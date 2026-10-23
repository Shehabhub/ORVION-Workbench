# ORVION-Workbench - Target Workspace and Repository Layout

Version 1.3 | 2026-10-24 | Owner-created source root reconciled; data cutover remains pending

## HANDOFF

- INHERITED: [EXECUTION-PLAN.md](EXECUTION-PLAN.md), existing independent product governance and the accepted Workbench checker/tool library.
- PROVEN: Current library names, contract template, native map generator and root-isolation rules were inspected. The owner-created source clone is at GitHub/ORVION-Workbench; old local data and external packets/sandboxes remain in place.
- UNPROVEN: Physical relocation, new configuration/catalog interfaces, proposed packet layout enforcement and future tools. A directory diagram does not implement a guard or prove recovery.
- CHANGED: This document gives full target names, evidence placement, selection semantics, ownership and migration rules. No directory creation/move, source installation or exact implementation approval is implied.
- REMAINING: Introduce each required surface through its owning plan stage and frozen scope; prove consumers and recovery before cutover.
- DO NOT TOUCH: Accepted paths during active operations; frozen Drafts/history; original receipts/refs/configurations; raw archives/secrets. No nested product repositories, shared-Git sandbox shortcut or automatic deletion.
- NEXT: Continue the existing WS005 isolated prototype. Use this layout to prevent new scattering; apply only the small part actually required by its approved scope. Storage migration remains stage 5.

## 1. Actual source root and external operational boundary

Owner-selected source repository: `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench`.

The owner independently cloned the private Shehabhub/ORVION-Workbench repo here and authorized work in it on client date 2026-10-24. Observed HEAD f42c5a098ca69a156e38e7ae8d9a5475c850f288, clean independent Git directory, no alternates, own Boot READY. The existing `.githooks` adapter was enabled in local config and actual admission passed. This is source admission only, not a fresh Finish or recovered local data.

The earlier non-Git parent/control/data topology is superseded by this actual source placement. Do not move/nest the owner clone, recreate its history or weaken the checker to put sandboxes/tests/temp/runtime under it. Source stays at the exact requested path. Existing packets/factory and the one old ORVION-Owner-Tools journal/archive remain external and unchanged until tested cutover. A future consolidated `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-Data` sibling groups those operational roles; that target is not created or installed yet. No guessed aliases, parallel live journal or blank replacement history.

Keep the current Git repository/history, `lib` and existing command names. Preserve the old clone/data until dependencies, active archiver and recovery are proven. Git metadata and engine-owned ignored receipts stay local at their actual owning source root. Historical root-bound evidence remains history; it does not certify this new checkout.

Legend: EXISTING means an actual current file/name, not proof it already occupies this target path. PROPOSED means a new surface that still needs its owning contract. CONDITIONAL means create only when its actual implementation is earned. Examples such as WS005/run-001 are identifiers, not instructions to allocate a contract or create all folders now.

