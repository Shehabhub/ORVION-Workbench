# Workbench Change Request - WS-047

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

## Objective

Make the owner's own Claude Code configuration survive a new Windows install, with the scope of data/records/WS-047/CONTRACT.md section 4. lib/Backup-Workspace.ps1 also copies keybindings.json, hooks\, the owner's own skills\ (never the cloud-synced skills\synced or skills\.trash) and local-marketplace\ (the usage meter plugin with /mode and the usage guard; never node_modules or the generated .claude-plugin\types) beside settings.json and statusline.ps1, and its header names what is kept and that .credentials.json never is. lib/Restore-Workspace.ps1 restores keybindings.json with the settings and hooks, skills and local-marketplace file by file: an absent file is copied, an existing file is kept and a differing backup copy is written once beside it as .restored. lib/Restore-ORVION.ps1's plugin checklist prints `claude plugin marketplace add "<ClaudeHome>\local-marketplace"` for the restored directory marketplace instead of the GitKraken step. lib/test-backup-restore.ps1 and lib/test-restore-orvion.ps1 add the cases (byte-identical copy and hash, the never-backed-up list, absent restore, keep and .restored over two rounds, the checklist line and its mutant). docs/RECOVERY.md's Holds and Leaves-out rows say so. changes/README.md gets the WS-047 row Organize -Refresh writes. Benefit (DEC-30: the owner can lose the machine without losing anything important): before WS-047 a new Windows install lost the usage meter, the run modes, the owner's hooks, skills and keybindings, and nothing printed how to get them back.

