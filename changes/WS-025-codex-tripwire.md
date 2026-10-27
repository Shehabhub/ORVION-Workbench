# Workbench Change Request - WS-025

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Close the last known defect and the Codex-escape gap before Batch 6: Hunt's archive-prefix invariant checks only append-only *.jsonl transcripts (edited memory/meta files are set aside by Copy-Grown, not rewritten history); lib\Delegate.ps1 -CodexBrief/-Clone is the one Codex launcher: a fresh relay session in a clone under temporary\cx, TEMP/TMP in its own scratch, effort at most xhigh (the owner ceiling), and an outside-agent tripwire that compares the watched places (system drive, profile and GitHub folder top level, every sibling git checkout with dirty-file content) before and after and records a failure event with exit 4 on any change; -ReadRoots narrows a brief's file and git read authority. WORKFLOW and lib/README name the launcher.

## Baseline

77eff5d5f1f470ff5c502da4e2f6ced33cbf1b04

## Write Scope

- RESUME.md
- lib/Delegate.ps1
- lib/Hunt.ps1
- lib/README.md
- lib/test-delegate.ps1
- lib/test-hunt.ps1
- WORKFLOW.md

## Out of Scope

All other engineering paths except native allocation/status/pointer bookkeeping. No checker (Test-WorkbenchChange.ps1), applier, workflow file, GitHub setting, user setting, Codex configuration or product repository change. No new suite or script: the schedule stays exactly the baseline's. The tripwire is not confinement (nested edits outside watched places and create-then-delete are beyond it). No data migration; stale archived memory copies are handled as data, not code. CTRL-19 stays OPEN; Batch 6/Phase 8 stay ON HOLD until the owner's lift record.

## Draft Assurance

