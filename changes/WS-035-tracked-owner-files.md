# Workbench Change Request - WS-035

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Put P7.2b's tracked files in the Workbench through the native lifecycle: the owner's texts in docs/owner, the recovery inputs and their map, one summary per finished workstream in records, and the T10 organizers with their log. Benefit: the backup and P7.5 can run from a clean checkout that holds the essential files (DEC-08), and the three later places have their organizers.

Tier: Significant under DEC-12. It changes recovery inputs and their pins, publishes owner texts in a public repository once released, and narrows one Markdown guard check by exact hash. Authority: DEC-08, DEC-09, DEC-10, DEC-11, DEC-12, DEC-13, DEC-14, DEC-19, DEC-22, DEC-23, DEC-25, DEC-26 and DEC-28, with the owner's archive decisions D117, D118, D119 and D120. Native checks prevail; no evaluator or applier change is included.

Number: WS-034 is reserved by DEC-04 and DEC-07, so this takes WS-035; the owner approved one contract (D117) and it runs before WS-034 inside P7. Intended contract: changes/WS-035-tracked-owner-files.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: lib/Invoke-ContractLifecycle.ps1 at this baseline, from one WS-035 manifest in the Runtime Root's parent, its dryrun over WS-033 first. Native Workbench.ps1 and the pinned evaluator keep every authority. This is the tool's first live use, so any stage that does not print its expected result stops the run.

## Baseline

9a33100b0720435aa0a55b922eeb6ba3065a2027

## Write Scope

- docs/history/LOG.tsv
- docs/history/README.md
- docs/owner/20261026-delegation/OWNER-DIRECTIVE-INTERACTIVE-MAP.md
- docs/owner/20261026-delegation/OWNER-DIRECTIVE-UNENCRYPTED-CONTINUITY.md
- docs/owner/20261031-owner-directive-improvement-ws/DIRECTIVE.md
- docs/owner/20261031-owner-directive-improvement-ws/OWNER-AUTHORITY-20261031.md
- docs/owner/20261031-owner-directive-improvement-ws/OWNER-REFINEMENT-20261031.md
- docs/owner/20261031-owner-directive-improvement-ws/OWNER-TWO-FOLDERS-20261031.md
- docs/owner/README.md
- docs/owner/recovery-inputs/batch6-hold-directive.json
- docs/owner/recovery-inputs/OWNER-APPROVAL-AB.txt
- docs/owner/recovery-inputs/OWNER-DECISION-20261027-evidence-and-trusted.md
- docs/owner/recovery-inputs/OWNER-DECISION-20261027-no-reinstall.md
- docs/owner/recovery-inputs/OWNER-DELEGATION.md
- docs/owner/recovery-inputs/OWNER-DIRECTIVE-REINSTALL.md
- docs/owner/recovery-inputs/owner-main-approval-ws013.txt
- docs/owner/recovery-inputs/OWNER-REQUEST-DELEGATE-SKILLS.md
- docs/owner/recovery-inputs/README.md
- docs/owner/recovery-inputs/recovery-inputs.json
- docs/owner/recovery-inputs/ws013-hosted-acceptance.json
- docs/README.md
- docs/WORKSPACE-LAYOUT.md
- lib/test-markdown-consistency.ps1
- lib/Test-MarkdownConsistency.ps1
- records/README.md
- records/WS-022/README.md
- records/WS-023/README.md
- records/WS-025/README.md
- records/WS-026/README.md
- records/WS-027/README.md
- records/WS-028/README.md
- records/WS-029/README.md
- records/WS-030/README.md
- records/WS-031/README.md
- records/WS-032/README.md
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Organize.ps1, lib/Backup-Workspace.ps1, lib/Restore-Workspace.ps1 and lib/hooks/Guard-Write.ps1 keep baseline bytes; changes/README.md is not refreshed; no weakened test or assertion (DEC-22); no CRM, ORVION, credentials, real sessions or events (DEC-08, DEC-09); the P7.2b data copy, memory junctions, the backup task and backup run; P7.3 to P7.8 and their tracked writes; any push (DEC-25); any file named own-finish-receipt.json under docs/owner (D119). Long paths wait for P7.5: nothing is renamed. No correction of docs/DECISIONS.md: the flagged DEC-14 and DEC-19 wording needs its own approval.

## Draft Assurance

V1: WS035-V1-CLAUDE-FALLBACK-DESIGN-20261104-01 | 2026-11-04 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-035\assurance\V1\DRAFT.md | A9F2989C64D46AEC53524B3C70AD5996B87126FEDC4603D905FCC1B67C5FC905
V2: WS035-V2-CLAUDE-FALLBACK-ADVERSARIAL-20261104-01 | 2026-11-04 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-035\assurance\V2\DRAFT.md | 804F60E0F61020017322BA953A88003E8C01F1DA7C95049AF9AD3A6C7CC16742
V3: WS035-V3-CLAUDE-REFRESH-20261104-01 | 2026-11-04 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-035\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V3 EVIDENCE REFRESH by Claude main under DEC-13, binding the frozen V1 and V2 digests above; each was frozen and hashed before the next began (assurance\V1\FROZEN.json, assurance\V2\FROZEN.json). Author of V1 and V2: Claude main, claude-opus-5-5, under the automatic fallback of DEC-19 and the owner's D120, because Codex is at its usage limit (first and only launch 2026-11-04 19:46 Cairo, records/WS-035/codex/V1-run). V2 is a same-session V2 by the author of V1. All three are one author's work: nothing here is independent, and no Codex work is claimed. Sources and selection table: assurance\V3\STANDARDS-CHECK.md and assurance\V3\REPORT.md.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W35\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W35\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W35\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-035\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order; where a step has more than 26 edits its letters cycle after z. Every payload is inline, so replay needs no source file. docs/history/LOG.tsv is the one generated log carried as bytes: a second Organize run would give new timestamps, and the fingerprint covers every tracked blob. DEC-28 lets only Organize write that file. Organize wrote these bytes, once, in the authoring clone; this literal step lands them unchanged, and after it only Organize writes the file. That is a narrower reading than DEC-28's words, so the owner's execution approval must name it; without that the step does not run.

1. Check whether `docs/history/LOG.tsv` contains `utc	action	place	from	to	workstream	reason	sha256`; if so record Already Applied when its Git blob is 3ad4c5529aed70a2789d7afa78e2f503a14ca389, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   utc	action	place	from	to	workstream	reason	sha256
   2026-11-04T17:40:34Z	new	workbench	-	docs/owner	WS-035	T10 organizer	807FFCC05AE1A10C3AF272BDEE21E9716B567912433778A7A19454C9EED8F38F
   2026-11-04T17:40:35Z	new	workbench	-	docs/owner/recovery-inputs	WS-035	T10 organizer	0BF128053B2F9F68FC9A2EC8B6117894583663BA9F8B25F4774D197745AB4F64
   2026-11-04T17:40:36Z	new	workbench	-	records	WS-035	T10 organizer	EFB622ECE54329E9C34270666CE4CE0FCA0E1433CF8304D81B5BA4638C0ED369
   2026-11-04T17:40:36Z	new	workbench	-	records/WS-022	WS-035	T10 organizer	644144150EFAFEEF5222261FFB00D2FC0436B0A4A0F94B0FDC8CAFB6CA92151E
   2026-11-04T17:40:37Z	new	workbench	-	records/WS-023	WS-035	T10 organizer	224F086CFB17A0B723DD525430414DF425BF8C2AB4D03A7D76199DA8FC8A51E0
   2026-11-04T17:40:38Z	new	workbench	-	records/WS-025	WS-035	T10 organizer	F549CB55F9781BC3E88838DE94AEDE2512604839BF3FD6E6F1637D21EC8C5C92
   2026-11-04T17:40:39Z	new	workbench	-	records/WS-026	WS-035	T10 organizer	92D75F011ADE77691572981138B74F00D9F0B6E9AD5C67A0AF6C7E945A34DE3E
   2026-11-04T17:40:39Z	new	workbench	-	records/WS-027	WS-035	T10 organizer	C9855D1F8B0778F8181267497A1AE4CD3860B2D34C7E01E242A3D24928CF03C3
   2026-11-04T17:40:40Z	new	workbench	-	records/WS-028	WS-035	T10 organizer	91B5894951E9FA8A044E8519B64DDAE652A90AE0151172BF7EC1AFEF3292CFCA
   2026-11-04T17:40:41Z	new	workbench	-	records/WS-029	WS-035	T10 organizer	807B47D66530F50DAE19E123DED8461F91CBED9D4C16CD5D403C4A55457320D2
   2026-11-04T17:40:41Z	new	workbench	-	records/WS-030	WS-035	T10 organizer	4E349C9D6FB0FCD2E54EB08B8876AB0C4829918092D831322F7843C350A7F70F
   2026-11-04T17:40:42Z	new	workbench	-	records/WS-031	WS-035	T10 organizer	C02B7BFDD9CB4EAE615D5EFCADD65F89B47C64EAA4013F228C99B199498F88FF
   2026-11-04T17:40:43Z	new	workbench	-	records/WS-032	WS-035	T10 organizer	AA6E8C16A5D661F7D4AD40B0665902C463F9E46BDBA971EC03B4F0752F51E797
   2026-11-04T17:40:43Z	new	temporary	-	.	WS-035	T10 organizer	FA8AFE6858BE34C8435BA5BE1E7AE7008B419A1BA9C5A61CFB9755E3FAA6B1BE
   2026-11-04T17:40:44Z	new	temporary	-	tools	WS-035	T10 organizer	DE6B5ACE9F75E27AAEBC67AA3C889EC7435B641D96621215E72FF9709CFFC309
   2026-11-04T17:40:45Z	new	temporary	-	sb	WS-035	T10 organizer	C9FCE25B3622C5A7E221DE6E3C884FF23F8B99EB2C08406570428E642F9E316E
   2026-11-04T17:40:45Z	new	temporary	-	cx	WS-035	T10 organizer	7833B2DCD7084B93CF0935A5DA37815D5C372AE7625701DB082CC233E0C40B4A
   2026-11-04T17:40:46Z	new	temporary	-	scratch	WS-035	T10 organizer	450D374F7ABACE609602F17161E87289B1D7D423CDFFBB3DFA80BBBC93A360B0
   2026-11-04T17:40:47Z	new	temporary	-	codex-relay-logs	WS-035	T10 organizer	DC72B10B84ED59EA0B248B3DC2A3E2F56231AEF083A0DEF5F0220514C237F7B2
   2026-11-04T17:40:47Z	new	temporary	-	tmp	WS-035	T10 organizer	5B94BEA2EDCBBAE0F86E6BB298CECA8E276A6D79DB85B6C4DF9411E8CFAC0233
   2026-11-04T17:40:48Z	new	temporary	-	map	WS-035	T10 organizer	2BA018162B9D37297561C2895B363F2080138F2798373FBF274C49347045457C
   2026-11-04T17:40:49Z	new	temporary	-	restore-staging	WS-035	T10 organizer	E08A0610D50EA90C600D1B59EFCDC5EC27783A6AE965985998A3F7BFA4D9962C
   2026-11-04T17:40:49Z	new	data	-	.	WS-035	T10 organizer	2B85AA4924A0EEB076EEE22B40EB557E237C8660F737B9CF2D57DDA38AFB737F
   2026-11-04T17:40:50Z	new	data	-	work	WS-035	T10 organizer	D37FC5B6D5BBB6532A125EFCD58ACF4A311C88C3D0C289003CC13BA35B286522
   2026-11-04T17:40:51Z	new	data	-	sessions	WS-035	T10 organizer	0B8944147C25EAACF40AC24C870C0B5CE14DE51AE0FDDD1D51D409B1FA6E47B9
   2026-11-04T17:40:51Z	new	data	-	records	WS-035	T10 organizer	AEF5DB56DC4B5BF80AF80A5653BD910FB48AD3BD0E4477D78329F0E5231347C6
   2026-11-04T17:40:52Z	new	data	-	events	WS-035	T10 organizer	B9B72CA5449DD7EB3FAE21BC5862C5BB6A6BFC5AFC8EFA6244A00771724A97F6
   ```

   The resulting file's Git blob is 3ad4c5529aed70a2789d7afa78e2f503a14ca389.

2. Check whether `docs/history/README.md` contains `| LOG.tsv | archive | - | - | - |`; if so record Already Applied when its Git blob is d0a49b9091207a7e11100005ea1c981139cbdbc9, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-035 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | --- | --- | --- | --- | --- |
   ```
   insert
   ```text
   | LOG.tsv | archive | - | - | - |
   ```

   The resulting file's Git blob is d0a49b9091207a7e11100005ea1c981139cbdbc9.

