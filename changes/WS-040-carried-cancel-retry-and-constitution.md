# Workbench Change Request - WS-040

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Unblock Batch 6 slice 7 and remove two refusal and loss classes it paid for, so ORVION moves faster (DEC-30), with the WS-040 scope of data/records/WS-040/CONTRACT.md sections 2 and 3: CRM approval through lib/Invoke-ContractStage.ps1 accepts an unbound pending baseline only when its top is one earlier CR's allocate, approve and Cancel commits, that CR reads Cancelled and the selected Draft names it under Supersedes / Depends On (the rule of CRM SPEC-273, CANCELLED_SEGMENT_NOT_CARRIED); the read-only native Boot and the approve fetch get one retry each on a named transient refusal that wrote nothing; Guard-Write refuses Events -Add while a Finish runs (the real journal it hashes); the missing WS-034 row of changes/README.md and the WS-040 row land through Organize; DEC-33 rules 1, 2, 3, 6, 7, 8, 9 and 12 take the wording Batch 6 proved, DEC-03 is retired into rules 1-3 with every requirement kept, DEC-01 names batch-scoped rules, DEC-28 keeps a fixed defect closed at its source and DEC-30 names ACI (D129). Benefit: SPEC-305 can be approved on top of the cancelled SPEC-304, a GitHub timeout costs one retry instead of a stopped slice, and a lesson cannot break a running Finish.

Tier: Significant under DEC-12 (a hook, a native-stage tool and governance text change). Authority: DEC-01, DEC-02, DEC-08, DEC-09, DEC-12, DEC-13, DEC-14, DEC-19, DEC-22, DEC-23, DEC-24, DEC-25, DEC-28, DEC-30 and DEC-33; the owner's words of 2026-11-11 ~17:10 Cairo (improve the constitutional rules when gaps are found), ~17:25 (the DEC-33 wording waits for the next justified Workbench contract), ~19:50 decision 7 (batch-scoped rules), ~22:10 (the Workbench contract route), ~22:35 ("Do not ask me; let the Constitution provide the answer") and ~23:35 (complete WS-040 through P5, stop at P6 for the release), frozen in data/records/WS-040/owner-words/decisions-inbox-20261111T2350.md; and 2026-11-12 ~07:38 Cairo ("V4 + fresh sandbox": one corrective version and one fresh sandbox Finish), frozen in data/records/WS-040/owner-words/decisions-inbox-20261112T0740.md. Every scope choice is Claude main's under that authority, labelled DELEGATED; no owner text is typed by an agent (DEC-02).

Number: WS-040; WS-039 labels the deferred Organize and restore items and is not used. Intended contract: changes/WS-040-carried-cancel-retry-and-constitution.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: this contract changes neither lib/Invoke-ContractLifecycle.ps1 nor the accepted evaluator, so both roles run the Original's own baseline controller, its SHA256 checked before each stage, with the accepted judge. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

62ccba33134497245ef6774b9ba0159c4993715f

## Write Scope

- changes/README.md
- docs/DECISIONS.md
- docs/history/DECISIONS-ARCHIVE.md
- docs/history/DECISIONS-MAP.tsv
- docs/RUNBOOK.md
- docs/WORKSPACE-LAYOUT.md
- lib/hooks/Guard-Write.ps1
- lib/Invoke-ContractStage.ps1
- lib/README.md
- lib/test-native-stage.ps1
- lib/test-organize.ps1
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Events.ps1, lib/Save-State.ps1, tests.ps1 and every other lib/ file, test and hook; every DEC entry but DEC-01, DEC-03, DEC-28, DEC-30 and DEC-33, and DEC-33 rules 4, 5, 10 and 11; the inbox fold (data/decisions-inbox.md is untracked; folded after Original Complete, CONTRACT.md item 5); the permanent network pin (BP-01, owner decision 1 of 2026-11-11 ~19:50), a Routine inbox-fold contract, the Hunt lint scope, the rule 10 and 11 additions and the CRGL definition (each considered and dropped, CONTRACT.md section 3); the seven legacy folders, Owner-Tools, the vault and every package; any CRM or ORVION change (SPEC-305 resumes under its own lifecycle only after the release, DEC-08), credentials, real sessions or events (DEC-09); Codex, subagents, RAM, power or scheduled-task changes; any push or release (DEC-25, reserved to the owner).

## Draft Assurance

V1: WS040-V1-CLAUDE-FALLBACK-DESIGN-20261111-01 | 2026-11-11 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-040\assurance\V1\DRAFT.md | C05400FE58CBA0259DD2D38415B6F030E7868EA3D7A540300738555E1D685BF5
V2: WS040-V2-CLAUDE-FALLBACK-ADVERSARIAL-20261111-01 | 2026-11-11 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-040\assurance\V2\DRAFT.md | 3965154F8F12221CAB1C9A6CB005B05DCE076319359817F6190EAD4DD9F3F59C
V3: WS040-V4-CLAUDE-CORRECTIVE-20261112-01 | 2026-11-12 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-040\assurance\V4\DRAFT.md | SELECTED
Selected Version: V3

