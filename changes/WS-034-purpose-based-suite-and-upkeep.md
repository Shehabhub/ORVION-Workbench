# Workbench Change Request - WS-034

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Make every later contract and Batch 6 slice cheaper and safer to run, so ORVION moves faster (DEC-30), with the WS-034 scope of data/records/WS-034/CONTRACT.md sections 2 and 10: the local Finish runs the always-on tests plus the tests that own the changed files, failing closed to the full schedule, while the CI recipe keeps the full schedule (DEC-07, about 20 minutes saved per contract); the evaluator bounds the Temp Root at 93 characters and its CI fixture floors become 0.001 GB under the owner's removal of every RAM minimum; Save-State retries a held continuity folder move a bounded number of times, works under a short TEMP, remembers its plan, splits a comma-joined evidence string and starts a new workstream folder only with an explicit plan; Guard-Write refuses only a write into a single-writer file, not every mention of its name, and refuses a write into a package\release folder (a lesson repeated in WS-037 and WS-038); the B15 Hunt and Organize fixes land; the stale Batch 6 hold sentence becomes the configured HoldNote; DEC-07 states the landed rule, DEC-25 names the Batch 6 release class with its conditions and DEC-33 rule 12 merges the owner's "no mistake twice" and "fix, do not skip" (D128); RUNBOOK sections 2 and 11 and the changes organizer say what the code now does. Benefit: shorter Finishes, fewer refused saves and guard false positives, and no repeated release-log mistake.

Tier: Significant under DEC-12 (the accepted evaluator, a hook, three tools and governance text change). Authority: DEC-01, DEC-02, DEC-04, DEC-07, DEC-08, DEC-09, DEC-12, DEC-13, DEC-14, DEC-19, DEC-22, DEC-23, DEC-24, DEC-25, DEC-28, DEC-30 and DEC-33; the owner's words of 2026-11-08 ~09:55 Cairo (WS-034 after the WS-038 release, beside Batch 6), ~10:20 (B15 in parallel; the Batch 6 class; standing approval of Claude main's proposals inside the constitution), ~10:35 (no mistake twice), ~21:10 (fix, do not skip), ~23:05 (start WS-034 if the constitution permits), 2026-11-07 ~19:40-20:06 (every RAM minimum removed), 2026-11-08 ~01:20 (no Codex, no subagents, standing) and 2026-11-09 ~05:55 (questions settled by the constitution first), frozen in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md. Every scope choice is Claude main's under that authority, labelled DELEGATED; no owner text is typed by an agent (DEC-02).

Number: WS-034 is reserved by DEC-04 and DEC-07. Intended contract: changes/WS-034-purpose-based-suite-and-upkeep.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: this contract changes the accepted evaluator, so the Original's own lib/Invoke-ContractLifecycle.ps1 refuses its judge after implement (LIFECYCLE_ROOT_EVALUATOR_CHANGED). Both roles run a byte-exact copy of the baseline controller outside the Original (data/records/WS-034/controller, its SHA256 recorded) with the accepted judge. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run. This contract's own Finishes run the full schedule, because its scope holds CONTROL paths; the saving starts with the next contract.

## Baseline

d69f27766b466b37a3ba3ee4de5176f2bb178c13

## Write Scope

- changes/README.md
- docs/DECISIONS.md
- docs/history/DECISIONS-ARCHIVE.md
- docs/history/DECISIONS-MAP.tsv
- docs/RUNBOOK.md
- lib/hooks/Guard-Write.ps1
- lib/Hunt.ps1
- lib/Invoke-ContractStage.ps1
- lib/Organize.ps1
- lib/Save-State.ps1
- lib/test-hunt.ps1
- lib/test-native-stage.ps1
- lib/test-organize.ps1
- lib/test-save-state.ps1
- lib/test-workbench-governance.ps1
- lib/Test-WorkbenchChange.ps1
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: lib/Invoke-ContractLifecycle.ps1, lib/apply-draft-steps.ps1, lib/Delegate.ps1 (PLAN section 9 register, trigger: the owner re-enables Codex), tests.ps1 and every other lib/ file, test and hook; every DEC entry but DEC-07, DEC-25 and DEC-33; the inbox fold (data/decisions-inbox.md is untracked; folded after Original Complete, CONTRACT.md item 13); the tracked-docs token tidy (its own contract); the sandbox skip for Routine contracts (decided no, CONTRACT.md section 7 Q1); the seven legacy folders, Owner-Tools, the vault, the restore staging and every package (no deletion, relocation or cleaning); any Batch 6 product step, Codex update or dispatch, machine power, memory or protection setting, or scheduled task; no CRM, ORVION, credentials, real sessions or events (DEC-08, DEC-09); any push or release (DEC-25).

## Draft Assurance

V1: WS034-V1-CLAUDE-FALLBACK-DESIGN-20261109-01 | 2026-11-09 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-034\assurance\V1\DRAFT.md | 83C3EC8E11A63BBBDBB3106A9BDFFCFC0BD3FAD07A070CB045394ADA2DA0CF19
V2: WS034-V2-CLAUDE-FALLBACK-ADVERSARIAL-20261109-01 | 2026-11-09 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-034\assurance\V2\DRAFT.md | 7353965EAD2FEA4B127E471FC95D2BC492E4ECEE9E093F09072844D8CF4BA2DF
V3: WS034-V3-CLAUDE-REFRESH-20261109-01 | 2026-11-09 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-034\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V3 EVIDENCE REFRESH by Claude main under DEC-13, binding the frozen V1 and V2 digests above; each was frozen and hashed before the next began (assurance\V1\FROZEN.json, assurance\V2\FROZEN.json). Author of V1 and V2: Claude main, claude-opus-5-5, under D120, because the owner skipped Codex and subagents for this work on 2026-11-08 ~01:20 Cairo, standing (the owner's words verbatim in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md). V2 is a same-session V2 by the author of V1. All three are one author's work: nothing here is independent, and no Codex work is claimed. Sources and selection table: assurance\V3\STANDARDS-CHECK.md and assurance\V3\REPORT.md.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W34\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W34\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W34\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W34\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order; where a step has more than 26 edits its letters cycle after z. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none. PowerShell 7.6.8 is the portable host in ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8, which WS-038 ran: the Store pwsh moved from 7.6.8 to 7.6.9 on its own between 2026-11-07 and 2026-11-09, so a fixed host keeps the version this Draft pins.

1. Check whether `changes/README.md` contains `| WS-033-compact-folders-method.md | contracts | Workbench Change Request - WS-033 | - | - |`; if so record Already Applied when its Git blob is c15ccb947a52faae9d20e333d48135a025d0e8fa, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-031-native-feature-preflight.md | contracts | Workbench Change Request - WS-031 | - | - |
   ```
   insert
   ```text
   | WS-033-compact-folders-method.md | contracts | Workbench Change Request - WS-033 | - | - |
   | WS-035-tracked-owner-files.md | contracts | Workbench Change Request - WS-035 | - | - |
   | WS-036-decision-record-and-save-state.md | contracts | Workbench Change Request - WS-036 | - | - |
   | WS-037-a6-lift-record.md | contracts | Workbench Change Request - WS-037 | - | - |
   | WS-038-finish-floors-and-upkeep.md | contracts | Workbench Change Request - WS-038 | - | - |
   ```

   The resulting file's Git blob is c15ccb947a52faae9d20e333d48135a025d0e8fa.

2. Check whether `docs/DECISIONS.md` contains `## DEC-07 Purpose-based local suite and the TEMP bound`; if so record Already Applied when its Git blob is 1dda22e02fe59f1cc1b1614bf6f8a06b03b5e6fb, and otherwise stop and report. Otherwise make exactly these 6 edits (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) replace the lines
   ```text
   ## DEC-07 WS-034 purpose-based local suite

   WS-034 changes the accepted evaluator once, through the full method: the local Finish runs the always-on checks plus
   the tests that own the changed files; the full suite still runs on GitHub before main moves; the Execution Context
   also bounds TEMP (at most 97 characters, with a Tests Root of at most 101; the evaluator does not check this today).
   Its release sets the new evaluator pin. Accepted cost: a break in another area shows first on GitHub.

   Scope: WS-034, deferred until after the Owner Lift.
   ```
   with
   ```text
   ## DEC-07 Purpose-based local suite and the TEMP bound

   The local Finish runs the always-on tests (test-workbench-governance, test-markdown-consistency,
   test-workspace-layout) plus every test that owns a Write Scope path: the test is itself in scope, or its text names the
   path's file name. It runs the full schedule instead when a scoped script (.ps1, .psm1, .mjs, .js, .json) has no owning
   test or the scope holds a CONTROL path other than RESUME.md. The CI recipe always runs the full schedule, so GitHub runs
   every test before main moves, and the recipe digest covers the selected list, so a receipt binds what ran. The
   Execution Context keeps Temp Root at most 93 characters (TEMP at most 97) and Tests Root at most 101; the evaluator's
   CI fixture floors are 0.001 GB, as the owner removed every RAM minimum. Accepted cost: a break in another area shows
   first on GitHub.

   Scope: every Workbench Finish after the WS-034 release, which sets the new evaluator pin.
   ```

   b) replace the lines
   ```text
   Changed: 2026-11-07
   History: D95, D96, D123
   ```
   with
   ```text
   Changed: 2026-11-09
   History: D95, D96, D123, D128
   ```

   c) replace the lines
   ```text
   Workbench: one push per workstream, at its end, after its native checks, through the existing release procedure
   (lib/README "Explicit dual owner operations", ruleset 'Workbench Main Protection'). Each push is one ordinary non-force
   push of an exact candidate to an exact ref after fresh actor, destination, ref, ancestry and protection checks, under
   its own DELEGATED publication or promotion record, never an earlier one; main moves only after hosted success on that
   exact head; a failure stops, with no automatic retry. WS-033's release (step P6.2) carries the whole range WS-027,
   WS-028 and WS-033 from main 4173639; the 12 WS-027 and WS-028 commits wait on workbench-preflight (f06a2b1), where
   hosted acceptance failed on 2026-10-31. CRM and ORVION: the owner wrapper's interactive confirmation is never
   emulated; running their native publish and promote engines directly needs a one-time owner authorization naming the
   exact SPECs, with every gate kept.
   ```
   with
   ```text
   Workbench: one push per workstream, at its end, after its native checks, through the existing release procedure (lib/README "Explicit dual owner operations", ruleset 'Workbench Main Protection').
   Each push is one ordinary non-force push of an exact candidate to an exact ref after fresh actor, destination, ref, ancestry and protection checks, under its own DELEGATED publication or promotion
   record, never an earlier one; main moves only after hosted success on that exact head; a failure stops, with no automatic retry. WS-033's release (step P6.2) carries the whole range WS-027, WS-028
   and WS-033 from main 4173639; the 12 WS-027 and WS-028 commits wait on workbench-preflight (f06a2b1), where hosted acceptance failed on 2026-10-31. CRM and ORVION: the owner wrapper's interactive
   confirmation is never emulated; running their native publish and promote engines directly needs a one-time owner authorization naming the exact SPECs, with every gate kept. Batch 6 class (owner
   2026-11-08): a Batch 6 SPEC in CRM or ORVION may go through its product's native publish, promote and hosted-deploy engines without the owner's words for that SPEC when it passed every native gate
   (Approve, the readiness gate, a Finish with its own receipt), hosted parity is proved after the deploy, each run has its own DELEGATED record naming that exact SPEC, the wrapper's confirmation is
   not emulated and a failure stops with no automatic retry. Outside the class, each needing the owner's own words: a migration that drops a table or column or deletes or rewrites existing rows, and
   a SPEC whose product AGENTS or ADRs demand them (DEC-08).
   ```

   d) replace the lines
   ```text
   Changed: 2026-10-31
   History: D15, D16, D29, D30, D45, D51, D52, D53, D59, D60, D90, D92, D93, D94
   ```
   with
   ```text
   Changed: 2026-11-09
   History: D15, D16, D29, D30, D45, D51, D52, D53, D59, D60, D90, D92, D93, D94, D128
   ```

   e) replace the line
   ```text
   12. Nothing open is lost: a found error, gap or question is fixed now or recorded with its owner and trigger; finish before expanding.
   ```
   with
   ```text
   12. Fix, never skip: fix each error, gap or failed check at its root now; defer only out-of-scope, unsafe or owner fixes (owner, trigger); lesson each mistake, guard a repeat; finish before expanding.
   ```

   f) replace the lines
   ```text
   Changed: 2026-11-02
   History: D112, D110
   ```
   with
   ```text
   Changed: 2026-11-09
   History: D112, D110, D128
   ```

   The resulting file's Git blob is 1dda22e02fe59f1cc1b1614bf6f8a06b03b5e6fb.

