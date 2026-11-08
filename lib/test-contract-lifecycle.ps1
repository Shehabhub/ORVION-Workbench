# Self-check for Invoke-ContractLifecycle: walks every stage, Sandbox then Original, on a tiny disposable workstream, with each
# guard refused at the point it can fire, then dry-runs the finished fixture. The fixture's evaluator is the real one up to its
# dot-source return, so every pure function is real; only Gate/Range decisions and the native verbs are stubs.
# -FirstFailure stops at the first failed case, so a mutant run costs only the chain up to its check.
param([switch]$FirstFailure)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$tool=Join-Path $PSScriptRoot 'Invoke-ContractLifecycle.ps1'
$hostExe=(Get-Process -Id $PID).Path
$parent=[IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\')
$root=Join-Path $parent ('olc'+[guid]::NewGuid().ToString('N').Substring(0,8))
$env:WORKBENCH_TEST_EVIDENCE=$null
$stopAtFirst=$FirstFailure.IsPresent;$fail=0;function Check($n,[bool]$ok){if($ok){"PASS $n"}else{"FAIL $n";$script:fail++;if($stopAtFirst){throw 'FIXTURE_CHAIN_STOPPED'}}}
function FixGit([string]$Repo){$lines=@(& git --no-optional-locks -C $Repo -c core.quotepath=false @args 2>$null);if($LASTEXITCODE){throw "FIXTURE_GIT:$($args-join' ')"};$lines}
function Write-Crlf([string]$Path,[string]$Text){[void][IO.Directory]::CreateDirectory((Split-Path $Path -Parent));[IO.File]::WriteAllText($Path,($Text-replace'\r?\n',"`r`n"),[Text.UTF8Encoding]::new($false))}
function Write-Json([string]$Path,$Value){[void][IO.Directory]::CreateDirectory((Split-Path $Path -Parent));$Value|ConvertTo-Json -Depth 9|Set-Content -LiteralPath $Path}
function Read-Json([string]$Path){Get-Content -LiteralPath $Path -Raw|ConvertFrom-Json}
function Set-Field([string]$Path,[string]$Name,$Value){$json=Read-Json $Path;$json.$Name=$Value;Write-Json $Path $json}
function Remove-Line([string]$Path,[string]$Text){[IO.File]::WriteAllLines($Path,@([IO.File]::ReadAllLines($Path)|Where-Object{!$_.Contains($Text)}))}
function Invoke-Stage([string]$Role,[string]$Stage,[string]$With,[string]$Inject){
    $saved=@{};foreach($name in 'PATH','TEMP','TMP','WORKBENCH_TEMP_ROOT','WORKBENCH_TEST_ROOT','ORVION_DATA_ROOT'){$saved[$name]=[Environment]::GetEnvironmentVariable($name)}
    $env:LIFECYCLE_FIXTURE_REFUSE=$Inject;$thrown='';$global:LASTEXITCODE=0;$out=@()
    try{$out=@(& $tool -Manifest $(if($With){$With}else{$manifest}) -Role $Role -Stage $Stage 2>&1|ForEach-Object{"$_"})}catch{$thrown="$_"}
    finally{foreach($name in $saved.Keys){[Environment]::SetEnvironmentVariable($name,$saved[$name])};$env:LIFECYCLE_FIXTURE_REFUSE=$null}
    [pscustomobject]@{Ok=(!$thrown-and!$LASTEXITCODE);Text=(@($out)+$thrown)-join' '}
}
function Test-Pass([string]$Role,[string]$Stage,[string]$Expect=''){
    $run=Invoke-Stage $Role $Stage
    if(!$run.Ok-or!$run.Text.Contains($Expect)){"FAIL $Role $Stage passes";"  detail: $($run.Text)";$script:fail++;throw 'FIXTURE_CHAIN_STOPPED'}
    "PASS $Role $Stage passes"
}
# One guard: optional damage to one file (restored after), the stage, the refusal code, the root put back if the stage moved it.
function Test-Refused([string]$Name,[string]$Role,[string]$Stage,[string]$Code,[string]$With='',[string]$Inject='',[string]$Path='',[scriptblock]$Edit){
    $rootPath=if($Role-ceq'Original'){$original}else{$sandbox}
    $present=Test-Path -LiteralPath (Join-Path $rootPath '.git');$head=if($present){@(FixGit $rootPath rev-parse HEAD)[0]}
    $bytes=if($Path){[IO.File]::ReadAllBytes($Path)}
    if($Edit){$null=& $Edit}
    $run=Invoke-Stage $Role $Stage $With $Inject
    if($Path){[IO.File]::SetAttributes($Path,[IO.FileAttributes]::Normal);[IO.File]::WriteAllBytes($Path,$bytes)}
    if($present-and((@(FixGit $rootPath rev-parse HEAD)[0]-cne$head)-or@(FixGit $rootPath status --porcelain --untracked-files=all).Count)){$null=FixGit $rootPath reset --quiet --hard $head;$null=FixGit $rootPath clean -q -f -d}
    $ok=!$run.Ok-and$run.Text.Contains($Code)
    Check $Name $ok
    if(!$ok){"  detail: $($run.Text)"}
}
$script:variantCount=0
function New-Variant([scriptblock]$Edit){$value=Read-Json $manifest;& $Edit $value;$script:variantCount++;$path=Join-Path $root "variant-$script:variantCount.json";Write-Json $path $value;$path}
# Outputs a qualified Draft also declares, so the change reaches past the qualification check.
function New-OutputVariant([string]$From,[string]$Path,[string]$Blob){
    $script:variantCount++;$steps=Join-Path $root "steps-$script:variantCount.json"
    Write-Json $steps ([ordered]@{draftSHA256=$draftSha;replay=[ordered]@{secondExit=0};steps=@(foreach($row in $outputs){if($row.Path-ceq$From){[ordered]@{path=$Path;blob=$Blob}}else{[ordered]@{path=$row.Path;blob=$row.Blob}}})})
    New-Variant {param($v)$v.Evidence.DraftCheck=$steps;$v.Outputs=@(foreach($row in $outputs){if($row.Path-ceq$From){[ordered]@{Path=$Path;Blob=$Blob}}else{$row}})}
}
# Rewrites the sandbox chain from one planned commit on, with $Edit on each commit up to $Through, and points the result at it.
function New-ForgedChain([string]$From,[string]$Through,[scriptblock]$Edit){
    $chain=@(FixGit $sandbox log --reverse --format=%H "$baseline..HEAD");$names='allocate','approve','begin','implement','review','complete'
    $at=[array]::IndexOf($names,$From);$end=[array]::IndexOf($names,$Through)
    $null=FixGit $sandbox reset --quiet --hard $(if($at){$chain[$at-1]}else{$baseline})
    for($i=$at;$i-lt$names.Count;$i++){
        $null=FixGit $sandbox checkout --quiet $chain[$i] -- .
        if($i-le$end){$null=& $Edit}
        $null=FixGit $sandbox add -A;$null=FixGit $sandbox commit --quiet --allow-empty -C $chain[$i]
    }
    Set-Field $sandboxResult 'Head' @(FixGit $sandbox rev-parse HEAD)[0]
}
function Edit-SandboxContract([string]$From,[string]$To){$file=Join-Path $sandbox 'changes\WS-999-fixture.md';$text=[IO.File]::ReadAllText($file);if(!$text.Contains($From)){throw 'FIXTURE_EDIT_ANCHOR'};[IO.File]::WriteAllText($file,$text.Replace($From,$To))}
function Get-TreeState{(Get-ChildItem -LiteralPath $root -Recurse -File -Force|ForEach-Object{$_.FullName+' '+(Get-FileHash -LiteralPath $_.FullName).Hash})-join"`n"}

$workbenchStub=@'
param([string]$Root,[switch]$Execute,[switch]$Finish,[switch]$Review,[switch]$Complete,[string]$Actionlint)
$ErrorActionPreference='Stop'
. (Join-Path $Root 'lib\Test-WorkbenchChange.ps1') -Root $Root
$verb=if($Execute){'Execute'}elseif($Finish){'Finish'}elseif($Review){'Review'}else{'Complete'}
if($env:LIFECYCLE_FIXTURE_REFUSE-ceq$verb){exit 9}
if($Actionlint-and!(Test-Path -LiteralPath $Actionlint)){exit 10}
$resume=Join-Path $Root 'RESUME.md';$routing=[IO.File]::ReadAllText($resume);$contract=Get-WorkbenchPointer $routing
$path=Join-Path $Root $contract;$text=[IO.File]::ReadAllText($path);$record=Get-WorkbenchFields $text
switch($verb){
'Execute'{if($record.Checkpoint['Resume Step']-cne'DONE'){[void][IO.Directory]::CreateDirectory((Join-Path $Root 'docs'));[IO.File]::WriteAllText((Join-Path $Root 'lib\tool.ps1'),"# tool v2`r`n");[IO.File]::WriteAllText((Join-Path $Root 'docs\new.txt'),"new`n")}elseif($env:LIFECYCLE_FIXTURE_REFUSE-ceq'ExecuteDone'){exit 9}}
'Finish'{
    $context=Get-WorkbenchContext $record;$role=Get-WorkbenchExecutionRole $Root $context;$recipe=Get-WorkbenchRecipe $Root 'HEAD' $record
    $proof=if($role-ceq'ORIGINAL'){(Assert-WorkbenchSandboxProof $Root $record $context $recipe -Implementation).digest}else{$null}
    $material=[ordered]@{schema=2;root=$Root;contract=$contract;finishHead=@(Invoke-WorkbenchGit $Root @('rev-parse','HEAD'))[0];fingerprint=(Get-WorkbenchFingerprint $Root 'HEAD' $contract);profiles=@(Get-WorkbenchProfiles @(Get-WorkbenchScope $record));evaluator=@(Invoke-WorkbenchGit $Root @('rev-parse','HEAD:lib/Test-WorkbenchChange.ps1'))[0];runLog=$env:FIXTURE_RUN_LOG;runStart=$env:FIXTURE_RUN_START;result='READY';draftSHA256=(Get-WorkbenchApprovalValues $record)['Approved SHA256'];recipe=$recipe.Digest;role=$role;proof=$proof}
    $digest=Get-WorkbenchDigest ($material|ConvertTo-Json -Compress -Depth 5);$material['digest']=$digest
    $receipt=$material|ConvertTo-Json -Depth 5
    [IO.File]::WriteAllText((Join-Path $Root '.workbench-local-certification.json'),$receipt)
    [void][IO.Directory]::CreateDirectory((Join-Path $Root '.workbench-certifications'));[IO.File]::WriteAllText((Join-Path $Root ".workbench-certifications\$digest.json"),$receipt)
    'PASS test-x.ps1';'TESTS: all passed in 0 s';'PASS the real journal is untouched by the checks'
}
'Review'{'WORKBENCH_REVIEW: READY'}
'Complete'{
    [IO.File]::WriteAllText($path,(Set-WorkbenchSection $text 'Status' ($record.Sections.Status.Replace('[x] In Progress','[ ] In Progress').Replace('[ ] Complete','[x] Complete'))))
    [IO.File]::WriteAllText($resume,$routing.Replace("Active Workbench Contract: $contract",'Active Workbench Contract: None'));'PREPARED'
}
}
'@
$runTimedStub=@'
param([string]$WorkingDirectory,[string]$Log,[string]$Command)
$start='RUN START '+[DateTime]::UtcNow.ToString('o');[IO.File]::WriteAllText($Log,"$start`n")
$env:FIXTURE_RUN_LOG=$Log;$env:FIXTURE_RUN_START=$start
$lines=@(Invoke-Expression $Command);$code=$LASTEXITCODE
foreach($line in $lines){Add-Content -LiteralPath $Log "[+0.0 min] $line"}
Add-Content -LiteralPath $Log "[+0.0 min] END exit=$code elapsed=0"
exit $code
'@
$watchStub=@'
param([string]$Log,[string]$Run,[string]$Csv,[switch]$Brief,[int]$ProgressMinutes,[int]$PollSeconds)
$deadline=[DateTime]::UtcNow.AddMinutes(2)
while([DateTime]::UtcNow-lt$deadline){
    try{$share=[IO.FileShare]::ReadWrite-bor[IO.FileShare]::Delete;$reader=[IO.StreamReader]::new([IO.File]::Open($Log,[IO.FileMode]::Open,[IO.FileAccess]::Read,$share));$text=$reader.ReadToEnd();$reader.Dispose();if($text-match'END exit=(\d+)'){"END exit=$($Matches[1])";exit 0}}catch{Start-Sleep -Milliseconds 50}
    Start-Sleep -Milliseconds 100
}
exit 5
'@
$previewStub=@'
param([string]$Draft,[string]$Root,[switch]$Preview)
if($env:LIFECYCLE_FIXTURE_REFUSE-ceq'Preview'){exit 4}
$sha=if($env:LIFECYCLE_FIXTURE_REFUSE-ceq'PreviewWrong'){'0'*64}else{(Get-FileHash -LiteralPath $Draft).Hash}
$blob=if($env:LIFECYCLE_FIXTURE_REFUSE-ceq'PreviewBlob'){'0'*40}else{'__TOOLBLOB__'}
[ordered]@{DraftSHA256=$sha;Files=@([ordered]@{File='lib/tool.ps1';Blob=$blob;Skip=$false},[ordered]@{File='docs/new.txt';Blob='__NEWBLOB__';Skip=$false})}|ConvertTo-Json -Depth 4
'@

try{
    # ---- fixture ----
    $original=Join-Path $root 'o';$other=Join-Path $root 'p2';$packet=Join-Path $root 'pk';$sandboxParent=Join-Path $root 'sp';$sandbox=Join-Path $sandboxParent 's';$runtimeRoot=Join-Path $root 'rt'
    [void][IO.Directory]::CreateDirectory($original);[void][IO.Directory]::CreateDirectory($other);[void][IO.Directory]::CreateDirectory($packet)
    foreach($repo in $original,$other){$null=FixGit $repo init --quiet -b main;foreach($pair in @(@('core.autocrlf','true'),@('core.hooksPath','.githooks'),@('user.name','fixture'),@('user.email','fixture@invalid.local'))){$null=FixGit $repo config --local $pair[0] $pair[1]}}
    $null=FixGit $original remote add origin 'https://fixture.invalid/original.git'
    $actionlint=Join-Path $root 'actionlint.exe';Write-Crlf $actionlint 'fixture'
    $evaluator=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Test-WorkbenchChange.ps1'))
    $return="if(`$MyInvocation.InvocationName-eq'.'){return}";$cut=$evaluator.IndexOf($return);if($cut-lt0){throw 'FIXTURE_EVALUATOR_RETURN_MISSING'}
    $judgeText=$evaluator.Substring(0,$cut)+"function Get-WorkbenchCITool{[ordered]@{SHA256='$((Get-FileHash -LiteralPath $actionlint).Hash)'}}`n$return`nif(`$env:LIFECYCLE_FIXTURE_REFUSE-ceq`$Mode){exit 7}`nif(`$ExpectedEvaluatorSha256-and(Get-FileHash -LiteralPath `$PSCommandPath).Hash-cne`$ExpectedEvaluatorSha256){exit 8}`n'WB_FIXTURE: admitted'`nexit 0`n"
    $toolPayload=Join-Path $root 'tool-v2.ps1';$newPayload=Join-Path $root 'new.txt';Write-Crlf $toolPayload "# tool v2`n";Write-Crlf $newPayload "new`n"
    $toolBlob=@(FixGit $original hash-object --path=lib/tool.ps1 -- $toolPayload)[0];$newBlob=@(FixGit $original hash-object --path=docs/new.txt -- $newPayload)[0]
    $outputs=@([pscustomobject]@{Path='lib/tool.ps1';Blob=$toolBlob},[pscustomobject]@{Path='docs/new.txt';Blob=$newBlob})
    Write-Crlf (Join-Path $original 'lib\Test-WorkbenchChange.ps1') $judgeText
    Write-Crlf (Join-Path $original 'lib\Workbench.ps1') $workbenchStub
    Write-Crlf (Join-Path $original 'lib\run_timed.ps1') $runTimedStub
    Write-Crlf (Join-Path $original 'lib\watch_run.ps1') $watchStub
    Write-Crlf (Join-Path $original 'lib\Watch-Host.ps1') "param([string]`$WatchPid,[switch]`$ExitWhenPidsGone)`nexit 0`n"
    Write-Crlf (Join-Path $original 'lib\apply-draft-steps.ps1') $previewStub.Replace('__TOOLBLOB__',$toolBlob).Replace('__NEWBLOB__',$newBlob)
    foreach($name in 'lib\Events.ps1','lib\Hunt.ps1','lib\test-x.ps1','tests.ps1','changes\README.md'){Write-Crlf (Join-Path $original $name) "# fixture`n"}
    Write-Crlf (Join-Path $original 'lib\tool.ps1') "# tool v1`n"
    Write-Crlf (Join-Path $original 'RESUME.md') "# Resume`nActive Workbench Contract: None`n"
    Write-Crlf (Join-Path $original '.gitignore') ".workbench-*`n"
    $null=FixGit $original add -A;$null=FixGit $original commit --quiet -m 'baseline'
    $baseline=@(FixGit $original rev-parse HEAD)[0]
    Write-Crlf (Join-Path $other 'keep.txt') "keep`n";$null=FixGit $other add -A;$null=FixGit $other commit --quiet -m 'other'
    $today=[DateTime]::UtcNow.ToString('yyyy-MM-dd')
    $v1=Join-Path $packet 'v1.md';$v2=Join-Path $packet 'v2.md';Write-Crlf $v1 "v1`n";Write-Crlf $v2 "v2`n"
    $draft=Join-Path $packet 'draft.md'
    $testsRoot=if($env:WORKBENCH_TEST_ROOT){[IO.Path]::GetFullPath($env:WORKBENCH_TEST_ROOT)}else{Join-Path $root 't'}
    Write-Crlf $draft @"
# Workbench Change Request - WS-999

## Status
[x] Draft
[ ] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective
Fixture.

## Baseline
$baseline

## Write Scope
- changes/WS-999-fixture.md
- RESUME.md
- lib/tool.ps1
- docs/new.txt

## Out of Scope
Everything else.

## Draft Assurance
V1: a | $today | $v1 | $((Get-FileHash -LiteralPath $v1).Hash)
V2: b | $today | $v2 | $((Get-FileHash -LiteralPath $v2).Hash)
V3: c | $today | $draft | SELECTED
Selected Version: V3

## Implementation Steps
1. Native Execute writes the two outputs.

## Acceptance Criteria
- [ ] criterion one

## Review Gate
- [ ] gate one

## Runtime Checkpoint
Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log
Created.

## Verification Notes
None yet.

## Execution Context
Original Root: $original
Sandbox Parent: $sandboxParent
Tests Root: $testsRoot
Temp Root: $(Join-Path $root 'tmp')
Runtime Root: $runtimeRoot
PowerShell Version: $($PSVersionTable.PSVersion)
Git Version: $(@(git --version)[0])
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001
"@
    $draftSha=(Get-FileHash -LiteralPath $draft).Hash
    [IO.File]::SetAttributes($draft,[IO.FileAttributes]::ReadOnly)
    $trusted=Join-Path $root 'trusted.ps1';[IO.File]::Copy((Join-Path $original 'lib\Test-WorkbenchChange.ps1'),$trusted)
    $judgeSha=(Get-FileHash -LiteralPath $trusted).Hash
    $approvalSandbox=Join-Path $packet 'gate-sandbox.md';Write-Crlf $approvalSandbox "Approved $draftSha for $sandbox`n"
    $approvalOriginal=Join-Path $packet 'gate-original.md'
    $authority=Join-Path $root 'authority.md';Write-Crlf $authority "authority`n"
    $closureRoot=Join-Path $root 'closure';$closureFile=Join-Path $closureRoot 'a.txt';Write-Crlf $closureFile "closed`n"
    $closureManifest=Join-Path $packet 'closure.json'
    ConvertTo-Json -InputObject @([ordered]@{path='a.txt';bytes=(Get-Item -LiteralPath $closureFile).Length;sha256=(Get-FileHash -LiteralPath $closureFile).Hash}) -Depth 3|Set-Content -LiteralPath $closureManifest
    $reviewEvidence=Join-Path $packet 'review.json';Write-Json $reviewEvidence ([ordered]@{Verdict='ACCEPT';MaterialFindings=0;Subject="draft $draftSha"})
    $qualification=Join-Path $packet 'qualification.json';Write-Json $qualification ([ordered]@{Verdict='PASS_EXACT_SELECTED_DRAFT_PRECHECKS';DraftSHA256=$draftSha})
    $draftCheck=Join-Path $packet 'draft-check.json';Write-Json $draftCheck ([ordered]@{draftSHA256=$draftSha;replay=[ordered]@{secondExit=0};steps=@(foreach($row in $outputs){[ordered]@{path=$row.Path;blob=$row.Blob}})})
    $decisions=Join-Path $packet 'decisions.md';Write-Crlf $decisions "## D1 fixture`n"
    $rowsFile=Join-Path $packet 'rows.json';$rows=[ordered]@{criteria=@([ordered]@{text='criterion one';evidence='seen';disposition='accepted'});review_gates=@([ordered]@{text='gate one';evidence='seen';disposition='accepted'})};Write-Json $rowsFile $rows
    $realData=Join-Path $root 'real';$journal=Join-Path $realData 'events\events.jsonl';Write-Crlf $journal "{}`n"
    $manifest=Join-Path $root 'manifest.json'
    $words=[ordered]@{Rows=$rowsFile;ResidualLog='Residual: none.';Notes='Reviewed {{Suites}} suites, receipt {{Receipt}}.';Boundaries='Fixture only.'}
    Write-Json $manifest ([ordered]@{Workstream='WS-999';Packet=$packet;Draft=$draft;DraftSHA256=$draftSha;Baseline=$baseline;Contract='changes/WS-999-fixture.md'
        Judge=(Join-Path $packet 'accepted\Test-WorkbenchChange.ps1');JudgeSHA256=$judgeSha;JudgeSource=$trusted;Original=$original;OriginalRemote='^https://fixture\.invalid/original\.git$';Sandbox=$sandbox;RuntimeRoot=$runtimeRoot
        HostExe=$hostExe;HostSHA256=(Get-FileHash -LiteralPath $hostExe).Hash;HostVersion=$PSVersionTable.PSVersion.ToString();Actionlint=$actionlint;RealData=$realData
        ProtectedRoots=@($original,$other);Closures=@([ordered]@{Root=$closureRoot;Manifest=$closureManifest;SHA256=(Get-FileHash -LiteralPath $closureManifest).Hash})
        Approval=[ordered]@{Sandbox=$approvalSandbox;Original=$approvalOriginal}
        OriginalApprovalTemplate='Approved {{DraftSHA256}} of {{Draft}} for {{Root}} at {{Baseline}}; sandbox {{Sandbox}} head {{SandboxHead}} receipt {{Receipt}} proof {{Proof}} {{ProofSHA256}} fingerprint {{Fingerprint}} recipe {{Recipe}} evaluator {{Evaluator}}.'
        Authority=[ordered]@{Path=$authority;SHA256=(Get-FileHash -LiteralPath $authority).Hash}
        Outputs=$outputs;AllocateLabel='exact fixture Draft allocation'
        ImplementLog=[ordered]@{Sandbox='Sandbox outputs applied.';Original='Original outputs applied.'}
        Evidence=[ordered]@{Review=$reviewEvidence;Qualification=$qualification;DraftCheck=$draftCheck;Decisions=$decisions;DecisionIds=@('D1')}
        ReviewText=[ordered]@{Sandbox=$words;Original=$words};ReviewsLabel='fixture self-review';KnownExtraCommits=[ordered]@{Sandbox=@();Original=@()}})
    $sandboxRuntime=Join-Path $runtimeRoot 'sandbox';$originalRuntime=Join-Path $runtimeRoot 'original'
    $sandboxResult=Join-Path $sandboxRuntime 'result.json';$binding=Join-Path $packet 'original-approval-binding.json'

    # ---- gates before anything exists ----
    $noField=New-Variant {param($v)$v.PSObject.Properties.Remove('Judge')}
    Test-Refused 'a manifest field missing is refused' Sandbox prepare 'LIFECYCLE_MANIFEST_FIELD_MISSING:Judge' -With $noField
    Test-Refused 'a changed host is refused' Sandbox prepare 'LIFECYCLE_HOST_CHANGED' -With (New-Variant {param($v)$v.HostSHA256='0'*64})
    Test-Refused 'a changed Draft is refused' Sandbox prepare 'LIFECYCLE_DRAFT_CHANGED' -With (New-Variant {param($v)$v.DraftSHA256='0'*64})
    Test-Refused 'a changed trusted evaluator is refused' Sandbox prepare 'LIFECYCLE_JUDGE_CHANGED' -With (New-Variant {param($v)$v.JudgeSHA256='0'*64})
    Test-Refused 'prepare without an Approval file is refused' Sandbox prepare 'LIFECYCLE_APPROVAL_REQUIRED' -With (New-Variant {param($v)$v.Approval.Sandbox=(Join-Path $root 'none.md')})
    Test-Refused 'a stage before prepare is refused' Sandbox allocate 'LIFECYCLE_NOT_PREPARED'
    Test-Refused 'a manifest off the Draft context is refused' Sandbox prepare 'LIFECYCLE_CONTEXT_MISMATCH' -With (New-Variant {param($v)$v.Sandbox=(Join-Path $root 'elsewhere')})
    $badQualification=Join-Path $root 'bad-qualification.json';Write-Json $badQualification ([ordered]@{Verdict='NO';DraftSHA256=$draftSha})
    Test-Refused 'an unqualified Draft is refused' Sandbox prepare 'LIFECYCLE_DRAFT_NOT_QUALIFIED' -With (New-Variant {param($v)$v.Evidence.Qualification=$badQualification})
    Test-Refused 'outputs other than the Draft declares are refused' Sandbox prepare 'LIFECYCLE_OUTPUTS_DIFFER_FROM_DRAFT' -With (New-Variant {param($v)$v.Outputs[0].Blob='0'*40})
    Test-Refused 'a dirty original is refused' Sandbox prepare 'LIFECYCLE_ORIGINAL_NOT_AT_BASELINE' -Edit {Write-Crlf (Join-Path $original 'stray.txt') "x`n"}
    Remove-Item -LiteralPath (Join-Path $original 'stray.txt') -ErrorAction SilentlyContinue
    Test-Refused 'an unpinned closure asks for its hash' Sandbox prepare 'LIFECYCLE_SET_CLOSURE_SHA256' -With (New-Variant {param($v)$v.Closures[0].SHA256=''})
    Test-Refused 'a changed closure manifest is refused' Sandbox prepare 'LIFECYCLE_CLOSURE_MANIFEST_CHANGED' -With (New-Variant {param($v)$v.Closures[0].SHA256='0'*64})
    Test-Refused 'changed closure evidence is refused' Sandbox prepare 'LIFECYCLE_CLOSURE_EVIDENCE_CHANGED' -Path $closureFile -Edit {Write-Crlf $closureFile "changed`n"}
    Test-Refused 'a dirty protected root is refused' Sandbox prepare 'LIFECYCLE_PROTECTED_ROOT_DIRTY' -Edit {Write-Crlf (Join-Path $other 'stray.txt') "x`n"}
    Remove-Item -LiteralPath (Join-Path $other 'stray.txt')
    Test-Refused 'an unreadable protected root is refused' Sandbox prepare 'LIFECYCLE_PROTECTED_HEAD_UNREADABLE' -With (New-Variant {param($v)$v.ProtectedRoots=@($v.ProtectedRoots[0],$packet)})
    $carried=Join-Path $original 'lib\Test-WorkbenchChange.ps1'
    Test-Refused 'an original carrying another evaluator is refused' Sandbox prepare 'LIFECYCLE_JUDGE_CHANGED' -Path $carried -Edit {[IO.File]::AppendAllText($carried,"# other`r`n")}
    Test-Refused 'an existing sandbox is refused' Sandbox prepare 'LIFECYCLE_SANDBOX_EXISTS' -Edit {[void][IO.Directory]::CreateDirectory($sandbox)}
    [IO.Directory]::Delete($sandbox)
    Test-Pass Sandbox prepare 'LIFECYCLE_PREPARED role=Sandbox'
    Test-Refused 'a second prepare is refused' Sandbox prepare 'LIFECYCLE_ALREADY_PREPARED'
    $wrongApproval=Join-Path $root 'wrong-approval.md';Write-Crlf $wrongApproval "Approved something else`n"
    Test-Refused 'an Approval of another subject is refused' Sandbox allocate 'LIFECYCLE_APPROVAL_SUBJECT_MISMATCH' -With (New-Variant {param($v)$v.Approval.Sandbox=$wrongApproval})

    Test-Refused 'an Approval gone after prepare is refused' Sandbox allocate 'LIFECYCLE_APPROVAL_REQUIRED' -With (New-Variant {param($v)$v.Approval.Sandbox=(Join-Path $root 'none.md')})
    $judge=Join-Path $packet 'accepted\Test-WorkbenchChange.ps1'
    Test-Refused 'a changed materialized evaluator is refused' Sandbox allocate 'LIFECYCLE_JUDGE_CHANGED' -Path $judge -Edit {[IO.File]::AppendAllText($judge,"# other`r`n")}
    $originGit=Join-Path $original '.git'
    Test-Refused 'a failed sandbox clone stops' Sandbox allocate 'LIFECYCLE_SANDBOX_CLONE_FAILED' -Edit {[IO.Directory]::Move($originGit,"$originGit-away")}
    [IO.Directory]::Move("$originGit-away",$originGit)

    # ---- sandbox ----
    Test-Pass Sandbox allocate
    Check 'the allocated working copy is writable though the frozen Draft is read-only' (!(Get-Item -LiteralPath (Join-Path $sandbox 'changes\WS-999-fixture.md')).IsReadOnly)
    Check 'the sandbox cannot push' (@(FixGit $sandbox remote get-url --push origin)[0]-ceq'DISABLED')
    Test-Refused 'a second allocation is refused' Sandbox allocate 'LIFECYCLE_SANDBOX_EXISTS'
    Test-Refused 'implement before Approval is refused' Sandbox implement 'LIFECYCLE_APPROVED_STATE_REQUIRED'
    Test-Refused 'Finish before implementation is refused' Sandbox finish 'LIFECYCLE_IMPLEMENTATION_REQUIRED'
    Test-Refused 'a dirty root is refused' Sandbox approve 'LIFECYCLE_ROOT_DIRTY' -Edit {Write-Crlf (Join-Path $sandbox 'stray.txt') "x`n"}
    $configPath=Join-Path $sandbox '.git\config'
    Test-Refused 'a changed hook path is refused' Sandbox approve 'LIFECYCLE_HOOK_OR_REMOTE_BINDING_CHANGED' -Path $configPath -Edit {$null=FixGit $sandbox config --local core.hooksPath other}
    Test-Refused 'a pushable sandbox is refused' Sandbox approve 'LIFECYCLE_HOOK_OR_REMOTE_BINDING_CHANGED' -Path $configPath -Edit {$null=FixGit $sandbox remote set-url --push origin 'https://fixture.invalid/x.git'}
    Test-Refused 'a pointer already taken is refused' Sandbox approve 'LIFECYCLE_POINTER_NOT_FREE' -Edit {Write-Crlf (Join-Path $sandbox 'RESUME.md') "# Resume`nActive Workbench Contract: changes/WS-998-other.md`n";$null=FixGit $sandbox add -A;$null=FixGit $sandbox commit --quiet -m 'pointer'}
    Test-Refused 'a stage commit the evaluator refuses stops' Sandbox approve 'LIFECYCLE_STAGE_ADMISSION_REFUSED' -Inject 'Gate'
    Test-Pass Sandbox approve
    Test-Refused 'a second Approval is refused' Sandbox approve 'LIFECYCLE_DRAFT_STATE_REQUIRED'
    Test-Refused 'a native Execute refusal stops' Sandbox implement 'LIFECYCLE_NATIVE_EXECUTE_REFUSED' -Inject 'Execute'
    Test-Refused 'a native Execute refusal after DONE stops' Sandbox implement 'LIFECYCLE_NATIVE_DONE_REFUSED' -Inject 'ExecuteDone'
    Test-Refused 'native output other than declared is refused' Sandbox implement 'LIFECYCLE_NATIVE_OUTPUT_DIFFERS' -With (New-Variant {param($v)$v.Outputs[1].Blob='0'*40})
    Test-Pass Sandbox implement
    Test-Refused 'a second implementation is refused' Sandbox implement 'LIFECYCLE_APPROVED_STATE_REQUIRED'
    Test-Refused 'another host version is refused' Sandbox finish 'LIFECYCLE_PINNED_HOST_REQUIRED' -With (New-Variant {param($v)$v.HostVersion='0.0.0'})
    Test-Refused 'a missing real journal is refused' Sandbox finish 'LIFECYCLE_REAL_JOURNAL_REQUIRED' -With (New-Variant {param($v)$v.RealData=(Join-Path $root 'none')})
    Test-Refused 'Finish on a dirty root is refused' Sandbox finish 'LIFECYCLE_CLEAN_DONE_REQUIRED' -Edit {Write-Crlf (Join-Path $sandbox 'stray.txt') "x`n"}
    $wrongLint=Join-Path $root 'other-lint.exe';Write-Crlf $wrongLint 'other'
    Test-Refused 'another actionlint is refused' Sandbox finish 'LIFECYCLE_PINNED_ACTIONLINT_REQUIRED' -With (New-Variant {param($v)$v.Actionlint=$wrongLint})
    $failed=Invoke-Stage Sandbox finish '' 'Finish'
    Check 'a failed native Finish reports failure' (!$failed.Ok)
    Check 'a failed native Finish is recorded in its result' ((Read-Json (Join-Path $sandboxRuntime 'run-result.json')).Exits.runner-eq9)
    Test-Refused 'a second Finish is refused without a blind retry' Sandbox finish 'LIFECYCLE_ONE_FINISH_ALREADY_STARTED_NO_BLIND_RETRY'
    foreach($name in @('operation.json','run-result.json','finish.log')+@('runner','watcher','host'|ForEach-Object{"finish-$_.log","finish-$_.stderr.log","finish-$_.exit"})){Remove-Item -LiteralPath (Join-Path $sandboxRuntime $name) -Force}
    Test-Pass Sandbox finish 'ONE SANDBOX FINISH STARTED'
    Check 'a Finish holds the machine awake and records it' ((Read-Json (Join-Path $sandboxRuntime 'launch-resources.json')).KeepAwake-eq$true)
    Check 'the real journal is reported unchanged' ((Read-Json (Join-Path $sandboxRuntime 'run-result.json')).RealJournalUnchanged-eq$true)

    $runResult=Join-Path $sandboxRuntime 'run-result.json';$finishLog=Join-Path $sandboxRuntime 'finish.log'
    $otherIndex=Join-Path $other '.git\index';$otherHead=@(FixGit $other rev-parse HEAD)[0]
    Test-Refused 'a failed child exit is refused' Sandbox inspect 'LIFECYCLE_FINISH_CHILD_FAILED' -Path (Join-Path $sandboxRuntime 'finish-runner.exit') -Edit {[IO.File]::WriteAllText((Join-Path $sandboxRuntime 'finish-runner.exit'),'1')}
    Test-Refused 'a run of another subject is refused' Sandbox inspect 'LIFECYCLE_RUN_SUBJECT_MISMATCH' -Path $runResult -Edit {Set-Field $runResult 'RealJournalUnchanged' $false}
    Test-Refused 'a contract no longer done is refused' Sandbox inspect 'LIFECYCLE_NOT_DONE_IN_PROGRESS' -Edit {$file=Join-Path $sandbox 'changes\WS-999-fixture.md';[IO.File]::WriteAllText($file,[IO.File]::ReadAllText($file).Replace('Resume Step: DONE','Resume Step: 1'));$null=FixGit $sandbox add -A;$null=FixGit $sandbox commit --quiet -m 'undone'}
    Test-Refused 'a changed test schedule is refused' Sandbox inspect 'LIFECYCLE_SCHEDULE_CHANGED' -Edit {Write-Crlf (Join-Path $sandbox 'lib\test-y.ps1') "# y`n";$null=FixGit $sandbox add -A;$null=FixGit $sandbox commit --quiet -m 'schedule'}
    Test-Refused 'a receipt of another tree is refused' Sandbox inspect 'LIFECYCLE_RECEIPT_SUBJECT_MISMATCH' -Edit {Write-Crlf (Join-Path $sandbox 'docs\extra.txt') "x`n";$null=FixGit $sandbox add -A;$null=FixGit $sandbox commit --quiet -m 'extra'}
    Test-Refused 'a carrying range beyond the outputs is refused' Sandbox inspect 'LIFECYCLE_CARRYING_SCOPE_DIFFERS' -With (New-Variant {param($v)$v.Outputs=@($v.Outputs[0])})
    Test-Refused 'a committed output other than declared is refused' Sandbox inspect 'LIFECYCLE_COMMITTED_OUTPUT_DIFFERS' -With (New-Variant {param($v)$v.Outputs[1].Blob='0'*40})
    Test-Refused 'a log without the journal line is refused' Sandbox inspect 'LIFECYCLE_FINISH_LOG_NOT_SUCCESS' -Path $finishLog -Edit {Remove-Line $finishLog 'real journal is untouched'}
    Test-Refused 'a log missing a test is refused' Sandbox inspect 'LIFECYCLE_ORDERED_TEST_MISSING' -Path $finishLog -Edit {Remove-Line $finishLog 'PASS test-x.ps1'}
    Test-Refused 'a changed evaluator in the root is refused' Sandbox inspect 'LIFECYCLE_ROOT_EVALUATOR_CHANGED' -Edit {[IO.File]::AppendAllText((Join-Path $sandbox 'lib\Test-WorkbenchChange.ps1'),"`r`n# changed`r`n")}
    Test-Refused 'a dirty root at inspection is refused' Sandbox inspect 'LIFECYCLE_ROOT_DIRTY' -Edit {Write-Crlf (Join-Path $sandbox 'stray.txt') "x`n"}
    $liveOutput=Join-Path $sandbox 'lib\tool.ps1'
    Test-Refused 'a live output other than committed is refused' Sandbox inspect 'LIFECYCLE_LIVE_OUTPUT_DIFFERS' -Path $liveOutput -Edit {$when=[IO.File]::GetLastWriteTimeUtc($liveOutput);[IO.File]::WriteAllText($liveOutput,[IO.File]::ReadAllText($liveOutput).Replace('v2','v3'));[IO.File]::SetLastWriteTimeUtc($liveOutput,$when)}
    Test-Refused 'a changed real journal is refused' Sandbox inspect 'LIFECYCLE_REAL_JOURNAL_CHANGED' -Path $journal -Edit {[IO.File]::AppendAllText($journal,"{}`r`n")}
    $otherFile=Join-Path $other 'keep.txt'
    # Hidden from git status, so only the tool's own hash compare can catch it.
    $otherBytes=[IO.File]::ReadAllBytes($otherFile)
    Test-Refused 'a changed protected file is refused' Sandbox inspect 'LIFECYCLE_PROTECTED_TRACKED_CHANGED' -Path (Join-Path $other '.git\index') -Edit {$null=FixGit $other update-index --assume-unchanged keep.txt;[IO.File]::WriteAllText($otherFile,"changed`n")}
    [IO.File]::WriteAllBytes($otherFile,$otherBytes)
    Test-Refused 'a dropped protected root is refused' Sandbox inspect 'LIFECYCLE_PROTECTED_ROOT_COUNT_CHANGED' -With (New-Variant {param($v)$v.ProtectedRoots=@($v.ProtectedRoots[0])})
    Test-Refused 'a swapped protected root is refused' Sandbox inspect 'LIFECYCLE_PROTECTED_ROOT_MISSING' -With (New-Variant {param($v)$v.ProtectedRoots=@($v.ProtectedRoots[0],$sandbox)})
    Test-Refused 'a moved protected head is refused' Sandbox inspect 'LIFECYCLE_PROTECTED_HEAD_CHANGED' -Path $otherIndex -Edit {$null=FixGit $other commit --quiet --allow-empty -m 'moved'}
    $null=FixGit $other update-ref refs/heads/main $otherHead
    Test-Refused 'a new protected ref is refused' Sandbox inspect 'LIFECYCLE_PROTECTED_REFS_CHANGED' -Edit {$null=FixGit $other update-ref refs/heads/stray HEAD}
    $null=FixGit $other update-ref -d refs/heads/stray
    Test-Refused 'a changed protected local file is refused' Sandbox inspect 'LIFECYCLE_PROTECTED_LOCAL_CHANGED' -Path (Join-Path $other '.git\config') -Edit {$null=FixGit $other config --local fixture.moved 1}
    Test-Refused 'a refused implementation range stops' Sandbox inspect 'LIFECYCLE_IMPLEMENTATION_RANGE_REFUSED' -Inject 'Range'
    # A turn-diff ref is the Codex client's own bookkeeping and must not fail the compare.
    $null=FixGit $other update-ref refs/codex/turn-diffs/captures/x HEAD
    Test-Pass Sandbox inspect 'LIFECYCLE_INSPECT_READY role=Sandbox'
    $null=FixGit $other update-ref -d refs/codex/turn-diffs/captures/x
    $export=Join-Path $sandboxRuntime 'own-finish-receipt.json'
    Test-Refused 'a colliding receipt export is refused' Sandbox inspect 'LIFECYCLE_RECEIPT_EXPORT_COLLISION' -Path $export -Edit {[IO.File]::AppendAllText($export,' ')}

    $observed=Join-Path $sandboxRuntime 'independent-finish-review.json'
    Test-Refused 'review without an inspection is refused' Sandbox review 'LIFECYCLE_INSPECTION_MISSING' -Path $observed -Edit {Set-Field $observed 'ReadyForNativeReview' $false}
    Test-Refused 'review of another head is refused' Sandbox review 'LIFECYCLE_REVIEW_SUBJECT_CHANGED' -Path $observed -Edit {Set-Field $observed 'Head' ('0'*40)}
    $badReview=Join-Path $root 'bad-review.json';Write-Json $badReview ([ordered]@{Verdict='REJECT';MaterialFindings=1;Subject="draft $draftSha"})
    Test-Refused 'rejected review evidence is refused' Sandbox review 'LIFECYCLE_REVIEW_EVIDENCE_INVALID' -With (New-Variant {param($v)$v.Evidence.Review=$badReview})
    Test-Refused 'a recorded decision missing is refused' Sandbox review 'LIFECYCLE_DECISION_MISSING:D2' -With (New-Variant {param($v)$v.Evidence.DecisionIds=@('D1','D2')})
    Test-Refused 'fewer review rows than criteria is refused' Sandbox review 'LIFECYCLE_CRITERIA_COUNT_DIFFERS' -Path $rowsFile -Edit {Set-Field $rowsFile 'criteria' @()}
    Test-Refused 'a row with no evidence is refused' Sandbox review 'LIFECYCLE_CRITERION_EVIDENCE_MISSING' -Path $rowsFile -Edit {Set-Field $rowsFile 'criteria' @([ordered]@{text='criterion one';evidence='';disposition='accepted'})}
    Test-Refused 'a row with no disposition is refused' Sandbox review 'LIFECYCLE_CRITERION_EVIDENCE_MISSING' -Path $rowsFile -Edit {Set-Field $rowsFile 'criteria' @([ordered]@{text='criterion one';evidence='seen';disposition=''})}
    Test-Refused 'a row of another criterion is refused' Sandbox review 'LIFECYCLE_CRITERION_EVIDENCE_MISSING' -Path $rowsFile -Edit {Set-Field $rowsFile 'criteria' @([ordered]@{text='criterion two';evidence='seen';disposition='accepted'})}
    Test-Refused 'a native Review refusal stops' Sandbox review 'LIFECYCLE_NATIVE_REVIEW_REFUSED' -Inject 'Review'
    Remove-Item -LiteralPath (Join-Path $sandboxRuntime 'criterion-review.json')
    Test-Refused 'Complete without a criterion review is refused' Sandbox complete 'LIFECYCLE_CRITERION_REVIEW_MISSING'
    Test-Pass Sandbox review 'WORKBENCH_REVIEW: READY'
    Check 'review ticked every mapped row' (![regex]::IsMatch([IO.File]::ReadAllText((Join-Path $sandbox 'changes\WS-999-fixture.md')),'(?m)^- \[ \] '))
    Test-Refused 'Complete with a stale inspection is refused' Sandbox complete 'LIFECYCLE_INSPECTION_MISSING' -Path $observed -Edit {Set-Field $observed 'OwnReceipt' ('0'*64)}
    Test-Refused 'a native Complete refusal stops' Sandbox complete 'LIFECYCLE_NATIVE_COMPLETE_REFUSED' -Inject 'Complete'
    Test-Refused 'a refused whole range stops' Sandbox complete 'LIFECYCLE_COMPLETE_RANGE_REFUSED' -Inject 'Range'
    Test-Pass Sandbox complete 'LIFECYCLE_COMPLETE_RANGE_READY role=Sandbox'
    Check 'the sandbox result names its role and is not published' ((Read-Json $sandboxResult).Role-ceq'SANDBOX'-and(Read-Json $sandboxResult).Pushed-eq$false)

    # ---- original ----
    function Clear-Approval{if(Test-Path -LiteralPath $approvalOriginal){Remove-Item -LiteralPath $approvalOriginal -Force}}
    Test-Refused 'original prepare without a complete sandbox is refused' Original prepare 'LIFECYCLE_SANDBOX_PROOF_REQUIRED' -Path $sandboxResult -Edit {Set-Field $sandboxResult 'Status' 'In Progress'}
    Test-Refused 'a changed delegation is refused' Original prepare 'LIFECYCLE_AUTHORITY_CHANGED' -With (New-Variant {param($v)$v.Authority.SHA256='0'*64})
    $exclude=Join-Path $original '.git\info\exclude';$excludeBytes=[IO.File]::ReadAllBytes($exclude);$allocatedHere=Join-Path $original 'changes\WS-999-fixture.md'
    Test-Refused 'an original already holding the contract is refused' Original prepare 'LIFECYCLE_ORIGINAL_NOT_AT_BASELINE' -Edit {[IO.File]::AppendAllText($exclude,"`nchanges/WS-999-fixture.md`n");Write-Crlf $allocatedHere "x`n"}
    Remove-Item -LiteralPath $allocatedHere;[IO.File]::WriteAllBytes($exclude,$excludeBytes)
    Test-Refused 'an Approval already recorded is refused' Original prepare 'LIFECYCLE_APPROVAL_ALREADY_RECORDED' -Edit {Write-Crlf $approvalOriginal "x`n"}
    Clear-Approval
    Test-Refused 'an unfilled Approval template is refused' Original prepare 'LIFECYCLE_TEMPLATE_UNFILLED' -With (New-Variant {param($v)$v.OriginalApprovalTemplate='{{Nothing}}'})
    Clear-Approval
    Test-Refused 'a recipe the sandbox did not prove is refused' Original prepare 'LIFECYCLE_PREDICTED_RECIPE_MISMATCH' -With (New-OutputVariant 'lib/tool.ps1' 'lib/tool.ps1' ('0'*40))
    Clear-Approval
    Test-Refused 'a fingerprint the sandbox did not prove is refused' Original prepare 'LIFECYCLE_PREDICTED_FINGERPRINT_MISMATCH' -With (New-OutputVariant 'docs/new.txt' 'docs/new.txt' ('0'*40))
    Clear-Approval
    Test-Refused 'a refused literal plan stops' Original prepare 'LIFECYCLE_LITERAL_PLAN_REFUSED' -Inject 'Preview'
    Clear-Approval
    Test-Refused 'a literal plan of another Draft is refused' Original prepare 'LIFECYCLE_LITERAL_PLAN_DIFFERS' -Inject 'PreviewWrong'
    Clear-Approval
    Test-Refused 'a literal plan of other blobs is refused' Original prepare 'LIFECYCLE_LITERAL_PLAN_DIFFERS' -Inject 'PreviewBlob'
    Clear-Approval
    Test-Pass Original prepare 'LIFECYCLE_PREPARED role=Original'
    $preflight=Join-Path $originalRuntime 'preflight.json'
    Test-Refused 'allocation without a preflight is refused' Original allocate 'LIFECYCLE_PREFLIGHT_REQUIRED' -Path $preflight -Edit {Set-Field $preflight 'Ready' $false}
    Test-Refused 'a changed binding to the sandbox is refused' Original allocate 'LIFECYCLE_SANDBOX_BINDING_CHANGED' -Path $binding -Edit {Set-Field $binding 'ApprovalSHA256' ('0'*64)}
    Test-Refused 'a moved original is refused' Original allocate 'LIFECYCLE_BASELINE_OR_ALLOCATION_CHANGED' -Edit {$null=FixGit $original commit --quiet --allow-empty -m 'moved'}
    Test-Pass Original allocate
    $originConfig=Join-Path $original '.git\config'
    Test-Refused 'an original bound to another remote is refused' Original approve 'LIFECYCLE_HOOK_OR_REMOTE_BINDING_CHANGED' -Path $originConfig -Edit {$null=FixGit $original remote set-url origin 'https://fixture.invalid/other.git'}
    Test-Refused 'a git failure stops' Original approve 'LIFECYCLE_GIT_FAILED' -Path $originConfig -Edit {$null=FixGit $original remote remove origin}
    Test-Pass Original approve
    Test-Pass Original implement
    Test-Pass Original finish 'ONE ORIGINAL FINISH STARTED'
    Test-Refused 'a receipt of an earlier head is refused' Original inspect 'LIFECYCLE_RECEIPT_HEAD_MISMATCH' -Edit {$null=FixGit $original commit --quiet --allow-empty -m 'moved'}
    Test-Refused 'a receipt with no binding to the proved sandbox is refused' Original inspect 'LIFECYCLE_SANDBOX_PROOF_BINDING_CHANGED' -Path $sandboxResult -Edit {Set-Field $sandboxResult 'Receipt' ('0'*64)}
    Test-Pass Original inspect 'LIFECYCLE_INSPECT_READY role=Original'
    Test-Refused 'original review without both proofs is refused' Original review 'LIFECYCLE_BOTH_ROOT_PROOFS_REQUIRED' -Path $sandboxResult -Edit {Set-Field $sandboxResult 'Receipt' ('0'*64)}
    Test-Pass Original review
    Test-Pass Original complete 'LIFECYCLE_COMPLETE_RANGE_READY role=Original'
    Check 'the original carries six stage commits' (@(FixGit $original rev-list "$baseline..HEAD").Count-eq6)
    Check 'the original pointer is free again' ([IO.File]::ReadAllText((Join-Path $original 'RESUME.md'))-match'Active Workbench Contract: None')

    # ---- dry run of the finished fixture ----
    $state=Get-TreeState
    $dry=Invoke-Stage Sandbox dryrun
    Check 'dry run of the sandbox passes' ($dry.Ok-and$dry.Text.Contains('LIFECYCLE_DRYRUN_PASS'))
    if(!$dry.Ok){"  detail: $($dry.Text)"}
    $dryOriginal=& $hostExe -NoProfile -File $tool -Manifest $manifest -Role Original -Stage dryrun 2>&1|Out-String
    Check 'dry run of the original passes through the pinned host' ($dryOriginal.Contains('LIFECYCLE_DRYRUN_PASS')-and$dryOriginal.Contains('original-approval')-and$dryOriginal.Contains('prediction'))
    if(!$dryOriginal.Contains('LIFECYCLE_DRYRUN_PASS')){"  detail: $dryOriginal"}
    Check 'a dry run writes nothing' ((Get-TreeState)-ceq$state)
    # What git prints on stderr with exit 0 must never read as the answer a caller takes from the first line.
    $env:GIT_TRACE='1';$traced=Invoke-Stage Sandbox dryrun;$env:GIT_TRACE=$null
    Check 'a git trace on stderr never reads as a result' ($traced.Ok-and$traced.Text.Contains('LIFECYCLE_DRYRUN_PASS'))
    Test-Refused 'a dry run of an unfinished role is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_RESULT_MISMATCH' -Path $sandboxResult -Edit {Set-Field $sandboxResult 'Status' 'In Progress'}
    $finalHead=@(FixGit $sandbox rev-parse HEAD)[0]
    Test-Refused 'a commit the plan does not hold is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_UNPLANNED_COMMIT:stray' -Path $sandboxResult -Edit {$null=FixGit $sandbox commit --quiet --allow-empty -m 'stray';Set-Field $sandboxResult 'Head' @(FixGit $sandbox rev-parse HEAD)[0]}
    Test-Refused 'a planned commit missing is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_PLANNED_COMMIT_MISSING:complete' -Path $sandboxResult -Edit {Set-Field $sandboxResult 'Head' @(FixGit $sandbox rev-parse HEAD~1)[0]}
    $null=FixGit $sandbox commit --quiet --allow-empty -m 'stray'
    $bytes=[IO.File]::ReadAllBytes($sandboxResult);Set-Field $sandboxResult 'Head' @(FixGit $sandbox rev-parse HEAD)[0]
    $known=Invoke-Stage Sandbox dryrun (New-Variant {param($v)$v.KnownExtraCommits.Sandbox=@('stray')})
    Check 'a recorded earlier attempt is reported and passes' ($known.Ok-and$known.Text.Contains('stray')-and$known.Text.Contains('review-ticks'))
    [IO.File]::WriteAllBytes($sandboxResult,$bytes);$null=FixGit $sandbox reset --quiet --hard $finalHead
    Test-Refused 'a stage status other than planned is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_STATUS_DIFFERS:begin' -Path $sandboxResult -Edit {New-ForgedChain begin begin {Edit-SandboxContract '[x] In Progress' '[ ] In Progress';Edit-SandboxContract '[ ] Approved' '[x] Approved'}}
    Test-Refused 'an allocated blob other than the Draft is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_ALLOCATED_BLOB_DIFFERS' -Path $sandboxResult -Edit {New-ForgedChain allocate allocate {Edit-SandboxContract 'Fixture.' 'Fixture two.'}}
    $sandboxPointer=Join-Path $sandbox 'RESUME.md'
    Test-Refused 'a pointer other than planned is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_POINTER_DIFFERS' -Path $sandboxResult -Edit {New-ForgedChain approve review {[IO.File]::AppendAllText($sandboxPointer,"# note`r`n")}}
    Test-Refused 'a Begin text other than planned is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_BEGIN_TEXT_DIFFERS' -Path $sandboxResult -Edit {New-ForgedChain begin begin {Edit-SandboxContract 'Fixture.' 'Fixture two.'}}
    Test-Refused 'ticks other than planned are refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_TICKS_DIFFER' -Path $sandboxResult -Edit {New-ForgedChain review review {Edit-SandboxContract '- [x] criterion one' '- [ ] criterion one'}}
    Test-Refused 'stage paths other than planned are refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_PATHS_DIFFER:implement' -With (New-OutputVariant 'docs/new.txt' 'docs/other.txt' $newBlob)
    $sameApproval=Join-Path $root 'same-approval.md';[IO.File]::Copy($approvalSandbox,$sameApproval)
    Test-Refused 'an Approval text other than committed is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_APPROVE_TEXT_DIFFERS' -With (New-Variant {param($v)$v.Approval.Sandbox=$sameApproval})
    Test-Refused 'an implement log other than committed is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_IMPLEMENT_TEXT_DIFFERS' -With (New-Variant {param($v)$v.ImplementLog.Sandbox='Other.'})
    Test-Refused 'a changed receipt export is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_RECEIPT_EXPORT_CHANGED' -Path $export -Edit {[IO.File]::AppendAllText($export,' ')}
    Test-Refused 'a receipt of another commit is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_RECEIPT_COMMIT_DIFFERS' -Path $observed -Edit {Set-Field $observed 'OwnReceipt' ('0'*64)}
    Test-Refused 'a Finish command other than planned is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_FINISH_COMMAND_DIFFERS' -With (New-Variant {param($v)$v.Actionlint='C:\other\actionlint.exe'})
    Test-Refused 'a review text other than committed is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_REVIEW_TEXT_DIFFERS' -With (New-Variant {param($v)$v.ReviewText.Sandbox.ResidualLog='Other.'})
    $hostLog=Join-Path $sandboxRuntime 'finish-host.log'
    Test-Refused 'missing run evidence is refused' Sandbox dryrun 'LIFECYCLE_DRYRUN_EVIDENCE_MISSING:finish-host.log' -Edit {[IO.File]::Move($hostLog,"$hostLog.away")}
    [IO.File]::Move("$hostLog.away",$hostLog)
    Test-Refused 'an Approval the template cannot reproduce is refused' Original dryrun 'LIFECYCLE_DRYRUN_APPROVAL_TEXT_DIFFERS' -With (New-Variant {param($v)$v.OriginalApprovalTemplate='Other {{Root}}.'})
    Test-Refused 'a prediction other than bound is refused' Original dryrun 'LIFECYCLE_DRYRUN_PREDICTION_DIFFERS' -Path $binding -Edit {Set-Field $binding 'PredictedRecipe' ('0'*64)}
}catch{
    if("$_"-cne'FIXTURE_CHAIN_STOPPED'){"FAIL the fixture ran to its end";"  detail: $_ $($_.ScriptStackTrace)";$fail++}
}finally{
    if(Test-Path -LiteralPath $root){$null=Remove-OrvionOwnedTree $root @($parent)}
}
if($fail){"test-contract-lifecycle: $fail failed";exit 1}
'test-contract-lifecycle: all passed'
