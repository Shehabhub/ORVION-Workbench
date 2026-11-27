# Workbench Change Request - WS-052

## Status

[x] Draft
[ ] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Give the lifecycle a step that deletes a tracked file and route a new agent to the live state, with the scope of data/records/WS-052/CONTRACT.md section 5. lib/apply-draft-steps.ps1 replays a step ``N. Delete `path`, whose baseline Git blob is <40 hex>.``: it preflights it with every other step (path check, DUPLICATE_TARGET, TARGET_IS_DIRECTORY), plans an absent file as Already Applied, refuses a present file whose blob is not the declared baseline blob (DELETE_BASELINE_BLOB_MISMATCH) before any write, re-reads the bytes before it deletes (TARGET_CHANGED), and previews the step with Delete=true and the null blob (40 zeros); lib/README.md names it. lib/Invoke-ContractLifecycle.ps1 reads the null blob as absent: its prediction removes such a path from its throwaway index, and its committed and live output checks read a missing path as the null blob. lib/test-draft-steps.ps1 and lib/test-contract-lifecycle.ps1 cover both, the lifecycle fixture gaining one deleted file. RESUME.md line 2 names data/work/NOW.md, written only by lib/Save-State.ps1 (DEC-26), lib/Pulse.ps1 and lib/README.md: the line data/records/WS-050/candidate.patch carried. records/WS-051/README.md is the WS-051 summary with its Organize -New header, docs/history/LOG.tsv row and records/README.md Files line, so NO_SUMMARY holds once WS-052 is Complete. changes/README.md gets the WS-052 row Organize -Refresh writes. Benefit (DEC-30: a new agent finds the live state; the owner can lose the machine): RESUME.md routed every new agent to the retired journal route, and no contract could delete a tracked file, so the retired HANDOFF.md and the recovery move could not land; WS-053 lands them with this step.

