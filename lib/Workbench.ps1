# Operational entry for Workbench's own cycle. Native product dispatch is a later contract.
[CmdletBinding(DefaultParameterSetName='Boot')]
param([Parameter(ParameterSetName='Boot',Mandatory)][switch]$Boot,
      [Parameter(ParameterSetName='Gate',Mandatory)][switch]$Gate,
      [Parameter(ParameterSetName='Finish',Mandatory)][switch]$Finish,
      [Parameter(ParameterSetName='Review',Mandatory)][switch]$Review,
      [Parameter(ParameterSetName='Complete',Mandatory)][switch]$Complete,
      [Parameter(ParameterSetName='Execute',Mandatory)][switch]$Execute,
      [Parameter(ParameterSetName='CI',Mandatory)][switch]$CI,
      [Parameter(ParameterSetName='CI',Mandatory)][string]$Candidate,
      [Parameter(ParameterSetName='CI',Mandatory)][string]$CIRuntimeRoot,
      [Parameter(ParameterSetName='CI')][switch]$CIWorker,
      [string]$Actionlint,
      [Parameter(ParameterSetName='Gate')][switch]$Staged,
      [Parameter(ParameterSetName='Gate')][string]$Base='HEAD',
      [Parameter(ParameterSetName='Gate')][string]$Head,
      [string]$Root=(Split-Path $PSScriptRoot -Parent),
      [string]$BootstrapJudge,[string]$BootstrapSha256)
