# Workbench Change Request - WS-023

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

## Objective

One double-click recovery entry: Backup-Workspace -Package records sourceUserProfile, masks URL passwords in a packaged copy of Codex config.toml before SHA256SUMS is written, and only after a verified archive places Restore-ORVION.cmd/.ps1 and an <archive>.sha256 sidecar beside it. Restore-ORVION (Windows PowerShell 5.1, ASCII) installs only missing Git, 7-Zip and PowerShell via winget, verifies the newest archive against its sidecar with no older-package fallback, refuses an existing staging folder or a different/unrecorded source profile, extracts once, clones the packaged Workbench bundle at its recorded head, runs Restore-Workspace (which now restores the masked Codex config copy-once), removes staging only on success, runs each product's unchanged workstation.cmd unless -SkipProducts, and prints a READY/ACTION checklist. HANDOFF section 12 criterion 5 and RECOVERY.md record the owner's 2026-10-27 no-reinstall decision.

## Baseline

55662e74df59ad2acc5bc0748fdb619bf8b5c658

## Write Scope

- RESUME.md
- HANDOFF.md
- docs/RECOVERY.md
- lib/Backup-Workspace.ps1
- lib/README.md
- lib/Restore-ORVION.cmd
- lib/Restore-ORVION.ps1
- lib/Restore-Workspace.ps1
- lib/test-backup-restore.ps1
- lib/test-restore-orvion.ps1

## Out of Scope

All other engineering paths except native allocation/status/pointer bookkeeping. No checker (Test-WorkbenchChange.ps1), applier, workflow, WORKFLOW.md, TEMPLATE, GitHub setting, user setting or product repository change. No WORKSTATION-profile path: the Workbench workstation.cmd and its CONTROL verifier are deferred to WS-024. No credential is packaged; the masked postgres passwords are re-entered by the owner. RESUME.md content beyond native bookkeeping is not changed. CTRL-19 stays OPEN; Batch 6/Phase 8 stay ON HOLD until the owner's lift record; clean-Windows recovery stays UNPROVEN (residual risk accepted by the owner).

## Draft Assurance

V1: WS023-RECOVERY-LAUNCHER-DESIGN | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws023-package\assurance\V1\DRAFT.md | FD7FCE5348693524F25B9C4AF816BE125F26DF1ADC363EBB84E0ABAD308C743E
V2: WS023-RECOVERY-LAUNCHER-ADVERSARIAL | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws023-package\assurance\V2\DRAFT.md | 5A80333241E89B1D03DE462B4FB9D4D0C7A707D4B6FC79C69E1BDEB6F656CC57
V3: WS023-RECOVERY-LAUNCHER-REFRESH | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws023-package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSrec23
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSrec23\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSrec23\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws023-package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `HANDOFF.md` contains `amended by the owner 2026-10-27`; if so record Already Applied when its Git blob is 985962343c449af088ac2096293b520b01e946d7, and otherwise stop and report. Otherwise make exactly this one edit (Recovery launcher only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   5. C2: the owner's planned Windows reinstallation is the clean-machine recovery proof; it is performed by
      `docs/RECOVERY.md` and is UNPROVEN until its restore and Boots succeed there.
   ```
   with
   ```text
   5. C2, amended by the owner 2026-10-27 (no Windows reinstallation): C1 on package
      orvion-backup-20261026T201821Z.7z (SHA256 BC28B482F6E101D40D3DD2E9DA5690C122589350804F64FE59BC612D8E9F0203; cloud
      re-download matched; isolated restore; CRM, ORVION and Workbench Boots READY), plus one isolated run of the released
      `lib/Restore-ORVION.cmd` launcher against a fresh package. Clean-machine tool installation stays UNPROVEN: residual risk accepted by the owner.
   ```

   The resulting file's Git blob is 985962343c449af088ac2096293b520b01e946d7.

2. Check whether `docs/RECOVERY.md` contains `Restore-ORVION.cmd`; if so record Already Applied when its Git blob is bb3526d7e4ed93c34fd9875b7e1930eba449fb67, and otherwise stop and report. Otherwise make exactly these 6 edits (Recovery launcher only), each matched once, and change nothing else:

   a) replace the line
   ```text
   | Claude settings, statusline and ORVION project memory; declared recovery inputs (owner approvals, sealed proofs) | Everything outside the folders listed on the left |
   ```
   with
   ```text
   | Claude settings, statusline and ORVION project memory; Codex config.toml (URL passwords masked); declared recovery inputs (owner approvals, sealed proofs) | Everything outside the folders listed on the left |
   ```

   b) replace the line
   ```text
   `%USERPROFILE%\.codex\config.toml` (MCP servers and project trust; copy it, it holds no token values), `%USERPROFILE%\.codex` and `.claude` transcripts of non-ORVION projects, and anything else you keep outside
   ```
   with
   ```text
   `%USERPROFILE%\.codex` and `.claude` transcripts of non-ORVION projects, and anything else you keep outside
   ```

   c) replace the line
   ```text
      Record the `PACKAGE:` line (path, size, SHA256) and read the `SECRET SCAN:` report (see above). If a run is
   ```
   with
   ```text
      Keep the archive, its `.sha256` and both `Restore-ORVION` launcher files together. Record the `PACKAGE:` line
      (path, size, SHA256) and read the `SECRET SCAN:` report (see above). If a run is
   ```

   d) replace the line
   ```text
      `-Target`, `-ClaudeHome`, `-LegacyTarget` under a new empty folder), run the Boots there, then delete that test folder.
   ```
   with
   ```text
      `-Target`, `-ClaudeHome`, `-LegacyTarget`, `-CodexHome` under a new empty folder), run the Boots there, then delete that test folder.
   ```

   e) replace the lines
   ```text
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
   ```
   with
   ```text
   Sign in to OneDrive, open `OneDrive\ORVION-Recovery`, and double-click **Restore-ORVION.cmd**.
   Use the same Windows profile, `C:\Users\My Lab`; the launcher refuses a different or unrecorded source profile unless
   `-AllowNewProfile` is supplied. If winget is missing, install App Installer from Microsoft Store and rerun.

   The launcher installs only missing Git, 7-Zip and PowerShell, requires the newest archive's `.sha256` (no older-package
   fallback), hydrates/verifies it, and extracts once into the new `C:\ORVION-Temp`. It clones the package's own Workbench
   bundle at its recorded branch/head, runs Restore-Workspace and each product's unchanged `workstation.cmd`, then prints
   a READY/ACTION checklist and pauses. Restore failure retains staging for diagnosis; restore success removes staging.
   An existing staging folder is refused; inspect a failed/partial restore before removing anything or retrying.

   Complete the printed actions: revoke old GitHub CLI OAuth authorizations for PlatPlusHub and Shehabhub before
   `gh auth login` for both; `supabase login`; Claude/Codex sign-in; Docker first run; WSL admin/reboot if reported.
   Re-enter the **two masked local postgres passwords** in `~\.codex\config.toml`; merge `config.toml.restored` if present.
   Restore Marketing-MCP from OneDrive Personal Vault and run its own tunnel installer. Follow the printed missing-plugin
   marketplace/install commands (GitKraken uses its own CLI/hook installer), then run
   `pwsh -File <Target>\ORVION-Workbench\lib\Map-Repos.ps1 -Install`.
   Use `<Target>\ORVION-Owner-Tools` as the data root; repair/unset an old `ORVION_DATA_ROOT` before hooks or readers.

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
   extract once with `7z x <archive> -oC:\ORVION-Temp\pkg`. Clone
   `C:\ORVION-Temp\pkg\orvion-backup-<UTC>\repos\ORVION-Workbench.bundle` into `C:\ORVION-Temp\wb`, check out its
   `backup.json` branch/head, then run
   `pwsh -NoProfile -File C:\ORVION-Temp\wb\lib\Restore-Workspace.ps1 -From C:\ORVION-Temp\pkg\orvion-backup-<UTC>`.
   Use new empty paths; restore never overwrites repositories. Delete staging after success, run CRM/ORVION
   `workstation.cmd`, and complete the same checklist above. Workbench's pinned external actionlint requirement remains
   in WORKFLOW.md; it is not installed by recovery. Session archive error acknowledgement remains documented in
   [lib/README.md](../lib/README.md) (keep its acknowledgement archive and journal).

   Rebuild a nested clone only when needed: clone its `.clone-state\state.json` origin (or the restored main repository
   if that origin is gone). If `unique.bundle` needs prerequisites, fetch the restored main repositories first:
   `git fetch <Target>\<name> '+refs/*:refs/main-<name>/*'`. Then `git fetch <unique.bundle> '+refs/*:refs/restored/*'`,
   plus `git fetch <unique.bundle> HEAD` only if `git bundle list-heads <unique.bundle>` lists HEAD. Check out the recorded
   HEAD, run `git apply --index staged.diff` and `git apply worktree.diff` where present, and copy `untracked\` and the
   restored ignored files back. Keep a sandbox's push disabled: `git remote set-url --push origin DISABLED`.
   ```

   f) replace the line
   ```text
   - Recovery on a clean Windows installation (C2) until step 7 above succeeds.
   ```
   with
   ```text
   - Recovery on a clean Windows installation, including the launcher's tool installs: accepted as residual risk by the owner on 2026-10-27.
   ```

   The resulting file's Git blob is bb3526d7e4ed93c34fd9875b7e1930eba449fb67.

