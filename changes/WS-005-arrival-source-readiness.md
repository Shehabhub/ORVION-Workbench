# Workbench Change Request - WS-005

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Make arrival reporting use one truthful Coordinator view and preserve selected portable source plans/retention guidance at the owner-created actual Git root, without changing native authority or moving preserved local data.

## Baseline

f42c5a098ca69a156e38e7ae8d9a5475c850f288

## Write Scope

- RESUME.md
- .gitignore
- README.md
- WORKFLOW.md
- lib/Pulse.ps1
- lib/Coordinator.ps1
- lib/test-pulse.ps1
- lib/README.md
- docs/EXECUTION-PLAN.md
- docs/WORKSPACE-LAYOUT.md

## Out of Scope

Every other engineering path; completed contracts/receipt archives; native original/trusted code, configuration, tests and release; own checker/driver/runner/profile/receipt logic; generic management/native dispatch, root binding/migration, backup/restore changes, credentials/global settings, raw archives/events, new remote/protection/CI, workstation/ContractC, cleanup, Batch6/Phase8. RESUME routing is explicitly declared; its normalized criterion binds the complete body excluding only the legal active pointer. No data migration or blank replacement journal is authorized. Existing authorized private source publication is separate and cannot imply hosted certification.

## Required Reading

Accepted WORKFLOW, affected Pulse/Coordinator/lib index and own template; existing EXECUTION-PLAN stages0-1 and selected WORKSPACE-LAYOUT; this package V1/V2 and actual focused/adversarial/path-preflight evidence. Reuse accepted source/recipe/resource and native independence guarantees. No redundant full historical/native-suite rerun.

## Draft Assurance

V1: WS005-READINESS-R4-V1-DESIGN | 2026-10-23 | C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-supervision-20261023\readiness-r4\assurance\V1\DRAFT.md | 9F23AA4D55FC2891C2FA7E4F8A02D89C07C671E87FBDC9C2BFDF3ACA4B7034E9
V2: WS005-READINESS-R4-V2-ADVERSARIAL | 2026-10-23 | C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-supervision-20261023\readiness-r4\assurance\V2\DRAFT.md | CD8C270636B6279634055875D0D35AB5F8455F04D6F2E52901B18298B0416723
V3: WS005-READINESS-R4-V3-REFRESH | 2026-10-23 | C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-supervision-20261023\readiness-r4\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WS005
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WS005\tests
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WS005\temp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-supervision-20261023\runtime
PowerShell Version: 7.6.7
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Pre-Approval Evidence

Accepted Pulse failed5 of9 relevant caller checks; corrected caller passes9, and30 existing Coordinator checks pass. Actual first owner-routing mutant survived, revealing a measurement flaw, which was corrected in the disposable test. Corrected category/exit mutants fail1/4 assertions respectively. Preserve both failed/successful observations. Three actual relocation callers show unchanged nesting is unsafe; no migration pass is inferred. The private initial f42c5a0 main was separately downloaded with exact tree/Boot, not new code certification. No original source/native product changed. Before original authority, exact literal replay and own sandbox timed/watched full lifecycle must pass.

## Implementation Steps

1. Check whether `RESUME.md` contains `Source/data transition:`; if so record Already Applied when its Git blob is 883d859b49be7d871f1bcd6db2861704b97e403e, and otherwise stop and report. Otherwise make exactly these 4 edits (declared source and preserved single data-store routing), each matched once, and change nothing else:

   a) replace the line
   ```text
   1. **Exact resume point.** Run `pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\lib\Pulse.ps1"`.
   ```
   with
   ```text
   1. **Exact resume point.** Run `pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\lib\Pulse.ps1" -Root "C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools"`.
   ```

   b) replace the line
   ```text
      steps, evidence, blockers, where to stop for the owner). Cannot run commands? Search `events\events.jsonl` (this folder)
   ```
   with
   ```text
      steps, evidence, blockers, where to stop for the owner). Cannot run commands? Search `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\events\events.jsonl` (the preserved single journal)
   ```

   c) replace the line
   ```text
      `sessions\INDEX.md`. Search them all: `lib\Spider.ps1 '<SPEC id, error, script or phrase>'`.
   ```
   with
   ```text
      `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\sessions\INDEX.md`. Search them all: `lib\Spider.ps1 -Root 'C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools' '<SPEC id, error, script or phrase>'`.
   ```

   d) replace the line
   ```text
   5. **Before any task.** `lib\Events.ps1 -Find '<task in a few words>'`: what earlier agents learned, with the session that holds it.
   ```
   with
   ```text
   5. **Before any task.** `lib\Events.ps1 -Root 'C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools' -Find '<task in a few words>'`: what earlier agents learned, with the session that holds it.

   Source/data transition: this checkout is the selected source, with the existing local accepted hook. The old ORVION-Owner-Tools root remains the ONE event/session data store until separately tested migration. Explicit Root arguments above select it; no journal/working receipt is transplanted here. HANDOFF.md is dated history. This routing does not authorize a native operation or certify restored state.
   ```

   The resulting file's Git blob is 883d859b49be7d871f1bcd6db2861704b97e403e.

2. Check whether `.gitignore` contains `Proposed derived discovery views`; if so record Already Applied when its Git blob is dda0913bab047ae39566241b75914375bcaa2db0, and otherwise stop and report. Otherwise make exactly this one edit (bounded arrival reporting and selected portable source documentation), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   .workbench-certifications/
   ```
   insert
   ```text

   # Proposed derived discovery views are regenerated locally, not authored source authority.
   /ai-map.json
   /repository-index.md
   ```

   The resulting file's Git blob is dda0913bab047ae39566241b75914375bcaa2db0.

3. Check whether `README.md` contains `What belongs in Git:`; if so record Already Applied when its Git blob is 0ccb3a3f028d394f981054244b447133a9d628ad, and otherwise stop and report. Otherwise make exactly these 2 edits (bounded arrival reporting and selected portable source documentation), each matched once, and change nothing else:

   a) replace the line
   ```text
   # ORVION-Owner-Tools — the one local workspace outside both repositories
   ```
   with
   ```text
   # ORVION Workbench - independent management source
   ```

   b) immediately after the lines
   ```text
   # ORVION Workbench - independent management source

   ```
   insert
   ```text
   Private source repository: https://github.com/Shehabhub/ORVION-Workbench . Current selected checkout: `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench`, an actual Git root. Local `.githooks` must be configured; cloning alone does not install hooks or recover journals/receipts. Existing native repositories remain independent siblings. Managed sandbox/test/temp/runtime stay outside this checkout under the accepted context.

   What belongs in Git: reviewed code/tests/governance, contracts, selected portable plans and minimum safe unique authority/assurance knowledge required for reproducibility or continuation. An essential generated lock can be important; disposable handwritten scratch can be excluded. Secrets, sensitive transcripts and unique ignored working evidence need protected external recovery; Gitignore is not backup. This source-only clone does not restore the whole workstation. Generated local search views and disposable runtime are excluded; native tracked projections retain native authority.

   Current plan and layout: [docs/EXECUTION-PLAN.md](docs/EXECUTION-PLAN.md), [docs/WORKSPACE-LAYOUT.md](docs/WORKSPACE-LAYOUT.md). These become the selected plan after this scope's original completion and programme-checkpoint cutover. Until then the current external plan/checkpoint own live progress. General native management, indexing, consolidated-data cutover, hosted enforcement and clean-Windows recovery remain pending. Old ORVION-Owner-Tools data/archiver is preserved; no parallel blank archive is initialized here.

   The remaining dated inventory below is historical context. Prefer the current source plan/checkpoint and actual Boot over its older path/remote/status statements.
   ```

   The resulting file's Git blob is 0ccb3a3f028d394f981054244b447133a9d628ad.

