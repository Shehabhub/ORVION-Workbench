# WS-023 owning checks. No real user data, installers, network, gh or real claude.
# Function seams prove orchestration; one tiny real 7z/bundle proves the Windows PowerShell entry wiring.
param()
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) ('orvion-recovery-check-'+[guid]::NewGuid().ToString('N').Substring(0,8))
[void][IO.Directory]::CreateDirectory($t)
$source=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Restore-ORVION.ps1'))
$savedProfile=$env:USERPROFILE;$savedGlobal=$env:GIT_CONFIG_GLOBAL;$savedSystem=$env:GIT_CONFIG_NOSYSTEM
$savedInjection=@{}
foreach($key in 'OneDrive','OneDriveConsumer','OneDriveCommercial'){
    $savedInjection[$key]=[Environment]::GetEnvironmentVariable($key,'Process');[Environment]::SetEnvironmentVariable($key,$null,'Process')
}
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
function Get-FixtureTreeState([string]$Path){
    (@(Get-ChildItem -LiteralPath $Path -Recurse -Force|Sort-Object FullName|ForEach-Object{
        $hash='directory';if(!$_.PSIsContainer){$hash=(Get-FileHash -LiteralPath $_.FullName).Hash}
        $_.FullName+'|'+$_.Attributes+'|'+$hash
    })-join"`n")
}
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
    if($Case-eq'winget'){$script:available.winget=$false;$script:available.git=$false}
    if($Case-eq'no-winget'){$script:available.winget=$false}
    if($Case-in'claude-list','claude-list-fail'){$script:available.claude=$true}
    if($Case-in'install','verify','install-success'){$script:available.git=$false;$script:available.'7z'=$false;$script:available.pwsh=$false}
    function script:Get-RecoveryTool([string]$Name){$script:calls.Add('lookup '+$Name);if($script:available[$Name]){return $Name}}
    function script:Update-RecoveryPath{$script:calls.Add('refresh-path')}
    function script:Invoke-RecoveryProcess([string]$File,[string[]]$Arguments){
        $script:calls.Add($File+' '+($Arguments-join' '));$script:NativeExitCode=0
        if($File-eq'winget'){
            if($script:case-eq'install'){$script:NativeExitCode=17;return}
            if($script:case-ne'verify'){switch($Arguments[2]){'Git.Git'{$script:available.git=$true};'7zip.7zip'{$script:available.'7z'=$true};'Microsoft.PowerShell'{$script:available.pwsh=$true}}}
        }
        if($File-eq'7z'){
            if($Arguments[0]-eq'l'){
                if($script:case-eq'disk-list-exit'){$script:NativeExitCode=31;return}
                if($script:case-eq'disk-metadata'){'Path = bad';return}
                if($script:case-eq'disk-empty'){return}
                if($script:case-eq'disk-negative'){"Path = bad`nSize = -1";return}
                if($script:case-eq'disk-overflow'){"Path = bad`nSize = 9223372036854775808";return}
                "Path = fixture`nSize = 1024";return
            }
            if($script:case-eq'extract'){$script:NativeExitCode=18;return}
            $dir=$Arguments[1].Substring(2);[void][IO.Directory]::CreateDirectory($dir)
            if($script:case-eq'long-retained'){
                $deep=$dir;while($deep.Length-lt450){$deep=Join-Path $deep ('d'*35)}
                [void][IO.Directory]::CreateDirectory(('\\?\'+$deep))
                $script:longFile='\\?\'+(Join-Path $deep 'locked.txt')
                [IO.File]::WriteAllText($script:longFile,'retained fixture bytes')
                [IO.File]::SetAttributes($script:longFile,[IO.FileAttributes]::ReadOnly)
                $script:longAttributes=[IO.File]::GetAttributes($script:longFile)
                $script:longLock=[IO.File]::Open($script:longFile,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::Read)
            }
            if($script:case-ne'layout'){Copy-Item -LiteralPath $script:fakePkg -Destination $dir -Recurse}
        }
        if($File-eq'git'){
            if($Arguments[0]-eq'clone'){if($script:case-eq'clone'){$script:NativeExitCode=19;return};[void][IO.Directory]::CreateDirectory($Arguments[3])}
            if($Arguments[2]-eq'config'-and$script:case-eq'config'){$script:NativeExitCode=20}
            if($Arguments[2]-eq'checkout'-and$script:case-eq'checkout'){$script:NativeExitCode=21}
        }
        if($File-eq'pwsh'){Write-Output 'RESTORE_FIXTURE_OUTPUT';if($script:case-eq'restore'){$script:NativeExitCode=42};if($script:case-eq'temporary'-and$Arguments-contains'-Temporary'){$script:NativeExitCode=27};if($script:case-eq'map'-and($Arguments-join' ')-match'Map-Repos'){$script:NativeExitCode=28}}
        if($File-eq'claude'){Write-Output '  > ponytail@ponytail';if($script:case-eq'claude-list-fail'){$script:NativeExitCode=26}}
        if($File-like'*CRM\workstation.cmd'-and$script:case-eq'product'){$script:NativeExitCode=23}
    }
    function script:Get-RecoveryFreeBytes([string]$Path){
        if($script:case-eq'disk-unreadable'){throw 'RECOVERY_DISK_SPACE_UNREADABLE'}
        if($script:case-eq'disk-insufficient'){return [long]1}
        return [long]1GB
    }
    function script:Remove-RecoveryStaging {throw 'CLEANUP_SEAM_CALLED'}
    $stage=Join-Path $root 'stage';$target=Join-Path $root 'target'
    $outside=Join-Path $root 'outside.txt';[IO.File]::WriteAllText($outside,'outside fixture bytes')
    [IO.File]::SetAttributes($outside,[IO.FileAttributes]::ReadOnly)
    $outsideHash=(Get-FileHash $outside).Hash;$outsideAttributes=[IO.File]::GetAttributes($outside)
    if($Case-eq'exception'){function script:Get-RecoveryPackage {throw 'sensitive-exception-fixture'}}
    if($Case-eq'checklist-exception'){function script:Write-RecoveryChecklist {throw 'sensitive-checklist-fixture'}}
    if($Case-eq'staging'){[void][IO.Directory]::CreateDirectory($stage);[IO.File]::WriteAllText((Join-Path $stage 'keep.txt'),'keep')}
    foreach($p in 'CRM','ORVION'){[void][IO.Directory]::CreateDirectory((Join-Path $target $p));[IO.File]::WriteAllText((Join-Path $target "$p\workstation.cmd"),'fixture')}
    if($Case-eq'product-missing'){[IO.File]::Delete((Join-Path $target 'CRM\workstation.cmd'))}
    if($Case-in'claude-list','claude-list-fail'){
        [void][IO.Directory]::CreateDirectory((Join-Path $root 'claude'))
        [IO.File]::WriteAllText((Join-Path $root 'claude\settings.json'),'{"enabledPlugins":{"ponytail@ponytail":true},"extraKnownMarketplaces":{"ponytail":{"source":{"source":"github","repo":"DietrichGebert/ponytail"}}}}')
    }
    $params=@{PackageDir=$packages;Staging=$stage;Target=$target;ClaudeHome=(Join-Path $root 'claude');LegacyTarget=(Join-Path $root 'docs');CodexHome=(Join-Path $root 'codex')}
    if($Case-like'under-*'){$params[$Case.Substring(6)] = Join-Path $stage 'persistent'}
    if($Case-eq'equal-stage'){$params.ClaudeHome=$stage}
    if($Case-eq'alias-stage'){$alias=Join-Path $root 'alias';$null=New-Item -ItemType Junction -Path $alias -Target $root;$params.ClaudeHome=Join-Path $alias 'stage/persistent'}
    if($Case-in'default-stage','repeat-default'){$params.Remove('Staging')}
    if($Case-eq'placement-repo'){$params.Staging=Join-Path $target 'CRM/stage'}
    if($Case-eq'placement-data'){$params.Staging=Join-Path $env:ORVION_DATA_ROOT 'stage'}
    if($Case-eq'placement-profile-home'){$params.Staging=Join-Path $env:USERPROFILE '.codex/stage'}
    if($Case-eq'placement-owner-other'){$params.Staging=Join-Path $root 'other/ORVION-Owner-Tools/stage'}
    if($Case-eq'placement-git'){$gitRoot=Join-Path $root 'independent';[void][IO.Directory]::CreateDirectory((Join-Path $gitRoot '.git'));$params.Staging=Join-Path $gitRoot 'stage'}
    if($Case-eq'placement-sync'){$params.Staging=Join-Path $env:USERPROFILE 'OneDrive/stage'}
    if($Case-eq'placement-sync-alias'){
        $sync=Join-Path $env:USERPROFILE 'OneDrive';[void][IO.Directory]::CreateDirectory($sync)
        $alias=Join-Path $root 'sync-alias';$null=New-Item -ItemType Junction -Path $alias -Target $sync
        $params.Staging=Join-Path $alias 'stage'
    }
    if($Case-eq'relative-stage'){$params.Staging='.\relative-stage'}
    if($Case-eq'default-legacy'){$params.Remove('LegacyTarget')}
    if($Case-eq'allow-profile'){$plan.sourceUserProfile='C:\Users\different';[IO.File]::WriteAllText((Join-Path $script:fakePkg 'backup.json'),($plan|ConvertTo-Json -Depth 6));$params.AllowNewProfile=$true}
    if($Case-eq'skip-products'){$params.SkipProducts=$true}
    $savedLocation=Get-Location
    try{
        if($Case-eq'relative-stage'){Set-Location $root}
        $output=@(Invoke-OrvionRecovery @params *>&1)-join"`n"
        if($Case-eq'reuse-success'){
            $before=Get-FixtureTreeState $stage
            $second=@(Invoke-OrvionRecovery @params *>&1)-join"`n"
            $script:reusedRefused=$script:RecoveryExit-ne0-and$second-match'RECOVERY_STAGING_EXISTS'-and$second-notmatch'(?m)^READY: '-and(Get-FixtureTreeState $stage)-ceq$before
            $output+="`n"+$second
        }
        if($Case-eq'repeat-default'){
            $retained=@(Get-ChildItem (Join-Path $target 'ORVION-Workbench-temporary/restore-staging') -Directory)[0].FullName
            $marker=Join-Path $retained 'keep.txt';[IO.File]::WriteAllText($marker,'first attempt')
            $before=Get-FixtureTreeState $retained
            $output+="`n"+(@(Invoke-OrvionRecovery @params *>&1)-join"`n")
            $script:repeatKept=(Get-FixtureTreeState $retained)-ceq$before
        }
    }finally{Set-Location $savedLocation}
    $longOk=$true;$longLength=0
    if($Case-eq'long-retained'){
        try{
            $longLength=$script:longFile.Length-4
            $longOk=[IO.File]::ReadAllText($script:longFile)-ceq'retained fixture bytes'-and[IO.File]::GetAttributes($script:longFile)-eq$script:longAttributes
        }finally{$script:longLock.Dispose()}
    }
    $outsideOk=(Get-FileHash $outside).Hash-ceq$outsideHash-and[IO.File]::GetAttributes($outside)-eq$outsideAttributes
    [pscustomobject]@{Exit=$script:RecoveryExit;Output=$output;Calls=@($script:calls.ToArray());Stage=(Test-Path $stage);Keep=(Test-Path (Join-Path $stage 'keep.txt'));Root=$root;Newer=$newer;LongOk=$longOk;LongLength=$longLength;OutsideOk=$outsideOk;RepeatKept=$script:repeatKept;ReusedRefused=$script:reusedRefused}
}
function Test-Refusal([string]$Case,[string]$Token,[string]$Text=$source){
    $r=Invoke-Scenario $Case $Text
    $early=$Case-in'package','sidecar','invalid','hash','winget','staging','install','verify'
    $calls=$r.Calls-join"`n"
    $ok=$r.Exit-ne0-and$r.Output-notmatch'(?m)^READY: '-and$r.Output.Contains($Token)-and$r.Output.Contains('READY/ACTION recovery checklist')
    if($early){$ok=$ok-and$calls-notmatch'(?m)^7z x'}else{$ok=$ok-and$r.Stage-and$r.Output.Contains('staging retained')-and$calls-notmatch'workstation.cmd'}
    if($Case-eq'exception'){function script:Get-RecoveryPackage {throw 'sensitive-exception-fixture'}}
    if($Case-eq'checklist-exception'){function script:Write-RecoveryChecklist {throw 'sensitive-checklist-fixture'}}
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
    Assert-That 'newest by name; one extraction; local bundle branch/head; four paths passed; products both run; staging retained' ($r.Exit-eq0-and$r.Stage-and$r.Output.Contains('status=completed')-and$r.Output.Contains((Join-Path $r.Root 'stage'))-and@($r.Calls|Where-Object{$_-like'7z x *'}).Count-eq1-and$calls.Contains($r.Newer)-and$calls.Contains('repos\ORVION-Workbench.bundle')-and$calls.Contains('checkout --quiet -B recovery-branch '+('a'*40))-and$calls.Contains('-From ')-and$calls.Contains('-Target ')-and$calls.Contains('-ClaudeHome ')-and$calls.Contains('-LegacyTarget ')-and$calls.Contains('-CodexHome ')-and$calls.Contains('CRM\workstation.cmd')-and$calls.Contains('ORVION\workstation.cmd')-and$calls-notmatch'winget install')
    $r=Invoke-Scenario no-winget
    Assert-That 'installed prerequisites need no winget lookup; READY is final' ($r.Exit-eq0-and($r.Calls-join' ')-notmatch'lookup winget'-and($r.Output.Trim()-split"`n")[-1]-match'^READY: ')
    foreach($caseName in 'under-Target','under-ClaudeHome','under-CodexHome','under-LegacyTarget','equal-stage','alias-stage'){
        $r=Invoke-Scenario $caseName
        Assert-That "persistent destination guard $caseName precedes all installers and extraction" ($r.Exit-ne0-and$r.Output-match'RECOVERY_DESTINATION_IN_STAGING'-and$r.Calls.Count-le1-and$r.Output-notmatch'(?m)^READY: ')
    }
    $r=Invoke-Scenario default-stage
    Assert-That 'default staging is an owned UTC+GUID child of temporary restore-staging' ($r.Exit-eq0-and($r.Calls-join' ')-match'ORVION-Workbench-temporary\\restore-staging\\[0-9]+T[0-9]+Z-[a-f0-9]{32}'-and@(Get-ChildItem (Join-Path $r.Root 'target/ORVION-Workbench-temporary/restore-staging') -ErrorAction SilentlyContinue).Count-eq1)
    foreach($caseName in 'placement-repo','placement-data','placement-profile-home','placement-owner-other','placement-git','placement-sync','placement-sync-alias'){
        $r=Invoke-Scenario $caseName
        Assert-That "retained placement $caseName refused before extraction" ($r.Exit-ne0-and$r.Output-match'RECOVERY_STAGING_PLACEMENT_REFUSED'-and($r.Calls-join' ')-notmatch'7z x'-and$r.Output-notmatch'(?m)^READY: ')
    }
    foreach($pair in @(@('disk-metadata','METADATA_UNREADABLE'),@('disk-empty','METADATA_UNREADABLE'),@('disk-negative','METADATA_UNREADABLE'),@('disk-overflow','METADATA_UNREADABLE'),@('disk-list-exit','METADATA_UNREADABLE'),@('disk-insufficient','SPACE_INSUFFICIENT'),@('disk-unreadable','SPACE_UNREADABLE'))){
        $r=Invoke-Scenario $pair[0]
        Assert-That "pre-extraction disk refusal $($pair[0])" ($r.Exit-ne0-and!$r.Stage-and$r.Output.Contains('RECOVERY_DISK_'+$pair[1])-and($r.Calls-join' ')-notmatch'7z x'-and$r.Output-notmatch'(?m)^READY: ')
        if($pair[0]-eq'disk-list-exit'){Assert-That 'metadata child exit 31 preserved' ($r.Exit-eq31)}
    }
    $r=Invoke-Scenario long-retained
    Assert-That "native $($PSVersionTable.PSVersion) locked readonly path $($r.LongLength) bytes/attributes retained; outside unchanged; READY" ($r.Exit-eq0-and$r.Stage-and$r.LongOk-and$r.LongLength-ge450-and$r.OutsideOk-and$r.Output-match'(?m)^READY: '-and$r.Output-match'status=completed'-and$r.Output-notmatch'CLEANUP_SEAM_CALLED')
    Assert-That 'launcher has no automatic recursive cleanup or attribute mutation' ($source-notmatch'Directory\]::Delete|Remove-Item|Remove-RecoveryStaging|Attributes\s*=|SetAttributes|-Recurse')
    $r=Invoke-Scenario repeat-default
    Assert-That 'two default attempts retain distinct paths and first tree bytes/attributes unchanged' ($r.Exit-eq0-and$r.RepeatKept-and@(Get-ChildItem (Join-Path $r.Root 'target/ORVION-Workbench-temporary/restore-staging') -Directory).Count-eq2)
    $r=Invoke-Scenario reuse-success
    Assert-That 'explicit successful staging reuse refused without tree alteration or second extraction' ($r.ReusedRefused-and$r.Stage-and@($r.Calls|Where-Object{$_-like'7z x *'}).Count-eq1)
    $r=Invoke-Scenario relative-stage
    Assert-That 'relative staging uses PowerShell location and reports absolute path' ($r.Exit-eq0-and(Test-Path (Join-Path $r.Root 'relative-stage'))-and$r.Output.Contains((Join-Path $r.Root 'relative-stage')))
    $r=Invoke-Scenario default-legacy
    Assert-That 'launcher does not opt into legacy restore by default' ($r.Exit-eq0-and($r.Calls-join' ')-notmatch'-LegacyTarget')
    $r=Invoke-Scenario success
    Assert-That 'successful restore runs narrow rebuild then hourly map installation' (($r.Calls-join' ')-match'Restore-Workspace.ps1 -Temporary -Target .*Map-Repos.ps1 -Install -GitHub')
    foreach($caseName in 'temporary','map','claude-list-fail','exception','checklist-exception'){
        $r=Invoke-Scenario $caseName
        Assert-That "late failure $caseName withholds READY, retains staging and masks exceptions" ($r.Exit-ne0-and($r.Stage-or$caseName-eq'exception')-and$r.Output-notmatch'(?m)^READY: |sensitive-.*fixture'-and$r.Output-match'ACTION: ')
    }
    $needle="throw 'RECOVERY_DESTINATION_IN_STAGING'"
    if(!$source.Contains($needle)){throw 'MUTANT_ANCHOR_MISSING destination'}
    $r=Invoke-Scenario under-ClaudeHome ($source.Replace($needle,"Write-Host 'guard removed'"))
    Assert-That 'MUTANT killed: persistent destination under staging accepted' ($r.Exit-eq0-and($r.Calls-join' ')-match'7z x')
    $needle="if(`$script:RecoveryExit-eq0){Write-Host 'READY: restore and requested preparation completed'}"
    if(!$source.Contains($needle)){throw 'MUTANT_ANCHOR_MISSING READY'}
    $r=Invoke-Scenario claude-list-fail ($source.Replace($needle,"Write-Host 'READY: mutant'"))
    Assert-That 'MUTANT killed: READY after late failure' ($r.Exit-ne0-and$r.Output-match'(?m)^READY: ')
    $r=Invoke-Scenario install-success;$calls=$r.Calls-join"`n"
    Assert-That 'missing prerequisites only: exact three winget ids/flags; refresh PATH after each; verify commands' ($r.Exit-eq0-and@($r.Calls|Where-Object{$_-eq'refresh-path'}).Count-eq3-and@($r.Calls|Where-Object{$_-like'winget install *'}).Count-eq3-and$calls.Contains('Git.Git --exact --source winget --accept-source-agreements --accept-package-agreements')-and$calls.Contains('7zip.7zip --exact --source winget --accept-source-agreements --accept-package-agreements')-and$calls.Contains('Microsoft.PowerShell --exact --source winget --accept-source-agreements --accept-package-agreements'))
    $r=Invoke-Scenario allow-profile;Assert-That 'explicit profile override prints manual repair step and restores' ($r.Exit-eq0-and$r.Output.Contains('repair absolute hooks'))
    $r=Invoke-Scenario skip-products;Assert-That 'SkipProducts avoids both product entries' ($r.Exit-eq0-and($r.Calls-join' ')-notmatch'workstation.cmd')
    foreach($caseName in 'product','product-missing'){$r=Invoke-Scenario $caseName;Assert-That "$caseName records failure and still runs ORVION; restored files retained" ($r.Exit-ne0-and$r.Stage-and$r.Output-notmatch'(?m)^READY: '-and($r.Calls-join' ').Contains('ORVION\workstation.cmd')-and(Test-Path (Join-Path $r.Root 'target\ORVION\workstation.cmd')))}
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
    $body='param($From,$Target,$ClaudeHome,$LegacyTarget,$CodexHome,[switch]$Temporary) if($Temporary){exit 0}; if(!(Test-Path (Join-Path $From "backup.json")) -or !$Target -or !$ClaudeHome -or !$LegacyTarget -or !$CodexHome){exit 44}; [void][IO.Directory]::CreateDirectory((Join-Path $Target "ORVION-Workbench/lib")); [IO.File]::WriteAllText((Join-Path $Target "ORVION-Workbench/lib/Restore-Workspace.ps1"),"param([switch]`$Temporary,`$Target) exit 0"); [IO.File]::WriteAllText((Join-Path $Target "ORVION-Workbench/lib/Map-Repos.ps1"),"param([switch]`$Install,`$GitHub) exit 0"); Write-Output "REAL_CHILD_OUTPUT"; if($Target -like "*child-failure*"){exit 42}; exit 0'
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
        Assert-That "real 7z/local git/detached checkout/pwsh child under $engine (exit $code)" ($code-eq0-and($out-join' ').Contains('REAL_CHILD_OUTPUT')-and(Test-Path $stage)-and($out-join' ')-match'status=completed')
        if($code){$out|Select-Object -Last 12}
        $stage=Join-Path $t ('real-failure-'+[guid]::NewGuid().ToString('N').Substring(0,5))
        $out=@(& $engine -NoProfile -File $harness (Join-Path $PSScriptRoot 'Restore-ORVION.ps1') $zip $git $pwsh $cloud $stage (Join-Path $t 'child-failure') 2>&1);$code=$LASTEXITCODE
        Assert-That "real restore child failure under $engine preserves output, exit 42 and staging" ($code-eq42-and($out-join' ').Contains('REAL_CHILD_OUTPUT')-and($out-join' ').Contains('staging retained')-and(Test-Path $stage))
    }
    $cmd=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Restore-ORVION.cmd'))
    Assert-That 'cmd forwards arguments, always pauses after capturing exit, and returns captured code' ($cmd.Contains('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Restore-ORVION.ps1" %*')-and$cmd-match'(?s)set "ORVION_EXIT=%ERRORLEVEL%"\r?\npause\r?\nexit /b %ORVION_EXIT%')
}finally{
    $env:USERPROFILE=$savedProfile;$env:GIT_CONFIG_GLOBAL=$savedGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedSystem
    foreach($key in $savedInjection.Keys){[Environment]::SetEnvironmentVariable($key,$savedInjection[$key],'Process')}
    # Test-owned disposal only. The existing pwsh prerequisite handles long fixture paths.
    $cleanup=Join-Path ([IO.Path]::GetTempPath()) ('fixture-cleanup-'+[guid]::NewGuid().ToString('N')+'.ps1')
    $cleanupBody=@'
param($Fixture,$TempBoundary)
$ErrorActionPreference='Stop'
$full=[IO.Path]::GetFullPath($Fixture);$boundary=[IO.Path]::GetFullPath($TempBoundary).TrimEnd('\')+'\'
if(!$full.StartsWith($boundary,[StringComparison]::OrdinalIgnoreCase)-or((Get-Item -LiteralPath $full -Force).Attributes-band[IO.FileAttributes]::ReparsePoint)){throw 'FIXTURE_CLEANUP_REFUSED'}
Get-ChildItem -LiteralPath $full -Recurse -Force -Attributes ReparsePoint|ForEach-Object{[IO.Directory]::Delete($_.FullName,$false)}
Get-ChildItem -LiteralPath $full -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'}
[IO.Directory]::Delete($full,$true)
'@
    [IO.File]::WriteAllText($cleanup,$cleanupBody,[Text.Encoding]::ASCII)
    try{& (Get-Command pwsh -CommandType Application|Select-Object -First 1).Source -NoProfile -File $cleanup $t ([IO.Path]::GetTempPath().TrimEnd('\'));if($LASTEXITCODE){throw 'FIXTURE_CLEANUP_FAILED'}}finally{[IO.File]::Delete($cleanup)}
}
if($fail){throw "RESTORE_ORVION_SELFCHECK_FAILED $fail"};'RESTORE_ORVION_SELFCHECK PASS'
