# Workbench Change Request - WS-043

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Let the native lifecycle carry a contract that adds a script or a test, with the scope of data/records/WS-043/CONTRACT.md section 3. lib/Invoke-ContractLifecycle.ps1: Get-OriginalPrediction builds the tree the Original will carry (the baseline tree plus every declared output at its declared blob, an added path at mode 100644) in a throwaway index and object store whose alternates are the two roots' object stores, computes the judge's recipe on that tree and fingerprints that tree, so an added script enters the predicted schedule exactly as the judge reads it; the roots are read, never written, and every Git variable it sets is restored after, an unset one removed, never left as an empty string. Assert-FinishEvidence no longer requires the tree's test and hazard lists to equal the baseline's (LIFECYCLE_SCHEDULE_CHANGED): the schedule is the tree's own, the receipt still binds this tree's recipe and fingerprint and the carrying range still binds the exact declared paths and blobs, so an undeclared added script is refused as LIFECYCLE_RECEIPT_SUBJECT_MISMATCH. lib/test-contract-lifecycle.ps1: the fixture's outputs add lib/test-new.ps1, its Finish stub prints one PASS per scheduled test, the schedule case becomes the undeclared-script case, and the two prediction-mismatch cases use a blob other than the all-zero id, which Git refuses in an index. changes/README.md gets the WS-043 row Organize -Refresh writes. Benefit: WS-042 (its ledger, its constitution hook and their tests) and every later Batch 6 tool reach main through the one native gate without a per-workstream exception; the new-script half of WS-033 open item 42 closes.

