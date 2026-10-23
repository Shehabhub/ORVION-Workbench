# Operational entry for Workbench's own cycle. Native product dispatch is a later contract.
[CmdletBinding(DefaultParameterSetName='Boot')]
param([Parameter(ParameterSetName='Boot',Mandatory)][switch]$Boot,
      [Parameter(ParameterSetName='Gate',Mandatory)][switch]$Gate,
      [Parameter(ParameterSetName='Finish',Mandatory)][switch]$Finish,
      [Parameter(ParameterSetName='Review',Mandatory)][switch]$Review,
      [Parameter(ParameterSetName='Complete',Mandatory)][switch]$Complete,
      [Parameter(ParameterSetName='Execute',Mandatory)][switch]$Execute,
      [Parameter(ParameterSetName='Gate')][switch]$Staged,
      [Parameter(ParameterSetName='Gate')][string]$Base='HEAD',
      [Parameter(ParameterSetName='Gate')][string]$Head,
      [string]$Root=(Split-Path $PSScriptRoot -Parent),
      [string]$BootstrapJudge,[string]$BootstrapSha256)
$ErrorActionPreference='Stop'
try{[Console]::OutputEncoding=[Text.UTF8Encoding]::new($false)}catch{}
$temporaryJudge=$null
$operationLease=$null
$toolDirectory=$null
$temporaryParent=if($env:WORKBENCH_TEMP_ROOT){[IO.Path]::GetFullPath($env:WORKBENCH_TEMP_ROOT)}else{Join-Path ([IO.Path]::GetTempPath()) 'ORVION-Workbench'}
function Read-WorkbenchEntryGit([string[]]$Arguments) {
    $outputLines=@(& git -C $Root @Arguments 2>$null)
    if($LASTEXITCODE-ne0){throw 'WB_ENTRY_GIT_UNREADABLE'}
    $outputLines
}
function Get-WorkbenchAcceptedJudge {
    $files=@(Read-WorkbenchEntryGit @('ls-tree','-r','--name-only','HEAD'))
    if($files-ccontains'lib/Test-WorkbenchChange.ps1'){
        $expectedBlob=@(Read-WorkbenchEntryGit @('rev-parse','HEAD:lib/Test-WorkbenchChange.ps1'))[0]
        $judgeParent=Join-Path $temporaryParent 'judges'
        [void][IO.Directory]::CreateDirectory($judgeParent)
        $script:temporaryJudge=Join-Path $judgeParent ('wb-judge-'+[guid]::NewGuid().ToString('N')+'.ps1')
        $text=(@(Read-WorkbenchEntryGit @('show','HEAD:lib/Test-WorkbenchChange.ps1'))-join[char]10)+[char]10
        [IO.File]::WriteAllText($script:temporaryJudge,$text,[Text.UTF8Encoding]::new($false))
        $actualBlob=@(Read-WorkbenchEntryGit @('hash-object','--no-filters','--',$script:temporaryJudge))[0]
        if($actualBlob-cne$expectedBlob){throw 'WB_ACCEPTED_JUDGE_BYTES_MISMATCH'}
        return $script:temporaryJudge
    }
    if(!$BootstrapJudge-or$BootstrapSha256-cnotmatch'^[0-9A-F]{64}$'-or
       ![IO.Path]::IsPathFullyQualified($BootstrapJudge)-or
       (Get-FileHash -LiteralPath $BootstrapJudge -Algorithm SHA256).Hash-cne$BootstrapSha256){throw 'WB_EXPLICIT_REVIEWED_BOOTSTRAP_REQUIRED'}
    $fullJudge=[IO.Path]::GetFullPath($BootstrapJudge)
    if($fullJudge.StartsWith($Root.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'WB_BOOTSTRAP_INSIDE_SUBJECT_REFUSED'}
    $fullJudge
}
try {
    $Root=[IO.Path]::GetFullPath($Root)
    if($temporaryParent-ieq$Root-or$temporaryParent.StartsWith($Root.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'WB_TEMP_ROOT_INSIDE_CHECKOUT_REFUSED'}
    if([IO.Path]::GetFullPath($PSCommandPath)-ine(Join-Path $Root 'lib/Workbench.ps1')){throw 'WB_ENTRY_ROOT_MISMATCH'}
    $judge=Get-WorkbenchAcceptedJudge
    if($Boot){& pwsh -NoProfile -File $judge -Root $Root -Mode Boot;exit $LASTEXITCODE}
    if($Gate){
        if($Head){& pwsh -NoProfile -File $judge -Root $Root -Mode Range -Base $Base -Head $Head}
        else{& pwsh -NoProfile -File $judge -Root $Root -Mode Gate -Base $Base -Staged:$Staged}
        exit $LASTEXITCODE
    }
    . $judge -Root $Root
    $Root=Assert-WorkbenchRoot $Root
    $operationLease=Enter-WorkbenchOperation $Root
    $contract=Get-WorkbenchPointer ([IO.File]::ReadAllText((Join-Path $Root 'RESUME.md')))
    if($contract-eq'None'){throw 'WB_ACTIVE_CONTRACT_REQUIRED'}
    $contractFile=Get-WorkbenchLocalPath $Root $contract
    $record=Get-WorkbenchFields ([IO.File]::ReadAllText($contractFile))
    if($record.Status-cne'In Progress'){throw 'WB_IN_PROGRESS_REQUIRED'}
    if($record.Checkpoint.Blocker-cne'None'){throw ('WB_RUNTIME_BLOCKER:'+$record.Checkpoint.Blocker)}
    Assert-WorkbenchApproval $record $Root
    $dirty=@(Read-WorkbenchEntryGit @('status','--porcelain','--untracked-files=all'))
    if($dirty.Count){throw 'WB_CLEAN_IMPLEMENTATION_REQUIRED'}
    $finishHead=@(Read-WorkbenchEntryGit @('rev-parse','HEAD'))[0]
    $tree=@(Read-WorkbenchEntryGit @('rev-parse','HEAD^{tree}'))[0]
    $profiles=@(Get-WorkbenchProfiles @(Get-WorkbenchScope $record))
    $fingerprint=Get-WorkbenchFingerprint $Root $tree $contract
    if($Execute){
        $approval=Get-WorkbenchApprovalValues $record
        $selectedDraft=$approval['Approved Draft']
        $toolDirectory=Join-Path $temporaryParent ('tools/workbench-approved-applier-'+[guid]::NewGuid().ToString('N'))
        [void][IO.Directory]::CreateDirectory($toolDirectory)
        foreach($tool in 'apply-draft-steps.ps1','Invoke-DraftSteps.ps1'){
            $toolText=(@(Read-WorkbenchEntryGit @('show',('HEAD:lib/'+$tool)))-join[char]10)+[char]10
            $toolPath=Join-Path $toolDirectory $tool
            [IO.File]::WriteAllText($toolPath,$toolText,[Text.UTF8Encoding]::new($false))
            $expectedTool=@(Read-WorkbenchEntryGit @('rev-parse',('HEAD:lib/'+$tool)))[0]
            $actualTool=@(Read-WorkbenchEntryGit @('hash-object','--no-filters','--',$toolPath))[0]
            if($actualTool-cne$expectedTool){throw 'WB_ACCEPTED_APPLIER_BYTES_MISMATCH'}
        }
        $applier=Join-Path $toolDirectory 'apply-draft-steps.ps1'
        $planLines=@(& pwsh -NoProfile -File $applier -Draft $selectedDraft -Root $Root -Plan 2>&1);$planExit=$LASTEXITCODE
        if($planExit-ne0){throw 'WB_EXECUTION_PLAN_UNREADABLE'}
        $plan=($planLines-join[char]10)|ConvertFrom-Json -ErrorAction Stop
        if($plan.Schema-ne1-or[IO.Path]::GetFullPath($plan.Root)-ine$Root-or$plan.DraftSHA256-cne$approval['Approved SHA256']-or!@($plan.Files).Count){throw 'WB_EXECUTION_PLAN_IDENTITY_MISMATCH'}
        $scope=@(Get-WorkbenchScope $record)
        foreach($item in $plan.Files){if($item.File-cnotin$scope){throw 'WB_EXECUTION_PLAN_OUTSIDE_SCOPE'}}
        Assert-WorkbenchArtifact $selectedDraft $approval['Approved SHA256']
        & pwsh -NoProfile -File $applier -Draft $selectedDraft -Root $Root
        if($LASTEXITCODE-ne0){throw 'WB_LITERAL_EXECUTION_FAILED'}
        'WORKBENCH_EXECUTE: DONE (normal scoped commit and verification still required)'
    }elseif($Finish){
        if(!$env:ORVION_TIMED_LOG-or!(Test-Path -LiteralPath $env:ORVION_TIMED_LOG -PathType Leaf)-or
           !$env:ORVION_TIMED_ROOT-or[IO.Path]::GetFullPath($env:ORVION_TIMED_ROOT)-ine$Root){throw 'WB_FINISH_NOT_TIMED_FROM_OWN_ROOT'}
        $runLog=[IO.Path]::GetFullPath($env:ORVION_TIMED_LOG)
        if($runLog.StartsWith($Root.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'WB_LOG_INSIDE_CHECKOUT_REFUSED'}
        $logStream=[IO.File]::Open($runLog,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
        $logReader=[IO.StreamReader]::new($logStream,[Text.Encoding]::UTF8,$true)
        try{$runStart=$logReader.ReadLine()}finally{$logReader.Dispose()}
        if($runStart-notmatch'^\[[^]]+\] START pid=[0-9]+ '){throw 'WB_TIMED_START_INVALID'}
        $runnerId=0
        if(![int]::TryParse($env:ORVION_TIMED_PID,[ref]$runnerId)-or$runStart-notmatch(' START pid='+$runnerId+' ')){throw 'WB_TIMED_RUNNER_ID_INVALID'}
        $ancestorId=$PID;$foundRunner=$false
        for($hop=0;$hop-lt8-and$ancestorId-gt0;$hop++){
            $processRow=Get-CimInstance Win32_Process -Filter "ProcessId=$ancestorId" -ErrorAction Stop
            if(!$processRow){throw 'WB_TIMED_ANCESTRY_UNREADABLE'}
            if($ancestorId-eq$runnerId){
                $expectedRunner=Get-WorkbenchLocalPath $Root 'lib/run_timed.ps1'
                if(!([string]$processRow.CommandLine).Contains($expectedRunner,[StringComparison]::OrdinalIgnoreCase)){throw 'WB_TIMED_RUNNER_SOURCE_MISMATCH'}
                $foundRunner=$true;break
            }
            $ancestorId=[int]$processRow.ParentProcessId
        }
        if(!$foundRunner){throw 'WB_TIMED_RUNNER_NOT_ANCESTOR'}
        if('WORKSTATION'-in$profiles-or'CI'-in$profiles){throw 'WB_REQUIRED_PROFILE_NOT_IMPLEMENTED'}
        $workingReceipt=Get-WorkbenchLocalPath $Root '.workbench-local-certification.json'
        if(Test-Path -LiteralPath $workingReceipt){[IO.File]::Delete($workingReceipt)}
        $clock=[Diagnostics.Stopwatch]::StartNew()
        & pwsh -NoProfile -File (Join-Path $Root 'tests.ps1')
        $testExit=$LASTEXITCODE
        if($testExit-ne0){"FAILED: pwsh -NoProfile -File tests.ps1 (exit $testExit)";throw "WB_REQUIRED_TESTS_FAILED:exit=$testExit"}
        $afterHead=@(Read-WorkbenchEntryGit @('rev-parse','HEAD'))[0]
        if($afterHead-cne$finishHead-or@(Read-WorkbenchEntryGit @('status','--porcelain','--untracked-files=all')).Count){throw 'WB_INPUT_CHANGED_DURING_FINISH'}
        if((Get-WorkbenchFingerprint $Root $tree $contract)-cne$fingerprint){throw 'WB_FINGERPRINT_CHANGED_DURING_FINISH'}
        $receipt=[ordered]@{schema=1;root=$Root;contract=$contract;finishHead=$finishHead;fingerprint=$fingerprint;profiles=$profiles;
            evaluator=@(Read-WorkbenchEntryGit @('rev-parse','HEAD:lib/Test-WorkbenchChange.ps1'))[0];runLog=$runLog;runStart=$runStart;result='READY'}
        $digest=Get-WorkbenchDigest ($receipt|ConvertTo-Json -Depth 5 -Compress)
        $receipt['digest']=$digest
        $bytes=($receipt|ConvertTo-Json -Depth 5)
        [IO.File]::WriteAllText($workingReceipt,$bytes,[Text.UTF8Encoding]::new($false))
        $archive=Get-WorkbenchLocalPath $Root '.workbench-certifications'
        [void][IO.Directory]::CreateDirectory($archive)
        $archivedReceipt=Join-Path $archive ($digest+'.json')
        if(Test-Path -LiteralPath $archivedReceipt){
            if([IO.File]::ReadAllText($archivedReceipt)-cne$bytes){throw 'WB_HISTORICAL_RECEIPT_COLLISION'}
        }else{[IO.File]::WriteAllText($archivedReceipt,$bytes,[Text.UTF8Encoding]::new($false))}
        'WORKBENCH_LOCAL_CERTIFY: READY';"PROFILES: $($profiles-join', ')";"RECEIPT: $digest";"TIME: Workbench Finish $($clock.Elapsed.ToString('hh\:mm\:ss'))"
    }elseif($Review){
        Assert-WorkbenchCompletion $Root $tree $contract $record $profiles
        'WORKBENCH_REVIEW: READY';"FINGERPRINT: $fingerprint"
    }elseif($Complete){
        Assert-WorkbenchCompletion $Root $tree $contract $record $profiles
        $contractText=[IO.File]::ReadAllText($contractFile)
        $statusBody=$record.Sections.Status.Replace('[x] In Progress','[ ] In Progress').Replace('[ ] Complete','[x] Complete')
        $contractText=Set-WorkbenchSection $contractText 'Status' $statusBody
        if((Get-WorkbenchFrozen (Get-WorkbenchFields $contractText))-cne(Get-WorkbenchFrozen $record)){throw 'WB_COMPLETION_WOULD_CHANGE_FROZEN_AUTHORITY'}
        $resume=Get-WorkbenchLocalPath $Root 'RESUME.md'
        $resumeText=[IO.File]::ReadAllText($resume)
        $resumeText=[regex]::Replace($resumeText,'(?m)^Active Workbench Contract: [^\r\n]+','Active Workbench Contract: None')
        [IO.File]::WriteAllText($contractFile,$contractText,[Text.UTF8Encoding]::new($false))
        [IO.File]::WriteAllText($resume,$resumeText,[Text.UTF8Encoding]::new($false))
        'WORKBENCH_COMPLETE: PREPARED (normal scoped commit and range judgment still required)'
    }
    exit 0
}catch{'WORKBENCH: BLOCKED';"CODE: $($_.Exception.Message)";exit 1}
finally{
    if($operationLease){$operationLease.Dispose()}
    if($temporaryJudge-and(Test-Path -LiteralPath $temporaryJudge)){[IO.File]::Delete($temporaryJudge)}
    if($toolDirectory-and(Test-Path -LiteralPath $toolDirectory)){
        # Only these two own materializations; no recursive deletion or target discovery.
        foreach($tool in 'apply-draft-steps.ps1','Invoke-DraftSteps.ps1'){[IO.File]::Delete((Join-Path $toolDirectory $tool))}
        [IO.Directory]::Delete($toolDirectory,$false)
    }
}
