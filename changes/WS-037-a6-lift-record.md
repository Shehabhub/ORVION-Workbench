# Workbench Change Request - WS-037

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

## Objective

Record the owner's A6 decision of 2026-11-07 in the tracked governance files, as the owner's live instruction of about 19:00 Cairo authorizes: fold the A6 inbox item with the owner's words verbatim (DEC-01); replace only DEC-05's legacy-folder deletion sentence with the owner's sentence; transcribe the owner's Lift line into HANDOFF.md section 11 in its prescribed format; add archive item D126 and its map row; and land the 158 docs/history/LOG.tsv rows that Organize -Clean -Apply wrote at WS-033 step P8.2, only because the native clean-checkout admission requires them committed. Benefit: the Lift is recorded where DEC-01, DEC-04, DEC-05 and HANDOFF section 11 prescribe, and the inbox no longer holds a folded decision.

Tier: Significant under DEC-12 (an owner decision changes the decision text and a governance record). Authority: DEC-01, DEC-02, DEC-05, DEC-08, DEC-09, DEC-12, DEC-13, DEC-14, DEC-19, DEC-22, DEC-23, DEC-25 and DEC-28; the owner's A6 decision of 2026-11-07 18:30 Cairo and the owner's authorization of about 19:00 Cairo, both verbatim in data/records/WS-037/owner-words/decisions-inbox-20261107T1900.md. The Lift line and the DEC-05 sentence are the owner's own text, transcribed at the owner's explicit instruction; neither is DELEGATED and neither was typed by the owner (DEC-02). Native checks prevail; no evaluator, applier or tool change is included.

Number: WS-034 is reserved by DEC-04 and DEC-07, and WS-035 and WS-036 are Complete, so this takes WS-037. Intended contract: changes/WS-037-a6-lift-record.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: lib/Invoke-ContractLifecycle.ps1 at this baseline, from one WS-037 manifest in data/records/WS-037. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

33c76679bae5de2749ced2365be1ca6e7763e53c

## Write Scope

- docs/DECISIONS.md
- docs/history/DECISIONS-ARCHIVE.md
- docs/history/DECISIONS-MAP.tsv
- docs/history/LOG.tsv
- HANDOFF.md
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: DEC-10 and every other DEC entry; every lib/ file, test and hook; docs/WORKSPACE-LAYOUT.md (its stale Owner-Tools deletion step is observed, not changed); data/decisions-inbox.md, which is untracked and loses its two folded items after this contract is Complete and released; the seven legacy folders, the vault, the restore staging and every package, which stay untouched (no deletion, relocation or cleaning); Batch 6, B15, any Codex update, RAM floor or scheduled task change; no CRM, ORVION, credentials, real sessions or events (DEC-08, DEC-09); any push or release (DEC-25).

## Draft Assurance

V1: WS037-V1-CLAUDE-FALLBACK-DESIGN-20261107-01 | 2026-11-07 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-037\assurance\V1\DRAFT.md | 20F923ABC75CD99619B5EB1A22A4B43EF0041E4DA551B3EF43B0CA4B2B3E19B4
V2: WS037-V2-CLAUDE-FALLBACK-ADVERSARIAL-20261107-01 | 2026-11-07 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-037\assurance\V2\DRAFT.md | 86141FF0C531F7A9A220666F18C4F660F7989D265A4AECCABB6143DC19FAF0F9
V3: WS037-V3-CLAUDE-REFRESH-20261107-01 | 2026-11-07 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-037\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V3 EVIDENCE REFRESH by Claude main under DEC-13, binding the frozen V1 and V2 digests above; each was frozen and hashed before the next began (assurance\V1\FROZEN.json, assurance\V2\FROZEN.json). Author of V1 and V2: Claude main, claude-opus-5-5, under the automatic fallback of DEC-19 and the owner's D120, because Codex is unavailable on 2026-11-07 (codex-cli 0.166.0 against models cache client_version 0.167.0, ORVION_CACHE_CLI_MISMATCH) and the owner has not authorized a Codex update. V2 is a same-session V2 by the author of V1. All three are one author's work: nothing here is independent, and no Codex work is claimed. Sources and selection table: assurance\V3\STANDARDS-CHECK.md and assurance\V3\REPORT.md.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W37\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W37\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W37\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W37\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order; where a step has more than 26 edits its letters cycle after z. Every payload is inline, so replay needs no source file. docs/history/LOG.tsv is a generated log carried as bytes: Organize -Clean -Apply wrote its 158 new rows once, at WS-033 step P8.2 in the Original; they were kept byte-exact as data/records/WS-037/evidence/LOG-pending-158-rows.tsv (SHA256 64D1B7116EB481047F4FE49C99E127013195E12C91AE6CE4AD4315C31C3FA674) and the tracked file restored so the Original is clean for admission. DEC-28 lets only Organize write that file; this literal step lands Organize's bytes unchanged, and after it only Organize writes the file. That is a narrower reading than DEC-28's words, which the owner's authorization of about 19:00 Cairo names (its item 5); the execution approval cites it, and without that the step does not run. The HANDOFF.md step states the Lift line's insertion as a replacement of the section 12 heading line, which it writes back with the same bytes, because the line before the insertion is the closing fence of the format block and a fence cannot carry it.

