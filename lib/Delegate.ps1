# The delegation road of the improvement loop: turn an open or recurring event into a bounded investigation another
# agent can run cold, and get its verdict back into the event log.
#   Delegate.ps1 -Pattern <id> -Question '<what to prove or disprove>' [-Query '<phrase for the spider>'] [-Mode sandbox]
#       writes work\delegations\<UTC>-<pattern>\BRIEF.md (question, what is known, authority, method, report format),
#       records the delegation as an event, and prints how to launch it (a background agent: the hook adds the watchdog)
#   Delegate.ps1 -Report <delegation folder> -Reply <file holding the delegate's reply>
#       the return road: saves the reply as REPORT.md (never overwrites), reads its VERDICT line and records the
#       verdict as the pattern's next event, owned again by the delegating agent (Coordinator.ps1 then holds it)
#   Delegate.ps1 -List   every delegation, newest first, with its verdict once REPORT.md exists
#   Delegate.ps1 -CodexBrief <brief> -Clone <temporary\cx\...> [-Effort medium] [-Model gpt-6.1-sol]
#       runs one fresh Codex relay session in a clone under temporary\cx with TEMP/TMP in its own scratch folder, and
#       compares the watched places before and after (exit 4 + a failure event on any change or unreadable snapshot)
# Authority never grows by delegation: readonly = read the repositories, write only the delegation folder; sandbox =
# also experiment in disposable copies under the system temp folder. Never a commit, push, release, credential or
# Owner-Review edit. The verdict is evidence for the delegating agent to verify, not a decision. -ReadRoots narrows the
# brief's read authority to the task; that is guidance to the delegate, not OS enforcement.
[CmdletBinding(DefaultParameterSetName='brief')]
param([Parameter(ParameterSetName='brief',Mandatory)][ValidatePattern('^[a-z0-9]+(-[a-z0-9]+)*$')][string]$Pattern,
      [Parameter(ParameterSetName='brief',Mandatory)][string]$Question,
      [Parameter(ParameterSetName='brief')][string]$Query='',
      [Parameter(ParameterSetName='brief')][ValidateSet('readonly','sandbox')][string]$Mode='readonly',
      [Parameter(ParameterSetName='brief')][int]$Minutes=30,
      [Parameter(ParameterSetName='brief')][string[]]$ReadRoots,
      [Parameter(ParameterSetName='codex',Mandatory)][string]$CodexBrief,
      [Parameter(ParameterSetName='codex',Mandatory)][string]$Clone,
      [Parameter(ParameterSetName='codex')][ValidateSet('low','medium','high','xhigh')][string]$Effort='medium',  # owner ceiling: xhigh, never max
      [Parameter(ParameterSetName='codex')][ValidateSet('gpt-6.1-sol','gpt-6.1-terra')][string]$Model='gpt-6.1-sol',
      [Parameter(ParameterSetName='codex')][ValidateRange(1,120)][int]$TimeoutMinutes=20,
      [Parameter(ParameterSetName='codex')][string]$Relay,
      [Parameter(ParameterSetName='codex')][string[]]$Watch,
      [Parameter(ParameterSetName='list',Mandatory)][switch]$List,
      [Parameter(ParameterSetName='report',Mandatory)][string]$Report,
      [Parameter(ParameterSetName='report',Mandatory)][string]$Reply,
      [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'}))
$ErrorActionPreference='Stop'
if(!$PSBoundParameters.ContainsKey('Root')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $Root 'events') -PathType Container)){
    if($List){'DELEGATIONS_UNAVAILABLE: ORVION_DATA_ROOT_UNAVAILABLE';exit 3};throw 'ORVION_DATA_ROOT_UNAVAILABLE'
}
. (Join-Path $PSScriptRoot 'workspace-layout.ps1')
$temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout (Split-Path $PSScriptRoot -Parent)
$base=Join-Path $Root 'work\delegations';$ev=Join-Path $PSScriptRoot 'Events.ps1'