3. Check whether `docs/history/DECISIONS-ARCHIVE.md` contains `## D128 2026-11-09 WS-034: purpose-based local suite, the Batch 6 release class and rule 12`; if so record Already Applied when its Git blob is 5c4fe5518afb83d03257966240ed8663266f67cd, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   Now in: DEC-24
   ```
   insert
   ```text

   ## D128 2026-11-09 WS-034: purpose-based local suite, the Batch 6 release class and rule 12

   The owner's words of 2026-11-08, verbatim from data/decisions-inbox.md (~10:20, ~10:35 and ~21:10 Cairo):

   > I grant you the authorization in accordance with the rules and principles of the constitution: an option is to
   > authorize an entire class instead.

   > Any failure or mistake you make can serve as a learning opportunity, helping you ensure that it does not happen again
   > and that you never fall into the same error.

   > Make sure the constitution rules have some rule like 'don't skip but try to fix' and enhance this rule

   The first authorized the Batch 6 release class with the conditions Claude main wrote down before acting; DEC-25 now
   states them. The second and third merge into DEC-33 rule 12, so the rules stay twelve. WS-034 lands DEC-07 (the
   always-on and owning tests, fail closed, CI full) and the TEMP bound, and sets the evaluator's CI floors to 0.001
   under the owner's 2026-11-07 removal of every RAM minimum (D127).

   Replaced wording of DEC-07, verbatim:

   > ## DEC-07 WS-034 purpose-based local suite
   >
   > WS-034 changes the accepted evaluator once, through the full method: the local Finish runs the always-on checks plus
   > the tests that own the changed files; the full suite still runs on GitHub before main moves; the Execution Context
   > also bounds TEMP (at most 97 characters, with a Tests Root of at most 101; the evaluator does not check this today).
   > Its release sets the new evaluator pin. Accepted cost: a break in another area shows first on GitHub.
   >
   > Scope: WS-034, deferred until after the Owner Lift.
   > Why: about 20 minutes saved per workstream, while GitHub keeps the full suite.
   > Changed: 2026-11-07
   > History: D95, D96, D123

   Now in: DEC-07

   Replaced sentence of DEC-25, verbatim (the rest of the entry stands):

   > CRM and ORVION: the owner wrapper's interactive confirmation is never emulated; running their native publish and
   > promote engines directly needs a one-time owner authorization naming the exact SPECs, with every gate kept.

   Now in: DEC-25

   Replaced rule 12 of DEC-33, verbatim:

   > 12. Nothing open is lost: a found error, gap or question is fixed now or recorded with its owner and trigger; finish before expanding.

   Now in: DEC-33
   ```

   The resulting file's Git blob is 5c4fe5518afb83d03257966240ed8663266f67cd.

4. Check whether `docs/history/DECISIONS-MAP.tsv` contains `D128	2026-11-09	DEC	DEC-07 DEC-25 DEC-33	WS-034: owning-tests local suite and TEMP bound landed; Batch 6 release class; rule 12 fix, do not skip, no mistake twice`; if so record Already Applied when its Git blob is 8f77de1deb6736cf2d52b38e1020d337bda34910, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   D127	2026-11-08	DEC	DEC-24	WS-038: no lifecycle memory floor; keep-awake during a Finish; DECISIONS.md budget 48 KB
   ```
   insert
   ```text
   D128	2026-11-09	DEC	DEC-07 DEC-25 DEC-33	WS-034: owning-tests local suite and TEMP bound landed; Batch 6 release class; rule 12 fix, do not skip, no mistake twice
   ```

   The resulting file's Git blob is 8f77de1deb6736cf2d52b38e1020d337bda34910.

