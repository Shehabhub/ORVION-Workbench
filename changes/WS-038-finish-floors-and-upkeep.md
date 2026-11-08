# Workbench Change Request - WS-038

## Status

[x] Draft
[ ] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Make every later contract cheaper to run, so ORVION Batch 6 moves faster (DEC-30), with the WS-038 scope that Claude main decided under the owner's delegation (data/records/WS-038/DECISION-RECORD.md section 7): raise the DECISIONS.md byte budget from 40960 to 49152 B (6 B were left, so any new decision text failed the Markdown guard); remove the lifecycle's own memory floors (manifest MinPhysicalGB and MinCommitGB and the LIFECYCLE_MEMORY_BUFFER_NOT_READY_NO_FINISH_STARTED check), keeping the Draft's floors that the native ResourceCheck enforces, and rewrite DEC-24 accordingly (D127); hold the machine awake while the lifecycle waits for a Finish, and record it; find sh.exe beside either git.exe of Git for Windows, so the workspace layout test passes from Git Bash (WS-036 lost a 76-minute Finish to it); name DEC-30 and DEC-33 in AGENTS.md; and let Save-State delete an old continuity copy that holds read-only Git objects. Benefit: no hand step before a save, no Finish lost to sleep or to a path assumption, and room for the next decisions.

Tier: Significant under DEC-12 (governance text, the lifecycle controller and two tools change). Authority: DEC-01, DEC-02, DEC-07, DEC-08, DEC-09, DEC-12, DEC-13, DEC-14, DEC-19, DEC-22, DEC-23, DEC-24, DEC-25, DEC-28, DEC-30 and DEC-33; the owner's words of 2026-11-07 ~19:40-20:06 Cairo (RAM minimums removed; WS-038 scope and timing delegated to Claude main), ~20:40 (item A, keep-awake during a Finish) and 2026-11-08 ~01:20 (overnight, no subagents, no Codex), frozen in data/records/WS-038/owner-words/decisions-inbox-20261108T0120.md. Every scope choice is Claude main's under that delegation, labelled DELEGATED; no owner text is typed by an agent (DEC-02). The accepted evaluator lib/Test-WorkbenchChange.ps1 is not changed: its fixture floors, the original-only Finish and the Routine-tier proposal belong to WS-034 (DEC-07).

Number: WS-034 is reserved by DEC-04 and DEC-07, and WS-035 to WS-037 are Complete, so this takes WS-038. Intended contract: changes/WS-038-finish-floors-and-upkeep.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: lib/Invoke-ContractLifecycle.ps1 of this baseline, run from a byte-exact copy outside the Original (data/records/WS-038/controller, its SHA256 recorded), so both roles use the same controller after the Original's own copy changes. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

c25ac94d8f6db9d9f8c5b9575f676ca92342cf21

## Write Scope

- AGENTS.md
- docs/DECISIONS.md
- docs/history/DECISIONS-ARCHIVE.md
- docs/history/DECISIONS-MAP.tsv
- docs/WORKSPACE-LAYOUT.md
- lib/Invoke-ContractLifecycle.ps1
- lib/Save-State.ps1
- lib/test-contract-lifecycle.ps1
- lib/test-markdown-consistency.ps1
- lib/Test-MarkdownConsistency.ps1
- lib/test-save-state.ps1
- lib/test-workspace-layout.ps1
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: the accepted evaluator lib/Test-WorkbenchChange.ps1 and its fixture floors (WS-034, DEC-07); lib/Delegate.ps1 and its post-fold data root (PLAN section 9 register, trigger: the owner re-enables Codex); lib/apply-draft-steps.ps1 and every other lib/ file, test and hook; every DEC entry but DEC-24; data/decisions-inbox.md, whose items stay until every part of them is folded; the seven legacy folders, Owner-Tools, the vault, the restore staging and every package (no deletion, relocation or cleaning); Batch 6, B15, any Codex update or dispatch, machine power setting, RAM setting or scheduled task; no CRM, ORVION, credentials, real sessions or events (DEC-08, DEC-09); any push or release (DEC-25).

## Draft Assurance

