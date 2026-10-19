# Backs up everything a fresh clone cannot restore, to one folder (a USB drive), with SHA256SUMS.txt.
#   repos\<name>.bundle   every ref and commit, including unpushed candidates and pending-tail branches
#   repos\<name>\         ignored receipts (.orvion-local-certification.json, .orvion-certifications\), .claude\settings*.json,
#                         local git config (identity, remote, per-account credential pin: commands only, never tokens), HEAD
#   owner-tools\          this workspace (tools, sessions archive, events, work) minus work\sandboxes (disposable clones)
#   claude\               user settings + ORVION project memory (never ~/.claude.json or credentials: re-login after restore)
#   legacy\               Documents\ORVION-Owner-Review, -Owner-Tools, -Sandbox, -drafts-backup, Windows-Memory-Config until migrated
#                         (nested git clones skipped: reproducible sandboxes)
# Session transcripts are sensitive, so the destination must be BitLocker-protected unless -AllowUnencrypted is passed.
# Never stores GitHub/OAuth tokens: after restore run `gh auth login` for both accounts (see README, Recovery).
param([Parameter(Mandatory)][string]$Destination,[switch]$AllowUnencrypted,[switch]$SkipLegacy)
$ErrorActionPreference='Stop'
$tools=Split-Path $PSScriptRoot -Parent;$gh=Split-Path $tools -Parent;$docs=Split-Path $gh -Parent
function Invoke-Git{param([string]$Repo)$o=& git -C $Repo @args 2>&1;if($LASTEXITCODE){throw "GIT_FAILED $Repo git $args`n$o"};$o}

$drive=[IO.Path]::GetPathRoot([IO.Path]::GetFullPath($Destination))
$bl=(New-Object -ComObject Shell.Application).NameSpace($drive).Self.ExtendedProperty('System.Volume.BitLockerProtection')
if($bl-ne1-and!$AllowUnencrypted){throw "BACKUP_UNENCRYPTED: $drive is not BitLocker-protected (state '$bl'). Turn on BitLocker To Go for the drive, or pass -AllowUnencrypted knowingly."}
$out=Join-Path $Destination ("orvion-backup-"+[DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))
if(Test-Path $out){throw "exists: $out"};New-Item -ItemType Directory $out|Out-Null
function Copy-Tree([string]$From,[string]$To,[scriptblock]$Skip={$false}){
    if(!(Test-Path -LiteralPath $From)){return}
    $src=(Get-Item -LiteralPath $From).FullName
    $files=if((Get-Item -LiteralPath $src).PSIsContainer){Get-ChildItem -LiteralPath $src -Recurse -File -Force}else{Get-Item -LiteralPath $src}
    foreach($f in $files){
        $rel=if($f.FullName-eq$src){$f.Name}else{$f.FullName.Substring($src.Length+1)}
        if(& $Skip $rel){continue}
        $d=Join-Path $To $rel;New-Item -ItemType Directory -Path (Split-Path $d -Parent) -Force|Out-Null
        $in=[IO.File]::Open($f.FullName,'Open','Read','ReadWrite,Delete');try{$o=[IO.File]::Create($d);try{$in.CopyTo($o)}finally{$o.Close()}}finally{$in.Close()}
    }
}

$plan=[ordered]@{created=[DateTime]::UtcNow.ToString('o');machine=$env:COMPUTERNAME;repos=@()}
foreach($name in 'CRM','ORVION','CRM-trusted-main','ORVION-trusted-main'){
    $r=Join-Path $gh $name;if(!(Test-Path (Join-Path $r '.git'))){continue}
    $dir=Join-Path $out "repos\$name";New-Item -ItemType Directory $dir -Force|Out-Null
    $head=(Invoke-Git $r rev-parse HEAD).Trim();$branch=(Invoke-Git $r rev-parse --abbrev-ref HEAD).Trim()
    $dirty=@(Invoke-Git $r status --porcelain).Count
    Invoke-Git $r bundle create (Join-Path $out "repos\$name.bundle") --all|Out-Null
    Invoke-Git $r bundle verify (Join-Path $out "repos\$name.bundle")|Out-Null
    [IO.File]::WriteAllLines((Join-Path $dir 'git-config-local.txt'),[string[]](Invoke-Git $r config --local --list))
    [IO.File]::WriteAllLines((Join-Path $dir 'refs.txt'),[string[]](Invoke-Git $r for-each-ref --format='%(objectname) %(refname)'))
    foreach($p in '.orvion-local-certification.json','.orvion-certifications','.claude\settings.json','.claude\settings.local.json'){
        $toDir=if(Test-Path -LiteralPath (Join-Path $r $p) -PathType Container){Join-Path $dir $p}else{[IO.Path]::Combine($dir,(Split-Path $p -Parent))}
        Copy-Tree (Join-Path $r $p) $toDir
    }
    $plan.repos+=[ordered]@{name=$name;head=$head;branch=$branch;dirty=$dirty;origin=(Invoke-Git $r config --local remote.origin.url).Trim()
        originHead="$(& git -C $r symbolic-ref -q refs/remotes/origin/HEAD)".Trim()}  # empty when the clone has none
}
Copy-Tree $tools (Join-Path $out 'owner-tools') {param($rel)$rel-like'work\sandboxes\*'}
Copy-Tree "$env:USERPROFILE\.claude\settings.json" (Join-Path $out 'claude')
Copy-Tree "$env:USERPROFILE\.claude\statusline.ps1" (Join-Path $out 'claude')
foreach($p in Get-ChildItem "$env:USERPROFILE\.claude\projects" -Directory|Where-Object{Test-Path (Join-Path $_.FullName 'memory')}){
    if($p.Name-match'Documents-GitHub|ORVION'){Copy-Tree (Join-Path $p.FullName 'memory') (Join-Path $out "claude\projects\$($p.Name)\memory")}
}
if(!$SkipLegacy){foreach($n in 'ORVION-Owner-Review','ORVION-Owner-Tools','ORVION-Sandbox','ORVION-drafts-backup','Windows-Memory-Config'){
    $src=Join-Path $docs $n;if(!(Test-Path $src)){continue}
    $clones=@(Get-ChildItem $src -Recurse -Force -Directory -Filter .git -ErrorAction SilentlyContinue|ForEach-Object{$_.Parent.FullName.Substring($src.Length+1)+'\'})
    Copy-Tree $src (Join-Path $out "legacy\$n") {param($rel)foreach($c in $clones){if($rel.StartsWith($c)){return $true}};$false}
}}
$plan|ConvertTo-Json -Depth 4|Set-Content (Join-Path $out 'backup.json')
$sums=Get-ChildItem $out -Recurse -File|ForEach-Object{"$((Get-FileHash -LiteralPath $_.FullName).Hash)  $($_.FullName.Substring($out.Length+1))"}
[IO.File]::WriteAllLines((Join-Path $out 'SHA256SUMS.txt'),[string[]]$sums)
"BACKUP: $($sums.Count) files, $([math]::Round((Get-ChildItem $out -Recurse -File|Measure-Object Length -Sum).Sum/1MB)) MB -> $out"
$plan.repos|ForEach-Object{"  $($_.name) $($_.branch)@$($_.head.Substring(0,7))$(if($_.dirty){" DIRTY($($_.dirty)): uncommitted work is NOT in the bundle"})"}
