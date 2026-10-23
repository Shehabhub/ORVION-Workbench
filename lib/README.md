# ORVION agent tools (tracked local Workbench tools; workspace: ..\README.md)

Proven agent tooling for both repositories. Not repository authority: each repository's own scripts and
contracts decide; these only drive them. Run `Test-ScriptHazards.ps1` on every new scratch `.ps1`.
Contract B supplied each product's own independent native adapters. This directory remains the Workbench agent's tools,
not a dependency injected into direct-native product operation. Its historical move from Documents\ORVION-Sandbox\lib
does not make that old copy an execution entry.

## Workbench's own local cycle

`Workbench.ps1 -Boot` routes own work; `-Execute` checks the accepted applier's read-only plan before writes;
`-Gate -Staged` and `-Gate -Base <accepted-full-SHA> -Head <full-SHA>` use the
accepted checker and preserve native product independence. `Test-WorkbenchChange.ps1` owns own scope, transitions,
three-pass snapshots, exact local approval/root binding, machine clauses and receipt freshness. `run_timed.ps1` and
`watch_run.ps1` are locally adopted reporting adapters; no product installation is needed. Use absolute script paths
and the own explicit WorkingDirectory for self-Finish. The existing tests.ps1 remains the one full closure schedule.
New context-governed contracts bind the sandbox recipe, roots, relevant environment and versions to original execution.
Use WORKFLOW.md and changes/TEMPLATE.md; original approval records the exact successful sandbox receipt artifact.
Own Finish admits headroom/exclusive context use, invokes Events Find and Hunt Quick NoRecord, and runs that schedule
once with its actual parent/recipe binding. The original always needs its own fresh receipt; historical schema1 records
are preserved. These local controls are not human authentication or protection against equal OS privileges.
`test-workbench-governance.ps1` uses independent real-Git fixtures and short children for dispatch/refusal proofs;
those children are not a replacement for the actual full Workbench tool suite. Failed fixture roots are preserved;
WORKBENCH_TEST_ROOT selects their explicit parent, otherwise TEMP/ORVION-Workbench/tests is used. Accepted-code
materializations use WORKBENCH_TEMP_ROOT or that same TEMP/ORVION-Workbench parent. Current prototype
evidence and first-installation bootstrap remain outside this checkout under the existing task's own packet.

## Always, with the Monitor tool (never a hand-written alarm loop)
| When | Run under Monitor | Ends by itself |
|---|---|---|
| Any `scripts/run_timed.ps1` run (Finish, a suite) | `pwsh -NoProfile -File <repo>\scripts\watch_run.ps1 -Log <log> -Run finish-control -Brief` (a suite: `-Run control-suite`) | at END or RUNNER GONE |
| Any heavy run, or two at once | one shared `pwsh -NoProfile -File <lib>\Watch-Host.ps1 -WatchPid <owned runner PIDs> -ExitWhenPidsGone` | when the runners exit |
| Explicit Claude background agents | `pwsh -NoProfile -File <lib>\Watch-Subagents.ps1 -Session <exact session ID or absolute directory> -Only <agent IDs>` (or `-SinceStart`) | ALL FINISHED |

`STALLED` proves an unanswered tool wait; its cause remains UNPROVEN. Investigate the owned subject under native
authority before intervention. `UNREADABLE` is missing evidence, never a healthy state. Watch-Subagents requires an
explicit Claude session and refuses ambiguous/unsafe selectors; it does not guess the latest session or parse Codex.
It masks known credential shapes using the existing Sync-Sessions library before truncating any tool diagnostic.
Stalls append one event per transition; `-EventRoot` selects a disposable journal for tests. It never kills or retries.
`COMMIT LOW` is actionable resource evidence: apply the owning run's recovery policy; it does not grant authority to
kill unrelated work. `PRESSURE` reports slowdown risk. Reuse an existing observer instead of starting a duplicate.
Report state changes, receipts and blockers immediately; routine long-gate heartbeat is at most every five minutes.
Own Workbench Finish uses watcher `-Run workbench-finish`; native product Finish retains `finish-control`. These are
distinct comparable run families in the existing timing history, not new stores or separate monitoring engines.

The user-level Claude hook (`hooks\Watch-Reminder.ps1`) is a reporting adapter, never enforcement or approval.
At the actual Workbench root SessionStart supplies this index/Pulse; a direct-native session receives no Workbench
context. An explicit existing absolute Owner-Tools `-File` command opts in for that event only; mere mentions and
unresolved variables do not. Archival remains separate at session start/end. Native README/AGENTS/Boot and native
tools govern direct entry; neither product acquires an Owner-Tools dependency. No global client setting is changed.
A post-tool reminder cannot prove prior live coverage: attach while the runner is alive; retain any coverage gap
instead of automatically rerunning an expensive test. General management/observer-handle integration remains pending.

