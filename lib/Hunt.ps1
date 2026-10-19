# The hunting dogs: bug and gap hunters for this workspace. Each hound checks something that must always hold, or
# that must fail when broken, and reports BUG (wrong) or GAP (missing); every finding is recorded as an event
# (source hunter) so Pulse, Events -Find and the Spider show it to the next agent, and work\hunt-last.txt keeps the
# last result for Pulse. Read-only except that log, the events log and temp folders.
#   invariants  archived transcripts are still a prefix of their source; index rows match their files; event
#               evidence paths exist; lessons whose raw session is not archived
#   live        the archiver follows while agents run; hook and Codex pointers exist; hook errors were logged
#   versioned   tool changes not committed to the tools repo
#   tested      every tool has a self-check that names it
#   mutants     known bugs planted in a temp copy of lib must make their self-check FAIL (a test that passes
#               against broken code is a gap)
#   capability  NEED (history shows a missing MCP server, hook or skill) and PRUNE (configured, never used) proposals
#   lint        PSScriptAnalyzer bug-relevant rules, when installed (known false positives listed below)
# -Quick skips mutants and lint (about 5 s instead of about 60 s).
param([string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quick,[switch]$NoRecord,[object[]]$MutantSet)  # -MutantSet: test-hunt.ps1 only
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root $Root
$findings=[Collections.Generic.List[object]]::new()
function Add-Finding([string]$Kind,[string]$Hound,[string]$Text,[string]$Tags=''){$findings.Add([pscustomobject]@{kind=$Kind;hound=$Hound;text=$Text;tags=$Tags})}
$sw=[Diagnostics.Stopwatch]::StartNew()

# invariants: the archive never diverges from a source it copies (the prefix rule Copy-Grown relies on).
$raw=Join-Path $Root 'sessions\raw';$cp=Join-Path $env:USERPROFILE '.claude\projects';$diverged=0;$checked=0
if(Test-Path "$raw\claude"){foreach($a in Get-ChildItem "$raw\claude" -Recurse -File){
    if($a.BaseName-match'\.(replaced-)?\d{14}$'){continue}
    $src=Join-Path $cp $a.FullName.Substring("$raw\claude\".Length)
    if(!(Test-Path -LiteralPath $src)){continue};$s=Get-Item -LiteralPath $src;if($s.Length-lt$a.Length){continue}
    $checked++;$in=[IO.File]::Open($src,'Open','Read','ReadWrite,Delete');try{if(!(Test-Prefix $in $a.FullName $a.Length)){$diverged++}}finally{$in.Close()}
}}
if($diverged){Add-Finding BUG archive-prefix "$diverged of $checked archived files are no longer a prefix of their source (the next pass sets them aside; find out what rewrote them)" 'archive prefix source rewritten'}
$ix=Join-Path $Root 'sessions\index.jsonl';$bad=@()
if(Test-Path $ix){foreach($l in [IO.File]::ReadAllLines($ix)|Where-Object{$_}){
    $r=$l|ConvertFrom-Json;$p=Join-Path $Root $r.raw
    if(!(Test-Path -LiteralPath $p)){$bad+="$($r.id): raw file missing";continue}
    $f=Get-Item -LiteralPath $p;$idle=([DateTime]::UtcNow-$f.LastWriteTimeUtc).TotalMinutes-ge20
    if($idle-and($r.bytes-ne$f.Length-or$r.metaBytes-ne$f.Length)){$bad+="$($r.id): index says $($r.bytes)/$($r.metaBytes) bytes, file has $($f.Length)"}
}}else{Add-Finding GAP index-missing 'sessions\index.jsonl does not exist (run Sync-Sessions.ps1)'}
if($bad){Add-Finding BUG index-consistency "$($bad.Count) idle index rows disagree with their files, first: $($bad[0])" 'index session bytes stale'}
$evLog=Join-Path $Root 'events\events.jsonl'
$events=@(if(Test-Path $evLog){[IO.File]::ReadAllLines($evLog)|Where-Object{$_}|ForEach-Object{$_|ConvertFrom-Json}})
$ids=@{};if(Test-Path $ix){foreach($l in [IO.File]::ReadAllLines($ix)|Where-Object{$_}){$ids[($l|ConvertFrom-Json).id]=1}}
$missingEv=@($events|Where-Object{$_.evidence-match'^(?:[A-Za-z]:\\|work\\|sessions\\|lib\\)'}|Where-Object{
    $e=$_.evidence-replace'\s*\(.*$','';!(Test-Path -LiteralPath $e)-and!(Test-Path -LiteralPath (Join-Path $Root $e))-and!(Test-Path -LiteralPath (Join-Path (Join-Path $env:USERPROFILE 'Documents') $e))}|ForEach-Object pattern|Select-Object -Unique)
if($missingEv){Add-Finding GAP event-evidence "evidence path missing for: $($missingEv-join', ')" 'event evidence path missing'}
# a session already recorded as lost to the 30-day cleanup is a known, accepted loss, not a new gap
$lost=@($events|Where-Object{"$($_.evidence) $($_.summary)"-match'deleted by (the )?30-day cleanup'}|ForEach-Object session)
$orphan=@($events|Where-Object{$_.session-and$_.session-notlike'hunter-*'-and!$ids[$_.session]-and$_.session-notin$lost}|ForEach-Object session|Select-Object -Unique)
if($orphan){Add-Finding GAP lesson-raw-missing "$($orphan.Count) session(s) behind recorded lessons are not in the archive (deleted before it existed or not yet synced): $(($orphan|ForEach-Object{$_.Substring(0,[Math]::Min(8,$_.Length))})-join', ')" 'lesson session raw missing archive'}

# live
$agents=[bool](Get-Process -Name claude,codex -ErrorAction SilentlyContinue)
$follower=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'"|Where-Object{$_.CommandLine-match'Sync-Sessions\.ps1.*-Follow'})
if($agents-and!$follower){Add-Finding BUG archiver-down 'agents are running but no Sync-Sessions -Follow process: sessions are not being preserved' 'archiver follower down sessions'}
$us=Join-Path $env:USERPROFILE '.claude\settings.json'
if(Test-Path $us){foreach($m in [regex]::Matches([IO.File]::ReadAllText($us),'-File \\"([^\\"]+\.ps1)\\"')){if(!(Test-Path -LiteralPath $m.Groups[1].Value)){Add-Finding BUG hook-path "a Claude hook runs a script that does not exist: $($m.Groups[1].Value)" 'hook settings path missing'}}}
$cx=Join-Path $env:USERPROFILE '.codex\AGENTS.md'
if((Test-Path $cx)-and([IO.File]::ReadAllText($cx)-notmatch'Pulse\.ps1')){Add-Finding GAP codex-pointer 'Codex global AGENTS.md no longer points to Pulse/Events: Codex agents will not see the lessons' 'codex agents pointer instructions'}
$he=Join-Path $Root 'work\hook-errors.log'
if((Test-Path $he)-and(Get-Item $he).Length){Add-Finding BUG hook-errors "the session hook logged $(@(Get-Content $he).Count) error(s); last: $(@(Get-Content $he -Tail 1)[0])" 'hook error session start'}

# versioned
if(Test-Path (Join-Path $Root '.git')){
    $dirty=@(& git -C $Root status --porcelain 2>&1);if($LASTEXITCODE){Add-Finding BUG tools-git "git cannot read the tools repo: $dirty"}
    elseif($dirty){Add-Finding GAP tools-uncommitted "$($dirty.Count) tool change(s) not committed (not versioned, not in a clone): $(($dirty|Select-Object -First 4)-join'; ')" 'tools repo uncommitted versioning'}
}else{Add-Finding GAP tools-unversioned 'the tools folder is not a git repository'}

# tested: each tool is named by at least one self-check (or is a hook/fixture/test itself)
$lib=$PSScriptRoot;$testText=(Get-ChildItem $lib -File -Filter '*.ps1'|Where-Object Name -cmatch '^test-'|ForEach-Object{[IO.File]::ReadAllText($_.FullName)})-join"`n"
# exempt with the reason they are trusted without a self-check; anything new must have one
$exempt=@{'apply-draft-steps.ps1'='proven by every contract rehearsal (step blobs reproduce)';'Invoke-DraftSteps.ps1'='proven by every Draft generation';'Invoke-DraftRehearsal.ps1'='is itself a full lifecycle rehearsal';'Test-ContractReview.ps1'='is itself a review check, run per contract';'Test-ScriptHazards.ps1'='run by tests.ps1 on every script';'Watch-Subagents.ps1'='proven live on 16 agents, needs a real transcript'}
$untested=@(Get-ChildItem $lib -File -Filter *.ps1|Where-Object{$_.Name-cnotmatch'^test-'-and!$testText.Contains($_.Name)-and!$exempt[$_.Name]}|ForEach-Object Name)
if($untested){Add-Finding GAP untested-tools "$($untested.Count) tool(s) no self-check names: $($untested-join', ')" 'untested tool self-check missing test'}

if(!$Quick){
    # mutants: plant a known bug in a temp copy; the named self-check must fail. [file, find, replace, test, what]
    $mutants=if($MutantSet){$MutantSet}else{@(  # each row needs the leading comma, or PowerShell flattens the rows into one list of strings
        ,@('Sync-Sessions.ps1','if($have-ge0-and($have-gt$end-or!(Test-Prefix $in $Dst $have))){','if($false){','test-sync-sessions-append.ps1','the prefix proof before an append')
        ,@('Sync-Sessions.ps1','$nl=[Array]::LastIndexOf($buf,[byte]10,$got-1);$end=','$nl=$got-1;$end=','test-sync-sessions-append.ps1','the complete-lines-only rule')
        ,@('Sync-Sessions.ps1','if(Test-Path "$raw\claude"){foreach($p in Get-ChildItem "$raw\claude"','if(Test-Path "$ClaudeProjects"){foreach($p in Get-ChildItem "$ClaudeProjects"','test-sync-sessions-survival.ps1','indexing the archive, not the sources')
        ,@('Spider.ps1','$m.Value.Replace($m.Groups[2].Value,''<masked>'')','$m.Value','test-spider.ps1','masking credential values in snippets')
        ,@('Spider.ps1','if($LASTEXITCODE-gt1){throw','if($false){throw','test-spider.ps1','refusing a failing git read')
        ,@('Events.ps1','if($last.Count){"EVENT DUPLICATE','if($false){"EVENT DUPLICATE','test-events.ps1','duplicate refusal')
        ,@('Events.ps1','$s+=$idf[$q]*(2*(Test-WordMatch $q $v.tagWords)+(Test-WordMatch $q $v.words))/6','$s+=$idf[$q]*[int]((Test-WordMatch $q $v.words)-gt0)','test-events-retrieval.ps1','tag and exact-word ranking')
        ,@('Delegate.ps1','- You MUST NOT commit, push','- You may commit, push','test-delegate.ps1','the authority limits in every brief')
    )}
    $t=Join-Path ([IO.Path]::GetTempPath()) "orvion-hunt-$([guid]::NewGuid().ToString('N').Substring(0,6))"
    try{
        foreach($m in $mutants){
            if(Test-Path $t){Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
            New-Item -ItemType Directory "$t\lib" -Force|Out-Null;Copy-Item "$lib\*" "$t\lib" -Recurse
            $f="$t\lib\$($m[0])";$c=[IO.File]::ReadAllText($f)
            if(!$c.Contains($m[1])){Add-Finding GAP mutant-stale "mutant for $($m[4]) no longer applies to $($m[0]) (code changed: update Hunt.ps1)" 'hunt mutant stale';continue}
            [IO.File]::WriteAllText($f,$c.Replace($m[1],$m[2]))
            $null=& pwsh -NoProfile -File "$t\lib\$($m[3])" 2>&1
            if($LASTEXITCODE-eq0){Add-Finding GAP mutant-survived "$($m[3]) still passes with $($m[4]) broken in $($m[0]): the check does not guard it" 'test mutant survived self-check weak'}
        }
    }finally{if(Test-Path $t){Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}}
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

$bugs=@($findings|Where-Object kind -eq BUG).Count;$gaps=@($findings|Where-Object kind -eq GAP).Count;$props=@($findings|Where-Object kind -in NEED,PRUNE).Count
$summary="HUNT $([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC$(if($Quick){' (quick)'}): $bugs bug(s), $gaps gap(s), $props capability proposal(s) in $([int]$sw.Elapsed.TotalSeconds) s"
$summary;$findings|ForEach-Object{"  $($_.kind) $($_.hound): $($_.text)"}
New-Item -ItemType Directory (Join-Path $Root 'work') -Force|Out-Null
[IO.File]::WriteAllLines((Join-Path $Root 'work\hunt-last.txt'),[string[]](@($summary)+@($findings|ForEach-Object{"  $($_.kind) $($_.hound): $($_.text)"})))
if(!$NoRecord){foreach($x in $findings){
    $null=& (Join-Path $PSScriptRoot 'Events.ps1') -Root $Root -Add -Pattern "hunt-$($x.hound)" -Source hunter -Session "hunter-$([DateTime]::UtcNow.ToString('yyyy-MM-dd'))" -Category $(if($x.kind-eq'BUG'){'failure'}elseif($x.kind-in'NEED','PRUNE'){'proposal'}else{'observation'}) -Severity $(if($x.kind-eq'BUG'){'high'}else{'warn'}) -Cause confirmed -Summary "$($x.kind): $($x.text)" -Tool 'Hunt.ps1' -Tags "hunt $($x.kind.ToLower()) $($x.tags)"
}
    # A hound that no longer finds what it reported closes its own finding; hounds -Quick skipped cannot judge.
    $skipped=if($Quick){'^hunt-(mutant-|lint-|mcp-|docs-|hook-candidates)'}else{'^$'}
    $now=@($findings|ForEach-Object{"hunt-$($_.hound)"})
    foreach($g in @($events|Where-Object{$_.pattern-like'hunt-*'}|Group-Object pattern)){
        $z=@($g.Group|Sort-Object at)[-1]
        if($z.status-eq'open'-and$g.Name-notin$now-and$g.Name-notmatch$skipped){
            $null=& (Join-Path $PSScriptRoot 'Events.ps1') -Root $Root -Add -Pattern $g.Name -Source hunter -Session "hunter-$([DateTime]::UtcNow.ToString('yyyy-MM-dd'))" -Category $z.category -Cause confirmed -Status resolved -Summary "no longer found by Hunt.ps1 ($([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC)" -Tool 'Hunt.ps1' -Tags $z.tags
        }
    }
}
exit [int]($bugs-gt0)
