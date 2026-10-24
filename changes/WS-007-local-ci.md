# Workbench Change Request - WS-007

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Implement a real local CI test context in the existing Workbench checker/driver/schedule, with pinned grammar plus closed semantic workflow policy, one timed/watched owning schedule, causal refusals and strict separation from native certification. This is the first CONTROL capability, not hosted enforcement, release transport or original approval.

## Baseline

21ee8b1cf103b9296b91d5503c4e2a6b90b6095a

## Write Scope

- RESUME.md
- lib/Test-WorkbenchChange.ps1
- lib/Workbench.ps1
- tests.ps1
- lib/test-workbench-governance.ps1
- WORKFLOW.md
- lib/README.md

## Out of Scope

All other implementation paths; original execution without exact new Gate 1; hosted workflow creation/publication/promotion, actual trusted-main, platform/account/settings/credential changes, products, storage migration/cleanup, completed WS005/006, roadmap changes, Batch 6 and Phase 8. CTRL-19 OPEN. RESUME authority body unchanged; legal pointer/status transitions only.

## Draft Assurance

V1: WS007-CI-DESIGN-20261024 | 2026-10-24 | C:\Users\My Lab\Documents\ORVION-Owner-Review\ci-capability-20261024\assurance\V1\DRAFT.md | 8EF2EBCEF6C784E900130061B0DB40373F36E71EB31682DAC51C29EFFE813342
V2: WS007-CI-ADVERSARIAL-20261024 | 2026-10-24 | C:\Users\My Lab\Documents\ORVION-Owner-Review\ci-capability-20261024\assurance\V2\DRAFT.md | E85AD24EB9B3C3D2242BC15A785C3E3E4ACCA70C30A5DE93EF64AEC26C343D8D
V3: WS007-CI-REFRESH-20261024 | 2026-10-24 | C:\Users\My Lab\Documents\ORVION-Owner-Review\ci-capability-20261024\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WScI
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WScI\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WScI\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\ci-capability-20261024\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/Test-WorkbenchChange.ps1` contains `function Get-WorkbenchCITool`; if so record Already Applied when its Git blob is 0359914cae98f493a59d202649cd2fe2ee29fcf3, and otherwise stop and report. Otherwise make exactly these 2 edits (implement the isolated local CI test context and its measured safety obligations), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
       [pscustomobject]@{Digest=(Get-WorkbenchDigest ($material|ConvertTo-Json -Depth 8 -Compress));Material=$material;Context=$context}
   }
   ```
   insert
   ```text

   # CI is a test context, never a native receipt or owner approval. Windows/amd64 only.
   function Get-WorkbenchCITool {
       [ordered]@{Version='1.7.12';SHA256='54CA21BE3DE4C7CFA26914AA8B61BD76BF573EF3CAAC5F80D110558CDF241718';ArchiveSHA256='6E7241B51E6817EA6A047693D8E6FED13B31819C9A0DD6C5A726E1592D22F6E9';Platform='windows-amd64'}
   }
   function Assert-WorkbenchCITool([string]$Actionlint) {
       $full=Assert-WorkbenchExternalPath $Actionlint
       $tool=Get-WorkbenchCITool
       if(!$IsWindows-or[Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture-ne'X64'-or
          !(Test-Path -LiteralPath $full -PathType Leaf)-or(Get-FileHash -LiteralPath $full).Hash-cne$tool.SHA256){throw 'WB_CI_GRAMMAR_TOOL_IDENTITY'}
       $full
   }
   function Get-WorkbenchWorkflowPolicy {
       $provision=@'
   $ErrorActionPreference='Stop'
   $tools=Join-Path $env:RUNNER_TEMP 'workbench-tools'
   [void](New-Item -ItemType Directory -Path $tools -ErrorAction Stop)
   $archive=Join-Path $tools 'actionlint.zip'
   Invoke-WebRequest -Uri 'https://github.com/rhysd/actionlint/releases/download/v1.7.12/actionlint_1.7.12_windows_amd64.zip' -OutFile $archive
   if((Get-FileHash -LiteralPath $archive).Hash -cne '6E7241B51E6817EA6A047693D8E6FED13B31819C9A0DD6C5A726E1592D22F6E9'){throw 'CI_TOOL_ARCHIVE_CHANGED'}
   $zip=[IO.Compression.ZipFile]::OpenRead($archive)
   try{
       $entries=@($zip.Entries | Where-Object {$_.FullName -ceq 'actionlint.exe'})
       if($entries.Count -ne 1){throw 'CI_TOOL_ENTRY_INVALID'}
       [IO.Compression.ZipFileExtensions]::ExtractToFile($entries[0],(Join-Path $tools 'actionlint.exe'),$false)
   }finally{$zip.Dispose()}
   if((Get-FileHash -LiteralPath (Join-Path $tools 'actionlint.exe')).Hash -cne '54CA21BE3DE4C7CFA26914AA8B61BD76BF573EF3CAAC5F80D110558CDF241718'){throw 'CI_TOOL_BINARY_CHANGED'}
   '@
       # JSON is a deliberately closed YAML subset. No YAML aliases/duplicate keys or expressions can add hidden behavior.
       [ordered]@{name='Workbench acceptance';on=[ordered]@{push=[ordered]@{branches=@('workbench-preflight')}};
           permissions=[ordered]@{contents='read'};jobs=[ordered]@{'workbench-acceptance'=[ordered]@{
               name='workbench-acceptance';'runs-on'='windows-2025';'timeout-minutes'=60;
               steps=@([ordered]@{name='Checkout';uses='actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683';with=[ordered]@{'fetch-depth'=0;'persist-credentials'=$false}},
                   [ordered]@{name='Provision pinned grammar';shell='pwsh';run=$provision},
                   [ordered]@{name='Verify';shell='pwsh';run='& ./lib/Workbench.ps1 -CI -Candidate $env:GITHUB_SHA -CIRuntimeRoot (Join-Path $env:RUNNER_TEMP ("workbench-ci-" + $env:GITHUB_RUN_ID + "-" + $env:GITHUB_RUN_ATTEMPT)) -Actionlint (Join-Path $env:RUNNER_TEMP "workbench-tools/actionlint.exe"); exit $LASTEXITCODE'})}}}
   }
   function Assert-WorkbenchJsonPolicy($policyActual,$policyExpected) {
       if($policyExpected-is[Collections.IDictionary]){
           if($policyActual.ValueKind-ne[Text.Json.JsonValueKind]::Object){throw 'WB_CI_WORKFLOW_POLICY'}
           $names=@($policyActual.EnumerateObject()|ForEach-Object{$_.Name})
           if($names.Count-ne$policyExpected.Count-or(@($names|Sort-Object -CaseSensitive)-join'|')-cne(@($policyExpected.Keys|Sort-Object -CaseSensitive)-join'|')){throw 'WB_CI_WORKFLOW_POLICY'}
           foreach($key in $policyExpected.Keys){Assert-WorkbenchJsonPolicy ($policyActual.GetProperty($key)) $policyExpected[$key]}
       }elseif($policyExpected-is[array]){
           if($policyActual.ValueKind-ne[Text.Json.JsonValueKind]::Array-or$policyActual.GetArrayLength()-ne$policyExpected.Count){throw 'WB_CI_WORKFLOW_POLICY'}
           for($index=0;$index-lt$policyExpected.Count;$index++){Assert-WorkbenchJsonPolicy $policyActual[$index] $policyExpected[$index]}
       }else{
           if($policyActual.GetRawText()-cne(ConvertTo-Json -InputObject $policyExpected -Compress)){throw 'WB_CI_WORKFLOW_POLICY'}
       }
   }
   function Assert-WorkbenchWorkflowText([string]$workflowBody) {
       try{$document=[Text.Json.JsonDocument]::Parse($workflowBody)}catch{throw 'WB_CI_WORKFLOW_JSON_REQUIRED'}
       try{Assert-WorkbenchJsonPolicy $document.RootElement (Get-WorkbenchWorkflowPolicy)}finally{$document.Dispose()}
   }
   function Assert-WorkbenchWorkflowSet([string]$Checkout,[string]$workflowTree,[string]$Actionlint,[string]$TempDirectory,[switch]$RequireWorkflow) {
       $files=@(Invoke-WorkbenchGit $Checkout @('ls-tree','-r','--name-only',$workflowTree)|Where-Object{$_-cmatch'^\.github/workflows/'})
       if(!$files.Count){if($RequireWorkflow){throw 'WB_CI_WORKFLOW_REQUIRED'};return}
       if($files.Count-ne1-or$files[0]-cne'.github/workflows/workbench-acceptance.yml'){throw 'WB_CI_WORKFLOW_SET_UNSUPPORTED'}
       $workflowText=Get-WorkbenchText $Checkout $workflowTree $files[0]
       Assert-WorkbenchWorkflowText $workflowText
       $binary=Assert-WorkbenchCITool $Actionlint
       [void][IO.Directory]::CreateDirectory($TempDirectory)
       $fixture=Join-Path $TempDirectory ('workbench-grammar-'+[guid]::NewGuid().ToString('N')+'.yml')
       try{
           [IO.File]::WriteAllText($fixture,$workflowText,[Text.UTF8Encoding]::new($false))
           & $binary '-shellcheck=' '-pyflakes=' $fixture
           if($LASTEXITCODE-ne0){throw 'WB_CI_WORKFLOW_GRAMMAR'}
       }finally{if(Test-Path -LiteralPath $fixture){[IO.File]::Delete($fixture)}}
   }
   function Get-WorkbenchCIRecipe([string]$Checkout,[string]$Candidate,[string]$RuntimeRoot) {
       $null=Assert-WorkbenchRoot $Checkout
       if($Candidate-cnotmatch'^[0-9a-f]{40}$'-or@(Invoke-WorkbenchGit $Checkout @('rev-parse','HEAD'))[0]-cne$Candidate){throw 'WB_CI_CANDIDATE_MISMATCH'}
       if(@(Invoke-WorkbenchGit $Checkout @('status','--porcelain','--untracked-files=all')).Count){throw 'WB_CI_CLEAN_CANDIDATE_REQUIRED'}
       $runtime=Assert-WorkbenchExternalPath $RuntimeRoot
       if($runtime-ieq$Checkout-or(Test-WorkbenchUnder $runtime $Checkout)-or(Test-WorkbenchUnder $Checkout $runtime)){throw 'WB_CI_RUNTIME_OVERLAP'}
       foreach($key in 'GIT_DIR','GIT_WORK_TREE','GIT_COMMON_DIR','GIT_INDEX_FILE','GIT_OBJECT_DIRECTORY','GIT_ALTERNATE_OBJECT_DIRECTORIES','GIT_CONFIG_COUNT','GIT_CONFIG_PARAMETERS'){
           if([Environment]::GetEnvironmentVariable($key,'Process')){throw 'WB_CI_GIT_ENVIRONMENT_REFUSED'}
       }
       $context=[ordered]@{'Original Root'=$Checkout;'Sandbox Parent'=(Join-Path $runtime 'unused');'Tests Root'=(Join-Path $runtime 't');'Temp Root'=(Join-Path $runtime 'tmp');'Runtime Root'=(Join-Path $runtime 'logs');
           'PowerShell Version'=$PSVersionTable.PSVersion.ToString();'Git Version'=@(Invoke-WorkbenchGit $Checkout @('--version'))[0];'Minimum Physical GB'='1.5';'Minimum Commit GB'='3'}
       $record=[pscustomobject]@{Sections=@{'Execution Context'=(@($context.Keys|ForEach-Object{$_+': '+$context[$_]})-join[char]10)}}
       $baseRecipe=Get-WorkbenchRecipe $Checkout $Candidate $record
       $material=[ordered]@{schema=1;kind='CI_TEST_ONLY';candidate=$Candidate;root=$Checkout;runtime=$runtime;schedule=$baseRecipe.Material;grammar=(Get-WorkbenchCITool);policy=(Get-WorkbenchWorkflowPolicy)}
       [pscustomobject]@{Digest=(Get-WorkbenchDigest ($material|ConvertTo-Json -Depth 20 -Compress));Material=$material;Context=$context}
   }
   function Assert-WorkbenchCIObserved([string]$Checkout,[string]$ciLogPath) {
       $ciWatcherPath=Join-Path $Checkout 'lib/watch_run.ps1'
       $observers=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'" -ErrorAction Stop|Where-Object{
           ([string]$_.CommandLine).Contains($ciWatcherPath,[StringComparison]::OrdinalIgnoreCase)-and
           ([string]$_.CommandLine).Contains($ciLogPath,[StringComparison]::OrdinalIgnoreCase)})
       if($observers.Count-ne1){throw 'WB_CI_OBSERVER_REQUIRED'}
   }
   function Assert-WorkbenchCITimed([string]$Checkout,[string]$RuntimeRoot) {
       $log=Join-Path $RuntimeRoot 'ci.log'
       if(!$env:ORVION_TIMED_ROOT-or[IO.Path]::GetFullPath($env:ORVION_TIMED_ROOT)-ine$Checkout-or
          $env:ORVION_TIMED_LOG-ine$log-or!(Test-Path -LiteralPath $log)){throw 'WB_CI_TIMED_CONTEXT_REQUIRED'}
       $runnerId=0
       if(![int]::TryParse($env:ORVION_TIMED_PID,[ref]$runnerId)){throw 'WB_CI_TIMED_PARENT_REQUIRED'}
       $ancestorId=$PID;$found=$false
       for($hop=0;$hop-lt8-and$ancestorId-gt0;$hop++){
           $row=Get-CimInstance Win32_Process -Filter "ProcessId=$ancestorId" -ErrorAction Stop
           if(!$row){throw 'WB_CI_TIMED_PARENT_REQUIRED'}
           if($ancestorId-eq$runnerId){
               if(!([string]$row.CommandLine).Contains((Join-Path $Checkout 'lib/run_timed.ps1'),[StringComparison]::OrdinalIgnoreCase)){throw 'WB_CI_TIMED_PARENT_REQUIRED'}
               $found=$true;break
           };$ancestorId=[int]$row.ParentProcessId
       }
       if(!$found){throw 'WB_CI_TIMED_PARENT_REQUIRED'}
       $reader=[IO.StreamReader]::new([IO.File]::Open($log,'Open','Read','ReadWrite'))
       try{$start=$reader.ReadLine()}finally{$reader.Dispose()}
       if($start-notmatch('^\[[^]]+\] START pid='+$runnerId+' ')){throw 'WB_CI_TIMED_PARENT_REQUIRED'}
       Assert-WorkbenchCIObserved $Checkout $log
   }
   function Assert-WorkbenchCISuiteParent([string]$Checkout,[string]$Candidate,[string]$RuntimeRoot,[string]$Digest,[int]$Parent) {
       $processRow=Get-CimInstance Win32_Process -Filter "ProcessId=$PID" -ErrorAction Stop
       $ownerRow=Get-CimInstance Win32_Process -Filter "ProcessId=$Parent" -ErrorAction Stop
       if(!$processRow-or!$ownerRow-or$processRow.ParentProcessId-ne$Parent-or
          !([string]$ownerRow.CommandLine).Contains((Join-Path $Checkout 'lib/Workbench.ps1'),[StringComparison]::OrdinalIgnoreCase)-or
          ([string]$ownerRow.CommandLine)-notmatch'(?i)(?:^|\s)-CIWorker(?:\s|$)'){throw 'WB_CI_SUITE_PARENT_REQUIRED'}
       $recipe=Get-WorkbenchCIRecipe $Checkout $Candidate $RuntimeRoot
       if($Digest-cne$recipe.Digest){throw 'WB_CI_RECIPE_MISMATCH'}
       Assert-WorkbenchCITimed $Checkout $RuntimeRoot
       $recipe
   }

   ```

   b) replace the line
   ```text
       if($record.Status-in@('Approved','In Progress')-and('CI'-in$profiles-or'WORKSTATION'-in$profiles)){throw 'WB_PROFILE_CAPABILITY_NOT_YET_IMPLEMENTED'}
   ```
   with
   ```text
       if($record.Status-in@('Approved','In Progress')-and('WORKSTATION'-in$profiles)){throw 'WB_PROFILE_CAPABILITY_NOT_YET_IMPLEMENTED'}
       if('CI'-in$profiles-and@($scope|Where-Object{$_-match'^\.github/'-and$_-cne'.github/workflows/workbench-acceptance.yml'}).Count){throw 'WB_CI_SCOPE_UNSUPPORTED'}
   ```

   The resulting file's Git blob is 0359914cae98f493a59d202649cd2fe2ee29fcf3.

