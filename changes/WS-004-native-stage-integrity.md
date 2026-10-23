# Workbench Change Request - WS-004

## Status

[x] Draft
[ ] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Make existing native stage transport and its pre-Review diagnostic refuse unsafe or unproven evidence, create exact scoped files, preserve native authority and expose truthful tool discovery.

## Baseline

1822947e936198453181ef7efb8585289ddb47b0

## Write Scope

- RESUME.md
- lib/Invoke-ContractStage.ps1
- lib/Test-ContractReview.ps1
- lib/test-native-stage.ps1
- lib/README.md
- WORKFLOW.md

## Out of Scope

Native product/trusted originals, their contracts, engines, profiles, tests, receipts, release and remote state; completed WS001-003 history and own checker/recipe/driver; global settings, authentication, credentials, archives and event journal; full management entry, scheduler, monitor engine, storage migration/deletion, workstation/ContractC, Batch6 and Phase8. RESUME authority body remains unchanged; only this contract's own legal active pointer transitions are permitted. Native compatibility experiment modifies only its disposable clone, never an original product.

## Required Reading

Accepted WORKFLOW.md, lib/README.md and affected adapters; V1-DESIGN.md, SOURCE-DECISIONS.md and actual WS004 prechecks/callers/native-proof evidence. P3 G2c step1/G3 remains the sole owning acceptance map. Reuse completed recipe/approval/resource and observer foundations; no whole-programme research or completed product-suite replay.

## Draft Assurance

V1: WS-NATIVE-STAGE-R2-V1-DESIGN | 2026-10-23 | C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-stage-integrity-20261023-r2\V1-DESIGN.md | 0B0535870E6401CF1B833D63EA0D16DD2C228523B38FF69F592FEA001BB6C896
V2: WS-NATIVE-STAGE-R2-V2-ADVERSARIAL | 2026-10-23 | C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-stage-integrity-20261023-r2\V2-DRAFT.md | 0F30007FA9B3D8F1DA4E75152A8EE8BDAB43EDCD49B19779402227AC30E23F6F
V3: WS-NATIVE-STAGE-R2-V3-REFRESH | 2026-10-23 | C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-stage-integrity-20261023-r2\V3-DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WS004
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WS004\tests
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WS004\temp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-stage-integrity-20261023-r2\runtime
PowerShell Version: 7.6.7
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Pre-Approval Evidence

Actual old caller probes reproduced missing HEAD:new-file and diagnostic exit0 despite failed criterion/forbidden paths. Focused positive/refusal/causal callers run the real adapters against explicitly counted toy boundaries; none is native certification. Actual independent disabled-push Founder clone uses unchanged native hooks/engine, exact allocation, created file and native scope, fresh timed/watched REPOSITORY Finish, direct live Review, Complete and native range/binding. Native-protocol findings were repaired in the disposable proposal: legitimate NOT APPLICABLE must not become a wrapper failure, refusal output must survive, and legal section order must not misplace Review evidence. Original primary files are unchanged.

Failed focus-v1 read-only-object cleanup, focus-v3/v4 incomplete toy scaffolding and focus-v5 scalar/array verdict mismatch remain preserved. R1's actual selection-precheck accepted a self-consistent replacement Draft/config despite a different allocated Git blob; its candidate/rehearsal is retained without any full own Finish or original authority. R2 binds every post-allocation stage to the actual unique Git allocation before Boot/writes and adds its blocked case/causal removal mutant. Reuse existing remove-owned helper instead of another deletion engine; early all-source hazard scan precedes this construction. The focused caller suite avoids repeatedly running unrelated process-kill cases during iteration; the existing full schedule still owns those cases. These preparations are not the selected Workbench's own full closure: exact literal replay and own normal-hook sandbox Finish/Review/Complete/range must succeed before an honest delegated original decision.

## Implementation Steps

