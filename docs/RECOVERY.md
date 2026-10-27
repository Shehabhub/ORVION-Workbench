# Workbench recovery: before and after reinstalling Windows

Updated 2026-10-27. [Workspace layout](WORKSPACE-LAYOUT.md) owns the source/private/disposable boundary.

Owner procedure. GitHub alone does not restore this workstation: sessions, the event journal, ignored receipts,
approvals, evidence, unique sandbox commits and Claude memory exist only locally. They travel in ONE compressed package
made by `lib\Backup-Workspace.ps1 -Package` and restored by `lib\Restore-Workspace.ps1 -Package`. Credential stores
(gh/Supabase/Claude/Codex logins, Windows Credential Manager) are deliberately not packaged; this file says how each is
recovered.

The package is NOT encrypted: owner decision of 2026-10-26, recoverability and simplicity first. Anyone who can read the
OneDrive folder can read the transcripts and evidence inside it. To make that risk visible, the package step runs a
gitleaks scan and writes `<archive>.secret-scan.txt` beside the archive: rule, file and line of each finding, never the
value. Read it before uploading. A finding that is a live credential is revoked or rotated at its provider (the
recovery never needs it: every login is redone after reinstall); a value you must keep goes to OneDrive Personal Vault,
not into this folder. Never put the package or its scan in a Git repository.

## What the package holds and what it leaves out

| Holds (verified by SHA256SUMS.txt inside the archive) | Leaves out (regenerable or owner-held) |
| --- | --- |
| Every ref of CRM, ORVION, both trusted clones, ORVION-Workbench and its trusted clone (bundles), their ignored receipts and safe local git config | Credential stores and logins (re-login, below) |
| One private data root resolved as documented in [lib/README.md](../lib/README.md): records, sessions, events and protected working evidence | Disposable temporary tree: rebuild clones, fixtures, scratch and tools |
| Reviewed retained legacy inputs and Windows-Memory-Config; historical source locations below | node_modules (reinstalled from lockfiles) |
| Per nested clone: its ignored files in place, `.clone-state\unique.bundle` (HEAD and every tip the main bundles lack), `staged.diff`, `worktree.diff`, `untracked\` | Claude/Codex program files, plugins, other projects' transcripts |
| Claude settings, statusline and ORVION project memory; Codex config.toml (URL passwords masked); declared recovery inputs (owner approvals, sealed proofs) | Everything outside the folders listed on the left |

The package refuses (no archive) rather than lose state a bundle cannot carry: uncommitted work, more than one stash or
a linked worktree in a main repository, or files under the one data root's `work\sandboxes`. Commit or remove them only under their owning authority first. Protected records/runtime and required unique evidence remain package inputs; disposable temporary trees are excluded.

Historical citation: Documents\ORVION-Owner-Review, Documents\ORVION-Owner-Tools, Documents\ORVION-Owner-Recovery, Documents\ORVION-Sandbox, Documents\ORVION-drafts-backup and Documents\Windows-Memory-Config were the retained legacy inputs. Their sealed paths are provenance, not current entry routes.

Not in this package and NOT regenerable by it: `C:\Users\My Lab\Marketing-MCP` (the copy Codex's marketing MCP
servers use) and the older `Documents\GitHub\Marketing-MCP` (neither is a Git repository; both hold Google credentials
under `credentials\`: keep them in OneDrive Personal Vault or re-create them with `gcloud auth application-default login`),
`%USERPROFILE%\.codex` and `.claude` transcripts of non-ORVION projects, and anything else you keep outside
the folders above. Copy what you need separately before reinstalling.

## Before reinstalling (in this order)

1. Make the package straight into OneDrive (an agent may run this). Select the actual reviewed recovery-input map from the owning private records; do not guess a relocated filename.
   `pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\lib\Backup-Workspace.ps1" -Destination "C:\Users\My Lab\OneDrive\ORVION-Recovery" -RecoveryInputs "<reviewed map>" -Package`
   Keep the archive, its `.sha256` and both `Restore-ORVION` launcher files together. Record the `PACKAGE:` line
   (path, size, SHA256) and read the `SECRET SCAN:` report (see above). If a run is
   interrupted, inspect its owned staging under the managed temporary root before removing it. Keep the newest two or three packages; retire older copies only after required evidence/retention checks.
