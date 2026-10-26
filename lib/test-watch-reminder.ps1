# Real hook callers in a disposable workspace; bounded followers read only fixture transcripts, with Pulse stubbed.
param([switch]$RootProbeOnly,[switch]$FailureProbeOnly)
$ErrorActionPreference='Stop'
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-hookcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))"
$savedProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
$inheritedDataRoot=$env:ORVION_DATA_ROOT;$env:ORVION_DATA_ROOT=$null  # hermetic: a caller's data root must not steer the fixture hook
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
}
try{

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
    $c=Invoke-Hook "pwsh -NoProfile -File `"$t\repo\scripts\run_timed.ps1`" -Log `"C:\logs\a.log`" -Command `"pwsh -NoProfile -File scripts/test_agent_continuity.ps1`"" $ws
    Assert-That 'a rooted run_timed path names the watch_run beside it' ($c.Contains("$t\repo\scripts\watch_run.ps1")-and$c.Contains('-Run control-suite'))
    $c=Invoke-Hook 'pwsh -NoProfile -File "$E\pt\scripts\run_timed.ps1" -Log "$E3\pt-suite.log" -Command "pwsh -NoProfile -File scripts/test_agent_continuity.ps1"' $ws
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
    $env:USERPROFILE=$savedProfile;$env:ORVION_DATA_ROOT=$inheritedDataRoot
    $resolved=[IO.Path]::GetFullPath($t);if(!$resolved.StartsWith([IO.Path]::GetTempPath(),[StringComparison]::OrdinalIgnoreCase)-or(Split-Path $resolved -Leaf)-notlike'orvion-hookcheck-*'){throw 'HOOK_TEST_CLEANUP_BOUNDARY'}
    [IO.Directory]::Delete($resolved,$true)
}
if($fail){throw "WATCH_REMINDER_SELFCHECK_FAILED $fail"};'WATCH_REMINDER_SELFCHECK PASS'
