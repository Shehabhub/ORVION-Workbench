# Self-check for Delegate.ps1 in a temp root: the brief carries the question, the known history, the authority limits
# and the exact report and record lines; the delegation is itself an event; -List shows pending, then the verdict.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-delegcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t|Out-Null
$fixtureParent=[IO.Path]::GetFullPath((Split-Path $t -Parent));$fixturePath=[IO.Path]::GetFullPath($t)
$savedEnvironment=@{};foreach($key in 'WORKBENCH_TEMP_ROOT','WORKBENCH_TEST_ROOT','TEMP','TMP','PATH','CODEX_HOME'){$savedEnvironment[$key]=[Environment]::GetEnvironmentVariable($key)}
$env:WORKBENCH_TEMP_ROOT=Join-Path $t 'temporary';$env:WORKBENCH_TEST_ROOT=Join-Path $t 'tests'
$env:TEMP=Join-Path $t 'tmp';$env:TMP=$env:TEMP;[void][IO.Directory]::CreateDirectory($env:TEMP)
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
    & (Join-Path $PSScriptRoot 'Events.ps1') -Root $t -Add -Pattern zebra-case -Session s1 -Category failure -Summary 'ZEBRA-42 broke once'|Out-Null
    $out=@(& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $t -Pattern zebra-case -Question 'Does ZEBRA-42 break again?' -Mode sandbox -Minutes 10)
    $briefPath=([regex]::Match(($out-join"`n"),'DELEGATED zebra-case -> (.+BRIEF\.md)')).Groups[1].Value
    $b=[IO.File]::ReadAllText($briefPath)
    Assert-That 'brief has the question and the known history' ($b.Contains('Does ZEBRA-42 break again?')-and$b.Contains('ZEBRA-42 broke once'))
    Assert-That 'brief bounds authority' ($b.Contains('MUST NOT commit, push')-and$b.Contains('Mode: **sandbox**')-and$b.Contains('10 minutes'))
    Assert-That 'brief names the exact report and record lines' ($b.Contains('VERDICT: CONFIRMED')-and$b.Contains('Do not record events')-and$b.Contains('saves your reply as')-and$b-notmatch'create ````'-and$b.Contains((Join-Path (Split-Path $briefPath) 'REPORT.md')))
    $ev=@([IO.File]::ReadAllLines((Join-Path $t 'events\events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json})
    Assert-That 'the delegation is recorded as an event' (@($ev|Where-Object{$_.source-eq'delegate-road'-and$_.summary-like'delegated (sandbox, 10 min)*'}).Count-eq1)
    Assert-That 'list shows it pending' ((@(& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $t -List)-join' ')-match'pending \(no REPORT\.md yet\)')
    Set-Content (Join-Path (Split-Path $briefPath) 'REPORT.md') "VERDICT: DISPROVEN`nCause: ..."
    Assert-That 'list shows the verdict once reported' ((@(& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $t -List)-join' ')-match'zebra-case: DISPROVEN')
    $bad=try{& (Join-Path $PSScriptRoot 'Delegate.ps1') -Root $t -Pattern 'Not Valid' -Question x|Out-Null;$false}catch{$true}
    Assert-That 'a malformed pattern id is refused' $bad
    $de=Join-Path $PSScriptRoot 'Delegate.ps1';$evPath=Join-Path $PSScriptRoot 'Events.ps1'
    $damaged=Join-Path $t 'damaged';$null=& $evPath -Root $damaged -Add -Pattern unrelated -Summary 'unrelated history'
    Add-Content (Join-Path $damaged 'events\events.jsonl') '{"torn row';Add-Content (Join-Path $damaged 'events\events.jsonl') '{}'
    $out=@(& pwsh -NoProfile -File $de -Root $damaged -Pattern damaged-case -Question 'ABSENT-97');$code=$LASTEXITCODE
    $path=([regex]::Match(($out-join"`n"),'DELEGATED damaged-case -> (.+BRIEF\.md)')).Groups[1].Value;$text=[IO.File]::ReadAllText($path)
    Assert-That 'damaged history is counted in the brief with exit 2' ($code-eq2-and$text-match'EVENTS_INCOMPLETE: 2 unreadable history record\(s\) skipped'-and$text-notmatch'nothing recorded yet')
    $indexed=Join-Path $t 'indexed';$null=& $evPath -Root $indexed -Add -Pattern unrelated -Summary 'unrelated history'
    New-Item -ItemType Directory (Join-Path $indexed 'sessions')|Out-Null;Set-Content (Join-Path $indexed 'sessions\index.jsonl') '{"torn index'
    $out=@(& pwsh -NoProfile -File $de -Root $indexed -Pattern indexed-case -Question 'ABSENT-97');$code=$LASTEXITCODE
    $path=([regex]::Match(($out-join"`n"),'DELEGATED indexed-case -> (.+BRIEF\.md)')).Groups[1].Value;$text=[IO.File]::ReadAllText($path)
    Assert-That 'incomplete related lookup remains visible in the brief with exit 2' ($code-eq2-and$text-match'(?s)Related past events.+EVENTS_INCOMPLETE:'-and$text-notmatch'none recorded')
    $out=@(& pwsh -NoProfile -File $de -Root (Join-Path $t 'absent') -Pattern absent-case -Question 'ABSENT-97');$code=$LASTEXITCODE
    $path=([regex]::Match(($out-join"`n"),'DELEGATED absent-case -> (.+BRIEF\.md)')).Groups[1].Value;$text=[IO.File]::ReadAllText($path)
    Assert-That 'unavailable history and related lookup remain visible in the brief with exit 3' ($code-eq3-and$text-match'(?s)What is already known.+EVENTS_UNAVAILABLE: no history journal'-and$text-match'(?s)Related past events.+EVENTS_UNAVAILABLE:'-and$text-notmatch'none recorded|nothing recorded yet')
    $out=@(& $de -Root $t -Pattern narrow-case -Question 'NARROW-1' -ReadRoots 'C:\only\here')
    $text=[IO.File]::ReadAllText(([regex]::Match(($out-join"`n"),'DELEGATED narrow-case -> (.+BRIEF\.md)')).Groups[1].Value)
    Assert-That 'ReadRoots narrows file and git reads of the brief' ($text.Contains('read only these roots: `C:\only\here`, and run read-only git commands (show, log, grep, rev-parse, cat-file, ls-tree, status) inside those roots only')-and!$text.Contains('every file of the workspace')-and!$text.Contains('status) in the real checkouts'))

    # Actual vendored relay, synthetic CLI/cache/data/watch roots only. No installed agent executable or owner data.
    $savedTempRoot=$env:WORKBENCH_TEMP_ROOT;$gh=Join-Path $t 'gh';$env:WORKBENCH_TEMP_ROOT=Join-Path $gh 'ORVION-Workbench-temporary'
    try{
        . (Join-Path $PSScriptRoot 'workspace-layout.ps1');$tempRoot=Initialize-OrvionTemporaryRoot -Checkout (Split-Path $PSScriptRoot -Parent)
        $clone=Join-Path $tempRoot 'cx\ORVION-selfcheck';$null=& git init -q $clone
        $briefHeadings='Objective','Why delegated','Scope','Authority','Embedded evidence','Read only if needed','Write boundary','Deliverables','Acceptance','Stop conditions','Return format'
        # A section named with $null is left out; any other value replaces its body.
        function New-Brief([string]$Name,[hashtable]$Body=@{}){
            $path=Join-Path $t "$Name.md"
            Set-Content -LiteralPath $path (@(foreach($heading in $briefHeadings){if($Body.ContainsKey($heading)-and$null-eq$Body[$heading]){continue};"## $heading";if($Body.ContainsKey($heading)){$Body[$heading]}else{"fixture brief, DEC-20"}}))
            $path
        }
        $codexBrief=New-Brief 'selfcheck'
        $data=Join-Path $t 'data';[void][IO.Directory]::CreateDirectory($data)
        $cacheFile=Join-Path $t 'models_cache.json';$bin=Join-Path $t 'bin';[void][IO.Directory]::CreateDirectory($bin)
        $fake=Join-Path $bin 'fake-codex.mjs';$stateFile=Join-Path $bin 'state.json';$calls=Join-Path $bin 'calls.jsonl'
        $originalHome=Join-Path $t 'original-codex-home';[void][IO.Directory]::CreateDirectory($originalHome)
        $sentinels=@{'config.toml'=[byte[]](0,67,79,78,70,73,71,255);'auth.json'=[byte[]](0,65,85,84,72,254)}
        foreach($name in $sentinels.Keys){[IO.File]::WriteAllBytes((Join-Path $originalHome $name),$sentinels[$name])}
        $env:CODEX_HOME=$originalHome;$script:featureProbes=@();$script:workstreams=0
        [IO.File]::WriteAllText($fake,@'
import fs from 'node:fs';import path from 'node:path';import {fileURLToPath} from 'node:url';
const dir=path.dirname(fileURLToPath(import.meta.url));
const s=JSON.parse(fs.readFileSync(path.join(dir,'state.json'),'utf8'));const a=process.argv.slice(2);
const featureCall=a.includes('features');
fs.appendFileSync(path.join(dir,'calls.jsonl'),JSON.stringify({argv:a,temp:process.env.TEMP,cwd:process.cwd(),
  codexHome:process.env.CODEX_HOME??null,codexHomeSet:Object.hasOwn(process.env,'CODEX_HOME'),
  featureHomeEntries:featureCall&&process.env.CODEX_HOME?fs.readdirSync(process.env.CODEX_HOME):null})+'\n');
if(a.includes('--version')){console.log('codex-cli '+(s.version||'0.0.9'));process.exit(0)}
const settings={};for(let i=0;i<a.length;i++){if(a[i]==='-c'){const p=a[++i].split('=');settings[p[0]]=p[1]}}
if(featureCall){
  // Match the installed feature grammar: exec's isolation flag is unsupported here.
  for(let i=0;i<a.length-2;i+=2){
    if(a[i]!=='-c'||!a[i+1]?.includes('=')){console.error('error: unexpected argument '+a[i]);process.exit(2)}
  }
  if(a.length%2!==0||a.at(-2)!=='features'||a.at(-1)!=='list'){console.error('error: expected features list');process.exit(2)}
  if(s.featureWarning)console.error(s.featureWarning);
  if(s.featureExit){process.stdout.write(s.featureStdout||'');process.exit(s.featureExit)}
  for(const name of ['memories','multi_agent','shell_tool','view_image']){
    if(s.missingFeature===name)continue;
    console.log(name+' experimental '+(s.malformedFeature===name?'false extra':s.ignoredFeature===name?'true':(settings['features.'+name]||'true')));
     if(s.duplicateFeature===name)console.log(name+' experimental true');
  }
  process.exit(0);
}
if(a.includes('sandbox')&&a.includes('--')){
  const [inClone,inRun,outside]=a.slice(a.indexOf('--')+3);
  if(s.mxcUnavailable){console.error('windows.sandbox = mxc is not allowed');process.exit(1)}
  if(!s.mxcNoClone)fs.writeFileSync(inClone,'x');
  fs.writeFileSync(inRun,'x');
  if(s.mxcWiden)fs.writeFileSync(outside,'x');
  process.exit(s.mxcExit?1:0);
}
if(a[0]!=='exec')process.exit(91);
if(!a.includes('--ignore-user-config')){console.error('error: exec requires --ignore-user-config');process.exit(92)}
const output=a[a.indexOf('-o')+1];const brief=fs.readFileSync(0,'utf8');
fs.writeFileSync(output,s.final??'INHERITED: x\nPROVEN: x\nUNPROVEN: x\nCHANGED: x\nREMAINING: x\nDO NOT TOUCH: x\nNEXT: x\n');fs.writeFileSync(path.join(path.dirname(output),'seen-brief.txt'),brief);
if(s.escape)fs.writeFileSync(s.escape,'synthetic change');
if(s.removeControls)fs.unlinkSync(path.join(path.dirname(output),'native-controls.json'));
 if(s.corruptControls)fs.writeFileSync(path.join(path.dirname(output),'native-controls.json'),s.corruptControls);
 if(s.plantLauncher)fs.writeFileSync(path.join(path.dirname(output),'launcher.json'),'synthetic preserved');
if(s.stderr)console.error(s.stderr);
if(s.badEvents)process.stdout.write('{torn\n');
 else for(const e of (s.events||[{type:'thread.started',thread_id:'synthetic-thread'}]))console.log(JSON.stringify(e));
process.exit(s.exit||0);
'@)
        $nodePath=(Get-Command node -CommandType Application).Source
        if($IsWindows){[IO.File]::WriteAllText((Join-Path $bin 'codex.cmd'),('@"'+$nodePath+'" "%~dp0fake-codex.mjs" %*'))}
        else{
            [IO.File]::WriteAllText((Join-Path $bin 'codex'),("#!/bin/sh`nexec '"+$nodePath.Replace("'","'\''")+"' '"+$fake.Replace("'","'\''")+"' "+'"$@"'+"`n"))
            & chmod +x (Join-Path $bin 'codex');if($LASTEXITCODE){throw 'fixture executable unavailable'}
        }
        $env:PATH=$bin+[IO.Path]::PathSeparator+$savedEnvironment.PATH
        function Write-Cache([object[]]$Models=@(
            @{slug='gpt-8.9-sol';visibility='list';supported_reasoning_levels=@(@{effort='xhigh'})},
            @{slug='gpt-8.10-sol';visibility='list';supported_reasoning_levels=@(@{effort='xhigh'})},
            @{slug='gpt-10.0-sol';visibility='list';supported_reasoning_levels=@(@{effort='high'})},
            @{slug='gpt-99.0-sol';visibility='hidden';supported_reasoning_levels=@(@{effort='xhigh'})},
            @{slug='gpt-99.0-terra';visibility='list';supported_reasoning_levels=@(@{effort='xhigh'})}
        ),[string]$Fetched=([DateTimeOffset]::UtcNow.ToString('o'))){
            [IO.File]::WriteAllText($cacheFile,(@{fetched_at=$Fetched;client_version='0.0.9';models=$Models}|ConvertTo-Json -Depth 6))
        }
        Write-Cache
        $runner=Join-Path $t 'invoke-fixture.ps1';$parameters=Join-Path $t 'parameters.json'
        [IO.File]::WriteAllText($runner,'param([string]$Parameters,[string]$Entry);$ErrorActionPreference="Stop";$settings=Get-Content -LiteralPath $Parameters -Raw|ConvertFrom-Json -AsHashtable;& $Entry @settings;exit $LASTEXITCODE')
        $repo=Join-Path $gh 'PRODUCT';$null=& git init -q $repo;$null=& git -C $repo -c user.name=fixture -c user.email=fixture@invalid commit -q --allow-empty -m fixture
        Set-Content (Join-Path $repo 'notes.txt') 'already untracked before the run'
        function Invoke-Codex([hashtable]$State=@{},[hashtable]$More=@{}){
            [IO.File]::WriteAllText($stateFile,($State|ConvertTo-Json -Depth 10));[IO.File]::WriteAllText($calls,'')
            $settings=@{Root=$data;CodexBrief=$codexBrief;Clone=$clone;Workstream="W$(10000+$script:workstreams++)";ModelCache=$cacheFile;Effort='xhigh';Watch=@($gh,$repo)}
            foreach($key in $More.Keys){if($null-eq$More[$key]){$settings.Remove($key)}else{$settings[$key]=$More[$key]}}
            [IO.File]::WriteAllText($parameters,($settings|ConvertTo-Json -Depth 4))
            $script:codexOut=@(& pwsh -NoProfile -File $runner -Parameters $parameters -Entry $de 2>&1)-join"`n"
            $script:codexCode=$LASTEXITCODE
            $script:observed=@([IO.File]::ReadLines($calls)|Where-Object{$_}|ForEach-Object{$_|ConvertFrom-Json})
            $script:featureProbes+=@($observed|Where-Object{$_.argv-contains'features'})
            $script:evidence=([regex]::Match($codexOut,'CODEX_EVIDENCE: ([^\r\n]+)')).Groups[1].Value
            $codexCode
        }
        function Get-CodexEvidenceFile([string]$Name){
            if(!$evidence-or!(Test-Path -LiteralPath (Join-Path $evidence $Name) -PathType Leaf)){
                throw "CODEX_FIXTURE_DIAGNOSTIC: expected $Name; child exit $codexCode; calls $($observed.Count); captured child output:`n$codexOut"
            }
            Join-Path $evidence $Name
        }
        [IO.File]::WriteAllText($stateFile,'{}')
        $historicalDiagnostic=@(& node $fake --ignore-user-config -c features.memories=false features list 2>&1)-join"`n";$historicalCode=$LASTEXITCODE
        Assert-That 'fake feature parser rejects the historical unsupported flag with exit 2' ($historicalCode-eq2-and$historicalDiagnostic-match'unexpected argument --ignore-user-config')
        $code=Invoke-Codex
        $setFeature=@($observed|Where-Object{$_.argv-contains'features'});$setExec=@($observed|Where-Object{$_.argv[0]-eq'exec'})
        $native=Get-Content (Get-CodexEvidenceFile 'native-controls.json') -Raw|ConvertFrom-Json
        Assert-That 'feature-only home is initially empty while exec retains original home and isolation flag' ($code-eq0-and$setFeature.Count-eq1-and$setFeature[0].codexHomeSet-and$setFeature[0].codexHome-ne$originalHome-and$null-ne$setFeature[0].featureHomeEntries-and$setFeature[0].featureHomeEntries.Count-eq0-and$native.featureHome-ceq$setFeature[0].codexHome-and$setExec.Count-eq1-and$setExec[0].codexHomeSet-and$setExec[0].codexHome-ceq$originalHome-and$setExec[0].argv-contains'--ignore-user-config'-and$setFeature[0].cwd-ceq$setExec[0].cwd)
        $featureArgv=$setFeature[0].argv-join' '
        Assert-That 'feature probe retains every fixed common override without exec-only flag' ($featureArgv-notmatch'--ignore-user-config'-and$featureArgv-match'approval_policy=never'-and$featureArgv-match'features.memories=false'-and$featureArgv-match'memories.use_memories=false'-and$featureArgv-match'memories.generate_memories=false'-and$featureArgv-match'features.multi_agent=false'-and$featureArgv-match'project_doc_max_bytes=0')
        try{
            Remove-Item -LiteralPath Env:CODEX_HOME
            $code=Invoke-Codex
            $unsetFeature=@($observed|Where-Object{$_.argv-contains'features'});$unsetExec=@($observed|Where-Object{$_.argv[0]-eq'exec'})
            Assert-That 'an unset exec home stays unset and gets a different empty feature-only home' ($code-eq0-and$unsetExec.Count-eq1-and!$unsetExec[0].codexHomeSet-and$null-eq$unsetExec[0].codexHome-and$unsetExec[0].argv-contains'--ignore-user-config'-and$unsetFeature.Count-eq1-and$null-ne$unsetFeature[0].featureHomeEntries-and$unsetFeature[0].featureHomeEntries.Count-eq0-and$unsetFeature[0].codexHome-cne$setFeature[0].codexHome)
        }finally{$env:CODEX_HOME=$originalHome}
        $code=Invoke-Codex @{} @{ModelCache=(Join-Path $t 'missing-cache.json')}
        $fixtureDiagnostic=try{$null=Get-CodexEvidenceFile 'launcher.json';''}catch{$_.Exception.Message}
        Assert-That 'a refused fixture retains original child diagnostic and exit before dereference' ($code-ne0-and!$observed.Count-and$fixtureDiagnostic.Contains($codexOut)-and$fixtureDiagnostic.Contains("child exit $code")-and$fixtureDiagnostic-match'CODEX_MODEL_AVAILABILITY_UNVERIFIED'-and$fixtureDiagnostic-notmatch'Cannot bind argument')
        $code=Invoke-Codex @{exit=7}
        $exec=@($observed|Where-Object{$_.argv[0]-eq'exec'})
        $request=Get-Content (Get-CodexEvidenceFile 'launcher.json') -Raw|ConvertFrom-Json
        if($exec.Count-ne1){throw "CODEX_FIXTURE_DIAGNOSTIC: expected one exec; child exit $code; captured child output:`n$codexOut"}
        $argv=$exec[0].argv -join ' '
        Assert-That 'relay nonzero survives with unique default evidence and scratch, latest compatible numeric family and xhigh' ($code-eq7-and$codexOut-match'CODEX_DONE relay exit 7'-and$exec.Count-eq1-and$exec[0].temp.StartsWith((Join-Path $tempRoot 'scratch'))-and$evidence.StartsWith((Join-Path $tempRoot 'codex-relay-logs'))-and$argv-match'-m gpt-8.10-sol'-and$argv-match'model_reasoning_effort=xhigh')
        Assert-That 'fixed settings reach actual CLI argv, without historical memory deletion' ($argv-match'web_search=disabled'-and$argv-match'approval_policy=never'-and$argv-match'features.memories=false'-and$argv-match'memories.use_memories=false'-and$argv-match'memories.generate_memories=false'-and$argv-match'features.multi_agent=false'-and$argv-match'project_doc_max_bytes=0'-and$argv-match'--ignore-user-config')
        foreach($routineEffort in 'low','medium','high'){
            Write-Cache @(@{slug='gpt-8.10-sol';visibility='list';supported_reasoning_levels=@(@{effort=$routineEffort})})
            $code=Invoke-Codex @{} @{Effort=$routineEffort}
            $routineExec=@($observed|Where-Object{$_.argv[0]-eq'exec'})
            Assert-That "ordinary $routineEffort engineering needs no new admission flag" ($code-eq0-and$routineExec.Count-eq1-and($routineExec[0].argv-join' ')-match"model_reasoning_effort=$routineEffort")
        }
        $code=Invoke-Codex @{} @{Effort=$null}
        $defaultExec=@($observed|Where-Object{$_.argv[0]-eq'exec'})
        $dec18=[regex]::Match([IO.File]::ReadAllText((Join-Path $PSScriptRoot '../docs/DECISIONS.md')),'Code value: the engineering effort of lib/Delegate\.ps1\s+is (low|medium|high|xhigh) and carries this ID').Groups[1].Value
        Assert-That 'omitting effort gives the value DEC-18 names, on a line that carries that ID' ($dec18-and$code-eq0-and$defaultExec.Count-eq1-and($defaultExec[0].argv-join' ')-cmatch"model_reasoning_effort=$dec18"-and[IO.File]::ReadAllText($de)-cmatch"\`$Effort='$dec18',\s*# DEC-18")
        Write-Cache
        Assert-That 'brief prefixes arrival guidance and evidence distinguishes requested settings from actual runtime and prevention' ((Get-Content (Join-Path $evidence 'seen-brief.txt') -Raw)-match'(?s)^DELEGATE ARRIVAL OVERRIDE.*skip global arrival.*fixture brief'-and$request.ActualModel-like'UNVERIFIED*'-and$request.SpawnPrevention-eq'UNPROVEN')
        Assert-That 'the brief names the HANDOFF return and the two writable places' ((Get-Content (Join-Path $evidence 'seen-brief.txt') -Raw)-match'(?s)seven HANDOFF fields.*DO NOT TOUCH.*Clone: .*Run folder \(your deliverables; set TEMP and TMP here')
        # DEC-20: MXC by name, per-run roots, no fallback. The acceptance on the real CLI lives in the slice evidence, this fixes the request.
        $code=Invoke-Codex
        $mxcExec=@($observed|Where-Object{$_.argv[0]-eq'exec'});$mxcProbe=@($observed|Where-Object{$_.argv-contains'sandbox'});$mxcRequest=Get-Content (Get-CodexEvidenceFile 'launcher.json') -Raw|ConvertFrom-Json
        $runFolder=$mxcExec[0].temp;$rootsSetting="sandbox_workspace_write.writable_roots=['$clone','$runFolder']"
        foreach($mxcCall in @(@{Name='exec';Argv=$mxcExec[0].argv},@{Name='probe';Argv=$mxcProbe[0].argv})){
            Assert-That "the $($mxcCall.Name) asks for MXC, no command network and only the clone and the run folder" ($mxcCall.Argv-ccontains'windows.sandbox=mxc'-and$mxcCall.Argv-ccontains'sandbox_workspace_write.network_access=false'-and$mxcCall.Argv-ccontains'sandbox_workspace_write.exclude_tmpdir_env_var=true'-and$mxcCall.Argv-ccontains'sandbox_workspace_write.exclude_slash_tmp=true'-and$mxcCall.Argv-ccontains$rootsSetting-and@($mxcCall.Argv-match'writable_roots').Count-eq1)
        }
        Assert-That 'exec is workspace-write, never full access, and the record names both roots' (($mxcExec[0].argv-join' ')-cmatch'-s workspace-write'-and($mxcExec[0].argv-join' ')-notmatch'danger-full-access|network_access=true|web_search=live'-and((@($mxcRequest.WritableRoots)-join'|')-ceq"$clone|$runFolder")-and$mxcRequest.Sandbox-ceq'workspace-write')
        Assert-That 'the probe runs before the model on an empty home and leaves nothing in the clone or run folder' (@($observed.argv|Where-Object{$_-ceq'sandbox'}).Count-eq1-and$mxcProbe[0].argv-ccontains'sandbox_mode=workspace-write'-and[array]::IndexOf(@($observed|ForEach-Object{$_.argv[0]}),'exec')-gt[array]::IndexOf(@($observed|ForEach-Object{$_.argv-contains'sandbox'}),$true)-and$mxcProbe[0].codexHome-cne$originalHome-and!(Get-ChildItem -LiteralPath $clone -Force -Name|Where-Object{$_-like'mxc-probe*'})-and!(Get-ChildItem -LiteralPath $runFolder -Force -Name|Where-Object{$_-like'mxc-probe*'})-and(Get-Content (Get-CodexEvidenceFile 'mxc-probe.json') -Raw|ConvertFrom-Json).passed)
        foreach($mxcState in 'mxcUnavailable','mxcNoClone','mxcWiden','mxcExit'){
            $code=Invoke-Codex @{$mxcState=$true}
            Assert-That "$mxcState refuses the run, never widened, before any model call" ($code-eq5-and$codexOut-match'CODEX_CONTROLS_UNVERIFIED: ORVION_MXC_REFUSED'-and!@($observed|Where-Object{$_.argv[0]-eq'exec'}).Count-and!(Get-Content (Get-CodexEvidenceFile 'mxc-probe.json') -Raw|ConvertFrom-Json).passed)
        }
        # DEC-19: no internet for Codex.
        foreach($researchSettings in @(@{Research=$true},@{Research=$true;Effort=$null})){
            $code=Invoke-Codex @{} $researchSettings
            Assert-That '-Research is refused before any CLI call' ($code-ne0-and$codexOut-match'CODEX_RESEARCH_REFUSED'-and$codexOut-match'DEC-19'-and!$observed.Count)
        }
        # DEC-21: the brief template.
        foreach($briefCase in @(
            @{Name='over-8kb';Body=@{Objective=('x'*8193)};Says='over 8 KB'},
            @{Name='no-why';Body=@{'Why delegated'=$null};Says="'Why delegated' missing"},
            @{Name='empty-scope';Body=@{Scope=' '};Says="'Scope' missing or empty"},
            @{Name='twice';Body=@{Objective=@('x','## Scope','y')};Says="'Scope' twice"},
            @{Name='evidence-61';Body=@{'Embedded evidence'=@(1..61|ForEach-Object{"line $_"})};Says='61 lines, the limit is 60'}
        )){
            $code=Invoke-Codex @{} @{CodexBrief=(New-Brief $briefCase.Name $briefCase.Body)}
            Assert-That "brief $($briefCase.Name) is refused before any CLI call" ($code-ne0-and$codexOut-match'CODEX_BRIEF_REFUSED'-and$codexOut.Contains($briefCase.Says)-and!$observed.Count)
        }
        $measuredBrief=New-Brief 'evidence-60' @{'Embedded evidence'=@(1..60|ForEach-Object{"line $_"});'Read only if needed'=@('## a heading of its own','not a template section')}
        $code=Invoke-Codex @{} @{CodexBrief=$measuredBrief}
        $measured=if($code-eq0){Get-Content (Get-CodexEvidenceFile 'launcher.json') -Raw|ConvertFrom-Json}
        Assert-That 'a conforming brief at the limit runs and the launcher measures it' ($code-eq0-and$measured.BriefEvidenceLines-eq60-and$measured.BriefBytes-eq(Get-Item -LiteralPath $measuredBrief).Length)
        $runNamePattern=[regex]::Match([IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Organize.ps1')),'\$runName=''([^'']+)''').Groups[1].Value
        Assert-That 'the run folders carry the workstream, in the form Organize names' ($runNamePattern-and"$(Split-Path $evidence -Leaf)/"-cmatch$runNamePattern-and(Split-Path $evidence -Leaf)-cmatch"^$($measured.Workstream)-")
        $code=Invoke-Codex @{} @{Workstream='bad'}
        Assert-That 'a workstream outside the W<NN> form is refused' ($code-ne0-and!$observed.Count)
        # DEC-21: one Codex session per workstream.
        $code=Invoke-Codex @{} @{Workstream='W20001'}
        $sessionPath=Join-Path $tempRoot 'sb/W20001/codex/session.json';$session=Get-Content -LiteralPath $sessionPath -Raw -ErrorAction SilentlyContinue|ConvertFrom-Json
        Assert-That 'the session, model and effort are recorded beside the workstream' ($code-eq0-and$session.SessionId-ceq'synthetic-thread'-and$session.Model-ceq'gpt-8.10-sol'-and$session.Effort-ceq'xhigh')
        foreach($sessionCase in @(@{Workstream='W20001'},@{Workstream='W20001';ResumeSession='other-thread'},@{Workstream='W20002';ResumeSession='synthetic-thread'})){
            $code=Invoke-Codex @{} $sessionCase
            Assert-That 'a second fresh session, or a resume of a session this workstream did not record, is refused before the CLI' ($code-ne0-and$codexOut-match'CODEX_SESSION_REFUSED'-and!$observed.Count)
        }
        $code=Invoke-Codex @{} @{Workstream='W20001';ResumeSession='synthetic-thread'}
        $resumed=@($observed|Where-Object{$_.argv[0]-eq'exec'});$resumedArgv=$resumed[0].argv-join' ';$resumeAt=[array]::IndexOf($resumed[0].argv,'resume')
        Assert-That 'the resume dry run keeps MXC and every control after resume' ($code-eq0-and$resumedArgv-cmatch'^exec --ignore-user-config -s workspace-write resume synthetic-thread '-and[array]::IndexOf($resumed[0].argv,'-c')-gt$resumeAt-and$resumed[0].argv-ccontains'windows.sandbox=mxc'-and@($resumed[0].argv-match'writable_roots').Count-eq1-and@($observed|Where-Object{$_.argv-contains'sandbox'}).Count-eq1)
        $code=Invoke-Codex @{events=@(@{type='thread.started';thread_id='another-thread'})} @{Workstream='W20001';ResumeSession='synthetic-thread'}
        Assert-That 'a resume that lands in another session fails and the record stands' ($code-eq5-and$codexOut-match'resume returned another session'-and(Get-Content -LiteralPath $sessionPath -Raw|ConvertFrom-Json).SessionId-ceq'synthetic-thread')
        # The return format: the seven HANDOFF fields in at most 40 lines (WORKSPACE-LAYOUT section 15).
        $handoffLines='INHERITED: x','PROVEN: x','UNPROVEN: x','CHANGED: x','REMAINING: x','DO NOT TOUCH: x','NEXT: x'
        foreach($returnCase in @(
            @{Workstream='W20003';Final='one plain line';Says='missing INHERITED, PROVEN'},
            @{Workstream='W20004';Final=(($handoffLines|Where-Object{$_-notmatch'^PROVEN'})-join"`n");Says='missing PROVEN'},
            @{Workstream='W20005';Final=(($handoffLines+@(1..34|ForEach-Object{"more $_"}))-join"`n");Says='41 lines'}
        )){
            $code=Invoke-Codex @{final=$returnCase.Final} @{Workstream=$returnCase.Workstream}
            Assert-That "a return outside the seven fields in 40 lines exits 6, with its session kept so a resume can correct it ($($returnCase.Says))" ($code-eq6-and$codexOut-match'CODEX_RETURN_FORMAT'-and$codexOut.Contains($returnCase.Says)-and(Test-Path -LiteralPath (Join-Path $tempRoot "sb/$($returnCase.Workstream)/codex/session.json")))
        }
        $code=Invoke-Codex @{final=(($handoffLines+@(1..33|ForEach-Object{"more $_"}))-join"`n")}
        Assert-That 'forty lines holding the seven fields pass' ($code-eq0)
        $code=Invoke-Codex @{final=(($handoffLines|ForEach-Object{"**$_**"})-join"`n")}
        Assert-That 'the labels may carry markup' ($code-eq0)
        # The relay alone refuses what Delegate never asks for: a direct call cannot widen.
        $relayPath=Join-Path $PSScriptRoot 'codex-relay.mjs';$relayOut=Join-Path $t 'relay-refusal'
        $relayBase=@('--orvion-profile','engineering','--orvion-cache-version','0.0.9','--brief',$codexBrief,'--ignore-user-config','--clean-env','--web-search','disabled','--model','gpt-8.10-sol','--effort','high','--timeout','1m','--out-dir',$relayOut)
        foreach($relayCase in @(
            @{Name='full access';More=@('--cd',$clone,'--orvion-run-folder',$t,'--sandbox','danger-full-access')},
            @{Name='no run folder';More=@('--cd',$clone,'--sandbox','workspace-write')},
            @{Name='a quote in a root';More=@('--cd',$clone,'--orvion-run-folder',(Join-Path $t "it's"),'--sandbox','workspace-write')}
        )){
            [IO.File]::WriteAllText($calls,'')
            $relayText=@(& node $relayPath @relayBase @($relayCase.More) 2>&1)-join"`n";$relayExit=$LASTEXITCODE
            Assert-That "the relay refuses $($relayCase.Name) with no CLI call" ($relayExit-ne0-and$relayText-match'ORVION_PROFILE_REFUSED'-and!@([IO.File]::ReadLines($calls)).Count)
        }
        $code=Invoke-Codex @{escape=(Join-Path $gh 'stray.txt')}
        $journal=@(Get-Content -LiteralPath (Join-Path $data 'events/events.jsonl') -ErrorAction SilentlyContinue|ForEach-Object{$_|ConvertFrom-Json}|Where-Object pattern -eq 'codex-outside-write')
        Assert-That 'a new entry beside the checkouts trips exit 4 and records a failure event' ($code-eq4-and$codexOut-match'CODEX_TRIPWIRE: 1 change'-and$journal.Count-eq1-and$journal[0].category-eq'failure')
        Remove-Item -LiteralPath (Join-Path $gh 'stray.txt')
        $code=Invoke-Codex @{escape=(Join-Path $repo 'notes.txt')}
        Assert-That 'rewriting an already untracked file in a sibling checkout trips exit 4' ($code-eq4-and$codexOut-match'CODEX_TRIPWIRE')
        $unicodeDirty=Join-Path $repo 'ملف space.txt';$savedEncoding=[Console]::OutputEncoding
        foreach($codePage in 437,65001){
            Set-Content -LiteralPath $unicodeDirty 'before'
            try{[Console]::OutputEncoding=[Text.Encoding]::GetEncoding($codePage);$code=Invoke-Codex @{escape=$unicodeDirty}}finally{[Console]::OutputEncoding=$savedEncoding}
            Assert-That "rewriting an already dirty Unicode path trips exit 4 on console code page $codePage" ($code-eq4-and$codexOut-match'CODEX_TRIPWIRE')
        }
        $renameSource=Join-Path $repo 'old name.txt';Set-Content -LiteralPath $renameSource 'tracked before rename'
        $null=& git -C $repo add -- 'old name.txt';$null=& git -C $repo -c user.name=fixture -c user.email=fixture@invalid commit -q -m fixture-rename
        $null=& git -C $repo mv -- 'old name.txt' 'new name.txt'
        $code=Invoke-Codex @{escape=(Join-Path $repo 'new name.txt')}
        Assert-That 'rewriting a staged rename destination trips exit 4' ($code-eq4-and$codexOut-match'CODEX_TRIPWIRE')
        $code=Invoke-Codex @{} @{Effort='max'}
        Assert-That 'effort above the owner ceiling is refused' ($code-ne0-and$codexOut-notmatch'CODEX_DONE')
        Assert-That 'fixture propagates parameter-binding refusal and its original diagnostic' ($code-eq1-and$codexOut-match'ValidateSet|Cannot validate argument'-and!$observed.Count)
        $code=Invoke-Codex @{} @{UnknownFixtureParameter='refused'}
        Assert-That 'fixture propagates unknown parameter refusal without dispatch' ($code-eq1-and$codexOut-match'UnknownFixtureParameter'-and!$observed.Count)
        $null=& git -C $clone remote add unsafe (Join-Path $t 'synthetic-push-target')
        $code=Invoke-Codex
        Assert-That 'configured push target refuses before CLI' ($code-ne0-and$codexOut-match'CODEX_CLONE_REFUSED'-and!$observed.Count)
        $null=& git -C $clone remote set-url --push unsafe DISABLED
        $code=Invoke-Codex
        Assert-That 'disabled push clone remains usable' ($code-eq0-and@($observed|Where-Object{$_.argv[0]-eq'exec'}).Count-eq1)
        $null=& git -C $clone remote remove unsafe
        $outside=Join-Path $t 'not-cx';$null=& git init -q $outside
        $code=Invoke-Codex @{} @{Clone=$outside}
        Assert-That 'a clone outside temporary/cx is refused without a CLI call' ($code-ne0-and$codexOut-match'CODEX_CLONE_REFUSED'-and!$observed.Count)
        $permanent=Join-Path $data 'records/WS-026/package/runtime/named-evidence'
        $code=Invoke-Codex @{} @{OutDir=$permanent}
        Assert-That 'caller-named evidence stays in the bound data root and returns its durable path' ($code-eq0-and$evidence-eq$permanent-and(Test-Path (Join-Path $permanent 'SHA256SUMS')))
        $validHashes=$true
        foreach($line in Get-Content (Join-Path $permanent 'SHA256SUMS')){
            if($line-notmatch'^([A-F0-9]{64})  (.+)$'){$validHashes=$false;continue}
            if((Get-FileHash -LiteralPath (Join-Path $permanent $Matches[2])).Hash-cne$Matches[1]){$validHashes=$false}
        }
        Assert-That 'every retained artifact hash is independently reproducible' ($validHashes-and@(Get-Content (Join-Path $permanent 'SHA256SUMS')).Count-ge8)
        $listedArtifacts=@(Get-Content (Join-Path $permanent 'SHA256SUMS')|ForEach-Object{($_-split'  ',2)[1]}|Sort-Object)
        $actualArtifacts=@(Get-ChildItem -LiteralPath $permanent -Recurse -Force -File|Where-Object Name -NE 'SHA256SUMS'|ForEach-Object{[IO.Path]::GetRelativePath($permanent,$_.FullName).Replace('\','/')}|Sort-Object)
        Assert-That 'integrity manifest covers exactly all retained artifacts' (($listedArtifacts-join'|')-ceq($actualArtifacts-join'|'))
        $code=Invoke-Codex @{} @{OutDir=$permanent}
        Assert-That 'existing destination refuses without overwrite or model call' ($code-ne0-and$codexOut-match'CODEX_OUTPUT_COLLISION'-and!$observed.Count)
        foreach($destination in @((Join-Path $data 'records/../escaped'),(Join-Path $data 'records/nested/../escaped'),(Join-Path $clone 'evidence'),(Join-Path $data 'work/delegations/new'),(Join-Path $data 'records/sessions/new'),(Join-Path $t 'different-data/records/new'),(Join-Path $data 'records'),(Join-Path $data 'records/%USERPROFILE%'),(Join-Path $data 'records/NUL.txt'))){
            $code=Invoke-Codex @{} @{OutDir=$destination}
            Assert-That 'traversal/source/private/unbound/root destination refuses before CLI' ($code-ne0-and!$observed.Count)
        }
        $code=Invoke-Codex @{} @{Root=$clone;OutDir=(Join-Path $clone 'work/delegations/new')}
        Assert-That 'rebinding the scope root into source is refused' ($code-ne0-and$codexOut-match'CODEX_OUTPUT_ROOT_REFUSED'-and!$observed.Count)
        $otherRepo=Join-Path $t 'other-source';$null=& git init -q $otherRepo
        $code=Invoke-Codex @{} @{Root=(Join-Path $otherRepo 'data');OutDir=(Join-Path $otherRepo 'data/work/delegations/new')}
        Assert-That 'scope root under an unrelated Git source is refused' ($code-ne0-and$codexOut-match'CODEX_OUTPUT_ROOT_REFUSED'-and!$observed.Count)
        $code=Invoke-Codex @{} @{Root=(Join-Path $t 'private/records')}
        Assert-That 'private subtree cannot become a data-root binding even with default logs' ($code-ne0-and$codexOut-match'CODEX_OUTPUT_ROOT_REFUSED'-and!$observed.Count)
        $nestedSource=Join-Path $data 'records/nested-source';$null=& git init -q $nestedSource
        $code=Invoke-Codex @{} @{OutDir=(Join-Path $nestedSource 'evidence')}
        Assert-That 'a Git source beneath records cannot receive evidence' ($code-ne0-and$codexOut-match'CODEX_OUTPUT_SCOPE_REFUSED'-and!$observed.Count-and!(Test-Path (Join-Path $nestedSource 'evidence')))
        $link=Join-Path $data 'records/redirect';$target=Join-Path $t 'redirect-target';[void][IO.Directory]::CreateDirectory($target)
        try{
            if($IsWindows){$null=New-Item -ItemType Junction -Path $link -Target $target}else{$null=New-Item -ItemType SymbolicLink -Path $link -Target $target}
            $code=Invoke-Codex @{} @{OutDir=(Join-Path $link 'new')}
            Assert-That 'a reparse ancestor refuses without redirected evidence' ($code-ne0-and$codexOut-match'CODEX_REPARSE_REFUSED'-and!$observed.Count-and!(Test-Path (Join-Path $target 'new')))
        }finally{if(Get-Item -LiteralPath $link -Force -ErrorAction SilentlyContinue){[IO.Directory]::Delete($link)}}
        $code=Invoke-Codex @{} @{Family='terra'}
        Assert-That 'wrong family refuses without fallback' ($code-ne0-and!$observed.Count-and$codexOut-match'CODEX_MODEL_FAMILY_REFUSED')
        Write-Cache @(@{slug='gpt-9-sol';visibility='list';supported_reasoning_levels=@(@{effort='xhigh'})});$code=Invoke-Codex
        Assert-That 'an available newer major-only family identifier needs no pinned-list change' ($code-eq0-and((Get-Content (Join-Path $evidence 'launcher.json') -Raw|ConvertFrom-Json).SelectedModel-eq'gpt-9-sol'))
        $duplicate=@{slug='gpt-8.10-sol';visibility='list';supported_reasoning_levels=@(@{effort='xhigh'})}
        Write-Cache @($duplicate,$duplicate);$code=Invoke-Codex
        Assert-That 'duplicate availability entries refuse before CLI' ($code-ne0-and!$observed.Count)
        Write-Cache @(@{slug='gpt-99.0-terra';visibility='list';supported_reasoning_levels=@(@{effort='xhigh'})});$code=Invoke-Codex
        Assert-That 'another family never substitutes for absent Sol' ($code-ne0-and!$observed.Count)
        foreach($badModel in @('gpt-8.10-sol;bad',"gpt-8.10-sol`n",'gpt-8.10-sol-preview','gpt-8.10-sol')){
            Write-Cache @(@{slug=$badModel;visibility='list';supported_reasoning_levels=@(@{effort='high'})})
            $code=Invoke-Codex
            Assert-That 'unsafe slug or unsupported effort fails availability before any CLI' ($code-ne0-and!$observed.Count-and$codexOut-match'CODEX_MODEL_AVAILABILITY_UNVERIFIED')
        }
        Write-Cache -Fetched ([DateTimeOffset]::UtcNow.AddDays(-2).ToString('o'));$code=Invoke-Codex
        Assert-That 'stale availability refuses without live refresh' ($code-ne0-and!$observed.Count)
        Write-Cache -Fetched ([DateTimeOffset]::UtcNow.AddHours(1).ToString('o'));$code=Invoke-Codex
        Assert-That 'future availability refuses before CLI' ($code-ne0-and!$observed.Count)
        Write-Cache -Fetched ([DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ss'));$code=Invoke-Codex
        Assert-That 'timezone-less timestamp refuses instead of assuming local time' ($code-ne0-and!$observed.Count)
        Write-Cache -Fetched 'not-a-dateZ';$code=Invoke-Codex
        Assert-That 'malformed timezone-bearing timestamp refuses' ($code-ne0-and!$observed.Count)
        foreach($validFetched in @([DateTimeOffset]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ss.fffffffZ'),[DateTimeOffset]::UtcNow.ToOffset([TimeSpan]::FromHours(2)).ToString('o'))){
            Write-Cache -Fetched $validFetched;$code=Invoke-Codex
            Assert-That 'current ISO Z and explicit offset timestamps survive PS automatic date conversion' ($code-eq0-and@($observed|Where-Object{$_.argv[0]-eq'exec'}).Count-eq1)
        }
        [IO.File]::WriteAllText($cacheFile,'{torn');$code=Invoke-Codex
        Assert-That 'corrupt cache refuses without model fallback' ($code-ne0-and!$observed.Count)
        Write-Cache
        $code=Invoke-Codex @{version='0.0.8'}
        Assert-That 'CLI/cache mismatch fails before a model call' ($code-eq5-and!@($observed|Where-Object{$_.argv[0]-eq'exec'}).Count)
        foreach($state in @(@{missingFeature='memories'},@{ignoredFeature='multi_agent'},@{duplicateFeature='memories'},@{featureWarning='ignored unsupported setting tools.view_image'},@{malformedFeature='memories'})){
            $code=Invoke-Codex $state
            Assert-That 'missing/ignored native controls fail closed before model call' ($code-eq5-and!@($observed|Where-Object{$_.argv[0]-eq'exec'}).Count)
        }
        $code=Invoke-Codex @{featureExit=23;featureStdout="synthetic partial feature output`n";featureWarning='synthetic native failure diagnostic'}
        $native=Get-Content (Get-CodexEvidenceFile 'native-controls.json') -Raw|ConvertFrom-Json
        Assert-That 'nonzero feature status refuses exec and retains complete native output and diagnostic' ($code-eq5-and!@($observed|Where-Object{$_.argv[0]-eq'exec'}).Count-and$native.exitCode-eq23-and$native.featureList-ceq"synthetic partial feature output`n"-and$native.diagnostics-ceq"synthetic native failure diagnostic`n")
        foreach($state in @(@{stderr='ignored tools.view_image'},@{removeControls=$true},@{corruptControls='{torn'},@{corruptControls='{}'},@{badEvents=$true},@{events=@()},@{events=@(@{})},@{events=@(@{type='item.completed';item='invalid'})},@{events=@(@{type='warning';message='unknown feature'})},@{events=@(@{type='turn.failed';error=@{message='synthetic failure'}})})){
            $code=Invoke-Codex $state
            Assert-That 'runtime ignored controls or missing/unreadable evidence cannot return success' ($code-eq5-and$codexOut-match'CODEX_CONTROLS_UNVERIFIED')
        }
        foreach($itemEnvelope in 'item.started','item.updated','item.completed'){
            foreach($validItem in @(@{type='agent_message';text='synthetic native message'},@{type='future_native_extension_v99'})){
                $code=Invoke-Codex @{events=@(@{type=$itemEnvelope;item=$validItem})}
                Assert-That "$itemEnvelope accepts a valid nonempty string item type $($validItem.type)" ($code-eq0-and$codexOut-match'CODEX_DONE relay exit 0')
            }
            $code=Invoke-Codex @{events=@(@{type=$itemEnvelope;item='invalid'})}
            Assert-That "$itemEnvelope refuses a scalar item control" ($code-eq5-and$codexOut-match'CODEX_CONTROLS_UNVERIFIED: invalid item event shape')
            foreach($invalidItem in @(@{},@{type=''},@{type=7},@{type=" `t`r`n"},@{type=$null})){
                $code=Invoke-Codex @{events=@(@{type=$itemEnvelope;item=$invalidItem})}
                Assert-That "$itemEnvelope refuses a missing, empty, nonstring or whitespace item type $($invalidItem|ConvertTo-Json -Compress)" ($code-eq5-and$codexOut-match'CODEX_CONTROLS_UNVERIFIED: invalid item event type')
            }
        }
        # Literal real first-run shape; no evidence path or model execution is needed.
        $ignoredControl=@{type='item.completed';item=@{id='item_0';type='error';message="Codex is ignoring 1 unrecognized configuration setting. Check for typos or deprecated settings.`n  session-flags: ``tools.view_image`` is ignored."}}
        $code=Invoke-Codex @{events=@($ignoredControl)}
        Assert-That 'actual nested ignored-control error fails a clean native exit' ($code-eq5-and$codexOut-match'CODEX_CONTROLS_UNVERIFIED: runtime reports unsupported controls'-and((Get-Content (Get-CodexEvidenceFile 'events.jsonl') -Raw|ConvertFrom-Json).item.message-ceq$ignoredControl.item.message))
        # Synthetic log only, never a spawning experiment. A mention in report text is not observed creation.
        $code=Invoke-Codex @{events=@(@{type='item.completed';item=@{type='agent_message';text='spawn_agent may remain exposed'}})}
        Assert-That 'a textual limitation is not fabricated spawn evidence' ($code-eq0)
        $code=Invoke-Codex @{events=@(@{type='tool_inventory';tools=@(@{name='spawn_agent'})})}
        Assert-That 'catalog exposure is not relabelled as observed creation' ($code-eq0)
        $structuredInventory=@{type='tool_inventory';tools=@(@{type='spawn_agent';name='spawn_agent'},@{type='command_execution';name='exec_command'},@{type='error';message='ignored setting'})}
        $code=Invoke-Codex @{events=@($structuredInventory)}
        Assert-That 'structured inventory is neither observed creation nor runtime error' ($code-eq0)
        $code=Invoke-Codex @{events=@(@{type='item.completed';item=@{type='agent_message';text=($ignoredControl|ConvertTo-Json -Depth 8);example=$ignoredControl}})}
        Assert-That 'reported control-error example is data rather than an actual warning' ($code-eq0)
        $code=Invoke-Codex @{events=@(@{type='item.completed';item=@{type='collab_tool_call';tool='spawn_agent'}})}
        Assert-That 'observed unauthorized tool creation fails and escalates' ($code-eq5-and$codexOut-match'CODEX_UNAUTHORIZED_CREATION')
        $code=Invoke-Codex @{stderr='ignored setting';events=@(@{type='item.completed';item=@{type='collab_tool_call';tool='spawn_agent'}})}
        Assert-That 'ignored-control diagnostic cannot hide observed spawning' ($code-eq5-and$codexOut-match'CODEX_UNAUTHORIZED_CREATION')
        $code=Invoke-Codex @{events=@($ignoredControl,@{type='item.completed';item=@{type='collab_tool_call';tool='spawn_agent'}})}
        Assert-That 'nested ignored control cannot hide observed spawning' ($code-eq5-and$codexOut-match'CODEX_UNAUTHORIZED_CREATION')
        $code=Invoke-Codex @{plantLauncher=$true}
        Assert-That 'launcher record collision refuses without overwriting retained child artifact' ($code-ne0-and(Get-Content -LiteralPath (Join-Path $evidence 'launcher.json') -Raw)-ceq'synthetic preserved')
        $code=Invoke-Codex @{} @{Watch=@((Join-Path $t 'missing-watch'))}
        Assert-That 'unreadable initial watch fails exit 4 without CLI and preserves evidence' ($code-eq4-and!$observed.Count-and$codexOut-match'CODEX_TRIPWIRE'-and(Test-Path (Join-Path $evidence 'SHA256SUMS')))
        $code=Invoke-Codex @{} @{Relay=(Join-Path $t 'untrusted-relay.mjs')}
        Assert-That 'a relay override cannot bypass fixed controls' ($code-ne0-and!$observed.Count-and$codexOut-match'CODEX_RELAY_OVERRIDE_REFUSED')
        Assert-That 'all feature calls use distinct initially empty task-temporary homes, including refusals' ($featureProbes.Count-gt1-and@($featureProbes|Where-Object{!$_.codexHomeSet-or$null-eq$_.featureHomeEntries-or$_.featureHomeEntries.Count-ne0-or!$_.codexHome.StartsWith($_.temp+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)}).Count-eq0-and@($featureProbes.codexHome|Sort-Object -Unique).Count-eq$featureProbes.Count)
        $sentinelsUnchanged=$true
        foreach($name in $sentinels.Keys){if([Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $originalHome $name)))-cne[Convert]::ToBase64String($sentinels[$name])){$sentinelsUnchanged=$false}}
        Assert-That 'original synthetic config and auth sentinel bytes remain unchanged' $sentinelsUnchanged
    }finally{$env:WORKBENCH_TEMP_ROOT=$savedTempRoot}
}finally{
    foreach($key in $savedEnvironment.Keys){if($null-eq$savedEnvironment[$key]){Remove-Item -LiteralPath "Env:$key" -ErrorAction SilentlyContinue}else{[Environment]::SetEnvironmentVariable($key,$savedEnvironment[$key])}}
    if(![IO.Path]::GetFullPath($t).Equals($fixturePath)-or!$fixturePath.StartsWith($fixtureParent+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)){throw 'FIXTURE_CLEANUP_ROOT_REFUSED'}
    Get-ChildItem -LiteralPath $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)
}
if($fail){throw "DELEGATE_SELFCHECK_FAILED $fail"};'DELEGATE_SELFCHECK PASS'
