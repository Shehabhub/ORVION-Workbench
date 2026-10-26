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
