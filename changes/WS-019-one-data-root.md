# Workbench Change Request - WS-019

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

One data root everywhere, so the owner's Claude hooks can run this checkout's lib\hooks\Watch-Reminder.ps1 without splitting the session archive: Sync-Sessions, Backup-Workspace, Hunt (-DataRoot, its -Root stays the source/lint scope) and the session hook take the identical WS-017 default (ORVION_DATA_ROOT, else the sibling ORVION-Owner-Tools with events\, else this checkout); the hook passes that root to its Sync child, the masking library, Pulse and its error log, with an independent fallback when the root itself fails. A relative ORVION_DATA_ROOT is refused in every data tool (ORVION_DATA_ROOT_NOT_ABSOLUTE) so no tool can pick a store by its current directory. Pulse bounds the displayed session title and last prompt to 300 characters. Backup normalizes a trailing separator. Correct the stale entry-document statements the fresh-agent orientation test found.

## Baseline

4cdf1d54171d714498f74ec4ea59f432036620e9

## Write Scope

- RESUME.md
- lib/Sync-Sessions.ps1
- lib/hooks/Watch-Reminder.ps1
- lib/Hunt.ps1
- lib/Backup-Workspace.ps1
- lib/Events.ps1
- lib/Spider.ps1
- lib/Pulse.ps1
- lib/Coordinator.ps1
- lib/Delegate.ps1
- lib/Watch-Subagents.ps1
- lib/test-pulse.ps1
- lib/test-sync-sessions-survival.ps1
- lib/test-watch-reminder.ps1
- lib/test-hunt.ps1
- lib/test-events.ps1
- lib/test-backup-restore.ps1
- lib/README.md
- AGENTS.md
- README.md
- HANDOFF.md
- docs/EXECUTION-PLAN.md
- docs/RECOVERY.md
- docs/WORKSPACE-LAYOUT.md

## Out of Scope

All other engineering paths except native allocation/status/pointer bookkeeping. No checker (Test-WorkbenchChange.ps1), applier, workflow, WORKFLOW.md, TEMPLATE, GitHub setting or product repository change; the user hook settings are changed only after release, outside this contract, with a backup. RESUME.md content beyond native bookkeeping is not changed (event resume-hook-transition-sentence). Deferred and recorded: per-store Sync mutex (declined: one store), backup of a non-default override store beyond the default rule, Hunt baseline, Finish watcher binding, Test-ScriptHazards scope, observer timeouts. CTRL-19 stays OPEN; Batch 6/Phase 8 stay ON HOLD; C2 stays UNPROVEN.

## Draft Assurance

V1: WS019-DATAROOT-DESIGN | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws019-package\assurance\V1\DRAFT.md | 7F2865124401A4234304C6933EA101FAA7C0C028B9A0582A34ABF1C3531B9619
V2: WS019-DATAROOT-ADVERSARIAL | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws019-package\assurance\V2\DRAFT.md | 8B21B043C8165ABBC66CBBA8302DE7F2B880796AEAB07569E6D71DC5067EE279
V3: WS019-DATAROOT-REFRESH | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws019-package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSroot19
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSroot19\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSroot19\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws019-package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/Sync-Sessions.ps1` contains `ORVION_DATA_ROOT`; if so record Already Applied when its Git blob is e674fcf83b4b5ac1363da8b2013a39fdf4a47db2, and otherwise stop and report. Otherwise make exactly these 2 edits (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quiet,[switch]$Follow,[int]$IntervalSeconds=60,[int]$IndexMinutes=15,[switch]$Library,
   ```
   with
   ```text
   param([string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}),[switch]$Quiet,[switch]$Follow,[int]$IntervalSeconds=60,[int]$IndexMinutes=15,[switch]$Library,
   ```

   b) immediately after the line
   ```text
               $sr=New-Object IO.StreamReader (Open-Shared $f.FullName);try{$first=$sr.ReadLine()}finally{$sr.Close()}
   ```
   insert
   ```text
               # Case-insensitive compact first-line cwd substrings: Documents\\GitHub\\CRM,
               # Documents\\GitHub\\ORVION, or ORVION anywhere. Thus C:\cx\ORVION-<task> is archived;
               # C:\cx\CRM-<task> and C:\cx\repo are not. Keep this selector unchanged when naming clones.
   ```

   The resulting file's Git blob is e674fcf83b4b5ac1363da8b2013a39fdf4a47db2.

2. Check whether `lib/hooks/Watch-Reminder.ps1` contains `$dataRoot`; if so record Already Applied when its Git blob is f72275d083abc1ee0bf0fba2cdfad6769943cc2f, and otherwise stop and report. Otherwise make exactly these 5 edits (one data root everywhere only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       $lib=Split-Path $PSScriptRoot -Parent
   ```
   insert
   ```text
       $dataRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]})
       $dataRoot=[IO.Path]::GetFullPath($dataRoot).TrimEnd('\')
   ```

   b) replace the line
   ```text
           $safe=& {param($Value,$Library,$Workspace) . (Join-Path $Library 'Sync-Sessions.ps1') -Library -Root $Workspace;Hide-Secret $Value} $Text $lib $workbench
   ```
   with
   ```text
           $safe=& {param($Value,$Library,$Workspace) . (Join-Path $Library 'Sync-Sessions.ps1') -Library -Root $Workspace;Hide-Secret $Value} $Text $lib $dataRoot
   ```

   c) replace the line
   ```text
           Start-Process pwsh -ArgumentList "-NoProfile -File `"$lib\Sync-Sessions.ps1`" $mode" -WindowStyle Hidden
   ```
   with
   ```text
           Start-Process pwsh -ArgumentList "-NoProfile -File `"$lib\Sync-Sessions.ps1`" $mode -Root `"$dataRoot`"" -WindowStyle Hidden
   ```

   d) replace the lines
   ```text
           $events=(& (Join-Path $lib 'Pulse.ps1'))-join"`n"  # one voice: Pulse owns live state, owner decisions and the newest lessons
           Send-Context ("ORVION AGENT TOOLS exist at $lib (index: README.md). Use them; never hand-write an alarm loop.`n"+$always.Replace('<lib>',$lib)+"`n"+$events+"`nBefore a task: pwsh -NoProfile -File `"$lib\Events.ps1`" -Find '<task in a few words>'. Record a failure, discovery or decision worth keeping with Events.ps1 -Add. Past sessions (task, size, tools, errors, SPECs, raw path): $(Split-Path $lib -Parent)\sessions\INDEX.md.")
   ```
   with
   ```text
           $events=(& (Join-Path $lib 'Pulse.ps1') -Root $dataRoot)-join"`n"  # one voice: Pulse owns live state, owner decisions and the newest lessons
           Send-Context ("ORVION AGENT TOOLS exist at $lib (index: README.md). Use them; never hand-write an alarm loop.`n"+$always.Replace('<lib>',$lib)+"`n"+$events+"`nBefore a task: pwsh -NoProfile -File `"$lib\Events.ps1`" -Find '<task in a few words>'. Record a failure, discovery or decision worth keeping with Events.ps1 -Add. Past sessions (task, size, tools, errors, SPECs, raw path): $dataRoot\sessions\INDEX.md.")
   ```

   e) replace the lines
   ```text
       try{$errDir=Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'work';[IO.Directory]::CreateDirectory($errDir)|Out-Null;[IO.File]::AppendAllText((Join-Path $errDir 'hook-errors.log'),"$([DateTime]::UtcNow.ToString('o')) WATCH_REMINDER_UNREADABLE`n")}catch{$null=$_}
       [Console]::Error.WriteLine('WATCH_REMINDER_UNREADABLE: reporting failed; consult the native authority, not an inferred success.')
   ```
   with
   ```text
       $relativeRootRefused=$_.Exception.Message-eq'ORVION_DATA_ROOT_NOT_ABSOLUTE'
       # Resolve independently of $lib/$dataRoot: even their initialization may have failed.
       try{
       $checkout=Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
       $sibling=Join-Path (Split-Path $checkout -Parent) 'ORVION-Owner-Tools'
       foreach($candidate in @($env:ORVION_DATA_ROOT)+@(if(Test-Path -LiteralPath (Join-Path $sibling 'events')){$sibling})+@($checkout)){
           try{
               if(!$candidate-or![IO.Path]::IsPathFullyQualified($candidate)){continue}
               $errDir=Join-Path ([IO.Path]::GetFullPath($candidate)) 'work'
               [IO.Directory]::CreateDirectory($errDir)|Out-Null
               [IO.File]::AppendAllText((Join-Path $errDir 'hook-errors.log'),"$([DateTime]::UtcNow.ToString('o')) WATCH_REMINDER_UNREADABLE`n")
               break
           }catch{$null=$_}
       }
       }catch{$null=$_}
       [Console]::Error.WriteLine('WATCH_REMINDER_UNREADABLE: '+$(if($relativeRootRefused){'ORVION_DATA_ROOT_NOT_ABSOLUTE; '})+'reporting failed; consult the native authority, not an inferred success.')
   ```

   The resulting file's Git blob is f72275d083abc1ee0bf0fba2cdfad6769943cc2f.

3. Check whether `lib/Hunt.ps1` contains `DataRoot`; if so record Already Applied when its Git blob is da35c87362b38010be1a4c2092d05a524c3a8b18, and otherwise stop and report. Otherwise make exactly these 12 edits (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quick,[switch]$NoRecord,[object[]]$MutantSet)  # -MutantSet: test-hunt.ps1 only
   ```
   with
   ```text
   param([string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quick,[switch]$NoRecord,[object[]]$MutantSet,[string]$DataRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}))  # -MutantSet: test-hunt.ps1 only
   ```

   b) replace the line
   ```text
   . (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $Root
   ```
   with
   ```text
   # Sync's library binds $Root in this scope; restore the independent source root afterwards.
   $sourceRoot=$Root
   . (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $DataRoot
   $Root=$sourceRoot
   ```

   c) replace the line
   ```text
   $raw=Join-Path $Root 'sessions\raw';$cp=Join-Path $env:USERPROFILE '.claude\projects';$diverged=0;$checked=0
   ```
   with
   ```text
   $raw=Join-Path $DataRoot 'sessions\raw';$cp=Join-Path $env:USERPROFILE '.claude\projects';$diverged=0;$checked=0
   ```

   d) replace the line
   ```text
   $ix=Join-Path $Root 'sessions\index.jsonl';$bad=@()
   ```
   with
   ```text
   $ix=Join-Path $DataRoot 'sessions\index.jsonl';$bad=@()
   ```

   e) replace the line
   ```text
       $r=$l|ConvertFrom-Json;$p=Join-Path $Root $r.raw
   ```
   with
   ```text
       $r=$l|ConvertFrom-Json;$p=Join-Path $DataRoot $r.raw
   ```

   f) replace the line
   ```text
   $evLog=Join-Path $Root 'events\events.jsonl'
   ```
   with
   ```text
   $evLog=Join-Path $DataRoot 'events\events.jsonl'
   ```

   g) replace the line
   ```text
   foreach($lg in 'sync-errors.log'){$p=Join-Path $Root "work\$lg";if((Test-Path $p)-and(Get-Item $p).Length){Add-Finding BUG $lg.Replace('.log','') "the session archiver logged $(@(Get-Content $p).Count) failure(s); last: $(@(Get-Content $p -Tail 1)[0])" 'archive sync error file failed'}}
   ```
   with
   ```text
   foreach($lg in 'sync-errors.log'){$p=Join-Path $DataRoot "work\$lg";if((Test-Path $p)-and(Get-Item $p).Length){Add-Finding BUG $lg.Replace('.log','') "the session archiver logged $(@(Get-Content $p).Count) failure(s); last: $(@(Get-Content $p -Tail 1)[0])" 'archive sync error file failed'}}
   ```

   h) replace the line
   ```text
       $e=$_.evidence-replace'\s*\(.*$','';!(Test-Path -LiteralPath $e)-and!(Test-Path -LiteralPath (Join-Path $Root $e))-and!(Test-Path -LiteralPath (Join-Path (Join-Path $env:USERPROFILE 'Documents') $e))}|ForEach-Object pattern|Select-Object -Unique)
   ```
   with
   ```text
       $e=$_.evidence-replace'\s*\(.*$','';!(Test-Path -LiteralPath $e)-and!(Test-Path -LiteralPath (Join-Path $(if($e-match'^(work|sessions)\\'){$DataRoot}else{$Root}) $e))-and!(Test-Path -LiteralPath (Join-Path (Join-Path $env:USERPROFILE 'Documents') $e))}|ForEach-Object pattern|Select-Object -Unique)
   ```

   i) replace the line
   ```text
   $he=Join-Path $Root 'work\hook-errors.log'
   ```
   with
   ```text
   $he=Join-Path $DataRoot 'work\hook-errors.log'
   ```

   j) replace the lines
   ```text
   New-Item -ItemType Directory (Join-Path $Root 'work') -Force|Out-Null
   [IO.File]::WriteAllLines((Join-Path $Root 'work\hunt-last.txt'),[string[]](@($summary)+@($findings|ForEach-Object{"  $($_.kind) $($_.hound): $($_.text)"})))
   ```
   with
   ```text
   New-Item -ItemType Directory (Join-Path $DataRoot 'work') -Force|Out-Null
   [IO.File]::WriteAllLines((Join-Path $DataRoot 'work\hunt-last.txt'),[string[]](@($summary)+@($findings|ForEach-Object{"  $($_.kind) $($_.hound): $($_.text)"})))
   ```

   k) replace the line
   ```text
       $null=& (Join-Path $PSScriptRoot 'Events.ps1') -Root $Root -Add -Pattern "hunt-$($x.hound)" -Source hunter -Session "hunter-$([DateTime]::UtcNow.ToString('yyyy-MM-dd'))" -Category $(if($x.kind-eq'BUG'){'failure'}elseif($x.kind-in'NEED','PRUNE'){'proposal'}else{'observation'}) -Severity $(if($x.kind-eq'BUG'){'high'}else{'warn'}) -Cause confirmed -Summary "$($x.kind): $($x.text)" -Tool 'Hunt.ps1' -Tags "hunt $($x.kind.ToLower()) $($x.tags)"
   ```
   with
   ```text
       $null=& (Join-Path $PSScriptRoot 'Events.ps1') -Root $DataRoot -Add -Pattern "hunt-$($x.hound)" -Source hunter -Session "hunter-$([DateTime]::UtcNow.ToString('yyyy-MM-dd'))" -Category $(if($x.kind-eq'BUG'){'failure'}elseif($x.kind-in'NEED','PRUNE'){'proposal'}else{'observation'}) -Severity $(if($x.kind-eq'BUG'){'high'}else{'warn'}) -Cause confirmed -Summary "$($x.kind): $($x.text)" -Tool 'Hunt.ps1' -Tags "hunt $($x.kind.ToLower()) $($x.tags)"
   ```

   l) replace the line
   ```text
               $null=& (Join-Path $PSScriptRoot 'Events.ps1') -Root $Root -Add -Pattern $g.Name -Source hunter -Session "hunter-$([DateTime]::UtcNow.ToString('yyyy-MM-dd'))" -Category $z.category -Cause confirmed -Status resolved -Summary "no longer found by Hunt.ps1 ($([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC)" -Tool 'Hunt.ps1' -Tags $z.tags
   ```
   with
   ```text
               $null=& (Join-Path $PSScriptRoot 'Events.ps1') -Root $DataRoot -Add -Pattern $g.Name -Source hunter -Session "hunter-$([DateTime]::UtcNow.ToString('yyyy-MM-dd'))" -Category $z.category -Cause confirmed -Status resolved -Summary "no longer found by Hunt.ps1 ($([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC)" -Tool 'Hunt.ps1' -Tags $z.tags
   ```

   The resulting file's Git blob is da35c87362b38010be1a4c2092d05a524c3a8b18.

