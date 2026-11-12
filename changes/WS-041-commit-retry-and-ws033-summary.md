# Workbench Change Request - WS-041

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Land Batch 6 BP-21 and the WS-033 P9.1 report, with the scope of data/records/WS-041/CONTRACT.md section 3: lib/Invoke-ContractStage.ps1 retries the native commit once when the repository's own commit hook refuses with the named transient class already retried for the read-only Boot (`SUBJECT: github:PUBLIC_READ:GIT_TIMEOUT` or `CODE: GIT_FETCH_FAILED` on a line of its own) and HEAD is unchanged, so the refusal wrote nothing; a second refusal stands; lib/test-native-stage.ps1 proves it with three cases; records/WS-033/README.md holds the WS-033 summary and final report A-I, added through lib/Organize.ps1 -New (its records/README.md and docs/history/LOG.tsv rows); changes/README.md gets the WS-041 row Organize -Refresh writes. Benefit: a transient GitHub refusal inside a CRM or ORVION commit hook costs one retry instead of a stopped slice (12 such refusals 2026-11-08..12), and WS-033 closes with its report.

Tier: Routine under DEC-12: an established pattern (the same named class is already retried once in the same file for the Boot and the approve fetch, WS-040, DEC-33 rule 8), no new permanent control, no change to authority, the Workbench lifecycle controller, security or the evaluator; the product repository's own hook still decides every commit; the test change keeps every assertion. One Claude Draft whose three passes are one line each, no Codex and no mutant campaign. Authority: DEC-02, DEC-08, DEC-09, DEC-12, DEC-23, DEC-24, DEC-25 and DEC-33; the owner's words of 2026-11-12 ~13:27 Cairo ("I agree, on the condition that your work meets your own standard of satisfaction and also complies with the rules of the constitution."), answering the question to approve BP-21 and the P9.1 report as one Routine Workbench contract, frozen in data/records/WS-041/owner-words/decisions-inbox-20261112T1332.md. Every scope choice is Claude main's under that authority, labelled DELEGATED; no owner text is typed by an agent (DEC-02).

Number: WS-041. Intended contract: changes/WS-041-commit-retry-and-ws033-summary.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: this contract changes neither lib/Invoke-ContractLifecycle.ps1 nor the accepted evaluator, so both roles run the Original's own baseline controller, its SHA256 checked before each stage, with the accepted judge. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

839e9468a23b27d910eedbe5053ac4f7cb4c3961

## Write Scope

- changes/README.md
- docs/history/LOG.tsv
- lib/Invoke-ContractStage.ps1
- lib/test-native-stage.ps1
- records/README.md
- records/WS-033/README.md
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Organize.ps1, lib/Events.ps1, lib/Save-State.ps1, tests.ps1 and every other lib/ file, test and hook; every DEC entry; the Boot and fetch retries' behaviour (only the Boot line's pattern moves into the shared `$transient`); data/ (untracked); the seven legacy folders, Owner-Tools, the vault and every package; any CRM or ORVION change (DEC-08), credentials, real sessions or events (DEC-09); Batch 6 slice 8 (on hold until the owner authorizes it); Codex, subagents, RAM, power or scheduled-task changes; any push or release before both roles are Complete (DEC-25).

## Draft Assurance

V1: WS041-V1-CLAUDE-ROUTINE-DESIGN-20261112-01 | 2026-11-12 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-041\assurance\V1\DRAFT.md | 60D2DFD2A2C625CC68D9D9C60A50765D8E4F9B2F159CB2994B505324A58556E5
V2: WS041-V2-CLAUDE-ROUTINE-ADVERSARIAL-20261112-01 | 2026-11-12 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-041\assurance\V2\DRAFT.md | 2C88CB0115655565C7CD30AC8C0926905FE12E675972FD193F4B1D89BA131A09
V3: WS041-V3-CLAUDE-ROUTINE-REFRESH-20261112-01 | 2026-11-12 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-041\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