Tier: Significant under DEC-12 (a new lifecycle step kind that removes tracked files, the lifecycle controller's output checks, and the route every new agent reads first). Governance check: every consumer listed (CONTRACT.md section 5); the owning tests run on the candidate with three causal production mutants; a retro closes the workstream. Authority: for RESUME line 2, the owner's approval, not DELEGATED, in the owner's words frozen in data/records/batch6/owner-words/owner-2026-11-26-a2-r2-approved.txt (SHA256 F40071A45F166CA08F07E4711EB69A0D4B51BF042EE9C30BE9DE2DC57E1A8A53), covering A2-PROPOSAL-R2 section 4, "the same contract carries RESUME line 2", which WS-051 deferred here; for the deletion step and the WS-051 summary, Batch 6 PLAN Step 4 A1 and Step 6 A2 and the owner's words of 2026-11-26 10:44 Cairo in data/records/WS-050/owner-words/owner-2026-11-26-all-steps-no-skip-frontend-after.txt (SHA256 0F1FAFFF91B1A21E0C886F53D72A5BC5B3327FBFE0EAA5A42FAD3758BE428356); DEC-01, DEC-02, DEC-08, DEC-09, DEC-10, DEC-11, DEC-12, DEC-13, DEC-14, DEC-22, DEC-23, DEC-24, DEC-25, DEC-26, DEC-30, DEC-31 and DEC-33; for everything else, the owner's delegation that the constitution decides in the owner's absence (data/records/batch6/owner-words/owner-2026-11-21-constitution-decides-in-my-absence.txt, SHA256 DB34F67C2AF82D9A9751597247ABEEBD74B4BBB1CC6F47291D2572FE080EEAB0) and the live AFK Mode run instruction. Gate approvals are Claude main's under that delegation, labelled DELEGATED; no owner text is typed by an agent (DEC-02).

Number: WS-052. Intended contract: changes/WS-052-delete-step-and-live-state-route.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: this contract changes lib/Invoke-ContractLifecycle.ps1, so both roles run the byte-exact baseline copy data/records/WS-052/controller/Invoke-ContractLifecycle.ps1 (SHA256 1BBC2BB98B5C1400F51BF124CCE9A18002ED1C053218AEE2FEA7BFB9F34AD823, WS-038, WS-043 and WS-051 precedent), its SHA256 checked before each stage, with the accepted judge lib/Test-WorkbenchChange.ps1 (SHA256 4E1F00E159B82ECDFDD0F0C542A08B71D77BBFE4ABAAB4B6B1B8377587017FD1, unchanged). WS-052 adds no script and deletes no file, so the baseline controller and applier admit it. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

8d3822ecacb5ec640c9a756cc8eaf155ff9cae1d

## Write Scope

- changes/README.md
- docs/history/LOG.tsv
- lib/apply-draft-steps.ps1
- lib/Invoke-ContractLifecycle.ps1
- lib/README.md
- lib/test-contract-lifecycle.ps1
- lib/test-draft-steps.ps1
- records/README.md
- records/WS-051/README.md
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: any deletion of a tracked file by this contract; HANDOFF.md retirement with its readers and the A1 recovery move (deferred to WS-053, CONTRACT.md section 3); RESUME.md apart from line 2 and the native pointer transitions; every other function and case of lib/apply-draft-steps.ps1, lib/Invoke-ContractLifecycle.ps1 and their tests; lib/Test-WorkbenchChange.ps1, lib/Workbench.ps1, lib/Invoke-DraftSteps.ps1, lib/Organize.ps1 and every other lib/ file, test and hook; .claude/settings.json; docs/DECISIONS.md and every other docs/ file; every other row and line of lib/README.md, changes/README.md and records/README.md; records/WS-022 to WS-050 and every other records/ file; every earlier LOG.tsv row; WORKFLOW.md and HANDOFF.md; past changes/WS-0xx files; the owner's profile (%USERPROFILE%\.claude and %LOCALAPPDATA%\usage) and the agent memory pointers (changed after Complete, outside the repository); data/ (untracked); the seven legacy folders, Owner-Tools, the vault and every package; any CRM or ORVION change (DEC-08); any Supabase project, Primary or Founder Secondary; credentials, real sessions or events (DEC-09); Codex, subagents, RAM, power or scheduled-task changes; FE-0; any push or release before both roles are Complete (DEC-25).

## Draft Assurance

V1: WS052-V1-CLAUDE-SIGNIFICANT-DESIGN-20261127-01 | 2026-11-27 | c:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-052\assurance\V1\DRAFT.md | DC0742DEEE91DF629CC2FDD95217DF85DBE2BEC8CBE78F9611DEA86CAADBBCDA
V2: WS052-V2-CLAUDE-SIGNIFICANT-ADVERSARIAL-20261127-01 | 2026-11-27 | c:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-052\assurance\V2\DRAFT.md | 72B6C05331280A64296A917D21EC754EA7CEB9EB944BCB881428477EC52D8C34
V3: WS052-V3-CLAUDE-REFRESH-20261127-01 | 2026-11-27 | c:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-052\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V1 DESIGN by Claude main, claude-opus-5-5, under D120: the owner skipped Codex and subagents on 2026-11-08 ~01:20 Cairo, standing (the owner's words verbatim in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md; D124 wrote D120 into DEC-14 and DEC-19). Codex skipped by owner decision, not by unavailability. No Codex work is claimed and nothing here is independent. V1 designs the scope of data/records/WS-052/CONTRACT.md section 5 from the frozen candidate cx\W52-c2 (tree 85d9e311f0a249feef05eaf8954464e411703731 at baseline 8d3822e), whose owning tests passed before V1: test-draft-steps (the eight Delete cases), test-contract-lifecycle, test-organize, test-markdown-consistency 154 assertions, and Organize -Check -Quick with isolated absent roots PASS (data/records/WS-052/evidence/*.log); the three production mutants were killed and restored (evidence/mutants.log). RESUME.md line 2 is the A2-R2 route the owner approved (data/records/batch6/owner-words/owner-2026-11-26-a2-r2-approved.txt), equal to line 20 of data/records/WS-050/candidate.patch.

V2 ADVERSARIAL by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V2 attacks V1 and changes no output or criterion. The V1 Draft check PASSED on every item (data/records/WS-052/evidence/w52-check-V1.log; V1/claude-draft-check.json SHA256 59C5D3ABB26E79FB3ECE4D9B1B7D4405F733652CCC908AAFE639BF072D98235C): tree equal, numstat, exact lines, RESUME line 2 equal to candidate.patch line 20, the LOG row, schedule, organizer, NO_SUMMARY a/b/c, gitleaks 0, masked 0/0, the four owning tests exit 0 (test-contract-lifecycle 202s, test-organize 370s), BASELINE, NULLBLOB and RESUMELINK killed with their named first FAIL or refusal and bytes restored, hazards 0/74. Attacks: (a) authority: RESUME line 2 is byte-equal to the text the owner approved through A2-R2 (resumeLineOk), line 1 stays None, DEC-26 and DEC-30/33 are untouched (exact lines); (b) a Delete of other bytes is refused before any write (BASELINE mutant, test-draft-steps), and a missing output is the null blob, never a forged blob (NULLBLOB mutant); (c) the judge lib/Test-WorkbenchChange.ps1 stays 4E1F00E1 and is not in scope; (d) this contract deletes no tracked file, so the baseline tools carry it (generate-draft NO_DELETION_IN_THIS_CONTRACT); (e) privacy: no finding, no e-mail, computer name or tunnel script name; (f) unprovable here: the first live RESUME.md file step stays UNPROVEN until the sandbox run. V2 reuses the V1 test and mutant results only when its replay tree equals V1's (Check-Draft -ReuseTests, REUSE_TREE_DIFFERS otherwise).

V3 REFRESH by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V3 changes no output and confirms the live facts on 2026-11-27: origin/main 8d3822ecacb5ec640c9a756cc8eaf155ff9cae1d and the Original HEAD 8d3822ecacb5ec640c9a756cc8eaf155ff9cae1d, 0 uncommitted path(s); lib/Invoke-ContractLifecycle.ps1 is still SHA256 1BBC2BB98B5C1400F51BF124CCE9A18002ED1C053218AEE2FEA7BFB9F34AD823, equal to the controller copy data/records/WS-052/controller/Invoke-ContractLifecycle.ps1 (1BBC2BB98B5C1400F51BF124CCE9A18002ED1C053218AEE2FEA7BFB9F34AD823), and lib/Test-WorkbenchChange.ps1 still 4E1F00E159B82ECDFDD0F0C542A08B71D77BBFE4ABAAB4B6B1B8377587017FD1; the pinned host is 7.6.8 and git version 2.56.1.windows.1. The V2 Draft check passed (data/records/WS-052/evidence/w52-check-V2.log; V2/claude-draft-check.json SHA256 C0ED99307962A36B8728BFA4687EB40F3F1010E87137A79034D9BE94A134A616): tree equal, every text check true, gitleaks 0, masked 0/0, the four owning tests exit 0, the three mutants BASELINE, NULLBLOB and RESUMELINK killed with bytes restored, hazards 0/74; V3 reuses the V1 test and mutant results because the replay tree is identical.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W52\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W52\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W52\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W52\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.56.1.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none. PowerShell 7.6.8 is the portable host in ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8, which WS-034 and WS-040 to WS-051 ran; git 2.56.1 is the live machine version. RESUME.md has a file step whose declared resulting blob carries the native pointer naming this contract: the baseline Original prepare previews with -PointerContract (WS-051) and Execute runs after Approval sets the pointer (the WS-027 precedent). Its route is pinned by the normalized-resume criterion below across Approval and Complete, with no blob criterion for RESUME.md, and preparation itself keeps None.

1. Check whether `changes/README.md` contains `| WS-052-delete-step-and-live-state-route.md | contracts | Workbench Change Request - WS-052 | - | - |`; if so record Already Applied when its Git blob is cb18b04d8b696b0b328964c6380791ac4cfeb2b9, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-052 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-051-reply-form-and-preview-pointer.md | contracts | Workbench Change Request - WS-051 | - | - |
   ```
   insert
   ```text
   | WS-052-delete-step-and-live-state-route.md | contracts | Workbench Change Request - WS-052 | - | - |
   ```

   The resulting file's Git blob is cb18b04d8b696b0b328964c6380791ac4cfeb2b9.

2. Check whether `docs/history/LOG.tsv` contains `2026-11-26T19:54:27Z	new	workbench	-	records/WS-051	WS-052	WS-052 WS-051 summary	D321E7900A7C1EA7DC63FDC10C33C1ADDF2BADCD829573240AE37561757D9D91`; if so record Already Applied when its Git blob is 3f205975f30a199c3f58184fa107db8160b2bcc7, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-052 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   2026-11-26T15:10:22Z	new	workbench	-	records/WS-050	WS-051	WS-051 WS-050 summary	F103182DC25DE0F203102889B29E84A398E4D968553081A0CD7241BC0DCF83C0
   ```
   insert
   ```text
   2026-11-26T19:54:27Z	new	workbench	-	records/WS-051	WS-052	WS-052 WS-051 summary	D321E7900A7C1EA7DC63FDC10C33C1ADDF2BADCD829573240AE37561757D9D91
   ```

   The resulting file's Git blob is 3f205975f30a199c3f58184fa107db8160b2bcc7.

3. Check whether `lib/apply-draft-steps.ps1` contains `# absent file is Already Applied, and the plan's blob for it is the null blob (40 zeros), which the lifecycle reads as absent.`; if so record Already Applied when its Git blob is a17930e4ffc43781305121535e74758ac4db0fb1, and otherwise stop and report. Otherwise make exactly these 8 edits (land this exact frozen WS-052 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   # Preflight every target, operation and filtered blob before the first implementation write.
   ```
   insert
   ```text
   # WS-052: a step "N. Delete `path`, whose baseline Git blob is <40 hex>." removes a file that still holds that blob; an
   # absent file is Already Applied, and the plan's blob for it is the null blob (40 zeros), which the lifecycle reads as absent.
   ```

   b) replace the line
   ```text
   $items=@([regex]::Split($section.Groups[1].Value,'(?m)^(?=\d+\. )')|Where-Object{$_-match'^\d+\. Check whether '})
   ```
   with
   ```text
   $items=@([regex]::Split($section.Groups[1].Value,'(?m)^(?=\d+\. )')|Where-Object{$_-match'^\d+\. (Check whether|Delete) '})
   ```

   c) replace the line
   ```text
   $plans=@();$paths=@{}
   ```
   with
   ```text
   $plans=@();$paths=@{};$nullBlob='0'*40
   ```

   d) immediately after the line
   ```text
   foreach($it in $items){
   ```
   insert
   ```text
       if($it-match'^\d+\. Delete '){
           $deleteMatch=[regex]::Match($it,'^\d+\. Delete `([^`]+)`, whose baseline Git blob is ([0-9a-f]{40})\.')
           if(!$deleteMatch.Success){throw 'DELETE_STEP_INVALID'}
           $file=$deleteMatch.Groups[1].Value;$p=Get-DraftTargetPath $Root $file
           if($paths.ContainsKey($p)){throw "DUPLICATE_TARGET:$file"};$paths[$p]=$true
           if(Test-Path -LiteralPath $p -PathType Container){throw "TARGET_IS_DIRECTORY:$file"}
           if(![IO.File]::Exists($p)){$plans+=[pscustomobject]@{File=$file;Path=$p;Skip=$true;Create=$false;Delete=$true;Blob=$nullBlob};continue}
           $found=@(git -C $Root hash-object "--path=$file" -- $p)
           if($LASTEXITCODE-or$found.Count-ne1-or$found[0]-cne$deleteMatch.Groups[2].Value){throw "DELETE_BASELINE_BLOB_MISMATCH:$file"}
           $plans+=[pscustomobject]@{File=$file;Path=$p;Skip=$false;Create=$false;Delete=$true;Before=[Convert]::ToBase64String([IO.File]::ReadAllBytes($p));Blob=$nullBlob}
           continue
       }
   ```

   e) replace the line
   ```text
           $plans+= [pscustomobject]@{File=$file;Path=$p;Skip=$true;Create=$false;Blob=$want}
   ```
   with
   ```text
           $plans+= [pscustomobject]@{File=$file;Path=$p;Skip=$true;Create=$false;Delete=$false;Blob=$want}
   ```

   f) replace the line
   ```text
       $plans+=[pscustomobject]@{File=$file;Path=$p;Skip=$false;Create=$creating;Before=$raw;Text=$text;Blob=$got}
   ```
   with
   ```text
       $plans+=[pscustomobject]@{File=$file;Path=$p;Skip=$false;Create=$creating;Delete=$false;Before=$raw;Text=$text;Blob=$got}
   ```

   g) replace the line
   ```text
           Files=@($plans|ForEach-Object{[ordered]@{File=$_.File;Blob=$_.Blob;Skip=$_.Skip;Create=$_.Create}})}|ConvertTo-Json -Depth 5
   ```
   with
   ```text
           Files=@($plans|ForEach-Object{[ordered]@{File=$_.File;Blob=$_.Blob;Skip=$_.Skip;Create=$_.Create;Delete=$_.Delete}})}|ConvertTo-Json -Depth 5
   ```

   h) immediately after the line
   ```text
       if($checked-cne$plan.Path){throw 'TARGET_CHANGED'}
   ```
   insert
   ```text
       if($plan.Delete){
           if([Convert]::ToBase64String([IO.File]::ReadAllBytes($plan.Path))-cne$plan.Before){throw "TARGET_CHANGED:$($plan.File)"}
           [IO.File]::Delete($plan.Path);"DELETED: $($plan.File)";continue
       }
   ```

   The resulting file's Git blob is a17930e4ffc43781305121535e74758ac4db0fb1.

4. Check whether `lib/Invoke-ContractLifecycle.ps1` contains `# WS-052: an output whose blob is the null blob (40 zeros) is a file the Draft deletes, so absent reads as that blob.`; if so record Already Applied when its Git blob is 18c027d39f6cab0786c043c9cea46cf398e9fcd8, and otherwise stop and report. Otherwise make exactly these 5 edits (land this exact frozen WS-052 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   function Get-RootHead{@(Invoke-RootGit @('rev-parse','HEAD'))[0]}
   ```
   insert
   ```text
   # WS-052: an output whose blob is the null blob (40 zeros) is a file the Draft deletes, so absent reads as that blob.
   $nullBlob='0'*40
   function Get-TreeBlob([string]$Tree,[string]$Path){$row=@(Invoke-RootGit @('ls-tree',$Tree,'--',$Path));if($row.Count){($row[0]-split'\s')[2]}else{$nullBlob}}
   function Get-LiveBlob([string]$Path){$file=Join-Path $executionRoot $Path;if(Test-Path -LiteralPath $file){@(Invoke-RootGit @('hash-object',('--path='+$Path),'--',$file))[0]}else{$nullBlob}}
   ```

   b) replace the line
   ```text
           foreach($output in $m.Outputs){$row=@(Invoke-RootGit @('ls-tree',$Tree,'--',$output.Path));$mode=if($row.Count){($row[0]-split' ')[0]}else{'100644'};$null=Invoke-RootGit @('update-index','--add','--cacheinfo',"$mode,$($output.Blob),$($output.Path)")}
   ```
   with
   ```text
           foreach($output in $m.Outputs){$row=@(Invoke-RootGit @('ls-tree',$Tree,'--',$output.Path));$mode=if($row.Count){($row[0]-split' ')[0]}else{'100644'};if($output.Blob-ceq$nullBlob){$null=Invoke-RootGit @('update-index','--force-remove','--',$output.Path)}else{$null=Invoke-RootGit @('update-index','--add','--cacheinfo',"$mode,$($output.Blob),$($output.Path)")}}
   ```

   c) replace the line
   ```text
       foreach($output in $m.Outputs){if(@(Invoke-RootGit @('rev-parse',"${Tree}:$($output.Path)"))[0]-cne$output.Blob){throw 'LIFECYCLE_COMMITTED_OUTPUT_DIFFERS'}}
   ```
   with
   ```text
       foreach($output in $m.Outputs){if((Get-TreeBlob $Tree $output.Path)-cne$output.Blob){throw 'LIFECYCLE_COMMITTED_OUTPUT_DIFFERS'}}
   ```

   d) replace the line
   ```text
           foreach($output in $m.Outputs){if(@(Invoke-RootGit @('hash-object',('--path='+$output.Path),'--',(Join-Path $executionRoot $output.Path)))[0]-cne$output.Blob){throw 'LIFECYCLE_LIVE_OUTPUT_DIFFERS'}}
   ```
   with
   ```text
           foreach($output in $m.Outputs){if((Get-LiveBlob $output.Path)-cne$output.Blob){throw 'LIFECYCLE_LIVE_OUTPUT_DIFFERS'}}
   ```

   e) replace the line
   ```text
       foreach($output in $m.Outputs){if(@(Invoke-RootGit @('hash-object',('--path='+$output.Path),'--',(Join-Path $executionRoot $output.Path)))[0]-cne$output.Blob){throw 'LIFECYCLE_NATIVE_OUTPUT_DIFFERS'}}
   ```
   with
   ```text
       foreach($output in $m.Outputs){if((Get-LiveBlob $output.Path)-cne$output.Blob){throw 'LIFECYCLE_NATIVE_OUTPUT_DIFFERS'}}
   ```

   The resulting file's Git blob is 18c027d39f6cab0786c043c9cea46cf398e9fcd8.

5. Check whether `lib/README.md` contains `step removes a file still at its baseline blob |`; if so record Already Applied when its Git blob is ac8e1fccebc0c210d12642ec29081e43d36d23e0, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-052 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   | `apply-draft-steps.ps1 -Draft <d> -Root <clone>` | proves a Draft's steps reproduce its blobs |
   ```
   with
   ```text
   | `apply-draft-steps.ps1 -Draft <d> -Root <clone>` | proves a Draft's steps reproduce its blobs; a `Delete` step removes a file still at its baseline blob |
   ```

   The resulting file's Git blob is ac8e1fccebc0c210d12642ec29081e43d36d23e0.

6. Check whether `lib/test-contract-lifecycle.ps1` contains `$null=FixGit $sandbox read-tree --reset -u $chain[$i]`; if so record Already Applied when its Git blob is bea8d2c7d427e03a099a39f116fed7e9d84b230c, and otherwise stop and report. Otherwise make exactly these 6 edits (land this exact frozen WS-052 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
           $null=FixGit $sandbox checkout --quiet $chain[$i] -- .
   ```
   with
   ```text
           $null=FixGit $sandbox read-tree --reset -u $chain[$i]
   ```

   b) replace the line
   ```text
   'Execute'{if($record.Checkpoint['Resume Step']-cne'DONE'){[void][IO.Directory]::CreateDirectory((Join-Path $Root 'docs'));[IO.File]::WriteAllText((Join-Path $Root 'lib\tool.ps1'),"# tool v2`r`n");[IO.File]::WriteAllText((Join-Path $Root 'docs\new.txt'),"new`n");[IO.File]::WriteAllText((Join-Path $Root 'lib\test-new.ps1'),"# new test`r`n")}elseif($env:LIFECYCLE_FIXTURE_REFUSE-ceq'ExecuteDone'){exit 9}}
   ```
   with
   ```text
   'Execute'{if($record.Checkpoint['Resume Step']-cne'DONE'){[void][IO.Directory]::CreateDirectory((Join-Path $Root 'docs'));[IO.File]::WriteAllText((Join-Path $Root 'lib\tool.ps1'),"# tool v2`r`n");[IO.File]::WriteAllText((Join-Path $Root 'docs\new.txt'),"new`n");[IO.File]::WriteAllText((Join-Path $Root 'lib\test-new.ps1'),"# new test`r`n");[IO.File]::Delete((Join-Path $Root 'docs\old.txt'))}elseif($env:LIFECYCLE_FIXTURE_REFUSE-ceq'ExecuteDone'){exit 9}}
   ```

   c) replace the line
   ```text
   [ordered]@{DraftSHA256=$sha;Files=@([ordered]@{File='lib/tool.ps1';Blob=$blob;Skip=$false},[ordered]@{File='docs/new.txt';Blob='__NEWBLOB__';Skip=$false},[ordered]@{File='lib/test-new.ps1';Blob='__TESTNEWBLOB__';Skip=$false})}|ConvertTo-Json -Depth 4
   ```
   with
   ```text
   [ordered]@{DraftSHA256=$sha;Files=@([ordered]@{File='lib/tool.ps1';Blob=$blob;Skip=$false},[ordered]@{File='docs/new.txt';Blob='__NEWBLOB__';Skip=$false},[ordered]@{File='lib/test-new.ps1';Blob='__TESTNEWBLOB__';Skip=$false},[ordered]@{File='docs/old.txt';Blob=('0'*40);Skip=$false;Delete=$true})}|ConvertTo-Json -Depth 4
   ```

   d) replace the line
   ```text
       $outputs=@([pscustomobject]@{Path='lib/tool.ps1';Blob=$toolBlob},[pscustomobject]@{Path='docs/new.txt';Blob=$newBlob},[pscustomobject]@{Path='lib/test-new.ps1';Blob=$testNewBlob})
   ```
   with
   ```text
       $outputs=@([pscustomobject]@{Path='lib/tool.ps1';Blob=$toolBlob},[pscustomobject]@{Path='docs/new.txt';Blob=$newBlob},[pscustomobject]@{Path='lib/test-new.ps1';Blob=$testNewBlob},[pscustomobject]@{Path='docs/old.txt';Blob='0'*40})
   ```

   e) immediately after the line
   ```text
       Write-Crlf (Join-Path $original 'lib\tool.ps1') "# tool v1`n"
   ```
   insert
   ```text
       Write-Crlf (Join-Path $original 'docs\old.txt') "old`n"
   ```

   f) immediately after the line
   ```text
   - lib/test-new.ps1
   ```
   insert
   ```text
   - docs/old.txt
   ```

   The resulting file's Git blob is bea8d2c7d427e03a099a39f116fed7e9d84b230c.

7. Check whether `lib/test-draft-steps.ps1` contains `# WS-052: a Delete step removes a file only while it holds the declared baseline blob, preflighted with every other step.`; if so record Already Applied when its Git blob is 124a9f00848dda8f0aab89d29939b6da442d31db, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-052 candidate output), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
       Assert-DraftCase 'two None lines are refused' ($x.Code-ne0-and$x.Text-match'POINTER_NONE_COUNT:2') $x.Text
   }
   ```
   insert
   ```text
   # WS-052: a Delete step removes a file only while it holds the declared baseline blob, preflighted with every other step.
   function Test-DeleteCases{
       $r=Join-Path $root 'delete';New-Item -ItemType Directory -Force (Join-Path $r 'docs')|Out-Null
       git -C $r init -q;git -C $r config core.autocrlf true
       [IO.File]::WriteAllText("$r\docs\old.txt","old`r`nbody`r`n");[IO.File]::WriteAllText("$r\keep.txt","MARK`nkeep`n")
       git -C $r add .;git -C $r -c user.name=t -c user.email=t@t commit -qm base
       $old=@(git -C $r rev-parse HEAD:docs/old.txt)[0]
       [IO.File]::WriteAllText("$r\keep.txt","MARK`nkept`n");$s=Get-DraftFileStep $r 'keep.txt' 'MARK' 'delete fixture';git -C $r checkout -q -- keep.txt
       $del="Delete ``docs/old.txt``, whose baseline Git blob is $old."
       $d="$r\draft.md";$write={param([string[]]$Steps)$n=0;[IO.File]::WriteAllText($d,"## Implementation Steps`n`n"+(($Steps|ForEach-Object{$n++;"$n. $_"})-join"`n`n")+"`n`n## Acceptance Criteria`n")}
       $run={param([string[]]$Extra)$o=& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'apply-draft-steps.ps1') -Draft $d -Root $r @Extra 2>&1|Out-String;[pscustomobject]@{Code=$LASTEXITCODE;Text=$o}}
       $target="$r\docs\old.txt"
       & $write @($del,$s.Text);$x=& $run @('-Preview');$v=try{$x.Text|ConvertFrom-Json}catch{$null};$e=@($v.Files|Where-Object File -CEQ 'docs/old.txt')
       Assert-DraftCase 'a delete preview plans the null blob and keeps the file' ($x.Code-eq0-and$e.Count-eq1-and$e[0].Delete-eq$true-and$e[0].Skip-eq$false-and$e[0].Blob-ceq('0'*40)-and(Test-Path -LiteralPath $target)) $x.Text
       & $write @($s.Text.Replace($s.Blob,'0'*40),$del);$x=& $run @()
       Assert-DraftCase 'a later blob mismatch refuses before an earlier delete' ($x.Code-ne0-and$x.Text-match'DRAFT_BLOB_MISMATCH'-and(Test-Path -LiteralPath $target)) $x.Text
       & $write @($del.Replace($old,'1'*40));$x=& $run @()
       Assert-DraftCase 'a delete of other bytes than the baseline blob is refused' ($x.Code-ne0-and$x.Text-match'DELETE_BASELINE_BLOB_MISMATCH'-and(Test-Path -LiteralPath $target)) $x.Text
       & $write @($del.Replace('docs/old.txt','../old.txt'));$x=& $run @()
       Assert-DraftCase 'a delete outside the root is refused' ($x.Code-ne0-and$x.Text-match'DRAFT_PATH_INVALID') $x.Text
       & $write @($del.Replace('docs/old.txt','docs'));$x=& $run @()
       Assert-DraftCase 'a delete of a directory is refused' ($x.Code-ne0-and$x.Text-match'TARGET_IS_DIRECTORY'-and(Test-Path -LiteralPath $target)) $x.Text
       & $write @("Delete docs/old.txt.");$x=& $run @()
       Assert-DraftCase 'a malformed delete step is refused' ($x.Code-ne0-and$x.Text-match'DELETE_STEP_INVALID'-and(Test-Path -LiteralPath $target)) $x.Text
       & $write @($del,$s.Text);$x=& $run @()
       Assert-DraftCase 'a delete step removes the file with the other steps' ($x.Code-eq0-and$x.Text-match'DELETED: docs/old.txt'-and!(Test-Path -LiteralPath $target)-and@(git -C $r hash-object -- keep.txt)[0]-ceq$s.Blob) $x.Text
       $x=& $run @()
       Assert-DraftCase 'a resumed delete records Already Applied' ($x.Code-eq0-and$x.Text-match'ALREADY_APPLIED: docs/old.txt'-and!(Test-Path -LiteralPath $target)) $x.Text
   }
   ```

   b) immediately after the line
   ```text
       Test-PointerCases
   ```
   insert
   ```text
       Test-DeleteCases
   ```

   The resulting file's Git blob is 124a9f00848dda8f0aab89d29939b6da442d31db.

8. Check whether `records/README.md` contains `| WS-051/ | records | Summary of WS-051 reply form and preview pointer | agents, the owner | 2026-11-26 |`; if so record Already Applied when its Git blob is f0f22ea51c5dc0839654b45da94acb5c0cebe1e5, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-052 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-050/ | records | Summary of WS-050 summaries and summary check | agents, the owner | 2026-11-26 |
   ```
   insert
   ```text
   | WS-051/ | records | Summary of WS-051 reply form and preview pointer | agents, the owner | 2026-11-26 |
   ```

   b) replace the lines
   ```text
   | --- | --- | --- | --- | --- |
   | 2026-11-25T21:23:13Z | new | - | records/WS-041 | WS-050 WS-041 summary |
   ```
   with
   ```text
   | --- | --- | --- | --- | --- |
   ```

   c) immediately after the line
   ```text
   | 2026-11-26T15:10:22Z | new | - | records/WS-050 | WS-051 WS-050 summary |
   ```
   insert
   ```text
   | 2026-11-26T19:54:27Z | new | - | records/WS-051 | WS-052 WS-051 summary |
   ```

   d) immediately after the line
   ```text
   - [WS-050/README.md](WS-050/README.md)
   ```
   insert
   ```text
   - [WS-051/README.md](WS-051/README.md)
   ```

   The resulting file's Git blob is f0f22ea51c5dc0839654b45da94acb5c0cebe1e5.

