# The one lifecycle controller of a Workbench contract: a small per-workstream manifest replaces the copied Prepare-*,
# Stage-*, Run-*Finish, Review-*Finish and Complete-* scripts. Native Workbench.ps1 and the hash-pinned accepted evaluator
# keep every authority; this only transports. Stages run in order, Sandbox then Original, each started by the agent:
# prepare, allocate, approve, implement, finish, inspect, review, complete. dryrun walks a finished workstream and writes nothing.
[CmdletBinding()]
param([Parameter(Mandatory)][string]$Manifest,
      [Parameter(Mandatory)][ValidateSet('Sandbox','Original')][string]$Role,
      [Parameter(Mandatory)][ValidateSet('prepare','allocate','approve','implement','finish','inspect','review','complete','dryrun')][string]$Stage)
$ErrorActionPreference='Stop'
function Get-Json([string]$Path){Get-Content -LiteralPath $Path -Raw|ConvertFrom-Json}
$m=Get-Json $Manifest
foreach($field in 'Workstream','Packet','Draft','DraftSHA256','Baseline','Contract','Judge','JudgeSHA256','JudgeSource','Original','OriginalRemote','Sandbox','RuntimeRoot','HostExe','HostSHA256','HostVersion','Actionlint','RealData','MinPhysicalGB','MinCommitGB','ProtectedRoots','Closures','Approval','OriginalApprovalTemplate','Authority','Outputs','AllocateLabel','ImplementLog','Evidence','ReviewText','ReviewsLabel','KnownExtraCommits'){
    if($null-eq$m.$field){throw "LIFECYCLE_MANIFEST_FIELD_MISSING:$field"}
}
$isOriginal=$Role-ceq'Original'
$executionRoot=if($isOriginal){$m.Original}else{$m.Sandbox}
$runtime=Join-Path $m.RuntimeRoot $Role.ToLowerInvariant()
$contractPath=Join-Path $executionRoot $m.Contract;$approval=$m.Approval.$Role;$hostExe=$m.HostExe
$authorityFlag=$isOriginal;$tag=$m.Workstream.Replace('-','')
$beforePath=if($isOriginal){Join-Path $runtime 'before.json'}else{Join-Path $m.Packet 'baseline.json'}
$bindingPath=Join-Path $m.Packet 'original-approval-binding.json'
$sandboxResultPath=Join-Path (Join-Path $m.RuntimeRoot 'sandbox') 'result.json'
$labels=[ordered]@{allocate=$m.AllocateLabel;approve='exact delegated root-bound Approval';begin='Begin through accepted native admission';implement='exact scoped implementation';review='live criterion review of own fresh receipt';complete='Complete with own native receipt'}
function Get-Subject([string]$Name){"$($m.Workstream): $Role $($labels[$Name])"}
if((Get-FileHash -LiteralPath $hostExe).Hash-cne$m.HostSHA256){throw 'LIFECYCLE_HOST_CHANGED'}
if((Get-FileHash -LiteralPath $m.Draft).Hash-cne$m.DraftSHA256){throw 'LIFECYCLE_DRAFT_CHANGED'}
if($Stage-ceq'prepare'-and!$isOriginal){
    # The accepted evaluator is materialized here, once, from the trusted copy; only then is it dot-sourced.
    if(Test-Path -LiteralPath $beforePath){throw 'LIFECYCLE_ALREADY_PREPARED'}
    if(!(Test-Path -LiteralPath $approval)){throw 'LIFECYCLE_APPROVAL_REQUIRED'}
    foreach($source in $m.JudgeSource,(Join-Path $m.Original 'lib/Test-WorkbenchChange.ps1')){if((Get-FileHash -LiteralPath $source).Hash-cne$m.JudgeSHA256){throw 'LIFECYCLE_JUDGE_CHANGED'}}
    if(!(Test-Path -LiteralPath $m.Judge)){[void][IO.Directory]::CreateDirectory((Split-Path $m.Judge -Parent));[IO.File]::Copy($m.JudgeSource,$m.Judge,$false)}
}
if($Stage-cnotin@('prepare','dryrun')){
    if(!(Test-Path -LiteralPath $beforePath)){throw 'LIFECYCLE_NOT_PREPARED'}
    if(!(Test-Path -LiteralPath $approval)){throw 'LIFECYCLE_APPROVAL_REQUIRED'}
    $approvalText=[IO.File]::ReadAllText($approval)
    if(!$approvalText.Contains($m.DraftSHA256)-or!$approvalText.Contains($executionRoot)){throw 'LIFECYCLE_APPROVAL_SUBJECT_MISMATCH'}
}
if((Get-FileHash -LiteralPath $m.Judge).Hash-cne$m.JudgeSHA256){throw 'LIFECYCLE_JUDGE_CHANGED'}
. $m.Judge -Root $executionRoot
$frozenRecord=Get-WorkbenchFields ([IO.File]::ReadAllText($m.Draft));$context=Get-WorkbenchContext $frozenRecord
if([IO.Path]::GetFullPath($m.Sandbox)-ine[IO.Path]::GetFullPath((Join-Path $context['Sandbox Parent'] 's'))-or[IO.Path]::GetFullPath($m.RuntimeRoot)-ine$context['Runtime Root']-or[IO.Path]::GetFullPath($m.Original)-ine$context['Original Root']){throw 'LIFECYCLE_CONTEXT_MISMATCH'}
$env:PATH=(Split-Path $hostExe -Parent)+';'+$env:PATH
$env:WORKBENCH_TEMP_ROOT=$context['Temp Root'];$env:WORKBENCH_TEST_ROOT=$context['Tests Root'];$env:TEMP=$context['Temp Root'];$env:TMP=$env:TEMP
$env:ORVION_DATA_ROOT=Join-Path $runtime 'data'
if($Stage-cne'dryrun'){foreach($dir in $runtime,$env:TEMP,$env:WORKBENCH_TEST_ROOT,$env:ORVION_DATA_ROOT){[void][IO.Directory]::CreateDirectory($dir)}}