Routine tier (DEC-12): one Claude Draft whose three passes are one line each, frozen as the evaluator's three snapshots; author Claude main, claude-opus-5-5; no Codex (not part of the Routine tier; also skipped by the owner, D120) and nothing here is independent.
V1 pass 1, design: the scope of data/records/WS-041/CONTRACT.md section 3 from the frozen candidate.
V2 pass 2, adversarial: read against the stage tool's callers and the hook fixture; the retry fires only on the named class with HEAD unchanged, a second refusal stands, other codes are not retried; no content change needed, recorded as such (DEC-13: differences are never manufactured).
V3 pass 3, evidence refresh: V1's check PASS on the replay (37, 361, 154 and 45 PASS; hazards 0; gitleaks 0) and DEC-33 rule 8 as in force; no content change; selected.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W41\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W41\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W41\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W41\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none. PowerShell 7.6.8 is the portable host in ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8, which WS-034 and WS-040 ran.

1. Check whether `changes/README.md` contains `| WS-041-commit-retry-and-ws033-summary.md | contracts | Workbench Change Request - WS-041 | - | - |`; if so record Already Applied when its Git blob is 55b83995d64e6417ffee4b9a9514c93c368d3f8f, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-041 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-040-carried-cancel-retry-and-constitution.md | contracts | Workbench Change Request - WS-040 | - | - |
   ```
   insert
   ```text
   | WS-041-commit-retry-and-ws033-summary.md | contracts | Workbench Change Request - WS-041 | - | - |
   ```

   The resulting file's Git blob is 55b83995d64e6417ffee4b9a9514c93c368d3f8f.

2. Check whether `docs/history/LOG.tsv` contains `2026-11-12T11:29:40Z	new	workbench	-	records/WS-033	WS-041	WS-033 P9.1 summary	877BC7876200B0979876C6A65F97241D99D61F3A101906737E86DF8525684118`; if so record Already Applied when its Git blob is e58ffe5f67a751a2b107473d85ee8fc93108f881, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-041 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   2026-11-07T15:37:55Z	delete	temporary	scratch/ws029-v3/runtime-probe/stderr.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   ```
   insert
   ```text
   2026-11-12T11:29:40Z	new	workbench	-	records/WS-033	WS-041	WS-033 P9.1 summary	877BC7876200B0979876C6A65F97241D99D61F3A101906737E86DF8525684118
   ```

   The resulting file's Git blob is e58ffe5f67a751a2b107473d85ee8fc93108f881.

