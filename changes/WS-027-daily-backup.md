# Workbench Change Request - WS-027

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Daily explicit opt-in around the existing Backup-Workspace package engine, with visible application and Scheduler observations and a retained last VERIFIED package. Preserve previous verified recovery through refusals, partial/interrupted publication and report-only scanner limits. Earn durable recovery-input/runtime documentation and actual scheduled success/refusal plus representative measured limits before the corresponding root's live native Review/Complete.

Intended contract: changes/WS-027-daily-backup.md. This is a complete V3 evidence refresh, not an allocated/approved contract. Preparation leaves Active Workbench Contract: None. Native allocation, status and pointer transitions remain native-owned.

## Baseline

4173639609f3f762bf9f47dd034d2df65d0a0ddd

## Write Scope

- RESUME.md
- lib/Backup-Workspace.ps1
- lib/test-backup-restore.ps1
- lib/README.md
- docs/RECOVERY.md
- docs/EXECUTION-PLAN.md

## Out of Scope

All other engineering paths, WORKFLOW.md, products, WS032/search qualification, credentials, real sessions/events, cleanup/deletion, restore redesign and Candidate C retention, coherent snapshots, new services/frameworks, runtime installation/copying and remote/settings/security changes. work/WS027/V3 is preparation scratch/evidence only, not an implementation target. No delegate actual task registration/execution, raw tests.ps1/full Finish, engineering clone commit/push or native admission is performed. Unchanged owning suites may use their authorized local-only Git history/bare-remote fixtures and bounded owned cleanup; these are not publication of this engineering slice. Later root-bound native authority must separately admit Scheduler fixtures and original operation; this Draft alone grants no such authority.

## Draft Assurance

V1: WS027-V1-SOL-HIGH-DESIGN-20261030-01 | 2026-10-30 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-027\package\assurance\V1\DRAFT.md | 126186D328CC0DDD217377213BB435CB362516D0E739AD003E682B7449FF9485
V2: WS027-V2-SOL-HIGH-ADVERSARIAL-20261030-01 | 2026-10-30 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-027\package\assurance\V2\DRAFT.md | 618661A55F86B2BB9C91B8E3CAD1B35745F74FF88C5E83AE61C3396BF287F43E
V3: WS027-V3-SOL-HIGH-REFRESH-20261030-01 | 2026-10-30 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-027\package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

Those private paths are launcher-owned immutable declarations only, never followed here. Supplied frozen V1 and V2 Draft bytes match the exact declared digests. V3 is selected for external freeze; its own digest is measured by the launcher after freeze, never embedded in itself. D70 explicitly permits the actual fresh Sol/high V3 author in place of historical Claude; root verifies actual effective model/effort. This phase is not either final independent reviewer. Two fresh independent same-provider sessions must review this SAME externally frozen final source/test/docs/Draft subject. No provider-diversity claim, review agreement, owner-digest approval or native receipt is fabricated. D71 requires saving each pass/completion and continuing; local outputs are retained immediately for launcher mirroring.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W27\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W27\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W27\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-027\package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Preparation Environment

Operational buffer: 5 GB physical / 8 GB commit. Native context admission owns actual observations/exclusivity. V3 checks use the supplied portable 7.6.8 executable, actionlint at temporary/tools/actionlint.exe, WORKBENCH_TEMP_ROOT and WORKBENCH_TEST_ROOT under temporary/scratch/W27-v3, TEMP=TMP at its tmp child, a new empty synthetic ORVION_DATA_ROOT, and synthetic USERPROFILE. This is separate from later native execution roots above. Runtime Root names native evidence/helper context, never permission to copy a portable tool tree there. The actual Scheduler executable must be an existing supported installed runtime; already installed Store 7.6.9 is eligible only after exact path/version/access/module/action/readback proof. Do not silently change the native 7.6.8 context to claim that compatibility.

## Implementation Steps

1. Check whether `lib/Backup-Workspace.ps1` contains `# Daily backup v1:`; if so record Already Applied when its Git blob is 74672716ceda409be894f50a0f4198f93a94a9c4, and otherwise stop and report. Otherwise make exactly these 4 edits (retain the engine/publication boundary; add opt-in daily installation, exclusion, bounded paths and separated status), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([Parameter(Mandatory)][string]$Destination,[switch]$AllowUnencrypted,[switch]$SkipLegacy,[string]$RecoveryInputs,[switch]$Package)
   ```
   with
   ```text
   param([Parameter(Mandatory)][string]$Destination,[switch]$AllowUnencrypted,[switch]$SkipLegacy,[string]$RecoveryInputs,[switch]$Package,
         [switch]$Install,[switch]$Status,[string]$RuntimePath,[string]$DataRoot,[string]$TemporaryRoot,
         [ValidateRange(1,1440)][int]$ExecutionLimitMinutes,[ValidatePattern('^(?:[01][0-9]|2[0-3]):[0-5][0-9]$')][string]$DailyAt='02:00')
   ```

   b) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   # Daily backup v1: status lives beside the destination, outside the existing package contents.
   # One OS file handle covers manual and scheduled publication. An abandoned file is not a lease.
   function ConvertTo-BackupDestination([string]$Path){
       # Pure normalization: a volume/share root has no safe sibling status directory.
       # Refuse before filesystem access instead of turning C:\ into drive-relative C:.
       if(![IO.Path]::IsPathFullyQualified($Path)){throw 'BACKUP_DESTINATION_ABSOLUTE_REQUIRED'}
       $full=[IO.Path]::GetFullPath($Path)
       $trimmed=$full.TrimEnd('\','/')
       if($trimmed-ieq[IO.Path]::GetPathRoot($full).TrimEnd('\','/')){throw 'BACKUP_DESTINATION_ROOT_REFUSED'}
       $trimmed
   }
   $Destination=ConvertTo-BackupDestination $Destination
   $statusRoot=$Destination+'.status';$statusFile=Join-Path $statusRoot 'latest.json'
   function Assert-BackupPath([string]$Path){
       $node=[IO.Path]::GetFullPath($Path)
       while($node){
           $item=Get-Item -LiteralPath $node -Force -ErrorAction SilentlyContinue
           # PowerShell identifies standard namespace redirects by LinkType. Cloud placeholders
           # can have ReparsePoint with no LinkType; that flag alone is not a redirect.
           # This metadata walk is not atomic alias/confinement or cloud-availability proof.
           if($item-and$item.LinkType-in'Junction','SymbolicLink'){throw 'BACKUP_REPARSE_REFUSED'}
           $parent=Split-Path $node -Parent;if($parent-eq$node){break};$node=$parent
       }
   }
   function Test-BackupWithin([string]$Path,[string]$Root){
       $p=[IO.Path]::GetFullPath($Path).TrimEnd('\','/');$r=[IO.Path]::GetFullPath($Root).TrimEnd('\','/')
       $p-ieq$r-or$p.StartsWith($r+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)
   }
   function Write-BackupStatus($Value){
       $pending=Join-Path $statusRoot ('pending-'+[guid]::NewGuid().ToString('N')+'.json')
       # Same-directory replacement; the pending write does not truncate the previous record.
       # Local failure preservation is tested; cloud/remote atomicity and durability are unproven.
       [IO.File]::WriteAllText($pending,($Value|ConvertTo-Json -Depth 8),[Text.UTF8Encoding]::new($false))
       [IO.File]::Move($pending,$statusFile,$true)
   }
   function Get-BackupTaskIdentity {
       $identity=[Security.Principal.WindowsIdentity]::GetCurrent().Name
       $key=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($Destination.ToUpperInvariant()))).Substring(0,16)
       [pscustomobject]@{User=$identity;Name=('ORVION Workspace Backup '+$key);Description=('ORVION Backup v1 | '+$identity+' | '+$PSCommandPath+' | '+$Destination)}
   }
   function Test-BackupTaskUser([string]$UserId){
       # Scheduler may report a short account, qualified account or SID for the same user.
       # Resolve through Windows; an unreadable/unresolvable identity never grants ownership.
       try{
           if([string]::IsNullOrWhiteSpace($UserId)){return $false}
           $sid=if($UserId-match'^S-1-'){[Security.Principal.SecurityIdentifier]::new($UserId)}
                else{[Security.Principal.NTAccount]::new($UserId).Translate([Security.Principal.SecurityIdentifier])}
           $sid.Equals([Security.Principal.WindowsIdentity]::GetCurrent().User)
       }catch{return $false}
   }
   if($Status){
       # Application records miss binding/preflight/launch failures and may remain RUNNING.
       # Scheduler readback is separate evidence, never an inferred package verification.
       $application=$null;$applicationState='NEVER_RECORDED'
       try{if(Test-Path -LiteralPath $statusFile){$application=Get-Content -LiteralPath $statusFile -Raw|ConvertFrom-Json;$applicationState='RECORDED'}}catch{$applicationState='UNREADABLE'}
       $scheduler=[ordered]@{state='UNAVAILABLE';taskName=$null;lastRunUtc=$null;lastTaskResult=$null;nextRunUtc=$null;configurationVerified=$false}
       try{
           $taskIdentity=Get-BackupTaskIdentity;$scheduler.taskName=$taskIdentity.Name
           $task=Get-ScheduledTask -TaskName $taskIdentity.Name -TaskPath '\' -ErrorAction Stop
           if($task.Description-cne$taskIdentity.Description-or!(Test-BackupTaskUser $task.Principal.UserId)-or
              $task.Principal.LogonType-ne'Interactive'-or$task.Principal.RunLevel-ne'Limited'-or@($task.Actions).Count-ne1){$scheduler.state='OWNERSHIP_COLLISION'}
           else{
               $info=Get-ScheduledTaskInfo -TaskName $taskIdentity.Name -TaskPath '\' -ErrorAction Stop
               $scheduler.state='READBACK_ONLY';$scheduler.lastRunUtc=$info.LastRunTime.ToUniversalTime().ToString('o')
               $scheduler.lastTaskResult=$info.LastTaskResult;$scheduler.nextRunUtc=$info.NextRunTime.ToUniversalTime().ToString('o')
           }
       }catch{$scheduler.state='UNAVAILABLE'}
       [ordered]@{schema=1;observedUtc=[DateTime]::UtcNow.ToString('o');applicationState=$applicationState;application=$application;scheduler=$scheduler;
           interpretation='Application is the last persisted attempt only. Scheduler readback may describe a newer launch/preflight failure; correlate times and runId. Neither result alone verifies a package.'}|ConvertTo-Json -Depth 10
       return
   }
   if($Install){
       # No discovery of private roots or disposable runtime fallback during installation.
       if(!$Package-or!$RecoveryInputs-or!$DataRoot-or!$TemporaryRoot-or!$RuntimePath-or!$ExecutionLimitMinutes){throw 'BACKUP_INSTALL_EXPLICIT_ARGUMENTS_REQUIRED'}
       foreach($p in $Destination,$RecoveryInputs,$DataRoot,$TemporaryRoot,$RuntimePath){
           if(![IO.Path]::IsPathFullyQualified($p)){throw 'BACKUP_INSTALL_ABSOLUTE_PATH_REQUIRED'};Assert-BackupPath $p
       }
       if(!(Test-Path -LiteralPath $RuntimePath -PathType Leaf)-or[IO.Path]::GetFileName($RuntimePath)-ine'pwsh.exe'-or
          $RuntimePath-match'(?i)[\\/]ORVION-Workbench-temporary[\\/]'-or(Test-BackupWithin $RuntimePath $TemporaryRoot)){throw 'BACKUP_INSTALL_DURABLE_RUNTIME_REQUIRED'}
       if(!(Test-Path -LiteralPath $RecoveryInputs -PathType Leaf)-or!(Test-Path -LiteralPath $DataRoot -PathType Container)){throw 'BACKUP_INSTALL_INPUT_UNAVAILABLE'}
       foreach($durable in $PSCommandPath,$RecoveryInputs,$DataRoot){
           if($durable-match'(?i)[\\/]ORVION-Workbench-temporary[\\/]'-or(Test-BackupWithin $durable $TemporaryRoot)){throw 'BACKUP_INSTALL_DURABLE_INPUT_REQUIRED'}
       }
       if((Test-BackupWithin $statusRoot $Destination)-or(Test-BackupWithin $Destination $statusRoot)){throw 'BACKUP_OUTPUT_STATUS_OVERLAP'}
       foreach($inputPath in $PSCommandPath,$RecoveryInputs,$DataRoot,$RuntimePath){
           foreach($outputPath in $Destination,$statusRoot){
               if((Test-BackupWithin $inputPath $outputPath)-or(Test-BackupWithin $outputPath $inputPath)){throw 'BACKUP_INSTALL_OUTPUT_INPUT_OVERLAP'}
           }
       }
       # Encode literal PowerShell strings, then the entire UTF-16 command. No shell interpolation of paths.
       function Quote-BackupLiteral([string]$Value){"'"+$Value.Replace("'","''")+"'"}
       $command='$env:ORVION_DATA_ROOT='+(Quote-BackupLiteral $DataRoot)+'; $env:WORKBENCH_TEMP_ROOT='+(Quote-BackupLiteral $TemporaryRoot)+
           '; & '+(Quote-BackupLiteral $PSCommandPath)+' -Destination '+(Quote-BackupLiteral $Destination)+' -RecoveryInputs '+(Quote-BackupLiteral $RecoveryInputs)+' -Package'
       $arguments='-NoProfile -NonInteractive -WindowStyle Hidden -EncodedCommand '+[Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($command))
       $taskIdentity=Get-BackupTaskIdentity;$identity=$taskIdentity.User;$taskName=$taskIdentity.Name;$description=$taskIdentity.Description
       $existing=Get-ScheduledTask -TaskName $taskName -TaskPath '\' -ErrorAction SilentlyContinue
       if($existing-and($existing.Description-cne$description-or!(Test-BackupTaskUser $existing.Principal.UserId)-or
          $existing.Principal.LogonType-ne'Interactive'-or$existing.Principal.RunLevel-ne'Limited'-or
          @($existing.Actions).Count-ne1-or$existing.Actions[0].Execute-ine$RuntimePath-or$existing.Actions[0].Arguments-cne$arguments)){throw 'BACKUP_TASK_OWNERSHIP_COLLISION'}
       $action=New-ScheduledTaskAction -Execute $RuntimePath -Argument $arguments
       $trigger=New-ScheduledTaskTrigger -Daily -At ([datetime]::Today.Add([timespan]::ParseExact($DailyAt,'hh\:mm',$null)))
       $settings=New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes $ExecutionLimitMinutes)
       $principal=New-ScheduledTaskPrincipal -UserId $identity -LogonType Interactive -RunLevel Limited
       $registration=@{TaskName=$taskName;TaskPath='\';Description=$description;Action=$action;Trigger=$trigger;Settings=$settings;Principal=$principal}
       if($existing){$registration.Force=$true}
       Register-ScheduledTask @registration|Out-Null
       "BACKUP TASK: '$taskName' daily $DailyAt; interactive user $identity; limit $ExecutionLimitMinutes minutes; status $statusFile";return
   }
   $lease=$null;$record=$null;$previous=$null;$clock=[Diagnostics.Stopwatch]::StartNew()
   try{
   Assert-BackupPath $Destination;Assert-BackupPath $statusRoot
   # Refuse output feeding the copied inputs. No source/archiving redesign or automatic pruning.
   $checkout=Split-Path $PSScriptRoot -Parent;$siblings=Split-Path $checkout -Parent
   $dataCandidate=if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{Join-Path $siblings 'ORVION-Owner-Tools'}
   $sources=@($dataCandidate,(Join-Path $env:USERPROFILE '.claude'),(Join-Path $env:USERPROFILE '.codex'))
   if($RecoveryInputs){$sources+=$RecoveryInputs}
   foreach($n in 'CRM','ORVION','CRM-trusted-main','ORVION-trusted-main','ORVION-Workbench','ORVION-Workbench-trusted-main'){$sources+=Join-Path $siblings $n}
   foreach($source in $sources){
       if(![IO.Path]::IsPathFullyQualified($source)){continue}
       Assert-BackupPath $source
       foreach($output in $Destination,$statusRoot){if((Test-BackupWithin $output $source)-or(Test-BackupWithin $source $output)){throw 'BACKUP_OUTPUT_SOURCE_OVERLAP'}}
   }
   [void][IO.Directory]::CreateDirectory($statusRoot)
   try{$lease=[IO.File]::Open((Join-Path $statusRoot 'operation.lock'),'OpenOrCreate','ReadWrite','None')}catch{throw 'BACKUP_BUSY'}
   if(Test-Path -LiteralPath $statusFile){$previous=Get-Content -LiteralPath $statusFile -Raw|ConvertFrom-Json}
   $record=[ordered]@{schema=1;runId=[guid]::NewGuid().ToString('N');startedUtc=[DateTime]::UtcNow.ToString('o');endedUtc=$null;elapsedSeconds=$null;result='RUNNING';errorCode=$null;lastVerified=$previous.lastVerified}
   Write-BackupStatus $record
   ```

   c) replace the line
   ```text
   $temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout $tools
   ```
   with
   ```text
   $TemporaryRoot=Initialize-OrvionTemporaryRoot -Checkout $tools
   ```

   d) immediately after the lines
   ```text
       $scanLine;$packageLine
   }
   ```
   insert
   ```text
   $record.result='SUCCESS';$record.endedUtc=[DateTime]::UtcNow.ToString('o');$record.elapsedSeconds=$clock.Elapsed.TotalSeconds
   if($packageLine){$record.lastVerified=[ordered]@{archive=$archive;sha256=$hash;verifiedUtc=$record.endedUtc;runId=$record.runId;recoveryInputs=$RecoveryInputs}}
   Write-BackupStatus $record
   }catch{
       # Busy contenders and failed preflight cannot overwrite the active publisher's record.
       if($lease-and$record){
           $record.result='FAILURE';$record.endedUtc=[DateTime]::UtcNow.ToString('o');$record.elapsedSeconds=$clock.Elapsed.TotalSeconds
           $record.lastVerified=$previous.lastVerified
           $record.errorCode=if($_.Exception.Message-match'^(BACKUP_[A-Z_]+|PACKAGE_[A-Z_]+|ORVION_DATA_ROOT_[A-Z_]+|WB_TEMP_[A-Z_]+)'){$Matches[1]}else{'BACKUP_FAILED'}
           try{Write-BackupStatus $record}catch{Write-Warning 'BACKUP_STATUS_WRITE_FAILED: prior status may remain RUNNING; inspect artifacts before retry'}
       }
       throw
   }finally{if($lease){$lease.Dispose()};$clock.Stop()}
   ```

   The resulting file's Git blob is 74672716ceda409be894f50a0f4198f93a94a9c4.

