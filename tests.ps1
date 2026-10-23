# Every check this workspace's tools have: the script-hazard scan over all tracked .ps1 files, then each lib\test-*.ps1
# self-check (all disposable: temp folders and processes only). Exit 1 on any failure. Own timed Finish owns it.
$ErrorActionPreference='Stop'
$suiteRoot=$PSScriptRoot
. (Join-Path $suiteRoot 'lib/Test-WorkbenchChange.ps1') -Root $suiteRoot
$suiteParent=0
if(![int]::TryParse($env:WORKBENCH_SUITE_PARENT,[ref]$suiteParent)-or!$env:WORKBENCH_SUITE_RECIPE){throw 'WB_RAW_FULL_SUITE_REFUSED'}
$suiteProcess=Get-CimInstance Win32_Process -Filter "ProcessId=$PID" -ErrorAction Stop
$suiteOwner=Get-CimInstance Win32_Process -Filter "ProcessId=$suiteParent" -ErrorAction Stop
if(!$suiteProcess-or!$suiteOwner-or$suiteProcess.ParentProcessId-ne$suiteParent-or
   !([string]$suiteOwner.CommandLine).Contains((Join-Path $suiteRoot 'lib/Workbench.ps1'),[StringComparison]::OrdinalIgnoreCase)){
    throw 'WB_RAW_FULL_SUITE_REFUSED'
}
$suiteContract=Get-WorkbenchPointer ([IO.File]::ReadAllText((Join-Path $suiteRoot 'RESUME.md')))
if($suiteContract-ceq'None'){throw 'WB_RAW_FULL_SUITE_REFUSED'}
$suiteRecord=Get-WorkbenchFields ([IO.File]::ReadAllText((Join-Path $suiteRoot $suiteContract)))
$suiteRecipe=Get-WorkbenchRecipe $suiteRoot 'HEAD' $suiteRecord
if(!$suiteRecipe-or$suiteRecipe.Digest-cne$env:WORKBENCH_SUITE_RECIPE){throw 'WB_SUITE_RECIPE_MISMATCH'}
$lib=Join-Path $PSScriptRoot 'lib';$fail=0;$sw=[Diagnostics.Stopwatch]::StartNew()
# test events never reach the real journal: every check writes to its own disposable root
$journal=Join-Path $PSScriptRoot 'events\events.jsonl';$journalHash=if(Test-Path $journal){(Get-FileHash $journal).Hash}
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
exit [int]($fail-gt0)
