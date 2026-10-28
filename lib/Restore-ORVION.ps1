# Fresh-Windows entry: only the three recovery prerequisites are installed here.
# Keep ASCII and Windows PowerShell 5.1 compatible: pwsh does not exist yet.
param([string]$PackageDir=$PSScriptRoot,[string]$Staging,
      [string]$Target=(Join-Path $env:USERPROFILE 'Documents\GitHub'),
      [string]$ClaudeHome=(Join-Path $env:USERPROFILE '.claude'),
      [string]$LegacyTarget,
      [string]$CodexHome=(Join-Path $env:USERPROFILE '.codex'),
      [switch]$AllowNewProfile,[switch]$SkipProducts)
$ErrorActionPreference='Stop'

function Get-RecoveryTool([string]$Name){
    $command=Get-Command $Name -CommandType Application -ErrorAction SilentlyContinue|Select-Object -First 1
    if($command){return $command.Source}
    if($Name-eq'7z'){
        $fallback=Join-Path $env:ProgramFiles '7-Zip\7z.exe'
        if(Test-Path -LiteralPath $fallback -PathType Leaf){return $fallback}
    }
}
function Update-RecoveryPath{
    $env:PATH=[Environment]::GetEnvironmentVariable('Path','Machine')+';'+[Environment]::GetEnvironmentVariable('Path','User')
}
# Resolve existing ancestors too: a junction must not hide a persistent destination inside staging.
function Get-RecoveryActualPath([string]$Path,[int]$Depth=0){
    if($Depth-gt128){throw 'RECOVERY_PATH_UNRESOLVED'}
    $full=[IO.Path]::GetFullPath($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path))
    if($full-eq[IO.Path]::GetPathRoot($full)){return $full}
    $full=$full.TrimEnd('\','/')
    $item=Get-Item -LiteralPath $full -Force -ErrorAction SilentlyContinue
    if($item){
        if($item.Attributes-band[IO.FileAttributes]::ReparsePoint){
            $linkTarget=@($item.Target)[0]
            if(!$linkTarget){throw 'RECOVERY_PATH_UNRESOLVED'}
            if(![IO.Path]::IsPathRooted($linkTarget)){$linkTarget=Join-Path (Split-Path $full -Parent) $linkTarget}
            return Get-RecoveryActualPath $linkTarget ($Depth+1)
        }
    }
    $parent=Split-Path $full -Parent
    if(!$parent-or$parent-eq$full){return $full}
    Join-Path (Get-RecoveryActualPath $parent ($Depth+1)) (Split-Path $full -Leaf)
}
# Function seam: focused tests replace process execution, never invoking real installers or logins.
function Invoke-RecoveryProcess([string]$File,[string[]]$Arguments){
    # Windows PowerShell can surface ordinary native stderr as a PowerShell error.
    $ErrorActionPreference='Continue'
    & $File @Arguments
    $script:NativeExitCode=$LASTEXITCODE
}
function Get-RecoveryExpandedBytes([string]$Archive){
    $listing=@(Invoke-RecoveryProcess (Get-RecoveryTool '7z') @('l','-slt','-ba',$Archive))
    if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw 'RECOVERY_DISK_METADATA_UNREADABLE'}
    [long]$total=0;$entries=0
    foreach($block in (($listing-join"`n")-split'\r?\n\s*\r?\n')){
        if(!$block.Trim()){continue}
        $paths=[regex]::Matches($block,'(?m)^Path = .+\r?$')
        $sizes=[regex]::Matches($block,'(?m)^Size = ([0-9]+)\r?$')
        [long]$size=0
        if($paths.Count-ne1-or$sizes.Count-ne1-or![long]::TryParse($sizes[0].Groups[1].Value,[ref]$size)-or$size-gt([long]::MaxValue-$total)){throw 'RECOVERY_DISK_METADATA_UNREADABLE'}
        $total+=$size;$entries++
    }
    if(!$entries){throw 'RECOVERY_DISK_METADATA_UNREADABLE'}
    return $total
}
function Get-RecoveryFreeBytes([string]$Path){
    try{
        $drive=New-Object IO.DriveInfo ([IO.Path]::GetPathRoot($Path))
        if(!$drive.IsReady){throw 'not ready'}
        return $drive.AvailableFreeSpace
    }catch{throw 'RECOVERY_DISK_SPACE_UNREADABLE'}
}
function Get-RecoveryPackage([string]$Directory){
    $archive=Get-ChildItem -LiteralPath $Directory -Filter 'orvion-backup-*.7z' -File|Sort-Object Name -Descending|Select-Object -First 1
    if(!$archive){throw 'RECOVERY_PACKAGE_MISSING: no orvion-backup-*.7z in the package folder'}
    $sidecar=$archive.FullName+'.sha256'
    if(!(Test-Path -LiteralPath $sidecar -PathType Leaf)){throw "RECOVERY_SIDECAR_MISSING: $sidecar (never falling back to an older package)"}
    $line=[IO.File]::ReadAllText($sidecar).Trim()
    if($line-notmatch'^([A-Fa-f0-9]{64}) \*(.+)$'-or$Matches[2]-cne$archive.Name){throw 'RECOVERY_SIDECAR_INVALID: expected HASH *archive-name'}
    $expected=$Matches[1]
    # Reading every byte also hydrates a OneDrive Files On-Demand archive.
    if((Get-FileHash -LiteralPath $archive.FullName -Algorithm SHA256).Hash-ne$expected){throw "RECOVERY_HASH_MISMATCH: $($archive.Name) (never falling back to an older package)"}
    $archive.FullName
}
function Write-RecoveryPluginChecklist([string]$Settings,[string[]]$Installed){
    if(!(Test-Path -LiteralPath $Settings -PathType Leaf)){return}
    $settingsObject=Get-Content -LiteralPath $Settings -Raw|ConvertFrom-Json
    $seen=@{}
    foreach($line in $Installed){if($line-match'^\s*>\s+([^\s]+@[^\s]+)\s*$'){$seen[$Matches[1]]=$true}}
    $added=@{}
    foreach($entry in $settingsObject.enabledPlugins.PSObject.Properties){
        if($entry.Value-isnot[bool]-or!$entry.Value-or$seen.ContainsKey($entry.Name)){continue}
        $name,$market=$entry.Name-split'@',2
        if(!$market){Write-Host "ACTION: invalid enabled plugin name: $($entry.Name)";continue}
        if($market-ne'claude-plugins-official'-and!$added.ContainsKey($market)){
            $added[$market]=$true
            $source=$null
            if($settingsObject.extraKnownMarketplaces){$property=$settingsObject.extraKnownMarketplaces.PSObject.Properties[$market];if($property){$source=$property.Value.source;if($source-is[string]){$source=$property.Value}}}
            if($source-and$source.source-eq'github'-and$source.repo){Write-Host "ACTION: claude plugin marketplace add $($source.repo)"}
            elseif($source-and$source.source-eq'directory'){Write-Host "ACTION: $market directory marketplace: install GitKraken CLI, then its own hook installer"}
            else{Write-Host "ACTION: recover marketplace source for $market from settings before installing"}
        }
        Write-Host "ACTION: claude plugin install $($entry.Name) --scope user"
    }
}
function Write-RecoveryChecklist([string]$Target,[string]$ClaudeHome,[string]$CodexHome){
    Write-Host 'READY/ACTION recovery checklist (manual steps; no further installation here)'
    Write-Host 'ACTION: revoke old GitHub CLI authorizations on github.com for PlatPlusHub and Shehabhub, then gh auth login for each account'
    Write-Host 'ACTION: supabase login; claude and codex sign-in; Docker first run; WSL admin/reboot if product prepare reported it'
    Write-Host "ACTION: re-enter the two masked local postgres passwords in $CodexHome\config.toml (merge config.toml.restored if present)"
    Write-Host "ACTION: Marketing-MCP from the owner's OneDrive Personal Vault, then its own tunnel installer (not packaged)"
    $installed=@();$claude=Get-RecoveryTool 'claude'
    if($claude){
        $installed=@(Invoke-RecoveryProcess $claude @('plugin','list'))
        if($script:NativeExitCode){Write-Host 'ACTION: claude plugin list failed; plugin presence is unverified; commands below cover all enabled plugins';if(!$script:RecoveryExit){$script:RecoveryExit=$script:NativeExitCode};$installed=@()}
    }
    Write-RecoveryPluginChecklist (Join-Path $ClaudeHome 'settings.json') $installed
    foreach($product in 'CRM','ORVION'){Write-Host "ACTION: in $Target\$product run pwsh -NoProfile -File scripts\check_agent_continuity.ps1 -Boot; require ORVION: READY"}
    Write-Host "ACTION: in $Target\ORVION-Workbench run pwsh -NoProfile -File lib\Workbench.ps1 -Boot; require WORKBENCH: READY"
    Write-Host "ACTION: use restored ORVION-Owner-Tools as the data root (repair/unset ORVION_DATA_ROOT if needed); record C2 with restore and all three Boot outputs per HANDOFF.md section 12"
}
function Invoke-OrvionRecovery([string]$PackageDir,[string]$Staging,[string]$Target,[string]$ClaudeHome,[string]$LegacyTarget,[string]$CodexHome,[switch]$AllowNewProfile,[switch]$SkipProducts){
    $script:RecoveryExit=0;$ownsStaging=$false
    try{
        if(!$Staging){$Staging=Join-Path $Target ('ORVION-Workbench-temporary\restore-staging\'+[DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffffffZ')+'-'+[guid]::NewGuid().ToString('N'))}
        $Staging=[IO.Path]::GetFullPath($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Staging))
        $actualStage=Get-RecoveryActualPath $Staging
        foreach($destination in @((Join-Path $Target 'ORVION-Workbench'),(Join-Path $Target 'ORVION-Workbench-trusted-main'),(Join-Path $Target 'ORVION-Owner-Tools'),(Join-Path $Target 'CRM'),(Join-Path $Target 'CRM-trusted-main'),(Join-Path $Target 'ORVION'),(Join-Path $Target 'ORVION-trusted-main'),(Join-Path $Target 'ORVION-Workbench-temporary'),$ClaudeHome,$CodexHome)+@($LegacyTarget|Where-Object{$_})){
            $actual=Get-RecoveryActualPath $destination
            if($actual-ieq$actualStage-or$actual.StartsWith($actualStage+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'RECOVERY_DESTINATION_IN_STAGING'}
        }
        $protected=@((Join-Path $Target 'ORVION-Workbench'),(Join-Path $Target 'ORVION-Workbench-trusted-main'),(Join-Path $Target 'ORVION-Owner-Tools'),(Join-Path $Target 'CRM'),(Join-Path $Target 'CRM-trusted-main'),(Join-Path $Target 'ORVION'),(Join-Path $Target 'ORVION-trusted-main'),$ClaudeHome,$CodexHome,(Join-Path $env:USERPROFILE '.claude'),(Join-Path $env:USERPROFILE '.codex'))+@($LegacyTarget,$env:ORVION_DATA_ROOT|Where-Object{$_})
        foreach($path in $protected){
            $actual=Get-RecoveryActualPath $path
            if($actualStage-ieq$actual-or$actualStage.StartsWith($actual.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'RECOVERY_STAGING_PLACEMENT_REFUSED'}
        }
        foreach($path in @((Join-Path $env:USERPROFILE 'OneDrive'),$env:OneDrive,$env:OneDriveConsumer,$env:OneDriveCommercial)|Where-Object{$_}){
            $known=[IO.Path]::GetFullPath($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($path)).TrimEnd('\')
            if($Staging-ieq$known-or$Staging.StartsWith($known+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'RECOVERY_STAGING_PLACEMENT_REFUSED'}
            # Cloud reparse roots may expose no link Target. Staging resolution itself still
            # fails closed through such a root; do not require unrelated sync hydration.
            try{$known=Get-RecoveryActualPath $path}catch{if($_.Exception.Message-ne'RECOVERY_PATH_UNRESOLVED'){throw}}
            if($actualStage-ieq$known-or$actualStage.StartsWith($known.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'RECOVERY_STAGING_PLACEMENT_REFUSED'}
        }
        # Inspect ancestor metadata only, including independently named Git repositories.
        $ancestor=$actualStage
        while($ancestor){
            if((Split-Path $ancestor -Leaf)-ieq'ORVION-Owner-Tools'){throw 'RECOVERY_STAGING_PLACEMENT_REFUSED'}
            if(Test-Path -LiteralPath (Join-Path $ancestor '.git')){throw 'RECOVERY_STAGING_PLACEMENT_REFUSED'}
            $parent=Split-Path $ancestor -Parent
            if($parent-eq$ancestor){break};$ancestor=$parent
        }
        if(Test-Path -LiteralPath $Staging){throw "RECOVERY_STAGING_EXISTS: $Staging must not exist; inspect it before retrying"}
        foreach($item in @(@('git','Git.Git'),@('7z','7zip.7zip'),@('pwsh','Microsoft.PowerShell'))){
            if(!(Get-RecoveryTool $item[0])){
                $winget=Get-RecoveryTool 'winget'
                if(!$winget){throw 'RECOVERY_WINGET_REQUIRED: install App Installer from Microsoft Store, then rerun'}
                Invoke-RecoveryProcess $winget @('install','--id',$item[1],'--exact','--source','winget','--accept-source-agreements','--accept-package-agreements')
                if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw "RECOVERY_INSTALL_FAILED: $($item[1])"}
                Update-RecoveryPath
            }
            if(!(Get-RecoveryTool $item[0])){throw "RECOVERY_COMMAND_MISSING: $($item[0]) after prerequisite setup"}
        }
        $archive=Get-RecoveryPackage $PackageDir
        try{$expanded=Get-RecoveryExpandedBytes $archive}catch{throw 'RECOVERY_DISK_METADATA_UNREADABLE'}
        # Separate modest headroom for filesystem metadata/allocation; not a compressed-size multiplier
        # and not a promise of capacity for later clone/restore/product preparation.
        [long]$reserve=64MB
        $free=Get-RecoveryFreeBytes $actualStage
        if($null-eq$free-or$free-isnot[long]-or$free-lt0){throw 'RECOVERY_DISK_SPACE_UNREADABLE'}
        Write-Host "STAGING DISK: expanded logical bytes=$expanded; reserve bytes=$reserve; available bytes=$free (snapshot, not reserved)"
        if($expanded-gt([long]::MaxValue-$reserve)-or$free-lt($expanded+$reserve)){throw 'RECOVERY_DISK_SPACE_INSUFFICIENT'}
        $null=New-Item -ItemType Directory -Path $Staging;$ownsStaging=$true
        $extract=Join-Path $Staging 'pkg'
        Invoke-RecoveryProcess (Get-RecoveryTool '7z') @('x',"-o$extract",$archive)
        if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw 'RECOVERY_EXTRACT_FAILED'}
        # Backup packages have one enclosing orvion-backup-<UTC> directory.
        $roots=@(Get-ChildItem -LiteralPath $extract -Directory|Where-Object{Test-Path -LiteralPath (Join-Path $_.FullName 'backup.json') -PathType Leaf})
        if($roots.Count-ne1){throw 'RECOVERY_LAYOUT_INVALID: expected one package directory with backup.json'}
        $pkg=$roots[0].FullName;$plan=Get-Content -LiteralPath (Join-Path $pkg 'backup.json') -Raw|ConvertFrom-Json
        if(!$plan.sourceUserProfile-or$plan.sourceUserProfile.TrimEnd('\')-ine$env:USERPROFILE.TrimEnd('\')){
            Write-Host 'ACTION: docs/RECOVERY.md Manual fallback, profile paths: repair absolute hooks, settings and Claude memory paths by hand; historical receipts keep their original roots'
            if(!$AllowNewProfile){throw 'RECOVERY_PROFILE_MISMATCH: source profile differs or is unrecorded; use -AllowNewProfile only with the manual-path step'}
        }
        $records=@($plan.repos|Where-Object{$_.name-ceq'ORVION-Workbench'})
        if($records.Count-ne1-or$records[0].head-cnotmatch'^[a-f0-9]{40}$'-or!$records[0].branch){throw 'RECOVERY_WORKBENCH_RECORD_INVALID'}
        $record=$records[0];$wb=Join-Path $Staging 'wb';$git=Get-RecoveryTool 'git'
        Invoke-RecoveryProcess $git @('clone','--no-checkout',(Join-Path $pkg 'repos\ORVION-Workbench.bundle'),$wb)
        if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw 'RECOVERY_WORKBENCH_CLONE_FAILED'}
        Invoke-RecoveryProcess $git @('-C',$wb,'config','core.longpaths','true')
        if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw 'RECOVERY_WORKBENCH_CONFIG_FAILED'}
        $checkout=@('-C',$wb,'checkout','--quiet')
        if($record.branch-eq'HEAD'){$checkout+=@('--detach',$record.head)}else{$checkout+=@('-B',$record.branch,$record.head)}
        Invoke-RecoveryProcess $git $checkout
        if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw 'RECOVERY_WORKBENCH_CHECKOUT_FAILED'}
        $restoreArgs=@('-NoProfile','-File',(Join-Path $wb 'lib\Restore-Workspace.ps1'),'-From',$pkg,'-Target',$Target,'-ClaudeHome',$ClaudeHome,'-CodexHome',$CodexHome)
        if($LegacyTarget){$restoreArgs+=@('-LegacyTarget',$LegacyTarget)}
        Invoke-RecoveryProcess (Get-RecoveryTool 'pwsh') $restoreArgs
        if($script:NativeExitCode){$script:RecoveryExit=$script:NativeExitCode;throw 'RECOVERY_RESTORE_FAILED'}
        foreach($operation in @(@('lib\Restore-Workspace.ps1','-Temporary','-Target',$Target),@('lib\Map-Repos.ps1','-Install','-GitHub',$Target))){
            Invoke-RecoveryProcess (Get-RecoveryTool 'pwsh') (@('-NoProfile','-File',(Join-Path $Target ('ORVION-Workbench\'+$operation[0])))+@($operation[1..($operation.Count-1)]))
            if($script:NativeExitCode){Write-Host "ACTION: $($operation[0]) failed (exit $script:NativeExitCode)";if(!$script:RecoveryExit){$script:RecoveryExit=$script:NativeExitCode}}
        }
        if(!$SkipProducts){foreach($product in 'CRM','ORVION'){
            $entry=Join-Path $Target "$product\workstation.cmd"
            if(!(Test-Path -LiteralPath $entry -PathType Leaf)){Write-Host "ACTION: product entry missing: $entry";if(!$script:RecoveryExit){$script:RecoveryExit=1};continue}
            Invoke-RecoveryProcess $entry @()
            if($script:NativeExitCode){Write-Host "ACTION: $product workstation preparation failed (exit $script:NativeExitCode); restored files are retained";if(!$script:RecoveryExit){$script:RecoveryExit=$script:NativeExitCode}}
        }}
    }catch{
        if(!$script:RecoveryExit){$script:RecoveryExit=1}
        $code='RECOVERY_FAILED'
        if($_.Exception.Message-match'\A(RECOVERY_[A-Z_]+)(?::|$)'){$code=$Matches[1]}
        Write-Host "ACTION: $code; inspect the package and requested paths before retrying"
        if($code-like'RECOVERY_DISK_*'){Write-Host 'ACTION: verify 7z l -slt -ba metadata and staging-volume free space; free local capacity or choose another permitted -Staging, then retry'}
    }
    try{Write-RecoveryChecklist $Target $ClaudeHome $CodexHome}catch{if(!$script:RecoveryExit){$script:RecoveryExit=1};Write-Host 'ACTION: RECOVERY_CHECKLIST_FAILED'}
    if($ownsStaging){
        $status='failed';if($script:RecoveryExit-eq0){$status='completed'}
        Write-Host "ACTION: staging retained at $Staging; status=$status; purpose=extracted recovery package and bootstrap checkout"
        Write-Host 'ACTION: retained staging is sensitive and unencrypted; protect local access, inspect accumulated attempts, and obtain separate owner authorization for disposal'
    }
    if($script:RecoveryExit-eq0){Write-Host 'READY: restore and requested preparation completed'}
}
Invoke-OrvionRecovery -PackageDir $PackageDir -Staging $Staging -Target $Target -ClaudeHome $ClaudeHome -LegacyTarget $LegacyTarget -CodexHome $CodexHome -AllowNewProfile:$AllowNewProfile -SkipProducts:$SkipProducts
exit $script:RecoveryExit