Tier: Significant under DEC-12 (a change to the lifecycle controller, the path every contract's Original takes to main). Governance check: every consumer listed (CONTRACT.md section 3); the changed test runs once with its test root outside any ORVION-Workbench-temporary folder; three mutants each killed by a named case; a retro closes the workstream. Authority: DEC-02, DEC-08, DEC-09, DEC-11, DEC-12, DEC-13, DEC-14, DEC-22, DEC-23, DEC-24, DEC-25, DEC-26, DEC-30 and DEC-33; the owner's reply "B" of 2026-11-15 ~06:05 Cairo to "Approve B: a controller contract fixing the new-script and deletion limit (WS-033 open item 42), then WS-042 refrozen and rerun?", frozen verbatim in data/records/WS-043/owner-words/owner-2026-11-15-B-controller-fix-approved.txt (SHA256 6B090C6383650D7CEE59A7FA854DA80116479B8134A6697CC6EA61ED52064604), with Run Mode 1 standing from the owner's words of 2026-11-14 ~22:04 Cairo (data/records/WS-042/owner-words/owner-2026-11-14-2204-improving-loop-significant-approved.txt, SHA256 DC344EE74A7122CF97F43EC45EE797FDD89B70C6D19ACD7D77B3A88BC2A24180). Narrowing, reported to the owner: lib/apply-draft-steps.ps1 has only edit and create steps, so no Draft can delete a file and a deletion fix has no consumer; the deletion half of open item 42 stays open. Every scope choice is Claude main's under that authority, labelled DELEGATED; no owner text is typed by an agent (DEC-02).

Number: WS-043. Intended contract: changes/WS-043-lifecycle-new-scripts.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: this contract changes lib/Invoke-ContractLifecycle.ps1, so both roles run the byte-exact baseline 22fbf84 copy in data/records/WS-043/controller/ (IDENTITY.txt: blob b407d5be73fce6a93711cb7db9b241a6c60be5e8, SHA256 50DFF63CFF2FEBA1D5CCC3273623DFCDEE48D3740EBEF2CD11308A24B16F1E14), its SHA256 checked before each stage, with the accepted judge (the WS-038 precedent). WS-043 adds no script, so the baseline controller admits it. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

22fbf84ca3cfb5b08db322bd765eac9326683e1f

## Write Scope

- changes/README.md
- lib/Invoke-ContractLifecycle.ps1
- lib/test-contract-lifecycle.ps1
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Workbench.ps1, lib/Invoke-DraftSteps.ps1, lib/Organize.ps1, lib/Events.ps1, lib/Save-State.ps1, tests.ps1 and every other lib/ file, test and hook; any new Draft step kind or file deletion (the deletion half of WS-033 open item 42 stays open); every DEC entry; .claude/settings.json and the user settings in the owner's profile; the WS-042 scope (its own contract, refrozen after this one); data/ (untracked: open item 42's narrowing and WS-042's Check-Draft schedule guard follow after Complete, outside this contract); the seven legacy folders, Owner-Tools, the vault and every package; any CRM or ORVION change (DEC-08), credentials, real sessions or events (DEC-09); Batch 6 slice 11 (on hold); Codex, subagents, RAM, power or scheduled-task changes; any push or release before both roles are Complete (DEC-25).

## Draft Assurance

V1: WS043-V1-CLAUDE-SIGNIFICANT-DESIGN-20261115-01 | 2026-11-15 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-043\assurance\V1\DRAFT.md | CF8621248959FBC4F303A1521CCD43A6E6F8D1A2CE70AE44205C2327C3FD2605
V2: WS043-V2-CLAUDE-SIGNIFICANT-ADVERSARIAL-20261115-01 | 2026-11-15 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-043\assurance\V2\DRAFT.md | A2800D5680FC7B23D2564B8851BFEE2EB2827992E5D46703A3AAF932CD10853F
V3: WS043-V3-CLAUDE-REFRESH-20261115-01 | 2026-11-15 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-043\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V1 DESIGN by Claude main, claude-opus-5-5, under D120: the owner skipped Codex and subagents on 2026-11-08 ~01:20 Cairo, standing (the owner's words verbatim in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md; D124 wrote D120 into DEC-14 and DEC-19). Codex skipped by owner decision, not by unavailability. No Codex work is claimed and nothing here is independent. V1 designs the scope of data/records/WS-043/CONTRACT.md section 3 from the frozen candidate.

V2 ADVERSARIAL by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V2 attacks V1 and changes no output: (a) AC-04 claimed no assertion removed although the schedule case's assertion is replaced, so it now names the replacement and why it reaches the same refusal (DEC-22); (b) AC-01's claim that the roots are never written had no proof, so data/records/WS-043/assurance/Probe-Prediction.ps1 runs the replay controller's own prediction on a fresh baseline Original and the replay, and showed that Git refreshes the timestamp of objects a root already holds (freshen on write-tree): AC-01 now claims exactly what holds (no object added, removed or changed; index, HEAD and status unchanged; freshened files listed) and AC-03 names the probe's three environment runs.

V3 REFRESH by Claude main, claude-opus-5-5, under the same D120 standing; nothing here is independent. V3 rechecks the live facts V2 rests on (origin main and the Original HEAD at baseline 22fbf84, the pinned PowerShell 7.6.8, git 2.56.1.windows.1, the frozen owner words by SHA256, the baseline controller copy by SHA256) and changes no output and no criterion.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W43\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W43\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W43\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W43\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.56.1.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none. PowerShell 7.6.8 is the portable host in ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8, which WS-034, WS-040, WS-041 and WS-042 ran; git 2.56.1 is the live machine version.

1. Check whether `changes/README.md` contains `| WS-043-lifecycle-new-scripts.md | contracts | Workbench Change Request - WS-043 | - | - |`; if so record Already Applied when its Git blob is 7e152a21e7a5823a05ebf926ecd6c7c0f7f16540, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-043 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-041-commit-retry-and-ws033-summary.md | contracts | Workbench Change Request - WS-041 | - | - |
   ```
   insert
   ```text
   | WS-043-lifecycle-new-scripts.md | contracts | Workbench Change Request - WS-043 | - | - |
   ```

   The resulting file's Git blob is 7e152a21e7a5823a05ebf926ecd6c7c0f7f16540.

2. Check whether `lib/Invoke-ContractLifecycle.ps1` contains `# The tree the Original will carry: the baseline plus the declared outputs, built in a throwaway index and object store,`; if so record Already Applied when its Git blob is 8056027656dca768f10f3e37ea0aa6eacc0e2e33, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-043 candidate output), each matched once, and change nothing else:

   a) replace the lines
   ```text
       $recipe=Get-WorkbenchRecipe $executionRoot $Tree $Record
       foreach($row in $recipe.Material.inputs){$replacement=@($m.Outputs|Where-Object Path -CEQ $row.Path);if($replacement.Count-eq1){$row.Blob=$replacement[0].Blob}}
       $predictedRecipe=Get-WorkbenchDigest ($recipe.Material|ConvertTo-Json -Depth 8 -Compress)
       $rows=[Collections.Generic.SortedDictionary[string,string]]::new([StringComparer]::Ordinal)
       foreach($row in @(Invoke-RootGit @('ls-tree','-r',$Tree))){
           if($row-cnotmatch'^(?<mode>[0-9]+) blob (?<blob>[0-9a-f]{40})\t(?<path>.+)$'){throw 'LIFECYCLE_UNSUPPORTED_TREE_ENTRY'}
           $pathValue=$Matches.path;$modeValue=$Matches.mode;$blobValue=$Matches.blob
           $replacement=@($m.Outputs|Where-Object Path -CEQ $pathValue);if($replacement.Count-eq1){$blobValue=$replacement[0].Blob}
           if($pathValue-ceq'RESUME.md'){$blobValue=Get-WorkbenchResumeDigest (Get-WorkbenchText $executionRoot $Tree $pathValue)}
           $rows[$pathValue]="$modeValue $blobValue $pathValue"
       }
       foreach($output in $m.Outputs){if(!$rows.ContainsKey($output.Path)){$rows[$output.Path]='100644 '+$output.Blob+' '+$output.Path}}
       $rows[$m.Contract]='100644 '+(Get-WorkbenchDigest (Get-WorkbenchFrozen $Record))+' '+$m.Contract
       @{Recipe=$predictedRecipe;Fingerprint=(Get-WorkbenchDigest (@($rows.Values)-join[char]10))}
   ```
   with
   ```text
       # The tree the Original will carry: the baseline plus the declared outputs, built in a throwaway index and object store,
       # so an added script or test enters the schedule exactly as the judge reads it; the roots' objects are read, never written.
       $objects=foreach($repo in $executionRoot,$m.Sandbox){$lines=@(& git --no-optional-locks -C $repo rev-parse --path-format=absolute --git-path objects 2>$null);if($LASTEXITCODE-or$lines.Count-ne1){throw 'LIFECYCLE_PREDICTION_OBJECTS_UNREADABLE'};[IO.Path]::GetFullPath($lines[0])}
       $scratch=Join-Path ([IO.Path]::GetTempPath()) ('olp'+[guid]::NewGuid().ToString('N').Substring(0,8))
       $saved=@{};foreach($name in 'GIT_INDEX_FILE','GIT_OBJECT_DIRECTORY','GIT_ALTERNATE_OBJECT_DIRECTORIES'){$saved[$name]=[Environment]::GetEnvironmentVariable($name)}
       try{
           [void][IO.Directory]::CreateDirectory((Join-Path $scratch 'objects'))
           $env:GIT_INDEX_FILE=Join-Path $scratch 'index';$env:GIT_OBJECT_DIRECTORY=Join-Path $scratch 'objects';$env:GIT_ALTERNATE_OBJECT_DIRECTORIES=$objects-join[IO.Path]::PathSeparator
           $null=Invoke-RootGit @('read-tree',$Tree)
           foreach($output in $m.Outputs){$row=@(Invoke-RootGit @('ls-tree',$Tree,'--',$output.Path));$mode=if($row.Count){($row[0]-split' ')[0]}else{'100644'};$null=Invoke-RootGit @('update-index','--add','--cacheinfo',"$mode,$($output.Blob),$($output.Path)")}
           $predicted=@(Invoke-RootGit @('write-tree','--missing-ok'))[0]
           $recipe=Get-WorkbenchRecipe $executionRoot $predicted $Record
           $rows=[Collections.Generic.SortedDictionary[string,string]]::new([StringComparer]::Ordinal)
           foreach($row in @(Invoke-RootGit @('ls-tree','-r',$predicted))){
               if($row-cnotmatch'^(?<mode>[0-9]+) blob (?<blob>[0-9a-f]{40})\t(?<path>.+)$'){throw 'LIFECYCLE_UNSUPPORTED_TREE_ENTRY'}
               $pathValue=$Matches.path;$modeValue=$Matches.mode;$blobValue=$Matches.blob
               if($pathValue-ceq'RESUME.md'){$blobValue=Get-WorkbenchResumeDigest (Get-WorkbenchText $executionRoot $predicted $pathValue)}
               $rows[$pathValue]="$modeValue $blobValue $pathValue"
           }
           $rows[$m.Contract]='100644 '+(Get-WorkbenchDigest (Get-WorkbenchFrozen $Record))+' '+$m.Contract
           @{Recipe=$recipe.Digest;Fingerprint=(Get-WorkbenchDigest (@($rows.Values)-join[char]10))}
       }finally{foreach($name in $saved.Keys){if($null-eq$saved[$name]){Remove-Item -LiteralPath "Env:$name" -ErrorAction Ignore}else{Set-Item -LiteralPath "Env:$name" -Value $saved[$name]}};if(Test-Path -LiteralPath $scratch){Remove-Item -LiteralPath $scratch -Recurse -Force}}
   ```

   b) replace the lines
   ```text
       $recipe=Get-WorkbenchRecipe $executionRoot $Tree $record;$priorRecipe=Get-WorkbenchRecipe $executionRoot $m.Baseline $record
       if(($recipe.Material.tests-join'|')-cne($priorRecipe.Material.tests-join'|')-or($recipe.Material.hazards-join'|')-cne($priorRecipe.Material.hazards-join'|')){throw 'LIFECYCLE_SCHEDULE_CHANGED'}
   ```
   with
   ```text
       # The schedule is the tree's own: the receipt binds this recipe and fingerprint, the range binds the exact paths and blobs.
       $recipe=Get-WorkbenchRecipe $executionRoot $Tree $record
   ```

   The resulting file's Git blob is 8056027656dca768f10f3e37ea0aa6eacc0e2e33.