## Workspace memory and recovery
| Tool | Purpose |
|---|---|
| `Hunt.ps1 [-Quick]` | the hunting dogs: invariants, liveness, versioning, untested tools, planted-bug mutants, lint; every BUG/GAP becomes an event, the last result shows in Pulse |
| `Coordinator.ps1` / `-Brief` / `-Check` / `-Snapshot` / `-Assign` / `-Close` / `-Dispatch` | one event-journal classifier: UNOWNED, OVERDUE, OWNER, DISPATCHED, ACTIVE. Snapshot returns one schema1 object with Readable, Items and the same Brief lines; an incomplete snapshot explicitly has Readable=false. Explicit Owner=owner or Cause=owner-decision routes owner choices; technical decisions can remain ACTIVE. Text consumers retain UNREADABLE/exit 2 and mutation refuses before writes. Explicit empty journal is valid. Hunts/certifies nothing. |
| `Pulse.ps1` | arrival state from actual Git reads and one Coordinator snapshot shared by owner waits and queue. Inherited assignments stay intact; technical decisions are not owner waits. Missing/failed selected Git or journal evidence is UNREADABLE/exit 2; explicit empty journal or genuinely absent upstream is readable. DIRTY is an observation, never write authority. No fetch, test, retry or certification. |
| `Delegate.ps1 -Pattern <id> -Question '...'` / `-Report <folder> -Reply <file>` / `-List` | the delegation road: a bounded brief for a cold agent (authority never grows, due = twice its budget); `-Report` is the return road: saves the reply, records the verdict, hands the item back to the agent |
| `Spider.ps1 '<entity or phrase>'` | one question across sessions, events, both repos' files and commits, memory and owner packets; ranked, values masked, ~4 s |
| `Events.ps1 -Find '<task>'` / `-Brief` / `-Add` | improvement memory: relevant past failures, discoveries, decisions; watchers record alarms |
| `Sync-Sessions.ps1` | verbatim archive of every ORVION session + `sessions\index.jsonl` (hook runs it at start and end) |
| `Backup-Workspace.ps1 -Destination <usb>` / `Restore-Workspace.ps1 -From <backup>` | everything a clone cannot restore; encrypted drive required; restore never overwrites |
| `..\tests.ps1` | sole full closure schedule: hazards plus each owning test suite; only own timed Finish may launch it with the bound recipe. The normal hook checks admission/freshness, not another full run. |

## Contract lifecycle
| Tool | Purpose |
|---|---|
| `Invoke-ContractStage.ps1 -Config <x>.psd1 -Stage approve|implement|review|complete|bind` | bounded native transport: exact selected Draft/filter identity, native Boot and normal hooks before transitions; whole applier Plan before writes, declared paths only, actual Git authorship. Native gates remain authority. |
| `Test-ContractReview.ps1 -Config <x>.psd1 [-FinishLog <log>]` | read-only pre-Review diagnostics plus one native range Gate; exit1 observed failure, exit2 UNPROVEN/unsupported evidence, exit0 only for the measured class. Never certifies all descriptive/native criteria or replaces independent Review. |
| `Invoke-DraftSteps.ps1` (dot-source) | turns a sandbox diff into literal Draft steps with blobs |
| `apply-draft-steps.ps1 -Draft <d> -Root <clone>` | proves a Draft's steps reproduce its blobs |
| `Invoke-DraftRehearsal.ps1` | bounded literal/native-entry probes in a disposable clone: deliberately interrupts Finish and uses later sandbox-specific hook/worktree arrangements. Not a complete Finish/lifecycle proof; never transplant its results as original certification. |
| `lifecycle.ps1` (dot-source) | shared helpers, including `Stop-ProcessTreeFully` |

These are the Workbench agent's adapters. Direct entry into one product uses that product's own tools only.
An explicitly selected native transport config names the exact Root, baseline, native SPEC/slug, selected Draft,
raw SHA256, filtered allocation blob and configured Git user; every post-allocation stage matches that blob to
its single actual Git allocation before invoking a native child or writing. Do not infer a target from an old folder or another
SPEC with the same number. Read the actual native Boot ACTION/WRITE/START_CONTEXT or refusal preserved by the
adapter. Creation uses the existing literal applier's whole Plan; absent HEAD content is not a creation failure.
Never rerun approve after a diagnostic failure without inspecting actual commits/status: a native transition
may already have succeeded. Native applicability can truthfully be PASS or NOT APPLICABLE; the adapter cannot
grant an exemption. Existing explicit retirement remains scoped, and no invented model/coauthor enters commits.

