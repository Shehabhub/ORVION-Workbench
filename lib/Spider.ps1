# The ORVION spider: one question across everything the workspace knows, ranked, with a pointer to each original.
#   pwsh -NoProfile -File Spider.ps1 'SPEC-291'          an entity: SPEC id, error code, script, SHA, pattern id
#   pwsh -NoProfile -File Spider.ps1 'watcher ETA' -Top 3 a phrase (case-insensitive, exact words in order)
# Sources, crawled live at question time (measured 2026-10-20: 353 MB of sessions in 1.6-2.8 s, so no stale index):
#   sessions  archived transcripts (sessions\raw, main + subagents), joined with sessions\index.jsonl for task and date
#   events    events\events.jsonl through Events.ps1 -Find (lessons, recurrence, disposition)
#   repos     tracked files of each repository (git grep) and its commit messages (git log --grep)
#   notes     Claude memory, this workspace's READMEs and INDEX.md, the owner-review packets' own *.md (two levels, never
#             the repository clones inside them: 11,238 copies of repository files made the first version take 149 s)
# Rules (its robots.txt): credential values are masked in every snippet; a failing git read refuses, never reads as
# "no match"; .git, node_modules and raw sandboxes are never crawled. Read-only.
param([Parameter(Mandatory,Position=0)][string]$Query,[int]$Top=5,
      [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}),
      [string[]]$Repos=@('CRM','ORVION'|ForEach-Object{Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) $_}),
      [string]$ReviewRoot=(Join-Path $env:USERPROFILE 'Documents\ORVION-Owner-Review'))
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $Root  # the archive's secret rules mask snippets the same way
$cmp=[StringComparison]::OrdinalIgnoreCase
function Get-Snippet([string]$Line){  # one readable line around the first match, credential values masked
    # mask the whole line first: masking after the cut leaked the part of a token that fell inside the snippet
    $Line=Hide-Secret $Line
    $at=[Math]::Max(0,$Line.IndexOf($Query,$cmp)-70);$s=$Line.Substring($at,[Math]::Min(220,$Line.Length-$at))
    (($s-replace'\\[nrt]',' '-replace'\\"','"'-replace'\\\\','\'-replace'\s+',' ').Trim())
}
function Invoke-RepoGit([string]$Repo){$o=& git -C $Repo @args 2>&1;if($LASTEXITCODE-gt1){throw "SPIDER_GIT_FAILED $Repo git $($args-join' '): $o"};@($o|Where-Object{$_-is[string]})}

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
"== sessions: $(if(!(Test-Path -LiteralPath $raw)){"UNAVAILABLE (no archive at $raw)"}else{"$($ranked.Count) mention it"})$(if($ranked.Count){" ($(($ranked|Measure-Object hits -Sum).Sum) lines)"})"
foreach($s in $ranked|Select-Object -First $Top){
    $m=$ix[$s.id];$when=if($m.start){([datetime]$m.start).ToUniversalTime().ToString('yyyy-MM-dd')}else{'?'}
    "  $($s.hits)x  $when $($s.id.Substring(0,[Math]::Min(8,$s.id.Length))) $(if($m.repo){"[$($m.repo)] "})$(if($m.title){$m.title}else{$m.firstPrompt})"
    "        `"$($s.first)`""
    if($m.raw){"        -> $(Join-Path $Root $m.raw)"}
}
# Events: the improvement memory's own ranking.
$ev=@(& (Join-Path $PSScriptRoot 'Events.ps1') -Root $Root -Find $Query -Top $Top)
$evCode=$LASTEXITCODE
if($evCode-in2,3){$gaps.Add("events ($(if($evCode-eq2){'EVENTS_INCOMPLETE'}else{'EVENTS_UNAVAILABLE'}))")}
"== events: $(if($evCode-in2,3){($ev|Where-Object{$_-notmatch'^EVENTS:'})-join"`n  "}elseif($ev[0]-match'nothing recorded'){'none'}else{($ev|Select-Object -Skip 1)-join"`n  "})"
# Repositories: tracked files and commit messages.
foreach($r in $Repos){
    $name=Split-Path $r -Leaf
    if(!(Test-Path -LiteralPath (Join-Path $r '.git'))){"== $name`: UNAVAILABLE (no repository at $r)";$gaps.Add("$name (no repository)");continue}
    $g=@(Invoke-RepoGit $r grep -c -I -i -F -e $Query)
    $files=@($g|ForEach-Object{$p,$n=$_-split':(?=\d+$)';[pscustomobject]@{path=$p;hits=[int]$n}}|Sort-Object hits -Descending)
    $log=@(Invoke-RepoGit $r log --oneline -i -F "--grep=$Query" -n $Top)
    "== $name files: $($files.Count) ($(($files|Select-Object -First $Top|ForEach-Object{"$($_.path) $($_.hits)"})-join', '))"
    if($log.Count){"   $name commits: $(($log|ForEach-Object{$_.Substring(0,[Math]::Min(90,$_.Length))})-join' | ')"}
}
# Notes: memory, workspace docs, owner-review packets (markdown only).
$md=@(
    $projects=Join-Path $env:USERPROFILE '.claude\projects'
    # Claude is optional; enumeration/read errors for a present source must still refuse.
    if(Test-Path -LiteralPath $projects){
        if(!(Test-Path -LiteralPath $projects -PathType Container)){throw 'SPIDER_CLAUDE_PROJECTS_NOT_DIRECTORY'}
        Get-ChildItem -LiteralPath $projects -Directory|ForEach-Object{$m=Join-Path $_.FullName 'memory';if(Test-Path $m){Get-ChildItem $m -File -Filter *.md}}
    }
    foreach($p in 'README.md','lib\README.md','sessions\INDEX.md'){$x=Join-Path $Root $p;if(Test-Path $x){Get-Item $x}}
    if(Test-Path $ReviewRoot){Get-ChildItem $ReviewRoot -File -Filter *.md;foreach($d in Get-ChildItem $ReviewRoot -Directory){
        Get-ChildItem $d.FullName -File -Filter *.md
        Get-ChildItem $d.FullName -Directory|Where-Object{!(Test-Path (Join-Path $_.FullName '.git'))}|ForEach-Object{Get-ChildItem $_.FullName -File -Filter *.md}}}
)
$nh=@(foreach($f in $md){$c=@([IO.File]::ReadAllLines($f.FullName)|Where-Object{$_.IndexOf($Query,$cmp)-ge0}).Count;if($c){[pscustomobject]@{path=$f.FullName;hits=$c}}})
if($gaps.Count){$coverage="SPIDER_COVERAGE: incomplete - $($gaps-join'; ')"}
"== notes: $($nh.Count) files$(if($nh.Count){': '+(($nh|Sort-Object hits -Descending|Select-Object -First $Top|ForEach-Object{"$($_.path.Replace($env:USERPROFILE,'~')) $($_.hits)"})-join', ')})"
if($gaps.Count){$coverage;exit 3}
