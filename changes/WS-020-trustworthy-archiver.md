# Workbench Change Request - WS-020

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Make the session archiver and its health signals trustworthy: Sync-Sessions reads the index with -DateKind String so cached and new start values sort without the inconsistent-comparer failure that broke an archiver pass; Events records an evidence-only correction instead of discarding it as a duplicate; Hunt checks only the latest nonempty evidence per pattern so a correction clears a stale citation while the journal stays append-only; and Sync-Sessions -AcknowledgeErrors -ExpectedSHA256 -Reason gives an auditable way to clear a reviewed archiver failure (serialized with the error writer, immutable verified archive, verified event before the log is retired, new errors block again). Four existing self-checks use the bounded owned-tree cleanup helper.

## Baseline

640cd27fc1794490b26567a95fa846f34ef1d783

## Write Scope

- RESUME.md
- lib/Sync-Sessions.ps1
- lib/Events.ps1
- lib/Hunt.ps1
- lib/test-sync-sessions-ack.ps1
- lib/test-sync-sessions-survival.ps1
- lib/test-events.ps1
- lib/test-hunt.ps1
- lib/test-events-retrieval.ps1
- lib/test-sync-sessions-append.ps1
- lib/test-sync-sessions-rewrite.ps1
- lib/test-watch-reminder.ps1
- lib/README.md
- docs/RECOVERY.md

## Out of Scope

All other engineering paths except native allocation/status/pointer bookkeeping. No checker (Test-WorkbenchChange.ps1), applier, workflow, WORKFLOW.md, TEMPLATE, hook, GitHub setting, user setting or product repository change. RESUME.md content beyond native bookkeeping is not changed (its routing sentence stays true after the WS-019 hook repoint). Deferred: Test-ScriptHazards treating independent function scopes as one (proved false collision), Hunt baseline, Finish watcher binding, observer timeouts. CTRL-19 stays OPEN; Batch 6/Phase 8 stay ON HOLD; C2 stays UNPROVEN.

## Draft Assurance

