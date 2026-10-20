# Self-check for Coordinator.ps1 in a temp root, the whole loop with a moved clock: an observation nobody owns is TRIAGE;
# assigned it is READY; past due OVERDUE (-Check fails); dispatched it is DISPATCHED, OVERDUE when no report returns;
# Delegate.ps1 -Report brings the verdict back owned by the agent; closing removes it; a reopened item needs a new owner;
# decisions wait on the owner; a deferral without a date is refused; every finder records into the same journal.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-coordcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t|Out-Null
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
$co=Join-Path $PSScriptRoot 'Coordinator.ps1';$ev=Join-Path $PSScriptRoot 'Events.ps1';$de=Join-Path $PSScriptRoot 'Delegate.ps1'
function Get-State([string]$Pattern,[datetime]$At=[DateTime]::UtcNow){$l=@(& $co -Root $t -Now $At)|Where-Object{$_-match" $Pattern "};if($l){($l-split'\s+')[0]}else{'GONE'}}
try{
    & $ev -Root $t -Add -Pattern lynx-leak -Session s1 -Category failure -Severity warn -Summary 'LYNX-7 leaked a handle'|Out-Null
    Assert-That 'an observation nobody owns is TRIAGE' ((Get-State lynx-leak)-eq'TRIAGE')
    & $co -Root $t -Assign lynx-leak -Owner agent -Action 'close the handle in finally' -Due ([DateTime]::UtcNow.AddDays(1).ToString('yyyy-MM-dd'))|Out-Null
    Assert-That 'assigned with an action it is READY' ((Get-State lynx-leak)-eq'READY')
    Assert-That 'the assignment keeps the observation text' ((@(& $co -Root $t)-join' ')-match'LYNX-7 leaked a handle')
    & $co -Root $t -Check -Now ([DateTime]::UtcNow.AddDays(3))|Out-Null
    Assert-That 'past due it is OVERDUE and -Check fails' ((Get-State lynx-leak ([DateTime]::UtcNow.AddDays(3)))-eq'OVERDUE'-and$LASTEXITCODE-eq1)
    $out=@(& $co -Root $t -Dispatch lynx-leak -Question 'Does LYNX-7 leak on every path?' -Minutes 10)
    $dir=Split-Path ([regex]::Match(($out-join"`n"),'DELEGATED lynx-leak -> (.+BRIEF\.md)').Groups[1].Value)
    Assert-That 'dispatched it is DISPATCHED' ((Get-State lynx-leak)-eq'DISPATCHED')
    Assert-That 'no report within twice the budget is OVERDUE' ((Get-State lynx-leak ([DateTime]::UtcNow.AddMinutes(25)))-eq'OVERDUE'-and((@(& $co -Root $t -Now ([DateTime]::UtcNow.AddMinutes(25)))-join' ')-match'no report came back'))
    $reply=Join-Path $t 'reply.txt';Set-Content $reply 'no verdict here'
    $refused=try{& $de -Root $t -Report $dir -Reply $reply|Out-Null;$false}catch{"$_"-match'REPORT_NO_VERDICT'}
    Assert-That 'a reply without a VERDICT line is refused' $refused
    Set-Content $reply "VERDICT: CONFIRMED`nCause: confirmed, the error path skips Dispose."
    & $de -Root $t -Report $dir -Reply $reply|Out-Null
    Assert-That 'the verdict comes back owned by the agent with a next action' ((Get-State lynx-leak)-eq'READY'-and((@(& $co -Root $t)-join' ')-match'owner agent: verify the decisive check'))
    Assert-That 'the report is saved once' ((Test-Path (Join-Path $dir 'REPORT.md'))-and$(try{& $de -Root $t -Report $dir -Reply $reply|Out-Null;$false}catch{"$_"-match'REPORT_EXISTS'}))
    & $co -Root $t -Close lynx-leak -Status resolved -Reason 'fixed: Dispose in finally, self-check added'|Out-Null
    & $co -Root $t -Check|Out-Null
    Assert-That 'closed it leaves the queue and -Check passes' ((Get-State lynx-leak)-eq'GONE'-and$LASTEXITCODE-eq0)
    & $ev -Root $t -Add -Pattern lynx-leak -Session s2 -Category failure -Summary 'LYNX-7 leaked again'|Out-Null
    Assert-That 'a reopened item needs a new owner' ((Get-State lynx-leak)-eq'TRIAGE')
    & $ev -Root $t -Add -Pattern owner-pick -Session s1 -Category decision -Cause owner-decision -Summary 'pick a remote'|Out-Null
    Assert-That 'a decision waits on the owner' ((Get-State owner-pick)-eq'OWNER')
    $refused=try{& $co -Root $t -Close lynx-leak -Status deferred -Reason 'later'|Out-Null;$false}catch{"$_"-match'COORDINATOR_DEFER_NEEDS_DUE'}
    Assert-That 'a deferral without a date is refused' $refused
    $refused=try{& $co -Root $t -Assign no-such -Owner agent -Action x|Out-Null;$false}catch{"$_"-match'COORDINATOR_NO_OPEN_ITEM'}
    Assert-That 'acting on an item that is not open is refused' $refused
    & $co -Root $t -Assign lynx-leak -Owner 'cr:handle fix' -Action 'draft the fix' -Due 2030-01-15|Out-Null
    Assert-That 'an assignment keeps its own due date while other items are open' ((@(& $co -Root $t)-join' ')-match'lynx-leak \(age 0 d, due 2030-01-15\)')
    & $co -Root $t -Close lynx-leak -Status deferred -Reason 'after the release' -Due 2030-02-01|Out-Null
    Assert-That 'a deferral keeps its owner and its new date' ((@(& $co -Root $t)-join' ')-match'READY +lynx-leak \(age 0 d, due 2030-02-01\).+owner cr:handle fix')
    & $ev -Root $t -Add -Pattern lynx-leak -Session s3 -Category failure -Summary 'LYNX-7 leaked a third time'|Out-Null
    $brief=@(& $co -Root $t -Brief)
    Assert-That 'a recurrence of a deferred item stays with its owner; the brief counts every state' ($brief[0]-match'^queue    triage 0 \| overdue 0 \| owner 1 \| dispatched 0 \| ready 1')
    # every tool that finds something writes it into the same journal (no private notebooks)
    $silent=@('Hunt.ps1','Watch-Subagents.ps1','Watch-Host.ps1','Delegate.ps1','Coordinator.ps1'|Where-Object{![IO.File]::ReadAllText((Join-Path $PSScriptRoot $_)).Contains('Events.ps1')})
    Assert-That "every finder records into the journal$(if($silent){": not $($silent-join', ')"})" (!$silent)
}finally{[IO.Directory]::Delete($t,$true)}
if($fail){throw "COORDINATOR_SELFCHECK_FAILED $fail"};'COORDINATOR_SELFCHECK PASS'
