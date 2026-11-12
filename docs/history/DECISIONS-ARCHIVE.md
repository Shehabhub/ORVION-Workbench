# Decisions archive

Append-only. Each item: its archive ID, date, the owner's words verbatim, the replaced wording and `Now in: DEC-NN`.
Items D1-D122 are in DECISIONS-LOG.md (byte-exact old log); DECISIONS-MAP.tsv gives every D-number its entry.

## D123 2026-11-07 Owner: G1-G4, programme order and the product overlay narrowed (A0 2026-11-07; A3 DELEGATED)

The owner's words (2026-11-06 23:38 Cairo, data/records/WS-033/owner-words/20261106T2138Z-direction-and-migration.md,
section 2):

> ### 2. Approval of the Proposed Direction
>
> I approve the overall direction of your recommendations:
>
> - Preserve WB as a lean workspace-wide support layer.
> - Remove unnecessary WB Draft and sandbox overlays from native product change cycles.
> - Narrow DEC-13 and DEC-23 appropriately.
> - Permit the second paired change request to be derived from the first, with all differences explicitly documented.
> - Preserve independent native Finish, parity, CI, receipts, and certification.
> - Complete the outstanding restore acceptance requirement.
> - Reduce Save-State complexity and session startup token consumption.
> - Reconsider the DEC-04 ordering so Batch 6 is not unnecessarily blocked by WB development.
>
> However, this is approval of the engineering direction, not permission to discard incomplete migration work or silently rewrite already-ratified decisions.
>
> Before implementing the reordering, identify any migration dependencies that must be protected and present the resulting executable sequence.

A0, 2026-11-07 00:14 Cairo: "yes" (the revised sequence, PLAN.md section 6, whose M2 carries G1-G4). The exact text
(A3) was approved under the owner's temporary delegation of 2026-11-07 (data/records/WS-033/owner-delegation-20261107.md,
section 2: "A2/A3 decision preparation and amendments ... only where the WB Constitution permits"; section 4 item 5),
recorded DELEGATED (DEC-02), never as typed by the owner. Reading and checks: data/records/WS-033/DELEGATED-DECISIONS-20261107.md.

Replaced wording of DEC-04, verbatim:

> ## DEC-04 Programme order to the Batch 6 threshold
>
> WS-033, then WS-034, then the Owner Lift through its existing process, then STOP at the Batch 6 threshold. No agent
> starts Batch 6; it waits for the owner's lift record. The Final Stop Packet baseline exists; WS-033 adds a supplement.
> Work stays on this roadmap and on each workstream's plan, with no gap left behind and no new unit, framework, service or
> pipeline outside them. After the Owner Lift the Workbench is in maintenance mode: a new Workbench contract only for a
> real incident, a false green or red, a measured material cost or a proven safety or governance gap.
>
> Scope: the programme until the Owner Lift, and the Workbench after it.
> Why: the owner fixed the order and the stop point; the Workbench must earn its cost against the product.
> Changed: 2026-11-01
> History: D27, D67, D68, D79, D83, D96, D106
> Watch: `(?i)owner lift.{0,120}batch 6|batch 6.{0,120}owner lift`

Replaced wording of DEC-07, verbatim:

> ## DEC-07 WS-034 purpose-based local suite
>
> WS-034 changes the accepted evaluator once, through the full method: the local Finish runs the always-on checks plus
> the tests that own the changed files; the full suite still runs on GitHub before main moves; the Execution Context
> also bounds TEMP (at most 97 characters, with a Tests Root of at most 101; the evaluator does not check this today).
> Its release sets the new evaluator pin. Accepted cost: a break in another area shows first on GitHub.
>
> Scope: WS-034.
> Why: about 20 minutes saved per workstream, while GitHub keeps the full suite.
> Changed: 2026-10-31
> History: D95, D96

Replaced wording of DEC-13, verbatim:

> ## DEC-13 Drafts and their authors
>
> Significant changes get three genuinely distinct Drafts: V1 Design (complete); V2 Adversarial (a revised Draft with
> the reason for each change); V3 Evidence Refresh: V2 brought up to date with the guidelines available online and with
> current global standards, practices, specifications and general recommendations, each with its source, plus native
> admission, owning tests and mutants and sandbox approval. The orchestrator keeps the V1-V2-V3 diffs and a selection
> table (change, pass, evidence) and selects. Differences are never manufactured: an adversary that finds nothing, or a
> V2 that already meets current standards, is recorded as such. Authors: the prototype by Claude main in a disposable
> clone, consulting current official sources; V1 and V2 by Codex in one session, without internet, V1 frozen and hashed
> before V2 (labelled same-session V2); V3 by Claude main, who records whether V2 suffices or what V3 changes. This
> holds for every Workbench slice and contract, and for every CRM and ORVION SPEC within that repository's own lifecycle.
>
> Scope: Significant and Owner-Decision changes.
> Why: real, differing work by capable authors, with the latest standards checked by the agent that has internet.
> Changed: 2026-10-31
> History: D31, D33, D34, D38, D87, D100, D102

