# Archives every ORVION agent session verbatim, continuously, and keeps the searchable index current.
#   Claude Code: ~/.claude/projects/<ORVION project>/  (main transcript, subagents, tool-results) -> sessions\raw\claude\...
#   Codex:       ~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl whose cwd is in the ORVION workspace -> sessions\raw\codex\...
# Append-only and crash-safe: a transcript gains only complete lines (a line still being written waits for the next
# pass), and only after the archived bytes are proven to be a prefix of the source; a source that was rewritten keeps
# the old copy beside the new one. Nothing in the archive is ever deleted (Claude Code deletes its own transcripts
# after cleanupPeriodDays, default 30). A sync killed mid-append leaves a partial line that the next pass completes.
#   (default)  one pass, then the index
#   -Follow    a pass every -IntervalSeconds while any Claude Code or Codex process runs, the index every
#              -IndexMinutes, a final pass and index when they are all gone: no session depends on its shutdown hook
# Index (sessions\index.jsonl): one line per session, metadata + relative raw path only; never transcript text.
# secretHits / secretNames: credential-shaped strings (names only, values never printed); keep the archive out of Git
# and back it up only to an encrypted drive (Backup-Workspace.ps1 refuses otherwise).
param([string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quiet,[switch]$Follow,[int]$IntervalSeconds=60,[int]$IndexMinutes=15,[switch]$Library)  # -Library: dot-source for tests, defines the functions only
$ErrorActionPreference='Stop'
$raw=Join-Path $Root 'sessions\raw';$indexPath=Join-Path $Root 'sessions\index.jsonl'
$workspace='Documents[\\/-]+GitHub|ORVION'
# Bounded so random runs inside encoded blobs do not match (measured: every unbounded gh*_ hit was one).
$secret='(?<![\w-])(gh[pousr]_[A-Za-z0-9]{36}|github_pat_\w{40,}|sbp_[0-9a-f]{40}|sk-ant-[\w-]{30,})(?![\w-])|-----BEGIN [A-Z ]*PRIVATE KEY'
$jwt='(?<![\w-])eyJ[\w-]{10,}\.(eyJ[\w-]{20,})\.[\w-]{20,}(?![\w-])'
# NAME=value / "name":"value" credentials (an env dump printed CLAUDE_CODE_MESSAGING_TOKEN this way, 2026-10-19).
$assign='(?i)(?:(?<=\\[nrt])|(?<![A-Za-z0-9_\\]))([A-Z0-9_]*(?:TOKEN|SECRET|PASSWORD|PASSWD|API_?KEY|ACCESS_?KEY|PRIVATE_?KEY)[A-Z0-9_]*)\\?["'']?\s*[=:]\s*\\?["'']?(?![\$<{%(\\])([A-Za-z0-9_\-./+]{20,})'
# SHA-256 prefixes of the local Supabase stack's published defaults (JWT secret, S3 key id/secret, sb_secret): public, not secrets.
$publicDefaults='A064B502','B0F3A96D','7F59EDAF','C85DEBB5'
function Get-AssignedSecretName([string]$Line){
    foreach($m in [regex]::Matches($Line,$assign)){
        $v=$m.Groups[2].Value
        if($v-match'^(.)\1+$'-or$v-match'^[a-z_]+$'-or$v-match'\.[A-Za-z]'-or$v-match'^[A-Za-z]+(-[A-Za-z]+)+$'){continue}  # repeats, words, code (Some.Type, Verb-Noun)
        $h=[BitConverter]::ToString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($v))).Replace('-','').Substring(0,8)
        if($h-notin$publicDefaults){$m.Groups[1].Value.ToUpper()}  # a JSON escape (\n) never joins the name
    }
}
function Test-RealJwt([string]$Payload){  # the local stack's well-known keys (iss supabase-demo) are public
    $b=$Payload.Replace('-','+').Replace('_','/');$b+='='*((4-$b.Length%4)%4)
    try{([Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b))|ConvertFrom-Json).iss-ne'supabase-demo'}catch{$true}
}

