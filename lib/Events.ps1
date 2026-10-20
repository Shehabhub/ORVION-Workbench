# ORVION improvement memory: one append-only line per meaningful event in <root>\events\events.jsonl.
#   -Add      record an event (watchers call this at their alarm boundaries; agents at a failure, discovery, decision, session end)
#   -Find <t> the few patterns relevant to a task description (run before starting a task)
#   -Brief    open or recurring patterns, at most -Top lines (the SessionStart hook prints this)
# Not authority: a confirmed lesson graduates to its repository home (or Claude memory) through the normal lifecycle;
# this file only says what happened, how often, and where the raw evidence is (sessions\raw via session id + time).
[CmdletBinding(DefaultParameterSetName='brief')]
param(
    [Parameter(ParameterSetName='add',Mandatory)][switch]$Add,
    [Parameter(ParameterSetName='add',Mandatory)][ValidatePattern('^[a-z0-9]+(-[a-z0-9]+)*$')][string]$Pattern,
    [Parameter(ParameterSetName='add',Mandatory)][string]$Summary,
    [Parameter(ParameterSetName='add')][ValidateSet('failure','discovery','decision','proposal','success','observation')][string]$Category='observation',
    [Parameter(ParameterSetName='add')][ValidateSet('confirmed','hypothesis','owner-decision','none')][string]$Cause='hypothesis',
    [Parameter(ParameterSetName='add')][ValidateSet('open','resolved','disproven','deferred','superseded')][string]$Status='open',
    [Parameter(ParameterSetName='add')][ValidateSet('info','warn','high')][string]$Severity='info',
    [Parameter(ParameterSetName='add')][string]$Tool='',
    [Parameter(ParameterSetName='add')][string]$Action='',
    [Parameter(ParameterSetName='add')][string]$Evidence='',
    [Parameter(ParameterSetName='add')][string]$Trigger='',
    [Parameter(ParameterSetName='add')][string]$Tags='',  # words a future task would use (pid process param), for -Find
    [Parameter(ParameterSetName='add')][string]$Repo='',
    [Parameter(ParameterSetName='add')][string]$Sha='',
    [Parameter(ParameterSetName='add')][string]$Source='agent',
    [Parameter(ParameterSetName='add')][string]$Owner='',  # who answers for it next: agent | owner | delegate:<folder> | cr:<subject> (Coordinator.ps1)
    [Parameter(ParameterSetName='add')][ValidatePattern('^$|^\d{4}-\d\d-\d\d')][string]$Due='',
    [Parameter(ParameterSetName='add')][string]$Session=$env:CLAUDE_CODE_SESSION_ID,
    [Parameter(ParameterSetName='add')][datetime]$At=[DateTime]::UtcNow,  # only a backfill passes this
    [Parameter(ParameterSetName='find',Mandatory)][string]$Find,
    [Parameter(ParameterSetName='brief')][switch]$Brief,
    [int]$Top=5,
    [string]$Root=(Split-Path $PSScriptRoot -Parent)
)
$ErrorActionPreference='Stop'
$log=Join-Path $Root 'events\events.jsonl'
# A torn or hand-damaged line is skipped (and counted for Hunt.ps1), never allowed to silence every reader.
function Read-Events{if(Test-Path $log){foreach($l in [IO.File]::ReadAllLines($log)){if($l){try{$o=$l|ConvertFrom-Json;if($o.pattern-and$o.at){$o}else{$script:badLines++}}catch{$script:badLines++}}}}}
$script:badLines=0

if($Add){
    # Watchers, hunters and agents append at the same moment: one writer at a time, or a line is lost (12 parallel
    # writers kept 11 lines, measured 2026-10-20). The duplicate check runs inside the same lock.
    New-Item -ItemType Directory -Path (Split-Path $log -Parent) -Force|Out-Null
    # named by a stable hash of the log's folder (String.GetHashCode differs in every process, so it cannot name a lock)
    $key=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes((Get-Item (Split-Path $log -Parent)).FullName.ToLowerInvariant()))).Substring(0,16)
    $lock=[Threading.Mutex]::new($false,"Local\orvion-events-$key")
    $owned=try{$lock.WaitOne(30000)}catch [Threading.AbandonedMutexException]{$true}
    if(!$owned){throw "EVENTS_LOCK_TIMEOUT: another writer held $log for 30 s"}
    try{
        # an assignment repeats the summary with a new owner, action, due or status: that is a new fact
        $last=@(Read-Events|Where-Object{$_.pattern-eq$Pattern-and$_.session-eq$Session-and$_.summary-eq$Summary-and$_.status-eq$Status-and"$($_.owner)"-eq$Owner-and"$($_.action)"-eq$Action-and"$($_.due)"-eq$Due})
        if($last.Count){"EVENT DUPLICATE $Pattern (already recorded for this session)";exit 0}  # watchers repeat; one line per fact
        $e=[ordered]@{at=$At.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ');session="$Session";source=$Source;repo=$Repo;sha=$Sha
            pattern=$Pattern;category=$Category;severity=$Severity;summary=$Summary;cause=$Cause;status=$Status
            tool=$Tool;action=$Action;evidence=$Evidence;trigger=$Trigger;tags=$Tags;owner=$Owner;due=$Due}
        # a torn last line (a writer killed mid-line) is closed first, or this record would join it and be lost with it
        $lead='';if((Test-Path $log)-and(Get-Item $log).Length){$fs=[IO.File]::OpenRead($log);try{$null=$fs.Seek(-1,'End');if($fs.ReadByte()-ne10){$lead="`n"}}finally{$fs.Dispose()}}
        [IO.File]::AppendAllText($log,$lead+($e|ConvertTo-Json -Compress)+"`n")
        $n=@(Read-Events|Where-Object pattern -eq $Pattern|ForEach-Object session|Select-Object -Unique).Count
    }finally{$lock.ReleaseMutex()}
    "EVENT RECORDED $Pattern ($n session(s))";exit 0
}

