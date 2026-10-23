# Workbench's own local admission checker. Product authority is never evaluated here.
[CmdletBinding()]
param([ValidateSet('Boot','Gate','Range')][string]$Mode='Boot',
      [string]$Root=(Split-Path $PSScriptRoot -Parent),[string]$Base='HEAD',
      [string]$Head='HEAD',[switch]$Staged,[string]$ExpectedEvaluatorSha256)
$ErrorActionPreference='Stop'
try{[Console]::OutputEncoding=[Text.UTF8Encoding]::new($false)}catch{}
function Invoke-WorkbenchGit([string]$Checkout,[string[]]$Arguments) {
    $lines=@(& git -C $Checkout -c core.quotepath=false @Arguments 2>$null)
    if($LASTEXITCODE-ne0){throw 'WB_GIT_UNREADABLE'}
    $lines
}
function Get-WorkbenchDigest([string]$value) {
    [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($value)))
}
function Assert-WorkbenchExternalPath([string]$path) {
    if(![IO.Path]::IsPathFullyQualified($path)){throw 'WB_CONTEXT_PATH_NOT_ABSOLUTE'}
    $full=[IO.Path]::GetFullPath($path)
    $cursor=Get-Item -LiteralPath $full -Force -ErrorAction SilentlyContinue
    $probe=$full
    while($probe){
        $cursor=Get-Item -LiteralPath $probe -Force -ErrorAction SilentlyContinue
        if($cursor-and($cursor.Attributes-band[IO.FileAttributes]::ReparsePoint)){throw 'WB_CONTEXT_REPARSE_REFUSED'}
        $next=Split-Path $probe -Parent
        if(!$next-or$next-eq$probe){break};$probe=$next
    }
    $full
}
function Test-WorkbenchUnder([string]$path,[string]$Parent) {
    $path.StartsWith($Parent.TrimEnd('\','/')+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)
}
function Get-WorkbenchContext($record) {
    if(!$record.Sections.Contains('Execution Context')){return $null}
    $names=@('Original Root','Sandbox Parent','Tests Root','Temp Root','Runtime Root','PowerShell Version','Git Version','Minimum Physical GB','Minimum Commit GB')
    $context=[ordered]@{}
    foreach($line in @($record.Sections['Execution Context']-split'\n'|Where-Object{$_.Trim()})){
        if($line-cnotmatch'^(?<name>[^:]+): (?<value>.+)$'-or$Matches.name-cnotin$names-or$context.Contains($Matches.name)){throw 'WB_EXECUTION_CONTEXT_INVALID'}
        $context[$Matches.name]=$Matches.value
    }
    if($context.Count-ne$names.Count){throw 'WB_EXECUTION_CONTEXT_REQUIRED'}
    foreach($name in 'Original Root','Sandbox Parent','Tests Root','Temp Root','Runtime Root'){$context[$name]=Assert-WorkbenchExternalPath $context[$name]}
    if($context['Original Root']-ieq$context['Sandbox Parent']-or
       (Test-WorkbenchUnder $context['Original Root'] $context['Sandbox Parent'])-or
       (Test-WorkbenchUnder $context['Sandbox Parent'] $context['Original Root'])){throw 'WB_CONTEXT_ORIGINAL_SANDBOX_OVERLAP'}
    $managed=@($context['Tests Root'],$context['Temp Root'],$context['Runtime Root'])
    if(@($managed|Sort-Object -Unique).Count-ne3){throw 'WB_CONTEXT_MANAGED_ROOT_COLLISION'}
    foreach($path in $managed){
        if($path-ieq$context['Original Root']-or(Test-WorkbenchUnder $path $context['Original Root'])-or
           (Test-WorkbenchUnder $context['Original Root'] $path)){throw 'WB_CONTEXT_LOCAL_DATA_ORIGINAL_OVERLAP'}
        foreach($other in $managed){if($path-ine$other-and(Test-WorkbenchUnder $path $other)){throw 'WB_CONTEXT_MANAGED_ROOT_OVERLAP'}}
    }
    $rangeProbe=Join-Path $context['Tests Root'] ('orvion-wb-governance-'+('a'*32)+'/range-counterexample/'+('a'*40)+'..'+('b'*40))
    if($rangeProbe.Length-ge260){throw 'WB_CONTEXT_FIXTURE_PATH_TOO_LONG'}
    if($context['PowerShell Version']-cnotmatch'^[0-9]+\.[0-9]+\.[0-9]+$'-or$context['Git Version']-cnotmatch'^git version [0-9][A-Za-z0-9.()-]+$'){throw 'WB_CONTEXT_VERSION_INVALID'}
    foreach($name in 'Minimum Physical GB','Minimum Commit GB'){
        $number=0.0
        if(![double]::TryParse($context[$name],[Globalization.NumberStyles]::AllowDecimalPoint,[Globalization.CultureInfo]::InvariantCulture,[ref]$number)-or$number-le0){throw 'WB_CONTEXT_RESOURCE_INVALID'}
    }
    $context
}
function Get-WorkbenchExecutionRole([string]$Checkout,$context) {
    if([IO.Path]::GetFullPath($Checkout)-ieq$context['Original Root']){return 'ORIGINAL'}
    if(!(Test-WorkbenchUnder ([IO.Path]::GetFullPath($Checkout)) $context['Sandbox Parent'])){throw 'WB_CONTEXT_EXECUTION_ROOT_UNDECLARED'}
    $null=Assert-WorkbenchRoot $Checkout
    $push=@(Invoke-WorkbenchGit $Checkout @('remote','get-url','--push','origin'))
    if($push.Count-ne1-or$push[0]-cne'DISABLED'){throw 'WB_CONTEXT_SANDBOX_PUSH_NOT_DISABLED'}
    'SANDBOX'
}
function Assert-WorkbenchContextRuntime([string]$Checkout,$context,[switch]$ResourceCheck) {
    $role=Get-WorkbenchExecutionRole $Checkout $context
    foreach($name in 'Tests Root','Temp Root','Runtime Root'){
        if($context[$name]-ieq$Checkout-or(Test-WorkbenchUnder $context[$name] $Checkout)-or
           (Test-WorkbenchUnder $Checkout $context[$name])){throw 'WB_CONTEXT_LOCAL_DATA_CHECKOUT_OVERLAP'}
    }
    if($PSVersionTable.PSVersion.ToString()-cne$context['PowerShell Version']-or
       @(Invoke-WorkbenchGit $Checkout @('--version'))[0]-cne$context['Git Version']){throw 'WB_CONTEXT_EXECUTABLE_VERSION_MISMATCH'}
    foreach($name in 'GIT_DIR','GIT_WORK_TREE','GIT_COMMON_DIR','GIT_INDEX_FILE','GIT_OBJECT_DIRECTORY','GIT_ALTERNATE_OBJECT_DIRECTORIES','GIT_CONFIG_COUNT','GIT_CONFIG_PARAMETERS'){
        if([Environment]::GetEnvironmentVariable($name,'Process')){throw ('WB_CONTEXT_GIT_ENVIRONMENT_REFUSED:'+$name)}
    }
    foreach($binding in @(@('WORKBENCH_TEST_ROOT','Tests Root'),@('WORKBENCH_TEMP_ROOT','Temp Root'))){
        $value=[Environment]::GetEnvironmentVariable($binding[0],'Process')
        if($value-and[IO.Path]::GetFullPath($value)-ine$context[$binding[1]]){throw ('WB_CONTEXT_ENVIRONMENT_MISMATCH:'+$binding[0])}
    }
    if($env:WORKBENCH_TEST_EVIDENCE-and!(Test-WorkbenchUnder (Assert-WorkbenchExternalPath $env:WORKBENCH_TEST_EVIDENCE) $context['Runtime Root'])){throw 'WB_CONTEXT_EVIDENCE_ROOT_MISMATCH'}
    if($ResourceCheck){
        $memory=Get-CimInstance Win32_OperatingSystem -Property FreePhysicalMemory,FreeVirtualMemory -ErrorAction Stop
        if(!$memory-or$null-eq$memory.FreePhysicalMemory-or$null-eq$memory.FreeVirtualMemory){throw 'WB_CONTEXT_RESOURCES_UNREADABLE'}
        $physical=[double]$memory.FreePhysicalMemory/1MB;$commit=[double]$memory.FreeVirtualMemory/1MB
        if($physical-lt[double]::Parse($context['Minimum Physical GB'],[Globalization.CultureInfo]::InvariantCulture)-or
           $commit-lt[double]::Parse($context['Minimum Commit GB'],[Globalization.CultureInfo]::InvariantCulture)){throw 'WB_CONTEXT_RESOURCE_BUDGET_UNAVAILABLE'}
    }
    $role
}
function Get-WorkbenchRecipe([string]$Checkout,[string]$tree,$record) {
    $context=Get-WorkbenchContext $record
    if(!$context){return $null}
    $files=@(Invoke-WorkbenchGit $Checkout @('ls-tree','-r','--name-only',$tree))
    $tests=@($files|Where-Object{$_-cmatch'^lib/test-[^/]+\.(?i:ps1)$'}|Sort-Object -CaseSensitive)
    $hazards=@($files|Where-Object{$_-match'\.ps1$'-and$_-notmatch'^(sessions|events|work|\.git)/'}|Sort-Object -CaseSensitive)
    if(!$tests.Count-or$files-cnotcontains'tests.ps1'){throw 'WB_RECIPE_TEST_SCHEDULE_MISSING'}
    $inputs=@(foreach($path in @('tests.ps1','lib/Workbench.ps1','lib/run_timed.ps1','lib/Events.ps1','lib/Hunt.ps1')+$hazards|Select-Object -Unique){
        [ordered]@{Path=$path;Blob=@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${tree}:$path"))[0]}
    })
    $material=[ordered]@{schema=1;context=$context;command='pwsh -NoProfile -File ${CHECKOUT}/tests.ps1';tests=$tests;hazards=$hazards;inputs=$inputs;tools=@('Events -Find contract-id','Hunt -Quick -NoRecord');maxHeavyRuns=1}
    [pscustomobject]@{Digest=(Get-WorkbenchDigest ($material|ConvertTo-Json -Depth 8 -Compress));Material=$material;Context=$context}
}
function Enter-WorkbenchHeavyOperation($context) {
    [void][IO.Directory]::CreateDirectory($context['Temp Root'])
    $lock=Assert-WorkbenchExternalPath (Join-Path $context['Temp Root'] 'finish-heavy.lock')
    try{[IO.File]::Open($lock,[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)}catch{throw 'WB_CONTEXT_HEAVY_OPERATION_IN_PROGRESS'}
}
function Assert-WorkbenchSandboxProof([string]$Checkout,$record,$context,$recipe,[switch]$Implementation) {
    if((Get-WorkbenchExecutionRole $Checkout $context)-cne'ORIGINAL'){return $null}
    $values=@{}
    foreach($field in 'Sandbox Receipt','Sandbox Receipt SHA256'){
        $found=@([regex]::Matches($record.Sections['Execution Log'],'(?m)^'+$field+': (?<value>[^\n]+)$'))
        if($found.Count-ne1){throw 'WB_SANDBOX_PROOF_REQUIRED'}
        $values[$field]=$found[0].Groups['value'].Value
    }
    Assert-WorkbenchArtifact $values['Sandbox Receipt'] $values['Sandbox Receipt SHA256']
    $proofText=[IO.File]::ReadAllText($values['Sandbox Receipt'])
    $proof=ConvertFrom-WorkbenchReceipt $proofText
    $approval=Get-WorkbenchApprovalValues $record
    if($proof.schema-ne2-or$proof.role-cne'SANDBOX'-or$proof.draftSHA256-cne$approval['Approved SHA256']-or
       $proof.finishHead-cnotmatch'^[0-9a-f]{40}$'-or$proof.evaluator-cnotmatch'^[0-9a-f]{40}$'-or
       (@($proof.profiles)-join',')-cne(@(Get-WorkbenchProfiles @(Get-WorkbenchScope $record))-join',')-or
       $proof.contract-cnotmatch('^changes/'+[regex]::Escape($record.Id)+'-')-or
       !(Test-WorkbenchUnder ([IO.Path]::GetFullPath($proof.root)) $context['Sandbox Parent'])-or$proof.root-ieq$Checkout){throw 'WB_SANDBOX_PROOF_WRONG_SUBJECT'}
    $log=[IO.File]::ReadAllLines($proof.runLog)
    if(!$log.Count-or$log[0]-cne$proof.runStart-or-not@($log|Where-Object{$_-match'^\[\+[^]]+ min\] END exit=0 '}).Count){throw 'WB_SANDBOX_PROOF_RUN_NOT_SUCCESSFUL'}
    if($Implementation-and($proof.recipe-cne$recipe.Digest-or$proof.fingerprint-cne(Get-WorkbenchFingerprint $Checkout 'HEAD' $proof.contract)-or
       $proof.evaluator-cne@(Invoke-WorkbenchGit $Checkout @('rev-parse','HEAD:lib/Test-WorkbenchChange.ps1'))[0])){throw 'WB_SANDBOX_PROOF_RECIPE_OR_INPUT_MISMATCH'}
    $proof
}
function Assert-WorkbenchRelativePath([string]$Relative) {
    $segments=@($Relative-split'/')
    if(!$Relative-or[IO.Path]::IsPathRooted($Relative)-or$Relative-match'[\\\x00-\x1f<>:"|?*`]'-or
       @($segments|Where-Object{$_-in@('','.','..','.git')-or$_-match'[ .]$|^(?:CON|PRN|AUX|NUL|COM[1-9\u00b9\u00b2\u00b3]|LPT[1-9\u00b9\u00b2\u00b3])(?:\.|$)'}).Count){throw 'WB_RELATIVE_PATH_INVALID'}
}
function Get-WorkbenchLocalPath([string]$Checkout,[string]$Relative) {
    Assert-WorkbenchRelativePath $Relative
    $segments=@($Relative-split'/')
    $cursor=[IO.Path]::GetFullPath($Checkout)
    foreach($segment in @('')+$segments){
        if($segment){$cursor=Join-Path $cursor $segment}
        $item=Get-Item -LiteralPath $cursor -Force -ErrorAction SilentlyContinue
        if($item-and($item.Attributes-band[IO.FileAttributes]::ReparsePoint)){throw 'WB_REPARSE_LOCAL_PATH_REFUSED'}
    }
    $cursor
}
function Assert-WorkbenchRoot([string]$Checkout) {
    $rootItem=Get-Item -LiteralPath $Checkout -Force -ErrorAction Stop
    if($rootItem.Attributes-band[IO.FileAttributes]::ReparsePoint){throw 'WB_REPARSE_ROOT_REFUSED'}
    $resolvedRoot=[IO.Path]::GetFullPath($Checkout)
    $top=@(Invoke-WorkbenchGit $resolvedRoot @('rev-parse','--show-toplevel'))[0]
    if([IO.Path]::GetFullPath($top)-ine$resolvedRoot){throw 'WB_ROOT_MISMATCH'}
    $common=@(Invoke-WorkbenchGit $resolvedRoot @('rev-parse','--path-format=absolute','--git-common-dir'))[0]
    if([IO.Path]::GetFullPath($common)-ine(Join-Path $resolvedRoot '.git')){throw 'WB_SHARED_GIT_REFUSED'}
    if((Get-Item -LiteralPath (Join-Path $resolvedRoot '.git') -Force).Attributes-band[IO.FileAttributes]::ReparsePoint-or
       (Test-Path -LiteralPath (Join-Path $resolvedRoot '.git/objects/info/alternates'))){throw 'WB_SHARED_OBJECT_STORE_REFUSED'}
    $resolvedRoot
}
function Enter-WorkbenchOperation([string]$Checkout) {
    $leasePath=Join-Path $Checkout '.git/workbench-operation.lock'
    $item=Get-Item -LiteralPath $leasePath -Force -ErrorAction SilentlyContinue
    if($item-and($item.Attributes-band[IO.FileAttributes]::ReparsePoint)){throw 'WB_REPARSE_LOCAL_PATH_REFUSED'}
    try{[IO.File]::Open($leasePath,[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)}
    catch{throw 'WB_OPERATION_IN_PROGRESS_OR_UNREADABLE'}
}
function Get-WorkbenchText([string]$Checkout,[string]$tree,[string]$path) {
    (@(Invoke-WorkbenchGit $Checkout @('show',"${tree}:$path"))-join[char]10)+[char]10
}
function Get-WorkbenchFields([string]$Text) {
    $identity=@([regex]::Matches($Text,'(?m)^# Workbench Change Request - (?<id>WS-[0-9]{3})\r?$'))
    if($identity.Count-ne1){throw 'WB_CONTRACT_ID_INVALID'}
    $sections=[ordered]@{}
    $matchesFound=[regex]::Matches(($Text-replace'\r\n',"$([char]10)"),'(?ms)^## (?<name>[^\n]+)\n(?<body>.*?)(?=^## |\z)')
    foreach($matchFound in $matchesFound){
        $name=$matchFound.Groups['name'].Value.Trim()
        if($sections.Contains($name)){throw "WB_DUPLICATE_SECTION:$name"}
        $sections[$name]=$matchFound.Groups['body'].Value.Trim()
    }
    foreach($required in 'Status','Objective','Baseline','Write Scope','Out of Scope','Draft Assurance','Implementation Steps','Acceptance Criteria','Review Gate','Runtime Checkpoint','Execution Log','Verification Notes'){
        if(!$sections.Contains($required)){throw "WB_MISSING_SECTION:$required"}
    }
    $states=@([regex]::Matches($sections.Status,'(?m)^\[x\] (Draft|Approved|In Progress|Complete|Cancelled)$')|ForEach-Object{$_.Groups[1].Value})
    $statusLines=@($sections.Status-split'\n'|Where-Object{$_.Trim()})
    $statusNames=@($statusLines|ForEach-Object{$_-replace'^\[[ x]\] ',''}|Sort-Object -Unique)
    if($states.Count-ne1-or$statusLines.Count-ne5-or$statusNames.Count-ne5-or@($statusLines|Where-Object{$_-cnotmatch'^\[[ x]\] (Draft|Approved|In Progress|Complete|Cancelled)$'}).Count){throw 'WB_STATUS_INVALID'}
    $checkpoint=@{}
    foreach($field in @(@('Resume Step','(?:[1-9][0-9]*|DONE)'),@('Blocker','(?:None|[A-Z][A-Z0-9_-]+)'),@('Recovery Attempt','[0-3]'))){
        $entries=@([regex]::Matches($sections['Runtime Checkpoint'],'(?m)^'+$field[0]+': (?<value>'+$field[1]+')$'))
        if($entries.Count-ne1){throw 'WB_RUNTIME_CHECKPOINT_INVALID'}
        $checkpoint[$field[0]]=$entries[0].Groups['value'].Value
    }
    [pscustomobject]@{Id=$identity[0].Groups['id'].Value;Sections=$sections;Status=$states[0];Checkpoint=$checkpoint}
}
function Get-WorkbenchFrozen($record) {
    $pieces=@('Contract Identity: '+$record.Id)
    foreach($name in $record.Sections.Keys){
        if($name-in@('Status','Runtime Checkpoint','Execution Log','Verification Notes')){continue}
        $body=$record.Sections[$name]
        if($name-in@('Acceptance Criteria','Review Gate')){$body=$body-creplace'(?m)^- \[[ x]\] ','- [ ] '}
        $pieces+=$name+[char]10+$body
    }
    $pieces-join([char]10+[string][char]10)
}
function Set-WorkbenchSection([string]$Text,[string]$SectionName,[string]$ReplacementBody) {
    $pattern='(?ms)^## '+[regex]::Escape($SectionName)+'\r?\n.*?(?=^## |\z)'
    $sectionsFound=@([regex]::Matches($Text,$pattern))
    if($sectionsFound.Count-ne1){throw 'WB_MUTABLE_SECTION_NOT_UNIQUE'}
    $lineBreak=if($Text.Contains(([string][char]13+[char]10))){[string][char]13+[char]10}else{[string][char]10}
    $normalizedBody=$ReplacementBody.Trim()-replace'\r\n',([string][char]10)
    $normalizedBody=$normalizedBody-replace'\n',$lineBreak
    $replacement='## '+$SectionName+$lineBreak+$lineBreak+$normalizedBody+$lineBreak+$lineBreak
    $matchFound=$sectionsFound[0]
    $Text.Remove($matchFound.Index,$matchFound.Length).Insert($matchFound.Index,$replacement)
}
function Get-WorkbenchScope($record) {
    $paths=@($record.Sections['Write Scope']-split'\n'|Where-Object{$_-match'^- '}|ForEach-Object{$_.Substring(2).Trim()})
    if(!$paths.Count-or@($paths|Sort-Object -Unique).Count-ne$paths.Count){throw 'WB_SCOPE_INVALID'}
    foreach($path in $paths){
        Assert-WorkbenchRelativePath $path
        if($path-match'^(sessions|events|work)(/|$)'){throw 'WB_SCOPE_PATH_REFUSED'}
    }
    $paths
}
function Get-WorkbenchProfiles([string[]]$paths) {
    $profiles=@('REPOSITORY')
    if(@($paths|Where-Object{$_-match'(^AGENTS\.md$|^RESUME\.md$|^WORKFLOW\.md$|^changes/|^\.githooks/|^tests\.ps1$|^lib/(Workbench|Test-WorkbenchChange|test-workbench|run_timed|watch_run|apply-draft-steps|Invoke-DraftSteps))'}).Count){$profiles+='CONTROL'}
    if(@($paths|Where-Object{$_-match'^lib/(Owner-|Invoke-Owner|Test-Owner|Coordinator|Watch-|Delegate|Invoke-Contract|lifecycle)'}).Count){$profiles+='COORDINATION'}
    if(@($paths|Where-Object{$_-match'(WORKSTATION|[Dd]octor|[Bb]ootstrap|[Pp]repare)'}).Count){$profiles+='WORKSTATION'}
    if(@($paths|Where-Object{$_-match'^lib/(Backup|Restore)'}).Count){$profiles+='RECOVERY'}
    if(@($paths|Where-Object{$_-match'^\.github/'}).Count){$profiles+='CI'}
    $profiles|Sort-Object -Unique
}
function Get-WorkbenchBlobChecks($record,[string[]]$scope) {
    $checks=@([regex]::Matches($record.Sections['Acceptance Criteria'],'(?m)check: (?<clause>[^\n]+)$'))
    $seen=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach($check in $checks){
        $clause=$check.Groups['clause'].Value.Trim()
        if($clause-cmatch'^blob:(?<path>.+)=(?<sha>[0-9a-f]{40})$'){$kind='blob';$checkPath=$Matches.path;$expectedValue=$Matches.sha}
        elseif($clause-cmatch'^normalized-resume:(?<path>RESUME\.md)=(?<sha>[0-9A-F]{64})$'){$kind='normalized-resume';$checkPath=$Matches.path;$expectedValue=$Matches.sha}
        else{throw 'WB_CHECK_CLAUSE_INVALID_OR_UNSUPPORTED'}
        if($checkPath-cnotin$scope-or!$seen.Add($checkPath)){throw 'WB_BLOB_CHECK_SCOPE_OR_DUPLICATE'}
        [pscustomobject]@{Kind=$kind;Path=$checkPath;Value=$expectedValue}
    }
}
function Get-WorkbenchStepDeclarations($record,[string[]]$scope) {
    # Declaration closure only; the accepted existing applier owns operation interpretation.
    $items=@([regex]::Split($record.Sections['Implementation Steps'],'(?m)^(?=\d+\. )')|Where-Object{$_-match'^\d+\. Check whether '})
    $seen=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach($item in $items){
        $target=[regex]::Match($item,'^\d+\. Check whether `(?<path>[^`]+)` contains `[^`]+`')
        $outputBlob=@([regex]::Matches($item,"(?m)^   The resulting file's Git blob is (?<blob>[0-9a-f]{40})\.$"))
        if(!$target.Success-or$outputBlob.Count-ne1){throw 'WB_LITERAL_STEP_DECLARATION_INVALID'}
        $targetPath=$target.Groups['path'].Value
        if($targetPath-cnotin$scope-or!$seen.Add($targetPath)){throw 'WB_LITERAL_STEP_SCOPE_OR_DUPLICATE'}
        [pscustomobject]@{Path=$targetPath;Kind='blob';Value=$outputBlob[0].Groups['blob'].Value}
    }
}
function Get-WorkbenchApprovalValues($record) {
    $values=@{}
    foreach($field in 'Approved Draft','Approved SHA256','Owner Evidence','Owner Evidence SHA256','Execution Root'){
        $found=@([regex]::Matches($record.Sections['Execution Log'],'(?m)^'+[regex]::Escape($field)+': (?<value>[^\n]+)$'))
        if($found.Count-ne1){throw "WB_APPROVAL_MISSING_OR_DUPLICATED:$field"}
        $values[$field]=$found[0].Groups['value'].Value.Trim()
    }
    $values
}
function Get-WorkbenchResumeDigest([string]$Text) {
    Get-WorkbenchDigest (($Text-replace'\r\n',([string][char]10))-replace'(?m)^Active Workbench Contract: [^\n]+','Active Workbench Contract: NORMALIZED')
}
function Get-WorkbenchPointer([string]$Text,[switch]$AllowMissing) {
    $pointers=@([regex]::Matches($Text,'(?m)^Active Workbench Contract: (?<path>None|changes/WS-[0-9]{3}-[A-Za-z0-9-]+\.md)\r?$'))
    if(!$pointers.Count-and$AllowMissing){return 'None'}
    if($pointers.Count-ne1){throw 'WB_ACTIVE_POINTER_INVALID'}
    $pointers[0].Groups['path'].Value
}
function Assert-WorkbenchArtifact([string]$path,[string]$Digest) {
    if(![IO.Path]::IsPathFullyQualified($path)-or$Digest-cnotmatch'^[0-9A-F]{64}$'){throw 'WB_ARTIFACT_IDENTITY_INVALID'}
    $item=Get-Item -LiteralPath $path -Force -ErrorAction Stop
    if($item.PSIsContainer-or($item.Attributes-band[IO.FileAttributes]::ReparsePoint)-or
       (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash-cne$Digest){throw 'WB_ARTIFACT_CHANGED'}
}
function Assert-WorkbenchApproval($record,[string]$Checkout) {
    $values=Get-WorkbenchApprovalValues $record
    Assert-WorkbenchArtifact $values['Approved Draft'] $values['Approved SHA256']
    Assert-WorkbenchArtifact $values['Owner Evidence'] $values['Owner Evidence SHA256']
    if(![IO.Path]::IsPathFullyQualified($values['Execution Root'])-or
       [IO.Path]::GetFullPath($values['Execution Root'])-ine[IO.Path]::GetFullPath($Checkout)){throw 'WB_APPROVAL_ROOT_MISMATCH'}
    if(![IO.File]::ReadAllText($values['Owner Evidence']).Contains($values['Approved SHA256'],[StringComparison]::Ordinal)){throw 'WB_OWNER_EVIDENCE_SUBJECT_MISMATCH'}
    if(![IO.File]::ReadAllText($values['Owner Evidence']).Contains($values['Execution Root'],[StringComparison]::Ordinal)){throw 'WB_OWNER_EVIDENCE_ROOT_MISMATCH'}
    $draft=Get-WorkbenchFields ([IO.File]::ReadAllText($values['Approved Draft']))
    if($draft.Status-cne'Draft'-or(Get-WorkbenchFrozen $draft)-cne(Get-WorkbenchFrozen $record)){throw 'WB_APPROVED_AUTHORITY_CHANGED'}
    $identities=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    $paths=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach($version in 1..3){
        $assurance=@([regex]::Matches($record.Sections['Draft Assurance'],'(?m)^V'+$version+': (?<id>[^|\n]+) \| (?<date>[0-9]{4}-[0-9]{2}-[0-9]{2}) \| (?<path>[^|\n]+) \| (?<hash>[0-9A-F]{64}|SELECTED)$'))
        if($assurance.Count-ne1){throw 'WB_THREE_PASS_MISSING_OR_DUPLICATED'}
        $entry=$assurance[0].Groups
        $dateValue=[DateTime]::MinValue
        if(![DateTime]::TryParseExact($entry['date'].Value,'yyyy-MM-dd',[Globalization.CultureInfo]::InvariantCulture,[Globalization.DateTimeStyles]::None,[ref]$dateValue)-or$dateValue.Date-gt[DateTime]::UtcNow.Date){throw 'WB_ASSURANCE_DATE_INVALID'}
        if(!$identities.Add($entry['id'].Value.Trim())-or!$paths.Add($entry['path'].Value.Trim())){throw 'WB_THREE_PASS_IDENTITY_DUPLICATED'}
        if($version-eq3){
            if($entry['hash'].Value-cne'SELECTED'-or$entry['path'].Value.Trim()-cne$values['Approved Draft']){throw 'WB_SELECTED_DRAFT_MISMATCH'}
        }else{Assert-WorkbenchArtifact $entry['path'].Value.Trim() $entry['hash'].Value}
    }
    if($record.Sections['Draft Assurance']-notmatch'(?m)^Selected Version: V3$'){throw 'WB_SELECTED_VERSION_INVALID'}
}
function Get-WorkbenchFingerprint([string]$Checkout,[string]$tree,[string]$contract) {
    $rows=@(Invoke-WorkbenchGit $Checkout @('ls-tree','-r',$tree))
    $inputs=@()
    foreach($row in $rows){
        if($row-notmatch'^(?<mode>[0-9]+) blob (?<blob>[0-9a-f]{40})\t(?<path>.+)$'){throw 'WB_UNSUPPORTED_TREE_ENTRY'}
        $modeValue=$Matches.mode;$blobValue=$Matches.blob;$pathValue=$Matches.path
        if($modeValue-cnotin@('100644','100755')){throw 'WB_NONREGULAR_TREE_ENTRY_REFUSED'}
        if($pathValue-eq$contract){$blobValue=Get-WorkbenchDigest (Get-WorkbenchFrozen (Get-WorkbenchFields (Get-WorkbenchText $Checkout $tree $pathValue)))}
        elseif($pathValue-eq'RESUME.md'){$blobValue=Get-WorkbenchResumeDigest (Get-WorkbenchText $Checkout $tree $pathValue)}
        $inputs+="$modeValue $blobValue $pathValue"
    }
    Get-WorkbenchDigest ($inputs-join[char]10)
}
function Read-WorkbenchReceipt([string]$Checkout,[string]$Digest) {
    $receiptPath=if($Digest){Get-WorkbenchLocalPath $Checkout ".workbench-certifications/$Digest.json"}else{Get-WorkbenchLocalPath $Checkout '.workbench-local-certification.json'}
    if(!(Test-Path -LiteralPath $receiptPath -PathType Leaf)){throw 'WB_RECEIPT_MISSING'}
    $receiptText=[IO.File]::ReadAllText($receiptPath)
    ConvertFrom-WorkbenchReceipt $receiptText
}
function ConvertFrom-WorkbenchReceipt([string]$receiptText) {
    $json=[System.Text.Json.JsonDocument]::Parse($receiptText)
    try{
        $names=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
        foreach($property in $json.RootElement.EnumerateObject()){if(!$names.Add($property.Name)){throw 'WB_RECEIPT_DUPLICATE_MEMBER'}}
        if($json.RootElement.GetProperty('schema').ValueKind-ne[System.Text.Json.JsonValueKind]::Number-or
           $json.RootElement.GetProperty('schema').GetInt32()-notin@(1,2)){throw 'WB_RECEIPT_SCHEMA_INVALID'}
        $schema=$json.RootElement.GetProperty('schema').GetInt32()
        $expectedNames=if($schema-eq1){'contract,digest,evaluator,fingerprint,finishHead,profiles,result,root,runLog,runStart,schema'}else{'contract,digest,draftSHA256,evaluator,fingerprint,finishHead,profiles,proof,recipe,result,role,root,runLog,runStart,schema'}
        if((@($names|Sort-Object)-join',')-cne$expectedNames){throw 'WB_RECEIPT_FIELDS_INVALID'}
    }finally{$json.Dispose()}
    $value=$receiptText|ConvertFrom-Json -ErrorAction Stop
    if($value.schema-notin@(1,2)-or$value.result-cne'READY'){throw 'WB_RECEIPT_INVALID'}
    $expected=$value.digest
    $material=[ordered]@{schema=$value.schema;root=$value.root;contract=$value.contract;finishHead=$value.finishHead;fingerprint=$value.fingerprint;profiles=@($value.profiles);evaluator=$value.evaluator;runLog=$value.runLog;runStart=$value.runStart;result=$value.result}
    if($value.schema-eq2){
        if($value.draftSHA256-cnotmatch'^[0-9A-F]{64}$'-or$value.recipe-cnotmatch'^[0-9A-F]{64}$'-or$value.role-cnotin@('SANDBOX','ORIGINAL')-or
           ($value.proof-and$value.proof-cnotmatch'^[0-9A-F]{64}$')){throw 'WB_RECEIPT_CONTEXT_FIELDS_INVALID'}
        $material['draftSHA256']=$value.draftSHA256;$material['recipe']=$value.recipe;$material['role']=$value.role;$material['proof']=$value.proof
    }
    if((Get-WorkbenchDigest ($material|ConvertTo-Json -Compress -Depth 5))-cne$expected){throw 'WB_RECEIPT_DIGEST_INVALID'}
    $value
}
function Assert-WorkbenchCompletion([string]$Checkout,[string]$tree,[string]$contract,$record,[string[]]$profiles,[switch]$Historical) {
    foreach($section in 'Acceptance Criteria','Review Gate'){
        if($record.Sections[$section]-match'(?m)^- \[ \] '-or$record.Sections[$section]-notmatch'(?m)^- \[x\] '){throw 'WB_COMPLETION_CRITERIA_OPEN'}
    }
    if($record.Sections['Verification Notes']-notmatch'(?m)^Verdict: Confirmed Complete$'-or
       $record.Sections['Runtime Checkpoint']-notmatch'(?m)^Resume Step: DONE$'-or
       $record.Sections['Runtime Checkpoint']-notmatch'(?m)^Blocker: None$'){throw 'WB_LIVE_REVIEW_MISSING'}
    $fingerprint=Get-WorkbenchFingerprint $Checkout $tree $contract
    $reviewed=@([regex]::Matches($record.Sections['Verification Notes'],'(?m)^Reviewed Receipt: (?<digest>[0-9A-F]{64})$'))
    if(!$reviewed.Count){throw 'WB_REVIEW_RECEIPT_MISSING'}
    $reviewDigest=$reviewed[-1].Groups['digest'].Value
    $receipt=Read-WorkbenchReceipt $Checkout $reviewDigest
    $context=Get-WorkbenchContext $record
    if($context){
        $recipe=Get-WorkbenchRecipe $Checkout $tree $record
        $approval=Get-WorkbenchApprovalValues $record
        if($receipt.schema-ne2-or$receipt.recipe-cne$recipe.Digest-or$receipt.draftSHA256-cne$approval['Approved SHA256']-or
           $receipt.role-cne(Get-WorkbenchExecutionRole $Checkout $context)){throw 'WB_RECEIPT_CONTEXT_MISMATCH'}
        $sandbox=Assert-WorkbenchSandboxProof $Checkout $record $context $recipe
        if($receipt.role-ceq'ORIGINAL'-and$receipt.proof-cne$sandbox.digest){throw 'WB_RECEIPT_SANDBOX_PROOF_MISMATCH'}
    }
    if(!$Historical){$working=Read-WorkbenchReceipt $Checkout;if($working.digest-cne$reviewDigest){throw 'WB_WORKING_RECEIPT_NOT_REVIEWED'}}
    $evaluator=@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${tree}:lib/Test-WorkbenchChange.ps1"))[0]
    if([IO.Path]::GetFullPath($receipt.root)-ine[IO.Path]::GetFullPath($Checkout)-or
       $receipt.finishHead-cnotmatch'^[0-9a-f]{40}$'-or
       $receipt.contract-cne$contract-or$receipt.fingerprint-cne(Get-WorkbenchFingerprint $Checkout $tree $contract)-or
       $receipt.evaluator-cne$evaluator-or(@($receipt.profiles)-join',')-cne($profiles-join',')){throw 'WB_RECEIPT_STALE_OR_WRONG_SUBJECT'}
    if($record.Sections['Verification Notes']-notmatch('(?m)^Reviewed Fingerprint: '+[regex]::Escape($fingerprint)+'$')){throw 'WB_REVIEW_SUBJECT_MISSING'}
    $log=[IO.File]::ReadAllLines($receipt.runLog)
    if(!$log.Count-or$log[0]-cne$receipt.runStart-or-not@($log|Where-Object{$_-match'^\[\+[^]]+ min\] END exit=0 '}).Count){throw 'WB_TIMED_RUN_NOT_SUCCESSFUL'}
}
function Test-WorkbenchTree([string]$Checkout,[string]$Before,[string]$After,[switch]$RequireWorkingMatch,[switch]$Historical) {
    $paths=@(Invoke-WorkbenchGit $Checkout @('diff','--name-only','--no-renames',$Before,$After))
    $beforeFiles=@(Invoke-WorkbenchGit $Checkout @('ls-tree','-r','--name-only',$Before))
    $afterFiles=@(Invoke-WorkbenchGit $Checkout @('ls-tree','-r','--name-only',$After))
    $caseNames=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach($path in $afterFiles){if(!$caseNames.Add($path)){throw 'WB_CASE_COLLISION_TREE'}}
    foreach($path in $afterFiles){if($path-match'^(sessions|events|work)(/|$)'-or$path-match'^\.workbench-'){throw 'WB_LOCAL_DATA_REFUSED'}}
    # Bounded known credential shapes, based on the existing watcher's redaction vocabulary.
    # This is not a complete secret detector; values are never printed.
    foreach($path in $paths|Where-Object{$afterFiles-ccontains$_}){
        $content=Get-WorkbenchText $Checkout $After $path
        if($content-match'\b(gh[pousr]_[A-Za-z0-9]{20,}|github_pat_\w{20,}|sk-[A-Za-z0-9_-]{20,})|-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----'){throw "WB_CREDENTIAL_SHAPED_CONTENT_REFUSED:$path"}
    }
    $pointer=Get-WorkbenchPointer (Get-WorkbenchText $Checkout $After 'RESUME.md') -AllowMissing:($afterFiles-cnotcontains'WORKFLOW.md')
    $priorPointer=if($beforeFiles-contains'WORKFLOW.md'){Get-WorkbenchPointer (Get-WorkbenchText $Checkout $Before 'RESUME.md')}else{'None'}
    $contract=if($pointer-ne'None'){$pointer}elseif($priorPointer-ne'None'){$priorPointer}else{@($paths|Where-Object{$_-cmatch'^changes/WS-[0-9]{3}-[A-Za-z0-9-]+\.md$'})}
    if(@($contract).Count-ne1-or!$contract){if(!$paths.Count){return $null};throw 'WB_GOVERNING_CONTRACT_MISSING_OR_AMBIGUOUS'}
    if($afterFiles-cnotcontains$contract){throw 'WB_CONTRACT_MISSING'}
    $record=Get-WorkbenchFields (Get-WorkbenchText $Checkout $After $contract)
    if($contract-cnotmatch('^changes/'+[regex]::Escape($record.Id)+'-[A-Za-z0-9-]+\.md$')){throw 'WB_CONTRACT_PATH_ID_MISMATCH'}
    $scope=@(Get-WorkbenchScope $record)
    $blobChecks=@(Get-WorkbenchBlobChecks $record $scope)
    $stepDeclarations=@(Get-WorkbenchStepDeclarations $record $scope)
    if(@($stepDeclarations|Where-Object{$_.Path-ceq'RESUME.md'}).Count-and
       @($blobChecks|Where-Object{$_.Kind-ceq'normalized-resume'}).Count-ne1){throw 'WB_RESUME_NORMALIZATION_CHECK_REQUIRED'}
    foreach($pin in $blobChecks|Where-Object{$_.Kind-ceq'blob'}){
        $declared=@($stepDeclarations|Where-Object{$_.Path-ceq$pin.Path})
        if($declared.Count-and$declared[0].Value-cne$pin.Value){throw 'WB_CONTRADICTORY_BLOB_PREDICATE'}
    }
    $profiles=@(Get-WorkbenchProfiles $scope)
    if($record.Status-in@('Approved','In Progress')-and('CI'-in$profiles-or'WORKSTATION'-in$profiles)){throw 'WB_PROFILE_CAPABILITY_NOT_YET_IMPLEMENTED'}
    $baseline=$record.Sections['Baseline'].Trim()
    if($baseline-cnotmatch'^[0-9a-f]{40}$'){throw 'WB_BASELINE_INVALID'}
    & git -C $Checkout merge-base --is-ancestor $baseline $Before 2>$null
    if($LASTEXITCODE-ne0){throw 'WB_BASELINE_NOT_ANCESTOR'}
    $oldRecord=$null
    $initialImport=$false
    if($beforeFiles-ccontains$contract){$oldRecord=Get-WorkbenchFields (Get-WorkbenchText $Checkout $Before $contract)}
    $context=Get-WorkbenchContext $record
    $contextRequired=$beforeFiles-ccontains'lib/Test-WorkbenchChange.ps1'-and
        (Get-WorkbenchText $Checkout $Before 'lib/Test-WorkbenchChange.ps1').Contains('WB_EXECUTION_CONTEXT_REQUIRED',[StringComparison]::Ordinal)
    if(!$oldRecord-and$contextRequired-and!$context){throw 'WB_EXECUTION_CONTEXT_REQUIRED'}
    if($context){
        $null=Get-WorkbenchExecutionRole $Checkout $context
        if($record.Status-in@('Approved','In Progress','Complete')){$null=Assert-WorkbenchSandboxProof $Checkout $record $context $null}
    }
    if($oldRecord){
        $legal=@{Draft=@('Draft','Approved','Cancelled');Approved=@('Approved','In Progress','Cancelled');'In Progress'=@('In Progress','Complete','Cancelled');Complete=@('Complete');Cancelled=@('Cancelled')}
        if($record.Status-cnotin$legal[$oldRecord.Status]){throw 'WB_ILLEGAL_TRANSITION'}
        if($oldRecord.Status-ne'Draft'-and(Get-WorkbenchFrozen $oldRecord)-cne(Get-WorkbenchFrozen $record)){throw 'WB_FROZEN_AUTHORITY_CHANGED'}
        foreach($appendOnly in 'Execution Log','Verification Notes'){
            if(!$record.Sections[$appendOnly].StartsWith($oldRecord.Sections[$appendOnly],[StringComparison]::Ordinal)){throw 'WB_EVIDENCE_HISTORY_REWRITTEN'}
        }
        if($oldRecord.Status-in@('Complete','Cancelled')-and(Get-WorkbenchText $Checkout $Before $contract)-cne(Get-WorkbenchText $Checkout $After $contract)){throw 'WB_TERMINAL_CONTRACT_IMMUTABLE'}
    }elseif($record.Status-ne'Draft'){
        # One initial import: exact externally approved Draft, before any kernel implementation.
        # Existing installations never gain a second allocation route.
        $initialImport=$record.Status-ceq'Approved'-and$beforeFiles-cnotcontains'WORKFLOW.md'-and
            $beforeFiles-cnotcontains'lib/Test-WorkbenchChange.ps1'-and$afterFiles-cnotcontains'WORKFLOW.md'-and
            $afterFiles-cnotcontains'lib/Test-WorkbenchChange.ps1'-and
            !@($paths|Where-Object{$_-cnotin@($contract,'RESUME.md')}).Count
        if(!$initialImport){throw 'WB_ALLOCATION_MUST_BE_DRAFT'}
    }
    if($record.Status-in@('Approved','In Progress','Complete')){Assert-WorkbenchApproval $record $Checkout}
    foreach($path in $paths){
        if($path-ceq$contract){continue}
        if($path-cnotin$scope){throw "WB_WRITE_SCOPE_REFUSED:$path"}
        if($record.Status-eq'Draft'){throw 'WB_DRAFT_IMPLEMENTATION_REFUSED'}
        if($record.Status-in@('Complete','Cancelled')){
            if($path-cne'RESUME.md'){throw 'WB_TERMINAL_IMPLEMENTATION_REFUSED'}
            $oldResume=(Get-WorkbenchText $Checkout $Before 'RESUME.md')-replace'(?m)^Active Workbench Contract: [^\n]+','Active Workbench Contract: NORMALIZED'
            $newResume=(Get-WorkbenchText $Checkout $After 'RESUME.md')-replace'(?m)^Active Workbench Contract: [^\n]+','Active Workbench Contract: NORMALIZED'
            if($oldResume-cne$newResume){throw 'WB_TERMINAL_ROUTER_EDIT_REFUSED'}
        }
        if($path-ceq'RESUME.md'-and$initialImport){
            $oldResume=Get-WorkbenchText $Checkout $Before 'RESUME.md'
            $newResume=(Get-WorkbenchText $Checkout $After 'RESUME.md')-replace'(?m)^Active Workbench Contract: [^\n]+\n?',''
            if($oldResume.TrimEnd([char]10,[char]13)-cne$newResume.TrimEnd([char]10,[char]13)){throw 'WB_INITIAL_IMPORT_IMPLEMENTATION_REFUSED'}
        }
        $declaredOutput=@($stepDeclarations|Where-Object{$_.Path-ceq$path})
        if($declaredOutput.Count-and$path-cne'RESUME.md'){
            if($afterFiles-cnotcontains$path-or@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${After}:$path"))[0]-cne$declaredOutput[0].Value){throw 'WB_DECLARED_OUTPUT_MISMATCH'}
        }
        if($declaredOutput.Count-and$path-ceq'RESUME.md'-and!$initialImport){
            $oldRoute=Get-WorkbenchResumeDigest (Get-WorkbenchText $Checkout $Before 'RESUME.md')
            $newRoute=Get-WorkbenchResumeDigest (Get-WorkbenchText $Checkout $After 'RESUME.md')
            if($oldRoute-cne$newRoute-and@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${After}:$path"))[0]-cne$declaredOutput[0].Value){throw 'WB_DECLARED_ROUTING_OUTPUT_MISMATCH'}
        }
        if($path-match'\.ps1$|^\.githooks/'){
            $pin=@($blobChecks|Where-Object{$_.Path-ceq$path})
            if(!$pin.Count){$pin=$declaredOutput}
            if($pin.Count-ne1-or$afterFiles-cnotcontains$path){throw 'WB_CONTROL_PIN_REQUIRED'}
            $actualControl=@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${After}:$path"))[0]
            if($pin[0].Kind-cne'blob'-or$actualControl-cne$pin[0].Value){throw 'WB_UNAPPROVED_CONTROL_BYTES'}
        }
        if($path-cmatch'^changes/WS-' -and $path-cne$contract){throw 'WB_UNRELATED_CONTRACT_REFUSED'}
    }
    if($record.Status-in@('Draft','Complete','Cancelled')-and$pointer-ne'None'){throw 'WB_ACTIVE_STATUS_CONTRADICTION'}
    if($record.Status-in@('Approved','In Progress')-and$pointer-cne$contract){throw 'WB_ACTIVE_CONTRACT_MISMATCH'}
    if($RequireWorkingMatch){
        if(@(Invoke-WorkbenchGit $Checkout @('diff','--name-only','--no-renames')).Count-or
           @(Invoke-WorkbenchGit $Checkout @('ls-files','--others','--exclude-standard')).Count){throw 'WB_WORKING_INDEX_MISMATCH'}
        foreach($path in $paths){
            if($afterFiles-ccontains$path){
                $workingPath=Get-WorkbenchLocalPath $Checkout $path
                if(!(Test-Path -LiteralPath $workingPath -PathType Leaf)){throw 'WB_WORKING_INDEX_MISMATCH'}
                $workingBlob=@(Invoke-WorkbenchGit $Checkout @('hash-object',"--path=$path",'--',$workingPath))[0]
                $treeBlob=@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${After}:$path"))[0]
                if($workingBlob-cne$treeBlob){throw 'WB_WORKING_INDEX_MISMATCH'}
            }
        }
    }
    if($record.Status-eq'Complete'){
        foreach($declaredOutput in $stepDeclarations|Where-Object{$_.Path-cne'RESUME.md'}){
            if($afterFiles-cnotcontains$declaredOutput.Path-or@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${After}:$($declaredOutput.Path)"))[0]-cne$declaredOutput.Value){throw 'WB_COMPLETION_DECLARED_OUTPUT_MISMATCH'}
        }
        foreach($pin in $blobChecks){
            if($afterFiles-cnotcontains$pin.Path){throw 'WB_COMPLETION_BLOB_MISMATCH'}
            $actualPin=if($pin.Kind-ceq'blob'){@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${After}:$($pin.Path)"))[0]}else{Get-WorkbenchResumeDigest (Get-WorkbenchText $Checkout $After $pin.Path)}
            if($actualPin-cne$pin.Value){throw 'WB_COMPLETION_BLOB_MISMATCH'}
        }
        Assert-WorkbenchCompletion $Checkout $After $contract $record $profiles -Historical:$Historical
    }
    [pscustomobject]@{Contract=$contract;Status=$record.Status;Profiles=$profiles;Scope=$scope;Fingerprint=(Get-WorkbenchFingerprint $Checkout $After $contract)}
}
if($MyInvocation.InvocationName-eq'.'){return}
$operationLease=$null
try {
    if($ExpectedEvaluatorSha256-and(Get-FileHash -LiteralPath $PSCommandPath).Hash-cne$ExpectedEvaluatorSha256){throw 'WB_BOOTSTRAP_EVALUATOR_CHANGED'}
    $Root=Assert-WorkbenchRoot $Root
    if($Mode-eq'Gate'-and$Staged){$operationLease=Enter-WorkbenchOperation $Root}
    if($Mode-eq'Boot'){
        $pointer=Get-WorkbenchPointer ([IO.File]::ReadAllText((Join-Path $Root 'RESUME.md')))
        $dirty=@(Invoke-WorkbenchGit $Root @('status','--porcelain','--untracked-files=all'))
        if($dirty.Count){throw 'WB_WORKING_TREE_DIRTY'}
        if($pointer-eq'None'){$bootLines=@('MODE: PLAN','ACTION: Read RESUME.md for the current task; prepare an isolated Draft and obtain its exact Gate 1 before original writes','START_CONTEXT: WORKFLOW.md, RESUME.md','WRITE: none (isolated preparation only)')}else{
            $active=Get-WorkbenchFields ([IO.File]::ReadAllText((Join-Path $Root $pointer)))
            if($pointer-cnotmatch('^changes/'+[regex]::Escape($active.Id)+'-[A-Za-z0-9-]+\.md$')){throw 'WB_CONTRACT_PATH_ID_MISMATCH'}
            if($active.Status-cnotin@('Approved','In Progress')){throw 'WB_ACTIVE_STATUS_CONTRADICTION'}
            Assert-WorkbenchApproval $active $Root
            if($active.Checkpoint.Blocker-cne'None'){throw ('WB_RUNTIME_BLOCKER:'+$active.Checkpoint.Blocker)}
            $nextAction=if($active.Status-ceq'Approved'){'Record In Progress under the approved contract, then execute its literal steps'}elseif($active.Checkpoint['Resume Step']-ceq'DONE'){'Use the existing run/receipt evidence; perform only the missing Finish, live Review or Complete stage'}else{'Execute implementation step '+$active.Checkpoint['Resume Step']+' through the scope-checked entry'}
            $bootLines=@("STATUS: $($active.Status)","STEP: $($active.Checkpoint['Resume Step'])","BLOCKER: None","ACTION: $nextAction","START_CONTEXT: WORKFLOW.md, $pointer","WRITE: $((Get-WorkbenchScope $active)-join', ')","PROFILES: $((Get-WorkbenchProfiles @(Get-WorkbenchScope $active))-join', ')")
        }
        'WORKBENCH: READY';"ACTIVE_CONTRACT: $pointer";$bootLines
    }elseif($Mode-eq'Range'){
        if($Base-cnotmatch'^[0-9a-f]{40}$'-or$Head-cnotmatch'^[0-9a-f]{40}$'){throw 'WB_FULL_RANGE_SHA_REQUIRED'}
        & git -C $Root merge-base --is-ancestor $Base $Head 2>$null;if($LASTEXITCODE){throw 'WB_RANGE_DIVERGED'}
        foreach($commit in @(Invoke-WorkbenchGit $Root @('rev-list','--reverse',"$Base..$Head",'--'))){
            $parents=@(@(Invoke-WorkbenchGit $Root @('rev-list','--parents','-n','1',$commit))[0]-split' ')
            if($parents.Count-ne2){throw 'WB_MERGE_RANGE_REFUSED'}
            $null=Test-WorkbenchTree $Root $parents[1] $commit -Historical
        }
        'WORKBENCH: READY';'EVIDENCE: every range transition checked'
    }else{
        $tree=if($Staged){@(Invoke-WorkbenchGit $Root @('write-tree'))[0]}else{@(Invoke-WorkbenchGit $Root @('rev-parse',"$Head^{tree}"))[0]}
        $result=Test-WorkbenchTree $Root $Base $tree -RequireWorkingMatch:$Staged
        'WORKBENCH: READY'
        if($result){"CONTRACT: $($result.Contract)";"STATUS: $($result.Status)";"PROFILES: $($result.Profiles-join', ')"}
    }
    exit 0
}catch{ 'WORKBENCH: BLOCKED';"CODE: $($_.Exception.Message)";exit 1 }
finally{if($operationLease){$operationLease.Dispose()}}
