# Workbench recovery: before and after reinstalling Windows

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
| One data root: `ORVION_DATA_ROOT`, else sibling `ORVION-Owner-Tools` when it has `events\`, else this checkout: sessions archive, events journal, work | Clean nested clones (each keeps `.clone-state\state.json`: origin, HEAD, refs) |
| Documents\ORVION-Owner-Review, -Owner-Tools, -Owner-Recovery, -Sandbox, -drafts-backup, Windows-Memory-Config | node_modules (reinstalled from lockfiles) |
| Per nested clone: its ignored files in place, `.clone-state\unique.bundle` (HEAD and every tip the main bundles lack), `staged.diff`, `worktree.diff`, `untracked\` | Claude/Codex program files, plugins, other projects' transcripts |
| Claude settings, statusline and ORVION project memory; declared recovery inputs (owner approvals, sealed proofs) | Everything outside the folders listed on the left |

The package refuses (no archive) rather than lose state a bundle cannot carry: uncommitted work, more than one stash or
a linked worktree in a main repository, or files under the one data root's `work\sandboxes`. Commit or remove them first.

Not in this package and NOT regenerable by it: `C:\Users\My Lab\Marketing-MCP` (the copy Codex's marketing MCP
servers use) and the older `Documents\GitHub\Marketing-MCP` (neither is a Git repository; both hold Google credentials
under `credentials\`: keep them in OneDrive Personal Vault or re-create them with `gcloud auth application-default login`),
`%USERPROFILE%\.codex\config.toml` (MCP servers and project trust; copy it, it holds no token values), `%USERPROFILE%\.codex` and `.claude` transcripts of non-ORVION projects, and anything else you keep outside
the folders above. Copy what you need separately before reinstalling.

## Before reinstalling (in this order)

1. Make the package straight into OneDrive (an agent may run this). The recovery-input map in use is
   `C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\recovery-inputs.json`.
   `pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\lib\Backup-Workspace.ps1" -Destination "C:\Users\My Lab\OneDrive\ORVION-Recovery" -RecoveryInputs "<map above>" -Package`
   Record the `PACKAGE:` line (path, size, SHA256) and read the `SECRET SCAN:` report (see above). If a run is
   interrupted, delete any `%TEMP%\orvion-package-*` folder by hand. Keep the newest two or three packages; delete older.
2. Prove the cloud copy, not the sync icon: wait until OneDrive is idle, free the local copy
   (`attrib +U -P "<archive>"`, Files On-Demand), read it again so OneDrive downloads it, and compare `Get-FileHash`
   with the `PACKAGE:` line. Alternatively download it from onedrive.live.com on another device.
3. Prove the restore before wiping anything: restore once from the cloud copy into empty separate folders (add
   `-Target`, `-ClaudeHome`, `-LegacyTarget` under a new empty folder), run the Boots there, then delete that test folder.
4. Have sign-in details for: Microsoft account, GitHub accounts PlatPlusHub and Shehabhub (with 2FA), Supabase, Claude,
   OpenAI/Codex, Google (Marketing).
5. Copy anything from "Not in this package" that you want to keep.

## After reinstalling

Create the Windows user with the same name, `My Lab`: restored hooks, settings and Claude memory folders name
`C:\Users\My Lab\...` absolutely. With another name those live paths must be repaired by hand; historical receipts keep
their original roots either way.

1. Sign in to OneDrive with the same Microsoft account; wait until `OneDrive\ORVION-Recovery` has the archive (or
   download it from onedrive.live.com). Check its SHA256 against the recorded `PACKAGE:` line (`Get-FileHash`).
2. Install the toolchain: PowerShell 7.6.x, Git for Windows 2.54.x, 7-Zip, GitHub CLI
   (`winget install Microsoft.PowerShell Git.Git 7zip.7zip GitHub.cli`), then `git config --global core.longpaths true`
   (evidence paths exceed 260 characters). Workbench requires the external actionlint 1.7.12 Windows/amd64 executable pinned by `Get-WorkbenchCITool` (archive and executable SHA256), supplied via `-Actionlint` or `WORKBENCH_ACTIONLINT` for targeted tests, as required by `WORKFLOW.md`; never fetch latest implicitly. Optional scoop tools used by product checks: gitleaks, supabase, trivy.
3. Get the restore tool from GitHub (the repository is public; `gh auth login` as Shehabhub is still needed later), into a temporary folder:
   `git clone https://github.com/Shehabhub/ORVION-Workbench C:\ORVION-Temp\workbench`
   Without GitHub access: `7z x <archive> -oC:\ORVION-Temp\open`, then
   `git clone C:\ORVION-Temp\open\orvion-backup-<UTC>\repos\ORVION-Workbench.bundle C:\ORVION-Temp\workbench` and run
   step 4 with `-From C:\ORVION-Temp\open\orvion-backup-<UTC>` instead of `-Package`; delete `C:\ORVION-Temp\open` after.
