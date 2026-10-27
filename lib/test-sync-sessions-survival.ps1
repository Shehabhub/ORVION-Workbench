# Survival check for Sync-Sessions.ps1 on temp sources: a session stays indexed after Claude Code deletes its source
# (the 30-day cleanup), a Codex session outside the workspace is never archived, and a set-aside copy is not a session.
param([switch]$RootProbeOnly,[switch]$SortProbeOnly)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-survival-$([guid]::NewGuid().ToString('N').Substring(0,6))"
$cp=Join-Path $t 'claude-projects';$cx=Join-Path $t 'codex-sessions';$ws=Join-Path $t 'ws'
New-Item -ItemType Directory "$cp\C--Users-x-Documents-GitHub-CRM","$cx\2026\10\20","$ws\sessions" -Force|Out-Null
. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $ws -ClaudeProjects $cp -CodexSessions $cx
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
    if(!$RootProbeOnly){
        # One cached September DateTime among 16 new October strings broke the en-US comparer at 17 rows.
        & {
            $sortStore=Join-Path $t 'sort-store';$sortCulture=[cultureinfo]::CurrentCulture
            . (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $sortStore -ClaudeProjects (Join-Path $t 'no-sort-claude') -CodexSessions (Join-Path $t 'no-sort-codex')
            try{
                [cultureinfo]::CurrentCulture='en-US';$script:failures=0
                [void][IO.Directory]::CreateDirectory((Join-Path $raw 'codex'))
                foreach($sortNumber in 0..16){
                    $sortId='f{0:00}' -f $sortNumber
                    $sortStamp=if($sortNumber-eq8){'2026-09-12T00:00:00Z'}else{'2026-10-20T23:42:00Z'}
                    [IO.File]::WriteAllText((Join-Path $raw "codex\$sortId.jsonl"),('{"timestamp":"'+$sortStamp+'"}'+"`n"))
                }
                $sortCachedPath=Join-Path $raw 'codex\f08.jsonl'
                $sortCached=New-IndexRow 'codex' 'f08';$sortCached.headHash=Get-HeadHash $sortCachedPath
                Update-Meta $sortCached $sortCachedPath 'codex'
                [IO.File]::WriteAllText($indexPath,($sortCached|ConvertTo-Json -Compress -Depth 4)+"`n")
                Assert-That 'sort fixture seeds an ISO cache read as DateTime without DateKind String' (([IO.File]::ReadAllText($indexPath)|ConvertFrom-Json -AsHashtable).start-is[datetime])
                foreach($sortPass in 1..2){
                    $sortRows=@()
                    try{Invoke-Pass;$sortRows=@(Update-Index)}catch{Write-SyncError 'sort fixture pass' $_}
                    Assert-That "sort pass $sortPass keeps all 17 archive rows" ($sortRows.Count-eq17-and(@($sortRows.id|Sort-Object -Unique)-join',')-ceq(@(0..16|ForEach-Object{'f{0:00}' -f $_})-join','))
                    Assert-That "sort pass $sortPass keeps start and end as strings" ($sortRows.Count-eq17-and!@($sortRows|Where-Object{$_.start-isnot[string]-or$_.end-isnot[string]}).Count)
                    Assert-That "sort pass $sortPass writes both indexes without sync errors" ($script:failures-eq0-and!(Test-Path -LiteralPath $errLog)-and(Test-Path -LiteralPath $indexPath)-and(Test-Path -LiteralPath (Join-Path $Root 'sessions\INDEX.md')))
                }
            }finally{[cultureinfo]::CurrentCulture=$sortCulture}
        }
        if($SortProbeOnly){if($fail){throw 'SYNC_SORT_PROBE_FAILED'};'SYNC_SORT_PROBE PASS';return}
    }

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
            if($case-eq'fallback'){$null=Remove-OrvionOwnedTree -Path $sibling -AllowedRoots @($t)}else{[void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))}
            $expected=if($case-eq'override'){$env:ORVION_DATA_ROOT=$override+'\';$override}elseif($case-eq'sibling'){$sibling}else{$checkout}
            $output=@(& pwsh -NoProfile -File (Join-Path $copy 'Sync-Sessions.ps1') -ClaudeProjects $probeProjects -CodexSessions (Join-Path $t 'empty-codex') -Quiet 2>&1);$syncCode=$LASTEXITCODE
            if($case-eq'fallback'){
                # No data root: refuse with a stable code and never archive into the source checkout (WS-022).
                Assert-That 'sync without a data root refuses and writes nothing into the checkout' ($syncCode-ne0-and($output-join' ')-match'ORVION_DATA_ROOT_UNAVAILABLE'-and!(Test-Path (Join-Path $checkout 'sessions'))-and!(Test-Path (Join-Path $checkout 'work')))
            }else{
                Assert-That "sync default $case selects only the data root, silent exit 0" ($syncCode-eq0-and!$output.Count-and(Test-Path (Join-Path $expected 'sessions\INDEX.md'))-and!(Test-Path (Join-Path $checkout 'sessions')))
            }
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
}finally{$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}
if($fail){throw "SURVIVAL_SELFCHECK_FAILED $fail"};'SURVIVAL_SELFCHECK PASS'
