param([string]$Guard=(Join-Path $PSScriptRoot 'Test-MarkdownConsistency.ps1'),[switch]$NoMutants,[string]$Case,[string]$RepositoryTree='Working')
$ErrorActionPreference='Stop'
. $Guard
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$parent=if($env:WORKBENCH_TEST_ROOT){$env:WORKBENCH_TEST_ROOT}else{$env:TEMP}
if(![IO.Path]::IsPathFullyQualified($parent)){throw 'MD_TEST_ROOT_REQUIRED'}
$scratch=Join-Path $parent ('md-'+[guid]::NewGuid().ToString('N').Substring(0,8))
[void][IO.Directory]::CreateDirectory($scratch)
$script:passed=0;$nl=[string][char]10
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
        'README.md'="# Purpose$nl[Governance](WORKFLOW.md) [Resume](RESUME.md) [Closure](HANDOFF.md) [Guide](docs/guide.md#section) [external](../ORVION-Owner-Tools/STATE.md) [private](C:/private/missing.md)$nl"
        'RESUME.md'="Active Workbench Contract: None${nl}Live state: ../ORVION-Owner-Tools/STATE.md$nl"
        'HANDOFF.md'="# Closure$nl${nl}Unique closure boundary.$nl"
        'docs/EXECUTION-PLAN.md'="# Plan$nl${nl}Only this file describes the sequence.$nl"
        'docs/WORKSPACE-LAYOUT.md'="# Layout$nl${nl}Only this file describes storage.$nl"
        'docs/RECOVERY.md'="# Recovery$nl${nl}Only this file describes recovery.$nl"
        'lib/README.md'="# Tools$nl${nl}Only this file describes tools.$nl"
        'changes/TEMPLATE.md'="# Template$nl${nl}Only this file describes new proposals.$nl"
        'docs/guide.md'="# Guide$nl## Section$nl[back](../README.md#purpose)$nl"
        'changes/WS-001-history.md'="# Frozen history$nl[original packet](not-here.md)$nl"
        'docs/history/archive.md'="# Frozen archive${nl}Run Documents\ORVION-Sandbox\old.ps1 (source-bound historical instruction).$nl"
        'WORKFLOW.md'=@'
# Governance

## One-home table

