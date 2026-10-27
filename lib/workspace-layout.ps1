# Temporary roots only; data-root defaults stay inline in their owning scripts.
# WORKBENCH_TEMP_ROOT is an explicit context root. ORVION_STANDALONE_TEMP=1 opts a standalone
# installation into system temp; hosted runners may use RUNNER_TEMP / GITHUB_ACTIONS=true.
function Get-OrvionRepositoryCandidates {
    param([string]$GitHub,[string[]]$Skip=@('*-trusted-main','ORVION-Owner-Tools','ORVION-Workbench-temporary','_*'))
    foreach($d in Get-ChildItem -LiteralPath $GitHub -Directory){
        if(@($Skip|Where-Object{$d.Name-like$_}).Count-or!(Test-Path -LiteralPath (Join-Path $d.FullName '.git'))){continue}
        $top="$( & git -C $d.FullName rev-parse --show-toplevel 2>$null )"
        if($LASTEXITCODE-or!$top-or[IO.Path]::GetFullPath($top)-ne$d.FullName){[pscustomobject]@{name=$d.Name;root=$d.FullName;problem='not a readable Git work tree'};continue}
        [pscustomobject]@{name=$d.Name;root=$d.FullName;problem=''}
    }
}
function Initialize-OrvionTemporaryRoot {
    param([Parameter(Mandatory)][string]$Checkout,[string]$Target,[string]$TemporaryRoot=$env:WORKBENCH_TEMP_ROOT)
    $checkoutPath=[IO.Path]::GetFullPath($Checkout).TrimEnd('\','/')
    if($TemporaryRoot){
        if(![IO.Path]::IsPathFullyQualified($TemporaryRoot)){throw 'WB_TEMP_ROOT_NOT_ABSOLUTE'}
        $temporary=[IO.Path]::GetFullPath($TemporaryRoot)
    }elseif($Target){
        if(![IO.Path]::IsPathFullyQualified($Target)){throw 'WB_TEMP_TARGET_NOT_ABSOLUTE'}
        $temporary=Join-Path ([IO.Path]::GetFullPath($Target)) 'ORVION-Workbench-temporary'
    }else{
        # Only the exact clone homes bind a checkout to its temporary root: <temporary>\cx\<name> and
        # <temporary>\sb\<WS>\<name>. Anything deeper (a test fixture under a Temp Root) falls through.
        $temporary=$null;$parent=[IO.DirectoryInfo]::new($checkoutPath).Parent
        if($parent-and$parent.Name-ieq'cx'-and$parent.Parent-and$parent.Parent.Name-ieq'ORVION-Workbench-temporary'){$temporary=$parent.Parent.FullName}
        elseif($parent-and$parent.Parent-and$parent.Parent.Name-ieq'sb'-and$parent.Parent.Parent-and$parent.Parent.Parent.Name-ieq'ORVION-Workbench-temporary'){$temporary=$parent.Parent.Parent.FullName}
        # Hosted runners check out into ...\ORVION-Workbench\ORVION-Workbench: their own temp wins over the name rule.
        if(!$temporary-and($env:RUNNER_TEMP-or$env:GITHUB_ACTIONS-eq'true'-or$env:ORVION_STANDALONE_TEMP-eq'1')){
            $hostTemp=if($env:RUNNER_TEMP){$env:RUNNER_TEMP}else{[IO.Path]::GetTempPath()}
            if(![IO.Path]::IsPathFullyQualified($hostTemp)){throw 'WB_TEMP_ROOT_NOT_ABSOLUTE'}
            $temporary=Join-Path $hostTemp 'ORVION-Workbench'
        }
        if(!$temporary-and([IO.Path]::GetFileName($checkoutPath)-in'ORVION-Workbench','ORVION-Workbench-trusted-main')){
            $temporary=Join-Path (Split-Path $checkoutPath -Parent) 'ORVION-Workbench-temporary'
        }
        if(!$temporary){throw 'WB_TEMP_LAYOUT_UNAVAILABLE'}
    }
    $temporary=[IO.Path]::GetFullPath($temporary).TrimEnd('\','/')
    if($temporary-ieq$checkoutPath-or$temporary.StartsWith($checkoutPath+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)){throw 'WB_TEMP_ROOT_INSIDE_CHECKOUT_REFUSED'}
    $managedTemp=Join-Path $temporary 'tmp'
    try{[void][IO.Directory]::CreateDirectory($managedTemp)}catch{throw 'WB_TEMP_MATERIALIZATION_FAILED'}
    $env:TEMP=$managedTemp;$env:TMP=$managedTemp
    $temporary
}

# Finish's required Hunt needs a data root. A sandbox or temporary clone has none (no ORVION_DATA_ROOT, no sibling
# ORVION-Owner-Tools with events\): give it an empty disposable store under the managed temp instead of failing, and
# never fall back to the checkout. Returns $null when the normal default applies.
function Get-OrvionFinishHuntDataRoot([Parameter(Mandatory)][string]$Checkout){
    if($env:ORVION_DATA_ROOT){return $null}
    $sibling=Join-Path (Split-Path ([IO.Path]::GetFullPath($Checkout).TrimEnd('\','/')) -Parent) 'ORVION-Owner-Tools'
    if(Test-Path -LiteralPath (Join-Path $sibling 'events') -PathType Container){return $null}
    $store=Join-Path ([IO.Path]::GetTempPath()) ('finish-hunt-data-'+[guid]::NewGuid().ToString('N'))
    foreach($part in 'events','sessions','work'){[void][IO.Directory]::CreateDirectory((Join-Path $store $part))}
    $store
}

# Keep these equal to the accepted judge's Get-WorkbenchCITool and provisioning URL.
# The owning test compares both hashes, version and URL against the judge's actual AST.
function Get-OrvionTemporaryTool {
    [ordered]@{Version='1.7.12';SHA256='54CA21BE3DE4C7CFA26914AA8B61BD76BF573EF3CAAC5F80D110558CDF241718';ArchiveSHA256='6E7241B51E6817EA6A047693D8E6FED13B31819C9A0DD6C5A726E1592D22F6E9';Url='https://github.com/rhysd/actionlint/releases/download/v1.7.12/actionlint_1.7.12_windows_amd64.zip'}
}
function Receive-OrvionTemporaryTool([string]$Uri,[string]$OutFile){
    Invoke-WebRequest -Uri $Uri -OutFile $OutFile
}
function Restore-OrvionTemporary([string]$Target){
    if(![IO.Path]::IsPathFullyQualified($Target)){throw 'WB_TEMP_TARGET_NOT_ABSOLUTE'}
    $root=Join-Path ([IO.Path]::GetFullPath($Target)) 'ORVION-Workbench-temporary'
    foreach($name in @('')+@('tmp','cx','sb','tools','restore-staging','codex-relay-logs','scratch','retired')){
        $path=if($name){Join-Path $root $name}else{$root}
        if((Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue).Attributes-band[IO.FileAttributes]::ReparsePoint){throw 'WB_TEMP_REPARSE_REFUSED'}
        [void][IO.Directory]::CreateDirectory($path)
    }
    $tool=Get-OrvionTemporaryTool;$exe=Join-Path $root 'tools/actionlint.exe'
    if(Get-Item -LiteralPath $exe -Force -ErrorAction SilentlyContinue){
        if(!(Test-Path -LiteralPath $exe -PathType Leaf)-or
           (Get-Item -LiteralPath $exe -Force).Attributes-band[IO.FileAttributes]::ReparsePoint-or
           (Get-FileHash -LiteralPath $exe).Hash-cne$tool.SHA256){throw 'WB_TEMP_TOOL_IDENTITY'}
        return $root
    }
    $stage=Join-Path $root ('tools/.provision-'+[guid]::NewGuid().ToString('N'))
    [void][IO.Directory]::CreateDirectory($stage)
    try{
        $archive=Join-Path $stage 'actionlint.zip'
        Receive-OrvionTemporaryTool $tool.Url $archive
        if((Get-FileHash -LiteralPath $archive).Hash-cne$tool.ArchiveSHA256){throw 'WB_TEMP_ARCHIVE_IDENTITY'}
        $zip=[IO.Compression.ZipFile]::OpenRead($archive)
        $candidate=Join-Path $stage 'actionlint.exe'
        try{
            $entries=@($zip.Entries|Where-Object{$_.FullName-ceq'actionlint.exe'})
            if($entries.Count-ne1){throw 'WB_TEMP_TOOL_ENTRY_INVALID'}
            [IO.Compression.ZipFileExtensions]::ExtractToFile($entries[0],$candidate,$false)
        }finally{$zip.Dispose()}
        if((Get-FileHash -LiteralPath $candidate).Hash-cne$tool.SHA256){throw 'WB_TEMP_TOOL_IDENTITY'}
        # Publish only the verified executable; Move refuses a concurrent winner, never overwrites it.
        [IO.File]::Move($candidate,$exe)
        $root
    }finally{if([IO.Directory]::Exists($stage)){[IO.Directory]::Delete($stage,$true)}}
}
