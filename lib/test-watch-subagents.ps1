# Self-check for Watch-Subagents.ps1 on synthetic transcripts (shapes measured on real agents, 2026-10-20): a text block
# still being followed by a tool call is not FINISHED; end_turn is; the harness's interruption marker is STOPPED but a tool
# result saying "was stopped" is not; a one-line transcript is seen; an old unanswered tool call is STALLED (exit 2).
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-wscheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";$d=Join-Path $t 'sess\subagents';New-Item -ItemType Directory $d -Force|Out-Null
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
function New-Agent([string]$Id,[string[]]$Lines,[int]$AgeMinutes=0){$p=Join-Path $d "agent-$Id.jsonl";[IO.File]::WriteAllLines($p,$Lines);if($AgeMinutes){(Get-Item $p).LastWriteTime=(Get-Date).AddMinutes(-$AgeMinutes)}}
try{
    $u='{"type":"user","message":{"role":"user","content":"go"}}'
    New-Agent midtext @($u,'{"type":"assistant","message":{"role":"assistant","stop_reason":null,"content":[{"type":"text","text":"Writing the file now."}]}}')
    New-Agent done @($u,'{"type":"assistant","message":{"role":"assistant","stop_reason":"end_turn","content":[{"type":"text","text":"VERDICT: done"}]}}')
    New-Agent killed @($u,'{"type":"user","message":{"role":"user","content":[{"type":"text","text":"[Request interrupted by user]"}]}}')
    New-Agent toolsays @($u,'{"type":"user","message":{"role":"user","content":[{"type":"tool_result","content":"container x was stopped"}]}}')
    New-Agent oneline @('{"type":"assistant","message":{"role":"assistant","stop_reason":"end_turn","content":[{"type":"text","text":"only line"}]}}')
    New-Agent stuck @($u,'{"type":"assistant","message":{"role":"assistant","stop_reason":"tool_use","content":[{"type":"tool_use","name":"Grep","input":{"path":"C:/elsewhere"}}]}}') 10
    $o=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Watch-Subagents.ps1') -Session (Join-Path $t 'sess') -Once);$code=$LASTEXITCODE
    function Get-State([string]$Id){(@($o|Where-Object{$_-like"$Id *"})[0]-split' ')[1]}
    Assert-That 'a text block before a tool call is not FINISHED' ((Get-State midtext)-eq'WORKING')
    Assert-That 'end_turn is FINISHED' ((Get-State done)-eq'FINISHED')
    Assert-That 'the interruption marker is STOPPED' ((Get-State killed)-eq'STOPPED')
    Assert-That 'a tool result saying "was stopped" is not STOPPED' ((Get-State toolsays)-eq'WORKING')
    Assert-That 'a one-line transcript is seen' ((Get-State oneline)-eq'FINISHED')
    Assert-That 'an old unanswered tool call is a stall (exit 2)' ((Get-State stuck)-eq'TOOL'-and$code-eq2)
}finally{[IO.Directory]::Delete($t,$true)}
if($fail){throw "WATCHDOG_SELFCHECK_FAILED $fail"};'WATCHDOG_SELFCHECK PASS'