# Standard output only: a CRLF warning on stderr must never read as the blob a caller takes from the first line.
function Invoke-RootGit([string[]]$Arguments){$lines=@(& git --no-optional-locks -C $executionRoot -c core.quotepath=false @Arguments 2>&1);if($LASTEXITCODE){throw "LIFECYCLE_GIT_FAILED:$($Arguments-join' '):$($lines-join' ')"};$lines|Where-Object{$_-isnot[Management.Automation.ErrorRecord]}|ForEach-Object{"$_"}}
function Get-RootHead{@(Invoke-RootGit @('rev-parse','HEAD'))[0]}
function Assert-CleanRoot{
    $null=Assert-WorkbenchRoot $executionRoot
    if(@(Invoke-RootGit @('status','--porcelain','--untracked-files=all')).Count){throw 'LIFECYCLE_ROOT_DIRTY'}
    $bound=if($isOriginal){@(Invoke-RootGit @('remote','get-url','origin'))[0]-cmatch$m.OriginalRemote}else{@(Invoke-RootGit @('remote','get-url','--push','origin'))[0]-ceq'DISABLED'}
    if(!$bound-or@(Invoke-RootGit @('config','--get','core.hooksPath'))[0]-cne'.githooks'){throw 'LIFECYCLE_HOOK_OR_REMOTE_BINDING_CHANGED'}
}
function Write-RootText([string]$Path,[string]$Text){[IO.File]::WriteAllText($Path,$Text,[Text.UTF8Encoding]::new($false))}
function Write-Evidence([string]$Name,$Value){$Value|ConvertTo-Json -Depth 9|Set-Content -LiteralPath (Join-Path $runtime $Name)}
function Save-RootCommit([string[]]$Paths,[string]$Name,[string]$LogName){
    $(
        $null=Invoke-RootGit (@('add','--')+$Paths)
        & $hostExe -NoProfile -File $m.Judge -ExpectedEvaluatorSha256 $m.JudgeSHA256 -Root $executionRoot -Mode Gate -Staged -Base HEAD
        if($LASTEXITCODE){throw 'LIFECYCLE_STAGE_ADMISSION_REFUSED'}
        Invoke-RootGit @('commit','--quiet','-m',(Get-Subject $Name))
    )|Set-Content -LiteralPath (Join-Path $runtime $LogName)
    Assert-CleanRoot
}
function Invoke-Native([string]$Verb,[string]$Code){& $hostExe -NoProfile -File (Join-Path $executionRoot 'lib\Workbench.ps1') -Root $executionRoot "-$Verb";if($LASTEXITCODE){throw $Code}}
function Expand-Template([string]$Text,[hashtable]$Values){
    foreach($key in $Values.Keys){$Text=$Text.Replace('{{'+$key+'}}',[string]$Values[$key])}
    if($Text-match'\{\{\w+\}\}'){throw 'LIFECYCLE_TEMPLATE_UNFILLED'}
    $Text
}
function Set-ContractStatus([string]$Text,$Record,[string]$From,[string]$To){Set-WorkbenchSection $Text 'Status' ($Record.Sections.Status.Replace("[x] $From","[ ] $From").Replace("[ ] $To","[x] $To"))}
function Get-ApprovedText([string]$Text){
    $record=Get-WorkbenchFields $Text
    $Text=Set-ContractStatus $Text $record 'Draft' 'Approved'
    $lines=@("Approved Draft: $($m.Draft)","Approved SHA256: $($m.DraftSHA256)","Owner Evidence: $approval","Owner Evidence SHA256: $((Get-FileHash -LiteralPath $approval).Hash)","Execution Root: $executionRoot")
    if($isOriginal){$proofFile=(Get-Json $bindingPath).Proof;$lines+=@("Sandbox Receipt: $proofFile","Sandbox Receipt SHA256: $((Get-FileHash -LiteralPath $proofFile).Hash)")}
    Set-WorkbenchSection $Text 'Execution Log' ($record.Sections['Execution Log']+"`n"+($lines-join"`n"))
}
function Get-BegunText([string]$Text){Set-ContractStatus $Text (Get-WorkbenchFields $Text) 'Approved' 'In Progress'}
function Get-ImplementedText([string]$Text){
    $record=Get-WorkbenchFields $Text
    $Text=Set-WorkbenchSection $Text 'Runtime Checkpoint' ($record.Sections['Runtime Checkpoint'].Replace('Resume Step: 1','Resume Step: DONE'))
    Set-WorkbenchSection $Text 'Execution Log' ($record.Sections['Execution Log']+"`n"+$m.ImplementLog.$Role)
}
function Get-ReviewedText([string]$Text,$Receipt,$Observed){
    $record=Get-WorkbenchFields $Text;$words=$m.ReviewText.$Role
    foreach($section in 'Acceptance Criteria','Review Gate'){$Text=Set-WorkbenchSection $Text $section ($record.Sections[$section]-creplace'(?m)^- \[ \] ','- [x] ')}
    $Text=Set-WorkbenchSection $Text 'Execution Log' ($record.Sections['Execution Log']+"`n"+$words.ResidualLog)
    $detail=Expand-Template $words.Notes @{Suites=$Observed.OrderedSuites;Receipt=$Receipt.digest;Proof=$Receipt.proof}
    Set-WorkbenchSection $Text 'Verification Notes' ($record.Sections['Verification Notes']+"`n"+(@('Verdict: Confirmed Complete',('Reviewed Fingerprint: '+$Receipt.fingerprint),('Reviewed Receipt: '+$Receipt.digest),$detail)-join"`n"))
}
function Get-MappedReview($Record,[switch]$AllowBlankDisposition){
    $rows=Get-Json $m.ReviewText.$Role.Rows
    foreach($pair in @(@('Acceptance Criteria','criteria'),@('Review Gate','review_gates'))){
        $found=@([regex]::Matches($Record.Sections[$pair[0]],'(?m)^- \[[ x]\] (.+)$'))
        $given=@($rows.($pair[1]))
        if($found.Count-ne$given.Count){throw 'LIFECYCLE_CRITERIA_COUNT_DIFFERS'}
        for($i=0;$i-lt$found.Count;$i++){if($given[$i].text-cne$found[$i].Groups[1].Value.Trim()-or!$given[$i].evidence-or(!$given[$i].disposition-and!$AllowBlankDisposition)){throw 'LIFECYCLE_CRITERION_EVIDENCE_MISSING'}}
    }
    $rows
}
function Assert-ReviewEvidence{
    $review=Get-Json $m.Evidence.Review;$qualified=Get-Json $m.Evidence.Qualification;$proof=Get-Json $m.Evidence.DraftCheck
    $decisions=[IO.File]::ReadAllText($m.Evidence.Decisions)
    if($review.Verdict-cne'ACCEPT'-or$review.MaterialFindings-ne0-or!$review.Subject.Contains($m.DraftSHA256)-or$qualified.DraftSHA256-cne$m.DraftSHA256-or$proof.draftSHA256-cne$m.DraftSHA256-or$proof.replay.secondExit-ne0){throw 'LIFECYCLE_REVIEW_EVIDENCE_INVALID'}
    foreach($id in $m.Evidence.DecisionIds){if(!$decisions.Contains("## $id ")){throw "LIFECYCLE_DECISION_MISSING:$id"}}
}
function Assert-QualifiedDraft{
    $qualified=Get-Json $m.Evidence.Qualification;$proof=Get-Json $m.Evidence.DraftCheck
    if($qualified.Verdict-cne'PASS_EXACT_SELECTED_DRAFT_PRECHECKS'-or$qualified.DraftSHA256-cne$m.DraftSHA256-or$proof.draftSHA256-cne$m.DraftSHA256){throw 'LIFECYCLE_DRAFT_NOT_QUALIFIED'}
    $declared=@($proof.steps|ForEach-Object{$_.path+' '+$_.blob});$given=@($m.Outputs|ForEach-Object{$_.Path+' '+$_.Blob})
    if(@(Compare-Object $declared $given).Count){throw 'LIFECYCLE_OUTPUTS_DIFFER_FROM_DRAFT'}
}
function Assert-Closures{
    $total=0
    foreach($closure in $m.Closures){
        if((Get-FileHash -LiteralPath $closure.Manifest).Hash-cne$closure.SHA256){throw 'LIFECYCLE_CLOSURE_MANIFEST_CHANGED'}
        foreach($file in @(Get-Json $closure.Manifest)){
            $path=Join-Path $closure.Root $file.path
            if(!(Test-Path -LiteralPath $path -PathType Leaf)-or(Get-Item -LiteralPath $path).Length-ne$file.bytes-or(Get-FileHash -LiteralPath $path).Hash-cne$file.sha256){throw 'LIFECYCLE_CLOSURE_EVIDENCE_CHANGED'}
            $total++
        }
    }
    $total
}
function Get-ProtectedSources{
    @(foreach($rootPath in $m.ProtectedRoots){
        $observedHead=@(& git --no-optional-locks -C $rootPath rev-parse HEAD)
        if($LASTEXITCODE-or$observedHead.Count-ne1-or$observedHead[0]-cnotmatch'^[0-9a-f]{40}$'){throw 'LIFECYCLE_PROTECTED_HEAD_UNREADABLE'}
        $dirty=@(& git --no-optional-locks -C $rootPath status --porcelain --untracked-files=all);if($LASTEXITCODE-or$dirty.Count){throw "LIFECYCLE_PROTECTED_ROOT_DIRTY:$rootPath"}
        $observedRefs=@(& git --no-optional-locks -C $rootPath for-each-ref --format='%(objectname) %(refname)');if($LASTEXITCODE){throw 'LIFECYCLE_PROTECTED_REFS_UNREADABLE'}
        $tracked=@{};$paths=@(& git --no-optional-locks -C $rootPath -c core.quotepath=false ls-files);if($LASTEXITCODE){throw 'LIFECYCLE_PROTECTED_INVENTORY_UNREADABLE'}
        foreach($path in $paths){$file=Join-Path $rootPath $path;$item=Get-Item -LiteralPath $file -Force;if($item.Attributes-band[IO.FileAttributes]::ReparsePoint){throw 'LIFECYCLE_PROTECTED_REPARSE_PATH'};$tracked[$path]=(Get-FileHash -LiteralPath $file).Hash}
        $local=@{};foreach($path in '.git/config','.git/index','.git/HEAD','.git/packed-refs','.workbench-local-certification.json','.orvion-local-certification.json'){$file=Join-Path $rootPath $path;$local[$path]=if(Test-Path -LiteralPath $file -PathType Leaf){(Get-FileHash -LiteralPath $file).Hash}else{'ABSENT'}}
        foreach($dir in '.workbench-certifications','.orvion-certifications'){if(Test-Path -LiteralPath (Join-Path $rootPath $dir)){foreach($file in Get-ChildItem -LiteralPath (Join-Path $rootPath $dir) -File){$local[$dir+'/'+$file.Name]=(Get-FileHash -LiteralPath $file.FullName).Hash}}}
        $afterHead=@(& git --no-optional-locks -C $rootPath rev-parse HEAD);if($LASTEXITCODE-or$afterHead.Count-ne1-or$afterHead[0]-cne$observedHead[0]){throw 'LIFECYCLE_PROTECTED_HEAD_MOVED_DURING_CAPTURE'}
        [ordered]@{root=$rootPath;head=$observedHead[0];refs=($observedRefs-join"`n");tracked=$tracked;local=$local}
    })
}
# Only the admitted root may differ, and only by its scoped paths, its index, its new receipt and its own HEAD.
function Assert-ProtectedUnchanged($Before,[string]$ScopedHead,[string[]]$ScopedPaths){
    $actual=@(Get-ProtectedSources)
    if(@($Before.sources).Count-ne@($m.ProtectedRoots).Count){throw 'LIFECYCLE_PROTECTED_ROOT_COUNT_CHANGED'}
    foreach($source in $Before.sources){
        $now=@($actual|Where-Object{$_.root-ceq$source.root})
        if($now.Count-ne1){throw 'LIFECYCLE_PROTECTED_ROOT_MISSING'}
        $scoped=$ScopedHead-and$source.root-ceq$executionRoot
        $expectedRefs=$source.refs
        if($scoped){
            if($now[0].head-cne$ScopedHead){throw 'LIFECYCLE_RECEIPT_HEAD_MISMATCH'}
            $expectedRefs=$source.refs.Replace(($m.Baseline+' refs/heads/main'),($ScopedHead+' refs/heads/main'))
        }elseif($now[0].head-cne$source.head){throw 'LIFECYCLE_PROTECTED_HEAD_CHANGED'}
        $refChanges=@(Compare-Object @($expectedRefs-split"`n"|Where-Object{$_}) @($now[0].refs-split"`n"|Where-Object{$_}))
        if(@($refChanges|Where-Object{$_.InputObject-cnotmatch'^[0-9a-f]{40} refs/codex/turn-diffs/(captures|checkpoints)/'}).Count){throw 'LIFECYCLE_PROTECTED_REFS_CHANGED'}
        foreach($property in $source.tracked.PSObject.Properties){
            if($scoped-and$property.Name-cin$ScopedPaths){continue}
            if($now[0].tracked[$property.Name]-cne$property.Value){throw 'LIFECYCLE_PROTECTED_TRACKED_CHANGED'}
        }
        foreach($property in $source.local.PSObject.Properties){
            if($scoped-and$property.Name-cin@('.git/index','.workbench-local-certification.json')){continue}
            if($now[0].local[$property.Name]-cne$property.Value){throw 'LIFECYCLE_PROTECTED_LOCAL_CHANGED'}
        }
    }
    @($actual).Count
}
function Assert-SandboxBinding{
    $binding=Get-Json $bindingPath;$qualified=Get-Json $sandboxResultPath
    if($binding.Root-cne$executionRoot-or$binding.DraftSHA256-cne$m.DraftSHA256-or$binding.ApprovalSHA256-cne(Get-FileHash -LiteralPath $approval).Hash-or$binding.ProofSHA256-cne(Get-FileHash -LiteralPath $binding.Proof).Hash-or$qualified.Status-cne'Complete'-or$qualified.IndependentWholeRange-cne'READY'-or$qualified.ReceiptExportSHA256-cne$binding.ProofSHA256){throw 'LIFECYCLE_SANDBOX_BINDING_CHANGED'}
}
function Get-OriginalPrediction([string]$Tree,$Record){
    $recipe=Get-WorkbenchRecipe $executionRoot $Tree $Record
    foreach($row in $recipe.Material.inputs){$replacement=@($m.Outputs|Where-Object Path -CEQ $row.Path);if($replacement.Count-eq1){$row.Blob=$replacement[0].Blob}}
    $predictedRecipe=Get-WorkbenchDigest ($recipe.Material|ConvertTo-Json -Depth 8 -Compress)
    $rows=[Collections.Generic.SortedDictionary[string,string]]::new([StringComparer]::Ordinal)
    foreach($row in @(Invoke-RootGit @('ls-tree','-r',$Tree))){
        if($row-cnotmatch'^(?<mode>[0-9]+) blob (?<blob>[0-9a-f]{40})\t(?<path>.+)$'){throw 'LIFECYCLE_UNSUPPORTED_TREE_ENTRY'}
        $pathValue=$Matches.path;$modeValue=$Matches.mode;$blobValue=$Matches.blob
        $replacement=@($m.Outputs|Where-Object Path -CEQ $pathValue);if($replacement.Count-eq1){$blobValue=$replacement[0].Blob}
        if($pathValue-ceq'RESUME.md'){$blobValue=Get-WorkbenchResumeDigest (Get-WorkbenchText $executionRoot $Tree $pathValue)}
        $rows[$pathValue]="$modeValue $blobValue $pathValue"
    }
    foreach($output in $m.Outputs){if(!$rows.ContainsKey($output.Path)){$rows[$output.Path]='100644 '+$output.Blob+' '+$output.Path}}
    $rows[$m.Contract]='100644 '+(Get-WorkbenchDigest (Get-WorkbenchFrozen $Record))+' '+$m.Contract
    @{Recipe=$predictedRecipe;Fingerprint=(Get-WorkbenchDigest (@($rows.Values)-join[char]10))}
}
function Get-OriginalApprovalText($Qualified,$Proof,[string]$ProofPath){
    Expand-Template $m.OriginalApprovalTemplate @{Draft=$m.Draft;DraftSHA256=$m.DraftSHA256;Root=$executionRoot;Baseline=$m.Baseline;Sandbox=$m.Sandbox;SandboxHead=$Qualified.Head;Receipt=$Proof.digest;Proof=$ProofPath;ProofSHA256=$Qualified.ReceiptExportSHA256;Fingerprint=$Proof.fingerprint;Recipe=$Proof.recipe;Evaluator=$Proof.evaluator}
}
function Get-FinishCommand{"& pwsh -NoProfile -File '$executionRoot\lib\Workbench.ps1' -Root '$executionRoot' -Finish -Actionlint '$($m.Actionlint)'"}
# What a Finish left behind, proved at the tree it ran on; -Live adds what only the untouched root can still show.
function Assert-FinishEvidence($Receipt,[string]$Tree,[switch]$Live){
    $run=Get-Json (Join-Path $runtime 'run-result.json')
    foreach($name in 'runner','watcher','host'){if($run.Exits.$name-ne0-or[IO.File]::ReadAllText((Join-Path $runtime "finish-$name.exit")).Trim()-cne'0'){throw 'LIFECYCLE_FINISH_CHILD_FAILED'}}
    if(!$run.RealJournalUnchanged-or$run.Root-cne$executionRoot-or$run.DraftSHA256-cne$m.DraftSHA256){throw 'LIFECYCLE_RUN_SUBJECT_MISMATCH'}
    $record=Get-WorkbenchFields (Get-WorkbenchText $executionRoot $Tree $m.Contract)
    if($record.Status-cne'In Progress'-or$record.Checkpoint['Resume Step']-cne'DONE'){throw 'LIFECYCLE_NOT_DONE_IN_PROGRESS'}
    $recipe=Get-WorkbenchRecipe $executionRoot $Tree $record;$priorRecipe=Get-WorkbenchRecipe $executionRoot $m.Baseline $record
    if(($recipe.Material.tests-join'|')-cne($priorRecipe.Material.tests-join'|')-or($recipe.Material.hazards-join'|')-cne($priorRecipe.Material.hazards-join'|')){throw 'LIFECYCLE_SCHEDULE_CHANGED'}
    if($Receipt.schema-ne2-or$Receipt.role-cne$Role.ToUpperInvariant()-or$Receipt.root-cne$executionRoot-or$Receipt.draftSHA256-cne$m.DraftSHA256-or$Receipt.recipe-cne$recipe.Digest-or$Receipt.fingerprint-cne(Get-WorkbenchFingerprint $executionRoot $Tree $m.Contract)-or$Receipt.evaluator-cne@(Invoke-WorkbenchGit $executionRoot @('rev-parse',"${Tree}:lib/Test-WorkbenchChange.ps1"))[0]){throw 'LIFECYCLE_RECEIPT_SUBJECT_MISMATCH'}
    # RESUME.md is the pointer; dedupe keeps exact set equality.
    $allowed=@(@('RESUME.md',$m.Contract)+@($m.Outputs.Path)|Sort-Object -Unique)
    if(@(Compare-Object $allowed @(Invoke-WorkbenchGit $executionRoot @('diff','--name-only',$m.Baseline,$Tree))).Count){throw 'LIFECYCLE_CARRYING_SCOPE_DIFFERS'}
    foreach($output in $m.Outputs){if(@(Invoke-RootGit @('rev-parse',"${Tree}:$($output.Path)"))[0]-cne$output.Blob){throw 'LIFECYCLE_COMMITTED_OUTPUT_DIFFERS'}}
    $log=[IO.File]::ReadAllText($Receipt.runLog);$watcherLog=[IO.File]::ReadAllText((Join-Path $runtime 'finish-watcher.log'))
    if([IO.File]::ReadAllLines($Receipt.runLog)[0]-cne$Receipt.runStart-or$log-notmatch'END exit=0 '-or$watcherLog-notmatch'END exit=0'-or[regex]::Matches($log,'TESTS: all passed in ').Count-ne1-or$log-notmatch'(?m)^\[\+[^]]+\] PASS the real journal is untouched by the checks\r?$'){throw 'LIFECYCLE_FINISH_LOG_NOT_SUCCESS'}
    $last=-1;foreach($test in $recipe.Material.tests){$found=[regex]::Matches($log,'(?m)^\[\+[^]]+\] PASS '+[regex]::Escape([IO.Path]::GetFileName($test))+'\r?$');if($found.Count-ne1-or$found[0].Index-le$last){throw 'LIFECYCLE_ORDERED_TEST_MISSING'};$last=$found[0].Index}
    if($Live){
        if((Get-FileHash -LiteralPath (Join-Path $executionRoot 'lib\Test-WorkbenchChange.ps1')).Hash-cne$m.JudgeSHA256){throw 'LIFECYCLE_ROOT_EVALUATOR_CHANGED'}
        if(@(Invoke-RootGit @('status','--porcelain','--untracked-files=all')).Count){throw 'LIFECYCLE_ROOT_DIRTY'}
        foreach($output in $m.Outputs){if(@(Invoke-RootGit @('hash-object',('--path='+$output.Path),'--',(Join-Path $executionRoot $output.Path)))[0]-cne$output.Blob){throw 'LIFECYCLE_LIVE_OUTPUT_DIFFERS'}}
        $launch=Get-Json (Join-Path $runtime 'launch-resources.json')
        if((Get-FileHash -LiteralPath $launch.RealJournal).Hash-cne$launch.JournalBeforeSHA256){throw 'LIFECYCLE_REAL_JOURNAL_CHANGED'}
    }
    $recipe
}
function Invoke-DryRun{
    $sameText={param($a,$b)(($a-replace"`r`n","`n").TrimEnd())-ceq(($b-replace"`r`n","`n").TrimEnd())}
    $result=Get-Json (Join-Path $runtime 'result.json')
    if($result.Status-cne'Complete'-or$result.Role-cne$Role.ToUpperInvariant()-or$result.DraftSHA256-cne$m.DraftSHA256-or$result.Root-cne$executionRoot-or$result.IndependentWholeRange-cne'READY'){throw 'LIFECYCLE_DRYRUN_RESULT_MISMATCH'}
    Assert-QualifiedDraft;Assert-ReviewEvidence;$closureFiles=Assert-Closures
    # The commit chain must be the planned one, in order; anything extra must be a recorded earlier attempt.
    $chain=@(Invoke-RootGit @('log','--reverse','--format=%H %s',"$($m.Baseline)..$($result.Head)")|ForEach-Object{$pair=$_-split' ',2;[pscustomobject]@{Id=$pair[0];Subject=$pair[1]}})
    $known=@($m.KnownExtraCommits.$Role);$commits=[ordered]@{};$extras=@();$cursor=0;$planned=@($labels.Keys)
    foreach($commit in $chain){
        if($cursor-lt$planned.Count-and$commit.Subject-ceq(Get-Subject $planned[$cursor])){$commits[$planned[$cursor]]=$commit.Id;$cursor++}
        elseif($commit.Subject-cin$known){$extras+=$commit}
        else{throw "LIFECYCLE_DRYRUN_UNPLANNED_COMMIT:$($commit.Subject)"}
    }
    if($cursor-ne$planned.Count){throw "LIFECYCLE_DRYRUN_PLANNED_COMMIT_MISSING:$($planned[$cursor])"}
    # Each commit: its exact paths and the status the stage must leave.
    $outputs=@($m.Outputs.Path)
    $stagePlan=[ordered]@{allocate=@('Draft',@($m.Contract));approve=@('Approved',@($m.Contract,'RESUME.md'));begin=@('In Progress',@($m.Contract));implement=@('In Progress',(@($m.Contract)+$outputs));review=@('In Progress',@($m.Contract));complete=@('Complete',@($m.Contract,'RESUME.md'))}
    foreach($name in $stagePlan.Keys){
        $record=Get-WorkbenchFields (Get-WorkbenchText $executionRoot $commits[$name] $m.Contract)
        if($record.Status-cne$stagePlan[$name][0]){throw "LIFECYCLE_DRYRUN_STATUS_DIFFERS:$name"}
        $paths=@(Invoke-RootGit @('diff-tree','--no-commit-id','--name-only','-r',$commits[$name]))
        if(@(Compare-Object $paths @($stagePlan[$name][1])).Count){throw "LIFECYCLE_DRYRUN_PATHS_DIFFER:$name"}
    }
    if(@(Invoke-RootGit @('rev-parse',"$($commits.allocate):$($m.Contract)"))[0]-cne@(Invoke-RootGit @('hash-object',('--path='+$m.Contract),'--',$m.Draft))[0]){throw 'LIFECYCLE_DRYRUN_ALLOCATED_BLOB_DIFFERS'}
    # The stages' own text transforms must reproduce what the workstream committed.
    $allocated=Get-WorkbenchText $executionRoot $commits.allocate $m.Contract
    $approvedText=Get-WorkbenchText $executionRoot $commits.approve $m.Contract
    $begunText=Get-WorkbenchText $executionRoot $commits.begin $m.Contract
    $implementedText=Get-WorkbenchText $executionRoot $commits.implement $m.Contract
    if(!(& $sameText (Get-ApprovedText $allocated) $approvedText)){throw 'LIFECYCLE_DRYRUN_APPROVE_TEXT_DIFFERS'}
    $pointerText=(Get-WorkbenchText $executionRoot $m.Baseline 'RESUME.md').Replace('Active Workbench Contract: None',('Active Workbench Contract: '+$m.Contract))
    if(!(& $sameText $pointerText (Get-WorkbenchText $executionRoot $commits.approve 'RESUME.md'))){throw 'LIFECYCLE_DRYRUN_POINTER_DIFFERS'}
    if(!(& $sameText (Get-BegunText $approvedText) $begunText)){throw 'LIFECYCLE_DRYRUN_BEGIN_TEXT_DIFFERS'}
    if(!(& $sameText (Get-ImplementedText $begunText) $implementedText)){throw 'LIFECYCLE_DRYRUN_IMPLEMENT_TEXT_DIFFERS'}
    # Finish: the same evidence check inspect makes, at the tree the receipt names, and the planned command lines.
    $observed=Get-Json (Join-Path $runtime 'independent-finish-review.json')
    if((Get-FileHash -LiteralPath $observed.ReceiptExport).Hash-cne$observed.ReceiptExportSHA256){throw 'LIFECYCLE_DRYRUN_RECEIPT_EXPORT_CHANGED'}
    $receipt=ConvertFrom-WorkbenchReceipt ([IO.File]::ReadAllText($observed.ReceiptExport))
    if($receipt.finishHead-cne$commits.implement-or$observed.OwnReceipt-cne$receipt.digest){throw 'LIFECYCLE_DRYRUN_RECEIPT_COMMIT_DIFFERS'}
    $recipe=Assert-FinishEvidence $receipt $commits.implement
    $operation=Get-Json (Join-Path $runtime 'operation.json');$started=@($operation.Identities|ForEach-Object CommandLine)
    if(!$started[0].Contains((Get-FinishCommand))-or!$started[1].Contains("$tag-$($Role.ToLowerInvariant())-finish")){throw 'LIFECYCLE_DRYRUN_FINISH_COMMAND_DIFFERS'}
    # Review: the mapped rows, the ticks, and with no earlier attempt the whole text.
    $rows=Get-MappedReview (Get-WorkbenchFields $implementedText) -AllowBlankDisposition;$blank=@(@($rows.criteria)+@($rows.review_gates)|Where-Object{!$_.disposition}).Count
    $reviewedText=Get-ReviewedText $implementedText $receipt $observed
    $lastBeforeComplete=if($extras.Count){$extras[-1].Id}else{$commits.review}
    $committedRecord=Get-WorkbenchFields (Get-WorkbenchText $executionRoot $lastBeforeComplete $m.Contract);$plannedRecord=Get-WorkbenchFields $reviewedText
    foreach($section in 'Acceptance Criteria','Review Gate'){if($plannedRecord.Sections[$section]-cne$committedRecord.Sections[$section]){throw 'LIFECYCLE_DRYRUN_TICKS_DIFFER'}}
    if(!$extras.Count-and!(& $sameText $reviewedText (Get-WorkbenchText $executionRoot $commits.review $m.Contract))){throw 'LIFECYCLE_DRYRUN_REVIEW_TEXT_DIFFERS'}
    $reproduced=@('allocate','approve','pointer','begin','implement');$reproduced+=if($extras.Count){'review-ticks'}else{'review'}
    # Original admission: the approval and the predictions must reproduce from the sandbox's result.
    if($isOriginal){
        Assert-SandboxBinding
        $qualified=Get-Json $sandboxResultPath;$proofPath=$qualified.ReceiptExport;$proof=ConvertFrom-WorkbenchReceipt ([IO.File]::ReadAllText($proofPath))
        if(!(& $sameText (Get-OriginalApprovalText $qualified $proof $proofPath) ([IO.File]::ReadAllText($approval)))){throw 'LIFECYCLE_DRYRUN_APPROVAL_TEXT_DIFFERS'}
        $prediction=Get-OriginalPrediction $m.Baseline $frozenRecord;$binding=Get-Json $bindingPath
        if($prediction.Recipe-cne$binding.PredictedRecipe-or$prediction.Fingerprint-cne$binding.PredictedFingerprint-or$prediction.Recipe-cne$proof.recipe-or$prediction.Fingerprint-cne$proof.fingerprint){throw 'LIFECYCLE_DRYRUN_PREDICTION_DIFFERS'}
        $reproduced+=@('original-approval','prediction')
    }
    $names=@('allocation.json','allocation-commit.log','approval.json','approval-commit.log','begin-commit.log','implementation.json','implementation-commit.log','launch-resources.json','operation.json','finish.log','finish-runner.log','finish-runner.exit','finish-watcher.log','finish-watcher.exit','finish-host.log','finish-host.exit','run-result.json','implementation-range.log','own-finish-receipt.json','independent-finish-review.json','criterion-review.json','review-commit.log','complete-commit.log','complete-range.log','result.json')
    if($isOriginal){$names+=@('before.json','literal-plan.json','preflight.json')}
    foreach($name in $names){if(!(Test-Path -LiteralPath (Join-Path $runtime $name) -PathType Leaf)){throw "LIFECYCLE_DRYRUN_EVIDENCE_MISSING:$name"}}
    [ordered]@{Verdict='LIFECYCLE_DRYRUN_PASS';Role=$Role;Workstream=$m.Workstream;Commits=$commits;Extras=@($extras|ForEach-Object Subject);Reproduced=$reproduced;Suites=$recipe.Material.tests.Count;BlankDispositions=$blank;ClosureFiles=$closureFiles;EvidenceFiles=$names.Count;NotReplayable='Live protected-root compare, native stages and Finish: only a live run can show them'}|ConvertTo-Json -Depth 5
}

