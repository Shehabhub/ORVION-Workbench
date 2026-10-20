# Self-check for Sync-Sessions.ps1's continuous archive: partial lines wait, growth appends, a killed append is
# completed, a rewritten source keeps the old copy, and the incremental index equals a full read.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-synctest-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t|Out-Null
. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $t  # never the real workspace
$src=Join-Path $t 'src.jsonl';$dst=Join-Path $t 'a\dst.jsonl';$fail=0
function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
function Write-Bytes([string]$Path,[string]$Text,[switch]$Append){$m=if($Append){'Append'}else{'Create'};$s=[IO.File]::Open($Path,$m,'Write','ReadWrite');try{$b=[Text.Encoding]::UTF8.GetBytes($Text);$s.Write($b,0,$b.Length)}finally{$s.Close()}}
try{
    Write-Bytes $src "{`"timestamp`":`"2026-10-20T01:00:00Z`",`"n`":1}`n{`"n`":2,`"partial"
    $null=Copy-Grown $src $dst
    Assert-That 'partial line waits' ([IO.File]::ReadAllText($dst)-ceq"{`"timestamp`":`"2026-10-20T01:00:00Z`",`"n`":1}`n")
    Write-Bytes $src "`":true}`n{`"n`":3,`"SPEC`":`"SPEC-123`"}`n" -Append
    $null=Copy-Grown $src $dst
    Assert-That 'growth appends complete lines' ([IO.File]::ReadAllText($dst)-ceq[IO.File]::ReadAllText($src))
    Write-Bytes $dst '{"n":4,"half' -Append  # a sync killed mid-append
    Write-Bytes $src "{`"n`":4,`"half`":1}`n" -Append
    $null=Copy-Grown $src $dst
    Assert-That 'killed append is completed' ([IO.File]::ReadAllText($dst)-ceq[IO.File]::ReadAllText($src))
    $row=New-IndexRow 'claude' 'test'
    Update-Meta $row $dst 'claude';$inc1=$row.lines
    Write-Bytes $src "{`"timestamp`":`"2026-10-20T02:00:00Z`",`"x`":`"CLAUDE_CODE_MESSAGING_TOKEN=0123456789abcdef0123456789abcdef`"}`n" -Append
    $null=Copy-Grown $src $dst;Update-Meta $row $dst 'claude'
    $full=New-IndexRow 'claude' 'test';Update-Meta $full $dst 'claude'
    Assert-That 'incremental index equals a full read' ($inc1-eq4-and$row.lines-eq$full.lines-and$row.metaBytes-eq(Get-Item $dst).Length-and$row.end-eq$full.end-and"$($row.specs)"-eq'SPEC-123')
    Assert-That 'NAME=value credential named, value not stored' ("$($row.secretNames)"-eq'CLAUDE_CODE_MESSAGING_TOKEN'-and$row.secretHits-eq1-and(($row|ConvertTo-Json)-notmatch'0123456789abcdef'))
    Write-Bytes $src ('{"type":"user","message":{"role":"user","content":"Fix the watcher ETA please"}}'+"`n"+'{"type":"user","isMeta":true,"message":{"role":"user","content":"meta, not a prompt"}}'+"`n"+'{"message":{"role":"user","content":"<task-notification>not a prompt</task-notification>"}}'+"`n"+'{"content":[{"type":"tool_use","id":"t1","name":"PowerShell","input":{}}]}'+"`n"+'{"content":[{"type":"tool_result","is_error":true}]}'+"`n") -Append
    $null=Copy-Grown $src $dst;Update-Meta $row $dst 'claude'
    Assert-That 'task, prompts, tools and errors are indexed' ($row.firstPrompt-eq'Fix the watcher ETA please'-and$row.lastPrompt-eq'Fix the watcher ETA please'-and$row.prompts-eq1-and$row.toolCalls-eq1-and$row.tools['PowerShell']-eq1-and$row.errors-eq1)
    $cx=Join-Path $t 'cx.jsonl'
    Write-Bytes $cx ('{"type":"event_msg","payload":{"type":"user_message","client_id":"x","message":"Line one\nSPEC-200 \"quoted\""}}'+"`n"+'{"type":"response_item","payload":{"type":"custom_tool_call","id":"c","status":"completed","name":"exec"}}'+"`n"+'{"type":"response_item","payload":{"type":"function_call","id":"f","name":"js","namespace":"mcp__cua_repl"}}'+"`n"+'{"m":"SPEC-999 SPEC-200 SPEC-200"}'+"`n")
    $cr=New-IndexRow 'codex' 'cx';Update-Meta $cr $cx 'codex'
    Assert-That 'Codex prompt and tools indexed, title unescaped' ($cr.prompts-eq1-and$cr.firstPrompt-ceq'Line one SPEC-200 "quoted"'-and$cr.toolCalls-eq2-and$cr.tools['mcp__cua_repl.js']-eq1)
    Assert-That 'most-mentioned SPEC ranks first' ($cr.specs[0]-eq'SPEC-200')
    Write-Bytes $src "{`"rewritten`":true}`n"
    $null=Copy-Grown $src $dst
    Assert-That 'rewritten source keeps the old copy beside' ([IO.File]::ReadAllText($dst)-ceq"{`"rewritten`":true}`n"-and@(Get-ChildItem (Split-Path $dst) -Filter 'dst.replaced-*').Count-eq1)
}finally{Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
if($fail){throw "SYNC_SELFCHECK_FAILED $fail"};'SYNC_SELFCHECK PASS'
