# ORVION coordinator: the one place where every open observation has someone answering for it. It hunts nothing itself.
# Spider, the hunters (Hunt.ps1), the watchers and agents RECORD in the event journal (Events.ps1 -Add); this reads the
# journal and holds every open item to an owner, a next action and a due time, so nothing recorded is left unaddressed.
#   Coordinator.ps1            the queue, most urgent first:
#                                TRIAGE     open, but nobody owns it or there is no next action
#                                OVERDUE    past its due time (given, or by severity: high 1 day, warn 3, info 7)
#                                OWNER      waiting on the owner's decision (category decision or owner = owner)
#                                DISPATCHED a delegate is working on it (Delegate.ps1); overdue if no report came back
#                                READY      owned, with a next action, not yet due
#   Coordinator.ps1 -Brief     counts and the three most urgent items (Pulse prints this at session start)
#   Coordinator.ps1 -Check     the same queue; exit 1 when anything is TRIAGE or OVERDUE
#   Coordinator.ps1 -Assign <pattern> -Owner <agent|owner|cr:subject> -Action '<next step>' [-Due yyyy-MM-dd]
#   Coordinator.ps1 -Close <pattern> -Status resolved|disproven|deferred|superseded -Reason '<why>' [-Due for deferred]
#   Coordinator.ps1 -Dispatch <pattern> -Question '<prove or disprove>' [-Mode sandbox] [-Minutes 30]   (Delegate.ps1)
# It never closes anything by itself: an item leaves the queue only through a recorded event with its reason.
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
$records=@(if(Test-Path $log){[IO.File]::ReadAllLines($log)|Where-Object{$_}|ForEach-Object{try{ConvertFrom-Json $_ -DateKind String}catch{$null=$_}}|Where-Object{$_.pattern-and$_.at}})
# Times stay strings until here (ConvertFrom-Json would guess a kind); a bare date is due at the end of that day.
function ConvertTo-Utc([string]$s){$d=[DateTimeOffset]::Parse($s,[Globalization.CultureInfo]::InvariantCulture).UtcDateTime;if($s.Length-eq10){$d.AddDays(1).AddSeconds(-1)}else{$d}}
$sla=@{high=1;warn=3;info=7}

# One item per pattern. Only the records since it was last closed count: a reopened item needs a new owner.
$items=foreach($g in @($records|Group-Object pattern)){
    $r=@($g.Group|Sort-Object{ConvertTo-Utc $_.at});$z=$r[-1]
    if($z.status-notin'open','deferred'){continue}
    $closed=@(for($i=0;$i-lt$r.Count;$i++){if($r[$i].status-notin'open','deferred'){$i}})
    $since=@($r|Select-Object -Skip $(if($closed){$closed[-1]+1}else{0}))
    if($z.status-eq'deferred'){$since=@($z)}  # a deferral is a fresh promise: its own owner and due
    $own=@($since.owner|Where-Object{$_})[-1];$act=@($since.action|Where-Object{$_})[-1];$dueText=@($since.due|Where-Object{$_})[-1]
    $opened=ConvertTo-Utc $since[0].at;$sev=@($since.severity|Where-Object{$_})[-1]
    $dueAt=if($dueText){ConvertTo-Utc $dueText}else{$opened.AddDays($(if($sla[$sev]){$sla[$sev]}else{7}))}
    $state=if($z.category-eq'decision'-or$own-eq'owner'){'OWNER'}
        elseif($z.source-eq'delegate-road'){if($Now-gt$dueAt){'OVERDUE'}else{'DISPATCHED'}}
        elseif(!$own-or!$act){'TRIAGE'}elseif($Now-gt$dueAt){'OVERDUE'}else{'READY'}
    [pscustomobject]@{pattern=$g.Name;state=$state;owner=$own;action=$act;due=$dueAt;age=[int]($Now-$opened).TotalDays;summary=$z.summary;category=$z.category;severity=$sev}
}
$order=@{TRIAGE=0;OVERDUE=1;OWNER=2;DISPATCHED=3;READY=4}
$items=@($items|Sort-Object @{e={$order[$_.state]}},@{e='age';Descending=$true})
function Find-OpenItem([string]$Pattern){$i=@($items|Where-Object pattern -eq $Pattern);if(!$i){throw "COORDINATOR_NO_OPEN_ITEM: $Pattern is not open in $log"};$i[0]}
function Format-QueueLine($i){
    $need=if($i.state-eq'TRIAGE'){"needs $(@(if(!$i.owner){'an owner'};if(!$i.action){'a next action'})-join' and ')"}
          elseif($i.state-eq'OVERDUE'-and$i.owner-like'delegate:*'){'no report came back: save the reply (Delegate.ps1 -Report) or dispatch again'}
          elseif($i.state-eq'OWNER'-and!$i.action){'waiting on the owner'}else{"owner $(if($i.owner){$i.owner}else{'owner'})$(if($i.action){": $($i.action)"})"}
    $s=$i.summary.Substring(0,[Math]::Min(110,$i.summary.Length))+$(if($i.summary.Length-gt110){'...'})
    "{0,-10} {1} (age {2} d, due {3}): {4} -> {5}" -f $i.state,$i.pattern,$i.age,$i.due.ToString('yyyy-MM-dd'),$s,$need
}

if($Assign){
    $i=Find-OpenItem $Assign;$z=@($records|Where-Object pattern -eq $Assign|Sort-Object at)[-1]
    & $ev -Root $Root -Add -Pattern $Assign -Source coordinator -Category $z.category -Severity $(if($z.severity){$z.severity}else{'info'}) -Cause $(if($z.cause){$z.cause}else{'hypothesis'}) -Status $z.status -Summary $z.summary -Owner $Owner -Action $Action -Due $Due -Tags "$($z.tags)"
    exit 0
}
if($Close){
    $i=Find-OpenItem $Close;if($Status-eq'deferred'-and!$Due){throw 'COORDINATOR_DEFER_NEEDS_DUE: a deferral is a promise with a date'}
    $z=@($records|Where-Object pattern -eq $Close|Sort-Object at)[-1]
    & $ev -Root $Root -Add -Pattern $Close -Source coordinator -Category $z.category -Cause $(if($z.cause){$z.cause}else{'hypothesis'}) -Status $Status -Summary $Reason -Owner $(if($Status-eq'deferred'){$i.owner}else{''}) -Action $(if($Status-eq'deferred'){$i.action}else{''}) -Due $Due -Tags "$($z.tags)"
    exit 0
}
if($Dispatch){$null=Find-OpenItem $Dispatch;& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $Root -Pattern $Dispatch -Question $Question -Mode $Mode -Minutes $Minutes;exit 0}

$count=($order.Keys|Sort-Object{$order[$_]}|ForEach-Object{$k=$_;"$($k.ToLower()) $(@($items|Where-Object state -eq $k).Count)"})-join' | '
if($Brief){
    "queue    $count (Coordinator.ps1 for all; -Assign / -Close / -Dispatch to act)"
    foreach($i in @($items|Where-Object state -in 'TRIAGE','OVERDUE'|Select-Object -First 3)){"         - $(Format-QueueLine $i)"}
    exit 0
}
"COORDINATOR $($Now.ToString('yyyy-MM-dd HH:mm')) UTC: $(@($items).Count) open item(s): $count"
foreach($i in $items){Format-QueueLine $i}
if($Check-and@($items|Where-Object state -in 'TRIAGE','OVERDUE').Count){exit 1}
