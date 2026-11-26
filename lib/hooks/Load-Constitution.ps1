# SessionStart hook: the constitution in every context. On startup, clear, resume and compact alike it prints DEC-30 and
# DEC-33 of docs/DECISIONS.md whole and the ID and title of every other decision, so no context (an old session resumed
# included) starts without them; only in a new context (startup, clear, or a client that sends no source) it adds the
# Always section of lib/README.md. Watch-Reminder.ps1 prints NOW.md and Pulse and never this text. Silent outside the
# Workbench root, judged by the project directory Claude Code names (CLAUDE_PROJECT_DIR), else the event's cwd, so a
# session whose shell has moved elsewhere still gets it. A missing section or rule, or text over its bound, prints one
# line telling the agent to read the rules itself before any governed decision. Reads the hook event from stdin; never
# blocks and exits 0. As the UserPromptSubmit hook it prints only DEC-33's twelve rules and DEC-31, the form of every
# reply (the rule-check table, both recommendations), so each owner message puts them in front of the reply; the Stop prompt hook of .claude/settings.json then checks the reply against rules 4, 5 and 10.
$ErrorActionPreference='Stop'
$lib=Split-Path $PSScriptRoot -Parent;$workbench=Split-Path $lib -Parent
$retrieve="CONSTITUTION NOT LOADED: read $workbench\docs\DECISIONS.md DEC-30 and DEC-33 in full now, before any governed decision"
try{
    $e=try{$raw=[Console]::In.ReadToEnd();if($raw.Trim()){$raw|ConvertFrom-Json}}catch{$null}
    $cwd=if($env:CLAUDE_PROJECT_DIR){$env:CLAUDE_PROJECT_DIR}elseif($e.cwd){"$($e.cwd)"}else{(Get-Location).Path}
    if([IO.Path]::GetFullPath($cwd).TrimEnd('\')-ne[IO.Path]::GetFullPath($workbench).TrimEnd('\')){exit 0}
    $text=[IO.File]::ReadAllText((Join-Path $workbench 'docs\DECISIONS.md'))-replace'\r?\n',"`n"
    # A section runs from its "## DEC-NN Title" heading to the next "## " heading or the end of the file (DEC-32).
    $dec30=[regex]::Match($text,'(?ms)^## DEC-30 .*?(?=\n## |\z)').Value.TrimEnd()
    $dec33=[regex]::Match($text,'(?ms)^## DEC-33 .*?(?=\n## |\z)').Value.TrimEnd()
    $dec31=[regex]::Match($text,'(?ms)^## DEC-31 .*?(?=\n## |\z)').Value.TrimEnd()
    $missing=@(if(!$dec30){'DEC-30'};if(!$dec31){'DEC-31'};if(!$dec33){'DEC-33'}else{foreach($n in 1..12){if($dec33-notmatch"(?m)^$n\. "){"DEC-33 rule $n"}}})
    if($missing){"$retrieve (not found: $($missing-join', '))."; exit 0}
    if($e.hook_event_name-eq'UserPromptSubmit'){
        $rules="THE CONSTITUTION, DEC-33 of $workbench\docs\DECISIONS.md (apply each rule before writing):`n$dec33`n`n$dec31"
        if($rules.Length-gt9500){"$retrieve (over the 9500-character bound)."}else{$rules}; exit 0
    }
    $others=@([regex]::Matches($text,'(?m)^## (DEC-\d+ .+)$')|ForEach-Object{$_.Groups[1].Value}|Where-Object{$_-notmatch'^DEC-3[03] '})
    $constitution="THE CONSTITUTION, from $workbench\docs\DECISIONS.md (decide by it):`n$dec30`n`n$dec33`n`nOther decisions in force (read the one a decision touches): $($others-join'; ')."
    $pointer="Tool guidance abbreviated; see $lib\README.md section 4."
    $guidance=$pointer
    if(!$e.source-or$e.source-in'startup','clear'){
        $md=[IO.File]::ReadAllText((Join-Path $lib 'README.md'))-replace'\r?\n',"`n"
        $always=[regex]::Match($md,'(?ms)^## (?:\d+\. )?Always\b.*?(?=\n## |\z)').Value.TrimEnd()  # found by title, with or without its ID (DEC-32)
        $guidance=if($always){$always.Replace('<lib>',$lib)}else{"Tool guidance UNREADABLE: no Always section in $lib\README.md; read it."}
    }
    # 9500: under the 10,000-character hook output cap; the tool guidance gives way first, the constitution is never cut.
    if($constitution.Length+1+$guidance.Length-gt9500){$guidance=$pointer}
    if($constitution.Length+1+$guidance.Length-gt9500){"$retrieve (over the 9500-character bound)."; exit 0}
    "$constitution`n$guidance"
}catch{"$retrieve (the hook failed)."}
exit 0
