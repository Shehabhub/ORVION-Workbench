# Workbench Change Request - WS-017

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

## Objective

Make the answers agents rely on true: the data tools (Events, Spider, Pulse, Coordinator, Delegate, Watch-Subagents) find the real data store by default (ORVION_DATA_ROOT, else the sibling ORVION-Owner-Tools store, else this checkout) and never report a missing or damaged store as "nothing found"; Finish consults the real lessons and says plainly when none are available; run_timed never runs a command in the wrong directory or without its log; the test schedule can never write into the real data store.

## Baseline

f42860b84dcd9b4dbe2111abdbc81583f33f511f

## Write Scope

- RESUME.md
- lib/Events.ps1
- lib/Spider.ps1
- lib/Pulse.ps1
- lib/Coordinator.ps1
- lib/Delegate.ps1
- lib/Watch-Subagents.ps1
- lib/Workbench.ps1
- lib/run_timed.ps1
- tests.ps1
- lib/test-events.ps1
- lib/test-spider.ps1
- lib/test-pulse.ps1
- lib/test-run-timed.ps1
- lib/test-watch-host.ps1
- lib/test-delegate.ps1
- lib/test-coordinator.ps1
- lib/README.md

## Out of Scope

All other engineering paths except native allocation/status/pointer bookkeeping. No checker (Test-WorkbenchChange.ps1), applier, workflow, hook, GitHub setting or product repository change; the ORVION-Owner-Tools copy of lib and the user hook settings are not changed. Deferred and recorded: Hunt mixed source/data root, Sync-Sessions failure exit and prefix proof, Restore manifest completeness, Backup git-config filtering for product repositories, Delegate verdict closure, Events duplicate fields and brief categories, Watch-Subagents stale evidence, apply-draft-steps marker refusal, Finish watcher binding, Test-ScriptHazards foreach targets and scopes, observer timeouts. CTRL-19 stays OPEN; Batch 6/Phase 8 stay ON HOLD.

## Draft Assurance

