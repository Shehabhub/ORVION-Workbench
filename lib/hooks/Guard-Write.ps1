# PreToolUse guard on PowerShell and Bash (DEC-28, guards.md G02): exits 2 when a command writes a single-writer file
# or redirects into a package\release folder, so the client refuses the call. The single-writer list is the file names
# of the Edit deny rules of .claude/settings.json (G01). The command is split into segments on &&, ||, |, ; and line
# breaks outside quotes and here-strings, and a segment is refused only when the name comes after a write verb in it, so a name inside a here-string or
# a read argument passes. It catches accidents and is no security boundary: a script that opens a file it does not name
# passes, and a crashed or timed-out hook does not block; Organize -Check catches what it misses. It errs toward
# refusal: a copy or move that only reads the file is refused too, so run that from the file's own tool.
param([string]$Settings=(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) '.claude\settings.json'),[string]$FinishLog='finish\.log')
$ErrorActionPreference='Stop'
$command="$(([Console]::In.ReadToEnd()|ConvertFrom-Json).tool_input.command)"
# A Finish hashes the real journal from launch to END (event no-journal-write-during-finish): no Events -Add while one runs.
# A Finish is a pwsh running lib/Pulse.ps1's timed-run test (run_timed.ps1) with its finish.log.
if($command-match'Events\.ps1\b[^|;&\r\n]*\s-Add\b'){$run=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'"|Where-Object{$_.CommandLine-match'run_timed\.ps1'-and$_.CommandLine-match$FinishLog})
    if($run.Count){[Console]::Error.WriteLine("GUARD_FINISH_JOURNAL: a Finish is running (pid $($run[0].ProcessId)); Events -Add changes the real journal it checks, so queue the lesson and add it after END");exit 2}}
$rules=@(([IO.File]::ReadAllText($Settings)|ConvertFrom-Json).permissions.deny|Where-Object{$_-cmatch'^Edit\('})
$names=@($rules|ForEach-Object{($_.TrimEnd(')')-split'/')[-1]}|Where-Object{$_-notmatch'\*'}|Select-Object -Unique)
$writes='Set-Content|Add-Content|Clear-Content|Out-File|Tee-Object|Move-Item|Copy-Item|Remove-Item|Rename-Item|New-Item|\b(tee|mv|cp|rm|del|ren|sc|ac)\b|sed\s+-i|\[(System\.)?IO\.File\]::\s*(Write|Append|Move|Copy|Delete|Replace|Create|Open)|>'
# A file written into a package\release folder changes the hashed release (lesson release-log-inside-hashed-folder).
$fills='Set-Content|Add-Content|Out-File|Tee-Object|\btee\b|\[(System\.)?IO\.File\]::\s*(Write|Append|Create)|>'
# A redirect of a stream or into nothing writes no file, and -> or => is no redirect.
$plain=$command-replace'\d?>&\d|\d?>>?\s*(\$null|/dev/null|NUL)\b|[-=]>',''
# Separators inside quotes or here-strings do not split, so a quoted ; or | cannot part a write verb from its target.
$segments=[Collections.Generic.List[string]]::new();$start=0
foreach($m in [regex]::Matches($plain,'@''[\s\S]*?''@|@"[\s\S]*?"@|''[^'']*''|"(?:[^"`]|`.)*"|&&|\|\||\||;|\r?\n')){
    if($m.Value[0]-notin"'",'"','@'){$segments.Add($plain.Substring($start,$m.Index-$start));$start=$m.Index+$m.Length}
}
$segments.Add($plain.Substring($start))
foreach($segment in $segments){
    $verb=[regex]::Match($segment,$writes,'IgnoreCase')
    if(!$verb.Success){continue}
    $after=$segment.Substring($verb.Index)
    foreach($name in $names){
        if($after-match"(?<![\w.-])$([regex]::Escape($name))(?![\w.-])"){[Console]::Error.WriteLine("GUARD_SINGLE_WRITER: $name has one writer, so run that tool, not this command (DEC-28)");exit 2}
    }
    $fill=[regex]::Match($segment,$fills,'IgnoreCase')
    if($fill.Success-and$segment.Substring($fill.Index)-match'package[\\/]+release(?![\w.-])'){[Console]::Error.WriteLine('GUARD_RELEASE_FOLDER: write logs outside package\release, which is hashed (lesson release-log-inside-hashed-folder)');exit 2}
}
exit 0