function Open-Shared([string]$Path){[IO.File]::Open($Path,'Open','Read','ReadWrite,Delete')}  # live sessions hold their file open
function Test-Prefix([IO.Stream]$Source,[string]$Dst,[long]$Len){  # the last 4 KB already archived still match the source
    $n=[int][Math]::Min(4096,$Len);if(!$n){return $true}
    $a=New-Object byte[] $n;$b=New-Object byte[] $n
    $d=[IO.File]::Open($Dst,'Open','Read','ReadWrite');try{$d.Position=$Len-$n;$null=$d.Read($a,0,$n)}finally{$d.Close()}
    $Source.Position=$Len-$n;$got=0;while($got-lt$n){$r=$Source.Read($b,$got,$n-$got);if(!$r){return $false};$got+=$r}
    [Linq.Enumerable]::SequenceEqual($a,$b)
}
function Copy-Grown([string]$Src,[string]$Dst){
    $s=Get-Item -LiteralPath $Src;$lines=$Src.EndsWith('.jsonl')
    $have=if(Test-Path -LiteralPath $Dst){(Get-Item -LiteralPath $Dst).Length}else{-1}
    if($have-eq$s.Length){return $false}
    New-Item -ItemType Directory -Path (Split-Path $Dst -Parent) -Force|Out-Null
    $in=Open-Shared $Src
    try{
        $end=$in.Length
        if($lines){  # stop after the last complete line; the rest is still being written
            $look=[int][Math]::Min(1MB,$end);$buf=New-Object byte[] $look;$in.Position=$end-$look;$got=0
            while($got-lt$look){$r=$in.Read($buf,$got,$look-$got);if(!$r){break};$got+=$r}
            $nl=[Array]::LastIndexOf($buf,[byte]10,$got-1);$end=if($nl-ge0){$end-$look+$nl+1}elseif($look-lt1MB){0}else{$end}
        }
        if($have-ge0-and($have-gt$end-or!(Test-Prefix $in $Dst $have))){  # rewritten or shrunk: keep the old copy beside
            Move-Item -LiteralPath $Dst ($Dst-replace'(\.[^.\\]+)$',".replaced-$([DateTime]::UtcNow.ToString('yyyyMMddHHmmss'))`$1");$have=-1
        }
        $from=[Math]::Max(0,$have);if($end-le$from){return $false}
        $out=[IO.File]::Open($Dst,'OpenOrCreate','Write','Read')
        try{$out.Position=$from;$in.Position=$from;$left=$end-$from;$buf=New-Object byte[] 1MB
            while($left-gt0){$r=$in.Read($buf,0,[int][Math]::Min($buf.Length,$left));if(!$r){break};$out.Write($buf,0,$r);$left-=$r};$out.Flush($true)}
        finally{$out.Close()}
    }finally{$in.Close()}
    $true
}