After implementation commit/DONE, invoke that selected repository's own timed/watched Finish exactly once;
this stage adapter schedules none of its child tests. Independently inspect actual criteria and its own fresh
receipt, supply the real review entry, Complete, then native bind. Failed/unknown diagnostics are visible;
unsupported checks require their owning native evidence, not fabricated approval or a copied criterion engine.
Entry appends name their owning legal section regardless of section order. Reuse existing lifecycle/process and
owned-fixture cleanup helpers. `test-native-stage.ps1` owns focused stub-boundary positives/refusals/mutants;
those fixtures never substitute for a real native lifecycle or an original receipt. General single/multi-target
management, observer handles, recipe bridging and partial recovery remain governed by P3 G2c and are not supplied
by this prerequisite. New tools must enter through the existing tested governance; this index is discovery only.

## Explicit dual owner operations

`Owner-PublishDual.ps1` and `Owner-PromoteDual.ps1` coordinate the two own tracked owner interfaces. `Invoke-OwnerDual.ps1` holds their one shared descriptor/result sequence; it does not replace native gates. They need an interactive owner console and preserve each interface's own confirmation. `-NonInteractive` refuses, and an earlier release delegation is not reused. Use existing approved owner entrypoints to bootstrap a release until the tracked interfaces are available on each trusted `main`.

Run one operation with `pwsh -NoProfile -File <lib>/Owner-PublishDual.ps1 -Descriptor <absolute-json-path> -EvidenceDirectory <absolute-external-directory> -Approval <absolute-operation-approval-json> -ApprovalSha256 <explicit-reviewed-SHA256>`; replace Publish with Promote for promotion. Missing approval refuses. The reviewed descriptor has exactly `schema: 1` and `targets`, an array of exactly two records. Each record has exactly these fields:

| Field | Value |
|---|---|
| `repository` | One `PlatPlusHub/CRM` and one `Shehabhub/ORVION`, each once; their own account routes are checked without requesting a token |
| `candidateRoot` | Explicit absolute original candidate checkout; all four checkout roots must be distinct |
| `trustedRoot` | Explicit absolute clean trusted `main` checkout; no clone, fetch, fast-forward or repair is performed by the coordinator |
| `candidate` | Full lowercase 40-character candidate SHA, already prepared through its own lifecycle |
| `base` | Full lowercase 40-character reviewed main SHA |

`Test-OwnerDualAdmission.ps1` is the one minimum local activation interlock, not full P3 governance. The explicit per-operation document has exactly `schema`, `operation`, `workbenchRoot`, `workbenchHead`, `workbenchConfigSha256`, `sourceDraftSha256`, `reviewSha256`, `sourceFiles`, `descriptorSha256`, `evidenceDirectory`, `expiresUtc` and `configurations`. Use integer schema 1, exact full commit/digest identities, the actual installed clean Workbench root, UTC expiry in `yyyy-MM-ddTHH:mm:ssZ`, four source entries `{path,sha256}` for the two entrypoints, core and checker, and four configuration entries `{root,sha256}` for the selected candidate/trusted local Git configs. No token values belong in the document. The source Draft and independent review digests identify the separately approved installation/review evidence; they are not owner authentication. There is no auto-approval generator or approval registry.

The evidence directory must match the explicit approval and be outside all five checkouts, including Workbench. Exact approval/descriptor bytes, source identities and configuration are checked at admission and again before each side effect. Duplicate JSON members, stale/modified input, wrong selection and missing tracked source refuse. Both product targets are checked before either child is invoked. Each child writes its new allowlisted operation record to a unique target directory; the coordinator validates that record and reads the exact remote ref. A nonzero child, wrong record, unreadable ref or readable ref mismatch prevents a DONE result. `result.json` preserves per-target results, exits and the local admission identity. It is operation evidence, never a native receipt or certification.

The operation document is an explicit local operator assertion. A digest, local hook, mutable receipt or console confirmation cannot authenticate the owner or resist an actor with equal OS privileges. Actual GitHub actor identity remains UNVERIFIED here; own-account routing is configuration evidence only. Preserve independent native Gate/CI/trusted judgments and keep CTRL-19 OPEN. Do not infer live release permission from installing this tool, from a source-contract approval or from a previous release delegation.

After partial success, inspect that result and the refs, then rerun the same reviewed descriptor. An exact already-completed ref is recorded as `ALREADY_DONE` and its child is skipped; the unfinished target is attempted normally. No rollback, retry loop or history rewrite occurs. Test with `pwsh -NoProfile -File <lib>/test-owner-dual.ps1`; its real local Git/child fixtures use explicit console/transport seams and never prove actual authenticated identity or live release. Preserve the external evidence directory with local backup. CTRL-19 remains open.

## Known traps (each cost a run)
- `pwsh -WorkingDirectory X -File scripts/y.ps1` runs the CALLER's repo script: always pass an absolute `-File`.
- `git grep` exits 1 for an unreadable blob, exactly as for "no match"; a failed native command reads as empty.
- `$Pid`, `$Host`, `$Input`, `$Matches`... are automatic variables; `Git`/`H`/`R` collide with commands/aliases.
- A one-element pipeline result is a scalar: wrap lists in `@()`.
