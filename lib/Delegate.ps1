# The delegation road of the improvement loop: turn an open or recurring event into a bounded investigation another
# agent can run cold, and get its verdict back into the event log.
#   Delegate.ps1 -Pattern <id> -Question '<what to prove or disprove>' [-Query '<phrase for the spider>'] [-Mode sandbox]
#       writes work\delegations\<UTC>-<pattern>\BRIEF.md (question, what is known, authority, method, report format),
#       records the delegation as an event, and prints how to launch it (a background agent: the hook adds the watchdog)
#   Delegate.ps1 -List   every delegation, newest first, with its verdict once REPORT.md exists
# Authority never grows by delegation: readonly = read the repositories, write only the delegation folder; sandbox =
# also experiment in disposable copies under the system temp folder. Never a commit, push, release, credential or
# Owner-Review edit. The verdict is evidence for the delegating agent to verify, not a decision.
[CmdletBinding(DefaultParameterSetName='brief')]
param([Parameter(ParameterSetName='brief',Mandatory)][ValidatePattern('^[a-z0-9]+(-[a-z0-9]+)*$')][string]$Pattern,
      [Parameter(ParameterSetName='brief',Mandatory)][string]$Question,
      [Parameter(ParameterSetName='brief')][string]$Query='',
      [Parameter(ParameterSetName='brief')][ValidateSet('readonly','sandbox')][string]$Mode='readonly',
      [Parameter(ParameterSetName='brief')][int]$Minutes=30,
      [Parameter(ParameterSetName='list',Mandatory)][switch]$List,
      [string]$Root=(Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference='Stop'
$base=Join-Path $Root 'work\delegations';$ev=Join-Path $PSScriptRoot 'Events.ps1'

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

$history=@(if(Test-Path (Join-Path $Root 'events\events.jsonl')){[IO.File]::ReadAllLines((Join-Path $Root 'events\events.jsonl'))|Where-Object{$_}|ForEach-Object{$_|ConvertFrom-Json}|Where-Object pattern -eq $Pattern|Sort-Object at})
$known=@($history|ForEach-Object{"- $(([datetime]$_.at).ToUniversalTime().ToString('yyyy-MM-dd')) [$($_.category), $($_.status), cause $($_.cause)] $($_.summary)$(if($_.action){" -> $($_.action)"})$(if($_.evidence){" (evidence: $($_.evidence))"})"})
$spider=if($Query){@(& (Join-Path $PSScriptRoot 'Spider.ps1') $Query -Top 3 -Root $Root)}else{@()}
$dir=Join-Path $base "$([DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))-$Pattern";New-Item -ItemType Directory $dir -Force|Out-Null
$report=Join-Path $dir 'REPORT.md'
$authority=if($Mode-eq'sandbox'){
"- You MAY create disposable copies (clones, worktrees, files) under ``$([IO.Path]::GetTempPath())`` and run experiments there, including deliberate failure injection. Delete them when done.
- You MAY read every file of the workspace and both repositories, and run read-only git commands in the real checkouts."
}else{
"- You MAY read every file of the workspace and both repositories, and run read-only git commands (show, log, grep, rev-parse, cat-file, ls-tree, status) in the real checkouts."
}
$brief=@"
# Delegated investigation: $Pattern

Brief written $([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC by the improvement loop's delegation road (``lib\Delegate.ps1``).
You start cold: everything you need is here or reachable from here. Mode: **$Mode**. Time budget: **$Minutes minutes**.

## Question
$Question

## What is already known (event history for ``$Pattern``)
$(if($known){$known-join"`n"}else{'- nothing recorded yet'})

## What the spider found$(if($Query){" for '$Query'"})
$(if($spider){'```'+"`n"+($spider-join"`n")+"`n"+'```'}else{'- not run (no -Query given)'})

## Authority (delegation never grants more)
$authority
- You MAY write only inside ``$dir``$(if($Mode-eq'sandbox'){' and your own temp copies'}).
- You MUST NOT commit, push, check out, reset or otherwise change the real checkouts (``Documents\GitHub\CRM``, ``Documents\GitHub\ORVION``, the trusted-main clones), edit ``Documents\ORVION-Owner-Review``, touch credentials (``gh auth``, tokens), call remote services that write, or start ``-Finish``.
- Prefer Read/Grep/Glob for files; use PowerShell for git and experiments. Never print environment variable values or secrets.
- Repository authority stays where it is: each repository's own Boot, contracts and Gate 1. Your result is evidence, not a decision.

## Method
1. LEARN: read what is cited above and the code it names before forming a view. Name the established way this kind of thing is checked.
2. REPRODUCE OR FALSIFY: design the smallest experiment that would prove the question either way$(if($Mode-eq'readonly'){' using reads only'}); run it; keep every command and its output.
3. MEASURE: exact numbers from real outputs; label anything you did not run as a hypothesis.
4. STOP when the question is answered, or when the time budget is spent (then report INCONCLUSIVE with what remains).

## Deliverable
Write ``$report`` with, in this order:
- ``VERDICT: CONFIRMED`` | ``VERDICT: DISPROVEN`` | ``VERDICT: INCONCLUSIVE`` (first line, exactly this form)
- Cause: confirmed or hypothesis, in one paragraph
- Evidence: the commands you ran and the decisive output lines, with file:line pointers
- Proposal: the smallest change that would fix it, in which repository or tool, and through which route (repository contract with its own Gate 1, or a workspace tool change); or "none"
- Cost and risk of the proposal

Then record the verdict in the improvement memory, one line (pick the values that match your verdict):
``pwsh -NoProfile -File "$ev" -Add -Pattern $Pattern -Source delegate -Category discovery -Cause <confirmed|hypothesis> -Status <open|disproven> -Summary '<VERDICT: one sentence>' -Evidence '$report'``
Finally reply with the VERDICT line and the report path.
"@
[IO.File]::WriteAllText((Join-Path $dir 'BRIEF.md'),$brief)
$null=& $ev -Root $Root -Add -Pattern $Pattern -Source delegate-road -Category observation -Status open -Summary "delegated ($Mode, $Minutes min): $Question" -Evidence (Join-Path $dir 'BRIEF.md')
"DELEGATED $Pattern -> $(Join-Path $dir 'BRIEF.md')"
"LAUNCH a background agent with exactly this prompt: Read `"$(Join-Path $dir 'BRIEF.md')`" and carry it out exactly as written."
"VERIFY its REPORT.md yourself before acting on it; Delegate.ps1 -List shows every delegation and verdict."