9. Check whether `records/WS-051/README.md` contains `Purpose: Summary of WS-051 reply form and preview pointer. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is e5e406db48efb553995a77cc962e9fbd2d1eda0c, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-052 candidate output), and change nothing else:

   ```text
   # WS-051

   Purpose: Summary of WS-051 reply form and preview pointer. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-26T19:54:27Z | new | - | records/WS-051 | WS-052 WS-051 summary |
   <!-- /organize:changes -->

   # WS-051 reply form and preview pointer

   Summary of a finished workstream (DEC-11), written in WS-052 by data/records/WS-052/summaries.ps1 from the change
   file, its receipts and the records in data/records/WS-051/; it changes no evidence. Paths that begin with data/ are in
   the data root, which is backed up and not published.
   Evidence: data/records/WS-051/.

   ## Result

   - Change file: changes/WS-051-reply-form-and-preview-pointer.md, SHA256 60D7278EE49436F71E118BC003835E0FF0F9E6557DE8D8DF23327E1AFAA8B320
   - Status: Complete
   - Verdict: Confirmed Complete
   - Reviewed Fingerprint: 4C296AE2E790BC35F933FCDAE066019A9685AF14037ECB2F2BC2ABEF95FB7FD3
   - Reviewed Receipt: BE3C5F139415B89DD31184EB7AEA0FFBFA4967D757E125529A28130E26650F25
   - Complete commit: 8d3822e WS-051: Original Complete with own native receipt

   ## Receipt

   The original own Finish receipt, `data/records/WS-051/receipts/original-own-finish-receipt.json`, SHA256 18E71881C33C330AB04B93B00F2F1EA8DBCDA1ED890AB6FAC5C6406AFB9DBD7B; its digest equals the Reviewed
   Receipt above. Copied from `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W51\runtime\original\own-finish-receipt.json`. The sandbox receipt, `data/records/WS-051/receipts/sandbox-own-finish-receipt.json`, SHA256 13635F4C9B71382E040D4A0972085DBD8A3970DCC992244BF6D07B3CBDFD328C,
   equals the Sandbox Receipt SHA256 of the change file. Run-start host and other-product names masked (D119):

   ~~~json
   {
     "schema": 2,
     "root": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench",
     "contract": "changes/WS-051-reply-form-and-preview-pointer.md",
     "finishHead": "84932478ca79acb04d8ca8693a0d59f272a7474c",
     "fingerprint": "4C296AE2E790BC35F933FCDAE066019A9685AF14037ECB2F2BC2ABEF95FB7FD3",
     "profiles": [
       "CONTROL",
       "COORDINATION",
       "REPOSITORY"
     ],
     "evaluator": "e0bf56b4f3dd2f444120bcb96af24f1538b314ea",
     "runLog": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\sb\\W51\\runtime\\original\\finish.log",
     "runStart": "[2026-11-26 19:37:54] START pid=3556 host=[masked] pwsh=7.6.8 cpus=8 head=8493247 concurrent=[masked],[masked],[masked],[masked],[masked],[masked],[masked],[masked],Sync-Sessions.ps1,Run-Stage.ps1,Invoke-ContractLifecycle.ps1,Watch-Host.ps1 | & pwsh -NoProfile -File 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\lib\\Workbench.ps1' -Root 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench' -Finish -Actionlint 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\tools\\actionlint.exe'",
     "result": "READY",
     "draftSHA256": "2FF8B47FA82D8DA73C5ED02554CE887731DD9EEDE48C69F3E5DD3B3D5B79E378",
     "recipe": "5ECF9266DD1CBA49FCAFAEFBEE539146C039401FB8C329D27DA650C194BBBBCE",
     "role": "ORIGINAL",
     "proof": "A272927E485BC8B74293207386B963A726071B2061863C8BD3EF215E7554E350",
     "digest": "BE3C5F139415B89DD31184EB7AEA0FFBFA4967D757E125529A28130E26650F25"
   }
   ~~~

   ## Versions

   | Version | Id | Role and author | SHA256 | Draft check | Chosen |
   | --- | --- | --- | --- | --- | --- |
   | V1 | WS051-V1-CLAUDE-SIGNIFICANT-DESIGN-20261126-01 | DESIGN by Claude main | BE4C91CB66ED9597583992D53CCBC34B7B08CE7471E1E06295B846EF48D26426 | FAIL | no: V3 is the Approved Draft (DEC-13) |
   | V2 | WS051-V2-CLAUDE-SIGNIFICANT-ADVERSARIAL-20261126-01 | ADVERSARIAL by Claude main | 255CAE0735B3E0D5A49F5D7170FB716A05AF584863DD7E3A3F1A42DAC7808E89 | PASS | no: V3 is the Approved Draft (DEC-13) |
   | V3 | WS051-V3-CLAUDE-REFRESH-20261126-01 | REFRESH by Claude main | 2FF8B47FA82D8DA73C5ED02554CE887731DD9EEDE48C69F3E5DD3B3D5B79E378 | PASS | yes: the Approved Draft |

   ## Failed, refused, superseded and stopped attempts (1)

   - `data/records/WS-051/lifecycle-sandbox.txt:1`: sandbox prepare failed (exit 1 after 1 s). LIFECYCLE_ORIGINAL_NOT_AT_BASELINE (stated in data/records/WS-051/lifecycle-sandbox.txt:4)

   ## Cited files (14)

   | File | SHA256 |
   | --- | --- |
   | data/records/WS-051/receipts/original-own-finish-receipt.json | 18E71881C33C330AB04B93B00F2F1EA8DBCDA1ED890AB6FAC5C6406AFB9DBD7B |
   | data/records/WS-051/receipts/sandbox-own-finish-receipt.json | 13635F4C9B71382E040D4A0972085DBD8A3970DCC992244BF6D07B3CBDFD328C |
   | data/records/WS-051/assurance/V1/DRAFT.md | BE4C91CB66ED9597583992D53CCBC34B7B08CE7471E1E06295B846EF48D26426 |
   | data/records/WS-051/assurance/V2/DRAFT.md | 255CAE0735B3E0D5A49F5D7170FB716A05AF584863DD7E3A3F1A42DAC7808E89 |
   | data/records/WS-051/assurance/V3/DRAFT.md | 2FF8B47FA82D8DA73C5ED02554CE887731DD9EEDE48C69F3E5DD3B3D5B79E378 |
   | data/records/WS-051/gate/GATE1-WS051-ORIGINAL-DELEGATED.md | 010CEABB653EA10D6FBA9A0FF982A0396E71169E12C7236E40588B88AC101A73 |
   | data/records/WS-051/candidate.patch | 26D868067BD05A6C33DCEDEFA025B9AFDAF5B6AF7A7A7BFBB39BB48EB52CA6BF |
   | data/records/WS-051/CONTRACT.md | FC3AFADF63D9AE0E927B395D9DF824CED3289909A0915A19406BD7DE30D46601 |
   | data/records/WS-051/lifecycle-original.txt | 2EBA3424ECD021F294FE6267F85026E8E9B1F8F781A9C2847ED83601DA66E010 |
   | data/records/WS-051/lifecycle-sandbox.txt | ACFAA6DF64F19F4AD66DB64D33FFBC671F71241DC568F51FD459935F1E7B6B9F |
   | data/records/WS-051/Make-Candidate.ps1 | 0D5BD23634C4F1F0D0E360CCFE216868053ED7290C834D7EA5FD786B0566EAC0 |
   | data/records/WS-051/manifest.json | 1775BB2B2261FA9FD6851E8E4461C5A2C4A765E23CAD01DEC07D6EC434B8BCAB |
   | data/records/WS-051/Run-Stage.ps1 | 267DC719974620F45346ACD74B723A8746C0566C2A244890424349B1B9AE01EB |
   | data/records/WS-051/summaries.ps1 | 98AD0CBAF872D7A35CA70E2C490BAEBC2B91AF6F4672E23D1EA7B2BBEC70CB80 |
   ```

   The resulting file's Git blob is e5e406db48efb553995a77cc962e9fbd2d1eda0c.

10. Check whether `RESUME.md` contains `Live state: data/work/NOW.md in the resolved data root, written only by lib/Save-State.ps1 (DEC-26); lib/Pulse.ps1 shows what runs; see lib/README.md.`; if so record Already Applied when its Git blob is 95648442f394d0fa68c9bbc6b56a02a3f43448a6, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-052 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   Live state: lib/Pulse.ps1 (resolved data root); if unavailable use the newest RESUME HERE journal entry through lib/Events.ps1 -Find 'resume here'; see lib/README.md.
   ```
   with
   ```text
   Live state: data/work/NOW.md in the resolved data root, written only by lib/Save-State.ps1 (DEC-26); lib/Pulse.ps1 shows what runs; see lib/README.md.
   ```

   The resulting file's Git blob is 95648442f394d0fa68c9bbc6b56a02a3f43448a6.