2. Check whether `lib/test-backup-restore.ps1` contains `function Invoke-DailyBackupChecks`; if so record Already Applied when its Git blob is 3ad21a014e8d1f6b22a2b49afdb1c7f92e5598b8, and otherwise stop and report. Otherwise make exactly this one edit (preserve the entire legacy assertion body and add owned synthetic daily/path checks), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([switch]$RootProbeOnly)
   ```
   with
   ```text
   param([switch]$RootProbeOnly,[switch]$DailyBackupOnly,[switch]$DailyPathOnly,[string]$DailyEvidenceRoot)
   function Invoke-BackupDestinationChecks {
       # Execute the actual production helpers; synthetic metadata never probes the supplied real paths.
       $guardTokens=$null;$guardErrors=$null
       $guardAst=[Management.Automation.Language.Parser]::ParseFile((Join-Path $PSScriptRoot 'Backup-Workspace.ps1'),[ref]$guardTokens,[ref]$guardErrors)
       if($guardErrors){throw 'BACKUP_DESTINATION_PARSE_FAILED'}
       foreach($helperName in 'Assert-BackupPath','ConvertTo-BackupDestination','Test-BackupWithin'){
           $helperNode=$guardAst.Find({param($n)$n-is[Management.Automation.Language.FunctionDefinitionAst]-and$n.Name-eq$helperName},$false)
           . ([scriptblock]::Create($helperNode.Extent.Text))
       }
       $guardFixture=Join-Path ([IO.Path]::GetTempPath()) ('backup-destination-'+[guid]::NewGuid().ToString('N'))
       $guardAncestor=Join-Path $guardFixture 'cloud';$guardLeaf=Join-Path $guardAncestor 'not-created/output'
       & {
           Set-Item Function:Get-Item -Value {param([string]$LiteralPath,[switch]$Force,[string]$ErrorAction)
               if($LiteralPath-eq$guardAncestor){[pscustomobject]@{Attributes=[IO.FileAttributes]$guardCase.Attributes;LinkType=$guardCase.LinkType}}
           }
           foreach($guardCase in @(
               @{Name='ordinary directory';Attributes='Directory';LinkType=$null;Refused=$false},
               @{Name='supplied cloud directory metadata';Attributes='Directory,Archive,ReadOnly,ReparsePoint';LinkType=$null;Refused=$false},
               @{Name='supplied executable alias metadata';Attributes='Archive,ReparsePoint';LinkType=$null;Refused=$false},
               @{Name='junction ancestor';Attributes='Directory,ReparsePoint';LinkType='Junction';Refused=$true},
               @{Name='directory symbolic link ancestor';Attributes='Directory,ReparsePoint';LinkType='SymbolicLink';Refused=$true},
               @{Name='file symbolic link';Attributes='ReparsePoint';LinkType='SymbolicLink';Refused=$true}
           )){
               $guardOutcome='ALLOWED';try{Assert-BackupPath $guardLeaf}catch{$guardOutcome=$_.Exception.Message}
               $guardExpected=if($guardCase.Refused){'BACKUP_REPARSE_REFUSED'}else{'ALLOWED'}
               if($guardOutcome-cne$guardExpected){throw ('BACKUP_DESTINATION_CHECK_FAILED '+$guardCase.Name+' '+$guardOutcome)}
               'PASS destination metadata '+$guardCase.Name
           }
       }
       # Real local junction, with an absent descendant: checking only the output itself is insufficient.
       [void][IO.Directory]::CreateDirectory((Join-Path $guardFixture 'target'))
       $guardJunction=Join-Path $guardFixture 'junction'
       $null=New-Item -ItemType Junction -Path $guardJunction -Target (Join-Path $guardFixture 'target')
       $junctionOutcome='ALLOWED';try{Assert-BackupPath (Join-Path $guardJunction 'absent/output')}catch{$junctionOutcome=$_.Exception.Message}
       if($junctionOutcome-cne'BACKUP_REPARSE_REFUSED'){throw ('BACKUP_JUNCTION_CHECK_FAILED '+$junctionOutcome)}
       'PASS actual owned junction ancestor refused'
       foreach($usbPath in 'E:\ORVION-Recovery','E:\ORVION-Recovery\','E:/ORVION-Recovery/','E:\parent\..\ORVION-Recovery\'){
           if((ConvertTo-BackupDestination $usbPath)-cne'E:\ORVION-Recovery'){throw 'BACKUP_USB_FOLDER_NORMALIZATION_FAILED'}
           'PASS pure USB child folder '+$usbPath
       }
       if(!(Test-BackupWithin 'E:\ORVION-Recovery\child' 'E:\ORVION-Recovery')-or(Test-BackupWithin 'E:\ORVION-Recovery-other' 'E:\ORVION-Recovery')){throw 'BACKUP_COMPONENT_OVERLAP_FAILED'}
       'PASS lexical component overlap retains child and excludes prefix sibling'
   }
   Invoke-BackupDestinationChecks
   function Invoke-BackupRuntimePathChecks {
       $pathFixture=Join-Path ([IO.Path]::GetTempPath()) ('backup-path-'+[guid]::NewGuid().ToString('N'))
       $null=[IO.Directory]::CreateDirectory($pathFixture)
       $pathMap=Join-Path $pathFixture 'map.json';[IO.File]::WriteAllText($pathMap,'{"schema":1,"inputs":[]}')
       [IO.File]::WriteAllText((Join-Path $pathFixture 'pwsh.exe'),'synthetic nonexecutable runtime placeholder')
       # Every Scheduler entry is trapped even if a future path-guard regression reaches it.
       foreach($schedulerCommand in 'Get-ScheduledTask','Get-ScheduledTaskInfo','New-ScheduledTaskAction','New-ScheduledTaskTrigger','New-ScheduledTaskSettingsSet','New-ScheduledTaskPrincipal','Register-ScheduledTask'){
           Set-Item -Path ('Function:'+$schedulerCommand) -Value {throw 'SCHEDULER_TRAP_UNEXPECTED'}
       }
       foreach($runtimeCase in @(
           @{Name='runtime inside supplied temporary root refused';Path=(Join-Path $pathFixture 'pwsh.exe')},
           @{Name='nonexistent installed runtime refused';Path=(Join-Path $pathFixture 'missing/pwsh.exe')}
       )){
           $runtimeRefused=$false
           try{& (Join-Path $PSScriptRoot 'Backup-Workspace.ps1') -Install -Package -Destination (Join-Path $pathFixture 'out') -RecoveryInputs $pathMap -DataRoot $pathFixture -TemporaryRoot $pathFixture -RuntimePath $runtimeCase.Path -ExecutionLimitMinutes 10}catch{$runtimeRefused=$_.Exception.Message-eq'BACKUP_INSTALL_DURABLE_RUNTIME_REQUIRED'}
           if(!$runtimeRefused){throw ('BACKUP_RUNTIME_PATH_CHECK_FAILED '+$runtimeCase.Name)}
           'PASS '+$runtimeCase.Name
       }
   }
   Invoke-BackupRuntimePathChecks
   if($DailyPathOnly){return}
   function Invoke-DailyBackupChecks {
       $dailyTestsRoot=if($env:WORKBENCH_TEST_ROOT){$env:WORKBENCH_TEST_ROOT}else{[IO.Path]::GetTempPath()}
       $dailyEvidence=if($DailyEvidenceRoot){$DailyEvidenceRoot}else{Join-Path $dailyTestsRoot ('daily-evidence-'+[guid]::NewGuid().ToString('N'))}
       [void][IO.Directory]::CreateDirectory($dailyEvidence)
   # Synthetic processes and local clones only; never imports ScheduledTasks or contacts a remote.
   $ErrorActionPreference='Stop'
   $checkout=Split-Path $PSScriptRoot -Parent
   $fixture=Join-Path $dailyTestsRoot ('focus-'+[guid]::NewGuid().ToString('N').Substring(0,8))
   $github=Join-Path $fixture 'GitHub';$data=Join-Path $fixture 'data';$managed=Join-Path $fixture 'managed'
   $probe=Join-Path $github "probe ' 雪/lib";$destination=Join-Path $fixture "cloud ' 雪 `$ (literal)";$map=Join-Path $fixture "map ' 雪.json"
   $runtime=Join-Path $PSHOME 'pwsh.exe';$script:cases=[Collections.Generic.List[object]]::new();$script:processes=[Collections.Generic.List[object]]::new()
   $caseResults=Join-Path $dailyEvidence 'focused-cases.json'
   function Save-FocusedEvidence { [ordered]@{fixture=$fixture;cases=@($script:cases);processes=@($script:processes)}|ConvertTo-Json -Depth 12|Set-Content -LiteralPath $caseResults }
   function Assert-Focused([string]$Name,[bool]$Condition,[string]$Evidence=''){
       $script:cases.Add([ordered]@{name=$Name;passed=$Condition;evidence=$Evidence});Save-FocusedEvidence
       if(!$Condition){throw ('FOCUSED_FAILED '+$Name)};'PASS '+$Name
   }
   function Invoke-FixtureGit([string]$Directory,[string[]]$GitArguments){
       $output=@(& git -C $Directory @GitArguments 2>&1);if($LASTEXITCODE){throw "FIXTURE_GIT_FAILED $($GitArguments[0]) $output"};$output
   }
   function Start-FocusedProcess([string]$Label,[string[]]$NativeArguments){
       $start=[Diagnostics.ProcessStartInfo]::new($runtime);$start.UseShellExecute=$false;$start.CreateNoWindow=$true;$start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true
       foreach($argument in $NativeArguments){$start.ArgumentList.Add($argument)}
       $timer=[Diagnostics.Stopwatch]::StartNew();$child=[Diagnostics.Process]::Start($start)
       [pscustomobject]@{label=$Label;child=$child;stdout=$child.StandardOutput.ReadToEndAsync();stderr=$child.StandardError.ReadToEndAsync();timer=$timer;arguments=$NativeArguments}
   }
   function Complete-FocusedProcess($Running,[int]$TimeoutSeconds=120){
       $timedOut=!$Running.child.WaitForExit($TimeoutSeconds*1000)
       if($timedOut){$Running.child.Kill($true);$Running.child.WaitForExit()}
       $Running.timer.Stop();$output=$Running.stdout.GetAwaiter().GetResult();$errors=$Running.stderr.GetAwaiter().GetResult()
       $record=[ordered]@{label=$Running.label;pid=$Running.child.Id;arguments=$Running.arguments;exitCode=$Running.child.ExitCode;durationSeconds=$Running.timer.Elapsed.TotalSeconds;timeout=$timedOut;processExited=$Running.child.HasExited}
       [IO.File]::WriteAllText((Join-Path $dailyEvidence ($Running.label+'.stdout.txt')),$output)
       [IO.File]::WriteAllText((Join-Path $dailyEvidence ($Running.label+'.stderr.txt')),$errors)
       $script:processes.Add($record);Save-FocusedEvidence;$Running.child.Dispose()
       [pscustomobject]@{code=$record.exitCode;text=$output+"`n"+$errors;duration=$record.durationSeconds;timeout=$timedOut}
   }
   function Invoke-FocusedProcess([string]$Label,[string[]]$NativeArguments){Complete-FocusedProcess (Start-FocusedProcess $Label $NativeArguments)}
   function Read-FocusedStatus {Get-Content -LiteralPath ($destination+'.status/latest.json') -Raw|ConvertFrom-Json}
   try{
       foreach($directory in $github,$data,$managed,$probe,(Join-Path $data 'events'),(Join-Path $data 'sessions/raw')){[void][IO.Directory]::CreateDirectory($directory)}
       [IO.File]::WriteAllText((Join-Path $data 'events/events.jsonl'),'{"synthetic":true}')
       [IO.File]::WriteAllText((Join-Path $data 'sessions/raw/s.jsonl'),'synthetic session')
       # Reuse public clone objects via LOCAL clone, with independent object stores. No commits/push/reset.
       foreach($repoName in 'CRM','ORVION','CRM-trusted-main','ORVION-trusted-main','ORVION-Workbench','ORVION-Workbench-trusted-main'){
           $repo=Join-Path $github $repoName
           $null=Invoke-FixtureGit $github @('clone','-q','--no-hardlinks',$checkout,$repo)
           $null=Invoke-FixtureGit $repo @('config','remote.origin.url',('https://github.com/fixture/'+$repoName+'.git'))
           $null=Invoke-FixtureGit $repo @('config','remote.origin.pushurl','DISABLED')
       }
       $wb=Join-Path $github 'ORVION-Workbench';$receipt=[ordered]@{digest=('B'*64);root=$wb;result='READY'}|ConvertTo-Json
       [void][IO.Directory]::CreateDirectory((Join-Path $wb '.workbench-certifications'))
       [IO.File]::WriteAllText((Join-Path $wb '.workbench-local-certification.json'),$receipt)
       [IO.File]::WriteAllText((Join-Path $wb ('.workbench-certifications/'+('B'*64)+'.json')),$receipt)
       $proof=Join-Path $fixture "proof ' 雪.txt";[IO.File]::WriteAllText($proof,'synthetic approved proof bytes')
       $proofBytes=[IO.File]::ReadAllBytes($proof);$proofHash=(Get-FileHash -LiteralPath $proof).Hash
       [ordered]@{schema=1;inputs=@(@{name='required-proof';path=$proof;sha256=$proofHash})}|ConvertTo-Json -Depth 5|Set-Content -LiteralPath $map
       foreach($file in 'Backup-Workspace.ps1','Restore-Workspace.ps1','Restore-ORVION.cmd','Restore-ORVION.ps1','workspace-layout.ps1'){Copy-Item -LiteralPath (Join-Path $checkout ('lib/'+$file)) -Destination $probe}
       $backup=Join-Path $probe 'Backup-Workspace.ps1'
       $env:ORVION_DATA_ROOT=$data;$env:WORKBENCH_TEMP_ROOT=$managed
       # Pure root normalization regressions: execute the production function, no filesystem probes.
       $normalTokens=$null;$normalErrors=$null
       $normalAst=[Management.Automation.Language.Parser]::ParseFile($backup,[ref]$normalTokens,[ref]$normalErrors)
       $normalFunction=$normalAst.Find({param($n)$n-is[Management.Automation.Language.FunctionDefinitionAst]-and$n.Name-eq'ConvertTo-BackupDestination'},$false).Extent.Text
       . ([scriptblock]::Create($normalFunction))
       foreach($rootInput in 'C:\','C:/','\\fixture-server\share\'){
           $rootRefused=$false;try{$null=ConvertTo-BackupDestination $rootInput}catch{$rootRefused=$_.Exception.Message-eq'BACKUP_DESTINATION_ROOT_REFUSED'}
           Assert-Focused ('pure volume/share-root destination refusal '+$rootInput) $rootRefused
       }
       $normalizationPath="C:\fixture ' 雪 `$ (literal)\child\..\destination\"
       Assert-Focused 'pure child normalization remains fully qualified and literal' ((ConvertTo-BackupDestination $normalizationPath)-ceq"C:\fixture ' 雪 `$ (literal)\destination"-and[IO.Path]::IsPathFullyQualified((ConvertTo-BackupDestination $normalizationPath)))
       $relativeRefused=$false;try{$null=ConvertTo-BackupDestination 'C:relative'}catch{$relativeRefused=$_.Exception.Message-eq'BACKUP_DESTINATION_ABSOLUTE_REQUIRED'}
       Assert-Focused 'drive-relative destination is refused without filesystem access' $relativeRefused
       $normalMutant=$normalFunction.Replace("throw 'BACKUP_DESTINATION_ROOT_REFUSED'","return `$trimmed")
       if($normalMutant-ceq$normalFunction){throw 'ROOT_MUTANT_STALE'}
       . ([scriptblock]::Create($normalMutant))
       Assert-Focused 'MUTANT killed: root guard removed yields drive-relative result' (![IO.Path]::IsPathFullyQualified((ConvertTo-BackupDestination 'C:\')))
       . ([scriptblock]::Create($normalFunction))
       $overlapMap=Join-Path $destination 'map.json'
       $overlapMapResult=Invoke-FocusedProcess 'action-map-overlap' @('-NoProfile','-File',$backup,'-Destination',$destination,'-RecoveryInputs',$overlapMap,'-Package')
       Assert-Focused 'map inside output refuses before replacing existing application status' ($overlapMapResult.code-ne0-and$overlapMapResult.text.Contains('BACKUP_OUTPUT_SOURCE_OVERLAP')-and!(Test-Path -LiteralPath ($destination+'.status')))
       $fixtureBytes=(Get-ChildItem -LiteralPath $github,$data -Recurse -File -Force|Measure-Object Length -Sum).Sum
       $fixtureFiles=@(Get-ChildItem -LiteralPath $github,$data -Recurse -File -Force).Count
       "FIXTURE $fixtureFiles files $fixtureBytes bytes (six independent local clones of public baseline, synthetic proof/receipts/journal)"
       # Every ScheduledTasks function resolves to one of these isolated mocks. The virtual runtime
       # is never read: Get-Item/Test-Path intercept its complete ancestry. Nothing is registered.
       $virtualRuntime='C:\WS027_SYNTHETIC_RUNTIME\pwsh.exe';$global:WS027DailyMock=[pscustomobject]@{registered=$null;registrations=0;forceValues=@()}
       Set-Item Function:Get-Item -Value {param([string]$LiteralPath,[switch]$Force,[string]$ErrorAction)
           if($LiteralPath-in'C:\','C:\WS027_SYNTHETIC_RUNTIME',$virtualRuntime){return}
           $parameters=@{LiteralPath=$LiteralPath;Force=$Force};if($ErrorAction){$parameters.ErrorAction=$ErrorAction}
           Microsoft.PowerShell.Management\Get-Item @parameters
       }
       Set-Item Function:Test-Path -Value {param([string]$LiteralPath,[string]$Path,[string]$PathType)
           if($LiteralPath-eq$virtualRuntime){return $true}
           $parameters=@{};if($LiteralPath){$parameters.LiteralPath=$LiteralPath}else{$parameters.Path=$Path};if($PathType){$parameters.PathType=$PathType}
           Microsoft.PowerShell.Management\Test-Path @parameters
       }
       Set-Item Function:Get-ScheduledTask -Value {param($TaskName,$TaskPath,$ErrorAction) $global:WS027DailyMock.registered}
       Set-Item Function:New-ScheduledTaskAction -Value {param($Execute,$Argument) [pscustomobject]@{Execute=$Execute;Arguments=$Argument}}
       Set-Item Function:New-ScheduledTaskTrigger -Value {param([switch]$Daily,$At) [pscustomobject]@{Daily=[bool]$Daily;At=$At}}
       Set-Item Function:New-ScheduledTaskSettingsSet -Value {param([switch]$StartWhenAvailable,$MultipleInstances,$ExecutionTimeLimit) [pscustomobject]@{StartWhenAvailable=[bool]$StartWhenAvailable;MultipleInstances=$MultipleInstances;ExecutionTimeLimit=$ExecutionTimeLimit}}
       Set-Item Function:New-ScheduledTaskPrincipal -Value {param($UserId,$LogonType,$RunLevel) [pscustomobject]@{UserId=$UserId;LogonType=$LogonType;RunLevel=$RunLevel}}
       Set-Item Function:Register-ScheduledTask -Value {param($TaskName,$TaskPath,$Description,$Action,$Trigger,$Settings,$Principal,[switch]$Force)
           $global:WS027DailyMock.registrations++;$global:WS027DailyMock.forceValues+=([bool]$Force)
           $global:WS027DailyMock.registered=[pscustomobject]@{TaskName=$TaskName;TaskPath=$TaskPath;Description=$Description;Actions=@($Action);Triggers=@($Trigger);Settings=$Settings;Principal=$Principal};$global:WS027DailyMock.registered
       }
       # The real candidate refuses installation from this disposable fixture. Registration mocks
       # below use one explicit scratch-only durability seam; original bytes are restored before
       # the captured action executes. This is configuration proof, never runtime admission.
       $originalBackup=[IO.File]::ReadAllText($backup)
       $actualInstallRefused=$false
       try{& $backup -Destination $destination -Package -Install -RecoveryInputs $map -DataRoot $data -TemporaryRoot $managed -RuntimePath $virtualRuntime -ExecutionLimitMinutes 10}catch{$actualInstallRefused=$_.Exception.Message-match'BACKUP_INSTALL_DURABLE_INPUT_REQUIRED'}
       Assert-Focused 'actual candidate refuses disposable installed script/map/data before registration' ($actualInstallRefused-and$global:WS027DailyMock.registrations-eq0)
       $durableAnchor='foreach($durable in $PSCommandPath,$RecoveryInputs,$DataRoot)'
       if(!$originalBackup.Contains($durableAnchor)){throw 'DURABILITY_SEAM_STALE'}
       [IO.File]::WriteAllText($backup,$originalBackup.Replace($durableAnchor,'foreach($durable in @())'))
       Set-Item Function:Get-ScheduledTaskInfo -Value {param($TaskName,$TaskPath,$ErrorAction)
           if($global:WS027DailyMock.infoUnavailable){throw 'synthetic task info unavailable'}
           [pscustomobject]@{LastRunTime=[datetime]'2026-10-30T23:00:00Z';LastTaskResult=2147942402;NextRunTime=[datetime]'2026-10-31T03:17:00Z'}
       }
       $installArguments=@{Destination=$destination;Package=$true;Install=$true;RecoveryInputs=$map;DataRoot=$data;TemporaryRoot=$managed;RuntimePath=$virtualRuntime;ExecutionLimitMinutes=10;DailyAt='03:17'}
       $before=$global:WS027DailyMock.registrations;$missingRefused=$false
       try{& $backup -Destination $destination -Install}catch{$missingRefused=$_.Exception.Message-match'BACKUP_INSTALL_EXPLICIT_ARGUMENTS_REQUIRED'}
       Assert-Focused 'installation requires explicit arguments, no registration' ($missingRefused-and$global:WS027DailyMock.registrations-eq$before)
       & $backup @installArguments
       $ownedTask=$global:WS027DailyMock.registered|ConvertTo-Json -Depth 10|ConvertFrom-Json
       Assert-Focused 'mock registration is daily, limited interactive user, IgnoreNew, explicit ten-minute fixture limit' ($ownedTask.Triggers[0].Daily-and$ownedTask.Triggers[0].At.ToString('HH:mm')-eq'03:17'-and$ownedTask.Settings.MultipleInstances-eq'IgnoreNew'-and$ownedTask.Principal.LogonType-eq'Interactive'-and$ownedTask.Principal.RunLevel-eq'Limited'-and$ownedTask.Settings.ExecutionTimeLimit.TotalMinutes-eq10-and!$global:WS027DailyMock.forceValues[0])
       $encoded=($ownedTask.Actions[0].Arguments-split' ')[-1];$decoded=[Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($encoded))
       [IO.File]::WriteAllText((Join-Path $dailyEvidence 'mock-action-command.txt'),$decoded)
       $ownedTask|ConvertTo-Json -Depth 10|Set-Content (Join-Path $dailyEvidence 'mock-registration.json')
       Assert-Focused 'action preserves literal apostrophe, space, Unicode and metacharacter paths' ($decoded.Contains($destination.Replace("'","''"))-and$decoded.Contains($map.Replace("'","''"))-and$decoded.Contains($backup.Replace("'","''")))
       & $backup @installArguments
       Assert-Focused 'exact owned reinstall alone permits Force' ($global:WS027DailyMock.registrations-eq2-and$global:WS027DailyMock.forceValues[1])
       $currentUser=[Security.Principal.WindowsIdentity]::GetCurrent()
       foreach($sameUser in @($currentUser.Name,($currentUser.Name-split'\\')[-1],$currentUser.User.Value)){
           $global:WS027DailyMock.registered=$ownedTask|ConvertTo-Json -Depth 10|ConvertFrom-Json
           $global:WS027DailyMock.registered.Principal.UserId=$sameUser
           $before=$global:WS027DailyMock.registrations
           & $backup @installArguments
           Assert-Focused ('same-user representation permits owned reinstall '+$sameUser) ($global:WS027DailyMock.registrations-eq($before+1)-and$global:WS027DailyMock.forceValues[-1])
           $global:WS027DailyMock.registered.Principal.UserId=$sameUser
           $sameStatus=(& $backup -Destination $destination -Status)|ConvertFrom-Json
           Assert-Focused ('same-user representation permits status readback '+$sameUser) ($sameStatus.scheduler.state-eq'READBACK_ONLY'-and$sameStatus.scheduler.lastTaskResult-eq2147942402-and!$sameStatus.scheduler.configurationVerified)
       }
       foreach($foreignUser in @('S-1-5-18','WS027-no-such-local-user','S-1-invalid','')){
           $global:WS027DailyMock.registered=$ownedTask|ConvertTo-Json -Depth 10|ConvertFrom-Json
           $global:WS027DailyMock.registered.Principal.UserId=$foreignUser
           $before=$global:WS027DailyMock.registrations;$identityRefused=$false
           try{& $backup @installArguments}catch{$identityRefused=$_.Exception.Message-eq'BACKUP_TASK_OWNERSHIP_COLLISION'}
           Assert-Focused ('foreign or unresolvable principal refuses reinstall '+$foreignUser) ($identityRefused-and$global:WS027DailyMock.registrations-eq$before)
           $foreignUserStatus=(& $backup -Destination $destination -Status)|ConvertFrom-Json
           Assert-Focused ('foreign or unresolvable principal refuses status attribution '+$foreignUser) ($foreignUserStatus.scheduler.state-eq'OWNERSHIP_COLLISION'-and$null-eq$foreignUserStatus.scheduler.lastTaskResult)
       }
       Set-Item Function:Get-ScheduledTask -Value {param($TaskName,$TaskPath,$ErrorAction) throw [UnauthorizedAccessException]::new('synthetic access denied')}
       $before=$global:WS027DailyMock.registrations;$accessRefused=$false
       try{& $backup @installArguments}catch{$accessRefused=$_.Exception.Message-eq'synthetic access denied'}
       Assert-Focused 'task access denied never falls back to registration' ($accessRefused-and$global:WS027DailyMock.registrations-eq$before)
       $accessStatus=(& $backup -Destination $destination -Status)|ConvertFrom-Json
       Assert-Focused 'task access denied reports unavailable without result' ($accessStatus.scheduler.state-eq'UNAVAILABLE'-and$null-eq$accessStatus.scheduler.lastTaskResult)
       Set-Item Function:Get-ScheduledTask -Value {param($TaskName,$TaskPath,$ErrorAction) $global:WS027DailyMock.registered}
       foreach($collision in 'description','principal','action'){
           $global:WS027DailyMock.registered=$ownedTask|ConvertTo-Json -Depth 10|ConvertFrom-Json
           switch($collision){description{$global:WS027DailyMock.registered.Description='unrelated task'}principal{$global:WS027DailyMock.registered.Principal.UserId='unrelated user'}action{$global:WS027DailyMock.registered.Actions[0].Arguments='unrelated arguments'}}
           $before=$global:WS027DailyMock.registrations;$collisionRefused=$false
           try{& $backup @installArguments}catch{$collisionRefused=$_.Exception.Message-match'BACKUP_TASK_OWNERSHIP_COLLISION'}
           Assert-Focused ('mock '+$collision+' collision refuses replacement') ($collisionRefused-and$global:WS027DailyMock.registrations-eq$before)
       }
       [IO.File]::WriteAllText($backup,$originalBackup)
       $global:WS027DailyMock.registered=$ownedTask
       $emptyStatus=(& $backup -Destination $destination -Status)|ConvertFrom-Json
       Assert-Focused 'status separates absent application record from newer Scheduler launcher failure' ($emptyStatus.applicationState-eq'NEVER_RECORDED'-and$null-eq$emptyStatus.application-and$emptyStatus.scheduler.state-eq'READBACK_ONLY'-and$emptyStatus.scheduler.lastTaskResult-eq2147942402-and!$emptyStatus.scheduler.configurationVerified)
       $global:WS027DailyMock.registered.Description='foreign description'
       $foreignStatus=(& $backup -Destination $destination -Status)|ConvertFrom-Json
       Assert-Focused 'status refuses attributing foreign task info to backup' ($foreignStatus.scheduler.state-eq'OWNERSHIP_COLLISION'-and$null-eq$foreignStatus.scheduler.lastTaskResult)
       $global:WS027DailyMock.registered=$ownedTask|ConvertTo-Json -Depth 10|ConvertFrom-Json
       # The ownedTask object was mutated by reference above; reset its known description.
       $global:WS027DailyMock.registered.Description='ORVION Backup v1 | '+[Security.Principal.WindowsIdentity]::GetCurrent().Name+' | '+$backup+' | '+$destination
       # Direct native invocation of the exact captured action arguments; virtual executable replaced
       # by supplied 7.6.8 solely for this synthetic proof. This is NOT a scheduled run/runtime proof.
       $actionArguments=@('-NoProfile','-NonInteractive','-WindowStyle','Hidden','-EncodedCommand',$encoded)
       $success=Invoke-FocusedProcess 'action-success' $actionArguments
       $status=Read-FocusedStatus;$verified=$status.lastVerified;$verifiedJson=$verified|ConvertTo-Json -Compress
       Assert-Focused 'native captured action publishes verified package and SUCCESS status' ($success.code-eq0-and$status.result-eq'SUCCESS'-and$verified.archive-and(Test-Path -LiteralPath $verified.archive)-and$success.text.Contains('PACKAGE:')) $success.text
       $visible=(& $backup -Destination $destination -Status)|ConvertFrom-Json
       Assert-Focused 'persisted SUCCESS remains explicitly separate from Scheduler failure' ($visible.application.result-eq'SUCCESS'-and$visible.scheduler.lastTaskResult-eq2147942402-and$visible.interpretation.Contains('last persisted attempt only'))
       $global:WS027DailyMock|Add-Member -NotePropertyName infoUnavailable -NotePropertyValue $true
       $unavailable=(& $backup -Destination $destination -Status)|ConvertFrom-Json
       Assert-Focused 'unavailable TaskInfo cannot promote stale application success to Scheduler success' ($unavailable.application.result-eq'SUCCESS'-and$unavailable.scheduler.state-eq'UNAVAILABLE'-and$null-eq$unavailable.scheduler.lastTaskResult)
       $global:WS027DailyMock.infoUnavailable=$false
       $originalArchiveHash=(Get-FileHash -LiteralPath $verified.archive).Hash
       Assert-Focused 'independent archive hash equals sidecar and lastVerified' ($originalArchiveHash-ceq$verified.sha256-and[IO.File]::ReadAllText($verified.archive+'.sha256').Trim()-ceq($originalArchiveHash+' *'+[IO.Path]::GetFileName($verified.archive)))
       $zip=(Get-Command 7z -CommandType Application -ErrorAction SilentlyContinue|Select-Object -First 1).Source;if(!$zip){$zip=Join-Path $env:ProgramFiles '7-Zip/7z.exe'}
       $zipOutput=@(& $zip t $verified.archive 2>&1);$zipExit=$LASTEXITCODE
       [IO.File]::WriteAllText((Join-Path $dailyEvidence 'independent-7z.txt'),($zipOutput-join"`n")+"`nEXIT $zipExit")
       Assert-Focused 'real 7z independently verifies published archive' ($zipExit-eq0)
       $restoreTarget=Join-Path $fixture 'restored'
       $restore=Invoke-FocusedProcess 'focused-restore' @('-NoProfile','-NonInteractive','-File',(Join-Path $probe 'Restore-Workspace.ps1'),'-Package',$verified.archive,'-Target',$restoreTarget,'-ClaudeHome',(Join-Path $fixture 'restored-claude'),'-CodexHome',(Join-Path $fixture 'restored-codex'))
       $restoredProof=Join-Path $restoreTarget 'ORVION-Owner-Tools/records/recovery-inputs/required-proof'
       Assert-Focused 'focused scratch restore preserves proof and Workbench HEAD' ($restore.code-eq0-and(Get-FileHash -LiteralPath $restoredProof).Hash-ceq$proofHash-and(Invoke-FixtureGit (Join-Path $restoreTarget 'ORVION-Workbench') @('rev-parse','HEAD'))-ceq(Invoke-FixtureGit $wb @('rev-parse','HEAD'))) $restore.text
       $statusPath=$destination+'.status/latest.json';$statusBefore=[IO.File]::ReadAllBytes($statusPath)
       $held=[IO.File]::Open(($destination+'.status/operation.lock'),'Open','ReadWrite','None')
       try{$busy=Invoke-FocusedProcess 'action-busy' $actionArguments}finally{$held.Dispose()}
       Assert-Focused 'manual-held destination lease refuses independent action without status overwrite' ($busy.code-ne0-and$busy.text.Contains('BACKUP_BUSY')-and[Convert]::ToBase64String($statusBefore)-ceq[Convert]::ToBase64String([IO.File]::ReadAllBytes($statusPath)))
       $heldStatus=[IO.File]::Open($statusPath,'Open','Read','Read')
       try{$writeFailed=Invoke-FocusedProcess 'action-status-write-failure' $actionArguments}finally{$heldStatus.Dispose()}
       Assert-Focused 'atomic status replacement failure preserves previous record and verified pointer' ($writeFailed.code-ne0-and$writeFailed.text.Contains('BACKUP_STATUS_WRITE_FAILED')-and[Convert]::ToBase64String($statusBefore)-ceq[Convert]::ToBase64String([IO.File]::ReadAllBytes($statusPath)))
       $launcher=Join-Path $destination 'Restore-ORVION.ps1';$launcherHash=(Get-FileHash -LiteralPath $launcher).Hash
       $heldLauncher=[IO.File]::Open($launcher,'Open','Read','Read')
       try{$publication=Invoke-FocusedProcess 'action-launcher-failure' $actionArguments}finally{$heldLauncher.Dispose()}
       $failedStatus=Read-FocusedStatus
       Assert-Focused 'launcher publication failure retains lastVerified and original archive; new archive has no success sidecar' ($publication.code-ne0-and$failedStatus.result-eq'FAILURE'-and($failedStatus.lastVerified|ConvertTo-Json -Compress)-ceq$verifiedJson-and(Get-FileHash -LiteralPath $verified.archive).Hash-ceq$originalArchiveHash-and(Get-FileHash -LiteralPath $launcher).Hash-ceq$launcherHash-and@(Get-ChildItem -LiteralPath $destination -Filter '*.sha256').Count-eq1) $publication.text
       [IO.File]::WriteAllText($proof,'controlled changed proof')
       $refusal=Invoke-FocusedProcess 'action-proof-refusal' $actionArguments;$failedStatus=Read-FocusedStatus
       Assert-Focused 'changed required proof gives nonzero failure, sanitized cause and unchanged lastVerified' ($refusal.code-ne0-and$failedStatus.result-eq'FAILURE'-and$failedStatus.errorCode-eq'BACKUP_RECOVERY_INPUT_REQUIRED_OR_CHANGED'-and($failedStatus.lastVerified|ConvertTo-Json -Compress)-ceq$verifiedJson-and(Get-FileHash -LiteralPath $verified.archive).Hash-ceq$originalArchiveHash-and!$refusal.text.Contains('PACKAGE:')) $refusal.text
       [IO.File]::WriteAllBytes($proof,$proofBytes)
       $running=Start-FocusedProcess 'action-interrupted' $actionArguments;$observedRunning=$false;$wait=[Diagnostics.Stopwatch]::StartNew()
       while(!$running.child.HasExited-and$wait.Elapsed.TotalSeconds-lt15){
           $active=Read-FocusedStatus;if($active.result-eq'RUNNING'-and$active.runId-ne$failedStatus.runId){$observedRunning=$true;break};Start-Sleep -Milliseconds 25
       }
       if(!$running.child.HasExited){$running.child.Kill($true);$running.child.WaitForExit()}
       $interrupted=Complete-FocusedProcess $running
       $interruptedStatus=Read-FocusedStatus
       Assert-Focused 'hard termination leaves distinguishable RUNNING status and prior verified pointer' ($observedRunning-and$interrupted.code-ne0-and$interruptedStatus.result-eq'RUNNING'-and($interruptedStatus.lastVerified|ConvertTo-Json -Compress)-ceq$verifiedJson)
       [IO.File]::WriteAllText($proof,'controlled changed proof after interruption')
       $afterKill=Invoke-FocusedProcess 'action-after-interruption' $actionArguments
       Assert-Focused 'abandoned file does not block new owner; controlled refusal updates status' ($afterKill.code-ne0-and(Read-FocusedStatus).errorCode-eq'BACKUP_RECOVERY_INPUT_REQUIRED_OR_CHANGED'-and!$afterKill.text.Contains('BACKUP_BUSY'))
       [IO.File]::WriteAllText((Join-Path $data '.git'),'synthetic forbidden data-root metadata')
       $preamble=Invoke-FocusedProcess 'action-preamble-refusal' $actionArguments;$failedStatus=Read-FocusedStatus
       Assert-Focused 'original preamble data-root refusal is visible with retained lastVerified' ($preamble.code-ne0-and$failedStatus.result-eq'FAILURE'-and$failedStatus.errorCode-eq'BACKUP_DATA_ROOT_GIT_REFUSED'-and($failedStatus.lastVerified|ConvertTo-Json -Compress)-ceq$verifiedJson)
       $overlapDestination=Join-Path $data 'unsafe-output'
       $overlap=Invoke-FocusedProcess 'action-overlap-refusal' @('-NoProfile','-NonInteractive','-File',$backup,'-Destination',$overlapDestination,'-RecoveryInputs',$map,'-Package')
       Assert-Focused 'output within copied data refuses before unsafe output or status writes' ($overlap.code-ne0-and$overlap.text.Contains('BACKUP_OUTPUT_SOURCE_OVERLAP')-and!(Test-Path -LiteralPath $overlapDestination)-and!(Test-Path -LiteralPath ($overlapDestination+'.status')))
       [ordered]@{files=$fixtureFiles;bytes=$fixtureBytes;packageBytes=(Get-Item -LiteralPath $verified.archive).Length;successfulBackupSeconds=$success.duration;reportedBackupSeconds=$status.elapsedSeconds;fixtureLimitMinutes=10;productionLimit='NOT_YET_PROVEN';actualScheduledSuccess='NOT_YET_PROVEN';actualScheduledRefusal='NOT_YET_PROVEN'}|ConvertTo-Json|Set-Content (Join-Path $dailyEvidence 'measurements.json')
       'FOCUSED PASS '+$script:cases.Count
   }finally{Save-FocusedEvidence}

   }
   Invoke-DailyBackupChecks
   if($DailyBackupOnly){return}
   ```

   The resulting file's Git blob is 3ad21a014e8d1f6b22a2b49afdb1c7f92e5598b8.

3. Check whether `lib/README.md` contains `Selected recovery coverage, explicit daily opt-in`; if so record Already Applied when its Git blob is b143493d40a0bc2b19944653f01befffb600c3f4, and otherwise stop and report. Otherwise make exactly these 2 edits (route operator semantics to Recovery and remove the dead STATE assumption), each matched once, and change nothing else:

   a) replace the line
   ```text
   Pulse supplies live state; use the private STATE.md route from the root resume file, never a copied owner-wait inventory. If STATE.md is missing or unreadable, resume from Pulse's `in flight` lines; if commands cannot run, read the newest `RESUME HERE` entry in the journal (`Events.ps1 -Find 'resume here'`). Before authorized operational work, Events -Find returns relevant lessons and Spider recovers a specific original fact. Use the actual resolved data root described above, not a second journal. Find a comparable executed contract in its owning repository and reuse its proven shape. Hunt Quick NoRecord is bounded gap discovery; full Hunt is reserved for relevant risky work. A first diagnosis is a hypothesis until measured.
   ```
   with
   ```text
   Pulse supplies live state through the root resume route, never a copied owner-wait inventory or a presumed STATE.md file. Resume from Pulse's `in flight` lines; if unavailable, use the newest `RESUME HERE` entry in the journal (`Events.ps1 -Find 'resume here'`). Before authorized operational work, Events -Find returns relevant lessons and Spider recovers a specific original fact. Use the actual resolved data root described above, not a second journal. Find a comparable executed contract in its owning repository and reuse its proven shape. Hunt Quick NoRecord is bounded gap discovery; full Hunt is reserved for relevant risky work. A first diagnosis is a hypothesis until measured.
   ```

   b) replace the line
   ```text
   | `Backup-Workspace.ps1 -Destination <usb>` / `Restore-Workspace.ps1 -From <backup>` | everything a clone cannot restore; encrypted drive required; restore never overwrites. Selective package v1: `-Package` (both) makes or restores one unencrypted 7z with a redacted secret-scan report instead (`..\docs\RECOVERY.md`) |
   ```
   with
   ```text
   | `Backup-Workspace.ps1 -Destination <folder> [-Package] [-Install] [-Status]` / `Restore-Workspace.ps1 -From <backup>` | Selected recovery coverage, explicit daily opt-in and separate application/Scheduler status. The directory route requires an encrypted drive; the package is unencrypted. [Recovery](../docs/RECOVERY.md#daily-backup-opt-in-and-observation) owns arguments, durable inputs, retention and proof limits. Restore never overwrites. |
   ```

   The resulting file's Git blob is b143493d40a0bc2b19944653f01befffb600c3f4.

4. Check whether `docs/RECOVERY.md` contains `## Daily backup opt-in and observation`; if so record Already Applied when its Git blob is edbc4cb2a4c11abec99329bd994ab9faa5662635, and otherwise stop and report. Otherwise make exactly these 8 edits (document earned coverage, opt-in observation, durable inputs/runtime, retention and unproven execution), each matched once, and change nothing else:

   a) replace the line
   ```text
   Updated 2026-10-27. [Workspace layout](WORKSPACE-LAYOUT.md) owns the source/private/disposable boundary.
   ```
   with
   ```text
   Updated 2026-10-30 (WS027 V3 candidate, not installed approval). [Workspace layout](WORKSPACE-LAYOUT.md) owns the source/private/disposable boundary.
   ```

   b) replace the line
   ```text
   approvals, evidence, unique sandbox commits and Claude memory exist only locally. They travel in ONE compressed package
   ```
   with
   ```text
   approvals, evidence and Claude memory exist only locally. The selected coverage below travels in ONE compressed package
   ```

   c) replace the lines
   ```text
   | Reviewed retained legacy inputs and Windows-Memory-Config; historical source locations below | node_modules (reinstalled from lockfiles) |
   | Per nested clone: its ignored files in place, `.clone-state\unique.bundle` (HEAD and every tip the main bundles lack), `staged.diff`, `worktree.diff`, `untracked\` | Claude/Codex program files, plugins, other projects' transcripts |
   ```
   with
   ```text
   | Explicit reviewed recovery-input files with approved hashes; no automatic inclusion of former legacy directories | node_modules (reinstalled from lockfiles), former legacy directories unless explicitly inventoried |
   | Required evidence retained in the data root or declared as recovery inputs | Disposable nested clones, their ignored/uncommitted files and unique refs not preserved elsewhere; Claude/Codex program files and plugins |
   ```

   d) replace the line
   ```text
      interrupted, inspect its owned staging under the managed temporary root before removing it. Keep the newest two or three packages; retire older copies only after required evidence/retention checks.
   ```
   with
   ```text
      interrupted, inspect its owned staging under the managed temporary root. Retain verified packages; there is no automatic pruning. Disposal needs separate owning authority and retention checks.
   ```

   e) replace the line
   ```text
   The launcher invokes both the narrow -Temporary rebuild and Map-Repos -Install after restore. The latter restores the hourly/logon refresh task and regenerates ai-map.html/json, the named source-root exceptions. Use the explicit commands above for manual fallback or an owning failed-step recovery. A restored task or map is discovery evidence, never certification.
   ```
   with
   ```text
   The launcher invokes both the narrow -Temporary rebuild and Map-Repos -Install after restore. The latter registers the hourly/logon refresh task and returns without generating ai-map.html/json. Run `pwsh -NoProfile -File <Target>\ORVION-Workbench\lib\Map-Repos.ps1 -GitHub <Target>` explicitly when immediate map generation is required. Those outputs are named source-root exceptions. Use the explicit commands above for manual fallback or an owning failed-step recovery. A restored task or map is discovery evidence, never certification. The daily backup task needs its own explicit registration below.
   ```

   f) replace the line
   ```text
   Rebuild a nested clone only when needed: clone its `.clone-state\state.json` origin (or the restored main repository
   ```
   with
   ```text
   Historical packages only: if an older package actually contains `.clone-state` evidence, rebuild a nested clone only when needed from its `.clone-state\state.json` origin (or the restored main repository
   ```

   g) immediately after the lines
   ```text
   restored ignored files back. Keep a sandbox's push disabled: `git remote set-url --push origin DISABLED`.

   ```
   insert
   ```text
   ## Daily backup opt-in and observation

   WS027 V3 extends the existing engine with explicit `-Install`; an ordinary backup does not register or start a task.
   After exact native admission, supply reviewed absolute paths in this interface (angle-bracket values are operator inputs, not executable examples):

   `pwsh -NoProfile -File <durable-checkout>\lib\Backup-Workspace.ps1 -Install -Package -Destination <folder> -RecoveryInputs <map.json> -DataRoot <data-root> -TemporaryRoot <managed-temporary> -RuntimePath <installed-pwsh.exe> -ExecutionLimitMinutes <measured-limit> -DailyAt 02:00`

   The destination must be an absolute child folder, never a volume/share root. An existing USB child folder such as
   `E:\ORVION-Recovery\` remains valid; root refusal avoids drive-relative normalization and a status folder inside the output.
   The ancestor metadata walk refuses PowerShell LinkType Junction or SymbolicLink. A ReparsePoint flag with null LinkType,
   as in the supplied approved OneDrive metadata, is allowed. This does not prove other reparse tags safe, resolve all
   namespace/volume aliases, prevent path changes between checks and use, or prove cloud hydration/access/atomicity.
   Output/status must not overlap copied sources or the recovery map. The task is daily, StartWhenAvailable, IgnoreNew, interactive current user, limited
   privilege. Logged-out execution, missed-trigger behavior and actual ScheduledTasks/runtime compatibility are
   NOT_YET_PROVEN. No password, elevation, runtime installation, task execution or automatic deletion is added.
   One shared OS file handle excludes manual and scheduled publishers at the destination. An abandoned
   `<destination>.status/operation.lock` file is not an active lease; do not remove a live publisher's lock.

   Read `Backup-Workspace.ps1 -Destination <folder> -Status`. The JSON envelope separates `applicationState` and
   `application` from `scheduler`. Application bytes come from `<destination>.status/latest.json`: attempt runId,
   UTC start/end, duration, RUNNING/SUCCESS/FAILURE, sanitized errorCode, and lastVerified package path/hash/runId/map
   reference. This is the last persisted application attempt, never a claim about the latest Scheduler outcome.
   Binding, root/overlap/reparse preflight and install refusals may occur without a record. Hard termination can leave
   RUNNING; status-write failure can leave prior bytes. NEVER_RECORDED and UNREADABLE are explicit observations.

   The Scheduler section reads only the destination-derived task name at `\`, checks description/account/principal,
   then reads Get-ScheduledTaskInfo's LastRunTime, LastTaskResult and NextRunTime. READBACK_ONLY is observation,
   not complete action/configuration verification; `configurationVerified` remains false. Foreign identity yields
   OWNERSHIP_COLLISION; absent/unavailable module/task/info yields UNAVAILABLE, not success. Correlate timestamps,
   task/action/account and application runId during actual proof. A newer launch/preflight failure must not be described
   as a fresh success because an older application SUCCESS exists. Scheduler exit zero alone does not verify an archive.

   For installation ownership and status attribution, Windows resolves short or qualified account names to a SID;
   a reported SID is parsed directly. Only the current Windows user's SID matches. Foreign, empty, malformed or
   unresolvable identities refuse ownership; lookup/access failure grants no fallback. Description, limited interactive
   principal and one-action checks remain, with exact executable/arguments required for replacement.

   lastVerified advances only after archive test/hash, staging cleanup, launcher copies and hash-sidecar publication.
   A successful directory backup does not advance it. Refusal, partial publication and interruption retain the previous
   verified pointer and archive. Scanner findings/failure/skipping do not block successful publication or pointer advancement;
   previous archives remain retained. Status replacement is one same-directory
   move; local failure preservation is tested, cloud/remote atomicity and crash durability are unproven. Failed pending
   records/partial archives can remain for inspection. Nothing prunes archives. Scan findings,
   failure or skipping are report-only; Git history inside bundles is outside scan coverage. Concurrent source changes
   are possible: this is not a coherent snapshot. Shared restore launchers and second-resolution archive-name refusal
   remain engine limitations. Candidate C launcher's staging retention above is unchanged and separate.

   ### Durable recovery inputs and runtime

   The owner/reviewer supplies and approves the map; no script generates approval by recomputing changed hashes.
   Keep it and its input files in durable owner-selected private records, for example
   `<data-root>/records/recovery-inputs-approved/map.json`, outside disposable tools/fixtures. Schema 1 is
   `{"schema":1,"inputs":[{"name":"required-proof","path":"C:\\durable\\proof.json","sha256":"<64 uppercase hexadecimal characters>"}]}`.
   Inputs must be a nonempty array with unique lowercase names matching `[a-z][a-z0-9-]{0,47}`, absolute file paths and
   approved uppercase SHA256. Record each entry's producer, purpose, durable original location, map location and approved
   map/file hashes in the owning reviewed inventory. Existing receipt and journal requirements still apply. The engine
   checks original and copied bytes; it refuses missing/changed inputs. The map path in status is only a reference.
   Restore puts approved files at `<Target>/ORVION-Owner-Tools/records/recovery-inputs/<name>` and the source inventory
   in that directory's source-map.json (or a hash-suffixed source map when retaining an earlier map). Review recovered
   paths and explicitly author/approve a durable map for the new configuration; old physical paths are historical.

   Use an existing supported installed absolute pwsh.exe, a durable Workbench checkout, durable data root and map.
   Installation refuses runtime/script/map/data under ORVION-Workbench-temporary or the supplied temporary root and
   refuses output/input overlap. These bounded lexical/reparse checks do not detect every alias or guarantee future
   availability. Approved input files' individual durability remains an inventory/proof obligation. Portable 7.6.8 is a
   test dependency only. Installed Store 7.6.9 is a possible runtime only after its exact path/version/account access,
   module loading, encoded action and readback are actually proven. No tool-tree copy or installation is implied.
   Changed runtime/action paths intentionally fail exact ownership matching on reinstall. Inspect the exact task,
   description/account/action/destination, then use its admitted owning lifecycle to remove only the verified owned
   registration and explicitly re-register/re-prove reviewed inputs. Never replace a foreign task. No removal is done here.

   ### Required execution proof

   Actual scheduled success, scheduled controlled refusal, durable installed runtime and production execution limit:
   NOT_YET_PROVEN. Synthetic direct-action/mock results are feasibility only. Before each owning live native Review/Complete,
   measure a complete representative run including packaging, verification, staging cleanup and publication, choose
   headroom against the real workload, and read back the selected execution limit. A fixture duration cannot bound the
   owner workspace. After exact admission let an owned near-term trigger actually fire success and then a controlled
   refusal, capture correlated Scheduler/application results, and independently verify/hash/restore the successful package
   and prove refusal preserves it. Inspect the daily definition separately. Direct invocation/manual task start/mock
   registration cannot substitute. Sandbox proof covers synthetic roots; original durable configuration and representative
   workload need their own Gate and root-bound receipt before original Review/Complete. Full native gates and the two
   independent fresh same-candidate reviews remain mandatory. No clean-machine or cloud recovery proof is claimed.

   ```

   h) replace the line
   ```text
   The separate USB route remains available: Backup-Workspace -Destination <drive> requires an encrypted drive and reports a dirty checkout (uncommitted work is not in a bundle). Enable BitLocker To Go before that route. Restore-Workspace -From <backup> verifies every manifest hash before writes, never overwrites, and restores refs/HEAD, safe local configuration and bound records. Re-login to both GitHub accounts and run each owning Boot afterward. The earlier backup/restore fixture proved identical refs, bytes and expected Boots, plus corrupt/existing-target refusals; that simulated proof never established clean-Windows recovery. System-drive BitLocker remains an owner choice, distinct from the unencrypted package decision.
   ```
   with
   ```text
   The separate USB route remains available: Backup-Workspace -Destination <absolute USB child folder> requires an encrypted drive and reports a dirty checkout (uncommitted work is not in a bundle). Enable BitLocker To Go before that route. Restore-Workspace -From <backup> verifies every manifest hash before writes, never overwrites, and restores refs/HEAD, safe local configuration and bound records. Re-login to both GitHub accounts and run each owning Boot afterward. The earlier backup/restore fixture proved identical refs, bytes and expected Boots, plus corrupt/existing-target refusals; that simulated proof never established clean-Windows recovery. System-drive BitLocker remains an owner choice, distinct from the unencrypted package decision.
   ```

   The resulting file's Git blob is edbc4cb2a4c11abec99329bd994ab9faa5662635.