The third pass slot holds V4, the one corrective version (DEC-14) of the frozen V3 (assurance\V3\DRAFT.md, SHA256 89810CE3B04B5C2FBA00398E7014E1AD293354066FEC87BF6F48DEAB58B480D2, assurance\V3\FROZEN.json), made on the owner's answer of 2026-11-12 ~07:38 Cairo after that V3's one sandbox Finish failed only on the hazard check. V4 binds the frozen V1 and V2 digests above; each was frozen and hashed before the next began (assurance\V1\FROZEN.json, assurance\V2\FROZEN.json). Author of V1 and V2: Claude main, claude-opus-5-5, under D120, because the owner skipped Codex and subagents on 2026-11-08 ~01:20 Cairo, standing (the owner's words verbatim in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md; D124 wrote D120 into DEC-14 and DEC-19). All four are one author's work: nothing here is independent, and no Codex work is claimed. Sources, change and selection table: assurance\V4\STANDARDS-CHECK.md and assurance\V4\REPORT.md.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W40b\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W40b\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W40b\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W40b\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order; where a step has more than 26 edits its letters cycle after z. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none. PowerShell 7.6.8 is the portable host in ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8, which WS-034 ran.

1. Check whether `changes/README.md` contains `| WS-034-purpose-based-suite-and-upkeep.md | contracts | Workbench Change Request - WS-034 | - | - |`; if so record Already Applied when its Git blob is dd02d07de7bc7c2ec0830f3c1aa9a9c120cf2e03, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-040 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-033-compact-folders-method.md | contracts | Workbench Change Request - WS-033 | - | - |
   ```
   insert
   ```text
   | WS-034-purpose-based-suite-and-upkeep.md | contracts | Workbench Change Request - WS-034 | - | - |
   ```

   b) immediately after the line
   ```text
   | WS-038-finish-floors-and-upkeep.md | contracts | Workbench Change Request - WS-038 | - | - |
   ```
   insert
   ```text
   | WS-040-carried-cancel-retry-and-constitution.md | contracts | Workbench Change Request - WS-040 | - | - |
   ```

   The resulting file's Git blob is dd02d07de7bc7c2ec0830f3c1aa9a9c120cf2e03.

2. Check whether `docs/DECISIONS.md` contains `words wait in decisions-inbox.md and the NOW.md "Pending decisions" list; a batch plan may hold that batch's operating`; if so record Already Applied when its Git blob is 5231cbf83726747180c7d3608c8785e4f9df01c9, and otherwise stop and report. Otherwise make exactly these 11 edits (land this exact frozen WS-040 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   words wait in decisions-inbox.md and the NOW.md "Pending decisions" list; the archive is
   ```
   with
   ```text
   words wait in decisions-inbox.md and the NOW.md "Pending decisions" list; a batch plan may hold that batch's operating
   rules, and its close step lists each in the inbox to be folded into its DEC entry, or it lapses. The archive is
   ```

   b) replace the lines
   ```text
   Changed: 2026-11-07
   History: D35, D83, D87, D88, D100, D101, D102, D125
   ```
   with
   ```text
   Changed: 2026-11-11
   History: D35, D83, D87, D88, D100, D101, D102, D125, D129
   ```

   c) replace the lines
   ```text

   ## DEC-03 Engineering principles

   Every file, folder, section, tool and step passes four tests. Learn first: look before adding, reuse what exists and
   rest on evidence; before proposing, learn from the CRM and ORVION governance, current standards and research, each
   source weighed by its strength. Learn before making assumptions: verify every fact a step depends on (read the file, run
   the check, read the current official source) before acting; keep proven fact, inference and hypothesis apart; never
   guess; ask the owner what only the owner knows. Earn it and worth it: a file exists only while something actively reads
   it (a tool, gate, decision, agent step or owner need); nothing is kept only as history; the Workbench's tools must
   really work. Simplify without weakness: the shortest form that keeps every gate, test, rule, needed piece of evidence
   and security boundary, boring rather than clever; small, closely related files are merged; a size budget is met by
   moving text to its one home, never by dropping a rule or raising the budget. Prefer the minimal, demonstrably safe
   solution, never one whose safety needs disproportionate complexity or fragile workarounds; where safety cannot be shown,
   fail closed and keep the evidence. Never leave a found error or gap unfixed: fix it now when its rules allow, otherwise
   schedule it with a named trigger. How each test is applied: WORKSPACE-LAYOUT.md section 1.

   Scope: every agent and every piece of work.
   Why: the owner's principles, restated in most decisions since 2026-10-26; the fourth test was added on 2026-11-01.
   Changed: 2026-11-01
   History: D19, D21, D37, D48, D65, D88, D95, D103, D106

   ```
   with
   ```text

   ```

   d) replace the lines
   ```text
   generated everywhere else (DEC-01). A fixed defect class lands the guard that keeps it closed, or its record says why
   none.
   ```
   with
   ```text
   generated everywhere else (DEC-01). A fixed defect class is kept closed at its source, the step or tool that made it,
   with a guard only where no native gate already holds it; its record says which.
   ```

   e) replace the lines
   ```text
   Changed: 2026-11-01
   History: D103, D106
   ```
   with
   ```text
   Changed: 2026-11-11
   History: D103, D106, D129
   ```

   f) replace the lines
   ```text
   prevented and fewer owner interventions, never counts of commits, contracts or tests. CAG, SACI, PICF and CRGL mean only
   what their owning repository texts define, never what memory recalls. Success: a new agent can open the project,
   ```
   with
   ```text
   prevented and fewer owner interventions, never counts of commits, contracts or tests. CAG, ACI, SACI, PICF and CRGL mean
   only what their owning repository texts define, never what memory recalls. Success: a new agent can open the project,
   ```

   g) replace the lines
   ```text
   Why: the owner's philosophy for every current and future agent, in the owner's own words of 2026-10-26.
   Changed: 2026-11-01
   History: D106
   ```
   with
   ```text
   Why: the owner's philosophy for every current and future agent, in the owner's own words of 2026-10-26.
   Changed: 2026-11-11
   History: D106, D129
   ```

   h) replace the lines
   ```text
   1. Learn first: read the code, contracts, past failures and current official sources before acting; never guess.
   2. Earn it and worth it: measured need, value above cost; reuse first; automate wisely; real outcomes, no reports of reports.
   3. Simplify without weakening: the smallest tested change that keeps every gate, test, rule and boundary.
   ```
   with
   ```text
   1. Learn first: read the code, contracts, past failures, the CRM and ORVION governance and current official sources, each weighed by its strength, before acting; never guess.
   2. Earn it and worth it: measured need, value above cost; reuse first, proofs included; automate wisely; parallel unless sharing a stack, a Finish or API budget; real outcomes, no reports of reports.
   3. Simplify without weakening: the smallest, boring, tested change keeping every gate, test, rule and boundary; nothing kept unread; meet a budget by moving text, never cut a rule or raise it.
   ```

   i) replace the lines
   ```text
   6. Enforce, not instruct: a critical limit lives in a gate or tool; CAG, ACI, SACI, PICF are what their repositories define.
   7. Before the irreversible: prove completion is feasible, verify the target, hold recovery or explicit authorization.
   8. Bounded, fail closed: limits on attempts and resources; no retry without new evidence; unknown stops and escalates.
   9. Test before trust: real conditions, not proxies; a high-risk change also gets a check its author did not write.
   ```
   with
   ```text
   6. Enforce, not instruct: a critical limit lives in one gate or tool, the native one where it exists.
   7. Before the irreversible (a terminal step such as Cancel or Complete, a deploy, a push, a deletion): prove completion is feasible, verify the target, hold recovery or explicit authorization.
   8. Bounded, fail closed: limit attempts and resources; retry only on new evidence, or once per stage for a named transient external refusal that wrote nothing; a second failure or unknown escalates.
   9. Test before trust: real conditions, not proxies; a high-risk change also gets a check its author did not write (the product's existing tests, native gates and hosted CI).
   ```

   j) replace the line
   ```text
   12. Fix, never skip: fix each error, gap or failed check at its root now; defer only out-of-scope, unsafe or owner fixes (owner, trigger); lesson each mistake, guard a repeat; finish before expanding.
   ```
   with
   ```text
   12. Fix, never skip: fix each error, gap or failure at root now; defer only out-of-scope, unsafe or owner fixes (owner, trigger); lesson each mistake, guard repeats at source; finish before expanding.
   ```

   k) replace the lines
   ```text
   Changed: 2026-11-09
   History: D112, D110, D128
   ```
   with
   ```text
   Changed: 2026-11-11
   History: D19, D21, D37, D48, D65, D88, D95, D103, D106, D110, D112, D128, D129
   ```

   The resulting file's Git blob is 5231cbf83726747180c7d3608c8785e4f9df01c9.

3. Check whether `docs/history/DECISIONS-ARCHIVE.md` contains `## D129 2026-11-11 WS-040: the constitution amended from Batch 6; DEC-03 retired into DEC-33`; if so record Already Applied when its Git blob is 6ed7c71a81e3ccbac6254b8b793e5b854ec261bb, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-040 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   Now in: DEC-33
   ```
   insert
   ```text

   ## D129 2026-11-11 WS-040: the constitution amended from Batch 6; DEC-03 retired into DEC-33

   The owner's words of 2026-11-11, verbatim from data/decisions-inbox.md (~17:10, ~17:25, ~22:10 and ~22:35 Cairo, and
   decision 7 of ~19:50):

   > Do not adopt, create, modify, or delete any file, mechanism, or tool, except in accordance with the rules and principles of the constitution. Furthermore, continuously improve the constitutional rules whenever loopholes or gaps—not currently covered by the existing rules—are discovered.

   > Learn from your experiences in previous cycles and the insights you've gained regarding potential improvements.
   > Refine the "constitution," the cycles, and their schedules—as well as anything else you believe warrants adjustment—in line with the new constitutional rules.
   > The goal is to implement minor, cost-effective enhancements, rather than requiring dedicated cycles or specific "Business Requests" (BRs) for these changes.
   > Let's move forward with the "slices" by introducing clear improvements—whether in terms of time, cost, or the rules themselves.

   > I believe returning to the "Workbench contract" has become necessary.
   >
   > For now, please compile everything that needs to be finalized, added, modified, improved, or removed before we proceed with the completion of BT6. This must be done in accordance with the principles of our "constitution." I recall you mentioning that some of these principles—or rules—themselves require improvement; the only obstacle was that doing so would necessitate a new contract—well, here we are.

   > Do not ask me; let the Constitution provide the answer. I will only agree to your proposals if they are in accordance with the rules of the Constitution.

   > The existing 8 Waste and Safety Rules in PLAN.md remain the single operational rule set.

   Lessons of Batch 6 slices 1-7 and WS-034 (decisions inbox ~17:25, revised ~22:30) amend DEC-33 rules 2, 3, 6, 7, 8, 9
   and 12; rules 1 and 3 also take the parts of DEC-03 no rule held (the product governance and the weighing of sources;
   boring rather than clever; never raising a budget), so DEC-03 retires with nothing dropped (rule 3) and its D-numbers
   map to DEC-33. Rule 6's list moves to DEC-30, which gains ACI. DEC-01 writes down decision 7 (batch-scoped rules);
   DEC-28 moves a repeat's guard to its source. Dropped by the constitution: a Routine inbox-fold contract at each batch
   close (no dedicated cycles), the rule 10 and 11 additions (covered) and the Codex fallback (in force, D124).

   Replaced entry DEC-03, verbatim:

   > ## DEC-03 Engineering principles
   >
   > Every file, folder, section, tool and step passes four tests. Learn first: look before adding, reuse what exists and
   > rest on evidence; before proposing, learn from the CRM and ORVION governance, current standards and research, each
   > source weighed by its strength. Learn before making assumptions: verify every fact a step depends on (read the file, run
   > the check, read the current official source) before acting; keep proven fact, inference and hypothesis apart; never
   > guess; ask the owner what only the owner knows. Earn it and worth it: a file exists only while something actively reads
   > it (a tool, gate, decision, agent step or owner need); nothing is kept only as history; the Workbench's tools must
   > really work. Simplify without weakness: the shortest form that keeps every gate, test, rule, needed piece of evidence
   > and security boundary, boring rather than clever; small, closely related files are merged; a size budget is met by
   > moving text to its one home, never by dropping a rule or raising the budget. Prefer the minimal, demonstrably safe
   > solution, never one whose safety needs disproportionate complexity or fragile workarounds; where safety cannot be shown,
   > fail closed and keep the evidence. Never leave a found error or gap unfixed: fix it now when its rules allow, otherwise
   > schedule it with a named trigger. How each test is applied: WORKSPACE-LAYOUT.md section 1.
   >
   > Scope: every agent and every piece of work.
   > Why: the owner's principles, restated in most decisions since 2026-10-26; the fourth test was added on 2026-11-01.
   > Changed: 2026-11-01
   > History: D19, D21, D37, D48, D65, D88, D95, D103, D106

   Now in: DEC-33

   Replaced sentence of DEC-01, verbatim (the rest of the entry stands):

   > words wait in decisions-inbox.md and the NOW.md "Pending decisions" list; the archive is

   Now in: DEC-01

   Replaced sentence of DEC-28, verbatim:

   > A fixed defect class lands the guard that keeps it closed, or its record says why none.

   Now in: DEC-28

   Replaced sentence of DEC-30, verbatim:

   > CAG, SACI, PICF and CRGL mean only what their owning repository texts define, never what memory recalls.

   Now in: DEC-30

   Replaced rules of DEC-33, verbatim:

   > 1. Learn first: read the code, contracts, past failures and current official sources before acting; never guess.
   > 2. Earn it and worth it: measured need, value above cost; reuse first; automate wisely; real outcomes, no reports of reports.
   > 3. Simplify without weakening: the smallest tested change that keeps every gate, test, rule and boundary.
   > 6. Enforce, not instruct: a critical limit lives in a gate or tool; CAG, ACI, SACI, PICF are what their repositories define.
   > 7. Before the irreversible: prove completion is feasible, verify the target, hold recovery or explicit authorization.
   > 8. Bounded, fail closed: limits on attempts and resources; no retry without new evidence; unknown stops and escalates.
   > 9. Test before trust: real conditions, not proxies; a high-risk change also gets a check its author did not write.
   > 12. Fix, never skip: fix each error, gap or failed check at its root now; defer only out-of-scope, unsafe or owner fixes (owner, trigger); lesson each mistake, guard a repeat; finish before expanding.

   Now in: DEC-33
   ```

   The resulting file's Git blob is 6ed7c71a81e3ccbac6254b8b793e5b854ec261bb.

4. Check whether `docs/history/DECISIONS-MAP.tsv` contains `D19	2026-10-26	DEC	DEC-17 DEC-33	tools must really work and earn their cost; WS-017 itself is history`; if so record Already Applied when its Git blob is b9bbaa20c28b3c13716e7484a826f612a99100b0, and otherwise stop and report. Otherwise make exactly these 10 edits (land this exact frozen WS-040 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   D19	2026-10-26	DEC	DEC-03 DEC-17	tools must really work and earn their cost; WS-017 itself is history
   ```
   with
   ```text
   D19	2026-10-26	DEC	DEC-17 DEC-33	tools must really work and earn their cost; WS-017 itself is history
   ```

   b) replace the line
   ```text
   D21	2026-10-26	DEC	DEC-03 DEC-24	fix every bug seen; two jobs at once where safe; WS-019 itself is history
   ```
   with
   ```text
   D21	2026-10-26	DEC	DEC-24 DEC-33	fix every bug seen; two jobs at once where safe; WS-019 itself is history
   ```

   c) replace the line
   ```text
   D37	2026-10-28	DEC	DEC-03 DEC-20	sub-agent prevention never claimed; minimal safe solutions over rescue complexity; WS-029 order is history
   ```
   with
   ```text
   D37	2026-10-28	DEC	DEC-20 DEC-33	sub-agent prevention never claimed; minimal safe solutions over rescue complexity; WS-029 order is history
   ```

   d) replace the line
   ```text
   D48	2026-10-29	History	DEC-02 DEC-03	WS-026 V3 continuation; "choose the best" grants judgment, not scope
   ```
   with
   ```text
   D48	2026-10-29	History	DEC-02 DEC-33	WS-026 V3 continuation; "choose the best" grants judgment, not scope
   ```

   e) replace the line
   ```text
   D65	2026-10-30	History	DEC-02 DEC-03	WS-032 namespace-trial authority
   ```
   with
   ```text
   D65	2026-10-30	History	DEC-02 DEC-33	WS-032 namespace-trial authority
   ```

   f) replace the line
   ```text
   D88	2026-10-31	DEC	DEC-01 DEC-02 DEC-03 DEC-06 DEC-08 DEC-10	organizers, one folder tool, deletion authority; the per-decision split replaced by D101
   ```
   with
   ```text
   D88	2026-10-31	DEC	DEC-01 DEC-02 DEC-06 DEC-08 DEC-10 DEC-33	organizers, one folder tool, deletion authority; the per-decision split replaced by D101
   ```

   g) replace the line
   ```text
   D95	2026-10-31	DEC	DEC-03 DEC-06 DEC-07 DEC-08	fix every gap; be informed before acting; personal OneDrive files untouched; S10; the TEMP gap
   ```
   with
   ```text
   D95	2026-10-31	DEC	DEC-06 DEC-07 DEC-08 DEC-33	fix every gap; be informed before acting; personal OneDrive files untouched; S10; the TEMP gap
   ```

   h) replace the line
   ```text
   D103	2026-11-01	DEC	DEC-03 DEC-08 DEC-09 DEC-10 DEC-11 DEC-27 DEC-28 DEC-29	compact GitHub, OneDrive for the last 7 backups only, nothing kept only as history, a fourth principle, guards and self-updating files, a plan with a status page
   ```
   with
   ```text
   D103	2026-11-01	DEC	DEC-08 DEC-09 DEC-10 DEC-11 DEC-27 DEC-28 DEC-29 DEC-33	compact GitHub, OneDrive for the last 7 backups only, nothing kept only as history, a fourth principle, guards and self-updating files, a plan with a status page
   ```

   i) replace the line
   ```text
   D106	2026-11-01	DEC	DEC-02 DEC-03 DEC-04 DEC-11 DEC-12 DEC-16 DEC-19 DEC-20 DEC-22 DEC-28 DEC-30 DEC-31 DEC-32	the owner's standing rules found outside DECISIONS.md (P1.3 TO-DEC), the CRM rows L05, L06, L12, L16, L21, L28 and the signposting design given their home by slice S1
   ```
   with
   ```text
   D106	2026-11-01	DEC	DEC-02 DEC-04 DEC-11 DEC-12 DEC-16 DEC-19 DEC-20 DEC-22 DEC-28 DEC-30 DEC-31 DEC-32 DEC-33	the owner's standing rules found outside DECISIONS.md (P1.3 TO-DEC), the CRM rows L05, L06, L12, L16, L21, L28 and the signposting design given their home by slice S1
   ```

   j) immediately after the line
   ```text
   D128	2026-11-09	DEC	DEC-07 DEC-25 DEC-33	WS-034: owning-tests local suite and TEMP bound landed; Batch 6 release class; rule 12 fix, do not skip, no mistake twice
   ```
   insert
   ```text
   D129	2026-11-11	DEC	DEC-01 DEC-28 DEC-30 DEC-33	WS-040: DEC-33 rules 1-3, 6-9 and 12 amended from Batch 6; DEC-03 retired into rules 1-3; batch-scoped rules; guard at the source; ACI in DEC-30
   ```

   The resulting file's Git blob is b9bbaa20c28b3c13716e7484a826f612a99100b0.