V1: WS017-ANSWERS-DESIGN | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws017-package\assurance\V1\DRAFT.md | A4A4249037CB177BCA38EE2E56BE4CCE003F2C61FFC558DD269E81977A28E1EC
V2: WS017-ANSWERS-ADVERSARIAL | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws017-package\assurance\V2\DRAFT.md | 1FC63843420B61F544D68C54FE3FA189609DC6D20AA4A819C9ABFD4E7BE130F1
V3: WS017-ANSWERS-REFRESH | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws017-package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSroot17
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSroot17\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSroot17\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws017-package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/Events.ps1` contains `EVENTS_UNAVAILABLE`; if so record Already Applied when its Git blob is 48d98858f32d8c056dd3143cf1a6ad0c65944f5b, and otherwise stop and report. Otherwise make exactly these 5 edits (trustworthy agent answers only), each matched once, and change nothing else:

   a) replace the line
   ```text
       [string]$Root=(Split-Path $PSScriptRoot -Parent)
   ```
   with
   ```text
       [string]$Root=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]})  # the data root: ORVION_DATA_ROOT, else sibling ORVION-Owner-Tools, else this checkout
   ```

   b) immediately after the lines
   ```text
       "EVENT RECORDED $Pattern ($n session(s))";exit 0
   }

   ```
   insert
   ```text
   # A reader never reports a missing or damaged journal as "nothing recorded": exit 3 unavailable, exit 2 incomplete.
   if(!(Test-Path -LiteralPath $log)){"EVENTS_UNAVAILABLE: no journal at $log (pass -Root or set ORVION_DATA_ROOT)";exit 3}
   function Exit-Reader{
       if($script:badLines){"EVENTS_INCOMPLETE: $($script:badLines) unreadable record(s) skipped in $log; results may miss them"}
       if($script:badIndexLines){"EVENTS_INCOMPLETE: $($script:badIndexLines) unreadable record(s) skipped in $ix; session links may miss them"}
       if($script:badLines-or$script:badIndexLines){exit 2};exit 0
   }
   ```

   c) replace the lines
   ```text
   $sessionIndex=@{};$ix=Join-Path $Root 'sessions\index.jsonl'
   if($Find-and(Test-Path $ix)){foreach($l in [IO.File]::ReadAllLines($ix)){if($l){try{$o=$l|ConvertFrom-Json;$sessionIndex[$o.id]=$o}catch{$script:badLines++}}}}
   ```
   with
   ```text
   $sessionIndex=@{};$ix=Join-Path $Root 'sessions\index.jsonl';$script:badIndexLines=0
   if($Find-and(Test-Path $ix)){foreach($l in [IO.File]::ReadAllLines($ix)){if($l){try{$o=$l|ConvertFrom-Json;$sessionIndex[$o.id]=$o}catch{$script:badIndexLines++}}}}
   ```

   d) replace the lines
   ```text
       if(!$hits.Count){"EVENTS: nothing recorded matches this task.";exit 0}
       "EVENTS relevant to this task ($($hits.Count) of $(@($views).Count) patterns):";$hits|ForEach-Object{Format-View $_.v -WithSession};exit 0
   ```
   with
   ```text
       if(!$hits.Count){"EVENTS: nothing recorded matches this task.";Exit-Reader}
       "EVENTS relevant to this task ($($hits.Count) of $(@($views).Count) patterns):";$hits|ForEach-Object{Format-View $_.v -WithSession};Exit-Reader
   ```

   e) immediately after the line
   ```text
   if($live.Count){"EVENTS open or recurring (top $($live.Count) of $(@($views).Count); for a task run Events.ps1 -Find '<task>'):";$live|ForEach-Object{Format-View $_}}
   ```
   insert
   ```text
   Exit-Reader
   ```

   The resulting file's Git blob is 48d98858f32d8c056dd3143cf1a6ad0c65944f5b.

2. Check whether `lib/Spider.ps1` contains `SPIDER_COVERAGE`; if so record Already Applied when its Git blob is da99c5987c00c848c79af43b6a5287a5d4dc4719, and otherwise stop and report. Otherwise make exactly these 8 edits (trustworthy agent answers only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$Root=(Split-Path $PSScriptRoot -Parent),
   ```
   with
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]}),
   ```

   b) immediately after the lines
   ```text
           if(!$found[$id]){$found[$id]=[pscustomobject]@{id=$id;hits=0;first=Get-Snippet $l}};$found[$id].hits++}}}finally{$sr.Close()}
   }}
   ```
   insert
   ```text
   # A missing source is reported as UNAVAILABLE and makes the answer incomplete (exit 3), never "0 found".
   $gaps=[Collections.Generic.List[string]]::new();if(!(Test-Path -LiteralPath $raw)){$gaps.Add("sessions (no archive at $raw)")}
   ```

   c) replace the line
   ```text
   "== sessions: $($ranked.Count) mention it$(if($ranked.Count){" ($(($ranked|Measure-Object hits -Sum).Sum) lines)"})"
   ```
   with
   ```text
   "== sessions: $(if(!(Test-Path -LiteralPath $raw)){"UNAVAILABLE (no archive at $raw)"}else{"$($ranked.Count) mention it"})$(if($ranked.Count){" ($(($ranked|Measure-Object hits -Sum).Sum) lines)"})"
   ```

   d) replace the line
   ```text
   "== events: $(if($ev[0]-match'nothing recorded'){'none'}else{($ev|Select-Object -Skip 1)-join"`n  "})"
   ```
   with
   ```text
   $evCode=$LASTEXITCODE
   if($evCode-in2,3){$gaps.Add("events ($(if($evCode-eq2){'EVENTS_INCOMPLETE'}else{'EVENTS_UNAVAILABLE'}))")}
   "== events: $(if($evCode-in2,3){($ev|Where-Object{$_-notmatch'^EVENTS:'})-join"`n  "}elseif($ev[0]-match'nothing recorded'){'none'}else{($ev|Select-Object -Skip 1)-join"`n  "})"
   ```

   e) replace the line
   ```text
   foreach($r in $Repos|Where-Object{Test-Path (Join-Path $_ '.git')}){
   ```
   with
   ```text
   foreach($r in $Repos){
   ```

   f) immediately after the line
   ```text
       $name=Split-Path $r -Leaf
   ```
   insert
   ```text
       if(!(Test-Path -LiteralPath (Join-Path $r '.git'))){"== $name`: UNAVAILABLE (no repository at $r)";$gaps.Add("$name (no repository)");continue}
   ```

   g) immediately after the line
   ```text
   $nh=@(foreach($f in $md){$c=@([IO.File]::ReadAllLines($f.FullName)|Where-Object{$_.IndexOf($Query,$cmp)-ge0}).Count;if($c){[pscustomobject]@{path=$f.FullName;hits=$c}}})
   ```
   insert
   ```text
   if($gaps.Count){$coverage="SPIDER_COVERAGE: incomplete - $($gaps-join'; ')"}
   ```

   h) immediately after the line
   ```text
   "== notes: $($nh.Count) files$(if($nh.Count){': '+(($nh|Sort-Object hits -Descending|Select-Object -First $Top|ForEach-Object{"$($_.path.Replace($env:USERPROFILE,'~')) $($_.hits)"})-join', ')})"
   ```
   insert
   ```text
   if($gaps.Count){$coverage;exit 3}
   ```

   The resulting file's Git blob is da99c5987c00c848c79af43b6a5287a5d4dc4719.

3. Check whether `lib/Pulse.ps1` contains `damaged session-index row`; if so record Already Applied when its Git blob is 463ca7334468942c75c3e68b725bcc8a5b7b7734, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy agent answers only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([string]$Root=(Split-Path $PSScriptRoot -Parent),[string]$Session=$env:CLAUDE_CODE_SESSION_ID,
   ```
   with
   ```text
   param([string]$Root=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]}),[string]$Session=$env:CLAUDE_CODE_SESSION_ID,
   ```

   b) replace the line
   ```text
   $prev=@(if(Test-Path $ixPath){[IO.File]::ReadAllLines($ixPath)|Where-Object{$_}|ForEach-Object{try{$_|ConvertFrom-Json}catch{$null=$_}}|Where-Object{$_}|Where-Object{$_.id-ne$Session-and$_.prompts}|Sort-Object end})|Select-Object -Last 1
   ```
   with
   ```text
   $prev=@(if(Test-Path $ixPath){[IO.File]::ReadAllLines($ixPath)|Where-Object{$_}|ForEach-Object{try{$_|ConvertFrom-Json}catch{$script:indexBadRows++}}|Where-Object{$_}|Where-Object{$_.id-ne$Session-and$_.prompts}|Sort-Object end})|Select-Object -Last 1
   # The session index is continuity evidence: missing is said plainly, damaged rows make the pulse unreadable.
   if(!(Test-Path $ixPath)){"last     none: no session index at $ixPath (Sync-Sessions.ps1 builds it)"}elseif($script:indexBadRows){$pulseUnreadable=$true;"last     UNREADABLE: $($script:indexBadRows) damaged session-index row(s) in $ixPath"}
   ```

   The resulting file's Git blob is 463ca7334468942c75c3e68b725bcc8a5b7b7734.

