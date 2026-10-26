# Archives every ORVION agent session verbatim, continuously, and keeps the searchable index current.
#   Claude Code: ~/.claude/projects/<CRM / ORVION project>/  (main transcript, subagents, tool-results, memory) -> sessions\raw\claude\...
#   Codex:       ~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl whose cwd is a CRM / ORVION folder -> sessions\raw\codex\...
# Never loses or invents bytes: a transcript (.jsonl, append-only) gains only complete lines, and only after the archived
# bytes are proven to match the whole source prefix; any other file is compared whole. A source
# that changed any other way keeps the old copy beside the new one (<name>.replaced-<UTC>[.ext]); nothing in the archive
# is ever deleted (Claude Code deletes its own transcripts after cleanupPeriodDays, default 30). A pass killed mid-append
# leaves a partial line that the next pass completes. A file that fails is logged to work\sync-errors.log and skipped;
# it never stops the others (Hunt.ps1 reports the log). Exit 3: any preservation/index failure, including earlier follow passes.
#   (default)  one pass, then the index
#   -Follow    a pass every -IntervalSeconds while any Claude Code or Codex process runs, the index every -IndexMinutes,
#              a final pass when none is left: no session depends on its shutdown hook
# Index (sessions\index.jsonl + INDEX.md): one line per session, metadata + relative raw path only; never transcript text.
# secretHits / secretNames: credential-shaped strings by kind (values never printed or stored); keep the archive out of
# Git and back it up only to an encrypted drive (Backup-Workspace.ps1 refuses otherwise).
param([string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quiet,[switch]$Follow,[int]$IntervalSeconds=60,[int]$IndexMinutes=15,[switch]$Library,
      [string]$ClaudeProjects=(Join-Path $env:USERPROFILE '.claude\projects'),[string]$CodexSessions=(Join-Path $env:USERPROFILE '.codex\sessions'))  # -Library: dot-source for tests, defines the functions only
$ErrorActionPreference='Stop'
$Root=[IO.Path]::GetFullPath($Root).TrimEnd('\')  # a trailing \ would cut the first character of every relative path
$raw=Join-Path $Root 'sessions\raw';$indexPath=Join-Path $Root 'sessions\index.jsonl';$errLog=Join-Path $Root 'work\sync-errors.log'
$workspace='GitHub-(CRM|ORVION)|ORVION'  # Claude project folders of the two repositories, their trusted clones and this workspace

# Credentials, by kind. A value may follow a JSON escape (\n), so "not after a word character" also accepts \n \r \t.
$edge='(?:(?<=\\[nrt])|(?<![\w-]))'
$secretKinds=[ordered]@{
    GITHUB_TOKEN="$edge(gh[pousr]_[A-Za-z0-9]{36}|github_pat_\w{40,})(?![\w-])"
    ANTHROPIC_KEY="$edge(sk-ant-[\w-]{30,})(?![\w-])"
    SUPABASE_PAT="$edge(sbp_[0-9a-f]{40})(?![\w-])"
    SUPABASE_SECRET="$edge(sb_secret_[\w-]{20,})(?![\w-])"
    PRIVATE_KEY='(-----BEGIN [A-Z ]*PRIVATE KEY)'
    CONNECTION_PASSWORD='(?i)\b(?:postgres(?:ql)?|mysql|mongodb(?:\+srv)?|redis|amqp)://[^:/\s"\\]+:([^@\s"\\]{3,})@'
    PASSWORD='(?i)(?:(?<=\\[nrt])|(?<![A-Za-z0-9_\\]))(?:password|passwd|pwd)\\?["'']?\s*[=:]\s*\\?["'']?(?![\$<{%(\\])([^\s"''\\,;]{8,})'
}
$jwt="$edge(eyJ[\w-]{10,}\.(eyJ[\w-]{20,})\.[\w-]{20,})(?![\w-])"
# NAME=value / "name":"value" credentials (an env dump printed CLAUDE_CODE_MESSAGING_TOKEN this way, 2026-10-19).
$assign='(?i)(?:(?<=\\[nrt])|(?<![A-Za-z0-9_\\]))([A-Z0-9_]*(?:TOKEN|SECRET|API_?KEY|ACCESS_?KEY|PRIVATE_?KEY)[A-Z0-9_]*)\\?["'']?\s*[=:]\s*\\?["'']?(?![\$<{%(\\])([A-Za-z0-9_\-./+]{20,})'
# SHA-256 prefixes of published local-development defaults (Supabase JWT secret, S3 key id / secret, sb_secret; the
# local Postgres password "postgres"): public, not secrets.
$publicDefaults='A064B502','B0F3A96D','7F59EDAF','C85DEBB5','A942B37C'  # computed, never typed from memory
function Get-ShortHash([string]$Value){[BitConverter]::ToString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($Value))).Replace('-','').Substring(0,8)}
function Test-RealJwt([string]$Payload){  # the local stack's well-known keys (iss supabase-demo) are public
    $b=$Payload.Replace('-','+').Replace('_','/');$b+='='*((4-$b.Length%4)%4)
    try{([Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b))|ConvertFrom-Json).iss-ne'supabase-demo'}catch{$true}
}
function Test-CodeLike([string]$Value){$Value-match'^(.)\1+$'-or$Value-match'^[a-z_]+$'-or$Value-match'\.[A-Za-z]'-or$Value-match'^[A-Za-z]+(-[A-Za-z]+)+$'}  # repeats, words, code (Some.Type, Verb-Noun)
# Every credential in a line as {kind; value}; the value is only ever used to mask or hash, never stored or printed.
function Get-SecretMatch([string]$Line){
    foreach($k in $secretKinds.Keys){foreach($m in [regex]::Matches($Line,$secretKinds[$k])){
        # a password that is a plain word (password, changeme) is exactly the risk, so only code shapes are skipped here
        $v=$m.Groups[1].Value;if($k-in'PASSWORD','CONNECTION_PASSWORD'-and($v-match'^(.)\1+$'-or$v-match'\.[A-Za-z]'-or$v-match'^[A-Za-z]+(-[A-Za-z]+)+$')){continue}
        if((Get-ShortHash $v)-notin$publicDefaults){[pscustomobject]@{kind=$k;value=$v}}}}
    foreach($m in [regex]::Matches($Line,$jwt)){if(Test-RealJwt $m.Groups[2].Value){[pscustomobject]@{kind='JWT';value=$m.Groups[1].Value}}}
    foreach($m in [regex]::Matches($Line,$assign)){$v=$m.Groups[2].Value
        if(!(Test-CodeLike $v)-and(Get-ShortHash $v)-notin$publicDefaults){[pscustomobject]@{kind=$m.Groups[1].Value.ToUpper();value=$v}}}
}
function Hide-Secret([string]$Line){  # the whole line masked; cut a snippet only after this, or a token at its edge leaks
    foreach($s in @(Get-SecretMatch $Line|Sort-Object {$_.value.Length} -Descending)){$Line=$Line.Replace($s.value,'<masked>')};$Line
}

