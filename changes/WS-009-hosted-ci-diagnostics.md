# Workbench Change Request - WS-009

## Status

[x] Draft
[ ] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Make a hosted CI child or observer failure name itself: on failure only, the existing CI entry prints each actual child exit, the runner's own bounded timed log and a failed watcher's output, credential-masked before sanitization and truncation, then prefixed, before its unchanged WB_CI_CHILD_OR_OBSERVER_FAILED refusal. Success output, exit codes, schedule, CI_TEST_ONLY classification and workflow policy stay unchanged.

## Baseline

1d09f7c24830368bb8d867742565373509f2aecd

## Write Scope

- RESUME.md
- lib/Workbench.ps1
- lib/test-workbench-governance.ps1

## Out of Scope

All other engineering files, the workflow and its policy, tests.ps1 schedule, run_timed/watch_run, receipts, artifact upload, products, OMC state/configuration, trusted/Data roots, original execution without exact Gate 1, publication/rerun/promotion/settings, completed WS005-008/010 replay, Batch 6 and Phase 8. CTRL-19 remains OPEN. Normal legal lifecycle allocation/pointer only.

## Draft Assurance

V1: WS009-PRIVACY-R2-V1-20261025 | 2026-10-24 | C:\Users\My Lab\Documents\ORVION-Owner-Review\ws009-privacy-successor-20261025-r2\assurance\V1\DRAFT.md | E9626EE02FD18C47E58E9BA557419E820ADB2084B4BEDDB08C04778C4816755E
V2: WS009-PRIVACY-R2-V2-20261025 | 2026-10-24 | C:\Users\My Lab\Documents\ORVION-Owner-Review\ws009-privacy-successor-20261025-r2\assurance\V2\DRAFT.md | 3FF59492695AB18D722592C227F24E44D65197147A4DEC86C1C416BEC5F5325D
V3: WS009-PRIVACY-R2-V3-20261025 | 2026-10-24 | C:\Users\My Lab\Documents\ORVION-Owner-Review\ws009-privacy-successor-20261025-r2\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSp2
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSp2\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSp2\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\ws009-privacy-successor-20261025-r2\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/Workbench.ps1` contains `Hide-WorkbenchCIDiagnostic`; if so record Already Applied when its Git blob is 5c37d45e55cf7dfed50796cc73aa782588850bfa, and otherwise stop and report. Otherwise make exactly this one edit (failure-only bounded diagnostics with accepted credential masking before sanitization, truncation and output), each matched once, and change nothing else:

   a) replace the line
   ```text
                   if(@($children|Where-Object{$_.Process.ExitCode-ne0}).Count){throw 'WB_CI_CHILD_OR_OBSERVER_FAILED'}
   ```
   with
   ```text
                   if(@($children|Where-Object{$_.Process.ExitCode-ne0}).Count){
                       # Failure only: actual exits, the runner's own timed log and a failed watcher's output, bounded.
                       # Controls are replaced and every line is prefixed, so replayed text cannot form a runner workflow command.
                       # Same bounded vocabulary as watch_run.ps1 Hide-Secret; its top-level watcher cannot be imported here.
                       # Mask each complete raw line before sanitizing, truncating or printing it; raw runtime logs stay local.
                       function Hide-WorkbenchCIDiagnostic([string]$diagnosticLine) {
                           $t = $diagnosticLine -replace '\b(gh[pousr]_[A-Za-z0-9]{20,}|github_pat_\w{20,}|sk-[A-Za-z0-9_-]{20,}|eyJ[\w-]{10,}\.[\w-]{10,}\.[\w-]+)', '<redacted>'
                           $t = $t -replace '(?i)\bbearer\s+(?!<redacted>)\S+', 'Bearer <redacted>'
                           $t -replace '(?i)\b(token|secret|password|passwd|api[_-]?key|authorization)(\s*[:=]\s*)(?!Bearer <redacted>)(?!<redacted>)\S+', '$1$2<redacted>'
                       }
                       foreach($child in $children|Sort-Object Role){'CI_CHILD: '+$child.Role+' exit='+$child.Process.ExitCode}
                       foreach($source in @(@('CI_LOG','ci.log',400),@('CI_WATCHER','watcher.log',40))){
                           if($source[0]-ceq'CI_WATCHER'-and@($children|Where-Object{$_.Role-ceq'watcher'})[0].Process.ExitCode-eq0){continue}
                           try{$lines=@([IO.File]::ReadAllLines((Join-Path $CIRuntimeRoot $source[1]))|Select-Object -Last $source[2]);if(!$lines.Count){$lines=@('<empty>')}}catch{$lines=@('<unreadable>')}
                           foreach($line in $lines){$text=Hide-WorkbenchCIDiagnostic $line;$text=$text-replace'[\x00-\x08\x0A-\x1F\x7F-\x9F\u2028\u2029]','?';$source[0]+': '+$text.Substring(0,[Math]::Min(2000,$text.Length))}
                       }
                       throw 'WB_CI_CHILD_OR_OBSERVER_FAILED'
                   }
   ```

   The resulting file's Git blob is 5c37d45e55cf7dfed50796cc73aa782588850bfa.

2. Check whether `lib/test-workbench-governance.ps1` contains `CI privacy`; if so record Already Applied when its Git blob is 2c42183e6eedd933d29b5ed6e09e678d3d46781e, and otherwise stop and report. Otherwise make exactly these 4 edits (causal synthetic privacy tests and existing actual CI child/observer/success checks), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   function Test-CICapability {
   ```
   insert
   ```text
       # WS009 privacy: exercise the literal failure block with synthetic logs independently of the watcher.
       $diagnosticText=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Workbench.ps1'))
       $parseTokens=$null;$parseErrors=$null
       $diagnosticAst=[Management.Automation.Language.Parser]::ParseInput($diagnosticText,[ref]$parseTokens,[ref]$parseErrors)
       $diagnosticBlocks=@($diagnosticAst.FindAll({param($node) $node-is[Management.Automation.Language.IfStatementAst]-and$node.Extent.Text.StartsWith('if(@($children|Where-Object{$_.Process.ExitCode-ne0}).Count)')},$true))
       if($parseErrors.Count-or$diagnosticBlocks.Count-ne1){throw 'CI_DIAGNOSTIC_BLOCK_NOT_UNIQUE'}
       $diagnosticBlock=[scriptblock]::Create("param(`$children,`$CIRuntimeRoot)`n"+$diagnosticBlocks[0].Extent.Text)
       $fakeGh='gh'+'p_'+('Ab3'*12);$fakePat='github_'+'pat_'+('Cd4_'*9);$fakeApi='sk'+'-'+('Ef5_'*9)
       $fakeJwt='eyJ'+('a'*12)+'.'+('b'*15)+'.'+('c'*15);$fakeBearer='SyntheticBearerValue';$fakeNamed='SyntheticNamedValue'
       $privacyRoot=Join-Path $ownedRoot 'privacy';[void][IO.Directory]::CreateDirectory($privacyRoot)
       $credentialLine="FAIL assertion expected=42 actual=41 trace=$fakeGh pat=$fakePat api=$fakeApi jwt=$fakeJwt Authorization: Bearer $fakeBearer password=$fakeNamed"
       $privacyCases=[ordered]@{assertion=$credentialLine}
       $privacyCases['boundary']=('x'*1994)+' '+$fakeGh+' tail'
       $privacyCases['named-boundary']=('x'*1986)+' API_KEY='+$fakeNamed+' tail'
       foreach($case in $privacyCases.Keys){
           $dir=Join-Path $privacyRoot $case;[void][IO.Directory]::CreateDirectory($dir)
           Write-FixtureFile (Join-Path $dir 'ci.log') ($privacyCases[$case]+[char]10)
           Write-FixtureFile (Join-Path $dir 'watcher.log') $credentialLine
           $children=@([pscustomobject]@{Role='runner';Process=[pscustomobject]@{ExitCode=1}},[pscustomobject]@{Role='watcher';Process=[pscustomobject]@{ExitCode=7}})
           $captured=[Collections.Generic.List[string]]::new();$refusal=''
           try{& $diagnosticBlock $children $dir|ForEach-Object{$captured.Add([string]$_)}}catch{$refusal=$_.Exception.Message}
           $text=$captured-join[char]10
           $leaked=@(@($fakeGh,$fakePat,$fakeApi,$fakeJwt,$fakeBearer,$fakeNamed)|Where-Object{$text.Contains($_)})
           Assert-Fixture ('CI privacy '+$case+' masks both log sources before output and preserves refusal/exits') ($leaked.Count-eq0-and$text.Contains('<redacted>')-and$refusal-ceq'WB_CI_CHILD_OR_OBSERVER_FAILED'-and$captured[0]-ceq'CI_CHILD: runner exit=1'-and$captured[1]-ceq'CI_CHILD: watcher exit=7')
           if($case-ceq'assertion'){Assert-Fixture 'CI privacy retains ordinary assertion context' ($text.Contains('FAIL assertion expected=42 actual=41'))}
           if($case-ceq'boundary'){Assert-Fixture 'CI privacy never leaks a truncated token prefix' (!$text.Contains($fakeGh.Substring(0,5)))}
           if($case-ceq'named-boundary'){Assert-Fixture 'CI privacy never leaks a truncated named value' (!$text.Contains($fakeNamed.Substring(0,4)))}
       }
       foreach($case in 'missing','empty','locked','malformed'){
           $dir=Join-Path $privacyRoot $case;[void][IO.Directory]::CreateDirectory($dir)
           $log=Join-Path $dir 'ci.log';$handle=$null
           if($case-in@('empty','locked')){Write-FixtureFile $log ''}
           if($case-ceq'locked'){$handle=[IO.File]::Open($log,'Open','ReadWrite','None')}
           if($case-ceq'malformed'){[IO.File]::WriteAllBytes($log,[byte[]](0xC3,0x28,0xFF,0x07,0x0A,0x41))}
           $captured=[Collections.Generic.List[string]]::new();$refusal=''
           try{try{& $diagnosticBlock $children $dir|ForEach-Object{$captured.Add([string]$_)}}catch{$refusal=$_.Exception.Message}}finally{if($handle){$handle.Dispose()}}
           $text=$captured-join[char]10
           $expected=if($case-ceq'empty'){'CI_LOG: <empty>'}elseif($case-in@('missing','locked')){'CI_LOG: <unreadable>'}else{'CI_LOG: '}
           Assert-Fixture ('CI privacy '+$case+' log retains fixed failure and safe fallback') ($refusal-ceq'WB_CI_CHILD_OR_OBSERVER_FAILED'-and$text.Contains($expected)-and$text-cnotmatch'[\x00-\x08\x0B-\x1F\x7F-\x9F\u2028\u2029]')
       }

   ```

   b) immediately after the line
   ```text
       Assert-Fixture 'CI actual terminal-None caller owns exactly one successful timed/watched schedule' ($positive.Exit-eq0-and$ciResult.Result-ceq'READY'-and$ciResult.Certification-eq$false-and$ciResult.Recipe-ceq$ciRecipe.Digest) $positive
   ```
   insert
   ```text
       Assert-Fixture 'CI actual success prints no failure diagnostics' ($positive.Output-cnotmatch'CI_CHILD:|CI_LOG:|CI_WATCHER:') $positive
   ```

   c) replace the line
   ```text
           if($scenario-ceq'child-exit'){Write-FixtureFile (Join-Path $mutantCI 'lib/test-synthetic.ps1') "'PASS forged green child'`nexit 7`n"}
   ```
   with
   ```text
           if($scenario-ceq'child-exit'){Write-FixtureFile (Join-Path $mutantCI 'lib/test-synthetic.ps1') "'PASS forged green child'`n'::error::forged workflow command'`n`"``e[31mforged ansi``a bell`"`n'FAIL assertion expected=42 actual=41 trace=$fakeGh password=$fakeNamed'`nexit 7`n"}
   ```

   d) immediately after the line
   ```text
           Assert-Fixture ('CI actual '+$scenario+' cannot become success') ($failure.Exit-ne0-and$failure.Output-match$expectedFailure-and!(Test-Path -LiteralPath (Join-Path $mutantRuntime 'ci-result.json'))) $failure
   ```
   insert
   ```text
           if($scenario-ceq'child-exit'){Assert-Fixture 'CI child failure names both exits, the failing test and its detail without raw workflow commands or controls' ($failure.Output-cmatch'(?m)^CI_CHILD: runner exit=1\r?$'-and$failure.Output-cmatch'(?m)^CI_CHILD: watcher exit=1\r?$'-and$failure.Output-cmatch'(?m)^CI_LOG: .*FAIL test-synthetic\.ps1'-and$failure.Output-cmatch'(?m)^CI_LOG: .*::error::forged workflow command'-and$failure.Output-cmatch'(?m)^CI_LOG: .*forged ansi\? bell'-and$failure.Output-cmatch'(?m)^CI_WATCHER: '-and$failure.Output-cnotmatch'(?m)^::'-and$failure.Output-cnotmatch'\x1B') $failure}
           if($scenario-ceq'child-exit'){Assert-Fixture 'CI actual child assertion redacts credentials and retains assertion context' ($failure.Output.Contains('FAIL assertion expected=42 actual=41')-and$failure.Output.Contains('<redacted>')-and!$failure.Output.Contains($fakeGh)-and!$failure.Output.Contains($fakeNamed)) $failure}
           if($scenario-ceq'watcher-exit'){Assert-Fixture 'CI observer failure names its own exit beside the runner log' ($failure.Output-cmatch'(?m)^CI_CHILD: runner exit=0\r?$'-and$failure.Output-cmatch'(?m)^CI_CHILD: watcher exit=7\r?$'-and$failure.Output-cmatch'(?m)^CI_LOG: .*END exit=0 '-and$failure.Output-cmatch'(?m)^CI_WATCHER: ') $failure}
   ```

   The resulting file's Git blob is 2c42183e6eedd933d29b5ed6e09e678d3d46781e.

## Acceptance Criteria

- [ ] Failure-only bounded diagnostics with supported credential masking in the existing CI entry. check: blob:lib/Workbench.ps1=5c37d45e55cf7dfed50796cc73aa782588850bfa
- [ ] Existing owning CI tests prove both exits, assertion context, supported synthetic credential masking in both sources before truncation, missing/empty/locked/malformed logs, control replacement, no raw workflow command and silent success. check: blob:lib/test-workbench-governance.ps1=2c42183e6eedd933d29b5ed6e09e678d3d46781e
- [ ] RESUME authority body unchanged. check: normalized-resume:RESUME.md=1F392B6A18CC44442BCABE3E23BF82571975C585E8C70496881136170FECE520
- [ ] The refusal code, exit 1, success output, ordered test/hazard schedule, CI_TEST_ONLY result, workflow policy and receipt rules are unchanged. No new file, dependency, artifact upload or workflow step is added.
- [ ] This role owns one fresh timed/watched Finish, live independent Review, native Review/Complete and whole carrying-range judgment. Sandbox proof is not original approval or certification. The hosted root cause remains UNPROVEN until a separately approved hosted run.

## Review Gate

- [ ] Observe scoped bytes, unchanged ordered tests and hazards, red/green owning evidence and preserved original state; no OMC change.
- [ ] Observe this role's own receipt, correct root/Draft/evaluator/recipe, actual timed END and concurrent watcher/host exits before Review/Complete. Check accepted implementation range before Review and complete carrying range afterward; clean final tree and active None.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Isolated preparation only. Synthetic exact-root sandbox approval is permitted only in the independent rehearsal; it grants no original or remote authority. No original Gate 1 exists.

## Verification Notes

No future certification is asserted. The first privacy frozen Draft 100B6A33F6E12674754FD79A75B36EC89D8745F25BE2B1C3C776F741468ED0CB was refused at native sandbox approval because its Cairo date was ahead of UTC. That immutable Draft and failed sandbox remain preserved separately. This successor corrects assurance chronology and uses a new independent context; implementation bytes and causal proof are unchanged. This independently identified successor supersedes historical V3 78CEE7218D931663C558DEEF68DC89FECE0BDA7066586C175AA860D7B2422783 for selection only, never rewrites its evidence or treats it as approval. Native CAG/SACI/PICF and the frozen workflow policy remain unchanged. The role owns a fresh sandbox Finish for these changed recipe inputs. Plan v1.6 and architecture v1.5 remain unchanged.

Known masking coverage is exactly the accepted watch_run Hide-Secret vocabulary: GitHub prefixed tokens, github_pat, sk-prefixed API keys and JWT shapes; Bearer values; non-whitespace values following token, secret, password, passwd, api_key/api-key or authorization with colon/equal. Full raw lines are masked before sanitization, the 2000-character cut and output. Both CI_LOG and failed CI_WATCHER are covered. This is not universal secret detection: unlabelled credentials outside these shapes, whitespace-containing or split/encoded values and new token formats can remain. False positives are possible. Raw runtime files remain unredacted local evidence; no artifact upload is introduced. Output remains last 400 ci.log lines and 40 failed-watcher lines, at most 2000 characters per payload line; ReadAllLines still reads the full raw log before tail selection (not a memory bound).

## Selection reasons and sources

Selected WS009-PRIVACY-R2 V3: Design: reuse exact accepted watcher masking vocabulary as a local failure-only equivalent. Importing watch_run would execute its top-level observer. Whole raw lines are masked before sanitization and output; direct assertion and actual child tests cover both sources. Adversarial review: token and named-value shapes crossing the 2000-character cut can leak a partial prefix if truncation is moved before masking. Add causal boundary cases for both; implementation remains the smallest equivalent. Evidence refresh: expand native owning tests to missing, empty, exclusively locked and malformed UTF-8 logs. Refresh literal-source causal negatives, controls, bounds, exact exits and success behavior before freezing. No new helper file or watcher-library refactor.

Evidence: red.log has six privacy failures against historical V3; green.log has zero failures using corrected bytes and identical new tests. Both preserve actual nonzero CI failure and quiet CI_TEST_ONLY success. The independently executed literal-source security probe supplies the wider bounds/controls/exits evidence. Native literal Plan/apply and independent evaluator admission remain required after freeze. Original OMC state never enters this proposal; its separately authorized relocation does not grant source approval.

Sources: accepted lib/watch_run.ps1 Hide-Secret (exact three regex replacements); historical WS009 V1/V2/V3 sealed packet and 39 probes at C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-ci-diagnostics-20261024; this packet red.log, green.log and probes/security; native WORKFLOW.md and lib/Test-WorkbenchChange.ps1. Importing watch_run.ps1 would execute its top-level observer, so the two-file scope uses its narrowly equivalent local function without a new library, framework, dependency or policy change.

Known masking coverage is exactly the accepted watch_run Hide-Secret vocabulary: GitHub prefixed tokens, github_pat, sk-prefixed API keys and JWT shapes; Bearer values; non-whitespace values following token, secret, password, passwd, api_key/api-key or authorization with colon/equal. Full raw lines are masked before sanitization, the 2000-character cut and output. Both CI_LOG and failed CI_WATCHER are covered. This is not universal secret detection: unlabelled credentials outside these shapes, whitespace-containing or split/encoded values and new token formats can remain. False positives are possible. Raw runtime files remain unredacted local evidence; no artifact upload is introduced. Output remains last 400 ci.log lines and 40 failed-watcher lines, at most 2000 characters per payload line; ReadAllLines still reads the full raw log before tail selection (not a memory bound).