4. Check whether `lib/Coordinator.ps1` contains `ORVION_DATA_ROOT`; if so record Already Applied when its Git blob is 1b513b370580a9438dab27ee047752dda26e869f, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy agent answers only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$Root=(Split-Path $PSScriptRoot -Parent))
   ```
   with
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]}))
   ```

   b) replace the line
   ```text
       $hits=@(& $ev -Root $Root -Find $Text -Top 5|Where-Object{$_-match'^\[(resolved|disproven|superseded) '-and$_-notmatch"\] $([regex]::Escape($Except)):"})
   ```
   with
   ```text
       $prior=@(& $ev -Root $Root -Find $Text -Top 5)
       $prior|Where-Object{$_-match'^EVENTS_(INCOMPLETE|UNAVAILABLE)'}
       $hits=@($prior|Where-Object{$_-match'^\[(resolved|disproven|superseded) '-and$_-notmatch"\] $([regex]::Escape($Except)):"})
   ```

   The resulting file's Git blob is 1b513b370580a9438dab27ee047752dda26e869f.

5. Check whether `lib/Delegate.ps1` contains `ORVION_DATA_ROOT`; if so record Already Applied when its Git blob is 5b7c2f2a71167c05bac9602871ff473ae77a03e0, and otherwise stop and report. Otherwise make exactly these 4 edits (trustworthy agent answers only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$Root=(Split-Path $PSScriptRoot -Parent))
   ```
   with
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]}))
   ```

   b) replace the line
   ```text
   $history=@(if(Test-Path (Join-Path $Root 'events\events.jsonl')){[IO.File]::ReadAllLines((Join-Path $Root 'events\events.jsonl'))|Where-Object{$_}|ForEach-Object{try{$_|ConvertFrom-Json}catch{$null=$_}}|Where-Object{$_}|Where-Object pattern -eq $Pattern|Sort-Object at})
   ```
   with
   ```text
   $log=Join-Path $Root 'events\events.jsonl';$historyBad=0
   $history=@(if(Test-Path $log){[IO.File]::ReadAllLines($log)|Where-Object{$_}|ForEach-Object{try{$o=$_|ConvertFrom-Json;if(!$o.pattern-or!$o.at){throw 'invalid record'};$o}catch{$historyBad++}}|Where-Object pattern -eq $Pattern|Sort-Object at})
   ```

   c) replace the line
   ```text
   $related=@(& $ev -Root $Root -Find $Question -Top 3|Where-Object{$_-notmatch"^EVENTS|\] $([regex]::Escape($Pattern)):"})  # solved before? say so before the work starts
   ```
   with
   ```text
   if($historyBad){$known+="- EVENTS_INCOMPLETE: $historyBad unreadable history record(s) skipped in $log"}
   if(!(Test-Path $log)){$known+="- EVENTS_UNAVAILABLE: no history journal at $log"}
   $related=@(& $ev -Root $Root -Find $Question -Top 3);$lookupCode=$LASTEXITCODE
   $related=@($related|Where-Object{$_-notmatch"^EVENTS:|^EVENTS relevant|\] $([regex]::Escape($Pattern)):"})  # solved before? say so before the work starts
   if($historyBad-and$lookupCode-eq0){$lookupCode=2}
   ```

   d) immediately after the line
   ```text
   "WHEN IT FINISHES: save its reply to a file, then: pwsh -NoProfile -File `"$PSCommandPath`" -Report `"$dir`" -Reply <that file>   (re-run its decisive check yourself before acting on it)"
   ```
   insert
   ```text
   exit $lookupCode
   ```

   The resulting file's Git blob is 5b7c2f2a71167c05bac9602871ff473ae77a03e0.

6. Check whether `lib/Watch-Subagents.ps1` contains `ORVION_DATA_ROOT`; if so record Already Applied when its Git blob is 627e6ca702ab73d79e27f5cacce1c230857480f8, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy agent answers only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$EventRoot=(Split-Path $PSScriptRoot -Parent))
   ```
   with
   ```text
         [string]$EventRoot=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]}))
   ```

   The resulting file's Git blob is 627e6ca702ab73d79e27f5cacce1c230857480f8.

7. Check whether `lib/Workbench.ps1` contains `lessons not consulted`; if so record Already Applied when its Git blob is 0b912913fdc219889a2c9b338931e136dd42d9f2, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy agent answers only), each matched once, and change nothing else:

   a) replace the lines
   ```text
               & pwsh -NoProfile -File (Join-Path $Root 'lib/Events.ps1') -Root $Root -Find $record.Id
               if($LASTEXITCODE-ne0){throw 'WB_REQUIRED_EVENTS_READ_FAILED'}
               'WORKBENCH_PREFLIGHT: Events Find READY'
   ```
   with
   ```text
               # Lessons come from the data root (Events.ps1 default), not this checkout; a journal that is absent (3,
               # sandbox or CI) or partly damaged (2) is said plainly by Events and does not block the Finish.
               & pwsh -NoProfile -File (Join-Path $Root 'lib/Events.ps1') -Find $record.Id
               if($LASTEXITCODE-notin0,2,3){throw 'WB_REQUIRED_EVENTS_READ_FAILED'}
               'WORKBENCH_PREFLIGHT: Events Find '+@{0='READY';2='INCOMPLETE (unreadable records skipped)';3='UNAVAILABLE (no journal at the data root; lessons not consulted)'}[$LASTEXITCODE]
   ```

   The resulting file's Git blob is 0b912913fdc219889a2c9b338931e136dd42d9f2.

8. Check whether `lib/run_timed.ps1` contains `the command was not run`; if so record Already Applied when its Git blob is 4580b662d813fdb0104343f50d8260520401ec19, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy agent answers only), each matched once, and change nothing else:

   a) replace the line
   ```text
   Set-Location -LiteralPath $WorkingDirectory
   ```
   with
   ```text
   # A directory or log that cannot be used stops the run: a command never runs elsewhere under this label.
   Set-Location -LiteralPath $WorkingDirectory -ErrorAction Stop
   ```

   b) replace the line
   ```text
   '[{0}] START pid={1} {2} | {3}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $PID, $envLabel, $Command | Out-File -LiteralPath $Log -Encoding utf8
   ```
   with
   ```text
   try { '[{0}] START pid={1} {2} | {3}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $PID, $envLabel, $Command | Out-File -LiteralPath $Log -Encoding utf8 -ErrorAction Stop }
   catch { "run_timed: cannot write the log $Log ($($_.Exception.Message)); the command was not run"; exit 1 }
   ```

   The resulting file's Git blob is 4580b662d813fdb0104343f50d8260520401ec19.

