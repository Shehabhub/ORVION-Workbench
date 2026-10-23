# Workbench Change Request - WS-003

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

## Objective

Make the existing Coordinator, Claude watchdog and reminder report only their actual evidence, refuse incomplete required queue state, mask known diagnostic secrets, and isolate direct-native context while retaining archival and existing tools.

## Baseline

86c7740611cc3d0a24f756085eb039912fb579d3

## Write Scope

- RESUME.md
- lib/Coordinator.ps1
- lib/test-coordinator.ps1
- lib/Watch-Subagents.ps1
- lib/test-watch-subagents.ps1
- lib/hooks/Watch-Reminder.ps1
- lib/test-watch-reminder.ps1
- lib/README.md
- WORKFLOW.md

## Out of Scope

Native product/trusted source, contracts, tests, profiles, receipts, release and remote state; WS001/WS002 history and kernel/checker/recipe/driver; archiver implementation and raw archives, global client configuration, new state registries/daemons/decision engines; generic management adapters and stage transport; cleanup/migration/workstation/Contract C, Batch6 and Phase8. RESUME authority body remains unchanged; only its own active pointer transitions are legal.

## Required Reading

Accepted WORKFLOW.md, lib/README.md and existing owning scripts/tests; V1-DESIGN.md; reused monitor-integration-review.json M4-M7 and current baseline-evidence.json; P3 G2c D/E/F/H. Reuse the own WS002 execution context and exact recipe enforcement. No whole programme re-research or product suite replay.

## Draft Assurance

V1: WS-OBSERVERS-R2-V1-DESIGN | 2026-10-23 | C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-observer-integrity-20261023-r2\V1-DESIGN.md | 12359308D9486428F270346C0D405E37FB406EC7B15F311C773E7EB2B4729B85
V2: WS-OBSERVERS-R2-V2-ADVERSARIAL | 2026-10-23 | C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-observer-integrity-20261023-r2\V2-DRAFT.md | E8D75B20996033FEC4A438EF88D07DB87EAAFFEA75DDCAC7C5BF5CF9BAE07660
V3: WS-OBSERVERS-R2-V3-REFRESH | 2026-10-23 | C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-observer-integrity-20261023-r2\V3-DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WS003r2
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WS003r2\tests
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WS003r2\temp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-observer-integrity-20261023-r2\runtime
PowerShell Version: 7.6.7
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Pre-Approval Evidence

Existing M4-M7 source hashes remain exact at baseline. Actual prototype callers prove positive and negative queue routing, corruption/missing/IO refusal and its success-on-corruption mutant; both watchdog output and its temporary journal mask a synthetic value crossing the truncation boundary, with one live stall/recovery/end notification sequence. Explicit session/selection and unsupported/missing evidence cases are exercised. Hook tests invoke the real adapter with disposable archive/Pulse stubs, proving native silence, preserved archival, exact Workbench opt-in, no quoted-runner false claim, bounded error output and honest late coverage. Earlier fixture failures remain in runtime/prototype; they are not certification. Full selected literal replay and normal-hook own sandbox Finish/Review/Complete are still required before delegated original approval.

R1's actual selected sandbox Finish failed its hazard scan on two reserved variable names. It was boundedly interrupted after that proven defect, preserving eight passing child-suite observations but no full-suite success/receipt. R2 preserves the failed packet/rehearsal, corrects names, runs the existing full candidate hazard scan before Draft construction, and repeats the changed watchdog/hook callers. Unchanged Coordinator evidence is reused. Own watcher run family workbench-finish prevents false cross-product timing comparisons without changing its engine or store. No original writes occurred under R1.

V3 refresh: official Claude Code hooks reference https://code.claude.com/docs/en/hooks confirms stdin JSON session/cwd/event and SessionStart/PostToolUse additional context. PostToolUse runs after the tool: it cannot establish prior live coverage. This reporting-only adapter does not implement client permission control. Existing measured transcript/launch shapes remain bounded compatibility evidence, not universal current-client support. No native tools or global settings change. The existing Sync-Sessions -Library owns masking; known-shape masking is not universal DLP. No future owner digest is falsely attributed to the owner; exact local approval is delegated under the actual exceptional instruction.

## Implementation Steps

1. Check whether `lib/Coordinator.ps1` contains `COORDINATOR_UNREADABLE`; if so record Already Applied when its Git blob is 118347c277451e98324fc526125ccd2cbac558b2, and otherwise stop and report. Otherwise make exactly these 6 edits (truthful scoped observer reporting without native interference), each matched once, and change nothing else:

   a) replace the lines
   ```text
   # The journal is the only state: every view is computed from it at read time, so there is no index to drift or rebuild.
   $bad=0;$records=@(if(Test-Path $log){foreach($l in [IO.File]::ReadAllLines($log)){if($l){try{$o=ConvertFrom-Json $l -DateKind String;if($o.pattern-and$o.at){$o}else{$bad++}}catch{$bad++}}}})
   ```
   with
   ```text
   # The journal is the only state: every view is computed from it at read time, so there is no index to drift or rebuild.
   ```

   b) immediately after the line
   ```text
   function ConvertTo-Utc([string]$s){$d=[DateTimeOffset]::Parse($s,[Globalization.CultureInfo]::InvariantCulture).UtcDateTime;if($s.Length-eq10){$d.AddDays(1).AddSeconds(-1)}else{$d}}
   ```
   insert
   ```text
   if($Due){try{$null=ConvertTo-Utc $Due}catch{throw 'COORDINATOR_DUE_INVALID: refused before journal writes'}}
   $bad=0;$readFault=$false
   $records=@(try{
       foreach($l in [IO.File]::ReadAllLines($log)){if($l.Trim()){try{
           $o=ConvertFrom-Json $l -DateKind String
           if(!$o.pattern-or!$o.at-or$o.summary-isnot[string]-or$o.status-notin'open','resolved','disproven','deferred','superseded'){throw 'invalid record'}
           $null=ConvertTo-Utc $o.at;if($o.due){$null=ConvertTo-Utc $o.due};$o
       }catch{$bad++}}}
   }catch{$readFault=$true})
   $incomplete=$readFault-or$bad-gt0
   # Viewing partial evidence is useful; acting on it would lose work. Never echo raw corrupt data or exception text.
   if($incomplete){
       'COORDINATOR_UNREADABLE: required journal evidence is incomplete; valid partial records follow.'
       if($Assign-or$Close-or$Dispatch){throw 'COORDINATOR_UNREADABLE: mutation refused before journal writes'}
   }
   ```

   c) replace the lines
   ```text
       $case=$own-or$dueText-or$z.category-eq'decision'-or$z.source-eq'delegate-road'-or$sev-eq'high'-or$last
       $state=if(!$case){'OBSERVATION'}elseif($z.category-eq'decision'-or$own-eq'owner'){'OWNER'}
   ```
   with
   ```text
       $cause=@($since.cause|Where-Object{$_})[-1]
       $ownerDecision=$own-eq'owner'-or$cause-eq'owner-decision'
       $case=$own-or$dueText-or$ownerDecision-or$z.category-eq'decision'-or$z.source-eq'delegate-road'-or$sev-eq'high'-or$last
       $state=if(!$case){'OBSERVATION'}elseif($ownerDecision){'OWNER'}
   ```

   d) replace the lines
   ```text
       foreach($i in @($items|Where-Object state -in 'ACTIVE','DISPATCHED'|Sort-Object last -Descending|Select-Object -First 2)){"         in flight: $($i.pattern) ($($i.owner)): $($i.action.Substring(0,[Math]::Min(260,$i.action.Length)))"}
       exit 0
   ```
   with
   ```text
       foreach($i in @($items|Where-Object state -in 'ACTIVE','DISPATCHED'|Sort-Object last -Descending|Select-Object -First 2)){"         in flight: $($i.pattern) ($($i.owner)): $($i.action.Substring(0,[Math]::Min(260,$i.action.Length)))"}
       exit $(if($incomplete){2}else{0})
   ```

   e) immediately after the line
   ```text
   foreach($i in $items){Format-QueueLine $i}
   ```
   insert
   ```text
   if($incomplete){exit 2}
   ```

   f) immediately after the line
   ```text
   if($Check-and$escalated.Count){exit 1}
   ```
   insert
   ```text
   exit 0
   ```

   The resulting file's Git blob is 118347c277451e98324fc526125ccd2cbac558b2.

