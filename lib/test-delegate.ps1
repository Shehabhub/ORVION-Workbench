# Self-check for Delegate.ps1 in a temp root: the brief carries the question, the known history, the authority limits
# and the exact report and record lines; the delegation is itself an event; -List shows pending, then the verdict.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-delegcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t|Out-Null
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
    & (Join-Path $PSScriptRoot 'Events.ps1') -Root $t -Add -Pattern zebra-case -Session s1 -Category failure -Summary 'ZEBRA-42 broke once'|Out-Null
    $out=@(& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $t -Pattern zebra-case -Question 'Does ZEBRA-42 break again?' -Mode sandbox -Minutes 10)
    $briefPath=([regex]::Match(($out-join"`n"),'DELEGATED zebra-case -> (.+BRIEF\.md)')).Groups[1].Value
    $b=[IO.File]::ReadAllText($briefPath)
    Assert-That 'brief has the question and the known history' ($b.Contains('Does ZEBRA-42 break again?')-and$b.Contains('ZEBRA-42 broke once'))
    Assert-That 'brief bounds authority' ($b.Contains('MUST NOT commit, push')-and$b.Contains('Mode: **sandbox**')-and$b.Contains('10 minutes'))
    Assert-That 'brief names the exact report and record lines' ($b.Contains('VERDICT: CONFIRMED')-and$b.Contains('Do not record events')-and$b.Contains('saves your reply as')-and$b-notmatch'create ````'-and$b.Contains((Join-Path (Split-Path $briefPath) 'REPORT.md')))
    $ev=@([IO.File]::ReadAllLines((Join-Path $t 'events\events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json})
    Assert-That 'the delegation is recorded as an event' (@($ev|Where-Object{$_.source-eq'delegate-road'-and$_.summary-like'delegated (sandbox, 10 min)*'}).Count-eq1)
    Assert-That 'list shows it pending' ((@(& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $t -List)-join' ')-match'pending \(no REPORT\.md yet\)')
    Set-Content (Join-Path (Split-Path $briefPath) 'REPORT.md') "VERDICT: DISPROVEN`nCause: ..."
    Assert-That 'list shows the verdict once reported' ((@(& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $t -List)-join' ')-match'zebra-case: DISPROVEN')
    $bad=try{& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $t -Pattern 'Not Valid' -Question x|Out-Null;$false}catch{$true}
    Assert-That 'a malformed pattern id is refused' $bad
    $de=Join-Path $PSScriptRoot 'Delegate.ps1';$evPath=Join-Path $PSScriptRoot 'Events.ps1'
    $damaged=Join-Path $t 'damaged';$null=& $evPath -Root $damaged -Add -Pattern unrelated -Summary 'unrelated history'
    Add-Content (Join-Path $damaged 'events\events.jsonl') '{"torn row';Add-Content (Join-Path $damaged 'events\events.jsonl') '{}'
    $out=@(& pwsh -NoProfile -File $de -Root $damaged -Pattern damaged-case -Question 'ABSENT-97');$code=$LASTEXITCODE
    $path=([regex]::Match(($out-join"`n"),'DELEGATED damaged-case -> (.+BRIEF\.md)')).Groups[1].Value;$text=[IO.File]::ReadAllText($path)
    Assert-That 'damaged history is counted in the brief with exit 2' ($code-eq2-and$text-match'EVENTS_INCOMPLETE: 2 unreadable history record\(s\) skipped'-and$text-notmatch'nothing recorded yet')
    $indexed=Join-Path $t 'indexed';$null=& $evPath -Root $indexed -Add -Pattern unrelated -Summary 'unrelated history'
    New-Item -ItemType Directory (Join-Path $indexed 'sessions')|Out-Null;Set-Content (Join-Path $indexed 'sessions\index.jsonl') '{"torn index'
    $out=@(& pwsh -NoProfile -File $de -Root $indexed -Pattern indexed-case -Question 'ABSENT-97');$code=$LASTEXITCODE
    $path=([regex]::Match(($out-join"`n"),'DELEGATED indexed-case -> (.+BRIEF\.md)')).Groups[1].Value;$text=[IO.File]::ReadAllText($path)
    Assert-That 'incomplete related lookup remains visible in the brief with exit 2' ($code-eq2-and$text-match'(?s)Related past events.+EVENTS_INCOMPLETE:'-and$text-notmatch'none recorded')
    $out=@(& pwsh -NoProfile -File $de -Root (Join-Path $t 'absent') -Pattern absent-case -Question 'ABSENT-97');$code=$LASTEXITCODE
    $path=([regex]::Match(($out-join"`n"),'DELEGATED absent-case -> (.+BRIEF\.md)')).Groups[1].Value;$text=[IO.File]::ReadAllText($path)
    Assert-That 'unavailable history and related lookup remain visible in the brief with exit 3' ($code-eq3-and$text-match'(?s)What is already known.+EVENTS_UNAVAILABLE: no history journal'-and$text-match'(?s)Related past events.+EVENTS_UNAVAILABLE:'-and$text-notmatch'none recorded|nothing recorded yet')
    $out=@(& $de -Root $t -Pattern narrow-case -Question 'NARROW-1' -ReadRoots 'C:\only\here')
    $text=[IO.File]::ReadAllText(([regex]::Match(($out-join"`n"),'DELEGATED narrow-case -> (.+BRIEF\.md)')).Groups[1].Value)
    Assert-That 'ReadRoots narrows file and git reads of the brief' ($text.Contains('read only these roots: `C:\only\here`, and run read-only git commands (show, log, grep, rev-parse, cat-file, ls-tree, status) inside those roots only')-and!$text.Contains('every file of the workspace')-and!$text.Contains('status) in the real checkouts'))

    # Codex launcher with a fake relay in a fake GitHub folder (its temporary root beside one checkout), default watch
    # list: TEMP in its own scratch, the effort ceiling, and the outside-write tripwire.
    $savedTempRoot=$env:WORKBENCH_TEMP_ROOT;$gh=Join-Path $t 'gh';$env:WORKBENCH_TEMP_ROOT=Join-Path $gh 'ORVION-Workbench-temporary'
    try{
        . (Join-Path $PSScriptRoot 'workspace-layout.ps1');$tempRoot=Initialize-OrvionTemporaryRoot -Checkout (Split-Path $PSScriptRoot -Parent)
        $clone=Join-Path $tempRoot 'cx\ORVION-selfcheck';$null=& git init -q $clone
        $relay=Join-Path $t 'relay.mjs';$codexBrief=Join-Path $t 'selfcheck.md';Set-Content $codexBrief 'fixture brief'
        Set-Content $relay "import fs from 'fs';const a=process.argv;const o=a[a.indexOf('--out-dir')+1];fs.mkdirSync(o,{recursive:true});fs.writeFileSync(o+'/seen.txt',process.env.TEMP+'\n'+a.slice(2).join(' '));if(process.env.FAKE_ESCAPE){fs.writeFileSync(process.env.FAKE_ESCAPE,'stray '+Date.now())};process.exit(Number(process.env.FAKE_EXIT||0))"
        $repo=Join-Path $gh 'PRODUCT';$null=& git init -q $repo;$null=& git -C $repo -c user.name=fixture -c user.email=fixture@invalid commit -q --allow-empty -m fixture
        Set-Content (Join-Path $repo 'notes.txt') 'already untracked before the run'
        function Invoke-Codex([string]$Escape,[string]$ExitCode='0',[string[]]$More=@()){
            $env:FAKE_ESCAPE=$Escape;$env:FAKE_EXIT=$ExitCode
            try{$script:codexOut=@(& pwsh -NoProfile -File $de -Root $t -CodexBrief $codexBrief -Clone $clone -Relay $relay @More 2>&1)-join"`n";$LASTEXITCODE}finally{$env:FAKE_ESCAPE=$null;$env:FAKE_EXIT=$null}
        }
        $code=Invoke-Codex '' '7'
        $seen=@(Get-ChildItem (Join-Path $tempRoot 'codex-relay-logs') -Directory -Filter '*-selfcheck'|ForEach-Object{Get-Content (Join-Path $_.FullName 'seen.txt')})
        Assert-That 'a clean Codex run passes the relay exit through, with TEMP in its own scratch and the fixed flags' ($code-eq7-and$codexOut-match'CODEX_DONE relay exit 7'-and$seen[0]-like(Join-Path $tempRoot 'scratch\*-selfcheck')-and$seen[1]-match'--sandbox danger-full-access --ignore-user-config --model gpt-6.1-sol --effort medium --timeout 20m')
        $code=Invoke-Codex (Join-Path $gh 'stray.txt')
        $journal=@([IO.File]::ReadAllLines((Join-Path $t 'events\events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json}|Where-Object pattern -eq 'codex-outside-write')
        Assert-That 'a new entry beside the checkouts trips exit 4 and records a failure event' ($code-eq4-and$codexOut-match'CODEX_TRIPWIRE: 1 change'-and$journal.Count-eq1-and$journal[0].category-eq'failure')
        Remove-Item -LiteralPath (Join-Path $gh 'stray.txt')
        $code=Invoke-Codex (Join-Path $repo 'notes.txt')
        Assert-That 'rewriting an already untracked file in a sibling checkout trips exit 4' ($code-eq4-and$codexOut-match'CODEX_TRIPWIRE')
        $code=Invoke-Codex '' '0' @('-Effort','max')
        Assert-That 'effort above the owner ceiling is refused' ($code-ne0-and$codexOut-notmatch'CODEX_DONE')
        $outside=Join-Path $t 'not-cx';$null=& git init -q $outside
        $refused=@(& pwsh -NoProfile -File $de -Root $t -CodexBrief $codexBrief -Clone $outside -Relay $relay 2>&1)-join"`n"
        Assert-That 'a clone outside temporary\cx is refused' ($LASTEXITCODE-ne0-and$refused-match'CODEX_CLONE_REFUSED')
    }finally{$env:WORKBENCH_TEMP_ROOT=$savedTempRoot}
}finally{Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
if($fail){throw "DELEGATE_SELFCHECK_FAILED $fail"};'DELEGATE_SELFCHECK PASS'