9. Check whether `tests.ps1` contains `ORVION_DATA_ROOT`; if so record Already Applied when its Git blob is 3df650aca5d3b3b5880e87eb2c41b82117033640, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy agent answers only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   # test events never reach the real journal: every check writes to its own disposable root
   $journal=Join-Path $PSScriptRoot 'events\events.jsonl';$journalHash=if(Test-Path $journal){(Get-FileHash $journal).Hash}
   ```
   with
   ```text
   # test events never reach the real journal: every check writes to its own disposable root, and the data tools'
   # default root (ORVION_DATA_ROOT) is an empty disposable folder for the whole run
   $dataRoot=if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path $PSScriptRoot -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@($PSScriptRoot))[0]}
   $journal=Join-Path $dataRoot 'events\events.jsonl';$journalHash=if(Test-Path $journal){(Get-FileHash $journal).Hash}
   $env:ORVION_DATA_ROOT=Join-Path $(if($env:WORKBENCH_TEMP_ROOT){$env:WORKBENCH_TEMP_ROOT}else{[IO.Path]::GetTempPath()}) "orvion-test-data-$PID";[void][IO.Directory]::CreateDirectory($env:ORVION_DATA_ROOT)
   ```

   The resulting file's Git blob is 3df650aca5d3b3b5880e87eb2c41b82117033640.

10. Check whether `lib/test-events.ps1` contains `EVENTS_UNAVAILABLE`; if so record Already Applied when its Git blob is 178145d5abc84e4144cd2085ad6da9c829c37a1d, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy agent answers only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       Assert-That 'a torn line does not silence the readers' ($okBrief-and$okFind)
   ```
   insert
   ```text
       $torn=@(& pwsh -NoProfile -File $ev -Root $t -Find 'process');$tornCode=$LASTEXITCODE
       Assert-That 'a damaged journal is reported INCOMPLETE with exit 2, results still shown' ($tornCode-eq2-and($torn-join"`n")-match'EVENTS_INCOMPLETE: 1 unreadable'-and($torn-join"`n")-match'ps-reserved-name')
       $tornBrief=@(& pwsh -NoProfile -File $ev -Root $t -Brief);$tornBriefCode=$LASTEXITCODE
       Assert-That 'Brief retains EVENTS_INCOMPLETE and exit 2 on a damaged journal' ($tornBriefCode-eq2-and($tornBrief-join"`n")-match'EVENTS_INCOMPLETE: 1 unreadable')
       $journal=Join-Path $t 'events\events.jsonl';$valid=@(Get-Content $journal|Select-Object -SkipLast 1);[IO.File]::WriteAllLines($journal,[string[]]$valid)
       Add-Content "$t\sessions\index.jsonl" '{"torn index'
       $indexOnly=@(& pwsh -NoProfile -File $ev -Root $t -Find 'process');$indexCode=$LASTEXITCODE;$indexText=$indexOnly-join"`n"
       Assert-That 'index damage alone names the index, not the journal, and exits 2' ($indexCode-eq2-and$indexText.Contains("EVENTS_INCOMPLETE: 1 unreadable record(s) skipped in $t\sessions\index.jsonl")-and!$indexText.Contains("skipped in $journal"))
       Add-Content $journal '{"torn journal';Add-Content $journal '{}'
       $both=@(& pwsh -NoProfile -File $ev -Root $t -Find 'process');$bothCode=$LASTEXITCODE;$bothText=$both-join"`n"
       Assert-That 'journal and index damage have separate counts and file attribution' ($bothCode-eq2-and$bothText.Contains("EVENTS_INCOMPLETE: 2 unreadable record(s) skipped in $journal")-and$bothText.Contains("EVENTS_INCOMPLETE: 1 unreadable record(s) skipped in $t\sessions\index.jsonl"))
       Assert-That 'Workbench incomplete preflight wording is source-neutral' ([IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Workbench.ps1')).Contains("2='INCOMPLETE (unreadable records skipped)'"))
       $none=@(& pwsh -NoProfile -File $ev -Root (Join-Path $t 'no-store') -Find 'process');$noneCode=$LASTEXITCODE
       $null=& pwsh -NoProfile -File $ev -Root (Join-Path $t 'no-store') -Brief;$noneBriefCode=$LASTEXITCODE
       Assert-That 'a missing journal is UNAVAILABLE (exit 3), never "nothing recorded"' ($noneCode-eq3-and$none[0]-match'^EVENTS_UNAVAILABLE'-and($none-join' ')-notmatch'nothing recorded'-and$noneBriefCode-eq3)
       # The default data root: the sibling ORVION-Owner-Tools store when it has events\, ORVION_DATA_ROOT above all.
       $gh=Join-Path $t 'gh';$copy=Join-Path $gh 'ORVION-Workbench\lib';[void][IO.Directory]::CreateDirectory($copy);Copy-Item $ev $copy
       $null=& $ev -Root (Join-Path $gh 'ORVION-Owner-Tools') -Add -Pattern sibling-store-marker -Session s9 -Summary 'found in the sibling data store' -Tags 'siblingmarker'
       $null=& $ev -Root (Join-Path $t 'env-store') -Add -Pattern env-store-marker -Session s9 -Summary 'found through ORVION_DATA_ROOT' -Tags 'siblingmarker'
       $savedRoot=$env:ORVION_DATA_ROOT
       try{$env:ORVION_DATA_ROOT=$null;$sib=@(& pwsh -NoProfile -File (Join-Path $copy 'Events.ps1') -Find 'siblingmarker')
           $env:ORVION_DATA_ROOT=Join-Path $t 'env-store';$viaEnv=@(& pwsh -NoProfile -File (Join-Path $copy 'Events.ps1') -Find 'siblingmarker')}finally{$env:ORVION_DATA_ROOT=$savedRoot}
       Assert-That 'default root finds the sibling data store; ORVION_DATA_ROOT overrides it' (($sib-join' ')-match'sibling-store-marker'-and($viaEnv-join' ')-match'env-store-marker'-and($viaEnv-join' ')-notmatch'sibling-store-marker')
       $expression='$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) ''ORVION-Owner-Tools'')|Where-Object{Test-Path -LiteralPath (Join-Path $_ ''events'')})+@(Split-Path $PSScriptRoot -Parent))[0]})'
       $drift=@(foreach($tool in 'Events','Spider','Pulse','Coordinator','Delegate'){if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot "$tool.ps1")).Contains('[string]$Root='+$expression)){$tool}})+@(if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Watch-Subagents.ps1')).Contains('[string]$EventRoot='+$expression)){'Watch-Subagents'})
       Assert-That "every data tool carries the one identical data-root default$(if($drift.Count){' (drifted: '+($drift-join', ')+')'})" (!$drift.Count)
   ```

   The resulting file's Git blob is 178145d5abc84e4144cd2085ad6da9c829c37a1d.

11. Check whether `lib/test-spider.ps1` contains `SPIDER_COVERAGE`; if so record Already Applied when its Git blob is 205ea50222c0308ce84a0062f63c10a9b34c8b44, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy agent answers only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       Assert-That 'malformed present projects root is fatal' $refused
   ```
   insert
   ```text
       $env:USERPROFILE=Join-Path $t 'profile'
       $archive=Join-Path $t 'ws\sessions\raw';$journal=Join-Path $t 'ws\events\events.jsonl'
       foreach($source in 'sessions','events','repository'){
           if($source-eq'sessions'){Move-Item -LiteralPath $archive -Destination (Join-Path $t 'saved-raw')}
           if($source-eq'events'){Move-Item -LiteralPath $journal -Destination (Join-Path $t 'saved-journal')}
           try{
               $selectedRepo=if($source-eq'repository'){Join-Path $t 'no-repo'}else{$repo}
               $gap=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $selectedRepo -ReviewRoot (Join-Path $t 'none'));$gapCode=$LASTEXITCODE;$gapText=$gap-join"`n"
               $named=@{sessions='sessions \(no archive';events='events \(EVENTS_UNAVAILABLE\)';repository='no-repo \(no repository\)'}[$source]
               Assert-That "missing $source alone names its coverage gap and exits 3" ($gapCode-eq3-and$gapText-match("SPIDER_COVERAGE: incomplete - "+$named)-and($gapText-split'SPIDER_COVERAGE: incomplete - ')[-1]-notmatch';')
           }finally{
               if($source-eq'sessions'){Move-Item -LiteralPath (Join-Path $t 'saved-raw') -Destination $archive}
               if($source-eq'events'){Move-Item -LiteralPath (Join-Path $t 'saved-journal') -Destination $journal}
           }
       }
       Add-Content $journal '{"torn line'
       $damaged=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ABSENT-97' -Root (Join-Path $t 'ws') -Repos $repo -ReviewRoot (Join-Path $t 'none'));$damagedCode=$LASTEXITCODE;$damagedText=$damaged-join"`n"
       Assert-That 'damaged journal with no matches exits 3 and retains EVENTS_INCOMPLETE' ($damagedCode-eq3-and$damagedText-match'(?m)^== events: EVENTS_INCOMPLETE: 1 unreadable'-and$damagedText-match'SPIDER_COVERAGE: incomplete - events \(EVENTS_INCOMPLETE\)'-and$damagedText-notmatch'events: none')
   ```

   The resulting file's Git blob is 205ea50222c0308ce84a0062f63c10a9b34c8b44.

12. Check whether `lib/test-pulse.ps1` contains `damaged session index`; if so record Already Applied when its Git blob is 83e5a9e3229c9df4b1fda5c9d8f0c76eb0e2f188, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy agent answers only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       Assert-PulseCheck 'genuinely unconfigured upstream remains a readable no-upstream state' ($pulseObserved.Exit-eq0-and$pulseObserved.Text-match'no upstream') $pulseObserved.Text
   ```
   insert
   ```text
       Assert-PulseCheck 'a missing session index is said plainly, not silently skipped' ($pulseObserved.Text-match'last     none: no session index') $pulseObserved.Text
       [void][IO.Directory]::CreateDirectory((Join-Path $pulseFixture 'sessions'))
       [IO.File]::WriteAllText((Join-Path $pulseFixture 'sessions/index.jsonl'),"{`"torn`n")
       $pulseObserved=Invoke-PulseCheck
       Assert-PulseCheck 'a damaged session index is UNREADABLE with nonzero exit' ($pulseObserved.Exit-eq2-and$pulseObserved.Text-match'last     UNREADABLE: 1 damaged') $pulseObserved.Text
   ```

   The resulting file's Git blob is 83e5a9e3229c9df4b1fda5c9d8f0c76eb0e2f188.

13. Check whether `lib/test-run-timed.ps1` contains `RUN_TIMED_SELFCHECK`; if so record Already Applied when its Git blob is 33f15f6037f2fbe41b70474cd0ac1df2e859adb3, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (trustworthy agent answers only), and change nothing else:

   ```text
   # Self-check for run_timed.ps1 in a temp folder: a run reports its command's exit code, and a working directory or log
   # that cannot be used stops the run before the command executes (never a command run elsewhere under this label).
   $ErrorActionPreference='Stop'
   $runner=Join-Path $PSScriptRoot 'run_timed.ps1'
   $t=Join-Path ([IO.Path]::GetTempPath()) "orvion-timedcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";[void][IO.Directory]::CreateDirectory($t)
   $fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
   $env:ORVION_RESOURCE_SECONDS='1'
   try{
       $marker=Join-Path $t 'ran.txt';$command="Set-Content -LiteralPath '$marker' (Get-Location).Path;exit 7"
       & pwsh -NoProfile -File $runner -Log (Join-Path $t 'ok.log') -WorkingDirectory $t -Command $command *>$null;$code=$LASTEXITCODE
       $log=[IO.File]::ReadAllText((Join-Path $t 'ok.log'))
       Assert-That 'the command runs in the requested directory and its exit code is preserved' ($code-eq7-and(Get-Content $marker)-eq$t-and$log-match'START pid='-and$log-match'END exit=7')
       Remove-Item $marker
       & pwsh -NoProfile -File $runner -Log (Join-Path $t 'nodir.log') -WorkingDirectory (Join-Path $t 'missing') -Command $command *>$null;$code=$LASTEXITCODE
       Assert-That 'a missing working directory stops the run before the command' ($code-ne0-and!(Test-Path $marker))
       & pwsh -NoProfile -File $runner -Log (Join-Path $t 'no\such\folder\x.log') -WorkingDirectory $t -Command $command *>$null;$code=$LASTEXITCODE
       Assert-That 'an unwritable log stops the run before the command' ($code-ne0-and!(Test-Path $marker))
   }finally{Remove-Item Env:ORVION_RESOURCE_SECONDS -ErrorAction SilentlyContinue;[IO.Directory]::Delete($t,$true)}
   if($fail){throw "RUN_TIMED_SELFCHECK_FAILED $fail"};'RUN_TIMED_SELFCHECK PASS'
   ```

   The resulting file's Git blob is 33f15f6037f2fbe41b70474cd0ac1df2e859adb3.

14. Check whether `lib/test-watch-host.ps1` contains `ORVION_DATA_ROOT`; if so record Already Applied when its Git blob is 53978799e8fea61a8151d24ee1109f9087529a4f, and otherwise stop and report. Otherwise make exactly these 2 edits (trustworthy agent answers only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   try{
   ```
   insert
   ```text
       $savedRoot=$env:ORVION_DATA_ROOT;$env:ORVION_DATA_ROOT=$t
   ```

   b) replace the line
   ```text
   }finally{Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
   }finally{$env:ORVION_DATA_ROOT=$savedRoot;Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   Assert-That 'the inherited data root is restored' ($env:ORVION_DATA_ROOT-eq$savedRoot)
   ```

   The resulting file's Git blob is 53978799e8fea61a8151d24ee1109f9087529a4f.