5. Check whether `docs/EXECUTION-PLAN.md` contains `WS027 V3 candidate adds minimal daily opt-in`; if so record Already Applied when its Git blob is bd239c754412bf035caadfeb931066663682f1b0, and otherwise stop and report. Otherwise make exactly these 2 edits (correct the cancelled reinstall prerequisite and retain native proof obligations), each matched once, and change nothing else:

   a) replace the line
   ```text
   8. **Stage7 closure:** reconcile all original P3/P4/master gaps. Since 2026-10-26 it is not a Batch 6 prerequisite: the Batch 6 gate is HANDOFF §12 as amended (A/B released, C1 by WS-015, Founder ADR-0033 routing, Shared Evidence waived, CTRL-19 OPEN with accepted risk, C2 at the owner's Windows reinstallation, then one recorded lift). Stages 2-7 continue only when a product task earns them. No automatic hold lift.
   ```
   with
   ```text
   8. **Stage7 closure:** reconcile all original P3/P4/master gaps. Since 2026-10-26 it is not a Batch 6 prerequisite: the Batch 6 gate is HANDOFF §12 as amended (A/B released, C1 by WS-015, Founder ADR-0033 routing, Shared Evidence waived, CTRL-19 OPEN with accepted risk, then one recorded lift). The owner cancelled the planned reinstallation on 2026-10-27; C2 is not a current reinstall prerequisite. Clean-Windows recovery remains unproven. Stages 2-7 continue only when a product task earns them. No automatic hold lift.
   ```

   b) immediately after the lines
   ```text
   Stage6 addition: a backup that reports success while omitting required proof is unacceptable. Require present nonempty structurally valid proof-input arrays and receipt-file arrays, valid nonempty positive controls, permanent missing/null/empty/scalar/object/invalid-entry negatives and no success manifest/restore writes on refusal. The corrected WS013R2 owns fresh V1/V2/V3 and its completed isolated native Finish/live Review; original certification remains separately gated; the rejected Draft's passing Finish cannot certify it. Inventory stable actual source/trusted/authority/evidence/meaningful knowledge/private archives and retained unique certificates explicitly; distinguish selected scope from complete coverage. Real offsite recoverability needs observed upload/download archive identity (unencrypted by owner decision 2026-10-26), recoverable MFA, extraction, exact refs/config/receipts/provenance/navigation and fresh clean-Windows cold starts. Cloud quota, a mounted destination, local round trip or readable GitHub source alone proves none of these.

   ```
   insert
   ```text
   WS027 V3 candidate adds minimal daily opt-in around the existing backup engine. [Recovery](RECOVERY.md#daily-backup-opt-in-and-observation) owns the interface, observation/durability/retention semantics and required execution proofs. Actual scheduled success/refusal, installed runtime compatibility and representative production limit remain NOT_YET_PROVEN and are required before the corresponding root's live native Review/Complete. Candidate C restore staging retention remains as documented there; no deletion or coherent-snapshot redesign is included. D70 is a WS027 role exception, not a standing workflow change.

   ```

   The resulting file's Git blob is bd239c754412bf035caadfeb931066663682f1b0.

