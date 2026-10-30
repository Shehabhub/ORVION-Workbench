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
param([Parameter(Mandatory)][string]$Destination,[switch]$AllowUnencrypted,[switch]$SkipLegacy,[string]$RecoveryInputs,[switch]$Package,
      [switch]$Install,[switch]$Status,[string]$RuntimePath,[string]$DataRoot,[string]$TemporaryRoot,
      [ValidateRange(1,1440)][int]$ExecutionLimitMinutes,[ValidatePattern('^(?:[01][0-9]|2[0-3]):[0-5][0-9]$')][string]$DailyAt='02:00')
$ErrorActionPreference='Stop'
# Daily backup v1: status lives beside the destination, outside the existing package contents.
# One OS file handle covers manual and scheduled publication. An abandoned file is not a lease.
function ConvertTo-BackupDestination([string]$Path){
    # Pure normalization: a volume/share root has no safe sibling status directory.
    # Refuse before filesystem access instead of turning C:\ into drive-relative C:.
    if(![IO.Path]::IsPathFullyQualified($Path)){throw 'BACKUP_DESTINATION_ABSOLUTE_REQUIRED'}
    $full=[IO.Path]::GetFullPath($Path)
    $trimmed=$full.TrimEnd('\','/')
    if($trimmed-ieq[IO.Path]::GetPathRoot($full).TrimEnd('\','/')){throw 'BACKUP_DESTINATION_ROOT_REFUSED'}
    $trimmed
}
$Destination=ConvertTo-BackupDestination $Destination
$statusRoot=$Destination+'.status';$statusFile=Join-Path $statusRoot 'latest.json'
function Assert-BackupPath([string]$Path){
    $node=[IO.Path]::GetFullPath($Path)
    while($node){
        $item=Get-Item -LiteralPath $node -Force -ErrorAction SilentlyContinue
        # PowerShell identifies standard namespace redirects by LinkType. Cloud placeholders
        # can have ReparsePoint with no LinkType; that flag alone is not a redirect.
        # This metadata walk is not atomic alias/confinement or cloud-availability proof.
        if($item-and$item.LinkType-in'Junction','SymbolicLink'){throw 'BACKUP_REPARSE_REFUSED'}
        $parent=Split-Path $node -Parent;if($parent-eq$node){break};$node=$parent
    }
}
function Test-BackupWithin([string]$Path,[string]$Root){
    $p=[IO.Path]::GetFullPath($Path).TrimEnd('\','/');$r=[IO.Path]::GetFullPath($Root).TrimEnd('\','/')
    $p-ieq$r-or$p.StartsWith($r+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)
}
function Write-BackupStatus($Value){
    $pending=Join-Path $statusRoot ('pending-'+[guid]::NewGuid().ToString('N')+'.json')
    # Same-directory replacement; the pending write does not truncate the previous record.
    # Local failure preservation is tested; cloud/remote atomicity and durability are unproven.
    [IO.File]::WriteAllText($pending,($Value|ConvertTo-Json -Depth 8),[Text.UTF8Encoding]::new($false))
    [IO.File]::Move($pending,$statusFile,$true)
}
function Get-BackupTaskIdentity {
    $identity=[Security.Principal.WindowsIdentity]::GetCurrent().Name
    $key=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($Destination.ToUpperInvariant()))).Substring(0,16)
    [pscustomobject]@{User=$identity;Name=('ORVION Workspace Backup '+$key);Description=('ORVION Backup v1 | '+$identity+' | '+$PSCommandPath+' | '+$Destination)}
}
function Test-BackupTaskUser([string]$UserId){
    # Scheduler may report a short account, qualified account or SID for the same user.
    # Resolve through Windows; an unreadable/unresolvable identity never grants ownership.
    try{
        if([string]::IsNullOrWhiteSpace($UserId)){return $false}
        $sid=if($UserId-match'^S-1-'){[Security.Principal.SecurityIdentifier]::new($UserId)}
             else{[Security.Principal.NTAccount]::new($UserId).Translate([Security.Principal.SecurityIdentifier])}
        $sid.Equals([Security.Principal.WindowsIdentity]::GetCurrent().User)
    }catch{return $false}
}
if($Status){
    # Application records miss binding/preflight/launch failures and may remain RUNNING.
    # Scheduler readback is separate evidence, never an inferred package verification.
    $application=$null;$applicationState='NEVER_RECORDED'
    try{if(Test-Path -LiteralPath $statusFile){$application=Get-Content -LiteralPath $statusFile -Raw|ConvertFrom-Json;$applicationState='RECORDED'}}catch{$applicationState='UNREADABLE'}
    $scheduler=[ordered]@{state='UNAVAILABLE';taskName=$null;lastRunUtc=$null;lastTaskResult=$null;nextRunUtc=$null;configurationVerified=$false}
    try{
        $taskIdentity=Get-BackupTaskIdentity;$scheduler.taskName=$taskIdentity.Name
        $task=Get-ScheduledTask -TaskName $taskIdentity.Name -TaskPath '\' -ErrorAction Stop
        if($task.Description-cne$taskIdentity.Description-or!(Test-BackupTaskUser $task.Principal.UserId)-or
           $task.Principal.LogonType-ne'Interactive'-or$task.Principal.RunLevel-ne'Limited'-or@($task.Actions).Count-ne1){$scheduler.state='OWNERSHIP_COLLISION'}
        else{
            $info=Get-ScheduledTaskInfo -TaskName $taskIdentity.Name -TaskPath '\' -ErrorAction Stop
            $scheduler.state='READBACK_ONLY';$scheduler.lastRunUtc=$info.LastRunTime.ToUniversalTime().ToString('o')
            $scheduler.lastTaskResult=$info.LastTaskResult;$scheduler.nextRunUtc=$info.NextRunTime.ToUniversalTime().ToString('o')
        }
    }catch{$scheduler.state='UNAVAILABLE'}
    [ordered]@{schema=1;observedUtc=[DateTime]::UtcNow.ToString('o');applicationState=$applicationState;application=$application;scheduler=$scheduler;
        interpretation='Application is the last persisted attempt only. Scheduler readback may describe a newer launch/preflight failure; correlate times and runId. Neither result alone verifies a package.'}|ConvertTo-Json -Depth 10
    return
}
if($Install){
    # No discovery of private roots or disposable runtime fallback during installation.
    if(!$Package-or!$RecoveryInputs-or!$DataRoot-or!$TemporaryRoot-or!$RuntimePath-or!$ExecutionLimitMinutes){throw 'BACKUP_INSTALL_EXPLICIT_ARGUMENTS_REQUIRED'}
    foreach($p in $Destination,$RecoveryInputs,$DataRoot,$TemporaryRoot,$RuntimePath){
        if(![IO.Path]::IsPathFullyQualified($p)){throw 'BACKUP_INSTALL_ABSOLUTE_PATH_REQUIRED'};Assert-BackupPath $p
    }
    if(!(Test-Path -LiteralPath $RuntimePath -PathType Leaf)-or[IO.Path]::GetFileName($RuntimePath)-ine'pwsh.exe'-or
       $RuntimePath-match'(?i)[\\/]ORVION-Workbench-temporary[\\/]'-or(Test-BackupWithin $RuntimePath $TemporaryRoot)){throw 'BACKUP_INSTALL_DURABLE_RUNTIME_REQUIRED'}
    if(!(Test-Path -LiteralPath $RecoveryInputs -PathType Leaf)-or!(Test-Path -LiteralPath $DataRoot -PathType Container)){throw 'BACKUP_INSTALL_INPUT_UNAVAILABLE'}
    foreach($durable in $PSCommandPath,$RecoveryInputs,$DataRoot){
        if($durable-match'(?i)[\\/]ORVION-Workbench-temporary[\\/]'-or(Test-BackupWithin $durable $TemporaryRoot)){throw 'BACKUP_INSTALL_DURABLE_INPUT_REQUIRED'}
    }
    if((Test-BackupWithin $statusRoot $Destination)-or(Test-BackupWithin $Destination $statusRoot)){throw 'BACKUP_OUTPUT_STATUS_OVERLAP'}
    foreach($inputPath in $PSCommandPath,$RecoveryInputs,$DataRoot,$RuntimePath){
        foreach($outputPath in $Destination,$statusRoot){
            if((Test-BackupWithin $inputPath $outputPath)-or(Test-BackupWithin $outputPath $inputPath)){throw 'BACKUP_INSTALL_OUTPUT_INPUT_OVERLAP'}
        }
    }
    # Encode literal PowerShell strings, then the entire UTF-16 command. No shell interpolation of paths.
    function Quote-BackupLiteral([string]$Value){"'"+$Value.Replace("'","''")+"'"}
    $command='$env:ORVION_DATA_ROOT='+(Quote-BackupLiteral $DataRoot)+'; $env:WORKBENCH_TEMP_ROOT='+(Quote-BackupLiteral $TemporaryRoot)+
        '; & '+(Quote-BackupLiteral $PSCommandPath)+' -Destination '+(Quote-BackupLiteral $Destination)+' -RecoveryInputs '+(Quote-BackupLiteral $RecoveryInputs)+' -Package'
    $arguments='-NoProfile -NonInteractive -WindowStyle Hidden -EncodedCommand '+[Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($command))
    $taskIdentity=Get-BackupTaskIdentity;$identity=$taskIdentity.User;$taskName=$taskIdentity.Name;$description=$taskIdentity.Description
    $existing=Get-ScheduledTask -TaskName $taskName -TaskPath '\' -ErrorAction SilentlyContinue
    if($existing-and($existing.Description-cne$description-or!(Test-BackupTaskUser $existing.Principal.UserId)-or
       $existing.Principal.LogonType-ne'Interactive'-or$existing.Principal.RunLevel-ne'Limited'-or
       @($existing.Actions).Count-ne1-or$existing.Actions[0].Execute-ine$RuntimePath-or$existing.Actions[0].Arguments-cne$arguments)){throw 'BACKUP_TASK_OWNERSHIP_COLLISION'}
    $action=New-ScheduledTaskAction -Execute $RuntimePath -Argument $arguments
    $trigger=New-ScheduledTaskTrigger -Daily -At ([datetime]::Today.Add([timespan]::ParseExact($DailyAt,'hh\:mm',$null)))
    $settings=New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes $ExecutionLimitMinutes)
    $principal=New-ScheduledTaskPrincipal -UserId $identity -LogonType Interactive -RunLevel Limited
    $registration=@{TaskName=$taskName;TaskPath='\';Description=$description;Action=$action;Trigger=$trigger;Settings=$settings;Principal=$principal}
    if($existing){$registration.Force=$true}
    Register-ScheduledTask @registration|Out-Null
    "BACKUP TASK: '$taskName' daily $DailyAt; interactive user $identity; limit $ExecutionLimitMinutes minutes; status $statusFile";return
}
$lease=$null;$record=$null;$previous=$null;$clock=[Diagnostics.Stopwatch]::StartNew()
try{
Assert-BackupPath $Destination;Assert-BackupPath $statusRoot
# Refuse output feeding the copied inputs. No source/archiving redesign or automatic pruning.
$checkout=Split-Path $PSScriptRoot -Parent;$siblings=Split-Path $checkout -Parent
$dataCandidate=if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{Join-Path $siblings 'ORVION-Owner-Tools'}
$sources=@($dataCandidate,(Join-Path $env:USERPROFILE '.claude'),(Join-Path $env:USERPROFILE '.codex'))
if($RecoveryInputs){$sources+=$RecoveryInputs}
foreach($n in 'CRM','ORVION','CRM-trusted-main','ORVION-trusted-main','ORVION-Workbench','ORVION-Workbench-trusted-main'){$sources+=Join-Path $siblings $n}
foreach($source in $sources){
    if(![IO.Path]::IsPathFullyQualified($source)){continue}
    Assert-BackupPath $source
    foreach($output in $Destination,$statusRoot){if((Test-BackupWithin $output $source)-or(Test-BackupWithin $source $output)){throw 'BACKUP_OUTPUT_SOURCE_OVERLAP'}}
}
[void][IO.Directory]::CreateDirectory($statusRoot)
try{$lease=[IO.File]::Open((Join-Path $statusRoot 'operation.lock'),'OpenOrCreate','ReadWrite','None')}catch{throw 'BACKUP_BUSY'}
if(Test-Path -LiteralPath $statusFile){$previous=Get-Content -LiteralPath $statusFile -Raw|ConvertFrom-Json}
$record=[ordered]@{schema=1;runId=[guid]::NewGuid().ToString('N');startedUtc=[DateTime]::UtcNow.ToString('o');endedUtc=$null;elapsedSeconds=$null;result='RUNNING';errorCode=$null;lastVerified=$previous.lastVerified}
Write-BackupStatus $record
$tools=Split-Path $PSScriptRoot -Parent;$gh=Split-Path $tools -Parent;$docs=Split-Path $gh -Parent
# Same data-root default as the readers; the script's checkout is already a repository bundle.
$ownerTools=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'})
if(!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $ownerTools 'events') -PathType Container)){throw 'ORVION_DATA_ROOT_UNAVAILABLE'}
# Selective package v1: on success only stdout is returned; stderr warnings (CRLF) must never count as entries.
# A failure names the subcommand and masks URL credentials: arguments and output may carry config values.
$ownerTools=[IO.Path]::GetFullPath($ownerTools).TrimEnd('\')
if(Get-Item -LiteralPath (Join-Path $ownerTools '.git') -Force -ErrorAction SilentlyContinue){throw 'BACKUP_DATA_ROOT_GIT_REFUSED'}
. (Join-Path $PSScriptRoot 'workspace-layout.ps1')
$TemporaryRoot=Initialize-OrvionTemporaryRoot -Checkout $tools
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
$record.result='SUCCESS';$record.endedUtc=[DateTime]::UtcNow.ToString('o');$record.elapsedSeconds=$clock.Elapsed.TotalSeconds
if($packageLine){$record.lastVerified=[ordered]@{archive=$archive;sha256=$hash;verifiedUtc=$record.endedUtc;runId=$record.runId;recoveryInputs=$RecoveryInputs}}
Write-BackupStatus $record
}catch{
    # Busy contenders and failed preflight cannot overwrite the active publisher's record.
    if($lease-and$record){
        $record.result='FAILURE';$record.endedUtc=[DateTime]::UtcNow.ToString('o');$record.elapsedSeconds=$clock.Elapsed.TotalSeconds
        $record.lastVerified=$previous.lastVerified
        $record.errorCode=if($_.Exception.Message-match'^(BACKUP_[A-Z_]+|PACKAGE_[A-Z_]+|ORVION_DATA_ROOT_[A-Z_]+|WB_TEMP_[A-Z_]+)'){$Matches[1]}else{'BACKUP_FAILED'}
        try{Write-BackupStatus $record}catch{Write-Warning 'BACKUP_STATUS_WRITE_FAILED: prior status may remain RUNNING; inspect artifacts before retry'}
    }
    throw
}finally{if($lease){$lease.Dispose()};$clock.Stop()}