2. Prove the cloud copy, not the sync icon: wait until OneDrive is idle, free the local copy
   (`attrib +U -P "<archive>"`, Files On-Demand), read it again so OneDrive downloads it, and compare `Get-FileHash`
   with the `PACKAGE:` line. Alternatively download it from onedrive.live.com on another device.
3. Prove the restore before wiping anything: restore once from the cloud copy into empty separate folders (add
   `-Target`, `-ClaudeHome`, `-LegacyTarget`, `-CodexHome` under a new empty folder), run the Boots there, then delete that test folder.
4. Have sign-in details for: Microsoft account, GitHub accounts PlatPlusHub and Shehabhub (with 2FA), Supabase, Claude,
   OpenAI/Codex, Google (Marketing).
5. Copy anything from "Not in this package" that you want to keep.

## After reinstalling

Sign in to OneDrive, open `OneDrive\ORVION-Recovery`, and double-click **Restore-ORVION.cmd**.
Use the same Windows profile, `C:\Users\My Lab`; the launcher refuses a different or unrecorded source profile unless
`-AllowNewProfile` is supplied. If winget is missing, install App Installer from Microsoft Store and rerun.

The launcher installs only missing Git, 7-Zip and PowerShell, requires the newest archive's `.sha256` (no older-package
fallback), hydrates/verifies it, and extracts once under the selected ORVION-Workbench-temporary staging root. It clones the package's own Workbench
bundle at its recorded branch/head, runs Restore-Workspace and each product's unchanged `workstation.cmd`, then prints
a READY/ACTION checklist and pauses. Restore failure retains staging for diagnosis; restore success removes staging.
An existing staging folder is refused; inspect a failed/partial restore before removing anything or retrying.

Complete the printed actions: revoke old GitHub CLI OAuth authorizations for PlatPlusHub and Shehabhub before
`gh auth login` for both; `supabase login`; Claude/Codex sign-in; Docker first run; WSL admin/reboot if reported.
Re-enter the **two masked local postgres passwords** in `~\.codex\config.toml`; merge `config.toml.restored` if present.
Restore Marketing-MCP from OneDrive Personal Vault and run its own tunnel installer. Follow the printed missing-plugin
marketplace/install commands (GitKraken uses its own CLI/hook installer). For manual map-task recovery use
`pwsh -File <Target>\ORVION-Workbench\lib\Map-Repos.ps1 -Install -GitHub <Target>`.
Use `<Target>\ORVION-Owner-Tools` as the data root; repair/unset an old `ORVION_DATA_ROOT` before hooks or readers. Persistent recovery inputs are restored under `records\recovery-inputs`, including the original source map. Claude project memory is stored under `records\claude-memory\<project>` and restored to each client through a verified junction. Memory destinations are preflighted before repository writes: conflicting directories, wrong or dangling foreign links refuse; an existing junction must target exactly that project's restored memory. This explicit memory adapter does not permit junctions to hide a persistent destination inside disposable staging.

Rebuild disposable storage with `pwsh -NoProfile -File <Target>\ORVION-Workbench\lib\Restore-Workspace.ps1 -Temporary -Target <Target>`. This narrow route needs no package or private journal and provisions the verified pinned `<Target>\ORVION-Workbench-temporary\tools\actionlint.exe`; it refuses corrupt existing bytes. Actionlint is required for owning workflow checks, not an optional global install. Set WORKBENCH_ACTIONLINT to that executable for focused tests.

The launcher invokes both the narrow -Temporary rebuild and Map-Repos -Install after restore. The latter restores the hourly/logon refresh task and regenerates ai-map.html/json, the named source-root exceptions. Use the explicit commands above for manual fallback or an owning failed-step recovery. A restored task or map is discovery evidence, never certification.

