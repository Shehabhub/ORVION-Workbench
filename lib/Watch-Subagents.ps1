# Watchdog for background subagents (agent tooling, not repository code). A background agent whose tool call
# needs an approval waits forever: the prompt is never shown, and nothing fails (2026-10-19: three cold-start
# agents sat 52 minutes on a Grep outside the working directory). The evidence is the agent's own transcript
# (`<session>\subagents\agent-<id>.jsonl`), read from its end. It is an EVENT STREAM for the Monitor tool:
# one line per state change, nothing while nothing changes, and it ends itself.
#   NEW <id>        a transcript appeared after the watch started (or was present at start)
#   STALLED <id>    its newest entry is a tool call with no result for -StallMinutes; cause UNPROVEN
#   IDLE <id>       no transcript write for -IdleMinutes in any other unfinished state
#   RECOVERED <id>  a stalled or idle agent wrote again
#   FINISHED <id>   its newest entry is a final answer;  STOPPED <id>  it was interrupted or killed
#   ALL FINISHED    every watched agent finished or stopped; the watch exits 0 (or 2 if any stalled)
# Explicit Claude transcript session only. Never guesses the latest session or another client's format.
# -Once prints selected states and exits 2 on a stall or incomplete evidence. Reads transcripts; alarms append Events.
param([string]$Session,[ValidateRange(0.001,10080)][double]$StallMinutes=3,[ValidateRange(0.001,10080)][double]$IdleMinutes=8,
      [ValidateRange(1,3600)][int]$PollSeconds=15,[switch]$Once,[string[]]$Only,[switch]$SinceStart,
      [string]$EventRoot=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools')|Where-Object{Test-Path -LiteralPath (Join-Path $_ 'events')})+@(Split-Path $PSScriptRoot -Parent))[0]}))
$ErrorActionPreference='Stop'
# `pwsh -File` passes "a,b" as one string, not an array.
$Only=@($Only|ForEach-Object{$_-split','}|ForEach-Object{$_.Trim()}|Where-Object{$_}|Sort-Object -Unique)
if(@($Only|Where-Object{$_-notmatch'^[A-Za-z0-9_-]+$'}).Count){throw 'WATCHDOG_SELECTOR_INVALID'}
if(!$Session){throw 'WATCHDOG_SESSION_REQUIRED: supply an explicit Claude session directory or exact ID'}
$proj=Join-Path $env:USERPROFILE '.claude\projects'
if(![IO.Path]::IsPathFullyQualified($Session)){
    if($Session-notmatch'^[A-Za-z0-9_-]+$'){throw 'WATCHDOG_SESSION_INVALID'}
    $sessionMatches=@(if(Test-Path -LiteralPath $proj){Get-ChildItem -LiteralPath $proj -Directory|ForEach-Object{Get-ChildItem -LiteralPath $_.FullName -Directory -Filter $Session}|Where-Object Name -eq $Session})
    if($sessionMatches.Count-ne1){throw 'WATCHDOG_SESSION_UNRESOLVED: exact session ID must resolve once'}
    $Session=$sessionMatches[0].FullName
}
if(!(Test-Path -LiteralPath $Session -PathType Container)){throw 'WATCHDOG_SESSION_UNRESOLVED'}
$Session=[IO.Path]::GetFullPath($Session)
for($ancestor=Get-Item -LiteralPath $Session;$ancestor;$ancestor=$ancestor.Parent){if($ancestor.Attributes-band[IO.FileAttributes]::ReparsePoint){throw 'WATCHDOG_SESSION_REPARSE_REFUSED'}}
$dir=Join-Path $Session 'subagents'
# Reuse the established bounded masking vocabulary, before truncating a diagnostic. Library mode never archives.
. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $EventRoot
$started=Get-Date
# The newest parseable entry, read from the end: transcripts are hundreds of KB and still being written.
function Get-LastEntry([string]$Path){
    $fs=[IO.File]::Open($Path,'Open','Read','ReadWrite')
    try{$n=[Math]::Min($fs.Length,262144);$fs.Seek(-$n,'End')|Out-Null;$buf=New-Object byte[] $n;[void]$fs.Read($buf,0,$n)}finally{$fs.Dispose()}
    $lines=@([Text.Encoding]::UTF8.GetString($buf)-split"`n"|Where-Object{$_.Trim()})  # @(): one line must stay a list, not a string to index
    # Bookkeeping entries (attachment, api-request, ...) follow the final answer; judge by the newest
    # conversation entry. A trailing api-request means a model call is in flight: the agent is working.
    $inFlight=$false
    for($i=$lines.Count-1;$i-ge0;$i--){
        try{$j=$lines[$i]|ConvertFrom-Json}catch{continue}
        if($j.type-in'assistant','user'){return [pscustomobject]@{Entry=$j;InFlight=$inFlight}}
        if($j.type-eq'api-request'){$inFlight=$true}
    };$null
}
function Get-AgentState([IO.FileInfo]$Transcript){
    if($Transcript.Attributes-band[IO.FileAttributes]::ReparsePoint){$last=$null}else{try{$last=Get-LastEntry $Transcript.FullName}catch{$last=$null}}
    if(!$last-or!$last.Entry.message-or$null-eq$last.Entry.message.content){return [pscustomobject]@{Id=$Transcript.BaseName-replace'^agent-','';State='UNREADABLE';Quiet=0;What='WATCHDOG_TRANSCRIPT_UNREADABLE'}};$e=$last.Entry
    $c=@($e.message.content);$tool=@($c|Where-Object{$_.type-eq'tool_use'})|Select-Object -Last 1
    # FINISHED only on stop_reason end_turn: a text block is written as its own line before the tool call that follows it,
    # with stop_reason null, for up to 22 s (measured 2026-10-20 on real agents); calling that "finished" ended the watch.
    # STOPPED only on the harness's own interruption markers, never on a tool result that merely says "was stopped".
    # (measured: a user entry whose text block starts "[Request interrupted by user" or a tool result that starts with the denial)
    $blocks=@(if($e.message.content-is[string]){$e.message.content}else{$c|ForEach-Object{if($_.text){$_.text}elseif($_.content-is[string]){$_.content}}})
    $interrupted=[bool]@($blocks|Where-Object{"$_".StartsWith('[Request interrupted')-or"$_".StartsWith('The user doesn''t want to proceed with this tool use')}).Count
    $state=if($last.InFlight){'WORKING'}elseif($e.type-eq'assistant'-and$tool){'TOOL'}elseif($e.type-eq'assistant'-and$e.message.stop_reason-eq'end_turn'){'FINISHED'}elseif($e.type-eq'user'-and$interrupted){'STOPPED'}else{'WORKING'}
    $what=if($tool){$j=Hide-Secret ("$($tool.name) "+($tool.input|ConvertTo-Json -Compress -Depth 20));$j=$j-replace'\s+',' ';$j.Substring(0,[Math]::Min(160,$j.Length))}else{''}
    $quiet=((Get-Date)-$Transcript.LastWriteTime).TotalMinutes
    [pscustomobject]@{Id=$Transcript.BaseName-replace'^agent-','';State=$state;Quiet=[Math]::Round($quiet,1);What=$what}
}
$last=@{};$alarm=@{};$anyStall=$false;$anyUnreadable=$false
while($true){
    $scanFault=$false
    try{
        if((Test-Path -LiteralPath $dir)-and((Get-Item -LiteralPath $dir).Attributes-band[IO.FileAttributes]::ReparsePoint)){throw 'reparse'}
        $files=@(if(Test-Path -LiteralPath $dir){Get-ChildItem -LiteralPath $dir -File -Filter 'agent-*.jsonl'})
    }catch{$scanFault=$true;$files=@()}
    if($SinceStart){$files=@($files|Where-Object{$_.CreationTime-ge$started.AddSeconds(-5)})}
    $watched=@(foreach($f in $files){
        $id=$f.BaseName-replace'^agent-',''
        if($Only.Count-and$id-notin$Only){continue}
        Get-AgentState $f
    })
    $missing=@($Only|Where-Object{$_-notin$watched.Id})
    if($Once-or((Get-Date)-$started).TotalMinutes-ge$StallMinutes){
        foreach($id in $missing){$watched+=[pscustomobject]@{Id=$id;State='UNREADABLE';Quiet=0;What='WATCHDOG_SELECTED_TRANSCRIPT_MISSING'}}
        if(!$watched.Count-or$scanFault){$watched+=[pscustomobject]@{Id='session';State='UNREADABLE';Quiet=0;What='WATCHDOG_SESSION_EVIDENCE_UNREADABLE'}}
    }
    foreach($s in $watched){
        if($Once){"{0} {1} quiet {2} min {3}" -f $s.Id,$s.State,$s.Quiet,$s.What;continue}
        if(!$last.ContainsKey($s.Id)){"NEW $($s.Id) ($($s.State))"}
        $kind=if($s.State-eq'UNREADABLE'){'UNREADABLE'}elseif($s.State-eq'TOOL'-and$s.Quiet-ge$StallMinutes){'STALLED'}elseif($s.State-in'WORKING','TOOL'-and$s.Quiet-ge$IdleMinutes){'IDLE'}else{$null}
        if($kind-and$alarm[$s.Id]-ne$kind){
            if($kind-eq'STALLED'){$anyStall=$true;"STALLED $($s.Id): waiting $($s.Quiet) min on $($s.What); cause UNPROVEN. Investigate the owned run before any intervention."
                try{$null=& (Join-Path $PSScriptRoot 'Events.ps1') -Root $EventRoot -Add -Pattern agent-tool-wait-cause-unproven -Source watchdog -Category failure -Severity high -Cause hypothesis -Session (Split-Path $Session -Leaf) -Summary "agent $($s.Id) waited $StallMinutes+ min on $($s.What); cause UNPROVEN" -Tags 'background subagent tool wait stall liveness'}catch{$anyUnreadable=$true;'WATCHDOG_JOURNAL_UNREADABLE: alarm evidence was not recorded'}}
            elseif($kind-eq'UNREADABLE'){$anyUnreadable=$true;"UNREADABLE $($s.Id): $($s.What)"}
            else{"IDLE $($s.Id): no transcript write for $($s.Quiet) min ($($s.State))"}
            $alarm[$s.Id]=$kind
        }elseif(!$kind-and$alarm[$s.Id]-and$s.State-notin'FINISHED','STOPPED'){"RECOVERED $($s.Id) ($($s.State))";$alarm.Remove($s.Id)}
        if($s.State-in'FINISHED','STOPPED'-and$last[$s.Id]-ne$s.State){"$($s.State) $($s.Id)";$alarm.Remove($s.Id)}
        $last[$s.Id]=$s.State
    }
    if($Once){exit $(if(@($watched|Where-Object{$_.State-eq'UNREADABLE'-or($_.State-eq'TOOL'-and$_.Quiet-ge$StallMinutes)}).Count){2}else{0})}
    $open=@($watched|Where-Object{$_.State-notin'FINISHED','STOPPED'})
    $expected=if($Only.Count){$Only.Count}else{1}
    if($watched.Count-ge$expected-and!$open.Count){"ALL FINISHED: $($watched.Count) agent(s)";exit $(if($anyStall-or$anyUnreadable){2}else{0})}
    Start-Sleep -Seconds $PollSeconds
}