V1: WS020-ARCHIVER-DESIGN | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws020-package\assurance\V1\DRAFT.md | 3A20A8B278BB57437D4C9556D7644A106C8B7DC28113808EB92834422A727DB9
V2: WS020-ARCHIVER-ADVERSARIAL | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws020-package\assurance\V2\DRAFT.md | E1F6836F20CE1F684C46F41CFB22CFB39905E2856A2BE77F9FD65405D80658F6
V3: WS020-ARCHIVER-REFRESH | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws020-package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSack20
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSack20\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSack20\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws020-package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/Sync-Sessions.ps1` contains `AcknowledgeErrors`; if so record Already Applied when its Git blob is 59b642453909281d141cfb1389f11658963524b5, and otherwise stop and report. Otherwise make exactly these 6 edits (trustworthy archiver only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$ClaudeProjects=(Join-Path $env:USERPROFILE '.claude\projects'),[string]$CodexSessions=(Join-Path $env:USERPROFILE '.codex\sessions'))  # -Library: dot-source for tests, defines the functions only
   ```
   with
   ```text
         [string]$ClaudeProjects=(Join-Path $env:USERPROFILE '.claude\projects'),[string]$CodexSessions=(Join-Path $env:USERPROFILE '.codex\sessions'),
         [switch]$AcknowledgeErrors,[string]$ExpectedSHA256,[string]$Reason)  # -Library: dot-source for tests, defines the functions only
   ```

   b) immediately after the lines
   ```text
       }finally{$in.Close()}
       $true
   }
   ```
   insert
   ```text
   function Enter-SyncErrorLock([int]$WaitMilliseconds=30000){
       [void][IO.Directory]::CreateDirectory((Split-Path $errLog -Parent))
       $logKey=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes([IO.Path]::GetFullPath($errLog).ToUpperInvariant())))
       $logMutex=[Threading.Mutex]::new($false,"Local\orvion-sync-errors-$logKey")
       try{
           $logOwned=try{$logMutex.WaitOne($WaitMilliseconds)}catch [Threading.AbandonedMutexException]{$true}
           if(!$logOwned){throw 'SYNC_ERRORS_LOCK_TIMEOUT'}
           $logMutex
       }catch{$logMutex.Dispose();throw}
   }
   ```

   c) replace the lines
   ```text
       try{New-Item -ItemType Directory (Split-Path $errLog -Parent) -Force|Out-Null
           [IO.File]::AppendAllText($errLog,"$([DateTime]::UtcNow.ToString('o')) $What : $($Err.Exception.Message)`n")}catch{$null=$_}
   ```
   with
   ```text
       try{
           # A waiting error must not time out and disappear while acknowledgement is recording its event.
           $errorLease=Enter-SyncErrorLock -WaitMilliseconds -1
           try{[IO.File]::AppendAllText($errLog,"$([DateTime]::UtcNow.ToString('o')) $What : $($Err.Exception.Message)`n")}
           finally{try{$errorLease.ReleaseMutex()}finally{$errorLease.Dispose()}}
       }catch{[Console]::Error.WriteLine('SESSIONS: error log UNREADABLE')}
   ```

   d) immediately after the lines
   ```text
       [Console]::Error.WriteLine("SESSIONS: preservation FAILED; see $errLog")
   }

   ```
   insert
   ```text
   function Invoke-SyncErrorAcknowledgement([string]$Digest,[string]$AcknowledgementReason){
       if($Digest-notmatch'^[0-9A-Fa-f]{64}$'-or[string]::IsNullOrWhiteSpace($AcknowledgementReason)){throw 'SYNC_ACK_HASH_AND_REASON_REQUIRED'}
       $Digest=$Digest.ToUpperInvariant()
       $ackLease=Enter-SyncErrorLock
       try{
           if(!(Test-Path -LiteralPath $errLog -PathType Leaf)-or!(Get-Item -LiteralPath $errLog).Length){throw 'SYNC_ACK_NO_ACTIVE_ERRORS'}
           if((Get-FileHash -LiteralPath $errLog -Algorithm SHA256).Hash-cne$Digest){throw 'SYNC_ACK_STALE_HASH'}
           $ackId=[guid]::NewGuid().ToString('N')
           $archiveName="sync-errors-ack-$Digest-$ackId.log"
           $archivePath=Join-Path (Split-Path $errLog -Parent) $archiveName
           $archiveStream=[IO.File]::Open($archivePath,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
           try{
               $activeStream=[IO.File]::OpenRead($errLog)
               try{$activeStream.CopyTo($archiveStream);$archiveStream.Flush($true)}finally{$activeStream.Dispose()}
           }finally{$archiveStream.Dispose()}
           if((Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash-cne$Digest){throw 'SYNC_ACK_ARCHIVE_COPY_MISMATCH'}
           (Get-Item -LiteralPath $archivePath).IsReadOnly=$true
           # This operation has a unique event identity, not an invented transcript/session identity.
           $ackPattern="sync-errors-ack-$ackId";$ackSession=''
           $ackSummary="Acknowledged sync-errors SHA256 ${Digest}: $($AcknowledgementReason.Trim())"
           $ackEvidence="work\$archiveName"
           $ackOutput=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Events.ps1') -Root $Root -Add -Pattern $ackPattern -Session $ackSession -Source sync-ack -Category observation -Cause confirmed -Status resolved -Summary $ackSummary -Evidence $ackEvidence -Tool 'Sync-Sessions.ps1 -AcknowledgeErrors' -Action $AcknowledgementReason.Trim() -Tags 'archive sync errors acknowledgement' 2>&1)
           if($LASTEXITCODE-ne0){throw 'SYNC_ACK_EVENT_FAILED'}
           $ackJournal=Join-Path $Root 'events\events.jsonl'
           $ackRecords=@(if(Test-Path -LiteralPath $ackJournal){foreach($ackLine in [IO.File]::ReadAllLines($ackJournal)){
               try{$ackRecord=$ackLine|ConvertFrom-Json -DateKind String}catch{continue}
               if($ackRecord.pattern-ceq$ackPattern-and$ackRecord.session-ceq$ackSession-and$ackRecord.source-ceq'sync-ack'-and$ackRecord.status-ceq'resolved'-and$ackRecord.summary-ceq$ackSummary-and$ackRecord.evidence-ceq$ackEvidence-and$ackRecord.action-ceq$AcknowledgementReason.Trim()){$ackRecord}
           }})
           if($ackRecords.Count-ne1){throw 'SYNC_ACK_EVENT_NOT_VERIFIED'}
           # Both objects must still be the bytes reviewed and recorded before retiring the active log.
           if((Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash-cne$Digest){throw 'SYNC_ACK_ARCHIVE_MISMATCH'}
           if((Get-FileHash -LiteralPath $errLog -Algorithm SHA256).Hash-cne$Digest){throw 'SYNC_ACK_ACTIVE_CHANGED'}
           [IO.File]::Delete($errLog)
           "SESSIONS: acknowledged SHA256 $Digest -> $archivePath (event $ackPattern)"
       }finally{try{$ackLease.ReleaseMutex()}finally{$ackLease.Dispose()}}
   }

   ```

   e) replace the line
   ```text
       $old=@{};if(Test-Path $indexPath){foreach($l in [IO.File]::ReadAllLines($indexPath)){if($l){try{$o=$l|ConvertFrom-Json -AsHashtable;$old["$($o.client)/$($o.id)"]=$o}catch{Write-SyncError 'index.jsonl line' $_}}}}
   ```
   with
   ```text
       $old=@{};if(Test-Path $indexPath){foreach($l in [IO.File]::ReadAllLines($indexPath)){if($l){try{$o=$l|ConvertFrom-Json -AsHashtable -DateKind String;$old["$($o.client)/$($o.id)"]=$o}catch{Write-SyncError 'index.jsonl line' $_}}}}
   ```

   f) immediately after the line
   ```text
   if($Library){return}
   ```
   insert
   ```text
   if($AcknowledgeErrors-or$PSBoundParameters.ContainsKey('ExpectedSHA256')-or$PSBoundParameters.ContainsKey('Reason')){
       try{
           if(!$AcknowledgeErrors-or$Follow-or!$PSBoundParameters.ContainsKey('Root')){throw 'SYNC_ACK_EXPLICIT_ROOT_AND_MODE_REQUIRED'}
           Invoke-SyncErrorAcknowledgement $ExpectedSHA256 $Reason
           exit 0
       }catch{[Console]::Error.WriteLine("SESSIONS: acknowledgement FAILED; active errors retained ($($_.Exception.Message))");exit 3}
   }
   ```

   The resulting file's Git blob is 59b642453909281d141cfb1389f11658963524b5.

2. Check whether `lib/Events.ps1` contains `-ceq$Evidence`; if so record Already Applied when its Git blob is f1ca005f9dee8e656cb160d25250d243ab7f769d, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy archiver only), each matched once, and change nothing else:

   a) replace the line
   ```text
           $last=@(Read-Events|Where-Object{$_.pattern-eq$Pattern-and$_.session-eq$Session-and$_.summary-eq$Summary-and$_.status-eq$Status-and"$($_.owner)"-eq$Owner-and"$($_.action)"-eq$Action-and"$($_.due)"-eq$Due})
   ```
   with
   ```text
           $last=@(Read-Events|Where-Object{$_.pattern-eq$Pattern-and$_.session-eq$Session-and$_.summary-eq$Summary-and$_.status-eq$Status-and"$($_.owner)"-eq$Owner-and"$($_.action)"-eq$Action-and"$($_.due)"-eq$Due-and"$($_.evidence)"-ceq$Evidence})
   ```

   The resulting file's Git blob is f1ca005f9dee8e656cb160d25250d243ab7f769d.

3. Check whether `lib/Hunt.ps1` contains `currentEvidence`; if so record Already Applied when its Git blob is eb776d907e9699d249d778585aba7f94a1dfdc27, and otherwise stop and report. Otherwise make exactly these 4 edits (trustworthy archiver only), each matched once, and change nothing else:

   a) replace the line
   ```text
   $missingEv=@($events|Where-Object{$_.evidence-match'^(?:[A-Za-z]:\\|work\\|sessions\\|lib\\)'}|Where-Object{
   ```
   with
   ```text
   # Current evidence follows the latest nonempty citation, even when later assignment metadata has none.
   # Stable timestamp ordering makes the last appended record win ties without rewriting journal history.
   $currentEvidence=@($events|Where-Object{![string]::IsNullOrWhiteSpace($_.evidence)}|Group-Object pattern|ForEach-Object{@($_.Group|Sort-Object at -Stable)[-1]})
   $missingEv=@($currentEvidence|Where-Object{$_.evidence-match'^(?:[A-Za-z]:\\|work\\|sessions\\|lib\\)'}|Where-Object{
   ```

   b) immediately after the line
   ```text
       $t=Join-Path ([IO.Path]::GetTempPath()) "orvion-hunt-$([guid]::NewGuid().ToString('N').Substring(0,6))"
   ```
   insert
   ```text
       . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   ```

   c) replace the line
   ```text
               if(Test-Path $t){Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
               if(Test-Path $t){$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}
   ```

   d) replace the line
   ```text
       }finally{if(Test-Path $t){Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}}
   ```
   with
   ```text
       }finally{if(Test-Path $t){$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}}
   ```

   The resulting file's Git blob is eb776d907e9699d249d778585aba7f94a1dfdc27.

4. Check whether `lib/test-sync-sessions-ack.ps1` contains `SYNC_ACK_SELFCHECK`; if so record Already Applied when its Git blob is 02510fabab291f9cdf1354009b1c005003e4a820, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (trustworthy archiver only), and change nothing else:

   ```text
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
   ```

   The resulting file's Git blob is 02510fabab291f9cdf1354009b1c005003e4a820.

5. Check whether `lib/test-sync-sessions-survival.ps1` contains `SortProbeOnly`; if so record Already Applied when its Git blob is 52106cd3d7dfda97f1dc55cab146ae6493acb440, and otherwise stop and report. Otherwise make exactly these 5 edits (trustworthy archiver only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([switch]$RootProbeOnly)
   ```
   with
   ```text
   param([switch]$RootProbeOnly,[switch]$SortProbeOnly)
   ```

   b) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   ```

   c) immediately after the lines
   ```text
   $fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
   try{
   ```
   insert
   ```text
       if(!$RootProbeOnly){
           # One cached September DateTime among 16 new October strings broke the en-US comparer at 17 rows.
           & {
               $sortStore=Join-Path $t 'sort-store';$sortCulture=[cultureinfo]::CurrentCulture
               . (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $sortStore -ClaudeProjects (Join-Path $t 'no-sort-claude') -CodexSessions (Join-Path $t 'no-sort-codex')
               try{
                   [cultureinfo]::CurrentCulture='en-US';$script:failures=0
                   [void][IO.Directory]::CreateDirectory((Join-Path $raw 'codex'))
                   foreach($sortNumber in 0..16){
                       $sortId='f{0:00}' -f $sortNumber
                       $sortStamp=if($sortNumber-eq8){'2026-09-12T00:00:00Z'}else{'2026-10-20T23:42:00Z'}
                       [IO.File]::WriteAllText((Join-Path $raw "codex\$sortId.jsonl"),('{"timestamp":"'+$sortStamp+'"}'+"`n"))
                   }
                   $sortCachedPath=Join-Path $raw 'codex\f08.jsonl'
                   $sortCached=New-IndexRow 'codex' 'f08';$sortCached.headHash=Get-HeadHash $sortCachedPath
                   Update-Meta $sortCached $sortCachedPath 'codex'
                   [IO.File]::WriteAllText($indexPath,($sortCached|ConvertTo-Json -Compress -Depth 4)+"`n")
                   Assert-That 'sort fixture seeds an ISO cache read as DateTime without DateKind String' (([IO.File]::ReadAllText($indexPath)|ConvertFrom-Json -AsHashtable).start-is[datetime])
                   foreach($sortPass in 1..2){
                       $sortRows=@()
                       try{Invoke-Pass;$sortRows=@(Update-Index)}catch{Write-SyncError 'sort fixture pass' $_}
                       Assert-That "sort pass $sortPass keeps all 17 archive rows" ($sortRows.Count-eq17-and(@($sortRows.id|Sort-Object -Unique)-join',')-ceq(@(0..16|ForEach-Object{'f{0:00}' -f $_})-join','))
                       Assert-That "sort pass $sortPass keeps start and end as strings" ($sortRows.Count-eq17-and!@($sortRows|Where-Object{$_.start-isnot[string]-or$_.end-isnot[string]}).Count)
                       Assert-That "sort pass $sortPass writes both indexes without sync errors" ($script:failures-eq0-and!(Test-Path -LiteralPath $errLog)-and(Test-Path -LiteralPath $indexPath)-and(Test-Path -LiteralPath (Join-Path $Root 'sessions\INDEX.md')))
                   }
               }finally{[cultureinfo]::CurrentCulture=$sortCulture}
           }
           if($SortProbeOnly){if($fail){throw 'SYNC_SORT_PROBE_FAILED'};'SYNC_SORT_PROBE PASS';return}
       }
   ```

   d) replace the line
   ```text
               if($case-eq'fallback'){[IO.Directory]::Delete($sibling,$true)}else{[void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))}
   ```
   with
   ```text
               if($case-eq'fallback'){$null=Remove-OrvionOwnedTree -Path $sibling -AllowedRoots @($t)}else{[void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))}
   ```

   e) replace the line
   ```text
   }finally{[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
   }finally{$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}
   ```

   The resulting file's Git blob is 52106cd3d7dfda97f1dc55cab146ae6493acb440.

6. Check whether `lib/test-events.ps1` contains `EvidenceProbeOnly`; if so record Already Applied when its Git blob is 019d5867d8971ea05d18d23c5779b0ff0046e43a, and otherwise stop and report. Otherwise make exactly these 4 edits (trustworthy archiver only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([switch]$RootProbeOnly,[string]$RelativeTool)
   ```
   with
   ```text
   param([switch]$RootProbeOnly,[string]$RelativeTool,[switch]$EvidenceProbeOnly)
   ```

   b) immediately after the lines
   ```text
   param([switch]$RootProbeOnly,[string]$RelativeTool,[switch]$EvidenceProbeOnly)
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   ```

   c) immediately after the lines
   ```text
   $fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
   try{
   ```
   insert
   ```text
       if(!$RootProbeOnly){
           $evidenceStore=Join-Path $t 'evidence-correction'
           $null=& $ev -Root $evidenceStore -Add -Pattern evidence-correction -Session same-session -Summary 'suite completed' -Evidence 'work\wrong.log'
           $corrected=& $ev -Root $evidenceStore -Add -Pattern evidence-correction -Session same-session -Summary 'suite completed' -Evidence 'work\correct.log'
           $repeated=& $ev -Root $evidenceStore -Add -Pattern evidence-correction -Session same-session -Summary 'suite completed' -Evidence 'work\correct.log'
           $evidenceRows=@([IO.File]::ReadAllLines((Join-Path $evidenceStore 'events\events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json})
           Assert-That 'evidence-only correction is appended and an identical correction is deduplicated' ($corrected-match'EVENT RECORDED'-and$repeated-match'EVENT DUPLICATE'-and$evidenceRows.Count-eq2-and$evidenceRows[-1].evidence-ceq'work\correct.log'-and$evidenceRows[0].evidence-ceq'work\wrong.log')
           if($EvidenceProbeOnly){if($fail){throw 'EVENTS_EVIDENCE_PROBE_FAILED'};'EVENTS_EVIDENCE_PROBE PASS';return}
       }
   ```

   d) replace the line
   ```text
   }finally{[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
   }finally{$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}
   ```

   The resulting file's Git blob is 019d5867d8971ea05d18d23c5779b0ff0046e43a.

7. Check whether `lib/test-hunt.ps1` contains `EvidenceProbeOnly`; if so record Already Applied when its Git blob is d96dae2a14d445b41c72ebca0eb63c6cb4e688ad, and otherwise stop and report. Otherwise make exactly these 5 edits (trustworthy archiver only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([switch]$RootProbeOnly)
   ```
   with
   ```text
   param([switch]$RootProbeOnly,[switch]$EvidenceProbeOnly)
   ```

   b) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   ```

   c) immediately after the lines
   ```text
   $fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
   try{
   ```
   insert
   ```text
       if(!$RootProbeOnly){
           $evidenceRoot=Join-Path $t 'evidence';[void][IO.Directory]::CreateDirectory((Join-Path $evidenceRoot 'events'))
           [void][IO.Directory]::CreateDirectory((Join-Path $evidenceRoot 'work'))
           [IO.File]::WriteAllText((Join-Path $evidenceRoot 'work\correct.log'),'fixture')
           $evidenceEvents=@(
               [ordered]@{at='2026-10-20T00:00:00Z';pattern='corrected';evidence='work\wrong.log (38.027 min)';status='resolved'}
               [ordered]@{at='2026-10-26T00:00:00Z';pattern='corrected';evidence='work\correct.log (38.027 min)';status='resolved'}
               [ordered]@{at='2026-10-26T01:00:00Z';pattern='corrected';evidence='';status='resolved'}
               [ordered]@{at='2026-10-26T00:00:00Z';pattern='independent';evidence='work\still-missing.log';status='resolved'}
               # An empty latest update cannot erase a missing citation either.
               [ordered]@{at='2026-10-26T01:00:00Z';pattern='independent';evidence='';status='resolved'}
               # Many equal timestamps followed by an older backfill expose an unstable tie ordering.
               foreach($tieIndex in 0..15){[ordered]@{at='2026-10-26T00:00:00Z';pattern='equal-time';evidence=$(if($tieIndex-eq15){'work\correct.log'}else{'work\wrong.log'});status='open'}}
               [ordered]@{at='2000-01-01T00:00:00Z';pattern='equal-time';evidence='work\wrong.log';status='open'}
           )
           $evidenceJournal=Join-Path $evidenceRoot 'events\events.jsonl'
           [IO.File]::WriteAllLines($evidenceJournal,[string[]]@($evidenceEvents|ForEach-Object{$_|ConvertTo-Json -Compress}))
           $evidenceHash=(Get-FileHash -LiteralPath $evidenceJournal).Hash
           $evidenceLauncher=Join-Path $t 'evidence-probe.ps1'
           [IO.File]::WriteAllText($evidenceLauncher,@'
   param([string]$Hunt,[string]$Store)
   function Get-Process { @() }
   function Get-CimInstance { @() }
   & $Hunt -Root $Store -DataRoot $Store -Quick -NoRecord
   exit $LASTEXITCODE
   '@)
           $evidenceOutput=@(& pwsh -NoProfile -File $evidenceLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $evidenceRoot)
           $evidenceCode=$LASTEXITCODE
           $evidenceGap=@($evidenceOutput|Where-Object{$_-match'GAP event-evidence:'})-join' '
           Assert-That 'latest nonempty corrected evidence replaces historical missing paths' ($evidenceCode-eq0-and$evidenceGap-notmatch'corrected')
           Assert-That 'resolved missing evidence survives a later empty metadata update' ($evidenceGap-match'independent')
           Assert-That 'equal timestamp evidence uses last journal record despite older backfill' ($evidenceGap-notmatch'equal-time')
           Assert-That 'evidence projection never rewrites the append-only journal' ((Get-FileHash -LiteralPath $evidenceJournal).Hash-ceq$evidenceHash)
           if($EvidenceProbeOnly){if($fail){throw 'HUNT_EVIDENCE_PROBE_FAILED'};'HUNT_EVIDENCE_PROBE PASS';return}
       }
   ```

   d) replace the line
   ```text
               if($case-eq'fallback'){[IO.Directory]::Delete($sibling,$true)}else{[void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))}
   ```
   with
   ```text
               if($case-eq'fallback'){$null=Remove-OrvionOwnedTree -Path $sibling -AllowedRoots @($t)}else{[void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))}
   ```

   e) replace the line
   ```text
   }finally{$env:USERPROFILE=$savedProfile;Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
   }finally{$env:USERPROFILE=$savedProfile;$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}
   ```

   The resulting file's Git blob is d96dae2a14d445b41c72ebca0eb63c6cb4e688ad.

