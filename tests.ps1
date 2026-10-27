# Every check this workspace's tools have: the script-hazard scan over all tracked .ps1 files, then each lib\test-*.ps1
# self-check (all disposable: temp folders and processes only). Exit 1 on any failure. Own timed Finish owns it.
$ErrorActionPreference='Stop'
$suiteRoot=$PSScriptRoot
$savedDataRoot=$env:ORVION_DATA_ROOT;$savedTemp=$env:TEMP;$savedTmp=$env:TMP
$testData=$null
try{
. (Join-Path $suiteRoot 'lib/workspace-layout.ps1')
$temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout $suiteRoot
. (Join-Path $suiteRoot 'lib/Test-WorkbenchChange.ps1') -Root $suiteRoot
$suiteParent=0
if(![int]::TryParse($env:WORKBENCH_SUITE_PARENT,[ref]$suiteParent)-or!$env:WORKBENCH_SUITE_RECIPE){throw 'WB_RAW_FULL_SUITE_REFUSED'}
$suiteProcess=Get-CimInstance Win32_Process -Filter "ProcessId=$PID" -ErrorAction Stop
$suiteOwner=Get-CimInstance Win32_Process -Filter "ProcessId=$suiteParent" -ErrorAction Stop
if(!$suiteProcess-or!$suiteOwner-or$suiteProcess.ParentProcessId-ne$suiteParent-or
   !([string]$suiteOwner.CommandLine).Contains((Join-Path $suiteRoot 'lib/Workbench.ps1'),[StringComparison]::OrdinalIgnoreCase)){
    throw 'WB_RAW_FULL_SUITE_REFUSED'
}

if($env:WORKBENCH_SUITE_MODE-ceq'CI'){
    $ciRecipe=Assert-WorkbenchCISuiteParent $suiteRoot $env:WORKBENCH_CI_CANDIDATE $env:WORKBENCH_CI_RUNTIME $env:WORKBENCH_SUITE_RECIPE $suiteParent
    $suiteRecipe=[pscustomobject]@{Material=$ciRecipe.Material.schedule}
}elseif(!$env:WORKBENCH_SUITE_MODE-or$env:WORKBENCH_SUITE_MODE-ceq'FINISH'){
    $suiteContract=Get-WorkbenchPointer ([IO.File]::ReadAllText((Join-Path $suiteRoot 'RESUME.md')))
    if($suiteContract-ceq'None'){throw 'WB_RAW_FULL_SUITE_REFUSED'}
    $suiteRecord=Get-WorkbenchFields ([IO.File]::ReadAllText((Join-Path $suiteRoot $suiteContract)))
    $suiteRecipe=Get-WorkbenchRecipe $suiteRoot 'HEAD' $suiteRecord
    if(!$suiteRecipe-or$suiteRecipe.Digest-cne$env:WORKBENCH_SUITE_RECIPE){throw 'WB_SUITE_RECIPE_MISMATCH'}
}else{throw 'WB_SUITE_MODE_REFUSED'}
$lib=Join-Path $PSScriptRoot 'lib';$fail=0;$sw=[Diagnostics.Stopwatch]::StartNew()
# test events never reach the real journal: every check writes to its own disposable root, and the data tools'
# default root (ORVION_DATA_ROOT) is an empty disposable folder for the whole run
$dataRoot=if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path $PSScriptRoot -Parent) 'ORVION-Owner-Tools'}
$journal=Join-Path $dataRoot 'events\events.jsonl';$journalHash=if(Test-Path $journal){(Get-FileHash $journal).Hash}
$testData=Join-Path $env:TEMP ('orvion-test-data-'+[guid]::NewGuid().ToString('N'))
$env:ORVION_DATA_ROOT=$testData;[void][IO.Directory]::CreateDirectory($testData)
$scripts=@(Get-ChildItem $PSScriptRoot -Recurse -File -Filter *.ps1|Where-Object{$_.FullName-notmatch'\\(sessions|events|work|\.git)\\'})
$actualHazards=@($scripts|ForEach-Object{[IO.Path]::GetRelativePath($suiteRoot,$_.FullName).Replace('\','/')}|Sort-Object -CaseSensitive)
if(($actualHazards-join[char]10)-cne(@($suiteRecipe.Material.hazards)-join[char]10)){throw 'WB_SUITE_UNDECLARED_HAZARD_INPUT'}
$out=& pwsh -NoProfile -File (Join-Path $lib 'Test-ScriptHazards.ps1') @($scripts.FullName) 2>&1
if($LASTEXITCODE){$fail++;"FAIL hazards`n$($out-join"`n")"}else{"PASS hazards ($($scripts.Count) scripts)"}
foreach($relativeTest in $suiteRecipe.Material.tests){
    $t=Get-Item -LiteralPath (Join-Path $suiteRoot $relativeTest)
    $out=& pwsh -NoProfile -File $t.FullName 2>&1
    if($LASTEXITCODE){$fail++;"FAIL $($t.Name)`n$(($out|Select-Object -Last 15)-join"`n")"}else{"PASS $($t.Name)"}
}
if($journalHash-ne$(if(Test-Path $journal){(Get-FileHash $journal).Hash})){$fail++;'FAIL a check wrote into the real journal events\events.jsonl'}else{'PASS the real journal is untouched by the checks'}
"TESTS: $(if($fail){"$fail FAILED"}else{'all passed'}) in $([int]$sw.Elapsed.TotalSeconds) s"
}finally{
    $env:ORVION_DATA_ROOT=$savedDataRoot;$env:TEMP=$savedTemp;$env:TMP=$savedTmp
    if($testData-and(Test-Path -LiteralPath $testData)){
        . (Join-Path $lib 'remove-owned.ps1')
        $null=Remove-OrvionOwnedTree -Path $testData -AllowedRoots @((Join-Path $temporaryRoot 'tmp'))
    }
}
exit [int]($fail-gt0)
