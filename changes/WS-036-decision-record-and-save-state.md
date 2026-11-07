# Workbench Change Request - WS-036

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Land WS-033 steps P7.3 and P7.4 as one contract: the decision archive, the byte-exact old log D1-D122 and the D-number map move into docs/history; lib/Save-State.ps1 becomes the one save method in the decision text and the runbook; the path fixes of Part A (R-INBOX, R-DOC1, R-DOC2) and the one fold-moved line in lib/Organize.ps1; Save-State fix F1 (a leftover continuity.old is restored, never deleted) with its owning test case and mutant; and the decision amendments G1-G4 and D-11 with archive items D123-D125. Benefit: the decision record is complete in the Workbench (DEC-01), the transitional "until P7.3/P7.4" wording expires, and the save method in force is written once.

Tier: Significant under DEC-12. It changes the decision text, a tested tool and its test, and publishes the old log once released. Authority: DEC-01, DEC-02, DEC-04, DEC-07, DEC-08, DEC-09, DEC-12, DEC-13, DEC-14, DEC-19, DEC-22, DEC-23, DEC-25, DEC-26 and DEC-28; the owner's direction of 2026-11-06 and A0 (2026-11-07); A2 (content) and A3 (exact text) DELEGATED on 2026-11-07 under the owner's written delegation (data/records/WS-033/DELEGATED-DECISIONS-20261107.md). Native checks prevail; no evaluator or applier change is included.

Number: WS-034 is reserved by DEC-04 and DEC-07 and deferred until after the Owner Lift, and WS-035 is Complete, so this takes WS-036. Intended contract: changes/WS-036-decision-record-and-save-state.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: lib/Invoke-ContractLifecycle.ps1 at this baseline, from one WS-036 manifest in the Runtime Root's parent. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

a8450180469ff3b53509c7d3c7bb93789262a065

## Write Scope

