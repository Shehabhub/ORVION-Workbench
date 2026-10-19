# Self-check for Remove-OrvionOwnedTree: deletes inside an allowed root (read-only files included) and
# refuses a path outside it, the root itself, and any tree containing a junction.
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$root=Join-Path ([IO.Path]::GetTempPath()) ("orvion-remove-check-"+[guid]::NewGuid().ToString('N').Substring(0,8))
$outside=Join-Path ([IO.Path]::GetTempPath()) ("orvion-remove-outside-"+[guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Force "$root\a\b",$outside|Out-Null
$fail=0;function Check($n,[bool]$ok){if($ok){"PASS $n"}else{"FAIL $n";$script:fail++}}
function Refuses([scriptblock]$s,[string]$p){try{&$s|Out-Null;$false}catch{"$_"-match$p}}
try{
    Set-Content "$root\a\b\ro.txt" 'x';(Get-Item "$root\a\b\ro.txt").Attributes='ReadOnly'
    Set-Content "$outside\keep.txt" 'keep'
    Check 'path outside the allowed root is refused' (Refuses {Remove-OrvionOwnedTree $outside @($root)} 'REMOVE_OUTSIDE_ALLOWED_ROOT')
    Check 'the allowed root itself is refused' (Refuses {Remove-OrvionOwnedTree $root @($root)} 'REMOVE_OUTSIDE_ALLOWED_ROOT')
    New-Item -ItemType Junction -Path "$root\a\link" -Target $outside|Out-Null
    Check 'a tree containing a junction is refused' (Refuses {Remove-OrvionOwnedTree "$root\a" @($root)} 'REMOVE_CONTAINS_REPARSE_POINT')
    Check 'the junction target survives' (Test-Path "$outside\keep.txt")
    [IO.Directory]::Delete("$root\a\link")
    $n=Remove-OrvionOwnedTree "$root\a" @($root)
    Check 'read-only files inside the root are deleted' (-not(Test-Path "$root\a")-and$n-gt0)
}finally{foreach($d in $root,$outside){if(Test-Path $d){Get-ChildItem $d -Recurse -Force|%{$_.Attributes='Normal'};[IO.Directory]::Delete($d,$true)}}}
"REMOVE-OWNED CHECK: $fail failed";exit $fail
