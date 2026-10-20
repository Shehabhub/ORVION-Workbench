# Self-check for Events.ps1 in a temp root: add, duplicate refusal, recurrence across sessions, ranking by rare words,
# the brief's open-first order, and the link from an event to its session's raw record through sessions\index.jsonl.
$ErrorActionPreference='Stop'
$ev=Join-Path $PSScriptRoot 'Events.ps1'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-evcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory "$t\sessions" -Force|Out-Null
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
    '{"id":"s1-aaaaaaaa","start":"2026-10-01T10:00:00Z","title":"first session","raw":"sessions\\raw\\s1.jsonl"}'|Set-Content "$t\sessions\index.jsonl"
    $a=& $ev -Root $t -Add -Pattern ps-reserved-name -Session s1-aaaaaaaa -Category failure -Status resolved -Summary 'param named $Pid broke' -Tool Test-ScriptHazards.ps1 -Tags 'pid process param'
    $b=& $ev -Root $t -Add -Pattern ps-reserved-name -Session s1-aaaaaaaa -Category failure -Status resolved -Summary 'param named $Pid broke'
    $c=& $ev -Root $t -Add -Pattern ps-reserved-name -Session s2-bbbbbbbb -Category failure -Status resolved -Summary 'param named $event broke' -Tags 'pid process param'
    $null=& $ev -Root $t -Add -Pattern watch-run-eta -Session s2-bbbbbbbb -Category proposal -Status deferred -Summary 'no ETA for a new run name' -Tags 'watcher eta script'
    $null=& $ev -Root $t -Add -Pattern other-script -Session s2-bbbbbbbb -Category observation -Status resolved -Summary 'a script ran' -Tags 'script'
    Assert-That 'add, duplicate refused, recurrence counted' ("$a"-match'RECORDED.*\(1 session'-and"$b"-match'DUPLICATE'-and"$c"-match'\(2 session')
    $f=@(& $ev -Root $t -Find 'write a script that takes a process id')
    Assert-That 'rare words rank the right pattern first' ($f[1]-match'^\[resolved x2 .*ps-reserved-name')
    Assert-That 'find links the raw session record' (($f-join"`n")-match'raw record: session s2-bbbbb|raw record: session s1-aaaaa')
    $br=@(& $ev -Root $t -Brief)
    Assert-That 'brief lists open or deferred first, then recurring' ($br[1]-match'watch-run-eta'-and$br[2]-match'ps-reserved-name'-and(($br-join' ')-notmatch'other-script'))
    $bad=try{& $ev -Root $t -Add -Pattern 'Bad Pattern' -Summary x;$false}catch{$true}
    Assert-That 'a malformed pattern id is refused' $bad
    $before=(Get-Content "$t\events\events.jsonl").Count
    $jobs=1..12|ForEach-Object{Start-Job -ScriptBlock {param($e,$r,$i)& pwsh -NoProfile -File $e -Root $r -Add -Pattern race-case -Session "w$i" -Summary "writer $i"} -ArgumentList $ev,$t,$_}
    $null=$jobs|Wait-Job;$jobs|Remove-Job
    Assert-That '12 writers at once lose no line' ((Get-Content "$t\events\events.jsonl").Count-eq$before+12)
    Add-Content "$t\events\events.jsonl" '{"torn line'
    $okBrief=try{$null=& $ev -Root $t -Brief;$true}catch{$false};$okFind=try{$null=& $ev -Root $t -Find 'process';$true}catch{$false}
    Assert-That 'a torn line does not silence the readers' ($okBrief-and$okFind)
}finally{[IO.Directory]::Delete($t,$true)}
if($fail){throw "EVENTS_SELFCHECK_FAILED $fail"};'EVENTS_SELFCHECK PASS'