4. Check whether `lib/Backup-Workspace.ps1` contains `ORVION_DATA_ROOT`; if so record Already Applied when its Git blob is b758ee5e99e0aa18960ac3c60bc613cfb6c49450, and otherwise stop and report. Otherwise make exactly these 2 edits (one data root everywhere only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   # Selective package v1: the data root is fixed; the script's own checkout is already a repository bundle.
   $ownerTools=Join-Path $gh 'ORVION-Owner-Tools'
   ```
   with
   ```text
   # Same data-root default as the readers; the script's checkout is already a repository bundle.
   $ownerTools=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]})
   ```

   b) immediately after the line
   ```text
   # A failure names the subcommand and masks URL credentials: arguments and output may carry config values.
   ```
   insert
   ```text
   $ownerTools=[IO.Path]::GetFullPath($ownerTools).TrimEnd('\')
   ```

   The resulting file's Git blob is b758ee5e99e0aa18960ac3c60bc613cfb6c49450.

5. Check whether `lib/Events.ps1` contains `ORVION_DATA_ROOT_NOT_ABSOLUTE`; if so record Already Applied when its Git blob is 3de2ece51245a5205ad168684d98a593cd3ff82e, and otherwise stop and report. Otherwise make exactly this one edit (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
       [string]$Root=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]})  # the data root: ORVION_DATA_ROOT, else sibling ORVION-Owner-Tools, else this checkout
   ```
   with
   ```text
       [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]})  # the data root: ORVION_DATA_ROOT, else sibling ORVION-Owner-Tools, else this checkout
   ```

   The resulting file's Git blob is 3de2ece51245a5205ad168684d98a593cd3ff82e.

6. Check whether `lib/Spider.ps1` contains `ORVION_DATA_ROOT_NOT_ABSOLUTE`; if so record Already Applied when its Git blob is 647887da093bddf1f499796a214b8996b6546e79, and otherwise stop and report. Otherwise make exactly this one edit (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]}),
   ```
   with
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}),
   ```

   The resulting file's Git blob is 647887da093bddf1f499796a214b8996b6546e79.

7. Check whether `lib/Pulse.ps1` contains `Format-PulsePrompt`; if so record Already Applied when its Git blob is eb3fadea63c3386af20ae1d8f82f77dffdda9804, and otherwise stop and report. Otherwise make exactly these 2 edits (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([string]$Root=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]}),[string]$Session=$env:CLAUDE_CODE_SESSION_ID,
   ```
   with
   ```text
   param([string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}),[string]$Session=$env:CLAUDE_CODE_SESSION_ID,
   ```

   b) replace the line
   ```text
   if($prev){"last     session $($prev.id.Substring(0,[Math]::Min(8,$prev.id.Length))) [$($prev.repo) $($prev.client)] `"$(@($prev.title,$prev.firstPrompt)|Where-Object{$_}|Select-Object -First 1)`" ended $(([datetime]$prev.end).ToUniversalTime().ToString('yyyy-MM-dd HH:mm')); last ask: `"$($prev.lastPrompt)`""}
   ```
   with
   ```text
   function Format-PulsePrompt([string]$Text){if($Text.Length-gt300){return $Text.Substring(0,297)+'...'};$Text}
   if($prev){
       $title=Format-PulsePrompt (@($prev.title,$prev.firstPrompt)|Where-Object{$_}|Select-Object -First 1)
       $lastPrompt=Format-PulsePrompt $prev.lastPrompt
       $archive=Join-Path $Root $(if($prev.raw){$prev.raw}else{'sessions\INDEX.md'})
       "last     session $($prev.id.Substring(0,[Math]::Min(8,$prev.id.Length))) [$($prev.repo) $($prev.client)] `"$title`" ended $(([datetime]$prev.end).ToUniversalTime().ToString('yyyy-MM-dd HH:mm')); last ask: `"$lastPrompt`"; archive: $archive"
   }
   ```

   The resulting file's Git blob is eb3fadea63c3386af20ae1d8f82f77dffdda9804.

8. Check whether `lib/Coordinator.ps1` contains `ORVION_DATA_ROOT_NOT_ABSOLUTE`; if so record Already Applied when its Git blob is 3d66f1bfe022c1d1b7c8bc335f31a98825c0e054, and otherwise stop and report. Otherwise make exactly this one edit (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]}))
   ```
   with
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}))
   ```

   The resulting file's Git blob is 3d66f1bfe022c1d1b7c8bc335f31a98825c0e054.

9. Check whether `lib/Delegate.ps1` contains `ORVION_DATA_ROOT_NOT_ABSOLUTE`; if so record Already Applied when its Git blob is c836bfabc1ce86ca65fcfa44d97b7f82b4220c83, and otherwise stop and report. Otherwise make exactly this one edit (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]}))
   ```
   with
   ```text
         [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}))
   ```

   The resulting file's Git blob is c836bfabc1ce86ca65fcfa44d97b7f82b4220c83.