15. Check whether `lib/test-delegate.ps1` contains `EVENTS_INCOMPLETE`; if so record Already Applied when its Git blob is 65a297f30a568231cf413255fb7a5b19d6c43252, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy agent answers only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       Assert-That 'a malformed pattern id is refused' $bad
   ```
   insert
   ```text
       $de=Join-Path $PSScriptRoot 'Delegate.ps1';$evPath=Join-Path $PSScriptRoot 'Events.ps1'
       $damaged=Join-Path $t 'damaged';$null=& $evPath -Root $damaged -Add -Pattern unrelated -Summary 'unrelated history'
       Add-Content (Join-Path $damaged 'events\events.jsonl') '{"torn row';Add-Content (Join-Path $damaged 'events\events.jsonl') '{}'
       $out=@(& pwsh -NoProfile -File $de -Root $damaged -Pattern damaged-case -Question 'ABSENT-97');$code=$LASTEXITCODE
       $path=([regex]::Match(($out-join"`n"),'DELEGATED damaged-case -> (.+BRIEF\.md)')).Groups[1].Value;$text=[IO.File]::ReadAllText($path)
       Assert-That 'damaged history is counted in the brief with exit 2' ($code-eq2-and$text-match'EVENTS_INCOMPLETE: 2 unreadable history record\(s\) skipped'-and$text-notmatch'nothing recorded yet')
       $indexed=Join-Path $t 'indexed';$null=& $evPath -Root $indexed -Add -Pattern unrelated -Summary 'unrelated history'
       New-Item -ItemType Directory (Join-Path $indexed 'sessions')|Out-Null;Set-Content (Join-Path $indexed 'sessions\index.jsonl') '{"torn index'
       $out=@(& pwsh -NoProfile -File $de -Root $indexed -Pattern indexed-case -Question 'ABSENT-97');$code=$LASTEXITCODE
       $path=([regex]::Match(($out-join"`n"),'DELEGATED indexed-case -> (.+BRIEF\.md)')).Groups[1].Value;$text=[IO.File]::ReadAllText($path)
       Assert-That 'incomplete related lookup remains visible in the brief with exit 2' ($code-eq2-and$text-match'(?s)Related past events.+EVENTS_INCOMPLETE:'-and$text-notmatch'none recorded')
       $out=@(& pwsh -NoProfile -File $de -Root (Join-Path $t 'absent') -Pattern absent-case -Question 'ABSENT-97');$code=$LASTEXITCODE
       $path=([regex]::Match(($out-join"`n"),'DELEGATED absent-case -> (.+BRIEF\.md)')).Groups[1].Value;$text=[IO.File]::ReadAllText($path)
       Assert-That 'unavailable history and related lookup remain visible in the brief with exit 3' ($code-eq3-and$text-match'(?s)What is already known.+EVENTS_UNAVAILABLE: no history journal'-and$text-match'(?s)Related past events.+EVENTS_UNAVAILABLE:'-and$text-notmatch'none recorded|nothing recorded yet')
   ```

   The resulting file's Git blob is 65a297f30a568231cf413255fb7a5b19d6c43252.

16. Check whether `lib/test-coordinator.ps1` contains `EVENTS_UNAVAILABLE`; if so record Already Applied when its Git blob is 4304247fa9f131d74a9b53996e45ba7c71b28980, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy agent answers only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       Assert-That 'new assignments cannot poison a valid journal with an invalid due date' ($invalidDue-and(Get-FileHash $validJournal).Hash-eq$validHash)
   ```
   insert
   ```text
       New-Item -ItemType Directory (Join-Path $t 'sessions')|Out-Null;Set-Content (Join-Path $t 'sessions\index.jsonl') '{"torn index'
       $aux=@(& pwsh -NoProfile -File $co -Root $t -Assign technical-choice -Owner agent -Action 'retain assignment');$auxCode=$LASTEXITCODE
       Assert-That 'incomplete auxiliary lookup warns without blocking assignment' ($auxCode-eq0-and($aux-join' ')-match'EVENTS_INCOMPLETE:'-and(Get-State technical-choice)-eq'ACTIVE')
       $auxLib=Join-Path $t 'aux-lib';New-Item -ItemType Directory $auxLib|Out-Null;Copy-Item $co $auxLib
       # Select an absent store only for the auxiliary read; assignment still appends to its required journal.
       $proxy='param([string]$Root,[string]$Find,[int]$Top);if($Find){& ''__EVENTS__'' -Root (Join-Path $Root ''absent'') -Find $Find -Top $Top;exit $LASTEXITCODE};& ''__EVENTS__'' -Root $Root @args;exit $LASTEXITCODE'
       Set-Content (Join-Path $auxLib 'Events.ps1') ($proxy.Replace('__EVENTS__',$ev.Replace("'","''")))
       $aux=@(& pwsh -NoProfile -File (Join-Path $auxLib 'Coordinator.ps1') -Root $t -Assign technical-choice -Owner agent -Action 'retain assignment');$auxCode=$LASTEXITCODE
       Assert-That 'unavailable auxiliary lookup warns without blocking assignment' ($auxCode-eq0-and($aux-join' ')-match'EVENTS_UNAVAILABLE:'-and(Get-State technical-choice)-eq'ACTIVE')
   ```

   The resulting file's Git blob is 4304247fa9f131d74a9b53996e45ba7c71b28980.