V1: WS038-V1-CLAUDE-FALLBACK-DESIGN-20261107-01 | 2026-11-07 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-038\assurance\V1\DRAFT.md | 4F2864F59935B825AADED9FE4323A0EEC2C52DA64F91C39B417FC0BEBDB14A9F
V2: WS038-V2-CLAUDE-FALLBACK-ADVERSARIAL-20261107-01 | 2026-11-07 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-038\assurance\V2\DRAFT.md | ADE1618C37488B9AE187DE7A4C2A83ECAEE67CD8408E7A89E9A3F02843B2F4E1
V3: WS038-V3-CLAUDE-REFRESH-20261107-01 | 2026-11-07 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-038\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V3 EVIDENCE REFRESH by Claude main under DEC-13, binding the frozen V1 and V2 digests above; each was frozen and hashed before the next began (assurance\V1\FROZEN.json, assurance\V2\FROZEN.json). Author of V1 and V2: Claude main, claude-opus-5-5, under D120, because the owner skipped Codex for this work on 2026-11-08 ~01:20 Cairo (the owner's words verbatim in data/decisions-inbox.md). V2 is a same-session V2 by the author of V1. All three are one author's work: nothing here is independent, and no Codex work is claimed. Sources and selection table: assurance\V3\STANDARDS-CHECK.md and assurance\V3\REPORT.md.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W38\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W38\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W38\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W38\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order; where a step has more than 26 edits its letters cycle after z. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none.

1. Check whether `AGENTS.md` contains `The constitution binds every session: read DEC-30 and DEC-33 before the first decision and decide by them.`; if so record Already Applied when its Git blob is 52da6ec809649d7b261c59f2730eff4b750af084, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-038 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   never commit a secret (DEC-09); CRM and ORVION change only through their own README, AGENTS and Boot (DEC-08).
   ```
   insert
   ```text
   The constitution binds every session: read DEC-30 and DEC-33 before the first decision and decide by them.
   ```

   The resulting file's Git blob is 52da6ec809649d7b261c59f2730eff4b750af084.

2. Check whether `docs/DECISIONS.md` contains `applying the owning run's recovery policy, never killing unrelated work. A Finish keeps only the memory floors of its`; if so record Already Applied when its Git blob is dfe6cee37a879d76bd55ab8e4c9b58f0508544f6, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-038 candidate output), each matched once, and change nothing else:

   a) replace the lines
   ```text
   applying the owning run's recovery policy, never killing unrelated work. A Finish launch keeps the native minimum of
   3 GB free commit (enforced by Assert-WorkbenchContextRuntime -ResourceCheck) and the launch scripts' 5 GB physical
   buffer; no task script adds a larger free-commit buffer.
   ```
   with
   ```text
   applying the owning run's recovery policy, never killing unrelated work. A Finish keeps only the memory floors of its
   Draft's Execution Context (enforced by Assert-WorkbenchContextRuntime -ResourceCheck); no launch script or manifest
   adds one, and the lifecycle holds the machine awake while a Finish runs.
   ```

   b) replace the lines
   ```text
   Why: the host has limited memory; a starved Finish fails for reasons unrelated to the candidate.
   Changed: 2026-10-31
   History: D21, D25, D30, D86
   ```
   with
   ```text
   Why: the host has limited memory; a starved or sleeping Finish fails for reasons unrelated to the candidate.
   Changed: 2026-11-08
   History: D21, D25, D30, D86, D127
   ```

   The resulting file's Git blob is dfe6cee37a879d76bd55ab8e4c9b58f0508544f6.

