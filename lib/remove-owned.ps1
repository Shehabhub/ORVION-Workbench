# Deletes a directory tree only when it lies inside an allowed sandbox root, contains no reparse point
# (junction or symlink that could lead outside), and is not the root itself. Clears read-only flags
# (Git pack files) first. Returns the bytes freed.
function Remove-OrvionOwnedTree([Parameter(Mandatory)][string]$Path,[Parameter(Mandatory)][string[]]$AllowedRoots){
    $full=[IO.Path]::GetFullPath($Path).TrimEnd('\')
    $inside=$AllowedRoots|Where-Object{$r=[IO.Path]::GetFullPath($_).TrimEnd('\');$full.StartsWith("$r\",[StringComparison]::OrdinalIgnoreCase)}
    if(-not$inside){throw "REMOVE_OUTSIDE_ALLOWED_ROOT:$full"}
    if(-not(Test-Path -LiteralPath $full)){return 0}
    $root=Get-Item -LiteralPath $full -Force
    if($root.Attributes-band[IO.FileAttributes]::ReparsePoint){throw "REMOVE_REPARSE_POINT:$full"}
    $items=@(Get-ChildItem -LiteralPath $full -Recurse -Force -Attributes !ReparsePoint -ErrorAction Stop)
    $links=@(Get-ChildItem -LiteralPath $full -Recurse -Force -Attributes ReparsePoint -ErrorAction Stop)
    if($links.Count){throw "REMOVE_CONTAINS_REPARSE_POINT:$($links[0].FullName)"}
    $bytes=($items|Where-Object{-not$_.PSIsContainer}|Measure-Object Length -Sum).Sum
    foreach($i in $items){if($i.Attributes-band[IO.FileAttributes]::ReadOnly){$i.Attributes=$i.Attributes-bxor[IO.FileAttributes]::ReadOnly}}
    [IO.Directory]::Delete($full,$true)
    if(Test-Path -LiteralPath $full){throw "REMOVE_INCOMPLETE:$full"}
    [long]$bytes
}
