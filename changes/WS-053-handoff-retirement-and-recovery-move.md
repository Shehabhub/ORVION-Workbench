# Workbench Change Request - WS-053

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

## Objective

Retire HANDOFF.md with every reader moved to its one home, and move the A1 machine recovery into the backup package, with the scope of data/records/WS-053/CONTRACT.md section 5. HANDOFF.md is deleted by the WS-052 step ``N. Delete `path`, whose baseline Git blob is <40 hex>.``; README.md repoints its closure row to DEC-05; WORKFLOW.md drops its Batch 6 closure home row and names DEC-05 in its section 1 pointer list; docs/DECISIONS.md DEC-05 keeps the Lift as decided and pins the closure criteria and the Lift line at `dbc0fc7:HANDOFF.md` sections 11-12, and the active-document list drops it; docs/WORKSPACE-LAYOUT.md drops it from the tree, the retention row and the kept-names row; lib/Organize.ps1 drops it from the workbench router's required files, with lib/test-organize.ps1's fixture. lib/Test-MarkdownConsistency.ps1 gains `$RetiredFiles=@('HANDOFF.md')`: it fails MD_RETIRED_PRESENT if the file returns and MD_RETIRED_REFERENCE if an active file or tool names it outside a `<sha7>:path` pin, with history, changes/WS-*.md, docs/owner, records and the check itself exempt; lib/test-markdown-consistency.ps1 covers it. lib/Backup-Workspace.ps1 gains Save-MachineInventory, run only with -Package: a masked machine inventory (MCP servers, plugins, scoop, winget, npm and bun globals, VS Code, WSL, installed programs, store apps, tool versions, global git, environment variables with secret-named values not recorded, scheduled tasks, the pinned temporary tools) in records\machine\inventory-<UTC date> of the data root, written through a .partial folder and a move, with TEMP isolated in a private folder removed after and each source listed in inventory-status.tsv; lib/test-backup-restore.ps1 covers it and lib/README.md names it. docs/RECOVERY.md gains "## Machine restore"; lib/Restore-ORVION.ps1 prints one ACTION line naming the newest inventory and its C2 line names DEC-05 and docs/RECOVERY.md, with lib/test-restore-orvion.ps1. records/WS-052/README.md is the WS-052 summary with its Organize -New header, docs/history/LOG.tsv row and records/README.md lines, so NO_SUMMARY holds once WS-053 is Complete. changes/README.md gets the WS-053 row Organize -Refresh writes. Benefit (DEC-30: the owner can lose the machine without losing anything important; a new agent reads one home): HANDOFF.md was a retired closure file still listed as active, budgeted and read by the recovery checklist, and no backup recorded which programs, tools, MCP servers and settings the machine needs.

Tier: Significant under DEC-12 (it deletes a tracked file, changes what every backup package carries and what every restore prints, and adds a repository-wide guard). Governance check: every consumer listed (CONTRACT.md section 5); the owning tests run on the candidate with one causal mutant per production file (four); a retro closes the workstream. Authority: scope and order, the owner's live words of 2026-11-28, "continue with WS-053 retires HANDOFF.md and moves the A1 recovery, as WS-052's CONTRACT.md section 3 records. Then the Batch 6 Finish", with WS-052 CONTRACT.md section 3 naming the scope; Batch 6 PLAN Step 4 A1 and the owner's words of 2026-11-26 10:44 Cairo in data/records/WS-050/owner-words/owner-2026-11-26-all-steps-no-skip-frontend-after.txt (SHA256 0F1FAFFF91B1A21E0C886F53D72A5BC5B3327FBFE0EAA5A42FAD3758BE428356); DEC-01, DEC-02, DEC-05, DEC-08, DEC-09, DEC-10, DEC-11, DEC-12, DEC-13, DEC-14, DEC-22, DEC-23, DEC-24, DEC-25, DEC-26, DEC-27, DEC-30, DEC-31 and DEC-33; for everything else, the owner's delegation that the constitution decides in the owner's absence (data/records/batch6/owner-words/owner-2026-11-21-constitution-decides-in-my-absence.txt, SHA256 DB34F67C2AF82D9A9751597247ABEEBD74B4BBB1CC6F47291D2572FE080EEAB0) and the live AFK Mode run instruction. Gate approvals are Claude main's under that delegation, labelled DELEGATED; no owner text is typed by an agent (DEC-02).

Number: WS-053. Intended contract: changes/WS-053-handoff-retirement-and-recovery-move.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: WS-053 changes neither lib/Invoke-ContractLifecycle.ps1 nor lib/apply-draft-steps.ps1, so both roles run the baseline lib/Invoke-ContractLifecycle.ps1 and lib/apply-draft-steps.ps1 of dbc0fc7 with the accepted judge lib/Test-WorkbenchChange.ps1 (SHA256 4E1F00E159B82ECDFDD0F0C542A08B71D77BBFE4ABAAB4B6B1B8377587017FD1, unchanged). The Delete step is the WS-052 grammar, which the baseline applier and controller carry. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

dbc0fc7927fdcb3b3e20a4add90a3f2e0bcee56a

## Write Scope

- changes/README.md
- docs/DECISIONS.md
- docs/history/LOG.tsv
- docs/RECOVERY.md
- docs/WORKSPACE-LAYOUT.md
- HANDOFF.md
- lib/Backup-Workspace.ps1
- lib/Organize.ps1
- lib/README.md
- lib/Restore-ORVION.ps1
- lib/test-backup-restore.ps1
- lib/test-markdown-consistency.ps1
- lib/Test-MarkdownConsistency.ps1
- lib/test-organize.ps1
- lib/test-restore-orvion.ps1
- README.md
- records/README.md
- records/WS-052/README.md
- RESUME.md
- WORKFLOW.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: any deletion of a tracked file other than HANDOFF.md; RESUME.md apart from the native pointer transitions; lib/apply-draft-steps.ps1, lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/Workbench.ps1, lib/Invoke-DraftSteps.ps1 and every other lib/ file, test and hook not in Write Scope; every other function and case of the changed lib/ files; .claude/settings.json; every other docs/ file and every other DEC entry; every other row and line of the changed documents, lib/README.md, changes/README.md and records/README.md; records/WS-022 to WS-051 and every other records/ file; every earlier LOG.tsv row; past changes/WS-0xx files; the untracked data/records/machine/machine-inventory.ps1 (its retirement goes to Organize -Clean with the owner, DEC-10); the root work/ folder; the owner's profile (%USERPROFILE%\.claude and %LOCALAPPDATA%\usage) and the agent memory pointers (changed after Complete, outside the repository); data/ (untracked); the seven legacy folders, Owner-Tools, the vault and every package; any CRM or ORVION change (DEC-08); any Supabase project, Primary or Founder Secondary; credentials, real sessions or events (DEC-09); Codex, subagents, RAM, power, environment-variable or scheduled-task changes; FE-0; any push or release before both roles are Complete (DEC-25).

## Draft Assurance