3. Check whether `docs/history/DECISIONS-ARCHIVE.md` contains `## D127 2026-11-08 WS-038: Finish floors, keep-awake and the DECISIONS.md budget`; if so record Already Applied when its Git blob is 7062830013e3e2ad83f1b23aa4bcff4d2cd0f666, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-038 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   Now in: DEC-05
   ```
   insert
   ```text

   ## D127 2026-11-08 WS-038: Finish floors, keep-awake and the DECISIONS.md budget

   The owner's words of 2026-11-07, verbatim from data/decisions-inbox.md (~19:40, ~20:06 and ~20:40 Cairo):

   > remove any minimam limit set to the RAM memory in the repo's

   > i see alote of recommendation and that's good i like it, you can decide how & when

   > i approve all include Exclude the disposable test folders from Microsoft Defender's live scanning but i don't know
   > how to do it - if you can do by yourself simply or toch me to do it manully, what's else can improve and enhance and fix
   > before BT6

   The first removed every RAM minimum; WS-038 removes the lifecycle manifest floors and their check. The second gave
   Claude main the WS-038 scope. The third approved item A, the machine held awake during a Finish. Under that delegation
   WS-038 also raises the DECISIONS.md budget from 40 KB to 48 KB (6 B were left). The evaluator's own floors stay until
   WS-034 (DEC-07), and the two inbox items stay until every part of them is folded.

   Replaced wording of DEC-24, verbatim:

   > ## DEC-24 Concurrency and host resources
   >
   > Two jobs run at once where it is safe: light work, or two Codex reviews. Codex never runs beside a heavy job (a
   > Finish, a full suite, a package build, a restore). Heavy runs are watched by one Watch-Host; COMMIT LOW means
   > applying the owning run's recovery policy, never killing unrelated work. A Finish launch keeps the native minimum of
   > 3 GB free commit (enforced by Assert-WorkbenchContextRuntime -ResourceCheck) and the launch scripts' 5 GB physical
   > buffer; no task script adds a larger free-commit buffer.
   >
   > Scope: every heavy run and every parallel job.
   > Why: the host has limited memory; a starved Finish fails for reasons unrelated to the candidate.
   > Changed: 2026-10-31
   > History: D21, D25, D30, D86

   Now in: DEC-24
   ```

   The resulting file's Git blob is 7062830013e3e2ad83f1b23aa4bcff4d2cd0f666.

4. Check whether `docs/history/DECISIONS-MAP.tsv` contains `D127	2026-11-08	DEC	DEC-24	WS-038: no lifecycle memory floor; keep-awake during a Finish; DECISIONS.md budget 48 KB`; if so record Already Applied when its Git blob is b843551a22bd946968d684667eaece48e129035e, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-038 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   D126	2026-11-07	DEC	DEC-05	A6: Owner Lift approved; all seven legacy folders stay; later deletion needs DEC-10 and the owner
   ```
   insert
   ```text
   D127	2026-11-08	DEC	DEC-24	WS-038: no lifecycle memory floor; keep-awake during a Finish; DECISIONS.md budget 48 KB
   ```

   The resulting file's Git blob is b843551a22bd946968d684667eaece48e129035e.

