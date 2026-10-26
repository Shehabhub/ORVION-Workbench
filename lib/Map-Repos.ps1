# Interactive repository map v1: every Git repository under the GitHub folder, its committed files and the links between them.
#   pwsh -NoProfile -File Map-Repos.ps1                 rebuild <Workbench root>\ai-map.json and ai-map.html (~a minute)
#   pwsh -NoProfile -File Map-Repos.ps1 -Links <path>   one file's outgoing links and backlinks (repo:path or a unique tail)
#   pwsh -NoProfile -File Map-Repos.ps1 -Orphans        files nothing links to (entry documents excepted)
#   pwsh -NoProfile -File Map-Repos.ps1 -Install        refresh hourly and at logon (per-user scheduled task); -Uninstall removes it
# Repositories are discovered on every run, so a new clone joins the map by itself; *-trusted-main copies and the
# ORVION-Owner-Tools data store are skipped; an unborn or broken repository is listed under `problems`, never fatal.
# Only files COMMITTED at HEAD are read (never the working tree or index, never untracked or ignored files), and paths
# under sessions/ or events/ and *.jsonl are excluded; credentials in origin URLs are removed. Links (Obsidian-style,
# with backlinks): markdown links, repository paths named in text, cross-repository paths, globs, distinctive bare file
# names, SPEC-/WS- contract ids and ADR-NNNN sections. The outputs are git-ignored derived views, never authority.
param([string]$GitHub=(Split-Path (Split-Path $PSScriptRoot -Parent) -Parent),[string]$Out=(Split-Path $PSScriptRoot -Parent),
      [string]$Links,[switch]$Orphans,[switch]$Install,[switch]$Uninstall,[string[]]$Skip=@('*-trusted-main','ORVION-Owner-Tools','_*'))
