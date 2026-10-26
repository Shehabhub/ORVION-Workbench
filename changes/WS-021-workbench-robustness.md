# Workbench Change Request - WS-021

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

## Objective

Make the Workbench observers robust: Test-ScriptHazards groups variable spellings by the nearest function scope so independent functions no longer collide falsely while same-scope collisions stay caught; Hunt parses the session index once and reports malformed or unreadable rows as BUG index-unreadable with a count instead of crashing, keeping index-dependent findings unresolved while the index is incomplete; Pulse guards process/host discovery (running UNREADABLE, exit 2) and caps its output at 4096 characters with diagnostics, counts and pointers first and an exact more line; the SessionStart hook runs Pulse as a child with redirected files and a 6 s deadline, kills the owned tree on expiry and reports live state UNREADABLE, and caps its context at 8192.

## Baseline

e1b71a4bc288e56d7ceaa924c40aca2c2caa4e21

## Write Scope

- RESUME.md
- lib/Test-ScriptHazards.ps1
- lib/Hunt.ps1
- lib/Pulse.ps1
- lib/hooks/Watch-Reminder.ps1
- lib/test-events.ps1
- lib/test-hunt.ps1
- lib/test-pulse.ps1
- lib/test-watch-reminder.ps1
- lib/README.md

## Out of Scope

All other engineering paths except native allocation/status/pointer bookkeeping. No checker (Test-WorkbenchChange.ps1), applier, workflow, WORKFLOW.md, TEMPLATE, GitHub setting, user setting or product repository change. No change to which events the hook handles or to archiving. RESUME.md content beyond native bookkeeping is not changed. Deferred: Hunt baseline, Finish watcher binding, observer timeouts. CTRL-19 stays OPEN; Batch 6/Phase 8 stay ON HOLD; C2 stays UNPROVEN.

## Draft Assurance

V1: WS021-ROBUSTNESS-DESIGN | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws021-package\assurance\V1\DRAFT.md | A8F9DD5F3223E1690396F02284D043166EFA77E864FE182B735BAD1071E4F235
V2: WS021-ROBUSTNESS-ADVERSARIAL | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws021-package\assurance\V2\DRAFT.md | CD05733E57F5AEC3DEFC8CAF0D3E438D565DAB92338E2FDD33F69DCFF9683AD3
V3: WS021-ROBUSTNESS-REFRESH | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws021-package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSrob21
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSrob21\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSrob21\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws021-package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/Test-ScriptHazards.ps1` contains `FunctionDefinitionAst`; if so record Already Applied when its Git blob is 3fabb69ff73b1c886b20000442351c90e2cc0a45, and otherwise stop and report. Otherwise make exactly this one edit (Workbench robustness only), each matched once, and change nothing else:

   a) replace the line
   ```text
       foreach($g in ($vars|Group-Object{$_.VariablePath.UserPath.ToLowerInvariant()})){
   ```
   with
   ```text
       foreach($g in ($vars|Group-Object{
           $variableScope=$_.Parent
           while($variableScope-and$variableScope-isnot[Management.Automation.Language.FunctionDefinitionAst]){$variableScope=$variableScope.Parent}
           $scopeOffset=if($variableScope){$variableScope.Extent.StartOffset}else{-1}
           "$scopeOffset`:$($_.VariablePath.UserPath.ToLowerInvariant())"
       })){
   ```

   The resulting file's Git blob is 3fabb69ff73b1c886b20000442351c90e2cc0a45.

2. Check whether `lib/Hunt.ps1` contains `index-unreadable`; if so record Already Applied when its Git blob is 37266499d16b0ee196f70391c5232fcc0dc21cc5, and otherwise stop and report. Otherwise make exactly these 4 edits (Workbench robustness only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   $ix=Join-Path $DataRoot 'sessions\index.jsonl';$bad=@()
   if(Test-Path $ix){foreach($l in [IO.File]::ReadAllLines($ix)|Where-Object{$_}){
       $r=$l|ConvertFrom-Json;$p=Join-Path $DataRoot $r.raw
       if(!(Test-Path -LiteralPath $p)){$bad+="$($r.id): raw file missing";continue}
       $f=Get-Item -LiteralPath $p;$idle=([DateTime]::UtcNow-$f.LastWriteTimeUtc).TotalMinutes-ge20
       if($idle-and($r.bytes-ne$f.Length-or$r.metaBytes-ne$f.Length)){$bad+="$($r.id): index says $($r.bytes)/$($r.metaBytes) bytes, file has $($f.Length)"}
   }}else{Add-Finding GAP index-missing 'sessions\index.jsonl does not exist (run Sync-Sessions.ps1)'}
   ```
   with
   ```text
   $ix=Join-Path $DataRoot 'sessions\index.jsonl';$bad=@();$ids=@{}
   $indexIncomplete=$false;$indexMalformed=0;$indexReadFault=$false;$indexCheckFaults=0
   try{$indexExists=Test-Path -LiteralPath $ix -ErrorAction Stop}catch{$indexExists=$true;$indexReadFault=$true}
   if($indexExists){
       try{if($indexReadFault){throw 'index path unreadable'};$indexLines=[IO.File]::ReadAllLines($ix)}catch{$indexReadFault=$true;$indexIncomplete=$true;$indexLines=@()}
       foreach($l in $indexLines){
           if([string]::IsNullOrWhiteSpace($l)){continue}
           try{
               $r=$l|ConvertFrom-Json -DateKind String -NoEnumerate
               if($r-isnot[pscustomobject]-or$r.id-isnot[string]-or[string]::IsNullOrWhiteSpace($r.id)-or$r.raw-isnot[string]-or[string]::IsNullOrWhiteSpace($r.raw)){throw 'invalid index row'}
               $p=Join-Path $DataRoot $r.raw
           }catch{$indexMalformed++;$indexIncomplete=$true;continue}
           $ids[$r.id]=1
           try{
               if(!(Test-Path -LiteralPath $p -PathType Leaf)){$bad+="$($r.id): raw file missing";continue}
               $f=Get-Item -LiteralPath $p;$idle=([DateTime]::UtcNow-$f.LastWriteTimeUtc).TotalMinutes-ge20
               if($idle-and($r.bytes-ne$f.Length-or$r.metaBytes-ne$f.Length)){$bad+="$($r.id): index says $($r.bytes)/$($r.metaBytes) bytes, file has $($f.Length)"}
           }catch{$indexCheckFaults++;$indexIncomplete=$true}
       }
       if($indexIncomplete){
           $indexDiagnostic=if($indexReadFault){'row count unknown (index file read failed)'}else{"$indexMalformed malformed row(s)$(if($indexCheckFaults){"; $indexCheckFaults raw file check(s) unreadable"})"}
           Add-Finding BUG index-unreadable $indexDiagnostic 'index session unreadable malformed'
       }
   }else{$indexIncomplete=$true;Add-Finding GAP index-missing 'sessions\index.jsonl does not exist (run Sync-Sessions.ps1)'}
   ```

   b) replace the lines
   ```text
   foreach($lg in 'sync-errors.log'){$p=Join-Path $DataRoot "work\$lg";if((Test-Path $p)-and(Get-Item $p).Length){Add-Finding BUG $lg.Replace('.log','') "the session archiver logged $(@(Get-Content $p).Count) failure(s); last: $(@(Get-Content $p -Tail 1)[0])" 'archive sync error file failed'}}
   $ids=@{};if(Test-Path $ix){foreach($l in [IO.File]::ReadAllLines($ix)|Where-Object{$_}){$ids[($l|ConvertFrom-Json).id]=1}}
   ```
   with
   ```text
   foreach($lg in 'sync-errors.log'){$p=Join-Path $DataRoot "work\$lg";if((Test-Path $p)-and(Get-Item $p).Length){Add-Finding BUG $lg.Replace('.log','') "the session archiver logged $(@(Get-Content $p).Count) failure(s); last: $(@(Get-Content $p -Tail 1)[0])" 'archive sync error file failed'}}
   ```

   c) replace the line
   ```text
   $orphan=@($events|Where-Object{$_.session-and$_.session-notlike'hunter-*'-and!$ids[$_.session]-and$_.session-notin$lost}|ForEach-Object session|Select-Object -Unique)
   ```
   with
   ```text
   $orphan=@(if(!$indexIncomplete){$events|Where-Object{$_.session-and$_.session-notlike'hunter-*'-and!$ids[$_.session]-and$_.session-notin$lost}|ForEach-Object session|Select-Object -Unique})
   ```

   d) immediately after the line
   ```text
       foreach($g in @($events|Where-Object{$_.pattern-like'hunt-*'}|Group-Object pattern)){
   ```
   insert
   ```text
           if($indexIncomplete-and$g.Name-match'^hunt-(index-|lesson-raw-missing$)'){continue}
   ```

   The resulting file's Git blob is 37266499d16b0ee196f70391c5232fcc0dc21cc5.