6. Check whether `RESUME.md` contains `Live state: lib/Pulse.ps1`; if so record Already Applied when its Git blob is 98d0a8fc575156f56696803582d6285b9a53cf03, and otherwise stop and report. Otherwise make exactly this one edit (correct only the dead live-state route; the native lifecycle owns the active pointer), each matched once, and change nothing else:

   a) replace the line
   ```text
   Live state: ..\ORVION-Owner-Tools\STATE.md (private; data root resolved by Pulse; see lib/README.md)
   ```
   with
   ```text
   Live state: lib/Pulse.ps1 (resolved data root); if unavailable use the newest RESUME HERE journal entry through lib/Events.ps1 -Find 'resume here'; see lib/README.md.
   ```

   The resulting file's Git blob is 98d0a8fc575156f56696803582d6285b9a53cf03.

## Acceptance Criteria

All entries remain unchecked for native delivery. V3 preparation observations in Verification Notes do not close these future root-bound requirements.

- [ ] Exact scoped output; check: blob:lib/Backup-Workspace.ps1=74672716ceda409be894f50a0f4198f93a94a9c4
- [ ] Exact scoped output; check: blob:lib/test-backup-restore.ps1=3ad21a014e8d1f6b22a2b49afdb1c7f92e5598b8
- [ ] Exact scoped output; check: blob:lib/README.md=b143493d40a0bc2b19944653f01befffb600c3f4
- [ ] Exact scoped output; check: blob:docs/RECOVERY.md=edbc4cb2a4c11abec99329bd994ab9faa5662635
- [ ] Exact scoped output; check: blob:docs/EXECUTION-PLAN.md=bd239c754412bf035caadfeb931066663682f1b0
- [ ] Exact scoped output; check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [ ] Preserve the complete legacy backup/restore assertion body (prior executed Prototype: 129 PASS, exit 0). Run independent existing assertions through the actual owning native schedule on the final candidate; no assertion removal, weakening, mirror-only substitution or prior-result reuse. Inspect actual consumers: tests.ps1 discovers the owning suites; test-workspace-layout.ps1's all probe invokes Backup-Workspace for missing-data refusal. Current-candidate native verification must cover that consumer as well. No raw tests.ps1 or full Finish is run by this V3 author.
- [ ] Run the default complete lib/test-backup-restore.ps1 with explicit synthetic roots and full stdout/stderr/exits; it includes the focused daily and path blocks. The -DailyBackupOnly and -DailyPathOnly switches remain diagnostic routes, not required duplicate runs of an unchanged passed block. The default owning suite includes both new checks and unchanged legacy assertions. Confirm independent Git/7z/hash/restore controls, exact literal action arguments, SID-equivalent short/full/SID account identity with foreign/unresolvable/access-denied refusal; task identity/Force collision refusals, path/runtime/map overlap refusals, shared lock, measured same-directory replacement failure preservation, interrupted RUNNING/reacquisition, sanitized failure and unchanged lastVerified/archive under refusals and publication failures. Preserve failed harness attempts separately. Mock registration uses a declared scratch-only script/map/data durability seam, restores exact candidate bytes before executing the captured action, and never proves real scheduling/durable installation.
- [ ] Pure root/path positives and negatives require no filesystem access to drive/share roots; USB child folders with slash variants remain valid. Execute exact production helpers against supplied cloud/executable-alias metadata and actual owned junctions; reject Junction/SymbolicLink at every inspected ancestor, allow null LinkType reparse metadata. Null LinkType is not a reparse-tag classification, atomic namespace control or cloud/Store compatibility proof. Independently kill semantic mutations of cloud acceptance, redirect/ancestor refusal, component overlap and status separation; source pins, exact rows/replacements, original PASS and behavioral mutant failure must be retained. The root-guard mutant must expose the original drive-relative defect. Retain existing integrity/refusal/credential/recovery mutants and literal Draft controls; the accepted applier must reproduce all filtered output blobs from the declared baseline, reject a wrong blob without writes, and recognize Already Applied. RESUME's declared step blob assumes only the native allocated active-pointer line; its normalized-resume criterion governs the actual route body across allocation/Complete. Preparation itself keeps None.
- [ ] Application status and Scheduler readback remain separate. Exercise no application record, stale SUCCESS with newer nonzero Scheduler result, unavailable TaskInfo and foreign task identity. Application SUCCESS is only the last persisted attempt; READBACK_ONLY is never complete configuration verification. Parameter binding, preflight and startup failure can lack a record; UNAVAILABLE and stale RUNNING never become fresh success. Independently verify the archive/hash/sidecar before calling it VERIFIED. No pruning, scanner guarantee or coherent-snapshot claim.
- [ ] Freeze fresh distinct complete V1/V2/V3, then obtain two independent fresh reviews of the same final candidate (source/test/docs/Draft digests identical for both reviewers). D70 permits all WS027 roles in latest compatible Sol/high; independence is distinct fresh same-provider sessions, not provider diversity. Preserve findings, fixes and any required new exact-candidate reviews honestly. No live research, F6 waiver or WS032 qualification is inferred from D68's supplied source-pack exception.
- [ ] Admit the sandbox root under the actual accepted native Gate and final selected Draft before any live native action. Its subject is isolated synthetic Git/data/profile/map/destination fixtures. Run all native full Finish gates with their required live runner/watch/host evidence and fresh root-bound receipt; preserve failures/limits. Scheduler fixtures need exact owning admission, existing installed runtime, unique verified owned task identity and literal reviewed action/environment controls. A sandbox fixture action may execute the exact candidate at its synthetic checkout only under that explicit fixture authority; it does not claim durable -Install admission (which correctly refuses disposable script/map/data). No production data is touched. If actual Scheduler fixture proof cannot be safely admitted, stop before that root's live Review/Complete; do not substitute mocks or defer required proof until after Complete.
- [ ] Before sandbox live Review/Complete, let an admitted owned near-term trigger actually fire success and then a controlled synthetic refusal for the same final candidate. Separately read back its daily definition, account/principal, exact executable/arguments/environment, settings and execution limit. Capture TaskInfo times/results and correlated application runId/status, complete duration and fixture workload. Independently verify/hash/test/restore successful bytes and prove refusal retains the lastVerified/archive/sidecar. Registration inspection, direct invocation, mock task or manual Scheduler start is insufficient. Bound only this synthetic workload, never the original workspace. Scheduled descendant/timeout behavior and stale status must be observed honestly.
- [ ] After successful sandbox proof/receipt and separate exact original Gate, apply only the six literal source edits in the original root. Validate actual durable installed runtime, script checkout, data/map/input locations, approved map/file hashes, producers/purposes and recovery locations using the owning reviewed inventory. Verify source/output/status separation, task ownership and real action readback. Do not silently approve changed evidence by hashing it again. Existing receipts/journal remain mandatory; use valid then-current receipts, never require a future final Complete receipt inside the pre-Complete backup.
- [ ] Before ORIGINAL live Review/Complete, measure a representative complete backup of the actual clean original configuration/workload, including package creation, verification, staging cleanup, launcher/sidecar and status publication; record file/byte counts and headroom rationale. Select and read back the explicit production execution limit (1..1440 minutes). Fixture seconds/ten-minute mock setting do not establish it. Explicitly install only the exact owned daily task; after admission let an owned near-term trigger actually fire success then a controlled refusal with reviewed recoverable inputs. Preserve prior approved bytes, then restore the reviewed input after the refusal through its owning authority, without silently reapproving it. Retain correlated real Scheduler/application results, actual runtime/account/environment, archive/hash/sidecar and independent verification/restore evidence. Return the task to the reviewed daily definition and read it back; no unrelated tasks or data are touched. NOT_YET_PROVEN until actually observed.
- [ ] Original full native Finish/live Review/Complete/release require their own fresh root-bound receipt and exact selected Draft/source identity, actual scheduled proofs and measured representative limit. Sandbox results do not certify original roots, durable operation or production timing. No native gate is waived; retain required timing/watch/headroom and independent assertions. Do not rerun an unchanged passed expensive check without a source/failure/concern reason. Neither source publication nor a task result establishes clean-machine/cloud recovery.
- [ ] Operator docs accurately describe selected coverage, no automatic legacy/nested backup, approved map schema/location/producer/purpose/hashes/recovered inventory, installed runtime/re-registration, application/Scheduler limits, no archive pruning and Candidate C retention. Correct the dead STATE route and cancelled reinstall prerequisite; preserve dated historical evidence. Keep one authoritative Recovery home and route other docs there. No private contents or active-contract allocation in this candidate.

