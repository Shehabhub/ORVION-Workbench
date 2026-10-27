# Backs up everything a fresh clone cannot restore, to one folder (a USB drive), with SHA256SUMS.txt.
#   repos\<name>.bundle   every ref and commit, including unpushed candidates and pending-tail branches
#   repos\<name>\         ignored receipts (.orvion-local-certification.json, .orvion-certifications\), .claude\settings*.json,
#                         local git config (identity, remote, per-account credential pin: commands only, never tokens), HEAD
#   owner-tools\          GitHub\ORVION-Owner-Tools (sessions archive, events journal, work) minus work\sandboxes (disposable clones)
#   claude\               user settings only; memory lives in owner-tools\records\claude-memory
# Session transcripts are sensitive, so the destination must be BitLocker-protected unless -AllowUnencrypted is passed.
# -Package writes one compressed, UNENCRYPTED 7z instead (owner decision 2026-10-26: recoverability over secrecy), staged under
# TEMP and removed. gitleaks (when installed) scans the staging first and writes <archive>.secret-scan.txt next to it: rule,
# file and line only, never a value. The scan reports; it does not block. docs\RECOVERY.md says what to do with findings.
# Never stores GitHub/OAuth tokens: after restore run `gh auth login` for both accounts (see README, Recovery).
param([Parameter(Mandatory)][string]$Destination,[switch]$AllowUnencrypted,[switch]$SkipLegacy,[string]$RecoveryInputs,[switch]$Package)
$ErrorActionPreference='Stop'
$tools=Split-Path $PSScriptRoot -Parent;$gh=Split-Path $tools -Parent;$docs=Split-Path $gh -Parent
# Same data-root default as the readers; the script's checkout is already a repository bundle.
$ownerTools=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'})
if(!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $ownerTools 'events') -PathType Container)){throw 'ORVION_DATA_ROOT_UNAVAILABLE'}
# Selective package v1: on success only stdout is returned; stderr warnings (CRLF) must never count as entries.
# A failure names the subcommand and masks URL credentials: arguments and output may carry config values.
$ownerTools=[IO.Path]::GetFullPath($ownerTools).TrimEnd('\')
if(Get-Item -LiteralPath (Join-Path $ownerTools '.git') -Force -ErrorAction SilentlyContinue){throw 'BACKUP_DATA_ROOT_GIT_REFUSED'}
. (Join-Path $PSScriptRoot 'workspace-layout.ps1')
$temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout $tools
function Invoke-Git{param([string]$Repo)$o=& git -C $Repo @args 2>&1;if($LASTEXITCODE){throw "GIT_FAILED $Repo git $($args[0]) (exit $LASTEXITCODE)`n$("$o"-replace'://[^/@\s]+@','://***@')"};$o|Where-Object{$_-isnot[Management.Automation.ErrorRecord]}}
function Get-SevenZip{$z=(Get-Command 7z -CommandType Application -ErrorAction SilentlyContinue|Select-Object -First 1).Source;if(!$z){$z=Join-Path $env:ProgramFiles '7-Zip\7z.exe'};if(!(Test-Path -LiteralPath $z)){throw 'PACKAGE_7ZIP_REQUIRED'};$z}
function Get-SafeConfig([string]$Repo){
    foreach($entry in ((@(Invoke-Git $Repo config --local --null --list)-join"`n")-split"`0"|Where-Object{$_})){
        $key,$value=$entry-split"`n",2
        $safeKey=$key-replace'://[^/\s]*@','://';$safeValue=$value-replace'://[^/\s]*@','://'
        if($key-cne$safeKey-or$value-cne$safeValue){Write-Warning "BACKUP_CONFIG_USERINFO_STRIPPED: $safeKey"}
        $key=$safeKey;$value=$safeValue
        if($key-match'^http\..*(extraheader|cookiefile)$'-or$value-match'[\x00-\x1f]'){throw "BACKUP_UNSAFE_CONFIG: $key"}
        # Clone/init recreates this metadata; neither store it nor warn about its omission.
        if($key-match'^(core\.(repositoryformatversion|filemode|bare|logallrefupdates|symlinks|ignorecase)|remote\.origin\.fetch)$'){continue}
        # Whole helper values only; the owner function must use the same login twice.
        if($key-match'^credential\.(.*\.)?helper$'-and$value-cnotmatch'\A(?:|manager|manager-core|wincred|!gh auth (?:git-credential|token)(?: --hostname [A-Za-z0-9.-]+)?|!f\(\) \{ echo username=([A-Za-z0-9-]{1,39}); echo "password=\$\(gh auth token --user \1\)"; \}; f)\z'){throw "BACKUP_UNSAFE_CONFIG: $key"}
        if($key-match'^(user\.(name|email)|core\.(hookspath|autocrlf)|branch\.[^=]+\.(remote|merge)|remote\.origin\.(url|pushurl)|push\.default|protocol\.[a-z.]+|gc\.auto|maintenance\.auto|credential\.(.*\.)?(helper|username|usehttppath))$'){
            if($value-match'gh[pousr]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}|password=(?!\$\(gh auth token)'){throw "BACKUP_UNSAFE_CONFIG: $key"}
            "$key=$value"
        }
        else{Write-Warning "BACKUP_CONFIG_OMITTED: $key"}
    }
}

function Protect-CodexConfig([string]$Text){
    $quoted='""".*?"""|\x27{3}.*?\x27{3}|"(?:\\.|[^"\\])*"|''[^'']*'''
    # Consume composite values together: masking a secret array/table must not leave tail bytes.
    $composite='[\[{](?:(?:'+$quoted+')|#[^\r\n]*|(?<depth>[\[{])|(?<-depth>[\]}])|[^\[\]{}"''#])*(?(depth)(?!))[\]}]'
    $pattern='(?ms)(?<prefix>(?:^|[,\[{]\s*)[ \t]*(?<key>"[^"\r\n]+"|''[^''\r\n]+''|[A-Za-z0-9_.-]+)[ \t]*=[ \t]*)(?<value>'+$quoted+'|'+$composite+'|[^\[\]{},\r\n#]+)'
    $masked=[regex]::Replace($Text,$pattern,{
        param($match)
        $key=$match.Groups['key'].Value.Trim('"',"'")
        $value=$match.Groups['value'].Value
        # Whole credential words only (separator- or camelCase-bounded): "path", "patch", "keyboard" are not secrets.
        if(($key-match'(?i)(?:^|[_.\-])(?:api_?keys?|keys?|tokens?|secrets?|passwords?|passwd|pats?)(?:$|[_.\-])'-or$key-cmatch'[a-z0-9](?:Keys?|Tokens?|Secrets?|Passwords?|Pats?)$')-and$key-notmatch'(?i)_(?:env|env_var)$'){
            # Explicit environment substitutions are references, not inline credentials.
            if($value-notmatch'^(["''])?\$(?:\{[A-Za-z_][A-Za-z0-9_]*\}|[A-Za-z_][A-Za-z0-9_]*|env:[A-Za-z_][A-Za-z0-9_]*)(?:["''])?$'){$value='"***"'}
        }
        elseif($value.TrimStart()-match'^[\[{]'){$value=Protect-CodexConfig $value}
        $match.Groups['prefix'].Value+$value
    })
    [regex]::Replace($masked,'://([^:/@\s]+):([^@\s]*)@',{
        param($match)
        if($match.Groups[2].Value-match'^\$(?:\{[A-Za-z_][A-Za-z0-9_]*\}|[A-Za-z_][A-Za-z0-9_]*|env:[A-Za-z_][A-Za-z0-9_]*)$'){return $match.Value}
        '://'+$match.Groups[1].Value+':***@'
    })
}

if($Package){
    $zip=Get-SevenZip
    # Selective package v1: a package without both products is incomplete; refuse instead of omitting them.
    foreach($n in 'CRM','ORVION','CRM-trusted-main','ORVION-trusted-main'){if(!(Test-Path -LiteralPath (Join-Path $gh "$n\.git"))){throw "PACKAGE_REPO_REQUIRED: $n"}}
    $staging=Join-Path ([IO.Path]::GetTempPath()) ("orvion-package-"+[guid]::NewGuid().ToString('N'))
    $out=Join-Path $staging ("orvion-backup-"+[DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))
}else{
$drive=[IO.Path]::GetPathRoot([IO.Path]::GetFullPath($Destination))
$bl=(New-Object -ComObject Shell.Application).NameSpace($drive).Self.ExtendedProperty('System.Volume.BitLockerProtection')
if($bl-ne1-and!$AllowUnencrypted){throw "BACKUP_UNENCRYPTED: $drive is not BitLocker-protected (state '$bl'). Turn on BitLocker To Go for the drive, or pass -AllowUnencrypted knowingly."}
$out=Join-Path $Destination ("orvion-backup-"+[DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))
}
if(Test-Path $out){throw "exists: $out"};New-Item -ItemType Directory $out|Out-Null
try{
function Copy-Tree([string]$From,[string]$To,[scriptblock]$Skip={$false}){
    if(!(Test-Path -LiteralPath $From)){return}
    $src=(Get-Item -LiteralPath $From).FullName
    # Empty memory directories still identify projects that need junctions after recovery.
    if((Get-Item -LiteralPath $src).PSIsContainer){
        [void][IO.Directory]::CreateDirectory($To)
        foreach($directory in Get-ChildItem -LiteralPath $src -Recurse -Directory -Force){
            $relative=$directory.FullName.Substring($src.Length+1)
            if(!(& $Skip ($relative+'\'))){[void][IO.Directory]::CreateDirectory((Join-Path $To $relative))}
        }
    }
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
    if(!(Test-Path -LiteralPath (Join-Path $ownerTools 'events\events.jsonl') -PathType Leaf)-or!(Test-Path -LiteralPath (Join-Path $ownerTools 'sessions') -PathType Container)){throw 'BACKUP_JOURNAL_REQUIRED'}
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
$plan=[ordered]@{created=[DateTime]::UtcNow.ToString('o');machine=$env:COMPUTERNAME;sourceUserProfile=$env:USERPROFILE;repos=@()};$bundledTips=@{}
foreach($name in 'CRM','ORVION','CRM-trusted-main','ORVION-trusted-main','ORVION-Workbench','ORVION-Workbench-trusted-main'){
    $r=Join-Path $gh $name;if(!(Test-Path (Join-Path $r '.git'))){continue}
    $dir=Join-Path $out "repos\$name";New-Item -ItemType Directory $dir -Force|Out-Null
    $head=(Invoke-Git $r rev-parse HEAD).Trim();$branch=(Invoke-Git $r rev-parse --abbrev-ref HEAD).Trim()
    $dirty=@(Invoke-Git $r status --porcelain).Count
    # a bundle keeps refs, not the stash reflog or a linked worktree's state: count them so the report can say so
    $stash=@(Invoke-Git $r stash list).Count;$worktrees=@(Invoke-Git $r worktree list --porcelain|Where-Object{$_-like'worktree *'}).Count-1
    # Selective package v1: a package refuses state a bundle cannot carry instead of only warning about it.
    if($Package-and($dirty-or$stash-gt1-or$worktrees-gt0)){throw "PACKAGE_MAIN_REPO_STATE_NOT_PRESERVABLE: $name dirty=$dirty stash=$stash worktrees=$worktrees (commit, push or remove it first)"}
    Invoke-Git $r bundle create (Join-Path $out "repos\$name.bundle") --all|Out-Null
    Invoke-Git $r bundle verify (Join-Path $out "repos\$name.bundle")|Out-Null
    $bundledTips[$r]=@(Invoke-Git $r bundle list-heads (Join-Path $out "repos\$name.bundle")|ForEach-Object{($_-split' ')[0]}|Sort-Object -Unique)
    $localConfig=@(Get-SafeConfig $r)
    if($name-like'ORVION-Workbench*'){foreach($line in $localConfig){
        $key,$value=$line-split'=',2
        if(($key-like'remote.origin.*'-and$value-ne'DISABLED'-and$value-notmatch'^https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(?:\.git)?$')-or($key-eq'core.hookspath'-and$value-ne'.githooks')){throw "BACKUP_UNSAFE_CONFIG: $key"}
    }}
    [IO.File]::WriteAllLines((Join-Path $dir 'git-config-local.txt'),[string[]]$localConfig)
    [IO.File]::WriteAllLines((Join-Path $dir 'refs.txt'),[string[]]@(Invoke-Git $r for-each-ref --format='%(objectname) %(refname)'))  # a detached trusted clone may hold no refs
    $receiptPaths=if($name-like'ORVION-Workbench*'){@('.workbench-local-certification.json','.workbench-certifications')}else{@('.orvion-local-certification.json','.orvion-certifications','.claude\settings.json','.claude\settings.local.json')}
    foreach($p in $receiptPaths){
        $toDir=if(Test-Path -LiteralPath (Join-Path $r $p) -PathType Container){Join-Path $dir $p}else{[IO.Path]::Combine($dir,(Split-Path $p -Parent))}
        Copy-Tree (Join-Path $r $p) $toDir
    }
    $plan.repos+=[ordered]@{name=$name;head=$head;branch=$branch;dirty=$dirty;stash=$stash;worktrees=$worktrees;origin=(($localConfig|Where-Object{$_-like'remote.origin.url=*'})-replace'^remote.origin.url=','')
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
if($Package-and@(Get-ChildItem -LiteralPath (Join-Path $ownerTools 'work\sandboxes') -Recurse -File -Force -ErrorAction SilentlyContinue).Count){throw 'PACKAGE_OWNER_SANDBOXES_NOT_PRESERVED: work\sandboxes holds files; capture or remove them first'}
Copy-Tree $ownerTools (Join-Path $out 'owner-tools') {param($rel)$rel-like'work\sandboxes\*'}
Copy-Tree "$env:USERPROFILE\.claude\settings.json" (Join-Path $out 'claude')
Copy-Tree "$env:USERPROFILE\.claude\statusline.ps1" (Join-Path $out 'claude')
# Recovery settings only: retain MCP names/trust, mask URL passwords before the manifest hashes these bytes.
$codexConfig=Join-Path $env:USERPROFILE '.codex\config.toml'
if(Test-Path -LiteralPath $codexConfig -PathType Leaf){
    $codexOut=Join-Path $out 'codex';New-Item -ItemType Directory $codexOut -Force|Out-Null
    $masked=Protect-CodexConfig ([IO.File]::ReadAllText($codexConfig))
    [IO.File]::WriteAllText((Join-Path $codexOut 'config.toml'),$masked,[Text.UTF8Encoding]::new($false))
}
$plan|ConvertTo-Json -Depth 4|Set-Content (Join-Path $out 'backup.json')
$sums=Get-ChildItem $out -Recurse -File|ForEach-Object{"$((Get-FileHash -LiteralPath $_.FullName).Hash)  $($_.FullName.Substring($out.Length+1))"}
[IO.File]::WriteAllLines((Join-Path $out 'SHA256SUMS.txt'),[string[]]$sums)
"BACKUP: $($sums.Count) files, $([math]::Round((Get-ChildItem $out -Recurse -File|Measure-Object Length -Sum).Sum/1MB)) MB -> $out"
$plan.repos|ForEach-Object{"  $($_.name) $($_.branch)@$($_.head.Substring(0,7))$(if($_.dirty){" DIRTY($($_.dirty)): uncommitted work is NOT in the bundle"})$(if($_.stash){"; $($_.stash) stash(es): only the newest survives a bundle"})$(if($_.worktrees-gt0){"; $($_.worktrees) linked worktree(s): their uncommitted state is NOT backed up"})"}
'  not backed up by design: supabase\.temp (recreated by `supabase link`), credentials (re-login: gh auth login, supabase login)'
if($Package){
    New-Item -ItemType Directory $Destination -Force|Out-Null
    $archive=Join-Path $Destination ((Split-Path $out -Leaf)+'.7z');if(Test-Path -LiteralPath $archive){throw "exists: $archive"}
    # A stale success marker must not survive a failed attempt at this archive name.
    if(Test-Path -LiteralPath "$archive.sha256"){Remove-Item -LiteralPath "$archive.sha256"}
    # Selective package v1: identify secrets without exposing them; the JSON report stays in the staging that is deleted below.
    # Report-only: the sidecar always records the outcome; Git history inside the *.bundle files is not scanned.
    $scan="$archive.secret-scan.txt";$scope='files only; Git history inside *.bundle is not scanned'
    if(Get-Command gitleaks -CommandType Application -ErrorAction SilentlyContinue){
        $report=Join-Path $staging 'gitleaks.json'
        & gitleaks dir $out --redact --no-banner --exit-code 0 --report-format json --report-path $report 2>&1|Out-Null
        if($LASTEXITCODE-or!(Test-Path -LiteralPath $report)){$scanLine="SECRET SCAN: FAILED (gitleaks exit $LASTEXITCODE); package made without a scan";[IO.File]::WriteAllLines($scan,[string[]]@($scanLine))}
        else{
            $findings=@(Get-Content -LiteralPath $report -Raw|ConvertFrom-Json)|Where-Object{$_}
            [IO.File]::WriteAllLines($scan,[string[]]@("gitleaks $(& gitleaks version) findings: $($findings.Count) (rule, file:line; values never recorded; $scope)")+@($findings|ForEach-Object{"$($_.RuleID)  $($_.File.Replace('\','/').Replace($out.Replace('\','/')+'/','')):$($_.StartLine)"}|Sort-Object))
            $scanLine="SECRET SCAN: $($findings.Count) finding(s) -> $scan"
        }
    }else{$scanLine='SECRET SCAN: SKIPPED (gitleaks not installed)';[IO.File]::WriteAllLines($scan,[string[]]@($scanLine))}
    $o=& $zip a -t7z -mx7 $archive $out 2>&1;if($LASTEXITCODE){throw "PACKAGE_FAILED ($LASTEXITCODE)`n$o"}
    $o=& $zip t $archive 2>&1;if($LASTEXITCODE){throw "PACKAGE_VERIFY_FAILED ($LASTEXITCODE)"}
    $hash=(Get-FileHash -LiteralPath $archive).Hash
    $packageLine="PACKAGE: $archive $([math]::Round((Get-Item $archive).Length/1MB,1)) MB SHA256 $hash (unencrypted; staging removed)"
}
}finally{if($Package-and$staging-and(Test-Path -LiteralPath $staging)){Get-ChildItem $staging -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($staging,$true)}}
# Printed only after the staging is gone; an interrupted run leaves %TEMP%\orvion-package-* to delete by hand.
if($packageLine){
    # Publish the recovery entry only after verification, hashing AND staging cleanup succeeded.
    try{
        foreach($launcher in 'Restore-ORVION.cmd','Restore-ORVION.ps1'){Copy-Item -LiteralPath (Join-Path $PSScriptRoot $launcher) -Destination (Join-Path $Destination $launcher) -Force}
        [IO.File]::WriteAllText("$archive.sha256",("$hash *"+(Split-Path $archive -Leaf)+[Environment]::NewLine),[Text.Encoding]::ASCII)
    }catch{if(Test-Path -LiteralPath "$archive.sha256"){Remove-Item -LiteralPath "$archive.sha256"};throw}
    $scanLine;$packageLine
}
