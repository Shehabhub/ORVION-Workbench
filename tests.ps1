# Every check this workspace's tools have: the script-hazard scan over all tracked .ps1 files, then each lib\test-*.ps1
# self-check (all disposable: temp folders and processes only). Exit 1 on any failure. The pre-commit hook runs it.
$ErrorActionPreference='Stop'
$lib=Join-Path $PSScriptRoot 'lib';$fail=0;$sw=[Diagnostics.Stopwatch]::StartNew()
$scripts=@(Get-ChildItem $PSScriptRoot -Recurse -File -Filter *.ps1|Where-Object{$_.FullName-notmatch'\\(sessions|events|work|\.git)\\'})
$out=& pwsh -NoProfile -File (Join-Path $lib 'Test-ScriptHazards.ps1') @($scripts.FullName) 2>&1
if($LASTEXITCODE){$fail++;"FAIL hazards`n$($out-join"`n")"}else{"PASS hazards ($($scripts.Count) scripts)"}
foreach($t in Get-ChildItem $lib -File -Filter '*.ps1'|Where-Object Name -cmatch '^test-'){  # case-sensitive: Test-*.ps1 are tools
    $out=& pwsh -NoProfile -File $t.FullName 2>&1
    if($LASTEXITCODE){$fail++;"FAIL $($t.Name)`n$(($out|Select-Object -Last 15)-join"`n")"}else{"PASS $($t.Name)"}
}
"TESTS: $(if($fail){"$fail FAILED"}else{'all passed'}) in $([int]$sw.Elapsed.TotalSeconds) s"
exit [int]($fail-gt0)
