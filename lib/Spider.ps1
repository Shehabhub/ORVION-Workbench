# The ORVION spider: one question across everything the workspace knows, ranked, with a pointer to each original.
#   pwsh -NoProfile -File Spider.ps1 'SPEC-291'          an entity: SPEC id, error code, script, SHA, pattern id
#   pwsh -NoProfile -File Spider.ps1 'watcher ETA' -Top 3 a phrase (case-insensitive, exact words in order)
# Sources, crawled live at question time (no stale index), each hit under its source label (repo, data, temporary):
#   data       archived transcripts (sessions\raw, main + subagents), joined with sessions\index.jsonl for task and date;
#              events\events.jsonl through Events.ps1 -Find; every other text file of the data root, and its names
#   repo       tracked files of each repository (git grep) and its commit messages (git log --grep)
#   temporary  bounded: every name, the text of sb, scratch and each README.md; never a Git checkout, a link, a folder
#              named sandbox, a binary or a file over 2 MB (the first version read 11,238 copies of repository files in 149 s)
# A Markdown hit in the top files prints path:line section N, the nearest ## heading above it; other files, path and count.
# Rules (its robots.txt): credential values are masked in every snippet; a failing git read refuses, never reads as
# "no match"; a missing source says UNAVAILABLE and exits 3, never zero hits; .git and raw sandboxes are never crawled. Read-only.
param([Parameter(Mandatory,Position=0)][string]$Query,[int]$Top=5,
      [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) 'data'}),
      [string[]]$Repos,
      [string]$GitHub=(Split-Path (Split-Path $PSScriptRoot -Parent) -Parent),
      [string]$Temporary=(Join-Path $GitHub 'ORVION-Workbench-temporary'))