2. Check whether `lib/test-coordinator.ps1` contains `required check cannot succeed over partial journal evidence`; if so record Already Applied when its Git blob is 1d0fa394a072b237ac12e69b0490f5bb63d509cf, and otherwise stop and report. Otherwise make exactly these 4 edits (truthful scoped observer reporting without native interference), each matched once, and change nothing else:

   a) replace the line
   ```text
       Assert-That 'a material item nobody took is UNOWNED, escalated, -Check fails' ((Get-State lynx-leak)-eq'UNOWNED'-and$LASTEXITCODE-eq1)
   ```
   with
   ```text
       $checkCode=$LASTEXITCODE
       Assert-That 'a material item nobody took is UNOWNED, escalated, -Check fails' ((Get-State lynx-leak)-eq'UNOWNED'-and$checkCode-eq1)
   ```

   b) immediately after the line
   ```text
       Assert-That 'a genuine decision waits on the owner and is not escalated as noise' ((Get-State owner-pick)-eq'OWNER'-and((@(& $co -Root $t -Brief)|Select-Object -Skip 1)-join' ')-notmatch'owner-pick')
   ```
   insert
   ```text
       Add-Event -Pattern technical-choice -Session s1 -Category decision -Cause confirmed -Summary 'use the existing parser' -Owner agent -Action 'prove the parser cases'
       Add-Event -Pattern unclassified-choice -Session s1 -Category decision -Cause hypothesis -Summary 'classify this finding'
       Add-Event -Pattern owner-assigned -Session s1 -Category observation -Summary 'owner must choose' -Owner owner -Action 'choose the commercial option'
       Assert-That 'technical decisions remain ACTIVE; unclassified material choices are UNOWNED; explicit owner assignment remains OWNER' ((Get-State technical-choice)-eq'ACTIVE'-and(Get-State unclassified-choice)-eq'UNOWNED'-and(Get-State owner-assigned)-eq'OWNER')
   ```

   c) immediately after the line
   ```text
       Assert-That 'acting on an item that is not open is refused' $(try{& $co -Root $t -Assign no-such -Owner agent -Action x|Out-Null;$false}catch{"$_"-match'COORDINATOR_NO_OPEN_ITEM'})
   ```
   insert
   ```text
       $validJournal=Join-Path $t 'events\events.jsonl';$validHash=(Get-FileHash $validJournal).Hash
       $invalidDue=try{& $co -Root $t -Assign technical-choice -Owner agent -Action x -Due not-a-date|Out-Null;$false}catch{"$_"-match'COORDINATOR_DUE_INVALID'}
       Assert-That 'new assignments cannot poison a valid journal with an invalid due date' ($invalidDue-and(Get-FileHash $validJournal).Hash-eq$validHash)
   ```

   d) immediately after the line
   ```text
       Assert-That 'a torn line is skipped and counted; the record after it survives' ($q-match'journal: 1 unreadable line\(s\) skipped'-and(Get-State after-tear)-eq'UNOWNED')
   ```
   insert
   ```text
       & $co -Root $t -Check|Out-Null
       Assert-That 'required check cannot succeed over partial journal evidence' ($LASTEXITCODE-eq2)
       & $co -Root $t -Brief|Out-Null
       Assert-That 'brief retains its incomplete-evidence exit' ($LASTEXITCODE-eq2)
       $journal=Join-Path $t 'events\events.jsonl';$before=(Get-FileHash $journal).Hash
       $refused=0
       foreach($kind in 'assign','close','dispatch'){
           try{switch($kind){
               assign {& $co -Root $t -Assign after-tear -Owner agent -Action x|Out-Null}
               close {& $co -Root $t -Close after-tear -Status resolved -Reason x|Out-Null}
               dispatch {& $co -Root $t -Dispatch after-tear -Question x|Out-Null}
           }}catch{if("$_"-match'COORDINATOR_UNREADABLE'){$refused++}}
       }
       Assert-That 'all three mutation doors refuse incomplete evidence before appending or dispatching' ($refused-eq3-and(Get-FileHash $journal).Hash-eq$before)
       $empty=Join-Path $t 'empty';New-Item -ItemType Directory "$empty\events" -Force|Out-Null
       [IO.File]::WriteAllText("$empty\events\events.jsonl",'')
       & $co -Root $empty -Check|Out-Null
       Assert-That 'an explicit empty valid journal is a successful empty case' ($LASTEXITCODE-eq0)
       & $co -Root (Join-Path $t 'absent') -Check|Out-Null
       Assert-That 'absent required journal is UNREADABLE, never an empty success' ($LASTEXITCODE-eq2)
       [IO.File]::WriteAllText("$empty\events\events.jsonl",'{"pattern":"bad-date","at":"not-a-date","status":"open","summary":"synthetic"}')
       $dateOut=@(& $co -Root $empty -Check)-join' '
       Assert-That 'invalid record dates are counted without throwing raw record data' ($LASTEXITCODE-eq2-and$dateOut-match'COORDINATOR_UNREADABLE'-and$dateOut-notmatch'not-a-date')
       $held=[IO.File]::Open("$empty\events\events.jsonl",'Open','ReadWrite','None')
       try{& $co -Root $empty -Check|Out-Null;$heldCode=$LASTEXITCODE}finally{$held.Dispose()}
       Assert-That 'unreadable journal IO cannot return success' ($heldCode-eq2)
       # Causal mutant: removing this required-check refusal changes the very observation above to success.
       $mutant=Join-Path $t 'Coordinator-mutant.ps1'
       $body=[IO.File]::ReadAllText($co);$needle='if($incomplete){exit 2}'
       if(!$body.Contains($needle)){throw 'COORDINATOR_MUTANT_ANCHOR_MISSING'}
       [IO.File]::WriteAllText($mutant,$body.Replace($needle,'if($false){exit 2}'))
       & $mutant -Root $empty -Check|Out-Null
       Assert-That 'the incomplete-evidence detector kills its success-on-corruption mutant' ($LASTEXITCODE-eq0)
   ```

   The resulting file's Git blob is 1d0fa394a072b237ac12e69b0490f5bb63d509cf.