3. Check whether `lib/Backup-Workspace.ps1` contains `sourceUserProfile=$env:USERPROFILE`; if so record Already Applied when its Git blob is 3d9a1fed2671bcffa937933c915e3905f99e0408, and otherwise stop and report. Otherwise make exactly these 5 edits (Recovery launcher only), each matched once, and change nothing else:

   a) replace the line
   ```text
   $plan=[ordered]@{created=[DateTime]::UtcNow.ToString('o');machine=$env:COMPUTERNAME;repos=@()};$bundledTips=@{}
   ```
   with
   ```text
   $plan=[ordered]@{created=[DateTime]::UtcNow.ToString('o');machine=$env:COMPUTERNAME;sourceUserProfile=$env:USERPROFILE;repos=@()};$bundledTips=@{}
   ```

   b) immediately after the line
   ```text
   Copy-Tree "$env:USERPROFILE\.claude\statusline.ps1" (Join-Path $out 'claude')
   ```
   insert
   ```text
   # Recovery settings only: retain MCP names/trust, mask URL passwords before the manifest hashes these bytes.
   $codexConfig=Join-Path $env:USERPROFILE '.codex\config.toml'
   if(Test-Path -LiteralPath $codexConfig -PathType Leaf){
       $codexOut=Join-Path $out 'codex';New-Item -ItemType Directory $codexOut -Force|Out-Null
       $masked=[IO.File]::ReadAllText($codexConfig)-replace'://([^:/@\s]+):([^@\s]*)@','://${1}:***@'
       [IO.File]::WriteAllText((Join-Path $codexOut 'config.toml'),$masked,[Text.UTF8Encoding]::new($false))
   }
   ```

   c) immediately after the line
   ```text
       $archive=Join-Path $Destination ((Split-Path $out -Leaf)+'.7z');if(Test-Path -LiteralPath $archive){throw "exists: $archive"}
   ```
   insert
   ```text
       # A stale success marker must not survive a failed attempt at this archive name.
       if(Test-Path -LiteralPath "$archive.sha256"){Remove-Item -LiteralPath "$archive.sha256"}
   ```

   d) replace the line
   ```text
       $packageLine="PACKAGE: $archive $([math]::Round((Get-Item $archive).Length/1MB,1)) MB SHA256 $((Get-FileHash -LiteralPath $archive).Hash) (unencrypted; staging removed)"
   ```
   with
   ```text
       $hash=(Get-FileHash -LiteralPath $archive).Hash
       $packageLine="PACKAGE: $archive $([math]::Round((Get-Item $archive).Length/1MB,1)) MB SHA256 $hash (unencrypted; staging removed)"
   ```

   e) replace the line
   ```text
   if($packageLine){$scanLine;$packageLine}
   ```
   with
   ```text
   if($packageLine){
       # Publish the recovery entry only after verification, hashing AND staging cleanup succeeded.
       try{
           foreach($launcher in 'Restore-ORVION.cmd','Restore-ORVION.ps1'){Copy-Item -LiteralPath (Join-Path $PSScriptRoot $launcher) -Destination (Join-Path $Destination $launcher) -Force}
           [IO.File]::WriteAllText("$archive.sha256",("$hash *"+(Split-Path $archive -Leaf)+[Environment]::NewLine),[Text.Encoding]::ASCII)
       }catch{if(Test-Path -LiteralPath "$archive.sha256"){Remove-Item -LiteralPath "$archive.sha256"};throw}
       $scanLine;$packageLine
   }
   ```

   The resulting file's Git blob is 3d9a1fed2671bcffa937933c915e3905f99e0408.

