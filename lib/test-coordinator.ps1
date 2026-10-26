# Self-check for Coordinator.ps1 in a disposable root (the real journal is hashed before and after and must not change):
# observations ask nothing (no false escalation); material items become cases; assignment shows prior resolutions;
# explicit due and missing reports escalate; the return road; recurrence after a fix; duplicates; a torn journal line;
# the overhead on a 5,000-record journal; and the value: forgotten work the old session-start brief did not show.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-coordcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t|Out-Null
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
$co=Join-Path $PSScriptRoot 'Coordinator.ps1';$ev=Join-Path $PSScriptRoot 'Events.ps1';$de=Join-Path $PSScriptRoot 'Delegate.ps1'
$real=Join-Path (Split-Path $PSScriptRoot -Parent) 'events\events.jsonl';$realHash=if(Test-Path $real){(Get-FileHash $real).Hash}else{'none'}
function Get-State([string]$Pattern,[datetime]$At=[DateTime]::UtcNow){$l=@(& $co -Root $t -Now $At)|Where-Object{$_-match"^\S+ +$Pattern "};if($l){($l-split'\s+')[0]}else{'NOT A CASE'}}
function Add-Event{& $ev -Root $t -Add @args|Out-Null}
try{
    Add-Event -Pattern quiet-note -Session s1 -Category observation -Summary 'the suite took 43 min'
    Add-Event -Pattern small-warn -Session s1 -Category failure -Severity warn -Summary 'a lint warning'
    Assert-That 'observations and warnings ask nothing of anyone (no false escalation)' ((Get-State quiet-note)-eq'NOT A CASE'-and(Get-State small-warn)-eq'NOT A CASE'-and((@(& $co -Root $t -Brief)-join' ')-match'observations 2'))
    Add-Event -Pattern handle-fix -Session s0 -Category failure -Summary 'OTTER handle leak' -Tags 'otter handle leak dispose'
    & $co -Root $t -Close handle-fix -Status resolved -Reason 'fixed: Dispose in finally (OTTER)'|Out-Null
    Add-Event -Pattern lynx-leak -Session s1 -Category failure -Severity high -Summary 'LYNX handle leak blocks the run' -Tags 'lynx handle leak dispose'
    & $co -Root $t -Check|Out-Null
    $checkCode=$LASTEXITCODE
    Assert-That 'a material item nobody took is UNOWNED, escalated, -Check fails' ((Get-State lynx-leak)-eq'UNOWNED'-and$checkCode-eq1)
    $out=@(& $co -Root $t -Assign lynx-leak -Owner agent -Action 'close the handle in finally')
    Assert-That 'taking work first shows the prior resolution of a related event' ((($out-join' ')-match'PRIOR RESOLUTIONS')-and(($out-join' ')-match'Dispose in finally \(OTTER\)'))
    Assert-That 'owned with an action it is ACTIVE, not escalated, and named as in flight' ((Get-State lynx-leak)-eq'ACTIVE'-and((@(& $co -Root $t -Brief)-join' ')-match'in flight: lynx-leak \(agent\): close the handle in finally')-and((@(& $co -Root $t -Brief)|Select-Object -Skip 1|Where-Object{$_-notmatch'in flight'})-join' ')-notmatch'lynx-leak')
    & $co -Root $t -Assign lynx-leak -Owner agent -Action 'close the handle in finally' -Due ([DateTime]::UtcNow.ToString('yyyy-MM-dd'))|Out-Null
    Assert-That 'an explicit due time escalates once passed' ((Get-State lynx-leak ([DateTime]::UtcNow.AddDays(2)))-eq'OVERDUE')
    $out=@(& $co -Root $t -Dispatch lynx-leak -Question 'Does the LYNX handle leak on every path?' -Minutes 10)
    $dir=Split-Path ([regex]::Match(($out-join"`n"),'DELEGATED lynx-leak -> (.+BRIEF\.md)').Groups[1].Value)
    Assert-That 'the brief carries related past events and how they ended' ([IO.File]::ReadAllText((Join-Path $dir 'BRIEF.md'))-match'(?s)Related past events.+Dispose in finally \(OTTER\)')
    Assert-That 'dispatched it is DISPATCHED; with no report past twice its budget it is OVERDUE' ((Get-State lynx-leak)-eq'DISPATCHED'-and(Get-State lynx-leak ([DateTime]::UtcNow.AddMinutes(25)))-eq'OVERDUE'-and((@(& $co -Root $t -Now ([DateTime]::UtcNow.AddMinutes(25)))-join' ')-match'no report came back'))
    $reply=Join-Path $t 'reply.txt';Set-Content $reply 'no verdict here'
    Assert-That 'a reply without a VERDICT line is refused' $(try{& $de -Root $t -Report $dir -Reply $reply|Out-Null;$false}catch{"$_"-match'REPORT_NO_VERDICT'})
    Set-Content $reply "VERDICT: CONFIRMED`nCause: confirmed, the error path skips Dispose."
    & $de -Root $t -Report $dir -Reply $reply|Out-Null
    Assert-That 'the verdict returns to the agent with a next action, saved once' ((Get-State lynx-leak)-eq'ACTIVE'-and((@(& $co -Root $t)-join' ')-match'owner agent: verify the decisive check')-and$(try{& $de -Root $t -Report $dir -Reply $reply|Out-Null;$false}catch{"$_"-match'REPORT_EXISTS'}))
    & $co -Root $t -Close lynx-leak -Status resolved -Reason 'fixed: Dispose in finally, self-check added'|Out-Null
    & $co -Root $t -Check|Out-Null
    Assert-That 'closed with its reason it leaves the cases and -Check passes' ((Get-State lynx-leak)-eq'NOT A CASE'-and$LASTEXITCODE-eq0)
    Add-Event -Pattern lynx-leak -Session s2 -Category failure -Summary 'LYNX leaked again'
    Assert-That 'a recurrence after a fix is material and shows the last resolution' ((Get-State lynx-leak)-eq'UNOWNED'-and((@(& $co -Root $t)-join' ')-match'last time \(1x\): \S+ resolved: fixed: Dispose in finally, self-check added'))
    Add-Event -Pattern lynx-leak -Session s2 -Category failure -Summary 'LYNX leaked again'
    Add-Event -Pattern lynx-leak -Session s3 -Category failure -Summary 'LYNX leaked again'
    Assert-That 'duplicates and repeats stay one case (one line per fact)' (@(& $co -Root $t|Where-Object{$_-match' lynx-leak '}).Count-eq1-and@([IO.File]::ReadAllLines((Join-Path $t 'events\events.jsonl'))|Where-Object{$_-match'LYNX leaked again'}).Count-eq2)
    Add-Event -Pattern owner-pick -Session s1 -Category decision -Cause owner-decision -Summary 'pick a remote'
    Assert-That 'a genuine decision waits on the owner and is not escalated as noise' ((Get-State owner-pick)-eq'OWNER'-and((@(& $co -Root $t -Brief)|Select-Object -Skip 1)-join' ')-notmatch'owner-pick')
    Add-Event -Pattern technical-choice -Session s1 -Category decision -Cause confirmed -Summary 'use the existing parser' -Owner agent -Action 'prove the parser cases'
    Add-Event -Pattern unclassified-choice -Session s1 -Category decision -Cause hypothesis -Summary 'classify this finding'
    Add-Event -Pattern owner-assigned -Session s1 -Category observation -Summary 'owner must choose' -Owner owner -Action 'choose the commercial option'
    Assert-That 'technical decisions remain ACTIVE; unclassified material choices are UNOWNED; explicit owner assignment remains OWNER' ((Get-State technical-choice)-eq'ACTIVE'-and(Get-State unclassified-choice)-eq'UNOWNED'-and(Get-State owner-assigned)-eq'OWNER')
    Assert-That 'a deferral without a date is refused' $(try{& $co -Root $t -Close lynx-leak -Status deferred -Reason 'later'|Out-Null;$false}catch{"$_"-match'COORDINATOR_DEFER_NEEDS_DUE'})
    Assert-That 'acting on an item that is not open is refused' $(try{& $co -Root $t -Assign no-such -Owner agent -Action x|Out-Null;$false}catch{"$_"-match'COORDINATOR_NO_OPEN_ITEM'})
    $validJournal=Join-Path $t 'events\events.jsonl';$validHash=(Get-FileHash $validJournal).Hash
    $invalidDue=try{& $co -Root $t -Assign technical-choice -Owner agent -Action x -Due not-a-date|Out-Null;$false}catch{"$_"-match'COORDINATOR_DUE_INVALID'}
    Assert-That 'new assignments cannot poison a valid journal with an invalid due date' ($invalidDue-and(Get-FileHash $validJournal).Hash-eq$validHash)
    New-Item -ItemType Directory (Join-Path $t 'sessions')|Out-Null;Set-Content (Join-Path $t 'sessions\index.jsonl') '{"torn index'
    $aux=@(& pwsh -NoProfile -File $co -Root $t -Assign technical-choice -Owner agent -Action 'retain assignment');$auxCode=$LASTEXITCODE
    Assert-That 'incomplete auxiliary lookup warns without blocking assignment' ($auxCode-eq0-and($aux-join' ')-match'EVENTS_INCOMPLETE:'-and(Get-State technical-choice)-eq'ACTIVE')
    $auxLib=Join-Path $t 'aux-lib';New-Item -ItemType Directory $auxLib|Out-Null;Copy-Item $co $auxLib
    # Select an absent store only for the auxiliary read; assignment still appends to its required journal.
    $proxy='param([string]$Root,[string]$Find,[int]$Top);if($Find){& ''__EVENTS__'' -Root (Join-Path $Root ''absent'') -Find $Find -Top $Top;exit $LASTEXITCODE};& ''__EVENTS__'' -Root $Root @args;exit $LASTEXITCODE'
    Set-Content (Join-Path $auxLib 'Events.ps1') ($proxy.Replace('__EVENTS__',$ev.Replace("'","''")))
    $aux=@(& pwsh -NoProfile -File (Join-Path $auxLib 'Coordinator.ps1') -Root $t -Assign technical-choice -Owner agent -Action 'retain assignment');$auxCode=$LASTEXITCODE
    Assert-That 'unavailable auxiliary lookup warns without blocking assignment' ($auxCode-eq0-and($aux-join' ')-match'EVENTS_UNAVAILABLE:'-and(Get-State technical-choice)-eq'ACTIVE')
    # journal corruption: a writer killed mid-line leaves a torn line; the next record must stay readable
    [IO.File]::AppendAllText((Join-Path $t 'events\events.jsonl'),'{"at":"2026-10-20T00:00:00Z","pattern":"torn","summ')
    Add-Event -Pattern after-tear -Session s1 -Category failure -Severity high -Summary 'written after a torn line'
    $q=@(& $co -Root $t)-join' '
    Assert-That 'a torn line is skipped and counted; the record after it survives' ($q-match'journal: 1 unreadable line\(s\) skipped'-and(Get-State after-tear)-eq'UNOWNED')
    & $co -Root $t -Check|Out-Null
    Assert-That 'required check cannot succeed over partial journal evidence' ($LASTEXITCODE-eq2)
    & $co -Root $t -Brief|Out-Null
    Assert-That 'brief retains its incomplete-evidence exit' ($LASTEXITCODE-eq2)
    $journal=Join-Path $t 'events\events.jsonl';$before=(Get-FileHash $journal).Hash
    $refused=0
    foreach($kind in 'assign','close','dispatch'){
        try{switch($kind){
            assign {& $co -Root $t -Assign after-tear -Owner agent -Action x|Out-Null}
            close {& $co -Root $t -Close after-tear -Status resolved -Reason x|Out-Null}
            dispatch {& $co -Root $t -Dispatch after-tear -Question x|Out-Null}
        }}catch{if("$_"-match'COORDINATOR_UNREADABLE'){$refused++}}
    }
    Assert-That 'all three mutation doors refuse incomplete evidence before appending or dispatching' ($refused-eq3-and(Get-FileHash $journal).Hash-eq$before)
    $empty=Join-Path $t 'empty';New-Item -ItemType Directory "$empty\events" -Force|Out-Null
    [IO.File]::WriteAllText("$empty\events\events.jsonl",'')
    & $co -Root $empty -Check|Out-Null
    Assert-That 'an explicit empty valid journal is a successful empty case' ($LASTEXITCODE-eq0)
    & $co -Root (Join-Path $t 'absent') -Check|Out-Null
    Assert-That 'absent required journal is UNREADABLE, never an empty success' ($LASTEXITCODE-eq2)
    [IO.File]::WriteAllText("$empty\events\events.jsonl",'{"pattern":"bad-date","at":"not-a-date","status":"open","summary":"synthetic"}')
    $dateOut=@(& $co -Root $empty -Check)-join' '
    Assert-That 'invalid record dates are counted without throwing raw record data' ($LASTEXITCODE-eq2-and$dateOut-match'COORDINATOR_UNREADABLE'-and$dateOut-notmatch'not-a-date')
    $held=[IO.File]::Open("$empty\events\events.jsonl",'Open','ReadWrite','None')
    try{& $co -Root $empty -Check|Out-Null;$heldCode=$LASTEXITCODE}finally{$held.Dispose()}
    Assert-That 'unreadable journal IO cannot return success' ($heldCode-eq2)
    # Causal mutant: removing this required-check refusal changes the very observation above to success.
    $mutant=Join-Path $t 'Coordinator-mutant.ps1'
    $body=[IO.File]::ReadAllText($co);$needle='if($incomplete){exit 2}'
    if(!$body.Contains($needle)){throw 'COORDINATOR_MUTANT_ANCHOR_MISSING'}
    [IO.File]::WriteAllText($mutant,$body.Replace($needle,'if($false){exit 2}'))
    & $mutant -Root $empty -Check|Out-Null
    Assert-That 'the incomplete-evidence detector kills its success-on-corruption mutant' ($LASTEXITCODE-eq0)
    # value: work the old session-start brief (Events.ps1 -Brief, newest and most recurring first) no longer showed
    $v=Join-Path $t 'value';New-Item -ItemType Directory $v|Out-Null
    & $ev -Root $v -Add -Pattern forgotten-probe -Session old -Category observation -Summary 'delegated: does the guard miss shallow clones?' -Source delegate-road -Owner 'delegate:x' -Due '2026-10-01T00:00:00Z' -At '2026-09-30T00:00:00Z'|Out-Null
    foreach($k in 1..6){& $ev -Root $v -Add -Pattern "recent-note-$k" -Session "s$k" -Category observation -Summary "routine note $k"|Out-Null;& $ev -Root $v -Add -Pattern "recent-note-$k" -Session "t$k" -Category observation -Summary "routine note $k"|Out-Null}
    $old=@(& $ev -Root $v -Brief)-join' ';$new=@(& $co -Root $v -Brief)-join' '
    Assert-That 'a delegation whose report never came back: the old brief buried it, the coordinator escalates it' ($old-notmatch'forgotten-probe'-and$new-match'OVERDUE +forgotten-probe')
    # overhead on a journal far larger than the real one
    $big=Join-Path $t 'big';New-Item -ItemType Directory "$big\events" -Force|Out-Null
    $lines=foreach($k in 1..5000){'{{"at":"2026-10-{0:00}T10:00:00Z","session":"s{1}","source":"agent","pattern":"p-{2}","category":"observation","severity":"info","summary":"note {1}","cause":"none","status":"{3}","owner":"","due":""}}' -f (1+$k%28),$k,($k%700),$(if($k%3){'open'}else{'resolved'})}
    [IO.File]::WriteAllLines("$big\events\events.jsonl",[string[]]$lines)
    $ms=(Measure-Command{& $co -Root $big -Brief|Out-Null}).TotalMilliseconds
    Assert-That "overhead: the brief over 5,000 records takes $([int]$ms) ms (bound 15,000)" ($ms-lt15000)
    $silent=@('Hunt.ps1','Watch-Subagents.ps1','Watch-Host.ps1','Delegate.ps1','Coordinator.ps1'|Where-Object{![IO.File]::ReadAllText((Join-Path $PSScriptRoot $_)).Contains('Events.ps1')})
    Assert-That "every finder records into the one journal$(if($silent){": not $($silent-join', ')"})" (!$silent)
}finally{[IO.Directory]::Delete($t,$true)}
Assert-That 'the real journal is untouched by this check' ($realHash-eq$(if(Test-Path $real){(Get-FileHash $real).Hash}else{'none'}))
if($fail){throw "COORDINATOR_SELFCHECK_FAILED $fail"};'COORDINATOR_SELFCHECK PASS'