8. Check whether `lib/test-events-retrieval.ps1` contains `Remove-OrvionOwnedTree`; if so record Already Applied when its Git blob is 8000e1c77ed09992f98cb2de82168f7b91b7d6d7, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy archiver only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   ```

   b) replace the line
   ```text
   }finally{[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
   }finally{$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}
   ```

   The resulting file's Git blob is 8000e1c77ed09992f98cb2de82168f7b91b7d6d7.

9. Check whether `lib/test-sync-sessions-append.ps1` contains `Remove-OrvionOwnedTree`; if so record Already Applied when its Git blob is c0d15b8b388ee2c6aa3866341dc58dc247d411cc, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy archiver only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   ```

   b) replace the line
   ```text
   }finally{Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
   }finally{$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}
   ```

   The resulting file's Git blob is c0d15b8b388ee2c6aa3866341dc58dc247d411cc.

10. Check whether `lib/test-sync-sessions-rewrite.ps1` contains `Remove-OrvionOwnedTree`; if so record Already Applied when its Git blob is b7c2e4b06c0ad48d44fe832e8da8c9f44cf9aa8c, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy archiver only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   ```

   b) replace the line
   ```text
   }finally{Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
   }finally{$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}
   ```

   The resulting file's Git blob is b7c2e4b06c0ad48d44fe832e8da8c9f44cf9aa8c.

11. Check whether `lib/test-watch-reminder.ps1` contains `Remove-OrvionOwnedTree`; if so record Already Applied when its Git blob is eee48da7f3b09199b9e76cc532f9fdb8a5a49fc3, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy archiver only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   ```

   b) replace the line
   ```text
       [IO.Directory]::Delete($resolved,$true)
   ```
   with
   ```text
       $null=Remove-OrvionOwnedTree -Path $resolved -AllowedRoots @([IO.Path]::GetTempPath())
   ```

   The resulting file's Git blob is eee48da7f3b09199b9e76cc532f9fdb8a5a49fc3.

