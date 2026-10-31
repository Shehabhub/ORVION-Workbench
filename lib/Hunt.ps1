# The hunting dogs: bug and gap hunters for this workspace. Each hound checks something that must always hold, or
# that must fail when broken, and reports BUG (wrong) or GAP (missing); every finding is recorded as an event
# (source hunter) so Pulse, Events -Find and the Spider show it to the next agent, and work\hunt-last.txt keeps the
# last result for Pulse. Read-only except that log, the events log, temp folders and, with -DeletionReadiness, its
# report work\deletion-readiness.json.
#   invariants  archived transcripts are still a prefix of their source; index rows match their files; event
#               evidence paths exist; lessons whose raw session is not archived; every declared decision
#               supersession is named on both sides (C2: declared links only, no script judges meaning)
#   readiness   opt-in -DeletionReadiness <inputs.json>: C1 deletion/placement readiness (see Test-DeletionReadiness)
#   live        the archiver follows while agents run; hook and Codex pointers exist; hook errors were logged
#   versioned   tool changes not committed to the tools repo
#   tested      every tool has a self-check that names it
#   mutants     known bugs planted in a temp copy of lib must make their self-check FAIL (a test that passes
#               against broken code is a gap)
#   capability  NEED (history shows a missing MCP server, hook or skill) and PRUNE (configured, never used) proposals
#   lint        PSScriptAnalyzer bug-relevant rules, when installed (known false positives listed below)
# -NoRecord suppresses events only; work\hunt-last.txt (and any C1 report) is still written in the data root.
# -Quick skips mutants and lint (about 5 s instead of about 60 s).
param([string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quick,[switch]$NoRecord,[object[]]$MutantSet,[string]$DecisionsPath,[string]$DeletionReadiness,[string]$DataRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'}),[scriptblock]$GetMapTask={Get-ScheduledTask -TaskName 'ORVION Repository Map' -ErrorAction Stop | Get-ScheduledTaskInfo -ErrorAction Stop})  # test seams
$ErrorActionPreference='Stop'
if(!$PSBoundParameters.ContainsKey('DataRoot')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $DataRoot 'events') -PathType Container)){throw 'ORVION_DATA_ROOT_UNAVAILABLE'}
. (Join-Path $PSScriptRoot 'workspace-layout.ps1')
$temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout $Root
# Sync's library binds $Root in this scope; restore the independent source root afterwards.
$sourceRoot=$Root
. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $DataRoot
$Root=$sourceRoot
$findings=[Collections.Generic.List[object]]::new()
function Add-Finding([string]$Kind,[string]$Hound,[string]$Text,[string]$Tags=''){$findings.Add([pscustomobject]@{kind=$Kind;hound=$Hound;text=$Text;tags=$Tags})}
try{$mapTaskInfo=& $GetMapTask;if(!$mapTaskInfo-or$null-eq$mapTaskInfo.LastTaskResult-or$mapTaskInfo.LastTaskResult-ne0){throw 'missing or nonzero result'}}catch{Add-Finding GAP map-task 'ORVION Repository Map task missing or last result non-zero/unreadable' 'repository map scheduled task'}
$sw=[Diagnostics.Stopwatch]::StartNew()

