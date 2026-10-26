# Real Pulse caller on owned Git/journal fixtures. No product, real journal or credential writes.
# An explicit library permits causal mutants; it never changes production tool selection.
param([string]$Library=$PSScriptRoot,[switch]$OutputProbeOnly)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$pulseFailures=0
$pulseCompleted=$false
$pulsePath=Join-Path $Library 'Pulse.ps1'
$pulseTestParent=if($env:WORKBENCH_TEST_ROOT){[IO.Path]::GetFullPath($env:WORKBENCH_TEST_ROOT)}else{Join-Path ([IO.Path]::GetTempPath()) 'ORVION-Workbench'}
$pulseFixture=Join-Path $pulseTestParent ('pulse-'+[guid]::NewGuid().ToString('N').Substring(0,8))
[void][IO.Directory]::CreateDirectory($pulseFixture)
$savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
$env:GIT_CONFIG_GLOBAL=Join-Path $pulseFixture 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
$savedGitCeiling=$env:GIT_CEILING_DIRECTORIES;$env:GIT_CEILING_DIRECTORIES=$pulseFixture
$pulseRepository=Join-Path $pulseFixture 'native'
[void][IO.Directory]::CreateDirectory($pulseRepository)
[void][IO.Directory]::CreateDirectory((Join-Path $pulseFixture 'events'))
$pulseJournal=Join-Path $pulseFixture 'events/events.jsonl'
# Keep process/log discovery synthetic as well as the journal and repositories.
$pulseLauncher=Join-Path $pulseFixture 'invoke-pulse.ps1'
$pulseLaunchText=@'
param([string]$Pulse,[string]$Data,[string]$Repository)
function Get-CimInstance{param([string]$ClassName,[string]$Filter) if($ClassName-eq'Win32_OperatingSystem'){[pscustomobject]@{FreePhysicalMemory=1000000;FreeVirtualMemory=2000000}}}
if($Repository){& $Pulse -Root $Data -Repos $Repository}else{& $Pulse -Root $Data -Repos @()};exit $LASTEXITCODE
'@
[IO.File]::WriteAllText($pulseLauncher,$pulseLaunchText)
function Assert-PulseCheck([string]$label,[bool]$condition,[string]$detail=''){
    if($condition){"PASS $label"}else{$script:pulseFailures++;"FAIL $label";if($detail){$detail}}
}
function Read-PulseFixtureGit([string[]]$gitArguments){
    $gitLines=@(& git -C $pulseRepository @gitArguments 2>&1)
    if($LASTEXITCODE-ne0){throw 'PULSE_FIXTURE_GIT_FAILED'}
    $gitLines
}
function Invoke-PulseCheck([string]$selectedRepository=$pulseRepository){
    $pulseLines=@(& pwsh -NoProfile -File $pulseLauncher -Pulse $pulsePath -Data $pulseFixture -Repository $selectedRepository 2>&1)
    [pscustomobject]@{Exit=$LASTEXITCODE;Text=$pulseLines-join"`n"}
}
function Set-PulseFixtureEvents([object[]]$eventRows){
    $eventText=(@($eventRows|ForEach-Object{$_|ConvertTo-Json -Compress})-join"`n")
    [IO.File]::WriteAllText($pulseJournal,$eventText,[Text.UTF8Encoding]::new($false))
}
try{
    Set-PulseFixtureEvents @()
    [void][IO.Directory]::CreateDirectory((Join-Path $pulseFixture 'sessions'))
    $largeRow=@{id='large-index-fixture';prompts=1;title=('T'*10000);lastPrompt=('L'*10000);end='2026-10-20T00:00:00Z';repo='fixture';client='fixture';raw='sessions\raw\fixture.jsonl'}
    [IO.File]::WriteAllText((Join-Path $pulseFixture 'sessions/index.jsonl'),($largeRow|ConvertTo-Json -Compress)+"`n")
    $largeObserved=Invoke-PulseCheck ''
    $largeLine=[regex]::Match($largeObserved.Text,'(?m)^last     session .*?"(?<title>[^"]*)" ended .*?last ask: "(?<prompt>[^"]*)"')
    Assert-PulseCheck 'large session title is bounded to 300 characters with ellipsis' ($largeObserved.Exit-eq0-and$largeLine.Success-and$largeLine.Groups['title'].Value-ceq(('T'*297)+'...'))
    Assert-PulseCheck 'large last prompt is bounded to 300 characters with ellipsis' ($largeObserved.Exit-eq0-and$largeLine.Success-and$largeLine.Groups['prompt'].Value-ceq(('L'*297)+'...'))
    Assert-PulseCheck 'bounded session display retains its absolute archive pointer' ($largeObserved.Exit-eq0-and$largeObserved.Text.Contains('; archive: '+(Join-Path $pulseFixture $largeRow.raw)))
    [IO.File]::Delete((Join-Path $pulseFixture 'sessions/index.jsonl'))
    if($OutputProbeOnly){if($pulseFailures){throw 'PULSE_OUTPUT_PROBE_FAILED'};$pulseCompleted=$true;'PULSE_OUTPUT_PROBE PASS';return}
    $null=Read-PulseFixtureGit @('init','--quiet','-b','main')
    $null=Read-PulseFixtureGit @('config','user.name','Pulse Fixture')
    $null=Read-PulseFixtureGit @('config','user.email','fixture@invalid.local')
    [IO.File]::WriteAllText((Join-Path $pulseRepository 'a.txt'),"baseline`n")
    $null=Read-PulseFixtureGit @('add','--','a.txt')
    $null=Read-PulseFixtureGit @('commit','--quiet','-m','owned Pulse fixture only')
    $pulseHead=@(Read-PulseFixtureGit @('rev-parse','HEAD'))[0]
    $null=Read-PulseFixtureGit @('remote','add','origin',$pulseRepository)
    $null=Read-PulseFixtureGit @('update-ref','refs/remotes/origin/main',$pulseHead)
    $null=Read-PulseFixtureGit @('config','branch.main.remote','origin')
    $null=Read-PulseFixtureGit @('config','branch.main.merge','refs/heads/main')
    $pulseRows=@(
        @{pattern='technical';at='2026-10-23T10:00:00Z';category='decision';status='open';owner='agent';cause='confirmed';action='implement the approved scope';summary='Technical action, not an owner choice'},
        @{pattern='commercial';at='2026-10-23T10:00:01Z';category='decision';status='open';owner='owner';cause='owner-decision';summary='Actual owner decision'},
        @{pattern='inherited';at='2026-10-23T10:00:02Z';category='decision';status='open';owner='owner';cause='owner-decision';summary='Prior explicit assignment'},
        @{pattern='inherited';at='2026-10-23T10:00:03Z';category='observation';status='open';summary='Later diagnostic without reassignment'},
        @{pattern='closed';at='2026-10-23T10:00:04Z';category='decision';status='resolved';owner='owner';summary='Resolved choice'}
    )
    Set-PulseFixtureEvents $pulseRows
    $pulseBefore=(Get-FileHash -LiteralPath $pulseJournal).Hash
    $pulseObserved=Invoke-PulseCheck
    $pulseOwnerSection=[regex]::Match($pulseObserved.Text,'(?ms)^waiting  on the owner: (?<count>[0-9]+)\r?\n(?<entries>.*?)(?=^(last|cases|queue|hunt|tools)\s|\z)')
    $pulseOwnerEntries=$pulseOwnerSection.Groups['entries'].Value
    Assert-PulseCheck 'owner list itself contains commercial and inherited only; queue matches cannot satisfy it' ($pulseObserved.Exit-eq0-and$pulseOwnerSection.Success-and$pulseOwnerSection.Groups['count'].Value-ceq'2'-and$pulseOwnerEntries-match'commercial'-and$pulseOwnerEntries-match'inherited'-and$pulseOwnerEntries-notmatch'technical') $pulseObserved.Text
    Assert-PulseCheck 'read-only observation preserves journal and Git HEAD' ((Get-FileHash -LiteralPath $pulseJournal).Hash-ceq$pulseBefore-and@(Read-PulseFixtureGit @('rev-parse','HEAD'))[0]-ceq$pulseHead)
    Set-PulseFixtureEvents @()
    $pulseObserved=Invoke-PulseCheck
    Assert-PulseCheck 'explicit empty journal and readable synchronized repository are valid' ($pulseObserved.Exit-eq0-and$pulseObserved.Text-match'waiting  on the owner: 0'-and$pulseObserved.Text-match'clean, 0 ahead / 0 behind') $pulseObserved.Text
    [IO.File]::WriteAllText($pulseJournal,'{"torn')
    $pulseObserved=Invoke-PulseCheck
    Assert-PulseCheck 'torn required journal is unreadable with nonzero exit, never zero owner waits' ($pulseObserved.Exit-eq2-and$pulseObserved.Text-match'waiting  UNREADABLE'-and$pulseObserved.Text-notmatch'waiting  on the owner: 0') $pulseObserved.Text
    [IO.File]::Delete($pulseJournal)
    $pulseObserved=Invoke-PulseCheck
    Assert-PulseCheck 'missing required journal is not an empty healthy journal' ($pulseObserved.Exit-eq2-and$pulseObserved.Text-match'waiting  UNREADABLE') $pulseObserved.Text
    Set-PulseFixtureEvents @()
    $pulseBroken=Join-Path $pulseFixture 'broken'
    [void][IO.Directory]::CreateDirectory((Join-Path $pulseBroken '.git'))
    $pulseObserved=Invoke-PulseCheck $pulseBroken
    Assert-PulseCheck 'failed Git read remains UNREADABLE and nonzero' ($pulseObserved.Exit-eq2-and$pulseObserved.Text-match'repo\s+broken UNREADABLE') $pulseObserved.Text
    $pulseObserved=Invoke-PulseCheck (Join-Path $pulseFixture 'missing')
    Assert-PulseCheck 'explicit missing repository is reported rather than silently omitted' ($pulseObserved.Exit-eq2-and$pulseObserved.Text-match'repo\s+missing UNREADABLE') $pulseObserved.Text
    [IO.File]::AppendAllText((Join-Path $pulseRepository 'a.txt'),"dirty fixture`n")
    $pulseObserved=Invoke-PulseCheck
    Assert-PulseCheck 'readable dirt stays visible without falsely claiming unreadability or permission' ($pulseObserved.Exit-eq0-and$pulseObserved.Text-match'DIRTY\(1\)') $pulseObserved.Text
    $null=Read-PulseFixtureGit @('config','--unset','branch.main.remote')
    $null=Read-PulseFixtureGit @('config','--unset','branch.main.merge')
    $pulseObserved=Invoke-PulseCheck
    Assert-PulseCheck 'genuinely unconfigured upstream remains a readable no-upstream state' ($pulseObserved.Exit-eq0-and$pulseObserved.Text-match'no upstream') $pulseObserved.Text
    Assert-PulseCheck 'a missing session index is said plainly, not silently skipped' ($pulseObserved.Text-match'last     none: no session index') $pulseObserved.Text
    [void][IO.Directory]::CreateDirectory((Join-Path $pulseFixture 'sessions'))
    [IO.File]::WriteAllText((Join-Path $pulseFixture 'sessions/index.jsonl'),"{`"torn`n")
    $pulseObserved=Invoke-PulseCheck
    Assert-PulseCheck 'a damaged session index is UNREADABLE with nonzero exit' ($pulseObserved.Exit-eq2-and$pulseObserved.Text-match'last     UNREADABLE: 1 damaged') $pulseObserved.Text
    $pulseCompleted=$true
}finally{
    $env:GIT_CEILING_DIRECTORIES=$savedGitCeiling
    $env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem
    if($pulseCompleted-and$pulseFailures-eq0){$null=Remove-OrvionOwnedTree -Path $pulseFixture -AllowedRoots @($pulseTestParent)}
    else{"PULSE_FIXTURE_PRESERVED: $pulseFixture"}
}
if($pulseFailures){throw "PULSE_SELFCHECK_FAILED $pulseFailures"}
'PULSE_SELFCHECK PASS'