12. Check whether `lib/README.md` contains `AcknowledgeErrors`; if so record Already Applied when its Git blob is 3c7261eaad321621289f03fa67909bb6180c3a37, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy archiver only), each matched once, and change nothing else:

   a) replace the line
   ```text
   | `Sync-Sessions.ps1` | verbatim archive of every ORVION session + `sessions\index.jsonl` (hook runs it at start and end) |
   ```
   with
   ```text
   | `Sync-Sessions.ps1` | verbatim archive of every ORVION session + `sessions\index.jsonl` (hook runs it at start and end); explicit `-AcknowledgeErrors -Root <data> -ExpectedSHA256 <hash> -Reason <text>` archives reviewed errors and records their acknowledgement |
   ```

   b) immediately after the lines
   ```text
   After partial success, inspect that result and the refs, then rerun the same reviewed descriptor. An exact already-completed ref is recorded as `ALREADY_DONE` and its child is skipped; the unfinished target is attempted normally. No rollback, retry loop or history rewrite occurs. Test with `pwsh -NoProfile -File <lib>/test-owner-dual.ps1`; its real local Git/child fixtures use explicit console/transport seams and never prove actual authenticated identity or live release. Preserve the external evidence directory with local backup. CTRL-19 remains open.

   ```
   insert
   ```text
   ## Session error acknowledgement

   Hunt reports every nonempty `<data>\work\sync-errors.log` as a BUG. Review those failures and their disposition,
   then hash the reviewed file with `Get-FileHash -LiteralPath '<data>\work\sync-errors.log' -Algorithm SHA256`.
   Run `pwsh -NoProfile -File lib\Sync-Sessions.ps1 -Root '<data>' -AcknowledgeErrors -ExpectedSHA256 '<hash>' -Reason '<review and disposition>'`.
   An explicit root, exact current hash and nonempty reason are required; acknowledgement cannot accompany `-Follow`.

   A short per-log mutex shared with the error writer protects the reviewed bytes. The command creates a new readonly
   `<data>\work\sync-errors-ack-<SHA256>-<id>.log`, verifies its bytes, appends and verifies a unique event containing its
   digest, reason and archive path, then retires the matching active log. The follower's lifetime mutex is independent.
   Success returns 0. A stale hash or any archive/event/retirement failure returns 3 and leaves the active log blocking.
   Retain acknowledgement archives and the journal for recovery. New failures create a new active log and block Hunt
   again; an acknowledgement records disposition of the reviewed errors, rather than proving a healthy sync.

   For event evidence, Hunt checks the latest nonempty citation per pattern, ordered by `at` with journal order breaking
   ties. Append corrections under the same pattern with corrected `-Evidence`; later empty assignment metadata inherits
   that citation, and resolved status alone does not excuse a missing path. `test-sync-sessions-ack.ps1` owns refusal and
   concurrency fixtures; `test-ws020-mutants.ps1 -Mutant <id>` runs a direct focused negative probe (`All` runs every mutant).

   ```

   The resulting file's Git blob is 3c7261eaad321621289f03fa67909bb6180c3a37.