3. Check whether `lib/Watch-Subagents.ps1` contains `WATCHDOG_SESSION_REQUIRED`; if so record Already Applied when its Git blob is a2ff0cf1e62b907485e9af9b0f5d0d1da968dd21, and otherwise stop and report. Otherwise make exactly these 15 edits (truthful scoped observer reporting without native interference), each matched once, and change nothing else:

   a) replace the lines
   ```text
   #   STALLED <id>    its newest entry is a tool call with no result for -StallMinutes (an unseen approval
   #                   prompt, or a hung command); names the tool and its input
   ```
   with
   ```text
   #   STALLED <id>    its newest entry is a tool call with no result for -StallMinutes; cause UNPROVEN
   ```

   b) replace the lines
   ```text
   # -Once prints every agent's state and exits (2 when any is stalled). Read-only.
   param([string]$Session,[double]$StallMinutes=3,[double]$IdleMinutes=8,[int]$PollSeconds=15,[switch]$Once,[string[]]$Only,[switch]$SinceStart)
   ```
   with
   ```text
   # Explicit Claude transcript session only. Never guesses the latest session or another client's format.
   # -Once prints selected states and exits 2 on a stall or incomplete evidence. Reads transcripts; alarms append Events.
   param([string]$Session,[ValidateRange(0.001,10080)][double]$StallMinutes=3,[ValidateRange(0.001,10080)][double]$IdleMinutes=8,
         [ValidateRange(1,3600)][int]$PollSeconds=15,[switch]$Once,[string[]]$Only,[switch]$SinceStart,
         [string]$EventRoot=(Split-Path $PSScriptRoot -Parent))
   ```

   c) replace the line
   ```text
   $Only=@($Only|ForEach-Object{$_-split','}|ForEach-Object{$_.Trim()}|Where-Object{$_})
   ```
   with
   ```text
   $Only=@($Only|ForEach-Object{$_-split','}|ForEach-Object{$_.Trim()}|Where-Object{$_}|Sort-Object -Unique)
   if(@($Only|Where-Object{$_-notmatch'^[A-Za-z0-9_-]+$'}).Count){throw 'WATCHDOG_SELECTOR_INVALID'}
   if(!$Session){throw 'WATCHDOG_SESSION_REQUIRED: supply an explicit Claude session directory or exact ID'}
   ```

   d) replace the lines
   ```text
   if(!$Session){$Session=(Get-ChildItem $proj -Recurse -Directory -Filter subagents|Sort-Object LastWriteTime -Descending|Select-Object -First 1).Parent.FullName}
   elseif(!(Test-Path -LiteralPath $Session)){$Session=(Get-ChildItem $proj -Recurse -Directory -Filter $Session|Select-Object -First 1).FullName}
   if(!$Session){throw 'NO_SESSION'}
   ```
   with
   ```text
   if(![IO.Path]::IsPathFullyQualified($Session)){
       if($Session-notmatch'^[A-Za-z0-9_-]+$'){throw 'WATCHDOG_SESSION_INVALID'}
       $sessionMatches=@(if(Test-Path -LiteralPath $proj){Get-ChildItem -LiteralPath $proj -Directory|ForEach-Object{Get-ChildItem -LiteralPath $_.FullName -Directory -Filter $Session}|Where-Object Name -eq $Session})
       if($sessionMatches.Count-ne1){throw 'WATCHDOG_SESSION_UNRESOLVED: exact session ID must resolve once'}
       $Session=$sessionMatches[0].FullName
   }
   if(!(Test-Path -LiteralPath $Session -PathType Container)){throw 'WATCHDOG_SESSION_UNRESOLVED'}
   $Session=[IO.Path]::GetFullPath($Session)
   for($ancestor=Get-Item -LiteralPath $Session;$ancestor;$ancestor=$ancestor.Parent){if($ancestor.Attributes-band[IO.FileAttributes]::ReparsePoint){throw 'WATCHDOG_SESSION_REPARSE_REFUSED'}}
   ```

   e) immediately after the line
   ```text
   $dir=Join-Path $Session 'subagents'
   ```
   insert
   ```text
   # Reuse the established bounded masking vocabulary, before truncating a diagnostic. Library mode never archives.
   . (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $EventRoot
   ```

   f) replace the line
   ```text
       $last=Get-LastEntry $Transcript.FullName;if(!$last){return $null};$e=$last.Entry
   ```
   with
   ```text
       if($Transcript.Attributes-band[IO.FileAttributes]::ReparsePoint){$last=$null}else{try{$last=Get-LastEntry $Transcript.FullName}catch{$last=$null}}
       if(!$last-or!$last.Entry.message-or$null-eq$last.Entry.message.content){return [pscustomobject]@{Id=$Transcript.BaseName-replace'^agent-','';State='UNREADABLE';Quiet=0;What='WATCHDOG_TRANSCRIPT_UNREADABLE'}};$e=$last.Entry
   ```

   g) replace the lines
   ```text
       $c=@($e.message.content);$tool=@($c|Where-Object{$_.type-eq'tool_use'})|Select-Object -Last 1
       $text=(@($c|Where-Object{$_.type-eq'text'}|ForEach-Object{$_.text})-join' ')
   ```
   with
   ```text
       $c=@($e.message.content);$tool=@($c|Where-Object{$_.type-eq'tool_use'})|Select-Object -Last 1
   ```

   h) replace the line
   ```text
       $what=if($tool){$j=($tool.input|ConvertTo-Json -Compress -Depth 4)-replace'\s+',' ';"$($tool.name) $($j.Substring(0,[Math]::Min(160,$j.Length)))"}else{''}
   ```
   with
   ```text
       $what=if($tool){$j=Hide-Secret ("$($tool.name) "+($tool.input|ConvertTo-Json -Compress -Depth 20));$j=$j-replace'\s+',' ';$j.Substring(0,[Math]::Min(160,$j.Length))}else{''}
   ```

   i) replace the line
   ```text
   $last=@{};$alarm=@{};$anyStall=$false
   ```
   with
   ```text
   $last=@{};$alarm=@{};$anyStall=$false;$anyUnreadable=$false
   ```

   j) replace the line
   ```text
       $files=@(if(Test-Path -LiteralPath $dir){Get-ChildItem -LiteralPath $dir -Filter 'agent-*.jsonl'})
   ```
   with
   ```text
       $scanFault=$false
       try{
           if((Test-Path -LiteralPath $dir)-and((Get-Item -LiteralPath $dir).Attributes-band[IO.FileAttributes]::ReparsePoint)){throw 'reparse'}
           $files=@(if(Test-Path -LiteralPath $dir){Get-ChildItem -LiteralPath $dir -File -Filter 'agent-*.jsonl'})
       }catch{$scanFault=$true;$files=@()}
   ```

   k) replace the lines
   ```text
       $watched=@()
       foreach($f in $files){
           $s=Get-AgentState $f;if(!$s){continue}
           if($Only.Count-and$s.Id-notin$Only){continue}
           $watched+=$s
   ```
   with
   ```text
       $watched=@(foreach($f in $files){
           $id=$f.BaseName-replace'^agent-',''
           if($Only.Count-and$id-notin$Only){continue}
           Get-AgentState $f
       })
       $missing=@($Only|Where-Object{$_-notin$watched.Id})
       if($Once-or((Get-Date)-$started).TotalMinutes-ge$StallMinutes){
           foreach($id in $missing){$watched+=[pscustomobject]@{Id=$id;State='UNREADABLE';Quiet=0;What='WATCHDOG_SELECTED_TRANSCRIPT_MISSING'}}
           if(!$watched.Count-or$scanFault){$watched+=[pscustomobject]@{Id='session';State='UNREADABLE';Quiet=0;What='WATCHDOG_SESSION_EVIDENCE_UNREADABLE'}}
       }
       foreach($s in $watched){
   ```

   l) replace the line
   ```text
           $kind=if($s.State-eq'TOOL'-and$s.Quiet-ge$StallMinutes){'STALLED'}elseif($s.State-in'WORKING','TOOL'-and$s.Quiet-ge$IdleMinutes){'IDLE'}else{$null}
   ```
   with
   ```text
           $kind=if($s.State-eq'UNREADABLE'){'UNREADABLE'}elseif($s.State-eq'TOOL'-and$s.Quiet-ge$StallMinutes){'STALLED'}elseif($s.State-in'WORKING','TOOL'-and$s.Quiet-ge$IdleMinutes){'IDLE'}else{$null}
   ```

   m) replace the lines
   ```text
               if($kind-eq'STALLED'){$anyStall=$true;"STALLED $($s.Id): waiting $($s.Quiet) min on $($s.What) - stop it and fix the cause (permission scope or a hung command)"
                   try{$null=& (Join-Path $PSScriptRoot 'Events.ps1') -Add -Pattern agent-stall-unseen-approval -Source watchdog -Category failure -Severity high -Session (Split-Path $Session -Leaf) -Summary "agent $($s.Id) waited $StallMinutes+ min on $($s.What)" -Tags 'background subagent agent stuck hang waiting permission prompt'}catch{$null=$_}}  # improvement memory, never at the cost of the watch
   ```
   with
   ```text
               if($kind-eq'STALLED'){$anyStall=$true;"STALLED $($s.Id): waiting $($s.Quiet) min on $($s.What); cause UNPROVEN. Investigate the owned run before any intervention."
                   try{$null=& (Join-Path $PSScriptRoot 'Events.ps1') -Root $EventRoot -Add -Pattern agent-tool-wait-cause-unproven -Source watchdog -Category failure -Severity high -Cause hypothesis -Session (Split-Path $Session -Leaf) -Summary "agent $($s.Id) waited $StallMinutes+ min on $($s.What); cause UNPROVEN" -Tags 'background subagent tool wait stall liveness'}catch{$anyUnreadable=$true;'WATCHDOG_JOURNAL_UNREADABLE: alarm evidence was not recorded'}}
               elseif($kind-eq'UNREADABLE'){$anyUnreadable=$true;"UNREADABLE $($s.Id): $($s.What)"}
   ```

   n) replace the line
   ```text
       if($Once){exit $(if(@($watched|Where-Object{$_.State-eq'TOOL'-and$_.Quiet-ge$StallMinutes}).Count){2}else{0})}
   ```
   with
   ```text
       if($Once){exit $(if(@($watched|Where-Object{$_.State-eq'UNREADABLE'-or($_.State-eq'TOOL'-and$_.Quiet-ge$StallMinutes)}).Count){2}else{0})}
   ```

   o) replace the line
   ```text
       if($watched.Count-ge$expected-and!$open.Count){"ALL FINISHED: $($watched.Count) agent(s)";exit $(if($anyStall){2}else{0})}
   ```
   with
   ```text
       if($watched.Count-ge$expected-and!$open.Count){"ALL FINISHED: $($watched.Count) agent(s)";exit $(if($anyStall-or$anyUnreadable){2}else{0})}
   ```

   The resulting file's Git blob is a2ff0cf1e62b907485e9af9b0f5d0d1da968dd21.

