# Self-check for Watch-Subagents.ps1 on synthetic transcripts (shapes measured on real agents, 2026-10-20): a text block
# still being followed by a tool call is not FINISHED; end_turn is; the harness's interruption marker is STOPPED but a tool
# result saying "was stopped" is not; a one-line transcript is seen; an old unanswered tool call is STALLED (exit 2).
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-wscheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";$d=Join-Path $t 'sess\subagents';New-Item -ItemType Directory $d -Force|Out-Null
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
$watch=Join-Path $PSScriptRoot 'Watch-Subagents.ps1';$eventRoot=Join-Path $t 'memory';$live=$null
$savedProfile=$env:USERPROFILE
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
if($fail){throw "WATCHDOG_SELFCHECK_FAILED $fail"};'WATCHDOG_SELFCHECK PASS'