5. Check whether `docs/WORKSPACE-LAYOUT.md` contains `checks DEC-ID uniqueness, the watch patterns and the size budget of DECISIONS.md (48 KB; each entry's decision at`; if so record Already Applied when its Git blob is abd975b300189f2257b120c46258ea65c1055278, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-038 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
     checks DEC-ID uniqueness, the watch patterns and the size budget of DECISIONS.md (40 KB; each entry's decision at
   ```
   with
   ```text
     checks DEC-ID uniqueness, the watch patterns and the size budget of DECISIONS.md (48 KB; each entry's decision at
   ```

   b) replace the line
   ```text
   | Markdown guard (lib/Test-MarkdownConsistency.ps1; read-only: the working tree, the index or a Git tree, never an outside path) | the Finish schedule | every tracked Markdown file reachable from README.md or AGENTS.md through local links, unless it is history (an allocated contract, or a link in the History index of docs/history/README.md); links and anchors resolved case-sensitively from their file; the One-home table of WORKFLOW.md (each concept once, in its fixed home); only RESUME.md declares the active contract pointer; no duplicate prose paragraph of 25 words or more; no header date older than a body amendment; a retired path never as an instruction; DEC-ID uniqueness, watch patterns (never on a frozen owner text whose exact bytes the guard pins, and no other check is skipped), archive append-only with every item naming an existing entry, size budgets in bytes after CRLF to LF (AGENTS.md 1.5 KB, NOW.md 6 KB, README.md 8 KB, DECISIONS.md 40 KB, RESUME.md 900 B, HANDOFF.md 4,500 B, WORKFLOW.md 20,300 B, injected hook text), links and line length (<= 200; table rows exempt) in active files; section IDs and citations (records/WS-033/signposting.md section 5) |
   ```
   with
   ```text
   | Markdown guard (lib/Test-MarkdownConsistency.ps1; read-only: the working tree, the index or a Git tree, never an outside path) | the Finish schedule | every tracked Markdown file reachable from README.md or AGENTS.md through local links, unless it is history (an allocated contract, or a link in the History index of docs/history/README.md); links and anchors resolved case-sensitively from their file; the One-home table of WORKFLOW.md (each concept once, in its fixed home); only RESUME.md declares the active contract pointer; no duplicate prose paragraph of 25 words or more; no header date older than a body amendment; a retired path never as an instruction; DEC-ID uniqueness, watch patterns (never on a frozen owner text whose exact bytes the guard pins, and no other check is skipped), archive append-only with every item naming an existing entry, size budgets in bytes after CRLF to LF (AGENTS.md 1.5 KB, NOW.md 6 KB, README.md 8 KB, DECISIONS.md 48 KB, RESUME.md 900 B, HANDOFF.md 4,500 B, WORKFLOW.md 20,300 B, injected hook text), links and line length (<= 200; table rows exempt) in active files; section IDs and citations (records/WS-033/signposting.md section 5) |
   ```

   The resulting file's Git blob is abd975b300189f2257b120c46258ea65c1055278.

6. Check whether `lib/Invoke-ContractLifecycle.ps1` contains `foreach($field in 'Workstream','Packet','Draft','DraftSHA256','Baseline','Contract','Judge','JudgeSHA256','JudgeSource','Original','OriginalRemote','Sandbox','RuntimeRoot','HostExe','HostSHA256','HostVersion','Actionlint','RealData','ProtectedRoots','Closures','Approval','OriginalApprovalTemplate','Authority','Outputs','AllocateLabel','ImplementLog','Evidence','ReviewText','ReviewsLabel','KnownExtraCommits'){`; if so record Already Applied when its Git blob is b407d5be73fce6a93711cb7db9b241a6c60be5e8, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-038 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   foreach($field in 'Workstream','Packet','Draft','DraftSHA256','Baseline','Contract','Judge','JudgeSHA256','JudgeSource','Original','OriginalRemote','Sandbox','RuntimeRoot','HostExe','HostSHA256','HostVersion','Actionlint','RealData','MinPhysicalGB','MinCommitGB','ProtectedRoots','Closures','Approval','OriginalApprovalTemplate','Authority','Outputs','AllocateLabel','ImplementLog','Evidence','ReviewText','ReviewsLabel','KnownExtraCommits'){
   ```
   with
   ```text
   foreach($field in 'Workstream','Packet','Draft','DraftSHA256','Baseline','Contract','Judge','JudgeSHA256','JudgeSource','Original','OriginalRemote','Sandbox','RuntimeRoot','HostExe','HostSHA256','HostVersion','Actionlint','RealData','ProtectedRoots','Closures','Approval','OriginalApprovalTemplate','Authority','Outputs','AllocateLabel','ImplementLog','Evidence','ReviewText','ReviewsLabel','KnownExtraCommits'){
   ```

   b) immediately after the lines
   ```text
       if(!(Test-Path -LiteralPath $journal -PathType Leaf)){throw 'LIFECYCLE_REAL_JOURNAL_REQUIRED'}
       $null=Assert-WorkbenchContextRuntime $executionRoot $context -ResourceCheck
   ```
   insert
   ```text
       # The only memory floors are the Draft's (DEC-24). ES_CONTINUOUS|ES_SYSTEM_REQUIRED keeps the machine awake while this
       # process waits for the Finish; Windows releases it when the process ends.
       Add-Type -Namespace OrvionLifecycle -Name Power -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint flags);'
       $awake=[OrvionLifecycle.Power]::SetThreadExecutionState([uint32]2147483649)-ne0
   ```

   c) replace the lines
   ```text
       $headroom=[ordered]@{Utc=[DateTime]::UtcNow.ToString('o');PhysicalGB=[Math]::Round($memory.FreePhysicalMemory/1MB,2);CommitGB=[Math]::Round($memory.FreeVirtualMemory/1MB,2);RealJournal=$journal;JournalBeforeSHA256=(Get-FileHash -LiteralPath $journal).Hash;MinPhysicalGB=$m.MinPhysicalGB;MinCommitGB=$m.MinCommitGB}
       if($headroom.PhysicalGB-lt$m.MinPhysicalGB-or$headroom.CommitGB-lt$m.MinCommitGB){throw 'LIFECYCLE_MEMORY_BUFFER_NOT_READY_NO_FINISH_STARTED'}
   ```
   with
   ```text
       $headroom=[ordered]@{Utc=[DateTime]::UtcNow.ToString('o');PhysicalGB=[Math]::Round($memory.FreePhysicalMemory/1MB,2);CommitGB=[Math]::Round($memory.FreeVirtualMemory/1MB,2);RealJournal=$journal;JournalBeforeSHA256=(Get-FileHash -LiteralPath $journal).Hash;KeepAwake=$awake}
   ```

   The resulting file's Git blob is b407d5be73fce6a93711cb7db9b241a6c60be5e8.

7. Check whether `lib/Save-State.ps1` contains `# Git object files copied from nested clones are read-only, and Directory.Delete refuses them (2026-11-07).`; if so record Already Applied when its Git blob is 2e713248e458cf012b59a9bd4cdac0e0f3d7ef9d, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-038 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   foreach($path in $stage,$previous){if(Test-Path -LiteralPath $path){[IO.Directory]::Delete($path,$true)}}
   ```
   with
   ```text
   # Git object files copied from nested clones are read-only, and Directory.Delete refuses them (2026-11-07).
   function Remove-Copy([string]$Path){Get-ChildItem -LiteralPath $Path -Recurse -Force -File|Where-Object IsReadOnly|ForEach-Object{$_.IsReadOnly=$false};[IO.Directory]::Delete($Path,$true)}
   foreach($path in $stage,$previous){if(Test-Path -LiteralPath $path){Remove-Copy $path}}
   ```

   b) replace the line
   ```text
   if($differ.Count){[IO.Directory]::Delete($stage,$true);throw "SAVE_CONTINUITY_MISMATCH: $($differ-join', ')"}
   ```
   with
   ```text
   if($differ.Count){Remove-Copy $stage;throw "SAVE_CONTINUITY_MISMATCH: $($differ-join', ')"}
   ```

   c) replace the line
   ```text
   if(Test-Path -LiteralPath $previous){[IO.Directory]::Delete($previous,$true)}
   ```
   with
   ```text
   if(Test-Path -LiteralPath $previous){Remove-Copy $previous}
   ```

   The resulting file's Git blob is 2e713248e458cf012b59a9bd4cdac0e0f3d7ef9d.

8. Check whether `lib/test-contract-lifecycle.ps1` contains `Check 'a Finish holds the machine awake and records it' ((Read-Json (Join-Path $sandboxRuntime 'launch-resources.json')).KeepAwake-eq$true)`; if so record Already Applied when its Git blob is 909aca1e2b18f59581712711bfd3bc04197fdb29, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-038 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
           HostExe=$hostExe;HostSHA256=(Get-FileHash -LiteralPath $hostExe).Hash;HostVersion=$PSVersionTable.PSVersion.ToString();Actionlint=$actionlint;RealData=$realData;MinPhysicalGB=0.001;MinCommitGB=0.001
   ```
   with
   ```text
           HostExe=$hostExe;HostSHA256=(Get-FileHash -LiteralPath $hostExe).Hash;HostVersion=$PSVersionTable.PSVersion.ToString();Actionlint=$actionlint;RealData=$realData
   ```

   b) replace the lines
   ```text
       Test-Refused 'a missing real journal is refused' Sandbox finish 'LIFECYCLE_REAL_JOURNAL_REQUIRED' -With (New-Variant {param($v)$v.RealData=(Join-Path $root 'none')})
       Test-Refused 'too little memory starts no Finish' Sandbox finish 'LIFECYCLE_MEMORY_BUFFER_NOT_READY_NO_FINISH_STARTED' -With (New-Variant {param($v)$v.MinPhysicalGB=1000000})
   ```
   with
   ```text
       Test-Refused 'a missing real journal is refused' Sandbox finish 'LIFECYCLE_REAL_JOURNAL_REQUIRED' -With (New-Variant {param($v)$v.RealData=(Join-Path $root 'none')})
   ```

   c) immediately after the line
   ```text
       Test-Pass Sandbox finish 'ONE SANDBOX FINISH STARTED'
   ```
   insert
   ```text
       Check 'a Finish holds the machine awake and records it' ((Read-Json (Join-Path $sandboxRuntime 'launch-resources.json')).KeepAwake-eq$true)
   ```

   The resulting file's Git blob is 909aca1e2b18f59581712711bfd3bc04197fdb29.