Tier: Significant under DEC-12 (it widens what the backup carries out of the owner's profile, where the credentials file must stay out, and what a restore writes into it). Governance check: every consumer listed (CONTRACT.md section 4); the owning tests run on the candidate with production mutants; one real backup and restore into empty folders after Complete; a retro closes the workstream. Authority: DEC-02, DEC-08, DEC-09, DEC-10, DEC-11, DEC-12, DEC-13, DEC-14, DEC-22, DEC-23, DEC-24, DEC-25, DEC-26, DEC-27, DEC-30 and DEC-33; the owner's words of 2026-11-22 23:29:52 Cairo frozen in data/records/WS-047/owner-words/owner-2026-11-22-claude-setup-survival.txt (SHA256 307A156A7C8A9CFB8274D56056BF5FA0B2032E20FCEDF549ADCF673D640B92E0), under the owner's delegation that the constitution decides in the owner's absence (data/records/WS-046/owner-words/owner-2026-11-21-constitution-decides-in-my-absence.txt, SHA256 DB34F67C2AF82D9A9751597247ABEEBD74B4BBB1CC6F47291D2572FE080EEAB0) and the live AFK Mode run instruction. Every scope choice (what is kept, what is left out, the restore rule) is Claude main's under that delegation, labelled DELEGATED; no owner text is typed by an agent (DEC-02).

Number: WS-047. Intended contract: changes/WS-047-claude-setup-survival.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: this contract changes neither lib/Invoke-ContractLifecycle.ps1 nor the judge and adds no script, so both roles run the Original's own controller (SHA256 AD76811656C7DAEEED7D214597F986178B57BA7943DE4B16F0438A33F57CEF57), its SHA256 checked before each stage, with the accepted judge. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

c069d9f8ed03d7bf6ce9134af5655225c7a25975

## Write Scope

- changes/README.md
- docs/RECOVERY.md
- lib/Backup-Workspace.ps1
- lib/Restore-ORVION.ps1
- lib/Restore-Workspace.ps1
- lib/test-backup-restore.ps1
- lib/test-restore-orvion.ps1
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: every other line of lib/Backup-Workspace.ps1, lib/Restore-Workspace.ps1 and lib/Restore-ORVION.ps1 (the package, vault, legacy, Git and memory blocks keep their behaviour); every other case of lib/test-backup-restore.ps1 and lib/test-restore-orvion.ps1; every other row of docs/RECOVERY.md and changes/README.md; lib/README.md (its Backup and Restore rows stay true); the live owner profile, .credentials.json, the plugin cache and plugin lists, the transcripts, %LOCALAPPDATA%\usage and the usage meter's own files (a real backup and restore after Complete writes only to empty folders under C:\tmp); lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Workbench.ps1 and every other lib/ file, test and hook; past changes/WS-0xx files; .claude/settings.json and the user settings in the owner's profile; data/ (untracked); the seven legacy folders, Owner-Tools, the vault and every package; any CRM or ORVION change (DEC-08); any Supabase project, Primary or Founder Secondary; credentials, real sessions or events (DEC-09); Codex, subagents, RAM, power or scheduled-task changes; any push or release before both roles are Complete (DEC-25).

## Draft Assurance

V1: WS047-V1-CLAUDE-SIGNIFICANT-DESIGN-20261123-01 | 2026-11-23 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-047\assurance\V1\DRAFT.md | 28D2F622FB3CB93F40E97CA543C4922010D04B99C08CE3DB0F9C6DD176C6D3B8
V2: WS047-V2-CLAUDE-SIGNIFICANT-ADVERSARIAL-20261123-01 | 2026-11-23 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-047\assurance\V2\DRAFT.md | 717E444437CA0D093949237B38AB904424C6E4CB4E9DC9581C3AFF65A98E0D3C
V3: WS047-V3-CLAUDE-REFRESH-20261123-01 | 2026-11-23 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-047\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V1 DESIGN by Claude main, claude-opus-5-5, under D120: the owner skipped Codex and subagents on 2026-11-08 ~01:20 Cairo, standing (the owner's words verbatim in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md; D124 wrote D120 into DEC-14 and DEC-19). Codex skipped by owner decision, not by unavailability. No Codex work is claimed and nothing here is independent. V1 designs the scope of data/records/WS-047/CONTRACT.md section 4 from the frozen candidate.

V2 ADVERSARIAL by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V2 attacks V1 and changes no output: (a) V1's filters were proven on fixtures; V2 checks them against the live tree (data/records/WS-047/review/live-claude-tree.txt, SHA256 F66282C43BEB313AC50120DA045CDE7BD2C47DFFC2E0EF5DCB929B721E5D01DC, counts only): 596 of the 598 live skill files are cloud-synced and skipped, so a lost filter would carry the account-delivered skills, which the SYNCED mutant proves the never-backed-up case catches; 5 of the 14 local-marketplace files are generated and skipped; and the live settings name local-mods as a directory marketplace whose leaf is local-marketplace, so the Draft check runs Write-RecoveryPluginChecklist on a reduced copy of those settings and requires the marketplace add line, the usage@local-mods install line and no GitKraken step; (b) .credentials.json is named in no Copy-Tree line: the backup copies four named items and the header says it never copies the credentials, and the never-backed-up case searches every backed-up file for the fixture credential text, so a later wildcard copy would fail it; (c) a restore never overwrites: an existing file is kept and its differing backup copy is written once as .restored, round 2 keeps an earlier .restored, and the OVERWRITE mutant proves the round 1 keep case catches an overwrite.

V3 REFRESH by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V3 changes no output and confirms the live facts on 2026-11-23: origin/main and the Original HEAD are both c069d9f8ed03d7bf6ce9134af5655225c7a25975; lib/Invoke-ContractLifecycle.ps1 is still SHA256 AD76811656C7DAEEED7D214597F986178B57BA7943DE4B16F0438A33F57CEF57 and lib/Test-WorkbenchChange.ps1 still 4E1F00E159B82ECDFDD0F0C542A08B71D77BBFE4ABAAB4B6B1B8377587017FD1; the pinned host is 7.6.8 and git 2.56.1.windows.1. The V2 Draft check passed with all three mutants killed and their bytes restored, no gitleaks finding and 0 of 74 hazards; it reused the V1 test results because the replay tree was identical, and V3 does the same under the same rule.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W47\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W47\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W47\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W47\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.56.1.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none. PowerShell 7.6.8 is the portable host in ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8, which WS-034 and WS-040 to WS-046 ran; git 2.56.1 is the live machine version.

1. Check whether `changes/README.md` contains `| WS-047-claude-setup-survival.md | contracts | Workbench Change Request - WS-047 | - | - |`; if so record Already Applied when its Git blob is dabe1bd14a2e45f443f1aec2ab3f42a94b780524, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-047 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-046-approve-sandbox-consistency-guard.md | contracts | Workbench Change Request - WS-046 | - | - |
   ```
   insert
   ```text
   | WS-047-claude-setup-survival.md | contracts | Workbench Change Request - WS-047 | - | - |
   ```

   The resulting file's Git blob is dabe1bd14a2e45f443f1aec2ab3f42a94b780524.

2. Check whether `docs/RECOVERY.md` contains `| Required evidence retained in the data root or declared as recovery inputs | Disposable nested clones, their ignored/uncommitted files and unique refs not preserved elsewhere; Claude/Codex program files; marketplace plugins (the checklist prints their reinstall commands) |`; if so record Already Applied when its Git blob is 703b1b4f5a1c9abb3144410665f4b2f4108b6ffe, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-047 candidate output), each matched once, and change nothing else:

   a) replace the lines
   ```text
   | Required evidence retained in the data root or declared as recovery inputs | Disposable nested clones, their ignored/uncommitted files and unique refs not preserved elsewhere; Claude/Codex program files and plugins |
   | Claude settings, statusline and ORVION project memory; Codex config.toml (URL passwords masked); declared recovery inputs (owner approvals, sealed proofs) | Everything outside the folders listed on the left |
   ```
   with
   ```text
   | Required evidence retained in the data root or declared as recovery inputs | Disposable nested clones, their ignored/uncommitted files and unique refs not preserved elsewhere; Claude/Codex program files; marketplace plugins (the checklist prints their reinstall commands) |
   | Claude settings, statusline, keybindings, hooks, own skills (not the cloud-synced ones), the local plugin marketplace (the usage meter) and ORVION project memory; Codex config.toml (URL passwords masked); declared recovery inputs (owner approvals, sealed proofs) | Everything outside the folders listed on the left |
   ```

   The resulting file's Git blob is 703b1b4f5a1c9abb3144410665f4b2f4108b6ffe.

3. Check whether `lib/Backup-Workspace.ps1` contains `#   claude\               user settings, statusline, keybindings, hooks\, own skills\ (not the cloud-synced skills\synced), the`; if so record Already Applied when its Git blob is 90e79e6df25d29ded238ddc0da5303abef6bc553, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-047 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   #   claude\               user settings only; memory lives in owner-tools\claude-memory (records\claude-memory before WS-033)
   ```
   with
   ```text
   #   claude\               user settings, statusline, keybindings, hooks\, own skills\ (not the cloud-synced skills\synced), the
   #                         local-marketplace\ plugins (the usage meter; no generated types or node_modules) (WS-047);
   #                         never .credentials.json. Memory lives in owner-tools\claude-memory (records\ before WS-033)
   ```

   b) immediately after the line
   ```text
   Copy-Tree "$env:USERPROFILE\.claude\statusline.ps1" (Join-Path $out 'claude')
   ```
   insert
   ```text
   # WS-047: the owner's own Claude configuration. Restore copies only what is absent; Restore-ORVION
   # prints the plugin reinstall steps from settings.json.
   $claudeRoot=Join-Path $env:USERPROFILE '.claude'
   Copy-Tree (Join-Path $claudeRoot 'keybindings.json') (Join-Path $out 'claude')
   Copy-Tree (Join-Path $claudeRoot 'hooks') (Join-Path $out 'claude\hooks')
   Copy-Tree (Join-Path $claudeRoot 'skills') (Join-Path $out 'claude\skills') {param($rel)$rel-match'^(synced|\.trash)\\'}
   Copy-Tree (Join-Path $claudeRoot 'local-marketplace') (Join-Path $out 'claude\local-marketplace') {param($rel)$rel-match'(^|\\)(node_modules|\.claude-plugin\\types)\\'}
   ```

   The resulting file's Git blob is 90e79e6df25d29ded238ddc0da5303abef6bc553.

4. Check whether `lib/Restore-ORVION.ps1` contains `# WS-047: Restore-Workspace puts the local marketplace (the usage meter) back into ClaudeHome\local-marketplace.`; if so record Already Applied when its Git blob is 5364f472c43930dab5ce1fbba535836fbf503e88, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-047 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
               if($source-and$source.source-eq'github'-and$source.repo){Write-Host "ACTION: claude plugin marketplace add $($source.repo)"}
   ```
   insert
   ```text
               # WS-047: Restore-Workspace puts the local marketplace (the usage meter) back into ClaudeHome\local-marketplace.
               elseif($source-and$source.source-eq'directory'-and$source.path-and(Split-Path $source.path -Leaf)-eq'local-marketplace'){Write-Host "ACTION: claude plugin marketplace add `"$(Join-Path (Split-Path $Settings -Parent) 'local-marketplace')`""}
   ```

   The resulting file's Git blob is 5364f472c43930dab5ce1fbba535836fbf503e88.

5. Check whether `lib/Restore-Workspace.ps1` contains `# (the package's owner-tools\, into ORVION-Workbench\data), Claude memory and configuration (WS-047: settings, hooks, skills,`; if so record Already Applied when its Git blob is 3bbaafb5a77eecaed14b178449955f6c5edbfbeb, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-047 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   # (the package's owner-tools\, into ORVION-Workbench\data), Claude memory and legacy folders.
   ```
   with
   ```text
   # (the package's owner-tools\, into ORVION-Workbench\data), Claude memory and configuration (WS-047: settings, hooks, skills,
   # the local plugin marketplace) and legacy folders.
   ```

   b) replace the line
   ```text
   foreach($f in 'settings.json','statusline.ps1'){
   ```
   with
   ```text
   foreach($f in 'settings.json','statusline.ps1','keybindings.json'){
   ```

   c) immediately after the lines
   ```text
       if(Test-Path $d){if(Test-Path "$d.restored"){"KEPT existing $d and $f.restored (nothing copied)"}else{Copy-Item $s "$d.restored";"KEPT existing $d (backup copy: $f.restored, merge by hand)"}}else{New-Item -ItemType Directory $ClaudeHome -Force|Out-Null;Copy-Item $s $d;"RESTORED $d"}
   }
   ```
   insert
   ```text
   # WS-047: hooks, own skills and the local plugin marketplace, file by file; an existing file is kept and a differing backup
   # copy is written once beside it as .restored. Restore-ORVION prints the plugin reinstall steps from settings.json.
   foreach($tree in 'hooks','skills','local-marketplace'){
       $src=Join-Path $From "claude\$tree";if(!(Test-Path -LiteralPath $src -PathType Container)){continue};$copied=0;$kept=0
       foreach($file in Get-ChildItem -LiteralPath $src -Recurse -File -Force){
           $d=Join-Path $ClaudeHome ("$tree\"+$file.FullName.Substring($src.Length+1))
           if(Test-Path -LiteralPath $d){$kept++;if(!(Test-Path -LiteralPath "$d.restored")-and(Get-FileHash -LiteralPath $d).Hash-cne(Get-FileHash -LiteralPath $file.FullName).Hash){Copy-Item -LiteralPath $file.FullName -Destination "$d.restored"}}
           else{[void][IO.Directory]::CreateDirectory((Split-Path $d -Parent));Copy-Item -LiteralPath $file.FullName -Destination $d;$copied++}
       }
       "RESTORED claude $tree ($copied copied, $kept existing kept; a differing backup copy sits beside it as .restored)"
   }
   ```

   The resulting file's Git blob is 3bbaafb5a77eecaed14b178449955f6c5edbfbeb.

6. Check whether `lib/test-backup-restore.ps1` contains `# WS-047: the owner's Claude configuration survives a new machine; credentials, cloud-synced skills and caches never leave it.`; if so record Already Applied when its Git blob is ba94fbf277a8e9a5b76ac0974b22af851b9f0362, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-047 candidate output), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
           [IO.File]::WriteAllText("$codexHome\config.toml.restored",'preserve earlier recovery')
       }
   ```
   insert
   ```text
       # WS-047: the owner's Claude configuration survives a new machine; credentials, cloud-synced skills and caches never leave it.
       $claudeFixture=Join-Path $env:USERPROFILE '.claude'
       $kept=[ordered]@{'settings.json'='{"fixture":"settings"}';'keybindings.json'='{"fixture":"keys"}';'hooks\hook.json'='fixture hook'
           'skills\mode\SKILL.md'='fixture mode skill';'local-marketplace\.claude-plugin\marketplace.json'='{"name":"local-mods"}'
           'local-marketplace\usage-meter\hooks\register.ts'='fixture meter'}
       $never=[ordered]@{'.credentials.json'='{"claudeAiOauth":"fixture-credential-never-copied"}';'skills\synced\cloud\SKILL.md'='fixture synced skill'
           'skills\.trash\old\SKILL.md'='fixture trashed skill';'local-marketplace\usage-meter\.claude-plugin\types\x.d.ts'='fixture generated'
           'local-marketplace\usage-meter\node_modules\m\index.js'='fixture module';'plugins\cache\big.bin'='fixture cache';'projects\p\x.jsonl'='fixture transcript'
           'plugins\known_marketplaces.json'='{"fixture":"plugin list"}';'plugins\installed_plugins.json'='{"fixture":"plugin list"}'}
       foreach($pair in @($kept.GetEnumerator())+@($never.GetEnumerator())){$file=Join-Path $claudeFixture $pair.Key;[void][IO.Directory]::CreateDirectory((Split-Path $file -Parent));[IO.File]::WriteAllText($file,$pair.Value)}
       $claudeOut=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination (Join-Path $t 'usb-claude') -AllowUnencrypted 2>&1)
       if($LASTEXITCODE-ne0){throw ('CLAUDE_BACKUP_FIXTURE_FAILED: '+($claudeOut-join' '))}
       $claudeBackup=@(Get-ChildItem (Join-Path $t 'usb-claude') -Directory)[0].FullName;$claudeSums=[IO.File]::ReadAllText("$claudeBackup\SHA256SUMS.txt")
       Assert-That 'Claude settings, keybindings, hooks, own skills, local marketplace are backed up byte-identically and hashed' (@($kept.Keys|Where-Object{!(Test-Path -LiteralPath "$claudeBackup\claude\$_")-or[IO.File]::ReadAllText("$claudeBackup\claude\$_")-cne$kept[$_]-or!$claudeSums.Contains((Get-FileHash -LiteralPath "$claudeBackup\claude\$_").Hash+"  claude\$_")}).Count-eq0) $claudeOut
       Assert-That 'credentials, synced and trashed skills, generated types, node_modules, plugin cache, plugin lists and transcripts are never backed up' (@($never.Keys|Where-Object{Test-Path -LiteralPath "$claudeBackup\claude\$_"}).Count-eq0-and!(Get-ChildItem -LiteralPath $claudeBackup -Recurse -File|Where-Object{[IO.File]::ReadAllText($_.FullName).Contains('fixture-credential-never-copied')}))
       $claudeHome=Join-Path $t 'ch-config'
       $claudeRestore=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $claudeBackup -Target (Join-Path $t 'claude-target-0') -ClaudeHome $claudeHome -LegacyTarget (Join-Path $t 'claude-docs-0') -CodexHome (Join-Path $t 'claude-codex-0') 2>&1)
       Assert-That 'absent Claude configuration restored byte-identically; no plugins folder is written' ($LASTEXITCODE-eq0-and@($kept.Keys|Where-Object{(!(Test-Path -LiteralPath "$claudeHome\$_")-or[IO.File]::ReadAllText("$claudeHome\$_")-cne$kept[$_])}).Count-eq0-and!(Test-Path -LiteralPath "$claudeHome\plugins")) $claudeRestore
       [IO.File]::WriteAllText("$claudeHome\hooks\hook.json",'owner hook')
       foreach($round in 1,2){
           $again=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $claudeBackup -Target (Join-Path $t "claude-target-$round") -ClaudeHome $claudeHome -LegacyTarget (Join-Path $t "claude-docs-$round") -CodexHome (Join-Path $t "claude-codex-$round") 2>&1)
           Assert-That "an existing Claude file is kept, a differing backup copy written once, an identical one none (round $round)" ($LASTEXITCODE-eq0-and[IO.File]::ReadAllText("$claudeHome\hooks\hook.json")-ceq'owner hook'-and!(Test-Path -LiteralPath "$claudeHome\skills\mode\SKILL.md.restored")-and$(if($round-eq1){[IO.File]::ReadAllText("$claudeHome\hooks\hook.json.restored")-ceq'fixture hook'}else{[IO.File]::ReadAllText("$claudeHome\hooks\hook.json.restored")-ceq'preserve earlier hook recovery'})) $again
           [IO.File]::WriteAllText("$claudeHome\hooks\hook.json.restored",'preserve earlier hook recovery')
       }
       [IO.Directory]::Delete($claudeFixture,$true)
   ```

   The resulting file's Git blob is ba94fbf277a8e9a5b76ac0974b22af851b9f0362.

7. Check whether `lib/test-restore-orvion.ps1` contains `# WS-047: the local marketplace (the usage meter) is re-added from the restored ClaudeHome copy, never via GitKraken.`; if so record Already Applied when its Git blob is 178ca6c8be46e2bfb59551aad461da347da137ff, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-047 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       Assert-That 'absent claude/list shows all enabled plugins including exact ponytail marketplace command' ($plugins.Contains('claude plugin marketplace add DietrichGebert/ponytail')-and@($plugins-split"`n"|Where-Object{$_-like'*claude plugin install *'}).Count-eq6)
   ```
   insert
   ```text
       # WS-047: the local marketplace (the usage meter) is re-added from the restored ClaudeHome copy, never via GitKraken.
       $localHome=Join-Path $t 'local-home';[void][IO.Directory]::CreateDirectory($localHome);$localSettings=Join-Path $localHome 'settings.json'
       [IO.File]::WriteAllText($localSettings,(@{enabledPlugins=@{'usage@local-mods'=$true};extraKnownMarketplaces=@{'local-mods'=@{source=@{source='directory';path='C:\Users\Elsewhere\.claude\local-marketplace'}}}}|ConvertTo-Json -Depth 8))
       $plugins=@(Write-RecoveryPluginChecklist $localSettings @() *>&1)-join"`n"
       Assert-That 'local marketplace is re-added from the restored ClaudeHome copy, then the usage plugin installed; no GitKraken step' ($plugins.Contains("ACTION: claude plugin marketplace add `"$localHome\local-marketplace`"")-and$plugins.Contains('ACTION: claude plugin install usage@local-mods --scope user')-and$plugins-notmatch'GitKraken'-and$plugins-notmatch'Elsewhere')
       Import-RecoveryFunctions ($source.Replace("-and(Split-Path `$source.path -Leaf)-eq'local-marketplace'){",'-and$false){'))
       $plugins=@(Write-RecoveryPluginChecklist $localSettings @() *>&1)-join"`n"
       Assert-That 'MUTANT killed: local marketplace branch removed' (!$plugins.Contains('claude plugin marketplace add')-and$plugins.Contains('GitKraken'))
       Import-RecoveryFunctions $source
   ```

   The resulting file's Git blob is 178ca6c8be46e2bfb59551aad461da347da137ff.

## Acceptance Criteria

- [x] Output `changes/README.md` equals its declared resulting Git blob. check: blob:changes/README.md=dabe1bd14a2e45f443f1aec2ab3f42a94b780524
- [x] Output `docs/RECOVERY.md` equals its declared resulting Git blob. check: blob:docs/RECOVERY.md=703b1b4f5a1c9abb3144410665f4b2f4108b6ffe
- [x] Output `lib/Backup-Workspace.ps1` equals its declared resulting Git blob. check: blob:lib/Backup-Workspace.ps1=90e79e6df25d29ded238ddc0da5303abef6bc553
- [x] Output `lib/Restore-ORVION.ps1` equals its declared resulting Git blob. check: blob:lib/Restore-ORVION.ps1=5364f472c43930dab5ce1fbba535836fbf503e88
- [x] Output `lib/Restore-Workspace.ps1` equals its declared resulting Git blob. check: blob:lib/Restore-Workspace.ps1=3bbaafb5a77eecaed14b178449955f6c5edbfbeb
- [x] Output `lib/test-backup-restore.ps1` equals its declared resulting Git blob. check: blob:lib/test-backup-restore.ps1=ba94fbf277a8e9a5b76ac0974b22af851b9f0362
- [x] Output `lib/test-restore-orvion.ps1` equals its declared resulting Git blob. check: blob:lib/test-restore-orvion.ps1=178ca6c8be46e2bfb59551aad461da347da137ff
- [x] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [x] AC-01 Backup and restore: lib/Backup-Workspace.ps1 (numstat 10/1) changes only its claude\ header line into three that name what is kept and that .credentials.json never is, and adds after the statusline copy exactly four Copy-Tree lines from %USERPROFILE%\.claude: keybindings.json, hooks\, skills\ skipping `^(synced|\.trash)\\` and local-marketplace\ skipping `(^|\\)(node_modules|\.claude-plugin\\types)\\`; it copies no credentials file, no plugins\ folder and no projects\ transcripts. lib/Restore-Workspace.ps1 (14/2) changes only its header and adds keybindings.json to the settings copy, then copies hooks, skills and local-marketplace file by file: an absent file is copied; an existing file is kept and, when its hash differs and no .restored copy exists yet, the backup copy is written once beside it as .restored; one RESTORED line per tree names both counts. lib/Restore-ORVION.ps1 (2/0) adds, between the github and the GitKraken branches of Write-RecoveryPluginChecklist, one branch for a directory marketplace whose path leaf is local-marketplace that prints `ACTION: claude plugin marketplace add "<ClaudeHome>\local-marketplace"` from the restored settings' folder; every other line of the three scripts keeps its bytes. On the replay the checklist reads the marketplace and plugin entries of this machine's live settings.json (copied into the check's side folder with no other key; review/live-claude-tree.txt) and prints the local-marketplace add line for the side folder and `ACTION: claude plugin install usage@local-mods --scope user`, with no GitKraken step, a probe the Draft check runs.
- [x] AC-02 Tests and documentation: lib/test-backup-restore.ps1 (25/0) backs up a fixture profile under the test's own USERPROFILE and adds exactly five cases: "Claude settings, keybindings, hooks, own skills, local marketplace are backed up byte-identically and hashed", "credentials, synced and trashed skills, generated types, node_modules, plugin cache, plugin lists and transcripts are never backed up", "absent Claude configuration restored byte-identically; no plugins folder is written" and "an existing Claude file is kept, a differing backup copy written once, an identical one none" for rounds 1 and 2. lib/test-restore-orvion.ps1 (9/0) adds "local marketplace is re-added from the restored ClaudeHome copy, then the usage plugin installed; no GitKraken step" and its in-test mutant. docs/RECOVERY.md changes only the "Holds" and "Leaves out" rows that name these items (2/2). No existing case is removed. Three production mutants on the replay must each make their owning test fail with the named case as its first FAIL line, and the Draft check must kill all three and restore the bytes: SYNCED (the backup's skills filter removed: the never-backed-up case), OVERWRITE (the restore's keep branch disabled so an existing file is overwritten: the round 1 keep case) and MARKETPLACE (the local-marketplace branch disabled in Restore-ORVION: the local marketplace case of test-restore-orvion).
- [x] AC-03 Organizer: changes/README.md is what lib/Organize.ps1 -Refresh writes: it holds the WS-047 row, and a refresh of the replay with this contract in place changes no organizer.
- [x] AC-04 Secrets and privacy: gitleaks on the exact candidate range reports no finding in the 7 outputs and RESUME.md; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; neither masked value (the computer name, a marketing tunnel script name) nor the owner's e-mail is in any changed file or in this contract; no backup or test output carries the fixture credential text.
- [x] AC-05 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria; the scope profiles include CONTROL, so the Finish runs the full test schedule, test-backup-restore, test-restore-orvion, test-workspace-layout, test-organize and test-markdown-consistency among it. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json. From each Finish launch to END: no Events -Add, Save-State or edit in a protected root, and Docker off.
- [x] AC-06 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-047/evidence/protected-before.json, captured before the sandbox Finish and again after Original Complete with data/records/WS-038/Capture-Protected.ps1; lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Workbench.ps1 and lib/README.md are unchanged; both roles ran the Original's controller whose SHA256 this Draft names; the live %USERPROFILE%\.claude, its .credentials.json and %LOCALAPPDATA%\usage are never written (the one real restore after Complete goes into empty folders under C:\tmp); the user settings are unchanged; CRM, ORVION and their trusted copies keep their HEAD and files (the lifecycle's protected-root compare); no Supabase project is touched; no Codex, subagent, RAM, power setting or scheduled task change; no push before both roles are Complete.

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
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-047\assurance\V3\DRAFT.md
Approved SHA256: 888E6783289240F12B00150038B31EFFCBA35987AE85E5ABEF4205A780330F9A
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-047\gate\GATE1-WS047-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: E17060EAC93669A9B655A729991EC9B593C362AA60D88A4057F67B65214F2BF9
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W47\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 76051F53C174E4798C43708D20C3C0A029833EF70F055E209125442B2533D2BD
Original exact declared outputs applied by accepted native Execute; fresh own Finish and Review/Complete remain required. Other protected roots unchanged. Controller: the Original's own lib/Invoke-ContractLifecycle.ps1 (SHA256 AD768116), unchanged by this contract and used by both roles, checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority.
Residual risks carried unchanged from the selected Draft Review Gate and data/records/WS-047/CONTRACT.md; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (D120, frozen in data/records/WS-034/owner-words), not by unavailability. Controller: the Original's own lib/Invoke-ContractLifecycle.ps1 (SHA256 AD768116), unchanged by this contract and used by both roles, checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority. Release is a later stage (DEC-25), after Original Complete and the retro.

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W47-c2 (data/records/WS-047/Make-Candidate.ps1). Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json beside this Draft. After Complete, outside this contract: the release under DEC-25 on the DELEGATED record, only when every gate passed and Claude main's retro is satisfied; the protected state is compared with its record from before; one real backup of this machine and a restore of its Claude block into empty folders under C:\tmp prove .credentials.json absent and the copies byte-identical; Save-State records the result.
Verdict: Confirmed Complete
Reviewed Fingerprint: 821CD34A92C9F2DA2F9BE0F3BAEB15BE3F8369E701D14F6A1B4BEF5629F5A5A4
Reviewed Receipt: D9670446316CACE80A1AE40037EDC551AF6F28FAA47D0A4C353DDAB85A1F1566
Live ORIGINAL-role review: runtime/original/criterion-review.json. Own Finish 32 ordered suites, runner/watcher/host 0/0/0, real journal unchanged. Review: ONE Claude-main SELF-REVIEW, not independent; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (D120, frozen in data/records/WS-034/owner-words), not by unavailability. Exact completed sandbox proof 12A5EFDD8C489C89A756212CD12B9B24E29B6A04262C562172B08DE36B74A35E bound. Not pushed; the one release (DEC-25) follows only on every gate passed and the retro, under the owner's request and AFK Mode (DELEGATED).