13. Check whether `docs/RECOVERY.md` contains `AcknowledgeErrors`; if so record Already Applied when its Git blob is fa981110dc9f340ad61b3bd780ae79fad828566e, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy archiver only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
      Claude Code runs this checkout's `lib\hooks\Watch-Reminder.ps1`; it starts the session archiver (`lib\Sync-Sessions.ps1`) with that data root.
   ```
   insert
   ```text
      If Hunt reports `BUG sync-errors`, inspect `<data>\work\sync-errors.log` and address its cause. To acknowledge
      exactly those reviewed bytes, obtain `Get-FileHash -LiteralPath '<data>\work\sync-errors.log' -Algorithm SHA256`, then
      run `pwsh -NoProfile -File lib\Sync-Sessions.ps1 -Root '<data>' -AcknowledgeErrors -ExpectedSHA256 '<hash>' -Reason '<what was reviewed and its disposition>'`.
      This requires an explicit data root and nonempty reason. A short log lock serializes error appends with acknowledgement;
      the command verifies a new readonly archive under `<data>\work\`, appends and verifies its journal event, then retires
      the matching active log. A stale hash or any archive/event/retirement failure returns exit 3 and retains the active log.
      Keep the archive and journal in the recovery package. Subsequent failures create a new active log and block Hunt again;
      rerun `lib\Hunt.ps1 -Root '<checkout>' -DataRoot '<data>' -Quick -NoRecord` to observe the current result.
   ```

   The resulting file's Git blob is fa981110dc9f340ad61b3bd780ae79fad828566e.

