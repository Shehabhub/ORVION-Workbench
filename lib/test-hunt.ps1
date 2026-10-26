# Self-check for Hunt.ps1: a planted bug its self-check catches is NOT reported, a harmless change the check cannot
# see IS reported as a surviving mutant, a stale mutant is reported, and nothing is recorded with -NoRecord.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-huntcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t|Out-Null
$savedProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
    $set=@(
        ,@('Events.ps1','if($last.Count){"EVENT DUPLICATE','if($false){"EVENT DUPLICATE','test-events.ps1','duplicate refusal')        # caught
        ,@('Events.ps1','# One view per pattern','# One view, per pattern','test-events.ps1','a comment only')                          # survives
        ,@('Events.ps1','THIS TEXT IS NOT IN THE FILE','x','test-events.ps1','a mutant whose code moved')                           # stale
    )
    $out=@(& (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $t -NoRecord -MutantSet $set)-join"`n"
    Assert-That 'a caught mutant is not reported' ($out-notmatch'duplicate refusal broken')
    Assert-That 'a surviving mutant is reported as a gap' ($out-match'GAP mutant-survived: test-events\.ps1 still passes with a comment only broken')
    Assert-That 'a stale mutant is reported' ($out-match'GAP mutant-stale: mutant for a mutant whose code moved')
    Assert-That 'the last result is kept for Pulse' (Test-Path (Join-Path $t 'work\hunt-last.txt'))
    Assert-That '-NoRecord writes no events' (!(Test-Path (Join-Path $t 'events\events.jsonl')))
    & (Join-Path $PSScriptRoot 'Events.ps1') -Root $t -Add -Pattern hunt-old-problem -Session hunter-2026-01-01 -Category observation -Summary 'GAP: something once found'|Out-Null
    $null=& (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $t -Quick
    $ev=@([IO.File]::ReadAllLines((Join-Path $t 'events\events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json})
    $last=@($ev|Where-Object pattern -eq 'hunt-old-problem'|Sort-Object at)[-1]
    Assert-That 'a finding no longer found is closed by the hunter' ($last.status-eq'resolved'-and$last.summary-like'no longer found*')
    Assert-That 'current findings are recorded as events' (@($ev|Where-Object{$_.pattern-eq'hunt-index-missing'-and$_.source-eq'hunter'}).Count-eq1)
}finally{$env:USERPROFILE=$savedProfile;Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
if($fail){throw "HUNT_SELFCHECK_FAILED $fail"};'HUNT_SELFCHECK PASS'
