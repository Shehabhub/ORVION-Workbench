# Workbench Change Request - WS-013

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Close the measured Workbench source/trusted/config/receipt and explicitly declared external proof-file backup/restore coverage gaps using the existing tools. Preserve required-input failure propagation, historical authority and product independence. This is private recovery preparation, not offsite completion.

## Baseline

d4d0ece52ad23af8cf98a3e1c52eaa98464d8017

## Write Scope

- RESUME.md
- lib/Backup-Workspace.ps1
- lib/Restore-Workspace.ps1
- lib/test-backup-restore.ps1

## Out of Scope

All other engineering paths except native allocation/status/pointer bookkeeping. No original write before exact Gate1; no original WS012 execution/rebuild or changes to its frozen evidence. No programme-plan, architecture, checker, recipe driver, workflow or product change; no full42 replay, original Finish replay, source publication, main promotion, trust advancement, visibility/settings/subscription change, upload, real keys, destination commitment, archive migration, new engine/collector/service or encryption bypass. Existing AllowUnencrypted is used only on synthetic owning fixtures, never real archive operations. CTRL19OPEN, Batch6/Phase8HOLD and all stages remain.

## Draft Assurance

V1: WS013R2-RECOVERY-DESIGN | 2026-10-25 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\recovery-r2\assurance\V1\DRAFT.md | 46D3E90EDAFF4335E008DBB048E8B9905CC28A92A691226238834C0006E50AE2
V2: WS013R2-RECOVERY-ADVERSARIAL | 2026-10-25 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\recovery-r2\assurance\V2\DRAFT.md | 332CD68694EFFA9DB7A60224319D546CDDB5F2CCEC36E028AE5F521007F65F59
V3: WS013R2-RECOVERY-REFRESH | 2026-10-25 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\recovery-r2\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSrec13r2
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSrec13r2\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSrec13r2\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\recovery-r2\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/Backup-Workspace.ps1` contains `Workbench recovery coverage v1:`; if so record Already Applied when its Git blob is d054d745021035ed0d2dcc148cb413a3b10b6fb7, and otherwise stop and report. Otherwise make exactly these 6 edits (extend existing backup/restore required Workbench consumers and owning causal fixtures only), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([Parameter(Mandatory)][string]$Destination,[switch]$AllowUnencrypted,[switch]$SkipLegacy)
   ```
   with
   ```text
   param([Parameter(Mandatory)][string]$Destination,[switch]$AllowUnencrypted,[switch]$SkipLegacy,[string]$RecoveryInputs)
   ```

   b) immediately after the lines
   ```text
       }
   }

   ```
   insert
   ```text
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
   ```

   c) replace the line
   ```text
   foreach($name in 'CRM','ORVION','CRM-trusted-main','ORVION-trusted-main'){
   ```
   with
   ```text
   foreach($name in 'CRM','ORVION','CRM-trusted-main','ORVION-trusted-main','ORVION-Workbench','ORVION-Workbench-trusted-main'){
   ```

   d) replace the line
   ```text
       [IO.File]::WriteAllLines((Join-Path $dir 'git-config-local.txt'),[string[]](Invoke-Git $r config --local --list))
   ```
   with
   ```text
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
   ```

   e) replace the line
   ```text
       foreach($p in '.orvion-local-certification.json','.orvion-certifications','.claude\settings.json','.claude\settings.local.json'){
   ```
   with
   ```text
       $receiptPaths=if($name-like'ORVION-Workbench*'){@('.workbench-local-certification.json','.workbench-certifications')}else{@('.orvion-local-certification.json','.orvion-certifications','.claude\settings.json','.claude\settings.local.json')}
       foreach($p in $receiptPaths){
   ```

   f) immediately after the lines
   ```text
           originHead="$(& git -C $r symbolic-ref -q refs/remotes/origin/HEAD)".Trim()}  # empty when the clone has none
   }
   ```
   insert
   ```text
   if($workbenchPresent){
       foreach($item in $recovery){
           $file=Join-Path $out ("recovery-inputs/"+$item.name)
           [void][IO.Directory]::CreateDirectory((Split-Path $file -Parent))
           [IO.File]::Copy($item.source,$file,$false)
           if((Get-FileHash -LiteralPath $file).Hash-cne$item.sha256){throw 'BACKUP_RECOVERY_INPUT_CHANGED_DURING_COPY'}
       }
       $plan.workbenchRecovery=[ordered]@{schema=1;inputs=$recovery;receiptFiles=@(Get-ChildItem -LiteralPath (Join-Path $out 'repos/ORVION-Workbench/.workbench-certifications') -File|ForEach-Object{$_.Name})}
   }
   ```

   The resulting file's Git blob is d054d745021035ed0d2dcc148cb413a3b10b6fb7.