1. Check whether `docs/DECISIONS.md` contains `At Lift, all seven legacy folders stay. Later deletion requires DEC-10 and owner approval.`; if so record Already Applied when its Git blob is d4dcca1de8ba151ff4590690a27a9398f26bc396, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-037 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   At the Lift the owner deletes the five legacy folders; until then they stay owner-controlled.
   ```
   with
   ```text
   At Lift, all seven legacy folders stay. Later deletion requires DEC-10 and owner approval.
   ```

   b) replace the lines
   ```text
   Changed: 2026-10-31
   History: D2, D3, D4, D26, D34, D38, D46, D58
   ```
   with
   ```text
   Changed: 2026-11-07
   History: D2, D3, D4, D26, D34, D38, D46, D58, D126
   ```

   The resulting file's Git blob is d4dcca1de8ba151ff4590690a27a9398f26bc396.

2. Check whether `docs/history/DECISIONS-ARCHIVE.md` contains `## D126 2026-11-07 Owner: A6 Owner Lift approved; all seven legacy folders stay (transcribed at the owner's instruction)`; if so record Already Applied when its Git blob is cba8459172c8a55ab5ba2e9035d933706e777210, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-037 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   Now in: DEC-01, DEC-26
   ```
   insert
   ```text

   ## D126 2026-11-07 Owner: A6 Owner Lift approved; all seven legacy folders stay (transcribed at the owner's instruction)

   The owner's words verbatim, as quoted in data/decisions-inbox.md until this contract (byte copy:
   data/records/WS-037/owner-words/decisions-inbox-20261107T1900.md, SHA256 33E5817BDB7E3E20A5B2DBE09F58DE905AC53D8C46799922C075768675AC7AA1).

   2026-11-07 18:30 Cairo: A6 Owner Lift approved; all seven legacy folders retained (DEC-05 amendment pending), the A6 decision:

   > # Owner Decision — A6 Lift Approved, Legacy Folders Retained
   >
   > I have reviewed the WS-033 handoff and `LIFT-READINESS.md`.
   >
   > **My final Owner decision is: APPROVE A6 — Owner Lift, with all seven legacy folders retained temporarily.**
   >
   > This supersedes only DEC-05's requirement to delete the five legacy folders at the Lift. No other governance decision or approved workflow is changed.
   >
   > ## 1. Record the narrow DEC-05 amendment
   >
   > Verify the current authoritative `docs/DECISIONS.md` and its byte budget.
   >
   > Replace only this existing sentence:
   >
   > "At the Lift the owner deletes the five legacy folders; until then they stay owner-controlled."
   >
   > With:
   >
   > "At Lift, all seven legacy folders stay. Later deletion requires DEC-10 and owner approval."
   >
   > Preserve the remaining DEC-05 text, its accepted residual risks, and the 40,960-byte document limit.
   >
   > Do not modify DEC-10.
   >
   > ## 2. Retain all seven legacy folders
   >
   > The exact seven paths are listed in `data/records/WS-033/LIFT-READINESS.md`, Section 5.
   >
   > I explicitly authorize their temporary retention, not their deletion.
   >
   > This includes the five Documents folders and both ORVION-Owner-Tools folders in GitHub and OneDrive.
   >
   > Do not delete, relocate, clean, or overwrite these folders. Keep the 14 historical file versions and all existing rollback material.
   >
   > My approval of the seven-path inventory is NOT approval to delete any of those paths.
   >
   > Any future deletion requires the applicable DEC-10 checks, a fresh review of the exact deletion list, and my separate explicit approval.
   >
   > Leave the related restore staging, vault recovery material, and existing client Read grants unchanged for now.
   >
   > ## 3. Record my Owner Lift decision
   >
   > The five HANDOFF Section 12 criteria are reported as MET in the completed WS-033 readiness package.
   >
   > I explicitly approve A6 and authorize transcription of my Owner decision into the existing authoritative `HANDOFF.md`, Section 11, using its prescribed format:
   >
   > `LIFT 2026-11-07: Batch 6 hold lifted by the owner; HANDOFF.md section 12 criteria 1-5 evidenced in data\records\delegation-20261026\LIFT-EVIDENCE.md.`
   >
   > This is a record of my explicit Owner decision, not a new decision delegated to the agent.
   >
   > First reconcile DEC-05 using the narrow amendment above. Follow the existing repository approval, writing and validation controls. If a native control prohibits recording the Lift through this route, STOP and report that specific blocker rather than bypassing it.
   >
   > Do not use the attached `HANDOFF(6).md` as a replacement for the repository's authoritative `HANDOFF.md`; verify the actual file and its current contents first.
   >
   > Preserve my words in the existing owner-decision archive as required by DEC-01.
   >
   > ## 4. Preserve all unresolved risks
   >
   > Keep the following accurately recorded:
   >
   > - Restore Launcher remains UNPROVEN on the post-fold layout.
   > - Fourteen older Owner-Tools file versions remain retained.
   > - `Organize -Check` reported FAIL 360; do not relabel it PASS.
   > - Windows format readiness remains NOT READY.
   > - Save-State's vault cleanup workaround is not its permanent code fix.
   > - Independent review gaps, memory-margin decisions and other R1–R9 risks remain open or accepted exactly as documented.
   >
   > Do not introduce additional remediation into this Lift-recording step.
   >
   > ## 5. Verify, save and STOP
   >
   > After the bounded governance update:
   >
   > 1. Verify the exact DEC-05 change, the Lift record, the document byte limit, and applicable existing guards.
   > 2. Confirm that none of the seven legacy folders or protected backup materials changed.
   > 3. Save the Owner decision and update the authoritative continuity records.
   > 4. Run the existing Save-State procedure and publish the updated status page.
   > 5. Report the exact changes, evidence, and current Lift status.
   >
   > **STOP after recording and verifying the Lift.**
   >
   > This approval removes the programme-level Batch 6 hold, but does not authorize executing Batch 6 inside ORVION or CRM. Each product still requires its own native Boot, SPEC authorization and lifecycle.
   >
   > Do not begin B15, Batch 6, deletion, Windows reinstallation, Codex updates, RAM changes, scheduled-task modifications or unrelated improvements as part of this step.
   >
   > No new architecture, review cycle or workstream. Execute only this approved Owner decision.

   2026-11-07 ~19:00 Cairo: one narrow Workbench contract authorized to record A6 (inbox not accepted as the final Lift record):

   > I have reviewed your assessment and recommendations.
   >
   > I agree that a dedicated contract is expensive for a small textual change. However, I do not approve treating `decisions-inbox.md` as the final A6 Lift record while DEC-01, DEC-04, DEC-05 and HANDOFF Section 11 still prescribe the formal recording process.
   >
   > **My decision: authorize ONE narrowly scoped Workbench contract to resolve this proven governance blocker.** This is a limited exception to my earlier instruction against creating another workstream, not permission for additional improvements.
   >
   > The contract must:
   >
   > 1. Incorporate my already-approved A6 decision from the inbox, preserving my exact words.
   > 2. Amend only DEC-05's legacy-folder deletion requirement. All seven folders remain intact; any future deletion requires DEC-10 and separate owner approval.
   > 3. Record the approved Lift line in HANDOFF Section 11 through the native authorized procedure, respecting DEC-02's owner-only authority.
   > 4. Update only the required decision archive, decision map, inbox and associated evidence.
   > 5. Address the 158 pending `LOG.tsv` rows only as required by the native clean-checkout admission, preserving their provenance.
   > 6. Preserve the existing byte limits, guards, mandatory assurance, native lifecycle and release requirements.
   >
   > Do not shorten or bypass required gates, but do not introduce unnecessary review work, additional features, new architecture or unrelated fixes.
   >
   > Before execution, verify that the proposed contract can legitimately record the owner's Lift line. If DEC-02 or another binding rule still prohibits this even with my explicit transcription authorization, identify the exact blocker and STOP.
   >
   > Keep all seven legacy folders, historical versions, rollback copies, recovery material and existing product dependencies untouched.
   >
   > No Batch 6 execution, B15, Codex update, RAM change, scheduled-task modification, or unrelated cleanup.
   >
   > Execute only the authorized native contract and its required release, preserving evidence of any failure. After the formal Lift record is verified, report the result and STOP. Both products still require separate Batch 6 authorizations.
   >
   > **Priority: compliant completion with the minimum necessary work—not optimization, expansion or perfection.**

   Transcribed by Claude main at the owner's explicit instruction of 2026-11-07: the DEC-05 sentence and the HANDOFF.md
   section 11 Lift line are the owner's own text. Neither is DELEGATED, and neither was typed by the owner.

   Replaced wording of DEC-05, verbatim:

   > ## DEC-05 Lift criteria and accepted open risks
   >
   > The owner decides the Lift on the closure criteria of HANDOFF section 12 as amended. Criterion 5, amended when the
   > owner cancelled the Windows reinstall: the isolated restore of orvion-backup-20261026T201821Z.7z (done 2026-10-26)
   > plus one isolated run of the released Restore-ORVION.cmd against a fresh package (same-machine PASS on 2026-10-28:
   > records/WS-029/package/successor/step3/attempt-20261028T180229Z-r2/result.json). With the reinstall cancelled,
   > clean-Windows recovery (contract C2) is not a Lift condition. Stated as open wherever the Lift is discussed:
   > clean-machine recovery and clean-Windows tool installation are UNPROVEN (residual risk accepted by the owner); Shared
   > Evidence is WAIVED as a closure prerequisite, not earned, and no assurance is claimed from it; CTRL-19 is OPEN with
   > its residual risk accepted (both gh tokens are reachable by this OS user; main protection depends on GitHub settings).
   > At the Lift the owner deletes the five legacy folders; until then they stay owner-controlled.
   >
   > Scope: the Owner Lift and every report that mentions it.
   > Why: the Lift must rest on what was proven, with every open risk visible.
   > Changed: 2026-10-31
   > History: D2, D3, D4, D26, D34, D38, D46, D58

   Now in: DEC-05
   ```

   The resulting file's Git blob is cba8459172c8a55ab5ba2e9035d933706e777210.

3. Check whether `docs/history/DECISIONS-MAP.tsv` contains `D126	2026-11-07	DEC	DEC-05	A6: Owner Lift approved; all seven legacy folders stay; later deletion needs DEC-10 and the owner`; if so record Already Applied when its Git blob is e4505f358781866081bb50448fcced12957d5e56, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-037 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   D125	2026-11-07	DEC	DEC-01 DEC-26	P7.3 and P7.4: archive, old log and map in docs/history; Save-State the one save method
   ```
   insert
   ```text
   D126	2026-11-07	DEC	DEC-05	A6: Owner Lift approved; all seven legacy folders stay; later deletion needs DEC-10 and the owner
   ```

   The resulting file's Git blob is e4505f358781866081bb50448fcced12957d5e56.