# invariants: an archived transcript never diverges from its source (the prefix rule Copy-Grown relies on). Only
# append-only *.jsonl transcripts: edited files (memory, meta) legitimately change and Copy-Grown sets them aside.
$raw=Join-Path $DataRoot 'sessions\raw';$cp=Join-Path $env:USERPROFILE '.claude\projects';$diverged=0;$checked=0
if(Test-Path "$raw\claude"){foreach($a in Get-ChildItem "$raw\claude" -Recurse -File -Filter *.jsonl){
    if($a.BaseName-match'\.(replaced-)?\d{14}$'){continue}
    $src=Join-Path $cp $a.FullName.Substring("$raw\claude\".Length)
    if(!(Test-Path -LiteralPath $src)){continue};$s=Get-Item -LiteralPath $src;if($s.Length-lt$a.Length){continue}
    $checked++;$in=[IO.File]::Open($src,'Open','Read','ReadWrite,Delete');try{if(!(Test-Prefix $in $a.FullName $a.Length)){$diverged++}}finally{$in.Close()}
}}
if($diverged){Add-Finding BUG archive-prefix "$diverged of $checked archived files are no longer a prefix of their source (the next pass sets them aside; find out what rewrote them)" 'archive prefix source rewritten'}
$ix=Join-Path $DataRoot 'sessions\index.jsonl';$bad=@();$ids=@{}
$indexIncomplete=$false;$indexMalformed=0;$indexReadFault=$false;$indexCheckFaults=0
try{$indexExists=Test-Path -LiteralPath $ix -ErrorAction Stop}catch{$indexExists=$true;$indexReadFault=$true}
if($indexExists){
    try{if($indexReadFault){throw 'index path unreadable'};$indexLines=[IO.File]::ReadAllLines($ix)}catch{$indexReadFault=$true;$indexIncomplete=$true;$indexLines=@()}
    foreach($l in $indexLines){
        if([string]::IsNullOrWhiteSpace($l)){continue}
        try{
            $r=$l|ConvertFrom-Json -DateKind String -NoEnumerate
            if($r-isnot[pscustomobject]-or$r.id-isnot[string]-or[string]::IsNullOrWhiteSpace($r.id)-or$r.raw-isnot[string]-or[string]::IsNullOrWhiteSpace($r.raw)){throw 'invalid index row'}
            $p=Join-Path $DataRoot $r.raw
        }catch{$indexMalformed++;$indexIncomplete=$true;continue}
        $ids[$r.id]=1
        try{
            if(!(Test-Path -LiteralPath $p -PathType Leaf)){$bad+="$($r.id): raw file missing";continue}
            $f=Get-Item -LiteralPath $p;$idle=([DateTime]::UtcNow-$f.LastWriteTimeUtc).TotalMinutes-ge20
            if($idle-and($r.bytes-ne$f.Length-or$r.metaBytes-ne$f.Length)){$bad+="$($r.id): index says $($r.bytes)/$($r.metaBytes) bytes, file has $($f.Length)"}
        }catch{$indexCheckFaults++;$indexIncomplete=$true}
    }
    if($indexIncomplete){
        $indexDiagnostic=if($indexReadFault){'row count unknown (index file read failed)'}else{"$indexMalformed malformed row(s)$(if($indexCheckFaults){"; $indexCheckFaults raw file check(s) unreadable"})"}
        Add-Finding BUG index-unreadable $indexDiagnostic 'index session unreadable malformed'
    }
}else{$indexIncomplete=$true;Add-Finding GAP index-missing 'sessions\index.jsonl does not exist (run Sync-Sessions.ps1)'}
if($bad){Add-Finding BUG index-consistency "$($bad.Count) idle index rows disagree with their files, first: $($bad[0])" 'index session bytes stale'}
$evLog=Join-Path $DataRoot 'events\events.jsonl'
$events=@(if(Test-Path $evLog){[IO.File]::ReadAllLines($evLog)|Where-Object{$_}|ForEach-Object{try{$_|ConvertFrom-Json}catch{$null=$_}}|Where-Object{$_}})
$torn=@(if(Test-Path $evLog){[IO.File]::ReadAllLines($evLog)|Where-Object{$_}|Where-Object{try{$o=$_|ConvertFrom-Json;!($o.pattern-and$o.at)}catch{$true}}}).Count
if($torn){Add-Finding BUG events-corrupt "$torn line(s) of events\events.jsonl are not valid events (skipped by every reader; repair or remove them)" 'events log corrupt torn line'}
foreach($lg in 'sync-errors.log'){$p=Join-Path $DataRoot "work\$lg";if((Test-Path $p)-and(Get-Item $p).Length){Add-Finding BUG $lg.Replace('.log','') "the session archiver logged $(@(Get-Content $p).Count) failure(s); last: $(@(Get-Content $p -Tail 1)[0])" 'archive sync error file failed'}}
# Current evidence follows the latest nonempty citation, even when later assignment metadata has none.
# Stable timestamp ordering makes the last appended record win ties without rewriting journal history.
$currentEvidence=@($events|Where-Object{![string]::IsNullOrWhiteSpace($_.evidence)}|Group-Object pattern|ForEach-Object{@($_.Group|Sort-Object at -Stable)[-1]})
$missingEv=@($currentEvidence|Where-Object{$_.evidence-match'^(?:[A-Za-z]:\\|work\\|sessions\\|lib\\)'}|Where-Object{
    $e=$_.evidence-replace'\s*\(.*$','';!(Test-Path -LiteralPath $e)-and!(Test-Path -LiteralPath (Join-Path $(if($e-match'^(work|sessions)\\'){$DataRoot}else{$Root}) $e))-and!(Test-Path -LiteralPath (Join-Path (Join-Path $env:USERPROFILE 'Documents') $e))}|ForEach-Object pattern|Select-Object -Unique)
if($missingEv){Add-Finding GAP event-evidence "evidence path missing for: $($missingEv-join', ')" 'event evidence path missing'}
# a session already recorded as lost to the 30-day cleanup is a known, accepted loss, not a new gap
$lost=@($events|Where-Object{"$($_.evidence) $($_.summary)"-match'deleted by (the )?30-day cleanup'}|ForEach-Object session)
$orphan=@(if(!$indexIncomplete){$events|Where-Object{$_.session-and$_.session-notlike'hunter-*'-and!$ids[$_.session]-and$_.session-notin$lost}|ForEach-Object session|Select-Object -Unique})
# C2: "Dn supersedes/amends/reopens Dm" and "Dm ... superseded/amended/revised/reopened ... by Dn" each need both
# sections to name the other. A missing record is a GAP; an unreadable one is a BUG, never a clean result.
# Owned here, so a caller's variables of the same name (an in-process & invocation) never reach the closure guard.
$decisions=@{};$c1=$null
if(!$DecisionsPath){$DecisionsPath=Join-Path $DataRoot 'records\delegation-20261026\DECISIONS.md'}
if(!(Test-Path -LiteralPath $DecisionsPath -PathType Leaf)){Add-Finding GAP decision-record-missing "no decision record at $DecisionsPath`: supersession back-pointers unchecked" 'decision record missing supersession'}
else{try{
    $decisions=@{};foreach($m in [regex]::Matches([IO.File]::ReadAllText($DecisionsPath),'(?ms)^## (D\d+)\b.*?(?=^## D\d+\b|\z)')){$decisions[$m.Groups[1].Value]+=$m.Value}
    if(!$decisions.Count){throw 'no decision headings'}
    $unpaired=@(@(foreach($n in $decisions.Keys){
        foreach($m in [regex]::Matches($decisions[$n],'(?i)(?<!\bD\d+\s)\b(?:supersedes|amends|reopens)\s+(D\d+)\b')){$o=$m.Groups[1].Value;if(!$decisions.ContainsKey($o)-or$decisions[$o]-notmatch"\b$n\b"){"$n->$o"}}
        foreach($m in [regex]::Matches($decisions[$n],'(?i)\b(?:superseded|amended|revised|reopened)\b[^.;()\r\n]{0,60}?\bby\s+(D\d+)')){$o=$m.Groups[1].Value;if(!$decisions.ContainsKey($o)-or$decisions[$o]-notmatch"\b$n\b"){"$o->$n"}}
    })|Sort-Object -Unique)
    if($unpaired){Add-Finding BUG decision-backpointer "$($unpaired.Count) declared supersession(s) not named on both sides (newer->older): $($unpaired-join', ')" 'decision supersession back-pointer'}
}catch{Add-Finding BUG decision-record-unreadable "decision record $DecisionsPath unreadable: $($_.Exception.Message)" 'decision record unreadable'}}
if($orphan){Add-Finding GAP lesson-raw-missing "$($orphan.Count) session(s) behind recorded lessons are not in the archive (deleted before it existed or not yet synced): $(($orphan|ForEach-Object{$_.Substring(0,[Math]::Min(8,$_.Length))})-join', ')" 'lesson session raw missing archive'}

# live
$agents=[bool](Get-Process -Name claude,codex -ErrorAction SilentlyContinue)
$follower=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'"|Where-Object{$_.CommandLine-match'Sync-Sessions\.ps1.*-Follow'})
if($agents-and!$follower){Add-Finding BUG archiver-down 'agents are running but no Sync-Sessions -Follow process: sessions are not being preserved' 'archiver follower down sessions'}
$us=Join-Path $env:USERPROFILE '.claude\settings.json'
if(Test-Path $us){foreach($m in [regex]::Matches([IO.File]::ReadAllText($us),'-File \\"([^\\"]+\.ps1)\\"')){if(!(Test-Path -LiteralPath $m.Groups[1].Value)){Add-Finding BUG hook-path "a Claude hook runs a script that does not exist: $($m.Groups[1].Value)" 'hook settings path missing'}}}
$cx=Join-Path $env:USERPROFILE '.codex\AGENTS.md'
if((Test-Path $cx)-and([IO.File]::ReadAllText($cx)-notmatch'Pulse\.ps1')){Add-Finding GAP codex-pointer 'Codex global AGENTS.md no longer points to Pulse/Events: Codex agents will not see the lessons' 'codex agents pointer instructions'}
$he=Join-Path $DataRoot 'work\hook-errors.log'
if((Test-Path $he)-and(Get-Item $he).Length){Add-Finding BUG hook-errors "the session hook logged $(@(Get-Content $he).Count) error(s); last: $(@(Get-Content $he -Tail 1)[0])" 'hook error session start'}

# versioned
if(Test-Path (Join-Path $Root '.git')){
    $dirty=@(& git -C $Root status --porcelain 2>&1);if($LASTEXITCODE){Add-Finding BUG tools-git "git cannot read the tools repo: $dirty"}
    elseif($dirty){Add-Finding GAP tools-uncommitted "$($dirty.Count) tool change(s) not committed (not versioned, not in a clone): $(($dirty|Select-Object -First 4)-join'; ')" 'tools repo uncommitted versioning'}
}else{Add-Finding GAP tools-unversioned 'the tools folder is not a git repository'}

# tested: each tool is named by at least one self-check (or is a hook/fixture/test itself)
$lib=$PSScriptRoot;$testText=(Get-ChildItem $lib -File -Filter '*.ps1'|Where-Object Name -cmatch '^test-'|ForEach-Object{[IO.File]::ReadAllText($_.FullName)})-join"`n"
# exempt with the reason they are trusted without a self-check; anything new must have one
$exempt=@{'apply-draft-steps.ps1'='proven by every contract rehearsal (step blobs reproduce)';'Invoke-DraftSteps.ps1'='proven by every Draft generation';'Invoke-DraftRehearsal.ps1'='is itself a full lifecycle rehearsal';'Test-ContractReview.ps1'='is itself a review check, run per contract';'Test-ScriptHazards.ps1'='run by tests.ps1 on every script'}
$untested=@(Get-ChildItem $lib -File -Filter *.ps1|Where-Object{$_.Name-cnotmatch'^test-'-and!$testText.Contains($_.Name)-and!$exempt[$_.Name]}|ForEach-Object Name)
if($untested){Add-Finding GAP untested-tools "$($untested.Count) tool(s) no self-check names: $($untested-join', ')" 'untested tool self-check missing test'}

if(!$Quick){
    # mutants: plant a known bug in a temp copy; the named self-check must fail. [file, find, replace, test, what]
    $mutants=if($MutantSet){$MutantSet}else{@(  # each row needs the leading comma, or PowerShell flattens the rows into one list of strings
        ,@('Sync-Sessions.ps1','if($have-ge0-and!$same){Move-Item','if($false){Move-Item','test-sync-sessions-append.ps1','the prefix proof before an append')
        ,@('Sync-Sessions.ps1','if($i-ge0){return $pos-$n+$i+1}','if($i-ge0){return $Upto}','test-sync-sessions-append.ps1','the complete-lines-only rule')
        ,@('Sync-Sessions.ps1','-or$r.headHash-ne$head){','){','test-sync-sessions-rewrite.ps1','restarting the index row of a replaced file')
        ,@('Sync-Sessions.ps1','$edge=''(?:(?<=\\[nrt])|(?<![\w-]))''','$edge=''(?<![\w-])''','test-sync-sessions-secrets.ps1','finding a token right after a JSON \n escape')
        ,@('Sync-Sessions.ps1','if(Test-Path "$raw\claude"){foreach($p in Get-ChildItem "$raw\claude"','if(Test-Path "$ClaudeProjects"){foreach($p in Get-ChildItem "$ClaudeProjects"','test-sync-sessions-survival.ps1','indexing the archive, not the sources')
        ,@('Spider.ps1','$Line=Hide-Secret $Line','$Line=$Line','test-spider.ps1','masking credential values in snippets')
        ,@('Spider.ps1','if($LASTEXITCODE-gt1){throw','if($false){throw','test-spider.ps1','refusing a failing git read')
        ,@('Events.ps1','if($last.Count){"EVENT DUPLICATE','if($false){"EVENT DUPLICATE','test-events.ps1','duplicate refusal')
        ,@('Events.ps1','$s+=$idf[$q]*(2*(Test-WordMatch $q $v.tagWords)+(Test-WordMatch $q $v.words))/6','$s+=$idf[$q]*[int]((Test-WordMatch $q $v.words)-gt0)','test-events-retrieval.ps1','tag and exact-word ranking')
        ,@('Delegate.ps1','- You MUST NOT commit, push','- You may commit, push','test-delegate.ps1','the authority limits in every brief')
        ,@('Coordinator.ps1','elseif($z.source-eq''delegate-road''){','elseif($false){','test-coordinator.ps1','holding a dispatched item until its report returns')
        ,@('Coordinator.ps1','-Skip $(if($closed){$closed[-1]+1}else{0})','-Skip 0','test-coordinator.ps1','a reopened item needing a new owner')
        ,@('Coordinator.ps1','-or$sev-eq''high''-or$last','-or$sev-eq''high''','test-coordinator.ps1','a recurrence after a fix being material')
        ,@('Events.ps1','if($fs.ReadByte()-ne10){$lead="`n"}','if($false){$lead="`n"}','test-coordinator.ps1','closing a torn journal line before the next record')
        ,@('Delegate.ps1','-Owner $(if($next){''agent''}else{''''})','-Owner ''''','test-coordinator.ps1','handing a returned verdict back to the agent')
        ,@('Watch-Subagents.ps1','$e.message.stop_reason-eq''end_turn''','$false','test-watch-subagents.ps1','finished only on end_turn')
    )}
    $t=Join-Path ([IO.Path]::GetTempPath()) "orvion-hunt-$([guid]::NewGuid().ToString('N').Substring(0,6))"
    . (Join-Path $PSScriptRoot 'remove-owned.ps1')
    try{
        foreach($m in $mutants){
            if(Test-Path $t){$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}
            New-Item -ItemType Directory "$t\lib" -Force|Out-Null;Copy-Item "$lib\*" "$t\lib" -Recurse
            $f="$t\lib\$($m[0])";$c=[IO.File]::ReadAllText($f)
            if(!$c.Contains($m[1])){Add-Finding GAP mutant-stale "mutant for $($m[4]) no longer applies to $($m[0]) (code changed: update Hunt.ps1)" 'hunt mutant stale';continue}
            [IO.File]::WriteAllText($f,$c.Replace($m[1],$m[2]))
            $null=& pwsh -NoProfile -File "$t\lib\$($m[3])" 2>&1
            if($LASTEXITCODE-eq0){Add-Finding GAP mutant-survived "$($m[3]) still passes with $($m[4]) broken in $($m[0]): the check does not guard it" 'test mutant survived self-check weak'}
        }
    }finally{if(Test-Path $t){$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath())}}
    # capabilities: what the session history says is missing (NEED) or unused (PRUNE). Proposals only: installing or
    # removing a plugin, MCP server, hook or skill stays the owner's decision.
    $use=@{};$skillUse=@{};$gh=0;$docs=0;$sessions=@{}
    if(Test-Path $raw){foreach($f in Get-ChildItem $raw -Recurse -File -Filter *.jsonl){
        $sessions[$f.BaseName]=1
        foreach($l in [IO.File]::ReadLines($f.FullName)){
            if($l.IndexOf('"type":"tool_use"',[StringComparison]::Ordinal)-lt0-and$l.IndexOf('function_call',[StringComparison]::Ordinal)-lt0){continue}
            foreach($m in [regex]::Matches($l,'"name":"mcp__([^"]+?)__[^"]+"|"namespace":"mcp__([^"]+)"')){$k="$($m.Groups[1].Value)$($m.Groups[2].Value)";$use[$k]=1+$use[$k]}  # Claude names / Codex namespaces
            foreach($m in [regex]::Matches($l,'"name":"Skill","input":\{"skill":"([^"]+)"')){$skillUse[$m.Groups[1].Value]=1+$skillUse[$m.Groups[1].Value]}
            $gh+=[regex]::Matches($l,'"command":"[^"]*\bgh api\b').Count
            $docs+=[regex]::Matches($l,'"name":"WebFetch","input":\{"url":"https?://(?:docs\.|learn\.|developers\.|git-scm\.)').Count
        }
    }}
    $configured=[ordered]@{}  # server -> where it is configured
    foreach($r in 'CRM','ORVION'){$m=Join-Path (Split-Path $Root -Parent) "$r\.mcp.json";if(Test-Path $m){foreach($n in ((Get-Content $m -Raw|ConvertFrom-Json).mcpServers.PSObject.Properties.Name)){$configured[$n]=@($configured[$n])+"$r\.mcp.json"|Where-Object{$_}}}}
    $cxCfg=Join-Path $env:USERPROFILE '.codex\config.toml'
    if(Test-Path $cxCfg){foreach($n in (Select-String -Path $cxCfg -Pattern '^\[mcp_servers\.([^\].]+)\]'|ForEach-Object{$_.Matches[0].Groups[1].Value})){$configured["codex:$n"]='~\.codex\config.toml'}}
    if($sessions.Count-ge10){
        $idle=@($configured.Keys|Where-Object{!$use[($_-replace'^codex:','')]})
        if($idle){Add-Finding PRUNE mcp-unused "$($idle.Count) configured MCP server(s) never called in $($sessions.Count) archived transcripts (each costs context every session): $($idle-join', ')" 'mcp server unused prune context'}
    }
    if($gh-ge50-and!$configured.Contains('github')){Add-Finding NEED mcp-github "agents called gh api $gh times by hand; Claude has no GitHub MCP server (Codex has $(@($configured.Keys|Where-Object{$_-like'codex:github*'})-join', ')); a per-account server must respect CTRL-19" 'mcp github gh api'}
    $c7=[int]$use['context7']+[int]$use['claude_ai_Context7']
    if($docs-ge15-and$c7-le5){Add-Finding NEED docs-by-hand "agents fetched documentation pages by hand $docs times while Context7 (installed) was called $c7 times: surface it at the point of need" 'docs documentation context7 webfetch library'}
    $hookText=@(foreach($s in (Join-Path $env:USERPROFILE '.claude\settings.json'),(Join-Path (Split-Path $Root -Parent) 'CRM\.claude\settings.local.json'),(Join-Path (Split-Path $Root -Parent) 'ORVION\.claude\settings.local.json')){if(Test-Path $s){[IO.File]::ReadAllText($s)}})-join"`n"
    $hookText+=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'hooks\Watch-Reminder.ps1'))
    $recurring=@($events|Where-Object{$_.category-eq'failure'}|Group-Object pattern|Where-Object{@($_.Group.session|Select-Object -Unique).Count-ge2}|ForEach-Object{
        $tool=@($_.Group.tool|Where-Object{$_})[-1];$act=@($_.Group.action|Where-Object{$_})[-1]
        $toolName=if($tool){[IO.Path]::GetFileNameWithoutExtension(($tool-split'\s')[0])}else{''}
        if(!$toolName-or!$hookText.Contains($toolName)){"$($_.Name) ($(@($_.Group.session|Select-Object -Unique).Count) sessions; rule: $act)"}})
    if($recurring){Add-Finding NEED hook-candidates "lessons that recurred across sessions with no hook enforcing them at the point of action (reminders alone did not prevent the repeat): $($recurring-join' | ')" 'hook enforce recurring lesson point of action'}
    # lint: bug-relevant rules only; the listed hits were triaged as false positives on 2026-10-20
    if(Get-Module -ListAvailable PSScriptAnalyzer){
        Import-Module PSScriptAnalyzer
        $known='Events.ps1:PSReviewUnusedParameter:Brief','Invoke-ContractStage.ps1:PSReviewUnusedParameter:EntryFile','Sync-Sessions.ps1:PSReviewUnusedParameter:ClaudeProjects','Sync-Sessions.ps1:PSReviewUnusedParameter:CodexSessions','seed-events.ps1:PSReviewUnusedParameter:Root'
        $lint=@(Invoke-ScriptAnalyzer -Path $Root -Recurse -IncludeRule PSReviewUnusedParameter,PSAvoidUsingEmptyCatchBlock,PSAvoidUsingCmdletAliases,PSPossibleIncorrectComparisonWithNull,PSUseDeclaredVarsMoreThanAssignments|
            Where-Object{$_.ScriptPath-notmatch'\\(work|sessions|events)\\'}|Where-Object{"$($_.ScriptName):$($_.RuleName):$([regex]::Match($_.Message,"'([^']+)'").Groups[1].Value)"-notin$known})
        foreach($g in $lint|Group-Object RuleName){Add-Finding GAP "lint-$($g.Name.ToLower())" "$($g.Count)x $($g.Name): $(($g.Group|Select-Object -First 3|ForEach-Object{"$($_.ScriptName):$($_.Line)"})-join', ')" 'lint static analysis'}
    }else{Add-Finding GAP lint-unavailable 'PSScriptAnalyzer is not installed: Install-Module PSScriptAnalyzer -Scope CurrentUser' 'lint static analysis'}
}