## Review Gate

- [ ] Observe current live root, final selected Draft/source/test/docs fingerprints, native receipt, runner/watch coverage and all acceptance evidence, including that root's actual triggered success/refusal and complete measured workload/limit. Original review separately checks original installation and receipt.
- [ ] Two fresh independent same-candidate reviews are actually complete and reconciled. Same-provider independence is labelled. No phase author statement is an independent review or release approval.
- [ ] Remaining risks are explicit: live source copy is not a coherent snapshot; unencrypted archive/report-only scanner excludes bundle history; shared launchers and second-resolution archive collision refusal remain; status can be stale/unreadable; partial/staging/pending artifacts may remain; namespace/volume aliases, account availability, installed Store runtime and real Scheduler termination behavior need actual proof. New bounded refusal does not claim a speculative security engine.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

This is the prospective implementation checkpoint. Actual native admission, final reviews, Scheduler/runtime/production-limit evidence are outstanding prerequisites, not claimed completed work. If later blocked, use the owning existing recovery policy and retain evidence; do not change direction or weaken gates.

## Execution Log

Append only. No approval or execution-root binding is claimed here. At actual approval append exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line with actual immutable identities. For original execution append the actual Sandbox Receipt and Sandbox Receipt SHA256 binding the successful schema2 sandbox artifact to that selected Draft. Preserve its log/source identity. Any live delegated decision must identify the actual delegation and never be attributed falsely to a human exact-digest message. No future receipt or self-hash is fabricated.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-027\package\assurance\V3\DRAFT.md
Approved SHA256: 40C0E73C1851A4E47BF06558C7A2ED61E23501D06089A972C257F8B391FB619A
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-027\package\gate\GATE1-WS027-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: 1C2E3D654FC044D3BE09B0A4DF4583F9542A63A60948CBCA3BD4675B192A8891
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-027\package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: C69708556DD71517370406CB5E3FE289C92215676CC61C26ABB03C769DFE7911

