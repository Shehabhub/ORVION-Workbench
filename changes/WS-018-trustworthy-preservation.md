# Workbench Change Request - WS-018

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Make preservation trustworthy before the Windows reinstall: Sync-Sessions proves the whole archived prefix before appending and ends nonzero (3) with a visible line when any file failed; Restore refuses an empty, partial or path-escaping SHA256SUMS before it writes anything; Backup applies one safe config rule to every repository (userinfo stripped, gh-calling helpers kept, helpers accepted only by an exact whole-value grammar, literal secrets in any kept value and auth headers refused by key name only, clone metadata not stored). Also make the owning checks hermetic: no self-check outcome depends on the user's global or system git config, profile or locale, and journal/due timestamps are written in the invariant Gregorian calendar.

## Baseline

6b5549dd51973f9b9c6c8c5bc16e8a9909e496a2

## Write Scope

- RESUME.md
- lib/Sync-Sessions.ps1
- lib/Restore-Workspace.ps1
- lib/Backup-Workspace.ps1
- lib/test-sync-sessions-rewrite.ps1
- lib/test-sync-sessions-survival.ps1
- lib/test-backup-restore.ps1
- lib/Events.ps1
- lib/Delegate.ps1
- lib/test-coordinator.ps1
- lib/test-events.ps1
- lib/test-owner-dual.ps1
- lib/test-draft-steps.ps1
- lib/test-map-repos.ps1
- lib/test-native-stage.ps1
- lib/test-pulse.ps1
- lib/test-spider.ps1
- lib/test-hunt.ps1
- lib/README.md

## Out of Scope

All other engineering paths except native allocation/status/pointer bookkeeping. No checker (Test-WorkbenchChange.ps1), applier, workflow, hook, GitHub setting or product repository change; the ORVION-Owner-Tools copy of lib and the user hook settings are not changed. Deferred and recorded: Hunt mixed source/data root and baseline, Delegate verdict closure, Events duplicate fields and brief categories, Watch-Subagents stale evidence, apply-draft-steps marker refusal, Finish watcher binding, Test-ScriptHazards foreach targets and scopes, observer timeouts. CTRL-19 stays OPEN; Batch 6/Phase 8 stay ON HOLD; C2 stays UNPROVEN.

## Draft Assurance

