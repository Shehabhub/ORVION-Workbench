# Generic PICF lifecycle rehearsal of one frozen Draft (disposable clone, push DISABLED, real .githooks), one
# repository per run. Base = the commit the Draft names as its baseline, modelled as main. The implementation
# applies the Draft's own steps literally (apply-draft-steps.ps1), so the Draft text alone is proven
# executable. Carries the authoritative checkout's ignored certification state read-only (ENGINEERING_METHOD §2).
param([Parameter(Mandatory)][ValidateSet('platinum','founder')][string]$Repo,[Parameter(Mandatory)][string]$Base,[Parameter(Mandatory)][string]$Id,[Parameter(Mandatory)][string]$Slug,[Parameter(Mandatory)][string]$DraftFile,[Parameter(Mandatory)][string]$EvidenceDir,[string]$Date=(Get-Date -Format yyyy-MM-dd))
$ErrorActionPreference='Stop'
# A failed git or pwsh throws (PowerShell 7.4+); calls whose exit code is the evidence opt out locally.
$PSNativeCommandUseErrorActionPreference=$true
$script:Failures=@()
function Assert-Rig([bool]$Ok,[string]$What){if(-not$Ok){$script:Failures+=$What}}
. (Join-Path $PSScriptRoot 'lifecycle.ps1')
$Ev=$EvidenceDir
$cfg=@{platinum=@{Auth='C:\Users\My Lab\Documents\GitHub\CRM';Url='https://github.com/PlatPlusHub/CRM.git';User='PlatPlusHub';Mail='platplustours@gmail.com'}
       founder=@{Auth='C:\Users\My Lab\Documents\GitHub\ORVION';Url='https://github.com/Shehabhub/ORVION.git';User='Shehabhub';Mail='shehab.nim@gmail.com'}}[$Repo]
$Name="rig-$Repo";$Rel="changes/$Id-$Slug.md"
# The files the Draft's own steps change, read from the Draft.
$Changed=@([regex]::Matches(([IO.File]::ReadAllText($DraftFile)-replace"`r`n","`n"),'(?m)^\d+\. Check whether `([^`]+)` contains')|ForEach-Object{$_.Groups[1].Value});if(!$Changed.Count){throw 'NO_FILE_STEPS'}
$c=Join-Path $Ev $Name;$log=Join-Path $Ev "$Name.log";$noHooks=Join-Path $Ev 'no-hooks'
function Say([string]$s){$l="[$(Get-Date -Format HH:mm:ss)] $s";Add-Content -LiteralPath $log -Value $l -Encoding utf8;$l}
function Brief([string]$t){(($t-split"`r?`n")|Where-Object{$_-match'^(ORVION|MODE|CODE|SUBJECT|APPROVAL_EVIDENCE|PREPARE|CRITERIA|BLOCKER):'}|Select-Object -First 8)-join' | '}
function Commit-Rig([string]$Message,[switch]$NoHook,[switch]$ExpectRefusal){$PSNativeCommandUseErrorActionPreference=$false
    git -C $c add -A
    $h=if($NoHook){@('-c',"core.hooksPath=$noHooks")}else{@()}
    $out=& git -C $c @h commit -q -m $Message 2>&1|Out-String;$code=$LASTEXITCODE
    Add-Content -LiteralPath $log -Value $out -Encoding utf8
    if($ExpectRefusal){Say "EXPECTED-REFUSAL probe exit=$code :: $(Brief $out)";return $out}
    if($code){Say "COMMIT REFUSED ($code): $Message :: $(Brief $out)";throw 'COMMIT_REFUSED'}
    Say ("COMMIT OK {0} {1}{2} :: {3}" -f (git -C $c rev-parse --short HEAD),$Message,$(if($NoHook){' [hooks off: sandbox only]'}else{''}),(Brief $out))
}
function Invoke-Ctl([string[]]$A){$PSNativeCommandUseErrorActionPreference=$false;$o=& pwsh -NoProfile -WorkingDirectory $c -File "$c\scripts\check_agent_continuity.ps1" @A 2>&1|Out-String;Add-Content -LiteralPath $log -Value $o -Encoding utf8;[pscustomobject]@{Code=$LASTEXITCODE;Text=$o}}

