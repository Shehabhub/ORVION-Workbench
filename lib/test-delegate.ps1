# Self-check for Delegate.ps1 in a temp root: the brief carries the question, the known history, the authority limits
# and the exact report and record lines; the delegation is itself an event; -List shows pending, then the verdict.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-delegcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t|Out-Null
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
    & (Join-Path $PSScriptRoot 'Events.ps1') -Root $t -Add -Pattern zebra-case -Session s1 -Category failure -Summary 'ZEBRA-42 broke once'|Out-Null
    $out=@(& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $t -Pattern zebra-case -Question 'Does ZEBRA-42 break again?' -Mode sandbox -Minutes 10)
    $briefPath=([regex]::Match(($out-join"`n"),'DELEGATED zebra-case -> (.+BRIEF\.md)')).Groups[1].Value
    $b=[IO.File]::ReadAllText($briefPath)
    Assert-That 'brief has the question and the known history' ($b.Contains('Does ZEBRA-42 break again?')-and$b.Contains('ZEBRA-42 broke once'))
    Assert-That 'brief bounds authority' ($b.Contains('MUST NOT commit, push')-and$b.Contains('Mode: **sandbox**')-and$b.Contains('10 minutes'))
    Assert-That 'brief names the exact report and record lines' ($b.Contains('VERDICT: CONFIRMED')-and$b.Contains('Do not record events')-and$b.Contains('saves your reply as')-and$b-notmatch'create ````'-and$b.Contains((Join-Path (Split-Path $briefPath) 'REPORT.md')))
    $ev=@([IO.File]::ReadAllLines((Join-Path $t 'events\events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json})
    Assert-That 'the delegation is recorded as an event' (@($ev|Where-Object{$_.source-eq'delegate-road'-and$_.summary-like'delegated (sandbox, 10 min)*'}).Count-eq1)
    Assert-That 'list shows it pending' ((@(& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $t -List)-join' ')-match'pending \(no REPORT\.md yet\)')
    Set-Content (Join-Path (Split-Path $briefPath) 'REPORT.md') "VERDICT: DISPROVEN`nCause: ..."
    Assert-That 'list shows the verdict once reported' ((@(& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $t -List)-join' ')-match'zebra-case: DISPROVEN')
    $bad=try{& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $t -Pattern 'Not Valid' -Question x|Out-Null;$false}catch{$true}
    Assert-That 'a malformed pattern id is refused' $bad
}finally{[IO.Directory]::Delete($t,$true)}
if($fail){throw "DELEGATE_SELFCHECK_FAILED $fail"};'DELEGATE_SELFCHECK PASS'