# Index metadata is read incrementally: each row remembers metaBytes, and only the archived bytes after it are read.
function ConvertFrom-JsonText([string]$Text){  # a JSON string body as one readable line, at most 160 characters
    $t=try{[string](ConvertFrom-Json ('"'+$Text.TrimEnd('\')+'"'))}catch{$Text}
    (($t-replace'\s+',' ').Trim())-replace'^(.{160}).+$','$1...'
}
function Update-Meta($Row,[string]$Path,[string]$Client){
    $specs=$Row.specCounts;$names=@{};foreach($s in @($Row.secretNames)){if($s){$names[$s]=1}}
    $fs=Open-Shared $Path
    # Read only complete lines: a partial tail (a killed append) is read once the next pass completes it.
    $look=[int][Math]::Min(1MB,$fs.Length-$Row.metaBytes);$buf=New-Object byte[] $look;$fs.Position=$fs.Length-$look;$got=0
    while($got-lt$look){$cnt=$fs.Read($buf,$got,$look-$got);if(!$cnt){break};$got+=$cnt}
    $nl=if($got){[Array]::LastIndexOf($buf,[byte]10,$got-1)}else{-1};$limit=if($nl-ge0){$fs.Length-$look+$nl+1}else{[long]$Row.metaBytes}
    $fs.Position=[long]$Row.metaBytes;$sr=New-Object IO.StreamReader $fs
    try{while($Row.metaBytes-lt$limit-and$null-ne($l=$sr.ReadLine())){
        $Row.lines++;$Row.metaBytes+=[Text.Encoding]::UTF8.GetByteCount($l)+1
        $t=[regex]::Match($l,'"timestamp":"([^"]+)"');if($t.Success){if(!$Row.start){$Row.start=$t.Groups[1].Value};$Row.end=$t.Groups[1].Value}
        if(!$Row.cwd){$c=[regex]::Match($l,'"cwd":"([^"]+)"');if($c.Success){$Row.cwd=$c.Groups[1].Value-replace'\\\\','\'}}
        if(!$Row.branch){$b=[regex]::Match($l,'"gitBranch":"([^"]+)"');if($b.Success){$Row.branch=$b.Groups[1].Value}}
        $a=[regex]::Match($l,'"aiTitle":"((?:[^"\\]|\\.)+)"');if($a.Success){$Row.title=ConvertFrom-JsonText $a.Groups[1].Value}
        foreach($s in [regex]::Matches($l,'SPEC-\d{3}')){$specs[$s.Value]=1+$specs[$s.Value]}  # counted: the most discussed, not the highest, describe a session
        # What happened, without reading the transcript: the task, how much work, what failed, whether it was compacted.
        # Codex puts other keys between type and message/name (measured 2026-10-20), so match the payload type, then the field.
        $prompt=if($Client-eq'codex'){if($l.Contains('"payload":{"type":"user_message"')){[regex]::Match($l,'"message":"((?:[^"\\]|\\.){1,400})')}}
            elseif(!$l.Contains('"isMeta":true')){[regex]::Match($l,'"message":\{"role":"user","content":"(?!<(?:task-notification|local-command|command-))((?:[^"\\]|\\.){1,400})')}
        if($prompt-and$prompt.Success){$Row.prompts++;if(!$Row.firstPrompt){$Row.firstPrompt=ConvertFrom-JsonText $prompt.Groups[1].Value}}
        foreach($tm in [regex]::Matches($l,'"type":"tool_use","id":"[^"]+","name":"([^"]+)"')){$tool=$tm.Groups[1].Value;$Row.tools[$tool]=1+$Row.tools[$tool];$Row.toolCalls++}
        if($Client-eq'codex'-and$l-match'"payload":\{"type":"(?:custom_tool_call|function_call)"'){
            $nm=[regex]::Match($l,'"name":"([^"]+)"');$ns=[regex]::Match($l,'"namespace":"([^"]+)"')
            if($nm.Success){$tool=if($ns.Success){"$($ns.Groups[1].Value).$($nm.Groups[1].Value)"}else{$nm.Groups[1].Value};$Row.tools[$tool]=1+$Row.tools[$tool];$Row.toolCalls++}
        }
        $Row.errors+=[regex]::Matches($l,'"is_error":true').Count
        if($l.Contains('"subtype":"compact_boundary"')){$Row.compactions++}
        $hits=[regex]::Matches($l,$secret).Count+@([regex]::Matches($l,$jwt)|Where-Object{Test-RealJwt $_.Groups[1].Value}).Count
        $an=@(Get-AssignedSecretName $l);foreach($n in $an){$names[$n]=1}
        $Row.secretHits+=$hits+$an.Count
    }}finally{$sr.Close()}
    $Row.specCounts=$specs;$Row.specs=@($specs.GetEnumerator()|Sort-Object Value -Descending|Select-Object -First 8|ForEach-Object Key);$Row.secretNames=@($names.Keys|Sort-Object)
}

function Invoke-Pass{
    $script:copied=0;$list=@()
    foreach($p in Get-ChildItem "$env:USERPROFILE\.claude\projects" -Directory|Where-Object Name -match $workspace){
        foreach($f in Get-ChildItem $p.FullName -Recurse -File){
            if(Copy-Grown $f.FullName (Join-Path $raw "claude\$($p.Name)$($f.FullName.Substring($p.FullName.Length))")){$script:copied++}
        }
        foreach($f in Get-ChildItem $p.FullName -File -Filter *.jsonl){$list+=[pscustomobject]@{client='claude';id=$f.BaseName;dst=Join-Path $raw "claude\$($p.Name)\$($f.Name)";sub=Join-Path $p.FullName "$($f.BaseName)\subagents"}}
    }
    $codex="$env:USERPROFILE\.codex\sessions"
    if(Test-Path $codex){foreach($f in Get-ChildItem $codex -Recurse -File -Filter *.jsonl){
        $sr=New-Object IO.StreamReader (Open-Shared $f.FullName);try{$first=$sr.ReadLine()}finally{$sr.Close()}
        if($first-notmatch'"cwd":"[^"]*(Documents\\\\GitHub|ORVION)'){continue}
        $target=Join-Path $raw "codex$($f.FullName.Substring($codex.Length))"
        if(Copy-Grown $f.FullName $target){$script:copied++}
        $list+=[pscustomobject]@{client='codex';id=($f.BaseName-replace'^rollout-[\dT-]+?-(?=[0-9a-f]{8}-)','');dst=$target;sub=''}
    }}
    $script:sessions=$list
}

$schema=3  # bump when Update-Meta learns a field: every row is then re-read once from the start
function New-IndexRow([string]$Client,[string]$Id){
    [ordered]@{v=$schema;client=$Client;id=$Id;repo='';title='';firstPrompt='';cwd='';branch='';start='';end='';durationMin=0
        prompts=0;toolCalls=0;tools=@{};errors=0;compactions=0;subagents=0;subagentTasks=@();events=0;specs=@();specCounts=@{}
        secretHits=0;secretNames=@();bytes=0;lines=0;raw='';sha256='';metaBytes=0}
}
function Update-Index{
    $old=@{};if(Test-Path $indexPath){foreach($l in [IO.File]::ReadAllLines($indexPath)){if($l){$o=$l|ConvertFrom-Json -AsHashtable;$old["$($o.client)/$($o.id)"]=$o}}}
    $evCount=@{};$evLog=Join-Path $Root 'events\events.jsonl'
    if(Test-Path $evLog){foreach($l in [IO.File]::ReadAllLines($evLog)){$m=[regex]::Match($l,'"session":"([^"]+)"');if($m.Success){$evCount[$m.Groups[1].Value]=1+$evCount[$m.Groups[1].Value]}}}
    $rows=foreach($s in $script:sessions){
        if(!(Test-Path -LiteralPath $s.dst)){continue}
        $a=Get-Item -LiteralPath $s.dst;$r=$old["$($s.client)/$($s.id)"]
        if(!$r-or$r.v-ne$schema-or$r.metaBytes-gt$a.Length){  # new, older schema, or replaced: read from the start
            $r=New-IndexRow $s.client $s.id

        }
        if($r.metaBytes-lt$a.Length){Update-Meta $r $a.FullName $s.client}
        $idle=([DateTime]::UtcNow-$a.LastWriteTimeUtc).TotalMinutes-ge10
        if($r.bytes-ne$a.Length){$r.sha256=''};if($idle-and!$r.sha256){$r.sha256=(Get-FileHash -LiteralPath $a.FullName).Hash}  # a live session has no final hash yet
        $r.bytes=$a.Length;$r.raw=$a.FullName.Substring($Root.Length+1)
        $r.repo=if($r.cwd-match'\\GitHub\\([^\\]+)'){$Matches[1]}else{Split-Path $r.cwd -Leaf}
        if($r.start-and$r.end){$r.durationMin=[int]([datetime]$r.end-[datetime]$r.start).TotalMinutes}
        $sub=Join-Path (Split-Path $a.FullName) "$($s.id)\subagents"  # the archived copy: survives the source's 30-day deletion
        $metas=@(if($s.client-eq'claude'-and(Test-Path $sub)){Get-ChildItem $sub -Filter *.meta.json})
        $r.subagents=@(if(Test-Path $sub){Get-ChildItem $sub -Filter *.jsonl}).Count
        $r.subagentTasks=@($metas|ForEach-Object{try{(Get-Content $_.FullName -Raw|ConvertFrom-Json).description}catch{}}|Where-Object{$_}|Select-Object -First 12)
        $r.events=[int]$evCount[$s.id]
        [pscustomobject]$r
    }
    $rows=@($rows|Sort-Object start)
    $tmp="$indexPath.tmp";[IO.File]::WriteAllLines($tmp,[string[]]@($rows|ForEach-Object{$_|ConvertTo-Json -Compress -Depth 3}));Move-Item $tmp $indexPath -Force
    Write-IndexPage $rows
    $rows
}
function Write-IndexPage($IndexRows){  # sessions\INDEX.md: the same index as one readable table, newest first
    $md=[Collections.Generic.List[string]]::new()
    $md.Add('# ORVION session index (generated by lib\Sync-Sessions.ps1; do not edit)');$md.Add('')
    $md.Add("Updated $([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC. $($IndexRows.Count) sessions. Raw transcripts: ``sessions\raw\`` (search with Grep; never ``grep -o`` a wide window).")
    $md.Add('Machine-readable: `sessions\index.jsonl`. Events recorded in a session: `lib\Events.ps1 -Find <words>`.');$md.Add('')
    $md.Add('| Start (UTC) | Min | Repo | Client | Title / first task | Prompts | Tools | Errors | Compact | Agents | Events | SPECs | MB | Raw |')
    $md.Add('|---|---|---|---|---|---|---|---|---|---|---|---|---|---|')
    foreach($r in @($IndexRows|Sort-Object start -Descending)){
        $title=(@($r.title,$r.firstPrompt)|Where-Object{$_}|Select-Object -First 1)-replace'\|','/'
        $top=($r.tools.GetEnumerator()|Sort-Object Value -Descending|Select-Object -First 3|ForEach-Object{"$($_.Key) $($_.Value)"})-join', '
        $md.Add("| $(if($r.start){([datetime]$r.start).ToUniversalTime().ToString('yyyy-MM-dd HH:mm')}) | $($r.durationMin) | $($r.repo) | $($r.client) | $title | $($r.prompts) | $($r.toolCalls)$(if($top){" ($top)"}) | $($r.errors) | $($r.compactions) | $($r.subagents) | $($r.events) | $(@($r.specs|Select-Object -First 4)-join' ') | $([math]::Round($r.bytes/1MB,1)) | ``$($r.raw)`` |")
    }
    $p=Join-Path $Root 'sessions\INDEX.md';[IO.File]::WriteAllLines("$p.tmp",$md);Move-Item "$p.tmp" $p -Force
}

if($Library){return}
# Hooks of several sessions fire together and a follower may already run: one sync at a time, the others skip.
$lock=[Threading.Mutex]::new($false,'Local\orvion-sync-sessions')
$owned=try{$lock.WaitOne(0)}catch [Threading.AbandonedMutexException]{$true}  # a killed earlier sync still hands over the lock
if(!$owned){if(!$Quiet){'SESSIONS: another sync is running'};exit 0}
function Test-AgentsRunning{[bool](Get-Process -Name claude,codex -ErrorAction SilentlyContinue)}
if($Follow){
    $nextIndex=[DateTime]::MinValue;$gone=0
    while($true){
        try{Invoke-Pass;if([DateTime]::UtcNow-ge$nextIndex){$null=Update-Index;$nextIndex=[DateTime]::UtcNow.AddMinutes($IndexMinutes)}}
        catch{if(!$Quiet){"SESSIONS: pass failed: $($_.Exception.Message)"}}  # a locked or vanished file must not end the follower
        $gone=if(Test-AgentsRunning){0}else{$gone+1}
        if($gone-ge2){break}  # two quiet polls in a row: every session has ended
        Start-Sleep -Seconds $IntervalSeconds
    }
}
Invoke-Pass;$rows=Update-Index
if(!$Quiet){"SESSIONS: $($rows.Count) indexed, $copied files copied, $([math]::Round(($rows|Measure-Object bytes -Sum).Sum/1MB,1)) MB main transcripts, credential-shaped strings in $(@($rows|Where-Object secretHits).Count) sessions ($(@($rows.secretNames|Where-Object{$_}|Select-Object -Unique)-join', ')) -> $indexPath"}