2. Check whether `lib/Restore-Workspace.ps1` contains `Workbench recovery coverage v1:`; if so record Already Applied when its Git blob is 98fd3b9b09ea8945abb4b32e318563e5ca5f9ad2, and otherwise stop and report. Otherwise make exactly these 3 edits (extend existing backup/restore required Workbench consumers and owning causal fixtures only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $plan=Get-Content (Join-Path $From 'backup.json') -Raw|ConvertFrom-Json
   ```
   insert
   ```text
   # Workbench recovery coverage v1: required consumers must exist even if omitted from a partial manifest.
   if(@($plan.repos|Where-Object{$_.name-like'ORVION-Workbench*'}).Count){
       $coverage=$plan.workbenchRecovery
       if($coverage-isnot[pscustomobject]-or$coverage.schema-isnot[long]-and$coverage.schema-isnot[int]-or
          $coverage.schema-ne1-or$coverage.inputs-isnot[array]-or$coverage.inputs.Count-eq0-or
          $coverage.receiptFiles-isnot[array]-or$coverage.receiptFiles.Count-eq0){throw 'RESTORE_WORKBENCH_COVERAGE_REQUIRED'}
       foreach($name in 'ORVION-Workbench','ORVION-Workbench-trusted-main'){
           if(@($plan.repos|Where-Object{$_.name-ceq$name}).Count-ne1){throw 'RESTORE_WORKBENCH_COVERAGE_REQUIRED'}
           foreach($file in @("repos/$name.bundle","repos/$name/refs.txt","repos/$name/git-config-local.txt")){
               if(!(Test-Path -LiteralPath (Join-Path $From $file) -PathType Leaf)){throw 'RESTORE_WORKBENCH_INPUT_REQUIRED'}
           }
       }
       $required=@('repos/ORVION-Workbench/.workbench-local-certification.json')
       foreach($name in $plan.workbenchRecovery.receiptFiles){
           if($name-isnot[string]-or$name-cnotmatch'^[A-F0-9]{64}\.json$'){throw 'RESTORE_WORKBENCH_INPUT_INVALID'}
           $required+="repos/ORVION-Workbench/.workbench-certifications/$name"
       }
       $names=@{}
       foreach($item in $plan.workbenchRecovery.inputs){
           if($item-isnot[pscustomobject]-or$item.name-isnot[string]-or$item.sha256-isnot[string]-or$item.name-cnotmatch'^[a-z][a-z0-9-]{0,47}$'-or$names.ContainsKey($item.name)-or$item.sha256-cnotmatch'^[A-F0-9]{64}$'){throw 'RESTORE_WORKBENCH_INPUT_INVALID'}
           $names[$item.name]=$true;$required+=("recovery-inputs/"+$item.name)
           $f=Join-Path $From ("recovery-inputs/"+$item.name)
           if(!(Test-Path -LiteralPath $f -PathType Leaf)-or(Get-FileHash -LiteralPath $f).Hash-cne$item.sha256){throw 'RESTORE_WORKBENCH_INPUT_REQUIRED_OR_CORRUPT'}
       }
       $listed=@([IO.File]::ReadAllLines((Join-Path $From 'SHA256SUMS.txt'))|ForEach-Object{($_-split'  ',2)[1]-replace'\\','/'})
       foreach($file in $required){if(!(Test-Path -LiteralPath (Join-Path $From $file) -PathType Leaf)-or$file-cnotin$listed){throw 'RESTORE_WORKBENCH_INPUT_REQUIRED'}}
       Assert-Absent (Join-Path $Target 'ORVION-Recovery-Inputs')
   }

   ```

   b) replace the line
   ```text
           if($k-match'^(user\.|credential\.|core\.hookspath$|core\.autocrlf$|lfs\.|submodule\.|branch\.|remote\.origin\.pushurl$)'){$cfg[$k]=@($cfg[$k])+$v|Where-Object{$null-ne$_}}
   ```
   with
   ```text
           if($k-match'^(user\.|credential\.|core\.hookspath$|core\.autocrlf$|lfs\.|submodule\.|branch\.|remote\.origin\.pushurl$|push\.default$|protocol\.[a-z.]+$|gc\.auto$|maintenance\.auto$)'){$cfg[$k]=@($cfg[$k])+$v|Where-Object{$null-ne$_}}
   ```

   c) immediately after the lines
   ```text
       $d=Join-Path $LegacyTarget $l.Name;if(Test-Path $d){"SKIPPED legacy $($l.Name) (exists)"}else{Copy-Item $l.FullName $d -Recurse;"RESTORED legacy $($l.Name)"}
   }}
   ```
   insert
   ```text
   if($plan.workbenchRecovery){
       Copy-Item -LiteralPath (Join-Path $From 'recovery-inputs') -Destination (Join-Path $Target 'ORVION-Recovery-Inputs') -Recurse
       Copy-Item -LiteralPath (Join-Path $From 'backup.json') -Destination (Join-Path $Target 'ORVION-Recovery-Inputs/source-map.json')
       'RESTORED Workbench proof inputs; source-map.json retains original paths. Historical receipts retain their original physical roots; no new-machine certification or trust advancement is implied.'
   }
   ```

   The resulting file's Git blob is 98fd3b9b09ea8945abb4b32e318563e5ca5f9ad2.

3. Check whether `lib/test-backup-restore.ps1` contains `Workbench recovery coverage v1:`; if so record Already Applied when its Git blob is 023019fb3c5a3a8a2deb18679e551ccb44bf74a3, and otherwise stop and report. Otherwise make exactly this one edit (extend existing backup/restore required Workbench consumers and owning causal fixtures only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       Assert-That 'malformed present projects root is fatal without success' ($LASTEXITCODE-ne0-and($malformed-join' ')-match'BACKUP_CLAUDE_PROJECTS_NOT_DIRECTORY'-and($malformed-join' ')-notmatch'BACKUP:')
   ```
   insert
   ```text
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
   ```

   The resulting file's Git blob is 023019fb3c5a3a8a2deb18679e551ccb44bf74a3.