10. Check whether `lib/Watch-Subagents.ps1` contains `ORVION_DATA_ROOT_NOT_ABSOLUTE`; if so record Already Applied when its Git blob is 4b7e9d3663229e9b752cfae0517e6b2115d12d85, and otherwise stop and report. Otherwise make exactly this one edit (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
         [string]$EventRoot=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]}))
   ```
   with
   ```text
         [string]$EventRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent))[0]}))
   ```

   The resulting file's Git blob is 4b7e9d3663229e9b752cfae0517e6b2115d12d85.

11. Check whether `lib/test-pulse.ps1` contains `OutputProbeOnly`; if so record Already Applied when its Git blob is cae6733812779ec89c02e57018c8ee7508d53806, and otherwise stop and report. Otherwise make exactly these 4 edits (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([string]$Library=$PSScriptRoot)
   ```
   with
   ```text
   param([string]$Library=$PSScriptRoot,[switch]$OutputProbeOnly)
   ```

   b) immediately after the line
   ```text
   $pulseJournal=Join-Path $pulseFixture 'events/events.jsonl'
   ```
   insert
   ```text
   # Keep process/log discovery synthetic as well as the journal and repositories.
   $pulseLauncher=Join-Path $pulseFixture 'invoke-pulse.ps1'
   $pulseLaunchText=@'
   param([string]$Pulse,[string]$Data,[string]$Repository)
   function Get-CimInstance{param([string]$ClassName,[string]$Filter) if($ClassName-eq'Win32_OperatingSystem'){[pscustomobject]@{FreePhysicalMemory=1000000;FreeVirtualMemory=2000000}}}
   if($Repository){& $Pulse -Root $Data -Repos $Repository}else{& $Pulse -Root $Data -Repos @()};exit $LASTEXITCODE
   '@
   [IO.File]::WriteAllText($pulseLauncher,$pulseLaunchText)
   ```

   c) replace the line
   ```text
       $pulseLines=@(& pwsh -NoProfile -File $pulsePath -Root $pulseFixture -Repos $selectedRepository 2>&1)
   ```
   with
   ```text
       $pulseLines=@(& pwsh -NoProfile -File $pulseLauncher -Pulse $pulsePath -Data $pulseFixture -Repository $selectedRepository 2>&1)
   ```

   d) immediately after the line
   ```text
   try{
   ```
   insert
   ```text
       Set-PulseFixtureEvents @()
       [void][IO.Directory]::CreateDirectory((Join-Path $pulseFixture 'sessions'))
       $largeRow=@{id='large-index-fixture';prompts=1;title=('T'*10000);lastPrompt=('L'*10000);end='2026-10-20T00:00:00Z';repo='fixture';client='fixture';raw='sessions\raw\fixture.jsonl'}
       [IO.File]::WriteAllText((Join-Path $pulseFixture 'sessions/index.jsonl'),($largeRow|ConvertTo-Json -Compress)+"`n")
       $largeObserved=Invoke-PulseCheck ''
       $largeLine=[regex]::Match($largeObserved.Text,'(?m)^last     session .*?"(?<title>[^"]*)" ended .*?last ask: "(?<prompt>[^"]*)"')
       Assert-PulseCheck 'large session title is bounded to 300 characters with ellipsis' ($largeObserved.Exit-eq0-and$largeLine.Success-and$largeLine.Groups['title'].Value-ceq(('T'*297)+'...'))
       Assert-PulseCheck 'large last prompt is bounded to 300 characters with ellipsis' ($largeObserved.Exit-eq0-and$largeLine.Success-and$largeLine.Groups['prompt'].Value-ceq(('L'*297)+'...'))
       Assert-PulseCheck 'bounded session display retains its absolute archive pointer' ($largeObserved.Exit-eq0-and$largeObserved.Text.Contains('; archive: '+(Join-Path $pulseFixture $largeRow.raw)))
       [IO.File]::Delete((Join-Path $pulseFixture 'sessions/index.jsonl'))
       if($OutputProbeOnly){if($pulseFailures){throw 'PULSE_OUTPUT_PROBE_FAILED'};$pulseCompleted=$true;'PULSE_OUTPUT_PROBE PASS';return}
   ```

   The resulting file's Git blob is cae6733812779ec89c02e57018c8ee7508d53806.

12. Check whether `lib/test-sync-sessions-survival.ps1` contains `SURVIVAL_SELFCHECK`; if so record Already Applied when its Git blob is 8fc8e1428edcab496e4e2c04fcab059b31322898, and otherwise stop and report. Otherwise make exactly these 2 edits (one data root everywhere only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   # (the 30-day cleanup), a Codex session outside the workspace is never archived, and a set-aside copy is not a session.
   ```
   insert
   ```text
   param([switch]$RootProbeOnly)
   ```

   b) immediately after the lines
   ```text
   $fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
   try{
   ```
   insert
   ```text

       # Real no-Root caller with fixture sources; the three destinations must be exclusive.
       $layout=Join-Path $t 'roots';$checkout=Join-Path $layout 'ORVION-Workbench';$copy=Join-Path $checkout 'lib'
       $sibling=Join-Path $layout 'ORVION-Owner-Tools';$override=Join-Path $t 'override store'
       [void][IO.Directory]::CreateDirectory($copy)
       $probeSync=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Sync-Sessions.ps1')).Replace('Local\orvion-sync-sessions',('Local\ws019-'+[guid]::NewGuid().ToString('N')))
       [IO.File]::WriteAllText((Join-Path $copy 'Sync-Sessions.ps1'),$probeSync)
       $probeProjects=Join-Path $t 'root-projects';$probeProject=Join-Path $probeProjects 'C--Fixture-ORVION'
       [void][IO.Directory]::CreateDirectory($probeProject)
       Set-Content (Join-Path $probeProject 'fixture.jsonl') '{"timestamp":"2026-10-20T01:00:00Z","message":{"role":"user","content":"fixture"}}'
       $savedDataRoot=$env:ORVION_DATA_ROOT
       try{
           foreach($case in 'sibling','override','fallback'){
               $env:ORVION_DATA_ROOT=$null
               if($case-eq'fallback'){[IO.Directory]::Delete($sibling,$true)}else{[void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))}
               $expected=if($case-eq'override'){$env:ORVION_DATA_ROOT=$override+'\';$override}elseif($case-eq'sibling'){$sibling}else{$checkout}
               $output=@(& pwsh -NoProfile -File (Join-Path $copy 'Sync-Sessions.ps1') -ClaudeProjects $probeProjects -CodexSessions (Join-Path $t 'empty-codex') -Quiet 2>&1);$syncCode=$LASTEXITCODE
               Assert-That "sync default $case selects only the data root, silent exit 0" ($syncCode-eq0-and!$output.Count-and(Test-Path (Join-Path $expected 'sessions\INDEX.md'))-and($case-eq'fallback'-or!(Test-Path (Join-Path $checkout 'sessions'))))
           }
       }finally{$env:ORVION_DATA_ROOT=$savedDataRoot}
       if($RootProbeOnly){if($fail){throw 'SYNC_ROOT_PROBE_FAILED'};'SYNC_ROOT_PROBE PASS';return}
   ```

   The resulting file's Git blob is 8fc8e1428edcab496e4e2c04fcab059b31322898.

