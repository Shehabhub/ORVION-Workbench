# Workbench Change Request - WS-022

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

One clean three-folder layout and no known defect before Batch 6: a temporary-root resolver binds only exact clone homes and sets managed process temp; data-root defaults refuse instead of writing into source; the five WS-023 after-pass fixes; records-based backup/restore with three Claude memory junctions and data-root .git refusal; Restore-Workspace -Temporary rebuilds the temporary skeleton and the pinned actionlint 1.7.12, and the launcher registers the hourly map task; archive sidecar lock; Events current-row dedupe, repo auto-fill and -Repo filter; Pulse masked footer, urgent visibility and map freshness; Hunt map-task guard; scanner dot-invoke fallback; Spider over every repository; the Markdown consistency guard with one role and a word budget per root document, a one-home table, a history index and a Working with Codex section; root RESUME.md becomes the active pointer plus one line to the private live state.

## Baseline

a3c5f2b52a1bb1da81ad6d24ec98967a18f74b5f

## Write Scope

- .githooks/pre-commit
- AGENTS.md
- changes/TEMPLATE.md
- docs/EXECUTION-PLAN.md
- docs/RECOVERY.md
- docs/WORKSPACE-LAYOUT.md
- HANDOFF.md
- lib/Backup-Workspace.ps1
- lib/Coordinator.ps1
- lib/Delegate.ps1
- lib/Events.ps1
- lib/hooks/Watch-Reminder.ps1
- lib/Hunt.ps1
- lib/Invoke-DraftRehearsal.ps1
- lib/Map-Repos.ps1
- lib/Pulse.ps1
- lib/README.md
- lib/Restore-ORVION.ps1
- lib/Restore-Workspace.ps1
- lib/Spider.ps1
- lib/Sync-Sessions.ps1
- lib/test-backup-restore.ps1
- lib/test-coordinator.ps1
- lib/test-events.ps1
- lib/test-hunt.ps1
- lib/test-map-repos.ps1
- lib/test-markdown-consistency.ps1
- lib/Test-MarkdownConsistency.ps1
- lib/test-pulse.ps1
- lib/test-restore-orvion.ps1
- lib/Test-ScriptHazards.ps1
- lib/test-spider.ps1
- lib/test-sync-sessions-ack.ps1
- lib/test-sync-sessions-survival.ps1
- lib/test-watch-reminder.ps1
- lib/test-workbench-governance.ps1
- lib/test-workspace-layout.ps1
- lib/Watch-Subagents.ps1
- lib/Workbench.ps1
- lib/workspace-layout.ps1
- README.md
- RESUME.md
- tests.ps1
- WORKFLOW.md

## Out of Scope

All other engineering paths except native allocation/status/pointer bookkeeping. No checker (Test-WorkbenchChange.ps1), applier, workflow file, GitHub setting, user setting or product repository change. No WORKSTATION-profile path: the -Temporary rebuild only recreates the disposable skeleton and the judge-pinned actionlint; client installation and workstation preparation stay out (Codex before-pass). No file deletion (the step tooling has no delete step; config/README.md stays, now linked). No data migration is performed by this contract. CTRL-19 stays OPEN; Batch 6/Phase 8 stay ON HOLD until the owner's lift record; clean-Windows recovery stays UNPROVEN (residual risk accepted by the owner).

## Draft Assurance

V1: WS022-ONE-CLEAN-LAYOUT-DESIGN | 2026-10-27 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-022\package\assurance\V1\DRAFT.md | 7D4346FC219330D4A030E66C2D72E0660EC1BAD8A32AB45C214A58C06994B043
V2: WS022-ONE-CLEAN-LAYOUT-ADVERSARIAL | 2026-10-27 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-022\package\assurance\V2\DRAFT.md | B20A249AF3D8D1CFFC3EAE2216BBE8A9570B2B248DFC1936DC406C9588E38B16
V3: WS022-ONE-CLEAN-LAYOUT-REFRESH | 2026-10-27 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-022\package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W22
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W22\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W22\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-022\package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `.githooks/pre-commit` contains `refuse_temp() { echo 'WORKBENCH: BLOCKED'; echo "CODE: $1"; exit 1; }`; if so record Already Applied when its Git blob is eaf7682a43493279eeb786b2ef746e669eec3191, and otherwise stop and report. Otherwise make exactly this one edit (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
   judge=$(mktemp "${TMPDIR:-/tmp}/workbench-judge-XXXXXXXX.ps1") || exit 1
   ```
   with
   ```text
   refuse_temp() { echo 'WORKBENCH: BLOCKED'; echo "CODE: $1"; exit 1; }
   # Resolve without executing proposed checkout code. Keep in step with lib/workspace-layout.ps1.
   temporary=${WORKBENCH_TEMP_ROOT:-}
   if [ -z "$temporary" ]; then
       # Only the exact clone homes bind: <temporary>/cx/<name> and <temporary>/sb/<WS>/<name>.
       lower() { basename "$1" | tr '[:upper:]' '[:lower:]'; }
       p=$(dirname "$root"); gp=$(dirname "$p"); ggp=$(dirname "$gp")
       if [ "$(lower "$p")" = cx ] && [ "$(lower "$gp")" = orvion-workbench-temporary ]; then temporary=$gp
       elif [ "$(lower "$gp")" = sb ] && [ "$(lower "$ggp")" = orvion-workbench-temporary ]; then temporary=$ggp
       elif [ -n "${RUNNER_TEMP:-}" ] || [ "${GITHUB_ACTIONS:-}" = true ] || [ "${ORVION_STANDALONE_TEMP:-}" = 1 ]; then
           temporary="${RUNNER_TEMP:-${TEMP:-/tmp}}/ORVION-Workbench"
       else
           case $(lower "$root") in
               orvion-workbench|orvion-workbench-trusted-main) temporary="$p/ORVION-Workbench-temporary" ;;
               *) refuse_temp WB_TEMP_LAYOUT_UNAVAILABLE ;;
           esac
       fi
   fi
   case "$temporary" in /*|[A-Za-z]:[\\/]*) ;; *) refuse_temp WB_TEMP_ROOT_NOT_ABSOLUTE ;; esac
   temporary=$(cygpath -am "$temporary") || refuse_temp WB_TEMP_ROOT_NOT_ABSOLUTE
   case $(printf '%s' "$temporary/" | tr '[:upper:]' '[:lower:]') in
       "$(printf '%s' "$root/" | tr '[:upper:]' '[:lower:]')"*) refuse_temp WB_TEMP_ROOT_INSIDE_CHECKOUT_REFUSED ;;
   esac
   managed=$(cygpath -u "$temporary")/tmp
   mkdir -p -- "$managed" || refuse_temp WB_TEMP_MATERIALIZATION_FAILED
   TEMP=$(cygpath -w "$managed"); TMP=$TEMP; TMPDIR=$managed
   export TEMP TMP TMPDIR
   judge=$(mktemp "$managed/workbench-judge-XXXXXXXX.ps1") || refuse_temp WB_TEMP_MATERIALIZATION_FAILED
   ```

   The resulting file's Git blob is eaf7682a43493279eeb786b2ef746e669eec3191.

2. Check whether `AGENTS.md` contains `Router only (Codex and other agents that read AGENTS.md): read [README.md](README.md), then [RESUME.md](RESUME.md), then [HANDOFF.md](HANDOFF.md).`; if so record Already Applied when its Git blob is ea8fdf7acef489dbcddb870b0670679baa4d51ed, and otherwise stop and report. Otherwise make exactly this one edit (One clean layout only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   Router only (Codex and other agents that read AGENTS.md): read `README.md`, then `RESUME.md`, then `HANDOFF.md`.
   Workbench's own engineering entry is `lib/Workbench.ps1 -Boot`; its authority is `WORKFLOW.md`.
   ```
   with
   ```text
   Router only (Codex and other agents that read AGENTS.md): read [README.md](README.md), then [RESUME.md](RESUME.md), then [HANDOFF.md](HANDOFF.md).
   Workbench's own engineering entry is `lib/Workbench.ps1 -Boot`; its authority is [WORKFLOW.md](WORKFLOW.md).
   ```

   The resulting file's Git blob is ea8fdf7acef489dbcddb870b0670679baa4d51ed.

3. Check whether `changes/TEMPLATE.md` contains `Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\<WS>\sb`; if so record Already Applied when its Git blob is 8daa5a6d81a5921a074cbf01e9f187b3b34af3c2, and otherwise stop and report. Otherwise make exactly this one edit (One clean layout only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   Sandbox Parent: absolute independently owned disposable parent outside the original
   Tests Root: absolute short external fixture parent, with proven safe full revision/path probe
   Temp Root: absolute external tool/operation-temp parent
   Runtime Root: absolute external evidence/log parent
   ```
   with
   ```text
   Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\<WS>\sb
   Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\<WS>\t
   Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\<WS>\tmp
   Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\<WS>\runtime
   ```

   The resulting file's Git blob is 8daa5a6d81a5921a074cbf01e9f187b3b34af3c2.

4. Check whether `docs/EXECUTION-PLAN.md` contains `Version 2.0 | 2026-10-27 | Batch 6 gate is HANDOFF §12 (amended); status/evidence dated at Draft freeze, native live state owns execution`; if so record Already Applied when its Git blob is 55ebfa5da39752c74010083a0825547e75b59de5, and otherwise stop and report. Otherwise make exactly these 9 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
   Version 1.9 | 2026-10-26 | Batch 6 gate is HANDOFF §12 (amended); status/evidence dated at Draft freeze, native live state owns execution
   ```
   with
   ```text
   Version 2.0 | 2026-10-27 | Batch 6 gate is HANDOFF §12 (amended); status/evidence dated at Draft freeze, native live state owns execution
   ```

   b) replace the line
   ```text
   This is the owner's current remaining execution sequence. It supersedes earlier conversational sequencing, not immutable contracts or the acceptance map in [03-WORKBENCH.md](<C:\Users\My Lab\Documents\ORVION-Owner-Review\owner-workbench-handoff-20261021\runbooks\03-WORKBENCH.md>). Do not create a competing roadmap, approval registry or active-contract register.
   ```
   with
   ```text
   This is the owner's current remaining execution sequence. It supersedes earlier conversational sequencing, not immutable contracts or the [preserved P3 acceptance map](history/programme/workbench-acceptance-v10.md). Do not create a competing roadmap, approval registry or active-contract register.
   ```

   c) replace the line
   ```text
   Start at [README.md](../README.md), then follow the newest `RESUME HERE` checkpoint routed by [RESUME.md](../RESUME.md), then run `pwsh -NoProfile -File lib/Workbench.ps1 -Boot`. Workbench RESUME owns its active engineering contract; each product owns its own lifecycle. Live owner instructions win; otherwise follow the owning README/AGENTS/Boot and exact contract. Historical HANDOFF files and reports never grant a new scope.
   ```
   with
   ```text
   Start at [README.md](../README.md), then follow the private live-state route in [RESUME.md](../RESUME.md), then run `pwsh -NoProfile -File lib/Workbench.ps1 -Boot`. Workbench RESUME owns its active engineering contract; each product owns its own lifecycle. Live owner instructions win; otherwise follow the owning README/AGENTS/Boot and exact contract. Historical HANDOFF files and reports never grant a new scope.
   ```

   d) replace the line
   ```text
   | Workbench / ORVION-Owner-Tools | f42c5a098ca69a156e38e7ae8d9a5475c850f288 | WS004 local completion preserved; later owner-authorized private initial main publication and exact clone/Boot verified; [own result](<C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-stage-integrity-20261023-r2\runtime\original\result.json>), [publication](<C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-supervision-20261023\runtime\remote-bootstrap\result.json>) |
   ```
   with
   ```text
   | Workbench / ORVION-Owner-Tools | f42c5a098ca69a156e38e7ae8d9a5475c850f288 | WS004 local completion preserved; later owner-authorized private initial main publication and exact clone/Boot verified; [historical citation: own result](<C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-stage-integrity-20261023-r2\runtime\original\result.json>), [historical citation: publication](<C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-supervision-20261023\runtime\remote-bootstrap\result.json>) |
   ```

   e) replace the lines
   ```text
   | Native repair closure | Separate original receipts | [RELEASE-RESULT.json](<C:\Users\My Lab\Documents\ORVION-Owner-Review\native-brief-unreadable-20261023\RELEASE-RESULT.json>) |
   | Contract B | PT SPEC-294 / FD SPEC-296 released | [B result](<C:\Users\My Lab\Documents\ORVION-Owner-Review\contract-b-release-interface-20261021\runtime\local-source-result.json>), current ContractBRelease section |
   | WS005 readiness-r4 | Complete 2310836a2b70f6e98b85a30a490efd286a85417f; actual canonical cutover ACTIVATED | [Original sealed evidence](<C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-supervision-20261023\runtime\readiness-r4\original\EVIDENCE.json>): 21 suites PASS, Finish 00:14:32, timed 14.6 min, receipt E703219A73CD76451FBB4DA83CFCC70D8055AF81DEC53989EDE4FFEE5C738DFD; Review/Complete/accepted range READY. These results prove readiness, not general native management |
   ```
   with
   ```text
   | Native repair closure | Separate original receipts | [historical citation: RELEASE-RESULT.json](<C:\Users\My Lab\Documents\ORVION-Owner-Review\native-brief-unreadable-20261023\RELEASE-RESULT.json>) |
   | Contract B | PT SPEC-294 / FD SPEC-296 released | [historical citation: B result](<C:\Users\My Lab\Documents\ORVION-Owner-Review\contract-b-release-interface-20261021\runtime\local-source-result.json>), current ContractBRelease section |
   | WS005 readiness-r4 | Complete 2310836a2b70f6e98b85a30a490efd286a85417f; actual canonical cutover ACTIVATED | [historical citation: Original sealed evidence](<C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-supervision-20261023\runtime\readiness-r4\original\EVIDENCE.json>): 21 suites PASS, Finish 00:14:32, timed 14.6 min, receipt E703219A73CD76451FBB4DA83CFCC70D8055AF81DEC53989EDE4FFEE5C738DFD; Review/Complete/accepted range READY. These results prove readiness, not general native management |
   ```

   f) replace the line
   ```text
   4. Check current HEAD, dirt and selected source/config anchors. Historical `C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WS005\prototype` contains preserved readiness edits, not a current clean management baseline. Do not reset it or rerun Prepare-Supervision.ps1. A new proposal uses an absent destination outside authoritative trees, an independent Git/common directory and object store with no alternates/hardlinks, push DISABLED and the exact accepted baseline recorded in its own existing preparation evidence. No existing preparation file grants a new approval.
   ```
   with
   ```text
   4. Check current HEAD, dirt and selected source/config anchors. Preserve the historical WS005 readiness prototype; it is not a current clean management baseline. Do not reset it or rerun Prepare-Supervision.ps1. A new proposal uses an absent destination outside authoritative trees, an independent Git/common directory and object store with no alternates/hardlinks, push DISABLED and the exact accepted baseline recorded in its own existing preparation evidence. No existing preparation file grants a new approval.
   ```

   g) replace the line
   ```text
   6. Execute original scope through its own fresh Finish, actual Review/Complete and normal hook/range/candidate rules. Never transplant a sandbox receipt. The private source remote now exists; source publication is distinct from hosted enforcement/certification, which is not yet implemented for Workbench. Never invent a hosted CI result or native REMOTE_CERTIFY for it.
   ```
   with
   ```text
   6. Execute original scope through its own fresh Finish, actual Review/Complete and normal hook/range/candidate rules. Never transplant a sandbox receipt. The public source remote and local CI capability exist, and the dated exact hosted success above is recorded. Source publication, hosted success, effective protection and remote certification remain separate evidence classes. Never invent a fresh hosted result or native REMOTE_CERTIFY.
   ```

   h) replace the line
   ```text
   The checker still rejects Sandbox/Tests/Temp/Runtime overlap with the authoritative checkout. Keep managed operational data external. Until a tested stage5 cutover, use existing declared external packet/factory roots and the one event/session data root: `ORVION_DATA_ROOT`, else the sibling `ORVION-Owner-Tools` when it has `events\`, else this checkout. A future consolidated `GitHub/ORVION-Workbench-Data` sibling is a target, not created or installed by this plan. This deliberate external data boundary preserves isolation; ignored folders are not an exemption.
   ```
   with
   ```text
   The checker still rejects Sandbox/Tests/Temp/Runtime overlap with the authoritative checkout. [WORKSPACE-LAYOUT.md](WORKSPACE-LAYOUT.md#3-private-data-and-disposable-trees) owns the three roles: private data/records under ORVION-Owner-Tools and disposable sandbox/test/temp/tool roots under ORVION-Workbench-temporary. The earlier Workbench-Data proposal is superseded; sealed historical paths remain unchanged. [lib/README.md](../lib/README.md) owns the actual data resolver and missing-store refusal. Existing exact approved roots retain their bindings until tested cutover; ignored folders are not an exemption.
   ```

   i) replace the line
   ```text
   - 2026-10-26 / v1.9: under the owner's exceptional delegation and reinstall directive, decoupled Batch 6 from Stage 7 and P3 management; HANDOFF §12 owns the gate. Stage 6 recovery is to be delivered as WS-015's selective package with C1 same-machine restore; the package is unencrypted by owner decision (2026-10-26), which replaces the encrypted destination/key conditions of Stages 6-7 for it, with a redacted secret-scan report instead; clean-Windows recovery (C2) is the owner's planned reinstallation via docs/RECOVERY.md. No stage, P3 obligation or frozen evidence was deleted.
   ```
   with
   ```text
   - 2026-10-27 / v2.0: root roles and Markdown guard reconciled; current P3 reference routes to the tracked history copy, live state routes through RESUME, source/CI evidence classes and three-folder storage roles corrected. HANDOFF §12 retains the amended C2 gate; no old test result certifies these new bytes.

   - 2026-10-26 / v1.9: under the owner's exceptional delegation and reinstall directive, decoupled Batch 6 from Stage 7 and P3 management; HANDOFF §12 owns the gate. Stage 6 recovery is to be delivered as WS-015's selective package with C1 same-machine restore; the package is unencrypted by owner decision (2026-10-26), which replaces the encrypted destination/key conditions of Stages 6-7 for it, with a redacted secret-scan report instead; clean-Windows recovery (C2) was then the owner's planned reinstallation via docs/RECOVERY.md. No stage, P3 obligation or frozen evidence was deleted.
   ```

   The resulting file's Git blob is 55ebfa5da39752c74010083a0825547e75b59de5.

5. Check whether `docs/RECOVERY.md` contains `Updated 2026-10-27. [Workspace layout](WORKSPACE-LAYOUT.md) owns the source/private/disposable boundary.`; if so record Already Applied when its Git blob is 66f998d97231e5e8e48c7b44f1963b15f3ebf590, and otherwise stop and report. Otherwise make exactly these 11 edits (One clean layout only), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
   # Workbench recovery: before and after reinstalling Windows

   ```
   insert
   ```text
   Updated 2026-10-27. [Workspace layout](WORKSPACE-LAYOUT.md) owns the source/private/disposable boundary.

   ```

   b) replace the lines
   ```text
   | One data root: `ORVION_DATA_ROOT`, else sibling `ORVION-Owner-Tools` when it has `events\`, else this checkout: sessions archive, events journal, work | Clean nested clones (each keeps `.clone-state\state.json`: origin, HEAD, refs) |
   | Documents\ORVION-Owner-Review, -Owner-Tools, -Owner-Recovery, -Sandbox, -drafts-backup, Windows-Memory-Config | node_modules (reinstalled from lockfiles) |
   ```
   with
   ```text
   | One private data root resolved as documented in [lib/README.md](../lib/README.md): records, sessions, events and protected working evidence | Disposable temporary tree: rebuild clones, fixtures, scratch and tools |
   | Reviewed retained legacy inputs and Windows-Memory-Config; historical source locations below | node_modules (reinstalled from lockfiles) |
   ```

   c) replace the line
   ```text
   a linked worktree in a main repository, or files under the one data root's `work\sandboxes`. Commit or remove them first.
   ```
   with
   ```text
   a linked worktree in a main repository, or files under the one data root's `work\sandboxes`. Commit or remove them only under their owning authority first. Protected records/runtime and required unique evidence remain package inputs; disposable temporary trees are excluded.

   Historical citation: Documents\ORVION-Owner-Review, Documents\ORVION-Owner-Tools, Documents\ORVION-Owner-Recovery, Documents\ORVION-Sandbox, Documents\ORVION-drafts-backup and Documents\Windows-Memory-Config were the retained legacy inputs. Their sealed paths are provenance, not current entry routes.
   ```

   d) replace the lines
   ```text
   1. Make the package straight into OneDrive (an agent may run this). The recovery-input map in use is
      `C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\recovery-inputs.json`.
      `pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\lib\Backup-Workspace.ps1" -Destination "C:\Users\My Lab\OneDrive\ORVION-Recovery" -RecoveryInputs "<map above>" -Package`
   ```
   with
   ```text
   1. Make the package straight into OneDrive (an agent may run this). Select the actual reviewed recovery-input map from the owning private records; do not guess a relocated filename.
      `pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\lib\Backup-Workspace.ps1" -Destination "C:\Users\My Lab\OneDrive\ORVION-Recovery" -RecoveryInputs "<reviewed map>" -Package`
   ```

   e) replace the line
   ```text
      interrupted, delete any `%TEMP%\orvion-package-*` folder by hand. Keep the newest two or three packages; delete older.
   ```
   with
   ```text
      interrupted, inspect its owned staging under the managed temporary root before removing it. Keep the newest two or three packages; retire older copies only after required evidence/retention checks.
   ```

   f) replace the line
   ```text
   fallback), hydrates/verifies it, and extracts once into the new `C:\ORVION-Temp`. It clones the package's own Workbench
   ```
   with
   ```text
   fallback), hydrates/verifies it, and extracts once under the selected ORVION-Workbench-temporary staging root. It clones the package's own Workbench
   ```

   g) replace the lines
   ```text
   marketplace/install commands (GitKraken uses its own CLI/hook installer), then run
   `pwsh -File <Target>\ORVION-Workbench\lib\Map-Repos.ps1 -Install`.
   Use `<Target>\ORVION-Owner-Tools` as the data root; repair/unset an old `ORVION_DATA_ROOT` before hooks or readers.
   ```
   with
   ```text
   marketplace/install commands (GitKraken uses its own CLI/hook installer). For manual map-task recovery use
   `pwsh -File <Target>\ORVION-Workbench\lib\Map-Repos.ps1 -Install -GitHub <Target>`.
   Use `<Target>\ORVION-Owner-Tools` as the data root; repair/unset an old `ORVION_DATA_ROOT` before hooks or readers. Persistent recovery inputs are restored under `records\recovery-inputs`, including the original source map. Claude project memory is stored under `records\claude-memory\<project>` and restored to each client through a verified junction. Memory destinations are preflighted before repository writes: conflicting directories, wrong or dangling foreign links refuse; an existing junction must target exactly that project's restored memory. This explicit memory adapter does not permit junctions to hide a persistent destination inside disposable staging.

   Rebuild disposable storage with `pwsh -NoProfile -File <Target>\ORVION-Workbench\lib\Restore-Workspace.ps1 -Temporary -Target <Target>`. This narrow route needs no package or private journal and provisions the verified pinned `<Target>\ORVION-Workbench-temporary\tools\actionlint.exe`; it refuses corrupt existing bytes. Actionlint is required for owning workflow checks, not an optional global install. Set WORKBENCH_ACTIONLINT to that executable for focused tests.

   The launcher invokes both the narrow -Temporary rebuild and Map-Repos -Install after restore. The latter restores the hourly/logon refresh task and regenerates ai-map.html/json, the named source-root exceptions. Use the explicit commands above for manual fallback or an owning failed-step recovery. A restored task or map is discovery evidence, never certification.
   ```

   h) replace the lines
   ```text
   extract once with `7z x <archive> -oC:\ORVION-Temp\pkg`. Clone
   `C:\ORVION-Temp\pkg\orvion-backup-<UTC>\repos\ORVION-Workbench.bundle` into `C:\ORVION-Temp\wb`, check out its
   ```
   with
   ```text
   extract once with `7z x <archive> -o<temporary>\pkg`. Clone
   `<temporary>\pkg\orvion-backup-<UTC>\repos\ORVION-Workbench.bundle` into `<temporary>\wb`, check out its
   ```

   i) replace the line
   ```text
   `pwsh -NoProfile -File C:\ORVION-Temp\wb\lib\Restore-Workspace.ps1 -From C:\ORVION-Temp\pkg\orvion-backup-<UTC>`.
   ```
   with
   ```text
   `pwsh -NoProfile -File <temporary>\wb\lib\Restore-Workspace.ps1 -From <temporary>\pkg\orvion-backup-<UTC>`.
   ```

   j) replace the lines
   ```text
   `workstation.cmd`, and complete the same checklist above. Workbench's pinned external actionlint requirement remains
   in WORKFLOW.md; it is not installed by recovery. Session archive error acknowledgement remains documented in
   ```
   with
   ```text
   `workstation.cmd`, and complete the same checklist above. Use the -Temporary route above for required pinned actionlint. Session archive error acknowledgement remains documented in
   ```

   k) immediately after the lines
   ```text
   ## Not yet proven

   ```
   insert
   ```text
   The separate USB route remains available: Backup-Workspace -Destination <drive> requires an encrypted drive and reports a dirty checkout (uncommitted work is not in a bundle). Enable BitLocker To Go before that route. Restore-Workspace -From <backup> verifies every manifest hash before writes, never overwrites, and restores refs/HEAD, safe local configuration and bound records. Re-login to both GitHub accounts and run each owning Boot afterward. The earlier backup/restore fixture proved identical refs, bytes and expected Boots, plus corrupt/existing-target refusals; that simulated proof never established clean-Windows recovery. System-drive BitLocker remains an owner choice, distinct from the unencrypted package decision.

   ```

   The resulting file's Git blob is 66f998d97231e5e8e48c7b44f1963b15f3ebf590.

6. Check whether `docs/WORKSPACE-LAYOUT.md` contains `Version 2.0 | 2026-10-27 | Three folders; public source, private data and disposable storage`; if so record Already Applied when its Git blob is d77fe0c40c9a7b04a961d3162ae38976c55e3da9, and otherwise stop and report. Otherwise make exactly this one edit (One clean layout only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   # ORVION-Workbench - Target Workspace and Repository Layout

   Version 1.5 | 2026-10-24 | Owner-created source root reconciled; data cutover remains pending

   ## HANDOFF

   - INHERITED: [EXECUTION-PLAN.md](EXECUTION-PLAN.md), existing independent product governance and the accepted Workbench checker/tool library.
   - PROVEN: Current library names, contract template, native map generator and root-isolation rules were inspected. The owner-created source clone is at GitHub/ORVION-Workbench; old local data and external packets/sandboxes remain in place.
   - UNPROVEN: Physical relocation, new configuration/catalog interfaces, proposed packet layout enforcement and future tools. A directory diagram does not implement a guard or prove recovery.
   - CHANGED: This document gives full target names, evidence placement, selection semantics, ownership and migration rules. No directory creation/move, source installation or exact implementation approval is implied.
   - REMAINING: Introduce each required surface through its owning plan stage and frozen scope; prove consumers and recovery before cutover.
   - DO NOT TOUCH: Accepted paths during active operations; frozen Drafts/history; original receipts/refs/configurations; raw archives/secrets. No nested product repositories, shared-Git sandbox shortcut or automatic deletion.
   - NEXT: WS005 readiness and source-plan cutover are COMPLETE. Follow the sole live checkpoint and canonical execution plan for the remaining P3 capability. Preserve the historical dirty prototype and use a fresh independent exact-baseline clone for a new proposal. Storage migration remains stage 5; proposed data/config paths are not installed.

   ## 1. Actual source root and external operational boundary

   Owner-selected source repository: `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench`.

   The owner independently cloned the private Shehabhub/ORVION-Workbench repo here and authorized work in it on client date 2026-10-24. Observed HEAD f42c5a098ca69a156e38e7ae8d9a5475c850f288, clean independent Git directory, no alternates, own Boot READY. The existing `.githooks` adapter was enabled in local config and actual admission passed. That is the historical source-admission observation. WS005 R4 later completed at 2310836a2b70f6e98b85a30a490efd286a85417f with its own fresh original Finish/Review/Complete/range and actual canonical plan/layout cutover. Old-root local data remains unmigrated; general native management and recovered workstation state are still unproven.

   The earlier non-Git parent/control/data topology is superseded by this actual source placement. Do not move/nest the owner clone, recreate its history or weaken the checker to put sandboxes/tests/temp/runtime under it. Source stays at the exact requested path. Existing packets/factory and the one old ORVION-Owner-Tools journal/archive remain external and unchanged until tested cutover. A future consolidated `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-Data` sibling groups those operational roles; that target is not created or installed yet. No guessed aliases, parallel live journal or blank replacement history.

   Keep the current Git repository/history, `lib` and existing command names. Preserve the old clone/data until dependencies, active archiver and recovery are proven. Git metadata and engine-owned ignored receipts stay local at their actual owning source root. Historical root-bound evidence remains history; it does not certify this new checkout.

   Legend: EXISTING means an actual current file/name, not proof it already occupies this target path. PROPOSED means a new surface that still needs its owning contract. CONDITIONAL means create only when its actual implementation is earned. Examples such as WS005/run-001 are identifiers, not instructions to allocate a contract or create all folders now.

   ### Proposed independent Workbench trusted-main checkout

   Target: `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-trusted-main`.

   This is a PROPOSED independent Git checkout of the same authorized private Shehabhub/ORVION-Workbench repository. It is an external sibling of source, not a linked worktree, nested repository, submodule, shared common Git directory or shared object store/alternates. Its role is trusted evaluation from previously accepted Workbench governance and owner-controlled release judgment. Its existence, configuration, credentials, trusted baseline and operational capability have NOT been established by this documentation change. Do not create or configure it here.

   The complete workspace therefore includes these explicit external bindings (locations are roles, never inferred dispatch authority):

       Documents/GitHub/
       |-- ORVION-Workbench/                  [EXISTING source; own local lifecycle]
       |-- ORVION-Workbench-trusted-main/     [PROPOSED independent trusted evaluation/release checkout]
       |-- ORVION-Workbench-Data/             [PROPOSED operational data; Stage 5, not installed]
       |-- CRM/                              [EXISTING independent Platinum source]
       |-- CRM-trusted-main/                 [EXISTING independent Platinum trusted checkout]
       |-- ORVION/                           [EXISTING independent Founder source]
       `-- ORVION-trusted-main/               [EXISTING independent Founder trusted checkout]

   Stage 3 of EXECUTION-PLAN.md owns hosted acceptance, governed preflight publication, exact SHA binding, trusted-baseline evaluation and candidate self-exemption refusal, enforceable private GitHub branch protection, separately authorized promotion and separate local/hosted/trusted/remote evidence. A proposed checkout or local hook is not activated hosted protection. Owner-reviewed private-plan/ruleset limitations remain dated evidence until revalidated at implementation; never change visibility, purchase a plan, alter account permissions or enable/bypass settings without separate authority. Unavailable private protection remains an exact capability blocker. The initial hosted bootstrap must use explicitly reviewed accepted authority and separate authorization, not self-approval or an impossible prior-workflow dependency. Stage 6 owns clean-machine recovery and fresh remote enforcement checks for this trusted boundary.

   ## 2. Full control repository tree

       ORVION-Workbench/                                 [actual independent Git source root]
       |-- .git/                                    [local Git metadata; never copied into tracked payload]
       |-- .gitattributes                           [EXISTING]
       |-- .gitignore                               [EXISTING; not a security boundary]
       |-- .github/                                 [PROPOSED hosted security scope; not installed]
       |   `-- workflows/                           [PROPOSED Workbench-specific hosted acceptance; filename/check identity earned in Stage 3]
       |-- .githooks/
       |   `-- pre-commit                           [EXISTING accepted admission adapter]
       |-- AGENTS.md                                [EXISTING agent route]
       |-- README.md                                [EXISTING human/agent entry]
       |-- RESUME.md                                [EXISTING own active-contract pointer]
       |-- HANDOFF.md                               [EXISTING historical programme reference]
       |-- WORKFLOW.md                              [EXISTING own governance]
       |-- tests.ps1                                [EXISTING full-suite owner]
       |-- ai-map.json                              [PROPOSED generated local projection; normally ignored]
       |-- repository-index.md                      [PROPOSED generated local human view; normally ignored]
       |-- .workbench-local-certification.json       [EXISTING local ignored engine receipt]
       |-- .workbench-certifications/               [EXISTING local ignored receipt archives]
       |-- changes/
       |   |-- TEMPLATE.md                          [EXISTING]
       |   |-- WS-001-workbench-local-governance.md  [EXISTING immutable history]
       |   |-- WS-002-execution-context-binding.md  [EXISTING immutable history]
       |   |-- WS-003-observer-integrity.md          [EXISTING immutable history]
       |   |-- WS-004-native-stage-integrity.md      [EXISTING immutable history]
       |   `-- WS-005-arrival-source-readiness.md    [EXISTING Complete R4; later contracts use actual allocation]
       |-- docs/                                    [EXISTING selected durable documentation]
       |   |-- EXECUTION-PLAN.md                     [EXISTING single selected source plan]
       |   `-- WORKSPACE-LAYOUT.md                   [EXISTING selected architecture]
       |-- config/                                  [PROPOSED non-secret examples only]
       |   `-- roots.example.psd1                   [example of logical roots; schema not frozen]
       |-- lib/                                     [preserve ALL existing names below]
       |   |-- README.md
       |   |-- Workbench.ps1
       |   |-- Test-WorkbenchChange.ps1
       |   |-- Test-ScriptHazards.ps1
       |   |-- Invoke-ContractStage.ps1
       |   |-- Test-ContractReview.ps1
       |   |-- Invoke-DraftSteps.ps1
       |   |-- apply-draft-steps.ps1
       |   |-- Invoke-DraftRehearsal.ps1
       |   |-- Owner-PublishDual.ps1
       |   |-- Owner-PromoteDual.ps1
       |   |-- Invoke-OwnerDual.ps1
       |   |-- Test-OwnerDualAdmission.ps1
       |   |-- run_timed.ps1
       |   |-- watch_run.ps1
       |   |-- Watch-Host.ps1
       |   |-- Watch-Subagents.ps1
       |   |-- Pulse.ps1
       |   |-- Events.ps1
       |   |-- Coordinator.ps1
       |   |-- Spider.ps1
       |   |-- Hunt.ps1
       |   |-- Delegate.ps1
       |   |-- Sync-Sessions.ps1
       |   |-- Backup-Workspace.ps1
       |   |-- Restore-Workspace.ps1
       |   |-- lifecycle.ps1
       |   |-- remove-owned.ps1
       |   |-- hooks/
       |   |   `-- Watch-Reminder.ps1               [EXISTING nested hook adapter]
       |   |-- fixtures/
       |   |   `-- seed-events.ps1                  [EXISTING nested fixture helper]
       |   |-- test-workbench-governance.ps1
       |   |-- test-native-stage.ps1
       |   |-- test-owner-dual.ps1
       |   |-- test-draft-steps.ps1
       |   |-- test-lifecycle-failclosed.ps1
       |   |-- test-coordinator.ps1
       |   |-- test-events.ps1
       |   |-- test-events-retrieval.ps1
       |   |-- test-spider.ps1
       |   |-- test-hunt.ps1
       |   |-- test-delegate.ps1
       |   |-- test-watch-host.ps1
       |   |-- test-watch-subagents.ps1
       |   |-- test-watch-reminder.ps1
       |   |-- test-sync-sessions-append.ps1
       |   |-- test-sync-sessions-rewrite.ps1
       |   |-- test-sync-sessions-secrets.ps1
       |   |-- test-sync-sessions-survival.ps1
       |   |-- test-backup-restore.ps1
       |   |-- test-remove-owned.ps1
       |   `-- test-pulse.ps1                        [EXISTING WS005 owning caller tests]
       `-- workstation/                             [CONDITIONAL stage 6 requirements, not empty scaffold]
           `-- requirements.psd1                     [only if a separate owned manifest is earned]

   No separate gates/profiles/engines folders are introduced: those mechanisms already belong to the accepted checker and owning scripts. Do not move tests out of lib; tests.ps1 currently discovers/executes their bound recipe there. A new WS005 transport helper or generator and its test must receive concrete names from the proven prototype/frozen scope, not an assumed command copied from a diagram.

   No CI workflow is installed by this layout. The private source remote already exists; add actual hosted admission only through its separately owned CI scope. Workstation Doctor/Prepare commands are likewise not invented here: stage 6 must select real existing adapters or earn explicitly tested additions. General AI/MCP/search services are not added as architecture scaffolding.

   ## 3. Full local-data tree

       ORVION-Workbench-Data/                            [target external data root; not installed]
       |-- config/
       |   `-- roots.local.psd1                      [PROPOSED sole local location binding]
       |-- legacy/                                  [CONDITIONAL preserved historical bundles]
       |   |-- ORVION-Owner-Review/                  [retain required original relative structure]
       |   |-- ORVION-Sandbox/                       [only inventoried protected historical content]
       |   |-- ORVION-Owner-Tools/                   [old external owner tools, not a second live lib]
       |   `-- ORVION-drafts-backup/                 [required provenance, not an active Draft route]
       |-- packets/
       |   `-- WS005/                               [example unit identity; not Gate 1]
       |       |-- planning/
       |       |   |-- PLAN.md                      [one working proposal for this unit]
       |       |   `-- revisions/
       |       |       |-- P01-design.md             [retained substantial plan revision]
       |       |       `-- P02-correction.md         [evidence/reason for an earned correction]
       |       |-- assurance/
       |       |   |-- V1/
       |       |   |   `-- DRAFT.md                 [Design snapshot]
       |       |   |-- V2/
       |       |   |   `-- DRAFT.md                 [Adversarial Review snapshot + findings]
       |       |   `-- V3/
       |       |       `-- DRAFT.md                 [Evidence Refresh; selected reasons/sources in footer]
       |       |-- selected/
       |       |   `-- selection.json               [derived pointer to exact V3 bytes; no copied Draft]
       |       |-- authority/
       |       |   |-- sandbox-approval.json        [actual decision evidence when lawful/applicable]
       |       |   `-- original-approval.json       [actual human or honest DELEGATED evidence]
       |       |-- config/
       |       |   |-- platinum.psd1                [only when this target is selected]
       |       |   `-- founder.psd1                 [only when this target is selected]
       |       |-- payload-source/                 [selected output bytes, not another editable engine]
       |       |-- accepted/                       [preserved accepted evaluator inputs if required]
       |       |-- payload.json                    [literal replay/output identities]
       |       |-- EVIDENCE.json                   [packet evidence pointers and declared classes]
       |       |-- SHA256SUMS.txt                  [sealed bounded immutable artifacts, excludes itself]
       |       `-- migration/                      [CONDITIONAL for an actual relocation unit]
       |           |-- path-map.json               [old/new/provenance mapping]
       |           `-- COPY-VERIFY.json            [actual copy/consumer verification evidence]
       |-- sandboxes/
       |   `-- WS005/
       |       |-- prototype/                      [independent Workbench Git clone, push DISABLED]
       |       |-- platinum/                       [independent native clone only when required]
       |       |-- founder/                        [independent native clone only when required]
       |       `-- third-fixture/                  [bounded explicit-routing proof only]
       |-- tests/                                  [short disposable test-fixture root]
       |   `-- run-001/                            [generated unique owned fixture identity]
       |-- temp/                                   [working scratch, not frozen assurance]
       |   `-- op-001/                             [generated unique owned operation identity]
       |-- runtime/
       |   `-- WS005/
       |       `-- run-001/                         [actual unique run identity]
       |           |-- operation.json              [existing operation record extended only if earned]
       |           |-- result.json                 [operation outcome, NOT native certification]
       |           |-- host.log                    [one shared host observer where warranted]
       |           `-- targets/
       |               `-- platinum/               [repeat only for explicitly selected subjects]
       |                   |-- finish.log
       |                   |-- finish.log.resources.csv
       |                   |-- watcher.log         [actual observer capture if supported/needed]
       |                   |-- finish.exit         [actual producer exit, not inferred success]
       |                   `-- receipt.json        [immutable captured native receipt when needed]
       |-- evidence/
       |   `-- WS005/                              [durable evidence not already owned by packet/run]
       |       `-- REVIEW.md                       [only a substantive owning review, not routine report]
       |-- sessions/
       |   |-- raw/
       |   |   |-- claude/                          [retain project/session/subagent/tool-result paths]
       |   |   `-- codex/                           [retain actual year/month/day archive layout]
       |   |-- index.jsonl                         [derived from retained archive, not vanished sources]
       |   `-- INDEX.md                            [derived human view]
       |-- events/
       |   `-- events.jsonl                        [the ONE existing event journal]
       |-- indexes/
       |   |-- catalog.json                        [PROPOSED local federated source/coverage catalog]
       |   `-- INDEX.md                            [PROPOSED derived human view]
       `-- graveyard/
           `-- q-001/                              [generated verified quarantine identity]
               |-- QUARANTINE.json                 [origin, verified UTC, content/hold/authority evidence]
               `-- content/                        [only specifically eligible quarantined material]

   All new JSON/PSD1 names in this tree are design proposals, not published schemas or existing command interfaces. Reuse an owning equivalent instead of introducing a duplicate record. Folders are created on demand for a real unit/run; do not allocate empty projects, fake approvals or placeholder receipts.

   ### Assurance and selected-version rules

   1. Planning/PLAN.md is editable pre-freeze design work. planning/revisions retains only substantial corrections worth preserving, not every thought or chat. It never changes an approved contract.
   2. V1, V2 and V3 have distinct IDs and SHA-256 identities, actual pass evidence and reviewable sources. V3 is the selected stage required by the current Workbench template. Preserve failed/rejected reasoning too.
   3. selected/selection.json points to the exact immutable assurance/V3/DRAFT.md by unit, version, relative location and digest. It is a derived locator, not approval and not a new registry. Human selected-version navigation is generated from that same pointer.
   4. Do not duplicate DRAFT.md inside selected. The current Draft Assurance V3 path and Approved Draft must identify the actual selected artifact; the approval identifies its exact bytes and execution root. No self-hash inside its own Draft and no assumed new selection schema accepted by current guards.
   5. Once frozen, never edit an assurance snapshot, payload or approval to repair an execution failure. Preserve it; use a lawful corrected successor/new identified bundle. Existing sealed packages remain byte-identical regardless of this new naming model.
   6. Rejected V1/V2 and required V3 evidence are protected knowledge, not disposable graveyard content. Only redundant scratch/clones/material independently proven eligible may enter quarantine after the required preservation and approvals.

   ### Evidence ownership: one file, clear role

   | Location | Owns | Does NOT own |
   |---|---|---|
   | ORVION-Workbench/changes | actual Workbench CR, legal status and runtime checkpoint | a product CR or duplicate approval registry |
   | ORVION-Workbench/docs | single selected plan and architecture after proven cutover | raw sessions, active run results or competing live state |
   | data/packets | unit proposal/assurance, approval artifacts, literal payload and seal | certification merely from being named selected |
   | data/runtime | real operation/log/exit/observer and captured result evidence | authority to waive native Finish/Review/CI |
   | data/evidence | substantive research/review not already owned elsewhere | mandatory per-session reports or duplicate logs |
   | data/indexes | generated pointers, source states and coverage | business truth, approvals or secrets |
   | data/events | existing append-only operational lessons/assignment | second active-CR state |
   | data/sessions | original retained transcripts and derived indexes | hidden reasoning or proof of work not recorded |

   Runtime logs supporting a required receipt remain protected even when old; directory name does not authorize cleanup. Original native/Workbench engine receipts stay at their owning paths. Captured immutable copies retain origin/digest and are evidence, never transplanted working receipts. Do not duplicate raw files into evidence merely to make the tree look complete.

   Tool-result attachments remain at their real archived relative paths; there is no new global sessions/tool-results folder. legacy is a protected history container only when preservation needs it, not a second working library or permission to copy every disposable clone. Inventory and map each retained bundle once; active units/checkpoints use their tested cutover routes, never an automatic wholesale move into legacy.

   ## 4. Logical roots and configuration

   Use the proposed local roots binding as a location adapter only: ControlRoot, SandboxRoot, TestsRoot, TempRoot, RuntimeRoot, PacketRoot, EvidenceRoot, SessionRoot, EventRoot, IndexRoot and GraveyardRoot. Select their actual schema through a reviewed implementation; this list is not an accepted PSD1 interface.

   Original Root maps to the actual ORVION-Workbench source checkout. The future external data-root roles are sandboxes, tests, temp and runtime. Until tested cutover, the exact current contract declares their existing external locations. Keep these roots distinct/non-overlapping as required by the actual checker. Native product/trusted roots are explicit external bindings keyed by repository identity, not inferred siblings. An operation's exact pinned config/contract still decides authority; editing roots.local cannot silently relocate an approved operation.

   Use relative paths inside each root; use declared absolute bindings between roots. Non-secret examples can be tracked; machine bindings, session catalogs, operation approvals and sensitive state remain local. Account handles may be named; token/password values never enter either tracked examples or generated catalogs.

   The current Pulse/Spider/session/backup tools have real path assumptions. A roots file alone does not implement indirection: each affected consumer must be changed/tested in scope. Current own receipt placement and raw-session relative layout must be preserved until their consumers prove any change. Generated catalogs include included/excluded/unreadable coverage and validate relevant freshness rather than trusting a timestamp alone.

   ## 5. Product repositories, backups and workstation boundary

       Agent -> ORVION-Workbench/lib/Workbench.ps1 -> selected native entry/engines -> own native receipts/verdicts
                         |                           |
                         +-> existing observers <----+ actual runs/logs
                         +-> declared data roots / generated discovery pointers

   The management entry validates/dispatches; the native engine decides; observers report; generated catalogs locate. Observation and discovery cannot grant dispatch or native authority, and management cannot replace native verdicts.

   Platinum CRM, Founder ORVION and their trusted checkouts stay independent at their currently accepted locations. Workbench references them explicitly. They are not subfolders, vendored source or submodules inside control; direct-native operation gains no dependency on this layout.

   Recovery copies belong in the unencrypted compressed package in OneDrive by owner decision of 2026-10-26; follow [RECOVERY.md](RECOVERY.md) for secret-scan review, cloud-copy verification and restore proof. They are not replaced by data/evidence or a Git push. Store recovery proof/pointers under its owning unit; never copy credentials into a local recovery folder. External Windows tools/authentication and installed services are dependencies to diagnose, not directories copied into this repo.

   The owner-authorized source remote is https://github.com/Shehabhub/ORVION-Workbench (public, as recorded in README.md and RECOVERY.md); accepted f42c5a0 main was published and downloaded with matching tree and read-only Boot. WS005 R4 subsequently installed the canonical docs and completed the single-live-location cutover locally; its six commits through 2310836a2b70f6e98b85a30a490efd286a85417f are unpublished. Separate exact publication authorization, bounded subject/history/privacy review and fresh readback remain required. Source publication is distinct from protected recovery of unique external assurance/receipts.

   Track the minimum safe material whose loss would remove knowledge, exact authority, reproducibility or the ability to resume: source/tests/governance, actual contracts, selected plans, safe templates and selected non-secret assurance/decision evidence. A generated dependency lock can be essential; a handwritten scratch note can be disposable. Normally regenerate local maps/search views, caches, scratch, clones and repetitive raw logs. Generated local projection policy does not change native repositories' required tracked maps.

   .git metadata, working receipt archives, machine bindings, raw sessions/events, local catalogs, runtime, prototypes and graveyard are not ordinary source payload. Required unique ignored evidence must have proven protected backup or an explicitly reviewed safe evidence capsule, not be silently dropped. Never put secrets/raw sensitive sessions into Git merely to achieve one physical storage location. Existing exact artifact files stay unchanged; any curated safe export is labelled as such and never substituted for its original approval/receipt. No new duplicate approval registry is introduced.

   This layout does not implement hosted enforcement or authorize unrelated remotes. Verify the actual tracked publication subject and a fresh download; a source clone is not complete workstation recovery.

   ### Existing locations to account for at migration

   | Current location | Target treatment; not a move command |
   |---|---|
   | Documents/GitHub/ORVION-Workbench | actual selected source clone, same accepted history and source origin; keep this Git root |
   | Documents/GitHub/ORVION-Workbench-trusted-main | PROPOSED independent checkout of the same authorized repo for previously trusted evaluation/owner release; no creation/configuration in this correction; Stage 3 implementation and Stage 6 recovery |
   | Documents/GitHub/ORVION-Owner-Tools | preserved old clone; the one sessions/events data root is `ORVION_DATA_ROOT`, else this sibling when it has `events\`, else this checkout; no parallel live journal |
   | Documents/ORVION-Owner-Review | prior external plan/layout copies are preserved history after WS005 selected the source docs; other live packets are mapped explicitly; required sealed old bundles may retain their structure under data/legacy/ORVION-Owner-Review |
   | Documents/ORVION-Sandbox | map live sandbox/runtime/test/checkpoint material by actual role; required historical bundles may use data/legacy/ORVION-Sandbox; do not sweep the directory wholesale |
   | Documents/ORVION-Owner-Tools | identify old external release scripts/evidence versus replaced copies; preserve required history under data/legacy/ORVION-Owner-Tools; no second active lib |
   | Documents/ORVION-drafts-backup | inventory required provenance under data/legacy/ORVION-drafts-backup; never treat these copies as current selected authority |
   | Native original/trusted roots, installed tools, credential stores, encrypted USB | explicit external dependencies; not nested inside control and not absorbed by this diagram |

   The mapping must record what remains, is copied, becomes active, stays historical or is separately proposed for retirement. No source folder is disposable merely because this table names a destination.

   ## 6. Adoption order and architectural checks

   1. Plan stages 1-3: preserve lib names, actual selected root/operation handling, exact assurance pointers and native independence. Keep completed WS005 outputs/history intact; create new proposal outputs only in their exact declared independent external roots. A historical WS005 packet/tree example is not a new contract allocation or authority.
   2. Stage 4: introduce derived control map and local federated catalog through actual consumers. Correct the incomplete Spider coverage without unbounded disk/archive crawling. Prove missing/stale/read failures and actual fresh-agent discovery.
   3. Stage 5: inventory/copy/hash/consumer-cutover/restore proof before consolidating external data. Preserve the actual new source clone. Prove parent-derived defaults, hooks, process working directories, recipe/approval root bindings, active processes, backup and session paths. Do not rewrite frozen historical absolute paths; preserve source-to-new-location mapping.
   4. Moving original roots changes exact authority inputs. Existing frozen root-bound approvals cannot be silently reused. Select a quiescent boundary and approved migration/successor route; do not move during Finish or ongoing archiving without its proven controlled cutover.
   5. Check the deepest actual generated Windows fixture/revision/path probe against the installed toolchain. The existing checker has a concrete 260-character refusal. Prefer short unit/run identifiers and data/tests; do not change registry settings or weaken the guard to fit a diagram.
   6. WS005 has selected the source docs through actual verified cutover. Retain that one live source location, the sole current external programme checkpoint and preserved previous plan/history. Any later storage/checkpoint relocation needs its own proven approved boundary; never repeat WS005 cutover or maintain two manually synchronized live plans.
   7. Plan stage 6 proves clean-machine recovery of the selected real layout using the unencrypted OneDrive package and verification steps in [RECOVERY.md](RECOVERY.md). Stage 7 retains ADR-0033 closure and the owner-held Batch 6 decision.

   Acceptance attacks: outside-root creation; junction/sibling/ancestor escape; duplicate common Git/output roots; unknown/ignored evidence omitted; stale/partial index displayed as complete; changed selected bytes; pointer falsely treated as approval; raw secret in generated tracked view; frozen metadata rewritten during migration; old path consumer still writing elsewhere; missing archive source deleting a retained session from index; interrupted copy/refresh/quarantine; required evidence offered to purge; clean restore unable to run an actual entry.

   This diagram does not require every proposed file/folder now. Create only earned implemented surfaces. No generic framework, new resident watcher, semantic index, scheduler or extra governance engine is authorized by naming folders. This remains the smallest compatible evolution of the current tools.

   ## 7. Source basis and change record

   - 2026-10-24 / v1.5: add the proposed independent ORVION-Workbench-trusted-main external binding and conditional hosted workflow role. Stage 3 owns security acceptance and Stage 6 its recovery; all source/data classifications and tool names retained. No checkout or workflow created and no settings/remote action authorized.

   - 2026-10-24 / v1.4: mark installed docs, WS005 Complete and test-pulse accurately; retain all library names, directory roles/classifications, proposed data/config paths, retention and migration boundaries. No data relocation, new interface or management implementation is implied.

   - Existing control README/AGENTS/RESUME/WORKFLOW, changes/TEMPLATE.md, lib/README.md and Test-WorkbenchChange root/assurance checks; actual library inventory on 2026-10-23.
   - Existing native scripts/generate-ai-map.ps1: deterministic source-derived projections and non-writing freshness check.
   - Existing Events lessons: repository independence, nested sandbox hazards and archive-derived session indexing.
   - [Git repository layout](https://git-scm.com/docs/gitrepository-layout): actual Git metadata/common-directory boundaries; not a mandate for these application folder names.
   - [Microsoft path limits](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation): runtime/API-specific limits, not a universal long-path guarantee.
   - 2026-10-24 / v1.2: retention is based on recovery/authority value rather than whether a file is generated; local derived maps normally stay ignored. Recorded the verified private initial source remote and the still-pending inclusion of important external documents/evidence. No physical cutover or prototype installation claimed.
   - 2026-10-23 / v1.1: owner selected Documents/GitHub/ORVION-Workbench as the exact common parent. Added the existing nested hooks/fixtures library files found during recursive path-consumer inspection. Current operational roots remain unchanged pending proof.
   - 2026-10-23 / v1: owner requested a concrete complete layout, including tools, plan drafts/improvements, assurance snapshots and selection. Added this architectural companion without relocating source/data or changing current exact contracts.

   Canonical routing: WS005 R4 completed the actual post-Complete cutover. This source docs location is selected by the sole programme checkpoint; prior external revisions remain unchanged historical evidence. A later governed revision updates these same files; it does not repeat cutover or create another live plan.
   ```
   with
   ```text
   # ORVION-Workbench - Target Workspace and Repository Layout

   Version 2.0 | 2026-10-27 | Three folders; public source, private data and disposable storage

   ## 1. Three-folder boundary

   The selected source is C:\Users\My Lab\Documents\GitHub\ORVION-Workbench, an independent Git root. The source remote is PUBLIC (measured 2026-10-26); the initial private clone and admission observations of 2026-10-24 are historical. Preserve its history, lib names and local hooks. The [programme plan](EXECUTION-PLAN.md) owns canonical routing, stage order and hosted/trusted acceptance; this layout owns storage roles, not live programme status.

       Documents/GitHub/
       |-- ORVION-Workbench/                 Git source
       |-- ORVION-Owner-Tools/               private data, not a second working lib
       |-- ORVION-Workbench-temporary/       disposable storage
       |-- ORVION-Workbench-trusted-main/    independent trusted evaluation/release
       |-- CRM/                             independent Platinum source
       |-- CRM-trusted-main/                independent Platinum trusted clone
       |-- ORVION/                          independent Founder source
       `-- ORVION-trusted-main/              independent Founder trusted clone

   A role diagram grants no creation, movement, installation, release or cleanup authority. Existing native and trusted roots remain independent siblings: no nested repositories, linked worktrees, common Git directories, alternates or shared object-store shortcuts. Workbench refers to products explicitly; products do not acquire Workbench or peer dependencies. Each keeps its own identity, SPEC numbering, contracts, receipts, CI, credentials and release. Combined coordination belongs here only. Repository plus SPEC/WS identifies a claim; matching numbers do not mean matching contracts.

   The product independence rule also forbids naming the peer, Workbench or cross-repository facts in a product's README, AGENTS, Boot, manifest, GOVERNANCE pin or ADR. A product README that does not lead here is correct. Say where each coordinated change lands; one candidate SHA, Finish and exact-SHA certification belong to each repository separately. ADR-0033's programme sequence belongs to Founder; Platinum names rather than copies it.

   Owner-reviewed Workbench trust/protection observations remain dated evidence until revalidated. An independent trusted checkout uses previously accepted governance for owner-controlled release judgment. Its name/existence, local hook or green workflow proves neither trusted capability nor effective hosted protection. Stage 3 of the plan owns exact candidate/baseline/bootstrap, private entitlement, actor/bypass, separately authorized publication/settings/promotion and separate local/hosted/trusted/remote evidence. Stage 6 owns recovery and fresh enforcement checks. Unknown protection blocks the affected claim; no visibility change, purchase or permission bypass is inferred.

   ## 2. Source and named exceptions

   The source owns README/AGENTS/RESUME/HANDOFF/WORKFLOW, tests.ps1, changes/, docs/, lib/, .gitattributes, .gitignore and the accepted .githooks adapter. Keep tests in lib; tests.ps1 discovers the bound owning recipe there. Keep hooks/Watch-Reminder.ps1 and fixtures/seed-events.ps1 under lib. No parallel gates/profiles/engines folders or replacement library. Hosted workflows and workstation requirements exist only when their owning implementation is earned; a layout creates neither a workflow nor Doctor/Prepare command. config/ holds only the historical [WS-010 scaffold note](../config/README.md): no configuration interface or roots.example schema exists; retire it once contract steps can delete files.

   The only managed generated-data exceptions at the source root are:
   - Native engine-owned .workbench-local-certification.json and .workbench-certifications/ at their actual owning paths; Git metadata remains local too.
   - The owner-requested ai-map.html and ai-map.json, generated by Map-Repos, ignored by Git and refreshable by its installed hourly/logon task.

   These exceptions do not permit source-nested sandboxes, tests, temp, private archives, runtime, machine bindings, catalogs or graveyard. An ignored sandbox once hid broken references because the native consistency tool indexed ignored files. Generated views locate source; they never grant dispatch, approval or certification. Native required tracked maps retain native policy.

   Track the minimum safe knowledge whose loss would remove authority, reproducibility or continuation: reviewed source/tests/governance, contracts, selected plans, templates and essential non-secret assurance/decision evidence. A dependency lock may be essential; a handwritten scratch note may be disposable. Regenerate local maps, search views, caches, scratch, clones and repetitive logs. Gitignore is not protected backup. Unique ignored approval/receipt/history dependencies need proven recovery or a reviewed safe evidence capsule; never publish raw sensitive sessions or secrets to achieve one location. Curated exports retain origin and limitations and cannot replace original authority.

   ## 3. Private data and disposable trees

   [lib/README.md](../lib/README.md) owns actual resolver behavior: ORVION_DATA_ROOT overrides the sibling ORVION-Owner-Tools store; missing default data is unavailable and writers refuse. There is one journal and one retained session archive, never an implicit checkout fallback or blank replacement history.

       ORVION-Owner-Tools/
       |-- STATE.md                         private live-state route
       |-- records/<WS>/
       |   |-- planning/revisions/           substantial editable pre-freeze proposals
       |   |-- assurance/V1,V2,V3/           protected identified snapshots
       |   |-- selected/                    derived pointer, no duplicate Draft
       |   |-- authority/                   actual approval evidence
       |   |-- config/                      explicit selected native configurations
       |   |-- payload-source/              selected output bytes
       |   |-- accepted/                    required evaluator inputs
       |   |-- runtime/<run>/               real operations, logs, exits and captured receipts
       |   |-- evidence/                    substantive research/review
       |   `-- migration/                   origin/path-map and copy verification
       |-- sessions/raw/                    verbatim retained client-relative paths
       |-- sessions/index.jsonl,INDEX.md     derived from retained archive
       |-- events/events.jsonl              one append-only journal
       |-- config/                          private machine bindings when earned
       |-- indexes/                         derived federated pointers/coverage when earned
       |-- legacy/                          protected original relative bundle structure
       `-- graveyard/                       verified quarantine, not ordinary scratch

       ORVION-Workbench-temporary/
       |-- sb/<WS>/                         isolated sandbox clones
       |-- cx/<name>/                       disposable Codex delegate clones
       |-- t/                               short test fixtures
       |-- tmp/                             tool/operation scratch; child TEMP/TMP in tmp/
       `-- tools/actionlint.exe             verified pinned external tool

   These are roles, not newly published JSON/PSD1 schemas. Reuse existing equivalent records; create folders only for an actual unit/run. No fake approval, placeholder receipt, mandatory per-session report or duplicate log. The earlier Workbench-Data consolidation proposal is superseded by these three roles; sealed historical paths remain unchanged. Product/native operation results and certification stay with their owning engines.

   Where earned, payload declarations record literal replay/output identities, evidence pointers declare their classes, and SHA256SUMS seals bounded immutable artifacts excluding itself. Operation records identify the actual outcome, not native certification. Per-target runtime retains finish/resource/watcher logs, actual producer exits and any captured immutable receipt; a watcher exit alone proves no native success. Quarantine metadata retains origin, verified UTC and content/hold/authority evidence. None of these illustrative record names publishes a new accepted schema.

   ### Assurance and evidence ownership

   1. Planning is editable before freeze; retain substantial corrections/rejected reasoning, not every thought. It never amends an approved contract.
   2. V1/V2/V3 have distinct IDs and SHA256 identities, real pass evidence, reviewable sources and selection reasons. V3 is selected by the current template. Required rejected/unselected snapshots remain protected.
   3. A selected pointer names the exact immutable V3 by unit, version, relative path and digest. It is a derived locator, never approval, a second registry or an editable duplicate Draft. Human navigation derives from the same pointer.
   4. Approval identifies actual selected bytes and physical execution root. The selected Draft cannot contain its own hash. Existing guards/contracts retain their exact supported artifact paths until proven change.
   5. Never repair a frozen snapshot/payload/approval after failure. Preserve it and use a lawful corrected successor or new identified bundle. Existing sealed packages remain byte-identical.
   6. changes/ owns the Workbench CR/status/runtime checkpoint, not a product CR. docs/ owns the selected plan/architecture, not live runs. Private records own proposal/assurance, exact approvals/payload/seal and operation evidence; captured receipts remain evidence, never transplanted working receipts.
   7. evidence/ holds substantive knowledge not already owned by a packet/run. indexes/ holds pointers, source states and coverage, not business truth, secrets or approvals. events/ holds lessons/assignment, not a second active-contract register. sessions/ holds retained transcripts/derived indexes, not hidden reasoning.
   8. Runtime logs supporting required receipts stay protected even when old. Captured immutable copies retain origin/digest. Keep tool-result attachments at actual archived relative paths; invent no global sessions/tool-results folder and do not duplicate raw files into evidence for appearance.
   9. legacy/ preserves only inventoried required historical bundles and their structure, not every disposable clone or a second active lib. Map retained bundles once; use tested active cutover routes. Quarantine only independently eligible redundant material after preservation/approval.

   ## 4. Bindings and migration

   Logical roles include ControlRoot, SandboxRoot, TestsRoot, TempRoot, RuntimeRoot, PacketRoot, EvidenceRoot, SessionRoot, EventRoot, IndexRoot and GraveyardRoot. This names roles, not an accepted roots.local.psd1 API. Relative paths stay within roots; explicit absolute bindings connect roots. An exact operation config/contract decides authority; editing a location adapter cannot relocate an approved operation.

   Original Root is the actual source checkout; Sandbox/Tests/Temp/Runtime stay external and distinct/non-overlapping as required by the checker. Versions, headroom, recipe and execution root remain contract-bound. Prefer short WS/run identifiers and probe the deepest real generated fixture/revision path against the installed toolchain; the concrete 260-character refusal is not weakened with registry changes or a diagram.

   Tool consumers/defaults, hooks, process working directories, archiver, backup, approvals and root-bound recipes must all prove any cutover; changing one variable or roots file is insufficient. Preserve engine receipt placement and raw-session relative layout until consumers prove otherwise. Generated catalogs declare included/excluded/unreadable coverage and relevant freshness rather than trusting a timestamp.

   For relocation: inventory actual consumers and active jobs; freeze exact mapping after isolated proof; copy, hash/ref/config verify, prove mapped operation and fresh-destination restore; then cut over under bounded authority, preserving a recoverable old copy. Retirement/deletion is separately authorized. Unknown dependencies or active Finish/archiving stop unsafe movement. No junction aliases to hide unresolved consumers, wholesale legacy sweep or assumed old-root approval reuse. Historical absolute paths remain frozen with source-to-location provenance.

   Managed creation validates per-operation roots; test outside-root/reparse/ancestor/sibling escape, common-Git/output collisions, interrupted copy/refresh/quarantine and concurrent creation. Required evidence cannot become purgeable by age, LastAccessTime, old PID or directory name. [Plan Stage 5](EXECUTION-PLAN.md#7-stage-5---organized-storage-and-safe-sandbox-factory) owns staged retention approvals and waits. No automatic cleanup or claimed saving without measured approved deletion.

   ## 5. Recovery and adoption boundaries

   Follow [RECOVERY.md](RECOVERY.md): the unencrypted OneDrive package (owner decision 2026-10-26), redacted secret-scan review, cloud download identity and restore proof. Recovery is not replaced by Git push or private evidence folders. External installed tools/services and authentication are dependencies to diagnose, not directories copied into source. Native direct entry remains independent; observers report and catalogs locate, while selected native engines judge.

   Adopt earned surfaces through the plan's owning stages: preserve completed readiness/canonical cutover; prove relevant explicit routing, discovery and missing/stale/read failures; prove each storage consumer before relocation; recover the actual layout/trusted boundary; retain ADR-0033 and [HANDOFF section 12](../HANDOFF.md#12-success-criteria-before-the-programme-closes-and-batch-6-resumes) for Batch 6. Future changes update these same living docs through their exact scope rather than repeating cutover.

   Acceptance attacks also include unknown/ignored evidence omitted, partial index presented as complete, changed selected bytes, pointer mistaken for approval, secret in a tracked view, frozen metadata rewrite, old-path writers, missing archive source deleting retained index entries, required evidence offered to purge and a restore unable to run the actual entry. A directory picture proves none of these. No general framework, resident watcher, semantic index, scheduler or extra governance engine is earned merely by naming folders.

   ## 6. Source basis and change record

   - 2026-10-27 / v2.0: reconciled the public source boundary and three-folder roles, named engine/map exceptions, current private-data and temporary roots. Removed the empty config scaffold; no consumer existed. Original naming proposals and dated observations remain in Git.
   - 2026-10-24 / v1.5: proposed independent Workbench trusted-main and conditional hosted workflow; Stage 3 acceptance/Stage 6 recovery, no checkout/settings authorization.
   - v1.4-v1: preserved selected source admission/readiness, knowledge-value retention, original folder/tool names and consumer-by-consumer migration. Git retains full accepted revisions.
   - [Git repository layout](https://git-scm.com/docs/gitrepository-layout) informs independent metadata/common directories; [Microsoft path limits](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation) informs installed-toolchain probing, not universal long-path assurance.
   ```

   The resulting file's Git blob is d77fe0c40c9a7b04a961d3162ae38976c55e3da9.

7. Check whether `HANDOFF.md` contains `# ORVION programme closure and evidence boundaries`; if so record Already Applied when its Git blob is 786c8c6ac5e21fbda63dc0df45fbca7fa5faa6c9, and otherwise stop and report. Otherwise make exactly these 7 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
   # ORVION programme handoff — for a new agent with no history (Claude Code or Codex)
   ```
   with
   ```text
   # ORVION programme closure and evidence boundaries
   ```

   b) replace the lines
   ```text
   Written 2026-10-20 by the closing session (Claude Code, session `84ee17dc`). Read top to bottom once; it takes ~10 min.
   Live state always wins over this file: run `lib\Pulse.ps1` and each repository's Boot (§3). Section 4 is a dated
   snapshot and names the record that is authoritative for each fact.
   ```
   with
   ```text
   Updated 2026-10-27. Live operation state is external; [RESUME.md](RESUME.md) routes there. Each product's README/AGENTS/Boot owns its execution. This document retains the Batch 6 gate, not a copied roadmap, owner queue or startup procedure. The [programme plan](docs/EXECUTION-PLAN.md) owns sequencing; [WORKFLOW.md](WORKFLOW.md) governs Workbench changes.
   ```

   c) replace the lines
   ```text
   ## 1. Architecture and purpose
   - **ORVION** is a travel CRM / operations / revenue platform for Egyptian travel agencies (flights, Umrah, Hajj, visa,
     hotels, tours): Supabase/PostgreSQL, SQL migrations + `app`-schema RPCs. The commercial roadmap is each repository's
     Phase 8 / **Batch 6**, ON HOLD by owner decision (2026-10-18) until the infrastructure programme closes.
   - The **infrastructure programme** (now) makes the repositories self-governing and safe for any agent: a Gate that
     judges every Change Request (CR) transition, exact-SHA certification, trusted publication/promotion, recovery.
   - **ORVION-Workbench** (this folder, source remote `Shehabhub/ORVION-Workbench`, `workbench-preflight` then `main`) is the owner's external execution and coordination layer:
     agent tools and combined (two-repository) work; the session archive and event journal use one data root: `ORVION_DATA_ROOT`, else sibling `ORVION-Owner-Tools` when it has `events\`, else this checkout. It is never repository
     authority and never a dependency of either repository.

   ## 2. Repository identities and boundaries (owner rule, 2026-10-20: strict independence)
   | | Platinum | Founder |
   |---|---|---|
   | Checkout | `C:\Users\My Lab\Documents\GitHub\CRM` | `C:\Users\My Lab\Documents\GitHub\ORVION` |
   | GitHub / account | `PlatPlusHub/CRM` / PlatPlusHub | `Shehabhub/ORVION` / Shehabhub |
   | Hosted Supabase | Primary `vrvtsxexkiiiivlkdxzp` | `brplkqmbzffpxqgkkdzo` |
   | Trusted clone (owner promotes from it) | `...\GitHub\CRM-trusted-main` | `...\GitHub\ORVION-trusted-main` |
   - Neither repository may name the other, this workspace, or cross-repository facts: no README, AGENTS.md, Boot,
     manifest, GOVERNANCE pin or ADR text. Each keeps its own SPEC numbering (the same number names different contracts),
     receipts, CI, credentials and release. Combined operations live only here. "One coordinated programme when
     requested. Two fully independent repositories by design." A repository README that does not lead here is correct.
   - Every repository works alone; workspace tools are optional helpers. Say where each change lands.

   ## 3. Entry points (verified 2026-10-20)
   1. Combined work: `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\README.md` -> `RESUME.md` -> this file.
   2. Platinum only: `C:\Users\My Lab\Documents\GitHub\CRM\README.md`, then `AGENTS.md`, then
      `pwsh -NoProfile -File scripts/check_agent_continuity.ps1 -Boot` at that root.
   3. Founder only: the same three in `C:\Users\My Lab\Documents\GitHub\ORVION`.
   Active task record (live checkpoint, ordered steps): `C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\20261020-wave1-v3\RESUME.md`.

   ## 4. Current authoritative state (snapshot 2026-10-20 ~17:55 local; verify before acting)
   Authoritative live sources: each repository's Boot and `git`; `lib\Pulse.ps1`; the task record
   `Documents\ORVION-Sandbox\evidence\20261020-wave1-v3\RESUME.md` (last checkpoint); the Gate 1 packet's `SHA256SUMS.txt`.
   - **Repositories (verified)**: Platinum `CRM` main = origin/main = `94e7a39e6da7ac553842d2d2954cae38a574d45b` (SPEC-290),
     clean; Founder `ORVION` main = origin/main = `434180cc273e6a73423a48a3a00b77a9fdc379aa` (SPEC-292), clean; both
     trusted clones at the same SHAs, clean. Receipts: `.orvion-local-certification.json` (cr SPEC-290 / SPEC-292) and
     `.orvion-certifications\` in each checkout. Leftover released branches (harmless, do not delete without the owner):
     Platinum `orvion/spec-284-pending`, `-285-`, `-290-`; Founder `orvion/spec-292-pending`.
   - **Contract A — FROZEN, AT GATE 1, NOT APPROVED, NOT IN EITHER REPOSITORY.** Packet
     `C:\Users\My Lab\Documents\ORVION-Owner-Review\SPEC-291-293-wave1\` (start at `GATE-1.md`; 49 files, `SHA256SUMS.txt`):
     | Repository | Contract | Draft SHA-256 | Git blob |
     |---|---|---|---|
     | Platinum | SPEC-291 | `5C94E1324730FB4A99AC8D86FA1A2C36D7335338FA98E0B455E2D8B435DF6FBE` | `3a007e12f8a4cf395845cb044e17a5681de677f8` |
     | Founder | SPEC-293 | `54BF9EE345D3CF88809ABAB1E4A3107BD5C2CCE7C18BD378828F5C21208F8C3C` | `40fb06902aa55c3c7945450067deed82f7c0ff62` |
     Same 6 files per repository (`scripts/check_agent_continuity.ps1`, `test_agent_continuity.ps1`, `github_public_read.ps1`,
     `test_github_public_read.ps1`, `watch_ci.ps1`, `CR_LIFECYCLE.md`); no cross-repository text (checked by the generator
     and two independent reviews). Evidence on the exact final bytes (all in the packet): control suite 595/595 both;
     reader 86/86 both; receipts 71/71; watcher self-test 62/62; consistency CLEAN; STORE negatives (unguarded fails
     OS1-3, OSM1-2); Certify negatives (unpatched fails 108c, INH-1u); watcher-wait negatives (pt 1.0 s, fd 1.5 s);
     byte check 12/12; lifecycle rehearsal PASSED both (`evidence\rehearsal\`); dress rehearsal of the batch with the real
     executor and the packet's configs PASSED (`ORVION-Sandbox\evidence\20261020-wave1-v3\dress-final\`); independent
     reviews CONFIRMED (`evidence\independent-review-REPORT.md`, `evidence\independent-final-review-REPORT.md`).
     Known limitation approved with it (Notes): a pause loop with no total bound (never a wrong verdict) -> contract B.
   - **Never use**: the 2026-10-19 packet `Owner-Review\wave1-2026-10-19` (SUPERSEDED, never approved), any Draft under
     `wave1-v3\drafts\superseded-*`, `drafts-dry\`, `drafts-a\` (dry), `review-a*\` copies; generators `make-drafts.ps1`,
     `make-drafts.merged.ps1`, `apply-routing.ps1`, `apply-adr.ps1` (pre-independence).
   - **Sandboxes** (disposable, push DISABLED): `ORVION-Sandbox\evidence\20261019-objstore\pt` and `\fd` hold the tested
     edits uncommitted; `rebuild-a.ps1` rebuilds them. Nothing is running. Open owner items: Gate 1 for contract A,
     BitLocker, workspace remote, Shared Evidence earn-or-waive, MCP prune / GitHub MCP, CTRL-19.

   ## 5. Completed work (precise states)
   RELEASED = implemented, locally certified (Finish), published, promoted to `main`, `REMOTE_CERTIFY: READY`:
   - History restoration; Founder operational independence (Founder SPEC-289 `794a6db`); basic Platinum-to-Founder sync
     (Platinum SPEC-286 `4a22aa5`; defects Platinum SPEC-287 / Founder SPEC-290); CR B GitHub Actions hardening
     (Platinum SPEC-289 `b091f0f`, Founder SPEC-291 `b1d996f`); CR C Three-Pass Draft Assurance + run cost reporting
     (Platinum SPEC-290 `94e7a39`, Founder SPEC-292 `434180c`, released 2026-10-20 with the owner's one-time approval).
   PREPARED, NOT APPROVED: contract A (§4). Workspace tools: implemented and tested here (`tests.ps1`), not in any repository.

   ## 6. Remaining roadmap (ADR-0033 Programme sequence, Founder `reports/architecture-decision-records.md`; consolidated by the owner)
   1. **Contract A** — "a read that cannot finish is never a verdict" (object-store/shallow guard + shared GitHub read
      budget, `REMOTE_CERTIFY: UNREADABLE`). Platinum SPEC-291 / Founder SPEC-293. **At Gate 1** (§4, §7).
   2. **Contract B** — release interface (4 Publish/Promote launchers + 2 external dual coordinators), the agent tools
      tracked INSIDE each repository and named by its own Boot/AGENTS.md (no pointer here or to the other repository),
      `watch_run` fixes (late attach floods; ETA from test counts; `UNREADABLE` in its verdict words), the fail-closed
      reads remainder (`Git-State` treats a failed `rev-list --count` as 0; `Base-HasId` failures read as "free"), and
      contract A's recorded follow-ups (its Notes): a total deadline for `Wait-OrvionPublicSlot` pauses, a permanent
      `origin` misconfiguration reading `UNREADABLE`. Not drafted.
   3. **Shared Evidence + Independent Native Finish optimization** — not earned; waived by the owner as a closure
      prerequisite on 2026-10-26 (a future CR may still earn it).
   4. **Contract C** — split on 2026-10-26 (§12): C1 written closure criteria + selective package + same-machine
      isolated restore (WS-015); C2 clean-Windows recovery, performed by the owner's planned reinstallation
      (`docs/RECOVERY.md`).
   5. Infrastructure closure (§12), then unchanged Phase 8 / Batch 6 and the commercial programme, each under its own CR.

   ## 7. Immediate next actions (in order)
   1. Orient (read-only): `pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\lib\Pulse.ps1"`;
      Boot in each repository; confirm §4's SHAs and that `Get-FileHash` of both packet Drafts equals the table.
   2. **Wait for the owner's Gate 1.** Do not approve for them. The message they send is in `GATE-1.md` ("To approve").
      If they ask questions, answer from the packet; do not re-run suites, rehearsals or reviews (all on these exact bytes).
   3. After an approval that names BOTH exact digests: follow `PKT\exec\RUNBOOK.md` steps 2-13 exactly
      (`preflight-a.ps1 -Before approve` -> `LIB\Invoke-ContractStage.ps1 -Config PKT\exec\<pt|fd>.psd1 -Stage approve`,
      `implement` -> Finish through `run_timed.ps1` + `watch_run.ps1` (memory: two together need >= 5.2 GB) -> Review ->
      Complete -> Bind -> `make-owner-scripts-a.ps1` -> owner publishes -> one CI watcher at a time -> owner promotes ->
      `-Certify` -> closure). An approval naming only one digest: run that repository alone (the configs are separate).
   4. Never: regenerate or edit a frozen Draft (it changes the digest); approve, publish or promote without the owner;
      commit a Draft before approval; restart a killed heavy run without the owner's OK; run two CI watchers at once
      before contract A is on `main`; touch Batch 6.
   5. After contract A is RELEASED: draft contract B (§6) from a sandbox prototype, same method (§8), its own Gate 1.

   ## 8. Governance (each repository's `ENGINEERING_METHOD.md`, `CR_LIFECYCLE.md`, `AGENTS.md`, `GOVERNANCE.md`)
   - **CR lifecycle**: Draft -> (Gate 1: the owner approves the exact SHA-256 of the frozen Draft) -> allocate + Approve
     commits -> implement the Draft's literal steps -> **Finish** (`-Finish`, only through `scripts/run_timed.ps1`, watched by
     `scripts/watch_run.ps1`; writes the local receipt `LOCAL_CERTIFY: READY`) -> independent **Review** (live Git, not the
     log) -> Complete -> `-Gate -BindCandidate` (bound record) -> owner **publish** to `orvion-preflight` -> exact-SHA CI ->
     owner **promote** from the trusted clone (`promote_main.ps1`, `-Gate -Trusted` judges with an evaluator outside the
     candidate) -> `-Certify` (`REMOTE_CERTIFY: READY`). Publish/promote are the owner's (`CR_LIFECYCLE.md` §9).
   - **CAG** (admission): one definition of transitions, judged by the hook at HEAD and by CI at every commit of a range.
     **ACI**: changing a GOVERNANCE §6 pin is an authority change with a Gate-found consumer closure.
     **SACI** (stale authority): a pinned line keeps its ratified text in every state. **PICF** (completion feasibility):
     `check:` clauses on Acceptance Criteria are judged feasible at Approval and must hold at Complete (locally and in CI).
   - **Three-Pass Draft Assurance**: every Draft records `Pass 1 Design`, `Pass 2 Adversarial Review`, `Pass 3 Evidence
     Refresh` (dated) and `Selected Version`; the Gate refuses a missing/duplicate/undated record.
   - Drafts are committed only at approval; never write an unallocated SPEC id in a tracked file (it reserves the number);
     a blocked checkpoint is never committed; reading is unrestricted, writing needs an active approved CR's Write Scope.
   - Before freezing: sandbox + prototype in a disposable clone, then a full lifecycle rehearsal
     (`lib\Invoke-DraftRehearsal.ps1`), byte check (tested blob == step blob), independent review (`lib\Delegate.ps1`).

   ## 9. Execution lessons (each cost a run; the full journal: `lib\Events.ps1 -Find '<task>'`)
   - **Learn before guessing**: a first diagnosis is a hypothesis until measured (2026-10-20: "gc.auto" was wrong; Git 2.54
     automatic *maintenance* packed fixture objects; fixed with `gc.auto 0` + `maintenance.auto false`).
   - PowerShell double-quoted text turns `` `r `` / `` `t `` into control bytes and drops other backticks: write Markdown
     code as ` ``x`` ` there; the Gate refuses U+000D (`PROHIBITED_CHARACTER`). The Draft generator now refuses control bytes.
   - Generated Draft steps must match how `apply-draft-steps.ps1` applies them (substring matching; deletions with
     context; a final newline) — `lib\test-draft-steps.ps1` covers it. Always rehearse before freezing.
   - A failed native command reads as empty (`if(git status)` on error = "clean"): use throwing wrappers.
   - `pwsh -WorkingDirectory X -File rel.ps1` runs the caller's script: absolute `-File` paths. .NET file APIs ignore the
     PowerShell location. `git config` in a worktree edits the main repo. Helper names must not shadow commands/aliases.
   - **Resources**: a control suite ~42 min; a Finish 45-70 min (two in parallel need >= 5.2 GB free; at 3 GB it pages).
     Claude Code's low-memory reaper killed two suites at 7 min once: restart only with the owner's OK. Avoid starting a
     Finish 12:15-12:30 local (a future-date test straddles 10:00 UTC).
   - **GitHub API quota**: anonymous 60 requests/hour per IP, shared by every watcher; a 304 still costs 1;
     `/rate_limit` is free. Two 30 s watchers exhausted it in 15 min and `-Certify` printed FAILED while CI was green.
     Until contract A is on `main`: ONE watcher at a time, `-PollSeconds 120`. Exit 2 = unreadable, never "failed".
   - Background agents stall on unseen permission prompts: read-only delegates use Read/Grep/Glob only; watch every
     background agent and every timed run under Monitor (`Watch-Subagents`, `watch_run`, `Watch-Host`).
   - Never run unguarded old code as a causal negative without reading its top level (it once ran real winget/npm).

   ## 10. Coordinator and continuity (all in `lib\`, index `lib\README.md`)
   - **Pulse** (`Pulse.ps1`): the live state an arriving agent sees first (repos, pending candidates, running runs, host,
     owner waits, last session, coordinator queue, in-flight work and its RESUME). Printed at Claude session start.
   - **Lion King** = `Coordinator.ps1`: reads the one journal, holds every open item to an owner, next action and due time
     (TRIAGE/OVERDUE/OWNER/DISPATCHED/READY); closes nothing without a recorded reason.
   - **Spider** = `Spider.ps1 '<phrase>'`: one question across sessions, events, both repositories, memory and packets.
   - **Dogs** = `Hunt.ps1`: invariants, liveness, untested tools, planted-bug mutants; every BUG/GAP becomes an event.
   - **Birds** = the watchers: `watch_run` (in each repository; one timed run), `Watch-Host` (memory), `Watch-Subagents`
     (background agents STALLED/FINISHED).
   - **Journal**: `events\events.jsonl` under the one data root above via `Events.ps1 -Add/-Find/-Brief`; **delegation**: `Delegate.ps1` (brief ->
     report -> verdict event). **Sessions**: `sessions\raw\` verbatim (Claude + Codex; sensitive: token shapes
     noted in `docs/RECOVERY.md`), `sessions\INDEX.md` under that same data root, kept by `Sync-Sessions.ps1`, started by Claude Code running this checkout's `lib\hooks\Watch-Reminder.ps1`. **Backup**: `Backup-Workspace.ps1 -Package`
     (one selective archive in OneDrive, unencrypted by owner decision; reinstall and restore steps: `docs\RECOVERY.md`).
     Recover the latest verified state: Pulse -> its `in flight` line -> that task's RESUME.md.
   - Codex does not read Claude hooks or memory: it starts from §3 and this file. Claude memory
     (`C:\Users\My Lab\.claude\projects\C--Users-My-Lab-Documents-GitHub-CRM\memory\MEMORY.md`) is a convenience copy.

   ## 11. Owner decisions
   - **Approved and used**: everything in §5; the one-time publish/promote approval for SPEC-290/292 ("only this time").
   - **Requires the owner**: Gate 1 for each frozen Draft (exact SHA-256; both digests may come in one message); publish;
     promote; any GitHub setting; any credential; deleting anything outside disposable preparation; restarting a heavy
     run the host killed; what to do with secret-scan findings in the recovery package (`docs\RECOVERY.md`); the open
     decisions: BitLocker on C:,
     MCP prune / GitHub MCP. Decided 2026-10-26: Shared Evidence waived as a closure prerequisite; CTRL-19 dispositioned
     OPEN with its residual risk accepted (below).
   - **ON HOLD**: Batch 6 (both repositories) and the Phase 8 remainder, until the §12 lift record. **OPEN**: CTRL-19 (both
     `gh` tokens are reachable by this OS user; `main` protection depends on GitHub configuration the repositories cannot
     set); residual risk accepted by the owner, not closed.
   - **Forbidden without authorization**: production/hosted writes, credential exposure, history rewriting, publishing,
     promoting, modifying protected repository files outside an approved contract, cross-repository references.
   - Owner working rules: verify every request is sound and worth it, state the verdict in one line; learn before
     guessing; earn it, worth it, simplify without weakening; record every confirmed own mistake as an event.

   ## Startup message (owner: paste into a fresh Claude Code or Codex session)
   ```
   with
   ```text
   ## Lift record (owner: one dated line in the delegation decisions record, typed once criteria 1-5 below are evidenced)
   ```

   d) replace the lines
   ```text
   You are continuing the ORVION infrastructure programme with no prior history. Work only from files and live commands.
   Read in order: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\README.md, then RESUME.md, then HANDOFF.md in that
   folder. Run: pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\lib\Pulse.ps1"
   Then report to me: the verified current state, the next owner decision required, and the first safe action.
   Until I authorize it: do not approve, implement, run Finish, publish or promote; do not edit either repository or any
   frozen Draft; keep Platinum (CRM) and Founder (ORVION) independent. Before any task I give, check it is sound and
   worth doing and state that verdict in one line.
   ```
   with
   ```text
   LIFT <yyyy-mm-dd>: Batch 6 hold lifted by the owner; HANDOFF.md section 12 criteria 1-5 evidenced in records\delegation-20261026\LIFT-EVIDENCE.md.
   ```

   e) replace the lines
   ```text
   Amended 2026-10-26 under the owner's exceptional delegation (its text and SHA-256 are recorded in WS-015). These are the
   written closure criteria (contract C1); each needs recorded evidence, none is inferred:
   ```
   with
   ```text

   Amended 2026-10-26 under the owner's exceptional delegation (its text and SHA-256 are recorded in WS-015). These are the written closure criteria (contract C1); each needs recorded evidence, none is inferred:

   ```

   f) replace the lines
   ```text
   2. C1: WS-015 released (`Backup-Workspace -Package`/`Restore-Workspace -Package`), one real package made and its
      OneDrive copy verified by a cloud re-download, and its same-machine isolated restore into new empty roots verified (SHA256SUMS, exact refs/HEAD, and each restored
      repository's Boot printing its expected READY result). C1 is not a clean-machine proof. The package is NOT
      encrypted: the owner decided on 2026-10-26 that an unencrypted compressed archive in OneDrive replaces the earlier
      "encrypted backup" condition; secrets are reported by name (rule, file, line) by the package's scan, never claimed absent.
   3. Founder ADR-0033 amended through a native Founder CR and released, so Founder's Boot routes to Batch 6 like Platinum's;
      a cold-start agent in each repository reaches that next action from its README/Boot alone.
   4. Shared Evidence: waived as a closure prerequisite (not earned). CTRL-19: OPEN, residual risk accepted by the owner.
      Workbench Stages 2-7 / P3 management are not Batch 6 prerequisites.
   5. C2, amended by the owner 2026-10-27 (no Windows reinstallation): C1 on package
      orvion-backup-20261026T201821Z.7z (SHA256 BC28B482F6E101D40D3DD2E9DA5690C122589350804F64FE59BC612D8E9F0203; cloud
      re-download matched; isolated restore; CRM, ORVION and Workbench Boots READY), plus one isolated run of the released
      `lib/Restore-ORVION.cmd` launcher against a fresh package. Clean-machine tool installation stays UNPROVEN: residual risk accepted by the owner.
   ```
   with
   ```text
   2. C1: WS-015 released (`Backup-Workspace -Package`/`Restore-Workspace -Package`), one real package made and its OneDrive copy verified by a cloud re-download, and its same-machine isolated restore into new empty roots verified (SHA256SUMS, exact refs/HEAD, and each restored repository's Boot printing its expected READY result). C1 is not a clean-machine proof. The package is NOT encrypted: the owner decided on 2026-10-26 that an unencrypted compressed archive in OneDrive replaces the earlier "encrypted backup" condition; secrets are reported by name (rule, file, line) by the package's scan, never claimed absent.
   3. Founder ADR-0033 amended through a native Founder CR and released, so Founder's Boot routes to Batch 6 like Platinum's; a cold-start agent in each repository reaches that next action from its README/Boot alone.
   4. Shared Evidence: waived as a closure prerequisite (not earned). CTRL-19: OPEN, residual risk accepted by the owner. Workbench Stages 2-7 / P3 management are not Batch 6 prerequisites.
   5. C2, amended by the owner 2026-10-27 (no Windows reinstallation): C1 on package orvion-backup-20261026T201821Z.7z (SHA256 BC28B482F6E101D40D3DD2E9DA5690C122589350804F64FE59BC612D8E9F0203; cloud re-download matched; isolated restore; CRM, ORVION and Workbench Boots READY), plus one isolated run of the released `lib/Restore-ORVION.cmd` launcher against a fresh package. Clean-machine tool installation stays UNPROVEN: residual risk accepted by the owner.

   ```

   g) immediately after the line
   ```text
   The hold is lifted by one recorded lift decision that cites the evidence of 1-5; each product's Boot then owns Batch 6.
   ```
   insert
   ```text

   ## Evidence boundaries

   Snapshots, transcripts and historical contracts describe their exact subjects, not today's authority. A passing sandbox receipt cannot certify an original checkout; local completion, hosted success, independent trust, publication/promotion and remote certification remain separate facts. Historical receipts retain their physical roots and are never transplanted as working certification.

   Nothing is Gate 1 until the owner approves the exact frozen Draft SHA-256; honest recorded delegation is labelled delegated. Publication, promotion, GitHub settings, credentials, production writes, destructive retirement and restarting a host-killed heavy run require their owning authorization. An earlier one-time release approval is not reusable. Neither this file nor workstation restoration lifts Batch 6 automatically. See [recovery limits](docs/RECOVERY.md#not-yet-proven).
   ```

   The resulting file's Git blob is 786c8c6ac5e21fbda63dc0df45fbca7fa5faa6c9.

8. Check whether `lib/Backup-Workspace.ps1` contains `#   claude\               user settings only; memory lives in owner-tools\records\claude-memory`; if so record Already Applied when its Git blob is 02400ebb0d2a78f81472bac65104ee32c891a552, and otherwise stop and report. Otherwise make exactly these 7 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   #   claude\               user settings + ORVION project memory (never ~/.claude.json or credentials: re-login after restore)
   #   legacy\               Documents\ORVION-Owner-Review, -Owner-Tools, -Owner-Recovery, -Sandbox, -drafts-backup, Windows-Memory-Config
   #                         (node_modules skipped; a nested clone keeps only what no main bundle holds: its ignored files in
   #                         place, .clone-state\ unique.bundle (HEAD and every other tip absent from the main bundles),
   #                         staged.diff, worktree.diff, untracked\, state.json)
   ```
   with
   ```text
   #   claude\               user settings only; memory lives in owner-tools\records\claude-memory
   ```

   b) replace the line
   ```text
   $ownerTools=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]})
   ```
   with
   ```text
   $ownerTools=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'})
   if(!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $ownerTools 'events') -PathType Container)){throw 'ORVION_DATA_ROOT_UNAVAILABLE'}
   ```

   c) immediately after the line
   ```text
   $ownerTools=[IO.Path]::GetFullPath($ownerTools).TrimEnd('\')
   ```
   insert
   ```text
   if(Get-Item -LiteralPath (Join-Path $ownerTools '.git') -Force -ErrorAction SilentlyContinue){throw 'BACKUP_DATA_ROOT_GIT_REFUSED'}
   . (Join-Path $PSScriptRoot 'workspace-layout.ps1')
   $temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout $tools
   ```

   d) immediately after the lines
   ```text
           else{Write-Warning "BACKUP_CONFIG_OMITTED: $key"}
       }
   }

   ```
   insert
   ```text
   function Protect-CodexConfig([string]$Text){
       $quoted='""".*?"""|\x27{3}.*?\x27{3}|"(?:\\.|[^"\\])*"|''[^'']*'''
       # Consume composite values together: masking a secret array/table must not leave tail bytes.
       $composite='[\[{](?:(?:'+$quoted+')|#[^\r\n]*|(?<depth>[\[{])|(?<-depth>[\]}])|[^\[\]{}"''#])*(?(depth)(?!))[\]}]'
       $pattern='(?ms)(?<prefix>(?:^|[,\[{]\s*)[ \t]*(?<key>"[^"\r\n]+"|''[^''\r\n]+''|[A-Za-z0-9_.-]+)[ \t]*=[ \t]*)(?<value>'+$quoted+'|'+$composite+'|[^\[\]{},\r\n#]+)'
       $masked=[regex]::Replace($Text,$pattern,{
           param($match)
           $key=$match.Groups['key'].Value.Trim('"',"'")
           $value=$match.Groups['value'].Value
           # Whole credential words only (separator- or camelCase-bounded): "path", "patch", "keyboard" are not secrets.
           if(($key-match'(?i)(?:^|[_.\-])(?:api_?keys?|keys?|tokens?|secrets?|passwords?|passwd|pats?)(?:$|[_.\-])'-or$key-cmatch'[a-z0-9](?:Keys?|Tokens?|Secrets?|Passwords?|Pats?)$')-and$key-notmatch'(?i)_(?:env|env_var)$'){
               # Explicit environment substitutions are references, not inline credentials.
               if($value-notmatch'^(["''])?\$(?:\{[A-Za-z_][A-Za-z0-9_]*\}|[A-Za-z_][A-Za-z0-9_]*|env:[A-Za-z_][A-Za-z0-9_]*)(?:["''])?$'){$value='"***"'}
           }
           elseif($value.TrimStart()-match'^[\[{]'){$value=Protect-CodexConfig $value}
           $match.Groups['prefix'].Value+$value
       })
       [regex]::Replace($masked,'://([^:/@\s]+):([^@\s]*)@',{
           param($match)
           if($match.Groups[2].Value-match'^\$(?:\{[A-Za-z_][A-Za-z0-9_]*\}|[A-Za-z_][A-Za-z0-9_]*|env:[A-Za-z_][A-Za-z0-9_]*)$'){return $match.Value}
           '://'+$match.Groups[1].Value+':***@'
       })
   }

   ```

   e) immediately after the line
   ```text
       $src=(Get-Item -LiteralPath $From).FullName
   ```
   insert
   ```text
       # Empty memory directories still identify projects that need junctions after recovery.
       if((Get-Item -LiteralPath $src).PSIsContainer){
           [void][IO.Directory]::CreateDirectory($To)
           foreach($directory in Get-ChildItem -LiteralPath $src -Recurse -Directory -Force){
               $relative=$directory.FullName.Substring($src.Length+1)
               if(!(& $Skip ($relative+'\'))){[void][IO.Directory]::CreateDirectory((Join-Path $To $relative))}
           }
       }
   ```

   f) replace the line
   ```text
       $masked=[IO.File]::ReadAllText($codexConfig)-replace'://([^:/@\s]+):([^@\s]*)@','://${1}:***@'
   ```
   with
   ```text
       $masked=Protect-CodexConfig ([IO.File]::ReadAllText($codexConfig))
   ```

   g) replace the lines
   ```text
   }
   $projects=Join-Path $env:USERPROFILE '.claude\projects'
   # Claude is optional; errors reading a present source still terminate the backup before its manifest.
   if(Test-Path -LiteralPath $projects){
   if(!(Test-Path -LiteralPath $projects -PathType Container)){throw 'BACKUP_CLAUDE_PROJECTS_NOT_DIRECTORY'}
   foreach($p in Get-ChildItem -LiteralPath $projects -Directory|Where-Object{Test-Path (Join-Path $_.FullName 'memory')}){
       if($p.Name-match'Documents-GitHub|ORVION'){Copy-Tree (Join-Path $p.FullName 'memory') (Join-Path $out "claude\projects\$($p.Name)\memory")}
   }
   }
   # Selective package v1: a nested clone is regenerated from its recorded origin/HEAD; only state no main bundle holds is kept.
   function Save-CloneState([string]$Clone,[string]$To){
       $localConfig=@(Get-SafeConfig $Clone)
       # .clone-state is reserved for generated metadata; a source path of that name would be overwritten, so refuse.
       if(Test-Path -LiteralPath (Join-Path $Clone '.clone-state')){throw "BACKUP_CLONE_STATE_NAME_COLLISION: $Clone"}
       # Unresolved merge entries cannot be rebuilt by git apply from the saved diffs: refuse rather than save a broken patch.
       if(@(Invoke-Git $Clone diff --name-only --diff-filter=U).Count){throw "BACKUP_NESTED_UNMERGED_NOT_PRESERVABLE: $Clone (resolve or abort the merge first)"}
       $state=Join-Path $To '.clone-state';New-Item -ItemType Directory $state -Force|Out-Null
       # Ignored files (receipts, approvals, evidence) are copied in place; only node_modules is regenerable.
       $ignored=@("$(& git -C $Clone ls-files --others --ignored --exclude-standard -z 2>$null)"-split"`0");if($LASTEXITCODE){throw "GIT_FAILED $Clone ls-files"}
       foreach($f in @($ignored|Where-Object{$_-and$_-notmatch'(^|/)node_modules/'})){Copy-Tree (Join-Path $Clone $f) (Split-Path (Join-Path $To $f) -Parent)}
       $refs=@(Invoke-Git $Clone for-each-ref --format='%(objectname) %(refname)')
       # A bundle carries refs/stash, not older stash entries kept only in its reflog: refuse rather than lose them.
       if(@(Invoke-Git $Clone stash list).Count-gt1){throw "BACKUP_NESTED_STASHES_NOT_PRESERVABLE: $Clone (apply or drop the older stashes first)"}
       $head="$(& git -C $Clone rev-parse -q --verify HEAD)".Trim()
       # Regenerable = reachable from what the main bundles actually hold; every other tip, HEAD included, is bundled above it.
       if($null-eq$script:mainCommits){$script:mainCommits=[Collections.Generic.HashSet[string]]::new();foreach($m in $bundledTips.Keys){foreach($s in @(Invoke-Git $m rev-list @($bundledTips[$m]))){[void]$script:mainCommits.Add($s)}}}
       $known=@(@($refs|ForEach-Object{($_-split' ')[0]})+@($head)|Where-Object{$_-and$script:mainCommits.Contains($_)}|Sort-Object -Unique)
       $unique=@($refs|Where-Object{!$script:mainCommits.Contains(($_-split' ')[0])}|ForEach-Object{($_-split' ',2)[1]})
       if($head-and!$script:mainCommits.Contains($head)){$unique+='HEAD'}
       # Git cannot write beyond MAX_PATH here: it writes a short path under $out and .NET moves the file into place.
       $short=Join-Path $out ('.t'+[guid]::NewGuid().ToString('N').Substring(0,8))
       if($unique.Count){Invoke-Git $Clone bundle create $short @unique @($known|ForEach-Object{"^$_"})|Out-Null;[IO.File]::Move($short,(Join-Path $state 'unique.bundle'))}
       # One worktree walk: index and worktree changes are saved apart (staged.diff, worktree.diff); renames carry a second path.
       $status=@("$(& git -C $Clone status --porcelain=v1 -z --untracked-files=all 2>$null)"-split"`0");if($LASTEXITCODE){throw "GIT_FAILED $Clone status"}
       $staged=$false;$unstaged=$false;$untracked=@()
       for($i=0;$i-lt$status.Count;$i++){$e=$status[$i];if($e.Length-lt4){continue};if($e.StartsWith('?? ')){$untracked+=$e.Substring(3)}else{if($e[0]-ne' '){$staged=$true};if($e[1]-ne' '){$unstaged=$true};if($e[0]-in'R','C'){$i++}}}
       if($staged){& git -C $Clone diff --cached --binary "--output=$short";if($LASTEXITCODE){throw "GIT_FAILED $Clone diff --cached"};[IO.File]::Move($short,(Join-Path $state 'staged.diff'))}
       if($unstaged){& git -C $Clone diff --binary "--output=$short";if($LASTEXITCODE){throw "GIT_FAILED $Clone diff"};[IO.File]::Move($short,(Join-Path $state 'worktree.diff'))}
       foreach($f in @($untracked|Where-Object{$_-notmatch'(^|/)node_modules/'})){Copy-Tree (Join-Path $Clone $f) (Split-Path (Join-Path "$state\untracked" $f) -Parent)}
       [ordered]@{head=$head;branch="$(& git -C $Clone symbolic-ref -q --short HEAD)".Trim();origin=(($localConfig|Where-Object{$_-like'remote.origin.url=*'})-replace'^remote.origin.url=','');refs=$refs;unique=$unique}|ConvertTo-Json -Depth 3|Set-Content (Join-Path $state 'state.json')
   }
   if(!$SkipLegacy){foreach($n in 'ORVION-Owner-Review','ORVION-Owner-Tools','ORVION-Owner-Recovery','ORVION-Sandbox','ORVION-drafts-backup','Windows-Memory-Config'){
       $src=Join-Path $docs $n;if(!(Test-Path $src)){continue}
       # a legacy folder that is itself a repository keeps its files, not its .git; node_modules is reinstalled from its lockfile
       # Only a .git that Git accepts as its work tree's top is a clone; a broken one is ordinary data and is copied whole.
       # A .git FILE (linked worktree, submodule) marks a work tree too, so its own state is captured, never dropped.
       $clones=@(Get-ChildItem $src -Recurse -Force -Filter .git -ErrorAction SilentlyContinue|ForEach-Object{Split-Path $_.FullName -Parent}|Where-Object{$top="$(& git -C $_ rev-parse --show-toplevel 2>$null)";!$LASTEXITCODE-and$top-and[IO.Path]::GetFullPath($top)-eq$_}|ForEach-Object{if($_.Length-gt$src.Length){$_.Substring($src.Length+1)+'\'}else{'.git\'}})
       Copy-Tree $src (Join-Path $out "legacy\$n") {param($rel)if($rel-match'(^|\\)node_modules\\'){return $true};foreach($c in $clones){if($rel.StartsWith($c)){return $true}};$false}
       foreach($c in $clones){$rel=if($c-eq'.git\'){''}else{$c};Save-CloneState (Join-Path $src $rel) (Join-Path $out "legacy\$n\$rel")}
   }}
   ```
   with
   ```text
   }
   ```

   The resulting file's Git blob is 02400ebb0d2a78f81472bac65104ee32c891a552.

9. Check whether `lib/Coordinator.ps1` contains `# Item text is masked where items are built, before any view shortens it (a cut first leaves a token's prefix).`; if so record Already Applied when its Git blob is 0dbb346bbcb7d9e70941dd701e2ea5415f6603fb, and otherwise stop and report. Otherwise make exactly these 4 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}))
   ```
   with
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'}))
   ```

   b) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   if(!$PSBoundParameters.ContainsKey('Root')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $Root 'events') -PathType Container)){'COORDINATOR_UNAVAILABLE: ORVION_DATA_ROOT_UNAVAILABLE';exit 3}
   ```

   c) immediately after the line
   ```text
   $ev=Join-Path $PSScriptRoot 'Events.ps1';$log=Join-Path $Root 'events\events.jsonl'
   ```
   insert
   ```text
   # Item text is masked where items are built, before any view shortens it (a cut first leaves a token's prefix).
   $null=New-Module -Name CoordinatorMask -ScriptBlock {param($Library,$Data) . (Join-Path $Library 'Sync-Sessions.ps1') -Library -Root $Data;Export-ModuleMember -Function Hide-Secret} -ArgumentList $PSScriptRoot,$Root|Import-Module -PassThru
   ```

   d) replace the lines
   ```text
       [pscustomobject]@{pattern=$g.Name;state=$state;owner=$own;action=$act;due=$dueAt;age=[int]($Now-(ConvertTo-Utc $since[0].at)).TotalDays
           summary=$z.summary;last=(ConvertTo-Utc $z.at);recurred=$closed.Count;lastFix=$(if($last){"$(([datetime](ConvertTo-Utc $last.at)).ToString('yyyy-MM-dd')) $($last.status): $($last.summary)"})}
   ```
   with
   ```text
       [pscustomobject]@{pattern=$g.Name;state=$state;owner=$own;action=$(if($act){Hide-Secret $act});due=$dueAt;age=[int]($Now-(ConvertTo-Utc $since[0].at)).TotalDays
           summary=(Hide-Secret $z.summary);last=(ConvertTo-Utc $z.at);recurred=$closed.Count;lastFix=$(if($last){"$(([datetime](ConvertTo-Utc $last.at)).ToString('yyyy-MM-dd')) $($last.status): $(Hide-Secret $last.summary)"})}
   ```

   The resulting file's Git blob is 0dbb346bbcb7d9e70941dd701e2ea5415f6603fb.

10. Check whether `lib/Delegate.ps1` contains `if(!$PSBoundParameters.ContainsKey('Root')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $Root 'events') -PathType Container)){`; if so record Already Applied when its Git blob is 0ed83ab1c36c924274c3209e9e382beef0d98826, and otherwise stop and report. Otherwise make exactly these 4 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}))
   ```
   with
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'}))
   ```

   b) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   if(!$PSBoundParameters.ContainsKey('Root')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $Root 'events') -PathType Container)){
       if($List){'DELEGATIONS_UNAVAILABLE: ORVION_DATA_ROOT_UNAVAILABLE';exit 3};throw 'ORVION_DATA_ROOT_UNAVAILABLE'
   }
   . (Join-Path $PSScriptRoot 'workspace-layout.ps1')
   $temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout (Split-Path $PSScriptRoot -Parent)
   ```

   c) replace the line
   ```text
   "- You MAY create disposable copies (clones, worktrees, files) under ``$([IO.Path]::GetTempPath())`` and run experiments there, including deliberate failure injection. Delete them when done.
   ```
   with
   ```text
   "- You MAY create disposable copies (clones, worktrees, files) under ``$(Join-Path $temporaryRoot 'cx\ORVION-<task>')`` and run experiments there, including deliberate failure injection. Delete them when done.
   ```

   d) replace the line
   ```text
   - You MUST NOT commit, push, check out, reset or otherwise change the real checkouts (``Documents\GitHub\CRM``, ``Documents\GitHub\ORVION``, the trusted-main clones), edit ``Documents\ORVION-Owner-Review``, touch credentials (``gh auth``, tokens), call remote services that write, or start ``-Finish``.
   ```
   with
   ```text
   - You MUST NOT commit, push, check out, reset or otherwise change the real checkouts (``Documents\GitHub\CRM``, ``Documents\GitHub\ORVION``, the trusted-main clones), edit ``$Root\records``, touch credentials (``gh auth``, tokens), call remote services that write, or start ``-Finish``.
   ```

   The resulting file's Git blob is 0ed83ab1c36c924274c3209e9e382beef0d98826.

11. Check whether `lib/Events.ps1` contains `[Parameter(ParameterSetName='add')][Parameter(ParameterSetName='find')][string]$Repo='',`; if so record Already Applied when its Git blob is c378107bf82bc1fc9b8466c2f90b9045420ea685, and otherwise stop and report. Otherwise make exactly these 9 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
       [Parameter(ParameterSetName='add')][string]$Repo='',
   ```
   with
   ```text
       [Parameter(ParameterSetName='add')][Parameter(ParameterSetName='find')][string]$Repo='',
   ```

   b) replace the line
   ```text
       [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]})  # the data root: ORVION_DATA_ROOT, else sibling ORVION-Owner-Tools, else this checkout
   ```
   with
   ```text
       [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'})  # the data root: ORVION_DATA_ROOT, else sibling ORVION-Owner-Tools; missing readers are UNAVAILABLE
   ```

   c) immediately after the line
   ```text
   if($Add){
   ```
   insert
   ```text
       if(!$PSBoundParameters.ContainsKey('Root')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $Root 'events') -PathType Container)){throw 'ORVION_DATA_ROOT_UNAVAILABLE'}
   ```

   d) immediately after the line
   ```text
       try{
   ```
   insert
   ```text
           # the repository is part of the fact: resolve it before the duplicate check
           if(!$PSBoundParameters.ContainsKey('Repo')){
               $gitRoot=@(& git -C (Get-Location).Path rev-parse --show-toplevel 2>$null)
               if($LASTEXITCODE-eq0-and$gitRoot.Count){$Repo=Split-Path $gitRoot[-1] -Leaf}
           }
   ```

   e) replace the lines
   ```text
           $last=@(Read-Events|Where-Object{$_.pattern-eq$Pattern-and$_.session-eq$Session-and$_.summary-eq$Summary-and$_.status-eq$Status-and"$($_.owner)"-eq$Owner-and"$($_.action)"-eq$Action-and"$($_.due)"-eq$Due-and"$($_.evidence)"-ceq$Evidence})
           if($last.Count){"EVENT DUPLICATE $Pattern (already recorded for this session)";exit 0}  # watchers repeat; one line per fact
   ```
   with
   ```text
           $last=@(Read-Events|Where-Object{$_.pattern-eq$Pattern}|Sort-Object at -Stable|Select-Object -Last 1)
           if($last.Count-and$last[0].session-eq$Session){
               $same=$true
               foreach($field in 'summary','status','category','cause','severity','action','evidence','owner','due','repo'){
                   if([string]$last[0].$field -cne [string](Get-Variable -Name $field -ValueOnly)){$same=$false;break}
               }
               if($same){"EVENT DUPLICATE $Pattern (already recorded for this session)";exit 0}
           }
   ```

   f) replace the line
   ```text
   if(!(Test-Path -LiteralPath $log)){"EVENTS_UNAVAILABLE: no journal at $log (pass -Root or set ORVION_DATA_ROOT)";exit 3}
   ```
   with
   ```text
   # The archive's secret rules, loaded in their own module so the library cannot touch this script's variables;
   # every reader line (entries and diagnostics naming paths) leaves masked.
   $null=New-Module -Name EventsMask -ScriptBlock {param($Library,$Data) . (Join-Path $Library 'Sync-Sessions.ps1') -Library -Root $Data;Export-ModuleMember -Function Hide-Secret} -ArgumentList $PSScriptRoot,$Root|Import-Module -PassThru
   if(!(Test-Path -LiteralPath $log)){Hide-Secret "EVENTS_UNAVAILABLE: no journal at $log (pass -Root or set ORVION_DATA_ROOT)";exit 3}
   ```

   g) replace the lines
   ```text
       if($script:badLines){"EVENTS_INCOMPLETE: $($script:badLines) unreadable record(s) skipped in $log; results may miss them"}
       if($script:badIndexLines){"EVENTS_INCOMPLETE: $($script:badIndexLines) unreadable record(s) skipped in $ix; session links may miss them"}
   ```
   with
   ```text
       if($script:badLines){Hide-Secret "EVENTS_INCOMPLETE: $($script:badLines) unreadable record(s) skipped in $log; results may miss them"}
       if($script:badIndexLines){Hide-Secret "EVENTS_INCOMPLETE: $($script:badIndexLines) unreadable record(s) skipped in $ix; session links may miss them"}
   ```

   h) replace the lines
   ```text
   $views=foreach($g in @(Read-Events|Group-Object pattern)){
       $r=@($g.Group|Sort-Object at);$z=$r[-1]
   ```
   with
   ```text
   # -Repo and a stored repo are lists ("CRM,ORVION"); an owner/repo slug counts by its repo name; Workbench = ORVION-Workbench.
   function Get-RepoNames([string]$Value){@($Value-split'[,\s]+'|Where-Object{$_}|ForEach-Object{$n=($_-split'/')[-1];if($n-ieq'Workbench'){'ORVION-Workbench'}else{$n}})}
   $repoWanted=Get-RepoNames $Repo
   $views=foreach($g in @(Read-Events|Where-Object{!$Find-or!$Repo-or$Repo-eq'all'-or@(Get-RepoNames $_.repo|Where-Object{$repoWanted-icontains$_}).Count}|Group-Object pattern)){
       $r=@($g.Group|Sort-Object at -Stable);$z=$r[-1]
   ```

   i) replace the lines
   ```text
           $line+="`n    raw record: session $($s.id.Substring(0,[Math]::Min(8,$s.id.Length))) $when `"$($s.title)`" -> $(Join-Path $Root $s.raw)"}
       $line
   ```
   with
   ```text
           $line+="`n    raw record: session $($s.id.Substring(0,[Math]::Min(8,$s.id.Length))) $when `"$($s.title)`" -> $(Join-Path $Root $s.raw)"}
       Hide-Secret $line  # every rendered field (summary, action, evidence, title) leaves masked
   ```

   The resulting file's Git blob is c378107bf82bc1fc9b8466c2f90b9045420ea685.

12. Check whether `lib/hooks/Watch-Reminder.ps1` contains `if(!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $dataRoot 'events') -PathType Container)){throw 'ORVION_DATA_ROOT_UNAVAILABLE'}`; if so record Already Applied when its Git blob is c818b92fbb424777a81eb0d6a4baa034ad89630f, and otherwise stop and report. Otherwise make exactly these 6 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
       $dataRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]})
   ```
   with
   ```text
       $dataRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'})
       if(!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $dataRoot 'events') -PathType Container)){throw 'ORVION_DATA_ROOT_UNAVAILABLE'}
   ```

   b) immediately after the line
   ```text
           $mode=if($hookEvent-eq'SessionStart'){'-Follow -Quiet'}else{'-Quiet'}
   ```
   insert
   ```text
           . (Join-Path $lib 'workspace-layout.ps1')
           $null=Initialize-OrvionTemporaryRoot -Checkout $workbench
   ```

   c) replace the line
   ```text
               foreach($pulseFile in $pulseOut,$pulseErr){if(Test-Path -LiteralPath $pulseFile){Remove-Item -LiteralPath $pulseFile -Force}}
   ```
   with
   ```text
               foreach($pulseFile in $pulseOut,$pulseErr){try{if(Test-Path -LiteralPath $pulseFile){Remove-Item -LiteralPath $pulseFile -Force}}catch{$null=$_}}
   ```

   d) replace the line
   ```text
       $relativeRootRefused=$_.Exception.Message-eq'ORVION_DATA_ROOT_NOT_ABSOLUTE'
   ```
   with
   ```text
       $rootFailureCode=if($_.Exception.Message-in'ORVION_DATA_ROOT_NOT_ABSOLUTE','ORVION_DATA_ROOT_UNAVAILABLE','WB_TEMP_LAYOUT_UNAVAILABLE','WB_TEMP_ROOT_NOT_ABSOLUTE','WB_TEMP_MATERIALIZATION_FAILED'){$_.Exception.Message}
   ```

   e) replace the line
   ```text
       foreach($candidate in @($env:ORVION_DATA_ROOT)+@(if(Test-Path -LiteralPath (Join-Path $sibling 'events')){$sibling})+@($checkout)){
   ```
   with
   ```text
       foreach($candidate in @($env:ORVION_DATA_ROOT)+@(if(Test-Path -LiteralPath (Join-Path $sibling 'events')){$sibling})){
   ```

   f) replace the line
   ```text
       [Console]::Error.WriteLine('WATCH_REMINDER_UNREADABLE: '+$(if($relativeRootRefused){'ORVION_DATA_ROOT_NOT_ABSOLUTE; '})+'reporting failed; consult the native authority, not an inferred success.')
   ```
   with
   ```text
       [Console]::Error.WriteLine('WATCH_REMINDER_UNREADABLE: '+$(if($rootFailureCode){$rootFailureCode+'; '})+'reporting failed; consult the native authority, not an inferred success.')
   ```

   The resulting file's Git blob is c818b92fbb424777a81eb0d6a4baa034ad89630f.

13. Check whether `lib/Hunt.ps1` contains `# -NoRecord suppresses events only; work\hunt-last.txt is still written in the data root.`; if so record Already Applied when its Git blob is 2b6e7209ebec580edd0c1919d4d52e18dc6bf43d, and otherwise stop and report. Otherwise make exactly these 5 edits (One clean layout only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   #   lint        PSScriptAnalyzer bug-relevant rules, when installed (known false positives listed below)
   ```
   insert
   ```text
   # -NoRecord suppresses events only; work\hunt-last.txt is still written in the data root.
   ```

   b) replace the line
   ```text
   param([string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quick,[switch]$NoRecord,[object[]]$MutantSet,[string]$DataRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}))  # -MutantSet: test-hunt.ps1 only
   ```
   with
   ```text
   param([string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quick,[switch]$NoRecord,[object[]]$MutantSet,[string]$DataRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'}),[scriptblock]$GetMapTask={Get-ScheduledTask -TaskName 'ORVION Repository Map' -ErrorAction Stop | Get-ScheduledTaskInfo -ErrorAction Stop})  # test seams
   ```

   c) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   if(!$PSBoundParameters.ContainsKey('DataRoot')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $DataRoot 'events') -PathType Container)){throw 'ORVION_DATA_ROOT_UNAVAILABLE'}
   . (Join-Path $PSScriptRoot 'workspace-layout.ps1')
   $temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout $Root
   ```

   d) immediately after the line
   ```text
   function Add-Finding([string]$Kind,[string]$Hound,[string]$Text,[string]$Tags=''){$findings.Add([pscustomobject]@{kind=$Kind;hound=$Hound;text=$Text;tags=$Tags})}
   ```
   insert
   ```text
   try{$mapTaskInfo=& $GetMapTask;if(!$mapTaskInfo-or$null-eq$mapTaskInfo.LastTaskResult-or$mapTaskInfo.LastTaskResult-ne0){throw 'missing or nonzero result'}}catch{Add-Finding GAP map-task 'ORVION Repository Map task missing or last result non-zero/unreadable' 'repository map scheduled task'}
   ```

   e) replace the line
   ```text
           ,@('Watch-Subagents.ps1','$e.message.stop_reason-eq''end_turn''','$text','test-watch-subagents.ps1','finished only on end_turn')
   ```
   with
   ```text
           ,@('Watch-Subagents.ps1','$e.message.stop_reason-eq''end_turn''','$false','test-watch-subagents.ps1','finished only on end_turn')
   ```

   The resulting file's Git blob is 2b6e7209ebec580edd0c1919d4d52e18dc6bf43d.

14. Check whether `lib/Invoke-DraftRehearsal.ps1` contains `. (Join-Path $PSScriptRoot 'workspace-layout.ps1')`; if so record Already Applied when its Git blob is a862e2530992dfec0d9ee01fbed3d9229c13244f, and otherwise stop and report. Otherwise make exactly this one edit (One clean layout only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   . (Join-Path $PSScriptRoot 'workspace-layout.ps1')
   $temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout (Split-Path $PSScriptRoot -Parent)
   ```

   The resulting file's Git blob is a862e2530992dfec0d9ee01fbed3d9229c13244f.

15. Check whether `lib/Map-Repos.ps1` contains `[string]$Links,[switch]$Orphans,[switch]$Install,[switch]$Uninstall,[string[]]$Skip=@('*-trusted-main','ORVION-Owner-Tools','ORVION-Workbench-temporary','_*'))`; if so record Already Applied when its Git blob is 72d8ae37e3ddf915aadc0e4f2b1b03ba1c409005, and otherwise stop and report. Otherwise make exactly these 4 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
   # ORVION-Owner-Tools data store are skipped; an unborn or broken repository is listed under `problems`, never fatal.
   ```
   with
   ```text
   # ORVION-Owner-Tools data store and ORVION-Workbench-temporary tree are skipped; an unborn or broken repository is listed under `problems`, never fatal.
   ```

   b) replace the line
   ```text
         [string]$Links,[switch]$Orphans,[switch]$Install,[switch]$Uninstall,[string[]]$Skip=@('*-trusted-main','ORVION-Owner-Tools','_*'))
   ```
   with
   ```text
         [string]$Links,[switch]$Orphans,[switch]$Install,[switch]$Uninstall,[string[]]$Skip=@('*-trusted-main','ORVION-Owner-Tools','ORVION-Workbench-temporary','_*'))
   ```

   c) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   . (Join-Path $PSScriptRoot 'workspace-layout.ps1')
   ```

   d) replace the lines
   ```text
   $repos=@(foreach($d in Get-ChildItem -LiteralPath $GitHub -Directory){
       if(@($Skip|Where-Object{$d.Name-like$_}).Count-or!(Test-Path -LiteralPath (Join-Path $d.FullName '.git'))){continue}
       $top="$(& git -C $d.FullName rev-parse --show-toplevel 2>$null)"
       if($LASTEXITCODE-or!$top-or[IO.Path]::GetFullPath($top)-ne$d.FullName){$problems.Add([ordered]@{repo=$d.Name;problem='not a readable Git work tree'});continue}
       $head="$(& git -C $d.FullName rev-parse -q --verify HEAD)".Trim();if(!$head){$problems.Add([ordered]@{repo=$d.Name;problem='no commits yet'})}
       [pscustomobject]@{name=$d.Name;root=$d.FullName;head=$head;branch="$(& git -C $d.FullName symbolic-ref -q --short HEAD)".Trim()
           origin=("$(& git -C $d.FullName config --get remote.origin.url)".Trim()-replace'://[^/@\s]+@','://')}
   ```
   with
   ```text
   $repos=@(foreach($d in Get-OrvionRepositoryCandidates -GitHub $GitHub -Skip $Skip){
       if($d.problem){$problems.Add([ordered]@{repo=$d.name;problem=$d.problem});continue}
       $head="$(& git -C $d.root rev-parse -q --verify HEAD)".Trim();if(!$head){$problems.Add([ordered]@{repo=$d.name;problem='no commits yet'})}
       [pscustomobject]@{name=$d.name;root=$d.root;head=$head;branch="$(& git -C $d.root symbolic-ref -q --short HEAD)".Trim()
           origin=("$(& git -C $d.root config --get remote.origin.url)".Trim()-replace'://[^/@\s]+@','://')}
   ```

   The resulting file's Git blob is 72d8ae37e3ddf915aadc0e4f2b1b03ba1c409005.

16. Check whether `lib/Pulse.ps1` contains `#   map        ai-map freshness: each mapped repository's saved head against its live HEAD`; if so record Already Applied when its Git blob is 1be958f0d7a55969d82f00593a0f0b4d495aa286, and otherwise stop and report. Otherwise make exactly these 10 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   # Read-only; a failing git read prints UNREADABLE for that repository instead of guessing.
   param([string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}),[string]$Session=$env:CLAUDE_CODE_SESSION_ID,
         [string[]]$Repos=@('CRM','ORVION'|ForEach-Object{Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) $_}))
   ```
   with
   ```text
   #   map        ai-map freshness: each mapped repository's saved head against its live HEAD
   # Read-only except one side effect: a stale map starts its refresh task. A failing read prints UNREADABLE, never a guess.
   param([string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'}),[string]$Session=$env:CLAUDE_CODE_SESSION_ID,
         [string[]]$Repos=@('CRM','ORVION'|ForEach-Object{Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) $_}),
         [scriptblock]$StartMapTask={Start-ScheduledTask -TaskName 'ORVION Repository Map' -ErrorAction Stop},
         [string]$MapPath=(Join-Path (Split-Path $PSScriptRoot -Parent) 'ai-map.json'))  # owner-fixed generated map location
   ```

   b) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   if(!$PSBoundParameters.ContainsKey('Root')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $Root 'events') -PathType Container)){'PULSE_UNAVAILABLE: ORVION_DATA_ROOT_UNAVAILABLE';exit 3}
   ```

   c) immediately after the line
   ```text
   $pulseUnreadable=$false
   ```
   insert
   ```text
   # Mask every value before it is shortened: a cut first can leave a token's tail unmasked. The library loads in its own
   # module, isolated from Pulse's variables.
   $null=New-Module -Name PulseMask -ScriptBlock {param($Library,$Data) . (Join-Path $Library 'Sync-Sessions.ps1') -Library -Root $Data;Export-ModuleMember -Function Hide-Secret} -ArgumentList $PSScriptRoot,$Root|Import-Module -PassThru
   ```

   d) immediately after the line
   ```text
   "ORVION PULSE $([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC"
   ```
   insert
   ```text
   if(!(Test-Path -LiteralPath $MapPath -PathType Leaf)){"map      missing: pwsh -NoProfile -File lib\Map-Repos.ps1 -Install"}
   else{try{
       $map=[IO.File]::ReadAllText($MapPath)|ConvertFrom-Json
       $mappedRepos=@($map|ForEach-Object{$_.repos}|Where-Object{$null-ne$_})  # @($null).Count is 1: a blank map must not read as fresh
       if(!$mappedRepos.Count){throw 'no mapped repositories'}
       $stale=@(foreach($mapped in $mappedRepos){
           if(!$mapped.name-or!$mapped.root-or!$mapped.head){throw 'map entry without name, root or head'}
           if((Get-GitLine $mapped.root rev-parse HEAD)-ne$mapped.head){$mapped.name}})
       if($stale){& $StartMapTask|Out-Null;"map      stale ($($stale-join', ')): refresh started"}else{'map      fresh'}
   }catch{$pulseUnreadable=$true;"map      UNREADABLE ($($_.Exception.Message))"}}
   ```

   e) replace the line
   ```text
       $last=if($log-and(Test-Path -LiteralPath $log)){@(Get-Content -LiteralPath $log -Tail 1)[0]}else{''}
   ```
   with
   ```text
       $last=if($log-and(Test-Path -LiteralPath $log)){Hide-Secret @(Get-Content -LiteralPath $log -Tail 1)[0]}else{''}
   ```

   f) immediately after the line
   ```text
       "waiting  on the owner: $($waiting.Count)"
   ```
   insert
   ```text
       # Snapshot summaries arrive masked: Coordinator masks item text where it builds items.
   ```

   g) replace the line
   ```text
   function Format-PulsePrompt([string]$Text){if($Text.Length-gt300){return $Text.Substring(0,297)+'...'};$Text}
   ```
   with
   ```text
   function Format-PulsePrompt([string]$Text){$Text=Hide-Secret $Text;if($Text.Length-gt300){return $Text.Substring(0,297)+'...'};$Text}
   ```

   h) replace the lines
   ```text
   # Mask complete lines before any new abbreviation; the library is isolated from Pulse's variables.
   $pulseSafeLines=@(& {
       param($Lines,$Library,$Data)
       . (Join-Path $Library 'Sync-Sessions.ps1') -Library -Root $Data
       foreach($line in $Lines){Hide-Secret $line}
   } $pulseLines $PSScriptRoot $Root)
   ```
   with
   ```text
   # Mask complete lines again before any new abbreviation (covers every line not masked at its source).
   $pulseSafeLines=@(foreach($line in $pulseLines){Hide-Secret $line})
   ```

   i) replace the lines
   ```text
       $priority=if($text-match'^ORVION PULSE|^state\s'){0}elseif($text-match'^(waiting|cases|tools)\s'){1}elseif(!$ownerDetail-and$text-match'^(repo|running|last|queue)\s.*UNREADABLE'){2}
           elseif($text-match'^last\s|^         in flight:'){3}elseif($text-match'^(repo|running|hunt)\s'){4}elseif($ownerDetail){6}else{5}
   ```
   with
   ```text
       # Priority from line structure only: summary words (an owner note saying "UNOWNED") never promote a line.
       # Non-owner "         - " lines are the Coordinator's escalated (UNOWNED/OVERDUE) items.
       $priority=if($text-match'^ORVION PULSE|^state\s'){0}elseif($text-match'^(waiting|cases|tools)\s'){1}elseif($ownerDetail){6}
           elseif($text-match'^(repo|running|last|queue|map)\s.*UNREADABLE'){2}
           elseif($text-match'^last\s|^         (in flight:|- )'){3}elseif($text-match'^(repo|running|hunt|map)\s'){4}else{5}
   ```

   j) immediately after the line
   ```text
       if($coordinatorCommand.Length-gt1000){$coordinatorCommand='Coordinator.ps1 -Root <same Root supplied to Pulse>'}
   ```
   insert
   ```text
       $coordinatorCommand=Hide-Secret $coordinatorCommand
   ```

   The resulting file's Git blob is 1be958f0d7a55969d82f00593a0f0b4d495aa286.

17. Check whether `lib/README.md` contains `Historical citation: Documents\ORVION-Sandbox\lib was the former library location, now retired.`; if so record Already Applied when its Git blob is 7cf9dc0bbc327fda396e0aefb6dd18c830dff227, and otherwise stop and report. Otherwise make exactly these 6 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   not a dependency injected into direct-native product operation. Its historical move from Documents\ORVION-Sandbox\lib
   does not make that old copy an execution entry.
   ```
   with
   ```text
   not a dependency injected into direct-native product operation.

   Historical citation: Documents\ORVION-Sandbox\lib was the former library location, now retired.
   ```

   b) replace the line
   ```text
   `ORVION_DATA_ROOT`, else the sibling `..\ORVION-Owner-Tools` store when it has `events\`, else this checkout.
   ```
   with
   ```text
   `ORVION_DATA_ROOT`, else the sibling `..\ORVION-Owner-Tools` store. Missing data is unavailable; default writers
   refuse `ORVION_DATA_ROOT_UNAVAILABLE` unless the sibling has `events\`. Pass an explicit root for tests/hosted use.
   ```

   c) replace the line
   ```text
   reports that code on stderr, exits 0, and logs to the next fully qualified fallback root.
   ```
   with
   ```text
   reports on stderr, exits 0, and logs only to an absolute override or an existing sibling store, never the checkout.
   Hunt `-NoRecord` suppresses events only: `work\hunt-last.txt` remains in the data root.
   ```

   d) replace the lines
   ```text
   Use `C:\cx\ORVION-<task>` for disposable Codex clones, including CRM work: that shape is archived. A generic
   `C:\cx\repo` or `C:\cx\CRM-<task>` is not selected. Naming a clone does not change its native repository authority.
   ```
   with
   ```text
   Use `..\ORVION-Workbench-temporary\cx\<name>` for disposable Codex clones. That parent contains ORVION, so its
   clones are selected by the archival cwd rule. Naming a clone does not change its native repository authority.

   ## Arrival and knowledge practice

   Pulse supplies live state; use the private STATE.md route from the root resume file, never a copied owner-wait inventory. If STATE.md is missing or unreadable, resume from Pulse's `in flight` lines; if commands cannot run, read the newest `RESUME HERE` entry in the journal (`Events.ps1 -Find 'resume here'`). Before authorized operational work, Events -Find returns relevant lessons and Spider recovers a specific original fact. Use the actual resolved data root described above, not a second journal. Find a comparable executed contract in its owning repository and reuse its proven shape. Hunt Quick NoRecord is bounded gap discovery; full Hunt is reserved for relevant risky work. A first diagnosis is a hypothesis until measured.

   Confirmed lessons become Events entries and graduate through a contract to their repository home. Long work records a dated checkpoint and RESUME HERE pointer in the one journal. A recurring pattern is an investigation candidate, not authority for a task. Retained sessions include client-written messages, tool calls/results, attachments, subagents and hook context; hidden reasoning, unwritten client state and already-deleted sources cannot be recovered. Claude's retention can remove originals; the archive preserves retained bytes rather than summarizing them away. Credential-shaped index findings name rules/locations, never values; token shapes do not prove live credentials. Review recovery scan findings through [RECOVERY.md](../docs/RECOVERY.md).

   Use absolute -File paths: pwsh -WorkingDirectory does not select a relative script. .NET file APIs ignore PowerShell location, and worktree git config may edit shared local configuration. A failed native read is not empty success; use checked exits. PowerShell double-quoted text turns `` `r `` / `` `t `` into control bytes and drops other backticks: write Markdown code as ` ``x`` ` there; the Gate refuses U+000D (`PROHIBITED_CHARACTER`). Literal Draft steps must survive actual applier preflight and blob comparison: they must match how `apply-draft-steps.ps1` applies them (substring matching, deletions with context, a final newline; `test-draft-steps.ps1` covers it). In a product repository, never write an unallocated SPEC id in a tracked file (it reserves the number), and never commit a blocked checkpoint. Read old code's top level before running a causal negative: it may install real tools. Do not restart a host-killed heavy run without its owning authorization.

   ## Markdown guard

   Test-MarkdownConsistency.ps1 checks working/index/explicit-tree Markdown without writes or external path probes. test-markdown-consistency.ps1 owns isolated Git fixtures and causal guard mutants and is discovered by the existing tests.ps1 recipe. [WORKFLOW](../WORKFLOW.md#markdown-consistency) owns the rules, root budgets, history exceptions and one-home table.
   ```

   e) replace the lines
   ```text
   WORKBENCH_TEST_ROOT selects their explicit parent, otherwise TEMP/ORVION-Workbench/tests is used. Accepted-code
   materializations use WORKBENCH_TEMP_ROOT or that same TEMP/ORVION-Workbench parent. Current prototype
   ```
   with
   ```text
   WORKBENCH_TEST_ROOT selects their explicit parent. `workspace-layout.ps1` resolves temporary storage: explicit
   WORKBENCH_TEMP_ROOT first, then an explicit restore target, then a containing ORVION-Workbench-temporary, then
   the canonical installed checkout's sibling ORVION-Workbench-temporary. Entries set process TEMP and TMP to its
   `tmp\` before children start; accepted-code materializations use that root. Broken local layouts refuse
   `WB_TEMP_LAYOUT_UNAVAILABLE`. Only RUNNER_TEMP, GITHUB_ACTIONS=true or an explicit ORVION_STANDALONE_TEMP=1
   allow system temp for hosted/standalone use. An explicit root must be absolute and outside the checkout. Current prototype
   ```

   f) immediately after the line
   ```text
   Use Workbench.ps1 -CI -Candidate <exact-40-character-lowercase-HEAD> -CIRuntimeRoot <new-external-directory> -Actionlint <external-pinned-actionlint.exe>. The existing engine starts its timed runner/watcher and tests.ps1 once; inspect ci.log, watcher.log, runner.exit, watcher.exit and ci-result.json at that external root. Nonzero, omitted owning suites, changed candidate/recipe/inputs, absent observer or forged direct suite parent refuses. Never invoke tests.ps1 or -CIWorker to bypass the parent. Native Finish/approval/receipt/Review/Complete remain independent and unchanged. This CI result cannot certify original work. Get-WorkbenchCITool owns the pinned tool identities; Get-WorkbenchWorkflowPolicy owns the exact deliberately narrow JSON/YAML workflow policy. No workflow file, hosted bootstrap, remote enforcement or publication is installed by this capability. Future provisioning is a separately governed dependency, not an implicit download or owner-credential use.
   ```
   insert
   ```text

   ## Transport and CI evidence contract

   Observer integrity: Coordinator derives the one event journal, retains valid partial diagnostics but returns UNREADABLE/exit 2 for incomplete required evidence and refuses assignment/closure/dispatch before writes. Technical decisions do not become owner decisions merely by category. Watch-Subagents requires an explicit supported Claude session, masks with the existing library before truncation, exposes missing/unreadable evidence and reports tool-wait cause as UNPROVEN; it never kills, retries or certifies. The optional Watch-Reminder supplies Workbench context only at this root or for an explicit existing Owner-Tools command in that event. Direct-native entry remains independent; archival preserves knowledge separately. These are reporting adapters, not authenticated approval, OS enforcement or a completed general management interface. Reuse one run observer and one shared host observer; report actionable changes immediately and routine long-gate heartbeat at most every five minutes. A late reminder cannot prove earlier live coverage or justify an expensive replay.

   Native stage transport: lib/README.md identifies the existing agent adapters and their evidence limits. An explicit exact config selects one native root/contract; raw Draft SHA256 and destination-filtered blob, clean root, native Boot and normal .githooks precede mutation. Preserve native ACTION/WRITE/START_CONTEXT and refusal output. The existing applier Plan owns creation and literal grammar; scope is checked before writes, only declared paths are staged, and Git owns actual authorship. Native applicability is derived by the native engine, never forced to PASS by this adapter. Appends target legal section names, not an assumed section order. Finish, profiles, tests, receipt validation, Review/Complete and binding remain native; no child test schedule is duplicated. The diagnostic reviewer returns non-success for observed failures or unsupported required evidence and cannot auto-certify descriptive criteria. A post-commit diagnostic refusal requires inspecting actual state before any retry. These bounded adapters are not the general P3 management entry and do not inject dependencies into direct-native operation.

   Post-allocation identity: native transport compares its selected filtered Draft blob with the unique actual Git allocation before native Boot or writes. A self-consistent replacement config/Draft pair grants no authority. Keep original failed proposal/fixtures as evidence and use a new exact candidate rather than substituting frozen bytes.

   Arrival reporting: Pulse consumes one Coordinator Snapshot for owner routing and the queue, preserving that classifier's inherited assignment and explicit Readable state. A category named decision alone is not an owner wait. Missing/failed selected repository or required journal evidence yields visible UNREADABLE and Pulse exit2, never a zero-wait or clean substitute. A readable empty journal, unconfigured upstream or dirty tree retains its actual meaning. These observations grant no write permission, certification or universal liveness guarantee; native Boot and the owning exact contract still decide. test-pulse owns the real Git/journal caller fixtures.

   Local CI capability: lib/Workbench.ps1 -CI -Candidate <full-lowercase-HEAD-SHA> -CIRuntimeRoot <new-absolute-external-directory> -Actionlint <verified-external-actionlint.exe> runs the existing timed runner and one concurrent watcher, then the existing tests.ps1 schedule once. It requires a clean independent root, exact candidate, real timed ancestry/observer and recipe binding ordered tests, hazard/helper blobs, evaluator, root, runtime, PowerShell/Git and pinned grammar tool/policy. Its internal -CIWorker is not a raw-entry bypass; absent real timed ancestry/observer refuses. The driver child is the actual direct suite parent; environment stamps alone grant no admission. A terminal RESUME None is permitted only in that CI route. A CI_TEST_ONLY result is not a local certification receipt, approval, native Review/Complete, hosted check or trusted candidate judgment. No CI path writes native working/archive receipts or lifecycle metadata. Equal-OS-privilege tampering remains outside the local trust boundary; independent accepted-code judgment and hosted protection remain separate requirements.

   The supported first workflow set is exactly .github/workflows/workbench-acceptance.yml, encoded as the closed JSON subset of YAML returned by Get-WorkbenchWorkflowPolicy. All duplicate/unknown keys, changed branch/triggers, conditions, permissions, action/checkout settings, step commands and missing tests refuse. The upstream actionlint1.7.12 Windows/amd64 executable is pinned by Get-WorkbenchCITool (archive and executable SHA256); supply a verified external copy, never install globally or fetch latest implicitly. Semantic validation and real grammar parsing are both mandatory when a workflow exists; zero workflows is legitimate only for local capability preparation, not hosted parity. The policy contains fixed official-download/archive/binary hash-verified provisioning under RUNNER_TEMP/workbench-tools, followed by the fixed CI entry; this unit creates no workflow or hosted provisioning operation. Native owning CI tests require the pinned external tool through -Actionlint (or WORKBENCH_ACTIONLINT for targeted tests). Future hosted installation must prove its own bootstrap/toolchain/runtime and permission boundaries before freeze. Native CI-profile Finish validates this same grammar/policy before its unchanged owning tests and receipt rules; missing tool or unsupported workflow refuses. WORKSTATION remains blocked. No current private protection, hosted success, release interface or real trusted checkout is asserted. CTRL-19 remains OPEN.
   ```

   The resulting file's Git blob is 7cf9dc0bbc327fda396e0aefb6dd18c830dff227.

18. Check whether `lib/Restore-ORVION.ps1` contains `param([string]$PackageDir=$PSScriptRoot,[string]$Staging,`; if so record Already Applied when its Git blob is 2b4b43e1087aa4040c48f622716ba44266b73d33, and otherwise stop and report. Otherwise make exactly these 12 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([string]$PackageDir=$PSScriptRoot,[string]$Staging='C:\ORVION-Temp',
   ```
   with
   ```text
   param([string]$PackageDir=$PSScriptRoot,[string]$Staging,
   ```

   b) replace the line
   ```text
         [string]$LegacyTarget=(Join-Path $env:USERPROFILE 'Documents'),
   ```
   with
   ```text
         [string]$LegacyTarget,
   ```

   c) immediately after the lines
   ```text
       $env:PATH=[Environment]::GetEnvironmentVariable('Path','Machine')+';'+[Environment]::GetEnvironmentVariable('Path','User')
   }
   ```
   insert
   ```text
   # Resolve existing ancestors too: a junction must not hide a persistent destination inside staging.
   function Get-RecoveryActualPath([string]$Path,[int]$Depth=0){
       if($Depth-gt128){throw 'RECOVERY_PATH_UNRESOLVED'}
       $full=[IO.Path]::GetFullPath($Path)
       if($full-eq[IO.Path]::GetPathRoot($full)){return $full}
       $full=$full.TrimEnd('\','/')
       $item=Get-Item -LiteralPath $full -Force -ErrorAction SilentlyContinue
       if($item){
           if($item.Attributes-band[IO.FileAttributes]::ReparsePoint){
               $linkTarget=@($item.Target)[0]
               if(!$linkTarget){throw 'RECOVERY_PATH_UNRESOLVED'}
               if(![IO.Path]::IsPathRooted($linkTarget)){$linkTarget=Join-Path (Split-Path $full -Parent) $linkTarget}
               return Get-RecoveryActualPath $linkTarget ($Depth+1)
           }
       }
       $parent=Split-Path $full -Parent
       if(!$parent-or$parent-eq$full){return $full}
       Join-Path (Get-RecoveryActualPath $parent ($Depth+1)) (Split-Path $full -Leaf)
   }
   ```

   d) replace the lines
   ```text
       Write-Host 'READY/ACTION recovery checklist (manual steps; no further installation here)'
       if($script:RecoveryExit-eq0){Write-Host 'READY: restore and requested product preparation completed'}
       else{Write-Host "ACTION: recovery reported exit $script:RecoveryExit; resolve the failure above before declaring READY"}
   ```
   with
   ```text
       Write-Host 'READY/ACTION recovery checklist (manual steps; no further installation here)'
   ```

   e) replace the lines
   ```text
       Write-RecoveryPluginChecklist (Join-Path $ClaudeHome 'settings.json') $installed
       Write-Host "ACTION: pwsh -File `"$Target\ORVION-Workbench\lib\Map-Repos.ps1`" -Install"
   ```
   with
   ```text
       Write-RecoveryPluginChecklist (Join-Path $ClaudeHome 'settings.json') $installed
   ```

   f) replace the lines
   ```text
           $winget=Get-RecoveryTool 'winget'
           if(!$winget){throw 'RECOVERY_WINGET_REQUIRED: install App Installer from Microsoft Store, then rerun'}
   ```
   with
   ```text
           if(!$Staging){$Staging=Join-Path $Target ('ORVION-Workbench-temporary\restore-staging\'+[DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffffffZ'))}
           $actualStage=Get-RecoveryActualPath $Staging
           foreach($destination in @((Join-Path $Target 'ORVION-Workbench'),(Join-Path $Target 'ORVION-Workbench-trusted-main'),(Join-Path $Target 'ORVION-Owner-Tools'),(Join-Path $Target 'CRM'),(Join-Path $Target 'CRM-trusted-main'),(Join-Path $Target 'ORVION'),(Join-Path $Target 'ORVION-trusted-main'),(Join-Path $Target 'ORVION-Workbench-temporary'),$ClaudeHome,$CodexHome)+@($LegacyTarget|Where-Object{$_})){
               $actual=Get-RecoveryActualPath $destination
               if($actual-ieq$actualStage-or$actual.StartsWith($actualStage+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'RECOVERY_DESTINATION_IN_STAGING'}
           }
           if(Test-Path -LiteralPath $Staging){throw "RECOVERY_STAGING_EXISTS: $Staging must not exist; inspect it before retrying"}
   ```

   g) immediately after the lines
   ```text
           foreach($item in @(@('git','Git.Git'),@('7z','7zip.7zip'),@('pwsh','Microsoft.PowerShell'))){
               if(!(Get-RecoveryTool $item[0])){
   ```
   insert
   ```text
                   $winget=Get-RecoveryTool 'winget'
                   if(!$winget){throw 'RECOVERY_WINGET_REQUIRED: install App Installer from Microsoft Store, then rerun'}
   ```

   h) replace the lines
   ```text
           $archive=Get-RecoveryPackage $PackageDir
           if(Test-Path -LiteralPath $Staging){throw "RECOVERY_STAGING_EXISTS: $Staging must not exist; inspect it before retrying"}
   ```
   with
   ```text
           $archive=Get-RecoveryPackage $PackageDir
   ```

   i) replace the line
   ```text
           Invoke-RecoveryProcess (Get-RecoveryTool 'pwsh') @('-NoProfile','-File',(Join-Path $wb 'lib\Restore-Workspace.ps1'),'-From',$pkg,'-Target',$Target,'-ClaudeHome',$ClaudeHome,'-LegacyTarget',$LegacyTarget,'-CodexHome',$CodexHome)
   ```
   with
   ```text
           $restoreArgs=@('-NoProfile','-File',(Join-Path $wb 'lib\Restore-Workspace.ps1'),'-From',$pkg,'-Target',$Target,'-ClaudeHome',$ClaudeHome,'-CodexHome',$CodexHome)
           if($LegacyTarget){$restoreArgs+=@('-LegacyTarget',$LegacyTarget)}
           Invoke-RecoveryProcess (Get-RecoveryTool 'pwsh') $restoreArgs
   ```

   j) replace the lines
   ```text
           Get-ChildItem -LiteralPath $Staging -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'}
           [IO.Directory]::Delete([IO.Path]::GetFullPath($Staging),$true);$ownsStaging=$false
   ```
   with
   ```text
           foreach($operation in @(@('lib\Restore-Workspace.ps1','-Temporary','-Target',$Target),@('lib\Map-Repos.ps1','-Install','-GitHub',$Target))){
               Invoke-RecoveryProcess (Get-RecoveryTool 'pwsh') (@('-NoProfile','-File',(Join-Path $Target ('ORVION-Workbench\'+$operation[0])))+@($operation[1..($operation.Count-1)]))
               if($script:NativeExitCode){Write-Host "ACTION: $($operation[0]) failed (exit $script:NativeExitCode)";if(!$script:RecoveryExit){$script:RecoveryExit=$script:NativeExitCode}}
           }
   ```

   k) replace the lines
   ```text
           Write-Host "ACTION: $($_.Exception.Message)"
           if($ownsStaging){Write-Host "ACTION: staging retained at $Staging"}
   ```
   with
   ```text
           $code='RECOVERY_FAILED'
           if($_.Exception.Message-match'\A(RECOVERY_[A-Z_]+)(?::|$)'){$code=$Matches[1]}
           Write-Host "ACTION: $code; inspect the package and requested paths before retrying"
   ```

   l) replace the line
   ```text
       try{Write-RecoveryChecklist $Target $ClaudeHome $CodexHome}catch{if(!$script:RecoveryExit){$script:RecoveryExit=1};Write-Host "ACTION: checklist incomplete: $($_.Exception.Message)"}
   ```
   with
   ```text
       try{Write-RecoveryChecklist $Target $ClaudeHome $CodexHome}catch{if(!$script:RecoveryExit){$script:RecoveryExit=1};Write-Host 'ACTION: RECOVERY_CHECKLIST_FAILED'}
       if($ownsStaging-and$script:RecoveryExit-eq0){
           try{
               Get-ChildItem -LiteralPath $Staging -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'}
               [IO.Directory]::Delete([IO.Path]::GetFullPath($Staging),$true);$ownsStaging=$false
           }catch{$script:RecoveryExit=1;Write-Host 'ACTION: RECOVERY_STAGING_CLEANUP_FAILED'}
       }
       if($ownsStaging){Write-Host "ACTION: staging retained at $Staging"}
       if($script:RecoveryExit-eq0){Write-Host 'READY: restore and requested preparation completed'}
   ```

   The resulting file's Git blob is 2b4b43e1087aa4040c48f622716ba44266b73d33.

19. Check whether `lib/Restore-Workspace.ps1` contains `[string]$ClaudeHome=(Join-Path $env:USERPROFILE '.claude'),[string]$LegacyTarget,[switch]$SkipLegacy,`; if so record Already Applied when its Git blob is 6918d2f702c4fea8ad0b43a759582a17bac9d886, and otherwise stop and report. Otherwise make exactly these 10 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the lines
   ```text
         [string]$ClaudeHome=(Join-Path $env:USERPROFILE '.claude'),[string]$LegacyTarget=(Join-Path $env:USERPROFILE 'Documents'),[switch]$SkipLegacy,
         [string]$Package,[string]$CodexHome=(Join-Path $env:USERPROFILE '.codex'))
   ```
   with
   ```text
         [string]$ClaudeHome=(Join-Path $env:USERPROFILE '.claude'),[string]$LegacyTarget,[switch]$SkipLegacy,
         [string]$Package,[string]$CodexHome=(Join-Path $env:USERPROFILE '.codex'),[switch]$Temporary)
   ```

   b) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   . (Join-Path $PSScriptRoot 'workspace-layout.ps1')
   if($Temporary){
       if($From-or$Package-or$LegacyTarget-or$SkipLegacy-or$PSBoundParameters.ContainsKey('ClaudeHome')-or$PSBoundParameters.ContainsKey('CodexHome')){throw 'RESTORE_TEMPORARY_ARGUMENTS'}
       $root=Restore-OrvionTemporary $Target
       "RESTORED temporary workspace: $root"
       return
   }
   ```

   c) immediately after the line
   ```text
   if($Package){
   ```
   insert
   ```text
       $temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout (Split-Path $PSScriptRoot -Parent)
   ```

   d) immediately after the line
   ```text
   $From=(Resolve-Path $From).Path
   ```
   insert
   ```text
   # A data root is never a repository (including a .git file or junction). Refuse before destination writes.
   if(Get-Item -LiteralPath (Join-Path $From 'owner-tools/.git') -Force -ErrorAction SilentlyContinue){throw 'RESTORE_DATA_ROOT_GIT_REFUSED'}
   ```

   e) replace the line
   ```text
       Assert-Absent (Join-Path $Target 'ORVION-Recovery-Inputs')
   ```
   with
   ```text
       # A recovered data root may already carry earlier proof inputs. Identical names must agree.
       foreach($inputFile in Get-ChildItem -LiteralPath (Join-Path $From 'recovery-inputs') -File){
           $existing=Join-Path $From ('owner-tools/records/recovery-inputs/'+$inputFile.Name)
           if((Test-Path -LiteralPath $existing)-and(!(Test-Path -LiteralPath $existing -PathType Leaf)-or(Get-FileHash -LiteralPath $existing).Hash-cne(Get-FileHash -LiteralPath $inputFile.FullName).Hash)){throw 'RESTORE_RECOVERY_INPUT_CONFLICT'}
       }
   ```

   f) immediately after the line
   ```text
   Assert-Absent (Join-Path $Target 'ORVION-Owner-Tools')
   ```
   insert
   ```text
   # Preflight every memory destination, including dangling links, before restoring any repository.
   $memorySources=@{}
   foreach($m in Get-ChildItem -LiteralPath (Join-Path $From 'owner-tools/records/claude-memory') -Directory -ErrorAction SilentlyContinue){$memorySources[$m.Name]=$m.FullName}
   foreach($m in Get-ChildItem -LiteralPath (Join-Path $From 'claude/projects') -Directory -ErrorAction SilentlyContinue){
       $source=Join-Path $m.FullName 'memory'
       if(Test-Path -LiteralPath $source -PathType Container){
           if($memorySources.ContainsKey($m.Name)){throw 'RESTORE_MEMORY_SOURCE_CONFLICT'}
           $memorySources[$m.Name]=$source
       }
   }
   foreach($key in $memorySources.Keys){
       $destination=Join-Path $ClaudeHome "projects/$key/memory"
       $existing=Get-Item -LiteralPath $destination -Force -ErrorAction SilentlyContinue
       $expected=[IO.Path]::GetFullPath((Join-Path $Target "ORVION-Owner-Tools/records/claude-memory/$key")).TrimEnd('\')
       if($existing-and($existing.LinkType-cne'Junction'-or[IO.Path]::GetFullPath(@($existing.Target)[0]).TrimEnd('\')-ine$expected)){throw 'RESTORE_MEMORY_CONFLICT'}
   }
   $temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout (Split-Path $PSScriptRoot -Parent) -Target $(if($PSBoundParameters.ContainsKey('Target')){$Target})
   ```

   g) replace the lines
   ```text
   foreach($m in Get-ChildItem (Join-Path $From 'claude\projects') -Directory -ErrorAction SilentlyContinue){
       $d=Join-Path $ClaudeHome "projects\$($m.Name)\memory"
       if(Test-Path $d){"SKIPPED claude memory $($m.Name) (exists)"}else{New-Item -ItemType Directory (Split-Path $d -Parent) -Force|Out-Null;Copy-Item (Join-Path $m.FullName 'memory') $d -Recurse;"RESTORED claude memory $($m.Name)"}
   ```
   with
   ```text
   foreach($key in $memorySources.Keys){
       $memoryTarget=Join-Path $Target "ORVION-Owner-Tools/records/claude-memory/$key"
       if(!(Test-Path -LiteralPath $memoryTarget)){
           [void][IO.Directory]::CreateDirectory((Split-Path $memoryTarget -Parent))
           Copy-Item -LiteralPath $memorySources[$key] -Destination $memoryTarget -Recurse
       }
       $destination=Join-Path $ClaudeHome "projects/$key/memory"
       [void][IO.Directory]::CreateDirectory((Split-Path $destination -Parent))
       if(!(Get-Item -LiteralPath $destination -Force -ErrorAction SilentlyContinue)){$null=New-Item -ItemType Junction -Path $destination -Target $memoryTarget}
       $link=Get-Item -LiteralPath $destination -Force
       if($link.LinkType-cne'Junction'-or[IO.Path]::GetFullPath(@($link.Target)[0]).TrimEnd('\')-ine[IO.Path]::GetFullPath($memoryTarget).TrimEnd('\')){throw 'RESTORE_MEMORY_JUNCTION_INVALID'}
       "RESTORED claude memory junction $key"
   ```

   h) replace the line
   ```text
   if(!$SkipLegacy){foreach($l in Get-ChildItem (Join-Path $From 'legacy') -Directory -ErrorAction SilentlyContinue){
   ```
   with
   ```text
   if(!$SkipLegacy-and$PSBoundParameters.ContainsKey('LegacyTarget')-and$LegacyTarget){foreach($l in Get-ChildItem (Join-Path $From 'legacy') -Directory -ErrorAction SilentlyContinue){
       [void][IO.Directory]::CreateDirectory($LegacyTarget)
   ```

   i) replace the lines
   ```text
       $d=Join-Path $LegacyTarget $l.Name;if(Test-Path $d){"SKIPPED legacy $($l.Name) (exists)"}else{Copy-Item $l.FullName $d -Recurse;"RESTORED legacy $($l.Name)"}
   }}
   ```
   with
   ```text
       $d=Join-Path $LegacyTarget $l.Name;if(Test-Path $d){"SKIPPED legacy $($l.Name) (exists)"}else{Copy-Item $l.FullName $d -Recurse;"RESTORED legacy $($l.Name)"}
   }}elseif(Test-Path -LiteralPath (Join-Path $From 'legacy')){'ACTION: old package legacy files were not restored; pass -LegacyTarget explicitly to recover them'}
   ```

   j) replace the lines
   ```text
       Copy-Item -LiteralPath (Join-Path $From 'recovery-inputs') -Destination (Join-Path $Target 'ORVION-Recovery-Inputs') -Recurse
       Copy-Item -LiteralPath (Join-Path $From 'backup.json') -Destination (Join-Path $Target 'ORVION-Recovery-Inputs/source-map.json')
   ```
   with
   ```text
       $inputsTarget=Join-Path $Target 'ORVION-Owner-Tools/records/recovery-inputs'
       [void][IO.Directory]::CreateDirectory($inputsTarget)
       foreach($inputFile in Get-ChildItem -LiteralPath (Join-Path $From 'recovery-inputs') -File){
           $destination=Join-Path $inputsTarget $inputFile.Name
           if(!(Test-Path -LiteralPath $destination)){Copy-Item -LiteralPath $inputFile.FullName -Destination $destination}
       }
       $map=Join-Path $From 'backup.json';$mapDestination=Join-Path $inputsTarget 'source-map.json'
       if((Test-Path -LiteralPath $mapDestination)-and(Get-FileHash -LiteralPath $mapDestination).Hash-cne(Get-FileHash -LiteralPath $map).Hash){$mapDestination=Join-Path $inputsTarget ('source-map-'+(Get-FileHash -LiteralPath $map).Hash+'.json')}
       if(!(Test-Path -LiteralPath $mapDestination)){Copy-Item -LiteralPath $map -Destination $mapDestination}
   ```

   The resulting file's Git blob is 6918d2f702c4fea8ad0b43a759582a17bac9d886.

20. Check whether `lib/Spider.ps1` contains `[string]$GitHub=(Split-Path (Split-Path $PSScriptRoot -Parent) -Parent))`; if so record Already Applied when its Git blob is e2f7076d7aaada2eddf5a7f539676f7a07b1b3ca, and otherwise stop and report. Otherwise make exactly these 9 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the lines
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}),
         [string[]]$Repos=@('CRM','ORVION'|ForEach-Object{Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) $_}),
         [string]$ReviewRoot=(Join-Path $env:USERPROFILE 'Documents\ORVION-Owner-Review'))
   ```
   with
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'}),
         [string[]]$Repos,
         [string]$GitHub=(Split-Path (Split-Path $PSScriptRoot -Parent) -Parent))
   ```

   b) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   if(!$PSBoundParameters.ContainsKey('Root')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $Root 'events') -PathType Container)){'SPIDER_UNAVAILABLE: ORVION_DATA_ROOT_UNAVAILABLE';exit 3}
   ```

   c) immediately after the line
   ```text
   . (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $Root  # the archive's secret rules mask snippets the same way
   ```
   insert
   ```text
   . (Join-Path $PSScriptRoot 'workspace-layout.ps1')
   # The three ORVION repositories are always expected: one missing or not Git is a coverage gap, never silently dropped.
   if(!$PSBoundParameters.ContainsKey('Repos')){$Repos=@(@('CRM','ORVION','ORVION-Workbench'|ForEach-Object{Join-Path $GitHub $_})+@(Get-OrvionRepositoryCandidates -GitHub $GitHub|ForEach-Object root)|Select-Object -Unique)}
   ```

   d) replace the line
   ```text
   function Invoke-RepoGit([string]$Repo){$o=& git -C $Repo @args 2>&1;if($LASTEXITCODE-gt1){throw "SPIDER_GIT_FAILED $Repo git $($args-join' '): $o"};@($o|Where-Object{$_-is[string]})}
   ```
   with
   ```text
   function Invoke-RepoGit([string]$Repo){$o=& git -C $Repo @args 2>&1;if($LASTEXITCODE-gt1){throw (Hide-Secret "SPIDER_GIT_FAILED $Repo git $($args-join' '): $o")};@($o|Where-Object{$_-is[string]})}
   ```

   e) immediately after the lines
   ```text
   function Invoke-RepoGit([string]$Repo){$o=& git -C $Repo @args 2>&1;if($LASTEXITCODE-gt1){throw (Hide-Secret "SPIDER_GIT_FAILED $Repo git $($args-join' '): $o")};@($o|Where-Object{$_-is[string]})}

   ```
   insert
   ```text
   # Every rendered line (pointers, file names, note paths, diagnostics) leaves masked; fields cut short are masked first.
   $script:spiderExit=0
   & {
   ```

   f) replace the line
   ```text
       if($log.Count){"   $name commits: $(($log|ForEach-Object{$_.Substring(0,[Math]::Min(90,$_.Length))})-join' | ')"}
   ```
   with
   ```text
       if($log.Count){"   $name commits: $(($log|ForEach-Object{$c=Hide-Secret $_;$c.Substring(0,[Math]::Min(90,$c.Length))})-join' | ')"}
   ```

   g) replace the lines
   ```text
       $projects=Join-Path $env:USERPROFILE '.claude\projects'
       # Claude is optional; enumeration/read errors for a present source must still refuse.
       if(Test-Path -LiteralPath $projects){
           if(!(Test-Path -LiteralPath $projects -PathType Container)){throw 'SPIDER_CLAUDE_PROJECTS_NOT_DIRECTORY'}
           Get-ChildItem -LiteralPath $projects -Directory|ForEach-Object{$m=Join-Path $_.FullName 'memory';if(Test-Path $m){Get-ChildItem $m -File -Filter *.md}}
   ```
   with
   ```text
       $sessionIndex=Join-Path $Root 'sessions\INDEX.md';if(Test-Path -LiteralPath $sessionIndex -PathType Leaf){Get-Item -LiteralPath $sessionIndex}
       $records=Join-Path $Root 'records'
       if(Test-Path -LiteralPath $records -PathType Container){
           Get-ChildItem -LiteralPath $records -File -Filter *.md
           foreach($d in Get-ChildItem -LiteralPath $records -Directory|Where-Object{$_.Name -notmatch 'sandbox' -and !($_.Attributes -band [IO.FileAttributes]::ReparsePoint) -and !(Test-Path -LiteralPath (Join-Path $_.FullName '.git'))}){
               Get-ChildItem -LiteralPath $d.FullName -File -Filter *.md
               foreach($sub in Get-ChildItem -LiteralPath $d.FullName -Directory|Where-Object{$_.Name -notmatch 'sandbox' -and !($_.Attributes -band [IO.FileAttributes]::ReparsePoint) -and !(Test-Path -LiteralPath (Join-Path $_.FullName '.git'))}){Get-ChildItem -LiteralPath $sub.FullName -File -Filter *.md}
           }
   ```

   h) replace the lines
   ```text
       }
       foreach($p in 'README.md','lib\README.md','sessions\INDEX.md'){$x=Join-Path $Root $p;if(Test-Path $x){Get-Item $x}}
       if(Test-Path $ReviewRoot){Get-ChildItem $ReviewRoot -File -Filter *.md;foreach($d in Get-ChildItem $ReviewRoot -Directory){
           Get-ChildItem $d.FullName -File -Filter *.md
           Get-ChildItem $d.FullName -Directory|Where-Object{!(Test-Path (Join-Path $_.FullName '.git'))}|ForEach-Object{Get-ChildItem $_.FullName -File -Filter *.md}}}
   ```
   with
   ```text
       }
   ```

   i) replace the line
   ```text
   if($gaps.Count){$coverage;exit 3}
   ```
   with
   ```text
   if($gaps.Count){$coverage;$script:spiderExit=3}
   }|ForEach-Object{Hide-Secret $_}
   exit $script:spiderExit
   ```

   The resulting file's Git blob is e2f7076d7aaada2eddf5a7f539676f7a07b1b3ca.

21. Check whether `lib/Sync-Sessions.ps1` contains `$watch=[Diagnostics.Stopwatch]::StartNew()`; if so record Already Applied when its Git blob is 6e665874eb1483fdf091b7535f800b35b3f221aa, and otherwise stop and report. Otherwise make exactly these 5 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}),[switch]$Quiet,[switch]$Follow,[int]$IntervalSeconds=60,[int]$IndexMinutes=15,[switch]$Library,
   ```
   with
   ```text
   param([string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'}),[switch]$Quiet,[switch]$Follow,[int]$IntervalSeconds=60,[int]$IndexMinutes=15,[switch]$Library,
   ```

   b) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   if(!$Library-and!$PSBoundParameters.ContainsKey('Root')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $Root 'events') -PathType Container)){throw 'ORVION_DATA_ROOT_UNAVAILABLE'}
   ```

   c) replace the lines
   ```text
       $logKey=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes([IO.Path]::GetFullPath($errLog).ToUpperInvariant())))
       $logMutex=[Threading.Mutex]::new($false,"Local\orvion-sync-errors-$logKey")
       try{
           $logOwned=try{$logMutex.WaitOne($WaitMilliseconds)}catch [Threading.AbandonedMutexException]{$true}
           if(!$logOwned){throw 'SYNC_ERRORS_LOCK_TIMEOUT'}
           $logMutex
       }catch{$logMutex.Dispose();throw}
   ```
   with
   ```text
       $watch=[Diagnostics.Stopwatch]::StartNew()
       while($true){
           try{return [IO.File]::Open($errLog+'.lock',[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)}
           catch [IO.IOException]{
               if(($_.Exception.HResult -band 0xFFFF)-notin 32,33){throw}
               if($WaitMilliseconds-ge0-and$watch.ElapsedMilliseconds-ge$WaitMilliseconds){throw 'SYNC_ERRORS_LOCK_TIMEOUT'}
               Start-Sleep -Milliseconds 50
           }
       }
   ```

   d) replace the line
   ```text
           finally{try{$errorLease.ReleaseMutex()}finally{$errorLease.Dispose()}}
   ```
   with
   ```text
           finally{$errorLease.Dispose()}
   ```

   e) replace the line
   ```text
       }finally{try{$ackLease.ReleaseMutex()}finally{$ackLease.Dispose()}}
   ```
   with
   ```text
       }finally{$ackLease.Dispose()}
   ```

   The resulting file's Git blob is 6e665874eb1483fdf091b7535f800b35b3f221aa.

22. Check whether `lib/test-backup-restore.ps1` contains `# loss warned, records-based memory, old-package compatibility, tampering and destination conflicts refused.`; if so record Already Applied when its Git blob is 754b870715c378cec0efc0b6d5371764029ea9d3, and otherwise stop and report. Otherwise make exactly these 25 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
   # loss warned, a legacy folder that is itself a repository backed up; a tampered backup and an existing target refused.
   ```
   with
   ```text
   # loss warned, records-based memory, old-package compatibility, tampering and destination conflicts refused.
   ```

   b) replace the line
   ```text
   Copy-Item (Join-Path $PSScriptRoot 'Backup-Workspace.ps1'),(Join-Path $PSScriptRoot 'Restore-Workspace.ps1') $lib
   ```
   with
   ```text
   Copy-Item (Join-Path $PSScriptRoot 'Backup-Workspace.ps1'),(Join-Path $PSScriptRoot 'Restore-Workspace.ps1'),(Join-Path $PSScriptRoot 'workspace-layout.ps1') $lib
   ```

   c) immediately after the line
   ```text
   bearer_token_env_var = "EXAMPLE_TOKEN"
   ```
   insert
   ```text
   api_key = "fixture-inline-key"
   password = "fixture-inline-password"
   "access_token" = 'fixture-inline-token'
   pat = "fixture-inline-pat"
   secret = """fixture-multiline
   continued-secret"""
   api_token = "${TOKEN_FROM_ENV}"
   url = "postgresql://env_user:${PGPASSWORD}@localhost/db"
   headers = { api_key = "fixture-inline-header-first", password = "fixture-inline-header-second" }
   keys = ["fixture-inline-array", "fixture-inline-array-tail"]
   credentials = { token = { value = "fixture-inline-nested" } }
   nested = [{ api_key = "fixture-inline-deep" }]
   apiKey = "fixture-inline-camel"
   path = "C:/fixture/keep-path"
   executablePath = "C:/fixture/keep-exe"
   keyboard_layout = "keep-keyboard"
   patch_level = "keep-patch"
   ```

   d) immediately after the line
   ```text
   [IO.File]::WriteAllText((Join-Path $env:USERPROFILE '.codex/config.toml'),$configFixture)
   ```
   insert
   ```text
   $savedTemporaryRoot=$env:WORKBENCH_TEMP_ROOT;$env:WORKBENCH_TEMP_ROOT=Join-Path $t 'managed'
   ```

   e) immediately after the lines
   ```text
   function Read-BackupTree([string]$Path){(@(Get-ChildItem -LiteralPath $Path -Recurse -File -Force|ForEach-Object{[Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($_.FullName))})-join"`n")}
   try{
   ```
   insert
   ```text
       [void][IO.Directory]::CreateDirectory((Join-Path $gh 'ORVION-Owner-Tools/events'))
       # Backup rejects data-root repository metadata before any output is created (file and directory).
       foreach($kind in 'file','directory'){
           $dataGit=Join-Path $gh 'ORVION-Owner-Tools/.git'
           if($kind-eq'file'){[IO.File]::WriteAllText($dataGit,'gitdir: fixture')}else{[void][IO.Directory]::CreateDirectory($dataGit)}
           try{
               $refused=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t "data-git-$kind") -AllowUnencrypted 2>&1)
               Assert-That "backup data-root .git $kind refuses before packaging" ($LASTEXITCODE-ne0-and($refused-join' ')-match'BACKUP_DATA_ROOT_GIT_REFUSED'-and!(Test-Path (Join-Path $t "data-git-$kind")))
           }finally{if($kind-eq'file'){[IO.File]::Delete($dataGit)}else{[IO.Directory]::Delete($dataGit)}}
       }
       function Set-FixtureManifest([string]$PackageRoot){
           $lines=@(Get-ChildItem -LiteralPath $PackageRoot -Recurse -File -Force|Where-Object{$_.Name-ne'SHA256SUMS.txt'}|ForEach-Object{(Get-FileHash -LiteralPath $_.FullName).Hash+'  '+$_.FullName.Substring($PackageRoot.Length+1)})
           [IO.File]::WriteAllLines((Join-Path $PackageRoot 'SHA256SUMS.txt'),[string[]]$lines)
       }
       # An actual old-format package, not an opt-in to the removed legacy backup writer.
       $old=Join-Path $t 'old-package'
       foreach($dir in 'owner-tools','legacy/ORVION-old','claude/projects/key-old/memory'){[void][IO.Directory]::CreateDirectory((Join-Path $old $dir))}
       [IO.File]::WriteAllText((Join-Path $old 'backup.json'),' {"repos":[]}')
       [IO.File]::WriteAllText((Join-Path $old 'legacy/ORVION-old/evidence.txt'),'legacy bytes')
       [IO.File]::WriteAllText((Join-Path $old 'claude/projects/key-old/memory/note.md'),'old memory')
       Set-FixtureManifest $old
       function Test-OldRestore([string]$Label,[string]$ScriptFile="$lib/Restore-Workspace.ps1",[switch]$ExplicitLegacy){
           $target=Join-Path $t $Label;$client=$target+'-client';$legacy=$target+'-legacy'
           $arguments=@('-NoProfile','-File',$ScriptFile,'-From',$old,'-Target',$target,'-ClaudeHome',$client,'-CodexHome',($target+'-codex'))
           if($ExplicitLegacy){$arguments+=@('-LegacyTarget',$legacy)}
           $output=@(& pwsh @arguments 2>&1);$code=$LASTEXITCODE
           [pscustomobject]@{Exit=$code;Text=($output-join"`n");Target=$target;Client=$client;Legacy=$legacy}
       }
       $oldDefault=Test-OldRestore 'old-default'
       $link=Get-Item -LiteralPath ($oldDefault.Client+'/projects/key-old/memory') -Force
       Assert-That 'old memory migrates into records with a verified Junction' ($oldDefault.Exit-eq0-and$link.LinkType-ceq'Junction'-and@($link.Target)[0]-ieq($oldDefault.Target+'/ORVION-Owner-Tools/records/claude-memory/key-old').Replace('/','\')-and[IO.File]::ReadAllText(($oldDefault.Client+'/projects/key-old/memory/note.md'))-ceq'old memory')
       Assert-That 'old legacy defaults to one ACTION and creates no legacy destination' ($oldDefault.Exit-eq0-and@($oldDefault.Text-split"`n"|Where-Object{$_-match'^ACTION: old package legacy'}).Count-eq1-and!(Test-Path $oldDefault.Legacy))
       $oldExplicit=Test-OldRestore 'old-explicit' -ExplicitLegacy
       Assert-That 'explicit LegacyTarget restores old package legacy bytes' ($oldExplicit.Exit-eq0-and[IO.File]::ReadAllText(($oldExplicit.Legacy+'/ORVION-old/evidence.txt'))-ceq'legacy bytes')
       $correctTarget=Join-Path $t 'correct-link'
       $correctMemory=Join-Path $correctTarget 'ORVION-Owner-Tools/records/claude-memory/key-old'
       [void][IO.Directory]::CreateDirectory($correctMemory)
       $correctLink=$correctTarget+'-client/projects/key-old/memory'
       [void][IO.Directory]::CreateDirectory((Split-Path $correctLink -Parent))
       $null=New-Item -ItemType Junction -Path $correctLink -Target $correctMemory
       [IO.Directory]::Delete($correctTarget,$true)
       $correctResult=Test-OldRestore 'correct-link'
       Assert-That 'matching existing junction to the future records target is retained and verified' ($correctResult.Exit-eq0-and(Get-Item -LiteralPath $correctLink).LinkType-ceq'Junction'-and[IO.File]::ReadAllText((Join-Path $correctLink 'note.md'))-ceq'old memory')
       foreach($kind in 'directory','junction','dangling'){
           $target=Join-Path $t ('conflict-'+$kind);$memory=$target+'-client/projects/key-old/memory'
           [void][IO.Directory]::CreateDirectory((Split-Path $memory -Parent))
           if($kind-eq'directory'){[void][IO.Directory]::CreateDirectory($memory)}else{
               $linkTarget=Join-Path $t ('link-target-'+$kind);[void][IO.Directory]::CreateDirectory($linkTarget)
               $null=New-Item -ItemType Junction -Path $memory -Target $linkTarget
               if($kind-eq'dangling'){[IO.Directory]::Delete($linkTarget)}
           }
           $result=Test-OldRestore ('conflict-'+$kind)
           Assert-That "conflicting memory $kind refuses before persistent restore writes" ($result.Exit-ne0-and$result.Text-match'RESTORE_MEMORY_CONFLICT'-and!(Test-Path $result.Target))
       }
       foreach($kind in 'file','directory'){
           $dataGit=Join-Path $old 'owner-tools/.git'
           if($kind-eq'file'){[IO.File]::WriteAllText($dataGit,'gitdir: fixture')}else{[void][IO.Directory]::CreateDirectory($dataGit)}
           Set-FixtureManifest $old
           $result=Test-OldRestore ('packaged-git-'+$kind)
           Assert-That "packaged data-root .git $kind refuses before writes" ($result.Exit-ne0-and$result.Text-match'RESTORE_DATA_ROOT_GIT_REFUSED'-and!(Test-Path $result.Target))
           if($kind-eq'file'){
               $restoreBytes=[IO.File]::ReadAllText("$lib/Restore-Workspace.ps1")
               $anchor="throw 'RESTORE_DATA_ROOT_GIT_REFUSED'"
               if(!$restoreBytes.Contains($anchor)){throw 'MUTANT_STALE packaged git'}
               $mutant=Join-Path $lib 'mutant-restore.ps1';[IO.File]::WriteAllText($mutant,$restoreBytes.Replace($anchor,"Write-Output 'guard removed'"))
               $result=Test-OldRestore 'mutant-packaged-git' $mutant
               Assert-That 'MUTANT killed: packaged data-root .git accepted' ($result.Exit-eq0-and(Test-Path ($result.Target+'/ORVION-Owner-Tools/.git')))
           }
           if($kind-eq'file'){[IO.File]::Delete($dataGit)}else{[IO.Directory]::Delete($dataGit)}
       }
       Set-FixtureManifest $old
       $restoreBytes=[IO.File]::ReadAllText("$lib/Restore-Workspace.ps1")
       $anchor="if(!`$SkipLegacy-and`$PSBoundParameters.ContainsKey('LegacyTarget')-and`$LegacyTarget)"
       if(!$restoreBytes.Contains($anchor)){throw 'MUTANT_STALE legacy'}
       $mutated=$restoreBytes.Replace($anchor,"if(!`$SkipLegacy)").Replace('[string]$LegacyTarget,',"[string]`$LegacyTarget=(Join-Path `$env:USERPROFILE 'Documents'),")
       [IO.File]::WriteAllText($mutant,$mutated)
       $result=Test-OldRestore 'mutant-legacy' $mutant
       if($result.Exit){$result.Text}
       Assert-That 'MUTANT killed: implicit legacy destination recreated' ($result.Exit-eq0-and(Test-Path (Join-Path $env:USERPROFILE 'Documents/ORVION-old/evidence.txt'))-and$result.Text-notmatch'^ACTION: old package legacy')
   ```

   f) replace the line
   ```text
       Copy-Item (Join-Path $PSScriptRoot 'Backup-Workspace.ps1') $probeLib
   ```
   with
   ```text
       Copy-Item (Join-Path $PSScriptRoot 'Backup-Workspace.ps1'),(Join-Path $PSScriptRoot 'workspace-layout.ps1') $probeLib
   ```

   g) replace the line
   ```text
       Assert-That 'Codex URL passwords masked before manifest hashing; usernames and env names intact' ($masked-notmatch'://[^:/@\s]+:(?!\*\*\*@)[^@\s]*@'-and$masked.Contains('://local_user:***@127.0.0.1')-and$masked.Contains('://founder_user:***@127.0.0.1')-and$masked.Contains('EXAMPLE_TOKEN')-and[IO.File]::ReadAllText("$bk\SHA256SUMS.txt").Contains((Get-FileHash $maskedFile).Hash+'  codex\config.toml'))
   ```
   with
   ```text
       Assert-That 'Codex URL passwords masked before manifest hashing; usernames and env names intact' ($masked.Replace('env_user:${PGPASSWORD}@','env_user:***@')-notmatch'://[^:/@\s]+:(?!\*\*\*@)[^@\s]*@'-and$masked.Contains('://local_user:***@127.0.0.1')-and$masked.Contains('://founder_user:***@127.0.0.1')-and$masked.Contains('EXAMPLE_TOKEN')-and[IO.File]::ReadAllText("$bk\SHA256SUMS.txt").Contains((Get-FileHash $maskedFile).Hash+'  codex\config.toml'))
   ```

   h) replace the line
   ```text
       Assert-That 'a legacy folder that is itself a repository is backed up without its .git' ((Test-Path "$bk\legacy\ORVION-drafts-backup\draft.md")-and!(Test-Path "$bk\legacy\ORVION-drafts-backup\.git"))
   ```
   with
   ```text
       Assert-That 'new backup omits legacy folders and separate client memory' (!(Test-Path "$bk/legacy")-and!(Test-Path "$bk/claude/projects"))
       Assert-That 'inline Codex credentials including multiline and inline-table values masked; env references kept' ($masked-notmatch'fixture-inline|fixture-multiline|continued-secret'-and$masked.Contains('${TOKEN_FROM_ENV}')-and$masked.Contains('env_user:${PGPASSWORD}@localhost'))
       Assert-That 'non-credential keys containing pat/key (path, executablePath, keyboard_layout, patch_level) keep their values' ((@('keep-path','keep-exe','keep-keyboard','keep-patch')|Where-Object{!$masked.Contains($_)}).Count-eq0)
       # Keep a legacy-shaped file in this synthetic package to exercise manifest completeness below.
       [void][IO.Directory]::CreateDirectory("$bk/legacy/old");[IO.File]::WriteAllText("$bk/legacy/old/draft.md",'old bytes')
       Add-Content "$bk/SHA256SUMS.txt" ((Get-FileHash "$bk/legacy/old/draft.md").Hash+'  legacy/old/draft.md')
   ```

   i) replace the line
   ```text
                   $nestedOriginKept=(Get-Content -LiteralPath "$folder\legacy\ORVION-drafts-backup\.clone-state\state.json" -Raw|ConvertFrom-Json).origin-ceq$cleanOrigin
   ```
   with
   ```text
                   $nestedOriginKept=!(Test-Path "$folder/legacy")
   ```

   j) replace the lines
   ```text
       $projects=Join-Path $env:USERPROFILE '.claude/projects'
       [void][IO.Directory]::CreateDirectory((Join-Path $projects 'Documents-GitHub-empty/memory'))
       [void][IO.Directory]::CreateDirectory((Join-Path $projects 'Documents-GitHub-missing'))
       $memory=Join-Path $projects 'Documents-GitHub-valid/memory';[void][IO.Directory]::CreateDirectory($memory)
   ```
   with
   ```text
       $projects=Join-Path $gh 'ORVION-Owner-Tools/records/claude-memory'
       [void][IO.Directory]::CreateDirectory((Join-Path $projects 'Documents-GitHub-empty'))
       [void][IO.Directory]::CreateDirectory((Join-Path $projects 'Documents-GitHub-third'))
       $memory=Join-Path $projects 'Documents-GitHub-valid';[void][IO.Directory]::CreateDirectory($memory)
   ```

   k) replace the line
   ```text
       Assert-That 'valid fixture restore preserves optional memory bytes' ($LASTEXITCODE-eq0-and[IO.File]::ReadAllText((Join-Path $t 'ch-memory/projects/Documents-GitHub-valid/memory/fixture.md'))-ceq'fixture memory bytes')
   ```
   with
   ```text
       Assert-That 'records restore preserves memory bytes via junction' ($LASTEXITCODE-eq0-and[IO.File]::ReadAllText((Join-Path $t 'ch-memory/projects/Documents-GitHub-valid/memory/fixture.md'))-ceq'fixture memory bytes')
       $newTarget=Join-Path $t 'restored-memory'
       foreach($key in 'Documents-GitHub-empty','Documents-GitHub-valid','Documents-GitHub-third'){
           $link=Get-Item -LiteralPath (Join-Path $t "ch-memory/projects/$key/memory") -Force
           Assert-That "new records memory $key is a junction to owner records" ($link.LinkType-ceq'Junction'-and@($link.Target)[0]-ieq(Join-Path $newTarget "ORVION-Owner-Tools/records/claude-memory/$key"))
       }
       Assert-That 'separate Claude projects memory is never packaged' (!(Test-Path "$memoryBackup/claude/projects"))
   ```

   l) replace the lines
   ```text
       Assert-That 'missing manifest is fatal before creating a restore target' ($LASTEXITCODE-ne0-and!(Test-Path (Join-Path $t 'restored-no-manifest')))
       $env:USERPROFILE=Join-Path $t 'malformed-profile';[void][IO.Directory]::CreateDirectory((Join-Path $env:USERPROFILE '.claude'))
       [IO.File]::WriteAllText((Join-Path $env:USERPROFILE '.claude/projects'),'not a directory')
       $malformed=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination (Join-Path $t 'usb-malformed') -AllowUnencrypted 2>&1)
       Assert-That 'malformed present projects root is fatal without success' ($LASTEXITCODE-ne0-and($malformed-join' ')-match'BACKUP_CLAUDE_PROJECTS_NOT_DIRECTORY'-and($malformed-join' ')-notmatch'BACKUP:')
       $env:USERPROFILE=Join-Path $t 'profile'
   ```
   with
   ```text
       Assert-That 'missing manifest is fatal before creating a restore target' ($LASTEXITCODE-ne0-and!(Test-Path (Join-Path $t 'restored-no-manifest')))
   ```

   m) replace the line
   ```text
       Assert-That 'declared external proof bytes and original reference map retained' ((Get-FileHash "$wbTarget/ORVION-Recovery-Inputs/required-proof").Hash-ceq(Get-FileHash $proof).Hash-and(Test-Path "$wbTarget/ORVION-Recovery-Inputs/source-map.json"))
   ```
   with
   ```text
       Assert-That 'declared external proof bytes and original reference map retained' ((Get-FileHash "$wbTarget/ORVION-Owner-Tools/records/recovery-inputs/required-proof").Hash-ceq(Get-FileHash $proof).Hash-and(Test-Path "$wbTarget/ORVION-Owner-Tools/records/recovery-inputs/source-map.json"))
       Assert-That 'recovery inputs never recreate the old GitHub sibling' (!(Test-Path "$wbTarget/ORVION-Recovery-Inputs"))
       $recordsInputs=Join-Path $wbb 'owner-tools/records/recovery-inputs'
       [void][IO.Directory]::CreateDirectory($recordsInputs)
       Copy-Item -LiteralPath $proof -Destination (Join-Path $recordsInputs 'required-proof')
       [IO.File]::WriteAllText((Join-Path $recordsInputs 'source-map.json'),'old source map')
       Set-FixtureManifest $wbb
       $repeatTarget=Join-Path $t 'repeat-records'
       $repeated=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target $repeatTarget -ClaudeHome ($repeatTarget+'-ch') -CodexHome ($repeatTarget+'-cx') 2>&1)
       Assert-That 'already-recorded recovery inputs merge identical bytes and preserve prior source map' ($LASTEXITCODE-eq0-and[IO.File]::ReadAllText("$repeatTarget/ORVION-Owner-Tools/records/recovery-inputs/source-map.json")-ceq'old source map'-and(Test-Path (Join-Path $repeatTarget ('ORVION-Owner-Tools/records/recovery-inputs/source-map-'+(Get-FileHash $planFile).Hash+'.json'))))
       [IO.File]::WriteAllText((Join-Path $recordsInputs 'required-proof'),'different bytes')
       Set-FixtureManifest $wbb
       $conflictTarget=Join-Path $t 'conflict-records'
       $conflicted=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target $conflictTarget -ClaudeHome ($conflictTarget+'-ch') 2>&1)
       Assert-That 'conflicting packaged recovery input copies refuse before persistent writes' ($LASTEXITCODE-ne0-and($conflicted-join' ')-match'RESTORE_RECOVERY_INPUT_CONFLICT'-and!(Test-Path $conflictTarget))
       [IO.Directory]::Delete($recordsInputs,$true)
       Set-FixtureManifest $wbb
   ```

   n) replace the line
   ```text
       Copy-Item (Join-Path $lib 'Backup-Workspace.ps1'),(Join-Path $lib 'Restore-Workspace.ps1') $probeLib
   ```
   with
   ```text
       Copy-Item (Join-Path $lib 'Backup-Workspace.ps1'),(Join-Path $lib 'Restore-Workspace.ps1'),(Join-Path $lib 'workspace-layout.ps1') $probeLib
   ```

   o) replace the lines
   ```text
       $nested=Join-Path $t 'ORVION-Sandbox\evidence\c1';& git clone -q $remote $nested 2>&1|Out-Null;if($LASTEXITCODE){throw 'NESTED_FIXTURE_CLONE_FAILED'}
       Set-Content "$nested\a.txt" 'unique';Invoke-Quiet $nested commit -q -am unique|Out-Null;$uniqueHead=(Invoke-Quiet $nested rev-parse HEAD).Trim()
       # Index and worktree differ (staged B, worktree C); an ignored non-receipt evidence file must survive too.
       Set-Content "$nested\a.txt" 'staged';Invoke-Quiet $nested add a.txt|Out-Null;Set-Content "$nested\a.txt" 'dirty';Set-Content "$nested\new.txt" 'untracked'
       Add-Content "$nested\.git\info\exclude" ".workbench-certifications/`nevidence-out/";[void][IO.Directory]::CreateDirectory("$nested\evidence-out");[IO.File]::WriteAllText("$nested\evidence-out\approval.txt",'ignored evidence')
       $detached=Join-Path $t 'ORVION-Sandbox\evidence\c2';& git clone -q $remote $detached 2>&1|Out-Null;Invoke-Quiet $detached checkout -q --detach|Out-Null
       Set-Content "$detached\a.txt" 'detached work';Invoke-Quiet $detached commit -q -am detached|Out-Null;$detachedHead=(Invoke-Quiet $detached rev-parse HEAD).Trim()
       # A linked worktree (.git file) is a work tree of its own: its uncommitted change must be captured, not skipped.
       $linked=Join-Path $t 'ORVION-Sandbox\evidence\wt';Invoke-Quiet $detached worktree add -q --detach $linked|Out-Null;Set-Content "$linked\a.txt" 'worktree change'
       [IO.Directory]::CreateDirectory("$nested\node_modules")|Out-Null;[IO.File]::WriteAllText("$nested\node_modules\m.js",'regenerable inside a clone')
       # Selective package v1: a package needs both products and their trusted clones; omission refuses.
       foreach($n in 'ORVION','CRM-trusted-main'){& git clone -q $remote (Join-Path $gh $n) 2>&1|Out-Null;if($LASTEXITCODE){throw "PRODUCT_FIXTURE_FAILED $n"}}
       # Selective package v1: git's line-ending warnings go to stderr; on real data they were counted as unmerged entries.
       $crlf=Join-Path $t 'ORVION-Sandbox\evidence\c7';& git clone -q $remote $crlf 2>&1|Out-Null;Invoke-Quiet $crlf config core.autocrlf true|Out-Null;[IO.File]::WriteAllText("$crlf\a.txt","lf only`n")
       $crlfWarned=("$(& git -C $crlf diff --name-only --diff-filter=U 2>&1)")-match'CRLF'
   ```
   with
   ```text
       foreach($name in 'ORVION','CRM-trusted-main'){& git clone -q $remote (Join-Path $gh $name) 2>&1|Out-Null;if($LASTEXITCODE){throw "PRODUCT_FIXTURE_FAILED $name"}}
   ```

   p) replace the lines
   ```text
       Invoke-Quiet $crm stash clear|Out-Null
       [void][IO.Directory]::CreateDirectory("$nested\.workbench-certifications");[IO.File]::WriteAllText("$nested\.workbench-certifications\r.json",'{"nested":"receipt"}')
       $broken=Join-Path $t 'ORVION-Sandbox\evidence\broken';[void][IO.Directory]::CreateDirectory("$broken\.git");[IO.File]::WriteAllText("$broken\.git\HEAD",'not a repository');[IO.File]::WriteAllText("$broken\data.txt",'kept')
       $modules=Join-Path $t 'ORVION-Sandbox\evidence\node_modules\pkg';[void][IO.Directory]::CreateDirectory($modules);[IO.File]::WriteAllText("$modules\x.js",'regenerable')
   ```
   with
   ```text
       Invoke-Quiet $crm stash clear|Out-Null
   ```

   q) replace the line
   ```text
       $planted='ghp_'+-join((48..57)+(65..90)+(97..122)|Get-Random -Count 36|ForEach-Object{[char]$_});[IO.File]::WriteAllText((Join-Path $t 'ORVION-Sandbox\evidence\leak.txt'),"token=$planted")
   ```
   with
   ```text
       $planted='ghp_'+-join((48..57)+(65..90)+(97..122)|Get-Random -Count 36|ForEach-Object{[char]$_});[IO.File]::WriteAllText((Join-Path $gh 'ORVION-Owner-Tools/records/leak.txt'),"token=$planted")
       $savedPackageTemporaryRoot=$env:WORKBENCH_TEMP_ROOT;$env:WORKBENCH_TEMP_ROOT=$pkgTemp
   ```

   r) replace the line
   ```text
           Assert-That 'package destination holds archive, scan, hash and both launchers; staging is removed' (@(Get-ChildItem $cloud -Force).Count-eq5-and(Test-Path $scan)-and$archive-and@(Get-ChildItem $pkgTemp -Force).Count-eq0-and($pkg-join' ')-match'PACKAGE: .*unencrypted'-and[IO.File]::ReadAllText("$archive.sha256").Trim()-ceq((Get-FileHash $archive).Hash+' *'+(Split-Path $archive -Leaf))-and(Get-FileHash "$cloud\Restore-ORVION.cmd").Hash-ceq(Get-FileHash "$lib\Restore-ORVION.cmd").Hash-and(Get-FileHash "$cloud\Restore-ORVION.ps1").Hash-ceq(Get-FileHash "$lib\Restore-ORVION.ps1").Hash)
   ```
   with
   ```text
           Assert-That 'package destination holds archive, scan, hash and both launchers; staging is removed' (@(Get-ChildItem $cloud -Force).Count-eq5-and(Test-Path $scan)-and$archive-and@(Get-ChildItem (Join-Path $pkgTemp 'tmp') -Force).Count-eq0-and($pkg-join' ')-match'PACKAGE: .*unencrypted'-and[IO.File]::ReadAllText("$archive.sha256").Trim()-ceq((Get-FileHash $archive).Hash+' *'+(Split-Path $archive -Leaf))-and(Get-FileHash "$cloud\Restore-ORVION.cmd").Hash-ceq(Get-FileHash "$lib\Restore-ORVION.cmd").Hash-and(Get-FileHash "$cloud\Restore-ORVION.ps1").Hash-ceq(Get-FileHash "$lib\Restore-ORVION.ps1").Hash)
   ```

   s) replace the line
   ```text
               Assert-That "failed package $operation writes no hash or launcher; existing files untouched" ($failedCode-ne0-and($failedPackage-join' ')-match'PACKAGE_(VERIFY_)?FAILED'-and@((Get-ChildItem -LiteralPath $failedCloud -Filter *.sha256)).Count-eq0-and[IO.File]::ReadAllText((Join-Path $failedCloud 'Restore-ORVION.cmd'))-ceq'keep existing bytes'-and[IO.File]::ReadAllText((Join-Path $failedCloud 'Restore-ORVION.ps1'))-ceq'keep existing bytes'-and[IO.File]::ReadAllText((Join-Path $failedCloud 'unrelated.txt'))-ceq'keep existing bytes'-and@(Get-ChildItem $pkgTemp -Force).Count-eq0)
   ```
   with
   ```text
               Assert-That "failed package $operation writes no hash or launcher; existing files untouched" ($failedCode-ne0-and($failedPackage-join' ')-match'PACKAGE_(VERIFY_)?FAILED'-and@((Get-ChildItem -LiteralPath $failedCloud -Filter *.sha256)).Count-eq0-and[IO.File]::ReadAllText((Join-Path $failedCloud 'Restore-ORVION.cmd'))-ceq'keep existing bytes'-and[IO.File]::ReadAllText((Join-Path $failedCloud 'Restore-ORVION.ps1'))-ceq'keep existing bytes'-and[IO.File]::ReadAllText((Join-Path $failedCloud 'unrelated.txt'))-ceq'keep existing bytes'-and@(Get-ChildItem (Join-Path $pkgTemp 'tmp') -Force).Count-eq0)
   ```

   t) replace the line
   ```text
               Assert-That 'secret scan names the planted token by rule and path, never its value' ([IO.File]::ReadAllText($scan)-match'github-pat  legacy/ORVION-Sandbox/evidence/leak\.txt:1'-and[IO.File]::ReadAllText($scan)-notmatch$planted-and($pkg-join' ')-notmatch$planted-and($pkg-join' ')-match'SECRET SCAN: [1-9]')
   ```
   with
   ```text
               Assert-That 'secret scan names the planted token by rule and path, never its value' ([IO.File]::ReadAllText($scan)-match'github-pat  owner-tools/records/leak\.txt:1'-and[IO.File]::ReadAllText($scan)-notmatch$planted-and($pkg-join' ')-notmatch$planted-and($pkg-join' ')-match'SECRET SCAN: [1-9]')
   ```

   u) replace the lines
   ```text
           }else{Assert-That 'without gitleaks the scan is reported as skipped' (($pkg-join' ')-match'SECRET SCAN: SKIPPED'-and[IO.File]::ReadAllText($scan)-match'SKIPPED')}
           $stashy=Join-Path $t 'ORVION-Sandbox\evidence\c3';& git clone -q $remote $stashy 2>&1|Out-Null;foreach($i in 1,2){Set-Content "$stashy\a.txt" "stash $i";Invoke-Quiet $stashy stash -q|Out-Null}
           $stashed=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination (Join-Path $t 'cloud4') -RecoveryInputs $inputs -Package 2>&1)
           Assert-That 'a nested clone with older stash entries refuses instead of losing them' ($LASTEXITCODE-ne0-and($stashed-join' ')-match'BACKUP_NESTED_STASHES_NOT_PRESERVABLE'-and!(Test-Path (Join-Path $t 'cloud4')))
           Get-ChildItem $stashy -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($stashy,$true)
           $collide=Join-Path $t 'ORVION-Sandbox\evidence\c4';& git clone -q $remote $collide 2>&1|Out-Null;Add-Content "$collide\.git\info\exclude" '.clone-state/';[void][IO.Directory]::CreateDirectory("$collide\.clone-state");[IO.File]::WriteAllText("$collide\.clone-state\state.json",'original evidence')
           $collided=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination (Join-Path $t 'cloud5') -RecoveryInputs $inputs -Package 2>&1)
           Assert-That 'a source .clone-state name refuses instead of being overwritten by metadata' ($LASTEXITCODE-ne0-and($collided-join' ')-match'BACKUP_CLONE_STATE_NAME_COLLISION'-and!(Test-Path (Join-Path $t 'cloud5')))
           Get-ChildItem $collide -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($collide,$true)
           $merge=Join-Path $t 'ORVION-Sandbox\evidence\c5';& git clone -q $remote $merge 2>&1|Out-Null
           Invoke-Quiet $merge checkout -q -b side|Out-Null;Set-Content "$merge\a.txt" 'side';Invoke-Quiet $merge commit -q -am side|Out-Null;Invoke-Quiet $merge checkout -q main|Out-Null;Set-Content "$merge\a.txt" 'main';Invoke-Quiet $merge commit -q -am main|Out-Null
           & git -C $merge -c user.name=t -c user.email=t@t merge -q side 2>&1|Out-Null
           $unmerged=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination (Join-Path $t 'cloud6') -RecoveryInputs $inputs -Package 2>&1)
           Assert-That 'an unresolved nested merge refuses instead of saving an unappliable patch' ($LASTEXITCODE-ne0-and($unmerged-join' ')-match'BACKUP_NESTED_UNMERGED_NOT_PRESERVABLE'-and!(Test-Path (Join-Path $t 'cloud6')))
           Get-ChildItem $merge -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($merge,$true)
   ```
   with
   ```text
           }else{Assert-That 'without gitleaks the scan is reported as skipped' (($pkg-join' ')-match'SECRET SCAN: SKIPPED'-and[IO.File]::ReadAllText($scan)-match'SKIPPED')}
   ```

   v) replace the line
   ```text
           Assert-That 'a damaged archive refuses before any restore target and leaves no staging' ($LASTEXITCODE-ne0-and($wrong-join' ')-match'PACKAGE_EXTRACT_FAILED'-and!(Test-Path (Join-Path $t 'pkg-wrong'))-and@(Get-ChildItem $pkgTemp -Force).Count-eq0)
   ```
   with
   ```text
           Assert-That 'a damaged archive refuses before any restore target and leaves no staging' ($LASTEXITCODE-ne0-and($wrong-join' ')-match'PACKAGE_EXTRACT_FAILED'-and!(Test-Path (Join-Path $t 'pkg-wrong'))-and@(Get-ChildItem (Join-Path $pkgTemp 'tmp') -Force).Count-eq0)
   ```

   w) replace the line
   ```text
           Assert-That 'package restore leaves no plaintext staging and rebuilds the exact source HEAD' (@(Get-ChildItem $pkgTemp -Force).Count-eq0-and(& git -C "$pkgTarget/ORVION-Workbench" rev-parse HEAD)-ceq(& git -C $wb rev-parse HEAD))
   ```
   with
   ```text
           Assert-That 'package restore leaves no plaintext staging and rebuilds the exact source HEAD' (@(Get-ChildItem (Join-Path $pkgTemp 'tmp') -Force).Count-eq0-and(& git -C "$pkgTarget/ORVION-Workbench" rev-parse HEAD)-ceq(& git -C $wb rev-parse HEAD))
   ```

   x) replace the lines
   ```text
           $restoredClone=Join-Path $pkgDocs 'ORVION-Sandbox\evidence\c1';$state=Join-Path $restoredClone '.clone-state'
           Assert-That 'nested clone keeps ignored receipt and evidence, staged and worktree changes apart, untracked file, but not node_modules' ([IO.File]::ReadAllText("$restoredClone\.workbench-certifications\r.json")-ceq'{"nested":"receipt"}'-and[IO.File]::ReadAllText("$restoredClone\evidence-out\approval.txt")-ceq'ignored evidence'-and[IO.File]::ReadAllText("$state\staged.diff")-match'\+staged'-and[IO.File]::ReadAllText("$state\worktree.diff")-match'\+dirty'-and(Test-Path "$state\untracked\new.txt")-and!(Test-Path (Join-Path $pkgDocs 'ORVION-Sandbox\evidence\node_modules'))-and!(Test-Path "$restoredClone\node_modules")-and!(Test-Path "$state\untracked\node_modules"))
           Assert-That 'git stderr warnings (CRLF) are not counted as unmerged or dirty entries' ($crlfWarned-and(Test-Path (Join-Path $pkgDocs 'ORVION-Sandbox\evidence\c7\.clone-state\worktree.diff')))
           Assert-That 'a broken .git folder is not a clone: its files are kept, not skipped' ([IO.File]::ReadAllText((Join-Path $pkgDocs 'ORVION-Sandbox\evidence\broken\data.txt'))-ceq'kept'-and[IO.File]::ReadAllText((Join-Path $pkgDocs 'ORVION-Sandbox\evidence\broken\.git\HEAD'))-ceq'not a repository')
           $rebuilt=Join-Path $t 'rebuilt-c1';& git clone -q $remote $rebuilt 2>&1|Out-Null
           Invoke-Quiet $rebuilt fetch -q "$state\unique.bundle" 'refs/heads/*:refs/restored/*'|Out-Null
           Assert-That 'unique commit absent from every main repository is recoverable from its bundle on top of a main repository' ((Invoke-Quiet $rebuilt rev-parse refs/restored/main).Trim()-ceq$uniqueHead)
           Invoke-Quiet $rebuilt fetch -q (Join-Path $pkgDocs 'ORVION-Sandbox\evidence\c2\.clone-state\unique.bundle') HEAD|Out-Null
           Assert-That 'a linked worktree inside the evidence tree keeps its own uncommitted change' ([IO.File]::ReadAllText((Join-Path $pkgDocs 'ORVION-Sandbox\evidence\wt\.clone-state\worktree.diff'))-match'\+worktree change')
           Assert-That 'a unique commit on a detached HEAD is bundled and recoverable' ((Invoke-Quiet $rebuilt rev-parse FETCH_HEAD).Trim()-ceq$detachedHead)
       }finally{$env:TEMP=$savedTemp;$env:TMP=$savedTmp}
   ```
   with
   ```text
           Assert-That 'new package does not recreate legacy destinations' (!(Test-Path $pkgDocs)-and!(Test-Path "$pkgTarget/ORVION-Recovery-Inputs"))
       }finally{$env:WORKBENCH_TEMP_ROOT=$savedPackageTemporaryRoot;$env:TEMP=$savedTemp;$env:TMP=$savedTmp}
   ```

   y) replace the line
   ```text
       $env:ORVION_DATA_ROOT=$savedDataRoot;$env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem;$env:USERPROFILE=$previousProfile;Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)
   ```
   with
   ```text
       $env:WORKBENCH_TEMP_ROOT=$savedTemporaryRoot;$env:ORVION_DATA_ROOT=$savedDataRoot;$env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem;$env:USERPROFILE=$previousProfile;Get-ChildItem -LiteralPath $t -Recurse -Force -Attributes ReparsePoint|ForEach-Object{[IO.Directory]::Delete($_.FullName,$false)};Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)
   ```

   The resulting file's Git blob is 754b870715c378cec0efc0b6d5371764029ea9d3.

23. Check whether `lib/test-coordinator.ps1` contains `$mutant=Join-Path $auxLib 'Coordinator-mutant.ps1'  # beside the copied Sync-Sessions.ps1 it loads`; if so record Already Applied when its Git blob is 6a25f6c3482ec46be317b14e299dfb9e3114e0b4, and otherwise stop and report. Otherwise make exactly these 2 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
       $auxLib=Join-Path $t 'aux-lib';New-Item -ItemType Directory $auxLib|Out-Null;Copy-Item $co $auxLib
   ```
   with
   ```text
       $auxLib=Join-Path $t 'aux-lib';New-Item -ItemType Directory $auxLib|Out-Null;Copy-Item $co,(Join-Path $PSScriptRoot 'Sync-Sessions.ps1') $auxLib  # Coordinator masks with the archive's rules
   ```

   b) replace the line
   ```text
       $mutant=Join-Path $t 'Coordinator-mutant.ps1'
   ```
   with
   ```text
       $mutant=Join-Path $auxLib 'Coordinator-mutant.ps1'  # beside the copied Sync-Sessions.ps1 it loads
   ```

   The resulting file's Git blob is 6a25f6c3482ec46be317b14e299dfb9e3114e0b4.

24. Check whether `lib/test-events.ps1` contains `@{name='dot invoked own function';code='function Read-First { $Token=1 }; . Read-First; $token=2';count=1},`; if so record Already Applied when its Git blob is 079e1c877aedb16298c250b6ddcec1c18b607128, and otherwise stop and report. Otherwise make exactly these 4 edits (One clean layout only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
               @{name='dot sourced block';code='function Read-First { $Token=1; . { $token=2 } }';count=1},
   ```
   insert
   ```text
               @{name='dot invoked own function';code='function Read-First { $Token=1 }; . Read-First; $token=2';count=1},
               @{name='one function dot invoked from two scopes';code='function Read-Shared { $x=1 }; function Read-First { . Read-Shared }; function Read-Second { . Read-Shared }';count=1},
               @{name='dot invocation joins only its own function';code='function Read-First { $Token=1 }; function Read-Second { $token=2 }; function Invoke-LocalDot { $x=1 }; . Invoke-LocalDot';count=0},
   ```

   b) immediately after the line
   ```text
           Assert-That 'evidence-only correction is appended and an identical correction is deduplicated' ($corrected-match'EVENT RECORDED'-and$repeated-match'EVENT DUPLICATE'-and$evidenceRows.Count-eq2-and$evidenceRows[-1].evidence-ceq'work\correct.log'-and$evidenceRows[0].evidence-ceq'work\wrong.log')
   ```
   insert
   ```text
           $cycle=Join-Path $t 'cycle'
           foreach($summary in 'A','B','A'){$null=& $ev -Root $cycle -Add -Pattern cycle -Session s -Summary $summary -At ([datetime]'2026-01-01T00:00:00Z') -Repo fixture}
           $null=& $ev -Root $cycle -Add -Pattern cycle -Session s -Summary A -At ([datetime]'2026-01-01T00:00:00Z') -Repo fixture -Category failure
           $null=& $ev -Root $cycle -Add -Pattern cycle -Session other -Summary A -At ([datetime]'2026-01-01T00:00:00Z') -Repo fixture -Category failure
           $cycleRows=@([IO.File]::ReadAllLines((Join-Path $cycle 'events/events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json})
           Assert-That 'current tied row, material category and session recurrence' ($cycleRows.Count-eq5-and$cycleRows[2].summary-ceq'A')
           $found=@(& $ev -Root $cycle -Find cycle -Repo fixture)-join' '
           $absent=@(& $ev -Root $cycle -Find cycle -Repo other)-join' '
           Assert-That 'Find filters repository before grouping' ($found-match'cycle'-and$absent-match'nothing recorded')
           # Real journals name repositories loosely: lists, owner/repo, and "Workbench" for ORVION-Workbench.
           $aliases=Join-Path $t 'aliases'
           foreach($row in @(@('pair','CRM,ORVION'),@('slug','Shehabhub/ORVION-Workbench'),@('short','Workbench'))){$null=& $ev -Root $aliases -Add -Pattern $row[0] -Session s -Summary $row[0] -Repo $row[1]}
           $orvion=@(& $ev -Root $aliases -Find 'pair slug short' -Repo ORVION)-join' ';$wb=@(& $ev -Root $aliases -Find 'pair slug short' -Repo Workbench)-join' '
           Assert-That 'Repo filter matches list members, owner/repo slugs and the Workbench alias' ($orvion-match'pair'-and$orvion-notmatch'slug|short'-and$wb-match'slug'-and$wb-match'short'-and$wb-notmatch'pair')
           $bySlug=@(& $ev -Root $aliases -Find 'pair slug short' -Repo 'Shehabhub/ORVION-Workbench')-join' '
           Assert-That 'an owner/repo selector matches its own stored slug and alias' ($bySlug-match'slug'-and$bySlug-match'short'-and$bySlug-notmatch'pair')
           # The repository is part of the fact: the same note for another repository is recorded, not a duplicate.
           $first=& $ev -Root $aliases -Add -Pattern per-repo -Session s -Summary same -Repo CRM
           $second=& $ev -Root $aliases -Add -Pattern per-repo -Session s -Summary same -Repo ORVION
           $orvionOnly=@(& $ev -Root $aliases -Find 'per repo' -Repo ORVION)-join' '
           Assert-That 'dedupe includes the repository' ($first-match'EVENT RECORDED'-and$second-match'EVENT RECORDED'-and$orvionOnly-match'per-repo')
           $tokenShape='ghp_'+('A1b2C3d4E5'*4).Substring(0,36)  # the real GitHub token length the masking rule recognizes
           $null=& $ev -Root $aliases -Add -Pattern leaked-note -Session s -Summary "saw $tokenShape" -Action "rotate $tokenShape" -Repo CRM
           $shown=@(& $ev -Root $aliases -Find 'leaked note')-join' '
           Assert-That 'Find output masks credential shapes in every field' ($shown-match'leaked-note: saw <masked>'-and!$shown.Contains('ghp_'))
           # Diagnostics name paths: a token-shaped data root never prints intact (missing and damaged journals).
           $tokenRoot=Join-Path $t $tokenShape
           $missingOut=@(& pwsh -NoProfile -File $ev -Root $tokenRoot -Find 'anything')-join' '
           [void][IO.Directory]::CreateDirectory((Join-Path $tokenRoot 'events'));[IO.File]::WriteAllText((Join-Path $tokenRoot 'events/events.jsonl'),"{torn`n")
           $damagedOut=@(& pwsh -NoProfile -File $ev -Root $tokenRoot -Brief)-join' '
           Assert-That 'unavailable and incomplete diagnostics mask a token-shaped root' ($missingOut-match'EVENTS_UNAVAILABLE'-and$damagedOut-match'EVENTS_INCOMPLETE'-and!($missingOut+$damagedOut).Contains('ghp_'))
           $here=@(Push-Location $t;try{git init -q 'repo-auto' 2>&1|Out-Null;Push-Location 'repo-auto';try{& $ev -Root $aliases -Add -Pattern auto-repo -Session s -Summary auto}finally{Pop-Location}}finally{Pop-Location})
           $autoRow=@([IO.File]::ReadAllLines((Join-Path $aliases 'events/events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json}|Where-Object{$_.pattern-eq'auto-repo'})
           Assert-That 'Add fills Repo from the current git root' ($here-match'EVENT RECORDED'-and$autoRow.Count-eq1-and$autoRow[0].repo-ceq'repo-auto')
   ```

   c) replace the line
   ```text
       $expression='$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw ''ORVION_DATA_ROOT_NOT_ABSOLUTE''};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace''[\\/]hooks$'','''') -Parent) -Parent) ''ORVION-Owner-Tools'')|Where-Object{Test-Path -LiteralPath (Join-Path $_ ''events'')})+@(Split-Path ($PSScriptRoot-replace''[\\/]hooks$'','''') -Parent))[0]})'
   ```
   with
   ```text
       $expression='$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw ''ORVION_DATA_ROOT_NOT_ABSOLUTE''};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace''[\\/]hooks$'','''') -Parent) -Parent) ''ORVION-Owner-Tools''})'
   ```

   d) replace the line
   ```text
       $gh=Join-Path $t 'gh';$copy=Join-Path $gh 'ORVION-Workbench\lib';[void][IO.Directory]::CreateDirectory($copy);Copy-Item $ev $copy
   ```
   with
   ```text
       $gh=Join-Path $t 'gh';$copy=Join-Path $gh 'ORVION-Workbench\lib';[void][IO.Directory]::CreateDirectory($copy);Copy-Item $ev,(Join-Path $PSScriptRoot 'Sync-Sessions.ps1') $copy  # Events masks with the archive's rules
   ```

   The resulting file's Git blob is 079e1c877aedb16298c250b6ddcec1c18b607128.

25. Check whether `lib/test-hunt.ps1` contains `$savedTemporaryRoot=$env:WORKBENCH_TEMP_ROOT;$savedTemp=$env:TEMP;$savedTmp=$env:TMP;$env:WORKBENCH_TEMP_ROOT=$t+'-managed'`; if so record Already Applied when its Git blob is 5432ff2270dd81af62a1e4eb481567d4817d8a41, and otherwise stop and report. Otherwise make exactly these 6 edits (One clean layout only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $t=Join-Path ([IO.Path]::GetTempPath()) "orvion-huntcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t|Out-Null
   ```
   insert
   ```text
   $savedTemporaryRoot=$env:WORKBENCH_TEMP_ROOT;$savedTemp=$env:TEMP;$savedTmp=$env:TMP;$env:WORKBENCH_TEMP_ROOT=$t+'-managed'
   ```

   b) immediately after the line
   ```text
           Assert-That 'partial index saves its result and NoRecord preserves the journal' ((Test-Path (Join-Path $indexStore 'work/hunt-last.txt'))-and(Get-FileHash $indexJournal).Hash-ceq$indexHash)
   ```
   insert
   ```text
           # The repository map refreshes itself only while its scheduled task exists and last succeeded.
           $mapLauncher=Join-Path $t 'map-probe.ps1'
           [IO.File]::WriteAllText($mapLauncher,@'
   param([string]$Hunt,[string]$Store,[string]$Mode)
   function Get-Process { @() }
   function Get-CimInstance { @() }
   $task=switch($Mode){'missing'{{throw 'no task'}}'failed'{{[pscustomobject]@{LastTaskResult=1}}}default{{[pscustomobject]@{LastTaskResult=0}}}}
   & $Hunt -Root $Store -DataRoot $Store -Quick -NoRecord -GetMapTask $task
   exit $LASTEXITCODE
   '@)
           $mapSeen=@{}
           foreach($mode in 'missing','failed','ok'){$mapSeen[$mode]=(@(& pwsh -NoProfile -File $mapLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $indexStore -Mode $mode 2>&1)-join"`n")-match'GAP map-task'}
           Assert-That 'map task missing or failed is a GAP; a healthy task is not' ($mapSeen.missing-and$mapSeen.failed-and!$mapSeen.ok)
   ```

   c) replace the line
   ```text
           foreach($case in 'sibling','override','explicit','fallback'){
   ```
   with
   ```text
           foreach($case in 'sibling','override','explicit'){
   ```

   d) replace the lines
   ```text
               if($case-eq'fallback'){$null=Remove-OrvionOwnedTree -Path $sibling -AllowedRoots @($t)}else{[void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))}
               $expected=if($case-eq'explicit'){$env:ORVION_DATA_ROOT=$override;$explicit}elseif($case-eq'override'){$env:ORVION_DATA_ROOT=$override+'\';$override}elseif($case-eq'sibling'){$sibling}else{$checkout}
   ```
   with
   ```text
               [void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))
               $expected=if($case-eq'explicit'){$env:ORVION_DATA_ROOT=$override;$explicit}elseif($case-eq'override'){$env:ORVION_DATA_ROOT=$override+'\';$override}else{$sibling}
   ```

   e) replace the line
   ```text
               Assert-That "hunt $case records findings and last result only in data root" ((Test-Path (Join-Path $expected 'work\hunt-last.txt'))-and@($rootEvents|Where-Object pattern -eq 'hunt-sync-errors').Count-gt0-and$closed.status-eq'resolved'-and($case-eq'fallback'-or!(Test-Path (Join-Path $checkout 'work'))))
   ```
   with
   ```text
               Assert-That "hunt $case records findings and last result only in data root" ((Test-Path (Join-Path $expected 'work\hunt-last.txt'))-and@($rootEvents|Where-Object pattern -eq 'hunt-sync-errors').Count-gt0-and$closed.status-eq'resolved'-and!(Test-Path (Join-Path $checkout 'work')))
   ```

   f) replace the line
   ```text
   }finally{$env:USERPROFILE=$savedProfile;$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}
   ```
   with
   ```text
   }finally{$env:WORKBENCH_TEMP_ROOT=$savedTemporaryRoot;$env:TEMP=$savedTemp;$env:TMP=$savedTmp;$env:USERPROFILE=$savedProfile;$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath());if(Test-Path ($t+'-managed')){$null=Remove-OrvionOwnedTree -Path ($t+'-managed') -AllowedRoots @([IO.Path]::GetTempPath())}}
   ```

   The resulting file's Git blob is 5432ff2270dd81af62a1e4eb481567d4817d8a41.

26. Check whether `lib/test-map-repos.ps1` contains `[void](New-Repo 'ORVION-Workbench-temporary' @{'README.m`; if so record Already Applied when its Git blob is 0a9f5f1ba28abb883a131f78c2920bc8fdea009b, and otherwise stop and report. Otherwise make exactly these 2 edits (One clean layout only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       [void](New-Repo 'RepoB' @{'notes.md'="# Notes`nBack to [guide](../RepoA/docs/guide.md).`n"})
   ```
   insert
   ```text
       [void](New-Repo 'ORVION-Workbench-temporary' @{'README.md'="# disposable`n"})
   ```

   b) replace the line
   ```text
       Assert-That 'discovers repositories, skips trusted copies, reports unborn and broken ones without failing' ((@($m.repos.name)-join',')-ceq'RepoA,RepoB,RepoD'-and@($m.problems|Where-Object{$_.repo-ceq'RepoD'-and$_.problem-match'no commits'}).Count-eq1-and@($m.problems|Where-Object{$_.repo-ceq'RepoE'}).Count-eq1)
   ```
   with
   ```text
       Assert-That 'discovers repositories, skips trusted and temporary copies, reports unborn and broken ones without failing' ((@($m.repos.name)-join',')-ceq'RepoA,RepoB,RepoD'-and@($m.problems|Where-Object{$_.repo-ceq'RepoD'-and$_.problem-match'no commits'}).Count-eq1-and@($m.problems|Where-Object{$_.repo-ceq'RepoE'}).Count-eq1)
   ```

   The resulting file's Git blob is 0a9f5f1ba28abb883a131f78c2920bc8fdea009b.

27. Check whether `lib/test-markdown-consistency.ps1` contains `param([string]$Guard=(Join-Path $PSScriptRoot 'Test-MarkdownConsistency.ps1'),[switch]$NoMutants,[string]$Case,[string]$RepositoryTree='Working')`; if so record Already Applied when its Git blob is 9ddde5f1184eae7b1ae270c88bf081e29a8a1a7d, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (One clean layout only), and change nothing else:

   ```text
   param([string]$Guard=(Join-Path $PSScriptRoot 'Test-MarkdownConsistency.ps1'),[switch]$NoMutants,[string]$Case,[string]$RepositoryTree='Working')
   $ErrorActionPreference='Stop'
   . $Guard
   . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   $parent=if($env:WORKBENCH_TEST_ROOT){$env:WORKBENCH_TEST_ROOT}else{$env:TEMP}
   if(![IO.Path]::IsPathFullyQualified($parent)){throw 'MD_TEST_ROOT_REQUIRED'}
   $scratch=Join-Path $parent ('md-'+[guid]::NewGuid().ToString('N').Substring(0,8))
   [void][IO.Directory]::CreateDirectory($scratch)
   $script:passed=0;$nl=[string][char]10
   function Write-MarkdownFixture([string]$Path,[string]$Text){
       [void][IO.Directory]::CreateDirectory((Split-Path $Path -Parent))
       [IO.File]::WriteAllText($Path,$Text,[Text.UTF8Encoding]::new($false))
   }
   function Invoke-MarkdownFixtureGit([string]$Directory,[string[]]$Arguments){
       [Text.Encoding]::UTF8.GetString((Invoke-MarkdownGit $Directory $Arguments)).Trim()
   }
   function New-MarkdownFixture([string]$Name){
       $fixture=Join-Path $scratch $Name;[void][IO.Directory]::CreateDirectory($fixture)
       $null=Invoke-MarkdownFixtureGit $fixture @('init','--quiet')
       $seed=[ordered]@{
           'AGENTS.md'="# Arrival$nl[Start](README.md)$nl"
           'README.md'="# Purpose$nl[Governance](WORKFLOW.md) [Resume](RESUME.md) [Closure](HANDOFF.md) [Guide](docs/guide.md#section) [external](../ORVION-Owner-Tools/STATE.md) [private](C:/private/missing.md)$nl"
           'RESUME.md'="Active Workbench Contract: None${nl}Live state: ../ORVION-Owner-Tools/STATE.md$nl"
           'HANDOFF.md'="# Closure$nl${nl}Unique closure boundary.$nl"
           'docs/EXECUTION-PLAN.md'="# Plan$nl${nl}Only this file describes the sequence.$nl"
           'docs/WORKSPACE-LAYOUT.md'="# Layout$nl${nl}Only this file describes storage.$nl"
           'docs/RECOVERY.md'="# Recovery$nl${nl}Only this file describes recovery.$nl"
           'lib/README.md'="# Tools$nl${nl}Only this file describes tools.$nl"
           'changes/TEMPLATE.md'="# Template$nl${nl}Only this file describes new proposals.$nl"
           'docs/guide.md'="# Guide$nl## Section$nl[back](../README.md#purpose)$nl"
           'changes/WS-001-history.md'="# Frozen history$nl[original packet](not-here.md)$nl"
           'docs/history/archive.md'="# Frozen archive${nl}Run Documents\ORVION-Sandbox\old.ps1 (source-bound historical instruction).$nl"
           'WORKFLOW.md'=@'
   # Governance

   ## One-home table

   | Concept | Sole home |
   |---|---|
   | Arrival | [arrival](AGENTS.md#arrival) |
   | Purpose | [purpose](README.md#purpose) |
   | Active contract | [pointer](RESUME.md) |
   | Batch 6 closure | [closure](HANDOFF.md#closure) |
   | Governance | [governance](WORKFLOW.md#governance) |
   | Programme plan | [plan](docs/EXECUTION-PLAN.md#plan) |
   | Workspace layout | [layout](docs/WORKSPACE-LAYOUT.md#layout) |
   | Recovery | [recovery](docs/RECOVERY.md#recovery) |
   | Tool catalogue | [tools](lib/README.md#tools) |
   | Contract template | [template](changes/TEMPLATE.md#template) |

   ## History index

   - [contract](changes/WS-001-history.md)
   - [archive](docs/history/archive.md)
   '@
       }
       foreach($path in $seed.Keys){Write-MarkdownFixture (Join-Path $fixture $path) $seed[$path]}
       return $fixture
   }
   function Edit-MarkdownFixture([string]$Directory,[string]$Path,[string]$Before,[string]$After){
       $absolute=Join-Path $Directory $Path;$text=[IO.File]::ReadAllText($absolute)
       if(!$text.Contains($Before)){throw "MD_FIXTURE_ANCHOR: $Path"}
       Write-MarkdownFixture $absolute ($text.Replace($Before,$After))
   }
   $cases=[ordered]@{
       positive=@('',{})
       empty=@('MD_INPUT_EMPTY',{param($directory) Write-MarkdownFixture (Join-Path $directory 'docs/guide.md') ''})
       unreadable=@('Exception|Could not|cannot|denied|MD_INPUT',{param($directory) [IO.File]::Delete((Join-Path $directory 'docs/guide.md'))})
       orphan=@('MD_ORPHAN',{param($directory) Write-MarkdownFixture (Join-Path $directory 'docs/unlinked.md') '# Unlinked'})
       missingLink=@('MD_LINK_MISSING',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '../README.md#purpose' 'README.md#purpose'})
       missingAnchor=@('MD_ANCHOR_MISSING',{param($directory) Edit-MarkdownFixture $directory 'README.md' '#section' '#absent'})
       duplicateHeading=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '## Section' ('## Section'+$nl+'## Section'+$nl+'[second](#section-1)')})
       unicodeAnchor=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '## Section' ('## Section'+$nl+'## Café 旅行!'+$nl+'[Unicode](#caf%C3%A9-%E6%97%85%E8%A1%8C)')})
       referenceLinks=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '[back](../README.md#purpose)' ('[back][root]'+$nl+$nl+'[root]: ../README.md#purpose')})
       referenceMissing=@('MD_REFERENCE_MISSING',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '[back](../README.md#purpose)' '[back][absent]'})
       angleLink=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '[back](../README.md#purpose)' '[back](<../README.md#purpose>)'})
       percentPath=@('',{param($directory) Write-MarkdownFixture (Join-Path $directory 'docs/space Café.md') '# Fine';Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[space](space%20Caf%C3%A9.md#fine)')})
       nestedPath=@('',{param($directory) Write-MarkdownFixture (Join-Path $directory 'docs/a(b(c)).md') '# Fine';Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[nested](a(b(c)).md#fine)')})
       invalidUtf8=@('Unable to translate|MD_INPUT',{param($directory) [IO.File]::WriteAllBytes((Join-Path $directory 'docs/guide.md'),[byte[]]@(195))})
       anchorCase=@('MD_ANCHOR_MISSING',{param($directory) Edit-MarkdownFixture $directory 'README.md' '#section' '#Section'})
       pathCase=@('MD_LINK_MISSING',{param($directory) Edit-MarkdownFixture $directory 'README.md' 'docs/guide.md' 'docs/Guide.md'})
       historyByName=@('',{param($directory) Write-MarkdownFixture (Join-Path $directory 'changes/WS-002-new.md') '# New contract'})
       changesStray=@('MD_ORPHAN',{param($directory) Write-MarkdownFixture (Join-Path $directory 'changes/notes.md') '# Stray notes'})
       historyDuplicate=@('MD_HISTORY_ENTRY',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '- [contract](changes/WS-001-history.md)' ('- [contract](changes/WS-001-history.md)'+$nl+'- [again](changes/WS-001-history.md)')})
       historyAbsent=@('MD_HISTORY_ENTRY',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' 'changes/WS-001-history.md' 'changes/WS-999-missing.md'})
       historySmuggling=@('MD_HISTORY_ENTRY',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '- [archive](docs/history/archive.md)' ('- [archive](docs/history/archive.md)'+$nl+'- [living](docs/guide.md)')})
       historyIndexDuplicate=@('MD_HISTORY_INDEX',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '## History index' ('## History index'+$nl+$nl+'## History index')})
       historyFormat=@('MD_HISTORY_FORMAT',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '- [archive](docs/history/archive.md)' 'docs/history/archive.md'})
       homeMissing=@('MD_HOME_MISSING',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '| Arrival | [arrival](AGENTS.md#arrival) |' ''})
       homeDuplicate=@('MD_HOME_ROW',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '| Arrival | [arrival](AGENTS.md#arrival) |' ('| Arrival | [arrival](AGENTS.md#arrival) |'+$nl+'| Arrival | [arrival](AGENTS.md#arrival) |')})
       homeTarget=@('MD_ANCHOR_MISSING',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' 'AGENTS.md#arrival' 'AGENTS.md#absent'})
       homeOwner=@('MD_HOME_OWNER',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' 'AGENTS.md#arrival' 'README.md#purpose'})
       homeTableDuplicate=@('MD_HOME_TABLE',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '## One-home table' ('## One-home table'+$nl+$nl+'## One-home table')})
       homeFormat=@('MD_HOME_FORMAT',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '| Concept | Sole home |' ('| Concept | Sole home |'+$nl+'| Extra | malformed |')})
       pointer=@('MD_POINTER_HOME',{param($directory) Edit-MarkdownFixture $directory 'HANDOFF.md' 'Unique closure boundary.' 'Active Workbench Contract: None'})
       pointerFence=@('MD_POINTER_HOME',{param($directory) Edit-MarkdownFixture $directory 'HANDOFF.md' 'Unique closure boundary.' ('~~~text'+$nl+'Active Workbench Contract: None'+$nl+'~~~')})
       budget=@('MD_BUDGET',{param($directory) Edit-MarkdownFixture $directory 'AGENTS.md' '# Arrival' ('# Arrival '+('word '*101))})
       duplicate=@('MD_DUPLICATE_PROSE',{param($directory) $prose=1..25-join' ';foreach($path in @('HANDOFF.md','docs/guide.md')){Write-MarkdownFixture (Join-Path $directory $path) ([IO.File]::ReadAllText((Join-Path $directory $path))+$nl+$nl+$prose)}})
       fenceExclusion=@('',{param($directory) $prose=1..25-join' ';foreach($path in @('HANDOFF.md','docs/guide.md')){Write-MarkdownFixture (Join-Path $directory $path) ([IO.File]::ReadAllText((Join-Path $directory $path))+$nl+$nl+'~~~text'+$nl+$prose+$nl+'[missing](no.md)'+$nl+'~~~'+$nl)}})
       contractExclusion=@('',{param($directory) $prose=1..25-join' ';foreach($path in @('changes/WS-001-history.md','docs/history/archive.md')){Write-MarkdownFixture (Join-Path $directory $path) ([IO.File]::ReadAllText((Join-Path $directory $path))+$nl+$nl+$prose)}})
       staleDate=@('MD_STALE_DATE',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Updated 2026-10-20'+$nl+$nl+'Amended 2026-10-27')})
       currentDate=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Version 2 | 2026-10-27 | Selected'+$nl+$nl+'Amended 2026-10-27')})
       retired=@('MD_RETIRED_ROUTE',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Run Documents\ORVION-Sandbox\old.ps1')})
       retiredFence=@('MD_RETIRED_ROUTE',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'~~~powershell'+$nl+'pwsh C:\ORVION-Temp\old.ps1'+$nl+'~~~')})
       retiredRoutes=@('MD_RETIRED_ROUTE',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Run ORVION-Owner-Tools\lib\Pulse.ps1')})
       historicalCitation=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Historical citation: Documents\ORVION-Sandbox\old.ps1 is retired.')})
       disguisedInstruction=@('MD_RETIRED_INSTRUCTION',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Historical citation: run Documents\ORVION-Sandbox\old.ps1')})
       externalPointers=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[private](../../ORVION-Owner-Tools/records/missing.md)')})
       externalUnapproved=@('MD_EXTERNAL_UNAPPROVED',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[wrong](../../missing.md)')})
       emptyInventory=@('MD_INPUT_EMPTY',{param($directory) $null=Invoke-MarkdownFixtureGit $directory @('rm','-r','--cached','--quiet','.')})
   }
   $budgetLimits=@{'AGENTS.md'=100;'README.md'=400;'RESUME.md'=120;'HANDOFF.md'=600;'WORKFLOW.md'=2400}
   $cases['atBudgets']=@('',{param($directory)
       foreach($budgetPath in $budgetLimits.Keys){
           $text=[IO.File]::ReadAllText((Join-Path $directory $budgetPath));$remaining=$budgetLimits[$budgetPath]-[regex]::Matches($text,'\S+').Count
           $filled=if($budgetPath-ceq'WORKFLOW.md'){$text.Replace('## One-home table',('word '*$remaining)+$nl+$nl+'## One-home table')}else{$text+$nl+$nl+('word '*$remaining)}
           Write-MarkdownFixture (Join-Path $directory $budgetPath) $filled
       }
   })
   foreach($budgetPath in $budgetLimits.Keys){
       $limit=$budgetLimits[$budgetPath]
       $cases['overBudget'+$budgetPath.Split('.')[0]]=@('MD_BUDGET',({param($directory)
           $text=[IO.File]::ReadAllText((Join-Path $directory $budgetPath));Write-MarkdownFixture (Join-Path $directory $budgetPath) ($text+$nl+$nl+('word '*($limit+1)))
       }.GetNewClosure()))
   }
   try{
       foreach($caseName in $cases.Keys){
           if($Case-and$caseName-cne$Case){continue}
           $directory=New-MarkdownFixture $caseName
           $null=Invoke-MarkdownFixtureGit $directory @('add','--all')
           & $cases[$caseName][1] $directory
           if($caseName-notin'unreadable','emptyInventory'){$null=Invoke-MarkdownFixtureGit $directory @('add','--all')}
           $failure='';try{$null=Test-MarkdownConsistency $directory}catch{$failure=$_.Exception.Message}
           $expected=$cases[$caseName][0]
           if(($expected-and$failure-notmatch$expected)-or(!$expected-and$failure)){throw "FAIL $caseName expected '$expected', observed '$failure'"}
           $script:passed++;"PASS $caseName"
           if($caseName-eq'positive'){
               $treeId=Invoke-MarkdownFixtureGit $directory @('write-tree')
               Write-MarkdownFixture (Join-Path $directory 'docs/guide.md') ''
               foreach($selection in @('Index',$treeId)){$null=Test-MarkdownConsistency $directory $selection;$script:passed++;"PASS selected $selection ignores working bytes"}
               foreach($path in @(Get-ChildItem $directory -Recurse -Filter *.md)){
                   $text=[IO.File]::ReadAllText($path.FullName)-replace '\r?\n',([string][char]13+[char]10);Write-MarkdownFixture $path.FullName $text
               }
               Write-MarkdownFixture (Join-Path $directory 'docs/guide.md') (('# Guide'+$nl+'## Section'+$nl+'[back](../README.md#purpose)'+$nl)-replace '\n',([string][char]13+[char]10))
               $null=Test-MarkdownConsistency $directory;$script:passed++;'PASS CRLF equivalent'
               $failure='';try{$null=Test-MarkdownConsistency $directory 'missing-tree'}catch{$failure=$_.Exception.Message}
               if($failure-cne'MD_GIT_UNREADABLE'){throw "FAIL invalidTree $failure"};$script:passed++;'PASS invalid tree refuses'
           }
       }
       if(!$Case){$null=Test-MarkdownConsistency (Split-Path $PSScriptRoot -Parent) $RepositoryTree;$script:passed++;'PASS repository Markdown'}
       if(!$NoMutants-and!$Case){
           $source=[IO.File]::ReadAllText($Guard)
           $mutants=[ordered]@{
               empty='throw "MD_INPUT_EMPTY: $path"';orphan='throw "MD_ORPHAN: $path"'
               missingLink='throw "MD_LINK_MISSING: $Source -> $Link"';missingAnchor='throw "MD_ANCHOR_MISSING: $Source -> $Link"'
               historyByName='[void]$history.Add($path)';historyDuplicate='throw "MD_HISTORY_ENTRY: $link"'
               historyIndexDuplicate="throw 'MD_HISTORY_INDEX'";homeMissing="throw 'MD_HOME_MISSING'"
               homeOwner="throw 'MD_HOME_OWNER'";externalUnapproved='throw "MD_EXTERNAL_UNAPPROVED: $Source -> $Link"'
               historyFormat="throw 'MD_HISTORY_FORMAT'";homeFormat="throw 'MD_HOME_FORMAT'"
               homeDuplicate="throw 'MD_HOME_ROW'";homeTableDuplicate="throw 'MD_HOME_TABLE'"
               pointer='throw "MD_POINTER_HOME: $path"';budget='throw "MD_BUDGET: $path"'
               duplicate='throw "MD_DUPLICATE_PROSE: $($paragraphs[$normalized]), $path"';staleDate='throw "MD_STALE_DATE: $path"'
               retired='throw "MD_RETIRED_ROUTE: $path"';disguisedInstruction='throw "MD_RETIRED_INSTRUCTION: $path"'
           }
           foreach($caseName in $mutants.Keys){
               $anchor=$mutants[$caseName];if(!$source.Contains($anchor)){throw "MD_MUTANT_STALE: $caseName"}
               $mutant=Join-Path $scratch ('mutant-'+$caseName+'.ps1');Write-MarkdownFixture $mutant ($source.Replace($anchor,'$null=$null'))
               $output=& pwsh -NoProfile -File $PSCommandPath -Guard $mutant -NoMutants -Case $caseName 2>&1
               if($LASTEXITCODE-eq0-or($output-join$nl)-notmatch("FAIL "+$caseName+" expected")){throw "MD_MUTANT_SURVIVED: $caseName $output"}
               $script:passed++;"PASS MUTANT KILLED $caseName"
           }
       }
       "MARKDOWN_TESTS PASS: $script:passed assertions"
   }finally{$null=Remove-OrvionOwnedTree -Path $scratch -AllowedRoots @($parent)}
   ```

   The resulting file's Git blob is 9ddde5f1184eae7b1ae270c88bf081e29a8a1a7d.

28. Check whether `lib/Test-MarkdownConsistency.ps1` contains `# Read-only Markdown check. Working uses the Git index inventory with working bytes;`; if so record Already Applied when its Git blob is 668c26bc7af50c374901711179c2a58b77f8a795, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (One clean layout only), and change nothing else:

   ```text
   # Read-only Markdown check. Working uses the Git index inventory with working bytes;
   # Index or a tree-ish uses only selected Git blobs. No external reference is opened.
   param([string]$Root=(Split-Path $PSScriptRoot -Parent),[string]$Tree='Working')
   $ErrorActionPreference='Stop'
   function Invoke-MarkdownGit([string]$Root,[string[]]$Arguments,[string]$Feed=''){
       $start=[Diagnostics.ProcessStartInfo]::new('git');$start.WorkingDirectory=$Root
       $start.UseShellExecute=$false;$start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true;$start.RedirectStandardInput=$true
       foreach($argument in $Arguments){$start.ArgumentList.Add($argument)}
       $process=[Diagnostics.Process]::Start($start);$buffer=[IO.MemoryStream]::new()
       try{
           $copy=$process.StandardOutput.BaseStream.CopyToAsync($buffer);$diagnostic=$process.StandardError.ReadToEndAsync()
           $process.StandardInput.Write($Feed);$process.StandardInput.Close();$null=$copy.GetAwaiter().GetResult();$process.WaitForExit()
           if($process.ExitCode-ne0){throw 'MD_GIT_UNREADABLE'}
           return ,$buffer.ToArray()
       }finally{$buffer.Dispose();$process.Dispose()}
   }
   function Get-MarkdownInput([string]$Root,[string]$Tree){
       $utf8=[Text.UTF8Encoding]::new($false,$true);$files=[Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
       $objects=@{};$inventory=if($Tree-in'Working','Index'){@('ls-files','--stage','-z')}else{@('ls-tree','-rz','--full-tree',$Tree)}
       $listing=$utf8.GetString((Invoke-MarkdownGit $Root $inventory))
       foreach($entry in $listing.Split([char]0,[StringSplitOptions]::RemoveEmptyEntries)){
           if($entry-notmatch '^(\d+) (?:blob )?([a-f0-9]{40,64})(?: (\d))?\t(.+)$'){throw 'MD_INVENTORY_UNREADABLE'}
           $mode=$Matches[1];$object=$Matches[2];$stage=$Matches[3];$path=$Matches[4]
           if($stage-and$stage-ne'0'){throw 'MD_INDEX_UNMERGED'}
           if($path-notmatch '(?i)\.md$'){continue}
           if($mode-notin'100644','100755'){throw "MD_INPUT_MODE: $path"}
           if($Tree-eq'Working'){
               $cursor=$Root
               foreach($part in $path.Split('/')){
                   $cursor=Join-Path $cursor $part
                   if(([IO.File]::GetAttributes($cursor)-band[IO.FileAttributes]::ReparsePoint)-ne0){throw "MD_INPUT_REPARSE: $path"}
               }
               $files.Add($path,$utf8.GetString([IO.File]::ReadAllBytes($cursor)))
           }else{$objects[$path]=$object}
       }
       if($Tree-ne'Working'-and$objects.Count){
           $paths=@($objects.Keys|Sort-Object -CaseSensitive)
           $bytes=Invoke-MarkdownGit $Root @('cat-file','--batch') ((($paths|ForEach-Object{$objects[$_]})-join"`n")+"`n")
           $offset=0
           foreach($path in $paths){
               $end=$offset;while($end-lt$bytes.Length-and$bytes[$end]-ne10){$end++}
               $header=[Text.Encoding]::ASCII.GetString($bytes,$offset,$end-$offset)
               if($header-notmatch '^[a-f0-9]{40,64} blob (\d+)$'){throw 'MD_BLOB_UNREADABLE'}
               $length=[int]$Matches[1];$offset=$end+1
               $files.Add($path,$utf8.GetString($bytes,$offset,$length));$offset+=$length+1
           }
       }
       if(!$files.Count){throw 'MD_INPUT_EMPTY'}
       foreach($path in $files.Keys){if([string]::IsNullOrWhiteSpace($files[$path])){throw "MD_INPUT_EMPTY: $path"}}
       return ,$files
   }
   function Get-MarkdownPlain([string]$Content){
       $lines=[Collections.Generic.List[string]]::new();$fence='';$size=0
       foreach($line in ($Content-replace"`r`n","`n").Split("`n")){
           if($line-match '^ {0,3}(`{3,}|~{3,})'){
               $marker=$Matches[1]
               if(!$fence){$fence=$marker.Substring(0,1);$size=$marker.Length}
               elseif($marker.StartsWith($fence)-and$marker.Length-ge$size-and$line-match '^ {0,3}(`+|~+)\s*$'){$fence=''}
               $lines.Add('');continue
           }
           if(!$fence){$lines.Add($line)}else{$lines.Add('')}
       }
       return $lines-join"`n"
   }
   function Get-MarkdownAnchors([string]$Content){
       $previous=$null;$anchors=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
       foreach($line in (Get-MarkdownPlain $Content).Split("`n")){
           if($line-match '^ {0,3}#{1,6}\s+(.+?)\s*#*\s*$'){
               $slug=$Matches[1]-replace '\[([^\]]+)\]\([^)]*\)','$1'
               $slug=($slug.ToLowerInvariant()-replace '[^\p{L}\p{M}\p{N}_\-\s]','')-replace '\s','-'
               $base=$slug;$number=0
               while($anchors.Contains($slug)){$number++;$slug="$base-$number"}
               [void]$anchors.Add($slug)
           }elseif($line-match '^\s*(?:=+|-+)\s*$'-and$previous-and$previous-notmatch '^\s*[|#>-]'){
               $slug=($previous.ToLowerInvariant()-replace '[^\p{L}\p{M}\p{N}_\-\s]','')-replace '\s','-'
               $base=$slug;$number=0;while($anchors.Contains($slug)){$number++;$slug="$base-$number"};[void]$anchors.Add($slug)
           }
           foreach($tag in [regex]::Matches($line,'(?i)<(?:a|h[1-6])\s+[^>]*(?:id|name)=["'']([^"'']+)["'']')){[void]$anchors.Add($tag.Groups[1].Value)}
           $previous=$line
       }
       return ,$anchors
   }
   function Get-MarkdownLinks([string]$Content){
       $plain=Get-MarkdownPlain $Content;$definitions=@{}
       foreach($definition in [regex]::Matches($plain,'(?m)^ {0,3}\[([^\]]+)\]:\s*(?:<([^>]+)>|(\S+))')){
           $definitions[($definition.Groups[1].Value.ToLowerInvariant()-replace '\s+',' ')]=$definition.Groups[2].Value+$definition.Groups[3].Value
       }
       $plain=$plain-replace '(?m)^ {0,3}\[[^\]]+\]:[^\n]*',''
       $plain=$plain-replace '`+[^`\n]*`+',''
       $inline='!?\[[^\]\n]*\]\(\s*(?:<([^>]+)>|((?:[^\s()\\]|\\.|(?<Paren>\()|(?<-Paren>\)))+)(?(Paren)(?!)))(?:\s+["''][^\n]*?["''])?\s*\)'
       foreach($link in [regex]::Matches($plain,$inline)){$link.Groups[1].Value+$link.Groups[2].Value}
       $plain=$plain-replace $inline,''
       foreach($link in [regex]::Matches($plain,'\[([^\]\n]+)\](?:\[([^\]\n]*)\])?')){
           $label=if($link.Groups[2].Success-and$link.Groups[2].Value){$link.Groups[2].Value}else{$link.Groups[1].Value}
           $key=$label.ToLowerInvariant()-replace '\s+',' '
           if($definitions.ContainsKey($key)){$definitions[$key]}
           elseif($link.Groups[2].Success){throw "MD_REFERENCE_MISSING: $label"}
       }
       foreach($link in [regex]::Matches($plain,'<((?:\.?\.?/|#)[^<>\s]+)>')){$link.Groups[1].Value}
   }
   function Resolve-MarkdownLink([string]$Source,[string]$Link,$Files,$Anchors){
       # URI schemes, rooted paths and sibling/private pointers are opaque; never stat them.
       $Link=[Net.WebUtility]::HtmlDecode($Link)-replace '\\([() ])','$1'
       if($Link-match '^(?:[a-zA-Z][\w+.-]*:|[/\\]{1,2})'){return}
       $parts=$Link.Split('#',2);$target=[Uri]::UnescapeDataString($parts[0]).Replace('\','/')
       $stack=[Collections.Generic.List[string]]::new();$outside=0
       foreach($part in (($Source-replace '[^/]+$','')+$target).Split('/')){
           if($part-eq'..'){if(!$stack.Count){$outside++}else{$stack.RemoveAt($stack.Count-1)}}elseif($part-and$part-ne'.'){$stack.Add($part)}
       }
       if($outside){if(($stack-join'/')-cmatch '^ORVION-Owner-Tools/(?:STATE\.md$|records/)'){return};throw "MD_EXTERNAL_UNAPPROVED: $Source -> $Link"}
       $resolved=if(!$target){$Source}else{$stack-join'/'}
       if($resolved.EndsWith('/')){$resolved=$resolved.TrimEnd('/')}
       if(!$resolved-or$Link.EndsWith('/')){
           if(!@($Files.Keys|Where-Object{$_.StartsWith("$resolved/",[StringComparison]::Ordinal)}).Count){throw "MD_LINK_MISSING: $Source -> $Link"};return
       }
       if(!$Files.ContainsKey($resolved)){throw "MD_LINK_MISSING: $Source -> $Link"}
       if($parts.Count-eq2-and$parts[1]-and$Anchors.ContainsKey($resolved)-and!$Anchors[$resolved].Contains([Uri]::UnescapeDataString($parts[1]))){throw "MD_ANCHOR_MISSING: $Source -> $Link"}
       return $resolved
   }
   function Test-MarkdownConsistency([string]$Root,[string]$Tree='Working'){
       $files=Get-MarkdownInput $Root $Tree;$anchors=@{};$edges=@{};$budgets=@{ 'AGENTS.md'=100;'README.md'=400;'RESUME.md'=120;'HANDOFF.md'=600;'WORKFLOW.md'=2400 }
       foreach($path in $files.Keys){$anchors[$path]=Get-MarkdownAnchors $files[$path]}
       # Other tracked targets may be linked, but only Markdown files participate in reachability.
       $targets=[Collections.Generic.Dictionary[string,string]]::new($files,[StringComparer]::Ordinal)
       $arguments=if($Tree-in'Working','Index'){@('ls-files','-z')}else{@('ls-tree','-rz','--name-only',$Tree)}
       foreach($path in ([Text.Encoding]::UTF8.GetString((Invoke-MarkdownGit $Root $arguments))).Split([char]0,[StringSplitOptions]::RemoveEmptyEntries)){if(!$targets.ContainsKey($path)){$targets.Add($path,'')}}
       $wordCounts=[ordered]@{}
       foreach($path in $budgets.Keys){
           if(!$files.ContainsKey($path)){throw "MD_ROOT_MISSING: $path"}
           $wordCounts[$path]=[regex]::Matches($files[$path],'\S+').Count
           if($wordCounts[$path]-gt$budgets[$path]){throw "MD_BUDGET: $path"}
       }
       $workflow=$files['WORKFLOW.md'];$history=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
       $indexes=[regex]::Matches($workflow,'(?ms)^## History index\r?\n(.*?)(?=^## |\z)')
       if($indexes.Count-ne1){throw 'MD_HISTORY_INDEX'}
       foreach($line in $indexes[0].Groups[1].Value.Split("`n")){if($line.Trim()-and$line-notmatch '^- \[[^\]]+\]\([^)]+\)\r?$'){throw 'MD_HISTORY_FORMAT'}}
       foreach($link in (Get-MarkdownLinks $indexes[0].Groups[1].Value)){
           if($link-cnotmatch '^(?:changes/WS-[^/]+\.md|docs/history/.+\.md)$'-or!$files.ContainsKey($link)-or!$history.Add($link)){throw "MD_HISTORY_ENTRY: $link"}
       }
       # Allocated contracts are judge-governed history by name (a contract's own file appears only at allocation, so an
       # explicit listing could never pass its own Finish); any other file under changes/ must still be reachable.
       foreach($path in $files.Keys){if($path-cmatch'^changes/WS-\d{3}-[A-Za-z0-9-]+\.md$'){[void]$history.Add($path)}}
       foreach($path in $files.Keys){
           $edges[$path]=if($history.Contains($path)){@()}else{@(foreach($link in (Get-MarkdownLinks $files[$path])){Resolve-MarkdownLink $path $link $targets $anchors})}
       }
       $expected=@('Arrival','Purpose','Active contract','Batch 6 closure','Governance','Programme plan','Workspace layout','Recovery','Tool catalogue','Contract template')
       $owners=@{'Arrival'='AGENTS.md';'Purpose'='README.md';'Active contract'='RESUME.md';'Batch 6 closure'='HANDOFF.md';'Governance'='WORKFLOW.md';'Programme plan'='docs/EXECUTION-PLAN.md';'Workspace layout'='docs/WORKSPACE-LAYOUT.md';'Recovery'='docs/RECOVERY.md';'Tool catalogue'='lib/README.md';'Contract template'='changes/TEMPLATE.md'}
       $homes=[regex]::Matches($workflow,'(?ms)^## One-home table\r?\n(.*?)(?=^## |\z)')
       if($homes.Count-ne1){throw 'MD_HOME_TABLE'}
       $rows=[regex]::Matches($homes[0].Groups[1].Value,'(?m)^\| ([^|]+?) \| \[[^\]]+\]\(([^)]+)\) \|\r?$');$concepts=@{};$locations=@{}
       if(@($homes[0].Groups[1].Value.Split("`n")|Where-Object{$_.Trim()}).Count-ne$rows.Count+2){throw 'MD_HOME_FORMAT'}
       foreach($row in $rows){
           $concept=$row.Groups[1].Value;$location=$row.Groups[2].Value
           if($concept-notin$expected-or$concepts.ContainsKey($concept)-or$locations.ContainsKey($location)-or($location-notmatch '#.+$'-and!($concept-ceq'Active contract'-and$location-ceq'RESUME.md'))){throw 'MD_HOME_ROW'}
           if($location.Split('#')[0]-cne$owners[$concept]){throw 'MD_HOME_OWNER'}
           $concepts[$concept]=$true;$locations[$location]=$true
       }
       if($concepts.Count-ne$expected.Count){throw 'MD_HOME_MISSING'}
       $reachable=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal);$queue=[Collections.Generic.Queue[string]]::new()
       $queue.Enqueue('README.md');$queue.Enqueue('AGENTS.md')
       while($queue.Count){$path=$queue.Dequeue();if($reachable.Add($path)){foreach($next in $edges[$path]){if($files.ContainsKey($next)){$queue.Enqueue($next)}}}}
       $paragraphs=@{};$retired='(?i)(?:Documents[/\\]ORVION-(?:Owner-Review|Sandbox)|ORVION-Owner-Tools[/\\]lib|C:[/\\](?:cx|ORVION-Temp)(?=[/\\\s`"''<]|$)|GitHub[/\\]ORVION-Recovery-Inputs)'
       foreach($path in $files.Keys){
           if(!$reachable.Contains($path)-and!$history.Contains($path)){throw "MD_ORPHAN: $path"}
           if($history.Contains($path)-or$path-clike'changes/WS-*.md'){continue}
           if($path-cne'RESUME.md'-and$files[$path].Contains('Active Workbench Contract:')){throw "MD_POINTER_HOME: $path"}
           $plain=Get-MarkdownPlain $files[$path]
           $header=($plain-split '(?m)^## ',2)[0]
           $dates=@([regex]::Matches($header,'(?im)^(?:Version[^\n]*?\|\s*|(?:Updated|Amended|Amendment|Last updated)(?:\s*:)?\s+)(\d{4}-\d{2}-\d{2})')|Select-Object -First 1|ForEach-Object{$_.Groups[1].Value})
           $amendments=@([regex]::Matches($plain,'(?i)\b(?:amended|amendment|updated)\b[^\n\d]{0,60}(\d{4}-\d{2}-\d{2})')|ForEach-Object{$_.Groups[1].Value}|Sort-Object)
           if($dates.Count-and$amendments.Count-and$dates[-1]-clt$amendments[-1]){throw "MD_STALE_DATE: $path"}
           foreach($paragraph in [regex]::Split(($files[$path]-replace"`r`n","`n").Trim(),'\n\s*\n')){
               $routing=$paragraph-replace '\[historical citation:[^\]]*\]\(<[^>]+>\)',''
               if($routing-match$retired-and$routing-notmatch '^Historical citation:'){throw "MD_RETIRED_ROUTE: $path"}
               if($paragraph-match$retired-and(($routing-match '^Historical citation:'-and$routing-match '(?i)\b(?:run|execute|invoke|pwsh|powershell|start at|follow|use)\b')-or$paragraph-match '(?im)^\s*(?:\d+\.\s*)?(?:run|execute|invoke|pwsh|powershell|start at|follow|use)\b')){throw "MD_RETIRED_INSTRUCTION: $path"}
           }
           foreach($paragraph in [regex]::Split($plain.Trim(),'\n\s*\n')){
               if($paragraph-match '(?m)^\s*(?:#|\||[-*+] |\d+[.)] |>|<)'){continue}
               $normalized=([regex]::Replace($paragraph,'\s+',' ')).Trim()
               if([regex]::Matches($normalized,'\S+').Count-ge25){
                   if($paragraphs.ContainsKey($normalized)){throw "MD_DUPLICATE_PROSE: $($paragraphs[$normalized]), $path"}
                   $paragraphs[$normalized]=$path
               }
           }
       }
       [pscustomobject]@{Result='MARKDOWN_CONSISTENCY PASS';Files=$files.Count;Words=$wordCounts}
   }
   if($MyInvocation.InvocationName-ne'.'){
       try{$result=Test-MarkdownConsistency $Root $Tree;$result.Result}catch{Write-Output $_.Exception.Message;exit 1}
   }
   ```

   The resulting file's Git blob is 668c26bc7af50c374901711179c2a58b77f8a795.

29. Check whether `lib/test-pulse.ps1` contains `$noMap=Join-Path $Data 'no-ai-map.json'  # never the checkout's real map, which could start the real refresh task`; if so record Already Applied when its Git blob is 64ef04898b3af58d5fca07079e850dbe18c268f0, and otherwise stop and report. Otherwise make exactly these 3 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
   if($Repository){& $Pulse -Root $Data -Repos $Repository}else{& $Pulse -Root $Data -Repos @()};exit $LASTEXITCODE
   ```
   with
   ```text
   $noMap=Join-Path $Data 'no-ai-map.json'  # never the checkout's real map, which could start the real refresh task
   if($Repository){& $Pulse -Root $Data -Repos $Repository -MapPath $noMap}else{& $Pulse -Root $Data -Repos @() -MapPath $noMap};exit $LASTEXITCODE
   ```

   b) replace the line
   ```text
           $boundedRows=@(foreach($ownerIndex in 0..999){@{pattern=('owner-{0:D4}' -f $ownerIndex);at='2026-10-20T00:00:00Z';category='decision';status='open';owner='owner';summary=('S'*150)}})
   ```
   with
   ```text
           # Owner summaries that merely mention "UNOWNED" must not outrank the real escalated item below.
           $boundedRows=@(foreach($ownerIndex in 0..999){@{pattern=('owner-{0:D4}' -f $ownerIndex);at='2026-10-20T00:00:00Z';category='decision';status='open';owner='owner';summary=('UNOWNED '+('S'*142))}})
   ```

   c) immediately after the line
   ```text
           if($BoundProbeOnly){if($pulseFailures){throw 'PULSE_BOUND_PROBE_FAILED'};$pulseCompleted=$true;'PULSE_BOUND_PROBE PASS';return}
   ```
   insert
   ```text
           # The overflow footer names the data root; a token-shaped folder name must be masked there too.
           $tokenShape='ghp_'+('A1b2C3d4E5'*4).Substring(0,36)  # the real GitHub token length the masking rule recognizes
           $tokenRoot=Join-Path $pulseFixture $tokenShape
           [void][IO.Directory]::CreateDirectory((Join-Path $tokenRoot 'events'))
           [IO.File]::WriteAllText((Join-Path $tokenRoot 'events/events.jsonl'),(@($boundedRows|ForEach-Object{$_|ConvertTo-Json -Compress})-join"`n"),[Text.UTF8Encoding]::new($false))
           $tokenLines=@(& pwsh -NoProfile -File $pulseLauncher -Pulse $pulsePath -Data $tokenRoot -Repository '' -DiscoveryFault '' -RuntimeRows 0 2>&1)-join"`n"
           Assert-PulseCheck 'overflow footer masks a token-shaped data-root path' ($tokenLines-match'(?m)^more\s'-and!$tokenLines.Contains($tokenShape)) $tokenLines
           # Mask before the 150-character cut: a token straddling the cut must not leave its prefix behind.
           Set-PulseFixtureEvents @(@{pattern='straddle';at='2026-10-20T00:00:00Z';category='decision';status='open';owner='owner';summary=('S'*139)+' '+$tokenShape})  # a token stands after a separator, as in real text
           $straddle=Invoke-PulseCheck ''
           Assert-PulseCheck 'owner summary is masked before it is shortened' ($straddle.Text-match'straddle: S+ <masked>'-and$straddle.Text-notmatch'ghp_') $straddle.Text
           # Coordinator's own cuts (summary 110, action 260) happen before Pulse sees the line: masked at the source.
           Set-PulseFixtureEvents @(@{pattern='escalated-straddle';at='2026-10-20T00:00:00Z';category='failure';severity='high';status='open';summary=('S'*104)+' '+$tokenShape},
               @{pattern='active-straddle';at='2026-10-20T00:00:00Z';category='observation';owner='agent';status='open';summary='in flight';action=('A'*254)+' '+$tokenShape})
           $coordinatorCut=Invoke-PulseCheck ''
           Assert-PulseCheck 'Coordinator summary and action are masked before their own cuts' ($coordinatorCut.Text-match'escalated-straddle'-and$coordinatorCut.Text-match'active-straddle'-and$coordinatorCut.Text-notmatch'ghp_') $coordinatorCut.Text
           Set-PulseFixtureEvents @()
           # Map freshness: each mapped repository's saved head against its live HEAD; every outcome is visible.
           $mapFile=Join-Path $pulseFixture 'ai-map.json';$marker=Join-Path $pulseFixture 'map-started.txt'
           $mapRepository=Join-Path $pulseFixture 'mapped';[void][IO.Directory]::CreateDirectory($mapRepository)
           foreach($gitStep in @(@('init','-q'),@('-c','user.name=fixture','-c','user.email=fixture@example.invalid','commit','-q','--allow-empty','-m','mapped'))){& git -C $mapRepository @gitStep 2>&1|Out-Null;if($LASTEXITCODE){throw 'PULSE_FIXTURE_GIT_FAILED'}}
           $mappedHead="$(& git -C $mapRepository rev-parse HEAD)".Trim()
           $mapProbe=Join-Path $pulseFixture 'invoke-map.ps1'
           [IO.File]::WriteAllText($mapProbe,'param($Pulse,$Data,$Map,$Marker,[switch]$FailLaunch) $start=if($FailLaunch){{throw ''launch failed''}}else{[scriptblock]::Create("[IO.File]::AppendAllText(''$Marker'',''x'')")};& $Pulse -Root $Data -Repos @() -MapPath $Map -StartMapTask $start;exit $LASTEXITCODE')
           $mapJson={param($Head)@{generated='2026-10-20T00:00:00Z';repos=@(@{name='mapped';root=$mapRepository;head=$Head})}|ConvertTo-Json -Compress -Depth 4}
           foreach($case in @(
               @{name='stale map (saved head differs) starts one refresh';map=(& $mapJson ('0'*40));line='^map      stale \(mapped\): refresh started$';exit=0;started=$true},
               @{name='fresh map starts no refresh and says fresh';map=(& $mapJson $mappedHead);line='^map      fresh$';exit=0;started=$false},
               @{name='missing map is named, never silent';map=$null;line='^map      missing: ';exit=0;started=$false},
               @{name='malformed map makes Pulse unreadable';map='{torn';line='^map      UNREADABLE ';exit=2;started=$false},
               @{name='empty map makes Pulse unreadable';map='{"repos":[]}';line='^map      UNREADABLE \(no mapped repositories\)';exit=2;started=$false},
               @{name='blank map file makes Pulse unreadable';map='';line='^map      UNREADABLE ';exit=2;started=$false},
               @{name='map object without repos makes Pulse unreadable';map='{}';line='^map      UNREADABLE \(no mapped repositories\)';exit=2;started=$false},
               @{name='map entry without fields makes Pulse unreadable';map='{"repos":[{}]}';line='^map      UNREADABLE \(map entry without name, root or head\)';exit=2;started=$false},
               @{name='map entry without head makes Pulse unreadable, never a refresh';map=('{"repos":[{"name":"mapped","root":'+($mapRepository|ConvertTo-Json)+'}]}');line='^map      UNREADABLE \(map entry';exit=2;started=$false},
               @{name='failed refresh launch makes Pulse unreadable';map=(& $mapJson ('0'*40));line='^map      UNREADABLE \(launch failed\)';exit=2;started=$false;fail=$true})){
               foreach($stale in $marker,$mapFile){if(Test-Path -LiteralPath $stale){[IO.File]::Delete($stale)}}
               if($null-ne$case.map){[IO.File]::WriteAllText($mapFile,$case.map)}
               $mapOut=@(& pwsh -NoProfile -File $mapProbe -Pulse $pulsePath -Data $pulseFixture -Map $mapFile -Marker $marker -FailLaunch:([bool]$case.fail) 2>&1)-join"`n";$mapExit=$LASTEXITCODE
               $started=(Test-Path -LiteralPath $marker)-and[IO.File]::ReadAllText($marker)-ceq'x'
               Assert-PulseCheck $case.name ($started-eq$case.started-and$mapExit-eq$case.exit-and$mapOut-match('(?m)'+$case.line)) $mapOut
           }
   ```

   The resulting file's Git blob is 64ef04898b3af58d5fca07079e850dbe18c268f0.

30. Check whether `lib/test-restore-orvion.ps1` contains `if($Case-eq'winget'){$script:available.winget=$false;$script:available.git=$false}`; if so record Already Applied when its Git blob is 893ace7c23be8e74ff76554110a7cbc664addafc, and otherwise stop and report. Otherwise make exactly these 10 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
       if($Case-eq'winget'){$script:available.winget=$false}
   ```
   with
   ```text
       if($Case-eq'winget'){$script:available.winget=$false;$script:available.git=$false}
       if($Case-eq'no-winget'){$script:available.winget=$false}
   ```

   b) replace the line
   ```text
       function script:Get-RecoveryTool([string]$Name){if($script:available[$Name]){return $Name}}
   ```
   with
   ```text
       function script:Get-RecoveryTool([string]$Name){$script:calls.Add('lookup '+$Name);if($script:available[$Name]){return $Name}}
   ```

   c) replace the line
   ```text
           if($File-eq'pwsh'){Write-Output 'RESTORE_FIXTURE_OUTPUT';if($script:case-eq'restore'){$script:NativeExitCode=42}}
   ```
   with
   ```text
           if($File-eq'pwsh'){Write-Output 'RESTORE_FIXTURE_OUTPUT';if($script:case-eq'restore'){$script:NativeExitCode=42};if($script:case-eq'temporary'-and$Arguments-contains'-Temporary'){$script:NativeExitCode=27};if($script:case-eq'map'-and($Arguments-join' ')-match'Map-Repos'){$script:NativeExitCode=28}}
   ```

   d) immediately after the line
   ```text
       $stage=Join-Path $root 'stage';$target=Join-Path $root 'target'
   ```
   insert
   ```text
       if($Case-eq'exception'){function script:Get-RecoveryPackage {throw 'sensitive-exception-fixture'}}
       if($Case-eq'checklist-exception'){function script:Write-RecoveryChecklist {throw 'sensitive-checklist-fixture'}}
   ```

   e) immediately after the line
   ```text
       $params=@{PackageDir=$packages;Staging=$stage;Target=$target;ClaudeHome=(Join-Path $root 'claude');LegacyTarget=(Join-Path $root 'docs');CodexHome=(Join-Path $root 'codex')}
   ```
   insert
   ```text
       if($Case-like'under-*'){$params[$Case.Substring(6)] = Join-Path $stage 'persistent'}
       if($Case-eq'equal-stage'){$params.ClaudeHome=$stage}
       if($Case-eq'alias-stage'){$alias=Join-Path $root 'alias';$null=New-Item -ItemType Junction -Path $alias -Target $root;$params.ClaudeHome=Join-Path $alias 'stage/persistent'}
       if($Case-eq'default-stage'){$params.Remove('Staging')}
       if($Case-eq'default-legacy'){$params.Remove('LegacyTarget')}
   ```

   f) replace the lines
   ```text
       $ok=$r.Exit-ne0-and$r.Output.Contains($Token)-and$r.Output.Contains('READY/ACTION recovery checklist')
       if($early){$ok=$ok-and$calls-notmatch'^7z x'}else{$ok=$ok-and$r.Stage-and$r.Output.Contains('staging retained')-and$calls-notmatch'workstation.cmd'}
   ```
   with
   ```text
       $ok=$r.Exit-ne0-and$r.Output-notmatch'(?m)^READY: '-and$r.Output.Contains($Token)-and$r.Output.Contains('READY/ACTION recovery checklist')
       if($early){$ok=$ok-and$calls-notmatch'(?m)^7z x'}else{$ok=$ok-and$r.Stage-and$r.Output.Contains('staging retained')-and$calls-notmatch'workstation.cmd'}
       if($Case-eq'exception'){function script:Get-RecoveryPackage {throw 'sensitive-exception-fixture'}}
       if($Case-eq'checklist-exception'){function script:Write-RecoveryChecklist {throw 'sensitive-checklist-fixture'}}
   ```

   g) immediately after the line
   ```text
       Assert-That 'newest by name; one extraction; local bundle branch/head; four paths passed; products both run; staging removed' ($r.Exit-eq0-and!$r.Stage-and@($r.Calls|Where-Object{$_-like'7z x *'}).Count-eq1-and$calls.Contains($r.Newer)-and$calls.Contains('repos\ORVION-Workbench.bundle')-and$calls.Contains('checkout --quiet -B recovery-branch '+('a'*40))-and$calls.Contains('-From ')-and$calls.Contains('-Target ')-and$calls.Contains('-ClaudeHome ')-and$calls.Contains('-LegacyTarget ')-and$calls.Contains('-CodexHome ')-and$calls.Contains('CRM\workstation.cmd')-and$calls.Contains('ORVION\workstation.cmd')-and$calls-notmatch'winget install')
   ```
   insert
   ```text
       $r=Invoke-Scenario no-winget
       Assert-That 'installed prerequisites need no winget lookup; READY is final' ($r.Exit-eq0-and($r.Calls-join' ')-notmatch'lookup winget'-and($r.Output.Trim()-split"`n")[-1]-match'^READY: ')
       foreach($caseName in 'under-Target','under-ClaudeHome','under-CodexHome','under-LegacyTarget','equal-stage','alias-stage'){
           $r=Invoke-Scenario $caseName
           Assert-That "persistent destination guard $caseName precedes all installers and extraction" ($r.Exit-ne0-and$r.Output-match'RECOVERY_DESTINATION_IN_STAGING'-and$r.Calls.Count-le1-and$r.Output-notmatch'(?m)^READY: ')
       }
       $r=Invoke-Scenario default-stage
       Assert-That 'default staging is an owned UTC child of temporary restore-staging' ($r.Exit-eq0-and($r.Calls-join' ')-match'ORVION-Workbench-temporary\\restore-staging\\[0-9]+T[0-9]+Z'-and@(Get-ChildItem (Join-Path $r.Root 'target/ORVION-Workbench-temporary/restore-staging') -ErrorAction SilentlyContinue).Count-eq0)
       $r=Invoke-Scenario default-legacy
       Assert-That 'launcher does not opt into legacy restore by default' ($r.Exit-eq0-and($r.Calls-join' ')-notmatch'-LegacyTarget')
       $r=Invoke-Scenario success
       Assert-That 'successful restore runs narrow rebuild then hourly map installation' (($r.Calls-join' ')-match'Restore-Workspace.ps1 -Temporary -Target .*Map-Repos.ps1 -Install -GitHub')
       foreach($caseName in 'temporary','map','claude-list-fail','exception','checklist-exception'){
           $r=Invoke-Scenario $caseName
           Assert-That "late failure $caseName withholds READY, retains staging and masks exceptions" ($r.Exit-ne0-and($r.Stage-or$caseName-eq'exception')-and$r.Output-notmatch'(?m)^READY: |sensitive-.*fixture'-and$r.Output-match'ACTION: ')
       }
       $needle="throw 'RECOVERY_DESTINATION_IN_STAGING'"
       if(!$source.Contains($needle)){throw 'MUTANT_ANCHOR_MISSING destination'}
       $r=Invoke-Scenario under-ClaudeHome ($source.Replace($needle,"Write-Host 'guard removed'"))
       Assert-That 'MUTANT killed: persistent destination under staging accepted' ($r.Exit-eq0-and($r.Calls-join' ')-match'7z x')
       $needle="if(`$script:RecoveryExit-eq0){Write-Host 'READY: restore and requested preparation completed'}"
       if(!$source.Contains($needle)){throw 'MUTANT_ANCHOR_MISSING READY'}
       $r=Invoke-Scenario claude-list-fail ($source.Replace($needle,"Write-Host 'READY: mutant'"))
       Assert-That 'MUTANT killed: READY after late failure' ($r.Exit-ne0-and$r.Output-match'(?m)^READY: ')
   ```

   h) replace the line
   ```text
       foreach($caseName in 'product','product-missing'){$r=Invoke-Scenario $caseName;Assert-That "$caseName records failure and still runs ORVION; restored files retained" ($r.Exit-ne0-and!$r.Stage-and($r.Calls-join' ').Contains('ORVION\workstation.cmd')-and(Test-Path (Join-Path $r.Root 'target\ORVION\workstation.cmd')))}
   ```
   with
   ```text
       foreach($caseName in 'product','product-missing'){$r=Invoke-Scenario $caseName;Assert-That "$caseName records failure and still runs ORVION; restored files retained" ($r.Exit-ne0-and$r.Stage-and$r.Output-notmatch'(?m)^READY: '-and($r.Calls-join' ').Contains('ORVION\workstation.cmd')-and(Test-Path (Join-Path $r.Root 'target\ORVION\workstation.cmd')))}
   ```

   i) replace the line
   ```text
       $body='param($From,$Target,$ClaudeHome,$LegacyTarget,$CodexHome) if(!(Test-Path (Join-Path $From "backup.json")) -or !$Target -or !$ClaudeHome -or !$LegacyTarget -or !$CodexHome){exit 44}; Write-Output "REAL_CHILD_OUTPUT"; if($Target -like "*child-failure*"){exit 42}; exit 0'
   ```
   with
   ```text
       $body='param($From,$Target,$ClaudeHome,$LegacyTarget,$CodexHome,[switch]$Temporary) if($Temporary){exit 0}; if(!(Test-Path (Join-Path $From "backup.json")) -or !$Target -or !$ClaudeHome -or !$LegacyTarget -or !$CodexHome){exit 44}; [void][IO.Directory]::CreateDirectory((Join-Path $Target "ORVION-Workbench/lib")); [IO.File]::WriteAllText((Join-Path $Target "ORVION-Workbench/lib/Restore-Workspace.ps1"),"param([switch]`$Temporary,`$Target) exit 0"); [IO.File]::WriteAllText((Join-Path $Target "ORVION-Workbench/lib/Map-Repos.ps1"),"param([switch]`$Install,`$GitHub) exit 0"); Write-Output "REAL_CHILD_OUTPUT"; if($Target -like "*child-failure*"){exit 42}; exit 0'
   ```

   j) immediately after the line
   ```text
       if([IO.Path]::GetFullPath($t).StartsWith([IO.Path]::GetFullPath([IO.Path]::GetTempPath()),[StringComparison]::OrdinalIgnoreCase)){
   ```
   insert
   ```text
           Get-ChildItem -LiteralPath $t -Recurse -Force -Attributes ReparsePoint|ForEach-Object{[IO.Directory]::Delete($_.FullName,$false)}
   ```

   The resulting file's Git blob is 893ace7c23be8e74ff76554110a7cbc664addafc.

31. Check whether `lib/Test-ScriptHazards.ps1` contains `$functionNames=@($ast.FindAll({$args[0]-is[Management.Automation.Language.FunctionDefinitionAst]},$true)|ForEach-Object Name)`; if so record Already Applied when its Git blob is 968a8f7f57ee92ca827fe1ce7185e3ea19f0e320, and otherwise stop and report. Otherwise make exactly these 2 edits (One clean layout only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       $vars=$ast.FindAll({$args[0]-is[Management.Automation.Language.VariableExpressionAst]},$true)|Where-Object{$_.VariablePath.IsUnqualified-and$_.VariablePath.UserPath-notmatch'^(_|args|true|false|null|PSItem|this|input|matches|LASTEXITCODE|PID|env:.*)$'}
   ```
   insert
   ```text
       $functionNames=@($ast.FindAll({$args[0]-is[Management.Automation.Language.FunctionDefinitionAst]},$true)|ForEach-Object Name)
       $scopeOf={param($Node)$s=$Node.Parent;while($s-and$s-isnot[Management.Automation.Language.FunctionDefinitionAst]){$s=$s.Parent};$s}
       # A dot-invoked own function runs in its caller's scope: only that function joins the caller's scope.
       # One function dot-invoked from two scopes belongs to both; that is reported, never guessed.
       $dotCaller=@{}
       foreach($dotGroup in $ast.FindAll({$args[0]-is[Management.Automation.Language.CommandAst]-and$args[0].InvocationOperator-eq[Management.Automation.Language.TokenKind]::Dot},$true)|Where-Object{$_.GetCommandName() -in $functionNames}|Group-Object{$_.GetCommandName()}){
           $callers=@($dotGroup.Group|ForEach-Object{$s=& $scopeOf $_;if($s){$s.Extent.StartOffset}else{-1}}|Select-Object -Unique)
           if($callers.Count-gt1){"$p`:$($dotGroup.Group[1].Extent.StartLineNumber) DOT function '$($dotGroup.Name)' is dot-invoked from $($callers.Count) scopes - its variables join both; give each caller its own function";$found++}
           $dotCaller[$dotGroup.Name]=& $scopeOf $dotGroup.Group[0]
       }
   ```

   b) replace the lines
   ```text
           $variableScope=$_.Parent
           while($variableScope-and$variableScope-isnot[Management.Automation.Language.FunctionDefinitionAst]){$variableScope=$variableScope.Parent}
   ```
   with
   ```text
           $variableScope=& $scopeOf $_;$hops=0
           while($variableScope-and$dotCaller.ContainsKey($variableScope.Name)-and$hops++-lt10){$variableScope=$dotCaller[$variableScope.Name]}
   ```

   The resulting file's Git blob is 968a8f7f57ee92ca827fe1ce7185e3ea19f0e320.

32. Check whether `lib/test-spider.ps1` contains `[void][IO.Directory]::CreateDirectory((Join-Path $t 'ws/records/claude-memory/project'))`; if so record Already Applied when its Git blob is 65bf2e351ce12a9a7deac97a91ba241680af9fa8, and otherwise stop and report. Otherwise make exactly these 12 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
       Set-Content (Join-Path $t 'ws\README.md') 'Notes about ZEBRA-42.'
   ```
   with
   ```text
       [void][IO.Directory]::CreateDirectory((Join-Path $t 'ws/records/claude-memory/project'))
       Set-Content (Join-Path $t 'ws/records/README.md') 'Notes about ZEBRA-42.'
   ```

   b) replace the line
   ```text
       $out=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo -ReviewRoot (Join-Path $t 'none'))
   ```
   with
   ```text
       $out=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo)
   ```

   c) replace the line
   ```text
       $projects=Join-Path $env:USERPROFILE '.claude/projects'
   ```
   with
   ```text
       $projects=Join-Path $t 'ws/records/claude-memory'
   ```

   d) replace the line
   ```text
       $empty=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo -ReviewRoot (Join-Path $t 'none'))
   ```
   with
   ```text
       $empty=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo)
   ```

   e) replace the line
   ```text
       $memory=Join-Path $projects 'project/memory';[void][IO.Directory]::CreateDirectory($memory)
   ```
   with
   ```text
       $memory=Join-Path $projects 'project';[void][IO.Directory]::CreateDirectory($memory)
   ```

   f) replace the line
   ```text
       $present=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo -ReviewRoot (Join-Path $t 'none'))
   ```
   with
   ```text
       $present=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo)
   ```

   g) replace the line
   ```text
       try{$refused=try{& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo -ReviewRoot (Join-Path $t 'none')|Out-Null;$false}catch{$true}}finally{$handle.Dispose()}
   ```
   with
   ```text
       try{$refused=try{& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo|Out-Null;$false}catch{$true}}finally{$handle.Dispose()}
   ```

   h) immediately after the line
   ```text
       Assert-That 'present unreadable memory fails instead of becoming no match' $refused
   ```
   insert
   ```text
       # Default repositories follow the map's discovery rule: all three repos, never trusted copies or the temporary tree.
       $gh=Join-Path $t 'gh'
       foreach($n in 'CRM','ORVION','ORVION-Workbench','ORVION-trusted-main','ORVION-Workbench-temporary'){$d=Join-Path $gh $n;New-Item -ItemType Directory $d -Force|Out-Null;Invoke-Quiet $d init -q;Set-Content (Join-Path $d 'n.md') 'ZEBRA-42';Invoke-Quiet $d add -A;Invoke-Quiet $d -c user.name=t -c user.email=t@t commit -q -m n}
       $all=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -GitHub $gh)-join"`n"
       Assert-That 'default search covers CRM, ORVION and ORVION-Workbench, skipping trusted and temporary copies' ($all-match'(?m)^== CRM files: 1'-and$all-match'(?m)^== ORVION files: 1'-and$all-match'(?m)^== ORVION-Workbench files: 1'-and$all-notmatch'== ORVION-trusted-main'-and$all-notmatch'== ORVION-Workbench-temporary')
       # An expected repository that is present but not Git is a named coverage gap, never silently skipped.
       Rename-Item -LiteralPath (Join-Path $gh 'ORVION-Workbench\.git') '.git-hidden'
       try{$noGit=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -GitHub $gh);$noGitCode=$LASTEXITCODE}
       finally{Rename-Item -LiteralPath (Join-Path $gh 'ORVION-Workbench\.git-hidden') '.git'}
       Assert-That 'an expected repository without Git is a coverage gap (exit 3)' ($noGitCode-eq3-and($noGit-join"`n")-match'SPIDER_COVERAGE: incomplete - ORVION-Workbench \(no repository\)')
       # Every rendered field is masked: the query header and a session title, not only snippets.
       $ghToken='ghp_'+('A1b2C3d4E5'*4).Substring(0,36)
       $ixFile=Join-Path $t 'ws\sessions\index.jsonl';$savedIx=[IO.File]::ReadAllText($ixFile)
       [IO.File]::WriteAllText($ixFile,('{"id":"s1","start":"2026-10-01T10:00:00Z","title":"zebra '+$ghToken+'","repo":"CRM","raw":"sessions\\raw\\claude\\p\\s1.jsonl"}'))
       try{$masked=@(& (Join-Path $PSScriptRoot 'Spider.ps1') "ZEBRA-42 $ghToken" -Root (Join-Path $t 'ws') -Repos $repo)+@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo)}
       finally{[IO.File]::WriteAllText($ixFile,$savedIx)}
       # File names, archive pointers and git failures are rendered too: one mask covers every line.
       Set-Content (Join-Path $repo "$ghToken.md") 'ZEBRA-42';Invoke-Quiet $repo add -A;Invoke-Quiet $repo -c user.name=t -c user.email=t@t commit -q -m 'token-shaped file'
       $tokenWs=Join-Path $t $ghToken;Copy-Item (Join-Path $t 'ws') $tokenWs -Recurse
       $paths=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root $tokenWs -Repos $repo)-join"`n"
       $badRepo=Join-Path $t 'bad-repo';New-Item -ItemType Directory $badRepo|Out-Null;Set-Content (Join-Path $badRepo '.git') 'gitdir: C:/does/not/exist'
       $gitFail=try{& (Join-Path $PSScriptRoot 'Spider.ps1') "ZEBRA-42 $ghToken" -Root (Join-Path $t 'ws') -Repos $badRepo|Out-Null;''}catch{"$_"}
       Assert-That 'file names, archive pointers and git failures are masked' ($paths-match'files: 2'-and$paths-match'-> .*<masked>'-and!$paths.Contains('ghp_')-and$gitFail-match'SPIDER_GIT_FAILED'-and!$gitFail.Contains('ghp_'))
       Assert-That 'query header and session titles are masked' (($masked-join"`n")-match"SPIDER 'ZEBRA-42 <masked>'"-and($masked-join"`n")-match'zebra <masked>'-and!($masked-join"`n").Contains('ghp_'))
   ```

   i) replace the line
   ```text
       $refused=try{& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $broken -ReviewRoot (Join-Path $t 'none')|Out-Null;$false}catch{"$_"-match'SPIDER_GIT_FAILED'}
   ```
   with
   ```text
       $refused=try{& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $broken|Out-Null;$false}catch{"$_"-match'SPIDER_GIT_FAILED'}
   ```

   j) replace the lines
   ```text
       Assert-That 'an unreadable repository refuses, never reads as no match' $refused
       $env:USERPROFILE=Join-Path $t 'malformed-profile';[void][IO.Directory]::CreateDirectory((Join-Path $env:USERPROFILE '.claude'))
       [IO.File]::WriteAllText((Join-Path $env:USERPROFILE '.claude/projects'),'not a directory')
       $refused=try{& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo -ReviewRoot (Join-Path $t 'none')|Out-Null;$false}catch{"$_"-match'SPIDER_CLAUDE_PROJECTS_NOT_DIRECTORY'}
       Assert-That 'malformed present projects root is fatal' $refused
       $env:USERPROFILE=Join-Path $t 'profile'
   ```
   with
   ```text
       Assert-That 'an unreadable repository refuses, never reads as no match' $refused
   ```

   k) replace the line
   ```text
               $gap=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $selectedRepo -ReviewRoot (Join-Path $t 'none'));$gapCode=$LASTEXITCODE;$gapText=$gap-join"`n"
   ```
   with
   ```text
               $gap=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $selectedRepo);$gapCode=$LASTEXITCODE;$gapText=$gap-join"`n"
   ```

   l) replace the line
   ```text
       $damaged=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ABSENT-97' -Root (Join-Path $t 'ws') -Repos $repo -ReviewRoot (Join-Path $t 'none'));$damagedCode=$LASTEXITCODE;$damagedText=$damaged-join"`n"
   ```
   with
   ```text
       $damaged=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ABSENT-97' -Root (Join-Path $t 'ws') -Repos $repo);$damagedCode=$LASTEXITCODE;$damagedText=$damaged-join"`n"
   ```

   The resulting file's Git blob is 65bf2e351ce12a9a7deac97a91ba241680af9fa8.

33. Check whether `lib/test-sync-sessions-ack.ps1` contains `# The sidecar lock is the file itself: an aliased spelling (junction) of the same store contends, and the`; if so record Already Applied when its Git blob is 5ddb06d697cafd49348c625c14d77bcf3663b3ab, and otherwise stop and report. Otherwise make exactly this one edit (One clean layout only), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
           Assert-Ack 'concurrent new failure blocks Hunt after acknowledgement' ($concurrentHunt.Code-eq1-and$concurrentHunt.Text-match'BUG sync-errors:.*new concurrent failure')
       }
   ```
   insert
   ```text
       if($Probe-in'All','Concurrency'){
           # The sidecar lock is the file itself: an aliased spelling (junction) of the same store contends, and the
           # sidecar survives release (deleting it would let two writers each create their own).
           $lockStore=Join-Path $t 'lock-store';$alias=Join-Path $t 'lock-alias'
           [void][IO.Directory]::CreateDirectory((Join-Path $lockStore 'work'));$null=New-Item -ItemType Junction -Path $alias -Target $lockStore
           $first=& {. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $lockStore;Enter-SyncErrorLock -WaitMilliseconds 1000}
           try{
               $secondRefused=try{$second=& {. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $alias;Enter-SyncErrorLock -WaitMilliseconds 300};$second.Dispose();$false}catch{"$_"-match'SYNC_ERRORS_LOCK_TIMEOUT'}
           }finally{$first.Dispose()}
           Assert-Ack 'aliased store spelling contends on the same sidecar lock' $secondRefused
           $null=& {. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $lockStore;Write-SyncError 'fixture' ([pscustomobject]@{Exception=[Exception]::new('sidecar probe')})} 2>&1
           Assert-Ack 'sidecar lock file survives release, also after a real error write' ((Test-Path -LiteralPath (Join-Path $lockStore 'work\sync-errors.log.lock') -PathType Leaf)-and[IO.File]::ReadAllText((Join-Path $lockStore 'work\sync-errors.log'))-match'sidecar probe')
           [IO.Directory]::Delete($alias)
       }
   ```

   The resulting file's Git blob is 5ddb06d697cafd49348c625c14d77bcf3663b3ab.

34. Check whether `lib/test-sync-sessions-survival.ps1` contains `# No data root: refuse with a stable code and never archive into the source checkout (WS-022).`; if so record Already Applied when its Git blob is e31e9416ff1e4107e557ce61de8239c7e9e4862b, and otherwise stop and report. Otherwise make exactly this one edit (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
               Assert-That "sync default $case selects only the data root, silent exit 0" ($syncCode-eq0-and!$output.Count-and(Test-Path (Join-Path $expected 'sessions\INDEX.md'))-and($case-eq'fallback'-or!(Test-Path (Join-Path $checkout 'sessions'))))
   ```
   with
   ```text
               if($case-eq'fallback'){
                   # No data root: refuse with a stable code and never archive into the source checkout (WS-022).
                   Assert-That 'sync without a data root refuses and writes nothing into the checkout' ($syncCode-ne0-and($output-join' ')-match'ORVION_DATA_ROOT_UNAVAILABLE'-and!(Test-Path (Join-Path $checkout 'sessions'))-and!(Test-Path (Join-Path $checkout 'work')))
               }else{
                   Assert-That "sync default $case selects only the data root, silent exit 0" ($syncCode-eq0-and!$output.Count-and(Test-Path (Join-Path $expected 'sessions\INDEX.md'))-and!(Test-Path (Join-Path $checkout 'sessions')))
               }
   ```

   The resulting file's Git blob is e31e9416ff1e4107e557ce61de8239c7e9e4862b.

35. Check whether `lib/test-watch-reminder.ps1` contains `$savedTemporaryRoot=$env:WORKBENCH_TEMP_ROOT;$env:WORKBENCH_TEMP_ROOT=Join-Path $t 'managed'`; if so record Already Applied when its Git blob is 024a376875d84aae42934d391093b33b06390cdf, and otherwise stop and report. Otherwise make exactly these 13 edits (One clean layout only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $savedProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
   ```
   insert
   ```text
   $savedTemporaryRoot=$env:WORKBENCH_TEMP_ROOT;$env:WORKBENCH_TEMP_ROOT=Join-Path $t 'managed'
   ```

   b) immediately after the line
   ```text
   $hook=Join-Path $lib 'hooks\Watch-Reminder.ps1';Copy-Item (Join-Path $PSScriptRoot 'hooks\Watch-Reminder.ps1') $hook
   ```
   insert
   ```text
   Copy-Item (Join-Path $PSScriptRoot 'workspace-layout.ps1') $lib
   [void][IO.Directory]::CreateDirectory((Join-Path (Split-Path $ws -Parent) 'ORVION-Owner-Tools/events'))
   ```

   c) immediately after the line
   ```text
           [void][IO.Directory]::CreateDirectory((Join-Path $deadlineLib 'hooks'));[void][IO.Directory]::CreateDirectory($deadlineTemp)
   ```
   insert
   ```text
           Copy-Item (Join-Path $PSScriptRoot 'workspace-layout.ps1') $deadlineLib
   ```

   d) immediately after the lines
   ```text
               }finally{$child.Dispose()}
           }
   ```
   insert
   ```text
           $deadlineSavedTemporaryRoot=$env:WORKBENCH_TEMP_ROOT;$env:WORKBENCH_TEMP_ROOT=$deadlineTemp
   ```

   e) replace the lines
   ```text
               Assert-That 'Pulse stdout and stderr temporary files are deleted after healthy, failed and timed-out calls' (@(Get-ChildItem -LiteralPath $deadlineTemp -Filter 'orvion-pulse-*').Count-eq0)
           }finally{$env:ORVION_DATA_ROOT=$deadlineSavedRoot;$env:TEMP=$deadlineSavedTemp;$env:TMP=$deadlineSavedTmp}
   ```
   with
   ```text
               Assert-That 'Pulse stdout and stderr temporary files are deleted after healthy, failed and timed-out calls' (@(Get-ChildItem -LiteralPath (Join-Path $deadlineTemp 'tmp') -Filter 'orvion-pulse-*').Count-eq0)
           }finally{$env:WORKBENCH_TEMP_ROOT=$deadlineSavedTemporaryRoot;$env:ORVION_DATA_ROOT=$deadlineSavedRoot;$env:TEMP=$deadlineSavedTemp;$env:TMP=$deadlineSavedTmp}
   ```

   f) immediately after the line
   ```text
               $code=$LASTEXITCODE;$log=Join-Path $expected 'work\hook-errors.log'
   ```
   insert
   ```text
               if($case-in'fallback','invalid-fallback'){
                   Assert-That "hook early $case stays stderr-only without creating checkout work" ($code-eq0-and[IO.File]::ReadAllText($stdout)-eq''-and[IO.File]::ReadAllText($stderr)-match'^WATCH_REMINDER_UNREADABLE:'-and!(Test-Path (Join-Path $checkout 'work'))-and@((Get-ChildItem $layout -Recurse -Filter hook-errors.log)).Count-eq0)
                   continue
               }
   ```

   g) replace the line
   ```text
           foreach($case in 'sibling','override','fallback'){
   ```
   with
   ```text
           foreach($case in 'sibling','override'){
   ```

   h) immediately after the line
   ```text
               Copy-Item (Join-Path $PSScriptRoot 'hooks\Watch-Reminder.ps1') (Join-Path $probeLib 'hooks')
   ```
   insert
   ```text
               Copy-Item (Join-Path $PSScriptRoot 'workspace-layout.ps1') $probeLib
   ```

   i) replace the lines
   ```text
               if($case-ne'fallback'){[void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))}
               $expected=if($case-eq'override'){$env:ORVION_DATA_ROOT=$override+'\';$override}elseif($case-eq'sibling'){$sibling}else{$checkout}
   ```
   with
   ```text
               [void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))
               $expected=if($case-eq'override'){$env:ORVION_DATA_ROOT=$override+'\';$override}else{$sibling}
   ```

   j) replace the line
   ```text
               $archiveOk=$hookCode-eq0-and!$quiet.Count-and$call.root-eq$expected-and(Test-Path (Join-Path $expected 'sessions\raw\claude\C--Fixture-ORVION\fixture.jsonl'))-and($case-eq'fallback'-or!(Test-Path (Join-Path $checkout 'sessions')))
   ```
   with
   ```text
               $archiveOk=$hookCode-eq0-and!$quiet.Count-and$call.root-eq$expected-and(Test-Path (Join-Path $expected 'sessions\raw\claude\C--Fixture-ORVION\fixture.jsonl'))-and!(Test-Path (Join-Path $checkout 'sessions'))
   ```

   k) replace the line
   ```text
               Assert-That "hook $case errors use data root" ((Test-Path (Join-Path $expected 'work\hook-errors.log'))-and($case-eq'fallback'-or!(Test-Path (Join-Path $checkout 'work'))))
   ```
   with
   ```text
               Assert-That "hook $case errors use data root" ((Test-Path (Join-Path $expected 'work\hook-errors.log'))-and!(Test-Path (Join-Path $checkout 'work')))
   ```

   l) replace the line
   ```text
       $errorText=Get-Content (Join-Path $ws 'work\hook-errors.log') -Raw
   ```
   with
   ```text
       $errorText=Get-Content (Join-Path (Split-Path $ws -Parent) 'ORVION-Owner-Tools\work\hook-errors.log') -Raw
   ```

   m) replace the line
   ```text
       $env:USERPROFILE=$savedProfile;$env:ORVION_DATA_ROOT=$inheritedDataRoot
   ```
   with
   ```text
       $env:WORKBENCH_TEMP_ROOT=$savedTemporaryRoot;$env:USERPROFILE=$savedProfile;$env:ORVION_DATA_ROOT=$inheritedDataRoot
   ```

   The resulting file's Git blob is 024a376875d84aae42934d391093b33b06390cdf.

36. Check whether `lib/test-workbench-governance.ps1` contains `$info.Environment['WORKBENCH_TEMP_ROOT']=Join-Path $ownedRoot 'entry-temp'`; if so record Already Applied when its Git blob is 4125825db2f267ef809fa3498a88fa8cb692032d, and otherwise stop and report. Otherwise make exactly these 5 edits (One clean layout only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       foreach($key in 'WORKBENCH_TEST_ROOT','WORKBENCH_TEMP_ROOT','WORKBENCH_TEST_EVIDENCE','WORKBENCH_SUITE_PARENT','WORKBENCH_SUITE_RECIPE','WORKBENCH_SUITE_MODE','WORKBENCH_CI_CANDIDATE','WORKBENCH_CI_RUNTIME'){$null=$info.Environment.Remove($key)}
   ```
   insert
   ```text
       $info.Environment['WORKBENCH_TEMP_ROOT']=Join-Path $ownedRoot 'entry-temp'
   ```

   b) replace the line
   ```text
       foreach($relative in 'lib/Test-WorkbenchChange.ps1','lib/Workbench.ps1','lib/run_timed.ps1','lib/watch_run.ps1','lib/Test-ScriptHazards.ps1','lib/Events.ps1','lib/Hunt.ps1','tests.ps1'){
   ```
   with
   ```text
       foreach($relative in 'lib/Test-WorkbenchChange.ps1','lib/Workbench.ps1','lib/workspace-layout.ps1','lib/remove-owned.ps1','lib/run_timed.ps1','lib/watch_run.ps1','lib/Test-ScriptHazards.ps1','lib/Events.ps1','lib/Hunt.ps1','tests.ps1'){
   ```

   c) immediately after the line
   ```text
       Assert-Fixture 'CI actual terminal-None caller owns exactly one successful timed/watched schedule' ($positive.Exit-eq0-and$ciResult.Result-ceq'READY'-and$ciResult.Certification-eq$false-and$ciResult.Recipe-ceq$ciRecipe.Digest) $positive
   ```
   insert
   ```text
       Assert-Fixture 'CI driver removes its test data from managed temp on success' ($positive.Exit-eq0-and@(Get-ChildItem -LiteralPath (Join-Path $ciRecipe.Context['Temp Root'] 'tmp') -Filter 'orvion-test-data-*' -ErrorAction SilentlyContinue).Count-eq0)
   ```

   d) immediately after the line
   ```text
           Assert-Fixture ('CI actual '+$scenario+' cannot become success') ($failure.Exit-ne0-and$failure.Output-match$expectedFailure-and!(Test-Path -LiteralPath (Join-Path $mutantRuntime 'ci-result.json'))) $failure
   ```
   insert
   ```text
           if($scenario-ceq'child-exit'){Assert-Fixture 'CI driver removes its test data after a failed test child' (@(Get-ChildItem -LiteralPath (Join-Path $mutantRuntime 'tmp/tmp') -Filter 'orvion-test-data-*' -ErrorAction SilentlyContinue).Count-eq0)}
   ```

   e) replace the line
   ```text
       foreach($relative in 'lib/Test-WorkbenchChange.ps1','lib/Workbench.ps1','lib/run_timed.ps1','lib/watch_run.ps1','lib/apply-draft-steps.ps1','lib/Invoke-DraftSteps.ps1','lib/Events.ps1','lib/Hunt.ps1','lib/Sync-Sessions.ps1','.githooks/pre-commit'){
   ```
   with
   ```text
       foreach($relative in 'lib/Test-WorkbenchChange.ps1','lib/Workbench.ps1','lib/workspace-layout.ps1','lib/run_timed.ps1','lib/watch_run.ps1','lib/apply-draft-steps.ps1','lib/Invoke-DraftSteps.ps1','lib/Events.ps1','lib/Hunt.ps1','lib/Sync-Sessions.ps1','.githooks/pre-commit'){
   ```

   The resulting file's Git blob is 4125825db2f267ef809fa3498a88fa8cb692032d.

37. Check whether `lib/test-workspace-layout.ps1` contains `# Real local layout and Git-for-Windows hook callers; all data and mutants are disposable fixtures.`; if so record Already Applied when its Git blob is a971316a96027c780a898c5493d26fa8697794fc, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (One clean layout only), and change nothing else:

   ```text
   # Real local layout and Git-for-Windows hook callers; all data and mutants are disposable fixtures.
   param([ValidateSet('all','nested','hook','temporary')][string]$Probe='all',
         [string]$Resolver=(Join-Path $PSScriptRoot 'workspace-layout.ps1'),
         [string]$Hook=(Join-Path (Split-Path $PSScriptRoot -Parent) '.githooks/pre-commit'),[switch]$NoMutants)
   $ErrorActionPreference='Stop'
   . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   $scratchParent=[IO.Path]::GetTempPath()
   $scratch=Join-Path $scratchParent ('orvion-layout-'+[guid]::NewGuid().ToString('N').Substring(0,8))
   [void][IO.Directory]::CreateDirectory($scratch)
   $savedEnvironment=@{}
   foreach($key in 'TEMP','TMP','TMPDIR','WORKBENCH_TEMP_ROOT','ORVION_DATA_ROOT','GITHUB_ACTIONS','RUNNER_TEMP','ORVION_STANDALONE_TEMP','GIT_CONFIG_GLOBAL','GIT_CONFIG_NOSYSTEM'){
       $savedEnvironment[$key]=[Environment]::GetEnvironmentVariable($key,'Process')
   }
   $fail=0
   function Assert-Layout([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{$script:fail++;"FAIL $Name"}}
   function Write-LayoutFile([string]$Path,[string]$Text){
       [void][IO.Directory]::CreateDirectory((Split-Path $Path -Parent))
       [IO.File]::WriteAllText($Path,$Text,[Text.UTF8Encoding]::new($false))
   }
   function Invoke-LayoutChild([string]$Executable,[string[]]$Arguments,[hashtable]$Environment=@{},[string]$Directory=$scratch){
       $info=[Diagnostics.ProcessStartInfo]::new($Executable)
       $info.WorkingDirectory=$Directory;$info.UseShellExecute=$false;$info.CreateNoWindow=$true
       $info.RedirectStandardOutput=$true;$info.RedirectStandardError=$true;$info.RedirectStandardInput=$true
       foreach($key in $Environment.Keys){if($null-eq$Environment[$key]){$null=$info.Environment.Remove($key)}else{$info.Environment[$key]=$Environment[$key]}}
       foreach($argument in $Arguments){$info.ArgumentList.Add($argument)}
       $child=[Diagnostics.Process]::new();$child.StartInfo=$info
       try{
           $null=$child.Start();$child.StandardInput.Close();$stdout=$child.StandardOutput.ReadToEndAsync();$stderr=$child.StandardError.ReadToEndAsync()
           if(!$child.WaitForExit(30000)){$child.Kill($true);$child.WaitForExit();throw 'LAYOUT_CHILD_TIMEOUT'}
           [pscustomobject]@{Exit=$child.ExitCode;Text=$stdout.GetAwaiter().GetResult()+$stderr.GetAwaiter().GetResult()}
       }finally{$child.Dispose()}
   }
   function Invoke-LayoutGit([string]$Directory,[string[]]$Arguments){
       $result=Invoke-LayoutChild $script:gitExe (@('-C',$Directory)+$Arguments)
       if($result.Exit){throw ('LAYOUT_FIXTURE_GIT_FAILED: '+$result.Text)}
       $result.Text.Trim()
   }
   function Test-TemporaryLayout([string]$Name,[string]$Checkout,[string]$Expected,[hashtable]$Options=@{}){
       $Expected=[IO.Path]::GetFullPath($Expected)
       [void][IO.Directory]::CreateDirectory($Checkout)
       $previousTemp=$env:TEMP;$previousTmp=$env:TMP
       try{
           # A refusal is a named FAIL of this case, never a crash that hides which case broke.
           try{$resolved=Initialize-OrvionTemporaryRoot -Checkout $Checkout @Options}catch{Assert-Layout "$Name ($($_.Exception.Message))" $false;return}
           $expectedTemp=Join-Path $Expected 'tmp'
           $child=Invoke-LayoutChild 'pwsh' @('-NoProfile','-Command','[ordered]@{temp=$env:TEMP;tmp=$env:TMP;api=[IO.Path]::GetTempPath().TrimEnd([char]92)}|ConvertTo-Json -Compress')
           $observed=$child.Text|ConvertFrom-Json
           Assert-Layout $Name ($resolved-ieq$Expected-and$env:TEMP-ieq$expectedTemp-and$env:TMP-ieq$expectedTemp-and$child.Exit-eq0-and$observed.temp-ieq$expectedTemp-and$observed.tmp-ieq$expectedTemp-and$observed.api-ieq$expectedTemp)
       }finally{$env:TEMP=$previousTemp;$env:TMP=$previousTmp}
   }
   try{
       foreach($key in 'WORKBENCH_TEMP_ROOT','ORVION_DATA_ROOT','GITHUB_ACTIONS','RUNNER_TEMP','ORVION_STANDALONE_TEMP'){
           [Environment]::SetEnvironmentVariable($key,$null,'Process')
       }
       $env:TEMP=$scratch;$env:TMP=$scratch
       $env:GIT_CONFIG_GLOBAL=Join-Path $scratch 'empty.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
       . $Resolver
       $gitExe=(Get-Command git -CommandType Application|Select-Object -First 1).Source
       if($Probe-in'all','nested'){
           $temporary=Join-Path $scratch 'space layout/ORVION-Workbench-temporary'
           Test-TemporaryLayout 'nested sandbox stays under temporary' (Join-Path $temporary 'sb/WS-022/c') $temporary
           Test-TemporaryLayout 'nested cx stays under temporary' (Join-Path $temporary 'cx/ORVION-task') $temporary
       }
       if($Probe-eq'all'){
           $installed=Join-Path $scratch 'installed/ORVION-Workbench'
           Test-TemporaryLayout 'installed checkout uses sibling temporary' $installed (Join-Path (Split-Path $installed -Parent) 'ORVION-Workbench-temporary')
           $explicit=Join-Path $scratch 'context temp'
           Test-TemporaryLayout 'explicit context wins over nested layout and target' (Join-Path $temporary 'sb/WS-022/rehearsal') $explicit @{TemporaryRoot=$explicit;Target=(Join-Path $scratch 'other target')}
           $target=Join-Path $scratch 'restore target'
           Test-TemporaryLayout 'explicit restore target wins over executing checkout' $installed (Join-Path $target 'ORVION-Workbench-temporary') @{Target=$target}
           $broken=Join-Path $scratch 'broken checkout';[void][IO.Directory]::CreateDirectory($broken)
           $failure=try{$null=Initialize-OrvionTemporaryRoot -Checkout $broken;''}catch{$_.Exception.Message}
           Assert-Layout 'broken local layout refuses without system-temp fallback' ($failure-ceq'WB_TEMP_LAYOUT_UNAVAILABLE')
           foreach($bad in @(@{TemporaryRoot='relative'},@{Target='relative'},@{TemporaryRoot=(Join-Path $broken 'tmp')})){
               $failure=try{$null=Initialize-OrvionTemporaryRoot -Checkout $broken @bad;''}catch{$_.Exception.Message}
               Assert-Layout 'invalid explicit temporary selection refuses' ($failure-match'^WB_TEMP_(ROOT_NOT_ABSOLUTE|TARGET_NOT_ABSOLUTE|ROOT_INSIDE_CHECKOUT_REFUSED)$')
           }
           $env:RUNNER_TEMP=Join-Path $scratch 'runner'
           Test-TemporaryLayout 'hosted runner explicitly permits temporary storage' $broken (Join-Path $env:RUNNER_TEMP 'ORVION-Workbench')
           $env:RUNNER_TEMP=$null;$env:GITHUB_ACTIONS='true'
           Test-TemporaryLayout 'GitHub Actions explicitly permits system temp' $broken (Join-Path $scratch 'ORVION-Workbench')
           $env:GITHUB_ACTIONS=$null;$env:ORVION_STANDALONE_TEMP='1'
           Test-TemporaryLayout 'standalone opt-in permits system temp' $broken (Join-Path $scratch 'ORVION-Workbench')
           $env:ORVION_STANDALONE_TEMP=$null

       }
       if($Probe-in'all','temporary'){
           # Pin equality against the actual accepted judge definitions, without executing its entrypoint.
           $judgePath=Join-Path $PSScriptRoot 'Test-WorkbenchChange.ps1'
           $tokens=$null;$errors=$null;$judge=[Management.Automation.Language.Parser]::ParseFile($judgePath,[ref]$tokens,[ref]$errors)
           foreach($name in 'Get-WorkbenchCITool','Get-WorkbenchWorkflowPolicy'){
               $fn=$judge.Find({param($n)$n-is[Management.Automation.Language.FunctionDefinitionAst]-and$n.Name-eq$name},$false)
               . ([scriptblock]::Create($fn.Extent.Text))
           }
           $accepted=Get-WorkbenchCITool;$pin=Get-OrvionTemporaryTool
           $policy=Get-WorkbenchWorkflowPolicy
           $provision=$policy.jobs['workbench-acceptance'].steps[1].run
           Assert-Layout 'temporary actionlint matches judge version, archive hash, exe hash and exact URL' ($pin.Version-ceq$accepted.Version-and$pin.ArchiveSHA256-ceq$accepted.ArchiveSHA256-and$pin.SHA256-ceq$accepted.SHA256-and$provision.Contains("Invoke-WebRequest -Uri '"+$pin.Url+"' -OutFile"))
           $fakeArchive=Join-Path $scratch 'fake-actionlint.zip'
           $zip=[IO.Compression.ZipFile]::Open($fakeArchive,'Create')
           try{$entry=$zip.CreateEntry('actionlint.exe');$writer=[IO.StreamWriter]::new($entry.Open());try{$writer.Write('fake executable bytes')}finally{$writer.Dispose()}}finally{$zip.Dispose()}
           $fakeExe=Join-Path $scratch 'fake.exe';[IO.File]::WriteAllText($fakeExe,'fake executable bytes',[Text.UTF8Encoding]::new($false))
           $fakePin=@{Version='1.7.12';Url='fixture://local';ArchiveSHA256=(Get-FileHash $fakeArchive).Hash;SHA256=(Get-FileHash $fakeExe).Hash}
           function Get-OrvionTemporaryTool {$fakePin}
           $script:downloads=0;$script:interrupt=$false
           function Receive-OrvionTemporaryTool([string]$Uri,[string]$OutFile){
               $script:downloads++
               Copy-Item -LiteralPath $fakeArchive -Destination $OutFile
               if($script:interrupt){throw 'FIXTURE_INTERRUPTED'}
           }
           function Test-TemporaryProvision([string]$Name,[string]$Root=(Join-Path $scratch $Name)){
               try{$null=Restore-OrvionTemporary $Root;$errorText=''}catch{$errorText=$_.Exception.Message}
               $tree=Join-Path $Root 'ORVION-Workbench-temporary'
               [pscustomobject]@{Error=$errorText;Root=$Root;Tree=$tree;Exe=(Join-Path $tree 'tools/actionlint.exe');Half=@(Get-ChildItem -LiteralPath (Join-Path $tree 'tools') -Filter '.provision-*' -ErrorAction SilentlyContinue).Count}
           }
           $rebuilt=Test-TemporaryProvision 'narrow rebuild'
           Assert-Layout 'narrow rebuild publishes verified executable at temporary/tools only' (!$rebuilt.Error-and(Get-FileHash $rebuilt.Exe).Hash-ceq$fakePin.SHA256-and$rebuilt.Half-eq0-and@(Get-ChildItem $rebuilt.Root).Count-eq1)
           $before=$downloads;$again=Test-TemporaryProvision 'narrow rebuild'
           Assert-Layout 'second temporary rebuild is idempotent without another download' (!$again.Error-and$downloads-eq$before-and$again.Half-eq0)
           [IO.File]::WriteAllText($rebuilt.Exe,'corrupt existing')
           $corrupt=Test-TemporaryProvision 'narrow rebuild'
           Assert-Layout 'corrupt existing executable refused without replacement' ($corrupt.Error-ceq'WB_TEMP_TOOL_IDENTITY'-and[IO.File]::ReadAllText($rebuilt.Exe)-ceq'corrupt existing'-and$downloads-eq$before)
           $expectedArchive=$fakePin.ArchiveSHA256;$fakePin.ArchiveSHA256='A'*64
           $badArchive=Test-TemporaryProvision 'bad archive';$fakePin.ArchiveSHA256=$expectedArchive
           Assert-Layout 'archive identity checked before extraction with no half tool' ($badArchive.Error-ceq'WB_TEMP_ARCHIVE_IDENTITY'-and!(Test-Path $badArchive.Exe)-and$badArchive.Half-eq0)
           $expectedExe=$fakePin.SHA256;$fakePin.SHA256='B'*64
           $badExe=Test-TemporaryProvision 'bad exe';$fakePin.SHA256=$expectedExe
           Assert-Layout 'executable identity checked after extraction with no half tool' ($badExe.Error-ceq'WB_TEMP_TOOL_IDENTITY'-and!(Test-Path $badExe.Exe)-and$badExe.Half-eq0)
           $script:interrupt=$true;$interrupted=Test-TemporaryProvision 'interrupted';$script:interrupt=$false
           Assert-Layout 'interrupted download cleans owned staging and leaves no executable' ($interrupted.Error-ceq'FIXTURE_INTERRUPTED'-and!(Test-Path $interrupted.Exe)-and$interrupted.Half-eq0)
           $retry=Test-TemporaryProvision 'interrupted'
           Assert-Layout 'interrupted provisioning can be retried' (!$retry.Error-and(Test-Path $retry.Exe))
           $originalArchive=$fakeArchive;$originalArchiveHash=$fakePin.ArchiveSHA256
           foreach($entryNames in @(@('../actionlint.exe'),@('actionlint.exe','actionlint.exe'))){
               $fakeArchive=Join-Path $scratch ('invalid-entries-'+$entryNames.Count+'.zip')
               $zip=[IO.Compression.ZipFile]::Open($fakeArchive,'Create')
               try{foreach($name in $entryNames){$entry=$zip.CreateEntry($name);$writer=[IO.StreamWriter]::new($entry.Open());try{$writer.Write('fake executable bytes')}finally{$writer.Dispose()}}}finally{$zip.Dispose()}
               $fakePin.ArchiveSHA256=(Get-FileHash $fakeArchive).Hash
               $invalidEntry=Test-TemporaryProvision ('invalid entries '+$entryNames.Count)
               Assert-Layout ('invalid or duplicate actionlint archive entries refused: '+$entryNames.Count) ($invalidEntry.Error-ceq'WB_TEMP_TOOL_ENTRY_INVALID'-and!(Test-Path $invalidEntry.Exe)-and$invalidEntry.Half-eq0)
           }
           $fakeArchive=$originalArchive;$fakePin.ArchiveSHA256=$originalArchiveHash
           # Test the actual -Temporary entry with fake archive transport. All client/data homes are absent.
           $entryLib=Join-Path $scratch 'narrow entry/lib';[void][IO.Directory]::CreateDirectory($entryLib)
           Copy-Item (Join-Path $PSScriptRoot 'Restore-Workspace.ps1') $entryLib
           $fakeSuffix="`nfunction Get-OrvionTemporaryTool { @{Version='1.7.12';Url='fixture://local';ArchiveSHA256='"+$fakePin.ArchiveSHA256+"';SHA256='"+$fakePin.SHA256+"'} }`nfunction Receive-OrvionTemporaryTool([string]`$Uri,[string]`$OutFile){ Copy-Item -LiteralPath '"+$fakeArchive.Replace("'","''")+"' -Destination `$OutFile }`n"
           Write-LayoutFile (Join-Path $entryLib 'workspace-layout.ps1') ([IO.File]::ReadAllText($Resolver)+$fakeSuffix)
           $entryTarget=Join-Path $scratch 'entry target'
           $entryResult=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $entryLib 'Restore-Workspace.ps1'),'-Temporary','-Target',$entryTarget) @{USERPROFILE=(Join-Path $scratch 'absent-profile');ORVION_DATA_ROOT=(Join-Path $scratch 'absent-data');PATH=$env:PATH}
           if($entryResult.Exit){'TEMPORARY_ENTRY_DIAGNOSTIC: '+$entryResult.Text}
           Assert-Layout 'actual Temporary entry needs no package, journal, sessions, client homes or credentials' ($entryResult.Exit-eq0-and(Test-Path (Join-Path $entryTarget 'ORVION-Workbench-temporary/tools/actionlint.exe'))-and@(Get-ChildItem $entryTarget).Count-eq1-and!(Test-Path (Join-Path $scratch 'absent-profile/.claude'))-and!(Test-Path (Join-Path $scratch 'absent-profile/.codex'))-and!(Test-Path (Join-Path $scratch 'absent-data')))
           if(!$NoMutants){
               $layoutBytes=[IO.File]::ReadAllText($Resolver)
               $anchor="if((Get-FileHash -LiteralPath `$candidate).Hash-cne`$tool.SHA256){throw 'WB_TEMP_TOOL_IDENTITY'}"
               if(!$layoutBytes.Contains($anchor)){throw 'LAYOUT_MUTANT_STALE: exe identity'}
               $mutantLayout=Join-Path $scratch 'mutants/tool-layout.ps1'
               Write-LayoutFile $mutantLayout ($layoutBytes.Replace($anchor,'# mutant removed executable check')+$fakeSuffix)
               . $mutantLayout
               $mutantFakePin=Get-OrvionTemporaryTool
               $fakeSuffixBad=$fakeSuffix.Replace($mutantFakePin.SHA256,('B'*64))
               Write-LayoutFile $mutantLayout ($layoutBytes.Replace($anchor,'# mutant removed executable check')+$fakeSuffixBad)
               . $mutantLayout
               $mutated=Test-TemporaryProvision 'mutant unchecked exe'
               Assert-Layout 'MUTANT KILLED: executable hash check removed' (!$mutated.Error-and(Test-Path $mutated.Exe))
               $anchor="'tools/actionlint.exe'"
               if(!$layoutBytes.Contains($anchor)){throw 'LAYOUT_MUTANT_STALE: legacy tool path'}
               Write-LayoutFile $mutantLayout ($layoutBytes.Replace($anchor,"'actionlint.exe'")+$fakeSuffix)
               . $mutantLayout
               $mutated=Test-TemporaryProvision 'mutant legacy path'
               Assert-Layout 'MUTANT KILLED: legacy actionlint path used' (!$mutated.Error-and!(Test-Path $mutated.Exe)-and(Test-Path (Join-Path $mutated.Tree 'actionlint.exe')))
               . $Resolver
           }

       }
       if($Probe-eq'all'){
           # An empty synthetic checkout must never become the implicit data store.
           $dataCheckout=Join-Path $scratch 'data/ORVION-Workbench';$dataLib=Join-Path $dataCheckout 'lib'
           [void][IO.Directory]::CreateDirectory((Join-Path $dataLib 'hooks'))
           Copy-Item (Join-Path $PSScriptRoot 'Events.ps1'),(Join-Path $PSScriptRoot 'Sync-Sessions.ps1'),(Join-Path $PSScriptRoot 'Backup-Workspace.ps1'),$Resolver $dataLib
           Copy-Item (Join-Path $PSScriptRoot 'hooks/Watch-Reminder.ps1') (Join-Path $dataLib 'hooks')
           $reader=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $dataLib 'Events.ps1'),'-Brief')
           $writer=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $dataLib 'Events.ps1'),'-Add','-Pattern','fixture','-Summary','fixture')
           $backupDestination=Join-Path $scratch 'refused backup'
           $backup=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $dataLib 'Backup-Workspace.ps1'),'-Destination',$backupDestination,'-AllowUnencrypted')
           $hookFailure=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $dataLib 'hooks/Watch-Reminder.ps1')) # EOF is invalid input
           Assert-Layout 'missing data readers report UNAVAILABLE and writers refuse stable code' ($reader.Exit-eq3-and$reader.Text-match'EVENTS_UNAVAILABLE'-and$writer.Exit-ne0-and$writer.Text-match'ORVION_DATA_ROOT_UNAVAILABLE'-and$backup.Exit-ne0-and$backup.Text-match'ORVION_DATA_ROOT_UNAVAILABLE')
           Assert-Layout 'missing data and hook failure create no checkout work or backup' ($hookFailure.Exit-eq0-and$hookFailure.Text-match'ORVION_DATA_ROOT_UNAVAILABLE'-and!(Test-Path (Join-Path $dataCheckout 'work'))-and!(Test-Path (Join-Path $dataCheckout 'events'))-and!(Test-Path $backupDestination))
           foreach($dataCase in @(
               @('Pulse',@()),@('Spider',@('fixture')),@('Coordinator',@('-Brief')),
               @('Delegate',@('-List')),@('Hunt',@('-Quick','-NoRecord')),
               @('Sync-Sessions',@('-Quiet')),@('Watch-Subagents',@('-Session','fixture','-Once'))
           )){
               $tool=$dataCase[0];Copy-Item (Join-Path $PSScriptRoot ($tool+'.ps1')) $dataLib
               $missing=Invoke-LayoutChild 'pwsh' (@('-NoProfile','-File',(Join-Path $dataLib ($tool+'.ps1')))+$dataCase[1])
               $expectedExit=if($tool-in'Pulse','Spider','Coordinator','Delegate'){3}else{1}
               Assert-Layout ("missing default data: $tool refuses before any checkout write") ($missing.Exit-eq$expectedExit-and$missing.Text-match'ORVION_DATA_ROOT_UNAVAILABLE'-and!(Test-Path (Join-Path $dataCheckout 'work'))-and!(Test-Path (Join-Path $dataCheckout 'events')))
           }
           $override=Join-Path $scratch 'override data'
           $explicitWrite=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $dataLib 'Events.ps1'),'-Add','-Pattern','override','-Summary','fixture') @{ORVION_DATA_ROOT=$override}
           Assert-Layout 'absolute data override still initializes an explicit store' ($explicitWrite.Exit-eq0-and(Test-Path (Join-Path $override 'events/events.jsonl')))
       }
       if($Probe-in'all','hook'){
           $hookTemporary=Join-Path $scratch 'hook space/ORVION-Workbench-temporary'
           $hookCheckout=Join-Path $hookTemporary 'sb/WS-022/c'
           [void][IO.Directory]::CreateDirectory($hookCheckout)
           $null=Invoke-LayoutGit $hookCheckout @('init','--quiet','-b','main')
           $checker=@'
   param([string]$Root,[string]$Mode,[switch]$Staged,[string]$Base)
   [ordered]@{temp=$env:TEMP;tmp=$env:TMP;script=$PSCommandPath}|ConvertTo-Json -Compress|Set-Content -LiteralPath (Join-Path $Root '.git/judge.json')
   exit 0
   '@
           Write-LayoutFile (Join-Path $hookCheckout 'lib/Test-WorkbenchChange.ps1') ($checker.Replace("`r`n","`n")+[char]10)
           Write-LayoutFile (Join-Path $hookCheckout '.githooks/pre-commit') ([IO.File]::ReadAllText($Hook).Replace("`r`n","`n"))
           $null=Invoke-LayoutGit $hookCheckout @('add','lib/Test-WorkbenchChange.ps1')
           # Fixture-only accepted HEAD; no commit is made in the prototype checkout.
           $null=Invoke-LayoutGit $hookCheckout @('-c','user.name=Fixture','-c','user.email=fixture@invalid.local','-c','core.hooksPath=DISABLED','commit','--quiet','-m','fixture accepted checker')
           $unmanaged=Join-Path $scratch 'unmanaged';[void][IO.Directory]::CreateDirectory($unmanaged)
           $hookEnvironment=@{TMPDIR=$null;WORKBENCH_TEMP_ROOT=$null;WS022_UNMANAGED_ROOT=$unmanaged.Replace('\','/')}
           $hookArguments=@('-C',$hookCheckout,'-c','core.hooksPath=.githooks','hook','run','pre-commit')
           $result=Invoke-LayoutChild $gitExe $hookArguments $hookEnvironment $hookCheckout
           $observation=Join-Path $hookCheckout '.git/judge.json'
           $observed=if(Test-Path $observation){Get-Content -LiteralPath $observation -Raw|ConvertFrom-Json}
           $expected=Join-Path $hookTemporary 'tmp'
           Assert-Layout 'hook uses managed temp with absent TMPDIR and spaces via real Git sh' ($result.Exit-eq0-and$observed-and$observed.temp-ieq$expected-and$observed.tmp-ieq$expected-and[IO.Path]::GetDirectoryName($observed.script)-ieq$expected)
           Assert-Layout 'hook trap removes accepted judge' (@(Get-ChildItem -LiteralPath $expected -Filter 'workbench-judge-*').Count-eq0)
           if($Probe-eq'all'){
               Copy-Item (Join-Path $PSScriptRoot 'Workbench.ps1'),$Resolver (Join-Path $hookCheckout 'lib')
               $entry=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $hookCheckout 'lib/Workbench.ps1'),'-Boot')
               $entryObserved=Get-Content -LiteralPath $observation -Raw|ConvertFrom-Json
               if($entry.Exit-ne0){'LAYOUT_ENTRY_DIAGNOSTIC: '+$entry.Text}
               Assert-Layout 'Workbench sets child TEMP and TMP for a nested clone before accepted dispatch' ($entry.Exit-eq0-and$entryObserved.temp-ieq$expected-and$entryObserved.tmp-ieq$expected-and[IO.Path]::GetDirectoryName($entryObserved.script)-ieq(Join-Path $hookTemporary 'judges')-and!(Test-Path -LiteralPath $entryObserved.script))
           }
           $blocker=Join-Path $scratch 'blocked root';Write-LayoutFile $blocker 'file'
           $blocked=Invoke-LayoutChild $gitExe $hookArguments @{WORKBENCH_TEMP_ROOT=$blocker;TMPDIR=$null} $hookCheckout
           Assert-Layout 'hook refuses failed temporary directory materialization' ($blocked.Exit-ne0-and$blocked.Text-match'WB_TEMP_MATERIALIZATION_FAILED')
           # Fail git show after mktemp, while retaining the actual Git-for-Windows hook interpreter.
           $shimBin=Join-Path $scratch 'shim';$gitShell=$gitExe.Replace('\','/')
           Write-LayoutFile (Join-Path $shimBin 'git') ("#!/bin/sh`nif [ `"`$1`" = show ]; then printf partial; exit 1; fi`nexec `"$gitShell`" `"`$@`"`n")
           $shExe=Join-Path (Split-Path (Split-Path $gitExe -Parent) -Parent) 'usr/bin/sh.exe'
           $failedShow=Invoke-LayoutChild $shExe @('-c','PATH="$(cygpath -u "$WS022_SHIM"):$PATH"; export PATH; exec sh .githooks/pre-commit') @{TMPDIR=$null;WS022_SHIM=$shimBin.Replace('\','/');PATH=(Split-Path $shExe -Parent)+';'+$env:PATH} $hookCheckout
           Assert-Layout 'hook trap removes a partially materialized judge on git show failure' ($failedShow.Exit-ne0-and@(Get-ChildItem -LiteralPath $expected -Filter 'workbench-judge-*').Count-eq0)
       }
       if($Probe-eq'all'){
           # Finish's required Hunt in a sandbox clone: no data root beside it -> empty disposable store, never the checkout.
           $huntClone=Join-Path $scratch 'hunt/sb/W22/rehearsal';[void][IO.Directory]::CreateDirectory($huntClone)
           $env:TEMP=$scratch;$env:TMP=$scratch;$env:ORVION_DATA_ROOT=$null
           $store=Get-OrvionFinishHuntDataRoot -Checkout $huntClone
           Assert-Layout 'Finish Hunt in a clone without a data root gets an empty disposable store outside the checkout' ($store-and$store.StartsWith($scratch,[StringComparison]::OrdinalIgnoreCase)-and!$store.StartsWith($huntClone,[StringComparison]::OrdinalIgnoreCase)-and(Test-Path (Join-Path $store 'events') -PathType Container)-and!(Get-ChildItem (Join-Path $store 'events') -Force))
           $installedHunt=Join-Path $scratch 'hunt-installed/ORVION-Workbench';[void][IO.Directory]::CreateDirectory((Join-Path $scratch 'hunt-installed/ORVION-Owner-Tools/events'));[void][IO.Directory]::CreateDirectory($installedHunt)
           Assert-Layout 'Finish Hunt beside a real data store keeps the default' ($null-eq(Get-OrvionFinishHuntDataRoot -Checkout $installedHunt))
           $env:ORVION_DATA_ROOT=$scratch
           Assert-Layout 'Finish Hunt with an explicit ORVION_DATA_ROOT keeps the default' ($null-eq(Get-OrvionFinishHuntDataRoot -Checkout $huntClone))
           $env:ORVION_DATA_ROOT=$null
       }
       if($Probe-eq'all'-and!$NoMutants){
           $resolverText=[IO.File]::ReadAllText($Resolver)
           $resolverAnchor='$temporary=$parent.Parent.Parent.FullName'
           if(!$resolverText.Contains($resolverAnchor)){throw 'LAYOUT_MUTANT_STALE: nested'}
           $mutantResolver=Join-Path $scratch 'mutants/workspace-layout.ps1'
           Write-LayoutFile $mutantResolver ($resolverText.Replace($resolverAnchor,"`$temporary=Join-Path ([IO.Path]::GetTempPath()) 'escaped'"))
           $nestedMutant=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',$PSCommandPath,'-Probe','nested','-Resolver',$mutantResolver,'-NoMutants')
           Assert-Layout 'MUTANT KILLED: nested clone falls outside temporary' ($nestedMutant.Exit-ne0-and$nestedMutant.Text-match'FAIL nested sandbox stays under temporary')
           $hookText=[IO.File]::ReadAllText($Hook);$hookAnchor='judge=$(mktemp "$managed/'
           if(!$hookText.Contains($hookAnchor)){throw 'LAYOUT_MUTANT_STALE: hook'}
           $mutantHook=Join-Path $scratch 'mutants/pre-commit'
           Write-LayoutFile $mutantHook ($hookText.Replace($hookAnchor,'judge=$(mktemp "$WS022_UNMANAGED_ROOT/'))
           $hookMutant=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',$PSCommandPath,'-Probe','hook','-Hook',$mutantHook,'-NoMutants')
           Assert-Layout 'MUTANT KILLED: hook ignores managed temp' ($hookMutant.Exit-ne0-and$hookMutant.Text-match'FAIL hook uses managed temp')
       }
   }finally{
       foreach($key in $savedEnvironment.Keys){[Environment]::SetEnvironmentVariable($key,$savedEnvironment[$key],'Process')}
       $null=Remove-OrvionOwnedTree -Path $scratch -AllowedRoots @($scratchParent)
   }
   if($fail){throw "WORKSPACE_LAYOUT_FAILED: $fail"};'WORKSPACE_LAYOUT PASS'
   ```

   The resulting file's Git blob is a971316a96027c780a898c5493d26fa8697794fc.

38. Check whether `lib/Watch-Subagents.ps1` contains `ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{J`; if so record Already Applied when its Git blob is 0ddabdec89ff10d8e675965a17e46eb7a8162de8, and otherwise stop and report. Otherwise make exactly these 2 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$EventRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}))
   ```
   with
   ```text
         [string]$EventRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'}))
   ```

   b) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   if(!$PSBoundParameters.ContainsKey('EventRoot')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $EventRoot 'events') -PathType Container)){throw 'ORVION_DATA_ROOT_UNAVAILABLE'}
   ```

   The resulting file's Git blob is 0ddabdec89ff10d8e675965a17e46eb7a8162de8.

39. Check whether `lib/Workbench.ps1` contains `$temporaryParent=$null`; if so record Already Applied when its Git blob is 6b086b44fc6a9d4315f1b263fd7fdb1473e82712, and otherwise stop and report. Otherwise make exactly these 6 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
   $temporaryParent=if($env:WORKBENCH_TEMP_ROOT){[IO.Path]::GetFullPath($env:WORKBENCH_TEMP_ROOT)}else{Join-Path ([IO.Path]::GetTempPath()) 'ORVION-Workbench'}
   ```
   with
   ```text
   $temporaryParent=$null
   ```

   b) replace the lines
   ```text
       $Root=[IO.Path]::GetFullPath($Root)
       if($temporaryParent-ieq$Root-or$temporaryParent.StartsWith($Root.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'WB_TEMP_ROOT_INSIDE_CHECKOUT_REFUSED'}
   ```
   with
   ```text
       $Root=[IO.Path]::GetFullPath($Root)
   ```

   c) immediately after the line
   ```text
       if([IO.Path]::GetFullPath($PSCommandPath)-ine(Join-Path $Root 'lib/Workbench.ps1')){throw 'WB_ENTRY_ROOT_MISMATCH'}
   ```
   insert
   ```text
       . (Join-Path $PSScriptRoot 'workspace-layout.ps1')
       $temporaryParent=Initialize-OrvionTemporaryRoot -Checkout $Root
   ```

   d) immediately after the line
   ```text
               [void][IO.Directory]::CreateDirectory($CIRuntimeRoot)
   ```
   insert
   ```text
               $null=Initialize-OrvionTemporaryRoot -Checkout $Root -TemporaryRoot $ciRecipe.Context['Temp Root']
   ```

   e) immediately after the line
   ```text
               $env:WORKBENCH_TEMP_ROOT=$context['Temp Root']
   ```
   insert
   ```text
               $null=Initialize-OrvionTemporaryRoot -Checkout $Root
   ```

   f) replace the line
   ```text
               & pwsh -NoProfile -File (Join-Path $Root 'lib/Hunt.ps1') -Root $Root -Quick -NoRecord
   ```
   with
   ```text
               $huntArguments=@('-NoProfile','-File',(Join-Path $Root 'lib/Hunt.ps1'),'-Root',$Root,'-Quick','-NoRecord')
               $huntData=Get-OrvionFinishHuntDataRoot -Checkout $Root
               if($huntData){$huntArguments+=@('-DataRoot',$huntData);'WORKBENCH_PREFLIGHT: no data root beside this checkout (sandbox/clone); Hunt Quick uses an empty disposable store'}
               & pwsh @huntArguments
   ```

   The resulting file's Git blob is 6b086b44fc6a9d4315f1b263fd7fdb1473e82712.

40. Check whether `lib/workspace-layout.ps1` contains `# Temporary roots only; data-root defaults stay inline in their owning scripts.`; if so record Already Applied when its Git blob is a27fa4dbf9a8e7a7280c2ee11b661ff2e888a2d1, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (One clean layout only), and change nothing else:

   ```text
   # Temporary roots only; data-root defaults stay inline in their owning scripts.
   # WORKBENCH_TEMP_ROOT is an explicit context root. ORVION_STANDALONE_TEMP=1 opts a standalone
   # installation into system temp; hosted runners may use RUNNER_TEMP / GITHUB_ACTIONS=true.
   function Get-OrvionRepositoryCandidates {
       param([string]$GitHub,[string[]]$Skip=@('*-trusted-main','ORVION-Owner-Tools','ORVION-Workbench-temporary','_*'))
       foreach($d in Get-ChildItem -LiteralPath $GitHub -Directory){
           if(@($Skip|Where-Object{$d.Name-like$_}).Count-or!(Test-Path -LiteralPath (Join-Path $d.FullName '.git'))){continue}
           $top="$( & git -C $d.FullName rev-parse --show-toplevel 2>$null )"
           if($LASTEXITCODE-or!$top-or[IO.Path]::GetFullPath($top)-ne$d.FullName){[pscustomobject]@{name=$d.Name;root=$d.FullName;problem='not a readable Git work tree'};continue}
           [pscustomobject]@{name=$d.Name;root=$d.FullName;problem=''}
       }
   }
   function Initialize-OrvionTemporaryRoot {
       param([Parameter(Mandatory)][string]$Checkout,[string]$Target,[string]$TemporaryRoot=$env:WORKBENCH_TEMP_ROOT)
       $checkoutPath=[IO.Path]::GetFullPath($Checkout).TrimEnd('\','/')
       if($TemporaryRoot){
           if(![IO.Path]::IsPathFullyQualified($TemporaryRoot)){throw 'WB_TEMP_ROOT_NOT_ABSOLUTE'}
           $temporary=[IO.Path]::GetFullPath($TemporaryRoot)
       }elseif($Target){
           if(![IO.Path]::IsPathFullyQualified($Target)){throw 'WB_TEMP_TARGET_NOT_ABSOLUTE'}
           $temporary=Join-Path ([IO.Path]::GetFullPath($Target)) 'ORVION-Workbench-temporary'
       }else{
           # Only the exact clone homes bind a checkout to its temporary root: <temporary>\cx\<name> and
           # <temporary>\sb\<WS>\<name>. Anything deeper (a test fixture under a Temp Root) falls through.
           $temporary=$null;$parent=[IO.DirectoryInfo]::new($checkoutPath).Parent
           if($parent-and$parent.Name-ieq'cx'-and$parent.Parent-and$parent.Parent.Name-ieq'ORVION-Workbench-temporary'){$temporary=$parent.Parent.FullName}
           elseif($parent-and$parent.Parent-and$parent.Parent.Name-ieq'sb'-and$parent.Parent.Parent-and$parent.Parent.Parent.Name-ieq'ORVION-Workbench-temporary'){$temporary=$parent.Parent.Parent.FullName}
           # Hosted runners check out into ...\ORVION-Workbench\ORVION-Workbench: their own temp wins over the name rule.
           if(!$temporary-and($env:RUNNER_TEMP-or$env:GITHUB_ACTIONS-eq'true'-or$env:ORVION_STANDALONE_TEMP-eq'1')){
               $hostTemp=if($env:RUNNER_TEMP){$env:RUNNER_TEMP}else{[IO.Path]::GetTempPath()}
               if(![IO.Path]::IsPathFullyQualified($hostTemp)){throw 'WB_TEMP_ROOT_NOT_ABSOLUTE'}
               $temporary=Join-Path $hostTemp 'ORVION-Workbench'
           }
           if(!$temporary-and([IO.Path]::GetFileName($checkoutPath)-in'ORVION-Workbench','ORVION-Workbench-trusted-main')){
               $temporary=Join-Path (Split-Path $checkoutPath -Parent) 'ORVION-Workbench-temporary'
           }
           if(!$temporary){throw 'WB_TEMP_LAYOUT_UNAVAILABLE'}
       }
       $temporary=[IO.Path]::GetFullPath($temporary).TrimEnd('\','/')
       if($temporary-ieq$checkoutPath-or$temporary.StartsWith($checkoutPath+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)){throw 'WB_TEMP_ROOT_INSIDE_CHECKOUT_REFUSED'}
       $managedTemp=Join-Path $temporary 'tmp'
       try{[void][IO.Directory]::CreateDirectory($managedTemp)}catch{throw 'WB_TEMP_MATERIALIZATION_FAILED'}
       $env:TEMP=$managedTemp;$env:TMP=$managedTemp
       $temporary
   }

   # Finish's required Hunt needs a data root. A sandbox or temporary clone has none (no ORVION_DATA_ROOT, no sibling
   # ORVION-Owner-Tools with events\): give it an empty disposable store under the managed temp instead of failing, and
   # never fall back to the checkout. Returns $null when the normal default applies.
   function Get-OrvionFinishHuntDataRoot([Parameter(Mandatory)][string]$Checkout){
       if($env:ORVION_DATA_ROOT){return $null}
       $sibling=Join-Path (Split-Path ([IO.Path]::GetFullPath($Checkout).TrimEnd('\','/')) -Parent) 'ORVION-Owner-Tools'
       if(Test-Path -LiteralPath (Join-Path $sibling 'events') -PathType Container){return $null}
       $store=Join-Path ([IO.Path]::GetTempPath()) ('finish-hunt-data-'+[guid]::NewGuid().ToString('N'))
       foreach($part in 'events','sessions','work'){[void][IO.Directory]::CreateDirectory((Join-Path $store $part))}
       $store
   }

   # Keep these equal to the accepted judge's Get-WorkbenchCITool and provisioning URL.
   # The owning test compares both hashes, version and URL against the judge's actual AST.
   function Get-OrvionTemporaryTool {
       [ordered]@{Version='1.7.12';SHA256='54CA21BE3DE4C7CFA26914AA8B61BD76BF573EF3CAAC5F80D110558CDF241718';ArchiveSHA256='6E7241B51E6817EA6A047693D8E6FED13B31819C9A0DD6C5A726E1592D22F6E9';Url='https://github.com/rhysd/actionlint/releases/download/v1.7.12/actionlint_1.7.12_windows_amd64.zip'}
   }
   function Receive-OrvionTemporaryTool([string]$Uri,[string]$OutFile){
       Invoke-WebRequest -Uri $Uri -OutFile $OutFile
   }
   function Restore-OrvionTemporary([string]$Target){
       if(![IO.Path]::IsPathFullyQualified($Target)){throw 'WB_TEMP_TARGET_NOT_ABSOLUTE'}
       $root=Join-Path ([IO.Path]::GetFullPath($Target)) 'ORVION-Workbench-temporary'
       foreach($name in @('')+@('tmp','cx','sb','tools','restore-staging','codex-relay-logs','scratch','retired')){
           $path=if($name){Join-Path $root $name}else{$root}
           if((Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue).Attributes-band[IO.FileAttributes]::ReparsePoint){throw 'WB_TEMP_REPARSE_REFUSED'}
           [void][IO.Directory]::CreateDirectory($path)
       }
       $tool=Get-OrvionTemporaryTool;$exe=Join-Path $root 'tools/actionlint.exe'
       if(Get-Item -LiteralPath $exe -Force -ErrorAction SilentlyContinue){
           if(!(Test-Path -LiteralPath $exe -PathType Leaf)-or
              (Get-Item -LiteralPath $exe -Force).Attributes-band[IO.FileAttributes]::ReparsePoint-or
              (Get-FileHash -LiteralPath $exe).Hash-cne$tool.SHA256){throw 'WB_TEMP_TOOL_IDENTITY'}
           return $root
       }
       $stage=Join-Path $root ('tools/.provision-'+[guid]::NewGuid().ToString('N'))
       [void][IO.Directory]::CreateDirectory($stage)
       try{
           $archive=Join-Path $stage 'actionlint.zip'
           Receive-OrvionTemporaryTool $tool.Url $archive
           if((Get-FileHash -LiteralPath $archive).Hash-cne$tool.ArchiveSHA256){throw 'WB_TEMP_ARCHIVE_IDENTITY'}
           $zip=[IO.Compression.ZipFile]::OpenRead($archive)
           $candidate=Join-Path $stage 'actionlint.exe'
           try{
               $entries=@($zip.Entries|Where-Object{$_.FullName-ceq'actionlint.exe'})
               if($entries.Count-ne1){throw 'WB_TEMP_TOOL_ENTRY_INVALID'}
               [IO.Compression.ZipFileExtensions]::ExtractToFile($entries[0],$candidate,$false)
           }finally{$zip.Dispose()}
           if((Get-FileHash -LiteralPath $candidate).Hash-cne$tool.SHA256){throw 'WB_TEMP_TOOL_IDENTITY'}
           # Publish only the verified executable; Move refuses a concurrent winner, never overwrites it.
           [IO.File]::Move($candidate,$exe)
           $root
       }finally{if([IO.Directory]::Exists($stage)){[IO.Directory]::Delete($stage,$true)}}
   }
   ```

   The resulting file's Git blob is a27fa4dbf9a8e7a7280c2ee11b661ff2e888a2d1.

41. Check whether `README.md` contains `| ORVION-Workbench | Git source; local engine receipts and owner-requested generated map exceptions |`; if so record Already Applied when its Git blob is c71ce73075fb06f6e4aa6280b30d77fccbacd83e, and otherwise stop and report. Otherwise make exactly these 10 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
   # ORVION Workbench - independent management source
   ```
   with
   ```text
   # ORVION Workbench
   ```

   b) replace the line
   ```text
   Source repository: https://github.com/Shehabhub/ORVION-Workbench (PUBLIC, measured 2026-10-26: never commit owner records, sessions, approvals or anything secret). Current selected checkout: `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench`, an actual Git root. Local `.githooks` must be configured; cloning alone does not install hooks or recover journals/receipts. Existing native repositories remain independent siblings. Managed sandbox/test/temp/runtime stay outside this checkout under the accepted context.
   ```
   with
   ```text
   Independent management source for the owner's ORVION workspace: reviewed tools, tests, governance, contracts and portable engineering knowledge. Source repository: https://github.com/Shehabhub/ORVION-Workbench (PUBLIC, measured 2026-10-26). Never commit secrets, owner records, sensitive sessions or approvals. Gitignore is not backup; unique ignored evidence needs protected external recovery. Essential generated locks can belong in Git; disposable handwritten scratch can be excluded. Native tracked projections retain native authority.
   ```

   c) replace the line
   ```text
   What belongs in Git: reviewed code/tests/governance, contracts, selected portable plans and minimum safe unique authority/assurance knowledge required for reproducibility or continuation. An essential generated lock can be important; disposable handwritten scratch can be excluded. Secrets, sensitive transcripts and unique ignored working evidence need protected external recovery; Gitignore is not backup. This source-only clone does not restore the whole workstation. Generated local search views and disposable runtime are excluded; native tracked projections retain native authority.
   ```
   with
   ```text
   ## Start here
   ```

   d) replace the line
   ```text
   Current plan and layout: [docs/EXECUTION-PLAN.md](docs/EXECUTION-PLAN.md), [docs/WORKSPACE-LAYOUT.md](docs/WORKSPACE-LAYOUT.md). These are the selected canonical source documents after verified WS005 R4 original completion and post-Complete checkpoint cutover. The sole external programme checkpoint owns live progress; prior external plan/layout copies remain history. Do not repeat completed WS005 readiness or cutover. General native management, indexing, consolidated-data cutover, hosted enforcement and clean-Windows recovery remain pending. Old ORVION-Owner-Tools data/archiver is preserved; no parallel blank archive is initialized here.
   ```
   with
   ```text
   Read [RESUME.md](RESUME.md), then [HANDOFF.md](HANDOFF.md) for the Batch 6 closure boundary. For Workbench changes run `pwsh -NoProfile -File lib/Workbench.ps1 -Boot` and follow [WORKFLOW.md](WORKFLOW.md). Use its actual contract or blocked result. Configure local `.githooks`; cloning alone installs neither hooks nor journals/receipts. Each product's own README, AGENTS and Boot decide its authority; this workspace coordinates only explicitly requested combined work.
   ```

   e) replace the line
   ```text
   Stage 3 of the selected plan now requires Workbench-specific GitHub security parity and an independent proposed ORVION-Workbench-trusted-main checkout. These are future acceptance obligations, not activated hosted enforcement or permission to create/configure/publish. See the plan and layout for the exact private-entitlement, trusted-baseline, bootstrap and owner-authorization boundaries.
   ```
   with
   ```text
   ## Three folders
   ```

   f) replace the lines
   ```text
   The remaining dated inventory below is historical context. Prefer the current source plan/checkpoint and actual Boot over its older path/remote/status statements.
   **After any interruption, start at [`RESUME.md`](RESUME.md)**: live resume point, latest session, the two repositories, boundaries.
   ```
   with
   ```text
   | Sibling | Role |
   |---|---|
   | ORVION-Workbench | Git source; local engine receipts and owner-requested generated map exceptions |
   | ORVION-Owner-Tools | One private data store: records, sessions, events, evidence and machine bindings |
   | ORVION-Workbench-temporary | Disposable clones, fixtures, scratch and pinned tools |
   ```

   g) replace the line
   ```text
   **For Workbench's own changes:** run `pwsh -NoProfile -File lib/Workbench.ps1 -Boot` from this root and follow [WORKFLOW.md](WORKFLOW.md). This initial local kernel supplies own admission/Finish/Review; full product supervision and workstation recovery remain separately governed. A product-only entry continues to use that product's own tools.
   ```
   with
   ```text
   Product repositories and trusted clones remain independent siblings. Managed sandbox/test/temp/runtime do not belong inside source. A source clone restores neither the whole workstation nor live certification.
   ```

   h) replace the line
   ```text
   ## Agent orientation (start here after a reinstall or a new session)
   ```
   with
   ```text
   ## Navigation
   ```

   i) replace the lines
   ```text
   You may be a new Claude Code or Codex session with no memory of earlier work. Everything you need is in these files,
   the event journal and the session archive; do not ask the owner to re-explain the project.
   ```
   with
   ```text
   - [Programme plan](docs/EXECUTION-PLAN.md): remaining sequence, dated evidence, publication and acceptance boundaries.
   - [Workspace layout](docs/WORKSPACE-LAYOUT.md): folder roles, named exceptions, retention and migration.
   - [Recovery](docs/RECOVERY.md): package, cloud verification and restore procedures and limits.
   - [Tool catalogue](lib/README.md): Pulse, journal/search/archive, delegation, observers, map and native adapters.
   - [Contract template](changes/TEMPLATE.md): new Workbench proposals; allocated history is indexed in WORKFLOW.
   ```

   j) replace the lines
   ```text
   1. Where things stand: `RESUME.md` (active contract pointer, Pulse command, boundaries), then `HANDOFF.md` once.
   2. Who decides: each repository's own README, AGENTS.md and Boot. Platinum = `..\CRM`, Founder = `..\ORVION`, this
      repository = its own changes only (`lib/Workbench.ps1 -Boot`, `WORKFLOW.md`). Gate 1, publish and promote are the
      owner's unless a recorded owner delegation says otherwise; a delegated decision is labelled delegated.
   3. Learn before acting (enforced: own Finish runs `Events -Find` and `Hunt -Quick` itself; do the same by hand first).
      The ONE journal and session archive use the data root: `ORVION_DATA_ROOT`, else the sibling `ORVION-Owner-Tools`
      when it has `events\`, else this checkout; pass that root as `-Root` (below: `<data>`).
      - `lib\Events.ps1 -Root <data> -Find '<task>'` returns what earlier agents learned, with the session that holds it.
      - `lib\Spider.ps1 -Root <data> '<SPEC, error, script or phrase>'` finds the original evidence across sessions, both products'
        files and commits, memory and owner packets.
      - Find a comparable executed contract in the owning repository (`changes/` here, the product's own contract folder
        there) and copy its proven shape, not its repository-specific rules.
      - `lib\Hunt.ps1 -Quick -NoRecord` (from this checkout) for gaps before a change; the full Hunt only when the change is risky. Bounded, not routine.
      - Label each claim PROVEN (cited evidence), HYPOTHESIS (reasoned, unchecked) or UNVERIFIED (assumed).
   4. Get help: `lib\Delegate.ps1 -Root <data>` writes a bounded brief for a cold agent. A Codex second opinion is advisory only and
      follows `C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\delegate-review\codex-delegate@3aa72d6\ORVION-USAGE.md`
      (`--ignore-user-config`, a disposable push-disabled clone, no commit, network or gh; you verify every claim). It
      never certifies.
   5. Watch, do not poll: `run_timed.ps1` + `watch_run.ps1`, one `Watch-Host.ps1 -ExitWhenPidsGone` for heavy runs,
      `Watch-Subagents.ps1` for background agents (table in `lib\README.md`). Pulse shows the arrival state.
   6. Leave knowledge behind: a confirmed lesson becomes an event (`Events.ps1 -Root <data> -Add`), then graduates to its repository
      home through a contract. Long work writes a dated checkpoint that names the next step, and adds a `RESUME HERE`
      event pointing at it.
   7. Recovery after reinstalling Windows: [docs/RECOVERY.md](docs/RECOVERY.md).
   8. See the whole estate at once (Interactive repository map v1): `lib\Map-Repos.ps1` maps every Git repository under
      the GitHub folder (discovered on each run) into `ai-map.json` and `ai-map.html` in this root (git-ignored, refreshed
      hourly once `-Install` registers its task). `-Links <path>` prints a file's links and backlinks; `-Orphans` lists
      files nothing links to: link a new file from where it belongs so it is never orphaned. A derived view, never authority.

   Not repository authority. Platinum (`..\CRM`, PlatPlusHub/CRM) and Founder (`..\ORVION`, Shehabhub/ORVION) each decide
   through their own Boot, contracts and certification; everything here only drives, observes or preserves them.
   **Never put work inside a repository tree**: an ignored sandbox copy there hid 32 broken references from
   `check_repository_consistency.ps1` (it indexes ignored files), measured 2026-10-19.

   | Folder | What | Git | Backup | Sensitive |
   |---|---|---|---|---|
   | `lib\`, `tests.ps1` | agent tools (index: `lib\README.md`) and their checks | `Shehabhub/ORVION-Workbench`: `workbench-preflight`, then `main` | yes | no |
   | `sessions\raw\` | every ORVION agent session, verbatim (Claude Code + Codex) | never | yes (package, unencrypted by owner decision) | **yes** |
   | `sessions\index.jsonl` | one line per session: id, title, repo cwd, branch, start/end, size, SPECs, raw path, sha256 | never | yes | low |
   | `events\events.jsonl` | improvement memory: what happened, how often, current disposition, evidence pointer | never | yes | low |
   | `work\` | evidence, runs, drafts scratch; `work\sandboxes\` = disposable clones | never | yes (not sandboxes) | low |

   ## Sessions (nothing summarized away)
   - `lib\Sync-Sessions.ps1 -Follow` (started by Claude Code running this checkout's `lib\hooks\Watch-Reminder.ps1`, one instance) copies every session of the workspace
     into `sessions\raw\` under the one data root above once a minute while any Claude Code or Codex process runs, then a last pass when all are gone;
     no session depends on its shutdown hook. Only complete lines are appended, after the archived bytes are proven to be
     a prefix of the source; a killed pass is completed by the next one; a rewritten source keeps the old copy beside it.
     Measured 2026-10-20: about 1 s and 1 s CPU per pass including PowerShell start, 0 bytes lost in the self-check cases.
     Claude Code deletes its own transcripts after 30 days: everything before 2026-10-11 (e.g. session `cbaf43d9`,
     2026-09-12) was already gone when the archive started on 2026-10-20.
   - Find a session: read `sessions\INDEX.md` (newest first: task, minutes, prompts, tools, errors, compactions, agents,
     events, most-discussed SPECs, raw path) or `sessions\index.jsonl`; `lib\Events.ps1 -Find` links each lesson to its session. Search content: Grep over `sessions\raw\` (ripgrep
     handles the size; never `grep -o` a wide window, see events `orphaned-search-process`).
   - Captured: messages, tool calls and results (large results in `tool-results\`), subagent transcripts, hook context,
     Monitor notifications. **Not captured**: hidden model reasoning (only what the client stores), anything a client
     never writes to disk, Codex sessions started outside the workspace, sessions deleted before 2026-10-20.
     Codex has no session hooks: its sessions are picked up at the next Claude session start or a manual sync.
   - `secretHits` / `secretNames` in the index flag credential-shaped strings by name (values never printed or stored).
     The 2026-10-26 secret scan recorded in `docs/RECOVERY.md` found 10 GitHub token shapes in Codex sessions; token shapes do not prove live credentials. Follow its revoke/re-login steps. The raw history stays verbatim (integrity); protection is: never in Git, and the
     recovery package reports secret findings by name (`docs/RECOVERY.md`); BitLocker on C: stays an owner action.

   ## Improvement memory
   `lib\Events.ps1 -Brief` (printed at session start) lists open or recurring patterns; `-Find '<task>'` returns the few
   relevant to a task; `-Add` records one. Watch-Subagents (STALLED) and Watch-Host (COMMIT LOW) record their alarms
   themselves. A pattern recurring across sessions is an investigation candidate, not a task. A confirmed lesson
   graduates to its repository home (or Claude memory) through the normal lifecycle; this log is never authority.

   ## Inventory (measured 2026-10-20)
   | Location | Purpose | Tracked | Backup | Disposable | Restore |
   |---|---|---|---|---|---|
   | `..\CRM`, `..\ORVION` | the repositories; ignored receipts `.orvion-local-certification.json`, `.orvion-certifications\`, `.claude\settings*.json`; **unpushed candidates and `orvion/*-pending` branches exist only here** | yes + ignored state | bundle (all refs) + ignored files + local config | no | `Restore-Workspace.ps1` |
   | `..\CRM-trusted-main`, `..\ORVION-trusted-main` | trusted clones the owner promotes from; per-account credential pin in local config | yes | bundle + config | no | same |
   | this folder | tools, sessions, events, work | no | yes | `work\sandboxes` only | same |
   | `~\.claude\projects\*ORVION/CRM*\memory`, `~\.claude\settings.json`, `statusline.ps1` | Claude memory and hooks | no | yes | no | same (never overwrites) |
   | `~\.codex\sessions` | Codex transcripts | no | via `sessions\raw` | no | archive copy |
   | `Documents\ORVION-Owner-Review` (1.4 GB) | owner packets; **live**: `cr-da-execution-2026-10-19\owner-publish/promote.ps1`, `wave1-2026-10-19\GATE-1-PACKET.md` | no | legacy | no | legacy copy |
   | `Documents\ORVION-Sandbox` (1.4 GB) | evidence, sandboxes and run configs for SPEC-290..293 (its old `lib\` copy was deleted 2026-10-20 after every script was repointed here) | no | legacy (git clones skipped) | its clones | legacy copy |
   | `Documents\ORVION-Owner-Tools` | the owner's **working** Platinum release adapters (`Owner-Publish/Promote.ps1`, used 2026-10-18) + logs; its README explains; same name as this folder by history only | no | legacy | no: merged by the wave-2 release interface | legacy copy |
   | `Documents\ORVION-drafts-backup`, `Documents\Windows-Memory-Config` | 2026-10-12 Draft copies; 2026-10-18 WSL memory config | no | legacy | no | legacy copy |
   | `%TEMP%\orvion-*` | test leftovers | no | no | yes | — |
   | GitHub tokens (`gh`, `%APPDATA%\GitHub CLI`), Supabase CLI login | credentials | never | **never** | — | `gh auth login` for PlatPlusHub and Shehabhub |

   Legacy folders move here only after what depends on them is released (owner scripts, Gate 1 packet, run configs):
   copy, verify hashes, update references, then retire the old path with the owner's OK.

   ## Backup to USB, and recovery
   Reinstalling Windows: use [docs/RECOVERY.md](docs/RECOVERY.md) (one selective package in OneDrive). The USB folder
   backup below remains available:
   1. Turn on BitLocker To Go for the stick (the system drive C: was measured unencrypted, 2026-10-20).
   2. `pwsh -NoProfile -File "<this folder>\lib\Backup-Workspace.ps1" -Destination E:\` → `orvion-backup-<UTC>\` with `SHA256SUMS.txt`.
      Refuses an unencrypted drive; reports a dirty checkout (uncommitted work is not in a bundle).
   3. New machine: install Git, PowerShell 7, gh, Docker/WSL, Supabase CLI per each repository's `README.md`, then
      `pwsh -NoProfile -File E:\orvion-backup-<UTC>\owner-tools\lib\Restore-Workspace.ps1 -From E:\orvion-backup-<UTC>`.
      Verifies every hash first, never overwrites, and restores refs, HEAD, local config, receipts, workspace and memory.
   4. `gh auth login` for both accounts, then Boot in each repository.

   Proof level (2026-10-20): **Simulated** — backup → restore into an empty location → all 4 repositories at their exact
   SHAs with identical refs, clean trees, byte-identical receipts and bound records, and Boot output identical to the
   originals (`ORVION: READY`) apart from timings. Corrupt-backup and existing-target refusals tested. Not yet
   **clean-install proven** (needs Windows Sandbox or a VM: owner action).
   ```
   with
   ```text
   The canonical plan/layout cutover is complete. Old data and frozen evidence stay preserved; remaining management, hosted enforcement and clean-Windows recovery claims require their own evidence. A dated programme snapshot never grants scope or permission to publish, promote or configure a service.
   ```

   The resulting file's Git blob is c71ce73075fb06f6e4aa6280b30d77fccbacd83e.

42. Check whether `RESUME.md` contains `Live state:`; if so record Already Applied when its Git blob is 8d37a0e43c8ccd1da04beac716b08dee5b6df366, and otherwise stop and report. Otherwise make exactly this one edit (One clean layout only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   # ORVION recovery — start here after any interruption

   This file owns the active Workbench contract pointer and routes to the existing programme checkpoint. For Workbench's
   own changes run lib/Workbench.ps1 -Boot and follow WORKFLOW.md. Transcripts and dated HANDOFF snapshots are history;
   each product's own Boot remains its authority. This is not a second programme status report.

   0. **New to this programme (no history)?** Read [`HANDOFF.md`](HANDOFF.md) once: architecture, boundaries, governance,
      lessons, roadmap, owner decisions and the last verified state with its next actions. Then continue here.
   1. **Exact resume point.** Run `pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\lib\Pulse.ps1" -Root "C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools"`.
      Its `in flight` lines name the active work and that work's own `RESUME.md` (last verified checkpoint, ordered resumable
      steps, evidence, blockers, where to stop for the owner). Cannot run commands? Search `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\events\events.jsonl` (the preserved single journal)
      for `RESUME HERE`; the newest such line names the same file.
   2. **Latest session.** Pulse's `last` line names it; every session, newest first, with its raw transcript path:
      `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\sessions\INDEX.md`. Search them all: `lib\Spider.ps1 -Root 'C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools' '<SPEC id, error, script or phrase>'`.
   3. **The programme: one programme, two independent repositories.**
      - Platinum `C:\Users\My Lab\Documents\GitHub\CRM` (PlatPlusHub/CRM) and Founder `C:\Users\My Lab\Documents\GitHub\ORVION`
        (Shehabhub/ORVION). In each: `README.md`, then `AGENTS.md`, then
        `pwsh -NoProfile -File scripts/check_agent_continuity.ps1 -Boot` at its root.
      - The infrastructure programme's order is ADR-0033's Programme sequence (Founder `reports/architecture-decision-records.md`);
        Platinum names it, never copies it.
      - Each repository keeps its own identity, SPEC numbering (the same number names different contracts), contracts,
        receipts, CI, credentials and release. Coordination never merges them: one candidate SHA, one Finish, one exact-SHA
        certification per repository.
   4. **Boundaries.** Nothing is approved until the owner approves an exact SHA-256 (Gate 1); Drafts are committed only then.
      Publish and promote are the owner's (`CR_LIFECYCLE.md` §9). Batch 6 is ON HOLD until the lift record that HANDOFF.md §12 requires; CTRL-19 is OPEN.
      Reinstalling Windows or recovering this workstation: [`docs/RECOVERY.md`](docs/RECOVERY.md) (one unencrypted package in OneDrive, exact steps).
   5. **Before any task.** `lib\Events.ps1 -Root 'C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools' -Find '<task in a few words>'`: what earlier agents learned, with the session that holds it.

   Source/data transition: this checkout is the selected source, with the existing local accepted hook. The old ORVION-Owner-Tools root remains the ONE event/session data store until separately tested migration. Explicit Root arguments above select it; no journal/working receipt is transplanted here. HANDOFF.md is dated history. This routing does not authorize a native operation or certify restored state.

   Active Workbench Contract: changes/WS-022-one-clean-layout.md
   ```
   with
   ```text
   Active Workbench Contract: changes/WS-022-one-clean-layout.md
   Live state: ..\ORVION-Owner-Tools\STATE.md (private; data root resolved by Pulse; see lib/README.md)
   ```

   The resulting file's Git blob is 8d37a0e43c8ccd1da04beac716b08dee5b6df366.

43. Check whether `tests.ps1` contains `$savedDataRoot=$env:ORVION_DATA_ROOT;$savedTemp=$env:TEMP;$savedTmp=$env:TMP`; if so record Already Applied when its Git blob is 352230d5ca925ad96f2e6b8a68a34e3b1c59ff3b, and otherwise stop and report. Otherwise make exactly these 4 edits (One clean layout only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $suiteRoot=$PSScriptRoot
   ```
   insert
   ```text
   $savedDataRoot=$env:ORVION_DATA_ROOT;$savedTemp=$env:TEMP;$savedTmp=$env:TMP
   $testData=$null
   try{
   . (Join-Path $suiteRoot 'lib/workspace-layout.ps1')
   $temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout $suiteRoot
   ```

   b) replace the line
   ```text
   $dataRoot=if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path $PSScriptRoot -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@($PSScriptRoot))[0]}
   ```
   with
   ```text
   $dataRoot=if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path $PSScriptRoot -Parent) 'ORVION-Owner-Tools'}
   ```

   c) replace the line
   ```text
   $env:ORVION_DATA_ROOT=Join-Path $(if($env:WORKBENCH_TEMP_ROOT){$env:WORKBENCH_TEMP_ROOT}else{[IO.Path]::GetTempPath()}) "orvion-test-data-$PID";[void][IO.Directory]::CreateDirectory($env:ORVION_DATA_ROOT)
   ```
   with
   ```text
   $testData=Join-Path $env:TEMP ('orvion-test-data-'+[guid]::NewGuid().ToString('N'))
   $env:ORVION_DATA_ROOT=$testData;[void][IO.Directory]::CreateDirectory($testData)
   ```

   d) immediately after the line
   ```text
   "TESTS: $(if($fail){"$fail FAILED"}else{'all passed'}) in $([int]$sw.Elapsed.TotalSeconds) s"
   ```
   insert
   ```text
   }finally{
       $env:ORVION_DATA_ROOT=$savedDataRoot;$env:TEMP=$savedTemp;$env:TMP=$savedTmp
       if($testData-and(Test-Path -LiteralPath $testData)){
           . (Join-Path $lib 'remove-owned.ps1')
           $null=Remove-OrvionOwnedTree -Path $testData -AllowedRoots @((Join-Path $temporaryRoot 'tmp'))
       }
   }
   ```

   The resulting file's Git blob is 352230d5ca925ad96f2e6b8a68a34e3b1c59ff3b.

44. Check whether `WORKFLOW.md` contains `## Working with Codex`; if so record Already Applied when its Git blob is 0f914d375a76dde94ceeeed254d7c765cd4ec3aa, and otherwise stop and report. Otherwise make exactly these 6 edits (One clean layout only), each matched once, and change nothing else:

   a) replace the line
   ```text
   Create a contract using changes/TEMPLATE.md. Exact scope includes additions, deletions and both sides of renames. Local sessions/events/work and credentials never enter tracked engineering state. Freeze the Design, Adversarial Review and Evidence Refresh snapshots; use three distinct IDs/paths, allowing unchanged successive content. The V3 snapshot's digest is supplied by the owner's exact Gate 1; it does not contain its own hash. Approval evidence must actually identify that digest. This binds local evidence, not authenticated owner identity.
   ```
   with
   ```text
   Create a contract using changes/TEMPLATE.md. Exact scope includes additions, deletions and both sides of renames. Local sessions/events/work and credentials never enter tracked engineering state. Freeze the Design, Adversarial Review and Evidence Refresh snapshots; use three distinct IDs/paths, allowing unchanged successive content. The V3 snapshot's digest is supplied by the owner's exact Gate 1; it does not contain its own hash. Approval evidence must actually identify that digest. This binds local evidence, not authenticated owner identity. Acceptance `check:` clauses are judged feasible at Approval and must still hold at Complete, locally and in CI.
   ```

   b) replace the lines
   ```text

   Observer integrity: Coordinator derives the one event journal, retains valid partial diagnostics but returns UNREADABLE/exit 2 for incomplete required evidence and refuses assignment/closure/dispatch before writes. Technical decisions do not become owner decisions merely by category. Watch-Subagents requires an explicit supported Claude session, masks with the existing library before truncation, exposes missing/unreadable evidence and reports tool-wait cause as UNPROVEN; it never kills, retries or certifies. The optional Watch-Reminder supplies Workbench context only at this root or for an explicit existing Owner-Tools command in that event. Direct-native entry remains independent; archival preserves knowledge separately. These are reporting adapters, not authenticated approval, OS enforcement or a completed general management interface. Reuse one run observer and one shared host observer; report actionable changes immediately and routine long-gate heartbeat at most every five minutes. A late reminder cannot prove earlier live coverage or justify an expensive replay.

   Native stage transport: lib/README.md identifies the existing agent adapters and their evidence limits. An explicit exact config selects one native root/contract; raw Draft SHA256 and destination-filtered blob, clean root, native Boot and normal .githooks precede mutation. Preserve native ACTION/WRITE/START_CONTEXT and refusal output. The existing applier Plan owns creation and literal grammar; scope is checked before writes, only declared paths are staged, and Git owns actual authorship. Native applicability is derived by the native engine, never forced to PASS by this adapter. Appends target legal section names, not an assumed section order. Finish, profiles, tests, receipt validation, Review/Complete and binding remain native; no child test schedule is duplicated. The diagnostic reviewer returns non-success for observed failures or unsupported required evidence and cannot auto-certify descriptive criteria. A post-commit diagnostic refusal requires inspecting actual state before any retry. These bounded adapters are not the general P3 management entry and do not inject dependencies into direct-native operation.

   Post-allocation identity: native transport compares its selected filtered Draft blob with the unique actual Git allocation before native Boot or writes. A self-consistent replacement config/Draft pair grants no authority. Keep original failed proposal/fixtures as evidence and use a new exact candidate rather than substituting frozen bytes.

   ```
   with
   ```text

   ```

   c) replace the line
   ```text
   Arrival reporting: Pulse consumes one Coordinator Snapshot for owner routing and the queue, preserving that classifier's inherited assignment and explicit Readable state. A category named decision alone is not an owner wait. Missing/failed selected repository or required journal evidence yields visible UNREADABLE and Pulse exit2, never a zero-wait or clean substitute. A readable empty journal, unconfigured upstream or dirty tree retains its actual meaning. These observations grant no write permission, certification or universal liveness guarantee; native Boot and the owning exact contract still decide. test-pulse owns the real Git/journal caller fixtures.
   ```
   with
   ```text
   ## Active contract
   ```

   d) immediately after the lines
   ```text
   ## Active contract

   ```
   insert
   ```text
   [RESUME.md](RESUME.md) alone owns the active pointer; it contains exactly the pointer and private live-state route. Programme progress stays in that external state. Run the owning Boot before execution; dated snapshots cannot activate a scope.
   ```

   e) replace the line
   ```text
   Local CI capability: lib/Workbench.ps1 -CI -Candidate <full-lowercase-HEAD-SHA> -CIRuntimeRoot <new-absolute-external-directory> -Actionlint <verified-external-actionlint.exe> runs the existing timed runner and one concurrent watcher, then the existing tests.ps1 schedule once. It requires a clean independent root, exact candidate, real timed ancestry/observer and recipe binding ordered tests, hazard/helper blobs, evaluator, root, runtime, PowerShell/Git and pinned grammar tool/policy. Its internal -CIWorker is not a raw-entry bypass; absent real timed ancestry/observer refuses. The driver child is the actual direct suite parent; environment stamps alone grant no admission. A terminal RESUME None is permitted only in that CI route. A CI_TEST_ONLY result is not a local certification receipt, approval, native Review/Complete, hosted check or trusted candidate judgment. No CI path writes native working/archive receipts or lifecycle metadata. Equal-OS-privilege tampering remains outside the local trust boundary; independent accepted-code judgment and hosted protection remain separate requirements.
   ```
   with
   ```text
   ## Working with Codex
   ```

   f) replace the line
   ```text
   The supported first workflow set is exactly .github/workflows/workbench-acceptance.yml, encoded as the closed JSON subset of YAML returned by Get-WorkbenchWorkflowPolicy. All duplicate/unknown keys, changed branch/triggers, conditions, permissions, action/checkout settings, step commands and missing tests refuse. The upstream actionlint1.7.12 Windows/amd64 executable is pinned by Get-WorkbenchCITool (archive and executable SHA256); supply a verified external copy, never install globally or fetch latest implicitly. Semantic validation and real grammar parsing are both mandatory when a workflow exists; zero workflows is legitimate only for local capability preparation, not hosted parity. The policy contains fixed official-download/archive/binary hash-verified provisioning under RUNNER_TEMP/workbench-tools, followed by the fixed CI entry; this unit creates no workflow or hosted provisioning operation. Native owning CI tests require the pinned external tool through -Actionlint (or WORKBENCH_ACTIONLINT for targeted tests). Future hosted installation must prove its own bootstrap/toolchain/runtime and permission boundaries before freeze. Native CI-profile Finish validates this same grammar/policy before its unchanged owning tests and receipt rules; missing tool or unsupported workflow refuses. WORKSTATION remains blocked. No current private protection, hosted success, release interface or real trusted checkout is asserted. CTRL-19 remains OPEN.
   ```
   with
   ```text
   Use a two-way method: orchestrator and delegate both bring their own proposals, notes and concerns. Record an agreement table (proposal, each side's position, disposition and reason), then a rebuttal round before freezing. Review meaning line by line, rerun owning focused checks and plant independent mutants. Check that a request is sound and worth doing and state the verdict in one line; label claims PROVEN (cited), HYPOTHESIS (reasoned) or UNVERIFIED (assumed). Learn before guessing; earn improvements and simplify without weakening.

   The effort ceiling is xhigh, used only for before-passes; implementation stays at high or below. Choose gpt-6.1-sol for design, adversarial and security work; gpt-6.1-terra for bounded research/checks. Every brief ends with a summary of at most 40 lines.

   Delegates must not read real sessions/events, ~/.claude, ~/.codex or ORVION-Owner-Tools. Use supplied safe source and synthetic fixtures. Disposable delegate clones belong only under ORVION-Workbench-temporary\\cx with independent Git/object storage and push disabled. No commit, push or network by the delegate. Never reset another slice's edits. The orchestrator verifies every claim; delegation is advisory and cannot certify.

   Run focused test files in the owning Finish environment: WORKBENCH_TEMP_ROOT and WORKBENCH_TEST_ROOT under the selected temporary root; TEMP=TMP=<temporary root>\\tmp; WORKBENCH_ACTIONLINT=<temporary sibling>\\tools\\actionlint.exe; ORVION_DATA_ROOT is a new empty folder under that temp. Remove only owned scratch. The owning native Finish alone schedules tests.ps1; a delegate never starts a duplicate full suite.

   ## Markdown consistency

   lib/Test-MarkdownConsistency.ps1 is read-only: Working checks the complete indexed Markdown inventory against working bytes; Index or an explicit Git tree checks its blobs. Empty/unreadable inputs refuse. Local Markdown links and anchors in living docs resolve from their source, case-sensitively, with no basename search. Absolute/URI/sibling private pointers are opaque external references, never probed. Frozen contracts and indexed history retain original source-bound citations.

   Every tracked Markdown file must be reachable from README/AGENTS through local links or listed exactly once in the history index below. Allocated contracts (changes/WS-NNN-*.md) are history by name, since a contract file appears only at its own allocation; any other file under changes/ must be reachable. Index entries must exist. The one-home table has one row per concept and one sole target. RESUME's two-line format has no heading, so its target is the file itself.

   Root word limits (whitespace-delimited; LF/CRLF equivalent): AGENTS 100, README 400, RESUME 120, HANDOFF 600, WORKFLOW 2400. Only RESUME may declare the active pointer in living docs, including code fences. Exact duplicate prose paragraphs of at least 25 words refuse among living docs; fenced code, contracts and indexed history are excluded. Header update/amendment dates cannot precede body amendments. Retired entry paths refuse as instructions, including fenced commands. Explicit non-executable historical citations may retain them; approved STATE.md/records pointers remain external. The history index accepts only allocated contracts and docs/history, never living files.

   ## One-home table

   | Concept | Sole home |
   |---|---|
   | Arrival | [AGENTS](AGENTS.md#orvion-workbench--agents-start-here) |
   | Purpose | [README](README.md#orvion-workbench) |
   | Active contract | [RESUME](RESUME.md) |
   | Batch 6 closure | [HANDOFF](HANDOFF.md#12-success-criteria-before-the-programme-closes-and-batch-6-resumes) |
   | Governance | [WORKFLOW](WORKFLOW.md#workbench-local-workflow) |
   | Programme plan | [Plan](docs/EXECUTION-PLAN.md#1-read-this-first-authority-and-continuity) |
   | Workspace layout | [Layout](docs/WORKSPACE-LAYOUT.md#1-three-folder-boundary) |
   | Recovery | [Recovery](docs/RECOVERY.md#workbench-recovery-before-and-after-reinstalling-windows) |
   | Tool catalogue | [Tools](lib/README.md#orvion-agent-tools-tracked-local-workbench-tools-workspace-readmemd) |
   | Contract template | [Template](changes/TEMPLATE.md#workbench-change-request---ws-nnn) |

   ## History index

   - [WS-001-workbench-local-governance.md](changes/WS-001-workbench-local-governance.md)
   - [WS-002-execution-context-binding.md](changes/WS-002-execution-context-binding.md)
   - [WS-003-observer-integrity.md](changes/WS-003-observer-integrity.md)
   - [WS-004-native-stage-integrity.md](changes/WS-004-native-stage-integrity.md)
   - [WS-005-arrival-source-readiness.md](changes/WS-005-arrival-source-readiness.md)
   - [WS-006-plan-reconciliation.md](changes/WS-006-plan-reconciliation.md)
   - [WS-007-local-ci.md](changes/WS-007-local-ci.md)
   - [WS-008-hosted-acceptance.md](changes/WS-008-hosted-acceptance.md)
   - [WS-009-hosted-ci-diagnostics.md](changes/WS-009-hosted-ci-diagnostics.md)
   - [WS-010-source-scaffold.md](changes/WS-010-source-scaffold.md)
   - [WS-011-optional-claude-input.md](changes/WS-011-optional-claude-input.md)
   - [WS-013-workbench-recovery-coverage.md](changes/WS-013-workbench-recovery-coverage.md)
   - [WS-014-knowledge-plan-continuity.md](changes/WS-014-knowledge-plan-continuity.md)
   - [WS-015-selective-recovery-package.md](changes/WS-015-selective-recovery-package.md)
   - [WS-016-interactive-repository-map.md](changes/WS-016-interactive-repository-map.md)
   - [WS-017-trustworthy-agent-answers.md](changes/WS-017-trustworthy-agent-answers.md)
   - [WS-018-trustworthy-preservation.md](changes/WS-018-trustworthy-preservation.md)
   - [WS-019-one-data-root.md](changes/WS-019-one-data-root.md)
   - [WS-020-trustworthy-archiver.md](changes/WS-020-trustworthy-archiver.md)
   - [WS-021-workbench-robustness.md](changes/WS-021-workbench-robustness.md)
   - [WS-023-recovery-launcher.md](changes/WS-023-recovery-launcher.md)
   - [environment-recovery-original.md](docs/history/programme/environment-recovery-original.md)
   - [execution-plan-pre-git-v1.4.md](docs/history/programme/execution-plan-pre-git-v1.4.md)
   - [programme-handoff-original.md](docs/history/programme/programme-handoff-original.md)
   - [workbench-acceptance-v10.md](docs/history/programme/workbench-acceptance-v10.md)
   ```

   The resulting file's Git blob is 0f914d375a76dde94ceeeed254d7c765cd4ec3aa.

## Acceptance Criteria

- [ ] Exact approved scoped output. check: blob:.githooks/pre-commit=eaf7682a43493279eeb786b2ef746e669eec3191
- [ ] Exact approved scoped output. check: blob:AGENTS.md=ea8fdf7acef489dbcddb870b0670679baa4d51ed
- [ ] Exact approved scoped output. check: blob:changes/TEMPLATE.md=8daa5a6d81a5921a074cbf01e9f187b3b34af3c2
- [ ] Exact approved scoped output. check: blob:docs/EXECUTION-PLAN.md=55ebfa5da39752c74010083a0825547e75b59de5
- [ ] Exact approved scoped output. check: blob:docs/RECOVERY.md=66f998d97231e5e8e48c7b44f1963b15f3ebf590
- [ ] Exact approved scoped output. check: blob:docs/WORKSPACE-LAYOUT.md=d77fe0c40c9a7b04a961d3162ae38976c55e3da9
- [ ] Exact approved scoped output. check: blob:HANDOFF.md=786c8c6ac5e21fbda63dc0df45fbca7fa5faa6c9
- [ ] Exact approved scoped output. check: blob:lib/Backup-Workspace.ps1=02400ebb0d2a78f81472bac65104ee32c891a552
- [ ] Exact approved scoped output. check: blob:lib/Coordinator.ps1=0dbb346bbcb7d9e70941dd701e2ea5415f6603fb
- [ ] Exact approved scoped output. check: blob:lib/Delegate.ps1=0ed83ab1c36c924274c3209e9e382beef0d98826
- [ ] Exact approved scoped output. check: blob:lib/Events.ps1=c378107bf82bc1fc9b8466c2f90b9045420ea685
- [ ] Exact approved scoped output. check: blob:lib/hooks/Watch-Reminder.ps1=c818b92fbb424777a81eb0d6a4baa034ad89630f
- [ ] Exact approved scoped output. check: blob:lib/Hunt.ps1=2b6e7209ebec580edd0c1919d4d52e18dc6bf43d
- [ ] Exact approved scoped output. check: blob:lib/Invoke-DraftRehearsal.ps1=a862e2530992dfec0d9ee01fbed3d9229c13244f
- [ ] Exact approved scoped output. check: blob:lib/Map-Repos.ps1=72d8ae37e3ddf915aadc0e4f2b1b03ba1c409005
- [ ] Exact approved scoped output. check: blob:lib/Pulse.ps1=1be958f0d7a55969d82f00593a0f0b4d495aa286
- [ ] Exact approved scoped output. check: blob:lib/README.md=7cf9dc0bbc327fda396e0aefb6dd18c830dff227
- [ ] Exact approved scoped output. check: blob:lib/Restore-ORVION.ps1=2b4b43e1087aa4040c48f622716ba44266b73d33
- [ ] Exact approved scoped output. check: blob:lib/Restore-Workspace.ps1=6918d2f702c4fea8ad0b43a759582a17bac9d886
- [ ] Exact approved scoped output. check: blob:lib/Spider.ps1=e2f7076d7aaada2eddf5a7f539676f7a07b1b3ca
- [ ] Exact approved scoped output. check: blob:lib/Sync-Sessions.ps1=6e665874eb1483fdf091b7535f800b35b3f221aa
- [ ] Exact approved scoped output. check: blob:lib/test-backup-restore.ps1=754b870715c378cec0efc0b6d5371764029ea9d3
- [ ] Exact approved scoped output. check: blob:lib/test-coordinator.ps1=6a25f6c3482ec46be317b14e299dfb9e3114e0b4
- [ ] Exact approved scoped output. check: blob:lib/test-events.ps1=079e1c877aedb16298c250b6ddcec1c18b607128
- [ ] Exact approved scoped output. check: blob:lib/test-hunt.ps1=5432ff2270dd81af62a1e4eb481567d4817d8a41
- [ ] Exact approved scoped output. check: blob:lib/test-map-repos.ps1=0a9f5f1ba28abb883a131f78c2920bc8fdea009b
- [ ] Exact approved scoped output. check: blob:lib/test-markdown-consistency.ps1=9ddde5f1184eae7b1ae270c88bf081e29a8a1a7d
- [ ] Exact approved scoped output. check: blob:lib/Test-MarkdownConsistency.ps1=668c26bc7af50c374901711179c2a58b77f8a795
- [ ] Exact approved scoped output. check: blob:lib/test-pulse.ps1=64ef04898b3af58d5fca07079e850dbe18c268f0
- [ ] Exact approved scoped output. check: blob:lib/test-restore-orvion.ps1=893ace7c23be8e74ff76554110a7cbc664addafc
- [ ] Exact approved scoped output. check: blob:lib/Test-ScriptHazards.ps1=968a8f7f57ee92ca827fe1ce7185e3ea19f0e320
- [ ] Exact approved scoped output. check: blob:lib/test-spider.ps1=65bf2e351ce12a9a7deac97a91ba241680af9fa8
- [ ] Exact approved scoped output. check: blob:lib/test-sync-sessions-ack.ps1=5ddb06d697cafd49348c625c14d77bcf3663b3ab
- [ ] Exact approved scoped output. check: blob:lib/test-sync-sessions-survival.ps1=e31e9416ff1e4107e557ce61de8239c7e9e4862b
- [ ] Exact approved scoped output. check: blob:lib/test-watch-reminder.ps1=024a376875d84aae42934d391093b33b06390cdf
- [ ] Exact approved scoped output. check: blob:lib/test-workbench-governance.ps1=4125825db2f267ef809fa3498a88fa8cb692032d
- [ ] Exact approved scoped output. check: blob:lib/test-workspace-layout.ps1=a971316a96027c780a898c5493d26fa8697794fc
- [ ] Exact approved scoped output. check: blob:lib/Watch-Subagents.ps1=0ddabdec89ff10d8e675965a17e46eb7a8162de8
- [ ] Exact approved scoped output. check: blob:lib/Workbench.ps1=6b086b44fc6a9d4315f1b263fd7fdb1473e82712
- [ ] Exact approved scoped output. check: blob:lib/workspace-layout.ps1=a27fa4dbf9a8e7a7280c2ee11b661ff2e888a2d1
- [ ] Exact approved scoped output. check: blob:README.md=c71ce73075fb06f6e4aa6280b30d77fccbacd83e
- [ ] Exact approved scoped output. check: blob:tests.ps1=352230d5ca925ad96f2e6b8a68a34e3b1c59ff3b
- [ ] Exact approved scoped output. check: blob:WORKFLOW.md=0f914d375a76dde94ceeeed254d7c765cd4ec3aa
- [ ] RESUME is the active pointer plus one line to the private live state. check: normalized-resume:RESUME.md=80E4319AB22909E36CDBDCEE4E0910835A6837D23B0C3E544E0FCAB0017B4AEE
- [ ] The owning tests prove every slice: exact clone-home temp binding and Finish-environment fixtures; data-root refusal without checkout writes; restore staging containment, credential-word masking, fixed diagnostics, lazy winget, final-only READY; records-based package/restore, memory junctions, .git refusal; -Temporary skeleton and pinned actionlint identity; sidecar lock alias contention and survival; Events current-row dedupe, repo auto-fill and alias filter; Pulse masked footer and map freshness; Hunt map-task guard; scanner dot-invoke fallback; Spider default repositories; Markdown guard rules on fixtures and on this repository.
- [ ] Mandatory V1/V2/V3, focused proof on all 27 suites with the orchestrator's independent planted mutants, accepted literal replay controls and Test B (temporary deleted and rebuilt) are preserved. One isolated native timed/watched Finish owns the grown full schedule (two new suites, two new scripts) with a fresh SANDBOX receipt before original approval; the original needs its own fresh Finish, live Review, native Complete and an independent carrying-range READY.

## Review Gate

- [ ] Inspect the scoped files, the focused/mutant/literal evidence, the meaning-preservation audit and Test B; preserve all frozen prior evidence.
- [ ] Independently check the native receipt root/Draft/recipe/evaluator/fingerprint, ordered tests and timed/watcher/host exits; normal native Review/Complete and every new carrying transition must pass. No second-agent or provider certification is claimed.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Decision D27 in C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\delegation-20261026\DECISIONS.md (under D19-D26 and the owner's 2026-10-27 standing order). Codex investigated at xhigh (before pass) and implemented slices at high (Sol) in the disposable prototype; Terra assisted audits; every slice re-verified by the orchestrator (records\WS-022\*-review.md). Under the owner's exceptional delegation this one Workbench contract is authorized. Gate 1 for this Draft is DELEGATED: the owner did not type its digest. Sandbox approval is synthetic and grants no original authority.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-022\package\assurance\V3\DRAFT.md
Approved SHA256: D82689C72FB0480A95BC906640370D46B348C2DE54C9A34CFF409E577CF59F47
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\delegation-20261026\GATE1-WS022-DELEGATED.md
Owner Evidence SHA256: E3B49735FA76D2831CA07C4B312850AA78CF974E11508635B0B5A38AEC33ECC2
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-022\package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 1282CCB4989B89AA7C339CD68685F1B6154C9C7B1F2F072FBE61F0FDDC5B3F0E
Original admission: DELEGATED exact Gate 1 under the owner's exceptional delegation of 2026-10-26 (OWNER-DELEGATION.md SHA-256 94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217; decisions D1-D27; D27 is the delegated decision for this contract). The owner did not type this digest. Bound to this literal root, the exact V3 digest and the fresh sandbox receipt; no sandbox receipt transplant as original certification.

## Verification Notes

Profiles RECOVERY+CONTROL+COORDINATION+REPOSITORY, never WORKSTATION. The orchestrator's planted mutants (package\Run-Evidence.ps1) are each killed by their own named assertion; hazard scan 0; all 27 suites PASS with an isolated ORVION_DATA_ROOT in the Finish environment (focused-selected.log). Test B and the real launcher run against a fresh package follow; they are not claimed here.

## Selection reasons and sources

Evidence Refresh: per-slice reviews (slice1/234/569/7-review.md), the meaning-preservation audit, the final 27-suite focused proof with planted mutants and hazard scan 0. Baseline a3c5f2b (main = WS-023), accepted judge 835E14DA unchanged.

Sources: DECISIONS.md D19-D27, records\WS-022\*, accepted WORKFLOW/TEMPLATE/checker, WS-023 packet scripts.