3. Check whether `lib/Pulse.ps1` contains `$pulseLimit=4096`; if so record Already Applied when its Git blob is 74eea48b9f0b7909e912816eb955c404fc9863d5, and otherwise stop and report. Otherwise make exactly these 6 edits (Workbench robustness only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   function Get-GitLine{param([string]$Repo)$o=& git -C $Repo @args 2>$null;if($LASTEXITCODE){throw "git $($args-join' ')"};"$o".Trim()}
   ```
   insert
   ```text
   $pulseOwnerLines=@()
   $pulseLines=@(. {
   ```

   b) replace the line
   ```text
   $procs=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'"|Where-Object{$_.CommandLine})
   ```
   with
   ```text
   try{
   $procs=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'" -ErrorAction Stop|Where-Object{$_.CommandLine})
   ```

   c) replace the line
   ```text
   $os=Get-CimInstance Win32_OperatingSystem
   ```
   with
   ```text
   $os=Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
   if(!$os-or$null-eq$os.FreePhysicalMemory-or$null-eq$os.FreeVirtualMemory){throw 'host evidence unavailable'}
   ```

   d) immediately after the line
   ```text
   "running  archiver $(if($follow){"following (pid $($follow[0].ProcessId))"}else{'NOT running (start a session or: Sync-Sessions.ps1 -Follow)'}); timed runs: $(if($timed){$timed-join' | '}else{'none'}); host: $([math]::Round($os.FreePhysicalMemory/1MB,1)) GB free, commit headroom $([math]::Round($os.FreeVirtualMemory/1MB,1)) GB"
   ```
   insert
   ```text
   }catch{$pulseUnreadable=$true;'running  UNREADABLE (process/host discovery failed)'}
   ```

   e) replace the line
   ```text
       foreach($w in $waiting){"         - $($w.pattern): $($w.summary.Substring(0,[Math]::Min(150,$w.summary.Length)))$(if($w.summary.Length-gt150){'...'})"}
   ```
   with
   ```text
       $pulseOwnerLines=@(foreach($w in $waiting){"         - $($w.pattern): $($w.summary.Substring(0,[Math]::Min(150,$w.summary.Length)))$(if($w.summary.Length-gt150){'...'})"})
       $pulseOwnerLines
   ```

   f) immediately after the line
   ```text
   "tools    Coordinator.ps1 | Spider.ps1 '<anything>' (all sources) | Events.ps1 -Find '<task>' | Delegate.ps1 -List | Hunt.ps1 | sessions\INDEX.md | lib\README.md"
   ```
   insert
   ```text
   })
   if($pulseUnreadable){$pulseLines=@($pulseLines[0],'state    UNREADABLE (required live evidence incomplete)')+@($pulseLines|Select-Object -Skip 1)}
   # Select before rendering: keep diagnostics/counts/pointers, then the snapshot's urgent detail order.
   # Mask complete lines before any new abbreviation; the library is isolated from Pulse's variables.
   $pulseSafeLines=@(& {
       param($Lines,$Library,$Data)
       . (Join-Path $Library 'Sync-Sessions.ps1') -Library -Root $Data
       foreach($line in $Lines){Hide-Secret $line}
   } $pulseLines $PSScriptRoot $Root)
   $pulseOwnerSet=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
   foreach($line in $pulseOwnerLines){[void]$pulseOwnerSet.Add($line)}
   $pulseRows=@();$pulseAbbreviated=$false
   for($lineIndex=0;$lineIndex-lt$pulseLines.Count;$lineIndex++){
       $text=[string]$pulseSafeLines[$lineIndex];$ownerDetail=$pulseOwnerSet.Contains([string]$pulseLines[$lineIndex])
       $priority=if($text-match'^ORVION PULSE|^state\s'){0}elseif($text-match'^(waiting|cases|tools)\s'){1}elseif(!$ownerDetail-and$text-match'^(repo|running|last|queue)\s.*UNREADABLE'){2}
           elseif($text-match'^last\s|^         in flight:'){3}elseif($text-match'^(repo|running|hunt)\s'){4}elseif($ownerDetail){6}else{5}
       if($text.Length-gt1024){
           $pulseAbbreviated=$true
           $archiveOffset=$text.IndexOf('; archive: ',[StringComparison]::Ordinal)
           if($text-match'^last\s'-and$archiveOffset-ge0){
               $archiveTail=$text.Substring($archiveOffset)
               $text='last     session detail abbreviated'+$(if($archiveTail.Length-lt700){$archiveTail}else{'; archive: sessions\INDEX.md under the selected data root'})
           }else{$text=$text.Substring(0,250)+'... (detail abbreviated)'+$(if($text-match'UNREADABLE'){' UNREADABLE'})}
       }
       $pulseRows+=,[pscustomobject]@{Index=$lineIndex;Text=$text;Priority=$priority;Owner=$ownerDetail}
   }
   $pulseLimit=4096-[Environment]::NewLine.Length
   $pulseText=$pulseRows.Text-join"`n"
   if($pulseText.Length-gt$pulseLimit-or$pulseAbbreviated){
       $coordinatorCommand="pwsh -NoProfile -File '"+(Join-Path $PSScriptRoot 'Coordinator.ps1').Replace("'","''")+"' -Root '"+$Root.Replace("'","''")+"'"
       # Extremely long caller paths get an explicit same-Root template rather than a cut, misleading command.
       if($coordinatorCommand.Length-gt1000){$coordinatorCommand='Coordinator.ps1 -Root <same Root supplied to Pulse>'}
       $footerReserve="more     $($pulseOwnerLines.Count) more owner wait(s); $($pulseRows.Count) more entries total; $coordinatorCommand"
       $available=$pulseLimit-$footerReserve.Length-1;$used=0;$ownerFull=$false
       $selected=[Collections.Generic.HashSet[int]]::new()
       foreach($row in $pulseRows|Sort-Object Priority,Index){
           if($row.Owner-and$ownerFull){continue}
           if($used+$row.Text.Length+1-le$available){[void]$selected.Add($row.Index);$used+=$row.Text.Length+1}
           elseif($row.Owner){$ownerFull=$true}
       }
       $shown=@($pulseRows|Where-Object{$selected.Contains($_.Index)})
       $omittedOwners=$pulseOwnerLines.Count-@($shown|Where-Object Owner).Count
       $footer="more     $omittedOwners more owner wait(s); $($pulseRows.Count-$shown.Count) more entries total; $coordinatorCommand"
       $pulseText=(@($shown.Text)+@($footer))-join"`n"
   }
   $pulseText
   ```

   The resulting file's Git blob is 74eea48b9f0b7909e912816eb955c404fc9863d5.

4. Check whether `lib/hooks/Watch-Reminder.ps1` contains `WaitForExit(6000)`; if so record Already Applied when its Git blob is 1df0de9a1618ce8fc2a99430bbf38bab38204ced, and otherwise stop and report. Otherwise make exactly this one edit (Workbench robustness only), each matched once, and change nothing else:

   a) replace the lines
   ```text
           $events=(& (Join-Path $lib 'Pulse.ps1') -Root $dataRoot)-join"`n"  # one voice: Pulse owns live state, owner decisions and the newest lessons
           Send-Context ("ORVION AGENT TOOLS exist at $lib (index: README.md). Use them; never hand-write an alarm loop.`n"+$always.Replace('<lib>',$lib)+"`n"+$events+"`nBefore a task: pwsh -NoProfile -File `"$lib\Events.ps1`" -Find '<task in a few words>'. Record a failure, discovery or decision worth keeping with Events.ps1 -Add. Past sessions (task, size, tools, errors, SPECs, raw path): $dataRoot\sessions\INDEX.md.")
   ```
   with
   ```text
           # File redirection avoids a full pipe blocking Pulse before its deadline. Only this child tree is owned here.
           $pulseTemp=Join-Path ([IO.Path]::GetTempPath()) ('orvion-pulse-'+[guid]::NewGuid().ToString('N'))
           $pulseOut=$pulseTemp+'.out';$pulseErr=$pulseTemp+'.err';$pulseChild=$null
           try{
               $pulseChild=Start-Process pwsh -ArgumentList "-NoProfile -NonInteractive -File `"$lib\Pulse.ps1`" -Root `"$dataRoot`"" -RedirectStandardOutput $pulseOut -RedirectStandardError $pulseErr -WindowStyle Hidden -PassThru
               if(!$pulseChild.WaitForExit(6000)){
                   $pulseChild.Kill($true)
                   if(!$pulseChild.WaitForExit(1000)){throw 'pulse cleanup incomplete'}
                   $events='Pulse did not answer in 6 s; live state UNREADABLE.'
               }else{
                   $events=([IO.File]::ReadAllText($pulseOut)-replace'\r?\n',"`n").TrimEnd([char]10)
                   $pulseError=[IO.File]::ReadAllText($pulseErr)
                   if($pulseError-or($pulseChild.ExitCode-ne0-and$events-notmatch'UNREADABLE')){$events='Pulse UNREADABLE (reporter failed; run Pulse.ps1 directly).'}
                   if($events.Length-gt4096){$events='Pulse UNREADABLE (reporter output exceeded 4096 characters; run Pulse.ps1 directly).'}
               }
           }catch{
               if($pulseChild-and!$pulseChild.HasExited){try{$pulseChild.Kill($true);$null=$pulseChild.WaitForExit(1000)}catch{$null=$_}}
               $events='Pulse UNREADABLE (reporter could not run).'
           }finally{
               if($pulseChild){$pulseChild.Dispose()}
               foreach($pulseFile in $pulseOut,$pulseErr){if(Test-Path -LiteralPath $pulseFile){Remove-Item -LiteralPath $pulseFile -Force}}
           }
           $contextPrefix="ORVION AGENT TOOLS exist at $lib (index: README.md). Use them; never hand-write an alarm loop.`n"
           $contextSuffix="`nBefore a task: pwsh -NoProfile -File `"$lib\Events.ps1`" -Find '<task in a few words>'. Record a failure, discovery or decision worth keeping with Events.ps1 -Add. Past sessions (task, size, tools, errors, SPECs, raw path): $dataRoot\sessions\INDEX.md."
           $guidance=$always.Replace('<lib>',$lib)
           $contextLimit=8192-[Environment]::NewLine.Length
           if($contextPrefix.Length+$guidance.Length+1+$events.Length+$contextSuffix.Length-gt$contextLimit){
               $guidance="Tool guidance abbreviated; see $lib\README.md."
           }
           $context=$contextPrefix+$guidance+"`n"+$events+$contextSuffix
           if($context.Length-gt$contextLimit){$context="ORVION AGENT TOOLS: see lib\README.md.`n$events`nPast sessions: sessions\INDEX.md under the selected data root."}
           Send-Context $context
   ```

   The resulting file's Git blob is 1df0de9a1618ce8fc2a99430bbf38bab38204ced.

5. Check whether `lib/test-events.ps1` contains `HazardProbeOnly`; if so record Already Applied when its Git blob is fa02526552adf51ee7684d97ec85d44e6f1e00e5, and otherwise stop and report. Otherwise make exactly these 2 edits (Workbench robustness only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([switch]$RootProbeOnly,[string]$RelativeTool,[switch]$EvidenceProbeOnly)
   ```
   with
   ```text
   param([switch]$RootProbeOnly,[string]$RelativeTool,[switch]$EvidenceProbeOnly,[switch]$HazardProbeOnly)
   ```

   b) immediately after the lines
   ```text
   $fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
   try{
   ```
   insert
   ```text
       if(!$RootProbeOnly-and!$EvidenceProbeOnly){
           # The reserved-name lesson below owns the real scanner caller; strings keep planted hazards out of this script's AST.
           $hazardCases=@(
               @{name='separate functions';code='function Read-First { $Token=1 }; function Read-Second { $token=2 }';count=0},
               @{name='nested functions';code='function Read-First { $Token=1; function Read-Second { $token=2 } }';count=0},
               @{name='root and function';code='$Token=1; function Read-First { $token=2 }';count=0},
               @{name='same function parameter and loop';code='function Read-First { param($Token) foreach($token in 1..2){ $token } }';count=1},
               @{name='conditional block';code='function Read-First { $Token=1; if($true){$token=2} }';count=1},
               @{name='dot sourced block';code='function Read-First { $Token=1; . { $token=2 } }';count=1},
               @{name='automatic variable';code='function Read-First { $Pid=1 }';count=1}
           )
           foreach($hazardCase in $hazardCases){
               $hazardPath=Join-Path $t ('hazard-'+$hazardCase.name.Replace(' ','-')+'.ps1')
               [IO.File]::WriteAllText($hazardPath,$hazardCase.code)
               $hazardOutput=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Test-ScriptHazards.ps1') $hazardPath 2>&1)-join"`n"
               $hazardExit=$LASTEXITCODE
               Assert-That "scanner $($hazardCase.name) has $($hazardCase.count) hazard(s)" ($hazardExit-eq[int]($hazardCase.count-gt0)-and$hazardOutput-match("(?m)^hazards: "+$hazardCase.count+'\s*$'))
           }
           if($HazardProbeOnly){if($fail){throw 'HAZARD_PROBE_FAILED'};'HAZARD_PROBE PASS';return}
       }
   ```

   The resulting file's Git blob is fa02526552adf51ee7684d97ec85d44e6f1e00e5.

6. Check whether `lib/test-hunt.ps1` contains `IndexProbeOnly`; if so record Already Applied when its Git blob is c082165e6aa42ad5e86ce4f0c9c52ab12b05f97c, and otherwise stop and report. Otherwise make exactly these 2 edits (Workbench robustness only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([switch]$RootProbeOnly,[switch]$EvidenceProbeOnly)
   ```
   with
   ```text
   param([switch]$RootProbeOnly,[switch]$EvidenceProbeOnly,[switch]$IndexProbeOnly)
   ```

   b) immediately after the lines
   ```text
   $fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
   try{
   ```
   insert
   ```text
       if(!$RootProbeOnly-and!$EvidenceProbeOnly){
           $indexStore=Join-Path $t 'index-probe'
           foreach($part in 'sessions','events','work'){[void][IO.Directory]::CreateDirectory((Join-Path $indexStore $part))}
           $indexLauncher=Join-Path $t 'index-probe.ps1'
           [IO.File]::WriteAllText($indexLauncher,@'
   param([string]$Hunt,[string]$Store,[switch]$Record)
   function Get-Process { @() }
   function Get-CimInstance { @() }
   & $Hunt -Root $Store -DataRoot $Store -Quick -NoRecord:(!$Record)
   exit $LASTEXITCODE
   '@)
           $indexFile=Join-Path $indexStore 'sessions/index.jsonl'
           $indexJournal=Join-Path $indexStore 'events/events.jsonl'
           $oldIndexEvents=@(foreach($pattern in 'hunt-index-consistency','hunt-lesson-raw-missing','hunt-unrelated-old'){
               @{at='2000-01-01T00:00:00Z';pattern=$pattern;status='open';category='observation';summary='old fixture';session='hunter-fixture'}|ConvertTo-Json -Compress
           })
           [IO.File]::WriteAllLines($indexJournal,[string[]]$oldIndexEvents)
           [IO.File]::WriteAllText((Join-Path $indexStore 'work/sync-errors.log'),'INDEPENDENT-SENTINEL')
           $marker=Join-Path $indexStore 'sessions/marker.jsonl'
           [IO.File]::WriteAllText($marker,'x');(Get-Item $marker).LastWriteTimeUtc=[DateTime]::UtcNow.AddHours(-1)
           $indexRow=@{id='before';raw='sessions\marker.jsonl';bytes=0;metaBytes=0}
           $indexAfter=@{id='after';raw='sessions\marker.jsonl';bytes=0;metaBytes=0}
           [IO.File]::WriteAllLines($indexFile,[string[]]@(($indexRow|ConvertTo-Json -Compress),'{torn','null',($indexAfter|ConvertTo-Json -Compress),'  '))
           $indexHash=(Get-FileHash $indexJournal).Hash
           $indexOutput=@(& pwsh -NoProfile -File $indexLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $indexStore 2>&1)-join"`n";$indexCode=$LASTEXITCODE
           Assert-That 'index corruption counts two rows, checks valid rows on both sides and continues other hounds' ($indexCode-eq1-and$indexOutput-match'BUG index-unreadable: 2 malformed row\(s\)'-and$indexOutput-match'BUG index-consistency: 2 '-and$indexOutput-match'BUG sync-errors:.*INDEPENDENT-SENTINEL'-and$indexOutput-match'^HUNT ')
           Assert-That 'partial index saves its result and NoRecord preserves the journal' ((Test-Path (Join-Path $indexStore 'work/hunt-last.txt'))-and(Get-FileHash $indexJournal).Hash-ceq$indexHash)
           $indexRow.bytes=1;$indexRow.metaBytes=1
           [IO.File]::WriteAllText((Join-Path $indexStore 'work/sync-errors.log'),'')
           [IO.File]::WriteAllLines($indexFile,[string[]]@(($indexRow|ConvertTo-Json -Compress),'{torn'))
           $null=& pwsh -NoProfile -File $indexLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $indexStore -Record
           $recordIndexCode=$LASTEXITCODE
           $indexEvents=@([IO.File]::ReadAllLines($indexJournal)|ForEach-Object{$_|ConvertFrom-Json})
           Assert-That 'incomplete index retains old index and lesson findings while unrelated findings can resolve' (@($indexEvents|Where-Object pattern -eq 'hunt-index-consistency')[-1].status-eq'open'-and@($indexEvents|Where-Object pattern -eq 'hunt-lesson-raw-missing')[-1].status-eq'open'-and@($indexEvents|Where-Object pattern -eq 'hunt-unrelated-old')[-1].status-eq'resolved')
           Assert-That 'index corruption alone exits 1 and recording names index unreadability in the journal' ($recordIndexCode-eq1-and@($indexEvents|Where-Object pattern -eq 'hunt-index-unreadable').Count-eq1)
           $indexLock=[IO.File]::Open($indexFile,'Open','ReadWrite','None')
           try{$lockedOutput=@(& pwsh -NoProfile -File $indexLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $indexStore 2>&1)-join"`n";$lockedCode=$LASTEXITCODE}finally{$indexLock.Dispose()}
           Assert-That 'unreadable index file reports unknown count and continues to the summary' ($lockedCode-eq1-and$lockedOutput-match'BUG index-unreadable: row count unknown'-and$lockedOutput-match'^HUNT ')
           if($IndexProbeOnly){if($fail){throw 'HUNT_INDEX_PROBE_FAILED'};'HUNT_INDEX_PROBE PASS';return}
       }
   ```

   The resulting file's Git blob is c082165e6aa42ad5e86ce4f0c9c52ab12b05f97c.

7. Check whether `lib/test-pulse.ps1` contains `BoundProbeOnly`; if so record Already Applied when its Git blob is 667eb6d835e4a53e9b681ae20b46724dba45b9e5, and otherwise stop and report. Otherwise make exactly these 5 edits (Workbench robustness only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([string]$Library=$PSScriptRoot,[switch]$OutputProbeOnly)
   ```
   with
   ```text
   param([string]$Library=$PSScriptRoot,[switch]$OutputProbeOnly,[switch]$BoundProbeOnly,[switch]$RuntimeProbeOnly)
   ```

   b) replace the lines
   ```text
   param([string]$Pulse,[string]$Data,[string]$Repository)
   function Get-CimInstance{param([string]$ClassName,[string]$Filter) if($ClassName-eq'Win32_OperatingSystem'){[pscustomobject]@{FreePhysicalMemory=1000000;FreeVirtualMemory=2000000}}}
   ```
   with
   ```text
   param([string]$Pulse,[string]$Data,[string]$Repository,[string]$DiscoveryFault,[int]$RuntimeRows)
   function Get-CimInstance{param([string]$ClassName,[string]$Filter)
       if(($DiscoveryFault-eq'process'-and$ClassName-eq'Win32_Process')-or($DiscoveryFault-eq'host'-and$ClassName-eq'Win32_OperatingSystem')){throw 'FIXTURE_DISCOVERY_FAILURE'}
       if($ClassName-eq'Win32_OperatingSystem'){[pscustomobject]@{FreePhysicalMemory=1000000;FreeVirtualMemory=2000000}}
       if($ClassName-eq'Win32_Process'){foreach($runIndex in 1..$RuntimeRows|Where-Object{$_-gt0-and$RuntimeRows-gt0}){[pscustomobject]@{ProcessId=$runIndex;CommandLine=('pwsh run_timed.ps1 -Log "'+(Join-Path $Data ('fixture-log-'+$runIndex+('-long'*15)))+'"')}}}
   }
   ```

   c) replace the lines
   ```text
   function Invoke-PulseCheck([string]$selectedRepository=$pulseRepository){
       $pulseLines=@(& pwsh -NoProfile -File $pulseLauncher -Pulse $pulsePath -Data $pulseFixture -Repository $selectedRepository 2>&1)
   ```
   with
   ```text
   function Invoke-PulseCheck([string]$selectedRepository=$pulseRepository,[string]$discoveryFault='',[int]$runtimeRows=0){
       $pulseLines=@(& pwsh -NoProfile -File $pulseLauncher -Pulse $pulsePath -Data $pulseFixture -Repository $selectedRepository -DiscoveryFault $discoveryFault -RuntimeRows $runtimeRows 2>&1)
   ```

   d) immediately after the line
   ```text
       if($OutputProbeOnly){if($pulseFailures){throw 'PULSE_OUTPUT_PROBE_FAILED'};$pulseCompleted=$true;'PULSE_OUTPUT_PROBE PASS';return}
   ```
   insert
   ```text
       if(!$RuntimeProbeOnly){
           $boundedRows=@(foreach($ownerIndex in 0..999){@{pattern=('owner-{0:D4}' -f $ownerIndex);at='2026-10-20T00:00:00Z';category='decision';status='open';owner='owner';summary=('S'*150)}})
           # Appended last, oldest first in the classifier: arrival order cannot decide selection.
           $boundedRows+=@{pattern='urgent-owner';at='2000-01-01T00:00:00Z';category='decision';status='open';owner='owner';summary='MOST-URGENT-OWNER'}
           $boundedRows+=@{pattern='critical-agent';at='2000-01-01T00:00:00Z';category='failure';severity='high';status='open';summary='UNOWNED-SENTINEL'}
           $boundedRows+=@{pattern='resumable';at='2026-10-20T00:00:00Z';category='observation';owner='agent';action='resume at fixture/RESUME.md';status='open';summary='in flight'}
           Set-PulseFixtureEvents $boundedRows
           $boundedIndex=Join-Path $pulseFixture 'sessions/index.jsonl'
           [IO.File]::WriteAllLines($boundedIndex,[string[]]@(($largeRow|ConvertTo-Json -Compress),'{torn'))
           $bounded=Invoke-PulseCheck '' '' 200
           $ownerMatches=[regex]::Matches($bounded.Text,'(?m)^         - (?:owner-[0-9]+|urgent-owner):')
           $moreMatch=[regex]::Match($bounded.Text,'(?m)^more\s+(?<count>[0-9]+) more owner wait\(s\)')
           Assert-PulseCheck 'total Pulse cap preserves unreadability, actual counts and exact omitted owner count' ($bounded.Exit-eq2-and$bounded.Text.Length+[Environment]::NewLine.Length-le4096-and$bounded.Text-match'last     UNREADABLE: 1 damaged'-and$bounded.Text-match'waiting  on the owner: 1001'-and$moreMatch.Success-and[int]$moreMatch.Groups['count'].Value-eq(1001-$ownerMatches.Count)) $bounded.Text
           Assert-PulseCheck 'bounded details retain snapshot urgency, escalation, continuation and same-root Coordinator pointer' ($ownerMatches.Count-gt0-and$ownerMatches[0].Value.EndsWith('urgent-owner:')-and$bounded.Text-match'UNOWNED-SENTINEL'-and$bounded.Text-match'fixture/RESUME.md'-and$bounded.Text.Contains("; archive: "+(Join-Path $pulseFixture $largeRow.raw))-and$bounded.Text.Contains("-Root '"+$pulseFixture.Replace("'","''")+"'")) $bounded.Text
           Set-PulseFixtureEvents @(@{pattern=('p'*10000);at='2026-10-20T00:00:00Z';category='decision';status='open';owner='owner';summary='wide identifier'})
           [IO.File]::WriteAllText($boundedIndex,'')
           $wide=Invoke-PulseCheck ''
           Assert-PulseCheck 'one oversized identifier remains bounded with readable status and a detail pointer' ($wide.Exit-eq0-and$wide.Text.Length+[Environment]::NewLine.Length-le4096-and$wide.Text-match'waiting  on the owner: 1'-and$wide.Text-match'detail abbreviated'-and$wide.Text.Contains("-Root '"+$pulseFixture.Replace("'","''")+"'")) $wide.Text
           $wideSession=$largeRow.Clone();$wideSession.repo='R'*12000
           [IO.File]::WriteAllText($boundedIndex,($wideSession|ConvertTo-Json -Compress))
           Set-PulseFixtureEvents @()
           $wide=Invoke-PulseCheck '' '' 200
           Assert-PulseCheck 'oversized runtime and session fields share the total cap and retain archive continuity' ($wide.Exit-eq0-and$wide.Text.Length+[Environment]::NewLine.Length-le4096-and$wide.Text.Contains('; archive: '+(Join-Path $pulseFixture $largeRow.raw))) $wide.Text
           [IO.File]::Delete($boundedIndex)
           Set-PulseFixtureEvents @()
           if($BoundProbeOnly){if($pulseFailures){throw 'PULSE_BOUND_PROBE_FAILED'};$pulseCompleted=$true;'PULSE_BOUND_PROBE PASS';return}
       }
   ```

   e) immediately after the line
   ```text
       Assert-PulseCheck 'read-only observation preserves journal and Git HEAD' ((Get-FileHash -LiteralPath $pulseJournal).Hash-ceq$pulseBefore-and@(Read-PulseFixtureGit @('rev-parse','HEAD'))[0]-ceq$pulseHead)
   ```
   insert
   ```text
       foreach($discoveryFailure in 'process','host'){
           $pulseObserved=Invoke-PulseCheck $pulseRepository $discoveryFailure
           Assert-PulseCheck "$discoveryFailure discovery failure stays UNREADABLE with exit 2 and retains owner information" ($pulseObserved.Exit-eq2-and$pulseObserved.Text-match'(?m)^running  UNREADABLE \('-and$pulseObserved.Text-match'waiting  on the owner: 2'-and$pulseObserved.Text-notmatch'archiver .*NOT running|host: 0|FIXTURE_DISCOVERY_FAILURE') $pulseObserved.Text
       }
       if($RuntimeProbeOnly){if($pulseFailures){throw 'PULSE_RUNTIME_PROBE_FAILED'};$pulseCompleted=$true;'PULSE_RUNTIME_PROBE PASS';return}
   ```

   The resulting file's Git blob is 667eb6d835e4a53e9b681ae20b46724dba45b9e5.

