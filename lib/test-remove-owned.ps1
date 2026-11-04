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
    Set-Content "$root\a\one.txt" 'xyz';(Get-Item "$root\a\one.txt").Attributes='ReadOnly'
    $one=Remove-OrvionOwnedTree "$root\a\one.txt" @($root)
    Check 'one read-only file is deleted, its folder kept' (-not(Test-Path "$root\a\one.txt")-and$one-gt0-and(Test-Path "$root\a\b\ro.txt"))
    Check 'a file outside the allowed root is refused' (Refuses {Remove-OrvionOwnedTree "$outside\keep.txt" @($root)} 'REMOVE_OUTSIDE_ALLOWED_ROOT')
    # OneDrive shows every vault file as a reparse point with no link type: only -CloudFile passes one such file (slice S7).
    Add-Type -TypeDefinition @"
using System;using System.Runtime.InteropServices;using Microsoft.Win32.SafeHandles;
public static class Rp{
[DllImport("kernel32",SetLastError=true,CharSet=CharSet.Unicode)]public static extern SafeFileHandle CreateFile(string n,uint a,uint s,IntPtr p,uint c,uint f,IntPtr t);
[DllImport("kernel32",SetLastError=true)]public static extern bool DeviceIoControl(SafeFileHandle h,uint code,byte[] i,int il,IntPtr o,int ol,out int r,IntPtr ov);
public static int Set(string path,uint tag){var h=CreateFile(path,0x40000000|0x80000000,0,IntPtr.Zero,3,0x02000000|0x00200000,IntPtr.Zero);if(h.IsInvalid)return Marshal.GetLastWin32Error();
var g=new Guid("11111111-2222-3333-4444-555555555555").ToByteArray();var b=new byte[8+16+4];BitConverter.GetBytes(tag).CopyTo(b,0);BitConverter.GetBytes((ushort)4).CopyTo(b,4);g.CopyTo(b,8);int r;
bool ok=DeviceIoControl(h,0x900A4,b,b.Length,IntPtr.Zero,0,out r,IntPtr.Zero);int e=ok?0:Marshal.GetLastWin32Error();h.Dispose();return e;}}
"@
    $cloud="$outside\cloud.7z";Set-Content $cloud 'x';$cloudRoot=@($outside)
    Check 'the stand-in is a reparse file with no link type' ([Rp]::Set($cloud,0x1234)-eq0-and[bool]((Get-Item -LiteralPath $cloud -Force).Attributes-band[IO.FileAttributes]::ReparsePoint)-and!(Get-Item -LiteralPath $cloud -Force).LinkType)
    Check 'a cloud file is refused without -CloudFile' ((Refuses {Remove-OrvionOwnedTree $cloud $cloudRoot} 'REMOVE_REPARSE_POINT')-and(Test-Path -LiteralPath $cloud))
    Check 'a cloud file is deleted with -CloudFile' (!(Refuses {Remove-OrvionOwnedTree $cloud $cloudRoot -CloudFile} 'REMOVE_REPARSE_POINT')-and!(Test-Path -LiteralPath $cloud))
    New-Item -ItemType Junction -Path "$root\a\cloudlink" -Target $outside|Out-Null
    Check 'a junction is refused even with -CloudFile' ((Refuses {Remove-OrvionOwnedTree "$root\a\cloudlink" @($root) -CloudFile} 'REMOVE_REPARSE_POINT')-and(Test-Path "$outside\keep.txt"))
    [IO.Directory]::Delete("$root\a\cloudlink")
    $n=Remove-OrvionOwnedTree "$root\a" @($root)
    Check 'read-only files inside the root are deleted' (-not(Test-Path "$root\a")-and$n-gt0)
}finally{foreach($d in $root,$outside){if(Test-Path $d){Get-ChildItem $d -Recurse -Force|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($d,$true)}}}
"REMOVE-OWNED CHECK: $fail failed";exit $fail
