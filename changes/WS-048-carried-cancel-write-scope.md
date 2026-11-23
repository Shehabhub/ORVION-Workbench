# Workbench Change Request - WS-048

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Let the stage approve rule carry an unbound pending baseline made by a cancelled CR's own implement commits, with the scope of data/records/WS-048/CONTRACT.md section 4. In lib/Invoke-ContractStage.ps1, Get-CarriedCancel (WS-040) carried a pending range only when every commit touched just the one cancelled CR, _ORVION_CANONICAL/manifest.md and ai-map.json; it now also admits the other files of those commits when each is listed in that CR's `## Write Scope` at the head (bullets, backticks stripped, separators normalised), and refuses as before when any file lies outside it. Every earlier refusal is kept: more than one change file or two CRs, a CR not `[x] Cancelled` at the head, a CR the Draft does not name in Supersedes, an unbound floor and more than 20 commits. CRM itself judges each commit of a publication range against the frozen baseline's Write Scope (OUT_OF_SCOPE_WRITE) and forbids a Write Scope change after approval, so the Write Scope read at the head is the approved one and CRM re-judges the same commits at publication. lib/test-native-stage.ps1 adds a -Scoped fixture, a carrying case, a refusal case for a file outside the scope and a causal mutant; lib/README.md's Invoke-ContractStage row names the rule; changes/README.md gets the WS-048 row Organize -Refresh writes. Benefit (DEC-30: errors prevented, fewer owner interventions): CRM SPEC-335 was cancelled after its Complete refused (data/records/batch6/exit-bundle-j/spec335/DELEGATED-CANCEL.md); its implement commit b274da4 writes eight files of its Write Scope, so its successor SPEC-336 would be refused PENDING_BASELINE_UNBOUND at approve and the Batch 6 exit bundle J would stop.

Tier: Significant under DEC-12 (it widens what the approve gate admits as a pending baseline for every CRM and ORVION Draft that supersedes a cancelled CR). Governance check: the one caller and every consumer listed (CONTRACT.md section 4); the owning tests run on the candidate with a positive case, a refusal case and causal production mutants; a real-data probe on the CRM SPEC-335 range; a retro closes the workstream. Authority: DEC-02, DEC-08, DEC-09, DEC-11, DEC-12, DEC-13, DEC-14, DEC-22, DEC-23, DEC-24, DEC-25, DEC-26, DEC-30 and DEC-33; the owner's words of 2026-11-23 13:04:35 Cairo frozen in data/records/WS-048/owner-words/owner-2026-11-23-continue-until-b6-finish.txt (SHA256 7D2A8B8F0F209C8538B0D87F133C440DBB620C2577DEAECF8F3D312584C94759), under the owner's delegation that the constitution decides in the owner's absence (data/records/WS-046/owner-words/owner-2026-11-21-constitution-decides-in-my-absence.txt, SHA256 DB34F67C2AF82D9A9751597247ABEEBD74B4BBB1CC6F47291D2572FE080EEAB0) and the live AFK Mode run instruction. The design is Claude main's engineering choice under that delegation, labelled DELEGATED; no owner text is typed by an agent (DEC-02).

Number: WS-048. Intended contract: changes/WS-048-carried-cancel-write-scope.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: this contract changes neither lib/Invoke-ContractLifecycle.ps1 nor the judge and adds no script, so both roles run the Original's own controller (SHA256 AD76811656C7DAEEED7D214597F986178B57BA7943DE4B16F0438A33F57CEF57), its SHA256 checked before each stage, with the accepted judge. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

f4020dada8666bf11b20fd72d158b15ecb1f4887

## Write Scope

- changes/README.md
- lib/Invoke-ContractStage.ps1
- lib/README.md
- lib/test-native-stage.ps1
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: every other line of lib/Invoke-ContractStage.ps1 (the bound-record route, the floor, the 20-commit bound and every other stage keep their behaviour); every other case of lib/test-native-stage.ps1; every other row of lib/README.md and changes/README.md; lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Workbench.ps1, lib/Hunt.ps1 and every other lib/ file, test and hook; docs/ (docs/WORKSPACE-LAYOUT.md names the tool and stays true); past changes/WS-0xx files; .claude/settings.json and the owner's profile; data/ (untracked); the seven legacy folders, Owner-Tools, the vault and every package; any CRM or ORVION change (DEC-08: the CRM repository is only read by the Draft check's probe, and SPEC-336 runs later under its own contract); any Supabase project, Primary or Founder Secondary; credentials, real sessions or events (DEC-09); Codex, subagents, RAM, power or scheduled-task changes; any push or release before both roles are Complete (DEC-25).

