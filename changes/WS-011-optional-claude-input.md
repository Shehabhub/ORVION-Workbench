# Workbench Change Request - WS-011

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Handle an absent optional Claude projects root in Spider and workspace backup without hiding errors reading present data. Isolate the owning fixtures from the user profile and preserve required backup/restore failures. One shared environmental defect, four engineering files, no workflow or schedule change.

## Baseline

10deefbb0367544a3f18e137c4d1db64f81b4432

## Write Scope

- RESUME.md
- lib/Spider.ps1
- lib/Backup-Workspace.ps1
- lib/test-spider.ps1
- lib/test-backup-restore.ps1

## Out of Scope

All other source, Restore-Workspace.ps1, workflow/policy and all 21-suite schedule changes, new dependencies/engines, global Claude directories, primary repositories, credentials, sessions/events/work data, original implementation without exact Gate 1, remote writes/reruns/promotion, trusted advancement, OMC restoration/migration, protection/visibility/subscriptions. Plan v1.6 and architecture v1.5 unchanged. CTRL-19 OPEN; Batch 6 and Phase 8 ON HOLD. Native allocation/status/pointer bookkeeping only in this role.

## Draft Assurance

V1: WS011-DESIGN-20261025 | 2026-10-25 | C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-ci-recovery-20261025\assurance\V1\DRAFT.md | 383F6283A8A1E4A3AE508FED019D96B346B98AB3059516753EDF81C3812DAAF4
V2: WS011-ADVERSARIAL-20261025 | 2026-10-25 | C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-ci-recovery-20261025\assurance\V2\DRAFT.md | 03DD618DC95FDC6BA8C872C3A469AB71D30705CA5E0510F3018C8075C19C0219
V3: WS011-REFRESH-20261025 | 2026-10-25 | C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-ci-recovery-20261025\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WShR
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WShR\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WShR\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-ci-recovery-20261025\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/Spider.ps1` contains `SPIDER_CLAUDE_PROJECTS_NOT_DIRECTORY`; if so record Already Applied when its Git blob is 27669741f44cd3ab846a85a6202f993447fcca82, and otherwise stop and report. Otherwise make exactly this one edit (guard optional Claude absence while retaining present-source failures and isolated causal coverage), each matched once, and change nothing else:

   a) replace the line
   ```text
       Get-ChildItem (Join-Path $env:USERPROFILE '.claude\projects') -Directory|ForEach-Object{$m=Join-Path $_.FullName 'memory';if(Test-Path $m){Get-ChildItem $m -File -Filter *.md}}
   ```
   with
   ```text
       $projects=Join-Path $env:USERPROFILE '.claude\projects'
       # Claude is optional; enumeration/read errors for a present source must still refuse.
       if(Test-Path -LiteralPath $projects){
           if(!(Test-Path -LiteralPath $projects -PathType Container)){throw 'SPIDER_CLAUDE_PROJECTS_NOT_DIRECTORY'}
           Get-ChildItem -LiteralPath $projects -Directory|ForEach-Object{$m=Join-Path $_.FullName 'memory';if(Test-Path $m){Get-ChildItem $m -File -Filter *.md}}
       }
   ```

   The resulting file's Git blob is 27669741f44cd3ab846a85a6202f993447fcca82.

2. Check whether `lib/Backup-Workspace.ps1` contains `BACKUP_CLAUDE_PROJECTS_NOT_DIRECTORY`; if so record Already Applied when its Git blob is c470d08d83220b09ba26442bfd3a064674e9c1f5, and otherwise stop and report. Otherwise make exactly these 2 edits (guard optional Claude absence while retaining present-source failures and isolated causal coverage), each matched once, and change nothing else:

   a) replace the line
   ```text
   foreach($p in Get-ChildItem "$env:USERPROFILE\.claude\projects" -Directory|Where-Object{Test-Path (Join-Path $_.FullName 'memory')}){
   ```
   with
   ```text
   $projects=Join-Path $env:USERPROFILE '.claude\projects'
   # Claude is optional; errors reading a present source still terminate the backup before its manifest.
   if(Test-Path -LiteralPath $projects){
   if(!(Test-Path -LiteralPath $projects -PathType Container)){throw 'BACKUP_CLAUDE_PROJECTS_NOT_DIRECTORY'}
   foreach($p in Get-ChildItem -LiteralPath $projects -Directory|Where-Object{Test-Path (Join-Path $_.FullName 'memory')}){
   ```

   b) immediately after the lines
   ```text
       if($p.Name-match'Documents-GitHub|ORVION'){Copy-Tree (Join-Path $p.FullName 'memory') (Join-Path $out "claude\projects\$($p.Name)\memory")}
   }
   ```
   insert
   ```text
   }
   ```

   The resulting file's Git blob is c470d08d83220b09ba26442bfd3a064674e9c1f5.

3. Check whether `lib/test-spider.ps1` contains `missing optional Claude root is not created`; if so record Already Applied when its Git blob is 6306c4e221384f9196b73e7caee5f671b94ad257, and otherwise stop and report. Otherwise make exactly these 3 edits (guard optional Claude absence while retaining present-source failures and isolated causal coverage), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $t=Join-Path ([IO.Path]::GetTempPath()) "orvion-spidercheck-$([guid]::NewGuid().ToString('N').Substring(0,6))"
   ```
   insert
   ```text
   $previousProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
   ```

   b) immediately after the line
   ```text
       Assert-That 'note found' ($text-match'== notes: \d+ files.*README\.md')
   ```
   insert
   ```text
       Assert-That 'missing optional Claude root is not created' (!(Test-Path (Join-Path $env:USERPROFILE '.claude')))
       $projects=Join-Path $env:USERPROFILE '.claude/projects'
       [void][IO.Directory]::CreateDirectory($projects)
       $empty=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo -ReviewRoot (Join-Path $t 'none'))
       Assert-That 'empty optional projects retains workspace notes' (($empty-join' ')-match'README\.md')
       [void][IO.Directory]::CreateDirectory((Join-Path $projects 'no-memory'))
       $memory=Join-Path $projects 'project/memory';[void][IO.Directory]::CreateDirectory($memory)
       $note=Join-Path $memory 'fixture.md';[IO.File]::WriteAllText($note,'ZEBRA-42 memory')
       $present=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo -ReviewRoot (Join-Path $t 'none'))
       Assert-That 'valid Claude memory is searched and missing project memory is optional' (($present-join' ')-match'fixture\.md')
       $handle=[IO.File]::Open($note,'Open','ReadWrite','None')
       try{$refused=try{& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo -ReviewRoot (Join-Path $t 'none')|Out-Null;$false}catch{$true}}finally{$handle.Dispose()}
       Assert-That 'present unreadable memory fails instead of becoming no match' $refused
   ```

   c) replace the line
   ```text
   }finally{if(Test-Path $t){Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}}
   ```
   with
   ```text
       $env:USERPROFILE=Join-Path $t 'malformed-profile';[void][IO.Directory]::CreateDirectory((Join-Path $env:USERPROFILE '.claude'))
       [IO.File]::WriteAllText((Join-Path $env:USERPROFILE '.claude/projects'),'not a directory')
       $refused=try{& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo -ReviewRoot (Join-Path $t 'none')|Out-Null;$false}catch{"$_"-match'SPIDER_CLAUDE_PROJECTS_NOT_DIRECTORY'}
       Assert-That 'malformed present projects root is fatal' $refused
   }finally{$env:USERPROFILE=$previousProfile;if(Test-Path $t){Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}}
   ```

   The resulting file's Git blob is 6306c4e221384f9196b73e7caee5f671b94ad257.