Replaced wording of DEC-23, verbatim:

> ## DEC-23 Finish attempts
>
> One Finish per stage. A Finish that ran tests is never rerun to get a pass, a passed check is not rerun, and a Finish
> that has operation.json is never rerun. A fresh attempt is lawful only after an attempt that certified nothing
> because a proven cause outside the candidate stopped it (it ran no test, or a measured host-resource block) and that
> cause was handled, not hidden; the failed attempt's evidence is kept, the decision is recorded, and the new attempt
> must pass in full with its own receipt. During a native Finish: no Codex or other heavy job beside it, resources
> measured fresh just before the start, never an append to the real event journal and no extra heavy copy or scan; its
> own logs and receipts are kept as it runs.
>
> Scope: every native Finish.
> Why: a Finish proves the candidate once; reruns until green would prove nothing.
> Changed: 2026-10-31
> History: D14, D22, D25, D71, D77

Now in: DEC-04, DEC-07, DEC-13, DEC-23

## D124 2026-11-07 D-11: D120 written into DEC-14 and DEC-19; DEC-20's narrative shortened to fit the budget

D120 (old log, 2026-11-04) is the owner's words on the Codex fallback. On 2026-11-05 the owner approved the D-11 trim on
the condition that no constitutional meaning, decision, reference or obligation is lost
(data/records/WS-035/review/P7.3-P7.4-CONTRACT-DRAFT.md section 8). The exact text was approved under the 2026-11-07
delegation (A3), recorded DELEGATED. DEC-20 keeps every obligation and the WS-033 P2.2 reference; only the narrative
("file gone") left the entry.

Replaced wording of DEC-14, verbatim:

> ## DEC-14 Reviews and the correction limit
>
> The frozen V3 is reviewed twice: by Claude main, as a documented review labelled a Claude-main self-review and never
> called independent, and by Codex in the V1 and V2 session.
> Verdicts are ACCEPT, REVISE or BLOCK, with one rebuttal round before a rejection is final; a material rejection cites a
> reproducible defect, a mandatory requirement, a test, a security finding or a named gate; preference never triggers a
> Draft. At most one corrective version, by Claude main, reviewed again the same way; a remaining material disagreement
> goes to the owner as a short decision packet, and only the owner allows another version. A failing native gate blocks
> whatever the reviews say; agreement between agents replaces no gate. Claude main implements through the native
> lifecycle.
>
> Scope: every reviewed Draft.
> Why: a second view and a hard stop on endless revision.
> Changed: 2026-10-31
> History: D24, D31, D38, D73, D74, D75, D77, D80, D82, D84, D85, D87, D100, D102

Replaced wording of DEC-19, verbatim:

> ## DEC-19 Codex role and availability
>
> Codex drafts V1 and V2 and reviews the frozen V3; it has no other standing role. It never uses the internet: hosted web
> search stays off, Delegate refuses -Research, and command network access is off where the CLI allows it. Codex never
> blocks: when it is unavailable or at its usage limit, Claude main does the step at once, labelled as Claude work; the
> failed Codex attempt is kept; Codex is used again from the next step once its limit resets. Codex work that did not
> happen is never claimed. Codex works under supervision: each brief asks for its own proposals and concerns; Claude
> writes its own hypothesis before reading a Codex pass, verifies every material claim against real data before accepting
> it and answers in a disposition table; a rejected Codex item gets one rebuttal round; the record names which agent found
> each defect.
>
> Scope: every use of Codex.
> Why: Codex is an assistant used whenever it is available, never a blocker and never an internet client.
> Changed: 2026-11-01
> History: D20, D24, D27, D47, D55, D72, D73, D76, D77, D83, D100, D106

Replaced wording of DEC-20, verbatim:

> ## DEC-20 Codex launch and safety
>
> Codex runs only through lib/Delegate.ps1, in a disposable clone, never in an original root, with --ignore-user-config (the user's Codex
> configuration loads production MCP servers and tokens). Each run is confined by Codex's MXC Windows sandbox in workspace-write mode:
> the writable roots are the clone and the run folder only, passed per run by Delegate with -c, never as a client-wide setting; .git and
> .codex stay read-only inside them. Those settings exclude Codex's temporary folders, yet inside MXC the default TEMP named the
> container's own AC\Temp and it took a write (WS-033 P2.2, file gone): that folder is outside both roots and the tripwire does not watch
> it, so no confinement is claimed for it, and a delegate sets TEMP and TMP to the run folder first. When MXC is unavailable the run is
> refused and never widened to full access, so a Delegate without this confinement (before slice S6) launches no Codex run. The sandbox
> confines writes; it is not claimed to confine reads, so a delegate never reads the real sessions or events, ~/.claude, ~/.codex or
> ORVION-Owner-Tools (later data/), and its brief embeds what it needs. Delegate's tripwire stays as the second check: it detects outside
> writes (exit 4). Every run passes features.multi_agent=false and disables Codex memories; spawn_agent is still exposed, so prevention
> is never claimed; a confirmed unauthorized sub-agent fails the run; no recursive delegation. Never run Codex beside a heavy job, and
> never touch a watched checkout during a run. The codex-delegate skills are not installed as a global Claude skill.
>
> Scope: every Codex launch.
> Why: confinement instead of detection; the MXC sandbox works on this machine and refused a write outside its folder.
> Changed: 2026-11-04
> History: D7, D8, D9, D28, D33, D36, D37, D105, D106

Now in: DEC-14, DEC-19, DEC-20

## D125 2026-11-07 P7.3 and P7.4: the decision record and the save method in force

The WS-033 plan (approved 2026-10-31, rows O01 and L01; P7.3 and P7.4 in the sequence approved 2026-11-07 as A0) moves
the archive, the old log and the map to docs/history and makes lib/Save-State.ps1 the one save method. The transitional
wording expired with this contract; R-INBOX names the inbox without a path (D-04, 2026-11-05).

Replaced wording of DEC-01, verbatim:

> ## DEC-01 Decision records: one source of truth
>
> This file is the only home of every decision and rule in force: one entry per subject, `## DEC-NN <subject>`. IDs are
> permanent and never reused. A new owner decision rewrites each entry it changes into one updated decision,
> consolidated and rephrased, never layered on the old wording, or adds an entry for a new subject. No entry sends the
> reader to another entry to combine with it. In the same operation the replaced wording and the owner's words verbatim
> go to the archive, each item with its date and `Now in: DEC-NN`. Until P7.4 this draft is rewritten directly and the
> archive is the old log (new items continue its numbering from D102); from P7.4, docs/DECISIONS.md changes through a
> contract, owner words wait in data/decisions-inbox.md and the NOW.md "Pending decisions" list, and the archive is
> docs/history/DECISIONS-ARCHIVE.md beside the byte-exact old log and its D-number map. Every other file cites the
> DEC-NN and never restates it; a value that code must carry sits next to its DEC-NN, and its owning test compares it
> with this file; Claude memory holds pointers only. A value that was copied and drifted before gets a Watch pattern.
> Entry format and checks: WORKSPACE-LAYOUT.md (until P7.4: ARCHITECTURE.md) sections 10 and 11.
>
> Scope: every decision, rule and owner preference of the Workbench workspace, for every agent.
> Why: the same decision was stored in several places and layered across entries, and copies drifted.
> Changed: 2026-10-31
> History: D35, D83, D87, D88, D100, D101, D102

Replaced wording of DEC-26, verbatim:

> ## DEC-26 Save and compact
>
> After every completed phase, operation or passed gate: keep raw outputs, exits and subject hashes, update the one
> live state file, run the save method and verify the copies before going on. For every compact the owner gets the
> /compact line and the resume message, and types /compact by hand. One save method for every agent: until WS-033 step
> P7.3, lines 1-3 of ORVION-Workbench/work/RESUME-HERE.md plus records/WS-028/package/Save-Checkpoint.ps1; after it,
> lib/Save-State.ps1 with data/work/NOW.md. Live state lives in that one file only; other files hold evidence, and
> memory only points to it. A save never freezes or certifies an active output.
>
> Scope: every agent, after every step.
> Why: work resumes exactly where it stopped, after a compact or a lost machine.
> Changed: 2026-10-31
> History: D20, D62, D71, D87

Now in: DEC-01, DEC-26

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

## D127 2026-11-08 WS-038: Finish floors, keep-awake and the DECISIONS.md budget

The owner's words of 2026-11-07, verbatim from data/decisions-inbox.md (~19:40, ~20:06 and ~20:40 Cairo):

> remove any minimam limit set to the RAM memory in the repo's

