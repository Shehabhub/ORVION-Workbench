# Self-check for hooks\Watch-Reminder.ps1's timed-run reminder: a rooted run_timed path names the watch_run beside it;
# a path built from variables, or a session folder that is not a repository, never yields a watcher path that does not
# exist (measured 2026-10-20: it printed ORVION-Owner-Tools\scripts\watch_run.ps1 and an unexpanded $E3 log).
$ErrorActionPreference='Stop'
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
$hook=Join-Path $PSScriptRoot 'hooks\Watch-Reminder.ps1'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-hookcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory "$t\repo\scripts" -Force|Out-Null
function Invoke-Hook([string]$Command,[string]$Cwd){
    $e=@{hook_event_name='PostToolUse';tool_name='PowerShell';cwd=$Cwd;tool_input=@{command=$Command;run_in_background=$true};tool_response=@{}}|ConvertTo-Json -Depth 4 -Compress
    $o=$e|& pwsh -NoProfile -File $hook;if(!$o){return ''};("$o"|ConvertFrom-Json).hookSpecificOutput.additionalContext
}
try{
    Set-Content "$t\repo\scripts\watch_run.ps1" '#'
    # the hook stays silent outside the ORVION workspace, so the session folder is a real workspace path
    $ws=Split-Path $PSScriptRoot -Parent
    $c=Invoke-Hook "pwsh -NoProfile -File `"$t\repo\scripts\run_timed.ps1`" -Log `"C:\logs\a.log`" -Command `"pwsh -NoProfile -File scripts/test_agent_continuity.ps1`"" $ws
    Assert-That 'a rooted run_timed path names the watch_run beside it' ($c.Contains("$t\repo\scripts\watch_run.ps1")-and$c.Contains('-Run control-suite'))
    $c=Invoke-Hook 'pwsh -NoProfile -File "$E\pt\scripts\run_timed.ps1" -Log "$E3\pt-suite.log" -Command "pwsh -NoProfile -File scripts/test_agent_continuity.ps1"' $ws
    Assert-That 'a path built from variables yields no invented watcher path, and the log is flagged' ($c.Contains('<the folder of the run_timed.ps1 you started>')-and$c.Contains('expand the variables')-and!$c.Contains("$ws\scripts\watch_run.ps1"))
}finally{[IO.Directory]::Delete($t,$true)}
if($fail){throw "WATCH_REMINDER_SELFCHECK_FAILED $fail"};'WATCH_REMINDER_SELFCHECK PASS'
