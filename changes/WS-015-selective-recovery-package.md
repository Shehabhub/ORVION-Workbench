# Workbench Change Request - WS-015

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

## Objective

Make the workstation recoverable before the owner reinstalls Windows: one selective compressed package, unencrypted by owner decision, with a redacted secret-scan report (Backup-Workspace -Package, Restore-Workspace -Package) that adds the missing GitHub\ORVION-Owner-Tools journal/sessions, keeps each nested clone's unique state (receipts, unique commits, uncommitted work) and drops only regenerable material; document the exact reinstall procedure and an agent orientation in README so a fresh agent continues from the repository alone; record the owner-delegated HANDOFF §12 amendment (C1/C2 split, Shared Evidence waived, CTRL-19 OPEN with accepted risk) and decouple Batch 6 from Workbench Stages 2-7.

## Baseline

ca081c33e1c6767c468de3e453f51d56de50b54b

## Write Scope

- lib/Backup-Workspace.ps1
- lib/Restore-Workspace.ps1
- lib/test-backup-restore.ps1
- docs/RECOVERY.md
- HANDOFF.md
- docs/EXECUTION-PLAN.md
- RESUME.md
- README.md
- lib/README.md

## Out of Scope

All other engineering paths except native allocation/status/pointer bookkeeping. No checker, recipe driver, workflow, hook, product or GitHub setting change; no Windows Sandbox; no upload of the historical archive; no deletion or move of any evidence or unrelated file; no secret value in tests, logs, reports or transcripts; no trust advancement. Running the real package, its cloud copy, the C1 restore, the Founder CR and the hold lift are post-Complete operations, not steps of this contract. CTRL-19 stays OPEN; Batch 6/Phase 8 stay ON HOLD until the HANDOFF §12 lift record.

## Draft Assurance

