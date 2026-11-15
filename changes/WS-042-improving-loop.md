# Workbench Change Request - WS-042

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Land the four approved Improving Loop items, with the scope of data/records/WS-042/CONTRACT.md section 3. G1: the token ledger moves into Git-tracked lib/Token-Ledger.ps1, incremental by each session's byte size and with no slice-cost step; lib/Save-State.ps1 prints its latest row as one `tokens:` line only after NOW.md and the continuity copy are whole and only where `<data root>\records\token-ledger.tsv` exists, and any ledger failure is one `TOKEN_LEDGER_SKIPPED` line that never changes the save or its exit. C: a second, separate SessionStart hook, lib/hooks/Load-Constitution.ps1 in .claude/settings.json, prints DEC-30 and DEC-33 (rules 1-12) whole and the ID and title of every other decision from docs/DECISIONS.md on startup, clear, resume and compact alike, adds the lib/README.md Always section only in a new context (startup, clear, no source), stays within 9,500 characters, is silent only when the project directory Claude Code names (else the event's cwd) is not the Workbench, and prints one `CONSTITUTION NOT LOADED` line telling the agent to read the rules itself when anything cannot be loaded; lib/hooks/Watch-Reminder.ps1 keeps NOW.md and Pulse and no longer prints the tool guidance, so the two hooks never duplicate. G3: #18 folds into DEC-31 (the owner is never asked to open a terminal; a blocked agent hands over a ready script and one line); D130 in docs/history/DECISIONS-ARCHIVE.md, with its map row, holds DEC-31's replaced wording and #18's words and the ~22:04 G3 line verbatim (DEC-01 archives the words of a decision that changes an entry) and lists the 16 verified settled entries, which change no entry, by date and DEC home with their verbatim frozen copy (the D128 and D129 practice); the eight pending entries stay. D: verified durable knowledge that lived only in Claude memory moves to its existing tracked home: RUNBOOK sections 7, 9 and 11, WORKSPACE-LAYOUT and lib/README. changes/README.md gets the WS-042 row Organize -Refresh writes. Benefit: every session, an old one resumed included, starts with the constitution from its one authoritative file; each save shows the session's token row (DEC-18); the inbox drops from 25 to 8 pending entries; a fresh clone holds every verified lesson.

Tier: Significant under DEC-12 (a new permanent SessionStart control in the tracked settings, a change to Save-State's recovery path and DEC-31's text). Governance check: every consumer listed (CONTRACT.md section 3) and the Markdown guard; every new or changed test runs once with its test root outside any ORVION-Workbench-temporary folder; a retro closes the workstream. Authority: DEC-01, DEC-02, DEC-08, DEC-09, DEC-12, DEC-13, DEC-14, DEC-18, DEC-23, DEC-24, DEC-25, DEC-26, DEC-30, DEC-31 and DEC-33; the owner's words of 2026-11-14 ~21:15 Cairo (approved direction), ~21:43 (feedback) and ~22:04 ("Owner Decision - Improving Loop Significant Contract": G1, C, G3 and D exactly; bare "update" and Administrator NOT APPROVED, so nothing is written for them; Docker only within existing authorized scope; "Proceed in Run Mode 1 through the approved contract"), frozen verbatim in data/records/WS-042/owner-words/ (SHA256 75A38D58643981C453AE7F8BB37A35C0806E77698E41023474F4693446802228, 6AB430B3804F3A2400C4F4E389542D023F57625D9323A7C68E00465A0CA6B9E8 and DC344EE74A7122CF97F43EC45EE797FDD89B70C6D19ACD7D77B3A88BC2A24180), and the inbox as read for G3 in decisions-inbox-20261114T2210.md (SHA256 617EE95E8C0D47E11AD2C35511D4F4B49FF4D2FC973876CD51FDB0504D8C3DC6). Every scope choice is Claude main's under that authority, labelled DELEGATED; no owner text is typed by an agent (DEC-02).

Number: WS-042. Intended contract: changes/WS-042-improving-loop.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: this contract changes neither lib/Invoke-ContractLifecycle.ps1 nor the accepted evaluator, so both roles run the Original's own baseline controller, its SHA256 checked before each stage, with the accepted judge. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

dde2009ce6b05c5296b02c53a0d92eaf0efd6193

## Write Scope

- .claude/settings.json
- changes/README.md
- docs/DECISIONS.md
- docs/history/DECISIONS-ARCHIVE.md
- docs/history/DECISIONS-MAP.tsv
- docs/RUNBOOK.md
- docs/WORKSPACE-LAYOUT.md
- lib/hooks/Load-Constitution.ps1
- lib/hooks/Watch-Reminder.ps1
- lib/README.md
- lib/Save-State.ps1
- lib/test-save-state.ps1
- lib/test-token-ledger.ps1
- lib/test-watch-reminder.ps1
- lib/Token-Ledger.ps1
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Organize.ps1, lib/Events.ps1, lib/Guard-Write.ps1, tests.ps1 and every other lib/ file, test and hook; every DEC entry but DEC-31; the user settings in the owner's profile (Watch-Reminder stays registered there, unchanged); G2, G4, G5 and every settings or connector change beyond the one SessionStart entry; any permission for a bare "update" or for running as Administrator; data/ (untracked: the inbox fold, the ledger table's move, status-page.ps1 and the Claude memory pointers follow after Complete, outside this contract); the seven legacy folders, Owner-Tools, the vault and every package; any CRM or ORVION change (DEC-08), credentials, real sessions or events (DEC-09); Batch 6 slice 11 (on hold); Codex, subagents, RAM, power or scheduled-task changes; any push or release before both roles are Complete (DEC-25).

## Draft Assurance

V1: WS042-V1-CLAUDE-SIGNIFICANT-DESIGN-20261115-01 | 2026-11-15 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-042\assurance\V1\DRAFT.md | 480CA8DADB34EDF0A74F34AD31F4F74CD98B3558D0BEEF082A1A0CF20E222A66
V2: WS042-V2-CLAUDE-SIGNIFICANT-ADVERSARIAL-20261115-01 | 2026-11-15 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-042\assurance\V2\DRAFT.md | F24546F04FF3C49C51017D2FA123EBE0FA0E882D0704D4C7533E3EFFAE27ECF2
V3: WS042-V3-CLAUDE-REFRESH-20261115-04 | 2026-11-15 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-042\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V3 REFRESH by Claude main, claude-opus-5-5, under D120: the owner skipped Codex and subagents on 2026-11-08 ~01:20 Cairo, standing (the owner's words verbatim in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md; D124 wrote D120 into DEC-14 and DEC-19). Codex skipped by owner decision, not by unavailability. No Codex work is claimed and nothing here is independent. This is the fourth V3 freeze. The first (030FD733) was refused at the sandbox native Execute with WB_CONTEXT_EXECUTABLE_VERSION_MISMATCH (superseded-attempt1-git-version\WHY.txt). The second (13B93C2B) completed the sandbox Finish but was refused at inspect with LIFECYCLE_SCHEDULE_CHANGED, because the controller at baseline 22fbf84 refused any change of the test or hazard schedule and WS-042 adds new scripts by design; nothing ran in the Original and nothing was certified (superseded-attempt2-schedule\WHY.txt). WS-043 (owner reply "B", 2026-11-15 ~06:05 Cairo) fixed that controller with a predicted tree and was released as main fcf5649. The third (C97C7F91) completed the sandbox (Complete 66e9da7) but its Original Finish failed in test-backup-restore on a baseline race in Write-BackupStatus, not in a WS-042 output; nothing was certified or pushed (superseded-attempt4-backup-race\WHY.txt). WS-044 (owner reply "A", 2026-11-15 ~14:10 Cairo) fixed that writer; its candidate dde2009 reaches main by its own DEC-25 release before this V3's sandbox prepare. This V3 is made on the new baseline dde2009 (origin main and the Original HEAD, clean tree; pinned pwsh 7.6.8, git 2.56.1) from candidate cx\W42-c5, built by Make-Candidate.ps1 from candidate-V5.patch (a 3-way refresh of candidate-V4.patch); the 15 changes and their sizes are unchanged from V2, the tree differs only by the baseline. Check-Draft now also proves that the completion is feasible on the baseline's own controller (schedule block); the owning tests run fresh on this tree.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W42\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W42\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W42\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W42\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.56.1.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none. PowerShell 7.6.8 is the portable host in ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8, which WS-034, WS-040 and WS-041 ran.

1. Check whether `.claude/settings.json` contains `"SessionStart": [`; if so record Already Applied when its Git blob is 31b1e98bab4725abf474950b2c0772595890ea75, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-042 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
     "hooks": {
   ```
   insert
   ```text
       "SessionStart": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "pwsh -NoProfile -File \"$CLAUDE_PROJECT_DIR/lib/hooks/Load-Constitution.ps1\"",
               "timeout": 20
             }
           ]
         }
       ],
   ```

   The resulting file's Git blob is 31b1e98bab4725abf474950b2c0772595890ea75.

2. Check whether `changes/README.md` contains `| WS-042-improving-loop.md | contracts | Workbench Change Request - WS-042 | - | - |`; if so record Already Applied when its Git blob is 6c55359c782dd1a6bc57cf76cba2c18944ad899a, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-042 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-041-commit-retry-and-ws033-summary.md | contracts | Workbench Change Request - WS-041 | - | - |
   ```
   insert
   ```text
   | WS-042-improving-loop.md | contracts | Workbench Change Request - WS-042 | - | - |
   ```

   The resulting file's Git blob is 6c55359c782dd1a6bc57cf76cba2c18944ad899a.