## Draft Assurance

V1: WS048-V1-CLAUDE-SIGNIFICANT-DESIGN-20261123-01 | 2026-11-23 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-048\assurance\V1\DRAFT.md | 05B78B0920C4DCAB514E19DC78402100B6436BBF46E80436AA0618BB38456F01
V2: WS048-V2-CLAUDE-SIGNIFICANT-ADVERSARIAL-20261123-01 | 2026-11-23 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-048\assurance\V2\DRAFT.md | 6229FEC90D61E8F3DB83DB434147E549182DF9EFCF52860C47D7A6B3D0AB5982
V3: WS048-V3-CLAUDE-REFRESH-20261123-01 | 2026-11-23 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-048\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V1 DESIGN by Claude main, claude-opus-5-5, under D120: the owner skipped Codex and subagents on 2026-11-08 ~01:20 Cairo, standing (the owner's words verbatim in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md; D124 wrote D120 into DEC-14 and DEC-19). Codex skipped by owner decision, not by unavailability. No Codex work is claimed and nothing here is independent. V1 designs the scope of data/records/WS-048/CONTRACT.md section 4 from the frozen candidate.

V2 ADVERSARIAL by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V2 attacks V1 against CRM's own native check (scripts/check_agent_continuity.ps1 at b787391) and changes no output: (a) case: CRM compares a written path with its frozen Write Scope case-insensitively (-notcontains); V1 compares case-sensitively (-cnotin), so V1 can only refuse more, never admit a path CRM would refuse, and a refusal fails closed (PENDING_BASELINE_UNBOUND, no write). (b) backticks and separators: CRM's Bullets strips one surrounding backtick pair and turns backslashes into slashes; V1 trims backticks and turns backslashes into slashes, the same for every bullet of SPEC-335, and the TRIM mutant proves the trim is load-bearing. (c) renames: CRM judges both the Path and the Old of each record; V1 lists files with --no-renames, so a rename is a delete plus an add and both paths are judged. (d) scope at the head: CRM forbids a Write Scope change after approval and re-judges every commit of a publication range (OUT_OF_SCOPE_WRITE), so the list V1 reads at the head is the approved one; a forged later scope would itself be refused by CRM at publication. (e) real data: SPEC-335's implement commit b274da4 writes 8 files, all among the 11 entries of its Write Scope (the CR, supabase/tests 192, 193 and 194, the three reports/master files and _ORVION_CANONICAL/manifest.md); the probe on the live CRM repository returns the SPEC-335 path only for a Draft naming it in Supersedes, and the baseline returns nothing. (f) the SCOPE mutant (the Write Scope check removed) lets the outside file through and is killed by the refusal case; every earlier refusal keeps its line.

V3 REFRESH by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V3 changes no output and confirms the live facts on 2026-11-23: origin/main and the Original HEAD are both f4020dada8666bf11b20fd72d158b15ecb1f4887; lib/Invoke-ContractLifecycle.ps1 is still SHA256 AD76811656C7DAEEED7D214597F986178B57BA7943DE4B16F0438A33F57CEF57 and lib/Test-WorkbenchChange.ps1 still 4E1F00E159B82ECDFDD0F0C542A08B71D77BBFE4ABAAB4B6B1B8377587017FD1; the pinned host is 7.6.8 and git 2.56.1.windows.1; the CRM repository is still at the SPEC-335 Cancel head b78739119185d7b7c4bb20c422e47a8cda088469 with a clean tree. The V1 Draft check passed with both mutants (SCOPE and TRIM) killed and their bytes restored, the real-data probe as designed, no gitleaks finding and 0 of 74 hazards; V2 reused the V1 test results because the replay tree was identical, and V3 does the same under the same rule.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W48\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W48\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W48\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W48\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.56.1.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none. PowerShell 7.6.8 is the portable host in ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8, which WS-034 and WS-040 to WS-047 ran; git 2.56.1 is the live machine version.

1. Check whether `changes/README.md` contains `| WS-048-carried-cancel-write-scope.md | contracts | Workbench Change Request - WS-048 | - | - |`; if so record Already Applied when its Git blob is 3dc34fd2707a0d70195065dd7ac4aa7c07785b25, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-048 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-047-claude-setup-survival.md | contracts | Workbench Change Request - WS-047 | - | - |
   ```
   insert
   ```text
   | WS-048-carried-cancel-write-scope.md | contracts | Workbench Change Request - WS-048 | - | - |
   ```

   The resulting file's Git blob is 3dc34fd2707a0d70195065dd7ac4aa7c07785b25.

2. Check whether `lib/Invoke-ContractStage.ps1` contains `# (the same X throughout) plus only the manifest, ai-map and paths in X's Write Scope, down to $Main or a bound record, at`; if so record Already Applied when its Git blob is 15bbf23db256c081259455944b9b13c0808818bc, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-048 candidate output), each matched once, and change nothing else:

   a) replace the lines
   ```text
   # (the same X throughout) plus only the manifest and ai-map, down to $Main or a bound record, at most 20 commits; X must
   # read [x] Cancelled at $Head and appear in the Draft's Supersedes section (CRM CANCELLED_SEGMENT_NOT_CARRIED).
   ```
   with
   ```text
   # (the same X throughout) plus only the manifest, ai-map and paths in X's Write Scope, down to $Main or a bound record, at
   # most 20 commits; X must read [x] Cancelled at $Head and appear in the Draft's Supersedes section (CRM
   # CANCELLED_SEGMENT_NOT_CARRIED). WS-048: the Write Scope bullets mirror CRM OUT_OF_SCOPE_WRITE, which judges the same
   # paths per commit at publication; CRM freezes Write Scope after approval, so reading it at $Head reads the frozen list.
   ```

   b) replace the line
   ```text
       $x=$null;$c=$Head
   ```
   with
   ```text
       $x=$null;$c=$Head;$other=@()
   ```

   c) replace the lines
   ```text
           if(@($files|Where-Object{$_-cnotin@($own[0],'_ORVION_CANONICAL/manifest.md','ai-map.json')}).Count){return $null}
           $x=$own[0];$c=Invoke-RepoGit @('rev-parse',"$c^")
   ```
   with
   ```text
           $x=$own[0];$other+=@($files|Where-Object{$_-cnotin@($x,'_ORVION_CANONICAL/manifest.md','ai-map.json')})
           $c=Invoke-RepoGit @('rev-parse',"$c^")
   ```

   d) replace the line
   ```text
       if((@(Invoke-RepoGit @('show',"${Head}:$x"))-join"`n")-notmatch'(?m)^\[x\] Cancelled\s*$'){return $null}
   ```
   with
   ```text
       $text=(@(Invoke-RepoGit @('show',"${Head}:$x"))-join"`n")-replace"`r",''
       if($text-notmatch'(?m)^\[x\] Cancelled\s*$'){return $null}
       $ws=[regex]::Match($text,'(?s)\n## Write Scope\n(.*?)(?=\n## |\z)')
       $scope=@([regex]::Matches($ws.Groups[1].Value,'(?m)^-\s+(.+?)\s*$')|ForEach-Object{$_.Groups[1].Value.Trim('`')-replace'\\','/'})
       if(@($other|Where-Object{$_-cnotin$scope}).Count){return $null}
   ```

   The resulting file's Git blob is 15bbf23db256c081259455944b9b13c0808818bc.

3. Check whether `lib/README.md` contains `lines; an unbound pending baseline is carried only by a Cancelled CR the Draft names in Supersedes, its own commits writing nothing outside its Write Scope. Native gates remain authority. |`; if so record Already Applied when its Git blob is bc94c46b6b780152fef53b5db61ae158f6f84984, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-048 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   | `Invoke-ContractStage.ps1 -Config <x>.psd1 -Stage approve\|implement\|review\|complete\|bind` | bounded native transport: exact selected Draft/filter identity, native Boot and normal hooks before transitions; whole applier Plan before writes, declared paths only, actual Git authorship; approve refuses unless `SandboxConsistency` (the sandbox's native consistency log) shows nothing beyond RECOVER-1 and the `ConsistencyAccepted` lines. Native gates remain authority. |
   ```
   with
   ```text
   | `Invoke-ContractStage.ps1 -Config <x>.psd1 -Stage approve\|implement\|review\|complete\|bind` | bounded native transport: exact selected Draft/filter identity, native Boot and normal hooks before transitions; whole applier Plan before writes, declared paths only, actual Git authorship; approve refuses unless `SandboxConsistency` (the sandbox's native consistency log) shows nothing beyond RECOVER-1 and the `ConsistencyAccepted` lines; an unbound pending baseline is carried only by a Cancelled CR the Draft names in Supersedes, its own commits writing nothing outside its Write Scope. Native gates remain authority. |
   ```

   The resulting file's Git blob is bc94c46b6b780152fef53b5db61ae158f6f84984.