4. Restore (refuses to overwrite anything):
   `pwsh -NoProfile -File C:\ORVION-Temp\workbench\lib\Restore-Workspace.ps1 -Package "<path>\orvion-backup-<UTC>.7z"`
   It rebuilds `Documents\GitHub\*` with identical refs, HEAD, receipts and safe config, then ORVION-Owner-Tools,
   Claude memory/settings and the Documents\ORVION-* folders. Delete `C:\ORVION-Temp\workbench` afterwards; if the
   restore was interrupted, also delete `%TEMP%\orvion-restore-*`.
5. Credentials: first, for PlatPlusHub and for Shehabhub, revoke the old GitHub CLI authorization on github.com
   (Settings > Applications > Authorized OAuth Apps > GitHub CLI > Revoke): archived sessions contain token-shaped
   strings (secret scan of 2026-10-26: 10 GitHub token shapes in Codex sessions), and revoking kills every old token
   at once. Then `gh auth login` for PlatPlusHub and for Shehabhub (the restored git config keeps each repository's
   per-account credential pin); `supabase login`; sign in to Claude Code and Codex.
6. Verify, in order: `pwsh -NoProfile -File scripts\check_agent_continuity.ps1 -Boot` in CRM and in ORVION must print
   `ORVION: READY`; `pwsh -NoProfile -File lib\Workbench.ps1 -Boot` in ORVION-Workbench must print `WORKBENCH: READY`;
   Restore places the data store at `<GitHub>\ORVION-Owner-Tools` (`<GitHub>` is Restore's `-Target`, or
   `%USERPROFILE%\Documents\GitHub` by default). If `ORVION_DATA_ROOT` was set before recovery, unset it or point it
   to that restored directory before starting hooks or readers. Then run Pulse with `-Root` set to that store.
   Claude Code runs this checkout's `lib\hooks\Watch-Reminder.ps1`; it starts the session archiver (`lib\Sync-Sessions.ps1`) with that data root.
   If Hunt reports `BUG sync-errors`, inspect `<data>\work\sync-errors.log` and address its cause. To acknowledge
   exactly those reviewed bytes, obtain `Get-FileHash -LiteralPath '<data>\work\sync-errors.log' -Algorithm SHA256`, then
   run `pwsh -NoProfile -File lib\Sync-Sessions.ps1 -Root '<data>' -AcknowledgeErrors -ExpectedSHA256 '<hash>' -Reason '<what was reviewed and its disposition>'`.
   This requires an explicit data root and nonempty reason. A short log lock serializes error appends with acknowledgement;
   the command verifies a new readonly archive under `<data>\work\`, appends and verifies its journal event, then retires
   the matching active log. A stale hash or any archive/event/retirement failure returns exit 3 and retains the active log.
   Keep the archive and journal in the recovery package. Subsequent failures create a new active log and block Hunt again;
   rerun `lib\Hunt.ps1 -Root '<checkout>' -DataRoot '<data>' -Quick -NoRecord` to observe the current result.
7. Record the result as the clean-machine recovery proof (HANDOFF §12, C2) with the Boot outputs. Only then may the
   Batch 6 hold be lifted.
8. A nested clone is rebuilt only when needed. Clone its `state.json` origin, or the restored main repository it
   descends from if that origin is gone. The bundle's prerequisites are commits held by the restored main repositories
   together, not necessarily by one: if the fetch below reports a missing prerequisite, first fetch the other restored
   main repositories into the rebuilt clone (`git fetch <Documents\GitHub\name> '+refs/*:refs/main-<name>/*'`). If `.clone-state\unique.bundle` exists: `git fetch <bundle> '+refs/*:refs/restored/*'`,
   plus `git fetch <bundle> HEAD` only when `git bundle list-heads <bundle>` lists HEAD (it is bundled only when unique).
   Check out its recorded HEAD, then `git apply --index staged.diff` and `git apply worktree.diff` where they exist,
   copy `untracked\` back, and copy its restored ignored files (receipts, evidence) into the rebuilt folder. Keep a
   sandbox's push disabled: `git remote set-url --push origin DISABLED`.

## Not yet proven

- Recovery on a clean Windows installation (C2) until step 7 above succeeds.
- Confidentiality of the package: it is unencrypted by owner decision; it is as private as the OneDrive account.
- The secret scan finds known token shapes in files only; Git history inside the `*.bundle` files is not scanned, and a
  clean report does not prove the archive holds no secret.
- Reflogs are not kept (bundles carry refs): a commit reachable only from a reflog, such as a reset or deleted sandbox
  branch, is not preserved. Give it a branch first if it matters.
- Historical receipts keep their original physical roots; restoring them does not re-certify anything.
- OneDrive sync is not versioned backup: a deleted or overwritten package is lost after the recycle-bin period.
- CTRL-19 remains OPEN: both gh tokens are reachable by this OS user; protection depends on GitHub settings.
