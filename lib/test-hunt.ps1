# Self-check for Hunt.ps1: a planted bug its self-check catches is NOT reported, a harmless change the check cannot
# see IS reported as a surviving mutant, a stale mutant is reported, and nothing is recorded with -NoRecord.
param([switch]$RootProbeOnly,[switch]$EvidenceProbeOnly,[switch]$IndexProbeOnly)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-huntcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t|Out-Null
$savedTemporaryRoot=$env:WORKBENCH_TEMP_ROOT;$savedTemp=$env:TEMP;$savedTmp=$env:TMP;$env:WORKBENCH_TEMP_ROOT=$t+'-managed'
$savedProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
    if(!$RootProbeOnly-and!$EvidenceProbeOnly){
        $indexStore=Join-Path $t 'index-probe'
        foreach($part in 'sessions','events','work'){[void][IO.Directory]::CreateDirectory((Join-Path $indexStore $part))}
        $indexLauncher=Join-Path $t 'index-probe.ps1'
        [IO.File]::WriteAllText($indexLauncher,@'
param([string]$Hunt,[string]$Store,[switch]$Record)
function Get-Process { @() }
function Get-CimInstance { @() }
& $Hunt -Root $Store -DataRoot $Store -Quick -NoRecord:(!$Record)
exit $LASTEXITCODE
'@)
        $indexFile=Join-Path $indexStore 'sessions/index.jsonl'
        $indexJournal=Join-Path $indexStore 'events/events.jsonl'
        $oldIndexEvents=@(foreach($pattern in 'hunt-index-consistency','hunt-lesson-raw-missing','hunt-unrelated-old'){
            @{at='2000-01-01T00:00:00Z';pattern=$pattern;status='open';category='observation';summary='old fixture';session='hunter-fixture'}|ConvertTo-Json -Compress
        })
        [IO.File]::WriteAllLines($indexJournal,[string[]]$oldIndexEvents)
        [IO.File]::WriteAllText((Join-Path $indexStore 'work/sync-errors.log'),'INDEPENDENT-SENTINEL')
        $marker=Join-Path $indexStore 'sessions/marker.jsonl'
        [IO.File]::WriteAllText($marker,'x');(Get-Item $marker).LastWriteTimeUtc=[DateTime]::UtcNow.AddHours(-1)
        $indexRow=@{id='before';raw='sessions\marker.jsonl';bytes=0;metaBytes=0}
        $indexAfter=@{id='after';raw='sessions\marker.jsonl';bytes=0;metaBytes=0}
        [IO.File]::WriteAllLines($indexFile,[string[]]@(($indexRow|ConvertTo-Json -Compress),'{torn','null',($indexAfter|ConvertTo-Json -Compress),'  '))
        $indexHash=(Get-FileHash $indexJournal).Hash
        $indexOutput=@(& pwsh -NoProfile -File $indexLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $indexStore 2>&1)-join"`n";$indexCode=$LASTEXITCODE
        Assert-That 'index corruption counts two rows, checks valid rows on both sides and continues other hounds' ($indexCode-eq1-and$indexOutput-match'BUG index-unreadable: 2 malformed row\(s\)'-and$indexOutput-match'BUG index-consistency: 2 '-and$indexOutput-match'BUG sync-errors:.*INDEPENDENT-SENTINEL'-and$indexOutput-match'^HUNT ')
        Assert-That 'partial index saves its result and NoRecord preserves the journal' ((Test-Path (Join-Path $indexStore 'work/hunt-last.txt'))-and(Get-FileHash $indexJournal).Hash-ceq$indexHash)
        # The repository map refreshes itself only while its scheduled task exists and last succeeded.
        $mapLauncher=Join-Path $t 'map-probe.ps1'
        [IO.File]::WriteAllText($mapLauncher,@'
param([string]$Hunt,[string]$Store,[string]$Mode)
function Get-Process { @() }
function Get-CimInstance { @() }
$task=switch($Mode){'missing'{{throw 'no task'}}'failed'{{[pscustomobject]@{LastTaskResult=1}}}default{{[pscustomobject]@{LastTaskResult=0}}}}
& $Hunt -Root $Store -DataRoot $Store -Quick -NoRecord -GetMapTask $task
exit $LASTEXITCODE
'@)
        $mapSeen=@{}
        foreach($mode in 'missing','failed','ok'){$mapSeen[$mode]=(@(& pwsh -NoProfile -File $mapLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $indexStore -Mode $mode 2>&1)-join"`n")-match'GAP map-task'}
        Assert-That 'map task missing or failed is a GAP; a healthy task is not' ($mapSeen.missing-and$mapSeen.failed-and!$mapSeen.ok)
        $indexRow.bytes=1;$indexRow.metaBytes=1
        [IO.File]::WriteAllText((Join-Path $indexStore 'work/sync-errors.log'),'')
        [IO.File]::WriteAllLines($indexFile,[string[]]@(($indexRow|ConvertTo-Json -Compress),'{torn'))
        $null=& pwsh -NoProfile -File $indexLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $indexStore -Record
        $recordIndexCode=$LASTEXITCODE
        $indexEvents=@([IO.File]::ReadAllLines($indexJournal)|ForEach-Object{$_|ConvertFrom-Json})
        Assert-That 'incomplete index retains old index and lesson findings while unrelated findings can resolve' (@($indexEvents|Where-Object pattern -eq 'hunt-index-consistency')[-1].status-eq'open'-and@($indexEvents|Where-Object pattern -eq 'hunt-lesson-raw-missing')[-1].status-eq'open'-and@($indexEvents|Where-Object pattern -eq 'hunt-unrelated-old')[-1].status-eq'resolved')
        Assert-That 'index corruption alone exits 1 and recording names index unreadability in the journal' ($recordIndexCode-eq1-and@($indexEvents|Where-Object pattern -eq 'hunt-index-unreadable').Count-eq1)
        $indexLock=[IO.File]::Open($indexFile,'Open','ReadWrite','None')
        try{$lockedOutput=@(& pwsh -NoProfile -File $indexLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $indexStore 2>&1)-join"`n";$lockedCode=$LASTEXITCODE}finally{$indexLock.Dispose()}
        Assert-That 'unreadable index file reports unknown count and continues to the summary' ($lockedCode-eq1-and$lockedOutput-match'BUG index-unreadable: row count unknown'-and$lockedOutput-match'^HUNT ')
        if($IndexProbeOnly){if($fail){throw 'HUNT_INDEX_PROBE_FAILED'};'HUNT_INDEX_PROBE PASS';return}
    }
    if(!$RootProbeOnly){
        $evidenceRoot=Join-Path $t 'evidence';[void][IO.Directory]::CreateDirectory((Join-Path $evidenceRoot 'events'))
        [void][IO.Directory]::CreateDirectory((Join-Path $evidenceRoot 'work'))
        [IO.File]::WriteAllText((Join-Path $evidenceRoot 'work\correct.log'),'fixture')
        $evidenceEvents=@(
            [ordered]@{at='2026-10-20T00:00:00Z';pattern='corrected';evidence='work\wrong.log (38.027 min)';status='resolved'}
            [ordered]@{at='2026-10-26T00:00:00Z';pattern='corrected';evidence='work\correct.log (38.027 min)';status='resolved'}
            [ordered]@{at='2026-10-26T01:00:00Z';pattern='corrected';evidence='';status='resolved'}
            [ordered]@{at='2026-10-26T00:00:00Z';pattern='independent';evidence='work\still-missing.log';status='resolved'}
            # An empty latest update cannot erase a missing citation either.
            [ordered]@{at='2026-10-26T01:00:00Z';pattern='independent';evidence='';status='resolved'}
            # Many equal timestamps followed by an older backfill expose an unstable tie ordering.
            foreach($tieIndex in 0..15){[ordered]@{at='2026-10-26T00:00:00Z';pattern='equal-time';evidence=$(if($tieIndex-eq15){'work\correct.log'}else{'work\wrong.log'});status='open'}}
            [ordered]@{at='2000-01-01T00:00:00Z';pattern='equal-time';evidence='work\wrong.log';status='open'}
        )
        $evidenceJournal=Join-Path $evidenceRoot 'events\events.jsonl'
        [IO.File]::WriteAllLines($evidenceJournal,[string[]]@($evidenceEvents|ForEach-Object{$_|ConvertTo-Json -Compress}))
        $evidenceHash=(Get-FileHash -LiteralPath $evidenceJournal).Hash
        $evidenceLauncher=Join-Path $t 'evidence-probe.ps1'
        [IO.File]::WriteAllText($evidenceLauncher,@'
param([string]$Hunt,[string]$Store)
function Get-Process { @() }
function Get-CimInstance { @() }
& $Hunt -Root $Store -DataRoot $Store -Quick -NoRecord
exit $LASTEXITCODE
'@)
        $evidenceOutput=@(& pwsh -NoProfile -File $evidenceLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $evidenceRoot)
        $evidenceCode=$LASTEXITCODE
        $evidenceGap=@($evidenceOutput|Where-Object{$_-match'GAP event-evidence:'})-join' '
        Assert-That 'latest nonempty corrected evidence replaces historical missing paths' ($evidenceCode-eq0-and$evidenceGap-notmatch'corrected')
        Assert-That 'resolved missing evidence survives a later empty metadata update' ($evidenceGap-match'independent')
        Assert-That 'equal timestamp evidence uses last journal record despite older backfill' ($evidenceGap-notmatch'equal-time')
        Assert-That 'evidence projection never rewrites the append-only journal' ((Get-FileHash -LiteralPath $evidenceJournal).Hash-ceq$evidenceHash)
        if($EvidenceProbeOnly){if($fail){throw 'HUNT_EVIDENCE_PROBE_FAILED'};'HUNT_EVIDENCE_PROBE PASS';return}
    }

    # Independently controlled source and data with opposing evidence; Quick avoids slow mutants/lint.
    $layout=Join-Path $t 'roots';$checkout=Join-Path $layout 'ORVION-Workbench';$copy=Join-Path $checkout 'lib'
    $sibling=Join-Path $layout 'ORVION-Owner-Tools';$override=Join-Path $layout 'override store';$explicit=Join-Path $t 'explicit store'
    [void][IO.Directory]::CreateDirectory($copy)
    Copy-Item (Join-Path $PSScriptRoot '*') $copy -Recurse
    $savedDataRoot=$env:ORVION_DATA_ROOT
    try{
        foreach($case in 'sibling','override','explicit'){
            $env:ORVION_DATA_ROOT=$null
            [void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))
            $expected=if($case-eq'explicit'){$env:ORVION_DATA_ROOT=$override;$explicit}elseif($case-eq'override'){$env:ORVION_DATA_ROOT=$override+'\';$override}else{$sibling}
            [void][IO.Directory]::CreateDirectory((Join-Path $expected 'work'));[void][IO.Directory]::CreateDirectory((Join-Path $expected 'sessions'));[void][IO.Directory]::CreateDirectory((Join-Path $expected 'events'))
            Set-Content (Join-Path $expected 'work\sync-errors.log') "fixture-$case"
            Set-Content (Join-Path $expected 'work\hook-errors.log') "fixture-hook-$case"
            Set-Content (Join-Path $expected 'sessions\marker.jsonl') '{}'
            (Get-Item (Join-Path $expected 'sessions\marker.jsonl')).LastWriteTimeUtc=[DateTime]::UtcNow.AddHours(-1)
            Set-Content (Join-Path $expected 'sessions\index.jsonl') '{"id":"fixture","raw":"sessions\\marker.jsonl","bytes":0,"metaBytes":0}'
            Set-Content (Join-Path $expected 'events\events.jsonl') '{torn','{"at":"2026-10-20T01:00:00Z","pattern":"fixture-evidence","evidence":"sessions\\marker.jsonl"}','{"at":"2000-01-01T00:00:00Z","pattern":"hunt-old-root-problem","status":"open","category":"observation"}'
            $archived=Join-Path $expected 'sessions\raw\claude\C--Fixture-ORVION';$source=Join-Path $env:USERPROFILE '.claude\projects\C--Fixture-ORVION'
            [void][IO.Directory]::CreateDirectory($archived);[void][IO.Directory]::CreateDirectory($source)
            Set-Content (Join-Path $archived 'prefix.jsonl') 'old';Set-Content (Join-Path $source 'prefix.jsonl') 'rewritten'
            $extra=if($case-eq'explicit'){@('-DataRoot',$explicit)}else{@()}
            $result=@(& pwsh -NoProfile -File (Join-Path $copy 'Hunt.ps1') -Quick @extra)-join"`n";$huntCode=$LASTEXITCODE
            Assert-That "hunt $case reads sessions, events and sync errors from data root with BUG exit 1" ($huntCode-eq1-and$result-match"BUG sync-errors:.*fixture-$case"-and$result-match'BUG index-consistency:.*index says'-and$result-match'BUG events-corrupt:'-and$result-match'BUG archive-prefix:'-and$result-match"BUG hook-errors:.*fixture-hook-$case"-and$result-notmatch'GAP event-evidence:')
            $rootEvents=@(Get-Content (Join-Path $expected 'events\events.jsonl')|ForEach-Object{try{$_|ConvertFrom-Json}catch{$null=$_}})
            $closed=@($rootEvents|Where-Object pattern -eq 'hunt-old-root-problem')[-1]
            Assert-That "hunt $case records findings and last result only in data root" ((Test-Path (Join-Path $expected 'work\hunt-last.txt'))-and@($rootEvents|Where-Object pattern -eq 'hunt-sync-errors').Count-gt0-and$closed.status-eq'resolved'-and!(Test-Path (Join-Path $checkout 'work')))
            # Data has no .git. Source has an invalid .git; only the source may decide tools-git.
            Set-Content (Join-Path $checkout '.git') 'gitdir: missing-fixture-git'
            $sourceCheck=@(& pwsh -NoProfile -File (Join-Path $copy 'Hunt.ps1') -Quick -NoRecord @extra)-join"`n"
            Assert-That "hunt $case keeps git checks on source after library import" ($sourceCheck-match'BUG tools-git:')
            Remove-Item -LiteralPath (Join-Path $checkout '.git')
        }
    }finally{$env:ORVION_DATA_ROOT=$savedDataRoot}
    if($RootProbeOnly){if($fail){throw 'HUNT_ROOT_PROBE_FAILED'};'HUNT_ROOT_PROBE PASS';return}
    $set=@(
        ,@('Events.ps1','if($last.Count){"EVENT DUPLICATE','if($false){"EVENT DUPLICATE','test-events.ps1','duplicate refusal')        # caught
        ,@('Events.ps1','# One view per pattern','# One view, per pattern','test-events.ps1','a comment only')                          # survives
        ,@('Events.ps1','THIS TEXT IS NOT IN THE FILE','x','test-events.ps1','a mutant whose code moved')                           # stale
    )
    $out=@(& (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $t -DataRoot $t -NoRecord -MutantSet $set)-join"`n"
    Assert-That 'a caught mutant is not reported' ($out-notmatch'duplicate refusal broken')
    Assert-That 'a surviving mutant is reported as a gap' ($out-match'GAP mutant-survived: test-events\.ps1 still passes with a comment only broken')
    Assert-That 'a stale mutant is reported' ($out-match'GAP mutant-stale: mutant for a mutant whose code moved')
    Assert-That 'the last result is kept for Pulse' (Test-Path (Join-Path $t 'work\hunt-last.txt'))
    Assert-That '-NoRecord writes no events' (!(Test-Path (Join-Path $t 'events\events.jsonl')))
    & (Join-Path $PSScriptRoot 'Events.ps1') -Root $t -Add -Pattern hunt-old-problem -Session hunter-2026-01-01 -Category observation -Summary 'GAP: something once found'|Out-Null
    $null=& (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $t -DataRoot $t -Quick
    $ev=@([IO.File]::ReadAllLines((Join-Path $t 'events\events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json})
    $last=@($ev|Where-Object pattern -eq 'hunt-old-problem'|Sort-Object at)[-1]
    Assert-That 'a finding no longer found is closed by the hunter' ($last.status-eq'resolved'-and$last.summary-like'no longer found*')
    Assert-That 'current findings are recorded as events' (@($ev|Where-Object{$_.pattern-eq'hunt-index-missing'-and$_.source-eq'hunter'}).Count-eq1)
}finally{$env:WORKBENCH_TEMP_ROOT=$savedTemporaryRoot;$env:TEMP=$savedTemp;$env:TMP=$savedTmp;$env:USERPROFILE=$savedProfile;$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath());if(Test-Path ($t+'-managed')){$null=Remove-OrvionOwnedTree -Path ($t+'-managed') -AllowedRoots @([IO.Path]::GetTempPath())}}
if($fail){throw "HUNT_SELFCHECK_FAILED $fail"};'HUNT_SELFCHECK PASS'