4. Check whether `lib/test-watch-subagents.ps1` contains `whole tool diagnostics are masked before truncation`; if so record Already Applied when its Git blob is c0e44dc1a50ff9e9a1cea34cf90c14864466233b, and otherwise stop and report. Otherwise make exactly these 2 edits (truthful scoped observer reporting without native interference), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
   ```
   insert
   ```text
   $watch=Join-Path $PSScriptRoot 'Watch-Subagents.ps1';$eventRoot=Join-Path $t 'memory';$live=$null
   $savedProfile=$env:USERPROFILE
   ```

   b) replace the line
   ```text
   }finally{[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
       $env:USERPROFILE=Join-Path $t 'profile'
       $noSession=@(& pwsh -NoProfile -File $watch -Once 2>&1)-join' '
       Assert-That 'missing session refuses instead of choosing an implicit latest transcript' ($LASTEXITCODE-ne0-and$noSession-match'WATCHDOG_SESSION_REQUIRED')
       foreach($branch in 'p1','p2'){New-Item -ItemType Directory (Join-Path $env:USERPROFILE ".claude\projects\$branch\same-session\subagents") -Force|Out-Null}
       $ambiguous=@(& pwsh -NoProfile -File $watch -Session same-session -Once 2>&1)-join' '
       Assert-That 'an ambiguous exact session ID refuses' ($LASTEXITCODE-ne0-and$ambiguous-match'WATCHDOG_SESSION_UNRESOLVED')
       $unsafe=@(& pwsh -NoProfile -File $watch -Session '*' -Once 2>&1)-join' '
       Assert-That 'wildcard session selectors refuse' ($LASTEXITCODE-ne0-and$unsafe-match'WATCHDOG_SESSION_INVALID')
       $dedup=@(& pwsh -NoProfile -File $watch -Session (Join-Path $t 'sess') -Only done,done -Once)
       Assert-That 'duplicate selected IDs are observed once' ($LASTEXITCODE-eq0-and$dedup.Count-eq1-and$dedup[0]-match'^done FINISHED')
       New-Agent unreadable @('{not-json')
       New-Agent wrongclient @('{"type":"response_item","payload":{"role":"assistant"}}')
       New-Agent malformed @('{"type":"assistant"}')
       $bad=@(& pwsh -NoProfile -File $watch -Session (Join-Path $t 'sess') -Only unreadable,wrongclient,malformed,absent -Once)-join' '
       Assert-That 'unparseable, unsupported, malformed and missing selected transcripts stay visible and non-success' ($LASTEXITCODE-eq2-and@([regex]::Matches($bad,' UNREADABLE ')).Count-eq4)
       New-Agent torn @('{"type":"assistant","message":{"content":[],"stop_reason":"end_turn"}}','{"type":')
       $tail=@(& pwsh -NoProfile -File $watch -Session (Join-Path $t 'sess') -Only torn -Once)-join' '
       Assert-That 'a trailing incomplete append preserves the latest complete conversation entry' ($LASTEXITCODE-eq0-and$tail-match'torn FINISHED')
       $token='ghp_'+('Ab2C3dEf4G5hI6jK7L8mN9oP0qR1sT2uV3wX'.Substring(0,36))
       $tool=@{type='assistant';message=@{stop_reason='tool_use';content=@(@{type='tool_use';name='PowerShell';input=@{pad=('x'*122);token=$token}})}}|ConvertTo-Json -Compress -Depth 8
       New-Agent secret @($tool) 10
       $masked=@(& pwsh -NoProfile -File $watch -Session (Join-Path $t 'sess') -Only secret -Once)-join' '
       Assert-That 'whole tool diagnostics are masked before truncation across its boundary' ($LASTEXITCODE-eq2-and$masked.Contains('<masked>')-and!$masked.Contains($token.Substring(0,10)))
       $stdout=Join-Path $t 'live.log';$stderr=Join-Path $t 'live.err'
       $live=Start-Process pwsh -ArgumentList "-NoProfile -File `"$watch`" -Session `"$t\sess`" -Only secret -PollSeconds 1 -EventRoot `"$eventRoot`"" -PassThru -WindowStyle Hidden -RedirectStandardOutput $stdout -RedirectStandardError $stderr
       function Read-LiveOutput{
           if(!(Test-Path $stdout)){return ''}
           $stream=[IO.File]::Open($stdout,'Open','Read','ReadWrite');$reader=[IO.StreamReader]::new($stream)
           try{$reader.ReadToEnd()}finally{$reader.Dispose()}
       }
       function Wait-Output([string]$Pattern){
           $deadline=[DateTime]::UtcNow.AddSeconds(20)
           do{if((Read-LiveOutput)-match$Pattern){return $true};if($live.HasExited){return $false};Start-Sleep -Milliseconds 100}while([DateTime]::UtcNow-lt$deadline)
           $false
       }
       if(!(Wait-Output 'STALLED secret')){throw 'WATCHDOG_TEST_STALL_NOT_OBSERVED'}
       Start-Sleep -Milliseconds 1200 # one unchanged poll: proves notification deduplication
       New-Agent secret @($u)
       if(!(Wait-Output 'RECOVERED secret')){throw 'WATCHDOG_TEST_RECOVERY_NOT_OBSERVED'}
       New-Agent secret @('{"type":"assistant","message":{"content":[],"stop_reason":"end_turn"}}')
       if(!$live.WaitForExit(20000)){throw 'WATCHDOG_TEST_EXIT_TIMEOUT'}
       $liveText=[IO.File]::ReadAllText($stdout);$journal=Join-Path $eventRoot 'events\events.jsonl';$journalText=[IO.File]::ReadAllText($journal)
       Assert-That 'a live stall alarms once, recovers, finishes, and preserves its observed failure exit' ($live.ExitCode-eq2-and@([regex]::Matches($liveText,'(?m)^STALLED secret')).Count-eq1-and$liveText-match'RECOVERED secret'-and$liveText-match'ALL FINISHED')
       Assert-That 'stdout and one temporary event both mask before storage and do not invent cause or kill authority' (!$liveText.Contains($token.Substring(0,10))-and!$journalText.Contains($token.Substring(0,10))-and$journalText.Contains('<masked>')-and@([IO.File]::ReadAllLines($journal)).Count-eq1-and$liveText-match'cause UNPROVEN'-and$liveText-notmatch'stop it and fix')
       Assert-That 'the observer library never started archival or created session data' (!(Test-Path (Join-Path $eventRoot 'sessions')))
   }finally{
       $env:USERPROFILE=$savedProfile
       if($live-and!$live.HasExited){Stop-Process -Id $live.Id -Force;$live.WaitForExit()}
       $resolved=[IO.Path]::GetFullPath($t);if(!$resolved.StartsWith([IO.Path]::GetTempPath(),[StringComparison]::OrdinalIgnoreCase)-or(Split-Path $resolved -Leaf)-notlike'orvion-wscheck-*'){throw 'WATCHDOG_TEST_CLEANUP_BOUNDARY'}
       [IO.Directory]::Delete($resolved,$true)
   }
   ```

   The resulting file's Git blob is c0e44dc1a50ff9e9a1cea34cf90c14864466233b.

5. Check whether `lib/hooks/Watch-Reminder.ps1` contains `explicitTool`; if so record Already Applied when its Git blob is 2d2b9d764f7c745da442704e4763ab7887d958d8, and otherwise stop and report. Otherwise make exactly these 12 edits (truthful scoped observer reporting without native interference), each matched once, and change nothing else:

   a) replace the line
   ```text
   # Claude Code hook (machine-local agent tooling): makes sure every agent knows and uses the ORVION watchers.
   ```
   with
   ```text
   # Claude Code reporting adapter: Workbench context is opt-in; native product entry stays independent.
   ```

   b) replace the line
   ```text
       $hookEvent=if($e){$e.hook_event_name}else{'SessionStart'}
   ```
   with
   ```text
       if(!$e-or!$e.hook_event_name){throw 'HOOK_INPUT_INVALID'}
       $hookEvent=$e.hook_event_name
   ```

   c) replace the line
   ```text
       if($cwd-notlike"$env:USERPROFILE\Documents\GitHub\*"-and$cwd-notlike"$env:USERPROFILE\Documents\ORVION-*"){exit 0}
   ```
   with
   ```text
       $workbench=Split-Path $lib -Parent
       $workbenchEntry=[IO.Path]::GetFullPath($cwd).TrimEnd('\')-eq[IO.Path]::GetFullPath($workbench).TrimEnd('\')
       $archiveScope=$workbenchEntry-or$cwd-like"$env:USERPROFILE\Documents\GitHub\*"-or$cwd-like"$env:USERPROFILE\Documents\ORVION-*"
       # Parse command structure without executing it. A mention, variable or quoted command payload does not opt in.
       $explicitTool=$false;$timedCommand=$null
       if($hookEvent-eq'PostToolUse'-and$e.tool_name-in'PowerShell','Bash'){
           $parseErrors=$null;$tokens=$null
           $ast=[Management.Automation.Language.Parser]::ParseInput("$($e.tool_input.command)",[ref]$tokens,[ref]$parseErrors)
           if(!$parseErrors){foreach($cmd in $ast.FindAll({param($n)$n-is[Management.Automation.Language.CommandAst]},$true)){
               $name=$cmd.GetCommandName();if(!$name-or[IO.Path]::GetFileNameWithoutExtension($name)-notin'pwsh','powershell'){continue}
               $elements=$cmd.CommandElements
               for($i=1;$i-lt$elements.Count-1;$i++){
                   if($elements[$i]-is[Management.Automation.Language.CommandParameterAst]-and$elements[$i].ParameterName-eq'File'-and($elements[$i+1]-is[Management.Automation.Language.StringConstantExpressionAst]-or$elements[$i+1]-is[Management.Automation.Language.ExpandableStringExpressionAst])){
                       $file=$elements[$i+1].Value
                       if($file-match'(?:^|[\\/])run_timed\.ps1$'-and!$timedCommand){$timedCommand=$cmd}
                       if($elements[$i+1]-is[Management.Automation.Language.StringConstantExpressionAst]-and[IO.Path]::IsPathFullyQualified($file)){
                           $file=[IO.Path]::GetFullPath($file)
                           if($file.StartsWith($lib.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)-and$file.EndsWith('.ps1',[StringComparison]::OrdinalIgnoreCase)-and(Test-Path -LiteralPath $file -PathType Leaf)){$explicitTool=$true}
                       }
                   }
               }
           }}
       }
   ```

   d) replace the lines
   ```text
           if($hookEvent-eq'SessionStart'){$Text;return}
           @{hookSpecificOutput=@{hookEventName=$hookEvent;additionalContext=$Text}}|ConvertTo-Json -Compress -Depth 4
   ```
   with
   ```text
           $safe=& {param($Value,$Library,$Workspace) . (Join-Path $Library 'Sync-Sessions.ps1') -Library -Root $Workspace;Hide-Secret $Value} $Text $lib $workbench
           if($hookEvent-eq'SessionStart'){$safe;return}
           @{hookSpecificOutput=@{hookEventName=$hookEvent;additionalContext=$safe}}|ConvertTo-Json -Compress -Depth 4
   ```

   e) immediately after the line
   ```text
       if($hookEvent-in'SessionStart','SessionEnd'){
   ```
   insert
   ```text
           if(!$archiveScope){exit 0}
   ```

   f) immediately after the line
   ```text
           if($hookEvent-eq'SessionEnd'){exit 0}
   ```
   insert
   ```text
           if(!$workbenchEntry){exit 0} # archival preserves knowledge; it never enrolls a native session in Workbench
   ```

   g) immediately after the lines
   ```text
           Send-Context ("ORVION AGENT TOOLS exist at $lib (index: README.md). Use them; never hand-write an alarm loop.`n"+$always.Replace('<lib>',$lib)+"`n"+$events+"`nBefore a task: pwsh -NoProfile -File `"$lib\Events.ps1`" -Find '<task in a few words>'. Record a failure, discovery or decision worth keeping with Events.ps1 -Add. Past sessions (task, size, tools, errors, SPECs, raw path): $(Split-Path $lib -Parent)\sessions\INDEX.md.")
           exit 0
       }
   ```
   insert
   ```text
       if(!$workbenchEntry-and!$explicitTool){exit 0}
   ```

   h) immediately after the line
   ```text
       if($hookEvent-eq'PostToolUse'-and$e.tool_name-in'Agent','Task'-and($in.run_in_background-or$r.isAsync-or$r.status-eq'async_launched')){
   ```
   insert
   ```text
           if("$($e.session_id)"-notmatch'^[A-Za-z0-9_-]+$'-or($r.agentId-and"$($r.agentId)"-notmatch'^[A-Za-z0-9_-]+$')){Send-Context 'WATCHDOG_UNREADABLE: explicit supported Claude session/agent identity is required; never guess the latest transcript.';exit 0}
   ```

   i) replace the line
   ```text
           Send-Context ("WATCHDOG REQUIRED: you launched a background agent. Start the Monitor tool now (timeout_ms 1800000, re-arm on expiry) with: pwsh -NoProfile -File `"$lib\Watch-Subagents.ps1`" -Session $($e.session_id)$only. On STALLED stop the agent and fix the cause (a tool call outside the working directories waits on an unseen approval). Read-only agents should use Read/Grep/Glob, not shell.")
   ```
   with
   ```text
           Send-Context ("WATCHDOG REQUIRED for this explicit Claude session: pwsh -NoProfile -File `"$lib\Watch-Subagents.ps1`" -Session $($e.session_id)$only. Use one owned observer. STALLED proves a tool wait, not its cause or permission to kill. Investigate under the subject's native authority; report unreadable evidence. This adapter does not observe another client's transcript format.")
   ```

   j) replace the lines
   ```text
       if($e.tool_name-in'PowerShell','Bash'-and"$($in.command)"-match'run_timed\.ps1'){
           $c="$($in.command)"
   ```
   with
   ```text
       if($timedCommand){
           $c=$timedCommand.Extent.Text
   ```

   k) replace the lines
   ```text
           $run=if($c-match'-Finish'){'finish-control'}elseif($c-match'test_agent_continuity'){'control-suite'}else{'timed-run'}
           $bg=if($in.run_in_background){''}else{' run_timed blocks in the foreground, so a watcher cannot follow it live: start it with run_in_background next time.'}
           Send-Context ("WATCHER REQUIRED: you started a timed run. Start the Monitor tool now (timeout_ms 1800000, re-arm on expiry) with: pwsh -NoProfile -File `"$watch`" -Log `"$log`" -Run $run -Brief. For a heavy run, or two at once, also Monitor: pwsh -NoProfile -File `"$lib\Watch-Host.ps1`" -WatchPid <runner pid from the watcher's first line> -ExitWhenPidsGone.$bg")
   ```
   with
   ```text
           $run=if($c-match'Workbench\.ps1.*-Finish'){'workbench-finish'}elseif($c-match'-Finish'){'finish-control'}elseif($c-match'test_agent_continuity'){'control-suite'}else{'timed-run'}
           $bg=if($in.run_in_background){'Attach while the runner is live.'}else{'This post-tool event may arrive after a foreground run ended. Late attachment cannot prove live coverage; preserve the gap, and never repeat an expensive run without native justification.'}
           Send-Context ("WATCHER REQUIRED: reuse the one native observer for this run; if absent while live: pwsh -NoProfile -File `"$watch`" -Log `"$log`" -Run $run -Brief. For heavy concurrent runs reuse one shared host observer over their owned PIDs: `"$lib\Watch-Host.ps1`" -WatchPid <owned runner PIDs> -ExitWhenPidsGone. Report transitions/blockers; routine heartbeat at most every five minutes. $bg")
   ```

   l) replace the line
   ```text
       try{$log=Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'work\hook-errors.log';[IO.File]::AppendAllText($log,"$([DateTime]::UtcNow.ToString('o')) $($hookEvent) $($_.Exception.Message)`n")}catch{$null=$_}
   ```
   with
   ```text
       # Stable diagnostic only: exception messages/input may contain credentials. This reporter is never a native gate.
       try{$errDir=Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'work';[IO.Directory]::CreateDirectory($errDir)|Out-Null;[IO.File]::AppendAllText((Join-Path $errDir 'hook-errors.log'),"$([DateTime]::UtcNow.ToString('o')) WATCH_REMINDER_UNREADABLE`n")}catch{$null=$_}
       [Console]::Error.WriteLine('WATCH_REMINDER_UNREADABLE: reporting failed; consult the native authority, not an inferred success.')
   ```

   The resulting file's Git blob is 2d2b9d764f7c745da442704e4763ab7887d958d8.

6. Check whether `lib/test-watch-reminder.ps1` contains `direct-native SessionStart archives without Owner-Tools context`; if so record Already Applied when its Git blob is 3f273bdf642d81bf6b8f0247c157c3a3ffe832d0, and otherwise stop and report. Otherwise make exactly these 4 edits (truthful scoped observer reporting without native interference), each matched once, and change nothing else:

   a) replace the lines
   ```text
   # Self-check for hooks\Watch-Reminder.ps1's timed-run reminder: a rooted run_timed path names the watch_run beside it;
   # a path built from variables, or a session folder that is not a repository, never yields a watcher path that does not
   # exist (measured 2026-10-20: it printed ORVION-Owner-Tools\scripts\watch_run.ps1 and an unexpanded $E3 log).
   ```
   with
   ```text
   # Real hook callers in a disposable workspace. Bounded archive/Pulse stubs never start a real follower or journal.
   ```

   b) replace the lines
   ```text
   $hook=Join-Path $PSScriptRoot 'hooks\Watch-Reminder.ps1'
   $t=Join-Path ([IO.Path]::GetTempPath()) "orvion-hookcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory "$t\repo\scripts" -Force|Out-Null
   function Invoke-Hook([string]$Command,[string]$Cwd){
       $e=@{hook_event_name='PostToolUse';tool_name='PowerShell';cwd=$Cwd;tool_input=@{command=$Command;run_in_background=$true};tool_response=@{}}|ConvertTo-Json -Depth 4 -Compress
       $o=$e|& pwsh -NoProfile -File $hook;if(!$o){return ''};("$o"|ConvertFrom-Json).hookSpecificOutput.additionalContext
   ```
   with
   ```text
   $t=Join-Path ([IO.Path]::GetTempPath()) "orvion-hookcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))"
   $savedProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
   $ws=Join-Path $env:USERPROFILE 'Documents\GitHub\OwnerTools';$lib=Join-Path $ws 'lib';$native=Join-Path $env:USERPROFILE 'Documents\GitHub\Native'
   New-Item -ItemType Directory "$lib\hooks","$t\repo\scripts",$native -Force|Out-Null
   $hook=Join-Path $lib 'hooks\Watch-Reminder.ps1';Copy-Item (Join-Path $PSScriptRoot 'hooks\Watch-Reminder.ps1') $hook
   $sync=Join-Path $PSScriptRoot 'Sync-Sessions.ps1'
   $stub=@'
   param([switch]$Library,[string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quiet,[switch]$Follow)
   if($Library){. '__SYNC__' -Library -Root $Root;return}
   @{pid=$PID;follow=[bool]$Follow}|ConvertTo-Json -Compress|Add-Content (Join-Path (Split-Path $PSScriptRoot -Parent) 'archive.calls')
   '@
   [IO.File]::WriteAllText((Join-Path $lib 'Sync-Sessions.ps1'),$stub.Replace('__SYNC__',$sync.Replace("'","''")))
   Set-Content (Join-Path $lib 'Pulse.ps1') "Add-Content (Join-Path (Split-Path `$PSScriptRoot -Parent) 'pulse.calls') 'pulse';'STUB-PULSE'"
   Set-Content (Join-Path $lib 'README.md') "## Always`nSTUB-TOOLS`n## Next`n"
   Set-Content "$t\repo\scripts\watch_run.ps1" '#'
   Set-Content (Join-Path $lib 'run_timed.ps1') '#'
   Set-Content (Join-Path $lib 'watch_run.ps1') '#'
   function Invoke-Event($HookInput){$HookInput|ConvertTo-Json -Depth 8 -Compress|& pwsh -NoProfile -File $hook}
   function Invoke-Hook([string]$Command,[string]$Cwd,[bool]$Background=$true){
       $out=Invoke-Event @{hook_event_name='PostToolUse';tool_name='PowerShell';cwd=$Cwd;tool_input=@{command=$Command;run_in_background=$Background};tool_response=@{}}
       if(!$out){return ''};("$out"|ConvertFrom-Json).hookSpecificOutput.additionalContext
   }
   function Wait-Archive([int]$Count){
       $path=Join-Path $ws 'archive.calls';$deadline=[DateTime]::UtcNow.AddSeconds(15)
       do{
           $rows=@(if(Test-Path $path){try{Get-Content $path|ForEach-Object{$_|ConvertFrom-Json}}catch{}})
           if($rows.Count-ge$Count){foreach($row in $rows){try{$child=Get-Process -Id $row.pid -ErrorAction Stop;if(!$child.WaitForExit(5000)){throw 'HOOK_STUB_EXIT_TIMEOUT'}}catch [Microsoft.PowerShell.Commands.ProcessCommandException]{}};return $rows}
           Start-Sleep -Milliseconds 100
       }while([DateTime]::UtcNow-lt$deadline)
       throw 'HOOK_ARCHIVE_STUB_TIMEOUT'
   ```

   c) replace the lines
   ```text
   try{
       Set-Content "$t\repo\scripts\watch_run.ps1" '#'
       # the hook stays silent outside the ORVION workspace, so the session folder is a real workspace path
       $ws=Split-Path $PSScriptRoot -Parent
   ```
   with
   ```text
   try{
   ```

   d) replace the lines
   ```text
       Assert-That 'a path built from variables yields no invented watcher path, and the log is flagged' ($c.Contains('<the folder of the run_timed.ps1 you started>')-and$c.Contains('expand the variables')-and!$c.Contains("$ws\scripts\watch_run.ps1"))
   }finally{[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
       Assert-That 'variables yield no invented watcher path and the log is flagged' ($c.Contains('<the folder of the run_timed.ps1 you started>')-and$c.Contains('expand the variables')-and!$c.Contains("$ws\scripts\watch_run.ps1"))
       $nativeStart=@(Invoke-Event @{hook_event_name='SessionStart';cwd=$native;session_id='native-session'});$rows=@(Wait-Archive 1)
       Assert-That 'direct-native SessionStart archives without Owner-Tools context or Pulse' (!$nativeStart.Count-and$rows.Count-eq1-and$rows[0].follow-and!(Test-Path (Join-Path $ws 'pulse.calls')))
       $nativeCommand="pwsh -NoProfile -File `"$t\repo\scripts\run_timed.ps1`" -Log `"C:\logs\a.log`" -Command native"
       Assert-That 'native timed commands stay under native tools without Workbench reminders' (!(Invoke-Hook $nativeCommand $native))
       $workbenchStart=@(Invoke-Event @{hook_event_name='SessionStart';cwd=$ws;session_id='workbench-session'})-join' ';$rows=@(Wait-Archive 2)
       Assert-That 'Workbench SessionStart receives one index/Pulse with separate archival' ($workbenchStart-match'STUB-TOOLS'-and$workbenchStart-match'STUB-PULSE'-and@(Get-Content (Join-Path $ws 'pulse.calls')).Count-eq1-and$rows.Count-eq2)
       $explicit="pwsh -NoProfile -File `"$lib\run_timed.ps1`" -Log `"C:\logs\b.log`" -Command native"
       $c=Invoke-Hook $explicit $native
       Assert-That 'an explicit existing Owner-Tools File command opts in for that event' ($c.Contains("$lib\watch_run.ps1")-and$c-match'one shared host observer')
       $ownFinish=Invoke-Hook ($explicit.Replace('-Command native','-Command "pwsh -File lib/Workbench.ps1 -Finish"')) $ws
       Assert-That 'own Workbench timing uses its own run family instead of native product history' ($ownFinish-match'-Run workbench-finish')
       $mention="Write-Output 'pwsh -File `"$lib\run_timed.ps1`" -Log C:\logs\b.log'"
       Assert-That 'mere command text/path mentions do not opt in native sessions' (!(Invoke-Hook $mention $native))
       Assert-That 'a quoted runner mention is not reported as a started run even at Workbench entry' (!(Invoke-Hook $mention $ws))
       $missing=@(Invoke-Event @{hook_event_name='PostToolUse';tool_name='Agent';cwd=$ws;tool_input=@{run_in_background=$true};tool_response=@{isAsync=$true;agentId='a1'}})-join' '
       Assert-That 'missing background identity is UNREADABLE, never implicit latest' ($missing-match'WATCHDOG_UNREADABLE'-and$missing-notmatch' -Session ')
       $agent=@(Invoke-Event @{hook_event_name='PostToolUse';tool_name='Agent';cwd=$ws;session_id='s1';tool_input=@{run_in_background=$true};tool_response=@{isAsync=$true;agentId='a1'}})-join' '
       Assert-That 'background guidance binds actual session/agent without inventing cause or kill authority' ($agent-match'-Session s1 -Only a1'-and$agent-match'not its cause or permission to kill'-and$agent-notmatch'On STALLED stop')
       $c=Invoke-Hook $explicit $ws $false
       Assert-That 'foreground completion cannot be relabeled as live coverage or require an unearned replay' ($c-match'Late attachment cannot prove live coverage'-and$c-match'never repeat an expensive run'-and$c-match'five minutes')
       $end=@(Invoke-Event @{hook_event_name='SessionEnd';cwd=$native});$rows=@(Wait-Archive 3)
       Assert-That 'native SessionEnd keeps its final one-shot archive without Workbench context' (!$end.Count-and$rows.Count-eq3-and!$rows[2].follow)
       $other=@(Invoke-Event @{hook_event_name='SessionStart';cwd=(Join-Path $t 'unrelated')})
       Assert-That 'unrelated sessions stay quiet and start no archiver' (!$other.Count-and@(Get-Content (Join-Path $ws 'archive.calls')).Count-eq3)
       $secret='ghp_'+('Ab2C3dEf4G5hI6jK7L8mN9oP0qR1sT2uV3wX'.Substring(0,36))
       $bad=@("{bad $secret"|& pwsh -NoProfile -File $hook 2>&1)-join' ';$code=$LASTEXITCODE
       $errorText=Get-Content (Join-Path $ws 'work\hook-errors.log') -Raw
       Assert-That 'malformed input reports a stable error without raw values or a false gate verdict' ($bad-match'WATCH_REMINDER_UNREADABLE'-and!$bad.Contains($secret)-and$errorText-match'WATCH_REMINDER_UNREADABLE'-and!$errorText.Contains($secret)-and$code-eq0)
   }finally{
       $env:USERPROFILE=$savedProfile
       $resolved=[IO.Path]::GetFullPath($t);if(!$resolved.StartsWith([IO.Path]::GetTempPath(),[StringComparison]::OrdinalIgnoreCase)-or(Split-Path $resolved -Leaf)-notlike'orvion-hookcheck-*'){throw 'HOOK_TEST_CLEANUP_BOUNDARY'}
       [IO.Directory]::Delete($resolved,$true)
   }
   ```

   The resulting file's Git blob is 3f273bdf642d81bf6b8f0247c157c3a3ffe832d0.

7. Check whether `lib/README.md` contains `Incomplete/missing/unreadable journal`; if so record Already Applied when its Git blob is 910a3dcf9688004ff6da4d7d4f5848bd431d69ea, and otherwise stop and report. Otherwise make exactly these 4 edits (truthful scoped observer reporting without native interference), each matched once, and change nothing else:

   a) replace the lines
   ```text
   | Any heavy run, or two at once | `pwsh -NoProfile -File <lib>\Watch-Host.ps1 -WatchPid <runner pid> -ExitWhenPidsGone` | when the runners exit |
   | Any background agent | `pwsh -NoProfile -File <lib>\Watch-Subagents.ps1 -Session <session id> -SinceStart` | ALL FINISHED |
   ```
   with
   ```text
   | Any heavy run, or two at once | one shared `pwsh -NoProfile -File <lib>\Watch-Host.ps1 -WatchPid <owned runner PIDs> -ExitWhenPidsGone` | when the runners exit |
   | Explicit Claude background agents | `pwsh -NoProfile -File <lib>\Watch-Subagents.ps1 -Session <exact session ID or absolute directory> -Only <agent IDs>` (or `-SinceStart`) | ALL FINISHED |
   ```

   b) replace the lines
   ```text
   On `STALLED`: stop the agent, fix the cause (usually a tool call outside the working directories needs an
   unseen approval), relaunch. On `COMMIT LOW`: stop the newest heavy run. On `PRESSURE`: expect slowdown only.
   Read-only background agents: use Read/Grep/Glob, not shell commands, so no approval is ever needed.
   ```
   with
   ```text
   `STALLED` proves an unanswered tool wait; its cause remains UNPROVEN. Investigate the owned subject under native
   authority before intervention. `UNREADABLE` is missing evidence, never a healthy state. Watch-Subagents requires an
   explicit Claude session and refuses ambiguous/unsafe selectors; it does not guess the latest session or parse Codex.
   It masks known credential shapes using the existing Sync-Sessions library before truncating any tool diagnostic.
   Stalls append one event per transition; `-EventRoot` selects a disposable journal for tests. It never kills or retries.
   `COMMIT LOW` is actionable resource evidence: apply the owning run's recovery policy; it does not grant authority to
   kill unrelated work. `PRESSURE` reports slowdown risk. Reuse an existing observer instead of starting a duplicate.
   Report state changes, receipts and blockers immediately; routine long-gate heartbeat is at most every five minutes.
   Own Workbench Finish uses watcher `-Run workbench-finish`; native product Finish retains `finish-control`. These are
   distinct comparable run families in the existing timing history, not new stores or separate monitoring engines.
   ```

   c) replace the lines
   ```text
   Enforced on this machine by a user-level Claude Code hook (`~/.claude/settings.json` -> `hooks\Watch-Reminder.ps1`):
   every session starts with this table; launching a background agent or a `run_timed.ps1` run injects the exact
   command to monitor it. Agents that do not read Claude hooks (Codex, other machines) get the rule only once the
   wave-2 tooling contract tracks these tools in each repository and names them in `AGENTS.md`.
   ```
   with
   ```text
   The user-level Claude hook (`hooks\Watch-Reminder.ps1`) is a reporting adapter, never enforcement or approval.
   At the actual Workbench root SessionStart supplies this index/Pulse; a direct-native session receives no Workbench
   context. An explicit existing absolute Owner-Tools `-File` command opts in for that event only; mere mentions and
   unresolved variables do not. Archival remains separate at session start/end. Native README/AGENTS/Boot and native
   tools govern direct entry; neither product acquires an Owner-Tools dependency. No global client setting is changed.
   A post-tool reminder cannot prove prior live coverage: attach while the runner is alive; retain any coverage gap
   instead of automatically rerunning an expensive test. General management/observer-handle integration remains pending.
   ```

   d) replace the line
   ```text
   | `Coordinator.ps1` / `-Brief` / `-Check` / `-Assign` / `-Close` / `-Dispatch` | the coordinator over every tool: reads the one journal (events) and holds each open item to an owner, a next action and a due time (TRIAGE, OVERDUE, OWNER, DISPATCHED, READY); hunts nothing, closes nothing without a recorded reason |
   ```
   with
   ```text
   | `Coordinator.ps1` / `-Brief` / `-Check` / `-Assign` / `-Close` / `-Dispatch` | one event-journal view: UNOWNED, OVERDUE, OWNER, DISPATCHED, ACTIVE; observations remain quiet. Explicit Owner=owner or Cause=owner-decision routes owner choices; technical decisions can remain ACTIVE. Incomplete/missing/unreadable journal returns UNREADABLE/exit 2 with valid partial diagnostics; mutation refuses before writes. Explicit empty journal is valid. Hunts/certifies nothing. |
   ```

   The resulting file's Git blob is 910a3dcf9688004ff6da4d7d4f5848bd431d69ea.

8. Check whether `WORKFLOW.md` contains `Observer integrity:`; if so record Already Applied when its Git blob is b16ba2ef2951603fbd04ff01ffd19aacf1251ece, and otherwise stop and report. Otherwise make exactly this one edit (truthful scoped observer reporting without native interference), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
   Review is a live observation: check every actual criterion, inspect timed runner/watcher final exits and fresh receipt, record Confirmed Complete and DONE/None, then use the read-only Review check. Complete verifies those facts again and prepares only its own status/pointer edits. Stage exact paths and commit normally; independently judge the entire carrying range before declaring local completion. No local-only result means publication, promotion or remote certification.

   ```
   insert
   ```text
   Observer integrity: Coordinator derives the one event journal, retains valid partial diagnostics but returns UNREADABLE/exit 2 for incomplete required evidence and refuses assignment/closure/dispatch before writes. Technical decisions do not become owner decisions merely by category. Watch-Subagents requires an explicit supported Claude session, masks with the existing library before truncation, exposes missing/unreadable evidence and reports tool-wait cause as UNPROVEN; it never kills, retries or certifies. The optional Watch-Reminder supplies Workbench context only at this root or for an explicit existing Owner-Tools command in that event. Direct-native entry remains independent; archival preserves knowledge separately. These are reporting adapters, not authenticated approval, OS enforcement or a completed general management interface. Reuse one run observer and one shared host observer; report actionable changes immediately and routine long-gate heartbeat at most every five minutes. A late reminder cannot prove earlier live coverage or justify an expensive replay.

   ```

   The resulting file's Git blob is b16ba2ef2951603fbd04ff01ffd19aacf1251ece.

## Acceptance Criteria

- [x] All8 exact literal outputs match their declared blobs; no replacement observer/queue/masking engine is introduced.
- [x] RESUME authority body remains unchanged; check: normalized-resume:RESUME.md=72C0F8CEF1A08BA4EF511A3CF103CFF9C550672712E418323842518B384431A1
- [x] Coordinator retains partial valid diagnostics but required queue reads/Brief return UNREADABLE/exit2 for corruption, missing file, unreadable IO or invalid dates; explicit empty valid journal passes.
- [x] Assignment/closure/dispatch refuses incomplete evidence before writes; invalid new due dates cannot poison a valid journal. The causal refusal mutant is detected.
- [x] Existing owner-decision cause/explicit owner routes OWNER; confirmed owned technical decisions stay ACTIVE, unclassified material decisions UNOWNED. Prior resolutions, due, delegation-return and recurrence remain covered.
- [x] Watchdog requires explicit unambiguous supported Claude identity; unsafe selectors refuse, duplicate IDs do not multiply observers, and unreadable/unsupported/missing selected evidence is visible and non-success.
- [x] Existing whole-line masking runs before diagnostic truncation, printing and event storage; actual synthetic live wait alarms once, recovers and finishes with its truthful failure history. No automatic kill/retry or invented cause.
- [x] Direct-native start/post-tool receives no Workbench context; actual Workbench root or explicit existing absolute Owner-Tools command opts in per event. Archival startup/end remains independent and no real follower is started by tests.
- [x] Hook protocol/quoted command parsing/error diagnostics are truthful; foreground post-tool does not claim live coverage or mandate expensive replay. Existing native per-run and shared host monitors are reused with five-minute routine heartbeat.
- [x] Own exact selected sandbox full timed/watched Finish and independent native Review/Complete/range pass; original later produces a distinct fresh matching-recipe receipt. Historical evidence/native product state stays preserved.

## Review Gate

- [x] Inspect all actual criteria, exact output blobs, independent selected sandbox receipt, original recipe/fingerprint/role, timed runner/watcher exits and fresh original receipt.
- [x] Inspect full normal-hook carrying range, clean source and preserved unsuccessful prototypes/history; no unproven client support, authentication, OS non-bypassability or full management claim.
- [x] Reuse existing P3 G2c as the sole remaining acceptance map; CTRL19 remains OPEN, Batch6/Phase8 held, no native product or remote modification.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Draft preparation only. Append exact selected approval/root and actual lifecycle evidence. Original Approval also names the immutable successful sandbox receipt and digest. Never transplant it as the original receipt.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-observer-integrity-20261023-r2\V3-DRAFT.md
Approved SHA256: 4AA6A0007400939DB501ED37B6766321B3D2A45F0BB7663C95456F8C2B9F98DA
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-observer-integrity-20261023-r2\runtime\original\approval-binding.txt
Owner Evidence SHA256: 969CD3BA79CF918591F11D525795512FC9CE7298133E381E6B7FC671AF22DAD2
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-observer-integrity-20261023-r2\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: DCA62E70CBD397193A334596E948058E09C2420F37F25060A9F5E52B20E91B84
Original literal8 outputs applied through the accepted native Workbench entry, all declared blobs match. Fresh own timed/watched full Finish still required.

## Verification Notes

No original execution or Review yet. Append observed Verdict: Confirmed Complete, Reviewed Fingerprint and Reviewed Receipt only after fresh native evidence.
Verdict: Confirmed Complete
Reviewed Fingerprint: BA9CFA22E7A24249568726EF92A2465B3AE3D14C442A81097AD8BEC3E0AFC7C6
Reviewed Receipt: EEB72D1E730A9A6447B98AD7994DAE43B62F7136C55B403CDB15E694C489299E
Evidence: actual Original root, exact8 outputs, full real owning suite, actual timed/watched exits, matching role/recipe/Draft and independent live review. Runtime: C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-observer-integrity-20261023-r2\runtime\original. Synthetic fixture results are dispatch proof only; this root owns its distinct full Finish. No product/remote/recovery or equal-OS security claim.

## Notes

One earned P3 observer-integrity dependency, not the general management interface. The optional client hook cannot force an equal-privilege agent to comply; native repository scripts/contracts remain correctness authority. Watchdog supports the explicit measured Claude transcript shape, not Codex. Partial append tails remain tolerable when a complete conversation entry exists. Existing masks have bounded known-shape/default exceptions. CI/WORKSTATION remain unsupported/fail-closed; no cleanup or speculative product scope. V2 non-selected assurance snapshot uses a zero self-reference placeholder; selected V3 binds its computed artifact digest externally.