V1: WS053-V1-CLAUDE-SIGNIFICANT-DESIGN-20261128-01 | 2026-11-28 | c:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-053\assurance\V1\DRAFT.md | 405B24E57E42FE861D4C1C319C4156F518589F27BC6DA30D78308D55E9C56815
V2: WS053-V2-CLAUDE-SIGNIFICANT-ADVERSARIAL-20261128-01 | 2026-11-28 | c:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-053\assurance\V2\DRAFT.md | 7FC6492FCA4436778B0955D90108CC44A9A336C84111011F722C6536498173DD
V3: WS053-V3-CLAUDE-REFRESH-20261128-01 | 2026-11-28 | c:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-053\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V1 DESIGN by Claude main, claude-opus-5-5, under D120: the owner skipped Codex and subagents on 2026-11-08 ~01:20 Cairo, standing (the owner's words verbatim in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md; D124 wrote D120 into DEC-14 and DEC-19). Codex skipped by owner decision, not by unavailability. No Codex work is claimed and nothing here is independent. V1 designs the scope of data/records/WS-053/CONTRACT.md section 5 from the frozen candidate cx\W53-c4 (tree 94a2ab1aa5e58e353341057a9d7ea42b0678ed62 at baseline dbc0fc7, candidate-c3.patch SHA256 58011D4D47D854B3E4AD75CE757C9B1880F3EA1AE011CD20DB1100B7183969A4; it replaces candidate.patch only in README.md and WORKFLOW.md, whose removal-only changes had no Draft marker), whose owning tests passed before V1: test-backup-restore, test-restore-orvion, test-markdown-consistency 162 assertions and test-organize, and Organize -Check -Quick with isolated absent roots PASS (data/records/WS-053/evidence/*.log; the first markdown run failed MD_LINK_MISSING and is kept; on cx\W53-c4 test-markdown-consistency passed again with 162 assertions and Organize -Check -Quick passed with fresh absent roots, evidence/*-c4*.log, the first c4 Organize run having failed because Hunt had created its data root, kept in organize-check-c4.log); the four production mutants were killed and restored (evidence/mutants.log). HANDOFF.md is deleted by the WS-052 Delete grammar at its baseline blob 3e5875c6fb68dab0559d1c81ba8e2068cf062c60; DEC-05 keeps its closure criteria by the pin `dbc0fc7:HANDOFF.md`.

V2 ADVERSARIAL by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V2 attacks V1 and changes no output or criterion. The V1 Draft check PASSED on every item (data/records/WS-053/evidence/w53-check-V1b.log; V1/claude-draft-check.json SHA256 959BA0D5CF4DFDF5234DB68208AEECE5692FCB3E03889167C4A8C7955B79A7B3; the first run, evidence/w53-check-V1.log, failed on three faults of the check kit, not the candidate, fixed and recorded in CONTRACT.md section 6): tree equal, numstat, exact lines, the Delete step and its absence after both applies, the DEC-05 pin resolving to the HANDOFF.md baseline blob, the LOG row, schedule, organizer, NO_SUMMARY a/b/c, gitleaks 0, masked 0/0, the four owning tests exit 0 (test-backup-restore 283s, test-organize 302s), INVENTORYMASK, RESTOREACTION, RETIREDLIST and ROUTERLIST killed at their named first FAIL with bytes restored, hazards 0/74, and the guard passing with the contract and refusing MD_RETIRED_PRESENT when the baseline HANDOFF.md is staged back. Attacks: (a) loss: the Lift record and closure criteria stay reachable by the pin `dbc0fc7:HANDOFF.md` sections 11-12 in DEC-05 (dec05PinOk), and DEC-05's Lift stays as decided (exact lines); (b) return: a file named HANDOFF.md brought back fails the guard (retired:True) and a tool or active file naming it fails MD_RETIRED_REFERENCE (the five retired-file cases); (c) secrets: the machine inventory masks MCP env and header values, token shapes, URL passwords, key query values and secret-named environment values (INVENTORYMASK killed), and gitleaks finds nothing in the Draft or the outputs; (d) the Delete removes only the baseline bytes (the WS-052 grammar refuses other bytes before any write) and HANDOFF.md is the only deletion (numstat, delete=1); (e) the judge lib/Test-WorkbenchChange.ps1 stays 4E1F00E1 and the lifecycle tools are not in scope; (f) unprovable here: a real -Package run on this machine and the restore of its inventory stay UNPROVEN until after Original Complete. V2 reuses the V1 test and mutant results only when its replay tree equals V1's (Check-Draft -ReuseTests, REUSE_TREE_DIFFERS otherwise).

V3 REFRESH by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V3 changes no output and confirms the live facts on 2026-11-28: origin/main dbc0fc7927fdcb3b3e20a4add90a3f2e0bcee56a and the Original HEAD dbc0fc7927fdcb3b3e20a4add90a3f2e0bcee56a, 0 uncommitted path(s); lib/Invoke-ContractLifecycle.ps1 is SHA256 B10AF598951AEA82AF1A6DA07F1A8E0B558339CE1C8FA078D92ED2D28EC18AFA at the baseline and WS-053 changes neither it nor lib/apply-draft-steps.ps1, so no controller copy is needed (CONTRACT.md section 5), and lib/Test-WorkbenchChange.ps1 is still 4E1F00E159B82ECDFDD0F0C542A08B71D77BBFE4ABAAB4B6B1B8377587017FD1; the pinned host is 7.6.8 and git version 2.56.1.windows.1. The V2 Draft check passed (data/records/WS-053/evidence/w53-check-V2.log; V2/claude-draft-check.json SHA256 065EB414A690170468774F678BD59D2CD09158FAD662420451679B3928C4CD0F): tree equal, every text check true, gitleaks 0, masked 0/0, the four owning tests exit 0, the four mutants INVENTORYMASK, RESTOREACTION, RETIREDLIST and ROUTERLIST killed with bytes restored, hazards 0/74; V3 reuses the V1 test and mutant results because the replay tree is identical.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W53\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W53\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W53\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W53\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.56.1.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none. PowerShell 7.6.8 is the portable host in ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8, which WS-034 and WS-040 to WS-052 ran; git 2.56.1 is the live machine version. RESUME.md has no step: it is in Write Scope only for the native pointer transitions, and the normalized-resume criterion below pins its route equal to the baseline across Approval and Complete. HANDOFF.md has a Delete step; its output is the null blob, so it has no blob criterion, and a criterion below states its absence.

1. Check whether `changes/README.md` contains `| WS-053-handoff-retirement-and-recovery-move.md | contracts | Workbench Change Request - WS-053 | - | - |`; if so record Already Applied when its Git blob is 6ff70870f3b7d0493f0da1d20b0da4666bea4f2a, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-052-delete-step-and-live-state-route.md | contracts | Workbench Change Request - WS-052 | - | - |
   ```
   insert
   ```text
   | WS-053-handoff-retirement-and-recovery-move.md | contracts | Workbench Change Request - WS-053 | - | - |
   ```

   The resulting file's Git blob is 6ff70870f3b7d0493f0da1d20b0da4666bea4f2a.

2. Check whether `docs/DECISIONS.md` contains `The owner lifted the Batch 6 hold on 2026-11-07 on closure criteria 1-5 as amended. WS-053 retired the closure file; the`; if so record Already Applied when its Git blob is 0dae778e63553ebf1a5119dd2b8715c2d90133ee, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) replace the lines
   ```text
   The owner decides the Lift on the closure criteria of HANDOFF section 12 as amended. Criterion 5, amended when the
   owner cancelled the Windows reinstall: the isolated restore of orvion-backup-20261026T201821Z.7z (done 2026-10-26)
   ```
   with
   ```text
   The owner lifted the Batch 6 hold on 2026-11-07 on closure criteria 1-5 as amended. WS-053 retired the closure file; the
   criteria and the Lift line stay at `dbc0fc7:HANDOFF.md` sections 11-12, the evidence in
   data\records\delegation-20261026\LIFT-EVIDENCE.md. Criterion 5, amended when the owner cancelled the Windows
   reinstall: the isolated restore of orvion-backup-20261026T201821Z.7z (done 2026-10-26)
   ```

   b) replace the lines
   ```text
   Why: the Lift must rest on what was proven, with every open risk visible.
   Changed: 2026-11-07
   ```
   with
   ```text
   Why: the Lift must rest on what was proven, with every open risk visible.
   Changed: 2026-11-28
   ```

   c) replace the line
   ```text
   In each active document (README, WORKFLOW, HANDOFF, RUNBOOK, DECISIONS, WORKSPACE-LAYOUT, lib/README and NOW.md) every
   ```
   with
   ```text
   In each active document (README, WORKFLOW, RUNBOOK, DECISIONS, WORKSPACE-LAYOUT, lib/README and NOW.md) every
   ```

   The resulting file's Git blob is 0dae778e63553ebf1a5119dd2b8715c2d90133ee.

3. Check whether `docs/history/LOG.tsv` contains `2026-11-28T08:03:13Z	new	workbench	-	records/WS-052	WS-053	WS-053 WS-052 summary	B0D99424139E6FF010C7E6DADE087238B69498E6B646B1A9FBAE8256517FB043`; if so record Already Applied when its Git blob is c4c0b24739c257ae15cb781878fb8cb32189c684, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   2026-11-26T19:54:27Z	new	workbench	-	records/WS-051	WS-052	WS-052 WS-051 summary	D321E7900A7C1EA7DC63FDC10C33C1ADDF2BADCD829573240AE37561757D9D91
   ```
   insert
   ```text
   2026-11-28T08:03:13Z	new	workbench	-	records/WS-052	WS-053	WS-053 WS-052 summary	B0D99424139E6FF010C7E6DADE087238B69498E6B646B1A9FBAE8256517FB043
   ```

   The resulting file's Git blob is c4c0b24739c257ae15cb781878fb8cb32189c684.

4. Check whether `docs/RECOVERY.md` contains `Updated 2026-11-28 (WS-053: machine restore). [Workspace layout](WORKSPACE-LAYOUT.md) owns the source/private/disposable boundary.`; if so record Already Applied when its Git blob is a29ca2b641a20867b94ca171491e1e4bce8d94ed, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   Updated 2026-10-30 (WS027 V3 candidate, not installed approval). [Workspace layout](WORKSPACE-LAYOUT.md) owns the source/private/disposable boundary.
   ```
   with
   ```text
   Updated 2026-11-28 (WS-053: machine restore). [Workspace layout](WORKSPACE-LAYOUT.md) owns the source/private/disposable boundary.
   ```

   b) replace the line
   ```text
   Record the restore result and all three Boot outputs. (Lift criterion 5 in HANDOFF section 12 was amended by the owner
   ```
   with
   ```text
   Record the restore result and all three Boot outputs. (Lift criterion 5 of DEC-05 was amended by the owner
   ```

   c) immediately after the lines
   ```text
   restored ignored files back. Keep a sandbox's push disabled: `git remote set-url --push origin DISABLED`.

   ```
   insert
   ```text
   ## Machine restore

   Each `Backup-Workspace -Package` first writes a machine inventory to `records\machine\inventory-<UTC date>` in the data
   root (one per UTC day; a day already written is reused), so the package carries it and Restore-Workspace brings it back
   with the data. It records programs and settings, never a secret value: MCP environment and header values, token shapes
   and secret-named environment values are masked. `inventory-status.tsv` names each source as ok, missing or failed.
   After Restore-ORVION, from the newest inventory folder:

   1. Programs: `scoop import scoop-export.json`; `winget import -i winget-export.json --accept-package-agreements`;
      `npm i -g` each name in npm-global.json; `code --install-extension <id>` for each line of vscode-extensions.txt,
      then copy `vscode-user\*` to `%APPDATA%\Code\User`.
   2. Pinned tools: download PowerShell-7.6.8-win-x64.zip from the official v7.6.8 release, check its SHA-256 against
      temporary-tools.tsv and unzip it to `ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8`;
      `npm i typescript@7.0.2 --prefix <temporary>\tools\typescript`.
   3. MCP: re-add each server in claude-mcp-servers.masked.json with `claude mcp add`; supply masked values from their own
      sign-ins.
   4. Environment: set the non-secret values in environment-variables.tsv; re-create each masked secret value from its
      provider.
   5. Global git: apply the lines in gitconfig-global.txt with `git config --global`.

   Marketing-MCP and every sign-in stay the owner's (DEC-09).
   ```

   The resulting file's Git blob is a29ca2b641a20867b94ca171491e1e4bce8d94ed.

5. Check whether `docs/WORKSPACE-LAYOUT.md` contains `| RESUME.md, WORKFLOW.md, AGENTS.md, docs/RECOVERY.md, docs/WORKSPACE-LAYOUT.md keep their names | the evaluator, the Markdown guard and Restore-ORVION read them; Map-Repos treats them as entry documents (records/WS-033/MIGRATION-MAP.tsv W02-W04, W06, W07, W12) |`; if so record Already Applied when its Git blob is b0aff342eaa7a251e723d8b1030535c7159f47d7, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) replace the lines
   ```text
   ├── WORKFLOW.md             only the parts the trusted checker and the Markdown guard read
   ├── HANDOFF.md              Lift record and programme closure criteria only
   ```
   with
   ```text
   ├── WORKFLOW.md             only the parts the trusted checker and the Markdown guard read
   ```

   b) replace the line
   ```text
   | backup packages and their sidecars | the last 7, plus any package an active file names (HANDOFF.md and DEC-05 name orvion-backup-20261026T201821Z.7z) | deleted by `-Clean`'s retention tier, which Backup-Workspace runs after each verified package (slice S7, DEC-27); a package carrying the OneDrive pin attribute is kept and reported |
   ```
   with
   ```text
   | backup packages and their sidecars | the last 7, plus any package an active file names (DEC-05 names orvion-backup-20261026T201821Z.7z) | deleted by `-Clean`'s retention tier, which Backup-Workspace runs after each verified package (slice S7, DEC-27); a package carrying the OneDrive pin attribute is kept and reported |
   ```

   c) replace the line
   ```text
   | RESUME.md, WORKFLOW.md, HANDOFF.md, AGENTS.md, docs/RECOVERY.md, docs/WORKSPACE-LAYOUT.md keep their names | the evaluator, the Markdown guard and Restore-ORVION read them; Map-Repos treats them as entry documents (records/WS-033/MIGRATION-MAP.tsv W02-W04, W06, W07, W12) |
   ```
   with
   ```text
   | RESUME.md, WORKFLOW.md, AGENTS.md, docs/RECOVERY.md, docs/WORKSPACE-LAYOUT.md keep their names | the evaluator, the Markdown guard and Restore-ORVION read them; Map-Repos treats them as entry documents (records/WS-033/MIGRATION-MAP.tsv W02-W04, W06, W07, W12) |
   ```

   d) replace the line
   ```text
   | Markdown guard (lib/Test-MarkdownConsistency.ps1; read-only: the working tree, the index or a Git tree, never an outside path) | the Finish schedule | every tracked Markdown file reachable from README.md or AGENTS.md through local links, unless it is history (an allocated contract, or a link in the History index of docs/history/README.md); links and anchors resolved case-sensitively from their file; the One-home table of WORKFLOW.md (each concept once, in its fixed home); only RESUME.md declares the active contract pointer; no duplicate prose paragraph of 25 words or more; no header date older than a body amendment; a retired path never as an instruction; DEC-ID uniqueness, watch patterns (never on a frozen owner text whose exact bytes the guard pins, and no other check is skipped), archive append-only with every item naming an existing entry, size budgets in bytes after CRLF to LF (AGENTS.md 1.5 KB, NOW.md 6 KB, README.md 8 KB, DECISIONS.md 48 KB, RESUME.md 900 B, HANDOFF.md 4,500 B, WORKFLOW.md 20,300 B, injected hook text), links and line length (<= 200; table rows exempt) in active files; section IDs and citations (records/WS-033/signposting.md section 5) |
   ```
   with
   ```text
   | Markdown guard (lib/Test-MarkdownConsistency.ps1; read-only: the working tree, the index or a Git tree, never an outside path) | the Finish schedule | every tracked Markdown file reachable from README.md or AGENTS.md through local links, unless it is history (an allocated contract, or a link in the History index of docs/history/README.md); links and anchors resolved case-sensitively from their file; the One-home table of WORKFLOW.md (each concept once, in its fixed home); only RESUME.md declares the active contract pointer; no duplicate prose paragraph of 25 words or more; no header date older than a body amendment; a retired path never as an instruction; DEC-ID uniqueness, watch patterns (never on a frozen owner text whose exact bytes the guard pins, and no other check is skipped), archive append-only with every item naming an existing entry, size budgets in bytes after CRLF to LF (AGENTS.md 1.5 KB, NOW.md 6 KB, README.md 8 KB, DECISIONS.md 48 KB, RESUME.md 900 B, WORKFLOW.md 20,300 B, injected hook text), links and line length (<= 200; table rows exempt) in active files; section IDs and citations (records/WS-033/signposting.md section 5) |
   ```

   The resulting file's Git blob is b0aff342eaa7a251e723d8b1030535c7159f47d7.

6. Delete `HANDOFF.md`, whose baseline Git blob is 3e5875c6fb68dab0559d1c81ba8e2068cf062c60.

7. Check whether `lib/Backup-Workspace.ps1` contains `#                         with -Package, first records\machine\inventory-<UTC date>: the A1 machine inventory (WS-053)`; if so record Already Applied when its Git blob is 575f78c04b80c2fff6513cc07c8f010ba9d451a5, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   #   owner-tools\          the data root, ORVION-Workbench\data (sessions archive, events journal, work) minus work\sandboxes
   ```
   insert
   ```text
   #                         with -Package, first records\machine\inventory-<UTC date>: the A1 machine inventory (WS-053)
   ```

   b) immediately after the line
   ```text
   $TemporaryRoot=Initialize-OrvionTemporaryRoot -Checkout $tools
   ```
   insert
   ```text
   # A1 recovery (WS-053): what a fresh Windows needs reinstalled or re-set, written once per UTC day into the data root
   # before it is packaged (docs/RECOVERY.md, Machine restore). Secret values are never read out: MCP env and header values,
   # token prefixes, URL passwords, key query values and secret-named variables are masked. A missing tool is recorded as
   # missing and a failed item as failed; neither fails the backup. A half-written day is never reused.
   function Save-MachineInventory([string]$Root){
       $Root=[IO.Path]::GetFullPath($Root);$parent=Join-Path $Root 'records\machine';$final=Join-Path $parent ('inventory-'+[DateTime]::UtcNow.ToString('yyyyMMdd'))
       if(Test-Path -LiteralPath $final -PathType Container){"MACHINE INVENTORY: $final (reused)";return}
       $out=$final+'.partial';if([IO.Directory]::Exists($out)){[IO.Directory]::Delete($out,$true)}
       # Tools run here write caches to TEMP (node's compile cache, winget logs): they go to a private folder removed after.
       $scratch=$final+'.tmp';if([IO.Directory]::Exists($scratch)){[IO.Directory]::Delete($scratch,$true)};[void][IO.Directory]::CreateDirectory($scratch)
       $savedTemp=$env:TEMP,$env:TMP;$env:TEMP=$env:TMP=$scratch
       try{
       [void][IO.Directory]::CreateDirectory($out);$h=$env:USERPROFILE;$status=[Collections.Generic.List[string]]::new()
       $secretKey='(?i)(token|secret|password|passwd|api_?key|private_?key|bearer|cookie|credential|session|_pat$|_pat_)'
       function Protect-InventoryValue($v){
           if($v-is[Collections.IDictionary]){$o=[ordered]@{};foreach($k in $v.Keys){$o[$k]=if($k-in'env','headers'-and$v[$k]-is[Collections.IDictionary]){$e=[ordered]@{};foreach($ek in $v[$k].Keys){$e[$ek]='<masked>'};$e}elseif($k-match$secretKey-and$v[$k]-isnot[Collections.IDictionary]){'<masked>'}else{Protect-InventoryValue $v[$k]}};$o}
           elseif($v-is[string]){$v-replace'(?i)(sbp_|ghp_|gho_|github_pat_|sk-|eyJ)[A-Za-z0-9_\-\.]+','<masked>'-replace'(://[^:/@\s]+:)[^@\s]+@','$1<masked>@'-replace'(?i)([?&](key|token|api_key|apikey)=)[^&\s"]+','$1<masked>'}
           elseif($v-is[Collections.IEnumerable]){,@($v|ForEach-Object{Protect-InventoryValue $_})}else{$v}
       }
       function Write-Item([string]$Name,[scriptblock]$Body,[string]$Needs){
           if($Needs-and!(Get-Command $Needs -ErrorAction SilentlyContinue)){$status.Add("$Name`tmissing`t$Needs");return}
           try{$text=@(& $Body)-join"`n";$file=Join-Path $out $Name;[void][IO.Directory]::CreateDirectory((Split-Path $file -Parent))
               [IO.File]::WriteAllText($file,(Protect-InventoryValue $text),[Text.UTF8Encoding]::new($false));$status.Add("$Name`tok`t")}
           catch{$status.Add("$Name`tfailed`t$((Protect-InventoryValue "$($_.Exception.Message)")-replace'\s+',' ')")}
       }
       $claudeJson=Join-Path $h '.claude.json'
       if(Test-Path -LiteralPath $claudeJson -PathType Leaf){Write-Item 'claude-mcp-servers.masked.json' {
           $j=[IO.File]::ReadAllText($claudeJson)|ConvertFrom-Json -AsHashtable;$mcp=[ordered]@{user=(Protect-InventoryValue $j.mcpServers);projects=[ordered]@{}}
           foreach($p in @($j.projects.Keys)){if($j.projects[$p].mcpServers.Count){$mcp.projects[$p]=Protect-InventoryValue $j.projects[$p].mcpServers}}
           $mcp|ConvertTo-Json -Depth 12}}else{$status.Add("claude-mcp-servers.masked.json`tmissing`t.claude.json")}
       foreach($name in 'installed_plugins.json','known_marketplaces.json'){$file=Join-Path $h ".claude\plugins\$name"
           if(Test-Path -LiteralPath $file -PathType Leaf){Write-Item "claude-plugins-$name" {Protect-InventoryValue ([IO.File]::ReadAllText($file)|ConvertFrom-Json -AsHashtable)|ConvertTo-Json -Depth 12}}}
       Write-Item 'scoop-export.json' {scoop export 2>$null} 'scoop'
       Write-Item 'winget-export.json' {$file=Join-Path $out 'winget-export.raw.json';$null=winget export -o $file --include-versions --accept-source-agreements --disable-interactivity 2>&1
           if(!(Test-Path -LiteralPath $file)){throw "winget export wrote nothing (exit $LASTEXITCODE)"};$text=[IO.File]::ReadAllText($file);[IO.File]::Delete($file);$text} 'winget'
       Write-Item 'npm-global.json' {npm ls -g --depth=0 --json 2>$null} 'npm'
       Write-Item 'bun-global.txt' {bun pm ls -g 2>$null} 'bun'
       Write-Item 'vscode-extensions.txt' {code --list-extensions --show-versions 2>$null} 'code'
       Write-Item 'wsl.txt' {(wsl.exe -l -v 2>&1|Out-String)-replace"`0",''} 'wsl.exe'
       Write-Item 'installed-programs.tsv' {"Name`tVersion`tPublisher"
           @(foreach($k in 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'){
               Get-ItemProperty $k -ErrorAction SilentlyContinue|Where-Object DisplayName})|Sort-Object DisplayName -Unique|ForEach-Object{"$($_.DisplayName)`t$($_.DisplayVersion)`t$($_.Publisher)"}}
       Write-Item 'store-apps.txt' {Get-AppxPackage|Where-Object{!$_.IsFramework-and$_.SignatureKind-ne'System'}|Sort-Object Name|ForEach-Object{"$($_.Name)`t$($_.Version)"}} 'Get-AppxPackage'
       Write-Item 'tool-versions.txt' {foreach($c in 'git','pwsh','node','npm','bun','docker','supabase','gh','codex','claude','gitleaks','7z','scoop','code'){$g=Get-Command $c -ErrorAction SilentlyContinue|Select-Object -First 1;"$c`t$($g.Source)`t$($g.Version)"}}
       $vscode=Join-Path "$env:APPDATA" 'Code\User'
       foreach($name in 'settings.json','keybindings.json','tasks.json','mcp.json'){$file=Join-Path $vscode $name;if(Test-Path -LiteralPath $file -PathType Leaf){Write-Item "vscode-user\$name" {[IO.File]::ReadAllText($file)}}}
       if(Test-Path -LiteralPath (Join-Path $vscode 'snippets') -PathType Container){foreach($f in Get-ChildItem -LiteralPath (Join-Path $vscode 'snippets') -File){Write-Item "vscode-user\snippets\$($f.Name)" {[IO.File]::ReadAllText($f.FullName)}}}
       Write-Item 'gitconfig-global.txt' {git config --global --list 2>$null} 'git'
       Write-Item 'environment-variables.tsv' {"Scope`tName`tValue";foreach($scope in 'User','Machine'){$vars=[Environment]::GetEnvironmentVariables($scope);foreach($k in ($vars.Keys|Sort-Object)){"$scope`t$k`t$(if($k-match$secretKey){'<secret: value not recorded>'}else{$vars[$k]})"}}}
       if(Get-Command Get-ScheduledTask -ErrorAction SilentlyContinue){foreach($task in Get-ScheduledTask -TaskPath '\' -ErrorAction SilentlyContinue|Where-Object{$_.TaskName-notmatch'^(MicrosoftEdge|OneDrive|GoogleUpdate|Opera|npcap|User_Feed)'}){
           Write-Item ("scheduled-tasks\"+($task.TaskName-replace'[\\/:*?"<>|]','_')+'.xml') {Export-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath}}}else{$status.Add("scheduled-tasks`tmissing`tGet-ScheduledTask")}
       $pinned=Join-Path $TemporaryRoot 'tools'
       if(Test-Path -LiteralPath $pinned -PathType Container){Write-Item 'temporary-tools.tsv' {"Path`tSHA256`tBytes"
           Get-ChildItem -LiteralPath $pinned -File|ForEach-Object{"$($_.Name)`t$((Get-FileHash -LiteralPath $_.FullName).Hash)`t$($_.Length)"}
           Get-ChildItem -LiteralPath $pinned -Directory|ForEach-Object{"$($_.Name)\`t(dir)`t$((Get-ChildItem -LiteralPath $_.FullName -Recurse -File|Measure-Object Length -Sum).Sum)"}}
           $ts=Join-Path $pinned 'typescript\package.json';if(Test-Path -LiteralPath $ts -PathType Leaf){Write-Item 'temporary-typescript-package.json' {[IO.File]::ReadAllText($ts)}}}
       else{$status.Add("temporary-tools.tsv`tmissing`t$pinned")}
       [IO.File]::WriteAllLines((Join-Path $out 'inventory-status.tsv'),[string[]](@("Item`tState`tDetail")+$status),[Text.UTF8Encoding]::new($false))
       }finally{$env:TEMP,$env:TMP=$savedTemp;try{[IO.Directory]::Delete($scratch,$true)}catch{"MACHINE INVENTORY: temporary folder left: $scratch"}}
       [IO.Directory]::Move($out,$final)
       $count={param($s)@($status|Where-Object{$_-match"`t$s`t"}).Count}
       "MACHINE INVENTORY: $final ($(& $count 'ok') ok, $(& $count 'missing') missing, $(& $count 'failed') failed)"
   }
   ```

   c) immediately after the line
   ```text
   if($Package-and@(Get-ChildItem -LiteralPath (Join-Path $ownerTools 'work\sandboxes') -Recurse -File -Force -ErrorAction SilentlyContinue).Count){throw 'PACKAGE_OWNER_SANDBOXES_NOT_PRESERVED: work\sandboxes holds files; capture or remove them first'}
   ```
   insert
   ```text
   if($Package){Save-MachineInventory $ownerTools}
   ```

   The resulting file's Git blob is 575f78c04b80c2fff6513cc07c8f010ba9d451a5.

8. Check whether `lib/Organize.ps1` contains `'workbench:'=New-OrganizeRule 'router' @('README.md','AGENTS.md','RESUME.md','WORKFLOW.md','tests.ps1','.gitignore','.gitattributes','changes/','config/','docs/','lib/','records/','.githooks/','.github/') '^(\.git/?|\.claude/|data/|workstation/|ai-map\.(html|json)|\.workbench-local-certification\.json|\.workbench-certifications/|\.omc/)$'`; if so record Already Applied when its Git blob is e6b7ee50cc429f8bfd25db42b39bab3b711f53f3, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
       'workbench:'=New-OrganizeRule 'router' @('README.md','AGENTS.md','RESUME.md','WORKFLOW.md','HANDOFF.md','tests.ps1','.gitignore','.gitattributes','changes/','config/','docs/','lib/','records/','.githooks/','.github/') '^(\.git/?|\.claude/|data/|workstation/|ai-map\.(html|json)|\.workbench-local-certification\.json|\.workbench-certifications/|\.omc/)$'
   ```
   with
   ```text
       'workbench:'=New-OrganizeRule 'router' @('README.md','AGENTS.md','RESUME.md','WORKFLOW.md','tests.ps1','.gitignore','.gitattributes','changes/','config/','docs/','lib/','records/','.githooks/','.github/') '^(\.git/?|\.claude/|data/|workstation/|ai-map\.(html|json)|\.workbench-local-certification\.json|\.workbench-certifications/|\.omc/)$'
   ```

   The resulting file's Git blob is e6b7ee50cc429f8bfd25db42b39bab3b711f53f3.

9. Check whether `lib/README.md` contains `, first the machine inventory of [Machine restore](../docs/RECOVERY.md#machine-restore)), explicit daily opt-in and separate application/Scheduler status. After a verified package it runs Organize's retention tier; a failure there is printed and in the status, and never fails the backup. The directory route requires an encrypted drive; the package is unencrypted. [Recovery](../docs/RECOVERY.md#daily-backup-opt-in-and-observation) owns arguments, durable inputs, retention and proof limits. Restore never overwrites. |`; if so record Already Applied when its Git blob is 2406230ab665ed939fe877c975f861a79e5bb662, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   | `Backup-Workspace.ps1 -Destination <folder> [-Package] [-Install] [-Status]` / `Restore-Workspace.ps1 -From <backup>` | Selected recovery coverage, explicit daily opt-in and separate application/Scheduler status. After a verified package it runs Organize's retention tier; a failure there is printed and in the status, and never fails the backup. The directory route requires an encrypted drive; the package is unencrypted. [Recovery](../docs/RECOVERY.md#daily-backup-opt-in-and-observation) owns arguments, durable inputs, retention and proof limits. Restore never overwrites. |
   ```
   with
   ```text
   | `Backup-Workspace.ps1 -Destination <folder> [-Package] [-Install] [-Status]` / `Restore-Workspace.ps1 -From <backup>` | Selected recovery coverage (with `-Package`, first the machine inventory of [Machine restore](../docs/RECOVERY.md#machine-restore)), explicit daily opt-in and separate application/Scheduler status. After a verified package it runs Organize's retention tier; a failure there is printed and in the status, and never fails the backup. The directory route requires an encrypted drive; the package is unencrypted. [Recovery](../docs/RECOVERY.md#daily-backup-opt-in-and-observation) owns arguments, durable inputs, retention and proof limits. Restore never overwrites. |
   ```

   The resulting file's Git blob is 2406230ab665ed939fe877c975f861a79e5bb662.

10. Check whether `lib/Restore-ORVION.ps1` contains `Write-Host "ACTION: the data root is the restored ORVION-Workbench\data (repair/unset ORVION_DATA_ROOT if needed); record the restore and all three Boot outputs (DEC-05, docs/RECOVERY.md)"`; if so record Already Applied when its Git blob is 0bdf2e74deb6c7ecf1f4d457fee50de7172198f2, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
       Write-Host "ACTION: the data root is the restored ORVION-Workbench\data (repair/unset ORVION_DATA_ROOT if needed); record C2 with restore and all three Boot outputs per HANDOFF.md section 12"
   ```
   with
   ```text
       Write-Host "ACTION: the data root is the restored ORVION-Workbench\data (repair/unset ORVION_DATA_ROOT if needed); record the restore and all three Boot outputs (DEC-05, docs/RECOVERY.md)"
       Write-Host "ACTION: from the newest $Target\ORVION-Workbench\data\records\machine\inventory-<date> reinstall programs, pinned tools, MCP servers, environment values and global git (docs/RECOVERY.md, Machine restore)"
   ```

   The resulting file's Git blob is 0bdf2e74deb6c7ecf1f4d457fee50de7172198f2.

11. Check whether `lib/test-backup-restore.ps1` contains `# WS-053: these packages reuse a seeded machine inventory (today and tomorrow UTC); the real read is checked once below.`; if so record Already Applied when its Git blob is 1a9bae3a3817c551a3fcc5c6579a62183f6ffb3e, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       [IO.File]::WriteAllText((Join-Path $data 'sessions/raw/s.jsonl'),'synthetic session')
   ```
   insert
   ```text
       # WS-053: these packages reuse a seeded machine inventory (today and tomorrow UTC); the real read is checked once below.
       foreach($day in 0,1){[void][IO.Directory]::CreateDirectory((Join-Path $data ('records/machine/inventory-'+[DateTime]::UtcNow.AddDays($day).ToString('yyyyMMdd'))))}
   ```

   b) immediately after the line
   ```text
       $planted='ghp_'+-join((48..57)+(65..90)+(97..122)|Get-Random -Count 36|ForEach-Object{[char]$_});[void][IO.Directory]::CreateDirectory((Join-Path $data 'records'));[IO.File]::WriteAllText((Join-Path $data 'records/leak.txt'),"token=$planted")
   ```
   insert
   ```text
       # WS-053: a token-shaped MCP value built at run time, in every place the inventory masks.
       $mcpSecret=-join((48..57)+(97..102)|Get-Random -Count 16|ForEach-Object{[char]$_})*2
       [ordered]@{mcpServers=[ordered]@{fixture=[ordered]@{command='fixture-mcp';args=@('--key',"sbp_$mcpSecret");env=[ordered]@{FIXTURE_VALUE=$mcpSecret}}};projects=[ordered]@{'C:/fixture'=[ordered]@{mcpServers=[ordered]@{web=[ordered]@{type='http';url="https://user:$mcpSecret@example.invalid/mcp?key=$mcpSecret";headers=[ordered]@{Authorization="Bearer $mcpSecret"}}}}}}|ConvertTo-Json -Depth 8|Set-Content -LiteralPath (Join-Path $env:USERPROFILE '.claude.json')
   ```

   c) immediately after the line
   ```text
           $pkgExit=$LASTEXITCODE;Assert-That 'a failed retention run never fails the backup' ($pkgExit-eq0);if($pkgExit){throw ('PACKAGE_FIXTURE_FAILED: '+($pkg-join' '))}
   ```
   insert
   ```text
           # WS-053: the first package writes the machine inventory into the data root; MCP secrets never leave masked.
           $inventory=@(Get-ChildItem -LiteralPath (Join-Path $data 'records/machine') -Directory -Filter 'inventory-*')
           $mcpText=if($inventory.Count-eq1){[IO.File]::ReadAllText((Join-Path $inventory[0].FullName 'claude-mcp-servers.masked.json'))}else{''}
           $inventoryStatus=if($inventory.Count-eq1){[IO.File]::ReadAllText((Join-Path $inventory[0].FullName 'inventory-status.tsv'))}else{''}
           Assert-That 'a package writes one machine inventory with a status table' ($inventory.Count-eq1-and($pkg-join"`n")-cmatch'(?m)^MACHINE INVENTORY: .*inventory-\d{8} \(\d+ ok, \d+ missing, \d+ failed\)'-and$inventoryStatus-cmatch'(?m)^claude-mcp-servers\.masked\.json	ok	') @($pkg)
           Assert-That 'the inventory masks MCP env, headers, token prefixes, URL passwords and key query values' ($mcpText.Contains('<masked>')-and!$mcpText.Contains($mcpSecret)-and$mcpText.Contains('"command": "fixture-mcp"')) @($mcpText)
   ```

   d) replace the line
   ```text
           $namingFile=Join-Path (Split-Path $probeLib -Parent) 'HANDOFF.md';[IO.File]::WriteAllText($namingFile,"Restore from $namedSeed.`n")
   ```
   with
   ```text
           $namingFile=Join-Path (Split-Path $probeLib -Parent) 'README.md';[IO.File]::WriteAllText($namingFile,"Restore from $namedSeed.`n")
   ```

   The resulting file's Git blob is 1a9bae3a3817c551a3fcc5c6579a62183f6ffb3e.

12. Check whether `lib/test-markdown-consistency.ps1` contains `'README.md'="# Purpose$nl[Governance](WORKFLOW.md) [Resume](RESUME.md) [Guide](docs/guide.md#section)$nl[data](data/work/NOW.md) [private](C:/private/missing.md)$nl${nl}## 1. Start$nl${nl}[Decisions](docs/DECISIONS.md) [Runbook](docs/RUNBOOK.md) [History](docs/history/README.md)$nl"`; if so record Already Applied when its Git blob is 93d73badd3a10478aa459d937c7f7289aee221b8, and otherwise stop and report. Otherwise make exactly these 9 edits (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
           'README.md'="# Purpose$nl[Governance](WORKFLOW.md) [Resume](RESUME.md) [Closure](HANDOFF.md) [Guide](docs/guide.md#section)$nl[data](data/work/NOW.md) [private](C:/private/missing.md)$nl${nl}## 1. Start$nl${nl}[Decisions](docs/DECISIONS.md) [Runbook](docs/RUNBOOK.md) [History](docs/history/README.md)$nl"
   ```
   with
   ```text
           'README.md'="# Purpose$nl[Governance](WORKFLOW.md) [Resume](RESUME.md) [Guide](docs/guide.md#section)$nl[data](data/work/NOW.md) [private](C:/private/missing.md)$nl${nl}## 1. Start$nl${nl}[Decisions](docs/DECISIONS.md) [Runbook](docs/RUNBOOK.md) [History](docs/history/README.md)$nl"
   ```

   b) replace the lines
   ```text
           'RESUME.md'="Active Workbench Contract: None${nl}Live state: data/work/NOW.md$nl"
           'HANDOFF.md'="# Closure$nl${nl}Unique closure boundary.$nl${nl}## 12. Criteria$nl${nl}Closure criteria.$nl"
   ```
   with
   ```text
           'RESUME.md'="Active Workbench Contract: None${nl}Live state: data/work/NOW.md$nl"
   ```

   c) replace the lines
   ```text
   | Active contract | [pointer](RESUME.md) |
   | Batch 6 closure | [closure](HANDOFF.md#closure) |
   ```
   with
   ```text
   | Active contract | [pointer](RESUME.md) |
   ```

   d) replace the lines
   ```text
       pointer=@('MD_POINTER_HOME',{param($directory) Edit-MarkdownFixture $directory 'HANDOFF.md' 'Unique closure boundary.' 'Active Workbench Contract: None'})
       pointerFence=@('MD_POINTER_HOME',{param($directory) Edit-MarkdownFixture $directory 'HANDOFF.md' 'Unique closure boundary.' ('~~~text'+$nl+'Active Workbench Contract: None'+$nl+'~~~')})
   ```
   with
   ```text
       pointer=@('MD_POINTER_HOME',{param($directory) Edit-MarkdownFixture $directory 'docs/RUNBOOK.md' 'The procedures.' 'Active Workbench Contract: None'})
       pointerFence=@('MD_POINTER_HOME',{param($directory) Edit-MarkdownFixture $directory 'docs/RUNBOOK.md' 'The procedures.' ('~~~text'+$nl+'Active Workbench Contract: None'+$nl+'~~~')})
   ```

   e) replace the lines
   ```text
       duplicate=@('MD_DUPLICATE_PROSE',{param($directory) $prose=1..25-join' ';foreach($path in @('HANDOFF.md','docs/guide.md')){Write-MarkdownFixture (Join-Path $directory $path) ([IO.File]::ReadAllText((Join-Path $directory $path))+$nl+$nl+$prose)}})
       fenceExclusion=@('',{param($directory) $prose=1..25-join' ';foreach($path in @('HANDOFF.md','docs/guide.md')){Write-MarkdownFixture (Join-Path $directory $path) ([IO.File]::ReadAllText((Join-Path $directory $path))+$nl+$nl+'~~~text'+$nl+$prose+$nl+'[missing](no.md)'+$nl+'~~~'+$nl)}})
   ```
   with
   ```text
       duplicate=@('MD_DUPLICATE_PROSE',{param($directory) $prose=1..25-join' ';foreach($path in @('docs/RUNBOOK.md','docs/guide.md')){Write-MarkdownFixture (Join-Path $directory $path) ([IO.File]::ReadAllText((Join-Path $directory $path))+$nl+$nl+$prose)}})
       fenceExclusion=@('',{param($directory) $prose=1..25-join' ';foreach($path in @('docs/RUNBOOK.md','docs/guide.md')){Write-MarkdownFixture (Join-Path $directory $path) ([IO.File]::ReadAllText((Join-Path $directory $path))+$nl+$nl+'~~~text'+$nl+$prose+$nl+'[missing](no.md)'+$nl+'~~~'+$nl)}})
   ```

   f) immediately after the line
   ```text
       frozenCitation=@('MD_SECTION_MISSING',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}See ${d}77.$nl"})
   ```
   insert
   ```text
       retiredPresent=@('MD_RETIRED_PRESENT: HANDOFF.md',{param($directory) Write-MarkdownFixture (Join-Path $directory 'HANDOFF.md') "# Closure$nl"})
       retiredReference=@('MD_RETIRED_REFERENCE: docs/guide.md names HANDOFF.md',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Read HANDOFF.md first.')})
       retiredToolReference=@('MD_RETIRED_REFERENCE: lib/Tool.ps1 names HANDOFF.md',{param($directory) Edit-MarkdownFixture $directory 'lib/Tool.ps1' '# Tool:' '# Tool (reads HANDOFF.md):'})
       retiredPinned=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'The closure text stays at `dbc0fc7:HANDOFF.md`.')})
       retiredHistory=@('',{param($directory) Edit-MarkdownFixture $directory 'changes/WS-001-history.md' '# Frozen history' ('# Frozen history'+$nl+'Read HANDOFF.md first.')})
   ```

   g) replace the line
   ```text
   $budgetLimits=@{'AGENTS.md'=1536;'README.md'=8192;'RESUME.md'=900;'HANDOFF.md'=4500;'WORKFLOW.md'=20300;'docs/DECISIONS.md'=49152}
   ```
   with
   ```text
   $budgetLimits=@{'AGENTS.md'=1536;'README.md'=8192;'RESUME.md'=900;'WORKFLOW.md'=20300;'docs/DECISIONS.md'=49152}
   ```

   h) immediately after the line
   ```text
               duplicate='throw "MD_DUPLICATE_PROSE: $($paragraphs[$normalized]), $path"';staleDate='throw "MD_STALE_DATE: $path"'
   ```
   insert
   ```text
               retiredPresent='throw "MD_RETIRED_PRESENT: $name"';retiredReference='throw "MD_RETIRED_REFERENCE: $path names $name"'
   ```

   i) immediately after the line
   ```text
               frozenCitation=@('Assert-MarkdownCitations $path $text $sections','if(!$frozen){Assert-MarkdownCitations $path $text $sections}')
   ```
   insert
   ```text
               retiredPinned=@('$named=''(?<![0-9a-f]{7}:)(?<![\w./-])''+','$named=''(?<![\w./-])''+')
               retiredHistory=@('if($history.Contains($path)-or$path-clike''changes/WS-*.md''-or$path-clike''docs/history/*''-or','if(')
   ```

   The resulting file's Git blob is 93d73badd3a10478aa459d937c7f7289aee221b8.

