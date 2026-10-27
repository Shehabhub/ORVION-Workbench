# Real local layout and Git-for-Windows hook callers; all data and mutants are disposable fixtures.
param([ValidateSet('all','nested','hook','temporary')][string]$Probe='all',
      [string]$Resolver=(Join-Path $PSScriptRoot 'workspace-layout.ps1'),
      [string]$Hook=(Join-Path (Split-Path $PSScriptRoot -Parent) '.githooks/pre-commit'),[switch]$NoMutants)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$scratchParent=[IO.Path]::GetTempPath()
$scratch=Join-Path $scratchParent ('orvion-layout-'+[guid]::NewGuid().ToString('N').Substring(0,8))
[void][IO.Directory]::CreateDirectory($scratch)
$savedEnvironment=@{}
foreach($key in 'TEMP','TMP','TMPDIR','WORKBENCH_TEMP_ROOT','ORVION_DATA_ROOT','GITHUB_ACTIONS','RUNNER_TEMP','ORVION_STANDALONE_TEMP','GIT_CONFIG_GLOBAL','GIT_CONFIG_NOSYSTEM'){
    $savedEnvironment[$key]=[Environment]::GetEnvironmentVariable($key,'Process')
}
$fail=0
function Assert-Layout([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{$script:fail++;"FAIL $Name"}}
function Write-LayoutFile([string]$Path,[string]$Text){
    [void][IO.Directory]::CreateDirectory((Split-Path $Path -Parent))
    [IO.File]::WriteAllText($Path,$Text,[Text.UTF8Encoding]::new($false))
}
function Invoke-LayoutChild([string]$Executable,[string[]]$Arguments,[hashtable]$Environment=@{},[string]$Directory=$scratch){
    $info=[Diagnostics.ProcessStartInfo]::new($Executable)
    $info.WorkingDirectory=$Directory;$info.UseShellExecute=$false;$info.CreateNoWindow=$true
    $info.RedirectStandardOutput=$true;$info.RedirectStandardError=$true;$info.RedirectStandardInput=$true
    foreach($key in $Environment.Keys){if($null-eq$Environment[$key]){$null=$info.Environment.Remove($key)}else{$info.Environment[$key]=$Environment[$key]}}
    foreach($argument in $Arguments){$info.ArgumentList.Add($argument)}
    $child=[Diagnostics.Process]::new();$child.StartInfo=$info
    try{
        $null=$child.Start();$child.StandardInput.Close();$stdout=$child.StandardOutput.ReadToEndAsync();$stderr=$child.StandardError.ReadToEndAsync()
        if(!$child.WaitForExit(30000)){$child.Kill($true);$child.WaitForExit();throw 'LAYOUT_CHILD_TIMEOUT'}
        [pscustomobject]@{Exit=$child.ExitCode;Text=$stdout.GetAwaiter().GetResult()+$stderr.GetAwaiter().GetResult()}
    }finally{$child.Dispose()}
}
function Invoke-LayoutGit([string]$Directory,[string[]]$Arguments){
    $result=Invoke-LayoutChild $script:gitExe (@('-C',$Directory)+$Arguments)
    if($result.Exit){throw ('LAYOUT_FIXTURE_GIT_FAILED: '+$result.Text)}
    $result.Text.Trim()
}
function Test-TemporaryLayout([string]$Name,[string]$Checkout,[string]$Expected,[hashtable]$Options=@{}){
    $Expected=[IO.Path]::GetFullPath($Expected)
    [void][IO.Directory]::CreateDirectory($Checkout)
    $previousTemp=$env:TEMP;$previousTmp=$env:TMP
    try{
        # A refusal is a named FAIL of this case, never a crash that hides which case broke.
        try{$resolved=Initialize-OrvionTemporaryRoot -Checkout $Checkout @Options}catch{Assert-Layout "$Name ($($_.Exception.Message))" $false;return}
        $expectedTemp=Join-Path $Expected 'tmp'
        $child=Invoke-LayoutChild 'pwsh' @('-NoProfile','-Command','[ordered]@{temp=$env:TEMP;tmp=$env:TMP;api=[IO.Path]::GetTempPath().TrimEnd([char]92)}|ConvertTo-Json -Compress')
        $observed=$child.Text|ConvertFrom-Json
        Assert-Layout $Name ($resolved-ieq$Expected-and$env:TEMP-ieq$expectedTemp-and$env:TMP-ieq$expectedTemp-and$child.Exit-eq0-and$observed.temp-ieq$expectedTemp-and$observed.tmp-ieq$expectedTemp-and$observed.api-ieq$expectedTemp)
    }finally{$env:TEMP=$previousTemp;$env:TMP=$previousTmp}
}
try{
    foreach($key in 'WORKBENCH_TEMP_ROOT','ORVION_DATA_ROOT','GITHUB_ACTIONS','RUNNER_TEMP','ORVION_STANDALONE_TEMP'){
        [Environment]::SetEnvironmentVariable($key,$null,'Process')
    }
    $env:TEMP=$scratch;$env:TMP=$scratch
    $env:GIT_CONFIG_GLOBAL=Join-Path $scratch 'empty.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
    . $Resolver
    $gitExe=(Get-Command git -CommandType Application|Select-Object -First 1).Source
    if($Probe-in'all','nested'){
        $temporary=Join-Path $scratch 'space layout/ORVION-Workbench-temporary'
        Test-TemporaryLayout 'nested sandbox stays under temporary' (Join-Path $temporary 'sb/WS-022/c') $temporary
        Test-TemporaryLayout 'nested cx stays under temporary' (Join-Path $temporary 'cx/ORVION-task') $temporary
    }
    if($Probe-eq'all'){
        $installed=Join-Path $scratch 'installed/ORVION-Workbench'
        Test-TemporaryLayout 'installed checkout uses sibling temporary' $installed (Join-Path (Split-Path $installed -Parent) 'ORVION-Workbench-temporary')
        $explicit=Join-Path $scratch 'context temp'
        Test-TemporaryLayout 'explicit context wins over nested layout and target' (Join-Path $temporary 'sb/WS-022/rehearsal') $explicit @{TemporaryRoot=$explicit;Target=(Join-Path $scratch 'other target')}
        $target=Join-Path $scratch 'restore target'
        Test-TemporaryLayout 'explicit restore target wins over executing checkout' $installed (Join-Path $target 'ORVION-Workbench-temporary') @{Target=$target}
        $broken=Join-Path $scratch 'broken checkout';[void][IO.Directory]::CreateDirectory($broken)
        $failure=try{$null=Initialize-OrvionTemporaryRoot -Checkout $broken;''}catch{$_.Exception.Message}
        Assert-Layout 'broken local layout refuses without system-temp fallback' ($failure-ceq'WB_TEMP_LAYOUT_UNAVAILABLE')
        foreach($bad in @(@{TemporaryRoot='relative'},@{Target='relative'},@{TemporaryRoot=(Join-Path $broken 'tmp')})){
            $failure=try{$null=Initialize-OrvionTemporaryRoot -Checkout $broken @bad;''}catch{$_.Exception.Message}
            Assert-Layout 'invalid explicit temporary selection refuses' ($failure-match'^WB_TEMP_(ROOT_NOT_ABSOLUTE|TARGET_NOT_ABSOLUTE|ROOT_INSIDE_CHECKOUT_REFUSED)$')
        }
        $env:RUNNER_TEMP=Join-Path $scratch 'runner'
        Test-TemporaryLayout 'hosted runner explicitly permits temporary storage' $broken (Join-Path $env:RUNNER_TEMP 'ORVION-Workbench')
        $env:RUNNER_TEMP=$null;$env:GITHUB_ACTIONS='true'
        Test-TemporaryLayout 'GitHub Actions explicitly permits system temp' $broken (Join-Path $scratch 'ORVION-Workbench')
        $env:GITHUB_ACTIONS=$null;$env:ORVION_STANDALONE_TEMP='1'
        Test-TemporaryLayout 'standalone opt-in permits system temp' $broken (Join-Path $scratch 'ORVION-Workbench')
        $env:ORVION_STANDALONE_TEMP=$null

    }
    if($Probe-in'all','temporary'){
        # Pin equality against the actual accepted judge definitions, without executing its entrypoint.
        $judgePath=Join-Path $PSScriptRoot 'Test-WorkbenchChange.ps1'
        $tokens=$null;$errors=$null;$judge=[Management.Automation.Language.Parser]::ParseFile($judgePath,[ref]$tokens,[ref]$errors)
        foreach($name in 'Get-WorkbenchCITool','Get-WorkbenchWorkflowPolicy'){
            $fn=$judge.Find({param($n)$n-is[Management.Automation.Language.FunctionDefinitionAst]-and$n.Name-eq$name},$false)
            . ([scriptblock]::Create($fn.Extent.Text))
        }
        $accepted=Get-WorkbenchCITool;$pin=Get-OrvionTemporaryTool
        $policy=Get-WorkbenchWorkflowPolicy
        $provision=$policy.jobs['workbench-acceptance'].steps[1].run
        Assert-Layout 'temporary actionlint matches judge version, archive hash, exe hash and exact URL' ($pin.Version-ceq$accepted.Version-and$pin.ArchiveSHA256-ceq$accepted.ArchiveSHA256-and$pin.SHA256-ceq$accepted.SHA256-and$provision.Contains("Invoke-WebRequest -Uri '"+$pin.Url+"' -OutFile"))
        $fakeArchive=Join-Path $scratch 'fake-actionlint.zip'
        $zip=[IO.Compression.ZipFile]::Open($fakeArchive,'Create')
        try{$entry=$zip.CreateEntry('actionlint.exe');$writer=[IO.StreamWriter]::new($entry.Open());try{$writer.Write('fake executable bytes')}finally{$writer.Dispose()}}finally{$zip.Dispose()}
        $fakeExe=Join-Path $scratch 'fake.exe';[IO.File]::WriteAllText($fakeExe,'fake executable bytes',[Text.UTF8Encoding]::new($false))
        $fakePin=@{Version='1.7.12';Url='fixture://local';ArchiveSHA256=(Get-FileHash $fakeArchive).Hash;SHA256=(Get-FileHash $fakeExe).Hash}
        function Get-OrvionTemporaryTool {$fakePin}
        $script:downloads=0;$script:interrupt=$false
        function Receive-OrvionTemporaryTool([string]$Uri,[string]$OutFile){
            $script:downloads++
            Copy-Item -LiteralPath $fakeArchive -Destination $OutFile
            if($script:interrupt){throw 'FIXTURE_INTERRUPTED'}
        }
        function Test-TemporaryProvision([string]$Name,[string]$Root=(Join-Path $scratch $Name)){
            try{$null=Restore-OrvionTemporary $Root;$errorText=''}catch{$errorText=$_.Exception.Message}
            $tree=Join-Path $Root 'ORVION-Workbench-temporary'
            [pscustomobject]@{Error=$errorText;Root=$Root;Tree=$tree;Exe=(Join-Path $tree 'tools/actionlint.exe');Half=@(Get-ChildItem -LiteralPath (Join-Path $tree 'tools') -Filter '.provision-*' -ErrorAction SilentlyContinue).Count}
        }
        $rebuilt=Test-TemporaryProvision 'narrow rebuild'
        Assert-Layout 'narrow rebuild publishes verified executable at temporary/tools only' (!$rebuilt.Error-and(Get-FileHash $rebuilt.Exe).Hash-ceq$fakePin.SHA256-and$rebuilt.Half-eq0-and@(Get-ChildItem $rebuilt.Root).Count-eq1)
        $before=$downloads;$again=Test-TemporaryProvision 'narrow rebuild'
        Assert-Layout 'second temporary rebuild is idempotent without another download' (!$again.Error-and$downloads-eq$before-and$again.Half-eq0)
        [IO.File]::WriteAllText($rebuilt.Exe,'corrupt existing')
        $corrupt=Test-TemporaryProvision 'narrow rebuild'
        Assert-Layout 'corrupt existing executable refused without replacement' ($corrupt.Error-ceq'WB_TEMP_TOOL_IDENTITY'-and[IO.File]::ReadAllText($rebuilt.Exe)-ceq'corrupt existing'-and$downloads-eq$before)
        $expectedArchive=$fakePin.ArchiveSHA256;$fakePin.ArchiveSHA256='A'*64
        $badArchive=Test-TemporaryProvision 'bad archive';$fakePin.ArchiveSHA256=$expectedArchive
        Assert-Layout 'archive identity checked before extraction with no half tool' ($badArchive.Error-ceq'WB_TEMP_ARCHIVE_IDENTITY'-and!(Test-Path $badArchive.Exe)-and$badArchive.Half-eq0)
        $expectedExe=$fakePin.SHA256;$fakePin.SHA256='B'*64
        $badExe=Test-TemporaryProvision 'bad exe';$fakePin.SHA256=$expectedExe
        Assert-Layout 'executable identity checked after extraction with no half tool' ($badExe.Error-ceq'WB_TEMP_TOOL_IDENTITY'-and!(Test-Path $badExe.Exe)-and$badExe.Half-eq0)
        $script:interrupt=$true;$interrupted=Test-TemporaryProvision 'interrupted';$script:interrupt=$false
        Assert-Layout 'interrupted download cleans owned staging and leaves no executable' ($interrupted.Error-ceq'FIXTURE_INTERRUPTED'-and!(Test-Path $interrupted.Exe)-and$interrupted.Half-eq0)
        $retry=Test-TemporaryProvision 'interrupted'
        Assert-Layout 'interrupted provisioning can be retried' (!$retry.Error-and(Test-Path $retry.Exe))
        $originalArchive=$fakeArchive;$originalArchiveHash=$fakePin.ArchiveSHA256
        foreach($entryNames in @(@('../actionlint.exe'),@('actionlint.exe','actionlint.exe'))){
            $fakeArchive=Join-Path $scratch ('invalid-entries-'+$entryNames.Count+'.zip')
            $zip=[IO.Compression.ZipFile]::Open($fakeArchive,'Create')
            try{foreach($name in $entryNames){$entry=$zip.CreateEntry($name);$writer=[IO.StreamWriter]::new($entry.Open());try{$writer.Write('fake executable bytes')}finally{$writer.Dispose()}}}finally{$zip.Dispose()}
            $fakePin.ArchiveSHA256=(Get-FileHash $fakeArchive).Hash
            $invalidEntry=Test-TemporaryProvision ('invalid entries '+$entryNames.Count)
            Assert-Layout ('invalid or duplicate actionlint archive entries refused: '+$entryNames.Count) ($invalidEntry.Error-ceq'WB_TEMP_TOOL_ENTRY_INVALID'-and!(Test-Path $invalidEntry.Exe)-and$invalidEntry.Half-eq0)
        }
        $fakeArchive=$originalArchive;$fakePin.ArchiveSHA256=$originalArchiveHash
        # Test the actual -Temporary entry with fake archive transport. All client/data homes are absent.
        $entryLib=Join-Path $scratch 'narrow entry/lib';[void][IO.Directory]::CreateDirectory($entryLib)
        Copy-Item (Join-Path $PSScriptRoot 'Restore-Workspace.ps1') $entryLib
        $fakeSuffix="`nfunction Get-OrvionTemporaryTool { @{Version='1.7.12';Url='fixture://local';ArchiveSHA256='"+$fakePin.ArchiveSHA256+"';SHA256='"+$fakePin.SHA256+"'} }`nfunction Receive-OrvionTemporaryTool([string]`$Uri,[string]`$OutFile){ Copy-Item -LiteralPath '"+$fakeArchive.Replace("'","''")+"' -Destination `$OutFile }`n"
        Write-LayoutFile (Join-Path $entryLib 'workspace-layout.ps1') ([IO.File]::ReadAllText($Resolver)+$fakeSuffix)
        $entryTarget=Join-Path $scratch 'entry target'
        $entryResult=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $entryLib 'Restore-Workspace.ps1'),'-Temporary','-Target',$entryTarget) @{USERPROFILE=(Join-Path $scratch 'absent-profile');ORVION_DATA_ROOT=(Join-Path $scratch 'absent-data');PATH=$env:PATH}
        if($entryResult.Exit){'TEMPORARY_ENTRY_DIAGNOSTIC: '+$entryResult.Text}
        Assert-Layout 'actual Temporary entry needs no package, journal, sessions, client homes or credentials' ($entryResult.Exit-eq0-and(Test-Path (Join-Path $entryTarget 'ORVION-Workbench-temporary/tools/actionlint.exe'))-and@(Get-ChildItem $entryTarget).Count-eq1-and!(Test-Path (Join-Path $scratch 'absent-profile/.claude'))-and!(Test-Path (Join-Path $scratch 'absent-profile/.codex'))-and!(Test-Path (Join-Path $scratch 'absent-data')))
        if(!$NoMutants){
            $layoutBytes=[IO.File]::ReadAllText($Resolver)
            $anchor="if((Get-FileHash -LiteralPath `$candidate).Hash-cne`$tool.SHA256){throw 'WB_TEMP_TOOL_IDENTITY'}"
            if(!$layoutBytes.Contains($anchor)){throw 'LAYOUT_MUTANT_STALE: exe identity'}
            $mutantLayout=Join-Path $scratch 'mutants/tool-layout.ps1'
            Write-LayoutFile $mutantLayout ($layoutBytes.Replace($anchor,'# mutant removed executable check')+$fakeSuffix)
            . $mutantLayout
            $mutantFakePin=Get-OrvionTemporaryTool
            $fakeSuffixBad=$fakeSuffix.Replace($mutantFakePin.SHA256,('B'*64))
            Write-LayoutFile $mutantLayout ($layoutBytes.Replace($anchor,'# mutant removed executable check')+$fakeSuffixBad)
            . $mutantLayout
            $mutated=Test-TemporaryProvision 'mutant unchecked exe'
            Assert-Layout 'MUTANT KILLED: executable hash check removed' (!$mutated.Error-and(Test-Path $mutated.Exe))
            $anchor="'tools/actionlint.exe'"
            if(!$layoutBytes.Contains($anchor)){throw 'LAYOUT_MUTANT_STALE: legacy tool path'}
            Write-LayoutFile $mutantLayout ($layoutBytes.Replace($anchor,"'actionlint.exe'")+$fakeSuffix)
            . $mutantLayout
            $mutated=Test-TemporaryProvision 'mutant legacy path'
            Assert-Layout 'MUTANT KILLED: legacy actionlint path used' (!$mutated.Error-and!(Test-Path $mutated.Exe)-and(Test-Path (Join-Path $mutated.Tree 'actionlint.exe')))
            . $Resolver
        }

    }
    if($Probe-eq'all'){
        # An empty synthetic checkout must never become the implicit data store.
        $dataCheckout=Join-Path $scratch 'data/ORVION-Workbench';$dataLib=Join-Path $dataCheckout 'lib'
        [void][IO.Directory]::CreateDirectory((Join-Path $dataLib 'hooks'))
        Copy-Item (Join-Path $PSScriptRoot 'Events.ps1'),(Join-Path $PSScriptRoot 'Sync-Sessions.ps1'),(Join-Path $PSScriptRoot 'Backup-Workspace.ps1'),$Resolver $dataLib
        Copy-Item (Join-Path $PSScriptRoot 'hooks/Watch-Reminder.ps1') (Join-Path $dataLib 'hooks')
        $reader=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $dataLib 'Events.ps1'),'-Brief')
        $writer=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $dataLib 'Events.ps1'),'-Add','-Pattern','fixture','-Summary','fixture')
        $backupDestination=Join-Path $scratch 'refused backup'
        $backup=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $dataLib 'Backup-Workspace.ps1'),'-Destination',$backupDestination,'-AllowUnencrypted')
        $hookFailure=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $dataLib 'hooks/Watch-Reminder.ps1')) # EOF is invalid input
        Assert-Layout 'missing data readers report UNAVAILABLE and writers refuse stable code' ($reader.Exit-eq3-and$reader.Text-match'EVENTS_UNAVAILABLE'-and$writer.Exit-ne0-and$writer.Text-match'ORVION_DATA_ROOT_UNAVAILABLE'-and$backup.Exit-ne0-and$backup.Text-match'ORVION_DATA_ROOT_UNAVAILABLE')
        Assert-Layout 'missing data and hook failure create no checkout work or backup' ($hookFailure.Exit-eq0-and$hookFailure.Text-match'ORVION_DATA_ROOT_UNAVAILABLE'-and!(Test-Path (Join-Path $dataCheckout 'work'))-and!(Test-Path (Join-Path $dataCheckout 'events'))-and!(Test-Path $backupDestination))
        foreach($dataCase in @(
            @('Pulse',@()),@('Spider',@('fixture')),@('Coordinator',@('-Brief')),
            @('Delegate',@('-List')),@('Hunt',@('-Quick','-NoRecord')),
            @('Sync-Sessions',@('-Quiet')),@('Watch-Subagents',@('-Session','fixture','-Once'))
        )){
            $tool=$dataCase[0];Copy-Item (Join-Path $PSScriptRoot ($tool+'.ps1')) $dataLib
            $missing=Invoke-LayoutChild 'pwsh' (@('-NoProfile','-File',(Join-Path $dataLib ($tool+'.ps1')))+$dataCase[1])
            $expectedExit=if($tool-in'Pulse','Spider','Coordinator','Delegate'){3}else{1}
            Assert-Layout ("missing default data: $tool refuses before any checkout write") ($missing.Exit-eq$expectedExit-and$missing.Text-match'ORVION_DATA_ROOT_UNAVAILABLE'-and!(Test-Path (Join-Path $dataCheckout 'work'))-and!(Test-Path (Join-Path $dataCheckout 'events')))
        }
        $override=Join-Path $scratch 'override data'
        $explicitWrite=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $dataLib 'Events.ps1'),'-Add','-Pattern','override','-Summary','fixture') @{ORVION_DATA_ROOT=$override}
        Assert-Layout 'absolute data override still initializes an explicit store' ($explicitWrite.Exit-eq0-and(Test-Path (Join-Path $override 'events/events.jsonl')))
    }
    if($Probe-in'all','hook'){
        $hookTemporary=Join-Path $scratch 'hook space/ORVION-Workbench-temporary'
        $hookCheckout=Join-Path $hookTemporary 'sb/WS-022/c'
        [void][IO.Directory]::CreateDirectory($hookCheckout)
        $null=Invoke-LayoutGit $hookCheckout @('init','--quiet','-b','main')
        $checker=@'
param([string]$Root,[string]$Mode,[switch]$Staged,[string]$Base)
[ordered]@{temp=$env:TEMP;tmp=$env:TMP;script=$PSCommandPath}|ConvertTo-Json -Compress|Set-Content -LiteralPath (Join-Path $Root '.git/judge.json')
exit 0
'@
        Write-LayoutFile (Join-Path $hookCheckout 'lib/Test-WorkbenchChange.ps1') ($checker.Replace("`r`n","`n")+[char]10)
        Write-LayoutFile (Join-Path $hookCheckout '.githooks/pre-commit') ([IO.File]::ReadAllText($Hook).Replace("`r`n","`n"))
        $null=Invoke-LayoutGit $hookCheckout @('add','lib/Test-WorkbenchChange.ps1')
        # Fixture-only accepted HEAD; no commit is made in the prototype checkout.
        $null=Invoke-LayoutGit $hookCheckout @('-c','user.name=Fixture','-c','user.email=fixture@invalid.local','-c','core.hooksPath=DISABLED','commit','--quiet','-m','fixture accepted checker')
        $unmanaged=Join-Path $scratch 'unmanaged';[void][IO.Directory]::CreateDirectory($unmanaged)
        $hookEnvironment=@{TMPDIR=$null;WORKBENCH_TEMP_ROOT=$null;WS022_UNMANAGED_ROOT=$unmanaged.Replace('\','/')}
        $hookArguments=@('-C',$hookCheckout,'-c','core.hooksPath=.githooks','hook','run','pre-commit')
        $result=Invoke-LayoutChild $gitExe $hookArguments $hookEnvironment $hookCheckout
        $observation=Join-Path $hookCheckout '.git/judge.json'
        $observed=if(Test-Path $observation){Get-Content -LiteralPath $observation -Raw|ConvertFrom-Json}
        $expected=Join-Path $hookTemporary 'tmp'
        Assert-Layout 'hook uses managed temp with absent TMPDIR and spaces via real Git sh' ($result.Exit-eq0-and$observed-and$observed.temp-ieq$expected-and$observed.tmp-ieq$expected-and[IO.Path]::GetDirectoryName($observed.script)-ieq$expected)
        Assert-Layout 'hook trap removes accepted judge' (@(Get-ChildItem -LiteralPath $expected -Filter 'workbench-judge-*').Count-eq0)
        if($Probe-eq'all'){
            Copy-Item (Join-Path $PSScriptRoot 'Workbench.ps1'),$Resolver (Join-Path $hookCheckout 'lib')
            $entry=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',(Join-Path $hookCheckout 'lib/Workbench.ps1'),'-Boot')
            $entryObserved=Get-Content -LiteralPath $observation -Raw|ConvertFrom-Json
            if($entry.Exit-ne0){'LAYOUT_ENTRY_DIAGNOSTIC: '+$entry.Text}
            Assert-Layout 'Workbench sets child TEMP and TMP for a nested clone before accepted dispatch' ($entry.Exit-eq0-and$entryObserved.temp-ieq$expected-and$entryObserved.tmp-ieq$expected-and[IO.Path]::GetDirectoryName($entryObserved.script)-ieq(Join-Path $hookTemporary 'judges')-and!(Test-Path -LiteralPath $entryObserved.script))
        }
        $blocker=Join-Path $scratch 'blocked root';Write-LayoutFile $blocker 'file'
        $blocked=Invoke-LayoutChild $gitExe $hookArguments @{WORKBENCH_TEMP_ROOT=$blocker;TMPDIR=$null} $hookCheckout
        Assert-Layout 'hook refuses failed temporary directory materialization' ($blocked.Exit-ne0-and$blocked.Text-match'WB_TEMP_MATERIALIZATION_FAILED')
        # Fail git show after mktemp, while retaining the actual Git-for-Windows hook interpreter.
        $shimBin=Join-Path $scratch 'shim';$gitShell=$gitExe.Replace('\','/')
        Write-LayoutFile (Join-Path $shimBin 'git') ("#!/bin/sh`nif [ `"`$1`" = show ]; then printf partial; exit 1; fi`nexec `"$gitShell`" `"`$@`"`n")
        $shExe=Join-Path (Split-Path (Split-Path $gitExe -Parent) -Parent) 'usr/bin/sh.exe'
        $failedShow=Invoke-LayoutChild $shExe @('-c','PATH="$(cygpath -u "$WS022_SHIM"):$PATH"; export PATH; exec sh .githooks/pre-commit') @{TMPDIR=$null;WS022_SHIM=$shimBin.Replace('\','/');PATH=(Split-Path $shExe -Parent)+';'+$env:PATH} $hookCheckout
        Assert-Layout 'hook trap removes a partially materialized judge on git show failure' ($failedShow.Exit-ne0-and@(Get-ChildItem -LiteralPath $expected -Filter 'workbench-judge-*').Count-eq0)
    }
    if($Probe-eq'all'){
        # Finish's required Hunt in a sandbox clone: no data root beside it -> empty disposable store, never the checkout.
        $huntClone=Join-Path $scratch 'hunt/sb/W22/rehearsal';[void][IO.Directory]::CreateDirectory($huntClone)
        $env:TEMP=$scratch;$env:TMP=$scratch;$env:ORVION_DATA_ROOT=$null
        $store=Get-OrvionFinishHuntDataRoot -Checkout $huntClone
        Assert-Layout 'Finish Hunt in a clone without a data root gets an empty disposable store outside the checkout' ($store-and$store.StartsWith($scratch,[StringComparison]::OrdinalIgnoreCase)-and!$store.StartsWith($huntClone,[StringComparison]::OrdinalIgnoreCase)-and(Test-Path (Join-Path $store 'events') -PathType Container)-and!(Get-ChildItem (Join-Path $store 'events') -Force))
        $installedHunt=Join-Path $scratch 'hunt-installed/ORVION-Workbench';[void][IO.Directory]::CreateDirectory((Join-Path $scratch 'hunt-installed/ORVION-Owner-Tools/events'));[void][IO.Directory]::CreateDirectory($installedHunt)
        Assert-Layout 'Finish Hunt beside a real data store keeps the default' ($null-eq(Get-OrvionFinishHuntDataRoot -Checkout $installedHunt))
        $env:ORVION_DATA_ROOT=$scratch
        Assert-Layout 'Finish Hunt with an explicit ORVION_DATA_ROOT keeps the default' ($null-eq(Get-OrvionFinishHuntDataRoot -Checkout $huntClone))
        $env:ORVION_DATA_ROOT=$null
    }
    if($Probe-eq'all'-and!$NoMutants){
        $resolverText=[IO.File]::ReadAllText($Resolver)
        $resolverAnchor='$temporary=$parent.Parent.Parent.FullName'
        if(!$resolverText.Contains($resolverAnchor)){throw 'LAYOUT_MUTANT_STALE: nested'}
        $mutantResolver=Join-Path $scratch 'mutants/workspace-layout.ps1'
        Write-LayoutFile $mutantResolver ($resolverText.Replace($resolverAnchor,"`$temporary=Join-Path ([IO.Path]::GetTempPath()) 'escaped'"))
        $nestedMutant=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',$PSCommandPath,'-Probe','nested','-Resolver',$mutantResolver,'-NoMutants')
        Assert-Layout 'MUTANT KILLED: nested clone falls outside temporary' ($nestedMutant.Exit-ne0-and$nestedMutant.Text-match'FAIL nested sandbox stays under temporary')
        $hookText=[IO.File]::ReadAllText($Hook);$hookAnchor='judge=$(mktemp "$managed/'
        if(!$hookText.Contains($hookAnchor)){throw 'LAYOUT_MUTANT_STALE: hook'}
        $mutantHook=Join-Path $scratch 'mutants/pre-commit'
        Write-LayoutFile $mutantHook ($hookText.Replace($hookAnchor,'judge=$(mktemp "$WS022_UNMANAGED_ROOT/'))
        $hookMutant=Invoke-LayoutChild 'pwsh' @('-NoProfile','-File',$PSCommandPath,'-Probe','hook','-Hook',$mutantHook,'-NoMutants')
        Assert-Layout 'MUTANT KILLED: hook ignores managed temp' ($hookMutant.Exit-ne0-and$hookMutant.Text-match'FAIL hook uses managed temp')
    }
}finally{
    foreach($key in $savedEnvironment.Keys){[Environment]::SetEnvironmentVariable($key,$savedEnvironment[$key],'Process')}
    $null=Remove-OrvionOwnedTree -Path $scratch -AllowedRoots @($scratchParent)
}
if($fail){throw "WORKSPACE_LAYOUT_FAILED: $fail"};'WORKSPACE_LAYOUT PASS'
