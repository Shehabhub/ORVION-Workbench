# Failure injection for the shared sandbox tooling (2026-10-19): process-tree ownership and termination, and the
# executor failing closed when git cannot read. Disposable: creates and removes its own temp repo and processes.
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'lifecycle.ps1')
$fail=0;function Test-Case([string]$Name,[bool]$Ok,[string]$Detail=''){if($Ok){"PASS $Name"}else{$script:fail++;"FAIL $Name $Detail"}}
function New-Row([int]$Id,[int]$Parent,[datetime]$At){[pscustomobject]@{ProcessId=$Id;ParentProcessId=$Parent;CreationDate=$At}}

# 1. Ownership on synthetic rows: only real descendants, never a stale parent id or a reused id's children.
$t0=[datetime]'2026-10-19T12:00:00'
$rows=@((New-Row 100 1 $t0),(New-Row 101 100 $t0.AddSeconds(1)),(New-Row 102 101 $t0.AddSeconds(2)),
        (New-Row 200 100 $t0.AddSeconds(-5)),                 # older than the root: a stale parent id
        (New-Row 103 999 $t0.AddSeconds(10)),(New-Row 104 103 $t0.AddSeconds(11)))  # unrelated holder and its child
$own=Select-OwnedProcesses $rows 100 $t0
Test-Case 'T1 descendants are owned' ($own.ContainsKey(101)-and$own.ContainsKey(102))
Test-Case 'T1 a process older than its claimed parent is not owned' (-not$own.ContainsKey(200))
Test-Case 'T1 an unrelated process and its child are not owned' (-not$own.ContainsKey(103)-and-not$own.ContainsKey(104))
# Our child 105 (pid now reused by 105', started later) had child 106 before the reuse: 106 is ours, 107 (after) is not.
$known=@{100=$t0;105=$t0.AddSeconds(1)}
$rows2=@((New-Row 105 999 $t0.AddSeconds(20)),(New-Row 106 105 $t0.AddSeconds(3)),(New-Row 107 105 $t0.AddSeconds(21)))
$own2=Select-OwnedProcesses $rows2 100 $t0 $known
Test-Case 'T1 a reused parent id passes on only children born before the reuse' ($own2.ContainsKey(106)-and-not$own2.ContainsKey(107))

# 2. Live: a spawner that keeps starting children is stopped completely; an older unrelated process survives.
$bystander=Start-Process pwsh -ArgumentList '-NoProfile','-Command','Start-Sleep 120' -PassThru -WindowStyle Hidden
$spawn='while($true){Start-Process pwsh -ArgumentList ''-NoProfile'',''-Command'',''Start-Sleep 120'' -WindowStyle Hidden;Start-Sleep -Milliseconds 300}'
$root=Start-Process pwsh -ArgumentList '-NoProfile','-Command',$spawn -PassThru -WindowStyle Hidden
Start-Sleep -Seconds 4
$r=Stop-ProcessTreeFully $root.Id $root.StartTime
$left=@(Get-CimInstance Win32_Process|Where-Object{$_.ParentProcessId-eq$root.Id-and$_.CreationDate-ge$root.StartTime.AddSeconds(-1)})
Test-Case 'T2 a tree spawning during the stop leaves no survivor' ($r.Survivors-eq0-and$root.HasExited-and-not$left.Count) "survivors=$($r.Survivors) left=$($left.Count) seen=$($r.Stopped)"
Test-Case 'T2 an unrelated older process is untouched' (-not$bystander.HasExited)
Stop-Process -Id $bystander.Id -Force -ErrorAction SilentlyContinue

# 3. A root that already exited: its orphaned child is still found and stopped.
$orph=Start-Process pwsh -ArgumentList '-NoProfile','-Command','Start-Process pwsh -ArgumentList ''-NoProfile'',''-Command'',''Start-Sleep 120'' -WindowStyle Hidden' -PassThru -WindowStyle Hidden
$orph.WaitForExit(15000)|Out-Null;$started=$orph.StartTime;Start-Sleep -Milliseconds 500
$child=@(Get-CimInstance Win32_Process|Where-Object{$_.ParentProcessId-eq$orph.Id-and$_.CreationDate-ge$started.AddSeconds(-1)})
$r=Stop-ProcessTreeFully $orph.Id $started
$still=@($child|Where-Object{Get-Process -Id $_.ProcessId -ErrorAction SilentlyContinue})
Test-Case 'T3 the orphan of an exited root is stopped' ($child.Count-eq1-and-not$still.Count-and$r.Survivors-eq0) "child=$($child.Count) still=$($still.Count)"

# 4. The executor fails closed when git cannot read: a corrupted index once read as a clean checkout.
$tmp=Join-Path ([IO.Path]::GetTempPath()) "orvion-failclosed-$([guid]::NewGuid().ToString('N').Substring(0,8))"
try{
    git init -q $tmp;git -C $tmp config user.name Tester;git -C $tmp config user.email t@example.invalid
    Set-Content -LiteralPath "$tmp\a.txt" -Value 'a';git -C $tmp add a.txt;git -C $tmp commit -q -m init
    [IO.File]::WriteAllBytes("$tmp\.git\index",[byte[]](1,2,3))
    $raw=git -C $tmp status --porcelain 2>$null;$code=$LASTEXITCODE;$global:LASTEXITCODE=0
    Test-Case 'T4 precondition: an unchecked git status prints nothing on a corrupted index' (-not$raw-and$code-ne0) "code=$code"
    $draft=Join-Path $tmp 'draft.md';Set-Content -LiteralPath $draft -Value 'x'
    $cfg=Join-Path ([IO.Path]::GetTempPath()) "$(Split-Path $tmp -Leaf).psd1"
    Set-Content -LiteralPath $cfg -Value "@{Root='$tmp';Main='0';Id='SPEC-0';Slug='x';Draft='$draft';Sha='0';Blob='0';User='Tester';Suffix='t';ApprovalNote='t'}"
    $out=& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Invoke-ContractStage.ps1') -Config $cfg -Stage complete 2>&1|Out-String;$code=$LASTEXITCODE
    Test-Case 'T4 the executor refuses instead of reading a clean checkout' ($code-ne0-and$out-match'git status --porcelain failed') ($out.Trim()-split"`n"|Select-Object -Last 3)
}finally{Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue;Remove-Item -LiteralPath $cfg,(Join-Path ([IO.Path]::GetTempPath()) 'SPEC-0-lifecycle.log') -Force -ErrorAction SilentlyContinue}
"FAILCLOSED CHECK: $fail failed";exit $fail