9. Check whether `lib/test-markdown-consistency.ps1` contains `$budgetLimits=@{'AGENTS.md'=1536;'README.md'=8192;'RESUME.md'=900;'HANDOFF.md'=4500;'WORKFLOW.md'=20300;'docs/DECISIONS.md'=49152}`; if so record Already Applied when its Git blob is 675d215dffd3ed70c005f0ef6d819b0d0935d62e, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-038 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   $budgetLimits=@{'AGENTS.md'=1536;'README.md'=8192;'RESUME.md'=900;'HANDOFF.md'=4500;'WORKFLOW.md'=20300;'docs/DECISIONS.md'=40960}
   ```
   with
   ```text
   $budgetLimits=@{'AGENTS.md'=1536;'README.md'=8192;'RESUME.md'=900;'HANDOFF.md'=4500;'WORKFLOW.md'=20300;'docs/DECISIONS.md'=49152}
   ```

   The resulting file's Git blob is 675d215dffd3ed70c005f0ef6d819b0d0935d62e.

10. Check whether `lib/Test-MarkdownConsistency.ps1` contains `$budgets=@{'AGENTS.md'=1536;'README.md'=8192;'RESUME.md'=900;'HANDOFF.md'=4500;'WORKFLOW.md'=20300;'docs/DECISIONS.md'=49152}`; if so record Already Applied when its Git blob is a210a1416738025987f94428f1b6315fec84cc6a, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-038 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
       $budgets=@{'AGENTS.md'=1536;'README.md'=8192;'RESUME.md'=900;'HANDOFF.md'=4500;'WORKFLOW.md'=20300;'docs/DECISIONS.md'=40960}
   ```
   with
   ```text
       $budgets=@{'AGENTS.md'=1536;'README.md'=8192;'RESUME.md'=900;'HANDOFF.md'=4500;'WORKFLOW.md'=20300;'docs/DECISIONS.md'=49152}
   ```

   The resulting file's Git blob is a210a1416738025987f94428f1b6315fec84cc6a.