13. Check whether `lib/Test-MarkdownConsistency.ps1` contains `$MarkdownActive=@('README.md','WORKFLOW.md','docs/RUNBOOK.md','docs/DECISIONS.md','docs/WORKSPACE-LAYOUT.md','lib/README.md')`; if so record Already Applied when its Git blob is 80bf0616c2428c77132950e85702f492c91f5953, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   $MarkdownActive=@('README.md','WORKFLOW.md','HANDOFF.md','docs/RUNBOOK.md','docs/DECISIONS.md','docs/WORKSPACE-LAYOUT.md','lib/README.md')
   ```
   with
   ```text
   $MarkdownActive=@('README.md','WORKFLOW.md','docs/RUNBOOK.md','docs/DECISIONS.md','docs/WORKSPACE-LAYOUT.md','lib/README.md')
   $RetiredFiles=@('HANDOFF.md')
   ```

   b) replace the line
   ```text
       $budgets=@{'AGENTS.md'=1536;'README.md'=8192;'RESUME.md'=900;'HANDOFF.md'=4500;'WORKFLOW.md'=20300;'docs/DECISIONS.md'=49152}
   ```
   with
   ```text
       $budgets=@{'AGENTS.md'=1536;'README.md'=8192;'RESUME.md'=900;'WORKFLOW.md'=20300;'docs/DECISIONS.md'=49152}
   ```

   c) replace the lines
   ```text
       $expected=@('Arrival','Purpose','Active contract','Batch 6 closure','Decisions and rules','Procedures','Workspace layout','Recovery','Tool catalogue','Contract template')
       $owners=@{'Arrival'='AGENTS.md';'Purpose'='README.md';'Active contract'='RESUME.md';'Batch 6 closure'='HANDOFF.md';'Decisions and rules'='docs/DECISIONS.md';'Procedures'='docs/RUNBOOK.md';'Workspace layout'='docs/WORKSPACE-LAYOUT.md';'Recovery'='docs/RECOVERY.md';'Tool catalogue'='lib/README.md';'Contract template'='changes/TEMPLATE.md'}
   ```
   with
   ```text
       $expected=@('Arrival','Purpose','Active contract','Decisions and rules','Procedures','Workspace layout','Recovery','Tool catalogue','Contract template')
       $owners=@{'Arrival'='AGENTS.md';'Purpose'='README.md';'Active contract'='RESUME.md';'Decisions and rules'='docs/DECISIONS.md';'Procedures'='docs/RUNBOOK.md';'Workspace layout'='docs/WORKSPACE-LAYOUT.md';'Recovery'='docs/RECOVERY.md';'Tool catalogue'='lib/README.md';'Contract template'='changes/TEMPLATE.md'}
   ```

   d) immediately after the line
   ```text
       if($concepts.Count-ne$expected.Count){throw 'MD_HOME_MISSING'}
   ```
   insert
   ```text
       # A retired file (DEC-05) stays absent and is named only at its last commit (`<sha7>:path`); history, records, owner
       # texts and this check keep their words.
       foreach($name in $RetiredFiles){
           if($targets.ContainsKey($name)){throw "MD_RETIRED_PRESENT: $name"}
           $named='(?<![0-9a-f]{7}:)(?<![\w./-])'+[regex]::Escape($name)
           foreach($path in @($files.Keys)+@($tools.Keys)){
               if($history.Contains($path)-or$path-clike'changes/WS-*.md'-or$path-clike'docs/history/*'-or$path-clike'docs/owner/*'-or$path-clike'records/*'-or$path-cin'lib/Test-MarkdownConsistency.ps1','lib/test-markdown-consistency.ps1'){continue}
               $text=if($tools.ContainsKey($path)){$tools[$path]}else{$files[$path]}
               if($text-cmatch$named){throw "MD_RETIRED_REFERENCE: $path names $name"}
           }
       }
   ```

   The resulting file's Git blob is 80bf0616c2428c77132950e85702f492c91f5953.

14. Check whether `lib/test-organize.ps1` contains `foreach($file in 'AGENTS.md','RESUME.md','WORKFLOW.md','tests.ps1','.gitignore','.gitattributes','.githooks/h','.github/g','config/README.md','lib/README.md','lib/Tool.ps1','lib/Organize.ps1','lib/hooks/w.ps1','README.md'){Add-File (Join-Path $wb $file) "# $file`; if so record Already Applied when its Git blob is 3c5ac4cce45688609bde33b9594b4097c0cf182c, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
       foreach($file in 'AGENTS.md','RESUME.md','WORKFLOW.md','HANDOFF.md','tests.ps1','.gitignore','.gitattributes','.githooks/h','.github/g','config/README.md','lib/README.md','lib/Tool.ps1','lib/Organize.ps1','lib/hooks/w.ps1','README.md'){Add-File (Join-Path $wb $file) "# $file`n"}
   ```
   with
   ```text
       foreach($file in 'AGENTS.md','RESUME.md','WORKFLOW.md','tests.ps1','.gitignore','.gitattributes','.githooks/h','.github/g','config/README.md','lib/README.md','lib/Tool.ps1','lib/Organize.ps1','lib/hooks/w.ps1','README.md'){Add-File (Join-Path $wb $file) "# $file`n"}
   ```

   The resulting file's Git blob is 3c5ac4cce45688609bde33b9594b4097c0cf182c.

15. Check whether `lib/test-restore-orvion.ps1` contains `Assert-That 'checklist names the machine inventory and its RECOVERY section (WS-053)' ($r.Output-cmatch'(?m)^ACTION: from the newest .+\\data\\records\\machine\\inventory-<date> reinstall programs.+Machine restore')`; if so record Already Applied when its Git blob is 162c6c6fe87bad80b556abb4a4591eb5a9c4f603, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       $r=Invoke-Scenario claude-list;Assert-That 'checklist obtains injected claude plugin list and suppresses installed commands' ($r.Exit-eq0-and($r.Calls-join' ').Contains('claude plugin list')-and!$r.Output.Contains('claude plugin install ponytail@ponytail'))
   ```
   insert
   ```text
       Assert-That 'checklist names the machine inventory and its RECOVERY section (WS-053)' ($r.Output-cmatch'(?m)^ACTION: from the newest .+\\data\\records\\machine\\inventory-<date> reinstall programs.+Machine restore')
   ```

   The resulting file's Git blob is 162c6c6fe87bad80b556abb4a4591eb5a9c4f603.

16. Check whether `README.md` contains `| the criteria that close the programme | [DEC-05](docs/DECISIONS.md#dec-05-lift-criteria-and-accepted-open-risks) |`; if so record Already Applied when its Git blob is 37e494aa6ee4151739ee772734c651708f897501, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   | the criteria that close the programme | [HANDOFF.md](HANDOFF.md) |
   ```
   with
   ```text
   | the criteria that close the programme | [DEC-05](docs/DECISIONS.md#dec-05-lift-criteria-and-accepted-open-risks) |
   ```

   The resulting file's Git blob is 37e494aa6ee4151739ee772734c651708f897501.

17. Check whether `records/README.md` contains `| WS-052/ | records | Summary of WS-052 delete step and live state route | agents, the owner | 2026-11-28 |`; if so record Already Applied when its Git blob is dba4dd743994a4fbb46748fce6b4f5b9eefb5d93, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-051/ | records | Summary of WS-051 reply form and preview pointer | agents, the owner | 2026-11-26 |
   ```
   insert
   ```text
   | WS-052/ | records | Summary of WS-052 delete step and live state route | agents, the owner | 2026-11-28 |
   ```

   b) replace the lines
   ```text
   | --- | --- | --- | --- | --- |
   | 2026-11-25T21:23:14Z | new | - | records/WS-042 | WS-050 WS-042 summary |
   ```
   with
   ```text
   | --- | --- | --- | --- | --- |
   ```

   c) immediately after the line
   ```text
   | 2026-11-26T19:54:27Z | new | - | records/WS-051 | WS-052 WS-051 summary |
   ```
   insert
   ```text
   | 2026-11-28T08:03:13Z | new | - | records/WS-052 | WS-053 WS-052 summary |
   ```

   d) immediately after the line
   ```text
   - [WS-051/README.md](WS-051/README.md)
   ```
   insert
   ```text
   - [WS-052/README.md](WS-052/README.md)
   ```

   The resulting file's Git blob is dba4dd743994a4fbb46748fce6b4f5b9eefb5d93.