V1: WS018-PRESERVATION-DESIGN | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws018-package\assurance\V1\DRAFT.md | EA954ED851EA8058CA3D6DB561ACF4FAB23364DA31740F8B1557F30472ABE76C
V2: WS018-PRESERVATION-ADVERSARIAL | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws018-package\assurance\V2\DRAFT.md | 4014D41DE3855C23DDC8FA48844E037BF0B584C023BD5C758EA530B2CD9A159D
V3: WS018-PRESERVATION-REFRESH | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws018-package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSpres18
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSpres18\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSpres18\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws018-package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/Sync-Sessions.ps1` contains `preservation FAILED`; if so record Already Applied when its Git blob is 7efe44b2ffcdec6895a69b850e8689874064e63a, and otherwise stop and report. Otherwise make exactly these 10 edits (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) replace the line
   ```text
   # bytes are proven to match the source at both their head and their tail; any other file is compared whole. A source
   ```
   with
   ```text
   # bytes are proven to match the whole source prefix; any other file is compared whole. A source
   ```

   b) replace the line
   ```text
   # it never stops the others (Hunt.ps1 reports the log).
   ```
   with
   ```text
   # it never stops the others (Hunt.ps1 reports the log). Exit 3: any preservation/index failure, including earlier follow passes.
   ```

   c) replace the line
   ```text
   function Test-Prefix([IO.Stream]$Source,[string]$Dst,[long]$Len){  # the archived bytes still match the source at their head and their tail
   ```
   with
   ```text
   function Test-Prefix([IO.Stream]$Source,[string]$Dst,[long]$Len){
   ```

   d) replace the lines
   ```text
       try{foreach($at in @(0,[Math]::Max(0,$Len-4096))|Select-Object -Unique){
           $n=[int][Math]::Min(4096,$Len-$at);$a=New-Object byte[] $n;$b=New-Object byte[] $n
           $d.Position=$at;$got=0;while($got-lt$n){$r=$d.Read($a,$got,$n-$got);if(!$r){return $false};$got+=$r}
           $Source.Position=$at;$got=0;while($got-lt$n){$r=$Source.Read($b,$got,$n-$got);if(!$r){return $false};$got+=$r}
   ```
   with
   ```text
       try{$Source.Position=0;$left=$Len
           while($left-gt0){
           $n=[int][Math]::Min(1MB,$left);$a=New-Object byte[] $n;$b=New-Object byte[] $n
           $got=0;while($got-lt$n){$r=$d.Read($a,$got,$n-$got);if(!$r){return $false};$got+=$r}
           $got=0;while($got-lt$n){$r=$Source.Read($b,$got,$n-$got);if(!$r){return $false};$got+=$r}
   ```

   e) immediately after the line
   ```text
           if(![Linq.Enumerable]::SequenceEqual($a,$b)){return $false}
   ```
   insert
   ```text
           $left-=$n
   ```

   f) replace the line
   ```text
           if($lines){  # a transcript grows: same history if the archived bytes are still its head and tail
   ```
   with
   ```text
           if($lines){  # a transcript grows: same history only if every archived byte still matches
   ```

   g) immediately after the line
   ```text
       $script:failures++
   ```
   insert
   ```text
       [Console]::Error.WriteLine("SESSIONS: preservation FAILED; see $errLog")
   ```

   h) replace the line
   ```text
       exit 0
   ```
   with
   ```text
       exit $(if($script:failures){3}else{0})
   ```

   i) replace the line
   ```text
   Invoke-Pass;$rows=Update-Index
   ```
   with
   ```text
   try{Invoke-Pass;$rows=Update-Index}catch{Write-SyncError 'pass' $_}
   ```

   j) immediately after the line
   ```text
   if(!$Quiet){"SESSIONS: $($rows.Count) indexed, $copied files copied, $([math]::Round(($rows|Measure-Object bytes -Sum).Sum/1MB,1)) MB main transcripts, credentials in $(@($rows|Where-Object secretHits).Count) sessions ($(@($rows.secretNames|Where-Object{$_}|Select-Object -Unique)-join', '))$(if($script:failures){"; $($script:failures) file(s) FAILED, see $errLog"}) -> $indexPath"}
   ```
   insert
   ```text
   exit $(if($script:failures){3}else{0})
   ```

   The resulting file's Git blob is 7efe44b2ffcdec6895a69b850e8689874064e63a.

2. Check whether `lib/Restore-Workspace.ps1` contains `BACKUP_MANIFEST_INCOMPLETE`; if so record Already Applied when its Git blob is 2bab89142b0321b4991b0a80628b4afcea53338d, and otherwise stop and report. Otherwise make exactly these 3 edits (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $From=(Resolve-Path $From).Path
   ```
   insert
   ```text
   $listed=@{}
   ```

   b) replace the lines
   ```text
       $h,$rel=$l-split'  ',2;$f=Join-Path $From $rel
       if(!(Test-Path -LiteralPath $f)-or(Get-FileHash -LiteralPath $f).Hash-ne$h){$rel}
   ```
   with
   ```text
       $h,$rel=$l-split'  ',2
       if($h-cnotmatch'^[A-Fa-f0-9]{64}$'-or!$rel-or[IO.Path]::IsPathRooted($rel)-or$rel-match'(^|[\\/])\.\.([\\/]|$)|:'){throw 'BACKUP_MANIFEST_INVALID'}
       $f=[IO.Path]::GetFullPath((Join-Path $From $rel));$listed[$f]=$true
       if(!(Test-Path -LiteralPath $f -PathType Leaf)-or(Get-FileHash -LiteralPath $f).Hash-ne$h){$rel}
   ```

   c) immediately after the line
   ```text
   if($bad.Count){throw "BACKUP_CORRUPT: $($bad.Count) file(s) fail SHA256SUMS, first: $($bad[0])"}
   ```
   insert
   ```text
   if(!$listed.Count-or!$listed.ContainsKey((Join-Path $From 'backup.json'))){throw 'BACKUP_MANIFEST_INCOMPLETE'}
   foreach($f in Get-ChildItem -LiteralPath $From -Recurse -File -Force){
       if($f.FullName-ne(Join-Path $From 'SHA256SUMS.txt')-and!$listed.ContainsKey($f.FullName)){throw 'BACKUP_MANIFEST_INCOMPLETE'}
   }
   ```

   The resulting file's Git blob is 2bab89142b0321b4991b0a80628b4afcea53338d.

3. Check whether `lib/Backup-Workspace.ps1` contains `Get-SafeConfig`; if so record Already Applied when its Git blob is 3f0119853d1fe5ea011a255edb7b9da57a918842, and otherwise stop and report. Otherwise make exactly these 5 edits (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   function Get-SevenZip{$z=(Get-Command 7z -CommandType Application -ErrorAction SilentlyContinue|Select-Object -First 1).Source;if(!$z){$z=Join-Path $env:ProgramFiles '7-Zip\7z.exe'};if(!(Test-Path -LiteralPath $z)){throw 'PACKAGE_7ZIP_REQUIRED'};$z}
   ```
   insert
   ```text
   function Get-SafeConfig([string]$Repo){
       foreach($entry in ((@(Invoke-Git $Repo config --local --null --list)-join"`n")-split"`0"|Where-Object{$_})){
           $key,$value=$entry-split"`n",2
           $safeKey=$key-replace'://[^/\s]*@','://';$safeValue=$value-replace'://[^/\s]*@','://'
           if($key-cne$safeKey-or$value-cne$safeValue){Write-Warning "BACKUP_CONFIG_USERINFO_STRIPPED: $safeKey"}
           $key=$safeKey;$value=$safeValue
           if($key-match'^http\..*(extraheader|cookiefile)$'-or$value-match'[\x00-\x1f]'){throw "BACKUP_UNSAFE_CONFIG: $key"}
           # Clone/init recreates this metadata; neither store it nor warn about its omission.
           if($key-match'^(core\.(repositoryformatversion|filemode|bare|logallrefupdates|symlinks|ignorecase)|remote\.origin\.fetch)$'){continue}
           # Whole helper values only; the owner function must use the same login twice.
           if($key-match'^credential\.(.*\.)?helper$'-and$value-cnotmatch'\A(?:|manager|manager-core|wincred|!gh auth (?:git-credential|token)(?: --hostname [A-Za-z0-9.-]+)?|!f\(\) \{ echo username=([A-Za-z0-9-]{1,39}); echo "password=\$\(gh auth token --user \1\)"; \}; f)\z'){throw "BACKUP_UNSAFE_CONFIG: $key"}
           if($key-match'^(user\.(name|email)|core\.(hookspath|autocrlf)|branch\.[^=]+\.(remote|merge)|remote\.origin\.(url|pushurl)|push\.default|protocol\.[a-z.]+|gc\.auto|maintenance\.auto|credential\.(.*\.)?(helper|username|usehttppath))$'){
               if($value-match'gh[pousr]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}|password=(?!\$\(gh auth token)'){throw "BACKUP_UNSAFE_CONFIG: $key"}
               "$key=$value"
           }
           else{Write-Warning "BACKUP_CONFIG_OMITTED: $key"}
       }
   }
   ```

   b) replace the lines
   ```text
       $localConfig=@(Invoke-Git $r config --local --list)
       if($name-like'ORVION-Workbench*'){
           # Only approved non-secret identity/routing settings. Never retain auth headers or arbitrary helper commands.
           if(@($localConfig|Where-Object{$_-match'^(http\..*(extraheader|cookiefile)|credential\..*|core\.(sshcommand|gitproxy)|include\.)='}).Count){throw 'BACKUP_WORKBENCH_UNSAFE_CONFIG'}
           $localConfig=@($localConfig|Where-Object{$_-match'^(user\.(name|email)|core\.(hookspath|autocrlf)|branch\.[^=]+\.(remote|merge)|remote\.origin\.(url|pushurl)|push\.default|protocol\.[a-z.]+|gc\.auto|maintenance\.auto)='})
           foreach($line in $localConfig){
               $key,$value=$line-split'=',2
               if($value-match'[\x00-\x1f]' -or ($key-like'remote.origin.*'-and$value-ne'DISABLED'-and$value-notmatch'^https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(?:\.git)?$') -or ($key-eq'core.hookspath'-and$value-ne'.githooks')){throw 'BACKUP_WORKBENCH_UNSAFE_CONFIG'}
           }
       }
   ```
   with
   ```text
       $localConfig=@(Get-SafeConfig $r)
       if($name-like'ORVION-Workbench*'){foreach($line in $localConfig){
           $key,$value=$line-split'=',2
           if(($key-like'remote.origin.*'-and$value-ne'DISABLED'-and$value-notmatch'^https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(?:\.git)?$')-or($key-eq'core.hookspath'-and$value-ne'.githooks')){throw "BACKUP_UNSAFE_CONFIG: $key"}
       }}
   ```

   c) replace the line
   ```text
       $plan.repos+=[ordered]@{name=$name;head=$head;branch=$branch;dirty=$dirty;stash=$stash;worktrees=$worktrees;origin=(Invoke-Git $r config --local remote.origin.url).Trim()
   ```
   with
   ```text
       $plan.repos+=[ordered]@{name=$name;head=$head;branch=$branch;dirty=$dirty;stash=$stash;worktrees=$worktrees;origin=(($localConfig|Where-Object{$_-like'remote.origin.url=*'})-replace'^remote.origin.url=','')
   ```

   d) immediately after the line
   ```text
   function Save-CloneState([string]$Clone,[string]$To){
   ```
   insert
   ```text
       $localConfig=@(Get-SafeConfig $Clone)
   ```

   e) replace the line
   ```text
       [ordered]@{head=$head;branch="$(& git -C $Clone symbolic-ref -q --short HEAD)".Trim();origin="$(& git -C $Clone config --get remote.origin.url)".Trim();refs=$refs;unique=$unique}|ConvertTo-Json -Depth 3|Set-Content (Join-Path $state 'state.json')
   ```
   with
   ```text
       [ordered]@{head=$head;branch="$(& git -C $Clone symbolic-ref -q --short HEAD)".Trim();origin=(($localConfig|Where-Object{$_-like'remote.origin.url=*'})-replace'^remote.origin.url=','');refs=$refs;unique=$unique}|ConvertTo-Json -Depth 3|Set-Content (Join-Path $state 'state.json')
   ```

   The resulting file's Git blob is 3f0119853d1fe5ea011a255edb7b9da57a918842.

4. Check whether `lib/test-sync-sessions-rewrite.ps1` contains `REWRITE_SELFCHECK`; if so record Already Applied when its Git blob is 066bf262fad8f3beb89476bcc042a93246273c67, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       Assert-That 'and keeps the old copy beside' ((Get-Aside 's1.replaced-*.jsonl').Count-eq1-and([IO.File]::ReadAllText("$arch\s1.jsonl"))-ceq[IO.File]::ReadAllText($s))
   ```
   insert
   ```text
       $middle="$proj\middle.jsonl";$old=('{"pad":"'+('a'*12KB)+'"}'+"`n")*2
       [IO.File]::WriteAllText($middle,$old);Invoke-Sync
       [IO.File]::WriteAllText($middle,$old.Substring(0,12KB)+'b'+$old.Substring(12KB+1)+"{}`n");Invoke-Sync
       Assert-That 'unchanged ends with a rewritten middle preserve both whole versions' ((Get-Aside 'middle.replaced-*.jsonl').Count-eq1-and[IO.File]::ReadAllText((Get-Aside 'middle.replaced-*.jsonl')[0].FullName)-ceq$old-and(Get-FileHash "$arch\middle.jsonl").Hash-ceq(Get-FileHash $middle).Hash)
   ```

   The resulting file's Git blob is 066bf262fad8f3beb89476bcc042a93246273c67.

5. Check whether `lib/test-sync-sessions-survival.ps1` contains `SURVIVAL_SELFCHECK`; if so record Already Applied when its Git blob is b90ad1179f29d5e4b01e9eaec2866e87e80bde7b, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       Assert-That 'INDEX.md is written' ((Get-Content "$ws\sessions\INDEX.md" -Raw)-match'keep me')
   ```
   insert
   ```text
       $sync=Join-Path $t 'sync.ps1';$locked="$cp\C--Users-x-Documents-GitHub-CRM\locked.jsonl"
       $body=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Sync-Sessions.ps1')).Replace('Local\orvion-sync-sessions',('Local\orvion-sync-sessions-'+[guid]::NewGuid().ToString('N')))
       [IO.File]::WriteAllText($sync,$body)
       [IO.File]::WriteAllText($locked,"{}`n")
       $handle=[IO.File]::Open($locked,'Open','ReadWrite','None')
       try{$failed=@(& pwsh -NoProfile -File $sync -Root $ws -ClaudeProjects $cp -CodexSessions $cx -Quiet 2>&1);$code=$LASTEXITCODE}finally{$handle.Dispose()}
       $onceFailed=$code-eq3-and($failed-join' ')-match'SESSIONS: preservation FAILED'-and(Test-Path "$ws\work\sync-errors.log")
       # Only process discovery is stubbed: the first failed pass recovers before the final pass.
       $followerPath=Join-Path $t 'follow.ps1'
       $body=[IO.File]::ReadAllText($sync).Replace('function Test-AgentsRunning{[bool](Get-Process -Name claude,codex -ErrorAction SilentlyContinue)}','function Test-AgentsRunning{$blocked=Join-Path $Root ''sessions\raw\claude\C--Users-x-Documents-GitHub-CRM\locked.jsonl'';if(Test-Path -LiteralPath $blocked -PathType Container){Remove-Item -LiteralPath $blocked};return $false}')
       [IO.File]::WriteAllText($followerPath,$body)
       [void][IO.Directory]::CreateDirectory("$ws\sessions\raw\claude\C--Users-x-Documents-GitHub-CRM\locked.jsonl")
       $failed=@(& pwsh -NoProfile -File $followerPath -Root $ws -ClaudeProjects $cp -CodexSessions $cx -Quiet -Follow -IntervalSeconds 0 2>&1);$code=$LASTEXITCODE
       Assert-That 'quiet follower remembers a failed pass after recovery and exits 3' ($code-eq3-and($failed-join' ')-match'SESSIONS: preservation FAILED'-and(Test-Path "$ws\sessions\raw\claude\C--Users-x-Documents-GitHub-CRM\locked.jsonl" -PathType Leaf))
       $success=@(& pwsh -NoProfile -File $sync -Root $ws -ClaudeProjects $cp -CodexSessions $cx -Quiet 2>&1)
       Assert-That 'quiet preservation failure is visible with exit 3; success stays silent with exit 0' ($onceFailed-and$LASTEXITCODE-eq0-and$success.Count-eq0)
   ```

   The resulting file's Git blob is b90ad1179f29d5e4b01e9eaec2866e87e80bde7b.

6. Check whether `lib/test-backup-restore.ps1` contains `BACKUP_RESTORE_SELFCHECK`; if so record Already Applied when its Git blob is 22a5ee0d1fb62cb6c0f661b13771f6dc603976e5, and otherwise stop and report. Otherwise make exactly these 11 edits (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   $zip=(Get-Command 7z -CommandType Application -ErrorAction SilentlyContinue|Select-Object -First 1).Source;if(!$zip){$zip=Join-Path $env:ProgramFiles '7-Zip\7z.exe'}
   if(!(Test-Path -LiteralPath $zip)){throw 'BACKUP_RESTORE_SELFCHECK_7ZIP_REQUIRED: package self-checks require 7z'}
   ```

   b) immediately after the line
   ```text
   $t=Join-Path ([IO.Path]::GetTempPath()) "orvion-brcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))"
   ```
   insert
   ```text
   $savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
   $env:GIT_CONFIG_GLOBAL=Join-Path $t 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
   ```

   c) immediately after the line
   ```text
   function Invoke-Quiet{param([string]$Dir)$o=& git -C $Dir -c user.name=t -c user.email=t@t @args 2>&1;if($LASTEXITCODE){throw "git $args : $o"};$o}
   ```
   insert
   ```text
   function Read-BackupTree([string]$Path){(@(Get-ChildItem -LiteralPath $Path -Recurse -File -Force|ForEach-Object{[Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($_.FullName))})-join"`n")}
   ```

   d) immediately after the line
   ```text
       Invoke-Quiet $crm branch orvion/x-pending|Out-Null
   ```
   insert
   ```text
       Invoke-Quiet $crm config credential.https://github.com.helper '!gh auth token'|Out-Null
   ```

   e) replace the line
   ```text
       $up=& git -C $rc config --get-all branch.main.remote
   ```
   with
   ```text
       $up=& git -C $rc config --local --get-all branch.main.remote
   ```

   f) immediately after the line
   ```text
       Assert-That 'restore warns about the stash' (($r-join' ')-match'WARN CRM: 2 stash')
   ```
   insert
   ```text
       $helperKept=(& git -C $rc config --get credential.https://github.com.helper)-ceq'!gh auth token'
       $fake='ghp_'+'FAKE'+('x'*36)
       $shellHelper='!f() { echo username=fixture-login; echo "password=$(gh auth token --user fixture-login)"; }; f'
       $unsafeCases=@(
           @('header','http.https://github.com/.extraheader',"AUTHORIZATION: $fake",$fake),
           @('cookiefile','http.https://github.com/.cookiefile','fixture-cookie-path','fixture-cookie-path'),
           @('helper','credential.helper',"!echo $fake",$fake),
           @('shell-literal-token','credential.helper',$shellHelper.Replace('$(gh auth token --user fixture-login)',$fake),$fake),
           @('contains-gh-probe','credential.helper','!echo gh auth token; echo UNAPPROVED_FIXTURE_SECRET','UNAPPROVED_FIXTURE_SECRET'),
           @('username-token-probe','credential.https://github.com.username',$fake,$fake),
           @('mismatched-login','credential.helper',$shellHelper.Replace('--user fixture-login','--user different-login'),'different-login'),
           @('echo-password','credential.helper','echo password=hunter2','hunter2'),
           @('gh-literal-token','credential.helper',($shellHelper+'; echo '+$fake),$fake),
           @('gh-pat-prefix','credential.helper',($shellHelper+'; echo github_pat_fixture'),'github_pat_fixture'),
           @('gh-literal-password','credential.helper','!f() { echo "password=hunter2"; gh auth token; }; f','hunter2'))
       foreach($case in $unsafeCases){
           Invoke-Quiet $crm config $case[1] $case[2]|Out-Null
           $destination=Join-Path $t ('unsafe-'+$case[0])
           try{$unsafe=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination $destination -AllowUnencrypted 2>&1);$code=$LASTEXITCODE}
           finally{if($case[1]-eq'remote.origin.url'){Invoke-Quiet $crm config $case[1] $remote|Out-Null}else{Invoke-Quiet $crm config --unset-all $case[1]|Out-Null}}
           $copies=Read-BackupTree $destination
           Assert-That ('product config refuses '+$case[0]+' by key without saving its value; external helper survives') ($helperKept-and$code-ne0-and($unsafe-join' ')-match'BACKUP_UNSAFE_CONFIG'-and($unsafe-join' ').Contains($case[1])-and!($unsafe-join' ').Contains($case[3])-and!$copies.Contains($case[3])-and($unsafe-join' ')-notmatch'BACKUP:')
       }
       # The real helper chain resets first, then asks gh at restore-time; never execute the helper here.
       $helperKey='credential.https://github.com.helper'
       Invoke-Quiet $crm config --unset-all $helperKey|Out-Null
       Invoke-Quiet $crm config --add $helperKey ''|Out-Null;Invoke-Quiet $crm config --add $helperKey $shellHelper|Out-Null
       $helperDestination=Join-Path $t 'helper-chain'
       $helperBackup=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination $helperDestination -AllowUnencrypted 2>&1);$helperCode=$LASTEXITCODE
       $restoredHelpers=@();$helperRestoreCode=-1
       if($helperCode-eq0){
           $helperFolder=@(Get-ChildItem $helperDestination -Directory)[0].FullName;$helperTarget=Join-Path $t 'restored-helpers'
           $helperRestore=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $helperFolder -Target $helperTarget -ClaudeHome (Join-Path $t 'helper-ch') -LegacyTarget (Join-Path $t 'helper-docs') 2>&1);$helperRestoreCode=$LASTEXITCODE
           if($helperRestoreCode-eq0){$restoredHelpers=@(& git -C "$helperTarget\CRM" config --local --get-all $helperKey)}
       }
       Assert-That 'empty reset and exact gh shell-function helper survive backup and restore in order' ($helperCode-eq0-and$helperRestoreCode-eq0-and$restoredHelpers.Count-eq2-and$restoredHelpers[0]-ceq''-and$restoredHelpers[1]-ceq$shellHelper)
       Invoke-Quiet $crm config --unset-all $helperKey|Out-Null;Invoke-Quiet $crm config $helperKey '!gh auth token'|Out-Null
       # Force every clone/init key to be present, independent of Git/platform defaults.
       $cloneMetadata=[ordered]@{'core.repositoryformatversion'='0';'core.filemode'='false';'core.bare'='false';'core.logallrefupdates'='true';'core.symlinks'='false';'core.ignorecase'='true';'remote.origin.fetch'='+refs/heads/*:refs/remotes/origin/*'}
       foreach($metadataKey in $cloneMetadata.Keys){Invoke-Quiet $crm config $metadataKey $cloneMetadata[$metadataKey]|Out-Null}
       foreach($case in @(@('username','someone'),@('token',$fake),@('password',"fixture-user:$fake"))){
           $origin="https://$($case[1])@github.com/o/r.git";$cleanOrigin='https://github.com/o/r.git'
           $urlKey="credential.https://$($case[1])@github.com.username";$cleanUrlKey='credential.https://github.com.username'
           Invoke-Quiet $crm config remote.origin.url $origin|Out-Null;Invoke-Quiet $crm config $urlKey 'fixture-account'|Out-Null
           Invoke-Quiet $legacy config remote.origin.url $origin|Out-Null
           $destination=Join-Path $t ('userinfo-'+$case[0]);$target=Join-Path $t ('restored-userinfo-'+$case[0])
           try{
               $stripped=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination $destination -AllowUnencrypted 2>&1);$code=$LASTEXITCODE
               $originKept=$false;$urlKeyKept=$false;$nestedOriginKept=$false;$configLines=@()
               if($code-eq0){
                   $folder=@(Get-ChildItem $destination -Directory)[0].FullName
                   $configLines=[IO.File]::ReadAllLines("$folder\repos\CRM\git-config-local.txt")
                   $nestedOriginKept=(Get-Content -LiteralPath "$folder\legacy\ORVION-drafts-backup\.clone-state\state.json" -Raw|ConvertFrom-Json).origin-ceq$cleanOrigin
                   $userRestore=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $folder -Target $target -ClaudeHome ($target+'-ch') -LegacyTarget ($target+'-docs') 2>&1)
                   if($LASTEXITCODE-eq0){
                       $originKept=(& git -C "$target\CRM" config --get remote.origin.url)-ceq$cleanOrigin
                       $urlKeyKept=(& git -C "$target\CRM" config --get $cleanUrlKey)-ceq'fixture-account'
                   }
               }
               $tree=Read-BackupTree $destination;$messages=$stripped-join"`n"
               Assert-That ('userinfo '+$case[0]+' stripped from origin, backup.json and state.json; every backup file searched') ($code-eq0-and$originKept-and$nestedOriginKept-and$configLines-ccontains"remote.origin.url=$cleanOrigin"-and$messages.Contains('BACKUP_CONFIG_USERINFO_STRIPPED: remote.origin.url')-and!$messages.Contains($case[1])-and!$tree.Contains($case[1])-and!$tree.Contains($fake))
               Assert-That ('userinfo '+$case[0]+' stripped from URL-shaped key and restored with key-only warning') ($code-eq0-and$urlKeyKept-and$configLines-ccontains"$cleanUrlKey=fixture-account"-and$messages.Contains("BACKUP_CONFIG_USERINFO_STRIPPED: $cleanUrlKey")-and!$messages.Contains($case[1])-and!$tree.Contains($case[1]))
               if($case[0]-eq'username'){foreach($metadataKey in $cloneMetadata.Keys){
                   Assert-That ("clone metadata silently omitted: $metadataKey") ($code-eq0-and!$messages.Contains("BACKUP_CONFIG_OMITTED: $metadataKey")-and@($configLines|Where-Object{($_-split'=',2)[0]-eq$metadataKey}).Count-eq0)
               }}
           }finally{
               Invoke-Quiet $crm config remote.origin.url $remote|Out-Null;Invoke-Quiet $crm config --unset-all $urlKey|Out-Null
               Invoke-Quiet $legacy config --unset-all remote.origin.url|Out-Null
           }
       }
       $manifestFile=Join-Path $bk 'SHA256SUMS.txt';$manifest=[IO.File]::ReadAllText($manifestFile)
       foreach($case in 'empty','plan','config','data','absolute','parent'){
           $changed=switch($case){
               empty {''}
               plan {(@($manifest-split'\r?\n'|Where-Object{$_-and$_-notmatch'  backup\.json$'})-join"`n")+"`n"}
               config {(@($manifest-split'\r?\n'|Where-Object{$_-and$_-notmatch'git-config-local\.txt$'})-join"`n")+"`n"}
               data {(@($manifest-split'\r?\n'|Where-Object{$_-and$_-notmatch'draft\.md$'})-join"`n")+"`n"}
               absolute {$manifest+((Get-FileHash "$bk\backup.json").Hash)+"  $bk\backup.json`n"}
               parent {$manifest+((Get-FileHash "$bk\backup.json").Hash)+"  ..\$([IO.Path]::GetFileName($bk))\backup.json`n"}
           }
           [IO.File]::WriteAllText($manifestFile,$changed);$destination=Join-Path $t ('manifest-'+$case)
           $refused=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target $destination -ClaudeHome ($destination+'-ch') -LegacyTarget ($destination+'-docs') 2>&1);$code=$LASTEXITCODE
           Assert-That ('manifest '+$case+' refuses before restore writes') ($code-ne0-and($refused-join' ')-match'BACKUP_MANIFEST_(INCOMPLETE|INVALID)'-and!(Test-Path $destination)-and!(Test-Path ($destination+'-ch'))-and!(Test-Path ($destination+'-docs')))
       }
       [IO.File]::WriteAllText($manifestFile,$manifest)
   ```

   g) replace the line
   ```text
       Assert-That 'auth-header config is refused without success' ($LASTEXITCODE-ne0-and($unsafe-join' ')-match'BACKUP_WORKBENCH_UNSAFE_CONFIG'-and($unsafe-join' ')-notmatch'BACKUP:')
   ```
   with
   ```text
       Assert-That 'auth-header config is refused without success' ($LASTEXITCODE-ne0-and($unsafe-join' ')-match'BACKUP_UNSAFE_CONFIG'-and($unsafe-join' ')-notmatch'BACKUP:')
   ```

   h) replace the lines
   ```text
       foreach($ref in @(Invoke-Quiet $trusted for-each-ref --format='%(refname)')){& git -C $trusted update-ref --no-deref -d $ref;if($LASTEXITCODE){throw 'TRUSTED_REF_FIXTURE_FAILED'}}
       $zip=(Get-Command 7z -CommandType Application -ErrorAction SilentlyContinue|Select-Object -First 1).Source;if(!$zip){$zip=Join-Path $env:ProgramFiles '7-Zip\7z.exe'}
   ```
   with
   ```text
       foreach($ref in @(Invoke-Quiet $trusted for-each-ref --format='%(refname)')){& git -C $trusted update-ref --no-deref -d $ref;if($LASTEXITCODE){throw 'TRUSTED_REF_FIXTURE_FAILED'}}
   ```

   i) immediately after the line
   ```text
           if(Get-Command gitleaks -CommandType Application -ErrorAction SilentlyContinue){
   ```
   insert
   ```text
               if([IO.File]::ReadAllText($scan)-match'^SECRET SCAN: FAILED'){
                   Assert-That 'a failed installed scanner is reported without exposing the planted value' (($pkg-join' ')-match'SECRET SCAN: FAILED'-and[IO.File]::ReadAllText($scan)-notmatch$planted-and($pkg-join' ')-notmatch$planted)
               }else{
   ```

   j) immediately after the line
   ```text
               Assert-That 'secret scan names the planted token by rule and path, never its value' ([IO.File]::ReadAllText($scan)-match'github-pat  legacy/ORVION-Sandbox/evidence/leak\.txt:1'-and[IO.File]::ReadAllText($scan)-notmatch$planted-and($pkg-join' ')-notmatch$planted-and($pkg-join' ')-match'SECRET SCAN: [1-9]')
   ```
   insert
   ```text
               }
   ```

   k) replace the line
   ```text
   }finally{$env:USERPROFILE=$previousProfile;Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
   }finally{$env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem;$env:USERPROFILE=$previousProfile;Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```

   The resulting file's Git blob is 22a5ee0d1fb62cb6c0f661b13771f6dc603976e5.

7. Check whether `lib/Events.ps1` contains `InvariantCulture`; if so record Already Applied when its Git blob is 2b9c06cd10182dfd9d701322ab474ba0eccf2983, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) replace the line
   ```text
           $e=[ordered]@{at=$At.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ');session="$Session";source=$Source;repo=$Repo;sha=$Sha
   ```
   with
   ```text
           $e=[ordered]@{at=$At.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ',[Globalization.CultureInfo]::InvariantCulture);session="$Session";source=$Source;repo=$Repo;sha=$Sha
   ```

   The resulting file's Git blob is 2b9c06cd10182dfd9d701322ab474ba0eccf2983.

8. Check whether `lib/Delegate.ps1` contains `InvariantCulture`; if so record Already Applied when its Git blob is ff8efac7dc5b7b5cf5b4ae8fb55a0236704983a1, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) replace the line
   ```text
   $null=& $ev -Root $Root -Add -Pattern $Pattern -Source delegate-road -Category observation -Status open -Summary "delegated ($Mode, $Minutes min): $Question" -Evidence (Join-Path $dir 'BRIEF.md') -Owner "delegate:$(Split-Path $dir -Leaf)" -Action 'report back' -Due ([DateTime]::UtcNow.AddMinutes(2*$Minutes).ToString('yyyy-MM-ddTHH:mm:ssZ'))
   ```
   with
   ```text
   $null=& $ev -Root $Root -Add -Pattern $Pattern -Source delegate-road -Category observation -Status open -Summary "delegated ($Mode, $Minutes min): $Question" -Evidence (Join-Path $dir 'BRIEF.md') -Owner "delegate:$(Split-Path $dir -Leaf)" -Action 'report back' -Due ([DateTime]::UtcNow.AddMinutes(2*$Minutes).ToString('yyyy-MM-ddTHH:mm:ssZ',[Globalization.CultureInfo]::InvariantCulture))
   ```

   The resulting file's Git blob is ff8efac7dc5b7b5cf5b4ae8fb55a0236704983a1.

9. Check whether `lib/test-coordinator.ps1` contains `InvariantCulture`; if so record Already Applied when its Git blob is 70186bf860bf1cdc053e2c6f884460cc3e981c7e, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) replace the line
   ```text
       & $co -Root $t -Assign lynx-leak -Owner agent -Action 'close the handle in finally' -Due ([DateTime]::UtcNow.ToString('yyyy-MM-dd'))|Out-Null
   ```
   with
   ```text
       & $co -Root $t -Assign lynx-leak -Owner agent -Action 'close the handle in finally' -Due ([DateTime]::UtcNow.ToString('yyyy-MM-dd',[Globalization.CultureInfo]::InvariantCulture))|Out-Null
   ```

   The resulting file's Git blob is 70186bf860bf1cdc053e2c6f884460cc3e981c7e.

10. Check whether `lib/test-events.ps1` contains `ar-SA`; if so record Already Applied when its Git blob is ca0334a38216ea0b77bbc493630ac7480a197a7d, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       Assert-That "every data tool carries the one identical data-root default$(if($drift.Count){' (drifted: '+($drift-join', ')+')'})" (!$drift.Count)
   ```
   insert
   ```text
       # A Hijri-calendar culture (ar-SA) must not leak into stored timestamps: readers parse them as Gregorian UTC.
       $hijri=Join-Path $t 'hijri';& pwsh -NoProfile -Command "[Globalization.CultureInfo]::CurrentCulture='ar-SA';& '$($ev.Replace("'","''"))' -Root '$($hijri.Replace("'","''"))' -Add -Pattern locale-check -Summary 'calendar'"|Out-Null
       $stamp=([IO.File]::ReadAllLines((Join-Path $hijri 'events\events.jsonl'))[0]|ConvertFrom-Json -DateKind String).at
       Assert-That 'timestamps stay Gregorian UTC under an ar-SA culture' ("$stamp".StartsWith([DateTime]::UtcNow.ToString('yyyy',[Globalization.CultureInfo]::InvariantCulture)))
   ```

   The resulting file's Git blob is ca0334a38216ea0b77bbc493630ac7480a197a7d.

11. Check whether `lib/test-owner-dual.ps1` contains `GIT_CONFIG_NOSYSTEM`; if so record Already Applied when its Git blob is a0744d625ab74f68613d73e770ad78321f88798a, and otherwise stop and report. Otherwise make exactly these 3 edits (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   [void][IO.Directory]::CreateDirectory($work)
   ```
   insert
   ```text
   $savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
   $env:GIT_CONFIG_GLOBAL=Join-Path $work 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
   try{
   ```

   b) replace the line
   ```text
               sourceDraftSha256=('A'*64);reviewSha256=('B'*64);expiresUtc=[DateTime]::UtcNow.AddHours(1).ToString('yyyy-MM-ddTHH:mm:ssZ');
   ```
   with
   ```text
               sourceDraftSha256=('A'*64);reviewSha256=('B'*64);expiresUtc=[DateTime]::UtcNow.AddHours(1).ToString('yyyy-MM-ddTHH:mm:ssZ',[Globalization.CultureInfo]::InvariantCulture);
   ```

   c) immediately after the line
   ```text
   exit [int]($failed-gt0)
   ```
   insert
   ```text
   }finally{$env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem}
   ```

   The resulting file's Git blob is a0744d625ab74f68613d73e770ad78321f88798a.

12. Check whether `lib/test-draft-steps.ps1` contains `GIT_CONFIG_NOSYSTEM`; if so record Already Applied when its Git blob is d2f4f3913d55fdb8e184a5222c50af77fe708ca0, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $root=Join-Path ([IO.Path]::GetTempPath()) "orvion-draft-steps-$PID";$fail=0
   ```
   insert
   ```text
   $savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
   $env:GIT_CONFIG_GLOBAL=Join-Path $root 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
   ```

   b) immediately after the lines
   ```text
       Test-CreationCases
   }finally{
   ```
   insert
   ```text
       $env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem
   ```

   The resulting file's Git blob is d2f4f3913d55fdb8e184a5222c50af77fe708ca0.

13. Check whether `lib/test-map-repos.ps1` contains `GIT_CONFIG_NOSYSTEM`; if so record Already Applied when its Git blob is 31525e94b249832b00af12ab7ab71682fd7497e5, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   [void][IO.Directory]::CreateDirectory($gh);[void][IO.Directory]::CreateDirectory($out);$fail=0
   ```
   insert
   ```text
   $savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
   $env:GIT_CONFIG_GLOBAL=Join-Path $t 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
   ```

   b) replace the line
   ```text
   }finally{Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
   }finally{$env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem;Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```

   The resulting file's Git blob is 31525e94b249832b00af12ab7ab71682fd7497e5.

14. Check whether `lib/test-native-stage.ps1` contains `GIT_CONFIG_NOSYSTEM`; if so record Already Applied when its Git blob is dfa482496f381442328efe512d1cd827a82ab983, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   [void][IO.Directory]::CreateDirectory($tempRoot)
   ```
   insert
   ```text
   $savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
   $env:GIT_CONFIG_GLOBAL=Join-Path $tempRoot 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
   ```

   b) immediately after the line
   ```text
   }finally{
   ```
   insert
   ```text
       $env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem
   ```

   The resulting file's Git blob is dfa482496f381442328efe512d1cd827a82ab983.

15. Check whether `lib/test-pulse.ps1` contains `GIT_CONFIG_NOSYSTEM`; if so record Already Applied when its Git blob is 7995b7df033279f69cfc03476ba5a38c083799d2, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   [void][IO.Directory]::CreateDirectory($pulseFixture)
   ```
   insert
   ```text
   $savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
   $env:GIT_CONFIG_GLOBAL=Join-Path $pulseFixture 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
   $savedGitCeiling=$env:GIT_CEILING_DIRECTORIES;$env:GIT_CEILING_DIRECTORIES=$pulseFixture
   ```

   b) immediately after the line
   ```text
   }finally{
   ```
   insert
   ```text
       $env:GIT_CEILING_DIRECTORIES=$savedGitCeiling
       $env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem
   ```

   The resulting file's Git blob is 7995b7df033279f69cfc03476ba5a38c083799d2.

16. Check whether `lib/test-spider.ps1` contains `GIT_CONFIG_NOSYSTEM`; if so record Already Applied when its Git blob is 06bc8b6e8b61ad9bc7eb3707c684279f589135c9, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $previousProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
   ```
   insert
   ```text
   $savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
   $env:GIT_CONFIG_GLOBAL=Join-Path $t 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
   ```

   b) replace the line
   ```text
   }finally{$env:USERPROFILE=$previousProfile;if(Test-Path $t){Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}}
   ```
   with
   ```text
   }finally{$env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem;$env:USERPROFILE=$previousProfile;if(Test-Path $t){Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}}
   ```

   The resulting file's Git blob is 06bc8b6e8b61ad9bc7eb3707c684279f589135c9.

17. Check whether `lib/test-hunt.ps1` contains `USERPROFILE`; if so record Already Applied when its Git blob is 9c0c911150d02925eff6823cdfdcdbabcf1658c4, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $t=Join-Path ([IO.Path]::GetTempPath()) "orvion-huntcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t|Out-Null
   ```
   insert
   ```text
   $savedProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
   ```

   b) replace the line
   ```text
   }finally{Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
   }finally{$env:USERPROFILE=$savedProfile;Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```

   The resulting file's Git blob is 9c0c911150d02925eff6823cdfdcdbabcf1658c4.

18. Check whether `lib/README.md` contains `complete hash manifest`; if so record Already Applied when its Git blob is 1ff6392a15f1c82ae192cfc31aaf76c060ae75cb, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy preservation and hermetic checks only), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
   | `..\tests.ps1` | sole full closure schedule: hazards plus each owning test suite; only own timed Finish may launch it with the bound recipe. The normal hook checks admission/freshness, not another full run. |

   ```
   insert
   ```text
   Session appends prove every archived prefix byte by streaming; rewrites retain the old version. Any failed pass emits a diagnostic even with `-Quiet` and exits 3 (follow remembers earlier failures). Hooks launch detached: success stays silent, failure status/output belongs to the child and never blocks the hook.
   Restore requires a complete hash manifest, including `backup.json`, and refuses absolute or parent paths before writing. Every repository uses the same config allowlist; auth headers, cookie files, unapproved helpers and helpers containing literal secrets refuse by key only. Empty helper resets, manager/manager-core/wincred and gh auth token/git-credential commands (including shell functions) survive for re-login. URL userinfo is stripped from config keys and values with a key-only warning before any config or origin metadata is saved. Clone/init metadata is silently omitted; branch upstream entries remain kept.

   ```

   The resulting file's Git blob is 1ff6392a15f1c82ae192cfc31aaf76c060ae75cb.

## Acceptance Criteria

- [ ] Exact approved scoped output. check: blob:lib/Sync-Sessions.ps1=7efe44b2ffcdec6895a69b850e8689874064e63a
- [ ] Exact approved scoped output. check: blob:lib/Restore-Workspace.ps1=2bab89142b0321b4991b0a80628b4afcea53338d
- [ ] Exact approved scoped output. check: blob:lib/Backup-Workspace.ps1=3f0119853d1fe5ea011a255edb7b9da57a918842
- [ ] Exact approved scoped output. check: blob:lib/test-sync-sessions-rewrite.ps1=066bf262fad8f3beb89476bcc042a93246273c67
- [ ] Exact approved scoped output. check: blob:lib/test-sync-sessions-survival.ps1=b90ad1179f29d5e4b01e9eaec2866e87e80bde7b
- [ ] Exact approved scoped output. check: blob:lib/test-backup-restore.ps1=22a5ee0d1fb62cb6c0f661b13771f6dc603976e5
- [ ] Exact approved scoped output. check: blob:lib/Events.ps1=2b9c06cd10182dfd9d701322ab474ba0eccf2983
- [ ] Exact approved scoped output. check: blob:lib/Delegate.ps1=ff8efac7dc5b7b5cf5b4ae8fb55a0236704983a1
- [ ] Exact approved scoped output. check: blob:lib/test-coordinator.ps1=70186bf860bf1cdc053e2c6f884460cc3e981c7e
- [ ] Exact approved scoped output. check: blob:lib/test-events.ps1=ca0334a38216ea0b77bbc493630ac7480a197a7d
- [ ] Exact approved scoped output. check: blob:lib/test-owner-dual.ps1=a0744d625ab74f68613d73e770ad78321f88798a
- [ ] Exact approved scoped output. check: blob:lib/test-draft-steps.ps1=d2f4f3913d55fdb8e184a5222c50af77fe708ca0
- [ ] Exact approved scoped output. check: blob:lib/test-map-repos.ps1=31525e94b249832b00af12ab7ab71682fd7497e5
- [ ] Exact approved scoped output. check: blob:lib/test-native-stage.ps1=dfa482496f381442328efe512d1cd827a82ab983
- [ ] Exact approved scoped output. check: blob:lib/test-pulse.ps1=7995b7df033279f69cfc03476ba5a38c083799d2
- [ ] Exact approved scoped output. check: blob:lib/test-spider.ps1=06bc8b6e8b61ad9bc7eb3707c684279f589135c9
- [ ] Exact approved scoped output. check: blob:lib/test-hunt.ps1=9c0c911150d02925eff6823cdfdcdbabcf1658c4
- [ ] Exact approved scoped output. check: blob:lib/README.md=1ff6392a15f1c82ae192cfc31aaf76c060ae75cb
- [ ] The owning tests prove: a rewritten transcript with unchanged ends keeps both whole versions; a quiet failed pass or follower exits 3 with a visible line while success stays silent with exit 0; Restore refuses an empty, partial, absolute or parent-path manifest before any write; Backup strips userinfo (username or token) from every URL value and key and the stripped text appears in no backup file, keeps an empty reset plus a gh shell-function helper in order through backup and restore, accepts helpers only by exact whole-value grammar (same login twice in the gh shell-function shape), and refuses literal tokens in any kept value, passwords and auth headers by key name without storing the value; Events and Delegate write invariant Gregorian timestamps; the git-fixture checks (backup-restore, draft-steps, map-repos, native-stage, owner-dual, pulse, spider) set and restore GIT_CONFIG_GLOBAL/GIT_CONFIG_NOSYSTEM and the Hunt check isolates its profile.
- [ ] Mandatory V1/V2/V3, focused proof, planted-regression mutants, accepted literal replay controls and the real before/after measurement are preserved. One isolated native timed/watched Finish owns the full schedule with a fresh SANDBOX receipt before original approval; the original needs its own fresh Finish, live Review, native Complete and an independent carrying-range READY.

## Review Gate

- [ ] Inspect the eighteen scoped files, the focused/mutant/literal evidence and the real read-only measurement; preserve all frozen prior evidence.
- [ ] Independently check the native receipt root/Draft/recipe/evaluator/fingerprint, ordered tests and timed/watcher/host exits; normal native Review/Complete and every new carrying transition must pass. No second-agent or provider certification is claimed.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Decision D20 in C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\DECISIONS.md (under the owner's D19 request and D12 approval): fix the preservation tools the reinstall depends on, found by the Codex tool audit. Codex implemented in a disposable clone under orchestrator supervision. Under the owner's exceptional delegation this one Workbench contract is authorized. Gate 1 for this Draft is DELEGATED: the owner did not type its digest. Sandbox approval is synthetic and grants no original authority.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws018-package\assurance\V3\DRAFT.md
Approved SHA256: 11625D31360BA36F5B902733B850624B1039BEC221DEDBCB1AF0060897EECCD0
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\GATE1-WS018-DELEGATED.md
Owner Evidence SHA256: 05CC355FDFDE67DD0B8C857DBBF86B0EBC01264AA30AF9BF24888962A38309A8
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws018-package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 832880DAF7FEA8560A085ACA4D90EADFBEE8AEEC072174F6812BC373D38CBBDB
Original admission: DELEGATED exact Gate 1 under the owner's exceptional delegation of 2026-10-26 (OWNER-DELEGATION.md SHA-256 94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217; decisions D1-D20; D20 is the delegated decision for this contract). The owner did not type this digest. Bound to this literal root, the exact V3 digest and the fresh sandbox receipt; no sandbox receipt transplant as original certification.

## Verification Notes

Measured before freeze on the real workstation, read-only (real-measurement.json; key names and outcomes only, never a value): before, Backup wrote the four product repositories' local git config verbatim (CRM origin carried username userinfo); after, all six repositories are KEPT with no userinfo left, both gh shell-function helpers kept after the empty reset, editor metadata keys omitted. The whole-prefix proof reads the largest real archived transcript (168.7 MB) in 208 ms. Codex fixtures missed three real shapes found by the orchestrator: the shell-function helper (would refuse), username userinfo (would refuse) and a test reading global git config (fails on this workstation); all fixed and pinned. A Codex evidence review (codex\review1-report.txt) then PROVED: an arbitrary command containing "gh auth token" and a token in credential.*.username were saved (fixed in round 3 by an exact whole-value helper grammar and a secret veto on every kept value, codex\fix3-report.txt); ar-SA culture wrote year 1448 timestamps (fixed, invariant culture); seven git-fixture checks and Hunt changed outcome under a hostile global/system config or profile (fixed, hermetic); its final hostile-config run passed 389 assertions with zero failures. Eight planted regressions are each detected (mutants.log), including an orchestrator-added ar-SA timestamp assertion that pins the locale fix; hazard scan 0; fifteen owning self-checks PASS. Codex tools-report findings #3, #4, #6, #7 are closed by this contract.

## Selection reasons and sources

Evidence Refresh: focused-selected.log PASS for the fifteen owning self-checks on the selected bytes, eight planted regressions detected, hazard scan 0, real read-only measurement, literal replay controls run before the one sandbox Finish. Baseline 6b5549d (main = preflight), accepted judge 835E14DA unchanged.

Sources: DECISIONS.md D19/D20, codex-reports\tools-report.txt, ws018-package\codex, accepted WORKFLOW/TEMPLATE/checker, WS-017 packet scripts, the real read-only measurement.