13. Check whether `lib/test-watch-reminder.ps1` contains `WATCH_REMINDER_SELFCHECK`; if so record Already Applied when its Git blob is 192dcf231e6d6de151e97102b6fcd20f17bd646b, and otherwise stop and report. Otherwise make exactly these 4 edits (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
   # Real hook callers in a disposable workspace. Bounded archive/Pulse stubs never start a real follower or journal.
   ```
   with
   ```text
   # Real hook callers in a disposable workspace; bounded followers read only fixture transcripts, with Pulse stubbed.
   param([switch]$RootProbeOnly,[switch]$FailureProbeOnly)
   ```

   b) immediately after the line
   ```text
   $savedProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
   ```
   insert
   ```text
   $inheritedDataRoot=$env:ORVION_DATA_ROOT;$env:ORVION_DATA_ROOT=$null  # hermetic: a caller's data root must not steer the fixture hook
   ```

   c) immediately after the lines
   ```text
   }
   try{
   ```
   insert
   ```text

       # Real hook + real preservation/index code, bounded at the process-discovery boundary.
       $savedDataRoot=$env:ORVION_DATA_ROOT
       try{
           foreach($case in 'override','sibling','fallback','invalid-sibling','invalid-fallback'){
               $layout=Join-Path $t "early-$case";$checkout=Join-Path $layout 'ORVION-Workbench';$probeLib=Join-Path $checkout 'lib'
               $sibling=Join-Path $layout 'ORVION-Owner-Tools';$override=Join-Path $layout 'override store'
               [void][IO.Directory]::CreateDirectory((Join-Path $probeLib 'hooks'))
               $probeHook=Join-Path $probeLib 'hooks\Watch-Reminder.ps1'
               Copy-Item (Join-Path $PSScriptRoot 'hooks\Watch-Reminder.ps1') $probeHook
               $env:ORVION_DATA_ROOT=$null
               if($case-match'sibling'){[void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))}
               $expected=if($case-eq'override'){$env:ORVION_DATA_ROOT=$override;$override}elseif($case-match'sibling'){$sibling}else{$checkout}
               if($case-like'invalid-*'){$env:ORVION_DATA_ROOT='relative-invalid'}
               # Throw on the first Split-Path, before either $lib or $dataRoot is assigned.
               $launcher=Join-Path $layout 'early.ps1'
               $launch=@'
   param([string]$Hook,[switch]$Invalid)
   $global:ws019Early=$true
   function Split-Path{if($global:ws019Early){$global:ws019Early=$false;throw 'FIXTURE_EARLY_FAILURE'};Microsoft.PowerShell.Management\Split-Path @args}
   if($Invalid){Remove-Item Function:\Split-Path}
   & $Hook
   '@
               [IO.File]::WriteAllText($launcher,$launch)
               $stdout=Join-Path $layout 'stdout.txt';$stderr=Join-Path $layout 'stderr.txt'
               ''|& pwsh -NoProfile -File $launcher -Hook $probeHook -Invalid:($case-like'invalid-*') 1>$stdout 2>$stderr
               $code=$LASTEXITCODE;$log=Join-Path $expected 'work\hook-errors.log'
               Assert-That "hook early $case logs once in fallback store; stderr only and exit 0" ($code-eq0-and[IO.File]::ReadAllText($stdout)-eq''-and[IO.File]::ReadAllText($stderr)-match'^WATCH_REMINDER_UNREADABLE:'-and(Test-Path $log)-and@([IO.File]::ReadAllLines($log)).Count-eq1-and[IO.File]::ReadAllText($log)-match'WATCH_REMINDER_UNREADABLE'-and@((Get-ChildItem $layout -Recurse -Filter hook-errors.log)).Count-eq1)
           }
           if($FailureProbeOnly){if($fail){throw 'HOOK_FAILURE_PROBE_FAILED'};'HOOK_FAILURE_PROBE PASS';return}
           foreach($case in 'sibling','override','fallback'){
               $layout=Join-Path $t $case;$checkout=Join-Path $layout 'ORVION-Workbench';$probeLib=Join-Path $checkout 'lib'
               $sibling=Join-Path $layout 'ORVION-Owner-Tools';$override=Join-Path $layout 'override store'
               [void][IO.Directory]::CreateDirectory((Join-Path $probeLib 'hooks'))
               Copy-Item (Join-Path $PSScriptRoot 'hooks\Watch-Reminder.ps1') (Join-Path $probeLib 'hooks')
               $env:ORVION_DATA_ROOT=$null
               if($case-ne'fallback'){[void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))}
               $expected=if($case-eq'override'){$env:ORVION_DATA_ROOT=$override+'\';$override}elseif($case-eq'sibling'){$sibling}else{$checkout}
               $real=[IO.File]::ReadAllText($sync).Replace('function Test-AgentsRunning{[bool](Get-Process -Name claude,codex -ErrorAction SilentlyContinue)}','function Test-AgentsRunning{$false}').Replace('Local\orvion-sync-sessions',('Local\ws019-'+[guid]::NewGuid().ToString('N')))
               [IO.File]::WriteAllText((Join-Path $probeLib 'Sync.real.ps1'),$real)
               # Deliberate checkout default: proves the hook passes Root explicitly even if the library default changes.
               $wrapper=@'
   param([switch]$Library,[string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quiet,[switch]$Follow)
   $checkout=Split-Path $PSScriptRoot -Parent
   if($Library){Add-Content (Join-Path $checkout 'library.calls') $Root;. (Join-Path $PSScriptRoot 'Sync.real.ps1') -Library -Root $Root;return}
   & (Join-Path $PSScriptRoot 'Sync.real.ps1') -Root $Root -Quiet -Follow:$Follow -IntervalSeconds 0
   @{root=$Root;pid=$PID;follow=[bool]$Follow;code=$LASTEXITCODE}|ConvertTo-Json -Compress|Add-Content (Join-Path $checkout 'archive.calls')
   '@
               [IO.File]::WriteAllText((Join-Path $probeLib 'Sync-Sessions.ps1'),$wrapper)
               Set-Content (Join-Path $probeLib 'Pulse.ps1') 'param([string]$Root=(Split-Path $PSScriptRoot -Parent)) Add-Content (Join-Path (Split-Path $PSScriptRoot -Parent) ''pulse.calls'') $Root;''FIXTURE-PULSE'''
               Set-Content (Join-Path $probeLib 'README.md') "## Always`nFIXTURE-TOOLS`n## Next`n"
               $project=Join-Path $env:USERPROFILE '.claude\projects\C--Fixture-ORVION'
               [void][IO.Directory]::CreateDirectory($project)
               [IO.File]::WriteAllText((Join-Path $project 'fixture.jsonl'),"{`"timestamp`":`"2026-10-20T01:00:00Z`",`"message`":{`"role`":`"user`",`"content`":`"fixture`"}}`n")
               $probeHook=Join-Path $probeLib 'hooks\Watch-Reminder.ps1'
               $quiet=@(@{hook_event_name='SessionEnd';cwd=$checkout}|ConvertTo-Json -Compress|& pwsh -NoProfile -File $probeHook 2>&1);$hookCode=$LASTEXITCODE
               $deadline=[DateTime]::UtcNow.AddSeconds(15)
               while(!(Test-Path (Join-Path $checkout 'archive.calls'))-and[DateTime]::UtcNow-lt$deadline){Start-Sleep -Milliseconds 50}
               $call=Get-Content (Join-Path $checkout 'archive.calls') -Raw|ConvertFrom-Json
               $archiveOk=$hookCode-eq0-and!$quiet.Count-and$call.root-eq$expected-and(Test-Path (Join-Path $expected 'sessions\raw\claude\C--Fixture-ORVION\fixture.jsonl'))-and($case-eq'fallback'-or!(Test-Path (Join-Path $checkout 'sessions')))
               Assert-That "hook $case archives fixture in data root without split archive; silent exit 0" $archiveOk
               if(!$archiveOk){"HOOK_FIXTURE_DIAGNOSTIC: case=$case hook=$hookCode child=$($call.code) stdoutRows=$($quiet.Count) rootMatches=$($call.root-eq$expected) archiveExists=$(Test-Path (Join-Path $expected 'sessions\raw\claude\C--Fixture-ORVION\fixture.jsonl'))"}
               $context=@(@{hook_event_name='SessionStart';cwd=$checkout}|ConvertTo-Json -Compress|& pwsh -NoProfile -File $probeHook)-join' '
               $deadline=[DateTime]::UtcNow.AddSeconds(15)
               while(@(Get-Content (Join-Path $checkout 'archive.calls')).Count-lt2-and[DateTime]::UtcNow-lt$deadline){Start-Sleep -Milliseconds 50}
               $calls=@(Get-Content (Join-Path $checkout 'archive.calls')|ForEach-Object{$_|ConvertFrom-Json})
               foreach($call in $calls){try{$child=Get-Process -Id $call.pid -ErrorAction Stop;if(!$child.WaitForExit(5000)){throw 'ROOT_CHILD_TIMEOUT'}}catch [Microsoft.PowerShell.Commands.ProcessCommandException]{}}
               Assert-That "hook $case passes data root to masking library and Pulse, and reports archive path" ((Get-Content (Join-Path $checkout 'library.calls'))-eq$expected-and(Get-Content (Join-Path $checkout 'pulse.calls'))-eq$expected-and$context.Contains("$expected\sessions\INDEX.md")-and$calls.Count-eq2-and$calls[1].follow)
               $null=@('{bad'|& pwsh -NoProfile -File $probeHook 2>&1)
               Assert-That "hook $case errors use data root" ((Test-Path (Join-Path $expected 'work\hook-errors.log'))-and($case-eq'fallback'-or!(Test-Path (Join-Path $checkout 'work'))))
           }
       }finally{$env:ORVION_DATA_ROOT=$savedDataRoot}
       if($RootProbeOnly){if($fail){throw 'HOOK_ROOT_PROBE_FAILED'};'HOOK_ROOT_PROBE PASS';return}
   ```

   d) replace the line
   ```text
       $env:USERPROFILE=$savedProfile
   ```
   with
   ```text
       $env:USERPROFILE=$savedProfile;$env:ORVION_DATA_ROOT=$inheritedDataRoot
   ```

   The resulting file's Git blob is 192dcf231e6d6de151e97102b6fcd20f17bd646b.

14. Check whether `lib/test-hunt.ps1` contains `HUNT_SELFCHECK`; if so record Already Applied when its Git blob is 01d2204f4c9a748b9b2e688f8daf57176c7cb161, and otherwise stop and report. Otherwise make exactly these 4 edits (one data root everywhere only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   # see IS reported as a surviving mutant, a stale mutant is reported, and nothing is recorded with -NoRecord.
   ```
   insert
   ```text
   param([switch]$RootProbeOnly)
   ```

   b) immediately after the line
   ```text
   try{
   ```
   insert
   ```text

       # Independently controlled source and data with opposing evidence; Quick avoids slow mutants/lint.
       $layout=Join-Path $t 'roots';$checkout=Join-Path $layout 'ORVION-Workbench';$copy=Join-Path $checkout 'lib'
       $sibling=Join-Path $layout 'ORVION-Owner-Tools';$override=Join-Path $layout 'override store';$explicit=Join-Path $t 'explicit store'
       [void][IO.Directory]::CreateDirectory($copy)
       Copy-Item (Join-Path $PSScriptRoot '*') $copy -Recurse
       $savedDataRoot=$env:ORVION_DATA_ROOT
       try{
           foreach($case in 'sibling','override','explicit','fallback'){
               $env:ORVION_DATA_ROOT=$null
               if($case-eq'fallback'){[IO.Directory]::Delete($sibling,$true)}else{[void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))}
               $expected=if($case-eq'explicit'){$env:ORVION_DATA_ROOT=$override;$explicit}elseif($case-eq'override'){$env:ORVION_DATA_ROOT=$override+'\';$override}elseif($case-eq'sibling'){$sibling}else{$checkout}
               [void][IO.Directory]::CreateDirectory((Join-Path $expected 'work'));[void][IO.Directory]::CreateDirectory((Join-Path $expected 'sessions'));[void][IO.Directory]::CreateDirectory((Join-Path $expected 'events'))
               Set-Content (Join-Path $expected 'work\sync-errors.log') "fixture-$case"
               Set-Content (Join-Path $expected 'work\hook-errors.log') "fixture-hook-$case"
               Set-Content (Join-Path $expected 'sessions\marker.jsonl') '{}'
               (Get-Item (Join-Path $expected 'sessions\marker.jsonl')).LastWriteTimeUtc=[DateTime]::UtcNow.AddHours(-1)
               Set-Content (Join-Path $expected 'sessions\index.jsonl') '{"id":"fixture","raw":"sessions\\marker.jsonl","bytes":0,"metaBytes":0}'
               Set-Content (Join-Path $expected 'events\events.jsonl') '{torn','{"at":"2026-10-20T01:00:00Z","pattern":"fixture-evidence","evidence":"sessions\\marker.jsonl"}','{"at":"2000-01-01T00:00:00Z","pattern":"hunt-old-root-problem","status":"open","category":"observation"}'
               $archived=Join-Path $expected 'sessions\raw\claude\C--Fixture-ORVION';$source=Join-Path $env:USERPROFILE '.claude\projects\C--Fixture-ORVION'
               [void][IO.Directory]::CreateDirectory($archived);[void][IO.Directory]::CreateDirectory($source)
               Set-Content (Join-Path $archived 'prefix.jsonl') 'old';Set-Content (Join-Path $source 'prefix.jsonl') 'rewritten'
               $extra=if($case-eq'explicit'){@('-DataRoot',$explicit)}else{@()}
               $result=@(& pwsh -NoProfile -File (Join-Path $copy 'Hunt.ps1') -Quick @extra)-join"`n";$huntCode=$LASTEXITCODE
               Assert-That "hunt $case reads sessions, events and sync errors from data root with BUG exit 1" ($huntCode-eq1-and$result-match"BUG sync-errors:.*fixture-$case"-and$result-match'BUG index-consistency:.*index says'-and$result-match'BUG events-corrupt:'-and$result-match'BUG archive-prefix:'-and$result-match"BUG hook-errors:.*fixture-hook-$case"-and$result-notmatch'GAP event-evidence:')
               $rootEvents=@(Get-Content (Join-Path $expected 'events\events.jsonl')|ForEach-Object{try{$_|ConvertFrom-Json}catch{$null=$_}})
               $closed=@($rootEvents|Where-Object pattern -eq 'hunt-old-root-problem')[-1]
               Assert-That "hunt $case records findings and last result only in data root" ((Test-Path (Join-Path $expected 'work\hunt-last.txt'))-and@($rootEvents|Where-Object pattern -eq 'hunt-sync-errors').Count-gt0-and$closed.status-eq'resolved'-and($case-eq'fallback'-or!(Test-Path (Join-Path $checkout 'work'))))
               # Data has no .git. Source has an invalid .git; only the source may decide tools-git.
               Set-Content (Join-Path $checkout '.git') 'gitdir: missing-fixture-git'
               $sourceCheck=@(& pwsh -NoProfile -File (Join-Path $copy 'Hunt.ps1') -Quick -NoRecord @extra)-join"`n"
               Assert-That "hunt $case keeps git checks on source after library import" ($sourceCheck-match'BUG tools-git:')
               Remove-Item -LiteralPath (Join-Path $checkout '.git')
           }
       }finally{$env:ORVION_DATA_ROOT=$savedDataRoot}
       if($RootProbeOnly){if($fail){throw 'HUNT_ROOT_PROBE_FAILED'};'HUNT_ROOT_PROBE PASS';return}
   ```

   c) replace the line
   ```text
       $out=@(& (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $t -NoRecord -MutantSet $set)-join"`n"
   ```
   with
   ```text
       $out=@(& (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $t -DataRoot $t -NoRecord -MutantSet $set)-join"`n"
   ```

   d) replace the line
   ```text
       $null=& (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $t -Quick
   ```
   with
   ```text
       $null=& (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $t -DataRoot $t -Quick
   ```

   The resulting file's Git blob is 01d2204f4c9a748b9b2e688f8daf57176c7cb161.

15. Check whether `lib/test-events.ps1` contains `Sync-Sessions`; if so record Already Applied when its Git blob is 508aca7735b4c700b0470e0076493378045295c4, and otherwise stop and report. Otherwise make exactly these 5 edits (one data root everywhere only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   # the brief's open-first order, and the link from an event to its session's raw record through sessions\index.jsonl.
   ```
   insert
   ```text
   param([switch]$RootProbeOnly,[string]$RelativeTool)
   ```

   b) immediately after the lines
   ```text
   $fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
   try{
   ```
   insert
   ```text
       $expression='$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw ''ORVION_DATA_ROOT_NOT_ABSOLUTE''};$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace''[\\/]hooks$'','''') -Parent) -Parent) ''ORVION-Owner-Tools'')|Where-Object{Test-Path -LiteralPath (Join-Path $_ ''events'')})+@(Split-Path ($PSScriptRoot-replace''[\\/]hooks$'','''') -Parent))[0]})'
       $drift=@(foreach($tool in 'Events','Spider','Pulse','Coordinator','Delegate','Sync-Sessions'){if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot "$tool.ps1")).Contains('[string]$Root='+$expression)){$tool}})+@(if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Watch-Subagents.ps1')).Contains('[string]$EventRoot='+$expression)){'Watch-Subagents'})+@(if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Hunt.ps1')).Contains('[string]$DataRoot='+$expression)){'Hunt'})
       $drift+=@(if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Backup-Workspace.ps1')).Contains('$ownerTools='+$expression)){'Backup-Workspace'})
       $drift+=@(if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot 'hooks\Watch-Reminder.ps1')).Contains('$dataRoot='+$expression)){'Watch-Reminder'})
       Assert-That "every data tool carries the one identical data-root default$(if($drift.Count){' (drifted: '+($drift-join', ')+')'})" (!$drift.Count)
       # Default evaluation must refuse before either PowerShell or .NET can resolve a relative store.
       # A copied library and explicit fixture profile keep a reverted guard safe to exercise.
       $layout=Join-Path $t 'relative-roots';$checkout=Join-Path $layout 'ORVION-Workbench';$copy=Join-Path $checkout 'lib'
       [void][IO.Directory]::CreateDirectory($copy)
       Copy-Item (Join-Path $PSScriptRoot '*') $copy -Recurse
       [void][IO.Directory]::CreateDirectory((Join-Path $layout 'ORVION-Owner-Tools\events'))
       $relativeCases=@(
           @{tool='Events';arguments=@('-Brief')},
           @{tool='Spider';arguments=@('fixture')},
           @{tool='Pulse';arguments=@()},
           @{tool='Coordinator';arguments=@('-Brief')},
           @{tool='Delegate';arguments=@('-List')},
           @{tool='Watch-Subagents';arguments=@('-Session','fixture','-Once')},
           @{tool='Sync-Sessions';arguments=@('-Quiet','-ClaudeProjects',(Join-Path $t 'no-claude'),'-CodexSessions',(Join-Path $t 'no-codex'))},
           @{tool='Backup-Workspace';arguments=@('-Destination',(Join-Path $t 'relative-backup'),'-AllowUnencrypted','-SkipLegacy')},
           @{tool='Hunt';arguments=@('-Quick','-NoRecord')},
           @{tool='hooks\Watch-Reminder';arguments=@()}
       )
       foreach($case in $relativeCases|Where-Object{!$RelativeTool-or$_.tool-eq$RelativeTool}){foreach($launch in 'a','b'){
           $launchRoot=Join-Path $t ("launch-$($case.tool.Replace('\','-'))-$launch")
           [void][IO.Directory]::CreateDirectory($launchRoot)
           # A reverted Pulse/Hunt guard must not discover live runs or read their logs.
           $launcher=Join-Path $launchRoot 'invoke-tool.ps1'
           $arguments=@(foreach($argument in $case.arguments){if($argument-match'^-[A-Za-z]+$'){$argument}else{"'"+$argument.Replace("'","''")+"'"}})
           $toolPath=(Join-Path $copy ($case.tool+'.ps1')).Replace("'","''")
           $launchText=@'
   $ErrorActionPreference='Stop'
   function Get-CimInstance{param([string]$ClassName,[string]$Filter) if($ClassName-eq'Win32_OperatingSystem'){[pscustomobject]@{FreePhysicalMemory=1000000;FreeVirtualMemory=2000000}}}
   '@
           [IO.File]::WriteAllText($launcher,$launchText+"`n& '$toolPath' "+($arguments-join' ')+"`nexit `$LASTEXITCODE`n")
           $info=[Diagnostics.ProcessStartInfo]::new((Get-Command pwsh -CommandType Application|Select-Object -First 1).Source)
           $info.UseShellExecute=$false;$info.CreateNoWindow=$true;$info.WorkingDirectory=$launchRoot
           $info.RedirectStandardOutput=$true;$info.RedirectStandardError=$true;$info.RedirectStandardInput=$true
           $info.Environment['USERPROFILE']=Join-Path $t 'profile'
           $info.Environment['ORVION_DATA_ROOT']='relative-store'
           foreach($argument in @('-NoProfile','-File',$launcher)){$info.ArgumentList.Add($argument)}
           $child=[Diagnostics.Process]::new();$child.StartInfo=$info
           try{
               [void]$child.Start();$stdout=$child.StandardOutput.ReadToEndAsync();$stderr=$child.StandardError.ReadToEndAsync()
               # Invalid input also bounds the hook if its try-path guard is deliberately reverted.
               $child.StandardInput.Write('{fixture-invalid');$child.StandardInput.Close()
               if(!$child.WaitForExit(15000)){throw 'RELATIVE_ROOT_FIXTURE_TIMEOUT'}
               $out=$stdout.GetAwaiter().GetResult();$err=$stderr.GetAwaiter().GetResult();$code=$child.ExitCode
           }finally{$child.Dispose()}
           $refused=if($case.tool-eq'hooks\Watch-Reminder'){
               $code-eq0-and$out-eq''-and@($err.TrimEnd()-split'\r?\n').Count-eq1-and$err-match'^WATCH_REMINDER_UNREADABLE: ORVION_DATA_ROOT_NOT_ABSOLUTE;'
           }else{$code-ne0-and($out+$err)-match'ORVION_DATA_ROOT_NOT_ABSOLUTE'}
           Assert-That "$($case.tool) rejects relative environment root from launch $launch without a relative store" ($refused-and!(Test-Path -LiteralPath (Join-Path $launchRoot 'relative-store'))-and!(Test-Path -LiteralPath (Join-Path $checkout 'relative-store')))
       }}
       if($RootProbeOnly){if($fail){throw 'EVENTS_ROOT_PROBE_FAILED'};'EVENTS_ROOT_PROBE PASS';return}
   ```

   c) replace the line
   ```text
       $null=& $ev -Root (Join-Path $t 'env-store') -Add -Pattern env-store-marker -Session s9 -Summary 'found through ORVION_DATA_ROOT' -Tags 'siblingmarker'
   ```
   with
   ```text
       $null=& $ev -Root (Join-Path $t 'env store') -Add -Pattern env-store-marker -Session s9 -Summary 'found through ORVION_DATA_ROOT' -Tags 'siblingmarker'
   ```

   d) replace the line
   ```text
           $env:ORVION_DATA_ROOT=Join-Path $t 'env-store';$viaEnv=@(& pwsh -NoProfile -File (Join-Path $copy 'Events.ps1') -Find 'siblingmarker')}finally{$env:ORVION_DATA_ROOT=$savedRoot}
   ```
   with
   ```text
           $env:ORVION_DATA_ROOT=(Join-Path $t 'env store')+'\';$viaEnv=@(& pwsh -NoProfile -File (Join-Path $copy 'Events.ps1') -Find 'siblingmarker')}finally{$env:ORVION_DATA_ROOT=$savedRoot}
   ```

   e) replace the lines
   ```text
       Assert-That 'default root finds the sibling data store; ORVION_DATA_ROOT overrides it' (($sib-join' ')-match'sibling-store-marker'-and($viaEnv-join' ')-match'env-store-marker'-and($viaEnv-join' ')-notmatch'sibling-store-marker')
       $expression='$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) ''ORVION-Owner-Tools'')|Where-Object{Test-Path -LiteralPath (Join-Path $_ ''events'')})+@(Split-Path $PSScriptRoot -Parent))[0]})'
       $drift=@(foreach($tool in 'Events','Spider','Pulse','Coordinator','Delegate'){if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot "$tool.ps1")).Contains('[string]$Root='+$expression)){$tool}})+@(if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Watch-Subagents.ps1')).Contains('[string]$EventRoot='+$expression)){'Watch-Subagents'})
       Assert-That "every data tool carries the one identical data-root default$(if($drift.Count){' (drifted: '+($drift-join', ')+')'})" (!$drift.Count)
   ```
   with
   ```text
       Assert-That 'default root finds the sibling data store; ORVION_DATA_ROOT overrides it' (($sib-join' ')-match'sibling-store-marker'-and($viaEnv-join' ')-match'env-store-marker'-and($viaEnv-join' ')-notmatch'sibling-store-marker')
   ```

   The resulting file's Git blob is 508aca7735b4c700b0470e0076493378045295c4.