V1: WS025-CODEX-TRIPWIRE-DESIGN | 2026-10-27 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-025\package\assurance\V1\DRAFT.md | 6A377F1238B9FEC15EC3E99A2CAAD573CBB959D5398DF880544316671DD20A79
V2: WS025-CODEX-TRIPWIRE-ADVERSARIAL | 2026-10-27 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-025\package\assurance\V2\DRAFT.md | A679DAF1D136F8B094A3B1587B1783CF90AA292EEAADC80068A5689360DD0AD9
V3: WS025-CODEX-TRIPWIRE-REFRESH | 2026-10-27 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-025\package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W25
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W25\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W25\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-025\package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/Delegate.ps1` contains `#   Delegate.ps1 -CodexBrief <brief> -Clone <temporary\cx\...> [-Effort medium] [-Model gpt-6.1-sol]`; if so record Already Applied when its Git blob is b57d74d74511c6df1627aa90c22cba807b44d563, and otherwise stop and report. Otherwise make exactly these 7 edits (Codex tripwire and Hunt transcript invariant only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   #   Delegate.ps1 -List   every delegation, newest first, with its verdict once REPORT.md exists
   ```
   insert
   ```text
   #   Delegate.ps1 -CodexBrief <brief> -Clone <temporary\cx\...> [-Effort medium] [-Model gpt-6.1-sol]
   #       runs one fresh Codex relay session in a clone under temporary\cx with TEMP/TMP in its own scratch folder, and
   #       compares the watched places before and after (exit 4 + a failure event on any change or unreadable snapshot)
   ```

   b) replace the line
   ```text
   # Owner-Review edit. The verdict is evidence for the delegating agent to verify, not a decision.
   ```
   with
   ```text
   # Owner-Review edit. The verdict is evidence for the delegating agent to verify, not a decision. -ReadRoots narrows the
   # brief's read authority to the task; that is guidance to the delegate, not OS enforcement.
   ```

   c) immediately after the line
   ```text
         [Parameter(ParameterSetName='brief')][int]$Minutes=30,
   ```
   insert
   ```text
         [Parameter(ParameterSetName='brief')][string[]]$ReadRoots,
         [Parameter(ParameterSetName='codex',Mandatory)][string]$CodexBrief,
         [Parameter(ParameterSetName='codex',Mandatory)][string]$Clone,
         [Parameter(ParameterSetName='codex')][ValidateSet('low','medium','high','xhigh')][string]$Effort='medium',  # owner ceiling: xhigh, never max
         [Parameter(ParameterSetName='codex')][ValidateSet('gpt-6.1-sol','gpt-6.1-terra')][string]$Model='gpt-6.1-sol',
         [Parameter(ParameterSetName='codex')][ValidateRange(1,120)][int]$TimeoutMinutes=20,
         [Parameter(ParameterSetName='codex')][string]$Relay,
         [Parameter(ParameterSetName='codex')][string[]]$Watch,
   ```

   d) immediately after the lines
   ```text
   $base=Join-Path $Root 'work\delegations';$ev=Join-Path $PSScriptRoot 'Events.ps1'

   ```
   insert
   ```text
   if($CodexBrief){
       # Codex runs unrestricted (owner decision: its Windows sandbox is blocked), so this launcher, not the brief, checks
       # what changed outside the clone and scratch. A tripwire, not confinement: it sees new or removed entries in watched
       # folders and any change to a watched git checkout (dirty file content included), not nested edits elsewhere or
       # create-then-delete.
       $briefFile=(Resolve-Path -LiteralPath $CodexBrief).Path;$cloneDir=(Resolve-Path -LiteralPath $Clone).Path
       $cxRoot=Join-Path $temporaryRoot 'cx'
       if(!$cloneDir.StartsWith("$cxRoot\",[StringComparison]::OrdinalIgnoreCase)-or!(Test-Path -LiteralPath (Join-Path $cloneDir '.git'))){throw "CODEX_CLONE_REFUSED: $cloneDir is not a git clone under $cxRoot"}
       if(!$Relay){$Relay=Join-Path $Root 'records\delegation-20261026\delegate-review\codex-delegate@3aa72d6\scripts\relay.mjs'}
       if(!(Test-Path -LiteralPath $Relay -PathType Leaf)){throw "CODEX_RELAY_MISSING: $Relay"}
       $run="$([DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))-$([IO.Path]::GetFileNameWithoutExtension($briefFile))"
       $scratch=Join-Path $temporaryRoot "scratch\$run";$logs=Join-Path $temporaryRoot "codex-relay-logs\$run";[void][IO.Directory]::CreateDirectory($scratch)
       # the temporary root always sits beside the checkouts, wherever this script runs from
       if(!$Watch){$gitHub=Split-Path $temporaryRoot -Parent;$Watch=@("$env:SystemDrive\",$env:USERPROFILE,$gitHub)+@(Get-ChildItem -LiteralPath $gitHub -Directory|Where-Object{Test-Path -LiteralPath (Join-Path $_.FullName '.git')}|ForEach-Object FullName)}
       function Get-CodexWorld{foreach($place in $Watch){
           if(Test-Path -LiteralPath (Join-Path $place '.git')){
               $head=@(& git -C $place rev-parse HEAD 2>$null);$headCode=$LASTEXITCODE;$state=@(& git -C $place status --porcelain --untracked-files=all 2>$null)
               if($headCode-or$LASTEXITCODE){throw "CODEX_WATCH_UNREADABLE: $place"};"$place|git|$head"
               foreach($line in $state){$file=Join-Path $place $line.Substring(3).Trim('"')  # status names the path; the hash sees a rewrite of an already dirty file
                   "$place|$line|$(if(Test-Path -LiteralPath $file -PathType Leaf){(Get-FileHash -LiteralPath $file).Hash})"}
           }else{"$place|.";Get-ChildItem -LiteralPath $place -Force -Name -ErrorAction Stop|ForEach-Object{"$place|$_"}}  # the marker keeps an empty folder comparable
       }}
       $before=@(Get-CodexWorld)
       $savedTemp=$env:TEMP;$savedTmp=$env:TMP;$env:TEMP=$scratch;$env:TMP=$scratch
       try{& node $Relay --brief $briefFile --cd $cloneDir --sandbox danger-full-access --ignore-user-config --model $Model --effort $Effort --timeout "${TimeoutMinutes}m" --out-dir $logs;$relayCode=$LASTEXITCODE}
       finally{$env:TEMP=$savedTemp;$env:TMP=$savedTmp}
       $after=try{@(Get-CodexWorld)}catch{@("UNREADABLE|$($_.Exception.Message)")}
       $changed=@(Compare-Object $before $after|ForEach-Object{"$($_.SideIndicator) $($_.InputObject)"})
       if($changed){
           $null=& $ev -Root $Root -Add -Pattern codex-outside-write -Source delegate-codex -Category failure -Status open -Summary "Codex run $run changed watched places: $(($changed|Select-Object -First 5)-join'; ')" -Evidence $logs -Owner agent -Action 'inspect what wrote it before any further Codex run; remove only after inspection'
           "CODEX_TRIPWIRE: $($changed.Count) change(s) outside the clone and scratch";$changed;exit 4
       }
       "CODEX_DONE relay exit $relayCode; scratch $scratch; logs $logs";exit $relayCode
   }

   ```

   e) immediately after the line
   ```text
   $reportPath=Join-Path $dir 'REPORT.md'
   ```
   insert
   ```text
   $readable=if($ReadRoots){'only these roots: '+(($ReadRoots|ForEach-Object{'`'+$_+'`'})-join', ')}else{'every file of the workspace and both repositories'}
   $gitScope=if($ReadRoots){'inside those roots only'}else{'in the real checkouts'}
   ```

   f) replace the line
   ```text
   - You MAY read every file of the workspace and both repositories, and run read-only git commands in the real checkouts."
   ```
   with
   ```text
   - You MAY read $readable, and run read-only git commands $gitScope."
   ```

   g) replace the line
   ```text
   "- You MAY read every file of the workspace and both repositories, and run read-only git commands (show, log, grep, rev-parse, cat-file, ls-tree, status) in the real checkouts."
   ```
   with
   ```text
   "- You MAY read $readable, and run read-only git commands (show, log, grep, rev-parse, cat-file, ls-tree, status) $gitScope."
   ```

   The resulting file's Git blob is b57d74d74511c6df1627aa90c22cba807b44d563.

2. Check whether `lib/Hunt.ps1` contains `# invariants: an archived transcript never diverges from its source (the prefix rule Copy-Grown relies on). Only`; if so record Already Applied when its Git blob is 5eac8c001a0c7dd290c8da33885cfc5dcf4e34b6, and otherwise stop and report. Otherwise make exactly these 2 edits (Codex tripwire and Hunt transcript invariant only), each matched once, and change nothing else:

   a) replace the line
   ```text
   # invariants: the archive never diverges from a source it copies (the prefix rule Copy-Grown relies on).
   ```
   with
   ```text
   # invariants: an archived transcript never diverges from its source (the prefix rule Copy-Grown relies on). Only
   # append-only *.jsonl transcripts: edited files (memory, meta) legitimately change and Copy-Grown sets them aside.
   ```

   b) replace the line
   ```text
   if(Test-Path "$raw\claude"){foreach($a in Get-ChildItem "$raw\claude" -Recurse -File){
   ```
   with
   ```text
   if(Test-Path "$raw\claude"){foreach($a in Get-ChildItem "$raw\claude" -Recurse -File -Filter *.jsonl){
   ```

   The resulting file's Git blob is 5eac8c001a0c7dd290c8da33885cfc5dcf4e34b6.

3. Check whether `lib/README.md` contains `sh Codex relay session (effort at most xhigh) with TEMP in i`; if so record Already Applied when its Git blob is 5789ef3b82b1777b4f2bc71982d7cd0b49d02326, and otherwise stop and report. Otherwise make exactly this one edit (Codex tripwire and Hunt transcript invariant only), each matched once, and change nothing else:

   a) replace the line
   ```text
   | `Delegate.ps1 -Pattern <id> -Question '...'` / `-Report <folder> -Reply <file>` / `-List` | the delegation road: a bounded brief for a cold agent (authority never grows, due = twice its budget); `-Report` is the return road: saves the reply, records the verdict, hands the item back to the agent |
   ```
   with
   ```text
   | `Delegate.ps1 -Pattern <id> -Question '...' [-ReadRoots ...]` / `-Report <folder> -Reply <file>` / `-List` / `-CodexBrief <brief> -Clone <temporary\cx\...>` | the delegation road: a bounded brief for a cold agent (authority never grows, due = twice its budget; `-ReadRoots` narrows reads); `-Report` is the return road: saves the reply, records the verdict, hands the item back to the agent; `-CodexBrief` runs one fresh Codex relay session (effort at most xhigh) with TEMP in its own scratch and an outside-agent tripwire: exit 4 + event `codex-outside-write` on any change to watched places |
   ```

   The resulting file's Git blob is 5789ef3b82b1777b4f2bc71982d7cd0b49d02326.

4. Check whether `lib/test-delegate.ps1` contains `$out=@(& $de -Root $t -Pattern narrow-case -Question 'NARROW-1' -ReadRoots 'C:\only\here')`; if so record Already Applied when its Git blob is fba9c29b53e7b3d2766df5187173b0251b6d2bad, and otherwise stop and report. Otherwise make exactly this one edit (Codex tripwire and Hunt transcript invariant only), each matched once, and change nothing else:

   a) replace the line
   ```text
   }finally{[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
       $out=@(& $de -Root $t -Pattern narrow-case -Question 'NARROW-1' -ReadRoots 'C:\only\here')
       $text=[IO.File]::ReadAllText(([regex]::Match(($out-join"`n"),'DELEGATED narrow-case -> (.+BRIEF\.md)')).Groups[1].Value)
       Assert-That 'ReadRoots narrows file and git reads of the brief' ($text.Contains('read only these roots: `C:\only\here`, and run read-only git commands (show, log, grep, rev-parse, cat-file, ls-tree, status) inside those roots only')-and!$text.Contains('every file of the workspace')-and!$text.Contains('status) in the real checkouts'))

       # Codex launcher with a fake relay in a fake GitHub folder (its temporary root beside one checkout), default watch
       # list: TEMP in its own scratch, the effort ceiling, and the outside-write tripwire.
       $savedTempRoot=$env:WORKBENCH_TEMP_ROOT;$gh=Join-Path $t 'gh';$env:WORKBENCH_TEMP_ROOT=Join-Path $gh 'ORVION-Workbench-temporary'
       try{
           . (Join-Path $PSScriptRoot 'workspace-layout.ps1');$tempRoot=Initialize-OrvionTemporaryRoot -Checkout (Split-Path $PSScriptRoot -Parent)
           $clone=Join-Path $tempRoot 'cx\ORVION-selfcheck';$null=& git init -q $clone
           $relay=Join-Path $t 'relay.mjs';$codexBrief=Join-Path $t 'selfcheck.md';Set-Content $codexBrief 'fixture brief'
           Set-Content $relay "import fs from 'fs';const a=process.argv;const o=a[a.indexOf('--out-dir')+1];fs.mkdirSync(o,{recursive:true});fs.writeFileSync(o+'/seen.txt',process.env.TEMP+'\n'+a.slice(2).join(' '));if(process.env.FAKE_ESCAPE){fs.writeFileSync(process.env.FAKE_ESCAPE,'stray '+Date.now())};process.exit(Number(process.env.FAKE_EXIT||0))"
           $repo=Join-Path $gh 'PRODUCT';$null=& git init -q $repo;$null=& git -C $repo -c user.name=fixture -c user.email=fixture@invalid commit -q --allow-empty -m fixture
           Set-Content (Join-Path $repo 'notes.txt') 'already untracked before the run'
           function Invoke-Codex([string]$Escape,[string]$ExitCode='0',[string[]]$More=@()){
               $env:FAKE_ESCAPE=$Escape;$env:FAKE_EXIT=$ExitCode
               try{$script:codexOut=@(& pwsh -NoProfile -File $de -Root $t -CodexBrief $codexBrief -Clone $clone -Relay $relay @More 2>&1)-join"`n";$LASTEXITCODE}finally{$env:FAKE_ESCAPE=$null;$env:FAKE_EXIT=$null}
           }
           $code=Invoke-Codex '' '7'
           $seen=@(Get-ChildItem (Join-Path $tempRoot 'codex-relay-logs') -Directory -Filter '*-selfcheck'|ForEach-Object{Get-Content (Join-Path $_.FullName 'seen.txt')})
           Assert-That 'a clean Codex run passes the relay exit through, with TEMP in its own scratch and the fixed flags' ($code-eq7-and$codexOut-match'CODEX_DONE relay exit 7'-and$seen[0]-like(Join-Path $tempRoot 'scratch\*-selfcheck')-and$seen[1]-match'--sandbox danger-full-access --ignore-user-config --model gpt-6.1-sol --effort medium --timeout 20m')
           $code=Invoke-Codex (Join-Path $gh 'stray.txt')
           $journal=@([IO.File]::ReadAllLines((Join-Path $t 'events\events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json}|Where-Object pattern -eq 'codex-outside-write')
           Assert-That 'a new entry beside the checkouts trips exit 4 and records a failure event' ($code-eq4-and$codexOut-match'CODEX_TRIPWIRE: 1 change'-and$journal.Count-eq1-and$journal[0].category-eq'failure')
           Remove-Item -LiteralPath (Join-Path $gh 'stray.txt')
           $code=Invoke-Codex (Join-Path $repo 'notes.txt')
           Assert-That 'rewriting an already untracked file in a sibling checkout trips exit 4' ($code-eq4-and$codexOut-match'CODEX_TRIPWIRE')
           $code=Invoke-Codex '' '0' @('-Effort','max')
           Assert-That 'effort above the owner ceiling is refused' ($code-ne0-and$codexOut-notmatch'CODEX_DONE')
           $outside=Join-Path $t 'not-cx';$null=& git init -q $outside
           $refused=@(& pwsh -NoProfile -File $de -Root $t -CodexBrief $codexBrief -Clone $outside -Relay $relay 2>&1)-join"`n"
           Assert-That 'a clone outside temporary\cx is refused' ($LASTEXITCODE-ne0-and$refused-match'CODEX_CLONE_REFUSED')
       }finally{$env:WORKBENCH_TEMP_ROOT=$savedTempRoot}
   }finally{Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```

   The resulting file's Git blob is fba9c29b53e7b3d2766df5187173b0251b6d2bad.

5. Check whether `lib/test-hunt.ps1` contains `Set-Content (Join-Path $archived 'MEMORY.md') 'old';Set-Content (Join-Path $source 'MEMORY.md') 'edited in place'  # not a transcript: never a prefix BUG`; if so record Already Applied when its Git blob is b380f9399619f629c388b0c948b366c03cd68969, and otherwise stop and report. Otherwise make exactly these 2 edits (Codex tripwire and Hunt transcript invariant only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
               Set-Content (Join-Path $archived 'prefix.jsonl') 'old';Set-Content (Join-Path $source 'prefix.jsonl') 'rewritten'
   ```
   insert
   ```text
               Set-Content (Join-Path $archived 'MEMORY.md') 'old';Set-Content (Join-Path $source 'MEMORY.md') 'edited in place'  # not a transcript: never a prefix BUG
   ```

   b) replace the line
   ```text
               Assert-That "hunt $case reads sessions, events and sync errors from data root with BUG exit 1" ($huntCode-eq1-and$result-match"BUG sync-errors:.*fixture-$case"-and$result-match'BUG index-consistency:.*index says'-and$result-match'BUG events-corrupt:'-and$result-match'BUG archive-prefix:'-and$result-match"BUG hook-errors:.*fixture-hook-$case"-and$result-notmatch'GAP event-evidence:')
   ```
   with
   ```text
               Assert-That "hunt $case reads sessions, events and sync errors from data root with BUG exit 1" ($huntCode-eq1-and$result-match"BUG sync-errors:.*fixture-$case"-and$result-match'BUG index-consistency:.*index says'-and$result-match'BUG events-corrupt:'-and$result-match'BUG archive-prefix: 1 of 1 archived'-and$result-match"BUG hook-errors:.*fixture-hook-$case"-and$result-notmatch'GAP event-evidence:')
   ```

   The resulting file's Git blob is b380f9399619f629c388b0c948b366c03cd68969.

6. Check whether `WORKFLOW.md` contains `he delegate. Never reset another slice's edits. Launch every`; if so record Already Applied when its Git blob is c791b3710c0eb4b363abf4cc0853ca4463d4be97, and otherwise stop and report. Otherwise make exactly this one edit (Codex tripwire and Hunt transcript invariant only), each matched once, and change nothing else:

   a) replace the line
   ```text
   Delegates must not read real sessions/events, ~/.claude, ~/.codex or ORVION-Owner-Tools. Use supplied safe source and synthetic fixtures. Disposable delegate clones belong only under ORVION-Workbench-temporary\\cx with independent Git/object storage and push disabled. No commit, push or network by the delegate. Never reset another slice's edits. The orchestrator verifies every claim; delegation is advisory and cannot certify.
   ```
   with
   ```text
   Delegates must not read real sessions/events, ~/.claude, ~/.codex or ORVION-Owner-Tools. Use supplied safe source and synthetic fixtures. Disposable delegate clones belong only under ORVION-Workbench-temporary\\cx with independent Git/object storage and push disabled. No commit, push or network by the delegate. Never reset another slice's edits. Launch every Codex run with `lib\Delegate.ps1 -CodexBrief <brief> -Clone <clone>`: one fresh session, TEMP in its own scratch, and an outside-agent tripwire (exit 4 and a failure event on any change to watched places; a tripwire, not confinement). The orchestrator verifies every claim; delegation is advisory and cannot certify.
   ```

   The resulting file's Git blob is c791b3710c0eb4b363abf4cc0853ca4463d4be97.

## Acceptance Criteria

- [ ] Exact approved scoped output. check: blob:lib/Delegate.ps1=b57d74d74511c6df1627aa90c22cba807b44d563
- [ ] Exact approved scoped output. check: blob:lib/Hunt.ps1=5eac8c001a0c7dd290c8da33885cfc5dcf4e34b6
- [ ] Exact approved scoped output. check: blob:lib/README.md=5789ef3b82b1777b4f2bc71982d7cd0b49d02326
- [ ] Exact approved scoped output. check: blob:lib/test-delegate.ps1=fba9c29b53e7b3d2766df5187173b0251b6d2bad
- [ ] Exact approved scoped output. check: blob:lib/test-hunt.ps1=b380f9399619f629c388b0c948b366c03cd68969
- [ ] Exact approved scoped output. check: blob:WORKFLOW.md=c791b3710c0eb4b363abf4cc0853ca4463d4be97
- [ ] The owning tests prove every behaviour: Hunt counts only diverged transcripts (a diverged MEMORY.md is not a BUG); the Codex launcher passes the relay exit through with TEMP in its own scratch and the fixed flags, trips exit 4 with a failure event on a new entry beside the checkouts and on a rewrite of an already untracked file in a sibling checkout, refuses effort max and a clone outside temporary\cx, and watches the GitHub folder beside the temporary root by default; -ReadRoots narrows file and git reads.
- [ ] Mandatory V1/V2/V3, focused proof on all 27 suites with the orchestrator's independent planted mutants, and accepted literal replay controls are preserved. One isolated native timed/watched Finish owns the unchanged full schedule with a fresh SANDBOX receipt before original approval; the original needs its own fresh Finish, live Review, native Complete and an independent carrying-range READY.

## Review Gate

- [ ] Inspect the scoped files, the focused/mutant/literal evidence and the Codex after-pass disposition; preserve all frozen prior evidence.
- [ ] Independently check the native receipt root/Draft/recipe/evaluator/fingerprint, ordered tests and timed/watcher/host exits; normal native Review/Complete and every new carrying transition must pass. No second-agent or provider certification is claimed.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Decision D28 in C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\delegation-20261026\DECISIONS.md (under D19-D27, the owner's standing order and the owner's approval of records\LEARNING-20261027.md). The orchestrator built the prototype; Codex (Sol, medium, fresh session, run through this very launcher) reviewed it adversarially and its three findings were fixed (records\WS-025\review1-disposition.md). Under the owner's exceptional delegation this one Workbench contract is authorized. Gate 1 for this Draft is DELEGATED: the owner did not type its digest. Sandbox approval is synthetic and grants no original authority.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-025\package\assurance\V3\DRAFT.md
Approved SHA256: C667A55C52259BA61B922C1436288EE7E2110D0697B91E9BA8098EA51ADB3687
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\delegation-20261026\GATE1-WS025-DELEGATED.md
Owner Evidence SHA256: 6A2FE41F88F378D8F984929F94AC5010483FF06F4907D523B126D15E945FD9AD
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-025\package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: FCE4BD18F6A4BAC7935B4573403E988DC758C438B1AE4EFF35D709228CF7C93B
Original admission: DELEGATED exact Gate 1 under the owner's exceptional delegation of 2026-10-26 (OWNER-DELEGATION.md SHA-256 94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217; decisions D1-D28; D28 is the delegated decision for this contract). The owner did not type this digest. Bound to this literal root, the exact V3 digest and the fresh sandbox receipt; no sandbox receipt transplant as original certification.

## Verification Notes

The orchestrator's nine planted mutants (package\Run-Evidence.ps1) are each killed by their own named assertion; hazard scan 0; all 27 suites PASS with an isolated ORVION_DATA_ROOT in the Finish environment (focused-selected.log); the Markdown guard passes on the prototype.

## Selection reasons and sources

Evidence Refresh: the 27-suite focused proof with nine planted mutants and hazard scan 0 on the final bytes. Baseline 77eff5d (main = WS-022), accepted judge 835E14DA unchanged.

Sources: DECISIONS.md D19-D28, records\WS-025\*, records\LEARNING-20261027.md, accepted WORKFLOW/TEMPLATE/checker, WS-022 packet scripts.