2. Check whether `lib/Workbench.ps1` contains `WORKBENCH_CI_WORKER: READY`; if so record Already Applied when its Git blob is ba881d88847a566a7b4d6896411fa5b6720f05e3, and otherwise stop and report. Otherwise make exactly these 4 edits (implement the isolated local CI test context and its measured safety obligations), each matched once, and change nothing else:

   a) immediately after the line
   ```text
         [Parameter(ParameterSetName='Execute',Mandatory)][switch]$Execute,
   ```
   insert
   ```text
         [Parameter(ParameterSetName='CI',Mandatory)][switch]$CI,
         [Parameter(ParameterSetName='CI',Mandatory)][string]$Candidate,
         [Parameter(ParameterSetName='CI',Mandatory)][string]$CIRuntimeRoot,
         [Parameter(ParameterSetName='CI')][switch]$CIWorker,
         [string]$Actionlint,
   ```

   b) immediately after the line
   ```text
       $Root=Assert-WorkbenchRoot $Root
   ```
   insert
   ```text

       if($CI){
           $ciRecipe=Get-WorkbenchCIRecipe $Root $Candidate $CIRuntimeRoot
           $Actionlint=Assert-WorkbenchCITool $Actionlint
           $env:WORKBENCH_ACTIONLINT=$Actionlint
           $CIRuntimeRoot=$ciRecipe.Material.runtime
           if(!$CIWorker){
               if(Test-Path -LiteralPath $CIRuntimeRoot){throw 'WB_CI_RUNTIME_ALREADY_EXISTS'}
               [void][IO.Directory]::CreateDirectory($CIRuntimeRoot)
               $ciLog=Join-Path $CIRuntimeRoot 'ci.log'
               # Invoke only the existing timed runner/watcher and this fixed worker. No caller command API.
               $quote={param($value) "'"+$value.Replace("'","''")+"'"}
               $command='& pwsh -NoProfile -File '+(& $quote $PSCommandPath)+' -Root '+(& $quote $Root)+' -CI -CIWorker -Candidate '+$Candidate+' -CIRuntimeRoot '+(& $quote $CIRuntimeRoot)+' -Actionlint '+(& $quote $Actionlint)
               $children=[Collections.Generic.List[object]]::new()
               try{
                   foreach($role in 'watcher','runner'){
                       $info=[Diagnostics.ProcessStartInfo]::new((Get-Command pwsh -CommandType Application|Select-Object -First 1).Source)
                       $info.UseShellExecute=$false;$info.CreateNoWindow=$true;$info.WorkingDirectory=$Root
                       $info.RedirectStandardOutput=$true;$info.RedirectStandardError=$true
                       foreach($key in 'WORKBENCH_SUITE_PARENT','WORKBENCH_SUITE_RECIPE','WORKBENCH_SUITE_MODE','WORKBENCH_CI_CANDIDATE','WORKBENCH_CI_RUNTIME','WORKBENCH_TEST_EVIDENCE','ORVION_TIMED_LOG','ORVION_TIMED_ROOT','ORVION_TIMED_PID'){$null=$info.Environment.Remove($key)}
                       $info.Environment['WORKBENCH_TEST_ROOT']=$ciRecipe.Context['Tests Root'];$info.Environment['WORKBENCH_TEMP_ROOT']=$ciRecipe.Context['Temp Root']
                       $ciArguments=if($role-ceq'watcher'){@('-NoProfile','-File',(Join-Path $Root 'lib/watch_run.ps1'),'-Log',$ciLog,'-Run','workbench-ci','-Brief','-PollSeconds','2','-Csv',(Join-Path $CIRuntimeRoot 'timings.csv'))}else{@('-NoProfile','-File',(Join-Path $Root 'lib/run_timed.ps1'),'-Log',$ciLog,'-WorkingDirectory',$Root,'-Command',$command)}
                       foreach($argument in $ciArguments){$info.ArgumentList.Add($argument)}
                       $process=[Diagnostics.Process]::new();$process.StartInfo=$info;$null=$process.Start()
                       $children.Add([pscustomobject]@{Role=$role;Process=$process;Out=$process.StandardOutput.ReadToEndAsync();Err=$process.StandardError.ReadToEndAsync()})
                   }
                   foreach($child in $children|Sort-Object Role){
                       $child.Process.WaitForExit()
                       [IO.File]::WriteAllText((Join-Path $CIRuntimeRoot ($child.Role+'.log')),($child.Out.GetAwaiter().GetResult()+$child.Err.GetAwaiter().GetResult()),[Text.UTF8Encoding]::new($false))
                       [IO.File]::WriteAllText((Join-Path $CIRuntimeRoot ($child.Role+'.exit')),[string]$child.Process.ExitCode)
                   }
                   if(@($children|Where-Object{$_.Process.ExitCode-ne0}).Count){throw 'WB_CI_CHILD_OR_OBSERVER_FAILED'}
                   $actual=Get-WorkbenchCIRecipe $Root $Candidate $CIRuntimeRoot
                   if($actual.Digest-cne$ciRecipe.Digest){throw 'WB_CI_INPUT_CHANGED'}
                   $logText=[IO.File]::ReadAllText($ciLog)
                   $previousPosition=-1
                   foreach($test in $ciRecipe.Material.schedule.tests){
                       $matchesTest=[regex]::Matches($logText,'(?m)^\[\+[^]]+\] PASS '+[regex]::Escape((Split-Path $test -Leaf))+'\r?$')
                       if($matchesTest.Count-ne1-or$matchesTest[0].Index-le$previousPosition){throw 'WB_CI_REQUIRED_TEST_NOT_OBSERVED'}
                       $previousPosition=$matchesTest[0].Index
                   }
                   if([regex]::Matches($logText,'(?m)^\[\+[^]]+\] PASS hazards \(').Count-ne1-or
                      [regex]::Matches($logText,'(?m)^\[\+[^]]+\] PASS the real journal is untouched by the checks\r?$').Count-ne1){throw 'WB_CI_REQUIRED_TEST_NOT_OBSERVED'}
                   if([regex]::Matches($logText,'(?m)^\[\+[^]]+\] TESTS: all passed in ').Count-ne1-or$logText-notmatch'END exit=0 '-or$logText-notmatch'WORKBENCH_CI_WORKER: READY'){throw 'WB_CI_SCHEDULE_NOT_PROVED'}
                   [ordered]@{Kind='CI_TEST_ONLY';Candidate=$Candidate;Root=$Root;Recipe=$ciRecipe.Digest;Result='READY';RunnerExit=0;WatcherExit=0;Certification=$false}|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $CIRuntimeRoot 'ci-result.json') -Encoding utf8
                   'WORKBENCH_CI: READY (tests only; no native certification)'
               }finally{foreach($child in $children){$child.Process.Dispose()}}
               exit 0
           }
           $operationLease=Enter-WorkbenchOperation $Root
           Assert-WorkbenchCITimed $Root $CIRuntimeRoot
           $null=Assert-WorkbenchContextRuntime $Root $ciRecipe.Context -ResourceCheck
           $heavyLease=Enter-WorkbenchHeavyOperation $ciRecipe.Context
           $env:WORKBENCH_TEST_ROOT=$ciRecipe.Context['Tests Root'];$env:WORKBENCH_TEMP_ROOT=$ciRecipe.Context['Temp Root']
           $env:WORKBENCH_SUITE_PARENT=[string]$PID;$env:WORKBENCH_SUITE_RECIPE=$ciRecipe.Digest;$env:WORKBENCH_SUITE_MODE='CI'
           $env:WORKBENCH_CI_CANDIDATE=$Candidate;$env:WORKBENCH_CI_RUNTIME=$CIRuntimeRoot
           Assert-WorkbenchWorkflowSet $Root $Candidate $Actionlint $ciRecipe.Context['Temp Root']
           & pwsh -NoProfile -File (Join-Path $Root 'tests.ps1')
           if($LASTEXITCODE-ne0){throw 'WB_CI_REQUIRED_TESTS_FAILED'}
           Assert-WorkbenchCIObserved $Root (Join-Path $CIRuntimeRoot 'ci.log')
           if((Get-WorkbenchCIRecipe $Root $Candidate $CIRuntimeRoot).Digest-cne$ciRecipe.Digest){throw 'WB_CI_INPUT_CHANGED'}
           'WORKBENCH_CI_WORKER: READY';exit 0
       }

   ```

   c) replace the line
   ```text
           if('WORKSTATION'-in$profiles-or'CI'-in$profiles){throw 'WB_REQUIRED_PROFILE_NOT_IMPLEMENTED'}
   ```
   with
   ```text
           if('WORKSTATION'-in$profiles){throw 'WB_REQUIRED_PROFILE_NOT_IMPLEMENTED'}
   ```

   d) immediately after the lines
   ```text
               $env:WORKBENCH_SUITE_RECIPE=$recipe.Digest
           }
   ```
   insert
   ```text
           $env:WORKBENCH_SUITE_MODE='FINISH'
           if($Actionlint){$env:WORKBENCH_ACTIONLINT=Assert-WorkbenchCITool $Actionlint}
           if('CI'-in$profiles){Assert-WorkbenchWorkflowSet $Root $tree $Actionlint $temporaryParent -RequireWorkflow}
   ```

   The resulting file's Git blob is ba881d88847a566a7b4d6896411fa5b6720f05e3.