| Concept | Sole home |
|---|---|
| Arrival | [arrival](AGENTS.md#arrival) |
| Purpose | [purpose](README.md#purpose) |
| Active contract | [pointer](RESUME.md) |
| Batch 6 closure | [closure](HANDOFF.md#closure) |
| Governance | [governance](WORKFLOW.md#governance) |
| Programme plan | [plan](docs/EXECUTION-PLAN.md#plan) |
| Workspace layout | [layout](docs/WORKSPACE-LAYOUT.md#layout) |
| Recovery | [recovery](docs/RECOVERY.md#recovery) |
| Tool catalogue | [tools](lib/README.md#tools) |
| Contract template | [template](changes/TEMPLATE.md#template) |

## History index

- [contract](changes/WS-001-history.md)
- [archive](docs/history/archive.md)
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
    historyByName=@('',{param($directory) Write-MarkdownFixture (Join-Path $directory 'changes/WS-002-new.md') '# New contract'})
    changesStray=@('MD_ORPHAN',{param($directory) Write-MarkdownFixture (Join-Path $directory 'changes/notes.md') '# Stray notes'})
    historyDuplicate=@('MD_HISTORY_ENTRY',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '- [contract](changes/WS-001-history.md)' ('- [contract](changes/WS-001-history.md)'+$nl+'- [again](changes/WS-001-history.md)')})
    historyAbsent=@('MD_HISTORY_ENTRY',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' 'changes/WS-001-history.md' 'changes/WS-999-missing.md'})
    historySmuggling=@('MD_HISTORY_ENTRY',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '- [archive](docs/history/archive.md)' ('- [archive](docs/history/archive.md)'+$nl+'- [living](docs/guide.md)')})
    historyIndexDuplicate=@('MD_HISTORY_INDEX',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '## History index' ('## History index'+$nl+$nl+'## History index')})
    historyFormat=@('MD_HISTORY_FORMAT',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '- [archive](docs/history/archive.md)' 'docs/history/archive.md'})
    homeMissing=@('MD_HOME_MISSING',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '| Arrival | [arrival](AGENTS.md#arrival) |' ''})
    homeDuplicate=@('MD_HOME_ROW',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '| Arrival | [arrival](AGENTS.md#arrival) |' ('| Arrival | [arrival](AGENTS.md#arrival) |'+$nl+'| Arrival | [arrival](AGENTS.md#arrival) |')})
    homeTarget=@('MD_ANCHOR_MISSING',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' 'AGENTS.md#arrival' 'AGENTS.md#absent'})
    homeOwner=@('MD_HOME_OWNER',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' 'AGENTS.md#arrival' 'README.md#purpose'})
    homeTableDuplicate=@('MD_HOME_TABLE',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '## One-home table' ('## One-home table'+$nl+$nl+'## One-home table')})
    homeFormat=@('MD_HOME_FORMAT',{param($directory) Edit-MarkdownFixture $directory 'WORKFLOW.md' '| Concept | Sole home |' ('| Concept | Sole home |'+$nl+'| Extra | malformed |')})
    pointer=@('MD_POINTER_HOME',{param($directory) Edit-MarkdownFixture $directory 'HANDOFF.md' 'Unique closure boundary.' 'Active Workbench Contract: None'})
    pointerFence=@('MD_POINTER_HOME',{param($directory) Edit-MarkdownFixture $directory 'HANDOFF.md' 'Unique closure boundary.' ('~~~text'+$nl+'Active Workbench Contract: None'+$nl+'~~~')})
    budget=@('MD_BUDGET',{param($directory) Edit-MarkdownFixture $directory 'AGENTS.md' '# Arrival' ('# Arrival '+('word '*101))})
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
    externalPointers=@('',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[private](../../ORVION-Owner-Tools/records/missing.md)')})
    externalUnapproved=@('MD_EXTERNAL_UNAPPROVED',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[wrong](../../missing.md)')})
    emptyInventory=@('MD_INPUT_EMPTY',{param($directory) $null=Invoke-MarkdownFixtureGit $directory @('rm','-r','--cached','--quiet','.')})
}
$budgetLimits=@{'AGENTS.md'=100;'README.md'=400;'RESUME.md'=120;'HANDOFF.md'=600;'WORKFLOW.md'=2400}
$cases['atBudgets']=@('',{param($directory)
    foreach($budgetPath in $budgetLimits.Keys){
        $text=[IO.File]::ReadAllText((Join-Path $directory $budgetPath));$remaining=$budgetLimits[$budgetPath]-[regex]::Matches($text,'\S+').Count
        $filled=if($budgetPath-ceq'WORKFLOW.md'){$text.Replace('## One-home table',('word '*$remaining)+$nl+$nl+'## One-home table')}else{$text+$nl+$nl+('word '*$remaining)}
        Write-MarkdownFixture (Join-Path $directory $budgetPath) $filled
    }
})
foreach($budgetPath in $budgetLimits.Keys){
    $limit=$budgetLimits[$budgetPath]
    $cases['overBudget'+$budgetPath.Split('.')[0]]=@('MD_BUDGET',({param($directory)
        $text=[IO.File]::ReadAllText((Join-Path $directory $budgetPath));Write-MarkdownFixture (Join-Path $directory $budgetPath) ($text+$nl+$nl+('word '*($limit+1)))
    }.GetNewClosure()))
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
            if($failure-cne'MD_GIT_UNREADABLE'){throw "FAIL invalidTree $failure"};$script:passed++;'PASS invalid tree refuses'
        }
    }
    if(!$Case){$null=Test-MarkdownConsistency (Split-Path $PSScriptRoot -Parent) $RepositoryTree;$script:passed++;'PASS repository Markdown'}
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
        }
        foreach($caseName in $mutants.Keys){
            $anchor=$mutants[$caseName];if(!$source.Contains($anchor)){throw "MD_MUTANT_STALE: $caseName"}
            $mutant=Join-Path $scratch ('mutant-'+$caseName+'.ps1');Write-MarkdownFixture $mutant ($source.Replace($anchor,'$null=$null'))
            $output=& pwsh -NoProfile -File $PSCommandPath -Guard $mutant -NoMutants -Case $caseName 2>&1
            if($LASTEXITCODE-eq0-or($output-join$nl)-notmatch("FAIL "+$caseName+" expected")){throw "MD_MUTANT_SURVIVED: $caseName $output"}
            $script:passed++;"PASS MUTANT KILLED $caseName"
        }
    }
    "MARKDOWN_TESTS PASS: $script:passed assertions"
}finally{$null=Remove-OrvionOwnedTree -Path $scratch -AllowedRoots @($parent)}