4. Check whether `docs/history/LOG.tsv` contains `2026-11-07T15:17:31Z	delete	temporary	sb/W25	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0526B635715D27E63AAD550834318494FABAB88D01E40A1A29EF6E9F91C264AB`; if so record Already Applied when its Git blob is 1c3f7d470f10728b521034942560f5d1327a3b0c, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-037 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   2026-11-04T17:40:52Z	new	data	-	events	WS-035	T10 organizer	B9B72CA5449DD7EB3FAE21BC5862C5BB6A6BFC5AFC8EFA6244A00771724A97F6
   ```
   insert
   ```text
   2026-11-07T15:17:31Z	delete	temporary	sb/W25	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0526B635715D27E63AAD550834318494FABAB88D01E40A1A29EF6E9F91C264AB
   2026-11-07T15:18:05Z	delete	temporary	sb/W26	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0C3C135C39AF2B9EB3134CE9BA00B77BB1EDA0314A10D2A0D59F50D9419C7945
   2026-11-07T15:18:38Z	delete	temporary	sb/W31	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	7293B821A15E3DFCD3A682E03281AEE92F055BC6FB97CE497FCACD822DA89BCE
   2026-11-07T15:18:51Z	delete	temporary	cx/W26-admission-advisory	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	9C4E06EA0CAF0F36808BDF7D772665B77EAB669B73C07A20BACFB7DF9592D2CB
   2026-11-07T15:18:57Z	delete	temporary	cx/W26-bootstrap	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	CF24E2264258A3CE1F5D3F6E68E3CFB9AD518C6B8C13DEFC4C240848C85D0750
   2026-11-07T15:19:03Z	delete	temporary	cx/W26-literal-negative	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	42D5D27A20926A40D0264B3EE621BFD4B7E3D0687BDEB7B4821DB616FD2666AF
   2026-11-07T15:19:09Z	delete	temporary	cx/W26-literal-positive	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	498F50964C15783DFE175DD460F201D213D321D5C12BFAE21DDB7AB9836926DC
   2026-11-07T15:19:15Z	delete	temporary	cx/W26-m1-tripwire	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	6425EBC37C596D0FB5A76ED34FB5C0559208773CCA97A52C17EA08434079F653
   2026-11-07T15:19:20Z	delete	temporary	cx/W26-m2-exec-memory	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	3B4D5489A2AE04239CD70E2E9F0E7261694D7342CC3B496B169DCD6D4E2BADA2
   2026-11-07T15:19:26Z	delete	temporary	cx/W26-m3-spawn	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	ABEB0F172C6F0051998D380EAAF18211F27B0FA028FAD9B02F26BD314046B1BD
   2026-11-07T15:19:31Z	delete	temporary	cx/W26-prototype	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0C8CE83EB4F4FBD8AEE652D38CADAD6F4BED60C3FF73567B184EBFA82EAE126E
   2026-11-07T15:19:36Z	delete	temporary	cx/W26-r2-literal-negative	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	668FD1662AAD3331AFF786929EABC3801505251B1DAD8F08902EE70C6CA516A0
   2026-11-07T15:19:42Z	delete	temporary	cx/W26-r2-literal-positive	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	C0CDC6CF21A88D4900886B440BBE19C7D223B756E58369183100B35793273AE1
   2026-11-07T15:19:47Z	delete	temporary	cx/W26-r2-mutants	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	C10AC50A18C0F97F495EE090030A9EF4A20E24CBD4C0CDBF4F783929E83129F4
   2026-11-07T15:19:52Z	delete	temporary	cx/W26-r2-mutants-cont	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	E0C17F184E28444FC128E8444692601C60F4A19D9CE316CB858ABAEDF7E9AA0B
   2026-11-07T15:19:58Z	delete	temporary	cx/W26-r2-mutants-coverage	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	1DC6A1530B8D20418532A383071FE6661B53638C8138140234B2D9D51F82B6D3
   2026-11-07T15:20:04Z	delete	temporary	cx/W26-r2-mutants-rest	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	13A365448DD61FF6A89F513325DEC0580E4BCA3BBB9C627C6317872937E781A5
   2026-11-07T15:20:09Z	delete	temporary	cx/W26-r2-rebuttal-a	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0E38FFD5535ACAAAB5CF2D3031D5BFEB941F75744B977F3DC540CA191D327FAC
   2026-11-07T15:20:15Z	delete	temporary	cx/W26-r2-rebuttal-b	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	6D67C1D7A3A984954997014C757E3A2247E40BA978F86B6E9815BC5920C13D51
   2026-11-07T15:20:20Z	delete	temporary	cx/W26-r2-review-a	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	811B4100C479A116B5BD1EF9F4CCCE92A359086843FDE263BEFD274D731BEE59
   2026-11-07T15:20:26Z	delete	temporary	cx/W26-r2-review-b	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	7C02A9565230B8916D86E1ADE6A67FB75F0CB05677F52BE381F6006DF1A5681A
   2026-11-07T15:20:32Z	delete	temporary	cx/W26-research-proof	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	5AAF13D97A71C83D8C7A2206CFCB25FC929FE8026C035FB5BE42BAFFE88AC404
   2026-11-07T15:20:37Z	delete	temporary	cx/W26-review-launcher	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	41CB12D442A32CCBCC6A71898500FCA4E8AB20C332856EBE708CD0F351A645A3
   2026-11-07T15:20:43Z	delete	temporary	cx/W26-v1	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	D0A70961901490DF8E9275B20240A3B66834811789E4B1BE566CD009C4D98122
   2026-11-07T15:20:50Z	delete	temporary	cx/W26-v2	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	9B4DE548DD1370C4DB47CC703FC6F2A65430DCF7BF1D31F85900FD733F9EAFC6
   2026-11-07T15:20:56Z	delete	temporary	cx/W26-v3	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	4B0AF9E198F734F2A2B3E0CC294AC0A11527B22C07D63AB56FD711357A1966D4
   2026-11-07T15:21:03Z	delete	temporary	cx/W26-v3-r2	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	87CD96D3229AEB83E5D2C76042966838E95120998EDD8480AF9BC9A49F824F66
   2026-11-07T15:21:08Z	delete	temporary	cx/W26-v3-repro	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0ABA5D3FE0F042C985358DADDDA96BC53E6440A7EC8DD5C72F57D1321E555368
   2026-11-07T15:21:14Z	delete	temporary	cx/W26-v3-review-a	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	620979728B7E592FD3603733D6CDBE809832B4D14F6AB97B021B7D00C2D26D14
   2026-11-07T15:21:20Z	delete	temporary	cx/W26-v3-review-b	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	60886F471D2D91B8A1C632FE07A7CA2CA0D20F162B3084B8BC1BB4919017A51F
   2026-11-07T15:21:39Z	delete	temporary	cx/W27-prepass	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	4F7BD4D9C152739FB1A767492C119110E4A79B8BDD323FAA454422ACFFA0C6E1
   2026-11-07T15:21:48Z	delete	temporary	cx/W27-prototype	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	92D684F54A7DB9BE410370436C16D94D6D3E6EE434B90DE09D6EB3AF1FDA7FCB
   2026-11-07T15:21:58Z	delete	temporary	cx/W27-prototype-r2	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	28AD1F8E4510D1058940D61EC52A64975E6350AD448AA1C043B62FFAD6355AC1
   2026-11-07T15:22:06Z	delete	temporary	cx/W27-research-catalog-r1	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	C039D921F3829C47B2295D54FE279E1AEDF08D423A3247B5FCCBC038E9E651AA
   2026-11-07T15:22:18Z	delete	temporary	cx/W27-review-codex	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	DA3E4DFA6746348D836C82D604D7FD07B334C6926A17B0F11EA68161C8B17ECD
   2026-11-07T15:22:27Z	delete	temporary	cx/W27-source-pack	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	06597051AA2F39E1BCB8B669E0904ADD1D41FE8CB1927B5C5AD2C6364D9A59DF
   2026-11-07T15:22:37Z	delete	temporary	cx/W27-v1	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	AC446D769349D4FF0AF280B4DAD56467713A90272BA08C142837B264E024D799
   2026-11-07T15:22:47Z	delete	temporary	cx/W27-v2	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	ABD86E9C0FD0C1BD214008C87F800E9685373A6850A2F9A25559ECE8DCC7C26C
   2026-11-07T15:23:01Z	delete	temporary	cx/W28-proto	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	8FF3F6372CAC029708A8CB67A3447065D1BABC111B15F958BAEE5795EF088CC6
   2026-11-07T15:23:09Z	delete	temporary	cx/W28-replay-V1	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0B2B9C80D6D84D31B6A9B6E6300039FD4811387E2548800FD81CFF2710440538
   2026-11-07T15:23:18Z	delete	temporary	cx/W28-replay-V1-attempt1	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	9F235A4FD9E711B3C42B2DFB2A7385303117978250CEBD19639E34D29DA13340
   2026-11-07T15:23:27Z	delete	temporary	cx/W28-replay-V2	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	A0B4261AEB17573B1E1DEA38139DDF1B6F6AD758FBA9534051D88AAA2B918BD7
   2026-11-07T15:23:35Z	delete	temporary	cx/W28-replay-V3	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	DAE0732F6AF7CC8FA6466D4B936CD29895D8F5F2C7E93BB5C4F2CA17DA04002E
   2026-11-07T15:23:44Z	delete	temporary	cx/W28-replay-V4	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	FF2E95947DDADC22FD87FD349F7D5D895058BBBD95DFBE6F49007DE504C46C0D
   2026-11-07T15:23:52Z	delete	temporary	cx/W28-replay-V5	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	1E3EA2C2B8A46CA66F4829942725EC74D02E245D96762E47300EABCB728077A9
   2026-11-07T15:24:01Z	delete	temporary	cx/W28-replay-V6	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	906EA595E4A1E6949ECCC3B68A63143C564D5EE3E747A0D63F9216328D1BE30C
   2026-11-07T15:24:10Z	delete	temporary	cx/W28-replay-V7	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	040057B7B7191B5BA8E36FF7A606F011C27674706A072945A36FC21D4500307A
   2026-11-07T15:24:19Z	delete	temporary	cx/W28-review	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	5A8BDE3B79091ABC0460C33537CE72B070E0D85E82D9E26FF15BAD64E8CDBD03
   2026-11-07T15:24:27Z	delete	temporary	cx/W28-review-v4	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	90F73B36EF60614BC576446EB2728BD606E68B1C764DAFBB98B1A2B02485D579
   2026-11-07T15:24:28Z	delete	temporary	cx/W28-review-v5	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	DAEC507E820D4B8CCC1D4DD3188A654626F18C9EA0E95CAF0C1C79590D0424F8
   2026-11-07T15:24:58Z	delete	temporary	cx/W28-review-v5m	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	FDCBB074A777BA1B1E64CEFD9FBA2823598C40753A41AFD04997582791A1BD41
   2026-11-07T15:25:00Z	delete	temporary	cx/W28-review-v6	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	E1897D63225E9439342FA85D106B1C13DE20FBA18990CCC26F55519824E6100A
   2026-11-07T15:25:25Z	delete	temporary	cx/W28-v2	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0854C3369A4D996CF891C35026628F88AAAEE1D91B92278F590A40706C7A5140
   2026-11-07T15:25:34Z	delete	temporary	cx/W28-v3	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	D6298B2F962BC40B6F929BD0C78093046BD4B186F6C60FAF05D6F7B227C7E628
   2026-11-07T15:26:16Z	delete	temporary	cx/W28-v3-mutants	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	58AEA1C66401C581127AD19CF791138B86B1785EC649ECC61B3E26609850B539
   2026-11-07T15:26:25Z	delete	temporary	cx/W28-v4	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	26785CD5476CB3E57224A40CFE3641DC18C73A7E97E3FFE77E8959536A0B4F32
   2026-11-07T15:27:42Z	delete	temporary	cx/W28-v4-mutants	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	733E0DE1EEBE66F5CD0B314411FA92F5F0FBCE124B1607422AFCA0D14676197A
   2026-11-07T15:27:47Z	delete	temporary	cx/W28-v4-probe	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	73E4F93248E056A21F5AF23F84975C54DC4246534C6272D674E6A4B7091EDE33
   2026-11-07T15:27:56Z	delete	temporary	cx/W28-v5	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	B8ED58F62D7648E8D4675E53B00465A58F801F5B6C72F36FAF484482A93F1C42
   2026-11-07T15:29:28Z	delete	temporary	cx/W28-v5-mutants	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	3FF5220795E2A05EF1B054636ED8B806F586DB5EA608B9738DB4AC4C3C90EE18
   2026-11-07T15:29:28Z	delete	temporary	cx/W28-v5-probe	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	BE56D0965D1CA0A0E3D84D346C053DAD33C4EAE283279D78799C720150FCEF62
   2026-11-07T15:29:37Z	delete	temporary	cx/W28-v6	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	C89340B777635FC1E9ACA75BC42771B4CD23BE3B07A785D8756F4B3D0560C4F9
   2026-11-07T15:31:07Z	delete	temporary	cx/W28-v6-mutants	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	6023229990BD6A09B625896CD74DBE4B87A91A260DCFED7979AF79ED1CB388B8
   2026-11-07T15:31:08Z	delete	temporary	cx/W28-v6-probe	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	6AE6C187F4A6D5F76495FE4A7E71AA793307ECD0557EDE26220D606CE9D30E87
   2026-11-07T15:31:53Z	delete	temporary	cx/W28-v7	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	F9B357C5EC6C8B6C221CC4F737885733BD494BB947AA55FDB7F84B618E793470
   2026-11-07T15:33:27Z	delete	temporary	cx/W28-v7-mutants	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	EE61FBF33B71591B8FCCE46A4B16EDE836333F64A5283E35D3E70818182C27E8
   2026-11-07T15:33:28Z	delete	temporary	cx/W28-v7-probe	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	85A081BACB341BBD2BA22F3422CF14089317DF67DED54D33140AB5649BED29D5
   2026-11-07T15:33:29Z	delete	temporary	cx/W28-v7-selfreview	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	6FE13AB4FAC365EB1BF40227B9C565413AC9EF9542FD23A27F592F50E467FEB6
   2026-11-07T15:33:34Z	delete	temporary	cx/W31-bootstrap	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	1878FD8C1A08F740A729732F3E12D39E6F5F75BFB42E86EAF870DB1C76C0BC4F
   2026-11-07T15:33:39Z	delete	temporary	cx/W31-claude-qualification	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	AA6D8D3738B7229EC9D954A9D79289BC88113E70868EF95CC5DD28943B31273B
   2026-11-07T15:33:47Z	delete	temporary	cx/W31-prototype	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	2ACB6CAC6433EE5B2FDAE21151959A3523776365887CC71138C66E97A639ADB1
   2026-11-07T15:33:53Z	delete	temporary	cx/W31-review-a	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	DEF00C22CCE5A33B151BA2002A397FEFCAD62E6CC5F6A81AF009DB3ECC77216E
   2026-11-07T15:33:58Z	delete	temporary	cx/W31-review-b	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	4194D2595EFD9458EB8A19F268D32B16CAA63311616B4064F613EADD830268AA
   2026-11-07T15:34:04Z	delete	temporary	cx/W31-sol-bootstrap-review	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	717E85E8DD31D631378C19F274C5ABFE25F034A6AC5207EEA5C9FAE9E9A4DD70
   2026-11-07T15:34:09Z	delete	temporary	cx/W31-v1	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	82B4D6A896D7A8BDB96666873F6B4B78E1B34B1D5C4AD40580BF141D3F768FD7
   2026-11-07T15:34:15Z	delete	temporary	cx/W31-v1-literal-negative	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	D40F016771732B1DDA207D2D11B278918752669D7C4DC7A689FA4E660675CC29
   2026-11-07T15:34:20Z	delete	temporary	cx/W31-v1-literal-positive	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	8BC5A5DA10D878AD7760A2B15586341BF24FA669BF89130B3332675348504FB6
   2026-11-07T15:34:27Z	delete	temporary	cx/W31-v2	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	C5A8E8FEDAD0E1E2D7BF7AF19181F752062A2FDB0FBD9D9E91DBF705F4766EE8
   2026-11-07T15:34:33Z	delete	temporary	cx/W31-v3	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	61321691E03EE806B9D54EA4E79C9BBC5701B3C2DC6839EE18157A2D6CE9088B
   2026-11-07T15:34:38Z	delete	temporary	cx/W31-v3-r1	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	3BE60CAB4961DA8D70C7DAE6E3FD61C3CA78E455EC9BF0F098949981BDC344DC
   2026-11-07T15:34:49Z	delete	temporary	cx/W33-dcomp-V2	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	8081B666949471141FFB27AA7933A70F2FC55C3D860EC1C314D178D08435E129
   2026-11-07T15:34:58Z	delete	temporary	cx/W33-dcomp-V3	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	6DAB3212076C8FA2295F2FDE907E41D8D44438DB5B691C4BAA169ECA45FE7459
   2026-11-07T15:35:08Z	delete	temporary	cx/W33-draft	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	FE666AC5FDE885514265B31F5D5B3F86CFBDEA15CD69471DD1421F17D5177649
   2026-11-07T15:35:26Z	delete	temporary	cx/W33-replay-V1	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	53209A9D93FFED761AEDB9366E4E7DA68ACFB2CCEAD1BF8560A5EFFEAA1C64AB
   2026-11-07T15:35:36Z	delete	temporary	cx/W33-replay-V2	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	F79BB7D48824BFE10AF208879E2DF1628673FC90D0D03C556686652BFE2277AF
   2026-11-07T15:35:44Z	delete	temporary	cx/W33-replay-V3	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	D5E3339A6BC8BC451F33D96D8D62B9A1A561CD7D9159E47E9F980143FFB9B6CF
   2026-11-07T15:36:36Z	delete	temporary	cx/W33-v3	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	F4F2316E64DCEFBDDB5131D515651B89ED3587ABB1D8498D5078F6120950C380
   2026-11-07T15:36:36Z	delete	temporary	cx/W33-v3-mutants	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	B837875B126A8DE068F02DD0CF3F8FAECA82848CADF559BCD643994F7D339E3C
   2026-11-07T15:36:37Z	delete	temporary	cx/W33-v3-mutants-final	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	999FBBB5F8367F464C52515333FEFDB32F66574432044B3B455FF47AF2A659F5
   2026-11-07T15:36:37Z	delete	temporary	cx/W35-ackfull	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	84964863F39DA9C8C1E499D7C6B867A1C296E989BDC29A63D7902678AE1A762C
   2026-11-07T15:37:02Z	delete	temporary	cx/W35-draft	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0672B02EF220CA7E60A2454C372E4161D865875717305E2D71966101621D52D4
   2026-11-07T15:37:02Z	delete	temporary	cx/W35-replay-V1-14bfd8	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	563C1F3F37D243F26B7D4F8D77D9ADFCDCCDC34A87C0EBB8B9C926AFCA4817D8
   2026-11-07T15:37:03Z	delete	temporary	cx/W35-replay-V1-f56bd6	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	2C469A80994883F46A5850DA30CEC7005F0B0F553E59755B4343806A721E1DA6
   2026-11-07T15:37:03Z	delete	temporary	cx/W35-replay-V2-18addf	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	35BB716BE840DDF3E7823DA9ABCF23AD00DB6A38713311CD8329B28858AE8062
   2026-11-07T15:37:04Z	delete	temporary	cx/W35-replay-V3-3368a3	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	25BC30823456027A8F10B1C2D6DD279AE3AD75000A327F1745672C485C6636E2
   2026-11-07T15:37:20Z	delete	temporary	cx/W36-draft	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	EB1DA90D4BCE414FBBBEA673797E0778BF2C5C586CA8FBF21EB3FC0649BA11D3
   2026-11-07T15:37:21Z	delete	temporary	cx/W36-organize-base-original	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	A9097BCBEA659EDA2C332076F2192E963CF2E8743579E0E28C02214F73ED8FC2
   2026-11-07T15:37:21Z	delete	temporary	cx/W36-organize-base-sandbox	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	3AB468C490DD1998936B1157C922F5A2B9EBA5A9E666355F803AFAFB078ED076
   2026-11-07T15:37:21Z	delete	temporary	cx/W36-replay-V1-b3cf19	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	51D98613E3D6F718542FBDFD6D94F32B78F3B09CD6264B8815B377AC8F7EA84C
   2026-11-07T15:37:22Z	delete	temporary	cx/W36-replay-V1-b7511a	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	3D0063B09240BBB1E749065E33D6BA4BD36C8DA4C890F3E0D664D229760EFB5C
   2026-11-07T15:37:22Z	delete	temporary	cx/W36-replay-V2-04d546	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	29BE43FF28A4EC32E94DFE23980D912F3AC0B13F5F1935BB7AE87E2F9C89F7A7
   2026-11-07T15:37:23Z	delete	temporary	cx/W36-replay-V3-5d3788	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	1FC4B65023B896DE2464B83F843B76675A13C67F3EEF6BF376704C1A9ACD1B20
   2026-11-07T15:37:23Z	delete	temporary	cx/W36-replay-V3-db511d	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	C53C428589B0A3C111B23529582D7FFF9C5830B66234D176EC17140B7EDABB3C
   2026-11-07T15:37:24Z	delete	temporary	scratch/W27-protocol-20261030	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	BB366BEC122FC3DC81BCD6F02E286762EDC96D046AA97C040780C8BC4E3EFF14
   2026-11-07T15:37:33Z	delete	temporary	scratch/W27-prototype-r2	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	6702F910025EDA3BC0F26B9DF8D044F64B6C785641554D3834C3052DC2614C70
   2026-11-07T15:37:40Z	delete	temporary	scratch/W27-v1	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	DDE6B16DCB51930CB9D6CA78627741992593F05BE66A43341830692797D37D9B
   2026-11-07T15:37:42Z	delete	temporary	scratch/W31-claude-qualification	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0EE78FC855A7A79454FD401EDD53E853A9E7B216CF6EFAB429772AAB62B778A9
   2026-11-07T15:37:42Z	delete	temporary	scratch/W31-native-gateway	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	8EF4996B174C35DCFD01179053E3E8A465CD1041988205E934A18C2927410F2F
   2026-11-07T15:37:42Z	delete	temporary	scratch/W31-owning	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:42Z	delete	temporary	scratch/W31-prototype-checks	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:42Z	delete	temporary	scratch/W31-prototype-native-gateway	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	22C6F4FEA5BCDE3542497B6421571678EDC2BBBC96D030BF0357A88A83D84F8E
   2026-11-07T15:37:43Z	delete	temporary	scratch/W33-20261101T083353Z-p12b	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	40DA223A615F350CCC08538E2ECDD7B83FADF4ADD38339F084E278D08C496D35
   2026-11-07T15:37:43Z	delete	temporary	scratch/W33-20261101T181315Z-s2-real-save	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	C8F378E5381384C818BCA947B69ED1182685E35AEA385EAA687AD1BC005CFB5A
   2026-11-07T15:37:43Z	delete	temporary	scratch/W33-20261101T181534Z-s2-real-save	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	E6A33B313A6C43EA9B7088585DA28D50FFD0364DFB03DD730642CC17D18BAA18
   2026-11-07T15:37:44Z	delete	temporary	scratch/W33-20261101T182819Z-s3-dev	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:44Z	delete	temporary	scratch/W33-20261102T120020Z-s9p2-map	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	CCCD1AB353F10C38F55085B7F2E0A5CAC4194F23C19C567B0DB621854B8EBB52
   2026-11-07T15:37:44Z	delete	temporary	scratch/W33-20261102T120933Z-s9p2-map	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	B77FAD24151CF779E7F3E07AF8B21E29997AC1F3F819A25C102E7E5DD37C967F
   2026-11-07T15:37:45Z	delete	temporary	scratch/W33-20261104T033532Z-codex-bd7786ec	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	698CE604999BFD0E40190279ABC253CA9737C0F263082AD2230B928DE627B767
   2026-11-07T15:37:46Z	delete	temporary	scratch/W33-20261104T042140Z-codex-53991eb5	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	28383AE27C1197D0AE4A172D6BB2B4A9DF39B0CFA97619D085AFCFD0CE71CDBC
   2026-11-07T15:37:47Z	delete	temporary	scratch/W33-20261104T043448Z-codex-5c921139	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	73271F5085F11A2E75EB9B95E0A31FE4B5B442796576A7A79AD658ECDCA8A838
   2026-11-07T15:37:48Z	delete	temporary	scratch/W33-20261104T164500Z-p7-verify	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	CC53FBD376FCDB0D5075914287A012CAB1F7BD4C7AE66F24A7C20B35FCF2789D
   2026-11-07T15:37:48Z	delete	temporary	scratch/W33-20261104T165028Z-contract-proto	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0A24A43F63EF2FED36A821576E92A9328FD839461B099819E9A6465B3369FE61
   2026-11-07T15:37:48Z	delete	temporary	scratch/W33-20261104T170933Z-contract-proto2	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0C0788939274E61409C1BB832B445E308A01352C14B70115FDF845BE94968FD0
   2026-11-07T15:37:49Z	delete	temporary	scratch/W33-20261104T171034Z-contract-proto2	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	8DC9574C7A59AFA134D2F2ACB8C831EF8A693AD2385FDD342C1E4AD84E23DF74
   2026-11-07T15:37:49Z	delete	temporary	scratch/W33-check-V1-b81e9602	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:49Z	delete	temporary	scratch/W33-check-V2-c144030e	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:50Z	delete	temporary	scratch/W33-check-V3-afe7a0b0	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:50Z	delete	temporary	scratch/W33-d107	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	1175BCCC61DF299B76B31AE8E68645325D7F4A4C52A26224BA98133C0EEA6B6B
   2026-11-07T15:37:50Z	delete	temporary	scratch/W33-dcomp-365958	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	9EC3ABE551A42A4C0BE32832AC944397CE55B07882562A2C25748BC8C8E1233E
   2026-11-07T15:37:50Z	delete	temporary	scratch/W33-dcomp-bb3ecf	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	455F568D52B197D7528D19D859FCE3F5C6D1CE659FA634C24B26F1EC85C9CBE0
   2026-11-07T15:37:50Z	delete	temporary	scratch/W33-guards	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	72D516105CEA5D089CBFCBB32B5EAA904241F9709A77EAE2951E60FC18B6D3F9
   2026-11-07T15:37:51Z	delete	temporary	scratch/W33-p72b-run	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	779B101E5311AF9F49CAFE81070773C7591AC681FE38ACBC86A999F8EEB4CC9D
   2026-11-07T15:37:51Z	delete	temporary	scratch/W33-s1	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	5A7B08F29B216EA98F7A6F5AB7A5E577BE0B1086BFCED0DFAC605694CBDE570B
   2026-11-07T15:37:51Z	delete	temporary	scratch/W33-s9-lint-base	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	A5E0A848B53FCA2ADF1B5A7B374F046C7E7989B4740306A3B57F2AC674E36999
   2026-11-07T15:37:51Z	delete	temporary	scratch/W33-status	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	85E053E1AD0BF876C70114DE1BB15311AA0379E7A4FCA694D36BBBA1EAB5970A
   2026-11-07T15:37:51Z	delete	temporary	scratch/W33-summaries	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	CA1F796971343FA795333E728A5A82776F63F26B79541C2383CC0CB95AE057AC
   2026-11-07T15:37:52Z	delete	temporary	scratch/W33-verify-V2-ace17ce8	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	877663D53AC3500F10D7916C91D758612656501125AEBF0808602A5613CE9F27
   2026-11-07T15:37:53Z	delete	temporary	scratch/W33-verify2-4c6cd6	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	58F75B93E6C3DBEFC5D9226BD7C87F923A7274DD1AC6117D13ED251A4FF83984
   2026-11-07T15:37:53Z	delete	temporary	scratch/W33-verifyV3-5c51a3	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	0395AEC55691DABC8B2B672B57ED40D94D72C92DB191C07500E086C056DC900D
   2026-11-07T15:37:53Z	delete	temporary	scratch/W33-verifyV3-d06ea9	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	88A56AE5AA1D14A14AF2CF6D6E324D75BA8EE47730697DED01AAA5BA1F20672F
   2026-11-07T15:37:53Z	delete	temporary	scratch/W33-verifyV3-de6579	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	7E4C4DA45BCF9C18A2C6FB881B715658CAA09B7174390C0C833220CA58C95409
   2026-11-07T15:37:54Z	delete	temporary	scratch/W35-20261104T173706Z-contract-proto3	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	30358E3DACC4BA54D812ABB23E29F2026CFB96FDE79364692D7B2C22939DC088
   2026-11-07T15:37:54Z	delete	temporary	scratch/W35-20261104T174032Z-contract-proto3	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	F2107BE7333A925EC23AE2CDBD7EBF9F942F9ADFA7E0F7F9A66C4C8447F21DF3
   2026-11-07T15:37:55Z	delete	temporary	scratch/W35-20261104T174619Z-codex-a76f5337	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	A50418B0995E46A3DF47749F57240521624060EB2F9884AC683F9B5AD3250987
   2026-11-07T15:37:55Z	delete	temporary	scratch/W36-20261106T231217Z-codex-caa43d2d	-	WS-033	disposable: P8.2 per the P8.1 list, owner 2026-11-07	509FEF23C74389CAC4170078468AE93473E504541C4E681DDD869696659D01F5
   2026-11-07T15:37:55Z	delete	temporary	scratch/fd299-v2/author-pass2/mutants/candidate-parent/V2/probe.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:55Z	delete	temporary	scratch/fd299-v2/author-pass2/mutants/positive/V2/probe.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:55Z	delete	temporary	scratch/fd299-v2/author-pass2/mutants/promote-candidate/V1/probe.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:55Z	delete	temporary	scratch/fd299-v2/author-pass2/mutants/promote-candidate/V2/probe.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:55Z	delete	temporary	scratch/fd299-v2/author-pass2/mutants/promote-depth/V2/probe.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:55Z	delete	temporary	scratch/fd299-v2/author-pass2/mutants/promote-false-done/V1/probe.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:55Z	delete	temporary	scratch/fd299-v2/author-pass2/mutants/promote-false-done/V2/probe.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:55Z	delete	temporary	scratch/fd299-v2/author-pass2/mutants/publish-candidate/V1/probe.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:55Z	delete	temporary	scratch/fd299-v2/author-pass2/mutants/publish-candidate/V2/probe.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:55Z	delete	temporary	scratch/fd299-v2/author-pass2/mutants/publish-depth/V2/probe.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:55Z	delete	temporary	scratch/fd299-v2/author-pass2/mutants/publish-false-done/V1/probe.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:55Z	delete	temporary	scratch/fd299-v2/author-pass2/mutants/publish-false-done/V2/probe.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   2026-11-07T15:37:55Z	delete	temporary	scratch/ws029-v3/runtime-probe/stderr.log	-	WS-033	empty-log: P8.2 per the P8.1 list, owner 2026-11-07	E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
   ```

   The resulting file's Git blob is 1c3f7d470f10728b521034942560f5d1327a3b0c.

5. Check whether `HANDOFF.md` contains `LIFT 2026-11-07: Batch 6 hold lifted by the owner; HANDOFF.md section 12 criteria 1-5 evidenced in data\records\delegation-20261026\LIFT-EVIDENCE.md.`; if so record Already Applied when its Git blob is 3e5875c6fb68dab0559d1c81ba8e2068cf062c60, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-037 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   ## 12. Success criteria before the programme closes and Batch 6 resumes
   ```
   with
   ```text
   LIFT 2026-11-07: Batch 6 hold lifted by the owner; HANDOFF.md section 12 criteria 1-5 evidenced in data\records\delegation-20261026\LIFT-EVIDENCE.md.

   ## 12. Success criteria before the programme closes and Batch 6 resumes
   ```

   The resulting file's Git blob is 3e5875c6fb68dab0559d1c81ba8e2068cf062c60.

