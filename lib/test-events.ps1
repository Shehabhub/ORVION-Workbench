# Self-check for Events.ps1 in a temp root: add, duplicate refusal, recurrence across sessions, ranking by rare words,
# the brief's open-first order, and the link from an event to its session's raw record through sessions\index.jsonl.
param([switch]$RootProbeOnly,[string]$RelativeTool,[switch]$EvidenceProbeOnly,[switch]$HazardProbeOnly)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$ev=Join-Path $PSScriptRoot 'Events.ps1'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-evcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory "$t\sessions" -Force|Out-Null
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
    if(!$RootProbeOnly-and!$EvidenceProbeOnly){
        # The reserved-name lesson below owns the real scanner caller; strings keep planted hazards out of this script's AST.
        $hazardCases=@(
            @{name='separate functions';code='function Read-First { $Token=1 }; function Read-Second { $token=2 }';count=0},
            @{name='nested functions';code='function Read-First { $Token=1; function Read-Second { $token=2 } }';count=0},
            @{name='root and function';code='$Token=1; function Read-First { $token=2 }';count=0},
            @{name='same function parameter and loop';code='function Read-First { param($Token) foreach($token in 1..2){ $token } }';count=1},
            @{name='conditional block';code='function Read-First { $Token=1; if($true){$token=2} }';count=1},
            @{name='dot sourced block';code='function Read-First { $Token=1; . { $token=2 } }';count=1},
            @{name='dot invoked own function';code='function Read-First { $Token=1 }; . Read-First; $token=2';count=1},
            @{name='one function dot invoked from two scopes';code='function Read-Shared { $x=1 }; function Read-First { . Read-Shared }; function Read-Second { . Read-Shared }';count=1},
            @{name='dot invocation joins only its own function';code='function Read-First { $Token=1 }; function Read-Second { $token=2 }; function Invoke-LocalDot { $x=1 }; . Invoke-LocalDot';count=0},
            @{name='automatic variable';code='function Read-First { $Pid=1 }';count=1}
        )
        foreach($hazardCase in $hazardCases){
            $hazardPath=Join-Path $t ('hazard-'+$hazardCase.name.Replace(' ','-')+'.ps1')
            [IO.File]::WriteAllText($hazardPath,$hazardCase.code)
            $hazardOutput=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Test-ScriptHazards.ps1') $hazardPath 2>&1)-join"`n"
            $hazardExit=$LASTEXITCODE
            Assert-That "scanner $($hazardCase.name) has $($hazardCase.count) hazard(s)" ($hazardExit-eq[int]($hazardCase.count-gt0)-and$hazardOutput-match("(?m)^hazards: "+$hazardCase.count+'\s*$'))
        }
        if($HazardProbeOnly){if($fail){throw 'HAZARD_PROBE_FAILED'};'HAZARD_PROBE PASS';return}
    }
    if(!$RootProbeOnly){
        $evidenceStore=Join-Path $t 'evidence-correction'
        $null=& $ev -Root $evidenceStore -Add -Pattern evidence-correction -Session same-session -Summary 'suite completed' -Evidence 'work\wrong.log'
        $corrected=& $ev -Root $evidenceStore -Add -Pattern evidence-correction -Session same-session -Summary 'suite completed' -Evidence 'work\correct.log'
        $repeated=& $ev -Root $evidenceStore -Add -Pattern evidence-correction -Session same-session -Summary 'suite completed' -Evidence 'work\correct.log'
        $evidenceRows=@([IO.File]::ReadAllLines((Join-Path $evidenceStore 'events\events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json})
        Assert-That 'evidence-only correction is appended and an identical correction is deduplicated' ($corrected-match'EVENT RECORDED'-and$repeated-match'EVENT DUPLICATE'-and$evidenceRows.Count-eq2-and$evidenceRows[-1].evidence-ceq'work\correct.log'-and$evidenceRows[0].evidence-ceq'work\wrong.log')
        $cycle=Join-Path $t 'cycle'
        foreach($summary in 'A','B','A'){$null=& $ev -Root $cycle -Add -Pattern cycle -Session s -Summary $summary -At ([datetime]'2026-01-01T00:00:00Z') -Repo fixture}
        $null=& $ev -Root $cycle -Add -Pattern cycle -Session s -Summary A -At ([datetime]'2026-01-01T00:00:00Z') -Repo fixture -Category failure
        $null=& $ev -Root $cycle -Add -Pattern cycle -Session other -Summary A -At ([datetime]'2026-01-01T00:00:00Z') -Repo fixture -Category failure
        $cycleRows=@([IO.File]::ReadAllLines((Join-Path $cycle 'events/events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json})
        Assert-That 'current tied row, material category and session recurrence' ($cycleRows.Count-eq5-and$cycleRows[2].summary-ceq'A')
        $found=@(& $ev -Root $cycle -Find cycle -Repo fixture)-join' '
        $absent=@(& $ev -Root $cycle -Find cycle -Repo other)-join' '
        Assert-That 'Find filters repository before grouping' ($found-match'cycle'-and$absent-match'nothing recorded')
        # Real journals name repositories loosely: lists, owner/repo, and "Workbench" for ORVION-Workbench.
        $aliases=Join-Path $t 'aliases'
        foreach($row in @(@('pair','CRM,ORVION'),@('slug','Shehabhub/ORVION-Workbench'),@('short','Workbench'))){$null=& $ev -Root $aliases -Add -Pattern $row[0] -Session s -Summary $row[0] -Repo $row[1]}
        $orvion=@(& $ev -Root $aliases -Find 'pair slug short' -Repo ORVION)-join' ';$wb=@(& $ev -Root $aliases -Find 'pair slug short' -Repo Workbench)-join' '
        Assert-That 'Repo filter matches list members, owner/repo slugs and the Workbench alias' ($orvion-match'pair'-and$orvion-notmatch'slug|short'-and$wb-match'slug'-and$wb-match'short'-and$wb-notmatch'pair')
        $bySlug=@(& $ev -Root $aliases -Find 'pair slug short' -Repo 'Shehabhub/ORVION-Workbench')-join' '
        Assert-That 'an owner/repo selector matches its own stored slug and alias' ($bySlug-match'slug'-and$bySlug-match'short'-and$bySlug-notmatch'pair')
        # The repository is part of the fact: the same note for another repository is recorded, not a duplicate.
        $first=& $ev -Root $aliases -Add -Pattern per-repo -Session s -Summary same -Repo CRM
        $second=& $ev -Root $aliases -Add -Pattern per-repo -Session s -Summary same -Repo ORVION
        $orvionOnly=@(& $ev -Root $aliases -Find 'per repo' -Repo ORVION)-join' '
        Assert-That 'dedupe includes the repository' ($first-match'EVENT RECORDED'-and$second-match'EVENT RECORDED'-and$orvionOnly-match'per-repo')
        $tokenShape='ghp_'+('A1b2C3d4E5'*4).Substring(0,36)  # the real GitHub token length the masking rule recognizes
        $null=& $ev -Root $aliases -Add -Pattern leaked-note -Session s -Summary "saw $tokenShape" -Action "rotate $tokenShape" -Repo CRM
        $shown=@(& $ev -Root $aliases -Find 'leaked note')-join' '
        Assert-That 'Find output masks credential shapes in every field' ($shown-match'leaked-note: saw <masked>'-and!$shown.Contains('ghp_'))
        # Diagnostics name paths: a token-shaped data root never prints intact (missing and damaged journals).
        $tokenRoot=Join-Path $t $tokenShape
        $missingOut=@(& pwsh -NoProfile -File $ev -Root $tokenRoot -Find 'anything')-join' '
        [void][IO.Directory]::CreateDirectory((Join-Path $tokenRoot 'events'));[IO.File]::WriteAllText((Join-Path $tokenRoot 'events/events.jsonl'),"{torn`n")
        $damagedOut=@(& pwsh -NoProfile -File $ev -Root $tokenRoot -Brief)-join' '
        Assert-That 'unavailable and incomplete diagnostics mask a token-shaped root' ($missingOut-match'EVENTS_UNAVAILABLE'-and$damagedOut-match'EVENTS_INCOMPLETE'-and!($missingOut+$damagedOut).Contains('ghp_'))
        $here=@(Push-Location $t;try{git init -q 'repo-auto' 2>&1|Out-Null;Push-Location 'repo-auto';try{& $ev -Root $aliases -Add -Pattern auto-repo -Session s -Summary auto}finally{Pop-Location}}finally{Pop-Location})
        $autoRow=@([IO.File]::ReadAllLines((Join-Path $aliases 'events/events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json}|Where-Object{$_.pattern-eq'auto-repo'})
        Assert-That 'Add fills Repo from the current git root' ($here-match'EVENT RECORDED'-and$autoRow.Count-eq1-and$autoRow[0].repo-ceq'repo-auto')
        if($EvidenceProbeOnly){if($fail){throw 'EVENTS_EVIDENCE_PROBE_FAILED'};'EVENTS_EVIDENCE_PROBE PASS';return}
    }
    $expression='$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw ''ORVION_DATA_ROOT_NOT_ABSOLUTE''};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace''[\\/]hooks$'','''') -Parent) -Parent) ''ORVION-Owner-Tools''})'
    $drift=@(foreach($tool in 'Events','Spider','Pulse','Coordinator','Delegate','Sync-Sessions'){if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot "$tool.ps1")).Contains('[string]$Root='+$expression)){$tool}})+@(if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Watch-Subagents.ps1')).Contains('[string]$EventRoot='+$expression)){'Watch-Subagents'})+@(if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Hunt.ps1')).Contains('[string]$DataRoot='+$expression)){'Hunt'})
    $drift+=@(if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Backup-Workspace.ps1')).Contains('$ownerTools='+$expression)){'Backup-Workspace'})
    $drift+=@(if(![IO.File]::ReadAllText((Join-Path $PSScriptRoot 'hooks\Watch-Reminder.ps1')).Contains('$dataRoot='+$expression)){'Watch-Reminder'})
    Assert-That "every data tool carries the one identical data-root default$(if($drift.Count){' (drifted: '+($drift-join', ')+')'})" (!$drift.Count)
    # Default evaluation must refuse before either PowerShell or .NET can resolve a relative store.
    # A copied library and explicit fixture profile keep a reverted guard safe to exercise.
    $layout=Join-Path $t 'relative-roots';$checkout=Join-Path $layout 'ORVION-Workbench';$copy=Join-Path $checkout 'lib'
    [void][IO.Directory]::CreateDirectory($copy)
    Copy-Item (Join-Path $PSScriptRoot '*') $copy -Recurse
    [void][IO.Directory]::CreateDirectory((Join-Path $layout 'ORVION-Owner-Tools\events'))
    $relativeCases=@(
        @{tool='Events';arguments=@('-Brief')},
        @{tool='Spider';arguments=@('fixture')},
        @{tool='Pulse';arguments=@()},
        @{tool='Coordinator';arguments=@('-Brief')},
        @{tool='Delegate';arguments=@('-List')},
        @{tool='Watch-Subagents';arguments=@('-Session','fixture','-Once')},
        @{tool='Sync-Sessions';arguments=@('-Quiet','-ClaudeProjects',(Join-Path $t 'no-claude'),'-CodexSessions',(Join-Path $t 'no-codex'))},
        @{tool='Backup-Workspace';arguments=@('-Destination',(Join-Path $t 'relative-backup'),'-AllowUnencrypted','-SkipLegacy')},
        @{tool='Hunt';arguments=@('-Quick','-NoRecord')},
        @{tool='hooks\Watch-Reminder';arguments=@()}
    )
    foreach($case in $relativeCases|Where-Object{!$RelativeTool-or$_.tool-eq$RelativeTool}){foreach($launch in 'a','b'){
        $launchRoot=Join-Path $t ("launch-$($case.tool.Replace('\','-'))-$launch")
        [void][IO.Directory]::CreateDirectory($launchRoot)
        # A reverted Pulse/Hunt guard must not discover live runs or read their logs.
        $launcher=Join-Path $launchRoot 'invoke-tool.ps1'
        $arguments=@(foreach($argument in $case.arguments){if($argument-match'^-[A-Za-z]+$'){$argument}else{"'"+$argument.Replace("'","''")+"'"}})
        $toolPath=(Join-Path $copy ($case.tool+'.ps1')).Replace("'","''")
        $launchText=@'
$ErrorActionPreference='Stop'
function Get-CimInstance{param([string]$ClassName,[string]$Filter) if($ClassName-eq'Win32_OperatingSystem'){[pscustomobject]@{FreePhysicalMemory=1000000;FreeVirtualMemory=2000000}}}
'@
        [IO.File]::WriteAllText($launcher,$launchText+"`n& '$toolPath' "+($arguments-join' ')+"`nexit `$LASTEXITCODE`n")
        $info=[Diagnostics.ProcessStartInfo]::new((Get-Command pwsh -CommandType Application|Select-Object -First 1).Source)
        $info.UseShellExecute=$false;$info.CreateNoWindow=$true;$info.WorkingDirectory=$launchRoot
        $info.RedirectStandardOutput=$true;$info.RedirectStandardError=$true;$info.RedirectStandardInput=$true
        $info.Environment['USERPROFILE']=Join-Path $t 'profile'
        $info.Environment['ORVION_DATA_ROOT']='relative-store'
        foreach($argument in @('-NoProfile','-File',$launcher)){$info.ArgumentList.Add($argument)}
        $child=[Diagnostics.Process]::new();$child.StartInfo=$info
        try{
            [void]$child.Start();$stdout=$child.StandardOutput.ReadToEndAsync();$stderr=$child.StandardError.ReadToEndAsync()
            # Invalid input also bounds the hook if its try-path guard is deliberately reverted.
            $child.StandardInput.Write('{fixture-invalid');$child.StandardInput.Close()
            if(!$child.WaitForExit(15000)){throw 'RELATIVE_ROOT_FIXTURE_TIMEOUT'}
            $out=$stdout.GetAwaiter().GetResult();$err=$stderr.GetAwaiter().GetResult();$code=$child.ExitCode
        }finally{$child.Dispose()}
        $refused=if($case.tool-eq'hooks\Watch-Reminder'){
            $code-eq0-and$out-eq''-and@($err.TrimEnd()-split'\r?\n').Count-eq1-and$err-match'^WATCH_REMINDER_UNREADABLE: ORVION_DATA_ROOT_NOT_ABSOLUTE;'
        }else{$code-ne0-and($out+$err)-match'ORVION_DATA_ROOT_NOT_ABSOLUTE'}
        Assert-That "$($case.tool) rejects relative environment root from launch $launch without a relative store" ($refused-and!(Test-Path -LiteralPath (Join-Path $launchRoot 'relative-store'))-and!(Test-Path -LiteralPath (Join-Path $checkout 'relative-store')))
    }}
    if($RootProbeOnly){if($fail){throw 'EVENTS_ROOT_PROBE_FAILED'};'EVENTS_ROOT_PROBE PASS';return}
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
    $gh=Join-Path $t 'gh';$copy=Join-Path $gh 'ORVION-Workbench\lib';[void][IO.Directory]::CreateDirectory($copy);Copy-Item $ev,(Join-Path $PSScriptRoot 'Sync-Sessions.ps1') $copy  # Events masks with the archive's rules
    $null=& $ev -Root (Join-Path $gh 'ORVION-Owner-Tools') -Add -Pattern sibling-store-marker -Session s9 -Summary 'found in the sibling data store' -Tags 'siblingmarker'
    $null=& $ev -Root (Join-Path $t 'env store') -Add -Pattern env-store-marker -Session s9 -Summary 'found through ORVION_DATA_ROOT' -Tags 'siblingmarker'
    $savedRoot=$env:ORVION_DATA_ROOT
    try{$env:ORVION_DATA_ROOT=$null;$sib=@(& pwsh -NoProfile -File (Join-Path $copy 'Events.ps1') -Find 'siblingmarker')
        $env:ORVION_DATA_ROOT=(Join-Path $t 'env store')+'\';$viaEnv=@(& pwsh -NoProfile -File (Join-Path $copy 'Events.ps1') -Find 'siblingmarker')}finally{$env:ORVION_DATA_ROOT=$savedRoot}
    Assert-That 'default root finds the sibling data store; ORVION_DATA_ROOT overrides it' (($sib-join' ')-match'sibling-store-marker'-and($viaEnv-join' ')-match'env-store-marker'-and($viaEnv-join' ')-notmatch'sibling-store-marker')
    # A Hijri-calendar culture (ar-SA) must not leak into stored timestamps: readers parse them as Gregorian UTC.
    $hijri=Join-Path $t 'hijri';& pwsh -NoProfile -Command "[Globalization.CultureInfo]::CurrentCulture='ar-SA';& '$($ev.Replace("'","''"))' -Root '$($hijri.Replace("'","''"))' -Add -Pattern locale-check -Summary 'calendar'"|Out-Null
    $stamp=([IO.File]::ReadAllLines((Join-Path $hijri 'events\events.jsonl'))[0]|ConvertFrom-Json -DateKind String).at
    Assert-That 'timestamps stay Gregorian UTC under an ar-SA culture' ("$stamp".StartsWith([DateTime]::UtcNow.ToString('yyyy',[Globalization.CultureInfo]::InvariantCulture)))
}finally{$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}
if($fail){throw "EVENTS_SELFCHECK_FAILED $fail"};'EVENTS_SELFCHECK PASS'
