# ORVION pulse: the workspace's live state in a dozen lines, for any agent arriving (the session-start hook prints it;
# Codex and others run it themselves). Everything is read at call time; nothing here is stored or authoritative.
#   repos      each repository: branch@HEAD, clean, ahead/behind its upstream as of the last fetch, pending candidates
#   running    the session archiver, timed runs (with their log's last line), host memory
#   waiting    genuine owner choices from the SAME Coordinator snapshot as the queue
#   last       the newest other session: task, when it ended, where it stopped
#   queue      the coordinator's queue (Coordinator.ps1 -Brief): counts by state, the three most urgent items
#   map        ai-map freshness: each mapped repository's saved head against its live HEAD
# Read-only except one side effect: a stale map starts its refresh task. A failing read prints UNREADABLE, never a guess.
param([string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'}),[string]$Session=$env:CLAUDE_CODE_SESSION_ID,
      [string[]]$Repos=@('CRM','ORVION'|ForEach-Object{Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) $_}),
      [scriptblock]$StartMapTask={Start-ScheduledTask -TaskName 'ORVION Repository Map' -ErrorAction Stop},
      [string]$MapPath=(Join-Path (Split-Path $PSScriptRoot -Parent) 'ai-map.json'))  # owner-fixed generated map location
$ErrorActionPreference='Stop'
if(!$PSBoundParameters.ContainsKey('Root')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $Root 'events') -PathType Container)){'PULSE_UNAVAILABLE: ORVION_DATA_ROOT_UNAVAILABLE';exit 3}
$pulseUnreadable=$false
# Mask every value before it is shortened: a cut first can leave a token's tail unmasked. The library loads in its own
# module, isolated from Pulse's variables.
$null=New-Module -Name PulseMask -ScriptBlock {param($Library,$Data) . (Join-Path $Library 'Sync-Sessions.ps1') -Library -Root $Data;Export-ModuleMember -Function Hide-Secret} -ArgumentList $PSScriptRoot,$Root|Import-Module -PassThru
function Get-GitLine{param([string]$Repo)$o=& git -C $Repo @args 2>$null;if($LASTEXITCODE){throw "git $($args-join' ')"};"$o".Trim()}
$pulseOwnerLines=@()
$pulseLines=@(. {
"ORVION PULSE $([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC"
if(!(Test-Path -LiteralPath $MapPath -PathType Leaf)){"map      missing: pwsh -NoProfile -File lib\Map-Repos.ps1 -Install"}
else{try{
    $map=[IO.File]::ReadAllText($MapPath)|ConvertFrom-Json
    $mappedRepos=@($map|ForEach-Object{$_.repos}|Where-Object{$null-ne$_})  # @($null).Count is 1: a blank map must not read as fresh
    if(!$mappedRepos.Count){throw 'no mapped repositories'}
    $stale=@(foreach($mapped in $mappedRepos){
        if(!$mapped.name-or!$mapped.root-or!$mapped.head){throw 'map entry without name, root or head'}
        if((Get-GitLine $mapped.root rev-parse HEAD)-ne$mapped.head){$mapped.name}})
    if($stale){& $StartMapTask|Out-Null;"map      stale ($($stale-join', ')): refresh started"}else{'map      fresh'}
}catch{$pulseUnreadable=$true;"map      UNREADABLE ($($_.Exception.Message))"}}
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
try{
$procs=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'" -ErrorAction Stop|Where-Object{$_.CommandLine})
$follow=@($procs|Where-Object{$_.CommandLine-match'Sync-Sessions\.ps1.*-Follow'})
$timed=@($procs|Where-Object{$_.CommandLine-match'run_timed\.ps1'}|ForEach-Object{
    $log=[regex]::Match($_.CommandLine,'-Log\s+"?([^"]+?)"?(\s+-|\s*$)').Groups[1].Value
    $last=if($log-and(Test-Path -LiteralPath $log)){Hide-Secret @(Get-Content -LiteralPath $log -Tail 1)[0]}else{''}
    "pid $($_.ProcessId)$(if($log){" $log"})$(if($last){": $($last.Substring(0,[Math]::Min(80,$last.Length)))"})"})
$os=Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
if(!$os-or$null-eq$os.FreePhysicalMemory-or$null-eq$os.FreeVirtualMemory){throw 'host evidence unavailable'}
"running  archiver $(if($follow){"following (pid $($follow[0].ProcessId))"}else{'NOT running (start a session or: Sync-Sessions.ps1 -Follow)'}); timed runs: $(if($timed){$timed-join' | '}else{'none'}); host: $([math]::Round($os.FreePhysicalMemory/1MB,1)) GB free, commit headroom $([math]::Round($os.FreeVirtualMemory/1MB,1)) GB"
}catch{$pulseUnreadable=$true;'running  UNREADABLE (process/host discovery failed)'}
# One journal read/classifier: inherited assignment and unreadable evidence are Coordinator-owned.
$pulseSnapshot=$null
try{
    $snapshotRows=@(& (Join-Path $PSScriptRoot 'Coordinator.ps1') -Root $Root -Snapshot)
    if($snapshotRows.Count-ne1-or$snapshotRows[0].Schema-ne1-or$snapshotRows[0].Readable-isnot[bool]){throw 'snapshot unavailable'}
    $pulseSnapshot=$snapshotRows[0]
    if(!$pulseSnapshot.Readable){throw 'required journal incomplete'}
    $waiting=@($pulseSnapshot.Items|Where-Object state -eq 'OWNER')
    "waiting  on the owner: $($waiting.Count)"
    # Snapshot summaries arrive masked: Coordinator masks item text where it builds items.
    $pulseOwnerLines=@(foreach($w in $waiting){"         - $($w.pattern): $($w.summary.Substring(0,[Math]::Min(150,$w.summary.Length)))$(if($w.summary.Length-gt150){'...'})"})
    $pulseOwnerLines
}catch{$pulseUnreadable=$true;'waiting  UNREADABLE (required Coordinator evidence unavailable/incomplete)'}
$ixPath=Join-Path $Root 'sessions\index.jsonl'
$prev=@(if(Test-Path $ixPath){[IO.File]::ReadAllLines($ixPath)|Where-Object{$_}|ForEach-Object{try{$_|ConvertFrom-Json}catch{$script:indexBadRows++}}|Where-Object{$_}|Where-Object{$_.id-ne$Session-and$_.prompts}|Sort-Object end})|Select-Object -Last 1
# The session index is continuity evidence: missing is said plainly, damaged rows make the pulse unreadable.
if(!(Test-Path $ixPath)){"last     none: no session index at $ixPath (Sync-Sessions.ps1 builds it)"}elseif($script:indexBadRows){$pulseUnreadable=$true;"last     UNREADABLE: $($script:indexBadRows) damaged session-index row(s) in $ixPath"}
function Format-PulsePrompt([string]$Text){$Text=Hide-Secret $Text;if($Text.Length-gt300){return $Text.Substring(0,297)+'...'};$Text}
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
})
if($pulseUnreadable){$pulseLines=@($pulseLines[0],'state    UNREADABLE (required live evidence incomplete)')+@($pulseLines|Select-Object -Skip 1)}
# Select before rendering: keep diagnostics/counts/pointers, then the snapshot's urgent detail order.
# Mask complete lines again before any new abbreviation (covers every line not masked at its source).
$pulseSafeLines=@(foreach($line in $pulseLines){Hide-Secret $line})
$pulseOwnerSet=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
foreach($line in $pulseOwnerLines){[void]$pulseOwnerSet.Add($line)}
$pulseRows=@();$pulseAbbreviated=$false
for($lineIndex=0;$lineIndex-lt$pulseLines.Count;$lineIndex++){
    $text=[string]$pulseSafeLines[$lineIndex];$ownerDetail=$pulseOwnerSet.Contains([string]$pulseLines[$lineIndex])
    # Priority from line structure only: summary words (an owner note saying "UNOWNED") never promote a line.
    # Non-owner "         - " lines are the Coordinator's escalated (UNOWNED/OVERDUE) items.
    $priority=if($text-match'^ORVION PULSE|^state\s'){0}elseif($text-match'^(waiting|cases|tools)\s'){1}elseif($ownerDetail){6}
        elseif($text-match'^(repo|running|last|queue|map)\s.*UNREADABLE'){2}
        elseif($text-match'^last\s|^         (in flight:|- )'){3}elseif($text-match'^(repo|running|hunt|map)\s'){4}else{5}
    if($text.Length-gt1024){
        $pulseAbbreviated=$true
        $archiveOffset=$text.IndexOf('; archive: ',[StringComparison]::Ordinal)
        if($text-match'^last\s'-and$archiveOffset-ge0){
            $archiveTail=$text.Substring($archiveOffset)
            $text='last     session detail abbreviated'+$(if($archiveTail.Length-lt700){$archiveTail}else{'; archive: sessions\INDEX.md under the selected data root'})
        }else{$text=$text.Substring(0,250)+'... (detail abbreviated)'+$(if($text-match'UNREADABLE'){' UNREADABLE'})}
    }
    $pulseRows+=,[pscustomobject]@{Index=$lineIndex;Text=$text;Priority=$priority;Owner=$ownerDetail}
}
$pulseLimit=4096-[Environment]::NewLine.Length
$pulseText=$pulseRows.Text-join"`n"
if($pulseText.Length-gt$pulseLimit-or$pulseAbbreviated){
    $coordinatorCommand="pwsh -NoProfile -File '"+(Join-Path $PSScriptRoot 'Coordinator.ps1').Replace("'","''")+"' -Root '"+$Root.Replace("'","''")+"'"
    # Extremely long caller paths get an explicit same-Root template rather than a cut, misleading command.
    if($coordinatorCommand.Length-gt1000){$coordinatorCommand='Coordinator.ps1 -Root <same Root supplied to Pulse>'}
    $coordinatorCommand=Hide-Secret $coordinatorCommand
    $footerReserve="more     $($pulseOwnerLines.Count) more owner wait(s); $($pulseRows.Count) more entries total; $coordinatorCommand"
    $available=$pulseLimit-$footerReserve.Length-1;$used=0;$ownerFull=$false
    $selected=[Collections.Generic.HashSet[int]]::new()
    foreach($row in $pulseRows|Sort-Object Priority,Index){
        if($row.Owner-and$ownerFull){continue}
        if($used+$row.Text.Length+1-le$available){[void]$selected.Add($row.Index);$used+=$row.Text.Length+1}
        elseif($row.Owner){$ownerFull=$true}
    }
    $shown=@($pulseRows|Where-Object{$selected.Contains($_.Index)})
    $omittedOwners=$pulseOwnerLines.Count-@($shown|Where-Object Owner).Count
    $footer="more     $omittedOwners more owner wait(s); $($pulseRows.Count-$shown.Count) more entries total; $coordinatorCommand"
    $pulseText=(@($shown.Text)+@($footer))-join"`n"
}
$pulseText
exit $(if($pulseUnreadable){2}else{0})
