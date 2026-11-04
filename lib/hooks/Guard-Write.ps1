# PreToolUse guard on PowerShell and Bash (DEC-28, guards.md G02): exits 2 when a command names a single-writer file
# together with a write verb, so the client refuses the call. The list is the file names of the Edit deny rules of
# .claude/settings.json (G01). It catches accidents and is no security boundary: a script that opens a file it does not
# name passes, and a crashed or timed-out hook does not block; Organize -Check catches what it misses. It errs toward
# refusal: a read that also redirects elsewhere is refused too, so run that from the file's own tool.
param([string]$Settings=(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) '.claude\settings.json'))
$ErrorActionPreference='Stop'
$command="$(([Console]::In.ReadToEnd()|ConvertFrom-Json).tool_input.command)"
$rules=@(([IO.File]::ReadAllText($Settings)|ConvertFrom-Json).permissions.deny|Where-Object{$_-cmatch'^Edit\('})
$names=@($rules|ForEach-Object{($_.TrimEnd(')')-split'/')[-1]}|Where-Object{$_-notmatch'\*'}|Select-Object -Unique)
$writes='Set-Content|Add-Content|Clear-Content|Out-File|Tee-Object|Move-Item|Copy-Item|Remove-Item|Rename-Item|New-Item|\b(tee|mv|cp|rm|del|ren|sc|ac)\b|sed\s+-i|\[(System\.)?IO\.File\]::\s*(Write|Append|Move|Copy|Delete|Replace|Create|Open)|>'
# A redirect of a stream or into nothing writes no file, and -> or => is no redirect.
$plain=$command-replace'\d?>&\d|\d?>>?\s*(\$null|/dev/null|NUL)\b|[-=]>',''
if($plain-notmatch$writes){exit 0}
foreach($name in $names){
    if($plain-match"(?<![\w.-])$([regex]::Escape($name))(?![\w.-])"){[Console]::Error.WriteLine("GUARD_SINGLE_WRITER: $name has one writer, so run that tool, not this command (DEC-28)");exit 2}
}
exit 0