4. Check whether `lib/README.md` contains `Restore-ORVION`; if so record Already Applied when its Git blob is 33bfe6174cc6ded0476fa55144d555fbdcedf7ec, and otherwise stop and report. Otherwise make exactly this one edit (Recovery launcher only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | `Backup-Workspace.ps1 -Destination <usb>` / `Restore-Workspace.ps1 -From <backup>` | everything a clone cannot restore; encrypted drive required; restore never overwrites. Selective package v1: `-Package` (both) makes or restores one unencrypted 7z with a redacted secret-scan report instead (`..\docs\RECOVERY.md`) |
   ```
   insert
   ```text
   | `Restore-ORVION.cmd` / `Restore-ORVION.ps1` | double-click recovery beside the newest package and required .sha256; installs missing Git/7-Zip/pwsh, restores from its own Workbench bundle, runs product preparation, prints manual actions (`..\docs\RECOVERY.md`) |
   ```

   The resulting file's Git blob is 33bfe6174cc6ded0476fa55144d555fbdcedf7ec.

5. Check whether `lib/Restore-ORVION.cmd` contains `Restore-ORVION.ps1`; if so record Already Applied when its Git blob is 93e49bf74c0f452063fa5acf9b47540702df0ec5, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (Recovery launcher only), and change nothing else:

   ```text
   @echo off
   setlocal
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Restore-ORVION.ps1" %*
   set "ORVION_EXIT=%ERRORLEVEL%"
   pause
   exit /b %ORVION_EXIT%
   ```

   The resulting file's Git blob is 93e49bf74c0f452063fa5acf9b47540702df0ec5.

6. Check whether `lib/Restore-ORVION.ps1` contains `RECOVERY_SIDECAR_MISSING`; if so record Already Applied when its Git blob is e1d38ccc31df912dab36f9d2abc570a162605d57, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (Recovery launcher only), and change nothing else:

   ```text
   # Fresh-Windows entry: only the three recovery prerequisites are installed here.
   # Keep ASCII and Windows PowerShell 5.1 compatible: pwsh does not exist yet.
   param([string]$PackageDir=$PSScriptRoot,[string]$Staging='C:\ORVION-Temp',
         [string]$Target=(Join-Path $env:USERPROFILE 'Documents\GitHub'),
         [string]$ClaudeHome=(Join-Path $env:USERPROFILE '.claude'),
         [string]$LegacyTarget=(Join-Path $env:USERPROFILE 'Documents'),
         [string]$CodexHome=(Join-Path $env:USERPROFILE '.codex'),
         [switch]$AllowNewProfile,[switch]$SkipProducts)
   $ErrorActionPreference='Stop'

   function Get-RecoveryTool([string]$Name){
       $command=Get-Command $Name -CommandType Application -ErrorAction SilentlyContinue|Select-Object -First 1
       if($command){return $command.Source}
       if($Name-eq'7z'){
           $fallback=Join-Path $env:ProgramFiles '7-Zip\7z.exe'
           if(Test-Path -LiteralPath $fallback -PathType Leaf){return $fallback}
       }
   }
   function Update-RecoveryPath{
       $env:PATH=[Environment]::GetEnvironmentVariable('Path','Machine')+';'+[Environment]::GetEnvironmentVariable('Path','User')
   }
   # Function seam: focused tests replace process execution, never invoking real installers or logins.
   function Invoke-RecoveryProcess([string]$File,[string[]]$Arguments){
       # Windows PowerShell can surface ordinary native stderr as a PowerShell error.
       $ErrorActionPreference='Continue'
       & $File @Arguments
       $script:NativeExitCode=$LASTEXITCODE
   }
   function Get-RecoveryPackage([string]$Directory){
       $archive=Get-ChildItem -LiteralPath $Directory -Filter 'orvion-backup-*.7z' -File|Sort-Object Name -Descending|Select-Object -First 1
       if(!$archive){throw 'RECOVERY_PACKAGE_MISSING: no orvion-backup-*.7z in the package folder'}
       $sidecar=$archive.FullName+'.sha256'
       if(!(Test-Path -LiteralPath $sidecar -PathType Leaf)){throw "RECOVERY_SIDECAR_MISSING: $sidecar (never falling back to an older package)"}
       $line=[IO.File]::ReadAllText($sidecar).Trim()
       if($line-notmatch'^([A-Fa-f0-9]{64}) \*(.+)$'-or$Matches[2]-cne$archive.Name){throw 'RECOVERY_SIDECAR_INVALID: expected HASH *archive-name'}
       $expected=$Matches[1]
       # Reading every byte also hydrates a OneDrive Files On-Demand archive.
       if((Get-FileHash -LiteralPath $archive.FullName -Algorithm SHA256).Hash-ne$expected){throw "RECOVERY_HASH_MISMATCH: $($archive.Name) (never falling back to an older package)"}
       $archive.FullName
   }
   function Write-RecoveryPluginChecklist([string]$Settings,[string[]]$Installed){
       if(!(Test-Path -LiteralPath $Settings -PathType Leaf)){return}
       $settingsObject=Get-Content -LiteralPath $Settings -Raw|ConvertFrom-Json
       $seen=@{}
       foreach($line in $Installed){if($line-match'^\s*>\s+([^\s]+@[^\s]+)\s*$'){$seen[$Matches[1]]=$true}}
       $added=@{}
       foreach($entry in $settingsObject.enabledPlugins.PSObject.Properties){
           if($entry.Value-isnot[bool]-or!$entry.Value-or$seen.ContainsKey($entry.Name)){continue}
           $name,$market=$entry.Name-split'@',2
           if(!$market){Write-Host "ACTION: invalid enabled plugin name: $($entry.Name)";continue}
           if($market-ne'claude-plugins-official'-and!$added.ContainsKey($market)){
               $added[$market]=$true
               $source=$null
               if($settingsObject.extraKnownMarketplaces){$property=$settingsObject.extraKnownMarketplaces.PSObject.Properties[$market];if($property){$source=$property.Value.source;if($source-is[string]){$source=$property.Value}}}
               if($source-and$source.source-eq'github'-and$source.repo){Write-Host "ACTION: claude plugin marketplace add $($source.repo)"}
               elseif($source-and$source.source-eq'directory'){Write-Host "ACTION: $market directory marketplace: install GitKraken CLI, then its own hook installer"}
               else{Write-Host "ACTION: recover marketplace source for $market from settings before installing"}
           }
           Write-Host "ACTION: claude plugin install $($entry.Name) --scope user"
       }
   }
   function Write-RecoveryChecklist([string]$Target,[string]$ClaudeHome,[string]$CodexHome){
       Write-Host 'READY/ACTION recovery checklist (manual steps; no further installation here)'
       if($script:RecoveryExit-eq0){Write-Host 'READY: restore and requested product preparation completed'}
       else{Write-Host "ACTION: recovery reported exit $script:RecoveryExit; resolve the failure above before declaring READY"}
       Write-Host 'ACTION: revoke old GitHub CLI authorizations on github.com for PlatPlusHub and Shehabhub, then gh auth login for each account'
       Write-Host 'ACTION: supabase login; claude and codex sign-in; Docker first run; WSL admin/reboot if product prepare reported it'
       Write-Host "ACTION: re-enter the two masked local postgres passwords in $CodexHome\config.toml (merge config.toml.restored if present)"
       Write-Host "ACTION: Marketing-MCP from the owner's OneDrive Personal Vault, then its own tunnel installer (not packaged)"
       $installed=@();$claude=Get-RecoveryTool 'claude'
       if($claude){
           $installed=@(Invoke-RecoveryProcess $claude @('plugin','list'))
           if($script:NativeExitCode){Write-Host 'ACTION: claude plugin list failed; plugin presence is unverified; commands below cover all enabled plugins';if(!$script:RecoveryExit){$script:RecoveryExit=$script:NativeExitCode};$installed=@()}
       }
       Write-RecoveryPluginChecklist (Join-Path $ClaudeHome 'settings.json') $installed
       Write-Host "ACTION: pwsh -File `"$Target\ORVION-Workbench\lib\Map-Repos.ps1`" -Install"
       foreach($product in 'CRM','ORVION'){Write-Host "ACTION: in $Target\$product run pwsh -NoProfile -File scripts\check_agent_continuity.ps1 -Boot; require ORVION: READY"}
       Write-Host "ACTION: in $Target\ORVION-Workbench run pwsh -NoProfile -File lib\Workbench.ps1 -Boot; require WORKBENCH: READY"
       Write-Host "ACTION: use restored ORVION-Owner-Tools as the data root (repair/unset ORVION_DATA_ROOT if needed); record C2 with restore and all three Boot outputs per HANDOFF.md section 12"
   }
   function Invoke-OrvionRecovery([string]$PackageDir,[string]$Staging,[string]$Target,[string]$ClaudeHome,[string]$LegacyTarget,[string]$CodexHome,[switch]$AllowNewProfile,[switch]$SkipProducts){
       $script:RecoveryExit=0;$ownsStaging=$false
       try{
           $winget=Get-RecoveryTool 'winget'
           if(!$winget){throw 'RECOVERY_WINGET_REQUIRED: install App Installer from Microsoft Store, then rerun'}
           foreach($item in @(@('git','Git.Git'),@('7z','7zip.7zip'),@('pwsh','Microsoft.PowerShell'))){
               if(!(Get-RecoveryTool $item[0])){
                   Invoke-RecoveryProcess $winget @('install','--id',$item[1],'--exact','--source','winget','--accept-source-agreements','--accept-package-agreements')
                   if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw "RECOVERY_INSTALL_FAILED: $($item[1])"}
                   Update-RecoveryPath
               }
               if(!(Get-RecoveryTool $item[0])){throw "RECOVERY_COMMAND_MISSING: $($item[0]) after prerequisite setup"}
           }
           $archive=Get-RecoveryPackage $PackageDir
           if(Test-Path -LiteralPath $Staging){throw "RECOVERY_STAGING_EXISTS: $Staging must not exist; inspect it before retrying"}
           $null=New-Item -ItemType Directory -Path $Staging;$ownsStaging=$true
           $extract=Join-Path $Staging 'pkg'
           Invoke-RecoveryProcess (Get-RecoveryTool '7z') @('x',"-o$extract",$archive)
           if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw 'RECOVERY_EXTRACT_FAILED'}
           # Backup packages have one enclosing orvion-backup-<UTC> directory.
           $roots=@(Get-ChildItem -LiteralPath $extract -Directory|Where-Object{Test-Path -LiteralPath (Join-Path $_.FullName 'backup.json') -PathType Leaf})
           if($roots.Count-ne1){throw 'RECOVERY_LAYOUT_INVALID: expected one package directory with backup.json'}
           $pkg=$roots[0].FullName;$plan=Get-Content -LiteralPath (Join-Path $pkg 'backup.json') -Raw|ConvertFrom-Json
           if(!$plan.sourceUserProfile-or$plan.sourceUserProfile.TrimEnd('\')-ine$env:USERPROFILE.TrimEnd('\')){
               Write-Host 'ACTION: docs/RECOVERY.md Manual fallback, profile paths: repair absolute hooks, settings and Claude memory paths by hand; historical receipts keep their original roots'
               if(!$AllowNewProfile){throw 'RECOVERY_PROFILE_MISMATCH: source profile differs or is unrecorded; use -AllowNewProfile only with the manual-path step'}
           }
           $records=@($plan.repos|Where-Object{$_.name-ceq'ORVION-Workbench'})
           if($records.Count-ne1-or$records[0].head-cnotmatch'^[a-f0-9]{40}$'-or!$records[0].branch){throw 'RECOVERY_WORKBENCH_RECORD_INVALID'}
           $record=$records[0];$wb=Join-Path $Staging 'wb';$git=Get-RecoveryTool 'git'
           Invoke-RecoveryProcess $git @('clone','--no-checkout',(Join-Path $pkg 'repos\ORVION-Workbench.bundle'),$wb)
           if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw 'RECOVERY_WORKBENCH_CLONE_FAILED'}
           Invoke-RecoveryProcess $git @('-C',$wb,'config','core.longpaths','true')
           if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw 'RECOVERY_WORKBENCH_CONFIG_FAILED'}
           $checkout=@('-C',$wb,'checkout','--quiet')
           if($record.branch-eq'HEAD'){$checkout+=@('--detach',$record.head)}else{$checkout+=@('-B',$record.branch,$record.head)}
           Invoke-RecoveryProcess $git $checkout
           if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw 'RECOVERY_WORKBENCH_CHECKOUT_FAILED'}
           Invoke-RecoveryProcess (Get-RecoveryTool 'pwsh') @('-NoProfile','-File',(Join-Path $wb 'lib\Restore-Workspace.ps1'),'-From',$pkg,'-Target',$Target,'-ClaudeHome',$ClaudeHome,'-LegacyTarget',$LegacyTarget,'-CodexHome',$CodexHome)
           if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw 'RECOVERY_RESTORE_FAILED'}
           Get-ChildItem -LiteralPath $Staging -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'}
           [IO.Directory]::Delete([IO.Path]::GetFullPath($Staging),$true);$ownsStaging=$false
           if(!$SkipProducts){foreach($product in 'CRM','ORVION'){
               $entry=Join-Path $Target "$product\workstation.cmd"
               if(!(Test-Path -LiteralPath $entry -PathType Leaf)){Write-Host "ACTION: product entry missing: $entry";if(!$script:RecoveryExit){$script:RecoveryExit=1};continue}
               Invoke-RecoveryProcess $entry @()
               if($script:NativeExitCode){Write-Host "ACTION: $product workstation preparation failed (exit $script:NativeExitCode); restored files are retained";if(!$script:RecoveryExit){$script:RecoveryExit=$script:NativeExitCode}}
           }}
       }catch{
           if(!$script:RecoveryExit){$script:RecoveryExit=1}
           Write-Host "ACTION: $($_.Exception.Message)"
           if($ownsStaging){Write-Host "ACTION: staging retained at $Staging"}
       }
       try{Write-RecoveryChecklist $Target $ClaudeHome $CodexHome}catch{if(!$script:RecoveryExit){$script:RecoveryExit=1};Write-Host "ACTION: checklist incomplete: $($_.Exception.Message)"}
   }
   Invoke-OrvionRecovery -PackageDir $PackageDir -Staging $Staging -Target $Target -ClaudeHome $ClaudeHome -LegacyTarget $LegacyTarget -CodexHome $CodexHome -AllowNewProfile:$AllowNewProfile -SkipProducts:$SkipProducts
   exit $script:RecoveryExit
   ```

   The resulting file's Git blob is e1d38ccc31df912dab36f9d2abc570a162605d57.

7. Check whether `lib/Restore-Workspace.ps1` contains `CodexHome`; if so record Already Applied when its Git blob is 2710d93e8ab2b83cdde782d5f597d221b44af31d, and otherwise stop and report. Otherwise make exactly these 3 edits (Recovery launcher only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$Package)
   ```
   with
   ```text
         [string]$Package,[string]$CodexHome=(Join-Path $env:USERPROFILE '.codex'))
   ```

   b) immediately after the lines
   ```text
       if(Test-Path $d){if(Test-Path "$d.restored"){"KEPT existing $d and $f.restored (nothing copied)"}else{Copy-Item $s "$d.restored";"KEPT existing $d (backup copy: $f.restored, merge by hand)"}}else{New-Item -ItemType Directory $ClaudeHome -Force|Out-Null;Copy-Item $s $d;"RESTORED $d"}
   }
   ```
   insert
   ```text
   $s=Join-Path $From 'codex\config.toml';$d=Join-Path $CodexHome 'config.toml'
   if(Test-Path -LiteralPath $s -PathType Leaf){
       if(Test-Path -LiteralPath $d){if(Test-Path -LiteralPath "$d.restored"){"KEPT existing $d and config.toml.restored (nothing copied)"}else{Copy-Item -LiteralPath $s -Destination "$d.restored";"KEPT existing $d (backup copy: config.toml.restored, merge by hand)"}}
       else{New-Item -ItemType Directory $CodexHome -Force|Out-Null;Copy-Item -LiteralPath $s -Destination $d;"RESTORED $d"}
   }
   ```

   c) replace the line
   ```text
   "NEXT: gh auth login (PlatPlusHub and Shehabhub), then Boot in each repository."
   ```
   with
   ```text
   "NEXT: gh auth login (PlatPlusHub and Shehabhub); re-enter the masked local postgres passwords in $CodexHome\config.toml (merge config.toml.restored if present), then Boot in each repository."
   ```

   The resulting file's Git blob is 2710d93e8ab2b83cdde782d5f597d221b44af31d.

8. Check whether `lib/test-backup-restore.ps1` contains `sourceUserProfile`; if so record Already Applied when its Git blob is e7e01f42bf65464a9ec86dcaf8158f99e64c2d4a, and otherwise stop and report. Otherwise make exactly these 7 edits (Recovery launcher only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   Copy-Item (Join-Path $PSScriptRoot 'Backup-Workspace.ps1'),(Join-Path $PSScriptRoot 'Restore-Workspace.ps1') $lib
   ```
   insert
   ```text
   Copy-Item (Join-Path $PSScriptRoot 'Restore-ORVION.cmd'),(Join-Path $PSScriptRoot 'Restore-ORVION.ps1') $lib
   ```

   b) immediately after the line
   ```text
   $previousProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
   ```
   insert
   ```text
   [void][IO.Directory]::CreateDirectory((Join-Path $env:USERPROFILE '.codex'))
   $configFixture=@'
   [mcp_servers.postgres-local]
   url = "postgresql://local_user:fake-local@127.0.0.1:5432/local"
   [mcp_servers.postgres-founder]
   url = "postgresql://founder_user:fake-founder@127.0.0.1:5433/founder"
   [mcp_servers.example]
   bearer_token_env_var = "EXAMPLE_TOKEN"
   '@
   [IO.File]::WriteAllText((Join-Path $env:USERPROFILE '.codex/config.toml'),$configFixture)
   ```

   c) immediately after the line
   ```text
       $bk=@(Get-ChildItem (Join-Path $t 'usb') -Directory)[0].FullName
   ```
   insert
   ```text
       $maskedFile=Join-Path $bk 'codex/config.toml';$masked=[IO.File]::ReadAllText($maskedFile)
       Assert-That 'Codex URL passwords masked before manifest hashing; usernames and env names intact' ($masked-notmatch'://[^:/@\s]+:(?!\*\*\*@)[^@\s]*@'-and$masked.Contains('://local_user:***@127.0.0.1')-and$masked.Contains('://founder_user:***@127.0.0.1')-and$masked.Contains('EXAMPLE_TOKEN')-and[IO.File]::ReadAllText("$bk\SHA256SUMS.txt").Contains((Get-FileHash $maskedFile).Hash+'  codex\config.toml'))
       Assert-That 'backup records source profile without making Codex a recovery input' ((Get-Content "$bk\backup.json" -Raw|ConvertFrom-Json).sourceUserProfile-ceq$env:USERPROFILE-and!(Test-Path "$bk\recovery-inputs"))
   ```

   d) replace the line
   ```text
       $r=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target $res -ClaudeHome (Join-Path $t 'ch') -LegacyTarget (Join-Path $t 'docs2'))
   ```
   with
   ```text
       $codexHome=Join-Path $t 'restored-codex'
       $r=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target $res -ClaudeHome (Join-Path $t 'ch') -LegacyTarget (Join-Path $t 'docs2') -CodexHome $codexHome)
   ```

   e) immediately after the line
   ```text
       if($LASTEXITCODE-ne0){throw ('RESTORE_FIXTURE_FAILED: '+($r-join' '))}
   ```
   insert
   ```text
       Assert-That 'absent Codex config copied byte-identically; NEXT explains masked passwords' ((Get-FileHash "$codexHome\config.toml").Hash-ceq(Get-FileHash $maskedFile).Hash-and($r-join' ')-match'NEXT: .*masked local postgres passwords')
       [IO.File]::WriteAllText("$codexHome\config.toml",'owner configuration')
       foreach($round in 1,2){
           $configRestore=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target (Join-Path $t "config-target-$round") -ClaudeHome (Join-Path $t "config-claude-$round") -LegacyTarget (Join-Path $t "config-docs-$round") -CodexHome $codexHome 2>&1)
           Assert-That "existing Codex config untouched, restored copy written once (round $round)" ($LASTEXITCODE-eq0-and[IO.File]::ReadAllText("$codexHome\config.toml")-ceq'owner configuration'-and$(if($round-eq1){(Get-FileHash "$codexHome\config.toml.restored").Hash-ceq(Get-FileHash $maskedFile).Hash}else{[IO.File]::ReadAllText("$codexHome\config.toml.restored")-ceq'preserve earlier recovery'}))
           [IO.File]::WriteAllText("$codexHome\config.toml.restored",'preserve earlier recovery')
       }
   ```

   f) immediately after the line
   ```text
       Copy-Item (Join-Path $lib 'Backup-Workspace.ps1'),(Join-Path $lib 'Restore-Workspace.ps1') $probeLib
   ```
   insert
   ```text
       Copy-Item (Join-Path $lib 'Restore-ORVION.cmd'),(Join-Path $lib 'Restore-ORVION.ps1') $probeLib
   ```

   g) replace the line
   ```text
           Assert-That 'package destination holds one archive plus its scan report and staging is removed' (@(Get-ChildItem $cloud -Force).Count-eq2-and(Test-Path $scan)-and$archive-and@(Get-ChildItem $pkgTemp -Force).Count-eq0-and($pkg-join' ')-match'PACKAGE: .*unencrypted')
   ```
   with
   ```text
           Assert-That 'package destination holds archive, scan, hash and both launchers; staging is removed' (@(Get-ChildItem $cloud -Force).Count-eq5-and(Test-Path $scan)-and$archive-and@(Get-ChildItem $pkgTemp -Force).Count-eq0-and($pkg-join' ')-match'PACKAGE: .*unencrypted'-and[IO.File]::ReadAllText("$archive.sha256").Trim()-ceq((Get-FileHash $archive).Hash+' *'+(Split-Path $archive -Leaf))-and(Get-FileHash "$cloud\Restore-ORVION.cmd").Hash-ceq(Get-FileHash "$lib\Restore-ORVION.cmd").Hash-and(Get-FileHash "$cloud\Restore-ORVION.ps1").Hash-ceq(Get-FileHash "$lib\Restore-ORVION.ps1").Hash)
           # Fail archive creation and verification separately. Real 7z handles successful commands; no installer seam.
           $backupFile=Join-Path $probeLib 'Backup-Workspace.ps1';$backupBytes=[IO.File]::ReadAllText($backupFile)
           $tokens=$null;$parseErrors=$null;$backupAst=[Management.Automation.Language.Parser]::ParseInput($backupBytes,[ref]$tokens,[ref]$parseErrors)
           $zipFunction=$backupAst.Find({param($n)$n-is[Management.Automation.Language.FunctionDefinitionAst]-and$n.Name-eq'Get-SevenZip'},$false).Extent.Text
           foreach($operation in 'a','t'){
               $failedCloud=Join-Path $t "cloud-failed-$operation";[void][IO.Directory]::CreateDirectory($failedCloud)
               foreach($name in 'Restore-ORVION.cmd','Restore-ORVION.ps1','unrelated.txt'){[IO.File]::WriteAllText((Join-Path $failedCloud $name),'keep existing bytes')}
               $fakeZip=Join-Path $t "7z-fail-$operation.cmd"
               [IO.File]::WriteAllLines($fakeZip,[string[]]@('@echo off',('if "%1"=="'+$operation+'" exit /b 71'),('"'+$zip+'" %*'),'exit /b %ERRORLEVEL%'))
               [IO.File]::WriteAllText($backupFile,$backupBytes.Replace($zipFunction,("function Get-SevenZip{'"+$fakeZip.Replace("'","''")+"'}")))
               try{$failedPackage=@(& pwsh -NoProfile -File $backupFile -Destination $failedCloud -RecoveryInputs $inputs -Package 2>&1);$failedCode=$LASTEXITCODE}
               finally{[IO.File]::WriteAllText($backupFile,$backupBytes)}
               Assert-That "failed package $operation writes no hash or launcher; existing files untouched" ($failedCode-ne0-and($failedPackage-join' ')-match'PACKAGE_(VERIFY_)?FAILED'-and@((Get-ChildItem -LiteralPath $failedCloud -Filter *.sha256)).Count-eq0-and[IO.File]::ReadAllText((Join-Path $failedCloud 'Restore-ORVION.cmd'))-ceq'keep existing bytes'-and[IO.File]::ReadAllText((Join-Path $failedCloud 'Restore-ORVION.ps1'))-ceq'keep existing bytes'-and[IO.File]::ReadAllText((Join-Path $failedCloud 'unrelated.txt'))-ceq'keep existing bytes'-and@(Get-ChildItem $pkgTemp -Force).Count-eq0)
           }
   ```

   The resulting file's Git blob is e7e01f42bf65464a9ec86dcaf8158f99e64c2d4a.

