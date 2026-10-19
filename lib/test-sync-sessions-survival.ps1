# Survival check for Sync-Sessions.ps1 on temp sources: a session stays indexed after Claude Code deletes its source
# (the 30-day cleanup), a Codex session outside the workspace is never archived, and a set-aside copy is not a session.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-survival-$([guid]::NewGuid().ToString('N').Substring(0,6))"
$cp=Join-Path $t 'claude-projects';$cx=Join-Path $t 'codex-sessions';$ws=Join-Path $t 'ws'
New-Item -ItemType Directory "$cp\C--Users-x-Documents-GitHub-CRM","$cx\2026\10\20","$ws\sessions" -Force|Out-Null
. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $ws -ClaudeProjects $cp -CodexSessions $cx
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
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
}finally{[IO.Directory]::Delete($t,$true)}
if($fail){throw "SURVIVAL_SELFCHECK_FAILED $fail"};'SURVIVAL_SELFCHECK PASS'