1. Check whether `lib/Invoke-ContractStage.ps1` contains `NATIVE_APPROVAL_EVIDENCE_UNREADABLE`; if so record Already Applied when its Git blob is ab5f391ce3ad70a444f264a0d02f83a8af9a4524, and otherwise stop and report. Otherwise make exactly these 16 edits (bounded native transport with truthful evidence and no native engine duplication), each matched once, and change nothing else:

   a) replace the line
   ```text
   # ponytail: edits to existing files only; a Draft that creates a file needs a create step added here.
   ```
   with
   ```text
   # Creation uses the existing applier's complete read-only Plan; this adapter never invents literal edits.
   ```

   b) immediately after the line
   ```text
   . (Join-Path $PSScriptRoot 'lifecycle.ps1')
   ```
   insert
   ```text
   . (Join-Path $PSScriptRoot 'Invoke-DraftSteps.ps1')
   ```

   c) replace the line
   ```text
   function Invoke-RepoGit([string[]]$GitArgs){$o=& git -C $r @GitArgs 2>$null;if($LASTEXITCODE){throw "git $($GitArgs-join' ') failed ($LASTEXITCODE)"};$o}
   ```
   with
   ```text
   function Invoke-RepoGit([string[]]$GitArgs){$o=& git -C $r -c core.quotepath=false @GitArgs 2>$null;if($LASTEXITCODE){throw "git $($GitArgs-join' ') failed ($LASTEXITCODE)"};$o}
   ```

   d) replace the lines
   ```text
       Invoke-RepoGit @('add','-A')|Out-Null
       $trailer="Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>";if($env:ORVION_COMMIT_TRAILER){$trailer+="`n$env:ORVION_COMMIT_TRAILER"}
       $out=& git -C $r commit -q -m "$Message`n`n$trailer" 2>&1|Out-String;$code=$LASTEXITCODE
   ```
   with
   ```text
       Assert-StageScope
       $targets=@($allowedPaths|Where-Object{(Test-Path -LiteralPath (Get-DraftTargetPath $r $_))-or@(Invoke-RepoGit @('ls-files','--',$_)).Count})
       if(!$targets.Count){throw 'NO_SCOPED_COMMIT_TARGETS'}
       Invoke-RepoGit (@('add','-A','--')+$targets)|Out-Null
       Assert-StageScope
       # Git owns actual authorship. Only explicit operator text is retained; no invented model identity.
       $messageText=if($env:ORVION_COMMIT_TRAILER){"$Message`n`n$env:ORVION_COMMIT_TRAILER"}else{$Message}
       $out=& git -C $r commit -q -m $messageText 2>&1|Out-String;$code=$LASTEXITCODE
   ```

   e) replace the lines
   ```text
   # The files the Draft's steps change, with the blob each step must produce.
   function Get-DraftFiles{$t=[IO.File]::ReadAllText($cfg.Draft)-replace"`r`n","`n"
       $o=[ordered]@{};foreach($m in [regex]::Matches($t,'(?ms)^\d+\. Check whether `([^`]+)` contains.*?The resulting file''s Git blob is ([0-9a-f]{40})')){$o[$m.Groups[1].Value]=$m.Groups[2].Value};$o}
   ```
   with
   ```text
   function Add-StageEntry([string]$SectionText,[string]$Heading,[string]$Entry){
       # Legal native contracts need not put Review Gate after Verification Notes.
       $sections=[regex]::Matches($SectionText,('(?ms)^## '+[regex]::Escape($Heading)+'\r?\n.*?(?=^## |\z)'))
       if($sections.Count-ne1){throw 'NATIVE_ENTRY_SECTION_AMBIGUOUS'}
       $nl=Get-Newline $SectionText
       $SectionText.Insert($sections[0].Index+$sections[0].Length,$nl+$Entry+$nl+$nl)
   }
   # The native contract owns scope; the accepted applier owns literal grammar and whole-plan preflight.
   function Get-DeclaredScope([string]$ScopeText){
       $section=[regex]::Match(($ScopeText-replace"`r`n","`n"),'(?s)## Write Scope\s+(.+?)\n## ')
       if(!$section.Success){throw 'WRITE_SCOPE_MISSING'}
       @($section.Groups[1].Value-split"`n"|Where-Object{$_-match'^- `'}|ForEach-Object{($_-replace'^- `([^`]+)`.*$','$1')-replace'\\','/'})
   }
   function Assert-StageScope{
       $changed=@(Invoke-RepoGit @('diff','--name-only','--no-renames','--'))+@(Invoke-RepoGit @('diff','--cached','--name-only','--no-renames','--'))+@(Invoke-RepoGit @('ls-files','--others','--exclude-standard'))
       if(@($changed|Where-Object{$_-notin$allowedPaths}).Count){throw 'OUT_OF_SCOPE_WRITE: refuses before staging unrelated paths'}
   }
   function Read-LiteralPlan{
       $json=& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'apply-draft-steps.ps1') -Draft $cfg.Draft -Root $r -Plan 2>&1|Out-String
       if($LASTEXITCODE){throw 'DRAFT_PLAN_REFUSED'}
       $plan=$json|ConvertFrom-Json
       if($plan.Schema-ne1-or$plan.DraftSHA256-cne$cfg.Sha-or$plan.Root-cne[IO.Path]::GetFullPath($r)-or!@($plan.Files).Count){throw 'DRAFT_PLAN_IDENTITY_MISMATCH'}
       foreach($file in $plan.Files){$null=Get-DraftTargetPath $r $file.File;if($file.File-notin$scope){throw 'DRAFT_PLAN_OUT_OF_SCOPE'}}
       $plan
   }
   ```

   f) replace the lines
   ```text
   if((git -C $r rev-parse --show-toplevel)-ne($r-replace'\\','/')){throw 'ROOT_MISMATCH'}
   if((git -C $r config user.name)-ne$cfg.User){throw 'IDENTITY_MISMATCH'}
   ```
   with
   ```text
   if(!(Test-Path -LiteralPath $r -PathType Container)-or!([IO.Path]::IsPathFullyQualified($r))){throw 'ROOT_MISMATCH'}
   if((Invoke-RepoGit @('rev-parse','--show-toplevel'))-ne($r-replace'\\','/')){throw 'ROOT_MISMATCH'}
   if((Invoke-RepoGit @('config','user.name'))-ne$cfg.User){throw 'IDENTITY_MISMATCH'}
   if(Invoke-RepoGit @('status','--porcelain')){throw 'DIRTY_CHECKOUT'}
   if((Invoke-RepoGit @('config','--get','core.hooksPath'))-cne'.githooks'-or!(Test-Path -LiteralPath (Join-Path $r '.githooks/pre-commit') -PathType Leaf)){throw 'NORMAL_NATIVE_HOOK_REQUIRED'}
   if($Id-notmatch'^SPEC-\d+$'-or$cfg.Slug-notmatch'^[a-z0-9][a-z0-9-]*$'-or$cfg.Main-cnotmatch'^[0-9a-f]{40}$'-or$cfg.Sha-cnotmatch'^[0-9A-F]{64}$'-or$cfg.Blob-cnotmatch'^[0-9a-f]{40}$'){throw 'CONFIG_IDENTITY_INVALID'}
   if((Get-FileHash -LiteralPath $cfg.Draft -Algorithm SHA256).Hash-cne$cfg.Sha){throw 'DRAFT_SHA_MISMATCH'}
   if((Invoke-RepoGit @('hash-object',"--path=$ContractRel",'--',$cfg.Draft))-cne$cfg.Blob){throw 'DRAFT_FILTERED_BLOB_MISMATCH'}
   if($Stage-cne'approve'){
       $allocation=@(Invoke-RepoGit @('log','--diff-filter=A','--format=%H','--',$ContractRel))
       if($allocation.Count-ne1-or(Invoke-RepoGit @('rev-parse',"$($allocation[0]):$ContractRel"))-cne$cfg.Blob){throw 'SELECTED_DRAFT_NOT_ALLOCATED'}
   }
   $scope=Get-DeclaredScope ([IO.File]::ReadAllText($cfg.Draft));$allowedPaths=@($scope)+@($ContractRel)
   foreach($path in $allowedPaths){$null=Get-DraftTargetPath $r $path}
   foreach($path in $Retired){$null=Get-DraftTargetPath $r $path;if($path-notin$scope){throw 'RETIRED_OUT_OF_SCOPE'}}
   $native=Join-Path $r 'scripts/check_agent_continuity.ps1'
   if(!(Test-Path -LiteralPath $native -PathType Leaf)){throw 'NATIVE_BOOT_UNAVAILABLE'}
   $boot=& pwsh -NoProfile -File $native -Root $r -Boot 2>&1|Out-String
   $bootCode=$LASTEXITCODE
   # Even refusal must preserve the native ACTION/WRITE/context and named blocker.
   $boot
   Write-Say ("NATIVE BOOT exit=$bootCode : "+(Get-Brief $boot))
   if($bootCode-or$boot-notmatch'(?m)^ORVION: READY\r?$'){throw 'NATIVE_BOOT_REFUSED'}
   if($Stage-in'implement','review','complete'){
       if($boot-notmatch("(?m)^CR: "+[regex]::Escape($Id)+"\r?$")-or$boot-notmatch'(?m)^MODE: (EXECUTE|VERIFY)\r?$'){throw 'NATIVE_BOOT_SUBJECT_NOT_ACTIVE'}
   }
   ```

   g) replace the line
   ```text
       if((git -C $r hash-object --no-filters $cfg.Draft)-ne$cfg.Blob){throw 'DRAFT_BLOB_MISMATCH'}
   ```
   with
   ```text
       if((Invoke-RepoGit @('hash-object',"--path=$ContractRel",'--',$cfg.Draft))-ne$cfg.Blob){throw 'DRAFT_BLOB_MISMATCH'}
   ```

   h) replace the line
   ```text
       Write-Say "preconditions: sha256 $h = approved; blob $($cfg.Blob); HEAD = origin/main = $head; clean; $n source anchors match"
   ```
   with
   ```text
       Write-Say "preconditions: sha256 $h = approved; blob $($cfg.Blob); HEAD=$head; origin/main=$om; clean; $n source anchors match"
   ```

   i) replace the line
   ```text
       $t=Add-ToSection $t 'Verification Notes' ("### $(Get-Date -Format yyyy-MM-dd) — Gate 1 approval recorded${nl}${nl}$($cfg.ApprovalNote) Immediately before allocation the hash, the Draft blob $($cfg.Blob), all $n source anchors, the baseline HEAD $($cfg.Main) against refreshed origin/main $om and a clean checkout were revalidated, and the pre-commit allocator admitted the identity; Draft allocated as $($alloc.Substring(0,7)). No implementation performed before this transition. Batch 6 remains ON HOLD; CTRL-19 remains OPEN.")
   ```
   with
   ```text
       $t=Add-StageEntry $t 'Verification Notes' ("### $(Get-Date -Format yyyy-MM-dd) — Gate 1 approval recorded${nl}${nl}$($cfg.ApprovalNote) Immediately before allocation the hash, the Draft blob $($cfg.Blob), all $n source anchors, the baseline HEAD $($cfg.Main) against refreshed origin/main $om and a clean checkout were revalidated, and the pre-commit allocator admitted the identity; Draft allocated as $($alloc.Substring(0,7)). No implementation performed before this transition. Batch 6 remains ON HOLD; CTRL-19 remains OPEN.")
   ```

   j) replace the lines
   ```text
       $out=Save-Commit "${Id}: Approve exact frozen contract ($($cfg.Suffix))"
       if($out-notmatch'APPROVAL_EVIDENCE: PASS'){throw 'APPROVAL_EVIDENCE_NOT_PASS'}
   ```
   with
   ```text
       $out=(Save-Commit "${Id}: Approve exact frozen contract ($($cfg.Suffix))")-join"`n"
       # The native engine derives applicability. A REPOSITORY-only scope legitimately reports NOT APPLICABLE.
       if($out-notmatch'(?m)^ORVION: READY\r?$'-or$out-notmatch'(?m)^APPROVAL_EVIDENCE: (PASS|NOT APPLICABLE)\r?$'){throw 'NATIVE_APPROVAL_EVIDENCE_UNREADABLE'}
   ```

   k) replace the lines
   ```text
       $files=Get-DraftFiles;if(!$files.Count){throw 'NO_FILE_STEPS'}
       foreach($f in $files.Keys){if((Invoke-RepoGit @('rev-parse',"HEAD:$f"))-eq$files[$f]){throw "ALREADY_APPLIED $f"}}
   ```
   with
   ```text
       $plan=Read-LiteralPlan;$files=[ordered]@{}
       foreach($file in $plan.Files){if($file.Skip){throw "ALREADY_APPLIED $($file.File)"};$files[$file.File]=$file.Blob}
   ```

   l) replace the lines
   ```text
       $scope=[regex]::Match($t,'(?s)## Write Scope\s+(.+?)\n## ').Groups[1].Value-split"`r?`n"|Where-Object{$_-match'^- `'}|ForEach-Object{($_-replace'^- `|`$','')}
       Invoke-RepoGit @('add','-A')|Out-Null
       $changed=@(Invoke-RepoGit @('diff','--cached','--name-only'));$outside=@($changed|Where-Object{$_-notin$scope});if($outside){throw "OUT_OF_SCOPE $($outside-join',')"}
       $num=@{};foreach($s in @(Invoke-RepoGit (@('diff','--cached','--numstat','--')+@($files.Keys)))){$p=$s-split"`t";$num[$p[2]]="$($p[0]) insertions, $($p[1]) deletions"}
   ```
   with
   ```text
       Assert-StageScope
       $num=@{};foreach($s in @(Invoke-RepoGit (@('diff','--numstat','--')+@($files.Keys)))){$p=$s-split"`t";$num[$p[2]]="$($p[0]) insertions, $($p[1]) deletions"}
       foreach($file in $plan.Files|Where-Object Create){$num[$file.File]="$(@([IO.File]::ReadAllLines((Join-Path $r $file.File))).Count) insertions, 0 deletions (created)"}
   ```

   m) replace the line
   ```text
       $lines=@("- Step 1 Applied: the owner's Gate 1 approval names this exact Draft's SHA-256; the baseline HEAD was $($cfg.Main) and every source anchor matched there; Draft allocated as $alloc and approved as $appr with APPROVAL_EVIDENCE: PASS.")
   ```
   with
   ```text
       $lines=@("- Step 1 Applied: native recorded Gate 1 evidence names this exact Draft's SHA-256; the baseline HEAD was $($cfg.Main) and every source anchor matched there; Draft allocated as $alloc and approved as $appr with APPROVAL_EVIDENCE: PASS.")
   ```

   n) replace the lines
   ```text
       $e="### $(Get-Date -Format yyyy-MM-dd) — Implementation checkpoint (Claude)${nl}${nl}Outcome: Complete (implementation steps; final verification pending)${nl}${nl}"+($lines-join$nl)
       $t=Add-ToSection $t 'Verification Notes' $e;$t=Set-Once $t "Resume Step: 1$nl" "Resume Step: DONE$nl" 'checkpoint';Write-RepoText $r $ContractRel $t
   ```
   with
   ```text
       $e="### $(Get-Date -Format yyyy-MM-dd) — Implementation checkpoint (governed automation)${nl}${nl}Outcome: Complete (implementation steps; final verification pending)${nl}${nl}"+($lines-join$nl)
       $t=Add-StageEntry $t 'Execution Log' $e;$t=Set-Once $t "Resume Step: 1$nl" "Resume Step: DONE$nl" 'checkpoint';Write-RepoText $r $ContractRel $t
   ```

   o) replace the line
   ```text
       $t=Read-RepoText $r $ContractRel;Write-RepoText $r $ContractRel (Add-ToSection $t 'Review Gate' $e)
   ```
   with
   ```text
       $t=Read-RepoText $r $ContractRel;Write-RepoText $r $ContractRel (Add-StageEntry $t 'Verification Notes' $e)
   ```

   p) replace the line
   ```text
       $t=[regex]::Replace($t,'(?m)^- \[ \] ','- [x] ');$t=Add-ToSection $t 'Verification Notes' (Get-Entry);Write-RepoText $r $ContractRel $t
   ```
   with
   ```text
       $t=[regex]::Replace($t,'(?m)^- \[ \] ','- [x] ');$t=Add-StageEntry $t 'Verification Notes' (Get-Entry);Write-RepoText $r $ContractRel $t
   ```

   The resulting file's Git blob is ab5f391ce3ad70a444f264a0d02f83a8af9a4524.

2. Check whether `lib/Test-ContractReview.ps1` contains `REVIEW_DIAGNOSTICS:`; if so record Already Applied when its Git blob is 06df20cba2312d3b1058f4ed2cd30a6e983a7692, and otherwise stop and report. Otherwise make exactly these 10 edits (bounded native transport with truthful evidence and no native engine duplication), each matched once, and change nothing else:

   a) replace the line
   ```text
   # Execution Log. Takes the same .psd1 as Invoke-ContractStage.ps1. Generalised from CR B's review-checks.ps1.
   ```
   with
   ```text
   # Execution Log. Pre-Review observations only, not certification or a replacement native criterion engine.
   # Exit 1 on an observed failure, 2 on required evidence this adapter cannot establish, 0 for its measured class only.
   ```

   b) replace the lines
   ```text
   $cfg=Import-PowerShellDataFile $Config;$r=$cfg.Root;$Rel="changes/$($cfg.Id)-$($cfg.Slug).md"
   function Invoke-RepoGit([string[]]$GitArgs){$o=& git -C $r @GitArgs 2>$null;if($LASTEXITCODE){throw "git $($GitArgs-join' ') failed ($LASTEXITCODE)"};$o}
   ```
   with
   ```text
   $cfg=Import-PowerShellDataFile $Config;$r=$cfg.Root;$Rel="changes/$($cfg.Id)-$($cfg.Slug).md";$failed=0;$unproven=0
   function Invoke-RepoGit([string[]]$GitArgs){$o=& git -C $r -c core.quotepath=false @GitArgs 2>$null;if($LASTEXITCODE){throw "git $($GitArgs-join' ') failed ($LASTEXITCODE)"};$o}
   if(Invoke-RepoGit @('status','--porcelain')){$failed++;'FAIL dirty pre-Review subject'}
   ```

   c) replace the lines
   ```text
   "outside Write Scope: [$((@($changed|Where-Object{$_-notin$scope}))-join', ')]"
   "forbidden paths changed: [$((@($changed|Where-Object{$_-in$forbidden}))-join', ')] of $($forbidden.Count) listed"
   ```
   with
   ```text
   $outside=@($changed|Where-Object{$_-ne$Rel-and$_-notin$scope});if($outside.Count){$failed++}
   $forbiddenChanged=@($changed|Where-Object{$_-ne$Rel-and$_-in$forbidden});if($forbiddenChanged.Count){$failed++}
   "outside Write Scope: [$($outside-join', ')]"
   "forbidden paths changed: [$($forbiddenChanged-join', ')] of $($forbidden.Count) listed"
   ```

   d) replace the line
   ```text
   $alloc=Invoke-RepoGit @('log','--diff-filter=A','--format=%H','--',$Rel);"allocation $alloc stores blob $(Invoke-RepoGit @('rev-parse',"${alloc}:$Rel")) (approved $($cfg.Blob))"
   ```
   with
   ```text
   $alloc=@(Invoke-RepoGit @('log','--diff-filter=A','--format=%H','--',$Rel));if($alloc.Count-ne1){throw 'REVIEW_ALLOCATION_AMBIGUOUS'};$alloc=$alloc[0]
   $allocatedBlob=Invoke-RepoGit @('rev-parse',"${alloc}:$Rel");if($allocatedBlob-cne$cfg.Blob){$failed++}
   if((Get-FileHash -LiteralPath $cfg.Draft).Hash-cne$cfg.Sha){$failed++;'FAIL selected Draft identity'}
   "allocation $alloc stores blob $allocatedBlob (approved $($cfg.Blob))"
   ```

   e) replace the line
   ```text
   "contract lines removed outside Status/Checkpoint/checkboxes/empty logs: $($bad.Count) $($bad-join' / ')"
   ```
   with
   ```text
   "contract removed-line diagnostic: $($bad.Count); native range Gate owns frozen text and legal transition judgment"
   ```

   f) replace the lines
   ```text
   foreach($m in [regex]::Matches($ac,'`check: (blob|has|lacks) (\S+) (?:"((?:[^"])+)"|([0-9a-f]{40}))`')){
       $k=$m.Groups[1].Value;$p=$m.Groups[2].Value;$text=(Invoke-RepoGit @('show',"${head}:$p"))-join"`n"
   ```
   with
   ```text
   $checks=@([regex]::Matches($ac,'`check: (blob|has|lacks) (\S+) (?:"((?:[^"])+)"|([0-9a-f]{40}))`'))
   $clauses=[regex]::Matches($ac,'`check: ').Count
   if($clauses-ne$checks.Count){$unproven++;'UNPROVEN: native checks outside this diagnostic adapter; use native authority, never infer a pass'}
   foreach($m in $checks){
       $k=$m.Groups[1].Value;$p=$m.Groups[2].Value
       if($p.Contains('#')){$unproven++;'UNPROVEN: keyed native check requires its native authority';continue}
       $text=(Invoke-RepoGit @('show',"${head}:$p"))-join"`n"
   ```

   g) replace the line
   ```text
       "criterion {0} {1}: {2}" -f $k,$p,$(if($ok){'holds'}else{'FAILS'})
   ```
   with
   ```text
       if(!$ok){$failed++};"criterion {0} {1}: {2}" -f $k,$p,$(if($ok){'holds'}else{'FAILS'})
   }
   if($FinishLog){
       $finish=[IO.File]::ReadAllText($FinishLog)
       if($finish-notmatch'LOCAL_CERTIFY: READY'-or$finish-notmatch'END exit=0'){$failed++;'FAIL supplied Finish log lacks its successful native result/END'}
       "finish log: "+((Get-Content -LiteralPath $FinishLog|Where-Object{$_-match'LOCAL_CERTIFY:|RESOURCES:|END exit=|EXIT'})-join' | ')
   ```

   h) replace the lines
   ```text
   }
   if($FinishLog){"finish log: "+((Get-Content -LiteralPath $FinishLog|Where-Object{$_-match'LOCAL_CERTIFY:|^RESOURCES:|^END|EXIT'})-join' | ')}
   ```
   with
   ```text
   }
   ```

   i) immediately after the line
   ```text
   $rc=Get-Content -Raw (Join-Path $r '.orvion-local-certification.json')|ConvertFrom-Json
   ```
   insert
   ```text
   if($rc.cr-cne$cfg.Id-or$rc.result-cne'READY'){$failed++}
   if($rc.finishHead-cne$head){$unproven++;'UNPROVEN: not the exact pre-Review Finish head; later metadata/binding is judged by native authority'}
   ```

   j) immediately after the line
   ```text
   "receipt: cr=$($rc.cr) result=$($rc.result) finishHead=$($rc.finishHead) fresh=$($rc.finishHead-eq$head)"
   ```
   insert
   ```text
   $native=Join-Path $r 'scripts/check_agent_continuity.ps1'
   if(!(Test-Path -LiteralPath $native -PathType Leaf)){$unproven++;'UNPROVEN: native range Gate unavailable'}else{
       $gate=& pwsh -NoProfile -File $native -Root $r -Gate -BaseRef $cfg.Main -HeadRef $head 2>&1|Out-String
       $gateCode=$LASTEXITCODE;$gate
       if($gateCode-or$gate-notmatch'(?m)^ORVION: READY\r?$'){$failed++;'FAIL native range Gate'}
   }
   "REVIEW_DIAGNOSTICS: failures=$failed unproven=$unproven. Native gates/receipts and independent actual review remain mandatory; no descriptive criterion was auto-approved."
   exit $(if($failed){1}elseif($unproven){2}else{0})
   ```

   The resulting file's Git blob is 06df20cba2312d3b1058f4ed2cd30a6e983a7692.

3. Check whether `lib/test-native-stage.ps1` contains `NATIVE_STAGE_CALLERS PASS`; if so record Already Applied when its Git blob is 05607a9276fc184e518d137b8d41dac556cf5aa5, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (bounded native transport with truthful evidence and no native engine duplication), and change nothing else:

   ```text
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
   ```

   The resulting file's Git blob is 05607a9276fc184e518d137b8d41dac556cf5aa5.

4. Check whether `lib/README.md` contains `bounded native transport:`; if so record Already Applied when its Git blob is c5902682912d4ebaf8632aefdfd2e03dccab20a4, and otherwise stop and report. Otherwise make exactly these 3 edits (bounded native transport with truthful evidence and no native engine duplication), each matched once, and change nothing else:

   a) replace the line
   ```text
   | `..\tests.ps1` | every check: hazard scan of all scripts + each `test-*.ps1` (pre-commit runs it) |
   ```
   with
   ```text
   | `..\tests.ps1` | sole full closure schedule: hazards plus each owning test suite; only own timed Finish may launch it with the bound recipe. The normal hook checks admission/freshness, not another full run. |
   ```

   b) replace the lines
   ```text
   | `Invoke-ContractStage.ps1 -Config <x>.psd1 -Stage approve|implement|review|complete|bind` | executes an owner-approved Draft on the real checkout; every git read throws on failure |
   | `Test-ContractReview.ps1 -Config <x>.psd1 [-FinishLog <log>]` | read-only live-Git Review checks (scope, authors, allocation blob, every criterion) |
   ```
   with
   ```text
   | `Invoke-ContractStage.ps1 -Config <x>.psd1 -Stage approve|implement|review|complete|bind` | bounded native transport: exact selected Draft/filter identity, native Boot and normal hooks before transitions; whole applier Plan before writes, declared paths only, actual Git authorship. Native gates remain authority. |
   | `Test-ContractReview.ps1 -Config <x>.psd1 [-FinishLog <log>]` | read-only pre-Review diagnostics plus one native range Gate; exit1 observed failure, exit2 UNPROVEN/unsupported evidence, exit0 only for the measured class. Never certifies all descriptive/native criteria or replaces independent Review. |
   ```

   c) immediately after the lines
   ```text
   | `lifecycle.ps1` (dot-source) | shared helpers, including `Stop-ProcessTreeFully` |

   ```
   insert
   ```text
   These are the Workbench agent's adapters. Direct entry into one product uses that product's own tools only.
   An explicitly selected native transport config names the exact Root, baseline, native SPEC/slug, selected Draft,
   raw SHA256, filtered allocation blob and configured Git user; every post-allocation stage matches that blob to
   its single actual Git allocation before invoking a native child or writing. Do not infer a target from an old folder or another
   SPEC with the same number. Read the actual native Boot ACTION/WRITE/START_CONTEXT or refusal preserved by the
   adapter. Creation uses the existing literal applier's whole Plan; absent HEAD content is not a creation failure.
   Never rerun approve after a diagnostic failure without inspecting actual commits/status: a native transition
   may already have succeeded. Native applicability can truthfully be PASS or NOT APPLICABLE; the adapter cannot
   grant an exemption. Existing explicit retirement remains scoped, and no invented model/coauthor enters commits.

   After implementation commit/DONE, invoke that selected repository's own timed/watched Finish exactly once;
   this stage adapter schedules none of its child tests. Independently inspect actual criteria and its own fresh
   receipt, supply the real review entry, Complete, then native bind. Failed/unknown diagnostics are visible;
   unsupported checks require their owning native evidence, not fabricated approval or a copied criterion engine.
   Entry appends name their owning legal section regardless of section order. Reuse existing lifecycle/process and
   owned-fixture cleanup helpers. `test-native-stage.ps1` owns focused stub-boundary positives/refusals/mutants;
   those fixtures never substitute for a real native lifecycle or an original receipt. General single/multi-target
   management, observer handles, recipe bridging and partial recovery remain governed by P3 G2c and are not supplied
   by this prerequisite. New tools must enter through the existing tested governance; this index is discovery only.

   ```

   The resulting file's Git blob is c5902682912d4ebaf8632aefdfd2e03dccab20a4.

5. Check whether `WORKFLOW.md` contains `Native stage transport:`; if so record Already Applied when its Git blob is a4393df944645813c33108f670ad4006b41fc471, and otherwise stop and report. Otherwise make exactly this one edit (bounded native transport with truthful evidence and no native engine duplication), each matched once, and change nothing else:

   a) replace the line
   ```text
   Sources: Git githooks and git-write-tree manuals; SLSA v1.2 artifact verification informs subject/input expectations. This is not a claim of SLSA compliance, signature verification, owner authentication or tamper resistance against equal OS privileges.
   ```
   with
   ```text
   Native stage transport: lib/README.md identifies the existing agent adapters and their evidence limits. An explicit exact config selects one native root/contract; raw Draft SHA256 and destination-filtered blob, clean root, native Boot and normal .githooks precede mutation. Preserve native ACTION/WRITE/START_CONTEXT and refusal output. The existing applier Plan owns creation and literal grammar; scope is checked before writes, only declared paths are staged, and Git owns actual authorship. Native applicability is derived by the native engine, never forced to PASS by this adapter. Appends target legal section names, not an assumed section order. Finish, profiles, tests, receipt validation, Review/Complete and binding remain native; no child test schedule is duplicated. The diagnostic reviewer returns non-success for observed failures or unsupported required evidence and cannot auto-certify descriptive criteria. A post-commit diagnostic refusal requires inspecting actual state before any retry. These bounded adapters are not the general P3 management entry and do not inject dependencies into direct-native operation.

   Post-allocation identity: native transport compares its selected filtered Draft blob with the unique actual Git allocation before native Boot or writes. A self-consistent replacement config/Draft pair grants no authority. Keep original failed proposal/fixtures as evidence and use a new exact candidate rather than substituting frozen bytes.

   Draft selection evidence: retain three identified snapshots and three distinct SHA256 identities; the selected Draft footer records reasons and reviewable sources. Actual relevant prechecks and adversarial observations remain required. No semantic-quality scoring engine, three full Finish runs or invented design differences are required. Required assurance artifacts remain protected evidence, never disposable cleanup targets.

   Sources: Git githooks, git-add, git-hash-object and git-write-tree manuals; Microsoft Directory.Delete reference informs reuse of bounded owned-fixture cleanup; SLSA v1.2 artifact verification informs subject/input expectations. This is not a claim of SLSA compliance, signature verification, owner authentication or tamper resistance against equal OS privileges.
   ```

   The resulting file's Git blob is a4393df944645813c33108f670ad4006b41fc471.

## Acceptance Criteria

- [ ] All5 literal outputs reproduce their exact declared Git blobs, including the new focused suite; no native profile/criterion/receipt/masking/process/deletion engine is copied.
- [ ] RESUME authority body remains exact; check: normalized-resume:RESUME.md=72C0F8CEF1A08BA4EF511A3CF103CFF9C550672712E418323842518B384431A1
- [ ] Every native stage checks selected raw Draft and destination-filtered identity; every post-allocation stage matches the actual unique Git allocation before native Boot/writes. Clean root/normal hooks, native route/refusal and actual Git authorship remain mandatory.
- [ ] Whole literal Plan scope is checked before the first implementation write; new file creation works, unrelated dirt remains untouched, and exact declared paths alone are staged.
- [ ] Native applicability PASS and NOT APPLICABLE remain native decisions; unreadable evidence is non-success, and a post-commit diagnostic failure is never assumed to mean rollback.
- [ ] Workflow appends land in the named legal section despite section ordering; native hooks and actual Finish/receipt/Review/Complete/bind remain their owning authorities.
- [ ] Diagnostic failures/forbidden writes are nonzero, unsupported checks are explicit UNPROVEN, own CR synchronization is implicitly scoped, and the native range Gate is reused once rather than reimplemented.
- [ ] Actual positive/refusal and causal removal callers pass; a real disposable native lifecycle is independently completed/bound without certifying either original or claiming full management readiness.
- [ ] Existing tool index and workflow explain exact native selection, evidence limits, one native test schedule, original independence and remaining P3 management work without obsolete full-suite hook advice.
- [ ] Exact selected sandbox own full timed/watched Finish, live Review/Complete/range and later distinct original matching-recipe receipt are inspected; no preserved history or product original is changed.

## Review Gate

- [ ] Inspect all actual criteria, exact5 output blobs, all required suite results, runner/watcher/host exits, role-bound fresh receipt and selected sandbox/original recipe/fingerprint match.
- [ ] Inspect normal-hook full carrying range, native compatibility proof, preserved failures and clean source; no native bypass, fake certification, owner authentication or equal-OS enforcement claim.
- [ ] Keep P3 G2c/G3/G4 management/monitor/partial recovery open; storage/recovery and Batch6 remain separately held.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Draft preparation only. Append exact selected approval/root and actual native own lifecycle evidence. Original Approval additionally binds the immutable successful selected sandbox receipt and SHA256; it never transplants that receipt as original certification.

## Verification Notes

No original execution or Review yet. Append observed Verdict: Confirmed Complete, Reviewed Fingerprint and Reviewed Receipt only after actual own fresh evidence.

## Notes

One earned native-transport prerequisite. Direct-native sessions continue using native adapters; Workbench adapters are agent tools, never native dependencies. General management entry/observer handles/native recipe bridging/partial recovery/storage/workstation remain pending. Local integrity is not authenticated owner identity or protection against equal OS privileges.

Selection reasons and sources: select V3 because actual caller counterexamples, causal mutants and a real unchanged-native lifecycle support the smallest repair to existing adapters; V2's limitations/failures are retained and refreshed rather than hidden. V1 artifact SHA256 is bound above; V2 SHA256 0F30007FA9B3D8F1DA4E75152A8EE8BDAB43EDCD49B19779402227AC30E23F6F is bound above and here; V3's own digest remains external to avoid a self-hash cycle. Owner requires three distinct identified snapshots and reviewable selection reasons/sources, not a semantic-quality scoring engine or three full Finish runs. Sources refreshed 2026-10-23: SOURCE-DECISIONS.md; official Git https://git-scm.com/docs/git-add, https://git-scm.com/docs/git-hash-object and https://git-scm.com/docs/githooks; Microsoft https://learn.microsoft.com/en-us/dotnet/api/system.io.directory.delete?view=net-10.0 and PowerShell about_Comparison_Operators/about_Return; actual native AGENTS/CR_LIFECYCLE/template/evaluator at Founder971180e; local runtime/prototype/native-callers-v7.log, C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-stage-integrity-20261023/native-proof/finish.log, independent-review.json and bind-stage.log. These justify declared-path staging, filtered identity, scalar verdict parsing, existing bounded cleanup and native authority. Reject copied native engines, generic retries/killers, extra state registries, three full assurance runs, synthetic-receipt substitution and speculative original product work.