## Acceptance Criteria

- [ ] Exact approved scoped recovery output. check: blob:lib/Backup-Workspace.ps1=d054d745021035ed0d2dcc148cb413a3b10b6fb7
- [ ] Exact approved scoped recovery output. check: blob:lib/Restore-Workspace.ps1=98fd3b9b09ea8945abb4b32e318563e5ca5f9ad2
- [ ] Exact approved scoped recovery output. check: blob:lib/test-backup-restore.ps1=023019fb3c5a3a8a2deb18679e551ccb44bf74a3
- [ ] Original RESUME authority remains intact. check: normalized-resume:RESUME.md=1F392B6A18CC44442BCABE3E23BF82571975C585E8C70496881136170FECE520
- [ ] Existing owning test permanently rejects missing/null/empty/scalar/object input collections and invalid entries, plus malformed receiptFiles on restore, with valid nonempty array backup/restore positive controls. Existing owning test proves exact source and independent detached trusted HEAD/refs, preserved push-disabled/protocol-deny settings, byte-identical historical working/archive receipts without root rewriting and declared external proof/source-map round trip. Missing map/receipt, unreadable inputs, corrupt receipt/proof, changed proof hash, unsafe auth-header config, omitted required proof and existing target refuse without a false success or restore target writes as applicable. Existing optional-Claude and product fixtures retain their actual semantics.
- [ ] Mandatory V1/V2/V3, actual focused controls, accepted literal replay/idempotence and negative refusal evidence are preserved. One selected isolated native timed/watched Finish owns the full schedule, fresh SANDBOX receipt, live accepted-code Review, native Review/Complete and independent new carrying-range READY. No original approval or receipt transplant is inferred.
- [ ] Restore returns declared proof files under a non-overwriting recovery-inputs target plus original path map; it does not rewrite root-bound certification or claim new-machine trust. Explicit proof list must be owner reviewed for complete actual evidence/archives; a synthetic map is not a production inventory or offsite restore. Real encryption/cloud/clean-Windows proof remain separately gated.

