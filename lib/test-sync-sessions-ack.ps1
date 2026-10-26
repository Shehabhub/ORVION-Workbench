# Sync-Sessions acknowledgement through real CLI/library callers, injected I/O/event failures and gated writers.
param([ValidateSet('All','Input','Success','StaleHash','ArchiveFailure','ArchiveInitialVerification','EventFailure','EventVerification','ArchiveVerification','RetireOrder','RetireFailure','ActiveChanged','Concurrency')][string]$Probe='All')
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$t=Join-Path ([IO.Path]::GetTempPath()) ('orvion-syncack-'+[guid]::NewGuid().ToString('N').Substring(0,8))
[void][IO.Directory]::CreateDirectory($t)
$fail=0;$ackChildren=[Collections.Generic.List[object]]::new()
function Assert-Ack([string]$Assertion,[bool]$Condition){if($Condition){"PASS $Assertion"}else{"FAIL $Assertion";$script:fail++}}
function Start-AckChild([string[]]$Arguments){
    $childInfo=[Diagnostics.ProcessStartInfo]::new((Get-Command pwsh -CommandType Application|Select-Object -First 1).Source)
    $childInfo.UseShellExecute=$false;$childInfo.CreateNoWindow=$true
    $childInfo.RedirectStandardOutput=$true;$childInfo.RedirectStandardError=$true
    foreach($childArgument in @('-NoProfile','-File')+$Arguments){$childInfo.ArgumentList.Add($childArgument)}
    $childProcess=[Diagnostics.Process]::new();$childProcess.StartInfo=$childInfo
    [void]$childProcess.Start()
    $ChildState=[pscustomobject]@{Process=$childProcess;Stdout=$childProcess.StandardOutput.ReadToEndAsync();Stderr=$childProcess.StandardError.ReadToEndAsync()}
    $ackChildren.Add($ChildState);$ChildState
}
function Complete-AckChild($ChildState){
    if(!$ChildState.Process.WaitForExit(15000)){throw 'SYNC_ACK_FIXTURE_CHILD_TIMEOUT'}
    [pscustomobject]@{Code=$ChildState.Process.ExitCode;Text=$ChildState.Stdout.GetAwaiter().GetResult()+$ChildState.Stderr.GetAwaiter().GetResult()}
}
function Wait-AckMarker([string]$Marker){
    $markerDeadline=[DateTime]::UtcNow.AddSeconds(10)
    while(!(Test-Path -LiteralPath $Marker)){
        if([DateTime]::UtcNow-ge$markerDeadline){throw 'SYNC_ACK_FIXTURE_MARKER_TIMEOUT'}
        Start-Sleep -Milliseconds 20
    }
}
function New-AckCase([string]$caseName,[string]$EventMode='Real'){
    $caseRoot=Join-Path $t $caseName;$caseLib=Join-Path $caseRoot 'lib';$caseStore=Join-Path $caseRoot 'store'
    [void][IO.Directory]::CreateDirectory($caseLib);[void][IO.Directory]::CreateDirectory((Join-Path $caseStore 'work'))
    Copy-Item (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') $caseLib
    Copy-Item (Join-Path $PSScriptRoot 'Events.ps1') $caseLib
    $caseLog=Join-Path $caseStore 'work\sync-errors.log'
    $caseText="2026-10-25T23:42:00Z pass : fixture failure`n";[IO.File]::WriteAllText($caseLog,$caseText)
    if($EventMode-ne'Real'){
        Move-Item -LiteralPath (Join-Path $caseLib 'Events.ps1') -Destination (Join-Path $caseLib 'Events.real.ps1')
        $eventHeader=@'
param([string]$Root,[switch]$Add,[string]$Pattern,[string]$Session,[string]$Source,[string]$Category,[string]$Cause,[string]$Status,[string]$Summary,[string]$Evidence,[string]$Tool,[string]$Action,[string]$Tags)
$ErrorActionPreference='Stop'
$fixtureActive=Join-Path $Root 'work\sync-errors.log'
'@
        $eventBody=switch($EventMode){
            EventFailure { '& (Join-Path $PSScriptRoot ''Events.real.ps1'') @PSBoundParameters;exit 9' }
            EventVerification { 'exit 0' }
            ArchiveVerification { @'
& (Join-Path $PSScriptRoot 'Events.real.ps1') @PSBoundParameters
$fixtureArchive=Join-Path $Root $Evidence
(Get-Item -LiteralPath $fixtureArchive).IsReadOnly=$false
[IO.File]::WriteAllText($fixtureArchive,'damaged archive')
exit 0
'@ }
            RetireOrder { @'
if(!(Test-Path -LiteralPath $fixtureActive)){exit 12}
[IO.File]::WriteAllText((Join-Path $Root 'event-saw-active'),'yes')
& (Join-Path $PSScriptRoot 'Events.real.ps1') @PSBoundParameters
exit $LASTEXITCODE
'@ }
            ActiveChanged { @'
& (Join-Path $PSScriptRoot 'Events.real.ps1') @PSBoundParameters
[IO.File]::AppendAllText($fixtureActive,"external new failure`n")
exit 0
'@ }
            Concurrency { @'
[IO.File]::WriteAllText((Join-Path $Root 'ack-ready'),'yes')
$fixtureDeadline=[DateTime]::UtcNow.AddSeconds(10)
while(!(Test-Path -LiteralPath (Join-Path $Root 'ack-release'))){
    if([DateTime]::UtcNow-ge$fixtureDeadline){exit 13}
    Start-Sleep -Milliseconds 20
}
& (Join-Path $PSScriptRoot 'Events.real.ps1') @PSBoundParameters
exit $LASTEXITCODE
'@ }
            default { throw 'UNKNOWN_EVENT_FIXTURE_MODE' }
        }
        [IO.File]::WriteAllText((Join-Path $caseLib 'Events.ps1'),$eventHeader+"`n"+$eventBody+"`n")
    }
    [pscustomobject]@{Store=$caseStore;Sync=(Join-Path $caseLib 'Sync-Sessions.ps1');Log=$caseLog;Text=$caseText;Hash=(Get-FileHash -LiteralPath $caseLog).Hash}
}
function Invoke-AckCase($case,[string]$RequestedHash=''){
    if(!$RequestedHash){$RequestedHash=$case.Hash}
    Complete-AckChild (Start-AckChild @($case.Sync,'-Root',$case.Store,'-AcknowledgeErrors','-ExpectedSHA256',$RequestedHash,'-Reason','fixture reviewed failure'))
}
function Read-AckEvents($case){
    $caseJournal=Join-Path $case.Store 'events\events.jsonl'
    if(Test-Path -LiteralPath $caseJournal){foreach($caseLine in [IO.File]::ReadAllLines($caseJournal)){$caseLine|ConvertFrom-Json -DateKind String}}
}
function Assert-AckBlocked($case,[string]$FailureName,[string]$ExpectedText=''){
    if(!$ExpectedText){$ExpectedText=$case.Text}
    Assert-Ack "$FailureName preserves the active log bytes" ((Test-Path -LiteralPath $case.Log)-and[IO.File]::ReadAllText($case.Log)-ceq$ExpectedText)
    $huntResult=Complete-AckChild (Start-AckChild @($huntLauncher,'-Hunt',(Join-Path $PSScriptRoot 'Hunt.ps1'),'-Store',$case.Store))
    Assert-Ack "$FailureName remains a Hunt sync-errors BUG" ($huntResult.Code-eq1-and$huntResult.Text-match'BUG sync-errors:')
}
$huntLauncher=Join-Path $t 'hunt.ps1'
[IO.File]::WriteAllText($huntLauncher,@'
param([string]$Hunt,[string]$Store)
function Get-Process { @() }
function Get-CimInstance { @() }
& $Hunt -Root $Store -DataRoot $Store -Quick -NoRecord
exit $LASTEXITCODE
'@)
try{
    if($Probe-in'All','Input'){
        $case=New-AckCase 'input'
        foreach($invalidArguments in @(
            ,@('-AcknowledgeErrors','-ExpectedSHA256',$case.Hash,'-Reason','reviewed')
            ,@('-Root',$case.Store,'-ExpectedSHA256',$case.Hash,'-Reason','reviewed')
            ,@('-Root',$case.Store,'-AcknowledgeErrors','-ExpectedSHA256','bad','-Reason','reviewed')
            ,@('-Root',$case.Store,'-AcknowledgeErrors','-ExpectedSHA256',$case.Hash,'-Reason',' ')
            ,@('-Root',$case.Store,'-AcknowledgeErrors','-ExpectedSHA256',$case.Hash,'-Reason','reviewed','-Follow')
        )){
            $invalidResult=Complete-AckChild (Start-AckChild @(@($case.Sync)+$invalidArguments))
            Assert-Ack 'invalid acknowledgement mode, root, hash or reason refuses without retiring errors' ($invalidResult.Code-eq3-and[IO.File]::ReadAllText($case.Log)-ceq$case.Text)
        }
    }
    if($Probe-in'All','StaleHash'){
        $case=New-AckCase 'stale'
        $staleResult=Invoke-AckCase $case ('0'*64)
        Assert-Ack 'stale hash refuses before creating an archive or event' ($staleResult.Code-eq3-and$staleResult.Text-match'SYNC_ACK_STALE_HASH'-and@(Get-ChildItem (Join-Path $case.Store 'work') -Filter 'sync-errors-ack-*.log').Count-eq0-and@(Read-AckEvents $case).Count-eq0)
        Assert-AckBlocked $case 'stale hash'
    }
    if($Probe-in'All','Success','RetireOrder'){
        $case=New-AckCase 'success' 'RetireOrder'
        $successResult=Invoke-AckCase $case
        $successEvents=@(Read-AckEvents $case)
        $successArchives=@(Get-ChildItem (Join-Path $case.Store 'work') -Filter 'sync-errors-ack-*.log')
        Assert-Ack 'acknowledgement records the event before retiring the active log' ($successResult.Code-eq0-and(Test-Path -LiteralPath (Join-Path $case.Store 'event-saw-active'))-and!(Test-Path -LiteralPath $case.Log))
        Assert-Ack 'acknowledgement preserves a readonly byte-exact archive and verified audit identity' ($successArchives.Count-eq1-and$successArchives[0].IsReadOnly-and[IO.File]::ReadAllText($successArchives[0].FullName)-ceq$case.Text-and(Get-FileHash -LiteralPath $successArchives[0].FullName).Hash-ceq$case.Hash-and$successEvents.Count-eq1-and$successEvents[0].summary.Contains($case.Hash)-and$successEvents[0].action-ceq'fixture reviewed failure'-and(Join-Path $case.Store $successEvents[0].evidence)-ceq$successArchives[0].FullName)
        $cleared=Complete-AckChild (Start-AckChild @($huntLauncher,'-Hunt',(Join-Path $PSScriptRoot 'Hunt.ps1'),'-Store',$case.Store))
        Assert-Ack 'acknowledged failure clears sync BUG without synthetic evidence or session gaps' ($cleared.Code-eq0-and$cleared.Text-notmatch'BUG sync-errors:'-and$cleared.Text-notmatch'GAP event-evidence:'-and$cleared.Text-notmatch'GAP lesson-raw-missing:')
        $originalArchive=$successArchives[0].FullName;$originalArchiveHash=(Get-FileHash -LiteralPath $originalArchive).Hash
        [IO.File]::WriteAllText($case.Log,"new failure after acknowledgement`n")
        Assert-AckBlocked $case 'new failure' "new failure after acknowledgement`n"
        $case.Hash=(Get-FileHash -LiteralPath $case.Log).Hash
        $secondResult=Invoke-AckCase $case
        Assert-Ack 'a second explicit acknowledgement preserves the first archive and appends another audit event' ($secondResult.Code-eq0-and@(Read-AckEvents $case).Count-eq2-and@(Get-ChildItem (Join-Path $case.Store 'work') -Filter 'sync-errors-ack-*.log').Count-eq2-and(Get-FileHash -LiteralPath $originalArchive).Hash-ceq$originalArchiveHash)
    }
    if($Probe-in'All','ArchiveFailure'){
        $case=New-AckCase 'archive-failure'
        $archiveLauncher=Join-Path $t 'archive-failure.ps1'
        [IO.File]::WriteAllText($archiveLauncher,@'
param([string]$Library,[string]$Store,[string]$Digest)
$ErrorActionPreference='Stop'
. $Library -Library -Root $Store
$script:archiveFailureHandle=$null
function Get-FileHash {
    param([string]$LiteralPath,[string]$Algorithm)
    $fixtureHash=Microsoft.PowerShell.Utility\Get-FileHash -LiteralPath $LiteralPath -Algorithm $Algorithm
    # Deny copying but permit deletion: a broken error-cleanup mutant must not be protected by this fixture lock.
    if($LiteralPath-eq$errLog-and!$script:archiveFailureHandle){$script:archiveFailureHandle=[IO.File]::Open($LiteralPath,'Open','Read','Delete')}
    $fixtureHash
}
try{Invoke-SyncErrorAcknowledgement $Digest 'fixture archive I/O failure';exit 0}
catch{'FIXTURE_ARCHIVE_IO_FAILURE';exit 3}
finally{if($script:archiveFailureHandle){$script:archiveFailureHandle.Dispose()}}
'@)
        $archiveResult=Complete-AckChild (Start-AckChild @($archiveLauncher,'-Library',$case.Sync,'-Store',$case.Store,'-Digest',$case.Hash))
        Assert-Ack 'archive I/O failure refuses before any acknowledgement event' ($archiveResult.Code-eq3-and$archiveResult.Text-match'FIXTURE_ARCHIVE_IO_FAILURE'-and@(Read-AckEvents $case).Count-eq0)
        Assert-AckBlocked $case 'archive I/O failure'
    }
    if($Probe-in'All','ArchiveInitialVerification'){
        $case=New-AckCase 'initial-archive-verification'
        $initialArchiveLauncher=Join-Path $t 'initial-archive-verification.ps1'
        [IO.File]::WriteAllText($initialArchiveLauncher,@'
param([string]$Library,[string]$Store,[string]$Digest)
$ErrorActionPreference='Stop'
. $Library -Library -Root $Store
function Get-FileHash {
    param([string]$LiteralPath,[string]$Algorithm)
    if([IO.Path]::GetFileName($LiteralPath)-like'sync-errors-ack-*'){return [pscustomobject]@{Hash=('0'*64)}}
    Microsoft.PowerShell.Utility\Get-FileHash -LiteralPath $LiteralPath -Algorithm $Algorithm
}
try{Invoke-SyncErrorAcknowledgement $Digest 'fixture invalid archive digest';exit 0}
catch{'FIXTURE_ARCHIVE_VERIFICATION_FAILURE';exit 3}
'@)
        $initialArchiveResult=Complete-AckChild (Start-AckChild @($initialArchiveLauncher,'-Library',$case.Sync,'-Store',$case.Store,'-Digest',$case.Hash))
        Assert-Ack 'initial archive verification failure refuses before recording any event' ($initialArchiveResult.Code-eq3-and$initialArchiveResult.Text-match'FIXTURE_ARCHIVE_VERIFICATION_FAILURE'-and@(Read-AckEvents $case).Count-eq0)
        Assert-AckBlocked $case 'initial archive verification failure'
    }
    if($Probe-in'All','RetireFailure'){
        $case=New-AckCase 'retirement-failure'
        $retireHandle=[IO.File]::Open($case.Log,'Open','Read','Read')
        try{
            $retireResult=Invoke-AckCase $case
            Assert-Ack 'retirement I/O failure reports failure after preserving its audit event' ($retireResult.Code-eq3-and@(Read-AckEvents $case).Count-eq1)
            Assert-AckBlocked $case 'retirement I/O failure'
        }finally{$retireHandle.Dispose()}
    }
    foreach($failureMode in 'EventFailure','EventVerification','ArchiveVerification','ActiveChanged'){
        if($Probe-notin'All',$failureMode){continue}
        $case=New-AckCase $failureMode $failureMode
        $failureResult=Invoke-AckCase $case
        $failureCode=switch($failureMode){EventFailure{'SYNC_ACK_EVENT_FAILED'} EventVerification{'SYNC_ACK_EVENT_NOT_VERIFIED'} ArchiveVerification{'SYNC_ACK_ARCHIVE_MISMATCH'} ActiveChanged{'SYNC_ACK_ACTIVE_CHANGED'}}
        Assert-Ack "$failureMode refuses with a stable failure code" ($failureResult.Code-eq3-and$failureResult.Text.Contains($failureCode))
        $preservedText=if($failureMode-eq'ActiveChanged'){$case.Text+"external new failure`n"}else{$case.Text}
        Assert-AckBlocked $case $failureMode $preservedText
    }
    if($Probe-in'All','Concurrency'){
        $case=New-AckCase 'concurrency' 'Concurrency'
        $ackChild=Start-AckChild @($case.Sync,'-Root',$case.Store,'-AcknowledgeErrors','-ExpectedSHA256',$case.Hash,'-Reason','fixture concurrent acknowledgement')
        Wait-AckMarker (Join-Path $case.Store 'ack-ready')
        $writerLauncher=Join-Path $t 'writer.ps1'
        [IO.File]::WriteAllText($writerLauncher,@'
param([string]$Library,[string]$Store)
. $Library -Library -Root $Store
$script:failures=0
[IO.File]::WriteAllText((Join-Path $Store 'writer-ready'),'yes')
try{throw 'new concurrent failure'}catch{Write-SyncError 'fixture writer' $_}
if($script:failures-ne1){exit 4}
exit 0
'@)
        $writerChild=Start-AckChild @($writerLauncher,'-Library',$case.Sync,'-Store',$case.Store)
        Wait-AckMarker (Join-Path $case.Store 'writer-ready')
        Assert-Ack 'concurrent error writer waits for acknowledgement log lock' (!$writerChild.Process.WaitForExit(500))
        [IO.File]::WriteAllText((Join-Path $case.Store 'ack-release'),'yes')
        $concurrentAck=Complete-AckChild $ackChild;$concurrentWriter=Complete-AckChild $writerChild
        Assert-Ack 'acknowledgement and waiting writer both finish without losing the new error' ($concurrentAck.Code-eq0-and$concurrentWriter.Code-eq0-and(Test-Path -LiteralPath $case.Log)-and[IO.File]::ReadAllText($case.Log)-match'new concurrent failure'-and[IO.File]::ReadAllText($case.Log)-notmatch'fixture failure')
        $concurrentEvents=@(Read-AckEvents $case)
        Assert-Ack 'concurrent acknowledgement archives only the reviewed bytes' ($concurrentEvents.Count-eq1-and[IO.File]::ReadAllText((Join-Path $case.Store $concurrentEvents[0].evidence))-ceq$case.Text)
        $concurrentHunt=Complete-AckChild (Start-AckChild @($huntLauncher,'-Hunt',(Join-Path $PSScriptRoot 'Hunt.ps1'),'-Store',$case.Store))
        Assert-Ack 'concurrent new failure blocks Hunt after acknowledgement' ($concurrentHunt.Code-eq1-and$concurrentHunt.Text-match'BUG sync-errors:.*new concurrent failure')
    }
}finally{
    foreach($ownedChild in $ackChildren){try{if(!$ownedChild.Process.HasExited){$ownedChild.Process.Kill($true);$null=$ownedChild.Process.WaitForExit(5000)}}finally{$ownedChild.Process.Dispose()}}
    $null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())
}
if($fail){throw "SYNC_ACK_SELFCHECK_FAILED $fail ($Probe)"};"SYNC_ACK_SELFCHECK PASS ($Probe)"