16. Check whether `lib/test-backup-restore.ps1` contains `ORVION_DATA_ROOT`; if so record Already Applied when its Git blob is 011efcda04e87ccdbdc09094607545eb18334b1b, and otherwise stop and report. Otherwise make exactly these 5 edits (one data root everywhere only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   # loss warned, a legacy folder that is itself a repository backed up; a tampered backup and an existing target refused.
   ```
   insert
   ```text
   param([switch]$RootProbeOnly)
   ```

   b) immediately after the line
   ```text
   $savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
   ```
   insert
   ```text
   $savedGitInjection=@{}
   foreach($key in [Environment]::GetEnvironmentVariables('Process').Keys|Where-Object{$_-match'^GIT_CONFIG_(COUNT|PARAMETERS|KEY_\d+|VALUE_\d+)$'}){
       $savedGitInjection[$key]=[Environment]::GetEnvironmentVariable($key,'Process')
       Remove-Item -LiteralPath ('Env:\'+$key)
   }
   ```

   c) immediately after the line
   ```text
   $previousProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
   ```
   insert
   ```text
   $savedDataRoot=$env:ORVION_DATA_ROOT;$env:ORVION_DATA_ROOT=$null
   ```

   d) immediately after the lines
   ```text
   function Read-BackupTree([string]$Path){(@(Get-ChildItem -LiteralPath $Path -Recurse -File -Force|ForEach-Object{[Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($_.FullName))})-join"`n")}
   try{
   ```
   insert
   ```text
       $gitProbe=@(& git -c ws019.fixture=isolated config --get ws019.fixture 2>&1);$gitProbeCode=$LASTEXITCODE
       $remainingInjection=@([Environment]::GetEnvironmentVariables('Process').Keys|Where-Object{$_-match'^GIT_CONFIG_(COUNT|PARAMETERS|KEY_\d+|VALUE_\d+)$'})
       Assert-That 'backup self-check clears inherited Git configuration injection' ($gitProbeCode-eq0-and($gitProbe-join' ')-ceq'isolated'-and!$remainingInjection.Count)
       $probeLib=Join-Path $gh 'probe-checkout\lib';[void][IO.Directory]::CreateDirectory($probeLib)
       Copy-Item (Join-Path $PSScriptRoot 'Backup-Workspace.ps1') $probeLib
       $override=Join-Path $t 'override store';[void][IO.Directory]::CreateDirectory((Join-Path $override 'events'))
       [void][IO.Directory]::CreateDirectory((Join-Path $gh 'ORVION-Owner-Tools\events'))
       [IO.File]::WriteAllText((Join-Path $override 'events\marker.txt'),'override fixture')
       [IO.File]::WriteAllText((Join-Path $gh 'ORVION-Owner-Tools\events\marker.txt'),'sibling fixture')
       # Only the script layout is needed here; remove it before later Workbench-presence checks.
       $env:ORVION_DATA_ROOT=$override+'\'
       try{$probe=@(& pwsh -NoProfile -File "$probeLib\Backup-Workspace.ps1" -Destination (Join-Path $t 'override-backup') -AllowUnencrypted -SkipLegacy 2>&1);$probeCode=$LASTEXITCODE}
       finally{$env:ORVION_DATA_ROOT=$null}
       $folder=@(Get-ChildItem (Join-Path $t 'override-backup') -Directory)[0].FullName
       $marker=Join-Path $folder 'owner-tools\events\marker.txt'
       Assert-That 'Backup ORVION_DATA_ROOT selects override bytes and their manifest hash instead of sibling store' ($probeCode-eq0-and(Test-Path $marker)-and[IO.File]::ReadAllText($marker)-ceq'override fixture'-and[IO.File]::ReadAllText((Join-Path $folder 'SHA256SUMS.txt')).Contains((Get-FileHash $marker).Hash+'  owner-tools\events\marker.txt'))
       . (Join-Path $PSScriptRoot 'remove-owned.ps1')
       $null=Remove-OrvionOwnedTree (Split-Path $probeLib -Parent) @($t)
       [IO.File]::Delete((Join-Path $gh 'ORVION-Owner-Tools\events\marker.txt'))
       if($RootProbeOnly){if($fail){throw 'BACKUP_ROOT_PROBE_FAILED'};'BACKUP_ROOT_PROBE PASS';return}
   ```

   e) replace the line
   ```text
   }finally{$env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem;$env:USERPROFILE=$previousProfile;Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   ```
   with
   ```text
   }finally{
       foreach($key in [Environment]::GetEnvironmentVariables('Process').Keys|Where-Object{$_-match'^GIT_CONFIG_(COUNT|PARAMETERS|KEY_\d+|VALUE_\d+)$'}){Remove-Item -LiteralPath ('Env:\'+$key)}
       foreach($key in $savedGitInjection.Keys){[Environment]::SetEnvironmentVariable($key,$savedGitInjection[$key],'Process')}
       $env:ORVION_DATA_ROOT=$savedDataRoot;$env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem;$env:USERPROFILE=$previousProfile;Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)
   }
   ```

   The resulting file's Git blob is 011efcda04e87ccdbdc09094607545eb18334b1b.

17. Check whether `lib/README.md` contains `one data root everywhere`; if so record Already Applied when its Git blob is af865a48aeca0f00defca15c7deee54cd695a47b, and otherwise stop and report. Otherwise make exactly these 4 edits (one data root everywhere only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   Data root (trustworthy answers v1): Events, Spider, Pulse, Coordinator, Delegate and Watch-Subagents default `-Root` to
   `ORVION_DATA_ROOT`, else the sibling `..\ORVION-Owner-Tools` store when it has `events\`, else this checkout. A missing or
   damaged store is said, never answered as "nothing found": `EVENTS_UNAVAILABLE` (exit 3), `EVENTS_INCOMPLETE` (exit 2),
   `SPIDER_COVERAGE: incomplete` (exit 3), Pulse `last UNREADABLE` (exit 2). Hunt's `-Root` is still this checkout.
   ```
   with
   ```text
   Data root (one data root everywhere): Events, Spider, Pulse, Coordinator, Delegate, Watch-Subagents, Sync-Sessions,
   Backup-Workspace, Hunt `-DataRoot` and the session hook (`hooks\Watch-Reminder.ps1`) default to
   `ORVION_DATA_ROOT`, else the sibling `..\ORVION-Owner-Tools` store when it has `events\`, else this checkout.
   An environment override must be fully qualified; otherwise `ORVION_DATA_ROOT_NOT_ABSOLUTE` refuses it. The hook
   reports that code on stderr, exits 0, and logs to the next fully qualified fallback root.
   Readers report `EVENTS_UNAVAILABLE` (exit 3), `EVENTS_INCOMPLETE` (exit 2), or `SPIDER_COVERAGE: incomplete` (exit 3).
   Pulse reports a damaged session index as `last UNREADABLE` with exit 2. A missing index prints `last none: no session
   index`; it does not itself make Pulse fail when the journal and selected repositories are readable.
   Hunt's `-Root` stays this checkout (its source and lint scope).

   Codex archival reads the compact first session-metadata line. Its cwd selector accepts a `Documents\GitHub\CRM`
   or `Documents\GitHub\ORVION` prefix, or `ORVION` anywhere in cwd (PowerShell's case-insensitive match).
   Use `C:\cx\ORVION-<task>` for disposable Codex clones, including CRM work: that shape is archived. A generic
   `C:\cx\repo` or `C:\cx\CRM-<task>` is not selected. Naming a clone does not change its native repository authority.
   ```

   b) immediately after the line
   ```text
   ## Always, with the Monitor tool (never a hand-written alarm loop)
   ```
   insert
   ```text
   Codex runs are watched by the orchestrator, or through this checkout's `lib\run_timed.ps1` with `lib\watch_run.ps1` (use absolute paths and the run's explicit WorkingDirectory).
   ```

   c) replace the line
   ```text
   The user-level Claude hook (`hooks\Watch-Reminder.ps1`) is a reporting adapter, never enforcement or approval.
   ```
   with
   ```text
   Claude Code runs this checkout's `lib\hooks\Watch-Reminder.ps1`, a reporting adapter, never enforcement or approval; its sessions/events use the one data root described above.
   ```

   d) replace the line
   ```text
   context. An explicit existing absolute Owner-Tools `-File` command opts in for that event only; mere mentions and
   ```
   with
   ```text
   context. An explicit existing absolute `-File` command inside this Workbench checkout's `lib\` opts in for that event only; mere mentions and
   ```

   The resulting file's Git blob is af865a48aeca0f00defca15c7deee54cd695a47b.