3. Check whether `tests.ps1` contains `WB_SUITE_MODE_REFUSED`; if so record Already Applied when its Git blob is cb0df646baa1ff2f753595176ea6ff350fd13982, and otherwise stop and report. Otherwise make exactly this one edit (implement the isolated local CI test context and its measured safety obligations), each matched once, and change nothing else:

   a) replace the lines
   ```text
   $suiteContract=Get-WorkbenchPointer ([IO.File]::ReadAllText((Join-Path $suiteRoot 'RESUME.md')))
   if($suiteContract-ceq'None'){throw 'WB_RAW_FULL_SUITE_REFUSED'}
   $suiteRecord=Get-WorkbenchFields ([IO.File]::ReadAllText((Join-Path $suiteRoot $suiteContract)))
   $suiteRecipe=Get-WorkbenchRecipe $suiteRoot 'HEAD' $suiteRecord
   if(!$suiteRecipe-or$suiteRecipe.Digest-cne$env:WORKBENCH_SUITE_RECIPE){throw 'WB_SUITE_RECIPE_MISMATCH'}
   ```
   with
   ```text

   if($env:WORKBENCH_SUITE_MODE-ceq'CI'){
       $ciRecipe=Assert-WorkbenchCISuiteParent $suiteRoot $env:WORKBENCH_CI_CANDIDATE $env:WORKBENCH_CI_RUNTIME $env:WORKBENCH_SUITE_RECIPE $suiteParent
       $suiteRecipe=[pscustomobject]@{Material=$ciRecipe.Material.schedule}
   }elseif(!$env:WORKBENCH_SUITE_MODE-or$env:WORKBENCH_SUITE_MODE-ceq'FINISH'){
       $suiteContract=Get-WorkbenchPointer ([IO.File]::ReadAllText((Join-Path $suiteRoot 'RESUME.md')))
       if($suiteContract-ceq'None'){throw 'WB_RAW_FULL_SUITE_REFUSED'}
       $suiteRecord=Get-WorkbenchFields ([IO.File]::ReadAllText((Join-Path $suiteRoot $suiteContract)))
       $suiteRecipe=Get-WorkbenchRecipe $suiteRoot 'HEAD' $suiteRecord
       if(!$suiteRecipe-or$suiteRecipe.Digest-cne$env:WORKBENCH_SUITE_RECIPE){throw 'WB_SUITE_RECIPE_MISMATCH'}
   }else{throw 'WB_SUITE_MODE_REFUSED'}
   ```

   The resulting file's Git blob is cb0df646baa1ff2f753595176ea6ff350fd13982.

