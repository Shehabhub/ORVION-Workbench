# Round trip for Backup-Workspace.ps1 / Restore-Workspace.ps1 on a synthetic workspace (temp GitHub root, bare remote):
# exact HEAD and refs, a DISABLED push URL kept, branch upstream single-valued, an ignored receipt byte-identical, stash
# loss warned, records-based memory, old-package compatibility, tampering and destination conflicts refused.
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
$ErrorActionPreference='Stop'
$zip=(Get-Command 7z -CommandType Application -ErrorAction SilentlyContinue|Select-Object -First 1).Source;if(!$zip){$zip=Join-Path $env:ProgramFiles '7-Zip\7z.exe'}
if(!(Test-Path -LiteralPath $zip)){throw 'BACKUP_RESTORE_SELFCHECK_7ZIP_REQUIRED: package self-checks require 7z'}
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-brcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))"
$savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
$savedGitInjection=@{}
foreach($key in [Environment]::GetEnvironmentVariables('Process').Keys|Where-Object{$_-match'^GIT_CONFIG_(COUNT|PARAMETERS|KEY_\d+|VALUE_\d+)$'}){
    $savedGitInjection[$key]=[Environment]::GetEnvironmentVariable($key,'Process')
    Remove-Item -LiteralPath ('Env:\'+$key)
}
$env:GIT_CONFIG_GLOBAL=Join-Path $t 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
$gh=Join-Path $t 'GitHub';$lib=Join-Path $gh 'ORVION-Owner-Tools\lib';New-Item -ItemType Directory $lib -Force|Out-Null
Copy-Item (Join-Path $PSScriptRoot 'Backup-Workspace.ps1'),(Join-Path $PSScriptRoot 'Restore-Workspace.ps1'),(Join-Path $PSScriptRoot 'workspace-layout.ps1') $lib
Copy-Item (Join-Path $PSScriptRoot 'Restore-ORVION.cmd'),(Join-Path $PSScriptRoot 'Restore-ORVION.ps1') $lib
$previousProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
[void][IO.Directory]::CreateDirectory((Join-Path $env:USERPROFILE '.codex'))
$configFixture=@'
[mcp_servers.postgres-local]
url = "postgresql://local_user:fake-local@127.0.0.1:5432/local"
[mcp_servers.postgres-founder]
url = "postgresql://founder_user:fake-founder@127.0.0.1:5433/founder"
[mcp_servers.example]
bearer_token_env_var = "EXAMPLE_TOKEN"
api_key = "fixture-inline-key"
password = "fixture-inline-password"
"access_token" = 'fixture-inline-token'
pat = "fixture-inline-pat"
secret = """fixture-multiline
continued-secret"""
api_token = "${TOKEN_FROM_ENV}"
url = "postgresql://env_user:${PGPASSWORD}@localhost/db"
headers = { api_key = "fixture-inline-header-first", password = "fixture-inline-header-second" }
keys = ["fixture-inline-array", "fixture-inline-array-tail"]
credentials = { token = { value = "fixture-inline-nested" } }
nested = [{ api_key = "fixture-inline-deep" }]
apiKey = "fixture-inline-camel"
path = "C:/fixture/keep-path"
executablePath = "C:/fixture/keep-exe"
keyboard_layout = "keep-keyboard"
patch_level = "keep-patch"
'@
[IO.File]::WriteAllText((Join-Path $env:USERPROFILE '.codex/config.toml'),$configFixture)
$savedTemporaryRoot=$env:WORKBENCH_TEMP_ROOT;$env:WORKBENCH_TEMP_ROOT=Join-Path $t 'managed'
$savedDataRoot=$env:ORVION_DATA_ROOT;$env:ORVION_DATA_ROOT=$null
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
function Invoke-Quiet{param([string]$Dir)$o=& git -C $Dir -c user.name=t -c user.email=t@t @args 2>&1;if($LASTEXITCODE){throw "git $args : $o"};$o}
function Read-BackupTree([string]$Path){(@(Get-ChildItem -LiteralPath $Path -Recurse -File -Force|ForEach-Object{[Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($_.FullName))})-join"`n")}
try{
    [void][IO.Directory]::CreateDirectory((Join-Path $gh 'ORVION-Owner-Tools/events'))
    # Backup rejects data-root repository metadata before any output is created (file and directory).
    foreach($kind in 'file','directory'){
        $dataGit=Join-Path $gh 'ORVION-Owner-Tools/.git'
        if($kind-eq'file'){[IO.File]::WriteAllText($dataGit,'gitdir: fixture')}else{[void][IO.Directory]::CreateDirectory($dataGit)}
        try{
            $refused=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t "data-git-$kind") -AllowUnencrypted 2>&1)
            Assert-That "backup data-root .git $kind refuses before packaging" ($LASTEXITCODE-ne0-and($refused-join' ')-match'BACKUP_DATA_ROOT_GIT_REFUSED'-and!(Test-Path (Join-Path $t "data-git-$kind")))
        }finally{if($kind-eq'file'){[IO.File]::Delete($dataGit)}else{[IO.Directory]::Delete($dataGit)}}
    }
    function Set-FixtureManifest([string]$PackageRoot){
        $lines=@(Get-ChildItem -LiteralPath $PackageRoot -Recurse -File -Force|Where-Object{$_.Name-ne'SHA256SUMS.txt'}|ForEach-Object{(Get-FileHash -LiteralPath $_.FullName).Hash+'  '+$_.FullName.Substring($PackageRoot.Length+1)})
        [IO.File]::WriteAllLines((Join-Path $PackageRoot 'SHA256SUMS.txt'),[string[]]$lines)
    }
    # An actual old-format package, not an opt-in to the removed legacy backup writer.
    $old=Join-Path $t 'old-package'
    foreach($dir in 'owner-tools','legacy/ORVION-old','claude/projects/key-old/memory'){[void][IO.Directory]::CreateDirectory((Join-Path $old $dir))}
    [IO.File]::WriteAllText((Join-Path $old 'backup.json'),' {"repos":[]}')
    [IO.File]::WriteAllText((Join-Path $old 'legacy/ORVION-old/evidence.txt'),'legacy bytes')
    [IO.File]::WriteAllText((Join-Path $old 'claude/projects/key-old/memory/note.md'),'old memory')
    Set-FixtureManifest $old
    function Test-OldRestore([string]$Label,[string]$ScriptFile="$lib/Restore-Workspace.ps1",[switch]$ExplicitLegacy){
        $target=Join-Path $t $Label;$client=$target+'-client';$legacy=$target+'-legacy'
        $arguments=@('-NoProfile','-File',$ScriptFile,'-From',$old,'-Target',$target,'-ClaudeHome',$client,'-CodexHome',($target+'-codex'))
        if($ExplicitLegacy){$arguments+=@('-LegacyTarget',$legacy)}
        $output=@(& pwsh @arguments 2>&1);$code=$LASTEXITCODE
        [pscustomobject]@{Exit=$code;Text=($output-join"`n");Target=$target;Client=$client;Legacy=$legacy}
    }
    $oldDefault=Test-OldRestore 'old-default'
    $link=Get-Item -LiteralPath ($oldDefault.Client+'/projects/key-old/memory') -Force
    Assert-That 'old memory migrates into records with a verified Junction' ($oldDefault.Exit-eq0-and$link.LinkType-ceq'Junction'-and@($link.Target)[0]-ieq($oldDefault.Target+'/ORVION-Owner-Tools/records/claude-memory/key-old').Replace('/','\')-and[IO.File]::ReadAllText(($oldDefault.Client+'/projects/key-old/memory/note.md'))-ceq'old memory')
    Assert-That 'old legacy defaults to one ACTION and creates no legacy destination' ($oldDefault.Exit-eq0-and@($oldDefault.Text-split"`n"|Where-Object{$_-match'^ACTION: old package legacy'}).Count-eq1-and!(Test-Path $oldDefault.Legacy))
    $oldExplicit=Test-OldRestore 'old-explicit' -ExplicitLegacy
    Assert-That 'explicit LegacyTarget restores old package legacy bytes' ($oldExplicit.Exit-eq0-and[IO.File]::ReadAllText(($oldExplicit.Legacy+'/ORVION-old/evidence.txt'))-ceq'legacy bytes')
    $correctTarget=Join-Path $t 'correct-link'
    $correctMemory=Join-Path $correctTarget 'ORVION-Owner-Tools/records/claude-memory/key-old'
    [void][IO.Directory]::CreateDirectory($correctMemory)
    $correctLink=$correctTarget+'-client/projects/key-old/memory'
    [void][IO.Directory]::CreateDirectory((Split-Path $correctLink -Parent))
    $null=New-Item -ItemType Junction -Path $correctLink -Target $correctMemory
    [IO.Directory]::Delete($correctTarget,$true)
    $correctResult=Test-OldRestore 'correct-link'
    Assert-That 'matching existing junction to the future records target is retained and verified' ($correctResult.Exit-eq0-and(Get-Item -LiteralPath $correctLink).LinkType-ceq'Junction'-and[IO.File]::ReadAllText((Join-Path $correctLink 'note.md'))-ceq'old memory')
    foreach($kind in 'directory','junction','dangling'){
        $target=Join-Path $t ('conflict-'+$kind);$memory=$target+'-client/projects/key-old/memory'
        [void][IO.Directory]::CreateDirectory((Split-Path $memory -Parent))
        if($kind-eq'directory'){[void][IO.Directory]::CreateDirectory($memory)}else{
            $linkTarget=Join-Path $t ('link-target-'+$kind);[void][IO.Directory]::CreateDirectory($linkTarget)
            $null=New-Item -ItemType Junction -Path $memory -Target $linkTarget
            if($kind-eq'dangling'){[IO.Directory]::Delete($linkTarget)}
        }
        $result=Test-OldRestore ('conflict-'+$kind)
        Assert-That "conflicting memory $kind refuses before persistent restore writes" ($result.Exit-ne0-and$result.Text-match'RESTORE_MEMORY_CONFLICT'-and!(Test-Path $result.Target))
    }
    foreach($kind in 'file','directory'){
        $dataGit=Join-Path $old 'owner-tools/.git'
        if($kind-eq'file'){[IO.File]::WriteAllText($dataGit,'gitdir: fixture')}else{[void][IO.Directory]::CreateDirectory($dataGit)}
        Set-FixtureManifest $old
        $result=Test-OldRestore ('packaged-git-'+$kind)
        Assert-That "packaged data-root .git $kind refuses before writes" ($result.Exit-ne0-and$result.Text-match'RESTORE_DATA_ROOT_GIT_REFUSED'-and!(Test-Path $result.Target))
        if($kind-eq'file'){
            $restoreBytes=[IO.File]::ReadAllText("$lib/Restore-Workspace.ps1")
            $anchor="throw 'RESTORE_DATA_ROOT_GIT_REFUSED'"
            if(!$restoreBytes.Contains($anchor)){throw 'MUTANT_STALE packaged git'}
            $mutant=Join-Path $lib 'mutant-restore.ps1';[IO.File]::WriteAllText($mutant,$restoreBytes.Replace($anchor,"Write-Output 'guard removed'"))
            $result=Test-OldRestore 'mutant-packaged-git' $mutant
            Assert-That 'MUTANT killed: packaged data-root .git accepted' ($result.Exit-eq0-and(Test-Path ($result.Target+'/ORVION-Owner-Tools/.git')))
        }
        if($kind-eq'file'){[IO.File]::Delete($dataGit)}else{[IO.Directory]::Delete($dataGit)}
    }
    Set-FixtureManifest $old
    $restoreBytes=[IO.File]::ReadAllText("$lib/Restore-Workspace.ps1")
    $anchor="if(!`$SkipLegacy-and`$PSBoundParameters.ContainsKey('LegacyTarget')-and`$LegacyTarget)"
    if(!$restoreBytes.Contains($anchor)){throw 'MUTANT_STALE legacy'}
    $mutated=$restoreBytes.Replace($anchor,"if(!`$SkipLegacy)").Replace('[string]$LegacyTarget,',"[string]`$LegacyTarget=(Join-Path `$env:USERPROFILE 'Documents'),")
    [IO.File]::WriteAllText($mutant,$mutated)
    $result=Test-OldRestore 'mutant-legacy' $mutant
    if($result.Exit){$result.Text}
    Assert-That 'MUTANT killed: implicit legacy destination recreated' ($result.Exit-eq0-and(Test-Path (Join-Path $env:USERPROFILE 'Documents/ORVION-old/evidence.txt'))-and$result.Text-notmatch'^ACTION: old package legacy')
    $gitProbe=@(& git -c ws019.fixture=isolated config --get ws019.fixture 2>&1);$gitProbeCode=$LASTEXITCODE
    $remainingInjection=@([Environment]::GetEnvironmentVariables('Process').Keys|Where-Object{$_-match'^GIT_CONFIG_(COUNT|PARAMETERS|KEY_\d+|VALUE_\d+)$'})
    Assert-That 'backup self-check clears inherited Git configuration injection' ($gitProbeCode-eq0-and($gitProbe-join' ')-ceq'isolated'-and!$remainingInjection.Count)
    $probeLib=Join-Path $gh 'probe-checkout\lib';[void][IO.Directory]::CreateDirectory($probeLib)
    Copy-Item (Join-Path $PSScriptRoot 'Backup-Workspace.ps1'),(Join-Path $PSScriptRoot 'workspace-layout.ps1') $probeLib
    $override=Join-Path $t 'override store';[void][IO.Directory]::CreateDirectory((Join-Path $override 'events'))
    [void][IO.Directory]::CreateDirectory((Join-Path $gh 'ORVION-Owner-Tools\events'))
    [IO.File]::WriteAllText((Join-Path $override 'events\marker.txt'),'override fixture')
    [IO.File]::WriteAllText((Join-Path $gh 'ORVION-Owner-Tools\events\marker.txt'),'sibling fixture')
    # Only the script layout is needed here; remove it before later Workbench-presence checks.
    $env:ORVION_DATA_ROOT=$override+'\'
    try{$probe=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination (Join-Path $t 'override-backup') -AllowUnencrypted -SkipLegacy 2>&1);$probeCode=$LASTEXITCODE}
    finally{$env:ORVION_DATA_ROOT=$null}
    $folder=@(Get-ChildItem (Join-Path $t 'override-backup') -Directory)[0].FullName
    $marker=Join-Path $folder 'owner-tools\events\marker.txt'
    Assert-That 'Backup ORVION_DATA_ROOT selects override bytes and their manifest hash instead of sibling store' ($probeCode-eq0-and(Test-Path $marker)-and[IO.File]::ReadAllText($marker)-ceq'override fixture'-and[IO.File]::ReadAllText((Join-Path $folder 'SHA256SUMS.txt')).Contains((Get-FileHash $marker).Hash+'  owner-tools\events\marker.txt'))
    . (Join-Path $PSScriptRoot 'remove-owned.ps1')
    $null=Remove-OrvionOwnedTree (Split-Path $probeLib -Parent) @($t)
    [IO.File]::Delete((Join-Path $gh 'ORVION-Owner-Tools\events\marker.txt'))
    if($RootProbeOnly){if($fail){throw 'BACKUP_ROOT_PROBE_FAILED'};'BACKUP_ROOT_PROBE PASS';return}
    $remote=Join-Path $t 'remote.git';& git init -q --bare -b main $remote
    $crm=Join-Path $gh 'CRM';& git clone -q $remote $crm 2>&1|Out-Null
    Set-Content "$crm\.gitignore" '.orvion-local-certification.json';Set-Content "$crm\a.txt" 'one';Invoke-Quiet $crm add -A|Out-Null;Invoke-Quiet $crm commit -q -m one|Out-Null
    Invoke-Quiet $crm push -q -u origin main|Out-Null;Invoke-Quiet $crm remote set-url --push origin DISABLED|Out-Null
    Invoke-Quiet $crm branch orvion/x-pending|Out-Null
    Invoke-Quiet $crm config credential.https://github.com.helper '!gh auth token'|Out-Null
    Set-Content "$crm\.orvion-local-certification.json" '{"receipt":"exact"}'
    foreach($i in 1,2){Set-Content "$crm\a.txt" "stash $i";Invoke-Quiet $crm stash -q|Out-Null}
    $legacy=Join-Path $t 'ORVION-drafts-backup';New-Item -ItemType Directory $legacy|Out-Null;& git init -q $legacy;Set-Content "$legacy\draft.md" 'kept'
    $out=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination (Join-Path $t 'usb') -AllowUnencrypted 2>&1)
    if($LASTEXITCODE-ne0){throw ('BACKUP_FIXTURE_FAILED: '+($out-join' '))}
    Assert-That 'missing optional Claude root is not created' (!(Test-Path (Join-Path $env:USERPROFILE '.claude')))
    Assert-That 'backup warns that older stashes do not survive' (($out-join' ')-match'2 stash\(es\)')
    $bk=@(Get-ChildItem (Join-Path $t 'usb') -Directory)[0].FullName
    $maskedFile=Join-Path $bk 'codex/config.toml';$masked=[IO.File]::ReadAllText($maskedFile)
    Assert-That 'Codex URL passwords masked before manifest hashing; usernames and env names intact' ($masked.Replace('env_user:${PGPASSWORD}@','env_user:***@')-notmatch'://[^:/@\s]+:(?!\*\*\*@)[^@\s]*@'-and$masked.Contains('://local_user:***@127.0.0.1')-and$masked.Contains('://founder_user:***@127.0.0.1')-and$masked.Contains('EXAMPLE_TOKEN')-and[IO.File]::ReadAllText("$bk\SHA256SUMS.txt").Contains((Get-FileHash $maskedFile).Hash+'  codex\config.toml'))
    Assert-That 'backup records source profile without making Codex a recovery input' ((Get-Content "$bk\backup.json" -Raw|ConvertFrom-Json).sourceUserProfile-ceq$env:USERPROFILE-and!(Test-Path "$bk\recovery-inputs"))
    Assert-That 'new backup omits legacy folders and separate client memory' (!(Test-Path "$bk/legacy")-and!(Test-Path "$bk/claude/projects"))
    Assert-That 'inline Codex credentials including multiline and inline-table values masked; env references kept' ($masked-notmatch'fixture-inline|fixture-multiline|continued-secret'-and$masked.Contains('${TOKEN_FROM_ENV}')-and$masked.Contains('env_user:${PGPASSWORD}@localhost'))
    Assert-That 'non-credential keys containing pat/key (path, executablePath, keyboard_layout, patch_level) keep their values' ((@('keep-path','keep-exe','keep-keyboard','keep-patch')|Where-Object{!$masked.Contains($_)}).Count-eq0)
    # Keep a legacy-shaped file in this synthetic package to exercise manifest completeness below.
    [void][IO.Directory]::CreateDirectory("$bk/legacy/old");[IO.File]::WriteAllText("$bk/legacy/old/draft.md",'old bytes')
    Add-Content "$bk/SHA256SUMS.txt" ((Get-FileHash "$bk/legacy/old/draft.md").Hash+'  legacy/old/draft.md')
    $res=Join-Path $t 'restored'
    $codexHome=Join-Path $t 'restored-codex'
    $r=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target $res -ClaudeHome (Join-Path $t 'ch') -LegacyTarget (Join-Path $t 'docs2') -CodexHome $codexHome)
    if($LASTEXITCODE-ne0){throw ('RESTORE_FIXTURE_FAILED: '+($r-join' '))}
    Assert-That 'absent Codex config copied byte-identically; NEXT explains masked passwords' ((Get-FileHash "$codexHome\config.toml").Hash-ceq(Get-FileHash $maskedFile).Hash-and($r-join' ')-match'NEXT: .*masked local postgres passwords')
    [IO.File]::WriteAllText("$codexHome\config.toml",'owner configuration')
    foreach($round in 1,2){
        $configRestore=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target (Join-Path $t "config-target-$round") -ClaudeHome (Join-Path $t "config-claude-$round") -LegacyTarget (Join-Path $t "config-docs-$round") -CodexHome $codexHome 2>&1)
        Assert-That "existing Codex config untouched, restored copy written once (round $round)" ($LASTEXITCODE-eq0-and[IO.File]::ReadAllText("$codexHome\config.toml")-ceq'owner configuration'-and$(if($round-eq1){(Get-FileHash "$codexHome\config.toml.restored").Hash-ceq(Get-FileHash $maskedFile).Hash}else{[IO.File]::ReadAllText("$codexHome\config.toml.restored")-ceq'preserve earlier recovery'}))
        [IO.File]::WriteAllText("$codexHome\config.toml.restored",'preserve earlier recovery')
    }
    $rc="$res\CRM"
    Assert-That 'restored at the exact HEAD with identical refs' (($r-join' ')-match'RESTORED CRM main@'-and(& git -C $rc rev-parse HEAD)-eq(& git -C $crm rev-parse HEAD))
    Assert-That 'the DISABLED push URL is kept' ((& git -C $rc config --get remote.origin.pushurl)-eq'DISABLED')
    $up=& git -C $rc config --local --get-all branch.main.remote
    Assert-That 'the branch upstream is single-valued' (@($up).Count-eq1-and$up-eq'origin')
    Assert-That 'the ignored receipt is byte-identical' ((Get-FileHash "$rc\.orvion-local-certification.json").Hash-eq(Get-FileHash "$crm\.orvion-local-certification.json").Hash)
    Assert-That 'restore warns about the stash' (($r-join' ')-match'WARN CRM: 2 stash')
    $helperKept=(& git -C $rc config --get credential.https://github.com.helper)-ceq'!gh auth token'
    $fake='ghp_'+'FAKE'+('x'*36)
    $shellHelper='!f() { echo username=fixture-login; echo "password=$(gh auth token --user fixture-login)"; }; f'
    $unsafeCases=@(
        @('header','http.https://github.com/.extraheader',"AUTHORIZATION: $fake",$fake),
        @('cookiefile','http.https://github.com/.cookiefile','fixture-cookie-path','fixture-cookie-path'),
        @('helper','credential.helper',"!echo $fake",$fake),
        @('shell-literal-token','credential.helper',$shellHelper.Replace('$(gh auth token --user fixture-login)',$fake),$fake),
        @('contains-gh-probe','credential.helper','!echo gh auth token; echo UNAPPROVED_FIXTURE_SECRET','UNAPPROVED_FIXTURE_SECRET'),
        @('username-token-probe','credential.https://github.com.username',$fake,$fake),
        @('mismatched-login','credential.helper',$shellHelper.Replace('--user fixture-login','--user different-login'),'different-login'),
        @('echo-password','credential.helper','echo password=hunter2','hunter2'),
        @('gh-literal-token','credential.helper',($shellHelper+'; echo '+$fake),$fake),
        @('gh-pat-prefix','credential.helper',($shellHelper+'; echo github_pat_fixture'),'github_pat_fixture'),
        @('gh-literal-password','credential.helper','!f() { echo "password=hunter2"; gh auth token; }; f','hunter2'))
    foreach($case in $unsafeCases){
        Invoke-Quiet $crm config $case[1] $case[2]|Out-Null
        $destination=Join-Path $t ('unsafe-'+$case[0])
        try{$unsafe=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination $destination -AllowUnencrypted 2>&1);$code=$LASTEXITCODE}
        finally{if($case[1]-eq'remote.origin.url'){Invoke-Quiet $crm config $case[1] $remote|Out-Null}else{Invoke-Quiet $crm config --unset-all $case[1]|Out-Null}}
        $copies=Read-BackupTree $destination
        Assert-That ('product config refuses '+$case[0]+' by key without saving its value; external helper survives') ($helperKept-and$code-ne0-and($unsafe-join' ')-match'BACKUP_UNSAFE_CONFIG'-and($unsafe-join' ').Contains($case[1])-and!($unsafe-join' ').Contains($case[3])-and!$copies.Contains($case[3])-and($unsafe-join' ')-notmatch'BACKUP:')
    }
    # The real helper chain resets first, then asks gh at restore-time; never execute the helper here.
    $helperKey='credential.https://github.com.helper'
    Invoke-Quiet $crm config --unset-all $helperKey|Out-Null
    Invoke-Quiet $crm config --add $helperKey ''|Out-Null;Invoke-Quiet $crm config --add $helperKey $shellHelper|Out-Null
    $helperDestination=Join-Path $t 'helper-chain'
    $helperBackup=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination $helperDestination -AllowUnencrypted 2>&1);$helperCode=$LASTEXITCODE
    $restoredHelpers=@();$helperRestoreCode=-1
    if($helperCode-eq0){
        $helperFolder=@(Get-ChildItem $helperDestination -Directory)[0].FullName;$helperTarget=Join-Path $t 'restored-helpers'
        $helperRestore=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $helperFolder -Target $helperTarget -ClaudeHome (Join-Path $t 'helper-ch') -LegacyTarget (Join-Path $t 'helper-docs') 2>&1);$helperRestoreCode=$LASTEXITCODE
        if($helperRestoreCode-eq0){$restoredHelpers=@(& git -C "$helperTarget\CRM" config --local --get-all $helperKey)}
    }
    Assert-That 'empty reset and exact gh shell-function helper survive backup and restore in order' ($helperCode-eq0-and$helperRestoreCode-eq0-and$restoredHelpers.Count-eq2-and$restoredHelpers[0]-ceq''-and$restoredHelpers[1]-ceq$shellHelper)
    Invoke-Quiet $crm config --unset-all $helperKey|Out-Null;Invoke-Quiet $crm config $helperKey '!gh auth token'|Out-Null
    # Force every clone/init key to be present, independent of Git/platform defaults.
    $cloneMetadata=[ordered]@{'core.repositoryformatversion'='0';'core.filemode'='false';'core.bare'='false';'core.logallrefupdates'='true';'core.symlinks'='false';'core.ignorecase'='true';'remote.origin.fetch'='+refs/heads/*:refs/remotes/origin/*'}
    foreach($metadataKey in $cloneMetadata.Keys){Invoke-Quiet $crm config $metadataKey $cloneMetadata[$metadataKey]|Out-Null}
    foreach($case in @(@('username','someone'),@('token',$fake),@('password',"fixture-user:$fake"))){
        $origin="https://$($case[1])@github.com/o/r.git";$cleanOrigin='https://github.com/o/r.git'
        $urlKey="credential.https://$($case[1])@github.com.username";$cleanUrlKey='credential.https://github.com.username'
        Invoke-Quiet $crm config remote.origin.url $origin|Out-Null;Invoke-Quiet $crm config $urlKey 'fixture-account'|Out-Null
        Invoke-Quiet $legacy config remote.origin.url $origin|Out-Null
        $destination=Join-Path $t ('userinfo-'+$case[0]);$target=Join-Path $t ('restored-userinfo-'+$case[0])
        try{
            $stripped=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination $destination -AllowUnencrypted 2>&1);$code=$LASTEXITCODE
            $originKept=$false;$urlKeyKept=$false;$nestedOriginKept=$false;$configLines=@()
            if($code-eq0){
                $folder=@(Get-ChildItem $destination -Directory)[0].FullName
                $configLines=[IO.File]::ReadAllLines("$folder\repos\CRM\git-config-local.txt")
                $nestedOriginKept=!(Test-Path "$folder/legacy")
                $userRestore=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $folder -Target $target -ClaudeHome ($target+'-ch') -LegacyTarget ($target+'-docs') 2>&1)
                if($LASTEXITCODE-eq0){
                    $originKept=(& git -C "$target\CRM" config --get remote.origin.url)-ceq$cleanOrigin
                    $urlKeyKept=(& git -C "$target\CRM" config --get $cleanUrlKey)-ceq'fixture-account'
                }
            }
            $tree=Read-BackupTree $destination;$messages=$stripped-join"`n"
            Assert-That ('userinfo '+$case[0]+' stripped from origin, backup.json and state.json; every backup file searched') ($code-eq0-and$originKept-and$nestedOriginKept-and$configLines-ccontains"remote.origin.url=$cleanOrigin"-and$messages.Contains('BACKUP_CONFIG_USERINFO_STRIPPED: remote.origin.url')-and!$messages.Contains($case[1])-and!$tree.Contains($case[1])-and!$tree.Contains($fake))
            Assert-That ('userinfo '+$case[0]+' stripped from URL-shaped key and restored with key-only warning') ($code-eq0-and$urlKeyKept-and$configLines-ccontains"$cleanUrlKey=fixture-account"-and$messages.Contains("BACKUP_CONFIG_USERINFO_STRIPPED: $cleanUrlKey")-and!$messages.Contains($case[1])-and!$tree.Contains($case[1]))
            if($case[0]-eq'username'){foreach($metadataKey in $cloneMetadata.Keys){
                Assert-That ("clone metadata silently omitted: $metadataKey") ($code-eq0-and!$messages.Contains("BACKUP_CONFIG_OMITTED: $metadataKey")-and@($configLines|Where-Object{($_-split'=',2)[0]-eq$metadataKey}).Count-eq0)
            }}
        }finally{
            Invoke-Quiet $crm config remote.origin.url $remote|Out-Null;Invoke-Quiet $crm config --unset-all $urlKey|Out-Null
            Invoke-Quiet $legacy config --unset-all remote.origin.url|Out-Null
        }
    }
    $manifestFile=Join-Path $bk 'SHA256SUMS.txt';$manifest=[IO.File]::ReadAllText($manifestFile)
    foreach($case in 'empty','plan','config','data','absolute','parent'){
        $changed=switch($case){
            empty {''}
            plan {(@($manifest-split'\r?\n'|Where-Object{$_-and$_-notmatch'  backup\.json$'})-join"`n")+"`n"}
            config {(@($manifest-split'\r?\n'|Where-Object{$_-and$_-notmatch'git-config-local\.txt$'})-join"`n")+"`n"}
            data {(@($manifest-split'\r?\n'|Where-Object{$_-and$_-notmatch'draft\.md$'})-join"`n")+"`n"}
            absolute {$manifest+((Get-FileHash "$bk\backup.json").Hash)+"  $bk\backup.json`n"}
            parent {$manifest+((Get-FileHash "$bk\backup.json").Hash)+"  ..\$([IO.Path]::GetFileName($bk))\backup.json`n"}
        }
        [IO.File]::WriteAllText($manifestFile,$changed);$destination=Join-Path $t ('manifest-'+$case)
        $refused=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target $destination -ClaudeHome ($destination+'-ch') -LegacyTarget ($destination+'-docs') 2>&1);$code=$LASTEXITCODE
        Assert-That ('manifest '+$case+' refuses before restore writes') ($code-ne0-and($refused-join' ')-match'BACKUP_MANIFEST_(INCOMPLETE|INVALID)'-and!(Test-Path $destination)-and!(Test-Path ($destination+'-ch'))-and!(Test-Path ($destination+'-docs')))
    }
    [IO.File]::WriteAllText($manifestFile,$manifest)
    $again=try{& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target $res -ClaudeHome (Join-Path $t 'ch') 2>&1|Out-String}catch{"$_"}
    Assert-That 'an existing target is refused' ($again-match'RESTORE_TARGET_EXISTS')
    $projects=Join-Path $gh 'ORVION-Owner-Tools/records/claude-memory'
    [void][IO.Directory]::CreateDirectory((Join-Path $projects 'Documents-GitHub-empty'))
    [void][IO.Directory]::CreateDirectory((Join-Path $projects 'Documents-GitHub-third'))
    $memory=Join-Path $projects 'Documents-GitHub-valid';[void][IO.Directory]::CreateDirectory($memory)
    $note=Join-Path $memory 'fixture.md';[IO.File]::WriteAllText($note,'fixture memory bytes')
    $withMemory=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination (Join-Path $t 'usb-memory') -AllowUnencrypted 2>&1)
    Assert-That 'present valid and empty or missing project memory backup succeeds' ($LASTEXITCODE-eq0-and($withMemory-join' ')-match'BACKUP:')
    $memoryBackup=@(Get-ChildItem (Join-Path $t 'usb-memory') -Directory)[0].FullName
    $memoryRestore=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $memoryBackup -Target (Join-Path $t 'restored-memory') -ClaudeHome (Join-Path $t 'ch-memory') -LegacyTarget (Join-Path $t 'docs-memory') 2>&1)
    Assert-That 'records restore preserves memory bytes via junction' ($LASTEXITCODE-eq0-and[IO.File]::ReadAllText((Join-Path $t 'ch-memory/projects/Documents-GitHub-valid/memory/fixture.md'))-ceq'fixture memory bytes')
    $newTarget=Join-Path $t 'restored-memory'
    foreach($key in 'Documents-GitHub-empty','Documents-GitHub-valid','Documents-GitHub-third'){
        $link=Get-Item -LiteralPath (Join-Path $t "ch-memory/projects/$key/memory") -Force
        Assert-That "new records memory $key is a junction to owner records" ($link.LinkType-ceq'Junction'-and@($link.Target)[0]-ieq(Join-Path $newTarget "ORVION-Owner-Tools/records/claude-memory/$key"))
    }
    Assert-That 'separate Claude projects memory is never packaged' (!(Test-Path "$memoryBackup/claude/projects"))
    foreach($case in @(@('required-receipt',"$crm\.orvion-local-certification.json"),@('present-memory',$note))){
        $handle=[IO.File]::Open($case[1],'Open','ReadWrite','None');$destination=Join-Path $t ('usb-locked-'+$case[0])
        try{$locked=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination $destination -AllowUnencrypted 2>&1);$code=$LASTEXITCODE}finally{$handle.Dispose()}
        Assert-That ($case[0]+' unreadable is fatal without a success manifest') ($code-ne0-and($locked-join' ')-notmatch'BACKUP:'-and@(Get-ChildItem $destination -Recurse -Filter SHA256SUMS.txt).Count-eq0)
    }
    $saved=[IO.File]::ReadAllBytes("$bk\repos\CRM\refs.txt");[IO.File]::Delete("$bk\repos\CRM\refs.txt")
    $incomplete=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target (Join-Path $t 'restored-incomplete') -ClaudeHome (Join-Path $t 'ch-incomplete') 2>&1)
    Assert-That 'incomplete artifact is fatal before creating a restore target' ($LASTEXITCODE-ne0-and($incomplete-join' ')-match'BACKUP_CORRUPT'-and!(Test-Path (Join-Path $t 'restored-incomplete')))
    [IO.File]::WriteAllBytes("$bk\repos\CRM\refs.txt",$saved)
    Add-Content "$bk\repos\CRM\refs.txt" 'tampered'
    $bad=try{& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target (Join-Path $t 'restored2') -ClaudeHome (Join-Path $t 'ch2') 2>&1|Out-String}catch{"$_"}
    Assert-That 'a tampered backup is refused' ($bad-match'BACKUP_CORRUPT')
    [IO.File]::Delete("$bk\SHA256SUMS.txt")
    $missingManifest=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target (Join-Path $t 'restored-no-manifest') -ClaudeHome (Join-Path $t 'ch-no-manifest') 2>&1)
    Assert-That 'missing manifest is fatal before creating a restore target' ($LASTEXITCODE-ne0-and!(Test-Path (Join-Path $t 'restored-no-manifest')))
    # Workbench recovery coverage v1: independent source/trusted, exact historical receipts and declared proof bytes.
    # Selective package v1: a present Workbench requires the one journal and sessions archive under GitHub\ORVION-Owner-Tools.
    $journal=Join-Path $gh 'ORVION-Owner-Tools\events\events.jsonl';[void][IO.Directory]::CreateDirectory((Split-Path $journal -Parent));[IO.File]::WriteAllText($journal,"{`"fixture`":`"journal`"}`n")
    $session=Join-Path $gh 'ORVION-Owner-Tools\sessions\raw\s.jsonl';[void][IO.Directory]::CreateDirectory((Split-Path $session -Parent));[IO.File]::WriteAllText($session,'fixture session')
    $wb=Join-Path $gh 'ORVION-Workbench';$trusted=Join-Path $gh 'ORVION-Workbench-trusted-main'
    foreach($repo in $wb,$trusted){
        & git clone -q $remote $repo 2>&1|Out-Null;if($LASTEXITCODE){throw 'WB_FIXTURE_CLONE_FAILED'}
        Invoke-Quiet $repo remote set-url origin https://github.com/fixture/workbench.git|Out-Null
        Invoke-Quiet $repo remote set-url --push origin DISABLED|Out-Null
        Invoke-Quiet $repo config core.hooksPath .githooks|Out-Null
        Invoke-Quiet $repo config push.default nothing|Out-Null
        Invoke-Quiet $repo config protocol.allow never|Out-Null
    }
    Invoke-Quiet $trusted checkout -q --detach HEAD|Out-Null
    $wbIgnore=Join-Path $wb '.gitignore';Add-Content $wbIgnore ".workbench-local-certification.json`n.workbench-certifications/"
    Invoke-Quiet $wb add .gitignore|Out-Null;Invoke-Quiet $wb commit -q -m 'fixture ignored receipts'|Out-Null
    $digest='A'*64;$receipt=Join-Path $wb '.workbench-local-certification.json'
    [void][IO.Directory]::CreateDirectory((Join-Path $wb '.workbench-certifications'))
    @{schema=2;root=$wb;result='READY';digest=$digest}|ConvertTo-Json|Set-Content $receipt
    $archive=Join-Path $wb ".workbench-certifications/$digest.json";Copy-Item $receipt $archive
    $proof=Join-Path $t 'external-proof.json';[IO.File]::WriteAllText($proof,'{"fixture":"required private proof reference"}')
    $inputs=Join-Path $t 'recovery-inputs.json'
    @{schema=1;inputs=@(@{name='required-proof';path=$proof;sha256=(Get-FileHash $proof).Hash})}|ConvertTo-Json -Depth 4|Set-Content $inputs
    # Permanent structural regressions: every malformed shape must fail before a success manifest.
    $validInputs=[IO.File]::ReadAllText($inputs)
    $shapes=[ordered]@{absent='{"schema":1}';null='{"schema":1,"inputs":null}';empty='{"schema":1,"inputs":[]}';scalar='{"schema":1,"inputs":"proof"}';object='{"schema":1,"inputs":{}}';nullEntry='{"schema":1,"inputs":[null]}';scalarEntry='{"schema":1,"inputs":["proof"]}';objectEntry='{"schema":1,"inputs":[{}]}';schemaString='{"schema":"1","inputs":[{}]}'}
    foreach($case in $shapes.GetEnumerator()){
        [IO.File]::WriteAllText($inputs,$case.Value)
        $destination=Join-Path $t ('wb-map-'+$case.Key)
        $badMap=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination $destination -RecoveryInputs $inputs -AllowUnencrypted 2>&1);$exitCode=$LASTEXITCODE
        Assert-That ('malformed backup proof map '+$case.Key+' fails closed') ($exitCode-ne0-and($badMap-join' ')-match'BACKUP_RECOVERY_INPUTS_INVALID'-and($badMap-join' ')-notmatch'BACKUP:'-and@(Get-ChildItem $destination -Recurse -Filter SHA256SUMS.txt).Count-eq0)
    }
    [IO.File]::WriteAllText($inputs,$validInputs)
    $missing=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t 'wb-no-inputs') -AllowUnencrypted 2>&1)
    Assert-That 'Workbench present requires explicit approved recovery input map' ($LASTEXITCODE-ne0-and($missing-join' ')-match'BACKUP_RECOVERY_INPUTS_REQUIRED')
    $receiptBytes=[IO.File]::ReadAllBytes($receipt);[IO.File]::Delete($receipt)
    $missingReceipt=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t 'wb-no-receipt') -RecoveryInputs $inputs -AllowUnencrypted 2>&1)
    Assert-That 'required missing Workbench receipt blocks backup manifest' ($LASTEXITCODE-ne0-and($missingReceipt-join' ')-match'BACKUP_WORKBENCH_RECEIPTS_REQUIRED'-and@(Get-ChildItem (Join-Path $t 'wb-no-receipt') -Recurse -Filter SHA256SUMS.txt).Count-eq0)
    [IO.File]::WriteAllBytes($receipt,$receiptBytes)
    [IO.File]::WriteAllText($receipt,'not valid json')
    $invalidReceipt=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t 'wb-invalid-receipt') -RecoveryInputs $inputs -AllowUnencrypted 2>&1)
    Assert-That 'corrupt required receipt is fatal without success manifest' ($LASTEXITCODE-ne0-and($invalidReceipt-join' ')-notmatch'BACKUP:'-and@(Get-ChildItem (Join-Path $t 'wb-invalid-receipt') -Recurse -Filter SHA256SUMS.txt).Count-eq0)
    [IO.File]::WriteAllBytes($receipt,$receiptBytes)
    foreach($file in $receipt,$proof){
        $lock=[IO.File]::Open($file,'Open','ReadWrite','None')
        try{$locked=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t ('wb-lock-'+[IO.Path]::GetFileName($file))) -RecoveryInputs $inputs -AllowUnencrypted 2>&1);$code=$LASTEXITCODE}finally{$lock.Dispose()}
        Assert-That ('required unreadable Workbench input refuses '+[IO.Path]::GetFileName($file)) ($code-ne0-and($locked-join' ')-notmatch'BACKUP:')
    }
    $originalProof=[IO.File]::ReadAllBytes($proof);[IO.File]::WriteAllText($proof,'changed')
    $changed=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t 'wb-changed') -RecoveryInputs $inputs -AllowUnencrypted 2>&1)
    Assert-That 'changed required proof hash refuses before manifest' ($LASTEXITCODE-ne0-and($changed-join' ')-match'BACKUP_RECOVERY_INPUT_REQUIRED_OR_CHANGED')
    [IO.File]::WriteAllBytes($proof,$originalProof)
    Invoke-Quiet $wb config http.https://github.com/.extraheader 'fixture-redacted-header'|Out-Null
    $unsafe=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t 'wb-unsafe') -RecoveryInputs $inputs -AllowUnencrypted 2>&1)
    Assert-That 'auth-header config is refused without success' ($LASTEXITCODE-ne0-and($unsafe-join' ')-match'BACKUP_UNSAFE_CONFIG'-and($unsafe-join' ')-notmatch'BACKUP:')
    Invoke-Quiet $wb config --unset-all http.https://github.com/.extraheader|Out-Null
    $back=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t 'wb-usb') -RecoveryInputs $inputs -AllowUnencrypted 2>&1)
    if($LASTEXITCODE){throw ('WB_BACKUP_FIXTURE_FAILED: '+($back-join' '))}
    $wbb=@(Get-ChildItem (Join-Path $t 'wb-usb') -Directory)[0].FullName
    # Restore negatives use internally consistent checksum manifests, isolating semantic validation.
    $planFile=Join-Path $wbb 'backup.json';$manifestFile=Join-Path $wbb 'SHA256SUMS.txt'
    $validPlan=[IO.File]::ReadAllText($planFile);$validManifest=[IO.File]::ReadAllText($manifestFile)
    foreach($field in 'inputs','receiptFiles'){
        foreach($shape in 'absent','null','empty','scalar','object','nullEntry','scalarEntry','objectEntry'){
            $planFixture=$validPlan|ConvertFrom-Json
            switch($shape){
                absent {$planFixture.workbenchRecovery.psobject.Properties.Remove($field)}
                null {$planFixture.workbenchRecovery.$field=$null}
                empty {$planFixture.workbenchRecovery.$field=@()}
                scalar {$planFixture.workbenchRecovery.$field='fixture'}
                object {$planFixture.workbenchRecovery.$field=[pscustomobject]@{}}
                nullEntry {$planFixture.workbenchRecovery.$field=@($null)}
                scalarEntry {$planFixture.workbenchRecovery.$field=@(17)}
                objectEntry {$planFixture.workbenchRecovery.$field=@([pscustomobject]@{})}
            }
            $planFixture|ConvertTo-Json -Depth 8|Set-Content $planFile
            $newHash=(Get-FileHash $planFile).Hash
            [IO.File]::WriteAllText($manifestFile,([regex]::Replace($validManifest,'(?m)^[A-F0-9]{64}(  backup\.json\r?$)',{param($m)$newHash+$m.Groups[1].Value})))
            $destination=Join-Path $t ('wb-restore-map-'+$field+'-'+$shape)
            $badMap=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target $destination -ClaudeHome ($destination+'-claude') -LegacyTarget ($destination+'-legacy') 2>&1);$exitCode=$LASTEXITCODE
            $cause=if($shape-in'absent','null','empty','scalar','object'){'RESTORE_WORKBENCH_COVERAGE_REQUIRED'}else{'RESTORE_WORKBENCH_INPUT_INVALID'}
            Assert-That ('malformed restore '+$field+' '+$shape+' refuses before writes') ($exitCode-ne0-and($badMap-join' ')-match$cause-and($badMap-join' ')-notmatch'BACKUP_CORRUPT|RESTORED '-and!(Test-Path $destination)-and!(Test-Path ($destination+'-claude'))-and!(Test-Path ($destination+'-legacy')))
        }
    }
    [IO.File]::WriteAllText($planFile,$validPlan);[IO.File]::WriteAllText($manifestFile,$validManifest)
    $wbTarget=Join-Path $t 'wb-restored'
    $restored=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target $wbTarget -ClaudeHome (Join-Path $t 'wb-ch') -LegacyTarget (Join-Path $t 'wb-docs') 2>&1)
    if($LASTEXITCODE){throw ('WB_RESTORE_FIXTURE_FAILED: '+($restored-join' '))}
    Assert-That 'source and independent detached trusted HEAD round trip exactly' ((& git -C "$wbTarget/ORVION-Workbench" rev-parse HEAD)-ceq(& git -C $wb rev-parse HEAD)-and(& git -C "$wbTarget/ORVION-Workbench-trusted-main" rev-parse HEAD)-ceq(& git -C $trusted rev-parse HEAD)-and(& git -C "$wbTarget/ORVION-Workbench-trusted-main" rev-parse --abbrev-ref HEAD)-ceq'HEAD')
    Assert-That 'Workbench certification bytes retained without rewriting physical root' ((Get-FileHash "$wbTarget/ORVION-Workbench/.workbench-local-certification.json").Hash-ceq(Get-FileHash $receipt).Hash-and(Get-FileHash "$wbTarget/ORVION-Workbench/.workbench-certifications/$digest.json").Hash-ceq(Get-FileHash $archive).Hash)
    Assert-That 'trusted recovery remains push disabled and protocol denied' ((& git -C "$wbTarget/ORVION-Workbench-trusted-main" config --get remote.origin.pushurl)-ceq'DISABLED'-and(& git -C "$wbTarget/ORVION-Workbench-trusted-main" config --get protocol.allow)-ceq'never'-and(& git -C "$wbTarget/ORVION-Workbench-trusted-main" config --get push.default)-ceq'nothing')
    Assert-That 'declared external proof bytes and original reference map retained' ((Get-FileHash "$wbTarget/ORVION-Owner-Tools/records/recovery-inputs/required-proof").Hash-ceq(Get-FileHash $proof).Hash-and(Test-Path "$wbTarget/ORVION-Owner-Tools/records/recovery-inputs/source-map.json"))
    Assert-That 'recovery inputs never recreate the old GitHub sibling' (!(Test-Path "$wbTarget/ORVION-Recovery-Inputs"))
    $recordsInputs=Join-Path $wbb 'owner-tools/records/recovery-inputs'
    [void][IO.Directory]::CreateDirectory($recordsInputs)
    Copy-Item -LiteralPath $proof -Destination (Join-Path $recordsInputs 'required-proof')
    [IO.File]::WriteAllText((Join-Path $recordsInputs 'source-map.json'),'old source map')
    Set-FixtureManifest $wbb
    $repeatTarget=Join-Path $t 'repeat-records'
    $repeated=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target $repeatTarget -ClaudeHome ($repeatTarget+'-ch') -CodexHome ($repeatTarget+'-cx') 2>&1)
    Assert-That 'already-recorded recovery inputs merge identical bytes and preserve prior source map' ($LASTEXITCODE-eq0-and[IO.File]::ReadAllText("$repeatTarget/ORVION-Owner-Tools/records/recovery-inputs/source-map.json")-ceq'old source map'-and(Test-Path (Join-Path $repeatTarget ('ORVION-Owner-Tools/records/recovery-inputs/source-map-'+(Get-FileHash $planFile).Hash+'.json'))))
    [IO.File]::WriteAllText((Join-Path $recordsInputs 'required-proof'),'different bytes')
    Set-FixtureManifest $wbb
    $conflictTarget=Join-Path $t 'conflict-records'
    $conflicted=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target $conflictTarget -ClaudeHome ($conflictTarget+'-ch') 2>&1)
    Assert-That 'conflicting packaged recovery input copies refuse before persistent writes' ($LASTEXITCODE-ne0-and($conflicted-join' ')-match'RESTORE_RECOVERY_INPUT_CONFLICT'-and!(Test-Path $conflictTarget))
    [IO.Directory]::Delete($recordsInputs,$true)
    Set-FixtureManifest $wbb
    $again=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target $wbTarget -ClaudeHome (Join-Path $t 'wb-ch') 2>&1)
    Assert-That 'existing recovery evidence destination refuses overwrite' ($LASTEXITCODE-ne0-and($again-join' ')-match'RESTORE_TARGET_EXISTS')
    $rp=Join-Path $wbb 'recovery-inputs/required-proof';[IO.File]::AppendAllText($rp,'corrupt')
    $badProof=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target (Join-Path $t 'wb-corrupt') -ClaudeHome (Join-Path $t 'wb-corrupt-ch') 2>&1)
    Assert-That 'corrupt proof blocks before any restore target writes' ($LASTEXITCODE-ne0-and($badProof-join' ')-match'BACKUP_CORRUPT'-and!(Test-Path (Join-Path $t 'wb-corrupt')))
    [IO.File]::WriteAllBytes($rp,$originalProof)
    $savedManifest=[IO.File]::ReadAllText((Join-Path $wbb 'SHA256SUMS.txt'))
    $withoutProof=(@($savedManifest-split'\r?\n'|Where-Object{$_-and$_-notmatch'recovery-inputs[\\/]required-proof$'})-join[char]10)+[char]10
    [IO.File]::WriteAllText((Join-Path $wbb 'SHA256SUMS.txt'),$withoutProof);[IO.File]::Delete($rp)
    $omitted=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target (Join-Path $t 'wb-omitted') -ClaudeHome (Join-Path $t 'wb-omitted-ch') 2>&1)
    Assert-That 'required input omitted together with manifest entry still refuses before writes' ($LASTEXITCODE-ne0-and($omitted-join' ')-match'RESTORE_WORKBENCH_INPUT_REQUIRED'-and!(Test-Path (Join-Path $t 'wb-omitted')))
    # Selective package v1: run from a production-shaped checkout (lib not under ORVION-Owner-Tools), as the real tool does.
    $probeLib=Join-Path $gh 'Workbench-checkout\lib';[void][IO.Directory]::CreateDirectory($probeLib)
    Copy-Item (Join-Path $lib 'Backup-Workspace.ps1'),(Join-Path $lib 'Restore-Workspace.ps1'),(Join-Path $lib 'workspace-layout.ps1') $probeLib
    Copy-Item (Join-Path $lib 'Restore-ORVION.cmd'),(Join-Path $lib 'Restore-ORVION.ps1') $probeLib
    $journalBytes=[IO.File]::ReadAllBytes($journal);[IO.File]::Delete($journal)
    $noJournal=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination (Join-Path $t 'no-journal') -RecoveryInputs $inputs -AllowUnencrypted 2>&1)
    Assert-That 'missing journal blocks a Workbench backup without success' ($LASTEXITCODE-ne0-and($noJournal-join' ')-match'BACKUP_JOURNAL_REQUIRED'-and($noJournal-join' ')-notmatch'BACKUP:')
    [IO.File]::WriteAllBytes($journal,$journalBytes)
    foreach($name in 'ORVION','CRM-trusted-main'){& git clone -q $remote (Join-Path $gh $name) 2>&1|Out-Null;if($LASTEXITCODE){throw "PRODUCT_FIXTURE_FAILED $name"}}
    # A package refuses state a bundle cannot carry; the earlier stash-warning fixture is cleared for the package cases.
    Invoke-Quiet $crm stash clear|Out-Null
    # The real trusted clone is detached with no refs at all; its bundle and restore must still round trip.
    foreach($ref in @(Invoke-Quiet $trusted for-each-ref --format='%(refname)')){& git -C $trusted update-ref --no-deref -d $ref;if($LASTEXITCODE){throw 'TRUSTED_REF_FIXTURE_FAILED'}}
    $cloud=Join-Path $t 'cloud';$pkgTemp=Join-Path $t 'pkg-temp';[void][IO.Directory]::CreateDirectory($pkgTemp)
    # A token-shaped value built at run time, so this file never holds one: the scan must name it without its value.
    $planted='ghp_'+-join((48..57)+(65..90)+(97..122)|Get-Random -Count 36|ForEach-Object{[char]$_});[IO.File]::WriteAllText((Join-Path $gh 'ORVION-Owner-Tools/records/leak.txt'),"token=$planted")
    $savedPackageTemporaryRoot=$env:WORKBENCH_TEMP_ROOT;$env:WORKBENCH_TEMP_ROOT=$pkgTemp
    $savedTemp=$env:TEMP;$savedTmp=$env:TMP;$env:TEMP=$pkgTemp;$env:TMP=$pkgTemp
    try{
        $missing=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination $cloud -RecoveryInputs $inputs -Package 2>&1)
        Assert-That 'a package without a product repository refuses before any archive' ($LASTEXITCODE-ne0-and($missing-join' ')-match'PACKAGE_REPO_REQUIRED: ORVION-trusted-main'-and!(Test-Path $cloud))
        & git clone -q $remote (Join-Path $gh 'ORVION-trusted-main') 2>&1|Out-Null;if($LASTEXITCODE){throw 'PRODUCT_FIXTURE_FAILED ORVION-trusted-main'}
        $pkg=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination $cloud -RecoveryInputs $inputs -Package 2>&1)
        if($LASTEXITCODE){throw ('PACKAGE_FIXTURE_FAILED: '+($pkg-join' '))}
        $archive=@(Get-ChildItem $cloud -Filter *.7z -Force)[0].FullName;$scan="$archive.secret-scan.txt"
        Assert-That 'package destination holds archive, scan, hash and both launchers; staging is removed' (@(Get-ChildItem $cloud -Force).Count-eq5-and(Test-Path $scan)-and$archive-and@(Get-ChildItem (Join-Path $pkgTemp 'tmp') -Force).Count-eq0-and($pkg-join' ')-match'PACKAGE: .*unencrypted'-and[IO.File]::ReadAllText("$archive.sha256").Trim()-ceq((Get-FileHash $archive).Hash+' *'+(Split-Path $archive -Leaf))-and(Get-FileHash "$cloud\Restore-ORVION.cmd").Hash-ceq(Get-FileHash "$lib\Restore-ORVION.cmd").Hash-and(Get-FileHash "$cloud\Restore-ORVION.ps1").Hash-ceq(Get-FileHash "$lib\Restore-ORVION.ps1").Hash)
        # Fail archive creation and verification separately. Real 7z handles successful commands; no installer seam.
        $backupFile=Join-Path $probeLib 'Backup-Workspace.ps1';$backupBytes=[IO.File]::ReadAllText($backupFile)
        $tokens=$null;$parseErrors=$null;$backupAst=[Management.Automation.Language.Parser]::ParseInput($backupBytes,[ref]$tokens,[ref]$parseErrors)
        $zipFunction=$backupAst.Find({param($n)$n-is[Management.Automation.Language.FunctionDefinitionAst]-and$n.Name-eq'Get-SevenZip'},$false).Extent.Text
        foreach($operation in 'a','t'){
            $failedCloud=Join-Path $t "cloud-failed-$operation";[void][IO.Directory]::CreateDirectory($failedCloud)
            foreach($name in 'Restore-ORVION.cmd','Restore-ORVION.ps1','unrelated.txt'){[IO.File]::WriteAllText((Join-Path $failedCloud $name),'keep existing bytes')}
            $fakeZip=Join-Path $t "7z-fail-$operation.cmd"
            [IO.File]::WriteAllLines($fakeZip,[string[]]@('@echo off',('if "%1"=="'+$operation+'" exit /b 71'),('"'+$zip+'" %*'),'exit /b %ERRORLEVEL%'))
            [IO.File]::WriteAllText($backupFile,$backupBytes.Replace($zipFunction,("function Get-SevenZip{'"+$fakeZip.Replace("'","''")+"'}")))
            try{$failedPackage=@(& pwsh -NoProfile -File $backupFile -Destination $failedCloud -RecoveryInputs $inputs -Package 2>&1);$failedCode=$LASTEXITCODE}
            finally{[IO.File]::WriteAllText($backupFile,$backupBytes)}
            Assert-That "failed package $operation writes no hash or launcher; existing files untouched" ($failedCode-ne0-and($failedPackage-join' ')-match'PACKAGE_(VERIFY_)?FAILED'-and@((Get-ChildItem -LiteralPath $failedCloud -Filter *.sha256)).Count-eq0-and[IO.File]::ReadAllText((Join-Path $failedCloud 'Restore-ORVION.cmd'))-ceq'keep existing bytes'-and[IO.File]::ReadAllText((Join-Path $failedCloud 'Restore-ORVION.ps1'))-ceq'keep existing bytes'-and[IO.File]::ReadAllText((Join-Path $failedCloud 'unrelated.txt'))-ceq'keep existing bytes'-and@(Get-ChildItem (Join-Path $pkgTemp 'tmp') -Force).Count-eq0)
        }
        if(Get-Command gitleaks -CommandType Application -ErrorAction SilentlyContinue){
            if([IO.File]::ReadAllText($scan)-match'^SECRET SCAN: FAILED'){
                Assert-That 'a failed installed scanner is reported without exposing the planted value' (($pkg-join' ')-match'SECRET SCAN: FAILED'-and[IO.File]::ReadAllText($scan)-notmatch$planted-and($pkg-join' ')-notmatch$planted)
            }else{
            Assert-That 'secret scan names the planted token by rule and path, never its value' ([IO.File]::ReadAllText($scan)-match'github-pat  owner-tools/records/leak\.txt:1'-and[IO.File]::ReadAllText($scan)-notmatch$planted-and($pkg-join' ')-notmatch$planted-and($pkg-join' ')-match'SECRET SCAN: [1-9]')
            }
        }else{Assert-That 'without gitleaks the scan is reported as skipped' (($pkg-join' ')-match'SECRET SCAN: SKIPPED'-and[IO.File]::ReadAllText($scan)-match'SKIPPED')}
        [IO.File]::WriteAllText((Join-Path $wb 'uncommitted.txt'),'work in progress')
        $dirtyMain=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination (Join-Path $t 'cloud3') -RecoveryInputs $inputs -Package 2>&1)
        Assert-That 'a package refuses uncommitted main-repository work instead of warning' ($LASTEXITCODE-ne0-and($dirtyMain-join' ')-match'PACKAGE_MAIN_REPO_STATE_NOT_PRESERVABLE'-and!(Test-Path (Join-Path $t 'cloud3')))
        [IO.File]::Delete((Join-Path $wb 'uncommitted.txt'))
        $listing=@(& $zip l -slt $archive 2>&1)
        Assert-That 'archive headers and every entry are unencrypted (owner decision)' ($LASTEXITCODE-eq0-and($listing-join' ')-match'SHA256SUMS\.txt'-and($listing-join' ')-match'Encrypted = -'-and($listing-join' ')-notmatch'Encrypted = \+')
        $damaged=Join-Path $t 'damaged.7z';$bytes=[IO.File]::ReadAllBytes($archive);[IO.File]::WriteAllBytes($damaged,$bytes[0..([int]($bytes.Length/2))])
        $wrong=@(& pwsh -NoProfile -File "$probeLib\Restore-Workspace.ps1" -Package $damaged -Target (Join-Path $t 'pkg-wrong') -ClaudeHome (Join-Path $t 'pkg-wrong-ch') -LegacyTarget (Join-Path $t 'pkg-wrong-docs') 2>&1)
        Assert-That 'a damaged archive refuses before any restore target and leaves no staging' ($LASTEXITCODE-ne0-and($wrong-join' ')-match'PACKAGE_EXTRACT_FAILED'-and!(Test-Path (Join-Path $t 'pkg-wrong'))-and@(Get-ChildItem (Join-Path $pkgTemp 'tmp') -Force).Count-eq0)
        $both=@(& pwsh -NoProfile -File "$probeLib\Restore-Workspace.ps1" -Package $archive -From $wbb -Target (Join-Path $t 'pkg-both') 2>&1)
        Assert-That 'exactly one restore source is required' ($LASTEXITCODE-ne0-and($both-join' ')-match'RESTORE_SOURCE_REQUIRED'-and!(Test-Path (Join-Path $t 'pkg-both')))
        $pkgTarget=Join-Path $t 'pkg-restored';$pkgDocs=Join-Path $t 'pkg-docs'
        $restoredPkg=@(& pwsh -NoProfile -File "$probeLib\Restore-Workspace.ps1" -Package $archive -Target $pkgTarget -ClaudeHome (Join-Path $t 'pkg-ch') -LegacyTarget $pkgDocs 2>&1)
        if($LASTEXITCODE){throw ('PACKAGE_RESTORE_FIXTURE_FAILED: '+($restoredPkg-join' '))}
        Assert-That 'package restore leaves no plaintext staging and rebuilds the exact source HEAD' (@(Get-ChildItem (Join-Path $pkgTemp 'tmp') -Force).Count-eq0-and(& git -C "$pkgTarget/ORVION-Workbench" rev-parse HEAD)-ceq(& git -C $wb rev-parse HEAD))
        Assert-That 'a ref-less detached trusted clone round trips at its exact HEAD' ((& git -C "$pkgTarget/ORVION-Workbench-trusted-main" rev-parse HEAD)-ceq(& git -C $trusted rev-parse HEAD)-and(& git -C "$pkgTarget/ORVION-Workbench-trusted-main" rev-parse --abbrev-ref HEAD)-ceq'HEAD'-and@(& git -C "$pkgTarget/ORVION-Workbench-trusted-main" for-each-ref).Count-eq0)
        Assert-That 'journal and sessions come from GitHub\ORVION-Owner-Tools, not the running checkout' ([IO.File]::ReadAllText("$pkgTarget/ORVION-Owner-Tools/events/events.jsonl")-ceq[Text.Encoding]::UTF8.GetString($journalBytes)-and[IO.File]::ReadAllText("$pkgTarget/ORVION-Owner-Tools/sessions/raw/s.jsonl")-ceq'fixture session')
        Assert-That 'new package does not recreate legacy destinations' (!(Test-Path $pkgDocs)-and!(Test-Path "$pkgTarget/ORVION-Recovery-Inputs"))
    }finally{$env:WORKBENCH_TEMP_ROOT=$savedPackageTemporaryRoot;$env:TEMP=$savedTemp;$env:TMP=$savedTmp}
}finally{
    foreach($key in [Environment]::GetEnvironmentVariables('Process').Keys|Where-Object{$_-match'^GIT_CONFIG_(COUNT|PARAMETERS|KEY_\d+|VALUE_\d+)$'}){Remove-Item -LiteralPath ('Env:\'+$key)}
    foreach($key in $savedGitInjection.Keys){[Environment]::SetEnvironmentVariable($key,$savedGitInjection[$key],'Process')}
    $env:WORKBENCH_TEMP_ROOT=$savedTemporaryRoot;$env:ORVION_DATA_ROOT=$savedDataRoot;$env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem;$env:USERPROFILE=$previousProfile;Get-ChildItem -LiteralPath $t -Recurse -Force -Attributes ReparsePoint|ForEach-Object{[IO.Directory]::Delete($_.FullName,$false)};Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)
}
if($fail){throw "BACKUP_RESTORE_SELFCHECK_FAILED $fail"};'BACKUP_RESTORE_SELFCHECK PASS'
