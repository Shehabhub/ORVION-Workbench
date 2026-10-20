# ORVION coordinator: a dispatcher and continuity aid over the one event journal (events\events.jsonl). It hunts nothing,
# approves nothing, certifies nothing and governs nothing: repository authority stays with each repository's own Boot,
# contracts, Gate 1 and -Certify. Spider, Hunt, the watchers and agents RECORD (Events.ps1 -Add); this reads.
#
# Most records are observations: they stay in the journal, found again by Events.ps1 -Find, and ask nothing of anyone.
# An open item becomes a CASE only when it is material: someone took it (owner), it carries an explicit due time, it is
# an owner decision, a delegation, severity high, or it came back after it was resolved (the fix did not hold).
#   OWNER      a genuine owner decision
#   UNOWNED    material (high, or recurred after a resolution) and nobody has taken it          -> escalated
#   OVERDUE    past its explicit due time; a delegation whose report never came back           -> escalated
#   DISPATCHED a delegate is working on it, within its time budget
#   ACTIVE     owned, with a next action
# Only UNOWNED and OVERDUE are escalated (Pulse at session start, -Check exit 1); nothing is due by default.
#   Coordinator.ps1 [-Check] | -Brief   (the brief also names the two most recently updated in-flight cases: where to resume)
#   Coordinator.ps1 -Assign <pattern> -Owner <agent|owner|cr:subject> -Action '<next step>' [-Due yyyy-MM-dd]
#   Coordinator.ps1 -Close <pattern> -Status resolved|disproven|deferred|superseded -Reason '<why>' [-Due, for deferred]
#   Coordinator.ps1 -Dispatch <pattern> -Question '<prove or disprove>' [-Mode sandbox] [-Minutes 30]   (Delegate.ps1)
# Taking or dispatching work first prints prior resolutions of related events, so solved problems are not solved twice.
[CmdletBinding(DefaultParameterSetName='queue')]
param([Parameter(ParameterSetName='queue')][switch]$Check,
      [Parameter(ParameterSetName='brief',Mandatory)][switch]$Brief,
      [Parameter(ParameterSetName='assign',Mandatory)][string]$Assign,
      [Parameter(ParameterSetName='assign',Mandatory)][string]$Owner,
      [Parameter(ParameterSetName='assign',Mandatory)][string]$Action,
      [Parameter(ParameterSetName='close',Mandatory)][string]$Close,
      [Parameter(ParameterSetName='close',Mandatory)][ValidateSet('resolved','disproven','deferred','superseded')][string]$Status,
      [Parameter(ParameterSetName='close',Mandatory)][string]$Reason,
      [Parameter(ParameterSetName='assign')][Parameter(ParameterSetName='close')][string]$Due='',
      [Parameter(ParameterSetName='dispatch',Mandatory)][string]$Dispatch,
      [Parameter(ParameterSetName='dispatch',Mandatory)][string]$Question,
      [Parameter(ParameterSetName='dispatch')][ValidateSet('readonly','sandbox')][string]$Mode='readonly',
      [Parameter(ParameterSetName='dispatch')][int]$Minutes=30,
      [datetime]$Now=[DateTime]::UtcNow,  # the self-check moves the clock
      [string]$Root=(Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference='Stop'
$ev=Join-Path $PSScriptRoot 'Events.ps1';$log=Join-Path $Root 'events\events.jsonl'
# The journal is the only state: every view is computed from it at read time, so there is no index to drift or rebuild.
$bad=0;$records=@(if(Test-Path $log){foreach($l in [IO.File]::ReadAllLines($log)){if($l){try{$o=ConvertFrom-Json $l -DateKind String;if($o.pattern-and$o.at){$o}else{$bad++}}catch{$bad++}}}})
# Times stay strings until here (ConvertFrom-Json would guess a kind); a bare date is due at the end of that day.
function ConvertTo-Utc([string]$s){$d=[DateTimeOffset]::Parse($s,[Globalization.CultureInfo]::InvariantCulture).UtcDateTime;if($s.Length-eq10){$d.AddDays(1).AddSeconds(-1)}else{$d}}

$open=foreach($g in @($records|Group-Object pattern)){
    $r=@($g.Group|Sort-Object{ConvertTo-Utc $_.at});$z=$r[-1]
    if($z.status-notin'open','deferred'){continue}
    $closed=@(for($i=0;$i-lt$r.Count;$i++){if($r[$i].status-in'resolved','disproven','superseded'){$i}})
    # only the records since the last closure count: a reopened item needs someone to take it again
    $since=@($r|Select-Object -Skip $(if($closed){$closed[-1]+1}else{0}))
    if($z.status-eq'deferred'){$since=@($z)}  # a deferral is a fresh promise: its own owner, action and date
    $own=@($since.owner|Where-Object{$_})[-1];$act=@($since.action|Where-Object{$_})[-1];$dueText=@($since.due|Where-Object{$_})[-1]
    $sev=@($since.severity|Where-Object{$_})[-1];$dueAt=if($dueText){ConvertTo-Utc $dueText}else{$null}
    $last=if($closed){$r[$closed[-1]]}else{$null}
    $case=$own-or$dueText-or$z.category-eq'decision'-or$z.source-eq'delegate-road'-or$sev-eq'high'-or$last
    $state=if(!$case){'OBSERVATION'}elseif($z.category-eq'decision'-or$own-eq'owner'){'OWNER'}
        elseif($dueAt-and$Now-gt$dueAt){'OVERDUE'}elseif($z.source-eq'delegate-road'){'DISPATCHED'}
        elseif(!$own-or!$act){'UNOWNED'}else{'ACTIVE'}
    [pscustomobject]@{pattern=$g.Name;state=$state;owner=$own;action=$act;due=$dueAt;age=[int]($Now-(ConvertTo-Utc $since[0].at)).TotalDays
        summary=$z.summary;last=(ConvertTo-Utc $z.at);recurred=$closed.Count;lastFix=$(if($last){"$(([datetime](ConvertTo-Utc $last.at)).ToString('yyyy-MM-dd')) $($last.status): $($last.summary)"})}
}
$order=@{UNOWNED=0;OVERDUE=1;OWNER=2;DISPATCHED=3;ACTIVE=4}
$items=@($open|Where-Object state -ne 'OBSERVATION'|Sort-Object @{e={$order[$_.state]}},@{e='age';Descending=$true})
$observations=@($open|Where-Object state -eq 'OBSERVATION').Count
$escalated=@($items|Where-Object state -in 'UNOWNED','OVERDUE')
function Find-OpenItem([string]$Pattern){$i=@($open|Where-Object pattern -eq $Pattern);if(!$i){throw "COORDINATOR_NO_OPEN_ITEM: $Pattern is not open in $log"};$i[0]}
function Format-QueueLine($i){
    $need=switch($i.state){'UNOWNED'{"material$(if($i.recurred){', recurred after a resolution'}) and nobody has taken it: -Assign it, or -Close it with the reason"}
        'OVERDUE'{if($i.owner-like'delegate:*'){'no report came back: save the reply (Delegate.ps1 -Report) or dispatch again'}else{"past due; owner $($i.owner): $($i.action)"}}
        'OWNER'{if($i.action){"owner: $($i.action)"}else{'waiting on the owner'}}
        default{"owner $($i.owner)$(if($i.action){": $($i.action)"})"}}
    $s=$i.summary.Substring(0,[Math]::Min(110,$i.summary.Length))+$(if($i.summary.Length-gt110){'...'})
    "{0,-10} {1} (age {2} d{3}): {4} -> {5}{6}" -f $i.state,$i.pattern,$i.age,$(if($i.due){", due $($i.due.ToString('yyyy-MM-dd'))"}),$s,$need,$(if($i.lastFix){"`n           last time ($($i.recurred)x): $($i.lastFix.Substring(0,[Math]::Min(140,$i.lastFix.Length)))"})
}
function Show-PriorResolution([string]$Text,[string]$Except){  # before new work: what was already solved, and how
    $hits=@(& $ev -Root $Root -Find $Text -Top 5|Where-Object{$_-match'^\[(resolved|disproven|superseded) '-and$_-notmatch"\] $([regex]::Escape($Except)):"})
    if($hits){'PRIOR RESOLUTIONS of related events (read before acting):';$hits|ForEach-Object{"  $_"}}
}

if($Assign){
    $i=Find-OpenItem $Assign;$z=@($records|Where-Object pattern -eq $Assign|Sort-Object{ConvertTo-Utc $_.at})[-1]
    Show-PriorResolution "$($z.summary) $($z.tags)" $Assign
    & $ev -Root $Root -Add -Pattern $Assign -Source coordinator -Category $z.category -Severity $(if($z.severity){$z.severity}else{'info'}) -Cause $(if($z.cause){$z.cause}else{'hypothesis'}) -Status $z.status -Summary $z.summary -Owner $Owner -Action $Action -Due $Due -Tags "$($z.tags)"
    exit 0
}
if($Close){
    $i=Find-OpenItem $Close;if($Status-eq'deferred'-and!$Due){throw 'COORDINATOR_DEFER_NEEDS_DUE: a deferral is a promise with a date'}
    $z=@($records|Where-Object pattern -eq $Close|Sort-Object{ConvertTo-Utc $_.at})[-1]
    & $ev -Root $Root -Add -Pattern $Close -Source coordinator -Category $z.category -Cause $(if($z.cause){$z.cause}else{'hypothesis'}) -Status $Status -Summary $Reason -Owner $(if($Status-eq'deferred'){$i.owner}else{''}) -Action $(if($Status-eq'deferred'){$i.action}else{''}) -Due $Due -Tags "$($z.tags)"
    exit 0
}
if($Dispatch){$null=Find-OpenItem $Dispatch;Show-PriorResolution $Question $Dispatch;& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $Root -Pattern $Dispatch -Question $Question -Mode $Mode -Minutes $Minutes;exit 0}

$count="$(($order.Keys|Sort-Object{$order[$_]}|ForEach-Object{$k=$_;"$($k.ToLower()) $(@($items|Where-Object state -eq $k).Count)"})-join' | ') | observations $observations$(if($bad){" | journal: $bad unreadable line(s) skipped"})"
if($Brief){
    "cases    $count (Coordinator.ps1 for all)"
    foreach($i in @($escalated|Select-Object -First 3)){"         - $(Format-QueueLine $i)"}
    # what is in flight, newest first: after an interruption this is where work resumes (cold-start rehearsal, 2026-10-20)
    foreach($i in @($items|Where-Object state -in 'ACTIVE','DISPATCHED'|Sort-Object last -Descending|Select-Object -First 2)){"         in flight: $($i.pattern) ($($i.owner)): $($i.action.Substring(0,[Math]::Min(260,$i.action.Length)))"}
    exit 0
}
"COORDINATOR $($Now.ToString('yyyy-MM-dd HH:mm')) UTC: $($items.Count) case(s): $count"
foreach($i in $items){Format-QueueLine $i}
if($Check-and$escalated.Count){exit 1}