## Verification Notes

PROVEN — isolated V3 preparation, not native execution: frozen V1 and V2 SHA256 values match supplied bytes. Exact production Assert-BackupPath SHA256 878ADC21011446DCDCA7930E603C9DAAAB7837DBB391FCC089271F37C3BFA2EE matches PINNED-DEPLOYMENT-METADATA.json and its exact V2 source pin. Reuse is limited to that unchanged helper's supplied native 7.6.8 acceptance of the approved OneDrive folder/WindowsApps alias metadata and the supplied ordinary installed 7.6.9 no-profile launch/hash. No delegate private-path probe occurred. Null LinkType is neither cloud-tag classification nor atomicity/confinement/availability proof; actual Backup Scheduler/installation behavior remains unproven.

The supplied ROOT-PRINCIPAL-METADATA.json reports the current qualified name versus Scheduler's short name, with both direct full-name and SID-text comparisons false. ROOT-PRINCIPAL-RESOLUTION.json reports supported NTAccount translation to the exact current SID. V2's raw string check can falsely reject that representation. V3 adds only Test-BackupTaskUser and replaces the two raw account predicates in -Install/-Status with SID equivalence. SID strings use SecurityIdentifier; names use NTAccount.Translate; the result must equal WindowsIdentity.GetCurrent().User. Empty, malformed, foreign or unresolvable identity refuses ownership; access errors grant no fallback. Description, Interactive/Limited, one action and exact reinstall executable/arguments checks remain unchanged. This is no identity framework or real Scheduler qualification.