5. Check whether `docs/RUNBOOK.md` contains `explicit minimum host headroom (Temp Root at most 93 characters: DEC-07). Unknown fields, root`; if so record Already Applied when its Git blob is 9d411ea388be683e3bfd56ad6d254091554299d8, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
     explicit minimum host headroom (the TEMP bound the evaluator does not check yet: DEC-07). Unknown fields, root
   ```
   with
   ```text
     explicit minimum host headroom (Temp Root at most 93 characters: DEC-07). Unknown fields, root
   ```

   b) replace the lines
   ```text
     temporary must exist, made when the workstream starts (refused: `SAVE_WORKSTREAM_FOLDER_MISSING`).
   - Every evidence path exists, absolute or relative to the checkout (refused: `SAVE_EVIDENCE_MISSING`).
   ```
   with
   ```text
     temporary is made by a save that also gives `-Plan`, after every check; without `-Plan` a missing folder is refused
     (`SAVE_WORKSTREAM_FOLDER_MISSING`), so a mistyped name writes nothing.
   - Every evidence path exists, absolute or relative to the checkout (refused: `SAVE_EVIDENCE_MISSING`); one string
     joined by commas is split into paths.
   ```

   c) replace the lines
   ```text
     exists (refused: `SAVE_VAULT_MISSING`). The status page renders from the plan file, `sb/W<NN>/PLAN.md` unless `-Plan`
     names another (refused: `SAVE_PLAN_MISSING`, or the `SAVE_PLAN_*` rule the plan breaks: an unbalanced code span, a
   ```
   with
   ```text
     exists (refused: `SAVE_VAULT_MISSING`). The status page renders from the plan file: `-Plan` when given (kept in
     `sb/W<NN>/plan.txt`), else `sb/W<NN>/PLAN.md`, that folder's `plan.txt`, then the previous workstream's `plan.txt`
     (refused: `SAVE_PLAN_MISSING`, or the `SAVE_PLAN_*` rule the plan breaks: an unbalanced code span, a
   ```

   The resulting file's Git blob is 9d411ea388be683e3bfd56ad6d254091554299d8.

6. Check whether `lib/hooks/Guard-Write.ps1` contains `# PreToolUse guard on PowerShell and Bash (DEC-28, guards.md G02): exits 2 when a command writes a single-writer file`; if so record Already Applied when its Git blob is 106e4fb2d30a05fc20fcc6b791defe392ed7f5aa, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) replace the lines
   ```text
   # PreToolUse guard on PowerShell and Bash (DEC-28, guards.md G02): exits 2 when a command names a single-writer file
   # together with a write verb, so the client refuses the call. The list is the file names of the Edit deny rules of
   # .claude/settings.json (G01). It catches accidents and is no security boundary: a script that opens a file it does not
   # name passes, and a crashed or timed-out hook does not block; Organize -Check catches what it misses. It errs toward
   # refusal: a read that also redirects elsewhere is refused too, so run that from the file's own tool.
   ```
   with
   ```text
   # PreToolUse guard on PowerShell and Bash (DEC-28, guards.md G02): exits 2 when a command writes a single-writer file
   # or redirects into a package\release folder, so the client refuses the call. The single-writer list is the file names
   # of the Edit deny rules of .claude/settings.json (G01). The command is split into segments on &&, ||, |, ; and line
   # breaks outside quotes and here-strings, and a segment is refused only when the name comes after a write verb in it, so a name inside a here-string or
   # a read argument passes. It catches accidents and is no security boundary: a script that opens a file it does not name
   # passes, and a crashed or timed-out hook does not block; Organize -Check catches what it misses. It errs toward
   # refusal: a copy or move that only reads the file is refused too, so run that from the file's own tool.
   ```

   b) immediately after the line
   ```text
   $writes='Set-Content|Add-Content|Clear-Content|Out-File|Tee-Object|Move-Item|Copy-Item|Remove-Item|Rename-Item|New-Item|\b(tee|mv|cp|rm|del|ren|sc|ac)\b|sed\s+-i|\[(System\.)?IO\.File\]::\s*(Write|Append|Move|Copy|Delete|Replace|Create|Open)|>'
   ```
   insert
   ```text
   # A file written into a package\release folder changes the hashed release (lesson release-log-inside-hashed-folder).
   $fills='Set-Content|Add-Content|Out-File|Tee-Object|\btee\b|\[(System\.)?IO\.File\]::\s*(Write|Append|Create)|>'
   ```

   c) replace the lines
   ```text
   if($plain-notmatch$writes){exit 0}
   foreach($name in $names){
       if($plain-match"(?<![\w.-])$([regex]::Escape($name))(?![\w.-])"){[Console]::Error.WriteLine("GUARD_SINGLE_WRITER: $name has one writer, so run that tool, not this command (DEC-28)");exit 2}
   ```
   with
   ```text
   # Separators inside quotes or here-strings do not split, so a quoted ; or | cannot part a write verb from its target.
   $segments=[Collections.Generic.List[string]]::new();$start=0
   foreach($m in [regex]::Matches($plain,'@''[\s\S]*?''@|@"[\s\S]*?"@|''[^'']*''|"(?:[^"`]|`.)*"|&&|\|\||\||;|\r?\n')){
       if($m.Value[0]-notin"'",'"','@'){$segments.Add($plain.Substring($start,$m.Index-$start));$start=$m.Index+$m.Length}
   }
   $segments.Add($plain.Substring($start))
   foreach($segment in $segments){
       $verb=[regex]::Match($segment,$writes,'IgnoreCase')
       if(!$verb.Success){continue}
       $after=$segment.Substring($verb.Index)
       foreach($name in $names){
           if($after-match"(?<![\w.-])$([regex]::Escape($name))(?![\w.-])"){[Console]::Error.WriteLine("GUARD_SINGLE_WRITER: $name has one writer, so run that tool, not this command (DEC-28)");exit 2}
       }
       $fill=[regex]::Match($segment,$fills,'IgnoreCase')
       if($fill.Success-and$segment.Substring($fill.Index)-match'package[\\/]+release(?![\w.-])'){[Console]::Error.WriteLine('GUARD_RELEASE_FOLDER: write logs outside package\release, which is hashed (lesson release-log-inside-hashed-folder)');exit 2}
   ```

   The resulting file's Git blob is 106e4fb2d30a05fc20fcc6b791defe392ed7f5aa.

7. Check whether `lib/Hunt.ps1` contains `$pwshProcs=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'")`; if so record Already Applied when its Git blob is 01874396476120db240e081a3fd7babd817b1f52, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) replace the lines
   ```text
   $follower=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'"|Where-Object{$_.CommandLine-match'Sync-Sessions\.ps1.*-Follow'})
   if($agents-and!$follower){Add-Finding BUG archiver-down 'agents are running but no Sync-Sessions -Follow process: sessions are not being preserved' 'archiver follower down sessions'}
   ```
   with
   ```text
   $pwshProcs=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'")
   $follower=@($pwshProcs|Where-Object{$_.CommandLine-match'Sync-Sessions\.ps1.*-Follow'})
   $unreadable=@($pwshProcs|Where-Object{!$_.CommandLine}).Count  # an elevated process hides its command line from an unelevated window
   if($agents-and!$follower-and$unreadable){Add-Finding GAP archiver-unverifiable "agents are running and $unreadable pwsh process(es) have an unreadable command line (elevated?): the Sync-Sessions -Follow archiver cannot be verified from this window" 'archiver follower unverifiable elevated'}
   elseif($agents-and!$follower){Add-Finding BUG archiver-down 'agents are running but no Sync-Sessions -Follow process: sessions are not being preserved' 'archiver follower down sessions'}
   ```

   The resulting file's Git blob is 01874396476120db240e081a3fd7babd817b1f52.

8. Check whether `lib/Invoke-ContractStage.ps1` contains `# Retired (optional paths the Draft deletes), Gh (owner/repo), GhUser (account for gh, optional), HoldNote (optional:`; if so record Already Applied when its Git blob is 404f28a7e0710771132e3abd996f08a33597b6d5, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   # Retired (optional paths the Draft deletes), Gh (owner/repo), GhUser (account for gh, optional).
   ```
   with
   ```text
   # Retired (optional paths the Draft deletes), Gh (owner/repo), GhUser (account for gh, optional), HoldNote (optional:
   # a sentence the approve and implement entries end with; absent means none).
   ```

   b) immediately after the line
   ```text
   $cfg=Import-PowerShellDataFile $Config
   ```
   insert
   ```text
   $holdNote=if($cfg.HoldNote){' '+$cfg.HoldNote}else{''}
   ```

   c) replace the line
   ```text
       $t=Add-StageEntry $t 'Verification Notes' ("### $(Get-Date -Format yyyy-MM-dd) — Gate 1 approval recorded${nl}${nl}$($cfg.ApprovalNote) Immediately before allocation the hash, the Draft blob $($cfg.Blob), all $n source anchors, the baseline HEAD $($cfg.Main) against refreshed origin/main $om and a clean checkout were revalidated, and the pre-commit allocator admitted the identity; Draft allocated as $($alloc.Substring(0,7)). No implementation performed before this transition. Batch 6 remains ON HOLD; CTRL-19 remains OPEN.")
   ```
   with
   ```text
       $t=Add-StageEntry $t 'Verification Notes' ("### $(Get-Date -Format yyyy-MM-dd) — Gate 1 approval recorded${nl}${nl}$($cfg.ApprovalNote) Immediately before allocation the hash, the Draft blob $($cfg.Blob), all $n source anchors, the baseline HEAD $($cfg.Main) against refreshed origin/main $om and a clean checkout were revalidated, and the pre-commit allocator admitted the identity; Draft allocated as $($alloc.Substring(0,7)). No implementation performed before this transition.$holdNote")
   ```

   d) replace the line
   ```text
       $lines+="- Step $($i+1) Applied: generator rerun, ``generate-ai-map.ps1 -Check`` exit 0, the staged change names only Write Scope paths. Every edit was applied literally from this contract's steps and its Git blob checked before commit. Fresh timed and watched Finish, independent Review, Complete and candidate binding remain. Batch 6 remains ON HOLD; CTRL-19 remains OPEN."
   ```
   with
   ```text
       $lines+="- Step $($i+1) Applied: generator rerun, ``generate-ai-map.ps1 -Check`` exit 0, the staged change names only Write Scope paths. Every edit was applied literally from this contract's steps and its Git blob checked before commit. Fresh timed and watched Finish, independent Review, Complete and candidate binding remain.$holdNote"
   ```

   The resulting file's Git blob is 404f28a7e0710771132e3abd996f08a33597b6d5.

9. Check whether `lib/Organize.ps1` contains `if((($prose-and$at-cnotlike'data:claude-memory/*')-or$named.Groups[1].Value-cmatch'\.\w+$')-and!(Test-OrganizeNamedPath $named.Groups[1].Value)){"BROKEN_PATH $at $($named.Groups[1].Value.TrimEnd('.'))"}`; if so record Already Applied when its Git blob is 9c96086677bb0dd1a4b7a8963474d6a45861c9fc, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
                   if(($prose-or$named.Groups[1].Value-cmatch'\.\w+$')-and!(Test-OrganizeNamedPath $named.Groups[1].Value)){"BROKEN_PATH $at $($named.Groups[1].Value.TrimEnd('.'))"}
   ```
   with
   ```text
                   if((($prose-and$at-cnotlike'data:claude-memory/*')-or$named.Groups[1].Value-cmatch'\.\w+$')-and!(Test-OrganizeNamedPath $named.Groups[1].Value)){"BROKEN_PATH $at $($named.Groups[1].Value.TrimEnd('.'))"}
   ```

   The resulting file's Git blob is 9c96086677bb0dd1a4b7a8963474d6a45861c9fc.