3. Check whether `docs/owner/20261026-delegation/OWNER-DIRECTIVE-INTERACTIVE-MAP.md` contains `# Owner message received 2026-10-26 in session b0862c78-8372-43af-b4c1-eee9dd4ef223 (verbatim, Arabic)`; if so record Already Applied when its Git blob is 34b53a6409f8b78c6d7bd0ca9b9e8642df248572, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # Owner message received 2026-10-26 in session b0862c78-8372-43af-b4c1-eee9dd4ef223 (verbatim, Arabic)

   اريد خريطة تفاعليه او ai-map.json للمستودعات الثلاثة توضع فى جذر C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
   يمكنها تحديث نفسها دوريا واكتشاف المستودعات اول باول
   وايضا اريدها بامكانها ان تربط بين الملفات وبعضها كمثل obsidian فى المنهج والفلسفة لتستطيع الادوات والوكلاء فهم الواقع سريعا ولا يتم تيتم اى ملفات او اقسام

   Meaning: an interactive map / ai-map.json of the three repositories in the ORVION-Workbench root; refreshes itself
   periodically and discovers repositories as they appear; links files to each other in the Obsidian manner (links,
   backlinks) so tools and agents grasp reality quickly and no file or section is left orphaned.
   This supersedes the delegation's earlier restriction "Do NOT install the interactive map ... unless independently
   required" for this one feature; it is delivered as one new Workbench contract (WS-016) through the normal workflow.
   ```

   The resulting file's Git blob is 34b53a6409f8b78c6d7bd0ca9b9e8642df248572.

4. Check whether `docs/owner/20261026-delegation/OWNER-DIRECTIVE-UNENCRYPTED-CONTINUITY.md` contains `# Owner messages received 2026-10-26 in session b0862c78-8372-43af-b4c1-eee9dd4ef223 (verbatim, one paste, two directives plus a note)`; if so record Already Applied when its Git blob is 0e847ab8c25314c20c47648a9ccd9eaedf3527f8, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # Owner messages received 2026-10-26 in session b0862c78-8372-43af-b4c1-eee9dd4ef223 (verbatim, one paste, two directives plus a note)

   ---

   # OWNER DIRECTIVE — SIMPLIFIED CLOUD RECOVERY, VERIFIED SYNCHRONIZATION AND PERMANENT AGENT CONTINUITY

   I want to revise the recovery strategy and address several important concerns.

   **My priority is preserving everything valuable before reinstalling Windows, while keeping Workbench lightweight, understandable and maintainable by future agents.**

   ## 1. Change the backup approach

   I do NOT currently want the recovery package encrypted.

   For now, a compressed archive synchronized to my existing OneDrive is sufficient for my preferred recovery workflow.

   Therefore:

   - Do not create an encryption key or ask me to retrieve one now.
   - Do not make key custody a blocker to preparing the backup.
   - Do not upload the original 4 GB collection of largely regenerable artifacts.
   - Preserve everything genuinely irreplaceable, regardless of the final compressed size.

   I understand that encryption would require a key. I am explicitly prioritizing recoverability and simplicity for this backup.

   **However, review the security implications of this change.**

   A non-encrypted archive containing agent sessions may expose credentials, tokens, private information or other sensitive material if the OneDrive account is compromised.

   Identify actual sensitive contents without exposing their values in reports or logs. Do not place plaintext passwords, authentication exports, private keys or production secrets in public GitHub or casually bundle them into an unencrypted cloud archive.

   If essential sensitive material cannot safely be included under this decision, preserve it through an appropriate existing secure recovery method and clearly identify that exception.

   Do not silently claim that an unencrypted archive satisfies Contract C if the governing contract explicitly requires encryption. Identify the smallest legitimate amendment or remaining unmet condition.

   ## 2. Verify GitHub synchronization

   Confirm that every important, appropriate Git-tracked source asset across all three repositories is safely present on its correct GitHub remote.

   Check:

   - Exact local and remote SHAs.
   - Unpushed commits.
   - Uncommitted and untracked valuable files.
   - Important scripts, tools, governance and recovery instructions.
   - Accepted contracts, authoritative plans and relevant documentation.
   - Required version pins and reproducible installation instructions.

   Never assume that a clean working tree means all valuable information is backed up.

   Respect each repository's independent governance and publication authority.

   ## 3. Preserve important non-GitHub data in OneDrive

   For everything important that should NOT be committed to GitHub, establish an organized permanent local data location with a verified synchronized or copied counterpart in OneDrive.

   Include, where appropriate:

   - Valuable Claude/Codex sessions.
   - The event journal and session indexes.
   - Important engineering memory and lessons.
   - Approvals, receipts and unique certification evidence.
   - Frozen historical Drafts and meaningful review records.
   - Unique commits, patches and untracked data from historical clones.
   - Necessary configuration and reconstruction information.
   - Any other irreplaceable engineering knowledge.

   Compress this selectively, excluding only proven regenerable material.

   **Verify actual OneDrive availability, not merely local file existence or a synchronization icon.**

   Where possible, verify the uploaded archive through a separate cloud download and integrity comparison.

   Remember that OneDrive synchronization is not equivalent to independent versioned backup. Preserve a reasonable recovery history without unnecessary duplication.

   ## 4. Address the risks discovered during the audit

   Before declaring recovery readiness, account for these known issues:

   - The original backup missed sessions and the event journal.
   - The original tooling failed against the trusted clone's Git references.
   - Nested clones contained unique states that previous backups omitted.
   - A damaged directory could previously be skipped silently.
   - Approximately 898 versus 900 clone states were reported; reconcile the actual inventory.
   - Historical local commits, uncommitted changes and untracked files require different preservation methods.
   - Existing tests previously passed with synthetic data despite real-machine defects.
   - Marketing-MCP configuration and credentials may be outside the proposed recovery package.
   - Codex currently has broad access to production MCP services; review and restrict unnecessary authority.

   Do not treat the provisional 100 MB estimate, successful isolated tests, or GitHub synchronization as proof of complete recovery.

   **Do not delete or reinstall anything until the real essential-data inventory, cloud recovery and relevant restoration checks are verified.**

   ## 5. The repository must be the agent's memory

   This is especially important.

   **Do not assume that you will be the agent operating ORVION after the Windows reinstall.**

   The next agent may be a completely new Claude Code or Codex session with no memory of your conversations, decisions or implementation history.

   I do not want the continuity of my engineering environment to depend on an agent's intelligence, intuition or ability to reconstruct undocumented history.

   I want the repositories and permanent Workbench data to provide that intelligence and continuity.

   Ensure that the existing README, AGENTS, RESUME, WORKFLOW, Boot and appropriate governance mechanisms provide future agents with clear, enforceable guidance covering:

   - What Workbench is for and what each tool does.
   - Which repository owns each authority.
   - How to discover the current task and true execution state.
   - How to recover accumulated engineering knowledge.
   - When and how to use Hunt, Spider, Pulse, Events, Watcher and Delegate.
   - How tools assist one another and support delegated investigation and repair.
   - How to follow Draft, Gate 1, Finish, Review, Complete, publish and promote correctly.
   - How to identify blockers, previous mistakes and relevant lessons.
   - What may be modified, deferred, deleted or published.
   - How to restore the environment after reinstalling Windows.
   - How to preserve new valuable knowledge for the next agent.

   Use the existing governance framework. Improve missing guidance rather than creating a competing one.

   Future agents should be guided by clear rules, discoverable sources and appropriate automated checks — **not by assumptions about what they already know**.

   Test this through a fresh-agent orientation using only the restored repositories and their documented entry points.

   ## 6. Keep Workbench useful, not bureaucratic

   Workbench tools were created to assist agents and perform useful work on their behalf.

   Hunt should help discover gaps and defects.

   Spider should recover relevant knowledge and evidence.

   Delegate should help distribute suitable engineering tasks.

   Watcher and Monitor should provide reliable operational awareness without unnecessary resource consumption.

   Ensure future agents understand when and how to use these capabilities.

   Avoid forcing expensive operations when their benefit is not justified.

   Preserve the existing working tools and improve their usefulness with minimal changes.

   ## 7. Final priority

   My intended sequence is:

   **Preserve essential knowledge → verify GitHub and OneDrive recovery → establish reliable future-agent instructions → reinstall Windows safely → restore Workbench → resume Batch 6.**

   Keep C2 and CTRL-19 truthful and unresolved until their actual governing requirements are satisfied.

   Do not restart Workbench expansion or create unnecessary contracts.

   Integrate these directions into the currently authorized Hybrid strategy, with the smallest legitimate changes.

   **The final objective is simple: I want to install fresh Windows, recover my repositories and essential Workbench knowledge, open a new agent session, and have that agent understand exactly how to continue working without rebuilding anything valuable or asking me to explain the project again.**

   ---

   **OWNER DIRECTIVE — EVIDENCE-BASED LEARNING, PATTERN DISCOVERY AND CROSS-REPOSITORY INTELLIGENCE**

   I want you and Codex to actively use the existing Workbench tools — particularly **Hunt, Spider, Events, Pulse, and Delegate** — to improve engineering awareness, discover recurring patterns, identify defects, and recognize gaps before they cause failures.

   **Learn from all THREE repositories, not Workbench alone:**

   - `PlatPlusHub/CRM`
   - `Shehabhub/ORVION`
   - `Shehabhub/ORVION-Workbench`

   Study their actual governance, completed and rejected contracts, execution lifecycles, tests, failures, corrections, approvals, certification evidence, and lessons learned.

   **Use successful historical contracts as real engineering examples instead of guessing how something should work.**

   When investigating or implementing a change:

   1. Search for comparable previously executed contracts and proven solutions.
   2. Identify recurring failure patterns, unnecessary complexity, missing safeguards, and reusable engineering techniques.
   3. Use Hunt to detect actionable gaps and Spider to locate their original evidence.
   4. Delegate suitable bounded investigations to Codex for independent analysis and verification.
   5. Cross-check findings against actual code, contracts, tests, receipts, and historical outcomes.
   6. Distinguish **PROVEN FACTS, REASONABLE HYPOTHESES, and UNVERIFIED ASSUMPTIONS**.
   7. Apply useful lessons without blindly copying repository-specific rules or weakening native governance.
   8. Preserve confirmed reusable findings in the appropriate permanent repository knowledge and existing Events/continuity mechanisms.

   Do not invent problems, claim unsupported discoveries, or create unnecessary remediation contracts.

   Do not run exhaustive historical scans on every task. Use targeted searches, existing indexes, and risk-based checks. Proactive Hunt should be bounded, useful, and resource-efficient.

   **Most importantly, make this learning-first behavior discoverable and appropriately enforceable through the existing README, AGENTS, RESUME, Boot, and WORKFLOW mechanisms.**

   Future agents must learn from our accumulated engineering experience rather than restarting from assumptions or depending on previous chat sessions.

   I want Workbench to act as an **engineering intelligence and assistance system**: discovering, learning, delegating, verifying, repairing, and preserving knowledge.

   **The repositories must preserve what the agents have learned; the agents must use that knowledge to become more effective.**

   Integrate this into the approved Hybrid strategy with minimum additional complexity, without delaying the essential recovery work or Batch 6.

   ---

   Note in the same message: "you can use compact to enhance or let codex use compact on you - and try to enhance and improve the way you and codex delegate to better delegate. tell me now are now good time to compact you"
   ```

   The resulting file's Git blob is 0e847ab8c25314c20c47648a9ccd9eaedf3527f8.

5. Check whether `docs/owner/20261031-owner-directive-improvement-ws/DIRECTIVE.md` contains `# ORVION — Owner Authorization for One Consolidated Improvement Workstream`; if so record Already Applied when its Git blob is b79d4fcebf5b1119fa955028d3a34d8cb3ec0ed9, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # ORVION — Owner Authorization for One Consolidated Improvement Workstream

   **Activation:** Immediately after WS-028 is successfully completed, verified, and preserved.

   **Authority:** New explicit Owner Directive.

   **Purpose:** Resolve accumulated documentation conflicts, reduce recurring agent-context waste, improve existing knowledge discovery, and consolidate model/effort governance — without redesigning ORVION or expanding the approved roadmap.

   **Operating philosophy:** Learn Before Guessing · Earn It & Worth It · Simplify Without Diluting · Preserve Mandatory Gates.

   ---

   ## 1. Owner decision — Resolve the deferred-workstream ambiguity

   I am explicitly designating the **ONE Deferred Improvement Workstream** from D79 for the consolidated improvements described in this directive.

   The intended sequence is:

   WS-027 (completed) → WS-028 (complete and certify) → Final Stop Packet → ONE Consolidated Improvement WS → Owner Lift → STOP at Batch 6 threshold.

   Do not begin Batch 6.

   ### Important clarification

   D73 previously identified model-allocation and delegation improvements as candidates for the deferred workstream.

   That was a candidate, not an irrevocable requirement that the workstream address only model delegation.

   I am now explicitly selecting a single bounded improvement workstream covering:

   1. Documentation reconciliation and permanent anti-accumulation controls.
   2. Independent Owner-Tools interactive knowledge map.
   3. Existing Spider discovery coverage expansion.
   4. Brief and automatically loaded context optimization.
   5. Consolidated Claude/Codex model-and-effort governance, including clarification of prior temporary delegation rules.

   These improvements share one underlying objective:

   **Reduce operational ambiguity and repeated context consumption while improving agents' ability to discover and use existing project knowledge.**

   They must be handled as ONE coordinated improvement workstream, not five new workstreams.

   Use the existing Workbench contract, admission, Draft, review, and native lifecycle mechanisms.

   Do not create another architecture, governance platform, knowledge database, or persistent service.

   Do not expand this initiative into an indefinite repository-cleanup programme.

   ## 2. Explicit owner authorization and precedence

   This directive is a new owner-level authorization for the described improvement scope.

   It supersedes older operational restrictions **only where those restrictions would otherwise prevent these specifically approved improvements**.

   This includes applicable earlier:

   - Deferred-improvement selection limitations.
   - Temporary Codex-bypass instructions.
   - Outdated Claude/Codex reasoning-effort requirements.
   - Restrictions that previously prevented work on these particular mapping, discovery, or documentation-maintenance improvements.
   - Earlier planning holds that conflict with implementing this approved consolidated workstream after WS-028.

   ### Codex clarification

   D77 temporarily bypassed Codex until further notice.

   For this improvement workstream, I explicitly lift that bypass **to the extent necessary to use Codex under the new model policy**, provided it is actually available and the existing delegated execution boundary is satisfied.

   If Codex is unavailable, do not wait indefinitely or invent a successful Codex review.

   Use an existing authorized alternative only if it satisfies the governing contract, independence requirements, and native acceptance rules. Otherwise identify the exact blocker.

   Do not generalize historical WS-027-specific exceptions into permanent rules without this directive or another valid owner amendment.

   ### Permission reconciliation

   Review the applicable decisions, especially D17, D27, D31–D41, D70, D73–D79, and the actual operative governance files.

   Identify:

   - Conflicting standing instructions.
   - Temporary restrictions whose scope has expired.
   - Superseded operational requirements.
   - Duplicate active authority statements.
   - Restrictions that still correctly protect evidence, privacy, or native execution.
   - Any required native amendment needed to give this owner decision operational effect.

   Record the new owner directive through the existing decision mechanism.

   **Update mutable operational instructions in place. Preserve historical decision entries verbatim.**

   Do not append contradictory operational paragraphs while leaving obsolete instructions active.

   ### Important safety boundary

   This directive does **not** authorize:

   - Forged owner approvals or Gate 1 digests.
   - Bypassing mandatory native gates or required status checks.
   - Weakening tests, security boundaries, or review integrity.
   - Force pushes or repository protection changes.
   - Deleting protected history, owner data, or evidence.
   - Expanding privileges or exposing secrets.
   - Starting Batch 6.

   Distinguish an obsolete procedural restriction from a still-binding security or evidence invariant.

   Do not unnecessarily request routine owner approvals that this directive already supplies, but do not fabricate approval where the native system requires a separate exact authorization.

   If a mandatory gate rejects the proposed scope, preserve its refusal and resolve the owning contractual issue lawfully.

   ## 3. Primary problem — Documentation and authority accumulation

   ### Owner concern

   Agents frequently modify governance by appending another decision, amendment, clarification, or exception instead of updating the corresponding active operational instruction.

   This causes:

   - Conflicting rules appearing simultaneously.
   - Agents repeatedly reading superseded and active text.
   - Increasingly large AGENTS.md, CLAUDE.md, WORKFLOW.md, Briefs, and handoffs.
   - Unnecessary input-token expenditure.
   - Unclear operational authority.
   - Increased chances of reintroducing previously corrected errors.

   ### Existing evidence

   The supplied DECISIONS.md contains explicit supersession chains, including:

   - D5 → D10/D11: recovery encryption policy.
   - D29 → D30: execution sequencing.
   - D31/D33 → D38: engineering role allocation.
   - D39 → D41: reasoning effort.
   - D41 → D70: WS-027-specific exception.
   - D74 → D75 → D76 → D77: review and Codex-availability decisions.

   These demonstrate why simply keeping the last paragraph or deleting apparently repeated text is unsafe.

   D32 also records a Codex V2 execution with approximately 3.18 million cumulative input tokens, repeated context retrieval, and unnecessary rereading of automatically loaded AGENTS.md.

   Treat these as historical measured evidence, not automatically as current measurements.

   ### Required improvement

   Establish and apply:

   **One Active Truth — Preserved History — Minimum Necessary Context.**

   For mutable operational documentation:

   - Find the authoritative existing instruction.
   - Update it in place.
   - Preserve its original meaning except where a newer owner decision intentionally changes it.
   - Remove proven obsolete operational duplication.
   - Retain necessary conditions, exceptions, and scope boundaries.
   - Use references to historical evidence instead of repeating the entire history.

   For append-only and immutable files:

   - Preserve original evidence.
   - Record legitimate new decisions using the existing append-only mechanism.
   - Never rewrite historical entries for convenience.

   For generated and temporary files:

   - Preserve their existing ownership, placement, dependency, and cleanup rules.

   ### Scope control

   Focus first on documentation directly involved in agent startup, delegation, recovery, governance, Brief creation, and continuation.

   Do not scan and rewrite every Markdown file in every repository merely to achieve perfect stylistic consistency.

   Process one file or one genuinely atomic dependency group at a time.

   For each modification, prove that no required operational rule, reference, consumer, or native condition was lost.

   Do not touch unrelated documentation.

   ## 4. Permanent prevention — Do not allow accumulation to recur

   A one-time cleanup without prevention is insufficient.

   Investigate the existing Markdown consistency guard and other suitable native checkers.

   Propose the smallest justified extension that can detect:

   - Duplicate active rule identifiers.
   - Broken mandatory links or references.
   - Incomplete supersession relationships.
   - Unauthorized changes to historical records.
   - Unjustified duplicate operational instructions.
   - Unexpected growth in automatically loaded instructions.

   Use existing positive and negative tests.

   For example, a planted second active definition of the same rule should be detected, while a legitimate new append-only historical decision should remain permitted.

   Do not claim that a simple regex or static checker fully understands semantic conflicts.

   Where semantic equivalence cannot be proved mechanically, require the existing independent review rather than automatic approval.

   **Prevention must be built into the existing workflow, not implemented as a new permanent agent or continuous scanning service.**

   Avoid blocking unrelated future contracts solely because old historical documentation contains unavoidable duplication.

   ## 5. Independent Owner-Tools AI map

   ### Explicit owner requirement

   Create a SECOND, independent interactive map at:

   `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\ai-map.html`

   With corresponding data:

   `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\ai-map.json`

   The new map must cover BOTH:

   **Root A**

   `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools`

   **Root B**

   `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary`

   ### Independence

   Preserve the existing Workbench map:

   `ORVION-Workbench\ai-map.html`

   `ORVION-Workbench\ai-map.json`

   The new Owner-Tools map must not replace or merge into the Workbench map.

   Reuse the existing WS-016 `Map-Repos.ps1` implementation and owning tests where feasible.

   Prefer minimal source-root parameterization or reuse of existing verified mapping functionality.

   Do not duplicate the mapping engine.

   ### Functional requirements

   The new map should support, where authorized and compatible with the existing implementation:

   - Clearly identified Owner-Tools and temporary Workbench roots.
   - Navigation between folders and relevant files.
   - Contract, SPEC, and decision references.
   - Markdown relationships and backlinks.
   - Relevant dependency and orphan visibility.
   - Meaningful navigation to temporary sandbox and workstream locations.
   - Independent refresh of the Owner-Tools map.
   - Accurate HTML/JSON correspondence.

   ### Privacy and performance

   Never indiscriminately index credentials, secret values, private transcript bodies, generated test fixtures, archives, or sensitive evidence.

   Distinguish structural representation from content indexing.

   Bound traversal of temporary workspaces.

   Prevent unexpected traversal through junctions, symlinks, and reparse points.

   Do not introduce uncontrolled recursive scans or large automatically injected graph outputs.

   Reuse existing refresh behavior where practical without creating an unnecessary new background service.

   ### Acceptance

   Demonstrate representative discoverability and correct links for BOTH roots.

   Verify that the original Workbench map still operates correctly.

   Verify generated-output placement, Git cleanliness, privacy exclusions, bounded traversal, and owning tests.

   ## 6. Spider — Expand existing discovery coverage

   ### Explicit owner requirement

   Extend the EXISTING Spider tool to cover:

   `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools`

   and

   `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary`

   This is a functional search requirement, not merely a map-display requirement.

   ### Preserve existing capabilities

   Spider must retain its existing supported discovery over repositories, sessions, lessons, decisions, records, and other established sources.

   Reuse existing source discovery, root resolution, result ranking, and provenance mechanisms.

   Do not create a second Spider.

   ### Expected behavior

   Verify that Spider can find authorized representative items from both new roots, including:

   - Decision or contract identifiers.
   - Relevant documentation.
   - Tool and script references.
   - Permitted evidence pointers.
   - Temporary contract or sandbox references.
   - Relationships between original and temporary workspaces.

   Results must identify the real source root and correct file location.

   Do not merge identically named files from different roots without source attribution.

   Do not represent unreadable, inaccessible, or excluded content as a successful empty search.

   ### Efficiency and safety

   Prefer lightweight discovery metadata and targeted reading.

   Avoid loading every temporary sandbox or generated artifact into the agent's context.

   Preserve scope boundaries and sensitive-content restrictions.

   Do not expand Spider into an unrestricted filesystem crawler.

   ### Acceptance

   Demonstrate successful retrieval from both additional roots, preserved existing search behavior, accurate source attribution, honest unavailable states, and bounded execution.

   ## 7. Brief and recurring-context optimization

   ### Owner objective

   Reduce unnecessary input tokens and repeated file reading when Claude Main, Claude subagents, Codex, or another authorized delegate begins a task.

   **Do not reduce engineering intelligence, autonomy, research quality, or mandatory assurance.**

   ### Inspect actual loading behavior

   Determine what is automatically supplied to each relevant agent, including:

   - AGENTS.md.
   - CLAUDE.md.
   - Nested and global instructions.
   - Imported rules.
   - Agent definitions and skills.
   - Session hooks.
   - Briefs.
   - Relevant handoff and continuity pointers.
   - Repeated governance reads.
   - Excessive tool-output history.

   Verify effective behavior using existing client and runtime evidence.

   Do not assume an instruction file is absent or present merely because of its location.

   ### Preferred Brief design

   A Brief should contain only the information needed to start and govern the task:

   - Exact objective.
   - Scope.
   - Authority.
   - Required gates.
   - Relevant evidence pointers.
   - Read/write boundaries.
   - Deliverables.
   - Acceptance criteria.
   - Stop conditions.

   Provide references to authoritative sources rather than copying large documents into every Brief.

   Do not re-read files already injected into context without a demonstrated need.

   Keep independent reviewers capable of conducting their own evidence discovery; do not replace genuine review with an author-prepared conclusion.

   Use existing targeted tools before expensive AI reasoning.

   ### Avoid false savings

   Moving 20,000 tokens from AGENTS.md into a permanently imported file is not a meaningful context reduction.

   Measure actual injected and repeated context, not merely source-file line counts.

   Do not create arbitrary hard limits that truncate mandatory governance or relevant evidence.

   Do not add additional session resets, new monitoring systems, or elaborate token accounting.

   ### Acceptance

   Use representative existing execution evidence to demonstrate:

   - Lower redundant startup context where achievable.
   - Fewer unnecessary repeated reads.
   - Reduced large tool-output duplication.
   - Preserved discovery capability.
   - Unchanged mandatory native checks and review quality.

   Where a saving cannot be measured, say so.

   ## 8. New standing model and reasoning-effort policy

   ### Explicit owner amendment

   Replace applicable outdated standing model/effort requirements for future work.

   **Codex**

   - Model: latest verified, compatible Sol-family model.
   - Reasoning effort: `high`.
   - Applies to V1, V2, and all other authorized Codex assignments.
   - No standing `xhigh`, `max`, or `ultra` requirement for Codex.
   - Verify actual CLI-supported model and effective effort before and during execution.
   - Record exact runtime model identifiers in execution evidence.
   - Do not hardcode a historical version as a future requirement.

   **Claude Main and Claude subagents**

   - Use Claude Main's existing default model/effort behavior.
   - Do not impose a hardcoded `high`, `xhigh`, or `max` requirement.
   - Do not change the owner's current Claude settings merely to satisfy older effort directives.
   - Verify actual inheritance or default behavior for subagents.
   - If subagent inheritance is unsupported, resolve the smallest supported default-compatible setting without fabricating an effective configuration.

   ### Authority reconciliation

   Review D31, D33, D34, D38, D39, D40, D41 and later scoped exceptions.

   Record the new owner amendment in the existing append-only decision ledger.

   Update active mutable instructions in place.

   Do not rewrite historical model/effort records or frozen contract evidence.

   Do not silently change active running sessions or invalidate previously frozen candidates.

   This new model policy changes resource allocation, not mandatory engineering phases or gates.

   ### Codex availability

   The earlier temporary Codex-bypass policy must not be treated as a permanent prohibition against future Codex use.

   For this workstream, Codex is permitted when its currently verified availability and security requirements allow.

   If unavailable, assess the existing authorized fallback instead of waiting indefinitely.

   Never claim a Claude review is a Codex review, and never falsely claim independence.

   ## 9. Root-cause and governance-conflict review

   I do not want the same failures to recur after the current cleanup.

   Perform a focused review of why governance accumulated and drifted in the first place.

   Investigate:

   - Whether decision amendments are reflected in active operational documentation.
   - Whether several files claim authority over the same rule.
   - Whether temporary exceptions remain active after their intended scope.
   - Whether auto-loaded instructions contain historical material.
   - Whether agents are rewarded by the workflow for appending new text rather than updating existing text.
   - Whether current checkers detect duplicate definitions and broken references.
   - Whether Briefs cause the same governance files to be read repeatedly.
   - Whether documentation maintenance itself creates unnecessary historical additions to active files.

   For each confirmed issue, identify the smallest existing mechanism capable of preventing recurrence.

   Do not turn this review into broad architectural research.

   Use the actual current sources and evidence, not speculation.

   ## 10. Non-negotiable anti-overengineering limits

   The success criterion is **sufficient, verified improvement**, not theoretical perfection.

   Do not pursue:

   - Full semantic understanding of every historical decision.
   - Perfect deduplication across all Markdown files.
   - A new graph database or vector database.
   - A replacement for Spider or Map-Repos.
   - A new orchestration framework.
   - New independent governance engines.
   - Rewriting all historical records.
   - Unlimited recursive filesystem indexing.
   - Full-repository cleanup beyond the justified critical path.
   - Additional permanent telemetry or monitoring.
   - Extra Draft rounds beyond the approved workflow.
   - Repeated heavy tests without an owning requirement.
   - New external dependencies without a proven blocker.

   A modest, maintainable change using existing verified tools is preferred over a sophisticated solution with disproportionate complexity.

   If a proposed improvement delivers little measurable benefit relative to its complexity, leave it out and explain why.

   **Do not spend 100,000 tokens engineering a mechanism intended to save 10,000 tokens unless the additional cost is justified by a proven critical risk.**

   ## 11. Implementation method

   After WS-028 passes:

   **First — Preserve the baseline**

   Verify WS-028 completion, native receipts, and required continuity evidence.

   Prepare the existing Final Stop Packet in its proper place before initiating the deferred improvement workstream.

   Keep that packet as the pre-improvement baseline. If later amendments are needed, preserve the original and use the governed supplementary record rather than rewriting history.

   **Second — Admit ONE bounded improvement workstream**

   Use existing native contract authority and allocation.

   Combine the five improvements in one coherent scope with distinct, testable acceptance criteria.

   Do not allocate separate workstreams for individual optional refinements.

   **Third — Reuse verified source knowledge**

   Start with Spider, Hunt, existing map tools, Markdown guards, current contract files, and focused evidence.

   Avoid repeatedly asking agents to rediscover the same governance rules.

   **Fourth — Implement minimally**

   Prefer narrow source modifications, existing tool extensions, and in-place corrections of mutable operational documentation.

   Respect every file's ownership and immutable boundaries.

   **Fifth — Test the actual behavior**

   Use focused positive and negative tests, existing native gates, and independent review according to the accepted contract.

   For mapping and Spider, verify representative real paths and search behavior.

   For context optimization, verify actual loaded or repeatedly read content.

   For effort settings, verify the real execution configuration.

   **Sixth — Preserve and close**

   Record the exact changes, verified outcomes, measured savings where available, remaining risks, and continuity evidence.

   Apply the existing authorized publication and release steps if their required approvals and native conditions are satisfied.

   Do not assume the workstream is complete merely because the source code has been edited.

   ## 12. Stop conditions

   Stop the affected operation if:

   - A mandatory native gate fails.
   - Protected evidence would need to be rewritten.
   - A required authorization cannot be lawfully established.
   - A security boundary would be weakened.
   - A required dependency or reference cannot be verified.
   - A proposed change requires material architectural expansion.
   - A change would compromise the running system or existing mandatory workflow.
   - An unresolved owner-level decision is needed for a high-risk operation.

   Preserve the evidence and identify the exact blocker.

   If an unrelated improvement is blocked, do not invent a bypass. Continue only with independently authorized, nondependent work where the existing governance permits it.

   ## 13. Expected evidence and final report

   Provide one concise English completion report covering:

   **A — Authority reconciliation**

   Which previous restrictions were superseded, which remain active, and why.

   **B — Documentation maintenance**

   Files actually improved, duplicated active instructions removed, and preserved history.

   **C — Permanent prevention**

   The existing checker changes, negative tests, and exact types of duplication now prevented.

   **D — Owner-Tools independent map**

   Both required roots, output locations, refresh behavior, and verified links.

   **E — Spider**

   New root coverage, actual search examples, and regression results.

   **F — Brief/context efficiency**

   What was repeatedly loaded, what changed, and measured savings where available.

   **G — Model and effort governance**

   Verified Codex Sol/high behavior and Claude default behavior without changing historical records.

   **H — Verification**

   Native checks, independent review, integrity results, and preserved evidence.

   **I — Residual risks**

   Only genuinely unresolved material issues, not speculative improvements.

   Separate verified facts, owner requirements, recommendations, and unproven assumptions.

   ## 14. Final owner intent

   I am not asking for a perfect documentation system.

   I am asking for a more efficient and dependable ORVION system.

   The real problem is that each future agent currently risks inheriting an increasingly large, inconsistent, and expensive body of instructions.

   We must stop that accumulation without sacrificing governance, security, independent review, or the ability to discover unexpected problems.

   Your responsibility is to deliver the smallest proven set of corrections that materially improves this situation.

   Do not repeatedly ask for authorization already supplied here.

   Do not convert these improvements into a new programme.

   Do not weaken mandatory gates.

   Do not overengineer.

   Do not start Batch 6.

   **Complete one bounded improvement workstream, preserve its evidence, then proceed to the existing Owner Lift process and stop at the Batch 6 threshold.**

   **Earn It & Worth It. Learn Before Guessing. Simplify Without Diluting. One Active Truth. Preserved History.**
   ```

   The resulting file's Git blob is b79d4fcebf5b1119fa955028d3a34d8cb3ec0ed9.

6. Check whether `docs/owner/20261031-owner-directive-improvement-ws/OWNER-AUTHORITY-20261031.md` contains `# Owner messages after D87, 2026-10-31 (verbatim)`; if so record Already Applied when its Git blob is 189edf84c96ce1f0a3bc0e5d5e310202264cc3ce, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # Owner messages after D87, 2026-10-31 (verbatim)

   Received by Claude main between about 15:55 and 16:45 Cairo. Recorded as D88. Applied in PLAN.md (v2), STANDARD.md
   and MIGRATION-MAP.md in this folder.

   ## Message A

   Furthermore, the key, frequently consulted documents contain numerous sections, lines, and decisions that are contradictory, conflicting, redundant, outdated, and disorganized. The very structure of these documents is not modern or technically sound; it does not facilitate their development or maintenance in a way that avoids the accumulation of redundancies and contradictions—the "decisions file" being a prime example.

   ## Message B

   I grant you the authority to take whatever actions you deem necessary. I also want to ensure you fully understand my requirements: previous agents working on these folders and projects failed to establish a proper structural organization for the files and directories. They did not group related items logically, nor did they handle the "orphan" files—temporary or redundant files automatically generated during execution—which have simply accumulated on the hard drive or in the cloud. This is quite frustrating. Could you refine the operational plan and document it in a way that ensures consistent execution—whether by you or by a less capable agent—so that the same instructions are followed regardless of the individual's intelligence level?

   I have no objection to reorganizing the folder structure to create a mature, well-organized repository that allows for scalability without conflicts, redundancies, or clutter.

   Furthermore, I do not want to retain obsolete sections, lines of code, or past decisions that are no longer relevant—whether they were superseded, reversed, or simply left behind as historical artifacts. Keeping them is a waste of resources and tokens whenever an agent reads through the files. Instead, we could move such items to a dedicated "historical archive" folder. This archive should include its own index, making it easy for an agent to navigate the contents and retrieve specific information if needed.

   In short, my philosophy is this: every folder should have an index or an "organizer" at its root that tracks the events and contents within it. Even if an agent needs to create a subfolder, it must be done according to established standards and rules. It should be done in a general, standardized way—not according to the individual whims of the agents.

   I would like to reorganize, clean up, and structure the three folders (this applies to the folders themselves, not to the CRM or Orvion systems). Can you assist me with this? Let this serve as a fresh start for restructuring the folders—not by rewriting the content from scratch, but by migrating, editing, and cleaning up the existing material, while removing any unnecessary context.

   ## Message C

   I want every file, every folder, and every section within those folders to adhere to the principles of the repository:

   Learn first & Earn it & worth it & Simplify without weakness.

   ## Message D

   the there Folder is :
   "C:\Users\My Lab\Documents\GitHub\ORVION-Workbench"
   "C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools"

   ## Message E

   "C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary"
   ```

   The resulting file's Git blob is 189edf84c96ce1f0a3bc0e5d5e310202264cc3ce.

7. Check whether `docs/owner/20261031-owner-directive-improvement-ws/OWNER-REFINEMENT-20261031.md` contains `# Owner refinement of D83, 2026-10-31 (verbatim)`; if so record Already Applied when its Git blob is b41764fa988581c63fca798fdd04e4eb32cd1c97, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # Owner refinement of D83, 2026-10-31 (verbatim)

   Received by Claude main at about 15:30 Cairo. Recorded as D87. The plan that applies it: PLAN.md in this folder.

   ## Message 1

   How about you try to uncover the "D83" plan yourself—specifically, by identifying existing gaps that have gone unnoticed until now?

   The goal is to improve the workflow—not just for you, but for any agents who might work after you. We need to ensure they strictly follow your methodology, rather than relying on their own personal approaches or individual interpretations.

   I asked you to uncover the "D83" plan because I’ve noticed that you (and other assigned agents) keep rereading the same files over and over. These files are excessively long, lack organization and flexibility, and fail to follow global standards or best practices—whether in terms of folder structure, section arrangement, or the content itself, which appears random, disorganized, and devoid of a systematic approach. Furthermore, the files are scattered and lack clear, logical connections that could be easily grasped by humans and agents alike. For comparison, look at the `CRM Repo` folder structure—it is relatively well-organized—whereas the three `Workbench` folders are the exact opposite. Additionally, the current task-delegation process between you and your sub-agents wastes a significant number of tokens, as every new sub-agent is forced to reread the same files from scratch. This runs counter to modern standards, which dictate that agents should be provided with a specific requirements document, accompanied by a concise roadmap for any necessary external reading beyond the core brief. You are currently re-reading the same core files after every "compact" step; I am looking for a solution to eliminate this unnecessary repetition.

   Furthermore, I suggest that the V1 and V2 phases be handled within the same Codex agent session, avoiding the need to reload and re-read the same context. Similarly, the prototype phase, the V3 phase, and the Claude-based review for V3 do not require separate sub-agents; they can all be managed by the primary agent within a single, continuous session.

   I also propose that the state be saved after every operation to prevent data loss, corruption, or the need to restart from scratch when performing a "compact" action. Additionally, after each operation and subsequent save, the agent (within the primary session) should prompt me to perform a "compact" step, providing the optimal command and the best follow-up message to ensure a seamless continuation.

   I have also noticed that using sub-agents during the prototype, V3, and review stages consumes a significant number of tokens—an unnecessary expense that can easily be avoided.

   Are you ready for this task? Please refine and improve the "D83" plan. Structure the steps of the plan without unnecessary expansion.
   Keep the number of Work Streams (WS) to a minimum—ideally consolidating them into a single WS phase wherever possible.
   Document the plan in writing so it is neither lost nor forgotten.
   Ensure the plan is robust, logical, and practical, grounded in up-to-date global best practices and standards—rather than relying on guesswork or personal assumptions—while remaining aligned with our established governance principles.

   I want a single, clear "router" file that serves as the starting point for both the agent and the human user.
   Eliminate any orphaned or legacy files; they should either be deleted or merged.
   Establish a clean, structured architecture for the workflow so that every agent follows a consistent method for saving and recording data, rather than each agent using its own unique approach.
   Furthermore, ensure that every folder or sub-process within the overall workflow remains free of redundancy, conflicts, or the kind of data accumulation that leads to excessive token consumption.

   Develop the execution plan, explain it to me, and keep it on record so we can begin implementation.

   ## Message 2 (sent while the plan was being prepared)

   I noticed that you already have data and measurements from previous work. Instead of re-assigning sub-agents and consuming additional resources, could you locate that existing data, or is it necessary to take the measurements again?
   ```

   The resulting file's Git blob is b41764fa988581c63fca798fdd04e4eb32cd1c97.

8. Check whether `docs/owner/20261031-owner-directive-improvement-ws/OWNER-TWO-FOLDERS-20261031.md` contains `# Owner preference: two folders, 2026-10-31 (verbatim)`; if so record Already Applied when its Git blob is 8fe51642457244a4c9d4d51e496f1ba1f8d5a94a, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # Owner preference: two folders, 2026-10-31 (verbatim)

   Received by Claude main at about 16:50 Cairo. Recorded as D89.

   I would have preferred to have only two folders:
   One, hosted on GitHub, kept constantly updated and lightweight, containing only essential files—such as those related to workflows and governance—regardless of the sensitivity or security risks associated with their content.
   The other, a temporary folder to be deleted manually, containing only transient files generated during work that are no longer needed once the task is complete.

   However, the previous agents set up three folders for me, which is not what I would have preferred.

   ## Facts checked when it arrived (read-only)

   - github.com/Shehabhub/ORVION-Workbench is PUBLIC; ruleset "Workbench Main Protection" is active on it.
   - GitHub documents rulesets and branch protection for private repositories only on paid plans (Pro, Team,
     Enterprise); on GitHub Free a private repository loses them. The account plan could not be read with the current
     token.
   - 12 local commits (affa92f..f06a2b1) are not pushed.
   ```

   The resulting file's Git blob is 8fe51642457244a4c9d4d51e496f1ba1f8d5a94a.

9. Check whether `docs/owner/README.md` contains `Purpose: The owner's words and the recovery inputs. Kind: owner-texts. Lifetime: permanent.`; if so record Already Applied when its Git blob is 33f6a31b3cea954beb79d2a58409dc59e636d0c7, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # owner

   Purpose: The owner's words and the recovery inputs. Kind: owner-texts. Lifetime: permanent.
   Reader: agents, the owner, Backup-Workspace.
   Rules: added only through lib/Organize.ps1 or by the tool named in Reader.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   | 20261026-delegation/ | sealed | - | - | - |
   | 20261031-owner-directive-improvement-ws/ | sealed | - | - | - |
   | recovery-inputs/ | owner-texts | Backup inputs that live nowhere else, flat, with their hash map | Backup-Workspace | 2026-11-04 |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:34Z | new | - | docs/owner | T10 organizer |
   | 2026-11-04T17:40:35Z | new | - | docs/owner/recovery-inputs | T10 organizer |
   <!-- /organize:changes -->

   ## Files

   - [20261026-delegation/OWNER-DIRECTIVE-INTERACTIVE-MAP.md](20261026-delegation/OWNER-DIRECTIVE-INTERACTIVE-MAP.md)
   - [20261026-delegation/OWNER-DIRECTIVE-UNENCRYPTED-CONTINUITY.md](20261026-delegation/OWNER-DIRECTIVE-UNENCRYPTED-CONTINUITY.md)
   - [20261031-owner-directive-improvement-ws/DIRECTIVE.md](20261031-owner-directive-improvement-ws/DIRECTIVE.md)
   - [20261031-owner-directive-improvement-ws/OWNER-AUTHORITY-20261031.md](20261031-owner-directive-improvement-ws/OWNER-AUTHORITY-20261031.md)
   - [20261031-owner-directive-improvement-ws/OWNER-REFINEMENT-20261031.md](20261031-owner-directive-improvement-ws/OWNER-REFINEMENT-20261031.md)
   - [20261031-owner-directive-improvement-ws/OWNER-TWO-FOLDERS-20261031.md](20261031-owner-directive-improvement-ws/OWNER-TWO-FOLDERS-20261031.md)
   - [recovery-inputs/OWNER-DECISION-20261027-evidence-and-trusted.md](recovery-inputs/OWNER-DECISION-20261027-evidence-and-trusted.md)
   - [recovery-inputs/OWNER-DECISION-20261027-no-reinstall.md](recovery-inputs/OWNER-DECISION-20261027-no-reinstall.md)
   - [recovery-inputs/OWNER-DELEGATION.md](recovery-inputs/OWNER-DELEGATION.md)
   - [recovery-inputs/OWNER-DIRECTIVE-REINSTALL.md](recovery-inputs/OWNER-DIRECTIVE-REINSTALL.md)
   - [recovery-inputs/OWNER-REQUEST-DELEGATE-SKILLS.md](recovery-inputs/OWNER-REQUEST-DELEGATE-SKILLS.md)
   - [recovery-inputs/README.md](recovery-inputs/README.md)
   ```

   The resulting file's Git blob is 33f6a31b3cea954beb79d2a58409dc59e636d0c7.

10. Check whether `docs/owner/recovery-inputs/batch6-hold-directive.json` contains `"At": "2026-10-21T15:51:58.0142632Z",`; if so record Already Applied when its Git blob is 25ff6d1dd4df3508d6e5234f23d3346ed2194aa7, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   {
     "At": "2026-10-21T15:51:58.0142632Z",
     "Verbatim": "لا تبدء اى من مراحل batch 6 كلا المستودعان الان وتخصص فى محاولة الاصلاح الحاليه لتهيئة دورات العمل بعد الاصلاح لاستكمالهم فيما بعد",
     "Scope": "Both CRM/Platinum and ORVION/Founder",
     "Batch6": "ON HOLD; do not select or implement any slice",
     "Focus": "Current repair and workflow readiness only; no automatic product-work continuation after certification"
   }
   ```

   The resulting file's Git blob is 25ff6d1dd4df3508d6e5234f23d3346ed2194aa7.