5. Check whether `docs/RUNBOOK.md` contains `2. For every tool, rule and folder the workstream touched, ask once: does it still earn its place (DEC-33 rule 3)? Merge or`; if so record Already Applied when its Git blob is 13cac2b13fe1f6a298c73b042c7fd32266b3ecc2, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-040 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   2. For every tool, rule and folder the workstream touched, ask once: does it still earn its place (DEC-03)? Merge or
   ```
   with
   ```text
   2. For every tool, rule and folder the workstream touched, ask once: does it still earn its place (DEC-33 rule 3)? Merge or
   ```

   The resulting file's Git blob is 13cac2b13fe1f6a298c73b042c7fd32266b3ecc2.

6. Check whether `docs/WORKSPACE-LAYOUT.md` contains `## 1. The four tests (owner principles, DEC-33 rules 1-3)`; if so record Already Applied when its Git blob is 402369241d70831c8cdf6547b5804b8240beba42, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-040 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   ## 1. The four tests (owner principles, DEC-03)
   ```
   with
   ```text
   ## 1. The four tests (owner principles, DEC-33 rules 1-3)
   ```

   The resulting file's Git blob is 402369241d70831c8cdf6547b5804b8240beba42.

7. Check whether `lib/hooks/Guard-Write.ps1` contains `param([string]$Settings=(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) '.claude\settings.json'),[string]$FinishLog='finish\.log')`; if so record Already Applied when its Git blob is fac8024ca1760dc95fa7cfcacab5df4c570ceade, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-040 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([string]$Settings=(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) '.claude\settings.json'))
   ```
   with
   ```text
   param([string]$Settings=(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) '.claude\settings.json'),[string]$FinishLog='finish\.log')
   ```

   b) immediately after the line
   ```text
   $command="$(([Console]::In.ReadToEnd()|ConvertFrom-Json).tool_input.command)"
   ```
   insert
   ```text
   # A Finish hashes the real journal from launch to END (event no-journal-write-during-finish): no Events -Add while one runs.
   # A Finish is a pwsh running lib/Pulse.ps1's timed-run test (run_timed.ps1) with its finish.log.
   if($command-match'Events\.ps1\b[^|;&\r\n]*\s-Add\b'){$run=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'"|Where-Object{$_.CommandLine-match'run_timed\.ps1'-and$_.CommandLine-match$FinishLog})
       if($run.Count){[Console]::Error.WriteLine("GUARD_FINISH_JOURNAL: a Finish is running (pid $($run[0].ProcessId)); Events -Add changes the real journal it checks, so queue the lesson and add it after END");exit 2}}
   ```

   The resulting file's Git blob is fac8024ca1760dc95fa7cfcacab5df4c570ceade.