Every V2 assertion text and complete 129-assertion legacy body is preserved. V3 adds 16 owning checks for short/full/SID reinstall/status and foreign/local-system/empty/malformed/unresolvable identities plus denied task access. The changed Backup/test subjects require a fresh default complete owning run. All V3 outcomes, stdout/stderr/exits and meaningful source hashes are bound by SOURCE-MANIFEST.json and evidence/final-results.json; the launcher must check these files before freeze. The complete refreshed local owning result is 190 PASS (129 legacy, 47 daily, 12 destination, 2 runtime). The current workspace-layout consumer result is 45 PASS. These are focused/owning synthetic fixtures, not raw tests.ps1/full Finish or native receipts. See evidence/CHANGE-EVIDENCE.md for exact check/reuse subjects, semantic assertions, native feasibility and risks. Prior failures remain in immutable inputs and new attempts are retained distinctly.

Unchanged exact production helper semantics retain bounded V2 evidence: ten original PASS/behavioral mutant assertion failures (no parser kills); root/path/status controls and publication/refusal/hash/restore behavior are also exercised by the fresh V3 owning suite. Changed identity controls and both call sites receive separate independent semantic counterexamples using actual production AST, with originals passing and parseable mutants failing behaviorally. These are bounded assertions, never complete coverage or real Scheduler execution. All six exact literal outputs are replayed through the unchanged accepted helper, including wrong-blob preflight refusal/no writes and Already Applied. Preparation keeps RESUME None; only the normalized live-state route is a candidate change. Its declared literal blob simulates the later native allocated pointer; neither this simulation nor a normalized digest is a native pointer binding.

