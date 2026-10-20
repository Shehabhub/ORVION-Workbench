# Round trip for Backup-Workspace.ps1 / Restore-Workspace.ps1 on a synthetic workspace (temp GitHub root, bare remote):
# exact HEAD and refs, a DISABLED push URL kept, branch upstream single-valued, an ignored receipt byte-identical, stash
# loss warned, a legacy folder that is itself a repository backed up; a tampered backup and an existing target refused.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-brcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))"
$gh=Join-Path $t 'GitHub';$lib=Join-Path $gh 'ORVION-Owner-Tools\lib';New-Item -ItemType Directory $lib -Force|Out-Null
Copy-Item (Join-Path $PSScriptRoot 'Backup-Workspace.ps1'),(Join-Path $PSScriptRoot 'Restore-Workspace.ps1') $lib
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
function Invoke-Quiet{param([string]$Dir)$o=& git -C $Dir -c user.name=t -c user.email=t@t @args 2>&1;if($LASTEXITCODE){throw "git $args : $o"};$o}
try{
    $remote=Join-Path $t 'remote.git';& git init -q --bare -b main $remote
    $crm=Join-Path $gh 'CRM';& git clone -q $remote $crm 2>&1|Out-Null
    Set-Content "$crm\.gitignore" '.orvion-local-certification.json';Set-Content "$crm\a.txt" 'one';Invoke-Quiet $crm add -A|Out-Null;Invoke-Quiet $crm commit -q -m one|Out-Null
    Invoke-Quiet $crm push -q -u origin main|Out-Null;Invoke-Quiet $crm remote set-url --push origin DISABLED|Out-Null
    Invoke-Quiet $crm branch orvion/x-pending|Out-Null
    Set-Content "$crm\.orvion-local-certification.json" '{"receipt":"exact"}'
    foreach($i in 1,2){Set-Content "$crm\a.txt" "stash $i";Invoke-Quiet $crm stash -q|Out-Null}
    $legacy=Join-Path $t 'ORVION-drafts-backup';New-Item -ItemType Directory $legacy|Out-Null;& git init -q $legacy;Set-Content "$legacy\draft.md" 'kept'
    $out=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination (Join-Path $t 'usb') -AllowUnencrypted)
    Assert-That 'backup warns that older stashes do not survive' (($out-join' ')-match'2 stash\(es\)')
    $bk=@(Get-ChildItem (Join-Path $t 'usb') -Directory)[0].FullName
    Assert-That 'a legacy folder that is itself a repository is backed up without its .git' ((Test-Path "$bk\legacy\ORVION-drafts-backup\draft.md")-and!(Test-Path "$bk\legacy\ORVION-drafts-backup\.git"))
    $res=Join-Path $t 'restored'
    $r=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target $res -ClaudeHome (Join-Path $t 'ch') -LegacyTarget (Join-Path $t 'docs2'))
    $rc="$res\CRM"
    Assert-That 'restored at the exact HEAD with identical refs' (($r-join' ')-match'RESTORED CRM main@'-and(& git -C $rc rev-parse HEAD)-eq(& git -C $crm rev-parse HEAD))
    Assert-That 'the DISABLED push URL is kept' ((& git -C $rc config --get remote.origin.pushurl)-eq'DISABLED')
    $up=& git -C $rc config --get-all branch.main.remote
    Assert-That 'the branch upstream is single-valued' (@($up).Count-eq1-and$up-eq'origin')
    Assert-That 'the ignored receipt is byte-identical' ((Get-FileHash "$rc\.orvion-local-certification.json").Hash-eq(Get-FileHash "$crm\.orvion-local-certification.json").Hash)
    Assert-That 'restore warns about the stash' (($r-join' ')-match'WARN CRM: 2 stash')
    $again=try{& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target $res -ClaudeHome (Join-Path $t 'ch') 2>&1|Out-String}catch{"$_"}
    Assert-That 'an existing target is refused' ($again-match'RESTORE_TARGET_EXISTS')
    Add-Content "$bk\repos\CRM\refs.txt" 'tampered'
    $bad=try{& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target (Join-Path $t 'restored2') -ClaudeHome (Join-Path $t 'ch2') 2>&1|Out-String}catch{"$_"}
    Assert-That 'a tampered backup is refused' ($bad-match'BACKUP_CORRUPT')
}finally{Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
if($fail){throw "BACKUP_RESTORE_SELFCHECK_FAILED $fail"};'BACKUP_RESTORE_SELFCHECK PASS'
