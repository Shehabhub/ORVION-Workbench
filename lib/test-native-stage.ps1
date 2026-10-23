# Actual transport/reporter callers on toy Git roots with counted STUB native boundaries.
# These fixtures prove orchestration/refusal only. Synthetic receipts/hooks never prove native certification.
$ErrorActionPreference='Stop';$fail=0
. (Join-Path $PSScriptRoot 'Invoke-DraftSteps.ps1')
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
function Assert-Stage([string]$Name,[bool]$Condition,[string]$Detail=''){if($Condition){"PASS $Name"}else{$script:fail++;"FAIL $Name";if($Detail){$Detail}}}
$tempRoot=Join-Path ([IO.Path]::GetTempPath()) ('orvion-stage-'+[guid]::NewGuid().ToString('N').Substring(0,6))
[void][IO.Directory]::CreateDirectory($tempRoot)
$savedTrailer=$env:ORVION_COMMIT_TRAILER;$env:ORVION_COMMIT_TRAILER=$null
function Read-StageGit([string]$dir,[string[]]$arguments){$o=@(& git -C $dir @arguments 2>$null);if($LASTEXITCODE){throw 'STAGE_FIXTURE_GIT_FAILED'};$o}
function New-StageFixture([string]$Name,[switch]$Outside,[switch]$RefuseBoot,[string]$Clause=''){
    $dir=Join-Path $tempRoot $Name;[void][IO.Directory]::CreateDirectory($dir)
    $null=Read-StageGit $dir @('init','--quiet')
    foreach($pair in @(@('user.name','Stage Fixture'),@('user.email','fixture@invalid.local'),@('core.autocrlf','true'))){$null=Read-StageGit $dir @('config','--local',$pair[0],$pair[1])}
    foreach($part in 'scripts','changes','.githooks'){[void][IO.Directory]::CreateDirectory((Join-Path $dir $part))}
    [IO.File]::WriteAllText((Join-Path $dir 'a.txt'),"baseline`n")
    [IO.File]::WriteAllText((Join-Path $dir '.gitignore'),".orvion-local-certification.json`n")
    [IO.File]::WriteAllText((Join-Path $dir '.githooks/pre-commit'),"#!/bin/sh`nprintf '%s\n' hook >> .git/hook.calls`nexit 0`n")
    $native=@'
param([switch]$Boot,[switch]$Gate,[string]$Root,[string]$BaseRef,[string]$HeadRef)
Add-Content (Join-Path $Root '.git/native.calls') $(if($Boot){'boot'}else{'gate'})
__RESULT__
'@
    $answer=if($RefuseBoot){"'ORVION: BLOCKED';exit 1"}else{"'ORVION: READY';'MODE: EXECUTE';'CR: SPEC-1';'STATUS: Approved';exit 0"}
    [IO.File]::WriteAllText((Join-Path $dir 'scripts/check_agent_continuity.ps1'),$native.Replace('__RESULT__',$answer))
    [IO.File]::WriteAllText((Join-Path $dir 'scripts/generate-ai-map.ps1'),"param([switch]`$Check)`nexit 0`n")
    $null=Read-StageGit $dir @('add','--','a.txt','.gitignore','.githooks/pre-commit','scripts')
    $null=Read-StageGit $dir @('commit','--quiet','-m','toy baseline; native commands are stubs')
    $main=@(Read-StageGit $dir @('rev-parse','HEAD'))[0]
    $Clause=$Clause.Replace('__BASE__',$main)
    $null=Read-StageGit $dir @('config','--local','core.hooksPath','.githooks')
    $wanted=Join-Path $dir 'new.txt';[IO.File]::WriteAllText($wanted,"stage-created-marker`n")
    $step=Get-DraftFileStep $dir 'new.txt' 'stage-created-marker' 'a counted disposable creation fixture'
    [IO.File]::Delete($wanted)
    $target=if($Outside){'a.txt'}else{'new.txt'}
    if(!$Clause){$Clause='blob new.txt '+$step.Blob}
    $body=@"
# SPEC-1 toy transport fixture

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Write Scope

- ``$target``

## Out of Scope

- ``a.txt``

## Implementation Steps

1. $($step.Text)

## Acceptance Criteria

- [ ] Fixture machine observation; ``check: $Clause``

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

None.

## Verification Notes

None.

## Review Gate

- [ ] These counted stub callers do not establish native certification.
"@+"`n"
    $draft=Join-Path $tempRoot "$Name-draft.md";[IO.File]::WriteAllText($draft,$body)
    [IO.File]::Copy($draft,(Join-Path $dir 'changes/SPEC-1-probe.md'))
    $null=Read-StageGit $dir @('add','--','changes/SPEC-1-probe.md');$null=Read-StageGit $dir @('commit','--quiet','-m','toy Approved input under counted hook')
    $blob=@(Read-StageGit $dir @('rev-parse','HEAD:changes/SPEC-1-probe.md'))[0]
    $cfg=Join-Path $tempRoot "$Name.psd1"
    [IO.File]::WriteAllText($cfg,"@{Root='$dir';Main='$main';Id='SPEC-1';Slug='probe';Draft='$draft';Sha='$((Get-FileHash $draft).Hash)';Blob='$blob';User='Stage Fixture';Suffix='toy only';ApprovalNote='synthetic fixture only'}")
    [pscustomobject]@{Root=$dir;Config=$cfg;Draft=$draft;Main=$main;Head=@(Read-StageGit $dir @('rev-parse','HEAD'))[0];Blob=$step.Blob}
}
function New-ApprovalFixture([string]$Name,[string]$ApprovalEvidence){
    $createdFixture=New-StageFixture $Name
    $rel='changes/SPEC-1-probe.md'
    $null=Read-StageGit $createdFixture.Root @('rm','--quiet','--',$rel)
    # Real native repositories retain changes/TEMPLATE.md; git rm removed our toy's only file.
    [void][IO.Directory]::CreateDirectory((Join-Path $createdFixture.Root 'changes'))
    [void][IO.Directory]::CreateDirectory((Join-Path $createdFixture.Root '_ORVION_CANONICAL'))
    [IO.File]::WriteAllText((Join-Path $createdFixture.Root '_ORVION_CANONICAL/manifest.md'),"Active Change Request: None.`nLast Completed: **toy baseline**`n")
    $hook=Join-Path $createdFixture.Root '.githooks/pre-commit'
    [IO.File]::AppendAllText($hook,"`n")
    [IO.File]::WriteAllText($hook,"#!/bin/sh`nprintf '%s\n' hook >> .git/hook.calls`nprintf '%s\n' 'ORVION: READY' 'APPROVAL_EVIDENCE: $ApprovalEvidence'`nexit 0`n")
    $native=Join-Path $createdFixture.Root 'scripts/check_agent_continuity.ps1'
    [IO.File]::WriteAllText($native,"param([switch]`$Boot,[switch]`$Gate,[string]`$Root)`n'ORVION: READY';'MODE: PLAN';'ACTIVE_CR: none';exit 0`n")
    $null=Read-StageGit $createdFixture.Root @('add','--','.githooks/pre-commit','scripts/check_agent_continuity.ps1','_ORVION_CANONICAL/manifest.md')
    $null=Read-StageGit $createdFixture.Root @('commit','--quiet','-m','toy approval boundary; not native certification')
    $main=@(Read-StageGit $createdFixture.Root @('rev-parse','HEAD'))[0]
    $null=Read-StageGit $createdFixture.Root @('remote','add','origin',$createdFixture.Root)
    $null=Read-StageGit $createdFixture.Root @('update-ref','refs/remotes/origin/main',$main)
    $draftText=[IO.File]::ReadAllText($createdFixture.Draft).Replace('[ ] Draft','[x] Draft').Replace('[x] Approved','[ ] Approved')
    $draftText=$draftText.Replace('- `new.txt`','- `new.txt`'+"`n"+'- `_ORVION_CANONICAL/manifest.md`')
    [IO.File]::WriteAllText($createdFixture.Draft,$draftText)
    $blob=@(Read-StageGit $createdFixture.Root @('hash-object',"--path=$rel",'--',$createdFixture.Draft))[0]
    [IO.File]::WriteAllText($createdFixture.Config,"@{Root='$($createdFixture.Root)';Main='$main';Id='SPEC-1';Slug='probe';Draft='$($createdFixture.Draft)';Sha='$((Get-FileHash -LiteralPath $createdFixture.Draft).Hash)';Blob='$blob';User='Stage Fixture';Suffix='toy only';ApprovalNote='synthetic only'}")
    $createdFixture
}
function Invoke-StageFixture($Fixture,[string]$Tool='Invoke-ContractStage.ps1',[string]$Library=$PSScriptRoot,[string]$Stage='implement',[string]$Entry=''){
    $arguments=@('-NoProfile','-File',(Join-Path $Library $Tool),'-Config',$Fixture.Config)
    if($Tool-eq'Invoke-ContractStage.ps1'){$arguments+=@('-Stage',$Stage);if($Entry){$arguments+=@('-EntryFile',$Entry)}}
    $output=@(& pwsh @arguments 2>&1)-join"`n";$exit=$LASTEXITCODE
    [pscustomobject]@{Exit=$exit;Output=$output;FileExists=(Test-Path (Join-Path $Fixture.Root 'new.txt'));Head=@(Read-StageGit $Fixture.Root @('rev-parse','HEAD'))[0]}
}
function Set-StubReceipt($Fixture){
    @{cr='SPEC-1';result='READY';finishHead=@(Read-StageGit $Fixture.Root @('rev-parse','HEAD'))[0]}|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $Fixture.Root '.orvion-local-certification.json')
}
try{
    $positive=New-StageFixture positive;$ok=Invoke-StageFixture $positive
    Assert-Stage 'actual create caller commits exact blob under normal counted hook; no missing HEAD-object assumption' ($ok.Exit-eq0-and$ok.FileExists-and@(Read-StageGit $positive.Root @('rev-parse','HEAD:new.txt'))[0]-ceq$positive.Blob-and@(Get-Content (Join-Path $positive.Root '.git/hook.calls')).Count-eq2)
    $messages=@(Read-StageGit $positive.Root @('log','--format=%B',"$($positive.Main)..HEAD",'--'))-join"`n"
    Assert-Stage 'no invented model/coauthor attribution enters actual commits' ($messages-notmatch'Claude|Anthropic|Co-Authored-By')
    Set-StubReceipt $positive;$review=Invoke-StageFixture $positive 'Test-ContractReview.ps1'
    Assert-Stage 'valid measured diagnostics pass, own CR metadata is implicitly scoped, native Gate is called once' ($review.Exit-eq0-and$review.Output-match'failures=0 unproven=0'-and@(Get-Content (Join-Path $positive.Root '.git/native.calls')|Where-Object{$_-eq'gate'}).Count-eq1)
    foreach($evidence in 'PASS','NOT APPLICABLE'){
        $approval=New-ApprovalFixture ('approval-'+$evidence.Replace(' ','-')) $evidence
        $approved=Invoke-StageFixture $approval -Stage approve
        Assert-Stage "actual approval caller respects native applicability $evidence" ($approved.Exit-eq0-and[IO.File]::ReadAllText((Join-Path $approval.Root 'changes/SPEC-1-probe.md')).Contains('[x] Approved')) $approved.Output
    }
    $missing=New-ApprovalFixture 'approval-missing' 'UNREADABLE';$blocked=Invoke-StageFixture $missing -Stage approve
    Assert-Stage 'unreadable native approval evidence is not treated as approval success' ($blocked.Exit-ne0-and$blocked.Output-match'NATIVE_APPROVAL_EVIDENCE_UNREADABLE') $blocked.Output
    $reviewEntry=Join-Path $tempRoot 'review-entry.txt';[IO.File]::WriteAllText($reviewEntry,'Verdict: Confirmed Complete; counted stub fixture only')
    $ordered=Join-Path $positive.Root 'changes/SPEC-1-probe.md'
    $body=[IO.File]::ReadAllText($ordered);$gate=[regex]::Match($body,'(?ms)^## Review Gate\r?\n.*\z').Value
    $body=$body.Replace($gate,'').Replace('## Execution Log',$gate.TrimEnd()+"`n`n## Execution Log")
    [IO.File]::WriteAllText($ordered,$body);$null=Read-StageGit $positive.Root @('add','--','changes/SPEC-1-probe.md');$null=Read-StageGit $positive.Root @('commit','--quiet','-m','toy alternate legal section order');Set-StubReceipt $positive
    $reviewed=Invoke-StageFixture $positive -Stage review -Entry $reviewEntry
    $notes=[regex]::Match([IO.File]::ReadAllText($ordered),'(?ms)^## Verification Notes\r?\n(.*?)(?=^## |\z)').Groups[1].Value
    Assert-Stage 'review entry belongs to Verification Notes regardless of legal section order' ($reviewed.Exit-eq0-and$notes.Contains('Verdict: Confirmed Complete'))
    $outsideFixture=New-StageFixture outside -Outside;$blocked=Invoke-StageFixture $outsideFixture
    Assert-Stage 'whole Plan rejects an out-of-scope creation before its first write or commit' ($blocked.Exit-ne0-and$blocked.Output-match'DRAFT_PLAN_OUT_OF_SCOPE'-and!$blocked.FileExists-and$blocked.Head-ceq$outsideFixture.Head)
    $dirty=New-StageFixture dirty;[IO.File]::WriteAllText((Join-Path $dirty.Root 'unrelated.txt'),'preserve me');$blocked=Invoke-StageFixture $dirty
    Assert-Stage 'unrelated pre-existing dirt is preserved and never staged' ($blocked.Exit-ne0-and$blocked.Output-match'DIRTY_CHECKOUT'-and!$blocked.FileExists-and@(Read-StageGit $dirty.Root @('diff','--cached','--name-only')).Count-eq0-and[IO.File]::ReadAllText((Join-Path $dirty.Root 'unrelated.txt'))-ceq'preserve me')
    $stale=New-StageFixture stale;[IO.File]::AppendAllText($stale.Draft,'changed');$blocked=Invoke-StageFixture $stale
    Assert-Stage 'every stage rechecks exact selected Draft before native child or implementation' ($blocked.Exit-ne0-and$blocked.Output-match'DRAFT_SHA_MISMATCH'-and!$blocked.FileExists-and!(Test-Path (Join-Path $stale.Root '.git/native.calls')))
    $swapped=New-StageFixture swapped;[IO.File]::AppendAllText($swapped.Draft,"`nUnallocated external revision.`n")
    $swappedConfig=Import-PowerShellDataFile $swapped.Config
    $swappedBlob=@(Read-StageGit $swapped.Root @('hash-object','--path=changes/SPEC-1-probe.md','--',$swapped.Draft))[0]
    [IO.File]::WriteAllText($swapped.Config,"@{Root='$($swapped.Root)';Main='$($swappedConfig.Main)';Id='SPEC-1';Slug='probe';Draft='$($swapped.Draft)';Sha='$((Get-FileHash -LiteralPath $swapped.Draft).Hash)';Blob='$swappedBlob';User='Stage Fixture';Suffix='toy only';ApprovalNote='synthetic only'}")
    $blocked=Invoke-StageFixture $swapped
    Assert-Stage 'consistent replacement config cannot substitute an unallocated selected Draft before native child or writes' ($blocked.Exit-ne0-and$blocked.Output-match'SELECTED_DRAFT_NOT_ALLOCATED'-and!$blocked.FileExists-and$blocked.Head-ceq$swapped.Head-and!(Test-Path (Join-Path $swapped.Root '.git/native.calls')))
    $refusal=New-StageFixture refusal -RefuseBoot;$blocked=Invoke-StageFixture $refusal
    Assert-Stage 'native Boot refusal prevents the literal child and leaves target unchanged' ($blocked.Exit-ne0-and$blocked.Output-match'NATIVE_BOOT_REFUSED'-and!$blocked.FileExists-and$blocked.Head-ceq$refusal.Head)
    Assert-Stage 'native refusal retains its actual evidence for diagnosis' ($blocked.Output-match'ORVION: BLOCKED')
    $wrong=New-StageFixture wrong;$result=Invoke-StageFixture $wrong;if($result.Exit){throw 'STAGE_REVIEW_NEGATIVE_FIXTURE_NOT_VALID'}
    [IO.File]::WriteAllText((Join-Path $wrong.Root 'new.txt'),"wrong content`n");$null=Read-StageGit $wrong.Root @('add','--','new.txt');$null=Read-StageGit $wrong.Root @('commit','--quiet','-m','toy failed criterion');Set-StubReceipt $wrong
    $bad=Invoke-StageFixture $wrong 'Test-ContractReview.ps1'
    Assert-Stage 'printed failed criterion is a nonzero observation even when stub native Gate returns success' ($bad.Exit-eq1-and$bad.Output-match'criterion blob new.txt: FAILS')
    $forbidden=New-StageFixture forbidden;$result=Invoke-StageFixture $forbidden;if($result.Exit){throw 'STAGE_SCOPE_NEGATIVE_FIXTURE_NOT_VALID'}
    [IO.File]::WriteAllText((Join-Path $forbidden.Root 'a.txt'),"forbidden change`n");$null=Read-StageGit $forbidden.Root @('add','--','a.txt');$null=Read-StageGit $forbidden.Root @('commit','--quiet','-m','toy forbidden write');Set-StubReceipt $forbidden
    $bad=Invoke-StageFixture $forbidden 'Test-ContractReview.ps1'
    Assert-Stage 'forbidden range writes cannot become a success exit' ($bad.Exit-eq1-and$bad.Output-match'forbidden paths changed: \[a.txt\]')
    $unknown=New-StageFixture unknown -Clause 'same a.txt __BASE__';$result=Invoke-StageFixture $unknown;if($result.Exit){throw 'STAGE_UNKNOWN_FIXTURE_NOT_VALID'};Set-StubReceipt $unknown
    $bad=Invoke-StageFixture $unknown 'Test-ContractReview.ps1'
    Assert-Stage 'unsupported diagnostic checks stay explicit UNPROVEN, not a duplicate native engine or false pass' ($bad.Exit-eq2-and$bad.Output-match'UNPROVEN: native checks outside')
    $mutantLib=Join-Path $tempRoot 'mutants';[void][IO.Directory]::CreateDirectory($mutantLib)
    foreach($file in 'Invoke-ContractStage.ps1','Test-ContractReview.ps1','lifecycle.ps1','Invoke-DraftSteps.ps1','apply-draft-steps.ps1'){[IO.File]::Copy((Join-Path $PSScriptRoot $file),(Join-Path $mutantLib $file))}
    $path=Join-Path $mutantLib 'Invoke-ContractStage.ps1';$body=[IO.File]::ReadAllText($path);$needle="if(`$file.File-notin`$scope){throw 'DRAFT_PLAN_OUT_OF_SCOPE'}";if(!$body.Contains($needle)){throw 'STAGE_SCOPE_MUTANT_ANCHOR'};[IO.File]::WriteAllText($path,$body.Replace($needle,''))
    $escaped=New-StageFixture escaped -Outside;$bad=Invoke-StageFixture $escaped -Library $mutantLib
    Assert-Stage 'causal removal mutant exposes first unscoped write, even though the later scope guard still refuses its commit' ($bad.Exit-ne0-and$bad.FileExists-and$bad.Head-ceq$escaped.Head)
    $path=Join-Path $mutantLib 'Test-ContractReview.ps1';$body=[IO.File]::ReadAllText($path);$needle='if(!$ok){$failed++}';if(!$body.Contains($needle)){throw 'STAGE_REVIEW_MUTANT_ANCHOR'};[IO.File]::WriteAllText($path,$body.Replace($needle,''))
    $bad=Invoke-StageFixture $wrong 'Test-ContractReview.ps1' $mutantLib
    Assert-Stage 'causal removal mutant returns false success for the exact failed-criterion observation' ($bad.Exit-eq0-and$bad.Output-match'criterion blob new.txt: FAILS')
    $path=Join-Path $mutantLib 'Invoke-ContractStage.ps1';$body=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Invoke-ContractStage.ps1'))
    $needle="if(`$allocation.Count-ne1-or(Invoke-RepoGit @('rev-parse',`"`$(`$allocation[0]):`$ContractRel`"))-cne`$cfg.Blob){throw 'SELECTED_DRAFT_NOT_ALLOCATED'}"
    if(!$body.Contains($needle)){throw 'STAGE_ALLOCATION_MUTANT_ANCHOR'};[IO.File]::WriteAllText($path,$body.Replace($needle,''))
    $bad=Invoke-StageFixture $swapped -Library $mutantLib
    Assert-Stage 'causal removal of allocation binding allows the exact unallocated revision to execute' ($bad.Exit-eq0-and$bad.FileExists-and$bad.Head-cne$swapped.Head)
}finally{
    $env:ORVION_COMMIT_TRAILER=$savedTrailer
    $resolved=[IO.Path]::GetFullPath($tempRoot)
    $allowedTemp=[IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\')
    if((Split-Path $resolved -Parent)-cne$allowedTemp-or(Split-Path $resolved -Leaf)-notlike'orvion-stage-*'){throw 'STAGE_TEST_CLEANUP_BOUNDARY'}
    # Reuse the existing owned-tree helper: Windows Git objects may be read-only.
    $null=Remove-OrvionOwnedTree -Path $resolved -AllowedRoots @($allowedTemp)
}
if($fail){throw "NATIVE_STAGE_CALLERS_FAILED:$fail"};'NATIVE_STAGE_CALLERS PASS (stub boundaries only, not native certification)'