3. Check whether `lib/test-contract-lifecycle.ps1` contains `foreach($test in $recipe.Material.tests){'PASS '+[IO.Path]::GetFileName($test)};'TESTS: all passed in 0 s';'PASS the real journal is untouched by the checks'`; if so record Already Applied when its Git blob is 5de69213090e16bae914db85bf5320cc5926c41d, and otherwise stop and report. Otherwise make exactly these 10 edits (land this exact frozen WS-043 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   'Execute'{if($record.Checkpoint['Resume Step']-cne'DONE'){[void][IO.Directory]::CreateDirectory((Join-Path $Root 'docs'));[IO.File]::WriteAllText((Join-Path $Root 'lib\tool.ps1'),"# tool v2`r`n");[IO.File]::WriteAllText((Join-Path $Root 'docs\new.txt'),"new`n")}elseif($env:LIFECYCLE_FIXTURE_REFUSE-ceq'ExecuteDone'){exit 9}}
   ```
   with
   ```text
   'Execute'{if($record.Checkpoint['Resume Step']-cne'DONE'){[void][IO.Directory]::CreateDirectory((Join-Path $Root 'docs'));[IO.File]::WriteAllText((Join-Path $Root 'lib\tool.ps1'),"# tool v2`r`n");[IO.File]::WriteAllText((Join-Path $Root 'docs\new.txt'),"new`n");[IO.File]::WriteAllText((Join-Path $Root 'lib\test-new.ps1'),"# new test`r`n")}elseif($env:LIFECYCLE_FIXTURE_REFUSE-ceq'ExecuteDone'){exit 9}}
   ```

   b) replace the line
   ```text
       'PASS test-x.ps1';'TESTS: all passed in 0 s';'PASS the real journal is untouched by the checks'
   ```
   with
   ```text
       foreach($test in $recipe.Material.tests){'PASS '+[IO.Path]::GetFileName($test)};'TESTS: all passed in 0 s';'PASS the real journal is untouched by the checks'
   ```

   c) replace the line
   ```text
   [ordered]@{DraftSHA256=$sha;Files=@([ordered]@{File='lib/tool.ps1';Blob=$blob;Skip=$false},[ordered]@{File='docs/new.txt';Blob='__NEWBLOB__';Skip=$false})}|ConvertTo-Json -Depth 4
   ```
   with
   ```text
   [ordered]@{DraftSHA256=$sha;Files=@([ordered]@{File='lib/tool.ps1';Blob=$blob;Skip=$false},[ordered]@{File='docs/new.txt';Blob='__NEWBLOB__';Skip=$false},[ordered]@{File='lib/test-new.ps1';Blob='__TESTNEWBLOB__';Skip=$false})}|ConvertTo-Json -Depth 4
   ```

   d) replace the lines
   ```text
       $toolPayload=Join-Path $root 'tool-v2.ps1';$newPayload=Join-Path $root 'new.txt';Write-Crlf $toolPayload "# tool v2`n";Write-Crlf $newPayload "new`n"
       $toolBlob=@(FixGit $original hash-object --path=lib/tool.ps1 -- $toolPayload)[0];$newBlob=@(FixGit $original hash-object --path=docs/new.txt -- $newPayload)[0]
       $outputs=@([pscustomobject]@{Path='lib/tool.ps1';Blob=$toolBlob},[pscustomobject]@{Path='docs/new.txt';Blob=$newBlob})
   ```
   with
   ```text
       $toolPayload=Join-Path $root 'tool-v2.ps1';$newPayload=Join-Path $root 'new.txt';Write-Crlf $toolPayload "# tool v2`n";Write-Crlf $newPayload "new`n";$testNewPayload=Join-Path $root 'test-new.ps1';Write-Crlf $testNewPayload "# new test`n"
       $toolBlob=@(FixGit $original hash-object --path=lib/tool.ps1 -- $toolPayload)[0];$newBlob=@(FixGit $original hash-object --path=docs/new.txt -- $newPayload)[0];$testNewBlob=@(FixGit $original hash-object --path=lib/test-new.ps1 -- $testNewPayload)[0]
       $outputs=@([pscustomobject]@{Path='lib/tool.ps1';Blob=$toolBlob},[pscustomobject]@{Path='docs/new.txt';Blob=$newBlob},[pscustomobject]@{Path='lib/test-new.ps1';Blob=$testNewBlob})
   ```

   e) replace the line
   ```text
       Write-Crlf (Join-Path $original 'lib\apply-draft-steps.ps1') $previewStub.Replace('__TOOLBLOB__',$toolBlob).Replace('__NEWBLOB__',$newBlob)
   ```
   with
   ```text
       Write-Crlf (Join-Path $original 'lib\apply-draft-steps.ps1') $previewStub.Replace('__TOOLBLOB__',$toolBlob).Replace('__NEWBLOB__',$newBlob).Replace('__TESTNEWBLOB__',$testNewBlob)
   ```

   f) immediately after the line
   ```text
   - docs/new.txt
   ```
   insert
   ```text
   - lib/test-new.ps1
   ```

   g) replace the line
   ```text
   1. Native Execute writes the two outputs.
   ```
   with
   ```text
   1. Native Execute writes the three outputs.
   ```

   h) replace the line
   ```text
       Test-Refused 'a changed test schedule is refused' Sandbox inspect 'LIFECYCLE_SCHEDULE_CHANGED' -Edit {Write-Crlf (Join-Path $sandbox 'lib\test-y.ps1') "# y`n";$null=FixGit $sandbox add -A;$null=FixGit $sandbox commit --quiet -m 'schedule'}
   ```
   with
   ```text
       Test-Refused 'an undeclared added script is refused' Sandbox inspect 'LIFECYCLE_RECEIPT_SUBJECT_MISMATCH' -Edit {Write-Crlf (Join-Path $sandbox 'lib\test-y.ps1') "# y`n";$null=FixGit $sandbox add -A;$null=FixGit $sandbox commit --quiet -m 'schedule'}
   ```

   i) replace the line
   ```text
       Test-Refused 'a recipe the sandbox did not prove is refused' Original prepare 'LIFECYCLE_PREDICTED_RECIPE_MISMATCH' -With (New-OutputVariant 'lib/tool.ps1' 'lib/tool.ps1' ('0'*40))
   ```
   with
   ```text
       Test-Refused 'a recipe the sandbox did not prove is refused' Original prepare 'LIFECYCLE_PREDICTED_RECIPE_MISMATCH' -With (New-OutputVariant 'lib/tool.ps1' 'lib/tool.ps1' ('1'*40))
   ```

   j) replace the line
   ```text
       Test-Refused 'a fingerprint the sandbox did not prove is refused' Original prepare 'LIFECYCLE_PREDICTED_FINGERPRINT_MISMATCH' -With (New-OutputVariant 'docs/new.txt' 'docs/new.txt' ('0'*40))
   ```
   with
   ```text
       Test-Refused 'a fingerprint the sandbox did not prove is refused' Original prepare 'LIFECYCLE_PREDICTED_FINGERPRINT_MISMATCH' -With (New-OutputVariant 'docs/new.txt' 'docs/new.txt' ('1'*40))
   ```

   The resulting file's Git blob is 5de69213090e16bae914db85bf5320cc5926c41d.

## Acceptance Criteria

- [ ] Output `changes/README.md` equals its declared resulting Git blob. check: blob:changes/README.md=7e152a21e7a5823a05ebf926ecd6c7c0f7f16540
- [ ] Output `lib/Invoke-ContractLifecycle.ps1` equals its declared resulting Git blob. check: blob:lib/Invoke-ContractLifecycle.ps1=8056027656dca768f10f3e37ea0aa6eacc0e2e33
- [ ] Output `lib/test-contract-lifecycle.ps1` equals its declared resulting Git blob. check: blob:lib/test-contract-lifecycle.ps1=5de69213090e16bae914db85bf5320cc5926c41d
- [ ] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [ ] AC-01 Prediction on the predicted tree: in lib/Invoke-ContractLifecycle.ps1, Get-OriginalPrediction reads the tree under test into a throwaway index (GIT_INDEX_FILE) with a throwaway object store (GIT_OBJECT_DIRECTORY) whose alternates are the Original's and the sandbox's object stores, sets each declared output to its declared blob (the tree's mode, else 100644), writes that tree with --missing-ok, and returns the judge's recipe digest of that tree and the fingerprint of its rows (RESUME.md by its normalized digest, the contract by its frozen digest); no object in the Original's or the sandbox's store is added, removed or changed and neither root's index, HEAD or status changes (Git may refresh the timestamp of an object a root already holds when write-tree meets it through an alternate, its freshen, which the probe lists), and the throwaway folder is removed; data/records/WS-043/assurance/Probe-Prediction.ps1 proves this on the replay, and that the prediction equals the judge's recipe and fingerprint of the tree the Original will carry (prediction-probe.json beside each Draft). test-contract-lifecycle passes with the fixture's added lib/test-new.ps1 through Original prepare and complete, and still refuses "a recipe the sandbox did not prove" (LIFECYCLE_PREDICTED_RECIPE_MISMATCH) and "a fingerprint the sandbox did not prove" (LIFECYCLE_PREDICTED_FINGERPRINT_MISMATCH).
- [ ] AC-02 Schedule is the tree's own: Assert-FinishEvidence no longer computes the baseline recipe or throws LIFECYCLE_SCHEDULE_CHANGED; it still requires the receipt's schema, role, root, Draft SHA256, recipe, fingerprint and evaluator to match this tree, and the carrying range still allows only RESUME.md, the contract and the declared outputs at their declared blobs. test-contract-lifecycle refuses "an undeclared added script" with LIFECYCLE_RECEIPT_SUBJECT_MISMATCH and keeps every other refusal case it had at baseline.
- [ ] AC-03 Environment restored: after the prediction, each of GIT_INDEX_FILE, GIT_OBJECT_DIRECTORY and GIT_ALTERNATE_OBJECT_DIRECTORIES holds its value from before, and one unset before is removed (Remove-Item Env:), never set to an empty string; on success and on a throw alike (finally); the probe runs it with all three unset, with GIT_ALTERNATE_OBJECT_DIRECTORIES set, and on a forced LIFECYCLE_GIT_FAILED, and finds no variable left behind or changed and no throwaway file left. test-contract-lifecycle runs to its end after the Original prepare cases ("the fixture ran to its end").
- [ ] AC-04 Owning test: lib/test-contract-lifecycle.ps1 differs from its baseline only by the added fixture output lib/test-new.ps1 (Execute, the literal-plan stub, the outputs, Write Scope, the step line), the Finish stub's one PASS per scheduled test, the undeclared-script case replacing the schedule case, and the '1'*40 blob in the two prediction-mismatch cases; the schedule case's assertion is replaced by the undeclared-script case, which reaches the same refusal of an unproved schedule through the receipt subject, the prediction and the range binding, and no other assertion is removed (DEC-22). It passes in full with WORKBENCH_TEST_ROOT outside any ORVION-Workbench-temporary folder, and three mutants are each killed by a named case: the baseline schedule check restored ("an undeclared added script is refused"), the baseline-tree prediction restored ("a fingerprint the sandbox did not prove is refused"), the restore by SetEnvironmentVariable(null) ("the fixture ran to its end").
- [ ] AC-05 Organizer: changes/README.md is what lib/Organize.ps1 -Refresh writes: it holds the WS-043 row, and a refresh of the replay with this contract in place changes no organizer.
- [ ] AC-06 Secrets and privacy: gitleaks on the exact candidate range reports no finding in the 3 outputs and RESUME.md; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; neither masked value (the computer name, a marketing tunnel script name) nor the owner's e-mail is in any changed file or in this contract.
- [ ] AC-07 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json. From each Finish launch to END: no Events -Add, Save-State or edit in a protected root, and Docker off.
- [ ] AC-08 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-043/evidence/protected-before.json, captured before the sandbox Finish and again after Original Complete with data/records/WS-038/Capture-Protected.ps1; lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1 and lib/Workbench.ps1 are unchanged, and lib/Invoke-ContractLifecycle.ps1 changes only as AC-01 to AC-03 declare; both roles ran the baseline controller copy whose SHA256 IDENTITY.txt names; the user settings are unchanged; CRM, ORVION and their trusted copies keep their HEAD and files (the lifecycle's protected-root compare); no Codex, subagent, RAM, power setting or scheduled task change; no push before both roles are Complete.

## Review Gate

- [ ] Inspect the live subject, this role's fresh receipt, timing and watching evidence, and every criterion above, with attempts, deviations and gaps kept visible. No prototype result or earlier receipt substitutes for this role's gate.
- [ ] Review: one Claude-main self-review, labelled as such and never called independent. The Codex review (DEC-14) is recorded SKIPPED by the owner's decision of 2026-11-08 ~01:20 Cairo, never replaced or claimed (D120). At most one corrective version; a remaining material disagreement goes to the owner.
- [ ] Retro (DEC-12): Claude main names what does not satisfy it, each item with a remedy and a check.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Append only. No approval, execution-root binding or receipt is claimed. At actual approval add exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line using actual immutable identities. Owner evidence must name the approved digest and execution root. For original execution append exactly one Sandbox Receipt and Sandbox Receipt SHA256 for the matching successful schema2 sandbox artifact. A delegated decision needs actual live owner delegation and is labelled delegated. Never invent human confirmation or approval.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-043\assurance\V3\DRAFT.md
Approved SHA256: 104C4654B64503B5752268F37D4AC70FC0B7EFA1B4F382D282B35CE5D0FBBBC7
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-043\gate\GATE1-WS043-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: 2EFEA64A0F03DA8464DD1D89BFEF53ACE3E9FC0F93F4DBB82ACC1AFE23486264
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W43\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: B4BB8456A174BA53F5C4E5CA5B205711BD2E1FCE49B1753AB9876F1916B9E841
Original exact declared outputs applied by accepted native Execute; fresh own Finish and Review/Complete remain required. Other protected roots unchanged. Controller: the baseline 22fbf84 copy data/records/WS-043/controller/Invoke-ContractLifecycle.ps1 (SHA256 50DFF63C, IDENTITY.txt), used by both roles because this contract changes lib/Invoke-ContractLifecycle.ps1, checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority.

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W43-c2 (data/records/WS-043/Make-Candidate.ps1). Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json and prediction-probe.json beside this Draft. After Complete, outside this contract: the release under DEC-25 on the owner's "B", only when every gate passed and Claude main's retro is satisfied; the protected state is compared with its record from before; WS-033 open-items.tsv line 42 is narrowed to its deletion half with this contract's reference; WS-042's Check-Draft gains the schedule-feasibility guard, and WS-042 is refrozen on the new baseline and rerun; Save-State and the status page record the result.