4. Check whether `lib/test-backup-restore.ps1` contains `missing optional Claude root is not created`; if so record Already Applied when its Git blob is 2b00fe3d883272da8b8804dcdc5a44edae3b83fa, and otherwise stop and report. Otherwise make exactly these 5 edits (guard optional Claude absence while retaining present-source failures and isolated causal coverage), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   Copy-Item (Join-Path $PSScriptRoot 'Backup-Workspace.ps1'),(Join-Path $PSScriptRoot 'Restore-Workspace.ps1') $lib
   ```
   insert
   ```text
   $previousProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
   ```

   b) replace the line
   ```text
       $out=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination (Join-Path $t 'usb') -AllowUnencrypted)
   ```
   with
   ```text
       $out=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination (Join-Path $t 'usb') -AllowUnencrypted 2>&1)
       if($LASTEXITCODE-ne0){throw ('BACKUP_FIXTURE_FAILED: '+($out-join' '))}
       Assert-That 'missing optional Claude root is not created' (!(Test-Path (Join-Path $env:USERPROFILE '.claude')))
   ```

   c) immediately after the line
   ```text
       $r=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target $res -ClaudeHome (Join-Path $t 'ch') -LegacyTarget (Join-Path $t 'docs2'))
   ```
   insert
   ```text
       if($LASTEXITCODE-ne0){throw ('RESTORE_FIXTURE_FAILED: '+($r-join' '))}
   ```

   d) immediately after the line
   ```text
       Assert-That 'an existing target is refused' ($again-match'RESTORE_TARGET_EXISTS')
   ```
   insert
   ```text
       $projects=Join-Path $env:USERPROFILE '.claude/projects'
       [void][IO.Directory]::CreateDirectory((Join-Path $projects 'Documents-GitHub-empty/memory'))
       [void][IO.Directory]::CreateDirectory((Join-Path $projects 'Documents-GitHub-missing'))
       $memory=Join-Path $projects 'Documents-GitHub-valid/memory';[void][IO.Directory]::CreateDirectory($memory)
       $note=Join-Path $memory 'fixture.md';[IO.File]::WriteAllText($note,'fixture memory bytes')
       $withMemory=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination (Join-Path $t 'usb-memory') -AllowUnencrypted 2>&1)
       Assert-That 'present valid and empty or missing project memory backup succeeds' ($LASTEXITCODE-eq0-and($withMemory-join' ')-match'BACKUP:')
       $memoryBackup=@(Get-ChildItem (Join-Path $t 'usb-memory') -Directory)[0].FullName
       $memoryRestore=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $memoryBackup -Target (Join-Path $t 'restored-memory') -ClaudeHome (Join-Path $t 'ch-memory') -LegacyTarget (Join-Path $t 'docs-memory') 2>&1)
       Assert-That 'valid fixture restore preserves optional memory bytes' ($LASTEXITCODE-eq0-and[IO.File]::ReadAllText((Join-Path $t 'ch-memory/projects/Documents-GitHub-valid/memory/fixture.md'))-ceq'fixture memory bytes')
       foreach($case in @(@('required-receipt',"$crm\.orvion-local-certification.json"),@('present-memory',$note))){
           $handle=[IO.File]::Open($case[1],'Open','ReadWrite','None');$destination=Join-Path $t ('usb-locked-'+$case[0])
           try{$locked=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination $destination -AllowUnencrypted 2>&1);$code=$LASTEXITCODE}finally{$handle.Dispose()}
           Assert-That ($case[0]+' unreadable is fatal without a success manifest') ($code-ne0-and($locked-join' ')-notmatch'BACKUP:'-and@(Get-ChildItem $destination -Recurse -Filter SHA256SUMS.txt).Count-eq0)
       }
       $saved=[IO.File]::ReadAllBytes("$bk\repos\CRM\refs.txt");[IO.File]::Delete("$bk\repos\CRM\refs.txt")
       $incomplete=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target (Join-Path $t 'restored-incomplete') -ClaudeHome (Join-Path $t 'ch-incomplete') 2>&1)
       Assert-That 'incomplete artifact is fatal before creating a restore target' ($LASTEXITCODE-ne0-and($incomplete-join' ')-match'BACKUP_CORRUPT'-and!(Test-Path (Join-Path $t 'restored-incomplete')))
       [IO.File]::WriteAllBytes("$bk\repos\CRM\refs.txt",$saved)
   ```

   e) replace the line
   ```text
   }finally{Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
       [IO.File]::Delete("$bk\SHA256SUMS.txt")
       $missingManifest=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target (Join-Path $t 'restored-no-manifest') -ClaudeHome (Join-Path $t 'ch-no-manifest') 2>&1)
       Assert-That 'missing manifest is fatal before creating a restore target' ($LASTEXITCODE-ne0-and!(Test-Path (Join-Path $t 'restored-no-manifest')))
       $env:USERPROFILE=Join-Path $t 'malformed-profile';[void][IO.Directory]::CreateDirectory((Join-Path $env:USERPROFILE '.claude'))
       [IO.File]::WriteAllText((Join-Path $env:USERPROFILE '.claude/projects'),'not a directory')
       $malformed=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination (Join-Path $t 'usb-malformed') -AllowUnencrypted 2>&1)
       Assert-That 'malformed present projects root is fatal without success' ($LASTEXITCODE-ne0-and($malformed-join' ')-match'BACKUP_CLAUDE_PROJECTS_NOT_DIRECTORY'-and($malformed-join' ')-notmatch'BACKUP:')
   }finally{$env:USERPROFILE=$previousProfile;Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```

   The resulting file's Git blob is 2b00fe3d883272da8b8804dcdc5a44edae3b83fa.

## Acceptance Criteria

- [ ] Exact minimal optional-input guard or owning fixture change. check: blob:lib/Spider.ps1=27669741f44cd3ab846a85a6202f993447fcca82
- [ ] Exact minimal optional-input guard or owning fixture change. check: blob:lib/Backup-Workspace.ps1=c470d08d83220b09ba26442bfd3a064674e9c1f5
- [ ] Exact minimal optional-input guard or owning fixture change. check: blob:lib/test-spider.ps1=6306c4e221384f9196b73e7caee5f671b94ad257
- [ ] Exact minimal optional-input guard or owning fixture change. check: blob:lib/test-backup-restore.ps1=2b00fe3d883272da8b8804dcdc5a44edae3b83fa
- [ ] RESUME authority remains unchanged. check: normalized-resume:RESUME.md=1F392B6A18CC44442BCABE3E23BF82571975C585E8C70496881136170FECE520
- [ ] Focused evidence proves unchanged source fails both suites without Claude and passes both with an empty valid projects directory; selected source passes isolated absent, valid memory, empty or missing optional memory, present unreadable data and required unreadable receipt cases. Invalid root, corrupt/incomplete backup, missing manifest and existing restore target remain fatal; valid restore preserves exact HEAD/refs, disabled push, upstream and receipt/memory bytes.
- [ ] This role completes one fresh timed/watched native Finish across all 21 suites, independent accepted-evaluator live Review, native Review/Complete and full carrying-range verification. Sandbox success is neither original certification nor hosted acceptance.

## Review Gate

- [ ] Inspect actual four-file output, focused causal controls, unchanged workflow, schedule, Restore and source identity; preserve original and primary roots.
- [ ] Inspect this role's fresh root/Draft/evaluator/recipe/input-bound receipt, timed END, watcher/host exits and live criteria with an independent accepted evaluator before native Review/Complete; then judge every carrying transition, clean tree and None pointer.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Sandbox preparation only. Synthetic isolated root-bound rehearsal approval is allowed by the owner directive; it grants no original execution or remote authority. Original Gate 1 remains absent.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-ci-recovery-20261025\assurance\V3\DRAFT.md
Approved SHA256: 6BEE78104FD6A2A944C4567E709854DBDFA4EE639D6AC4DEA40E8B78C55B3597
Owner Evidence: C:\Users\My Lab\.codex\attachments\583da780-379a-45e7-986c-1e5e350ba511\Pasted text.txt
Owner Evidence SHA256: BEECCC67CE138DD36C97E564104C530FDBF4CAB45366B27FCA9048FAF3FA1E0B
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-ci-recovery-20261025\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: BFA0328CEFC3A8F007C08206CCB514515B3D175D7FD8B3F60F87D6E0119E1929
Original literal optional Claude input output applied through the accepted native Workbench entry, all declared blobs match. Fresh own timed/watched full Finish still required.

## Verification Notes

CRGL applied before design: Platinum 20ea5e0d8f63742308efd4dc5e13ef178f0f82db and Founder da919011ee8b0b03cee620e910ff828b8e179f61. Their current consistency guard conditionally enumerates optional areas; Read-ReceiptJson refuses missing/unreadable required receipts; owning Git read fixtures prove faults were reached and never conflate unreadable with empty. Completed carrying contracts Platinum SPEC-294 and Founder SPEC-296 preserve Contract B source after cancelled predecessors exposed an impossible pre-Complete binding criterion. Reuse the principles and isolated native lifecycle; do not copy product identities, credentials, full policy or adapters. Publish, Watch, Certify and Promote stay separate. No primary changes or polling infrastructure. Evidence is frozen in this packet; root cause is experimental, not inferred solely from the old hosted wrapper. The original run remains terminal failure; the sandbox cannot claim a new hosted success.

## Selection reasons and sources

Evidence refresh: exact baseline controls fail both suites only when projects is absent and pass when an empty valid root is supplied. Selected owning tests pass all focused cases with the profile restored in finally. Frozen literal output is the selected four-file implementation; a separate fresh sandbox Finish, native Review/Complete and range are still required. No original authority or hosted-success claim.

Sources: WORKFLOW.md, changes/TEMPLATE.md, accepted Test-WorkbenchChange.ps1, existing Spider/Backup/Restore and owning tests; preserved hosted run 40158026832 job 121063480096; red-observations.json and green-final-observations.json; CRGL.json pins inspected primary source, tests, completed contracts and history. Both fixtures use temporary profile paths only, not the owner's actual Claude data. No restore production change was necessary. CRGL supplements CAG, SACI, PICF and three-pass assurance; it creates no comparison subsystem.