$ErrorActionPreference='Stop'
try{[Console]::OutputEncoding=[Text.UTF8Encoding]::new($false)}catch{}
$temporaryJudge=$null
$operationLease=$null
$heavyLease=$null
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
    # This primitive must run before Git can select or materialize the accepted judge.
    # The owning checker repeats context validation after trusted loading; neither prints values.
    foreach($key in 'GIT_DIR','GIT_WORK_TREE','GIT_COMMON_DIR','GIT_INDEX_FILE','GIT_OBJECT_DIRECTORY','GIT_ALTERNATE_OBJECT_DIRECTORIES','GIT_CONFIG_COUNT','GIT_CONFIG_PARAMETERS'){
        if([Environment]::GetEnvironmentVariable($key,'Process')){throw 'WB_BOOTSTRAP_GIT_ENVIRONMENT_REFUSED'}
    }
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

    if($CI){
        $ciRecipe=Get-WorkbenchCIRecipe $Root $Candidate $CIRuntimeRoot
        $Actionlint=Assert-WorkbenchCITool $Actionlint
        $env:WORKBENCH_ACTIONLINT=$Actionlint
        $CIRuntimeRoot=$ciRecipe.Material.runtime
        if(!$CIWorker){
            if(Test-Path -LiteralPath $CIRuntimeRoot){throw 'WB_CI_RUNTIME_ALREADY_EXISTS'}
            [void][IO.Directory]::CreateDirectory($CIRuntimeRoot)
            $ciLog=Join-Path $CIRuntimeRoot 'ci.log'
            # Invoke only the existing timed runner/watcher and this fixed worker. No caller command API.
            $quote={param($value) "'"+$value.Replace("'","''")+"'"}
            $command='& pwsh -NoProfile -File '+(& $quote $PSCommandPath)+' -Root '+(& $quote $Root)+' -CI -CIWorker -Candidate '+$Candidate+' -CIRuntimeRoot '+(& $quote $CIRuntimeRoot)+' -Actionlint '+(& $quote $Actionlint)
            $children=[Collections.Generic.List[object]]::new()
            try{
                foreach($role in 'watcher','runner'){
                    $info=[Diagnostics.ProcessStartInfo]::new((Get-Command pwsh -CommandType Application|Select-Object -First 1).Source)
                    $info.UseShellExecute=$false;$info.CreateNoWindow=$true;$info.WorkingDirectory=$Root
                    $info.RedirectStandardOutput=$true;$info.RedirectStandardError=$true
                    foreach($key in 'WORKBENCH_SUITE_PARENT','WORKBENCH_SUITE_RECIPE','WORKBENCH_SUITE_MODE','WORKBENCH_CI_CANDIDATE','WORKBENCH_CI_RUNTIME','WORKBENCH_TEST_EVIDENCE','ORVION_TIMED_LOG','ORVION_TIMED_ROOT','ORVION_TIMED_PID'){$null=$info.Environment.Remove($key)}
                    $info.Environment['WORKBENCH_TEST_ROOT']=$ciRecipe.Context['Tests Root'];$info.Environment['WORKBENCH_TEMP_ROOT']=$ciRecipe.Context['Temp Root']
                    $ciArguments=if($role-ceq'watcher'){@('-NoProfile','-File',(Join-Path $Root 'lib/watch_run.ps1'),'-Log',$ciLog,'-Run','workbench-ci','-Brief','-PollSeconds','2','-Csv',(Join-Path $CIRuntimeRoot 'timings.csv'))}else{@('-NoProfile','-File',(Join-Path $Root 'lib/run_timed.ps1'),'-Log',$ciLog,'-WorkingDirectory',$Root,'-Command',$command)}
                    foreach($argument in $ciArguments){$info.ArgumentList.Add($argument)}
                    $process=[Diagnostics.Process]::new();$process.StartInfo=$info;$null=$process.Start()
                    $children.Add([pscustomobject]@{Role=$role;Process=$process;Out=$process.StandardOutput.ReadToEndAsync();Err=$process.StandardError.ReadToEndAsync()})
                }
                foreach($child in $children|Sort-Object Role){
                    $child.Process.WaitForExit()
                    [IO.File]::WriteAllText((Join-Path $CIRuntimeRoot ($child.Role+'.log')),($child.Out.GetAwaiter().GetResult()+$child.Err.GetAwaiter().GetResult()),[Text.UTF8Encoding]::new($false))
                    [IO.File]::WriteAllText((Join-Path $CIRuntimeRoot ($child.Role+'.exit')),[string]$child.Process.ExitCode)
                }
                if(@($children|Where-Object{$_.Process.ExitCode-ne0}).Count){
                    # Failure only: actual exits, the runner's own timed log and a failed watcher's output, bounded.
                    # Controls are replaced and every line is prefixed, so replayed text cannot form a runner workflow command.
                    # Same bounded vocabulary as watch_run.ps1 Hide-Secret; its top-level watcher cannot be imported here.
                    # Mask each complete raw line before sanitizing, truncating or printing it; raw runtime logs stay local.
                    function Hide-WorkbenchCIDiagnostic([string]$diagnosticLine) {
                        $t = $diagnosticLine -replace '\b(gh[pousr]_[A-Za-z0-9]{20,}|github_pat_\w{20,}|sk-[A-Za-z0-9_-]{20,}|eyJ[\w-]{10,}\.[\w-]{10,}\.[\w-]+)', '<redacted>'
                        $t = $t -replace '(?i)\bbearer\s+(?!<redacted>)\S+', 'Bearer <redacted>'
                        $t -replace '(?i)\b(token|secret|password|passwd|api[_-]?key|authorization)(\s*[:=]\s*)(?!Bearer <redacted>)(?!<redacted>)\S+', '$1$2<redacted>'
                    }
                    foreach($child in $children|Sort-Object Role){'CI_CHILD: '+$child.Role+' exit='+$child.Process.ExitCode}
                    foreach($source in @(@('CI_LOG','ci.log',400),@('CI_WATCHER','watcher.log',40))){
                        if($source[0]-ceq'CI_WATCHER'-and@($children|Where-Object{$_.Role-ceq'watcher'})[0].Process.ExitCode-eq0){continue}
                        try{$lines=@([IO.File]::ReadAllLines((Join-Path $CIRuntimeRoot $source[1]))|Select-Object -Last $source[2]);if(!$lines.Count){$lines=@('<empty>')}}catch{$lines=@('<unreadable>')}
                        foreach($line in $lines){$text=Hide-WorkbenchCIDiagnostic $line;$text=$text-replace'[\x00-\x08\x0A-\x1F\x7F-\x9F\u2028\u2029]','?';$source[0]+': '+$text.Substring(0,[Math]::Min(2000,$text.Length))}
                    }
                    throw 'WB_CI_CHILD_OR_OBSERVER_FAILED'
                }
                $actual=Get-WorkbenchCIRecipe $Root $Candidate $CIRuntimeRoot
                if($actual.Digest-cne$ciRecipe.Digest){throw 'WB_CI_INPUT_CHANGED'}
                $logText=[IO.File]::ReadAllText($ciLog)
                $previousPosition=-1
                foreach($test in $ciRecipe.Material.schedule.tests){
                    $matchesTest=[regex]::Matches($logText,'(?m)^\[\+[^]]+\] PASS '+[regex]::Escape((Split-Path $test -Leaf))+'\r?$')
                    if($matchesTest.Count-ne1-or$matchesTest[0].Index-le$previousPosition){throw 'WB_CI_REQUIRED_TEST_NOT_OBSERVED'}
                    $previousPosition=$matchesTest[0].Index
                }
                if([regex]::Matches($logText,'(?m)^\[\+[^]]+\] PASS hazards \(').Count-ne1-or
                   [regex]::Matches($logText,'(?m)^\[\+[^]]+\] PASS the real journal is untouched by the checks\r?$').Count-ne1){throw 'WB_CI_REQUIRED_TEST_NOT_OBSERVED'}
                if([regex]::Matches($logText,'(?m)^\[\+[^]]+\] TESTS: all passed in ').Count-ne1-or$logText-notmatch'END exit=0 '-or$logText-notmatch'WORKBENCH_CI_WORKER: READY'){throw 'WB_CI_SCHEDULE_NOT_PROVED'}
                [ordered]@{Kind='CI_TEST_ONLY';Candidate=$Candidate;Root=$Root;Recipe=$ciRecipe.Digest;Result='READY';RunnerExit=0;WatcherExit=0;Certification=$false}|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $CIRuntimeRoot 'ci-result.json') -Encoding utf8
                'WORKBENCH_CI: READY (tests only; no native certification)'
            }finally{foreach($child in $children){$child.Process.Dispose()}}
            exit 0
        }
        $operationLease=Enter-WorkbenchOperation $Root
        Assert-WorkbenchCITimed $Root $CIRuntimeRoot
        $null=Assert-WorkbenchContextRuntime $Root $ciRecipe.Context -ResourceCheck
        $heavyLease=Enter-WorkbenchHeavyOperation $ciRecipe.Context
        $env:WORKBENCH_TEST_ROOT=$ciRecipe.Context['Tests Root'];$env:WORKBENCH_TEMP_ROOT=$ciRecipe.Context['Temp Root']
        $env:WORKBENCH_SUITE_PARENT=[string]$PID;$env:WORKBENCH_SUITE_RECIPE=$ciRecipe.Digest;$env:WORKBENCH_SUITE_MODE='CI'
        $env:WORKBENCH_CI_CANDIDATE=$Candidate;$env:WORKBENCH_CI_RUNTIME=$CIRuntimeRoot
        Assert-WorkbenchWorkflowSet $Root $Candidate $Actionlint $ciRecipe.Context['Temp Root']
        & pwsh -NoProfile -File (Join-Path $Root 'tests.ps1')
        if($LASTEXITCODE-ne0){throw 'WB_CI_REQUIRED_TESTS_FAILED'}
        Assert-WorkbenchCIObserved $Root (Join-Path $CIRuntimeRoot 'ci.log')
        if((Get-WorkbenchCIRecipe $Root $Candidate $CIRuntimeRoot).Digest-cne$ciRecipe.Digest){throw 'WB_CI_INPUT_CHANGED'}
        'WORKBENCH_CI_WORKER: READY';exit 0
    }

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
    $context=Get-WorkbenchContext $record
    $recipe=if($context){Get-WorkbenchRecipe $Root $tree $record}else{$null}
    if($context-and$Execute){$executionRole=Assert-WorkbenchContextRuntime $Root $context}
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
        if($context-and!(Test-WorkbenchUnder (Assert-WorkbenchExternalPath $runLog) $context['Runtime Root'])){throw 'WB_CONTEXT_RUN_LOG_MISMATCH'}
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
        if('WORKSTATION'-in$profiles){throw 'WB_REQUIRED_PROFILE_NOT_IMPLEMENTED'}
        if($context){
            $executionRole=Assert-WorkbenchContextRuntime $Root $context -ResourceCheck
            $sandboxProof=Assert-WorkbenchSandboxProof $Root $record $context $recipe -Implementation
            $heavyLease=Enter-WorkbenchHeavyOperation $context
            $env:WORKBENCH_TEST_ROOT=$context['Tests Root']
            $env:WORKBENCH_TEMP_ROOT=$context['Temp Root']
            $env:WORKBENCH_SUITE_PARENT=[string]$PID
            $env:WORKBENCH_SUITE_RECIPE=$recipe.Digest
        }
        $env:WORKBENCH_SUITE_MODE='FINISH'
        if($Actionlint){$env:WORKBENCH_ACTIONLINT=Assert-WorkbenchCITool $Actionlint}
        if('CI'-in$profiles){Assert-WorkbenchWorkflowSet $Root $tree $Actionlint $temporaryParent -RequireWorkflow}
        $workingReceipt=Get-WorkbenchLocalPath $Root '.workbench-local-certification.json'
        if(Test-Path -LiteralPath $workingReceipt){[IO.File]::Delete($workingReceipt)}
        $clock=[Diagnostics.Stopwatch]::StartNew()
        if($context){
            & pwsh -NoProfile -File (Join-Path $Root 'lib/Events.ps1') -Root $Root -Find $record.Id
            if($LASTEXITCODE-ne0){throw 'WB_REQUIRED_EVENTS_READ_FAILED'}
            'WORKBENCH_PREFLIGHT: Events Find READY'
            & pwsh -NoProfile -File (Join-Path $Root 'lib/Hunt.ps1') -Root $Root -Quick -NoRecord
            if($LASTEXITCODE-ne0){throw 'WB_REQUIRED_HUNT_FAILED'}
            'WORKBENCH_PREFLIGHT: Hunt Quick READY (GAP/proposal text is not zero findings or approval)'
        }
        & pwsh -NoProfile -File (Join-Path $Root 'tests.ps1')
        $testExit=$LASTEXITCODE
        if($testExit-ne0){"FAILED: pwsh -NoProfile -File tests.ps1 (exit $testExit)";throw "WB_REQUIRED_TESTS_FAILED:exit=$testExit"}
        $afterHead=@(Read-WorkbenchEntryGit @('rev-parse','HEAD'))[0]
        if($afterHead-cne$finishHead-or@(Read-WorkbenchEntryGit @('status','--porcelain','--untracked-files=all')).Count){throw 'WB_INPUT_CHANGED_DURING_FINISH'}
        if((Get-WorkbenchFingerprint $Root $tree $contract)-cne$fingerprint){throw 'WB_FINGERPRINT_CHANGED_DURING_FINISH'}
        $receipt=[ordered]@{schema=1;root=$Root;contract=$contract;finishHead=$finishHead;fingerprint=$fingerprint;profiles=$profiles;
            evaluator=@(Read-WorkbenchEntryGit @('rev-parse','HEAD:lib/Test-WorkbenchChange.ps1'))[0];runLog=$runLog;runStart=$runStart;result='READY'}
        if($context){
            $receipt['schema']=2
            $receipt['draftSHA256']=(Get-WorkbenchApprovalValues $record)['Approved SHA256']
            $receipt['recipe']=$recipe.Digest;$receipt['role']=$executionRole
            $receipt['proof']=if($sandboxProof){$sandboxProof.digest}else{$null}
        }
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
    if($heavyLease){$heavyLease.Dispose()}
    if($operationLease){$operationLease.Dispose()}
    if($temporaryJudge-and(Test-Path -LiteralPath $temporaryJudge)){[IO.File]::Delete($temporaryJudge)}
    if($toolDirectory-and(Test-Path -LiteralPath $toolDirectory)){
        # Only these two own materializations; no recursive deletion or target discovery.
        foreach($tool in 'apply-draft-steps.ps1','Invoke-DraftSteps.ps1'){[IO.File]::Delete((Join-Path $toolDirectory $tool))}
        [IO.Directory]::Delete($toolDirectory,$false)
    }
}