17. Check whether `lib/README.md` contains `trustworthy answers v1`; if so record Already Applied when its Git blob is d7ec0399efcc633ee909eb96868e4520be20f911, and otherwise stop and report. Otherwise make exactly this one edit (trustworthy agent answers only), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
   does not make that old copy an execution entry.

   ```
   insert
   ```text
   Data root (trustworthy answers v1): Events, Spider, Pulse, Coordinator, Delegate and Watch-Subagents default `-Root` to
   `ORVION_DATA_ROOT`, else the sibling `..\ORVION-Owner-Tools` store when it has `events\`, else this checkout. A missing or
   damaged store is said, never answered as "nothing found": `EVENTS_UNAVAILABLE` (exit 3), `EVENTS_INCOMPLETE` (exit 2),
   `SPIDER_COVERAGE: incomplete` (exit 3), Pulse `last UNREADABLE` (exit 2). Hunt's `-Root` is still this checkout.

   ```

   The resulting file's Git blob is d7ec0399efcc633ee909eb96868e4520be20f911.

## Acceptance Criteria

- [x] Exact approved scoped output. check: blob:lib/Events.ps1=48d98858f32d8c056dd3143cf1a6ad0c65944f5b
- [x] Exact approved scoped output. check: blob:lib/Spider.ps1=da99c5987c00c848c79af43b6a5287a5d4dc4719
- [x] Exact approved scoped output. check: blob:lib/Pulse.ps1=463ca7334468942c75c3e68b725bcc8a5b7b7734
- [x] Exact approved scoped output. check: blob:lib/Coordinator.ps1=1b513b370580a9438dab27ee047752dda26e869f
- [x] Exact approved scoped output. check: blob:lib/Delegate.ps1=5b7c2f2a71167c05bac9602871ff473ae77a03e0
- [x] Exact approved scoped output. check: blob:lib/Watch-Subagents.ps1=627e6ca702ab73d79e27f5cacce1c230857480f8
- [x] Exact approved scoped output. check: blob:lib/Workbench.ps1=0b912913fdc219889a2c9b338931e136dd42d9f2
- [x] Exact approved scoped output. check: blob:lib/run_timed.ps1=4580b662d813fdb0104343f50d8260520401ec19
- [x] Exact approved scoped output. check: blob:tests.ps1=3df650aca5d3b3b5880e87eb2c41b82117033640
- [x] Exact approved scoped output. check: blob:lib/test-events.ps1=178145d5abc84e4144cd2085ad6da9c829c37a1d
- [x] Exact approved scoped output. check: blob:lib/test-spider.ps1=205ea50222c0308ce84a0062f63c10a9b34c8b44
- [x] Exact approved scoped output. check: blob:lib/test-pulse.ps1=83e5a9e3229c9df4b1fda5c9d8f0c76eb0e2f188
- [x] Exact approved scoped output. check: blob:lib/test-run-timed.ps1=33f15f6037f2fbe41b70474cd0ac1df2e859adb3
- [x] Exact approved scoped output. check: blob:lib/test-watch-host.ps1=53978799e8fea61a8151d24ee1109f9087529a4f
- [x] Exact approved scoped output. check: blob:lib/test-delegate.ps1=65a297f30a568231cf413255fb7a5b19d6c43252
- [x] Exact approved scoped output. check: blob:lib/test-coordinator.ps1=4304247fa9f131d74a9b53996e45ba7c71b28980
- [x] Exact approved scoped output. check: blob:lib/README.md=d7ec0399efcc633ee909eb96868e4520be20f911
- [x] The owning tests prove: a missing journal is EVENTS_UNAVAILABLE (exit 3) for Find and Brief, never "nothing recorded"; a damaged journal is EVENTS_INCOMPLETE (exit 2) with results still shown; the default root finds the sibling data store and ORVION_DATA_ROOT overrides it; all six data tools carry the one identical default; Spider reports a missing archive, journal or repository as UNAVAILABLE with SPIDER_COVERAGE exit 3; Pulse says a missing session index plainly and makes a damaged one UNREADABLE (exit 2); run_timed preserves the exit code in the requested directory and stops before the command when the directory or the log cannot be used; Spider, Delegate and Coordinator keep EVENTS_INCOMPLETE/EVENTS_UNAVAILABLE visible (Spider and Delegate exit 2/3, Coordinator still assigns); index damage is attributed to the index; the Watch-Host check writes only to its own fixture.
- [x] Mandatory V1/V2/V3, focused proof, planted-regression mutants, accepted literal replay controls and the real before/after measurement are preserved. One isolated native timed/watched Finish owns the full schedule with a fresh SANDBOX receipt before original approval; the original needs its own fresh Finish, live Review, native Complete and an independent carrying-range READY.