8. Check whether `lib/Invoke-ContractStage.ps1` contains `# The CR a pending top carries, or $null: walk first parents from $Head while each commit changes one change file X`; if so record Already Applied when its Git blob is 90d40d0f8fc56280a6d09036e11638b2367e1768, and otherwise stop and report. Otherwise make exactly these 5 edits (land this exact frozen WS-040 candidate output), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
       $plan
   }
   ```
   insert
   ```text
   # The CR a pending top carries, or $null: walk first parents from $Head while each commit changes one change file X
   # (the same X throughout) plus only the manifest and ai-map, down to $Main or a bound record, at most 20 commits; X must
   # read [x] Cancelled at $Head and appear in the Draft's Supersedes section (CRM CANCELLED_SEGMENT_NOT_CARRIED).
   function Get-CarriedCancel([string]$Head,[string]$Main){
       $x=$null;$c=$Head
       for($n=0;$c-ne$Main-and!(Test-Path -LiteralPath (Join-Path $r ".orvion-certifications\$c.json"));$n++){
           if($n-ge20){return $null}
           $files=@(Invoke-RepoGit @('diff-tree','--no-commit-id','--name-only','-r','--no-renames',$c))
           $own=@($files|Where-Object{$_-like'changes/*.md'})
           if($own.Count-ne1-or($x-and$own[0]-cne$x)){return $null}
           if(@($files|Where-Object{$_-cnotin@($own[0],'_ORVION_CANONICAL/manifest.md','ai-map.json')}).Count){return $null}
           $x=$own[0];$c=Invoke-RepoGit @('rev-parse',"$c^")
       }
       if(!$x){return $null}
       if((@(Invoke-RepoGit @('show',"${Head}:$x"))-join"`n")-notmatch'(?m)^\[x\] Cancelled\s*$'){return $null}
       $sup=[regex]::Match(([IO.File]::ReadAllText($cfg.Draft)-replace"`r`n","`n"),'(?s)\n## Supersedes / Depends On\n(.*?)(?=\n## |\z)')
       if(!$sup.Success-or!$sup.Groups[1].Value.Contains($x)){return $null}
       $x
   }
   ```

   b) immediately after the line
   ```text
   $bootCode=$LASTEXITCODE
   ```
   insert
   ```text
   # The read-only Boot is retried once on the two named transient fetch refusals only (event native-boot-git-timeout-retry).
   if($bootCode-and$boot-match'(?m)^(SUBJECT: github:PUBLIC_READ:GIT_TIMEOUT|CODE: GIT_FETCH_FAILED)\r?$'){Write-Say "NATIVE BOOT $($Matches[1]): one retry";$boot=& pwsh -NoProfile -File $native -Root $r -Boot 2>&1|Out-String;$bootCode=$LASTEXITCODE}
   ```

   c) replace the line
   ```text
       Invoke-RepoGit @('fetch','-q','origin')|Out-Null
   ```
   with
   ```text
       # The fetch is read-only for the checkout: one retry on a failed exit (event native-boot-git-timeout-retry).
       try{Invoke-RepoGit @('fetch','-q','origin')|Out-Null}catch{Write-Say "FETCH failed: one retry ($_)";Invoke-RepoGit @('fetch','-q','origin')|Out-Null}
   ```

   d) replace the line
   ```text
       # main with its own bound record in this original checkout.
   ```
   with
   ```text
       # main with its own bound record in this original checkout, or (SPEC-273 carriage) when its unbound top is
       # only one earlier CR's allocate/approve/cancel commits, that CR Cancelled and named in this Draft's Supersedes.
   ```

   e) replace the lines
   ```text
           if(!(Test-Path -LiteralPath (Join-Path $r ".orvion-certifications\$head.json"))){throw "PENDING_BASELINE_UNBOUND $head"}
           Write-Say "baseline $head is a pending candidate above main $om, bound record present"
   ```
   with
   ```text
           if(Test-Path -LiteralPath (Join-Path $r ".orvion-certifications\$head.json")){Write-Say "baseline $head is a pending candidate above main $om, bound record present"}
           else{$carried=Get-CarriedCancel $head $om;if(!$carried){throw "PENDING_BASELINE_UNBOUND $head"}
               Write-Say "baseline $head carries Cancelled $carried (named in Supersedes) above $om or a bound record"}
   ```

   The resulting file's Git blob is 90d40d0f8fc56280a6d09036e11638b2367e1768.

9. Check whether `lib/README.md` contains `. While a Finish runs (a pwsh running run_timed.ps1 with its finish.log;`; if so record Already Applied when its Git blob is 074df9297203684b9b047627fd06de69b2ab61c4, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-040 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   | `hooks\Guard-Write.ps1` | the PreToolUse guard of `.claude/settings.json` on PowerShell and Bash (DEC-28, guards.md G02): a command naming a single-writer file with a write verb exits 2, `GUARD_SINGLE_WRITER`. The names are those of the settings' Edit deny rules (G01). It catches accidents and is no security boundary |
   ```
   with
   ```text
   | `hooks\Guard-Write.ps1` | the PreToolUse guard of `.claude/settings.json` on PowerShell and Bash (DEC-28, guards.md G02): a command naming a single-writer file with a write verb exits 2, `GUARD_SINGLE_WRITER`. While a Finish runs (a pwsh running run_timed.ps1 with its finish.log; `-FinishLog` names another log for tests), `Events.ps1 -Add` exits 2, `GUARD_FINISH_JOURNAL`. The names are those of the settings' Edit deny rules (G01). It catches accidents and is no security boundary |
   ```

   The resulting file's Git blob is 074df9297203684b9b047627fd06de69b2ab61c4.

10. Check whether `lib/test-native-stage.ps1` contains `function New-StageFixture([string]$Name,[switch]$Outside,[switch]$RefuseBoot,[string]$Clause='',[string]$BootScript=''){`; if so record Already Applied when its Git blob is 3c45de4f9c663a77b2f0657c60bb8b89fd67aff7, and otherwise stop and report. Otherwise make exactly these 5 edits (land this exact frozen WS-040 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   function New-StageFixture([string]$Name,[switch]$Outside,[switch]$RefuseBoot,[string]$Clause=''){
   ```
   with
   ```text
   function New-StageFixture([string]$Name,[switch]$Outside,[switch]$RefuseBoot,[string]$Clause='',[string]$BootScript=''){
   ```

   b) replace the line
   ```text
       $answer=if($RefuseBoot){"'ORVION: BLOCKED';exit 1"}else{"'ORVION: READY';'MODE: EXECUTE';'CR: SPEC-1';'STATUS: Approved';exit 0"}
   ```
   with
   ```text
       $answer=if($BootScript){$BootScript}elseif($RefuseBoot){"'ORVION: BLOCKED';exit 1"}else{"'ORVION: READY';'MODE: EXECUTE';'CR: SPEC-1';'STATUS: Approved';exit 0"}
   ```

   c) immediately after the lines
   ```text
       $createdFixture
   }
   ```
   insert
   ```text
   # An approval fixture whose baseline is an earlier CR's allocate/approve/cancel commits above origin/main (CRM SPEC-304
   # under SPEC-305, 2026-11-11). -Status is that CR's state at the top; -Extra adds a.txt to the top commit; -Name drops
   # or keeps the Supersedes line; -Bound writes the top's bound record; -Floor puts an unbound other commit below them.
   function New-PendingFixture([string]$Name,[string]$Status='Cancelled',[switch]$Extra,[switch]$Unnamed,[switch]$Bound,[switch]$Floor){
       $f=New-ApprovalFixture $Name 'PASS';$root=$f.Root;$old='changes/SPEC-0-old.md'
       if($Floor){[IO.File]::WriteAllText((Join-Path $root 'b.txt'),"floor
   ");$null=Read-StageGit $root @('add','--','b.txt');$null=Read-StageGit $root @('commit','--quiet','-m','other: unbound floor')}
       [IO.File]::AppendAllText((Join-Path $root '.git/info/exclude'),".orvion-certifications/`n")
       $text="# SPEC-0 old`n`n## Status`n`n[x] Draft`n[ ] Approved`n[ ] Cancelled`n"
       [IO.File]::WriteAllText((Join-Path $root $old),$text);$null=Read-StageGit $root @('add','--',$old);$null=Read-StageGit $root @('commit','--quiet','-m','SPEC-0: allocate')
       $text=$text.Replace('[x] Draft','[ ] Draft').Replace('[ ] Approved','[x] Approved');[IO.File]::WriteAllText((Join-Path $root $old),$text)
       [IO.File]::AppendAllText((Join-Path $root '_ORVION_CANONICAL/manifest.md'),"Approved: SPEC-0`n")
       $null=Read-StageGit $root @('add','--',$old,'_ORVION_CANONICAL/manifest.md');$null=Read-StageGit $root @('commit','--quiet','-m','SPEC-0: Approve')
       if($Status-eq'Cancelled'){$text=$text.Replace('[x] Approved','[ ] Approved').Replace('[ ] Cancelled','[x] Cancelled')}else{$text+="Note.`n"}
       [IO.File]::WriteAllText((Join-Path $root $old),$text);$add=@($old)
       if($Extra){[IO.File]::WriteAllText((Join-Path $root 'a.txt'),"smuggled`n");$add+='a.txt'}
       $null=Read-StageGit $root (@('add','--')+$add);$null=Read-StageGit $root @('commit','--quiet','-m',"SPEC-0: $Status")
       $top=@(Read-StageGit $root @('rev-parse','HEAD'))[0]
       if($Bound){[void][IO.Directory]::CreateDirectory((Join-Path $root '.orvion-certifications'));[IO.File]::WriteAllText((Join-Path $root ".orvion-certifications/$top.json"),'{}')}
       $sup=if($Unnamed){"- ``changes/SPEC-9-other.md`` (Cancelled)"}else{"- ``$old`` (Cancelled; this contract carries it)"}
       [IO.File]::WriteAllText($f.Draft,[IO.File]::ReadAllText($f.Draft).Replace("## Write Scope","## Supersedes / Depends On`n`n$sup`n`n## Write Scope"))
       $blob=@(Read-StageGit $root @('hash-object','--path=changes/SPEC-1-probe.md','--',$f.Draft))[0]
       [IO.File]::WriteAllText($f.Config,"@{Root='$root';Main='$top';Id='SPEC-1';Slug='probe';Draft='$($f.Draft)';Sha='$((Get-FileHash -LiteralPath $f.Draft).Hash)';Blob='$blob';User='Stage Fixture';Suffix='toy only';ApprovalNote='synthetic only'}")
       $f.Head=$top;$f
   }
   $retryNative="`$c=@(Get-Content (Join-Path `$Root '.git/native.calls')).Count;if(`$c-le__N__){'ORVION: BLOCKED';'CODE: __CODE__';'SUBJECT: origin';exit 1};'ORVION: READY';'MODE: EXECUTE';'CR: SPEC-1';'STATUS: Approved';exit 0"
   function Get-BootCalls($Fixture){@(Get-Content (Join-Path $Fixture.Root '.git/native.calls')|Where-Object{$_-eq'boot'}).Count}
   ```

   d) immediately after the line
   ```text
       Assert-Stage 'unsupported diagnostic checks stay explicit UNPROVEN, not a duplicate native engine or false pass' ($bad.Exit-eq2-and$bad.Output-match'UNPROVEN: native checks outside')
   ```
   insert
   ```text
       $carried=New-PendingFixture 'pending-carried';$r1=Invoke-StageFixture $carried -Stage approve
       Assert-Stage 'a Cancelled CR named in Supersedes carries an unbound pending baseline to approval' ($r1.Exit-eq0-and$r1.Output-match'carries Cancelled changes/SPEC-0-old.md'-and[IO.File]::ReadAllText((Join-Path $carried.Root 'changes/SPEC-1-probe.md')).Contains('[x] Approved')) $r1.Output
       $bound=New-PendingFixture 'pending-bound' -Status Approved -Bound;$r2=Invoke-StageFixture $bound -Stage approve
       Assert-Stage 'a bound pending baseline still approves (SPEC-284)' ($r2.Exit-eq0-and$r2.Output-match'bound record present') $r2.Output
       foreach($case in @(@('pending-unnamed',@{Unnamed=$true},'a Cancelled CR the Draft does not name'),@('pending-extra',@{Extra=$true},'a pending commit that also changes another file'),@('pending-approved',@{Status='Approved'},'a pending CR that is not Cancelled'),@('pending-floor',@{Floor=$true},'a Cancelled CR above an unbound commit that is not main'))){
           $p=$case[1];$fx=New-PendingFixture $case[0] @p;$rx=Invoke-StageFixture $fx -Stage approve
           Assert-Stage "refused before any write: $($case[2])" ($rx.Exit-ne0-and$rx.Output-match'PENDING_BASELINE_UNBOUND'-and$rx.Head-ceq$fx.Head-and!(Test-Path (Join-Path $fx.Root 'changes/SPEC-1-probe.md'))) $rx.Output
       }
       $once=New-StageFixture 'boot-once' -BootScript $retryNative.Replace('__N__','1').Replace('__CODE__','GIT_FETCH_FAILED');$r3=Invoke-StageFixture $once
       Assert-Stage 'one named transient Boot refusal gets exactly one retry, then the stage runs' ($r3.Exit-eq0-and$r3.FileExists-and(Get-BootCalls $once)-eq2) $r3.Output
       $twice=New-StageFixture 'boot-twice' -BootScript $retryNative.Replace('__N__','9').Replace('__CODE__','GIT_FETCH_FAILED');$r4=Invoke-StageFixture $twice
       Assert-Stage 'a second named refusal stands: no third Boot, no write' ($r4.Exit-ne0-and$r4.Output-match'NATIVE_BOOT_REFUSED'-and!$r4.FileExists-and(Get-BootCalls $twice)-eq2)
       $other=New-StageFixture 'boot-other' -BootScript $retryNative.Replace('__N__','9').Replace('__CODE__','DIRTY_CHECKOUT');$r5=Invoke-StageFixture $other
       Assert-Stage 'any other Boot refusal is not retried' ($r5.Exit-ne0-and(Get-BootCalls $other)-eq1)
       $nofetch=New-PendingFixture 'fetch-fails';$null=Read-StageGit $nofetch.Root @('remote','set-url','origin',(Join-Path $tempRoot 'no-such-origin'));$r6=Invoke-StageFixture $nofetch -Stage approve
       Assert-Stage 'a failed approve fetch is retried once and then stops before any write' ($r6.Exit-ne0-and$r6.Output-match'FETCH failed: one retry'-and$r6.Head-ceq$nofetch.Head) $r6.Output
   ```

   e) immediately after the line
   ```text
       Assert-Stage 'causal removal of allocation binding allows the exact unallocated revision to execute' ($bad.Exit-eq0-and$bad.FileExists-and$bad.Head-cne$swapped.Head)
   ```
   insert
   ```text
       $body=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Invoke-ContractStage.ps1'));$needle='if(!$sup.Success-or!$sup.Groups[1].Value.Contains($x)){return $null}'
       if(!$body.Contains($needle)){throw 'STAGE_SUPERSEDES_MUTANT_ANCHOR'};[IO.File]::WriteAllText($path,$body.Replace($needle,''))
       $fx=New-PendingFixture 'mutant-unnamed' -Unnamed;$bad=Invoke-StageFixture $fx -Library $mutantLib -Stage approve
       Assert-Stage 'causal removal of the Supersedes check lets an unnamed Cancelled CR carry the baseline' ($bad.Exit-eq0) $bad.Output
       $needle="'(?m)^(SUBJECT: github:PUBLIC_READ:GIT_TIMEOUT|CODE: GIT_FETCH_FAILED)\r?`$'"
       if(!$body.Contains($needle)){throw 'STAGE_RETRY_MUTANT_ANCHOR'};[IO.File]::WriteAllText($path,$body.Replace($needle,"'(?m)^CODE: '"))
       $fx=New-StageFixture 'mutant-retry' -BootScript $retryNative.Replace('__N__','9').Replace('__CODE__','DIRTY_CHECKOUT');$null=Invoke-StageFixture $fx -Library $mutantLib
       Assert-Stage 'causal widening of the retry to any code retries an unnamed refusal' ((Get-BootCalls $fx)-eq2)
   ```

   The resulting file's Git blob is 3c45de4f9c663a77b2f0657c60bb8b89fd67aff7.

11. Check whether `lib/test-organize.ps1` contains `# GUARD_FINISH_JOURNAL with a log name of its own, so the real Finish that runs this suite is not seen.`; if so record Already Applied when its Git blob is cb655e3d2d304a585f3eef98bbec2efffb21db64, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-040 candidate output), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
           Assert-That "G02 passes: $read" ((Get-GuardExit $read)-eq0)
       }
   ```
   insert
   ```text
       # GUARD_FINISH_JOURNAL with a log name of its own, so the real Finish that runs this suite is not seen.
       $finishName="finish-$([guid]::NewGuid().ToString('N')).log"
       function Get-FinishGuardExit([string]$Command){@{tool_input=@{command=$Command}}|ConvertTo-Json -Compress|& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'hooks\Guard-Write.ps1') -FinishLog ([regex]::Escape($finishName)) 2>&1|Out-Null;$LASTEXITCODE}
       $add='pwsh -NoProfile -File lib/Events.ps1 -Add -Pattern x -Summary y'
       Assert-That 'G02 Events -Add passes with no Finish' ((Get-FinishGuardExit $add)-eq0)
       $dummy=Start-Process pwsh -ArgumentList '-NoProfile','-Command',"Start-Sleep 120 # run_timed.ps1 -Log C:\x\$finishName" -WindowStyle Hidden -PassThru
       try{
           for($i=0;$i-lt50-and!@(Get-CimInstance Win32_Process -Filter "ProcessId=$($dummy.Id)"|Where-Object{$_.CommandLine-match[regex]::Escape($finishName)}).Count;$i++){Start-Sleep -Milliseconds 100}
           Assert-That 'G02 refuses Events -Add while a Finish runs' ((Get-FinishGuardExit $add)-eq2)
           Assert-That 'G02 passes Events -Find while a Finish runs' ((Get-FinishGuardExit 'pwsh -NoProfile -File lib/Events.ps1 -Find x')-eq0)
       }finally{Stop-Process -Id $dummy.Id -Force -ErrorAction SilentlyContinue}
   ```

   The resulting file's Git blob is cb655e3d2d304a585f3eef98bbec2efffb21db64.

## Acceptance Criteria

- [x] Output `changes/README.md` equals its declared resulting Git blob. check: blob:changes/README.md=dd02d07de7bc7c2ec0830f3c1aa9a9c120cf2e03
- [x] Output `docs/DECISIONS.md` equals its declared resulting Git blob. check: blob:docs/DECISIONS.md=5231cbf83726747180c7d3608c8785e4f9df01c9
- [x] Output `docs/history/DECISIONS-ARCHIVE.md` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-ARCHIVE.md=6ed7c71a81e3ccbac6254b8b793e5b854ec261bb
- [x] Output `docs/history/DECISIONS-MAP.tsv` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-MAP.tsv=b9bbaa20c28b3c13716e7484a826f612a99100b0
- [x] Output `docs/RUNBOOK.md` equals its declared resulting Git blob. check: blob:docs/RUNBOOK.md=13cac2b13fe1f6a298c73b042c7fd32266b3ecc2
- [x] Output `docs/WORKSPACE-LAYOUT.md` equals its declared resulting Git blob. check: blob:docs/WORKSPACE-LAYOUT.md=402369241d70831c8cdf6547b5804b8240beba42
- [x] Output `lib/hooks/Guard-Write.ps1` equals its declared resulting Git blob. check: blob:lib/hooks/Guard-Write.ps1=fac8024ca1760dc95fa7cfcacab5df4c570ceade
- [x] Output `lib/Invoke-ContractStage.ps1` equals its declared resulting Git blob. check: blob:lib/Invoke-ContractStage.ps1=90d40d0f8fc56280a6d09036e11638b2367e1768
- [x] Output `lib/README.md` equals its declared resulting Git blob. check: blob:lib/README.md=074df9297203684b9b047627fd06de69b2ab61c4
- [x] Output `lib/test-native-stage.ps1` equals its declared resulting Git blob. check: blob:lib/test-native-stage.ps1=3c45de4f9c663a77b2f0657c60bb8b89fd67aff7
- [x] Output `lib/test-organize.ps1` equals its declared resulting Git blob. check: blob:lib/test-organize.ps1=cb655e3d2d304a585f3eef98bbec2efffb21db64
- [x] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [x] AC-01 Carried Cancel (item 1): in lib/Invoke-ContractStage.ps1 the approve stage, when origin/main is not the configured baseline and the head has no bound record, accepts the head only when Get-CarriedCancel walks first parents from it, at most 20 commits, each changing one and the same change file X plus only _ORVION_CANONICAL/manifest.md and ai-map.json, down to origin/main or a commit with its own bound record, X reads [x] Cancelled at the head and the selected Draft's Supersedes / Depends On section contains X's path; otherwise PENDING_BASELINE_UNBOUND as at baseline, before any write. test-native-stage passes, including: a Cancelled CR named in Supersedes carries the baseline to approval; a bound pending baseline still approves (SPEC-284); refused before any write: a Cancelled CR the Draft does not name, a pending commit that also changes another file, a pending CR that is not Cancelled, a Cancelled CR above an unbound commit that is not main; the mutant without the Supersedes check is killed. Real case, design evidence only and never SPEC-305 approval evidence (owner 2026-11-11 ~23:35): on a disposable clone of CRM at 4a65685 the candidate stage accepted the frozen SPEC-305 Draft (it carries Cancelled SPEC-304) and refused a copy without the Supersedes line (data/records/WS-040/CONTRACT.md section 4); SPEC-305 is approved only in its own fresh governed sandbox after the release. CRM's native gates (SPEC-273 CANCELLED_SEGMENT_NOT_CARRIED at publication) keep their authority; this check only stops the Workbench refusing first.
- [x] AC-02 One retry (item 2): the read-only native Boot is run a second time only when its first run fails with `SUBJECT: github:PUBLIC_READ:GIT_TIMEOUT` or `CODE: GIT_FETCH_FAILED` on a line of its own, and the approve `git fetch -q origin` only after a failed exit; each at most once, then the refusal stands (DEC-33 rule 8 as amended). test-native-stage passes, including: one named refusal gets exactly one retry and the stage runs; a second named refusal stands with no third Boot and no write; any other Boot refusal is not retried; a failed approve fetch is retried once and stops before any write; the mutant that retries any code is killed.
- [x] AC-03 Finish journal guard (item 3a): lib/hooks/Guard-Write.ps1 exits 2 with GUARD_FINISH_JOURNAL for a command that runs Events.ps1 with -Add while a pwsh process runs run_timed.ps1 with a log matching -FinishLog (default `finish\.log`), and lib/README.md says so in the hook's row; test-organize passes with its earlier guard cases and the new ones (Events -Add passes with no Finish; refused while a Finish runs; Events -Find passes while a Finish runs), each using a log name of its own so the real Finish running the suite is not seen. Known limits, reported and not claimed covered: a call through a variable or an alias, a write by Save-State or another tool, and a session whose hooks are not this checkout's are not seen; the hook catches accidents and is no security boundary.
- [x] AC-04 Organizer (items 3b and 3c): changes/README.md is what lib/Organize.ps1 -Refresh writes: it holds the WS-034 and WS-040 rows, and a refresh of the replay changes no organizer.
- [x] AC-05 Constitution text (item 4): docs/DECISIONS.md is at most 49152 B after LF normalisation; DEC-03 is removed and only DEC-01, DEC-28, DEC-30 and DEC-33 otherwise differ from baseline, each with Changed 2026-11-11 and D129 in its History; DEC-33 keeps twelve numbered rules, rules 4, 5, 10 and 11 unchanged, and rules 1, 2, 3, 6, 7, 8, 9 and 12 read exactly as data/records/WS-040/CONTRACT.md section 3; DEC-30 reads "CAG, ACI, SACI, PICF and CRGL"; DEC-01 names batch-scoped rules folded into their DEC entry at the batch close or lapsed; DEC-28 keeps a fixed defect class closed at its source. docs/history/DECISIONS-ARCHIVE.md changes only by appending item D129, which quotes the owner's texts verbatim as frozen in data/records/WS-040/owner-words/decisions-inbox-20261111T2350.md (SHA256 0A6237315EAB6F39595A3DC02B8F33BB386DF79D014DE88B1EEE039A5487003F) and the replaced DEC-03 entry, DEC-01, DEC-28 and DEC-30 sentences and the eight replaced rules verbatim, each followed by its Now in line; docs/history/DECISIONS-MAP.tsv changes only by appending row D129 and by naming DEC-33 for DEC-03 in rows D19, D21, D37, D48, D65, D88, D95, D103 and D106, and no row with status DEC names a missing entry; docs/RUNBOOK.md and docs/WORKSPACE-LAYOUT.md change only their DEC-03 citation; every requirement of the retired DEC-03 keeps a home (owner 2026-11-11 ~23:35): looking before adding, reuse and evidence are rules 1, 2 and 10; the CRM and ORVION governance and current sources weighed by strength, and verifying each fact before acting, rule 1; fact, inference and hypothesis kept apart, rule 10 (PROVEN, UNPROVEN or HYPOTHESIS); the owner asked what only the owner knows, WORKSPACE-LAYOUT.md section 1 (an agent deciding what only the owner knows fails it); a file only while something reads it and nothing kept only as history, rule 3 and section 1; tools that really work, rules 2 and 9; the shortest boring form keeping every gate and boundary and a budget met by moving text, rule 3; small, closely related files merged, section 1; minimal, demonstrably safe, fail closed with the evidence kept, rules 3, 8 and 10; a found gap fixed now or given a named trigger, rule 12; and section 1, which applies the tests, cites DEC-33 rules 1-3; the Markdown guard passes with this contract in place, and test-markdown-consistency and test-hunt pass.
- [x] AC-06 Secrets and privacy: gitleaks on the exact candidate range reports no finding in the 11 outputs and RESUME.md; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; neither masked value (the computer name, a marketing tunnel script name) is in any changed file or in this contract.
- [x] AC-07 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json. From each Finish launch to END: no Events -Add, Save-State or edit in a protected root, and Docker off.
- [x] AC-08 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-040/evidence/protected-before.json, captured before the sandbox Finish and again after Original Complete with data/records/WS-038/Capture-Protected.ps1; lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1 and lib/apply-draft-steps.ps1 are unchanged; CRM, ORVION and their trusted copies keep their HEAD and files (the lifecycle's protected-root compare); no Codex, subagent, RAM, power setting or scheduled task change; no push or release under this contract. Commits stay local (DEC-25).

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
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-040\assurance\V4\DRAFT.md
Approved SHA256: F7CC17550C14C3173C34612B6B9786F64E0DC9C92ADCF8F62BB28D965D48F18C
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-040\gate\GATE1-WS040-V4-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: EDFBE837EBAD0AA72D2458A4793DFD2982B6D1CDDC350AD39A40DC89AABA94D5
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W40b\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 8B36822983263218D1FB91F16FCF961D17DB3A5B03E47AD7376E431208B9E1EA
Original exact declared outputs applied by accepted native Execute; fresh own Finish and Review/Complete remain required. Other protected roots unchanged. Controller: the Original's own baseline lib/Invoke-ContractLifecycle.ps1 (SHA256 50DFF63C, unchanged by this contract), checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority.
Residual risks carried unchanged from the selected Draft Review Gate and V4 REPORT.md; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (D120, frozen in data/records/WS-034/owner-words), not by unavailability. Controller: the Original's own baseline lib/Invoke-ContractLifecycle.ps1 (SHA256 50DFF63C, unchanged by this contract), checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority. Release is a later stage, reserved to the owner.

## Verification Notes

V4 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W40-cand (data/records/WS-040/Make-Candidate.ps1). Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json and REPORT.md beside this Draft. After Complete, outside this contract: the release is reserved to the owner's explicit words (owner ~23:35: stop at P6 with a release-readiness report); the protected state is compared with its record from before; the inbox is folded (CONTRACT.md item 5); Save-State and the status page record the result. V4 is the one corrective version (DEC-14) of V3 (assurance\V3\DRAFT.md, SHA256 89810CE3B04B5C2FBA00398E7014E1AD293354066FEC87BF6F48DEAB58B480D2): its one sandbox Finish (2026-11-12 00:35-01:14 Cairo, runtime sb\W40\runtime\sandbox) failed only on the hazard check, lib/test-native-stage.ps1:13, where the new -Answer parameter and the existing local $answer are one variable to PowerShell; every suite passed and the real journal was unchanged. That Finish is kept as evidence and never rerun (DEC-23). The only output change is that parameter renamed -BootScript (six lines, no logic change); the Execution Context moves to the fresh roots under sb\W40b. Sources, change and selection: STANDARDS-CHECK.md and REPORT.md beside this Draft.
Verdict: Confirmed Complete
Reviewed Fingerprint: CBA013F3F1D3DC725BCE29A4C365006BC8A4B0E58D0ED20EE42055D3CC9CCA6A
Reviewed Receipt: AE137C38CF09329C2197ED48851619D1D67F79469ED40B75A304A242E8F4E17C
Live ORIGINAL-role review: runtime/original/criterion-review.json. Own Finish 31 ordered suites, runner/watcher/host 0/0/0, real journal unchanged. Review: ONE Claude-main SELF-REVIEW, not independent; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (D120, frozen in data/records/WS-034/owner-words), not by unavailability. Exact completed sandbox proof 04C5D42F7B71E1630BADEBC8D54C71D2F042AC73C9E7EED7300EF21C0E3D4F8B bound. Not pushed; the release waits for the owner's explicit words.