## Acceptance Criteria

- [x] Output `docs/DECISIONS.md` equals its declared resulting Git blob. check: blob:docs/DECISIONS.md=d4dcca1de8ba151ff4590690a27a9398f26bc396
- [x] Output `docs/history/DECISIONS-ARCHIVE.md` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-ARCHIVE.md=cba8459172c8a55ab5ba2e9035d933706e777210
- [x] Output `docs/history/DECISIONS-MAP.tsv` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-MAP.tsv=e4505f358781866081bb50448fcced12957d5e56
- [x] Output `docs/history/LOG.tsv` equals its declared resulting Git blob. check: blob:docs/history/LOG.tsv=1c3f7d470f10728b521034942560f5d1327a3b0c
- [x] Output `HANDOFF.md` equals its declared resulting Git blob. check: blob:HANDOFF.md=3e5875c6fb68dab0559d1c81ba8e2068cf062c60
- [x] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [x] AC-01 DEC-05: docs/DECISIONS.md is at most 40960 B after LF normalisation and passes the Markdown guard with this contract in place. DEC-05 is the only entry that differs from baseline, and within it exactly three lines change: the sentence "At the Lift the owner deletes the five legacy folders; until then they stay owner-controlled." becomes the owner's sentence "At Lift, all seven legacy folders stay. Later deletion requires DEC-10 and owner approval.", Changed: becomes 2026-11-07, and History gains D126. DEC-10 is unchanged.
- [x] AC-02 Lift line: HANDOFF.md holds, exactly once and in section 11 after its format block, the owner's line "LIFT 2026-11-07: Batch 6 hold lifted by the owner; HANDOFF.md section 12 criteria 1-5 evidenced in data\records\delegation-20261026\LIFT-EVIDENCE.md."; the only other change from baseline is one blank line; the evidence file it names exists in the Original's data root (data/ is git-ignored, so no clone holds it).
- [x] AC-03 Archive and map: docs/history/DECISIONS-ARCHIVE.md changes only by appending item D126, which quotes both owner texts verbatim as frozen in data/records/WS-037/owner-words/decisions-inbox-20261107T1900.md (SHA256 33E5817BDB7E3E20A5B2DBE09F58DE905AC53D8C46799922C075768675AC7AA1), states the transcription at the owner's instruction, quotes the replaced DEC-05 verbatim and ends Now in: DEC-05; docs/history/DECISIONS-MAP.tsv changes only by appending row D126 and has one row for each of D1-D126; no map row or archive item names a missing DEC entry.
- [x] AC-04 Log rows: docs/history/LOG.tsv has SHA256 64D1B7116EB481047F4FE49C99E127013195E12C91AE6CE4AD4315C31C3FA674, equal to data/records/WS-037/evidence/LOG-pending-158-rows.tsv; its baseline bytes are an exact prefix and 158 rows are appended. Organize -Check, the DEC-28 guard of this file (G09 LOG_REWRITTEN and the TSV schema), runs once on this role's checkout and once on a disposable clone at the baseline, both read-only with the same data root and temporary root; exit and lines by class are recorded as an observation; no line names an output of this contract, and no line is added apart from UNKNOWN lines for git-ignored, untracked folders of the live checkout that the range does not touch and a clone cannot hold.
- [x] AC-05 Secrets and privacy: gitleaks on the exact candidate range reports 0 findings in the five outputs and RESUME.md; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; no allow marker or ignore file is added; neither masked value (the computer name, a marketing tunnel script name) is in any changed file or in this contract.
- [x] AC-06 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json.
- [x] AC-07 Boundary: the seven legacy folders, the vault step3 folder, the restore staging and the nine packages equal their record in data/records/WS-037/evidence/protected-before.json when captured again with data/records/WS-037/Capture-Protected.ps1 (file count, bytes, newest write and listing SHA256 per folder; name, size and write time per package; attributes only, cloud files never hydrated); no CRM or ORVION change, no Batch 6, B15, deletion, Codex, RAM or scheduled task change, no push or release under this contract. Commits stay local (DEC-25).

