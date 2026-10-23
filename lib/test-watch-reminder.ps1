# Real hook callers in a disposable workspace. Bounded archive/Pulse stubs never start a real follower or journal.
$ErrorActionPreference='Stop'
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
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
}
try{
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
    $env:USERPROFILE=$savedProfile
    $resolved=[IO.Path]::GetFullPath($t);if(!$resolved.StartsWith([IO.Path]::GetTempPath(),[StringComparison]::OrdinalIgnoreCase)-or(Split-Path $resolved -Leaf)-notlike'orvion-hookcheck-*'){throw 'HOOK_TEST_CLEANUP_BOUNDARY'}
    [IO.Directory]::Delete($resolved,$true)
}
if($fail){throw "WATCH_REMINDER_SELFCHECK_FAILED $fail"};'WATCH_REMINDER_SELFCHECK PASS'
