# Workbench Change Request - WS-044

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Let a real backup survive a short-lived reader of its status file, with the scope of data/records/WS-044/CONTRACT.md section 3. lib/Backup-Workspace.ps1: Write-BackupStatus retries the atomic replace of latest.json ([IO.File]::Move of the pending file with overwrite) when Windows refuses it with UnauthorizedAccessException, every 25 ms up to 80 tries (about 2 s), and then throws as before; no other exception is retried, and the record format, the pending file and the verified pointer are unchanged. lib/test-backup-restore.ps1: one case opens latest.json for reading, releases it after 300 ms and runs the real Write-BackupStatus (the new record lands, no pending file is left), and a test-level mutant without the retry is killed by the same reader (the write fails, the prior record stays). changes/README.md gets the WS-044 row Organize -Refresh writes. Benefit: the WS-042 Original Finish failed because the backup child died at that replace while the test polled the status (data/records/WS-042/BLOCKED-original-finish.md); any reader (a status poll, an indexer, antivirus, a person) could do the same to a real backup, and every later Finish runs that test.

Tier: Significant under DEC-12 (a change to the backup writer, recovery risk). Governance check: every consumer listed (CONTRACT.md section 3); the changed test runs once with its test root outside any ORVION-Workbench-temporary folder; mutants each killed by a named case; one real backup and restore (the Finish's test-backup-restore publishes a real 7z archive and restores it to scratch); a retro closes the workstream. Authority: DEC-02, DEC-08, DEC-09, DEC-11, DEC-12, DEC-13, DEC-14, DEC-22, DEC-23, DEC-24, DEC-25, DEC-26, DEC-30 and DEC-33; the owner's reply "A" of 2026-11-15 ~14:10 Cairo to "Open WS-044 (backup status race fix, Significant) then rerun WS-042? Reply A", frozen verbatim in data/records/WS-044/owner-words/owner-2026-11-15-A-backup-race-fix-approved.txt (SHA256 8CE98342D8737E4CEB3EC2A73631135490F94C87C62C8CA95C82BEA2DC27F2A5), with Run Mode 1 standing from the owner's words of 2026-11-14 ~22:04 Cairo (data/records/WS-042/owner-words/owner-2026-11-14-2204-improving-loop-significant-approved.txt, SHA256 DC344EE74A7122CF97F43EC45EE797FDD89B70C6D19ACD7D77B3A88BC2A24180). Every scope choice is Claude main's under that authority, labelled DELEGATED; no owner text is typed by an agent (DEC-02).

Number: WS-044. Intended contract: changes/WS-044-backup-status-reader-retry.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: this contract changes neither lib/Invoke-ContractLifecycle.ps1 nor the judge and adds no script, so both roles run the Original's own controller (SHA256 AD76811656C7DAEEED7D214597F986178B57BA7943DE4B16F0438A33F57CEF57), its SHA256 checked before each stage, with the accepted judge. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

fcf5649f27a2184d54e4c2cdf1d44d419fdb0ed5

## Write Scope

- changes/README.md
- lib/Backup-Workspace.ps1
- lib/test-backup-restore.ps1
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: every other function of lib/Backup-Workspace.ps1 (the archive, the 7z verification, the lease, the verified pointer), lib/Restore-Workspace.ps1, docs/RECOVERY.md (its line on a status-write failure keeping prior bytes stays true), the test's other cases and its reader helpers, lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Workbench.ps1 and every other lib/ file, test and hook; the daily backup task and its schedule; every DEC entry; .claude/settings.json and the user settings in the owner's profile; the WS-042 scope (its own contract, rerun after this one); data/ (untracked); the seven legacy folders, Owner-Tools, the vault and every package; any CRM or ORVION change (DEC-08), credentials, real sessions or events (DEC-09); Batch 6 slice 11 (on hold); Codex, subagents, RAM, power or scheduled-task changes; any push or release before both roles are Complete (DEC-25).

## Draft Assurance

V1: WS044-V1-CLAUDE-SIGNIFICANT-DESIGN-20261115-01 | 2026-11-15 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-044\assurance\V1\DRAFT.md | AFE6B8B4286BC6F610F814F562D4E63FEBA60677A70FADC7BE143FD137CF0995
V2: WS044-V2-CLAUDE-SIGNIFICANT-ADVERSARIAL-20261115-01 | 2026-11-15 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-044\assurance\V2\DRAFT.md | 4C9FB1FB4AE470A824E3A49C7D81158E7FA3659E83E230E3269C7044567EB997
V3: WS044-V3-CLAUDE-REFRESH-20261115-01 | 2026-11-15 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-044\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V1 DESIGN by Claude main, claude-opus-5-5, under D120: the owner skipped Codex and subagents on 2026-11-08 ~01:20 Cairo, standing (the owner's words verbatim in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md; D124 wrote D120 into DEC-14 and DEC-19). Codex skipped by owner decision, not by unavailability. No Codex work is claimed and nothing here is independent. V1 designs the scope of data/records/WS-044/CONTRACT.md section 3 from the frozen candidate.

V2 ADVERSARIAL by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V2 attacks V1 and changes no output: (a) AC-02's owning case assumed, without measurement, that the status Move is tried well inside the 300 ms reader window and that the reader is released well inside the 2 s bound, so data/records/WS-044/assurance/Probe-Timing.ps1 ran the candidate's own Write-BackupStatus and the test's own mutant regex 20 times each on the pinned host (timing-probe.json: mutant failed every time within 85 ms; the real writer wrote every time in 298 to 331 ms) and AC-02 now names those margins; (b) the baseline atomic-failure case holds latest.json for the whole action, so the writer now waits out the bound before failing: the probe measured about 2.6 s per never-closing reader, the bare throw rethrows the same UnauthorizedAccessException, the action still reports BACKUP_STATUS_WRITE_FAILED with the prior bytes kept (the V1 full run passed it), and AC-02 names that cost; (c) the mutant leaves a pending file when it fails, and the real run removes pending files before writing, so its no-pending assertion is not weakened by the mutant running first.

V3 REFRESH by Claude main, claude-opus-5-5, under the same D120 standing; nothing here is independent. V3 rechecks the live facts V2 rests on (origin main and the Original HEAD at baseline fcf5649, the pinned PowerShell 7.6.8, git 2.56.1.windows.1, the frozen owner words by SHA256 8CE98342 and the inbox copy AD1A6D01, the Original controller by SHA256 AD768116 and the judge by SHA256 4E1F00E1, equal to trusted-main) and changes no output and no criterion.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W44\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W44\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W44\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W44\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.56.1.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none. PowerShell 7.6.8 is the portable host in ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8, which WS-034 and WS-040 to WS-043 ran; git 2.56.1 is the live machine version.

1. Check whether `changes/README.md` contains `| WS-044-backup-status-reader-retry.md | contracts | Workbench Change Request - WS-044 | - | - |`; if so record Already Applied when its Git blob is 236ad60f0214f65a5b7771c115fc217f484aedc3, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-044 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-043-lifecycle-new-scripts.md | contracts | Workbench Change Request - WS-043 | - | - |
   ```
   insert
   ```text
   | WS-044-backup-status-reader-retry.md | contracts | Workbench Change Request - WS-044 | - | - |
   ```

   The resulting file's Git blob is 236ad60f0214f65a5b7771c115fc217f484aedc3.

2. Check whether `lib/Backup-Workspace.ps1` contains `# A reader holding latest.json open (a status poll, an indexer, antivirus) makes Windows refuse the replace:`; if so record Already Applied when its Git blob is 8917053620339e97196f76c759295f53fc00901f, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-044 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
       [IO.File]::Move($pending,$statusFile,$true)
   ```
   with
   ```text
       # A reader holding latest.json open (a status poll, an indexer, antivirus) makes Windows refuse the replace:
       # retry for about 2 s, then fail as before (WS-044, after WS-042 Original Finish attempt 1).
       for($try=1;;$try++){try{[IO.File]::Move($pending,$statusFile,$true);return}catch [UnauthorizedAccessException]{if($try-ge80){throw};Start-Sleep -Milliseconds 25}}
   ```

   The resulting file's Git blob is 8917053620339e97196f76c759295f53fc00901f.

3. Check whether `lib/test-backup-restore.ps1` contains `# WS-044: a reader that closes latest.json within the retry bound must not fail the replace (WS-042 Original a1).`; if so record Already Applied when its Git blob is 18fd1d3ff57d32d7e4fa945a74d7b12ef9311df4, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-044 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       Assert-Focused 'atomic status replacement failure preserves previous record and verified pointer' ($writeFailed.code-ne0-and$writeFailed.text.Contains('BACKUP_STATUS_WRITE_FAILED')-and[Convert]::ToBase64String($statusBefore)-ceq[Convert]::ToBase64String([IO.File]::ReadAllBytes($statusPath)))
   ```
   insert
   ```text
       # WS-044: a reader that closes latest.json within the retry bound must not fail the replace (WS-042 Original a1).
       $writerFunction=$normalAst.Find({param($n)$n-is[Management.Automation.Language.FunctionDefinitionAst]-and$n.Name-eq'Write-BackupStatus'},$false).Extent.Text
       $writerMutant=$writerFunction-replace'for\(\$try=1;;\$try\+\+\)\{try\{(\[IO\.File\]::Move\(\$pending,\$statusFile,\$true\));return\}catch[^\n]*','$1'
       if($writerMutant-ceq$writerFunction){throw 'WRITER_MUTANT_STALE'}
       $statusRoot=Join-Path $fixture 'reader-status';[void][IO.Directory]::CreateDirectory($statusRoot);$statusFile=Join-Path $statusRoot 'latest.json'
       function Test-ReaderRelease([string]$Definition){
           . ([scriptblock]::Create($Definition))
           Get-ChildItem -LiteralPath $statusRoot -Filter 'pending-*.json'|Remove-Item
           [IO.File]::WriteAllText($statusFile,'{"result":"OLD"}')
           $reader=[IO.File]::Open($statusFile,'Open','Read','Read');$release=[Threading.CancellationTokenSource]::new(300);$null=$release.Token.Register([Action]$reader.Dispose)
           $written=$true;try{Write-BackupStatus ([ordered]@{result='NEW'})}catch{$written=$false}finally{$release.Dispose();$reader.Dispose()}
           [pscustomobject]@{written=$written;result=([IO.File]::ReadAllText($statusFile)|ConvertFrom-Json).result;pending=@(Get-ChildItem -LiteralPath $statusRoot -Filter 'pending-*.json').Count}
       }
       $readerMutant=Test-ReaderRelease $writerMutant
       Assert-Focused 'MUTANT killed: without the retry a reader open at the replace fails the status write' (!$readerMutant.written-and$readerMutant.result-eq'OLD')
       $readerReal=Test-ReaderRelease $writerFunction
       Assert-Focused 'a reader closing within the retry bound does not fail the status replace' ($readerReal.written-and$readerReal.result-eq'NEW'-and$readerReal.pending-eq0)
   ```

   The resulting file's Git blob is 18fd1d3ff57d32d7e4fa945a74d7b12ef9311df4.

## Acceptance Criteria

- [x] Output `changes/README.md` equals its declared resulting Git blob. check: blob:changes/README.md=236ad60f0214f65a5b7771c115fc217f484aedc3
- [x] Output `lib/Backup-Workspace.ps1` equals its declared resulting Git blob. check: blob:lib/Backup-Workspace.ps1=8917053620339e97196f76c759295f53fc00901f
- [x] Output `lib/test-backup-restore.ps1` equals its declared resulting Git blob. check: blob:lib/test-backup-restore.ps1=18fd1d3ff57d32d7e4fa945a74d7b12ef9311df4
- [x] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [x] AC-01 Writer retry: in lib/Backup-Workspace.ps1 only Write-BackupStatus changes, and only its last statement: the one line [IO.File]::Move($pending,$statusFile,$true) becomes a loop that makes the same Move and returns, catches only UnauthorizedAccessException, rethrows it on the 80th try and otherwise sleeps 25 ms, preceded by two comment lines naming the reader and WS-042 Original Finish attempt 1; the pending file is written as before, and no other line of the file changes (numstat 3/1).
- [x] AC-02 Owning test: lib/test-backup-restore.ps1 differs from its baseline only by the lines added right after the case "atomic status replacement failure preserves previous record and verified pointer": a reader of latest.json (FileShare Read) released by a 300 ms timer, run against the real Write-BackupStatus text from the parsed script ("a reader closing within the retry bound does not fail the status replace": the write returns, latest.json holds the new record, no pending file is left) and against a mutant cut from that text by a regex that keeps only the Move ("MUTANT killed: without the retry a reader open at the replace fails the status write": the write fails and the prior record stays), the mutant refusing a stale anchor (WRITER_MUTANT_STALE); no assertion is removed (DEC-22). The baseline case "atomic status replacement failure preserves previous record and verified pointer" still passes: a reader that never closes still fails the write after the bound, prior bytes kept (docs/RECOVERY.md). test-backup-restore passes in full with WORKBENCH_TEST_ROOT outside any ORVION-Workbench-temporary folder, and two production mutants are each killed by "a reader closing within the retry bound does not fail the status replace": the bound cut to one try, and the caught type changed to IOException. The case rests on timing margins measured on the pinned host (data/records/WS-044/assurance/timing-probe.json, 20 runs each): the mutant fails within 85 ms of the reader opening, well before the 300 ms release; the real writer succeeds in 298 to 331 ms, well inside the ~2 s bound; a reader that never closes fails after about 2.6 s, the time the baseline atomic-failure case now adds to the run.
- [x] AC-03 Organizer: changes/README.md is what lib/Organize.ps1 -Refresh writes: it holds the WS-044 row, and a refresh of the replay with this contract in place changes no organizer.
- [x] AC-04 Secrets and privacy: gitleaks on the exact candidate range reports no finding in the 3 outputs and RESUME.md; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; neither masked value (the computer name, a marketing tunnel script name) nor the owner's e-mail is in any changed file or in this contract.
- [x] AC-05 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria; the Finish's test-backup-restore is this contract's real backup and restore (a published 7z archive verified independently and restored to scratch). Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json. From each Finish launch to END: no Events -Add, Save-State or edit in a protected root, and Docker off.
- [x] AC-06 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-044/evidence/protected-before.json, captured before the sandbox Finish and again after Original Complete with data/records/WS-038/Capture-Protected.ps1; lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Workbench.ps1, lib/Restore-Workspace.ps1 and docs/RECOVERY.md are unchanged; both roles ran the Original's controller whose SHA256 this Draft names; the user settings are unchanged; CRM, ORVION and their trusted copies keep their HEAD and files (the lifecycle's protected-root compare); no Codex, subagent, RAM, power setting or scheduled task change; no push before both roles are Complete.

## Review Gate

- [x] Inspect the live subject, this role's fresh receipt, timing and watching evidence, and every criterion above, with attempts, deviations and gaps kept visible. No prototype result or earlier receipt substitutes for this role's gate.
- [x] Review: one Claude-main self-review, labelled as such and never called independent. The Codex review (DEC-14) is recorded SKIPPED by the owner's decision of 2026-11-08 ~01:20 Cairo, never replaced or claimed (D120). At most one corrective version; a remaining material disagreement goes to the owner.
- [x] Retro (DEC-12): Claude main names what does not satisfy it, each item with a remedy and a check.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Append only. No approval, execution-root binding or receipt is claimed. At actual approval add exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line using actual immutable identities. Owner evidence must name the approved digest and execution root. For original execution append exactly one Sandbox Receipt and Sandbox Receipt SHA256 for the matching successful schema2 sandbox artifact. A delegated decision needs actual live owner delegation and is labelled delegated. Never invent human confirmation or approval.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-044\assurance\V3\DRAFT.md
Approved SHA256: 802E34F63D4744F2DBBA471C0831B4E385573B891352F60785F2C74694E84249
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-044\gate\GATE1-WS044-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: D0FB99EC4607126A37319F2E022DA69453906035CB8AD9EB0E69637144F1C4D6
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W44\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: A437836AA3738B0239662B9712C4A46BD86331223FB15C7690EDD73131251B79
Original exact declared outputs applied by accepted native Execute; fresh own Finish and Review/Complete remain required. Other protected roots unchanged. Controller: the Original's own lib/Invoke-ContractLifecycle.ps1 (SHA256 AD768116), unchanged by this contract and used by both roles, checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority.
Residual risks carried unchanged from the selected Draft Review Gate and data/records/WS-044/CONTRACT.md; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (D120, frozen in data/records/WS-034/owner-words), not by unavailability. Controller: the Original's own lib/Invoke-ContractLifecycle.ps1 (SHA256 AD768116), unchanged by this contract and used by both roles, checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority. Release is a later stage, on the owner's conditional words.

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W44-c2 (data/records/WS-044/Make-Candidate.ps1). Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json beside this Draft. After Complete, outside this contract: the release under DEC-25 on the owner's "A", only when every gate passed and Claude main's retro is satisfied; the protected state is compared with its record from before; then a fresh WS-042 attempt on the new baseline with its own receipt; Save-State records the result.
Verdict: Confirmed Complete
Reviewed Fingerprint: C2633233905922B66EF721DA2836B604AA465F9BA91AE5978CB1BB1D0C51618E
Reviewed Receipt: D08F3611F5D4ED5A9AB089934381684734798D07676155345C78F7C9300A83B7
Live ORIGINAL-role review: runtime/original/criterion-review.json. Own Finish 31 ordered suites, runner/watcher/host 0/0/0, real journal unchanged. Review: ONE Claude-main SELF-REVIEW, not independent; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (D120, frozen in data/records/WS-034/owner-words), not by unavailability. Exact completed sandbox proof 5213EB39996A6339416C790133CA6F3765CABC23265E811AAC8240E5F95B746D bound. Not pushed; the one release (DEC-25) follows only on every gate passed and the retro, under owner A (2026-11-15 ~14:10) and 'Proceed in Run Mode 1 through the approved contract' (owner 2026-11-14 ~22:04).