3. Check whether `docs/DECISIONS.md` contains `it never re-describes what the owner already knows. The owner is never asked to open a terminal or follow GUI steps: an`; if so record Already Applied when its Git blob is 01685309f1b570b273ab3e26a2dff4e112bc15d1, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-042 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   it never re-describes what the owner already knows.
   ```
   with
   ```text
   it never re-describes what the owner already knows. The owner is never asked to open a terminal or follow GUI steps: an
   agent blocked on the owner's machine hands over a ready script and one line saying what it does.
   ```

   b) replace the lines
   ```text
   Why: the owner's instructions of 2026-10-26 and 2026-10-31, and the constitution's "no reports that produce reports".
   Changed: 2026-11-01
   History: D106
   ```
   with
   ```text
   Why: the owner's instructions of 2026-10-26, 2026-10-31 and 2026-11-14, and the constitution's "no reports that produce reports".
   Changed: 2026-11-14
   History: D106, D130
   ```

   The resulting file's Git blob is 01685309f1b570b273ab3e26a2dff4e112bc15d1.

4. Check whether `docs/history/DECISIONS-ARCHIVE.md` contains `## D130 2026-11-14 WS-042: the decisions inbox folded; DEC-31 takes the ready-script line`; if so record Already Applied when its Git blob is 253e61cb323c1a52ce4f0a10fb76c06870fbd583, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-042 candidate output), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
   > 12. Fix, never skip: fix each error, gap or failed check at its root now; defer only out-of-scope, unsafe or owner fixes (owner, trigger); lesson each mistake, guard a repeat; finish before expanding.

   Now in: DEC-33
   ```
   insert
   ```text

   ## D130 2026-11-14 WS-042: the decisions inbox folded; DEC-31 takes the ready-script line

   The owner's words of 2026-11-14, verbatim from data/decisions-inbox.md (~12:00 Cairo):

   > you said "I'll record this as a lesson, so a future agent blocked like this hands you a ready script."
   > make sure you record it in repo memory for other agants as well not only yours. dont build another memory for repo but search where repo memory set and update it

   The owner's approval of the fold, 2026-11-14 ~22:04 Cairo, verbatim:

   > - **G3:** Archive the 16 verified settled entries, fold #18 into DEC-31, and preserve the eight pending entries. Follow DEC-01 exactly, including owner wording, historical evidence, and checks.

   The lesson becomes a line of DEC-31, which every agent reads. The 16 settled entries change no entry and leave the
   inbox as WS-040 left its executed approvals: 2026-11-11 ~18:20 (rule 5 conditions, in DEC-33 rule 8), ~19:27, ~19:40
   (verify before adding, DEC-33 rules 1 and 11), ~21:25 and ~23:35; 2026-11-12 ~08:00, ~08:45 (fix first and move on,
   DEC-33 rule 12), ~08:50, ~12:20, ~13:27, ~17:02 and 18:38-19:07; 2026-11-14 after 10:14 (fix flaws found, DEC-33 rule
   12), ~11:30 and ~11:45 (status pages, DEC-29) and ~12:30 (no rotation, batch6 PLAN section 10). They and the ~12:00
   entry above are verbatim in data/records/WS-042/owner-words/decisions-inbox-20261114T2210.md (SHA256 617EE95E...).

   Replaced wording of DEC-31, verbatim (the rest of the entry stands):

   > it never re-describes what the owner already knows.
   >
   > Scope: every message to the owner, from every agent.
   > Why: the owner's instructions of 2026-10-26 and 2026-10-31, and the constitution's "no reports that produce reports".
   > Changed: 2026-11-01
   > History: D106

   Now in: DEC-31
   ```

   The resulting file's Git blob is 253e61cb323c1a52ce4f0a10fb76c06870fbd583.

5. Check whether `docs/history/DECISIONS-MAP.tsv` contains `D130	2026-11-14	DEC	DEC-31	WS-042: inbox folded, 16 settled entries removed; DEC-31 never asks the owner to open a terminal, a blocked agent hands a ready script`; if so record Already Applied when its Git blob is 72940a6112f7777a18e831e273b60681c0f4415e, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-042 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   D129	2026-11-11	DEC	DEC-01 DEC-28 DEC-30 DEC-33	WS-040: DEC-33 rules 1-3, 6-9 and 12 amended from Batch 6; DEC-03 retired into rules 1-3; batch-scoped rules; guard at the source; ACI in DEC-30
   ```
   insert
   ```text
   D130	2026-11-14	DEC	DEC-31	WS-042: inbox folded, 16 settled entries removed; DEC-31 never asks the owner to open a terminal, a blocked agent hands a ready script
   ```

   The resulting file's Git blob is 72940a6112f7777a18e831e273b60681c0f4415e.