## Review Gate

- [x] Inspect the seventeen scoped files, the focused/mutant/literal evidence and the real before/after; preserve all frozen prior evidence.
- [x] Independently check the native receipt root/Draft/recipe/evaluator/fingerprint, ordered tests and timed/watcher/host exits; normal native Review/Complete and every new carrying transition must pass. No second-agent or provider certification is claimed.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Owner request of 2026-10-26 (decision D19 in C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\DECISIONS.md): make sure the tools really work and an agent can rely on them; consult Codex for gaps and choose what to fix. Under the owner's exceptional delegation this one Workbench contract is authorized. Gate 1 for this Draft is DELEGATED: the owner did not type its digest. Sandbox approval is synthetic and grants no original authority.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws017-package\assurance\V3\DRAFT.md
Approved SHA256: 2904BC39648B5C11D96BA4DA12B47A3051BC9662F12439B86E35D04FCA5A020B
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\GATE1-WS017-DELEGATED.md
Owner Evidence SHA256: E0C2621E5C04278FA13E922CEB44CF2B8E19D9384F2372C47D7B48242A3F092F
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws017-package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: C0995D6E41ED91AD75162D40CF8B27D030559065D03900EA6F969D6C63F1A785
Original admission: DELEGATED exact Gate 1 under the owner's exceptional delegation of 2026-10-26 (OWNER-DELEGATION.md SHA-256 94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217; decisions D1-D19; D19 is the owner request for this contract). The owner did not type this digest. Bound to this literal root, the exact V3 digest and the fresh sandbox receipt; no sandbox receipt transplant as original certification.
Original exact literal implementation applied by accepted native Workbench Execute. Declared filtered blobs match. Fresh root-bound original Finish and independent live Review remain required; sandbox success does not certify this root. This frozen Draft was not expanded.