function Open-Shared([string]$Path){[IO.File]::Open($Path,'Open','Read','ReadWrite,Delete')}  # live sessions hold their file open
function Test-Prefix([IO.Stream]$Source,[string]$Dst,[long]$Len){
    if($Source.Length-lt$Len){return $false};if(!$Len){return $true}
    $d=[IO.File]::Open($Dst,'Open','Read','ReadWrite')
    try{$Source.Position=0;$left=$Len
        while($left-gt0){
        $n=[int][Math]::Min(1MB,$left);$a=New-Object byte[] $n;$b=New-Object byte[] $n
        $got=0;while($got-lt$n){$r=$d.Read($a,$got,$n-$got);if(!$r){return $false};$got+=$r}
        $got=0;while($got-lt$n){$r=$Source.Read($b,$got,$n-$got);if(!$r){return $false};$got+=$r}
        if(![Linq.Enumerable]::SequenceEqual($a,$b)){return $false}
        $left-=$n
    }}finally{$d.Close()}
    $true
}
function Find-LineEnd([IO.Stream]$Stream,[long]$Upto,[long]$Floor=0){  # the offset just after the last \n before $Upto (or $Floor)
    $pos=$Upto;$buf=New-Object byte[] 1MB
    while($pos-gt$Floor){
        $n=[int][Math]::Min($buf.Length,$pos-$Floor);$Stream.Position=$pos-$n;$got=0
        while($got-lt$n){$r=$Stream.Read($buf,$got,$n-$got);if(!$r){break};$got+=$r}
        $i=[Array]::LastIndexOf($buf,[byte]10,$got-1);if($i-ge0){return $pos-$n+$i+1}
        $pos-=$n
    }
    $Floor
}
function Get-AsideName([string]$Path){  # beside the original, before its extension when it has one
    $stamp="replaced-$([DateTime]::UtcNow.ToString('yyyyMMddHHmmssfff'))";$ext=[IO.Path]::GetExtension($Path)
    if($ext){$Path.Substring(0,$Path.Length-$ext.Length)+".$stamp$ext"}else{"$Path.$stamp"}
}
function Copy-Grown([string]$Src,[string]$Dst){
    $s=Get-Item -LiteralPath $Src;$lines=$Src.EndsWith('.jsonl')
    $d=if(Test-Path -LiteralPath $Dst){Get-Item -LiteralPath $Dst}else{$null}
    if($d-and$d.Length-eq$s.Length-and$s.LastWriteTimeUtc-le$d.LastWriteTimeUtc){return $false}  # unchanged since the last copy
    New-Item -ItemType Directory -Path (Split-Path $Dst -Parent) -Force|Out-Null
    $in=Open-Shared $Src
    try{
        $have=if($d){$d.Length}else{-1}
        if($lines){  # a transcript grows: same history only if every archived byte still matches
            $same=$have-lt0-or(Test-Prefix $in $Dst $have)
            $end=Find-LineEnd $in $in.Length $(if($same){[Math]::Max(0,$have)}else{0})  # a line still being written waits
        }else{  # an edited file (memory, meta): unchanged only if every byte is the same
            $end=$in.Length;$same=$have-lt0
            if($d){$in.Position=0;$sh=[Security.Cryptography.SHA256]::HashData($in);$dh=[Security.Cryptography.SHA256]::HashData([IO.File]::ReadAllBytes($Dst))
                if([Linq.Enumerable]::SequenceEqual($sh,$dh)){[IO.File]::SetLastWriteTimeUtc($Dst,$s.LastWriteTimeUtc);return $false}}
        }
        if($have-ge0-and!$same){Move-Item -LiteralPath $Dst (Get-AsideName $Dst);$have=-1}  # changed other than by growth: keep the old copy beside
        $from=[Math]::Max(0,$have);if($end-le$from){return $false}
        $out=[IO.File]::Open($Dst,'OpenOrCreate','Write','Read')
        try{$out.SetLength($from);$out.Position=$from;$in.Position=$from;$left=$end-$from;$buf=New-Object byte[] 1MB
            while($left-gt0){$r=$in.Read($buf,0,[int][Math]::Min($buf.Length,$left));if(!$r){break};$out.Write($buf,0,$r);$left-=$r};$out.Flush($true)}
        finally{$out.Close()}
        if(!$lines){[IO.File]::SetLastWriteTimeUtc($Dst,$s.LastWriteTimeUtc)}
    }finally{$in.Close()}
    $true
}
function Write-SyncError([string]$What,$Err){
    try{New-Item -ItemType Directory (Split-Path $errLog -Parent) -Force|Out-Null
        [IO.File]::AppendAllText($errLog,"$([DateTime]::UtcNow.ToString('o')) $What : $($Err.Exception.Message)`n")}catch{$null=$_}
    $script:failures++
    [Console]::Error.WriteLine("SESSIONS: preservation FAILED; see $errLog")
}

