# Claude Code hook (machine-local agent tooling): makes sure every agent knows and uses the ORVION watchers.
#   SessionStart          -> prints the tool index (ORVION-Sandbox\lib\README.md, "Always" section)
#   PostToolUse Agent     -> a background agent was launched: the exact Watch-Subagents command for this session
#   PostToolUse PowerShell|Bash running scripts/run_timed.ps1 -> the exact watch_run and Watch-Host commands
# Reads the hook event from stdin; only ever adds context, never blocks, and exits 0 on any error.
$ErrorActionPreference='Stop'
try{
    $lib=Split-Path $PSScriptRoot -Parent
    $raw=[Console]::In.ReadToEnd();$e=if($raw.Trim()){$raw|ConvertFrom-Json}else{$null}
    $hookEvent=if($e){$e.hook_event_name}else{'SessionStart'}
    # Scoped to the ORVION workspace: silent in every unrelated project.
    $cwd=if($e.cwd){"$($e.cwd)"}else{(Get-Location).Path}
    if($cwd-notlike"$env:USERPROFILE\Documents\GitHub\*"-and$cwd-notlike"$env:USERPROFILE\Documents\ORVION-*"){exit 0}
    function Send-Context([string]$Text){
        if($hookEvent-eq'SessionStart'){$Text;return}
        @{hookSpecificOutput=@{hookEventName=$hookEvent;additionalContext=$Text}}|ConvertTo-Json -Compress -Depth 4
    }
    if($hookEvent-in'SessionStart','SessionEnd'){
        # Archive every session verbatim (Claude Code deletes transcripts after 30 days), continuously: start a follower
        # (a pass a minute while any Claude Code or Codex process runs; a second one exits at once). Detached, so the hook stays fast.
        $mode=if($hookEvent-eq'SessionStart'){'-Follow -Quiet'}else{'-Quiet'}
        Start-Process pwsh -ArgumentList "-NoProfile -File `"$lib\Sync-Sessions.ps1`" $mode" -WindowStyle Hidden
        if($hookEvent-eq'SessionEnd'){exit 0}
        $md=[IO.File]::ReadAllText((Join-Path $lib 'README.md'))
        $always=[regex]::Match($md,'(?s)## Always.*?(?=\n## )').Value
        $events=((& (Join-Path $lib 'Pulse.ps1'))+''+(& (Join-Path $lib 'Events.ps1') -Brief))-join"`n"  # the live state first, then the open lessons
        Send-Context ("ORVION AGENT TOOLS exist at $lib (index: README.md). Use them; never hand-write an alarm loop.`n"+$always.Replace('<lib>',$lib)+"`n"+$events+"`nBefore a task: pwsh -NoProfile -File `"$lib\Events.ps1`" -Find '<task in a few words>'. Record a failure, discovery or decision worth keeping with Events.ps1 -Add. Past sessions (task, size, tools, errors, SPECs, raw path): $(Split-Path $lib -Parent)\sessions\INDEX.md.")
        exit 0
    }
    $in=$e.tool_input
    # The hook input carries no run_in_background flag; the launch response does: isAsync, agentId (measured 2026-10-19).
    $r=$e.tool_response
    if($hookEvent-eq'PostToolUse'-and$e.tool_name-in'Agent','Task'-and($in.run_in_background-or$r.isAsync-or$r.status-eq'async_launched')){
        $only=if($r.agentId){" -Only $($r.agentId)"}else{' -SinceStart'}
        Send-Context ("WATCHDOG REQUIRED: you launched a background agent. Start the Monitor tool now (timeout_ms 1800000, re-arm on expiry) with: pwsh -NoProfile -File `"$lib\Watch-Subagents.ps1`" -Session $($e.session_id)$only. On STALLED stop the agent and fix the cause (a tool call outside the working directories waits on an unseen approval). Read-only agents should use Read/Grep/Glob, not shell.")
        exit 0
    }
    if($e.tool_name-in'PowerShell','Bash'-and"$($in.command)"-match'run_timed\.ps1'){
        $c="$($in.command)"
        $log=[regex]::Match($c,'-Log\s+(?:"([^"]+)"|''([^'']+)''|(\S+))');$log=@($log.Groups[1].Value,$log.Groups[2].Value,$log.Groups[3].Value)|Where-Object{$_}|Select-Object -First 1
        if(!$log-or$c-notmatch'run_timed\.ps1["'']?\s'){exit 0}  # a mention, not a run
        $rt=[regex]::Match($c,'(?:"([^"]*run_timed\.ps1)"|(\S*run_timed\.ps1))');$rt=@($rt.Groups[1].Value,$rt.Groups[2].Value)|Where-Object{$_}|Select-Object -First 1
        $watch=if($rt-and[IO.Path]::IsPathRooted($rt)){Join-Path (Split-Path $rt -Parent) 'watch_run.ps1'}else{Join-Path $e.cwd 'scripts\watch_run.ps1'}
        $run=if($c-match'-Finish'){'finish-control'}elseif($c-match'test_agent_continuity'){'control-suite'}else{'timed-run'}
        $bg=if($in.run_in_background){''}else{' run_timed blocks in the foreground, so a watcher cannot follow it live: start it with run_in_background next time.'}
        Send-Context ("WATCHER REQUIRED: you started a timed run. Start the Monitor tool now (timeout_ms 1800000, re-arm on expiry) with: pwsh -NoProfile -File `"$watch`" -Log `"$log`" -Run $run -Brief. For a heavy run, or two at once, also Monitor: pwsh -NoProfile -File `"$lib\Watch-Host.ps1`" -WatchPid <runner pid from the watcher's first line> -ExitWhenPidsGone.$bg")
        exit 0
    }
}catch{}
exit 0
