# Small coordinator only. Native interfaces/engines own authorization and admission; no delegation is inferred.
[CmdletBinding()]
param([Parameter(Mandatory)][ValidateSet('PUBLISH','PROMOTE')][string]$Operation,
      [Parameter(Mandatory)][string]$Descriptor,[Parameter(Mandatory)][string]$EvidenceDirectory,
      [string]$Approval,[string]$ApprovalSha256,[switch]$NonInteractive)
$ErrorActionPreference='Stop'
$interactive=!$NonInteractive-and[Environment]::UserInteractive-and$Host.Name-eq'ConsoleHost'
try{$interactive=$interactive-and![Console]::IsInputRedirected-and![Console]::IsOutputRedirected}catch{$interactive=$false}
foreach($hostArgument in [Environment]::GetCommandLineArgs()|Select-Object -Skip 1){
    if($hostArgument-match'^-(File|f|Command|c|EncodedCommand|e|ec)$'){break}
    if($hostArgument.StartsWith('-')-and$hostArgument.Length-ge5-and'noninteractive'.StartsWith($hostArgument.Substring(1).ToLowerInvariant())){$interactive=$false}
}
$overall='REFUSED';$classification='PRECONDITION';$exitCode=1;$manifestPath=$null
$outcomes=[Collections.Generic.List[object]]::new()
$descriptorHash=$null;$runRoot=$null;$admission=$null
function Save-DualResult {
    if($manifestPath){
        $record=[ordered]@{schema=1;operation=$Operation;descriptorSha256=$descriptorHash;admission=$admission;recordedUtc=[DateTime]::UtcNow.ToString('o');result=$overall;classification=$classification;exitCode=$exitCode;targets=@($outcomes.ToArray())}
        [IO.File]::WriteAllText($manifestPath,($record|ConvertTo-Json -Depth 6)+"`n",[Text.UTF8Encoding]::new($false))
    }
}
function Read-DualGit([string]$RepoRoot,[string[]]$GitArguments){
    $lines=@(& git -C $RepoRoot @GitArguments 2>$null)
    if($LASTEXITCODE-ne0){throw 'UNREADABLE: required local Git read failed.'}
    $lines
}
function Read-DualRemote([string]$RepoRoot,[string]$Ref){
    $lines=@(& git -C $RepoRoot ls-remote --exit-code origin $Ref 2>$null)
    $readExit=$LASTEXITCODE
    if($readExit-eq2-and$lines.Count-eq0){return $null}
    if($readExit-ne0-or$lines.Count-ne1-or$lines[0]-cnotmatch('^(?<sha>[0-9a-f]{40})\s+'+[regex]::Escape($Ref)+'$')){throw 'UNREADABLE: exact remote ref could not be read.'}
    $Matches.sha
}
function Assert-DualRoot([string]$RepoRoot,[string]$Repository,[string]$ExpectedHead,[string]$ExpectedBranch){
    if(![IO.Path]::IsPathFullyQualified($RepoRoot)-or!(Test-Path -LiteralPath $RepoRoot -PathType Container)){throw 'REFUSED: explicit existing absolute checkout required.'}
    $top=(Read-DualGit $RepoRoot @('rev-parse','--show-toplevel')|Out-String).Trim()
    if([IO.Path]::GetFullPath($top)-ine[IO.Path]::GetFullPath($RepoRoot)){throw 'REFUSED: checkout is not its repository root.'}
    if((Read-DualGit $RepoRoot @('rev-parse','HEAD')|Out-String).Trim()-cne$ExpectedHead-or@(Read-DualGit $RepoRoot @('status','--porcelain')).Count){throw 'REFUSED: checkout HEAD or clean state changed.'}
    $branch=(Read-DualGit $RepoRoot @('branch','--show-current')|Out-String).Trim()
    if(!$branch-or($ExpectedBranch-and$branch-cne$ExpectedBranch)){throw 'REFUSED: checkout branch role is wrong.'}
    $account=($Repository-split'/')[0]
    $urlPattern='^https://(?:'+[regex]::Escape($account)+'@)?github\.com/'+[regex]::Escape($Repository)+'(?:\.git)?$'
    foreach($direction in @(@('remote','get-url','--all','origin'),@('remote','get-url','--push','--all','origin'))){
        $urls=@(Read-DualGit $RepoRoot $direction)
        if($urls.Count-ne1-or$urls[0]-cnotmatch$urlPattern){throw 'REFUSED: checkout repository destination is wrong.'}
    }
    $helpers=@(Read-DualGit $RepoRoot @('config','--local','--get-all','credential.https://github.com.helper'))
    if($helpers.Count-ne2-or$helpers[0]-cne''-or$helpers[1]-notmatch('gh auth token --user '+[regex]::Escape($account)+'\b')-or[regex]::Matches($helpers[1],'gh auth token --user ').Count-ne1){throw 'REFUSED: own-account configuration route is not pinned.'}
}
try{
    if(![IO.Path]::IsPathFullyQualified($Descriptor)-or![IO.Path]::IsPathFullyQualified($EvidenceDirectory)){throw 'REFUSED: descriptor and evidence paths must be absolute.'}
    if(!$Approval-or!$ApprovalSha256){throw 'REFUSED: explicit exact-byte operation approval is missing.'}
    . (Join-Path $PSScriptRoot 'Test-OwnerDualAdmission.ps1')
    $admission=Assert-OwnerDualAdmission -Approval $Approval -ApprovalSha256 $ApprovalSha256 -Descriptor $Descriptor -EvidenceDirectory $EvidenceDirectory -Operation $Operation -WorkbenchRoot (Split-Path $PSScriptRoot -Parent)
    if(!$interactive){throw 'REFUSED: interactive owner console required; no operation was attempted.'}
    $descriptorBytes=[IO.File]::ReadAllBytes($Descriptor)
    $descriptorHash=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($descriptorBytes))
    if($descriptorHash-cne$admission.DescriptorSha256){throw 'REFUSED: descriptor changed after admission.'}
    $config=[Text.Encoding]::UTF8.GetString($descriptorBytes)|ConvertFrom-Json
    $topFields=@($config.PSObject.Properties.Name|Sort-Object)
    if(($topFields-join',')-cne'schema,targets'-or$config.schema-ne1-or$config.targets-isnot[Array]-or$config.targets.Count-ne2){throw 'REFUSED: descriptor must contain schema1 and exactly two targets.'}
    $seen=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $roots=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach($target in $config.targets){
        $fields=@($target.PSObject.Properties.Name|Sort-Object)
        if(($fields-join',')-cne'base,candidate,candidateRoot,repository,trustedRoot'-or$target.repository-notin@('PlatPlusHub/CRM','Shehabhub/ORVION')-or!$seen.Add($target.repository)){throw 'REFUSED: two distinct known repositories and exact target fields required.'}
        if($target.candidate-isnot[string]-or$target.base-isnot[string]-or$target.candidate-cnotmatch'^[0-9a-f]{40}$'-or$target.base-cnotmatch'^[0-9a-f]{40}$'){throw 'REFUSED: full lowercase candidate and base SHAs required.'}
        foreach($rootValue in @($target.candidateRoot,$target.trustedRoot)){
            if($rootValue-isnot[string]-or![IO.Path]::IsPathFullyQualified($rootValue)-or!$roots.Add([IO.Path]::GetFullPath($rootValue).TrimEnd('\','/'))){throw 'REFUSED: four distinct explicit absolute checkout roots required.'}
            $absoluteRoot=[IO.Path]::GetFullPath($rootValue).TrimEnd('\','/')
            $absoluteEvidence=[IO.Path]::GetFullPath($EvidenceDirectory).TrimEnd('\','/')
            if($absoluteEvidence-ieq$absoluteRoot-or$absoluteEvidence.StartsWith($absoluteRoot+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)){throw 'REFUSED: evidence must be outside all checkouts.'}
        }
        $outcomes.Add([pscustomobject]@{repository=$target.repository;candidate=$target.candidate;targetRef=$(if($Operation-eq'PUBLISH'){'refs/heads/orvion-preflight'}else{'refs/heads/main'});result='NOT_STARTED';childExit=$null;childEvidence=$null})
    }
    # Create allowlisted evidence only after the static descriptor/output boundary is valid.
    [void][IO.Directory]::CreateDirectory($EvidenceDirectory)
    $runRoot=Join-Path $EvidenceDirectory ([DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ')+'-'+[guid]::NewGuid().ToString('N'))
    [void][IO.Directory]::CreateDirectory($runRoot)
    $manifestPath=Join-Path $runRoot 'result.json'
    Save-DualResult
    # Preflight both targets before invoking either interface. This reads only; it never fetches, stages or repairs.
    for($index=0;$index-lt2;$index++){
        $target=$config.targets[$index];$outcome=$outcomes[$index]
        Assert-DualRoot $target.trustedRoot $target.repository $target.base 'main'
        $main=Read-DualRemote $target.trustedRoot 'refs/heads/main'
        $refValue=Read-DualRemote $target.trustedRoot $outcome.targetRef
        if($refValue-ceq$target.candidate-and($main-ceq$target.base-or($Operation-eq'PROMOTE'-and$main-ceq$target.candidate))){$outcome.result='ALREADY_DONE';continue}
        if($main-cne$target.base){throw 'REFUSED: remote main differs from the reviewed base.'}
        if($Operation-eq'PUBLISH'){
            Assert-DualRoot $target.candidateRoot $target.repository $target.candidate ''
            if(!(Test-Path -LiteralPath (Join-Path $target.candidateRoot ('.orvion-certifications\'+$target.candidate+'.json')) -PathType Leaf)){throw 'REFUSED: exact candidate record is missing.'}
        }elseif((Read-DualRemote $target.trustedRoot 'refs/heads/orvion-preflight')-cne$target.candidate){throw 'REFUSED: preflight differs from selected candidate.'}
        $entry=Join-Path $target.trustedRoot ('scripts\owner_'+$Operation.ToLowerInvariant()+'.ps1')
        if(!(Test-Path -LiteralPath $entry -PathType Leaf)){throw 'REFUSED: own tracked owner interface is missing.'}
        $outcome.result='PREFLIGHT_READY'
    }
    Save-DualResult
    for($index=0;$index-lt2;$index++){
        $target=$config.targets[$index];$outcome=$outcomes[$index]
        if($outcome.result-eq'ALREADY_DONE'){Write-Host "ALREADY $Operation $($target.repository): $($target.candidate)";continue}
        # A distinct pre-side-effect boundary: refresh approval/source/config bytes, never native tests or Gate.
        $admission=Assert-OwnerDualAdmission -Approval $Approval -ApprovalSha256 $ApprovalSha256 -Descriptor $Descriptor -EvidenceDirectory $EvidenceDirectory -Operation $Operation -WorkbenchRoot (Split-Path $PSScriptRoot -Parent)
        # Refresh exact main/target before each side effect; never repeat a previously completed target.
        if((Read-DualRemote $target.trustedRoot 'refs/heads/main')-cne$target.base){throw 'REFUSED: remote main changed after preflight.'}
        $childDirectory=Join-Path $runRoot ('target-'+($index+1))
        [void][IO.Directory]::CreateDirectory($childDirectory)
        $outcome.childEvidence=$childDirectory;$outcome.result='RUNNING';Save-DualResult
        $entry=Join-Path $target.trustedRoot ('scripts\owner_'+$Operation.ToLowerInvariant()+'.ps1')
        $childArguments=@('-NoProfile','-File',$entry,'-Candidate',$target.candidate,'-EvidenceDirectory',$childDirectory)
        if($Operation-eq'PUBLISH'){$childArguments+=@('-Root',$target.candidateRoot)}
        # Do not capture child stdout: its own real console confirmation must stay interactive.
        & pwsh @childArguments
        $outcome.childExit=$LASTEXITCODE
        $outcome.result='FAILED';Save-DualResult
        if($null-eq$outcome.childExit-or$outcome.childExit-ne0){throw 'FAILED: own owner interface refused; preserve completed target and inspect results.'}
        $files=@(Get-ChildItem -LiteralPath $childDirectory -File -Filter '*.json')
        if($files.Count-ne1){throw 'UNREADABLE: expected one new own operation record.'}
        try{$child=Get-Content -Raw -LiteralPath $files[0].FullName|ConvertFrom-Json}
        catch{throw 'UNREADABLE: new own operation record could not be read as JSON.'}
        $expectedCheckout=if($Operation-eq'PUBLISH'){$target.candidateRoot}else{$target.trustedRoot}
        if($child.operation-cne$Operation-or$child.repository-cne$target.repository-or$child.candidate-cne$target.candidate-or$child.targetRef-cne$outcome.targetRef-or$child.checkout-ine$expectedCheckout-or$child.result-cne'DONE'-or$child.exitCode-ne0-or$child.classification-cne'EXACT_REMOTE_REF_VERIFIED'){throw 'FAILED: own operation record does not match selected operation.'}
        if((Read-DualRemote $target.trustedRoot $outcome.targetRef)-cne$target.candidate){throw 'REF_MISMATCH: readable target ref differs from the selected candidate after child success.'}
        $outcome.result='DONE';Save-DualResult
    }
    $overall='DONE';$classification='EXACT_REFS_VERIFIED';$exitCode=0
}catch{
    Write-Host "Reason: $($_.Exception.Message)"
    if($_.Exception.Message.StartsWith('UNREADABLE:')-or$_.Exception.Message.StartsWith('ADMISSION_UNREADABLE:')){
        $classification='UNREADABLE'
        if($outcome-and$outcome.result-notin@('DONE','ALREADY_DONE')){$outcome.result='UNREADABLE'}
    }elseif($_.Exception.Message.StartsWith('FAILED:')){$classification='CHILD_RESULT_REFUSED'}
    elseif($_.Exception.Message.StartsWith('REF_MISMATCH:')){$classification='EXACT_REF_MISMATCH'}
    $overall=if(@($outcomes|Where-Object result -in @('DONE','ALREADY_DONE')).Count){'PARTIAL'}elseif($classification-eq'UNREADABLE'){'UNREADABLE'}elseif(@($outcomes|Where-Object{$null-ne$_.childExit}).Count){'FAILED'}else{'REFUSED'}
}finally{
    try{Save-DualResult}catch{$overall='FAILED';$exitCode=1;Write-Host 'Could not persist dual result; read actual refs before retry.'}
    Write-Host "DUAL_${Operation}: $overall"
    if($manifestPath){Write-Host "Result: $manifestPath"}
    Write-Host 'Publication/promotion results do not certify either repository. No rollback or history rewrite was attempted.'
}
exit $exitCode