if(Test-Path $c){throw "exists: $c"}
Set-Content -LiteralPath $log -Value "rehearsal $Name start $(Get-Date -Format s) draft sha256 $((Get-FileHash -Algorithm SHA256 $DraftFile).Hash)" -Encoding utf8
[void](New-Item -ItemType Directory -Force $noHooks)
git clone -q --no-hardlinks $cfg.Auth $c
git -C $c remote set-url origin $cfg.Url;git -C $c remote set-url --push origin DISABLED
git -C $c update-ref refs/remotes/origin/main $Base;git -C $c checkout -q -B main $Base;git -C $c branch -q --set-upstream-to=origin/main
git -C $c config core.hooksPath .githooks;git -C $c config user.name $cfg.User;git -C $c config user.email $cfg.Mail
if((git -C $c rev-parse --show-toplevel)-ne($c-replace'\\','/')){throw 'ROOT_MISMATCH'}
Copy-Item -LiteralPath "$($cfg.Auth)\.orvion-local-certification.json" -Destination $c
Copy-Item -LiteralPath "$($cfg.Auth)\.orvion-certifications" -Destination $c -Recurse
Get-ChildItem -LiteralPath "$c\.orvion-certifications" -File|ForEach-Object{$_.IsReadOnly=$true}
$rc=Get-Content -Raw "$c\.orvion-local-certification.json"|ConvertFrom-Json
Say "clone $(git -C $c rev-parse HEAD); receipt cr=$($rc.cr); records $(@(Get-ChildItem "$c\.orvion-certifications").Count)"
Say "BOOT start :: $(Brief (Invoke-Ctl @('-Boot')).Text)"

Copy-Item -LiteralPath $DraftFile -Destination (Join-Path $c $Rel)
Commit-Rig "${Id}: allocate exact frozen Draft (REHEARSAL)"
$t=Read-RepoText $c $Rel;Write-RepoText $c $Rel (Set-Status $t 'Draft' 'Approved');Set-ManifestLine $c 'Active Change Request' "``$Rel``";Update-Projections $c
Commit-Rig "${Id}: Approve exact frozen contract (REHEARSAL)"
$PSNativeCommandUseErrorActionPreference=$false;$ap=& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'apply-draft-steps.ps1') -Draft $DraftFile -Root $c 2>&1|Out-String
Add-Content -LiteralPath $log -Value $ap -Encoding utf8
$apc=$LASTEXITCODE;$PSNativeCommandUseErrorActionPreference=$true;if($apc){throw 'DRAFT_STEPS_DID_NOT_REPRODUCE'}
Say "Draft steps applied literally: $(([regex]::Match($ap,'files: [0-9]+, mismatches: [0-9]+')).Value)"
Update-Projections $c
& pwsh -NoProfile -WorkingDirectory $c -File "$c\scripts\generate-ai-map.ps1" -Check *>$null;$gc=$LASTEXITCODE;$PSNativeCommandUseErrorActionPreference=$true;Say "generator -Check exit=$gc";Assert-Rig ($gc-eq0) "generator -Check exit $gc"
Say "status: $((git -C $c status --porcelain)-join' | ')"
$t=Read-RepoText $c $Rel;$nl=Get-Newline $t;$t=Set-Status $t 'Approved' 'In Progress'
$t=Add-ToSection $t 'Verification Notes' "### $Date — Implementation checkpoint (REHEARSAL)${nl}${nl}Outcome: Complete${nl}${nl}- Implementation steps applied from the Draft (rehearsal)."
$t=Set-Once $t "Resume Step: 1$nl" "Resume Step: DONE$nl" 'checkpoint';Write-RepoText $c $Rel $t
Commit-Rig "${Id}: implement; Runtime Checkpoint DONE (REHEARSAL)"
$draftText=[IO.File]::ReadAllText($DraftFile)
foreach($f in $Changed){$b=git -C $c rev-parse "HEAD:$f";Say "blob $f = $b; named in Draft: $($draftText.Contains($b))";Assert-Rig $draftText.Contains($b) "blob $f not named in Draft"}
Say "BOOT done :: $(Brief (Invoke-Ctl @('-Boot')).Text)"

# Finish entry through the real timed runner (now the patched one): pass the entry stage and
# pending-certification protection, then stop the whole tree deepest first.
$flog=Join-Path $Ev "$Name-finish.log"
$tmpDir=[IO.Path]::GetTempPath();$before=@(Get-ChildItem -LiteralPath $tmpDir -Filter 'orvion-verify-*.log' -ErrorAction SilentlyContinue).FullName
$si=[Diagnostics.ProcessStartInfo]::new('pwsh');$si.WorkingDirectory=$c;$si.UseShellExecute=$false
foreach($arg in @('-NoProfile','-File','scripts/run_timed.ps1','-Log',$flog,'-Command','pwsh -NoProfile -File scripts/check_agent_continuity.ps1 -Finish')){$si.ArgumentList.Add($arg)}
$p=[Diagnostics.Process]::Start($si);$verdict='TIMEOUT';$sw=[Diagnostics.Stopwatch]::StartNew()
while($sw.Elapsed.TotalSeconds-lt300){Start-Sleep -Milliseconds 250
    if(@(Get-ChildItem -LiteralPath $tmpDir -Filter 'orvion-verify-*.log' -ErrorAction SilentlyContinue|Where-Object{$_.FullName-notin$before}).Count){$verdict='FIRST_VERIFICATION_STARTED';break}
    if($p.HasExited){$verdict="EXITED $($p.ExitCode)";break}}
