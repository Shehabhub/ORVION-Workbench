# WS-023 owning checks. No real user data, installers, network, gh or real claude.
# Function seams prove orchestration; one tiny real 7z/bundle proves the Windows PowerShell entry wiring.
param()
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) ('orvion-recovery-check-'+[guid]::NewGuid().ToString('N').Substring(0,8))
[void][IO.Directory]::CreateDirectory($t)
$source=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Restore-ORVION.ps1'))
$savedProfile=$env:USERPROFILE;$savedGlobal=$env:GIT_CONFIG_GLOBAL;$savedSystem=$env:GIT_CONFIG_NOSYSTEM
$savedInjection=@{}
foreach($key in [Environment]::GetEnvironmentVariables('Process').Keys|Where-Object{$_-match'^GIT_CONFIG_(COUNT|PARAMETERS|KEY_\d+|VALUE_\d+)$'}){
    $savedInjection[$key]=[Environment]::GetEnvironmentVariable($key,'Process');Remove-Item -LiteralPath ('Env:\'+$key)
}
$env:USERPROFILE=Join-Path $t 'profile';$env:GIT_CONFIG_GLOBAL=Join-Path $t 'empty.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
$fail=0
function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
function Import-RecoveryFunctions([string]$Text){
    $tokens=$null;$errors=$null;$ast=[Management.Automation.Language.Parser]::ParseInput($Text,[ref]$tokens,[ref]$errors)
    if($errors.Count){throw "FIXTURE_PARSE_FAILED: $errors"}
    foreach($node in $ast.FindAll({param($n)$n-is[Management.Automation.Language.FunctionDefinitionAst]},$false)){
        Invoke-Expression ($node.Extent.Text-replace'^function ([\w-]+)','function script:$1')
    }
}
function Set-Sidecar([string]$Archive){[IO.File]::WriteAllText("$Archive.sha256",((Get-FileHash $Archive).Hash+' *'+(Split-Path $Archive -Leaf))) }
function Invoke-Scenario([string]$Case,[string]$Text=$source){
    Import-RecoveryFunctions $Text
    $root=Join-Path $t ([guid]::NewGuid().ToString('N').Substring(0,8));[void][IO.Directory]::CreateDirectory($root)
    $script:case=$Case;$script:calls=[Collections.Generic.List[string]]::new();$script:available=@{winget=$true;git=$true;'7z'=$true;pwsh=$true}
    $script:fakePkg=Join-Path $root 'orvion-backup-fixture';[void][IO.Directory]::CreateDirectory($script:fakePkg)
    $record=@{name='ORVION-Workbench';branch='recovery-branch';head=('a'*40)}
    $plan=@{sourceUserProfile=$env:USERPROFILE;repos=@($record)}
    if($Case-eq'profile'){$plan.sourceUserProfile='C:\Users\different'}
    if($Case-eq'unrecorded'){$plan.Remove('sourceUserProfile')}
    if($Case-eq'record'){$record.head='bad'}
    [IO.File]::WriteAllText((Join-Path $script:fakePkg 'backup.json'),($plan|ConvertTo-Json -Depth 6))
    $packages=Join-Path $root 'cloud';[void][IO.Directory]::CreateDirectory($packages)
    $older=Join-Path $packages 'orvion-backup-20260101T000000Z.7z';[IO.File]::WriteAllText($older,'older');Set-Sidecar $older
    $newer=Join-Path $packages 'orvion-backup-20260201T000000Z.7z';[IO.File]::WriteAllText($newer,'newer');Set-Sidecar $newer
    # Deliberately reverse filesystem timestamps: only the UTC filename owns selection.
    (Get-Item $older).LastWriteTime=[datetime]::Now.AddDays(1)
    if($Case-eq'package') {Remove-Item -LiteralPath $older,$newer}
    if($Case-eq'sidecar'){Remove-Item -LiteralPath "$newer.sha256"}
    if($Case-eq'invalid'){[IO.File]::WriteAllText("$newer.sha256",('b'*64)+' *wrong.7z')}
    if($Case-eq'hash'){[IO.File]::WriteAllText($newer,'damaged newest')}
    if($Case-eq'winget'){$script:available.winget=$false}
    if($Case-in'claude-list','claude-list-fail'){$script:available.claude=$true}
    if($Case-in'install','verify','install-success'){$script:available.git=$false;$script:available.'7z'=$false;$script:available.pwsh=$false}
    function script:Get-RecoveryTool([string]$Name){if($script:available[$Name]){return $Name}}
    function script:Update-RecoveryPath{$script:calls.Add('refresh-path')}
    function script:Invoke-RecoveryProcess([string]$File,[string[]]$Arguments){
        $script:calls.Add($File+' '+($Arguments-join' '));$script:NativeExitCode=0
        if($File-eq'winget'){
            if($script:case-eq'install'){$script:NativeExitCode=17;return}
            if($script:case-ne'verify'){switch($Arguments[2]){'Git.Git'{$script:available.git=$true};'7zip.7zip'{$script:available.'7z'=$true};'Microsoft.PowerShell'{$script:available.pwsh=$true}}}
        }
        if($File-eq'7z'){
            if($script:case-eq'extract'){$script:NativeExitCode=18;return}
            $dir=$Arguments[1].Substring(2);[void][IO.Directory]::CreateDirectory($dir)
            if($script:case-ne'layout'){Copy-Item -LiteralPath $script:fakePkg -Destination $dir -Recurse}
        }
        if($File-eq'git'){
            if($Arguments[0]-eq'clone'){if($script:case-eq'clone'){$script:NativeExitCode=19;return};[void][IO.Directory]::CreateDirectory($Arguments[3])}
            if($Arguments[2]-eq'config'-and$script:case-eq'config'){$script:NativeExitCode=20}
            if($Arguments[2]-eq'checkout'-and$script:case-eq'checkout'){$script:NativeExitCode=21}
        }
        if($File-eq'pwsh'){Write-Output 'RESTORE_FIXTURE_OUTPUT';if($script:case-eq'restore'){$script:NativeExitCode=42}}
        if($File-eq'claude'){Write-Output '  > ponytail@ponytail';if($script:case-eq'claude-list-fail'){$script:NativeExitCode=26}}
        if($File-like'*CRM\workstation.cmd'-and$script:case-eq'product'){$script:NativeExitCode=23}
    }
    $stage=Join-Path $root 'stage';$target=Join-Path $root 'target'
    if($Case-eq'staging'){[void][IO.Directory]::CreateDirectory($stage);[IO.File]::WriteAllText((Join-Path $stage 'keep.txt'),'keep')}
    foreach($p in 'CRM','ORVION'){[void][IO.Directory]::CreateDirectory((Join-Path $target $p));[IO.File]::WriteAllText((Join-Path $target "$p\workstation.cmd"),'fixture')}
    if($Case-eq'product-missing'){[IO.File]::Delete((Join-Path $target 'CRM\workstation.cmd'))}
    if($Case-in'claude-list','claude-list-fail'){
        [void][IO.Directory]::CreateDirectory((Join-Path $root 'claude'))
        [IO.File]::WriteAllText((Join-Path $root 'claude\settings.json'),'{"enabledPlugins":{"ponytail@ponytail":true},"extraKnownMarketplaces":{"ponytail":{"source":{"source":"github","repo":"DietrichGebert/ponytail"}}}}')
    }
    $params=@{PackageDir=$packages;Staging=$stage;Target=$target;ClaudeHome=(Join-Path $root 'claude');LegacyTarget=(Join-Path $root 'docs');CodexHome=(Join-Path $root 'codex')}
    if($Case-eq'allow-profile'){$plan.sourceUserProfile='C:\Users\different';[IO.File]::WriteAllText((Join-Path $script:fakePkg 'backup.json'),($plan|ConvertTo-Json -Depth 6));$params.AllowNewProfile=$true}
    if($Case-eq'skip-products'){$params.SkipProducts=$true}
    $output=@(Invoke-OrvionRecovery @params *>&1)-join"`n"
    [pscustomobject]@{Exit=$script:RecoveryExit;Output=$output;Calls=@($script:calls.ToArray());Stage=(Test-Path $stage);Keep=(Test-Path (Join-Path $stage 'keep.txt'));Root=$root;Newer=$newer}
}
function Test-Refusal([string]$Case,[string]$Token,[string]$Text=$source){
    $r=Invoke-Scenario $Case $Text
    $early=$Case-in'package','sidecar','invalid','hash','winget','staging','install','verify'
    $calls=$r.Calls-join"`n"
    $ok=$r.Exit-ne0-and$r.Output.Contains($Token)-and$r.Output.Contains('READY/ACTION recovery checklist')
    if($early){$ok=$ok-and$calls-notmatch'^7z x'}else{$ok=$ok-and$r.Stage-and$r.Output.Contains('staging retained')-and$calls-notmatch'workstation.cmd'}
    if($Case-eq'staging'){$ok=$ok-and$r.Keep}
    if($Case-eq'restore'){$ok=$ok-and$r.Exit-eq42-and$r.Output.Contains('RESTORE_FIXTURE_OUTPUT')}
    if($Case-in'profile','unrecorded'){$ok=$ok-and$calls-notmatch'git clone'-and$r.Output.Contains('Manual fallback, profile paths')}
    $ok
}
try{
    Assert-That 'launcher ASCII only' (@([IO.File]::ReadAllBytes((Join-Path $PSScriptRoot 'Restore-ORVION.ps1'))|Where-Object{$_-gt127}).Count-eq0)
    $parse='param($p) $t=$null; $e=$null; [void][System.Management.Automation.Language.Parser]::ParseFile($p,[ref]$t,[ref]$e); if($e.Count){$e | Out-String | Write-Output; exit 1}; if($PSVersionTable.PSVersion.Major -ne 5 -or $PSVersionTable.PSVersion.Minor -ne 1){exit 2}; exit 0'
    $parseFile=Join-Path $t 'parse.ps1';[IO.File]::WriteAllText($parseFile,$parse)
    $parsed=@(& powershell.exe -NoProfile -File $parseFile (Join-Path $PSScriptRoot 'Restore-ORVION.ps1') 2>&1)
    Assert-That 'Windows PowerShell 5.1 parses launcher (exit 0)' ($LASTEXITCODE-eq0)
    # Explicit requested -Command parser check, in addition to -File above.
    $commandCheck="`$t=`$null; `$e=`$null; [void][System.Management.Automation.Language.Parser]::ParseFile('"+(Join-Path $PSScriptRoot 'Restore-ORVION.ps1').Replace("'","''")+"',[ref]`$t,[ref]`$e); if(`$e.Count){exit 1}; exit 0"
    & powershell.exe -NoProfile -Command $commandCheck
    Assert-That 'powershell.exe -NoProfile -Command parse check (exit 0)' ($LASTEXITCODE-eq0)
    $refusals=[ordered]@{winget='RECOVERY_WINGET_REQUIRED';package='RECOVERY_PACKAGE_MISSING';sidecar='RECOVERY_SIDECAR_MISSING';invalid='RECOVERY_SIDECAR_INVALID';hash='RECOVERY_HASH_MISMATCH';staging='RECOVERY_STAGING_EXISTS';install='RECOVERY_INSTALL_FAILED';verify='RECOVERY_COMMAND_MISSING';extract='RECOVERY_EXTRACT_FAILED';layout='RECOVERY_LAYOUT_INVALID';profile='RECOVERY_PROFILE_MISMATCH';unrecorded='RECOVERY_PROFILE_MISMATCH';record='RECOVERY_WORKBENCH_RECORD_INVALID';clone='RECOVERY_WORKBENCH_CLONE_FAILED';config='RECOVERY_WORKBENCH_CONFIG_FAILED';checkout='RECOVERY_WORKBENCH_CHECKOUT_FAILED';restore='RECOVERY_RESTORE_FAILED'}
    foreach($caseName in $refusals.Keys){Assert-That ("refusal $caseName") (Test-Refusal $caseName $refusals[$caseName])}
    $r=Invoke-Scenario success;$calls=$r.Calls-join"`n"
    Assert-That 'newest by name; one extraction; local bundle branch/head; four paths passed; products both run; staging removed' ($r.Exit-eq0-and!$r.Stage-and@($r.Calls|Where-Object{$_-like'7z x *'}).Count-eq1-and$calls.Contains($r.Newer)-and$calls.Contains('repos\ORVION-Workbench.bundle')-and$calls.Contains('checkout --quiet -B recovery-branch '+('a'*40))-and$calls.Contains('-From ')-and$calls.Contains('-Target ')-and$calls.Contains('-ClaudeHome ')-and$calls.Contains('-LegacyTarget ')-and$calls.Contains('-CodexHome ')-and$calls.Contains('CRM\workstation.cmd')-and$calls.Contains('ORVION\workstation.cmd')-and$calls-notmatch'winget install')
    $r=Invoke-Scenario install-success;$calls=$r.Calls-join"`n"
    Assert-That 'missing prerequisites only: exact three winget ids/flags; refresh PATH after each; verify commands' ($r.Exit-eq0-and@($r.Calls|Where-Object{$_-eq'refresh-path'}).Count-eq3-and@($r.Calls|Where-Object{$_-like'winget install *'}).Count-eq3-and$calls.Contains('Git.Git --exact --source winget --accept-source-agreements --accept-package-agreements')-and$calls.Contains('7zip.7zip --exact --source winget --accept-source-agreements --accept-package-agreements')-and$calls.Contains('Microsoft.PowerShell --exact --source winget --accept-source-agreements --accept-package-agreements'))
    $r=Invoke-Scenario allow-profile;Assert-That 'explicit profile override prints manual repair step and restores' ($r.Exit-eq0-and$r.Output.Contains('repair absolute hooks'))
    $r=Invoke-Scenario skip-products;Assert-That 'SkipProducts avoids both product entries' ($r.Exit-eq0-and($r.Calls-join' ')-notmatch'workstation.cmd')
    foreach($caseName in 'product','product-missing'){$r=Invoke-Scenario $caseName;Assert-That "$caseName records failure and still runs ORVION; restored files retained" ($r.Exit-ne0-and!$r.Stage-and($r.Calls-join' ').Contains('ORVION\workstation.cmd')-and(Test-Path (Join-Path $r.Root 'target\ORVION\workstation.cmd')))}
    $r=Invoke-Scenario claude-list;Assert-That 'checklist obtains injected claude plugin list and suppresses installed commands' ($r.Exit-eq0-and($r.Calls-join' ').Contains('claude plugin list')-and!$r.Output.Contains('claude plugin install ponytail@ponytail'))
    $r=Invoke-Scenario claude-list-fail;Assert-That 'failed claude list records uncertainty/exit and prints enabled commands' ($r.Exit-eq26-and$r.Output.Contains('plugin presence is unverified')-and$r.Output.Contains('claude plugin install ponytail@ponytail --scope user'))
    Import-RecoveryFunctions $source
    $savedPath=$env:PATH;$savedProgramFiles=$env:ProgramFiles
    try{
        $env:PATH=Join-Path $t 'empty-path';$env:ProgramFiles=Join-Path $t 'program-files'
        [void][IO.Directory]::CreateDirectory((Join-Path $env:ProgramFiles '7-Zip'))
        $fallback=Join-Path $env:ProgramFiles '7-Zip\7z.exe';[IO.File]::WriteAllText($fallback,'discovery only, never executed')
        Assert-That '7z discovery falls back to Program Files when PATH lacks 7z' ((Get-RecoveryTool '7z')-ceq$fallback)
    }finally{$env:PATH=$savedPath;$env:ProgramFiles=$savedProgramFiles}
    Import-RecoveryFunctions $source
    $settings=Join-Path $t 'settings.json'
    [IO.File]::WriteAllText($settings,(@{enabledPlugins=@{'gitkraken-hooks@gitkraken'=$true;'ponytail@ponytail'=$true;'session-report@claude-plugins-official'=$true;'project-artifact@claude-plugins-official'=$true;'claude-md-management@claude-plugins-official'=$true;'oh-my-claudecode@omc'=$true;'disabled@unused'=$false};extraKnownMarketplaces=@{gitkraken=@{source=@{source='directory';path='C:\Users\old\.claude\plugins\marketplaces\gitkraken'}};ponytail=@{source=@{source='github';repo='DietrichGebert/ponytail'}};omc=@{source=@{source='github';repo='Yeachan-Heo/oh-my-claudecode'}}}}|ConvertTo-Json -Depth 8))
    $plugins=@(Write-RecoveryPluginChecklist $settings @('Installed plugins:','  > session-report@claude-plugins-official','  > ponytail@ponytail') *>&1)-join"`n"
    Assert-That 'plugin list fixture filters installed/disabled; builtin needs no add; directory uses own installer; GitHub commands exact' ($plugins.Contains('install GitKraken CLI, then its own hook installer')-and$plugins.Contains('claude plugin marketplace add Yeachan-Heo/oh-my-claudecode')-and$plugins.Contains('claude plugin install oh-my-claudecode@omc --scope user')-and$plugins.Contains('claude plugin install project-artifact@claude-plugins-official --scope user')-and$plugins.Contains('claude plugin install claude-md-management@claude-plugins-official --scope user')-and$plugins-notmatch'install (ponytail|session-report|disabled)@'-and$plugins-notmatch'marketplace add .*claude-plugins-official')
    $plugins=@(Write-RecoveryPluginChecklist $settings @() *>&1)-join"`n"
    Assert-That 'absent claude/list shows all enabled plugins including exact ponytail marketplace command' ($plugins.Contains('claude plugin marketplace add DietrichGebert/ponytail')-and@($plugins-split"`n"|Where-Object{$_-like'*claude plugin install *'}).Count-eq6)
    # Removing each new guard must kill its focused observation (including the clear refusal diagnosis).
    foreach($caseName in $refusals.Keys){
        $token=$refusals[$caseName]
        $match=[regex]::Match($source,'throw (?:'''+$token+'[^'']*''|"'+$token+'[^"\r\n]*")')
        if(!$match.Success){throw "MUTANT_ANCHOR_MISSING $token"}
        $mutant=$source.Replace($match.Value,"Write-Host 'MUTANT guard removed'")
        Assert-That ("MUTANT killed: $caseName guard removal") (!(Test-Refusal $caseName $token $mutant))
    }
    $mutant=$source.Replace('Sort-Object Name -Descending','Sort-Object Name')
    $r=Invoke-Scenario success $mutant
    Assert-That 'MUTANT killed: oldest selection' (!(($r.Calls-join' ').Contains($r.Newer)))
    $mutant=$source.Replace('if(!(Test-Path -LiteralPath $entry -PathType Leaf)){','if($false){')
    $r=Invoke-Scenario product-missing $mutant
    Assert-That 'MUTANT killed: missing product entry refusal removed' ($r.Exit-eq0)
    $needle='if($script:NativeExitCode){Write-Host "ACTION: $product workstation preparation failed'
    $mutant=$source.Replace($needle,'if($false){Write-Host "ACTION: $product workstation preparation failed')
    $r=Invoke-Scenario product $mutant
    Assert-That 'MUTANT killed: product failure recording removed' ($r.Exit-eq0)
    # Real tiny extraction + real bundle checkout + real pwsh child, also run by Windows PowerShell 5.1.
    # The synthetic Restore body proves transport/output/exit, not the real workstation restore (C2).
    $zip=(Get-Command 7z -CommandType Application -ErrorAction Stop|Select-Object -First 1).Source;$git=(Get-Command git -CommandType Application -ErrorAction Stop|Select-Object -First 1).Source;$pwsh=(Get-Command pwsh -CommandType Application -ErrorAction Stop|Select-Object -First 1).Source
    $repo=Join-Path $t 'tiny-repo';$pkg=Join-Path $t 'real-package\orvion-backup-fixture';$cloud=Join-Path $t 'real-cloud'
    [void][IO.Directory]::CreateDirectory((Join-Path $repo 'lib'));[void][IO.Directory]::CreateDirectory((Join-Path $pkg 'repos'));[void][IO.Directory]::CreateDirectory($cloud)
    $body='param($From,$Target,$ClaudeHome,$LegacyTarget,$CodexHome) if(!(Test-Path (Join-Path $From "backup.json")) -or !$Target -or !$ClaudeHome -or !$LegacyTarget -or !$CodexHome){exit 44}; Write-Output "REAL_CHILD_OUTPUT"; if($Target -like "*child-failure*"){exit 42}; exit 0'
    [IO.File]::WriteAllText((Join-Path $repo 'lib\Restore-Workspace.ps1'),$body)
    & $git init -q -b main $repo;if($LASTEXITCODE){throw 'TINY_INIT_FAILED'}
    & $git -C $repo add -A;if($LASTEXITCODE){throw 'TINY_ADD_FAILED'}
    & $git -C $repo -c user.name=fixture -c user.email=fixture@example.invalid -c core.hooksPath=NUL commit -q -m fixture;if($LASTEXITCODE){throw 'TINY_COMMIT_FAILED'}
    $head=(& $git -C $repo rev-parse HEAD).Trim()
    & $git -C $repo bundle create (Join-Path $pkg 'repos\ORVION-Workbench.bundle') --all 2>&1|Out-Null;if($LASTEXITCODE){throw 'TINY_BUNDLE_FAILED'}
    [IO.File]::WriteAllText((Join-Path $pkg 'backup.json'),(@{sourceUserProfile=$env:USERPROFILE;repos=@(@{name='ORVION-Workbench';branch='HEAD';head=$head})}|ConvertTo-Json -Depth 5))
    $archive=Join-Path $cloud 'orvion-backup-20260101T000000Z.7z'
    & $zip a -t7z -mx1 $archive $pkg 2>&1|Out-Null;if($LASTEXITCODE){throw 'TINY_ARCHIVE_FAILED'};Set-Sidecar $archive
    $harness=Join-Path $t 'real-harness.ps1'
    # Dot-load only function definitions from the actual launcher; replace tool discovery, leave process execution real.
    $harnessBody=@'
param($Source,$Zip,$Git,$Pwsh,$Cloud,$Stage,$FixtureRoot)
$ErrorActionPreference='Stop'
$tok=$null;$err=$null;$ast=[Management.Automation.Language.Parser]::ParseFile($Source,[ref]$tok,[ref]$err)
foreach($fn in $ast.FindAll({param($n)$n -is [Management.Automation.Language.FunctionDefinitionAst]},$false)){. ([scriptblock]::Create($fn.Extent.Text))}
function Get-RecoveryTool([string]$Name){switch($Name){winget {'fixture-winget-never-run'};git {$Git};'7z' {$Zip};pwsh {$Pwsh}}}
Invoke-OrvionRecovery -PackageDir $Cloud -Staging $Stage -Target "$FixtureRoot\target" -ClaudeHome "$FixtureRoot\claude" -LegacyTarget "$FixtureRoot\docs" -CodexHome "$FixtureRoot\codex" -SkipProducts
exit $script:RecoveryExit
'@
    [IO.File]::WriteAllText($harness,$harnessBody,[Text.Encoding]::ASCII)
    foreach($engine in @($pwsh,'powershell.exe')){
        $stage=Join-Path $t ('real-stage-'+[guid]::NewGuid().ToString('N').Substring(0,5))
        $out=@(& $engine -NoProfile -File $harness (Join-Path $PSScriptRoot 'Restore-ORVION.ps1') $zip $git $pwsh $cloud $stage $t 2>&1);$code=$LASTEXITCODE
        Assert-That "real 7z/local git/detached checkout/pwsh child under $engine (exit $code)" ($code-eq0-and($out-join' ').Contains('REAL_CHILD_OUTPUT')-and!(Test-Path $stage))
        if($code){$out|Select-Object -Last 12}
        $out=@(& $engine -NoProfile -File $harness (Join-Path $PSScriptRoot 'Restore-ORVION.ps1') $zip $git $pwsh $cloud $stage (Join-Path $t 'child-failure') 2>&1);$code=$LASTEXITCODE
        Assert-That "real restore child failure under $engine preserves output, exit 42 and staging" ($code-eq42-and($out-join' ').Contains('REAL_CHILD_OUTPUT')-and($out-join' ').Contains('staging retained')-and(Test-Path $stage))
    }
    $cmd=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Restore-ORVION.cmd'))
    Assert-That 'cmd forwards arguments, always pauses after capturing exit, and returns captured code' ($cmd.Contains('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Restore-ORVION.ps1" %*')-and$cmd-match'(?s)set "ORVION_EXIT=%ERRORLEVEL%"\r?\npause\r?\nexit /b %ORVION_EXIT%')
}finally{
    $env:USERPROFILE=$savedProfile;$env:GIT_CONFIG_GLOBAL=$savedGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedSystem
    foreach($key in $savedInjection.Keys){[Environment]::SetEnvironmentVariable($key,$savedInjection[$key],'Process')}
    # Own GUID fixture only; never a product clone or real user configuration.
    if([IO.Path]::GetFullPath($t).StartsWith([IO.Path]::GetFullPath([IO.Path]::GetTempPath()),[StringComparison]::OrdinalIgnoreCase)){
        Get-ChildItem -LiteralPath $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)
    }else{throw 'FIXTURE_CLEANUP_OUTSIDE_TEMP'}
}
if($fail){throw "RESTORE_ORVION_SELFCHECK_FAILED $fail"};'RESTORE_ORVION_SELFCHECK PASS'
