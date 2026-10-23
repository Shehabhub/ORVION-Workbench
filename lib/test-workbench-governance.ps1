# Real local Git/caller fixtures. Synthetic owner assertions and short test children are NOT live approval or full-suite certification.
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'Test-WorkbenchChange.ps1')
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
. (Join-Path $PSScriptRoot 'Invoke-DraftSteps.ps1')
$testParent=if($env:WORKBENCH_TEST_ROOT){[IO.Path]::GetFullPath($env:WORKBENCH_TEST_ROOT)}else{Join-Path ([IO.Path]::GetTempPath()) 'ORVION-Workbench/tests'}
[void][IO.Directory]::CreateDirectory($testParent)
$ownedRoot=Join-Path $testParent ('orvion-wb-governance-'+[guid]::NewGuid().ToString('N'))
[void][IO.Directory]::CreateDirectory($ownedRoot)
$observations=[Collections.Generic.List[object]]::new()
$failures=0
$caseNumber=0
function Write-FixtureFile([string]$file,[string]$text) {
    [void][IO.Directory]::CreateDirectory((Split-Path $file -Parent))
    [IO.File]::WriteAllText($file,$text,[Text.UTF8Encoding]::new($false))
}
function Invoke-FixtureGit([string]$checkout,[string[]]$Arguments,[switch]$AllowFailure) {
    $lines=@(& git -C $checkout @Arguments 2>&1);$exitValue=$LASTEXITCODE
    $row=[pscustomobject]@{Kind='git';Root=$checkout;Arguments=$Arguments;Exit=$exitValue;Output=@($lines|ForEach-Object{"$_"})}
    $observations.Add($row)
    if($exitValue-ne0-and!$AllowFailure){throw "FIXTURE_GIT_FAILED:$($Arguments-join' '):$($lines-join' ')"}
    $row
}
function Invoke-FixtureChecker([string]$checkout,[string[]]$Arguments) {
    $lines=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Test-WorkbenchChange.ps1') -Root $checkout @Arguments 2>&1)
    $row=[pscustomobject]@{Kind='checker';Root=$checkout;Arguments=$Arguments;Exit=$LASTEXITCODE;Output=@($lines|ForEach-Object{"$_"})}
    $observations.Add($row);$row
}
function Assert-Fixture([string]$Name,[bool]$Condition,$Detail=$null) {
    if($Condition){"PASS $Name"}else{$script:failures++;"FAIL $Name $($Detail|ConvertTo-Json -Compress -Depth 4)"}
}
function Copy-Fixture([string]$From,[string]$Name) {
    $destination=Join-Path $ownedRoot $Name
    $null=Invoke-FixtureGit $ownedRoot @('clone','--quiet','--no-local',$From,$destination)
    foreach($setting in @(@('core.hooksPath','.githooks'),@('core.autocrlf','true'),@('gc.auto','0'),@('maintenance.auto','false'),@('user.name','Fixture'),@('user.email','fixture@invalid.local'))){$null=Invoke-FixtureGit $destination @('config','--local',$setting[0],$setting[1])}
    $null=Invoke-FixtureGit $destination @('remote','set-url','--push','origin','DISABLED')
    $destination
}
function Save-FixtureCommit([string]$checkout,[string[]]$paths,[string]$Message,[switch]$AllowFailure) {
    $null=Invoke-FixtureGit $checkout (@('add','--')+$paths)
    Invoke-FixtureGit $checkout @('commit','--quiet','-m',$Message) -AllowFailure:$AllowFailure
}
function Set-FixtureStatus([string]$checkout,[string]$State) {
    $file=Join-Path $checkout 'changes/WS-001-fixture.md'
    $text=[IO.File]::ReadAllText($file)-replace'\r\n',([string][char]10)
    $text=[regex]::Replace($text,'(?m)^\[x\] (Draft|Approved|In Progress|Complete|Cancelled)$','[ ] $1')
    $text=$text.Replace('[ ] '+$State,'[x] '+$State)
    Write-FixtureFile $file $text
}
function Approve-FixtureCheckout([string]$checkout,[switch]$AllowFailure) {
    Set-FixtureStatus $checkout 'Approved'
    $ownerFile=Join-Path $evidence ('owner-'+[guid]::NewGuid().ToString('N')+'.txt')
    Write-FixtureFile $ownerFile ("SYNTHETIC FIXTURE ONLY: approve exact Draft $draftDigest for execution root $checkout")
    $ownerDigest=(Get-FileHash -LiteralPath $ownerFile).Hash
    $file=Join-Path $checkout 'changes/WS-001-fixture.md'
    $approved=[IO.File]::ReadAllText($file).Replace('## Verification Notes',("Approved Draft: $v3"+[char]10+"Approved SHA256: $draftDigest"+[char]10+"Owner Evidence: $ownerFile"+[char]10+"Owner Evidence SHA256: $ownerDigest"+[char]10+"Execution Root: $checkout"+[char]10+[char]10+'## Verification Notes'))
    Write-FixtureFile $file $approved
    Write-FixtureFile (Join-Path $checkout 'RESUME.md') ('# Fixture'+[char]10+'Active Workbench Contract: changes/WS-001-fixture.md'+[char]10)
    Save-FixtureCommit $checkout @('changes/WS-001-fixture.md','RESUME.md') 'Fixture exact root-bound approval' -AllowFailure:$AllowFailure
}
function New-ApprovedFixture([string]$Name) {
    $checkout=Copy-Fixture $draftSnapshot $Name
    $null=Approve-FixtureCheckout $checkout
    $checkout
}
function Start-FixtureChild([string[]]$Arguments,[string]$Directory) {
    $info=[Diagnostics.ProcessStartInfo]::new((Get-Command pwsh -CommandType Application|Select-Object -First 1).Source)
    $info.UseShellExecute=$false;$info.CreateNoWindow=$true;$info.RedirectStandardOutput=$true;$info.RedirectStandardError=$true
    $info.WorkingDirectory=$Directory
    foreach($argument in $Arguments){$info.ArgumentList.Add($argument)}
    $process=[Diagnostics.Process]::new();$process.StartInfo=$info;$null=$process.Start()
    [pscustomobject]@{Process=$process;Out=$process.StandardOutput.ReadToEndAsync();Err=$process.StandardError.ReadToEndAsync()}
}
function Receive-FixtureChild($child) {
    try{
        if(!$child.Process.WaitForExit(60000)){$child.Process.Kill($true);throw 'OWNED_FIXTURE_CHILD_TIMEOUT'}
        [pscustomobject]@{Exit=$child.Process.ExitCode;Output=$child.Out.GetAwaiter().GetResult()+$child.Err.GetAwaiter().GetResult()}
    }finally{$child.Process.Dispose()}
}
function Invoke-FixtureFinish([string]$checkout,[string]$Label) {
    $log=Join-Path $ownedRoot ($Label+'.log')
    $entryPath=Join-Path $checkout 'lib/Workbench.ps1'
    $command="& '"+$entryPath.Replace("'","''")+"' -Root '"+$checkout.Replace("'","''")+"' -Finish"
    $runner=Start-FixtureChild @('-NoProfile','-File',(Join-Path $checkout 'lib/run_timed.ps1'),'-Log',$log,'-WorkingDirectory',$checkout,'-Command',$command) $checkout
    $observer=Start-FixtureChild @('-NoProfile','-File',(Join-Path $checkout 'lib/watch_run.ps1'),'-Log',$log,'-Run',$Label,'-Brief','-PollSeconds','0.1','-QuietMinutes','5','-Csv',(Join-Path $ownedRoot ($Label+'.csv'))) $checkout
    $runnerResult=Receive-FixtureChild $runner
    $watchResult=Receive-FixtureChild $observer
    $raw=[IO.File]::ReadAllText($log)
    $row=[pscustomobject]@{Kind='actual-fixture-run';Root=$checkout;Log=$log;Runner=$runnerResult;Watcher=$watchResult;Output=$raw}
    $observations.Add($row);$row
}
function Test-DuplicateSnapshotFixture {
    $checkout=Copy-Fixture $draftSnapshot 'duplicate-assurance'
    $oldSelected=$v3
    $v3=Join-Path $evidence 'duplicate-selected.md'
    $file=Join-Path $checkout 'changes/WS-001-fixture.md'
    $changed=[IO.File]::ReadAllText($file).Replace($oldSelected,$v3).Replace('V2: fixture-adversarial','V2: fixture-design')
    Write-FixtureFile $file $changed;Write-FixtureFile $v3 $changed
    $draftDigest=(Get-FileHash -LiteralPath $v3).Hash
    $null=Save-FixtureCommit $checkout @('changes/WS-001-fixture.md') 'Fixture unapproved duplicate assurance proposal'
    $refusal=Approve-FixtureCheckout $checkout -AllowFailure
    Assert-Fixture 'actual approval hook rejects duplicated pass identities' ($refusal.Exit-ne0-and($refusal.Output-join' ')-match'WB_THREE_PASS_IDENTITY_DUPLICATED') $refusal
}
function Test-AuthorizedCheckerFixture {
    $checkout=Copy-Fixture $draftSnapshot 'authorized-checker-change'
    $oldSelected=$v3;$v3=Join-Path $evidence 'authorized-checker-selected.md'
    $newChecker=[IO.File]::ReadAllText((Join-Path $checkout 'lib/Test-WorkbenchChange.ps1'))+[char]10+'# An explicitly approved non-semantic fixture change.'+[char]10
    $proposal=Join-Path $evidence 'checker-proposal.ps1';Write-FixtureFile $proposal $newChecker
    $pin=(Invoke-FixtureGit $checkout @('hash-object','--path=lib/Test-WorkbenchChange.ps1','--',$proposal)).Output[0]
    $file=Join-Path $checkout 'changes/WS-001-fixture.md'
    $changed=[IO.File]::ReadAllText($file).Replace($oldSelected,$v3).Replace('- [ ] Feature has the expected reviewed content.',('- [ ] Explicit checker bytes; check: blob:lib/Test-WorkbenchChange.ps1='+$pin))
    Write-FixtureFile $file $changed;Write-FixtureFile $v3 $changed
    $draftDigest=(Get-FileHash -LiteralPath $v3).Hash
    $null=Save-FixtureCommit $checkout @('changes/WS-001-fixture.md') 'Fixture unapproved exact checker proposal'
    $null=Approve-FixtureCheckout $checkout
    Set-FixtureStatus $checkout 'In Progress';Write-FixtureFile (Join-Path $checkout 'lib/Test-WorkbenchChange.ps1') $newChecker
    $accepted=Save-FixtureCommit $checkout @('changes/WS-001-fixture.md','lib/Test-WorkbenchChange.ps1') 'Fixture authorized checker update'
    Assert-Fixture 'accepted checker admits an explicitly approved exact successor' ($accepted.Exit-eq0) $accepted
    Write-FixtureFile (Join-Path $checkout 'lib/Test-WorkbenchChange.ps1') 'exit 0'
    $null=Invoke-FixtureGit $checkout @('add','lib/Test-WorkbenchChange.ps1')
    $refused=Invoke-FixtureChecker $checkout @('-Mode','Gate','-Staged')
    Assert-Fixture 'another body cannot substitute for the approved checker blob' ($refused.Exit-ne0-and($refused.Output-join' ')-match'WB_UNAPPROVED_CONTROL_BYTES') $refused
}
function Invoke-FixtureWatch([string]$watcher,[string]$Label) {
    $log=Join-Path $ownedRoot ($Label+'.log')
    $lines=@(('['+(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+"] START pid=$PID host=fixture | bounded completed replay"),
        '[+   0.001 min] PASS 1 mentioning UNREADABLE is test progress',
        '[+   0.002 min] TOOL: UNREADABLE',
        '[+   0.003 min] PUBLISH: REFUSED',
        '[+   0.004 min] END exit=1 total=0.0 min concurrent_end=0')
    [IO.File]::WriteAllLines($log,$lines,[Text.UTF8Encoding]::new($false))
    $child=Start-FixtureChild @('-NoProfile','-File',$watcher,'-Log',$log,'-Run',$Label,'-Brief','-PollSeconds','0.1','-QuietMinutes','5','-Csv',(Join-Path $ownedRoot ($Label+'.csv'))) $ownedRoot
    $result=Receive-FixtureChild $child
    $observations.Add([pscustomobject]@{Kind='watcher-replay';Log=$log;Watcher=$watcher;Exit=$result.Exit;Output=$result.Output})
    $result
}
function Test-ExecuteFixture {
    $checkout=Copy-Fixture $draftSnapshot 'actual-execute'
    $file=Join-Path $checkout 'feature.txt';$beforeBytes=[IO.File]::ReadAllBytes($file)
    try{Write-FixtureFile $file ('after'+[char]10);$step=Get-DraftFileStep $checkout 'feature.txt' 'after' 'isolated literal execution fixture'}
    finally{[IO.File]::WriteAllBytes($file,$beforeBytes)}
    $oldSelected=$v3;$v3=Join-Path $evidence 'execute-selected.md'
    $contractFile=Join-Path $checkout 'changes/WS-001-fixture.md'
    $body=[IO.File]::ReadAllText($contractFile).Replace($oldSelected,$v3)
    $body=Set-WorkbenchSection $body 'Implementation Steps' ('1. '+$step.Text)
    Write-FixtureFile $contractFile $body;Write-FixtureFile $v3 $body
    $fixturePlanLines=@(& pwsh -NoProfile -File (Join-Path $checkout 'lib/apply-draft-steps.ps1') -Draft $v3 -Root $checkout -Plan 2>&1)
    $fixturePlanExit=$LASTEXITCODE
    $fixturePlanValue=if($fixturePlanExit-eq0){($fixturePlanLines-join[char]10)|ConvertFrom-Json}else{$null}
    Assert-Fixture 'literal fixture uses the existing replay grammar before approval or writes' ($fixturePlanExit-eq0-and$fixturePlanValue.Files.Count-eq1-and$fixturePlanValue.Files[0].File-ceq'feature.txt'-and[Convert]::ToBase64String([IO.File]::ReadAllBytes($file))-ceq[Convert]::ToBase64String($beforeBytes)) $fixturePlanLines
    if($fixturePlanExit-ne0){throw 'FIXTURE_LITERAL_PLAN_PRECHECK_FAILED'}
    $draftDigest=(Get-FileHash -LiteralPath $v3).Hash
    $null=Save-FixtureCommit $checkout @('changes/WS-001-fixture.md') 'Fixture literal execution Draft'
    $null=Approve-FixtureCheckout $checkout
    Set-FixtureStatus $checkout 'In Progress'
    $null=Save-FixtureCommit $checkout @('changes/WS-001-fixture.md') 'Fixture begin literal execution'
    $entryPath=Join-Path $checkout 'lib/Workbench.ps1'
    $outputLines=@(& pwsh -NoProfile -File $entryPath -Root $checkout -Execute 2>&1);$exitValue=$LASTEXITCODE
    $executeBlob=(Invoke-FixtureGit $checkout @('hash-object','--path=feature.txt','--',$file)).Output[0]
    Assert-Fixture 'actual Execute uses accepted Plan and applier for an in-scope first write' ($exitValue-eq0-and$executeBlob-ceq$step.Blob-and($outputLines-join' ')-match'WORKBENCH_EXECUTE: DONE') $outputLines
    $null=Save-FixtureCommit $checkout @('feature.txt') 'Fixture literal implementation commit'
    $writeAt=(Get-Item -LiteralPath $file).LastWriteTimeUtc.Ticks
    $outputLines=@(& pwsh -NoProfile -File $entryPath -Root $checkout -Execute 2>&1);$exitValue=$LASTEXITCODE
    Assert-Fixture 'actual Execute resumes Already Applied without rewriting the selected file' ($exitValue-eq0-and($outputLines-join' ')-match'ALREADY_APPLIED: feature.txt'-and(Get-Item -LiteralPath $file).LastWriteTimeUtc.Ticks-eq$writeAt) $outputLines
}
try {
    $seed=Join-Path $ownedRoot 'seed';[void][IO.Directory]::CreateDirectory($seed)
    $null=Invoke-FixtureGit $seed @('init','--quiet')
    foreach($setting in @(@('user.name','Fixture'),@('user.email','fixture@invalid.local'),@('core.hooksPath','.git/hooks'),@('core.autocrlf','true'),@('gc.auto','0'),@('maintenance.auto','false'))){$null=Invoke-FixtureGit $seed @('config','--local',$setting[0],$setting[1])}
    foreach($relative in 'lib/Test-WorkbenchChange.ps1','lib/Workbench.ps1','lib/run_timed.ps1','lib/watch_run.ps1','lib/apply-draft-steps.ps1','lib/Invoke-DraftSteps.ps1','.githooks/pre-commit'){
        $source=Join-Path (Split-Path $PSScriptRoot -Parent) $relative
        Write-FixtureFile (Join-Path $seed $relative) ([IO.File]::ReadAllText($source))
    }
    Write-FixtureFile (Join-Path $seed 'RESUME.md') ('# Fixture'+[char]10+'Active Workbench Contract: None'+[char]10)
    Write-FixtureFile (Join-Path $seed 'WORKFLOW.md') ('# Fixture local authority'+[char]10)
    Write-FixtureFile (Join-Path $seed '.gitignore') ('work/'+[char]10+'.workbench-local-certification.json'+[char]10+'.workbench-certifications/'+[char]10)
    Write-FixtureFile (Join-Path $seed 'feature.txt') ('before'+[char]10)
    $shortTests=@'
$ErrorActionPreference='Stop'
$counter=Join-Path $PSScriptRoot 'work/count.txt'
[void][IO.Directory]::CreateDirectory((Split-Path $counter -Parent))
$count=if(Test-Path -LiteralPath $counter){[int][IO.File]::ReadAllText($counter)}else{0}
[IO.File]::WriteAllText($counter,[string]($count+1))
if(Test-Path -LiteralPath (Join-Path $PSScriptRoot 'work/fail')){exit 7}
'PASS synthetic fixture child (dispatch proof only)'
exit 0
'@
    Write-FixtureFile (Join-Path $seed 'tests.ps1') ($shortTests+[char]10)
    $null=Invoke-FixtureGit $seed @('add','.')
    $null=Invoke-FixtureGit $seed @('commit','--quiet','-m','Synthetic accepted checker seed; fixture trust assumption only')
    $baseline=(Invoke-FixtureGit $seed @('rev-parse','HEAD')).Output[0]
    $draftRoot=Copy-Fixture $seed 'draft'
    $evidence=Join-Path $ownedRoot 'assurance';[void][IO.Directory]::CreateDirectory($evidence)
    $v1=Join-Path $evidence 'V1.md';$v2=Join-Path $evidence 'V2.md';$v3=Join-Path $evidence 'V3.md';$ownerFile=Join-Path $evidence 'owner.txt'
    Write-FixtureFile $v1 'V1 fixture design; no live authority.'
    Write-FixtureFile $v2 'V2 fixture adversarial review; no live authority.'
    $sha1=(Get-FileHash -LiteralPath $v1).Hash;$sha2=(Get-FileHash -LiteralPath $v2).Hash
    $date=[DateTime]::UtcNow.ToString('yyyy-MM-dd')
    $text=@"
# Workbench Change Request - WS-001

## Status
[x] Draft
[ ] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective
Change one synthetic feature — retain UTF-8 authority and native admission.

## Baseline
$baseline

## Write Scope
- RESUME.md
- feature.txt
- lib/Test-WorkbenchChange.ps1
- .githooks/pre-commit

## Out of Scope
Every other engineering path and all real roots.

## Draft Assurance
V1: fixture-design | $date | $v1 | $sha1
V2: fixture-adversarial | $date | $v2 | $sha2
V3: fixture-refresh | $date | $v3 | SELECTED
Selected Version: V3

## Implementation Steps
Change feature.txt only. Checker/hook scope permits causal mutation tests but no unpinned control edits.

## Acceptance Criteria
- [ ] Feature has the expected reviewed content.

## Review Gate
- [ ] Actual fixture runner and watcher results checked.

## Runtime Checkpoint
Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log
Fixture only; no production approval.

## Verification Notes
Fixture only.
"@+[char]10
    Write-FixtureFile $v3 $text
    $draftDigest=(Get-FileHash -LiteralPath $v3).Hash
    Write-FixtureFile $ownerFile ("SYNTHETIC FIXTURE ONLY: approve exact Draft $draftDigest")
    $contract=Join-Path $draftRoot 'changes/WS-001-fixture.md';Write-FixtureFile $contract $text
    $draftCommit=Save-FixtureCommit $draftRoot @('changes/WS-001-fixture.md') 'Fixture Draft'
    $draftSnapshot=Copy-Fixture $draftRoot 'unapproved-seed'
    Assert-Fixture 'actual hook admits a Draft allocation' ($draftCommit.Exit-eq0)
    $core=Invoke-FixtureChecker $seed @('-Mode','Boot')
    Assert-Fixture 'CORE Boot has no product dependency or remote' ($core.Exit-eq0-and($core.Output-join' ')-match'MODE: PLAN') $core

    $bad=Copy-Fixture $draftRoot 'draft-implementation'
    Write-FixtureFile (Join-Path $bad 'feature.txt') 'unapproved'
    $blocked=Save-FixtureCommit $bad @('feature.txt') 'Forbidden Draft implementation' -AllowFailure
    Assert-Fixture 'actual hook rejects implementation without an active approved contract' ($blocked.Exit-ne0-and($blocked.Output-join' ')-match'WB_GOVERNING_CONTRACT_MISSING_OR_AMBIGUOUS|WB_DRAFT_IMPLEMENTATION_REFUSED') $blocked

    $approvalCommit=Approve-FixtureCheckout $draftRoot
    Assert-Fixture 'actual hook checks exact approval and three snapshot identities' ($approvalCommit.Exit-eq0) $approvalCommit
    $approvedHead=(Invoke-FixtureGit $draftRoot @('rev-parse','HEAD')).Output[0]
    $wrongRoot=Copy-Fixture $draftRoot 'wrong-root-record'
    $wrongRootRead=Invoke-FixtureChecker $wrongRoot @('-Mode','Boot')
    Assert-Fixture 'an approved record copied to another root grants no write authority' ($wrongRootRead.Exit-ne0-and($wrongRootRead.Output-join' ')-match'WB_APPROVAL_ROOT_MISMATCH') $wrongRootRead

    foreach($scenario in 'scope','frozen','index','checker','hook','complete','cancel','credential','local-data'){
        $script:caseNumber++;$bad=New-ApprovedFixture ("negative-$scenario")
        $approvedHead=(Invoke-FixtureGit $bad @('rev-parse','HEAD')).Output[0]
        $paths=@('changes/WS-001-fixture.md')
        switch($scenario){
            scope{Write-FixtureFile (Join-Path $bad 'outside.txt') 'outside';$paths=@('outside.txt');$expected='WB_WRITE_SCOPE_REFUSED'}
            frozen{$file=Join-Path $bad 'changes/WS-001-fixture.md';Write-FixtureFile $file ([IO.File]::ReadAllText($file).Replace('Change one synthetic feature','Widen the approved objective'));$expected='WB_FROZEN_AUTHORITY_CHANGED'}
            index{Write-FixtureFile (Join-Path $bad 'feature.txt') 'staged';$null=Invoke-FixtureGit $bad @('add','feature.txt');Write-FixtureFile (Join-Path $bad 'feature.txt') 'different working bytes';$paths=@();$expected='WB_WORKING_INDEX_MISMATCH'}
            checker{Write-FixtureFile (Join-Path $bad 'lib/Test-WorkbenchChange.ps1') 'exit 0';$paths=@('lib/Test-WorkbenchChange.ps1');$expected='WB_CONTROL_PIN_REQUIRED'}
            hook{Write-FixtureFile (Join-Path $bad '.githooks/pre-commit') ('#!/bin/sh'+[char]10+'exit 0'+[char]10);$paths=@('.githooks/pre-commit');$expected='WB_CONTROL_PIN_REQUIRED'}
            complete{Set-FixtureStatus $bad 'Complete';Write-FixtureFile (Join-Path $bad 'RESUME.md') ('# Fixture'+[char]10+'Active Workbench Contract: None'+[char]10);$paths+=@('RESUME.md');$expected='WB_ILLEGAL_TRANSITION'}
            cancel{Set-FixtureStatus $bad 'Cancelled';Write-FixtureFile (Join-Path $bad 'RESUME.md') ('# Fixture'+[char]10+'Active Workbench Contract: None'+[char]10);Write-FixtureFile (Join-Path $bad 'feature.txt') 'concealed during cancel';$paths+=@('RESUME.md','feature.txt');$expected='WB_TERMINAL_IMPLEMENTATION_REFUSED'}
            credential{Write-FixtureFile (Join-Path $bad 'feature.txt') ('ghp_'+('Q'*36));$paths=@('feature.txt');$expected='WB_CREDENTIAL_SHAPED_CONTENT_REFUSED'}
            local-data{Write-FixtureFile (Join-Path $bad 'work/private.txt') 'synthetic protected local history';$null=Invoke-FixtureGit $bad @('add','-f','work/private.txt');$paths=@();$expected='WB_LOCAL_DATA_REFUSED'}
        }
        if($paths.Count){$null=Invoke-FixtureGit $bad (@('add','--')+$paths)}
        # Direct accepted checker is the separate trust door, even when a candidate disables its working hook.
        $rejected=Invoke-FixtureChecker $bad @('-Mode','Gate','-Staged')
        Assert-Fixture ("causal $scenario refusal") ($rejected.Exit-ne0-and($rejected.Output-join' ')-match$expected) $rejected
        $unchanged=(Invoke-FixtureGit $bad @('rev-parse','HEAD')).Output[0]
        Assert-Fixture ("$scenario leaves accepted HEAD unchanged") ($unchanged-ceq$approvedHead)
    }
    $missing=New-ApprovedFixture 'artifact-change'
    $saved=[IO.File]::ReadAllText($v2)
    try{Write-FixtureFile $v2 'changed';$negative=Invoke-FixtureChecker $missing @('-Mode','Gate','-Staged');Assert-Fixture 'changed immutable V2 refuses' ($negative.Exit-ne0-and($negative.Output-join' ')-match'WB_ARTIFACT_CHANGED') $negative}
    finally{Write-FixtureFile $v2 $saved}
    Test-DuplicateSnapshotFixture
    Test-AuthorizedCheckerFixture
    Test-ExecuteFixture

    $brokenRoot=Invoke-FixtureChecker $ownedRoot @('-Mode','Boot')
    Assert-Fixture 'failed Git read is BLOCKED, never clean/READY' ($brokenRoot.Exit-ne0-and($brokenRoot.Output-join' ')-match'WB_ENTRY_GIT_UNREADABLE|WB_GIT_UNREADABLE'-and($brokenRoot.Output-join' ')-notmatch'WORKBENCH: READY') $brokenRoot
    $singleStatus=$text.Replace('[ ] Approved','[x] Approved')
    $statusRefused=$false;try{$null=Get-WorkbenchFields $singleStatus}catch{$statusRefused=$_.Exception.Message-eq'WB_STATUS_INVALID'}
    Assert-Fixture 'two official statuses refuse' $statusRefused
    $nested=$text.Replace('Change feature.txt only. Checker/hook scope permits causal mutation tests but no unpinned control edits.',('   [x] In Progress'+[char]10+'   [ ] Complete'+[char]10+'   ## Status'+[char]10+'   Resume Step: 1'))
    $nestedBefore=Get-WorkbenchFields $nested
    $nestedAfter=Set-WorkbenchSection $nested 'Status' $nestedBefore.Sections.Status.Replace('[x] Draft','[ ] Draft').Replace('[ ] Approved','[x] Approved')
    Assert-Fixture 'section mutation never rewrites contract-like strings inside literal payloads' ((Get-WorkbenchFrozen (Get-WorkbenchFields $nestedAfter))-ceq(Get-WorkbenchFrozen $nestedBefore))
    $duplicateStatus=$text.Replace('[ ] Cancelled','[ ] Draft')
    $duplicateRefused=$false;try{$null=Get-WorkbenchFields $duplicateStatus}catch{$duplicateRefused=$_.Exception.Message-eq'WB_STATUS_INVALID'}
    Assert-Fixture 'duplicated status options refuse' $duplicateRefused
    Assert-Fixture 'profiles derive CONTROL and REPOSITORY from governing scope' ((@(Get-WorkbenchProfiles @('RESUME.md','feature.txt'))-join',')-ceq'CONTROL,REPOSITORY')
    $fakeRecord=[pscustomobject]@{Sections=@{'Acceptance Criteria'='- [ ] unknown mandatory check: shell:exit 0'}}
    $unknownRefused=$false;try{$null=@(Get-WorkbenchBlobChecks $fakeRecord @('feature.txt'))}catch{$unknownRefused=$_.Exception.Message-eq'WB_CHECK_CLAUSE_INVALID_OR_UNSUPPORTED'}
    Assert-Fixture 'unknown machine-check vocabulary refuses instead of silently disappearing' $unknownRefused
    $resumeDigest=Get-WorkbenchResumeDigest ('# route'+[char]10+'Active Workbench Contract: None'+[char]10)
    $activeDigest=Get-WorkbenchResumeDigest ('# route'+[char]10+'Active Workbench Contract: changes/WS-001-fixture.md'+[char]10)
    Assert-Fixture 'only the lifecycle pointer is normalized in routing evidence' ($resumeDigest-ceq$activeDigest-and$resumeDigest-cne(Get-WorkbenchResumeDigest ('# altered route'+[char]10+'Active Workbench Contract: None'+[char]10)))
    $unicodeRecord=[pscustomobject]@{Sections=@{'Write Scope'='- tools/new file Ω.txt'}}
    Assert-Fixture 'governed scope preserves the existing Unicode and space path capability' ((@(Get-WorkbenchScope $unicodeRecord))[0]-ceq'tools/new file Ω.txt')

    $valid=New-ApprovedFixture 'lifecycle'
    Set-FixtureStatus $valid 'In Progress';Write-FixtureFile (Join-Path $valid 'feature.txt') ('after'+[char]10)
    $execution=Save-FixtureCommit $valid @('changes/WS-001-fixture.md','feature.txt') 'Fixture execution'
    Assert-Fixture 'own actual hook admits in-scope execution' ($execution.Exit-eq0) $execution
    $entry=Join-Path $valid 'lib/Workbench.ps1'
    $noTiming=@(& pwsh -NoProfile -File $entry -Root $valid -Finish 2>&1);$noTimingExit=$LASTEXITCODE
    Assert-Fixture 'Finish refuses a direct untimed start' ($noTimingExit-ne0-and($noTiming-join' ')-match'WB_FINISH_NOT_TIMED') $noTiming
    Assert-Fixture 'the hook never ran the fixture test child' (!(Test-Path -LiteralPath (Join-Path $valid 'work/count.txt')))
    $lease=[IO.File]::Open((Join-Path $valid '.git/workbench-operation.lock'),[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)
    try{$busy=Invoke-FixtureChecker $valid @('-Mode','Gate','-Staged');Assert-Fixture 'same-root admission refuses while another operation holds the lease' ($busy.Exit-ne0-and($busy.Output-join' ')-match'WB_OPERATION_IN_PROGRESS_OR_UNREADABLE') $busy}
    finally{$lease.Dispose()}
    $free=Invoke-FixtureChecker $valid @('-Mode','Gate','-Staged')
    Assert-Fixture 'an abandoned empty lease file does not block a new lawful operation' ($free.Exit-eq0) $free
    Write-FixtureFile (Join-Path $valid '.workbench-local-certification.json') 'stale working receipt'
    Write-FixtureFile (Join-Path $valid 'work/fail') 'fail the synthetic child deliberately'
    $failedRun=Invoke-FixtureFinish $valid 'wb-fixture-failed'
    Assert-Fixture 'failed actual timed fixture Finish preserves the child failure' ($failedRun.Runner.Exit-ne0-and$failedRun.Output-match'WB_REQUIRED_TESTS_FAILED:exit=7') $failedRun
    Assert-Fixture 'failed Finish retires the prior working receipt' (!(Test-Path -LiteralPath (Join-Path $valid '.workbench-local-certification.json')))
    Assert-Fixture 'simultaneous actual watcher also reports a failed run' ($failedRun.Watcher.Exit-ne0) $failedRun.Watcher
    [IO.File]::Delete((Join-Path $valid 'work/fail'))
    $successfulRun=Invoke-FixtureFinish $valid 'wb-fixture-success'
    Assert-Fixture 'successful actual timed fixture Finish emits a fresh receipt' ($successfulRun.Runner.Exit-eq0-and$successfulRun.Output-match'WORKBENCH_LOCAL_CERTIFY: READY') $successfulRun
    Assert-Fixture 'simultaneous actual watcher observes successful END' ($successfulRun.Watcher.Exit-eq0-and$successfulRun.Output-match'END exit=0 ') $successfulRun.Watcher
    $receipt=Read-WorkbenchReceipt $valid
    Assert-Fixture 'fresh receipt binds its own root and exact implementation' ($receipt.root-ieq$valid-and$receipt.fingerprint-ceq(Get-WorkbenchFingerprint $valid 'HEAD' 'changes/WS-001-fixture.md'))
    $file=Join-Path $valid 'changes/WS-001-fixture.md'
    $reviewText=[IO.File]::ReadAllText($file)-replace'\r\n',([string][char]10)
    $reviewText=$reviewText.Replace('- [ ] ','- [x] ').Replace('Resume Step: 1','Resume Step: DONE')
    $reviewText+=[char]10+'Verdict: Confirmed Complete'+[char]10+'Reviewed Fingerprint: '+$receipt.fingerprint+[char]10+'Reviewed Receipt: '+$receipt.digest+[char]10
    Write-FixtureFile $file $reviewText
    $null=Save-FixtureCommit $valid @('changes/WS-001-fixture.md') 'Fixture truthful live Review'
    $reviewOutput=@(& pwsh -NoProfile -File $entry -Root $valid -Review 2>&1);$reviewExit=$LASTEXITCODE
    Assert-Fixture 'actual Review entry validates current receipt and run' ($reviewExit-eq0-and($reviewOutput-join' ')-match'WORKBENCH_REVIEW: READY') $reviewOutput
    $completeOutput=@(& pwsh -NoProfile -File $entry -Root $valid -Complete 2>&1);$completeExit=$LASTEXITCODE
    Assert-Fixture 'actual Complete entry prepares only legal lifecycle metadata' ($completeExit-eq0-and($completeOutput-join' ')-match'WORKBENCH_COMPLETE: PREPARED') $completeOutput
    $completeCommit=Save-FixtureCommit $valid @('changes/WS-001-fixture.md','RESUME.md') 'Fixture Complete'
    Assert-Fixture 'actual hook admits Complete with fresh own receipt' ($completeCommit.Exit-eq0) $completeCommit
    $finalHead=(Invoke-FixtureGit $valid @('rev-parse','HEAD')).Output[0]
    $range=Invoke-FixtureChecker $valid @('-Mode','Range','-Base',$baseline,'-Head',$finalHead)
    Assert-Fixture 'actual range checker accepts every valid lifecycle transition' ($range.Exit-eq0) $range
    Assert-Fixture 'hooks and Review/Complete did not rerun Finish child tests' ([int][IO.File]::ReadAllText((Join-Path $valid 'work/count.txt'))-eq2)
    $archive=Join-Path $valid ('.workbench-certifications/'+$receipt.digest+'.json')
    Assert-Fixture 'the exact original receipt is archived by its own immutable digest' ((Get-FileHash -LiteralPath $archive).Hash-ceq(Get-FileHash -LiteralPath (Join-Path $valid '.workbench-local-certification.json')).Hash)

    $counterexample=New-ApprovedFixture 'range-counterexample'
    $approvedHead=(Invoke-FixtureGit $counterexample @('rev-parse','HEAD')).Output[0]
    Write-FixtureFile (Join-Path $counterexample 'outside.txt') 'forbidden intermediate; isolated Git data only'
    $null=Invoke-FixtureGit $counterexample @('add','outside.txt')
    $badTree=(Invoke-FixtureGit $counterexample @('write-tree')).Output[0]
    $badCommit=(Invoke-FixtureGit $counterexample @('commit-tree',$badTree,'-p',$approvedHead,'-m','Isolated invalid intermediate data')).Output[0]
    [IO.File]::Delete((Join-Path $counterexample 'outside.txt'))
    $null=Invoke-FixtureGit $counterexample @('add','-A')
    $goodTree=(Invoke-FixtureGit $counterexample @('write-tree')).Output[0]
    $goodEnd=(Invoke-FixtureGit $counterexample @('commit-tree',$goodTree,'-p',$badCommit,'-m','Isolated restored endpoint data')).Output[0]
    $endpoint=(Invoke-FixtureGit $counterexample @('diff','--name-only',$approvedHead,$goodEnd)).Output
    $badRange=Invoke-FixtureChecker $counterexample @('-Mode','Range','-Base',$approvedHead,'-Head',$goodEnd)
    Assert-Fixture 'valid endpoints do not hide an invalid intermediate transition' (!$endpoint.Count-and$badRange.Exit-ne0-and($badRange.Output-join' ')-match'WB_WRITE_SCOPE_REFUSED') $badRange
    $watcher=Join-Path $PSScriptRoot 'watch_run.ps1'
    $replay=Invoke-FixtureWatch $watcher 'wb-alert-positive'
    Assert-Fixture 'actual Brief caller reports generic unreadable and refused outcomes' ($replay.Exit-ne0-and$replay.Output-match'TOOL: UNREADABLE'-and$replay.Output-match'PUBLISH: REFUSED') $replay
    Assert-Fixture 'actual Brief caller suppresses passing test progress' ($replay.Output-notmatch'PASS 1 mentioning') $replay
    $mutant=Join-Path $ownedRoot 'watcher-mutant/watch_run.ps1'
    $watcherText=[IO.File]::ReadAllText($watcher)
    $mutated=$watcherText.Replace('|UNREADABLE|','|UNREADABLE_SUPPRESSED|')
    Assert-Fixture 'alert mutation actually changes the selected implementation' ($mutated-cne$watcherText)
    Write-FixtureFile $mutant $mutated
    $mutantResult=Invoke-FixtureWatch $mutant 'wb-alert-mutant'
    Assert-Fixture 'unreadable-suppression mutant is killed by the actual caller case' ($mutantResult.Output-notmatch'TOOL: UNREADABLE') $mutantResult
}catch{$failures++;"FAIL fixture setup or execution: $($_.Exception.Message)"}
finally{
    if($env:WORKBENCH_TEST_EVIDENCE){Write-FixtureFile $env:WORKBENCH_TEST_EVIDENCE ($observations|ConvertTo-Json -Depth 7)}
    if($failures-eq0){$null=Remove-OrvionOwnedTree $ownedRoot @($testParent)}else{"PRESERVED_FIXTURES: $ownedRoot"}
}
"WORKBENCH GOVERNANCE CHECK: $failures failed"
exit [int]($failures-gt0)
