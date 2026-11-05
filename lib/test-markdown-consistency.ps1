param([string]$Guard=(Join-Path $PSScriptRoot 'Test-MarkdownConsistency.ps1'),[switch]$NoMutants,[string]$Case,[string]$RepositoryTree='Working')
$ErrorActionPreference='Stop'
. $Guard
$repositoryPins=[Collections.Generic.Dictionary[string,string]]::new($FrozenOwnerTexts,[StringComparer]::Ordinal)
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$parent=if($env:WORKBENCH_TEST_ROOT){$env:WORKBENCH_TEST_ROOT}else{$env:TEMP}
if(![IO.Path]::IsPathFullyQualified($parent)){throw 'MD_TEST_ROOT_REQUIRED'}
$scratch=Join-Path $parent ('md-'+[guid]::NewGuid().ToString('N').Substring(0,8))
[void][IO.Directory]::CreateDirectory($scratch)
$script:passed=0;$nl=[string][char]10
# Fixture citations are built from $s and $d, so this file never cites a section or DEC entry itself (the guard reads it).
$s=' section';$d='DEC-'
function Write-MarkdownFixture([string]$Path,[string]$Text){
    [void][IO.Directory]::CreateDirectory((Split-Path $Path -Parent))
    [IO.File]::WriteAllText($Path,$Text,[Text.UTF8Encoding]::new($false))
}
function Invoke-MarkdownFixtureGit([string]$Directory,[string[]]$Arguments){
    [Text.Encoding]::UTF8.GetString((Invoke-MarkdownGit $Directory $Arguments)).Trim()
}
function New-MarkdownFixture([string]$Name){
    $fixture=Join-Path $scratch $Name;[void][IO.Directory]::CreateDirectory($fixture)
    $null=Invoke-MarkdownFixtureGit $fixture @('init','--quiet')
    $seed=[ordered]@{
        'AGENTS.md'="# Arrival$nl[Start](README.md)$nl"
        'README.md'="# Purpose$nl[Governance](WORKFLOW.md) [Resume](RESUME.md) [Closure](HANDOFF.md) [Guide](docs/guide.md#section)$nl[data](data/work/NOW.md) [private](C:/private/missing.md)$nl${nl}## 1. Start$nl${nl}[Decisions](docs/DECISIONS.md) [Runbook](docs/RUNBOOK.md) [History](docs/history/README.md)$nl"
        'RESUME.md'="Active Workbench Contract: None${nl}Live state: data/work/NOW.md$nl"
        'HANDOFF.md'="# Closure$nl${nl}Unique closure boundary.$nl${nl}## 12. Criteria$nl${nl}Closure criteria.$nl"
        'docs/RUNBOOK.md'="# Runbook$nl${nl}The procedures.$nl${nl}## 1. Steps$nl${nl}Step one.$nl"
        'docs/DECISIONS.md'="# Decisions$nl${nl}Every rule, once.$nl${nl}## ${d}01 First$nl${nl}First decision.$nl${nl}Scope: all.${nl}Why: one line.${nl}Changed: 2026-11-01${nl}History: D1$nl${nl}## ${d}02 Second$nl${nl}Second decision.$nl${nl}Scope: all.${nl}Why: one line.${nl}Changed: 2026-11-01${nl}History: D2${nl}Watch: ``(?i)\bwidget\b.{0,40}\bcount\b``$nl"
        'docs/WORKSPACE-LAYOUT.md'="# Layout$nl${nl}Only this file describes storage.$nl"
        'docs/RECOVERY.md'="# Recovery$nl${nl}Only this file describes recovery.$nl"
        'docs/history/README.md'="# History$nl${nl}## History index$nl${nl}- [contract](../../changes/WS-001-history.md)$nl- [archive](archive.md)$nl"
        'lib/README.md'="# Tools$nl${nl}Only this file describes tools.$nl"
        'lib/Tool.ps1'="# Tool: WORKFLOW.md$s 1 and ${d}01.$nl"
        'changes/TEMPLATE.md'="# Template$nl${nl}Only this file describes new proposals.$nl"
        'docs/guide.md'="# Guide$nl## Section$nl[back](../README.md#purpose)$nl${nl}See WORKFLOW.md${s}s 1 and 2.1, ``docs/RUNBOOK.md``$s 1, ${d}02, signposting.md$s 5 and records/x/DECISIONS.md$s 3.$nl${nl}The widget count is 5 (${d}02).$nl"
        'changes/WS-001-history.md'="# Frozen history$nl[original packet](not-here.md)$nl"
        'docs/history/archive.md'="# Frozen archive${nl}Run Documents\ORVION-Sandbox\old.ps1 (source-bound historical instruction).$nl"
        'WORKFLOW.md'=@'
# Governance

## 1. One-home table

| Concept | Sole home |
|---|---|
| Arrival | [arrival](AGENTS.md#arrival) |
| Purpose | [purpose](README.md#purpose) |
| Active contract | [pointer](RESUME.md) |
| Batch 6 closure | [closure](HANDOFF.md#closure) |
| Decisions and rules | [decisions](docs/DECISIONS.md#decisions) |
| Procedures | [runbook](docs/RUNBOOK.md#runbook) |
| Workspace layout | [layout](docs/WORKSPACE-LAYOUT.md#layout) |
| Recovery | [recovery](docs/RECOVERY.md#recovery) |
| Tool catalogue | [tools](lib/README.md#tools) |
| Contract template | [template](changes/TEMPLATE.md#template) |

## 2. Notes

### 2.1 Detail

Workflow notes.
'@
    }
    foreach($path in $seed.Keys){Write-MarkdownFixture (Join-Path $fixture $path) $seed[$path]}
    return $fixture
}
function Edit-MarkdownFixture([string]$Directory,[string]$Path,[string]$Before,[string]$After){
    $absolute=Join-Path $Directory $Path;$text=[IO.File]::ReadAllText($absolute)
    if(!$text.Contains($Before)){throw "MD_FIXTURE_ANCHOR: $Path"}
    Write-MarkdownFixture $absolute ($text.Replace($Before,$After))
}
$cases=[ordered]@{
    positive=@('',{})
    empty=@('MD_INPUT_EMPTY',{param($directory) Write-MarkdownFixture (Join-Path $directory 'docs/guide.md') ''})
    unreadable=@('Exception|Could not|cannot|denied|MD_INPUT',{param($directory) [IO.File]::Delete((Join-Path $directory 'docs/guide.md'))})
    orphan=@('MD_ORPHAN',{param($directory) Write-MarkdownFixture (Join-Path $directory 'docs/unlinked.md') '# Unlinked'})
    missingLink=@('MD_LINK_MISSING',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '../README.md#purpose' 'README.md#purpose'})
    missingAnchor=@('MD_ANCHOR_MISSING',{param($directory) Edit-MarkdownFixture $directory 'README.md' '#section' '#absent'})
    duplicateHeading=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '## Section' ('## Section'+$nl+'## Section'+$nl+'[second](#section-1)')})
    unicodeAnchor=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '## Section' ('## Section'+$nl+'## Café 旅行!'+$nl+'[Unicode](#caf%C3%A9-%E6%97%85%E8%A1%8C)')})
    referenceLinks=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '[back](../README.md#purpose)' ('[back][root]'+$nl+$nl+'[root]: ../README.md#purpose')})
    referenceMissing=@('MD_REFERENCE_MISSING',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '[back](../README.md#purpose)' '[back][absent]'})
    angleLink=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '[back](../README.md#purpose)' '[back](<../README.md#purpose>)'})
    percentPath=@('',{param($directory) Write-MarkdownFixture (Join-Path $directory 'docs/space Café.md') '# Fine';Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[space](space%20Caf%C3%A9.md#fine)')})
    nestedPath=@('',{param($directory) Write-MarkdownFixture (Join-Path $directory 'docs/a(b(c)).md') '# Fine';Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[nested](a(b(c)).md#fine)')})
    invalidUtf8=@('Unable to translate|MD_INPUT',{param($directory) [IO.File]::WriteAllBytes((Join-Path $directory 'docs/guide.md'),[byte[]]@(195))})
    anchorCase=@('MD_ANCHOR_MISSING',{param($directory) Edit-MarkdownFixture $directory 'README.md' '#section' '#Section'})
    pathCase=@('MD_LINK_MISSING',{param($directory) Edit-MarkdownFixture $directory 'README.md' 'docs/guide.md' 'docs/Guide.md'})
    archivePositive=@('',{param($directory) Add-ArchiveFixture $directory "# Archive$nl$nl## D102 2026-11-01 one${nl}Now in: ${d}01, ${d}02; more$nl"})
    archiveNoEntry=@('MD_ARCHIVE_ITEM: D102',{param($directory) Add-ArchiveFixture $directory "# Archive$nl$nl## D102 2026-11-01 one${nl}Now in: ${d}77$nl"})
    archiveNoNowIn=@('MD_ARCHIVE_ITEM: D102',{param($directory) Add-ArchiveFixture $directory "# Archive$nl$nl## D102 2026-11-01 one${nl}No pointer.$nl"})
    archiveAppended=@('',{param($directory) Add-ArchiveFixture $directory "# Archive$nl$nl## D102 2026-11-01 one${nl}Now in: ${d}01$nl" -Commit;[IO.File]::AppendAllText((Join-Path $directory 'docs/history/DECISIONS-ARCHIVE.md'),"## D103 2026-11-02 two${nl}Now in: ${d}02$nl")})
    archiveRewritten=@('MD_ARCHIVE_APPEND',{param($directory) Add-ArchiveFixture $directory "# Archive$nl$nl## D102 2026-11-01 one${nl}Now in: ${d}01$nl" -Commit;Write-MarkdownFixture (Join-Path $directory 'docs/history/DECISIONS-ARCHIVE.md') "# Archive$nl$nl## D102 2026-11-01 changed${nl}Now in: ${d}01$nl"})
    historyByName=@('',{param($directory) Write-MarkdownFixture (Join-Path $directory 'changes/WS-002-new.md') '# New contract'})
    changesStray=@('MD_ORPHAN',{param($directory) Write-MarkdownFixture (Join-Path $directory 'changes/notes.md') '# Stray notes'})
    historyDuplicate=@('MD_HISTORY_ENTRY',{param($directory) Edit-MarkdownFixture $directory 'docs/history/README.md' '- [contract](../../changes/WS-001-history.md)' ('- [contract](../../changes/WS-001-history.md)'+$nl+'- [again](../../changes/WS-001-history.md)')})
    historyAbsent=@('MD_LINK_MISSING',{param($directory) Edit-MarkdownFixture $directory 'docs/history/README.md' 'changes/WS-001-history.md' 'changes/WS-999-missing.md'})
    historySmuggling=@('MD_HISTORY_ENTRY',{param($directory) Edit-MarkdownFixture $directory 'docs/history/README.md' '- [archive](archive.md)' ('- [archive](archive.md)'+$nl+'- [living](../guide.md)')})
    historySelf=@('MD_HISTORY_ENTRY',{param($directory) Edit-MarkdownFixture $directory 'docs/history/README.md' '- [archive](archive.md)' ('- [archive](archive.md)'+$nl+'- [itself](README.md)')})
    historyIndexDuplicate=@('MD_HISTORY_INDEX',{param($directory) Edit-MarkdownFixture $directory 'docs/history/README.md' '## History index' ('## History index'+$nl+$nl+'## History index')})
    historyFormat=@('MD_HISTORY_FORMAT',{param($directory) Edit-MarkdownFixture $directory 'docs/history/README.md' '- [archive](archive.md)' 'archive.md'})
    homeMissing=@('MD_HOME_MISSING',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '| Arrival | [arrival](AGENTS.md#arrival) |' ''})
    homeDuplicate=@('MD_HOME_ROW',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '| Arrival | [arrival](AGENTS.md#arrival) |' ('| Arrival | [arrival](AGENTS.md#arrival) |'+$nl+'| Arrival | [arrival](AGENTS.md#arrival) |')})
    homeTarget=@('MD_ANCHOR_MISSING',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' 'AGENTS.md#arrival' 'AGENTS.md#absent'})
    homeOwner=@('MD_HOME_OWNER',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' 'AGENTS.md#arrival' 'README.md#purpose'})
    homeTableDuplicate=@('MD_HOME_TABLE',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '## 2. Notes' ('## 3. One-home table'+$nl+$nl+'## 2. Notes')})
    homeFormat=@('MD_HOME_FORMAT',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '| Concept | Sole home |' ('| Concept | Sole home |'+$nl+'| Extra | malformed |')})
    pointer=@('MD_POINTER_HOME',{param($directory) Edit-MarkdownFixture $directory 'HANDOFF.md' 'Unique closure boundary.' 'Active Workbench Contract: None'})
    pointerFence=@('MD_POINTER_HOME',{param($directory) Edit-MarkdownFixture $directory 'HANDOFF.md' 'Unique closure boundary.' ('~~~text'+$nl+'Active Workbench Contract: None'+$nl+'~~~')})
    budget=@('MD_BUDGET',{param($directory) Write-MarkdownFixture (Join-Path $directory 'AGENTS.md') (Add-MarkdownBytes ([IO.File]::ReadAllText((Join-Path $directory 'AGENTS.md'))) 1537)})
    activeMissing=@('MD_ROOT_MISSING',{param($directory) [IO.File]::Delete((Join-Path $directory 'docs/RUNBOOK.md'))})
    sectionIdMissing=@('MD_SECTION_ID',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' 'Workflow notes.' ('Workflow notes.'+$nl+$nl+'## Notes without an ID')})
    sectionIdDuplicate=@('MD_SECTION_ID',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' 'Workflow notes.' ('Workflow notes.'+$nl+$nl+'## 2. Again')})
    subsectionParent=@('MD_SECTION_ID',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '### 2.1 Detail' '### 3.1 Detail'})
    decisionsHeading=@('MD_SECTION_ID',{param($directory) Edit-MarkdownFixture $directory 'docs/DECISIONS.md' "## ${d}02 Second" '## 2. Second'})
    preambleAtLimit=@('',{param($directory) Edit-MarkdownFixture $directory 'README.md' '# Purpose' ('# Purpose'+$nl+'One purpose line.')})
    preamble=@('MD_PREAMBLE',{param($directory) Edit-MarkdownFixture $directory 'README.md' '# Purpose' ('# Purpose'+$nl+'One purpose line.'+$nl+'One line too many.')})
    lineAtLimit=@('',{param($directory) Edit-MarkdownFixture $directory 'README.md' '## 1. Start' ('## 1. Start'+$nl+$nl+'y'*200+$nl+'| '+'z'*300+' |')})
    lineLength=@('MD_LINE_LENGTH',{param($directory) Edit-MarkdownFixture $directory 'AGENTS.md' '# Arrival' ('# Arrival'+$nl+'y'*201)})
    decisionAtLimit=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/DECISIONS.md' 'First decision.' ((1..12|ForEach-Object{"Line $_."})-join$nl)})
    decisionLines=@('MD_DECISION_LINES',{param($directory) Edit-MarkdownFixture $directory 'docs/DECISIONS.md' 'First decision.' ((1..13|ForEach-Object{"Line $_."})-join$nl)})
    decisionEntry=@('MD_DECISION_ENTRY',{param($directory) Edit-MarkdownFixture $directory 'docs/DECISIONS.md' ("Why: one line.${nl}Changed: 2026-11-01${nl}History: D1") ("Changed: 2026-11-01${nl}History: D1")})
    watch=@('MD_WATCH',{param($directory) Edit-MarkdownFixture $directory 'docs/RECOVERY.md' 'describes recovery.' ('describes recovery.'+$nl+'The widget count is 6.')})
    watchPatternInvalid=@('Invalid pattern',{param($directory) Edit-MarkdownFixture $directory 'docs/DECISIONS.md' '(?i)\bwidget\b' '(?i)(widget'})
    citationMissing=@('MD_SECTION_MISSING',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+"See WORKFLOW.md$s 9.")})
    citationSubsection=@('MD_SECTION_MISSING',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+"See RUNBOOK.md$s 1.2.")})
    decisionMissing=@('MD_SECTION_MISSING',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+"See ${d}77.")})
    routerHop=@('MD_ROUTER_HOP',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+"See README.md$s 1.")})
    toolCitation=@('MD_ROUTER_HOP',{param($directory) Edit-MarkdownFixture $directory 'lib/Tool.ps1' '# Tool:' "# Tool (AGENTS.md$s 7):"})
    duplicate=@('MD_DUPLICATE_PROSE',{param($directory) $prose=1..25-join' ';foreach($path in @('HANDOFF.md','docs/guide.md')){Write-MarkdownFixture (Join-Path $directory $path) ([IO.File]::ReadAllText((Join-Path $directory $path))+$nl+$nl+$prose)}})
    fenceExclusion=@('',{param($directory) $prose=1..25-join' ';foreach($path in @('HANDOFF.md','docs/guide.md')){Write-MarkdownFixture (Join-Path $directory $path) ([IO.File]::ReadAllText((Join-Path $directory $path))+$nl+$nl+'~~~text'+$nl+$prose+$nl+'[missing](no.md)'+$nl+'~~~'+$nl)}})
    contractExclusion=@('',{param($directory) $prose=1..25-join' ';foreach($path in @('changes/WS-001-history.md','docs/history/archive.md')){Write-MarkdownFixture (Join-Path $directory $path) ([IO.File]::ReadAllText((Join-Path $directory $path))+$nl+$nl+$prose)}})
    staleDate=@('MD_STALE_DATE',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Updated 2026-10-20'+$nl+$nl+'Amended 2026-10-27')})
    currentDate=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Version 2 | 2026-10-27 | Selected'+$nl+$nl+'Amended 2026-10-27')})
    retired=@('MD_RETIRED_ROUTE',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Run Documents\ORVION-Sandbox\old.ps1')})
    retiredFence=@('MD_RETIRED_ROUTE',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'~~~powershell'+$nl+'pwsh C:\ORVION-Temp\old.ps1'+$nl+'~~~')})
    retiredRoutes=@('MD_RETIRED_ROUTE',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Run ORVION-Owner-Tools\lib\Pulse.ps1')})
    historicalCitation=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Historical citation: Documents\ORVION-Sandbox\old.ps1 is retired.')})
    disguisedInstruction=@('MD_RETIRED_INSTRUCTION',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+$nl+'Historical citation: run Documents\ORVION-Sandbox\old.ps1')})
    externalPointers=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[private](../data/records/missing.md)')})
    externalOldStore=@('MD_EXTERNAL_UNAPPROVED',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[old](../../ORVION-Owner-Tools/records/missing.md)')})
    dataOtherPath=@('MD_LINK_MISSING',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[raw](../data/sessions/raw/missing.md)')})
    externalUnapproved=@('MD_EXTERNAL_UNAPPROVED',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[wrong](../../missing.md)')})
    frozenPinned=@('',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}The widget count is 6.$nl"})
    frozenAltered=@('MD_WATCH',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}The widget count is 7.$nl" -Pinned "# Text$nl${nl}The widget count is 6.$nl"})
    frozenUnpinned=@('MD_WATCH',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}The widget count is 6.$nl" -Path 'docs/owner/t/OTHER.md'})
    frozenOrphan=@('MD_ORPHAN',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}The widget count is 6.$nl" -Unlinked})
    frozenRetired=@('MD_RETIRED_ROUTE',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}Run Documents\ORVION-Sandbox\old.ps1$nl"})
    frozenCitation=@('MD_SECTION_MISSING',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}See ${d}77.$nl"})
    emptyInventory=@('MD_INPUT_EMPTY',{param($directory) $null=Invoke-MarkdownFixtureGit $directory @('rm','-r','--cached','--quiet','.')})
}
function Add-FrozenFixture([string]$Directory,[string]$Text,[string]$Path='docs/owner/t/TEXT.md',[string]$Pinned=$Text,[switch]$Unlinked){
    # One fixture pin at one fixed path, on the fixture's own words; the repository's pins are checked below.
    $FrozenOwnerTexts['docs/owner/t/TEXT.md']=Get-MarkdownTextHash $Pinned
    Write-MarkdownFixture (Join-Path $Directory $Path) $Text
    if(!$Unlinked){Edit-MarkdownFixture $Directory 'README.md' '[History](docs/history/README.md)' "[History](docs/history/README.md) [frozen]($Path)"}
}
function Add-MarkdownBytes([string]$Text,[int]$Limit){
    # Pads to exactly $Limit bytes with list lines of at most 102 characters (lists are outside the duplicate-prose check).
    $left=$Limit-$Text.Length;$full=[math]::Floor(($left-3)/101)
    return $Text+(('- '+'x'*98+$nl)*$full)+'- '+'x'*($left-101*$full-3)+$nl
}
function Add-DecisionBytes([string]$Text,[int]$Limit){
    # Adds whole entries of at most 12 decision lines until the file is exactly $Limit bytes.
    $number=2
    while(($left=$Limit-$Text.Length)-gt0){
        $number++;$head="$nl## $d$('{0:d2}'-f$number) Filler$nl$nl";$tail="$nl${nl}Scope: s.${nl}Why: w.${nl}Changed: 2026-11-01${nl}History: D1$nl"
        $size=if($left-$head.Length-$tail.Length-le1212){$left-$head.Length-$tail.Length}else{[math]::Min(1212,$left-2*($head.Length+$tail.Length)-1)}
        $full=[math]::Floor(($size-1)/101)
        $Text+=$head+((@('x'*100)*$full)+@('x'*($size-101*$full))-join$nl)+$tail
    }
    return $Text
}
$budgetLimits=@{'AGENTS.md'=1536;'README.md'=8192;'RESUME.md'=900;'HANDOFF.md'=4500;'WORKFLOW.md'=20300;'docs/DECISIONS.md'=40960}
$cases['atBudgets']=@('',{param($directory)
    foreach($budgetPath in $budgetLimits.Keys){
        $text=[IO.File]::ReadAllText((Join-Path $directory $budgetPath))
        $filled=if($budgetPath-ceq'docs/DECISIONS.md'){Add-DecisionBytes $text $budgetLimits[$budgetPath]}else{Add-MarkdownBytes $text $budgetLimits[$budgetPath]}
        if($filled.Length-ne$budgetLimits[$budgetPath]){throw "MD_FIXTURE_FILL: $budgetPath"}
        Write-MarkdownFixture (Join-Path $directory $budgetPath) $filled
    }
})
foreach($budgetPath in $budgetLimits.Keys){
    $limit=$budgetLimits[$budgetPath]
    $cases['overBudget'+(Split-Path $budgetPath -LeafBase)]=@('MD_BUDGET',({param($directory)
        $text=[IO.File]::ReadAllText((Join-Path $directory $budgetPath));Write-MarkdownFixture (Join-Path $directory $budgetPath) (Add-MarkdownBytes $text ($limit+1))
    }.GetNewClosure()))
}
# NOW.md cases: each turns $nowBase into the text Test-NowMarkdown checks against the positive fixture repository.
$nowBase=@('# NOW WS-033',"Live state (${d}01).",'','## 1. Now','','One line.','','## 2. Done last','',"Done, see WORKFLOW.md$s 2.1 and RUNBOOK.md$s 1.",''
    '## 3. Next','','Next step.','','## 4. Owner questions','','None.','','## 5. Pending decisions','','None.','','## 6. Running','','None.',''
    '## 7. Pointers','','- docs/RUNBOOK.md','')-join$nl
function Add-ArchiveFixture([string]$Directory,[string]$Text,[switch]$Commit){
    Write-MarkdownFixture (Join-Path $Directory 'docs/history/DECISIONS-ARCHIVE.md') $Text
    Edit-MarkdownFixture $Directory 'docs/history/README.md' '- [archive](archive.md)' ('- [archive](archive.md)'+$nl+'- [decisions archive](DECISIONS-ARCHIVE.md)')
    if($Commit){$null=Invoke-MarkdownFixtureGit $Directory @('add','--all');$null=Invoke-MarkdownFixtureGit $Directory @('-c','user.name=t','-c','user.email=t@example.invalid','commit','-qm','archive')}
}
function Get-NowFiller([int]$Size){
    # Exactly $Size bytes of list lines of at most 104 characters.
    $full=[math]::Floor(($Size-4)/101);return (('- '+'x'*98+$nl)*$full)+'- '+'x'*($Size-101*$full-3)+$nl
}
$nowCases=[ordered]@{
    nowPositive=@('',{param($text) $text})
    nowCrlf=@('',{param($text) $text-replace "`n","`r`n"})
    nowAtBudget=@('',{param($text) $text.Replace('## 7. Pointers',(Get-NowFiller ($NowBudget-$text.Length-1))+$nl+'## 7. Pointers')})
    nowOverBudget=@('MD_NOW_BUDGET',{param($text) $text.Replace('## 7. Pointers',(Get-NowFiller ($NowBudget-$text.Length))+$nl+'## 7. Pointers')})
    nowSectionRenamed=@('MD_NOW_SECTIONS',{param($text) $text.Replace('## 4. Owner questions','## 4. Questions')})
    nowSectionExtra=@('MD_NOW_SECTIONS',{param($text) $text+$nl+'## 8. Extra'+$nl})
    nowSectionId=@('MD_SECTION_ID',{param($text) $text.Replace('## 2. Done last','## Done last')})
    nowPreamble=@('MD_PREAMBLE',{param($text) $text.Replace('Live state','One.'+$nl+'Two.'+$nl+'Three.'+$nl+'Live state')})
    nowTwoLines=@('MD_NOW_LINE',{param($text) $text.Replace('One line.','One line.'+$nl+'Two lines.')})
    nowLineAtLimit=@('',{param($text) $text.Replace('Next step.','y'*200)})
    nowLineLength=@('MD_NOW_LINE_LENGTH',{param($text) $text.Replace('Next step.','y'*201)})
    nowPointersAtLimit=@('',{param($text) $text.Replace('- docs/RUNBOOK.md',(@(1..8|ForEach-Object{'- docs/RUNBOOK.md'})-join$nl))})
    nowPointers=@('MD_NOW_POINTERS',{param($text) $text.Replace('- docs/RUNBOOK.md',(@(1..9|ForEach-Object{'- docs/RUNBOOK.md'})-join$nl))})
    nowPointerFormat=@('MD_NOW_POINTERS',{param($text) $text.Replace('- docs/RUNBOOK.md','docs/RUNBOOK.md')})
    nowPointersNone=@('',{param($text) $text.Replace('- docs/RUNBOOK.md','None.')})
    nowPointerMissing=@('MD_NOW_POINTER_MISSING',{param($text) $text.Replace('- docs/RUNBOOK.md','- docs/absent.md')})
    nowCitationMissing=@('MD_SECTION_MISSING',{param($text) $text.Replace('Next step.',"See WORKFLOW.md$s 9.")})
    nowDecisionMissing=@('MD_SECTION_MISSING',{param($text) $text.Replace('Next step.',"See ${d}77.")})
    nowRouterHop=@('MD_ROUTER_HOP',{param($text) $text.Replace('Next step.',"See README.md$s 1.")})
}
try{
    foreach($caseName in $cases.Keys){
        if($Case-and$caseName-cne$Case){continue}
        $directory=New-MarkdownFixture $caseName
        $null=Invoke-MarkdownFixtureGit $directory @('add','--all')
        & $cases[$caseName][1] $directory
        if($caseName-notin'unreadable','emptyInventory'){$null=Invoke-MarkdownFixtureGit $directory @('add','--all')}
        $failure='';try{$null=Test-MarkdownConsistency $directory}catch{$failure=$_.Exception.Message}
        $expected=$cases[$caseName][0]
        if(($expected-and$failure-notmatch$expected)-or(!$expected-and$failure)){throw "FAIL $caseName expected '$expected', observed '$failure'"}
        $script:passed++;"PASS $caseName"
        if($caseName-eq'positive'){
            $treeId=Invoke-MarkdownFixtureGit $directory @('write-tree')
            Write-MarkdownFixture (Join-Path $directory 'docs/guide.md') ''
            foreach($selection in @('Index',$treeId)){$null=Test-MarkdownConsistency $directory $selection;$script:passed++;"PASS selected $selection ignores working bytes"}
            foreach($path in @(Get-ChildItem $directory -Recurse -Filter *.md)){
                $text=[IO.File]::ReadAllText($path.FullName)-replace '\r?\n',([string][char]13+[char]10);Write-MarkdownFixture $path.FullName $text
            }
            Write-MarkdownFixture (Join-Path $directory 'docs/guide.md') (('# Guide'+$nl+'## Section'+$nl+'[back](../README.md#purpose)'+$nl)-replace '\n',([string][char]13+[char]10))
            $null=Test-MarkdownConsistency $directory;$script:passed++;'PASS CRLF equivalent'
            $failure='';try{$null=Test-MarkdownConsistency $directory 'missing-tree'}catch{$failure=$_.Exception.Message}
            if($failure-cnotmatch'^MD_GIT_UNREADABLE \S'){throw "FAIL invalidTree $failure"};$script:passed++;'PASS invalid tree refuses'
        }
    }
    $nowFixture=$null
    foreach($caseName in $nowCases.Keys){
        if($Case-and$caseName-cne$Case){continue}
        if(!$nowFixture){$nowFixture=New-MarkdownFixture 'now';$null=Invoke-MarkdownFixtureGit $nowFixture @('add','--all')}
        $failure='';try{$null=Test-NowMarkdown $nowFixture (& $nowCases[$caseName][1] $nowBase)}catch{$failure=$_.Exception.Message}
        $expected=$nowCases[$caseName][0]
        if(($expected-and$failure-notmatch$expected)-or(!$expected-and$failure)){throw "FAIL $caseName expected '$expected', observed '$failure'"}
        $script:passed++;"PASS $caseName"
    }
    if(!$Case){
        # The NOW.md values the guard carries, compared with the document that holds them (DEC-01).
        $layout=[IO.File]::ReadAllText((Join-Path (Split-Path $PSScriptRoot -Parent) 'docs/WORKSPACE-LAYOUT.md'))-replace"`r`n","`n"
        $order=[regex]::Match($layout,'(?s)NOW\.md sections, in this order: (.+?)\.\n').Groups[1].Value-replace '\s+',' '
        $names=@(($order-replace '\s*\([^)]*\)','')-split ', ')
        if(($names-join'|')-cne($NowSections-join'|')-or$order-notmatch "Pointers \(at most $NowPointers paths\)"-or
            [regex]::Matches($layout,'NOW\.md (\d+) KB').Count-ne1-or[int]([regex]::Match($layout,'NOW\.md (\d+) KB').Groups[1].Value)*1024-ne$NowBudget){
            throw "FAIL nowValues: the guard carries $($NowSections-join', '), $NowPointers pointers and $NowBudget B; the layout says $order"
        }
        $script:passed++;'PASS NOW.md values match WORKSPACE-LAYOUT.md'
        # Each pin in the guard holds on the repository's own bytes: a stale or absent frozen text fails here.
        $repository=Get-MarkdownInput (Split-Path $PSScriptRoot -Parent) $RepositoryTree
        foreach($pin in $repositoryPins.GetEnumerator()){
            if(!$repository.ContainsKey($pin.Key)-or(Get-MarkdownTextHash ($repository[$pin.Key]-replace"`r`n","`n"))-cne$pin.Value){throw "FAIL frozenPin: $($pin.Key)"}
            $script:passed++;"PASS frozen pin $($pin.Key)"
        }
    }
    if(!$NoMutants-and!$Case){
        $source=[IO.File]::ReadAllText($Guard)
        $mutants=[ordered]@{
            empty='throw "MD_INPUT_EMPTY: $path"';orphan='throw "MD_ORPHAN: $path"'
            missingLink='throw "MD_LINK_MISSING: $Source -> $Link"';missingAnchor='throw "MD_ANCHOR_MISSING: $Source -> $Link"'
            historyByName='[void]$history.Add($path)';historyDuplicate='throw "MD_HISTORY_ENTRY: $link"'
            historyIndexDuplicate="throw 'MD_HISTORY_INDEX'";homeMissing="throw 'MD_HOME_MISSING'"
            homeOwner="throw 'MD_HOME_OWNER'";externalUnapproved='throw "MD_EXTERNAL_UNAPPROVED: $Source -> $Link"'
            historyFormat="throw 'MD_HISTORY_FORMAT'";homeFormat="throw 'MD_HOME_FORMAT'"
            homeDuplicate="throw 'MD_HOME_ROW'";homeTableDuplicate="throw 'MD_HOME_TABLE'"
            pointer='throw "MD_POINTER_HOME: $path"';budget='throw "MD_BUDGET: $path"'
            duplicate='throw "MD_DUPLICATE_PROSE: $($paragraphs[$normalized]), $path"';staleDate='throw "MD_STALE_DATE: $path"'
            retired='throw "MD_RETIRED_ROUTE: $path"';disguisedInstruction='throw "MD_RETIRED_INSTRUCTION: $path"'
            activeMissing='throw "MD_ROOT_MISSING: $path"';sectionIdMissing='throw "MD_SECTION_ID: $Path ''$line'' (IDs: $($ids-join'', ''))"'
            preamble='throw "MD_PREAMBLE: $Path has $preamble lines before its first section (IDs: $($ids-join'', ''))"'
            lineLength='throw "MD_LINE_LENGTH: ${path}:$($i+1)"';decisionEntry='throw "MD_DECISION_ENTRY: $id"'
            decisionLines='throw "MD_DECISION_LINES: $id has $count lines"'
            watch='throw "MD_WATCH: ${path}:$($i+1) matches the Watch pattern of $id without citing it"'
            routerHop='throw "MD_ROUTER_HOP: $path cites $($citation[2])"'
            citationMissing='throw "MD_SECTION_MISSING: $path cites $($citation[2]); $($citation[0]) holds $($sections[$citation[0]]-join'', '')"'
            nowOverBudget='throw "MD_NOW_BUDGET: $bytes B"';nowSectionId='$null=Get-MarkdownSections ''NOW.md'' $text'
            nowSectionRenamed='throw "MD_NOW_SECTIONS: NOW.md holds $($titles-join'', '')"'
            nowTwoLines='throw "MD_NOW_LINE: Now has $($body[1].Count) lines"';nowLineLength='throw "MD_NOW_LINE_LENGTH: NOW.md:$($i+1)"'
            nowPointers='throw "MD_NOW_POINTERS: $($pointers.Count) lines"';nowPointerMissing='throw "MD_NOW_POINTER_MISSING: $pointer"'
            nowCitationMissing='Assert-MarkdownCitations ''NOW.md'' $plain (Get-MarkdownActiveSections (Get-MarkdownInput $Root ''Working''))'
        }
        foreach($caseName in $mutants.Keys){
            $anchor=$mutants[$caseName];if(!$source.Contains($anchor)){throw "MD_MUTANT_STALE: $caseName"}
            $mutant=Join-Path $scratch ('mutant-'+$caseName+'.ps1');Write-MarkdownFixture $mutant ($source.Replace($anchor,'$null=$null'))
            $output=& pwsh -NoProfile -File $PSCommandPath -Guard $mutant -NoMutants -Case $caseName 2>&1
            if($LASTEXITCODE-eq0-or($output-join$nl)-notmatch("FAIL "+$caseName+" expected")){throw "MD_MUTANT_SURVIVED: $caseName $output"}
            $script:passed++;"PASS MUTANT KILLED $caseName"
        }
        # The exemption's edges: each mutant removes it or widens it one way, and the case that owns that edge must fail.
        $pinCheck='$frozen=$FrozenOwnerTexts[$path]-ceq(Get-MarkdownTextHash $text)'
        $widened=[ordered]@{
            frozenPinned=@($pinCheck,'$frozen=$false')
            frozenAltered=@($pinCheck,'$frozen=$FrozenOwnerTexts.ContainsKey($path)')
            frozenUnpinned=@($pinCheck,'$frozen=$path-clike''docs/owner/*''')
            frozenOrphan=@('if(!$reachable.Contains($path)-and!$history.Contains($path)){','if(!$reachable.Contains($path)-and!$history.Contains($path)-and!$FrozenOwnerTexts.ContainsKey($path)){')
            frozenRetired=@('if($routing-match$retired-and$routing-notmatch ''^Historical citation:''){','if($routing-match$retired-and$routing-notmatch ''^Historical citation:''-and!$FrozenOwnerTexts.ContainsKey($path)){')
            frozenCitation=@('Assert-MarkdownCitations $path $text $sections','if(!$frozen){Assert-MarkdownCitations $path $text $sections}')
        }
        foreach($caseName in $widened.Keys){
            if(!$source.Contains($widened[$caseName][0])){throw "MD_MUTANT_STALE: $caseName"}
            $mutant=Join-Path $scratch ('mutant-'+$caseName+'.ps1');Write-MarkdownFixture $mutant ($source.Replace($widened[$caseName][0],$widened[$caseName][1]))
            $output=& pwsh -NoProfile -File $PSCommandPath -Guard $mutant -NoMutants -Case $caseName 2>&1
            if($LASTEXITCODE-eq0-or($output-join$nl)-notmatch("FAIL "+$caseName+" expected")){throw "MD_MUTANT_SURVIVED: $caseName $output"}
            $script:passed++;"PASS MUTANT KILLED $caseName"
        }
    }
    if(!$Case){$null=Test-MarkdownConsistency (Split-Path $PSScriptRoot -Parent) $RepositoryTree;$script:passed++;'PASS repository Markdown'}
    "MARKDOWN_TESTS PASS: $script:passed assertions"
}finally{$null=Remove-OrvionOwnedTree -Path $scratch -AllowedRoots @($parent)}