- docs/DECISIONS.md
- docs/history/DECISIONS-ARCHIVE.md
- docs/history/DECISIONS-LOG.md
- docs/history/DECISIONS-MAP.tsv
- docs/history/README.md
- docs/RECOVERY.md
- docs/RUNBOOK.md
- docs/WORKSPACE-LAYOUT.md
- lib/Organize.ps1
- lib/Save-State.ps1
- lib/test-save-state.ps1
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Invoke-DraftSteps.ps1 and lib/hooks/Guard-Write.ps1 keep baseline bytes; changes/README.md is not refreshed; docs/history/LOG.tsv is not written; no weakened test or assertion (DEC-22); Save-State fixes F2-F4 (deferred, A2); the paired-CR derivation (the products' own governance); any run of Save-State on the real data root, the continuity file and the legacy resume file (P8.3); Organize amendments (P7.5); memory files (P7.7); no CRM, ORVION, credentials, real sessions or events (DEC-08, DEC-09); no change to ORVION-Owner-Tools, which keeps the old log's original; any push or release (DEC-25).

## Draft Assurance

V1: WS036-V1-CLAUDE-FALLBACK-DESIGN-20261107-01 | 2026-11-07 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-036\assurance\V1\DRAFT.md | EBD4D0EDF8FEE94A997D220BC9CBE1A6BB94439EAA1EA78DC73F6BA17A1DA9DE
V2: WS036-V2-CLAUDE-FALLBACK-ADVERSARIAL-20261107-01 | 2026-11-07 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-036\assurance\V2\DRAFT.md | 9B3BCAF6AF8E1CC8A8E91A67F228D780D1C4EDDE6597FC520CC2463BEBC80DBF
V3: WS036-V3-CLAUDE-REFRESH-20261107-01 | 2026-11-07 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-036\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V3 EVIDENCE REFRESH by Claude main under DEC-13, binding the frozen V1 and V2 digests above; each was frozen and hashed before the next began (assurance\V1\FROZEN.json, assurance\V2\FROZEN.json). Author of V1 and V2: Claude main, claude-opus-5-5, under the automatic fallback of DEC-19 and the owner's D120, because the one Codex dispatch of 2026-11-07 was refused before any Codex work (ORVION_CACHE_CLI_MISMATCH, records/WS-036/codex/V1-run). V2 is a same-session V2 by the author of V1. All three are one author's work: nothing here is independent, and no Codex work is claimed. Sources and selection table: assurance\V3\STANDARDS-CHECK.md and assurance\V3\REPORT.md.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W36\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W36\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W36\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W36\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order; where a step has more than 26 edits its letters cycle after z. Every payload is inline, so replay needs no source file. docs/history/DECISIONS-LOG.md is the old log carried byte-exact (SHA256 BFCE37BF30C2E09BFB8E5D9C459A7B0CE08AE1E238CB0FC12A107DF4CC3DE955); the contents table of docs/history/README.md is the one lib/Organize.ps1 -Refresh wrote for these files.

1. Check whether `docs/DECISIONS.md` contains `Archive: docs/history/DECISIONS-ARCHIVE.md (from D123), DECISIONS-LOG.md (D1-D122), DECISIONS-MAP.tsv.`; if so record Already Applied when its Git blob is 93bf9b907ac80ca284ab5d995400c391dd5cca2e, and otherwise stop and report. Otherwise make exactly these 22 edits (land this exact frozen WS-036 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   Archive: Owner-Tools/records/delegation-20261026/DECISIONS.md (new items from D102); decisions-map.tsv maps each D-number.
   ```
   with
   ```text
   Archive: docs/history/DECISIONS-ARCHIVE.md (from D123), DECISIONS-LOG.md (D1-D122), DECISIONS-MAP.tsv.
   ```

   b) replace the lines
   ```text
   go to the archive, each item with its date and `Now in: DEC-NN`. Until P7.4 this draft is rewritten directly and the
   archive is the old log (new items continue its numbering from D102); from P7.4, docs/DECISIONS.md changes through a
   contract, owner words wait in data/decisions-inbox.md and the NOW.md "Pending decisions" list, and the archive is
   ```
   with
   ```text
   go to the archive, each item with its date and `Now in: DEC-NN`. This file changes only through a contract; owner
   words wait in decisions-inbox.md and the NOW.md "Pending decisions" list; the archive is
   ```

   c) replace the line
   ```text
   Entry format and checks: WORKSPACE-LAYOUT.md (until P7.4: ARCHITECTURE.md) sections 10 and 11.
   ```
   with
   ```text
   Entry format and checks: WORKSPACE-LAYOUT.md sections 10 and 11.
   ```

   d) replace the lines
   ```text
   Changed: 2026-10-31
   History: D35, D83, D87, D88, D100, D101, D102
   ```
   with
   ```text
   Changed: 2026-11-07
   History: D35, D83, D87, D88, D100, D101, D102, D125
   ```

   e) replace the lines
   ```text
   WS-033, then WS-034, then the Owner Lift through its existing process, then STOP at the Batch 6 threshold. No agent
   starts Batch 6; it waits for the owner's lift record. The Final Stop Packet baseline exists; WS-033 adds a supplement.
   ```
   with
   ```text
   WS-033, then the Owner Lift through its existing process, then STOP at the Batch 6 threshold; WS-034 waits in the
   maintenance backlog. No agent starts Batch 6; it waits for the owner's lift record. The Final Stop Packet baseline exists; WS-033 adds a supplement.
   ```

   f) replace the lines
   ```text
   Changed: 2026-11-01
   History: D27, D67, D68, D79, D83, D96, D106
   ```
   with
   ```text
   Changed: 2026-11-07
   History: D27, D67, D68, D79, D83, D96, D106, D123
   ```

   g) replace the line
   ```text
   Scope: WS-034.
   ```
   with
   ```text
   Scope: WS-034, deferred until after the Owner Lift.
   ```

   h) replace the lines
   ```text
   Changed: 2026-10-31
   History: D95, D96
   ```
   with
   ```text
   Changed: 2026-11-07
   History: D95, D96, D123
   ```

   i) replace the line
   ```text
   overwritten, relabelled or turned into a pass. When the workstream completes, records/WS-0NN/README.md keeps its result,
   ```
   with
   ```text
   overwritten, relabelled or turned into a pass. When the workstream completes, `records/WS-<NN>/README.md` keeps its result,
   ```

   j) replace the line
   ```text
   holds for every Workbench slice and contract, and for every CRM and ORVION SPEC within that repository's own lifecycle.
   ```
   with
   ```text
   holds for every Workbench slice and contract; a CRM or ORVION SPEC follows only its own lifecycle and native Draft
   Assurance, with no Workbench Draft or sandbox stage added.
   ```

   k) replace the lines
   ```text
   Changed: 2026-10-31
   History: D31, D33, D34, D38, D87, D100, D102
   ```
   with
   ```text
   Changed: 2026-11-07
   History: D31, D33, D34, D38, D87, D100, D102, D123
   ```

   l) replace the line
   ```text
   called independent, and by Codex in the V1 and V2 session.
   ```
   with
   ```text
   called independent, and by Codex in the V1 and V2 session. At its usage limit, Codex's review is recorded SKIPPED,
   never replaced or claimed, and Claude main's is the only one.
   ```

   m) replace the lines
   ```text
   Changed: 2026-10-31
   History: D24, D31, D38, D73, D74, D75, D77, D80, D82, D84, D85, D87, D100, D102
   ```
   with
   ```text
   Changed: 2026-11-07
   History: D24, D31, D38, D73, D74, D75, D77, D80, D82, D84, D85, D87, D100, D102, D120, D124
   ```

   n) replace the line
   ```text
   blocks: when it is unavailable or at its usage limit, Claude main does the step at once, labelled as Claude work; the
   ```
   with
   ```text
   blocks: when it is unavailable or at its usage limit, Claude main does the step at once (a Draft step; a review follows DEC-14),
   labelled as Claude work; the
   ```

   o) replace the lines
   ```text
   Changed: 2026-11-01
   History: D20, D24, D27, D47, D55, D72, D73, D76, D77, D83, D100, D106
   ```
   with
   ```text
   Changed: 2026-11-07
   History: D20, D24, D27, D47, D55, D72, D73, D76, D77, D83, D100, D106, D120, D124
   ```

   p) replace the lines
   ```text
   .codex stay read-only inside them. Those settings exclude Codex's temporary folders, yet inside MXC the default TEMP named the
   container's own AC\Temp and it took a write (WS-033 P2.2, file gone): that folder is outside both roots and the tripwire does not watch
   it, so no confinement is claimed for it, and a delegate sets TEMP and TMP to the run folder first. When MXC is unavailable the run is
   ```
   with
   ```text
   .codex stay read-only inside them. Inside MXC the default TEMP is the container's own AC\Temp,
   outside both roots and unwatched by the tripwire (it took a write in WS-033 P2.2), so no confinement is claimed for it and a
   delegate sets TEMP and TMP to the run folder first. When MXC is unavailable the run is
   ```

   q) replace the lines
   ```text
   Changed: 2026-11-04
   History: D7, D8, D9, D28, D33, D36, D37, D105, D106
   ```
   with
   ```text
   Changed: 2026-11-07
   History: D7, D8, D9, D28, D33, D36, D37, D105, D106, D124
   ```

   r) replace the line
   ```text
   One Finish per stage. A Finish that ran tests is never rerun to get a pass, a passed check is not rerun, and a Finish
   ```
   with
   ```text
   One Workbench Finish per stage. A Finish that ran tests is never rerun to get a pass, a passed check is not rerun, and a Finish
   ```

   s) replace the line
   ```text
   Scope: every native Finish.
   ```
   with
   ```text
   Scope: attempts and reruns, Workbench Finishes only; the host rule, every native Finish.
   ```

   t) replace the lines
   ```text
   Changed: 2026-10-31
   History: D14, D22, D25, D71, D77
   ```
   with
   ```text
   Changed: 2026-11-07
   History: D14, D22, D25, D71, D77, D123
   ```

   u) replace the lines
   ```text
   /compact line and the resume message, and types /compact by hand. One save method for every agent: until WS-033 step
   P7.3, lines 1-3 of ORVION-Workbench/work/RESUME-HERE.md plus records/WS-028/package/Save-Checkpoint.ps1; after it,
   ```
   with
   ```text
   /compact line and the resume message, and types /compact by hand. One save method for every agent:
   ```

   v) replace the lines
   ```text
   Changed: 2026-10-31
   History: D20, D62, D71, D87
   ```
   with
   ```text
   Changed: 2026-11-07
   History: D20, D62, D71, D87, D125
   ```

   The resulting file's Git blob is 93bf9b907ac80ca284ab5d995400c391dd5cca2e.

2. Check whether `docs/history/DECISIONS-ARCHIVE.md` contains `# Decisions archive`; if so record Already Applied when its Git blob is 6593a98b8f7fa2a467e25c634d7d99c90b16f9aa, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-036 candidate output), and change nothing else:

   ```text
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
   ```

   The resulting file's Git blob is 6593a98b8f7fa2a467e25c634d7d99c90b16f9aa.

3. Check whether `docs/history/DECISIONS-LOG.md` contains `# Decisions taken under OWNER-DELEGATION.md (append-only)`; if so record Already Applied when its Git blob is 39a0d07b93a17b903e1d126767894b3b35699008, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-036 candidate output), and change nothing else:

   ```text
   # Decisions taken under OWNER-DELEGATION.md (append-only)

   Source authority: OWNER-DELEGATION.md SHA-256 94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217.
   Later owner messages in the same session, recorded verbatim: OWNER-DIRECTIVE-REINSTALL.md, OWNER-REQUEST-DELEGATE-SKILLS.md.
   Every Gate 1 below is a DELEGATED exact Gate 1: the owner did not type that digest. It is recorded the way the native
   Founder precedent SPEC-297 recorded its delegated Gate 1 (native-brief-unreadable-20261023\authority\fd-gate1.json).
   Local integrity binds this evidence; it does not authenticate the owner.

   ## D1 2026-10-26 Contract shape
   Two contracts, one per native authority: WS-015 (Workbench: selective encrypted package, C1 restore tool, HANDOFF §12 /
   EXECUTION-PLAN / RESUME amendments, docs/RECOVERY.md) and one Founder CR (ADR-0034 superseding the ADR-0033 programme
   sequence tail, pinned `Next capability` line with its GOVERNANCE §6 pin). Platinum needs no change: its Boot already
   routes to Batch 6 and it never encoded the programme hold.

   ## D2 2026-10-26 Shared Evidence
   Disposition: WAIVED as a closure prerequisite, NOT earned. Delegation item 10 permits deferred or waived; HANDOFF §12
   offered "earned or waived". No assurance is claimed from it.

   ## D3 2026-10-26 CTRL-19
   Disposition: OPEN, residual risk accepted (both gh tokens reachable by this OS user; main protection depends on GitHub
   settings). Not closed (delegation item 9, §4).

   ## D4 2026-10-26 Contract C split and the Batch 6 lift point
   C1 = written closure criteria (HANDOFF §12 as amended) + one real encrypted package + same-machine isolated restore with
   Boots. C2 = clean-Windows recovery. The reinstall directive states the owner reinstalls Windows before Batch 6, so the
   reinstall itself is C2, run by docs/RECOVERY.md. The lift decision therefore waits for the post-reinstall restore; it is
   not taken under this delegation before then. This is the lawful resolution of the Batch 6 continuation decision.

   ## D5 2026-10-26 Key custody (superseded by D10)
   The package key is generated in-process, DPAPI-protected for this Windows user, never printed, logged or passed as an
   argument. A reinstall destroys it, so owner custody (docs/RECOVERY.md step 2) is a hard precondition of the reinstall.
   The agent cannot perform it without exposing the key, so it remains the owner's action: preserved blocker, no bypass.

   ## D6 2026-10-26 Not packaged
   GitHub\Marketing-MCP (not a Git repository; contains credentials) and non-ORVION transcripts under .codex/.claude are
   outside Workbench scope and are not packaged; docs/RECOVERY.md names them for the owner. No unrelated file is moved or
   deleted.

   ## D7 2026-10-26 Delegate skills
   Evaluated in parallel only; it must not delay recovery or Batch 6 (owner request). No installation before source review.

   ## D8 2026-10-26 Delegate skills: evaluated, NOT adopted yet
   Source reviewed at pinned commit 3aa72d681a79e2a9d09bd9a316353003ae1cb4a7 (codex-delegate 0.5.0, MIT; files and hashes in
   delegate-review\). relay.mjs uses only Node built-ins, no network of its own, writes under %TEMP%\delegate-relay, never
   commits. Two isolated trials on a throwaway repository with a known defect (the real $key shadowing bug), with
   --ignore-user-config (mandatory here: the user Codex config loads production MCP servers incl. supabase-primary
   execute_sql and GitHub tokens): read-only 28 s and workspace-write 20 s (~250 MB new processes), 0 files touched, but
   every Codex shell command was "blocked by policy", so the diagnosis was empty (confidence low). Cause: Codex's Windows
   sandbox is not operational on this machine; the owner's own Codex config runs sandbox_mode=danger-full-access with
   approval_policy=never. The only working delegation mode would therefore run with full user rights (tokens, production
   MCP), which the owner's conditions forbid. Not installed. Re-evaluate after the reinstall if Codex's Windows sandbox
   works there (or via WSL), with the same throwaway known-defect trial. Security note for the owner: the current Codex
   configuration itself runs unsandboxed with production MCP access (relevant to CTRL-19).

   ## D9 2026-10-26 Delegate: owner chose unrestricted mode; adopted under usage rules
   Owner message: "connect to codex unrestricted mode". Trial 3 (danger-full-access, --ignore-user-config, throwaway repo,
   brief forbids commit/network/gh): correct root cause, exact lines, mechanism and fix of the known $key defect in 19 s,
   ~240 MB new processes; 0 files touched, HEAD unchanged. Kept as a pinned copy plus ORVION-USAGE.md (in the recovery
   package via Owner-Review). Deliberately NOT installed as a global Claude skill: its stock instructions do not carry the
   --ignore-user-config / disposable-clone rules, so a future agent could run it unrestricted with production MCP in an
   original root. Residual risk accepted by the owner: Codex runs with this user's rights; protection is the brief plus the
   orchestrator's post-run check.

   ## D10 2026-10-26 Owner revised recovery: no encryption
   OWNER-DIRECTIVE-UNENCRYPTED-CONTINUITY.md supersedes D5 key custody and the encrypted package design: compressed, unencrypted archive synced to OneDrive, sensitive content identified without values and handled by exception; HANDOFF §12 amendment must state the owner decision instead of claiming an encrypted backup. Learning-first and repository-as-memory directives added. Plan and state: CHECKPOINT.md.

   ## D11 2026-10-26 Owner confirmation
   Owner: "don't encrypted The recovery package - just uploud it when the step come". The package is a plain compressed archive uploaded to OneDrive at its step; no key is created. The redacted secret scan stays as identification only (paths and rule names, never values), reported to the owner, per the earlier directive; it does not add encryption.

   ## D12 2026-10-26 Owner away; proceed to the verified stopping point
   Owner message (verbatim): "now what's next - i will go - i give you all approve you can need until you finish". Read as
   permission to continue the already-delegated plan unattended to its verified stopping point (CHECKPOINT.md steps 1-5),
   inside every limit of OWNER-DELEGATION.md. It grants no new scope: no reinstall, no deletion of evidence, no C2 claim,
   no CTRL-19 closure, no Batch 6 start. Any failed condition stops the affected irreversible action.

   ## D13 2026-10-26 Secret-scan findings in the unencrypted package
   Real-data scan (gitleaks 8.30.1 --redact, final selected bytes DA92198E): 4557 findings, values never recorded
   (ws015-package\real-secret-scan.txt, paths only). 4505 generic-api-key pattern hits, 4175 of all hits in verbatim
   session transcripts (mostly hashes/identifiers); 10 GitHub token shapes (app/oauth/refresh) all in Codex session
   transcripts; 21 jwt (local Supabase stack start logs and sessions, consistent with its published defaults); 21
   sourcegraph-shaped. Per D10/D11 the package stays unencrypted and the sessions stay verbatim (redacting them would break
   the archive's integrity). Compensating control: docs/RECOVERY.md makes revoking the GitHub CLI OAuth authorization
   for both accounts a step after reinstall, which kills every old gh token. Owner informed in the final report.
   Codex also found that the scan cannot see history inside bundles (documented).

   ## D14 2026-10-26 Original Finish attempt 1 refused by the suite; one re-run after the cause was removed
   The first original Finish (head 64142c3) stopped after 0.1 min, before any test: tests.ps1 WB_SUITE_UNDECLARED_HAZARD_INPUT,
   because the agent's continuity mirror (.continuity\, with .ps1 files) sat inside the checkout outside work\. The guard
   was right (README: never put work inside a repository tree). The mirror moved to work\continuity\ (git-ignored,
   excluded from the hazard schedule; still inside ORVION-Workbench as the owner asked); disk and tree hazard sets were
   proved equal. Attempt 1 evidence kept unchanged in runtime\original\attempt1-failed-undeclared-hazard\. No receipt was
   issued by it. One fresh Finish follows; nothing in the contract, Draft or code changed.

   ## D15 2026-10-26 Founder SPEC-298 release stops at the owner's interactive confirmation
   SPEC-298 is Complete and natively bound on the original (0529a0d, PREPARE: READY; Boot NEXT_CAPABILITY routes to Batch 6
   after the owner's lift). scripts/owner_publish.ps1 run from ORVION-trusted-main refused non-interactively:
   INTERACTIVE_CONFIRMATION_REQUIRED, no release operation attempted (fd-spec298\release\publish\). That interlock exists
   for the owner in a real console; emulating a console to type the confirmation would bypass a protection, which the
   delegation forbids. Publication and promotion of SPEC-298 are therefore left to the owner (two commands, CHECKPOINT.md);
   the local candidate, its receipt and its exact-SHA certification record travel in the recovery package. Revisions
   1-3 of the Draft were refused natively in the sandbox (Consumer Closure rows, Last Completed text) and are preserved.

   ## D16 2026-10-26 Owner authorizes bypassing the interactive interlock for SPEC-298, after a Codex review
   Owner message (verbatim, Arabic): "بل يمكنك تجاوز ذلك مؤقتا - انشر spec-298 وايضا قم بترقيتها ولكن اولا اعرض على كودكس
   ال spec ليبدى لك فيها رأيه ايضا ماذا تنتظر منى لاوافقك عليه او لافعله بنفسي". Meaning: temporarily bypass the
   interactive confirmation; publish and promote SPEC-298, but first have Codex review the spec. Applied narrowly: the
   owner wrapper's console prompt is not emulated; instead the native engines it calls are run directly
   (scripts/publish_candidate.ps1 from the candidate root, scripts/promote_main.ps1 from ORVION-trusted-main), so every
   native gate, lease, required check and ruleset still applies. One time, this candidate only; no force, no setting change.

   ## D17 2026-10-26 Interactive repository map as WS-016
   OWNER-DIRECTIVE-INTERACTIVE-MAP.md (verbatim). One Workbench contract WS-016: lib\Map-Repos.ps1 plus its owning test, generated ai-map.json and ai-map.html in the Workbench root, git-ignored (they change on every refresh and would dirty main, which blocks Finish and the recovery package). Inputs: only tracked files of every Git repository found under Documents\GitHub (discovered each run), never sessions, journal or evidence. Links: markdown links, backticked repository paths, contract/ADR ids; backlinks and an orphan list. Refresh: at each run of the tool and by a per-user scheduled task (owner request for periodic refresh). All three repositories are public (gh, 2026-10-26).

   ## D18 2026-10-26 WS-016 delegated Gate 1 and two reports
   WS-016 r1 (V3 21A66F4C...) was refused at sandbox Approval because its Write Scope omitted RESUME.md (WB_WRITE_SCOPE_REFUSED);
   preserved in ws016-package\r1-refused. r2 (V3 BD6439F9BBB3C88E264C2782D93E5F910D5A958D10ABA4002889A726D7A5E84F) passed the
   full sandbox lifecycle (Finish 15.2 min, review READY, Complete, range READY). Delegated Gate 1:
   GATE1-WS016-DELEGATED.md. Owner request (Arabic, 2026-10-26): after finishing, two English reports, (1) a detailed
   session report with suggestions, notes, concerns and weaknesses, (2) system features, how to start, and the big/small/
   main/sub work cycles; Codex may help. Codex advisory input: codex-reports\codex-report.txt (disposable clone C:\cxr).
   Verified finding from it: Finish's mandatory lesson lookup (lib/Workbench.ps1:231) passes the checkout as -Root, so it
   reads <checkout>\events\events.jsonl, which does not exist; the real journal is in ORVION-Owner-Tools. A follow-up
   contract, not part of WS-016.

   ## D19 2026-10-26 Tools must really work: WS-017 trustworthy agent answers
   Owner (Arabic, 2026-10-26): make sure the tools really work at full efficiency and that an agent can rely on and benefit
   from them, so the owner does not regret building Workbench; make it earn its value; consult Codex to expose gaps, defects
   and likely errors, and choose which deserve fixing. Measured: Events -Find and Spider default to the Workbench checkout and
   answer "nothing found" with exit 0; with -Root ORVION-Owner-Tools they work (1.7 s, 7 s). The session hooks run the older
   ORVION-Owner-Tools copy of lib (frozen at WS-004). Codex tool audit (codex-reports\tools-report.txt) found 20 issues; chosen
   for WS-017: data-root default (one identical expression), Events/Spider/Pulse honest unavailable/incomplete states, Finish
   lesson lookup, run_timed fail-closed directory/log, tests.ps1 data isolation. Deferred by name in WS-017 Out of Scope.
   Product git configs hold gh credential helpers (no stored token; key names only). Delegated Gate 1 to follow the sandbox.

   ## D20 2026-10-26 WS-018 trustworthy preservation (reinstall critical path); owner working rules
   WS-017 released: main = preflight = 6b5549d, hosted run 40318665925 success, Codex review 1 FIX FIRST fully fixed.
   Chosen next under D19/D12, because the reinstall depends on them: Codex tools-report findings #3 (Sync-Sessions prefix
   proof sampled 4 KB ends), #4 (archiver failure exited 0), #6 (Restore accepted partial/empty SHA256SUMS), #7 (Backup kept
   product git config verbatim). One contract, three drafts. Implemented by Codex in disposable C:\cx18\repo, reviewed by the
   orchestrator; real-shape checks (key names/regex results only) caught two refusals Codex fixtures missed: the real gh
   shell-function helper and CRM's username userinfo; and a test that read global git config. Owner instructions (Arabic,
   2026-10-26): bundle similar goals into one contract with the 3-draft governance; Codex works under supervision and must
   prove or disprove with evidence before results are accepted; ask Codex for suggestions; aim for a Workbench fit to resume
   Batch 6 soon; push and sync to the cloud continuously.

   ## D21 2026-10-26 WS-019 one data root everywhere; owner "fix anything, leave no bug", run two at once
   WS-018 Original Complete 4cdf1d5 (published to workbench-preflight; hosted check pending at writing). Owner request
   (2026-10-26): run two jobs at once where possible, fix every bug seen, leave none. Chosen under D19/D20/D12, one
   bundled contract: Sync-Sessions, the session hook (Watch-Reminder), Hunt (source root split from data root) and Backup
   take the identical WS-017 data-root default, so repointing the owner's Claude hooks to this checkout cannot split the
   archive; the hook error log keeps a fallback when the root itself fails; the stale entry-document statements found by
   the fresh-agent orientation test (event entry-docs-stale-statements) are corrected. Codex implemented in disposable
   C:\cx19\repo (proto1, fix2, fix3), every claim proved; orchestrator read every diff and spot-checked the real root
   (resolves to ORVION-Owner-Tools with sessions\raw) and the real hook settings shape (commands only). After release:
   back up settings.json, repoint the five hook entries (merging one exact duplicate).

   ## D22 2026-10-26 WS-019 original Finish attempt 2 (attempt 1 blocked at preflight, zero tests run)
   Attempt 1 (19:29 Cairo) ended at 0.3 min with WORKBENCH: BLOCKED, CODE: WB_REQUIRED_HUNT_FAILED, before any test ran.
   Cause: WS-019 working as designed. Hunt now reads the real data store, and found one BUG there: work\sync-errors.log held
   one archiver pass failure from 2026-10-25T23:42Z (Sort-Object IComparer inconsistent results), written by the OLD
   Owner-Tools lib copy that the owner's hook still runs. The sandbox passed because it has no sibling store.
   Handling: event sync-sort-inconsistent-comparer recorded (open; root cause and fix go into WS-020). Later passes are
   healthy (Hunt quick: no archive-prefix or index bug). The log was moved to work\sync-errors-acknowledged-20261026.log,
   content kept. Hunt quick then returned 0 bugs, exit 0.
   Why a second attempt is lawful: the one-Finish rule prevents re-running tests until they pass. Attempt 1 executed no
   test, and its blocker was a real environment finding that has been handled, not hidden. Attempt 1's evidence is kept
   in ws019-package\runtime\original-attempt1-blocked. Attempt 2 must pass in full; any failure stops WS-019.
   Non-blocking GAP noted for WS-020: event fixture-auto-gc-packs-lost-object cites pt-suite.log/fd-suite-merged.log;
   the real logs are *-merged-run1.log (2026-10-20 typo, no evidence lost).

   ## D23 2026-10-26 WS-020 trustworthy archiver: sort fix, evidence rules, auditable acknowledgement
   WS-019 RELEASED (main 640cd27, hosted 40363381219); hooks repointed to Workbench (backup kept). Under D19/D20/D21/D22/D12
   and the owner's rule to fix every bug seen, one bundled contract fixes what the WS-019 Finish block exposed:
   - Sync-Sessions index read `-DateKind String`. Codex proved (xhigh before-pass, verified by the orchestrator on this
     en-US machine) that cached DateTime start values mixed with new string values make Sort-Object's comparer
     inconsistent, failing an archiver pass.
   - Events dedupe includes Evidence, so an evidence correction is recorded.
   - Hunt checks only the latest nonempty evidence per pattern, so a correction clears a stale citation and the journal
     stays append-only.
   - `Sync-Sessions -AcknowledgeErrors -ExpectedSHA256 -Reason`, an auditable acknowledgement replacing the manual move made
     under D22. It is serialized with the error writer, archives immutably and verifies an event before retiring the log;
     new errors block again.
   - Owned-tree cleanup in four existing self-checks (bounded deletion helper).
   Not in scope:
   - RESUME.md: the sentence is still true after the repoint, and a native-pointer risk outweighs vague wording
     (event closed).
   - The hazard scanner's false cross-function collision: its own later contract.
   - Codex's mutant runner stays in the package as evidence, so it does not grow every Finish.
   Codex implemented in disposable C:\cx\ORVION-ws020 (archived naming) under orchestrator verification.

   ## D24 2026-10-26 WS-021 Workbench robustness: Hunt index rows, Pulse bounds and guard, hook deadline, scanner scopes
   WS-020 RELEASED (main e1b71a4, hosted 40375680952); the reviewed sync log was acknowledged through the new tool; the
   real-store Hunt shows 0 bugs and 0 gaps. Under D19/D20/D21/D22/D12, one bundled contract fixes the defects found by
   Codex's WS-019 after-pass and WS-021 before-pass (xhigh), all accepted:
   - Test-ScriptHazards groups variable spellings by the nearest function scope, so independent functions no longer
     collide falsely; same-scope collisions are still caught. The real tree stays at 0 hazards.
   - Hunt parses the session index once, reports malformed or unreadable rows as `BUG index-unreadable` with a count and
     continues instead of crashing; index-dependent findings are not resolved while the index is incomplete.
   - Pulse guards process and host discovery (`running  UNREADABLE`, exit 2; never a false "NOT running") and caps its
     output at 4096 characters, keeping diagnostics, counts and pointers first and ending with an exact `more` line.
   - The SessionStart hook runs Pulse as a child process with redirected files and a 6 s deadline, kills the owned tree
     on expiry and says live state is UNREADABLE; total context is capped at 8192. The orchestrator measured the real
     Pulse at ~2.0 s, so Codex's 3 s was raised to 6 s (fix1).
   - lib/README states these contracts.
   Codex implemented in disposable C:\cx\ORVION-ws021 (high, then medium) under orchestrator verification on the real
   store. The mutant runner stays in the package. Owner rule added: a rejected Codex item gets one rebuttal round.
   D24 addendum: Codex also made Pulse mask each whole line (Hide-Secret) before abbreviating it. This was unbriefed and was surfaced late by the owner-requested workflow audit; it is kept as a safeguard (ws021-package\codex\impl1-disposition.md).

   ## D25 2026-10-26 WS-021 sandbox Finish attempt 2 after a proven host-resource block
   Attempt 1 (ws021-package\runtime\sandbox-attempt1-resource-blocked) ran 17.5 min. 25 of 26 suites passed. test-workbench-governance failed only because its nested fixture Finish refused to start: WB_CONTEXT_RESOURCE_BUDGET_UNAVAILABLE. The resources CSV shows free memory falling from 3.5 GB to 0.41 GB at 22:11, with CPU at 100%.
   - The guard is in Workbench.ps1, which is outside WS-021's nine files. WS-020 passed the same suite in its sandbox and original runs.
   - Accountability: I ran Codex's WS-020 review and rebuttal beside the heaviest suite. That scheduling choice contributed.
   Authority: WORKFLOW.md issues a fresh receipt only on success and has no rule forbidding a fresh attempt. "One Finish per stage" is packet discipline (D22), so this attempt is recorded rather than silent. Attempt 1 certified nothing; attempt 2 must pass in full with its own receipt; the original stage keeps its own single Finish.
   Conditions for attempt 2: no Codex or other heavy job alongside it, and at least 3 GB of free memory, measured fresh just before the start.

   ## D26 2026-10-27 WS-023 recovery launcher: one double-click restore entry (RECOVERY profile only)
   WS-021 RELEASED (main 55662e7). The owner cancelled the Windows reinstall (OWNER-DECISION-20261027-no-reinstall.md) and
   amended lift criterion 5: the 2026-10-26 isolated restore of orvion-backup-20261026T201821Z.7z plus one isolated run of
   the released Restore-ORVION.cmd against a fresh package. Under D19/D20/D21/D22/D12, one contract delivers that launcher:
   - Backup-Workspace -Package records sourceUserProfile, packages Codex config.toml with URL passwords masked before
     SHA256SUMS is written (never as a recovery input), and only after a verified archive writes `<archive>.sha256` and
     copies Restore-ORVION.cmd/.ps1 beside it.
   - Restore-ORVION (Windows PowerShell 5.1, ASCII) installs only missing Git/7-Zip/PowerShell, verifies the newest archive
     against its sidecar with no older-package fallback, refuses existing staging and a profile mismatch (unless
     -AllowNewProfile), restores through the packaged Workbench's Restore-Workspace, runs each product's unchanged
     workstation.cmd unless -SkipProducts, and prints a READY/ACTION checklist.
   - Restore-Workspace restores the masked Codex config copy-once; HANDOFF section 12 and RECOVERY.md record the amendment.
   Scope stays RECOVERY+REPOSITORY: any WORKSTATION path is refused by the accepted checker until a CONTROL verifier
   exists, so the Workbench workstation.cmd is deferred to WS-024 (Codex rebuttal R2 confirmed). Codex before-pass (xhigh)
   and rebuttal R1-R3 accepted; implementation (high) in disposable C:\cx\ORVION-ws023, accepted after orchestrator review
   (ws023-package\codex\impl1-disposition.md). Clean-Windows tool installation stays UNPROVEN (owner-accepted residual risk).D26 addendum: sandbox attempt 1 was refused at Approval by the accepted judge (WB_ASSURANCE_DATE_INVALID): I dated V1/V2/V3 with the Cairo date 2026-10-27 while UTC was still 2026-10-26. Nothing was approved, executed or certified. The attempt is preserved in ws023-package\superseded-attempt1-assurance-date and the sandbox rehearsal-attempt1/probe-attempt1 folders; Freeze-WS023 now uses the UTC date. Refrozen V3 SHA-256 A21DC3B204EDD02FB33782DF2829B4013D5A8C6F380ABB1D037CC68FE6494EEB.

   D27 (2026-10-27, WS-022 "one clean layout and no known defect before Batch 6"): under D19-D26, the owner's 2026-10-27
   standing order (autonomous to Batch 6 resume; three folders; rebuildable sandbox; guard per workflow if earned; no
   orphan/duplicate .md; leave no known bug; Codex two-way method, xhigh ceiling, Sol/Terra by earn-it) and the owner
   decisions A/B (OWNER-DECISION-20261027-evidence-and-trusted.md), one Workbench contract WS-022 delivers: the temporary
   root resolver and managed process temp (exact clone homes only); honest data-root refusal (no checkout fallback); the
   five WS-023 after-pass fixes; records-based backup/restore with three Claude memory junctions and data-root .git
   refusal; Restore-Workspace -Temporary (skeleton + pinned actionlint 1.7.12 from the judge's exact pins) and the hourly
   map task; archive sidecar lock; Events current-row dedupe, repo auto-fill and -Repo filter; Pulse masked footer,
   urgent visibility and map freshness; Hunt map-task guard; scanner dot-invoke fallback; Spider over all repositories;
   the Markdown consistency guard with root-doc roles/budgets and a WORKFLOW "Working with Codex" section; STATE.md cutover
   (root RESUME.md = two-line pointer). Profiles REPOSITORY+CONTROL+COORDINATION+RECOVERY; no WORKSTATION path (Codex
   before-pass: narrow -Temporary rebuild is recovery, not workstation setup). Runtime Root is permanent
   (ORVION-Owner-Tools\records\WS-022\runtime); sandbox parent ORVION-Workbench-temporary\sb\W22. Evidence and
   dispositions: records\WS-022\*. Gate 1 for this Draft is DELEGATED (not owner-typed). CTRL-19 stays OPEN; Batch 6 HOLD
   until the owner's lift record.
   D27 addendum (freeze): four frozen attempts were superseded before any allocation, each preserved under records\WS-022\package\superseded-attempt1..4 with a README: (1) the old HANDOFF fenced block cannot be expressed inside step fences -> fence lines kept (now the owner's lift-record template) and the prototype uses diff.algorithm=histogram; (2) >26 edits exceed the applier's a)-z) lettering -> one whole-text edit; (3) a missing blank line before section 12 hit a generator/applier edge -> blank line restored; (4) Runtime Root must contain the Finish log -> Runtime Root = records\WS-022\package\runtime. Selected V3 SHA-256 4E951E0D6944E3C55EF554DADE765151B85FD15FB1E5BCE1A2184002907A7F3A; four literal controls passed. Nothing was approved, executed or certified by attempts 1-4.
   D27 addendum 2 (sandbox attempt 1): the one sandbox Finish of frozen V3 4E951E0D... BLOCKED at preflight with WB_REQUIRED_HUNT_FAILED after 0.1 min: Finish's required Hunt Quick refused ORVION_DATA_ROOT_UNAVAILABLE because a sandbox clone has no sibling data root (slice 1 correctly removed the checkout fallback; no focused test exercised Finish's preflight). Nothing was approved for the original or certified. Runtime preserved in records\WS-022\package\superseded-sandbox-attempt1-runtime; the clone is temporary\sb\W22\rehearsal-attempt1-finish-hunt. Fix: lib/workspace-layout.ps1 Get-OrvionFinishHuntDataRoot gives that Hunt an empty disposable store under the managed temp (never the checkout), with a focused test and a killed planted mutant. Refreeze and a fresh sandbox lifecycle follow (as D25 did for WS-021).
   D27 addendum 3 (sandbox attempt 2): frozen V3 F2881B1C... ran its one sandbox Finish for 21 min: 38 suites PASS and test-markdown-consistency FAIL (MD_HISTORY_MISSING: the guard demanded an explicit history-index entry for the contract's own file, which only exists after allocation, so no contract could pass). Nothing certified. Runtime preserved (superseded-sandbox-attempt2-runtime). Fix: allocated contracts changes/WS-NNN-*.md are history by name; any other changes/ file stays orphan-checked (test + killed in-test mutant); WORKFLOW wording updated.
   D28 (2026-10-27, WS-025 "Codex tripwire and Hunt transcript invariant"): under D19-D27, the owner's standing order and
   the owner's approval of the learning-pass improvements (records\LEARNING-20261027.md: P2 and C1 accepted, Codex
   amendments applied), one small Workbench contract WS-025 delivers: Hunt's archive-prefix invariant only for append-only
   *.jsonl transcripts (event hunt-prefix-check-memory-files: edited memory/meta files were false BUGs that blocked WS-022's
   first original Finish); lib\Delegate.ps1 -CodexBrief/-Clone, the one Codex launcher (fresh session, TEMP in its own
   scratch, effort ValidateSet low..xhigh = the owner ceiling, outside-agent tripwire over the system drive, profile and
   GitHub folder top level and every sibling git checkout incl. dirty-file content: exit 4 + failure event
   codex-outside-write; a tripwire, not confinement); -ReadRoots narrowing a brief's file and git read authority;
   WORKFLOW and lib/README lines. No new suite or script (schedule unchanged). Baseline 77eff5d (main = WS-022). Codex
   after-pass (medium) found 3 defects, all accepted and fixed (records\WS-025\review1-disposition.md). Sandbox parent
   ORVION-Workbench-temporary\sb\W25; packet and Runtime Root records\WS-025\package. Gate 1 DELEGATED (not owner-typed).
   CTRL-19 stays OPEN; Batch 6 HOLD until the owner's lift record.
   D28 addendum (freeze): attempt 1 (V3 DBC6460B...) was refused at SANDBOX approval with WB_WRITE_SCOPE_REFUSED:RESUME.md because Freeze-WS025 left the active pointer out of Write Scope (every contract keeps it: WS-020/021/023); preserved in records\WS-025\package\superseded-attempt1-scope-resume with WHY.txt. Attempt 2 selected V3 C667A55C52259BA61B922C1436288EE7E2110D0697B91E9BA8098EA51ADB3687; four literal controls passed; evidence (27 suites, hazards 0, 9/9 mutants) is unchanged because the six output bytes are identical. Nothing in attempt 1 was approved for the original, executed there or certified.

   ## D29 2026-10-27 Step 2 product fixes: native release method of D16, one time, for exactly two SPECs (sequence "CRM first" amended by D30)
   Owner approved plan Step 2 (CRM then ORVION evidence-default fix; ORVION also the ADR-0034 no-reinstall amendment and its
   pinned consumers). Owner answer (verbatim): "I approve the same native release method as D16, strictly for the two Step 2
   SPECs: CRM first, then ORVION. This is a new, one-time, explicitly scoped owner authorization—not a permanent bypass or
   delegation of future release authority. All mandatory Codex reviews, native lifecycle gates, hosted checks, branch
   protection, and REMOTE_CERTIFY requirements must remain fully enforced. No force operations, configuration changes,
   skipped gates, or unrelated releases are authorized. Complete and certify CRM before proceeding to ORVION. Stop
   immediately on any failed gate or unexpected scope change. Record this decision in the existing authoritative records and
   preserve the required evidence and OneDrive continuity. This authorization does not extend to Step 3 or any future SPEC."
   Applied: the console prompt is never emulated; native publish_candidate.ps1 / promote_main.ps1 run directly per D16.
   Packets: records\step2\pt-<spec> and records\step2\fd-<spec>. Gate 1 DELEGATED (not owner-typed). CTRL-19 OPEN; Batch 6 HOLD.

   ## D30 2026-10-27 Step 2: CRM and ORVION run concurrently (amends D29's sequence only)
   Owner directive "Concurrent CRM & ORVION Execution" (2026-10-27): "You are authorized and instructed to work on CRM and
   ORVION concurrently, rather than waiting for CRM to be completed and certified before starting ORVION ... Concurrency is
   authorized. Bypassing governance is not." This replaces only D29's "Complete and certify CRM before proceeding to ORVION";
   everything else in D29 stands (one-time D16 release method for exactly the two Step 2 SPECs, all gates enforced).
   Each repository keeps its own contract, Codex review, tests, Git history, protection, Publish/Promote/REMOTE_CERTIFY and
   packet (records\step2\pt-spec296, records\step2\fd-spec299); separate prototype/rehearsal clones under
   ORVION-Workbench-temporary\sb. Existing rules still bind the overlap: a Codex run never runs beside a suite or Finish,
   and heavy runs are observed by Watch-Host (COMMIT LOW = apply the owning run's recovery policy). Step 3 waits until both
   products meet Step 2 exit conditions. No deletion authorized.

   ## D31 2026-10-27 Three genuinely distinct Drafts per contract (applies from Founder SPEC-299; Platinum SPEC-296 left as is) (author and Codex-budget lines superseded from WS-026 by D33/D34, then by D38; purposes stand) (Routine-tier changes amended by D96: one Claude Draft)
   Owner: the three Drafts must each be real work by a high-capability author and the orchestrator verifies they differ and
   that the selected one is best. Agreed method (owner answer, 2026-10-27): V1 Design = complete Draft by the orchestrator at
   high effort; V2 Adversarial = complete revised Draft by a fresh Codex session at xhigh (a different author from V1),
   with the reason for each change; V3 Evidence Refresh = definitive evidence (native admission parser, owning tests and
   mutants, sandbox Approve) plus alignment with current standards, best practices and research and our principles; then
   the orchestrator saves V1->V2->V3 diffs and a selection table (change, pass, evidence) and selects. Differences are never
   manufactured: an adversary finding nothing is recorded as such. Effort scales with risk (xhigh for Significant /
   Owner-Decision, high for trivial). Codex budget: one xhigh run per contract (V2), evidence embedded in its brief.
   D31 addendum (owner, 2026-10-27): "keep this methodology for every coming SPEC and slice" - D31 is a standing rule for
   all future CRM/ORVION SPECs and Workbench slices/contracts, not only SPEC-299.

   ## D32 2026-10-27 Codex input efficiency: refined controls adopted; web search NOT yet authorized (web-search exclusion superseded by D33 for the governed WS-026 path; input rules stand)
   Measured (temporary\scratch\codex-input-analysis\result.txt): input = steps x accumulated context; briefs are 3-6 KB;
   the cost is large early outputs re-sent on every later call (V2 xhigh run: 3.18M input, 60 commands, 611k chars of
   output; top three reads ~40%), mostly re-learning native rules each session. Verified: Codex auto-loads the clone's
   AGENTS.md (~22k chars) into its instructions, so re-reading it duplicates.
   Owner decision (verbatim priority): "reduce unnecessary context consumption while preserving Codex's intelligence,
   autonomy, independent research, and ability to discover unforeseen defects." Adopted within the existing workflow:
   (1) targeted retrieval, large tool output kept in files, no rigid line limit on mandatory governance or contracts, do not
   re-read the auto-loaded AGENTS.md; (2) a native-rules reference is only a concise traceable index (file:line) of verified
   rules plus the existing admission checker, never a duplicate governance source and never a substitute for native
   evaluators or gates; (3) fresh sessions only at existing approved phase boundaries with concise file handoffs, no extra
   phases or resets; (4) lightweight observation from existing execution logs only (no A/B, no per-run analysis, no new
   telemetry). New work split (Codex: prototype + V1/V2/V3 at xhigh with its recommendation; Claude: review and choose)
   starts from WS-026. NOT authorized: any Delegate.ps1 change or live web search; WS-026 scope unchanged. Web search
   needs a separate, precisely scoped authorization.

   ## D33 2026-10-27 Governed Delegate upgrade, live research, Codex-authored Prototype/V1/V2/V3 (reopens D32's exclusion) (authorship, selection and the -WebSearch scope superseded by D38; addendum (2) stands; addendum (3) stands as corrected by D37)
   Owner directive "Governed Delegate Upgrade, Live Research and Codex-Led Engineering Variants" (2026-10-27): reopen the
   Delegate.ps1 improvement through the formal contract lifecycle (not a Workbench redesign): smallest opt-in hosted live
   web search, default runs unchanged, real web-search events as proof, explicit failure instead of false success, no shell
   networking, no global/user config change; Codex owns Prototype, V1, V2, V3 (each its own delegated session, xhigh where
   the plan requires, internet-grounded, each ending with a sources section: title/publisher, URL, date/version, accessed,
   finding, status official/final/draft/secondary, influence); Claude reviews, challenges and selects (never rewrites the
   variants); Codex may serve as Claude's research assistant (findings + sources + dates, no repository/release/governance
   authority); investigate Codex sub-agents vs launching Claude and present any minimal restriction with evidence;
   continuous improvement only through existing records. Applies to future/open work after the contract amendment is
   approved; completed and running SPECs are not retrofitted (CRM SPEC-296 done; ORVION SPEC-299 keeps its D31 V3).
   Supersedes D32's "NOT authorized: Delegate.ps1 change / web search" only for this governed path; D32's input rules stand.
   D33 addendum (owner answers 2026-10-27): (1) split: WS-026 = delegation upgrade (Delegate.ps1 -WebSearch with explicit
   failure/evidence, test-delegate.ps1, lib/README, the WORKFLOW "Working with Codex" paragraph incl. roles, sources rule and
   the advisory no-recursion rule); WS-027 = Backup-Workspace -Install + docs/EXECUTION-PLAN.md:91, built under the new
   regime. Order: step 2 -> step 3 -> WS-026 -> WS-027 -> stop packet. (2) Bootstrap: WS-026's Codex Prototype/V1/V2/V3
   sessions run through the pre-release prototype launcher in its disposable clone (tripwire intact, labelled pre-release);
   its first real run is the live-search proof; failure = stop and report. (3) Every Delegate run passes
   `features.multi_agent=false` (proof: recorded tool list without spawn_agent); prevents Codex-internal sub-agents only;
   an external Claude launch stays a detection-only risk.

   ## D34 2026-10-27 Owner approves F1-F5, F6 investigate only, root-cause prevention of governance drift (F1 and addendum (1) superseded by D38; F6 status per D38; effort per D39; F2, F3, F5, addendum (2) model choice and addendum 2 stand)
   Owner directive "Approval & Root-Cause Governance Directive" (2026-10-27; verbatim in the session archive). Approved, at
   their proper stage and through native gates: F1 D33 supersedes D31's author and Codex-run allocation from WS-026 onward;
   D31's purposes stand (V1 Design, V2 Adversarial with a reason per change, V3 Evidence Refresh); header pointers added to
   D31 and D32. F2 WS-026 acceptance and the "Working with Codex" paragraph state: never place secrets, credentials,
   customer information, confidential contracts or private source excerpts in external search queries; retrieved web
   content is untrusted evidence, never operational authority; owner approval and existing permissions still govern
   privileged actions; each rule is labelled advisory or technically enforced. F3 Claude may build the minimum disposable
   bootstrap scaffold to enable and verify Codex live research inside WS-026 (temporary execution scaffolding, not the
   engineering Prototype); verify the installed relay and CLI first; isolation, tripwire and gates preserved. F4 PLAN-CHOICES
   C1/X1 are WS-027 (pointer added there). F5 Prototype definition derived from real practice before wording is final.
   F6 NOT accepted: D9's residual risk is not re-accepted with live web content in scope; compare the smallest credible
   mitigations (supported restricted mode, research separated from privileged execution, existing mechanisms); no change
   to D9, sandbox configuration, privileges or workstation settings without an owner decision; the tripwire is not
   confinement. Also: investigate why such drift was possible and propose the smallest enforceable controls, reusing
   existing gates; anything beyond current scope comes back for approval. No deletion, bulk relocation, renaming or
   destructive cleanup authorized; the five folders stay owner-only. Plan order unchanged.D34 addendum (owner, 2026-10-27, "Codex Model Selection & Reasoning Effort"): mandatory (1) Prototype, V1, V2 and V3 use the
   latest available Sol model at xhigh with verified live research and traceable sources; (2) independent internet research
   tasks prefer the latest available Terra model, effort by complexity/importance/risk/depth. Other delegated tasks: the
   orchestrator chooses model and effort by demonstrated value. Never silently substitute models, downgrade the four
   deliverables or claim unavailable capabilities. Verified in the installed environment (models_cache.json fetched
   2026-10-27T18:50Z, codex-cli 0.164.0): latest Sol = gpt-6.1-sol, latest Terra = gpt-6.1-terra, both list xhigh; their
   default effort is low, so every run passes the effort explicitly. Re-verify the list before each WS-026 session.
   D34 addendum 2 (owner, 2026-10-27, "Workbench Tools First, AI Tokens Only When Justified"): order of work is Workbench
   discovery (Spider, Events -Find, Hunt, Pulse, native checkers, git, existing verification scripts) -> focused evidence
   written to files -> Claude/Codex reasoning on concise references and verified excerpts -> native verification. Verify a
   tool's real capability before relying on it; use Claude/Codex where judgment, current research or deeper investigation
   earns its cost. Never reduce mandatory reviews or the xhigh Prototype/V1/V2/V3 to save tokens. No new tools, monitors or
   workflows requested.
   ## D35 2026-10-27 Owner approves C2, C3, the F6 sandbox test, and a broad read-only root-cause audit with Codex as a primary partner ("Prototype/V1/V2/V3 stay Sol xhigh" superseded by D38)
   Owner directive "Approval & Comprehensive Root-Cause Audit" plus addendum "Codex as a Primary Research and Audit Partner"
   (2026-10-27; verbatim in the session archive). Approved in principle: C1 extended (permanent->temporary citations,
   operational scripts, event-evidence paths that break after folder deletion); C2 supersession back-pointer validation in an
   existing checker, append-only history kept; C3 Delegate preserves required brief/answer in a permanent records location,
   default behaviour unchanged; C4 memory = pointers; C5 owner-requirement fidelity. F6: test the restricted sandbox in
   isolation (write and network boundaries, hosted-search compatibility, bypasses, workflow impact); any change to D9's
   execution privileges must be in the implementation plan for owner approval. Authorized now: read-only investigation and
   ONE consolidated correction plan (sections A-J) in the existing records; Codex carries a major share of the investigation
   (latest verified model, high or higher; Prototype/V1/V2/V3 stay Sol xhigh), Claude coordinates, verifies material
   findings, challenges and consolidates; no claim of Codex live research before WS-026 proves it. NOT authorized before the
   owner reviews the plan: restructuring, destructive cleanup, security-setting changes, new structural mechanisms. Lift
   sequence binding; resource and parallel-execution rules stand; the audit must not become an endless investigation.
   ## D36 2026-10-27 Owner approves the D35 plan (audit-20261027\PLAN.md) with conditions
   Owner "Response to the Consolidated Audit" (verbatim in the session archive). Approved: WS-026 2a (disable Codex memories
   per run via the supported setting, verify it is effective, keep historical memory files), 2b (brief override of the
   global AGENTS.md = defense-in-depth guidance only, never a reliable override), C3 (reuse the relay's output capability:
   validated permanent path, unchanged default, integrity checks); WS-027 docs (RECOVERY.md, EXECUTION-PLAN.md, RESUME.md,
   WORKFLOW wording; any dependency that would invalidate Step 3 is corrected before that test); WS-028 (narrow, Hunt-based
   C1+C2, real FAIL and PASS tests, accurate coverage reporting, no new framework, Lift sequence kept); Step 5 corrections
   in principle (both products' settings.local.json, final preserved package with verified cloud hashes; confirm all
   consumers first; no deletion of protected folders before the owner's Lift approval); global ~\.codex\AGENTS.md minimal
   correction (recoverable copy kept, effect on other repositories considered, verified in a new delegated session).
   F6: portable PowerShell and Windows sandbox measurements approved; option (2) NOT approved yet: determine whether
   sensitive reads and disclosure can be constrained within the existing architecture; final acceptance must cover read and
   write boundaries, private records/credentials exposure, hosted live search, DNS/other network, native script/gate
   compatibility, portable PowerShell (durable recoverable location if it becomes a runtime dependency), bypasses and
   residual risk; else compare research/execution separation with the exact D33/D34 amendment. Advisory text never counts
   as preventing disclosure. Step 3: proceed only after its execution and acceptance are shown safe and valid (explicit
   current recovery-input map, isolated paths and environment, real task protected and restored on success or failure,
   three Boots actually run, memory junctions and maps verified, logs outside staging, cloud round-trip hash of the same new
   archive, STATE.md effect checked); name any blocker before the risky operation. C1: complete coverage and zero unresolved
   required dependencies (157 event paths, 7 missing, Contract A, 3 extra unique records, Sandbox dependencies, legacy
   scripts); never invent evidence or rewrite history.
   ## D37 2026-10-28 Owner: WS-029 before Criterion 5; D33 addendum (3) acceptance wording corrected; F6 still pending (deletion-required acceptance superseded for the WS-029 V3 successor by D43)
   Owner decision (verbatim in the session archive). (1) WS-029 approved, limited to the measured Windows PowerShell 5.1
   long-path staging-cleanup defect (event restore-launcher-long-path-cleanup) and its tests: extended-length prefix fix;
   acceptance = original failure reproduced; cleanup succeeds above 260 chars incl. the real package's path lengths; target
   validated as the intended isolated staging; normalization, junctions/reparse points and deletion outside staging handled
   safely; short paths unchanged; no registry/long-path setting change; native tests and independent review. No recovery
   redesign. WS-029 precedes WS-026, so it follows D31 (V1 orchestrator, V2 Codex xhigh adversarial, V3 evidence refresh),
   not D33 authorship. Then Step 3 under the agreed criteria. Order otherwise unchanged:
   WS-029 -> Step 3 -> WS-026 -> WS-027 -> WS-028 -> stop packet.
   (2) D33 addendum (3) proof "tool list without spawn_agent" is NOT met and must never be claimed (codex 0.164 sends
   spawn_agent under every supported setting, measured 2026-10-27). Corrected acceptance distinguishes: restriction
   requested by configuration; tools actually exposed; sub-agent creation actually observed in logs; whether spawning is
   technically prevented (it is not); residual risk. A clean run is not proof of impossibility. No uncontrolled sub-agent
   launched to test. The no-recursive-delegation rule stays; a confirmed unauthorized sub-agent creation fails/escalates
   the run. Documented limitation, not permission. Revisit when a verified supported capability exists.
   (3) F6 pending: measure readable-root restriction; D9 privilege model unchanged until the owner decides.
   D37 addendum (owner, 2026-10-28, "Reconsider WS-029 Complexity"; verbatim in the session archive): the owner will
   abandon the proposed cleanup implementation if making it safe needs disproportionate complexity or fragile
   workarounds. Before keeping low-level Windows APIs, handle-based deletion or a larger security design, evaluate a
   simpler supported mechanism; separate realistic threats in the approved operating model from hypothetical same-user
   adversarial processes. Preferences: minimal, demonstrably safe; fail closed when deletion safety cannot be
   established, preserving staging and diagnostic evidence rather than risking outside data; no redesign or expansion.
   If the current approach cannot meet this economically, recommend abandoning it with the smallest practical
   alternative and its consequences for Step 3. Approval is to challenge the solution, not to add complexity to rescue
   it; no gate bypass; an incomplete recovery is never reported as successful. Relayed to the running V3 author.
   ## D38 2026-10-28 Research-led, risk-proportionate engineering pipeline (implemented and verified through WS-026) (effort levels superseded by D39) (research role amended by D100: Claude main researches; Codex has no internet)
   Owner "Conditional Approval of the New Engineering Workflow (D38)" (verbatim in the session archive), approving the
   direction of records\workflow-proposal-20261028\EVALUATION.md with refinements. Applies from WS-026 onward; WS-029 and
   Step 3 keep D37; nothing is retrofitted; completed product releases are not reopened.
   Pipeline (full tier): (1) Terra research: latest verified Terra, effort by Earn It & Worth It, in a restricted research
   mode with no command execution and no unnecessary local data; live, source-backed, critical Research Evidence Pack that
   separates verified facts, standards, drafts, hypotheses, risks and open questions. (2) Prototype: Claude Main, in the
   authorized disposable environment. (3) V1 Design: Codex, latest verified Sol at xhigh. (4) V2 Adversarial: fresh Codex
   session, Sol xhigh, a justification per material change. (5) V3 Evidence Refresh: a fresh Claude subagent (D31's V3
   obligations unchanged: native admission, owning tests, mutants, sandbox verification, standards; states its changes and
   remaining risks); its isolation, tools, nesting and permissions verified before operational use. (6) Dual review of the
   same frozen candidate by Claude Main and Codex: ACCEPT / REVISE / BLOCK inside WORKFLOW.md:45's agreement table and
   rebuttal round; a material rejection cites a reproducible defect, mandatory requirement, test, security finding or named
   gate; preference never triggers a Draft. (7) At most one V4 by a fresh Claude subagent, reviewed again the same way;
   remaining material disagreement goes to the owner as a concise decision packet; no V5. A failing native gate blocks
   regardless of agreement. (8) Claude Main implements through the existing native lifecycle and scripts; independent
   Review, Finish, release, remote checks and owner boundaries unchanged; AI agreement replaces no gate.
   Tier: by risk, not size (security/confidentiality, data loss or destruction, recovery/backup/restore, authentication or
   privilege, migrations/data integrity, release/governance controls, cross-repository dependencies, complexity,
   reversibility, uncertainty), using the existing contract classification; no new score or admission mechanism. Lighter
   work uses the existing workflow (D31 or native lifecycle) with every mandatory gate. The tier and its reason are
   recorded in the contract or execution evidence.
   Models: Sol xhigh for V1/V2; latest verified Terra for research; Claude Main chooses Claude model/effort for Prototype,
   V3/V4 and implementation unless a contract requires one. D34 addendum 2 (Workbench tools first) and D35 apply.
   Supersedes: D33 authorship (Codex Prototype/V1/V2/V3), "Claude selects, never rewrites" (now the dual review), and
   addendum (1)'s "Delegate.ps1 -WebSearch" scope (now the restricted research mode; engineering sessions get no web
   search); D34 F1 and addendum (1) ("Prototype/V1/V2/V3 Sol xhigh with verified live research"); D35's equivalent
   phrase. Stands: D31 purposes; D32 input rules; D33 addendum (2) bootstrap and (3) as corrected by D37; D34 F2, F3, F5,
   addendum (2) Terra for research, addendum 2; D9.
   F6: research/execution separation approved as the preferred architecture; F6 is NOT resolved. Measured controls are
   recorded apart from residual risks: prompt injection carried by research artifacts; D9 engineering sessions keep shell
   networking; automatically loaded instructions or context; any local-access path not measured. Briefs carry only
   necessary sanitized context; loaded instructions, memory behaviour and exposed tools are verified. Claude's review of
   the pack is a safeguard, not a guarantee. This authorizes implementation and isolated verification only, not
   re-acceptance of exfiltration risk for production use: if the exposure cannot be reduced within scope, present its
   exact boundary and the needed decision before enabling the affected privileged workflow. No elevated Windows sandbox,
   machine-wide security change or privilege expansion.
   Claude subagents: no recursive hierarchy. Find the smallest supported per-task configuration giving a fresh context,
   only the role's tools, no unnecessary internet or private-record access, no further delegation, filesystem/execution
   boundaries, and traceable input/output; per-task restrictions before global settings; a repository agent definition
   only if required, with its exact location, contract scope and native tests. A subagent is not a sandbox; an
   unenforceable mandatory restriction is documented as residual risk and stops at the approval boundary.
   Cleanup: no automatic deletion now; after WS-028's native dependency/placement checks, evaluate a minimal stage in the
   existing Complete/lifecycle closure (identify, preserve, verify hashes/references/sync, confirm no dependency, remove
   only positively identified disposable artifacts, record result or refusal). No standing destructive-cleanup permission;
   the five Lift folders stay owner-controlled. Order: WS-029 -> Step 3 -> WS-026 (amended) -> WS-027 -> WS-028 -> stop
   packet -> owner Lift -> Batch 6. Optional improvements never become new prerequisites.
   WS-026 acceptance adds: verified Terra live search with traceable sources; measured research-session restrictions and
   limits; correct model/effort; the approved Prototype/V1/V2/V3 roles; verified subagent behaviour and bounded delegation;
   dual-review verdicts and the V4 limit; native gates and owner authority preserved; existing runs outside the new
   workflow unchanged; evidence retention and source attribution. Report concrete blockers, not redesign opportunities.
   ## D39 2026-10-28 Maximum reasoning effort for the Prototype, every Draft, critical reviews and deep research (level revised to xhigh by D41; scope, verification and subagent fallback stand)
   Owner addendum "Mandatory Maximum Reasoning Effort" (verbatim in the session archive). Every agent that authors,
   improves, adversarially challenges or reviews the Prototype or any Draft (V1, V2, V3, V4 or a later owner-approved
   revision), every independent review or adversarial assessment of them, and the deep internet research supporting them
   (standards, papers, security, technical investigation) runs at the highest reasoning effort its selected model
   supports. Model choice stays Earn It & Worth It; effort for these activities is never lowered to save tokens, time or
   capacity, and never silently. Routine discovery, deterministic checks and low-risk administration stay flexible.
   Verified 2026-10-28 (records\effort-20261028\VERIFIED.txt): codex-cli 0.164.0 lists low, medium, high, xhigh, max and
   ultra for gpt-6.1-sol and gpt-6.1-terra; a read-only probe of each with `max` completed and its session recorded
   effort "max". So the Codex maximum for these activities is `max`, not xhigh. `ultra` is excluded: it adds "automatic
   task delegation", which the no-recursive-delegation rule (D37 (2)) forbids. Claude: Opus 5.5 (and the other current
   Claude models) support `max`; Claude Code applies it per session with `/effort max` (or persistently only through the
   CLAUDE_CODE_EFFORT_LEVEL environment variable; the effortLevel setting cannot hold max; this user's setting is "high");
   Claude subagents get it per invocation (Agent effort "max").
   Supersedes, for these activities only: the owner xhigh ceiling (D26's text: "xhigh ceiling"; "effort ValidateSet
   low..xhigh = the owner ceiling") and every "xhigh" or "effort by importance" line in D31, D33, D34 addendum (1)/(2), D35 and
   D38. Limits, stated rather than hidden: Delegate.ps1 accepts at most xhigh (lib\Delegate.ps1:26), so governed Codex runs
   stay at xhigh until WS-026 adds `max` (never `ultra`) with a test; launching Codex outside Delegate.ps1 is not allowed
   (WORKFLOW.md:49). Claude Main's own session effort is set by the owner (`/effort max`); the orchestrator does not change
   user settings or environment. WS-029: its V2 started at xhigh before this rule, at the governed launcher's limit
   (recorded, not a silent downgrade); its V3 and reviews are Claude Main's at the session's effort.
   D39 addendum (owner, 2026-10-28, "Mandatory Max-Effort Claude Subagent Fallback"; supersedes the last sentence above):
   when Claude Main cannot run at `max`, the Prototype, V3 Evidence Refresh, any V4, and critical adversarial reviews and
   deep research are authored by a fresh Claude subagent whose `max` effort is verified in its effective runtime (a prompt
   asking for deeper thinking is not proof). Claude Main stays orchestrator (contracts, evidence, governance, native
   gates), independently examines the result, and delegates further max-effort review where required. The subagent
   follows the same contracts, approval boundaries, security restrictions and evidence rules; no nested or recursive
   delegation. If a verified max-effort subagent cannot be launched, report the blocker; never present lower-effort work
   as compliant. No change to the owner's global Claude settings is needed or made. WS-029: D31/D37 name the V3 purpose
   (Evidence Refresh) but not its author, and keep diffs, the selection table and selection with the orchestrator, so a
   subagent-authored V3 fits without a contract-authority conflict.
   ## D40 2026-10-28 Model-selection rule by family, never a pinned version; exact identifiers only in execution records
   Owner "Future-Proof Model Governance and WS-029 Continuation" (verbatim in the session archive). Reusable governance
   names a rule, not a version: the latest available, verified, compatible model of the family: Opus for Claude's
   critical engineering, independent reviews and subagents; Sol for Codex engineering, adversarial analysis and Draft
   authorship; Terra for independent technical and live internet research; always at the highest supported effort for
   D39 work. Before each run verify availability, capabilities and effective effort (the CLI's own model list and the
   run's recorded runtime; no new registry or configuration mechanism); never pick a model only because it was once
   recorded as latest; never downgrade silently. Execution records, evidence packets, frozen contracts where
   reproducibility needs it and audit logs keep the exact identifier, effort and runtime configuration actually used:
   historical truth, never a future requirement. Version strings in D34's addendum, D39 and records\effort-20261028 are
   verification records of that kind. Pinned versions found in reusable mechanisms (2026-10-28): WORKFLOW.md:47 (also the
   superseded xhigh ceiling) and lib\Delegate.ps1:10/27 (model allowlist and default) and lib\test-delegate.ps1:55; they
   change through WS-026 (family-based selection resolved from the CLI's model list, exact identifier recorded per run).
   Subagent security wording (owner point 3), as measured for the built-in Plan type: Agent-tool spawning is unavailable
   (its tool list omits Agent; launch record spawnDepth 1); spawning another process or agent CLI (claude, codex) through
   its shell is NOT prevented (it has PowerShell/Bash); filesystem limits are NOT enforced (an instruction only);
   before/after checks and the Delegate tripwire are detection only. The no-recursive-delegation rule stands.
   WS-029 V3 approved: after Codex V2, a fresh max-effort subagent on the latest verified Opus; Claude Main coordinates,
   verifies the patch, prepares diffs and the selection table and runs every native gate; a second max-effort review only
   when evidence and risk justify it. Frozen V1 and D31/D37 unchanged; D38 not retrofitted.
   ## D41 2026-10-28 Effort revised: xhigh for D39 work (supersedes D39's max); OneDrive path-length rule
   Owner "Reasoning Effort Revision & OneDrive Path-Length Fix" (verbatim in the session archive). (1) The Prototype,
   V1/V2/V3/V4 authoring, adversarial and independent reviews and deep internet research run at `xhigh`: Codex Sol and
   Terra at xhigh; Claude at xhigh where the model supports it, else high (never an unverified level or claimed
   equivalence). Verified 2026-10-28 (records\effort-20261028\VERIFIED.txt): both Codex families list xhigh and every
   Delegate run records it; Claude Opus (claude-opus-5-5) supports xhigh and a Plan subagent launched at xhigh recorded
   output_config effort "xhigh". Model choice stays D40 (latest verified of each family). Stands from D39: the scope of
   the activities, no silent downgrade, verification of the effective effort, and the addendum's subagent fallback, now
   at xhigh (Claude Main's session runs at high, so this work goes to an xhigh subagent). Superseded: D39's `max` level
   and its WS-026 item "Delegate.ps1 gains max" (Delegate's xhigh ceiling already matches). History kept: runs already
   made keep their recorded effort (WS-029 V2 xhigh; the running WS-029 V3 subagent started at max and is not
   interrupted or rewritten). (2) Permanent, synced records hold deliverables and concise evidence, never generated test
   fixture trees; long-path tests stay in their suites and run in temporary locations. Applied the same day: event
   onedrive-path-too-long-fixture-residue; records\WS-029\package\v2-codex-xhigh\FIXTURES-NOT-KEPT.md.

   ## D42 2026-10-28 WS-029 V3 current-run author and effort override
   Owner's direct instruction in the Codex continuation: "use sol with high effort not opus".
   For this WS-029 V3 segment use a fresh latest-verified compatible Sol worker at high effort through the existing lib/Delegate.ps1, instead of Opus/xhigh. Record the actual model and runtime effort. Frozen V1/V2, D31/D37 purpose/scope, independent verification and all native gates remain. This records the current-run instruction; no broader change to future author/effort policy is inferred.
   ## D43 2026-10-28 WS-029 Candidate C approved; recovery success separated from housekeeping
   Owner attachment "WS-029: Stop Solving Automatic Deletion" explicitly approves Candidate C: develop the minimal non-deleting launcher, preserve required restore/preparation/verification, retain fresh uniquely named staging, report its absolute path/status and housekeeping separately, and prepare narrow WS-029/Step 3 acceptance amendments. No automatic staging disposal, purge engine, new service/dependency, old evidence edits or gate waiver. Check repeatability, placement outside permanent Git/known OneDrive roots, sensitive unencrypted contents and available disk before extraction proportionately. Disposal remains separately owner-authorized. This supersedes D37's deletion-required acceptance for the successor WS-029 V3 only; frozen V1/V2 and WS-023 history remain intact. D31 method and native admission/review/Finish/release/certification remain.
   The attachment repeats Opus/xhigh, but after an explicit clarification the owner answered "Sol at high". Therefore D42's fresh Sol/high author choice applies to Candidate C; record actual runtime. Automatic-deletion Sol run stopped on this owner instruction (task relay tree 20268 only); its incomplete exploratory evidence is package/stopped-sol-high-ab, not an accepted Draft.
   ## D44 2026-10-28 Delegated bounded WS030 diagnostic succession; no frozen edit or gate waiver
   Codex execution decision under OWNER-DELEGATION.md SHA25694631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217 and the owner's continuing direction to resolve the actual blocker through established contracts. This is DELEGATED, not a newly typed owner digest. Original WS029 failed native Finish twice; seven focused Watch-Reminder probes PASS do not prove its actual assertion/cause/fix. Accepted authority/code and independent Sol advisory establish separate predecessor cancellation then unique successor allocation as the smallest admitted path for one out-of-frozen-scope tests.ps1 reporting edit. Cancellation preserves old authority/approvals/history and recovery bytes; it is not completion. Baseline84ba668 is openly pre-cancellation and every transition is independently judged.
   WS030 V3 SHA2567DFD342DA15F7A6A2262FE8344C4B9AB5C0D4FCCC47DA6AE315E8C3E0EA26E4F; sole new output tests.ps1 c0dc2d60183ea8168b0caa107875d44d26721aab retains all already-captured failed-child output. Recovery outputs unchanged; no automatic deletion, assertion/schedule/resource/receipt change or identified root-cause fix. New V1/V2/V3 actual Sol/xhigh under D41; historical D42/D43 high remains valid. V1 timeout with complete validated artifact retained distinctly; V2/V3 completed0, tripwires clean. Four reporter controls PASS, three mutants killed, hazards0, four final literal controls PASS.
   Fresh successor sandbox24a6dc6f6985b71adb4ba64de66a84e7f8dc4cd1 completed its own native full Finish18.6min exits0/0/0, fresh receipt F6B3EE66F8A4EFF9832F7AC4C503F91FDEAB20C191663ED43A5B734F3EB460AA, four protected-root/raw/config/index/ref/proof and368prior-file audits PASS, native Review/Complete and every-transition range READY. Real journal guard PASS; no host alarms. Exact original Gate record package/successor/GATE1-WS030-DELEGATED.md was created before original changes. Read-only original preflight84ba668 predicted exact matching full recipe85AEFDB62133D991009101B76B633C213D3988AD64EBB72EFBBF0D78F79C3997 and fingerprint1C439DD99A636A174F37A909E7B76F65700CC2B40D5BB044BBD237A105DDBE56. Proceed with separately admitted original cancellation/allocation/root-proof-bound approval/Begin/Execute, then one own fresh original full Finish/live Review/Complete/range. No original certification or release yet. Preserve every old attempt independently; no mixed receipt, blind retry or waiver. Later release/Step3/Lift/disposal gates stand. Evidence: records/WS-029/package/successor.
   ## D45 2026-10-28 Delegated WS030 main promotion verified; explicit Step3 hold retained
   After the owner's resumed "continue", release-only execution resumed under OWNER-DELEGATION.md section3 SHA25694631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217. The preceding explicit instruction "don't begin Step 3 recovery proof" remains binding. No Step3 package, cloud-recall proof, launcher, task modification, cleanup or Lift was started. Original WS029 remains separately Cancelled; frozen V3 and every prior attempt remain preserved.
   WS030 b2ad3546f37882af8d836e5e485e9b8b7e8c89bb passed fresh exact-hosted readback (run40700626312 attempt1, required check/app15368 and actual Verify SUCCESS), unchanged trusted pin and all11 native range transitions; prior local sandbox/original completion and scan/privacy evidence hashes matched. Exact DELEGATED-PROMOTION.txt preceded dispatch. Fresh native Shehabhub credential identity, remote main751c324/preflightb2ad354 and active ruleset25827491 required-check conditions passed. ONE ordinary non-force fast-forward main push exited0 at2026-10-28T17:26:01.9140898Z, no retry/settings/account/protection change or trust advancement.
   Independent connector ref/check readback plus direct git ls-remote prove main and preflight=b2ad3546; direct effective-rule readback proves active deletion/NFF/strict workbench-acceptance/app15368 protection, with no server bypass warning. The connector effective-rules endpoint was unavailable, so its supported native CLI read was used; no mutation bypass. This is observed release/promotion evidence, not invented native REMOTE_CERTIFY output (Workbench has no proven native certification interface). CTRL19 OPEN and security causal proof not re-earned; historical Watch-Reminder cause/fix still UNPROVEN. Exact receipt and all evidence hashes: records/WS-029/package/successor/release/RELEASE-RECEIPT.json. Stop after continuity save with Step3 on owner hold.
   ## D46 2026-10-28 Owner resumes Step3; R2 same-machine launcher proof PASS, first failure preserved
   Owner directly instructed "continue to start step 3", lifting the earlier Step3 hold for this proof. Frozen old acceptance8A49C184 remains unchanged; dated successor-subject binding names released WS030 b2ad3546 rather than falsely completing cancelled WS029. Existing conditional delegation and D43 apply; no native gate or observation waived.
   One native fresh package114306857bytes SHA2567217C59D21D5720A4BAE5A8ACFA776A4B177418107B870D408BB8FC96D7B6C47 was made with current explicit recovery-input map, exact released launchers, native exit0. Established OneDrive offload/recall proof: actual offline/recall attrs5248544 before full-byte read, hydrated1056 after, hash/length identical, repinned525344. File-only scan reports7873 findings by names/rules/lines, no secret-absence or bundle-history scan claim.
   First real launcher at attempt20261028T174627Z is FAILED and preserved: controller ReadAllText sharing failure was observed; native pre-extraction Get-FileHash absence reproduced under inherited Core module path; actual terminal native exit was lost/unproven. No staging/target was created; owned isolated checklist cache retained. Original task XML/enabled state restored exactly. No retroactive pass or hidden retry. Open-writer causal control and exact released read-only pre-extraction probes prove the ReadWrite-shared reader and native Windows child module-path remedies; no source or workstation setting changed. Stale7zip plan path preflight refusal also retained, corrected to the existing shim before invocation.
   Explicit R2 replacement used fresh empty roots and the SAME immutable fresh cloud-proven archive, preserving first failure separately. Exactly one actual released.cmd invocation in R2 exited0, final READY, staging retained; pause input only after actual prompt. Full real map task XML hash7CC05E69E048B8A3B2242382D9D8AFC29E1DCB69F24EE2C1649E0F0CDA27AC20 before/after identical, enabled true. Independent2555-file extracted manifest/inventory, six restored HEAD/ref/clean checks, all10 recovery inputs, exact source map, three memory junctions with55/32/9 matching files inclhidden, three ACTUAL Boots exit0/READY and six original tracked/config/index/proof/ref/profile protections all PASS. Native temporary actionlint provisioning is verified; no workstation installs, product preparation, account login or cleanup. Supplemental filename-only nested-manifest counting error corrected transparently to root-only exclusion, no recovery rerun.
   Bounded verdict PASS amended SAME-MACHINE launcher criterion, not clean-machine installation, post-stop-packet coverage, CTRL19 closure, earned Shared Evidence, Lift or disposal. Sensitive staging and all attempts retained. Terminal evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-029\package\successor\step3\attempt-20261028T180229Z-r2\result.json . Next programme unit WS026; no later work or Lift performed by this proof.
   ## D47 2026-10-28 Owner directs WS026 continuation without waiting for Claude quota
   Owner directly: "you can do it now and don't wait claude to re charge - don't skip anything and continue" after the quota blocker report. Scoped execution interpretation disclosed before proceeding: Codex replaces unavailable Claude roles FOR THIS WS026 SEGMENT, with latest verified Sol/xhigh; Terra/xhigh remains restricted live research. Prototype, separate fresh V1/V2/V3, two distinct reviewer sessions with agreement/rebuttal, max one V4, focused checks/mutants, exact delegated admission, independent sandbox/original Finish/Review/Complete, trusted carrying-range and qualified release all remain. No stage or mandatory security/native gate waived. Same-provider session independence is stated accurately; no fictitious Claude/cross-provider review. Standing D38 roles for other units are not silently changed. No quota/account/auth/config workaround, recursive delegation, exfiltration-risk acceptance, elevated sandbox, historical evidence change, cleanup or Lift. D38/D40/D41 stand except the named WS026 author substitution. Prior Claude weekly-limit failure and generated edits stay separately preserved. Exact direction/interpretation: records/WS-026/package/OWNER-CONTINUE-WITHOUT-CLAUDE.md, SHA256 63DE2676F987826139E31CB25FD79C4AC7E45109EFB873282EEFE97890C26982.
   ## D48 2026-10-29 DELEGATED one bounded WS026 V3 continuation after owner directs choosing the best solution
   Owner replied to the explicit V3-continuation/native-V4-admission choice: "Learn from your mistakes, the difficulties you have encountered, potential gaps, and the failures you have experienced. Always follow our principles: learn before guessing, apply the "earn it & worth it" rule, simplify without diluting, and choose the best solutions." This is a direction to exercise judgment under existing conditional delegation, not a verbatim option selection or exact-Draft approval. DELEGATED choice disclosed before authoring: ONE fresh Sol/xhigh V3-R2 evidence-refresh continuation at a distinct path/ID, retaining frozen rejected V3 B3B47C1A36E5F8DC502D674DF3012A92BE482C828CD9E3A67341B182A937430C, its two REVISE reviews and every actual probe. Native selected V3 truthfully names the completed evidence-refresh phase under this explicit scoped disposition; no hidden V4 relabel, overwritten artifact or checker change.
   This consumes the sole corrective round instead of an additional V4; remaining material disagreement goes to owner, no further loop/V5. Reproduce/fix the native item.type defect within existing Delegate/test-delegate scope, complete corrected baseline/remaining retained targeted mutants/new-validation mutant/literal controls and TWO fresh same-candidate reviews with agreement/rebuttal. All existing native admission/root/output/evaluator/sandbox/original Finish/Review/Complete/range and qualified release gates remain. No source-scope expansion, weakened assertion, privilege/config/account change, automatic retry, research-risk reacceptance, cleanup or Lift. D47 stays WS026-specific. Exact reply, interpretation and reasons: records/WS-026/package/v3/OWNER-CHOOSE-BEST-20261029.md SHA256 ADA90701DA0FC6C6D0C7EEF2D2E8ACE979278341C04855B428EB9A026FDA4ABA. This narrowly resolves the current phase-continuation ambiguity; it is not a standing pipeline rewrite or future technical acceptance.

   ## D49 2026-10-29 DELEGATED exact WS026 sandbox admission, no original authority
   Exact frozen V3-R2 SHA256 29C1F472CE62126D3E1689B7A6DD9539E6F72C7FE1D6EB947AF9A21F2659A454, physical sandbox C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W26\sb\s, baseline b2ad3546f37882af8d836e5e485e9b8b7e8c89bb, Gate record records/WS-026/package/GATE1-WS026-SANDBOX-DELEGATED.md SHA256 FBC05A4059E17B8F6528749565405FC7DA95458BA45E10DCF83638906852E0B1. Under the existing conditional delegation and D47/D48, source correction remains bounded; full-source BLOCK coverage findings resolved by two fresh evidence rebuttal ACCEPTs with all reports preserved. Root5 checks/2 consumer suites/literal controls/47 meaningful semantic comparisons over17 mapped rows pass; failed author transport after complete artifact and every unproven attempt remain distinct. Genuine six-root before-state and666 prior evidence files verified before sandbox creation. Proceed only native sandbox allocation/approval/Begin/Execute/one own Finish/independent audits/Review/Complete/range. No original write/approval, transplanted receipt, publication, production F6 acceptance, destructive cleanup or Lift. All native gates and ordinary hooks remain.

   ## D50 2026-10-29 DELEGATED exact WS026 original admission after sandbox Complete
   Exact Draft 29C1F472CE62126D3E1689B7A6DD9539E6F72C7FE1D6EB947AF9A21F2659A454, physical original C:\Users\My Lab\Documents\GitHub\ORVION-Workbench, baseline b2ad3546f37882af8d836e5e485e9b8b7e8c89bb. Separate approval C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-026\package\GATE1-WS026-ORIGINAL-DELEGATED.md SHA256 79DA8CFD5D195B88F7D605672DA82873BF5777B0BAAA2A3FE790FD8363DED0AB, immutable sandbox proof C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-026\package\runtime\sandbox\own-finish-receipt.json SHA256 798E2178A8F6B55A6ABF66B2846329409C3072B7EB3C516460B7942F2981814F, sandbox Complete c1a75f5ccce4c96589136fb1138c132d7ea04cdc and whole carrying range READY. Read-only original preflight predicts exact matching recipe/fingerprint and literal plan. Existing OWNER-DELEGATION/D47/D48 authority applies, honestly DELEGATED, no routine reapproval. Original own lifecycle/one Finish/independent audits/Review/Complete/range and later qualified release remain mandatory. No live research permission, F6 waiver, trust advancement, scope/settings change, cleanup or Lift. Before original writes, supplemental full40 identity audit resolved prior one-character head report from genuinely retained full refs/rawHEAD; Codex-managed turn-diffs ref drift recorded explicitly, never reported allrefs unchanged. Original baseline and prior report preserved, no backfill or Finish rerun. Evidence: records/WS-026/package/runtime/sandbox/protected-head-supplement.json and original/preflight.json.

   ## D51 2026-10-29 DELEGATED exact WS026 preflight publication, conditional fresh dispatch gates
   Candidate 200c3a1b9bb87550de6520f886c53eb8242fd55b, expected main/preflight b2ad3546f37882af8d836e5e485e9b8b7e8c89bb, ONE ordinary non-force push to refs/heads/workbench-preflight. Existing OWNER-DELEGATION exact authority94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217; no human-typed digest fiction. Separate sandbox/original own Finish27 suites/exits0, native Review Complete and full6-transition independently pinned trusted range READY. Both receipts and immutable proof binding retained. Source/public privacy classification reviewed13 distinct blobs, exact path metadata/generic comment only; all6-transition redacted gitleaks0. Exact publication record records/WS-026/package/release/DELEGATED-PUBLICATION.txt SHA256 1D8AB0C50BAFEEC1D5D174A5D2CAF56F7BBE9F27B7341A2677B991ECEB102B20. Dispatch must freshly verify actorShehabhub/ref ancestry/normal hook/active required check and exact refs; failure stops. No main promotion, rerun, trust/settings change, F6 acceptance, Lift or cleanup. Hosted success required on exact subject before separate promotion qualification.

   ## D52 2026-10-29 Exact qualified WS026 main promotion and save only
   Owner directly instructed: just qualified main promotion to finish WS-026's release and save. Exact candidate 200c3a1b9bb87550de6520f886c53eb8242fd55b, expected main b2ad3546f37882af8d836e5e485e9b8b7e8c89bb/preflight 200c3a1b9bb87550de6520f886c53eb8242fd55b. Existing conditional OWNER-DELEGATION section3 applies, explicit DELEGATED operational record release/DELEGATED-PROMOTION.txt SHA256 E3F5D5377B44CD54390A064CBD76A2ABE9E3C4743FDF4CCDE08D2A8FAE9A5907, not a newly human-typed hash. One ordinary non-force fast-forward to refs/heads/main only after fresh Shehabhub identity/normal hooks/exactrefs/ancestry/active strict ruleset25827491 no bypass and exact hosted40893277917 attempt1/app15368SUCCESS/trusted six-transition range. Separate local receipts and all failed/unproven evidence retained. Fresh remote/check/protection readback and continuity save required; STOP after WS026 release/save. No WS027, settings/trust advancement, reruns, new proof, Lift or cleanup.

   ## D53 2026-10-29 WS026 qualified main promotion verified; stop after save
   One authorized ordinary non-force Shehabhub push promoted main from b2ad3546f37882af8d836e5e485e9b8b7e8c89bb to exact 200c3a1b9bb87550de6520f886c53eb8242fd55b, exit0, no timeout/server bypass warning; no second push or rerun. Independent Git and API readback main/preflight both200c3a1b9bb87550de6520f886c53eb8242fd55b; exact required app15368workbench-acceptanceSUCCESS, ruleset25827491 active/strict/no bypass actors, trusted d2e352e unchanged and originalclean. First post-promotion default-account read omitted bypass_actors; incomplete observation/raw response retained, then bounded same-Shehabhub authenticated read established explicit empty array. No missing-field waiver or settings/account change. Release receipt records/WS-026/package/release/RELEASE-RECEIPT.json SHA256 6E91927724E6BDD68D0A4E94B5CC7265496ED585B7A120CC45D1023525D7ABFA retains local/native/trusted/hosted/promotion evidence separately. WS026 RELEASED; user requested only this promotion and save. Refresh canonical checkpoint and existing continuity mirrors, then STOP. WS027/WS028/Batch6/Lift/cleanup/new research proof not started; CTRL19OPEN and clean-machine recoveryUNPROVEN remain.

   ## D54 2026-10-29 DELEGATED bounded WS031 launcher-compatibility bootstrap for WS027
   Owner replied to the specific extension question with principles and choose the best solutions, not literal prewritten option approval. Interpretation disclosed before action: minimum owning corrective WS031 and ONE separately pinned disposable bootstrap, original/released WS026 untouched, every author/review/native gate retained. Exact reply/scope at records/WS-031/package/D54-OWNER-CHOICE.md SHA256 6BFC7D6744A58E6125E64FDC5A7EECF419D6A42A0D6787734F721E6D510C1053. Proposal SHA256BE65CD50A5F88F4898D17653F282BE64ADEF64C3AD373DA2BA5D62A94D1D5C18. Installed feature-list consumer exits2 on exec-only ignore-user-config. Preserve actual before/new evidence, validate empty feature-only home/no auth copy/retained exec isolation before model work. No routine Gate approval fiction, no original source approval, D47 role generalization, live-research/F6 waiver, privilege/config/trust/schedule change, cleanup or Lift. Complete WS027 remains objective; research tool/read qualification separate.

   ## D55 2026-10-29 DELEGATED WS031-only Sol author substitution after actual Claude refusal
   One Claude qualifier API429/seven-day limit before any child/tokens/source, failure retained; no retry or workaround. Under prior direct owner no-wait-Claude instruction and latest choose-best direction, new bounded DELEGATED choice at records/WS-031/package/D55-AUTHOR-SUBSTITUTION-CHOICE.md SHA256 FFCBE3F1186FFE93A39F57884580C8E6FE07F3F20F86224376BDAE5C328E45B2: separate fresh Sol/xhigh Prototype/V1/V2/V3 and two same-candidate independent reviewer sessions/agreement/rebuttal, sole correction limit, every native gate. No fictitious Claude/cross-provider claim; old bootstrap-only ACCEPT is not a formal stage. D47 itself not generalized; no standing later-unit role override, new live research/F6 acceptance, original/source/release authority, privilege/config/trust change or cleanup. Bootstrap actual native/synthetic-model transport and123 unchanged assertions pass, one real Sol/xhigh bootstrap-only review ACCEPT corroborated by runtime; native certification absent.

   ## D56 2026-10-30 DELEGATED exact WS031 sandbox admission, original authority withheld
   Recorded now from the preserved decision that existed BEFORE allocation/implementation: GATE1-WS031-SANDBOX-DELEGATED.md SHA256 C922622A953CEFBBB4C9DD9F3E88AADAA7604F9F49C9553E52C29E633CC38B82. OWNER-DELEGATION SHA94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217 and WS031-only D54/D55; honest DELEGATED, not a newly human-typed hash. Exact Draft656A92C8A81779EFAC91B9D1CA766EABD18B7D1083D97B52E4C9255FBC370F77, physical sandbox C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W31\sb\s, base200c3a1b9bb87550de6520f886c53eb8242fd55b. Distinct actual stages/two fresh same-subject ACCEPT reviews and bounded source/literal/mutant evidence qualified; genuine six-root BEFORE captured. Only relay/test-delegate/libREADME, own contract and native pointer. Every native gate retained; no original/release/research/F6/settings/trust/cleanup authority derived from bootstrap or this sandbox record.

   ## D57 2026-10-30 DELEGATED exact WS031 original admission after sandbox Complete
   Recorded now from preserved ORIGINAL decision that existed BEFORE original allocation/implementation: GATE1-WS031-ORIGINAL-DELEGATED.md SHA256 28E40260B221C4C1F5EB6B7FC6360AFE1C3BCB7348F00D1EF27F0F00B95EC96B. Same selected Draft, original C:\Users\My Lab\Documents\GitHub\ORVION-Workbench, base200c3a1. Completed sandbox HEADb5f570cbfde1c6be059a82cf47fbc6d46bcafcf0, receipt7DF0195FCB14D64F524C796448E77352E885792DEB32B7364D193EBA371BDFC5, immutable exportSHAC95FF88794B58BDB09134156D838C1C29C72E00EC384E18A91E4B4D893BC99B7. Separate root-bound conditional OWNER-DELEGATION admission, not transplantation/certification of original. Fresh actual six-root original BEFORE and accepted three-output Preview plan, predicted recipe/fingerprint and native sandbox-proof checks passed before writes. All original native gates, own Finish and qualified release retained; no additional role/security exception.

   ## D58 2026-10-30 WS031 independent sandbox and original native completion verified, release pending
   Actual local Complete HEAD4173639609f3f762bf9f47dd034d2df65d0a0ddd, clean/activeNone, six linear transitions from200c3a1. Sandbox own27 suite23.9min and original own27 suite29.8min, each timed runner/watcher/host0/0/0 and real journal unchanged; no duplicate suite or borrowed receipt. Own original receipt477AAA5AAD05E135A42ADFB0167F4251186E8B3253A39D9A472501271E423C24, exportSHA3170B7B055A8FEAE7390753EF82DF8CC9F709F8AF919320684F1DB1A701B0E5D, binds sandbox7DF0195FCB14D64F524C796448E77352E885792DEB32B7364D193EBA371BDFC5; shared recipe7F804FAC71116A2943D4A561E57E7AA14852DDAF4E79AB51F8EDE58AFC984EF2 and fingerprint3454E3B57341FB70797625D19C3625ECAE75D0220218E9964C5204F4AB224DF3. Independent role-specific protected-root/666 recovery-file/744 WS026-file audits, native Review/Complete and accepted carrying ranges READY. Current root HEAD4173639609f3f762bf9f47dd034d2df65d0a0ddd is LOCAL COMPLETE, not yet published/released. Trusted d2e352e unadvanced. Research controls remain separately unqualified; old failed attempts retained. Parent WS027 not implemented; WS028/final packet/owner Lift/Batch6 still later. Publication requires fresh separate exact actor/ref/privacy/protection/trusted admission and hosted acceptance before main promotion; no reuse of D52's WS026-only push authority. CTRL19OPEN; clean-machine recoveryUNPROVEN; sensitive staging retained; Lift/destructive cleanup owner-controlled.
   ## D59 2026-10-30 DELEGATED exact WS031 preflight publication, conditional fresh dispatch gates
   Exact candidate4173639609f3f762bf9f47dd034d2df65d0a0ddd, expected main/preflight200c3a1b9bb87550de6520f886c53eb8242fd55b, refs/heads/workbench-preflight only. OWNER-DELEGATION section3; release/DELEGATED-PUBLICATION.txt SHA256 EEE9B2D3CD373BD43B9DAFCDC06E5E5E3E5AD37E53A22B6F80E8282352CC01F8, honest DELEGATED. Both native roots Complete and accepted trusted six-transition range; gitleaks changed-range0, bounded metadata references classified, source clean/activeNone. ONE ordinary non-force Shehabhub push only after fresh actor/destination/ref/ancestry/active protection checks. Hosted success not yet earned; no main promotion, rerun, trust/settings change, F6, Lift or cleanup. Failure stops, no automatic retry.

   ## D60 2026-10-30 DELEGATED exact WS031 qualified main promotion
   Existing OWNER-DELEGATION section3 SHA25694631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217 and current resume authorize the scoped release. Candidate4173639609f3f762bf9f47dd034d2df65d0a0ddd; expected main200c3a1b9bb87550de6520f886c53eb8242fd55b/preflight4173639609f3f762bf9f47dd034d2df65d0a0ddd; actorShehabhub/refs/heads/main. Hosted40974276466 attempt1 actual push SUCCESS, unique required check123798332233/app15368 and Verify SUCCESS, sealed independently. Separate native root receipts/Complete, trusted six-transition range and bounded privacy qualification preserved. ONE ordinary non-force fast-forward conditionally admitted only after fresh actor/ref/ancestry/normal-hooks/active strict ruleset25827491/explicit empty bypass-array/native admission. Exact operational approval at records/WS-031/package/release/DELEGATED-PROMOTION.txt, SHA256B702B15A79CD7354E4FA2CEB81C248CDDFC542728B888302C334BC8D6774711B. Honest DELEGATED, not a newly human-typed digest; no D59 reuse or old WS026 hosted-run substitution. Remote/check/protection readback and complete release receipt mandatory. Failure or ambiguity stops without retry; no rerun/settings/trust/F6 waiver/WS027 role substitution/Lift/cleanup.
   ## D61 2026-10-30 Owner explicitly authorizes ONE minimum research-profile correction for WS027
   Owner answered: Authorize the scoped correction. Exact proposalSHA25659B781934DE23B501659344E95CA3F10FF4B275239F0677624EC559128A0FADE; records/WS-032/package/OWNER-AUTHORIZATION-D61.md SHA2569DE2554987F367DFE02D422C0ED51DA721F3B74612929A537E10B2CB61A33885 preserves question, answer and scope. Extends D54/D55 procedure to WS032 ONLY: pinned disposable bootstrap, Sol/xhigh roles while preserved Claude quota applies, separate actual Prototype/V1/V2/V3 and TWO fresh same-subject reviews, one material correction limit, every unchanged native gate. Baseline4173639609f3f762bf9f47dd034d2df65d0a0ddd; research-only fixed controls in relay/Delegate/owning test/catalogue, no new framework/global settings/privilege/trust change. Explicit PROCESS approval, not a final Draft/Gate1 digest or production F6 acceptance. Isolated synthetic qualification only; no live research before native owning correction and boundary protocol pass. If scope cannot sufficiently reduce exposure, stop with exact evidence; no blind retry, role generalization, backup-task implementation, Lift or cleanup. WS031 release remains complete and frozen.

   ## D62 2026-10-30 WS032 bounded stop recorded; owner holds V3/full Finish and requests continuity updates
   Execution record under D61, not new scope or risk acceptance. Frozen V1SHA25655893B19DC945657DE95FD13F821823D83E29393F0B0A2D4D19D0D8444A3DCAA retains six root checks/181 owningPASS/four-output literal controls; exact actual qualification wrapper5 rejects real Code Mode unavailable error when hostdisabled. Prototype's partial image/plugin reduction remains separate. Fresh actual Sol/xhigh V2 independently BLOCKED, unchanged four-file source; reportSHA2562FF2D322787963FA0593B6664C9D55A3E31FA7456C1F746AC676CBAAE3702A89. No supported in-scope remedy established, not universal impossibility. No V2 Draft fabricated or V3/native allocation/Gate/full Finish/original implementation/release/live research started. Bounded public/static policy lookup establishes no supported existing fixed-exec selective broker restriction; further environment/tool-control scope decision remains required, no guessed flag loop or error suppression.
   Owner directly instructed: continue but don't start V3 or a full Finish - and save before compact; also update the plan and the handoff. V3 and every full Finish are HELD across compaction until explicitly released; generic continue/model-selection preference is not hold release, broader environment authority or F6 waiver. Saved operational plan/handoff and exact boundary packet at records/WS-032/package, canonical work/RESUME-HERE.md; public programme/native authority remains unchanged. Existing D40/D41 model selection applies, latest verified compatible family/effort per task; D61 substitution remains unit-bound. Original clean4173639/activeNone, old releases/evidence preserved, archiver/unrelated workloads intact. Lift/destructive cleanup remain owner-controlled.
   ## D63 2026-10-30 Owner releases V3/full Finish hold; prerequisites unchanged
   Owner directly instructed: continue, start from V3 to Full Finish. This explicitly releases D62's hold. It supplies no error-gate waiver, F6 acceptance, corrected candidate or expansion beyond D61. Fresh read-only Boot READY/activeNone/PLAN and clean original4173639609f3f762bf9f47dd034d2df65d0a0ddd corroborated; no active WS032/timed Finish observed. Old archiver14724 was not observed; no unrelated process was stopped/restarted. Frozen V1 actual wrapper5 and independent V2 BLOCK remain unresolved. WORKFLOW requires named boundary/decision when necessary exposure cannot sufficiently reduce; D61 explicitly requires stop at the four-file limit. No V3/Finish on unchanged failed subject, allocation, source edits, research or scope expansion occurred. Owner boundary packet is concrete and retained; next permission must name bounded existing-client/hosting-policy feasibility metadata inspection, with no environment changes or live capability probes. Operational checkpoint/plan/handoff updated; historical evidence remains separate.
   ## D64 2026-10-30 Owner authorizes ONE bounded read-only hosting/tool-policy feasibility check
   Exact owner instruction: Authorize one bounded, read-only feasibility check of the existing client's supported hosting and tool-policy controls, using public documentation, non-secret metadata and synthetic task-owned data. Retain every mandatory gate. Any settings or implementation changes require a concrete scoped proposal.
   Completed evidence at records/WS-032/package/feasibility-20261030/AUTHORITY.json, VERDICT.md, SOURCES.json and parser-evidence. Official code-mode namespace exclusions/direct-only routing and app/MCP filters are recognized by installed0.164.0 strict config parser. Six parse-only cases: three accepted0, three deliberate unknown/type/nested refusals1; one actual startup metadata read0/requirements:null. No server/model/tool turn, live query/private-read/spawn or source/settings implementation requested. All seven CLI children terminal; frozen V1 pins unchanged/original clean4173639.
   Recognition is not enforcement; current direct/nested/private-read/search boundary remains UNPROVEN. One concrete isolated fixed namespace-routing catalog qualification is PROPOSED in SCOPED-QUALIFICATION-PROPOSAL.md, not authorized here. New source/config implementation or measurements beyond this read-only grant require that concrete scope. Existing failed V1/V2 remain separate; D63 hold release stands but is no error/F6/native gate waiver. No V3, Finish, native allocation, original implementation/release or live research. No new framework or repeated flag loop.
   ## D65 2026-10-30 Owner authorizes saved namespace trial and evidence-led continuation
   Owner directly replied to the concrete one-trial proposal approval request: i give you whatever authoriy you need but Learn from your mistakes, the difficulties you have encountered, potential gaps, and the failures you have experienced. Always follow our principles: learn before guessing, apply the earn it & worth it rule, simplify without diluting, and choose the best solutions.
   Interpretation disclosed before action: execute saved SCOPED-QUALIFICATION-PROPOSAL.md SHA256894A309293A0A3EA87B37E069E0DF48F7DD9FC393CADD095131F6D644FB6DB87; continue the existing roadmap where actual evidence supports owning native progression, no routine reapproval. Exact record at WS-032/package/namespace-trial/OWNER-AUTHORITY-D65.json. Four lib paths, distinct disabled-push candidate, fixed documented namespace hypothesis, meaningful deterministic/Windows argv controls before at most ONE actual no-action Terra catalog, all failure stop conditions and old subjects preserved. D63 hold released; D64 read-only work complete. No F6/runtime-error/native gate waiver, fabricated independence, live private-read/spawn query, repeated flag loop, unrelated security framework, global settings/install/account/privilege/trust change, uncontrolled resource consumption, Lift or destructive cleanup. If the exact trial fails, preserve its failure and do not rerun unchanged or broaden it silently. Original/source/publication still requires owning exact native authority and fresh release gates.
   ## D66 2026-10-30 D65 single namespace trial terminal: actual native error gate FAIL, partial routing evidence retained
   Execution result only, no new authority or waiver. ActualSol/xhigh namespace author01a18d05-f405-70d3-a83e-f85f664dfae3 native0/final109behavior-ASTPASS/105syntheticcases; first111-labelled attempt preserved with syntax-only label correction. NS01 owning231PASS/Markdown76PASS/WorkingPASS but native hazardFAIL reserved test variable event; Node/whitespace not reached. Separate NS01-R2 changes only two test variable references; all three policy consumers byte-identical, all six R2 checks0/owning231PASS/original78 and mandatory guards preserved. SourceManifestR2SHA256BB3443AD86863F391DAACE88ABA72FE14B8B813482E444356F1C3CD537197A52.
   ONE actualTerra/xhigh/read-only/never catalog01a18d23-65f1-7eb3-90ab-579a055515f9 ran14:07:48Z-14:08:06Z in W32-ns-cat-r2. Native wrapper5 correctly rejected item.completed/error Under-development features enabled: code_mode; raw relay/model completed0. Actual raw metadata now direct web.run/nested clock only, earlier explicit resource/patch/goal helpers removed from guidance; full generic/deferred inventory/private prevention/search use remain UNPROVEN. Tool/query/private/write/spawn actions0/tripwireunchanged; seven native artifact hashes verified. No suppression preference applied, no error whitelist or second trial. Exact evidence at WS-032/package/namespace-trial/TRIAL-VERDICT.md, NEXT-STEP.md, catalog-r2/ASSESSMENT.json.
   Private Where-Object spacing error corrected before dispatch and preserved; source unchanged, no runtime attempt spent by that helper fix. Known unified54126=0,72773=1,9407=0; catalog outer unified terminal exit uncollected, never invented; actual native5/raw0/process identities/logs/results independently retained and all native controllers terminal.
   D63 hold remains released, D65 broad authority recorded, but observed mandatory error stop and unproven operating boundary prevent V3/full Finish/native allocation/original implementation/release/live research. No complete supported gate-preserving operating remedy is qualified; next is exact owning startup-diagnostic requirement resolution and full boundary protocol, not another unchanged run. AGENTS stop rule applies. Original clean4173639/activeNone, old frozen/failed evidence preserved; no unrelated workload/config/install/trust change, Lift or cleanup. Plan/handoff/checkpoint saved.
   ## D67 2026-10-30 Owner continues exact WS032 diagnostic resolution and explicitly fixes roadmap
   Owner said continue, then: don't Go away form our plan roadmap - don't let any gap behaind - don't build anything far away from our standard plan. D65 needed authority persists; disclosed plan is WS032 prerequisite -> WS027 -> WS028 -> final stop packet -> owner Lift -> native Batch6, no new unit/framework/service/pipeline.
   One narrow pre-implementation proposal and fresh native Sol/xhigh critical review is prepared in WS-032/package/startup-diagnostic-review. Official Configuration Reference documents the exact unstable-feature warning preference; recognition/purpose is not enforcement or permission to suppress genuine errors. Review must decide whether fixed research-only preference plus explicit experimental-risk evidence and refusal of unexpected experimental features can preserve ALL emitted-error gates and authority. No code/profile/global config change or second actual catalog is authorized by this review record; no retroactive NS01 success, role rename or waiver. Four existing lib paths only if later admitted; unchanged native functions/guards and old failed subjects mandatory. Original clean4173639/activeNone; scope is current blocker, no WS027 backup code or downstream stages started.
   ## D68 2026-10-30 Owner defers WS032, approves WS027-only source-pack exception, then explicitly stops BEFORE WS027
   Owner explicitly approved WS032 outside the critical path, all evidence/failed gates/unqualified status preserved and unqualified live research disabled. Approved sequence: WS027 -> WS028 -> Final Stop Packet -> OWNER Lift -> native Batch6. For WS027 ONLY, previously proposed verified source-pack research exception with documented limits; no reduction of V3 assurance, independent reviews, native gates, governance, model assignments or mandatory acceptance. No new tooling research, architecture or unrelated improvements. Complete steps in order; stop at mandatory owner decisions; concise English reports.
   Latest direct instruction: Save & Stop when you arrivel to begen WS-27 - Don't begen WS-27 Right now. This expressly HOLDS the beginning of WS027 until a later owner resume. Source-pack verification/research, Prototype/Draft, coding, scheduling and native execution for WS027 have NOT begun under this decision. No downstream step or queued background launch.
   Exact owner text/scope at WS-027/package/owner-deferral-20261030/OWNER-DIRECTION.json. Prior D67 state was saved FIRST in the snapshot named by WS027/package/SAVE-FIRST-LATEST.txt, with11 verified copy comparisons. Deferral is a private programme disposition, not an invented native contract status, F6 acceptance or WS032 completion/certification. Existing author/provider roles remain; D61/D55 unit substitutions are not generalized. No unqualified live-research launch, source/settings change, warning suppression, new role, gate waiver, Lift or cleanup follows. Original remains clean4173639/activeNone. Update operational plan/handoff and Save-Continuity, then STOP at WS027 entry.
   ## D69 2026-10-30 Owner explicitly resumes WS027 after saved stop
   Owner: "Start WS-027". This lifts D68's save/stop at WS027 entry only. D68's WS027-only verified source-pack research exception applies; WS032 stays deferred, UNQUALIFIED and disabled for live research. All model assignments, assurance/native/owner gates, backup acceptance and sequential roadmap stay intact. Source verification: original clean4173639609f3f762bf9f47dd034d2df65d0a0ddd/BootREADY activeNone; eight source pins match prepass, two newly fetched Microsoft primary documents match saved content after newline normalization, existing map task XML captured without mutation. Evidence: WS027/package/source-pack-20261030/INPUT-MANIFEST.json.
   Apply the source-pack exception as an actual latest-compatible Terra/xhigh analysis of sanitized inline public source/document material, through unchanged released Delegate.ps1 engineering transport with hosted search OFF and no tools requested/authorized. This is explicitly source-pack analysis, not live RESEARCH profile/F6 qualification. No arbitrary override/relay patch/private input or search is introduced. Exposed capabilities and no-action observations must be reported separately; engineering D9 is not confinement, full inventory/prevention remains UNPROVEN. Native errors, unauthorized tool action/spawn or outside-write evidence stop the role, no retry or reinterpretation. Preserve actual model/effort, native records and output hashes. Then the existing Claude Prototype role, Sol V1/V2, Claude V3 and independent reviews remain; no WS031/WS032 substitute authority is borrowed. No original source write or real backup schedule before its owning exact Gate and proof. No WS028 start, Lift or cleanup.
   D69 execution result: attempted Terra/non-live engineering call refused before dispatch CODEX_MODEL_FAMILY_REFUSED requiresSol, controller1. Actual research phase NOT RUN. Fixed research transport mandates live search; not enabled. Owning transport-only proposal saved, unapplied; no silent override, new tooling research, role substitution or source correction. Originalclean4173639, no queued/live task. Source-pack verified preparation retained separately from failed transport.

   ## D70 2026-10-30 Owner explicitly authorizes ALL WS027 model roles as Sol/high
   Owner verbatim: you can prosses WS-027 all in Sol High. This expressly overrides D38/D40 provider assignments and D41 xhigh for WS027 ONLY, including source-pack analysis, Prototype, fresh V1/V2/V3, separate independent reviews and implementation/any already permitted corrective round. All roles use latest verified compatible Sol at high through unchanged released Delegate.ps1 engineering profile with hosted search disabled. Preserve every mandatory phase, fresh contexts, actual model/effort evidence, independent same-candidate reviews/agreement/rebuttal, sole corrective-round limit, exact delegated Gate, sandbox/original native lifecycle/Finish/Review/Complete/range and qualified release. Session independence is not cross-provider independence; no fictitious Claude/Terra authorship. The source-pack exception remains WS027-only; all backup acceptance/refusals/retention/scheduled proof remain. Exact owner statement and interpretation at WS027/package/OWNER-SOL-HIGH-D70.json.
   D69's refused Terra/non-live dispatch stays failed before model; its transport-only proposal is now superseded/unneeded, never applied. No alternate relay, launcher/source/config/privilege change or live research is necessary. No waiting for Claude quota. WS032 deferred/unqualified/evidence-preserved, unqualified live research disabled; WS028 has no implied author/effort or research exception. Roadmap WS027 -> WS028 -> Final Stop Packet -> OWNER Lift -> nativeBatch6, no skipped gates or cleanup.
   D70 continuation2026-10-30T18:19Z owner resume: prior Prototype thread01a18d88-a569-75d3-a2ba-9b26183ca0cb failed wrapper5/raw1 at usage limit8:16PM after TWO successful read-only commands and before authoring/tests, failure frozen. Current host/clientCairo20:19 is after that reported retry time (native message zone absent); ONE distinct fresh Prototype-R2 under continuing task/model authority, no account/setting workaround or V4 consumption. Fresh clone/native logs/results, every gate preserved; no source/task/fullFinish change by failed attempt.

   ## D71 2026-10-30 Owner requires save after every completion/pass, then continue
   Owner verbatim: make sure after every complet or pass you save what you did and continue. Apply to each completed phase and passed native/focused gate: retain raw outputs/exits/subject hashes, update exact live checkpoint, run existing Save-Continuity and verify static copies before proceeding. Active outputs remain labelled active, not frozen or certified. Native full Finish retains its own logs/receipts continuously; NEVER append the real event journal during native Finish, and avoid destabilizing it with extra heavy copy/scan work. Save that terminal gate before starting the next stage. No stop/restart/duplicate of active work or new source authority. D70 all WS027 Sol/high, D68 scope/sequence and every native gate remain unchanged.

   ## D72 2026-10-30 Owner: Claude takes over the Codex role until the Codex usage limit resets (WS027 V3)
   Owner verbatim: you can take over codex role until his usage limit on again. Applied to WS027 V3 only after Sol/high thread 01a18e41-8dea-74a2-bdbb-add44ebf3b41 stopped on the Codex usage limit after its own final-checks-01 PASS. Claude main (claude-opus-5-5) authored only NOTES.md, evidence/Build-Manifest.ps1 and SOURCE-MANIFEST.json from existing evidence; Sol bytes untouched. Frozen via one-condition variant v3/Freeze-Stage-D72.ps1 (only relaxation: usage-limit relay failure). V3 Draft SHA256 40C0E73C1851A4E47BF06558C7A2ED61E23501D06089A972C257F8B391FB619A. Every author is excluded from review.

   ## D73 2026-10-30 INTERIM owner rule: Codex usage limit -> assess and take over, do not wait (amended by D100: standing; Codex used again after its limit resets)
   Owner verbatim (summary of statement): "if it is discovered that Codex's reset has been exhausted, do not wait for reset his limit. Instead, assess the situation - one of your options should be to temporarily take over the task yourself, rather than waiting for Codex. Let's implement this rule now, on an interim basis, before formally incorporating it into the permanent governance framework - or until we find a model capable of matching Codex's level of effort... For now, please assume responsibility for the task using a sub-agent with the 'Opus' model, set to a 'high' effort level and continue."
   Interim until formally incorporated by a future WS or until a model matching Codex effort is designated. On Codex usage-limit exhaustion: assess; options include Claude temporarily taking over the Codex role instead of waiting. Preserve the failed Codex attempt, author/reviewer independence (fresh contexts; authors never review own subject), actual model/effort evidence, mandatory phases and every native gate. First application: WS027 V3 two independent same-candidate reviews by two fresh Claude Opus/high subagents (overrides D70 Sol/high for those two reviews only). Candidate for the ONE deferred model-allocation/delegation improvement WS; not yet permanent governance.

   ## D74 2026-10-30 Owner: ONE review suffices (WS027 V3) (superseded by D75)
   Owner verbatim: "You do not need two agents for the review. A single review from you is sufficient - be smart - why would you need two agents?!" Applied: reviewer B (fresh Opus/high) stopped unfinished, no output used; reviewer A (fresh Opus/high, same brief CDB7BA2D...A8AF, not an author) is the single review of frozen V3 40C0E73C...619A. Overrides WORKFLOW dual review for WS027 V3 only; native Gate/sandbox/original Finish/Review/Complete/release unchanged. Candidate for the deferred model-allocation/delegation WS.

   ## D75 2026-10-30 Owner WS027 Option 1 conditionally approved; dual Claude AND Codex review required (production-task/publication exclusion superseded for WS027 by D78)
   Owner: select Option 1 - preserve frozen V3 40C0E73C1851A4E47BF06558C7A2ED61E23501D06089A972C257F8B391FB619A, proceed toward Sandbox Gate without consuming V4; A-1..A-4 accepted as DOCUMENTED residual risks (A-4 daily-continuity/recovery impact to be carried in execution and Final Stop Packet records). Conditions: contract-required independent Claude AND Codex reviews of the same frozen V3 (Opus review A alone insufficient; this supersedes D74 for WS027 V3); retain sole V4 for material defects only; verify delegated Gate1 under OWNER-DELEGATION sec2 (precedents D49/D56 are not authority by themselves); native sandbox/Gate sequence exactly; Scheduler limited to the authorized temporary synthetic test task with ownership/isolation/behaviour/cleanup evidence; no production task or real backup publication; no weakened tests/suppressed failures/frozen-artifact change/unverified PASS. Stop on material finding, failed gate or missing authorization. WS028, deferred improvement WS and Batch6 untouched.
   Codex review: D70 Sol/high via unchanged Invoke-SolRole/Delegate after the usage-limit reset (2026-10-31 01:18 local); Claude review = v3-review/REVIEW-A.json (fresh Opus/high, not an author).

   ## D76 2026-10-30T20:52Z Owner: bypass Codex until its reset (WS027 V3 review precondition)
   Owner verbatim: "Do not wait for a Codex review or for a Codex Reset to become available; instead, bypass the Codex until its reset is reset."
   Applied: the D75 Codex-review precondition no longer blocks progress. Claude review A (fresh Opus/high, ACCEPT, 0 material) is the governing review for sandbox Gate1 now. The Codex review is DEFERRED, not waived: queued launch b0075cuka still fires after the reset (2026-10-30T23:20Z) on the same frozen V3, non-blocking and read-only. If it returns a material finding, stop at the next stage boundary and report (V4 retained). Under D72/D73 Claude continues covering Codex roles until reset. All other D75 conditions unchanged (sandbox synthetic task only, no production task/publication, no weakened tests/unverified PASS).

   ## D77 2026-10-30T22:0xZ Owner: bypass Codex from now until further notice; no repeated tests; no waiting
   Owner verbatim: "Bypass "Codex"—from now on and until further notice: Complete whatever tasks still need to be done, but do not repeat any tests, and do not wait for Codex."
   Applied: queued Codex V3 review launch (Claude task b0075cuka) stopped before it fired (no v3-review-codex/operation.json; brief retained unused). Codex roles are bypassed until the owner lifts this. For WS027 the frozen Draft's two-review wording (acceptance line 793, Review Gate line 804) is discharged by OWNER OVERRIDE D74/D76/D77 with the single independent review A (fresh Claude Opus/high, ACCEPT, 0 material) - recorded as an override, never as two reviews. No passed check is rerun. Native gates are not waived: lifecycle Review/Complete/range checks that read existing receipts still run. Production task/real publication remain unauthorized (D75).

   ## D78 2026-10-30T22:0xZ Owner: WS027 continue to the real repository (option a)
   Owner verbatim: "(a) Continue to the real repository". Options as presented: "(a) Continue to the real repository: allow the full Finish there, plus a real daily backup task and real backup runs, including one deliberate refusal."
   Applied: authorizes for WS027 ORIGINAL root only: one fresh original native full Finish (a different root's mandatory receipt, not a repeat of the sandbox check under D77), explicit -Install of the exact owned production daily backup task, representative real backup runs/publication to the reviewed destination, one controlled refusal with the reviewed input restored afterwards, and return to the reviewed daily definition. Supersedes D75's production-task/publication exclusion for these WS027 actions only. Codex stays bypassed (D77). No unrelated task/data touched; Lift/destructive cleanup remain owner-controlled.

   ## D79 2026-10-30T23:0xZ (01:0x Cairo) Owner: WS027 limit 60 min; autonomous run to the Batch 6 threshold (order amended by D96: WS-034 before the Owner Lift)
   Owner verbatim (1): "60 it seems good,"
   Owner verbatim (2): "I authorize you to proceed without interruption—bypassing the need for a "codex"—directly into one deferred improvement workstream, and to subsequently move past the "Owner Lift" phase.
   The plan shall be as follows:
   WS-027 → WS-028 → Final Stop Packet → one deferred improvement workstream → Owner Lift → Batch 6.
   Should you encounter any gaps or errors that can be easily fixed or resolved, please go ahead and address them—in line with our established principles—without needing to consult me. If you come across any critical, high-stakes decisions that cannot be bypassed, simply set them aside for me to review later; do not pause your work or wait for my input on these matters. Do not begin "Batch 6"—stop right at the threshold of "Batch 6." Ensure you save your progress as you go, and please do not wait for my responses, as I will be away for some time."
   Applied: WS027 production limit = 60 min (identical -Install, readback). New order: WS-027 -> WS-028 -> Final Stop Packet -> one deferred improvement WS -> Owner Lift -> STOP at Batch 6 threshold (Batch 6 not started). Codex stays bypassed (D77). Easily fixed gaps/errors are fixed under existing principles without consulting; critical/high-stakes items that cannot be bypassed are parked in a deferred-owner-decisions list and work continues around them. Not inferred: push/hosted release, credential/machine/GitHub-protection changes, destructive cleanup or deletion of owner data, reactivating WS-032 - these remain parked for the owner unless a written owner rule already authorizes them.
   ## D80 2026-10-31 WS-028 one V5 by Claude main (D31 item 7 exception)
   Owner's direct answer to the WS-028 V4 decision packet (V4 review REVISE, material R1b): "Authorize one V5, but Frist Save this check point and don't assign a new subagent for V5 but you do it by yourself".
   Applied: checkpoint saved before V5 (2026-10-31T07:58Z). Exactly ONE V5 for WS-028, authored by Claude main (not a subagent), fixing R1b at its root plus cheap minors; then one fresh independent review of frozen V5 as before (reviewer independent of every author). This is a one-time WS-028 exception to D31 item 7's V4 limit; no V6. If the V5 review is still materially REVISE, it returns to the owner. Codex stays bypassed (D77/D79).
   ## D81 2026-10-31 Claude subagent effort: medium
   Owner's direct instruction: "if you assign a claude subagent - assign him with only medium effort".
   Applied from now: every Claude subagent Claude main assigns (authoring, adversarial, review, research) runs at effort medium. This overrides, for Claude subagents only, the highest/xhigh effort rule of D39 and D41; Codex effort and the native gates are unchanged. Not retroactive: the WS-028 V5 review launched 2026-10-31 10:31Z at xhigh before this instruction keeps running and is recorded as xhigh.
   D81 addendum 2026-10-31 12:35 Cairo: owner added "no more xhigh subagent". The running xhigh V5 review was stopped unfinished (transcript kept: records/WS-028/package/v5-review/stopped-xhigh-review.transcript.jsonl; brief copy BRIEF.stopped-xhigh.md) and ONE fresh medium-effort reviewer was launched with the same brief (write area cx\W28-review-v5m). Only the medium review counts as the V5 review.

   ## D82 2026-10-31 WS-028 one V6 by Claude main; Codex model and effort rule
   Owner's answers: to the WS-028 V5 decision packet (V5 review REVISE, material R1c) "One V6, fix whole class (Recommended)"; and "every codex subagent will be the last upgrade from Sol 6 model and with high effort".
   Applied: (1) Exactly ONE V6 for WS-028, authored by Claude main (no subagent author), closing the truncated-path class by construction (any character the path match stops at that a file name may hold, not a list), with tests, then one fresh medium-effort review (D81). A material REVISE on V6 returns to the owner. (2) Whenever a Codex worker is used, it runs the latest verified upgrade of the Sol 6 model at effort high. Codex stays bypassed under D77/D79 until the owner lifts that; this rule sets model and effort for when Codex is used again.
   ## D83 2026-10-31 Owner directive: ONE consolidated improvement workstream after WS-028 (Codex model and effort amended by D98: every Codex run)
   Owner directive "ORVION — Owner Authorization for One Consolidated Improvement Workstream", saved verbatim at records/owner-directive-20261031-improvement-ws/DIRECTIVE.md (SHA256 E58EC467F29CDDA0F9C749A39807E760CDC1BCD9CD0607630036C2C925D29C4F).
   Activation: immediately after WS-028 is completed, verified and preserved, and after the Final Stop Packet baseline is prepared. It designates the ONE deferred improvement workstream of D79: documentation reconciliation with anti-accumulation checks, an independent Owner-Tools ai-map (Owner-Tools + Workbench-temporary roots) via existing Map-Repos, Spider coverage of both roots, Brief/auto-loaded context optimization, and consolidated model/effort governance. Codex bypass (D77) is lifted for that workstream where Codex is verified available: latest verified Sol-family model at effort high (matches D82). Claude Main and Claude subagents: existing default model/effort behaviour, no hardcoded effort; from activation this applies instead of D81's medium rule. Until activation, D80-D82 govern WS-028 (V6 by Claude main; its one review at medium per D81). Mutable operational instructions are updated in place; historical entries stay verbatim. Batch 6 not started; native gates, tests, evidence and security boundaries unchanged.
   ## D84 2026-10-31 WS-028 one V7 by Claude main with a stop rule
   Owner's answer to the WS-028 V6 decision packet (V6 review REVISE, material R1d: a target-only accepted break was checked before the continuation guard): "V7 fix + stop rule (Recommended)".
   Applied: exactly ONE V7 by Claude main (no subagent author): the continuation guard runs before the accepted-break lookup for LIVE and HISTORICAL edges, plus a test; then one fresh medium review (D81). Stop rule: if that review finds only another C1 edge case, it is recorded as a disclosed residual and WS-028 proceeds through Gate/sandbox/original anyway; before any real C1 run that informs deletion, the owner-reviewed inputs and cited paths get a manual check. A defect outside C1 edge cases (C2, Finish consumer, a gate, a security finding) still stops and returns to the owner.
   ## D85 2026-10-31 Temporary: no subagents, Claude main does the work (amended by D100: standing for the prototype, V3 and reviews)
   Owner's direct instruction: "if you now everneed a subagent - don't asign one but do it by yourself temprory".
   Applied until the owner says otherwise: Claude main assigns no subagent; every role that would have gone to one (author, adversarial, review, research) is done by Claude main itself. Where a rule asks for an independent reviewer, the work is labelled honestly as a Claude-main self-review under D85, never as independent; this is an owner override, not independence. The WS-028 V7 review (D84) is therefore a Claude-main self-review, and the D84 stop rule applies to it. Native gates, tests and evidence rules are unchanged.
   ## D86 2026-10-31 WS-028 Finish launch: drop the 8 GB commit buffer
   Owner's direct instruction (14:0x Cairo, free commit 7.83 GB): "bypass 8 GB role - acctuly its not right at all to be 8GB".
   Applied: the task-local 8 GB free-commit launch buffer in the WS-028 Run-SandboxFinish.ps1 and Run-OriginalFinish.ps1 is removed; the commit floor is the native Draft minimum (3 GB, still enforced by Assert-WorkbenchContextRuntime -ResourceCheck). The 5 GB physical launch buffer, the native minima, the one-Finish rule and every test are unchanged. The measured headroom is still recorded in launch-resources.json.
   ## D87 2026-10-31 D83 plan refined by the owner: one router, one state, one save method
   Owner's instruction (about 15:30 Cairo), saved verbatim at records/owner-directive-20261031-improvement-ws/OWNER-REFINEMENT-20261031.md (SHA256 0D7524D862E20CF0ABBA4BBBB162240F4EF55E4F3119B07064C0EEC5AE6A36C6), with two follow-ups: reuse existing measurements instead of measuring again, and "the key, frequently consulted documents contain numerous sections, lines, and decisions that are contradictory, conflicting, redundant, outdated, and disorganized ... the decisions file being a prime example".
   Applied: Claude main wrote records/owner-directive-20261031-improvement-ws/PLAN.md (SHA256 1EAE32F8246FDD0D5842604245208191ED58B4AAB5A103C3213103866B1BE998) with baseline MEASUREMENTS-20261031.txt: ONE workstream, WS-033. For future workstreams: (1) V1 and V2 run in one Codex session (V1 frozen and hashed first); (2) Prototype, V3 and the V3 review are done by Claude main in its own session, the review labelled a Claude-main self-review and never independent, with a recommended Codex review of frozen V3 in the V1/V2 session; (3) state is saved after every operation and the owner then gets the /compact line and the resume message; (4) one router file, ORVION-Workbench/README.md, for humans and agents; (5) orphaned and legacy files are merged or deleted: tracked documents through the contract, local work files after a verified archive copy, disposable and legacy folders only after evidence is preserved, a C1 readiness pass (D84 manual check) and one owner confirmation of the exact list; evidence records are never deleted (D83 limit); (6) one save and record method for every agent; (7) existing data is reused before measuring or researching again; (8) decisions get a status index and an active rules file, and this decision file stays a frozen archive whose text is never edited. Points (1) and (2) change the fresh-session-per-phase practice of D32 and the subagent roles of D38 for future workstreams. D85 stays in force (no subagents). Native gates, tests and evidence rules are unchanged.
   ## D88 2026-10-31 Owner authority to restructure the three folders; organizer in every folder; indexed archive
   Owner's messages (about 15:55-16:45 Cairo), saved verbatim at records/owner-directive-20261031-improvement-ws/OWNER-AUTHORITY-20261031.md (SHA256 DF1714F323FBC2EBDF0D8B68F768ADE7B129C5C6B03FC8739123FA38AFDABD75), including "I grant you the authority to take whatever actions you deem necessary", "every folder should have an index or an \"organizer\" at its root", "move such items to a dedicated \"historical archive\" folder ... with its own index", "every file, every folder, and every section ... adhere to the principles of the repository: Learn first & Earn it & worth it & Simplify without weakness", and the three folders: ORVION-Workbench, ORVION-Owner-Tools, ORVION-Workbench-temporary (not CRM or ORVION).
   Applied: Claude main wrote PLAN.md v2 (SHA256 64B7426FAD02CF0FA763D770B2C9B9FAB9B64C3FDA566D0387C82ADE2BAA4D45), STANDARD.md (SHA256 E5599CE732F00415AC89773EFF4AAF65258C7D2BD3FE435335E2EF84DDC9111B) and MIGRATION-MAP.md (SHA256 8A001F307FC0240564B40DED17668C066E20B3902F1077FDFA15D12FB53E4035) from INVENTORY-20261031.txt (SHA256 CEC43FB6F404698C1BEB7E55244E4FAE40A3B110E6FF3E7D35F7041C6C51C550); PLAN.v1.md is kept. Still ONE workstream, WS-033. Every managed folder gets a README.md organizer; folders are created, moved, archived and deleted only through one tool; replaced decisions and obsolete text move verbatim to an indexed archive in the same root (public: docs/history; private: Owner-Tools/archive); D87 point (8) is refined accordingly: the decision file moves into the archive and is split into one file per decision, its text unchanged. Deletion authority: disposable items of completed workstreams, empty logs and exact duplicates are deleted after the tool's gates pass (workstream Complete, evidence hash-checked, not pinned, not named by an active file), without a further question; evidence, records, sessions, events and decision text are never deleted. D85 stays in force. Native gates, tests and evidence rules are unchanged; Batch 6 is not started.
   ## D89 2026-10-31 Owner prefers two folders: one on GitHub, one temporary
   Owner's message (about 16:50 Cairo), saved verbatim at records/owner-directive-20261031-improvement-ws/OWNER-TWO-FOLDERS-20261031.md (SHA256 3E4DE13AD19430B4843531036A1C66ED40B72576D05EFEE636283B8CB7BE7A33): "I would have preferred to have only two folders: One, hosted on GitHub, kept constantly updated and lightweight, containing only essential files ... regardless of the sensitivity or security risks ... The other, a temporary folder to be deleted manually".
   Applied: WS-033's target becomes two working folders (the GitHub repo and the temporary folder), with the existing OneDrive backup vault kept for backups and full evidence archives; ORVION-Owner-Tools is folded into them. Open owner question before any sensitive file moves into Git: the repo is public and protected by the active ruleset "Workbench Main Protection"; making it private on GitHub Free would drop that ruleset. Until the owner answers, nothing sensitive is committed, nothing is pushed, and Owner-Tools stays in place. Secrets are never committed under any answer.
   ## D90 2026-10-31 Owner answers: GitHub repo stays public with all governance; push once per workstream
   Owner's answers to two questions (about 17:00 Cairo). Repo privacy: "Keep public, publish all" (option text shown: "Sensitive governance becomes public permanently (it can be cached even if deleted later). Secrets are still never committed. Not recommended."). Pushing: "Push per workstream (Recommended)" (option text shown: "At the end of each workstream, after its native checks, push through the existing release checks; the 12 waiting commits go in the first push.").
   Applied: the two-folder target of D89 is fixed: ORVION-Workbench (public GitHub) holds every essential file, including decisions, owner texts and recovery inputs; files that change all the time live in its git-ignored data/ folder (ORVION_DATA_ROOT) and reach Git through each workstream's contract; ORVION-Workbench-temporary holds only transient files; the OneDrive vault keeps backups, one full evidence archive per workstream and the raw session transcripts. Secrets are never committed: every file entering Git passes the secret scan first. Pushing happens at the end of each workstream through the existing release procedure, starting with the 12 local WS-027 and WS-028 commits (plan step R1); the earlier keep-it-local practice ends there. The D83 second map now covers ORVION-Workbench-temporary and data/. Plan files after this change: PLAN.md SHA256 B0BB8EA5ABD7644EE71EC6003A5E80B2CB42DA3B5D8DFDE1705690346950FEEE, STANDARD.md SHA256 65E319ED20C27611857BF8DFD04558FF7CA32DD9DD0D9C14E57C27D2C6E5BE66, MIGRATION-MAP.md SHA256 79305126D2F8BC9735B0F241B8FE586E0FDA2AF8AA9D6866C641C463F4C927C1, folder README.md SHA256 EA06436A5E4019B4F59FD77F99EA27605EBD2CA6F38EF93E41B480F8420540C0; the D88-cited versions were drafts updated in place. D85 stays in force. Native gates, tests and evidence rules are unchanged; Batch 6 is not started.
   ## D91 2026-10-31 Owner approves WS-033; the architecture is the mandatory reference; improvements authorized during execution
   Owner's words (about 17:10 Cairo), verbatim: "Very well, I approve WS-033-D90. However, first, please preserve and store the entire architectural framework you presented to me; it must serve as a mandatory reference for any agent working on the plan moving forward. Include everything—even elements I didn’t explicitly ask for—within this architectural framework; do not leave anything to the discretion or "intelligence" of the next agent. Furthermore, I authorize you to implement improvements as you encounter specific needs during execution. Also, do not forget to incorporate the enhancements to the workflow itself—which we discussed previously—to reduce token consumption and streamline interactions between you and Codex."
   Applied: WS-033 is approved as planned under D90. Claude main stored the complete framework at records/owner-directive-20261031-improvement-ws/ARCHITECTURE.md (SHA256 3F8CED7474345CCCD873B52EE0B845234D12EB4283204ECF4FFC142247BE17A8): the places, the full layout, where every kind of item goes, organizers, names, folder operations, lifetimes, pinned paths and native constraints, one home per information, decisions and rules, where drafts live during and after a workstream, tools and their data paths, the method, the Save-State and compact protocol, token rules, the Codex one-session protocol, subagents, push and release, security, checks, the daily flow, targets, a no-discretion procedure for uncovered cases, and definitions. It is mandatory for every agent and lands as docs/WORKSPACE-LAYOUT.md in WS-033 P1. STANDARD.md is kept as STANDARD.v2.md (SHA256 65E319ED20C27611857BF8DFD04558FF7CA32DD9DD0D9C14E57C27D2C6E5BE66), replaced by ARCHITECTURE.md. PLAN.md (SHA256 128D3627EC6548854260180EEFECCB8995A690A7B91099689E6CD5B3F5425AFE), MIGRATION-MAP.md (SHA256 65AAD3DEFCE88B209253C4E1463597E403DEBE964C8C1F8C27B2F1A9F2D0EF59) and the folder README.md (SHA256 8880C023ECDDA671777E65BB583C344EF33EE67099CAE62C46805E0902068F6D) point to it. Improvements found during execution follow ARCHITECTURE.md section 22: the smallest change that passes the three tests, recorded in the same operation; anything that weakens a gate, a test or security, or needs an approval only the owner can give, goes to the owner. D85 stays in force. Native gates, tests and evidence rules are unchanged; Batch 6 is not started.

   ## D92 2026-10-31 DELEGATED exact WS-027+WS-028 preflight publication (plan step R1)
   Exact candidate f06a2b196b9362150c4a100c6b4c8537e8609d50 (12 commits: WS-027 then WS-028), expected main and preflight 4173639609f3f762bf9f47dd034d2df65d0a0ddd, refs/heads/workbench-preflight only. Authority: OWNER-DELEGATION section 3, D90 and the owner's instruction of 2026-10-31 to push the 12 local commits through the release procedure; records/WS-028/package/release/DELEGATED-PUBLICATION.txt SHA256 97940AFF70F715A6D8D35D6B79C08FA6003EDCF0A02BAFE6D1AA5F48AF758BEA, honest DELEGATED. Qualification: both original roots Complete, the trusted evaluator judged all 12 transitions READY, outputs match each implementation commit, gitleaks 0, 18 bounded path/fixture findings classified non-sensitive (Claude-main self-review). ONE ordinary non-force Shehabhub push after fresh actor, destination, ref, ancestry and protection checks. Hosted success not yet earned; no main promotion yet, no rerun, trust or settings change, Lift or cleanup. Failure stops, no automatic retry.

   ## D93 2026-10-31 R1 stopped: hosted acceptance failed on the exact candidate; main not promoted
   Hosted run 41215560787 attempt 1 (push to workbench-preflight, head f06a2b196b9362150c4a100c6b4c8537e8609d50) concluded failure: check 124579223543 workbench-acceptance (app 15368) failure, 37 of 38 tests passed. test-backup-restore.ps1 failed at the WS-027 assertion 'actual candidate refuses disposable installed script/map/data before registration' (line 181). Cause (read-only diagnosis, Claude-main self-review): the test only passes when its fixture lies inside a folder named ORVION-Workbench-temporary, which is true on this machine and false on the hosted runner, because the Backup-Workspace.ps1 install guard (lines 96-97) recognizes disposable inputs only by that folder name or inside -TemporaryRoot. The hosted gate worked: it caught a defect local runs could not show. Applied: no promotion, main stays 4173639609f3f762bf9f47dd034d2df65d0a0ddd; workbench-preflight keeps f06a2b196b9362150c4a100c6b4c8537e8609d50 (no force, no deletion); no rerun; no test, gate or setting changed. Evidence: records/WS-028/package/release/hosted-failure.json SHA256 A9FFF9B6E70AF8C547AFEEA71C0A15087790ACF3641B7FC24D6CD759C39912BC and hosted-failure-20261031T155141Z/. The fix path is the owner's choice (recommended: a small fix workstream that changes only where the test builds that fixture, then R1 again with the longer range).

   ## D94 2026-10-31 Owner: fix the hosted test failure inside WS-033, with one Claude Draft for that fix
   Owner's answers (about 18:13 Cairo) to two questions. Fix path: "Fix inside WS-033" (option text shown: "Make the fix the first slice of WS-033. WS-027 and WS-028 reach GitHub main only when all of WS-033 ends, much later."). Drafts: "One Draft by Claude (Recommended)" (option text shown: "A D31 exception like D80: one test file, a few lines. The native Gate, both Finish runs, the review and GitHub's acceptance run all still apply."). Options not chosen: a separate small fix workstream first (it was recommended), or widening the backup code's safety check.
   Applied: WS-033 gains slice S0: lib/test-backup-restore.ps1 builds its install-refusal fixture inside a folder named ORVION-Workbench-temporary on every machine; the line-181 check and lib/Backup-Workspace.ps1 stay unchanged. Claude main writes S0 once (D31 exception for S0 only) and V1, V2 and V3 carry it unchanged; the other slices keep the plan's Draft method. PLAN step P1.1a first reproduces the hosted failure in the disposable clone, then proves the fix. The 12 WS-027 and WS-028 commits stay on workbench-preflight; main is promoted only at P6.2, for the whole range (WS-027, WS-028, WS-033), after hosted success on that exact head, with the WS-028 release scripts (expected preflight f06a2b196b9362150c4a100c6b4c8537e8609d50). New check (ARCHITECTURE section 19): each new or changed test runs once with its test root outside any ORVION-Workbench-temporary folder. PLAN.md SHA256 9CBCE1F9064616E1CA71FAD6648BADC427ED39F1D0F3BB2A696C1BF436F6552F, ARCHITECTURE.md SHA256 B2E0E1406D1F08E1C7AFF016ABEA7D0B2EB613B3ADDB9B87980E714A5890C9F3 (both updated in place). D85 stays in force; Batch 6 is not started.

   ## D95 2026-10-31 Owner: purpose-specific workflows, OneDrive cleanup, and no error or gap left unfixed

   Owner's words (verbatim, 2026-10-31 18:25 Cairo, with the P1.1 and P1.1a resume message):

   > As you work on the fixes, you will see that the workflow remains the same test or gate or profile or engine, regardless of the content of a "Slice" or "WS" (Workspace). I believe this is a flaw; according to the CRM Repo workflow, there should be distinct workflows—each objective or purpose should have its own independent process. I would like to implement this in the Workbench as well; for instance, a change to governance should not be tested using the same test cycle as something else.
   >
   > Alternatively, perhaps my assumption is incorrect, and the current workflow represents the absolute minimum process that all changes or additions must undergo—in which case, it should actually be expanded upon to improve it.
   >
   > Furthermore, it would be beneficial to clean up the "OneDriver" environment (or repository) by removing files that were uploaded there but do not belong in that location.
   >
   > Always ensure you are informed before taking any action—do not simply guess or make assumptions. Remember to apply our core principles: "Earn It, Worth It," and "Simplify without weaking."
   >
   > Do not leave anything uncorrected if it contains an error or a gap; it must be fixed.

   Applied 2026-10-31 (Claude main; read-only investigation before any change): (1) Workflow: the observation is confirmed. The evaluator derives the profiles REPOSITORY, CONTROL, COORDINATION, RECOVERY, WORKSTATION and CI from the changed paths (lib/Test-WorkbenchChange.ps1 lines 353-359), but its Finish recipe schedules every lib/test-*.ps1 for every change (line 98); the profiles only label the receipt, block WORKSTATION and limit CI scope (lines 503, 538, 539); and WORKFLOW.md gives almost every workstream the same full method (lines 21, 23, 45). CRM also keeps one lifecycle, but scales the method by tier (Routine, Significant, Owner-Decision: ENGINEERING_METHOD.md section 2) and lets each derived profile add its own proof (AGENTS.md section 5); its prototypes are risk-based. The design choice is the owner's: asked the same turn, the answer is D96. (2) OneDrive: inventoried by name and size only. No agent-written file lies outside the ORVION folders, and the owner's own files were neither opened nor touched. Every vault item has a row (MIGRATION-MAP C01-C06). Nothing is deleted now: OneDrive\ORVION-Owner-Tools is the live save mirror until the fold (C01, O13); step3-20261028T174627Z is WS-027 cloud-proof evidence, 110 MB, that the baseline wrongly listed as empty and planned to delete (C03 corrected: it moves to vault evidence at P8); the six backups wait for the keep-last-N retention of slice S7, because no retention code exists (C04); the launchers and sidecars are Backup-Workspace output (C06). (3) Errors and gaps fixed in this operation: inventory.ps1 skipped every OneDrive cloud-only file (fixed; erratum INVENTORY-20261031-onedrive-r2.txt: the vault holds 1,098 MB in 1,165 files, not 390 MB in 34); MIGRATION-MAP C03, C04, C06 and O04; ARCHITECTURE section 3.3 (vault contents), section 9 (path budget: a Tests Root of at most 101 characters and a TEMP of at most 97, which the evaluator does not check) and section 19 (hosted portability at the longest admitted test root), after P1.1a showed two S0 drafts that broke that budget. Scheduled, because the plan does not allow the fix here: the Hunt gaps become slice S10 with its triage step P1.1b (a Spider masking check that a surviving mutant passes, 44 lint findings, three recurring NEED items); the missing TEMP bound needs an evaluator change, which PLAN section 0.6 forbids in WS-033. ARCHITECTURE 2981004C, PLAN ADB997FB, MIGRATION-MAP 8169EF99.

   ## D96 2026-10-31 Owner: one lifecycle sized to each change, and a purpose-based local suite in WS-034

   Owner's answer (verbatim, 2026-10-31 shortly after 19:00 Cairo) to the question "You were right about the workflow. Today every Workbench change gets the same 38-file test suite and the same full method (three Drafts, Codex, mutants, two reviews). CRM keeps one lifecycle too, but it sizes the method to each change and adds checks for each purpose. Which design should the Workbench adopt?": "Also a purpose-based suite". Option text shown: "Everything in the first option, plus a new workstream WS-034 after WS-033 that changes the accepted evaluator. The local Finish would run the always-on checks and the tests that own the changed files. GitHub still runs the full suite before main moves. This saves about 20 minutes per workstream, but a break in another area would first show on GitHub, as D93 did. Changes D79 by adding WS-034 before the Owner Lift." The first option, which that answer includes: "One lifecycle, as in CRM. Each change gets a tier at the start: Routine (one Claude Draft with its three passes as lines; no Codex, no mutant campaign), Significant (today's full method) or Owner-Decision (decision record first). Each purpose adds its own check: governance (consumer list, Markdown guard), backup (one real backup and restore), workflow file (actionlint plus a GitHub run), tests (portability run). The full suite stays for every change, because it is cheap and 15 of the 38 test files read documents. Built in WS-033 slice S1. Amends D31 for Routine changes."

   Applied: D31 is amended for Routine changes (one Claude Draft whose three passes are one line each, frozen as the three snapshots the evaluator requires) from the moment slice S1 lands; Significant changes keep the full method. D79 is amended: WS-033, then WS-034, then the Owner Lift, then STOP at the Batch 6 threshold. WS-033 still never changes the evaluator (PLAN section 0.6). WS-034 changes it once, through the full method: the local Finish runs the always-on checks plus the tests that own the changed files; the full suite stays on GitHub before main moves; and the Execution Context also bounds TEMP (the gap recorded in D95). Written into ARCHITECTURE section 14.4 (tiers and purpose checks) and sections 9, 19 and 22, and into PLAN (header order, section 0.6, slice S1, step P9.3). ARCHITECTURE 44495F8E, PLAN A5266C66.

   ## D97 2026-10-31 Owner: delegation, brief, Spider, architecture and effort fixes; learn from the CRM and ORVION governance

   Owner's words (verbatim, 2026-10-31 about 19:35 and 19:45 Cairo):

   > what about fix the delegation and Brief & the tools like Spider & the entire architectural framework you presented to me & the Codex Effort.

   > what about fix the DECISIONS & AGENTS & CR_LIFECYCLE & ENGINEERING_METHOD & CODING_STANDARDS & CLAUDE & bootstrap.ps1

   To the question "CR_LIFECYCLE, ENGINEERING_METHOD, CODING_STANDARDS, CLAUDE.md and bootstrap.ps1 exist only in the CRM and ORVION repositories (four are identical in both). Your rules keep WS-033 out of CRM and ORVION, and each file there can only change through that repository's own lifecycle with your promotion. One measured issue: their AGENTS.md is 19 KB and loads at every session start; the Workbench target is 1.5 KB. What should happen with these product-repo files?" the owner answered (verbatim):

   > What I meant was: try to learn from their philosophy—rather than modifying it or simply copying their approach—to see if there is anything in their philosophy, organization, or structure that we might actually need.
   > My goal is to build a cohesive architectural, engineering, and technical framework, especially since we are currently in a phase of reorganization and restructuring, and everything will be contained within a single repository. Also, keep in mind that the plan includes steps to improve collaboration and delegation between you and the agents—which was one of the key priorities of the current plan.

   Applied: (1) Delegation, brief, Spider, the architecture and Codex effort, each now explicit in the plan: slice S1 makes one model and effort rule (D82, D83) and brings WORKFLOW.md and lib/README to it; slice S6 adds Delegate -ResumeSession, sets Delegate's effort default (medium today), and gives the brief a why-delegated line and Codex a seven-field HANDOFF return; P2.2, P2.3 and P4.2 reach Codex only through Delegate (the prototype's S6 Delegate once its tests pass, otherwise the accepted Delegate with one fresh session per step, labelled); slice S5 matches ARCHITECTURE section 13 (repository, data/, bounded temporary, vault sessions-raw/, source labels, UNAVAILABLE including cloud-only files); slice S9 pins the vault transcripts; ARCHITECTURE sections 1, 2, 3.3, 13 and 15 and MIGRATION-MAP O10 and C07 follow; every ARCHITECTURE section was checked against the slices; the effort lines of Claude memory became pointers. (2) DECISIONS and AGENTS of the Workbench are already WS-033 work (P1.4, slice S1 RULES.md and AGENTS stub, P7.4 split). CR_LIFECYCLE, ENGINEERING_METHOD, CODING_STANDARDS, CLAUDE.md and bootstrap.ps1 exist only in CRM and ORVION; nothing there was changed. As the owner clarified, step P1.1c learned from them read-only: records/WS-033/crm-learning.md judges 28 patterns: 17 Adopt now inside existing slices (S1, S2, S6, S10, P1.1b, P1.5), 7 already present, 3 later with a trigger, 3 rejected with evidence. PLAN 754C47C9, ARCHITECTURE D3534D05, MIGRATION-MAP 0F1D170B, crm-learning.md F8584B3D.

   ## D98 2026-10-31 Owner: Codex always at the latest Sol model, effort fixed at high (amends D83) (open question answered by D100)

   Owner's words (verbatim, 2026-10-31 about 20:15 Cairo):

   > Also could you clarify the meaning of the following:
   > "S6 adds a 'resume' function to the `Delegate.ps1` file. Every step in the Codex process passes through this file; it first attempts the prototype version, and if that fails, it proceeds to the current version—using a new session for each step, with sessions categorized accordingly."
   > As I recall, this relates to D83. S1 introduces the "single-effort" rule and updates both `WORKFLOW.md` and `lib/README`. S6, meanwhile, addresses the default behavior within `Delegate.ps1`.
   > The reason for my inquiry is that I would like to configure Codex to use the latest version of "Model Sol," with settings adjusted to "fixed effort" at a "high" level, for every instance in which you need to use Codex.

   Applied: amends D83, whose Codex model and effort rule covered WS-033: every Codex run that Claude starts uses the latest verified Sol-family model at effort high, fixed (no per-task choice), during WS-033 and after it. Delegate already selects the newest visible Sol model from Codex's own model cache and ignores the user configuration (lib/Delegate.ps1 lines 92-115 and 163); slice S6 makes high its default and the only effort of the engineering profile; slice S1 writes the one rule into RULES.md and brings WORKFLOW.md (Sol at xhigh today) and lib/README (default medium today) to it. The model-size half of CRM learning row L18 is rejected by this decision. Open owner question: whether the deep-research profile (D38: Terra at xhigh, not used in WS-033) also moves to Sol at high; until the owner answers it is unchanged.

   ## D99 2026-10-31 Owner: signposting, so an agent goes straight to the section it needs in CRM, ORVION and the Workbench

   Owner's words (verbatim, 2026-10-31 about 20:30 Cairo):

   > The CRM system is built on a specific philosophy: an agent should not need to read through an entire file to reach the information they require. Instead, there should be a form of "signposting" that directs them precisely to the section within the file where the relevant data resides.
   > Naturally, every file contains numbered or labeled sections, allowing the agent to navigate directly to the desired part without the burden of an exhaustive search—a necessity, given that some files will inevitably be lengthy, regardless of how well we organize or optimize them.
   > Therefore, I am looking for a dynamic and flexible approach that enables agents to locate exactly what they need within a specific section of a given folder—across our three platforms (CRM, Orvion, and Workbench)—thereby sparing them from tedious and time-consuming searches.
   > It would also be beneficial to research industry best practices and general standards online, as well as to examine other repositories that have already developed solutions for needs similar to our own; if their methodology proves effective, we could adopt it ourselves.

   Applied: new step P1.1d of the WS-033 plan, research first and read-only: current official guidance and published standards, repositories that solved the same need, and the CRM method itself, each with an Adopt or Reject verdict and its source in records/WS-033/signposting.md. The result feeds slice S1 (section labels in the Workbench documents) and slice S5 (finding, built on Map-Repos and Spider). The Workbench may read and index CRM and ORVION; any change inside them stays their own lifecycle and the owner's decision.

   ## D100 2026-10-31 Owner: one source of truth for every decision and fact; Codex offline for V1 and V2; research, prototype and V3 by Claude main; Codex never blocks; no Claude subagents

   Owner's words (verbatim, 2026-10-31 about 22:30 Cairo):

   > Since you have discovered that the same decision has been stored in multiple locations—using different formats or commands—it is time to ensure that the current plan addresses and corrects this flawed approach. Instead of having information scattered and duplicated across various files, there should be a single "source of truth" within the repository. One specific location should be responsible for recording a given decision or fact, while a separate file should archive superseded or replaced decisions. Everything must be interconnected; for instance, a unique identifier could link an obsolete decision or fact in one file to its updated counterpart in another, allowing the agent to track changes easily without cluttering the context.

   > Furthermore, it has become clear that enabling a sub-agent for "Codex" to access online learning resources or the internet is problematic. Therefore, it is best to limit the scope of the Codex agent to versions V1 and V2, as these do not require internet connectivity. When it comes to consulting global references or standards—which will be necessary during the prototype development phase—this should be handled by the primary Claude session agent. This approach avoids the need for a dedicated sub-agent for the prototype and ensures that the most current, up-to-date guidelines are used. Consequently, V3 will also fall under the purview of the primary Claude agent, as it requires cross-referencing against the latest global standards, guidelines, and best practices available online. This will allow Claude to determine whether V2 is sufficient or if existing standards necessitate further improvements—leading to the creation of a new V3 iteration, which will then be subject to review by the agents.

   > Additionally, we must establish a governing rule: if the usage limit for Codex has been reached, then... We will wait for its usage limit to reset; in the meantime, Claude will handle the entire workload. Codex should not act as a blocker for the workflow, but rather as an assistant to be utilized whenever it is available.

   > Furthermore, I do not want to initiate sub-agent sessions with Claude for prototyping or V3 development—nor for reviews—to avoid redundant, purposeless re-reading of the same files. That said, refining the project brief remains essential should we need to call upon Codex for assistance.

   Applied: (1) One fact, one place. A rule or fact in force is written only in its home: rules in docs/RULES.md; decisions in force in docs/decisions/ with its index; replaced or expired decisions in docs/history/decisions/, whose index names each replacement, so one ID chain leads from any old decision to the rule in force. Every other file cites the ID and never restates it. A value that code must carry sits next to its R-ID, and its owning test compares it with RULES.md. A rule that drifted before gets a watch pattern that the Markdown guard checks; the first is the Codex model and effort rule, whose values differed in WORKFLOW.md, lib/README, Delegate.ps1 and memory. In WS-033 this is slices S1 and S6 and steps P1.3, P1.4 and P7.4 (row O01); CRM learning row L03 is adopted now. (2) Codex drafts V1 and V2 and reviews the frozen V3, never with internet access: the research profile is retired (Delegate refuses -Research), hosted web search stays off, and command network access is turned off where the CLI allows it (slice S6). This answers the open question of D98. It amends D38, whose research role moves to Claude main: current global references and standards for the prototype (P1, including P1.1d) and for V3 (P3.1 checks V2 against them and decides whether V2 suffices or V3 must improve it) are Claude main's work, from current official sources. Reading of "subject to review by the agents": the frozen V3 is reviewed by Claude main (a labelled self-review) and by Codex in the V1 and V2 session (P4.2); the owner may correct this reading. (3) Codex never blocks: at its usage limit Claude main does the whole workload, labelled as Claude work, and Codex is used again from the next step once its limit resets; it amends D73, which was interim. (4) No Claude subagent sessions for the prototype, V3 or reviews, so no fresh agent re-reads the same files; it amends D85, which was temporary, into a standing rule for these roles. The Codex brief stays essential: slice S6 refines its template (ARCHITECTURE section 15) so it embeds the evidence Codex needs, and P2 counts the embedded files that Codex read again (target 0).

   ## D101 2026-10-31 Owner: consolidate decisions into one updated decision per subject, never layered

   Owner's words (verbatim, 2026-10-31 about 23:06 Cairo):

   > It seems you are still following the same old approach—layering new decisions on top of existing ones and linking them together—even though we agreed to restructure how files, decisions, and the facts contained within them are organized. Instead of having a collection of both old and new decisions, we should aim to consolidate, refine, and rephrase them into a single, updated decision. This would be far better than having to reconstruct lines and sections every time we make a new decision.

   Applied: D98 to D100 had been recorded in the old way, as new entries layered on older ones with back-pointers, and the plan had collected correction notes. The design is now one consolidated file of decisions in force, docs/DECISIONS.md, with one entry per subject rewritten in place, plus one archive of replaced wording and the owner's words (ARCHITECTURE sections 10 and 11); RULES.md, the per-decision files and their indexes are dropped. PLAN step P1.4 runs next: it consolidates D1-D101 into records/WS-033/DECISIONS.md and maps every D-number. Once the owner accepts that draft it is the source of truth, and this log becomes the archive, receiving only the owner's words verbatim. PLAN.md and ARCHITECTURE.md hold no change notes any more.

   ## D102 2026-10-31 Owner: consolidated decisions accepted; V3 review and V3 purpose confirmed

   Owner's words (verbatim, 2026-10-31 about 23:50 Cairo):

   > I approve the draft.
   > I confirm that the phrase "Version 3 (V3) is subject to review by the agents" entails a documented self-review on my part, in addition to a review by "Codex" (dated December 14).
   > Furthermore, Version 3 (V3) serves as an update to the online-available guidelines, in line with the global standards, practices, specifications, and general recommendations established in Version 2 (V2).

   Reading: "dated December 14" names entry DEC-14, which holds this rule; the self-review is Claude main's, documented and labelled.
   Now in: DEC-01 (records/WS-033/DECISIONS.md is accepted as the single source of truth; this log is its archive from here on), DEC-13, DEC-14.
   Replaced wording, DEC-13: "V3 Evidence Refresh (native admission, owning tests and mutants, sandbox approval, and alignment with current standards and research)" and "V3 by Claude main, who checks V2 against current official standards and records, with sources, whether V2 suffices or what V3 must improve."
   Replaced wording, DEC-14: "The frozen V3 is reviewed by Claude main, labelled a Claude-main self-review and never called independent, and by Codex in the V1 and V2 session (the owner has yet to confirm this reading of "subject to review by the agents")."

   ## D103 2026-11-01 Owner: compact GitHub, OneDrive for backups only, no history kept for its own sake; four principles; guards and self-updating files; a plan with a status page

   Owner's words (verbatim, 2026-11-01 about 00:55 Cairo, a question after P1.2):

   > Is our plan still to have only two folders?
   > The first would be the primary repository linked to GitHub, from which the environment and configuration are retrieved and kept up to date.
   > The second would be a temporary folder for files that don’t need to be permanently stored—files that aren't part of the core system or the standard workflow, but rather secondary items generated during the sandbox phase or general execution.
   >
   > As for OneDrive, I’m not sure how essential it is. I’d prefer it not to consume too much of our time unnecessarily—unless it can easily be adapted to serve as a small, dedicated space for logs, sessions, and similar data. I’m also curious why these logs or sessions weren't simply included in the main GitHub repository so that everything could be kept in one place. That said, it’s fine, provided the folder remains small after we clean it up and remove any unnecessary files.
   >
   > Or is the plan going to be revised—has it turned out to be difficult to implement as originally intended?

   Owner's words (verbatim, 2026-11-01 about 01:20 Cairo):

   > I prefer to avoid having files scattered across various cloud storage services, or keeping outdated, unimportant files—retaining them solely for the sake of historical record.
   >
   > Instead, I prefer a GitHub repository that is as compact as possible, kept consistently up-to-date, and well-structured. Files should be consolidated wherever feasible; there should be no "orphaned" or unused files—only those that are actively referenced. If a file were to be lost—whether on GitHub or OneDrive—it shouldn't be a significant loss.
   >
   > Furthermore, I do not have unlimited storage on GitHub or OneDrive; I rely on small, limited free-tier plans, and I have no intention of purchasing additional paid storage.
   >
   > Please keep this in mind. Also, when migrating files, ensure there are no broken links or orphaned sections resulting from changes to file paths.
   >
   > Additionally, whenever you can combine several small, closely related files into a single, unified file that serves the same purpose, please do so.
   >
   > Ensure that your plan remains up-to-date, flexible, interactive, and organized according to priority and established workflow principles. To these principles, add one more: "Learn before making assumptions."
   >
   > Finally, ensure that most files are protected by safeguards (guards) that prevent the agent from inadvertently corrupting them. Furthermore, the files should be capable of updating themselves automatically; we should not rely on the agent’s memory to manually update each file. Ideally, file types such as JSON, PS1, or similar formats should be self-updating and capable of synchronizing with one another seamlessly.

   Owner's answers to Claude main's four questions (2026-11-01 about 01:35 Cairo; the chosen option, verbatim):

   > Raw session transcripts (922 MB, growing; Spider searches them; each nightly backup carries them): "Last 60 days + index (Recommended)"
   > Evidence of finished workstreams and old records in Owner-Tools/records (94 MB, 5,106 files): "Keep only what's referenced (Recommended)"
   > Backups kept on OneDrive (about 130 MB each; 6 kept, 1.1 GB; the free plan is 5 GB): "Last 7 (Recommended)"
   > What "interactive" means for the plan: "Plus a status page"

   Reading: the vault no longer stores evidence archives or raw transcripts; OneDrive holds only the backup packages and the small continuity copy. "Keep only what's referenced" means a workstream's summary, receipt and the files a decision, gate or event cites stay; the rest is deleted after the Lift's C1 readiness pass, from a list the owner confirms once (the C1 check still needs the 511 manifest copies until then). The owner's words and decision text stay. "Learn before making assumptions" is the fourth test, beside Learn first, Earn it and worth it, and Simplify without weakness.
   Now in: DEC-03, DEC-08, DEC-09, DEC-10, DEC-11, DEC-27, DEC-28 (new), DEC-29 (new).
   Replaced wording, DEC-03: "Every file, folder, section, tool and step passes three tests. Learn first: look before adding, reuse what exists, rest on evidence and be informed before acting; never guess. Earn it and worth it: it has a reader and is worth its cost; the Workbench serves the product, and its tools must really work. Simplify without weakness: the shortest form that keeps every gate, test, rule, piece of evidence and security boundary. Prefer the minimal, demonstrably safe solution; abandon one whose safety needs disproportionate complexity or fragile workarounds rather than add complexity to rescue it; where safety cannot be established, fail closed and keep the evidence. Never leave a found error or gap unfixed: fix it in the current work when its rules allow, otherwise schedule it with a named trigger. How each test is applied: WORKSPACE-LAYOUT.md section 1."
   Replaced wording, DEC-03 Why: "the owner's principles, restated by the owner in most decisions since 2026-10-26."
   Replaced wording, DEC-08: "Target, reached in WS-033: ORVION-Workbench, the public GitHub repository, holds every essential file (tools, the router, decisions, owner texts, recovery inputs, contracts, workstream summaries, the archive); files that change all the time live in its git-ignored data/ folder (ORVION_DATA_ROOT) and reach Git through each workstream's contract. ORVION-Workbench-temporary holds only transient files and can be rebuilt (Restore-Workspace -Temporary). The OneDrive vault keeps the backups, one full evidence archive per workstream and the raw session transcripts. ORVION-Owner-Tools stays in place until WS-033 folds it in. One router file, ORVION-Workbench/README.md, serves humans and agents. Every managed folder has a README.md organizer; folders are created, moved, archived and deleted only through lib/Organize.ps1, which logs each operation; no orphan or duplicate document. CRM and ORVION stay separate: the Workbench may read and index them, and any change there is their own lifecycle and the owner's decision. The owner's personal OneDrive files are never opened or moved."
   Replaced wording, DEC-08 Scope: "ORVION-Workbench, ORVION-Workbench-temporary, ORVION-Owner-Tools and the OneDrive vault."
   Replaced wording, DEC-08 Why: "two folders, lightweight and current, instead of state scattered over three."
   Replaced wording, DEC-09: "The Workbench repository stays public, with its ruleset 'Workbench Main Protection', and publishes all essential governance (the owner's choice, knowing that published text can stay cached after deletion). Secrets are never committed: keys, tokens, passwords, connection strings, cookies, private keys. Every file entering Git passes the secret scan first; a hit keeps the file out of Git and in the vault. Raw transcripts never enter Git. Keys and passwords never appear in agent transcripts, logs or command arguments. No privilege is widened, and no credential, machine setting, GitHub protection or unrelated repository is changed without the owner."
   Replaced wording, DEC-10: "Never deleted: evidence, records, sessions, events, decision text, the owner's words and the owner's personal files. Deleted without a further question, only by lib/Organize.ps1 -Clean after its gates pass (workstream Complete, evidence hash-checked, not pinned, not named by an active file): disposable items of completed workstreams, empty logs and exact duplicates; the report lists every deletion. Tracked documents are merged or deleted only through a contract; local work files only after a verified archive copy; disposable and legacy folders only after their evidence is preserved, a C1 readiness pass, a manual check of the owner-reviewed inputs and cited paths, and one owner confirmation of the exact list. Restore staging is kept and reported, never deleted automatically; its disposal is a separate owner decision. Any other destructive cleanup needs the owner."
   Replaced wording, DEC-10 Scope: "every deletion in the three folders and the vault."
   Replaced wording, DEC-10 Why: "clean folders without ever losing evidence."
   Replaced wording, DEC-11: "Every failed, refused or superseded attempt is kept separately with its reason; it is never overwritten, relabelled or turned into a pass. Permanent synced records hold deliverables and concise evidence, never generated test fixture trees (OneDrive refuses paths over 400 characters): long-path tests run in temporary locations, and agents build fixtures under their own TEMP and copy only deliverables and logs into records."
   Replaced wording, DEC-11 Scope: "records, the vault and every agent's output."
   Replaced wording, DEC-11 Why: "honest history that OneDrive can always sync."
   Replaced wording, DEC-27: "The recovery package is a plain compressed archive, not encrypted, uploaded to OneDrive at its step; no key is created. The secret scan identifies findings by path and rule name only, never by value, and cannot see history inside bundles; session transcripts stay verbatim in the package. After any Windows reinstall, the GitHub CLI OAuth authorization of both accounts is revoked (docs/RECOVERY.md). Not packaged: GitHub\Marketing-MCP (not a repository; it holds credentials) and transcripts that are not ORVION's; no unrelated file is moved or deleted. The production daily backup task runs with a 60-minute limit."
   Replaced wording, DEC-27 Why: "the owner chose a simple unencrypted package over key custody."

   ## D104 2026-11-01 Owner: the old WS-029 test package is deleted; the Lift's restore package is kept until the Lift

   Owner's answers to Claude main's two questions in WS-033 step P1.2b (2026-11-01 about 10:31 Cairo; each question and the chosen option, verbatim):

   > P1.2b row C03: OneDrive\ORVION-Recovery\step3-20261028T174627Z holds an old test package from WS-029 step 3 (orvion-backup-20261028T174837Z.7z, 114 MB, plus its sidecars and launchers, 115 MB in all). No active file names it; only the archive and the WS-029 records mention it, and those records keep its SHA256 and results. Your direction allows only the last 7 daily packages and the continuity copy on OneDrive. What should happen to it?: "Delete it now (Recommended)"
   > P1.2b found that DEC-05 (your Lift criteria) and HANDOFF.md:18 name orvion-backup-20261026T201821Z.7z (205 MB) as the package of the isolated restore test for Lift criterion 5. The keep-last-7 rule would delete it after two more daily backups once slice S7 is live. What should the retention do with it?: "Keep it until the Lift (Recommended)"

   Option texts shown with the chosen options: "Deleted through the plan's cleanup with a log row. Its SHA256 and results stay in data/records/WS-029. OneDrive then holds only the daily packages and the continuity copy." and "Retention keeps the last 7 packages plus any package an active file names. That means at most one extra package (205 MB) until DEC-05 is rewritten at the Lift. DEC-10 and DEC-27 are rewritten to say so (archive item D104)."

   Reading: the step3 test package is deleted by Organize -Clean in WS-033 step P8 with a LOG.tsv row (MIGRATION-MAP.tsv C03); the retention of slice S7 deletes, through Organize -Clean, packages beyond the last 7 that no active file names, so orvion-backup-20261026T201821Z.7z stays until the Lift rewrites DEC-05 and HANDOFF.md.
   Now in: DEC-10, DEC-27.
   Replaced wording, DEC-10: "Kept: what an active reader uses (a tool, a gate, a decision, an agent step or an owner need), the owner's words, decision text, the event journal, the session index, and the owner's personal files, which are never touched. Nothing is kept only as history: Git history keeps every replaced tracked file. Deleted only by lib/Organize.ps1 -Clean after its gates pass (workstream Complete, not pinned, not named by an active file), with every deletion in its report: disposable items of completed workstreams, empty logs, exact duplicates, raw transcripts older than 60 days, and, after the Lift's C1 readiness pass, evidence no active reader uses, from a list the owner confirms once. A move or deletion updates or removes every reference to the item in the same operation, so no link, citation or section breaks (Organize -Check, the Markdown guard and Hunt show none). Tracked documents are merged or deleted only through a contract; legacy folders only after their C1 readiness pass, a manual check of the owner-reviewed inputs and cited paths, and one owner confirmation of the exact list. Restore staging is kept and reported, never deleted automatically; its disposal is a separate owner decision. Any other destructive cleanup needs the owner."
   Replaced wording, DEC-27: "The recovery package is a plain compressed archive, not encrypted, written by the daily 02:00 Cairo task to OneDrive\ORVION-Recovery; no key is created. Backup-Workspace keeps the last 7 packages with their sidecars and deletes older ones (slice S7). The secret scan identifies findings by path and rule name only, never by value, and cannot see history inside bundles; the package carries data/, with the raw transcripts of the last 60 days verbatim. After any Windows reinstall, the GitHub CLI OAuth authorization of both accounts is revoked (docs/RECOVERY.md). Not packaged: GitHub\Marketing-MCP (not a repository; it holds credentials) and transcripts that are not ORVION's; no unrelated file is moved or deleted. The production daily backup task runs with a 60-minute limit."

   ## D105 2026-11-01 Owner: Codex runs confined by the MXC sandbox (guards.md section 7, option A)

   Owner's answer to Claude main's question Q1 of WS-033 step P1.1e (records/WS-033/guards.md section 7), given during step P1.3b (2026-11-01 about 12:30 Cairo), verbatim:

   > about Codex sandbox question : i go with option A

   Option text chosen (guards.md section 7): "A (recommended): S6 runs Codex under MXC, workspace-write, writable roots the clone and the run folder only, set per run by Delegate; when MXC is unavailable the run is refused, never widened; the tripwire stays. DEC-20 is rewritten."

   Reading: slice S6 makes Delegate pass the MXC sandbox, workspace-write and the two writable roots per run with -c (guards.md G13; no client-wide setting); a run where MXC is unavailable is refused, so no Codex run is launched through a Delegate without this confinement; the tripwire stays as a second check; the evidence that MXC works here is guards.md T6. Read confinement is not claimed.
   Now in: DEC-20.
   Replaced wording, DEC-20: "Codex runs only through lib/Delegate.ps1, in a disposable clone, never in an original root, with --ignore-user-config (the user's Codex configuration loads production MCP servers and tokens). It runs in danger-full-access, the only working mode here (Codex's Windows sandbox does not work on this machine): the owner accepted that Codex has this user's rights, and protection is the brief, the orchestrator's post-run check and Delegate's tripwire, which detects outside writes (exit 4) but does not confine. Every run passes features.multi_agent=false and disables Codex memories; spawn_agent is still exposed, so prevention is never claimed; a confirmed unauthorized sub-agent fails the run; no recursive delegation. Never run Codex beside a heavy job, and never touch a watched checkout during a run. The codex-delegate skills are not installed as a global Claude skill."
   Replaced wording, DEC-20 Why: "Codex runs with this user's rights, so its boundaries must be explicit and checked after each run."

   ## D106 2026-11-01 S1: the owner's standing rules outside DECISIONS.md, the CRM rows and the signposting design get their home

   Not a new owner decision. WS-033 step P1.3 (records/WS-033/sections.tsv) found 13 owner rules in no entry (rows labelled TO-DEC: L033, L046, L116, L126, L129, L131, L133, L135, L136, L138, L143, L145, L149) and row L120 (DEC-11's TEMP wording, back to its source D41); step P1.1c (records/WS-033/crm-learning.md) adopted rows L05, L06, L12, L16, L21 and L28 for DECISIONS.md, and step P1.1d (records/WS-033/signposting.md section 5) one new entry. Slice S1 (WS-033 step P1.5b, records/WS-033/prototype/s1/Apply-S1Decisions.ps1) writes them into the entries below. The owner's words, verbatim, are the owner-typed messages of the session transcripts (records/WS-033/prototype/s1/Get-OwnerMessages.ps1); times UTC, then the session ID prefix.

   English only (row L135), 2026-10-26T09:28:17Z, b0862c78:

   > speake to me in english only

   The constitution (rows L126, L129): a first form of 14 principles at 2026-10-26T19:12:44Z, b0862c78:

   > مبادئنا في بناء ORVION وWorkbench تقوم على فكرة أساسية:
   >
   > نبني نظامًا ذكيًا يتعلم من خبراته، ينفذ بأقل تكلفة وتعقيد، يحافظ على المعرفة، ويثبت صحة قراراته بالأدلة، دون أن يعتمد نجاحه على ذكاء وكيل معين أو استمرار جلسة واحدة.
   >
   > وهذه هي المبادئ التي اتفقنا عليها عبر مراحل تطوير المشروع.
   >
   > ### دستورنا الهندسي — 14 مبدأ
   >
   > 1\. LEARN BEFORE GUESSING — تعلّم قبل أن تخمّن قبل اقتراح حل، ابحث في الكود والعقود السابقة وسجلات الأخطاء والتجارب الناجحة. لا تعِد اختراع حل سبق إثباته.
   >
   > 2\. NO UNSUPPORTED ASSUMPTIONS — لا افتراضات دون دليل افصل بين الحقيقة المثبتة، والفرضية المنطقية، والمعلومة غير المعروفة. لا تُعلن نجاحًا أو اكتشافًا لا تدعمه الأدلة.
   >
   > 3\. EARN IT / WORTH IT — أثبت القيمة قبل استثمار الموارد كل أداة أو اختبار أو تغيير يجب أن يقدم فائدة تستحق الوقت والذاكرة والتكلفة والتعقيد الذي يضيفه.
   >
   > 4\. SIMPLIFY WITHOUT WEAKENING — بسّط دون إضعاف تخلّص من التكرار والإجراءات غير الضرورية، لكن احتفظ بكل ضمانة تحمي من خطر حقيقي.
   >
   > 5\. EXECUTE WITHIN AUTHORITY — نفّذ داخل صلاحياتك احترم الحوكمة والموافقات وهوية كل مستودع. لا تتحول الموافقة على هدف عام إلى تصريح غير محدود لتغيير الأنظمة.
   >
   > 6\. TEST BEFORE TRUST — اختبر قبل أن تثق لا يكفي أن تعمل الأداة في اختبارات مصطنعة. اختبر الحالات الواقعية، وحالات الفشل، وأثبت أن الإصلاح يمنع تكرار العيب.
   >
   > 7\. PRESERVE KNOWLEDGE — احفظ المعرفة العقود والدروس والقرارات والجلسات المهمة والأدلة يجب أن تبقى قابلة للاستعادة. المستودع والبيانات الدائمة هما الذاكرة، وليست المحادثة.
   >
   > 8\. REUSE BEFORE REBUILD — أعد الاستخدام قبل إعادة البناء استفد من أدوات وحوكمة Platinum وFounder وWorkbench. لا تنشئ محركًا جديدًا بينما توجد آلية مجرّبة تؤدي الوظيفة.
   >
   > 9\. DISCOVER → DELEGATE → VERIFY → FIX — اكتشف وفوّض وتحقق وأصلح Hunt يكتشف، Spider يبحث عن الأدلة، Delegate يساعد على توزيع العمل، وWatcher يراقب. الوكيل يراجع ويصلح ويحفظ ما تعلمه.
   >
   > 10\. AUTONOMY WITH ACCOUNTABILITY — استقلالية مع مسؤولية نريد أقل عدد ممكن من تدخلات المالك، دون أن يخفي الوكيل أخطاءه أو يتجاوز حدود صلاحياته. كل عملية مهمة يجب أن تكون قابلة للتتبع والاستكمال.
   >
   > 11\. NO REPORTS THAT SPAWN REPORTS — لا تقارير تولّد تقارير التقرير وسيلة لاتخاذ قرار أو تنفيذ إجراء، وليس منتجًا بحد ذاته. نفضّل تنفيذًا مثبتًا على عشرات الصفحات دون تقدم حقيقي.
   >
   > 12\. MINIMUM MOVING PARTS — أقل عدد من المكونات المتحركة لا نضيف عمليات مراقبة مستمرة أو خدمات أو قواعد بيانات أو طبقات حوكمة إلا عند وجود ضرورة مثبتة.
   >
   > 13\. INDEPENDENCE BY DESIGN — الاستقلالية بالتصميم Platinum وFounder يحتفظان بحوكمتهما وهويتهما واختباراتهما واعتماداتهما. Workbench يساعدهما ولا يستولي على سلطتهما.
   >
   > 14\. PRODUCT VALUE FIRST — قيمة المنتج أولًا الهدف النهائي هو بناء ORVION CRM/ERP SaaS ناجح. Workbench موجود لتسريع هذا الهدف وحمايته، وليس ليصبح مشروعًا لا ينتهي.
   >
   > ### القواعد الحوكمية الأساسية
   >
   > لدينا أيضًا قواعد رسمية تطبق تلك المبادئ:
   >
   > | القاعدة | المقصود                                                                                                           |
   > | ------- | ----------------------------------------------------------------------------------------------------------------- |
   > | CAG     | الانضباط الدستوري للوكيل: التعلم، عدم التخمين، إثبات القيمة، تبسيط العمل، احترام الصلاحيات، الاختبار وحفظ المعرفة |
   > | SACI    | حماية سلامة السلطة من التقادم؛ فلا تُستخدم موافقة أو حالة قديمة لتبرير تنفيذ بعد تغير الظروف                      |
   > | PICF    | إثبات إمكانية إكمال العملية واستيفاء شروطها قبل عبور حدود تنفيذ لا يمكن الرجوع عنها بسهولة                        |
   > | CRGL    | الالتزام بضوابط دورة التغيير المعتمدة وفق تعريفها الرسمي في المستودع، دون اختراع تفسير جديد لها                   |
   >
   > وكذلك Three-Pass Draft Assurance: مسودة أولية V1، ثم مراجعة نقدية V2، ثم مراجعة بحثية V3. الهدف اكتشاف العيوب وتحسين جودة القرار قبل التنفيذ، مع الالتزام بالمسار الحوكمي المناسب للتغيير.
   >
   > هذه القواعد تُستخدم وفق نصوصها الأصلية وسلطتها المعتمدة، ولا ينبغي للوكلاء إعادة تعريفها من الذاكرة.

   and the final form, 96 seconds later, at 2026-10-26T19:14:20Z, b0862c78:

   > مبادئنا في بناء ORVION وWorkbench ليست مجرد قواعد للبرمجة، بل فلسفة هندسية نريد أن يلتزم بها كل وكيل، سواء كان Claude Code أو Codex أو أي وكيل يأتي بعدهما.
   >
   > هدفنا الأساسي: بناء ORVION كنظام CRM/ERP SaaS ناجح، باستخدام وكلاء أذكياء يتعلمون من الخبرة السابقة، ويعملون باستقلالية، ويحققون أعلى جودة بأقل تكلفة وتعقيد وتدخل من المالك.
   >
   > ## أولًا: مبادئنا الأساسية
   >
   > 1\. LEARN BEFORE GUESSING — تعلّم قبل التخمين. ابحث في الكود والعقود والأخطاء السابقة والأدلة الموجودة قبل اتخاذ أي قرار. لا تخترع حلًا سبق تنفيذه واختباره.
   >
   > 2\. NO UNSUPPORTED ASSUMPTIONS — لا افتراضات دون دليل. ميّز دائمًا بين الحقيقة المثبتة والاستنتاج والفرضية. ما لم يُختبر لا يُعلن نجاحه، وما لم يُفحص لا يُفترض أنه صحيح.
   >
   > 3\. EARN IT / WORTH IT — أثبت القيمة قبل إضافة التعقيد. كل أداة أو اختبار أو إجراء جديد يجب أن يبرر تكلفته وفائدته. لا نبني أنظمة لمجرد قدرتنا على بنائها.
   >
   > 4\. SIMPLIFY WITHOUT WEAKENING — بسّط دون إضعاف. تخلّص من الخطوات المكررة والتعقيدات غير الضرورية، لكن لا تضحِّ بضمانات حقيقية تحمي المنتج أو البيانات أو الصلاحيات.
   >
   > 5\. EXECUTE WITHIN AUTHORITY — نفّذ ضمن الصلاحيات. احترم العقود والموافقات والحوكمة المستقلة لكل مستودع. لا تتجاوز بوابة إلزامية أو تتصرف نيابة عن المالك دون تفويض صالح.
   >
   > 6\. TEST BEFORE TRUST — اختبر قبل أن تثق. اعتمد على اختبارات واقعية وذات معنى. لا يكفي نجاح الاختبارات المصطنعة إن كانت لا تغطي ظروف التشغيل الحقيقية.
   >
   > 7\. PRESERVE KNOWLEDGE — احفظ المعرفة والخبرة. يجب أن تصبح الأخطاء المكتشفة والدروس والقرارات والحلول المثبتة معرفة دائمة يستطيع الوكيل التالي الاستفادة منها.
   >
   > 8\. REUSE BEFORE REBUILD — أعد الاستخدام قبل إعادة البناء. استعمل الأدوات والآليات المجربة في Platinum وFounder وWorkbench، مع احترام اختلاف صلاحيات كل مستودع.
   >
   > 9\. AUTOMATE AND DELEGATE INTELLIGENTLY — أتمت ووَكِّل بذكاء. استخدم Hunt للاكتشاف، وSpider للبحث، وDelegate لتوزيع المهام المناسبة، وWatcher للمراقبة. لا تجعل الوكيل ينفذ يدويًا ما تستطيع أداة موثوقة إنجازه بكفاءة أكبر.
   >
   > 10\. MEASURE REAL VALUE — قِس القيمة الفعلية. النجاح ليس عدد Commits أو العقود أو الاختبارات؛ بل مقدار التقدم الحقيقي، والوقت الذي وفرناه، والأخطاء التي منعناها، وانخفاض تدخلات المالك.
   >
   > ## ثانيًا: قواعد الحوكمة التي تحمي هذه المبادئ
   >
   > لدينا أربعة مراجع حاكمة نحتكم إليها وفق تعريفاتها الأصلية في المستودعات:
   >
   > | القاعدة                                        | وظيفتها                                                                                          |
   > | ---------------------------------------------- | ------------------------------------------------------------------------------------------------ |
   > | CAG — Constitutional Agent Discipline          | الانضباط الهندسي للوكيل، والتعلم والتحقق والتنفيذ ضمن السلطة                                     |
   > | SACI — Stale Authority Integrity               | منع استخدام موافقات أو أدلة قديمة بعد تغير الحالة أو مصدر السلطة                                 |
   > | PICF — Pre-Irreversible Completion Feasibility | التأكد من قابلية استكمال العملية وشروطها قبل اتخاذ خطوة لا يسهل التراجع عنها                     |
   > | CRGL                                           | قواعد دورة التغيير والعقود المعتمدة؛ يُرجع لتعريفها الأصلي في المستودع بدل افتراض تفسير جديد لها |
   >
   > وتكملها مراجعة المسودات بثلاث مراحل V1 / V2 / V3 عندما تتطلبها الحوكمة: مراجعة أولية، ثم مراجعة نقدية مضادة، ثم مراجعة بحثية مدعومة بالمصادر.
   >
   > ## ثالثًا: فلسفتنا في تشغيل الوكلاء
   >
   > هناك ثلاث عبارات أعتبرها تلخص طريقة عملنا:
   >
   > «المستودع هو الذاكرة، وليس المحادثة.»
   >
   > لا نعتمد على بقاء الوكيل نفسه، أو تذكره لما حدث. يجب أن يجد أي وكيل جديد الحالة الصحيحة، والدروس، والعقود، والصلاحيات، والخطوة التالية من ملفات المشروع وأدواته الأصلية.
   >
   > «لا نريد تقارير تُنتج تقارير.»
   >
   > نريد اكتشافًا يؤدي إلى قرار، وقرارًا يؤدي إلى تنفيذ، وتنفيذًا يؤدي إلى نتيجة مثبتة. لا نستهلك الوقت والتوكنات لإعادة وصف ما نعرفه بالفعل.
   >
   > «Workbench يخدم ORVION، وليس العكس.»
   >
   > إذا أصبحت حوكمة Workbench تعطل تطوير المنتج دون فائدة مثبتة، نراجعها ونبسطها. وإذا اكتشفنا أداة مفيدة فعلًا، نحتفظ بها ونضمن استخدامها مستقبلًا.
   >
   > ## رابعًا: متى نعتبر أننا نجحنا؟
   >
   > ليس عندما نُنهي جميع ميزات Workbench.
   >
   > بل عندما يستطيع وكيل جديد فتح المشروع، وفهم حالته، واكتشاف الأخطاء، والاستفادة من الحلول السابقة، وتفويض العمل المناسب، وتنفيذه واختباره بأمان، ثم حفظ المعرفة للوكيل التالي — بأقل قدر ممكن من تدخل المالك.
   >
   > وفي الوقت نفسه يستطيع المالك فقدان الجهاز أو إعادة تثبيت Windows دون فقدان أي معرفة أو عمل مهم لا يمكن استعادته.
   >
   > المبدأ الجامع لكل ذلك:
   >
   > > تعلّم قبل أن تخمّن، وأثبت قبل أن تدّعي، وبسّط دون أن تُضعف، ونفّذ ضمن صلاحياتك، واحفظ ما تعلمته، ولا تبنِ شيئًا إضافيًا إلا إذا أثبت أنه يستحق.
   >
   > هذه هي الفلسفة التي ينبغي أن تحكم ORVION وWorkbench وجميع الوكلاء الحاليين والمستقبليين.

   Low-stakes choices (row L133), 2026-10-26T20:16:59Z, b0862c78 (its first line quotes Claude's question):

   > Still open: should I download the pinned guard checklists and debate prompts?
   >
   > should you do ?
   >
   > هل تراه يستحق ذلك
   > دائما عندما يقع امامك خيارا او سؤالا ما - طبق قاعدة - earn it & worth it

   Temporary and important files (row L145), 2026-10-26T21:14:01Z and 22:11:14Z, b0862c78:

   > كان هناك ملفات مؤقته تنتج اثناء التنفيذ وحفظت فى ال temp وخارج مجلد Documents
   > وايضا يوجد مجلدات اخري غير ORVION-Owner-Review & ORVION-Sandbox
   > مثل ما فى الصورة وذلك يغضبنى ايضا فاريد حصر بكل ما هو متعلق ب orvion وخارج مجلد GItHub لمناقشة حذفه ان كان حذفه earn it

   > ليه بتخفظ الملفات المهمه خارج مجلد المستودع الاصلي ليه بتحقظ بداخل C:\Users\My Lab\Documents\ORVION-Owner-Review\
   >
   > ماذا لو مسحت هذا المجلد الان هو ما معه من مجلدات :
   > ORVION-drafts-backup
   > ORVION-Owner-Recovery
   > ORVION-Owner-Review
   > ORVION-Owner-Tools
   > ORVION-Sandbox
   >
   > لانى بلغتك مرارا وتكرارا بانى اريد ان يكون هناك مجلدان فقط هما اصل الملفات المهمه :
   > C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
   > C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools

   and the standing instruction in every WS-033 resume message the owner has sent since 2026-11-01T08:54:31Z (a4217361): "Scratch files go to ORVION-Workbench-temporary\scratch, never the harness scratchpad."

   Satisfaction (row L138), 2026-10-27T07:37:02Z and 07:40:53Z, b0862c78:

   > بما انك عملت على المستودعات المحليه وتصليحهم وتحسينهم
   > فاين تقع مواطن رضاك انت وكودكس واين تقع مواطن عدم رضاكم
   > وايضا هل يمكنك ان delegate وتتعامل وتتواصل مع موديل جيميناي اظن هناك موديل مثبت على الجهاز

   > حاول ان تجد طرق اثناء وبجانب عملكم الطويل على المستودع ومع الوقت لجعلك انت وكودكس تصلان للرضا

   Learning from governance, standards and research (row L136), 2026-10-27T10:25:44Z, b0862c78:

   > تتبع الانماط وتعلم من حوكمة المستودعين وتعلم من المعايير العالمية وخبرات من سبقك عبر الاوراق البحثية والمنشورات على المنصات المختلفة وايضا استفد من ذكاء كودكس

   Maintenance mode (row L149): records/PLAN-CHOICES-20261027.md row C2, accepted with the triggers "real incident, false green/red, measured material cost, proven safety/governance gap", merged into the plan on the owner's order of 2026-10-27T12:16:06Z, b0862c78:

   > حسنا ادمج ما اخترتموه سويا بالخطة الاساسية واعرض لى خطواتها المجمعه بمنتهى البساطة والوضوح

   Cairo time (row L143), 2026-10-30T22:52:20Z (00:52 on 2026-10-31 in Cairo), 6d98132e:

   > iam in cairo egypt make sure the time you tell me is cairo time

   No owner words were found for row L033 (its source is WORKFLOW.md line 51, a contract's rule), row L116 (its source is the Claude memory file owner-codex-and-contract-rules.md lines 29-30, recorded there as owner feedback) or row L131 (the memory's "keep replies short" rests on the constitution's second saying, quoted above). The CRM rows rest on the CRM texts that crm-learning.md cites; the signposting entry rests on D99.

   Reading: DEC-02 adds deciding a low-stakes choice with Earn it. DEC-03 adds learning from the CRM and ORVION governance, standards and research, keeping fact, inference and hypothesis apart, boring rather than clever, and the size-budget rule; its sentence that the Workbench serves the product moves to DEC-30. DEC-04 adds maintenance mode after the Owner Lift. DEC-11 brings its TEMP rule back to D41 (fixtures under the run's TEMP inside ORVION-Workbench-temporary, with the one hosted-portability run outside) and takes the scratch rule of row L145: the row names DEC-08, which is at its 12-line limit, and DEC-11 already says where agents put transient files. DEC-12 adds the product benefit and the retro (row L138; the retro is Claude main's and Codex's, in the workstream's one Codex session, not a fresh low-effort one, which DEC-18 and DEC-21 exclude). DEC-16 adds freshness (L16), DEC-19 the hypothesis and finder record (L116), DEC-20 the private reads (L033), DEC-22 measurement integrity (L12), DEC-28 discovery-to-guard (L06). New: DEC-30 (the goal and the constitution; L05, L28's reason), DEC-31 (owner communication: L131, L135, L143), DEC-32 (sections and citations, signposting.md section 5). The preamble is cut to three lines for DEC-32.
   Now in: DEC-02, DEC-03, DEC-04, DEC-11, DEC-12, DEC-16, DEC-19, DEC-20, DEC-22, DEC-28, DEC-30, DEC-31, DEC-32.
   Replaced wording, DEC-02: "The owner's live instruction wins. OWNER-DELEGATION.md (SHA-256 94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217) is the standing conditional delegation. An approval given under it is recorded as DELEGATED, never as typed by the owner; an approval only the owner can give is never typed or simulated by an agent; local integrity binds evidence but does not authenticate the owner. A general instruction ("continue", "choose the best", "whatever authority you need") grants judgment inside the existing limits, never new scope, and its reading is written down before acting. A one-time authorization is never reused; a historical report never becomes an approval; if a condition fails, the affected irreversible action stops. Up to the Batch 6 threshold: fix an easily fixed gap or error without asking; park a critical decision that cannot be bypassed on the owner list and work around it. Never inferred from that autonomy: credential, machine-setting or GitHub-protection changes, destructive cleanup, deletion of owner data. Improvements found during execution follow WORKSPACE-LAYOUT.md section 22. The owner's words are saved verbatim and carried into the work without loss."
   Replaced wording, DEC-03: "Every file, folder, section, tool and step passes four tests. Learn first: look before adding, reuse what exists and rest on evidence. Learn before making assumptions: verify every fact a step depends on (read the file, run the check, read the current official source) before acting on it; never guess; ask the owner what only the owner knows. Earn it and worth it: a file exists only while something actively reads it (a tool, a gate, a decision, an agent step or an owner need); nothing is kept only as history; the Workbench serves the product, and its tools must really work. Simplify without weakness: the shortest form that keeps every gate, test, rule, needed piece of evidence and security boundary; small, closely related files are merged into one file that serves the same purpose. Prefer the minimal, demonstrably safe solution; abandon one whose safety needs disproportionate complexity or fragile workarounds; where safety cannot be established, fail closed and keep the evidence. Never leave a found error or gap unfixed: fix it in the current work when its rules allow, otherwise schedule it with a named trigger. How each test is applied: WORKSPACE-LAYOUT.md section 1."
   Replaced wording, DEC-04: "WS-033, then WS-034, then the Owner Lift through its existing process, then STOP at the Batch 6 threshold. No agent starts Batch 6; it waits for the owner's lift record. The Final Stop Packet baseline exists; WS-033 adds a supplement. Work stays on this roadmap and on each workstream's plan, with no gap left behind and no new unit, framework, service or pipeline outside them."
   Replaced wording, DEC-04 Scope: "the programme until the Owner Lift."
   Replaced wording, DEC-04 Why: "the owner fixed the order and the stop point."
   Replaced wording, DEC-11: "While a workstream is open, every failed, refused or superseded attempt is kept separately with its reason; it is never overwritten, relabelled or turned into a pass. When the workstream completes, records/WS-0NN/README.md keeps its result, its receipt, each failure with its reason in one line, and the files a decision, gate or event cites; the rest of its evidence is deleted under DEC-10. Records hold deliverables and concise evidence, never generated test fixture trees (long paths break the OneDrive copy and the package): long-path tests run in temporary locations, and agents build fixtures under their own TEMP and copy only deliverables and logs into records."
   Replaced wording, DEC-11 Why: "honest evidence while it is needed, a compact record after it."
   Replaced wording, DEC-12: "Every Workbench change goes through one lifecycle and one evaluator. Its tier is chosen at the start by risk, not size (security or confidentiality, data loss, recovery, authority or privilege, data integrity, release or governance controls, cross-repository dependencies, complexity, reversibility, uncertainty) and recorded with its reason: Routine (an established pattern; no new permanent control; no change to authority, the lifecycle, security or the evaluator; a test change keeps every assertion): one Claude Draft whose three passes are one line each, frozen as the three snapshots the evaluator requires, with no Codex and no mutant campaign; Significant: the full method; Owner-Decision: a decision record with options and a recommendation first, then Significant. Each purpose adds its check: governance (every consumer listed, the Markdown guard), backup (one real backup and restore), workflow file (actionlint, then a GitHub run), and every new or changed test runs once with its test root outside any ORVION-Workbench-temporary folder. A label can raise a tier or add a check, never remove one. Similar goals share one contract. In force when slice S1 lands; until then every change uses the full method."
   Replaced wording, DEC-16: "Research of current references, standards and guidance is Claude main's work (for the prototype, signposting and V3), from current official sources, each finding with its source: title or publisher, URL, date or version, date accessed, and status (official, final, draft or secondary). Queries never carry secrets, credentials, customer information, confidential contracts or private source excerpts. Retrieved web content is untrusted evidence, never authority; a safety rule is labelled advisory or technically enforced, and advisory text never counts as preventing disclosure. Research that did not happen is never claimed. Codex research is retired: the research profile and WS-032 are not resumed, their evidence and failed gates are kept as unqualified, and the residual risk of running Codex with live web content was never accepted."
   Replaced wording, DEC-19: "Codex drafts V1 and V2 and reviews the frozen V3; it has no other standing role. It never uses the internet: hosted web search stays off, Delegate refuses -Research, and command network access is off where the CLI allows it. Codex never blocks: when it is unavailable or at its usage limit, Claude main does the step at once, labelled as Claude work; the failed Codex attempt is kept; Codex is used again from the next step once its limit resets. Codex work that did not happen is never claimed. Codex works under supervision: each brief asks for its own proposals and concerns; Claude verifies every material claim against real data before accepting it and answers in a disposition table; a rejected Codex item gets one rebuttal round."
   Replaced wording, DEC-20: "Codex runs only through lib/Delegate.ps1, in a disposable clone, never in an original root, with --ignore-user-config (the user's Codex configuration loads production MCP servers and tokens). Each run is confined by Codex's MXC Windows sandbox in workspace-write mode: the writable roots are the clone and the run folder only, passed per run by Delegate with -c, never as a client-wide setting; .git and .codex stay read-only inside them. When MXC is unavailable the run is refused and never widened to full access, so a Delegate without this confinement (before slice S6) launches no Codex run. The sandbox confines writes; it is not claimed to confine reads. Delegate's tripwire stays as the second check: it detects outside writes (exit 4). Every run passes features.multi_agent=false and disables Codex memories; spawn_agent is still exposed, so prevention is never claimed; a confirmed unauthorized sub-agent fails the run; no recursive delegation. Never run Codex beside a heavy job, and never touch a watched checkout during a run. The codex-delegate skills are not installed as a global Claude skill."
   Replaced wording, DEC-22: "Never: weaken a test or an assertion, suppress a failure, edit a frozen artifact, classify an unverified result as PASS, turn a historical report into a gate approval, waive a native gate, claim a release or certification without proof, force-push, rewrite history, disable protection, mix credentials, advance trust without qualification, or bypass a failed certification. A test edit that weakens an assertion is a contract change. An interactive confirmation that exists for the owner is never emulated. Results are reported as PROVEN, UNPROVEN or HYPOTHESIS; observed release evidence is never presented as native certification (the Workbench has no native REMOTE_CERTIFY)."
   Replaced wording, DEC-28: "Every file an agent could corrupt by accident has a guard that fails before or at the change: for tracked files the contract and the staged gate; for Markdown the Markdown guard; for JSON, TSV and JSONL a schema check in the owning test or Organize -Check. A file that only one tool may write (NOW.md, LOG.tsv, the event journal, the session index, generated organizers and maps) is written by that tool alone, and a client hook refuses a direct edit where the client reliably supports one (WS-033 step P1.1e verifies this first). Every derived file is generated from its one source by its tool, never kept by hand; a check regenerates it and fails when the stored copy is stale, so no file depends on an agent remembering to update it. A value shared by several files (JSON, PS1, Markdown) has one source and is read or generated everywhere else (DEC-01)."
   Replaced preamble: "Status: in force, accepted by the owner on 2026-10-31 (WS-033 step P1.4); the single source of truth. It consolidates owner decisions D1-D101 of the old log, Owner-Tools/records/delegation-20261026/DECISIONS.md, which is its archive (new items from D102). WS-033 step P7.4 lands this file as docs/DECISIONS.md. decisions-map.tsv, beside this file, gives every D-number its entry, Expired or History. Find an entry: `grep -n '^## DEC-' DECISIONS.md`, then read that entry only. Each entry stands alone."

   ## D107 2026-11-01 Owner: each plan step names who runs it and the least costly model and effort that fits it, and its estimated time

   Owner's request after WS-033 step P1.5d (2026-11-01 about 18:50 Cairo), verbatim:

   > Could you add an additional column to the table in the interactive map (https://claude.ai/artifact/6c2tqrmwBN2JFZBcfj2kpD)—alongside the existing columns for "Step," "State," "Do," "Expect," and "If not"—that specifies the optimal model and the appropriate level of effort required to execute each step efficiently? This would help prevent the waste of tokens that occurs when using agents with a higher level of "intelligence" (and cost) than what the specific task actually demands.
   >
   > Additionally, please include another column indicating the estimated time required to complete each step.

   Claude main asked how the column should relate to DEC-18 (options: Claude per step with Codex fixed; per step for Codex too; display only). Owner's answer, verbatim:

   > Claude per step, Codex too, The column shows who runs each step - but if you can't chose the right Codex model or his effort becuse he is a deferant campany - keeps the last Sol model with high effort fixed ( only if codex avilabul ) or you take over his role until his reset come back

   Reading: every plan step names who runs it (Claude main, Codex, a script Claude main runs, or the owner) and a model family and effort, plus an estimated time; the status page shows both. Claude main cannot switch its own model and DEC-15 bars cheaper subagents, so the owner switches the session (/model, then s for this session only; /effort) before pasting the step's resume message, which names both. Codex: Claude main cannot verify which Codex model or effort is right for a step (another company's models, no official ranking available offline, DEC-19 keeps Codex off the internet), so its steps keep the latest Sol model at high; when Codex is unavailable or at its limit, Claude main takes the role, labelled, until it is back (DEC-19). Model facts used: the claude-api skill's model table (cached 2026-10-06: Fable 5.1 most capable at 10/50 USD per million tokens, Opus 5.5 4/20, Sonnet 5.5 2/10, Haiku 5.5 0.10/0.50; effort low, medium, high, xhigh, max) and the Claude Code model configuration page (code.claude.com/docs/en/model-config, read 2026-11-01: /model with s for this session only, /effort; Opus 5.5, Sonnet 5.5 and Haiku 5.5 default to medium).
   Now in: DEC-18.
   Replaced wording, DEC-18: "Codex: every run uses the latest verified Sol-family model at effort high, fixed, with no per-task choice. Claude main: the session's existing default model and effort; nothing hardcodes a Claude effort. Reusable rules name a model family, never a version. Before each run the model and effort are verified from the CLI's own model list (Delegate picks the newest visible Sol model from Codex's model cache) and from the run's recorded runtime; a model is never substituted or downgraded silently; each run record keeps the exact model identifier and effort used, as history, never as a future requirement. Code value: the effort of lib/Delegate.ps1 (from slice S6: high, the only effort of the engineering profile; today its default is still medium) carries this ID, and test-delegate compares it with this entry."
   Replaced wording, DEC-18 Scope and Why: "every Codex run and every Claude session." / "the owner fixed one model and effort for Codex, and copies of older values had drifted."

   ## D108 2026-11-02 Owner: batches by shared files, the cheaper of compact and clear, tracked savings, and one status page per account

   Owner, after S4 part 1 began (2026-11-02, Cairo), verbatim:

   > The status page
   > The link: https://claude.ai/artifact/6c2tqrmwBN2JFZBcfj2kpD
   > This page belongs to my previous account.
   >
   > I have two separate accounts for Claude,
   >
   > and one account for Codex.
   >
   > However, the usage quota for my first Claude account was exhausted,
   >
   > so I had to switch to another Claude account that still had an available quota.

   Claude main asked how saves should handle the page. Owner's answer: "New page each account (Recommended)".

   > It seems that each "clear" operation consumes a significant number of tokens and a large amount of context. I suspect that "clear" is not very efficient; is "compact" a more efficient alternative?
   >
   > Additionally, could you clarify which option avoids re-reading the same files—essentially starting from scratch? I want to eliminate any waste caused by repeatedly re-reading the same files, and I also want to avoid carrying around an ever-growing, heavy context throughout a session.

   > You can also search through GitHub repositories, global scripts, and connected MCP (Model Context Protocol) servers to leverage them for reducing the amount of context that needs to be re-read—whether within the files themselves or throughout the session. Examples include tools like Serena or Caveman, as well as repositories that utilize interactive local maps, which make it easier to link files and their internal sections to one another.

   > It is possible to group each execution phase—along with its interconnected internal steps—together, provided they involve the same files. Once processed, these can be finalized using either a "compact" or "clear" operation, depending on which yields greater resource savings. I am looking for an optimization methodology and an interactive roadmap—including the most suitable models and the level of effort required for each phase—that serves as a guiding philosophy to minimize resource consumption as much as possible.

   Claude main recommended P1.6 first with a Serena trial, and S7 beside S4 and S11. Owner, verbatim:

   > ok i approveyour Recommendation, continue to minimam File's Times read & Track patterns to reduce consumption and achieve savings as you progress.

   Now in: DEC-18, DEC-29; the method in ARCHITECTURE section 14.3; the batches in PLAN section 7.
   Owner, later on 2026-11-02, verbatim:

   > try to Finish P1.5 together

   Claude main asked for the order. Owner's answer: "P1.6, then all of P1.5 (Recommended)": the rest of P1.5 runs as one job, saved after each part, stopping only for a blocker or to ask for /compact near 200k.

   Owner, later on 2026-11-02, verbatim:

   > i want to do compact or clear whatever which the best before start every Slice or Step like P1.5

   So the parts inside a slice run with no stop; before every slice or step Claude main stops, names the cheaper of the two by ARCHITECTURE section 14.3, and gives the resume message.

   ## D109 2026-11-03 Owner: no automated agent loop for the rest of WS-033; Probe-Guard not run; S6 and S8 stay

   Claude main asked, with choices, the questions saved in NOW.md after S11 stopped at the usage limit. Owner's choices: Probe-Guard: "Accept record (Recommended)": lib/hooks/Probe-Guard.ps1 is not run, prototype/s11/guard-session-probe.md is S11's proof, and Hunt keeps GAP guard-probe-stale. S7: "New Claude main session (Recommended)". Cost: "Lower effort once on S5" and "One slice per 5-hour window". Owner's clarification, verbatim:

   > Cancel all automated agent-loop development and execution for the remainder of WS-033.
   > All remaining slices must run through manually started Claude main sessions. I will select the model and effort myself.
   > Preserve the existing WS-033 acceptance criteria, mandatory tests, and security gates.
   > Do not remove S6 or S8 requirements merely to save tokens.
   > Apply cost reductions only when they do not weaken required functionality or verification.
   > For S7, verify the retention boundary and deletion scope before allowing any destructive operation.
   > Do not introduce new orchestration, automatic retries, or background agent sessions.
   > Prioritize completing WS-033 through the shortest safe path, reusing verified evidence and existing checkpoints.

   Now in: DEC-15; the slice order, the cost choices and S7's precondition in PLAN sections 2, 6 and 7.

   Replaced wording, DEC-15, Why: "fresh subagents re-read the same files at high cost with little gain." Changed: 2026-10-31.
   ## D111 2026-11-03 Owner: S11 accepted; the two loop files retired to records; the OneDrive question deferred

   Number: D109 was taken twice in decisions-map.tsv. The constitution row of 2026-11-02, with no heading here, is now D112, because the map's key check refused the duplicate in S7's real check; D110 is its pair, also with no heading, so this entry is D111. Owner, verbatim:

   > S11 is accepted as completed based on its saved attempt-2 evidence. Continue the existing WS-033 plan without redesigning it.
   > 1. Leave the OneDrive files with secret-suggesting names untouched. Do not open, move, rename, delete, or modify them. Defer this decision.
   > 2. Retire `lib/Invoke-Sessions.ps1` and `lib/test-invoke-sessions.ps1` from executable/test-discovery paths by preserving them under records, with hashes and provenance. Do not destroy evidence or weaken mandatory tests.
   > 3. The automated agent loop is cancelled. Do not reactivate, repair, replace, or extend it.
   > 4. Use only manually started Claude main sessions. I control model and effort selection.
   > 5. Preserve DEC-15, all mandatory gates, and the existing WS-033 scope.
   > Before any destructive operation, verify the exact retention boundary, deletion targets, preservation requirements, and safeguards using the existing plan and evidence.
   > Do not run `lib/Invoke-Sessions.ps1` or `lib/hooks/Probe-Guard.ps1`.

   Now in: DEC-15 (unchanged wording); records/WS-033/open-items.tsv; records/WS-033/retired/invoke-sessions/PROVENANCE.md; records/WS-033/prototype/s7/boundary.md.

   ## D113 2026-11-03 Owner: all remaining WS-033 execution in the main session; /clear or /compact by the evidence

   Owner, verbatim:

   > Effective immediately, all remaining WS-033 execution must take place directly in the main Claude session.
   > Do not create, invoke, delegate to, or rely on any subagent for WS-033. All implementation, investigation, testing, verification, review, and checkpoint operations must be performed within the main session. Do not use headless Claude sessions, automated agent launches, or background agent execution. I will manually select the model and effort level for each main session.
   > Abandon the automated agent-loop approach for WS-033 entirely. Do not develop, repair, optimize, or reactivate the loop. Do not replace it with another orchestration mechanism. Do not introduce automatic retries, autonomous session switching, or agent scheduling. Safely retire loop-specific execution components while preserving historical evidence and avoiding unrelated changes.
   > Do not blindly prefer either /clear or /compact.
   > Prefer /clear when: A verified checkpoint and complete handoff are available. The next task can be resumed safely from persisted evidence. Carrying the existing conversation context would create unnecessary token consumption. A fresh session would preserve continuity without sacrificing correctness.
   > Prefer /compact when: The current execution depends on important active context not yet fully persisted. Clearing would risk losing essential reasoning, evidence, or continuity. Compaction is demonstrably more efficient than rebuilding the required context.
   > Treat these as decision guidelines subordinate to the actual constitutional rules, not replacements for them. Never use /clear before saving required state and verifying the resume path.
   > This directive changes only the execution mechanism for WS-033. It does not authorize changing the project's objectives, scope, constitutional requirements, or acceptance criteria.

   Now in: DEC-15 (unchanged wording); records/WS-033/retired/invoke-sessions/PROVENANCE.md; memory owner-compact-handoff-message.md for /clear and /compact.

   ## D114 2026-11-04 Owner: startup token options deferred; findings and scripts kept under records/WS-033

   Owner, verbatim:

   > Do not disable DeepWiki or change any MCP, plugins, hooks, or tools during WS-033. Defer all proposed optimizations.
   > Preserve the useful measurement scripts and a concise findings report under `records/WS-033`, after checking for secrets. Avoid unnecessary files or duplication.
   > Then continue P2.3 as approved, without delays or workflow changes.
   > Apply Earn It & Worth It. English only; times Cairo.

   Now in: records/WS-033/startup-tokens/FINDINGS.md; records/WS-033/open-items.tsv.

   ## D115 2026-11-04 Owner: same session through V3 and the reviews, stop before P5; the 200k alert alone forces no change

   Owner, verbatim:

   > I prefer continuing in the current Claude session through V2 completion, V3, and the required reviews, stopping only before entering the selected Draft into the sandbox (P5).
   > Preserve the approved sequence, evidence, tests, and review gates. Do not merge or skip steps.
   > The 200k context alert alone should not force a session change if continuing is technically supported and safe. Apply D108 to determine whether `/clear` or `/compact` is genuinely necessary.
   > If a hard limit or another proven blocker prevents continuation, save state and report it.
   > No push, no Claude subagents, and no workflow redesign. English only; Cairo time.

   Now in: this session's run of P2.3 to P4.3; NOW.md.

   ## D116 2026-11-04 WS-033 P4: one Claude main self-review suffices when Codex is unavailable

   The owner's words:

   > The normal workflow requires two reviews: Claude Main (P4.1) and Codex (P4.2).
   > If Codex is unavailable due to its usage limit, **one thorough Claude Main self-review is sufficient**. Do not perform two reviews using the same agent, as this adds cost without providing independent judgment.
   > Record P4.2 as **SKIPPED — Codex unavailable**, not PASS or independently reviewed. Document the reason and preserve all mandatory tests and gates.
   > Apply this rule to the current WS-033 review without changing unrelated workflow requirements.
   > Complete P4.1, then stop before P5.1 as agreed. English only; times Cairo.

   Now in: PLAN.md P4.2; the V3 Draft's Review Gate; REVIEW-CODEX.json, which records the skip. This replaces, for this review only, the earlier reading that Claude main takes P4.2 under DEC-19.

   ## D117 2026-11-04 Owner: WS-033 P7 answers; guard workarounds must not recur

   The owner's words:

   > Owner decisions — WS-033 P7:
   >
   > 1. **YES:** Draft one narrowly scoped contract covering P7.2b tracked writes and T10. Include privacy classification, secret scanning, backup integrity, and existing governance. Drafting only; P7.2b execution is NOT authorized.
   > 2. **YES:** Run P7.2 once using the approved command and correct map path. Verify `NO-OP VERIFIED`; stop if unexpected writes or failures occur.
   > 3. **ACKNOWLEDGE ONLY:** Record the DEC-28 direct-copy issue. Previous guard workarounds were not acceptable and must not recur. Do not authorize guarded writes or bypasses implicitly. Establish an explicitly permitted, hash-verified one-time procedure in the proposed contract before requesting execution approval.
   > 4. **YES:** Keep L02 at P7.3, preserving Save-Checkpoint and all required dependencies.
   > 5. **DEFER:** Address the 21 long paths at P7.5. Preserve the evidence and do not weaken acceptance criteria or rename files without verification.
   >
   > Also retain the follower-cutover risk and verify it at the appropriate stage.
   >
   > Continue the approved P7.2 verification and contract preparation only. Do not begin P7.2b, migration writes, or unrelated changes without separate authorization.
   >
   > Apply Learn Before Guessing, Earn It & Worth It, and Simplify Without Weakening. Preserve evidence and report actual blockers.
   >
   > Do not recommend `/clear` or `/compact` unless justified by D108 and actual context needs.
   >
   > English only; Cairo time.

   Now in: records/WS-033/p7/FINDINGS-4.md and contract-draft/DRAFT-0.md (a proposal). DEC-28's text is unchanged; no guarded write is authorized by this entry.

   ## D118 2026-11-04 Owner: WS-035 preparation decisions (given 19:00 Cairo)

   The owner's words:

   > **Owner Decisions — WS-035 Preparation**
   >
   > I approve the following directions, subject to verification:
   >
   > 1. **DIRECTIVE.md — Option A, narrowly scoped.** Preserve the owner's frozen text byte-exact. Limit any Markdown Guard exemption to verified, hash-pinned owner texts, not all files under `docs/owner`. Retain applicable structural, path, organizer, reference, and orphan checks. Add focused tests and mutants. This preserves owner authority without broadly weakening governance.
   >
   > 2. **CRLF pins — Option A.** Preserve the original three files byte-exact with their original hashes in `data/records`. Use verified LF copies for Git and update only the corresponding pins, with both versions and their relationships documented. Do not silently alter originals.
   >
   > 3. **V1/V2 ownership — Codex under DEC-13**, after verifying actual availability. Claude Main handles V3 and its assigned review. Do not automatically extend WS-033's D116 review exception to WS-035. If Codex remains unavailable, report the specific fallback decision required.
   >
   > Additional requirements:
   > - Complete privacy classification of the 21 flagged files before any public commit; a clean Gitleaks scan alone is insufficient.
   > - Resolve the `LOG.tsv` scan through an authorized method. Do not bypass guard refusals by rewriting commands.
   > - Preserve provenance paragraphs unless their removal is demonstrably necessary.
   > - Record the unexplained 22nd long path for P7.5 without premature renaming.
   > - Keep WS-035's scope minimal. Verify the proposed contract against existing governance and avoid expanding it into P7.3–P7.5 without separate approval.
   >
   > **Authorization boundary:** These decisions authorize contract drafting and verification only, not guard deployment, repository writes, P7.2b migration, or publication.
   >
   > Continue the approved preparation, identify any proven blockers, and present the next required authorization.
   >
   > Apply Learn Before Guessing, Earn It & Worth It, and Simplify Without Weakening. Recommend `/clear` or `/compact` only when justified under D108.
   >
   > English only; Cairo time.

   Now in: records/WS-033/p7/FINDINGS-5.md and contract-draft/DRAFT-1.md (a proposal). Archived late, by the Edit tool as D119 allows; the words come from session transcript 26d3ccda-7d96-49ca-90b5-cf8856bbd333, message 217921ef-0241-444f-9b39-532cf5735a64. The first attempt was refused by G02 (FINDINGS-5 section 6). DEC-13's text is unchanged.

   ## D119 2026-11-04 Owner: WS-035 answers to B1, P1, B3 and B4; P7.21 and P7.22 only

   The owner's words:

   > Resume WS-033 P7.21. Read lines 1-3 of ORVION-Workbench\work\RESUME-HERE.md, then ORVION-Owner-Tools\records\WS-033\p7\FINDINGS-5.md section 7.
   > Owner answers: (1) D118: yes, Edit tool, words from the transcript named in line 1. (2) Codex at its limit: wait for the reset. (3) Privacy: mask both values in the 9 summaries; keep own-finish-receipt.json out of Git, pinned at its original in data/records. (4) DEC-12: P7.2b's backup and P7.5's restore count; WS-035 holds read-only validation only.
   > Do P7.21 and P7.22 only: record the answers, apply them to DRAFT-1, write the V1 brief, launch through Delegate as the availability test. No guard deployment, repository write, P7.2b or publication. English only; Cairo time.

   Now in: records/WS-033/p7/contract-draft/DRAFT-1.md and PLAN.md P7.21 and P7.22. For WS-035 only, (2) replaces the step of DEC-19 where Claude main takes a Codex step at once (DEC-02); the texts of DEC-12, DEC-13 and DEC-19 are unchanged. Answer (2) is superseded by D120; the other three stand.

   ## D120 2026-11-04 Owner: automatic Codex fallback is the standing policy; D119's wait superseded; one Claude review when Codex is at its limit

   The owner's words, the policy sections verbatim (given about 19:55 Cairo; the full message is in the session transcript 3ee36884-7612-4c58-91b3-e0458fd2df60):

   > My previous instruction to wait for Codex's quota reset was incorrect. **Do not wait for Codex.**
   >
   > This is an intended standing principle of our agent workflow, not a new architecture or a WS-035-only exception.
   >
   > Codex remains the preferred delegate for V1 and V2.
   >
   > At each genuine Codex delegation point:
   >
   > 1. Attempt Codex through the approved Delegate mechanism.
   > 2. If Codex is available, use it normally.
   > 3. If Codex is unavailable because its quota is exhausted, **Claude Main immediately assumes the assigned V1/V2 work**.
   > 4. Preserve the required Prototype, V1, V2, V3, sandbox, Finish, testing, and release gates.
   > 5. Label the fallback transparently, including the actual author, model, effort, and reason.
   > 6. Do not wait for quota resets, repeatedly retry known unavailable capacity, or require another owner decision merely to activate this fallback.
   >
   > This exception lasts only while Codex is unavailable. Restore normal delegation automatically once Codex becomes available.
   >
   > If Codex remains unavailable at its review point:
   >
   > - Complete **one Claude Main review only**.
   > - Mark the Codex review explicitly **SKIPPED — Codex quota unavailable**.
   > - Do not substitute a second Claude review.
   > - Do not claim an independent Codex review occurred.
   > - Preserve all other mandatory tests and gates.
   >
   > If Codex is available, perform both reviews normally.
   >
   > D119's WS-035-specific waiting instruction does not represent my standing policy and is superseded by this clarification.
   >
   > Since Codex's latest actual availability test established quota exhaustion, use that evidence rather than making another redundant attempt solely to rediscover the same limit.
   >
   > **Execution boundary:** This directive authorizes the approved WS-035 drafting workflow and its automatic author fallback. It does not authorize guard deployment, original repository migration writes, P7.2b, public release, or bypassing any mandatory gate.

   Now in: DEC-19 and DEC-18 already carry the fallback for V1 and V2. DEC-14 does not carry the review arrangement, and docs/DECISIONS.md is tracked, so its correction waits for separate approval; proposed text in records/WS-035/GOVERNANCE-FINDINGS.md. Until then this entry is the authority (DEC-02).

   ## D121 2026-11-04 Owner: WS-035 execution approval, P7.25 only, with six answers

   The owner's words:

   > Resume WS-035 at P7.25. Read lines 1-3 of ORVION-Workbench\work\RESUME-HERE.md. Owner answers: (1) Approved: WS-035 V3, Draft SHA-256 B0E4A3F8DD4CE1ED6E04A83FDB0F9F6E29676A87617AD3AFE33107A49600E54E, sandbox first, then Original Root C:\Users\My Lab\Documents\GitHub\ORVION-Workbench, commits stay local. (2) Yes, the literal step may land the docs/history/LOG.tsv bytes Organize wrote once. (3) Yes, lib/Invoke-ContractLifecycle.ps1, its dryrun over WS-033 first. (4) Yes, row B and the fence exceptions. (5) Edit tool accepted for those generator edits. (6) The new-to-public values in V3\REPORT.md may be published. Record these in the archive first. No push, P7.26, P7.2b or guard deployment. Save and republish the status page at every stop and end each stop with the next model, effort, /clear or /compact and resume message. English only; Cairo time.

   Now in: records/WS-035/assurance/V3/DRAFT.md (unchanged) and its execution. (2) is the naming that the Draft's Implementation Steps require for DEC-28's narrower reading; DEC-28's text is unchanged. (5) confirms the method of V2/REPORT.md for those edits and grants no other write. (6) allows those values to be in the contract's commits; publication itself stays at P7.26 under its own approval.

   ## D122 2026-11-04 Owner: Option A, a scoped exception to the WS-033 dryrun refusal; P7.25 sandbox only, stop before the live review

   The owner's words, the decision and boundary sections verbatim (given about 22:55 Cairo; the full message is in the session transcript fbffb2ee-a2a0-4492-93cc-d33069314e55):

   > **Owner Decision: APPROVE OPTION A — SCOPED EXCEPTION ONLY.**
   >
   > I approve continuing with the existing `lib/Invoke-ContractLifecycle.ps1` at its baseline bytes.
   >
   > The WS-033 DryRun failure is acknowledged and accepted **only as a scoped exception to that historical compatibility check**.
   >
   > Evidence indicates:
   >
   > - WS-033 contained 8 deletions that the controller could not represent.
   > - WS-033 introduced 10 scripts that the controller could not handle.
   > - WS-035 has 30 additions, 5 modifications, zero deletions, and no newly added scripts.
   > - The Original-role prediction mismatch was not independently isolated; its proposed cause remains a hypothesis.
   > - The patched diagnostic copy passed the Sandbox role but did not establish a PASS for the baseline tool.
   >
   > **Do not record the WS-033 DryRun as PASS.**
   >
   > This approval is not permission to bypass any native acceptance gate or ignore a failure occurring on WS-035 itself.
   >
   > Keep the controller unchanged.
   >
   > Record the precise exception, its evidence, its limitations, and this owner authorization in the approved decision archive.
   >
   > Preserve the controller limitations as open items for future contracts involving deletions or newly added scripts, including WS-034.
   >
   > After Sandbox Finish and its required inspection, **STOP before the live review**.
   >
   > **Not authorized:** original-checkout implementation, P7.26, P7.2b, Git push, release, guard deployment outside the explicitly approved sandbox, or unrelated repository changes.

   The exception, precisely. Excepted: only the requirement in the frozen Draft's Objective and D121 answer (3) that the controller's dryrun over WS-033 come first. Its result stays REFUSED, both roles, exit 1, LIFECYCLE_DRYRUN_PATHS_DIFFER:implement (records/WS-035/dryrun-ws033/dryrun-sandbox.txt, dryrun-original.txt); it is not a PASS and the tool's dryrun has never passed on a real workstream at these bytes. Evidence: records/WS-035/dryrun-ws033/FINDINGS.md. Limitations: the patched copy proves nothing about the tool; the prediction refusal's cause is a hypothesis; no live stage has run on this tool, so WS-035 itself may still refuse, and any refusal on WS-035 stops the run. Not excepted: every native gate, every WS-035 stage result, and any contract that deletes files or adds scripts (records/WS-033/open-items.tsv, WS-034 included).

   Now in: records/WS-035/gate/ (this authorizes the sandbox Gate record), the plan's P7.25 row and open-items.tsv. D121's approval of the original root stands in its words, but D122 withholds the original stage until the owner gives it. DEC entries are unchanged.
   ```

   The resulting file's Git blob is 39a0d07b93a17b903e1d126767894b3b35699008.

4. Check whether `docs/history/DECISIONS-MAP.tsv` contains `d	date	status	now_in	reason`; if so record Already Applied when its Git blob is f2a208da4dae859196802d9b4f6b49d0dbea98a2, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-036 candidate output), and change nothing else:

   ```text
   d	date	status	now_in	reason
   D1	2026-10-26	History	-	WS-015 and the Founder CR contract shape; both delivered
   D2	2026-10-26	DEC	DEC-05	Shared Evidence waived as a closure prerequisite, not earned
   D3	2026-10-26	DEC	DEC-05	CTRL-19 open with its residual risk accepted
   D4	2026-10-26	DEC	DEC-05	Lift point; contract C2 (clean-Windows recovery) dropped when the reinstall was cancelled
   D5	2026-10-26	DEC	DEC-09 DEC-27	key custody ended by D10 (DEC-27); the never-expose-a-key rule is in DEC-09
   D6	2026-10-26	DEC	DEC-27	Marketing-MCP and non-ORVION transcripts are not packaged
   D7	2026-10-26	Expired	DEC-20	parallel evaluation of the delegate skills, ended by D8 and D9
   D8	2026-10-26	DEC	DEC-20	--ignore-user-config; Codex Windows sandbox not working; skills not installed
   D9	2026-10-26	DEC	DEC-20	unrestricted Codex mode with the owner-accepted residual risk
   D10	2026-10-26	DEC	DEC-27	plain unencrypted package synced to OneDrive
   D11	2026-10-26	DEC	DEC-27	no key; upload at its step; the scan identifies only
   D12	2026-10-26	History	DEC-02	one session's permission to continue unattended; its no-new-scope rule is in DEC-02
   D13	2026-10-26	DEC	DEC-27	scan findings by path and rule only; transcripts verbatim; gh revocation after a reinstall
   D14	2026-10-26	History	DEC-11 DEC-23	WS-015 Finish attempt 1 refused; continuity mirror moved to work\continuity
   D15	2026-10-26	DEC	DEC-22 DEC-25	an owner's interactive confirmation is never emulated
   D16	2026-10-26	History	DEC-22 DEC-25	one-time SPEC-298 release through the native engines
   D17	2026-10-26	History	-	WS-016 map delivered; the tool's contract is in lib/README
   D18	2026-10-26	History	-	WS-016 delegated Gate 1 and the two reports
   D19	2026-10-26	DEC	DEC-03 DEC-17	tools must really work and earn their cost; WS-017 itself is history
   D20	2026-10-26	DEC	DEC-12 DEC-19 DEC-26	bundle goals; Codex proves with evidence; save continuously; its push rule was replaced by D90 (DEC-25)
   D21	2026-10-26	DEC	DEC-03 DEC-24	fix every bug seen; two jobs at once where safe; WS-019 itself is history
   D22	2026-10-26	DEC	DEC-11 DEC-23	a fresh Finish attempt after an attempt that ran no test
   D23	2026-10-26	History	-	WS-020 contract
   D24	2026-10-26	DEC	DEC-14 DEC-19	one rebuttal round for a rejected Codex item; the WS-021 contract is history
   D25	2026-10-26	DEC	DEC-23 DEC-24	a fresh attempt after a measured resource block; no heavy job beside a Finish
   D26	2026-10-27	DEC	DEC-05 DEC-27	reinstall cancelled; criterion 5 amended; clean-Windows install UNPROVEN; the UTC assurance date is enforced by the native judge
   D27	2026-10-27	DEC	DEC-04 DEC-08 DEC-19	Batch 6 waits for the owner's lift; rebuildable temporary; no duplicate documents; two-way Codex; three folders and the xhigh ceiling replaced (DEC-08, DEC-18)
   D28	2026-10-27	DEC	DEC-20	Delegate is the one Codex launcher and its tripwire detects only; the WS-025 contract is history
   D29	2026-10-27	History	DEC-22 DEC-25	one-time release method for the two Step 2 SPECs
   D30	2026-10-27	History	DEC-24 DEC-25	Step 2 concurrency; its resource rules are in DEC-24
   D31	2026-10-27	DEC	DEC-12 DEC-13 DEC-14	Draft purposes, diffs, selection table, no manufactured differences; authors replaced (DEC-13)
   D32	2026-10-27	DEC	DEC-21	Codex input rules; its fresh-session-per-phase part changed by D87
   D33	2026-10-27	DEC	DEC-13 DEC-16 DEC-20	multi_agent=false (as corrected by D37) and the sources format; Codex authorship and web search expired
   D34	2026-10-27	DEC	DEC-05 DEC-10 DEC-13 DEC-16 DEC-17 DEC-18	query and web-content rules (F2); tools first; F1 and the model addendum expired; F3-F5 history
   D35	2026-10-27	DEC	DEC-01 DEC-02	memory holds pointers (C4) and owner words are carried faithfully (C5); back-pointers (C2) replaced by D101; Codex audit role expired
   D36	2026-10-27	DEC	DEC-16 DEC-20 DEC-21	Codex memories off per run; the global AGENTS.md override is guidance only; WS-026 to WS-028 approvals are history
   D37	2026-10-28	DEC	DEC-03 DEC-20	sub-agent prevention never claimed; minimal safe solutions over rescue complexity; WS-029 order is history
   D38	2026-10-28	DEC	DEC-05 DEC-10 DEC-12 DEC-13 DEC-14 DEC-15 DEC-16 DEC-18	tier by risk; dual review, one V4, gates over agreement; Terra research and subagent V3 expired; order replaced (DEC-04)
   D39	2026-10-28	DEC	DEC-15 DEC-18	no silent downgrade and verified effective effort; the max level and the subagent fallback expired
   D40	2026-10-28	DEC	DEC-15 DEC-18	model by family, exact identifiers only in run records; the WS-029 V3 approval is history
   D41	2026-10-28	DEC	DEC-11 DEC-18	records hold no fixture trees; the xhigh level expired
   D42	2026-10-28	History	DEC-18	WS-029 V3 run at Sol high
   D43	2026-10-28	DEC	DEC-10	restore staging kept and reported; disposal is the owner's; Candidate C is history
   D44	2026-10-28	History	DEC-22	WS-030 delegated diagnostic succession
   D45	2026-10-28	DEC	DEC-22 DEC-25	no invented REMOTE_CERTIFY; the WS-030 promotion is history
   D46	2026-10-28	DEC	DEC-05 DEC-11	same-machine launcher proof PASS for criterion 5
   D47	2026-10-28	History	DEC-19	Codex in Claude roles for WS-026 only
   D48	2026-10-29	History	DEC-02 DEC-03	WS-026 V3 continuation; "choose the best" grants judgment, not scope
   D49	2026-10-29	History	-	WS-026 sandbox admission
   D50	2026-10-29	History	-	WS-026 original admission
   D51	2026-10-29	History	DEC-25	WS-026 preflight publication
   D52	2026-10-29	History	DEC-25	WS-026 one-time promotion authority
   D53	2026-10-29	History	DEC-25	WS-026 promotion verified
   D54	2026-10-29	History	DEC-02	WS-031 bootstrap choice
   D55	2026-10-29	History	DEC-19	WS-031 Sol author substitution
   D56	2026-10-30	History	-	WS-031 sandbox admission
   D57	2026-10-30	History	-	WS-031 original admission
   D58	2026-10-30	History	DEC-05	WS-031 completion; its open risks are in DEC-05
   D59	2026-10-30	History	DEC-25	WS-031 preflight publication
   D60	2026-10-30	History	DEC-25	WS-031 promotion
   D61	2026-10-30	History	DEC-16	WS-032 research-profile correction; the profile is retired
   D62	2026-10-30	History	DEC-16 DEC-26	WS-032 stop; the V3 and Finish hold was released by D63
   D63	2026-10-30	History	-	release of the D62 hold
   D64	2026-10-30	History	DEC-16	WS-032 read-only feasibility check
   D65	2026-10-30	History	DEC-02 DEC-03	WS-032 namespace-trial authority
   D66	2026-10-30	History	DEC-16	WS-032 namespace trial failed
   D67	2026-10-30	DEC	DEC-04	stay on the roadmap with no new unit or framework; the WS-032 diagnostic is history
   D68	2026-10-30	History	DEC-04 DEC-16	WS-032 deferred (now retired); the WS-027-only source-pack exception was used; its sequence was replaced
   D69	2026-10-30	History	-	WS-027 start; the Terra transport was refused
   D70	2026-10-30	History	DEC-18	all WS-027 roles at Sol high
   D71	2026-10-30	DEC	DEC-23 DEC-26	save after every pass; no journal append or heavy copy during a native Finish
   D72	2026-10-30	History	DEC-19	Claude took over the Codex role for WS-027 V3
   D73	2026-10-30	DEC	DEC-14 DEC-15 DEC-19	the interim usage-limit rule became standing (D100); authors never review their own subject; Opus subagent reviews expired
   D74	2026-10-30	Expired	DEC-14	one review for WS-027 V3, replaced by D75
   D75	2026-10-30	DEC	DEC-14 DEC-22	no weakened tests, suppressed failures, frozen edits or unverified PASS; WS-027 Option 1 is history
   D76	2026-10-30	Expired	DEC-19	bypass Codex until its reset, replaced by D77 and D100
   D77	2026-10-30	DEC	DEC-14 DEC-19 DEC-23	a passed check is not rerun; the Codex bypass was lifted by D83
   D78	2026-10-30	History	DEC-27	WS-027 actions on the real repository
   D79	2026-10-30	DEC	DEC-02 DEC-04 DEC-27	autonomy rules; 60-minute backup limit; its order was changed by D96
   D80	2026-10-31	History	DEC-14	WS-028 V5 exception
   D81	2026-10-31	Expired	DEC-15 DEC-18	medium effort for Claude subagents, replaced by D83 and D85
   D82	2026-10-31	DEC	DEC-14 DEC-18	Codex latest Sol at high; the WS-028 V6 is history
   D83	2026-10-31	DEC	DEC-01 DEC-04 DEC-06 DEC-18 DEC-19	WS-033 designation and scope; Claude default effort; instructions updated in place
   D84	2026-10-31	DEC	DEC-10 DEC-14	manual check before a C1 run that informs deletion; the WS-028 V7 is history
   D85	2026-10-31	DEC	DEC-14 DEC-15	no Claude subagents; labelled self-reviews
   D86	2026-10-31	DEC	DEC-24	no free-commit buffer above the native minimum
   D87	2026-10-31	DEC	DEC-01 DEC-06 DEC-08 DEC-10 DEC-13 DEC-14 DEC-15 DEC-17 DEC-21 DEC-26	plan refinement points 1-7; point 8 (index and rules file) replaced by D101 (DEC-01)
   D88	2026-10-31	DEC	DEC-01 DEC-02 DEC-03 DEC-06 DEC-08 DEC-10	organizers, one folder tool, deletion authority; the per-decision split replaced by D101
   D89	2026-10-31	DEC	DEC-08 DEC-09	two folders, fixed by D90
   D90	2026-10-31	DEC	DEC-08 DEC-09 DEC-25	public repository, push per workstream, data/ and the vault
   D91	2026-10-31	DEC	DEC-02 DEC-06	WS-033 approved; ARCHITECTURE.md mandatory; improvements through its section 22
   D92	2026-10-31	History	DEC-25	R1 preflight publication of WS-027 and WS-028
   D93	2026-10-31	History	DEC-25	R1 stopped on the hosted failure; main not promoted
   D94	2026-10-31	DEC	DEC-06 DEC-12 DEC-25	S0 inside WS-033; release at P6.2; the portability check
   D95	2026-10-31	DEC	DEC-03 DEC-06 DEC-07 DEC-08	fix every gap; be informed before acting; personal OneDrive files untouched; S10; the TEMP gap
   D96	2026-10-31	DEC	DEC-04 DEC-07 DEC-12	tiers and purpose checks; WS-034; the order
   D97	2026-10-31	DEC	DEC-06 DEC-08 DEC-21	the WS-033 fixes; read-only learning from CRM and ORVION
   D98	2026-10-31	DEC	DEC-18	Codex always at the latest Sol, effort high, fixed
   D99	2026-10-31	DEC	DEC-06 DEC-08 DEC-32	signposting (P1.1d); the Workbench may read and index CRM and ORVION
   D100	2026-10-31	DEC	DEC-01 DEC-13 DEC-14 DEC-15 DEC-16 DEC-19 DEC-21	one source of truth; Codex offline; Claude main research, prototype and V3; Codex never blocks; no subagents; the brief
   D101	2026-10-31	DEC	DEC-01 DEC-06	consolidate into one updated decision per subject, never layered
   D102	2026-10-31	DEC	DEC-01 DEC-13 DEC-14	the owner accepted the consolidated file; the V3 review and the V3 purpose confirmed
   D103	2026-11-01	DEC	DEC-03 DEC-08 DEC-09 DEC-10 DEC-11 DEC-27 DEC-28 DEC-29	compact GitHub, OneDrive for the last 7 backups only, nothing kept only as history, a fourth principle, guards and self-updating files, a plan with a status page
   D104	2026-11-01	DEC	DEC-10 DEC-27	the WS-029 test package deleted in WS-033 step P8; the Lift's restore package kept until the Lift; package retention through Organize -Clean
   D105	2026-11-01	DEC	DEC-20	Codex confined by the MXC sandbox (workspace-write, writable roots the clone and the run folder), refused when MXC is unavailable, the tripwire kept
   D106	2026-11-01	DEC	DEC-02 DEC-03 DEC-04 DEC-11 DEC-12 DEC-16 DEC-19 DEC-20 DEC-22 DEC-28 DEC-30 DEC-31 DEC-32	the owner's standing rules found outside DECISIONS.md (P1.3 TO-DEC), the CRM rows L05, L06, L12, L16, L21, L28 and the signposting design given their home by slice S1
   D107	2026-11-01	DEC	DEC-18	each plan step names who runs it and the least costly model family and effort that fits, Codex on the latest Sol at high unless a per-step choice can be verified, Claude main taking Codex's role while it is unavailable; each step's estimated time on the status page
   D108	2026-11-02	DEC	DEC-18	open steps run in batches by the files they share, ended by the cheaper of compact and clear, with reads tracked at each save; P1.6 first with a Serena trial and S7 beside S4 and S11; each Claude account keeps its own status page (DEC-29)
   D112	2026-11-02	DEC	DEC-33	the owner offered 25 rules as the general constitution of ORVION; words in records/WS-033/owner-constitution-20261102.md; numbered D109 until the map's key check refused the duplicate on 2026-11-03
   D110	2026-11-02	DEC	DEC-33	the owner asked for 31 proposed rules examined and the best form adopted: twelve rules; DEC-30 restored; the map of every name is in records/WS-033/owner-constitution-20261102.md
   D109	2026-11-03	DEC	DEC-15	no automated agent loop, headless session, automatic retry or background agent session for the rest of WS-033; each slice in a Claude main session the owner starts, on the model and effort the owner selects; Probe-Guard not run; S6 and S8 not cut merely to save tokens
   D111	2026-11-03	DEC	DEC-15	S11 accepted; the two loop files retired to records with hashes and provenance; the OneDrive question deferred; only Claude main sessions the owner starts
   D113	2026-11-03	DEC	DEC-15	all remaining WS-033 execution directly in the main session: no subagents, headless or background agents, automatic retries, session switching or scheduling; /clear or /compact chosen on the evidence, under the constitutional rules
   D114	2026-11-04	History	-	startup token options deferred, no MCP, plugin, hook or tool change during WS-033; findings in records/WS-033/startup-tokens/FINDINGS.md
   D115	2026-11-04	History	-	WS-033 P2.3 to P4.3 in one Claude main session, stop before P5; the 200k alert alone forces no session change; D108 still decides any /clear or /compact
   D116	2026-11-04	History	-	WS-033 P4: Codex at its usage limit, so one thorough Claude main self-review suffices; P4.2 recorded SKIPPED, Codex unavailable, never PASS or independent; all tests and gates kept; stop before P5.1
   D117	2026-11-04	History	-	WS-033 P7 answers: P7.2b contract drafting, P7.2 run, guard workarounds must not recur; DEC-28 text unchanged
   D118	2026-11-04	History	-	WS-035 preparation decisions
   D119	2026-11-04	History	-	WS-035 answers to B1, P1, B3 and B4; P7.21 and P7.22 only
   D120	2026-11-04	DEC	DEC-14 DEC-19	automatic Codex fallback is the standing policy; one Claude review when Codex is at its limit (written into DEC-14 by D124)
   D121	2026-11-04	History	-	WS-035 execution approval, P7.25 only, with six answers
   D122	2026-11-04	History	-	Option A, a scoped exception to the WS-033 dryrun refusal; P7.25 sandbox only
   D123	2026-11-07	DEC	DEC-04 DEC-07 DEC-13 DEC-23	G1-G4: WS-033 then the Owner Lift then STOP, WS-034 deferred; product SPECs follow only their own lifecycle; attempt rules for Workbench Finishes
   D124	2026-11-07	DEC	DEC-14 DEC-19 DEC-20	D-11: D120 written into DEC-14 and DEC-19; DEC-20 narrative shortened
   D125	2026-11-07	DEC	DEC-01 DEC-26	P7.3 and P7.4: archive, old log and map in docs/history; Save-State the one save method
   ```

   The resulting file's Git blob is f2a208da4dae859196802d9b4f6b49d0dbea98a2.