Native admission FEASIBILITY uses unchanged accepted parser/checker/applier/helper identities, actual scope/checks/profiles/context declarations, version observations and recipe input inventories. V2 put operational prose inside the strict Execution Context section; V3 moves it to Preparation Environment, preserving every declared value. Physical roots/private immutable assurance paths are not followed. Final physical-root checks, external immutable-artifact verification, owner/digest/root binding, leases/headroom/watchers, full sandbox/original Finish and fresh receipts remain later mandatory gates after selection and final dual review. Structural/literal/owning fixture results never aggregate into certification.

| Snapshot | Decision / actual reason | Result boundary |
| --- | --- | --- |
| V1 / supplied frozen Sol/high Design | REVISE: blanket reparse refusal rejects approved cloud metadata; atomicity/scanner language overclaims | Frozen unchanged; its digest above is verified against supplied bytes |
| V2 / supplied frozen Sol/high Adversarial | REVISE: supported same-user short account representation fails raw comparison; strict context includes prose | Preserve LinkType correction and all engine/assertion behavior; exact unchanged helper evidence may be reused |
| V3 / actual fresh Sol/high Evidence Refresh under D70 | SELECTED: smallest SID-equivalence correction, all old assertions, refreshed changed-subject checks and strict context grammar | Candidate ready for external freeze/review only; no formal final review, Gate, receipt or deployment claim |

| Review position | Verdict / evidence | Rebuttal / disposition |
| --- | --- | --- |
| V3 phase author | SELECT V3 for launcher freeze; bounded local results in manifest/evidence | Not independent final review; no invented agreement |
| Independent fresh reviewer 1 | UNVERIFIED, not run here | Must review identical externally frozen final subject |
| Independent fresh reviewer 2 | UNVERIFIED, not run here | Must review that same subject and reconcile material findings before Gate |

Sources are the supplied D68 WS027-only pack S1-S5 and frozen V1/V2 source/provenance/logs; no live search, WS032 or F6 claim. S1-S3 repository public source at baseline 4173639609f3f762bf9f47dd034d2df65d0a0ddd: Backup-Workspace complete, Map-Repos scheduling excerpt and test-backup-restore assertion excerpt, respectively; publication dates unspecified; supplied-pack access 2026-10-30; final source excerpts influence engine preservation, scheduling precedent and assertion preservation only. S4 Microsoft New-ScheduledTaskSettingsSet official published Windows Server 2025 documentation (https://learn.microsoft.com/en-us/powershell/module/scheduledtasks/new-scheduledtasksettingsset?view=windowsserver2025-ps), publication unspecified, supplied reported fetch 2026-10-30; influences explicit daily settings/limit. S5 Microsoft Get-ScheduledTaskInfo official published documentation (https://learn.microsoft.com/en-us/powershell/module/scheduledtasks/get-scheduledtaskinfo?view=windowsserver2025-ps), publication unspecified, same reported access date; influences separate last-run observation, never package correctness. Complete titles/publishers/URLs/dates/status/influence and native metadata pins appear in evidence/CHANGE-EVIDENCE.md and SOURCE-MANIFEST.json. Current local native rules, actual consumers and six engineering files were also inspected; root declarations never grant private access.

HYPOTHESIS — supported SID equivalence accommodates provider normalization without weakening account binding. Source-level and synthetic checks support feasibility; only real admitted triggered actions can establish actual Backup Scheduler behavior. The unchanged LinkType decision remains bounded metadata semantics. The preexisting installed 7.6.9 runtime is separately observed, not the native 7.6.8 test context and not an installation qualification.

UNVERIFIED — both independent final reviews and source/doc owner acceptance; exact owner-selected externally frozen digest/root Gate; full native sandbox Finish/receipt and actual triggered success/refusal/restore/readback before sandbox Review/Complete; separate original Gate/receipt, durable reviewed input inventory/runtime, representative complete actual backup and justified limit, real -Install, actual triggered success/refusal and restored reviewed input/daily definition before original Review/Complete; original native carrying-range/release. No mock durability seam qualifies -Install. Fixtures require unique owned explicit native authority and exact candidate/environment isolation; original evidence needs valid then-current receipts, never a future Complete receipt. If a mandatory criterion cannot safely be earned, BLOCK before owning Review/Complete, never waive or defer beyond completion.

UNVERIFIED residuals — stale/unreadable/missing status and console-only binding/preflight refusal; logged-out/missed-trigger/child timeout behavior; namespace aliases/unknown tags and check/use races; cloud hydration/replacement/crash durability; unencrypted report-only scanning excludes bundled history; concurrent copying is no coherent snapshot; shared launchers/second-resolution archive collision refusal; retained partial/pending/staging artifacts and Candidate C closed deletion investigation. No pruning, automatic deletion, production mutation, clean-machine proof or certification. D70 role substitution and D71 evidence retention are explicit WS027 exceptions, never a workflow redesign. Requested tool restrictions are advisory: spawn tools remain exposed but were never invoked, memories-off cannot be technically attested here, and no no-call record claims confinement.