## Review Gate

- [ ] Inspect actual three scoped engineering files, positive/negative owning fixture output and literal controls; preserve original/WS012/prior seals.
- [ ] Independently check actual native receipt root/Draft/recipe/evaluator/input fingerprint, ordered tests and timed/watcher/host terminal exits; normal native Review/Complete and every new carrying transition must pass. Do not claim second-agent or provider certification.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Owner authorized corrected RECOVERY Draft and one fresh isolated closure in the current continuation. Rejected Draft8494F2AB and its Finish remain rejected and immutable. Synthetic sandbox root-bound approval does not grant human original Gate1. WS013 is an isolated proposed identity; no original allocation or second programme is created. Fresh original admission and owner release-boundary decision are required; changed frozen baseline/scope requires a new exact proposal, never silent substitution.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\recovery-r2\assurance\V3\DRAFT.md
Approved SHA256: 552C6EE22C0752DDC16FC3C5708DA6663EE401C124ED75654E987FF3A4824B63
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\protected-milestone-20261025\OWNER-APPROVAL-AB.txt
Owner Evidence SHA256: 330F8E099FE6D2B4F638052CCE7AAE59D34281EAB86053623B1B4616925DBD59
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\recovery-r2\runtime\sandbox-after-plan\own-finish-receipt.json
Sandbox Receipt SHA256: 0B7F5C2E504746B9DE07C40A8A350913A497B96F50186981A735359162471252
Original admission: owner-approved fixed42 release completed under explicit temporary protection exception; main/preflight exactd4d and protection restored ACTIVE/no-bypass/strict issuer15368 independently verified. Causal Stage3 security proof remains UNPROVEN. B was explicitly approved at this literal root and digest; no repeated approval or sandbox receipt transplant as original certification.
Original exact literal implementation applied by accepted native Workbench Execute. Declared filtered blobs match. Fresh root-bound original Finish and independent live Review remain required; sandbox success does not certify this root. Additional owner knowledge/automatic-freshness/physical-layout refinements remain requirements for an eligible successor scope; this frozen Draft was not expanded.

## Verification Notes

CRGL: Platinum20ea5e0 and Founderda91901 ADR0033 recovery sequence, ENGINEERING_METHOD harness participant-output/counterexample lessons, cold-start mutation controls/restoration, native exact-scope/assurance/receipt contracts SPEC290/292 and carrying completion294/296 were inspected read-only. Neither product owns this workspace backup engine; do not copy database backup claims or alter their receipts. Reuse existing Workbench Backup/Restore/test-backup-restore, file hashes, bundle --all (already proven detached), no-overwrite behavior, mandatory native lifecycle and accepted evaluator. The first focused prototype introduced Workbench fixtures before a preexisting malformed-Claude test; it then failed at a required-map precondition rather than its intended cause. Preserve focused-initial.log; selected prototype restores the original fixture order before adding Workbench cases. No guard weakened. No Finish occurred before selection.

## Selection reasons and sources

Evidence Refresh: this corrected selection owns its new focused and literal evidence and requires one fresh isolated native Finish. The rejected Finish certifies no corrected bytes. focused-selected.log actual full owning selfcheck PASS; original clean d4d/None and sealed prior111 files verified, WS012 frozen sandbox untouched. Existing hostedSUCCESS and42READY reused; no GitHub operation. Three declared output blobs and selected literal replay will be tested before one fresh sandbox native Finish. Preserve baseline pin/evaluator and all inherited programme/release holds.

Sources: current owner corrected Recovery and knowledge-retention continuation; prior rejected exact Draft and RECOVERY-REVIEW-BLOCKER.md, accepted WORKFLOW/template/checker, sealed prior backup-coverage-gap.json/remote-source-download.json, actual owning Backup/Restore/tests, focused-initial.log and focused-selected.log, CRGL-PRECEDENTS.md and PROTECTED-MAIN-SEQUENCE.md. CAG/SACI/PICF and four principles use their existing owning authorities; no parallel plan or scope bypass.
