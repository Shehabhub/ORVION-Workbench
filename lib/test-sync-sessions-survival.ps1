# Survival check for Sync-Sessions.ps1 on temp sources: a session stays indexed after Claude Code deletes its source
# (the 30-day cleanup), a Codex session outside the workspace is never archived, and a set-aside copy is not a session.
param([switch]$RootProbeOnly)
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-survival-$([guid]::NewGuid().ToString('N').Substring(0,6))"
$cp=Join-Path $t 'claude-projects';$cx=Join-Path $t 'codex-sessions';$ws=Join-Path $t 'ws'
New-Item -ItemType Directory "$cp\C--Users-x-Documents-GitHub-CRM","$cx\2026\10\20","$ws\sessions" -Force|Out-Null
. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $ws -ClaudeProjects $cp -CodexSessions $cx
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{

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
    $src="$cp\C--Users-x-Documents-GitHub-CRM\sess-1.jsonl"
    Set-Content $src '{"timestamp":"2026-10-20T01:00:00Z","cwd":"C:\\Users\\x\\Documents\\GitHub\\CRM","message":{"role":"user","content":"keep me"}}'
    Set-Content "$cx\2026\10\20\rollout-2026-10-20T01-00-00-01a00000-0000-0000-0000-000000000001.jsonl" '{"payload":{"cwd":"C:\\Users\\x\\Elsewhere"}}'
    Invoke-Pass;$rows=@(Update-Index)
    Assert-That 'session archived and indexed' (@($rows|Where-Object id -eq 'sess-1').Count-eq1)
    Assert-That 'a Codex session outside the workspace is not archived' (!(Test-Path "$ws\sessions\raw\codex"))
    Remove-Item $src  # Claude Code's 30-day cleanup
    Invoke-Pass;$rows=@(Update-Index)
    Assert-That 'the session stays indexed after its source is deleted' (@($rows|Where-Object id -eq 'sess-1').Count-eq1-and@($rows|Where-Object id -eq 'sess-1')[0].firstPrompt-eq'keep me')
    Copy-Item "$ws\sessions\raw\claude\C--Users-x-Documents-GitHub-CRM\sess-1.jsonl" "$ws\sessions\raw\claude\C--Users-x-Documents-GitHub-CRM\sess-1.replaced-20261020010000.jsonl"
    Invoke-Pass;$rows=@(Update-Index)
    Assert-That 'a set-aside copy is not indexed as a session' ($rows.Count-eq1)
    Assert-That 'INDEX.md is written' ((Get-Content "$ws\sessions\INDEX.md" -Raw)-match'keep me')
    $sync=Join-Path $t 'sync.ps1';$locked="$cp\C--Users-x-Documents-GitHub-CRM\locked.jsonl"
    $body=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Sync-Sessions.ps1')).Replace('Local\orvion-sync-sessions',('Local\orvion-sync-sessions-'+[guid]::NewGuid().ToString('N')))
    [IO.File]::WriteAllText($sync,$body)
    [IO.File]::WriteAllText($locked,"{}`n")
    $handle=[IO.File]::Open($locked,'Open','ReadWrite','None')
    try{$failed=@(& pwsh -NoProfile -File $sync -Root $ws -ClaudeProjects $cp -CodexSessions $cx -Quiet 2>&1);$code=$LASTEXITCODE}finally{$handle.Dispose()}
    $onceFailed=$code-eq3-and($failed-join' ')-match'SESSIONS: preservation FAILED'-and(Test-Path "$ws\work\sync-errors.log")
    # Only process discovery is stubbed: the first failed pass recovers before the final pass.
    $followerPath=Join-Path $t 'follow.ps1'
    $body=[IO.File]::ReadAllText($sync).Replace('function Test-AgentsRunning{[bool](Get-Process -Name claude,codex -ErrorAction SilentlyContinue)}','function Test-AgentsRunning{$blocked=Join-Path $Root ''sessions\raw\claude\C--Users-x-Documents-GitHub-CRM\locked.jsonl'';if(Test-Path -LiteralPath $blocked -PathType Container){Remove-Item -LiteralPath $blocked};return $false}')
    [IO.File]::WriteAllText($followerPath,$body)
    [void][IO.Directory]::CreateDirectory("$ws\sessions\raw\claude\C--Users-x-Documents-GitHub-CRM\locked.jsonl")
    $failed=@(& pwsh -NoProfile -File $followerPath -Root $ws -ClaudeProjects $cp -CodexSessions $cx -Quiet -Follow -IntervalSeconds 0 2>&1);$code=$LASTEXITCODE
    Assert-That 'quiet follower remembers a failed pass after recovery and exits 3' ($code-eq3-and($failed-join' ')-match'SESSIONS: preservation FAILED'-and(Test-Path "$ws\sessions\raw\claude\C--Users-x-Documents-GitHub-CRM\locked.jsonl" -PathType Leaf))
    $success=@(& pwsh -NoProfile -File $sync -Root $ws -ClaudeProjects $cp -CodexSessions $cx -Quiet 2>&1)
    Assert-That 'quiet preservation failure is visible with exit 3; success stays silent with exit 0' ($onceFailed-and$LASTEXITCODE-eq0-and$success.Count-eq0)
}finally{[IO.Directory]::Delete($t,$true)}
if($fail){throw "SURVIVAL_SELFCHECK_FAILED $fail"};'SURVIVAL_SELFCHECK PASS'
