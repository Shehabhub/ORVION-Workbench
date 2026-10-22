# A local, exact-byte operator interlock, NOT owner authentication or an OS security boundary.
# One operation document is supplied explicitly; this is not an approval registry or product authority.
function Assert-OwnerDualAdmission {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Approval,
          [Parameter(Mandatory)][ValidatePattern('^[0-9A-Fa-f]{64}$')][string]$ApprovalSha256,
          [Parameter(Mandatory)][string]$Descriptor,
          [Parameter(Mandatory)][string]$EvidenceDirectory,
          [Parameter(Mandatory)][ValidateSet('PUBLISH','PROMOTE')][string]$Operation,
          [Parameter(Mandatory)][string]$WorkbenchRoot)
    $ErrorActionPreference='Stop'
    function Read-AdmissionGit([string]$Checkout,[string[]]$Arguments) {
        $readLines=@(& git -C $Checkout @Arguments 2>$null)
        if($LASTEXITCODE-ne0){throw 'ADMISSION_UNREADABLE: Git read failed.'}
        $readLines
    }
    function Assert-AdmissionFields($RecordValue,[string]$Expected) {
        if((($RecordValue.PSObject.Properties.Name|Sort-Object)-join',')-cne$Expected){throw 'ADMISSION_REFUSED: unexpected operation document fields.'}
    }
    function Assert-AdmissionJson([System.Text.Json.JsonElement]$Element) {
        if($Element.ValueKind-eq[System.Text.Json.JsonValueKind]::Object) {
            $names=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
            foreach($property in $Element.EnumerateObject()) {
                if(!$names.Add($property.Name)){throw 'ADMISSION_REFUSED: duplicate JSON member.'}
                Assert-AdmissionJson $property.Value
            }
        }elseif($Element.ValueKind-eq[System.Text.Json.JsonValueKind]::Array){foreach($elementItem in $Element.EnumerateArray()){Assert-AdmissionJson $elementItem}}
    }
    foreach($absolutePath in @($Approval,$Descriptor,$WorkbenchRoot)) {
        if(![IO.Path]::IsPathFullyQualified($absolutePath)){throw 'ADMISSION_REFUSED: absolute paths required.'}
        if((Get-Item -LiteralPath $absolutePath -Force -ErrorAction Stop).Attributes-band[IO.FileAttributes]::ReparsePoint){throw 'ADMISSION_REFUSED: reparse target.'}
    }
    $approvalBytes=[IO.File]::ReadAllBytes($Approval)
    $actualApproval=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($approvalBytes))
    if($actualApproval-cne$ApprovalSha256.ToUpperInvariant()){throw 'ADMISSION_REFUSED: operation approval bytes changed.'}
    $approvalText=[Text.Encoding]::UTF8.GetString($approvalBytes)
    $approvalDocument=[System.Text.Json.JsonDocument]::Parse($approvalText)
    try {
        Assert-AdmissionJson $approvalDocument.RootElement
        if($approvalDocument.RootElement.GetProperty('schema').ValueKind-ne[System.Text.Json.JsonValueKind]::Number-or
           $approvalDocument.RootElement.GetProperty('schema').GetInt32()-ne1){throw 'ADMISSION_REFUSED: schema must be integer 1.'}
        $expiryLiteral=$approvalDocument.RootElement.GetProperty('expiresUtc').GetString()
    }finally{$approvalDocument.Dispose()}
    $authorization=$approvalText|ConvertFrom-Json -ErrorAction Stop
    Assert-AdmissionFields $authorization 'configurations,descriptorSha256,evidenceDirectory,expiresUtc,operation,reviewSha256,schema,sourceDraftSha256,sourceFiles,workbenchConfigSha256,workbenchHead,workbenchRoot'
    if(![IO.Path]::IsPathFullyQualified($EvidenceDirectory)-or$authorization.evidenceDirectory-cne[IO.Path]::GetFullPath($EvidenceDirectory)){throw 'ADMISSION_REFUSED: output directory differs from approved scope.'}
    if($authorization.schema-ne1-or$authorization.operation-cne$Operation-or
       $authorization.workbenchRoot-cne[IO.Path]::GetFullPath($WorkbenchRoot)-or
       $authorization.workbenchHead-cnotmatch'^[0-9a-f]{40}$'-or
       $authorization.sourceDraftSha256-cnotmatch'^[0-9A-F]{64}$'-or
       $authorization.reviewSha256-cnotmatch'^[0-9A-F]{64}$') {throw 'ADMISSION_REFUSED: operation/source/review selection invalid.'}
    $expires=[DateTimeOffset]::MinValue
    # PowerShell versions may auto-convert JSON ISO dates. Validate the actual JSON literal, not that coercion.
    if(![DateTimeOffset]::TryParseExact($expiryLiteral,'yyyy-MM-ddTHH:mm:ssZ',[Globalization.CultureInfo]::InvariantCulture,[Globalization.DateTimeStyles]::AssumeUniversal,[ref]$expires)-or
       $expires-le[DateTimeOffset]::UtcNow){throw 'ADMISSION_REFUSED: operation approval expired or malformed.'}
    # Verify raw local config BEFORE a status read can consult it. Worktrees/shared Git directories are refused.
    $workbenchConfig=Join-Path $WorkbenchRoot '.git\config'
    if(!(Test-Path -LiteralPath (Join-Path $WorkbenchRoot '.git') -PathType Container)-or
       $authorization.workbenchConfigSha256-cnotmatch'^[0-9A-F]{64}$'-or
       (Get-FileHash -LiteralPath $workbenchConfig -Algorithm SHA256).Hash-cne$authorization.workbenchConfigSha256){throw 'ADMISSION_REFUSED: reviewed Workbench configuration changed.'}
    $top=(Read-AdmissionGit $WorkbenchRoot @('rev-parse','--show-toplevel')|Out-String).Trim()
    if([IO.Path]::GetFullPath($top)-cne[IO.Path]::GetFullPath($WorkbenchRoot)-or
       (Read-AdmissionGit $WorkbenchRoot @('rev-parse','HEAD')|Out-String).Trim()-cne$authorization.workbenchHead-or
       @(Read-AdmissionGit $WorkbenchRoot @('status','--porcelain','--untracked-files=all')).Count){throw 'ADMISSION_REFUSED: Workbench identity or clean state changed.'}
    $required=@('lib/Owner-PublishDual.ps1','lib/Owner-PromoteDual.ps1','lib/Invoke-OwnerDual.ps1','lib/Test-OwnerDualAdmission.ps1')
    if($authorization.sourceFiles-isnot[Array]-or$authorization.sourceFiles.Count-ne$required.Count){throw 'ADMISSION_REFUSED: exact source population required.'}
    $sourceSeen=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach($sourceFile in $authorization.sourceFiles) {
        Assert-AdmissionFields $sourceFile 'path,sha256'
        if($sourceFile.path-cnotin$required-or!$sourceSeen.Add($sourceFile.path)-or
           $sourceFile.sha256-cnotmatch'^[0-9A-F]{64}$'-or
           (Get-FileHash -LiteralPath (Join-Path $WorkbenchRoot $sourceFile.path) -Algorithm SHA256).Hash-cne$sourceFile.sha256){throw 'ADMISSION_REFUSED: approved coordinator bytes changed.'}
    }
    foreach($relative in $required) {
        $tracked=@(Read-AdmissionGit $WorkbenchRoot @('ls-tree','HEAD','--',$relative))
        if($tracked.Count-ne1-or$tracked[0]-notmatch'^100(?:644|755) blob '){throw 'ADMISSION_REFUSED: untracked coordinator source.'}
    }
    $descriptorBytes=[IO.File]::ReadAllBytes($Descriptor)
    $descriptorDigest=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($descriptorBytes))
    if($authorization.descriptorSha256-cne$descriptorDigest){throw 'ADMISSION_REFUSED: reviewed descriptor changed.'}
    $descriptorText=[Text.Encoding]::UTF8.GetString($descriptorBytes)
    $selection=$descriptorText|ConvertFrom-Json -ErrorAction Stop
    $selectionDocument=[System.Text.Json.JsonDocument]::Parse($descriptorText)
    try{Assert-AdmissionJson $selectionDocument.RootElement}finally{$selectionDocument.Dispose()}
    # The coordinator owns full descriptor semantics. This interlock only binds its exact bytes and configuration subjects.
    $expectedRoots=@($selection.targets|ForEach-Object{$_.candidateRoot;$_.trustedRoot})
    $outputRoot=[IO.Path]::GetFullPath($EvidenceDirectory).TrimEnd('\','/')
    foreach($checkoutRoot in @($WorkbenchRoot)+$expectedRoots) {
        $resolvedCheckout=[IO.Path]::GetFullPath($checkoutRoot).TrimEnd('\','/')
        if($outputRoot-ieq$resolvedCheckout-or$outputRoot.StartsWith($resolvedCheckout+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)){throw 'ADMISSION_REFUSED: output is inside a checkout.'}
    }
    if($expectedRoots.Count-ne4-or$authorization.configurations-isnot[Array]-or$authorization.configurations.Count-ne4){throw 'ADMISSION_REFUSED: exact four configuration subjects required.'}
    $seen=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach($configuration in $authorization.configurations) {
        Assert-AdmissionFields $configuration 'root,sha256'
        if($configuration.root-isnot[string]-or![IO.Path]::IsPathFullyQualified($configuration.root)-or
           $configuration.root-cnotin$expectedRoots-or!$seen.Add($configuration.root)-or
           $configuration.sha256-cnotmatch'^[0-9A-F]{64}$'){throw 'ADMISSION_REFUSED: configuration identity invalid.'}
        $configPath=(Read-AdmissionGit $configuration.root @('rev-parse','--path-format=absolute','--git-path','config')|Out-String).Trim()
        if((Get-FileHash -LiteralPath $configPath -Algorithm SHA256).Hash-cne$configuration.sha256){throw 'ADMISSION_REFUSED: reviewed local configuration changed.'}
    }
    [pscustomobject]@{ApprovalSha256=$actualApproval;WorkbenchHead=$authorization.workbenchHead;DescriptorSha256=$descriptorDigest;
        IntendedOperation=$Operation;AuthenticatedOwner='UNVERIFIED';AuthenticatedGitHubActor='UNVERIFIED';
        Boundary='Explicit local operator assertion; equal-OS-privilege mutation and credential isolation are outside this interlock. Native gates and interactive owner confirmation remain mandatory.'}
}