3. Check whether `lib/Invoke-ContractStage.ps1` contains `# The one named transient refusal class (Boot, fetch and the repository's own commit hook): one retry each (DEC-33 rule 8).`; if so record Already Applied when its Git blob is 0033a6383474e91105378e3ef68d7e51c92f0b1c, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-041 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   function Get-Brief([string]$t){(($t-split"`r?`n")|Where-Object{$_-match'^(ORVION|MODE|CODE|SUBJECT|APPROVAL_EVIDENCE|CRITERIA|BLOCKER|PREPARE):'}|Select-Object -First 8)-join' | '}
   ```
   insert
   ```text
   # The one named transient refusal class (Boot, fetch and the repository's own commit hook): one retry each (DEC-33 rule 8).
   $transient='(?m)^(SUBJECT: github:PUBLIC_READ:GIT_TIMEOUT|CODE: GIT_FETCH_FAILED)\r?$'
   ```

   b) immediately after the line
   ```text
       $messageText=if($env:ORVION_COMMIT_TRAILER){"$Message`n`n$env:ORVION_COMMIT_TRAILER"}else{$Message}
   ```
   insert
   ```text
       $before=Invoke-RepoGit @('rev-parse','HEAD')
   ```

   c) immediately after the line
   ```text
       $out=& git -C $r commit -q -m $messageText 2>&1|Out-String;$code=$LASTEXITCODE
   ```
   insert
   ```text
       # A hook refusal writes no commit: one retry of the named transient class, the index unchanged (BP-21).
       if($code-and$out-match$transient-and(Invoke-RepoGit @('rev-parse','HEAD'))-ceq$before){Add-Content -LiteralPath $log -Value $out -Encoding utf8;Write-Say "COMMIT $($Matches[1]): one retry";$out=& git -C $r commit -q -m $messageText 2>&1|Out-String;$code=$LASTEXITCODE}
   ```

   d) replace the line
   ```text
   if($bootCode-and$boot-match'(?m)^(SUBJECT: github:PUBLIC_READ:GIT_TIMEOUT|CODE: GIT_FETCH_FAILED)\r?$'){Write-Say "NATIVE BOOT $($Matches[1]): one retry";$boot=& pwsh -NoProfile -File $native -Root $r -Boot 2>&1|Out-String;$bootCode=$LASTEXITCODE}
   ```
   with
   ```text
   if($bootCode-and$boot-match$transient){Write-Say "NATIVE BOOT $($Matches[1]): one retry";$boot=& pwsh -NoProfile -File $native -Root $r -Boot 2>&1|Out-String;$bootCode=$LASTEXITCODE}
   ```

   The resulting file's Git blob is 0033a6383474e91105378e3ef68d7e51c92f0b1c.

4. Check whether `lib/test-native-stage.ps1` contains `# BP-21: the repository's own commit hook refuses with a named transient code; the stage retries the commit once.`; if so record Already Applied when its Git blob is 994415207724cbe9e04ef3359c1ce55ec3e2b5ca, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-041 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
       [IO.File]::WriteAllText((Join-Path $dir '.githooks/pre-commit'),"#!/bin/sh`nprintf '%s\n' hook >> .git/hook.calls`nexit 0`n")
   ```
   with
   ```text
       [IO.File]::WriteAllText((Join-Path $dir '.githooks/pre-commit'),"#!/bin/sh`nprintf '%s\n' hook >> .git/hook.calls`nif [ -f .git/hook-fail ] && [ `$(cat .git/hook-fail) -gt 0 ]; then echo `$((`$(cat .git/hook-fail)-1)) > .git/hook-fail; printf '%s\n' 'ORVION: BLOCKED' `"`$(cat .git/hook-code)`" 'SUBJECT: origin'; exit 1; fi`nexit 0`n")
   ```

   b) immediately after the line
   ```text
       Assert-Stage 'a failed approve fetch is retried once and then stops before any write' ($r6.Exit-ne0-and$r6.Output-match'FETCH failed: one retry'-and$r6.Head-ceq$nofetch.Head) $r6.Output
   ```
   insert
   ```text
       # BP-21: the repository's own commit hook refuses with a named transient code; the stage retries the commit once.
       function Set-RetryHook($Fixture,[int]$Fail,[string]$Code){[IO.File]::WriteAllText((Join-Path $Fixture.Root '.git/hook-fail'),"$Fail`n");[IO.File]::WriteAllText((Join-Path $Fixture.Root '.git/hook-code'),"CODE: $Code`n")}
       function Get-HookCalls($Fixture){@(Get-Content (Join-Path $Fixture.Root '.git/hook.calls')).Count-1}
       $c1=New-StageFixture 'commit-once';Set-RetryHook $c1 1 'GIT_FETCH_FAILED';$r7=Invoke-StageFixture $c1
       Assert-Stage 'one named transient commit-hook refusal gets exactly one retry, then the commit lands' ($r7.Exit-eq0-and$r7.Head-cne$c1.Head-and(Get-HookCalls $c1)-eq2-and@(Read-StageGit $c1.Root @('rev-parse','HEAD:new.txt'))[0]-ceq$c1.Blob) $r7.Output
       $c2=New-StageFixture 'commit-twice';Set-RetryHook $c2 9 'GIT_FETCH_FAILED';$r8=Invoke-StageFixture $c2
       Assert-Stage 'a second named commit refusal stands: no third attempt, HEAD unchanged' ($r8.Exit-ne0-and$r8.Output-match'COMMIT_REFUSED'-and$r8.Head-ceq$c2.Head-and(Get-HookCalls $c2)-eq2) $r8.Output
       $c3=New-StageFixture 'commit-other';Set-RetryHook $c3 9 'REPOSITORY_CONSISTENCY_FAILED';$r9=Invoke-StageFixture $c3
       Assert-Stage 'any other commit refusal is not retried' ($r9.Exit-ne0-and$r9.Head-ceq$c3.Head-and(Get-HookCalls $c3)-eq1) $r9.Output
   ```

   The resulting file's Git blob is 994415207724cbe9e04ef3359c1ce55ec3e2b5ca.

5. Check whether `records/README.md` contains `| WS-033/ | records | Summary of WS-033 compact folders method | agents, the owner | 2026-11-12 |`; if so record Already Applied when its Git blob is e1296aae08c910884b2cf787f8de55ec0e4c43df, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-041 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-032/ | records | Summary of WS-032 deferred proposal (no change file) | agents, the owner | 2026-11-04 |
   ```
   insert
   ```text
   | WS-033/ | records | Summary of WS-033 compact folders method | agents, the owner | 2026-11-12 |
   ```

   b) replace the lines
   ```text
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:36Z | new | - | records/WS-022 | T10 organizer |
   ```
   with
   ```text
   | --- | --- | --- | --- | --- |
   ```

   c) immediately after the line
   ```text
   | 2026-11-04T17:40:43Z | new | - | records/WS-032 | T10 organizer |
   ```
   insert
   ```text
   | 2026-11-12T11:29:40Z | new | - | records/WS-033 | WS-033 P9.1 summary |
   ```

   d) immediately after the line
   ```text
   - [WS-032/README.md](WS-032/README.md)
   ```
   insert
   ```text
   - [WS-033/README.md](WS-033/README.md)
   ```

   The resulting file's Git blob is e1296aae08c910884b2cf787f8de55ec0e4c43df.

