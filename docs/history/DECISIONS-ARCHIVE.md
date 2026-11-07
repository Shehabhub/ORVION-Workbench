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