$ErrorActionPreference='Stop'
$GitHub=[IO.Path]::GetFullPath($GitHub);$Out=[IO.Path]::GetFullPath($Out);$json=Join-Path $Out 'ai-map.json';$task='ORVION Repository Map'
if($Install){
    $skipArg=(@($Skip|ForEach-Object{"'"+$_.Replace("'","''")+"'"})-join',')
    $action=New-ScheduledTaskAction -Execute (Get-Command pwsh).Source -Argument "-NoProfile -WindowStyle Hidden -Command `"& '$PSCommandPath' -GitHub '$GitHub' -Out '$Out' -Skip $skipArg`""
    $triggers=@((New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME),(New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Hours 1)))
    Register-ScheduledTask -TaskName $task -Action $action -Trigger $triggers -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 10)) -Force|Out-Null
    "MAP TASK: '$task' refreshes $Out hourly and at logon";return
}
if($Uninstall){Unregister-ScheduledTask -TaskName $task -Confirm:$false -ErrorAction SilentlyContinue;"MAP TASK: removed";return}
if($Links-or$Orphans){
    if(!(Test-Path -LiteralPath $json)){throw "MAP_MISSING: run Map-Repos.ps1 first ($json)"}
    $map=Get-Content -LiteralPath $json -Raw|ConvertFrom-Json
    if($Orphans){"ORPHANS: $($map.orphans.Count) of $($map.stats.files) files";$map.orphans;return}
    $hit=@($map.files|Where-Object{$_.id-ceq$Links-or$_.id.EndsWith('/'+$Links.Replace('\','/'))-or$_.id.EndsWith(':'+$Links.Replace('\','/'))})
    if($hit.Count-ne1){throw "MAP_LINKS_TARGET_$(if($hit.Count){'AMBIGUOUS: '+(@($hit.id)-join', ')}else{'UNKNOWN'})"}
    $f=$hit[0];"FILE: $($f.id)$(if($f.title){" - $($f.title)"})";"OUT ($($f.out.Count)):";$f.out|ForEach-Object{"  -> $_"};"IN ($($f.in.Count)):";$f.in|ForEach-Object{"  <- $_"};return
}
function Read-Git([string]$Repo){$o=@(& git -C $Repo @args 2>$null);if($LASTEXITCODE){throw "MAP_GIT_FAILED $Repo git $($args[0])"};$o}
# Committed blob contents through one `git cat-file --batch`, in batches small enough that neither pipe can fill.
function Read-Blobs([string]$Repo,[string[]]$BlobIds){
    $result=@{};if(!$BlobIds.Count){return $result}
    $si=[Diagnostics.ProcessStartInfo]::new('git');foreach($a in '-C',$Repo,'cat-file','--batch'){$si.ArgumentList.Add($a)};$si.UseShellExecute=$false;$si.RedirectStandardInput=$true;$si.RedirectStandardOutput=$true;$si.CreateNoWindow=$true
    $p=[Diagnostics.Process]::Start($si);$rd=[IO.BinaryReader]::new($p.StandardOutput.BaseStream)
    try{for($i=0;$i-lt$BlobIds.Count;$i+=100){
        $batch=$BlobIds[$i..([Math]::Min($i+99,$BlobIds.Count-1))];$p.StandardInput.Write(($batch-join"`n")+"`n");$p.StandardInput.Flush()
        foreach($id in $batch){
            $hdr=[Collections.Generic.List[byte]]::new();while(($b=$rd.ReadByte())-ne10){$hdr.Add($b)}
            $parts=[Text.Encoding]::ASCII.GetString($hdr.ToArray())-split' ';$n=[int64]$parts[2]
            $result[$id]=[Text.Encoding]::UTF8.GetString($rd.ReadBytes([int]$n));[void]$rd.ReadByte()
        }
    }}finally{$p.StandardInput.Close();$p.WaitForExit();$p.Dispose()}
    $result
}
# Discovery: a direct child of the GitHub folder whose top-level is itself; problems are reported, never fatal.
$problems=[Collections.Generic.List[object]]::new()
$repos=@(foreach($d in Get-ChildItem -LiteralPath $GitHub -Directory){
    if(@($Skip|Where-Object{$d.Name-like$_}).Count-or!(Test-Path -LiteralPath (Join-Path $d.FullName '.git'))){continue}
    $top="$(& git -C $d.FullName rev-parse --show-toplevel 2>$null)"
    if($LASTEXITCODE-or!$top-or[IO.Path]::GetFullPath($top)-ne$d.FullName){$problems.Add([ordered]@{repo=$d.Name;problem='not a readable Git work tree'});continue}
    $head="$(& git -C $d.FullName rev-parse -q --verify HEAD)".Trim();if(!$head){$problems.Add([ordered]@{repo=$d.Name;problem='no commits yet'})}
    [pscustomobject]@{name=$d.Name;root=$d.FullName;head=$head;branch="$(& git -C $d.FullName symbolic-ref -q --short HEAD)".Trim()
        origin=("$(& git -C $d.FullName config --get remote.origin.url)".Trim()-replace'://[^/@\s]+@','://')}
})
$text='\.(md|ps1|psm1|psd1|json|ya?ml|sql|py|ts|tsx|js|mjs|toml|txt|cmd|sh|csv)$';$private='(^|/)(sessions|events)/|\.jsonl$'
$files=[ordered]@{};$byRepo=@{};$unscanned=[Collections.Generic.List[string]]::new();$bodies=@{}
foreach($r in $repos){
    $rows=@();if($r.head){$rows=@(& git -C $r.root -c core.quotepath=off ls-tree -r --long HEAD 2>$null);if($LASTEXITCODE){throw "MAP_GIT_FAILED $($r.root) ls-tree"}};$paths=@();$want=@{}
    foreach($row in $rows){
        if($row-notmatch'^\d+ blob ([0-9a-f]{40,64}) +(\d+)\t(.+)$'){continue};$blob=$Matches[1];$size=[int64]$Matches[2];$p=$Matches[3]
        if($p-match$private){continue};$paths+=$p
        $files["$($r.name):$p"]=[ordered]@{id="$($r.name):$p";repo=$r.name;path=$p;title='';sections=@();out=[Collections.Generic.HashSet[string]]::new();in=[Collections.Generic.HashSet[string]]::new()}
        if($p-match$text){if($size-le2MB){$want[$blob]=@(@($want[$blob])+@($p)|Where-Object{$_})}else{$unscanned.Add("$($r.name):$p (over 2 MB)")}}
    }
    $byRepo[$r.name]=$paths;$got=Read-Blobs $r.root @($want.Keys)
    foreach($k in $want.Keys){foreach($p in $want[$k]){$bodies["$($r.name):$p"]=$got[$k]}}
}
# Indexes: unique basename and distinctive stem per repository, contract ids per repository, ADR sections.
$base=@{};$stem=@{};$ids=@{}
foreach($r in $repos){foreach($p in $byRepo[$r.name]){
    $k="$($r.name)|$([IO.Path]::GetFileName($p).ToLowerInvariant())";$base[$k]=@(@($base[$k])+@($p)|Where-Object{$_})
    $s=[IO.Path]::GetFileNameWithoutExtension($p);if($s.Length-ge10){$k="$($r.name)|$s";$stem[$k]=@(@($stem[$k])+@($p)|Where-Object{$_})}
    if($p-match'^changes/((?:SPEC|WS)-\d+)-'){$k="$($r.name)|$($Matches[1])";$ids[$k]=@(@($ids[$k])+@($p)|Where-Object{$_})}
}}
$adr=@{};$edges=[Collections.Generic.List[object]]::new();$seen=[Collections.Generic.HashSet[string]]::new();$broad=[ordered]@{};$names=@($repos.name)
function Join-RepoPath([string]$Path){$parts=[Collections.Generic.List[string]]::new();foreach($s in $Path-split'/'){if($s-eq'..'){if(!$parts.Count){return $null};$parts.RemoveAt($parts.Count-1)}elseif($s-and$s-ne'.'){$parts.Add($s)}};$parts-join'/'}
function Resolve-Target([string]$Repo,[string]$From,[string]$Target){
    $t=($Target-split'#')[0].Trim().Replace('\','/').Trim('`','"',"'",'<','>');if(!$t-or$t-match'^[a-z]+://'-and$t-notmatch'^file://'){return}
    $t=$t-replace'^file:///?','';try{$t=[Uri]::UnescapeDataString($t)}catch{}
    foreach($n in $names){$i=$t.IndexOf("/GitHub/$n/",[StringComparison]::OrdinalIgnoreCase);if($i-ge0){return "$n|$($t.Substring($i+9+$n.Length))"}}
    $dir=[IO.Path]::GetDirectoryName($From.Replace('/','\')).Replace('\','/')
    # A leading / is the repository root; otherwise the file's own folder first, then the root.
    $tries=if($t.StartsWith('/')){@($t.TrimStart('/'))}else{@($(if($dir){"$dir/$t"}),$t)}
    foreach($c in $tries){if(!$c){continue};$j=Join-RepoPath $c;if($j-and$files.Contains("$Repo`:$j")){return "$Repo|$j"}}
    # Only a path that leaves its own repository names a sibling repository.
    $up=if($dir){"$dir/$t"}else{$t}
    $m=[regex]::Match($t,'^(?:\.\./)+([^/]+)/(.+)$');if($m.Success-and$names-ccontains$m.Groups[1].Value-and!(Join-RepoPath $up)){return "$($m.Groups[1].Value)|$($m.Groups[2].Value)"}
    if($t-notmatch'/'){$b=@($base["$Repo|$($t.ToLowerInvariant())"]|Where-Object{$_});if($b.Count-eq1){return "$Repo|$($b[0])"}}
}
function Add-Edge([string]$From,[string]$To,[string]$Kind,[string]$Anchor){
    if(!$files.Contains($To)-or$From-ceq$To-or!$seen.Add("$From>$To#$Anchor")){return}
    [void]$files[$From].out.Add($To);[void]$files[$To].in.Add($From);$edges.Add([ordered]@{from=$From;to=$To;kind=$Kind;anchor=$Anchor})
}
foreach($id in @($bodies.Keys)){
    $f=$files[$id];if($f.path-match'\.md$'){$h=@([regex]::Matches($bodies[$id],'(?m)^#{1,4} (.+?)\s*$')|ForEach-Object{$_.Groups[1].Value});$f.sections=$h;if($h.Count){$f.title=$h[0]}
        foreach($m in [regex]::Matches($bodies[$id],'(?m)^#{2,4} (ADR-\d{4})\b')){$adr["$($f.repo)|$($m.Groups[1].Value)"]=$id}}
}
$pathRx='(?:\]\(([^)\s]+)\))|(?:`([^`\s]+\.[A-Za-z0-9]{1,5})(?:#[^`]*)?`)|((?:[A-Za-z]:)?[\w.\-]*(?:[\\/][\w.\-]+)+\.(?:md|ps1|psd1|json|ya?ml|sql|py|ts|js|toml|cmd|sh))'
foreach($id in @($bodies.Keys)){
    $f=$files[$id];$body=$bodies[$id]
    foreach($m in [regex]::Matches($body,$pathRx)){
        $ref=@($m.Groups[1].Value,$m.Groups[2].Value,$m.Groups[3].Value)|Where-Object{$_}|Select-Object -First 1
        $hit=Resolve-Target $f.repo $f.path $ref;if($hit){$k,$p=$hit-split'\|',2;Add-Edge $id "$k`:$p" $(if($k-cne$f.repo){'cross-repo'}elseif($m.Groups[1].Success){'link'}else{'path'}) $(if($ref-match'#(.+)$'){$Matches[1]})}
    }
    # A pattern such as lib\test-*.ps1 links every committed file it matches (how a schedule reaches its suites).
    foreach($m in [regex]::Matches($body,'[\w.\-]+(?:[\\/][\w.\-*]+)*[\\/][\w.\-]*\*[\w.\-]*\.[A-Za-z0-9]{1,5}')){
        # ponytail: a pattern matching more than 30 files names a whole folder, not a reference; it is listed under stats.broadPatterns.
        $g=$m.Value.Replace('\','/');$hits=@($byRepo[$f.repo]|Where-Object{$_-like$g-or$_-like"*/$g"})
        if($hits.Count-le30){foreach($p in $hits){Add-Edge $id "$($f.repo):$p" 'glob' $m.Value}}else{$broad["$($f.repo):$g"]=$hits.Count}
    }
    foreach($m in [regex]::Matches($body,'[\w\-]{10,}')){$hits=@($stem["$($f.repo)|$($m.Value)"]|Where-Object{$_});if($hits.Count-eq1){Add-Edge $id "$($f.repo):$($hits[0])" 'name' $m.Value}}
    foreach($m in [regex]::Matches($body,'\b((?:SPEC|WS)-\d{2,4})\b')){foreach($p in @($ids["$($f.repo)|$($m.Groups[1].Value)"]|Where-Object{$_})){Add-Edge $id "$($f.repo):$p" 'contract' $m.Groups[1].Value}}
    foreach($m in [regex]::Matches($body,'\b(ADR-\d{4})\b')){$t=$adr["$($f.repo)|$($m.Groups[1].Value)"];if($t){Add-Edge $id $t 'adr' $m.Groups[1].Value}}
}
# Entry documents are roots, not orphans: agents arrive there first.
$entry='^(README|AGENTS|CLAUDE|GEMINI|RESUME|HANDOFF|WORKFLOW|LICENSE|SECURITY|CONTRIBUTING)\.md$|^\.|/\.|(^|/)(README|AGENTS)\.md$'
$list=@(foreach($f in $files.Values){[ordered]@{id=$f.id;repo=$f.repo;path=$f.path;title=$f.title;sections=@($f.sections);out=@($f.out|Sort-Object);in=@($f.in|Sort-Object)}})
$orph=@($list|Where-Object{$_.in.Count-eq0-and$_.path-notmatch$entry}|ForEach-Object{$_.id}|Sort-Object)
$map=[ordered]@{schema=1;generated=[DateTime]::UtcNow.ToString('o');tool='lib/Map-Repos.ps1';authority='derived view only; each repository owns its facts'
    repos=$repos;problems=$problems;stats=[ordered]@{repos=$repos.Count;files=$list.Count;edges=$edges.Count;orphans=$orph.Count;unscanned=@($unscanned);broadPatterns=$broad};orphans=$orph;files=$list;edges=$edges}
$data=$map|ConvertTo-Json -Depth 6 -Compress
$html=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'ai-map.template.html')).Replace('/*MAP_DATA*/null',$data.Replace('</','<\/'))
# Each run writes its own temporary files and moves them into place, so overlapping runs never share a partial file.
$run=[guid]::NewGuid().ToString('N')
foreach($pair in @(@($json,$data),@((Join-Path $Out 'ai-map.html'),$html))){$tmp="$($pair[0]).$run.tmp";[IO.File]::WriteAllText($tmp,$pair[1],[Text.UTF8Encoding]::new($false));[IO.File]::Move($tmp,$pair[0],$true)}
"MAP: $($repos.Count) repositories ($(@($repos.name)-join', ')), $($list.Count) files, $($edges.Count) links, $($orph.Count) orphans$(if($problems.Count){", $($problems.Count) problem(s)"})$(if($unscanned.Count){", $($unscanned.Count) unscanned"}) -> $json"
