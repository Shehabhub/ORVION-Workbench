# Self-check for Save-State.ps1 in a test root (WORKBENCH_TEST_ROOT, else TEMP): the four printed lines, NOW.md as the
# Markdown guard accepts it, carry-over, pending decisions, the LOG line, the status page from a plan fixture, the vault
# continuity copy, and each refusal leaving NOW.md, LOG.md, the page and the vault untouched; then one mutant per
# refusal, each of which a case must kill. The checkout is read for citations only.
param([string]$SaveState=(Join-Path $PSScriptRoot 'Save-State.ps1'),[switch]$NoMutants,[string]$Case)
$ErrorActionPreference='Stop'
. (Join-Path (Split-Path $SaveState -Parent) 'Test-MarkdownConsistency.ps1')
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$parent=if($env:WORKBENCH_TEST_ROOT){$env:WORKBENCH_TEST_ROOT}else{$env:TEMP}
if(![IO.Path]::IsPathFullyQualified($parent)){throw 'SAVE_TEST_ROOT_REQUIRED'}
# Get-Item expands a short (8.3) TEMP such as C:\Users\MYLAB~1 to the long names Save-State's -Check prints.
[void][IO.Directory]::CreateDirectory($parent);$parent=(Get-Item -LiteralPath $parent).FullName
$scratch=Join-Path $parent ('ss-'+[guid]::NewGuid().ToString('N').Substring(0,8))
[void][IO.Directory]::CreateDirectory($scratch)
$checkout=Split-Path $PSScriptRoot -Parent;$script:passed=0;$nl=[string][char]10
# Citations are built from $s, so this file cites no section itself (the guard reads it).
$s=' section'
$planText=@(
    '# WS-099 plan: a fixture','','Status: in force.','','## 6. Now and next','','| Rank | Step | Why |','| --- | --- | --- |'
    '| 1 | P2 Build | first |','| 2 | P3 Check | then |','','## 7. Roadmap','','Batch note.','','| Batch | Steps | Same files | Run by | Ends with | Why here |','| --- | --- | --- | --- | --- | --- |'
    '| B1 Build | P2 | `a` | Sonnet | a save | first |','| B2 Check | P3, P4 | none | Codex | a save | then |','','## 3. Steps','','### Done','','| Step | Output |','| --- | --- |'
    '| P1 | `out` |','','### P2 Build','','A note.','','| Step | Do | Run by | Time |','| --- | --- | --- | --- |','| P2 | build | Opus | 1 h |','| P3 | check | Opus | 2 h |','| P4 | later | Haiku | 3 h |',''
)-join$nl
function New-SaveFixture([string]$Name){
    $root=Join-Path $scratch $Name;$work=[IO.Path]::Combine($root,'temporary','sb','W33')
    foreach($path in $work,(Join-Path $root 'vault')){[void][IO.Directory]::CreateDirectory($path)}
    [IO.File]::WriteAllText((Join-Path $work 'PLAN.md'),$planText)
    [pscustomobject]@{Data=(Join-Path $root 'data');Temporary=(Join-Path $root 'temporary');Vault=(Join-Path $root 'vault');Work=$work}
}
function Invoke-Save($Fixture,[hashtable]$Given=@{},[string]$Script=$SaveState){
    $arguments=@{Operation='P1.5 S2 part 1';Done='Save-State built.';Evidence=@('lib/README.md');Next='Next step';RunBy='Claude main: Opus, high'
        Checkout=$checkout;DataRoot=$Fixture.Data;Temporary=$Fixture.Temporary;Vault=$Fixture.Vault}
    foreach($key in $Given.Keys){$arguments[$key]=$Given[$key]}
    return @(& $Script @arguments)
}
function Get-SaveText($Fixture,[string]$Path){
    $file=if($Path-eq'NOW'){Join-Path $Fixture.Data 'work/NOW.md'}else{Join-Path $Fixture.Work $Path}
    if(Test-Path -LiteralPath $file){[IO.File]::ReadAllText($file)}else{''}
}
function Get-VaultState($Fixture){
    # Every vault file with its SHA256, so a refused save that touched the continuity copy shows.
    @(Get-ChildItem -LiteralPath $Fixture.Vault -Recurse -File -Force|ForEach-Object{"$([IO.Path]::GetRelativePath($Fixture.Vault,$_.FullName))=$((Get-FileHash -LiteralPath $_.FullName).Hash)"}|Sort-Object)-join'|'
}
function Get-SaveSnapshot($Fixture){(@('NOW','LOG.md','status.html'|ForEach-Object{Get-SaveText $Fixture $_})+(Get-VaultState $Fixture))-join'|'}
function Assert-Save([bool]$Condition,[string]$What){if(!$Condition){throw "SAVE_ASSERT: $What"}}
function Assert-Unchanged($Fixture,[scriptblock]$Refused){
    # Runs the refused save; NOW.md, LOG.md, the page and the vault must be byte-identical afterwards, then the refusal is passed on.
    $before=Get-SaveSnapshot $Fixture
    try{& $Refused}catch{$message=$_.Exception.Message
        Assert-Save ((Get-SaveSnapshot $Fixture)-ceq$before) 'a refused save wrote';throw $message}
}
function New-MismatchSave([string]$Name){
    # A copy that alters each file it writes, injected into a copy of the script under test, stands in for a file
    # written to during the copy.
    $source=[IO.File]::ReadAllText($SaveState);$anchor='[IO.File]::Copy($copy[1],$target)';if(!$source.Contains($anchor)){throw 'SAVE_INJECTION_STALE'}
    $folder=Join-Path $scratch $Name;[void][IO.Directory]::CreateDirectory($folder)
    Copy-Item -LiteralPath (Join-Path (Split-Path $SaveState -Parent) 'Test-MarkdownConsistency.ps1') -Destination $folder
    $injected=Join-Path $folder 'Save-State.ps1';[IO.File]::WriteAllText($injected,$source.Replace($anchor,$anchor+";[IO.File]::AppendAllText(`$target,'x')"),[Text.UTF8Encoding]::new($false))
    $injected
}
function Test-PlanRefusal([string]$Name,[scriptblock]$Edit){
    # A good save first, then the plan file is broken as $Edit says and the next save must refuse without writing.
    $f=New-SaveFixture $Name;$null=Invoke-Save $f $first
    [IO.File]::WriteAllText((Join-Path $f.Work 'PLAN.md'),(& $Edit $planText))
    Assert-Unchanged $f {Invoke-Save $f}
}
$first=@{Workstream='WS-033';Question=@('Which one?');Pointer=@('lib/README.md');Running=@('a process')}
$cases=[ordered]@{
    positive=@('',{$f=New-SaveFixture 'positive';$out=Invoke-Save $f $first;$now=Get-SaveText $f 'NOW'
        Assert-Save ($out.Count-eq4) 'four lines'
        Assert-Save ($out[0]-ceq"STATUS_PAGE $(Join-Path $f.Work 'status.html') steps=4 done=1 now=P2 plan=$((Get-FileHash -LiteralPath (Join-Path $f.Work 'PLAN.md')).Hash.Substring(0,8))") "page line: $($out[0])"
        Assert-Save ($out[1]-cmatch '^SAVED \d{4}-\d\d-\d\dT\d\d:\d\d:\d\dZ \(\d\d:\d\d Cairo\) WS-033 P1\.5 S2 part 1  NOW\.md (\d+) B  continuity copy verified$') "SAVED line: $($out[1])"
        Assert-Save ([int]$Matches[1]-eq[Text.Encoding]::UTF8.GetByteCount($now)) 'SAVED bytes'
        Assert-Save ($out[2]-ceq'/compact Keep: WS-033 P1.5 S2 part 1 done. Next = Next step. Open owner questions: Which one? Times in Cairo. English only.') "compact: $($out[2])"
        Assert-Save ($out[3]-ceq'Resume. NOW.md is already loaded; do not re-read it. Next: Next step. Run by: Claude main: Opus, high. Save after the step and give the compact line and resume message. Times in Cairo. English only.') "resume: $($out[3])"
        Assert-Save ((Test-NowMarkdown $checkout $now).Result-ceq'NOW_MARKDOWN PASS') 'guard'
        foreach($part in "# NOW WS-033$nl","## 1. Now$nl${nl}WS-033 P1.5 S2 part 1 done.$nl","Evidence:$nl- lib/README.md$nl","## 4. Owner questions$nl$nl- Which one?$nl","## 6. Running$nl$nl- a process$nl","## 7. Pointers$nl$nl- lib/README.md$nl"){Assert-Save $now.Contains($part) "NOW.md part $part"}
        $log=(Get-SaveText $f 'LOG.md').Split($nl)|Where-Object{$_.StartsWith('- ')}
        Assert-Save (@($log).Count-eq1-and$log-cmatch '^- \d{4}-\d\d-\d\dT\d\d:\d\d:\d\dZ P1\.5 S2 part 1: Save-State built\. Evidence: lib/README\.md\. Next: Next step\.$') "LOG: $log"})
    page=@('',{$f=New-SaveFixture 'page';$null=Invoke-Save $f $first;$page=Get-SaveText $f 'status.html'
        foreach($part in '<title>WS-099 plan</title>','<p class="status">Status: in force.</p>','<p>1 of 4 steps done</p>','<tr class="now"><td data-label="Rank">1</td>',
            '<tr class="next"><td data-label="Rank">2</td>','<tr class="done" data-step="P1">','<td data-label="Output"><code>out</code></td>','<p class="note">A note.</p>',
            '<tr class="now" data-step="P2">','<tr class="next" data-step="P3">','<tr class="pending" data-step="P4">','<p class="note">Batch note.</p>',
            '<details class="batch is-now" data-families="opus sonnet" open><summary><b>B1 Build</b>','<details class="batch" data-families="opus haiku codex"><summary><b>B2 Check</b>','<span><b>Same files</b><code>a</code></span>',
            '<tr class="now"><td class="id">P2</td><td class="st"><span class="chip">Now</span></td><td data-label="Do">build</td><td data-label="Run by">Opus</td><td data-label="Time">1 h</td></tr>',
            '<tr class="pending"><td class="id">P4</td><td class="st"><span class="chip">Pending</span></td><td data-label="Do">later</td><td data-label="Run by">Haiku</td><td data-label="Time">3 h</td></tr>'){Assert-Save $page.Contains($part) "page part $part"}
        Assert-Save ($page.IndexOf('<h2>Now and next</h2>')-lt$page.IndexOf('<h2>Roadmap</h2>')-and$page.IndexOf('<h2>Roadmap</h2>')-lt$page.IndexOf('<h2>Steps</h2>')) 'queue, batches, steps'
        # G07, G08: -Check compares without writing and skips the one stamped line; a hand edit or a changed plan is stale.
        $file=Join-Path $f.Work 'status.html';$check={@(& $SaveState -Check -Temporary $f.Temporary)}
        Assert-Save $page.Contains('<!-- generated by lib/Save-State.ps1 from PLAN.md; do not edit -->') 'page marker'
        $seen=@(& $check);Assert-Save (!$seen.Count) "fresh page stale: $seen"
        [IO.File]::WriteAllText($file,($page-replace'<p class="meta">Generated [^<]*','<p class="meta">Generated at another time'));$seen=@(& $check);Assert-Save (!$seen.Count) "stamp compared: $seen"
        [IO.File]::WriteAllText($file,$page.Replace('A note.','An edit.'));$seen=@(& $check);Assert-Save (($seen-join'|')-ceq"GENERATED STALE: $file") "hand edit: $seen"
        Assert-Save ([IO.File]::ReadAllText($file).Contains('An edit.')) 'Check wrote the page';[IO.File]::WriteAllText($file,$page)
        [IO.File]::WriteAllText((Join-Path $f.Work 'PLAN.md'),$planText.Replace('A note.','A newer note.'));$seen=@(& $check);Assert-Save (($seen-join'|')-ceq"GENERATED STALE: $file") "changed plan: $seen"})
    continuity=@('',{$f=New-SaveFixture 'continuity';[void][IO.Directory]::CreateDirectory((Join-Path $f.Data 'events'))
        [IO.File]::WriteAllText((Join-Path $f.Data 'events/events.jsonl'),"{}$nl")
        foreach($path in 'notes/a.txt','s/x','t/x','tmp/x','sx/keep.txt'){$file=Join-Path $f.Work $path;[void][IO.Directory]::CreateDirectory((Split-Path $file -Parent));[IO.File]::WriteAllText($file,$path)}
        [void][IO.Directory]::CreateDirectory((Join-Path $f.Vault 'continuity/old'));[IO.File]::WriteAllText((Join-Path $f.Vault 'continuity/old/stale.txt'),'stale')
        $null=Invoke-Save $f $first;$copy=Join-Path $f.Vault 'continuity'
        $sources=[ordered]@{'data/work/NOW.md'=(Join-Path $f.Data 'work/NOW.md');'data/events/events.jsonl'=(Join-Path $f.Data 'events/events.jsonl')}
        foreach($name in 'LOG.md','PLAN.md','status.html','notes/a.txt','sx/keep.txt'){$sources["sb/W33/$name"]=Join-Path $f.Work $name}
        $found=@(Get-ChildItem -LiteralPath $copy -Recurse -File -Force|ForEach-Object{[IO.Path]::GetRelativePath($copy,$_.FullName).Replace('\','/')}|Sort-Object)
        Assert-Save (($found-join'|')-ceq(@($sources.Keys|Sort-Object)-join'|')) "continuity holds $($found-join', ')"
        foreach($name in $sources.Keys){Assert-Save ((Get-FileHash -LiteralPath (Join-Path $copy $name)).Hash-ceq(Get-FileHash -LiteralPath $sources[$name]).Hash) "hash $name"}
        Assert-Save ((@(Get-ChildItem -LiteralPath $f.Vault -Force).Name-join'|')-ceq'continuity') 'only continuity/ in the vault'})
    readOnlyCopy=@('',{$f=New-SaveFixture 'readonly';$file=Join-Path $f.Work 'sx/locked.txt';[void][IO.Directory]::CreateDirectory((Split-Path $file -Parent))
        [IO.File]::WriteAllText($file,'git object');[IO.File]::SetAttributes($file,[IO.FileAttributes]::ReadOnly)
        try{$null=Invoke-Save $f $first;$null=Invoke-Save $f @{Operation='op 2'}}finally{[IO.File]::SetAttributes($file,[IO.FileAttributes]::Normal)}
        Assert-Save ((@(Get-ChildItem -LiteralPath $f.Vault -Force).Name-join'|')-ceq'continuity') 'a read-only file in the old copy does not stop the next save'})
    carryForward=@('',{$f=New-SaveFixture 'carry';$null=Invoke-Save $f $first;$null=Invoke-Save $f @{Operation='op 2'};$now=Get-SaveText $f 'NOW'
        foreach($part in "# NOW WS-033$nl","## 4. Owner questions$nl$nl- Which one?$nl","## 6. Running$nl${nl}None.$nl","## 7. Pointers$nl$nl- lib/README.md$nl"){Assert-Save $now.Contains($part) "carried $part"}
        Assert-Save (@((Get-SaveText $f 'LOG.md').Split($nl)|Where-Object{$_.StartsWith('- ')}).Count-eq2) 'two LOG lines'
        Assert-Save ([IO.File]::ReadAllText((Join-Path $f.Vault 'continuity/data/work/NOW.md'))-ceq$now) 'continuity holds the second NOW.md'})
    nextFirstSentence=@('',{$f=New-SaveFixture 'sentence';$out=Invoke-Save $f ($first+@{Next='Do P1.5 S3 now. Then read more.'})
        Assert-Save ($out[2]-clike'* Next = Do P1.5 S3 now. Open owner questions: *'-and$out[3]-clike'* Next: Do P1.5 S3 now. Run by: *') 'first sentence only'
        Assert-Save ((Get-SaveText $f 'NOW').Contains("## 3. Next$nl${nl}Do P1.5 S3 now. Then read more.$nl")) 'whole Next in NOW.md'})
    clearQuestions=@('',{$f=New-SaveFixture 'clear';$null=Invoke-Save $f $first;$out=Invoke-Save $f @{Question=@()}
        Assert-Save ((Get-SaveText $f 'NOW').Contains("## 4. Owner questions$nl${nl}None.$nl")-and$out[2]-cnotmatch 'Open owner') 'cleared'})
    pending=@('',{$f=New-SaveFixture 'pending';[void][IO.Directory]::CreateDirectory($f.Data);$inbox=Join-Path $f.Data 'decisions-inbox.md'
        [IO.File]::WriteAllText($inbox,"# Inbox$nl$nl## 2026-11-01 19:00 Cairo: keep the vault small$nl${nl}The owner's words.$nl")
        $null=Invoke-Save $f $first;$now=Get-SaveText $f 'NOW'
        Assert-Save ($now.Contains("## 5. Pending decisions$nl$nl- 2026-11-01 19:00 Cairo: keep the vault small$nl")-and!$now.Contains("owner's words")) 'pending'
        Assert-Save ((Get-FileHash -LiteralPath (Join-Path $f.Vault 'continuity/data/decisions-inbox.md')).Hash-ceq(Get-FileHash -LiteralPath $inbox).Hash) 'inbox in continuity'})
    blocker=@('',{$f=New-SaveFixture 'blocker';$out=Invoke-Save $f ($first+@{Blocker='a test fails'})
        Assert-Save ((Get-SaveText $f 'NOW').Contains("$nl${nl}WS-033 P1.5 S2 part 1 BLOCKED: a test fails.$nl")) 'Now'
        Assert-Save ($out[2]-clike'/compact Keep: WS-033 P1.5 S2 part 1 BLOCKED: a test fails. Next = *') 'compact'
        Assert-Save ((Get-SaveText $f 'LOG.md').TrimEnd()-clike'* BLOCKED: a test fails.') 'LOG'})
    wrapped=@('',{$f=New-SaveFixture 'wrapped';$long=(1..60|ForEach-Object{"word$_"})-join' '
        $null=Invoke-Save $f @{Workstream='WS-033';Done=$long;Question=@($long)};$null=Invoke-Save $f;$now=Get-SaveText $f 'NOW'
        Assert-Save (!@($now.Split($nl)|Where-Object{$_.Length-gt120}).Count) 'wrapped at 120'
        Assert-Save (($now-replace "$nl  ",' ').Contains("- $long$nl")) 'long question carried whole'})
    workstreamRequired=@('SAVE_WORKSTREAM_REQUIRED',{$f=New-SaveFixture 'required';Assert-Unchanged $f {Invoke-Save $f}})
    workstreamFormat=@('SAVE_WORKSTREAM_FORMAT',{$f=New-SaveFixture 'format';Assert-Unchanged $f {Invoke-Save $f @{Workstream='WS-33'}}})
    folderMissing=@('SAVE_WORKSTREAM_FOLDER_MISSING',{$f=New-SaveFixture 'folder';Assert-Unchanged $f {Invoke-Save $f @{Workstream='WS-034'}}})
    evidenceMissing=@('SAVE_EVIDENCE_MISSING',{$f=New-SaveFixture 'evidence';$null=Invoke-Save $f $first;Assert-Unchanged $f {Invoke-Save $f @{Evidence=@('lib/absent.ps1')}}})
    guardRefusal=@('MD_NOW_POINTERS',{$f=New-SaveFixture 'guard';$null=Invoke-Save $f $first;Assert-Unchanged $f {Invoke-Save $f @{Pointer=@(1..9|ForEach-Object{'lib/README.md'})}}})
    citationRefusal=@('MD_SECTION_MISSING',{$f=New-SaveFixture 'citation';Assert-Unchanged $f {Invoke-Save $f ($first+@{Next="Read WORKSPACE-LAYOUT.md$s 99"})}})
    vaultMissing=@('SAVE_VAULT_MISSING',{$f=New-SaveFixture 'vault';$null=Invoke-Save $f $first;Assert-Unchanged $f {Invoke-Save $f @{Vault=(Join-Path $f.Vault 'absent')}}})
    planMissing=@('SAVE_PLAN_MISSING',{$f=New-SaveFixture 'plan';$null=Invoke-Save $f $first;Assert-Unchanged $f {Invoke-Save $f @{Plan=(Join-Path $f.Work 'absent.md')}}})
    planCodeSpan=@('SAVE_PLAN_CODE_SPAN',{Test-PlanRefusal 'span' {param($p)$p.Replace('Status: in force.','Status: in `force.')}})
    planTableUnreadable=@('SAVE_PLAN_TABLE_UNREADABLE',{Test-PlanRefusal 'unreadable' {param($p)$p.Replace("| Rank | Step | Why |$nl| --- | --- | --- |","| Rank | Step | Why |$nl| x | y | z |")}})
    planTableShape=@('SAVE_PLAN_TABLE_SHAPE',{Test-PlanRefusal 'shape' {param($p)$p.Replace('| P4 | later | Haiku | 3 h |','| P4 | later | Haiku | 3 h | extra |')}})
    planSections=@('SAVE_PLAN_SECTIONS',{Test-PlanRefusal 'sections' {param($p)$p.Replace('## 6. Now and next','## 7. Now and next')}})
    planStepHeader=@('SAVE_PLAN_STEP_HEADER',{Test-PlanRefusal 'header' {param($p)$p.Replace('| Step | Do |','| Item | Do |')}})
    planStepTwice=@('SAVE_PLAN_STEP_TWICE',{Test-PlanRefusal 'twice' {param($p)$p.Replace('| P4 | later | Haiku | 3 h |',"| P4 | later | Haiku | 3 h |$nl| P3 | again | Opus | 1 h |")}})
    planSection6Table=@('SAVE_PLAN_SECTION_6_TABLE',{Test-PlanRefusal 'six' {param($p)$p.Replace("| 2 | P3 Check | then |$nl","| 2 | P3 Check | then |$nl$nl| A | B |$nl| --- | --- |$nl| a | b |$nl")}})
    planSection6Header=@('SAVE_PLAN_SECTION_6_HEADER',{Test-PlanRefusal 'sixHeader' {param($p)$p.Replace('| Rank | Step | Why |','| Rank | Item | Why |')}})
    planSection6Step=@('SAVE_PLAN_SECTION_6_STEP',{Test-PlanRefusal 'sixStep' {param($p)$p.Replace('| 2 | P3 Check | then |','| 2 | P1 Done | then |')}})
    planSection7=@('SAVE_PLAN_SECTION_7_TABLE',{Test-PlanRefusal 'seven' {param($p)$p.Replace('## 7. Roadmap','## 8. Roadmap')}})
    planSection7Table=@('SAVE_PLAN_SECTION_7_TABLE',{Test-PlanRefusal 'sevenTable' {param($p)$p.Replace("| B2 Check | P3, P4 | none | Codex | a save | then |$nl","| B2 Check | P3, P4 | none | Codex | a save | then |$nl$nl| A | B |$nl| --- | --- |$nl| a | b |$nl")}})
    planSection7Header=@('SAVE_PLAN_SECTION_7_HEADER',{Test-PlanRefusal 'sevenHeader' {param($p)$p.Replace('| Batch | Steps | Same files |','| Batch | Items | Same files |')}})
    planBatchNoSteps=@('SAVE_PLAN_BATCH_NO_STEPS',{Test-PlanRefusal 'batchEmpty' {param($p)$p.Replace('| B1 Build | P2 |','| B1 Build | none |')}})
    planBatchStep=@('SAVE_PLAN_BATCH_STEP',{Test-PlanRefusal 'batchStep' {param($p)$p.Replace('| B1 Build | P2 |','| B1 Build | P2, P1 |')}})
    planStepNoBatch=@('SAVE_PLAN_STEP_NO_BATCH',{Test-PlanRefusal 'stepAlone' {param($p)$p.Replace('| B2 Check | P3, P4 |','| B2 Check | P3 |')}})
    planStepColumn=@('SAVE_PLAN_STEP_COLUMN',{Test-PlanRefusal 'stepColumn' {param($p)$p.Replace('| Step | Do | Run by | Time |','| Step | Do | Run by | Hours |')}})
    planControl=@('SAVE_PLAN_CONTROL_CHARACTER',{Test-PlanRefusal 'control' {param($p)$p.Replace('A note.',"A note$([char]1).")}})
    continuityMismatch=@('SAVE_CONTINUITY_MISMATCH',{$f=New-SaveFixture 'mismatch';$null=Invoke-Save $f $first
        # The previous continuity copy must stay whole and no staging folder may remain.
        $injected=New-MismatchSave 'injected';$before=Get-VaultState $f
        try{$null=Invoke-Save $f @{} $injected}finally{Assert-Save ((Get-VaultState $f)-ceq$before) 'the previous continuity copy changed'}})
    continuityRestore=@('SAVE_CONTINUITY_MISMATCH',{$f=New-SaveFixture 'restore'
        # F1: a stop between the two moves leaves continuity.old as the only whole copy; the next save restores it first,
        # so even a refused save leaves it whole.
        $old=[IO.Path]::Combine($f.Vault,'continuity.old','kept');[void][IO.Directory]::CreateDirectory($old);[IO.File]::WriteAllText((Join-Path $old 'a.txt'),'last whole copy')
        $injected=New-MismatchSave 'restoreInjected';$kept=[IO.Path]::Combine($f.Vault,'continuity','kept','a.txt')
        try{$null=Invoke-Save $f $first $injected}finally{Assert-Save ((Test-Path -LiteralPath $kept)-and!(Test-Path -LiteralPath (Join-Path $f.Vault 'continuity.old'))-and[IO.File]::ReadAllText($kept)-ceq'last whole copy') 'the leftover continuity.old was not restored'}})
    planStore=@('',{$f=New-SaveFixture 'store';$plan=Join-Path $f.Temporary 'PLAN-elsewhere.md';[IO.File]::WriteAllText($plan,$planText)
        $null=Invoke-Save $f @{Workstream='WS-034';Plan=$plan};$w34=[IO.Path]::Combine($f.Temporary,'sb','W34')
        Assert-Save ([IO.File]::ReadAllText((Join-Path $w34 'plan.txt'))-ceq$plan) 'a given plan starts a new workstream folder and is remembered'
        $null=Invoke-Save $f @{Operation='op 2'}
        Assert-Save (@((Get-SaveText $f '../W34/LOG.md').Split($nl)|Where-Object{$_.StartsWith('- ')}).Count-eq2) 'the remembered plan serves the next save'
        [void][IO.Directory]::CreateDirectory([IO.Path]::Combine($f.Temporary,'sb','W35'));$null=Invoke-Save $f @{Workstream='WS-035'}
        Assert-Save (Test-Path -LiteralPath ([IO.Path]::Combine($f.Temporary,'sb','W35','status.html'))) 'the previous workstream plan serves a folder without one'})
    evidenceSplit=@('',{$f=New-SaveFixture 'split';$null=Invoke-Save $f ($first+@{Evidence=@('lib/README.md, lib/Save-State.ps1')})
        Assert-Save ((Get-SaveText $f 'NOW').Contains("Evidence:$nl- lib/README.md$nl- lib/Save-State.ps1$nl")) 'a comma-joined Evidence string is split'})
    moveRetry=@('',{$f=New-SaveFixture 'retry';$null=Invoke-Save $f $first;$held=Join-Path $f.Vault 'continuity/data/work/NOW.md'
        # A child process holds one file of the continuity copy open, as OneDrive does, for the seconds given.
        $hold={param([int]$Seconds)$ready=Join-Path $scratch ('held-'+[guid]::NewGuid().ToString('N'))
            $child=Start-Process pwsh -PassThru -WindowStyle Hidden -ArgumentList @('-NoProfile','-Command',"`$s=[IO.File]::Open('$held','Open','Read','Read');[IO.File]::WriteAllText('$ready','');Start-Sleep -Seconds $Seconds;`$s.Dispose()")
            while(!(Test-Path -LiteralPath $ready)){if($child.HasExited){throw 'SAVE_TEST_HOLD_FAILED'};Start-Sleep -Milliseconds 100};$child}
        $child=& $hold 3;try{$null=Invoke-Save $f @{Operation='op 2'}}finally{$child.WaitForExit()}
        Assert-Save ([IO.File]::ReadAllText($held).Contains('op 2')) 'held for 3 s, the save waits and completes'
        $whole=(Get-FileHash -LiteralPath $held).Hash;$failed=$false;$child=& $hold 15
        try{$null=Invoke-Save $f @{Operation='op 3'}}catch{$failed=$true}finally{$child.WaitForExit()}
        Assert-Save ($failed-and(Get-FileHash -LiteralPath $held).Hash-ceq$whole) 'held past five tries, the save fails and continuity stays whole'})
}
try{
    foreach($caseName in $cases.Keys){
        if($Case-and$caseName-cne$Case){continue}
        $failure='';try{& $cases[$caseName][1]}catch{$failure=$_.Exception.Message}
        $expected=$cases[$caseName][0]
        if(($expected-and$failure-notmatch$expected)-or(!$expected-and$failure)){throw "FAIL $caseName expected '$expected', observed '$failure'"}
        $script:passed++;"PASS $caseName"
    }
    if(!$NoMutants-and!$Case){
        $source=[IO.File]::ReadAllText($SaveState)
        $mutants=[ordered]@{
            workstreamRequired="throw 'SAVE_WORKSTREAM_REQUIRED'";workstreamFormat='throw "SAVE_WORKSTREAM_FORMAT: $Workstream"'
            folderMissing='throw "SAVE_WORKSTREAM_FOLDER_MISSING: $folder; give -Plan to start it"';evidenceMissing='throw "SAVE_EVIDENCE_MISSING: $path"'
            guardRefusal='$guarded=Test-NowMarkdown $Checkout $text'
            vaultMissing='throw "SAVE_VAULT_MISSING: $Vault"';planMissing='throw "SAVE_PLAN_MISSING: $Plan"'
            planCodeSpan='throw "SAVE_PLAN_CODE_SPAN: $s"';planTableUnreadable='throw "SAVE_PLAN_TABLE_UNREADABLE: $where"'
            planTableShape='throw "SAVE_PLAN_TABLE_SHAPE: $where row $($b.Rows[$r][0])"'
            planSections='throw "SAVE_PLAN_SECTIONS: $PlanPath needs a title, a Status line and sections 3 and 6"'
            planStepHeader='throw "SAVE_PLAN_STEP_HEADER: $($p.Title)"';planStepTwice='throw "SAVE_PLAN_STEP_TWICE: $id"'
            planSection6Table="throw 'SAVE_PLAN_SECTION_6_TABLE'";planSection6Header="throw 'SAVE_PLAN_SECTION_6_HEADER'"
            planSection6Step='throw "SAVE_PLAN_SECTION_6_STEP: $($t6.Rows[$r][1])"';planControl="throw 'SAVE_PLAN_CONTROL_CHARACTER'"
            planSection7="throw 'SAVE_PLAN_SECTION_7_TABLE'";planSection7Table="throw 'SAVE_PLAN_SECTION_7_TABLE'";planSection7Header="throw 'SAVE_PLAN_SECTION_7_HEADER'"
            planBatchNoSteps='throw "SAVE_PLAN_BATCH_NO_STEPS: $($t7.Rows[$r][0])"';planBatchStep='throw "SAVE_PLAN_BATCH_STEP: $id"';planStepNoBatch='throw "SAVE_PLAN_STEP_NO_BATCH: $id"'
            planStepColumn='throw "SAVE_PLAN_STEP_COLUMN: $($Entry.Row[0]) has no $Like column"'
            continuityRestore='if(!(Test-Path -LiteralPath $continuity)-and(Test-Path -LiteralPath $previous)){Move-Folder $previous $continuity}'
            planStore='$Plan=[IO.File]::ReadAllText($store).Trim();break'
            evidenceSplit='$Evidence=@($Evidence|ForEach-Object{$_-split'',''}|ForEach-Object{$_.Trim()}|Where-Object{$_})'
            moveRetry='Start-Sleep -Seconds 2'
            continuityMismatch='if($differ.Count){Remove-Copy $stage;throw "SAVE_CONTINUITY_MISMATCH: $($differ-join'', '')"}'
            readOnlyCopy='$_.IsReadOnly=$false'
        }
        $folder=Join-Path $scratch 'mutants';[void][IO.Directory]::CreateDirectory($folder)
        Copy-Item -LiteralPath (Join-Path (Split-Path $SaveState -Parent) 'Test-MarkdownConsistency.ps1') -Destination $folder
        foreach($caseName in $mutants.Keys){
            $anchor=$mutants[$caseName];if(!$source.Contains($anchor)){throw "SAVE_MUTANT_STALE: $caseName"}
            $mutant=Join-Path $folder 'Save-State.ps1';[IO.File]::WriteAllText($mutant,$source.Replace($anchor,'$null=$null'),[Text.UTF8Encoding]::new($false))
            $output=& pwsh -NoProfile -File $PSCommandPath -SaveState $mutant -NoMutants -Case $caseName 2>&1
            if($LASTEXITCODE-eq0-or($output-join$nl)-notmatch("FAIL "+$caseName+" expected")){throw "SAVE_MUTANT_SURVIVED: $caseName $output"}
            $script:passed++;"PASS MUTANT KILLED $caseName"
        }
    }
    "SAVE_STATE_TESTS PASS: $script:passed assertions"
}finally{$null=Remove-OrvionOwnedTree -Path $scratch -AllowedRoots @($parent)}