$stop=Stop-ProcessTreeFully $p.Id $p.StartTime;[void]$p.WaitForExit(10000);Assert-Rig ($stop.Survivors-eq0) "finish-entry survivors $($stop.Survivors)"
Say "finish-entry tree stopped: $($stop.Stopped) process(es) seen; survivors: $($stop.Survivors)"
$ft=Get-Content -Raw -LiteralPath $flog
Assert-Rig ($verdict-eq'FIRST_VERIFICATION_STARTED'-and$ft-notmatch'PENDING_RECEIPT|CERTIFY: FAILED') "finish entry $verdict";Say "FINISH ENTRY: $verdict after $([int]$sw.Elapsed.TotalSeconds)s; refused=$($ft-match'PENDING_RECEIPT|CERTIFY: FAILED'); profiles: $(([regex]::Match($ft,'VERIFICATION: [^\r\n]+')).Value)"

$t=Read-RepoText $c $Rel;$nl=Get-Newline $t
$t=Add-ToSection $t 'Review Gate' "### $Date — Independent live Review (REHEARSAL)${nl}${nl}Verdict: Confirmed Complete${nl}${nl}Recommendation to human: Set Status to Complete"
Write-RepoText $c $Rel $t;Commit-Rig "${Id}: Review (REHEARSAL)"
$t=Read-RepoText $c $Rel;$t=[regex]::Replace($t,'(?m)^- \[ \] ','- [x] ');$t=Set-Status $t 'In Progress' 'Complete';Write-RepoText $c $Rel $t
Set-ManifestLine $c 'Active Change Request' 'None.'
$lc=[regex]::Match($draftText,'`(Last Completed: \*\*.+?\*\*)`').Groups[1].Value;if(!$lc){throw 'no Last Completed in Draft'}
Set-ManifestLine $c 'Last Completed' $lc.Substring('Last Completed: '.Length);Update-Projections $c
$probe=(Commit-Rig "${Id}: Complete (REHEARSAL real-hook probe)" -ExpectRefusal)|Out-String
Say "hook criterion stage: criterion failure=$($probe-match'CRITERION_CHECK_FAILED') reached-receipt=$($probe-match'COMPLETION_PREREQUISITE[\s\S]*(no local certification receipt|certification receipt names)')";Assert-Rig ($probe-notmatch'CRITERION_CHECK_FAILED'-and$probe-match'COMPLETION_PREREQUISITE[\s\S]*(no local certification receipt|certification receipt names)') 'hook criterion stage'
Commit-Rig "${Id}: Complete (REHEARSAL)" -NoHook
$cand=(git -C $c rev-parse HEAD).Trim()
$rg=Invoke-Ctl @('-Gate','-BaseRef',$Base,'-HeadRef',$cand);Assert-Rig ($rg.Code-eq0-and$rg.Text-match'ORVION: READY') "range $($rg.Code)"
Say "RANGE (candidate evaluator, judges this contract's own Approval with Draft Assurance) $Base..$cand :: exit=$($rg.Code) :: $(Brief $rg.Text)"
$tm=Join-Path $Ev "$Name-trusted";$data=Join-Path $Ev "$Name-data"
git -C $c -c "core.hooksPath=$noHooks" worktree add -q --detach $tm $Base;git -C $c -c "core.hooksPath=$noHooks" worktree add -q --detach $data $cand
$PSNativeCommandUseErrorActionPreference=$false;$j=& pwsh -NoProfile -File (Join-Path $tm 'scripts/check_agent_continuity.ps1') -Gate -Trusted -Root $data -BaseRef $Base -HeadRef $cand 2>&1|Out-String;$jc=$LASTEXITCODE;$PSNativeCommandUseErrorActionPreference=$true;Assert-Rig ($jc-eq0-and$j-match'ORVION: READY') "trusted $jc"
Add-Content -LiteralPath $log -Value $j -Encoding utf8;Say "TRUSTED (base evaluator) exit=$jc :: $(Brief $j)"
git -C $c worktree remove --force $tm;git -C $c worktree remove --force $data
if($script:Failures.Count){Say "REHEARSAL FAILED: $($script:Failures-join'; ')";throw 'REHEARSAL_FAILED'}
Say "REHEARSAL PASSED; rehearsal end $(Get-Date -Format s)"
