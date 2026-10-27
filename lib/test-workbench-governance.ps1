# Real local Git/caller fixtures. Synthetic owner assertions and short test children are NOT live approval or full-suite certification.
param([switch]$CIOnly)
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
function Copy-Fixture([string]$From,[string]$Name,[string]$fixtureParent=$ownedRoot) {
    $destination=Join-Path $fixtureParent $Name
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
function Start-FixtureChild([string[]]$Arguments,[string]$Directory,[hashtable]$extraEnvironment) {
    $info=[Diagnostics.ProcessStartInfo]::new((Get-Command pwsh -CommandType Application|Select-Object -First 1).Source)
    $info.UseShellExecute=$false;$info.CreateNoWindow=$true;$info.RedirectStandardOutput=$true;$info.RedirectStandardError=$true
    $info.WorkingDirectory=$Directory
    foreach($key in 'WORKBENCH_TEST_ROOT','WORKBENCH_TEMP_ROOT','WORKBENCH_TEST_EVIDENCE','WORKBENCH_SUITE_PARENT','WORKBENCH_SUITE_RECIPE','WORKBENCH_SUITE_MODE','WORKBENCH_CI_CANDIDATE','WORKBENCH_CI_RUNTIME'){$null=$info.Environment.Remove($key)}
    $info.Environment['WORKBENCH_TEMP_ROOT']=Join-Path $ownedRoot 'entry-temp'
    $activeFile=Join-Path $Directory 'changes/WS-001-fixture.md'
    if(Test-Path -LiteralPath $activeFile){
        $childContext=Get-WorkbenchContext (Get-WorkbenchFields ([IO.File]::ReadAllText($activeFile)))
        if($childContext){$info.Environment['WORKBENCH_TEST_ROOT']=$childContext['Tests Root'];$info.Environment['WORKBENCH_TEMP_ROOT']=$childContext['Temp Root']}
    }
    if($extraEnvironment){foreach($key in $extraEnvironment.Keys){$info.Environment[$key]=$extraEnvironment[$key]}}
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
    $runtime=Join-Path $ownedRoot 'execution-runtime';[void][IO.Directory]::CreateDirectory($runtime)
    $log=Join-Path $runtime ($Label+'.log')
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
    $badEnvironment=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',$entryPath,'-Root',$checkout,'-Execute') $checkout @{WORKBENCH_TEST_ROOT=(Join-Path $ownedRoot 'unapproved-tests')})
    Assert-Fixture 'actual Execute rejects an unapproved fixture environment before writes' ($badEnvironment.Exit-ne0-and$badEnvironment.Output-match'WB_CONTEXT_ENVIRONMENT_MISMATCH'-and[Convert]::ToBase64String([IO.File]::ReadAllBytes($file))-ceq[Convert]::ToBase64String($beforeBytes)) $badEnvironment
    $executionResult=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',$entryPath,'-Root',$checkout,'-Execute') $checkout)
    $outputLines=@($executionResult.Output);$exitValue=$executionResult.Exit
    $executeBlob=(Invoke-FixtureGit $checkout @('hash-object','--path=feature.txt','--',$file)).Output[0]
    Assert-Fixture 'actual Execute uses accepted Plan and applier for an in-scope first write' ($exitValue-eq0-and$executeBlob-ceq$step.Blob-and($outputLines-join' ')-match'WORKBENCH_EXECUTE: DONE') $outputLines
    $null=Save-FixtureCommit $checkout @('feature.txt') 'Fixture literal implementation commit'
    $writeAt=(Get-Item -LiteralPath $file).LastWriteTimeUtc.Ticks
    $executionResult=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',$entryPath,'-Root',$checkout,'-Execute') $checkout)
    $outputLines=@($executionResult.Output);$exitValue=$executionResult.Exit
    Assert-Fixture 'actual Execute resumes Already Applied without rewriting the selected file' ($exitValue-eq0-and($outputLines-join' ')-match'ALREADY_APPLIED: feature.txt'-and(Get-Item -LiteralPath $file).LastWriteTimeUtc.Ticks-eq$writeAt) $outputLines
}
function New-ContextFixture([string]$Name,[hashtable]$Changes,[switch]$Original) {
    $checkout=Copy-Fixture $draftSnapshot $Name
    $file=Join-Path $checkout 'changes/WS-001-fixture.md'
    $body=[IO.File]::ReadAllText($file)
    $selected=Join-Path $evidence ($Name+'-selected.md')
    $oldPath=[regex]::Match($body,'(?m)^V3: [^|]+ \| [^|]+ \| (?<path>[^|]+) \| SELECTED\r?$').Groups['path'].Value.Trim()
    if(!$oldPath){throw 'CONTEXT_FIXTURE_SELECTED_PATH_MISSING'}
    $body=$body.Replace($oldPath,$selected)
    $fields=Get-WorkbenchFields $body
    $contextBody=$fields.Sections['Execution Context']
    $replacements=if($Changes){$Changes.Clone()}else{@{}}
    if($Original){$replacements['Original Root']=$checkout;$replacements['Sandbox Parent']=Join-Path $ownedRoot 'proof-sandboxes'}
    foreach($key in $replacements.Keys){
        $pattern='(?m)^'+[regex]::Escape($key)+': [^\n]+$'
        $value=$key+': '+$replacements[$key]
        $contextBody=[regex]::Replace($contextBody,$pattern,[Text.RegularExpressions.MatchEvaluator]{param($match)$value})
    }
    $body=Set-WorkbenchSection $body 'Execution Context' $contextBody
    Write-FixtureFile $file $body;Write-FixtureFile $selected $body
    $null=Save-FixtureCommit $checkout @('changes/WS-001-fixture.md') ('Fixture context Draft '+$Name)
    [pscustomobject]@{Root=$checkout;Selected=$selected;Digest=(Get-FileHash -LiteralPath $selected).Hash;DraftText=$body}
}
function Test-ContextAssurance {
    $initialV3=$v3;$initialDraftDigest=$draftDigest
    $without=Copy-Fixture $seed 'missing-context'
    $missing=[regex]::Replace($text,'(?ms)^## Execution Context\r?\n.*?(?=^## )','')
    Write-FixtureFile (Join-Path $without 'changes/WS-001-fixture.md') $missing
    $refused=Save-FixtureCommit $without @('changes/WS-001-fixture.md') 'Forbidden missing context Draft' -AllowFailure
    Assert-Fixture 'new actual allocation cannot omit the execution context' ($refused.Exit-ne0-and($refused.Output-join' ')-match'WB_EXECUTION_CONTEXT_REQUIRED') $refused
    $baseContext=(Get-WorkbenchFields $text).Sections['Execution Context']
    $sameRoot=[regex]::Replace($baseContext,'(?m)^Sandbox Parent: [^\n]+$',('Sandbox Parent: '+(Join-Path $testParent 'never-original')))
    $longRoot=[regex]::Replace($baseContext,'(?m)^Tests Root: [^\n]+$',('Tests Root: '+(Join-Path $testParent ('long-'+('x'*160)))))
    $badContexts=@(
        [pscustomobject]@{Name='overlap';Body=$sameRoot;Code='WB_CONTEXT_ORIGINAL_SANDBOX_OVERLAP'},
        [pscustomobject]@{Name='longpath';Body=$longRoot;Code='WB_CONTEXT_FIXTURE_PATH_TOO_LONG'},
        [pscustomobject]@{Name='unknown';Body=($baseContext+[char]10+'Skip Tests: true');Code='WB_EXECUTION_CONTEXT_INVALID'}
    )
    foreach($badContext in $badContexts){
        $badRoot=Copy-Fixture $seed ('invalid-context-'+$badContext.Name)
        Write-FixtureFile (Join-Path $badRoot 'changes/WS-001-fixture.md') (Set-WorkbenchSection $text 'Execution Context' $badContext.Body)
        $badCommit=Save-FixtureCommit $badRoot @('changes/WS-001-fixture.md') ('Forbidden context '+$badContext.Name) -AllowFailure
        Assert-Fixture ('actual allocation rejects context '+$badContext.Name) ($badCommit.Exit-ne0-and($badCommit.Output-join' ')-match$badContext.Code) $badCommit
    }
    $budget=New-ContextFixture 'context-budget' @{'Minimum Physical GB'='999999'}
    $v3=$budget.Selected;$draftDigest=$budget.Digest
    $null=Approve-FixtureCheckout $budget.Root
    Set-FixtureStatus $budget.Root 'In Progress';$null=Save-FixtureCommit $budget.Root @('changes/WS-001-fixture.md') 'Fixture begin unavailable budget'
    $budgetRun=Invoke-FixtureFinish $budget.Root 'wb-budget-refused'
    Assert-Fixture 'actual Finish refuses insufficient headroom before a test child' ($budgetRun.Runner.Exit-ne0-and$budgetRun.Output-match'WB_CONTEXT_RESOURCE_BUDGET_UNAVAILABLE'-and!(Test-Path -LiteralPath (Join-Path $budget.Root 'work/count.txt'))) $budgetRun
    $version=New-ContextFixture 'context-version' @{'PowerShell Version'='0.0.1'}
    $v3=$version.Selected;$draftDigest=$version.Digest
    $null=Approve-FixtureCheckout $version.Root
    Set-FixtureStatus $version.Root 'In Progress';$null=Save-FixtureCommit $version.Root @('changes/WS-001-fixture.md') 'Fixture begin wrong version'
    $versionRun=Invoke-FixtureFinish $version.Root 'wb-version-refused'
    Assert-Fixture 'actual Finish refuses a different executable version before a test child' ($versionRun.Runner.Exit-ne0-and$versionRun.Output-match'WB_CONTEXT_EXECUTABLE_VERSION_MISMATCH'-and!(Test-Path -LiteralPath (Join-Path $version.Root 'work/count.txt'))) $versionRun
    $v3=$initialV3;$draftDigest=$initialDraftDigest
    $busy=New-ApprovedFixture 'context-busy'
    Set-FixtureStatus $busy 'In Progress';$null=Save-FixtureCommit $busy @('changes/WS-001-fixture.md') 'Fixture begin shared heavy lease'
    $busyRecord=Get-WorkbenchFields ([IO.File]::ReadAllText((Join-Path $busy 'changes/WS-001-fixture.md')))
    $heavy=Enter-WorkbenchHeavyOperation (Get-WorkbenchContext $busyRecord)
    try{
        $busyRun=Invoke-FixtureFinish $busy 'wb-heavy-refused'
        Assert-Fixture 'actual Finish refuses a shared heavy-operation overlap before a test child' ($busyRun.Runner.Exit-ne0-and$busyRun.Output-match'WB_CONTEXT_HEAVY_OPERATION_IN_PROGRESS'-and!(Test-Path -LiteralPath (Join-Path $busy 'work/count.txt'))) $busyRun
    }finally{$heavy.Dispose()}
    $originalCase=New-ContextFixture 'original-context' @{} -Original
    $v3=$originalCase.Selected;$draftDigest=$originalCase.Digest
    $attempt=Approve-FixtureCheckout $originalCase.Root -AllowFailure
    Assert-Fixture 'original Approval refuses absent sandbox proof through the actual hook' ($attempt.Exit-ne0-and($attempt.Output-join' ')-match'WB_SANDBOX_PROOF_REQUIRED') $attempt
    Write-FixtureFile (Join-Path $originalCase.Root 'changes/WS-001-fixture.md') $originalCase.DraftText
    Write-FixtureFile (Join-Path $originalCase.Root 'RESUME.md') ('# Fixture'+[char]10+'Active Workbench Contract: None'+[char]10)
    $null=Invoke-FixtureGit $originalCase.Root @('add','--','changes/WS-001-fixture.md','RESUME.md')
    $proofParent=Join-Path $ownedRoot 'proof-sandboxes';[void][IO.Directory]::CreateDirectory($proofParent)
    $proofRoot=Copy-Fixture $originalCase.Root 'sandbox' $proofParent
    $null=Approve-FixtureCheckout $proofRoot
    Set-FixtureStatus $proofRoot 'In Progress';Write-FixtureFile (Join-Path $proofRoot 'feature.txt') ('after'+[char]10)
    $null=Save-FixtureCommit $proofRoot @('changes/WS-001-fixture.md','feature.txt') 'Fixture sandbox implementation for exact original context'
    $proofRun=Invoke-FixtureFinish $proofRoot 'wb-context-sandbox'
    Assert-Fixture 'actual isolated sandbox emits its own versioned recipe receipt' ($proofRun.Runner.Exit-eq0) $proofRun
    $proofReceipt=Read-WorkbenchReceipt $proofRoot
    Assert-Fixture 'sandbox receipt explicitly binds Draft and sandbox role' ($proofReceipt.schema-eq2-and$proofReceipt.role-ceq'SANDBOX'-and$proofReceipt.draftSHA256-ceq$draftDigest) $proofReceipt
    $artifact=Join-Path $evidence 'context-sandbox-receipt.json'
    [IO.File]::Copy((Join-Path $proofRoot '.workbench-local-certification.json'),$artifact,$false)
    $originalFile=Join-Path $originalCase.Root 'changes/WS-001-fixture.md'
    $originalText=[IO.File]::ReadAllText($originalFile);$originalRecord=Get-WorkbenchFields $originalText
    $originalText=Set-WorkbenchSection $originalText 'Execution Log' ($originalRecord.Sections['Execution Log']+[char]10+"Sandbox Receipt: $artifact"+[char]10+"Sandbox Receipt SHA256: $((Get-FileHash -LiteralPath $artifact).Hash)")
    Write-FixtureFile $originalFile $originalText
    $approvedOriginal=Approve-FixtureCheckout $originalCase.Root
    Assert-Fixture 'actual original Approval admits exact successful sandbox artifact' ($approvedOriginal.Exit-eq0) $approvedOriginal
    Set-FixtureStatus $originalCase.Root 'In Progress';Write-FixtureFile (Join-Path $originalCase.Root 'feature.txt') ('after'+[char]10)
    $null=Save-FixtureCommit $originalCase.Root @('changes/WS-001-fixture.md','feature.txt') 'Fixture original matches sandbox implementation'
    $originalRun=Invoke-FixtureFinish $originalCase.Root 'wb-context-original'
    Assert-Fixture 'actual original needs and produces its own fresh recipe receipt' ($originalRun.Runner.Exit-eq0) $originalRun
    $originalReceipt=Read-WorkbenchReceipt $originalCase.Root
    Assert-Fixture 'original receipt binds sandbox proof without transplanting it' ($originalReceipt.role-ceq'ORIGINAL'-and$originalReceipt.proof-ceq$proofReceipt.digest-and$originalReceipt.digest-cne$proofReceipt.digest-and$originalReceipt.root-cne$proofReceipt.root) $originalReceipt
    $count=[IO.File]::ReadAllText((Join-Path $originalCase.Root 'work/count.txt'))
    Write-FixtureFile (Join-Path $originalCase.Root 'feature.txt') ('changed after sandbox'+[char]10)
    $null=Save-FixtureCommit $originalCase.Root @('feature.txt') 'Fixture changed input after sandbox proof'
    $staleRun=Invoke-FixtureFinish $originalCase.Root 'wb-context-stale'
    Assert-Fixture 'actual original rejects stale sandbox input before any repeated tests' ($staleRun.Runner.Exit-ne0-and$staleRun.Output-match'WB_SANDBOX_PROOF_RECIPE_OR_INPUT_MISMATCH'-and[IO.File]::ReadAllText((Join-Path $originalCase.Root 'work/count.txt'))-ceq$count) $staleRun
    $sourceRoot=Split-Path $PSScriptRoot -Parent
    $raw=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',(Join-Path $sourceRoot 'tests.ps1')) $sourceRoot @{WORKBENCH_SUITE_PARENT=[string]$PID;WORKBENCH_SUITE_RECIPE=('A'*64)})
    Assert-Fixture 'actual raw full-suite caller rejects a claimed parent and recipe before tests' ($raw.Exit-ne0-and$raw.Output-match'WB_RAW_FULL_SUITE_REFUSED'-and$raw.Output-notmatch'PASS hazards') $raw
    $badGit=@{GIT_DIR=(Join-Path $seed '.git')}
    $bootstrap=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',(Join-Path $sourceRoot 'lib/Workbench.ps1'),'-Root',$sourceRoot,'-Boot') $sourceRoot $badGit)
    Assert-Fixture 'actual entry refuses a redirected Git environment before evaluator loading' ($bootstrap.Exit-ne0-and$bootstrap.Output-match'WB_BOOTSTRAP_GIT_ENVIRONMENT_REFUSED') $bootstrap
    $mutantRoot=Copy-Fixture $draftSnapshot 'bootstrap-mutant'
    $mutantPath=Join-Path $mutantRoot 'lib/Workbench.ps1'
    $mutantText=[IO.File]::ReadAllText($mutantPath)
    $primitive='(?ms)^    # This primitive must run.*?(?=^    \$Root=\[IO\.Path\])'
    if(@([regex]::Matches($mutantText,$primitive)).Count-ne1){throw 'BOOTSTRAP_ENVIRONMENT_MUTANT_STALE'}
    $mutantText=[regex]::Replace($mutantText,$primitive,'')
    Write-FixtureFile $mutantPath $mutantText
    $mutantBoot=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',$mutantPath,'-Root',$mutantRoot,'-Boot') $mutantRoot $badGit)
    Assert-Fixture 'removing pre-bootstrap environment validation is killed by the actual caller predicate' ($mutantBoot.Output-notmatch'WB_BOOTSTRAP_GIT_ENVIRONMENT_REFUSED') $mutantBoot
}

function Assert-CIRefusal([string]$Name,[scriptblock]$Operation,[string]$Code) {
    $caught='NONE'
    try{& $Operation}catch{$caught=$_.Exception.Message}
    $observations.Add([pscustomobject]@{Kind='ci-refusal';Name=$Name;Observed=$caught;Expected=$Code})
    Assert-Fixture $Name ($caught-cmatch$Code) $caught
}
function Test-CICapability {
    # WS009 privacy: exercise the literal failure block with synthetic logs independently of the watcher.
    $diagnosticText=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Workbench.ps1'))
    $parseTokens=$null;$parseErrors=$null
    $diagnosticAst=[Management.Automation.Language.Parser]::ParseInput($diagnosticText,[ref]$parseTokens,[ref]$parseErrors)
    $diagnosticBlocks=@($diagnosticAst.FindAll({param($node) $node-is[Management.Automation.Language.IfStatementAst]-and$node.Extent.Text.StartsWith('if(@($children|Where-Object{$_.Process.ExitCode-ne0}).Count)')},$true))
    if($parseErrors.Count-or$diagnosticBlocks.Count-ne1){throw 'CI_DIAGNOSTIC_BLOCK_NOT_UNIQUE'}
    $diagnosticBlock=[scriptblock]::Create("param(`$children,`$CIRuntimeRoot)`n"+$diagnosticBlocks[0].Extent.Text)
    $fakeGh='gh'+'p_'+('Ab3'*12);$fakePat='github_'+'pat_'+('Cd4_'*9);$fakeApi='sk'+'-'+('Ef5_'*9)
    $fakeJwt='eyJ'+('a'*12)+'.'+('b'*15)+'.'+('c'*15);$fakeBearer='SyntheticBearerValue';$fakeNamed='SyntheticNamedValue'
    $privacyRoot=Join-Path $ownedRoot 'privacy';[void][IO.Directory]::CreateDirectory($privacyRoot)
    $credentialLine="FAIL assertion expected=42 actual=41 trace=$fakeGh pat=$fakePat api=$fakeApi jwt=$fakeJwt Authorization: Bearer $fakeBearer password=$fakeNamed"
    $privacyCases=[ordered]@{assertion=$credentialLine}
    $privacyCases['boundary']=('x'*1994)+' '+$fakeGh+' tail'
    $privacyCases['named-boundary']=('x'*1986)+' API_KEY='+$fakeNamed+' tail'
    foreach($case in $privacyCases.Keys){
        $dir=Join-Path $privacyRoot $case;[void][IO.Directory]::CreateDirectory($dir)
        Write-FixtureFile (Join-Path $dir 'ci.log') ($privacyCases[$case]+[char]10)
        Write-FixtureFile (Join-Path $dir 'watcher.log') $credentialLine
        $children=@([pscustomobject]@{Role='runner';Process=[pscustomobject]@{ExitCode=1}},[pscustomobject]@{Role='watcher';Process=[pscustomobject]@{ExitCode=7}})
        $captured=[Collections.Generic.List[string]]::new();$refusal=''
        try{& $diagnosticBlock $children $dir|ForEach-Object{$captured.Add([string]$_)}}catch{$refusal=$_.Exception.Message}
        $text=$captured-join[char]10
        $leaked=@(@($fakeGh,$fakePat,$fakeApi,$fakeJwt,$fakeBearer,$fakeNamed)|Where-Object{$text.Contains($_)})
        Assert-Fixture ('CI privacy '+$case+' masks both log sources before output and preserves refusal/exits') ($leaked.Count-eq0-and$text.Contains('<redacted>')-and$refusal-ceq'WB_CI_CHILD_OR_OBSERVER_FAILED'-and$captured[0]-ceq'CI_CHILD: runner exit=1'-and$captured[1]-ceq'CI_CHILD: watcher exit=7')
        if($case-ceq'assertion'){Assert-Fixture 'CI privacy retains ordinary assertion context' ($text.Contains('FAIL assertion expected=42 actual=41'))}
        if($case-ceq'boundary'){Assert-Fixture 'CI privacy never leaks a truncated token prefix' (!$text.Contains($fakeGh.Substring(0,5)))}
        if($case-ceq'named-boundary'){Assert-Fixture 'CI privacy never leaks a truncated named value' (!$text.Contains($fakeNamed.Substring(0,4)))}
    }
    foreach($case in 'missing','empty','locked','malformed'){
        $dir=Join-Path $privacyRoot $case;[void][IO.Directory]::CreateDirectory($dir)
        $log=Join-Path $dir 'ci.log';$handle=$null
        if($case-in@('empty','locked')){Write-FixtureFile $log ''}
        if($case-ceq'locked'){$handle=[IO.File]::Open($log,'Open','ReadWrite','None')}
        if($case-ceq'malformed'){[IO.File]::WriteAllBytes($log,[byte[]](0xC3,0x28,0xFF,0x07,0x0A,0x41))}
        $captured=[Collections.Generic.List[string]]::new();$refusal=''
        try{try{& $diagnosticBlock $children $dir|ForEach-Object{$captured.Add([string]$_)}}catch{$refusal=$_.Exception.Message}}finally{if($handle){$handle.Dispose()}}
        $text=$captured-join[char]10
        $expected=if($case-ceq'empty'){'CI_LOG: <empty>'}elseif($case-in@('missing','locked')){'CI_LOG: <unreadable>'}else{'CI_LOG: '}
        Assert-Fixture ('CI privacy '+$case+' log retains fixed failure and safe fallback') ($refusal-ceq'WB_CI_CHILD_OR_OBSERVER_FAILED'-and$text.Contains($expected)-and$text-cnotmatch'[\x00-\x08\x0B-\x1F\x7F-\x9F\u2028\u2029]')
    }

    $policy=Get-WorkbenchWorkflowPolicy
    $validJson=$policy|ConvertTo-Json -Depth 20
    Assert-WorkbenchWorkflowText $validJson
    Assert-Fixture 'CI closed JSON workflow policy accepts its exact positive control' $true
    $mutations=@(
        @('privileged trigger',{$args[0].on=@{pull_request_target=@{}}}),
        @('write permission',{$args[0].permissions.contents='write'}),
        @('dynamic job skip',{$args[0].jobs.'workbench-acceptance'.if='${{ github.ref == ''refs/heads/other'' }}'}),
        @('wrong branch',{$args[0].on.push.branches=@('other')}),
        @('path filter',{$args[0].on.push.paths=@('docs/**')}),
        @('unpinned action',{$args[0].jobs.'workbench-acceptance'.steps[0].uses='actions/checkout@main'}),
        @('persisted credential',{$args[0].jobs.'workbench-acceptance'.steps[0].with.'persist-credentials'=$true}),
        @('omitted mandatory entry',{$args[0].jobs.'workbench-acceptance'.steps[2].run='Write-Output green'}),
        @('continue on failure',{$args[0].jobs.'workbench-acceptance'.'continue-on-error'=$true}),
        @('untrusted runner',{$args[0].jobs.'workbench-acceptance'.'runs-on'='self-hosted'}),
        @('extra job',{$args[0].jobs.extra=@{}})
    )
    foreach($mutation in $mutations){
        $value=Get-WorkbenchWorkflowPolicy;& $mutation[1] $value
        $body=$value|ConvertTo-Json -Depth 20
        Assert-CIRefusal ('CI policy rejects '+$mutation[0]) {Assert-WorkbenchWorkflowText $body} '^WB_CI_WORKFLOW_POLICY$'
    }
    Assert-CIRefusal 'CI rejects duplicate JSON keys' {Assert-WorkbenchWorkflowText ($validJson.Replace('"contents": "read"','"contents": "write", "contents": "read"'))} '^WB_CI_WORKFLOW_POLICY$'
    Assert-CIRefusal 'CI rejects ambiguous YAML rather than regex approval' {Assert-WorkbenchWorkflowText 'name: not-closed-json'} '^WB_CI_WORKFLOW_JSON_REQUIRED$'
    # Independent initial synthetic trust fixture; no real approval, receipt or production authority.
    $ciRoot=Join-Path $ownedRoot 'ci-caller';[void][IO.Directory]::CreateDirectory($ciRoot)
    $null=Invoke-FixtureGit $ciRoot @('init','--quiet')
    foreach($pair in @(@('user.name','CI fixture'),@('user.email','ci@invalid.local'),@('core.autocrlf','true'),@('core.hooksPath','.git/hooks'))){$null=Invoke-FixtureGit $ciRoot @('config','--local',$pair[0],$pair[1])}
    foreach($relative in 'lib/Test-WorkbenchChange.ps1','lib/Workbench.ps1','lib/workspace-layout.ps1','lib/remove-owned.ps1','lib/run_timed.ps1','lib/watch_run.ps1','lib/Test-ScriptHazards.ps1','lib/Events.ps1','lib/Hunt.ps1','tests.ps1'){
        Write-FixtureFile (Join-Path $ciRoot $relative) ([IO.File]::ReadAllText((Join-Path (Split-Path $PSScriptRoot -Parent) $relative)))
    }
    Write-FixtureFile (Join-Path $ciRoot 'RESUME.md') ('Active Workbench Contract: None'+[char]10)
    Write-FixtureFile (Join-Path $ciRoot '.gitignore') ('work/'+[char]10+'.workbench-local-certification.json'+[char]10+'.workbench-certifications/'+[char]10)
    Write-FixtureFile (Join-Path $ciRoot 'lib/test-synthetic.ps1') "'PASS synthetic CI child (dispatch proof only)'`nexit 0`n"
    $null=Invoke-FixtureGit $ciRoot @('add','.')
    $null=Invoke-FixtureGit $ciRoot @('commit','--quiet','-m','Synthetic initial CI fixture trust only')
    $ciHead=(Invoke-FixtureGit $ciRoot @('rev-parse','HEAD')).Output[0]
    # Keep the Windows fixture-path probe short even though owning fixture names are descriptive.
    $ciRuntime=Join-Path $testParent ('ci-'+[guid]::NewGuid().ToString('N').Substring(0,8))
    $ciRecipe=Get-WorkbenchCIRecipe $ciRoot $ciHead $ciRuntime
    Assert-Fixture 'CI recipe binds full candidate, ordered tests, runtime and evaluator inputs' ($ciRecipe.Material.candidate-ceq$ciHead-and$ciRecipe.Material.schedule.tests.Count-eq1-and@($ciRecipe.Material.schedule.inputs|Where-Object{$_.Path-ceq'lib/Test-WorkbenchChange.ps1'}).Count-eq1)
    Assert-CIRefusal 'CI refuses stale candidate SHA' {Get-WorkbenchCIRecipe $ciRoot ('0'*40) $ciRuntime} '^WB_CI_CANDIDATE_MISMATCH$'
    Assert-CIRefusal 'CI refuses overlapping runtime root' {Get-WorkbenchCIRecipe $ciRoot $ciHead $ciRoot} '^WB_CI_RUNTIME_OVERLAP$'
    Assert-CIRefusal 'CI refuses forged direct parent context' {Assert-WorkbenchCISuiteParent $ciRoot $ciHead $ciRuntime $ciRecipe.Digest $PID} '^WB_CI_SUITE_PARENT_REQUIRED$'
    Assert-CIRefusal 'CI refuses missing timed context and observer' {Assert-WorkbenchCITimed $ciRoot $ciRuntime} '^WB_CI_TIMED_CONTEXT_REQUIRED$'
    Assert-CIRefusal 'CI refuses missing concurrent watcher' {Assert-WorkbenchCIObserved $ciRoot (Join-Path $ciRuntime 'not-observed.log')} '^WB_CI_OBSERVER_REQUIRED$'
    Assert-CIRefusal 'CI workflow profile cannot omit its required workflow' {Assert-WorkbenchWorkflowSet $ciRoot $ciHead '' $ciRuntime -RequireWorkflow} '^WB_CI_WORKFLOW_REQUIRED$'
    $badBinary=Join-Path $ownedRoot 'unreviewed-tool.exe';Write-FixtureFile $badBinary 'not the pinned binary'
    Assert-CIRefusal 'CI refuses substituted grammar tool before execution' {Assert-WorkbenchCITool $badBinary} '^WB_CI_GRAMMAR_TOOL_IDENTITY$'
    $entryCI=Join-Path $ciRoot 'lib/Workbench.ps1'
    $worker=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',$entryCI,'-Root',$ciRoot,'-CI','-CIWorker','-Candidate',$ciHead,'-CIRuntimeRoot',$ciRuntime,'-Actionlint',$badBinary) $ciRoot)
    Assert-Fixture 'CI actual fixed entry refuses invalid tool before tests' ($worker.Exit-ne0-and$worker.Output-match'WB_CI_GRAMMAR_TOOL_IDENTITY'-and$worker.Output-notmatch'PASS hazards') $worker
    $fakeEnv=@{WORKBENCH_SUITE_MODE='CI';WORKBENCH_SUITE_PARENT=[string]$PID;WORKBENCH_SUITE_RECIPE=$ciRecipe.Digest;WORKBENCH_CI_CANDIDATE=$ciHead;WORKBENCH_CI_RUNTIME=$ciRuntime}
    $forged=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',(Join-Path $ciRoot 'tests.ps1')) $ciRoot $fakeEnv)
    Assert-Fixture 'CI actual raw driver refuses environment-only authority at terminal None' ($forged.Exit-ne0-and$forged.Output-match'WB_RAW_FULL_SUITE_REFUSED'-and$forged.Output-notmatch'PASS hazards') $forged
    $native=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',$entryCI,'-Root',$ciRoot,'-Finish') $ciRoot $fakeEnv)
    Assert-Fixture 'CI environment cannot issue native lifecycle certification' ($native.Exit-ne0-and$native.Output-match'WB_ACTIVE_CONTRACT_REQUIRED'-and!(Test-Path -LiteralPath (Join-Path $ciRoot '.workbench-local-certification.json'))) $native

    $verifiedGrammar=Assert-WorkbenchCITool $env:WORKBENCH_ACTIONLINT
    $workflowProbe=Join-Path $ownedRoot 'semantic-grammar-positive.yml'
    Write-FixtureFile $workflowProbe $validJson
    $grammarOutput=@(& $verifiedGrammar '-shellcheck=' '-pyflakes=' $workflowProbe 2>&1);$grammarExit=$LASTEXITCODE
    Assert-Fixture 'CI real pinned upstream grammar accepts the semantic positive' ($grammarExit-eq0) $grammarOutput
    $unknown=$validJson.Replace('"shell": "pwsh"','"shell_typo": "pwsh"')
    Write-FixtureFile $workflowProbe $unknown
    $grammarOutput=@(& $verifiedGrammar '-shellcheck=' '-pyflakes=' $workflowProbe 2>&1);$grammarExit=$LASTEXITCODE
    Assert-Fixture 'CI real grammar rejects an unknown workflow schema key' ($grammarExit-ne0) $grammarOutput
    $ciCall=@('-NoProfile','-File',$entryCI,'-Root',$ciRoot,'-CI','-Candidate',$ciHead,'-CIRuntimeRoot',$ciRuntime,'-Actionlint',$verifiedGrammar)
    $positive=Receive-FixtureChild (Start-FixtureChild $ciCall $ciRoot)
    $observations.Add([pscustomobject]@{Kind='ci-actual-positive';Root=$ciRoot;Runtime=$ciRuntime;Exit=$positive.Exit;Output=$positive.Output})
    $ciResult=if(Test-Path -LiteralPath (Join-Path $ciRuntime 'ci-result.json')){Get-Content -LiteralPath (Join-Path $ciRuntime 'ci-result.json') -Raw|ConvertFrom-Json}else{$null}
    Assert-Fixture 'CI actual terminal-None caller owns exactly one successful timed/watched schedule' ($positive.Exit-eq0-and$ciResult.Result-ceq'READY'-and$ciResult.Certification-eq$false-and$ciResult.Recipe-ceq$ciRecipe.Digest) $positive
    Assert-Fixture 'CI driver removes its test data from managed temp on success' ($positive.Exit-eq0-and@(Get-ChildItem -LiteralPath (Join-Path $ciRecipe.Context['Temp Root'] 'tmp') -Filter 'orvion-test-data-*' -ErrorAction SilentlyContinue).Count-eq0)
    Assert-Fixture 'CI actual success prints no failure diagnostics' ($positive.Output-cnotmatch'CI_CHILD:|CI_LOG:|CI_WATCHER:') $positive
    Assert-Fixture 'CI actual success creates neither native working nor archived certification' (!(Test-Path -LiteralPath (Join-Path $ciRoot '.workbench-local-certification.json'))-and!(Test-Path -LiteralPath (Join-Path $ciRoot '.workbench-certifications')))
    foreach($scenario in 'child-exit','omitted-schedule','omitted-hazards','stale-recipe','watcher-exit'){
        # Each mutant is independent synthetic initial trust data, never a bypassed production transition.
        $mutantCI=Join-Path $ownedRoot ('ci-'+$scenario);[void][IO.Directory]::CreateDirectory($mutantCI)
        foreach($relative in @((Invoke-FixtureGit $ciRoot @('ls-files')).Output)){
            Write-FixtureFile (Join-Path $mutantCI $relative) ([IO.File]::ReadAllText((Join-Path $ciRoot $relative)))
        }
        if($scenario-ceq'child-exit'){Write-FixtureFile (Join-Path $mutantCI 'lib/test-synthetic.ps1') "'PASS forged green child'`n'::error::forged workflow command'`n`"``e[31mforged ansi``a bell`"`n'FAIL assertion expected=42 actual=41 trace=$fakeGh password=$fakeNamed'`nexit 7`n"}
        elseif($scenario-ceq'omitted-schedule'){
            $driver=Join-Path $mutantCI 'tests.ps1';$driverText=[IO.File]::ReadAllText($driver)
            $needle='foreach($relativeTest in $suiteRecipe.Material.tests)'
            if(!$driverText.Contains($needle)){throw 'CI_SCHEDULE_MUTANT_STALE'}
            Write-FixtureFile $driver ($driverText.Replace($needle,'foreach($relativeTest in @())'))
        }elseif($scenario-ceq'omitted-hazards'){
            $driver=Join-Path $mutantCI 'tests.ps1';$driverText=[IO.File]::ReadAllText($driver)
            $needle='else{"PASS hazards ($($scripts.Count) scripts)"}'
            if(!$driverText.Contains($needle)){throw 'CI_HAZARDS_MUTANT_STALE'}
            Write-FixtureFile $driver ($driverText.Replace($needle,'else{"synthetic hazard omission"}'))
        }elseif($scenario-ceq'stale-recipe'){
            $driver=Join-Path $mutantCI 'lib/Workbench.ps1';$driverText=[IO.File]::ReadAllText($driver)
            $needle='$env:WORKBENCH_SUITE_RECIPE=$ciRecipe.Digest'
            if(!$driverText.Contains($needle)){throw 'CI_RECIPE_MUTANT_STALE'}
            Write-FixtureFile $driver ($driverText.Replace($needle,"`$env:WORKBENCH_SUITE_RECIPE=('A'*64)"))
        }else{
            $observerFile=Join-Path $mutantCI 'lib/watch_run.ps1'
            $observerText=[IO.File]::ReadAllText($observerFile)
            if(!$observerText.Contains("exit [int](`$body -notmatch '^END exit=0\b')")){throw 'CI_WATCHER_MUTANT_STALE'}
            Write-FixtureFile $observerFile ($observerText.Replace("exit [int](`$body -notmatch '^END exit=0\b')",'exit 7'))
        }
        $null=Invoke-FixtureGit $mutantCI @('init','--quiet')
        foreach($pair in @(@('user.name','CI mutant fixture'),@('user.email','ci@invalid.local'),@('core.autocrlf','true'),@('core.hooksPath','.git/hooks'))){$null=Invoke-FixtureGit $mutantCI @('config','--local',$pair[0],$pair[1])}
        $null=Invoke-FixtureGit $mutantCI @('add','.');$null=Invoke-FixtureGit $mutantCI @('commit','--quiet','-m','Isolated causal CI fixture trust only')
        $mutantHead=(Invoke-FixtureGit $mutantCI @('rev-parse','HEAD')).Output[0]
        $mutantRuntime=Join-Path $testParent ('ci-'+[guid]::NewGuid().ToString('N').Substring(0,8))
        $failure=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',(Join-Path $mutantCI 'lib/Workbench.ps1'),'-Root',$mutantCI,'-CI','-Candidate',$mutantHead,'-CIRuntimeRoot',$mutantRuntime,'-Actionlint',$verifiedGrammar) $mutantCI)
        $expectedFailure=if($scenario-in@('omitted-schedule','omitted-hazards')){'WB_CI_REQUIRED_TEST_NOT_OBSERVED'}else{'WB_CI_CHILD_OR_OBSERVER_FAILED'}
        $observations.Add([pscustomobject]@{Kind='ci-actual-mutant';Scenario=$scenario;Runtime=$mutantRuntime;Exit=$failure.Exit;Output=$failure.Output;Expected=$expectedFailure})
        Assert-Fixture ('CI actual '+$scenario+' cannot become success') ($failure.Exit-ne0-and$failure.Output-match$expectedFailure-and!(Test-Path -LiteralPath (Join-Path $mutantRuntime 'ci-result.json'))) $failure
        if($scenario-ceq'child-exit'){Assert-Fixture 'CI driver removes its test data after a failed test child' (@(Get-ChildItem -LiteralPath (Join-Path $mutantRuntime 'tmp/tmp') -Filter 'orvion-test-data-*' -ErrorAction SilentlyContinue).Count-eq0)}
        if($scenario-ceq'child-exit'){Assert-Fixture 'CI child failure names both exits, the failing test and its detail without raw workflow commands or controls' ($failure.Output-cmatch'(?m)^CI_CHILD: runner exit=1\r?$'-and$failure.Output-cmatch'(?m)^CI_CHILD: watcher exit=1\r?$'-and$failure.Output-cmatch'(?m)^CI_LOG: .*FAIL test-synthetic\.ps1'-and$failure.Output-cmatch'(?m)^CI_LOG: .*::error::forged workflow command'-and$failure.Output-cmatch'(?m)^CI_LOG: .*forged ansi\? bell'-and$failure.Output-cmatch'(?m)^CI_WATCHER: '-and$failure.Output-cnotmatch'(?m)^::'-and$failure.Output-cnotmatch'\x1B') $failure}
        if($scenario-ceq'child-exit'){Assert-Fixture 'CI actual child assertion redacts credentials and retains assertion context' ($failure.Output.Contains('FAIL assertion expected=42 actual=41')-and$failure.Output.Contains('<redacted>')-and!$failure.Output.Contains($fakeGh)-and!$failure.Output.Contains($fakeNamed)) $failure}
        if($scenario-ceq'watcher-exit'){Assert-Fixture 'CI observer failure names its own exit beside the runner log' ($failure.Output-cmatch'(?m)^CI_CHILD: runner exit=0\r?$'-and$failure.Output-cmatch'(?m)^CI_CHILD: watcher exit=7\r?$'-and$failure.Output-cmatch'(?m)^CI_LOG: .*END exit=0 '-and$failure.Output-cmatch'(?m)^CI_WATCHER: ') $failure}
    }


    foreach($changedPath in 'tests.ps1','lib/Workbench.ps1','lib/Test-WorkbenchChange.ps1','lib/watch_run.ps1'){
        $target=Join-Path $ciRoot $changedPath;$saved=[IO.File]::ReadAllText($target)
        try{
            Write-FixtureFile $target ($saved+[char]10+'# unauthorized mutation')
            Assert-CIRefusal ('CI refuses changed helper/evaluator/schedule '+$changedPath) {Get-WorkbenchCIRecipe $ciRoot $ciHead $ciRuntime} '^WB_CI_CLEAN_CANDIDATE_REQUIRED$'
        }finally{Write-FixtureFile $target $saved}
    }
    $wrongEntry=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',$entryCI,'-Root',$ownedRoot,'-CI','-Candidate',$ciHead,'-CIRuntimeRoot',$ciRuntime,'-Actionlint',$verifiedGrammar) $ciRoot)
    Assert-Fixture 'CI actual entry refuses a substituted physical root' ($wrongEntry.Exit-ne0-and$wrongEntry.Output-match'WB_ENTRY_ROOT_MISMATCH') $wrongEntry
    $unparented=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',$entryCI,'-Root',$ciRoot,'-CI','-CIWorker','-Candidate',$ciHead,'-CIRuntimeRoot',$ciRuntime,'-Actionlint',$verifiedGrammar) $ciRoot)
    Assert-Fixture 'CI actual internal worker refuses an unapproved raw invocation' ($unparented.Exit-ne0-and$unparented.Output-match'WB_CI_TIMED_CONTEXT_REQUIRED') $unparented

    # A content mutation is detected before any child starts, even with an unchanged claimed SHA.
    $scheduleFile=Join-Path $ciRoot 'lib/test-synthetic.ps1';$before=[IO.File]::ReadAllText($scheduleFile)
    Write-FixtureFile $scheduleFile 'exit 0 # altered schedule'
    Assert-CIRefusal 'CI refuses altered scheduled test at the claimed candidate' {Get-WorkbenchCIRecipe $ciRoot $ciHead $ciRuntime} '^WB_CI_CLEAN_CANDIDATE_REQUIRED$'
    Write-FixtureFile $scheduleFile $before
}

if($CIOnly){
    try{Test-CICapability}catch{$failures++;"FAIL CI fixture: $($_.Exception.Message)"}
    if($env:WORKBENCH_TEST_EVIDENCE){Write-FixtureFile $env:WORKBENCH_TEST_EVIDENCE ($observations|ConvertTo-Json -Depth 7)}
    if($failures-eq0){$null=Remove-OrvionOwnedTree $ownedRoot @($testParent)}else{"PRESERVED_FIXTURES: $ownedRoot"}
    "WORKBENCH CI OWNING CHECK: $failures failed";exit [int]($failures-gt0)
}
try {
    $seed=Join-Path $ownedRoot 'seed';[void][IO.Directory]::CreateDirectory($seed)
    $null=Invoke-FixtureGit $seed @('init','--quiet')
    foreach($setting in @(@('user.name','Fixture'),@('user.email','fixture@invalid.local'),@('core.hooksPath','.git/hooks'),@('core.autocrlf','true'),@('gc.auto','0'),@('maintenance.auto','false'))){$null=Invoke-FixtureGit $seed @('config','--local',$setting[0],$setting[1])}
    foreach($relative in 'lib/Test-WorkbenchChange.ps1','lib/Workbench.ps1','lib/workspace-layout.ps1','lib/run_timed.ps1','lib/watch_run.ps1','lib/apply-draft-steps.ps1','lib/Invoke-DraftSteps.ps1','lib/Events.ps1','lib/Hunt.ps1','lib/Sync-Sessions.ps1','.githooks/pre-commit'){
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
    Write-FixtureFile (Join-Path $seed 'lib/test-synthetic-fixture.ps1') ('# Synthetic dispatch fixture only; this is not the real owning suite.'+[char]10+'exit 0'+[char]10)
    Write-FixtureFile (Join-Path $seed 'lib/test-case-extension.PS1') ('# Windows discovery control, synthetic dispatch proof only.'+[char]10+'exit 0'+[char]10)
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

## Execution Context
Original Root: $(Join-Path $testParent 'never-original')
Sandbox Parent: $ownedRoot
Tests Root: $(Join-Path $testParent 'child-tests')
Temp Root: $(Join-Path $ownedRoot 'execution-temp')
Runtime Root: $(Join-Path $ownedRoot 'execution-runtime')
PowerShell Version: $($PSVersionTable.PSVersion.ToString())
Git Version: $((Invoke-FixtureGit $seed @('--version')).Output[0])
Minimum Physical GB: 1.5
Minimum Commit GB: 3

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
    $discoveryRecipe=Get-WorkbenchRecipe $draftRoot 'HEAD' (Get-WorkbenchFields $text)
    Assert-Fixture 'recipe retains the existing Windows uppercase-extension test discovery' (@($discoveryRecipe.Material.tests)-ccontains'lib/test-case-extension.PS1')
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
    Test-ContextAssurance
    Test-CICapability
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