18. Check whether `AGENTS.md` contains `ORVION-Workbench`; if so record Already Applied when its Git blob is 2aa413298cf6b89b32005234f25d465e1664f0ce, and otherwise stop and report. Otherwise make exactly this one edit (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
   # ORVION-Owner-Tools — agents start here
   ```
   with
   ```text
   # ORVION-Workbench — agents start here
   ```

   The resulting file's Git blob is 2aa413298cf6b89b32005234f25d465e1664f0ce.

19. Check whether `README.md` contains `ORVION_DATA_ROOT`; if so record Already Applied when its Git blob is 037320f61a1602a363a283a4a0497db7fbf76ab3, and otherwise stop and report. Otherwise make exactly these 4 edits (one data root everywhere only), each matched once, and change nothing else:

   a) replace the lines
   ```text
      The ONE journal and session archive live in `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools`: pass it as
      `-Root` (below: `<data>`), or the tools read and write an empty store inside this checkout.
   ```
   with
   ```text
      The ONE journal and session archive use the data root: `ORVION_DATA_ROOT`, else the sibling `ORVION-Owner-Tools`
      when it has `events\`, else this checkout; pass that root as `-Root` (below: `<data>`).
   ```

   b) replace the line
   ```text
   | `lib\`, `tests.ps1` | agent tools (index: `lib\README.md`) and their checks | local Git repo (no remote yet) | yes | no |
   ```
   with
   ```text
   | `lib\`, `tests.ps1` | agent tools (index: `lib\README.md`) and their checks | `Shehabhub/ORVION-Workbench`: `workbench-preflight`, then `main` | yes | no |
   ```

   c) replace the lines
   ```text
   - `lib\Sync-Sessions.ps1 -Follow` (started by the session-start hook, one instance) copies every session of the workspace
     into `sessions\raw\` once a minute while any Claude Code or Codex process runs, then a last pass when all are gone;
   ```
   with
   ```text
   - `lib\Sync-Sessions.ps1 -Follow` (started by Claude Code running this checkout's `lib\hooks\Watch-Reminder.ps1`, one instance) copies every session of the workspace
     into `sessions\raw\` under the one data root above once a minute while any Claude Code or Codex process runs, then a last pass when all are gone;
   ```

   d) replace the lines
   ```text
     Measured 2026-10-20 across 49 sessions: one real secret, `CLAUDE_CODE_MESSAGING_TOKEN` in session 84ee17dc (a
     per-session local pipe token, live only while that session runs); every other hit is the local Supabase stack's
     published defaults or code. The raw history stays verbatim (integrity); protection is: never in Git, and the
   ```
   with
   ```text
     The 2026-10-26 secret scan recorded in `docs/RECOVERY.md` found 10 GitHub token shapes in Codex sessions; token shapes do not prove live credentials. Follow its revoke/re-login steps. The raw history stays verbatim (integrity); protection is: never in Git, and the
   ```

   The resulting file's Git blob is 037320f61a1602a363a283a4a0497db7fbf76ab3.

