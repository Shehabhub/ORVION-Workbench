# Real local Git/child fixtures; the console and transport seams do not prove owner identity or live release.
param([string]$EvidenceDirectory,[string[]]$CaseNames)
$ErrorActionPreference='Stop'
$work=Join-Path ([IO.Path]::GetTempPath()) ('orvion-dual-'+[guid]::NewGuid().ToString('N'))
[void][IO.Directory]::CreateDirectory($work)
$gitExe=(Get-Command git -CommandType Application|Select-Object -First 1).Source
$records=[Collections.Generic.List[object]]::new()
function Write-DualFixture([string]$Path,[string]$Content){[void][IO.Directory]::CreateDirectory((Split-Path $Path -Parent));[IO.File]::WriteAllText($Path,$Content,[Text.UTF8Encoding]::new($false))}
function Invoke-DualSetupGit([string[]]$GitArguments){$value=@(& $gitExe @GitArguments 2>&1);if($LASTEXITCODE){throw "FIXTURE_SETUP_GIT: $($GitArguments-join' ') $($value-join' ')"};$value|ForEach-Object{"$_"}}
$stub=@'
param([string]$Root,[string]$Candidate,[string]$EvidenceDirectory)
$ErrorActionPreference='Stop'
$cfg=Get-Content -Raw -LiteralPath $env:ORVION_DUAL_FIXTURE|ConvertFrom-Json
$own=Split-Path $PSScriptRoot -Parent
$target=@($cfg.Targets|Where-Object TrustedRoot -eq $own)[0]
$operation=if($PSCommandPath-match'publish'){'PUBLISH'}else{'PROMOTE'}
Add-Content -LiteralPath $target.Calls -Value $operation
if(($cfg.Mode-eq'second-fail'-and$target.Index-eq1)-or($cfg.Mode-eq'first-fail'-and$target.Index-eq0)){exit 7}
$ref=if($operation-eq'PUBLISH'){'refs/heads/orvion-preflight'}else{'refs/heads/main'}
$actual=if($cfg.Mode-eq'wrong-ref'){$target.Base}else{$Candidate}
& $cfg.GitExe -C $target.Bare update-ref $ref $actual
if($LASTEXITCODE){throw 'FIXTURE_REF_UPDATE'}
if($cfg.Mode-eq'zero-no-record'){exit 0}
if($cfg.Mode-eq'malformed-record'){
    [void][IO.Directory]::CreateDirectory($EvidenceDirectory)
    [IO.File]::WriteAllText((Join-Path $EvidenceDirectory 'operation.json'),'{broken')
    exit 0
}
$metadata=@{operation=$operation;repository=$target.Repository;candidate=$Candidate;targetRef=$ref;checkout=$(if($operation-eq'PUBLISH'){$Root}else{$own});result='DONE';exitCode=0;classification='EXACT_REMOTE_REF_VERIFIED'}
if($cfg.Mode-eq'wrong-record'){$metadata.candidate='0'*40}
[void][IO.Directory]::CreateDirectory($EvidenceDirectory)
$metadata|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $EvidenceDirectory 'operation.json')
Write-Output "${operation}: DONE"
exit 0
'@
$driver=@'
param([string]$Config)
$ErrorActionPreference='Stop'
$global:OrvionDualFixture=Get-Content -Raw -LiteralPath $Config|ConvertFrom-Json
$env:ORVION_DUAL_FIXTURE=$Config
function Invoke-DualFixtureGit{
    $forward=@($args)
    if($forward.Count-ge3-and$forward[0]-ceq'-C'-and$forward[1]-ceq$global:OrvionDualFixture.WorkbenchRoot){
        if($global:OrvionDualFixture.Mode-eq'unreadable-admission'){$global:LASTEXITCODE=128;return}
        if($forward[2]-notin@('rev-parse','status','ls-tree')){throw 'FIXTURE_WORKBENCH_READ_ONLY'}
        & $global:OrvionDualFixture.GitExe @forward
        $global:LASTEXITCODE=$LASTEXITCODE
        return
    }
    $target=@($global:OrvionDualFixture.Targets|Where-Object{$forward[1]-in@($_.CandidateRoot,$_.TrustedRoot)})
    if($forward.Count-lt3-or$forward[0]-cne'-C'-or$target.Count-ne1){throw 'FIXTURE_GIT_ROOT'}
    if($forward[2]-in@('push','fetch')){throw 'FIXTURE_NO_TRANSPORT_WRITES'}
    if($forward[2]-eq'ls-remote'){
        if($forward.Count-ne6-or$forward[3]-cne'--exit-code'-or$forward[4]-cne'origin'){throw 'FIXTURE_REMOTE_ARGUMENTS'}
        if($global:OrvionDualFixture.Mode-eq'unreadable-after'-and(Test-Path -LiteralPath $target[0].Calls)){$global:LASTEXITCODE=128;return}
        $forward[4]=$target[0].Bare
    }
    & $global:OrvionDualFixture.GitExe @forward
    $global:LASTEXITCODE=$LASTEXITCODE
}
Set-Alias -Name git -Value Invoke-DualFixtureGit
$call=@{Descriptor=$global:OrvionDualFixture.Descriptor;EvidenceDirectory=$global:OrvionDualFixture.Evidence;Approval=$global:OrvionDualFixture.Approval;ApprovalSha256=$global:OrvionDualFixture.ApprovalSha256}
if($global:OrvionDualFixture.Mode-eq'noninteractive'){$call.NonInteractive=$true}
& $global:OrvionDualFixture.Entry @call
exit $LASTEXITCODE
'@
Write-DualFixture (Join-Path $work 'driver.ps1') $driver
$seed=Join-Path $work 'seed'
[void](Invoke-DualSetupGit @('init','--quiet','-b','main',$seed))
[void](Invoke-DualSetupGit @('-C',$seed,'config','user.name','Dual fixture'))
[void](Invoke-DualSetupGit @('-C',$seed,'config','user.email','fixture@example.invalid'))
[void](Invoke-DualSetupGit @('-C',$seed,'config','core.autocrlf','false'))
Write-DualFixture (Join-Path $seed '.gitignore') ".orvion-certifications/`n"
foreach($operation in 'publish','promote'){Write-DualFixture (Join-Path $seed "scripts\owner_$operation.ps1") $stub}
[void](Invoke-DualSetupGit @('-C',$seed,'add','--','.'))
[void](Invoke-DualSetupGit @('-C',$seed,'commit','--quiet','-m','Fixture trusted main'))
$base=(Invoke-DualSetupGit @('-C',$seed,'rev-parse','HEAD')).Trim()
[void](Invoke-DualSetupGit @('-C',$seed,'checkout','--quiet','-b','candidate'))
Write-DualFixture (Join-Path $seed 'candidate.txt') 'synthetic candidate'
[void](Invoke-DualSetupGit @('-C',$seed,'add','--','candidate.txt'))
[void](Invoke-DualSetupGit @('-C',$seed,'commit','--quiet','-m','Fixture candidate'))
$candidate=(Invoke-DualSetupGit @('-C',$seed,'rev-parse','HEAD')).Trim()
[void](Invoke-DualSetupGit @('-C',$seed,'branch','orvion-preflight',$candidate))
[void](Invoke-DualSetupGit @('-C',$seed,'checkout','--quiet','-b','candidate-second',$base))
Write-DualFixture (Join-Path $seed 'second-candidate.txt') 'independent second candidate'
[void](Invoke-DualSetupGit @('-C',$seed,'add','--','second-candidate.txt'))
[void](Invoke-DualSetupGit @('-C',$seed,'commit','--quiet','-m','Distinct second target candidate'))
$secondCandidate=(Invoke-DualSetupGit @('-C',$seed,'rev-parse','HEAD')).Trim()
if($secondCandidate-ceq$candidate){throw 'DUAL_FIXTURE_CANDIDATES_NOT_DISTINCT'}
[void](Invoke-DualSetupGit @('-C',$seed,'checkout','--quiet','main'))
foreach($operation in 'PUBLISH','PROMOTE'){
    foreach($mode in @('success','noninteractive','missing-party','wrong-repository','shared-root','bad-sha','stale-base','wrong-account','dirty-second','first-fail','second-fail','zero-no-record','malformed-record','wrong-record','wrong-ref','unreadable-after','evidence-inside','missing-approval','changed-approval','expired-approval','wrong-workbench','changed-source','changed-config','changed-descriptor','duplicate-approval','duplicate-descriptor','wrong-output','unreadable-admission')){
        if($CaseNames-and$mode-cnotin$CaseNames){continue}
        $casePath=Join-Path $work ($operation.ToLowerInvariant()+'-'+$mode)
        [void][IO.Directory]::CreateDirectory($casePath)
        $targets=@();$descriptorTargets=@()
        foreach($index in 0..1){
            $repository=@('PlatPlusHub/CRM','Shehabhub/ORVION')[$index]
            $ownCandidate=if($index-eq0){$candidate}else{$secondCandidate}
            $ownCandidateBranch=if($index-eq0){'candidate'}else{'candidate-second'}
            $bare=Join-Path $casePath "remote-$index.git"
            $trustedRoot=Join-Path $casePath "trusted $index"
            $candidateRoot=Join-Path $casePath "candidate $index"
            [void](Invoke-DualSetupGit @('clone','--quiet','--bare','--no-local',$seed,$bare))
            [void](Invoke-DualSetupGit @('-C',$bare,'update-ref','refs/heads/orvion-preflight',$(if($operation-eq'PUBLISH'){$base}else{$ownCandidate})))
            [void](Invoke-DualSetupGit @('clone','--quiet','--no-local','-b','main',$bare,$trustedRoot))
            [void](Invoke-DualSetupGit @('clone','--quiet','--no-local','-b',$ownCandidateBranch,$bare,$candidateRoot))
            foreach($fixtureRoot in @($trustedRoot,$candidateRoot)){
                [void](Invoke-DualSetupGit @('-C',$fixtureRoot,'remote','set-url','origin',('https://github.com/'+$repository)))
                [void](Invoke-DualSetupGit @('-C',$fixtureRoot,'config','protocol.https.allow','never'))
                [void](Invoke-DualSetupGit @('-C',$fixtureRoot,'config','protocol.ssh.allow','never'))
                [void](Invoke-DualSetupGit @('-C',$fixtureRoot,'config','gc.auto','0'))
                [void](Invoke-DualSetupGit @('-C',$fixtureRoot,'config','--local','--add','credential.https://github.com.helper',''))
                [void](Invoke-DualSetupGit @('-C',$fixtureRoot,'config','--local','--add','credential.https://github.com.helper',('!gh auth token --user '+($repository-split'/')[0])))
            }
            Write-DualFixture (Join-Path $candidateRoot ".orvion-certifications\$ownCandidate.json") '{}'
            $targets+=@{Index=$index;Repository=$repository;Bare=$bare;TrustedRoot=$trustedRoot;CandidateRoot=$candidateRoot;Base=$base;Calls=(Join-Path $casePath "calls-$index.txt")}
            $descriptorTargets+=@{repository=$repository;candidateRoot=$candidateRoot;trustedRoot=$trustedRoot;candidate=$ownCandidate;base=$base}
        }
        $evidence=Join-Path $casePath 'evidence'
        switch($mode){
            'missing-party'{$descriptorTargets=@($descriptorTargets[0])}
            'wrong-repository'{$descriptorTargets[1].repository='fixture/wrong'}
            'shared-root'{$descriptorTargets[1].candidateRoot=$descriptorTargets[0].candidateRoot}
            'bad-sha'{$descriptorTargets[1].candidate='bad'}
            'stale-base'{$descriptorTargets[1].base='0'*40}
            'wrong-account'{
                [void](Invoke-DualSetupGit @('-C',$targets[1].TrustedRoot,'config','--local','--unset-all','credential.https://github.com.helper'))
                [void](Invoke-DualSetupGit @('-C',$targets[1].TrustedRoot,'config','--local','--add','credential.https://github.com.helper',''))
                [void](Invoke-DualSetupGit @('-C',$targets[1].TrustedRoot,'config','--local','--add','credential.https://github.com.helper','!gh auth token --user WrongFixtureAccount'))
            }
            'dirty-second'{Write-DualFixture (Join-Path $targets[1].TrustedRoot 'dirt.txt') 'untracked'}
            'evidence-inside'{$evidence=Join-Path $targets[0].CandidateRoot 'forbidden-evidence'}
        }
        $descriptorPath=Join-Path $casePath 'descriptor.json'
        Write-DualFixture $descriptorPath (@{schema=1;targets=$descriptorTargets}|ConvertTo-Json -Depth 5)
        if($mode-eq'duplicate-descriptor'){
            $duplicateDescriptor=[IO.File]::ReadAllText($descriptorPath).TrimEnd().TrimEnd('}')+',"schema":1}'
            Write-DualFixture $descriptorPath $duplicateDescriptor
        }
        $workbenchRoot=Join-Path $casePath 'workbench'
        $lib=Join-Path $workbenchRoot 'lib'
        foreach($name in 'Owner-PublishDual.ps1','Owner-PromoteDual.ps1','Invoke-OwnerDual.ps1','Test-OwnerDualAdmission.ps1'){
            $text=[IO.File]::ReadAllText((Join-Path $PSScriptRoot $name))
            if($name-eq'Invoke-OwnerDual.ps1'-and$mode-ne'noninteractive'){
                $start=$text.IndexOf('$interactive=');$end=$text.IndexOf('$overall=',$start)
                if($start-lt0-or$end-lt$start){throw 'CONSOLE_SEAM_ANCHOR'}
                $text=$text.Remove($start,$end-$start).Insert($start,'$interactive=!$NonInteractive'+"`n")
            }
            Write-DualFixture (Join-Path $lib $name) $text
        }
        [void](Invoke-DualSetupGit @('init','--quiet','-b','main',$workbenchRoot))
        [void](Invoke-DualSetupGit @('-C',$workbenchRoot,'config','user.name','Dual admission fixture'))
        [void](Invoke-DualSetupGit @('-C',$workbenchRoot,'config','user.email','fixture@example.invalid'))
        [void](Invoke-DualSetupGit @('-C',$workbenchRoot,'add','--','lib'))
        [void](Invoke-DualSetupGit @('-C',$workbenchRoot,'commit','--quiet','-m','Exact fixture coordinator source'))
        $authorization=@{schema=1;operation=$operation;workbenchRoot=$workbenchRoot;evidenceDirectory=$evidence;
            workbenchHead=(Invoke-DualSetupGit @('-C',$workbenchRoot,'rev-parse','HEAD')).Trim();
            workbenchConfigSha256=(Get-FileHash -LiteralPath (Join-Path $workbenchRoot '.git\config')).Hash;
            descriptorSha256=(Get-FileHash -LiteralPath $descriptorPath).Hash;
            sourceDraftSha256=('A'*64);reviewSha256=('B'*64);expiresUtc=[DateTime]::UtcNow.AddHours(1).ToString('yyyy-MM-ddTHH:mm:ssZ');
            sourceFiles=@(Get-ChildItem -LiteralPath $lib -File|ForEach-Object{@{path=('lib/'+$_.Name);sha256=(Get-FileHash -LiteralPath $_.FullName).Hash}});
            configurations=@($targets|ForEach-Object{foreach($subject in @($_.CandidateRoot,$_.TrustedRoot)){@{root=$subject;sha256=(Get-FileHash -LiteralPath (Join-Path $subject '.git\config')).Hash}}})}
        if($mode-eq'expired-approval'){$authorization.expiresUtc='2000-01-01T00:00:00Z'}
        if($mode-eq'wrong-workbench'){$authorization.workbenchHead='0'*40}
        $approvalPath=Join-Path $casePath 'operation-approval.json'
        Write-DualFixture $approvalPath ($authorization|ConvertTo-Json -Depth 6)
        if($mode-eq'duplicate-approval'){
            $duplicateApproval=[IO.File]::ReadAllText($approvalPath).TrimEnd().TrimEnd('}')+',"schema":1}'
            Write-DualFixture $approvalPath $duplicateApproval
        }
        $approvalDigest=(Get-FileHash -LiteralPath $approvalPath).Hash
        if($mode-eq'changed-approval'){Add-Content -LiteralPath $approvalPath -Value ' '}
        if($mode-eq'changed-source'){
            [void](Invoke-DualSetupGit @('-C',$workbenchRoot,'update-index','--assume-unchanged','--','lib/Invoke-OwnerDual.ps1'))
            Add-Content -LiteralPath (Join-Path $lib 'Invoke-OwnerDual.ps1') -Value '# altered'
        }
        if($mode-eq'changed-config'){[void](Invoke-DualSetupGit @('-C',$targets[1].TrustedRoot,'config','fixture.changed','true'))}
        if($mode-eq'changed-descriptor'){Add-Content -LiteralPath $descriptorPath -Value ' '}
        if($mode-eq'wrong-output'){$evidence=Join-Path $casePath 'unapproved-evidence'}
        if($mode-eq'missing-approval'){$approvalPath='';$approvalDigest=''}
        $cfg=@{Mode=$mode;Targets=$targets;GitExe=$gitExe;WorkbenchRoot=$workbenchRoot;Descriptor=$descriptorPath;Evidence=$evidence;Approval=$approvalPath;ApprovalSha256=$approvalDigest;Entry=(Join-Path $lib ('Owner-'+$(if($operation-eq'PUBLISH'){'Publish'}else{'Promote'})+'Dual.ps1'))}
        $cfgPath=Join-Path $casePath 'config.json'
        Write-DualFixture $cfgPath ($cfg|ConvertTo-Json -Depth 6)
        $lines=@(& pwsh -NoProfile -File (Join-Path $work 'driver.ps1') -Config $cfgPath 2>&1)
        $code=$LASTEXITCODE
        Write-DualFixture (Join-Path $casePath 'actual.log') ($lines-join"`n")
        $resultFiles=@(if(Test-Path -LiteralPath $evidence){Get-ChildItem -LiteralPath $evidence -Recurse -File -Filter 'result.json'})
        $result=if($resultFiles.Count-eq1){Get-Content -Raw -LiteralPath $resultFiles[0].FullName|ConvertFrom-Json}else{$null}
        $counts=@(foreach($target in $targets){if(Test-Path -LiteralPath $target.Calls){@(Get-Content -LiteralPath $target.Calls).Count}else{0}})
        $ok=if($mode-eq'success'){$code-eq0-and$result.result-ceq'DONE'-and$counts[0]-eq1-and$counts[1]-eq1}else{$code-ne0-and(!$result-or$result.result-cne'DONE')}
        if($mode-in@('noninteractive','missing-party','wrong-repository','shared-root','bad-sha','stale-base','wrong-account','dirty-second','evidence-inside','missing-approval','changed-approval','expired-approval','wrong-workbench','changed-source','changed-config','changed-descriptor','duplicate-approval','duplicate-descriptor','wrong-output')){$ok=$ok-and$counts[0]-eq0-and$counts[1]-eq0}
        if($mode-eq'first-fail'){$ok=$ok-and$counts[0]-eq1-and$counts[1]-eq0-and$result.targets[0].childExit-eq7}
        if($mode-eq'second-fail'){
            $ok=$ok-and$counts[0]-eq1-and$counts[1]-eq1-and$result.result-ceq'PARTIAL'-and$result.targets[0].result-ceq'DONE'-and$result.targets[1].childExit-eq7
            $cfg.Mode='success';Write-DualFixture $cfgPath ($cfg|ConvertTo-Json -Depth 6)
            $resume=@(& pwsh -NoProfile -File (Join-Path $work 'driver.ps1') -Config $cfgPath 2>&1);$resumeExit=$LASTEXITCODE
            Write-DualFixture (Join-Path $casePath 'resume.log') ($resume-join"`n")
            $nextFile=@(Get-ChildItem -LiteralPath $evidence -Recurse -File -Filter 'result.json'|Sort-Object FullName)[-1]
            $nextResult=Get-Content -Raw -LiteralPath $nextFile.FullName|ConvertFrom-Json
            $ok=$ok-and$resumeExit-eq0-and$nextResult.result-ceq'DONE'-and$nextResult.targets[0].result-ceq'ALREADY_DONE'-and@(Get-Content -LiteralPath $targets[0].Calls).Count-eq1-and@(Get-Content -LiteralPath $targets[1].Calls).Count-eq2
        }
        if($mode-in@('zero-no-record','malformed-record','wrong-record','wrong-ref','unreadable-after')){$ok=$ok-and$counts[0]-eq1-and$counts[1]-eq0}
        if($mode-in@('zero-no-record','malformed-record','unreadable-after')){$ok=$ok-and$result.classification-ceq'UNREADABLE'}
        if($mode-eq'wrong-ref'){$ok=$ok-and$result.classification-ceq'EXACT_REF_MISMATCH'}
        if($mode-eq'unreadable-admission'){$ok=$ok-and$counts[0]-eq0-and$counts[1]-eq0-and@($lines|Where-Object{"$_"-ceq"DUAL_${operation}: UNREADABLE"}).Count-eq1}
        if($mode-eq'evidence-inside'){$ok=$ok-and!(Test-Path -LiteralPath $evidence)}
        $records.Add([pscustomobject]@{Operation=$operation;Case=$mode;Passed=[bool]$ok;Exit=$code;Result=$result.result;Classification=$result.classification;Counts=$counts;Fixture=$casePath})
        Write-Host ("{0} {1}/{2} exit{3} {4}"-f$(if($ok){'PASS'}else{'FAIL'}),$operation,$mode,$code,$result.result)
    }
}
if(!$CaseNames){
    # Mutate the exact checker function in memory, never the selected source files or native product engines.
    $admissionSource=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Test-OwnerDualAdmission.ps1'))
    $mutationPopulation=@(
        @('changed-approval','operation approval bytes changed.'),
        @('expired-approval','operation approval expired or malformed.'),
        @('wrong-workbench','Workbench identity or clean state changed.'),
        @('changed-source','approved coordinator bytes changed.'),
        @('changed-config','reviewed local configuration changed.'),
        @('changed-descriptor','reviewed descriptor changed.'),
        @('wrong-output','output directory differs from approved scope.'),
        @('duplicate-approval','duplicate JSON member.')
    )
    foreach($mutationCase in $mutationPopulation){
        $caseRoot=Join-Path $work ('publish-'+$mutationCase[0])
        $caseConfig=Get-Content -LiteralPath (Join-Path $caseRoot 'config.json') -Raw|ConvertFrom-Json
        $checkerArguments=@{Approval=$caseConfig.Approval;ApprovalSha256=$caseConfig.ApprovalSha256;
            Descriptor=$caseConfig.Descriptor;EvidenceDirectory=$caseConfig.Evidence;Operation='PUBLISH';WorkbenchRoot=$caseConfig.WorkbenchRoot}
        . ([scriptblock]::Create($admissionSource))
        $baselineRejected=$false
        try{Assert-OwnerDualAdmission @checkerArguments|Out-Null}catch{$baselineRejected=$_.Exception.Message.Contains($mutationCase[1])}
        $needle="throw 'ADMISSION_REFUSED: $($mutationCase[1])'"
        if([regex]::Matches($admissionSource,[regex]::Escape($needle)).Count-ne1){throw 'ADMISSION_MUTATION_ANCHOR'}
        . ([scriptblock]::Create($admissionSource.Replace($needle,'$null')))
        $mutantAccepted=$false
        try{Assert-OwnerDualAdmission @checkerArguments|Out-Null;$mutantAccepted=$true}catch{$null=$_}
        . ([scriptblock]::Create($admissionSource))
        $mutationPassed=$baselineRejected-and$mutantAccepted
        $records.Add([pscustomobject]@{Operation='ADMISSION';Case=('MUTATION/'+$mutationCase[0]);Passed=$mutationPassed;Exit=[int](!$mutationPassed);Result='Exact checker function boundary';Classification='CAUSAL_GUARD_REMOVAL';Counts=@();Fixture=$caseRoot})
        Write-Host "$(if($mutationPassed){'PASS'}else{'FAIL'}) ADMISSION MUTATION $($mutationCase[0]): baselineRejected=$baselineRejected mutantAccepted=$mutantAccepted"
    }
}
if(!$records.Count){throw 'EMPTY_DUAL_TEST_POPULATION'}
$failed=@($records|Where-Object{!$_.Passed}).Count
$record=@{Passed=$records.Count-$failed;Failed=$failed;Cases=$records;RecordedUtc=[DateTime]::UtcNow.ToString('o');DistinctCandidates=($candidate-cne$secondCandidate);CandidateSubjects=@($candidate,$secondCandidate);SourceSha256=(Get-FileHash -LiteralPath (Join-Path $PSScriptRoot 'Test-OwnerDualAdmission.ps1')).Hash;
    Sources=@(foreach($sourceName in 'Owner-PublishDual.ps1','Owner-PromoteDual.ps1','Invoke-OwnerDual.ps1','Test-OwnerDualAdmission.ps1','test-owner-dual.ps1'){@{Path=('lib/'+$sourceName);Sha256=(Get-FileHash -LiteralPath (Join-Path $PSScriptRoot $sourceName)).Hash}});
    Boundary='Actual dual entrypoints/core on real Git and child fixtures; exact checker mutations are function-boundary evidence. Console/transport seams and stub own interfaces do not prove product admission, actor identity or live release.'}
$resultPath=Join-Path ([IO.Path]::GetTempPath()) ('orvion-dual-result-'+[guid]::NewGuid().ToString('N')+'.json')
if($EvidenceDirectory){[void][IO.Directory]::CreateDirectory($EvidenceDirectory);$resultPath=Join-Path $EvidenceDirectory ('dual-'+[guid]::NewGuid().ToString('N')+'.json')}
[IO.File]::WriteAllText($resultPath,($record|ConvertTo-Json -Depth 7)+"`n")
"DUAL TESTS: $($records.Count-$failed) passed, $failed failed; result=$resultPath"
if(!$failed-and!$EvidenceDirectory){
    $resolved=[IO.Path]::GetFullPath($work);$parent=[IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\','/')
    if((Split-Path $resolved -Parent)-ine$parent-or(Split-Path $resolved -Leaf)-notmatch'^orvion-dual-[0-9a-f]{32}$'){throw 'FIXTURE_CLEANUP_BOUNDARY'}
    Remove-Item -LiteralPath $resolved -Recurse -Force -ErrorAction Stop
}else{"retained fixture root: $work"}
exit [int]($failed-gt0)
