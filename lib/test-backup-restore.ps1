# Round trip for Backup-Workspace.ps1 / Restore-Workspace.ps1 on a synthetic workspace (temp GitHub root, bare remote):
# exact HEAD and refs, a DISABLED push URL kept, branch upstream single-valued, an ignored receipt byte-identical, stash
# loss warned, a legacy folder that is itself a repository backed up; a tampered backup and an existing target refused.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-brcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))"
$gh=Join-Path $t 'GitHub';$lib=Join-Path $gh 'ORVION-Owner-Tools\lib';New-Item -ItemType Directory $lib -Force|Out-Null
Copy-Item (Join-Path $PSScriptRoot 'Backup-Workspace.ps1'),(Join-Path $PSScriptRoot 'Restore-Workspace.ps1') $lib
$previousProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
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
    $out=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination (Join-Path $t 'usb') -AllowUnencrypted 2>&1)
    if($LASTEXITCODE-ne0){throw ('BACKUP_FIXTURE_FAILED: '+($out-join' '))}
    Assert-That 'missing optional Claude root is not created' (!(Test-Path (Join-Path $env:USERPROFILE '.claude')))
    Assert-That 'backup warns that older stashes do not survive' (($out-join' ')-match'2 stash\(es\)')
    $bk=@(Get-ChildItem (Join-Path $t 'usb') -Directory)[0].FullName
    Assert-That 'a legacy folder that is itself a repository is backed up without its .git' ((Test-Path "$bk\legacy\ORVION-drafts-backup\draft.md")-and!(Test-Path "$bk\legacy\ORVION-drafts-backup\.git"))
    $res=Join-Path $t 'restored'
    $r=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target $res -ClaudeHome (Join-Path $t 'ch') -LegacyTarget (Join-Path $t 'docs2'))
    if($LASTEXITCODE-ne0){throw ('RESTORE_FIXTURE_FAILED: '+($r-join' '))}
    $rc="$res\CRM"
    Assert-That 'restored at the exact HEAD with identical refs' (($r-join' ')-match'RESTORED CRM main@'-and(& git -C $rc rev-parse HEAD)-eq(& git -C $crm rev-parse HEAD))
    Assert-That 'the DISABLED push URL is kept' ((& git -C $rc config --get remote.origin.pushurl)-eq'DISABLED')
    $up=& git -C $rc config --get-all branch.main.remote
    Assert-That 'the branch upstream is single-valued' (@($up).Count-eq1-and$up-eq'origin')
    Assert-That 'the ignored receipt is byte-identical' ((Get-FileHash "$rc\.orvion-local-certification.json").Hash-eq(Get-FileHash "$crm\.orvion-local-certification.json").Hash)
    Assert-That 'restore warns about the stash' (($r-join' ')-match'WARN CRM: 2 stash')
    $again=try{& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target $res -ClaudeHome (Join-Path $t 'ch') 2>&1|Out-String}catch{"$_"}
    Assert-That 'an existing target is refused' ($again-match'RESTORE_TARGET_EXISTS')
    $projects=Join-Path $env:USERPROFILE '.claude/projects'
    [void][IO.Directory]::CreateDirectory((Join-Path $projects 'Documents-GitHub-empty/memory'))
    [void][IO.Directory]::CreateDirectory((Join-Path $projects 'Documents-GitHub-missing'))
    $memory=Join-Path $projects 'Documents-GitHub-valid/memory';[void][IO.Directory]::CreateDirectory($memory)
    $note=Join-Path $memory 'fixture.md';[IO.File]::WriteAllText($note,'fixture memory bytes')
    $withMemory=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination (Join-Path $t 'usb-memory') -AllowUnencrypted 2>&1)
    Assert-That 'present valid and empty or missing project memory backup succeeds' ($LASTEXITCODE-eq0-and($withMemory-join' ')-match'BACKUP:')
    $memoryBackup=@(Get-ChildItem (Join-Path $t 'usb-memory') -Directory)[0].FullName
    $memoryRestore=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $memoryBackup -Target (Join-Path $t 'restored-memory') -ClaudeHome (Join-Path $t 'ch-memory') -LegacyTarget (Join-Path $t 'docs-memory') 2>&1)
    Assert-That 'valid fixture restore preserves optional memory bytes' ($LASTEXITCODE-eq0-and[IO.File]::ReadAllText((Join-Path $t 'ch-memory/projects/Documents-GitHub-valid/memory/fixture.md'))-ceq'fixture memory bytes')
    foreach($case in @(@('required-receipt',"$crm\.orvion-local-certification.json"),@('present-memory',$note))){
        $handle=[IO.File]::Open($case[1],'Open','ReadWrite','None');$destination=Join-Path $t ('usb-locked-'+$case[0])
        try{$locked=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination $destination -AllowUnencrypted 2>&1);$code=$LASTEXITCODE}finally{$handle.Dispose()}
        Assert-That ($case[0]+' unreadable is fatal without a success manifest') ($code-ne0-and($locked-join' ')-notmatch'BACKUP:'-and@(Get-ChildItem $destination -Recurse -Filter SHA256SUMS.txt).Count-eq0)
    }
    $saved=[IO.File]::ReadAllBytes("$bk\repos\CRM\refs.txt");[IO.File]::Delete("$bk\repos\CRM\refs.txt")
    $incomplete=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target (Join-Path $t 'restored-incomplete') -ClaudeHome (Join-Path $t 'ch-incomplete') 2>&1)
    Assert-That 'incomplete artifact is fatal before creating a restore target' ($LASTEXITCODE-ne0-and($incomplete-join' ')-match'BACKUP_CORRUPT'-and!(Test-Path (Join-Path $t 'restored-incomplete')))
    [IO.File]::WriteAllBytes("$bk\repos\CRM\refs.txt",$saved)
    Add-Content "$bk\repos\CRM\refs.txt" 'tampered'
    $bad=try{& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target (Join-Path $t 'restored2') -ClaudeHome (Join-Path $t 'ch2') 2>&1|Out-String}catch{"$_"}
    Assert-That 'a tampered backup is refused' ($bad-match'BACKUP_CORRUPT')
    [IO.File]::Delete("$bk\SHA256SUMS.txt")
    $missingManifest=@(& pwsh -NoProfile -File "$lib\Restore-Workspace.ps1" -From $bk -Target (Join-Path $t 'restored-no-manifest') -ClaudeHome (Join-Path $t 'ch-no-manifest') 2>&1)
    Assert-That 'missing manifest is fatal before creating a restore target' ($LASTEXITCODE-ne0-and!(Test-Path (Join-Path $t 'restored-no-manifest')))
    $env:USERPROFILE=Join-Path $t 'malformed-profile';[void][IO.Directory]::CreateDirectory((Join-Path $env:USERPROFILE '.claude'))
    [IO.File]::WriteAllText((Join-Path $env:USERPROFILE '.claude/projects'),'not a directory')
    $malformed=@(& pwsh -NoProfile -File "$lib\Backup-Workspace.ps1" -Destination (Join-Path $t 'usb-malformed') -AllowUnencrypted 2>&1)
    Assert-That 'malformed present projects root is fatal without success' ($LASTEXITCODE-ne0-and($malformed-join' ')-match'BACKUP_CLAUDE_PROJECTS_NOT_DIRECTORY'-and($malformed-join' ')-notmatch'BACKUP:')
    $env:USERPROFILE=Join-Path $t 'profile'
    # Workbench recovery coverage v1: independent source/trusted, exact historical receipts and declared proof bytes.
    $wb=Join-Path $gh 'ORVION-Workbench';$trusted=Join-Path $gh 'ORVION-Workbench-trusted-main'
    foreach($repo in $wb,$trusted){
        & git clone -q $remote $repo 2>&1|Out-Null;if($LASTEXITCODE){throw 'WB_FIXTURE_CLONE_FAILED'}
        Invoke-Quiet $repo remote set-url origin https://github.com/fixture/workbench.git|Out-Null
        Invoke-Quiet $repo remote set-url --push origin DISABLED|Out-Null
        Invoke-Quiet $repo config core.hooksPath .githooks|Out-Null
        Invoke-Quiet $repo config push.default nothing|Out-Null
        Invoke-Quiet $repo config protocol.allow never|Out-Null
    }
    Invoke-Quiet $trusted checkout -q --detach HEAD|Out-Null
    $wbIgnore=Join-Path $wb '.gitignore';Add-Content $wbIgnore ".workbench-local-certification.json`n.workbench-certifications/"
    Invoke-Quiet $wb add .gitignore|Out-Null;Invoke-Quiet $wb commit -q -m 'fixture ignored receipts'|Out-Null
    $digest='A'*64;$receipt=Join-Path $wb '.workbench-local-certification.json'
    [void][IO.Directory]::CreateDirectory((Join-Path $wb '.workbench-certifications'))
    @{schema=2;root=$wb;result='READY';digest=$digest}|ConvertTo-Json|Set-Content $receipt
    $archive=Join-Path $wb ".workbench-certifications/$digest.json";Copy-Item $receipt $archive
    $proof=Join-Path $t 'external-proof.json';[IO.File]::WriteAllText($proof,'{"fixture":"required private proof reference"}')
    $inputs=Join-Path $t 'recovery-inputs.json'
    @{schema=1;inputs=@(@{name='required-proof';path=$proof;sha256=(Get-FileHash $proof).Hash})}|ConvertTo-Json -Depth 4|Set-Content $inputs
    # Permanent structural regressions: every malformed shape must fail before a success manifest.
    $validInputs=[IO.File]::ReadAllText($inputs)
    $shapes=[ordered]@{absent='{"schema":1}';null='{"schema":1,"inputs":null}';empty='{"schema":1,"inputs":[]}';scalar='{"schema":1,"inputs":"proof"}';object='{"schema":1,"inputs":{}}';nullEntry='{"schema":1,"inputs":[null]}';scalarEntry='{"schema":1,"inputs":["proof"]}';objectEntry='{"schema":1,"inputs":[{}]}';schemaString='{"schema":"1","inputs":[{}]}'}
    foreach($case in $shapes.GetEnumerator()){
        [IO.File]::WriteAllText($inputs,$case.Value)
        $destination=Join-Path $t ('wb-map-'+$case.Key)
        $badMap=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination $destination -RecoveryInputs $inputs -AllowUnencrypted 2>&1);$exitCode=$LASTEXITCODE
        Assert-That ('malformed backup proof map '+$case.Key+' fails closed') ($exitCode-ne0-and($badMap-join' ')-match'BACKUP_RECOVERY_INPUTS_INVALID'-and($badMap-join' ')-notmatch'BACKUP:'-and@(Get-ChildItem $destination -Recurse -Filter SHA256SUMS.txt).Count-eq0)
    }
    [IO.File]::WriteAllText($inputs,$validInputs)
    $missing=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t 'wb-no-inputs') -AllowUnencrypted 2>&1)
    Assert-That 'Workbench present requires explicit approved recovery input map' ($LASTEXITCODE-ne0-and($missing-join' ')-match'BACKUP_RECOVERY_INPUTS_REQUIRED')
    $receiptBytes=[IO.File]::ReadAllBytes($receipt);[IO.File]::Delete($receipt)
    $missingReceipt=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t 'wb-no-receipt') -RecoveryInputs $inputs -AllowUnencrypted 2>&1)
    Assert-That 'required missing Workbench receipt blocks backup manifest' ($LASTEXITCODE-ne0-and($missingReceipt-join' ')-match'BACKUP_WORKBENCH_RECEIPTS_REQUIRED'-and@(Get-ChildItem (Join-Path $t 'wb-no-receipt') -Recurse -Filter SHA256SUMS.txt).Count-eq0)
    [IO.File]::WriteAllBytes($receipt,$receiptBytes)
    [IO.File]::WriteAllText($receipt,'not valid json')
    $invalidReceipt=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t 'wb-invalid-receipt') -RecoveryInputs $inputs -AllowUnencrypted 2>&1)
    Assert-That 'corrupt required receipt is fatal without success manifest' ($LASTEXITCODE-ne0-and($invalidReceipt-join' ')-notmatch'BACKUP:'-and@(Get-ChildItem (Join-Path $t 'wb-invalid-receipt') -Recurse -Filter SHA256SUMS.txt).Count-eq0)
    [IO.File]::WriteAllBytes($receipt,$receiptBytes)
    foreach($file in $receipt,$proof){
        $lock=[IO.File]::Open($file,'Open','ReadWrite','None')
        try{$locked=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t ('wb-lock-'+[IO.Path]::GetFileName($file))) -RecoveryInputs $inputs -AllowUnencrypted 2>&1);$code=$LASTEXITCODE}finally{$lock.Dispose()}
        Assert-That ('required unreadable Workbench input refuses '+[IO.Path]::GetFileName($file)) ($code-ne0-and($locked-join' ')-notmatch'BACKUP:')
    }
    $originalProof=[IO.File]::ReadAllBytes($proof);[IO.File]::WriteAllText($proof,'changed')
    $changed=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t 'wb-changed') -RecoveryInputs $inputs -AllowUnencrypted 2>&1)
    Assert-That 'changed required proof hash refuses before manifest' ($LASTEXITCODE-ne0-and($changed-join' ')-match'BACKUP_RECOVERY_INPUT_REQUIRED_OR_CHANGED')
    [IO.File]::WriteAllBytes($proof,$originalProof)
    Invoke-Quiet $wb config http.https://github.com/.extraheader 'fixture-redacted-header'|Out-Null
    $unsafe=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t 'wb-unsafe') -RecoveryInputs $inputs -AllowUnencrypted 2>&1)
    Assert-That 'auth-header config is refused without success' ($LASTEXITCODE-ne0-and($unsafe-join' ')-match'BACKUP_WORKBENCH_UNSAFE_CONFIG'-and($unsafe-join' ')-notmatch'BACKUP:')
    Invoke-Quiet $wb config --unset-all http.https://github.com/.extraheader|Out-Null
    $back=@(& pwsh -NoProfile -File "$lib/Backup-Workspace.ps1" -Destination (Join-Path $t 'wb-usb') -RecoveryInputs $inputs -AllowUnencrypted 2>&1)
    if($LASTEXITCODE){throw ('WB_BACKUP_FIXTURE_FAILED: '+($back-join' '))}
    $wbb=@(Get-ChildItem (Join-Path $t 'wb-usb') -Directory)[0].FullName
    # Restore negatives use internally consistent checksum manifests, isolating semantic validation.
    $planFile=Join-Path $wbb 'backup.json';$manifestFile=Join-Path $wbb 'SHA256SUMS.txt'
    $validPlan=[IO.File]::ReadAllText($planFile);$validManifest=[IO.File]::ReadAllText($manifestFile)
    foreach($field in 'inputs','receiptFiles'){
        foreach($shape in 'absent','null','empty','scalar','object','nullEntry','scalarEntry','objectEntry'){
            $planFixture=$validPlan|ConvertFrom-Json
            switch($shape){
                absent {$planFixture.workbenchRecovery.psobject.Properties.Remove($field)}
                null {$planFixture.workbenchRecovery.$field=$null}
                empty {$planFixture.workbenchRecovery.$field=@()}
                scalar {$planFixture.workbenchRecovery.$field='fixture'}
                object {$planFixture.workbenchRecovery.$field=[pscustomobject]@{}}
                nullEntry {$planFixture.workbenchRecovery.$field=@($null)}
                scalarEntry {$planFixture.workbenchRecovery.$field=@(17)}
                objectEntry {$planFixture.workbenchRecovery.$field=@([pscustomobject]@{})}
            }
            $planFixture|ConvertTo-Json -Depth 8|Set-Content $planFile
            $newHash=(Get-FileHash $planFile).Hash
            [IO.File]::WriteAllText($manifestFile,([regex]::Replace($validManifest,'(?m)^[A-F0-9]{64}(  backup\.json\r?$)',{param($m)$newHash+$m.Groups[1].Value})))
            $destination=Join-Path $t ('wb-restore-map-'+$field+'-'+$shape)
            $badMap=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target $destination -ClaudeHome ($destination+'-claude') -LegacyTarget ($destination+'-legacy') 2>&1);$exitCode=$LASTEXITCODE
            $cause=if($shape-in'absent','null','empty','scalar','object'){'RESTORE_WORKBENCH_COVERAGE_REQUIRED'}else{'RESTORE_WORKBENCH_INPUT_INVALID'}
            Assert-That ('malformed restore '+$field+' '+$shape+' refuses before writes') ($exitCode-ne0-and($badMap-join' ')-match$cause-and($badMap-join' ')-notmatch'BACKUP_CORRUPT|RESTORED '-and!(Test-Path $destination)-and!(Test-Path ($destination+'-claude'))-and!(Test-Path ($destination+'-legacy')))
        }
    }
    [IO.File]::WriteAllText($planFile,$validPlan);[IO.File]::WriteAllText($manifestFile,$validManifest)
    $wbTarget=Join-Path $t 'wb-restored'
    $restored=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target $wbTarget -ClaudeHome (Join-Path $t 'wb-ch') -LegacyTarget (Join-Path $t 'wb-docs') 2>&1)
    if($LASTEXITCODE){throw ('WB_RESTORE_FIXTURE_FAILED: '+($restored-join' '))}
    Assert-That 'source and independent detached trusted HEAD round trip exactly' ((& git -C "$wbTarget/ORVION-Workbench" rev-parse HEAD)-ceq(& git -C $wb rev-parse HEAD)-and(& git -C "$wbTarget/ORVION-Workbench-trusted-main" rev-parse HEAD)-ceq(& git -C $trusted rev-parse HEAD)-and(& git -C "$wbTarget/ORVION-Workbench-trusted-main" rev-parse --abbrev-ref HEAD)-ceq'HEAD')
    Assert-That 'Workbench certification bytes retained without rewriting physical root' ((Get-FileHash "$wbTarget/ORVION-Workbench/.workbench-local-certification.json").Hash-ceq(Get-FileHash $receipt).Hash-and(Get-FileHash "$wbTarget/ORVION-Workbench/.workbench-certifications/$digest.json").Hash-ceq(Get-FileHash $archive).Hash)
    Assert-That 'trusted recovery remains push disabled and protocol denied' ((& git -C "$wbTarget/ORVION-Workbench-trusted-main" config --get remote.origin.pushurl)-ceq'DISABLED'-and(& git -C "$wbTarget/ORVION-Workbench-trusted-main" config --get protocol.allow)-ceq'never'-and(& git -C "$wbTarget/ORVION-Workbench-trusted-main" config --get push.default)-ceq'nothing')
    Assert-That 'declared external proof bytes and original reference map retained' ((Get-FileHash "$wbTarget/ORVION-Recovery-Inputs/required-proof").Hash-ceq(Get-FileHash $proof).Hash-and(Test-Path "$wbTarget/ORVION-Recovery-Inputs/source-map.json"))
    $again=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target $wbTarget -ClaudeHome (Join-Path $t 'wb-ch') 2>&1)
    Assert-That 'existing recovery evidence destination refuses overwrite' ($LASTEXITCODE-ne0-and($again-join' ')-match'RESTORE_TARGET_EXISTS')
    $rp=Join-Path $wbb 'recovery-inputs/required-proof';[IO.File]::AppendAllText($rp,'corrupt')
    $badProof=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target (Join-Path $t 'wb-corrupt') -ClaudeHome (Join-Path $t 'wb-corrupt-ch') 2>&1)
    Assert-That 'corrupt proof blocks before any restore target writes' ($LASTEXITCODE-ne0-and($badProof-join' ')-match'BACKUP_CORRUPT'-and!(Test-Path (Join-Path $t 'wb-corrupt')))
    [IO.File]::WriteAllBytes($rp,$originalProof)
    $savedManifest=[IO.File]::ReadAllText((Join-Path $wbb 'SHA256SUMS.txt'))
    $withoutProof=(@($savedManifest-split'\r?\n'|Where-Object{$_-and$_-notmatch'recovery-inputs[\\/]required-proof$'})-join[char]10)+[char]10
    [IO.File]::WriteAllText((Join-Path $wbb 'SHA256SUMS.txt'),$withoutProof);[IO.File]::Delete($rp)
    $omitted=@(& pwsh -NoProfile -File "$lib/Restore-Workspace.ps1" -From $wbb -Target (Join-Path $t 'wb-omitted') -ClaudeHome (Join-Path $t 'wb-omitted-ch') 2>&1)
    Assert-That 'required input omitted together with manifest entry still refuses before writes' ($LASTEXITCODE-ne0-and($omitted-join' ')-match'RESTORE_WORKBENCH_INPUT_REQUIRED'-and!(Test-Path (Join-Path $t 'wb-omitted')))
}finally{$env:USERPROFILE=$previousProfile;Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
if($fail){throw "BACKUP_RESTORE_SELFCHECK_FAILED $fail"};'BACKUP_RESTORE_SELFCHECK PASS'
