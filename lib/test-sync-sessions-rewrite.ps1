# Rewrite and edge cases for Sync-Sessions.ps1 (each found by the 2026-10-20 independent bug hunt), through the real
# pass and index on temp sources: a transcript rewritten and grown restarts its index row and keeps the old copy; an
# edited memory file (same length, early edit) keeps the old copy; a file without an extension that shrinks loses
# nothing; CRLF lines are counted byte-exactly; a line over 1 MB still being written is not archived half-done.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-rewrite-$([guid]::NewGuid().ToString('N').Substring(0,6))"
$cp=Join-Path $t 'projects';$proj=Join-Path $cp 'C--Users-x-Documents-GitHub-CRM';$ws=Join-Path $t 'ws'
New-Item -ItemType Directory "$proj\memory","$ws\sessions" -Force|Out-Null
. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $ws -ClaudeProjects $cp -CodexSessions (Join-Path $t 'none')
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
$arch="$ws\sessions\raw\claude\C--Users-x-Documents-GitHub-CRM"
function Get-Aside([string]$Pattern){@(Get-ChildItem $arch -Recurse -File -Filter $Pattern)}
function Invoke-Sync{Invoke-Pass;$script:rows=@(Update-Index)}
try{
    $s="$proj\s1.jsonl"
    [IO.File]::WriteAllText($s,'{"timestamp":"2026-10-20T01:00:00Z","cwd":"C:\\Users\\x\\Documents\\GitHub\\CRM","message":{"role":"user","content":"OLD TASK"}}'+"`n")
    Invoke-Sync
    [IO.File]::WriteAllText($s,'{"timestamp":"2026-10-20T03:00:00Z","cwd":"C:\\Users\\x\\Documents\\GitHub\\CRM","message":{"role":"user","content":"NEW TASK, a longer first line than before"}}'+"`n"+'{"message":{"role":"user","content":"second"}}'+"`n")
    Invoke-Sync
    $r=@($rows|Where-Object id -eq 's1')[0]
    Assert-That 'a rewritten, grown transcript restarts its index row' ($r.firstPrompt-eq'NEW TASK, a longer first line than before'-and$r.prompts-eq2-and$r.lines-eq2-and$r.metaBytes-eq$r.bytes)
    Assert-That 'and keeps the old copy beside' ((Get-Aside 's1.replaced-*.jsonl').Count-eq1-and([IO.File]::ReadAllText("$arch\s1.jsonl"))-ceq[IO.File]::ReadAllText($s))
    $m="$proj\memory\note.md";[IO.File]::WriteAllText($m,"first value`nrest of the note`n");Invoke-Sync
    [IO.File]::WriteAllText($m,"other value`nrest of the note`n");(Get-Item $m).LastWriteTime=(Get-Date).AddMinutes(1);Invoke-Sync
    Assert-That 'an edited memory file (same length) is re-copied and the old copy kept' ([IO.File]::ReadAllText("$arch\memory\note.md")-ceq"other value`nrest of the note`n"-and(Get-Aside 'note.replaced-*.md').Count-eq1)
    $n="$proj\NOEXT";[IO.File]::WriteAllText($n,'AAAAAAAAAA');Invoke-Sync
    [IO.File]::WriteAllText($n,'BBBB');(Get-Item $n).LastWriteTime=(Get-Date).AddMinutes(2);Invoke-Sync
    Assert-That 'a file without an extension that shrinks loses nothing' ([IO.File]::ReadAllText("$arch\NOEXT")-ceq'BBBB'-and@(Get-ChildItem $arch -File -Filter 'NOEXT.replaced-*'|Where-Object{[IO.File]::ReadAllText($_.FullName)-ceq'AAAAAAAAAA'}).Count-eq1)
    $c="$proj\crlf.jsonl";[IO.File]::WriteAllText($c,"{`"timestamp`":`"2026-10-20T04:00:00Z`",`"a`":1}`r`n{`"b`":`"é`"}`r`n");Invoke-Sync
    $cr=@($rows|Where-Object id -eq 'crlf')[0]
    Assert-That 'CRLF and multi-byte lines are counted byte-exactly' ($cr.lines-eq2-and$cr.metaBytes-eq(Get-Item "$arch\crlf.jsonl").Length)
    $big="$proj\big.jsonl";$fs=[IO.File]::Open($big,'Create','Write','ReadWrite')
    try{$b=[Text.Encoding]::UTF8.GetBytes('{"timestamp":"2026-10-20T05:00:00Z","x":"'+('y'*(1300KB))+'"');$fs.Write($b,0,$b.Length)}finally{$fs.Close()}
    Invoke-Sync
    Assert-That 'a line over 1 MB still being written is not archived half-done' (!(Test-Path "$arch\big.jsonl")-or(Get-Item "$arch\big.jsonl").Length-eq0)
    [IO.File]::AppendAllText($big,"}`n");Invoke-Sync
    Assert-That 'and is archived whole once complete' ((Get-FileHash "$arch\big.jsonl").Hash-eq(Get-FileHash $big).Hash)
}finally{Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
if($fail){throw "REWRITE_SELFCHECK_FAILED $fail"};'REWRITE_SELFCHECK PASS'
