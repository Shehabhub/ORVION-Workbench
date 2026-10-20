# Watchdog for background subagents (agent tooling, not repository code). A background agent whose tool call
# needs an approval waits forever: the prompt is never shown, and nothing fails (2026-10-19: three cold-start
# agents sat 52 minutes on a Grep outside the working directory). The evidence is the agent's own transcript
# (`<session>\subagents\agent-<id>.jsonl`), read from its end. It is an EVENT STREAM for the Monitor tool:
# one line per state change, nothing while nothing changes, and it ends itself.
#   NEW <id>        a transcript appeared after the watch started (or was present at start)
#   STALLED <id>    its newest entry is a tool call with no result for -StallMinutes (an unseen approval
#                   prompt, or a hung command); names the tool and its input
#   IDLE <id>       no transcript write for -IdleMinutes in any other unfinished state
#   RECOVERED <id>  a stalled or idle agent wrote again
#   FINISHED <id>   its newest entry is a final answer;  STOPPED <id>  it was interrupted or killed
#   ALL FINISHED    every watched agent finished or stopped; the watch exits 0 (or 2 if any stalled)
# -Once prints every agent's state and exits (2 when any is stalled). Read-only.
param([string]$Session,[double]$StallMinutes=3,[double]$IdleMinutes=8,[int]$PollSeconds=15,[switch]$Once,[string[]]$Only,[switch]$SinceStart)
$ErrorActionPreference='Stop'
# `pwsh -File` passes "a,b" as one string, not an array.
$Only=@($Only|ForEach-Object{$_-split','}|ForEach-Object{$_.Trim()}|Where-Object{$_})
$proj=Join-Path $env:USERPROFILE '.claude\projects'
if(!$Session){$Session=(Get-ChildItem $proj -Recurse -Directory -Filter subagents|Sort-Object LastWriteTime -Descending|Select-Object -First 1).Parent.FullName}
elseif(!(Test-Path -LiteralPath $Session)){$Session=(Get-ChildItem $proj -Recurse -Directory -Filter $Session|Select-Object -First 1).FullName}
if(!$Session){throw 'NO_SESSION'}
$dir=Join-Path $Session 'subagents'
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
    $last=Get-LastEntry $Transcript.FullName;if(!$last){return $null};$e=$last.Entry
    $c=@($e.message.content);$tool=@($c|Where-Object{$_.type-eq'tool_use'})|Select-Object -Last 1
    $text=(@($c|Where-Object{$_.type-eq'text'}|ForEach-Object{$_.text})-join' ')
    # FINISHED only on stop_reason end_turn: a text block is written as its own line before the tool call that follows it,
    # with stop_reason null, for up to 22 s (measured 2026-10-20 on real agents); calling that "finished" ended the watch.
    # STOPPED only on the harness's own interruption markers, never on a tool result that merely says "was stopped".
    # (measured: a user entry whose text block starts "[Request interrupted by user" or a tool result that starts with the denial)
    $blocks=@(if($e.message.content-is[string]){$e.message.content}else{$c|ForEach-Object{if($_.text){$_.text}elseif($_.content-is[string]){$_.content}}})
    $interrupted=[bool]@($blocks|Where-Object{"$_".StartsWith('[Request interrupted')-or"$_".StartsWith('The user doesn''t want to proceed with this tool use')}).Count
    $state=if($last.InFlight){'WORKING'}elseif($e.type-eq'assistant'-and$tool){'TOOL'}elseif($e.type-eq'assistant'-and$e.message.stop_reason-eq'end_turn'){'FINISHED'}elseif($e.type-eq'user'-and$interrupted){'STOPPED'}else{'WORKING'}
    $what=if($tool){$j=($tool.input|ConvertTo-Json -Compress -Depth 4)-replace'\s+',' ';"$($tool.name) $($j.Substring(0,[Math]::Min(160,$j.Length)))"}else{''}
    $quiet=((Get-Date)-$Transcript.LastWriteTime).TotalMinutes
    [pscustomobject]@{Id=$Transcript.BaseName-replace'^agent-','';State=$state;Quiet=[Math]::Round($quiet,1);What=$what}
}
$last=@{};$alarm=@{};$anyStall=$false
while($true){
    $files=@(if(Test-Path -LiteralPath $dir){Get-ChildItem -LiteralPath $dir -Filter 'agent-*.jsonl'})
    if($SinceStart){$files=@($files|Where-Object{$_.CreationTime-ge$started.AddSeconds(-5)})}
    $watched=@()
    foreach($f in $files){
        $s=Get-AgentState $f;if(!$s){continue}
        if($Only.Count-and$s.Id-notin$Only){continue}
        $watched+=$s
        if($Once){"{0} {1} quiet {2} min {3}" -f $s.Id,$s.State,$s.Quiet,$s.What;continue}
        if(!$last.ContainsKey($s.Id)){"NEW $($s.Id) ($($s.State))"}
        $kind=if($s.State-eq'TOOL'-and$s.Quiet-ge$StallMinutes){'STALLED'}elseif($s.State-in'WORKING','TOOL'-and$s.Quiet-ge$IdleMinutes){'IDLE'}else{$null}
        if($kind-and$alarm[$s.Id]-ne$kind){
            if($kind-eq'STALLED'){$anyStall=$true;"STALLED $($s.Id): waiting $($s.Quiet) min on $($s.What) - stop it and fix the cause (permission scope or a hung command)"
                try{$null=& (Join-Path $PSScriptRoot 'Events.ps1') -Add -Pattern agent-stall-unseen-approval -Source watchdog -Category failure -Severity high -Session (Split-Path $Session -Leaf) -Summary "agent $($s.Id) waited $StallMinutes+ min on $($s.What)" -Tags 'background subagent agent stuck hang waiting permission prompt'}catch{$null=$_}}  # improvement memory, never at the cost of the watch
            else{"IDLE $($s.Id): no transcript write for $($s.Quiet) min ($($s.State))"}
            $alarm[$s.Id]=$kind
        }elseif(!$kind-and$alarm[$s.Id]-and$s.State-notin'FINISHED','STOPPED'){"RECOVERED $($s.Id) ($($s.State))";$alarm.Remove($s.Id)}
        if($s.State-in'FINISHED','STOPPED'-and$last[$s.Id]-ne$s.State){"$($s.State) $($s.Id)";$alarm.Remove($s.Id)}
        $last[$s.Id]=$s.State
    }
    if($Once){exit $(if(@($watched|Where-Object{$_.State-eq'TOOL'-and$_.Quiet-ge$StallMinutes}).Count){2}else{0})}
    $open=@($watched|Where-Object{$_.State-notin'FINISHED','STOPPED'})
    $expected=if($Only.Count){$Only.Count}else{1}
    if($watched.Count-ge$expected-and!$open.Count){"ALL FINISHED: $($watched.Count) agent(s)";exit $(if($anyStall){2}else{0})}
    Start-Sleep -Seconds $PollSeconds
}
