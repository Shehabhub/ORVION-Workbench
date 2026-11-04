# Self-check for Watch-Quiet.ps1: a job that keeps writing is silent until it exits (one DONE line); a live job that
# stops writing is reported once as STALLED and left running; a missing path is UNREADABLE; a log held open still counts.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-quietcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t -Force|Out-Null
$tool=Join-Path $PSScriptRoot 'Watch-Quiet.ps1'
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
    $w=Start-Process pwsh -ArgumentList '-NoProfile','-Command',"1..4|%{Set-Content '$t\log.txt' `$_;Start-Sleep 1}" -PassThru -WindowStyle Hidden
    $o=@(& pwsh -NoProfile -File $tool -WatchPid $w.Id -Path $t -QuietMinutes 0.5 -PollSeconds 1)
    Assert-That 'a job that keeps writing, then exits, gives one DONE line' ($o.Count-eq1-and$o[0]-like'DONE:*'-and$LASTEXITCODE-eq0)
    $s=Start-Process pwsh -ArgumentList '-NoProfile','-Command','Start-Sleep 30' -PassThru -WindowStyle Hidden
    $o=@(& pwsh -NoProfile -File $tool -WatchPid $s.Id -Path $t -QuietMinutes 0.05 -PollSeconds 1)
    Assert-That 'a live job that stops writing gives one STALLED line' ($o.Count-eq1-and$o[0]-like'STALLED:*'-and$LASTEXITCODE-eq2)
    Assert-That 'the stalled job is left running' (!!(Get-Process -Id $s.Id -ErrorAction SilentlyContinue))
    $o=@(& pwsh -NoProfile -File $tool -WatchPid $s.Id -Path "$t\nope")
    Assert-That 'a missing path is UNREADABLE' ($o[0]-like'UNREADABLE:*'-and$LASTEXITCODE-eq1)
    $held=Join-Path $t 'held';New-Item -ItemType Directory $held|Out-Null
    $h=Start-Process pwsh -ArgumentList '-NoProfile','-Command',"`$f=[IO.File]::AppendText('$held\log.txt');1..14|%{`$f.WriteLine(`$_);`$f.Flush();Start-Sleep 1};`$f.Close()" -PassThru -WindowStyle Hidden
    $o=@(& pwsh -NoProfile -File $tool -WatchPid $h.Id -Path $held -QuietMinutes 0.1 -PollSeconds 1);$code=$LASTEXITCODE;$h.WaitForExit()
    Assert-That 'a job writing to a log it holds open gives DONE, not STALLED' ($o.Count-eq1-and$o[0]-like'DONE:*'-and$code-eq0)
}finally{if($s){Stop-Process -Id $s.Id -Force -ErrorAction SilentlyContinue};[IO.Directory]::Delete($t,$true)}
if($fail){throw "QUIET_SELFCHECK_FAILED $fail"};'QUIET_SELFCHECK PASS'
