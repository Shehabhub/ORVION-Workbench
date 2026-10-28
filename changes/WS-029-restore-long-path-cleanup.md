# Workbench Change Request - WS-029

## Status

[x] Draft
[ ] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Implement owner-selected Candidate C (2026-10-28): successful mandatory recovery intentionally retains its owned staging and reports READY plus absolute staging location/status/purpose; failed recovery retains owned staging, keeps the original failure exit and withholds READY. Remove the baseline launcher's automatic recursive attribute/deletion block. Keep extraction, validation, local bundle checkout, Restore-Workspace -From, temporary preparation, map task, requested products and checklist/error propagation. Each default attempt uses a fresh timestamp-plus-GUID child of Target/ORVION-Workbench-temporary/restore-staging; explicit existing staging is refused unchanged. Add only necessary placement and disk preflight checks and truthful sensitivity/accumulation guidance. This supersedes deletion-specific V1/V2 semantics only; frozen history and native gates remain.

## Baseline

751c324248d040a6c5efab59c37859d00fc7ac28

## Write Scope

- RESUME.md
- docs/RECOVERY.md
- lib/Restore-ORVION.ps1
- lib/test-restore-orvion.ps1

## Out of Scope

Engineering edits are limited to lib/Restore-ORVION.ps1, lib/test-restore-orvion.ps1 and docs/RECOVERY.md, plus the native contract and RESUME bookkeeping required by the actual governed workflow. codex/ contains review/delegate artifacts only. The orchestrator owns packet literals, declared blobs, execution context, assurance, mutant scaffolding and native scope amendments; these do not authorize additional product engineering changes.

Excluded engineering work: automatic retained-staging cleanup or purging; a cleanup helper/walker, retention registry or service; handle/API resolver redesign, low-level Windows API work, UNC deletion or retained-entry attribute clearing; unrelated dependency, service, installer, machine-setting, registry or ACL changes; product changes; and changes to Backup-Workspace or Restore-Workspace independent cleanup. Existing prerequisite installation, restore, temporary preparation, map-task and requested product behavior remain within their existing governed recovery recipe. No new dependencies or purge system are introduced.

Private Owner-Tools data, real sessions, client-home contents, secrets and retained recovery data must not be included in public source, contracts or review artifacts. Sensitive unencrypted staging accumulates outside the guarded permanent repository/private/client/known OneDrive locations. Its disposal is a separate task requiring separate owner authority; this contract introduces no disposal authority or mechanism.

This delegate's execution authority is limited to its supplied review brief. It may not run full tests.ps1, lifecycle/Finish, a real restore, installers, network operations, agent CLIs or nested agents, or perform commits, push, freeze, approval or release; it may not read private Owner-Tools, real sessions or client homes. These are delegate execution limits, not prohibitions on the contract's governed lifecycle.

All unchanged mandatory native gates remain required under their actual separate authority: accepted literal replay controls; one native timed/watched sandbox Finish running the unchanged full tests.ps1 schedule and producing a fresh SANDBOX receipt before original approval; exact qualified Draft/root-bound delegated approval where authorized; original implementation and original Finish; live Review; native Complete; and independent carrying-range READY. Required governed commits and bookkeeping remain available to the authorized lifecycle operator. Freeze, approval, publication/push, promotion, release and remote certification remain separate qualified operations requiring their actual governing authority and evidence; this review grants none of them and substitutes for none of their gates.

HANDOFF criterion 5 and Step 3 remain separate real-run work: an isolated run of the released launcher against a fresh package, with isolated roots/environment, real map-task XML backup/restore, external logs, all three Boots, memory-key checks and the same fresh archive's cloud round-trip. Fixture evidence does not prove this run. Only the deletion-specific success expectation changes to successful mandatory recovery with intentionally retained staging and location/status output.

No clean-Windows installation, atomic namespace containment, exhaustive native alias/sync-provider support, absence of secrets, Step 3 completion or release is claimed. Frozen V1/V2 and prior deletion/race evidence remain unchanged. CTRL-19 remains OPEN and Batch 6 remains ON HOLD absent its own owner lift.

## Draft Assurance

V1: WS029-RESTORE-LONGPATH-DESIGN | 2026-10-28 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-029\package\assurance\V1\DRAFT.md | 8282B71EA6A1EBB559743278A29B2197D110500C3FCE89BD45A0D4E18CE68D8A
V2: WS029-RESTORE-LONGPATH-ADVERSARIAL | 2026-10-28 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-029\package\assurance\V2\DRAFT.md | DDDF89FA29C56C40658E15398DB7E4BE00BC11647BC01DE798878D424348A50F
V3: WS029-RESTORE-LONGPATH-REFRESH | 2026-10-28 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-029\package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W29
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W29\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W29\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-029\package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `docs/RECOVERY.md` contains `a READY/ACTION checklist and pauses. Owner-selected Candidate C (2026-10-28) intentionally retains staging on both`; if so record Already Applied when its Git blob is fe6db116722620736c776f4a9af068682ff4cdf4, and otherwise stop and report. Otherwise make exactly these 2 edits (owner-approved retained recovery staging, reporting, placement and extraction capacity checks (D43)), each matched once, and change nothing else:

   a) replace the lines
   ```text
   a READY/ACTION checklist and pauses. Restore failure retains staging for diagnosis; restore success removes staging.
   An existing staging folder is refused; inspect a failed/partial restore before removing anything or retrying.
   ```
   with
   ```text
   a READY/ACTION checklist and pauses. Owner-selected Candidate C (2026-10-28) intentionally retains staging on both
   success and failure. READY requires every requested mandatory operation and the checklist to succeed; a failure keeps
   its failure exit and withholds READY. Output names the absolute owned staging path, its completed/failed status and purpose.
   Each default attempt uses a new timestamp-plus-GUID child of `<Target>\ORVION-Workbench-temporary\restore-staging`.
   An explicit existing staging folder is refused without alteration. Attempts accumulate; inspect their reported locations.
   Staging must remain outside permanent Git repositories, Owner-Tools, Claude/Codex homes and known OneDrive roots,
   including managed reparse aliases. Managed path checks are not atomic namespace protection. Native mapped/subst and
   unknown sync providers are not comprehensively identified; do not use those aliases to place retained recovery data.

   Before extraction the launcher reads `7z l -slt -ba` entry sizes and snapshots available bytes on the staging volume.
   It requires the summed expanded logical bytes plus a separate 64 MiB allowance for metadata/allocation headroom;
   unreadable/malformed evidence or insufficient space refuses before extraction with a disk action. This is not a
   compressed-size multiplier, a space reservation, exact physical allocation accounting, or a guarantee of capacity for
   later clone, restore and product work. Check additional free space for those operations separately.

   Retained extraction is sensitive and unencrypted: owner records/sessions, settings and Git bundles can contain secrets.
   URL-password masking and credential exclusions do not prove otherwise; gitleaks scans files, not bundle history.
   Use an owner-controlled local location with appropriate existing access protection; keep it outside sync and repositories.
   The launcher does not change ACLs or machine settings. Review accumulated attempts after verification and obtain separate
   owner authorization before disposal. Retained housekeeping alone does not make an otherwise successful restore fail.
   The launcher's `Restore-Workspace -From` route does not run the child's independent `-Package` extraction cleanup;
   Backup/Restore-Workspace cleanup is unchanged.
   ```

   b) replace the line
   ```text
   Use new empty paths; restore never overwrites repositories. Delete staging after success, run CRM/ORVION
   ```
   with
   ```text
   Use new empty paths; restore never overwrites repositories. Retain staging for review and separately owner-authorized disposal; run CRM/ORVION
   ```

   The resulting file's Git blob is fe6db116722620736c776f4a9af068682ff4cdf4.