6. Check whether `docs/RUNBOOK.md` contains `("positional parameter cannot be found", 2026-11-14).`; if so record Already Applied when its Git blob is 28f4089544ef85fe895f346c34ee59cf3da6bde6, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-042 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
     A host-killed heavy run restarts only as DEC-23 allows.
   ```
   insert
   ```text
   - An array never crosses `pwsh -File`: it arrives as one string. Lifecycle Run-Stage stages exited 1 that way in
     WS-037 and WS-038 (event run-stage-array-via-file): pass one stage per call, or use `-Command` with a real array.
   - Call Save-State in-process (`& .\lib\Save-State.ps1`): through `-File` its `-Evidence` and `-Question` arrays fail
     ("positional parameter cannot be found", 2026-11-14).
   ```

   b) immediately after the lines
   ```text
   5. Reversibility: what undoing each option would cost.

   ```
   insert
   ```text
   Before asking, use what the owner already settled:

   - Session usage is not readable from VS Code (the status line does not run there): ask the owner for it.
   - GitHub has two gh accounts, PlatPlusHub (CRM and Workbench) and Shehabhub (ORVION). Check one with
     `GH_TOKEN=$(gh auth token --user <account>) gh api user -q .login`; an authentication refusal most likely means an
     expired token, so the owner regenerates it.
   - Docker (owner 2026-11-14): start or stop only the project-owned stack an already approved operation needs, by that
     product's own commands (DEC-08), leaving unrelated containers and services as they are. Never prune, delete
     volumes, reset destructively or touch another project; nothing here is a standing privilege beyond that.

   ```

   c) replace the line
   ```text
   pwsh -NoProfile -File lib/Save-State.ps1 -Operation '<operation>' -Done '<what finished>' -Evidence '<path>','<path>' `
   ```
   with
   ```text
   & .\lib\Save-State.ps1 -Operation '<operation>' -Done '<what finished>' -Evidence '<path>','<path>' `
   ```

   d) replace the line
   ```text
     and the other three go to the owner unchanged, carrying the first sentence of Next. The data root is `ORVION_DATA_ROOT`, else the checkout's `data/`;
   ```
   with
   ```text
     and the other three go to the owner unchanged, carrying the first sentence of Next. One line comes before them when
     the data root holds `records/token-ledger.tsv`: `tokens:` from `lib/Token-Ledger.ps1`, or `TOKEN_LEDGER_SKIPPED`,
     which never changes the save. The data root is `ORVION_DATA_ROOT`, else the checkout's `data/`;
   ```

   The resulting file's Git blob is 28f4089544ef85fe895f346c34ee59cf3da6bde6.

7. Check whether `docs/WORKSPACE-LAYOUT.md` contains `| save and recover | Save-State (new), Token-Ledger, Sync-Sessions, Backup-Workspace, Restore-Workspace, Restore-ORVION |`; if so record Already Applied when its Git blob is 04fd219a7717164b6cb001ddf298fbe97ce1e0ec, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-042 candidate output), each matched once, and change nothing else:

   a) replace the lines
   ```text
   | save and recover | Save-State (new), Sync-Sessions, Backup-Workspace, Restore-Workspace, Restore-ORVION |
   | watch long runs | run_timed, watch_run, Watch-Host, Watch-Subagents, hooks/Watch-Reminder |
   ```
   with
   ```text
   | save and recover | Save-State (new), Token-Ledger, Sync-Sessions, Backup-Workspace, Restore-Workspace, Restore-ORVION |
   | watch long runs | run_timed, watch_run, Watch-Host, Watch-Subagents, hooks/Watch-Reminder, hooks/Load-Constitution |
   ```

   b) immediately after the lines
   ```text
   through its `records/WS-<NN>/README.md`.

   ```
   insert
   ```text
   The Supabase MCP servers are named by project and access: `supabase-primary` (CRM, Primary vrvtsxexkiiiivlkdxzp) and
   `supabase-secondary` (ORVION, Secondary brplkqmbzffpxqgkkdzo) are read-only; writes go through `supabase-primary-write`
   and `supabase-secondary-write`, whose `execute_sql` and `apply_migration` ask the owner. The claude.ai Supabase
   connector reaches the Secondary account only. An MCP server added during a session loads only in a new session.

   ```

   The resulting file's Git blob is 04fd219a7717164b6cb001ddf298fbe97ce1e0ec.

8. Check whether `lib/hooks/Load-Constitution.ps1` contains `# SessionStart hook: the constitution in every context. On startup, clear, resume and compact alike it prints DEC-30 and`; if so record Already Applied when its Git blob is eefb8432d95340f7d8aa6167b7a9488db447aad0, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-042 candidate output), and change nothing else:

   ```text
   # SessionStart hook: the constitution in every context. On startup, clear, resume and compact alike it prints DEC-30 and
   # DEC-33 of docs/DECISIONS.md whole and the ID and title of every other decision, so no context (an old session resumed
   # included) starts without them; only in a new context (startup, clear, or a client that sends no source) it adds the
   # Always section of lib/README.md. Watch-Reminder.ps1 prints NOW.md and Pulse and never this text. Silent outside the
   # Workbench root, judged by the project directory Claude Code names (CLAUDE_PROJECT_DIR), else the event's cwd, so a
   # session whose shell has moved elsewhere still gets it. A missing section or rule, or text over its bound, prints one
   # line telling the agent to read the rules itself before any governed decision. Reads the hook event from stdin; never
   # blocks and exits 0.
   $ErrorActionPreference='Stop'
   $lib=Split-Path $PSScriptRoot -Parent;$workbench=Split-Path $lib -Parent
   $retrieve="CONSTITUTION NOT LOADED: read $workbench\docs\DECISIONS.md DEC-30 and DEC-33 in full now, before any governed decision"
   try{
       $e=try{$raw=[Console]::In.ReadToEnd();if($raw.Trim()){$raw|ConvertFrom-Json}}catch{$null}
       $cwd=if($env:CLAUDE_PROJECT_DIR){$env:CLAUDE_PROJECT_DIR}elseif($e.cwd){"$($e.cwd)"}else{(Get-Location).Path}
       if([IO.Path]::GetFullPath($cwd).TrimEnd('\')-ne[IO.Path]::GetFullPath($workbench).TrimEnd('\')){exit 0}
       $text=[IO.File]::ReadAllText((Join-Path $workbench 'docs\DECISIONS.md'))-replace'\r?\n',"`n"
       # A section runs from its "## DEC-NN Title" heading to the next "## " heading or the end of the file (DEC-32).
       $dec30=[regex]::Match($text,'(?ms)^## DEC-30 .*?(?=\n## |\z)').Value.TrimEnd()
       $dec33=[regex]::Match($text,'(?ms)^## DEC-33 .*?(?=\n## |\z)').Value.TrimEnd()
       $missing=@(if(!$dec30){'DEC-30'};if(!$dec33){'DEC-33'}else{foreach($n in 1..12){if($dec33-notmatch"(?m)^$n\. "){"DEC-33 rule $n"}}})
       if($missing){"$retrieve (not found: $($missing-join', '))."; exit 0}
       $others=@([regex]::Matches($text,'(?m)^## (DEC-\d+ .+)$')|ForEach-Object{$_.Groups[1].Value}|Where-Object{$_-notmatch'^DEC-3[03] '})
       $constitution="THE CONSTITUTION, from $workbench\docs\DECISIONS.md (decide by it):`n$dec30`n`n$dec33`n`nOther decisions in force (read the one a decision touches): $($others-join'; ')."
       $pointer="Tool guidance abbreviated; see $lib\README.md section 4."
       $guidance=$pointer
       if(!$e.source-or$e.source-in'startup','clear'){
           $md=[IO.File]::ReadAllText((Join-Path $lib 'README.md'))-replace'\r?\n',"`n"
           $always=[regex]::Match($md,'(?ms)^## (?:\d+\. )?Always\b.*?(?=\n## |\z)').Value.TrimEnd()  # found by title, with or without its ID (DEC-32)
           $guidance=if($always){$always.Replace('<lib>',$lib)}else{"Tool guidance UNREADABLE: no Always section in $lib\README.md; read it."}
       }
       # 9500: under the 10,000-character hook output cap; the tool guidance gives way first, the constitution is never cut.
       if($constitution.Length+1+$guidance.Length-gt9500){$guidance=$pointer}
       if($constitution.Length+1+$guidance.Length-gt9500){"$retrieve (over the 9500-character bound)."; exit 0}
       "$constitution`n$guidance"
   }catch{"$retrieve (the hook failed)."}
   exit 0
   ```

   The resulting file's Git blob is eefb8432d95340f7d8aa6167b7a9488db447aad0.

9. Check whether `lib/hooks/Watch-Reminder.ps1` contains `#   SessionStart          -> prints NOW.md and Pulse (after compact: short); Load-Constitution.ps1 prints the rules and tools`; if so record Already Applied when its Git blob is 981e25caffa82654e07874e5d5aa0b22edee9476, and otherwise stop and report. Otherwise make exactly these 5 edits (land this exact frozen WS-042 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   #   SessionStart          -> prints NOW.md, the tool index (lib\README.md, "Always" section) and Pulse (after compact: short)
   ```
   with
   ```text
   #   SessionStart          -> prints NOW.md and Pulse (after compact: short); Load-Constitution.ps1 prints the rules and tools
   ```

   b) replace the lines
   ```text
           if(!$workbenchEntry){exit 0} # archival preserves knowledge; it never enrolls a native session in Workbench
           $md=[IO.File]::ReadAllText((Join-Path $lib 'README.md'))
           $always=[regex]::Match($md,'(?ms)^## (?:\d+\. )?Always\b.*?(?=\n## |\z)').Value  # found by title, with or without its ID (DEC-32)
   ```
   with
   ```text
           if(!$workbenchEntry){exit 0} # archival preserves knowledge; it never enrolls a native session in Workbench
   ```

   c) replace the lines
   ```text
           # The tool index and the full Pulse only in a new context (startup, /clear, or a client that sends no source); after
           # compact, resume or fork a pointer and the short Pulse. The hook's own UNREADABLE messages are never shortened.
   ```
   with
   ```text
           # The full Pulse only in a new context (startup, /clear, or a client that sends no source); after compact, resume or
           # fork the short Pulse. The hook's own UNREADABLE messages are never shortened.
   ```

   d) replace the lines
   ```text
           $contextSuffix="`nBefore a task: pwsh -NoProfile -File `"$lib\Events.ps1`" -Find '<task in a few words>'. Record a failure, discovery or decision worth keeping with Events.ps1 -Add. Past sessions (task, size, tools, errors, SPECs, raw path): $dataRoot\sessions\INDEX.md."
           $guidance=if($fullStart){$always.Replace('<lib>',$lib)}else{"Tool guidance abbreviated; see $lib\README.md."}
   ```
   with
   ```text
           $contextSuffix="`nBefore a task: pwsh -NoProfile -File `"$lib\Events.ps1`" -Find '<task in a few words>'. Record a failure, discovery or decision worth keeping with Events.ps1 -Add. Past sessions (task, size, tools, errors, SPECs, raw path): $dataRoot\sessions\INDEX.md."
   ```

   e) replace the lines
   ```text
           if($contextPrefix.Length+$now.Length+1+$guidance.Length+1+$events.Length+$contextSuffix.Length-gt$contextLimit){
               $guidance="Tool guidance abbreviated; see $lib\README.md."
           }
           $context=$contextPrefix+$now+"`n"+$guidance+"`n"+$events+$contextSuffix
   ```
   with
   ```text
           $context=$contextPrefix+$now+"`n"+$events+$contextSuffix
   ```

   The resulting file's Git blob is 981e25caffa82654e07874e5d5aa0b22edee9476.

10. Check whether `lib/README.md` contains `and this section; a direct-native session receives no Workbench`; if so record Already Applied when its Git blob is 7acd762d41274e440e27f61ae5a840ae7ec77649, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-042 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   At the actual Workbench root SessionStart supplies NOW.md, this index and Pulse; a direct-native session receives no Workbench
   ```
   with
   ```text
   At the actual Workbench root SessionStart supplies NOW.md and Pulse, and `hooks\Load-Constitution.ps1` the constitution
   and this section; a direct-native session receives no Workbench
   ```

   b) replace the line
   ```text
   | `Save-State.ps1 -Operation <op> -Done <text> -Evidence <path> -Next <step> -RunBy <who>` | the one save (DEC-26): NOW.md from its template, checked by `Test-NowMarkdown` before it is written, one line in the workstream's LOG.md, the status page from the plan file (DEC-29), the hash-verified vault continuity copy, then the page line, the SAVED line, the /compact line and the resume message; every parameter in [RUNBOOK.md](../docs/RUNBOOK.md) section 11; `-Check` compares each stored status page with a fresh one, writes nothing, and prints `GENERATED STALE: <path>` |
   ```
   with
   ```text
   | `Save-State.ps1 -Operation <op> -Done <text> -Evidence <path> -Next <step> -RunBy <who>` | the one save (DEC-26): NOW.md from its template, checked by `Test-NowMarkdown` before it is written, one line in the workstream's LOG.md, the status page from the plan file (DEC-29), the hash-verified vault continuity copy, then the page line, the SAVED line, the /compact line and the resume message, and, when the token ledger exists, its `tokens:` line (a ledger failure prints `TOKEN_LEDGER_SKIPPED` and never fails the save); every parameter in [RUNBOOK.md](../docs/RUNBOOK.md) section 11; `-Check` compares each stored status page with a fresh one, writes nothing, and prints `GENERATED STALE: <path>` |
   | `Token-Ledger.ps1 [-Show <n>]` | the token ledger of DEC-18: one row per Claude main session in `<data root>\records\token-ledger.tsv` (context at turns 1 and 10 and at its peak, compactions, repeated Read ranges, the most-read file); an unchanged transcript keeps its row unparsed, so a run costs about a second; prints the last rows; the slice cost table stays a status-page step |
   | `hooks\Load-Constitution.ps1` | the SessionStart hook of `.claude/settings.json` at the Workbench root, on every source: DEC-30 and DEC-33 of docs/DECISIONS.md whole and the title of every other decision; section 4 only in a new context (startup, clear), else a pointer to it; within 9500 characters, the tool section giving way first; a missing rule or a breach prints `CONSTITUTION NOT LOADED: read ...` |
   ```

   The resulting file's Git blob is 7acd762d41274e440e27f61ae5a840ae7ec77649.