18. Check whether `records/WS-052/README.md` contains `Purpose: Summary of WS-052 delete step and live state route. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is daceec6d2c950724efe357f45e42301a5b4d5a51, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-053 candidate output), and change nothing else:

   ```text
   # WS-052

   Purpose: Summary of WS-052 delete step and live state route. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-28T08:03:13Z | new | - | records/WS-052 | WS-053 WS-052 summary |
   <!-- /organize:changes -->

   # WS-052 delete step and live state route

   Summary of a finished workstream (DEC-11), written in WS-053 by data/records/WS-053/summaries.ps1 from the change
   file, its receipts and the records in data/records/WS-052/; it changes no evidence. Paths that begin with data/ are in
   the data root, which is backed up and not published.
   Evidence: data/records/WS-052/.

   ## Result

   - Change file: changes/WS-052-delete-step-and-live-state-route.md, SHA256 836A475570AA0C3C66C46F48FED1FF51E02BFB5BF1BF6D35C17166C480DB5E0B
   - Status: Complete
   - Verdict: Confirmed Complete
   - Reviewed Fingerprint: 15089E731B6C2AFCC4ABC8218E74E69FA8FD71EF295EEE7470DF6C558EC405E8
   - Reviewed Receipt: FFB851FA6234A8EC8A7AA37CBF9E2BD687AA4767C0EF3E32139C4249B97D57E3
   - Complete commit: dbc0fc7 WS-052: Original Complete with own native receipt

   ## Receipt

   The original own Finish receipt, `data/records/WS-052/receipts/original-own-finish-receipt.json`, SHA256 FA73681BF05D71CA1F738518B6476241906632D890449281E00EA6BA2326BF57; its digest equals the Reviewed
   Receipt above. Copied from `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W52\runtime\original\own-finish-receipt.json`. The sandbox receipt, `data/records/WS-052/receipts/sandbox-own-finish-receipt.json`, SHA256 F9CD6EA54F35FEB3488973C2A39FB114407597B2D69776FAC734EECB228AA89B,
   equals the Sandbox Receipt SHA256 of the change file. Run-start host and other-product names masked (D119):

   ~~~json
   {
     "schema": 2,
     "root": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench",
     "contract": "changes/WS-052-delete-step-and-live-state-route.md",
     "finishHead": "85a83b579ecb5f1b0cd77bd12add9be418dbdbee",
     "fingerprint": "15089E731B6C2AFCC4ABC8218E74E69FA8FD71EF295EEE7470DF6C558EC405E8",
     "profiles": [
       "CONTROL",
       "COORDINATION",
       "REPOSITORY"
     ],
     "evaluator": "e0bf56b4f3dd2f444120bcb96af24f1538b314ea",
     "runLog": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\sb\\W52\\runtime\\original\\finish.log",
     "runStart": "[2026-11-28 00:04:25] START pid=22008 host=[masked] pwsh=7.6.8 cpus=8 head=85a83b5 concurrent=Sync-Sessions.ps1,Run-Stage.ps1,Invoke-ContractLifecycle.ps1,Watch-Host.ps1 | & pwsh -NoProfile -File 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\lib\\Workbench.ps1' -Root 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench' -Finish -Actionlint 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\tools\\actionlint.exe'",
     "result": "READY",
     "draftSHA256": "F8633B4C13B6B9842E880602A9BB70D1532DDF106064875D172F025A95A3AEAE",
     "recipe": "5452D0C7182D969FAA80AAD0DE90CEE6495CAA8968A769D2346F71A00CD9C5B6",
     "role": "ORIGINAL",
     "proof": "615B3F828EB3AC29BFBD624B515402F3F76EFD624BC358F9BD8A33D4EA9709C2",
     "digest": "FFB851FA6234A8EC8A7AA37CBF9E2BD687AA4767C0EF3E32139C4249B97D57E3"
   }
   ~~~

   ## Versions

   | Version | Id | Role and author | SHA256 | Draft check | Chosen |
   | --- | --- | --- | --- | --- | --- |
   | V1 | WS052-V1-CLAUDE-SIGNIFICANT-DESIGN-20261127-01 | DESIGN by Claude main | DC0742DEEE91DF629CC2FDD95217DF85DBE2BEC8CBE78F9611DEA86CAADBBCDA | PASS | no: V3 is the Approved Draft (DEC-13) |
   | V2 | WS052-V2-CLAUDE-SIGNIFICANT-ADVERSARIAL-20261127-01 | ADVERSARIAL by Claude main | 72B6C05331280A64296A917D21EC754EA7CEB9EB944BCB881428477EC52D8C34 | PASS | no: V3 is the Approved Draft (DEC-13) |
   | V3 | WS052-V3-CLAUDE-REFRESH-20261127-01 | REFRESH by Claude main | F8633B4C13B6B9842E880602A9BB70D1532DDF106064875D172F025A95A3AEAE | PASS | yes: the Approved Draft |

   ## Failed, refused, superseded and stopped attempts (0)

   None recorded.

   ## Cited files (16)

   | File | SHA256 |
   | --- | --- |
   | data/records/WS-052/receipts/original-own-finish-receipt.json | FA73681BF05D71CA1F738518B6476241906632D890449281E00EA6BA2326BF57 |
   | data/records/WS-052/receipts/sandbox-own-finish-receipt.json | F9CD6EA54F35FEB3488973C2A39FB114407597B2D69776FAC734EECB228AA89B |
   | data/records/WS-052/assurance/V1/DRAFT.md | DC0742DEEE91DF629CC2FDD95217DF85DBE2BEC8CBE78F9611DEA86CAADBBCDA |
   | data/records/WS-052/assurance/V2/DRAFT.md | 72B6C05331280A64296A917D21EC754EA7CEB9EB944BCB881428477EC52D8C34 |
   | data/records/WS-052/assurance/V3/DRAFT.md | F8633B4C13B6B9842E880602A9BB70D1532DDF106064875D172F025A95A3AEAE |
   | data/records/WS-052/gate/GATE1-WS052-ORIGINAL-DELEGATED.md | 0DC5000F041715649A721662C5CFE132245EA1BFFD44F50CA7CE245DAA615C90 |
   | data/records/WS-052/candidate.patch | C06C497A818E65D5A9EF6A89B5CAFD80F9F2C9E311180275E112A071DC99A603 |
   | data/records/WS-052/CONTRACT.md | 9011F0FF9243A8DEBD1AFDA26CCE8BF428468EE333821AB7ADACA4F2B43D49CB |
   | data/records/WS-052/lifecycle-original.txt | 0D0672BCD6999B04B75A126ED4F51259F8C3C9860544E95B1B4FDFB0060BE6C3 |
   | data/records/WS-052/lifecycle-sandbox.txt | D9CC8305A0DD2DC6714E2ADDA736C53353B599BA118468C64F6B3783F6710753 |
   | data/records/WS-052/Make-Candidate.ps1 | 717DE51FD0D7CA57142257D6107E9D9D29DFDD4118FB6B9CC94C7FDFF8E0808F |
   | data/records/WS-052/manifest.json | F7FA0EB803367408926FF2D41A19729A0F50F4F7987021758DD7F3BCC7D40FB8 |
   | data/records/WS-052/mutants.ps1 | 58A44D432CB2571AB26B51A12125D6438E103B1F2BDADDE93739F1A0ABA36C7D |
   | data/records/WS-052/Preflight.ps1 | AD2DD1D1A46E82A2B511036CAABF93CC62F038C5177D2CF4B7585B9871908D87 |
   | data/records/WS-052/Run-Stage.ps1 | 3C5E0A25CBBC6B7559E93DC1B74335C289DC4D3DF19294536E0341F5214783B3 |
   | data/records/WS-052/summaries.ps1 | 2D7C50E54AD1FFEF132B69DA65C72A229C03DA9CF7FD94DA9FD2AF3F5572D28A |
   ```

   The resulting file's Git blob is daceec6d2c950724efe357f45e42301a5b4d5a51.

19. Check whether `WORKFLOW.md` contains `- Programme closure criteria and the Lift: DEC-05.`; if so record Already Applied when its Git blob is 7b4b964da4ac80b2d047d869ef6f9a866ba2ee9b, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-053 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   - Records and evidence storage: DEC-11.
   ```
   insert
   ```text
   - Programme closure criteria and the Lift: DEC-05.
   ```

   b) replace the lines
   ```text
   | Active contract | [RESUME](RESUME.md) |
   | Batch 6 closure | [HANDOFF](HANDOFF.md#12-success-criteria-before-the-programme-closes-and-batch-6-resumes) |
   ```
   with
   ```text
   | Active contract | [RESUME](RESUME.md) |
   ```

   The resulting file's Git blob is 7b4b964da4ac80b2d047d869ef6f9a866ba2ee9b.