> i see alote of recommendation and that's good i like it, you can decide how & when

> i approve all include Exclude the disposable test folders from Microsoft Defender's live scanning but i don't know
> how to do it - if you can do by yourself simply or toch me to do it manully, what's else can improve and enhance and fix
> before BT6

The first removed every RAM minimum; WS-038 removes the lifecycle manifest floors and their check. The second gave
Claude main the WS-038 scope. The third approved item A, the machine held awake during a Finish. Under that delegation
WS-038 also raises the DECISIONS.md budget from 40 KB to 48 KB (6 B were left). The evaluator's own floors stay until
WS-034 (DEC-07), and the two inbox items stay until every part of them is folded.

Replaced wording of DEC-24, verbatim:

> ## DEC-24 Concurrency and host resources
>
> Two jobs run at once where it is safe: light work, or two Codex reviews. Codex never runs beside a heavy job (a
> Finish, a full suite, a package build, a restore). Heavy runs are watched by one Watch-Host; COMMIT LOW means
> applying the owning run's recovery policy, never killing unrelated work. A Finish launch keeps the native minimum of
> 3 GB free commit (enforced by Assert-WorkbenchContextRuntime -ResourceCheck) and the launch scripts' 5 GB physical
> buffer; no task script adds a larger free-commit buffer.
>
> Scope: every heavy run and every parallel job.
> Why: the host has limited memory; a starved Finish fails for reasons unrelated to the candidate.
> Changed: 2026-10-31
> History: D21, D25, D30, D86

Now in: DEC-24

## D128 2026-11-09 WS-034: purpose-based local suite, the Batch 6 release class and rule 12

The owner's words of 2026-11-08, verbatim from data/decisions-inbox.md (~10:20, ~10:35 and ~21:10 Cairo):

> I grant you the authorization in accordance with the rules and principles of the constitution: an option is to
> authorize an entire class instead.

> Any failure or mistake you make can serve as a learning opportunity, helping you ensure that it does not happen again
> and that you never fall into the same error.

> Make sure the constitution rules have some rule like 'don't skip but try to fix' and enhance this rule

The first authorized the Batch 6 release class with the conditions Claude main wrote down before acting; DEC-25 now
states them. The second and third merge into DEC-33 rule 12, so the rules stay twelve. WS-034 lands DEC-07 (the
always-on and owning tests, fail closed, CI full) and the TEMP bound, and sets the evaluator's CI floors to 0.001
under the owner's 2026-11-07 removal of every RAM minimum (D127).

Replaced wording of DEC-07, verbatim:

> ## DEC-07 WS-034 purpose-based local suite
>
> WS-034 changes the accepted evaluator once, through the full method: the local Finish runs the always-on checks plus
> the tests that own the changed files; the full suite still runs on GitHub before main moves; the Execution Context
> also bounds TEMP (at most 97 characters, with a Tests Root of at most 101; the evaluator does not check this today).
> Its release sets the new evaluator pin. Accepted cost: a break in another area shows first on GitHub.
>
> Scope: WS-034, deferred until after the Owner Lift.
> Why: about 20 minutes saved per workstream, while GitHub keeps the full suite.
> Changed: 2026-11-07
> History: D95, D96, D123

Now in: DEC-07

Replaced sentence of DEC-25, verbatim (the rest of the entry stands):

> CRM and ORVION: the owner wrapper's interactive confirmation is never emulated; running their native publish and
> promote engines directly needs a one-time owner authorization naming the exact SPECs, with every gate kept.

Now in: DEC-25

Replaced rule 12 of DEC-33, verbatim:

> 12. Nothing open is lost: a found error, gap or question is fixed now or recorded with its owner and trigger; finish before expanding.

Now in: DEC-33

## D129 2026-11-11 WS-040: the constitution amended from Batch 6; DEC-03 retired into DEC-33

The owner's words of 2026-11-11, verbatim from data/decisions-inbox.md (~17:10, ~17:25, ~22:10 and ~22:35 Cairo, and
decision 7 of ~19:50):

> Do not adopt, create, modify, or delete any file, mechanism, or tool, except in accordance with the rules and principles of the constitution. Furthermore, continuously improve the constitutional rules whenever loopholes or gaps—not currently covered by the existing rules—are discovered.

> Learn from your experiences in previous cycles and the insights you've gained regarding potential improvements.
> Refine the "constitution," the cycles, and their schedules—as well as anything else you believe warrants adjustment—in line with the new constitutional rules.
> The goal is to implement minor, cost-effective enhancements, rather than requiring dedicated cycles or specific "Business Requests" (BRs) for these changes.
> Let's move forward with the "slices" by introducing clear improvements—whether in terms of time, cost, or the rules themselves.