V1: WS015-PACKAGE-DESIGN | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws015-package\assurance\V1\DRAFT.md | B8B884F65C84F3497DE77D2652D2F8A201FFE9DFDD7F50E946B510656D551217
V2: WS015-PACKAGE-ADVERSARIAL | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws015-package\assurance\V2\DRAFT.md | FE871AFBB2F826965A5F4BF48F49D9E67D9A078537CE2F5D7DC4C432AA399343
V3: WS015-PACKAGE-REFRESH | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws015-package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSpkg15
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSpkg15\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSpkg15\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws015-package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/Backup-Workspace.ps1` contains `Selective package v1:`; if so record Already Applied when its Git blob is 168d936f208dd2e4fc13f1b7ccf300642206a847, and otherwise stop and report. Otherwise make exactly these 17 edits (selective unencrypted recovery package, C1 restore, agent orientation and the amended Batch 6 gate only), each matched once, and change nothing else:

   a) replace the line
   ```text
   #   owner-tools\          this workspace (tools, sessions archive, events, work) minus work\sandboxes (disposable clones)
   ```
   with
   ```text
   #   owner-tools\          GitHub\ORVION-Owner-Tools (sessions archive, events journal, work) minus work\sandboxes (disposable clones)
   ```

   b) replace the lines
   ```text
   #   legacy\               Documents\ORVION-Owner-Review, -Owner-Tools, -Sandbox, -drafts-backup, Windows-Memory-Config until migrated
   #                         (nested git clones skipped: reproducible sandboxes)
   ```
   with
   ```text
   #   legacy\               Documents\ORVION-Owner-Review, -Owner-Tools, -Owner-Recovery, -Sandbox, -drafts-backup, Windows-Memory-Config
   #                         (node_modules skipped; a nested clone keeps only what no main bundle holds: its ignored files in
   #                         place, .clone-state\ unique.bundle (HEAD and every other tip absent from the main bundles),
   #                         staged.diff, worktree.diff, untracked\, state.json)
   ```

   c) immediately after the line
   ```text
   # Session transcripts are sensitive, so the destination must be BitLocker-protected unless -AllowUnencrypted is passed.
   ```
   insert
   ```text
   # -Package writes one compressed, UNENCRYPTED 7z instead (owner decision 2026-10-26: recoverability over secrecy), staged under
   # TEMP and removed. gitleaks (when installed) scans the staging first and writes <archive>.secret-scan.txt next to it: rule,
   # file and line only, never a value. The scan reports; it does not block. docs\RECOVERY.md says what to do with findings.
   ```

   d) replace the line
   ```text
   param([Parameter(Mandatory)][string]$Destination,[switch]$AllowUnencrypted,[switch]$SkipLegacy,[string]$RecoveryInputs)
   ```
   with
   ```text
   param([Parameter(Mandatory)][string]$Destination,[switch]$AllowUnencrypted,[switch]$SkipLegacy,[string]$RecoveryInputs,[switch]$Package)
   ```

   e) replace the line
   ```text
   function Invoke-Git{param([string]$Repo)$o=& git -C $Repo @args 2>&1;if($LASTEXITCODE){throw "GIT_FAILED $Repo git $args`n$o"};$o}
   ```
   with
   ```text
   # Selective package v1: the data root is fixed; the script's own checkout is already a repository bundle.
   $ownerTools=Join-Path $gh 'ORVION-Owner-Tools'
   # Selective package v1: on success only stdout is returned; stderr warnings (CRLF) must never count as entries.
   # A failure names the subcommand and masks URL credentials: arguments and output may carry config values.
   function Invoke-Git{param([string]$Repo)$o=& git -C $Repo @args 2>&1;if($LASTEXITCODE){throw "GIT_FAILED $Repo git $($args[0]) (exit $LASTEXITCODE)`n$("$o"-replace'://[^/@\s]+@','://***@')"};$o|Where-Object{$_-isnot[Management.Automation.ErrorRecord]}}
   function Get-SevenZip{$z=(Get-Command 7z -CommandType Application -ErrorAction SilentlyContinue|Select-Object -First 1).Source;if(!$z){$z=Join-Path $env:ProgramFiles '7-Zip\7z.exe'};if(!(Test-Path -LiteralPath $z)){throw 'PACKAGE_7ZIP_REQUIRED'};$z}
   ```

   f) immediately after the lines
   ```text
   function Get-SevenZip{$z=(Get-Command 7z -CommandType Application -ErrorAction SilentlyContinue|Select-Object -First 1).Source;if(!$z){$z=Join-Path $env:ProgramFiles '7-Zip\7z.exe'};if(!(Test-Path -LiteralPath $z)){throw 'PACKAGE_7ZIP_REQUIRED'};$z}

   ```
   insert
   ```text
   if($Package){
       $zip=Get-SevenZip
       # Selective package v1: a package without both products is incomplete; refuse instead of omitting them.
       foreach($n in 'CRM','ORVION','CRM-trusted-main','ORVION-trusted-main'){if(!(Test-Path -LiteralPath (Join-Path $gh "$n\.git"))){throw "PACKAGE_REPO_REQUIRED: $n"}}
       $staging=Join-Path ([IO.Path]::GetTempPath()) ("orvion-package-"+[guid]::NewGuid().ToString('N'))
       $out=Join-Path $staging ("orvion-backup-"+[DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))
   }else{
   ```

   g) immediately after the line
   ```text
   $out=Join-Path $Destination ("orvion-backup-"+[DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))
   ```
   insert
   ```text
   }
   ```

   h) immediately after the line
   ```text
   if(Test-Path $out){throw "exists: $out"};New-Item -ItemType Directory $out|Out-Null
   ```
   insert
   ```text
   try{
   ```

   i) immediately after the lines
   ```text
           if(!(Test-Path -LiteralPath (Join-Path $gh "$name/.git") -PathType Container)){throw 'BACKUP_WORKBENCH_ROOT_REQUIRED'}
       }
   ```
   insert
   ```text
       if(!(Test-Path -LiteralPath (Join-Path $ownerTools 'events\events.jsonl') -PathType Leaf)-or!(Test-Path -LiteralPath (Join-Path $ownerTools 'sessions') -PathType Container)){throw 'BACKUP_JOURNAL_REQUIRED'}
   ```

   j) replace the line
   ```text
   $plan=[ordered]@{created=[DateTime]::UtcNow.ToString('o');machine=$env:COMPUTERNAME;repos=@()}
   ```
   with
   ```text
   $plan=[ordered]@{created=[DateTime]::UtcNow.ToString('o');machine=$env:COMPUTERNAME;repos=@()};$bundledTips=@{}
   ```

   k) immediately after the line
   ```text
       $stash=@(Invoke-Git $r stash list).Count;$worktrees=@(Invoke-Git $r worktree list --porcelain|Where-Object{$_-like'worktree *'}).Count-1
   ```
   insert
   ```text
       # Selective package v1: a package refuses state a bundle cannot carry instead of only warning about it.
       if($Package-and($dirty-or$stash-gt1-or$worktrees-gt0)){throw "PACKAGE_MAIN_REPO_STATE_NOT_PRESERVABLE: $name dirty=$dirty stash=$stash worktrees=$worktrees (commit, push or remove it first)"}
   ```

   l) immediately after the line
   ```text
       Invoke-Git $r bundle verify (Join-Path $out "repos\$name.bundle")|Out-Null
   ```
   insert
   ```text
       $bundledTips[$r]=@(Invoke-Git $r bundle list-heads (Join-Path $out "repos\$name.bundle")|ForEach-Object{($_-split' ')[0]}|Sort-Object -Unique)
   ```

   m) replace the line
   ```text
       [IO.File]::WriteAllLines((Join-Path $dir 'refs.txt'),[string[]](Invoke-Git $r for-each-ref --format='%(objectname) %(refname)'))
   ```
   with
   ```text
       [IO.File]::WriteAllLines((Join-Path $dir 'refs.txt'),[string[]]@(Invoke-Git $r for-each-ref --format='%(objectname) %(refname)'))  # a detached trusted clone may hold no refs
   ```

   n) replace the line
   ```text
   Copy-Tree $tools (Join-Path $out 'owner-tools') {param($rel)$rel-like'work\sandboxes\*'}
   ```
   with
   ```text
   if($Package-and@(Get-ChildItem -LiteralPath (Join-Path $ownerTools 'work\sandboxes') -Recurse -File -Force -ErrorAction SilentlyContinue).Count){throw 'PACKAGE_OWNER_SANDBOXES_NOT_PRESERVED: work\sandboxes holds files; capture or remove them first'}
   Copy-Tree $ownerTools (Join-Path $out 'owner-tools') {param($rel)$rel-like'work\sandboxes\*'}
   ```

   o) replace the line
   ```text
   if(!$SkipLegacy){foreach($n in 'ORVION-Owner-Review','ORVION-Owner-Tools','ORVION-Sandbox','ORVION-drafts-backup','Windows-Memory-Config'){
   ```
   with
   ```text
   # Selective package v1: a nested clone is regenerated from its recorded origin/HEAD; only state no main bundle holds is kept.
   function Save-CloneState([string]$Clone,[string]$To){
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
       [ordered]@{head=$head;branch="$(& git -C $Clone symbolic-ref -q --short HEAD)".Trim();origin="$(& git -C $Clone config --get remote.origin.url)".Trim();refs=$refs;unique=$unique}|ConvertTo-Json -Depth 3|Set-Content (Join-Path $state 'state.json')
   }
   if(!$SkipLegacy){foreach($n in 'ORVION-Owner-Review','ORVION-Owner-Tools','ORVION-Owner-Recovery','ORVION-Sandbox','ORVION-drafts-backup','Windows-Memory-Config'){
   ```

   p) replace the lines
   ```text
       # nested clones are reproducible sandboxes; a legacy folder that is itself a repository keeps its files, not its .git
       $clones=@(Get-ChildItem $src -Recurse -Force -Directory -Filter .git -ErrorAction SilentlyContinue|ForEach-Object{$p=$_.Parent.FullName;if($p.Length-gt$src.Length){$p.Substring($src.Length+1)+'\'}else{'.git\'}})
       Copy-Tree $src (Join-Path $out "legacy\$n") {param($rel)foreach($c in $clones){if($rel.StartsWith($c)){return $true}};$false}
   ```
   with
   ```text
       # a legacy folder that is itself a repository keeps its files, not its .git; node_modules is reinstalled from its lockfile
       # Only a .git that Git accepts as its work tree's top is a clone; a broken one is ordinary data and is copied whole.
       # A .git FILE (linked worktree, submodule) marks a work tree too, so its own state is captured, never dropped.
       $clones=@(Get-ChildItem $src -Recurse -Force -Filter .git -ErrorAction SilentlyContinue|ForEach-Object{Split-Path $_.FullName -Parent}|Where-Object{$top="$(& git -C $_ rev-parse --show-toplevel 2>$null)";!$LASTEXITCODE-and$top-and[IO.Path]::GetFullPath($top)-eq$_}|ForEach-Object{if($_.Length-gt$src.Length){$_.Substring($src.Length+1)+'\'}else{'.git\'}})
       Copy-Tree $src (Join-Path $out "legacy\$n") {param($rel)if($rel-match'(^|\\)node_modules\\'){return $true};foreach($c in $clones){if($rel.StartsWith($c)){return $true}};$false}
       foreach($c in $clones){$rel=if($c-eq'.git\'){''}else{$c};Save-CloneState (Join-Path $src $rel) (Join-Path $out "legacy\$n\$rel")}
   ```

   q) immediately after the line
   ```text
   '  not backed up by design: supabase\.temp (recreated by `supabase link`), credentials (re-login: gh auth login, supabase login)'
   ```
   insert
   ```text
   if($Package){
       New-Item -ItemType Directory $Destination -Force|Out-Null
       $archive=Join-Path $Destination ((Split-Path $out -Leaf)+'.7z');if(Test-Path -LiteralPath $archive){throw "exists: $archive"}
       # Selective package v1: identify secrets without exposing them; the JSON report stays in the staging that is deleted below.
       # Report-only: the sidecar always records the outcome; Git history inside the *.bundle files is not scanned.
       $scan="$archive.secret-scan.txt";$scope='files only; Git history inside *.bundle is not scanned'
       if(Get-Command gitleaks -CommandType Application -ErrorAction SilentlyContinue){
           $report=Join-Path $staging 'gitleaks.json'
           & gitleaks dir $out --redact --no-banner --exit-code 0 --report-format json --report-path $report 2>&1|Out-Null
           if($LASTEXITCODE-or!(Test-Path -LiteralPath $report)){$scanLine="SECRET SCAN: FAILED (gitleaks exit $LASTEXITCODE); package made without a scan";[IO.File]::WriteAllLines($scan,[string[]]@($scanLine))}
           else{
               $findings=@(Get-Content -LiteralPath $report -Raw|ConvertFrom-Json)|Where-Object{$_}
               [IO.File]::WriteAllLines($scan,[string[]]@("gitleaks $(& gitleaks version) findings: $($findings.Count) (rule, file:line; values never recorded; $scope)")+@($findings|ForEach-Object{"$($_.RuleID)  $($_.File.Replace('\','/').Replace($out.Replace('\','/')+'/','')):$($_.StartLine)"}|Sort-Object))
               $scanLine="SECRET SCAN: $($findings.Count) finding(s) -> $scan"
           }
       }else{$scanLine='SECRET SCAN: SKIPPED (gitleaks not installed)';[IO.File]::WriteAllLines($scan,[string[]]@($scanLine))}
       $o=& $zip a -t7z -mx7 $archive $out 2>&1;if($LASTEXITCODE){throw "PACKAGE_FAILED ($LASTEXITCODE)`n$o"}
       $o=& $zip t $archive 2>&1;if($LASTEXITCODE){throw "PACKAGE_VERIFY_FAILED ($LASTEXITCODE)"}
       $packageLine="PACKAGE: $archive $([math]::Round((Get-Item $archive).Length/1MB,1)) MB SHA256 $((Get-FileHash -LiteralPath $archive).Hash) (unencrypted; staging removed)"
   }
   }finally{if($Package-and$staging-and(Test-Path -LiteralPath $staging)){Get-ChildItem $staging -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($staging,$true)}}
   # Printed only after the staging is gone; an interrupted run leaves %TEMP%\orvion-package-* to delete by hand.
   if($packageLine){$scanLine;$packageLine}
   ```

   The resulting file's Git blob is 168d936f208dd2e4fc13f1b7ccf300642206a847.

2. Check whether `lib/Restore-Workspace.ps1` contains `Selective package v1:`; if so record Already Applied when its Git blob is 3806c46d24eff5b3b5cb5f728de098ecac6c4db4, and otherwise stop and report. Otherwise make exactly these 6 edits (selective unencrypted recovery package, C1 restore, agent orientation and the amended Batch 6 gate only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   param([Parameter(Mandatory)][string]$From,[string]$Target=(Join-Path $env:USERPROFILE 'Documents\GitHub'),
         [string]$ClaudeHome=(Join-Path $env:USERPROFILE '.claude'),[string]$LegacyTarget=(Join-Path $env:USERPROFILE 'Documents'),[switch]$SkipLegacy)
   ```
   with
   ```text
   # Selective package v1: -Package <file.7z> extracts a Backup-Workspace -Package archive into TEMP first (removed afterwards).
   param([string]$From,[string]$Target=(Join-Path $env:USERPROFILE 'Documents\GitHub'),
         [string]$ClaudeHome=(Join-Path $env:USERPROFILE '.claude'),[string]$LegacyTarget=(Join-Path $env:USERPROFILE 'Documents'),[switch]$SkipLegacy,
         [string]$Package)
   ```

   b) replace the line
   ```text
   function Invoke-Git{param([string]$Repo)$o=& git -C $Repo @args 2>&1;if($LASTEXITCODE){throw "GIT_FAILED $Repo git $args`n$o"};$o}
   ```
   with
   ```text
   # stdout only on success; a failure names the subcommand and masks URL credentials (config values pass through here)
   function Invoke-Git{param([string]$Repo)$o=& git -C $Repo @args 2>&1;if($LASTEXITCODE){throw "GIT_FAILED $Repo git $($args[0]) (exit $LASTEXITCODE)`n$("$o"-replace'://[^/@\s]+@','://***@')"};$o|Where-Object{$_-isnot[Management.Automation.ErrorRecord]}}
   ```

   c) immediately after the lines
   ```text
   function Assert-Absent([string]$Path){if(Test-Path -LiteralPath $Path){throw "RESTORE_TARGET_EXISTS: $Path (restore never overwrites)"}}

   ```
   insert
   ```text
   if(!$From-eq!$Package){throw 'RESTORE_SOURCE_REQUIRED: pass exactly one of -From or -Package'}
   try{
   if($Package){
       $zip=(Get-Command 7z -CommandType Application -ErrorAction SilentlyContinue|Select-Object -First 1).Source;if(!$zip){$zip=Join-Path $env:ProgramFiles '7-Zip\7z.exe'}
       if(!(Test-Path -LiteralPath $zip)){throw 'PACKAGE_7ZIP_REQUIRED'}
       $staging=Join-Path ([IO.Path]::GetTempPath()) ("orvion-restore-"+[guid]::NewGuid().ToString('N'))
       $o=& $zip x "-o$staging" $Package 2>&1;if($LASTEXITCODE){throw "PACKAGE_EXTRACT_FAILED ($LASTEXITCODE): damaged package: $(@($o|Where-Object{"$_"-match'ERROR|Cannot'})-join' ')"}
       $From=@(Get-ChildItem -LiteralPath $staging -Directory)[0].FullName
   }
   ```

   d) immediately after the line
   ```text
       & git clone --quiet --no-checkout (Join-Path $From "repos\$($r.name).bundle") $dest 2>&1|Out-Null;if($LASTEXITCODE){throw "CLONE_FAILED $($r.name)"}
   ```
   insert
   ```text
       Invoke-Git $dest config --local core.longpaths true|Out-Null  # a fresh Windows has no long-path default; set before checkout
   ```

   e) replace the line
   ```text
       if(Test-Path $d){Copy-Item $s "$d.restored";"KEPT existing $d (backup copy: $f.restored, merge by hand)"}else{New-Item -ItemType Directory $ClaudeHome -Force|Out-Null;Copy-Item $s $d;"RESTORED $d"}
   ```
   with
   ```text
       if(Test-Path $d){if(Test-Path "$d.restored"){"KEPT existing $d and $f.restored (nothing copied)"}else{Copy-Item $s "$d.restored";"KEPT existing $d (backup copy: $f.restored, merge by hand)"}}else{New-Item -ItemType Directory $ClaudeHome -Force|Out-Null;Copy-Item $s $d;"RESTORED $d"}
   ```

   f) immediately after the line
   ```text
   "NEXT: gh auth login (PlatPlusHub and Shehabhub), then Boot in each repository."
   ```
   insert
   ```text
   }finally{if($staging-and(Test-Path -LiteralPath $staging)){Get-ChildItem $staging -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($staging,$true)}}
   ```

   The resulting file's Git blob is 3806c46d24eff5b3b5cb5f728de098ecac6c4db4.

3. Check whether `lib/test-backup-restore.ps1` contains `Selective package v1:`; if so record Already Applied when its Git blob is 94fb9892c329026fd6dcd4add3ed271c70a6f2c1, and otherwise stop and report. Otherwise make exactly these 2 edits (selective unencrypted recovery package, C1 restore, agent orientation and the amended Batch 6 gate only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       # Workbench recovery coverage v1: independent source/trusted, exact historical receipts and declared proof bytes.
   ```
   insert
   ```text
       # Selective package v1: a present Workbench requires the one journal and sessions archive under GitHub\ORVION-Owner-Tools.
       $journal=Join-Path $gh 'ORVION-Owner-Tools\events\events.jsonl';[void][IO.Directory]::CreateDirectory((Split-Path $journal -Parent));[IO.File]::WriteAllText($journal,"{`"fixture`":`"journal`"}`n")
       $session=Join-Path $gh 'ORVION-Owner-Tools\sessions\raw\s.jsonl';[void][IO.Directory]::CreateDirectory((Split-Path $session -Parent));[IO.File]::WriteAllText($session,'fixture session')
   ```

   b) immediately after the line
   ```text
       Assert-That 'required input omitted together with manifest entry still refuses before writes' ($LASTEXITCODE-ne0-and($omitted-join' ')-match'RESTORE_WORKBENCH_INPUT_REQUIRED'-and!(Test-Path (Join-Path $t 'wb-omitted')))
   ```
   insert
   ```text
       # Selective package v1: run from a production-shaped checkout (lib not under ORVION-Owner-Tools), as the real tool does.
       $probeLib=Join-Path $gh 'Workbench-checkout\lib';[void][IO.Directory]::CreateDirectory($probeLib)
       Copy-Item (Join-Path $lib 'Backup-Workspace.ps1'),(Join-Path $lib 'Restore-Workspace.ps1') $probeLib
       $journalBytes=[IO.File]::ReadAllBytes($journal);[IO.File]::Delete($journal)
       $noJournal=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination (Join-Path $t 'no-journal') -RecoveryInputs $inputs -AllowUnencrypted 2>&1)
       Assert-That 'missing journal blocks a Workbench backup without success' ($LASTEXITCODE-ne0-and($noJournal-join' ')-match'BACKUP_JOURNAL_REQUIRED'-and($noJournal-join' ')-notmatch'BACKUP:')
       [IO.File]::WriteAllBytes($journal,$journalBytes)
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
       # A package refuses state a bundle cannot carry; the earlier stash-warning fixture is cleared for the package cases.
       Invoke-Quiet $crm stash clear|Out-Null
       [void][IO.Directory]::CreateDirectory("$nested\.workbench-certifications");[IO.File]::WriteAllText("$nested\.workbench-certifications\r.json",'{"nested":"receipt"}')
       $broken=Join-Path $t 'ORVION-Sandbox\evidence\broken';[void][IO.Directory]::CreateDirectory("$broken\.git");[IO.File]::WriteAllText("$broken\.git\HEAD",'not a repository');[IO.File]::WriteAllText("$broken\data.txt",'kept')
       $modules=Join-Path $t 'ORVION-Sandbox\evidence\node_modules\pkg';[void][IO.Directory]::CreateDirectory($modules);[IO.File]::WriteAllText("$modules\x.js",'regenerable')
       # The real trusted clone is detached with no refs at all; its bundle and restore must still round trip.
       foreach($ref in @(Invoke-Quiet $trusted for-each-ref --format='%(refname)')){& git -C $trusted update-ref --no-deref -d $ref;if($LASTEXITCODE){throw 'TRUSTED_REF_FIXTURE_FAILED'}}
       $zip=(Get-Command 7z -CommandType Application -ErrorAction SilentlyContinue|Select-Object -First 1).Source;if(!$zip){$zip=Join-Path $env:ProgramFiles '7-Zip\7z.exe'}
       $cloud=Join-Path $t 'cloud';$pkgTemp=Join-Path $t 'pkg-temp';[void][IO.Directory]::CreateDirectory($pkgTemp)
       # A token-shaped value built at run time, so this file never holds one: the scan must name it without its value.
       $planted='ghp_'+-join((48..57)+(65..90)+(97..122)|Get-Random -Count 36|ForEach-Object{[char]$_});[IO.File]::WriteAllText((Join-Path $t 'ORVION-Sandbox\evidence\leak.txt'),"token=$planted")
       $savedTemp=$env:TEMP;$savedTmp=$env:TMP;$env:TEMP=$pkgTemp;$env:TMP=$pkgTemp
       try{
           $missing=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination $cloud -RecoveryInputs $inputs -Package 2>&1)
           Assert-That 'a package without a product repository refuses before any archive' ($LASTEXITCODE-ne0-and($missing-join' ')-match'PACKAGE_REPO_REQUIRED: ORVION-trusted-main'-and!(Test-Path $cloud))
           & git clone -q $remote (Join-Path $gh 'ORVION-trusted-main') 2>&1|Out-Null;if($LASTEXITCODE){throw 'PRODUCT_FIXTURE_FAILED ORVION-trusted-main'}
           $pkg=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination $cloud -RecoveryInputs $inputs -Package 2>&1)
           if($LASTEXITCODE){throw ('PACKAGE_FIXTURE_FAILED: '+($pkg-join' '))}
           $archive=@(Get-ChildItem $cloud -Filter *.7z -Force)[0].FullName;$scan="$archive.secret-scan.txt"
           Assert-That 'package destination holds one archive plus its scan report and staging is removed' (@(Get-ChildItem $cloud -Force).Count-eq2-and(Test-Path $scan)-and$archive-and@(Get-ChildItem $pkgTemp -Force).Count-eq0-and($pkg-join' ')-match'PACKAGE: .*unencrypted')
           if(Get-Command gitleaks -CommandType Application -ErrorAction SilentlyContinue){
               Assert-That 'secret scan names the planted token by rule and path, never its value' ([IO.File]::ReadAllText($scan)-match'github-pat  legacy/ORVION-Sandbox/evidence/leak\.txt:1'-and[IO.File]::ReadAllText($scan)-notmatch$planted-and($pkg-join' ')-notmatch$planted-and($pkg-join' ')-match'SECRET SCAN: [1-9]')
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
           [IO.File]::WriteAllText((Join-Path $wb 'uncommitted.txt'),'work in progress')
           $dirtyMain=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination (Join-Path $t 'cloud3') -RecoveryInputs $inputs -Package 2>&1)
           Assert-That 'a package refuses uncommitted main-repository work instead of warning' ($LASTEXITCODE-ne0-and($dirtyMain-join' ')-match'PACKAGE_MAIN_REPO_STATE_NOT_PRESERVABLE'-and!(Test-Path (Join-Path $t 'cloud3')))
           [IO.File]::Delete((Join-Path $wb 'uncommitted.txt'))
           $listing=@(& $zip l -slt $archive 2>&1)
           Assert-That 'archive headers and every entry are unencrypted (owner decision)' ($LASTEXITCODE-eq0-and($listing-join' ')-match'SHA256SUMS\.txt'-and($listing-join' ')-match'Encrypted = -'-and($listing-join' ')-notmatch'Encrypted = \+')
           $damaged=Join-Path $t 'damaged.7z';$bytes=[IO.File]::ReadAllBytes($archive);[IO.File]::WriteAllBytes($damaged,$bytes[0..([int]($bytes.Length/2))])
           $wrong=@(& pwsh -NoProfile -File "$probeLib\Restore-Workspace.ps1" -Package $damaged -Target (Join-Path $t 'pkg-wrong') -ClaudeHome (Join-Path $t 'pkg-wrong-ch') -LegacyTarget (Join-Path $t 'pkg-wrong-docs') 2>&1)
           Assert-That 'a damaged archive refuses before any restore target and leaves no staging' ($LASTEXITCODE-ne0-and($wrong-join' ')-match'PACKAGE_EXTRACT_FAILED'-and!(Test-Path (Join-Path $t 'pkg-wrong'))-and@(Get-ChildItem $pkgTemp -Force).Count-eq0)
           $both=@(& pwsh -NoProfile -File "$probeLib\Restore-Workspace.ps1" -Package $archive -From $wbb -Target (Join-Path $t 'pkg-both') 2>&1)
           Assert-That 'exactly one restore source is required' ($LASTEXITCODE-ne0-and($both-join' ')-match'RESTORE_SOURCE_REQUIRED'-and!(Test-Path (Join-Path $t 'pkg-both')))
           $pkgTarget=Join-Path $t 'pkg-restored';$pkgDocs=Join-Path $t 'pkg-docs'
           $restoredPkg=@(& pwsh -NoProfile -File "$probeLib\Restore-Workspace.ps1" -Package $archive -Target $pkgTarget -ClaudeHome (Join-Path $t 'pkg-ch') -LegacyTarget $pkgDocs 2>&1)
           if($LASTEXITCODE){throw ('PACKAGE_RESTORE_FIXTURE_FAILED: '+($restoredPkg-join' '))}
           Assert-That 'package restore leaves no plaintext staging and rebuilds the exact source HEAD' (@(Get-ChildItem $pkgTemp -Force).Count-eq0-and(& git -C "$pkgTarget/ORVION-Workbench" rev-parse HEAD)-ceq(& git -C $wb rev-parse HEAD))
           Assert-That 'a ref-less detached trusted clone round trips at its exact HEAD' ((& git -C "$pkgTarget/ORVION-Workbench-trusted-main" rev-parse HEAD)-ceq(& git -C $trusted rev-parse HEAD)-and(& git -C "$pkgTarget/ORVION-Workbench-trusted-main" rev-parse --abbrev-ref HEAD)-ceq'HEAD'-and@(& git -C "$pkgTarget/ORVION-Workbench-trusted-main" for-each-ref).Count-eq0)
           Assert-That 'journal and sessions come from GitHub\ORVION-Owner-Tools, not the running checkout' ([IO.File]::ReadAllText("$pkgTarget/ORVION-Owner-Tools/events/events.jsonl")-ceq[Text.Encoding]::UTF8.GetString($journalBytes)-and[IO.File]::ReadAllText("$pkgTarget/ORVION-Owner-Tools/sessions/raw/s.jsonl")-ceq'fixture session')
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

   The resulting file's Git blob is 94fb9892c329026fd6dcd4add3ed271c70a6f2c1.

4. Check whether `docs/RECOVERY.md` contains `# Workbench recovery: before and after reinstalling Windows`; if so record Already Applied when its Git blob is a24c085c9456ec73ac261c14facd87fe15ccfb8f, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (selective unencrypted recovery package, C1 restore, agent orientation and the amended Batch 6 gate only), and change nothing else:

   ```text
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
   | GitHub\ORVION-Owner-Tools: sessions archive, events journal, work | Clean nested clones (each keeps `.clone-state\state.json`: origin, HEAD, refs) |
   | Documents\ORVION-Owner-Review, -Owner-Tools, -Owner-Recovery, -Sandbox, -drafts-backup, Windows-Memory-Config | node_modules (reinstalled from lockfiles) |
   | Per nested clone: its ignored files in place, `.clone-state\unique.bundle` (HEAD and every tip the main bundles lack), `staged.diff`, `worktree.diff`, `untracked\` | Claude/Codex program files, plugins, other projects' transcripts |
   | Claude settings, statusline and ORVION project memory; declared recovery inputs (owner approvals, sealed proofs) | Everything outside the folders listed on the left |

   The package refuses (no archive) rather than lose state a bundle cannot carry: uncommitted work, more than one stash or
   a linked worktree in a main repository, or files under ORVION-Owner-Tools\work\sandboxes. Commit or remove them first.

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
      (evidence paths exceed 260 characters). Optional scoop tools used by product checks: actionlint (pinned by the
      repositories), gitleaks, supabase, trivy.
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
      then Pulse with `-Root` ORVION-Owner-Tools. Restart the session archiver (`lib\Sync-Sessions.ps1`) as before.
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
   ```

   The resulting file's Git blob is a24c085c9456ec73ac261c14facd87fe15ccfb8f.

5. Check whether `HANDOFF.md` contains `Amended 2026-10-26 under the owner's exceptional delegation`; if so record Already Applied when its Git blob is 4957b2bb1f1b84f12c7ca596ec40e884853f6835, and otherwise stop and report. Otherwise make exactly these 4 edits (selective unencrypted recovery package, C1 restore, agent orientation and the amended Batch 6 gate only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   3. **Shared Evidence + Independent Native Finish optimization** — only if earned; owner to earn or waive.
   4. **Contract C** — final recovery proof (clean Windows machine or Windows Sandbox; needs BitLocker) + written
      programme closure criteria (none exist yet). Not drafted.
   ```
   with
   ```text
   3. **Shared Evidence + Independent Native Finish optimization** — not earned; waived by the owner as a closure
      prerequisite on 2026-10-26 (a future CR may still earn it).
   4. **Contract C** — split on 2026-10-26 (§12): C1 written closure criteria + selective package + same-machine
      isolated restore (WS-015); C2 clean-Windows recovery, performed by the owner's planned reinstallation
      (`docs/RECOVERY.md`).
   ```

   b) replace the lines
   ```text
     noted in README), `sessions\INDEX.md`, kept by `Sync-Sessions.ps1`. **Backup**: `Backup-Workspace.ps1` (needs an
     encrypted drive). Recover the latest verified state: Pulse -> its `in flight` line -> that task's RESUME.md.
   ```
   with
   ```text
     noted in README), `sessions\INDEX.md`, kept by `Sync-Sessions.ps1`. **Backup**: `Backup-Workspace.ps1 -Package`
     (one selective archive in OneDrive, unencrypted by owner decision; reinstall and restore steps: `docs\RECOVERY.md`).
     Recover the latest verified state: Pulse -> its `in flight` line -> that task's RESUME.md.
   ```

   c) replace the lines
   ```text
     run the host killed; the open decisions: BitLocker on C: and for the backup USB, a private remote for this workspace,
     earn-or-waive Shared Evidence optimization, MCP prune / GitHub MCP, CTRL-19.
   - **ON HOLD**: Batch 6 (both repositories) and the Phase 8 remainder. **OPEN**: CTRL-19 (both `gh` tokens are reachable
     by this OS user; `main` protection depends on GitHub configuration the repositories cannot set).
   ```
   with
   ```text
     run the host killed; what to do with secret-scan findings in the recovery package (`docs\RECOVERY.md`); the open
     decisions: BitLocker on C:,
     MCP prune / GitHub MCP. Decided 2026-10-26: Shared Evidence waived as a closure prerequisite; CTRL-19 dispositioned
     OPEN with its residual risk accepted (below).
   - **ON HOLD**: Batch 6 (both repositories) and the Phase 8 remainder, until the §12 lift record. **OPEN**: CTRL-19 (both
     `gh` tokens are reachable by this OS user; `main` protection depends on GitHub configuration the repositories cannot
     set); residual risk accepted by the owner, not closed.
   ```

   d) replace the lines
   ```text
   Contracts A, B and C each RELEASED (published, promoted, `REMOTE_CERTIFY: READY` in both repositories); a cold-start
   agent in each repository reaches the right next action from its README/Boot alone (no workspace needed); recovery
   proven on a clean machine from an encrypted backup; written closure criteria (contract C) met and recorded; Shared
   Evidence earned or waived by the owner; CTRL-19 dispositioned by the owner. Then the owner lifts the Batch 6 hold.
   ```
   with
   ```text
   Amended 2026-10-26 under the owner's exceptional delegation (its text and SHA-256 are recorded in WS-015). These are the
   written closure criteria (contract C1); each needs recorded evidence, none is inferred:
   1. Contracts A and B RELEASED in both repositories (published, promoted, `REMOTE_CERTIFY: READY`). Done before WS-015.
   2. C1: WS-015 released (`Backup-Workspace -Package`/`Restore-Workspace -Package`), one real package made and its
      OneDrive copy verified by a cloud re-download, and its same-machine isolated restore into new empty roots verified (SHA256SUMS, exact refs/HEAD, and each restored
      repository's Boot printing its expected READY result). C1 is not a clean-machine proof. The package is NOT
      encrypted: the owner decided on 2026-10-26 that an unencrypted compressed archive in OneDrive replaces the earlier
      "encrypted backup" condition; secrets are reported by name (rule, file, line) by the package's scan, never claimed absent.
   3. Founder ADR-0033 amended through a native Founder CR and released, so Founder's Boot routes to Batch 6 like Platinum's;
      a cold-start agent in each repository reaches that next action from its README/Boot alone.
   4. Shared Evidence: waived as a closure prerequisite (not earned). CTRL-19: OPEN, residual risk accepted by the owner.
      Workbench Stages 2-7 / P3 management are not Batch 6 prerequisites.
   5. C2: the owner's planned Windows reinstallation is the clean-machine recovery proof; it is performed by
      `docs/RECOVERY.md` and is UNPROVEN until its restore and Boots succeed there.
   The hold is lifted by one recorded lift decision that cites the evidence of 1-5; each product's Boot then owns Batch 6.
   ```

   The resulting file's Git blob is 4957b2bb1f1b84f12c7ca596ec40e884853f6835.

6. Check whether `docs/EXECUTION-PLAN.md` contains `2026-10-26 / v1.9:`; if so record Already Applied when its Git blob is 08c9311db673cfe07b4876d22d68379ba073240e, and otherwise stop and report. Otherwise make exactly these 12 edits (selective unencrypted recovery package, C1 restore, agent orientation and the amended Batch 6 gate only), each matched once, and change nothing else:

   a) replace the line
   ```text
   Version 1.8 | 2026-10-25 | Revised successor; status/evidence dated at Draft freeze, native live state owns execution
   ```
   with
   ```text
   Version 1.9 | 2026-10-26 | Batch 6 gate is HANDOFF §12 (amended); status/evidence dated at Draft freeze, native live state owns execution
   ```

   b) replace the lines
   ```text
   - PLANNED / PENDING: Reliable sanitized knowledge preservation/synchronization, remaining P3 single/dual native management, on-demand interactive discovery, managed storage/factory and encrypted offsite clean-Windows recovery, then unchanged Stage7 closure. The ordered stage/dependency map below owns programme direction; RESUME owns the active contract and the existing checkpoint owns live operation handles/progress.
   - BLOCKED / DEFERRED: Effective main protection/bootstrap/provider behavior and exact main authorization; original plan/Recovery Gate1; complete stable private recovery inventory, encrypted destination/quota and independent key/MFA custody, actual cloud recovery; general management/navigation/storage remain unimplemented. No automatic cloud publishing, migration, purge or trust advancement.
   - PRESERVE: Frozen WS012 and rejected WS013 evidence, original Stage0-7/P3 G2c A-H/G3/G4, architecture1.5, CAG/SACI/PICF/CRGL, V1/V2/V3, sandbox-first, independent native authorities and all required certification dependencies. CTRL-19 OPEN; Batch6/Phase8 HOLD until explicit owner lift after closure.
   ```
   with
   ```text
   - PLANNED / PENDING: Reliable sanitized knowledge preservation/synchronization, remaining P3 single/dual native management, on-demand interactive discovery, managed storage/factory and offsite clean-Windows recovery (package unencrypted by owner decision 2026-10-26), then unchanged Stage7 closure. The ordered stage/dependency map below owns programme direction; RESUME owns the active contract and the existing checkpoint owns live operation handles/progress.
   - BLOCKED / DEFERRED: Effective main protection/bootstrap/provider behavior and exact main authorization; original plan/Recovery Gate1; complete stable private recovery inventory, cloud destination/quota and MFA custody (no encryption key: owner decision 2026-10-26), actual cloud recovery; general management/navigation/storage remain unimplemented. No automatic cloud publishing, migration, purge or trust advancement.
   - PRESERVE: Frozen WS012 and rejected WS013 evidence, original Stage0-7/P3 G2c A-H/G3/G4, architecture1.5, CAG/SACI/PICF/CRGL, V1/V2/V3, sandbox-first, independent native authorities and all required certification dependencies. CTRL-19 OPEN; Batch6/Phase8 HOLD until the recorded lift decision required by HANDOFF §12 (amended 2026-10-26).
   ```

   c) replace the line
   ```text
   | Programme proof limits | No complete stable encrypted offsite archive, independently recoverable keys or clean-Windows restoration proved. Remaining P3/general management, interactive navigation and Stage5 cutover/factory remain PLANNED, despite foundational contracts. |
   ```
   with
   ```text
   | Programme proof limits | No complete stable offsite archive or clean-Windows restoration proved. Remaining P3/general management, interactive navigation and Stage5 cutover/factory remain PLANNED, despite foundational contracts. |
   ```

   d) replace the lines
   ```text
   7. **Stage6 recovery:** corrected existing Backup/Restore coverage, complete reviewed inventory and stable snapshot; owner encrypted destination/quota/key/MFA decisions; authorized real ciphertext upload/download/decrypt and clean supported Windows restore, all three cold starts plus independent trusted boundary and actual GitHub enforcement. Synthetic restore and Git clone are insufficient.
   8. **Stage7 closure / eventual Batch6:** reconcile all original P3/P4/Contract C/ADR0033/master gaps and A/B/C native releases; future-agent continuity, written closure, Shared Evidence earned or owner-waived, CTRL19 owner disposition; then explicit owner hold lift before Batch6/Phase8 native product scopes. No new independent programme, artificial completion checklist or automatic hold lift.
   ```
   with
   ```text
   7. **Stage6 recovery:** corrected existing Backup/Restore coverage, complete reviewed inventory and stable snapshot; owner destination/quota/MFA decisions (unencrypted package by owner decision 2026-10-26); authorized real upload/download/extract and clean supported Windows restore, all three cold starts plus independent trusted boundary and actual GitHub enforcement. Synthetic restore and Git clone are insufficient.
   8. **Stage7 closure:** reconcile all original P3/P4/master gaps. Since 2026-10-26 it is not a Batch 6 prerequisite: the Batch 6 gate is HANDOFF §12 as amended (A/B released, C1 by WS-015, Founder ADR-0033 routing, Shared Evidence waived, CTRL-19 OPEN with accepted risk, C2 at the owner's Windows reinstallation, then one recorded lift). Stages 2-7 continue only when a product task earns them. No automatic hold lift.
   ```

   e) replace the line
   ```text
   5. Account for every declared source: included, intentionally excluded with reason, or unreadable. Protect raw sessions/secrets from tracked catalogs; preserve masking, selective access and encrypted recovery. Gitignore alone does not protect tracked content.
   ```
   with
   ```text
   5. Account for every declared source: included, intentionally excluded with reason, or unreadable. Protect raw sessions/secrets from tracked catalogs; preserve masking, selective access and protected recovery (the package is unencrypted by owner decision 2026-10-26; its secret scan names findings). Gitignore alone does not protect tracked content.
   ```

   f) replace the line
   ```text
   Existing sandbox factory/setup tools must supply versioned reproducible build instructions, pinned inputs/tool versions, root/role bindings, disabled-push independent clone rules, non-secret workstation prerequisites, cleanup boundaries and a clean-machine way to rebuild disposable environments. Keep secrets and machine-specific credential custody outside public source. Retention and migration keep the original staged approvals/adversarial cases; no new source collector, archive relocation or background sync service. Important uniquely required ignored state needs reviewed encrypted recovery coverage, not an assumption that Gitignore or cloud source solves it.
   ```
   with
   ```text
   Existing sandbox factory/setup tools must supply versioned reproducible build instructions, pinned inputs/tool versions, root/role bindings, disabled-push independent clone rules, non-secret workstation prerequisites, cleanup boundaries and a clean-machine way to rebuild disposable environments. Keep secrets and machine-specific credential custody outside public source. Retention and migration keep the original staged approvals/adversarial cases; no new source collector, archive relocation or background sync service. Important uniquely required ignored state needs reviewed recovery coverage, not an assumption that Gitignore or cloud source solves it.
   ```

   g) replace the line
   ```text
   Stage 6 follows existing P4/Contract C. Doctor precedes an approved Prepare action; verify required actual capabilities/setup idempotence. Reuse Backup-Workspace/Restore-Workspace and extend only newly owned state. Prove encrypted backup to clean supported machine/Windows Sandbox, restored identities/refs/config/receipts/paths, and correct independent native/Workbench cold starts. Simulated restore is not clean-Windows proof. Credentials remain external and use their owning authentication routes; do not improvise encryption/system changes or overwrite a restore target.
   ```
   with
   ```text
   Stage 6 follows existing P4/Contract C. Doctor precedes an approved Prepare action; verify required actual capabilities/setup idempotence. Reuse Backup-Workspace/Restore-Workspace and extend only newly owned state. Prove the backup (unencrypted by owner decision 2026-10-26) to clean supported machine/Windows Sandbox, restored identities/refs/config/receipts/paths, and correct independent native/Workbench cold starts. Simulated restore is not clean-Windows proof. Credentials remain external and use their owning authentication routes; do not improvise encryption/system changes or overwrite a restore target.
   ```

   h) replace the line
   ```text
   Stage 6 additionally depends on the Stage 3 Workbench security capability: recover the independent ORVION-Workbench-trusted-main checkout from the same authorized repository with its selected previously trusted commit, independent Git/common/object store, accepted evaluator/helper identities and owner-controlled release role. Prove cold-start trusted judgment against exact candidate inputs, restored refs/non-secret configuration and preserved local/hosted/trusted/remote evidence, then freshly revalidate actual GitHub rules, check identity, entitlement and bypass applicability. A backup of local configuration cannot restore GitHub enforcement; source recovery cannot grant credentials or settings authority. Lost trust/receipts or unavailable protection blocks the affected release/parity claim without invalidating preserved completed evidence. Retain all existing encrypted clean-Windows/Contract C conditions.
   ```
   with
   ```text
   Stage 6 additionally depends on the Stage 3 Workbench security capability: recover the independent ORVION-Workbench-trusted-main checkout from the same authorized repository with its selected previously trusted commit, independent Git/common/object store, accepted evaluator/helper identities and owner-controlled release role. Prove cold-start trusted judgment against exact candidate inputs, restored refs/non-secret configuration and preserved local/hosted/trusted/remote evidence, then freshly revalidate actual GitHub rules, check identity, entitlement and bypass applicability. A backup of local configuration cannot restore GitHub enforcement; source recovery cannot grant credentials or settings authority. Lost trust/receipts or unavailable protection blocks the affected release/parity claim without invalidating preserved completed evidence. Retain all existing clean-Windows/Contract C conditions (their encryption requirement is replaced by owner decision 2026-10-26).
   ```

   i) replace the line
   ```text
   Stage6 addition: a backup that reports success while omitting required proof is unacceptable. Require present nonempty structurally valid proof-input arrays and receipt-file arrays, valid nonempty positive controls, permanent missing/null/empty/scalar/object/invalid-entry negatives and no success manifest/restore writes on refusal. The corrected WS013R2 owns fresh V1/V2/V3 and its completed isolated native Finish/live Review; original certification remains separately gated; the rejected Draft's passing Finish cannot certify it. Inventory stable actual source/trusted/authority/evidence/meaningful knowledge/private archives and retained unique certificates explicitly; distinguish selected scope from complete coverage. Real encrypted offsite recoverability needs observed upload/download ciphertext identity, separately recoverable keys/MFA, decryption, exact refs/config/receipts/provenance/navigation and fresh clean-Windows cold starts. Cloud quota, a mounted destination, local round trip or readable GitHub source alone proves none of these.
   ```
   with
   ```text
   Stage6 addition: a backup that reports success while omitting required proof is unacceptable. Require present nonempty structurally valid proof-input arrays and receipt-file arrays, valid nonempty positive controls, permanent missing/null/empty/scalar/object/invalid-entry negatives and no success manifest/restore writes on refusal. The corrected WS013R2 owns fresh V1/V2/V3 and its completed isolated native Finish/live Review; original certification remains separately gated; the rejected Draft's passing Finish cannot certify it. Inventory stable actual source/trusted/authority/evidence/meaningful knowledge/private archives and retained unique certificates explicitly; distinguish selected scope from complete coverage. Real offsite recoverability needs observed upload/download archive identity (unencrypted by owner decision 2026-10-26), recoverable MFA, extraction, exact refs/config/receipts/provenance/navigation and fresh clean-Windows cold starts. Cloud quota, a mounted destination, local round trip or readable GitHub source alone proves none of these.
   ```

   j) replace the line
   ```text
   Stage 7 reconciles ADR-0033 and Workbench HANDOFF section 12: A/B/C released with native certificates in both products; clean-machine encrypted recovery; written C closure; independent README/Boot continuity; Shared Evidence earned or owner-waived; CTRL-19 owner disposition. Do not replace these conditions with a reduced checklist.
   ```
   with
   ```text
   Stage 7 reconciles ADR-0033 and Workbench HANDOFF section 12: A/B/C released with native certificates in both products; clean-machine recovery; written C closure; independent README/Boot continuity; Shared Evidence earned or owner-waived; CTRL-19 owner disposition. Do not replace these conditions with a reduced checklist.
   ```

   k) replace the line
   ```text
   Only after applicable conditions are proven AND the owner lifts the hold may Batch 6/Phase 8 start under their own native scopes. Neither this plan nor WS005 lifts that hold. General N-repository support, GUI, generalized learning/search systems, automated purge and speculative speed tuning remain later work with explicit triggers; required independence, supported dual operation, authority and recovery are not deferred.
   ```
   with
   ```text
   Only after the HANDOFF §12 conditions are proven AND the recorded lift decision exists may Batch 6/Phase 8 start under their own native scopes. Neither this plan nor WS005 lifts that hold. General N-repository support, GUI, generalized learning/search systems, automated purge and speculative speed tuning remain later work with explicit triggers; required independence, supported dual operation, authority and recovery are not deferred.
   ```

   l) immediately after the lines
   ```text
   - 2026-10-24 / v1.6: integrate the owner-required Workbench GitHub security parity/trusted-main acceptance in Stage 3 and Per-change assurance, with Stage 6 recovery dependencies. Proposed independent checkout only; no hosted capability, settings, publication or original implementation is claimed or authorized. Preserve all earlier stages, P3 acceptance and directory/tool roles.

   ```
   insert
   ```text
   - 2026-10-26 / v1.9: under the owner's exceptional delegation and reinstall directive, decoupled Batch 6 from Stage 7 and P3 management; HANDOFF §12 owns the gate. Stage 6 recovery is to be delivered as WS-015's selective package with C1 same-machine restore; the package is unencrypted by owner decision (2026-10-26), which replaces the encrypted destination/key conditions of Stages 6-7 for it, with a redacted secret-scan report instead; clean-Windows recovery (C2) is the owner's planned reinstallation via docs/RECOVERY.md. No stage, P3 obligation or frozen evidence was deleted.

   ```

   The resulting file's Git blob is 08c9311db673cfe07b4876d22d68379ba073240e.

7. Check whether `RESUME.md` contains `Reinstalling Windows or recovering this workstation`; if so record Already Applied when its Git blob is 510b64cde6bb9f72ded50f871c65381d20645d45, and otherwise stop and report. Otherwise make exactly this one edit (selective unencrypted recovery package, C1 restore, agent orientation and the amended Batch 6 gate only), each matched once, and change nothing else:

   a) replace the line
   ```text
      Publish and promote are the owner's (`CR_LIFECYCLE.md` §9). Batch 6 is ON HOLD; CTRL-19 is OPEN.
   ```
   with
   ```text
      Publish and promote are the owner's (`CR_LIFECYCLE.md` §9). Batch 6 is ON HOLD until the lift record that HANDOFF.md §12 requires; CTRL-19 is OPEN.
      Reinstalling Windows or recovering this workstation: [`docs/RECOVERY.md`](docs/RECOVERY.md) (one unencrypted package in OneDrive, exact steps).
   ```

   The resulting file's Git blob is 510b64cde6bb9f72ded50f871c65381d20645d45.

8. Check whether `README.md` contains `## Agent orientation (start here after a reinstall or a new session)`; if so record Already Applied when its Git blob is 94aa429d03308e739ccee2aad3f14a850fa62bc4, and otherwise stop and report. Otherwise make exactly these 5 edits (selective unencrypted recovery package, C1 restore, agent orientation and the amended Batch 6 gate only), each matched once, and change nothing else:

   a) replace the line
   ```text
   Private source repository: https://github.com/Shehabhub/ORVION-Workbench . Current selected checkout: `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench`, an actual Git root. Local `.githooks` must be configured; cloning alone does not install hooks or recover journals/receipts. Existing native repositories remain independent siblings. Managed sandbox/test/temp/runtime stay outside this checkout under the accepted context.
   ```
   with
   ```text
   Source repository: https://github.com/Shehabhub/ORVION-Workbench (PUBLIC, measured 2026-10-26: never commit owner records, sessions, approvals or anything secret). Current selected checkout: `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench`, an actual Git root. Local `.githooks` must be configured; cloning alone does not install hooks or recover journals/receipts. Existing native repositories remain independent siblings. Managed sandbox/test/temp/runtime stay outside this checkout under the accepted context.
   ```

   b) immediately after the lines
   ```text
   **For Workbench's own changes:** run `pwsh -NoProfile -File lib/Workbench.ps1 -Boot` from this root and follow [WORKFLOW.md](WORKFLOW.md). This initial local kernel supplies own admission/Finish/Review; full product supervision and workstation recovery remain separately governed. A product-only entry continues to use that product's own tools.

   ```
   insert
   ```text
   ## Agent orientation (start here after a reinstall or a new session)

   You may be a new Claude Code or Codex session with no memory of earlier work. Everything you need is in these files,
   the event journal and the session archive; do not ask the owner to re-explain the project.

   1. Where things stand: `RESUME.md` (active contract pointer, Pulse command, boundaries), then `HANDOFF.md` once.
   2. Who decides: each repository's own README, AGENTS.md and Boot. Platinum = `..\CRM`, Founder = `..\ORVION`, this
      repository = its own changes only (`lib/Workbench.ps1 -Boot`, `WORKFLOW.md`). Gate 1, publish and promote are the
      owner's unless a recorded owner delegation says otherwise; a delegated decision is labelled delegated.
   3. Learn before acting (enforced: own Finish runs `Events -Find` and `Hunt -Quick` itself; do the same by hand first).
      The ONE journal and session archive live in `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools`: pass it as
      `-Root` (below: `<data>`), or the tools read and write an empty store inside this checkout.
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

   ```

   c) replace the line
   ```text
   | `sessions\raw\` | every ORVION agent session, verbatim (Claude Code + Codex) | never | yes, encrypted | **yes** |
   ```
   with
   ```text
   | `sessions\raw\` | every ORVION agent session, verbatim (Claude Code + Codex) | never | yes (package, unencrypted by owner decision) | **yes** |
   ```

   d) replace the lines
   ```text
     published defaults or code. The raw history stays verbatim (integrity); protection is: never in Git, encrypted
     backup only, BitLocker on C: (owner action).
   ```
   with
   ```text
     published defaults or code. The raw history stays verbatim (integrity); protection is: never in Git, and the
     recovery package reports secret findings by name (`docs/RECOVERY.md`); BitLocker on C: stays an owner action.
   ```

   e) immediately after the line
   ```text
   ## Backup to USB, and recovery
   ```
   insert
   ```text
   Reinstalling Windows: use [docs/RECOVERY.md](docs/RECOVERY.md) (one selective package in OneDrive). The USB folder
   backup below remains available:
   ```

   The resulting file's Git blob is 94aa429d03308e739ccee2aad3f14a850fa62bc4.

9. Check whether `lib/README.md` contains `Selective package v1:`; if so record Already Applied when its Git blob is 4240cf5c6e41365c6b0a22542836b58731150504, and otherwise stop and report. Otherwise make exactly this one edit (selective unencrypted recovery package, C1 restore, agent orientation and the amended Batch 6 gate only), each matched once, and change nothing else:

   a) replace the line
   ```text
   | `Backup-Workspace.ps1 -Destination <usb>` / `Restore-Workspace.ps1 -From <backup>` | everything a clone cannot restore; encrypted drive required; restore never overwrites |
   ```
   with
   ```text
   | `Backup-Workspace.ps1 -Destination <usb>` / `Restore-Workspace.ps1 -From <backup>` | everything a clone cannot restore; encrypted drive required; restore never overwrites. Selective package v1: `-Package` (both) makes or restores one unencrypted 7z with a redacted secret-scan report instead (`..\docs\RECOVERY.md`) |
   ```

   The resulting file's Git blob is 4240cf5c6e41365c6b0a22542836b58731150504.

## Acceptance Criteria

- [x] Exact approved scoped output. check: blob:lib/Backup-Workspace.ps1=168d936f208dd2e4fc13f1b7ccf300642206a847
- [x] Exact approved scoped output. check: blob:lib/Restore-Workspace.ps1=3806c46d24eff5b3b5cb5f728de098ecac6c4db4
- [x] Exact approved scoped output. check: blob:lib/test-backup-restore.ps1=94fb9892c329026fd6dcd4add3ed271c70a6f2c1
- [x] Exact approved scoped output. check: blob:docs/RECOVERY.md=a24c085c9456ec73ac261c14facd87fe15ccfb8f
- [x] Exact approved scoped output. check: blob:HANDOFF.md=4957b2bb1f1b84f12c7ca596ec40e884853f6835
- [x] Exact approved scoped output. check: blob:docs/EXECUTION-PLAN.md=08c9311db673cfe07b4876d22d68379ba073240e
- [x] Exact approved scoped output. check: blob:README.md=94aa429d03308e739ccee2aad3f14a850fa62bc4
- [x] Exact approved scoped output. check: blob:lib/README.md=4240cf5c6e41365c6b0a22542836b58731150504
- [x] RESUME routing carries the amended Batch 6 boundary and recovery pointer. check: normalized-resume:RESUME.md=A3753B0B89D4926D8E2C1929296C9C3F06C471F60A10DF2921F9C29094313419
- [x] The owning test proves: a package without a product repository refuses before any archive; the destination holds one archive plus its always-written scan report, every archive entry is unencrypted (7z -slt), and staging is removed after backup and restore; the secret scan names a planted token by rule and path and its value appears in neither the report nor the output (or the report says SKIPPED without gitleaks); git stderr (CRLF) warnings are not counted as unmerged or dirty entries; a damaged archive refuses before any restore target; exactly one restore source is required; journal and sessions come from GitHub\ORVION-Owner-Tools when run from a production-shaped checkout and their absence refuses; a ref-less detached trusted clone round trips; a nested clone keeps its ignored files (receipt and other evidence) in place, staged and worktree changes in separate diffs, its untracked file and a unique.bundle that restores its unique branch commit on top of a main repository and its unique detached-HEAD commit, while node_modules (also inside a nested clone) is excluded; a broken .git folder is copied as data; a package refuses uncommitted main-repository work. All earlier owning cases keep their semantics.
- [x] Mandatory V1/V2/V3, focused proof, planted-regression mutants, accepted literal replay controls and the real-workspace measurement are preserved. One isolated native timed/watched Finish owns the full schedule with a fresh SANDBOX receipt before original approval; the original needs its own fresh Finish, live Review, native Complete and an independent carrying-range READY.
- [x] HANDOFF §12, EXECUTION-PLAN and RESUME state the amended gate truthfully: C1 is not a clean-machine proof, C2 is UNPROVEN until the post-reinstall restore, the package is unencrypted by recorded owner decision (never claimed to meet the earlier encrypted condition), Shared Evidence is waived not earned, CTRL-19 stays OPEN, and the hold lifts only by a recorded decision citing that evidence. docs/RECOVERY.md names what is not packaged and what is not yet proven.

## Review Gate

- [x] Inspect the nine scoped files, the focused/mutant/literal evidence and the real measurement; preserve all frozen prior evidence.
- [x] Independently check the native receipt root/Draft/recipe/evaluator/fingerprint, ordered tests and timed/watcher/host exits; normal native Review/Complete and every new carrying transition must pass. No second-agent or provider certification is claimed.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Exceptional owner delegation of 2026-10-26 (C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\OWNER-DELEGATION.md) plus the owner's reinstall directive (OWNER-DIRECTIVE-REINSTALL.md) and the unencrypted-continuity directive (OWNER-DIRECTIVE-UNENCRYPTED-CONTINUITY.md, decisions D10-D12) authorize this one Workbench contract; decisions are logged in DECISIONS.md. Gate 1 for this Draft is DELEGATED: the owner did not type its digest. Sandbox approval is synthetic and grants no original authority.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws015-package\assurance\V3\DRAFT.md
Approved SHA256: 6CACEC8FF77A09DFAD6B398898918B2ABAE0B40CF4171A76B03C49CBFCF39067
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\GATE1-WS015-DELEGATED.md
Owner Evidence SHA256: ABC276BE2EDA78765C9FFCA2677966CFC662482BCEE90DF1618EAC489BEB526D
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws015-package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 31D2C3F825076B41019128F5D36993947323E941AAD786A5F5EE5C98DCAEF6DE
Original admission: DELEGATED exact Gate 1 under the owner's exceptional delegation of 2026-10-26 (OWNER-DELEGATION.md SHA-256 94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217; decisions D1-D13). The owner did not type this digest. Bound to this literal root, the exact V3 digest and the fresh sandbox receipt; no sandbox receipt transplant as original certification.
Original exact literal implementation applied by accepted native Workbench Execute. Declared filtered blobs match. Fresh root-bound original Finish and independent live Review remain required; sandbox success does not certify this root. Additional owner knowledge/automatic-freshness/physical-layout refinements remain requirements for an eligible successor scope; this frozen Draft was not expanded.

## Verification Notes

Measured before freeze: nested clones 900 (unique commits in 732, all bundled in 16 MB; diffs 3.3 MB; untracked 2.3 MB); the current WS-013 backup cannot run on this workstation (ref-less detached trusted clone gives a null refs list) and copies the running checkout instead of GitHub\ORVION-Owner-Tools; git cannot write bundle/diff files beyond MAX_PATH in deep staging, so they are written short and moved by .NET. The first, encrypted prototype was measured on real data (193.7 MB, 26.8 min) and its key handling found a $key shadowing defect; the owner then chose no encryption (D10/D11), so the key code was removed and gitleaks 8.30.1 (--redact) reports findings as rule and relative path only (it prints forward-slash paths, handled). Planted regressions for the data root, staging removal, unique bundles and ref-less refs are each detected. Independent advisory review by Codex (gpt-6.1-sol, effort high; codex-review\review1-*) raised 10 concerns plus one HANDOFF wording point; all were accepted and fixed with cases (review1-disposition.md); a second Codex pass checked the fixes. Codex agreement is advisory, never certification.
Verdict: Confirmed Complete
Reviewed Fingerprint: 84FE3C6DC49DEAEABF31D326FBC4298E3BF758FDCB229A5A06B9A2ACE4026884
Reviewed Receipt: DDDF0BC061F3067E2313057E8D272B5C6DF42C9C4A94CEAFF8AC387EA5D4C45F
Evidence: fresh ORIGINAL root-bound timed/watched Finish, actual21-suite schedule/exits, approved exact outputs and independently pinned accepted-code live review. Runtime: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws015-package\runtime\original. No sandbox receipt transplant, remote parity, offsite recovery or equal-OS isolation claim.

## Selection reasons and sources

Evidence Refresh: focused-selected.log PASS on the selected bytes, four planted regressions detected, real-workspace package measurement completed on the selected Backup bytes (real-measurement.json; archive deleted after measuring, scan findings by rule and path only), literal replay controls run before the one sandbox Finish. Baseline ca081c3 (main = preflight), accepted judge 835E14DA unchanged.

Sources: OWNER-DELEGATION.md, OWNER-DIRECTIVE-REINSTALL.md, DECISIONS.md, accepted WORKFLOW/TEMPLATE/checker, WS-013 contract and recovery-r2 scripts, Founder SPEC-297 delegated Gate 1 precedent, 7-Zip and gitleaks 8.30.1 behaviour observed locally, clone-scan.csv and the unique-probe measurements.