## Acceptance Criteria

- [ ] Output `changes/README.md` equals its declared resulting Git blob. check: blob:changes/README.md=cb18b04d8b696b0b328964c6380791ac4cfeb2b9
- [ ] Output `docs/history/LOG.tsv` equals its declared resulting Git blob. check: blob:docs/history/LOG.tsv=3f205975f30a199c3f58184fa107db8160b2bcc7
- [ ] Output `lib/apply-draft-steps.ps1` equals its declared resulting Git blob. check: blob:lib/apply-draft-steps.ps1=a17930e4ffc43781305121535e74758ac4db0fb1
- [ ] Output `lib/Invoke-ContractLifecycle.ps1` equals its declared resulting Git blob. check: blob:lib/Invoke-ContractLifecycle.ps1=18c027d39f6cab0786c043c9cea46cf398e9fcd8
- [ ] Output `lib/README.md` equals its declared resulting Git blob. check: blob:lib/README.md=ac8e1fccebc0c210d12642ec29081e43d36d23e0
- [ ] Output `lib/test-contract-lifecycle.ps1` equals its declared resulting Git blob. check: blob:lib/test-contract-lifecycle.ps1=bea8d2c7d427e03a099a39f116fed7e9d84b230c
- [ ] Output `lib/test-draft-steps.ps1` equals its declared resulting Git blob. check: blob:lib/test-draft-steps.ps1=124a9f00848dda8f0aab89d29939b6da442d31db
- [ ] Output `records/README.md` equals its declared resulting Git blob. check: blob:records/README.md=f0f22ea51c5dc0839654b45da94acb5c0cebe1e5
- [ ] Output `records/WS-051/README.md` equals its declared resulting Git blob. check: blob:records/WS-051/README.md=e5e406db48efb553995a77cc962e9fbd2d1eda0c
- [ ] RESUME routing equals the approved line 2 after native pointer normalization only. check: normalized-resume:RESUME.md=02B311D60DE22D03224E0B64BA88124E5C7731FB4DC49BC67E8A05E22875B010
- [ ] AC-01 Behaviour: lib/apply-draft-steps.ps1 (numstat 23/5) adds only the `N. Delete` step: its header comment, the step filter that admits `Delete`, the parse refusing a malformed step (DELETE_STEP_INVALID), the shared preflight (path check, DUPLICATE_TARGET, TARGET_IS_DIRECTORY), Already Applied for an absent file, DELETE_BASELINE_BLOB_MISMATCH for a present file whose blob is not the declared one before any write, the preview entry with Delete=true and the null blob, and the apply that re-reads the bytes (TARGET_CHANGED) before it deletes; every existing refusal and the -PointerContract path are unchanged. lib/Invoke-ContractLifecycle.ps1 (8/4) changes only its output reads: it adds the null blob and two readers (Get-TreeBlob, Get-LiveBlob) that return it for a missing path, the prediction removes a null-blob path from its throwaway index instead of adding it, and the committed, live and native-output checks use those readers. RESUME.md (1/1) changes only line 2, which equals line 20 of data/records/WS-050/candidate.patch without its `+`. lib/README.md (1/1) changes only the apply-draft-steps row, which names the Delete step.
- [ ] AC-02 Summaries, tests and documentation: records/WS-051/README.md (93/0) is the WS-051 summary holding its Organize header, and records/README.md (3/1) and docs/history/LOG.tsv (1/0) hold exactly the Files line and LOG row Organize -New and -Refresh write for it, no earlier row changed; no summary holds the owner's e-mail, the computer name or an unmasked run-start host. lib/test-draft-steps.ps1 (30/0) adds exactly Test-DeleteCases (eight cases) and its call; lib/test-contract-lifecycle.ps1 (6/4) gives its fixture one deleted file (docs/old.txt, the null blob in its outputs, its preview stub and its Write Scope) that both roles' lifecycles accept, and its forged-chain helper replays each commit's tree with read-tree so the deletion carries; no existing check is removed or weakened. Three production mutants on the replay must each make their owning test fail, and the Draft check must kill all three and restore the bytes: BASELINE (the baseline blob comparison removed from the Delete preflight; test-draft-steps, first FAIL 'a delete of other bytes than the baseline blob is refused'), NULLBLOB (a missing output read as forty `f` instead of the null blob; test-contract-lifecycle, first FAIL 'a native Execute refusal after DONE stops', and 'Sandbox implement passes' failing too) and RESUMELINK (RESUME line 2 linking a missing lib/MISSING-README.md; test-markdown-consistency exits nonzero with MD_LINK_MISSING: RESUME.md -> lib/MISSING-README.md). test-draft-steps, test-contract-lifecycle, test-organize and test-markdown-consistency pass on the replay, the last also with this contract in place. Organize -Check -Quick on the replay with this contract in place (temporary and data roots isolated and absent) prints no NO_SUMMARY finding, also with this contract marked Complete; with it marked Complete and records/WS-051/README.md removed it prints exactly NO_SUMMARY workbench:records/WS-051; the removed bytes come back.
- [ ] AC-03 Organizer: changes/README.md (1/0) is what lib/Organize.ps1 -Refresh writes: it holds the WS-052 row, and a refresh of the replay with this contract in place changes no organizer.
- [ ] AC-04 Secrets and privacy: gitleaks on the exact candidate range reports no finding in the 10 outputs; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; neither masked value (the computer name, a marketing tunnel script name) nor the owner's e-mail is in any changed file or in this contract.
- [ ] AC-05 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step (RESUME.md after the native pointer, to its declared blob), one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria; the scope profiles run the owning tests of every changed file. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json. From each Finish launch to END: no Events -Add, Save-State or edit in a protected root, and Docker off.
- [ ] AC-06 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-052/evidence/protected-before.json, captured before the sandbox Finish and again after Original Complete with data/records/WS-038/Capture-Protected.ps1; lib/Test-WorkbenchChange.ps1 and lib/Workbench.ps1 are unchanged; lib/Invoke-ContractLifecycle.ps1 and lib/apply-draft-steps.ps1 change only as AC-01 says, and both roles ran the baseline controller copy data/records/WS-052/controller/Invoke-ContractLifecycle.ps1 whose SHA256 this Draft names, checked before each stage; no tracked file is deleted by this contract; CRM, ORVION and their trusted copies keep their HEAD and files (the lifecycle's protected-root compare); no Supabase project is touched; no Codex, subagent, RAM, power setting or scheduled task change; no push before both roles are Complete.

## Review Gate

- [ ] Inspect the live subject, this role's fresh receipt, timing and watching evidence, and every criterion above, with attempts, deviations and gaps kept visible. No prototype result or earlier receipt substitutes for this role's gate.
- [ ] Review: one Claude-main self-review, labelled as such and never called independent. The Codex review (DEC-14) is recorded SKIPPED by the owner's decision of 2026-11-08 ~01:20 Cairo, never replaced or claimed (D120). At most one corrective version; a remaining material disagreement goes to the owner.
- [ ] Retro (DEC-12): Claude main names what does not satisfy it, each item with a remedy and a check.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Append only. No approval, execution-root binding or receipt is claimed. At actual approval add exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line using actual immutable identities. Owner evidence must name the approved digest and execution root. For original execution append exactly one Sandbox Receipt and Sandbox Receipt SHA256 for the matching successful schema2 sandbox artifact. A delegated decision needs actual live owner delegation and is labelled delegated. Never invent human confirmation or approval.

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W52-c2 (data/records/WS-052/Make-Candidate.ps1). Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json beside this Draft. The WS-051 summary's facts come from raw records (data/records/WS-052/summaries.ps1). After Complete, outside this contract: the release under DEC-25 on the DELEGATED record, only when every gate passed and Claude main's retro is satisfied; the protected state is compared with its record from before; the memory pointers to the live-state route and the Delete step; Save-State records the result.