> I believe returning to the "Workbench contract" has become necessary.
>
> For now, please compile everything that needs to be finalized, added, modified, improved, or removed before we proceed with the completion of BT6. This must be done in accordance with the principles of our "constitution." I recall you mentioning that some of these principles—or rules—themselves require improvement; the only obstacle was that doing so would necessitate a new contract—well, here we are.

> Do not ask me; let the Constitution provide the answer. I will only agree to your proposals if they are in accordance with the rules of the Constitution.

> The existing 8 Waste and Safety Rules in PLAN.md remain the single operational rule set.

Lessons of Batch 6 slices 1-7 and WS-034 (decisions inbox ~17:25, revised ~22:30) amend DEC-33 rules 2, 3, 6, 7, 8, 9
and 12; rules 1 and 3 also take the parts of DEC-03 no rule held (the product governance and the weighing of sources;
boring rather than clever; never raising a budget), so DEC-03 retires with nothing dropped (rule 3) and its D-numbers
map to DEC-33. Rule 6's list moves to DEC-30, which gains ACI. DEC-01 writes down decision 7 (batch-scoped rules);
DEC-28 moves a repeat's guard to its source. Dropped by the constitution: a Routine inbox-fold contract at each batch
close (no dedicated cycles), the rule 10 and 11 additions (covered) and the Codex fallback (in force, D124).

Replaced entry DEC-03, verbatim:

> ## DEC-03 Engineering principles
>
> Every file, folder, section, tool and step passes four tests. Learn first: look before adding, reuse what exists and
> rest on evidence; before proposing, learn from the CRM and ORVION governance, current standards and research, each
> source weighed by its strength. Learn before making assumptions: verify every fact a step depends on (read the file, run
> the check, read the current official source) before acting; keep proven fact, inference and hypothesis apart; never
> guess; ask the owner what only the owner knows. Earn it and worth it: a file exists only while something actively reads
> it (a tool, gate, decision, agent step or owner need); nothing is kept only as history; the Workbench's tools must
> really work. Simplify without weakness: the shortest form that keeps every gate, test, rule, needed piece of evidence
> and security boundary, boring rather than clever; small, closely related files are merged; a size budget is met by
> moving text to its one home, never by dropping a rule or raising the budget. Prefer the minimal, demonstrably safe
> solution, never one whose safety needs disproportionate complexity or fragile workarounds; where safety cannot be shown,
> fail closed and keep the evidence. Never leave a found error or gap unfixed: fix it now when its rules allow, otherwise
> schedule it with a named trigger. How each test is applied: WORKSPACE-LAYOUT.md section 1.
>
> Scope: every agent and every piece of work.
> Why: the owner's principles, restated in most decisions since 2026-10-26; the fourth test was added on 2026-11-01.
> Changed: 2026-11-01
> History: D19, D21, D37, D48, D65, D88, D95, D103, D106

Now in: DEC-33

Replaced sentence of DEC-01, verbatim (the rest of the entry stands):

> words wait in decisions-inbox.md and the NOW.md "Pending decisions" list; the archive is

Now in: DEC-01

Replaced sentence of DEC-28, verbatim:

> A fixed defect class lands the guard that keeps it closed, or its record says why none.

Now in: DEC-28

Replaced sentence of DEC-30, verbatim:

> CAG, SACI, PICF and CRGL mean only what their owning repository texts define, never what memory recalls.

Now in: DEC-30

Replaced rules of DEC-33, verbatim:

> 1. Learn first: read the code, contracts, past failures and current official sources before acting; never guess.
> 2. Earn it and worth it: measured need, value above cost; reuse first; automate wisely; real outcomes, no reports of reports.
> 3. Simplify without weakening: the smallest tested change that keeps every gate, test, rule and boundary.
> 6. Enforce, not instruct: a critical limit lives in a gate or tool; CAG, ACI, SACI, PICF are what their repositories define.
> 7. Before the irreversible: prove completion is feasible, verify the target, hold recovery or explicit authorization.
> 8. Bounded, fail closed: limits on attempts and resources; no retry without new evidence; unknown stops and escalates.
> 9. Test before trust: real conditions, not proxies; a high-risk change also gets a check its author did not write.
> 12. Fix, never skip: fix each error, gap or failed check at its root now; defer only out-of-scope, unsafe or owner fixes (owner, trigger); lesson each mistake, guard a repeat; finish before expanding.

Now in: DEC-33