20. Check whether `HANDOFF.md` contains `workbench-preflight`; if so record Already Applied when its Git blob is 399f1ecc5779117fb94fe011b080ef6501ba1e41, and otherwise stop and report. Otherwise make exactly these 2 edits (one data root everywhere only), each matched once, and change nothing else:

   a) replace the lines
   ```text
   - **ORVION-Owner-Tools** (this folder, local Git, no remote) is the owner's external execution and coordination layer:
     agent tools, the session archive, the event journal, combined (two-repository) work. It is never repository
   ```
   with
   ```text
   - **ORVION-Workbench** (this folder, source remote `Shehabhub/ORVION-Workbench`, `workbench-preflight` then `main`) is the owner's external execution and coordination layer:
     agent tools and combined (two-repository) work; the session archive and event journal use one data root: `ORVION_DATA_ROOT`, else sibling `ORVION-Owner-Tools` when it has `events\`, else this checkout. It is never repository
   ```

   b) replace the lines
   ```text
   - **Journal**: `events\events.jsonl` via `Events.ps1 -Add/-Find/-Brief`; **delegation**: `Delegate.ps1` (brief ->
     report -> verdict event). **Sessions**: `sessions\raw\` verbatim (Claude + Codex; sensitive: one live local token
     noted in README), `sessions\INDEX.md`, kept by `Sync-Sessions.ps1`. **Backup**: `Backup-Workspace.ps1 -Package`
   ```
   with
   ```text
   - **Journal**: `events\events.jsonl` under the one data root above via `Events.ps1 -Add/-Find/-Brief`; **delegation**: `Delegate.ps1` (brief ->
     report -> verdict event). **Sessions**: `sessions\raw\` verbatim (Claude + Codex; sensitive: token shapes
     noted in `docs/RECOVERY.md`), `sessions\INDEX.md` under that same data root, kept by `Sync-Sessions.ps1`, started by Claude Code running this checkout's `lib\hooks\Watch-Reminder.ps1`. **Backup**: `Backup-Workspace.ps1 -Package`
   ```

   The resulting file's Git blob is 399f1ecc5779117fb94fe011b080ef6501ba1e41.

21. Check whether `docs/EXECUTION-PLAN.md` contains `RESUME HERE`; if so record Already Applied when its Git blob is 3a0e1dae25ab5c29f8a6d9037244eb21aae0f469, and otherwise stop and report. Otherwise make exactly these 3 edits (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
   The sole live programme checkpoint is [RESUME.md](<C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\20261020-wave1-v3\RESUME.md>). Workbench RESUME owns its active engineering contract; each product owns its own lifecycle. Live owner instructions win; otherwise follow the owning README/AGENTS/Boot and exact contract. Historical HANDOFF files and reports never grant a new scope.
   ```
   with
   ```text
   Start at [README.md](../README.md), then follow the newest `RESUME HERE` checkpoint routed by [RESUME.md](../RESUME.md), then run `pwsh -NoProfile -File lib/Workbench.ps1 -Boot`. Workbench RESUME owns its active engineering contract; each product owns its own lifecycle. Live owner instructions win; otherwise follow the owning README/AGENTS/Boot and exact contract. Historical HANDOFF files and reports never grant a new scope.
   ```

   b) replace the line
   ```text
   The checker still rejects Sandbox/Tests/Temp/Runtime overlap with the authoritative checkout. Keep managed operational data external. Until a tested stage5 cutover, use existing declared external packet/factory roots and the one old ORVION-Owner-Tools event/session store. A future consolidated `GitHub/ORVION-Workbench-Data` sibling is a target, not created or installed by this plan. This deliberate external data boundary preserves isolation; ignored folders are not an exemption.
   ```
   with
   ```text
   The checker still rejects Sandbox/Tests/Temp/Runtime overlap with the authoritative checkout. Keep managed operational data external. Until a tested stage5 cutover, use existing declared external packet/factory roots and the one event/session data root: `ORVION_DATA_ROOT`, else the sibling `ORVION-Owner-Tools` when it has `events\`, else this checkout. A future consolidated `GitHub/ORVION-Workbench-Data` sibling is a target, not created or installed by this plan. This deliberate external data boundary preserves isolation; ignored folders are not an exemption.
   ```

   c) replace the line
   ```text
   Source admission, the own RESUME route and original readiness certification are COMPLETE in WS005 R4. The selected checkout has its own fresh original receipt and archives; never overwrite them with old-root working receipts. Reuse the normal local `.githooks` admission and preserve origin/hash-verified historical evidence when a range requires it. The one old event/session journal remains external by explicit Root. Neither Boot nor WS005 readiness proves full environment recovery or the future storage cutover.
   ```
   with
   ```text
   Source admission, the own RESUME route and original readiness certification are COMPLETE in WS005 R4. The selected checkout has its own fresh original receipt and archives; never overwrite them with old-root working receipts. Reuse the normal local `.githooks` admission and preserve origin/hash-verified historical evidence when a range requires it. Explicit Root selects the one event/session data root described above. Neither Boot nor WS005 readiness proves full environment recovery or the future storage cutover.
   ```

   The resulting file's Git blob is 3a0e1dae25ab5c29f8a6d9037244eb21aae0f469.

22. Check whether `docs/RECOVERY.md` contains `actionlint`; if so record Already Applied when its Git blob is 30a1008bf31c9e8b3f27d03f253876c95ea68cb0, and otherwise stop and report. Otherwise make exactly these 4 edits (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
   | GitHub\ORVION-Owner-Tools: sessions archive, events journal, work | Clean nested clones (each keeps `.clone-state\state.json`: origin, HEAD, refs) |
   ```
   with
   ```text
   | One data root: `ORVION_DATA_ROOT`, else sibling `ORVION-Owner-Tools` when it has `events\`, else this checkout: sessions archive, events journal, work | Clean nested clones (each keeps `.clone-state\state.json`: origin, HEAD, refs) |
   ```

   b) replace the line
   ```text
   a linked worktree in a main repository, or files under ORVION-Owner-Tools\work\sandboxes. Commit or remove them first.
   ```
   with
   ```text
   a linked worktree in a main repository, or files under the one data root's `work\sandboxes`. Commit or remove them first.
   ```

   c) replace the lines
   ```text
      (evidence paths exceed 260 characters). Optional scoop tools used by product checks: actionlint (pinned by the
      repositories), gitleaks, supabase, trivy.
   ```
   with
   ```text
      (evidence paths exceed 260 characters). Workbench requires the external actionlint 1.7.12 Windows/amd64 executable pinned by `Get-WorkbenchCITool` (archive and executable SHA256), supplied via `-Actionlint` or `WORKBENCH_ACTIONLINT` for targeted tests, as required by `WORKFLOW.md`; never fetch latest implicitly. Optional scoop tools used by product checks: gitleaks, supabase, trivy.
   ```

   d) replace the line
   ```text
      then Pulse with `-Root` ORVION-Owner-Tools. Restart the session archiver (`lib\Sync-Sessions.ps1`) as before.
   ```
   with
   ```text
      Restore places the data store at `<GitHub>\ORVION-Owner-Tools` (`<GitHub>` is Restore's `-Target`, or
      `%USERPROFILE%\Documents\GitHub` by default). If `ORVION_DATA_ROOT` was set before recovery, unset it or point it
      to that restored directory before starting hooks or readers. Then run Pulse with `-Root` set to that store.
      Claude Code runs this checkout's `lib\hooks\Watch-Reminder.ps1`; it starts the session archiver (`lib\Sync-Sessions.ps1`) with that data root.
   ```

   The resulting file's Git blob is 30a1008bf31c9e8b3f27d03f253876c95ea68cb0.

