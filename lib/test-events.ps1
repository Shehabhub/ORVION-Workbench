# Self-check for Events.ps1 in a temp root: add, duplicate refusal, recurrence across sessions, ranking by rare words,
# the brief's open-first order, and the link from an event to its session's raw record through sessions\index.jsonl.
$ErrorActionPreference='Stop'
$ev=Join-Path $PSScriptRoot 'Events.ps1'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-evcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory "$t\sessions" -Force|Out-Null
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
    '{"id":"s1-aaaaaaaa","start":"2026-10-01T10:00:00Z","title":"first session","raw":"sessions\\raw\\s1.jsonl"}'|Set-Content "$t\sessions\index.jsonl"
    $a=& $ev -Root $t -Add -Pattern ps-reserved-name -Session s1-aaaaaaaa -Category failure -Status resolved -Summary 'param named $Pid broke' -Tool Test-ScriptHazards.ps1 -Tags 'pid process param'
    $b=& $ev -Root $t -Add -Pattern ps-reserved-name -Session s1-aaaaaaaa -Category failure -Status resolved -Summary 'param named $Pid broke'
    $c=& $ev -Root $t -Add -Pattern ps-reserved-name -Session s2-bbbbbbbb -Category failure -Status resolved -Summary 'param named $event broke' -Tags 'pid process param'
    $null=& $ev -Root $t -Add -Pattern watch-run-eta -Session s2-bbbbbbbb -Category proposal -Status deferred -Summary 'no ETA for a new run name' -Tags 'watcher eta script'
    $null=& $ev -Root $t -Add -Pattern other-script -Session s2-bbbbbbbb -Category observation -Status resolved -Summary 'a script ran' -Tags 'script'
    Assert-That 'add, duplicate refused, recurrence counted' ("$a"-match'RECORDED.*\(1 session'-and"$b"-match'DUPLICATE'-and"$c"-match'\(2 session')
    $f=@(& $ev -Root $t -Find 'write a script that takes a process id')
    Assert-That 'rare words rank the right pattern first' ($f[1]-match'^\[resolved x2 .*ps-reserved-name')
    Assert-That 'find links the raw session record' (($f-join"`n")-match'raw record: session s2-bbbbb|raw record: session s1-aaaaa')
    $br=@(& $ev -Root $t -Brief)
    Assert-That 'brief lists open or deferred first, then recurring' ($br[1]-match'watch-run-eta'-and$br[2]-match'ps-reserved-name'-and(($br-join' ')-notmatch'other-script'))
    $bad=try{& $ev -Root $t -Add -Pattern 'Bad Pattern' -Summary x;$false}catch{$true}
    Assert-That 'a malformed pattern id is refused' $bad
    $before=(Get-Content "$t\events\events.jsonl").Count
    $jobs=1..12|ForEach-Object{Start-Job -ScriptBlock {param($e,$r,$i)& pwsh -NoProfile -File $e -Root $r -Add -Pattern race-case -Session "w$i" -Summary "writer $i"} -ArgumentList $ev,$t,$_}
    $null=$jobs|Wait-Job;$jobs|Remove-Job
    Assert-That '12 writers at once lose no line' ((Get-Content "$t\events\events.jsonl").Count-eq$before+12)
    Add-Content "$t\events\events.jsonl" '{"torn line'
    $okBrief=try{$null=& $ev -Root $t -Brief;$true}catch{$false};$okFind=try{$null=& $ev -Root $t -Find 'process';$true}catch{$false}
    Assert-That 'a torn line does not silence the readers' ($okBrief-and$okFind)
    $torn=@(& pwsh -NoProfile -File $ev -Root $t -Find 'process');$tornCode=$LASTEXITCODE
    Assert-That 'a damaged journal is reported INCOMPLETE with exit 2, results still shown' ($tornCode-eq2-and($torn-join"`n")-match'EVENTS_INCOMPLETE: 1 unreadable'-and($torn-join"`n")-match'ps-reserved-name')
    $tornBrief=@(& pwsh -NoProfile -File $ev -Root $t -Brief);$tornBriefCode=$LASTEXITCODE
    Assert-That 'Brief retains EVENTS_INCOMPLETE and exit 2 on a damaged journal' ($tornBriefCode-eq2-and($tornBrief-join"`n")-match'EVENTS_INCOMPLETE: 1 unreadable')
    $journal=Join-Path $t 'events\events.jsonl';$valid=@(Get-Content $journal|Select-Object -SkipLast 1);[IO.File]::WriteAllLines($journal,[string[]]$valid)
    Add-Content "$t\sessions\index.jsonl" '{"torn index'
    $indexOnly=@(& pwsh -NoProfile -File $ev -Root $t -Find 'process');$indexCode=$LASTEXITCODE;$indexText=$indexOnly-join"`n"
    Assert-That 'index damage alone names the index, not the journal, and exits 2' ($indexCode-eq2-and$indexText.Contains("EVENTS_INCOMPLETE: 1 unreadable record(s) skipped in $t\sessions\index.jsonl")-and!$indexText.Contains("skipped in $journal"))
    Add-Content $journal '{"torn journal';Add-Content $journal '{}'
    $both=@(& pwsh -NoProfile -File $ev -Root $t -Find 'process');$bothCode=$LASTEXITCODE;$bothText=$both-join"`n"
    Assert-That 'journal and index damage have separate counts and file attribution' ($bothCode-eq2-and$bothText.Contains("EVENTS_INCOMPLETE: 2 unreadable record(s) skipped in $journal")-and$bothText.Contains("EVENTS_INCOMPLETE: 1 unreadable record(s) skipped in $t\sessions\index.jsonl"))
    Assert-That 'Workbench incomplete preflight wording is source-neutral' ([IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Workbench.ps1')).Contains("2='INCOMPLETE (unreadable records skipped)'"))
    $none=@(& pwsh -NoProfile -File $ev -Root (Join-Path $t 'no-store') -Find 'process');$noneCode=$LASTEXITCODE
    $null=& pwsh -NoProfile -File $ev -Root (Join-Path $t 'no-store') -Brief;$noneBriefCode=$LASTEXITCODE
    Assert-That 'a missing journal is UNAVAILABLE (exit 3), never "nothing recorded"' ($noneCode-eq3-and$none[0]-match'^EVENTS_UNAVAILABLE'-and($none-join' ')-notmatch'nothing recorded'-and$noneBriefCode-eq3)
    # The default data root: the sibling ORVION-Owner-Tools store when it has events\, ORVION_DATA_ROOT above all.
    $gh=Join-Path $t 'gh';$copy=Join-Path $gh 'ORVION-Workbench\lib';[void][IO.Directory]::CreateDirectory($copy);Copy-Item $ev $copy
    $null=& $ev -Root (Join-Path $gh 'ORVION-Owner-Tools') -Add -Pattern sibling-store-marker -Session s9 -Summary 'found in the sibling data store' -Tags 'siblingmarker'
    $null=& $ev -Root (Join-Path $t 'env-store') -Add -Pattern env-store-marker -Session s9 -Summary 'found through ORVION_DATA_ROOT' -Tags 'siblingmarker'
    $savedRoot=$env:ORVION_DATA_ROOT
    try{$env:ORVION_DATA_ROOT=$null;$sib=@(& pwsh -NoProfile -File (Join-Path $copy 'Events.ps1') -Find 'siblingmarker')
        $env:ORVION_DATA_ROOT=Join-Path $t 'env-store';$viaEnv=@(& pwsh -NoProfile -File (Join-Path $copy 'Events.ps1') -Find 'siblingmarker')}finally{$env:ORVION_DATA_ROOT=$savedRoot}
    Assert-That 'default root finds the sibling data store; ORVION_DATA_ROOT overrides it' (($sib-join' ')-match'sibling-store-marker'-and($viaEnv-join' ')-match'env-store-marker'-and($viaEnv-join' ')-notmatch'sibling-store-marker')
    $expression='$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{(@(@(Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) ''ORVION-Owner-Tools'')|Where-Object{Test-Path -LiteralPath (Join-Path $_ ''events'')})+@(Split-Path $PSScriptRoot -Parent))[0]})'
    $drift=@(foreach($tool in 'Events','Spider','Pulse','Coordinator','Delegate'){if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot "$tool.ps1")).Contains('[string]$Root='+$expression)){$tool}})+@(if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Watch-Subagents.ps1')).Contains('[string]$EventRoot='+$expression)){'Watch-Subagents'})
    Assert-That "every data tool carries the one identical data-root default$(if($drift.Count){' (drifted: '+($drift-join', ')+')'})" (!$drift.Count)
}finally{[IO.Directory]::Delete($t,$true)}
if($fail){throw "EVENTS_SELFCHECK_FAILED $fail"};'EVENTS_SELFCHECK PASS'
