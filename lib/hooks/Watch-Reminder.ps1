# Claude Code reporting adapter: Workbench context is opt-in; native product entry stays independent.
#   SessionStart          -> prints the tool index (lib\README.md, "Always" section) and Pulse
#   PostToolUse Agent     -> a background agent was launched: the exact Watch-Subagents command for this session
#   PostToolUse PowerShell|Bash running scripts/run_timed.ps1 -> the exact watch_run and Watch-Host commands
# Reads the hook event from stdin; only ever adds context, never blocks, and exits 0 on any error.
$ErrorActionPreference='Stop'
try{
    $lib=Split-Path $PSScriptRoot -Parent
    $dataRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'})
    if(!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $dataRoot 'events') -PathType Container)){throw 'ORVION_DATA_ROOT_UNAVAILABLE'}
    $dataRoot=[IO.Path]::GetFullPath($dataRoot).TrimEnd('\')
    $raw=[Console]::In.ReadToEnd();$e=if($raw.Trim()){$raw|ConvertFrom-Json}else{$null}
    if(!$e-or!$e.hook_event_name){throw 'HOOK_INPUT_INVALID'}
    $hookEvent=$e.hook_event_name
    # Scoped to the ORVION workspace: silent in every unrelated project.
    $cwd=if($e.cwd){"$($e.cwd)"}else{(Get-Location).Path}
    $workbench=Split-Path $lib -Parent
    $workbenchEntry=[IO.Path]::GetFullPath($cwd).TrimEnd('\')-eq[IO.Path]::GetFullPath($workbench).TrimEnd('\')
    $archiveScope=$workbenchEntry-or$cwd-like"$env:USERPROFILE\Documents\GitHub\*"-or$cwd-like"$env:USERPROFILE\Documents\ORVION-*"
    # Parse command structure without executing it. A mention, variable or quoted command payload does not opt in.
    $explicitTool=$false;$timedCommand=$null
    if($hookEvent-eq'PostToolUse'-and$e.tool_name-in'PowerShell','Bash'){
        $parseErrors=$null;$tokens=$null
        $ast=[Management.Automation.Language.Parser]::ParseInput("$($e.tool_input.command)",[ref]$tokens,[ref]$parseErrors)
        if(!$parseErrors){foreach($cmd in $ast.FindAll({param($n)$n-is[Management.Automation.Language.CommandAst]},$true)){
            $name=$cmd.GetCommandName();if(!$name-or[IO.Path]::GetFileNameWithoutExtension($name)-notin'pwsh','powershell'){continue}
            $elements=$cmd.CommandElements
            for($i=1;$i-lt$elements.Count-1;$i++){
                if($elements[$i]-is[Management.Automation.Language.CommandParameterAst]-and$elements[$i].ParameterName-eq'File'-and($elements[$i+1]-is[Management.Automation.Language.StringConstantExpressionAst]-or$elements[$i+1]-is[Management.Automation.Language.ExpandableStringExpressionAst])){
                    $file=$elements[$i+1].Value
                    if($file-match'(?:^|[\\/])run_timed\.ps1$'-and!$timedCommand){$timedCommand=$cmd}
                    if($elements[$i+1]-is[Management.Automation.Language.StringConstantExpressionAst]-and[IO.Path]::IsPathFullyQualified($file)){
                        $file=[IO.Path]::GetFullPath($file)
                        if($file.StartsWith($lib.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)-and$file.EndsWith('.ps1',[StringComparison]::OrdinalIgnoreCase)-and(Test-Path -LiteralPath $file -PathType Leaf)){$explicitTool=$true}
                    }
                }
            }
        }}
    }
    function Send-Context([string]$Text){
        $safe=& {param($Value,$Library,$Workspace) . (Join-Path $Library 'Sync-Sessions.ps1') -Library -Root $Workspace;Hide-Secret $Value} $Text $lib $dataRoot
        if($hookEvent-eq'SessionStart'){$safe;return}
        @{hookSpecificOutput=@{hookEventName=$hookEvent;additionalContext=$safe}}|ConvertTo-Json -Compress -Depth 4
    }
    if($hookEvent-in'SessionStart','SessionEnd'){
        if(!$archiveScope){exit 0}
        # Archive every session verbatim (Claude Code deletes transcripts after 30 days), continuously: start a follower
        # (a pass a minute while any Claude Code or Codex process runs; a second one exits at once). Detached, so the hook stays fast.
        $mode=if($hookEvent-eq'SessionStart'){'-Follow -Quiet'}else{'-Quiet'}
        . (Join-Path $lib 'workspace-layout.ps1')
        $null=Initialize-OrvionTemporaryRoot -Checkout $workbench
        Start-Process pwsh -ArgumentList "-NoProfile -File `"$lib\Sync-Sessions.ps1`" $mode -Root `"$dataRoot`"" -WindowStyle Hidden
        if($hookEvent-eq'SessionEnd'){exit 0}
        if(!$workbenchEntry){exit 0} # archival preserves knowledge; it never enrolls a native session in Workbench
        $md=[IO.File]::ReadAllText((Join-Path $lib 'README.md'))
        $always=[regex]::Match($md,'(?s)## Always.*?(?=\n## )').Value
        # File redirection avoids a full pipe blocking Pulse before its deadline. Only this child tree is owned here.
        $pulseTemp=Join-Path ([IO.Path]::GetTempPath()) ('orvion-pulse-'+[guid]::NewGuid().ToString('N'))
        $pulseOut=$pulseTemp+'.out';$pulseErr=$pulseTemp+'.err';$pulseChild=$null
        try{
            $pulseChild=Start-Process pwsh -ArgumentList "-NoProfile -NonInteractive -File `"$lib\Pulse.ps1`" -Root `"$dataRoot`"" -RedirectStandardOutput $pulseOut -RedirectStandardError $pulseErr -WindowStyle Hidden -PassThru
            if(!$pulseChild.WaitForExit(6000)){
                $pulseChild.Kill($true)
                if(!$pulseChild.WaitForExit(1000)){throw 'pulse cleanup incomplete'}
                $events='Pulse did not answer in 6 s; live state UNREADABLE.'
            }else{
                $events=([IO.File]::ReadAllText($pulseOut)-replace'\r?\n',"`n").TrimEnd([char]10)
                $pulseError=[IO.File]::ReadAllText($pulseErr)
                if($pulseError-or($pulseChild.ExitCode-ne0-and$events-notmatch'UNREADABLE')){$events='Pulse UNREADABLE (reporter failed; run Pulse.ps1 directly).'}
                if($events.Length-gt4096){$events='Pulse UNREADABLE (reporter output exceeded 4096 characters; run Pulse.ps1 directly).'}
            }
        }catch{
            if($pulseChild-and!$pulseChild.HasExited){try{$pulseChild.Kill($true);$null=$pulseChild.WaitForExit(1000)}catch{$null=$_}}
            $events='Pulse UNREADABLE (reporter could not run).'
        }finally{
            if($pulseChild){$pulseChild.Dispose()}
            foreach($pulseFile in $pulseOut,$pulseErr){try{if(Test-Path -LiteralPath $pulseFile){Remove-Item -LiteralPath $pulseFile -Force}}catch{$null=$_}}
        }
        $contextPrefix="ORVION AGENT TOOLS exist at $lib (index: README.md). Use them; never hand-write an alarm loop.`n"
        $contextSuffix="`nBefore a task: pwsh -NoProfile -File `"$lib\Events.ps1`" -Find '<task in a few words>'. Record a failure, discovery or decision worth keeping with Events.ps1 -Add. Past sessions (task, size, tools, errors, SPECs, raw path): $dataRoot\sessions\INDEX.md."
        $guidance=$always.Replace('<lib>',$lib)
        $contextLimit=8192-[Environment]::NewLine.Length
        if($contextPrefix.Length+$guidance.Length+1+$events.Length+$contextSuffix.Length-gt$contextLimit){
            $guidance="Tool guidance abbreviated; see $lib\README.md."
        }
        $context=$contextPrefix+$guidance+"`n"+$events+$contextSuffix
        if($context.Length-gt$contextLimit){$context="ORVION AGENT TOOLS: see lib\README.md.`n$events`nPast sessions: sessions\INDEX.md under the selected data root."}
        Send-Context $context
        exit 0
    }
    if(!$workbenchEntry-and!$explicitTool){exit 0}
    $in=$e.tool_input
    # The hook input carries no run_in_background flag; the launch response does: isAsync, agentId (measured 2026-10-19).
    $r=$e.tool_response
    if($hookEvent-eq'PostToolUse'-and$e.tool_name-in'Agent','Task'-and($in.run_in_background-or$r.isAsync-or$r.status-eq'async_launched')){
        if("$($e.session_id)"-notmatch'^[A-Za-z0-9_-]+$'-or($r.agentId-and"$($r.agentId)"-notmatch'^[A-Za-z0-9_-]+$')){Send-Context 'WATCHDOG_UNREADABLE: explicit supported Claude session/agent identity is required; never guess the latest transcript.';exit 0}
        $only=if($r.agentId){" -Only $($r.agentId)"}else{' -SinceStart'}
        Send-Context ("WATCHDOG REQUIRED for this explicit Claude session: pwsh -NoProfile -File `"$lib\Watch-Subagents.ps1`" -Session $($e.session_id)$only. Use one owned observer. STALLED proves a tool wait, not its cause or permission to kill. Investigate under the subject's native authority; report unreadable evidence. This adapter does not observe another client's transcript format.")
        exit 0
    }
    if($timedCommand){
        $c=$timedCommand.Extent.Text
        $log=[regex]::Match($c,'-Log\s+(?:"([^"]+)"|''([^'']+)''|(\S+))');$log=@($log.Groups[1].Value,$log.Groups[2].Value,$log.Groups[3].Value)|Where-Object{$_}|Select-Object -First 1
        if(!$log-or$c-notmatch'run_timed\.ps1["'']?\s'){exit 0}  # a mention, not a run
        $rt=[regex]::Match($c,'(?:"([^"]*run_timed\.ps1)"|(\S*run_timed\.ps1))');$rt=@($rt.Groups[1].Value,$rt.Groups[2].Value)|Where-Object{$_}|Select-Object -First 1
        # The hook sees the command text only: a path built from variables ($E\pt\scripts\run_timed.ps1) cannot be
        # resolved here, and the session folder need not be a repository. Never print a watcher path that does not exist.
        $watch=if($rt-and[IO.Path]::IsPathRooted($rt)-and$rt-notmatch'\$'){Join-Path (Split-Path $rt -Parent) 'watch_run.ps1'}else{Join-Path $e.cwd 'scripts\watch_run.ps1'}
        if($rt-match'\$'-or!(Test-Path -LiteralPath $watch)){$watch='<the folder of the run_timed.ps1 you started>\watch_run.ps1'}
        if($log-match'\$'){$log="$log (expand the variables: the hook cannot)"}
        $run=if($c-match'Workbench\.ps1.*-Finish'){'workbench-finish'}elseif($c-match'-Finish'){'finish-control'}elseif($c-match'test_agent_continuity'){'control-suite'}else{'timed-run'}
        $bg=if($in.run_in_background){'Attach while the runner is live.'}else{'This post-tool event may arrive after a foreground run ended. Late attachment cannot prove live coverage; preserve the gap, and never repeat an expensive run without native justification.'}
        Send-Context ("WATCHER REQUIRED: reuse the one native observer for this run; if absent while live: pwsh -NoProfile -File `"$watch`" -Log `"$log`" -Run $run -Brief. For heavy concurrent runs reuse one shared host observer over their owned PIDs: `"$lib\Watch-Host.ps1`" -WatchPid <owned runner PIDs> -ExitWhenPidsGone. Report transitions/blockers; routine heartbeat at most every five minutes. $bg")
        exit 0
    }
}catch{  # never block a session, but never fail silently either: Hunt.ps1 reports this log
    # Stable diagnostic only: exception messages/input may contain credentials. This reporter is never a native gate.
    $rootFailureCode=if($_.Exception.Message-in'ORVION_DATA_ROOT_NOT_ABSOLUTE','ORVION_DATA_ROOT_UNAVAILABLE','WB_TEMP_LAYOUT_UNAVAILABLE','WB_TEMP_ROOT_NOT_ABSOLUTE','WB_TEMP_MATERIALIZATION_FAILED'){$_.Exception.Message}
    # Resolve independently of $lib/$dataRoot: even their initialization may have failed.
    try{
    $checkout=Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $sibling=Join-Path (Split-Path $checkout -Parent) 'ORVION-Owner-Tools'
    foreach($candidate in @($env:ORVION_DATA_ROOT)+@(if(Test-Path -LiteralPath (Join-Path $sibling 'events')){$sibling})){
        try{
            if(!$candidate-or![IO.Path]::IsPathFullyQualified($candidate)){continue}
            $errDir=Join-Path ([IO.Path]::GetFullPath($candidate)) 'work'
            [IO.Directory]::CreateDirectory($errDir)|Out-Null
            [IO.File]::AppendAllText((Join-Path $errDir 'hook-errors.log'),"$([DateTime]::UtcNow.ToString('o')) WATCH_REMINDER_UNREADABLE`n")
            break
        }catch{$null=$_}
    }
    }catch{$null=$_}
    [Console]::Error.WriteLine('WATCH_REMINDER_UNREADABLE: '+$(if($rootFailureCode){$rootFailureCode+'; '})+'reporting failed; consult the native authority, not an inferred success.')
}
exit 0