# One view per pattern: the latest record decides status and advice; recurrence = distinct sessions.
$views=foreach($g in @(Read-Events|Group-Object pattern)){
    $r=@($g.Group|Sort-Object at);$z=$r[-1]
    [pscustomobject]@{pattern=$g.Name;category=$z.category;status=$z.status;sessions=@($r.session|Select-Object -Unique).Count;last=([datetime]$z.at).ToUniversalTime().ToString('yyyy-MM-dd')
        summary=$z.summary;sessionList=@($r.session);tool=@($r.tool|Where-Object{$_})[-1];action=@($r.action|Where-Object{$_})[-1];evidence=@($r.evidence|Where-Object{$_})[-1];owner=@($r.owner|Where-Object{$_})[-1]
        tagWords=@([regex]::Matches((($r|ForEach-Object{"$($_.pattern-replace'-',' ') $($_.tags)"})-join' ').ToLower(),'[a-z0-9$_]{2,}')|ForEach-Object Value|Select-Object -Unique)
        words=@([regex]::Matches((($r|ForEach-Object{"$($_.pattern-replace'-',' ') $($_.summary) $($_.tool) $($_.action) $($_.tags)"})-join' ').ToLower(),'[a-z0-9$_]{2,}')|ForEach-Object Value|Select-Object -Unique)}
}
function Test-WordMatch([string]$Term,[string[]]$Vocabulary){  # 2 exact, 1 a shared stem of 4+ letters (exit/exits, watch/watcher), 0 none
    if($Vocabulary-contains$Term){return 2}
    foreach($w in $Vocabulary){if($Term.Length-ge4-and$w.Length-ge4-and($w.StartsWith($Term)-or$Term.StartsWith($w))){return 1}};0
}
function Format-View($v,[switch]$WithSession){
    $use=@(if($v.tool){"use $($v.tool)"};if($v.action){$v.action})-join'; '
    $line="[$($v.status) x$($v.sessions) $($v.last)$(if($v.owner){" owner $($v.owner)"})] $($v.pattern): $($v.summary)$(if($use){" -> $use"})$(if($v.evidence){" (evidence: $($v.evidence))"})"
    # the newest occurrence whose transcript is archived (an older one may predate the archive)
    $s=if($WithSession){@($v.sessionList|ForEach-Object{$script:sessionIndex[$_]}|Where-Object{$_})[-1]}
    if($s){$when=try{([datetime]$s.start).ToUniversalTime().ToString('yyyy-MM-dd')}catch{'?'}  # an index row may lack a start
        $line+="`n    raw record: session $($s.id.Substring(0,[Math]::Min(8,$s.id.Length))) $when `"$($s.title)`" -> $(Join-Path $Root $s.raw)"}
    $line
}
# The session index links an event to its full raw transcript (written by Sync-Sessions.ps1).
$sessionIndex=@{};$ix=Join-Path $Root 'sessions\index.jsonl'
if($Find-and(Test-Path $ix)){foreach($l in [IO.File]::ReadAllLines($ix)){if($l){try{$o=$l|ConvertFrom-Json;$sessionIndex[$o.id]=$o}catch{$script:badLines++}}}}
if($Find){
    $stop='the','and','for','with','that','this','from','into','then','run','use','new','all','any','our','its','are','was','not','but','when',  # 2-letter words count (id, ui, db), common ones do not
        'is','it','to','of','in','on','an','at','by','or','as','be','do','if','me','my','we','so','up','no','us','am','he','go'
    $words=@([regex]::Matches($Find.ToLower(),'[a-z0-9$_]{2,}')|ForEach-Object Value|Where-Object{$_-notin$stop}|Select-Object -Unique)
    # Rare words decide (idf): "script" matches everything, "pid" or "stall" matches what the task is about.
    $n=@($views).Count;$idf=@{};foreach($q in $words){$df=@($views|Where-Object{Test-WordMatch $q $_.words}).Count;if($df){$idf[$q]=[math]::Log(($n+1)/$df)}}
    # A word in the curated tags or pattern id (the event's index terms) outweighs one met in prose; exact beats stem.
    $hits=foreach($v in $views){$s=0.0;foreach($q in $idf.Keys){$s+=$idf[$q]*(2*(Test-WordMatch $q $v.tagWords)+(Test-WordMatch $q $v.words))/6};if($s){[pscustomobject]@{v=$v;s=$s}}}
    $hits=@($hits|Sort-Object @{e='s';Descending=$true},@{e={$_.v.sessions};Descending=$true})
    if($hits.Count){$best=$hits[0].s;$hits=@($hits|Where-Object{$_.s-ge0.4*$best}|Select-Object -First $Top)}
    if(!$hits.Count){"EVENTS: nothing recorded matches this task.";exit 0}
    "EVENTS relevant to this task ($($hits.Count) of $(@($views).Count) patterns):";$hits|ForEach-Object{Format-View $_.v -WithSession};exit 0
}
# owner decisions are Pulse's "waiting" list, so the brief leaves them out
$live=@($views|Where-Object{$_.category-ne'decision'}|Where-Object{$_.status-in'open','deferred'-or$_.sessions-ge2}|Sort-Object @{e={$_.status-in'open','deferred'};Descending=$true},@{e='sessions';Descending=$true},@{e='last';Descending=$true}|Select-Object -First $Top)
if($live.Count){"EVENTS open or recurring (top $($live.Count) of $(@($views).Count); for a task run Events.ps1 -Find '<task>'):";$live|ForEach-Object{Format-View $_}}