# C1 deletion/placement readiness (records/audit-20261027/codex-place/AUDIT-ANSWER.md rules 1-9; rule 2 resolves only
# absolute and Documents-relative spellings and rule 6's ambiguous current reader is not judged). Reports only: it never
# deletes, moves or authorizes. Inputs (schema 1, every path fully qualified): deletionRoots, temporaryRoot, profileRoot,
# live[] and historical[] (files or directories; every line, every match; a junction or symlink inside is never followed
# and is INCOMPLETE), manifest (TSV OriginalPath,RecordPath,Bytes,SHA256; RecordPath may be relative to the manifest's
# folder), protected[] (roots whose copies carry
# package/cloud protection evidence), harmless[{source,line,target,reason}], acceptedBreaks[{target,decision}].
# PASS needs zero FAIL edges and complete coverage; anything unread is INCOMPLETE.
function Test-DeletionReadiness([string]$InputsPath){
    $edges=[Collections.Generic.List[object]]::new();$incomplete=[Collections.Generic.List[string]]::new()
    function Get-Full([string]$p){[IO.Path]::GetFullPath($p).TrimEnd('\')}
    function Test-Under([string]$p,[string]$r){$p-ieq$r-or$p.StartsWith($r+'\',[StringComparison]::OrdinalIgnoreCase)}
    try{$spec=Get-Content -LiteralPath $InputsPath -Raw -ErrorAction Stop|ConvertFrom-Json
        if($spec.schema-ne1-or!@($spec.deletionRoots).Count-or!$spec.temporaryRoot-or!$spec.profileRoot){throw 'schema 1 with deletionRoots, temporaryRoot, profileRoot required'}
        $roots=@($spec.deletionRoots|ForEach-Object{Get-Full $_});$temp=Get-Full $spec.temporaryRoot;$userProfile=Get-Full $spec.profileRoot
        # A relative path has no known base (rule 2): a relative root would silently match nothing.
        if(@(@($spec.deletionRoots)+$spec.temporaryRoot+$spec.profileRoot+@($spec.protected)+@($spec.live)+@($spec.historical)+@($spec.manifest)+@($spec.harmless|ForEach-Object source)+@($spec.acceptedBreaks|ForEach-Object target)|Where-Object{$_-and![IO.Path]::IsPathFullyQualified($_)}).Count){throw 'every input path must be fully qualified'}
        $protected=@($spec.protected|Where-Object{$_}|ForEach-Object{Get-Full $_})
        # A harmless declaration exempts one target on one source line, never every hit on that line.
        $harmless=@{};foreach($h in @($spec.harmless|Where-Object{$_})){if(!$h.reason){throw 'harmless entry without reason'};$harmless["$((Get-Full $h.source).ToUpperInvariant())|$($h.line)|$((Get-Full $h.target).ToUpperInvariant())"]=$h.reason}
        $breaks=@{};foreach($b in @($spec.acceptedBreaks|Where-Object{$_})){if(!$b.decision){throw 'accepted break without decision pointer'};$breaks[(Get-Full $b.target).ToUpperInvariant()]=$b.decision}
    }catch{return [pscustomobject]@{outcome='INCOMPLETE';edges=@();incomplete=@("inputs ${InputsPath}: $($_.Exception.Message)")}}
    $manifest=@{}
    if($spec.manifest){try{foreach($row in [IO.File]::ReadAllLines($spec.manifest)){
        if(!$row.Trim()-or$row-like'OriginalPath*'){continue};$c=$row-split"`t"
        if($c.Count-ne4-or$c[3]-cnotmatch'^[A-F0-9]{64}$'-or![IO.Path]::IsPathFullyQualified($c[0])-or!$c[1]){throw "malformed row: $row"}
        # A relative RecordPath has one known base, the manifest's folder; every row of an original listed twice is checked.
        $manifest[(Get-Full $c[0]).ToUpperInvariant()]+=@([pscustomobject]@{original=Get-Full $c[0];record=[IO.Path]::GetFullPath($c[1],[IO.Path]::GetDirectoryName($spec.manifest)).TrimEnd('\');bytes=[long]$c[2];sha256=$c[3]})
    }}catch{$incomplete.Add("manifest $($spec.manifest): $($_.Exception.Message)")}}
    # Anchors: each absolute root plus Documents-relative spellings of roots under the profile's Documents.
    $anchors=@(foreach($r in @($roots)+$temp){$r;$d=Join-Path $userProfile 'Documents';if(Test-Under $r $d){$r.Substring($d.Length-'Documents'.Length)}})
    function Add-Edge($Source,$Line,$Role,$Target,$Result,$Reason){$edges.Add([pscustomobject]@{source=$Source;line=$Line;role=$Role;target=$Target;result=$Result;reason=$Reason})}
    function Test-Copy($Source,$Line,$Role,$Target){
        $rows=@($manifest.Values|ForEach-Object{$_}|Where-Object{Test-Under $_.original $Target})
        if(!$rows){
            if((Test-Under $Target $temp)-and(Test-Path -LiteralPath $Target)){Add-Edge $Source $Line $Role $Target FAIL 'exists under temporary, but required evidence has no protected copy (permanence)'}
            else{Add-Edge $Source $Line $Role $Target FAIL 'no manifest identity for required evidence'};return}
        foreach($row in $rows){
            $why=$null
            if(@($roots+$temp|Where-Object{Test-Under $row.record $_}).Count){$why='copy lies inside a deletion/temporary root (protection)'}
            elseif(!(Test-Path -LiteralPath $row.record -PathType Leaf)){$why='manifest copy missing'}
            elseif((Get-Item -LiteralPath $row.record).Length-ne$row.bytes-or(Get-FileHash -LiteralPath $row.record).Hash-cne$row.sha256){$why='manifest copy bytes/SHA256 differ'}
            elseif((Test-Path -LiteralPath $row.original -PathType Leaf)-and(Get-FileHash -LiteralPath $row.original).Hash-cne$row.sha256){$why='original differs from its supposedly identical copy'}
            elseif(!@($protected|Where-Object{Test-Under $row.record $_}).Count){$why='copy has no protection evidence (protection)'}
            if($why){Add-Edge $Source $Line $Role $row.original FAIL $why}else{Add-Edge $Source $Line $Role $row.original PASS "protected copy $($row.record) $($row.sha256)"}
        }
        # A junction or symlink inside a cited directory is never followed and is an omission, as for declared inputs.
        if((Test-Path -LiteralPath $Target -PathType Container)){foreach($f in Get-ChildItem -LiteralPath $Target -Recurse -Force){if($f.LinkType-in'Junction','SymbolicLink'){$incomplete.Add("$Role ${Source}:$Line cited $($f.FullName): $($f.LinkType) to $($f.LinkTarget) not followed")}elseif(!$f.PSIsContainer-and!$manifest.ContainsKey((Get-Full $f.FullName).ToUpperInvariant())){Add-Edge $Source $Line $Role $f.FullName FAIL 'file in cited directory has no manifest identity'}}}
    }
    foreach($group in @(@('LIVE',$spec.live),@('HISTORICAL',$spec.historical))){
        $role=$group[0]
        foreach($entry in @($group[1]|Where-Object{$_})){
            $files=try{if(Test-Path -LiteralPath $entry -PathType Container){$items=@(Get-ChildItem -LiteralPath $entry -Recurse -Force -ErrorAction Stop)
                    # Recursion does not enter a junction or symlink: each one is an omission, never silently complete.
                    foreach($link in @($items|Where-Object LinkType -in 'Junction','SymbolicLink')){$incomplete.Add("$role input $($link.FullName): $($link.LinkType) to $($link.LinkTarget) not followed")}
                    @($items|Where-Object{!$_.PSIsContainer-and$_.LinkType-notin'Junction','SymbolicLink'}|ForEach-Object FullName)}elseif(Test-Path -LiteralPath $entry -PathType Leaf){@($entry)}else{throw 'missing'}}catch{$incomplete.Add("$role input ${entry}: $($_.Exception.Message)");continue}
            foreach($file in $files){
                $source=Get-Full $file
                try{$lines=[IO.File]::ReadAllLines($source)}catch{$incomplete.Add("$role input ${source}: unreadable");continue}
                for($i=0;$i-lt$lines.Count;$i++){
                    # JSON escapes (also nested ones), slashes, file:/// and \\?\ prefixes, MSYS //c/ drives and
                    # $env:USERPROFILE/${env:USERPROFILE}/$HOME/$env:HOME/${HOME}/%USERPROFILE%/~ spellings.
                    $text=$lines[$i].Replace('/','\')-replace'\\{2,}','\'-replace'(?i)\bfile:\\+(?=[a-z]:)|\\+\?\\(?=[a-z]:)',''-replace'(?<=^|[\s"''(=,;\[])\\{1,2}([A-Za-z])(?=\\)','$1:'-replace'(?i)\$\{?env:USERPROFILE\}?|%USERPROFILE%|\$\{?(?:env:)?HOME\b\}?|(?<![\w~])~(?=\\)',$userProfile.Replace('$','$$')
                    foreach($anchor in $anchors){
                        foreach($m in [regex]::Matches($text,'(?i)(?<![\w\\])'+[regex]::Escape($anchor)+'(?![\w-])(?:\\[^"''`<>|*?\s,;)\]]*)?')){
                            $raw=$m.Value.TrimEnd('.','\');try{$target=if([IO.Path]::IsPathFullyQualified($raw)){Get-Full $raw}else{Get-Full (Join-Path $userProfile $raw)}}catch{$incomplete.Add("$role ${source}:$($i+1) unparsable path $raw");continue}
                            $key="$($source.ToUpperInvariant())|$($i+1)|$($target.ToUpperInvariant())"
                            if($harmless.ContainsKey($key)){Add-Edge $source ($i+1) $role $target PASS "HARMLESS: $($harmless[$key])";continue}
                            # The match ends at the first stop character; every stop character except " < > | * ? (which no
                            # file name holds) may still belong to the cited name, so the class is closed by construction:
                            # after any run of them (any Unicode whitespace , ; ' ) ] backtick), INCOMPLETE, never a PASS or
                            # FAIL for the shortened prefix, when the next token is path-like (\ or .ext) or an existing
                            # sibling is named "<leaf><run><next>...". Checked before the target-only accepted-break lookup,
                            # so a break on a prefix never exempts a longer cited path (only a line-keyed HARMLESS does).
                            try{$cut=[regex]::Match($text.Substring($m.Index+$m.Length),'^([\s,;'')\]`]+)([^"''`<>|*?\s,;)\]]*)');$sep=$cut.Groups[1].Value;$next=$cut.Groups[2].Value
                                $space=$sep-match'^ +$';$sibling="$(Split-Path $target -Leaf)$sep$next*"
                                $continues=$cut.Success-and(!$space-or$next)-and($next-match'\\|\.\w+$'-or[bool](Get-ChildItem -LiteralPath (Split-Path $target) -Filter $sibling -Force -ErrorAction Ignore))}catch{$incomplete.Add("$role ${source}:$($i+1) $target unreadable: $($_.Exception.Message)");continue}
                            if($continues){$incomplete.Add("$role ${source}:$($i+1) $(if($space){'path continues after a space'}else{"path may continue after '$sep'"}): $target$sep$next");continue}
                            if($breaks.ContainsKey($target.ToUpperInvariant())){Add-Edge $source ($i+1) $role $target PASS "accepted break: $($breaks[$target.ToUpperInvariant()])";continue}
                            if($role-eq'LIVE'){Add-Edge $source ($i+1) $role $target FAIL $(if(Test-Under $target $temp){'live dependency left under temporary'}else{'live read/write/binding into a deletion root'})}
                            else{try{Test-Copy $source ($i+1) $role $target}catch{$incomplete.Add("$role ${source}:$($i+1) $target unreadable: $($_.Exception.Message)")}}
                        }
                    }
                }
                # A live recovery-input map's selected targets must exist with their approved digests (an item without
                # one FAILs); a live JSON that cannot be parsed or hashed is unread, not a clean map.
                if($role-eq'LIVE'-and$source-like'*.json'){try{$map=Get-Content -LiteralPath $source -Raw|ConvertFrom-Json
                    foreach($item in @($map.inputs|Where-Object{$_.path})){
                        if(!$item.sha256-or![IO.Path]::IsPathFullyQualified($item.path)-or!(Test-Path -LiteralPath $item.path -PathType Leaf)-or(Get-FileHash -LiteralPath $item.path).Hash-cne$item.sha256){Add-Edge $source 0 LIVE (Get-Full $item.path) FAIL 'selected recovery input absent, hash-changed or without an approved digest'}}
                }catch{$incomplete.Add("LIVE input ${source}: JSON unparsable or map input unreadable")}}
            }
        }
    }
    $fails=@($edges|Where-Object result -eq FAIL)
    [pscustomobject]@{outcome=$(if($incomplete.Count){'INCOMPLETE'}elseif($fails.Count){'FAIL'}else{'PASS'});edges=@($edges);incomplete=@($incomplete)}
}
$readinessLine=$null
if($DeletionReadiness){
    $c1=Test-DeletionReadiness $DeletionReadiness;$report=Join-Path $DataRoot 'work\deletion-readiness.json'
    New-Item -ItemType Directory (Join-Path $DataRoot 'work') -Force|Out-Null
    [ordered]@{schema=1;at=[DateTime]::UtcNow.ToString('o');inputs=$DeletionReadiness;outcome=$c1.outcome;incomplete=$c1.incomplete;edges=$c1.edges}|ConvertTo-Json -Depth 5|Set-Content -LiteralPath $report -Encoding utf8NoBOM
    $failCount=@($c1.edges|Where-Object result -eq FAIL).Count
    if($c1.outcome-eq'PASS'){$readinessLine="C1 PASS: $(@($c1.edges).Count) edge(s), zero unresolved, coverage complete; report $report (readiness only, never deletion authority)"}
    else{Add-Finding BUG "c1-$($c1.outcome.ToLower())" "C1 $($c1.outcome): $failCount failing edge(s), $(@($c1.incomplete).Count) unread input(s); report $report" 'deletion readiness c1 placement'}
}
$bugs=@($findings|Where-Object kind -eq BUG).Count;$gaps=@($findings|Where-Object kind -eq GAP).Count;$props=@($findings|Where-Object kind -in NEED,PRUNE).Count
$summary="HUNT $([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC$(if($Quick){' (quick)'}): $bugs bug(s), $gaps gap(s), $props capability proposal(s) in $([int]$sw.Elapsed.TotalSeconds) s"
$summary;if($readinessLine){"  $readinessLine"};$findings|ForEach-Object{"  $($_.kind) $($_.hound): $($_.text)"}
New-Item -ItemType Directory (Join-Path $DataRoot 'work') -Force|Out-Null
[IO.File]::WriteAllLines((Join-Path $DataRoot 'work\hunt-last.txt'),[string[]](@($summary)+@($readinessLine|Where-Object{$_}|ForEach-Object{"  $_"})+@($findings|ForEach-Object{"  $($_.kind) $($_.hound): $($_.text)"})))
if(!$NoRecord){foreach($x in $findings){
    $null=& (Join-Path $PSScriptRoot 'Events.ps1') -Root $DataRoot -Add -Pattern "hunt-$($x.hound)" -Source hunter -Session "hunter-$([DateTime]::UtcNow.ToString('yyyy-MM-dd'))" -Category $(if($x.kind-eq'BUG'){'failure'}elseif($x.kind-in'NEED','PRUNE'){'proposal'}else{'observation'}) -Severity $(if($x.kind-eq'BUG'){'high'}else{'warn'}) -Cause confirmed -Summary "$($x.kind): $($x.text)" -Tool 'Hunt.ps1' -Tags "hunt $($x.kind.ToLower()) $($x.tags)"
}
    # A hound that no longer finds what it reported closes its own finding; hounds -Quick skipped cannot judge, nor can
    # C2 without readable decisions or C1 that did not run (no -DeletionReadiness) or was INCOMPLETE.
    $skipped=if($Quick){'^hunt-(mutant-|lint-|mcp-|docs-|hook-candidates)'}else{'^$'}
    $now=@($findings|ForEach-Object{"hunt-$($_.hound)"})
    foreach($g in @($events|Where-Object{$_.pattern-like'hunt-*'}|Group-Object pattern)){
        if($indexIncomplete-and$g.Name-match'^hunt-(index-|lesson-raw-missing$)'){continue}
        if(($g.Name-eq'hunt-decision-backpointer'-and!$decisions.Count)-or($g.Name-like'hunt-c1-*'-and$c1.outcome-notin'PASS','FAIL')){continue}
        $z=@($g.Group|Sort-Object at)[-1]
        if($z.status-eq'open'-and$g.Name-notin$now-and$g.Name-notmatch$skipped){
            $null=& (Join-Path $PSScriptRoot 'Events.ps1') -Root $DataRoot -Add -Pattern $g.Name -Source hunter -Session "hunter-$([DateTime]::UtcNow.ToString('yyyy-MM-dd'))" -Category $z.category -Cause confirmed -Status resolved -Summary "no longer found by Hunt.ps1 ($([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC)" -Tool 'Hunt.ps1' -Tags $z.tags
        }
    }
}
exit [int]($bugs-gt0)