4. Check whether `lib/test-workbench-governance.ps1` contains `function Test-CICapability`; if so record Already Applied when its Git blob is 95b3e48995fe12663f61fc3f4a37555025fdb890, and otherwise stop and report. Otherwise make exactly these 4 edits (implement the isolated local CI test context and its measured safety obligations), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   # Real local Git/caller fixtures. Synthetic owner assertions and short test children are NOT live approval or full-suite certification.
   ```
   insert
   ```text
   param([switch]$CIOnly)
   ```

   b) replace the line
   ```text
       foreach($key in 'WORKBENCH_TEST_ROOT','WORKBENCH_TEMP_ROOT','WORKBENCH_TEST_EVIDENCE','WORKBENCH_SUITE_PARENT','WORKBENCH_SUITE_RECIPE'){$null=$info.Environment.Remove($key)}
   ```
   with
   ```text
       foreach($key in 'WORKBENCH_TEST_ROOT','WORKBENCH_TEMP_ROOT','WORKBENCH_TEST_EVIDENCE','WORKBENCH_SUITE_PARENT','WORKBENCH_SUITE_RECIPE','WORKBENCH_SUITE_MODE','WORKBENCH_CI_CANDIDATE','WORKBENCH_CI_RUNTIME'){$null=$info.Environment.Remove($key)}
   ```

   c) immediately after the lines
   ```text
       Assert-Fixture 'removing pre-bootstrap environment validation is killed by the actual caller predicate' ($mutantBoot.Output-notmatch'WB_BOOTSTRAP_GIT_ENVIRONMENT_REFUSED') $mutantBoot
   }
   ```
   insert
   ```text

   function Assert-CIRefusal([string]$Name,[scriptblock]$Operation,[string]$Code) {
       $caught='NONE'
       try{& $Operation}catch{$caught=$_.Exception.Message}
       $observations.Add([pscustomobject]@{Kind='ci-refusal';Name=$Name;Observed=$caught;Expected=$Code})
       Assert-Fixture $Name ($caught-cmatch$Code) $caught
   }
   function Test-CICapability {
       $policy=Get-WorkbenchWorkflowPolicy
       $validJson=$policy|ConvertTo-Json -Depth 20
       Assert-WorkbenchWorkflowText $validJson
       Assert-Fixture 'CI closed JSON workflow policy accepts its exact positive control' $true
       $mutations=@(
           @('privileged trigger',{$args[0].on=@{pull_request_target=@{}}}),
           @('write permission',{$args[0].permissions.contents='write'}),
           @('dynamic job skip',{$args[0].jobs.'workbench-acceptance'.if='${{ github.ref == ''refs/heads/other'' }}'}),
           @('wrong branch',{$args[0].on.push.branches=@('other')}),
           @('path filter',{$args[0].on.push.paths=@('docs/**')}),
           @('unpinned action',{$args[0].jobs.'workbench-acceptance'.steps[0].uses='actions/checkout@main'}),
           @('persisted credential',{$args[0].jobs.'workbench-acceptance'.steps[0].with.'persist-credentials'=$true}),
           @('omitted mandatory entry',{$args[0].jobs.'workbench-acceptance'.steps[2].run='Write-Output green'}),
           @('continue on failure',{$args[0].jobs.'workbench-acceptance'.'continue-on-error'=$true}),
           @('untrusted runner',{$args[0].jobs.'workbench-acceptance'.'runs-on'='self-hosted'}),
           @('extra job',{$args[0].jobs.extra=@{}})
       )
       foreach($mutation in $mutations){
           $value=Get-WorkbenchWorkflowPolicy;& $mutation[1] $value
           $body=$value|ConvertTo-Json -Depth 20
           Assert-CIRefusal ('CI policy rejects '+$mutation[0]) {Assert-WorkbenchWorkflowText $body} '^WB_CI_WORKFLOW_POLICY$'
       }
       Assert-CIRefusal 'CI rejects duplicate JSON keys' {Assert-WorkbenchWorkflowText ($validJson.Replace('"contents": "read"','"contents": "write", "contents": "read"'))} '^WB_CI_WORKFLOW_POLICY$'
       Assert-CIRefusal 'CI rejects ambiguous YAML rather than regex approval' {Assert-WorkbenchWorkflowText 'name: not-closed-json'} '^WB_CI_WORKFLOW_JSON_REQUIRED$'
       # Independent initial synthetic trust fixture; no real approval, receipt or production authority.
       $ciRoot=Join-Path $ownedRoot 'ci-caller';[void][IO.Directory]::CreateDirectory($ciRoot)
       $null=Invoke-FixtureGit $ciRoot @('init','--quiet')
       foreach($pair in @(@('user.name','CI fixture'),@('user.email','ci@invalid.local'),@('core.autocrlf','true'),@('core.hooksPath','.git/hooks'))){$null=Invoke-FixtureGit $ciRoot @('config','--local',$pair[0],$pair[1])}
       foreach($relative in 'lib/Test-WorkbenchChange.ps1','lib/Workbench.ps1','lib/run_timed.ps1','lib/watch_run.ps1','lib/Test-ScriptHazards.ps1','lib/Events.ps1','lib/Hunt.ps1','tests.ps1'){
           Write-FixtureFile (Join-Path $ciRoot $relative) ([IO.File]::ReadAllText((Join-Path (Split-Path $PSScriptRoot -Parent) $relative)))
       }
       Write-FixtureFile (Join-Path $ciRoot 'RESUME.md') ('Active Workbench Contract: None'+[char]10)
       Write-FixtureFile (Join-Path $ciRoot '.gitignore') ('work/'+[char]10+'.workbench-local-certification.json'+[char]10+'.workbench-certifications/'+[char]10)
       Write-FixtureFile (Join-Path $ciRoot 'lib/test-synthetic.ps1') "'PASS synthetic CI child (dispatch proof only)'`nexit 0`n"
       $null=Invoke-FixtureGit $ciRoot @('add','.')
       $null=Invoke-FixtureGit $ciRoot @('commit','--quiet','-m','Synthetic initial CI fixture trust only')
       $ciHead=(Invoke-FixtureGit $ciRoot @('rev-parse','HEAD')).Output[0]
       # Keep the Windows fixture-path probe short even though owning fixture names are descriptive.
       $ciRuntime=Join-Path $testParent ('ci-'+[guid]::NewGuid().ToString('N').Substring(0,8))
       $ciRecipe=Get-WorkbenchCIRecipe $ciRoot $ciHead $ciRuntime
       Assert-Fixture 'CI recipe binds full candidate, ordered tests, runtime and evaluator inputs' ($ciRecipe.Material.candidate-ceq$ciHead-and$ciRecipe.Material.schedule.tests.Count-eq1-and@($ciRecipe.Material.schedule.inputs|Where-Object{$_.Path-ceq'lib/Test-WorkbenchChange.ps1'}).Count-eq1)
       Assert-CIRefusal 'CI refuses stale candidate SHA' {Get-WorkbenchCIRecipe $ciRoot ('0'*40) $ciRuntime} '^WB_CI_CANDIDATE_MISMATCH$'
       Assert-CIRefusal 'CI refuses overlapping runtime root' {Get-WorkbenchCIRecipe $ciRoot $ciHead $ciRoot} '^WB_CI_RUNTIME_OVERLAP$'
       Assert-CIRefusal 'CI refuses forged direct parent context' {Assert-WorkbenchCISuiteParent $ciRoot $ciHead $ciRuntime $ciRecipe.Digest $PID} '^WB_CI_SUITE_PARENT_REQUIRED$'
       Assert-CIRefusal 'CI refuses missing timed context and observer' {Assert-WorkbenchCITimed $ciRoot $ciRuntime} '^WB_CI_TIMED_CONTEXT_REQUIRED$'
       Assert-CIRefusal 'CI refuses missing concurrent watcher' {Assert-WorkbenchCIObserved $ciRoot (Join-Path $ciRuntime 'not-observed.log')} '^WB_CI_OBSERVER_REQUIRED$'
       Assert-CIRefusal 'CI workflow profile cannot omit its required workflow' {Assert-WorkbenchWorkflowSet $ciRoot $ciHead '' $ciRuntime -RequireWorkflow} '^WB_CI_WORKFLOW_REQUIRED$'
       $badBinary=Join-Path $ownedRoot 'unreviewed-tool.exe';Write-FixtureFile $badBinary 'not the pinned binary'
       Assert-CIRefusal 'CI refuses substituted grammar tool before execution' {Assert-WorkbenchCITool $badBinary} '^WB_CI_GRAMMAR_TOOL_IDENTITY$'
       $entryCI=Join-Path $ciRoot 'lib/Workbench.ps1'
       $worker=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',$entryCI,'-Root',$ciRoot,'-CI','-CIWorker','-Candidate',$ciHead,'-CIRuntimeRoot',$ciRuntime,'-Actionlint',$badBinary) $ciRoot)
       Assert-Fixture 'CI actual fixed entry refuses invalid tool before tests' ($worker.Exit-ne0-and$worker.Output-match'WB_CI_GRAMMAR_TOOL_IDENTITY'-and$worker.Output-notmatch'PASS hazards') $worker
       $fakeEnv=@{WORKBENCH_SUITE_MODE='CI';WORKBENCH_SUITE_PARENT=[string]$PID;WORKBENCH_SUITE_RECIPE=$ciRecipe.Digest;WORKBENCH_CI_CANDIDATE=$ciHead;WORKBENCH_CI_RUNTIME=$ciRuntime}
       $forged=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',(Join-Path $ciRoot 'tests.ps1')) $ciRoot $fakeEnv)
       Assert-Fixture 'CI actual raw driver refuses environment-only authority at terminal None' ($forged.Exit-ne0-and$forged.Output-match'WB_RAW_FULL_SUITE_REFUSED'-and$forged.Output-notmatch'PASS hazards') $forged
       $native=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',$entryCI,'-Root',$ciRoot,'-Finish') $ciRoot $fakeEnv)
       Assert-Fixture 'CI environment cannot issue native lifecycle certification' ($native.Exit-ne0-and$native.Output-match'WB_ACTIVE_CONTRACT_REQUIRED'-and!(Test-Path -LiteralPath (Join-Path $ciRoot '.workbench-local-certification.json'))) $native

       $verifiedGrammar=Assert-WorkbenchCITool $env:WORKBENCH_ACTIONLINT
       $workflowProbe=Join-Path $ownedRoot 'semantic-grammar-positive.yml'
       Write-FixtureFile $workflowProbe $validJson
       $grammarOutput=@(& $verifiedGrammar '-shellcheck=' '-pyflakes=' $workflowProbe 2>&1);$grammarExit=$LASTEXITCODE
       Assert-Fixture 'CI real pinned upstream grammar accepts the semantic positive' ($grammarExit-eq0) $grammarOutput
       $unknown=$validJson.Replace('"shell": "pwsh"','"shell_typo": "pwsh"')
       Write-FixtureFile $workflowProbe $unknown
       $grammarOutput=@(& $verifiedGrammar '-shellcheck=' '-pyflakes=' $workflowProbe 2>&1);$grammarExit=$LASTEXITCODE
       Assert-Fixture 'CI real grammar rejects an unknown workflow schema key' ($grammarExit-ne0) $grammarOutput
       $ciCall=@('-NoProfile','-File',$entryCI,'-Root',$ciRoot,'-CI','-Candidate',$ciHead,'-CIRuntimeRoot',$ciRuntime,'-Actionlint',$verifiedGrammar)
       $positive=Receive-FixtureChild (Start-FixtureChild $ciCall $ciRoot)
       $observations.Add([pscustomobject]@{Kind='ci-actual-positive';Root=$ciRoot;Runtime=$ciRuntime;Exit=$positive.Exit;Output=$positive.Output})
       $ciResult=if(Test-Path -LiteralPath (Join-Path $ciRuntime 'ci-result.json')){Get-Content -LiteralPath (Join-Path $ciRuntime 'ci-result.json') -Raw|ConvertFrom-Json}else{$null}
       Assert-Fixture 'CI actual terminal-None caller owns exactly one successful timed/watched schedule' ($positive.Exit-eq0-and$ciResult.Result-ceq'READY'-and$ciResult.Certification-eq$false-and$ciResult.Recipe-ceq$ciRecipe.Digest) $positive
       Assert-Fixture 'CI actual success creates neither native working nor archived certification' (!(Test-Path -LiteralPath (Join-Path $ciRoot '.workbench-local-certification.json'))-and!(Test-Path -LiteralPath (Join-Path $ciRoot '.workbench-certifications')))
       foreach($scenario in 'child-exit','omitted-schedule','omitted-hazards','stale-recipe','watcher-exit'){
           # Each mutant is independent synthetic initial trust data, never a bypassed production transition.
           $mutantCI=Join-Path $ownedRoot ('ci-'+$scenario);[void][IO.Directory]::CreateDirectory($mutantCI)
           foreach($relative in @((Invoke-FixtureGit $ciRoot @('ls-files')).Output)){
               Write-FixtureFile (Join-Path $mutantCI $relative) ([IO.File]::ReadAllText((Join-Path $ciRoot $relative)))
           }
           if($scenario-ceq'child-exit'){Write-FixtureFile (Join-Path $mutantCI 'lib/test-synthetic.ps1') "'PASS forged green child'`nexit 7`n"}
           elseif($scenario-ceq'omitted-schedule'){
               $driver=Join-Path $mutantCI 'tests.ps1';$driverText=[IO.File]::ReadAllText($driver)
               $needle='foreach($relativeTest in $suiteRecipe.Material.tests)'
               if(!$driverText.Contains($needle)){throw 'CI_SCHEDULE_MUTANT_STALE'}
               Write-FixtureFile $driver ($driverText.Replace($needle,'foreach($relativeTest in @())'))
           }elseif($scenario-ceq'omitted-hazards'){
               $driver=Join-Path $mutantCI 'tests.ps1';$driverText=[IO.File]::ReadAllText($driver)
               $needle='else{"PASS hazards ($($scripts.Count) scripts)"}'
               if(!$driverText.Contains($needle)){throw 'CI_HAZARDS_MUTANT_STALE'}
               Write-FixtureFile $driver ($driverText.Replace($needle,'else{"synthetic hazard omission"}'))
           }elseif($scenario-ceq'stale-recipe'){
               $driver=Join-Path $mutantCI 'lib/Workbench.ps1';$driverText=[IO.File]::ReadAllText($driver)
               $needle='$env:WORKBENCH_SUITE_RECIPE=$ciRecipe.Digest'
               if(!$driverText.Contains($needle)){throw 'CI_RECIPE_MUTANT_STALE'}
               Write-FixtureFile $driver ($driverText.Replace($needle,"`$env:WORKBENCH_SUITE_RECIPE=('A'*64)"))
           }else{
               $observerFile=Join-Path $mutantCI 'lib/watch_run.ps1'
               $observerText=[IO.File]::ReadAllText($observerFile)
               if(!$observerText.Contains("exit [int](`$body -notmatch '^END exit=0\b')")){throw 'CI_WATCHER_MUTANT_STALE'}
               Write-FixtureFile $observerFile ($observerText.Replace("exit [int](`$body -notmatch '^END exit=0\b')",'exit 7'))
           }
           $null=Invoke-FixtureGit $mutantCI @('init','--quiet')
           foreach($pair in @(@('user.name','CI mutant fixture'),@('user.email','ci@invalid.local'),@('core.autocrlf','true'),@('core.hooksPath','.git/hooks'))){$null=Invoke-FixtureGit $mutantCI @('config','--local',$pair[0],$pair[1])}
           $null=Invoke-FixtureGit $mutantCI @('add','.');$null=Invoke-FixtureGit $mutantCI @('commit','--quiet','-m','Isolated causal CI fixture trust only')
           $mutantHead=(Invoke-FixtureGit $mutantCI @('rev-parse','HEAD')).Output[0]
           $mutantRuntime=Join-Path $testParent ('ci-'+[guid]::NewGuid().ToString('N').Substring(0,8))
           $failure=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',(Join-Path $mutantCI 'lib/Workbench.ps1'),'-Root',$mutantCI,'-CI','-Candidate',$mutantHead,'-CIRuntimeRoot',$mutantRuntime,'-Actionlint',$verifiedGrammar) $mutantCI)
           $expectedFailure=if($scenario-in@('omitted-schedule','omitted-hazards')){'WB_CI_REQUIRED_TEST_NOT_OBSERVED'}else{'WB_CI_CHILD_OR_OBSERVER_FAILED'}
           $observations.Add([pscustomobject]@{Kind='ci-actual-mutant';Scenario=$scenario;Runtime=$mutantRuntime;Exit=$failure.Exit;Output=$failure.Output;Expected=$expectedFailure})
           Assert-Fixture ('CI actual '+$scenario+' cannot become success') ($failure.Exit-ne0-and$failure.Output-match$expectedFailure-and!(Test-Path -LiteralPath (Join-Path $mutantRuntime 'ci-result.json'))) $failure
       }


       foreach($changedPath in 'tests.ps1','lib/Workbench.ps1','lib/Test-WorkbenchChange.ps1','lib/watch_run.ps1'){
           $target=Join-Path $ciRoot $changedPath;$saved=[IO.File]::ReadAllText($target)
           try{
               Write-FixtureFile $target ($saved+[char]10+'# unauthorized mutation')
               Assert-CIRefusal ('CI refuses changed helper/evaluator/schedule '+$changedPath) {Get-WorkbenchCIRecipe $ciRoot $ciHead $ciRuntime} '^WB_CI_CLEAN_CANDIDATE_REQUIRED$'
           }finally{Write-FixtureFile $target $saved}
       }
       $wrongEntry=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',$entryCI,'-Root',$ownedRoot,'-CI','-Candidate',$ciHead,'-CIRuntimeRoot',$ciRuntime,'-Actionlint',$verifiedGrammar) $ciRoot)
       Assert-Fixture 'CI actual entry refuses a substituted physical root' ($wrongEntry.Exit-ne0-and$wrongEntry.Output-match'WB_ENTRY_ROOT_MISMATCH') $wrongEntry
       $unparented=Receive-FixtureChild (Start-FixtureChild @('-NoProfile','-File',$entryCI,'-Root',$ciRoot,'-CI','-CIWorker','-Candidate',$ciHead,'-CIRuntimeRoot',$ciRuntime,'-Actionlint',$verifiedGrammar) $ciRoot)
       Assert-Fixture 'CI actual internal worker refuses an unapproved raw invocation' ($unparented.Exit-ne0-and$unparented.Output-match'WB_CI_TIMED_CONTEXT_REQUIRED') $unparented

       # A content mutation is detected before any child starts, even with an unchanged claimed SHA.
       $scheduleFile=Join-Path $ciRoot 'lib/test-synthetic.ps1';$before=[IO.File]::ReadAllText($scheduleFile)
       Write-FixtureFile $scheduleFile 'exit 0 # altered schedule'
       Assert-CIRefusal 'CI refuses altered scheduled test at the claimed candidate' {Get-WorkbenchCIRecipe $ciRoot $ciHead $ciRuntime} '^WB_CI_CLEAN_CANDIDATE_REQUIRED$'
       Write-FixtureFile $scheduleFile $before
   }

   if($CIOnly){
       try{Test-CICapability}catch{$failures++;"FAIL CI fixture: $($_.Exception.Message)"}
       if($env:WORKBENCH_TEST_EVIDENCE){Write-FixtureFile $env:WORKBENCH_TEST_EVIDENCE ($observations|ConvertTo-Json -Depth 7)}
       if($failures-eq0){$null=Remove-OrvionOwnedTree $ownedRoot @($testParent)}else{"PRESERVED_FIXTURES: $ownedRoot"}
       "WORKBENCH CI OWNING CHECK: $failures failed";exit [int]($failures-gt0)
   }
   ```

   d) immediately after the line
   ```text
       Test-ContextAssurance
   ```
   insert
   ```text
       Test-CICapability
   ```

   The resulting file's Git blob is 95b3e48995fe12663f61fc3f4a37555025fdb890.

5. Check whether `WORKFLOW.md` contains `Local CI capability:`; if so record Already Applied when its Git blob is 20549676f70e25b58f97c2eed5412e10560bdab0, and otherwise stop and report. Otherwise make exactly these 2 edits (implement the isolated local CI test context and its measured safety obligations), each matched once, and change nothing else:

   a) replace the line
   ```text
   REPOSITORY always applies. CONTROL, COORDINATION and RECOVERY derive from exact scope and are covered by the existing full suite plus their owning new cases. WORKSTATION and CI are reserved fail-closed selections until their separately approved capability exists; they are not green placeholders or optional exemptions. Additional future verification must not remove derived obligations.
   ```
   with
   ```text
   REPOSITORY always applies. CONTROL, COORDINATION and RECOVERY derive from exact scope and are covered by the existing full suite plus their owning new cases. WORKSTATION remains reserved and fail-closed. CI has the separate local verification path described below; it is not hosted enforcement or an exemption from native Finish. Additional future verification must not remove derived obligations.
   ```

   b) immediately after the line
   ```text
   Arrival reporting: Pulse consumes one Coordinator Snapshot for owner routing and the queue, preserving that classifier's inherited assignment and explicit Readable state. A category named decision alone is not an owner wait. Missing/failed selected repository or required journal evidence yields visible UNREADABLE and Pulse exit2, never a zero-wait or clean substitute. A readable empty journal, unconfigured upstream or dirty tree retains its actual meaning. These observations grant no write permission, certification or universal liveness guarantee; native Boot and the owning exact contract still decide. test-pulse owns the real Git/journal caller fixtures.
   ```
   insert
   ```text


   Local CI capability: lib/Workbench.ps1 -CI -Candidate <full-lowercase-HEAD-SHA> -CIRuntimeRoot <new-absolute-external-directory> -Actionlint <verified-external-actionlint.exe> runs the existing timed runner and one concurrent watcher, then the existing tests.ps1 schedule once. It requires a clean independent root, exact candidate, real timed ancestry/observer and recipe binding ordered tests, hazard/helper blobs, evaluator, root, runtime, PowerShell/Git and pinned grammar tool/policy. Its internal -CIWorker is not a raw-entry bypass; absent real timed ancestry/observer refuses. The driver child is the actual direct suite parent; environment stamps alone grant no admission. A terminal RESUME None is permitted only in that CI route. A CI_TEST_ONLY result is not a local certification receipt, approval, native Review/Complete, hosted check or trusted candidate judgment. No CI path writes native working/archive receipts or lifecycle metadata. Equal-OS-privilege tampering remains outside the local trust boundary; independent accepted-code judgment and hosted protection remain separate requirements.

   The supported first workflow set is exactly .github/workflows/workbench-acceptance.yml, encoded as the closed JSON subset of YAML returned by Get-WorkbenchWorkflowPolicy. All duplicate/unknown keys, changed branch/triggers, conditions, permissions, action/checkout settings, step commands and missing tests refuse. The upstream actionlint1.7.12 Windows/amd64 executable is pinned by Get-WorkbenchCITool (archive and executable SHA256); supply a verified external copy, never install globally or fetch latest implicitly. Semantic validation and real grammar parsing are both mandatory when a workflow exists; zero workflows is legitimate only for local capability preparation, not hosted parity. The policy contains fixed official-download/archive/binary hash-verified provisioning under RUNNER_TEMP/workbench-tools, followed by the fixed CI entry; this unit creates no workflow or hosted provisioning operation. Native owning CI tests require the pinned external tool through -Actionlint (or WORKBENCH_ACTIONLINT for targeted tests). Future hosted installation must prove its own bootstrap/toolchain/runtime and permission boundaries before freeze. Native CI-profile Finish validates this same grammar/policy before its unchanged owning tests and receipt rules; missing tool or unsupported workflow refuses. WORKSTATION remains blocked. No current private protection, hosted success, release interface or real trusted checkout is asserted. CTRL-19 remains OPEN.
   ```

   The resulting file's Git blob is 20549676f70e25b58f97c2eed5412e10560bdab0.

6. Check whether `lib/README.md` contains `## Workbench local CI test context`; if so record Already Applied when its Git blob is 9e4e21accdea3f4baa5a73312a39220c2ee5e5ac, and otherwise stop and report. Otherwise make exactly this one edit (implement the isolated local CI test context and its measured safety obligations), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   - A one-element pipeline result is a scalar: wrap lists in `@()`.
   ```
   insert
   ```text


   ## Workbench local CI test context

   Use Workbench.ps1 -CI -Candidate <exact-40-character-lowercase-HEAD> -CIRuntimeRoot <new-external-directory> -Actionlint <external-pinned-actionlint.exe>. The existing engine starts its timed runner/watcher and tests.ps1 once; inspect ci.log, watcher.log, runner.exit, watcher.exit and ci-result.json at that external root. Nonzero, omitted owning suites, changed candidate/recipe/inputs, absent observer or forged direct suite parent refuses. Never invoke tests.ps1 or -CIWorker to bypass the parent. Native Finish/approval/receipt/Review/Complete remain independent and unchanged. This CI result cannot certify original work. Get-WorkbenchCITool owns the pinned tool identities; Get-WorkbenchWorkflowPolicy owns the exact deliberately narrow JSON/YAML workflow policy. No workflow file, hosted bootstrap, remote enforcement or publication is installed by this capability. Future provisioning is a separately governed dependency, not an implicit download or owner-credential use.
   ```

   The resulting file's Git blob is 9e4e21accdea3f4baa5a73312a39220c2ee5e5ac.

## Acceptance Criteria

- [ ] Exact installed output lib/Test-WorkbenchChange.ps1. check: blob:lib/Test-WorkbenchChange.ps1=0359914cae98f493a59d202649cd2fe2ee29fcf3
- [ ] Exact installed output lib/Workbench.ps1. check: blob:lib/Workbench.ps1=ba881d88847a566a7b4d6896411fa5b6720f05e3
- [ ] Exact installed output tests.ps1. check: blob:tests.ps1=cb0df646baa1ff2f753595176ea6ff350fd13982
- [ ] Exact installed output lib/test-workbench-governance.ps1. check: blob:lib/test-workbench-governance.ps1=95b3e48995fe12663f61fc3f4a37555025fdb890
- [ ] Exact installed output WORKFLOW.md. check: blob:WORKFLOW.md=20549676f70e25b58f97c2eed5412e10560bdab0
- [ ] Exact installed output lib/README.md. check: blob:lib/README.md=9e4e21accdea3f4baa5a73312a39220c2ee5e5ac
- [ ] RESUME authority body unchanged. check: normalized-resume:RESUME.md=1F392B6A18CC44442BCABE3E23BF82571975C585E8C70496881136170FECE520
- [ ] A real clean candidate CI invocation runs the existing deterministic schedule once through the actual driver, timed runner and watcher, produces a CI_TEST_ONLY result, and never native certification. Terminal None requires its proven parent/context.
- [ ] Owning causal tests reject wrong/stale SHA/root/context/parent, altered recipe/schedule/helper/evaluator, skipped/omitted tests, child/observer failures and certification misuse; native approval/sandbox proof/Finish/Review/Complete remain mandatory. Unsupported WORKSTATION remains fail-closed.
- [ ] Real pinned actionlint grammar plus closed JSON/YAML semantics accept the defined positive and reject unsafe triggers, permissions, conditional skips, unpinned actions, branch/path omissions, duplicate keys and missing owning entry. No hosted result or private protection is inferred.
- [ ] This role has its own new successful timed/watched native Finish and independent live Review before Complete. Literal reproduction/idempotence and relevant causal refusals are observed; historical receipts and all unrelated repositories remain unchanged. Final Complete and full accepted-range judgments are post-Review obligations, never claimed in advance.

## Review Gate

- [ ] Independently inspect six exact outputs, actual positive/refusal logs, trusted admission and unchanged programme/P3 boundaries.
- [ ] Observe this role's own fresh receipt/log/runner/watcher/host exits and implementation/evaluator/recipe/Draft identity. Do not use old WS005/006 proof or claim sandbox as original.
- [ ] Check scope, original baseline unchanged, normal hook, clean committed implementation, criteria and carrying transitions available now. Complete/full-range results must be verified afterwards. No publication or hosted/trusted-main claim.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

External isolated preparation only. No original approval or implementation is granted. The sandbox uses explicitly synthetic root-bound authority for this rehearsal only. Use existing native lifecycle tools and preserve exact artifacts.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\ci-capability-20261024\assurance\V3\DRAFT.md
Approved SHA256: 24497384B425910D572C651486395761E4D5DECCF7701BBC59B5FD4436A265FC
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\ci-capability-20261024\runtime\original\owner-approval.md
Owner Evidence SHA256: BFD07F32361578C63FEDAEDD151C2BF79631F4BBBA5C8123214FE1ECCD1FEFF2
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\ci-capability-20261024\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: C3CB1A26F20A355CE4E12D6EB363A4DB1A7B027D7E9FFAB5E5B2E6B2781376B1
Authority: Actual owner WS-007 Gate 1 directive supplied in this session; exact original root, baseline and six outputs. No remote or subsequent capability authority.

## Verification Notes

No future lifecycle verdict is asserted. Detailed bounded observations and role-specific fresh proof remain external. Original execution requires separate exact lawful owner approval and fresh original preconditions.


## Selection reasons and sources

Selected: actual prototype positive and causal cases plus targeted primary-source refresh justify this smallest six-file implementation. Previous drafts carry the same final payload but distinct review decisions; quality is supported by actual tests, not cosmetic versioning. Hosted security/private entitlement and real trust/release remain separate unproven boundaries.

Sources reviewed 2026-10-24: existing WORKFLOW.md, canonical plan v1.6/layout v1.5 and selected security design F6EEC83CC924CDAE3420FBA9131BA0FCDAFB52EA7B41E921DB3DE6D871B0E44D; actual probes in this packet; https://docs.github.com/en/actions/reference/security/secure-use ; https://github.com/rhysd/actionlint/blob/v1.7.12/docs/usage.md ; https://git-scm.com/docs/git-clone . No SLSA, owner authentication or equal-OS tamper-resistance claim.