## Acceptance Criteria

- [x] Output `changes/README.md` equals its declared resulting Git blob. check: blob:changes/README.md=6ff70870f3b7d0493f0da1d20b0da4666bea4f2a
- [x] Output `docs/DECISIONS.md` equals its declared resulting Git blob. check: blob:docs/DECISIONS.md=0dae778e63553ebf1a5119dd2b8715c2d90133ee
- [x] Output `docs/history/LOG.tsv` equals its declared resulting Git blob. check: blob:docs/history/LOG.tsv=c4c0b24739c257ae15cb781878fb8cb32189c684
- [x] Output `docs/RECOVERY.md` equals its declared resulting Git blob. check: blob:docs/RECOVERY.md=a29ca2b641a20867b94ca171491e1e4bce8d94ed
- [x] Output `docs/WORKSPACE-LAYOUT.md` equals its declared resulting Git blob. check: blob:docs/WORKSPACE-LAYOUT.md=b0aff342eaa7a251e723d8b1030535c7159f47d7
- [x] Output `lib/Backup-Workspace.ps1` equals its declared resulting Git blob. check: blob:lib/Backup-Workspace.ps1=575f78c04b80c2fff6513cc07c8f010ba9d451a5
- [x] Output `lib/Organize.ps1` equals its declared resulting Git blob. check: blob:lib/Organize.ps1=e6b7ee50cc429f8bfd25db42b39bab3b711f53f3
- [x] Output `lib/README.md` equals its declared resulting Git blob. check: blob:lib/README.md=2406230ab665ed939fe877c975f861a79e5bb662
- [x] Output `lib/Restore-ORVION.ps1` equals its declared resulting Git blob. check: blob:lib/Restore-ORVION.ps1=0bdf2e74deb6c7ecf1f4d457fee50de7172198f2
- [x] Output `lib/test-backup-restore.ps1` equals its declared resulting Git blob. check: blob:lib/test-backup-restore.ps1=1a9bae3a3817c551a3fcc5c6579a62183f6ffb3e
- [x] Output `lib/test-markdown-consistency.ps1` equals its declared resulting Git blob. check: blob:lib/test-markdown-consistency.ps1=93d73badd3a10478aa459d937c7f7289aee221b8
- [x] Output `lib/Test-MarkdownConsistency.ps1` equals its declared resulting Git blob. check: blob:lib/Test-MarkdownConsistency.ps1=80bf0616c2428c77132950e85702f492c91f5953
- [x] Output `lib/test-organize.ps1` equals its declared resulting Git blob. check: blob:lib/test-organize.ps1=3c5ac4cce45688609bde33b9594b4097c0cf182c
- [x] Output `lib/test-restore-orvion.ps1` equals its declared resulting Git blob. check: blob:lib/test-restore-orvion.ps1=162c6c6fe87bad80b556abb4a4591eb5a9c4f603
- [x] Output `README.md` equals its declared resulting Git blob. check: blob:README.md=37e494aa6ee4151739ee772734c651708f897501
- [x] Output `records/README.md` equals its declared resulting Git blob. check: blob:records/README.md=dba4dd743994a4fbb46748fce6b4f5b9eefb5d93
- [x] Output `records/WS-052/README.md` equals its declared resulting Git blob. check: blob:records/WS-052/README.md=daceec6d2c950724efe357f45e42301a5b4d5a51
- [x] Output `WORKFLOW.md` equals its declared resulting Git blob. check: blob:WORKFLOW.md=7b4b964da4ac80b2d047d869ef6f9a866ba2ee9b
- [x] RESUME routing equals the baseline after native pointer normalization only. check: normalized-resume:RESUME.md=02B311D60DE22D03224E0B64BA88124E5C7731FB4DC49BC67E8A05E22875B010
- [x] AC-01 Behaviour: HANDOFF.md (0/40) is deleted by the one Delete step at its baseline blob 3e5875c6fb68dab0559d1c81ba8e2068cf062c60 and is absent after both applies; the second apply reports every step Already Applied. Its readers move to their one home and change only those lines: README.md (1/1) repoints its closure row to DEC-05; WORKFLOW.md (1/1) drops its Batch 6 closure home row and names DEC-05 in its section 1 pointer list; docs/DECISIONS.md (6/4) keeps DEC-05's Lift as decided, pins the closure criteria and the Lift line at `dbc0fc7:HANDOFF.md` sections 11-12 (which resolves in the repository to that blob) and drops it from the active-document list; docs/WORKSPACE-LAYOUT.md (3/4) drops it from the tree, the retention row and the kept-names row; lib/Organize.ps1 (1/1) drops it from the workbench router's required files. lib/Test-MarkdownConsistency.ps1 (16/4) adds `$RetiredFiles=@('HANDOFF.md')`, drops HANDOFF.md from its active list, byte budget and home owner, fails MD_RETIRED_PRESENT if the file returns and MD_RETIRED_REFERENCE if an active file or tool names it outside a `<sha7>:path` pin, with history, changes/WS-*.md, docs/owner, records and the check itself exempt; on the replay it passes with this contract in place and refuses MD_RETIRED_PRESENT: HANDOFF.md when the baseline bytes are put back. lib/Backup-Workspace.ps1 (65/0) adds only Save-MachineInventory and its one call with -Package: a masked machine inventory in records\machine\inventory-<UTC date> of the data root, written through a .partial folder and a move, a day already written reused, TEMP isolated in a private folder removed after, MCP env and header values, token shapes, URL passwords, key query values and secret-named environment values never recorded, each source listed in inventory-status.tsv. docs/RECOVERY.md (23/2) adds "## Machine restore"; lib/Restore-ORVION.ps1 (2/1) prints one ACTION line naming the newest inventory and its C2 line names DEC-05 and docs/RECOVERY.md instead of HANDOFF.md; lib/README.md (1/1) changes only the Backup-Workspace row, which names the inventory. RESUME.md has no step.
- [x] AC-02 Summaries, tests and documentation: records/WS-052/README.md (95/0) is the WS-052 summary holding its Organize header, and records/README.md (3/1) and docs/history/LOG.tsv (1/0) hold exactly the Files line and LOG row Organize -New and -Refresh write for it under WS-053, no earlier row changed; no summary holds the owner's e-mail, the computer name or an unmasked run-start host. lib/test-markdown-consistency.ps1 (14/8) moves its fixtures off HANDOFF.md and adds exactly five retired-file cases (present, reference, tool reference, pinned, history); lib/test-backup-restore.ps1 (12/1) seeds a machine inventory for its repeat packages and checks that the first package writes one inventory with its status table and masks a run-time token-shaped MCP value everywhere; lib/test-restore-orvion.ps1 (1/0) checks the ACTION line; lib/test-organize.ps1 (1/1) drops HANDOFF.md from its fixture; no existing check is removed or weakened. Four production mutants on the replay must each make their owning test fail at the named case, and the Draft check must kill all four and restore the bytes: INVENTORYMASK (an MCP env value recorded unmasked; test-backup-restore, first FAIL 'the inventory masks MCP env, headers, token prefixes, URL passwords and key query values'), RESTOREACTION (the inventory ACTION line not printed; test-restore-orvion, first FAIL 'checklist names the machine inventory and its RECOVERY section (WS-053)'), RETIREDLIST (the retired list emptied; test-markdown-consistency, first FAIL retiredPresent expecting MD_RETIRED_PRESENT: HANDOFF.md) and ROUTERLIST (HANDOFF.md required again by the workbench router; test-organize, first FAIL 'a complete workspace passes'). test-backup-restore, test-restore-orvion (with an absolute scratch data root), test-markdown-consistency and test-organize pass on the replay. Organize -Check -Quick on the replay with this contract in place (temporary and data roots isolated and absent) prints no NO_SUMMARY finding, also with this contract marked Complete; with it marked Complete and records/WS-052/README.md removed it prints exactly NO_SUMMARY workbench:records/WS-052; the removed bytes come back.
- [x] AC-03 Organizer: changes/README.md (1/0) is what lib/Organize.ps1 -Refresh writes: it holds the WS-053 row, and a refresh of the replay with this contract in place changes no organizer. The replay's test and hazard schedule equals the baseline's.
- [x] AC-04 Secrets and privacy: gitleaks on the exact candidate range reports no finding in the 18 outputs; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; neither masked value (the computer name, a marketing tunnel script name) nor the owner's e-mail is in any changed file or in this contract; the machine inventory records no secret value in any form (AC-01, AC-02).
- [x] AC-05 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step (HANDOFF.md deleted, every other output to its declared blob, RESUME.md only through the native pointer), one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria; the scope profiles run the owning tests of every changed file. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json. From each Finish launch to END: no Events -Add, Save-State or edit in a protected root, and Docker off.
- [x] AC-06 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-053/evidence/protected-before.json, captured before the sandbox Finish and again after Original Complete with data/records/WS-038/Capture-Protected.ps1; lib/Test-WorkbenchChange.ps1, lib/Workbench.ps1, lib/Invoke-ContractLifecycle.ps1 and lib/apply-draft-steps.ps1 are unchanged and both roles ran the baseline tools of dbc0fc7; HANDOFF.md is the only tracked file deleted; CRM, ORVION and their trusted copies keep their HEAD and files (the lifecycle's protected-root compare); no Supabase project is touched; no Codex, subagent, RAM, power setting, environment variable or scheduled task change; no push before both roles are Complete.

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
Approved Draft: c:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-053\assurance\V3\DRAFT.md
Approved SHA256: E8E88438637F21BEBC0ABB64A88E18ACC3A5C7520B1EAE52F48B5707F52F840E
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-053\gate\GATE1-WS053-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: 1CF18470D949FFD468B0D402AEFEDE0B7DB0BAF67B752555BD91758EC7844F9D
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W53\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 3869136AA8E60C7C36B75A01E89E9E9B8B25B93D55FAD60F5EFC04091A785788
Original exact declared outputs (18 file steps and the HANDOFF.md Delete step) applied by accepted native Execute; fresh own Finish and Review/Complete remain required. Other protected roots unchanged. Controller: the baseline lib/Invoke-ContractLifecycle.ps1 of dbc0fc7 (SHA256 B10AF598), unchanged by this contract and run in place by both roles, checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority.
Residual risks carried unchanged from the selected Draft Review Gate and data/records/WS-053/CONTRACT.md; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (D120, frozen in data/records/WS-034/owner-words), not by unavailability. Controller: the baseline lib/Invoke-ContractLifecycle.ps1 of dbc0fc7 (SHA256 B10AF598), unchanged by this contract and run in place by both roles, checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority. Release is a later stage (DEC-25), after Original Complete and the retro.

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W53-c4 (data/records/WS-053/Make-Candidate.ps1). Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json beside this Draft. The WS-052 summary's facts come from raw records (data/records/WS-053/summaries.ps1). After Complete, outside this contract: the release under DEC-25 on the DELEGATED record, only when every gate passed and Claude main's retro is satisfied; the protected state is compared with its record from before; one real -Package backup proves the inventory on the machine; the memory pointers to HANDOFF.md move; Save-State records the result.
Verdict: Confirmed Complete
Reviewed Fingerprint: FD98D93526FCEFDA0520EE564C11EEF58BD9153B8A41ADFC5EB24A41F786F675
Reviewed Receipt: B90BD4C17D9A1AEE8FAA4FE155C474FBCE1A3B1B10CA68047B5543392BCDDB7A
Live ORIGINAL-role review: runtime/original/criterion-review.json. Own Finish 32 ordered suites, runner/watcher/host 0/0/0, real journal unchanged. Review: ONE Claude-main SELF-REVIEW, not independent; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (D120, frozen in data/records/WS-034/owner-words), not by unavailability. Exact completed sandbox proof E51C1E6FB8D84591297B2C95E54173EDDBB5AAC533FC85641CC9649296C2BF86 bound. Not pushed; the one release (DEC-25) follows only on every gate passed and the retro, under the owner's request and AFK Mode (DELEGATED).