11. Check whether `lib/test-save-state.ps1` contains `readOnlyCopy=@('',{$f=New-SaveFixture 'readonly';$file=Join-Path $f.Work 'sx/locked.txt';[void][IO.Directory]::CreateDirectory((Split-Path $file -Parent))`; if so record Already Applied when its Git blob is cba48ad58beff7c7cfbfd8f5b7d51b889d39218b, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-038 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
           Assert-Save ((@(Get-ChildItem -LiteralPath $f.Vault -Force).Name-join'|')-ceq'continuity') 'only continuity/ in the vault'})
   ```
   insert
   ```text
       readOnlyCopy=@('',{$f=New-SaveFixture 'readonly';$file=Join-Path $f.Work 'sx/locked.txt';[void][IO.Directory]::CreateDirectory((Split-Path $file -Parent))
           [IO.File]::WriteAllText($file,'git object');[IO.File]::SetAttributes($file,[IO.FileAttributes]::ReadOnly)
           try{$null=Invoke-Save $f $first;$null=Invoke-Save $f @{Operation='op 2'}}finally{[IO.File]::SetAttributes($file,[IO.FileAttributes]::Normal)}
           Assert-Save ((@(Get-ChildItem -LiteralPath $f.Vault -Force).Name-join'|')-ceq'continuity') 'a read-only file in the old copy does not stop the next save'})
   ```

   b) replace the line
   ```text
               continuityMismatch='if($differ.Count){[IO.Directory]::Delete($stage,$true);throw "SAVE_CONTINUITY_MISMATCH: $($differ-join'', '')"}'
   ```
   with
   ```text
               continuityMismatch='if($differ.Count){Remove-Copy $stage;throw "SAVE_CONTINUITY_MISMATCH: $($differ-join'', '')"}'
               readOnlyCopy='$_.IsReadOnly=$false'
   ```

   The resulting file's Git blob is cba48ad58beff7c7cfbfd8f5b7d51b889d39218b.

12. Check whether `lib/test-workspace-layout.ps1` contains `# Git for Windows keeps sh.exe in <home>\usr\bin; git.exe is <home>\cmd\git.exe or, first on Git Bash's PATH, <home>\mingw64\bin\git.exe.`; if so record Already Applied when its Git blob is 358647630530c32591bd984682c0b34ecbad8254, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-038 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
           $shExe=Join-Path (Split-Path (Split-Path $gitExe -Parent) -Parent) 'usr/bin/sh.exe'
   ```
   with
   ```text
           # Git for Windows keeps sh.exe in <home>\usr\bin; git.exe is <home>\cmd\git.exe or, first on Git Bash's PATH, <home>\mingw64\bin\git.exe.
           $gitHome=Split-Path (Split-Path $gitExe -Parent) -Parent
           $shExe=@($gitHome,(Split-Path $gitHome -Parent)|ForEach-Object{Join-Path $_ 'usr/bin/sh.exe'}|Where-Object{Test-Path -LiteralPath $_})[0]
   ```

   The resulting file's Git blob is 358647630530c32591bd984682c0b34ecbad8254.

## Acceptance Criteria

- [ ] Output `AGENTS.md` equals its declared resulting Git blob. check: blob:AGENTS.md=52da6ec809649d7b261c59f2730eff4b750af084
- [ ] Output `docs/DECISIONS.md` equals its declared resulting Git blob. check: blob:docs/DECISIONS.md=dfe6cee37a879d76bd55ab8e4c9b58f0508544f6
- [ ] Output `docs/history/DECISIONS-ARCHIVE.md` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-ARCHIVE.md=7062830013e3e2ad83f1b23aa4bcff4d2cd0f666
- [ ] Output `docs/history/DECISIONS-MAP.tsv` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-MAP.tsv=b843551a22bd946968d684667eaece48e129035e
- [ ] Output `docs/WORKSPACE-LAYOUT.md` equals its declared resulting Git blob. check: blob:docs/WORKSPACE-LAYOUT.md=abd975b300189f2257b120c46258ea65c1055278
- [ ] Output `lib/Invoke-ContractLifecycle.ps1` equals its declared resulting Git blob. check: blob:lib/Invoke-ContractLifecycle.ps1=b407d5be73fce6a93711cb7db9b241a6c60be5e8
- [ ] Output `lib/Save-State.ps1` equals its declared resulting Git blob. check: blob:lib/Save-State.ps1=2e713248e458cf012b59a9bd4cdac0e0f3d7ef9d
- [ ] Output `lib/test-contract-lifecycle.ps1` equals its declared resulting Git blob. check: blob:lib/test-contract-lifecycle.ps1=909aca1e2b18f59581712711bfd3bc04197fdb29
- [ ] Output `lib/test-markdown-consistency.ps1` equals its declared resulting Git blob. check: blob:lib/test-markdown-consistency.ps1=675d215dffd3ed70c005f0ef6d819b0d0935d62e
- [ ] Output `lib/Test-MarkdownConsistency.ps1` equals its declared resulting Git blob. check: blob:lib/Test-MarkdownConsistency.ps1=a210a1416738025987f94428f1b6315fec84cc6a
- [ ] Output `lib/test-save-state.ps1` equals its declared resulting Git blob. check: blob:lib/test-save-state.ps1=cba48ad58beff7c7cfbfd8f5b7d51b889d39218b
- [ ] Output `lib/test-workspace-layout.ps1` equals its declared resulting Git blob. check: blob:lib/test-workspace-layout.ps1=358647630530c32591bd984682c0b34ecbad8254
- [ ] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [ ] AC-01 Budget: lib/Test-MarkdownConsistency.ps1 and lib/test-markdown-consistency.ps1 each change one line, the docs/DECISIONS.md budget 40960 to 49152; docs/WORKSPACE-LAYOUT.md changes two lines, its two DECISIONS.md budgets 40 KB to 48 KB; the Markdown guard passes with this contract in place, and test-markdown-consistency passes.
- [ ] AC-02 DEC-24: docs/DECISIONS.md is at most 49152 B after LF normalisation; DEC-24 is the only entry that differs from baseline, and within it the floor sentence, Why, Changed and History change to the text of this Draft's step; docs/history/DECISIONS-ARCHIVE.md changes only by appending item D127, which quotes the owner's three texts verbatim as frozen in data/records/WS-038/owner-words/decisions-inbox-20261108T0120.md (SHA256 20E5C2C886F4F82496235D7401AE79AE4EF52CF513AF8AA5198C7349B0CD9B02, compared with whitespace and quote markers folded) and the replaced DEC-24 verbatim, and ends Now in: DEC-24; docs/history/DECISIONS-MAP.tsv changes only by appending row D127 and has one row for each of D1-D127; no map row or archive item names a missing DEC entry.
- [ ] AC-03 Lifecycle: lib/Invoke-ContractLifecycle.ps1 no longer names MinPhysicalGB, MinCommitGB or LIFECYCLE_MEMORY_BUFFER_NOT_READY_NO_FINISH_STARTED; it still calls Assert-WorkbenchContextRuntime with -ResourceCheck before a Finish; it calls SetThreadExecutionState(ES_CONTINUOUS|ES_SYSTEM_REQUIRED) before it starts the runner and records KeepAwake in launch-resources.json; test-contract-lifecycle passes, including "a Finish holds the machine awake and records it", which kills the mutant $awake=$false (assurance/mutant-keepawake.json). This contract's own stages run the baseline controller from its recorded copy, so the new lifecycle is proven here by its test; its first live Finish is the next contract's, and that run's launch-resources.json is checked for KeepAwake true.
- [ ] AC-04 sh.exe: lib/test-workspace-layout.ps1 passes from PowerShell (git at cmd\git.exe) and from a Git Bash login shell started with MSYSTEM=MINGW64 (git at /mingw64/bin/git), where the baseline test fails (assurance/baseline-layout-from-gitbash.log).
- [ ] AC-05 Save-State: the three deletions of a continuity copy go through Remove-Copy, which clears read-only flags first, and lib/Save-State.ps1 keeps one [IO.Directory]::Delete call; test-save-state passes with its readOnlyCopy case, and its mutant readOnlyCopy is killed.
- [ ] AC-06 AGENTS.md changes only by the line "The constitution binds every session: read DEC-30 and DEC-33 before the first decision and decide by them." after the DEC-08 sentence, and stays within 1536 B.
- [ ] AC-07 Secrets and privacy: gitleaks on the exact candidate range reports 0 findings in the 12 outputs and RESUME.md; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; no allow marker or ignore file is added; neither masked value (the computer name, a marketing tunnel script name) is in any changed file or in this contract.
- [ ] AC-08 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json.
- [ ] AC-09 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-038/evidence/protected-before.json when captured again with data/records/WS-038/Capture-Protected.ps1 (file count, bytes, newest write and listing SHA256 per folder; attributes only, cloud files never hydrated); the backup packages are compared as an observation only, because nightly backup retention may change them; lib/Test-WorkbenchChange.ps1, lib/Delegate.ps1 and lib/apply-draft-steps.ps1 are unchanged; no CRM or ORVION change, no Batch 6, B15, deletion, Codex, subagent, RAM, power setting or scheduled task change, no push or release under this contract. Commits stay local (DEC-25).

## Review Gate

- [ ] Inspect the live subject, this role's fresh receipt, timing and watching evidence, and every criterion above, with attempts, deviations and gaps kept visible. No prototype result or earlier receipt substitutes for this role's gate.
- [ ] Review: one Claude-main self-review, labelled as such and never called independent. The Codex review (DEC-14) is recorded SKIPPED by the owner's decision of 2026-11-08 ~01:20 Cairo, never replaced or claimed (D120). At most one corrective version; a remaining material disagreement goes to the owner.
- [ ] Retro (DEC-12): Claude main, and Codex if it reviewed, name what does not satisfy them, each item with a remedy and a check.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Append only. No approval, execution-root binding or receipt is claimed. At actual approval add exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line using actual immutable identities. Owner evidence must name the approved digest and execution root. For original execution append exactly one Sandbox Receipt and Sandbox Receipt SHA256 for the matching successful schema2 sandbox artifact. A delegated decision needs actual live owner delegation and is labelled delegated. Never invent human confirmation or approval.

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W38-cand. Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json and REPORT.md beside this Draft. After Complete, outside this contract: the release is its own stage and needs the owner's words for it (DEC-25); the protected state is compared with its record from before, and Save-State and the status page record the result. Until this contract lands, its own Finishes are held awake by a separate Claude-main process (SetThreadExecutionState, released at 10:29 Cairo on 2026-11-08), not by the lifecycle. V3 sources and selection table: STANDARDS-CHECK.md and REPORT.md beside this Draft.