## Acceptance Criteria

- [ ] Exact approved scoped output. check: blob:lib/Sync-Sessions.ps1=59b642453909281d141cfb1389f11658963524b5
- [ ] Exact approved scoped output. check: blob:lib/Events.ps1=f1ca005f9dee8e656cb160d25250d243ab7f769d
- [ ] Exact approved scoped output. check: blob:lib/Hunt.ps1=eb776d907e9699d249d778585aba7f94a1dfdc27
- [ ] Exact approved scoped output. check: blob:lib/test-sync-sessions-ack.ps1=02510fabab291f9cdf1354009b1c005003e4a820
- [ ] Exact approved scoped output. check: blob:lib/test-sync-sessions-survival.ps1=52106cd3d7dfda97f1dc55cab146ae6493acb440
- [ ] Exact approved scoped output. check: blob:lib/test-events.ps1=019d5867d8971ea05d18d23c5779b0ff0046e43a
- [ ] Exact approved scoped output. check: blob:lib/test-hunt.ps1=d96dae2a14d445b41c72ebca0eb63c6cb4e688ad
- [ ] Exact approved scoped output. check: blob:lib/test-events-retrieval.ps1=8000e1c77ed09992f98cb2de82168f7b91b7d6d7
- [ ] Exact approved scoped output. check: blob:lib/test-sync-sessions-append.ps1=c0d15b8b388ee2c6aa3866341dc58dc247d411cc
- [ ] Exact approved scoped output. check: blob:lib/test-sync-sessions-rewrite.ps1=b7c2e4b06c0ad48d44fe832e8da8c9f44cf9aa8c
- [ ] Exact approved scoped output. check: blob:lib/test-watch-reminder.ps1=eee48da7f3b09199b9e76cc532f9fdb8a5a49fc3
- [ ] Exact approved scoped output. check: blob:lib/README.md=3c7261eaad321621289f03fa67909bb6180c3a37
- [ ] Exact approved scoped output. check: blob:docs/RECOVERY.md=fa981110dc9f340ad61b3bd780ae79fad828566e
- [ ] The owning tests prove: a 17-file archive whose cached index start is a DateTime and whose new rows are strings survives two index passes with every row kept and string start/end, no sync error; an evidence-only correction is recorded and its exact repeat is a duplicate; Hunt reports a GAP only for the latest nonempty evidence per pattern (empty updates inherit, resolved status alone clears nothing, the later appended record wins equal timestamps); -AcknowledgeErrors refuses a stale hash or blank reason, keeps the blocking log on any archive or event failure, verifies the immutable archive and the recorded event before retiring the log, and a concurrent new error blocks again.
- [ ] Mandatory V1/V2/V3, focused proof, planted-regression mutants, accepted literal replay controls and the real read-only measurement are preserved. One isolated native timed/watched Finish owns the full schedule (growing by exactly lib/test-sync-sessions-ack.ps1) with a fresh SANDBOX receipt before original approval; the original needs its own fresh Finish, live Review, native Complete and an independent carrying-range READY.

