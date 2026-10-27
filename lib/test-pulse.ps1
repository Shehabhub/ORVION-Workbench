# Real Pulse caller on owned Git/journal fixtures. No product, real journal or credential writes.
# An explicit library permits causal mutants; it never changes production tool selection.
param([string]$Library=$PSScriptRoot,[switch]$OutputProbeOnly,[switch]$BoundProbeOnly,[switch]$RuntimeProbeOnly)
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
param([string]$Pulse,[string]$Data,[string]$Repository,[string]$DiscoveryFault,[int]$RuntimeRows)
function Get-CimInstance{param([string]$ClassName,[string]$Filter)
    if(($DiscoveryFault-eq'process'-and$ClassName-eq'Win32_Process')-or($DiscoveryFault-eq'host'-and$ClassName-eq'Win32_OperatingSystem')){throw 'FIXTURE_DISCOVERY_FAILURE'}
    if($ClassName-eq'Win32_OperatingSystem'){[pscustomobject]@{FreePhysicalMemory=1000000;FreeVirtualMemory=2000000}}
    if($ClassName-eq'Win32_Process'){foreach($runIndex in 1..$RuntimeRows|Where-Object{$_-gt0-and$RuntimeRows-gt0}){[pscustomobject]@{ProcessId=$runIndex;CommandLine=('pwsh run_timed.ps1 -Log "'+(Join-Path $Data ('fixture-log-'+$runIndex+('-long'*15)))+'"')}}}
}
$noMap=Join-Path $Data 'no-ai-map.json'  # never the checkout's real map, which could start the real refresh task
if($Repository){& $Pulse -Root $Data -Repos $Repository -MapPath $noMap}else{& $Pulse -Root $Data -Repos @() -MapPath $noMap};exit $LASTEXITCODE
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
function Invoke-PulseCheck([string]$selectedRepository=$pulseRepository,[string]$discoveryFault='',[int]$runtimeRows=0){
    $pulseLines=@(& pwsh -NoProfile -File $pulseLauncher -Pulse $pulsePath -Data $pulseFixture -Repository $selectedRepository -DiscoveryFault $discoveryFault -RuntimeRows $runtimeRows 2>&1)
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
    if(!$RuntimeProbeOnly){
        # Owner summaries that merely mention "UNOWNED" must not outrank the real escalated item below.
        $boundedRows=@(foreach($ownerIndex in 0..999){@{pattern=('owner-{0:D4}' -f $ownerIndex);at='2026-10-20T00:00:00Z';category='decision';status='open';owner='owner';summary=('UNOWNED '+('S'*142))}})
        # Appended last, oldest first in the classifier: arrival order cannot decide selection.
        $boundedRows+=@{pattern='urgent-owner';at='2000-01-01T00:00:00Z';category='decision';status='open';owner='owner';summary='MOST-URGENT-OWNER'}
        $boundedRows+=@{pattern='critical-agent';at='2000-01-01T00:00:00Z';category='failure';severity='high';status='open';summary='UNOWNED-SENTINEL'}
        $boundedRows+=@{pattern='resumable';at='2026-10-20T00:00:00Z';category='observation';owner='agent';action='resume at fixture/RESUME.md';status='open';summary='in flight'}
        Set-PulseFixtureEvents $boundedRows
        $boundedIndex=Join-Path $pulseFixture 'sessions/index.jsonl'
        [IO.File]::WriteAllLines($boundedIndex,[string[]]@(($largeRow|ConvertTo-Json -Compress),'{torn'))
        $bounded=Invoke-PulseCheck '' '' 200
        $ownerMatches=[regex]::Matches($bounded.Text,'(?m)^         - (?:owner-[0-9]+|urgent-owner):')
        $moreMatch=[regex]::Match($bounded.Text,'(?m)^more\s+(?<count>[0-9]+) more owner wait\(s\)')
        Assert-PulseCheck 'total Pulse cap preserves unreadability, actual counts and exact omitted owner count' ($bounded.Exit-eq2-and$bounded.Text.Length+[Environment]::NewLine.Length-le4096-and$bounded.Text-match'last     UNREADABLE: 1 damaged'-and$bounded.Text-match'waiting  on the owner: 1001'-and$moreMatch.Success-and[int]$moreMatch.Groups['count'].Value-eq(1001-$ownerMatches.Count)) $bounded.Text
        Assert-PulseCheck 'bounded details retain snapshot urgency, escalation, continuation and same-root Coordinator pointer' ($ownerMatches.Count-gt0-and$ownerMatches[0].Value.EndsWith('urgent-owner:')-and$bounded.Text-match'UNOWNED-SENTINEL'-and$bounded.Text-match'fixture/RESUME.md'-and$bounded.Text.Contains("; archive: "+(Join-Path $pulseFixture $largeRow.raw))-and$bounded.Text.Contains("-Root '"+$pulseFixture.Replace("'","''")+"'")) $bounded.Text
        Set-PulseFixtureEvents @(@{pattern=('p'*10000);at='2026-10-20T00:00:00Z';category='decision';status='open';owner='owner';summary='wide identifier'})
        [IO.File]::WriteAllText($boundedIndex,'')
        $wide=Invoke-PulseCheck ''
        Assert-PulseCheck 'one oversized identifier remains bounded with readable status and a detail pointer' ($wide.Exit-eq0-and$wide.Text.Length+[Environment]::NewLine.Length-le4096-and$wide.Text-match'waiting  on the owner: 1'-and$wide.Text-match'detail abbreviated'-and$wide.Text.Contains("-Root '"+$pulseFixture.Replace("'","''")+"'")) $wide.Text
        $wideSession=$largeRow.Clone();$wideSession.repo='R'*12000
        [IO.File]::WriteAllText($boundedIndex,($wideSession|ConvertTo-Json -Compress))
        Set-PulseFixtureEvents @()
        $wide=Invoke-PulseCheck '' '' 200
        Assert-PulseCheck 'oversized runtime and session fields share the total cap and retain archive continuity' ($wide.Exit-eq0-and$wide.Text.Length+[Environment]::NewLine.Length-le4096-and$wide.Text.Contains('; archive: '+(Join-Path $pulseFixture $largeRow.raw))) $wide.Text
        [IO.File]::Delete($boundedIndex)
        Set-PulseFixtureEvents @()
        if($BoundProbeOnly){if($pulseFailures){throw 'PULSE_BOUND_PROBE_FAILED'};$pulseCompleted=$true;'PULSE_BOUND_PROBE PASS';return}
        # The overflow footer names the data root; a token-shaped folder name must be masked there too.
        $tokenShape='ghp_'+('A1b2C3d4E5'*4).Substring(0,36)  # the real GitHub token length the masking rule recognizes
        $tokenRoot=Join-Path $pulseFixture $tokenShape
        [void][IO.Directory]::CreateDirectory((Join-Path $tokenRoot 'events'))
        [IO.File]::WriteAllText((Join-Path $tokenRoot 'events/events.jsonl'),(@($boundedRows|ForEach-Object{$_|ConvertTo-Json -Compress})-join"`n"),[Text.UTF8Encoding]::new($false))
        $tokenLines=@(& pwsh -NoProfile -File $pulseLauncher -Pulse $pulsePath -Data $tokenRoot -Repository '' -DiscoveryFault '' -RuntimeRows 0 2>&1)-join"`n"
        Assert-PulseCheck 'overflow footer masks a token-shaped data-root path' ($tokenLines-match'(?m)^more\s'-and!$tokenLines.Contains($tokenShape)) $tokenLines
        # Mask before the 150-character cut: a token straddling the cut must not leave its prefix behind.
        Set-PulseFixtureEvents @(@{pattern='straddle';at='2026-10-20T00:00:00Z';category='decision';status='open';owner='owner';summary=('S'*139)+' '+$tokenShape})  # a token stands after a separator, as in real text
        $straddle=Invoke-PulseCheck ''
        Assert-PulseCheck 'owner summary is masked before it is shortened' ($straddle.Text-match'straddle: S+ <masked>'-and$straddle.Text-notmatch'ghp_') $straddle.Text
        # Coordinator's own cuts (summary 110, action 260) happen before Pulse sees the line: masked at the source.
        Set-PulseFixtureEvents @(@{pattern='escalated-straddle';at='2026-10-20T00:00:00Z';category='failure';severity='high';status='open';summary=('S'*104)+' '+$tokenShape},
            @{pattern='active-straddle';at='2026-10-20T00:00:00Z';category='observation';owner='agent';status='open';summary='in flight';action=('A'*254)+' '+$tokenShape})
        $coordinatorCut=Invoke-PulseCheck ''
        Assert-PulseCheck 'Coordinator summary and action are masked before their own cuts' ($coordinatorCut.Text-match'escalated-straddle'-and$coordinatorCut.Text-match'active-straddle'-and$coordinatorCut.Text-notmatch'ghp_') $coordinatorCut.Text
        Set-PulseFixtureEvents @()
        # Map freshness: each mapped repository's saved head against its live HEAD; every outcome is visible.
        $mapFile=Join-Path $pulseFixture 'ai-map.json';$marker=Join-Path $pulseFixture 'map-started.txt'
        $mapRepository=Join-Path $pulseFixture 'mapped';[void][IO.Directory]::CreateDirectory($mapRepository)
        foreach($gitStep in @(@('init','-q'),@('-c','user.name=fixture','-c','user.email=fixture@example.invalid','commit','-q','--allow-empty','-m','mapped'))){& git -C $mapRepository @gitStep 2>&1|Out-Null;if($LASTEXITCODE){throw 'PULSE_FIXTURE_GIT_FAILED'}}
        $mappedHead="$(& git -C $mapRepository rev-parse HEAD)".Trim()
        $mapProbe=Join-Path $pulseFixture 'invoke-map.ps1'
        [IO.File]::WriteAllText($mapProbe,'param($Pulse,$Data,$Map,$Marker,[switch]$FailLaunch) $start=if($FailLaunch){{throw ''launch failed''}}else{[scriptblock]::Create("[IO.File]::AppendAllText(''$Marker'',''x'')")};& $Pulse -Root $Data -Repos @() -MapPath $Map -StartMapTask $start;exit $LASTEXITCODE')
        $mapJson={param($Head)@{generated='2026-10-20T00:00:00Z';repos=@(@{name='mapped';root=$mapRepository;head=$Head})}|ConvertTo-Json -Compress -Depth 4}
        foreach($case in @(
            @{name='stale map (saved head differs) starts one refresh';map=(& $mapJson ('0'*40));line='^map      stale \(mapped\): refresh started$';exit=0;started=$true},
            @{name='fresh map starts no refresh and says fresh';map=(& $mapJson $mappedHead);line='^map      fresh$';exit=0;started=$false},
            @{name='missing map is named, never silent';map=$null;line='^map      missing: ';exit=0;started=$false},
            @{name='malformed map makes Pulse unreadable';map='{torn';line='^map      UNREADABLE ';exit=2;started=$false},
            @{name='empty map makes Pulse unreadable';map='{"repos":[]}';line='^map      UNREADABLE \(no mapped repositories\)';exit=2;started=$false},
            @{name='blank map file makes Pulse unreadable';map='';line='^map      UNREADABLE ';exit=2;started=$false},
            @{name='map object without repos makes Pulse unreadable';map='{}';line='^map      UNREADABLE \(no mapped repositories\)';exit=2;started=$false},
            @{name='map entry without fields makes Pulse unreadable';map='{"repos":[{}]}';line='^map      UNREADABLE \(map entry without name, root or head\)';exit=2;started=$false},
            @{name='map entry without head makes Pulse unreadable, never a refresh';map=('{"repos":[{"name":"mapped","root":'+($mapRepository|ConvertTo-Json)+'}]}');line='^map      UNREADABLE \(map entry';exit=2;started=$false},
            @{name='failed refresh launch makes Pulse unreadable';map=(& $mapJson ('0'*40));line='^map      UNREADABLE \(launch failed\)';exit=2;started=$false;fail=$true})){
            foreach($stale in $marker,$mapFile){if(Test-Path -LiteralPath $stale){[IO.File]::Delete($stale)}}
            if($null-ne$case.map){[IO.File]::WriteAllText($mapFile,$case.map)}
            $mapOut=@(& pwsh -NoProfile -File $mapProbe -Pulse $pulsePath -Data $pulseFixture -Map $mapFile -Marker $marker -FailLaunch:([bool]$case.fail) 2>&1)-join"`n";$mapExit=$LASTEXITCODE
            $started=(Test-Path -LiteralPath $marker)-and[IO.File]::ReadAllText($marker)-ceq'x'
            Assert-PulseCheck $case.name ($started-eq$case.started-and$mapExit-eq$case.exit-and$mapOut-match('(?m)'+$case.line)) $mapOut
        }
    }
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
    foreach($discoveryFailure in 'process','host'){
        $pulseObserved=Invoke-PulseCheck $pulseRepository $discoveryFailure
        Assert-PulseCheck "$discoveryFailure discovery failure stays UNREADABLE with exit 2 and retains owner information" ($pulseObserved.Exit-eq2-and$pulseObserved.Text-match'(?m)^running  UNREADABLE \('-and$pulseObserved.Text-match'waiting  on the owner: 2'-and$pulseObserved.Text-notmatch'archiver .*NOT running|host: 0|FIXTURE_DISCOVERY_FAILURE') $pulseObserved.Text
    }
    if($RuntimeProbeOnly){if($pulseFailures){throw 'PULSE_RUNTIME_PROBE_FAILED'};$pulseCompleted=$true;'PULSE_RUNTIME_PROBE PASS';return}
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