Run `pwsh -NoProfile -File scripts\check_agent_continuity.ps1 -Boot` in CRM and ORVION: both must print `ORVION: READY`.
Run `pwsh -NoProfile -File lib\Workbench.ps1 -Boot` in Workbench: require `WORKBENCH: READY`.
Record the restore result and all three Boot outputs. (Lift criterion 5 in HANDOFF section 12 was amended by the owner
on 2026-10-27: no reinstallation is planned. Clean-Windows recovery remains unproven until a real reinstall succeeds.)

### Manual fallback

Profile paths: with a different Windows user, repair absolute hooks, settings and Claude memory paths by hand;
historical receipts retain their original physical roots. `-AllowNewProfile` acknowledges this step, it does not rewrite paths.
For alternate empty roots the launcher accepts `-Target`, `-ClaudeHome`, `-LegacyTarget`, `-CodexHome`, `-Staging`,
`-PackageDir`, and `-SkipProducts` (product preparation then remains manual).

If the launcher is unavailable: install Git, 7-Zip and PowerShell; verify `Get-FileHash <archive>` against the `.sha256`;
extract once with `7z x <archive> -o<temporary>\pkg`. Clone
`<temporary>\pkg\orvion-backup-<UTC>\repos\ORVION-Workbench.bundle` into `<temporary>\wb`, check out its
`backup.json` branch/head, then run
`pwsh -NoProfile -File <temporary>\wb\lib\Restore-Workspace.ps1 -From <temporary>\pkg\orvion-backup-<UTC>`.
Use new empty paths; restore never overwrites repositories. Delete staging after success, run CRM/ORVION
`workstation.cmd`, and complete the same checklist above. Use the -Temporary route above for required pinned actionlint. Session archive error acknowledgement remains documented in
[lib/README.md](../lib/README.md) (keep its acknowledgement archive and journal).

Rebuild a nested clone only when needed: clone its `.clone-state\state.json` origin (or the restored main repository
if that origin is gone). If `unique.bundle` needs prerequisites, fetch the restored main repositories first:
`git fetch <Target>\<name> '+refs/*:refs/main-<name>/*'`. Then `git fetch <unique.bundle> '+refs/*:refs/restored/*'`,
plus `git fetch <unique.bundle> HEAD` only if `git bundle list-heads <unique.bundle>` lists HEAD. Check out the recorded
HEAD, run `git apply --index staged.diff` and `git apply worktree.diff` where present, and copy `untracked\` and the
restored ignored files back. Keep a sandbox's push disabled: `git remote set-url --push origin DISABLED`.

## Not yet proven

The separate USB route remains available: Backup-Workspace -Destination <drive> requires an encrypted drive and reports a dirty checkout (uncommitted work is not in a bundle). Enable BitLocker To Go before that route. Restore-Workspace -From <backup> verifies every manifest hash before writes, never overwrites, and restores refs/HEAD, safe local configuration and bound records. Re-login to both GitHub accounts and run each owning Boot afterward. The earlier backup/restore fixture proved identical refs, bytes and expected Boots, plus corrupt/existing-target refusals; that simulated proof never established clean-Windows recovery. System-drive BitLocker remains an owner choice, distinct from the unencrypted package decision.

- Recovery on a clean Windows installation, including the launcher's tool installs: accepted as residual risk by the owner on 2026-10-27.
- Confidentiality of the package: it is unencrypted by owner decision; it is as private as the OneDrive account.
- The secret scan finds known token shapes in files only; Git history inside the `*.bundle` files is not scanned, and a
  clean report does not prove the archive holds no secret.
- Reflogs are not kept (bundles carry refs): a commit reachable only from a reflog, such as a reset or deleted sandbox
  branch, is not preserved. Give it a branch first if it matters.
- Historical receipts keep their original physical roots; restoring them does not re-certify anything.
- OneDrive sync is not versioned backup: a deleted or overwritten package is lost after the recycle-bin period.
- CTRL-19 remains OPEN: both gh tokens are reachable by this OS user; protection depends on GitHub settings.