11. Check whether `docs/owner/recovery-inputs/OWNER-APPROVAL-AB.txt` contains `OWNER DECISION: APPROVE A AND B — EXACT BOUNDED SCOPES`; if so record Already Applied when its Git blob is 23234e27b0424f0dde72dc744bca676b6589d451, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   OWNER DECISION: APPROVE A AND B — EXACT BOUNDED SCOPES
   A — APPROVED: Bounded GitHub protection-enforcement proof.
   I authorize the previously reviewed, bounded same-ruleset disposable-ref verification for Shehabhub/ORVION-Workbench.
   I will make no competing repository writes during the coordinated execution window.
   Use the existing active main-protection ruleset and the exact reviewed temporary probe configuration. Keep main protected throughout, preserve the existing required status check and bypass restrictions, and limit potentially destructive test operations strictly to the disposable probe reference.
   Independently verify the actual reason for each provider refusal, not merely the HTTP failure. Preserve the evidence and restore the reviewed main-only ruleset targeting after successful verification.
   If unexpected behavior, conflicting writes, unreadable mandatory evidence or rule drift occurs, stop the affected operation safely. No uncontrolled retries, protection bypasses or modifications to main are authorized by A.
   A does not authorize the 42-transition main promotion. Once all required protection and trusted-release gates pass, present the exact promotion admission and remaining owner authorization.
   B — APPROVED: Exact original Gate 1 for both frozen Drafts, conditionally executable after the fixed 42-transition release boundary.
   Original execution root for BOTH contracts:
   C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
   First — WS-014 R2 (Plan Successor)
   Exact selected Draft SHA-256:
   1A54C812D27071D4368381A57E933E9F90D478CCFCE4739434189C56531869F3
   I approve the exact previously reviewed, frozen WS-014 R2 Draft and its declared original engineering scope only.
   Second — WS-013 R2 (Corrected Recovery)
   Exact selected Draft SHA-256:
   552C6EE22C0752DDC16FC3C5708DA6663EE401C124ED75654E987FF3A4824B63
   I approve the exact previously reviewed, frozen WS-013 R2 Draft and its declared original engineering scope only.
   Execute WS-014 R2 first, followed by WS-013 R2, provided fresh native admission confirms that the approved subjects, physical root, ancestry, source inputs, sandbox evidence and governing requirements remain valid.
   Each contract requires its own legitimate original lifecycle, fresh Finish, independent Review, Complete and carrying-range verification. Do not transplant sandbox receipts or change frozen Drafts.
   WS-014 is the successor alternative to unimplemented WS-012. Do not execute both.
   Execution boundaries
   - Preserve the fixed 42-transition release subject until its protected-main release is completed.
   - Do not append WS-014 or WS-013 commits to that existing release candidate.
   - No force pushes, history rewrites, unapproved GitHub publication or automatic trusted-evaluator advancement.
   - No additional engineering scope beyond the two exact approved Drafts.
   - No bypass of native governance, required checks or independent review.
   - Preserve CTRL-19 OPEN and Batch 6 / Phase 8 ON HOLD.
   Please execute the authorized work in the proper dependency order, reuse valid existing evidence, and avoid unnecessary heavyweight reruns.
   My objective is meaningful progress across this coherent release-and-recovery milestone, not another cycle of repeated readiness reports.
   Report actual completion and only genuinely unresolved owner decisions.
   APPROVAL A: GRANTED.
   APPROVAL B: GRANTED for the exact two root-bound Drafts above, effective for original execution only after the fixed 42-transition release boundary and successful fresh native admission.
   ```

   The resulting file's Git blob is 23234e27b0424f0dde72dc744bca676b6589d451.

12. Check whether `docs/owner/recovery-inputs/OWNER-DECISION-20261027-evidence-and-trusted.md` contains `# Owner decisions 2026-10-27 (recorded by the orchestrator from the owner's answers)`; if so record Already Applied when its Git blob is a282cdb360ec8d8e307b1595803a776964849721, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # Owner decisions 2026-10-27 (recorded by the orchestrator from the owner's answers)

   A. 87 old evidence files (2.2 MB, inventory ORVION-Workbench-temporary\cx\ORVION-keepdrop\KEEP-DROP-review-dependencies.tsv):
      owner selected "Accept the limitation (Recommended)". They are preserved in the private store with their original-path
      provenance and hashes; no local re-check of OLD contract history after relocation; the judge and trusted pin stay
      unchanged; every new carrying range is still judged in full.

   B. Place of ORVION-Workbench-trusted-main: owner answered "apply my earn it & worth it rule" (decision delegated).
      Decision: it STAYS at C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-trusted-main. Reason: it is a clean clone of the
      GitHub repository pinned at d2e352e, fully recoverable from GitHub (same class as ORVION-Workbench), small; moving it
      earns nothing and costs changes to Backup-Workspace and every release script plus trust-path churn.
      Layout therefore: ORVION-Workbench (+ its trusted clone) = GitHub class; ORVION-Owner-Tools = private; ORVION-Workbench-temporary = disposable.
   ```

   The resulting file's Git blob is a282cdb360ec8d8e307b1595803a776964849721.

13. Check whether `docs/owner/recovery-inputs/OWNER-DECISION-20261027-no-reinstall.md` contains `# Owner decision, 2026-10-27 (~00:15 Cairo): no Windows reinstall; amend lift criterion 5`; if so record Already Applied when its Git blob is c36a2203324ce8cf0fc161921a4145e1e816be67, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # Owner decision, 2026-10-27 (~00:15 Cairo): no Windows reinstall; amend lift criterion 5

   ## Owner's request (written in Arabic, paraphrased in English)
   Instead of reinstalling Windows, delete only the ORVION-related folders outside C:\Users\My Lab\Documents\GitHub, then re-download and re-prepare them. Never touch the GitHub folder.

   ## Orchestrator's assessment, given to the owner
   - Deleting the ORVION folders outside GitHub and restoring them would prove nothing new, because the isolated restore that passed tonight already restored all 6 legacy folders. It could also lose work done after the 20:18Z package.
   - Inventory, measured read-only:
     - Owner-Review: 1.57 GB, the live state and evidence;
     - Sandbox: 2.77 GB of evidence;
     - old Codex clones: about 120 MB, some holding out/ folders not in any package;
     - test temp leftovers: about 150 MB;
     - free disk: 218 GB.
     None of it is worth deleting.
   - The question put to the owner: is the reinstall needed for its own sake, or mainly as the recovery proof? Skipping it requires changing HANDOFF §12 criterion 5 ("C2: the owner's planned Windows reinstallation"), which only the owner can do.

   ## Owner's answer (selected option, verbatim)
   "Skip reinstall (Recommended)": no Windows reinstall. The owner records that criterion 5 is met by C1 (passed tonight) plus a test of the double-click restore file once it is built. What stays unproven is installing tools on a bare Windows, which only matters if the machine is ever really lost.

   ## Effect
   - The Windows reinstall is CANCELLED. No ORVION folders are deleted.
   - Criterion 5 becomes: C1 on package orvion-backup-20261026T201821Z.7z (SHA256 BC28B482F6E101D40D3DD2E9DA5690C122589350804F64FE59BC612D8E9F0203; cloud re-download matched; isolated restore 212 s; CRM, ORVION and Workbench Boots READY, 2026-10-27), PLUS an isolated run of the released WS-023 Restore-ORVION.cmd against a fresh package.
     - Clean-machine tool installation stays UNPROVEN; the owner accepts it as residual risk.
   - The HANDOFF.md §12 text change goes into WS-023 scope.
   - This is NOT the lift decision. The hold stays ON until the owner records one lift decision citing criteria 1-5. CTRL-19 stays OPEN.
   ```

   The resulting file's Git blob is c36a2203324ce8cf0fc161921a4145e1e816be67.

14. Check whether `docs/owner/recovery-inputs/OWNER-DELEGATION.md` contains `# Owner message received 2026-10-26 in the Claude Code session b0862c78-8372-43af-b4c1-eee9dd4ef223 (verbatim)`; if so record Already Applied when its Git blob is adb2b8ba375e373721db4fe7cbff437823b7c28b, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # Owner message received 2026-10-26 in the Claude Code session b0862c78-8372-43af-b4c1-eee9dd4ef223 (verbatim)

   The message below is the owner's own text, pasted into the session as their message. It is the single source of the
   exceptional delegation. Every decision taken under it is recorded in DECISIONS.md next to this file, with its exact
   input hash and evidence. Local file integrity binds this evidence; it does not authenticate owner identity.

   ---

   # EXCEPTIONAL OWNER AUTHORIZATION — TEMPORARY END-TO-END EXECUTION DELEGATION

   **OWNER DECISION: APPROVED — ONE-TIME EXCEPTIONAL ADVANCE AUTHORIZATION**

   I explicitly authorize a temporary, narrowly scoped exception to the normal requirement for repeated owner approval during the approved Hybrid Workbench-to-Batch-6 strategy.

   I will be away from the workstation.

   **My intention is that you complete the approved strategy autonomously, without stopping at every Gate 1, implementation, publication, promotion, or routine owner-decision boundary.**

   This authorization supersedes my earlier instruction to stop automatically at each future exact-SHA approval request, but ONLY within the scope and conditions defined below.

   ## 1. Scope of exceptional approval

   I authorize the following work end to end:

   1. Complete the minimal, portable Workbench recovery capability.
   2. Preserve all essential tools, sessions, events, knowledge, contracts, approvals, receipts, and unique evidence.
   3. Exclude verified disposable and regenerable execution artifacts.
   4. Complete the necessary backup-coverage corrections and secure selective packaging.
   5. Produce and verify a small encrypted recovery package.
   6. Create an encrypted off-device copy when an already authorized, securely accessible destination and safe key-management method are available.
   7. Perform the approved C1 same-machine isolated recovery verification.
   8. Formally amend the appropriate programme authority to distinguish C1 from the still-unproven C2.
   9. Preserve CTRL-19 as OPEN with accurately recorded accepted residual risk.
   10. Resolve Shared Evidence through its permitted deferred or waived disposition, without inventing assurance.
   11. Amend the unnecessary Workbench-to-Batch-6 dependency through the proper owning authority.
   12. Correct Founder ADR-0033 and Boot routing where required.
   13. Complete qualified publication and promotion to the appropriate protected repositories.
   14. Lift the Batch 6 hold only when the legitimately amended, explicit prerequisites have been proven satisfied.
   15. Return to Batch 6 through the product's native workflow.

   Prefer ONE contract, or TWO at most where native repository boundaries permit.

   Do not artificially combine incompatible native contracts or weaken repository independence simply to meet that preference.

   ## 2. Exceptional advance Gate 1 authorization

   **I explicitly grant conditional advance owner approval for the necessary Gate 1 decisions within this bounded strategy.**

   You are authorized to prepare, freeze, evaluate, and execute the required Drafts without requesting another routine owner confirmation, provided that:

   - Each Draft remains strictly within this approved scope.
   - The existing mandatory V1/V2/V3 assurance is completed.
   - An independent trusted evaluator confirms the required admission and integrity conditions.
   - The exact final Draft SHA-256 is recorded before implementation.
   - The executed implementation matches the qualified frozen scope.
   - No material new risk, authority expansion, or unapproved deviation is introduced.

   Record this message as the source of the exceptional owner delegation, together with the exact Draft hashes, accepted conditions, evidence, and every decision made under it.

   **This is explicit authorization for a one-time exception to the owner-approval workflow, not permission to fabricate an exact-hash approval or falsely report that the ordinary Gate 1 procedure occurred.**

   Where the native governance recognizes a bounded owner exception, use its legitimate mechanism.

   If the current authority cannot recognize such an exception without a separate governing amendment, perform only the valid bounded amendment path; never falsely mark a mandatory gate as passed.

   ## 3. Exceptional publication and promotion authorization

   I also grant conditional advance authorization for the necessary publication and promotion operations within this strategy.

   You may proceed without further owner confirmation when all applicable checks pass:

   - Exact candidate and destination identities are established.
   - The correct independent GitHub identity is verified.
   - Current remote refs and ancestry are freshly checked.
   - Required local and original certification is successful.
   - Required hosted checks succeed on the exact candidate.
   - Existing branch protection remains active.
   - Independent trusted evaluation confirms release eligibility.
   - Remote readback proves the intended result.

   This authorization is limited to ordinary, non-force, qualified fast-forward operations.

   **No force pushes, history rewrites, disabled protection, credential mixing, unqualified trust advancement, or bypass of failed certification.**

   Preserve a complete release receipt for each independently governed repository.

   ## 4. Conditional authorization for Batch 6

   I conditionally authorize lifting the current Batch 6 hold **only after** the applicable programme amendments have been legitimately adopted and every prerequisite they retain has been satisfied.

   Do not claim that C2 has passed.

   Do not close CTRL-19.

   Do not claim Shared Evidence has been earned if it has not.

   Once the amended authority actually permits resumption, proceed through the native product workflow.

   The goal is to return to real ORVION product development, not initiate further Workbench expansion.

   ## 5. Explicit restrictions remain

   Even under this exceptional delegation:

   - Do NOT run or enable Windows Sandbox.
   - Do NOT upload the original approximately 4 GB archive.
   - Do NOT delete irreplaceable historical evidence.
   - Do NOT move or delete unrelated files.
   - Do NOT weaken mandatory product security safeguards.
   - Do NOT expose encryption keys or passwords to agent transcripts, logs, or command arguments.
   - Do NOT create unnecessary new infrastructure.
   - Do NOT install the interactive map or expand dual management unless independently required by the approved critical path.
   - Do NOT treat the provisional 100 MB estimate as an upper limit that justifies losing essential data.

   If secure off-device backup requires an unavailable owner-controlled secret, hardware action, or authentication, do not improvise a credential bypass. Complete other independently authorized work and preserve that precise blocker.

   ## 6. Independence, testing, and accountability

   Keep Platinum, Founder, and Workbench independently governed.

   Reuse completed tests and valid receipts whenever permitted.

   Do not rerun expensive Finish suites merely for reassurance.

   Use the existing Watcher, Timed Runner, Events, Pulse, and recovery checkpoints.

   Record each exceptional decision with its original owner authority, precise scope, input hash, test outcome, publication identity, and completion evidence.

   If any condition fails, stop the affected irreversible action rather than using this delegation to override the failure. Continue other safe, independent work.

   ## 7. Delegation expiration

   **This exceptional authorization expires automatically when the approved Hybrid strategy reaches its verified stopping point.**

   That point is:

   - The minimal Workbench recovery solution is implemented and appropriately certified.
   - C1 is truthfully verified.
   - C2 and CTRL-19 retain their documented unresolved status.
   - Applicable programme amendments and release steps are completed.
   - The Batch 6 continuation decision has been lawfully resolved.
   - The stable Workbench baseline and exact next product action are recorded.

   It does not authorize unlimited future Workbench changes, subsequent unrelated product contracts, or additional governance exceptions.

   ## FINAL OWNER INSTRUCTION

   **PROCEED AUTONOMOUSLY THROUGH THE ENTIRE APPROVED STRATEGY.**

   Do not interrupt execution merely to request routine confirmations already covered by this delegation.

   Use the smallest legitimate number of contracts and the simplest proven implementations.

   Preserve everything valuable from the Workbench investment.

   Complete the actual necessary work, establish a reliable and lightweight baseline, and return to Batch 6 as soon as legitimately possible.

   **I am authorizing controlled autonomy, not reduced engineering integrity.**

   **OWNER APPROVAL: GRANTED — EXCEPTIONAL, TEMPORARY, SCOPE-BOUND, AND CONDITIONALLY PRE-AUTHORIZED.**
   ```

   The resulting file's Git blob is adb2b8ba375e373721db4fe7cbff437823b7c28b.

15. Check whether `docs/owner/recovery-inputs/OWNER-DIRECTIVE-REINSTALL.md` contains `# Owner message received 2026-10-26 in session b0862c78-8372-43af-b4c1-eee9dd4ef223, during execution of OWNER-DELEGATION.md (verbatim)`; if so record Already Applied when its Git blob is c0da6d22a4246c890aca103ec7afc89294a5192f, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # Owner message received 2026-10-26 in session b0862c78-8372-43af-b4c1-eee9dd4ef223, during execution of OWNER-DELEGATION.md (verbatim)

   The owner asked that this be integrated into the approved Hybrid strategy using the smallest justified changes.

   ---

   **OWNER DIRECTIVE — WORKBENCH MUST ACTIVELY ASSIST AGENTS AND SURVIVE WINDOWS REINSTALLATION**

   Workbench was originally designed to **help agents perform engineering work, not merely monitor or govern them**.

   Tools such as **Hunt** should proactively discover defects, gaps, broken assumptions, and improvement opportunities, then provide actionable findings that help agents diagnose and fix problems.

   Please review and improve the existing Workbench tools, focusing on:

   - **Effectiveness:** Improve detection accuracy, usefulness, performance, and resource efficiency.
   - **Actual usage:** Ensure current and future agents consistently use the appropriate tools through existing Boot and workflow mechanisms, with automated enforcement where justified.
   - **Delegation:** Enable tools to cooperate intelligently, discover problems, delegate appropriate tasks, and assist agents in resolving them.
   - **Low overhead:** Avoid unnecessary scans, duplicate monitoring, excessive tests, or governance that costs more than the tools save.

   **Most importantly, I intend to reinstall Windows before starting Batch 6.**

   Therefore, establish a **small, complete, cloud-synchronized permanent repository and recovery package** containing everything essential to restore Workbench and its useful tools afterward.

   Preserve irreplaceable sessions, knowledge, decisions, configurations, credentials recovery instructions, contracts, unique changes, and certification evidence. Protect sensitive material through encryption and secure key custody.

   Exclude only material proven safely regenerable.

   **Do not assume GitHub synchronization alone guarantees full recovery. Verify backup completeness, document the exact post-Windows installation procedure, and clearly identify anything not yet proven.**

   My goal is to reinstall Windows without losing valuable work or spending additional time and resources rebuilding capabilities we already developed.

   Integrate these requirements into the currently approved Hybrid strategy, using the smallest justified changes and existing contracts wherever possible.

   **Workbench must make agents smarter, more autonomous, and more productive — while remaining lightweight, recoverable, and genuinely useful for building ORVION.**
   ```

   The resulting file's Git blob is c0da6d22a4246c890aca103ec7afc89294a5192f.

16. Check whether `docs/owner/recovery-inputs/owner-main-approval-ws013.txt` contains `OWNER APPROVAL - MAIN PROMOTION (received 2026-10-25 ~21:20Z, Claude session b0862c78)`; if so record Already Applied when its Git blob is 3a2f4e722a5e5aa3f5a54bc4b4270235336541ae, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   OWNER APPROVAL - MAIN PROMOTION (received 2026-10-25 ~21:20Z, Claude session b0862c78)

   Verbatim owner words:
   "i give you my aprove to promote to main when you need my approval
   and try to fix OMC if it must fix
   and continue the paln until you become satisfaide and be safe to resume batch 6"

   Agent interpretation, stated back to the owner in the same session before use:
   - Exactly ONE ordinary non-force fast-forward of
     ca081c33e1c6767c468de3e453f51d56de50b54b
     to Shehabhub/ORVION-Workbench refs/heads/main,
     expected old main d4d0ece52ad23af8cf98a3e1c52eaa98464d8017.
   - Only after hosted run 40233793042 (attempt 1, push, workbench-preflight, head ca081) is terminal SUCCESS
     with the required workbench-acceptance check from GitHub Actions app 15368 and meaningful Verify.
   - Ruleset 25827491 stays ACTIVE throughout; no exception, no settings change, no force, no retry,
     no alternate SHA/ref, no trusted-baseline advancement.
   - Fresh exact refs immediately before dispatch; any drift or failure stops without retry.
   - Lifting Batch 6 / Phase 8 holds or closing CTRL-19 is NOT granted by this text; the owner decides.
   ```

   The resulting file's Git blob is 3a2f4e722a5e5aa3f5a54bc4b4270235336541ae.

