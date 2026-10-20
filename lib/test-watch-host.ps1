# Self-check for Watch-Host.ps1, run from a temp copy of lib (so its event goes to a temp log): two pids given the way
# `pwsh -File` passes them ("a,b") are both watched; a forced threshold reports COMMIT LOW once and records one event;
# each exit is reported and the watch ends when all are gone.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-hostcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory "$t\lib" -Force|Out-Null
Copy-Item (Join-Path $PSScriptRoot 'Watch-Host.ps1'),(Join-Path $PSScriptRoot 'Events.ps1') "$t\lib"
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
    $a=Start-Process pwsh -ArgumentList '-NoProfile','-Command','Start-Sleep 4' -PassThru -WindowStyle Hidden
    $b=Start-Process pwsh -ArgumentList '-NoProfile','-Command','Start-Sleep 8' -PassThru -WindowStyle Hidden
    $o=@(& pwsh -NoProfile -File "$t\lib\Watch-Host.ps1" -CommitGB 999 -PollSeconds 1 -WatchPid "$($a.Id),$($b.Id)" -ExitWhenPidsGone)
    Assert-That 'both pids from one "a,b" argument are watched' ($o[0]-match"pids $($a.Id),$($b.Id)")
    Assert-That 'a crossed threshold is reported once' (@($o|Where-Object{$_-like'COMMIT LOW*'}).Count-eq1)
    Assert-That 'each exit is reported, then the watch ends' (@($o|Where-Object{$_-like'PID GONE*'}).Count-eq2-and$o[-1]-eq'ALL PIDS GONE')
    $ev=@(Get-Content "$t\events\events.jsonl"|ForEach-Object{$_|ConvertFrom-Json})
    Assert-That 'the alarm is recorded as one event' (@($ev|Where-Object{$_.pattern-eq'host-memory-pressure'-and$_.source-eq'monitor'}).Count-eq1)
}finally{Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
if($fail){throw "HOST_SELFCHECK_FAILED $fail"};'HOST_SELFCHECK PASS'