6. Check whether `records/WS-033/README.md` contains `Purpose: Summary of WS-033 compact folders method. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is 82350464b599d220208b90822d79d0cb283db86e, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-041 candidate output), and change nothing else:

   ```text
   # WS-033

   Purpose: Summary of WS-033 compact folders method. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-12T11:29:40Z | new | - | records/WS-033 | WS-033 P9.1 summary |
   <!-- /organize:changes -->

   # WS-033 compact folders method

   Summary of a finished workstream (DEC-11) and its final report A-I (owner directive 2026-10-31, DIRECTIVE.md section 13),
   written by Claude main in WS-033 step P9.1 on 2026-11-12 and landed by WS-041. Labels: Fact (a recorded or re-run result
   with its evidence), Unproven (not yet shown), Rec (a recommendation). Evidence paths that begin with the records folder name the evidence folders under data, as in the other summaries.
   Evidence: records/WS-033/ and data/records/owner-directive-20261031-improvement-ws/ (PLAN.md, PLAN-DONE.md).

   ## Result

   - Change file: ORVION-Workbench/changes/WS-033-compact-folders-method.md, SHA256 2A31AD62691FDC9E46DB31743F92DFF64FDDEFDE09BAEEB1F13BC68CB73CF1A4
   - Status: Complete
   - Verdict: Confirmed Complete
   - Reviewed Fingerprint: 0F79D8C890BF914C2DC10D2D83E2AD217C47FA5E54412B2B914A137446A56865
   - Reviewed Receipt: 5BC34A7D34DEEF4085FBD47A89C7F1A6D87934A8E3866C757FFDB7326AA7E88B
   - Released with WS-027 and WS-028 at 9a33100 (records/WS-033/package/release/RELEASE-RECEIPT.json); follow-ups WS-035
     (a845018), WS-036 (33c7667), the Lift record WS-037 (c25ac94) and WS-038, WS-034, WS-040, each with its own receipt.

   ## Receipt

   The original own Finish receipt, `records/WS-033/runtime/original/own-finish-receipt.json`, SHA256
   6AB2AFE9E8A3383818DEA3AC86819EC4FA91341BDB7ED3F455DED0309AFC485A; its digest equals the Reviewed Receipt above
   (runStart shortened; the evidence copy keeps the bytes, D119):

   ~~~json
   {
     "schema": 2,
     "contract": "changes/WS-033-compact-folders-method.md",
     "finishHead": "f3e3618ee21fccedaee7e2f31ee2c889984f8a90",
     "fingerprint": "0F79D8C890BF914C2DC10D2D83E2AD217C47FA5E54412B2B914A137446A56865",
     "profiles": ["CONTROL", "COORDINATION", "RECOVERY", "REPOSITORY"],
     "evaluator": "0359914cae98f493a59d202649cd2fe2ee29fcf3",
     "runStart": "[2026-11-04 14:14:59] START pid=18656 host=[masked] pwsh=7.6.8 cpus=8 head=f3e3618",
     "result": "READY",
     "draftSHA256": "16F3739491FFE8FDBCD1AFCDC13227E635A30856E3B92C1D15B6C359BEA430AE",
     "recipe": "D86A752BFAAC43D7913C76C6DAC658C971ADAF95F990A12426A846E1BECFF826",
     "role": "ORIGINAL",
     "proof": "F3B466DCDA0A26CF642E52616C326C70889B2F7B594D3EF49096D1AAF3424777",
     "digest": "5BC34A7D34DEEF4085FBD47A89C7F1A6D87934A8E3866C757FFDB7326AA7E88B"
   }
   ~~~

   ## Failed, refused and superseded attempts (5)

   - `records/WS-033/runtime/sandbox-failed-1`: failed. The V3 sandbox Finish launched from Git Bash put mingw64 git first, so test-workspace-layout.ps1:239 built a wrong sh.exe path (stated in records/WS-033/measurements.tsv, run sandbox-failed-1)
   - `records/WS-033/runtime/original-failed-1`: superseded. UNPROVEN: no record states the reason
   - `records/WS-033/package/release/publish-failed-1/failure.json`: failed. PUBLICATION_GIT_READ_FAILED in the ls-remote read before any push; no push attempted, remote unmoved (stated in that file)
   - `records/WS-033/p81-clean-dryrun-20261107-run2-FAILED-own-output-file-locked.txt`: failed. the dry run's own output file was locked (stated in its name)
   - `records/WS-033/lift/orvion-spec301/release/preflight-ci-failed-1-sha-not-fetched.log`: failed. the preflight CI read an unfetched SHA (stated in its name)

   ## A. Authority reconciliation

   - Fact: superseded: ORVION-Owner-Tools as the live data store (folded into `data/`, 566 of 566 manifest rows,
     records/WS-033/p7b/p72b-result.json); the per-workstream controller copies (lib/Invoke-ContractLifecycle.ps1 from
     WS-034); the former simplicity rule (retired into DEC-33 by WS-040, D129); the old decision log D1-D122 (byte-exact in
     docs/history/DECISIONS-LOG.md, mapped in DECISIONS-MAP.tsv).
   - Fact: still in force: DEC-02 (the owner's live instruction wins), DEC-08 (CRM and ORVION change only through their own
     Boot), DEC-09 (no secret committed), DEC-25 (a Workbench release needs the owner's words), DEC-05 (the Lift and its
     accepted residuals), DEC-30 and DEC-33 (the constitution).
   - Fact: the delegation of 2026-11-07 (records/WS-033/DELEGATED-DECISIONS-20261107.md) covered A2-A5; A6, the Lift line,
     stayed the owner's and was recorded by WS-037.

   ## B. Documentation maintenance

   - Fact (data/records/owner-directive-20261031-improvement-ws, MEASUREMENTS-20261031.txt against MEASUREMENTS-20261112.txt):
     WORKFLOW.md 18,922 to 1,595 B; work/RESUME-HERE.md 38,278 to 594 B; HANDOFF.md 3,583 to 2,815 B, longest line 620 to
     151; lib/README.md 41,839 to 37,305 B; README.md is the router (2,344 B); AGENTS.md is the stub (693 B).
   - Fact: one home per kind (DEC-01): docs/DECISIONS.md holds the rules as DEC-NN (41,213 B, budget 48 KB); live state only
     in data/work/NOW.md through lib/Save-State.ps1 (DEC-26); memory files reduced to DEC pointers (P7.7).
   - Fact: history kept: docs/history/DECISIONS-LOG.md, DECISIONS-ARCHIVE.md, DECISIONS-MAP.tsv and LOG.tsv.

   ## C. Permanent prevention

   - Fact: lib/Test-MarkdownConsistency.ps1 refuses MD_SECTION_ID, MD_PREAMBLE, MD_SECTION_MISSING, MD_ROUTER_HOP and
     MD_WATCH and checks NOW.md before Save-State writes it (P1.5c, P1.5e).
   - Fact: lib/Organize.ps1 -Check refuses broken links, paths, sections and citations, orphans, missing organizers and LOG
     rows, data-file schema errors, stale generated files and a LOG.tsv that is not a prefix of its committed copy (DEC-28,
     S11: 16 of 16 test runs, 40 of 40 mutants, P1.5n); the broken-reference mutant is killed (P1.5k).
   - Fact: lib/hooks/Guard-Write.ps1 blocks writes to single-writer files; Hunt reports layout and lint gaps (DEC-06).

   ## D. The second map

   - Fact: lib/Map-Repos.ps1 writes the repository map (committed files only) and, on every run, the second map of the
     names in ORVION-Workbench-temporary and `data/` to ORVION-Workbench-temporary\map; the scheduled task "ORVION
     Repository Map" refreshes both hourly and at logon. Owner-Tools is no longer a separate root: S9 folded it into
     `data/`, which the second map covers.
   - Fact (P7.6, 2026-11-12, 1.1 min): 3 repositories, 2,209 files, 38,788 links, 142 orphans; second map 44,098 names.

   ## E. Spider

   - Fact: lib/Spider.ps1 searches the repositories, `data/` and the temporary root live, each hit labelled repo, data or
     temporary; a missing source is UNAVAILABLE (exit 3), never zero hits; credential values are masked (the S10 case in
     lib/test-spider.ps1, P1.5a).
   - Fact (P7.6, records/WS-033/p76/p76-spider.txt): SPEC-308 138 s cold, with data and repo hits; GIT_TIMEOUT 22 s with
     data, repo and temporary hits; Hosted-Sql.ps1 and "stack swap" 22 s each. test-spider runs in every Workbench Finish
     (31 suites PASS in WS-038, WS-034 and WS-040).

   ## F. Brief and context efficiency

   - Fact (measure.ps1 section D): main-session startup context median 76,384 tokens (n=6, 2026-10-31) to 54,346 (n=76,
     2026-11-12); subagents unchanged at about 50,450.
   - Fact (section C): the most-read files were the old Owner-Tools ARCHITECTURE.md (167 reads) and PLAN.md (155); live
     state now arrives injected (NOW.md, DEC-26) and the router sends each question to one file.
   - Unproven: the saving per whole session beyond the startup median (not measured).
   - Rec: the WS-033 PLAN.md (47 KB) exceeds the client's 45,000-byte single read; keep moving Done rows to PLAN-DONE.md.

   ## G. Model and effort governance

   - Fact: DEC-18 (D107): Claude main uses Opus at high for judgment and irreversible steps, Sonnet at medium for scripted
     steps, Haiku at low for read-only measurements; Codex the latest Sol at high. V1 ran as gpt-6.1-sol at high, 27 min
     (P2.2); lib/Delegate.ps1 carries and compares the DEC-18 effort (P1.5q).
   - Fact: later Codex reviews were skipped by the owner (D116, D120); each later contract had one labelled Claude-main
     self-review. Historical records were not rewritten.

   ## H. Verification

   - Fact: each release ran the native lifecycle with sandbox and original Finishes (WS-033 36.0 and 35.6 min), a hosted
     run on the exact head, one promotion and a verified readback.
   - Fact (P7.5, 2026-11-12, records/WS-033/p75/): Organize -Refresh changed 0 of 40 organizers; -Check ORGANIZE FAIL 428,
     reported and never a PASS; Markdown guard PASS; Hunt 0 bugs, 6 gaps, 1 need.

   ## I. Residual risks

   | Risk | State | Evidence |
   | --- | --- | --- |
   | P7.5 criterion | 3 BROKEN_PATH in data\claude-memory: a CRM memory file's prose names three renamed CRM change files; memory is never edited. 0 MISSING outside the temporary root; 19 TOO_LONG and 5 NO_ORGANIZER under data; the rest in the temporary root | records/WS-033/p75/p75-organize-check.txt |
   | Temporary root growth | ORVION-Workbench-temporary\sb grew from 1.7 to 11.2 GB (Batch 6 sandboxes); disposal is the owner's (DEC-10) | MEASUREMENTS-20261112.txt section F |
   | Legacy folders | Documents\ORVION-Owner-Tools, -Owner-Review, -Owner-Recovery, -Sandbox and -drafts-backup remain until the owner's DEC-10 confirmation | records/WS-033/LIFT-READINESS.md section 5 |
   | Restore launcher after the fold | UNPROVEN; only the manual fallback is proven | LIFT-READINESS.md R1 |
   | Format readiness | NOT ready for a Windows reinstall | LIFT-READINESS.md section 3 |
   | Review independence | self-review only since the Codex skips | section G |
   ```

   The resulting file's Git blob is 82350464b599d220208b90822d79d0cb283db86e.

## Acceptance Criteria

- [ ] Output `changes/README.md` equals its declared resulting Git blob. check: blob:changes/README.md=55b83995d64e6417ffee4b9a9514c93c368d3f8f
- [ ] Output `docs/history/LOG.tsv` equals its declared resulting Git blob. check: blob:docs/history/LOG.tsv=e58ffe5f67a751a2b107473d85ee8fc93108f881
- [ ] Output `lib/Invoke-ContractStage.ps1` equals its declared resulting Git blob. check: blob:lib/Invoke-ContractStage.ps1=0033a6383474e91105378e3ef68d7e51c92f0b1c
- [ ] Output `lib/test-native-stage.ps1` equals its declared resulting Git blob. check: blob:lib/test-native-stage.ps1=994415207724cbe9e04ef3359c1ce55ec3e2b5ca
- [ ] Output `records/README.md` equals its declared resulting Git blob. check: blob:records/README.md=e1296aae08c910884b2cf787f8de55ec0e4c43df
- [ ] Output `records/WS-033/README.md` equals its declared resulting Git blob. check: blob:records/WS-033/README.md=82350464b599d220208b90822d79d0cb283db86e
- [ ] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [ ] AC-01 Commit retry (item 1): in lib/Invoke-ContractStage.ps1 one pattern `$transient` names the transient class, and Save-Commit runs `git commit` a second time only when the first exits non-zero, its output matches `$transient` and HEAD equals the HEAD read before the commit; at most once, then COMMIT_REFUSED stands (DEC-33 rule 8). The read-only Boot retry uses the same `$transient` with unchanged behaviour. test-native-stage passes, every earlier case included, with: one named commit-hook refusal gets exactly one retry and the commit lands with the declared blob; a second named refusal stands with no third attempt and HEAD unchanged; any other commit refusal is not retried.
- [ ] AC-02 WS-033 summary (item 2): records/WS-033/README.md begins with the organizer header Organize -New writes (Purpose "Summary of WS-033 compact folders method", Reader "agents, the owner"), then holds the sections Result, Receipt, Failed, refused and superseded attempts (5), and A to I of the WS-033 final report; records/README.md lists it in its contents, changes and Files lists; docs/history/LOG.tsv only appends its one `new` row, naming WS-041; the Markdown guard passes with this contract in place.
- [ ] AC-03 Organizer (item 3): changes/README.md is what lib/Organize.ps1 -Refresh writes: it holds the WS-041 row, and a refresh of the replay with this contract in place changes no organizer.
- [ ] AC-04 Secrets and privacy: gitleaks on the exact candidate range reports no finding in the six outputs and RESUME.md; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; neither masked value (the computer name, a marketing tunnel script name) is in any changed file or in this contract; the receipt quoted in the summary keeps its host masked.
- [ ] AC-05 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json. From each Finish launch to END: no Events -Add, Save-State or edit in a protected root, and Docker off.
- [ ] AC-06 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-041/evidence/protected-before.json, captured before the sandbox Finish and again after Original Complete with data/records/WS-038/Capture-Protected.ps1; lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1 and lib/apply-draft-steps.ps1 are unchanged; CRM, ORVION and their trusted copies keep their HEAD and files (the lifecycle's protected-root compare); no Codex, subagent, RAM, power setting or scheduled task change; no push before both roles are Complete.

## Review Gate

- [ ] Inspect the live subject, this role's fresh receipt, timing and watching evidence, and every criterion above, with attempts, deviations and gaps kept visible. No prototype result or earlier receipt substitutes for this role's gate.
- [ ] Review: one Claude-main self-review, labelled as such and never called independent. The Codex review is not part of the Routine tier (DEC-12) and was skipped by the owner's decision of 2026-11-08 ~01:20 Cairo (D120); it is never replaced or claimed. A remaining material disagreement goes to the owner.
- [ ] Retro (DEC-12): Claude main names what does not satisfy it, each item with a remedy and a check.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Append only. No approval, execution-root binding or receipt is claimed. At actual approval add exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line using actual immutable identities. Owner evidence must name the approved digest and execution root. For original execution append exactly one Sandbox Receipt and Sandbox Receipt SHA256 for the matching successful schema2 sandbox artifact. A delegated decision needs actual live owner delegation and is labelled delegated. Never invent human confirmation or approval.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-041\assurance\V3\DRAFT.md
Approved SHA256: 3A705B2E74FDD46E2F57A81BC3B950EC6483A5FACE14007580640623A71E7271
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-041\gate\GATE1-WS041-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: FDE135A1169BD2CA2A4215931DD47769D40FEB3ED4A70CCD0937CCAFDD98B06D
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W41\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: B3870F694802C50654CB1E3EE7F05E4ED3EADD63BCCB85954DB73DB184519BE6

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W41-cand (data/records/WS-041/Make-Candidate.ps1). Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json beside this Draft. After Complete, outside this contract: the release on the owner's conditional words of ~13:27 (every gate passed and Claude main's retro satisfied); the protected state is compared with its record from before; the WS-033 and Batch 6 PLAN rows, Save-State and the status pages record the result.