# Index metadata is read incrementally and byte-exactly: each row remembers metaBytes (where its reading stopped) and
# headHash (the first 4 KB it read); only complete lines after metaBytes are read, and a changed head restarts the row.
function ConvertFrom-JsonText([string]$Text){  # a JSON string body as one readable line, at most 160 characters
    $t=try{[string](ConvertFrom-Json ('"'+$Text.TrimEnd('\')+'"'))}catch{$Text}
    (($t-replace'\s+',' ').Trim())-replace'^(.{160}).+$','$1...'
}
function Get-HeadHash([string]$Path){$fs=Open-Shared $Path;try{$n=[int][Math]::Min(4096,$fs.Length);$b=New-Object byte[] $n;$null=$fs.Read($b,0,$n);[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($b))}finally{$fs.Close()}}
function Read-MetaLine($Row,[string]$l,[string]$Client,$SpecCount,$SecretKind){
    $Row.lines++
    $t=[regex]::Match($l,'"timestamp":"([^"]+)"');if($t.Success){if(!$Row.start){$Row.start=$t.Groups[1].Value};$Row.end=$t.Groups[1].Value}
    if(!$Row.cwd){$c=[regex]::Match($l,'"cwd":"([^"]+)"');if($c.Success){$Row.cwd=$c.Groups[1].Value-replace'\\\\','\'}}
    if(!$Row.branch){$b=[regex]::Match($l,'"gitBranch":"([^"]+)"');if($b.Success){$Row.branch=$b.Groups[1].Value}}
    $a=[regex]::Match($l,'"aiTitle":"((?:[^"\\]|\\.)+)"');if($a.Success){$Row.title=ConvertFrom-JsonText $a.Groups[1].Value}
    foreach($s in [regex]::Matches($l,'SPEC-\d{3}')){$SpecCount[$s.Value]=1+$SpecCount[$s.Value]}  # counted: the most discussed, not the highest, describe a session
    # What happened, without reading the transcript: the task, how much work, what failed, whether it was compacted.
    # Codex puts other keys between type and message/name (measured 2026-10-20), so match the payload type, then the field.
    $prompt=if($Client-eq'codex'){if($l.Contains('"payload":{"type":"user_message"')){[regex]::Match($l,'"message":"((?:[^"\\]|\\.){1,400})')}}
        elseif(!$l.Contains('"isMeta":true')){[regex]::Match($l,'"message":\{"role":"user","content":"(?!<(?:task-notification|local-command|command-))((?:[^"\\]|\\.){1,400})')}
    if($prompt-and$prompt.Success){$Row.prompts++;$Row.lastPrompt=ConvertFrom-JsonText (Hide-Secret $prompt.Groups[1].Value);if(!$Row.firstPrompt){$Row.firstPrompt=$Row.lastPrompt}}  # first = the task, last = where it stopped
    foreach($tm in [regex]::Matches($l,'"type":"tool_use","id":"[^"]+","name":"([^"]+)"')){$tool=$tm.Groups[1].Value;$Row.tools[$tool]=1+$Row.tools[$tool];$Row.toolCalls++}
    if($Client-eq'codex'-and$l-match'"payload":\{"type":"(?:custom_tool_call|function_call)"'){
        $nm=[regex]::Match($l,'"name":"([^"]+)"');$ns=[regex]::Match($l,'"namespace":"([^"]+)"')
        if($nm.Success){$tool=if($ns.Success){"$($ns.Groups[1].Value).$($nm.Groups[1].Value)"}else{$nm.Groups[1].Value};$Row.tools[$tool]=1+$Row.tools[$tool];$Row.toolCalls++}
    }
    $Row.errors+=[regex]::Matches($l,'"is_error":true').Count
    if($l.Contains('"subtype":"compact_boundary"')){$Row.compactions++}
    foreach($s in @(Get-SecretMatch $l)){$SecretKind[$s.kind]=1;$Row.secretHits++}
}
function Update-Meta($Row,[string]$Path,[string]$Client){
    $specs=$Row.specCounts;$names=@{};foreach($s in @($Row.secretNames)){if($s){$names[$s]=1}}
    $fs=Open-Shared $Path
    try{
        $limit=Find-LineEnd $fs $fs.Length ([long]$Row.metaBytes)  # complete lines only: a partial tail is read once completed
        $pos=[long]$Row.metaBytes;$buf=New-Object byte[] 4MB;$carry=[IO.MemoryStream]::new()
        while($pos-lt$limit){
            $fs.Position=$pos;$n=[int][Math]::Min($buf.Length,$limit-$pos);$got=0
            while($got-lt$n){$r=$fs.Read($buf,$got,$n-$got);if(!$r){break};$got+=$r}
            $start=0
            for($i=[Array]::IndexOf($buf,[byte]10,0,$got);$i-ge0;$i=[Array]::IndexOf($buf,[byte]10,$start,$got-$start)){
                $carry.Write($buf,$start,$i-$start);$bytes=$carry.ToArray();$carry.SetLength(0)
                $Row.metaBytes+=$bytes.Length+1  # byte-exact: CRLF and multi-byte characters are counted as they are on disk
                Read-MetaLine $Row ([Text.Encoding]::UTF8.GetString($bytes).TrimEnd("`r")) $Client $specs $names
                $start=$i+1;if($start-ge$got){break}
            }
            if($start-lt$got){$carry.Write($buf,$start,$got-$start)}
            $pos+=$got
        }
    }finally{$fs.Close()}
    $Row.specCounts=$specs;$Row.specs=@($specs.GetEnumerator()|Sort-Object Value -Descending|Select-Object -First 8|ForEach-Object Key);$Row.secretNames=@($names.Keys|Sort-Object)
}

function Invoke-Pass{
    $script:copied=0
    if(Test-Path $ClaudeProjects){foreach($p in Get-ChildItem $ClaudeProjects -Directory|Where-Object Name -match $workspace){
        foreach($f in Get-ChildItem $p.FullName -Recurse -File){
            try{if(Copy-Grown $f.FullName (Join-Path $raw "claude\$($p.Name)$($f.FullName.Substring($p.FullName.Length))")){$script:copied++}}catch{Write-SyncError $f.FullName $_}
        }
    }}
    if(Test-Path $CodexSessions){foreach($f in Get-ChildItem $CodexSessions -Recurse -File -Filter *.jsonl){
        try{
            $sr=New-Object IO.StreamReader (Open-Shared $f.FullName);try{$first=$sr.ReadLine()}finally{$sr.Close()}
            if($first-notmatch'"cwd":"[^"]*(Documents\\\\GitHub\\\\(CRM|ORVION)|ORVION)'){continue}
            if(Copy-Grown $f.FullName (Join-Path $raw "codex$($f.FullName.Substring($CodexSessions.Length))")){$script:copied++}
        }catch{Write-SyncError $f.FullName $_}
    }}
    # The index lists what the ARCHIVE holds, never the sources: Claude Code deletes a source after 30 days, and the
    # session must stay findable. Copies set aside (.replaced-<UTC>, older .<UTC>) are not separate sessions.
    $aside='\.(replaced-)?\d{14,17}$'
    $script:sessions=@(
        if(Test-Path "$raw\claude"){foreach($p in Get-ChildItem "$raw\claude" -Directory){foreach($f in Get-ChildItem $p.FullName -File -Filter *.jsonl|Where-Object{$_.BaseName-notmatch$aside}){
            [pscustomobject]@{client='claude';id=$f.BaseName;dst=$f.FullName}}}}
        if(Test-Path "$raw\codex"){foreach($f in Get-ChildItem "$raw\codex" -Recurse -File -Filter *.jsonl|Where-Object{$_.BaseName-notmatch$aside}){
            [pscustomobject]@{client='codex';id=($f.BaseName-replace'^rollout-[\dT-]+?-(?=[0-9a-f]{8}-)','');dst=$f.FullName}}}
    )
}

$schema=5  # bump when Update-Meta learns a field: every row is then re-read once from the start
function New-IndexRow([string]$Client,[string]$Id){
    [ordered]@{v=$schema;client=$Client;id=$Id;repo='';title='';firstPrompt='';lastPrompt='';cwd='';branch='';start='';end='';durationMin=0
        prompts=0;toolCalls=0;tools=@{};errors=0;compactions=0;subagents=0;subagentTasks=@();events=0;specs=@();specCounts=@{}
        secretHits=0;secretNames=@();bytes=0;lines=0;raw='';sha256='';metaBytes=0;headHash=''}
}
function Update-Index{
    $old=@{};if(Test-Path $indexPath){foreach($l in [IO.File]::ReadAllLines($indexPath)){if($l){try{$o=$l|ConvertFrom-Json -AsHashtable;$old["$($o.client)/$($o.id)"]=$o}catch{Write-SyncError 'index.jsonl line' $_}}}}
    $evCount=@{};$evLog=Join-Path $Root 'events\events.jsonl'
    if(Test-Path $evLog){foreach($l in [IO.File]::ReadAllLines($evLog)){$m=[regex]::Match($l,'"session":"([^"]+)"');if($m.Success){$evCount[$m.Groups[1].Value]=1+$evCount[$m.Groups[1].Value]}}}
    $rows=foreach($s in $script:sessions){
        if(!(Test-Path -LiteralPath $s.dst)){continue}
        $prev=$old["$($s.client)/$($s.id)"]
        try{
            $a=Get-Item -LiteralPath $s.dst;$r=$prev;$head=Get-HeadHash $a.FullName
            if(!$r-or$r.v-ne$schema-or$r.metaBytes-gt$a.Length-or$r.headHash-ne$head){$r=New-IndexRow $s.client $s.id;$r.headHash=$head}  # new, older schema, or the file was replaced
            if($r.metaBytes-lt$a.Length){Update-Meta $r $a.FullName $s.client}
            $idle=([DateTime]::UtcNow-$a.LastWriteTimeUtc).TotalMinutes-ge10
            if($r.bytes-ne$a.Length){$r.sha256=''};if($idle-and!$r.sha256){$r.sha256=(Get-FileHash -LiteralPath $a.FullName).Hash}  # a live session has no final hash yet
            $r.bytes=$a.Length;$r.raw=$a.FullName.Substring($Root.Length+1)
            $r.repo=if($r.cwd-match'\\GitHub\\([^\\]+)'){$Matches[1]}elseif($r.cwd){Split-Path $r.cwd -Leaf}else{''}
            if($r.start-and$r.end){$r.durationMin=[int]([datetime]$r.end-[datetime]$r.start).TotalMinutes}
            $sub=Join-Path (Split-Path $a.FullName) "$($s.id)\subagents"  # the archived copy: survives the source's 30-day deletion
            $metas=@(if($s.client-eq'claude'-and(Test-Path $sub)){Get-ChildItem $sub -Filter *.meta.json})
            $r.subagents=@(if(Test-Path $sub){Get-ChildItem $sub -Filter *.jsonl}).Count
            $r.subagentTasks=@($metas|ForEach-Object{try{(Get-Content $_.FullName -Raw|ConvertFrom-Json).description}catch{"(unreadable $($_.TargetObject))"}}|Where-Object{$_}|Select-Object -First 12)  # an unreadable meta is shown, not skipped
            $r.events=[int]$evCount[$s.id]
            [pscustomobject]$r
        }catch{Write-SyncError $s.dst $_;if($prev){[pscustomobject]$prev}}  # keep the last good row rather than lose the session
    }
    $rows=@($rows|Sort-Object start)
    $tmp="$indexPath.tmp";[IO.File]::WriteAllLines($tmp,[string[]]@($rows|ForEach-Object{$_|ConvertTo-Json -Compress -Depth 3}));Move-Item $tmp $indexPath -Force
    Write-IndexPage $rows
    $rows
}
function Write-IndexPage($IndexRows){  # sessions\INDEX.md: the same index as one readable table, newest first
    $md=[Collections.Generic.List[string]]::new()
    $md.Add('# ORVION session index (generated by lib\Sync-Sessions.ps1; do not edit)');$md.Add('')
    $md.Add("Updated $([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC. $($IndexRows.Count) sessions. Raw transcripts: ``sessions\raw\`` (search with ``lib\Spider.ps1``).")
    $md.Add('Machine-readable: `sessions\index.jsonl`. Events recorded in a session: `lib\Events.ps1 -Find <words>`.');$md.Add('')
    $md.Add('| Start (UTC) | Min | Repo | Client | Title / first task | Prompts | Tools | Errors | Compact | Agents | Events | SPECs | MB | Raw |')
    $md.Add('|---|---|---|---|---|---|---|---|---|---|---|---|---|---|')
    foreach($r in @($IndexRows|Sort-Object start -Descending)){
        $title=(@($r.title,$r.firstPrompt)|Where-Object{$_}|Select-Object -First 1)-replace'\|','/'
        $top=(@($r.tools.GetEnumerator())|Sort-Object Value -Descending|Select-Object -First 3|ForEach-Object{"$($_.Key) $($_.Value)"})-join', '
        $when=if($r.start){try{([datetime]$r.start).ToUniversalTime().ToString('yyyy-MM-dd HH:mm')}catch{"$($r.start)"}}else{''}
        $md.Add("| $when | $($r.durationMin) | $($r.repo) | $($r.client) | $title | $($r.prompts) | $($r.toolCalls)$(if($top){" ($top)"}) | $($r.errors) | $($r.compactions) | $($r.subagents) | $($r.events) | $(@($r.specs|Select-Object -First 4)-join' ') | $([math]::Round($r.bytes/1MB,1)) | ``$($r.raw)`` |")
    }
    $p=Join-Path $Root 'sessions\INDEX.md';[IO.File]::WriteAllLines("$p.tmp",$md);Move-Item "$p.tmp" $p -Force
}

if($Library){return}
# Hooks of several sessions fire together and a follower may already run: one sync at a time, the others skip.
$lock=[Threading.Mutex]::new($false,'Local\orvion-sync-sessions')
$owned=try{$lock.WaitOne(0)}catch [Threading.AbandonedMutexException]{$true}  # a killed earlier sync still hands over the lock
if(!$owned){if(!$Quiet){'SESSIONS: another sync is running'};exit 0}
$script:failures=0
function Test-AgentsRunning{[bool](Get-Process -Name claude,codex -ErrorAction SilentlyContinue)}
if($Follow){
    $nextIndex=[DateTime]::MinValue;$gone=0
    while($true){
        try{Invoke-Pass;if([DateTime]::UtcNow-ge$nextIndex){$null=Update-Index;$nextIndex=[DateTime]::UtcNow.AddMinutes($IndexMinutes)}}
        catch{Write-SyncError 'pass' $_}  # logged, never silent; the follower keeps going
        $gone=if(Test-AgentsRunning){0}else{$gone+1}
        if($gone-ge2){  # two quiet polls: a last pass, and stop only if no session started meanwhile
            try{Invoke-Pass;$null=Update-Index}catch{Write-SyncError 'final pass' $_}
            if(!(Test-AgentsRunning)){break};$gone=0
        }
        Start-Sleep -Seconds $IntervalSeconds
    }
    exit $(if($script:failures){3}else{0})
}
try{Invoke-Pass;$rows=Update-Index}catch{Write-SyncError 'pass' $_}
if(!$Quiet){"SESSIONS: $($rows.Count) indexed, $copied files copied, $([math]::Round(($rows|Measure-Object bytes -Sum).Sum/1MB,1)) MB main transcripts, credentials in $(@($rows|Where-Object secretHits).Count) sessions ($(@($rows.secretNames|Where-Object{$_}|Select-Object -Unique)-join', '))$(if($script:failures){"; $($script:failures) file(s) FAILED, see $errLog"}) -> $indexPath"}
exit $(if($script:failures){3}else{0})