4. Check whether `lib/test-native-stage.ps1` contains `# or keeps the Supersedes line; -Bound writes the top's bound record; -Floor puts an unbound other commit below them;`; if so record Already Applied when its Git blob is 55e1f4f4730d4dfe83bdec9dd5836ebd80cc0ecb, and otherwise stop and report. Otherwise make exactly these 6 edits (land this exact frozen WS-048 candidate output), each matched once, and change nothing else:

   a) replace the lines
   ```text
   # or keeps the Supersedes line; -Bound writes the top's bound record; -Floor puts an unbound other commit below them.
   function New-PendingFixture([string]$Name,[string]$Status='Cancelled',[switch]$Extra,[switch]$Unnamed,[switch]$Bound,[switch]$Floor){
   ```
   with
   ```text
   # or keeps the Supersedes line; -Bound writes the top's bound record; -Floor puts an unbound other commit below them;
   # -Scoped gives the CR a Write Scope naming w.txt and an implement commit writing it (WS-048).
   function New-PendingFixture([string]$Name,[string]$Status='Cancelled',[switch]$Extra,[switch]$Unnamed,[switch]$Bound,[switch]$Floor,[switch]$Scoped){
   ```

   b) immediately after the line
   ```text
       $text="# SPEC-0 old`n`n## Status`n`n[x] Draft`n[ ] Approved`n[ ] Cancelled`n"
   ```
   insert
   ```text
       if($Scoped){$text+="`n## Write Scope`n`n- ``$old```n- ``w.txt```n"}
   ```

   c) immediately after the line
   ```text
       $null=Read-StageGit $root @('add','--',$old,'_ORVION_CANONICAL/manifest.md');$null=Read-StageGit $root @('commit','--quiet','-m','SPEC-0: Approve')
   ```
   insert
   ```text
       if($Scoped){[IO.File]::WriteAllText((Join-Path $root 'w.txt'),"in scope`n");$text+="Implemented.`n";[IO.File]::WriteAllText((Join-Path $root $old),$text);$null=Read-StageGit $root @('add','--',$old,'w.txt');$null=Read-StageGit $root @('commit','--quiet','-m','SPEC-0: implement')}
   ```

   d) immediately after the line
   ```text
       Assert-Stage 'a Cancelled CR named in Supersedes carries an unbound pending baseline to approval' ($r1.Exit-eq0-and$r1.Output-match'carries Cancelled changes/SPEC-0-old.md'-and[IO.File]::ReadAllText((Join-Path $carried.Root 'changes/SPEC-1-probe.md')).Contains('[x] Approved')) $r1.Output
   ```
   insert
   ```text
       $scoped=New-PendingFixture 'pending-scoped' -Scoped;$rs=Invoke-StageFixture $scoped -Stage approve
       Assert-Stage 'a Cancelled CR whose own implement commit writes only its Write Scope carries the baseline (WS-048, SPEC-335)' ($rs.Exit-eq0-and$rs.Output-match'carries Cancelled changes/SPEC-0-old.md'-and[IO.File]::ReadAllText((Join-Path $scoped.Root 'changes/SPEC-1-probe.md')).Contains('[x] Approved')) $rs.Output
   ```

   e) replace the line
   ```text
       foreach($case in @(@('pending-unnamed',@{Unnamed=$true},'a Cancelled CR the Draft does not name'),@('pending-extra',@{Extra=$true},'a pending commit that also changes another file'),@('pending-approved',@{Status='Approved'},'a pending CR that is not Cancelled'),@('pending-floor',@{Floor=$true},'a Cancelled CR above an unbound commit that is not main'))){
   ```
   with
   ```text
       foreach($case in @(@('pending-unnamed',@{Unnamed=$true},'a Cancelled CR the Draft does not name'),@('pending-extra',@{Extra=$true},'a pending commit that also changes another file'),@('pending-approved',@{Status='Approved'},'a pending CR that is not Cancelled'),@('pending-floor',@{Floor=$true},'a Cancelled CR above an unbound commit that is not main'),@('pending-scoped-extra',@{Scoped=$true;Extra=$true},'a scoped Cancelled CR whose commit also changes a file outside its Write Scope'))){
   ```

   f) immediately after the line
   ```text
       Assert-Stage 'causal removal of the Supersedes check lets an unnamed Cancelled CR carry the baseline' ($bad.Exit-eq0) $bad.Output
   ```
   insert
   ```text
       $body2=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Invoke-ContractStage.ps1'));$needle2='if(@($other|Where-Object{$_-cnotin$scope}).Count){return $null}'
       if(!$body2.Contains($needle2)){throw 'STAGE_WRITE_SCOPE_MUTANT_ANCHOR'};[IO.File]::WriteAllText($path,$body2.Replace($needle2,''))
       $fx=New-PendingFixture 'mutant-scoped-extra' -Scoped -Extra;$bad=Invoke-StageFixture $fx -Library $mutantLib -Stage approve
       Assert-Stage 'causal removal of the Write Scope check lets a file outside it ride the carried baseline' ($bad.Exit-eq0) $bad.Output
   ```

   The resulting file's Git blob is 55e1f4f4730d4dfe83bdec9dd5836ebd80cc0ecb.

## Acceptance Criteria

- [ ] Output `changes/README.md` equals its declared resulting Git blob. check: blob:changes/README.md=3dc34fd2707a0d70195065dd7ac4aa7c07785b25
- [ ] Output `lib/Invoke-ContractStage.ps1` equals its declared resulting Git blob. check: blob:lib/Invoke-ContractStage.ps1=15bbf23db256c081259455944b9b13c0808818bc
- [ ] Output `lib/README.md` equals its declared resulting Git blob. check: blob:lib/README.md=bc94c46b6b780152fef53b5db61ae158f6f84984
- [ ] Output `lib/test-native-stage.ps1` equals its declared resulting Git blob. check: blob:lib/test-native-stage.ps1=55e1f4f4730d4dfe83bdec9dd5836ebd80cc0ecb
- [ ] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [ ] AC-01 Behaviour: in lib/Invoke-ContractStage.ps1 (numstat 12/6) only Get-CarriedCancel and its header comment change. While it walks the pending commits it collects every file other than the one CR, _ORVION_CANONICAL/manifest.md and ai-map.json instead of refusing at once; after the CR is found `[x] Cancelled` at the head it reads that CR's `## Write Scope` section from the head text (carriage returns removed), takes each `- ` bullet with backticks trimmed and backslashes turned into slashes, and returns $null when any collected file is not in that list (case-sensitive). Every earlier refusal keeps its line: a second change file in a commit, a second CR, a CR not Cancelled at the head, a CR the Draft does not name in Supersedes, an unbound floor and more than 20 commits. Every other line of the file keeps its bytes. On the replay the Draft check runs the new Get-CarriedCancel, parsed from the file, read-only against the CRM repository at the SPEC-335 Cancel head b787391 with Main 676df3e46fffae83366fa4c177a74d327edd6381: with a Draft naming changes/SPEC-335-the-exit-evidence-gaps-are-pinned-and-the-re-sweep-registered.md in Supersedes it returns that path; the same function from the baseline returns nothing for the same input; with a Draft that does not name it, the new function returns nothing.
- [ ] AC-02 Tests and documentation: lib/test-native-stage.ps1 (12/3) gives New-PendingFixture a -Scoped switch (the CR's text gets a `## Write Scope` naming the CR and w.txt in backticks, and an implement commit between Approve and Cancel writes w.txt) and adds exactly the case "a Cancelled CR whose own implement commit writes only its Write Scope carries the baseline (WS-048, SPEC-335)", the refusal case "refused before any write: a scoped Cancelled CR whose commit also changes a file outside its Write Scope", and the in-test mutant case "causal removal of the Write Scope check lets a file outside it ride the carried baseline" with its anchor STAGE_WRITE_SCOPE_MUTANT_ANCHOR. No existing case is removed or weakened. lib/README.md changes only the Invoke-ContractStage row (1/1), which names the rule. Two production mutants on the replay must each make test-native-stage fail with the named case as its first FAIL line, and the Draft check must kill both and restore the bytes: SCOPE (the Write Scope check removed: the refusal of a pending commit that also changes another file) and TRIM (the backtick trim removed: the WS-048 carrying case).
- [ ] AC-03 Organizer: changes/README.md is what lib/Organize.ps1 -Refresh writes: it holds the WS-048 row, and a refresh of the replay with this contract in place changes no organizer.
- [ ] AC-04 Secrets and privacy: gitleaks on the exact candidate range reports no finding in the 4 outputs and RESUME.md; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; neither masked value (the computer name, a marketing tunnel script name) nor the owner's e-mail is in any changed file or in this contract.
- [ ] AC-05 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria; the scope profiles include CONTROL, so the Finish runs the full test schedule, test-native-stage, test-lifecycle-failclosed, test-contract-lifecycle and test-markdown-consistency among it. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json. From each Finish launch to END: no Events -Add, Save-State or edit in a protected root, and Docker off.
- [ ] AC-06 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-048/evidence/protected-before.json, captured before the sandbox Finish and again after Original Complete with data/records/WS-038/Capture-Protected.ps1; lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1 and lib/Workbench.ps1 are unchanged; both roles ran the Original's controller whose SHA256 this Draft names; CRM, ORVION and their trusted copies keep their HEAD and files (the lifecycle's protected-root compare; the Draft check's probe only reads the CRM repository); no Supabase project is touched; no Codex, subagent, RAM, power setting or scheduled task change; no push before both roles are Complete.

## Review Gate

- [ ] Inspect the live subject, this role's fresh receipt, timing and watching evidence, and every criterion above, with attempts, deviations and gaps kept visible. No prototype result or earlier receipt substitutes for this role's gate.
- [ ] Review: one Claude-main self-review, labelled as such and never called independent. The Codex review (DEC-14) is recorded SKIPPED by the owner's decision of 2026-11-08 ~01:20 Cairo, never replaced or claimed (D120). At most one corrective version; a remaining material disagreement goes to the owner.
- [ ] Retro (DEC-12): Claude main names what does not satisfy it, each item with a remedy and a check.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Append only. No approval, execution-root binding or receipt is claimed. At actual approval add exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line using actual immutable identities. Owner evidence must name the approved digest and execution root. For original execution append exactly one Sandbox Receipt and Sandbox Receipt SHA256 for the matching successful schema2 sandbox artifact. A delegated decision needs actual live owner delegation and is labelled delegated. Never invent human confirmation or approval.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-048\assurance\V3\DRAFT.md
Approved SHA256: AA8B7892431DD29D0EC3FB642B2DB56A5FF0F5C667142A1D535377BBE2961BAD
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-048\gate\GATE1-WS048-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: 45E0CAD46372E66D4DD91B7CDF82CEAB0DC340BF89FC930D1B43AB80576A4231
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W48\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 28BF32398C715CF43638437263F9DCEF278CE5FE3350C0D4237FFF83FEFF5D26

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W48-c2 (data/records/WS-048/Make-Candidate.ps1). Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json beside this Draft. After Complete, outside this contract: the release under DEC-25 on the DELEGATED record, only when every gate passed and Claude main's retro is satisfied; the protected state is compared with its record from before; the CRM SPEC-336 sandbox approve on the Cancel head b787391 is the real-use proof and its result goes into the retro; Save-State records the result.