## Verification Notes

Measured before freeze on the real workstation (real-before-after.json), same calls without -Root: Events -Find before "nothing recorded" exit 0, after 5 relevant patterns of 122; Spider before sessions 0 / events none exit 0, after 5 sessions (267 lines) and events; Pulse and Coordinator before UNREADABLE exit 2, after the live queue (17 owner items, 11 active). Run from a checkout with no sibling store the tools now say UNAVAILABLE (exit 3) instead of an empty answer. Codex tool audit (exceptional-delegation-20261026\codex-reports\tools-report.txt) rated Events, Spider, Sync-Sessions, run_timed and others UNRELIABLE for silent false success; this contract fixes the root cause it found first and the measured silent paths; the rest are deferred by name in Out of Scope. Twelve planted regressions are each detected (mutants.log); hazard scan 0; nine affected self-checks PASS. A pre-freeze Codex review (codex-review\review1-report.txt, FIX FIRST) found the Watch-Host check escaping its fixture and callers (Spider, Delegate, Coordinator) hiding incomplete reads; all five findings were fixed and pinned (review1-disposition.md). tests.ps1 previously guarded <checkout>\events\events.jsonl, a file that does not exist, so it guarded nothing; it now guards the real data-root journal and isolates ORVION_DATA_ROOT. Product git configs hold gh credential helpers that call gh auth token (no stored token; checked by key name only).
Verdict: Confirmed Complete
Reviewed Fingerprint: 0D689D32E001D47576B7CBDED247149E796A5AB5960ABAE88947017EF37084C3
Reviewed Receipt: CA94C7DB77003AA99792F232D2D69069EEAD863937E8EABE5253C0064EFA47A3
Evidence: fresh ORIGINAL root-bound timed/watched Finish, actual ordered-suite schedule/exits, approved exact outputs and independently pinned accepted-code live review. Runtime: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws017-package\runtime\original. No sandbox receipt transplant, remote parity, offsite recovery or equal-OS isolation claim.

## Selection reasons and sources

Evidence Refresh: focused-selected.log PASS for the nine affected self-checks on the selected bytes, twelve planted regressions detected, Codex FIX FIRST findings 1-5 fixed, hazard scan 0, real before/after measurement, literal replay controls run before the one sandbox Finish. Baseline f42860b (main = preflight), accepted judge 835E14DA unchanged.

Sources: DECISIONS.md D19, codex-reports\tools-report.txt, ws017-package\codex-review, accepted WORKFLOW/TEMPLATE/checker, WS-016 packet scripts, the real before/after measurement.