## Review Gate

- [ ] Inspect the thirteen scoped files, the focused/mutant/literal evidence and the real read-only measurement; preserve all frozen prior evidence.
- [ ] Independently check the native receipt root/Draft/recipe/evaluator/fingerprint, ordered tests and timed/watcher/host exits; normal native Review/Complete and every new carrying transition must pass. No second-agent or provider certification is claimed.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Decision D23 in C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\DECISIONS.md (under D19/D20/D21/D22 and D12). Codex investigated at xhigh effort (before pass, codex\before1-report.txt) and implemented at high effort (codex\impl1-report.txt) in disposable C:\cx\ORVION-ws020 under orchestrator verification. Under the owner's exceptional delegation this one Workbench contract is authorized. Gate 1 for this Draft is DELEGATED: the owner did not type its digest. Sandbox approval is synthetic and grants no original authority.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws020-package\assurance\V3\DRAFT.md
Approved SHA256: F451F57B8B2676CDA83B4B12032374D74B2ABFE62A1A39FC08C4C9CEF84627F0
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\GATE1-WS020-DELEGATED.md
Owner Evidence SHA256: 48899B6B39AD3A97B30544374AE6E92877B66DFF81BF2B3B149B8062AFC26DB1
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws020-package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: EA717ECB6FBCA5A57481C3C8495F112ED70E01D79D83C5DD47865A53BF743E4C
Original admission: DELEGATED exact Gate 1 under the owner's exceptional delegation of 2026-10-26 (OWNER-DELEGATION.md SHA-256 94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217; decisions D1-D23; D23 is the delegated decision for this contract). The owner did not type this digest. Bound to this literal root, the exact V3 digest and the fresh sandbox receipt; no sandbox receipt transplant as original certification.

