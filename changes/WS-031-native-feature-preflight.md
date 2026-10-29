# Workbench Change Request - WS-031

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Restore the installed CLI 0.164.0 no-model feature preflight with its supported grammar, an initially empty temporary feature-only CODEX_HOME, unchanged fixed controls and unchanged exec environment/home/flag. Retain native diagnostics and bound the claim to feature recognition. Intended allocation path: changes/WS-031-native-feature-preflight.md.

## Baseline

200c3a1b9bb87550de6520f886c53eb8242fd55b

## Write Scope

- RESUME.md
- lib/codex-relay.mjs
- lib/test-delegate.ps1
- lib/README.md

## Out of Scope

Every other engineering path, routing text, product/task, workflow, Delegate, applier, checker, template, driver, schedule, installation, dispatch override, account, credential, settings, privilege, trusted state, cleanup and remote operation. RESUME.md changes only through its native active-contract pointer lifecycle; no literal RESUME edit is proposed. Contract allocation and status/log transitions use the existing native lifecycle. Task scratch is not native engineering scope. No new research proof, production F6, tool/read confinement, configuration-equivalence certification or global author substitution is authorized.

## Draft Assurance

V1: WS031-DESIGN-20261029-V1 | 2026-10-29 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-031\package\assurance\V1\DRAFT.md | A3D4AE2F0BD1F4F4B61CDB0DC0611F832A8AD0581C399B83B7479937F7B01581
V2: WS031-ADVERSARIAL-20261029-V2 | 2026-10-29 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-031\package\assurance\V2\DRAFT.md | EA50CAC55FD13713342D204475B0DD93391F58C8FD9E7B91A3B44154052CC1D5
V3: WS031-REFRESH-20261029-V3 | 2026-10-29 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-031\package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V3 EVIDENCE REFRESH selection: preceding frozen V1/V2 hashes above were recomputed from supplied complete copies and match their provenance. Their placeholders stay immutable in historical snapshots. These existing distinct declared IDs/paths identify launcher-owned immutable assurance artifacts; the delegate has not followed or verified external/private paths. V3 is SELECTED without its own hash; the launcher measures/freezes its final digest externally. This is the unfinished V3 continuation after a failed provider-limit attempt, not a material correction/V4. D54/D55 are WS031-only DELEGATED bootstrap and Sol/xhigh substitution, not Claude/provider independence or approval. Root must verify actual artifact existence, role provenance and native admission; no Gate or receipt is granted.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W31\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W31\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W31\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-031\package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/codex-relay.mjs` contains `const featureHome = mkdtempSync`; if so record Already Applied when its Git blob is eb60b15c9231f731d05b64858c16ed5df644fb8b, and otherwise stop and report. Otherwise make exactly these 5 edits (use an empty feature-only home and retain native probe diagnostics), each matched once, and change nothing else:

   a) replace the line
   ```text
   import { mkdirSync, writeFileSync, renameSync, readFileSync, existsSync, appendFileSync, openSync, fstatSync, readSync, closeSync } from "node:fs";
   ```
   with
   ```text
   import { mkdirSync, mkdtempSync, writeFileSync, renameSync, readFileSync, existsSync, appendFileSync, openSync, fstatSync, readSync, closeSync } from "node:fs";
   ```

   b) replace the lines
   ```text
     // Match dispatch's config source and working directory, not the launcher's project.
     const args = ["--ignore-user-config", ...requested.flatMap(value => ["-c", value])];
   ```
   with
   ```text
     // Installed CLI accepts --ignore-user-config only under exec. The feature
     // probe gets an empty home, without copying config/auth or changing env.
     // This does not establish equivalent managed/profile/trust loading for exec.
     const featureHome = mkdtempSync(join(tmpdir(), "orvion-feature-home-"));
     const args = requested.flatMap(value => ["-c", value]);
   ```

   c) replace the line
   ```text
       env, cwd: opts.cd, encoding: "utf8", timeout,
   ```
   with
   ```text
       env: { ...env, CODEX_HOME: featureHome }, cwd: opts.cd, encoding: "utf8", timeout,
   ```

   d) replace the line
   ```text
       exitCode: probe.status, error: probe.error ? String(probe.error.message) : null,
   ```
   with
   ```text
       configIsolation: "fresh empty feature-only CODEX_HOME; no copied config/auth; exec home unchanged", featureHome,
       exitCode: probe.status, signal: probe.signal, error: probe.error ? String(probe.error.message) : null,
       probeError: probe.error ? Object.fromEntries(Object.getOwnPropertyNames(probe.error).map(key => [key, probe.error[key]])) : null,
   ```

   e) replace the line
   ```text
       unverified: "supplemental keys, effective settings, complete tool catalog, private-read confinement and spawn prevention" };
   ```
   with
   ```text
       unverified: "configuration equivalence (including managed/profile/trust loading), supplemental keys, effective settings, complete tool catalog, private-read confinement and spawn prevention" };
   ```

   The resulting file's Git blob is eb60b15c9231f731d05b64858c16ed5df644fb8b.

2. Check whether `lib/test-delegate.ps1` contains `fake feature parser rejects the historical unsupported flag with exit 2`; if so record Already Applied when its Git blob is d6fdf1bcdc1df28be816d5461ab4ebd18998ec12, and otherwise stop and report. Otherwise make exactly these 13 edits (exercise native feature grammar, separate homes and retained exec behavior), each matched once, and change nothing else:

   a) replace the line
   ```text
   $savedEnvironment=@{};foreach($key in 'WORKBENCH_TEMP_ROOT','WORKBENCH_TEST_ROOT','TEMP','TMP','PATH'){$savedEnvironment[$key]=[Environment]::GetEnvironmentVariable($key)}
   ```
   with
   ```text
   $savedEnvironment=@{};foreach($key in 'WORKBENCH_TEMP_ROOT','WORKBENCH_TEST_ROOT','TEMP','TMP','PATH','CODEX_HOME'){$savedEnvironment[$key]=[Environment]::GetEnvironmentVariable($key)}
   ```

   b) immediately after the line
   ```text
           $fake=Join-Path $bin 'fake-codex.mjs';$stateFile=Join-Path $bin 'state.json';$calls=Join-Path $bin 'calls.jsonl'
   ```
   insert
   ```text
           $originalHome=Join-Path $t 'original-codex-home';[void][IO.Directory]::CreateDirectory($originalHome)
           $sentinels=@{'config.toml'=[byte[]](0,67,79,78,70,73,71,255);'auth.json'=[byte[]](0,65,85,84,72,254)}
           foreach($name in $sentinels.Keys){[IO.File]::WriteAllBytes((Join-Path $originalHome $name),$sentinels[$name])}
           $env:CODEX_HOME=$originalHome;$script:featureProbes=@()
   ```

   c) replace the line
   ```text
   fs.appendFileSync(path.join(dir,'calls.jsonl'),JSON.stringify({argv:a,temp:process.env.TEMP})+'\n');
   ```
   with
   ```text
   const featureCall=a.includes('features');
   fs.appendFileSync(path.join(dir,'calls.jsonl'),JSON.stringify({argv:a,temp:process.env.TEMP,cwd:process.cwd(),
     codexHome:process.env.CODEX_HOME??null,codexHomeSet:Object.hasOwn(process.env,'CODEX_HOME'),
     featureHomeEntries:featureCall&&process.env.CODEX_HOME?fs.readdirSync(process.env.CODEX_HOME):null})+'\n');
   ```

   d) replace the line
   ```text
   if(a.includes('features')){
   ```
   with
   ```text
   if(featureCall){
     // Match the installed feature grammar: exec's isolation flag is unsupported here.
     for(let i=0;i<a.length-2;i+=2){
       if(a[i]!=='-c'||!a[i+1]?.includes('=')){console.error('error: unexpected argument '+a[i]);process.exit(2)}
     }
     if(a.length%2!==0||a.at(-2)!=='features'||a.at(-1)!=='list'){console.error('error: expected features list');process.exit(2)}
   ```

   e) immediately after the line
   ```text
     if(s.featureWarning)console.error(s.featureWarning);
   ```
   insert
   ```text
     if(s.featureExit){process.stdout.write(s.featureStdout||'');process.exit(s.featureExit)}
   ```

   f) replace the line
   ```text
       console.log(name+' experimental '+(s.ignoredFeature===name?'true':(settings['features.'+name]||'true')));
   ```
   with
   ```text
       console.log(name+' experimental '+(s.malformedFeature===name?'false extra':s.ignoredFeature===name?'true':(settings['features.'+name]||'true')));
   ```

   g) immediately after the line
   ```text
   if(a[0]!=='exec')process.exit(91);
   ```
   insert
   ```text
   if(!a.includes('--ignore-user-config')){console.error('error: exec requires --ignore-user-config');process.exit(92)}
   ```

   h) immediately after the line
   ```text
               $script:observed=@([IO.File]::ReadLines($calls)|Where-Object{$_}|ForEach-Object{$_|ConvertFrom-Json})
   ```
   insert
   ```text
               $script:featureProbes+=@($observed|Where-Object{$_.argv-contains'features'})
   ```

   i) immediately after the lines
   ```text
               Join-Path $evidence $Name
           }
   ```
   insert
   ```text
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
   ```

   j) replace the line
   ```text
           foreach($state in @(@{missingFeature='memories'},@{ignoredFeature='multi_agent'},@{duplicateFeature='memories'},@{featureWarning='ignored unsupported setting tools.view_image'})){
   ```
   with
   ```text
           foreach($state in @(@{missingFeature='memories'},@{ignoredFeature='multi_agent'},@{duplicateFeature='memories'},@{featureWarning='ignored unsupported setting tools.view_image'},@{malformedFeature='memories'})){
   ```

   k) immediately after the lines
   ```text
               Assert-That 'missing/ignored native controls fail closed before model call' ($code-eq5-and!@($observed|Where-Object{$_.argv[0]-eq'exec'}).Count)
           }
   ```
   insert
   ```text
           $code=Invoke-Codex @{featureExit=23;featureStdout="synthetic partial feature output`n";featureWarning='synthetic native failure diagnostic'}
           $native=Get-Content (Get-CodexEvidenceFile 'native-controls.json') -Raw|ConvertFrom-Json
           Assert-That 'nonzero feature status refuses exec and retains complete native output and diagnostic' ($code-eq5-and!@($observed|Where-Object{$_.argv[0]-eq'exec'}).Count-and$native.exitCode-eq23-and$native.featureList-ceq"synthetic partial feature output`n"-and$native.diagnostics-ceq"synthetic native failure diagnostic`n")
   ```

   l) immediately after the line
   ```text
           Assert-That 'a relay override cannot bypass fixed controls' ($code-ne0-and!$observed.Count-and$codexOut-match'CODEX_RELAY_OVERRIDE_REFUSED')
   ```
   insert
   ```text
           Assert-That 'all feature calls use distinct initially empty task-temporary homes, including refusals' ($featureProbes.Count-gt1-and@($featureProbes|Where-Object{!$_.codexHomeSet-or$null-eq$_.featureHomeEntries-or$_.featureHomeEntries.Count-ne0-or!$_.codexHome.StartsWith($_.temp+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)}).Count-eq0-and@($featureProbes.codexHome|Sort-Object -Unique).Count-eq$featureProbes.Count)
           $sentinelsUnchanged=$true
           foreach($name in $sentinels.Keys){if([Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $originalHome $name)))-cne[Convert]::ToBase64String($sentinels[$name])){$sentinelsUnchanged=$false}}
           Assert-That 'original synthetic config and auth sentinel bytes remain unchanged' $sentinelsUnchanged
   ```

   m) replace the line
   ```text
       foreach($key in $savedEnvironment.Keys){[Environment]::SetEnvironmentVariable($key,$savedEnvironment[$key])}
   ```
   with
   ```text
       foreach($key in $savedEnvironment.Keys){if($null-eq$savedEnvironment[$key]){Remove-Item -LiteralPath "Env:$key" -ErrorAction SilentlyContinue}else{[Environment]::SetEnvironmentVariable($key,$savedEnvironment[$key])}}
   ```

   The resulting file's Git blob is d6fdf1bcdc1df28be816d5461ab4ebd18998ec12.

3. Check whether `lib/README.md` contains `Installed CLI 0.164.0 accepts`; if so record Already Applied when its Git blob is 4458b3a35dceb1213423e8f0a5e2d17f8a1d38fc, and otherwise stop and report. Otherwise make exactly this one edit (describe the bounded feature preflight and configuration-equivalence limit), each matched once, and change nothing else:

   a) replace the line
   ```text
   Engineering keeps D9 danger-full-access and existing command/network behavior, disables hosted web and requests approval never. `-Effort low|medium|high|xhigh` defaults to medium; current authors, deep work and reviews explicitly use xhigh. Both profiles use ignored user config, a clean child environment, memories off (feature plus use/generation), multi_agent=false, zero project document bytes and advisory arrival/private-read guidance. Existing memory files remain untouched. Research fixes Terra/xhigh, read-only, never approval, live hosted search, `features.shell_tool=false` and supported `features.view_image=false`. Explicit incompatible effort/family refuses. The fixed [relay](codex-relay.mjs) accepts no arbitrary configuration override or alternate dispatch. No-model feature preflight uses the same config source/directory and requires memories/multi_agent false, plus shell_tool/view_image false for research; raw positive/negative diagnostics are retained. Feature recognition proves neither supplemental settings nor effective runtime tools.
   ```
   with
   ```text
   Engineering keeps D9 danger-full-access and existing command/network behavior, disables hosted web and requests approval never. `-Effort low|medium|high|xhigh` defaults to medium; current authors, deep work and reviews explicitly use xhigh. Both profiles use ignored user config for exec, a clean child environment, memories off (feature plus use/generation), multi_agent=false, zero project document bytes and advisory arrival/private-read guidance. Existing memory files remain untouched. Research fixes Terra/xhigh, read-only, never approval, live hosted search, `features.shell_tool=false` and supported `features.view_image=false`. Explicit incompatible effort/family refuses. The fixed [relay](codex-relay.mjs) accepts no arbitrary configuration override or alternate dispatch. Installed CLI 0.164.0 accepts `--ignore-user-config` under exec only. No-model feature preflight uses the same working directory and fixed overrides, with a fresh empty task-temporary `CODEX_HOME` and no exec-only flag; no config/auth is copied, and exec retains its original environment/authentication home and flag. Temporary feature artifacts stay in scratch. The probe requires memories/multi_agent false, plus shell_tool/view_image false for research; raw positive/negative diagnostics, status and available errors are retained. This establishes native feature recognition only: configuration equivalence (including managed/profile/trust loading), supplemental settings, effective exec settings/tools and confinement remain unverified.
   ```

   The resulting file's Git blob is 4458b3a35dceb1213423e8f0a5e2d17f8a1d38fc.

## Acceptance Criteria

- [x] Relay output equals its declared resulting Git blob. check: blob:lib/codex-relay.mjs=eb60b15c9231f731d05b64858c16ed5df644fb8b
- [x] Owning test output equals its declared resulting Git blob. check: blob:lib/test-delegate.ps1=d6fdf1bcdc1df28be816d5461ab4ebd18998ec12
- [x] Catalogue output equals its declared resulting Git blob. check: blob:lib/README.md=4458b3a35dceb1213423e8f0a5e2d17f8a1d38fc
- [x] RESUME routing remains identical after only native pointer normalization. check: normalized-resume:RESUME.md=80E4319AB22909E36CDBDCEE4E0910835A6837D23B0C3E544E0FCAB0017B4AEE
- [x] Exact-source no-model installed-consumer evidence retains the historical unsupported feature invocation exit 2 and corrected features-list exit 0 with the required false rows. Bind native version/features and SYNTHETIC exec observations to the actual relay raw hash and stored blob; record zero actual model/hosted calls. This proves compatibility and native feature recognition, without claiming actual exec authentication or configuration equivalence.
- [x] Corrected synthetic positive controls pass for set and genuinely absent original CODEX_HOME. Feature attempts use distinct initially empty task-temporary directories without copied config/auth; the caller environment remains unchanged, exec keeps its original home presence/value and --ignore-user-config, and cwd/fixed overrides retain their prior meaning. Compare original binary sentinels and artifacts, including refused probes. Test unique identity across repeated attempts; native concurrency beyond supplied evidence remains a separately reported limit, not inferred from sequential success.
- [x] The strict fake feature parser rejects historical argv with exit 2 and accepts the corrected fixed -c pairs plus features list; synthetic exec refuses a missing original isolation flag. Missing/true/duplicate/malformed rows, ignored-setting diagnostics and nonzero status refuse before exec. Retain status/stdout/stderr/error and available signal/Error properties; deterministic missing-process, timeout, signal, allocation and evidence-write failures fail closed. Allocation failure has no native-controls artifact because no probe occurred. Mocked OS cases do not certify native Windows timeout behavior.
- [x] Preserve every preexisting owning assertion and expectation, fixed common/research controls, cache/version checks, evidence integrity, runtime event semantics, tripwire/spawn escalation and research stop boundary. Review semantic effects against the accepted baseline and bind all source/test artifacts. The exact candidate passes the owning delegate suite, Markdown owning/Working checks, changed PowerShell hazards, Node parsing and whitespace; preserve supplied failures and distinguish source-specific historical results from new results. Research-profile synthetic cases are not live research permission.
- [x] Independently exercise the bounded changed-policy mutation table below against a passing exact-source baseline. Each credited kill is behavioral with its input, expected/actual outcome, original/mutant raw hashes/blobs, artifacts and actual exits retained. Syntax, source-string, wrong-launch, broken-baseline or artifact-binding failures earn no semantic kill. No unrelated WS026 mutation rerun or exhaustive-control claim is required by this correction.
- [x] The original-root and sandbox-root lifecycles each satisfy their existing derived profiles, accepted evaluator/recipe, clean committed input, native headroom, leases and own absolute run_timed.ps1 with concurrent watch_run.ps1. Each authorized Finish owns one full tests.ps1 schedule and a separate fresh successful schema2 receipt with successful timed END and actual watcher evidence. Root also records the complete operational launch buffer (physical 5 GB / commit 8 GB) and required Watch-Host evidence; inadequate/unreadable resources block without killing unrelated work. No schedule or gate changes are proposed.
- [x] Original execution first binds an immutable successful sandbox receipt for the exact selected Draft, implementation fingerprint, evaluator and recipe, then earns its own original receipt. Independent live Review, Complete and accepted-baseline carrying-range judgment succeed for their actual subjects. Qualified release/publication/promotion and any new research proof retain their separate owning authorization/evidence. Neither AI agreement nor local/sandbox evidence waives a native failure or certifies another root.

## Review Gate

- [x] Fresh V2 adversarial and V3 evidence-refresh snapshots bind actual preceding frozen hashes and verified role model/effort under the WS031-only DELEGATED D55 substitution; V1 placeholders are never admitted or silently filled. Prototype, Design, Adversarial and Refresh remain distinct stages. No Claude or cross-provider work is invented.
- [x] Two distinct fresh reviewers inspect the SAME frozen selected candidate and exact outputs, line-by-line meaning, preserved assertions, bounded independent semantic mutants and source limitations. Record the existing agreement table/rebuttal (proposal, each position, ACCEPT/REVISE/BLOCK, evidence and reason). At most one material correction is allowed; its stage/version must have legitimate native support and fresh same-subject reviews. No unknown-version/gate bypass, endless revisions or V5; unresolved material dispute goes to the concise owner packet. Native failure blocks regardless of agreement.
- [x] Review actual literal replay/idempotence and unchanged-tree wrong-blob/anchor refusal controls, unsuppressed external context/admission, exact scoped outputs, source/test/evaluator/recipe bindings, both roots' timed/watched receipts, all acceptance evidence and independent live Review/Complete/range. Qualified release boundaries stay separate; record only observed role-specific results.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

No approval, allocation, activation, implementation or receipt is recorded by this V3 authoring snapshot. Append only through the native lifecycle. Future approval must append exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line with actual immutable identities; owner evidence binds the selected digest and physical root. A delegated decision must cite actual delegation and be labelled delegated. Original-role execution also appends exactly one Sandbox Receipt and Sandbox Receipt SHA256 identifying the immutable successful schema2 sandbox artifact for this exact selected Draft. Never invent or transplant these facts.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-031\package\assurance\V3\DRAFT.md
Approved SHA256: 656A92C8A81779EFAC91B9D1CA766EABD18B7D1083D97B52E4C9255FBC370F77
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-031\package\GATE1-WS031-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: 28E40260B221C4C1F5EB6B7FC6360AFE1C3BCB7348F00D1EF27F0F00B95EC96B
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-031\package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: C95FF88794B58BDB09134156D838C1C29C72E00EC384E18A91E4B4D893BC99B7
Original exact three declared outputs applied by accepted native Execute; fresh own Finish and independent Review/Complete remain required. Other protected roots unchanged; prior failed attempts retained.

## Verification Notes

PROVEN: V3 EVIDENCE REFRESH, 2026-10-29. Complete frozen V1/V2 Drafts/provenance and all three preloaded source files were read line by line. Actual V1 SHA256 A3D4AE2F0BD1F4F4B61CDB0DC0611F832A8AD0581C399B83B7479937F7B01581 and V2 SHA256 EA50CAC55FD13713342D204475B0DD93391F58C8FD9E7B91A3B44154052CC1D5 match their provenance/manifests. Supplied provenance reports gpt-6.1-sol/xhigh for both stages; actual V3 runtime corroboration remains launcher-owned. WS031-only D54/D55 are honestly DELEGATED bootstrap/substitution after Claude API429 weekly-quota refusal before child/tokens/source. No Claude or provider independence is claimed. Earlier V3 thread 01a188da-057a-7f42-8a0b-76890bddc41e failed at provider limit before authoring the four required files; that attempt stays separate/failed. This is the same unfinished V3, not V4.

PROVEN: All three actual raw hashes, filtered blobs and accepted HEAD/index bindings agree with frozen V1/V2 provenance/manifests. No material source defect was reproduced and no engineering source was changed. Baseline, complete native template, EXACT4 scope, execution context, literal steps, acceptance and review sections remain identical. RESUME is native pointer-only. The compatibility correction omits the exec-only flag solely from feature argv, creates an initially empty home per call, spreads the caller environment, retains fixed overrides/cwd and leaves exec home/flag/dispatch intact. Evidence serializes status/stdout/stderr/message/signal/own Error properties before refusal. Allocation/write failures follow exit 5. No cleanup, driver, workflow or trusted-state change is introduced.

PROVEN (supplied root command observations only): ROOT-PROTOTYPE-CHECKS.json/QUALIFICATION.json report six exit-0 checks including 131 owning assertions, owning/Working Markdown, changed PS hazards, Node parser and whitespace. Their prototype-manifest digest matches frozen V1's retained identity; original prototype pack/raw logs are not supplied. ROOT-NATIVE-TRANSPORT.json binds this exact relay to REAL native version/features, feature exit 0/relay exit 0, fresh feature home and SYNTHETIC exec retaining original home/flag, zero actual model/hosted calls. Native historical unsupported-feature exit 2 remains indirect V1/D54 attribution without its raw diagnostic here. No installed CLI rerun or actual model/authentication proof occurred. Author-reported Prototype 14-focused/six-mocked checks and earlier 123 assertions remain indirect historical attributions, not newly observed outcomes.

PROVEN (reused literal evidence): ROOT-V1-LITERAL.json binds actual V1, three exact blobs, idempotent unchanged tree and wrong-blob/anchor-drift exit 1 with no writes. ROOT-V2-REUSE-AND-CONTEXT.json records identical protected sections and unsuppressed structural context parsing, not live admission. The complete literal program remains identical in V3; reuse supports that program/output subject, not a fresh V3 replay/admission or receipt. Successful unchanged-source owning/literal/semantic runs were not repeated for a new Draft.

PROVEN (supplied V2 synthetic execution, verified artifact bindings): V2-MUTATION-HARNESS.mjs SHA256 C4A76F147E65767B4F17FA52EA533D131FB44C957AC7C494686FA9F30A0C652B and mutation-run-X5qZFc-results.json SHA256 19F3284FD150B0D57C8BAFA581D3431BAD0010B98BD103CB470815466A038D5A bind actual relay 25BDEA812BD42802E5B27A57CF7815291B9CC0C408E0A8243B65F2478226E5EE / eb60b15c9231f731d05b64858c16ed5df644fb8b. The author command node work/WS031/V2/mutation-harness.mjs is recorded exit 0; ROOT-V2-CONTROLS.json corroborates nine passing originals and ten behavioral kills. V3 reconstructs all ten full/extracted subjects plus original extraction in memory using the supplied pure mutation/extraction definitions and compares raw/filtered identities against report, frozen V2 manifest and root observations. Original run modules are absent; reconstructed bytes match, without claiming to have reread absent files or rerun their behavior. Parser exits 0 are supplied results; syntax/hash failures earn no kill. Actual V3 reconstruction/report-check command node --input-type=module - exits 0 only after those comparisons and raw report expected/observed/difference checks succeed; details are external in SOURCE-MANIFEST.json.

| Control | Passing original -> recorded mutant behavior |
|---|---|
| C1 unsupported feature flag | Feature 0/relay 0 -> strict fake feature 2/relay 5, no exec. |
| C2 inherited home | Distinct empty homes -> caller config/auth sentinel entries and reused identity; valid rows/exec still succeed. |
| C3 in-place environment mutation | Caller object/exec home retained -> both change, while probe/exec succeed. |
| C4 process-local home cache | Two actual main/probe calls in one VM: distinct empty homes -> same home, second includes probe-residue; both dispatches still succeed. |
| C5 config/auth copy | Empty initial home -> synthetic sentinel entries, while caller sentinel bytes and feature/exec success remain. |
| C6 removed exec flag | Feature success; synthetic exec/relay 0 -> 92. |
| C7 removed status guard | Status 23 WITH valid required false rows and benign stderr: original relay 5/no exec -> mutant relay 0/exec 0. |
| C8-own-error | ENOENT own Error properties retained -> null; message/signal checks intact, refusal stays 5. |
| C8-message | ETIMEDOUT message retained -> null; own properties/signal checks intact, refusal stays 5. |
| C8-signal | Signal-only SIGKILL retained -> null; no Error, refusal stays 5. |

PROVEN: Nine originals include repeated set-home Windows serialization, absent-home POSIX, research controls, valid-row status23, ENOENT, ETIMEDOUT, signal-only, allocation and evidence-write failure. Allocation has zero probes/evidence; failed evidence write has one probe/zero evidence; both refuse 5/no exec. The owning partial-row status case alone cannot kill C7 and separate relay processes alone cannot kill C4; supplied actual-slice same-VM comparisons address those bounded gaps. Ten kills cover only C1-C8 with three independent C8 variants. Every preexisting owning assertion/expectation remains in unchanged source; no unrelated 47-mutant rerun, production driver or exhaustive-control claim. Synthetic OS/CLI/results do not measure real Windows timeout, concurrent filesystem/ACL behavior or live research permission.

PROVEN (failures preserved): Frozen V1/V2 notes retain initial discovery, scope-order generator and inline scope-verifier expression failures separately from corrected checks. Initial Prototype unset-home 13/14 and controller failures remain indirect historical reports. Historical Terra LIVE_SEARCH_PASS_CONTROL_CONFIGURATION_FAILED for ignored tools.view_image and the earlier V3 provider-limit attempt stay failed. Neither repetition nor a later success marker establishes qualification. V3 source inspection had a no-match rg exit 1 and truncated displays, no test credit; complete required reads used bounded chunks.

HYPOTHESIS: Retain the minimum compatible source. Meaning, bound root observations and targeted synthetic comparisons support its compatibility objective; no reproducible material rejection earns a source correction. A later finding needs a defect, mandatory requirement, test/security result or named gate. Material rejection blocks through owning correction/escalation, with at most ONE legitimately supported corrective round and fresh same-subject reviews; no enum bypass, endless drafts or V5. Changed source invalidates older-source PASS and requires identifying affected checks before refresh.

UNVERIFIED: Feature/exec managed/profile/trust configuration equivalence, supplemental enforcement, effective settings/tools, actual model authentication, complete event visibility, private-read/network confinement and spawn prevention. Initial fresh CODEX_HOME isolates that directory only; later contents may change. D9 shell/network rights, guidance, tripwires, requested memories-off/multi_agent flags and no observed spawning prove no confinement. No private identity path was followed. No global configs, runtime dispatch, accounts, privileges or trusted state changed.

PROVEN (historical advisory source review only): The supplied HISTORICAL-TERRA-SOURCE-PACK.md was read locally 2026-10-29; its reported original access is 2026-10-28. OpenAI Configuration reference (https://developers.openai.com/codex/config-reference) and Config basics (https://developers.openai.com/codex/config-basic), publisher OpenAI, unspecified publication/version date, mutable vendor documents, influence configuration precedence/uncertainty only. Anthropic CLI reference (https://code.claude.com/docs/en/cli-reference; reported threshold v2.1.248) and Custom subagents (https://code.claude.com/docs/en/sub-agents), publisher Anthropic, otherwise unspecified publication/version, mutable vendor documents, influence preserved tool/read cautions. Final/draft standard status: not standards; vendor documentation only. No source was fetched/requalified. Its tools.view_image recommendation was contradicted by the preserved ignored-control failure and is not reintroduced. Research/F6 remain stopped/unqualified pending separate owning qualification, explicit permission, sanitized material, actual tool/read boundary and stop decision.

PROVEN: V3 generation reuses the frozen complete literal program, binds actual preceding hashes, compares every protected section, complete template headings, exact output declarations and four unique machine checks using accepted text parsers only. Runtime remains 1/None/0; all acceptance/review boxes remain unchecked. The manifest holds final Draft hash externally, source/provenance/evidence/new artifact identities, command outcomes, report baseline/mutant results and reconstructed subjects; there is no Draft/manifest self-hash. No successful unchanged generation/check is repeated. This is no native context/admission, approval, implementation or certification.

UNVERIFIED / exact next handoff: Launcher preserves/freezes all four V3 artifacts at existing declared assurance identities, corroborates actual V3 model/effort and obtains TWO distinct fresh reviewer sessions for the SAME frozen V3 and exact outputs, with the existing agreement table/rebuttal. Then exact delegated root-bound Gate, formal protected-root before baseline, separate sandbox then original native timed/watched/host Finish, independent Review/Complete/carrying-range and qualified release. Each authorized root owns one full tests.ps1 schedule, derived CONTROL/REPOSITORY profiles, evaluator/recipe, clean committed input, leases/headroom and a separate fresh successful schema2 receipt/timed END/watcher evidence. Original first binds the immutable exact-Draft successful sandbox proof and then earns its own receipt. Native minima 1.5 GB physical/3 GB commit and operational buffer 5/8 GB plus Watch-Host remain root-owned. No raw full suite, blind Finish retry, native failure waiver, invented Gate/receipt or release permission. Only actual live native review may append Verdict: Confirmed Complete, Reviewed Fingerprint and Reviewed Receipt. Research stays separately stopped.
Verdict: Confirmed Complete
Reviewed Fingerprint: 3454E3B57341FB70797625D19C3625ECAE75D0220218E9964C5204F4AB224DF3
Reviewed Receipt: 477AAA5AAD05E135A42ADFB0167F4251186E8B3253A39D9A472501271E423C24
Live ORIGINAL-role review: runtime/original/criterion-review.json. Own Finish27 ordered suites, timed runner/watcher/host0/0/0 and journal unchanged. Other five protected roots/raw states and historical evidence preserved; original changes limited to admitted three outputs/contract/pointer/index/new receipt. Host-managed ref drift recorded separately. Exact completed sandbox proof 7DF0195FCB14D64F524C796448E77352E885792DEB32B7364D193EBA371BDFC5 and separate original own receipt verified against shared recipe/fingerprint/evaluator. Two fresh same-subject reviews ACCEPT under WS031-only D54/D55, no Claude/provider-independence claim. No material correction consumed. Synthetic injected timeout-error retention is not watchdog timing; native configuration equivalence/tools/read confinement remain unproven. Failed provider attempts and historical research control proof stay FAILED. Own native Complete/carrying range remain checked; qualified hosted release/publication/promotion and any research proof retain separate gates. CTRL19 OPEN; clean-machine recovery UNPROVEN; sensitive staging retained; owner Lift/cleanup reserved.