## Review Gate

- [x] Inspect the live subject, this role's fresh receipt, timing and watching evidence, and every criterion above, with attempts, deviations and gaps kept visible. No prototype result or earlier receipt substitutes for this role's gate.
- [x] Review: one Claude-main self-review, labelled as such and never called independent, and the Codex review (DEC-14). Codex unable to dispatch at that point: its review is recorded SKIPPED, never replaced or claimed, and Claude main's is the only one (D120). At most one corrective version; a remaining material disagreement goes to the owner.
- [x] Retro (DEC-12): Claude main, and Codex if it reviewed, name what does not satisfy them, each item with a remedy and a check.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Append only. No approval, execution-root binding or receipt is claimed. At actual approval add exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line using actual immutable identities. Owner evidence must name the approved digest and execution root. For original execution append exactly one Sandbox Receipt and Sandbox Receipt SHA256 for the matching successful schema2 sandbox artifact. A delegated decision needs actual live owner delegation and is labelled delegated. Never invent human confirmation or approval.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-037\assurance\V3\DRAFT.md
Approved SHA256: 60BF02146E90B4F187FB1C769DDEC151B930CBEE4EBF6F4ADAEA6619FF66D8A1
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-037\gate\GATE1-WS037-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: 9CAC0E83AFFFD6B672C56FB8E69D51FACA1F8C1A28AF98E89F353D7350E220F3
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W37\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 087BB5B9C3285F4A5AC507CB127D944546A9016EB6969AD9FE406522E083EA57
Original exact declared outputs applied by accepted native Execute; fresh own Finish and Review/Complete remain required. Other protected roots unchanged.
Residual risks carried unchanged from the selected Draft Review Gate and V3 REPORT.md; Codex SKIPPED by owner decision 2026-11-07 ~23:20 Cairo (data/decisions-inbox.md, 2B), not by unavailability. Release is a later stage.

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W37-draft. Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json and REPORT.md beside this Draft. After Complete, outside this contract: the release is its own stage (DEC-25); the two folded inbox items are then removed from data/decisions-inbox.md, the protected state is compared with its record from before, and Save-State and the status page record the result. V3 sources and selection table: STANDARDS-CHECK.md and REPORT.md beside this Draft.
Verdict: Confirmed Complete
Reviewed Fingerprint: D7C8FDBCF5578993D63AB98808F60719216C62E299A8B4633B5DCFCE4E526A89
Reviewed Receipt: C9A068B3A9B6D67728BD63C5142B88D0AD0C2729F3A1E0415949FAE37295C341
Live ORIGINAL-role review: runtime/original/criterion-review.json. Own Finish 31 ordered suites, runner/watcher/host 0/0/0, real journal unchanged. Review: ONE Claude-main SELF-REVIEW, not independent; Codex SKIPPED by owner decision 2026-11-07 ~23:20 Cairo (data/decisions-inbox.md, 2B), not by unavailability. Exact completed sandbox proof 92E00835488F33E15954881477DE5B3B519F39A3C38EC7AB8F40F68C163E133E bound. Not pushed; release separate.

