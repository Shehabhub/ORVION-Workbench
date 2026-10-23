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
| Any heavy run, or two at once | `pwsh -NoProfile -File <lib>\Watch-Host.ps1 -WatchPid <runner pid> -ExitWhenPidsGone` | when the runners exit |
| Any background agent | `pwsh -NoProfile -File <lib>\Watch-Subagents.ps1 -Session <session id> -SinceStart` | ALL FINISHED |

On `STALLED`: stop the agent, fix the cause (usually a tool call outside the working directories needs an
unseen approval), relaunch. On `COMMIT LOW`: stop the newest heavy run. On `PRESSURE`: expect slowdown only.
Read-only background agents: use Read/Grep/Glob, not shell commands, so no approval is ever needed.

Enforced on this machine by a user-level Claude Code hook (`~/.claude/settings.json` -> `hooks\Watch-Reminder.ps1`):
every session starts with this table; launching a background agent or a `run_timed.ps1` run injects the exact
command to monitor it. Agents that do not read Claude hooks (Codex, other machines) get the rule only once the
wave-2 tooling contract tracks these tools in each repository and names them in `AGENTS.md`.

## Workspace memory and recovery
| Tool | Purpose |
|---|---|
| `Hunt.ps1 [-Quick]` | the hunting dogs: invariants, liveness, versioning, untested tools, planted-bug mutants, lint; every BUG/GAP becomes an event, the last result shows in Pulse |
| `Coordinator.ps1` / `-Brief` / `-Check` / `-Assign` / `-Close` / `-Dispatch` | the coordinator over every tool: reads the one journal (events) and holds each open item to an owner, a next action and a due time (TRIAGE, OVERDUE, OWNER, DISPATCHED, READY); hunts nothing, closes nothing without a recorded reason |
| `Pulse.ps1` | the live state any arriving agent sees first (repos, pending candidates, running, host, waiting on the owner, last session, the coordinator's queue); session start prints it |
| `Delegate.ps1 -Pattern <id> -Question '...'` / `-Report <folder> -Reply <file>` / `-List` | the delegation road: a bounded brief for a cold agent (authority never grows, due = twice its budget); `-Report` is the return road: saves the reply, records the verdict, hands the item back to the agent |
| `Spider.ps1 '<entity or phrase>'` | one question across sessions, events, both repos' files and commits, memory and owner packets; ranked, values masked, ~4 s |
| `Events.ps1 -Find '<task>'` / `-Brief` / `-Add` | improvement memory: relevant past failures, discoveries, decisions; watchers record alarms |
| `Sync-Sessions.ps1` | verbatim archive of every ORVION session + `sessions\index.jsonl` (hook runs it at start and end) |
| `Backup-Workspace.ps1 -Destination <usb>` / `Restore-Workspace.ps1 -From <backup>` | everything a clone cannot restore; encrypted drive required; restore never overwrites |
| `..\tests.ps1` | every check: hazard scan of all scripts + each `test-*.ps1` (pre-commit runs it) |

## Contract lifecycle
| Tool | Purpose |
|---|---|
| `Invoke-ContractStage.ps1 -Config <x>.psd1 -Stage approve|implement|review|complete|bind` | executes an owner-approved Draft on the real checkout; every git read throws on failure |
| `Test-ContractReview.ps1 -Config <x>.psd1 [-FinishLog <log>]` | read-only live-Git Review checks (scope, authors, allocation blob, every criterion) |
| `Invoke-DraftSteps.ps1` (dot-source) | turns a sandbox diff into literal Draft steps with blobs |
| `apply-draft-steps.ps1 -Draft <d> -Root <clone>` | proves a Draft's steps reproduce its blobs |
| `Invoke-DraftRehearsal.ps1` | full lifecycle rehearsal of a frozen Draft in a disposable clone (push DISABLED) |
| `lifecycle.ps1` (dot-source) | shared helpers, including `Stop-ProcessTreeFully` |

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