## Verification Notes

Exposed by WS-019: the original Finish preflight Hunt, now reading the real store, blocked on a real archiver failure (D22). Codex proved its cause with a deterministic 17-row reproducer (DateTime and string start values; comparer antisymmetry violated) and the real Update-Index on a synthetic archive; the orchestrator reproduced it on this en-US machine. Codex's direct runner kills 20 mutants (codex-mutants.log, run from a copy of the prototype lib; kept out of the repository so it does not grow every Finish); the orchestrator's independent planted regressions are detected (mutants.log); hazard scan 0; thirteen owning self-checks PASS with an isolated ORVION_DATA_ROOT. Real read-only measurement (real-measurement.json, types and counts only): the real index read with -DateKind String yields only string start values and sorts; the new evidence rule versus the old one on the real journal.

## Selection reasons and sources

Evidence Refresh: focused-selected.log PASS for thirteen owning self-checks on the selected bytes, 20 Codex mutants plus independent planted regressions detected, hazard scan 0, real read-only measurement, literal replay controls run before the one sandbox Finish. Baseline 640cd27 (main = preflight = WS-019), accepted judge 835E14DA unchanged.

Sources: DECISIONS.md D19-D23, ws020-package\codex, accepted WORKFLOW/TEMPLATE/checker, WS-019 packet scripts, the real read-only measurement.