5. Check whether `docs/history/README.md` contains `| DECISIONS-ARCHIVE.md | archive | Decisions archive | - | - |`; if so record Already Applied when its Git blob is 46db8f92d9321c7cf55244fe45b44639d1e18def, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-036 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | --- | --- | --- | --- | --- |
   ```
   insert
   ```text
   | DECISIONS-ARCHIVE.md | archive | Decisions archive | - | - |
   | DECISIONS-LOG.md | archive | Decisions taken under OWNER-DELEGATION.md (append-only) | - | - |
   | DECISIONS-MAP.tsv | archive | - | - | - |
   ```

   b) immediately after the lines
   ```text
   ## History index

   ```
   insert
   ```text
   - [DECISIONS-ARCHIVE.md](DECISIONS-ARCHIVE.md)
   - [DECISIONS-LOG.md](DECISIONS-LOG.md)
   ```

   The resulting file's Git blob is 46db8f92d9321c7cf55244fe45b44639d1e18def.

6. Check whether `docs/RECOVERY.md` contains `Retained extraction is sensitive and unencrypted: owner records, sessions, settings and Git bundles can contain secrets.`; if so record Already Applied when its Git blob is 349ddb26a5dd977c00ad1b1684ed1434459550b1, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-036 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   a linked worktree in a main repository, or files under the one data root's `work\sandboxes`. Commit or remove them only under their owning authority first. Protected records/runtime and required unique evidence remain package inputs; disposable temporary trees are excluded.
   ```
   with
   ```text
   a linked worktree in a main repository, or files under the one data root's `work\sandboxes`. Commit or remove them only under their owning authority first. Protected records, runtime and required unique evidence remain package inputs; disposable temporary trees are excluded.
   ```

   b) replace the line
   ```text
   Retained extraction is sensitive and unencrypted: owner records/sessions, settings and Git bundles can contain secrets.
   ```
   with
   ```text
   Retained extraction is sensitive and unencrypted: owner records, sessions, settings and Git bundles can contain secrets.
   ```

   c) replace the line
   ```text
   records/partial archives can remain for inspection. Only the retention tier prunes archives, by name, never hydrating one; its failure is reported and leaves the backup standing. Scan findings,
   ```
   with
   ```text
   `<root>/records/partial` archives can remain for inspection. Only the retention tier prunes archives, by name, never hydrating one; its failure is reported and leaves the backup standing. Scan findings,
   ```

   The resulting file's Git blob is 349ddb26a5dd977c00ad1b1684ed1434459550b1.