10. Check whether `lib/Save-State.ps1` contains `$source=Join-Path $item.DirectoryName 'PLAN.md';$store=Join-Path $item.DirectoryName 'plan.txt'`; if so record Already Applied when its Git blob is dd4647ef4b6438077384020f3468f50f6d81d35e, and otherwise stop and report. Otherwise make exactly these 8 edits (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
           $source=Join-Path $item.DirectoryName 'PLAN.md'
   ```
   with
   ```text
           $source=Join-Path $item.DirectoryName 'PLAN.md';$store=Join-Path $item.DirectoryName 'plan.txt'
           if(!(Test-Path -LiteralPath $source)-and(Test-Path -LiteralPath $store)){$source=[IO.File]::ReadAllText($store).Trim()}
   ```

   b) replace the line
   ```text
   if(!$Workstream){if($old-cmatch '^# NOW (WS-\d{3})\n'){$Workstream=$Matches[1]}else{throw 'SAVE_WORKSTREAM_REQUIRED'}}
   ```
   with
   ```text
   $previousWorkstream=if($old-cmatch '^# NOW (WS-\d{3})\n'){$Matches[1]}else{''}
   if(!$Workstream){if($previousWorkstream){$Workstream=$previousWorkstream}else{throw 'SAVE_WORKSTREAM_REQUIRED'}}
   ```

   c) replace the lines
   ```text
   $folder=[IO.Path]::Combine($Temporary,'sb','W'+[int]$Workstream.Substring(3))
   if(!(Test-Path -LiteralPath $folder -PathType Container)){throw "SAVE_WORKSTREAM_FOLDER_MISSING: $folder"}
   ```
   with
   ```text
   function Get-WorkstreamFolder([string]$Id){[IO.Path]::Combine($Temporary,'sb','W'+[int]$Id.Substring(3))}
   $folder=Get-WorkstreamFolder $Workstream
   # A new workstream's folder is made only with an explicit -Plan and only after every check, so a mistyped name writes nothing.
   $newFolder=!(Test-Path -LiteralPath $folder -PathType Container)
   if($newFolder-and!$Plan){throw "SAVE_WORKSTREAM_FOLDER_MISSING: $folder; give -Plan to start it"}
   # One -Evidence string joined by commas is split (ceiling: a path with a comma in it cannot be given).
   $Evidence=@($Evidence|ForEach-Object{$_-split','}|ForEach-Object{$_.Trim()}|Where-Object{$_})
   ```

   d) replace the line
   ```text
   if(!$Plan){$Plan=Join-Path $folder 'PLAN.md'}
   ```
   with
   ```text
   # A given -Plan is remembered in the folder's plan.txt. Without one: the folder's PLAN.md, its plan.txt, then the
   # previous workstream's plan.txt.
   $planGiven=[bool]$Plan
   if(!$Plan){
       $Plan=Join-Path $folder 'PLAN.md'
       $stores=@((Join-Path $folder 'plan.txt'))+@(if($previousWorkstream){Join-Path (Get-WorkstreamFolder $previousWorkstream) 'plan.txt'})
       if(!(Test-Path -LiteralPath $Plan)){foreach($store in $stores){if(Test-Path -LiteralPath $store -PathType Leaf){$Plan=[IO.File]::ReadAllText($store).Trim();break}}}
   }
   ```

   e) immediately after the line
   ```text
   if(!(Test-Path -LiteralPath $Plan -PathType Leaf)){throw "SAVE_PLAN_MISSING: $Plan"}
   ```
   insert
   ```text
   $Plan=(Get-Item -LiteralPath $Plan).FullName
   ```

   f) immediately after the line
   ```text
   [void][IO.Directory]::CreateDirectory((Split-Path $nowPath -Parent))
   ```
   insert
   ```text
   if($newFolder){[void][IO.Directory]::CreateDirectory($folder)}
   if($planGiven){[IO.File]::WriteAllText((Join-Path $folder 'plan.txt'),$Plan,$utf8)}
   ```

   g) replace the line
   ```text
   if(!(Test-Path -LiteralPath $continuity)-and(Test-Path -LiteralPath $previous)){[IO.Directory]::Move($previous,$continuity)}
   ```
   with
   ```text
   # OneDrive can hold a vault file for a moment: each folder move is tried 5 times, 2 s apart, only on IOException or
   # UnauthorizedAccessException, then the error stands (DEC-33 rule 8: bounded, fail closed).
   function Move-Folder([string]$From,[string]$To){
       for($attempt=1;;$attempt++){
           try{[IO.Directory]::Move($From,$To);return}
           catch [IO.IOException],[UnauthorizedAccessException]{if($attempt-ge5){throw};Start-Sleep -Seconds 2}
       }
   }
   if(!(Test-Path -LiteralPath $continuity)-and(Test-Path -LiteralPath $previous)){Move-Folder $previous $continuity}
   ```

   h) replace the lines
   ```text
   if(Test-Path -LiteralPath $continuity){[IO.Directory]::Move($continuity,$previous)}
   [IO.Directory]::Move($stage,$continuity)
   ```
   with
   ```text
   if(Test-Path -LiteralPath $continuity){Move-Folder $continuity $previous}
   Move-Folder $stage $continuity
   ```

   The resulting file's Git blob is dd4647ef4b6438077384020f3468f50f6d81d35e.

11. Check whether `lib/test-hunt.ps1` contains `# An unreadable pwsh command line (an elevated archiver) is a GAP, a missing follower with readable lines stays a BUG.`; if so record Already Applied when its Git blob is de9c0ec240fdac480cb4d07dd95c5dfe76dbd5bf, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
           try{Assert-That 'G15 no client has nothing to probe' ((Invoke-RecordHunt).out-cnotmatch'guard-probe-stale')}finally{$env:PATH=$savedPath}
   ```
   insert
   ```text
           # An unreadable pwsh command line (an elevated archiver) is a GAP, a missing follower with readable lines stays a BUG.
           $arch=Join-Path $t 'archiver-probe.ps1'
           foreach($case in @(@('unreadable','$null','GAP archiver-unverifiable','BUG archiver-down'),@('readable','''pwsh other.ps1''','BUG archiver-down','GAP archiver-unverifiable'))){
               [IO.File]::WriteAllText($arch,"param([string]`$Hunt,[string]`$Store)`nfunction Get-Process { [pscustomobject]@{Name='claude'} }`nfunction Get-CimInstance { [pscustomobject]@{CommandLine=$($case[1])} }`n& `$Hunt -Root `$Store -DataRoot `$Store -Quick -NoRecord`n")
               $o=(@(& pwsh -NoProfile -File $arch -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $store 2>&1|ForEach-Object{"$_"})-join"`n")
               Assert-That "archiver with an $($case[0]) command line reports $($case[2]) only" ($o-cmatch$case[2]-and$o-cnotmatch$case[3])
           }
   ```

   The resulting file's Git blob is de9c0ec240fdac480cb4d07dd95c5dfe76dbd5bf.

12. Check whether `lib/test-native-stage.ps1` contains `Assert-Stage 'implement entry has no hold sentence without HoldNote' (!([IO.File]::ReadAllText((Join-Path $positive.Root 'changes/SPEC-1-probe.md')).Contains('ON HOLD')))`; if so record Already Applied when its Git blob is d5c0b7022da2201953f9f3abfee58c8e7182defd, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       Assert-Stage 'no invented model/coauthor attribution enters actual commits' ($messages-notmatch'Claude|Anthropic|Co-Authored-By')
   ```
   insert
   ```text
       Assert-Stage 'implement entry has no hold sentence without HoldNote' (!([IO.File]::ReadAllText((Join-Path $positive.Root 'changes/SPEC-1-probe.md')).Contains('ON HOLD')))
   ```

   b) immediately after the line
   ```text
           $approval=New-ApprovalFixture ('approval-'+$evidence.Replace(' ','-')) $evidence
   ```
   insert
   ```text
           # HoldNote is optional: the PASS fixture has none and its entry ends at the transition sentence.
           if($evidence-eq'NOT APPLICABLE'){[IO.File]::WriteAllText($approval.Config,[IO.File]::ReadAllText($approval.Config).Replace("ApprovalNote='synthetic only'}","ApprovalNote='synthetic only';HoldNote='Toy hold stays.'}"))}
   ```

   c) replace the line
   ```text
           Assert-Stage "actual approval caller respects native applicability $evidence" ($approved.Exit-eq0-and[IO.File]::ReadAllText((Join-Path $approval.Root 'changes/SPEC-1-probe.md')).Contains('[x] Approved')) $approved.Output
   ```
   with
   ```text
           $approvedText=[IO.File]::ReadAllText((Join-Path $approval.Root 'changes/SPEC-1-probe.md'))
           Assert-Stage "actual approval caller respects native applicability $evidence" ($approved.Exit-eq0-and$approvedText.Contains('[x] Approved')) $approved.Output
           $held=$approvedText.Contains('before this transition. Toy hold stays.')
           Assert-Stage "approval entry carries the configured HoldNote only ($evidence)" ($approvedText.Contains('before this transition.')-and$held-eq($evidence-eq'NOT APPLICABLE')-and!$approvedText.Contains('ON HOLD'))
   ```

   The resulting file's Git blob is d5c0b7022da2201953f9f3abfee58c8e7182defd.