if($CodexBrief){
    # Codex runs unrestricted (owner decision: its Windows sandbox is blocked), so this launcher, not the brief, checks
    # what changed outside the clone and scratch. A tripwire, not confinement: it sees new or removed entries in watched
    # folders and any change to a watched git checkout (dirty file content included), not nested edits elsewhere or
    # create-then-delete.
    $briefFile=(Resolve-Path -LiteralPath $CodexBrief).Path;$cloneDir=(Resolve-Path -LiteralPath $Clone).Path
    $cxRoot=Join-Path $temporaryRoot 'cx'
    if(!$cloneDir.StartsWith("$cxRoot\",[StringComparison]::OrdinalIgnoreCase)-or!(Test-Path -LiteralPath (Join-Path $cloneDir '.git'))){throw "CODEX_CLONE_REFUSED: $cloneDir is not a git clone under $cxRoot"}
    if(!$Relay){$Relay=Join-Path $Root 'records\delegation-20261026\delegate-review\codex-delegate@3aa72d6\scripts\relay.mjs'}
    if(!(Test-Path -LiteralPath $Relay -PathType Leaf)){throw "CODEX_RELAY_MISSING: $Relay"}
    $run="$([DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))-$([IO.Path]::GetFileNameWithoutExtension($briefFile))"
    $scratch=Join-Path $temporaryRoot "scratch\$run";$logs=Join-Path $temporaryRoot "codex-relay-logs\$run";[void][IO.Directory]::CreateDirectory($scratch)
    # the temporary root always sits beside the checkouts, wherever this script runs from
    if(!$Watch){$gitHub=Split-Path $temporaryRoot -Parent;$Watch=@("$env:SystemDrive\",$env:USERPROFILE,$gitHub)+@(Get-ChildItem -LiteralPath $gitHub -Directory|Where-Object{Test-Path -LiteralPath (Join-Path $_.FullName '.git')}|ForEach-Object FullName)}
    function Get-CodexWorld{foreach($place in $Watch){
        if(Test-Path -LiteralPath (Join-Path $place '.git')){
            $head=@(& git -C $place rev-parse HEAD 2>$null);$headCode=$LASTEXITCODE;$state=@(& git -C $place status --porcelain --untracked-files=all 2>$null)
            if($headCode-or$LASTEXITCODE){throw "CODEX_WATCH_UNREADABLE: $place"};"$place|git|$head"
            foreach($line in $state){$file=Join-Path $place $line.Substring(3).Trim('"')  # status names the path; the hash sees a rewrite of an already dirty file
                "$place|$line|$(if(Test-Path -LiteralPath $file -PathType Leaf){(Get-FileHash -LiteralPath $file).Hash})"}
        }else{"$place|.";Get-ChildItem -LiteralPath $place -Force -Name -ErrorAction Stop|ForEach-Object{"$place|$_"}}  # the marker keeps an empty folder comparable
    }}
    $before=@(Get-CodexWorld)
    $savedTemp=$env:TEMP;$savedTmp=$env:TMP;$env:TEMP=$scratch;$env:TMP=$scratch
    try{& node $Relay --brief $briefFile --cd $cloneDir --sandbox danger-full-access --ignore-user-config --model $Model --effort $Effort --timeout "${TimeoutMinutes}m" --out-dir $logs;$relayCode=$LASTEXITCODE}
    finally{$env:TEMP=$savedTemp;$env:TMP=$savedTmp}
    $after=try{@(Get-CodexWorld)}catch{@("UNREADABLE|$($_.Exception.Message)")}
    $changed=@(Compare-Object $before $after|ForEach-Object{"$($_.SideIndicator) $($_.InputObject)"})
    if($changed){
        $null=& $ev -Root $Root -Add -Pattern codex-outside-write -Source delegate-codex -Category failure -Status open -Summary "Codex run $run changed watched places: $(($changed|Select-Object -First 5)-join'; ')" -Evidence $logs -Owner agent -Action 'inspect what wrote it before any further Codex run; remove only after inspection'
        "CODEX_TRIPWIRE: $($changed.Count) change(s) outside the clone and scratch";$changed;exit 4
    }
    "CODEX_DONE relay exit $relayCode; scratch $scratch; logs $logs";exit $relayCode
}

if($Report){
    $dir=(Resolve-Path -LiteralPath $Report).Path;$name=Split-Path $dir -Leaf
    $pm=[regex]::Match($name,'^\d{8}T\d{6}Z-(?<p>[a-z0-9]+(-[a-z0-9]+)*)$')
    if(!$pm.Success-or!(Test-Path (Join-Path $dir 'BRIEF.md'))){throw "DELEGATION_UNKNOWN: $dir is not a Delegate.ps1 folder"}
    $out=Join-Path $dir 'REPORT.md';if(Test-Path $out){throw "REPORT_EXISTS: $out (a verdict is recorded once)"}
    $text=[IO.File]::ReadAllText((Resolve-Path -LiteralPath $Reply).Path)
    $m=[regex]::Match($text,'(?m)^\s*VERDICT:\s*(CONFIRMED|DISPROVEN|INCONCLUSIVE)\b')
    if(!$m.Success){throw 'REPORT_NO_VERDICT: the reply has no VERDICT: CONFIRMED|DISPROVEN|INCONCLUSIVE line; ask the delegate again'}
    [IO.File]::WriteAllText($out,$text)
    $v=$m.Groups[1].Value;$first=($text-split"`r?`n"|Where-Object{$_.Trim()}|Select-Object -Skip 1 -First 1)
    $next=@{CONFIRMED='verify the decisive check yourself, then act on the proposal';INCONCLUSIVE='decide: dispatch again with a narrower question, or defer with a date';DISPROVEN=''}[$v]
    & $ev -Root $Root -Add -Pattern $pm.Groups['p'].Value -Source delegate -Category discovery -Cause $(if($v-eq'CONFIRMED'){'confirmed'}else{'hypothesis'}) -Status $(if($v-eq'DISPROVEN'){'disproven'}else{'open'}) -Summary "VERDICT: $v. $first" -Evidence $out -Owner $(if($next){'agent'}else{''}) -Action $next
    exit 0
}

if($List){
    if(!(Test-Path $base)){'DELEGATIONS: none';exit 0}
    $d=@(Get-ChildItem $base -Directory|Sort-Object Name -Descending)
    "DELEGATIONS: $($d.Count)"
    foreach($x in $d){
        $rep=Join-Path $x.FullName 'REPORT.md'
        $v=if(Test-Path $rep){$m=Select-String -LiteralPath $rep -Pattern '^\s*VERDICT:\s*(.+)$'|Select-Object -First 1;if($m){$m.Matches[0].Groups[1].Value.Trim()}else{'REPORT without a VERDICT line'}}else{'pending (no REPORT.md yet)'}
        "  $($x.Name): $v"
    }
    exit 0
}

$log=Join-Path $Root 'events\events.jsonl';$historyBad=0
$history=@(if(Test-Path $log){[IO.File]::ReadAllLines($log)|Where-Object{$_}|ForEach-Object{try{$o=$_|ConvertFrom-Json;if(!$o.pattern-or!$o.at){throw 'invalid record'};$o}catch{$historyBad++}}|Where-Object pattern -eq $Pattern|Sort-Object at})
$known=@($history|ForEach-Object{"- $(([datetime]$_.at).ToUniversalTime().ToString('yyyy-MM-dd')) [$($_.category), $($_.status), cause $($_.cause)] $($_.summary)$(if($_.action){" -> $($_.action)"})$(if($_.evidence){" (evidence: $($_.evidence))"})"})
if($historyBad){$known+="- EVENTS_INCOMPLETE: $historyBad unreadable history record(s) skipped in $log"}
if(!(Test-Path $log)){$known+="- EVENTS_UNAVAILABLE: no history journal at $log"}
$related=@(& $ev -Root $Root -Find $Question -Top 3);$lookupCode=$LASTEXITCODE
$related=@($related|Where-Object{$_-notmatch"^EVENTS:|^EVENTS relevant|\] $([regex]::Escape($Pattern)):"})  # solved before? say so before the work starts
if($historyBad-and$lookupCode-eq0){$lookupCode=2}
$spider=if($Query){@(& (Join-Path $PSScriptRoot 'Spider.ps1') $Query -Top 3 -Root $Root)}else{@()}
$dir=Join-Path $base "$([DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))-$Pattern";New-Item -ItemType Directory $dir -Force|Out-Null
$reportPath=Join-Path $dir 'REPORT.md'
$readable=if($ReadRoots){'only these roots: '+(($ReadRoots|ForEach-Object{'`'+$_+'`'})-join', ')}else{'every file of the workspace and both repositories'}
$gitScope=if($ReadRoots){'inside those roots only'}else{'in the real checkouts'}
$authority=if($Mode-eq'sandbox'){
"- You MAY create disposable copies (clones, worktrees, files) under ``$(Join-Path $temporaryRoot 'cx\ORVION-<task>')`` and run experiments there, including deliberate failure injection. Delete them when done.
- You MAY read $readable, and run read-only git commands $gitScope."
}else{
"- You MAY read $readable, and run read-only git commands (show, log, grep, rev-parse, cat-file, ls-tree, status) $gitScope."
}
$brief=@"
# Delegated investigation: $Pattern

Brief written $([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC by the improvement loop's delegation road (``lib\Delegate.ps1``).
You start cold: everything you need is here or reachable from here. Mode: **$Mode**. Time budget: **$Minutes minutes**.

## Question
$Question

## What is already known (event history for ``$Pattern``)
$(if($known){$known-join"`n"}else{'- nothing recorded yet'})

## Related past events and how they ended (``Events.ps1 -Find`` on the question)
$(if($related){$related-join"`n"}else{'- none recorded'})

## What the spider found$(if($Query){" for '$Query'"})
$(if($spider){'```'+"`n"+($spider-join"`n")+"`n"+'```'}else{'- not run (no -Query given)'})

## Authority (delegation never grants more)
$authority
- You MAY write only inside ``$dir`` (probe scripts and their outputs)$(if($Mode-eq'sandbox'){' and your own temp copies'}).
- You MUST NOT commit, push, check out, reset or otherwise change the real checkouts (``Documents\GitHub\CRM``, ``Documents\GitHub\ORVION``, the trusted-main clones), edit ``$Root\records``, touch credentials (``gh auth``, tokens), call remote services that write, or start ``-Finish``.
- Prefer Read/Grep/Glob for files; use PowerShell for git and experiments. Never print environment variable values or secrets.
- Repository authority stays where it is: each repository's own Boot, contracts and Gate 1. Your result is evidence, not a decision.

## Method
1. LEARN: read what is cited above and the code it names before forming a view. Name the established way this kind of thing is checked.
2. REPRODUCE OR FALSIFY: design the smallest experiment that would prove the question either way$(if($Mode-eq'readonly'){' using reads only'}); run it; keep every command and its output.
3. MEASURE: exact numbers from real outputs; label anything you did not run as a hypothesis.
4. Save each probe and its raw output in ``$dir`` as you go, so the evidence survives even if you stop early.
5. STOP when the question is answered, or when the time budget is spent (then report INCONCLUSIVE with what remains).

## Deliverable
Your final reply IS the report (helper agents may not write report files; the delegating agent saves your reply as ``$reportPath``). In this order:
- ``VERDICT: CONFIRMED`` | ``VERDICT: DISPROVEN`` | ``VERDICT: INCONCLUSIVE`` (first line, exactly this form)
- Cause: confirmed or hypothesis, in one paragraph
- Evidence: the commands you ran and the decisive output lines, with file:line pointers
- Proposal: the smallest change that would fix it, in which repository or tool, and through which route (repository contract with its own Gate 1, or a workspace tool change); or "none"
- Cost and risk of the proposal

Your reply must start with the VERDICT line and contain the whole report, nothing else. Do not record events
yourself: the delegating agent records your verdict when it saves your reply (one return road, no permission prompt).
"@
[IO.File]::WriteAllText((Join-Path $dir 'BRIEF.md'),$brief)
# due = twice the budget: past it, Coordinator.ps1 reports the delegation OVERDUE (no report came back)
$null=& $ev -Root $Root -Add -Pattern $Pattern -Source delegate-road -Category observation -Status open -Summary "delegated ($Mode, $Minutes min): $Question" -Evidence (Join-Path $dir 'BRIEF.md') -Owner "delegate:$(Split-Path $dir -Leaf)" -Action 'report back' -Due ([DateTime]::UtcNow.AddMinutes(2*$Minutes).ToString('yyyy-MM-ddTHH:mm:ssZ',[Globalization.CultureInfo]::InvariantCulture))
"DELEGATED $Pattern -> $(Join-Path $dir 'BRIEF.md')"
"LAUNCH a background agent with exactly this prompt: Read `"$(Join-Path $dir 'BRIEF.md')`" and carry it out exactly as written."
"WHEN IT FINISHES: save its reply to a file, then: pwsh -NoProfile -File `"$PSCommandPath`" -Report `"$dir`" -Reply <that file>   (re-run its decisive check yourself before acting on it)"
exit $lookupCode