2. Check whether `lib/Restore-ORVION.ps1` contains `$full=[IO.Path]::GetFullPath($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path))`; if so record Already Applied when its Git blob is 6a6280949b89fdb2564d3e3392fd8ec88ad40c37, and otherwise stop and report. Otherwise make exactly these 8 edits (owner-approved retained recovery staging, reporting, placement and extraction capacity checks (D43)), each matched once, and change nothing else:

   a) replace the line
   ```text
       $full=[IO.Path]::GetFullPath($Path)
   ```
   with
   ```text
       $full=[IO.Path]::GetFullPath($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path))
   ```

   b) immediately after the lines
   ```text
       $script:NativeExitCode=$LASTEXITCODE
   }
   ```
   insert
   ```text
   function Get-RecoveryExpandedBytes([string]$Archive){
       $listing=@(Invoke-RecoveryProcess (Get-RecoveryTool '7z') @('l','-slt','-ba',$Archive))
       if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw 'RECOVERY_DISK_METADATA_UNREADABLE'}
       [long]$total=0;$entries=0
       foreach($block in (($listing-join"`n")-split'\r?\n\s*\r?\n')){
           if(!$block.Trim()){continue}
           $paths=[regex]::Matches($block,'(?m)^Path = .+\r?$')
           $sizes=[regex]::Matches($block,'(?m)^Size = ([0-9]+)\r?$')
           [long]$size=0
           if($paths.Count-ne1-or$sizes.Count-ne1-or![long]::TryParse($sizes[0].Groups[1].Value,[ref]$size)-or$size-gt([long]::MaxValue-$total)){throw 'RECOVERY_DISK_METADATA_UNREADABLE'}
           $total+=$size;$entries++
       }
       if(!$entries){throw 'RECOVERY_DISK_METADATA_UNREADABLE'}
       return $total
   }
   function Get-RecoveryFreeBytes([string]$Path){
       try{
           $drive=New-Object IO.DriveInfo ([IO.Path]::GetPathRoot($Path))
           if(!$drive.IsReady){throw 'not ready'}
           return $drive.AvailableFreeSpace
       }catch{throw 'RECOVERY_DISK_SPACE_UNREADABLE'}
   }
   ```

   c) replace the line
   ```text
           if(!$Staging){$Staging=Join-Path $Target ('ORVION-Workbench-temporary\restore-staging\'+[DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffffffZ'))}
   ```
   with
   ```text
           if(!$Staging){$Staging=Join-Path $Target ('ORVION-Workbench-temporary\restore-staging\'+[DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffffffZ')+'-'+[guid]::NewGuid().ToString('N'))}
           $Staging=[IO.Path]::GetFullPath($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Staging))
   ```

   d) immediately after the lines
   ```text
               if($actual-ieq$actualStage-or$actual.StartsWith($actualStage+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'RECOVERY_DESTINATION_IN_STAGING'}
           }
   ```
   insert
   ```text
           $protected=@((Join-Path $Target 'ORVION-Workbench'),(Join-Path $Target 'ORVION-Workbench-trusted-main'),(Join-Path $Target 'ORVION-Owner-Tools'),(Join-Path $Target 'CRM'),(Join-Path $Target 'CRM-trusted-main'),(Join-Path $Target 'ORVION'),(Join-Path $Target 'ORVION-trusted-main'),$ClaudeHome,$CodexHome,(Join-Path $env:USERPROFILE '.claude'),(Join-Path $env:USERPROFILE '.codex'))+@($LegacyTarget,$env:ORVION_DATA_ROOT|Where-Object{$_})
           foreach($path in $protected){
               $actual=Get-RecoveryActualPath $path
               if($actualStage-ieq$actual-or$actualStage.StartsWith($actual.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'RECOVERY_STAGING_PLACEMENT_REFUSED'}
           }
           foreach($path in @((Join-Path $env:USERPROFILE 'OneDrive'),$env:OneDrive,$env:OneDriveConsumer,$env:OneDriveCommercial)|Where-Object{$_}){
               $known=[IO.Path]::GetFullPath($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($path)).TrimEnd('\')
               if($Staging-ieq$known-or$Staging.StartsWith($known+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'RECOVERY_STAGING_PLACEMENT_REFUSED'}
               # Cloud reparse roots may expose no link Target. Staging resolution itself still
               # fails closed through such a root; do not require unrelated sync hydration.
               try{$known=Get-RecoveryActualPath $path}catch{if($_.Exception.Message-ne'RECOVERY_PATH_UNRESOLVED'){throw}}
               if($actualStage-ieq$known-or$actualStage.StartsWith($known.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'RECOVERY_STAGING_PLACEMENT_REFUSED'}
           }
           # Inspect ancestor metadata only, including independently named Git repositories.
           $ancestor=$actualStage
           while($ancestor){
               if((Split-Path $ancestor -Leaf)-ieq'ORVION-Owner-Tools'){throw 'RECOVERY_STAGING_PLACEMENT_REFUSED'}
               if(Test-Path -LiteralPath (Join-Path $ancestor '.git')){throw 'RECOVERY_STAGING_PLACEMENT_REFUSED'}
               $parent=Split-Path $ancestor -Parent
               if($parent-eq$ancestor){break};$ancestor=$parent
           }
   ```

   e) immediately after the line
   ```text
           $archive=Get-RecoveryPackage $PackageDir
   ```
   insert
   ```text
           try{$expanded=Get-RecoveryExpandedBytes $archive}catch{throw 'RECOVERY_DISK_METADATA_UNREADABLE'}
           # Separate modest headroom for filesystem metadata/allocation; not a compressed-size multiplier
           # and not a promise of capacity for later clone/restore/product preparation.
           [long]$reserve=64MB
           $free=Get-RecoveryFreeBytes $actualStage
           if($null-eq$free-or$free-isnot[long]-or$free-lt0){throw 'RECOVERY_DISK_SPACE_UNREADABLE'}
           Write-Host "STAGING DISK: expanded logical bytes=$expanded; reserve bytes=$reserve; available bytes=$free (snapshot, not reserved)"
           if($expanded-gt([long]::MaxValue-$reserve)-or$free-lt($expanded+$reserve)){throw 'RECOVERY_DISK_SPACE_INSUFFICIENT'}
   ```

   f) immediately after the line
   ```text
           Write-Host "ACTION: $code; inspect the package and requested paths before retrying"
   ```
   insert
   ```text
           if($code-like'RECOVERY_DISK_*'){Write-Host 'ACTION: verify 7z l -slt -ba metadata and staging-volume free space; free local capacity or choose another permitted -Staging, then retry'}
   ```

   g) replace the lines
   ```text
       if($ownsStaging-and$script:RecoveryExit-eq0){
           try{
               Get-ChildItem -LiteralPath $Staging -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'}
               [IO.Directory]::Delete([IO.Path]::GetFullPath($Staging),$true);$ownsStaging=$false
           }catch{$script:RecoveryExit=1;Write-Host 'ACTION: RECOVERY_STAGING_CLEANUP_FAILED'}
   ```
   with
   ```text
       if($ownsStaging){
           $status='failed';if($script:RecoveryExit-eq0){$status='completed'}
           Write-Host "ACTION: staging retained at $Staging; status=$status; purpose=extracted recovery package and bootstrap checkout"
           Write-Host 'ACTION: retained staging is sensitive and unencrypted; protect local access, inspect accumulated attempts, and obtain separate owner authorization for disposal'
   ```

   h) replace the lines
   ```text
       }
       if($ownsStaging){Write-Host "ACTION: staging retained at $Staging"}
   ```
   with
   ```text
       }
   ```

   The resulting file's Git blob is 6a6280949b89fdb2564d3e3392fd8ec88ad40c37.

3. Check whether `lib/test-restore-orvion.ps1` contains `foreach($key in 'OneDrive','OneDriveConsumer','OneDriveCommercial'){`; if so record Already Applied when its Git blob is bafd5723f69f1b159e4f07900bedd4d425d26651, and otherwise stop and report. Otherwise make exactly these 13 edits (owner-approved retained recovery staging, reporting, placement and extraction capacity checks (D43)), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $savedInjection=@{}
   ```
   insert
   ```text
   foreach($key in 'OneDrive','OneDriveConsumer','OneDriveCommercial'){
       $savedInjection[$key]=[Environment]::GetEnvironmentVariable($key,'Process');[Environment]::SetEnvironmentVariable($key,$null,'Process')
   }
   ```

   b) immediately after the line
   ```text
   function Set-Sidecar([string]$Archive){[IO.File]::WriteAllText("$Archive.sha256",((Get-FileHash $Archive).Hash+' *'+(Split-Path $Archive -Leaf))) }
   ```
   insert
   ```text
   function Get-FixtureTreeState([string]$Path){
       (@(Get-ChildItem -LiteralPath $Path -Recurse -Force|Sort-Object FullName|ForEach-Object{
           $hash='directory';if(!$_.PSIsContainer){$hash=(Get-FileHash -LiteralPath $_.FullName).Hash}
           $_.FullName+'|'+$_.Attributes+'|'+$hash
       })-join"`n")
   }
   ```

   c) immediately after the line
   ```text
           if($File-eq'7z'){
   ```
   insert
   ```text
               if($Arguments[0]-eq'l'){
                   if($script:case-eq'disk-list-exit'){$script:NativeExitCode=31;return}
                   if($script:case-eq'disk-metadata'){'Path = bad';return}
                   if($script:case-eq'disk-empty'){return}
                   if($script:case-eq'disk-negative'){"Path = bad`nSize = -1";return}
                   if($script:case-eq'disk-overflow'){"Path = bad`nSize = 9223372036854775808";return}
                   "Path = fixture`nSize = 1024";return
               }
   ```

   d) immediately after the line
   ```text
               $dir=$Arguments[1].Substring(2);[void][IO.Directory]::CreateDirectory($dir)
   ```
   insert
   ```text
               if($script:case-eq'long-retained'){
                   $deep=$dir;while($deep.Length-lt450){$deep=Join-Path $deep ('d'*35)}
                   [void][IO.Directory]::CreateDirectory(('\\?\'+$deep))
                   $script:longFile='\\?\'+(Join-Path $deep 'locked.txt')
                   [IO.File]::WriteAllText($script:longFile,'retained fixture bytes')
                   [IO.File]::SetAttributes($script:longFile,[IO.FileAttributes]::ReadOnly)
                   $script:longAttributes=[IO.File]::GetAttributes($script:longFile)
                   $script:longLock=[IO.File]::Open($script:longFile,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::Read)
               }
   ```

   e) immediately after the lines
   ```text
           if($File-like'*CRM\workstation.cmd'-and$script:case-eq'product'){$script:NativeExitCode=23}
       }
   ```
   insert
   ```text
       function script:Get-RecoveryFreeBytes([string]$Path){
           if($script:case-eq'disk-unreadable'){throw 'RECOVERY_DISK_SPACE_UNREADABLE'}
           if($script:case-eq'disk-insufficient'){return [long]1}
           return [long]1GB
       }
       function script:Remove-RecoveryStaging {throw 'CLEANUP_SEAM_CALLED'}
   ```

   f) immediately after the line
   ```text
       $stage=Join-Path $root 'stage';$target=Join-Path $root 'target'
   ```
   insert
   ```text
       $outside=Join-Path $root 'outside.txt';[IO.File]::WriteAllText($outside,'outside fixture bytes')
       [IO.File]::SetAttributes($outside,[IO.FileAttributes]::ReadOnly)
       $outsideHash=(Get-FileHash $outside).Hash;$outsideAttributes=[IO.File]::GetAttributes($outside)
   ```

   g) replace the line
   ```text
       if($Case-eq'default-stage'){$params.Remove('Staging')}
   ```
   with
   ```text
       if($Case-in'default-stage','repeat-default'){$params.Remove('Staging')}
       if($Case-eq'placement-repo'){$params.Staging=Join-Path $target 'CRM/stage'}
       if($Case-eq'placement-data'){$params.Staging=Join-Path $env:ORVION_DATA_ROOT 'stage'}
       if($Case-eq'placement-profile-home'){$params.Staging=Join-Path $env:USERPROFILE '.codex/stage'}
       if($Case-eq'placement-owner-other'){$params.Staging=Join-Path $root 'other/ORVION-Owner-Tools/stage'}
       if($Case-eq'placement-git'){$gitRoot=Join-Path $root 'independent';[void][IO.Directory]::CreateDirectory((Join-Path $gitRoot '.git'));$params.Staging=Join-Path $gitRoot 'stage'}
       if($Case-eq'placement-sync'){$params.Staging=Join-Path $env:USERPROFILE 'OneDrive/stage'}
       if($Case-eq'placement-sync-alias'){
           $sync=Join-Path $env:USERPROFILE 'OneDrive';[void][IO.Directory]::CreateDirectory($sync)
           $alias=Join-Path $root 'sync-alias';$null=New-Item -ItemType Junction -Path $alias -Target $sync
           $params.Staging=Join-Path $alias 'stage'
       }
       if($Case-eq'relative-stage'){$params.Staging='.\relative-stage'}
   ```

   h) replace the lines
   ```text
       $output=@(Invoke-OrvionRecovery @params *>&1)-join"`n"
       [pscustomobject]@{Exit=$script:RecoveryExit;Output=$output;Calls=@($script:calls.ToArray());Stage=(Test-Path $stage);Keep=(Test-Path (Join-Path $stage 'keep.txt'));Root=$root;Newer=$newer}
   ```
   with
   ```text
       $savedLocation=Get-Location
       try{
           if($Case-eq'relative-stage'){Set-Location $root}
           $output=@(Invoke-OrvionRecovery @params *>&1)-join"`n"
           if($Case-eq'reuse-success'){
               $before=Get-FixtureTreeState $stage
               $second=@(Invoke-OrvionRecovery @params *>&1)-join"`n"
               $script:reusedRefused=$script:RecoveryExit-ne0-and$second-match'RECOVERY_STAGING_EXISTS'-and$second-notmatch'(?m)^READY: '-and(Get-FixtureTreeState $stage)-ceq$before
               $output+="`n"+$second
           }
           if($Case-eq'repeat-default'){
               $retained=@(Get-ChildItem (Join-Path $target 'ORVION-Workbench-temporary/restore-staging') -Directory)[0].FullName
               $marker=Join-Path $retained 'keep.txt';[IO.File]::WriteAllText($marker,'first attempt')
               $before=Get-FixtureTreeState $retained
               $output+="`n"+(@(Invoke-OrvionRecovery @params *>&1)-join"`n")
               $script:repeatKept=(Get-FixtureTreeState $retained)-ceq$before
           }
       }finally{Set-Location $savedLocation}
       $longOk=$true;$longLength=0
       if($Case-eq'long-retained'){
           try{
               $longLength=$script:longFile.Length-4
               $longOk=[IO.File]::ReadAllText($script:longFile)-ceq'retained fixture bytes'-and[IO.File]::GetAttributes($script:longFile)-eq$script:longAttributes
           }finally{$script:longLock.Dispose()}
       }
       $outsideOk=(Get-FileHash $outside).Hash-ceq$outsideHash-and[IO.File]::GetAttributes($outside)-eq$outsideAttributes
       [pscustomobject]@{Exit=$script:RecoveryExit;Output=$output;Calls=@($script:calls.ToArray());Stage=(Test-Path $stage);Keep=(Test-Path (Join-Path $stage 'keep.txt'));Root=$root;Newer=$newer;LongOk=$longOk;LongLength=$longLength;OutsideOk=$outsideOk;RepeatKept=$script:repeatKept;ReusedRefused=$script:reusedRefused}
   ```

   i) replace the line
   ```text
       Assert-That 'newest by name; one extraction; local bundle branch/head; four paths passed; products both run; staging removed' ($r.Exit-eq0-and!$r.Stage-and@($r.Calls|Where-Object{$_-like'7z x *'}).Count-eq1-and$calls.Contains($r.Newer)-and$calls.Contains('repos\ORVION-Workbench.bundle')-and$calls.Contains('checkout --quiet -B recovery-branch '+('a'*40))-and$calls.Contains('-From ')-and$calls.Contains('-Target ')-and$calls.Contains('-ClaudeHome ')-and$calls.Contains('-LegacyTarget ')-and$calls.Contains('-CodexHome ')-and$calls.Contains('CRM\workstation.cmd')-and$calls.Contains('ORVION\workstation.cmd')-and$calls-notmatch'winget install')
   ```
   with
   ```text
       Assert-That 'newest by name; one extraction; local bundle branch/head; four paths passed; products both run; staging retained' ($r.Exit-eq0-and$r.Stage-and$r.Output.Contains('status=completed')-and$r.Output.Contains((Join-Path $r.Root 'stage'))-and@($r.Calls|Where-Object{$_-like'7z x *'}).Count-eq1-and$calls.Contains($r.Newer)-and$calls.Contains('repos\ORVION-Workbench.bundle')-and$calls.Contains('checkout --quiet -B recovery-branch '+('a'*40))-and$calls.Contains('-From ')-and$calls.Contains('-Target ')-and$calls.Contains('-ClaudeHome ')-and$calls.Contains('-LegacyTarget ')-and$calls.Contains('-CodexHome ')-and$calls.Contains('CRM\workstation.cmd')-and$calls.Contains('ORVION\workstation.cmd')-and$calls-notmatch'winget install')
   ```

   j) replace the line
   ```text
       Assert-That 'default staging is an owned UTC child of temporary restore-staging' ($r.Exit-eq0-and($r.Calls-join' ')-match'ORVION-Workbench-temporary\\restore-staging\\[0-9]+T[0-9]+Z'-and@(Get-ChildItem (Join-Path $r.Root 'target/ORVION-Workbench-temporary/restore-staging') -ErrorAction SilentlyContinue).Count-eq0)
   ```
   with
   ```text
       Assert-That 'default staging is an owned UTC+GUID child of temporary restore-staging' ($r.Exit-eq0-and($r.Calls-join' ')-match'ORVION-Workbench-temporary\\restore-staging\\[0-9]+T[0-9]+Z-[a-f0-9]{32}'-and@(Get-ChildItem (Join-Path $r.Root 'target/ORVION-Workbench-temporary/restore-staging') -ErrorAction SilentlyContinue).Count-eq1)
       foreach($caseName in 'placement-repo','placement-data','placement-profile-home','placement-owner-other','placement-git','placement-sync','placement-sync-alias'){
           $r=Invoke-Scenario $caseName
           Assert-That "retained placement $caseName refused before extraction" ($r.Exit-ne0-and$r.Output-match'RECOVERY_STAGING_PLACEMENT_REFUSED'-and($r.Calls-join' ')-notmatch'7z x'-and$r.Output-notmatch'(?m)^READY: ')
       }
       foreach($pair in @(@('disk-metadata','METADATA_UNREADABLE'),@('disk-empty','METADATA_UNREADABLE'),@('disk-negative','METADATA_UNREADABLE'),@('disk-overflow','METADATA_UNREADABLE'),@('disk-list-exit','METADATA_UNREADABLE'),@('disk-insufficient','SPACE_INSUFFICIENT'),@('disk-unreadable','SPACE_UNREADABLE'))){
           $r=Invoke-Scenario $pair[0]
           Assert-That "pre-extraction disk refusal $($pair[0])" ($r.Exit-ne0-and!$r.Stage-and$r.Output.Contains('RECOVERY_DISK_'+$pair[1])-and($r.Calls-join' ')-notmatch'7z x'-and$r.Output-notmatch'(?m)^READY: ')
           if($pair[0]-eq'disk-list-exit'){Assert-That 'metadata child exit 31 preserved' ($r.Exit-eq31)}
       }
       $r=Invoke-Scenario long-retained
       Assert-That "native $($PSVersionTable.PSVersion) locked readonly path $($r.LongLength) bytes/attributes retained; outside unchanged; READY" ($r.Exit-eq0-and$r.Stage-and$r.LongOk-and$r.LongLength-ge450-and$r.OutsideOk-and$r.Output-match'(?m)^READY: '-and$r.Output-match'status=completed'-and$r.Output-notmatch'CLEANUP_SEAM_CALLED')
       Assert-That 'launcher has no automatic recursive cleanup or attribute mutation' ($source-notmatch'Directory\]::Delete|Remove-Item|Remove-RecoveryStaging|Attributes\s*=|SetAttributes|-Recurse')
       $r=Invoke-Scenario repeat-default
       Assert-That 'two default attempts retain distinct paths and first tree bytes/attributes unchanged' ($r.Exit-eq0-and$r.RepeatKept-and@(Get-ChildItem (Join-Path $r.Root 'target/ORVION-Workbench-temporary/restore-staging') -Directory).Count-eq2)
       $r=Invoke-Scenario reuse-success
       Assert-That 'explicit successful staging reuse refused without tree alteration or second extraction' ($r.ReusedRefused-and$r.Stage-and@($r.Calls|Where-Object{$_-like'7z x *'}).Count-eq1)
       $r=Invoke-Scenario relative-stage
       Assert-That 'relative staging uses PowerShell location and reports absolute path' ($r.Exit-eq0-and(Test-Path (Join-Path $r.Root 'relative-stage'))-and$r.Output.Contains((Join-Path $r.Root 'relative-stage')))
   ```

   k) replace the line
   ```text
           Assert-That "real 7z/local git/detached checkout/pwsh child under $engine (exit $code)" ($code-eq0-and($out-join' ').Contains('REAL_CHILD_OUTPUT')-and!(Test-Path $stage))
   ```
   with
   ```text
           Assert-That "real 7z/local git/detached checkout/pwsh child under $engine (exit $code)" ($code-eq0-and($out-join' ').Contains('REAL_CHILD_OUTPUT')-and(Test-Path $stage)-and($out-join' ')-match'status=completed')
   ```

   l) immediately after the line
   ```text
           if($code){$out|Select-Object -Last 12}
   ```
   insert
   ```text
           $stage=Join-Path $t ('real-failure-'+[guid]::NewGuid().ToString('N').Substring(0,5))
   ```

   m) replace the lines
   ```text
       # Own GUID fixture only; never a product clone or real user configuration.
       if([IO.Path]::GetFullPath($t).StartsWith([IO.Path]::GetFullPath([IO.Path]::GetTempPath()),[StringComparison]::OrdinalIgnoreCase)){
           Get-ChildItem -LiteralPath $t -Recurse -Force -Attributes ReparsePoint|ForEach-Object{[IO.Directory]::Delete($_.FullName,$false)}
           Get-ChildItem -LiteralPath $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)
       }else{throw 'FIXTURE_CLEANUP_OUTSIDE_TEMP'}
   ```
   with
   ```text
       # Test-owned disposal only. The existing pwsh prerequisite handles long fixture paths.
       $cleanup=Join-Path ([IO.Path]::GetTempPath()) ('fixture-cleanup-'+[guid]::NewGuid().ToString('N')+'.ps1')
       $cleanupBody=@'
   param($Fixture,$TempBoundary)
   $ErrorActionPreference='Stop'
   $full=[IO.Path]::GetFullPath($Fixture);$boundary=[IO.Path]::GetFullPath($TempBoundary).TrimEnd('\')+'\'
   if(!$full.StartsWith($boundary,[StringComparison]::OrdinalIgnoreCase)-or((Get-Item -LiteralPath $full -Force).Attributes-band[IO.FileAttributes]::ReparsePoint)){throw 'FIXTURE_CLEANUP_REFUSED'}
   Get-ChildItem -LiteralPath $full -Recurse -Force -Attributes ReparsePoint|ForEach-Object{[IO.Directory]::Delete($_.FullName,$false)}
   Get-ChildItem -LiteralPath $full -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'}
   [IO.Directory]::Delete($full,$true)
   '@
       [IO.File]::WriteAllText($cleanup,$cleanupBody,[Text.Encoding]::ASCII)
       try{& (Get-Command pwsh -CommandType Application|Select-Object -First 1).Source -NoProfile -File $cleanup $t ([IO.Path]::GetTempPath().TrimEnd('\'));if($LASTEXITCODE){throw 'FIXTURE_CLEANUP_FAILED'}}finally{[IO.File]::Delete($cleanup)}
   ```

   The resulting file's Git blob is bafd5723f69f1b159e4f07900bedd4d425d26651.

## Acceptance Criteria

- [ ] Exact approved scoped output. check: blob:docs/RECOVERY.md=fe6db116722620736c776f4a9af068682ff4cdf4
- [ ] Exact approved scoped output. check: blob:lib/Restore-ORVION.ps1=6a6280949b89fdb2564d3e3392fd8ec88ad40c37
- [ ] Exact approved scoped output. check: blob:lib/test-restore-orvion.ps1=bafd5723f69f1b159e4f07900bedd4d425d26651
- [ ] Owner C governs the narrow amendment: successful requested mandatory recovery and checklist complete with exit 0, retained staging and READY; failures retain owned staging, preserve first child exit (including 42), and withhold READY. Retained housekeeping alone is not failure. Status, purpose and absolute owned location are printed before READY, with sensitivity and separately owner-authorized disposal guidance.
- [ ] Native Windows PowerShell 5.1 parses the ASCII launcher and proves ordinary mock success, plus a locked read-only entry of at least 382 characters (target >=450) unchanged in bytes and attributes with outside sentinel unchanged. Successful recovery must invoke no cleanup seam or attribute/deletion operation. All existing product/map/temporary/checklist failure cases remain meaningful.
- [ ] Both existing owning suites pass sequentially on the final implementation/test subject using the established fixture process seam. A tiny local archive/bundle and fixture restore child prove transport and original exit propagation; they do not prove a real workspace restore. Small meaningful mutants include reintroduced automatic deletion and failed work reported READY, plus placement and insufficient-space refusals. Historical deletion-success, cleanup-failure and cleanup-race tests/mutants are SUPERSEDED BY OWNER C; preserve their frozen evidence.
- [ ] Repeat defaults retain distinct timestamp-plus-GUID children under Target/ORVION-Workbench-temporary/restore-staging and leave the first tree unchanged; explicit existing/reused staging refuses without alteration. Reject permanent repository, Owner-Tools, Claude/Codex-home and known OneDrive placement, including tested managed aliases, before extraction. State native file-symlink SKIP and all unproven alias/platform conditions. Managed path comparisons are not atomic containment.
- [ ] Before extraction, require readable actual 7z expanded-size metadata and readable sufficient free-space evidence. Test malformed/empty/negative/overflow/list-exit evidence and insufficient/unreadable capacity without extraction. Summed logical sizes plus a separately justified 64 MiB metadata/allocation allowance are a snapshot gate, not physical allocation proof, reservation or later-work capacity guarantee. No compressed-size multiplier or automatic purging.
- [ ] Document accumulating sensitive unencrypted staging, existing local access protection and separate owner-authorized disposal. URL masking/credential exclusions and a file-only gitleaks scan do not prove absence of secrets, especially in bundles. Do not print secrets or change ACLs/machine settings.
- [ ] Preserve D31's frozen V1/V2/V3 method, prior baseline reproduction and independent mutants/survivors, accepted literal replay controls and every unchanged native gate. One native timed/watched sandbox Finish still owns the unchanged full schedule/fresh SANDBOX receipt before original approval; original Finish, live Review, native Complete and independent carrying-range READY remain required. This delegate performs none of those operations.
- [ ] HANDOFF criterion 5 still requires one isolated run of the released launcher against a fresh package. Step 3 still requires isolated roots/environment, real map-task XML backup/restore, external logs, all three Boots, memory keys and the same fresh archive cloud round-trip. Only its launcher-success expectation changes to successful mandatory recovery plus intentionally retained staging and status/path output, with no deletion condition. Step 3 is not proven by these fixtures.

## Review Gate

- [ ] Inspect the three scoped paths, final subject hashes and complete baseline diff. Check that READY depends on all requested mandatory work, no retained-staging cleanup/attribute seam exists, disk evidence precedes extraction, and output/docs expose retention location/status, accumulation and sensitivity honestly. Review known alias refusals and residual non-atomic/path-platform limits without requesting another A/B optimization loop.
- [ ] Read the exact acceptance amendment, material V2 dispositions, frozen evidence and final focused/native/mutant logs, including every failure, SKIP and unproven condition. Orchestrator must regenerate literal steps, declared output blobs, context, assurance and native scope independently. This prototype evidence grants no lifecycle authority.
- [ ] Independently check native receipt root/Draft/recipe/evaluator/fingerprint, ordered tests and timed/watcher/host exits. Normal native Review/Complete and every carrying transition must pass. HANDOFF criterion 5 and the full Step 3 audit stand; retained housekeeping is a separate owner-authorized task. No approval, freeze, release, clean-machine proof or provider certification is claimed.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

2026-10-28: fresh gpt-6.1-sol high delegate, existing Delegate launcher, independent disabled-push clone at baseline 751c324248d040a6c5efab59c37859d00fc7ac28. Direct owner selected Candidate C and explicitly superseded only automatic-deletion semantics. Read supplied safe frozen evidence; no Pulse/Events/Spider, private-root access, nested agent, network or model/effort reconfirmation. Implemented only the three authorized engineering paths plus codex deliverables. Sequential focused/native fixture evidence is recorded in codex; final-subject.json identifies the final bytes. No freeze/approval/lifecycle/real restore/commit/push. Original frozen Gate 1/delegation statements remain historical and are not fresh authority for this candidate; orchestrator owns native packet and scope updates.


Authority: DECISIONS.md D43 records the explicit owner Candidate C amendment and subsequent Sol/high clarification, under OWNER-DELEGATION.md's bounded conditional advance authorization. V1/V2 bytes remain frozen. Gate 1 for the exact qualified successor is DELEGATED, not owner-typed; its actual Draft SHA256 and physical execution-root binding must be recorded before original implementation. Sandbox approval is synthetic and grants no original authority.

## Verification Notes

Subject: final-subject.json binds baseline 751c324248d040a6c5efab59c37859d00fc7ac28 and exactly lib/Restore-ORVION.ps1, lib/test-restore-orvion.ps1 and docs/RECOVERY.md. This independent review verified all three Git blobs, SHA-256 values and byte lengths and read their complete baseline diff and current source. Runtime results below are supplied evidence, not reruns by this reviewer. Review copies are under review-inputs/.

The orchestrator's focused.log records BOTH UNMODIFIED owning suites run sequentially under the frozen SHORT W29 environment with the supported pwsh 7.6.8 driver: test-restore-orvion exit 0 and test-backup-restore exit 0. No delegate backup adapter was used for this rerun. Recovery evidence covers retained success, existing refusals, mandatory preparation/product/checklist failures, first failure propagation, default uniqueness/repeat preservation, explicit successful-stage reuse refusal, provider-relative staging, tested placement guards and disk refusals. Real tiny 7z/local-bundle/fixture-child cases pass through both pwsh and actual powershell.exe transport children, including exit 42. These fixture children do not implement or prove a real workspace restore. hazards.log reports 0; mutants.log records five independent mutations detected by semantic assertions: automatic deletion, READY after failure, non-unique default attempts, placement bypass and insufficient-space bypass.

Author evidence is retained with its original scope. subject-final-native-proof.log records Windows PowerShell 5.1.26100.9711 / CLR 4.0.30319.42000 ordinary success with completed status/absolute path before READY, a locked read-only 464-character entry and unchanged outside sentinel, mandatory failure/no READY/exit 42, tested repository/data/home/OneDrive/junction placement and disk refusals. Actual 7z expanded-size parsing matches a real 4096-byte highly compressible fixture and reads a real capacity snapshot. subject-final-retention-mutants.log records four author mutations; it is separate from the five orchestrator mutants. The author's backup-suite adapter and process-scoped Git long-path configuration are disclosed historical proof; the unmodified orchestrator owning-suite pass supersedes that environment limitation. No adapter is part of the engineering candidate.

Supplemental native-owning-restore.log is a FAILED whole-driver experiment, exit 1. Under powershell.exe it passed default unique staging, locked/read-only 495-character preservation and repeated retention, then failed at lib/test-restore-orvion.ps1:301: the driver's ErrorActionPreference=Stop treated Git's informational "Cloning into" stderr from its real-child invocation as NativeCommandError. It is never counted as a native whole-driver pass. The supported owning driver is pwsh; its run and actual powershell.exe launcher transport children pass. The launcher process wrapper locally uses ErrorActionPreference=Continue and checks native exit codes. This evidence identifies a supplemental unsupported-driver limitation, not an established candidate product failure; full PowerShell 5.1 compatibility of the test driver is not added as an acceptance prerequisite.

Earlier failures remain historical failures: unusually long inherited TEMP exceeded the unchanged native directory provider's default-root support; initial fixture cleanup quoting/discovery failed; unwrapped backup Git bundle-lock creation exceeded MAX_PATH; abandoned child adapters failed. Later targeted and SHORT W29 results do not certify arbitrary long native staging-root creation. Native directory/file-symlink integration remains SKIP; inherited file-symlink evidence is Win32 1314. Static junction placement is tested. Native UNC/mapped/subst, exhaustive 8.3/PSDrive aliases, unknown sync providers, exact .NET Framework 4.8 and hostile concurrent namespace containment remain unproven. Managed checks are non-atomic.

Owner C supersedes only deletion-specific acceptance. V1:177 and V2:363-364 deletion/attribute/cleanup-failure/race tests and cleanup mutants are SUPERSEDED BY OWNER C, not passed; frozen history and immutable WS-023 statements remain unchanged. acceptance-amendment.md and dispositions.md retain their successors. Sensitive unencrypted staging accumulates; masking, credential exclusions and a file-only gitleaks scan do not establish absence of secrets in files or bundles. Existing local protection and separate owner-authorized disposal remain necessary. Expanded logical sizes plus separate 64 MiB metadata/allocation headroom and a free-space snapshot are not physical allocation proof, reservation or later-work capacity assurance. Backup/Restore-Workspace independent cleanup is unchanged.

No real restore, cloud round-trip, real task XML audit, three-Boot audit, memory-key audit, clean-Windows tool installation, Step 3 completion, accepted literal replay, full tests.ps1/Finish, native receipt, Review/Complete/carrying-range proof, freeze, approval or release is established by these fixtures or this review. Every unchanged native gate remains. The orchestrator must regenerate packet literals/blobs/context/assurance and native scope bookkeeping. Native CI/Finish resource checks remain applicable where requested by their owning entry points; they are not a universal focused-test/concurrency gate. This reviewer used only candidate source and supplied review evidence, without fresh research, runtime fixtures, private-data access or nested delegation.
Subject: final-subject.json; full baseline patch: v3-prototype.diff. Baseline 751c324248d040a6c5efab59c37859d00fc7ac28; exactly lib/Restore-ORVION.ps1, lib/test-restore-orvion.ps1, docs/RECOVERY.md. The final location correction also protects the current profile's default .claude/.codex homes, configured ORVION_DATA_ROOT and named Owner-Tools ancestors when custom recovery parameters select different destinations. No other engineering path changed.

Final proof index (only logs with subject-final prefix are the final implementation/test subject):
- subject-final-test-restore-orvion.log: owning suite, pwsh; native ASCII/5.1 parser checks; existing refusals, mandatory calls, product/map/temporary/checklist failures; real tiny 7z/bundle/fixture child under pwsh and powershell.exe; exit 42 retained; repeated default attempts and explicit reuse; repository/data/home/sync placement and disk refusals; existing internal mutants.
- subject-final-test-backup-restore.log: owning suite through Fixture-BackupSuite.ps1, sequentially after recovery suite. All original assertions are retained. The adapter supplies process-scoped GIT_CONFIG_PARAMETERS='core.longpaths=true' only to native pwsh children, restores it afterward, and adds absolute TEMP/reparse-root preconditions to the three existing recursive fixture disposal calls in an in-memory copy. Its only other substitution is the original lib path for PSScriptRoot. No engineering test file, Backup/Restore implementation, assertion, disk, machine or repository setting is changed by this adapter.
- subject-final-native-proof.log: native Windows PowerShell 5.1.26100.9711 / CLR 4.0.30319.42000; ordinary mock success reaches READY after checklist and retained completed status/path; locked read-only 464-character entry and outside sentinel preserve bytes/attributes; mandatory failures with no READY; original child exit 42; known repository/data/default-home/other-Owner-Tools/sync/junction placement and disk refusals. Real highly compressible archive Size parsing equals 4096 expected expanded bytes, with a readable actual volume snapshot; this is not compressed-size inference.
- subject-final-retention-mutants.log: four focused source mutations through the owning fixture process seam: reintroduced automatic deletion, failed child reported READY, permanent repository placement accepted, insufficient capacity accepted. Each must expose the targeted contract violation. Only mutant-owned scratch deletion is permitted; absolute TEMP boundary and non-reparse root are checked before it.

Commands (all run sequentially):
pwsh -NoProfile -File codex/Run-Focused.ps1 -Engine pwsh -Label subject-final
pwsh -NoProfile -File codex/Run-Focused.ps1 -Engine pwsh -Suite test-backup-restore -Script <absolute codex/Fixture-BackupSuite.ps1> -Label subject-final
pwsh -NoProfile -File codex/Run-Focused.ps1 -Engine powershell.exe -Suite native-proof -Script <absolute codex/Native-Proof.ps1> -Label subject-final
pwsh -NoProfile -File codex/Run-Focused.ps1 -Engine powershell.exe -Suite retention-mutants -Script <absolute codex/Native-Proof.ps1> -Label subject-final -Mutants
Run-Focused sets TEMP=TMP to inherited Delegate scratch and unique managed/test/fresh-empty-data roots beneath it, plus the supplied pinned WORKBENCH_ACTIONLINT path. Fixtures never live in codex/. Native-Proof reuses the owning scenario/process seam and guarded test-finally cleanup. Existing tiny synthetic Git commits/bundles belong solely to fixtures; no clone/source commit or push occurred.

Earlier attempts are preserved, not counted as final proof:
- initial-test-restore-orvion.log: real OneDrive cloud reparse metadata without a Target caused unrelated protection checks to fail; fixture cleanup also initially selected two pwsh executable results. Fixed by isolated fixture sync environment, explicit known-sync lexical checks/managed alias resolution, and first executable selection. Unresolved staging reparse roots still fail closed.
- second-test-restore-orvion.log: native whole owning suite reached default staging paths longer than the baseline 5.1 directory provider supports beneath this unusually long inherited TEMP. It also exposed a native trailing-backslash argument quoting issue in fixture cleanup; cleanup now trims that argument. Targeted native normal/long-entry proofs pass. The whole suite runs under pwsh and separately invokes real 5.1 transport/parse cases. Arbitrary >260-character native default staging-root creation remains UNPROVEN/unsupported by the unchanged New-Item mechanism; no native whole-suite pass is claimed.
- preliminary-test-backup-restore.log: unwrapped Git bundle lock creation hit MAX_PATH in Delegate scratch. final-test-backup-restore.log and final2-test-backup-restore.log describe abandoned fixture child-invocation adapters; they failed before complete package coverage. Fixture-Child.ps1 is preserved as an abandoned adapter, not used in final proof. final3 logs passed an earlier subject using the final native process-scoped Git seam.
- third/final recovery logs and final native/mutant logs cover earlier prototype bytes and are not substitutes for subject-final logs.

Limits and explicit dispositions:
- Native directory-symlink creation is attempted by Native-Proof and reported SKIP if unavailable. Native file-symlink integration remains SKIP; inherited final-paths.log records Win32 1314, not a fresh success. Static junction placement is freshly tested. No native UNC/network share, mapped/subst, exhaustive 8.3/PSDrive aliases, unknown sync providers, exact .NET Framework 4.8 or hostile namespace race proof. Managed normalization is not atomic identity/containment.
- The 64 MiB reserve is a separate modest metadata/allocation allowance. Entry Size summation gives expected logical extraction bytes, not exact allocation or a reservation. Later clone/restore/product capacity remains unguaranteed. No multiplier, purge or retention registry. User-supplied pre-run free space was 216.58 GiB; actual small-fixture volume snapshots appear in native logs. No sensitive file contents were inspected.
- Sensitive unencrypted copies accumulate. Masked Codex URL passwords, excluded credential stores and a gitleaks file scan cannot establish no secrets, especially in Git bundle history. Output/docs explain owner-controlled local access and separately authorized disposal without ACL/settings changes or printing secrets.
- Historical V1:177 and V2:363-364 deletion/attribute/cleanup-failure/race tests and their old cleanup mutants are SUPERSEDED BY OWNER C, not passed or silently dropped. Their frozen files and prior logs remain in codex-inputs. WS-023:13/:805 history is unchanged; HANDOFF criterion 5 and every Step 3 audit requirement stand. See acceptance-amendment.md and dispositions.md.
- No real workspace restore, cloud round-trip, real map-task XML backup/restore, three-Boot audit, memory-key audit, clean-machine install, Step 3, native lifecycle/Finish/full schedule, accepted literal replay, freeze, approval, release, original-source commit or push. Orchestrator owns those remaining native/packet operations.
- Host headroom is refreshed in each run log; work did not overlap. Supplied ResourceCheck scope remains native CI/Finish, not a universal focused-test concurrency policy. No claim that memory blocked an action, and no unrelated service was killed.

Sources: supplied brief and frozen codex-inputs, accepted local baseline and actual fixture outputs. codex-inputs/v3-standards-start.md contains inherited same-day Microsoft primary references. No fresh web fetch, private data-root access, Pulse/Events/Spider, real sessions, client-home reads, nested agents or agent CLI occurred.

Orchestrator verification after delegate exit (2026-10-28): exact three file SHA256/Git blobs match final-subject.json; copied every deliverable to package/v3 with hash equality. Run-Evidence.ps1 under the frozen W29 test/temp context ran BOTH UNMODIFIED owning suites sequentially, exit 0 each, without the delegate backup adapter; hazards 0; all five D43 orchestrator mutants killed by semantic assertions. Prior V1 selected focused log and mutant results are preserved under stopped-sol-high-ab before-C filenames. The five new mutants replace deletion-specific requirements explicitly superseded by D43, not historical evidence.
Supplemental whole test-driver invocation under powershell.exe passed default unique staging, 495-character locked/read-only retention and repeat attempts, then exited 1 at test-restore-orvion.ps1's real-child harness: PowerShell 5.1 surfaced Git's informational "Cloning into" stderr as NativeCommandError under the driver's ErrorActionPreference=Stop. It is not claimed as a pass. The owning driver/recipe uses pwsh 7.6.8 and passed; targeted native launcher proofs and actual powershell.exe transport children passed. Full PS5 compatibility of the owning test DRIVER is not an existing acceptance requirement. Do not broaden scope or erase this failed supplemental experiment.
Resource applicability correction: frozen V1/V2 Execution Context lines 45-46 specifies 1.5 physical/3 commit GiB. Test-WorkbenchChange.ps1:85-91 measures ONLY when ResourceCheck is passed; Workbench.ps1:139 and :219 (CI/Finish) and sandbox/original Finish wrappers request it. Execute :168 does not. Run-Evidence.ps1 and Delegate.ps1 do not establish a universal memory gate. WORKFLOW.md:29 expressly says this is not a universal concurrency policy. The first continuation applied it too broadly. Future native Finish remains strictly gated on fresh measurements; no user services/settings were changed.
Independent Sol/high review (thread 01a17fd8-991a-7713-8c18-ca4df024daa2) returned REVISE for two packet sections only, no material product defect. Both exact reviewer-provided Out of Scope and Verification Notes replacement bodies were incorporated with hash equality. Author originals remain under author-sections-before-review; independent-review/review.md retains the original verdict and precise conditions. This closes those pre-freeze revisions without altering the three engineering outputs or claiming a new reviewer verdict. Delegate exit 0, no tripwire changes reported. No second independent review is justified by a product-code change because there was none.

## Selection reasons and sources

Owner explicitly selected Candidate C on 2026-10-28. The baseline success-path recursive attribute/deletion block is removed. Requested mandatory work still controls success; retained housekeeping does not. Additional code is limited to unique default staging, necessary placement refusal, provider-relative normalization and metadata-based extraction disk preflight. Backup/Restore-Workspace independent cleanup is untouched. No automatic purging, dependency, registry, service or retention subsystem is introduced.

PROVEN claims must be read with the final subject and final focused/native logs. Frozen V1/V2 deletion proof and failures stay preserved as historical evidence; they are not silently treated as satisfied retention acceptance. Step 3 and native release gates remain outstanding.
