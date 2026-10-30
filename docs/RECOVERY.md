# Workbench recovery: before and after reinstalling Windows

Updated 2026-10-30 (WS027 V3 candidate, not installed approval). [Workspace layout](WORKSPACE-LAYOUT.md) owns the source/private/disposable boundary.

Owner procedure. GitHub alone does not restore this workstation: sessions, the event journal, ignored receipts,
approvals, evidence and Claude memory exist only locally. The selected coverage below travels in ONE compressed package
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
| Explicit reviewed recovery-input files with approved hashes; no automatic inclusion of former legacy directories | node_modules (reinstalled from lockfiles), former legacy directories unless explicitly inventoried |
| Required evidence retained in the data root or declared as recovery inputs | Disposable nested clones, their ignored/uncommitted files and unique refs not preserved elsewhere; Claude/Codex program files and plugins |
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
   interrupted, inspect its owned staging under the managed temporary root. Retain verified packages; there is no automatic pruning. Disposal needs separate owning authority and retention checks.
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
a READY/ACTION checklist and pauses. Owner-selected Candidate C (2026-10-28) intentionally retains staging on both
success and failure. READY requires every requested mandatory operation and the checklist to succeed; a failure keeps
its failure exit and withholds READY. Output names the absolute owned staging path, its completed/failed status and purpose.
Each default attempt uses a new timestamp-plus-GUID child of `<Target>\ORVION-Workbench-temporary\restore-staging`.
An explicit existing staging folder is refused without alteration. Attempts accumulate; inspect their reported locations.
Staging must remain outside permanent Git repositories, Owner-Tools, Claude/Codex homes and known OneDrive roots,
including managed reparse aliases. Managed path checks are not atomic namespace protection. Native mapped/subst and
unknown sync providers are not comprehensively identified; do not use those aliases to place retained recovery data.

Before extraction the launcher reads `7z l -slt -ba` entry sizes and snapshots available bytes on the staging volume.
It requires the summed expanded logical bytes plus a separate 64 MiB allowance for metadata/allocation headroom;
unreadable/malformed evidence or insufficient space refuses before extraction with a disk action. This is not a
compressed-size multiplier, a space reservation, exact physical allocation accounting, or a guarantee of capacity for
later clone, restore and product work. Check additional free space for those operations separately.

Retained extraction is sensitive and unencrypted: owner records/sessions, settings and Git bundles can contain secrets.
URL-password masking and credential exclusions do not prove otherwise; gitleaks scans files, not bundle history.
Use an owner-controlled local location with appropriate existing access protection; keep it outside sync and repositories.
The launcher does not change ACLs or machine settings. Review accumulated attempts after verification and obtain separate
owner authorization before disposal. Retained housekeeping alone does not make an otherwise successful restore fail.
The launcher's `Restore-Workspace -From` route does not run the child's independent `-Package` extraction cleanup;
Backup/Restore-Workspace cleanup is unchanged.

Complete the printed actions: revoke old GitHub CLI OAuth authorizations for PlatPlusHub and Shehabhub before
`gh auth login` for both; `supabase login`; Claude/Codex sign-in; Docker first run; WSL admin/reboot if reported.
Re-enter the **two masked local postgres passwords** in `~\.codex\config.toml`; merge `config.toml.restored` if present.
Restore Marketing-MCP from OneDrive Personal Vault and run its own tunnel installer. Follow the printed missing-plugin
marketplace/install commands (GitKraken uses its own CLI/hook installer). For manual map-task recovery use
`pwsh -File <Target>\ORVION-Workbench\lib\Map-Repos.ps1 -Install -GitHub <Target>`.
Use `<Target>\ORVION-Owner-Tools` as the data root; repair/unset an old `ORVION_DATA_ROOT` before hooks or readers. Persistent recovery inputs are restored under `records\recovery-inputs`, including the original source map. Claude project memory is stored under `records\claude-memory\<project>` and restored to each client through a verified junction. Memory destinations are preflighted before repository writes: conflicting directories, wrong or dangling foreign links refuse; an existing junction must target exactly that project's restored memory. This explicit memory adapter does not permit junctions to hide a persistent destination inside disposable staging.

Rebuild disposable storage with `pwsh -NoProfile -File <Target>\ORVION-Workbench\lib\Restore-Workspace.ps1 -Temporary -Target <Target>`. This narrow route needs no package or private journal and provisions the verified pinned `<Target>\ORVION-Workbench-temporary\tools\actionlint.exe`; it refuses corrupt existing bytes. Actionlint is required for owning workflow checks, not an optional global install. Set WORKBENCH_ACTIONLINT to that executable for focused tests.