## 2. Full control repository tree

    ORVION-Workbench/                                 [actual independent Git source root]
    |-- .git/                                    [local Git metadata; never copied into tracked payload]
    |-- .gitattributes                           [EXISTING]
    |-- .gitignore                               [EXISTING; not a security boundary]
    |-- .githooks/
    |   `-- pre-commit                           [EXISTING accepted admission adapter]
    |-- AGENTS.md                                [EXISTING agent route]
    |-- README.md                                [EXISTING human/agent entry]
    |-- RESUME.md                                [EXISTING own active-contract pointer]
    |-- HANDOFF.md                               [EXISTING historical programme reference]
    |-- WORKFLOW.md                              [EXISTING own governance]
    |-- tests.ps1                                [EXISTING full-suite owner]
    |-- ai-map.json                              [PROPOSED generated local projection; normally ignored]
    |-- repository-index.md                      [PROPOSED generated local human view; normally ignored]
    |-- .workbench-local-certification.json       [EXISTING local ignored engine receipt]
    |-- .workbench-certifications/               [EXISTING local ignored receipt archives]
    |-- changes/
    |   |-- TEMPLATE.md                          [EXISTING]
    |   |-- WS-001-workbench-local-governance.md  [EXISTING immutable history]
    |   |-- WS-002-execution-context-binding.md  [EXISTING immutable history]
    |   |-- WS-003-observer-integrity.md          [EXISTING immutable history]
    |   `-- WS-004-native-stage-integrity.md      [EXISTING; later contracts use actual allocation]
    |-- docs/                                    [PROPOSED selected durable documentation only]
    |   |-- EXECUTION-PLAN.md                     [future single live plan location after cutover]
    |   `-- WORKSPACE-LAYOUT.md                   [future location of this architecture]
    |-- config/                                  [PROPOSED non-secret examples only]
    |   `-- roots.example.psd1                   [example of logical roots; schema not frozen]
    |-- lib/                                     [preserve ALL existing names below]
    |   |-- README.md
    |   |-- Workbench.ps1
    |   |-- Test-WorkbenchChange.ps1
    |   |-- Test-ScriptHazards.ps1
    |   |-- Invoke-ContractStage.ps1
    |   |-- Test-ContractReview.ps1
    |   |-- Invoke-DraftSteps.ps1
    |   |-- apply-draft-steps.ps1
    |   |-- Invoke-DraftRehearsal.ps1
    |   |-- Owner-PublishDual.ps1
    |   |-- Owner-PromoteDual.ps1
    |   |-- Invoke-OwnerDual.ps1
    |   |-- Test-OwnerDualAdmission.ps1
    |   |-- run_timed.ps1
    |   |-- watch_run.ps1
    |   |-- Watch-Host.ps1
    |   |-- Watch-Subagents.ps1
    |   |-- Pulse.ps1
    |   |-- Events.ps1
    |   |-- Coordinator.ps1
    |   |-- Spider.ps1
    |   |-- Hunt.ps1
    |   |-- Delegate.ps1
    |   |-- Sync-Sessions.ps1
    |   |-- Backup-Workspace.ps1
    |   |-- Restore-Workspace.ps1
    |   |-- lifecycle.ps1
    |   |-- remove-owned.ps1
    |   |-- hooks/
    |   |   `-- Watch-Reminder.ps1               [EXISTING nested hook adapter]
    |   |-- fixtures/
    |   |   `-- seed-events.ps1                  [EXISTING nested fixture helper]
    |   |-- test-workbench-governance.ps1
    |   |-- test-native-stage.ps1
    |   |-- test-owner-dual.ps1
    |   |-- test-draft-steps.ps1
    |   |-- test-lifecycle-failclosed.ps1
    |   |-- test-coordinator.ps1
    |   |-- test-events.ps1
    |   |-- test-events-retrieval.ps1
    |   |-- test-spider.ps1
    |   |-- test-hunt.ps1
    |   |-- test-delegate.ps1
    |   |-- test-watch-host.ps1
    |   |-- test-watch-subagents.ps1
    |   |-- test-watch-reminder.ps1
    |   |-- test-sync-sessions-append.ps1
    |   |-- test-sync-sessions-rewrite.ps1
    |   |-- test-sync-sessions-secrets.ps1
    |   |-- test-sync-sessions-survival.ps1
    |   |-- test-backup-restore.ps1
    |   |-- test-remove-owned.ps1
    |   `-- test-pulse.ps1                        [PROPOSED owning test for the recorded gap]
    `-- workstation/                             [CONDITIONAL stage 6 requirements, not empty scaffold]
        `-- requirements.psd1                     [only if a separate owned manifest is earned]

No separate gates/profiles/engines folders are introduced: those mechanisms already belong to the accepted checker and owning scripts. Do not move tests out of lib; tests.ps1 currently discovers/executes their bound recipe there. A new WS005 transport helper or generator and its test must receive concrete names from the proven prototype/frozen scope, not an assumed command copied from a diagram.

No CI workflow is installed by this layout. The private source remote already exists; add actual hosted admission only through its separately owned CI scope. Workstation Doctor/Prepare commands are likewise not invented here: stage 6 must select real existing adapters or earn explicitly tested additions. General AI/MCP/search services are not added as architecture scaffolding.

## 3. Full local-data tree

    ORVION-Workbench-Data/                            [target external data root; not installed]
    |-- config/
    |   `-- roots.local.psd1                      [PROPOSED sole local location binding]
    |-- legacy/                                  [CONDITIONAL preserved historical bundles]
    |   |-- ORVION-Owner-Review/                  [retain required original relative structure]
    |   |-- ORVION-Sandbox/                       [only inventoried protected historical content]
    |   |-- ORVION-Owner-Tools/                   [old external owner tools, not a second live lib]
    |   `-- ORVION-drafts-backup/                 [required provenance, not an active Draft route]
    |-- packets/
    |   `-- WS005/                               [example unit identity; not Gate 1]
    |       |-- planning/
    |       |   |-- PLAN.md                      [one working proposal for this unit]
    |       |   `-- revisions/
    |       |       |-- P01-design.md             [retained substantial plan revision]
    |       |       `-- P02-correction.md         [evidence/reason for an earned correction]
    |       |-- assurance/
    |       |   |-- V1/
    |       |   |   `-- DRAFT.md                 [Design snapshot]
    |       |   |-- V2/
    |       |   |   `-- DRAFT.md                 [Adversarial Review snapshot + findings]
    |       |   `-- V3/
    |       |       `-- DRAFT.md                 [Evidence Refresh; selected reasons/sources in footer]
    |       |-- selected/
    |       |   `-- selection.json               [derived pointer to exact V3 bytes; no copied Draft]
    |       |-- authority/
    |       |   |-- sandbox-approval.json        [actual decision evidence when lawful/applicable]
    |       |   `-- original-approval.json       [actual human or honest DELEGATED evidence]
    |       |-- config/
    |       |   |-- platinum.psd1                [only when this target is selected]
    |       |   `-- founder.psd1                 [only when this target is selected]
    |       |-- payload-source/                 [selected output bytes, not another editable engine]
    |       |-- accepted/                       [preserved accepted evaluator inputs if required]
    |       |-- payload.json                    [literal replay/output identities]
    |       |-- EVIDENCE.json                   [packet evidence pointers and declared classes]
    |       |-- SHA256SUMS.txt                  [sealed bounded immutable artifacts, excludes itself]
    |       `-- migration/                      [CONDITIONAL for an actual relocation unit]
    |           |-- path-map.json               [old/new/provenance mapping]
    |           `-- COPY-VERIFY.json            [actual copy/consumer verification evidence]
    |-- sandboxes/
    |   `-- WS005/
    |       |-- prototype/                      [independent Workbench Git clone, push DISABLED]
    |       |-- platinum/                       [independent native clone only when required]
    |       |-- founder/                        [independent native clone only when required]
    |       `-- third-fixture/                  [bounded explicit-routing proof only]
    |-- tests/                                  [short disposable test-fixture root]
    |   `-- run-001/                            [generated unique owned fixture identity]
    |-- temp/                                   [working scratch, not frozen assurance]
    |   `-- op-001/                             [generated unique owned operation identity]
    |-- runtime/
    |   `-- WS005/
    |       `-- run-001/                         [actual unique run identity]
    |           |-- operation.json              [existing operation record extended only if earned]
    |           |-- result.json                 [operation outcome, NOT native certification]
    |           |-- host.log                    [one shared host observer where warranted]
    |           `-- targets/
    |               `-- platinum/               [repeat only for explicitly selected subjects]
    |                   |-- finish.log
    |                   |-- finish.log.resources.csv
    |                   |-- watcher.log         [actual observer capture if supported/needed]
    |                   |-- finish.exit         [actual producer exit, not inferred success]
    |                   `-- receipt.json        [immutable captured native receipt when needed]
    |-- evidence/
    |   `-- WS005/                              [durable evidence not already owned by packet/run]
    |       `-- REVIEW.md                       [only a substantive owning review, not routine report]
    |-- sessions/
    |   |-- raw/
    |   |   |-- claude/                          [retain project/session/subagent/tool-result paths]
    |   |   `-- codex/                           [retain actual year/month/day archive layout]
    |   |-- index.jsonl                         [derived from retained archive, not vanished sources]
    |   `-- INDEX.md                            [derived human view]
    |-- events/
    |   `-- events.jsonl                        [the ONE existing event journal]
    |-- indexes/
    |   |-- catalog.json                        [PROPOSED local federated source/coverage catalog]
    |   `-- INDEX.md                            [PROPOSED derived human view]
    `-- graveyard/
        `-- q-001/                              [generated verified quarantine identity]
            |-- QUARANTINE.json                 [origin, verified UTC, content/hold/authority evidence]
            `-- content/                        [only specifically eligible quarantined material]

All new JSON/PSD1 names in this tree are design proposals, not published schemas or existing command interfaces. Reuse an owning equivalent instead of introducing a duplicate record. Folders are created on demand for a real unit/run; do not allocate empty projects, fake approvals or placeholder receipts.

### Assurance and selected-version rules

1. Planning/PLAN.md is editable pre-freeze design work. planning/revisions retains only substantial corrections worth preserving, not every thought or chat. It never changes an approved contract.
2. V1, V2 and V3 have distinct IDs and SHA-256 identities, actual pass evidence and reviewable sources. V3 is the selected stage required by the current Workbench template. Preserve failed/rejected reasoning too.
3. selected/selection.json points to the exact immutable assurance/V3/DRAFT.md by unit, version, relative location and digest. It is a derived locator, not approval and not a new registry. Human selected-version navigation is generated from that same pointer.
4. Do not duplicate DRAFT.md inside selected. The current Draft Assurance V3 path and Approved Draft must identify the actual selected artifact; the approval identifies its exact bytes and execution root. No self-hash inside its own Draft and no assumed new selection schema accepted by current guards.
5. Once frozen, never edit an assurance snapshot, payload or approval to repair an execution failure. Preserve it; use a lawful corrected successor/new identified bundle. Existing sealed packages remain byte-identical regardless of this new naming model.
6. Rejected V1/V2 and required V3 evidence are protected knowledge, not disposable graveyard content. Only redundant scratch/clones/material independently proven eligible may enter quarantine after the required preservation and approvals.

### Evidence ownership: one file, clear role

| Location | Owns | Does NOT own |
|---|---|---|
| ORVION-Workbench/changes | actual Workbench CR, legal status and runtime checkpoint | a product CR or duplicate approval registry |
| ORVION-Workbench/docs | single selected plan and architecture after proven cutover | raw sessions, active run results or competing live state |
| data/packets | unit proposal/assurance, approval artifacts, literal payload and seal | certification merely from being named selected |
| data/runtime | real operation/log/exit/observer and captured result evidence | authority to waive native Finish/Review/CI |
| data/evidence | substantive research/review not already owned elsewhere | mandatory per-session reports or duplicate logs |
| data/indexes | generated pointers, source states and coverage | business truth, approvals or secrets |
| data/events | existing append-only operational lessons/assignment | second active-CR state |
| data/sessions | original retained transcripts and derived indexes | hidden reasoning or proof of work not recorded |

Runtime logs supporting a required receipt remain protected even when old; directory name does not authorize cleanup. Original native/Workbench engine receipts stay at their owning paths. Captured immutable copies retain origin/digest and are evidence, never transplanted working receipts. Do not duplicate raw files into evidence merely to make the tree look complete.

Tool-result attachments remain at their real archived relative paths; there is no new global sessions/tool-results folder. legacy is a protected history container only when preservation needs it, not a second working library or permission to copy every disposable clone. Inventory and map each retained bundle once; active units/checkpoints use their tested cutover routes, never an automatic wholesale move into legacy.

## 4. Logical roots and configuration

Use the proposed local roots binding as a location adapter only: ControlRoot, SandboxRoot, TestsRoot, TempRoot, RuntimeRoot, PacketRoot, EvidenceRoot, SessionRoot, EventRoot, IndexRoot and GraveyardRoot. Select their actual schema through a reviewed implementation; this list is not an accepted PSD1 interface.

Original Root maps to the actual ORVION-Workbench source checkout. The future external data-root roles are sandboxes, tests, temp and runtime. Until tested cutover, the exact current contract declares their existing external locations. Keep these roots distinct/non-overlapping as required by the actual checker. Native product/trusted roots are explicit external bindings keyed by repository identity, not inferred siblings. An operation's exact pinned config/contract still decides authority; editing roots.local cannot silently relocate an approved operation.

Use relative paths inside each root; use declared absolute bindings between roots. Non-secret examples can be tracked; machine bindings, session catalogs, operation approvals and sensitive state remain local. Account handles may be named; token/password values never enter either tracked examples or generated catalogs.

The current Pulse/Spider/session/backup tools have real path assumptions. A roots file alone does not implement indirection: each affected consumer must be changed/tested in scope. Current own receipt placement and raw-session relative layout must be preserved until their consumers prove any change. Generated catalogs include included/excluded/unreadable coverage and validate relevant freshness rather than trusting a timestamp alone.

## 5. Product repositories, backups and workstation boundary

    Agent -> ORVION-Workbench/lib/Workbench.ps1 -> selected native entry/engines -> own native receipts/verdicts
                      |                           |
                      +-> existing observers <----+ actual runs/logs
                      +-> declared data roots / generated discovery pointers

The management entry validates/dispatches; the native engine decides; observers report; generated catalogs locate. Observation and discovery cannot grant dispatch or native authority, and management cannot replace native verdicts.

Platinum CRM, Founder ORVION and their trusted checkouts stay independent at their currently accepted locations. Workbench references them explicitly. They are not subfolders, vendored source or submodules inside control; direct-native operation gains no dependency on this layout.

Encrypted recovery copies belong on their actual approved backup medium outside the sole working disk. They are not replaced by data/evidence or a Git push. Store recovery proof/pointers under its owning unit; never copy credentials into a local recovery folder. External Windows tools/authentication and installed services are dependencies to diagnose, not directories copied into this repo.

The owner-authorized private remote is https://github.com/Shehabhub/ORVION-Workbench; accepted f42c5a0 main was published and downloaded with matching tree and read-only Boot. Important external plan/layout artifacts are not part of that initial push yet. Their future canonical ORVION-Workbench/docs placement requires the owning source contract and a single-live-location cutover.

Track the minimum safe material whose loss would remove knowledge, exact authority, reproducibility or the ability to resume: source/tests/governance, actual contracts, selected plans, safe templates and selected non-secret assurance/decision evidence. A generated dependency lock can be essential; a handwritten scratch note can be disposable. Normally regenerate local maps/search views, caches, scratch, clones and repetitive raw logs. Generated local projection policy does not change native repositories' required tracked maps.

.git metadata, working receipt archives, machine bindings, raw sessions/events, local catalogs, runtime, prototypes and graveyard are not ordinary source payload. Required unique ignored evidence must have proven protected backup or an explicitly reviewed safe evidence capsule, not be silently dropped. Never put secrets/raw sensitive sessions into Git merely to achieve one physical storage location. Existing exact artifact files stay unchanged; any curated safe export is labelled as such and never substituted for its original approval/receipt. No new duplicate approval registry is introduced.

This layout does not implement hosted enforcement or authorize unrelated remotes. Verify the actual tracked publication subject and a fresh download; a source clone is not complete workstation recovery.

### Existing locations to account for at migration

| Current location | Target treatment; not a move command |
|---|---|
| Documents/GitHub/ORVION-Workbench | actual selected source clone, same accepted history and private origin; keep this Git root |
| Documents/GitHub/ORVION-Owner-Tools | preserved old clone and the one current sessions/events/work store; route explicitly until tested migration, no parallel live journal |
| Documents/ORVION-Owner-Review | current selected plan/layout eventually enter ORVION-Workbench/docs; live packets are mapped explicitly; required sealed old bundles may retain their structure under data/legacy/ORVION-Owner-Review |
| Documents/ORVION-Sandbox | map live sandbox/runtime/test/checkpoint material by actual role; required historical bundles may use data/legacy/ORVION-Sandbox; do not sweep the directory wholesale |
| Documents/ORVION-Owner-Tools | identify old external release scripts/evidence versus replaced copies; preserve required history under data/legacy/ORVION-Owner-Tools; no second active lib |
| Documents/ORVION-drafts-backup | inventory required provenance under data/legacy/ORVION-drafts-backup; never treat these copies as current selected authority |
| Native original/trusted roots, installed tools, credential stores, encrypted USB | explicit external dependencies; not nested inside control and not absorbed by this diagram |

The mapping must record what remains, is copied, becomes active, stays historical or is separately proposed for retirement. No source folder is disposable merely because this table names a destination.

## 6. Adoption order and architectural checks

1. Plan stages 1-3: preserve lib names, actual selected root/operation handling, exact assurance pointers and native independence. Create WS005 prototype outputs only in its existing declared external roots until its contract says otherwise.
2. Stage 4: introduce derived control map and local federated catalog through actual consumers. Correct the incomplete Spider coverage without unbounded disk/archive crawling. Prove missing/stale/read failures and actual fresh-agent discovery.
3. Stage 5: inventory/copy/hash/consumer-cutover/restore proof before consolidating external data. Preserve the actual new source clone. Prove parent-derived defaults, hooks, process working directories, recipe/approval root bindings, active processes, backup and session paths. Do not rewrite frozen historical absolute paths; preserve source-to-new-location mapping.
4. Moving original roots changes exact authority inputs. Existing frozen root-bound approvals cannot be silently reused. Select a quiescent boundary and approved migration/successor route; do not move during Finish or ongoing archiving without its proven controlled cutover.
5. Check the deepest actual generated Windows fixture/revision/path probe against the installed toolchain. The existing checker has a concrete 260-character refusal. Prefer short unit/run identifiers and data/tests; do not change registry settings or weaken the guard to fit a diagram.
6. Retain the sole current live checkpoint and selected execution plan until a proven cutover to their future locations. At cutover establish one live location plus explicit historical provenance; never maintain two manually synchronized live plans.
7. Plan stage 6 proves encrypted clean-machine recovery of the selected real layout. Stage 7 retains ADR-0033 closure and the owner-held Batch 6 decision.

Acceptance attacks: outside-root creation; junction/sibling/ancestor escape; duplicate common Git/output roots; unknown/ignored evidence omitted; stale/partial index displayed as complete; changed selected bytes; pointer falsely treated as approval; raw secret in generated tracked view; frozen metadata rewritten during migration; old path consumer still writing elsewhere; missing archive source deleting a retained session from index; interrupted copy/refresh/quarantine; required evidence offered to purge; clean restore unable to run an actual entry.

This diagram does not require every proposed file/folder now. Create only earned implemented surfaces. No generic framework, new resident watcher, semantic index, scheduler or extra governance engine is authorized by naming folders. This remains the smallest compatible evolution of the current tools.

## 7. Source basis and change record

- Existing control README/AGENTS/RESUME/WORKFLOW, changes/TEMPLATE.md, lib/README.md and Test-WorkbenchChange root/assurance checks; actual library inventory on 2026-10-23.
- Existing native scripts/generate-ai-map.ps1: deterministic source-derived projections and non-writing freshness check.
- Existing Events lessons: repository independence, nested sandbox hazards and archive-derived session indexing.
- [Git repository layout](https://git-scm.com/docs/gitrepository-layout): actual Git metadata/common-directory boundaries; not a mandate for these application folder names.
- [Microsoft path limits](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation): runtime/API-specific limits, not a universal long-path guarantee.
- 2026-10-24 / v1.2: retention is based on recovery/authority value rather than whether a file is generated; local derived maps normally stay ignored. Recorded the verified private initial source remote and the still-pending inclusion of important external documents/evidence. No physical cutover or prototype installation claimed.
- 2026-10-23 / v1.1: owner selected Documents/GitHub/ORVION-Workbench as the exact common parent. Added the existing nested hooks/fixtures library files found during recursive path-consumer inspection. Current operational roots remain unchanged pending proof.
- 2026-10-23 / v1: owner requested a concrete complete layout, including tools, plan drafts/improvements, assurance snapshots and selection. Added this architectural companion without relocating source/data or changing current exact contracts.

Canonical routing: proposed source document until this exact own scope completes. Then select the installed source docs in the sole programme checkpoint; external prior revisions remain history, never a second manually synchronized authority.