11. Check whether `lib/Save-State.ps1` contains `# section 3.3) once every copied file's SHA256 matches its source, then, where records\token-ledger.tsv exists, prints`; if so record Already Applied when its Git blob is 501beb4bea58f7bc4584d0e9ec811181111d7e16, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-042 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   # section 3.3) once every copied file's SHA256 matches its source, and prints the page line, the SAVED line, the
   ```
   with
   ```text
   # section 3.3) once every copied file's SHA256 matches its source, then, where records\token-ledger.tsv exists, prints
   # lib\Token-Ledger.ps1's latest row (a failure is one TOKEN_LEDGER_SKIPPED line), and prints the page line, the SAVED line, the
   ```

   b) immediately after the line
   ```text
   if(Test-Path -LiteralPath $previous){Remove-Copy $previous}
   ```
   insert
   ```text
   # The token ledger (DEC-18) runs only after NOW.md and the continuity copy are whole and only where its table exists;
   # a failure is one line and never fails the save.
   $ledger=[IO.Path]::Combine($DataRoot,'records','token-ledger.tsv')
   if(Test-Path -LiteralPath $ledger -PathType Leaf){
       try{$tokens=@(& (Join-Path $PSScriptRoot 'Token-Ledger.ps1') -Checkout $Checkout -DataRoot $DataRoot -Show 1);"tokens: $($tokens[-1])"}
       catch{"TOKEN_LEDGER_SKIPPED: $($_.Exception.Message)"}
   }
   ```

   The resulting file's Git blob is 501beb4bea58f7bc4584d0e9ec811181111d7e16.

12. Check whether `lib/test-save-state.ps1` contains `# continuity copy, the token ledger line from a stub Token-Ledger.ps1 (its failure never fails the save), and each refusal leaving NOW.md, LOG.md, the page and the vault untouched; then one mutant per`; if so record Already Applied when its Git blob is cca630bdd8754ea5ede50b62ca861c2503bd49dd, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-042 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   # continuity copy, and each refusal leaving NOW.md, LOG.md, the page and the vault untouched; then one mutant per
   ```
   with
   ```text
   # continuity copy, the token ledger line from a stub Token-Ledger.ps1 (its failure never fails the save), and each refusal leaving NOW.md, LOG.md, the page and the vault untouched; then one mutant per
   ```

   b) immediately after the lines
   ```text
       $injected
   }
   ```
   insert
   ```text
   function New-LedgerSave([string]$Name,[string]$Body){
       # A copy of the script under test beside a stub Token-Ledger.ps1, so no test reads a real transcript.
       $folder=Join-Path $scratch $Name;[void][IO.Directory]::CreateDirectory($folder)
       foreach($file in $SaveState,(Join-Path (Split-Path $SaveState -Parent) 'Test-MarkdownConsistency.ps1')){Copy-Item -LiteralPath $file -Destination $folder}
       [IO.File]::WriteAllText((Join-Path $folder 'Token-Ledger.ps1'),"param([string]`$Checkout,[string]`$DataRoot,[int]`$Show)$nl$Body$nl")
       Join-Path $folder (Split-Path $SaveState -Leaf)
   }
   function New-LedgerFixture([string]$Name){
       $f=New-SaveFixture $Name;$tsv=[IO.Path]::Combine($f.Data,'records','token-ledger.tsv')
       [void][IO.Directory]::CreateDirectory((Split-Path $tsv -Parent));[IO.File]::WriteAllText($tsv,"Session$nl");$f
   }
   ```

   c) immediately after the line
   ```text
           Assert-Save (($now-replace "$nl  ",' ').Contains("- $long$nl")) 'long question carried whole'})
   ```
   insert
   ```text
       # The ledger line comes first and only where records\token-ledger.tsv exists (positive asserts four lines without it).
       ledger=@('',{$f=New-LedgerFixture 'ledger';$out=Invoke-Save $f $first (New-LedgerSave 'ledgerStub' '"row $Show $DataRoot $Checkout"')
           Assert-Save ($out.Count-eq5-and$out[0]-ceq"tokens: row 1 $($f.Data) $checkout"-and$out[1]-clike'STATUS_PAGE *') "ledger line: $($out-join' | ')"})
       ledgerFailure=@('',{$f=New-LedgerFixture 'ledgerFail';$out=Invoke-Save $f $first (New-LedgerSave 'ledgerThrows' "throw 'STUB FAIL'")
           Assert-Save ($out.Count-eq5-and$out[0]-ceq'TOKEN_LEDGER_SKIPPED: STUB FAIL'-and$out[2]-clike'SAVED *continuity copy verified') "skipped line: $($out-join' | ')"
           $now=Get-SaveText $f 'NOW';Assert-Save ($now.Contains("WS-033 P1.5 S2 part 1 done.")) 'NOW.md written'
           Assert-Save ([IO.File]::ReadAllText((Join-Path $f.Vault 'continuity/data/work/NOW.md'))-ceq$now) 'continuity whole'})
   ```

   d) immediately after the line
   ```text
               readOnlyCopy='$_.IsReadOnly=$false'
   ```
   insert
   ```text
               ledger='"tokens: $($tokens[-1])"';ledgerFailure='"TOKEN_LEDGER_SKIPPED: $($_.Exception.Message)"'
   ```

   The resulting file's Git blob is cca630bdd8754ea5ede50b62ca861c2503bd49dd.

13. Check whether `lib/test-token-ledger.ps1` contains `# Self-check for Token-Ledger.ps1 in a test root (WORKBENCH_TEST_ROOT, else TEMP), over synthetic transcripts only: the`; if so record Already Applied when its Git blob is ff0a8d6de755f174f78c93bfc9969d059674bf6d, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-042 candidate output), and change nothing else:

   ```text
   # Self-check for Token-Ledger.ps1 in a test root (WORKBENCH_TEST_ROOT, else TEMP), over synthetic transcripts only: the
   # figures of one row (turns deduplicated by message id, sidechains excluded, compactions, repeated Read ranges, top file),
   # an unchanged transcript kept unparsed, a changed one parsed again, a row whose transcript is gone kept, -Show, the
   # default table under the data root, the transcript folder derived from the checkout path under HOME, and a missing
   # transcript folder giving no row and no error. No real transcript is read.
   param([string]$Ledger=(Join-Path $PSScriptRoot 'Token-Ledger.ps1'))
   $ErrorActionPreference='Stop'
   . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   $parent=if($env:WORKBENCH_TEST_ROOT){$env:WORKBENCH_TEST_ROOT}else{$env:TEMP}
   if(![IO.Path]::IsPathFullyQualified($parent)){throw 'LEDGER_TEST_ROOT_REQUIRED'}
   [void][IO.Directory]::CreateDirectory($parent);$parent=(Get-Item -LiteralPath $parent).FullName
   $scratch=Join-Path $parent ('tl-'+[guid]::NewGuid().ToString('N').Substring(0,8));[void][IO.Directory]::CreateDirectory($scratch)
   $script:passed=0
   function Assert-Ledger([bool]$Condition,[string]$What){if(!$Condition){throw "LEDGER_ASSERT: $What"};$script:passed++}
   function ConvertTo-Line($Value){$Value|ConvertTo-Json -Depth 10 -Compress}
   function Get-Usage([string]$Id,[int]$In,[int]$Read,[int]$Create,$Content=@(),[switch]$Side){
       ConvertTo-Line @{type='assistant';isSidechain=[bool]$Side;message=@{id=$Id;usage=@{input_tokens=$In;cache_read_input_tokens=$Read;cache_creation_input_tokens=$Create};content=@($Content)}}
   }
   function Get-Read([string]$Id,[string]$Path){@{type='tool_use';id=$Id;name='Read';input=@{file_path=$Path}}}
   function Get-Result([string]$Id,[string]$Text){ConvertTo-Line @{type='user';message=@{content=@(@{type='tool_result';tool_use_id=$Id;content=$Text})}}}
   function Get-Rows([string]$Table){$rows=@{};foreach($row in Import-Csv -LiteralPath $Table -Delimiter "`t"){$rows[$row.Session]=$row};$rows}
   try{
       $project=Join-Path $scratch 'project';[void][IO.Directory]::CreateDirectory($project)
       $a='aaaaaaaa-0000-0000-0000-000000000001';$b='bbbbbbbb-0000-0000-0000-000000000002'
       $lines=@(
           (Get-Usage 'm1' 10 100 0),(Get-Usage 'm1' 10 100 0)  # the same message twice counts once
           (Get-Usage 'm2' 5 200 50 (Get-Read 't1' 'C:\x\a.md')),(Get-Result 't1' 'abcdef')
           (Get-Usage 'm3' 5 300 0 (Get-Read 't2' 'C:\x\a.md')),(Get-Result 't2' 'abcdef')
           (Get-Usage 'm4' 1 200 0 (Get-Read 't3' 'C:\x\b.md')),(Get-Result 't3' 'zz')
           (ConvertTo-Line @{type='system';compactMetadata=@{preTokens=5000}})
           (Get-Usage 'm9' 99999 0 0 -Side)
           '{"usage": not json'
       )
       [IO.File]::WriteAllText((Join-Path $project "$a.jsonl"),($lines-join"`n")+"`n")
       $bFile=Join-Path $project "$b.jsonl";[IO.File]::WriteAllText($bFile,(Get-Usage 'n1' 1 1 1)+"`n")
       $table=Join-Path $scratch 'out\ledger.tsv'
       $out=@(& $Ledger -Project $project -Out $table)
       Assert-Ledger ($out.Count-eq2) "two rows printed: $($out-join' | ')"
       $rows=Get-Rows $table;$row=$rows[$a]
       # A string result is measured as its JSON text: "abcdef" is 8 characters, "zz" 4; the second a.md read repeats 8 of 20.
       foreach($pair in @(@('Turns','4'),@('Turn1','110'),@('Turn10','0'),@('Peak','305'),@('Compacts','1'),@('MedianCompactAt','5000'),@('ReadChars','20'),@('RepeatPct','40'),@('TopFile','a.md'),@('TopReads','2'))){
           Assert-Ledger ($row.($pair[0])-ceq$pair[1]) "$($pair[0]) is $($row.($pair[0])), expected $($pair[1])"
       }
       Assert-Ledger ($rows[$b].Turns-ceq'1'-and$rows[$b].TopFile-ceq'-') 'a session without reads'
       Assert-Ledger ($out[-1]-cmatch'^\d{4}-\d\d-\d\d \d\d:\d\d (aaaaaaaa|bbbbbbbb) turns \d+ t1 \d+ t10 0 peak \d+ compacts \d at \d+ repeat \d+% top \S+ x\d+$') "line shape: $($out[-1])"
       # An unchanged transcript keeps its row unparsed; a grown one is parsed again; a row without a transcript is kept.
       $text=[IO.File]::ReadAllText($table).Replace("$a`t$($row.LastUtc)`t$($row.Bytes)`t4`t","$a`t$($row.LastUtc)`t$($row.Bytes)`t999`t")
       [IO.File]::WriteAllText($table,$text+"cccccccc-gone`t2000-01-01 00:00`t1`t1`t1`t0`t1`t0`t0`t0`t0`t-`t0`n")
       [IO.File]::AppendAllText($bFile,(Get-Usage 'n2' 2 2 2)+"`n")
       $out=@(& $Ledger -Project $project -Out $table -Show 1);$rows=Get-Rows $table
       Assert-Ledger ($rows[$a].Turns-ceq'999') 'an unchanged transcript is not parsed again'
       Assert-Ledger ($rows[$b].Turns-ceq'2') 'a changed transcript is parsed again'
       Assert-Ledger ($rows.ContainsKey('cccccccc-gone')) 'a row whose transcript is gone is kept'
       Assert-Ledger ($out.Count-eq1) "-Show 1 prints one line: $($out-join' | ')"
       Assert-Ledger (!(Test-Path -LiteralPath "$table.tmp")) 'no temporary table left'
       # Defaults: the table under the data root; the transcript folder named after the checkout path under HOME.
       $data=Join-Path $scratch 'data';$out=@(& $Ledger -Project $project -DataRoot $data)
       Assert-Ledger ((Test-Path -LiteralPath ([IO.Path]::Combine($data,'records','token-ledger.tsv')))-and$out.Count-eq2) 'default table under the data root'
       $home2=Join-Path $scratch 'home';$checkout=Join-Path $scratch 'Some Lab\GitHub\ORVION-Workbench'
       $derived=Join-Path $home2 ('.claude\projects\'+($checkout-replace'[^A-Za-z0-9]','-'));[void][IO.Directory]::CreateDirectory($derived)
       Copy-Item -LiteralPath $bFile -Destination $derived
       $saved=$env:USERPROFILE;$env:USERPROFILE=$home2
       try{$out=@(& pwsh -NoProfile -File $Ledger -Checkout $checkout -DataRoot (Join-Path $scratch 'data2') 2>&1)}finally{$env:USERPROFILE=$saved}
       Assert-Ledger ($LASTEXITCODE-eq0-and$out.Count-eq1-and"$out"-cmatch' bbbbbbbb turns 2 ') "derived transcript folder: $out"
       $out=@(& $Ledger -Project (Join-Path $scratch 'absent') -Out (Join-Path $scratch 'empty.tsv'))
       Assert-Ledger ($out.Count-eq0-and([IO.File]::ReadAllText((Join-Path $scratch 'empty.tsv')).StartsWith("Session`t"))) 'a missing transcript folder gives no row and no error'
       "TOKEN_LEDGER_TESTS PASS: $script:passed assertions"
   }finally{$null=Remove-OrvionOwnedTree -Path $scratch -AllowedRoots @($parent)}
   ```

   The resulting file's Git blob is ff0a8d6de755f174f78c93bfc9969d059674bf6d.

14. Check whether `lib/test-watch-reminder.ps1` contains `# Also the second SessionStart hook, hooks\Load-Constitution.ps1, over the real docs\DECISIONS.md, and that the two never overlap.`; if so record Already Applied when its Git blob is c0c39ecce00cb99e509f21829179f845b970511f, and otherwise stop and report. Otherwise make exactly these 6 edits (land this exact frozen WS-042 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   # Real hook callers in a disposable workspace; bounded followers read only fixture transcripts, with Pulse stubbed.
   ```
   insert
   ```text
   # Also the second SessionStart hook, hooks\Load-Constitution.ps1, over the real docs\DECISIONS.md, and that the two never overlap.
   ```

   b) replace the lines
   ```text
               [IO.File]::WriteAllText((Join-Path $deadlineLib 'README.md'),"# Tools`n`n## 3. Index`n`nPREVIOUS-SECTION`n`n## 4. Always, numbered`nNUMBERED-TOOLS`n")
               $numbered=Invoke-DeadlineEvent
               Assert-That 'a numbered Always heading in the last section is injected' ($numbered.Exit-eq0-and$numbered.Text.Contains('NUMBERED-TOOLS')-and!$numbered.Text.Contains('PREVIOUS-SECTION'))
   ```
   with
   ```text
               # The second SessionStart hook, Load-Constitution.ps1, over the real docs/DECISIONS.md and lib/README.md: DEC-30
               # and DEC-33 whole and every other decision title on every source, the Always section only in a new context, the
               # 9500 bound, the retrieve line when a rule is missing, silence elsewhere; then four mutants, each must be caught.
   ```

   c) replace the lines
   ```text
               $real=Invoke-DeadlineEvent
               Assert-That 'the real lib/README.md has one Always section and SessionStart injects it' ($alwaysHeadings.Count-eq1-and$real.Exit-eq0-and$real.Text.Contains($alwaysHeadings[0]))
   ```
   with
   ```text
               $realDecisions=Join-Path (Split-Path $PSScriptRoot -Parent) 'docs\DECISIONS.md';$decisionText=[IO.File]::ReadAllText($realDecisions)-replace'\r?\n',"`n"
               $decisionLines=$decisionText-split"`n";$fixtureDecisions=Join-Path $deadlineCheckout 'docs\DECISIONS.md';[void][IO.Directory]::CreateDirectory((Split-Path $fixtureDecisions))
               function Get-DecisionSection([string]$Id){$at=[array]::FindIndex($decisionLines,[Predicate[string]]{param($l)$l.StartsWith("## $Id ")});$to=[array]::FindIndex($decisionLines,$at+1,[Predicate[string]]{param($l)$l.StartsWith('## ')});if($to-lt0){$to=$decisionLines.Count};@($decisionLines[$at..($to-1)]|Where-Object{$_.Trim()})}
               $ruleLines=@(Get-DecisionSection 'DEC-30')+@(Get-DecisionSection 'DEC-33');$titles=@($decisionLines|Where-Object{$_-match'^## DEC-\d+ '}|ForEach-Object{$_.Substring(3)})
               $constitutionHook=Join-Path $deadlineLib 'hooks\Load-Constitution.ps1';$constitutionSource=Join-Path $PSScriptRoot 'hooks\Load-Constitution.ps1'
               function Get-ConstitutionFault{
                   $faults=[Collections.Generic.List[string]]::new();[IO.File]::WriteAllText($fixtureDecisions,$decisionText)
                   $savedProjectDir=$env:CLAUDE_PROJECT_DIR;$env:CLAUDE_PROJECT_DIR=$null
                   try{
                   foreach($source in 'startup','clear','resume','compact',''){
                       $r=Invoke-DeadlineEvent $constitutionHook 'SessionStart' $deadlineCheckout $source;$o=$r.Text
                       $full=$source-in'startup','clear',''
                       if($r.Exit-ne0-or$r.Error-or$o.Length-gt9500-or@($ruleLines+$titles|Where-Object{!$o.Contains($_)}).Count-or$o.Contains('FIXTURE-PULSE')){$faults.Add("rules on '$source'")}
                       if($o.Contains($alwaysHeadings[0])-ne$full-or(!$full-and!$o.Contains('Tool guidance abbreviated; see'))){$faults.Add("tool index on '$source'")}
                       if($source-eq'startup'){$script:constitutionStartup=$o}elseif($source-eq'resume'){$script:constitutionResume=$o}
                   }
                   if((Invoke-DeadlineEvent $constitutionHook 'SessionStart' (Join-Path $t 'unrelated') 'startup').Text){$faults.Add('unrelated cwd')}
                   # The project directory Claude Code names wins over the event's cwd: a session whose shell moved still loads.
                   $env:CLAUDE_PROJECT_DIR=$deadlineCheckout;$o=(Invoke-DeadlineEvent $constitutionHook 'SessionStart' (Join-Path $t 'unrelated') 'compact').Text
                   if(@($ruleLines+$titles|Where-Object{!$o.Contains($_)}).Count){$faults.Add('moved cwd inside the project')}
                   $env:CLAUDE_PROJECT_DIR=Join-Path $t 'unrelated'
                   if((Invoke-DeadlineEvent $constitutionHook 'SessionStart' $deadlineCheckout 'startup').Text){$faults.Add('other project')}
                   $env:CLAUDE_PROJECT_DIR=$null
                   foreach($case in @(@('12. ','DEC-33 rule 12'),@('## DEC-30 ','DEC-30'))){
                       [IO.File]::WriteAllText($fixtureDecisions,$decisionText.Replace("`n$($case[0])","`nX$($case[0])"))
                       $r=Invoke-DeadlineEvent $constitutionHook 'SessionStart' $deadlineCheckout 'resume'
                       if($r.Exit-ne0-or!$r.Text.StartsWith('CONSTITUTION NOT LOADED: read ')-or!$r.Text.Contains("not found: $($case[1])")){$faults.Add("retrieve line for $($case[1])")}
                   }
                   [IO.File]::WriteAllText($fixtureDecisions,$decisionText.Replace("`n1. ","`n1. $('R'*9500) "))
                   if(!(Invoke-DeadlineEvent $constitutionHook 'SessionStart' $deadlineCheckout 'startup').Text.Contains('over the 9500-character bound')){$faults.Add('constitution bound')}
                   [IO.File]::WriteAllText($fixtureDecisions,$decisionText);[IO.File]::WriteAllText((Join-Path $deadlineLib 'README.md'),"## 4. Always`n"+('GUIDANCE'*1000)+"`n")
                   $r=Invoke-DeadlineEvent $constitutionHook 'SessionStart' $deadlineCheckout 'startup'
                   if($r.Text.Length-gt9500-or$r.Text.Contains('GUIDANCE')-or!$r.Text.Contains('Tool guidance abbreviated; see')-or@($ruleLines|Where-Object{!$r.Text.Contains($_)}).Count){$faults.Add('guidance gives way first')}
                   Copy-Item -LiteralPath $realReadme -Destination (Join-Path $deadlineLib 'README.md') -Force
                   }finally{$env:CLAUDE_PROJECT_DIR=$savedProjectDir}
                   $faults
               }
               Copy-Item -LiteralPath $constitutionSource -Destination $constitutionHook
               $faults=@(Get-ConstitutionFault)
               Assert-That "Load-Constitution.ps1 loads the constitution on every source, bounded and fail-loud (faults: $($faults-join', '))" (!$faults.Count)
               "BYTES Load-Constitution startup=$($constitutionStartup.Length) resume=$($constitutionResume.Length) characters"
               $original=[IO.File]::ReadAllText($constitutionSource)
               $mutants=[ordered]@{source="if(`$true){";retrieve='if($false){"$retrieve (not found:';bound='-gt99999){$guidance=$pointer}';scope="TrimEnd('\')){}";project='$cwd=if($false){'}
               $mutated=[ordered]@{source="if(!`$e.source-or`$e.source-in'startup','clear'){";retrieve='if($missing){"$retrieve (not found:';bound='-gt9500){$guidance=$pointer}';scope="TrimEnd('\')){exit 0}";project='$cwd=if($env:CLAUDE_PROJECT_DIR){'}
               foreach($name in $mutants.Keys){
                   if(!$original.Contains($mutated[$name])){Assert-That "constitution mutant $name applies" $false;continue}
                   [IO.File]::WriteAllText($constitutionHook,$original.Replace($mutated[$name],$mutants[$name]))
                   Assert-That "constitution mutant $name is caught" (@(Get-ConstitutionFault).Count-gt0)
               }
               Copy-Item -LiteralPath $constitutionSource -Destination $constitutionHook -Force
   ```

   d) replace the lines
   ```text
               Assert-That 'startup injects NOW.md whole and the full Pulse' ($startup.Exit-eq0-and$startup.Text.Contains($nowText)-and$startup.Text.Contains('repo     CRM')-and$startup.Text.Contains('LAST-LINE')-and$startup.Text.Contains('TOOLS-LINE')-and$startup.Text.Contains($alwaysHeadings[0]))
               Assert-That 'after /clear, a new context, the tool index and the full Pulse' ($cleared.Exit-eq0-and$cleared.Text.Contains($nowText)-and$cleared.Text.Contains('repo     CRM')-and$cleared.Text.Contains($alwaysHeadings[0]))
               Assert-That 'compact injects NOW.md whole and only the short Pulse' ($compact.Exit-eq0-and$compact.Text.Contains($nowText)-and!$compact.Text.Contains($alwaysHeadings[0])-and$compact.Text.Contains('Tool guidance abbreviated; see')-and$compact.Text.Contains('ORVION PULSE')-and$compact.Text.Contains('running  archiver')-and$compact.Text.Contains('waiting  on the owner: 1')-and!$compact.Text.Contains('repo     CRM')-and!$compact.Text.Contains('OWNER-ITEM')-and!$compact.Text.Contains('LAST-LINE')-and!$compact.Text.Contains('QUEUE-LINE')-and!$compact.Text.Contains('TOOLS-LINE'))
   ```
   with
   ```text
               Assert-That 'startup injects NOW.md whole and the full Pulse' ($startup.Exit-eq0-and$startup.Text.Contains($nowText)-and$startup.Text.Contains('repo     CRM')-and$startup.Text.Contains('LAST-LINE')-and$startup.Text.Contains('TOOLS-LINE'))
               Assert-That 'after /clear, a new context, the full Pulse' ($cleared.Exit-eq0-and$cleared.Text.Contains($nowText)-and$cleared.Text.Contains('repo     CRM'))
               $duplicated=@(foreach($r in $startup,$cleared,$compact){@($ruleLines+$alwaysHeadings+'Tool guidance abbreviated'|Where-Object{$r.Text.Contains($_)})})
               Assert-That "Watch-Reminder never repeats Load-Constitution's rules or tool guidance (found: $($duplicated-join' | '))" (!$duplicated.Count)
               Assert-That 'compact injects NOW.md whole and only the short Pulse' ($compact.Exit-eq0-and$compact.Text.Contains($nowText)-and$compact.Text.Contains('ORVION PULSE')-and$compact.Text.Contains('running  archiver')-and$compact.Text.Contains('waiting  on the owner: 1')-and!$compact.Text.Contains('repo     CRM')-and!$compact.Text.Contains('OWNER-ITEM')-and!$compact.Text.Contains('LAST-LINE')-and!$compact.Text.Contains('QUEUE-LINE')-and!$compact.Text.Contains('TOOLS-LINE'))
   ```

   e) replace the line
   ```text
               Assert-That 'complete SessionStart bounds README guidance while preserving Pulse diagnostics and index pointer' ($bounded.Exit-eq0-and$bounded.Text.Length-le8192-and$bounded.Text-match'Pulse UNREADABLE fixture'-and$bounded.Text.Contains("$deadlineStore\sessions\INDEX.md")-and$bounded.Text-match'README.md')
   ```
   with
   ```text
               Assert-That 'SessionStart never reads README guidance and keeps Pulse diagnostics and the index pointers' ($bounded.Exit-eq0-and$bounded.Text.Length-le8192-and!$bounded.Text.Contains('GUIDANCE')-and$bounded.Text-match'Pulse UNREADABLE fixture'-and$bounded.Text.Contains("$deadlineStore\sessions\INDEX.md")-and$bounded.Text-match'README.md')
   ```

   f) replace the line
   ```text
       Assert-That 'Workbench SessionStart receives one index/Pulse with separate archival' ($workbenchStart-match'STUB-TOOLS'-and$workbenchStart-match'STUB-PULSE'-and@(Get-Content (Join-Path $ws 'pulse.calls')).Count-eq1-and$rows.Count-eq2)
   ```
   with
   ```text
       Assert-That 'Workbench SessionStart receives one Pulse, no tool guidance, with separate archival' ($workbenchStart-notmatch'STUB-TOOLS'-and$workbenchStart-match'STUB-PULSE'-and@(Get-Content (Join-Path $ws 'pulse.calls')).Count-eq1-and$rows.Count-eq2)
   ```

   The resulting file's Git blob is c0c39ecce00cb99e509f21829179f845b970511f.

15. Check whether `lib/Token-Ledger.ps1` contains `# The token ledger of DEC-18 (from WS-033 D108): one row per Claude main session in <data root>\records\token-ledger.tsv,`; if so record Already Applied when its Git blob is 06d47dc49b80211e6e685306b7cddebaf2029236, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-042 candidate output), and change nothing else:

   ```text
   # The token ledger of DEC-18 (from WS-033 D108): one row per Claude main session in <data root>\records\token-ledger.tsv,
   # so each save shows whether the method saves: context size at turns 1 and 10 and at its peak, how often it was compacted
   # and at what size, and how much of what the Read tool returned was the same range of a file that session had already
   # read, with the most-read file. Read-only over the transcripts. A session whose transcript has not changed size keeps its
   # row unparsed, and a session whose transcript is gone keeps its row, so a save costs about a second. Prints the last rows.
   # Save-State calls it after the save is whole (-Show 1); the slice cost table stays a status-page step, never a save step.
   # Ceiling: counts the characters of tool results, not tokens; a repeat is the same file, offset and limit in one session,
   # so overlaps and reads in a later session are not counted and the figure is a lower bound; subagent sidechains are excluded.
   param([string]$Checkout=(Split-Path $PSScriptRoot -Parent),[string]$DataRoot,[string[]]$Project,[string]$Out,[int]$Show=6)
   $ErrorActionPreference='Stop'
   if(!$DataRoot){$DataRoot=if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{Join-Path $Checkout 'data'}}
   if(!$Out){$Out=[IO.Path]::Combine($DataRoot,'records','token-ledger.tsv')}
   # Claude Code names a project's transcript folder after its path, every character other than a letter or digit a dash.
   if(!$Project){$Project=@(Join-Path $HOME ('.claude\projects\'+([IO.Path]::GetFullPath($Checkout).TrimEnd('\')-replace'[^A-Za-z0-9]','-')))}
   $columns='Session','LastUtc','Bytes','Turns','Turn1','Turn10','Peak','Compacts','MedianCompactAt','ReadChars','RepeatPct','TopFile','TopReads'
   $kept=@{};if(Test-Path -LiteralPath $Out){foreach($row in Import-Csv -LiteralPath $Out -Delimiter "`t"){$kept[$row.Session]=$row}}
   $listed=@{};$folders=@($Project|Where-Object{Test-Path -LiteralPath $_ -PathType Container})
   $rows=foreach($file in @(if($folders.Count){Get-ChildItem -LiteralPath $folders -Filter *.jsonl})){
       $id=$file.BaseName;$known=$kept[$id];$listed[$id]=1
       if($known-and[long]$known.Bytes-eq$file.Length){$known;continue}
       $seen=@{};$sizes=[Collections.Generic.List[int]]::new();$compactAt=[Collections.Generic.List[int]]::new();$names=@{};$reads=@{};$ranges=@{};$readChars=0L;$repeatChars=0L
       foreach($line in [IO.File]::ReadLines($file.FullName)){
           if($line-notmatch'"compactMetadata"|"usage"|"tool_use"|"tool_result"'){continue}
           try{$entry=$line|ConvertFrom-Json -Depth 40}catch{continue}
           if($entry.isSidechain){continue}
           if($entry.compactMetadata){$compactAt.Add([int]$entry.compactMetadata.preTokens);continue}
           if($entry.type-eq'assistant'-and$entry.message.usage-and!$seen[$entry.message.id]){
               $seen[$entry.message.id]=1;$usage=$entry.message.usage
               $sizes.Add([int]$usage.input_tokens+[int]$usage.cache_read_input_tokens+[int]$usage.cache_creation_input_tokens)
           }
           foreach($block in @($entry.message.content)){
               if($block.type-eq'tool_use'-and$block.name-ceq'Read'){$names[$block.id]=@($block.input.file_path,"$($block.input.file_path)|$($block.input.offset)|$($block.input.limit)")}
               elseif($block.type-eq'tool_result'-and$names[$block.tool_use_id]){
                   $path,$range=$names[$block.tool_use_id];$size=("$($block.content|ConvertTo-Json -Depth 6 -Compress)").Length;$readChars+=$size;$reads[$path]=[int]$reads[$path]+1
                   if($ranges[$range]){$repeatChars+=$size}else{$ranges[$range]=1}
                   $names.Remove($block.tool_use_id)  # a transcript can carry the same result twice
               }
           }
       }
       if(!$sizes.Count){continue}
       $top=@($reads.GetEnumerator()|Sort-Object Value -Descending|Select-Object -First 1)
       $middle=if($compactAt.Count){@($compactAt|Sort-Object)[[int]($compactAt.Count/2)]}else{0}
       [pscustomobject]@{Session=$id;LastUtc=$file.LastWriteTimeUtc.ToString('yyyy-MM-dd HH:mm');Bytes=$file.Length;Turns=$sizes.Count;Turn1=$sizes[0]
           Turn10=$(if($sizes.Count-ge10){$sizes[9]}else{0});Peak=($sizes|Measure-Object -Maximum).Maximum;Compacts=$compactAt.Count;MedianCompactAt=$middle;ReadChars=$readChars
           RepeatPct=$(if($readChars){[int](100*$repeatChars/$readChars)}else{0});TopFile=$(if($top.Count){Split-Path $top[0].Key -Leaf}else{'-'});TopReads=$(if($top.Count){$top[0].Value}else{0})}
   }
   $sorted=@(@($rows)+@($kept.Values|Where-Object{!$listed[$_.Session]})|Where-Object{$_}|Sort-Object LastUtc)
   $lines=@($columns-join"`t")+@($sorted|ForEach-Object{$row=$_;(@($columns|ForEach-Object{$row.$_}))-join"`t"})
   [void][IO.Directory]::CreateDirectory((Split-Path $Out -Parent))
   [IO.File]::WriteAllText("$Out.tmp",($lines-join"`n")+"`n",[Text.UTF8Encoding]::new($false));[IO.File]::Move("$Out.tmp",$Out,$true)
   $sorted|Select-Object -Last $Show|ForEach-Object{"$($_.LastUtc) $($_.Session.Substring(0,8)) turns $($_.Turns) t1 $($_.Turn1) t10 $($_.Turn10) peak $($_.Peak) compacts $($_.Compacts) at $($_.MedianCompactAt) repeat $($_.RepeatPct)% top $($_.TopFile) x$($_.TopReads)"}
   ```

   The resulting file's Git blob is 06d47dc49b80211e6e685306b7cddebaf2029236.

## Acceptance Criteria

- [ ] Output `.claude/settings.json` equals its declared resulting Git blob. check: blob:.claude/settings.json=31b1e98bab4725abf474950b2c0772595890ea75
- [ ] Output `changes/README.md` equals its declared resulting Git blob. check: blob:changes/README.md=6c55359c782dd1a6bc57cf76cba2c18944ad899a
- [ ] Output `docs/DECISIONS.md` equals its declared resulting Git blob. check: blob:docs/DECISIONS.md=01685309f1b570b273ab3e26a2dff4e112bc15d1
- [ ] Output `docs/history/DECISIONS-ARCHIVE.md` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-ARCHIVE.md=253e61cb323c1a52ce4f0a10fb76c06870fbd583
- [ ] Output `docs/history/DECISIONS-MAP.tsv` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-MAP.tsv=72940a6112f7777a18e831e273b60681c0f4415e
- [ ] Output `docs/RUNBOOK.md` equals its declared resulting Git blob. check: blob:docs/RUNBOOK.md=28f4089544ef85fe895f346c34ee59cf3da6bde6
- [ ] Output `docs/WORKSPACE-LAYOUT.md` equals its declared resulting Git blob. check: blob:docs/WORKSPACE-LAYOUT.md=04fd219a7717164b6cb001ddf298fbe97ce1e0ec
- [ ] Output `lib/hooks/Load-Constitution.ps1` equals its declared resulting Git blob. check: blob:lib/hooks/Load-Constitution.ps1=eefb8432d95340f7d8aa6167b7a9488db447aad0
- [ ] Output `lib/hooks/Watch-Reminder.ps1` equals its declared resulting Git blob. check: blob:lib/hooks/Watch-Reminder.ps1=981e25caffa82654e07874e5d5aa0b22edee9476
- [ ] Output `lib/README.md` equals its declared resulting Git blob. check: blob:lib/README.md=7acd762d41274e440e27f61ae5a840ae7ec77649
- [ ] Output `lib/Save-State.ps1` equals its declared resulting Git blob. check: blob:lib/Save-State.ps1=501beb4bea58f7bc4584d0e9ec811181111d7e16
- [ ] Output `lib/test-save-state.ps1` equals its declared resulting Git blob. check: blob:lib/test-save-state.ps1=cca630bdd8754ea5ede50b62ca861c2503bd49dd
- [ ] Output `lib/test-token-ledger.ps1` equals its declared resulting Git blob. check: blob:lib/test-token-ledger.ps1=ff0a8d6de755f174f78c93bfc9969d059674bf6d
- [ ] Output `lib/test-watch-reminder.ps1` equals its declared resulting Git blob. check: blob:lib/test-watch-reminder.ps1=c0c39ecce00cb99e509f21829179f845b970511f
- [ ] Output `lib/Token-Ledger.ps1` equals its declared resulting Git blob. check: blob:lib/Token-Ledger.ps1=06d47dc49b80211e6e685306b7cddebaf2029236
- [ ] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [ ] AC-01 Token ledger (G1): lib/Token-Ledger.ps1 writes one row per Claude main session to `<data root>\records\token-ledger.tsv`, keeping a known row whose Bytes equal the transcript's length unread (incremental), with no slice-cost call. lib/Save-State.ps1 changes only one header line and adds one block after the continuity copy's old copy is removed: where the table exists it runs Token-Ledger.ps1 -Show 1 and prints `tokens: <row>`, and any failure prints one `TOKEN_LEDGER_SKIPPED: <reason>` line; the save, NOW.md, the continuity copy and the exit are unchanged either way. test-token-ledger passes; test-save-state passes every earlier case plus the ledger line and the forced ledger failure (NOW.md written, continuity whole).
- [ ] AC-02 Constitution hook (C): .claude/settings.json equals its baseline but for one SessionStart entry running lib/hooks/Load-Constitution.ps1 (timeout 20). For startup, clear, resume, compact and no source alike, run from the Workbench root it prints DEC-30 and DEC-33 of docs/DECISIONS.md whole with rules 1-12 and the ID and title of every other decision; the lib/README.md Always section only on startup, clear and no source, else one pointer; at most 9,500 characters; outside the root nothing, the root judged by the project directory Claude Code names (CLAUDE_PROJECT_DIR), else the event's cwd, so a compact or resume while the shell sits in a clone still loads it and another project stays silent; when a section or rule cannot be found, its text would pass the bound or the hook fails, one `CONSTITUTION NOT LOADED` line telling the agent to read DEC-30 and DEC-33 in full before any governed decision. lib/hooks/Watch-Reminder.ps1 no longer reads lib/README.md and keeps NOW.md and Pulse, so no text is injected twice. test-watch-reminder passes with these cases and sizes.
- [ ] AC-03 Decisions fold (G3): docs/DECISIONS.md differs from its baseline only inside DEC-31 (the ready-script sentence, the 2026-11-14 instruction, Changed 2026-11-14, History D106, D130); docs/history/DECISIONS-ARCHIVE.md only appends D130, holding DEC-31's replaced wording, #18's words and the ~22:04 G3 line verbatim, `Now in: DEC-31`, and the 16 settled inbox entries by date and DEC home with the SHA256 of their verbatim frozen copy; docs/history/DECISIONS-MAP.tsv only appends its one D130 row. The Markdown guard passes (budget, append-only archive, map rows).
- [ ] AC-04 Durable knowledge (D): docs/RUNBOOK.md adds the two traps to section 7 (an array never crosses `pwsh -File`; Save-State in-process), the settled answers to section 9 (usage not readable from VS Code, the two gh accounts and their check, Docker bounded exactly as the owner wrote it: only the project-owned stack an already approved operation needs, no prune, volume deletion, destructive reset or other project) and the in-process call and the `tokens:` line to section 11; docs/WORKSPACE-LAYOUT.md names the two new tools and the Supabase MCP names; lib/README.md lists Token-Ledger.ps1 and hooks\Load-Constitution.ps1. No changed file grants a bare "update" or running as Administrator. test-markdown-consistency and test-workspace-layout pass.
- [ ] AC-05 Organizer: changes/README.md is what lib/Organize.ps1 -Refresh writes: it holds the WS-042 row, and a refresh of the replay with this contract in place changes no organizer.
- [ ] AC-06 Secrets and privacy: gitleaks on the exact candidate range reports no finding in the 15 outputs and RESUME.md; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; neither masked value (the computer name, a marketing tunnel script name) nor the owner's e-mail is in any changed file or in this contract.
- [ ] AC-07 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json. From each Finish launch to END: no Events -Add, Save-State or edit in a protected root, and Docker off.
- [ ] AC-08 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-042/evidence/protected-before.json, captured before the sandbox Finish and again after Original Complete with data/records/WS-038/Capture-Protected.ps1; lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1 and lib/apply-draft-steps.ps1 are unchanged; the user settings are unchanged; CRM, ORVION and their trusted copies keep their HEAD and files (the lifecycle's protected-root compare); no Codex, subagent, RAM, power setting or scheduled task change; no push before both roles are Complete.

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
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-042\assurance\V3\DRAFT.md
Approved SHA256: FC82C3F4970CF609270973EA0EFB065A8AC941E21242E8DC619215DB063C3C80
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-042\gate\GATE1-WS042-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: 96F23F851C414875D5A993ED2071F904E3E8C5D2A9F1F11289FFA613A06E900C
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W42\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: C5A62D1CC861D2149B6ACBD1B2FD9794ADB42EB60CA53AE32A1EA94B3C2079CD

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W42-c5 (data/records/WS-042/Make-Candidate.ps1). Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json beside this Draft. After Complete, outside this contract: the release under DEC-25 on the owner's ~22:04 words, only when every gate passed and Claude main's retro is satisfied; the protected state is compared with its record from before; data/decisions-inbox.md is folded (16 removed, #18 folded, a header naming D130 and the frozen copy); the ledger table moves to data/records/token-ledger.tsv with status-page.ps1; the Claude memory files become pointers (update and Administrator NOT APPROVED 2026-11-14, Docker bounded); the ledger overhead and the hook outputs are measured; Save-State and the status page record the result.
