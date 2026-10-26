# ORVION pulse: the workspace's live state in a dozen lines, for any agent arriving (the session-start hook prints it;
# Codex and others run it themselves). Everything is read at call time; nothing here is stored or authoritative.
#   repos      each repository: branch@HEAD, clean, ahead/behind its upstream as of the last fetch, pending candidates
#   running    the session archiver, timed runs (with their log's last line), host memory
#   waiting    genuine owner choices from the SAME Coordinator snapshot as the queue
#   last       the newest other session: task, when it ended, where it stopped
#   queue      the coordinator's queue (Coordinator.ps1 -Brief): counts by state, the three most urgent items
# Read-only; a failing git read prints UNREADABLE for that repository instead of guessing.
param([string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}),[string]$Session=$env:CLAUDE_CODE_SESSION_ID,
      [string[]]$Repos=@('CRM','ORVION'|ForEach-Object{Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) $_}))
$ErrorActionPreference='Stop'
$pulseUnreadable=$false
function Get-GitLine{param([string]$Repo)$o=& git -C $Repo @args 2>$null;if($LASTEXITCODE){throw "git $($args-join' ')"};"$o".Trim()}
"ORVION PULSE $([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC"
foreach($r in $Repos){
    $name=Split-Path $r -Leaf
    try{
        if(!(Test-Path -LiteralPath (Join-Path $r '.git'))){throw 'selected repository missing'}
        $head=Get-GitLine $r rev-parse --short HEAD;$branch=Get-GitLine $r rev-parse --abbrev-ref HEAD
        $dirty=@(& git -C $r status --porcelain 2>$null).Count;if($LASTEXITCODE){throw 'status'}
        $upstream=Get-GitLine $r for-each-ref --format='%(upstream)' "refs/heads/$branch"
        $ab=if($upstream){(Get-GitLine $r rev-list --left-right --count "HEAD...$upstream")-split'\s+'}else{$null}
        # a pending tail already contained in the upstream was released: say so, it is only a leftover branch
        $pendingRows=@(& git -C $r for-each-ref --format='%(refname:short) %(objectname)' 'refs/heads/orvion/*-pending' 2>$null)
        if($LASTEXITCODE-ne0){throw 'pending refs unreadable'}
        $pending=@(foreach($pendingRow in $pendingRows){
            $n,$sha=$pendingRow-split' ';$gone=$false
            if($upstream){
                & git -C $r merge-base --is-ancestor $sha $upstream 2>$null
                if($LASTEXITCODE-notin0,1){throw 'pending ancestry unreadable'}
                $gone=$LASTEXITCODE-eq0
            }
            "$n@$($sha.Substring(0,7))$(if($gone){' (released, leftover branch)'}elseif(!$upstream){' (upstream unavailable)'})"
        })
        $state=if($ab){"$($ab[0]) ahead / $($ab[1]) behind upstream (last fetch)"}else{'no upstream'}
        "repo     $name $branch@$head $(if($dirty){"DIRTY($dirty)"}else{'clean'}), $state$(if($pending){"; pending: $($pending-join', ')"})"
    }catch{$pulseUnreadable=$true;"repo     $name UNREADABLE ($($_.Exception.Message))"}
}
$procs=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'"|Where-Object{$_.CommandLine})
$follow=@($procs|Where-Object{$_.CommandLine-match'Sync-Sessions\.ps1.*-Follow'})
$timed=@($procs|Where-Object{$_.CommandLine-match'run_timed\.ps1'}|ForEach-Object{
    $log=[regex]::Match($_.CommandLine,'-Log\s+"?([^"]+?)"?(\s+-|\s*$)').Groups[1].Value
    $last=if($log-and(Test-Path -LiteralPath $log)){@(Get-Content -LiteralPath $log -Tail 1)[0]}else{''}
    "pid $($_.ProcessId)$(if($log){" $log"})$(if($last){": $($last.Substring(0,[Math]::Min(80,$last.Length)))"})"})
