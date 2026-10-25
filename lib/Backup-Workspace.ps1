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
param([Parameter(Mandatory)][string]$Destination,[switch]$AllowUnencrypted,[switch]$SkipLegacy,[string]$RecoveryInputs)
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

# Workbench recovery coverage v1: explicit required evidence files; no cloud transport or key custody.
$workbenchPresent=(Test-Path -LiteralPath (Join-Path $gh 'ORVION-Workbench'))-or(Test-Path -LiteralPath (Join-Path $gh 'ORVION-Workbench-trusted-main'))
$recovery=@()
if($workbenchPresent){
    foreach($name in 'ORVION-Workbench','ORVION-Workbench-trusted-main'){
        if(!(Test-Path -LiteralPath (Join-Path $gh "$name/.git") -PathType Container)){throw 'BACKUP_WORKBENCH_ROOT_REQUIRED'}
    }
    if(!$RecoveryInputs){throw 'BACKUP_RECOVERY_INPUTS_REQUIRED'}
    $inputPlan=Get-Content -LiteralPath $RecoveryInputs -Raw|ConvertFrom-Json
    # JSON arrays must be present, nonempty arrays: @($null).Count is 1 in PowerShell.
    if($inputPlan-isnot[pscustomobject]-or$inputPlan.schema-isnot[long]-and$inputPlan.schema-isnot[int]-or
       $inputPlan.schema-ne1-or$inputPlan.inputs-isnot[array]-or$inputPlan.inputs.Count-eq0){throw 'BACKUP_RECOVERY_INPUTS_INVALID'}
    $names=@{}
    foreach($item in $inputPlan.inputs){
        if($item-isnot[pscustomobject]-or$item.name-isnot[string]-or$item.path-isnot[string]-or$item.sha256-isnot[string]-or$item.name-cnotmatch'^[a-z][a-z0-9-]{0,47}$'-or$names.ContainsKey($item.name)-or![IO.Path]::IsPathFullyQualified($item.path)-or$item.sha256-cnotmatch'^[A-F0-9]{64}$'){throw 'BACKUP_RECOVERY_INPUTS_INVALID'}
        $names[$item.name]=$true
        if(!(Test-Path -LiteralPath $item.path -PathType Leaf)-or(Get-FileHash -LiteralPath $item.path).Hash-cne$item.sha256){throw 'BACKUP_RECOVERY_INPUT_REQUIRED_OR_CHANGED'}
        $recovery+=@{name=$item.name;source=$item.path;sha256=$item.sha256}
    }
    $receiptRoot=Join-Path $gh 'ORVION-Workbench'
    if(!(Test-Path -LiteralPath (Join-Path $receiptRoot '.workbench-local-certification.json') -PathType Leaf)-or
       !(Test-Path -LiteralPath (Join-Path $receiptRoot '.workbench-certifications') -PathType Container)-or
       @(Get-ChildItem -LiteralPath (Join-Path $receiptRoot '.workbench-certifications') -File).Count-eq0){throw 'BACKUP_WORKBENCH_RECEIPTS_REQUIRED'}
    foreach($f in @((Get-Item -LiteralPath (Join-Path $receiptRoot '.workbench-local-certification.json')))+@(Get-ChildItem -LiteralPath (Join-Path $receiptRoot '.workbench-certifications') -File)){
        $receipt=Get-Content -LiteralPath $f.FullName -Raw|ConvertFrom-Json
        if($receipt.digest-cnotmatch'^[A-F0-9]{64}$'-or$receipt.root-cne$receiptRoot-or$receipt.result-cne'READY'){throw 'BACKUP_WORKBENCH_RECEIPT_INVALID'}
    }
}
$plan=[ordered]@{created=[DateTime]::UtcNow.ToString('o');machine=$env:COMPUTERNAME;repos=@()}
foreach($name in 'CRM','ORVION','CRM-trusted-main','ORVION-trusted-main','ORVION-Workbench','ORVION-Workbench-trusted-main'){
    $r=Join-Path $gh $name;if(!(Test-Path (Join-Path $r '.git'))){continue}
    $dir=Join-Path $out "repos\$name";New-Item -ItemType Directory $dir -Force|Out-Null
    $head=(Invoke-Git $r rev-parse HEAD).Trim();$branch=(Invoke-Git $r rev-parse --abbrev-ref HEAD).Trim()
    $dirty=@(Invoke-Git $r status --porcelain).Count
    # a bundle keeps refs, not the stash reflog or a linked worktree's state: count them so the report can say so
    $stash=@(Invoke-Git $r stash list).Count;$worktrees=@(Invoke-Git $r worktree list --porcelain|Where-Object{$_-like'worktree *'}).Count-1
    Invoke-Git $r bundle create (Join-Path $out "repos\$name.bundle") --all|Out-Null
    Invoke-Git $r bundle verify (Join-Path $out "repos\$name.bundle")|Out-Null
    $localConfig=@(Invoke-Git $r config --local --list)
    if($name-like'ORVION-Workbench*'){
        # Only approved non-secret identity/routing settings. Never retain auth headers or arbitrary helper commands.
        if(@($localConfig|Where-Object{$_-match'^(http\..*(extraheader|cookiefile)|credential\..*|core\.(sshcommand|gitproxy)|include\.)='}).Count){throw 'BACKUP_WORKBENCH_UNSAFE_CONFIG'}
        $localConfig=@($localConfig|Where-Object{$_-match'^(user\.(name|email)|core\.(hookspath|autocrlf)|branch\.[^=]+\.(remote|merge)|remote\.origin\.(url|pushurl)|push\.default|protocol\.[a-z.]+|gc\.auto|maintenance\.auto)='})
        foreach($line in $localConfig){
            $key,$value=$line-split'=',2
            if($value-match'[\x00-\x1f]' -or ($key-like'remote.origin.*'-and$value-ne'DISABLED'-and$value-notmatch'^https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(?:\.git)?$') -or ($key-eq'core.hookspath'-and$value-ne'.githooks')){throw 'BACKUP_WORKBENCH_UNSAFE_CONFIG'}
        }
    }
    [IO.File]::WriteAllLines((Join-Path $dir 'git-config-local.txt'),[string[]]$localConfig)
    [IO.File]::WriteAllLines((Join-Path $dir 'refs.txt'),[string[]](Invoke-Git $r for-each-ref --format='%(objectname) %(refname)'))
    $receiptPaths=if($name-like'ORVION-Workbench*'){@('.workbench-local-certification.json','.workbench-certifications')}else{@('.orvion-local-certification.json','.orvion-certifications','.claude\settings.json','.claude\settings.local.json')}
    foreach($p in $receiptPaths){
        $toDir=if(Test-Path -LiteralPath (Join-Path $r $p) -PathType Container){Join-Path $dir $p}else{[IO.Path]::Combine($dir,(Split-Path $p -Parent))}
        Copy-Tree (Join-Path $r $p) $toDir
    }
    $plan.repos+=[ordered]@{name=$name;head=$head;branch=$branch;dirty=$dirty;stash=$stash;worktrees=$worktrees;origin=(Invoke-Git $r config --local remote.origin.url).Trim()
        originHead="$(& git -C $r symbolic-ref -q refs/remotes/origin/HEAD)".Trim()}  # empty when the clone has none
}
if($workbenchPresent){
    foreach($item in $recovery){
        $file=Join-Path $out ("recovery-inputs/"+$item.name)
        [void][IO.Directory]::CreateDirectory((Split-Path $file -Parent))
        [IO.File]::Copy($item.source,$file,$false)
        if((Get-FileHash -LiteralPath $file).Hash-cne$item.sha256){throw 'BACKUP_RECOVERY_INPUT_CHANGED_DURING_COPY'}
    }
    $plan.workbenchRecovery=[ordered]@{schema=1;inputs=$recovery;receiptFiles=@(Get-ChildItem -LiteralPath (Join-Path $out 'repos/ORVION-Workbench/.workbench-certifications') -File|ForEach-Object{$_.Name})}
}
Copy-Tree $tools (Join-Path $out 'owner-tools') {param($rel)$rel-like'work\sandboxes\*'}
Copy-Tree "$env:USERPROFILE\.claude\settings.json" (Join-Path $out 'claude')
Copy-Tree "$env:USERPROFILE\.claude\statusline.ps1" (Join-Path $out 'claude')
$projects=Join-Path $env:USERPROFILE '.claude\projects'
# Claude is optional; errors reading a present source still terminate the backup before its manifest.
if(Test-Path -LiteralPath $projects){
if(!(Test-Path -LiteralPath $projects -PathType Container)){throw 'BACKUP_CLAUDE_PROJECTS_NOT_DIRECTORY'}
foreach($p in Get-ChildItem -LiteralPath $projects -Directory|Where-Object{Test-Path (Join-Path $_.FullName 'memory')}){
    if($p.Name-match'Documents-GitHub|ORVION'){Copy-Tree (Join-Path $p.FullName 'memory') (Join-Path $out "claude\projects\$($p.Name)\memory")}
}
}
if(!$SkipLegacy){foreach($n in 'ORVION-Owner-Review','ORVION-Owner-Tools','ORVION-Sandbox','ORVION-drafts-backup','Windows-Memory-Config'){
    $src=Join-Path $docs $n;if(!(Test-Path $src)){continue}
    # nested clones are reproducible sandboxes; a legacy folder that is itself a repository keeps its files, not its .git
    $clones=@(Get-ChildItem $src -Recurse -Force -Directory -Filter .git -ErrorAction SilentlyContinue|ForEach-Object{$p=$_.Parent.FullName;if($p.Length-gt$src.Length){$p.Substring($src.Length+1)+'\'}else{'.git\'}})
    Copy-Tree $src (Join-Path $out "legacy\$n") {param($rel)foreach($c in $clones){if($rel.StartsWith($c)){return $true}};$false}
}}
$plan|ConvertTo-Json -Depth 4|Set-Content (Join-Path $out 'backup.json')
$sums=Get-ChildItem $out -Recurse -File|ForEach-Object{"$((Get-FileHash -LiteralPath $_.FullName).Hash)  $($_.FullName.Substring($out.Length+1))"}
[IO.File]::WriteAllLines((Join-Path $out 'SHA256SUMS.txt'),[string[]]$sums)
"BACKUP: $($sums.Count) files, $([math]::Round((Get-ChildItem $out -Recurse -File|Measure-Object Length -Sum).Sum/1MB)) MB -> $out"
$plan.repos|ForEach-Object{"  $($_.name) $($_.branch)@$($_.head.Substring(0,7))$(if($_.dirty){" DIRTY($($_.dirty)): uncommitted work is NOT in the bundle"})$(if($_.stash){"; $($_.stash) stash(es): only the newest survives a bundle"})$(if($_.worktrees-gt0){"; $($_.worktrees) linked worktree(s): their uncommitted state is NOT backed up"})"}
'  not backed up by design: supabase\.temp (recreated by `supabase link`), credentials (re-login: gh auth login, supabase login)'