4. Check whether `WORKFLOW.md` contains `Arrival reporting: Pulse consumes one Coordinator Snapshot`; if so record Already Applied when its Git blob is 128e49003f0087865dbc2c576549e5dfece640c2, and otherwise stop and report. Otherwise make exactly this one edit (bounded arrival reporting and selected portable source documentation), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   Sources: Git githooks, git-add, git-hash-object and git-write-tree manuals; Microsoft Directory.Delete reference informs reuse of bounded owned-fixture cleanup; SLSA v1.2 artifact verification informs subject/input expectations. This is not a claim of SLSA compliance, signature verification, owner authentication or tamper resistance against equal OS privileges.
   ```
   insert
   ```text

   Arrival reporting: Pulse consumes one Coordinator Snapshot for owner routing and the queue, preserving that classifier's inherited assignment and explicit Readable state. A category named decision alone is not an owner wait. Missing/failed selected repository or required journal evidence yields visible UNREADABLE and Pulse exit2, never a zero-wait or clean substitute. A readable empty journal, unconfigured upstream or dirty tree retains its actual meaning. These observations grant no write permission, certification or universal liveness guarantee; native Boot and the owning exact contract still decide. test-pulse owns the real Git/journal caller fixtures.
   ```

   The resulting file's Git blob is 128e49003f0087865dbc2c576549e5dfece640c2.

5. Check whether `lib/Pulse.ps1` contains `One journal read/classifier`; if so record Already Applied when its Git blob is 63483229bc547b6ff34e5943801f873be42126fa, and otherwise stop and report. Otherwise make exactly these 10 edits (bounded arrival reporting and selected portable source documentation), each matched once, and change nothing else:

   a) replace the line
   ```text
   #   waiting    open owner decisions (events with category decision)
   ```
   with
   ```text
   #   waiting    genuine owner choices from the SAME Coordinator snapshot as the queue
   ```

   b) immediately after the line
   ```text
   $ErrorActionPreference='Stop'
   ```
   insert
   ```text
   $pulseUnreadable=$false
   ```

   c) replace the line
   ```text
   foreach($r in $Repos|Where-Object{Test-Path (Join-Path $_ '.git')}){
   ```
   with
   ```text
   foreach($r in $Repos){
   ```

   d) immediately after the line
   ```text
       try{
   ```
   insert
   ```text
           if(!(Test-Path -LiteralPath (Join-Path $r '.git'))){throw 'selected repository missing'}
   ```

   e) replace the line
   ```text
           $ab=try{(Get-GitLine $r rev-list --left-right --count 'HEAD...@{u}')-split'\s+'}catch{$null}
   ```
   with
   ```text
           $upstream=Get-GitLine $r for-each-ref --format='%(upstream)' "refs/heads/$branch"
           $ab=if($upstream){(Get-GitLine $r rev-list --left-right --count "HEAD...$upstream")-split'\s+'}else{$null}
   ```

   f) replace the lines
   ```text
           $pending=@(& git -C $r for-each-ref --format='%(refname:short) %(objectname)' 'refs/heads/orvion/*-pending' 2>$null|ForEach-Object{
               $n,$sha=$_-split' ';& git -C $r merge-base --is-ancestor $sha '@{u}' 2>$null;$gone=$LASTEXITCODE-eq0
               "$n@$($sha.Substring(0,7))$(if($gone){' (released, leftover branch)'})"})
   ```
   with
   ```text
           $pendingRows=@(& git -C $r for-each-ref --format='%(refname:short) %(objectname)' 'refs/heads/orvion/*-pending' 2>$null)
           if($LASTEXITCODE-ne0){throw 'pending refs unreadable'}
           $pending=@(foreach($pendingRow in $pendingRows){
               $n,$sha=$pendingRow-split' ';$gone=$false
               if($upstream){
                   & git -C $r merge-base --is-ancestor $sha $upstream 2>$null
                   if($LASTEXITCODE-notin0,1){throw 'pending ancestry unreadable'}
                   $gone=$LASTEXITCODE-eq0
               }
               "$n@$($sha.Substring(0,7))$(if($gone){' (released, leftover branch)'}elseif(!$upstream){' (upstream unavailable)'})"
           })
   ```

   g) replace the line
   ```text
       }catch{"repo     $name UNREADABLE ($($_.Exception.Message))"}
   ```
   with
   ```text
       }catch{$pulseUnreadable=$true;"repo     $name UNREADABLE ($($_.Exception.Message))"}
   ```

   h) replace the lines
   ```text
   # Decisions and lessons from the event log (latest record per pattern decides).
   $log=Join-Path $Root 'events\events.jsonl'
   $latest=@(if(Test-Path $log){[IO.File]::ReadAllLines($log)|Where-Object{$_}|ForEach-Object{try{$_|ConvertFrom-Json}catch{$null=$_}}|Where-Object{$_}|Group-Object pattern|ForEach-Object{@($_.Group|Sort-Object at)[-1]}})
   $waiting=@($latest|Where-Object{$_.category-eq'decision'-and$_.status-eq'open'})
   "waiting  on the owner: $($waiting.Count)"
   foreach($w in $waiting){"         - $($w.pattern): $($w.summary.Substring(0,[Math]::Min(150,$w.summary.Length)))$(if($w.summary.Length-gt150){'...'})"}
   ```
   with
   ```text
   # One journal read/classifier: inherited assignment and unreadable evidence are Coordinator-owned.
   $pulseSnapshot=$null
   try{
       $snapshotRows=@(& (Join-Path $PSScriptRoot 'Coordinator.ps1') -Root $Root -Snapshot)
       if($snapshotRows.Count-ne1-or$snapshotRows[0].Schema-ne1-or$snapshotRows[0].Readable-isnot[bool]){throw 'snapshot unavailable'}
       $pulseSnapshot=$snapshotRows[0]
       if(!$pulseSnapshot.Readable){throw 'required journal incomplete'}
       $waiting=@($pulseSnapshot.Items|Where-Object state -eq 'OWNER')
       "waiting  on the owner: $($waiting.Count)"
       foreach($w in $waiting){"         - $($w.pattern): $($w.summary.Substring(0,[Math]::Min(150,$w.summary.Length)))$(if($w.summary.Length-gt150){'...'})"}
   }catch{$pulseUnreadable=$true;'waiting  UNREADABLE (required Coordinator evidence unavailable/incomplete)'}
   ```

   i) replace the line
   ```text
   try{& (Join-Path $PSScriptRoot 'Coordinator.ps1') -Root $Root -Brief}catch{"queue    UNREADABLE ($($_.Exception.Message))"}
   ```
   with
   ```text
   if($pulseSnapshot){
       if(!$pulseSnapshot.Readable){'queue    UNREADABLE (valid partial diagnostics only)'}
       $pulseSnapshot.Brief
   }else{'queue    UNREADABLE (no valid Coordinator snapshot)'}
   ```

   j) immediately after the line
   ```text
   "tools    Coordinator.ps1 | Spider.ps1 '<anything>' (all sources) | Events.ps1 -Find '<task>' | Delegate.ps1 -List | Hunt.ps1 | sessions\INDEX.md | lib\README.md"
   ```
   insert
   ```text
   exit $(if($pulseUnreadable){2}else{0})
   ```

   The resulting file's Git blob is 63483229bc547b6ff34e5943801f873be42126fa.

6. Check whether `lib/Coordinator.ps1` contains `One derived view for reporting consumers`; if so record Already Applied when its Git blob is 7c39e5124ca6602b07329a86a95b761523f68fda, and otherwise stop and report. Otherwise make exactly these 4 edits (bounded arrival reporting and selected portable source documentation), each matched once, and change nothing else:

   a) immediately after the line
   ```text
         [Parameter(ParameterSetName='brief',Mandatory)][switch]$Brief,
   ```
   insert
   ```text
         [Parameter(ParameterSetName='snapshot',Mandatory)][switch]$Snapshot,
   ```

   b) replace the line
   ```text
       'COORDINATOR_UNREADABLE: required journal evidence is incomplete; valid partial records follow.'
   ```
   with
   ```text
       if(!$Snapshot){'COORDINATOR_UNREADABLE: required journal evidence is incomplete; valid partial records follow.'}
   ```

   c) replace the line
   ```text
   if($Brief){
   ```
   with
   ```text
   $briefLines=@(
   ```

   d) immediately after the line
   ```text
       foreach($i in @($items|Where-Object state -in 'ACTIVE','DISPATCHED'|Sort-Object last -Descending|Select-Object -First 2)){"         in flight: $($i.pattern) ($($i.owner)): $($i.action.Substring(0,[Math]::Min(260,$i.action.Length)))"}
   ```
   insert
   ```text
   )
   if($Snapshot){
       # One derived view for reporting consumers; not a state store or approval interface.
       [pscustomobject]@{Schema=1;Readable=(!$incomplete);Items=@($items);Brief=@($briefLines)}
       return
   }
   if($Brief){
       $briefLines
   ```

   The resulting file's Git blob is 7c39e5124ca6602b07329a86a95b761523f68fda.

7. Check whether `lib/test-pulse.ps1` contains `PULSE_SELFCHECK PASS`; if so record Already Applied when its Git blob is 7a8a8d324cc5b5b425242ebc63b79a66ef13bb72, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (bounded arrival reporting and selected portable source documentation), and change nothing else:

   ```text
   # Real Pulse caller on owned Git/journal fixtures. No product, real journal or credential writes.
   # An explicit library permits causal mutants; it never changes production tool selection.
   param([string]$Library=$PSScriptRoot)
   $ErrorActionPreference='Stop'
   . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   $pulseFailures=0
   $pulseCompleted=$false
   $pulsePath=Join-Path $Library 'Pulse.ps1'
   $pulseTestParent=if($env:WORKBENCH_TEST_ROOT){[IO.Path]::GetFullPath($env:WORKBENCH_TEST_ROOT)}else{Join-Path ([IO.Path]::GetTempPath()) 'ORVION-Workbench'}
   $pulseFixture=Join-Path $pulseTestParent ('pulse-'+[guid]::NewGuid().ToString('N').Substring(0,8))
   [void][IO.Directory]::CreateDirectory($pulseFixture)
   $pulseRepository=Join-Path $pulseFixture 'native'
   [void][IO.Directory]::CreateDirectory($pulseRepository)
   [void][IO.Directory]::CreateDirectory((Join-Path $pulseFixture 'events'))
   $pulseJournal=Join-Path $pulseFixture 'events/events.jsonl'
   function Assert-PulseCheck([string]$label,[bool]$condition,[string]$detail=''){
       if($condition){"PASS $label"}else{$script:pulseFailures++;"FAIL $label";if($detail){$detail}}
   }
   function Read-PulseFixtureGit([string[]]$gitArguments){
       $gitLines=@(& git -C $pulseRepository @gitArguments 2>&1)
       if($LASTEXITCODE-ne0){throw 'PULSE_FIXTURE_GIT_FAILED'}
       $gitLines
   }
   function Invoke-PulseCheck([string]$selectedRepository=$pulseRepository){
       $pulseLines=@(& pwsh -NoProfile -File $pulsePath -Root $pulseFixture -Repos $selectedRepository 2>&1)
       [pscustomobject]@{Exit=$LASTEXITCODE;Text=$pulseLines-join"`n"}
   }
   function Set-PulseFixtureEvents([object[]]$eventRows){
       $eventText=(@($eventRows|ForEach-Object{$_|ConvertTo-Json -Compress})-join"`n")
       [IO.File]::WriteAllText($pulseJournal,$eventText,[Text.UTF8Encoding]::new($false))
   }
   try{
       $null=Read-PulseFixtureGit @('init','--quiet','-b','main')
       $null=Read-PulseFixtureGit @('config','user.name','Pulse Fixture')
       $null=Read-PulseFixtureGit @('config','user.email','fixture@invalid.local')
       [IO.File]::WriteAllText((Join-Path $pulseRepository 'a.txt'),"baseline`n")
       $null=Read-PulseFixtureGit @('add','--','a.txt')
       $null=Read-PulseFixtureGit @('commit','--quiet','-m','owned Pulse fixture only')
       $pulseHead=@(Read-PulseFixtureGit @('rev-parse','HEAD'))[0]
       $null=Read-PulseFixtureGit @('remote','add','origin',$pulseRepository)
       $null=Read-PulseFixtureGit @('update-ref','refs/remotes/origin/main',$pulseHead)
       $null=Read-PulseFixtureGit @('config','branch.main.remote','origin')
       $null=Read-PulseFixtureGit @('config','branch.main.merge','refs/heads/main')
       $pulseRows=@(
           @{pattern='technical';at='2026-10-23T10:00:00Z';category='decision';status='open';owner='agent';cause='confirmed';action='implement the approved scope';summary='Technical action, not an owner choice'},
           @{pattern='commercial';at='2026-10-23T10:00:01Z';category='decision';status='open';owner='owner';cause='owner-decision';summary='Actual owner decision'},
           @{pattern='inherited';at='2026-10-23T10:00:02Z';category='decision';status='open';owner='owner';cause='owner-decision';summary='Prior explicit assignment'},
           @{pattern='inherited';at='2026-10-23T10:00:03Z';category='observation';status='open';summary='Later diagnostic without reassignment'},
           @{pattern='closed';at='2026-10-23T10:00:04Z';category='decision';status='resolved';owner='owner';summary='Resolved choice'}
       )
       Set-PulseFixtureEvents $pulseRows
       $pulseBefore=(Get-FileHash -LiteralPath $pulseJournal).Hash
       $pulseObserved=Invoke-PulseCheck
       $pulseOwnerSection=[regex]::Match($pulseObserved.Text,'(?ms)^waiting  on the owner: (?<count>[0-9]+)\r?\n(?<entries>.*?)(?=^(last|cases|queue|hunt|tools)\s|\z)')
       $pulseOwnerEntries=$pulseOwnerSection.Groups['entries'].Value
       Assert-PulseCheck 'owner list itself contains commercial and inherited only; queue matches cannot satisfy it' ($pulseObserved.Exit-eq0-and$pulseOwnerSection.Success-and$pulseOwnerSection.Groups['count'].Value-ceq'2'-and$pulseOwnerEntries-match'commercial'-and$pulseOwnerEntries-match'inherited'-and$pulseOwnerEntries-notmatch'technical') $pulseObserved.Text
       Assert-PulseCheck 'read-only observation preserves journal and Git HEAD' ((Get-FileHash -LiteralPath $pulseJournal).Hash-ceq$pulseBefore-and@(Read-PulseFixtureGit @('rev-parse','HEAD'))[0]-ceq$pulseHead)
       Set-PulseFixtureEvents @()
       $pulseObserved=Invoke-PulseCheck
       Assert-PulseCheck 'explicit empty journal and readable synchronized repository are valid' ($pulseObserved.Exit-eq0-and$pulseObserved.Text-match'waiting  on the owner: 0'-and$pulseObserved.Text-match'clean, 0 ahead / 0 behind') $pulseObserved.Text
       [IO.File]::WriteAllText($pulseJournal,'{"torn')
       $pulseObserved=Invoke-PulseCheck
       Assert-PulseCheck 'torn required journal is unreadable with nonzero exit, never zero owner waits' ($pulseObserved.Exit-eq2-and$pulseObserved.Text-match'waiting  UNREADABLE'-and$pulseObserved.Text-notmatch'waiting  on the owner: 0') $pulseObserved.Text
       [IO.File]::Delete($pulseJournal)
       $pulseObserved=Invoke-PulseCheck
       Assert-PulseCheck 'missing required journal is not an empty healthy journal' ($pulseObserved.Exit-eq2-and$pulseObserved.Text-match'waiting  UNREADABLE') $pulseObserved.Text
       Set-PulseFixtureEvents @()
       $pulseBroken=Join-Path $pulseFixture 'broken'
       [void][IO.Directory]::CreateDirectory((Join-Path $pulseBroken '.git'))
       $pulseObserved=Invoke-PulseCheck $pulseBroken
       Assert-PulseCheck 'failed Git read remains UNREADABLE and nonzero' ($pulseObserved.Exit-eq2-and$pulseObserved.Text-match'repo\s+broken UNREADABLE') $pulseObserved.Text
       $pulseObserved=Invoke-PulseCheck (Join-Path $pulseFixture 'missing')
       Assert-PulseCheck 'explicit missing repository is reported rather than silently omitted' ($pulseObserved.Exit-eq2-and$pulseObserved.Text-match'repo\s+missing UNREADABLE') $pulseObserved.Text
       [IO.File]::AppendAllText((Join-Path $pulseRepository 'a.txt'),"dirty fixture`n")
       $pulseObserved=Invoke-PulseCheck
       Assert-PulseCheck 'readable dirt stays visible without falsely claiming unreadability or permission' ($pulseObserved.Exit-eq0-and$pulseObserved.Text-match'DIRTY\(1\)') $pulseObserved.Text
       $null=Read-PulseFixtureGit @('config','--unset','branch.main.remote')
       $null=Read-PulseFixtureGit @('config','--unset','branch.main.merge')
       $pulseObserved=Invoke-PulseCheck
       Assert-PulseCheck 'genuinely unconfigured upstream remains a readable no-upstream state' ($pulseObserved.Exit-eq0-and$pulseObserved.Text-match'no upstream') $pulseObserved.Text
       $pulseCompleted=$true
   }finally{
       if($pulseCompleted-and$pulseFailures-eq0){$null=Remove-OrvionOwnedTree -Path $pulseFixture -AllowedRoots @($pulseTestParent)}
       else{"PULSE_FIXTURE_PRESERVED: $pulseFixture"}
   }
   if($pulseFailures){throw "PULSE_SELFCHECK_FAILED $pulseFailures"}
   'PULSE_SELFCHECK PASS'
   ```

   The resulting file's Git blob is 7a8a8d324cc5b5b425242ebc63b79a66ef13bb72.

8. Check whether `lib/README.md` contains `one event-journal classifier`; if so record Already Applied when its Git blob is 20414d01922827a6a39444285a1b2e889cffce0c, and otherwise stop and report. Otherwise make exactly these 2 edits (bounded arrival reporting and selected portable source documentation), each matched once, and change nothing else:

   a) replace the lines
   ```text
   | `Coordinator.ps1` / `-Brief` / `-Check` / `-Assign` / `-Close` / `-Dispatch` | one event-journal view: UNOWNED, OVERDUE, OWNER, DISPATCHED, ACTIVE; observations remain quiet. Explicit Owner=owner or Cause=owner-decision routes owner choices; technical decisions can remain ACTIVE. Incomplete/missing/unreadable journal returns UNREADABLE/exit 2 with valid partial diagnostics; mutation refuses before writes. Explicit empty journal is valid. Hunts/certifies nothing. |
   | `Pulse.ps1` | the live state any arriving agent sees first (repos, pending candidates, running, host, waiting on the owner, last session, the coordinator's queue); session start prints it |
   ```
   with
   ```text
   | `Coordinator.ps1` / `-Brief` / `-Check` / `-Snapshot` / `-Assign` / `-Close` / `-Dispatch` | one event-journal classifier: UNOWNED, OVERDUE, OWNER, DISPATCHED, ACTIVE. Snapshot returns one schema1 object with Readable, Items and the same Brief lines; an incomplete snapshot explicitly has Readable=false. Explicit Owner=owner or Cause=owner-decision routes owner choices; technical decisions can remain ACTIVE. Text consumers retain UNREADABLE/exit 2 and mutation refuses before writes. Explicit empty journal is valid. Hunts/certifies nothing. |
   | `Pulse.ps1` | arrival state from actual Git reads and one Coordinator snapshot shared by owner waits and queue. Inherited assignments stay intact; technical decisions are not owner waits. Missing/failed selected Git or journal evidence is UNREADABLE/exit 2; explicit empty journal or genuinely absent upstream is readable. DIRTY is an observation, never write authority. No fetch, test, retry or certification. |
   ```

   b) replace the line
   ```text
   | `Invoke-DraftRehearsal.ps1` | full lifecycle rehearsal of a frozen Draft in a disposable clone (push DISABLED) |
   ```
   with
   ```text
   | `Invoke-DraftRehearsal.ps1` | bounded literal/native-entry probes in a disposable clone: deliberately interrupts Finish and uses later sandbox-specific hook/worktree arrangements. Not a complete Finish/lifecycle proof; never transplant its results as original certification. |
   ```

   The resulting file's Git blob is 20414d01922827a6a39444285a1b2e889cffce0c.

9. Check whether `docs/EXECUTION-PLAN.md` contains `Source retention and remote publication`; if so record Already Applied when its Git blob is 4b6cc3ddf7e5e5e558c803a28e2731af64026945, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (bounded arrival reporting and selected portable source documentation), and change nothing else:

   ```text
   # ORVION Workbench - Remaining Execution Plan

   Version 1.4 | 2026-10-24 | Owner-requested consolidated execution sequence

   ## HANDOFF

   - INHERITED: Independent Platinum/Founder authority; completed Contracts A/B, WS001-004 and native Brief repairs. Existing P3 G2c A-H/G3/G4 and ADR-0033 remain binding.
   - PROVEN: Accepted Workbench f42c5a0, Platinum 20ea5e0 and Founder da91901 were clean at the last observation. Both native repairs have separate original Finish receipts and REMOTE_CERTIFY READY. Evidence links are below.
   - UNPROVEN: General native dispatch, integrated observer handles/partial recovery, comprehensive generated discovery, consolidated storage/factory operation and clean-Windows recovery.
   - CHANGED: This file consolidates the accepted direction and new indexing/storage requirement. It installs no source, approves no future exact Draft and moves no files.
   - REMAINING: Execute stages 0-7, applying the per-change assurance procedure to each earned implementation unit. Do not restart completed units.
   - DO NOT TOUCH: Frozen Drafts/history/evidence, unrelated work, credentials, native authority and required checks. No Batch 6/Phase 8, uncontrolled relocation/deletion, unrelated remote or production action. The separately owner-authorized private Shehabhub/ORVION-Workbench source publication is recorded below.
   - NEXT: Verify the existing WS005 isolated prototype, then implement/test the smallest selected-native admission/dispatch proposal there. Original source changes require their own frozen scope, sandbox proof and exact lawful approval.

   ## 1. Read this first: authority and continuity

   This is the owner's current remaining execution sequence. It supersedes earlier conversational sequencing, not immutable contracts or the acceptance map in [03-WORKBENCH.md](<C:\Users\My Lab\Documents\ORVION-Owner-Review\owner-workbench-handoff-20261021\runbooks\03-WORKBENCH.md>). Do not create a competing roadmap, approval registry or active-contract register.

   The architectural companion is [WORKSPACE-LAYOUT.md](WORKSPACE-LAYOUT.md): complete target code/data trees, existing tool names, unit planning/revision folders, V1/V2/V3, selected-version pointers and migration constraints. Use it when shaping new outputs. It is a target design, not installed paths, a frozen schema or permission to move accepted roots.

   The sole live programme checkpoint is [RESUME.md](<C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\20261020-wave1-v3\RESUME.md>). Workbench RESUME owns its active engineering contract; each product owns its own lifecycle. Live owner instructions win; otherwise follow the owning README/AGENTS/Boot and exact contract. Historical HANDOFF files and reports never grant a new scope.

   Accepted direction permits earned technical continuation under the recorded delegation. Every implementation still needs a concrete frozen contract, demonstrated feasibility and an exact approval with truthful human or DELEGATED provenance. This plan is not Gate 1 for future bytes. Never silently replace an approved Draft, invent authentication, or bypass owner-only/destructive/remote/system boundaries.

   Apply CAG, SACI, PICF, Mandatory Three-Pass Draft Assurance, Learn Before Guessing, Earn It / Worth It, Simplify Without Weakening, Execute Within Authority, Test Before Trust and Preserve Knowledge using their owning definitions. Do not invent policy meanings from acronyms.

   Improve this plan only when an observed gap, contradiction or relevant changed input earns it. Record the evidence, affected stage and correction briefly in section 10; update live NEXT. A new material scope uses its own contract; a new owner-only choice remains a proposal. Never rewrite frozen criteria/history or reopen completed tests without demonstrated impact.

   ## 2. Reference state: revalidate cheaply, do not replay tests

   | Subject | Last verified HEAD | Result/evidence |
   |---|---|---|
   | Workbench / ORVION-Owner-Tools | f42c5a098ca69a156e38e7ae8d9a5475c850f288 | WS004 local completion preserved; later owner-authorized private initial main publication and exact clone/Boot verified; [own result](<C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-stage-integrity-20261023-r2\runtime\original\result.json>), [publication](<C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-supervision-20261023\runtime\remote-bootstrap\result.json>) |
   | Platinum / PlatPlusHub/CRM | 20ea5e0d8f63742308efd4dc5e13ef178f0f82db | SPEC-295 Complete, published/promoted/certified; original/trusted roots matched |
   | Founder / Shehabhub/ORVION | da919011ee8b0b03cee620e910ff828b8e179f61 | SPEC-297 Complete, published/promoted/certified; original/trusted roots matched |
   | Native repair closure | Separate original receipts | [RELEASE-RESULT.json](<C:\Users\My Lab\Documents\ORVION-Owner-Review\native-brief-unreadable-20261023\RELEASE-RESULT.json>) |
   | Contract B | PT SPEC-294 / FD SPEC-296 released | [B result](<C:\Users\My Lab\Documents\ORVION-Owner-Review\contract-b-release-interface-20261021\runtime\local-source-result.json>), current ContractBRelease section |
   | WS005 readiness | Isolated implementation and corrected causal probes; no original approval | Stage1 nine-check positive and two detected mutants; 30-check Coordinator regression; old-root provisional literal replay. New-root successor required; general dispatcher not implemented |

   Original receipts: Platinum `334ef9c48d6e2284a0b234a9a7764a5e5b0fc8e8d0921b707792aa988e9be549`; Founder `d96aa363897479f151e3ea1ce71b50b19a5a00837130fa22bf09a1928b15ec41`; WS004 `C846653BDC46D68739F8A9C30990A842F66952B4E4B0CDEA072FA33353D93219`.

   Measured reference: WS004 original 20 suites/780 seconds, Finish 13:05; latest native original Finish 8:40 and 8:42 concurrently. Each native release had three preflight and two main workflows succeed on attempt 1. Different scopes are not a performance comparison. These results do not prove the unbuilt dispatcher. Current runtime facts belong in the live checkpoint, not this dated table.

   ### Source retention and remote publication

   The owner delegates the final retention design. Keep what cannot be regenerated without losing engineering knowledge, exact authority, reproducibility or safe continuation. This is a recovery-value decision, not simply a generated-versus-handwritten distinction.

   - Track reviewed code/tests/governance, actual contracts, the single selected plan/layout, safe config examples and the minimum non-secret unique assurance/decision/evidence needed to understand and resume accepted work. Dependency locks or other essential reproducibility inputs can belong in Git even when generated.
   - Exclude disposable clones/fixtures, working scratch, caches, regenerated search views, repetitive raw logs and machine-local bindings. Existing native tracked projections remain under native authority; do not alter them to enforce a Workbench packaging preference.
   - Secrets and sensitive raw archives stay outside Git, with an explicitly required protected recovery copy. Important ignored receipt/history artifacts need backup coverage or a reviewed safe evidence capsule; do not call unique past observations reproducible or assume Gitignore is backup.
   - Initial private main contains only the accepted unchanged f42c5a0 code/history. External plan/layout and the unapproved prototype are NOT included in that first push. Add important portable documents/evidence through their own exact governed source scope; do not bypass hooks with remote API commits or claim a source clone is the full recovered environment.
   - Before each publication, inspect the actual tracked subject and relevant history, exclude protected paths, review credential-shaped findings without exposing values, and verify a fresh download against the selected SHA/tree. Current initial scan covered 176 reachable blobs; nine findings were synthetic fixture inputs, no tracked sessions/events/work or credential-file paths were found. This is not a universal secret-absence guarantee.

   ## 3. Stage 0 - Recover the current unit

   1. Read this plan and the top of the sole live checkpoint; its current NEXT takes precedence over the reference snapshot.
   2. Run arrival/task tools once:

       pwsh -NoProfile -File 'C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\lib\Pulse.ps1' -Root 'C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools'
       pwsh -NoProfile -File 'C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\lib\Events.ps1' -Root 'C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools' -Find 'workbench native supervision WS005'

   3. Follow Workbench README/AGENTS/RESUME and its actual `lib/Workbench.ps1 -Boot` for its engineering lifecycle. Each selected native Boot remains required at its own boundaries; single selection does not preload/activate the peer.
   4. Check HEAD, dirt and selected source/config anchors. Existing prototype: `C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WS005\prototype`. Verify independent common Git directory, no alternates and push DISABLED against preparation.json. Do not rerun Prepare-Supervision.ps1: the destination exists.
   5. Unexpected dirt/drift stops the affected scope. Never reset/stash/discard it. Use Spider for a specific missing fact; no default whole-history scan, Doctor or Full Hunt.

   Exit: current task, authority, prototype and blocker known; no heavy test run just for arrival.

   ## 4. Stages 1-3 - Finish the management path

   ### Stage 1 - Make critical tools usable and honestly described

   - Extend existing lib/README.md, not a second inventory: purpose, real invocation, preconditions, effects, owning tests, exits and recovery for each critical-path tool.
   - Preserve proven applier/admission/lease/runner/watcher/host/journal/release/search/backup features. Do not rebuild them to improve the interface.
   - Pulse has an open independent-test gap. Its current waiting list selects every open decision event by category/status, without checking Owner/Cause; this can mislabel technical work as waiting on the owner. Prove and repair the relevant caller behavior in an owning scope, including failed repository reads and truthful partial state. Use the existing Coordinator's actual routing and native authority meanwhile. Whole-suite discovery is not proof that every tool is tested.
   - Correct the index description of Invoke-DraftRehearsal: its controlled Finish interruption and later sandbox-specific arrangements are narrower probes, not complete native Finish proof. Retain useful probes; do not use them as certification.
   - Watch-Subagents supports an explicit Claude session, not arbitrary Codex agents. Never guess a latest session. Resolve the recorded lint issue in an owning touched scope if earned; do not turn it into unrelated cleanup.

   Exit: required tools have evidence for their actual use, visible limitations and a supported next action. Do not block the prototype on unrelated cosmetic backlog.

   ### Stage 2 - WS005 selected-native prototype

   1. Work in the existing isolated clone. Extend the same Workbench entry and one small transport helper if needed. Freeze actual paths/switches only after feasibility. Do not copy native lifecycle/profile/receipt engines or add another scheduler/registry.
   2. Select explicit roots/configs, repository identity, contract, stage and exact inputs. Single never becomes dual. No folder-name/latest-packet discovery or arbitrary command-string API.
   3. Reuse Invoke-ContractStage for approve/implement/review/complete/bind, including native Boot and actual unique Git allocation binding. Add only missing transport around native Boot/Finish/Certify and existing release routes. Unsupported operations refuse explicitly.
   4. Bind actual isolated proof to relevant implementation/test/evaluator/helper inputs, environment/versions and recipe. Native implementation fingerprint alone does not bind every evaluator. Specify justified role/path/metadata differences; never exclude executable inputs to retain stale proof.
   5. Recheck admission before effects using existing per-target leases. Prove changed root/config/Draft/recipe cannot pass on an earlier check. Validate fixed operations/arguments and absolute paths; use ArgumentList for new process transport.
   6. Launch native timed Finish once at its eligible final state, with native watcher attached concurrently. Native Finish owns derived/Additional tests and receipts; do not separately schedule its child suites.
   7. Preserve native exits/refusals and independent Review/Complete/bind checks. A management result cannot replace native certification or independent review.
   8. Prove actual supported disposable native lifecycle operation. Stubs prove transport only. Do not create an original product CR just to demonstrate a launcher or attribute previous releases to new code.

   Exit: actual single-target lifecycle through the proposed entry, with positive/refusal evidence. Original installation still requires section 5.

   ### Stage 3 - Dual operation, monitoring and partial recovery

   - Use the same route with explicit independent targets, distinct common Git directories, output locations, leases and receipts. Eligible stages must actually overlap; a sequential loop does not prove concurrency.
   - Shared database/workstation/service stages require real identity/port/resource isolation; otherwise serialize or refuse. Free RAM alone is insufficient.
   - Reuse one native observer per run and one shared Watch-Host where warranted. Drain redirected stdout/stderr concurrently. Keep actual PID plus creation identity, log, observer, result and exit references in existing operation evidence.
   - Resume observes existing native state/handles first and reattaches where supported. Missing result, vanished observer or unreadable evidence cannot become READY. Never restart tests to reconstruct quiet progress.
   - Preserve independent outcomes on partial failure. Reuse a completed peer only while relevant evidence remains unchanged; retry the pending lawful operation explicitly, with bounded recovery and valid authority.
   - Keep interactive Publish/Promote confirmations and shared-console serialization. Their DONE is not REMOTE_CERTIFY READY.
   - Use three distinct disposable targets to prove explicit routing/cardinality; do not claim arbitrary future-repository compatibility.

   Exit: relevant existing P3 G2c A-H/G3 requirements evidenced: CORE, standalone products, single/dual, safe overlap, monitoring, failure isolation, recovery, authority and own governance. Smaller contracts are allowed when earned; complete each coherent unit before the next and never widen a frozen contract.

   ## 5. Per-change assurance and original installation

   Apply this procedure to every implementation unit; it is not an extra workflow:

   1. V1 Design: exact scope, literal replay, commands/effects, acceptance and recovery feasibility in isolation.
   2. V2 Adversarial Review: actual caller negatives and positive controls; preserve findings/corrections, not merely renamed copies.
   3. V3 Evidence Refresh: relevant current primary evidence only, reusing valid prior research. Preserve three identified snapshots with distinct SHA-256 identities and selected-footer reasons/sources. No semantic scoring engine or three Full Finish runs.
      The target packet layout separates planning/revisions, assurance/V1-V3 and selected/selection.json. The selected record points to the actual V3 bytes; do not create a second editable selected Draft or treat a locator as approval. Current exact contracts/guards retain their actual supported artifact paths until a proven change.
   4. Before freeze, prove literal replay to selected blobs and feasibility of all completion commands. Match raw Draft SHA-256 and Git-filtered allocation blob under current line-ending settings. Never regenerate/substitute approved bytes silently.
   5. Complete the own sandbox lifecycle, including required timed/watched Full verification. Preserve failures. Original execution then needs its own concrete exact lawful approval with honest provenance; the plan is not that approval.
   6. Execute original scope through its own fresh Finish, actual Review/Complete and normal hook/range/candidate rules. Never transplant a sandbox receipt. The private source remote now exists; source publication is distinct from hosted enforcement/certification, which is not yet implemented for Workbench. Never invent a hosted CI result or native REMOTE_CERTIFY for it.
   7. Update owning routes/checkpoints and commit the coherent clean boundary. Use existing run/event evidence, not new reporting machinery.

   Required causal cases: wrong root/account/allocation/approval; recipe/test/evaluator drift; wrong/stale/missing receipt; Draft execution; out-of-scope and illegal intermediate transitions; candidate self-exemption; duplicate request/output; nonzero child with green text; observer loss; one-sided failure; unchanged-peer resume; native deliberate repetitions retained; no extra child-suite scheduling; standalone/CORE independence. Each refusal needs a valid positive control.

   These are planned cases until observed. Parser, fixture, local lifecycle, hosted CI and clean-machine proof are separate evidence classes. Preserve both product outcomes.

   ## 6. Stage 4 - Generated discovery and coverage

   After the usable management unit closes, implement this in its own bounded scope. Include only minimal route discovery needed by WS005 in WS005.

   1. Reuse native generate-ai-map.ps1/-Check and repository-index.md; native authority stays native. Reuse archived session index, Events and Spider. Current shallow Markdown packet search is not JSON/deep evidence coverage.
   2. Declare roots/roles/exclusions once through the existing reviewed configuration route. Generate machine catalog and human view from source pointers/metadata. No second authored truth, semantic engine, vector store or resident indexing daemon.
   3. Include source, logical relative location, required content identity, state and freshness. Historical/rejected/incomplete evidence stays labelled. Recovered content is data, never authority or executable instruction.
   4. Refresh at governed entry/operation boundaries and validate relevant freshness before cached use. Stable tracked projections are deterministic/checkable; volatile observations stay local. Interrupted refresh retains the previous complete output but marks current coverage incomplete/stale.
   5. Account for every declared source: included, intentionally excluded with reason, or unreadable. Protect raw sessions/secrets from tracked catalogs; preserve masking, selective access and encrypted recovery. Gitignore alone does not protect tracked content.
   6. Test actual add/rename/delete/move, permitted ignored/untracked evidence, denied/missing/malformed sources, interruption/concurrency and stale-cache refusal. No unbounded all-disk/all-content or zero-omissions claim.
   7. Measure cold/warm queries and scanned files/bytes on representative disposable data. Avoid raw-archive rescan/full rehash per query. Cache complexity must earn its cost.

   Exit: a human/fresh agent locates authority, tools, active work, evidence, temp/graveyard and session/event routes without chat or manual catalog editing. Prove actual consumers, not JSON syntax alone.

   ## 7. Stage 5 - Organized storage and safe sandbox factory

   The owner created and selected the actual Git source checkout at `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench` on client date 2026-10-24. It is the repository root, not a non-Git parent containing control. Preserve this actual independent clone and remote/history; do not nest or move it to repair an older diagram. [WORKSPACE-LAYOUT.md](WORKSPACE-LAYOUT.md) owns the reconciled source/data layout.

   The checker still rejects Sandbox/Tests/Temp/Runtime overlap with the authoritative checkout. Keep managed operational data external. Until a tested stage5 cutover, use existing declared external packet/factory roots and the one old ORVION-Owner-Tools event/session store. A future consolidated `GitHub/ORVION-Workbench-Data` sibling is a target, not created or installed by this plan. This deliberate external data boundary preserves isolation; ignored folders are not an exemption.

   The new source clone has no old working receipt or history journal. Configure its existing local `.githooks` adapter and verify actual admission before engineering commits. Preserve archived receipts with origin/hash checks only if a historical range needs them; never import an old working receipt as current certification. Correct the owning source RESUME route in the same bounded readiness scope. The current source-only Boot READY proves routing/admission, not full environment recovery.

   1. Inventory actual path consumers/defaults/configs, active jobs and backup/restore coverage. Include tools deriving sibling roots from their script location. One changed variable does not prove relocation.
   2. Freeze final names/logical mapping after isolated proof. Use relative paths within roots and explicit bindings between roots. No guessed discovery or junction aliases to hide unresolved consumers.
   3. Rehearse copy/hash/ref/config verification, mapped operation and fresh-destination restore. Preserve sealed historical absolute-path bytes; use explicit provenance/location mapping rather than rewriting history.
   4. Under bounded migration approval: copy/verify, cut over consumers, prove operation and retain recoverable old copy. Retirement/deletion is separately authorized. Active runs/unknown dependencies stop unsafe migration.
   5. Route managed creation to validated per-operation directories. Test outside-root, reparse/junction, ancestor/sibling escape, collisions, concurrency and interruption. No uncontrolled system-temp fallback in the managed workflow.
   6. Retention stays observe-only until separately proven/approved: managed Temp older than 15 days without verified activity is only a quarantine candidate. G1 precedes relocation; G2 deletion requires more than 30 ADDITIONAL days from verified quarantineUtc plus renewed content/dependency/hold/path checks and its own approval. Preserve unknown/active/required evidence. Age/LastAccessTime/old PID alone are insufficient.
   7. Reuse the directive's 20 retention adversarial cases plus positive controls before live destructive activation. Safe cleanup deferral allows lawful sandbox entry. Automatic purge is not an invented Batch 6 prerequisite.

   Exit: organized managed roots, tested routing and backup/restore coverage, evidence preserved. No claimed disk saving without measured approved deletion; no automatic remote creation.

   ## 8. Stages 6-7 - Recovery and programme closure

   Stage 6 follows existing P4/Contract C. Doctor precedes an approved Prepare action; verify required actual capabilities/setup idempotence. Reuse Backup-Workspace/Restore-Workspace and extend only newly owned state. Prove encrypted backup to clean supported machine/Windows Sandbox, restored identities/refs/config/receipts/paths, and correct independent native/Workbench cold starts. Simulated restore is not clean-Windows proof. Credentials remain external and use their owning authentication routes; do not improvise encryption/system changes or overwrite a restore target.

   Stage 7 reconciles ADR-0033 and Workbench HANDOFF section 12: A/B/C released with native certificates in both products; clean-machine encrypted recovery; written C closure; independent README/Boot continuity; Shared Evidence earned or owner-waived; CTRL-19 owner disposition. Do not replace these conditions with a reduced checklist.

   The owner authorized the private Workbench remote and unchanged initial main was published/download-verified. Hosted protection/actor/bypass enforcement remains unproven and requires its own earned CI capability; source publication does not close CTRL-19. Local hashes/hooks cannot prevent arbitrary filesystem writes by an equal-privilege OS actor.

   Only after applicable conditions are proven AND the owner lifts the hold may Batch 6/Phase 8 start under their own native scopes. Neither this plan nor WS005 lifts that hold. General N-repository support, GUI, generalized learning/search systems, automated purge and speculative speed tuning remain later work with explicit triggers; required independence, supported dual operation, authority and recovery are not deferred.

   ## 9. Execution and interruption discipline

   - One current unit, one native verification schedule per eligible final state. Never rerun completed expensive tests to reassure a new agent or demonstrate overlap. Mandatory distinct sandbox/original/trust-stage checks remain.
   - Long-gate routine owner heartbeat: at most every five minutes, consolidated. Do not mirror unchanged watcher output. Actual receipts, new/changed blockers, missing required evidence, lost run/observer, nonzero termination and material pressure/stall transitions require prompt handling. Silence is not success.
   - Failure: preserve state/logs; use existing bounded recovery with at most three distinct hypotheses/attempts and relevant refreshed evidence. No blind retry, automatic cancellation, guard weakening, history rewrite, silent test substitution or false completion.
   - Before stopping, persist stage, approved scope/digests, exact heads, live owned handles/log/result references, proven results, blocker and precise NEXT in the sole checkpoint. Native CR/Git checkpoints remain native-owned. Do not depend on chat or this dated plan snapshot.
   - English files; Arabic owner communication. Preserve historical checkpoint tail, sealed plans/Drafts and raw archives. Do not write user memory files for this task.

   ## 10. Change record and sources

   - 2026-10-24 / v1.4: the owner independently cloned f42c5a0 directly at the selected ORVION-Workbench Git root. Verified clean identity, own common Git directory, no alternates, normal accepted hook admission. Reconcile the older control/data-parent diagram without moving the clone or weakening isolation. Keep old data/history untouched. Preserve the old-root provisional readiness bundle and build a new-root identified successor; it has no inherited approval.

   - 2026-10-24 / v1.3: recorded the owner-authorized private source remote, verified initial clone/Boot and explicit limits; refined retention by recovery value. Important external plans/evidence still need their governed source inclusion; initial publication is not full recovery or prototype installation.
   - 2026-10-23 / v1.2: recorded the owner's exact GitHub/ORVION-Workbench destination, retained code/data isolation and required path-compatibility proof before physical cutover. Stage 1 Pulse/Coordinator changes currently have focused prototype evidence only, not an installed or certified original result.
   - 2026-10-23 / v1.1: integrated the owner-requested complete WORKSPACE-LAYOUT.md companion. Defined code/data ownership, retained lib names, plan revisions, three-pass/selected artifact placement and incremental adoption; no relocation or new source interface claimed.
   - 2026-10-23 / v1: consolidated accepted readiness, generated-discovery and organized-root direction. Preserved P3 acceptance, current WS005 NEXT, exact approval and original C/Batch 6 closure conditions. Added the source-observed Pulse owner-wait routing gap to its existing readiness scope. No source implementation, migration or new test result claimed.

   Use local authorities/evidence first. Already reviewed narrow official sources; refresh only when a materially changed decision requires it:

   - [OWASP authorization](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html) and [agent security](https://cheatsheetseries.owasp.org/cheatsheets/AI_Agent_Security_Cheat_Sheet.html): scoped tools and checks at execution, untrusted recovered data; not equal-OS isolation.
   - [SLSA 1.2 verification](https://slsa.dev/spec/v1.2/verifying-artifacts): expected source/subject/parameters; no compliance claim.
   - [Microsoft arguments](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.processstartinfo.argumentlist?view=net-10.0), [streams](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.processstartinfo.redirectstandarderror?view=net-10.0), [FileSystemWatcher](https://learn.microsoft.com/en-us/dotnet/api/system.io.filesystemwatcher?view=net-10.0): installed-runtime APIs, deadlock prevention, notification-loss limits.
   - [Git ignore](https://git-scm.com/docs/gitignore) and [inventory](https://git-scm.com/docs/git-ls-files): tracked/untracked/excluded distinctions.
   - [GitHub rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets): actual active enforcement and bypass roles, not local assertions.


   Canonical routing: proposed source document until this exact own scope completes. Then select the installed source docs in the sole programme checkpoint; external prior revisions remain history, never a second manually synchronized authority.
   ```

   The resulting file's Git blob is 4b6cc3ddf7e5e5e558c803a28e2731af64026945.

10. Check whether `docs/WORKSPACE-LAYOUT.md` contains `Owner-selected source repository:`; if so record Already Applied when its Git blob is adf96fb741322bed166c2ffd65ef8d867477c1bb, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (bounded arrival reporting and selected portable source documentation), and change nothing else:

   ```text
   # ORVION-Workbench - Target Workspace and Repository Layout

   Version 1.3 | 2026-10-24 | Owner-created source root reconciled; data cutover remains pending

   ## HANDOFF

   - INHERITED: [EXECUTION-PLAN.md](EXECUTION-PLAN.md), existing independent product governance and the accepted Workbench checker/tool library.
   - PROVEN: Current library names, contract template, native map generator and root-isolation rules were inspected. The owner-created source clone is at GitHub/ORVION-Workbench; old local data and external packets/sandboxes remain in place.
   - UNPROVEN: Physical relocation, new configuration/catalog interfaces, proposed packet layout enforcement and future tools. A directory diagram does not implement a guard or prove recovery.
   - CHANGED: This document gives full target names, evidence placement, selection semantics, ownership and migration rules. No directory creation/move, source installation or exact implementation approval is implied.
   - REMAINING: Introduce each required surface through its owning plan stage and frozen scope; prove consumers and recovery before cutover.
   - DO NOT TOUCH: Accepted paths during active operations; frozen Drafts/history; original receipts/refs/configurations; raw archives/secrets. No nested product repositories, shared-Git sandbox shortcut or automatic deletion.
   - NEXT: Continue the existing WS005 isolated prototype. Use this layout to prevent new scattering; apply only the small part actually required by its approved scope. Storage migration remains stage 5.

   ## 1. Actual source root and external operational boundary

   Owner-selected source repository: `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench`.

   The owner independently cloned the private Shehabhub/ORVION-Workbench repo here and authorized work in it on client date 2026-10-24. Observed HEAD f42c5a098ca69a156e38e7ae8d9a5475c850f288, clean independent Git directory, no alternates, own Boot READY. The existing `.githooks` adapter was enabled in local config and actual admission passed. This is source admission only, not a fresh Finish or recovered local data.

   The earlier non-Git parent/control/data topology is superseded by this actual source placement. Do not move/nest the owner clone, recreate its history or weaken the checker to put sandboxes/tests/temp/runtime under it. Source stays at the exact requested path. Existing packets/factory and the one old ORVION-Owner-Tools journal/archive remain external and unchanged until tested cutover. A future consolidated `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-Data` sibling groups those operational roles; that target is not created or installed yet. No guessed aliases, parallel live journal or blank replacement history.

   Keep the current Git repository/history, `lib` and existing command names. Preserve the old clone/data until dependencies, active archiver and recovery are proven. Git metadata and engine-owned ignored receipts stay local at their actual owning source root. Historical root-bound evidence remains history; it does not certify this new checkout.

   Legend: EXISTING means an actual current file/name, not proof it already occupies this target path. PROPOSED means a new surface that still needs its owning contract. CONDITIONAL means create only when its actual implementation is earned. Examples such as WS005/run-001 are identifiers, not instructions to allocate a contract or create all folders now.

   ## 2. Full control repository tree

       ORVION-Workbench/                                 [actual independent Git source root]
       |-- .git/                                    [local Git metadata; never copied into tracked payload]
       |-- .gitattributes                           [EXISTING]
       |-- .gitignore                               [EXISTING; not a security boundary]
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
       |   `-- WS-004-native-stage-integrity.md      [EXISTING; later contracts use actual allocation]
       |-- docs/                                    [PROPOSED selected durable documentation only]
       |   |-- EXECUTION-PLAN.md                     [future single live plan location after cutover]
       |   `-- WORKSPACE-LAYOUT.md                   [future location of this architecture]
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
       |   `-- test-pulse.ps1                        [PROPOSED owning test for the recorded gap]
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

   Encrypted recovery copies belong on their actual approved backup medium outside the sole working disk. They are not replaced by data/evidence or a Git push. Store recovery proof/pointers under its owning unit; never copy credentials into a local recovery folder. External Windows tools/authentication and installed services are dependencies to diagnose, not directories copied into this repo.

   The owner-authorized private remote is https://github.com/Shehabhub/ORVION-Workbench; accepted f42c5a0 main was published and downloaded with matching tree and read-only Boot. Important external plan/layout artifacts are not part of that initial push yet. Their future canonical ORVION-Workbench/docs placement requires the owning source contract and a single-live-location cutover.

   Track the minimum safe material whose loss would remove knowledge, exact authority, reproducibility or the ability to resume: source/tests/governance, actual contracts, selected plans, safe templates and selected non-secret assurance/decision evidence. A generated dependency lock can be essential; a handwritten scratch note can be disposable. Normally regenerate local maps/search views, caches, scratch, clones and repetitive raw logs. Generated local projection policy does not change native repositories' required tracked maps.

   .git metadata, working receipt archives, machine bindings, raw sessions/events, local catalogs, runtime, prototypes and graveyard are not ordinary source payload. Required unique ignored evidence must have proven protected backup or an explicitly reviewed safe evidence capsule, not be silently dropped. Never put secrets/raw sensitive sessions into Git merely to achieve one physical storage location. Existing exact artifact files stay unchanged; any curated safe export is labelled as such and never substituted for its original approval/receipt. No new duplicate approval registry is introduced.

   This layout does not implement hosted enforcement or authorize unrelated remotes. Verify the actual tracked publication subject and a fresh download; a source clone is not complete workstation recovery.

   ### Existing locations to account for at migration

   | Current location | Target treatment; not a move command |
   |---|---|
   | Documents/GitHub/ORVION-Workbench | actual selected source clone, same accepted history and private origin; keep this Git root |
   | Documents/GitHub/ORVION-Owner-Tools | preserved old clone and the one current sessions/events/work store; route explicitly until tested migration, no parallel live journal |
   | Documents/ORVION-Owner-Review | current selected plan/layout eventually enter ORVION-Workbench/docs; live packets are mapped explicitly; required sealed old bundles may retain their structure under data/legacy/ORVION-Owner-Review |
   | Documents/ORVION-Sandbox | map live sandbox/runtime/test/checkpoint material by actual role; required historical bundles may use data/legacy/ORVION-Sandbox; do not sweep the directory wholesale |
   | Documents/ORVION-Owner-Tools | identify old external release scripts/evidence versus replaced copies; preserve required history under data/legacy/ORVION-Owner-Tools; no second active lib |
   | Documents/ORVION-drafts-backup | inventory required provenance under data/legacy/ORVION-drafts-backup; never treat these copies as current selected authority |
   | Native original/trusted roots, installed tools, credential stores, encrypted USB | explicit external dependencies; not nested inside control and not absorbed by this diagram |

   The mapping must record what remains, is copied, becomes active, stays historical or is separately proposed for retirement. No source folder is disposable merely because this table names a destination.

   ## 6. Adoption order and architectural checks

   1. Plan stages 1-3: preserve lib names, actual selected root/operation handling, exact assurance pointers and native independence. Create WS005 prototype outputs only in its existing declared external roots until its contract says otherwise.
   2. Stage 4: introduce derived control map and local federated catalog through actual consumers. Correct the incomplete Spider coverage without unbounded disk/archive crawling. Prove missing/stale/read failures and actual fresh-agent discovery.
   3. Stage 5: inventory/copy/hash/consumer-cutover/restore proof before consolidating external data. Preserve the actual new source clone. Prove parent-derived defaults, hooks, process working directories, recipe/approval root bindings, active processes, backup and session paths. Do not rewrite frozen historical absolute paths; preserve source-to-new-location mapping.
   4. Moving original roots changes exact authority inputs. Existing frozen root-bound approvals cannot be silently reused. Select a quiescent boundary and approved migration/successor route; do not move during Finish or ongoing archiving without its proven controlled cutover.
   5. Check the deepest actual generated Windows fixture/revision/path probe against the installed toolchain. The existing checker has a concrete 260-character refusal. Prefer short unit/run identifiers and data/tests; do not change registry settings or weaken the guard to fit a diagram.
   6. Retain the sole current live checkpoint and selected execution plan until a proven cutover to their future locations. At cutover establish one live location plus explicit historical provenance; never maintain two manually synchronized live plans.
   7. Plan stage 6 proves encrypted clean-machine recovery of the selected real layout. Stage 7 retains ADR-0033 closure and the owner-held Batch 6 decision.

   Acceptance attacks: outside-root creation; junction/sibling/ancestor escape; duplicate common Git/output roots; unknown/ignored evidence omitted; stale/partial index displayed as complete; changed selected bytes; pointer falsely treated as approval; raw secret in generated tracked view; frozen metadata rewritten during migration; old path consumer still writing elsewhere; missing archive source deleting a retained session from index; interrupted copy/refresh/quarantine; required evidence offered to purge; clean restore unable to run an actual entry.

   This diagram does not require every proposed file/folder now. Create only earned implemented surfaces. No generic framework, new resident watcher, semantic index, scheduler or extra governance engine is authorized by naming folders. This remains the smallest compatible evolution of the current tools.

   ## 7. Source basis and change record

   - Existing control README/AGENTS/RESUME/WORKFLOW, changes/TEMPLATE.md, lib/README.md and Test-WorkbenchChange root/assurance checks; actual library inventory on 2026-10-23.
   - Existing native scripts/generate-ai-map.ps1: deterministic source-derived projections and non-writing freshness check.
   - Existing Events lessons: repository independence, nested sandbox hazards and archive-derived session indexing.
   - [Git repository layout](https://git-scm.com/docs/gitrepository-layout): actual Git metadata/common-directory boundaries; not a mandate for these application folder names.
   - [Microsoft path limits](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation): runtime/API-specific limits, not a universal long-path guarantee.
   - 2026-10-24 / v1.2: retention is based on recovery/authority value rather than whether a file is generated; local derived maps normally stay ignored. Recorded the verified private initial source remote and the still-pending inclusion of important external documents/evidence. No physical cutover or prototype installation claimed.
   - 2026-10-23 / v1.1: owner selected Documents/GitHub/ORVION-Workbench as the exact common parent. Added the existing nested hooks/fixtures library files found during recursive path-consumer inspection. Current operational roots remain unchanged pending proof.
   - 2026-10-23 / v1: owner requested a concrete complete layout, including tools, plan drafts/improvements, assurance snapshots and selection. Added this architectural companion without relocating source/data or changing current exact contracts.

   Canonical routing: proposed source document until this exact own scope completes. Then select the installed source docs in the sole programme checkpoint; external prior revisions remain history, never a second manually synchronized authority.
   ```

   The resulting file's Git blob is adf96fb741322bed166c2ffd65ef8d867477c1bb.

## Acceptance Criteria

- [ ] All10 literal outputs match their declared blobs, including new caller test and selected docs; no native engine or event classifier is duplicated.
- [ ] RESUME routes to selected source and the ONE preserved external event/session data store; check: normalized-resume:RESUME.md=1F392B6A18CC44442BCABE3E23BF82571975C585E8C70496881136170FECE520
- [ ] Pulse owner waits and queue consume the same Coordinator snapshot; inherited owner assignment survives and category alone cannot classify an owner decision.
- [ ] Required unreadable journal/Git/missing selected root is visible and exits2; readable empty journal, actual dirty tree and genuinely unconfigured upstream keep their true meanings without granting permission.
- [ ] Actual owning positives and causal mutants prove both allowed/refused behavior; the owner-list test cannot be satisfied by a queue match. Existing Coordinator CLI/mutation/incomplete-evidence tests remain valid.
- [ ] Before Complete, verify exact installed plan/layout bytes, selected identity, README routes and canonical-cutover readiness against the bounded readiness record. The existing external plan remains selected; no activation is claimed. The separately authorized post-Complete operation below owns actual activation and single-live-location verification.
- [ ] Source-retention guidance distinguishes recovery/authority value from mere generation, keeps essential reproducibility inputs and protects unique sensitive evidence externally; derived local maps are ignored without changing native map authority.
- [ ] The rehearsal index identifies its actual interrupted/narrow proof class; no partial rehearsal, source clone, reporter exit or local hook is presented as full native/recovery/hosted/equal-OS proof.
- [ ] This execution role has its own fresh timed/watched derived full verification and reviewed matching receipt; original role additionally binds the exact successful sandbox proof before original execution. No receipt transplant or unrelated native test replay.

## Review Gate

- [ ] Inspect actual role/root, ten blobs, normalized routing, all required suites and final runner/watcher/host exits; original also matches selected sandbox recipe/fingerprint and approval.
- [ ] Independently inspect normal-hook carrying transitions, real positive/mutant evidence, source-retention and pre-Complete route readiness; preserve failures/history and native original independence. Final accepted whole-range judgment remains required after the Complete commit; actual canonical activation remains a separately observed post-Complete effect.
- [ ] Keep generic native management, relocation/indexing/recovery/hosted protection and Batch6 hold explicitly open; no future result claimed.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Preparation only. Append actual exact selected approval/root. Original approval also binds the immutable successful sandbox receipt artifact and SHA256. Plan direction is not exact future approval; delegated provenance must remain honest.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-supervision-20261023\readiness-r4\assurance\V3\DRAFT.md
Approved SHA256: 7AC4438B92ADC9C16707EDAD1DAD10F0AA1DBE9D77ECB0DCDF6E73FC2A374290
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-supervision-20261023\runtime\readiness-r4\original\approval-binding.txt
Owner Evidence SHA256: B433A3BD6C2DC502D46C7476EF2693B95A86B69CD1206218313C6FD8214E0593
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-native-supervision-20261023\runtime\readiness-r4\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 1B88E785D36CE373323AAFC68CA3CDF65FB686EA4491D43C2201364DDF075FC6

## Verification Notes

No original implementation or Review yet. Append observed Verdict: Confirmed Complete, Reviewed Fingerprint and Reviewed Receipt only after actual role-specific evidence.

## Notes

Select V3 because real caller counterexamples and corrected causal mutants support a small existing-classifier repair; source docs preserve the accepted plan/layout while source-only clone limits stay explicit. V1 design is recorded after initial feasibility probes, not backdated. V2 retains the escaped-mutant failure. New source-root topology, routing and docs replace the unapproved old-root proposal only through this identified successor. Source changes remain provisional until literal replay/freeze; exact original approval follows actual sandbox success. Three passes are identified snapshots, not three Full Finish runs. No self-hash is placed in V3. Sources refreshed/reused 2026-10-23: actual accepted own code/template and named evidence; OWASP authorization https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html and AI agent security https://cheatsheetseries.owasp.org/cheatsheets/AI_Agent_Security_Cheat_Sheet.html (execution-boundary checks and scoped tools); SLSA1.2 https://slsa.dev/spec/v1.2/verifying-artifacts (subject/parameter expectations, no compliance claim); Git https://git-scm.com/docs/gitignore (tracked versus ignored); npm https://docs.npmjs.com/cli/v11/configuring-npm/package-lock-json/ (an essential generated reproducibility input may be retained, no npm dependency introduced); Microsoft https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation (actual path probing, no registry change). Reject a second classifier, new daemon/scheduler, copied native engines, wholesale path replacement and the rule that all generated files are disposable.

## Post-Complete Canonical Cutover

This obligation is not a pre-Complete acceptance checkbox and cannot be claimed in advance. After the actual clean Complete commit, fresh own receipt, live Review and accepted whole-range result, the explicit role-bound task adapter may replace only CURRENT EXECUTION PLAN in the sole checkpoint and append one actual cutover provenance line. Original activation additionally requires exact original approval and its separate original receipt; sandbox uses a disposable checkpoint copy only. Verify exactly one selected plan/layout route, expected doc blobs, unchanged historical tail and the prior-content backup. Preserve the external plan/layout files byte-identically as history after actual activation. Interruption requires observing actual source/checkpoint/evidence before resuming; exact already-applied selection is idempotent. A missing result is not proof of no side effect. Do not rerun Finish for a reporting interruption.

## Corrective Selection Evidence

Select R4 V3 for the smallest explicit ordering correction. All ten payload blobs and output SHA256 values equal frozen R3; no implementation/test/evaluator/profile/recipe engine is changed. R3 Draft and successful sandbox receipt remain historical evidence, not approval or a receipt for this different Draft. Preserve plan v1.4/layoutv1.3 contents, all stages, P3/P4/retention/recovery/independence and owner holds. The existing exact-Draft receipt requirement justifies one new sandbox Full Finish, not repeated source probes or three Full runs. Targeted primary refresh on 2026-10-23: Microsoft File.Replace https://learn.microsoft.com/en-us/dotnet/api/system.io.file.replace and FileStream.Flush(Boolean) https://learn.microsoft.com/en-us/dotnet/api/system.io.filestream.flush support same-directory staged replacement/backup and explicit flush; this is not a power-loss or hostile-writer guarantee. Git hooks https://git-scm.com/docs/githooks preserve normal native admission, with known equal-OS bypass limits. Reject a new engine/registry, frozen mutation and future-condition checkmarks. Existing source behavioral evidence and earlier primary research are reused on identical inputs.