17. Check whether `docs/owner/recovery-inputs/OWNER-REQUEST-DELEGATE-SKILLS.md` contains `# Owner message received 2026-10-26 in session b0862c78-8372-43af-b4c1-eee9dd4ef223, during execution of OWNER-DELEGATION.md (verbatim)`; if so record Already Applied when its Git blob is 1ce65f56b9badf4dc8b4b5152d84583541dd4482, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # Owner message received 2026-10-26 in session b0862c78-8372-43af-b4c1-eee9dd4ef223, during execution of OWNER-DELEGATION.md (verbatim)

   ---

   **OWNER REQUEST — EVALUATE AND ADOPT AHMED EL NAGDY'S DELEGATE SKILLS**

   I found this open-source project:

   https://github.com/amElnagdy/delegate-skills

   Please study its official documentation, source code, execution permissions, Windows/WSL compatibility, and existing verification evidence.

   I want to consider it as a lightweight assistant for our existing ORVION Workbench agents.

   **My intended workflow:**

   Hunt discovers problems → Spider identifies relevant evidence → the main agent delegates a suitable bounded task → the assistant agent investigates or implements → the main agent reviews, verifies, and completes the native workflow.

   Focus initially on `codex-delegate`, allowing Claude Code to delegate appropriate tasks to Codex.

   Do not install the entire fleet or introduce additional persistent services unnecessarily.

   If the installed CLIs, security boundaries, resource limits, and native governance are compatible, I authorize installing the smallest required Delegate skill after source review, using a pinned, reproducible version.

   Start with one inexpensive, isolated, non-production validation that demonstrates whether delegation actually works.

   Preserve all original approval, Git, Finish, certification and release authorities. Delegated agents must not independently commit, publish, promote, handle owner secrets, or bypass native gates.

   Measure whether this improves execution speed, context efficiency, diagnosis quality, and owner independence without disproportionate RAM, CPU, or token consumption.

   If it provides real value, retain its installation instructions, exact version, configuration, and required source files within our permanent portable Workbench recovery assets.

   **Most importantly, do not delay the current recovery strategy or Batch 6 solely to integrate Delegate.**

   I want Delegate to make Workbench genuinely useful by helping agents perform work, not create another expensive orchestration framework.
   ```

   The resulting file's Git blob is 1ce65f56b9badf4dc8b4b5152d84583541dd4482.

18. Check whether `docs/owner/recovery-inputs/README.md` contains `# recovery-inputs`; if so record Already Applied when its Git blob is 208efc5d792f672cb5868662b08ecb9ebdeca7a4, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # recovery-inputs

   Purpose: Backup inputs that live nowhere else, flat, with their hash map. Kind: owner-texts. Lifetime: permanent.
   Reader: Backup-Workspace.
   Rules: added only through lib/Organize.ps1 or by the tool named in Reader.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   | OWNER-APPROVAL-AB.txt | owner-texts | - | - | - |
   | OWNER-DECISION-20261027-evidence-and-trusted.md | owner-texts | Owner decisions 2026-10-27 (recorded by the orchestrator from the owner's answers) | - | - |
   | OWNER-DECISION-20261027-no-reinstall.md | owner-texts | Owner decision, 2026-10-27 (~00:15 Cairo): no Windows reinstall; amend lift criterion 5 | - | - |
   | OWNER-DELEGATION.md | owner-texts | Owner message received 2026-10-26 in the Claude Code session b0862c78-8372-43af-b4c1-eee9dd4ef223 (verbatim) | - | - |
   | OWNER-DIRECTIVE-REINSTALL.md | owner-texts | Owner message received 2026-10-26 in session b0862c78-8372-43af-b4c1-eee9dd4ef223, during execution of OWNER-DELEGATION.md (verbatim) | - | - |
   | OWNER-REQUEST-DELEGATE-SKILLS.md | owner-texts | Owner message received 2026-10-26 in session b0862c78-8372-43af-b4c1-eee9dd4ef223, during execution of OWNER-DELEGATION.md (verbatim) | - | - |
   | batch6-hold-directive.json | owner-texts | - | - | - |
   | owner-main-approval-ws013.txt | owner-texts | - | - | - |
   | recovery-inputs.json | owner-texts | - | - | - |
   | ws013-hosted-acceptance.json | owner-texts | - | - | - |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:35Z | new | - | docs/owner/recovery-inputs | T10 organizer |
   <!-- /organize:changes -->

   ## LF copies and their originals

   Git stores LF, so two files here are LF copies. The bytes a backup pins are this folder's. The originals stay unaltered at the listed
   paths with their original hashes (owner decision D118 in the decisions archive).
   own-finish-receipt.json is not in Git: the map pins its original at data/records with its original hash (owner decision D119).

   | File here | LF SHA256, the pin in recovery-inputs.json | Original, unaltered | Original SHA256 | Difference |
   | --- | --- | --- | --- | --- |
   | ws013-hosted-acceptance.json | 6E48B84198DB0F3F8A19787F021419BF87EC6A3DF3F5D3F75E09B62C61AF0D73 | data/records/recovery-inputs/ws013-hosted-acceptance.json | 3043798C16B1F344BED72CF8A188253E780B6BFEF4E00621759026E98B8D01D2 | CRLF to LF |
   | batch6-hold-directive.json | A8D17209C96728123DD148A28F386BB15498D87E34E4BF900C0577BBA43A1125 | data/records/recovery-inputs/batch6-hold-directive.json | BC54E998EA6D7B93422DBA542160D9C8F3E32E17E80538A77E5249B7AD9F233B | CRLF to LF |
   ```

   The resulting file's Git blob is 208efc5d792f672cb5868662b08ecb9ebdeca7a4.

19. Check whether `docs/owner/recovery-inputs/recovery-inputs.json` contains `"schema": 1,`; if so record Already Applied when its Git blob is e7857e76b8aa9770a2a8273c0a33d62598632a10, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   {
     "schema": 1,
     "inputs": [
       {
         "name": "owner-delegation-20261026",
         "path": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\docs\\owner\\recovery-inputs\\OWNER-DELEGATION.md",
         "sha256": "94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217"
       },
       {
         "name": "owner-directive-reinstall",
         "path": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\docs\\owner\\recovery-inputs\\OWNER-DIRECTIVE-REINSTALL.md",
         "sha256": "C70FFE2D6EBF5D343D7D6579066D51484C36D3C5BEA6FCAB1AA78C72738D86B9"
       },
       {
         "name": "owner-request-delegate",
         "path": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\docs\\owner\\recovery-inputs\\OWNER-REQUEST-DELEGATE-SKILLS.md",
         "sha256": "26C52A20842FBC04AC913CA259A8DC5CDF71CB970A8F6AA681D605EE631CC178"
       },
       {
         "name": "owner-main-approval-ws013",
         "path": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\docs\\owner\\recovery-inputs\\owner-main-approval-ws013.txt",
         "sha256": "CD689663337F8C0FFBAEC21932A0F27F690488AF20117A0D4589F005DDFC3148"
       },
       {
         "name": "owner-approval-ab",
         "path": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\docs\\owner\\recovery-inputs\\OWNER-APPROVAL-AB.txt",
         "sha256": "330F8E099FE6D2B4F638052CCE7AAE59D34281EAB86053623B1B4616925DBD59"
       },
       {
         "name": "ws013-sandbox-receipt",
         "path": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\data\\records\\judge-evidence\\WS-013\\sandbox\\own-finish-receipt.json",
         "sha256": "0B7F5C2E504746B9DE07C40A8A350913A497B96F50186981A735359162471252"
       },
       {
         "name": "ws013-hosted-acceptance",
         "path": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\docs\\owner\\recovery-inputs\\ws013-hosted-acceptance.json",
         "sha256": "6E48B84198DB0F3F8A19787F021419BF87EC6A3DF3F5D3F75E09B62C61AF0D73"
       },
       {
         "name": "batch6-hold-directive",
         "path": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\docs\\owner\\recovery-inputs\\batch6-hold-directive.json",
         "sha256": "A8D17209C96728123DD148A28F386BB15498D87E34E4BF900C0577BBA43A1125"
       },
       {
         "name": "owner-decision-no-reinstall",
         "path": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\docs\\owner\\recovery-inputs\\OWNER-DECISION-20261027-no-reinstall.md",
         "sha256": "7273A8A9C5AE3AF168EA975D0AE07511F472F3EF65C92F717A54236E9F2094E9"
       },
       {
         "name": "owner-decision-evidence-trusted",
         "path": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\docs\\owner\\recovery-inputs\\OWNER-DECISION-20261027-evidence-and-trusted.md",
         "sha256": "311C468F080FAFA10313101C5F89157FAEBC90180244372AC825EC83F940BBB6"
       }
     ]
   }
   ```

   The resulting file's Git blob is e7857e76b8aa9770a2a8273c0a33d62598632a10.

20. Check whether `docs/owner/recovery-inputs/ws013-hosted-acceptance.json` contains `"observedUtc": "2026-10-25T21:45:42.0205548Z",`; if so record Already Applied when its Git blob is d443f98e8b82c015206d0c365cdad7067d42f176, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   {
     "observedUtc": "2026-10-25T21:45:42.0205548Z",
     "runId": 40233793042,
     "attempt": 1,
     "event": "push",
     "branch": "workbench-preflight",
     "headSha": "ca081c33e1c6767c468de3e453f51d56de50b54b",
     "workflow": "Workbench acceptance",
     "conclusion": "success",
     "completedUtc": "2026-10-25T21:18:45Z",
     "checkRunId": 121290917897,
     "checkName": "workbench-acceptance",
     "checkConclusion": "success",
     "appId": 15368,
     "appSlug": "github-actions",
     "verifyConclusion": "success",
     "verifyStartedUtc": "2026-10-25T21:05:19Z",
     "verifyCompletedUtc": "2026-10-25T21:18:42Z",
     "observation": "reads 21:14Z in_progress, 21:30Z transport timeout (UNKNOWN, no retry), 21:45Z terminal; within approved 70-min/15-min cadence"
   }
   ```

   The resulting file's Git blob is d443f98e8b82c015206d0c365cdad7067d42f176.

21. Check whether `docs/README.md` contains `| owner/ | owner-texts | The owner's words and the recovery inputs | agents, the owner, Backup-Workspace | 2026-11-04 |`; if so record Already Applied when its Git blob is 4ca02012ee61a3f43f1a30d12837e4dfff658a78, and otherwise stop and report. Otherwise make exactly these 3 edits (land this exact frozen WS-035 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | history/ | archive | the index of history: allocated contracts and frozen records | the Markdown guard (its History index); agents tracing why something changed | - |
   ```
   insert
   ```text
   | owner/ | owner-texts | The owner's words and the recovery inputs | agents, the owner, Backup-Workspace | 2026-11-04 |
   ```

   b) immediately after the line
   ```text
   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   ```
   insert
   ```text
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:34Z | new | - | docs/owner | T10 organizer |
   ```

   c) immediately after the line
   ```text
   <!-- /organize:changes -->
   ```
   insert
   ```text

   ## Files

   - [owner/README.md](owner/README.md)
   - [../records/README.md](../records/README.md)
   ```

   The resulting file's Git blob is 4ca02012ee61a3f43f1a30d12837e4dfff658a78.

22. Check whether `docs/WORKSPACE-LAYOUT.md` contains `| Markdown guard (lib/Test-MarkdownConsistency.ps1; read-only: the working tree, the index or a Git tree, never an outside path) | the Finish schedule | every tracked Markdown file reachable from README.md or AGENTS.md through local links, unless it is history (an allocated contract, or a link in the History index of docs/history/README.md); links and anchors resolved case-sensitively from their file; the One-home table of WORKFLOW.md (each concept once, in its fixed home); only RESUME.md declares the active contract pointer; no duplicate prose paragraph of 25 words or more; no header date older than a body amendment; a retired path never as an instruction; DEC-ID uniqueness, watch patterns (never on a frozen owner text whose exact bytes the guard pins, and no other check is skipped), archive append-only with every item naming an existing entry, size budgets in bytes after CRLF to LF (AGENTS.md 1.5 KB, NOW.md 6 KB, README.md 8 KB, DECISIONS.md 40 KB, RESUME.md 900 B, HANDOFF.md 4,500 B, WORKFLOW.md 20,300 B, injected hook text), links and line length (<= 200; table rows exempt) in active files; section IDs and citations (records/WS-033/signposting.md section 5) |`; if so record Already Applied when its Git blob is 0f1f4182bb5e9ada9e8a16c2ec14409d6942b4e7, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-035 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   | Markdown guard (lib/Test-MarkdownConsistency.ps1; read-only: the working tree, the index or a Git tree, never an outside path) | the Finish schedule | every tracked Markdown file reachable from README.md or AGENTS.md through local links, unless it is history (an allocated contract, or a link in the History index of docs/history/README.md); links and anchors resolved case-sensitively from their file; the One-home table of WORKFLOW.md (each concept once, in its fixed home); only RESUME.md declares the active contract pointer; no duplicate prose paragraph of 25 words or more; no header date older than a body amendment; a retired path never as an instruction; DEC-ID uniqueness, watch patterns, archive append-only with every item naming an existing entry, size budgets in bytes after CRLF to LF (AGENTS.md 1.5 KB, NOW.md 6 KB, README.md 8 KB, DECISIONS.md 40 KB, RESUME.md 900 B, HANDOFF.md 4,500 B, WORKFLOW.md 20,300 B, injected hook text), links and line length (<= 200; table rows exempt) in active files; section IDs and citations (records/WS-033/signposting.md section 5) |
   ```
   with
   ```text
   | Markdown guard (lib/Test-MarkdownConsistency.ps1; read-only: the working tree, the index or a Git tree, never an outside path) | the Finish schedule | every tracked Markdown file reachable from README.md or AGENTS.md through local links, unless it is history (an allocated contract, or a link in the History index of docs/history/README.md); links and anchors resolved case-sensitively from their file; the One-home table of WORKFLOW.md (each concept once, in its fixed home); only RESUME.md declares the active contract pointer; no duplicate prose paragraph of 25 words or more; no header date older than a body amendment; a retired path never as an instruction; DEC-ID uniqueness, watch patterns (never on a frozen owner text whose exact bytes the guard pins, and no other check is skipped), archive append-only with every item naming an existing entry, size budgets in bytes after CRLF to LF (AGENTS.md 1.5 KB, NOW.md 6 KB, README.md 8 KB, DECISIONS.md 40 KB, RESUME.md 900 B, HANDOFF.md 4,500 B, WORKFLOW.md 20,300 B, injected hook text), links and line length (<= 200; table rows exempt) in active files; section IDs and citations (records/WS-033/signposting.md section 5) |
   ```

   The resulting file's Git blob is 0f1f4182bb5e9ada9e8a16c2ec14409d6942b4e7.

23. Check whether `lib/test-markdown-consistency.ps1` contains `$repositoryPins=[Collections.Generic.Dictionary[string,string]]::new($FrozenOwnerTexts,[StringComparer]::Ordinal)`; if so record Already Applied when its Git blob is 7b6e001e780a9ac4de07c1ff37b1a3aa3ccedef8, and otherwise stop and report. Otherwise make exactly these 5 edits (land this exact frozen WS-035 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   . $Guard
   ```
   insert
   ```text
   $repositoryPins=[Collections.Generic.Dictionary[string,string]]::new($FrozenOwnerTexts,[StringComparer]::Ordinal)
   ```

   b) immediately after the line
   ```text
       externalUnapproved=@('MD_EXTERNAL_UNAPPROVED',{param($directory) Edit-MarkdownFixture $directory 'docs/guide.md' '# Guide' ('# Guide'+$nl+'[wrong](../../missing.md)')})
   ```
   insert
   ```text
       frozenPinned=@('',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}The widget count is 6.$nl"})
       frozenAltered=@('MD_WATCH',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}The widget count is 7.$nl" -Pinned "# Text$nl${nl}The widget count is 6.$nl"})
       frozenUnpinned=@('MD_WATCH',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}The widget count is 6.$nl" -Path 'docs/owner/t/OTHER.md'})
       frozenOrphan=@('MD_ORPHAN',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}The widget count is 6.$nl" -Unlinked})
       frozenRetired=@('MD_RETIRED_ROUTE',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}Run Documents\ORVION-Sandbox\old.ps1$nl"})
       frozenCitation=@('MD_SECTION_MISSING',{param($directory) Add-FrozenFixture $directory "# Text$nl${nl}See ${d}77.$nl"})
   ```

   c) immediately after the lines
   ```text
       emptyInventory=@('MD_INPUT_EMPTY',{param($directory) $null=Invoke-MarkdownFixtureGit $directory @('rm','-r','--cached','--quiet','.')})
   }
   ```
   insert
   ```text
   function Add-FrozenFixture([string]$Directory,[string]$Text,[string]$Path='docs/owner/t/TEXT.md',[string]$Pinned=$Text,[switch]$Unlinked){
       # One fixture pin at one fixed path, on the fixture's own words; the repository's pins are checked below.
       $FrozenOwnerTexts['docs/owner/t/TEXT.md']=Get-MarkdownTextHash $Pinned
       Write-MarkdownFixture (Join-Path $Directory $Path) $Text
       if(!$Unlinked){Edit-MarkdownFixture $Directory 'README.md' '[History](docs/history/README.md)' "[History](docs/history/README.md) [frozen]($Path)"}
   }
   ```

   d) immediately after the line
   ```text
           $script:passed++;'PASS NOW.md values match WORKSPACE-LAYOUT.md'
   ```
   insert
   ```text
           # Each pin in the guard holds on the repository's own bytes: a stale or absent frozen text fails here.
           $repository=Get-MarkdownInput (Split-Path $PSScriptRoot -Parent) $RepositoryTree
           foreach($pin in $repositoryPins.GetEnumerator()){
               if(!$repository.ContainsKey($pin.Key)-or(Get-MarkdownTextHash ($repository[$pin.Key]-replace"`r`n","`n"))-cne$pin.Value){throw "FAIL frozenPin: $($pin.Key)"}
               $script:passed++;"PASS frozen pin $($pin.Key)"
           }
   ```

   e) immediately after the lines
   ```text
               $script:passed++;"PASS MUTANT KILLED $caseName"
           }
   ```
   insert
   ```text
           # The exemption's edges: each mutant removes it or widens it one way, and the case that owns that edge must fail.
           $pinCheck='$frozen=$FrozenOwnerTexts[$path]-ceq(Get-MarkdownTextHash $text)'
           $widened=[ordered]@{
               frozenPinned=@($pinCheck,'$frozen=$false')
               frozenAltered=@($pinCheck,'$frozen=$FrozenOwnerTexts.ContainsKey($path)')
               frozenUnpinned=@($pinCheck,'$frozen=$path-clike''docs/owner/*''')
               frozenOrphan=@('if(!$reachable.Contains($path)-and!$history.Contains($path)){','if(!$reachable.Contains($path)-and!$history.Contains($path)-and!$FrozenOwnerTexts.ContainsKey($path)){')
               frozenRetired=@('if($routing-match$retired-and$routing-notmatch ''^Historical citation:''){','if($routing-match$retired-and$routing-notmatch ''^Historical citation:''-and!$FrozenOwnerTexts.ContainsKey($path)){')
               frozenCitation=@('Assert-MarkdownCitations $path $text $sections','if(!$frozen){Assert-MarkdownCitations $path $text $sections}')
           }
           foreach($caseName in $widened.Keys){
               if(!$source.Contains($widened[$caseName][0])){throw "MD_MUTANT_STALE: $caseName"}
               $mutant=Join-Path $scratch ('mutant-'+$caseName+'.ps1');Write-MarkdownFixture $mutant ($source.Replace($widened[$caseName][0],$widened[$caseName][1]))
               $output=& pwsh -NoProfile -File $PSCommandPath -Guard $mutant -NoMutants -Case $caseName 2>&1
               if($LASTEXITCODE-eq0-or($output-join$nl)-notmatch("FAIL "+$caseName+" expected")){throw "MD_MUTANT_SURVIVED: $caseName $output"}
               $script:passed++;"PASS MUTANT KILLED $caseName"
           }
   ```

   The resulting file's Git blob is 7b6e001e780a9ac4de07c1ff37b1a3aa3ccedef8.

24. Check whether `lib/Test-MarkdownConsistency.ps1` contains `# A frozen text (WORKSPACE-LAYOUT.md section 23) keeps its words: these exact bytes, after CRLF to LF, skip the watch patterns and no other check.`; if so record Already Applied when its Git blob is 01690d30f54a9cd207acb9114a807a7b3933cda3, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-035 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   $NowSections=@('Now','Done last','Next','Owner questions','Pending decisions','Running','Pointers');$NowPointers=8;$NowBudget=6144
   ```
   insert
   ```text
   # A frozen text (WORKSPACE-LAYOUT.md section 23) keeps its words: these exact bytes, after CRLF to LF, skip the watch patterns and no other check.
   $FrozenOwnerTexts=[Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
   $FrozenOwnerTexts['docs/owner/20261031-owner-directive-improvement-ws/DIRECTIVE.md']='E58EC467F29CDDA0F9C749A39807E760CDC1BCD9CD0607630036C2C925D29C4F'
   function Get-MarkdownTextHash([string]$Text){[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($Text)))}
   ```

   b) replace the lines
   ```text
               $lines=$text.Split("`n")
               for($i=0;$i-lt$lines.Count;$i++){foreach($id in $watches.Keys){if($watches[$id].IsMatch($lines[$i])-and!$lines[$i].Contains($id)){throw "MD_WATCH: ${path}:$($i+1) matches the Watch pattern of $id without citing it"}}}
   ```
   with
   ```text
               $lines=$text.Split("`n");$frozen=$FrozenOwnerTexts[$path]-ceq(Get-MarkdownTextHash $text)
               for($i=0;!$frozen-and$i-lt$lines.Count;$i++){foreach($id in $watches.Keys){if($watches[$id].IsMatch($lines[$i])-and!$lines[$i].Contains($id)){throw "MD_WATCH: ${path}:$($i+1) matches the Watch pattern of $id without citing it"}}}
   ```

   The resulting file's Git blob is 01690d30f54a9cd207acb9114a807a7b3933cda3.

25. Check whether `records/README.md` contains `Purpose: One short summary per finished workstream. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is da8ad20b629ec6ee6f3b9d8af43c3ae491dee9e8, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # records

   Purpose: One short summary per finished workstream. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: added only through lib/Organize.ps1 or by the tool named in Reader.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   | WS-022/ | records | Summary of WS-022 one clean layout | agents, the owner | 2026-11-04 |
   | WS-023/ | records | Summary of WS-023 recovery launcher | agents, the owner | 2026-11-04 |
   | WS-025/ | records | Summary of WS-025 codex tripwire | agents, the owner | 2026-11-04 |
   | WS-026/ | records | Summary of WS-026 governed delegation | agents, the owner | 2026-11-04 |
   | WS-027/ | records | Summary of WS-027 daily backup | agents, the owner | 2026-11-04 |
   | WS-028/ | records | Summary of WS-028 record integrity | agents, the owner | 2026-11-04 |
   | WS-029/ | records | Summary of WS-029 restore long path cleanup | agents, the owner | 2026-11-04 |
   | WS-030/ | records | Summary of WS-030 recovery diagnostics successor | agents, the owner | 2026-11-04 |
   | WS-031/ | records | Summary of WS-031 native feature preflight | agents, the owner | 2026-11-04 |
   | WS-032/ | records | Summary of WS-032 deferred proposal (no change file) | agents, the owner | 2026-11-04 |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:36Z | new | - | records/WS-022 | T10 organizer |
   | 2026-11-04T17:40:37Z | new | - | records/WS-023 | T10 organizer |
   | 2026-11-04T17:40:38Z | new | - | records/WS-025 | T10 organizer |
   | 2026-11-04T17:40:39Z | new | - | records/WS-026 | T10 organizer |
   | 2026-11-04T17:40:39Z | new | - | records/WS-027 | T10 organizer |
   | 2026-11-04T17:40:40Z | new | - | records/WS-028 | T10 organizer |
   | 2026-11-04T17:40:41Z | new | - | records/WS-029 | T10 organizer |
   | 2026-11-04T17:40:41Z | new | - | records/WS-030 | T10 organizer |
   | 2026-11-04T17:40:42Z | new | - | records/WS-031 | T10 organizer |
   | 2026-11-04T17:40:43Z | new | - | records/WS-032 | T10 organizer |
   <!-- /organize:changes -->

   ## Reading a summary

   A summary's failure list: Each line: the record, what happened, and the reason with the place that states it. UNPROVEN: no record states the
   reason. Not listed: test outputs of designed refusals, mutants, tools, start markers, saves and owner stops.

   [masked] in a run-start line stands for the computer name or a script name of another product; the evidence copy under data/records keeps the bytes (owner decision D119).

   ## Files

   - [WS-022/README.md](WS-022/README.md)
   - [WS-023/README.md](WS-023/README.md)
   - [WS-025/README.md](WS-025/README.md)
   - [WS-026/README.md](WS-026/README.md)
   - [WS-027/README.md](WS-027/README.md)
   - [WS-028/README.md](WS-028/README.md)
   - [WS-029/README.md](WS-029/README.md)
   - [WS-030/README.md](WS-030/README.md)
   - [WS-031/README.md](WS-031/README.md)
   - [WS-032/README.md](WS-032/README.md)
   ```

   The resulting file's Git blob is da8ad20b629ec6ee6f3b9d8af43c3ae491dee9e8.

26. Check whether `records/WS-022/README.md` contains `Purpose: Summary of WS-022 one clean layout. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is 7c871df450a1a611476e77dc82554c673f90dcd5, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # WS-022

   Purpose: Summary of WS-022 one clean layout. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:36Z | new | - | records/WS-022 | T10 organizer |
   <!-- /organize:changes -->

   # WS-022 one clean layout

   Summary of a finished workstream (DEC-11), written in WS-033 step P1.3b by records/WS-033/summaries.ps1 from the
   change file, the receipt, the attempt records (records/WS-033/attempts.tsv) and records/WS-033/cited.tsv; it changes
   no evidence.
   Evidence: records/WS-022/.

   ## Result

   - Change file: ORVION-Workbench/changes/WS-022-one-clean-layout.md, SHA256 DCDDE153DD5ED16704200648E007FB3EDA283FC4E891E06D5F80A2F2D03239E8
   - Status: Complete
   - Verdict: Confirmed Complete
   - Reviewed Fingerprint: D7C37E1AD960B4639CCDA60721E4C82135B860937FDCBEDC320AEAAEE11B7FBB
   - Reviewed Receipt: 2DAA76F11D1B0CE6C35C261CE874CCB135F9B923780C80D287F91A9DACD5DC7C

   ## Receipt

   The original own Finish receipt, `records/WS-022/package/runtime/original/own-finish-receipt.json`, SHA256 EFE6398BE342339F5F271D38625728B4877534CCAE43AD5EC2BAC2F0BE262A96; its digest equals the Reviewed Receipt above:

   ~~~json
   {
     "schema": 2,
     "root": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench",
     "contract": "changes/WS-022-one-clean-layout.md",
     "finishHead": "d88cae362b7cbae61c16ca7cc3bfc43eb1983606",
     "fingerprint": "D7C37E1AD960B4639CCDA60721E4C82135B860937FDCBEDC320AEAAEE11B7FBB",
     "profiles": [
       "CONTROL",
       "COORDINATION",
       "RECOVERY",
       "REPOSITORY"
     ],
     "evaluator": "0359914cae98f493a59d202649cd2fe2ee29fcf3",
     "runLog": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Owner-Tools\\records\\WS-022\\package\\runtime\\original\\finish.log",
     "runStart": "[2026-10-27 12:51:39] START pid=8128 host=[masked] pwsh=7.6.8 cpus=8 head=d88cae3 concurrent=Sync-Sessions.ps1,[masked],[masked],[masked],[masked],[masked],[masked],[masked],Run-OriginalFinish.ps1,Watch-Host.ps1 | & pwsh -NoProfile -File 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\lib\\Workbench.ps1' -Root 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench' -Finish -Actionlint 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\tools\\actionlint.exe'",
     "result": "READY",
     "draftSHA256": "D82689C72FB0480A95BC906640370D46B348C2DE54C9A34CFF409E577CF59F47",
     "recipe": "8D670A6E60DC9C6061CF30A97567E3D9E0E5A068FE955A67F34AEF143CAC7A38",
     "role": "ORIGINAL",
     "proof": "7C830373858F61687B6F9CFA6045A06546391D56EC4EDA4AF31B87B1BA064D38",
     "digest": "2DAA76F11D1B0CE6C35C261CE874CCB135F9B923780C80D287F91A9DACD5DC7C"
   }
   ~~~

   ## Failed, refused, superseded and stopped attempts (12)

   - `records/WS-022/package/superseded-attempt1-handoff-fence`: superseded. the positive literal control failed DRAFT_BLOB_MISMATCH:HANDOFF.md: the old HANDOFF fenced block cannot be expressed inside step fences (stated in records/WS-022/package/superseded-attempt1-handoff-fence/README.txt:1)
   - `records/WS-022/package/superseded-attempt2-edit-letters`: superseded. the positive control failed EDIT_FENCE_COUNT: docs/WORKSPACE-LAYOUT.md had 32 edits but the applier letters only a) to z) (stated in records/WS-022/package/superseded-attempt2-edit-letters/README.txt:1)
   - `records/WS-022/package/superseded-attempt3-blank-line`: superseded. HANDOFF blob mismatch: the lift-block edit dropped the blank line before section 12 (stated in records/WS-022/package/superseded-attempt3-blank-line/README.txt:1)
   - `records/WS-022/package/superseded-attempt4-runtime-root`: superseded. the Draft declared Runtime Root runtime directly under records/WS-022 while the lifecycle writes package\runtime (WB_CONTEXT_RUN_LOG_MISMATCH); caught before allocation (stated in records/WS-022/package/superseded-attempt4-runtime-root/README.txt:1)
   - `records/WS-022/package/superseded-attempt5-finish-hunt`: failed. the sandbox Finish was BLOCKED at preflight WB_REQUIRED_HUNT_FAILED: Hunt refused ORVION_DATA_ROOT_UNAVAILABLE because a sandbox clone has no sibling data root (stated in records/WS-022/package/superseded-attempt5-finish-hunt/README.txt:1)
   - `records/WS-022/package/superseded-attempt6-history-by-name`: failed. sandbox Finish attempt 2: 38 suites PASS, 1 FAIL test-markdown-consistency (MD_HISTORY_MISSING for the contract's own file, which exists only after allocation) (stated in records/WS-022/package/superseded-attempt6-history-by-name/README.txt:1)
   - `records/WS-022/package/superseded-sandbox-attempt1-runtime`: failed. the sandbox Finish stopped WORKBENCH: BLOCKED with an exception at lib/Hunt.ps1:18 (runner and watcher exit 1) (stated in records/WS-022/package/superseded-sandbox-attempt1-runtime/finish.log:4)
   - `records/WS-022/package/superseded-sandbox-attempt2-runtime`: failed. the sandbox Finish failed test-markdown-consistency.ps1 (runner and watcher exit 1) (stated in records/WS-022/package/superseded-sandbox-attempt2-runtime/finish.log:18)
   - `records/WS-022/package/superseded-original-attempt1-hunt-memory-prefix`: failed. the original Finish stopped after 0.3 min: WORKBENCH: BLOCKED, CODE: WB_REQUIRED_HUNT_FAILED (stated in records/WS-022/package/superseded-original-attempt1-hunt-memory-prefix/finish-watcher.log:3)
   - `records/WS-022/package/evidence/all-superseded-0826`: superseded. UNPROVEN: no record states the reason
   - `records/WS-022/package/evidence/all-superseded-1026`: superseded. UNPROVEN: no record states the reason
   - `records/WS-022/package/evidence/all-superseded-1105`: failed. the focused run failed "missing data readers report UNAVAILABLE and writers refuse stable code" (stated in records/WS-022/package/evidence/all-superseded-1105/focused.log:26)

   ## Cited files (6, from records/WS-033/cited.tsv)

   | File | SHA256 |
   | --- | --- |
   | records/WS-022/package/accepted/Test-WorkbenchChange.ps1 | 835E14DACE362A9ACF25E2ED5314F0E3CB8962DE8569A14FB46AC351A589848F |
   | records/WS-022/package/assurance/V1/DRAFT.md | 7D4346FC219330D4A030E66C2D72E0660EC1BAD8A32AB45C214A58C06994B043 |
   | records/WS-022/package/assurance/V2/DRAFT.md | B20A249AF3D8D1CFFC3EAE2216BBE8A9570B2B248DFC1936DC406C9588E38B16 |
   | records/WS-022/package/assurance/V3/DRAFT.md | D82689C72FB0480A95BC906640370D46B348C2DE54C9A34CFF409E577CF59F47 |
   | records/WS-022/package/release/single-promotion-attempt.json | 3A3554993A5BCE78FBADDF1B929F7CF95653A5C2763CEA3FD6190EE068352F7F |
   | records/WS-022/package/runtime/sandbox/own-finish-receipt.json | 1282CCB4989B89AA7C339CD68685F1B6154C9C7B1F2F072FBE61F0FDDC5B3F0E |
   ```

   The resulting file's Git blob is 7c871df450a1a611476e77dc82554c673f90dcd5.

27. Check whether `records/WS-023/README.md` contains `Purpose: Summary of WS-023 recovery launcher. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is 93c52e969e2182bc5cfd87c0458594a277c68a54, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # WS-023

   Purpose: Summary of WS-023 recovery launcher. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:37Z | new | - | records/WS-023 | T10 organizer |
   <!-- /organize:changes -->

   # WS-023 recovery launcher

   Historical citation: Summary of a finished workstream (DEC-11), written in WS-033 step P1.3b by records/WS-033/summaries.ps1 from the
   change file, the receipt, the attempt records (records/WS-033/attempts.tsv) and records/WS-033/cited.tsv; it changes
   no evidence.
   Evidence: `C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws023-package` (runtime and attempts) and records/WS-023/ (codex, release).

   ## Result

   - Change file: ORVION-Workbench/changes/WS-023-recovery-launcher.md, SHA256 0A9B25E0F3AD1DA12DC429CB77865DEA35F9C7D4F6CDDA98674B64A17F7815FA
   - Status: Complete
   - Verdict: Confirmed Complete
   - Reviewed Fingerprint: 8C93C3F67843CBBD080AE0148DB91587D42B0DA7D775C2C11E53C4407FDDFAAE
   - Reviewed Receipt: 2CCFCAA3924DE5A084D8BE577ED663C8A2F54B101F0D6B144B83EDC21E852B46

   ## Receipt

   Historical citation: The original own Finish receipt, `C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws023-package\runtime\original\own-finish-receipt.json`, SHA256 CFE415C0736FABD189DCADFB6D95C3E5B9ACDBBE0FFC341966868A975072CC32; its digest equals the Reviewed Receipt above:

   ~~~json
   {
     "schema": 2,
     "root": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench",
     "contract": "changes/WS-023-recovery-launcher.md",
     "finishHead": "6b749a0bf5dc6f88e7d702cf96dfc39050df729c",
     "fingerprint": "8C93C3F67843CBBD080AE0148DB91587D42B0DA7D775C2C11E53C4407FDDFAAE",
     "profiles": [
       "CONTROL",
       "RECOVERY",
       "REPOSITORY"
     ],
     "evaluator": "0359914cae98f493a59d202649cd2fe2ee29fcf3",
     "runLog": "C:\\Users\\My Lab\\Documents\\ORVION-Owner-Review\\engineering-continuation-20261025\\ws023-package\\runtime\\original\\finish.log",
     "runStart": "[2026-10-27 02:35:21] START pid=9500 host=[masked] pwsh=7.6.8 cpus=8 head=6b749a0 concurrent=Sync-Sessions.ps1,[masked],[masked],[masked],[masked],[masked],[masked],[masked],Run-OriginalFinish.ps1,Watch-Host.ps1 | & pwsh -NoProfile -File 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\lib\\Workbench.ps1' -Root 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench' -Finish -Actionlint 'C:\\Users\\My Lab\\Documents\\ORVION-Sandbox\\evidence\\WSsec\\grammar\\actionlint.exe'",
     "result": "READY",
     "draftSHA256": "A21DC3B204EDD02FB33782DF2829B4013D5A8C6F380ABB1D037CC68FE6494EEB",
     "recipe": "06E69E316DA7353601BAFA50CB2D6BBCAF8878C432CD95AE7F4E4B291573CAF5",
     "role": "ORIGINAL",
     "proof": "BBE95E2DA8C9091CFEDCDF34DC3FD6F6B296E3F8E2AB1C5F17C152D25DE9564A",
     "digest": "2CCFCAA3924DE5A084D8BE577ED663C8A2F54B101F0D6B144B83EDC21E852B46"
   }
   ~~~

   ## Failed, refused, superseded and stopped attempts (1)

   Historical citation: - `C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws023-package\superseded-attempt1-assurance-date`: refused. refused at sandbox Approval by the accepted judge, WB_ASSURANCE_DATE_INVALID: the Freeze dated V1-V3 2026-10-27 (Cairo) while UTC was 2026-10-26T21:58Z (stated in C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws023-package\superseded-attempt1-assurance-date\README.txt:1)

   ## Cited files (0, from records/WS-033/cited.tsv)

   None.
   ```

   The resulting file's Git blob is 93c52e969e2182bc5cfd87c0458594a277c68a54.

28. Check whether `records/WS-025/README.md` contains `Purpose: Summary of WS-025 codex tripwire. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is 1b0e4ec4f701cdf047d9b390683d643ce6693668, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # WS-025

   Purpose: Summary of WS-025 codex tripwire. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:38Z | new | - | records/WS-025 | T10 organizer |
   <!-- /organize:changes -->

   # WS-025 codex tripwire

   Summary of a finished workstream (DEC-11), written in WS-033 step P1.3b by records/WS-033/summaries.ps1 from the
   change file, the receipt, the attempt records (records/WS-033/attempts.tsv) and records/WS-033/cited.tsv; it changes
   no evidence.
   Evidence: records/WS-025/.

   ## Result

   - Change file: ORVION-Workbench/changes/WS-025-codex-tripwire.md, SHA256 CC92077EA03691B01D083AAE57740C4E12DEE2C8D185C171AD1C4FD1C5C6AE7B
   - Status: Complete
   - Verdict: Confirmed Complete
   - Reviewed Fingerprint: 2F028B2A2169BD1413E8E3D5DAB89ADB18EE4F5895C529276EBA0216089C63D6
   - Reviewed Receipt: 5BBFB115C2D9737554F18139DEB2E665CA01BCD0C7B12463CF3D0C9330E78FB6

   ## Receipt

   The original own Finish receipt, `records/WS-025/package/runtime/original/own-finish-receipt.json`, SHA256 89434F5EC781AF4120A13493D89B091CA57B5451022BEE7943368ADD4401350F; its digest equals the Reviewed Receipt above:

   ~~~json
   {
     "schema": 2,
     "root": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench",
     "contract": "changes/WS-025-codex-tripwire.md",
     "finishHead": "91134cf269fd1723b51842e2c74cab1c8d7cbaa4",
     "fingerprint": "2F028B2A2169BD1413E8E3D5DAB89ADB18EE4F5895C529276EBA0216089C63D6",
     "profiles": [
       "CONTROL",
       "COORDINATION",
       "REPOSITORY"
     ],
     "evaluator": "0359914cae98f493a59d202649cd2fe2ee29fcf3",
     "runLog": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Owner-Tools\\records\\WS-025\\package\\runtime\\original\\finish.log",
     "runStart": "[2026-10-27 14:47:12] START pid=17852 host=[masked] pwsh=7.6.8 cpus=8 head=91134cf concurrent=Sync-Sessions.ps1,[masked],[masked],[masked],[masked],[masked],[masked],[masked],Run-OriginalFinish.ps1,Watch-Host.ps1 | & pwsh -NoProfile -File 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\lib\\Workbench.ps1' -Root 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench' -Finish -Actionlint 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\tools\\actionlint.exe'",
     "result": "READY",
     "draftSHA256": "C667A55C52259BA61B922C1436288EE7E2110D0697B91E9BA8098EA51ADB3687",
     "recipe": "91E2836BE0D1A38028DEA76F7E6C0526083ABFB1490BBEEAED5599E6783C7D14",
     "role": "ORIGINAL",
     "proof": "22C5C86D091D235461E1AABF079CBDA5EA84842CAE3FC45713A66BBCA1F5AD6D",
     "digest": "5BBFB115C2D9737554F18139DEB2E665CA01BCD0C7B12463CF3D0C9330E78FB6"
   }
   ~~~

   ## Failed, refused, superseded and stopped attempts (1)

   - `records/WS-025/package/superseded-attempt1-scope-resume`: refused. Freeze attempt 1 was refused at sandbox approval, WB_WRITE_SCOPE_REFUSED:RESUME.md, because Freeze-WS025 dropped RESUME.md from the Write Scope (stated in records/WS-025/package/superseded-attempt1-scope-resume/WHY.txt:1)

   ## Cited files (7, from records/WS-033/cited.tsv)

   | File | SHA256 |
   | --- | --- |
   | records/WS-025/package/accepted/Test-WorkbenchChange.ps1 | 835E14DACE362A9ACF25E2ED5314F0E3CB8962DE8569A14FB46AC351A589848F |
   | records/WS-025/package/assurance/V1/DRAFT.md | 6A377F1238B9FEC15EC3E99A2CAAD573CBB959D5398DF880544316671DD20A79 |
   | records/WS-025/package/assurance/V2/DRAFT.md | A679DAF1D136F8B094A3B1587B1783CF90AA292EEAADC80068A5689360DD0AD9 |
   | records/WS-025/package/assurance/V3/DRAFT.md | C667A55C52259BA61B922C1436288EE7E2110D0697B91E9BA8098EA51ADB3687 |
   | records/WS-025/package/release/single-promotion-attempt.json | 117B7FAD940B16E420F848358CAA19ED7F1D49737DE48D4BAB9B46012211364B |
   | records/WS-025/package/runtime/sandbox/own-finish-receipt.json | FCE4BD18F6A4BAC7935B4573403E988DC758C438B1AE4EFF35D709228CF7C93B |
   | records/WS-025/review1-disposition.md | F3DD03FE2DF461C7D08C4247FE51CD3DD49EEE5D7EDB3E016DB5DC927A352A6C |
   ```

   The resulting file's Git blob is 1b0e4ec4f701cdf047d9b390683d643ce6693668.

29. Check whether `records/WS-026/README.md` contains `Purpose: Summary of WS-026 governed delegation. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is 3b7170fd7831a602a755cfc026329285e2eb4278, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # WS-026

   Purpose: Summary of WS-026 governed delegation. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:39Z | new | - | records/WS-026 | T10 organizer |
   <!-- /organize:changes -->

   # WS-026 governed delegation

   Summary of a finished workstream (DEC-11), written in WS-033 step P1.3b by records/WS-033/summaries.ps1 from the
   change file, the receipt, the attempt records (records/WS-033/attempts.tsv) and records/WS-033/cited.tsv; it changes
   no evidence.
   Evidence: records/WS-026/.

   ## Result

   - Change file: ORVION-Workbench/changes/WS-026-governed-delegation.md, SHA256 EFD7EADDFB019B1175BA8ACC1261AE4FC6F607FB5BF4916FD8F9CA4FE2A8C0D4
   - Status: Complete
   - Verdict: Confirmed Complete
   - Reviewed Fingerprint: 6E9F00F5461E40990ABEF840340E95BA5162E6B9EF3EC0835AFC1A168413A376
   - Reviewed Receipt: 00EB2D67CD59131E5052B6EAD79C11D1E600FE033E0B56436F5B2D49DF442CFA

   ## Receipt

   The original own Finish receipt, `records/WS-026/package/runtime/original/own-finish-receipt.json`, SHA256 CEF0C0BA5386D12E6943F99608AF9358DD3A1168538FA071DD9C4E5188DD5A2F; its digest equals the Reviewed Receipt above:

   ~~~json
   {
     "schema": 2,
     "root": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench",
     "contract": "changes/WS-026-governed-delegation.md",
     "finishHead": "98516a80e80194bfe7f583fe16abe4bd0d47f635",
     "fingerprint": "6E9F00F5461E40990ABEF840340E95BA5162E6B9EF3EC0835AFC1A168413A376",
     "profiles": [
       "CONTROL",
       "COORDINATION",
       "REPOSITORY"
     ],
     "evaluator": "0359914cae98f493a59d202649cd2fe2ee29fcf3",
     "runLog": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Owner-Tools\\records\\WS-026\\package\\runtime\\original\\finish.log",
     "runStart": "[2026-10-29 17:10:58] START pid=17432 host=[masked] pwsh=7.6.8 cpus=8 head=98516a8 concurrent=[masked],[masked],[masked],[masked],[masked],[masked],[masked],Sync-Sessions.ps1,Run-OriginalFinish.ps1,Run-OriginalFinish.ps1,Watch-Host.ps1 | & pwsh -NoProfile -File 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\lib\\Workbench.ps1' -Root 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench' -Finish -Actionlint 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\tools\\actionlint.exe'",
     "result": "READY",
     "draftSHA256": "29C1F472CE62126D3E1689B7A6DD9539E6F72C7FE1D6EB947AF9A21F2659A454",
     "recipe": "808739803280CA6FF0EE667AFD21FB7AA24944EB9A17DB463E420490F08A8F9D",
     "role": "ORIGINAL",
     "proof": "46FD8008A387ECF73B0584D0260487088EC0ACE7850DB10CF652976FCF0F040C",
     "digest": "00EB2D67CD59131E5052B6EAD79C11D1E600FE033E0B56436F5B2D49DF442CFA"
   }
   ~~~

   ## Failed, refused, superseded and stopped attempts (11)

   - `records/WS-026/package/v1`: failed. the V1 author transport failed with exit 1 and a turn.failed usage limit after the artifact was written; V1's owning delegate suite had 20 failing assertions (stated in ORVION-Workbench/changes/WS-026-governed-delegation.md:1801)
   - `records/WS-026/package/research-first-proof`: failed. the first Terra research attempt is LIVE_SEARCH_PASS_CONTROL_CONFIGURATION_FAILED: it ignored tools.view_image (stated in ORVION-Workbench/changes/WS-026-governed-delegation.md:1959)
   - `records/WS-026/package/assurance/V2/CAUSAL-AFTER-initial-failure.json`: failed. the initial V2 causal run had two assertion failures because the missing-events diagnostic replaced the earlier malformed-event/missing-type cause (stated in ORVION-Workbench/changes/WS-026-governed-delegation.md:1818)
   - `ORVION-Workbench/changes/WS-026-governed-delegation.md`: refused. the first V3-R2 setup put its synthetic data root beneath the clone's Git ancestor, and the unchanged launcher refused with CODEX_OUTPUT_ROOT_REFUSED; its log, CAUSAL-BEFORE-initial-setup-failure.log, is not in the records (stated in ORVION-Workbench/changes/WS-026-governed-delegation.md:2007)
   - `records/WS-026/package/assurance/V3-rejected-V3R2.diff`: rejected. V3 was rejected (verdict REVISE) on material finding F1: an invalid native item payload can succeed in lib/Delegate.ps1 (stated in ORVION-Workbench/changes/WS-026-governed-delegation.md:1906)
   - `ORVION-Workbench/changes/WS-026-governed-delegation.md`: failed. the first m1-tripwire mutant run is UNPROVEN as a kill: exit 1 did not establish the expected assertion because missing journal evidence stopped the diagnostic path earlier; V2-MUTANTS.json, which reports it, is not in the records (stated in ORVION-Workbench/changes/WS-026-governed-delegation.md:1928)
   - `records/WS-026/package/role-preflight-refusal.json`: refused. REFUSED_BEFORE_DISPATCH: task transport model sorting applied System.Version to the major-only version 6 (stated in records/WS-026/package/role-preflight-refusal.json:1)
   - `records/WS-026/package/r2-rebuttal-preparation-failure.json`: failed. the first array path expression lacked parentheses, so PowerShell joined all file names into one string (stated in records/WS-026/package/r2-rebuttal-preparation-failure.json:4)
   - `records/WS-026/package/r2-review-a/launch-preflight-failure.json`: failed. preparation's Where-Object used -ne0 as a command parameter and the launch went on before checking the preparation exit; the native launcher refused before Node dispatch (stated in records/WS-026/package/r2-review-a/launch-preflight-failure.json:4)
   - `records/WS-026/package/r2-review-b/launch-preflight-failure.json`: failed. preparation's Where-Object used -ne0 as a command parameter and the launch went on before checking the preparation exit; the native launcher refused before Node dispatch (stated in records/WS-026/package/r2-review-b/launch-preflight-failure.json:4)
   - `records/WS-026/package/runtime/sandbox/protected-head-supplement-initial-refusal.json`: refused. Verify-ProtectedHeadSupplement.ps1 refused "Original before refs changed": the original's Codex turn-diff captures and checkpoints differed from the pre-sandbox refs (stated in records/WS-026/package/runtime/sandbox/protected-head-supplement-initial-refusal.json:5)

   ## Cited files (84, from records/WS-033/cited.tsv)

   | File | SHA256 |
   | --- | --- |
   | records/WS-026/package/accepted/Test-WorkbenchChange.ps1 | 835E14DACE362A9ACF25E2ED5314F0E3CB8962DE8569A14FB46AC351A589848F |
   | records/WS-026/package/assurance/V1/DRAFT.md | 97D03D5D541A5E75E960A4A679A0979E4B14C30FDB3FD9A235CB2C755C8A2BD8 |
   | records/WS-026/package/assurance/V1/source/WORKFLOW.md | 2A2D65A906683316000AAE4F179C44F872904EDA2EAB2EB517D1FBAD6DD4A91F |
   | records/WS-026/package/assurance/V2/DRAFT.md | 640038F6635200EC3D9D25E52009B3D1F8281AFDB275AD469496B8F70C861631 |
   | records/WS-026/package/assurance/V2/source/lib/codex-relay.mjs | C52EAF48146F3B8D0BB4156368E0B8345E3AA379E70BB2381A346E07777CB5BD |
   | records/WS-026/package/assurance/V2/source/lib/Delegate.ps1 | EEE5EA37021D303C60116D2F20D50D62617BEB12E7D4CEB4AFC73DB91F4C7719 |
   | records/WS-026/package/assurance/V2/source/lib/README.md | 20999ECCD8AC8F86B6DBB3D1525B7F32456732F368B5A52355DB89B4D52D836A |
   | records/WS-026/package/assurance/V2/source/lib/test-delegate.ps1 | F84C57F7DF1A03B449205367DC028AA6C93D922BE07DD1967C0F955ABB21CE07 |
   | records/WS-026/package/assurance/V2/source/WORKFLOW.md | 2A2D65A906683316000AAE4F179C44F872904EDA2EAB2EB517D1FBAD6DD4A91F |
   | records/WS-026/package/assurance/V3-R2/DRAFT.md | 29C1F472CE62126D3E1689B7A6DD9539E6F72C7FE1D6EB947AF9A21F2659A454 |
   | records/WS-026/package/assurance/V3-R2/source/lib/codex-relay.mjs | C52EAF48146F3B8D0BB4156368E0B8345E3AA379E70BB2381A346E07777CB5BD |
   | records/WS-026/package/assurance/V3-R2/source/lib/Delegate.ps1 | 932B008868C094F5E0A3142DDBC690F720EF65EA8BE7439D719680E65330DE18 |
   | records/WS-026/package/assurance/V3-R2/source/lib/README.md | 20999ECCD8AC8F86B6DBB3D1525B7F32456732F368B5A52355DB89B4D52D836A |
   | records/WS-026/package/assurance/V3-R2/source/lib/test-delegate.ps1 | EA2D8766B93D1FA69C992D294DF28CC85763A52D733C9F74F012A419B50C8734 |
   | records/WS-026/package/assurance/V3-R2/source/WORKFLOW.md | 2A2D65A906683316000AAE4F179C44F872904EDA2EAB2EB517D1FBAD6DD4A91F |
   | records/WS-026/package/assurance/V3/DRAFT.md | B3B47C1A36E5F8DC502D674DF3012A92BE482C828CD9E3A67341B182A937430C |
   | records/WS-026/package/bootstrap/scaffold-r0/relay-original.mjs | D857CFCCF408E12D86B4A969C8C4544294919FE253A0096820ED9ED4D24FAB5C |
   | records/WS-026/package/GATE1-WS026-ORIGINAL-DELEGATED.md | 79DA8CFD5D195B88F7D605672DA82873BF5777B0BAAA2A3FE790FD8363DED0AB |
   | records/WS-026/package/OBSTACLE-AND-NEXT.md | 595CB6A0BF4C5FB31CDB4ACF3E2FC801F88210DE930CB966462A6BDA4A2819DF |
   | records/WS-026/package/research-first-proof/VERDICT.json | 1723B5AC2CFC750F6A9C0ADAFA5D7E8E17D7BCA56A95D8C4E6DD19BE9D6AAE91 |
   | records/WS-026/package/runtime/original/allocation-commit.log | 6985545BEEB27EC6C18AAAB6BBD04694E923A746696C01CB37D3B5E84FDFEDC4 |
   | records/WS-026/package/runtime/original/allocation.json | 8FD605E94FCA149D18E76790A5297553C3EB6674F71F1685965399DDF533F8CB |
   | records/WS-026/package/runtime/original/approval-commit.log | 17E021A26DE4587ED5C957DD752961BEE4FC31F55D7B2FFC3B7F704B24C47B1A |
   | records/WS-026/package/runtime/original/approval.json | 507D8B922615FBADC5CDE5D366FC3AD5D8F0C93A7E39B51800F3297FE3E1AAFF |
   | records/WS-026/package/runtime/original/before.json | 740C9E1330A60DE5355CCF6C72762FA8727BE2352200F4BC9CC630C176F8A5D8 |
   | records/WS-026/package/runtime/original/begin-commit.log | 0CFEF05FD452FF2B3A4EDC3DAD258C13A7A2ACFA4B43FED95A58A1A12E731794 |
   | records/WS-026/package/runtime/original/complete-commit.log | 60807E73516B63CDF78DC3389E2C906782C5557C182466D3100722524C5817C7 |
   | records/WS-026/package/runtime/original/complete-range.log | FCA967674CCC80209B9855CF9A31B0C8E7CFFA5E504CD74F8F402C4A35678D4B |
   | records/WS-026/package/runtime/original/criterion-review.json | 1783A62D7DD00233A1F6B6936DE78007801206E788659BED267D9A8CA53F88BB |
   | records/WS-026/package/runtime/original/finish-host.exit | 5FECEB66FFC86F38D952786C6D696C79C2DBC239DD4E91B46729D73A27FB57E9 |
   | records/WS-026/package/runtime/original/finish-host.log | 64D4478A657543A4560F5D79439DB10755ABCAB2162A3D26B3EA43D8FB07E556 |
   | records/WS-026/package/runtime/original/finish-host.stderr.log | E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855 |
   | records/WS-026/package/runtime/original/finish-runner.exit | 5FECEB66FFC86F38D952786C6D696C79C2DBC239DD4E91B46729D73A27FB57E9 |
   | records/WS-026/package/runtime/original/finish-runner.log | E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855 |
   | records/WS-026/package/runtime/original/finish-runner.stderr.log | E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855 |
   | records/WS-026/package/runtime/original/finish-watcher.exit | 5FECEB66FFC86F38D952786C6D696C79C2DBC239DD4E91B46729D73A27FB57E9 |
   | records/WS-026/package/runtime/original/finish-watcher.log | 5D41D01735A2DF4C2D687CAC0C1E55A647B345A038CE8F8D43D90AF41B60FABC |
   | records/WS-026/package/runtime/original/finish-watcher.stderr.log | E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855 |
   | records/WS-026/package/runtime/original/finish.log | 7C078B8B9ED9756B65C14BD528CCAAA52B3D7C73D59E103D04C62656A21D0D90 |
   | records/WS-026/package/runtime/original/finish.log.resources.csv | D4696865D9C3AE58CF698A87280B13700F13B6FCA78CE1873E68264A6B617AEC |
   | records/WS-026/package/runtime/original/implementation-commit.log | 0CFEF05FD452FF2B3A4EDC3DAD258C13A7A2ACFA4B43FED95A58A1A12E731794 |
   | records/WS-026/package/runtime/original/implementation-range.log | FCA967674CCC80209B9855CF9A31B0C8E7CFFA5E504CD74F8F402C4A35678D4B |
   | records/WS-026/package/runtime/original/implementation.json | 1A0BF0C80067A1283F0E7F04E1FC45648D586C6BF12E5970648D7B1568C5EAC9 |
   | records/WS-026/package/runtime/original/independent-finish-review.json | 2C308217370776EEAED54C649F54FE161CBB6FE85A03CE3F31960767AE32733E |
   | records/WS-026/package/runtime/original/launch-resources.json | 1D4424E515FAE7D31BC6EA914837AEEEB045E525ACF0FA8C05CC863432823906 |
   | records/WS-026/package/runtime/original/operation.json | 8A1D7C1CBB920747590CDA6D868E4490DA5F1C449C314D3DD7CCBF329D8EE75B |
   | records/WS-026/package/runtime/original/own-finish-receipt.json | CEF0C0BA5386D12E6943F99608AF9358DD3A1168538FA071DD9C4E5188DD5A2F |
   | records/WS-026/package/runtime/original/preflight.json | F2F353C3B1CC537347182CBD28E2B3FCD20413FFAE20D60B0DA8084867BDEC55 |
   | records/WS-026/package/runtime/original/result.json | 40DEB0DD7782F51FABE12C12498DE3E4AA4BC29B3236E82DB5CDDB0FA3B74479 |
   | records/WS-026/package/runtime/original/review-commit.log | 0CFEF05FD452FF2B3A4EDC3DAD258C13A7A2ACFA4B43FED95A58A1A12E731794 |
   | records/WS-026/package/runtime/original/run-result.json | A30BBB94C8A3AB110DCBFDCDAE48D5B102EC51266C4BD7337775D3379673E89B |
   | records/WS-026/package/runtime/original/timings.csv | 89E8B93BFCFE4DE1E13716C213A8BA53B7DE440D1BD23443F2493BF67A56DC0A |
   | records/WS-026/package/runtime/sandbox/allocation-commit.log | 6985545BEEB27EC6C18AAAB6BBD04694E923A746696C01CB37D3B5E84FDFEDC4 |
   | records/WS-026/package/runtime/sandbox/allocation.json | FE996F8D11634A749F9EBEDD020930C5398D4A4F12BA721767BF6E403E8E5146 |
   | records/WS-026/package/runtime/sandbox/approval-commit.log | 17E021A26DE4587ED5C957DD752961BEE4FC31F55D7B2FFC3B7F704B24C47B1A |
   | records/WS-026/package/runtime/sandbox/approval.json | 730A96AC7E504CC83FF4D3456E61C023FE46C22B1C56CC7FA13604BD55F0CD70 |
   | records/WS-026/package/runtime/sandbox/begin-commit.log | 0CFEF05FD452FF2B3A4EDC3DAD258C13A7A2ACFA4B43FED95A58A1A12E731794 |
   | records/WS-026/package/runtime/sandbox/complete-commit.log | 60807E73516B63CDF78DC3389E2C906782C5557C182466D3100722524C5817C7 |
   | records/WS-026/package/runtime/sandbox/complete-range.log | FCA967674CCC80209B9855CF9A31B0C8E7CFFA5E504CD74F8F402C4A35678D4B |
   | records/WS-026/package/runtime/sandbox/criterion-review.json | C00D6539EB11FD1EBC58FFE5E182AB3C3DC129A66563121243BA127885695F96 |
   | records/WS-026/package/runtime/sandbox/finish-host.exit | 5FECEB66FFC86F38D952786C6D696C79C2DBC239DD4E91B46729D73A27FB57E9 |
   | records/WS-026/package/runtime/sandbox/finish-host.log | 0EC9E7B95C4D1C1A7D4B7C714338EA72F7695273A45423902DF9A771CCACECC9 |
   | records/WS-026/package/runtime/sandbox/finish-host.stderr.log | E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855 |
   | records/WS-026/package/runtime/sandbox/finish-runner.exit | 5FECEB66FFC86F38D952786C6D696C79C2DBC239DD4E91B46729D73A27FB57E9 |
   | records/WS-026/package/runtime/sandbox/finish-runner.log | E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855 |
   | records/WS-026/package/runtime/sandbox/finish-runner.stderr.log | E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855 |
   | records/WS-026/package/runtime/sandbox/finish-watcher.exit | 5FECEB66FFC86F38D952786C6D696C79C2DBC239DD4E91B46729D73A27FB57E9 |
   | records/WS-026/package/runtime/sandbox/finish-watcher.log | 12C50E41A5367DEBC37E34475501AA8BCD3B0C9F67EF8A36F0F3A96249FE84D5 |
   | records/WS-026/package/runtime/sandbox/finish-watcher.stderr.log | E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855 |
   | records/WS-026/package/runtime/sandbox/finish.log | 19DF77B6620FE1120E7696F11938CF68B0753468C8A415E42197C80502D1BA0E |
   | records/WS-026/package/runtime/sandbox/finish.log.resources.csv | F1336CBA67352A966ADD845AD104F43F0BCA899EF50E6A252CA60008EC266361 |
   | records/WS-026/package/runtime/sandbox/implementation-commit.log | 0CFEF05FD452FF2B3A4EDC3DAD258C13A7A2ACFA4B43FED95A58A1A12E731794 |
   | records/WS-026/package/runtime/sandbox/implementation-range.log | FCA967674CCC80209B9855CF9A31B0C8E7CFFA5E504CD74F8F402C4A35678D4B |
   | records/WS-026/package/runtime/sandbox/implementation.json | A0584940EBF133304EA32B2D831E26129D0C86476D6484062DF320364809BFF3 |
   | records/WS-026/package/runtime/sandbox/independent-finish-review.json | 67F46E2E6F15CE555255A0EF6970BE9E1D10F82143C4D2A6E0541892122934C8 |
   | records/WS-026/package/runtime/sandbox/launch-resources.json | 919AE7E5EA4689AB60252A833854B491FC6F3BF73B407DD965CCDBDD2519A878 |
   | records/WS-026/package/runtime/sandbox/operation.json | FDBC339896B394C6740507E0D51877BA5135F979F8A65ACC4F2D18635F06D526 |
   | records/WS-026/package/runtime/sandbox/own-finish-receipt.json | 798E2178A8F6B55A6ABF66B2846329409C3072B7EB3C516460B7942F2981814F |
   | records/WS-026/package/runtime/sandbox/protected-head-supplement-initial-refusal.json | 16359076B5CFB1BF052B78EEBBF4A48303AAD66BC8E20BB9BB9B093BDFF9243A |
   | records/WS-026/package/runtime/sandbox/protected-head-supplement.json | FD4923A25B5245847F858BFC7B1D168FA065E61FBEFEABA24119F75358BE5D0B |
   | records/WS-026/package/runtime/sandbox/result.json | 4D52B4DFF6CBD374770EE92D14549E77FBE734469238D51E7794592B38612674 |
   | records/WS-026/package/runtime/sandbox/review-commit.log | 0CFEF05FD452FF2B3A4EDC3DAD258C13A7A2ACFA4B43FED95A58A1A12E731794 |
   | records/WS-026/package/runtime/sandbox/run-result.json | DBF3A8680A2307431CF31D95CA49E80679D3D7F61122C4C2FD61B48312621399 |
   | records/WS-026/package/runtime/sandbox/timings.csv | 544F15506859D04A8247180E995F9A49609A1D02D5F6CFBDEF8EFBC1961A7B85 |
   ```

   The resulting file's Git blob is 3b7170fd7831a602a755cfc026329285e2eb4278.

30. Check whether `records/WS-027/README.md` contains `Purpose: Summary of WS-027 daily backup. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is 3e8b5cdbeff5576544584fbd1d2742b58038d519, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # WS-027

   Purpose: Summary of WS-027 daily backup. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:39Z | new | - | records/WS-027 | T10 organizer |
   <!-- /organize:changes -->

   # WS-027 daily backup

   Summary of a finished workstream (DEC-11), written in WS-033 step P1.3b by records/WS-033/summaries.ps1 from the
   change file, the receipt, the attempt records (records/WS-033/attempts.tsv) and records/WS-033/cited.tsv; it changes
   no evidence.
   Evidence: records/WS-027/.

   ## Result

   - Change file: ORVION-Workbench/changes/WS-027-daily-backup.md, SHA256 40865507AD442082269EEC3EE0256C604497254FBA73DBAB8F8E99DA7793C73A
   - Status: Complete
   - Verdict: Confirmed Complete
   - Reviewed Fingerprint: E48EF249C67F632971B6AD1A4255DDB434AC316502CAF78117553CF33697B89A
   - Reviewed Receipt: 226F961CD9F737474C7DE377799032437E91294D5825B15231DE7EF032EAA7C4

   ## Receipt

   The original own Finish receipt, `records/WS-027/package/runtime/original/own-finish-receipt.json`, SHA256 1FB70E8E20151E048E11F36A05184BB0119301FD24D0BBFED5E79848F5B0D24E; its digest equals the Reviewed Receipt above:

   ~~~json
   {
     "schema": 2,
     "root": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench",
     "contract": "changes/WS-027-daily-backup.md",
     "finishHead": "5ca7958fed841cffb1a14cbf81640fa3de3d203e",
     "fingerprint": "E48EF249C67F632971B6AD1A4255DDB434AC316502CAF78117553CF33697B89A",
     "profiles": [
       "CONTROL",
       "RECOVERY",
       "REPOSITORY"
     ],
     "evaluator": "0359914cae98f493a59d202649cd2fe2ee29fcf3",
     "runLog": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Owner-Tools\\records\\WS-027\\package\\runtime\\original\\finish.log",
     "runStart": "[2026-10-31 00:04:19] START pid=19484 host=[masked] pwsh=7.6.8 cpus=8 head=5ca7958 concurrent=[masked],[masked],[masked],[masked],[masked],[masked],Sync-Sessions.ps1,Run-OriginalFinish.ps1,Watch-Host.ps1 | & pwsh -NoProfile -File 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\lib\\Workbench.ps1' -Root 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench' -Finish -Actionlint 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\tools\\actionlint.exe'",
     "result": "READY",
     "draftSHA256": "40C0E73C1851A4E47BF06558C7A2ED61E23501D06089A972C257F8B391FB619A",
     "recipe": "28B01A68E4BD7369FCA888E43E0718484F089B516154D13F3AB0ED538A6C5DA1",
     "role": "ORIGINAL",
     "proof": "76074AC6935650B55435113ED6A88BD0E0D95D15CA7C26BFF650E687A1ADDFE9",
     "digest": "226F961CD9F737474C7DE377799032437E91294D5825B15231DE7EF032EAA7C4"
   }
   ~~~

   ## Failed, refused, superseded and stopped attempts (18)

   - `records/WS-027/package/prototype`: failed. FAILED_USAGE_LIMIT_AFTER_TWO_READ_COMMANDS_BEFORE_AUTHORING (stated in records/WS-027/package/prototype/VERDICT.json:3)
   - `records/WS-027/package/prototype-r2/frozen/FAILED-COMMANDS.json`: failed. 3 author command(s) failed in this session; the record keeps each command with its output (first: exit 1, "{")
   - `records/WS-027/package/assurance/V1/evidence/draft-attempt-01.md`: failed. exit 1: the accepted applier reported IMPLEMENTATION_SECTION_MISSING (a required blank separator was missing) (stated in records/WS-027/package/assurance/V1/NOTES.md:41)
   - `records/WS-027/package/assurance/V1/evidence/draft-attempt-02.md`: failed. exit 1, exact test blob mismatch: native stdout decoding corrupted Unicode (stated in records/WS-027/package/assurance/V1/NOTES.md:42)
   - `records/WS-027/package/assurance/V1/FAILED-COMMANDS.json`: failed. 1 author command(s) failed in this session; the record keeps each command with its output (first: exit 1, "{")
   - `records/WS-027/package/assurance/V2/evidence/edit-attempt-01.txt`: failed. apply_patch verification failed at the RECOVERY long USB paragraph and neither file was applied (a copy sits in v2\checkpoints) (stated in records/WS-027/package/assurance/V2/evidence/edit-attempt-01.txt:1)
   - `records/WS-027/package/assurance/V2/FAILED-COMMANDS.json`: failed. 2 author command(s) failed in this session; the record keeps each command with its output (first: exit 1, "Run-Check.ps1: Cannot process argument transformation on parameter 'TimeoutSeconds'. Cannot convert value 'all...")
   - `records/WS-027/package/assurance/V3/FAILED-COMMANDS.json`: failed. 1 author command(s) failed in this session; the record keeps each command with its output (first: exit 1, "{")
   - `records/WS-027/package/entry/20261029T164326Z/cli-help-compatibility-failure.json`: failed. CreateProcessAsUserW failed:2 for "windows --help": the web documentation's platform form differs from the installed CLI (stated in records/WS-027/package/entry/20261029T164326Z/cli-help-compatibility-failure.json:5)
   - `records/WS-027/package/helper-history/FREEZE-ATTEMPT1-FAILURE.json`: failed. the Git output option was split into an empty --output= and a separate path (the failed helper is kept beside it) (stated in records/WS-027/package/helper-history/FREEZE-ATTEMPT1-FAILURE.json:5)
   - `records/WS-027/package/runtime/scheduler-fixture-attempt1-controller-bug`: failed. INCOMPLETE: the synthetic checkout was not the exact admitted candidate (stated in records/WS-027/package/runtime/scheduler-fixture-attempt1-controller-bug/result.json:6)
   - `records/WS-027/package/runtime/scheduler-fixture-attempt2-controller-bug`: failed. INCOMPLETE: "Cannot index into a null array." (stated in records/WS-027/package/runtime/scheduler-fixture-attempt2-controller-bug/result.json:6)
   - `records/WS-027/package/runtime/original/production-task-attempt1-launcher-quoting.stderr.log`: failed. Run-ProductionTask.ps1: a positional parameter cannot be found that accepts argument 'representative' (stated in records/WS-027/package/runtime/original/production-task-attempt1-launcher-quoting.stderr.log:1)
   - `records/WS-027/package/runtime/original/production-task-attempt2-readback-property-bug`: failed. INCOMPLETE: TASK_READBACK_DIFFERS (stated in records/WS-027/package/runtime/original/production-task-attempt2-readback-property-bug/result.json:7)
   - `records/WS-027/package/runtime/original/real-backup-attempt1-launcher-bug.stderr.log`: failed. The argument 'C:\Users\My' is not recognized as the name of a script file (stated in records/WS-027/package/runtime/original/real-backup-attempt1-launcher-bug.stderr.log:1)
   - `records/WS-027/package/runtime/original/literal-plan.attempt2-baseline-refused.txt`: refused. lib/apply-draft-steps.ps1:50 threw DRAFT_BLOB_MISMATCH (stated in records/WS-027/package/runtime/original/literal-plan.attempt2-baseline-refused.txt:3)
   - `records/WS-027/package/gate/GATE1-WS027-ORIGINAL-DELEGATED.attempt1-preflight-refused.md`: refused. UNPROVEN: no record states the reason
   - `records/WS-027/package/gate/GATE1-WS027-ORIGINAL-DELEGATED.attempt2-preflight-refused.md`: refused. UNPROVEN: no record states the reason

   ## Cited files (18, from records/WS-033/cited.tsv)

   | File | SHA256 |
   | --- | --- |
   | records/WS-027/package/accepted/Test-WorkbenchChange.ps1 | 835E14DACE362A9ACF25E2ED5314F0E3CB8962DE8569A14FB46AC351A589848F |
   | records/WS-027/package/assurance/V1/DRAFT.md | 126186D328CC0DDD217377213BB435CB362516D0E739AD003E682B7449FF9485 |
   | records/WS-027/package/assurance/V1/evidence/DRAFT.md | 126186D328CC0DDD217377213BB435CB362516D0E739AD003E682B7449FF9485 |
   | records/WS-027/package/assurance/V2/DRAFT.md | 618661A55F86B2BB9C91B8E3CAD1B35745F74FF88C5E83AE61C3396BF287F43E |
   | records/WS-027/package/assurance/V2/evidence/DRAFT.md | 618661A55F86B2BB9C91B8E3CAD1B35745F74FF88C5E83AE61C3396BF287F43E |
   | records/WS-027/package/assurance/V3/DRAFT.md | 40C0E73C1851A4E47BF06558C7A2ED61E23501D06089A972C257F8B391FB619A |
   | records/WS-027/package/assurance/V3/evidence/DRAFT.md | 40C0E73C1851A4E47BF06558C7A2ED61E23501D06089A972C257F8B391FB619A |
   | records/WS-027/package/gate/GATE1-WS027-ORIGINAL-DELEGATED.attempt1-preflight-refused.md | 1C2E3D654FC044D3BE09B0A4DF4583F9542A63A60948CBCA3BD4675B192A8891 |
   | records/WS-027/package/gate/GATE1-WS027-ORIGINAL-DELEGATED.attempt2-preflight-refused.md | 1C2E3D654FC044D3BE09B0A4DF4583F9542A63A60948CBCA3BD4675B192A8891 |
   | records/WS-027/package/gate/GATE1-WS027-ORIGINAL-DELEGATED.md | 1C2E3D654FC044D3BE09B0A4DF4583F9542A63A60948CBCA3BD4675B192A8891 |
   | records/WS-027/package/LAUNCHER-CORRECTION-PROPOSAL.md | BE65CD50A5F88F4898D17653F282BE64ADEF64C3AD373DA2BA5D62A94D1D5C18 |
   | records/WS-027/package/research-catalog-20261030/VERDICT.md | 36300A3142DF79D95ADDC9BCA9A75FC94BF026B83C0EFBFA85713D6BDB9A3CDE |
   | records/WS-027/package/runtime/original/production-task-attempt2-readback-property-bug/ws013-hosted-acceptance.saved.json | 3043798C16B1F344BED72CF8A188253E780B6BFEF4E00621759026E98B8D01D2 |
   | records/WS-027/package/runtime/original/production-task/ws013-hosted-acceptance.saved.json | 3043798C16B1F344BED72CF8A188253E780B6BFEF4E00621759026E98B8D01D2 |
   | records/WS-027/package/runtime/sandbox/own-finish-receipt.json | C69708556DD71517370406CB5E3FE289C92215676CC61C26ABB03C769DFE7911 |
   | records/WS-027/package/source-pack-sol-high/VERDICT.json | 05CFB02CC8739C1B2C237C3D6349465FCC20483C181F7D89358A886110844E77 |
   | records/WS-027/package/v2/checkpoints/pass-20261030T191245Z/evidence/DRAFT.md | 618661A55F86B2BB9C91B8E3CAD1B35745F74FF88C5E83AE61C3396BF287F43E |
   | records/WS-027/package/v2/PINNED-DEPLOYMENT-METADATA.json | 7EA2954AF04C51FBFE751C05EA0FA7FB88234613469E22E4F6548271BAF79028 |
   ```

   The resulting file's Git blob is 3e8b5cdbeff5576544584fbd1d2742b58038d519.

31. Check whether `records/WS-028/README.md` contains `Purpose: Summary of WS-028 record integrity. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is bbe095b313b30b1757d9d2b639758b8f8cf680b8, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # WS-028

   Purpose: Summary of WS-028 record integrity. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:40Z | new | - | records/WS-028 | T10 organizer |
   <!-- /organize:changes -->

   # WS-028 record integrity

   Summary of a finished workstream (DEC-11), written in WS-033 step P1.3b by records/WS-033/summaries.ps1 from the
   change file, the receipt, the attempt records (records/WS-033/attempts.tsv) and records/WS-033/cited.tsv; it changes
   no evidence.
   Evidence: records/WS-028/.

   ## Result

   - Change file: ORVION-Workbench/changes/WS-028-record-integrity.md, SHA256 2DCC0B7010C6A74FA2458BC6461E470CAF0F0E905B4EE0060C58507D1D1BF04C
   - Status: Complete
   - Verdict: Confirmed Complete
   - Reviewed Fingerprint: 0A1D30863A232E5A85F054361515FC1E17680BD5DCB3B64BECCFDDD8F82EF78A
   - Reviewed Receipt: FE3C92ADBE84953146DC65BEB4702081A74653391E36264E6E442E4168D0CEE4

   ## Receipt

   The original own Finish receipt, `records/WS-028/package/runtime/original/own-finish-receipt.json`, SHA256 F0EE84E53D6850EC746D5966305EAE04F6CA43A678D3EFB8D1334779DB1A6A48; its digest equals the Reviewed Receipt above:

   ~~~json
   {
     "schema": 2,
     "root": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench",
     "contract": "changes/WS-028-record-integrity.md",
     "finishHead": "ea9dd2b0fbc7c8c4b545013638416dff4d790266",
     "fingerprint": "0A1D30863A232E5A85F054361515FC1E17680BD5DCB3B64BECCFDDD8F82EF78A",
     "profiles": [
       "CONTROL",
       "REPOSITORY"
     ],
     "evaluator": "0359914cae98f493a59d202649cd2fe2ee29fcf3",
     "runLog": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Owner-Tools\\records\\WS-028\\package\\runtime\\original\\finish.log",
     "runStart": "[2026-10-31 14:30:13] START pid=3940 host=[masked] pwsh=7.6.8 cpus=8 head=ea9dd2b concurrent=[masked],[masked],[masked],[masked],[masked],[masked],Sync-Sessions.ps1,[masked],Run-OriginalFinish.ps1,Watch-Host.ps1 | & pwsh -NoProfile -File 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\lib\\Workbench.ps1' -Root 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench' -Finish -Actionlint 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\tools\\actionlint.exe'",
     "result": "READY",
     "draftSHA256": "2D08F84610A630E657A3AB88E6CE229BAA593E53683B97FE20BE6AA4205D5C31",
     "recipe": "010A801DD1464B26021012338D830B9A4E853AE61A5EB8168B6274E581295EBB",
     "role": "ORIGINAL",
     "proof": "C4F5286717FDA524F2BFF6CF723C3C9806C97C76A9A3FD9F1C609E7BDEAF05B5",
     "digest": "FE3C92ADBE84953146DC65BEB4702081A74653391E36264E6E442E4168D0CEE4"
   }
   ~~~

   ## Failed, refused, superseded and stopped attempts (15)

   - `records/WS-028/package/assurance/V1/draft-check.attempt1-checker-regex.json`: failed. UNPROVEN: no record states the reason
   - `records/WS-028/package/assurance/V3`: superseded. the V3 review returned REVISE (1 material, 6 minor findings) (stated in records/WS-028/package/v3-review/RESULT.json:4)
   - `records/WS-028/package/assurance/V3/evidence/record-probe-v3-attempt1.txt`: superseded. UNPROVEN: no record states the reason
   - `records/WS-028/package/assurance/V3/evidence/mutants-attempt2-gapcheck.txt`: failed. mutant C1-protection-unprotected-copy-accepted survived (stated in records/WS-028/package/assurance/V3/evidence/mutants-attempt2-gapcheck.txt:3)
   - `records/WS-028/package/assurance/V4`: superseded. the V4 review returned REVISE (1 material, 7 minor findings) (stated in records/WS-028/package/v4-review/RESULT.json:4)
   - `records/WS-028/package/assurance/V4/evidence/record-probe-v4-attempt1.txt`: superseded. the R1 test was split into 4 lines so each guard signal is load-bearing, then the probe was run again (stated in records/WS-028/package/assurance/V4/REPORT.md:108)
   - `records/WS-028/package/assurance/V5`: superseded. the V5 review returned REVISE (1 material, 1 minor finding) (stated in records/WS-028/package/v5-review/RESULT.json:4)
   - `records/WS-028/package/v5-review/BRIEF.stopped-xhigh.md`: stopped. the earlier xhigh review attempt was stopped unfinished and does not count (stated in records/WS-028/package/v5-review/RESULT.json:7)
   - `records/WS-028/package/assurance/V5/evidence/mutants-attempt1-weak-break-assertion.txt`: failed. mutant C1-V5-break-without-decision-accepted survived (stated in records/WS-028/package/assurance/V5/evidence/mutants-attempt1-weak-break-assertion.txt:81)
   - `records/WS-028/package/assurance/V5/evidence/test-hunt-v5-attempt1-before-break-fix.txt`: superseded. the complete test-hunt run was repeated after the break-fixture isolation; attempt 1 (exit 0, 69 PASS) is kept (stated in records/WS-028/package/assurance/V5/REPORT.md:31)
   - `records/WS-028/package/assurance/V6`: superseded. the V6 review returned REVISE (1 material finding) (stated in records/WS-028/package/v6-review/RESULT.json:4)
   - `records/WS-028/package/runtime/sandbox/approve-attempt1-readonly-refused.json`: refused. WriteAllText access denied: the allocated contract inherited ReadOnly from frozen V7 via File.Copy (stated in records/WS-028/package/runtime/sandbox/approve-attempt1-readonly-refused.json:4)
   - `records/WS-028/package/runtime/sandbox/review-attempt1-criteria-open.json`: refused. native WB_COMPLETION_CRITERIA_OPEN: the WS-028 adaptation omitted the WS-027 checkbox step, and Verification Notes mislabelled the D85 self-review as independent (stated in records/WS-028/package/runtime/sandbox/review-attempt1-criteria-open.json:6)
   - `records/WS-028/package/runtime/sandbox/review-fix-attempt2-history-rewrite-refused.diff`: refused. UNPROVEN: no record states the reason
   - `records/WS-028/package/release/hosted-failure.json`: failed. The test builds its install-refusal fixture under WORKBENCH_TEST_ROOT. Backup-Workspace.ps1 lines 96-97 treat an input as disposable only when its path contains a folder named ORVION-Workbench-temporary or lies inside -TemporaryRoot (fixture\managed). Locally the fixture is under C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\scratch\W27-v3\tests\focus-204ca89f, so the install is refused (PASS). On the runner it is under D:\a\_temp\workbench-ci-41215560787-1\t\focus-e7b251b9, so it is not refused, the mocked registration runs (log line BACKUP TASK) and the assertion fails. (stated in records/WS-028/package/release/hosted-failure.json:18)

   ## Cited files (11, from records/WS-033/cited.tsv)

   | File | SHA256 |
   | --- | --- |
   | records/WS-028/package/accepted/Test-WorkbenchChange.ps1 | 835E14DACE362A9ACF25E2ED5314F0E3CB8962DE8569A14FB46AC351A589848F |
   | records/WS-028/package/assurance/V1/DRAFT.md | 2BE7A63B0910D497764149131669B7B00FF737563A87909E42DCD45322B5FAAF |
   | records/WS-028/package/assurance/V2/DRAFT.md | BEA20AC53C314D9698C8EA119022EECA86046E3CDAB37993D0BAD7A6C800C716 |
   | records/WS-028/package/assurance/V3/DRAFT.md | 03D7B5B9CCA0E600FF4D6C9CB8701CE3430B200CC543E686E84788278CE34B72 |
   | records/WS-028/package/assurance/V4/DRAFT.md | 95A4F99ED04D27A09E155BD85064526E4ED65DD10D113A588D36AE8A9DF378AD |
   | records/WS-028/package/assurance/V5/DRAFT.md | 2DFA03DC45D8CB029E435D65FB15CD15919755DEBFE33D53CC31947C34C4EF07 |
   | records/WS-028/package/assurance/V6/DRAFT.md | 63FEDE31739C1B55E78551E265E15111C68ECF8FAFF19B025708BF7FD01AC779 |
   | records/WS-028/package/assurance/V7/DRAFT.md | 2D08F84610A630E657A3AB88E6CE229BAA593E53683B97FE20BE6AA4205D5C31 |
   | records/WS-028/package/gate/GATE1-WS028-ORIGINAL-DELEGATED.md | 969225270CF5B80C467CCC63998DD15D673F8A02B70E3E9D62CB50346C560BB4 |
   | records/WS-028/package/runtime/sandbox/own-finish-receipt.json | 92CC6A6B5C04C9F0D4EB3A5110017DD3670C9FE304D60737C656DFB2FFF81AA3 |
   | records/WS-028/package/Save-Checkpoint.ps1 | 566633DE9ABAEFA7B54ADBA3121FFEE54105099C797D1126DE9C09C61DF4AE0B |
   ```

   The resulting file's Git blob is bbe095b313b30b1757d9d2b639758b8f8cf680b8.

32. Check whether `records/WS-029/README.md` contains `Purpose: Summary of WS-029 restore long path cleanup. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is 3fbf070ff89e88d50e57c22b8448ede9825ef38c, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # WS-029

   Purpose: Summary of WS-029 restore long path cleanup. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:41Z | new | - | records/WS-029 | T10 organizer |
   <!-- /organize:changes -->

   # WS-029 restore long path cleanup

   Summary of a finished workstream (DEC-11), written in WS-033 step P1.3b by records/WS-033/summaries.ps1 from the
   change file, the receipt, the attempt records (records/WS-033/attempts.tsv) and records/WS-033/cited.tsv; it changes
   no evidence.
   Evidence: records/WS-029/.

   ## Result

   - Change file: ORVION-Workbench/changes/WS-029-restore-long-path-cleanup.md, SHA256 A386EC208BAF6120FC99EE34668F937C8007FE45371DFF2B86C5348CE0D7AE4A
   - Status: Cancelled
   - Execution Log: "Superseded by a separately admitted diagnostic and recovery-certification successor. Exact recovery outputs, frozen assurance and all attempt evidence are retained; cancellation is not completion."

   ## Receipt

   The sandbox own Finish receipt (no original receipt exists: the workstream was cancelled), `records/WS-029/package/runtime/sandbox-r3/own-finish-receipt.json`, SHA256 239EC336A66752A76F003A92B19A476CA642AF1B66048D486EB9E4673F97CE0E; its SHA256 equals the Sandbox Receipt SHA256 of the change file:

   ~~~json
   {
     "schema": 2,
     "root": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\sb\\W29\\rehearsal-r2",
     "contract": "changes/WS-029-restore-long-path-cleanup.md",
     "finishHead": "f90b45fb6192088d0edc91c79d923057da1f1649",
     "fingerprint": "424B0D2A1758C1C3342650D61FB6BA8D08726FA700D89EC2081D2AA8418D9F4D",
     "profiles": [
       "CONTROL",
       "RECOVERY",
       "REPOSITORY"
     ],
     "evaluator": "0359914cae98f493a59d202649cd2fe2ee29fcf3",
     "runLog": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Owner-Tools\\records\\WS-029\\package\\runtime\\sandbox-r3\\finish.log",
     "runStart": "[2026-10-28 10:52:02] START pid=17960 host=[masked] pwsh=7.6.8 cpus=8 head=f90b45f concurrent=Sync-Sessions.ps1,Run-SandboxFinish-R3.ps1,Run-SandboxFinish-R3.ps1,Watch-Host.ps1 | & pwsh -NoProfile -File 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\sb\\W29\\rehearsal-r2\\lib\\Workbench.ps1' -Root 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\sb\\W29\\rehearsal-r2' -Finish -Actionlint 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\tools\\actionlint.exe'",
     "result": "READY",
     "draftSHA256": "87C5B9DB0A4D2B59F468A6BCCB24AF1ACFEE0005154982C2465E39BB5F33880D",
     "recipe": "40D36F6552A8B9B19C74DC9CBBBD8152F1AF89845B80B58D87E772BDBEF48927",
     "role": "SANDBOX",
     "proof": null,
     "digest": "5B73F00CFBAB24ACACE77DAB21C9C8FE8B2C73BDBC36016C3AC600FA9CC240D5"
   }
   ~~~

   ## Failed, refused, superseded and stopped attempts (11)

   - `records/WS-029/package/stopped-sol-high-ab`: stopped. stopped by the owner's direction approving Candidate C, before a completed V3 (stated in records/WS-029/package/stopped-sol-high-ab/STATUS.md:1)
   - `records/WS-029/package/v3/initial-test-restore-orvion.log`: failed. real OneDrive cloud reparse metadata without a Target made unrelated protection checks fail, and fixture cleanup selected two pwsh executables (stated in ORVION-Workbench/changes/WS-029-restore-long-path-cleanup.md:540)
   - `records/WS-029/package/v3/second-test-restore-orvion.log`: failed. the native whole owning suite reached default staging paths longer than the PowerShell 5.1 directory provider supports beneath the long inherited TEMP (stated in ORVION-Workbench/changes/WS-029-restore-long-path-cleanup.md:541)
   - `records/WS-029/package/v2-codex-xhigh/preliminary-test-backup-restore.log`: failed. unwrapped Git bundle lock creation hit MAX_PATH in Delegate scratch (stated in ORVION-Workbench/changes/WS-029-restore-long-path-cleanup.md:542)
   - `records/WS-029/package/v3/final2-test-backup-restore.log`: failed. final-test-backup-restore.log and final2-test-backup-restore.log: abandoned fixture child-invocation adapters failed before complete package coverage (stated in ORVION-Workbench/changes/WS-029-restore-long-path-cleanup.md:542)
   - `records/WS-029/package/evidence/all/native-owning-restore.log`: failed. the supplemental whole-driver run under powershell.exe exited 1 at lib/test-restore-orvion.ps1:301: ErrorActionPreference=Stop treated Git's "Cloning into" stderr as NativeCommandError (stated in ORVION-Workbench/changes/WS-029-restore-long-path-cleanup.md:517)
   - `records/WS-029/package/runtime/sandbox`: superseded. the sandbox Finish passed (exits 0) but the owner's "resume" was read as "one fresh properly baselined closure; no waiver or retroactive proof" (stated in records/WS-029/package/r2-preparation.json:4)
   - `records/WS-029/package/runtime/original`: failed. the original Finish failed: "a check wrote into the real journal events\events.jsonl", CODE: WB_REQUIRED_TESTS_FAILED:exit=1 (stated in records/WS-029/package/runtime/original/finish.log:37)
   - `records/WS-029/package/r2-runtime-binding.json`: refused. the first R2 Execute was BLOCKED VERSION MISMATCH before output writes (frozen PowerShell 7.6.8, host 7.6.9) (stated in records/WS-029/package/r2-runtime-binding.json:11)
   - `records/WS-029/package/runtime/sandbox-r2`: failed. test-workbench-governance.ps1 failed: nested fixture Finish admissions refused WB_CONTEXT_RESOURCE_BUDGET_UNAVAILABLE (stated in records/WS-029/package/runtime/sandbox-r2/failure-summary.json:7)
   - `records/WS-029/package/runtime/original-r2`: failed. the only failing suite was test-watch-reminder.ps1; no record states its cause (WS-030's change file calls it unknown) (stated in records/WS-029/package/runtime/original-r2/failure-summary.json:5)

   ## Cited files (12, from records/WS-033/cited.tsv)

   | File | SHA256 |
   | --- | --- |
   | records/WS-029/package/accepted/Test-WorkbenchChange.ps1 | 835E14DACE362A9ACF25E2ED5314F0E3CB8962DE8569A14FB46AC351A589848F |
   | records/WS-029/package/assurance/V1/DRAFT.md | 8282B71EA6A1EBB559743278A29B2197D110500C3FCE89BD45A0D4E18CE68D8A |
   | records/WS-029/package/assurance/V2/DRAFT.md | DDDF89FA29C56C40658E15398DB7E4BE00BC11647BC01DE798878D424348A50F |
   | records/WS-029/package/assurance/V3/DRAFT.md | 87C5B9DB0A4D2B59F468A6BCCB24AF1ACFEE0005154982C2465E39BB5F33880D |
   | records/WS-029/package/RESOURCE-RESOLUTION-20261028.md | 17E8DA5AA01B0F523FF42250D0489E228AAFFD0E65205FAAEB8CDE4E85271F5A |
   | records/WS-029/package/runtime/original-r2/failure-summary.json | 0CAD22C800F1C83FFAF3E9B2DF72767A0E57949A57185D525F897C7E20F4F350 |
   | records/WS-029/package/runtime/sandbox-r3/own-finish-receipt.json | 239EC336A66752A76F003A92B19A476CA642AF1B66048D486EB9E4673F97CE0E |
   | records/WS-029/package/runtime/sandbox-r3/result.json | 9BC23BE178B96F79380542D0AD7EE9BB4E8F64C9A404775E0ACB2FC7CB781048 |
   | records/WS-029/package/runtime/sandbox/review-blocker.json | 4997A0FCC62277679EC34ED60E5F6DEE3541C0EAB2524D1DFF0A8CB3085FBE4E |
   | records/WS-029/package/runtime/watch-reminder-diagnosis/VERDICT.md | B0FB486F66F0AD04B807BE1F5BC6A96989B276A3BC51C866A2DF1B68D697708F |
   | records/WS-029/package/SELECTION.md | 368E02F40726FD96DE95996F1C28ED01BBB62090895A9F34C159D966AC2A8FEA |
   | records/WS-029/package/v2-codex-xhigh/V2-DRAFT.md | DDDF89FA29C56C40658E15398DB7E4BE00BC11647BC01DE798878D424348A50F |
   ```

   The resulting file's Git blob is 3fbf070ff89e88d50e57c22b8448ede9825ef38c.

33. Check whether `records/WS-030/README.md` contains `Purpose: Summary of WS-030 recovery diagnostics successor. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is 41ad3dbe7e32f5243bea2b723bd6986dd683e618, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # WS-030

   Purpose: Summary of WS-030 recovery diagnostics successor. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:41Z | new | - | records/WS-030 | T10 organizer |
   <!-- /organize:changes -->

   # WS-030 recovery diagnostics successor

   Summary of a finished workstream (DEC-11), written in WS-033 step P1.3b by records/WS-033/summaries.ps1 from the
   change file, the receipt, the attempt records (records/WS-033/attempts.tsv) and records/WS-033/cited.tsv; it changes
   no evidence.
   Evidence: records/WS-029/package/successor/.

   ## Result

   - Change file: ORVION-Workbench/changes/WS-030-recovery-diagnostics-successor.md, SHA256 A6D7FDF365A92EB76E3BD6666C8777E2D3B08A18C6C077C382E264D2B9A21CE7
   - Status: Complete
   - Verdict: Confirmed Complete
   - Reviewed Fingerprint: 1C439DD99A636A174F37A909E7B76F65700CC2B40D5BB044BBD237A105DDBE56
   - Reviewed Receipt: 471C278EBB07A725045C087A3AE0F9DBDF8DF9D7C3DF109EB02BAF7E6E3B85CD

   ## Receipt

   The original own Finish receipt, `records/WS-029/package/successor/runtime/original/own-finish-receipt.json`, SHA256 9FFFBF20CC99DCD66A3D51CCFD43D08F9E314EC307910F9984F6B6CBBF7595A2; its digest equals the Reviewed Receipt above:

   ~~~json
   {
     "schema": 2,
     "root": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench",
     "contract": "changes/WS-030-recovery-diagnostics-successor.md",
     "finishHead": "268ecfc7e4c1ae933f8b1a067cae67d9bc54e5e2",
     "fingerprint": "1C439DD99A636A174F37A909E7B76F65700CC2B40D5BB044BBD237A105DDBE56",
     "profiles": [
       "CONTROL",
       "RECOVERY",
       "REPOSITORY"
     ],
     "evaluator": "0359914cae98f493a59d202649cd2fe2ee29fcf3",
     "runLog": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Owner-Tools\\records\\WS-029\\package\\successor\\runtime\\original\\finish.log",
     "runStart": "[2026-10-28 16:28:49] START pid=7560 host=[masked] pwsh=7.6.8 cpus=8 head=268ecfc concurrent=Sync-Sessions.ps1,[masked],[masked],[masked],[masked],[masked],[masked],[masked],Test-WorkbenchChange.ps1,Run-OriginalFinish.ps1,Watch-Host.ps1 | & pwsh -NoProfile -File 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\lib\\Workbench.ps1' -Root 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench' -Finish -Actionlint 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\tools\\actionlint.exe'",
     "result": "READY",
     "draftSHA256": "7DFD342DA15F7A6A2262FE8344C4B9AB5C0D4FCCC47DA6AE315E8C3E0EA26E4F",
     "recipe": "85AEFDB62133D991009101B76B633C213D3988AD64EBB72EFBBF0D78F79C3997",
     "role": "ORIGINAL",
     "proof": "F6B3EE66F8A4EFF9832F7AC4C503F91FDEAB20C191663ED43A5B734F3EB460AA",
     "digest": "471C278EBB07A725045C087A3AE0F9DBDF8DF9D7C3DF109EB02BAF7E6E3B85CD"
   }
   ~~~

   ## Failed, refused, superseded and stopped attempts (1)

   - `records/WS-029/package/successor/step3/attempt-20261028T174627Z`: failed. the first Step 3 launcher run reported RECOVERY_FAILED: the pre-extraction archive lookup failed because the term Get-FileHash was not recognized (stated in records/WS-029/package/successor/step3/attempt-20261028T174627Z/pre-extraction-diagnosis.stdout.log:12)

   ## Cited files (7, from records/WS-033/cited.tsv)

   | File | SHA256 |
   | --- | --- |
   | records/WS-029/package/successor/assurance-qualified/V1/DRAFT.md | 87EE1D53263D6D75333EB9A6D83ECAB4F0B62C4D7D284C6E027493E9DEEDA473 |
   | records/WS-029/package/successor/assurance-qualified/V2/DRAFT.md | B3D6D4D58FDA5BF72C7F362BF9A6A7FA48ACEFFADD2423C747700EDF676B3FD3 |
   | records/WS-029/package/successor/assurance-qualified/V3/DRAFT.md | 7DFD342DA15F7A6A2262FE8344C4B9AB5C0D4FCCC47DA6AE315E8C3E0EA26E4F |
   | records/WS-029/package/successor/GATE1-WS030-DELEGATED.md | 1F7BF33C45AD6E0BBC1462747F63596B3C97A82327797B14BDE711362B9840FD |
   | records/WS-029/package/successor/release/RELEASE-RECEIPT.json | E14F4AAAEA87551FAB15FBBE974DA156550A3A7C5F708EE1A71C8C2CB8BDDC75 |
   | records/WS-029/package/successor/runtime/sandbox/own-finish-receipt.json | E50466B0938959CF75E8248BA4471DC3E2C0BA4C8B9B856AF1A05F8E3A73E869 |
   | records/WS-029/package/successor/step3/attempt-20261028T180229Z-r2/result.json | BA968C583B9CC63FFE46DD77FB3972EC526DA5E06BD5FD0673A8468670DCBD9C |
   ```

   The resulting file's Git blob is 41ad3dbe7e32f5243bea2b723bd6986dd683e618.

34. Check whether `records/WS-031/README.md` contains `Purpose: Summary of WS-031 native feature preflight. Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is ea8aa09e4aed04328d0dc1f6ef7e7de9db9809d9, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # WS-031

   Purpose: Summary of WS-031 native feature preflight. Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:42Z | new | - | records/WS-031 | T10 organizer |
   <!-- /organize:changes -->

   # WS-031 native feature preflight

   Summary of a finished workstream (DEC-11), written in WS-033 step P1.3b by records/WS-033/summaries.ps1 from the
   change file, the receipt, the attempt records (records/WS-033/attempts.tsv) and records/WS-033/cited.tsv; it changes
   no evidence.
   Evidence: records/WS-031/.

   ## Result

   - Change file: ORVION-Workbench/changes/WS-031-native-feature-preflight.md, SHA256 7380CD1702E14ACC0FE70AF387E1A32B9FC29EB83D7707F7CAA9F2139AD72434
   - Status: Complete
   - Verdict: Confirmed Complete
   - Reviewed Fingerprint: 3454E3B57341FB70797625D19C3625ECAE75D0220218E9964C5204F4AB224DF3
   - Reviewed Receipt: 477AAA5AAD05E135A42ADFB0167F4251186E8B3253A39D9A472501271E423C24

   ## Receipt

   The original own Finish receipt, `records/WS-031/package/runtime/original/own-finish-receipt.json`, SHA256 3170B7B055A8FEAE7390753EF82DF8CC9F709F8AF919320684F1DB1A701B0E5D; its digest equals the Reviewed Receipt above:

   ~~~json
   {
     "schema": 2,
     "root": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench",
     "contract": "changes/WS-031-native-feature-preflight.md",
     "finishHead": "4e6b27465029dff079f6a6f4a3d49fb122d96ede",
     "fingerprint": "3454E3B57341FB70797625D19C3625ECAE75D0220218E9964C5204F4AB224DF3",
     "profiles": [
       "CONTROL",
       "REPOSITORY"
     ],
     "evaluator": "0359914cae98f493a59d202649cd2fe2ee29fcf3",
     "runLog": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Owner-Tools\\records\\WS-031\\package\\runtime\\original\\finish.log",
     "runStart": "[2026-10-30 00:46:39] START pid=20924 host=[masked] pwsh=7.6.8 cpus=8 head=4e6b274 concurrent=[masked],[masked],[masked],[masked],[masked],[masked],Sync-Sessions.ps1,[masked],Run-OriginalFinish.ps1,Run-OriginalFinish.ps1,Watch-Host.ps1 | & pwsh -NoProfile -File 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench\\lib\\Workbench.ps1' -Root 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench' -Finish -Actionlint 'C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Workbench-temporary\\tools\\actionlint.exe'",
     "result": "READY",
     "draftSHA256": "656A92C8A81779EFAC91B9D1CA766EABD18B7D1083D97B52E4C9255FBC370F77",
     "recipe": "7F804FAC71116A2943D4A561E57E7AA14852DDAF4E79AB51F8EDE58AFC984EF2",
     "role": "ORIGINAL",
     "proof": "7DF0195FCB14D64F524C796448E77352E885792DEB32B7364D193EBA371BDFC5",
     "digest": "477AAA5AAD05E135A42ADFB0167F4251186E8B3253A39D9A472501271E423C24"
   }
   ~~~

   ## Failed, refused, superseded and stopped attempts (9)

   - `records/WS-031/package/bootstrap-preparation-first-failure.json`: failed. the bootstrap patch anchor was missing or ambiguous: PowerShell comma/addition precedence in nested string pairs (stated in records/WS-031/package/bootstrap-preparation-first-failure.json:5)
   - `records/WS-031/package/helper-preparation-failures.json`: failed. a double-quoted PowerShell anchor expanded $notes, and the absent anchor led to a negative IndexOf startIndex (stated in records/WS-031/package/helper-preparation-failures.json:5)
   - `records/WS-031/package/transport-setup-first-failure.json`: failed. Cannot overwrite variable HOME because it is read-only or constant (stated in records/WS-031/package/transport-setup-first-failure.json:4)
   - `records/WS-031/package/prototype/AUTHOR-FAILED-DIAGNOSTICS.json`: failed. 2 author command(s) failed in this session; the record keeps each command with its output (first: exit 1, "work/WS031\PROTOTYPE-BRIEF.md")
   - `records/WS-031/package/prototype-verification/orchestration-first-failure.json`: failed. Get-Command git returned two paths, which were joined into one executable string (whitespace launch only, not executed) (stated in records/WS-031/package/prototype-verification/orchestration-first-failure.json:5)
   - `records/WS-031/package/assurance/V1/AUTHOR-FAILED-DIAGNOSTICS.json`: failed. 2 author command(s) failed in this session; the record keeps each command with its output (first: exit 1, "diff --git a/lib/README.md b/lib/README.md")
   - `records/WS-031/package/assurance/V2/AUTHOR-FAILED-DIAGNOSTICS.json`: failed. 3 author command(s) failed in this session; the record keeps each command with its output (first: exit 1, "rg: evidence: The system cannot find the file specified. (os error 2)")
   - `records/WS-031/package/assurance/V3/AUTHOR-FAILED-DIAGNOSTICS.json`: failed. 1 author command(s) failed in this session; the record keeps each command with its output (first: exit 1, "FullName")
   - `records/WS-031/package/v3/FAILED-ATTEMPT-VERDICT.json`: failed. FAILED_PROVIDER_USAGE_LIMIT_NO_V3_ARTIFACT: a provider usage limit; the error and turn.failed are kept in the raw native events (stated in records/WS-031/package/v3/FAILED-ATTEMPT-VERDICT.json:3)

   ## Cited files (12, from records/WS-033/cited.tsv)

   | File | SHA256 |
   | --- | --- |
   | records/WS-031/package/accepted/Test-WorkbenchChange.ps1 | 835E14DACE362A9ACF25E2ED5314F0E3CB8962DE8569A14FB46AC351A589848F |
   | records/WS-031/package/assurance/V1/DRAFT.md | A3D4AE2F0BD1F4F4B61CDB0DC0611F832A8AD0581C399B83B7479937F7B01581 |
   | records/WS-031/package/assurance/V1/source/lib/codex-relay.mjs | 25BDEA812BD42802E5B27A57CF7815291B9CC0C408E0A8243B65F2478226E5EE |
   | records/WS-031/package/assurance/V2/DRAFT.md | EA50CAC55FD13713342D204475B0DD93391F58C8FD9E7B91A3B44154052CC1D5 |
   | records/WS-031/package/assurance/V2/source/lib/codex-relay.mjs | 25BDEA812BD42802E5B27A57CF7815291B9CC0C408E0A8243B65F2478226E5EE |
   | records/WS-031/package/assurance/V3/DRAFT.md | 656A92C8A81779EFAC91B9D1CA766EABD18B7D1083D97B52E4C9255FBC370F77 |
   | records/WS-031/package/assurance/V3/source/lib/codex-relay.mjs | 25BDEA812BD42802E5B27A57CF7815291B9CC0C408E0A8243B65F2478226E5EE |
   | records/WS-031/package/GATE1-WS031-ORIGINAL-DELEGATED.md | 28E40260B221C4C1F5EB6B7FC6360AFE1C3BCB7348F00D1EF27F0F00B95EC96B |
   | records/WS-031/package/prototype/source/lib/codex-relay.mjs | 25BDEA812BD42802E5B27A57CF7815291B9CC0C408E0A8243B65F2478226E5EE |
   | records/WS-031/package/runtime/sandbox/own-finish-receipt.json | C95FF88794B58BDB09134156D838C1C29C72E00EC384E18A91E4B4D893BC99B7 |
   | records/WS-031/package/v2-controls/mutation-harness.mjs | C4A76F147E65767B4F17FA52EA533D131FB44C957AC7C494686FA9F30A0C652B |
   | records/WS-031/package/v2-controls/mutation-run-X5qZFc/results.json | 19F3284FD150B0D57C8BAFA581D3431BAD0010B98BD103CB470815466A038D5A |
   ```

   The resulting file's Git blob is ea8aa09e4aed04328d0dc1f6ef7e7de9db9809d9.

35. Check whether `records/WS-032/README.md` contains `Purpose: Summary of WS-032 deferred proposal (no change file). Kind: records. Lifetime: permanent.`; if so record Already Applied when its Git blob is 1aeeb4405442d966e582104a6a841bdeb7a2ef55, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (land this exact frozen WS-035 candidate output), and change nothing else:

   ```text
   # WS-032

   Purpose: Summary of WS-032 deferred proposal (no change file). Kind: records. Lifetime: permanent.
   Reader: agents, the owner.
   Rules: one summary; evidence stays in data/records.

   <!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
   | Name | Kind | Purpose | Reader | Updated |
   | --- | --- | --- | --- | --- |
   <!-- /organize:contents -->

   <!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
   | UTC | Action | From | To | Reason |
   | --- | --- | --- | --- | --- |
   | 2026-11-04T17:40:43Z | new | - | records/WS-032 | T10 organizer |
   <!-- /organize:changes -->

   # WS-032 deferred proposal (no change file)

   Summary of a finished workstream (DEC-11), written in WS-033 step P1.3b by records/WS-033/summaries.ps1 from the
   change file, the receipt, the attempt records (records/WS-033/attempts.tsv) and records/WS-033/cited.tsv; it changes
   no evidence.
   Evidence: records/WS-032/.

   ## Result

   - No change file and no native contract: deferred outside the critical path by owner decision D68 (`records/WS-032/package/DEFERRED-D68.json`, SHA256 A6882A8649B18019ADBFB4BB9ABC0667928A238E2DD8BEF57A3CD23EAC4910D7):

   ~~~json
   {
     "AtUTC": "2026-10-30T15:38:15.0516511Z",
     "Decision": "D68",
     "ProgrammeDisposition": "DEFERRED_OUTSIDE_CRITICAL_PATH",
     "NativeContract": "None allocated; no native status invented",
     "Qualification": "UNQUALIFIED",
     "FailedGates": "Preserved, not waived",
     "EvidenceRoot": "WS032/package",
     "LiveResearch": "Disabled by owner direction; no research launch or global profile change",
     "OriginalIntegration": "NONE",
     "FurtherToolingResearch": "NOT_AUTHORIZED",
     "OwnerDecision": "C:\\Users\\My Lab\\Documents\\GitHub\\ORVION-Owner-Tools\\records\\WS-027\\package\\owner-deferral-20261030\\OWNER-DIRECTION.json"
   }
   ~~~

   ## Receipt

   None: no native Finish ran.

   ## Failed, refused, superseded and stopped attempts (8)

   - `records/WS-032/package/prototype/AUTHOR-FAILED-DIAGNOSTICS.json`: failed. 2 author command(s) failed in this session; the record keeps each command with its output (first: exit 1, "no output")
   - `records/WS-032/package/assurance/V1/AUTHOR-FAILED-DIAGNOSTICS.json`: failed. 2 author command(s) failed in this session; the record keeps each command with its output (first: exit 1, "96:    if(!$context){return $null}")
   - `records/WS-032/package/v1-catalog`: failed. CONTROL_GATE_FAILED_CODE_MODE_HOST_DISABLED (stated in records/WS-032/package/v1-catalog/ACTUAL-FAILED-CATALOG.json:123)
   - `records/WS-032/package/v2`: refused. BLOCK_NO_SUPPORTED_IN_SCOPE_REMEDY_ESTABLISHED: no supported per-task remedy within the four authorized source files, so no V2 Draft was made (stated in records/WS-032/package/v2/ADVERSARIAL-VERDICT.json:4)
   - `records/WS-032/package/namespace-trial/catalog`: superseded. the NS01 deterministic hazard check failed, so a distinct test-variable-only R2 was required (stated in records/WS-032/package/namespace-trial/catalog/SUPERSEDED-PREPARATION.json:5)
   - `records/WS-032/package/namespace-trial/author/deliverables/attempt-20261030T134150699Z`: failed. CODEX_CONTROLS_UNVERIFIED: JSON conversion failed (unexpected end while parsing an unquoted property name); stop and escalate (stated in records/WS-032/package/namespace-trial/author/deliverables/attempt-20261030T134150699Z/case-003-output.txt:12)
   - `records/WS-032/package/namespace-trial/author/deliverables/attempt-20261030T134508735Z`: failed. CODEX_CONTROLS_UNVERIFIED: JSON conversion failed (unexpected end while parsing an unquoted property name); stop and escalate (stated in records/WS-032/package/namespace-trial/author/deliverables/attempt-20261030T134508735Z/case-003-output.txt:12)
   - `records/WS-032/package/namespace-trial/catalog-r2`: failed. the actual catalog wrapper exited 5 (raw exit 0) on the startup notice (stated in records/WS-032/package/HANDOFF.md:22)

   ## Cited files (4, from records/WS-033/cited.tsv)

   | File | SHA256 |
   | --- | --- |
   | records/WS-032/package/feasibility-20261030/VERDICT.md | 54C9E2BD34B8398BE3122C5AC0ADC61217EEFFFB7E1A7A9646AB208BF62A1145 |
   | records/WS-032/package/namespace-trial/catalog-r2/ASSESSMENT.json | 8C50D94CDAC1272FB491B60D41B157B1470E80813E1C72FFCE785E20A973DE6D |
   | records/WS-032/package/namespace-trial/PRE-CATALOG-HAZARD-AND-CORRECTION.json | 503AB4FE7864AB114299F672B5EECCFD4F11B3E584ADC29C22BFF4931C711CDC |
   | records/WS-032/package/OWNER-BOUNDARY-DECISION.md | 68D4D4ED222CE6CFA99556724238E1D0C4C1A817D0A216732D210B5DB9B164EA |
   ```

   The resulting file's Git blob is 1aeeb4405442d966e582104a6a841bdeb7a2ef55.

## Acceptance Criteria

- [ ] Output `docs/history/LOG.tsv` equals its declared resulting Git blob. check: blob:docs/history/LOG.tsv=3ad4c5529aed70a2789d7afa78e2f503a14ca389
- [ ] Output `docs/history/README.md` equals its declared resulting Git blob. check: blob:docs/history/README.md=d0a49b9091207a7e11100005ea1c981139cbdbc9
- [ ] Output `docs/owner/20261026-delegation/OWNER-DIRECTIVE-INTERACTIVE-MAP.md` equals its declared resulting Git blob. check: blob:docs/owner/20261026-delegation/OWNER-DIRECTIVE-INTERACTIVE-MAP.md=34b53a6409f8b78c6d7bd0ca9b9e8642df248572
- [ ] Output `docs/owner/20261026-delegation/OWNER-DIRECTIVE-UNENCRYPTED-CONTINUITY.md` equals its declared resulting Git blob. check: blob:docs/owner/20261026-delegation/OWNER-DIRECTIVE-UNENCRYPTED-CONTINUITY.md=0e847ab8c25314c20c47648a9ccd9eaedf3527f8
- [ ] Output `docs/owner/20261031-owner-directive-improvement-ws/DIRECTIVE.md` equals its declared resulting Git blob. check: blob:docs/owner/20261031-owner-directive-improvement-ws/DIRECTIVE.md=b79d4fcebf5b1119fa955028d3a34d8cb3ec0ed9
- [ ] Output `docs/owner/20261031-owner-directive-improvement-ws/OWNER-AUTHORITY-20261031.md` equals its declared resulting Git blob. check: blob:docs/owner/20261031-owner-directive-improvement-ws/OWNER-AUTHORITY-20261031.md=189edf84c96ce1f0a3bc0e5d5e310202264cc3ce
- [ ] Output `docs/owner/20261031-owner-directive-improvement-ws/OWNER-REFINEMENT-20261031.md` equals its declared resulting Git blob. check: blob:docs/owner/20261031-owner-directive-improvement-ws/OWNER-REFINEMENT-20261031.md=b41764fa988581c63fca798fdd04e4eb32cd1c97
- [ ] Output `docs/owner/20261031-owner-directive-improvement-ws/OWNER-TWO-FOLDERS-20261031.md` equals its declared resulting Git blob. check: blob:docs/owner/20261031-owner-directive-improvement-ws/OWNER-TWO-FOLDERS-20261031.md=8fe51642457244a4c9d4d51e496f1ba1f8d5a94a
- [ ] Output `docs/owner/README.md` equals its declared resulting Git blob. check: blob:docs/owner/README.md=33f6a31b3cea954beb79d2a58409dc59e636d0c7
- [ ] Output `docs/owner/recovery-inputs/batch6-hold-directive.json` equals its declared resulting Git blob. check: blob:docs/owner/recovery-inputs/batch6-hold-directive.json=25ff6d1dd4df3508d6e5234f23d3346ed2194aa7
- [ ] Output `docs/owner/recovery-inputs/OWNER-APPROVAL-AB.txt` equals its declared resulting Git blob. check: blob:docs/owner/recovery-inputs/OWNER-APPROVAL-AB.txt=23234e27b0424f0dde72dc744bca676b6589d451
- [ ] Output `docs/owner/recovery-inputs/OWNER-DECISION-20261027-evidence-and-trusted.md` equals its declared resulting Git blob. check: blob:docs/owner/recovery-inputs/OWNER-DECISION-20261027-evidence-and-trusted.md=a282cdb360ec8d8e307b1595803a776964849721
- [ ] Output `docs/owner/recovery-inputs/OWNER-DECISION-20261027-no-reinstall.md` equals its declared resulting Git blob. check: blob:docs/owner/recovery-inputs/OWNER-DECISION-20261027-no-reinstall.md=c36a2203324ce8cf0fc161921a4145e1e816be67
- [ ] Output `docs/owner/recovery-inputs/OWNER-DELEGATION.md` equals its declared resulting Git blob. check: blob:docs/owner/recovery-inputs/OWNER-DELEGATION.md=adb2b8ba375e373721db4fe7cbff437823b7c28b
- [ ] Output `docs/owner/recovery-inputs/OWNER-DIRECTIVE-REINSTALL.md` equals its declared resulting Git blob. check: blob:docs/owner/recovery-inputs/OWNER-DIRECTIVE-REINSTALL.md=c0da6d22a4246c890aca103ec7afc89294a5192f
- [ ] Output `docs/owner/recovery-inputs/owner-main-approval-ws013.txt` equals its declared resulting Git blob. check: blob:docs/owner/recovery-inputs/owner-main-approval-ws013.txt=3a2f4e722a5e5aa3f5a54bc4b4270235336541ae
- [ ] Output `docs/owner/recovery-inputs/OWNER-REQUEST-DELEGATE-SKILLS.md` equals its declared resulting Git blob. check: blob:docs/owner/recovery-inputs/OWNER-REQUEST-DELEGATE-SKILLS.md=1ce65f56b9badf4dc8b4b5152d84583541dd4482
- [ ] Output `docs/owner/recovery-inputs/README.md` equals its declared resulting Git blob. check: blob:docs/owner/recovery-inputs/README.md=208efc5d792f672cb5868662b08ecb9ebdeca7a4
- [ ] Output `docs/owner/recovery-inputs/recovery-inputs.json` equals its declared resulting Git blob. check: blob:docs/owner/recovery-inputs/recovery-inputs.json=e7857e76b8aa9770a2a8273c0a33d62598632a10
- [ ] Output `docs/owner/recovery-inputs/ws013-hosted-acceptance.json` equals its declared resulting Git blob. check: blob:docs/owner/recovery-inputs/ws013-hosted-acceptance.json=d443f98e8b82c015206d0c365cdad7067d42f176
- [ ] Output `docs/README.md` equals its declared resulting Git blob. check: blob:docs/README.md=4ca02012ee61a3f43f1a30d12837e4dfff658a78
- [ ] Output `docs/WORKSPACE-LAYOUT.md` equals its declared resulting Git blob. check: blob:docs/WORKSPACE-LAYOUT.md=0f1f4182bb5e9ada9e8a16c2ec14409d6942b4e7
- [ ] Output `lib/test-markdown-consistency.ps1` equals its declared resulting Git blob. check: blob:lib/test-markdown-consistency.ps1=7b6e001e780a9ac4de07c1ff37b1a3aa3ccedef8
- [ ] Output `lib/Test-MarkdownConsistency.ps1` equals its declared resulting Git blob. check: blob:lib/Test-MarkdownConsistency.ps1=01690d30f54a9cd207acb9114a807a7b3933cda3
- [ ] Output `records/README.md` equals its declared resulting Git blob. check: blob:records/README.md=da8ad20b629ec6ee6f3b9d8af43c3ae491dee9e8
- [ ] Output `records/WS-022/README.md` equals its declared resulting Git blob. check: blob:records/WS-022/README.md=7c871df450a1a611476e77dc82554c673f90dcd5
- [ ] Output `records/WS-023/README.md` equals its declared resulting Git blob. check: blob:records/WS-023/README.md=93c52e969e2182bc5cfd87c0458594a277c68a54
- [ ] Output `records/WS-025/README.md` equals its declared resulting Git blob. check: blob:records/WS-025/README.md=1b0e4ec4f701cdf047d9b390683d643ce6693668
- [ ] Output `records/WS-026/README.md` equals its declared resulting Git blob. check: blob:records/WS-026/README.md=3b7170fd7831a602a755cfc026329285e2eb4278
- [ ] Output `records/WS-027/README.md` equals its declared resulting Git blob. check: blob:records/WS-027/README.md=3e8b5cdbeff5576544584fbd1d2742b58038d519
- [ ] Output `records/WS-028/README.md` equals its declared resulting Git blob. check: blob:records/WS-028/README.md=bbe095b313b30b1757d9d2b639758b8f8cf680b8
- [ ] Output `records/WS-029/README.md` equals its declared resulting Git blob. check: blob:records/WS-029/README.md=3fbf070ff89e88d50e57c22b8448ede9825ef38c
- [ ] Output `records/WS-030/README.md` equals its declared resulting Git blob. check: blob:records/WS-030/README.md=41ad3dbe7e32f5243bea2b723bd6986dd683e618
- [ ] Output `records/WS-031/README.md` equals its declared resulting Git blob. check: blob:records/WS-031/README.md=ea8aa09e4aed04328d0dc1f6ef7e7de9db9809d9
- [ ] Output `records/WS-032/README.md` equals its declared resulting Git blob. check: blob:records/WS-032/README.md=1aeeb4405442d966e582104a6a841bdeb7a2ef55
- [ ] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [ ] AC-01 Copies: every owner text and recovery input except recovery-inputs.json has the Git blob of `git hash-object --path=<To> <From>` of its FOLD.tsv source (rows O02-d1/d2, O02-w1 to w4, O03-01 to O03-10, without O03-06). Compared on this role's checkout at its review.
- [ ] AC-02 Map: recovery-inputs.json holds 10 inputs. 9 paths name the Original Root's docs/owner/recovery-inputs, each pin equal to the same file's bytes in this role's checkout (in the sandbox role those absolute paths do not resolve, so the file is taken by its name in the checkout). The receipt's path is under data/records with its original pin 0B7F5C2E504746B9DE07C40A8A350913A497B96F50186981A735359162471252. Exactly 2 pins differ from baseline, ws013-hosted-acceptance and batch6-hold-directive, each listed old to new in docs/owner/recovery-inputs/README.md. Every original at its present path is re-hashed unaltered at this role's review.
- [ ] AC-03 Privacy decision D119: own-finish-receipt.json is in no tree of the range, and neither masked value (the computer name; a marketing tunnel script name) is in any new or changed tracked file or in this contract.
- [ ] AC-04 Frozen text: DIRECTIVE.md is byte-exact, SHA256 E58EC467F29CDDA0F9C749A39807E760CDC1BCD9CD0607630036C2C925D29C4F at source, checkout and guard pin.
- [ ] AC-05 Guard exemption: lib/test-markdown-consistency.ps1 passes on this role's checkout with its test root outside any ORVION-Workbench-temporary folder (DEC-12), including the 6 frozen-text cases (pinned passes; altered bytes, an unpinned path under docs/owner, an orphan, a retired route and a bad citation refused), their 6 mutants killed, and the repository pin check. No existing assertion is weakened or removed.
- [ ] AC-06 Summaries: each records/WS-0NN/README.md ends with its P1.3b source, every paragraph kept in order, apart from these stated exceptions only: (1) the "Each line:" paragraph moves once to records/README.md, (2) 3 paragraphs of WS-023 carry the `Historical citation:` label, (3) one-for-one `[masked]` values, 9 hosts and 55 script names in 9 summaries, (4) 2 fence lines per summary change from backticks to tildes, (5) one sentence of WS-022 describes a wrong value without naming it as a path. The evidence copies keep their bytes.
- [ ] AC-07 Secrets: gitleaks reports 0 findings on the exact candidate range and on this contract; a hit keeps the file out of Git (DEC-09).
- [ ] AC-08 Privacy classification: a privacy-classification.json row in the WS-033 release format for every match in every new tracked file and this contract, on the final blobs, labelled as a self-review, with every byte of the owner texts read. No public commit before it. Any new-to-public value without an owner decision is reported to the owner.
- [ ] AC-09 Backup, read-only part only: the new map meets the input conditions of lib/Backup-Workspace.ps1:244-250 on this role's checkout (schema, name form, fully qualified path, hash form, the file's hash), each file taken by its name in the checkout, and the receipt's hash at its present original because its map path does not exist until P7.2b. The nightly task still reads the old map in Owner-Tools; this map is used by no backup until P7.2b re-installs the task, so landing it changes no backup. A backup run on it before the P7.2b copy refuses with BACKUP_RECOVERY_INPUT_REQUIRED_OR_CHANGED. No package is built, no lib/Backup or lib/Restore file changes, and the checkout is clean after Complete. Marking this criterion claims nothing about DEC-12's backup purpose check, which is PLANNED and unproven until the real backup of P7.2b and the restore of P7.5, each under its own approval and outside this contract.
- [ ] AC-10 Consumers (DEC-12 governance): every reader of a changed thing is listed in the live review with its result: docs/WORKSPACE-LAYOUT.md:366, lib/Backup-Workspace.ps1, lib/Restore-Workspace.ps1, lib/Organize.ps1:479, lib/data-schemas.json:90 for the map; the Finish schedule for the guard; the Markdown guard passes with this contract in place.
- [ ] AC-11 Organize: `Organize -Check` runs once on this role's checkout and its exit and lines by class are recorded as an observation; Hunt reports the same result as its transitional GAP. It is not expected to pass and is not counted as a successful full check. Prototype 3 had 430 BROKEN_PATH lines: 329 name a file a FOLD row brings at P7.2b, 53 name the live store that moves last, 1 was row B (now gone), and 47 are in baseline documents this contract does not touch, 31 for later steps and 16 placeholders or restore-layout names that never resolve. None of that is proven until the data is there; the full check against the required data belongs to P7.2b and P7.5. A BROKEN_PATH with its source under docs/owner or records/ that names neither a FOLD destination nor the live store, or any class other than BROKEN_PATH, MISSING, NO_ORGANIZER, UNKNOWN, TOO_LONG or GENERATED, stops this role for review.
- [ ] AC-12 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in measurements.tsv (failures too), and a live review of its own receipt and criteria. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json.
- [ ] AC-13 Boundary: no P7.2b copy, memory junction, backup task or run, real organizer, DEC-28 copy, follower change, P7.3 to P7.8 write, push or release happens under this contract. Commits stay local (DEC-25).

## Review Gate

- [ ] Inspect the live subject, this role's fresh receipt, timing and watching evidence, and every criterion above, with attempts, deviations and gaps kept visible. No prototype result or earlier receipt substitutes for this role's gate.
- [ ] Review: one Claude-main self-review, labelled as such and never called independent, and the Codex review (DEC-14). Codex at its usage limit at that point: its review is recorded SKIPPED — Codex quota unavailable, no second Claude review replaces it, and no independent review is claimed (D120). Codex available: it reviews in a fresh session, since no V1 and V2 Codex session exists. At most one corrective version; a remaining material disagreement goes to the owner.
- [ ] Retro (DEC-12): Claude main, and Codex if it reviewed, name what does not satisfy them, each item with a remedy and a check.

## One-time procedures after Complete

These are not Implementation Steps and no native gate runs them. Each needs its own later execution approval and leaves its own evidence. Without that approval, none runs. They are listed so the approval that lands these files can see what depends on them.

A. Real organizers. The log rows are already committed, so these run through Organize -New with -Checkout on a disposable clone, -Temporary and -Root on the real folders, and the prototype's arguments. Accept only if each new README's first-write SHA256, as logged in the clone, equals the committed row. Areas: the temporary root and 8 areas (retired and judges take no organizer), then the data root, work, sessions, records. data/events comes last, after B has verified row O08.

B. DEC-28 one-time copy, once, as its own script with its own evidence folder. It is the only permitted direct write to these four single-writer files: data/events/events.jsonl, data/sessions/index.jsonl, data/sessions/INDEX.md, data/work/hunt-last.txt. Before: record SHA256, length and time of each source; prove data/events absent, no backup lease and not within the 02:00 Cairo window, at least 5 GB free, and the follower's state (C). Copy: Fold-OwnerTools -Copy -Only O09-index.jsonl,O09-INDEX.md,O11-hunt-last.tx, then O08 last; it refuses an existing destination and writes no log line to the journal. After: each source re-hashed and unchanged; each destination equal to its source. Any difference stops the procedure and reports the named file. No automatic retry; the sources are never altered; a partial destination stays for the owner to decide. Refused by G02 or any other guard: stop and report; no rewording, splitting names, moving text to a script or editing the hook.

C. Follower cutover, checked at B and not before: whether Sync-Sessions -Follow still runs and on which -Root, one stop or end of it at cutover, then one Sync pass from the new root proving each transcript's prefix. If it ended earlier: record when, and record that Watch-Reminder's ORVION_DATA_ROOT_UNAVAILABLE delays archiving until cutover.

Before P7.2b, also: FOLD.tsv row O03-06 is retired so the receipt copies to data/records with its hash unchanged.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Append only. No approval, execution-root binding or receipt is claimed. At actual approval add exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line using actual immutable identities. Owner evidence must name the approved digest and execution root. For original execution append exactly one Sandbox Receipt and Sandbox Receipt SHA256 for the matching successful schema2 sandbox artifact. A delegated decision needs actual live owner delegation and is labelled delegated. Never invent human confirmation or approval.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-035\assurance\V3\DRAFT.md
Approved SHA256: B0E4A3F8DD4CE1ED6E04A83FDB0F9F6E29676A87617AD3AFE33107A49600E54E
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-035\gate\GATE1-WS035-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: 075286D1C4DBA8696BCB61DD737A2368C41E88C3B3A5855B39475D4BB193E4F1
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-035\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 3E173C4E90E6800062555288FB7F2F0270E5037C38D75A9CBC284D23DD361919
Original exact declared outputs applied by accepted native Execute; fresh own Finish and Review/Complete remain required. Other protected roots unchanged.

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort as set for the session (the plan says high; not readable from inside), the normal V3 author under DEC-13, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W35-draft. Prepared with the owner's D120. Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete, release, real backup or restore has run in this preparation. Draft-time proof is in claude-draft-check.json, REPORT.md, STANDARDS-CHECK.md and privacy-classification.json beside this Draft; V2's attacks are in assurance\V2\REPORT.md. Native admission is not proven here: the evaluator's readers pass, while prepare, allocate, approve and the hazards step of Finish only run in the role. UNPROVEN here: the full suite on this tree (the sandbox Finish proves it); Backup-Workspace itself on the new map (P7.2b runs it); Organize -Check against the required data (P7.2b, P7.5); the controller's first live use.