$ErrorActionPreference='Stop'
if(!$PSBoundParameters.ContainsKey('Root')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $Root 'events') -PathType Container)){'SPIDER_UNAVAILABLE: ORVION_DATA_ROOT_UNAVAILABLE';exit 3}
. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $Root  # the archive's secret rules mask snippets the same way
. (Join-Path $PSScriptRoot 'workspace-layout.ps1')
. (Join-Path $PSScriptRoot 'Test-MarkdownConsistency.ps1') $Root  # Get-MarkdownPlain: its checks run only when called
# The three ORVION repositories are always expected: one missing or not Git is a coverage gap, never silently dropped.
if(!$PSBoundParameters.ContainsKey('Repos')){$Repos=@(@('CRM','ORVION','ORVION-Workbench'|ForEach-Object{Join-Path $GitHub $_})+@(Get-OrvionRepositoryCandidates -GitHub $GitHub|ForEach-Object root)|Select-Object -Unique)}
$cmp=[StringComparison]::OrdinalIgnoreCase
function Get-Snippet([string]$Line){  # one readable line around the first match, credential values masked
    # mask the whole line first: masking after the cut leaked the part of a token that fell inside the snippet
    $Line=Hide-Secret $Line
    $at=[Math]::Max(0,$Line.IndexOf($Query,$cmp)-70);$s=$Line.Substring($at,[Math]::Min(220,$Line.Length-$at))
    (($s-replace'\\[nrt]',' '-replace'\\"','"'-replace'\\\\','\'-replace'\s+',' ').Trim())
}
function Invoke-RepoGit([string]$Repo){$o=& git -C $Repo @args 2>&1;if($LASTEXITCODE-gt1){throw (Hide-Secret "SPIDER_GIT_FAILED $Repo git $($args-join' '): $o")};@($o|Where-Object{$_-is[string]})}
# One file's text, open to its writers; an unreadable file is a named gap, never "no match".
function Read-SpiderText([string]$Path,[string]$Source){
    try{$sr=New-Object IO.StreamReader ([IO.File]::Open($Path,'Open','Read','ReadWrite,Delete'));try{$sr.ReadToEnd()}finally{$sr.Close()}}
    catch{$gaps.Add("$Source (unreadable $Path)")}
}
# path:line section N: the nearest ## heading above the hit, outside a code fence: its ID, else its title; - before the first.
function Get-MarkdownHits([string]$Source,[string]$Shown,[string]$Text){
    $lines=($Text-replace"`r`n","`n").Split("`n");$plain=(Get-MarkdownPlain $Text).Split("`n");$section='-';$hits=0
    for($i=0;$i-lt$lines.Count;$i++){
        if($plain[$i]-match'^#{2,6}\s+(\S.*?)\s*$'){
            $title=Hide-Secret $Matches[1]
            $section=if($title-match'^(\d+(?:\.\d+)*)\.?(?:\s|$)|^([A-Z]+-\d+)\b'){"$($Matches[1])$($Matches[2])"}else{$title.Substring(0,[Math]::Min(40,$title.Length))}
        }
        if($lines[$i].IndexOf($Query,$cmp)-ge0){$hits++;if($hits-le3){"  $Source $Shown`:$($i+1) section $section`: $(Get-Snippet $lines[$i])"}}
    }
    # ponytail: three lines a file keep the answer small; the count says how many more, and a grep of the file shows them.
    if($hits-gt3){"  $Source $Shown`: +$($hits-3) more"}
}
# A folder's names and bounded text, walked live. A Git checkout or a link is one name, never entered.
function Search-SpiderFolder([string]$Source,[string]$Folder,[scriptblock]$Bounded){
    if(!(Test-Path -LiteralPath $Folder -PathType Container)){"== $Source`: UNAVAILABLE (no folder at $Folder)";$gaps.Add("$Source (no folder at $Folder)");return}
    $named=[Collections.Generic.List[string]]::new();$found=[Collections.Generic.List[object]]::new();$over=0
    $walk=[Collections.Generic.Stack[string]]::new();$walk.Push($Folder)
    while($walk.Count){
        $here=$walk.Pop()
        try{$entries=@([IO.DirectoryInfo]::new($here).EnumerateFileSystemInfos())}catch{$gaps.Add("$Source (unreadable $here)");continue}
        foreach($entry in $entries){
            if($entry.Name-ceq'.git'){continue}
            $isFolder=$entry-is[IO.DirectoryInfo];$link=[bool]($entry.Attributes-band[IO.FileAttributes]::ReparsePoint)
            if($isFolder-and!$link-and!(Test-Path -LiteralPath (Join-Path $entry.FullName '.git'))){$walk.Push($entry.FullName);continue}
            $path=[IO.Path]::GetRelativePath($Folder,$entry.FullName).Replace('\','/')+$(if($isFolder){'/'})
            if($path.IndexOf($Query,$cmp)-ge0){$named.Add($path)}
            if($isFolder-or$link-or$path-notmatch'\.(md|txt|tsv|csv|log|json|jsonl|ps1)$'-or!(& $Bounded $path)){continue}
            if($entry.Length-gt2MB){$over++;continue}
            $text=Read-SpiderText $entry.FullName $Source
            if($text-and$text.IndexOf($Query,$cmp)-ge0){$found.Add([pscustomobject]@{path=$path;hits=@($text.Split("`n")|Where-Object{$_.IndexOf($Query,$cmp)-ge0}).Count;full=$entry.FullName})}
        }
    }
    $best=@($found|Sort-Object hits -Descending|Select-Object -First $Top)
    "== $Source files: $($found.Count) ($(($best|ForEach-Object{"$($_.path) $($_.hits)"})-join', '))$(if($over){"; $over over 2 MB not read"}) under $Folder"
    foreach($file in $best|Where-Object{$_.path-match'\.md$'}){$text=Read-SpiderText $file.full $Source;if($text){Get-MarkdownHits $Source $file.path $text}}
    "== $Source names: $($named.Count)$(if($named.Count){" ($(@($named|Select-Object -First $Top)-join', '))"})"
}

# Every rendered line (pointers, file names, note paths, diagnostics) leaves masked; fields cut short are masked first.
$script:spiderExit=0
& {
"SPIDER '$Query'"
# Sessions: lines that mention the query, per session, ranked by count; the first mention as the snippet.
$ix=@{};$ixPath=Join-Path $Root 'sessions\index.jsonl'
if(Test-Path $ixPath){foreach($l in [IO.File]::ReadAllLines($ixPath)){if($l){$o=$l|ConvertFrom-Json;$ix[$o.id]=$o}}}
$found=@{}
$raw=Join-Path $Root 'sessions\raw'
if(Test-Path $raw){foreach($f in Get-ChildItem $raw -Recurse -File -Filter *.jsonl){
    $id=if($f.Directory.Name-eq'subagents'){$f.Directory.Parent.Name}else{$f.BaseName-replace'^rollout-[\dT-]+?-(?=[0-9a-f]{8}-)',''}
    $sr=New-Object IO.StreamReader ([IO.File]::Open($f.FullName,'Open','Read','ReadWrite,Delete'))
    try{while($null-ne($l=$sr.ReadLine())){if($l.IndexOf($Query,$cmp)-ge0){
        if(!$found[$id]){$found[$id]=[pscustomobject]@{id=$id;hits=0;first=Get-Snippet $l}};$found[$id].hits++}}}finally{$sr.Close()}
}}
# A missing source is reported as UNAVAILABLE and makes the answer incomplete (exit 3), never "0 found".
$gaps=[Collections.Generic.List[string]]::new();if(!(Test-Path -LiteralPath $raw)){$gaps.Add("sessions (no archive at $raw)")}
$ranked=@($found.Values|Sort-Object hits -Descending)
"== data sessions: $(if(!(Test-Path -LiteralPath $raw)){"UNAVAILABLE (no archive at $raw)"}else{"$($ranked.Count) mention it"})$(if($ranked.Count){" ($(($ranked|Measure-Object hits -Sum).Sum) lines)"})"
foreach($s in $ranked|Select-Object -First $Top){
    $m=$ix[$s.id];$when=if($m.start){([datetime]$m.start).ToUniversalTime().ToString('yyyy-MM-dd')}else{'?'}
    "  data $($s.hits)x  $when $($s.id.Substring(0,[Math]::Min(8,$s.id.Length))) $(if($m.repo){"[$($m.repo)] "})$(if($m.title){$m.title}else{$m.firstPrompt})"
    "        `"$($s.first)`""
    if($m.raw){"        -> $(Join-Path $Root $m.raw)"}
}
# Events: the improvement memory's own ranking.
$ev=@(& (Join-Path $PSScriptRoot 'Events.ps1') -Root $Root -Find $Query -Top $Top)
$evCode=$LASTEXITCODE
if($evCode-in2,3){$gaps.Add("events ($(if($evCode-eq2){'EVENTS_INCOMPLETE'}else{'EVENTS_UNAVAILABLE'}))")}
"== data events: $(if($evCode-in2,3){($ev|Where-Object{$_-notmatch'^EVENTS:'})-join"`n  "}elseif($ev[0]-match'nothing recorded'){'none'}else{($ev|Select-Object -Skip 1)-join"`n  "})"
# Repositories: tracked files and commit messages.
foreach($r in $Repos){
    $name=Split-Path $r -Leaf
    if(!(Test-Path -LiteralPath (Join-Path $r '.git'))){"== repo $name`: UNAVAILABLE (no repository at $r)";$gaps.Add("$name (no repository)");continue}
    $g=@(Invoke-RepoGit $r grep -c -I -i -F -e $Query)
    $files=@($g|ForEach-Object{$p,$n=$_-split':(?=\d+$)';[pscustomobject]@{path=$p;hits=[int]$n}}|Sort-Object hits -Descending)
    $log=@(Invoke-RepoGit $r log --oneline -i -F "--grep=$Query" -n $Top)
    "== repo $name files: $($files.Count) ($(($files|Select-Object -First $Top|ForEach-Object{"$($_.path) $($_.hits)"})-join', '))"
    foreach($file in $files|Select-Object -First $Top|Where-Object{$_.path-match'\.md$'}){$text=Read-SpiderText (Join-Path $r $file.path) "repo $name";if($text){Get-MarkdownHits "repo $name" $file.path $text}}
    if($log.Count){"   repo $name commits: $(($log|ForEach-Object{$c=Hide-Secret $_;$c.Substring(0,[Math]::Min(90,$c.Length))})-join' | ')"}
}
# The rest of the data root (the transcripts and the journal are searched above), then temporary, bounded.
Search-SpiderFolder 'data' $Root {param($path)$path-notmatch'^sessions/raw/|^events/|(^|/)[^/]*sandbox[^/]*/'}
Search-SpiderFolder 'temporary' $Temporary {param($path)$path-match'^(sb|scratch)/|(^|/)README\.md$'-and$path-notmatch'(^|/)[^/]*sandbox[^/]*/'}
if($gaps.Count){"SPIDER_COVERAGE: incomplete - $($gaps-join'; ')";$script:spiderExit=3}
}|ForEach-Object{Hide-Secret $_}
exit $script:spiderExit