7. Check whether `docs/RUNBOOK.md` contains `One call saves every operation (DEC-26).`; if so record Already Applied when its Git blob is 2c40ce811a58ec21463413a577a9ab1ad52f024c, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-036 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   One call saves every operation once Save-State is live (WS-033 step P7.3, DEC-26); until then the save of DEC-26 holds.
   ```
   with
   ```text
   One call saves every operation (DEC-26).
   ```

   b) replace the line
   ```text
   - Pending decisions are the `## ` headings of `data/decisions-inbox.md`: one heading per owner decision not yet
   ```
   with
   ```text
   - Pending decisions are the `## ` headings of `decisions-inbox.md` in the data root (absent until the first owner decision is captured): one heading per owner decision not yet
   ```

   The resulting file's Git blob is 2c40ce811a58ec21463413a577a9ab1ad52f024c.

8. Check whether `docs/WORKSPACE-LAYOUT.md` contains `└── continuity/             Save-State's small copy of the latest progress: data/work/NOW.md, decisions-inbox.md when present,`; if so record Already Applied when its Git blob is c6d655d8e40f253c1ff4df344f6f28320aa4525a, and otherwise stop and report. Otherwise make exactly these 16 edits (land this exact frozen WS-036 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   └── continuity/             Save-State's small copy of the latest progress: data/work/NOW.md, data/decisions-inbox.md,
   ```
   with
   ```text
   └── continuity/             Save-State's small copy of the latest progress: data/work/NOW.md, decisions-inbox.md when present,
   ```

   b) replace the line
   ```text
   | a new owner instruction or decision | `data/decisions-inbox.md` (the owner's words verbatim, appended) and a line in NOW.md | Claude main | the same turn |
   ```
   with
   ```text
   | a new owner instruction or decision | `decisions-inbox.md` in the data root (the owner's words verbatim, appended; absent until the first one) and a line in NOW.md | Claude main | the same turn |
   ```

   c) replace the lines
   ```text
   | a workstream's summary: result, receipt, one line per failure, its cited files | `records/WS-0NN/README.md` (tracked) | the Complete step | at the end |
   | the files of a workstream that are cited (section 23) | `data/records/WS-0NN/`; every other file of `sb/W<NN>/` is deleted by `-Clean` (DEC-11) | the close step | after its push |
   ```
   with
   ```text
   | a workstream's summary: result, receipt, one line per failure, its cited files | `records/WS-<NN>/README.md` (tracked) | the Complete step | at the end |
   | the files of a workstream that are cited (section 23) | `data/records/WS-<NN>/`; every other file of `sb/W<NN>/` is deleted by `-Clean` (DEC-11) | the close step | after its push |
   ```

   d) replace the line
   ```text
   `records/WS-0NN/`. The vault is not managed: only Backup-Workspace (with the retention tier it runs) and Save-State
   ```
   with
   ```text
   `records/WS-<NN>/`. The vault is not managed: only Backup-Workspace (with the retention tier it runs) and Save-State
   ```

   e) replace the line
   ```text
   | `sb/W<NN>/`, `cx/W<NN>-*`, `scratch/W<NN>-*`, `codex-relay-logs/W<NN>-*` | until workstream `NN` is Complete and pushed and its cited files are hash-verified in `data/records/WS-0NN/` or their content is in pushed Git history | deleted by `-Clean` |
   ```
   with
   ```text
   | `sb/W<NN>/`, `cx/W<NN>-*`, `scratch/W<NN>-*`, `codex-relay-logs/W<NN>-*` | until workstream `NN` is Complete and pushed and its cited files are hash-verified in `data/records/WS-<NN>/` or their content is in pushed Git history | deleted by `-Clean` |
   ```

   f) replace the line
   ```text
   | owner decisions not yet in DECISIONS.md | `data/decisions-inbox.md` and the "Pending decisions" list in NOW.md | Claude main | injected with NOW.md |
   ```
   with
   ```text
   | owner decisions not yet in DECISIONS.md | `decisions-inbox.md` in the data root, when present, and the "Pending decisions" list in NOW.md | Claude main | injected with NOW.md |
   ```

   g) replace the line
   ```text
   | workstream summary (result, receipt, failures, cited files) | `records/WS-0NN/README.md` | the Complete step | audits |
   ```
   with
   ```text
   | workstream summary (result, receipt, failures, cited files) | `records/WS-<NN>/README.md` | the Complete step | audits |
   ```

   h) replace the line
   ```text
   - The old log D1-D101 is kept byte-exact in `docs/history/`; the archive's map gives every D-number its DEC-NN,
   ```
   with
   ```text
   - The old log D1-D122 is kept byte-exact as `docs/history/DECISIONS-LOG.md`; `docs/history/DECISIONS-MAP.tsv` gives every D-number its DEC-NN,
   ```

   i) replace the lines
   ```text
     most 12 lines).
   - Until P7.4 the file is records/WS-033/DECISIONS.md, with decisions-map.tsv beside it (DEC-01).
   ```
   with
   ```text
     most 12 lines).
   ```

   j) replace the line
   ```text
   2. `records/WS-0NN/README.md` is its one summary (DEC-11): the result and the receipt (verbatim, with its SHA256), each
   ```
   with
   ```text
   2. `records/WS-<NN>/README.md` is its one summary (DEC-11): the result and the receipt (verbatim, with its SHA256), each
   ```

   k) replace the lines
   ```text
      with its SHA256 and its path under `data/records/WS-0NN/`.
   3. After the push and release, the cited files of `sb/W<NN>/` are copied to `data/records/WS-0NN/` and hash-checked
   ```
   with
   ```text
      with its SHA256 and its path under `data/records/WS-<NN>/`.
   3. After the push and release, the cited files of `sb/W<NN>/` are copied to `data/records/WS-<NN>/` and hash-checked
   ```

   l) replace the line
   ```text
   folder goes to `data/records/WS-0NN/` until the Lift's C1 pass.
   ```
   with
   ```text
   folder goes to `data/records/WS-<NN>/` until the Lift's C1 pass.
   ```

   m) replace the line
   ```text
   through its `records/WS-0NN/README.md`.
   ```
   with
   ```text
   through its `records/WS-<NN>/README.md`.
   ```

   n) replace the line
   ```text
   NEW DECISION owner --> data/decisions-inbox.md + NOW.md "Pending decisions"
   ```
   with
   ```text
   NEW DECISION owner --> decisions-inbox.md (data root) + NOW.md "Pending decisions"
   ```

   o) replace the lines
   ```text
   WS END       summary --> records/WS-0NN/README.md; push through the release checks;
                cited files --> data/records/WS-0NN; Organize -Clean deletes the W<NN> items in temporary
   ```
   with
   ```text
   WS END       summary --> records/WS-<NN>/README.md; push through the release checks;
                cited files --> data/records/WS-<NN>; Organize -Clean deletes the W<NN> items in temporary
   ```

   p) replace the line
   ```text
      `data/decisions-inbox.md` if it changes a decision; a line in NOW.md.
   ```
   with
   ```text
      `decisions-inbox.md` (data root) if it changes a decision; a line in NOW.md.
   ```

   The resulting file's Git blob is c6d655d8e40f253c1ff4df344f6f28320aa4525a.

9. Check whether `lib/Organize.ps1` contains `foreach($inputs in [IO.Path]::Combine($places.workbench,'docs\owner\recovery-inputs\recovery-inputs.json')){`; if so record Already Applied when its Git blob is fbea7a35d71c1281ba790d70a9745c97b94f5023, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-036 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
       foreach($inputs in [IO.Path]::Combine($places.workbench,'docs\owner\recovery-inputs\recovery-inputs.json'),[IO.Path]::Combine($places.data,'records\recovery-inputs\recovery-inputs.json')){
   ```
   with
   ```text
       foreach($inputs in [IO.Path]::Combine($places.workbench,'docs\owner\recovery-inputs\recovery-inputs.json')){
   ```

   The resulting file's Git blob is fbea7a35d71c1281ba790d70a9745c97b94f5023.

10. Check whether `lib/Save-State.ps1` contains `# NOW.md unless given; pending decisions are the ## headings of decisions-inbox.md in the data root; Running is stated at every`; if so record Already Applied when its Git blob is 858d59dafa547503d1df6e95c8b145bee7990dfb, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-036 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   # NOW.md unless given; pending decisions are the ## headings of data/decisions-inbox.md; Running is stated at every
   ```
   with
   ```text
   # NOW.md unless given; pending decisions are the ## headings of decisions-inbox.md in the data root; Running is stated at every
   ```

   b) replace the line
   ```text
   if(Test-Path -LiteralPath $inbox){$copies+=,@('data/decisions-inbox.md',$inbox)}
   ```
   with
   ```text
   if(Test-Path -LiteralPath $inbox){$copies+=,@("data/$(Split-Path $inbox -Leaf)",$inbox)}
   ```

   c) immediately after the line
   ```text
   $continuity=Join-Path $Vault 'continuity';$stage="$continuity.new";$previous="$continuity.old"
   ```
   insert
   ```text
   # A stop between the two moves below leaves continuity.old as the only whole copy: it is restored, never deleted (F1).
   if(!(Test-Path -LiteralPath $continuity)-and(Test-Path -LiteralPath $previous)){[IO.Directory]::Move($previous,$continuity)}
   ```

   The resulting file's Git blob is 858d59dafa547503d1df6e95c8b145bee7990dfb.

11. Check whether `lib/test-save-state.ps1` contains `function New-MismatchSave([string]$Name){`; if so record Already Applied when its Git blob is 892e5f60ebadb21460e32af770cdb5e99a7829dd, and otherwise stop and report. Otherwise make exactly these 4 edits (land this exact frozen WS-036 candidate output), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
           Assert-Save ((Get-SaveSnapshot $Fixture)-ceq$before) 'a refused save wrote';throw $message}
   }
   ```
   insert
   ```text
   function New-MismatchSave([string]$Name){
       # A copy that alters each file it writes, injected into a copy of the script under test, stands in for a file
       # written to during the copy.
       $source=[IO.File]::ReadAllText($SaveState);$anchor='[IO.File]::Copy($copy[1],$target)';if(!$source.Contains($anchor)){throw 'SAVE_INJECTION_STALE'}
       $folder=Join-Path $scratch $Name;[void][IO.Directory]::CreateDirectory($folder)
       Copy-Item -LiteralPath (Join-Path (Split-Path $SaveState -Parent) 'Test-MarkdownConsistency.ps1') -Destination $folder
       $injected=Join-Path $folder 'Save-State.ps1';[IO.File]::WriteAllText($injected,$source.Replace($anchor,$anchor+";[IO.File]::AppendAllText(`$target,'x')"),[Text.UTF8Encoding]::new($false))
       $injected
   }
   ```

   b) replace the lines
   ```text
           # A copy that alters each file it writes, injected into a copy of the script under test, stands in for a file
           # written to during the copy; the previous continuity copy must stay whole and no staging folder may remain.
           $source=[IO.File]::ReadAllText($SaveState);$anchor='[IO.File]::Copy($copy[1],$target)';if(!$source.Contains($anchor)){throw 'SAVE_INJECTION_STALE'}
           $folder=Join-Path $scratch 'injected';[void][IO.Directory]::CreateDirectory($folder)
           Copy-Item -LiteralPath (Join-Path (Split-Path $SaveState -Parent) 'Test-MarkdownConsistency.ps1') -Destination $folder
           $injected=Join-Path $folder 'Save-State.ps1';[IO.File]::WriteAllText($injected,$source.Replace($anchor,$anchor+";[IO.File]::AppendAllText(`$target,'x')"),[Text.UTF8Encoding]::new($false))
           $before=Get-VaultState $f
   ```
   with
   ```text
           # The previous continuity copy must stay whole and no staging folder may remain.
           $injected=New-MismatchSave 'injected';$before=Get-VaultState $f
   ```

   c) immediately after the line
   ```text
           try{$null=Invoke-Save $f @{} $injected}finally{Assert-Save ((Get-VaultState $f)-ceq$before) 'the previous continuity copy changed'}})
   ```
   insert
   ```text
       continuityRestore=@('SAVE_CONTINUITY_MISMATCH',{$f=New-SaveFixture 'restore'
           # F1: a stop between the two moves leaves continuity.old as the only whole copy; the next save restores it first,
           # so even a refused save leaves it whole.
           $old=[IO.Path]::Combine($f.Vault,'continuity.old','kept');[void][IO.Directory]::CreateDirectory($old);[IO.File]::WriteAllText((Join-Path $old 'a.txt'),'last whole copy')
           $injected=New-MismatchSave 'restoreInjected';$kept=[IO.Path]::Combine($f.Vault,'continuity','kept','a.txt')
           try{$null=Invoke-Save $f $first $injected}finally{Assert-Save ((Test-Path -LiteralPath $kept)-and!(Test-Path -LiteralPath (Join-Path $f.Vault 'continuity.old'))-and[IO.File]::ReadAllText($kept)-ceq'last whole copy') 'the leftover continuity.old was not restored'}})
   ```

   d) immediately after the line
   ```text
               planStepColumn='throw "SAVE_PLAN_STEP_COLUMN: $($Entry.Row[0]) has no $Like column"'
   ```
   insert
   ```text
               continuityRestore='if(!(Test-Path -LiteralPath $continuity)-and(Test-Path -LiteralPath $previous)){[IO.Directory]::Move($previous,$continuity)}'
   ```

   The resulting file's Git blob is 892e5f60ebadb21460e32af770cdb5e99a7829dd.

## Acceptance Criteria

- [ ] Output `docs/DECISIONS.md` equals its declared resulting Git blob. check: blob:docs/DECISIONS.md=93bf9b907ac80ca284ab5d995400c391dd5cca2e
- [ ] Output `docs/history/DECISIONS-ARCHIVE.md` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-ARCHIVE.md=6593a98b8f7fa2a467e25c634d7d99c90b16f9aa
- [ ] Output `docs/history/DECISIONS-LOG.md` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-LOG.md=39a0d07b93a17b903e1d126767894b3b35699008
- [ ] Output `docs/history/DECISIONS-MAP.tsv` equals its declared resulting Git blob. check: blob:docs/history/DECISIONS-MAP.tsv=f2a208da4dae859196802d9b4f6b49d0dbea98a2
- [ ] Output `docs/history/README.md` equals its declared resulting Git blob. check: blob:docs/history/README.md=46db8f92d9321c7cf55244fe45b44639d1e18def
- [ ] Output `docs/RECOVERY.md` equals its declared resulting Git blob. check: blob:docs/RECOVERY.md=349ddb26a5dd977c00ad1b1684ed1434459550b1
- [ ] Output `docs/RUNBOOK.md` equals its declared resulting Git blob. check: blob:docs/RUNBOOK.md=2c40ce811a58ec21463413a577a9ab1ad52f024c
- [ ] Output `docs/WORKSPACE-LAYOUT.md` equals its declared resulting Git blob. check: blob:docs/WORKSPACE-LAYOUT.md=c6d655d8e40f253c1ff4df344f6f28320aa4525a
- [ ] Output `lib/Organize.ps1` equals its declared resulting Git blob. check: blob:lib/Organize.ps1=fbea7a35d71c1281ba790d70a9745c97b94f5023
- [ ] Output `lib/Save-State.ps1` equals its declared resulting Git blob. check: blob:lib/Save-State.ps1=858d59dafa547503d1df6e95c8b145bee7990dfb
- [ ] Output `lib/test-save-state.ps1` equals its declared resulting Git blob. check: blob:lib/test-save-state.ps1=892e5f60ebadb21460e32af770cdb5e99a7829dd
- [ ] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [ ] AC-01 Decision text: docs/DECISIONS.md is at most 40960 B after LF normalisation and passes the Markdown guard with this contract in place. Its changed entries are exactly the preamble, DEC-01, DEC-04, DEC-07, DEC-13, DEC-14, DEC-19, DEC-20, DEC-23 and DEC-26, each stamped Changed: 2026-11-07 with its archive item in History, and the file equals the approved text A3 (SHA256 D77C3A5CAF67EA95C9FE00AF2A69AD7D75BF329BB9A1DD266873D12C65C54F18).
- [ ] AC-02 Old log: docs/history/DECISIONS-LOG.md has SHA256 BFCE37BF30C2E09BFB8E5D9C459A7B0CE08AE1E238CB0FC12A107DF4CC3DE955, equal to its original in ORVION-Owner-Tools/records/delegation-20261026/DECISIONS.md, which stays in place.
- [ ] AC-03 Archive and map: docs/history/DECISIONS-ARCHIVE.md holds items D123, D124 and D125, each with the owner's words or approval verbatim, the replaced wording verbatim and a Now in: line naming existing DEC entries; docs/history/DECISIONS-MAP.tsv has one row for each of D1-D125 and every DEC row names existing entries; no archive item is dangling.
- [ ] AC-04 F1: lib/Save-State.ps1 restores a leftover continuity.old before the delete loop; the restore runs only when continuity is absent, and continuity.old is its sibling in the vault, so Directory.Move meets no existing destination and crosses no volume; lib/test-save-state.ps1 passes on this role's checkout with the case continuityRestore and its mutant killed; no existing assertion is weakened or removed.
- [ ] AC-05 Paths: Organize -Check runs once on this role's checkout and once on a disposable clone at the baseline, both read-only and with the same data root and temporary root; exit and lines by class are recorded as an observation. Compared with the baseline run, the inbox lines, the WS-<NN> placeholder lines, docs/RECOVERY.md lines 29, 79 and 169 and lib/Organize.ps1:479 print no BROKEN_PATH, and no line is added.
- [ ] AC-06 Transitions: docs/RUNBOOK.md and docs/WORKSPACE-LAYOUT.md carry no "until P7.3" or "Until P7.4" wording; DEC-26 names lib/Save-State.ps1 as the one save method; docs/history/README.md lists the two new Markdown files in its History index.
- [ ] AC-07 Secrets and privacy: gitleaks on the exact candidate range reports 0 findings apart from 5 sourcegraph-access-token matches in docs/history/DECISIONS-LOG.md at lines 43, 550, 554, 572 and 581, each a 40-hex Git object ID named as a commit or blob in its sentence, listed as a false positive with that sentence; no inline allow marker and no ignore file is added, because the old log is carried byte-exact and an ignore fingerprint names a commit that differs between the sandbox, the Original and the release; on this contract every finding is that same rule on a 40-hex Git object ID (the baseline, a blob pin or an old-log line carried inline), because the rule matches any 40 hex digits once a file holds its keyword, as the inline old log and this criterion do; neither masked value (the computer name, a marketing tunnel script name) is in any new or changed tracked file or in this contract.
- [ ] AC-08 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in measurements.tsv (failures too), and a live review of its own receipt and criteria. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json.
- [ ] AC-09 Boundary: no Save-State run on the real data root, no continuity file, no Owner-Tools change, no CRM or ORVION change, no push or release under this contract. Commits stay local (DEC-25).

## Review Gate

- [ ] Inspect the live subject, this role's fresh receipt, timing and watching evidence, and every criterion above, with attempts, deviations and gaps kept visible. No prototype result or earlier receipt substitutes for this role's gate.
- [ ] Review: one Claude-main self-review, labelled as such and never called independent, and the Codex review (DEC-14). Codex at its usage limit or unable to dispatch at that point: its review is recorded SKIPPED, never replaced or claimed, and Claude main's is the only one (D120). At most one corrective version; a remaining material disagreement goes to the owner.
- [ ] Retro (DEC-12): Claude main, and Codex if it reviewed, name what does not satisfy them, each item with a remedy and a check.

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Execution Log

Append only. No approval, execution-root binding or receipt is claimed. At actual approval add exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line using actual immutable identities. Owner evidence must name the approved digest and execution root. For original execution append exactly one Sandbox Receipt and Sandbox Receipt SHA256 for the matching successful schema2 sandbox artifact. A delegated decision needs actual live owner delegation and is labelled delegated. Never invent human confirmation or approval.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-036\assurance\V3\DRAFT.md
Approved SHA256: ACAF65CF201CDCB563A498CFB4D72917B5A0A42D69E459507BD6C2A5EFF0361C
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-036\gate\GATE1-WS036-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: 5C5B4CF6E91E420275F46C48C9688931E6B318A82A43FDA2900DDEB9F9A5087B
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W36\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 13F0209A82A7D466F6A9CFEA8F9602405832297DAF8DAB1E365CBB0F8B8FBE01

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W36-draft. Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete, release or real Save-State has run in this preparation. Draft-time proof is in claude-draft-check.json and REPORT.md beside this Draft. After Complete, outside this contract: the first real Save-State (P8.3) writes the continuity file and is the only proof of the live save; the release is its own stage (DEC-25). The plan's P7.3 Expect names the first continuity file; this contract writes none, so that part of the Expect is met at P8.3, after the release, and P7.3 is Done when this contract is Complete and released. V3 sources and selection table: STANDARDS-CHECK.md and REPORT.md beside this Draft.