9. Check whether `lib/test-restore-orvion.ps1` contains `RESTORE_ORVION_SELFCHECK PASS`; if so record Already Applied when its Git blob is ff4fd8c8cd5780ee3976d53942530a313214359f, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (Recovery launcher only), and change nothing else:

   ```text
   # WS-023 owning checks. No real user data, installers, network, gh or real claude.
   # Function seams prove orchestration; one tiny real 7z/bundle proves the Windows PowerShell entry wiring.
   param()
   $ErrorActionPreference='Stop'
   $t=Join-Path ([IO.Path]::GetTempPath()) ('orvion-recovery-check-'+[guid]::NewGuid().ToString('N').Substring(0,8))
   [void][IO.Directory]::CreateDirectory($t)
   $source=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Restore-ORVION.ps1'))
   $savedProfile=$env:USERPROFILE;$savedGlobal=$env:GIT_CONFIG_GLOBAL;$savedSystem=$env:GIT_CONFIG_NOSYSTEM
   $savedInjection=@{}
   foreach($key in [Environment]::GetEnvironmentVariables('Process').Keys|Where-Object{$_-match'^GIT_CONFIG_(COUNT|PARAMETERS|KEY_\d+|VALUE_\d+)$'}){
       $savedInjection[$key]=[Environment]::GetEnvironmentVariable($key,'Process');Remove-Item -LiteralPath ('Env:\'+$key)
   }
   $env:USERPROFILE=Join-Path $t 'profile';$env:GIT_CONFIG_GLOBAL=Join-Path $t 'empty.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
   $fail=0
   function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
   function Import-RecoveryFunctions([string]$Text){
       $tokens=$null;$errors=$null;$ast=[Management.Automation.Language.Parser]::ParseInput($Text,[ref]$tokens,[ref]$errors)
       if($errors.Count){throw "FIXTURE_PARSE_FAILED: $errors"}
       foreach($node in $ast.FindAll({param($n)$n-is[Management.Automation.Language.FunctionDefinitionAst]},$false)){
           Invoke-Expression ($node.Extent.Text-replace'^function ([\w-]+)','function script:$1')
       }
   }
   function Set-Sidecar([string]$Archive){[IO.File]::WriteAllText("$Archive.sha256",((Get-FileHash $Archive).Hash+' *'+(Split-Path $Archive -Leaf))) }
   function Invoke-Scenario([string]$Case,[string]$Text=$source){
       Import-RecoveryFunctions $Text
       $root=Join-Path $t ([guid]::NewGuid().ToString('N').Substring(0,8));[void][IO.Directory]::CreateDirectory($root)
       $script:case=$Case;$script:calls=[Collections.Generic.List[string]]::new();$script:available=@{winget=$true;git=$true;'7z'=$true;pwsh=$true}
       $script:fakePkg=Join-Path $root 'orvion-backup-fixture';[void][IO.Directory]::CreateDirectory($script:fakePkg)
       $record=@{name='ORVION-Workbench';branch='recovery-branch';head=('a'*40)}
       $plan=@{sourceUserProfile=$env:USERPROFILE;repos=@($record)}
       if($Case-eq'profile'){$plan.sourceUserProfile='C:\Users\different'}
       if($Case-eq'unrecorded'){$plan.Remove('sourceUserProfile')}
       if($Case-eq'record'){$record.head='bad'}
       [IO.File]::WriteAllText((Join-Path $script:fakePkg 'backup.json'),($plan|ConvertTo-Json -Depth 6))
       $packages=Join-Path $root 'cloud';[void][IO.Directory]::CreateDirectory($packages)
       $older=Join-Path $packages 'orvion-backup-20260101T000000Z.7z';[IO.File]::WriteAllText($older,'older');Set-Sidecar $older
       $newer=Join-Path $packages 'orvion-backup-20260201T000000Z.7z';[IO.File]::WriteAllText($newer,'newer');Set-Sidecar $newer
       # Deliberately reverse filesystem timestamps: only the UTC filename owns selection.
       (Get-Item $older).LastWriteTime=[datetime]::Now.AddDays(1)
       if($Case-eq'package') {Remove-Item -LiteralPath $older,$newer}
       if($Case-eq'sidecar'){Remove-Item -LiteralPath "$newer.sha256"}
       if($Case-eq'invalid'){[IO.File]::WriteAllText("$newer.sha256",('b'*64)+' *wrong.7z')}
       if($Case-eq'hash'){[IO.File]::WriteAllText($newer,'damaged newest')}
       if($Case-eq'winget'){$script:available.winget=$false}
       if($Case-in'claude-list','claude-list-fail'){$script:available.claude=$true}
       if($Case-in'install','verify','install-success'){$script:available.git=$false;$script:available.'7z'=$false;$script:available.pwsh=$false}
       function script:Get-RecoveryTool([string]$Name){if($script:available[$Name]){return $Name}}
       function script:Update-RecoveryPath{$script:calls.Add('refresh-path')}
       function script:Invoke-RecoveryProcess([string]$File,[string[]]$Arguments){
           $script:calls.Add($File+' '+($Arguments-join' '));$script:NativeExitCode=0
           if($File-eq'winget'){
               if($script:case-eq'install'){$script:NativeExitCode=17;return}
               if($script:case-ne'verify'){switch($Arguments[2]){'Git.Git'{$script:available.git=$true};'7zip.7zip'{$script:available.'7z'=$true};'Microsoft.PowerShell'{$script:available.pwsh=$true}}}
           }
           if($File-eq'7z'){
               if($script:case-eq'extract'){$script:NativeExitCode=18;return}
               $dir=$Arguments[1].Substring(2);[void][IO.Directory]::CreateDirectory($dir)
               if($script:case-ne'layout'){Copy-Item -LiteralPath $script:fakePkg -Destination $dir -Recurse}
           }
           if($File-eq'git'){
               if($Arguments[0]-eq'clone'){if($script:case-eq'clone'){$script:NativeExitCode=19;return};[void][IO.Directory]::CreateDirectory($Arguments[3])}
               if($Arguments[2]-eq'config'-and$script:case-eq'config'){$script:NativeExitCode=20}
               if($Arguments[2]-eq'checkout'-and$script:case-eq'checkout'){$script:NativeExitCode=21}
           }
           if($File-eq'pwsh'){Write-Output 'RESTORE_FIXTURE_OUTPUT';if($script:case-eq'restore'){$script:NativeExitCode=42}}
           if($File-eq'claude'){Write-Output '  > ponytail@ponytail';if($script:case-eq'claude-list-fail'){$script:NativeExitCode=26}}
           if($File-like'*CRM\workstation.cmd'-and$script:case-eq'product'){$script:NativeExitCode=23}
       }
       $stage=Join-Path $root 'stage';$target=Join-Path $root 'target'
       if($Case-eq'staging'){[void][IO.Directory]::CreateDirectory($stage);[IO.File]::WriteAllText((Join-Path $stage 'keep.txt'),'keep')}
       foreach($p in 'CRM','ORVION'){[void][IO.Directory]::CreateDirectory((Join-Path $target $p));[IO.File]::WriteAllText((Join-Path $target "$p\workstation.cmd"),'fixture')}
       if($Case-eq'product-missing'){[IO.File]::Delete((Join-Path $target 'CRM\workstation.cmd'))}
       if($Case-in'claude-list','claude-list-fail'){
           [void][IO.Directory]::CreateDirectory((Join-Path $root 'claude'))
           [IO.File]::WriteAllText((Join-Path $root 'claude\settings.json'),'{"enabledPlugins":{"ponytail@ponytail":true},"extraKnownMarketplaces":{"ponytail":{"source":{"source":"github","repo":"DietrichGebert/ponytail"}}}}')
       }
       $params=@{PackageDir=$packages;Staging=$stage;Target=$target;ClaudeHome=(Join-Path $root 'claude');LegacyTarget=(Join-Path $root 'docs');CodexHome=(Join-Path $root 'codex')}
       if($Case-eq'allow-profile'){$plan.sourceUserProfile='C:\Users\different';[IO.File]::WriteAllText((Join-Path $script:fakePkg 'backup.json'),($plan|ConvertTo-Json -Depth 6));$params.AllowNewProfile=$true}
       if($Case-eq'skip-products'){$params.SkipProducts=$true}
       $output=@(Invoke-OrvionRecovery @params *>&1)-join"`n"
       [pscustomobject]@{Exit=$script:RecoveryExit;Output=$output;Calls=@($script:calls.ToArray());Stage=(Test-Path $stage);Keep=(Test-Path (Join-Path $stage 'keep.txt'));Root=$root;Newer=$newer}
   }
   function Test-Refusal([string]$Case,[string]$Token,[string]$Text=$source){
       $r=Invoke-Scenario $Case $Text
       $early=$Case-in'package','sidecar','invalid','hash','winget','staging','install','verify'
       $calls=$r.Calls-join"`n"
       $ok=$r.Exit-ne0-and$r.Output.Contains($Token)-and$r.Output.Contains('READY/ACTION recovery checklist')
       if($early){$ok=$ok-and$calls-notmatch'^7z x'}else{$ok=$ok-and$r.Stage-and$r.Output.Contains('staging retained')-and$calls-notmatch'workstation.cmd'}
       if($Case-eq'staging'){$ok=$ok-and$r.Keep}
       if($Case-eq'restore'){$ok=$ok-and$r.Exit-eq42-and$r.Output.Contains('RESTORE_FIXTURE_OUTPUT')}
       if($Case-in'profile','unrecorded'){$ok=$ok-and$calls-notmatch'git clone'-and$r.Output.Contains('Manual fallback, profile paths')}
       $ok
   }
   try{
       Assert-That 'launcher ASCII only' (@([IO.File]::ReadAllBytes((Join-Path $PSScriptRoot 'Restore-ORVION.ps1'))|Where-Object{$_-gt127}).Count-eq0)
       $parse='param($p) $t=$null; $e=$null; [void][System.Management.Automation.Language.Parser]::ParseFile($p,[ref]$t,[ref]$e); if($e.Count){$e | Out-String | Write-Output; exit 1}; if($PSVersionTable.PSVersion.Major -ne 5 -or $PSVersionTable.PSVersion.Minor -ne 1){exit 2}; exit 0'
       $parseFile=Join-Path $t 'parse.ps1';[IO.File]::WriteAllText($parseFile,$parse)
       $parsed=@(& powershell.exe -NoProfile -File $parseFile (Join-Path $PSScriptRoot 'Restore-ORVION.ps1') 2>&1)
       Assert-That 'Windows PowerShell 5.1 parses launcher (exit 0)' ($LASTEXITCODE-eq0)
       # Explicit requested -Command parser check, in addition to -File above.
       $commandCheck="`$t=`$null; `$e=`$null; [void][System.Management.Automation.Language.Parser]::ParseFile('"+(Join-Path $PSScriptRoot 'Restore-ORVION.ps1').Replace("'","''")+"',[ref]`$t,[ref]`$e); if(`$e.Count){exit 1}; exit 0"
       & powershell.exe -NoProfile -Command $commandCheck
       Assert-That 'powershell.exe -NoProfile -Command parse check (exit 0)' ($LASTEXITCODE-eq0)
       $refusals=[ordered]@{winget='RECOVERY_WINGET_REQUIRED';package='RECOVERY_PACKAGE_MISSING';sidecar='RECOVERY_SIDECAR_MISSING';invalid='RECOVERY_SIDECAR_INVALID';hash='RECOVERY_HASH_MISMATCH';staging='RECOVERY_STAGING_EXISTS';install='RECOVERY_INSTALL_FAILED';verify='RECOVERY_COMMAND_MISSING';extract='RECOVERY_EXTRACT_FAILED';layout='RECOVERY_LAYOUT_INVALID';profile='RECOVERY_PROFILE_MISMATCH';unrecorded='RECOVERY_PROFILE_MISMATCH';record='RECOVERY_WORKBENCH_RECORD_INVALID';clone='RECOVERY_WORKBENCH_CLONE_FAILED';config='RECOVERY_WORKBENCH_CONFIG_FAILED';checkout='RECOVERY_WORKBENCH_CHECKOUT_FAILED';restore='RECOVERY_RESTORE_FAILED'}
       foreach($caseName in $refusals.Keys){Assert-That ("refusal $caseName") (Test-Refusal $caseName $refusals[$caseName])}
       $r=Invoke-Scenario success;$calls=$r.Calls-join"`n"
       Assert-That 'newest by name; one extraction; local bundle branch/head; four paths passed; products both run; staging removed' ($r.Exit-eq0-and!$r.Stage-and@($r.Calls|Where-Object{$_-like'7z x *'}).Count-eq1-and$calls.Contains($r.Newer)-and$calls.Contains('repos\ORVION-Workbench.bundle')-and$calls.Contains('checkout --quiet -B recovery-branch '+('a'*40))-and$calls.Contains('-From ')-and$calls.Contains('-Target ')-and$calls.Contains('-ClaudeHome ')-and$calls.Contains('-LegacyTarget ')-and$calls.Contains('-CodexHome ')-and$calls.Contains('CRM\workstation.cmd')-and$calls.Contains('ORVION\workstation.cmd')-and$calls-notmatch'winget install')
       $r=Invoke-Scenario install-success;$calls=$r.Calls-join"`n"
       Assert-That 'missing prerequisites only: exact three winget ids/flags; refresh PATH after each; verify commands' ($r.Exit-eq0-and@($r.Calls|Where-Object{$_-eq'refresh-path'}).Count-eq3-and@($r.Calls|Where-Object{$_-like'winget install *'}).Count-eq3-and$calls.Contains('Git.Git --exact --source winget --accept-source-agreements --accept-package-agreements')-and$calls.Contains('7zip.7zip --exact --source winget --accept-source-agreements --accept-package-agreements')-and$calls.Contains('Microsoft.PowerShell --exact --source winget --accept-source-agreements --accept-package-agreements'))
       $r=Invoke-Scenario allow-profile;Assert-That 'explicit profile override prints manual repair step and restores' ($r.Exit-eq0-and$r.Output.Contains('repair absolute hooks'))
       $r=Invoke-Scenario skip-products;Assert-That 'SkipProducts avoids both product entries' ($r.Exit-eq0-and($r.Calls-join' ')-notmatch'workstation.cmd')
       foreach($caseName in 'product','product-missing'){$r=Invoke-Scenario $caseName;Assert-That "$caseName records failure and still runs ORVION; restored files retained" ($r.Exit-ne0-and!$r.Stage-and($r.Calls-join' ').Contains('ORVION\workstation.cmd')-and(Test-Path (Join-Path $r.Root 'target\ORVION\workstation.cmd')))}
       $r=Invoke-Scenario claude-list;Assert-That 'checklist obtains injected claude plugin list and suppresses installed commands' ($r.Exit-eq0-and($r.Calls-join' ').Contains('claude plugin list')-and!$r.Output.Contains('claude plugin install ponytail@ponytail'))
       $r=Invoke-Scenario claude-list-fail;Assert-That 'failed claude list records uncertainty/exit and prints enabled commands' ($r.Exit-eq26-and$r.Output.Contains('plugin presence is unverified')-and$r.Output.Contains('claude plugin install ponytail@ponytail --scope user'))
       Import-RecoveryFunctions $source
       $savedPath=$env:PATH;$savedProgramFiles=$env:ProgramFiles
       try{
           $env:PATH=Join-Path $t 'empty-path';$env:ProgramFiles=Join-Path $t 'program-files'
           [void][IO.Directory]::CreateDirectory((Join-Path $env:ProgramFiles '7-Zip'))
           $fallback=Join-Path $env:ProgramFiles '7-Zip\7z.exe';[IO.File]::WriteAllText($fallback,'discovery only, never executed')
           Assert-That '7z discovery falls back to Program Files when PATH lacks 7z' ((Get-RecoveryTool '7z')-ceq$fallback)
       }finally{$env:PATH=$savedPath;$env:ProgramFiles=$savedProgramFiles}
       Import-RecoveryFunctions $source
       $settings=Join-Path $t 'settings.json'
       [IO.File]::WriteAllText($settings,(@{enabledPlugins=@{'gitkraken-hooks@gitkraken'=$true;'ponytail@ponytail'=$true;'session-report@claude-plugins-official'=$true;'project-artifact@claude-plugins-official'=$true;'claude-md-management@claude-plugins-official'=$true;'oh-my-claudecode@omc'=$true;'disabled@unused'=$false};extraKnownMarketplaces=@{gitkraken=@{source=@{source='directory';path='C:\Users\old\.claude\plugins\marketplaces\gitkraken'}};ponytail=@{source=@{source='github';repo='DietrichGebert/ponytail'}};omc=@{source=@{source='github';repo='Yeachan-Heo/oh-my-claudecode'}}}}|ConvertTo-Json -Depth 8))
       $plugins=@(Write-RecoveryPluginChecklist $settings @('Installed plugins:','  > session-report@claude-plugins-official','  > ponytail@ponytail') *>&1)-join"`n"
       Assert-That 'plugin list fixture filters installed/disabled; builtin needs no add; directory uses own installer; GitHub commands exact' ($plugins.Contains('install GitKraken CLI, then its own hook installer')-and$plugins.Contains('claude plugin marketplace add Yeachan-Heo/oh-my-claudecode')-and$plugins.Contains('claude plugin install oh-my-claudecode@omc --scope user')-and$plugins.Contains('claude plugin install project-artifact@claude-plugins-official --scope user')-and$plugins.Contains('claude plugin install claude-md-management@claude-plugins-official --scope user')-and$plugins-notmatch'install (ponytail|session-report|disabled)@'-and$plugins-notmatch'marketplace add .*claude-plugins-official')
       $plugins=@(Write-RecoveryPluginChecklist $settings @() *>&1)-join"`n"
       Assert-That 'absent claude/list shows all enabled plugins including exact ponytail marketplace command' ($plugins.Contains('claude plugin marketplace add DietrichGebert/ponytail')-and@($plugins-split"`n"|Where-Object{$_-like'*claude plugin install *'}).Count-eq6)
       # Removing each new guard must kill its focused observation (including the clear refusal diagnosis).
       foreach($caseName in $refusals.Keys){
           $token=$refusals[$caseName]
           $match=[regex]::Match($source,'throw (?:'''+$token+'[^'']*''|"'+$token+'[^"\r\n]*")')
           if(!$match.Success){throw "MUTANT_ANCHOR_MISSING $token"}
           $mutant=$source.Replace($match.Value,"Write-Host 'MUTANT guard removed'")
           Assert-That ("MUTANT killed: $caseName guard removal") (!(Test-Refusal $caseName $token $mutant))
       }
       $mutant=$source.Replace('Sort-Object Name -Descending','Sort-Object Name')
       $r=Invoke-Scenario success $mutant
       Assert-That 'MUTANT killed: oldest selection' (!(($r.Calls-join' ').Contains($r.Newer)))
       $mutant=$source.Replace('if(!(Test-Path -LiteralPath $entry -PathType Leaf)){','if($false){')
       $r=Invoke-Scenario product-missing $mutant
       Assert-That 'MUTANT killed: missing product entry refusal removed' ($r.Exit-eq0)
       $needle='if($script:NativeExitCode){Write-Host "ACTION: $product workstation preparation failed'
       $mutant=$source.Replace($needle,'if($false){Write-Host "ACTION: $product workstation preparation failed')
       $r=Invoke-Scenario product $mutant
       Assert-That 'MUTANT killed: product failure recording removed' ($r.Exit-eq0)
       # Real tiny extraction + real bundle checkout + real pwsh child, also run by Windows PowerShell 5.1.
       # The synthetic Restore body proves transport/output/exit, not the real workstation restore (C2).
       $zip=(Get-Command 7z -CommandType Application -ErrorAction Stop|Select-Object -First 1).Source;$git=(Get-Command git -CommandType Application -ErrorAction Stop|Select-Object -First 1).Source;$pwsh=(Get-Command pwsh -CommandType Application -ErrorAction Stop|Select-Object -First 1).Source
       $repo=Join-Path $t 'tiny-repo';$pkg=Join-Path $t 'real-package\orvion-backup-fixture';$cloud=Join-Path $t 'real-cloud'
       [void][IO.Directory]::CreateDirectory((Join-Path $repo 'lib'));[void][IO.Directory]::CreateDirectory((Join-Path $pkg 'repos'));[void][IO.Directory]::CreateDirectory($cloud)
       $body='param($From,$Target,$ClaudeHome,$LegacyTarget,$CodexHome) if(!(Test-Path (Join-Path $From "backup.json")) -or !$Target -or !$ClaudeHome -or !$LegacyTarget -or !$CodexHome){exit 44}; Write-Output "REAL_CHILD_OUTPUT"; if($Target -like "*child-failure*"){exit 42}; exit 0'
       [IO.File]::WriteAllText((Join-Path $repo 'lib\Restore-Workspace.ps1'),$body)
       & $git init -q -b main $repo;if($LASTEXITCODE){throw 'TINY_INIT_FAILED'}
       & $git -C $repo add -A;if($LASTEXITCODE){throw 'TINY_ADD_FAILED'}
       & $git -C $repo -c user.name=fixture -c user.email=fixture@example.invalid -c core.hooksPath=NUL commit -q -m fixture;if($LASTEXITCODE){throw 'TINY_COMMIT_FAILED'}
       $head=(& $git -C $repo rev-parse HEAD).Trim()
       & $git -C $repo bundle create (Join-Path $pkg 'repos\ORVION-Workbench.bundle') --all 2>&1|Out-Null;if($LASTEXITCODE){throw 'TINY_BUNDLE_FAILED'}
       [IO.File]::WriteAllText((Join-Path $pkg 'backup.json'),(@{sourceUserProfile=$env:USERPROFILE;repos=@(@{name='ORVION-Workbench';branch='HEAD';head=$head})}|ConvertTo-Json -Depth 5))
       $archive=Join-Path $cloud 'orvion-backup-20260101T000000Z.7z'
       & $zip a -t7z -mx1 $archive $pkg 2>&1|Out-Null;if($LASTEXITCODE){throw 'TINY_ARCHIVE_FAILED'};Set-Sidecar $archive
       $harness=Join-Path $t 'real-harness.ps1'
       # Dot-load only function definitions from the actual launcher; replace tool discovery, leave process execution real.
       $harnessBody=@'
   param($Source,$Zip,$Git,$Pwsh,$Cloud,$Stage,$FixtureRoot)
   $ErrorActionPreference='Stop'
   $tok=$null;$err=$null;$ast=[Management.Automation.Language.Parser]::ParseFile($Source,[ref]$tok,[ref]$err)
   foreach($fn in $ast.FindAll({param($n)$n -is [Management.Automation.Language.FunctionDefinitionAst]},$false)){. ([scriptblock]::Create($fn.Extent.Text))}
   function Get-RecoveryTool([string]$Name){switch($Name){winget {'fixture-winget-never-run'};git {$Git};'7z' {$Zip};pwsh {$Pwsh}}}
   Invoke-OrvionRecovery -PackageDir $Cloud -Staging $Stage -Target "$FixtureRoot\target" -ClaudeHome "$FixtureRoot\claude" -LegacyTarget "$FixtureRoot\docs" -CodexHome "$FixtureRoot\codex" -SkipProducts
   exit $script:RecoveryExit
   '@
       [IO.File]::WriteAllText($harness,$harnessBody,[Text.Encoding]::ASCII)
       foreach($engine in @($pwsh,'powershell.exe')){
           $stage=Join-Path $t ('real-stage-'+[guid]::NewGuid().ToString('N').Substring(0,5))
           $out=@(& $engine -NoProfile -File $harness (Join-Path $PSScriptRoot 'Restore-ORVION.ps1') $zip $git $pwsh $cloud $stage $t 2>&1);$code=$LASTEXITCODE
           Assert-That "real 7z/local git/detached checkout/pwsh child under $engine (exit $code)" ($code-eq0-and($out-join' ').Contains('REAL_CHILD_OUTPUT')-and!(Test-Path $stage))
           if($code){$out|Select-Object -Last 12}
           $out=@(& $engine -NoProfile -File $harness (Join-Path $PSScriptRoot 'Restore-ORVION.ps1') $zip $git $pwsh $cloud $stage (Join-Path $t 'child-failure') 2>&1);$code=$LASTEXITCODE
           Assert-That "real restore child failure under $engine preserves output, exit 42 and staging" ($code-eq42-and($out-join' ').Contains('REAL_CHILD_OUTPUT')-and($out-join' ').Contains('staging retained')-and(Test-Path $stage))
       }
       $cmd=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Restore-ORVION.cmd'))
       Assert-That 'cmd forwards arguments, always pauses after capturing exit, and returns captured code' ($cmd.Contains('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Restore-ORVION.ps1" %*')-and$cmd-match'(?s)set "ORVION_EXIT=%ERRORLEVEL%"\r?\npause\r?\nexit /b %ORVION_EXIT%')
   }finally{
       $env:USERPROFILE=$savedProfile;$env:GIT_CONFIG_GLOBAL=$savedGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedSystem
       foreach($key in $savedInjection.Keys){[Environment]::SetEnvironmentVariable($key,$savedInjection[$key],'Process')}
       # Own GUID fixture only; never a product clone or real user configuration.
       if([IO.Path]::GetFullPath($t).StartsWith([IO.Path]::GetFullPath([IO.Path]::GetTempPath()),[StringComparison]::OrdinalIgnoreCase)){
           Get-ChildItem -LiteralPath $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)
       }else{throw 'FIXTURE_CLEANUP_OUTSIDE_TEMP'}
   }
   if($fail){throw "RESTORE_ORVION_SELFCHECK_FAILED $fail"};'RESTORE_ORVION_SELFCHECK PASS'
   ```

   The resulting file's Git blob is ff4fd8c8cd5780ee3976d53942530a313214359f.

## Acceptance Criteria

- [x] Exact approved scoped output. check: blob:HANDOFF.md=985962343c449af088ac2096293b520b01e946d7
- [x] Exact approved scoped output. check: blob:docs/RECOVERY.md=bb3526d7e4ed93c34fd9875b7e1930eba449fb67
- [x] Exact approved scoped output. check: blob:lib/Backup-Workspace.ps1=3d9a1fed2671bcffa937933c915e3905f99e0408
- [x] Exact approved scoped output. check: blob:lib/README.md=33bfe6174cc6ded0476fa55144d555fbdcedf7ec
- [x] Exact approved scoped output. check: blob:lib/Restore-ORVION.cmd=93e49bf74c0f452063fa5acf9b47540702df0ec5
- [x] Exact approved scoped output. check: blob:lib/Restore-ORVION.ps1=e1d38ccc31df912dab36f9d2abc570a162605d57
- [x] Exact approved scoped output. check: blob:lib/Restore-Workspace.ps1=2710d93e8ab2b83cdde782d5f597d221b44af31d
- [x] Exact approved scoped output. check: blob:lib/test-backup-restore.ps1=e7e01f42bf65464a9ec86dcaf8158f99e64c2d4a
- [x] Exact approved scoped output. check: blob:lib/test-restore-orvion.ps1=ff4fd8c8cd5780ee3976d53942530a313214359f
- [x] The owning tests prove: the package records sourceUserProfile, the packaged Codex config has URL passwords masked before hashing and is never a recovery input, and the sidecar and both launchers appear only after a verified archive (a failed 7z add/test leaves none); Restore-Workspace restores the Codex config copy-once; the launcher parses in Windows PowerShell 5.1, refuses a missing/invalid/mismatched sidecar without falling back, refuses existing staging and a profile mismatch unless -AllowNewProfile, installs only missing prerequisites, keeps staging on failure and removes it on success, propagates child exit codes and always prints the checklist.
- [x] Mandatory V1/V2/V3, focused proof (with Codex's 20 in-test mutants), independent planted mutants, accepted literal replay controls and the real PS 5.1 measurement are preserved. One isolated native timed/watched Finish owns the grown full schedule (one new suite, one new launcher script) with a fresh SANDBOX receipt before original approval; the original needs its own fresh Finish, live Review, native Complete and an independent carrying-range READY.

## Review Gate

- [x] Inspect the nine scoped files, the focused/mutant/literal evidence and the real PS 5.1 measurement; preserve all frozen prior evidence.
- [x] Independently check the native receipt root/Draft/recipe/evaluator/fingerprint, ordered tests and timed/watcher/host exits; normal native Review/Complete and every new carrying transition must pass. No second-agent or provider certification is claimed.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Decision D26 in C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\DECISIONS.md (under D19-D25, D12 and OWNER-DECISION-20261027-no-reinstall.md). Codex investigated at xhigh effort (before pass and rebuttal round, ws023-package\codex) and implemented at high effort (codex\impl1-final.md) in disposable C:\cx\ORVION-ws023 under orchestrator verification (codex\impl1-disposition.md). Under the owner's exceptional delegation this one Workbench contract is authorized. Gate 1 for this Draft is DELEGATED: the owner did not type its digest. Sandbox approval is synthetic and grants no original authority.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws023-package\assurance\V3\DRAFT.md
Approved SHA256: A21DC3B204EDD02FB33782DF2829B4013D5A8C6F380ABB1D037CC68FE6494EEB
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\GATE1-WS023-DELEGATED.md
Owner Evidence SHA256: EA291CE48B97FA0C3163168D8FD6E9F5384022F1D31BEEF3A5B2A2369E0E743D
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws023-package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 7BF683ED930A479BDA23C6F4AEC2C918B48F18E3532E1CE072498151345FD1BF
Original admission: DELEGATED exact Gate 1 under the owner's exceptional delegation of 2026-10-26 (OWNER-DELEGATION.md SHA-256 94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217; decisions D1-D26; D26 is the delegated decision for this contract). The owner did not type this digest. Bound to this literal root, the exact V3 digest and the fresh sandbox receipt; no sandbox receipt transplant as original certification.
Original exact literal implementation applied by accepted native Workbench Execute. Declared filtered blobs match. Fresh root-bound original Finish and independent live Review remain required; sandbox success does not certify this root. This frozen Draft was not expanded.

## Verification Notes

Profiles RECOVERY+REPOSITORY, never WORKSTATION (Codex rebuttal R2 confirmed). Codex's 20 mutants are executed inside test-restore-orvion.ps1 on every run; the orchestrator's four independent planted regressions (hash check, staging refusal, profile refusal, Codex password masking) are detected (mutants.log); hazard scan 0; both owning self-checks PASS with an isolated ORVION_DATA_ROOT (focused-selected.log). Real measurement (real-measurement.json): Windows PowerShell 5.1 parse errors 0 and non-ASCII bytes 0 for the launcher. The real launcher run against a fresh package is lift criterion 5, after release; it is not claimed here.
Verdict: Confirmed Complete
Reviewed Fingerprint: 8C93C3F67843CBBD080AE0148DB91587D42B0DA7D775C2C11E53C4407FDDFAAE
Reviewed Receipt: 2CCFCAA3924DE5A084D8BE577ED663C8A2F54B101F0D6B144B83EDC21E852B46
Evidence: fresh ORIGINAL root-bound timed/watched Finish, actual ordered-suite schedule/exits, approved exact outputs and independently pinned accepted-code live review. Runtime: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws023-package\runtime\original. No sandbox receipt transplant, remote parity, offsite recovery or equal-OS isolation claim.

## Selection reasons and sources

Evidence Refresh: focused-selected.log PASS for both owning self-checks on the selected bytes, independent planted regressions detected, hazard scan 0, PS 5.1 measurement, literal replay controls run before the one sandbox Finish. Baseline 55662e7 (main = WS-021), accepted judge 835E14DA unchanged.

Sources: DECISIONS.md D19-D26, OWNER-DECISION-20261027-no-reinstall.md, ws023-package\codex, accepted WORKFLOW/TEMPLATE/checker, WS-021 packet scripts, the real PS 5.1 measurement.