8. Check whether `lib/test-watch-reminder.ps1` contains `DeadlineProbeOnly`; if so record Already Applied when its Git blob is f44450e022f1128f812951750d8635fc1f1a0959, and otherwise stop and report. Otherwise make exactly these 2 edits (Workbench robustness only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([switch]$RootProbeOnly,[switch]$FailureProbeOnly)
   ```
   with
   ```text
   param([switch]$RootProbeOnly,[switch]$FailureProbeOnly,[switch]$DeadlineProbeOnly,[string]$BaselineHook)
   ```

   b) immediately after the lines
   ```text
   }
   try{
   ```
   insert
   ```text
       if(!$RootProbeOnly-and!$FailureProbeOnly){
           $deadlineCheckout=Join-Path $t 'deadline checkout';$deadlineLib=Join-Path $deadlineCheckout 'lib'
           $deadlineStore=Join-Path $t 'deadline store';$deadlineTemp=Join-Path $deadlineStore 'temp'
           [void][IO.Directory]::CreateDirectory((Join-Path $deadlineLib 'hooks'));[void][IO.Directory]::CreateDirectory($deadlineTemp)
           $deadlineHook=Join-Path $deadlineLib 'hooks/Watch-Reminder.ps1'
           Copy-Item (Join-Path $PSScriptRoot 'hooks/Watch-Reminder.ps1') $deadlineHook
           [IO.File]::WriteAllText((Join-Path $deadlineLib 'README.md'),"## Always`nFIXTURE-TOOLS`n## Next`n")
           [IO.File]::WriteAllText((Join-Path $deadlineLib 'Sync-Sessions.ps1'),$stub.Replace('__SYNC__',$sync.Replace("'","''")))
           $deadlinePulse=@'
   param([string]$Root)
   [IO.File]::WriteAllText((Join-Path $Root 'received-root'),$Root)
   [IO.File]::WriteAllText((Join-Path $Root 'pulse.pid'),"$PID")
   $mode=[IO.File]::ReadAllText((Join-Path $Root 'mode'))
   if($mode-eq'hang'){
       $leaf=Join-Path $Root 'leaf.ps1'
       $child=Start-Process pwsh -ArgumentList "-NoProfile -File `"$leaf`" -Root `"$Root`"" -WindowStyle Hidden -PassThru
       [IO.File]::WriteAllText((Join-Path $Root 'leaf.pid'),"$($child.Id)")
       Start-Sleep -Seconds 30
   }
   if($mode-eq'flood'){'X'*70000;'Pulse UNREADABLE flood';exit 2}
   if($mode-eq'nonzero'){'Pulse UNREADABLE fixture';exit 2}
   'FIXTURE-PULSE'
   '@
           [IO.File]::WriteAllText((Join-Path $deadlineLib 'Pulse.ps1'),$deadlinePulse)
           [IO.File]::WriteAllText((Join-Path $deadlineStore 'leaf.ps1'),'param([string]$Root) Start-Sleep -Seconds 30')
           function Invoke-DeadlineEvent([string]$selectedHook=$deadlineHook,[string]$eventName='SessionStart',[string]$eventCwd=$deadlineCheckout){
               $info=[Diagnostics.ProcessStartInfo]::new((Get-Command pwsh -CommandType Application|Select-Object -First 1).Source)
               $info.UseShellExecute=$false;$info.CreateNoWindow=$true
               $info.RedirectStandardInput=$true;$info.RedirectStandardOutput=$true;$info.RedirectStandardError=$true
               foreach($argument in @('-NoProfile','-File',$selectedHook)){$info.ArgumentList.Add($argument)}
               $child=[Diagnostics.Process]::Start($info);$elapsed=[Diagnostics.Stopwatch]::StartNew()
               try{
                   $outTask=$child.StandardOutput.ReadToEndAsync();$errTask=$child.StandardError.ReadToEndAsync()
                   $child.StandardInput.Write((@{hook_event_name=$eventName;cwd=$eventCwd}|ConvertTo-Json -Compress));$child.StandardInput.Close()
                   $expired=!$child.WaitForExit(12000)
                   if($expired){$child.Kill($true);$null=$child.WaitForExit(2000)}
                   [pscustomobject]@{Text=$outTask.GetAwaiter().GetResult();Error=$errTask.GetAwaiter().GetResult();Exit=$child.ExitCode;Ms=[math]::Round($elapsed.Elapsed.TotalMilliseconds,1);Expired=$expired}
               }finally{$child.Dispose()}
           }
           $deadlineSavedRoot=$env:ORVION_DATA_ROOT;$deadlineSavedTemp=$env:TEMP;$deadlineSavedTmp=$env:TMP
           try{
               $env:ORVION_DATA_ROOT=$deadlineStore;$env:TEMP=$deadlineTemp;$env:TMP=$deadlineTemp
               [IO.File]::WriteAllText((Join-Path $deadlineStore 'mode'),'healthy')
               $healthyTimes=@();$baselineTimes=@()
               foreach($sample in 1..3){$healthy=Invoke-DeadlineEvent;$healthyTimes+=,$healthy.Ms}
               Assert-That 'healthy deadline caller passes spaced Root, stays stderr-silent and exits 0' ($healthy.Exit-eq0-and!$healthy.Expired-and!$healthy.Error-and$healthy.Text-match'FIXTURE-PULSE'-and[IO.File]::ReadAllText((Join-Path $deadlineStore 'received-root'))-ceq$deadlineStore)
               if($BaselineHook){
                   $baselinePath=Join-Path $deadlineLib 'hooks/baseline.ps1';Copy-Item -LiteralPath $BaselineHook -Destination $baselinePath
                   foreach($sample in 1..3){$baseline=Invoke-DeadlineEvent $baselinePath;$baselineTimes+=,$baseline.Ms}
                   Assert-That 'healthy SessionStart context is identical to the supplied baseline' ($baseline.Exit-eq0-and$healthy.Text-ceq$baseline.Text)
               }
               "LATENCY SessionStartMs=$($healthyTimes-join',') BaselineMs=$($baselineTimes-join',')"
               [IO.File]::WriteAllText((Join-Path $deadlineStore 'mode'),'hang')
               $hung=Invoke-DeadlineEvent
               $pulseId=[int][IO.File]::ReadAllText((Join-Path $deadlineStore 'pulse.pid'));$leafId=[int][IO.File]::ReadAllText((Join-Path $deadlineStore 'leaf.pid'))
               $ownedAlive=@(Get-Process -Id $pulseId,$leafId -ErrorAction SilentlyContinue)
               Assert-That 'Pulse deadline reports honest timeout, exit 0 and kills the owned descendant tree' ($hung.Exit-eq0-and!$hung.Expired-and$hung.Ms-lt9500-and$hung.Text.Contains('Pulse did not answer in 6 s; live state UNREADABLE.')-and!$ownedAlive.Count-and!$hung.Error)
               foreach($ownedChild in $ownedAlive){$ownedChild.Kill($true);$null=$ownedChild.WaitForExit(2000);$ownedChild.Dispose()}
               "LATENCY TimeoutMs=$($hung.Ms)"
               Assert-That 'archiving stays detached through the Pulse deadline' (@(Get-Content (Join-Path $deadlineCheckout 'archive.calls')).Count-ge4)
               foreach($pulseMode in 'nonzero','flood'){
                   [IO.File]::WriteAllText((Join-Path $deadlineStore 'mode'),$pulseMode)
                   $observed=Invoke-DeadlineEvent
                   Assert-That "Pulse $pulseMode preserves honest unreadability without pipe deadlock or oversized context" ($observed.Exit-eq0-and!$observed.Expired-and$observed.Text-match'UNREADABLE'-and$observed.Text.Length-le8192-and!$observed.Error)
               }
               [IO.File]::WriteAllText((Join-Path $deadlineLib 'README.md'),("## Always`n"+('GUIDANCE'*3000)+"`n## Next`n"))
               [IO.File]::WriteAllText((Join-Path $deadlineStore 'mode'),'nonzero')
               $bounded=Invoke-DeadlineEvent
               Assert-That 'complete SessionStart bounds README guidance while preserving Pulse diagnostics and index pointer' ($bounded.Exit-eq0-and$bounded.Text.Length-le8192-and$bounded.Text-match'Pulse UNREADABLE fixture'-and$bounded.Text.Contains("$deadlineStore\sessions\INDEX.md")-and$bounded.Text-match'README.md')
               $end=Invoke-DeadlineEvent $deadlineHook 'SessionEnd'
               $unrelated=Invoke-DeadlineEvent $deadlineHook 'SessionStart' (Join-Path $t 'unrelated')
               Assert-That 'deadline leaves silent SessionEnd and unrelated branches silent with exit 0' ($end.Exit-eq0-and$unrelated.Exit-eq0-and!$end.Text-and!$end.Error-and!$unrelated.Text-and!$unrelated.Error)
               Assert-That 'Pulse stdout and stderr temporary files are deleted after healthy, failed and timed-out calls' (@(Get-ChildItem -LiteralPath $deadlineTemp -Filter 'orvion-pulse-*').Count-eq0)
           }finally{$env:ORVION_DATA_ROOT=$deadlineSavedRoot;$env:TEMP=$deadlineSavedTemp;$env:TMP=$deadlineSavedTmp}
           if($DeadlineProbeOnly){if($fail){throw 'HOOK_DEADLINE_PROBE_FAILED'};'HOOK_DEADLINE_PROBE PASS';return}
       }
   ```

   The resulting file's Git blob is f44450e022f1128f812951750d8635fc1f1a0959.

9. Check whether `lib/README.md` contains `index-unreadable`; if so record Already Applied when its Git blob is e187e6881c7be2ccc3be0a3e325ce76b707c95b0, and otherwise stop and report. Otherwise make exactly this one edit (Workbench robustness only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   index`; it does not itself make Pulse fail when the journal and selected repositories are readable.
   ```
   insert
   ```text
   Failed process/host discovery prints `running  UNREADABLE` (exit 2). Pulse output is capped at 4096 characters: diagnostics,
   counts and pointers first, then owner waits in urgency order, ending with an exact `more` line and a same-root Coordinator command.
   SessionStart waits at most 6 s for Pulse (then kills its process tree and says live state is UNREADABLE) and caps its context at 8192.
   Hunt reports malformed or unreadable `sessions\index.jsonl` rows as `BUG index-unreadable` with a count and keeps going.
   ```

   The resulting file's Git blob is e187e6881c7be2ccc3be0a3e325ce76b707c95b0.

## Acceptance Criteria

- [x] Exact approved scoped output. check: blob:lib/Test-ScriptHazards.ps1=3fabb69ff73b1c886b20000442351c90e2cc0a45
- [x] Exact approved scoped output. check: blob:lib/Hunt.ps1=37266499d16b0ee196f70391c5232fcc0dc21cc5
- [x] Exact approved scoped output. check: blob:lib/Pulse.ps1=74eea48b9f0b7909e912816eb955c404fc9863d5
- [x] Exact approved scoped output. check: blob:lib/hooks/Watch-Reminder.ps1=1df0de9a1618ce8fc2a99430bbf38bab38204ced
- [x] Exact approved scoped output. check: blob:lib/test-events.ps1=fa02526552adf51ee7684d97ec85d44e6f1e00e5
- [x] Exact approved scoped output. check: blob:lib/test-hunt.ps1=c082165e6aa42ad5e86ce4f0c9c52ab12b05f97c
- [x] Exact approved scoped output. check: blob:lib/test-pulse.ps1=667eb6d835e4a53e9b681ae20b46724dba45b9e5
- [x] Exact approved scoped output. check: blob:lib/test-watch-reminder.ps1=f44450e022f1128f812951750d8635fc1f1a0959
- [x] Exact approved scoped output. check: blob:lib/README.md=e187e6881c7be2ccc3be0a3e325ce76b707c95b0
- [x] The owning tests prove: separate, nested and root-versus-function variable spellings give 0 hazards while same-function, block, dot-sourced and automatic-variable spellings give 1; a malformed or unreadable index row gives BUG index-unreadable with its count, Hunt continues and does not resolve index-dependent findings; failed process/host discovery prints running UNREADABLE and exits 2; Pulse output stays within 4096 characters in urgency order with an exact more count and a same-root Coordinator command; the hook answers within the 6 s deadline with the UNREADABLE line, exits 0, removes the owned process tree and its temporary files, passes -Root explicitly, keeps silent branches silent and the healthy context unchanged, and caps context at 8192.
- [x] Mandatory V1/V2/V3, focused proof, planted-regression mutants, accepted literal replay controls and the real read-only measurement are preserved. One isolated native timed/watched Finish owns the unchanged full schedule with a fresh SANDBOX receipt before original approval; the original needs its own fresh Finish, live Review, native Complete and an independent carrying-range READY.

## Review Gate

- [x] Inspect the nine scoped files, the focused/mutant/literal evidence and the real read-only measurement; preserve all frozen prior evidence.
- [x] Independently check the native receipt root/Draft/recipe/evaluator/fingerprint, ordered tests and timed/watcher/host exits; normal native Review/Complete and every new carrying transition must pass. No second-agent or provider certification is claimed.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Decision D24 in C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\DECISIONS.md (under D19/D20/D21/D22 and D12). Codex investigated at xhigh effort (before pass, codex\before1-report.txt), implemented at high effort (codex\impl1-report.txt) and fixed at medium effort (codex\fix1-report.txt) in disposable C:\cx\ORVION-ws021 under orchestrator verification. Under the owner's exceptional delegation this one Workbench contract is authorized. Gate 1 for this Draft is DELEGATED: the owner did not type its digest. Sandbox approval is synthetic and grants no original authority.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws021-package\assurance\V3\DRAFT.md
Approved SHA256: C1355F950562A877DB035ACB204FF9CD8F039B713CDEDD8E21A9172B1215D51D
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\GATE1-WS021-DELEGATED.md
Owner Evidence SHA256: 61B7CC0C35AD404CD46A4B3623852A359386B5241CD658A26C8402B6910ED374
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws021-package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 2F16B206D5456175BBE0031E5696354E421E9B18D829064F5816D925FA67E286
Original admission: DELEGATED exact Gate 1 under the owner's exceptional delegation of 2026-10-26 (OWNER-DELEGATION.md SHA-256 94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217; decisions D1-D24; D24 is the delegated decision for this contract). The owner did not type this digest. Bound to this literal root, the exact V3 digest and the fresh sandbox receipt; no sandbox receipt transplant as original certification.
Original exact literal implementation applied by accepted native Workbench Execute. Declared filtered blobs match. Fresh root-bound original Finish and independent live Review remain required; sandbox success does not certify this root. This frozen Draft was not expanded.

## Verification Notes

Found by Codex's WS-019 after-pass and WS-021 before-pass: Hunt crashed on one malformed index row; Pulse printed every owner wait (22,467 characters with 100 waits) and had unguarded discovery; the hook waited on Pulse with no deadline; the scanner reported false cross-function collisions. Codex's direct runner kills 17 mutants (codex-mutants.log, run from a copy of the prototype lib; kept out of the repository so it does not grow every Finish); the orchestrator's independent planted regressions are detected (mutants.log); hazard scan 0; thirteen owning self-checks PASS with an isolated ORVION_DATA_ROOT. Real read-only measurement (real-measurement.json, sizes, counts, timings and exit codes only): the bounded Pulse on the real store with both repositories, its time against the 6 s deadline (the measured ~2.0 s made 3 s too tight), and a real-store Hunt.
Verdict: Confirmed Complete
Reviewed Fingerprint: A0C290BE1452E11DC01EF1DD61BDA42D5FCD0390DC8839B39AD85647F707F852
Reviewed Receipt: 2CF8EDE85AA5E05403D7E663ED50AD3B7EF6804166F83C1493808F7022C28802
Evidence: fresh ORIGINAL root-bound timed/watched Finish, actual ordered-suite schedule/exits, approved exact outputs and independently pinned accepted-code live review. Runtime: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws021-package\runtime\original. No sandbox receipt transplant, remote parity, offsite recovery or equal-OS isolation claim.

## Selection reasons and sources

Evidence Refresh: focused-selected.log PASS for thirteen owning self-checks on the selected bytes, 17 Codex mutants plus independent planted regressions detected, hazard scan 0, real read-only measurement, literal replay controls run before the one sandbox Finish. Baseline e1b71a4 (main = preflight = WS-020), accepted judge 835E14DA unchanged.

Sources: DECISIONS.md D19-D24, ws021-package\codex, accepted WORKFLOW/TEMPLATE/checker, WS-020 packet scripts, the real read-only measurement.