$os=Get-CimInstance Win32_OperatingSystem
"running  archiver $(if($follow){"following (pid $($follow[0].ProcessId))"}else{'NOT running (start a session or: Sync-Sessions.ps1 -Follow)'}); timed runs: $(if($timed){$timed-join' | '}else{'none'}); host: $([math]::Round($os.FreePhysicalMemory/1MB,1)) GB free, commit headroom $([math]::Round($os.FreeVirtualMemory/1MB,1)) GB"
# One journal read/classifier: inherited assignment and unreadable evidence are Coordinator-owned.
$pulseSnapshot=$null
try{
    $snapshotRows=@(& (Join-Path $PSScriptRoot 'Coordinator.ps1') -Root $Root -Snapshot)
    if($snapshotRows.Count-ne1-or$snapshotRows[0].Schema-ne1-or$snapshotRows[0].Readable-isnot[bool]){throw 'snapshot unavailable'}
    $pulseSnapshot=$snapshotRows[0]
    if(!$pulseSnapshot.Readable){throw 'required journal incomplete'}
    $waiting=@($pulseSnapshot.Items|Where-Object state -eq 'OWNER')
    "waiting  on the owner: $($waiting.Count)"
    foreach($w in $waiting){"         - $($w.pattern): $($w.summary.Substring(0,[Math]::Min(150,$w.summary.Length)))$(if($w.summary.Length-gt150){'...'})"}
}catch{$pulseUnreadable=$true;'waiting  UNREADABLE (required Coordinator evidence unavailable/incomplete)'}
$ixPath=Join-Path $Root 'sessions\index.jsonl'
$prev=@(if(Test-Path $ixPath){[IO.File]::ReadAllLines($ixPath)|Where-Object{$_}|ForEach-Object{try{$_|ConvertFrom-Json}catch{$script:indexBadRows++}}|Where-Object{$_}|Where-Object{$_.id-ne$Session-and$_.prompts}|Sort-Object end})|Select-Object -Last 1
# The session index is continuity evidence: missing is said plainly, damaged rows make the pulse unreadable.
if(!(Test-Path $ixPath)){"last     none: no session index at $ixPath (Sync-Sessions.ps1 builds it)"}elseif($script:indexBadRows){$pulseUnreadable=$true;"last     UNREADABLE: $($script:indexBadRows) damaged session-index row(s) in $ixPath"}
function Format-PulsePrompt([string]$Text){if($Text.Length-gt300){return $Text.Substring(0,297)+'...'};$Text}
if($prev){
    $title=Format-PulsePrompt (@($prev.title,$prev.firstPrompt)|Where-Object{$_}|Select-Object -First 1)
    $lastPrompt=Format-PulsePrompt $prev.lastPrompt
    $archive=Join-Path $Root $(if($prev.raw){$prev.raw}else{'sessions\INDEX.md'})
    "last     session $($prev.id.Substring(0,[Math]::Min(8,$prev.id.Length))) [$($prev.repo) $($prev.client)] `"$title`" ended $(([datetime]$prev.end).ToUniversalTime().ToString('yyyy-MM-dd HH:mm')); last ask: `"$lastPrompt`"; archive: $archive"
}
# every open observation, held to an owner, a next action and a due time; the most urgent first
if($pulseSnapshot){
    if(!$pulseSnapshot.Readable){'queue    UNREADABLE (valid partial diagnostics only)'}
    $pulseSnapshot.Brief
}else{'queue    UNREADABLE (no valid Coordinator snapshot)'}
$hl=Join-Path $Root 'work\hunt-last.txt'
if(Test-Path $hl){
    $h=@(Get-Content $hl);$age=[int]([DateTime]::UtcNow-(Get-Item $hl).LastWriteTimeUtc).TotalHours
    "hunt     $($h[0]) ($age h ago$(if($age-ge24){'; stale: run Hunt.ps1'}))"
}else{'hunt     never run: pwsh -NoProfile -File lib\Hunt.ps1'}
"tools    Coordinator.ps1 | Spider.ps1 '<anything>' (all sources) | Events.ps1 -Find '<task>' | Delegate.ps1 -List | Hunt.ps1 | sessions\INDEX.md | lib\README.md"
exit $(if($pulseUnreadable){2}else{0})