The launcher invokes both the narrow -Temporary rebuild and Map-Repos -Install after restore. The latter registers the hourly/logon refresh task and returns without generating ai-map.html/json. Run `pwsh -NoProfile -File <Target>\ORVION-Workbench\lib\Map-Repos.ps1 -GitHub <Target>` explicitly when immediate map generation is required. Those outputs are named source-root exceptions. Use the explicit commands above for manual fallback or an owning failed-step recovery. A restored task or map is discovery evidence, never certification. The daily backup task needs its own explicit registration below.

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
Use new empty paths; restore never overwrites repositories. Retain staging for review and separately owner-authorized disposal; run CRM/ORVION
`workstation.cmd`, and complete the same checklist above. Use the -Temporary route above for required pinned actionlint. Session archive error acknowledgement remains documented in
[lib/README.md](../lib/README.md) (keep its acknowledgement archive and journal).

Historical packages only: if an older package actually contains `.clone-state` evidence, rebuild a nested clone only when needed from its `.clone-state\state.json` origin (or the restored main repository
if that origin is gone). If `unique.bundle` needs prerequisites, fetch the restored main repositories first:
`git fetch <Target>\<name> '+refs/*:refs/main-<name>/*'`. Then `git fetch <unique.bundle> '+refs/*:refs/restored/*'`,
plus `git fetch <unique.bundle> HEAD` only if `git bundle list-heads <unique.bundle>` lists HEAD. Check out the recorded
HEAD, run `git apply --index staged.diff` and `git apply worktree.diff` where present, and copy `untracked\` and the
restored ignored files back. Keep a sandbox's push disabled: `git remote set-url --push origin DISABLED`.

## Daily backup opt-in and observation

WS027 V3 extends the existing engine with explicit `-Install`; an ordinary backup does not register or start a task.
After exact native admission, supply reviewed absolute paths in this interface (angle-bracket values are operator inputs, not executable examples):

`pwsh -NoProfile -File <durable-checkout>\lib\Backup-Workspace.ps1 -Install -Package -Destination <folder> -RecoveryInputs <map.json> -DataRoot <data-root> -TemporaryRoot <managed-temporary> -RuntimePath <installed-pwsh.exe> -ExecutionLimitMinutes <measured-limit> -DailyAt 02:00`

The destination must be an absolute child folder, never a volume/share root. An existing USB child folder such as
`E:\ORVION-Recovery\` remains valid; root refusal avoids drive-relative normalization and a status folder inside the output.
The ancestor metadata walk refuses PowerShell LinkType Junction or SymbolicLink. A ReparsePoint flag with null LinkType,
as in the supplied approved OneDrive metadata, is allowed. This does not prove other reparse tags safe, resolve all
namespace/volume aliases, prevent path changes between checks and use, or prove cloud hydration/access/atomicity.
Output/status must not overlap copied sources or the recovery map. The task is daily, StartWhenAvailable, IgnoreNew, interactive current user, limited
privilege. Logged-out execution, missed-trigger behavior and actual ScheduledTasks/runtime compatibility are
NOT_YET_PROVEN. No password, elevation, runtime installation, task execution or automatic deletion is added.
One shared OS file handle excludes manual and scheduled publishers at the destination. An abandoned
`<destination>.status/operation.lock` file is not an active lease; do not remove a live publisher's lock.

Read `Backup-Workspace.ps1 -Destination <folder> -Status`. The JSON envelope separates `applicationState` and
`application` from `scheduler`. Application bytes come from `<destination>.status/latest.json`: attempt runId,
UTC start/end, duration, RUNNING/SUCCESS/FAILURE, sanitized errorCode, and lastVerified package path/hash/runId/map
reference. This is the last persisted application attempt, never a claim about the latest Scheduler outcome.
Binding, root/overlap/reparse preflight and install refusals may occur without a record. Hard termination can leave
RUNNING; status-write failure can leave prior bytes. NEVER_RECORDED and UNREADABLE are explicit observations.

The Scheduler section reads only the destination-derived task name at `\`, checks description/account/principal,
then reads Get-ScheduledTaskInfo's LastRunTime, LastTaskResult and NextRunTime. READBACK_ONLY is observation,
not complete action/configuration verification; `configurationVerified` remains false. Foreign identity yields
OWNERSHIP_COLLISION; absent/unavailable module/task/info yields UNAVAILABLE, not success. Correlate timestamps,
task/action/account and application runId during actual proof. A newer launch/preflight failure must not be described
as a fresh success because an older application SUCCESS exists. Scheduler exit zero alone does not verify an archive.

For installation ownership and status attribution, Windows resolves short or qualified account names to a SID;
a reported SID is parsed directly. Only the current Windows user's SID matches. Foreign, empty, malformed or
unresolvable identities refuse ownership; lookup/access failure grants no fallback. Description, limited interactive
principal and one-action checks remain, with exact executable/arguments required for replacement.

lastVerified advances only after archive test/hash, staging cleanup, launcher copies and hash-sidecar publication.
A successful directory backup does not advance it. Refusal, partial publication and interruption retain the previous
verified pointer and archive. Scanner findings/failure/skipping do not block successful publication or pointer advancement;
previous archives remain retained. Status replacement is one same-directory
move; local failure preservation is tested, cloud/remote atomicity and crash durability are unproven. Failed pending
records/partial archives can remain for inspection. Nothing prunes archives. Scan findings,
failure or skipping are report-only; Git history inside bundles is outside scan coverage. Concurrent source changes
are possible: this is not a coherent snapshot. Shared restore launchers and second-resolution archive-name refusal
remain engine limitations. Candidate C launcher's staging retention above is unchanged and separate.

### Durable recovery inputs and runtime

The owner/reviewer supplies and approves the map; no script generates approval by recomputing changed hashes.
Keep it and its input files in durable owner-selected private records, for example
`<data-root>/records/recovery-inputs-approved/map.json`, outside disposable tools/fixtures. Schema 1 is
`{"schema":1,"inputs":[{"name":"required-proof","path":"C:\\durable\\proof.json","sha256":"<64 uppercase hexadecimal characters>"}]}`.
Inputs must be a nonempty array with unique lowercase names matching `[a-z][a-z0-9-]{0,47}`, absolute file paths and
approved uppercase SHA256. Record each entry's producer, purpose, durable original location, map location and approved
map/file hashes in the owning reviewed inventory. Existing receipt and journal requirements still apply. The engine
checks original and copied bytes; it refuses missing/changed inputs. The map path in status is only a reference.
Restore puts approved files at `<Target>/ORVION-Owner-Tools/records/recovery-inputs/<name>` and the source inventory
in that directory's source-map.json (or a hash-suffixed source map when retaining an earlier map). Review recovered
paths and explicitly author/approve a durable map for the new configuration; old physical paths are historical.

Use an existing supported installed absolute pwsh.exe, a durable Workbench checkout, durable data root and map.
Installation refuses runtime/script/map/data under ORVION-Workbench-temporary or the supplied temporary root and
refuses output/input overlap. These bounded lexical/reparse checks do not detect every alias or guarantee future
availability. Approved input files' individual durability remains an inventory/proof obligation. Portable 7.6.8 is a
test dependency only. Installed Store 7.6.9 is a possible runtime only after its exact path/version/account access,
module loading, encoded action and readback are actually proven. No tool-tree copy or installation is implied.
Changed runtime/action paths intentionally fail exact ownership matching on reinstall. Inspect the exact task,
description/account/action/destination, then use its admitted owning lifecycle to remove only the verified owned
registration and explicitly re-register/re-prove reviewed inputs. Never replace a foreign task. No removal is done here.

### Required execution proof

Actual scheduled success, scheduled controlled refusal, durable installed runtime and production execution limit:
NOT_YET_PROVEN. Synthetic direct-action/mock results are feasibility only. Before each owning live native Review/Complete,
measure a complete representative run including packaging, verification, staging cleanup and publication, choose
headroom against the real workload, and read back the selected execution limit. A fixture duration cannot bound the
owner workspace. After exact admission let an owned near-term trigger actually fire success and then a controlled
refusal, capture correlated Scheduler/application results, and independently verify/hash/restore the successful package
and prove refusal preserves it. Inspect the daily definition separately. Direct invocation/manual task start/mock
registration cannot substitute. Sandbox proof covers synthetic roots; original durable configuration and representative
workload need their own Gate and root-bound receipt before original Review/Complete. Full native gates and the two
independent fresh same-candidate reviews remain mandatory. No clean-machine or cloud recovery proof is claimed.

## Not yet proven

The separate USB route remains available: Backup-Workspace -Destination <absolute USB child folder> requires an encrypted drive and reports a dirty checkout (uncommitted work is not in a bundle). Enable BitLocker To Go before that route. Restore-Workspace -From <backup> verifies every manifest hash before writes, never overwrites, and restores refs/HEAD, safe local configuration and bound records. Re-login to both GitHub accounts and run each owning Boot afterward. The earlier backup/restore fixture proved identical refs, bytes and expected Boots, plus corrupt/existing-target refusals; that simulated proof never established clean-Windows recovery. System-drive BitLocker remains an owner choice, distinct from the unencrypted package decision.

- Recovery on a clean Windows installation, including the launcher's tool installs: accepted as residual risk by the owner on 2026-10-27.
- Confidentiality of the package: it is unencrypted by owner decision; it is as private as the OneDrive account.
- The secret scan finds known token shapes in files only; Git history inside the `*.bundle` files is not scanned, and a
  clean report does not prove the archive holds no secret.
- Reflogs are not kept (bundles carry refs): a commit reachable only from a reflog, such as a reset or deleted sandbox
  branch, is not preserved. Give it a branch first if it matters.
- Historical receipts keep their original physical roots; restoring them does not re-certify anything.
- OneDrive sync is not versioned backup: a deleted or overwritten package is lost after the recycle-bin period.
- CTRL-19 remains OPEN: both gh tokens are reachable by this OS user; protection depends on GitHub settings.