23. Check whether `docs/WORKSPACE-LAYOUT.md` contains `ORVION_DATA_ROOT`; if so record Already Applied when its Git blob is 0b2ddeb385bffd91bb5c4546b0fd9f3cb1827fa6, and otherwise stop and report. Otherwise make exactly these 5 edits (one data root everywhere only), each matched once, and change nothing else:

   a) replace the line
   ```text
   Encrypted recovery copies belong on their actual approved backup medium outside the sole working disk. They are not replaced by data/evidence or a Git push. Store recovery proof/pointers under its owning unit; never copy credentials into a local recovery folder. External Windows tools/authentication and installed services are dependencies to diagnose, not directories copied into this repo.
   ```
   with
   ```text
   Recovery copies belong in the unencrypted compressed package in OneDrive by owner decision of 2026-10-26; follow [RECOVERY.md](RECOVERY.md) for secret-scan review, cloud-copy verification and restore proof. They are not replaced by data/evidence or a Git push. Store recovery proof/pointers under its owning unit; never copy credentials into a local recovery folder. External Windows tools/authentication and installed services are dependencies to diagnose, not directories copied into this repo.
   ```

   b) replace the line
   ```text
   The owner-authorized private remote is https://github.com/Shehabhub/ORVION-Workbench; accepted f42c5a0 main was published and downloaded with matching tree and read-only Boot. WS005 R4 subsequently installed the canonical docs and completed the single-live-location cutover locally; its six commits through 2310836a2b70f6e98b85a30a490efd286a85417f are unpublished. Separate exact publication authorization, bounded subject/history/privacy review and fresh readback remain required. Source publication is distinct from protected recovery of unique external assurance/receipts.
   ```
   with
   ```text
   The owner-authorized source remote is https://github.com/Shehabhub/ORVION-Workbench (public, as recorded in README.md and RECOVERY.md); accepted f42c5a0 main was published and downloaded with matching tree and read-only Boot. WS005 R4 subsequently installed the canonical docs and completed the single-live-location cutover locally; its six commits through 2310836a2b70f6e98b85a30a490efd286a85417f are unpublished. Separate exact publication authorization, bounded subject/history/privacy review and fresh readback remain required. Source publication is distinct from protected recovery of unique external assurance/receipts.
   ```

   c) replace the line
   ```text
   | Documents/GitHub/ORVION-Workbench | actual selected source clone, same accepted history and private origin; keep this Git root |
   ```
   with
   ```text
   | Documents/GitHub/ORVION-Workbench | actual selected source clone, same accepted history and source origin; keep this Git root |
   ```

   d) replace the line
   ```text
   | Documents/GitHub/ORVION-Owner-Tools | preserved old clone and the one current sessions/events/work store; route explicitly until tested migration, no parallel live journal |
   ```
   with
   ```text
   | Documents/GitHub/ORVION-Owner-Tools | preserved old clone; the one sessions/events data root is `ORVION_DATA_ROOT`, else this sibling when it has `events\`, else this checkout; no parallel live journal |
   ```

   e) replace the line
   ```text
   7. Plan stage 6 proves encrypted clean-machine recovery of the selected real layout. Stage 7 retains ADR-0033 closure and the owner-held Batch 6 decision.
   ```
   with
   ```text
   7. Plan stage 6 proves clean-machine recovery of the selected real layout using the unencrypted OneDrive package and verification steps in [RECOVERY.md](RECOVERY.md). Stage 7 retains ADR-0033 closure and the owner-held Batch 6 decision.
   ```

   The resulting file's Git blob is 0b2ddeb385bffd91bb5c4546b0fd9f3cb1827fa6.

## Acceptance Criteria

- [ ] Exact approved scoped output. check: blob:lib/Sync-Sessions.ps1=e674fcf83b4b5ac1363da8b2013a39fdf4a47db2
- [ ] Exact approved scoped output. check: blob:lib/hooks/Watch-Reminder.ps1=f72275d083abc1ee0bf0fba2cdfad6769943cc2f
- [ ] Exact approved scoped output. check: blob:lib/Hunt.ps1=da35c87362b38010be1a4c2092d05a524c3a8b18
- [ ] Exact approved scoped output. check: blob:lib/Backup-Workspace.ps1=b758ee5e99e0aa18960ac3c60bc613cfb6c49450
- [ ] Exact approved scoped output. check: blob:lib/Events.ps1=3de2ece51245a5205ad168684d98a593cd3ff82e
- [ ] Exact approved scoped output. check: blob:lib/Spider.ps1=647887da093bddf1f499796a214b8996b6546e79
- [ ] Exact approved scoped output. check: blob:lib/Pulse.ps1=eb3fadea63c3386af20ae1d8f82f77dffdda9804
- [ ] Exact approved scoped output. check: blob:lib/Coordinator.ps1=3d66f1bfe022c1d1b7c8bc335f31a98825c0e054
- [ ] Exact approved scoped output. check: blob:lib/Delegate.ps1=c836bfabc1ce86ca65fcfa44d97b7f82b4220c83
- [ ] Exact approved scoped output. check: blob:lib/Watch-Subagents.ps1=4b7e9d3663229e9b752cfae0517e6b2115d12d85
- [ ] Exact approved scoped output. check: blob:lib/test-pulse.ps1=cae6733812779ec89c02e57018c8ee7508d53806
- [ ] Exact approved scoped output. check: blob:lib/test-sync-sessions-survival.ps1=8fc8e1428edcab496e4e2c04fcab059b31322898
- [ ] Exact approved scoped output. check: blob:lib/test-watch-reminder.ps1=192dcf231e6d6de151e97102b6fcd20f17bd646b
- [ ] Exact approved scoped output. check: blob:lib/test-hunt.ps1=01d2204f4c9a748b9b2e688f8daf57176c7cb161
- [ ] Exact approved scoped output. check: blob:lib/test-events.ps1=508aca7735b4c700b0470e0076493378045295c4
- [ ] Exact approved scoped output. check: blob:lib/test-backup-restore.ps1=011efcda04e87ccdbdc09094607545eb18334b1b
- [ ] Exact approved scoped output. check: blob:lib/README.md=af865a48aeca0f00defca15c7deee54cd695a47b
- [ ] Exact approved scoped output. check: blob:AGENTS.md=2aa413298cf6b89b32005234f25d465e1664f0ce
- [ ] Exact approved scoped output. check: blob:README.md=037320f61a1602a363a283a4a0497db7fbf76ab3
- [ ] Exact approved scoped output. check: blob:HANDOFF.md=399f1ecc5779117fb94fe011b080ef6501ba1e41
- [ ] Exact approved scoped output. check: blob:docs/EXECUTION-PLAN.md=3a0e1dae25ab5c29f8a6d9037244eb21aae0f469
- [ ] Exact approved scoped output. check: blob:docs/RECOVERY.md=30a1008bf31c9e8b3f27d03f253876c95ea68cb0
- [ ] Exact approved scoped output. check: blob:docs/WORKSPACE-LAYOUT.md=0b2ddeb385bffd91bb5c4546b0fd9f3cb1827fa6
- [ ] The owning tests prove, for the sibling store, ORVION_DATA_ROOT and the checkout fallback: Sync-Sessions defaults to the data root; the hook archives into the data root and never creates <checkout>\sessions, passes the root to the masking library and Pulse, logs errors in the data root and still logs through the fallback when the root itself fails, silent with exit 0 on success; Hunt reads sessions, events and sync/hook errors from -DataRoot and writes findings there while git and lint checks stay on its source root; Backup packages the data-root store; the drift test pins the identical expression in all ten data tools; a relative ORVION_DATA_ROOT from two launch directories is refused by every tool and creates no store, while an absolute root with spaces and a trailing separator works; Pulse bounds title and last prompt to 300 characters and keeps the archive pointer; the backup check clears and restores injected git config (GIT_CONFIG_COUNT/PARAMETERS/KEY_n/VALUE_n); test-watch-reminder is hermetic to an inherited ORVION_DATA_ROOT.
- [ ] Mandatory V1/V2/V3, focused proof, planted-regression mutants, accepted literal replay controls and the real read-only measurement are preserved. One isolated native timed/watched Finish owns the full schedule with a fresh SANDBOX receipt before original approval; the original needs its own fresh Finish, live Review, native Complete and an independent carrying-range READY.

## Review Gate

- [ ] Inspect the twenty-three scoped files, the focused/mutant/literal evidence and the real read-only measurement; preserve all frozen prior evidence.
- [ ] Independently check the native receipt root/Draft/recipe/evaluator/fingerprint, ordered tests and timed/watcher/host exits; normal native Review/Complete and every new carrying transition must pass. No second-agent or provider certification is claimed.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Decision D21 in C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\DECISIONS.md (under the owner's D19 request, D20 rules and D12 approval). Codex implemented in a disposable clone under orchestrator supervision (proto1, fix2, fix3) and reviewed the candidate at xhigh effort before freeze (codex\review1-report.txt). Under the owner's exceptional delegation this one Workbench contract is authorized. Gate 1 for this Draft is DELEGATED: the owner did not type its digest. Sandbox approval is synthetic and grants no original authority.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws019-package\assurance\V3\DRAFT.md
Approved SHA256: 6AB4A612E704F84785799F7D28C5ABD52027B1C8A2305BCAC2DFB3307979807B
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\GATE1-WS019-DELEGATED.md
Owner Evidence SHA256: 3B7D53BBEE5A2C960B1ECCDA28C4BCC81C31390191CFC58CCFD774E70A6E9D72
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws019-package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: B2FD6690E06E19526818CF7AF5F6A9E94AC37D70646FEC52BC5FE38EBA6FA27A
Original admission: DELEGATED exact Gate 1 under the owner's exceptional delegation of 2026-10-26 (OWNER-DELEGATION.md SHA-256 94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217; decisions D1-D21; D21 is the delegated decision for this contract). The owner did not type this digest. Bound to this literal root, the exact V3 digest and the fresh sandbox receipt; no sandbox receipt transplant as original certification.

## Verification Notes

Measured before freeze on the real workstation, read-only (real-measurement.json; booleans and hook shapes only): no ORVION_DATA_ROOT override is set; the identical expression evaluated from the live checkout resolves to ORVION-Owner-Tools, which holds events\events.jsonl and sessions\raw; the checkout has no sessions folder of its own; the owner's five Watch-Reminder hook entries all run the old ORVION-Owner-Tools lib copy, one PostToolUse entry is an exact duplicate. Codex proved 26+7+21 direct mutants killed; the orchestrator's ten planted regressions are each detected (mutants.log); a Codex xhigh pre-freeze review (codex\review1-report.txt) proved a relative ORVION_DATA_ROOT selected stores by current directory (Hunt crashed), unbounded Pulse output (20 KB), non-archived generic Codex clone names and three inaccurate doc statements, all fixed in fix4; the orchestrator found and fixed a fix4 regression (the new Pulse test launcher dropped the exit code, failing two assertions) that Codex could not see because its full check was blocked; hazard scan 0; thirteen owning self-checks PASS with an isolated ORVION_DATA_ROOT, which exposed a non-hermetic hook test (fixed by the orchestrator: the test clears and restores an inherited override). The orchestrator found two Codex misses: lib/README still said Hunt's root was this checkout and named six tools, and RESUME.md edits were dropped because native stages own that file.

## Selection reasons and sources

Evidence Refresh: focused-selected.log PASS for thirteen owning self-checks on the selected bytes, ten planted regressions detected, hazard scan 0, real read-only measurement, literal replay controls run before the one sandbox Finish. Baseline 4cdf1d5 (main = preflight = WS-018), accepted judge 835E14DA unchanged.

Sources: DECISIONS.md D19/D20/D21, ws019-package\codex, accepted WORKFLOW/TEMPLATE/checker, WS-018 packet scripts, the real read-only measurement.