if($Stage-ceq'dryrun'){Invoke-DryRun;return}
if($isOriginal-and$Stage-cne'prepare'){
    Assert-SandboxBinding
    if($Stage-ceq'allocate'){$preflight=Get-Json (Join-Path $runtime 'preflight.json');if(!$preflight.Ready-or$preflight.Head-cne$m.Baseline){throw 'LIFECYCLE_PREFLIGHT_REQUIRED'}}
}
switch($Stage){
'prepare'{
    Assert-QualifiedDraft
    if(@(& git --no-optional-locks -C $m.Original rev-parse HEAD)[0]-cne$m.Baseline-or@(& git --no-optional-locks -C $m.Original status --porcelain --untracked-files=all).Count){throw 'LIFECYCLE_ORIGINAL_NOT_AT_BASELINE'}
    if($isOriginal){
        if(Test-Path -LiteralPath $contractPath){throw 'LIFECYCLE_ORIGINAL_NOT_AT_BASELINE'}
        $qualified=Get-Json $sandboxResultPath;$proofPath=$qualified.ReceiptExport;$proof=ConvertFrom-WorkbenchReceipt ([IO.File]::ReadAllText($proofPath))
        if($qualified.Status-cne'Complete'-or$qualified.IndependentWholeRange-cne'READY'-or!$qualified.OwnFreshFullFinish-or$qualified.DraftSHA256-cne$m.DraftSHA256-or$qualified.Receipt-cne$proof.digest-or(Get-FileHash -LiteralPath $proofPath).Hash-cne$qualified.ReceiptExportSHA256-or$proof.root-cne$m.Sandbox){throw 'LIFECYCLE_SANDBOX_PROOF_REQUIRED'}
        $null=Assert-WorkbenchRoot $executionRoot
        if((Get-FileHash -LiteralPath $m.Authority.Path).Hash-cne$m.Authority.SHA256){throw 'LIFECYCLE_AUTHORITY_CHANGED'}
        if(Test-Path -LiteralPath $approval){throw 'LIFECYCLE_APPROVAL_ALREADY_RECORDED'}
        Write-RootText $approval (Get-OriginalApprovalText $qualified $proof $proofPath)
        $fields=@("Approved Draft: $($m.Draft)","Approved SHA256: $($m.DraftSHA256)","Owner Evidence: $approval","Owner Evidence SHA256: $((Get-FileHash -LiteralPath $approval).Hash)","Execution Root: $executionRoot","Sandbox Receipt: $proofPath","Sandbox Receipt SHA256: $((Get-FileHash -LiteralPath $proofPath).Hash)")
        $text=[IO.File]::ReadAllText($m.Draft);$record=Get-WorkbenchFields $text
        $record=Get-WorkbenchFields (Set-WorkbenchSection $text 'Execution Log' ($record.Sections['Execution Log']+"`n"+($fields-join"`n")))
        Assert-WorkbenchApproval $record $executionRoot
        $null=Assert-WorkbenchContextRuntime $executionRoot $context -ResourceCheck
        $recipe=Get-WorkbenchRecipe $executionRoot 'HEAD' $record
        $null=Assert-WorkbenchSandboxProof $executionRoot $record $context $recipe
        $prediction=Get-OriginalPrediction 'HEAD' $record
        if($prediction.Recipe-cne$proof.recipe){throw 'LIFECYCLE_PREDICTED_RECIPE_MISMATCH'}
        if($prediction.Fingerprint-cne$proof.fingerprint){throw 'LIFECYCLE_PREDICTED_FINGERPRINT_MISMATCH'}
        & $hostExe -NoProfile -File (Join-Path $executionRoot 'lib/apply-draft-steps.ps1') -Draft $m.Draft -Root $executionRoot -Preview *> (Join-Path $runtime 'literal-plan.json')
        if($LASTEXITCODE){throw 'LIFECYCLE_LITERAL_PLAN_REFUSED'}
        $plan=Get-Json (Join-Path $runtime 'literal-plan.json')
        if($plan.DraftSHA256-cne$m.DraftSHA256-or$plan.Files.Count-ne@($m.Outputs).Count-or@($plan.Files|Where-Object Skip -eq $true).Count){throw 'LIFECYCLE_LITERAL_PLAN_DIFFERS'}
        foreach($output in $m.Outputs){$entry=@($plan.Files|Where-Object File -CEQ $output.Path);if($entry.Count-ne1-or$entry[0].Blob-cne$output.Blob){throw 'LIFECYCLE_LITERAL_PLAN_DIFFERS'}}
        # Fresh capture before original allocation; never backfill a missing baseline.
        $null=Assert-ProtectedUnchanged (Get-Json (Join-Path $m.Packet 'baseline.json')) '' @()
        [ordered]@{utc=[DateTime]::UtcNow.ToString('o');sources=@(Get-ProtectedSources)}|ConvertTo-Json -Depth 9|Set-Content -LiteralPath $beforePath
        [ordered]@{At=[DateTime]::UtcNow.ToString('o');Root=$executionRoot;DraftSHA256=$m.DraftSHA256;Proof=$proofPath;ProofSHA256=(Get-FileHash -LiteralPath $proofPath).Hash;Approval=$approval;ApprovalSHA256=(Get-FileHash -LiteralPath $approval).Hash;SandboxComplete=$qualified.Head;PredictedRecipe=$prediction.Recipe;PredictedFingerprint=$prediction.Fingerprint;OriginalSourceUnchanged=$true}|ConvertTo-Json|Set-Content -LiteralPath $bindingPath
        Write-Evidence 'preflight.json' ([ordered]@{At=[DateTime]::UtcNow.ToString('o');Ready=$true;Head=$m.Baseline;Root=$executionRoot;DraftSHA256=$m.DraftSHA256;PredictedRecipe=$prediction.Recipe;PredictedFingerprint=$prediction.Fingerprint;ProtectedRoots=@($m.ProtectedRoots).Count;OriginalSourceUnchanged=$true})
    }else{
        if(Test-Path -LiteralPath $m.Sandbox){throw 'LIFECYCLE_SANDBOX_EXISTS'}
        foreach($closure in $m.Closures){
            # A first prepare records a prior package once; the author then pins the hash in the manifest.
            if(!(Test-Path -LiteralPath $closure.Manifest)){
                $files=@(Get-ChildItem -LiteralPath $closure.Root -Recurse -File|ForEach-Object{[ordered]@{path=$_.FullName.Substring($closure.Root.Length+1);bytes=$_.Length;sha256=(Get-FileHash -LiteralPath $_.FullName).Hash}})
                ConvertTo-Json -InputObject $files -Depth 5|Set-Content -LiteralPath $closure.Manifest
            }
            if(!$closure.SHA256){throw "LIFECYCLE_SET_CLOSURE_SHA256:$($closure.Manifest)=$((Get-FileHash -LiteralPath $closure.Manifest).Hash)"}
        }
        $closureFiles=Assert-Closures
        $sources=@(Get-ProtectedSources)
        [ordered]@{utc=[DateTime]::UtcNow.ToString('o');sources=$sources;closure_files=$closureFiles;purpose='Genuine BEFORE before formal sandbox creation'}|ConvertTo-Json -Depth 9|Set-Content -LiteralPath $beforePath
    }
    "LIFECYCLE_PREPARED role=$Role"
}
'allocate'{
    if($isOriginal){Assert-CleanRoot}else{
        if(Test-Path -LiteralPath $executionRoot){throw 'LIFECYCLE_SANDBOX_EXISTS'}
        & git clone --quiet --no-local --no-hardlinks --no-checkout $m.Original $executionRoot
        if($LASTEXITCODE){throw 'LIFECYCLE_SANDBOX_CLONE_FAILED'}
        foreach($pair in @(@('gc.auto','0'),@('maintenance.auto','false'),@('core.autocrlf','true'),@('core.hooksPath','.githooks'),@('user.name',"ORVION $tag Sandbox"),@('user.email','sandbox@invalid.local'))){$null=Invoke-RootGit @('config','--local',$pair[0],$pair[1])}
        $null=Invoke-RootGit @('remote','set-url','--push','origin','DISABLED')
        $null=Invoke-RootGit @('checkout','--quiet',$m.Baseline)
        Assert-CleanRoot
    }
    if((Get-RootHead)-cne$m.Baseline-or(Test-Path -LiteralPath $contractPath)){throw 'LIFECYCLE_BASELINE_OR_ALLOCATION_CHANGED'}
    # The frozen Draft is read-only and File.Copy keeps that; clear it on the working copy (WS-028 sandbox attempt 1).
    [IO.File]::Copy($m.Draft,$contractPath,$false);[IO.File]::SetAttributes($contractPath,[IO.FileAttributes]::Normal)
    if((Get-FileHash -LiteralPath $contractPath).Hash-cne$m.DraftSHA256){throw 'LIFECYCLE_ALLOCATED_DRAFT_DIFFERS'}
    $filtered=@(Invoke-RootGit @('hash-object',('--path='+$m.Contract),'--',$m.Draft))[0]
    Save-RootCommit @($m.Contract) 'allocate' 'allocation-commit.log'
    if(@(Invoke-RootGit @('rev-parse',('HEAD:'+$m.Contract)))[0]-cne$filtered){throw 'LIFECYCLE_ALLOCATED_BLOB_DIFFERS'}
    Write-Evidence 'allocation.json' ([ordered]@{at=[DateTime]::UtcNow.ToString('o');root=$executionRoot;head=(Get-RootHead);draft_sha256=$m.DraftSHA256;allocated_git_blob=$filtered;status='Draft';normal_hook=$true;original_authority=$authorityFlag})
}
'approve'{
    Assert-CleanRoot
    $text=[IO.File]::ReadAllText($contractPath)
    if((Get-WorkbenchFields $text).Status-cne'Draft'){throw 'LIFECYCLE_DRAFT_STATE_REQUIRED'}
    Write-RootText $contractPath (Get-ApprovedText $text)
    $route=Join-Path $executionRoot 'RESUME.md';$routing=[IO.File]::ReadAllText($route)
    if($routing-notmatch'(?m)^Active Workbench Contract: None\r?$'){throw 'LIFECYCLE_POINTER_NOT_FREE'}
    Write-RootText $route ($routing.Replace('Active Workbench Contract: None',('Active Workbench Contract: '+$m.Contract)))
    Save-RootCommit @($m.Contract,'RESUME.md') 'approve' 'approval-commit.log'
    Write-Evidence 'approval.json' ([ordered]@{at=[DateTime]::UtcNow.ToString('o');root=$executionRoot;head=(Get-RootHead);status='Approved';approval=$approval;original_authority=$authorityFlag})
}
'implement'{
    Assert-CleanRoot
    $text=[IO.File]::ReadAllText($contractPath);$record=Get-WorkbenchFields $text
    if($record.Status-cne'Approved'){throw 'LIFECYCLE_APPROVED_STATE_REQUIRED'}
    Assert-WorkbenchApproval $record $executionRoot
    Write-RootText $contractPath (Get-BegunText $text)
    Save-RootCommit @($m.Contract) 'begin' 'begin-commit.log'
    Invoke-Native 'Execute' 'LIFECYCLE_NATIVE_EXECUTE_REFUSED'
    foreach($output in $m.Outputs){if(@(Invoke-RootGit @('hash-object',('--path='+$output.Path),'--',(Join-Path $executionRoot $output.Path)))[0]-cne$output.Blob){throw 'LIFECYCLE_NATIVE_OUTPUT_DIFFERS'}}
    Write-RootText $contractPath (Get-ImplementedText ([IO.File]::ReadAllText($contractPath)))
    Save-RootCommit (@($m.Contract)+@($m.Outputs.Path)) 'implement' 'implementation-commit.log'
    Invoke-Native 'Execute' 'LIFECYCLE_NATIVE_DONE_REFUSED'
    Write-Evidence 'implementation.json' ([ordered]@{at=[DateTime]::UtcNow.ToString('o');root=$executionRoot;head=(Get-RootHead);draft_sha256=$m.DraftSHA256;status='In Progress';resume_step='DONE';outputs=@($m.Outputs).Count;next='One own native timed/watched Finish';original_authority=$authorityFlag})
}
'finish'{
    if(Test-Path -LiteralPath (Join-Path $runtime 'operation.json')){throw 'LIFECYCLE_ONE_FINISH_ALREADY_STARTED_NO_BLIND_RETRY'}
    if(!(Test-Path -LiteralPath (Join-Path $runtime 'implementation.json'))){throw 'LIFECYCLE_IMPLEMENTATION_REQUIRED'}
    if($PSVersionTable.PSVersion.ToString()-cne$m.HostVersion){throw 'LIFECYCLE_PINNED_HOST_REQUIRED'}
    $record=Get-WorkbenchFields ([IO.File]::ReadAllText($contractPath))
    # The suite snapshots THIS real journal before replacing its data root with its own disposable folder.
    $env:ORVION_DATA_ROOT=$m.RealData
    $journal=Join-Path $env:ORVION_DATA_ROOT 'events\events.jsonl'
    if(!(Test-Path -LiteralPath $journal -PathType Leaf)){throw 'LIFECYCLE_REAL_JOURNAL_REQUIRED'}
    $null=Assert-WorkbenchContextRuntime $executionRoot $context -ResourceCheck
    $memory=Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
    $headroom=[ordered]@{Utc=[DateTime]::UtcNow.ToString('o');PhysicalGB=[Math]::Round($memory.FreePhysicalMemory/1MB,2);CommitGB=[Math]::Round($memory.FreeVirtualMemory/1MB,2);RealJournal=$journal;JournalBeforeSHA256=(Get-FileHash -LiteralPath $journal).Hash;MinPhysicalGB=$m.MinPhysicalGB;MinCommitGB=$m.MinCommitGB}
    if($headroom.PhysicalGB-lt$m.MinPhysicalGB-or$headroom.CommitGB-lt$m.MinCommitGB){throw 'LIFECYCLE_MEMORY_BUFFER_NOT_READY_NO_FINISH_STARTED'}
    Write-Evidence 'launch-resources.json' $headroom
    if($record.Status-cne'In Progress'-or$record.Checkpoint['Resume Step']-cne'DONE'-or@(Invoke-RootGit @('status','--porcelain','--untracked-files=all')).Count){throw 'LIFECYCLE_CLEAN_DONE_REQUIRED'}
    if((Get-FileHash -LiteralPath $m.Actionlint).Hash-cne(Get-WorkbenchCITool).SHA256){throw 'LIFECYCLE_PINNED_ACTIONLINT_REQUIRED'}
    function Start-Native([string]$Child,[string[]]$Arguments){
        $si=[Diagnostics.ProcessStartInfo]::new($hostExe);$si.UseShellExecute=$false;$si.CreateNoWindow=$true;$si.WorkingDirectory=$executionRoot
        if($Child-ceq'host'){$si.Environment['ORVION_DATA_ROOT']=Join-Path $runtime 'host-observer-data'}
        $si.RedirectStandardOutput=$true;$si.RedirectStandardError=$true
        foreach($arg in $Arguments){$si.ArgumentList.Add($arg)}
        $proc=[Diagnostics.Process]::Start($si)
        $stdout=[IO.File]::Open((Join-Path $runtime "finish-$Child.log"),[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::Read)
        $stderr=[IO.File]::Open((Join-Path $runtime "finish-$Child.stderr.log"),[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::Read)
        $outTask=$proc.StandardOutput.BaseStream.CopyToAsync($stdout);$errTask=$proc.StandardError.BaseStream.CopyToAsync($stderr)
        @{Process=$proc;Out=$stdout;Err=$stderr;OutTask=$outTask;ErrTask=$errTask}
    }
    $log=Join-Path $runtime 'finish.log';$started=[DateTime]::UtcNow.ToString('o')
    $runner=Start-Native 'runner' @('-NoProfile','-File',(Join-Path $executionRoot 'lib/run_timed.ps1'),'-WorkingDirectory',$executionRoot,'-Log',$log,'-Command',(Get-FinishCommand))
    $watcher=Start-Native 'watcher' @('-NoProfile','-File',(Join-Path $executionRoot 'lib/watch_run.ps1'),'-Log',$log,'-Run',"$tag-$($Role.ToLowerInvariant())-finish",'-Csv',(Join-Path $runtime 'timings.csv'),'-Brief','-ProgressMinutes','5','-PollSeconds','10')
    $hostWatch=Start-Native 'host' @('-NoProfile','-File',(Join-Path $executionRoot 'lib/Watch-Host.ps1'),'-WatchPid',([string]$runner.Process.Id),'-ExitWhenPidsGone')
    $identities=@(foreach($child in @($runner,$watcher,$hostWatch)){Get-CimInstance Win32_Process -Filter ('ProcessId='+$child.Process.Id)|Select-Object ProcessId,ParentProcessId,CreationDate,ExecutablePath,CommandLine})
    Write-Evidence 'operation.json' ([ordered]@{State='RUNNING';Root=$executionRoot;StartedUtc=$started;RunnerPid=$runner.Process.Id;WatcherPid=$watcher.Process.Id;HostPid=$hostWatch.Process.Id;Identities=$identities;Log=$log;TerminalResult=(Join-Path $runtime 'run-result.json');OneNativeFinish=$true;OriginalAuthority=$authorityFlag;RealJournal=$journal;HostObserverDataRoot=(Join-Path $runtime 'host-observer-data')})
    "ONE $($Role.ToUpperInvariant()) FINISH STARTED runner=$($runner.Process.Id), watcher=$($watcher.Process.Id), host=$($hostWatch.Process.Id); real journal guard bound"
    $exits=[ordered]@{}
    foreach($entry in @(@('runner',$runner),@('watcher',$watcher),@('host',$hostWatch))){
        $name=$entry[0];$job=$entry[1];$job.Process.WaitForExit();$job.OutTask.GetAwaiter().GetResult();$job.ErrTask.GetAwaiter().GetResult();$job.Out.Dispose();$job.Err.Dispose()
        $exits[$name]=$job.Process.ExitCode;[IO.File]::WriteAllText((Join-Path $runtime "finish-$name.exit"),[string]$job.Process.ExitCode)
    }
    Write-Evidence 'run-result.json' ([ordered]@{StartedUtc=$started;CompletedUtc=[DateTime]::UtcNow.ToString('o');Exits=$exits;Root=$executionRoot;Log=$log;RealJournalUnchanged=((Get-FileHash -LiteralPath $journal).Hash-ceq$headroom.JournalBeforeSHA256);DraftSHA256=$m.DraftSHA256})
    $exits|ConvertTo-Json
    if(@($exits.Values|Where-Object{$_-ne0}).Count){exit 1}
}
'inspect'{
    $receipt=Read-WorkbenchReceipt $executionRoot
    $recipe=Assert-FinishEvidence $receipt (Get-RootHead) -Live
    $allowed=@(@('RESUME.md',$m.Contract)+@($m.Outputs.Path)|Sort-Object -Unique)
    $roots=Assert-ProtectedUnchanged (Get-Json $beforePath) $(if($isOriginal){$receipt.finishHead}else{''}) $allowed
    $proofDigest=$null
    if($isOriginal){
        $record=Get-WorkbenchFields ([IO.File]::ReadAllText($contractPath))
        $proofDigest=(Assert-WorkbenchSandboxProof $executionRoot $record $context $recipe -Implementation).digest
        $qualified=Get-Json $sandboxResultPath
        if($qualified.Role-cne'SANDBOX'-or$qualified.DraftSHA256-cne$m.DraftSHA256-or$qualified.Root-cne$m.Sandbox-or$receipt.proof-cne$proofDigest-or$proofDigest-cne$qualified.Receipt){throw 'LIFECYCLE_SANDBOX_PROOF_BINDING_CHANGED'}
    }
    $closureFiles=Assert-Closures
    & $hostExe -NoProfile -File $m.Judge -ExpectedEvaluatorSha256 $m.JudgeSHA256 -Root $executionRoot -Mode Range -Base $m.Baseline -Head (Get-RootHead) *> (Join-Path $runtime 'implementation-range.log')
    if($LASTEXITCODE){throw 'LIFECYCLE_IMPLEMENTATION_RANGE_REFUSED'}
    $archive=Join-Path $executionRoot ('.workbench-certifications/'+$receipt.digest+'.json');$export=Join-Path $runtime 'own-finish-receipt.json'
    if(Test-Path -LiteralPath $export){if((Get-FileHash -LiteralPath $export).Hash-cne(Get-FileHash -LiteralPath $archive).Hash){throw 'LIFECYCLE_RECEIPT_EXPORT_COLLISION'}}else{[IO.File]::Copy($archive,$export,$false)}
    Write-Evidence 'independent-finish-review.json' ([ordered]@{at=[DateTime]::UtcNow.ToString('o');ReadyForNativeReview=$true;Head=(Get-RootHead);Root=$executionRoot;Role=$Role.ToUpperInvariant();DraftSHA256=$m.DraftSHA256;OwnReceipt=$receipt.digest;ReceiptExport=$export;ReceiptExportSHA256=(Get-FileHash -LiteralPath $export).Hash;OrderedSuites=$recipe.Material.tests.Count;Recipe=$recipe.Digest;Fingerprint=$receipt.fingerprint;Evaluator=$receipt.evaluator;Profiles=$receipt.profiles;RealJournalUnchanged=$true;ProtectedRoots=$roots;ClosureFiles=$closureFiles;ImplementationRange='READY';SandboxProof=$proofDigest;OriginalAuthority=$authorityFlag})
    "LIFECYCLE_INSPECT_READY role=$Role"
}
'review'{
    Assert-CleanRoot
    $text=[IO.File]::ReadAllText($contractPath);$record=Get-WorkbenchFields $text
    $receipt=Read-WorkbenchReceipt $executionRoot;$observed=Get-Json (Join-Path $runtime 'independent-finish-review.json')
    if(!$observed.ReadyForNativeReview-or$observed.OwnReceipt-cne$receipt.digest-or$observed.DraftSHA256-cne$m.DraftSHA256-or$receipt.role-cne$Role.ToUpperInvariant()){throw 'LIFECYCLE_INSPECTION_MISSING'}
    if($record.Status-cne'In Progress'-or$observed.Head-cne(Get-RootHead)){throw 'LIFECYCLE_REVIEW_SUBJECT_CHANGED'}
    Assert-ReviewEvidence
    if($isOriginal){
        $sandboxDone=Get-Json $sandboxResultPath
        if($sandboxDone.Status-cne'Complete'-or$sandboxDone.IndependentWholeRange-cne'READY'-or$sandboxDone.DraftSHA256-cne$m.DraftSHA256-or$receipt.proof-cne$sandboxDone.Receipt-or$observed.SandboxProof-cne$receipt.proof-or(Get-FileHash -LiteralPath $sandboxDone.ReceiptExport).Hash-cne$sandboxDone.ReceiptExportSHA256){throw 'LIFECYCLE_BOTH_ROOT_PROOFS_REQUIRED'}
    }
    $rows=Get-MappedReview $record
    $words=$m.ReviewText.$Role
    Write-Evidence 'criterion-review.json' ([ordered]@{at=[DateTime]::UtcNow.ToString('o');root=$executionRoot;draft=$m.DraftSHA256;receipt=$receipt.digest;criteria=$rows.criteria;review_gates=$rows.review_gates;boundaries=$words.Boundaries})
    Write-RootText $contractPath (Get-ReviewedText $text $receipt $observed)
    Save-RootCommit @($m.Contract) 'review' 'review-commit.log'
    Invoke-Native 'Review' 'LIFECYCLE_NATIVE_REVIEW_REFUSED'
}
'complete'{
    Assert-CleanRoot
    if(!(Test-Path -LiteralPath (Join-Path $runtime 'criterion-review.json'))){throw 'LIFECYCLE_CRITERION_REVIEW_MISSING'}
    $receipt=Read-WorkbenchReceipt $executionRoot;$observed=Get-Json (Join-Path $runtime 'independent-finish-review.json')
    if(!$observed.ReadyForNativeReview-or$observed.OwnReceipt-cne$receipt.digest-or$observed.DraftSHA256-cne$m.DraftSHA256-or$receipt.role-cne$Role.ToUpperInvariant()){throw 'LIFECYCLE_INSPECTION_MISSING'}
    Invoke-Native 'Complete' 'LIFECYCLE_NATIVE_COMPLETE_REFUSED'
    Save-RootCommit @($m.Contract,'RESUME.md') 'complete' 'complete-commit.log'
    $finalHead=Get-RootHead
    & $hostExe -NoProfile -File $m.Judge -ExpectedEvaluatorSha256 $m.JudgeSHA256 -Root $executionRoot -Mode Range -Base $m.Baseline -Head $finalHead *> (Join-Path $runtime 'complete-range.log')
    if($LASTEXITCODE){throw 'LIFECYCLE_COMPLETE_RANGE_REFUSED'}
    Write-Evidence 'result.json' ([ordered]@{at=[DateTime]::UtcNow.ToString('o');Root=$executionRoot;Head=$finalHead;Baseline=$m.Baseline;Status='Complete';Role=$Role.ToUpperInvariant();DraftSHA256=$m.DraftSHA256;Receipt=$receipt.digest;ReceiptExport=$observed.ReceiptExport;ReceiptExportSHA256=(Get-FileHash -LiteralPath $observed.ReceiptExport).Hash;Recipe=$receipt.recipe;Fingerprint=$receipt.fingerprint;OwnFreshFullFinish=$true;IndependentWholeRange='READY';Clean=$true;Reviews=$m.ReviewsLabel;OriginalAuthority=$authorityFlag;Publication=$false;Pushed=$false;SandboxProof=$receipt.proof})
    "LIFECYCLE_COMPLETE_RANGE_READY role=$Role"
}
}