13. Check whether `lib/test-organize.ps1` contains `$memo=Join-Path $data 'claude-memory\m.md';Add-File $memo 'see data/trigger/function/view and temporary/reversible and docs/gone-x.md';$checked=Invoke-Tool -Check;Assert-That 'memory prose without an extension is no path, a missing .md in memory still is' ($checked.Text-cnotmatch'BROKEN_PATH data:claude-memory/m\.md data/trigger'-and$checked.Text-cnotmatch'BROKEN_PATH data:claude-memory/m\.md temporary/reversible'-and$checked.Text-cmatch'(?m)^BROKEN_PATH data:claude-memory/m\.md docs/gone-x\.md$');[IO.File]::Delete($memo);[IO.Directory]::Delete((Split-Path $memo -Parent))`; if so record Already Applied when its Git blob is 41fb919b9dae5be7142d193fe52c15aef2c8777f, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
       foreach($write in "Set-Content $doc x","set-content $doc x","Add-Content $doc x","Clear-Content $doc","x | Out-File $doc","x | Tee-Object $doc","Move-Item a $doc","Copy-Item a $doc","Remove-Item $doc","Rename-Item $doc b","New-Item $doc","echo x > $doc","echo x >> $doc","mv a $doc","cp a $doc","rm $doc","tee $doc","sed -i s/a/b/ $doc","[IO.File]::WriteAllText('$doc','x')","[System.IO.File]::AppendAllText('$doc','x')","[IO.File]::Delete('$doc')","echo x > a 2>&1; Set-Content docs/history/LOG.tsv x","Set-Content ai-map.json x"){
   ```
   with
   ```text
       foreach($write in "Set-Content $doc x","set-content $doc x","Add-Content $doc x","Clear-Content $doc","x | Out-File $doc","x | Tee-Object $doc","Move-Item a $doc","Copy-Item a $doc","Remove-Item $doc","Rename-Item $doc b","New-Item $doc","echo x > $doc","echo x >> $doc","mv a $doc","cp a $doc","rm $doc","tee $doc","sed -i s/a/b/ $doc","[IO.File]::WriteAllText('$doc','x')","[System.IO.File]::AppendAllText('$doc','x')","[IO.File]::Delete('$doc')","echo x > a 2>&1; Set-Content docs/history/LOG.tsv x","Set-Content ai-map.json x","Set-Content -Value 'a;b' -Path $doc","Set-Content -Value `"a|b`" -Path $doc","Set-Content -Value @'`nx | y`n'@ -Path $doc","echo x | Out-File out/package/release/run.log","pwsh -File a.ps1 > C:\x\package\release\run.log","Get-Content a && Add-Content x\package\release\b.txt y"){
   ```

   b) replace the line
   ```text
       foreach($read in "Get-Content $doc","cat $doc","git log -- $doc","git status 2>&1 | Select-String $doc","Get-Content $doc 2>`$null","cat $doc 2> /dev/null","`$x=`$a.b -> $doc","Set-Content NOW.md.bak x","Set-Content MY-NOW.md x","Set-Content free.txt x"){
   ```
   with
   ```text
       foreach($read in "Get-Content $doc","cat $doc","git log -- $doc","git status 2>&1 | Select-String $doc","Get-Content $doc 2>`$null","cat $doc 2> /dev/null","`$x=`$a.b -> $doc","Set-Content NOW.md.bak x","Set-Content MY-NOW.md x","Set-Content free.txt x","Get-Content $doc > out.txt","Get-Content $doc | Set-Content copy.txt","@'`nnotes on $doc`n'@ | Set-Content notes.txt","Get-Content out\package\release\manifest.json","Get-Content out\package\release\a.txt > log.txt"){
   ```

   c) immediately after the line
   ```text
       Assert-TextPasses 'a pattern, a variable, a records path of either place and a dropped .md pass' $runbook 'sb/W<NN>/ docs/W<NN>-x.md lib/$name.ps1 data/records/* records/old-folder/deep/a.txt data/records/old-folder/deep/a.txt lib/README ORVION-Workbench-temporary/tmp/README.md temporary/tmp/README.md'
   ```
   insert
   ```text
       $memo=Join-Path $data 'claude-memory\m.md';Add-File $memo 'see data/trigger/function/view and temporary/reversible and docs/gone-x.md';$checked=Invoke-Tool -Check;Assert-That 'memory prose without an extension is no path, a missing .md in memory still is' ($checked.Text-cnotmatch'BROKEN_PATH data:claude-memory/m\.md data/trigger'-and$checked.Text-cnotmatch'BROKEN_PATH data:claude-memory/m\.md temporary/reversible'-and$checked.Text-cmatch'(?m)^BROKEN_PATH data:claude-memory/m\.md docs/gone-x\.md$');[IO.File]::Delete($memo);[IO.Directory]::Delete((Split-Path $memo -Parent))
   ```

   The resulting file's Git blob is 41fb919b9dae5be7142d193fe52c15aef2c8777f.

14. Check whether `lib/test-save-state.ps1` contains `# Get-Item expands a short (8.3) TEMP such as C:\Users\MYLAB~1 to the long names Save-State's -Check prints.`; if so record Already Applied when its Git blob is fef3415696c420753dafece0bcfde293d99fee4d, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   if(![IO.Path]::IsPathFullyQualified($parent)){throw 'SAVE_TEST_ROOT_REQUIRED'}
   ```
   insert
   ```text
   # Get-Item expands a short (8.3) TEMP such as C:\Users\MYLAB~1 to the long names Save-State's -Check prints.
   [void][IO.Directory]::CreateDirectory($parent);$parent=(Get-Item -LiteralPath $parent).FullName
   ```

   b) immediately after the line
   ```text
           try{$null=Invoke-Save $f $first $injected}finally{Assert-Save ((Test-Path -LiteralPath $kept)-and!(Test-Path -LiteralPath (Join-Path $f.Vault 'continuity.old'))-and[IO.File]::ReadAllText($kept)-ceq'last whole copy') 'the leftover continuity.old was not restored'}})
   ```
   insert
   ```text
       planStore=@('',{$f=New-SaveFixture 'store';$plan=Join-Path $f.Temporary 'PLAN-elsewhere.md';[IO.File]::WriteAllText($plan,$planText)
           $null=Invoke-Save $f @{Workstream='WS-034';Plan=$plan};$w34=[IO.Path]::Combine($f.Temporary,'sb','W34')
           Assert-Save ([IO.File]::ReadAllText((Join-Path $w34 'plan.txt'))-ceq$plan) 'a given plan starts a new workstream folder and is remembered'
           $null=Invoke-Save $f @{Operation='op 2'}
           Assert-Save (@((Get-SaveText $f '../W34/LOG.md').Split($nl)|Where-Object{$_.StartsWith('- ')}).Count-eq2) 'the remembered plan serves the next save'
           [void][IO.Directory]::CreateDirectory([IO.Path]::Combine($f.Temporary,'sb','W35'));$null=Invoke-Save $f @{Workstream='WS-035'}
           Assert-Save (Test-Path -LiteralPath ([IO.Path]::Combine($f.Temporary,'sb','W35','status.html'))) 'the previous workstream plan serves a folder without one'})
       evidenceSplit=@('',{$f=New-SaveFixture 'split';$null=Invoke-Save $f ($first+@{Evidence=@('lib/README.md, lib/Save-State.ps1')})
           Assert-Save ((Get-SaveText $f 'NOW').Contains("Evidence:$nl- lib/README.md$nl- lib/Save-State.ps1$nl")) 'a comma-joined Evidence string is split'})
       moveRetry=@('',{$f=New-SaveFixture 'retry';$null=Invoke-Save $f $first;$held=Join-Path $f.Vault 'continuity/data/work/NOW.md'
           # A child process holds one file of the continuity copy open, as OneDrive does, for the seconds given.
           $hold={param([int]$Seconds)$ready=Join-Path $scratch ('held-'+[guid]::NewGuid().ToString('N'))
               $child=Start-Process pwsh -PassThru -WindowStyle Hidden -ArgumentList @('-NoProfile','-Command',"`$s=[IO.File]::Open('$held','Open','Read','Read');[IO.File]::WriteAllText('$ready','');Start-Sleep -Seconds $Seconds;`$s.Dispose()")
               while(!(Test-Path -LiteralPath $ready)){if($child.HasExited){throw 'SAVE_TEST_HOLD_FAILED'};Start-Sleep -Milliseconds 100};$child}
           $child=& $hold 3;try{$null=Invoke-Save $f @{Operation='op 2'}}finally{$child.WaitForExit()}
           Assert-Save ([IO.File]::ReadAllText($held).Contains('op 2')) 'held for 3 s, the save waits and completes'
           $whole=(Get-FileHash -LiteralPath $held).Hash;$failed=$false;$child=& $hold 15
           try{$null=Invoke-Save $f @{Operation='op 3'}}catch{$failed=$true}finally{$child.WaitForExit()}
           Assert-Save ($failed-and(Get-FileHash -LiteralPath $held).Hash-ceq$whole) 'held past five tries, the save fails and continuity stays whole'})
   ```

   c) replace the line
   ```text
               folderMissing='throw "SAVE_WORKSTREAM_FOLDER_MISSING: $folder"';evidenceMissing='throw "SAVE_EVIDENCE_MISSING: $path"'
   ```
   with
   ```text
               folderMissing='throw "SAVE_WORKSTREAM_FOLDER_MISSING: $folder; give -Plan to start it"';evidenceMissing='throw "SAVE_EVIDENCE_MISSING: $path"'
   ```

   d) replace the line
   ```text
               continuityRestore='if(!(Test-Path -LiteralPath $continuity)-and(Test-Path -LiteralPath $previous)){[IO.Directory]::Move($previous,$continuity)}'
   ```
   with
   ```text
               continuityRestore='if(!(Test-Path -LiteralPath $continuity)-and(Test-Path -LiteralPath $previous)){Move-Folder $previous $continuity}'
               planStore='$Plan=[IO.File]::ReadAllText($store).Trim();break'
               evidenceSplit='$Evidence=@($Evidence|ForEach-Object{$_-split'',''}|ForEach-Object{$_.Trim()}|Where-Object{$_})'
               moveRetry='Start-Sleep -Seconds 2'
   ```

   The resulting file's Git blob is fef3415696c420753dafece0bcfde293d99fee4d.

15. Check whether `lib/test-workbench-governance.ps1` contains `# The fixture Temp Root sits beside the owned root: under it, it would exceed the 93-character Temp Root bound.`; if so record Already Applied when its Git blob is 64c797acd2f1dab99cd5875653fb0002a1eb6342, and otherwise stop and report. Otherwise make exactly these 6 edits (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   [void][IO.Directory]::CreateDirectory($ownedRoot)
   ```
   insert
   ```text
   # The fixture Temp Root sits beside the owned root: under it, it would exceed the 93-character Temp Root bound.
   $fixtureTemp=Join-Path $testParent ('wbt'+$ownedRoot.Substring($ownedRoot.Length-8))
   ```

   b) immediately after the line
   ```text
       Assert-Fixture 'CI recipe binds full candidate, ordered tests, runtime and evaluator inputs' ($ciRecipe.Material.candidate-ceq$ciHead-and$ciRecipe.Material.schedule.tests.Count-eq1-and@($ciRecipe.Material.schedule.inputs|Where-Object{$_.Path-ceq'lib/Test-WorkbenchChange.ps1'}).Count-eq1)
   ```
   insert
   ```text
       Assert-Fixture 'CI context keeps no RAM floor (owner 2026-11-07)' ($ciRecipe.Context['Minimum Physical GB']-ceq'0.001'-and$ciRecipe.Context['Minimum Commit GB']-ceq'0.001')
   ```

   c) replace the lines
   ```text
       try{Test-CICapability}catch{$failures++;"FAIL CI fixture: $($_.Exception.Message)"}
       if($env:WORKBENCH_TEST_EVIDENCE){Write-FixtureFile $env:WORKBENCH_TEST_EVIDENCE ($observations|ConvertTo-Json -Depth 7)}
       if($failures-eq0){$null=Remove-OrvionOwnedTree $ownedRoot @($testParent)}else{"PRESERVED_FIXTURES: $ownedRoot"}
   ```
   with
   ```text
       try{Test-CICapability}catch{$failures++;"FAIL CI fixture: $($_.Exception.Message)"}
       if($env:WORKBENCH_TEST_EVIDENCE){Write-FixtureFile $env:WORKBENCH_TEST_EVIDENCE ($observations|ConvertTo-Json -Depth 7)}
       if($failures-eq0){$null=Remove-OrvionOwnedTree $ownedRoot @($testParent);$null=Remove-OrvionOwnedTree $fixtureTemp @($testParent)}else{"PRESERVED_FIXTURES: $ownedRoot $fixtureTemp"}
   ```

   d) replace the line
   ```text
   Temp Root: $(Join-Path $ownedRoot 'execution-temp')
   ```
   with
   ```text
   Temp Root: $fixtureTemp
   ```

   e) immediately after the line
   ```text
       Assert-Fixture 'recipe retains the existing Windows uppercase-extension test discovery' (@($discoveryRecipe.Material.tests)-ccontains'lib/test-case-extension.PS1')
   ```
   insert
   ```text
       # DEC-07 selection (WS-034), in its own small repository so the always-on, owning and unowned cases are exact.
       $selRoot=Join-Path $ownedRoot 'selection';[void][IO.Directory]::CreateDirectory($selRoot)
       $null=Invoke-FixtureGit $selRoot @('init','--quiet')
       foreach($setting in @(@('user.name','Fixture'),@('user.email','fixture@invalid.local'),@('core.hooksPath','.git/hooks'),@('core.autocrlf','true'))){$null=Invoke-FixtureGit $selRoot @('config','--local',$setting[0],$setting[1])}
       foreach($relative in 'tests.ps1','lib/Workbench.ps1','lib/run_timed.ps1','lib/Events.ps1','lib/Hunt.ps1'){Write-FixtureFile (Join-Path $selRoot $relative) ('# fixture'+[char]10)}
       foreach($pair in @(@('lib/test-workbench-governance.ps1','# always-on'),@('lib/test-save-state.ps1','# owns Save-State.ps1'),@('lib/test-other.ps1','# owns Other.ps1'))){Write-FixtureFile (Join-Path $selRoot $pair[0]) ($pair[1]+[char]10)}
       $null=Invoke-FixtureGit $selRoot @('add','.')
       $null=Invoke-FixtureGit $selRoot @('commit','--quiet','-m','Selection fixture')
       $selHead=(Invoke-FixtureGit $selRoot @('rev-parse','HEAD')).Output[0]
       $selContext=(Get-WorkbenchFields $text).Sections['Execution Context']
       $selCIRuntime=Join-Path $testParent ('cs-'+[guid]::NewGuid().ToString('N').Substring(0,8))
       $selFull='lib/test-other.ps1,lib/test-save-state.ps1,lib/test-workbench-governance.ps1'
       $selectFor={param([string[]]$Scope)(@((Get-WorkbenchRecipe $selRoot $selHead ([pscustomobject]@{Sections=@{'Execution Context'=$selContext;'Write Scope'=(@($Scope|ForEach-Object{'- '+$_})-join[char]10)}})).Material.tests)-join',')}
       $selectCI={(@((Get-WorkbenchCIRecipe $selRoot $selHead $selCIRuntime).Material.schedule.tests)-join',')}
       Assert-Fixture 'selection runs the always-on tests plus the owner of a scoped path' ((& $selectFor @('RESUME.md','lib/Save-State.ps1','docs/notes.md'))-ceq'lib/test-save-state.ps1,lib/test-workbench-governance.ps1')
       Assert-Fixture 'selection runs everything for a scoped script no test names' ((& $selectFor @('RESUME.md','lib/Unowned.ps1'))-ceq$selFull)
       Assert-Fixture 'selection runs everything for a control path' ((& $selectFor @('lib/Save-State.ps1','tests.ps1'))-ceq$selFull)
       Assert-Fixture 'CI runs the full schedule' ((& $selectCI)-ceq$selFull)
       # Temp Root at most 93 (TEMP is Temp Root\tmp, at most 97); Tests Root at most 101 (the range probe). Both sides.
       $drive=[IO.Path]::GetPathRoot($testParent)
       $contextAt={param([int]$Tests,[int]$Temp)
           $body=[regex]::Replace($selContext,'(?m)^Tests Root: [^\n]+$',('Tests Root: '+$drive+('t'*($Tests-$drive.Length))))
           $body=[regex]::Replace($body,'(?m)^Temp Root: [^\n]+$',('Temp Root: '+$drive+('m'*($Temp-$drive.Length))))
           try{$null=Get-WorkbenchContext ([pscustomobject]@{Sections=@{'Execution Context'=$body}});'ACCEPTED'}catch{'THREW '+$_.Exception.Message}}
       $tooLong='THREW WB_CONTEXT_FIXTURE_PATH_TOO_LONG'
       Assert-Fixture 'context accepts a 101-character Tests Root and a 93-character Temp Root' ((& $contextAt 101 93)-ceq'ACCEPTED')
       Assert-Fixture 'context refuses a 102-character Tests Root' ((& $contextAt 102 93)-ceq$tooLong)
       Assert-Fixture 'context refuses a 94-character Temp Root' ((& $contextAt 101 94)-ceq$tooLong)
       # Mutants: each copy of the evaluator is dot-sourced into a child scope only, and the probe must see a different result.
       $checkerSource=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Test-WorkbenchChange.ps1'))
       $mutantPath=Join-Path $ownedRoot 'evaluator-mutant.ps1'
       foreach($mutant in @(
           @('selection without the fail-closed branch',"if(!`$owners.Count-and`$path-match'\.(ps1|psm1|mjs|js|json)`$'){return `$tests}",'',{& $selectFor @('RESUME.md','lib/Unowned.ps1')},$selFull),
           @('CI without the full schedule','$record -FullSchedule','$record',$selectCI,$selFull),
           @('Temp Root bound off by one','-gt93){','-gt94){',{& $contextAt 101 94},$tooLong))){
           $observed=if(!$checkerSource.Contains($mutant[1])){'MUTANT_ANCHOR_MISSING'}else{
               Write-FixtureFile $mutantPath $checkerSource.Replace($mutant[1],$mutant[2])
               try{& {. $mutantPath;& $mutant[3]}}catch{'THREW '+$_.Exception.Message}}
           Assert-Fixture ('mutant killed: '+$mutant[0]) ($observed-cne'MUTANT_ANCHOR_MISSING'-and$observed-cne$mutant[4]) $observed
       }
   ```

   f) replace the line
   ```text
       if($failures-eq0){$null=Remove-OrvionOwnedTree $ownedRoot @($testParent)}else{"PRESERVED_FIXTURES: $ownedRoot"}
   ```
   with
   ```text
       if($failures-eq0){$null=Remove-OrvionOwnedTree $ownedRoot @($testParent);$null=Remove-OrvionOwnedTree $fixtureTemp @($testParent)}else{"PRESERVED_FIXTURES: $ownedRoot $fixtureTemp"}
   ```

   The resulting file's Git blob is 64c797acd2f1dab99cd5875653fb0002a1eb6342.

16. Check whether `lib/Test-WorkbenchChange.ps1` contains `# TEMP is Temp Root\tmp, and a TEMP over 97 characters breaks the backup round trip (event evaluator-temp-unbounded).`; if so record Already Applied when its Git blob is e0bf56b4f3dd2f444120bcb96af24f1538b314ea, and otherwise stop and report. Otherwise make exactly these 5 edits (land this exact frozen WS-034 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       if($rangeProbe.Length-ge260){throw 'WB_CONTEXT_FIXTURE_PATH_TOO_LONG'}
   ```
   insert
   ```text
       # TEMP is Temp Root\tmp, and a TEMP over 97 characters breaks the backup round trip (event evaluator-temp-unbounded).
       if($context['Temp Root'].Length-gt93){throw 'WB_CONTEXT_FIXTURE_PATH_TOO_LONG'}
   ```

   b) replace the line
   ```text
   function Get-WorkbenchRecipe([string]$Checkout,[string]$tree,$record) {
   ```
   with
   ```text
   # DEC-07: a Finish runs the always-on tests plus every test that owns a scoped path (the test itself is scoped, or its
   # text names the path's leaf). A CONTROL path, or a scoped script that no test names, runs the whole schedule. RESUME.md
   # is in every scope, so it neither selects nor forces anything.
   function Select-WorkbenchTests([string]$Checkout,[string]$tree,$record,[string[]]$tests) {
       $scope=@(Get-WorkbenchScope $record|Where-Object{$_-cne'RESUME.md'})
       if((Get-WorkbenchProfiles $scope)-contains'CONTROL'){return $tests}
       $alwaysOn='lib/test-workbench-governance.ps1','lib/test-markdown-consistency.ps1','lib/test-workspace-layout.ps1'
       $chosen=[Collections.Generic.HashSet[string]]::new([string[]]@($tests|Where-Object{$_-cin$alwaysOn}))
       $text=@{};foreach($test in $tests){$text[$test]=Get-WorkbenchText $Checkout $tree $test}
       foreach($path in $scope){
           $leaf=Split-Path $path -Leaf
           $owners=@($tests|Where-Object{$_-ceq$path-or$text[$_].IndexOf($leaf,[StringComparison]::OrdinalIgnoreCase)-ge0})
           if(!$owners.Count-and$path-match'\.(ps1|psm1|mjs|js|json)$'){return $tests}
           foreach($owner in $owners){[void]$chosen.Add($owner)}
       }
       @($tests|Where-Object{$chosen.Contains($_)})
   }
   function Get-WorkbenchRecipe([string]$Checkout,[string]$tree,$record,[switch]$FullSchedule) {
   ```

   c) immediately after the line
   ```text
       if(!$tests.Count-or$files-cnotcontains'tests.ps1'){throw 'WB_RECIPE_TEST_SCHEDULE_MISSING'}
   ```
   insert
   ```text
       if(!$FullSchedule){$tests=@(Select-WorkbenchTests $Checkout $tree $record $tests)}
   ```

   d) replace the line
   ```text
           'PowerShell Version'=$PSVersionTable.PSVersion.ToString();'Git Version'=@(Invoke-WorkbenchGit $Checkout @('--version'))[0];'Minimum Physical GB'='1.5';'Minimum Commit GB'='3'}
   ```
   with
   ```text
           'PowerShell Version'=$PSVersionTable.PSVersion.ToString();'Git Version'=@(Invoke-WorkbenchGit $Checkout @('--version'))[0];'Minimum Physical GB'='0.001';'Minimum Commit GB'='0.001'}
   ```

   e) replace the line
   ```text
       $baseRecipe=Get-WorkbenchRecipe $Checkout $Candidate $record
   ```
   with
   ```text
       # GitHub runs every test before main moves (DEC-07); the record has no Write Scope, so a missing switch throws.
       $baseRecipe=Get-WorkbenchRecipe $Checkout $Candidate $record -FullSchedule
   ```

   The resulting file's Git blob is e0bf56b4f3dd2f444120bcb96af24f1538b314ea.

## Acceptance Criteria

- [x] Output `changes/README.md` equals its declared resulting Git blob. check: blob:changes/README.md=c15ccb947a52faae9d20e333d48135a025d0e8fa
- [x] Output `docs/DECISIONS.md` equals its declared resulting Git blob. check: blob:docs/DECISIONS.md=1dda22e02fe59f1cc1b1614bf6f8a06b03b5e6fb
- [x] Output `docs/history/DECISIONS-ARCHIVE.md` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-ARCHIVE.md=5c4fe5518afb83d03257966240ed8663266f67cd
- [x] Output `docs/history/DECISIONS-MAP.tsv` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-MAP.tsv=8f77de1deb6736cf2d52b38e1020d337bda34910
- [x] Output `docs/RUNBOOK.md` equals its declared resulting Git blob. check: blob:docs/RUNBOOK.md=9d411ea388be683e3bfd56ad6d254091554299d8
- [x] Output `lib/hooks/Guard-Write.ps1` equals its declared resulting Git blob. check: blob:lib/hooks/Guard-Write.ps1=106e4fb2d30a05fc20fcc6b791defe392ed7f5aa
- [x] Output `lib/Hunt.ps1` equals its declared resulting Git blob. check: blob:lib/Hunt.ps1=01874396476120db240e081a3fd7babd817b1f52
- [x] Output `lib/Invoke-ContractStage.ps1` equals its declared resulting Git blob. check: blob:lib/Invoke-ContractStage.ps1=404f28a7e0710771132e3abd996f08a33597b6d5
- [x] Output `lib/Organize.ps1` equals its declared resulting Git blob. check: blob:lib/Organize.ps1=9c96086677bb0dd1a4b7a8963474d6a45861c9fc
- [x] Output `lib/Save-State.ps1` equals its declared resulting Git blob. check: blob:lib/Save-State.ps1=dd4647ef4b6438077384020f3468f50f6d81d35e
- [x] Output `lib/test-hunt.ps1` equals its declared resulting Git blob. check: blob:lib/test-hunt.ps1=de9c0ec240fdac480cb4d07dd95c5dfe76dbd5bf
- [x] Output `lib/test-native-stage.ps1` equals its declared resulting Git blob. check: blob:lib/test-native-stage.ps1=d5c0b7022da2201953f9f3abfee58c8e7182defd
- [x] Output `lib/test-organize.ps1` equals its declared resulting Git blob. check: blob:lib/test-organize.ps1=41fb919b9dae5be7142d193fe52c15aef2c8777f
- [x] Output `lib/test-save-state.ps1` equals its declared resulting Git blob. check: blob:lib/test-save-state.ps1=fef3415696c420753dafece0bcfde293d99fee4d
- [x] Output `lib/test-workbench-governance.ps1` equals its declared resulting Git blob. check: blob:lib/test-workbench-governance.ps1=64c797acd2f1dab99cd5875653fb0002a1eb6342
- [x] Output `lib/Test-WorkbenchChange.ps1` equals its declared resulting Git blob. check: blob:lib/Test-WorkbenchChange.ps1=e0bf56b4f3dd2f444120bcb96af24f1538b314ea
- [x] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [x] AC-01 Evaluator (items 1-3): in lib/Test-WorkbenchChange.ps1, Get-WorkbenchRecipe selects, unless -FullSchedule is given, the always-on tests (test-workbench-governance, test-markdown-consistency, test-workspace-layout) plus every lib/test-*.ps1 that is itself scoped or whose text at the tree names a scoped path's file name, RESUME.md excluded; it keeps the full schedule when the scope holds a CONTROL path other than RESUME.md or a scoped .ps1, .psm1, .mjs, .js or .json path that no test names; Get-WorkbenchCIRecipe passes -FullSchedule; Get-WorkbenchContext refuses a Temp Root over 93 characters with WB_CONTEXT_FIXTURE_PATH_TOO_LONG; the CI context floors are '0.001'; test-workbench-governance passes, including the selection cases, the CI full-schedule case, the bounds at 101/93 accepted and 102 and 94 refused, the CI floor case and the three mutants killed (no fail-closed branch, no CI full schedule, the Temp Root bound off by one). On the replay tree the candidate evaluator selects for RESUME.md plus lib/Save-State.ps1 the three always-on tests and lib/test-save-state.ps1 only, for RESUME.md plus docs/RUNBOOK.md the always-on tests plus the tests that name RUNBOOK.md, each fewer than the full schedule, and for this contract's own scope the full schedule. Every owning test of this contract passes with Tests Root, Temp Root and TEMP of the Finish's own lengths (68, 70 and 74 characters), since the nested fixtures leave only a few characters under the 93 bound. Accepted cost (DEC-07): a test that exercises a scoped file without naming it is not run locally; GitHub runs it before main moves.
- [x] AC-02 Save-State (items 4-6): both continuity swap moves and the restore of continuity.old go through Move-Folder (5 attempts, 2 s apart, only IOException or UnauthorizedAccessException, then the error stands), and lib/Save-State.ps1 keeps one [IO.Directory]::Move call; a given -Plan is kept in the workstream folder's plan.txt and serves a later save without -Plan; one comma-joined -Evidence string is split; a missing workstream folder is made only by a save with -Plan, after every check; test-save-state passes with TEMP a long path and again with TEMP an 8.3 short path, including its planStore, evidenceSplit and moveRetry cases and their mutants.
- [x] AC-03 Guard-Write (items 7-8): lib/hooks/Guard-Write.ps1 refuses a protected name only after a write verb in the same command segment (segments split on &&, ||, |, ; and new lines outside quotes and here-strings, so a quoted separator cannot part a verb from its target, which the V1 candidate allowed and the baseline refused) and refuses a write into a package\release folder with GUARD_RELEASE_FOLDER naming the lesson; test-organize passes with its earlier guard cases and the new ones (three writes whose -Value holds a quoted ; or | or a here-string before -Path refused; three release-folder writes refused; a read redirected elsewhere, a here-string mention and reads from package\release pass). Known limit, kept on purpose: a copy or move that only reads a single-writer file is still refused (the guard errs toward refusal).
- [x] AC-04 B15 (item 9): lib/Hunt.ps1, lib/Organize.ps1 and lib/test-hunt.ps1 equal the baseline plus data/records/WS-034/b15-hunt-organize.patch (SHA256 CF20A416E8DE1247590CB1C7149A65B4D5D7C806F2D4B499FE3F2AADC8A45317), and lib/test-organize.ps1 holds every line that patch adds and none it removes; test-hunt and test-organize pass. At the Original stage, before Prepare: lib/Hunt.ps1, lib/Organize.ps1, lib/test-hunt.ps1 and changes/README.md in the Original's working tree equal their declared blobs, lib/test-organize.ps1 equals the baseline plus the patch; all five are copied to data/records/WS-034/b15-backup/ and only they are restored with git restore; implement writes the declared blobs (CONTRACT.md section 7 Q2). The proof runs live immediately before the restore, never from this preparation; any mismatch stops the Original stage before anything is restored.
- [x] AC-05 Hold sentence (item 10): no file under lib/ contains "remains ON HOLD"; lib/Invoke-ContractStage.ps1 ends its approval and implement entries with the configured HoldNote, or with nothing when it is absent; test-native-stage passes with and without HoldNote.
- [x] AC-06 Decisions and procedures (items 11, 12, 14): docs/DECISIONS.md is at most 49152 B after LF normalisation and only DEC-07, DEC-25 and DEC-33 differ from baseline; DEC-07 states the landed rule and no longer says "deferred until after the Owner Lift"; DEC-25 names the Batch 6 class and its conditions; DEC-33 keeps twelve numbered rules and rule 12 reads "12. Fix, never skip: fix each error, gap or failed check at its root now; defer only out-of-scope, unsafe or owner fixes (owner, trigger); lesson each mistake, guard a repeat; finish before expanding."; docs/history/DECISIONS-ARCHIVE.md changes only by appending item D128, which quotes the owner's three texts verbatim as frozen in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md (SHA256 85B76E13846809796CAD74459606207727ED19E9633C261BE75CE9C5934EFE3B) and the replaced DEC-07, DEC-25 sentence and rule 12 verbatim, each followed by its Now in line; docs/history/DECISIONS-MAP.tsv changes only by appending row D128; docs/RUNBOOK.md changes only in the TEMP-bound clause of section 2 and the folder, evidence and plan sentences of section 11; the Markdown guard passes with this contract in place, and test-markdown-consistency passes.
- [x] AC-07 Organizer (item 15): changes/README.md is what lib/Organize.ps1 -Refresh writes: a refresh of the replay changes no organizer.
- [x] AC-08 Secrets and privacy: gitleaks on the exact candidate range reports no finding in the 16 outputs and RESUME.md; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; neither masked value (the computer name, a marketing tunnel script name) is in any changed file or in this contract.
- [x] AC-09 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 on the full schedule with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json. The new evaluator blob pinned above is the one the release sets (DEC-07).
- [x] AC-10 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-034/evidence/protected-before.json, captured before the sandbox Finish and again after Original Complete with data/records/WS-038/Capture-Protected.ps1; lib/Invoke-ContractLifecycle.ps1, lib/apply-draft-steps.ps1 and lib/Delegate.ps1 are unchanged; no CRM or ORVION change, no Batch 6 product step, deletion, Codex, subagent, RAM, power setting or scheduled task change, no push or release under this contract. Commits stay local (DEC-25).

## Review Gate

- [x] Inspect the live subject, this role's fresh receipt, timing and watching evidence, and every criterion above, with attempts, deviations and gaps kept visible. No prototype result or earlier receipt substitutes for this role's gate.
- [x] Review: one Claude-main self-review, labelled as such and never called independent. The Codex review (DEC-14) is recorded SKIPPED by the owner's decision of 2026-11-08 ~01:20 Cairo, never replaced or claimed (D120). At most one corrective version; a remaining material disagreement goes to the owner.
- [x] Retro (DEC-12): Claude main, and Codex if it reviewed, name what does not satisfy them, each item with a remedy and a check.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Append only. No approval, execution-root binding or receipt is claimed. At actual approval add exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line using actual immutable identities. Owner evidence must name the approved digest and execution root. For original execution append exactly one Sandbox Receipt and Sandbox Receipt SHA256 for the matching successful schema2 sandbox artifact. A delegated decision needs actual live owner delegation and is labelled delegated. Never invent human confirmation or approval.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-034\assurance\V3\DRAFT.md
Approved SHA256: 8E09C075F318E0FF63952173B454A89F3481C9580EA905E03261476C146A731B
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-034\gate\GATE1-WS034-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: C0ACFDACFC48B4276DD7714F5039A2CBCDD75758A328C6AD8500A8990D90A724
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W34\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: E37BC7030024F243883D08AF7AA539EACAAE8165EE5F5394B997AB54D1B49803
Original exact declared outputs applied by accepted native Execute; fresh own Finish and Review/Complete remain required. Other protected roots unchanged. Controller: data/records/WS-034/controller copy of the baseline lifecycle with one line conditional (self-review F-1): the live evaluator is checked to its declared output blob e0bf56b, not to the accepted judge it replaces; the judge and native Workbench.ps1 keep every authority.
Residual risks carried unchanged from the selected Draft Review Gate and V3 REPORT.md; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (data/decisions-inbox.md), not by unavailability. Controller: data/records/WS-034/controller copy of the baseline lifecycle with one line conditional (self-review F-1): the live evaluator is checked to its declared output blob e0bf56b, not to the accepted judge it replaces; the judge and native Workbench.ps1 keep every authority. Release is a later stage.

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W34-cand (data/records/WS-034/Make-Candidate.ps1). Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json and REPORT.md beside this Draft. After Complete, outside this contract: the release is its own stage under its own DELEGATED record (DEC-25), settled at Original Complete by the constitution before any question to the owner; the protected state is compared with its record from before; the inbox is folded (CONTRACT.md item 13); Save-State and the status page record the result. V3 sources and selection table: STANDARDS-CHECK.md and REPORT.md beside this Draft; evidence refreshed 2026-11-09 ~07:25 Cairo (origin main d69f277, portable PowerShell 7.6.8, git version 2.54.0.windows.1).
Verdict: Confirmed Complete
Reviewed Fingerprint: 9ABF03158238E1436910C8CCB93B525FBEA9092580F9281C0FECAF43EA366A71
Reviewed Receipt: BDB676725EFF5AEB7202248B0AB827A2AD794FF51D0BBC95A8398B09CD4B95FD
Live ORIGINAL-role review: runtime/original/criterion-review.json. Own Finish 31 ordered suites, runner/watcher/host 0/0/0, real journal unchanged. Review: ONE Claude-main SELF-REVIEW, not independent; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (data/decisions-inbox.md), not by unavailability. Exact completed sandbox proof E20043558D2E65B7E163D6F11957FC7B1BE5196321A975E9265EB18DB0BD4631 bound. Not pushed; the release is its own stage.

