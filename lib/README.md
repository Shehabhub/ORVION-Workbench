# ORVION agent tools (tracked local Workbench tools; workspace: ..\README.md)

Proven agent tooling for both repositories. Not repository authority: each repository's own scripts and
contracts decide; these only drive them. Run `Test-ScriptHazards.ps1` on every new scratch `.ps1`.
Contract B supplied each product's own independent native adapters. This directory remains the Workbench agent's tools,
not a dependency injected into direct-native product operation.

Historical citation: Documents\ORVION-Sandbox\lib was the former library location, now retired.

Data root (one data root everywhere): Events, Spider, Pulse, Coordinator, Delegate, Watch-Subagents, Sync-Sessions,
Backup-Workspace, Hunt `-DataRoot` and the session hook (`hooks\Watch-Reminder.ps1`) default to
`ORVION_DATA_ROOT`, else the sibling `..\ORVION-Owner-Tools` store. Missing data is unavailable; default writers
refuse `ORVION_DATA_ROOT_UNAVAILABLE` unless the sibling has `events\`. Pass an explicit root for tests/hosted use.
An environment override must be fully qualified; otherwise `ORVION_DATA_ROOT_NOT_ABSOLUTE` refuses it. The hook
reports on stderr, exits 0, and logs only to an absolute override or an existing sibling store, never the checkout.
Hunt `-NoRecord` suppresses events only: `work\hunt-last.txt` remains in the data root.
Readers report `EVENTS_UNAVAILABLE` (exit 3), `EVENTS_INCOMPLETE` (exit 2), or `SPIDER_COVERAGE: incomplete` (exit 3).
Pulse reports a damaged session index as `last UNREADABLE` with exit 2. A missing index prints `last none: no session
index`; it does not itself make Pulse fail when the journal and selected repositories are readable.
Failed process/host discovery prints `running  UNREADABLE` (exit 2). Pulse output is capped at 4096 characters: diagnostics,
counts and pointers first, then owner waits in urgency order, ending with an exact `more` line and a same-root Coordinator command.
SessionStart waits at most 6 s for Pulse (then kills its process tree and says live state is UNREADABLE) and caps its context at 8192.
Hunt reports malformed or unreadable `sessions\index.jsonl` rows as `BUG index-unreadable` with a count and keeps going.
Hunt's `-Root` stays this checkout (its source and lint scope).

Codex archival reads the compact first session-metadata line. Its cwd selector accepts a `Documents\GitHub\CRM`
or `Documents\GitHub\ORVION` prefix, or `ORVION` anywhere in cwd (PowerShell's case-insensitive match).
Use `..\ORVION-Workbench-temporary\cx\<name>` for disposable Codex clones. That parent contains ORVION, so its
clones are selected by the archival cwd rule. Naming a clone does not change its native repository authority.

## Arrival and knowledge practice

Pulse supplies live state; use the private STATE.md route from the root resume file, never a copied owner-wait inventory. If STATE.md is missing or unreadable, resume from Pulse's `in flight` lines; if commands cannot run, read the newest `RESUME HERE` entry in the journal (`Events.ps1 -Find 'resume here'`). Before authorized operational work, Events -Find returns relevant lessons and Spider recovers a specific original fact. Use the actual resolved data root described above, not a second journal. Find a comparable executed contract in its owning repository and reuse its proven shape. Hunt Quick NoRecord is bounded gap discovery; full Hunt is reserved for relevant risky work. A first diagnosis is a hypothesis until measured.

Confirmed lessons become Events entries and graduate through a contract to their repository home. Long work records a dated checkpoint and RESUME HERE pointer in the one journal. A recurring pattern is an investigation candidate, not authority for a task. Retained sessions include client-written messages, tool calls/results, attachments, subagents and hook context; hidden reasoning, unwritten client state and already-deleted sources cannot be recovered. Claude's retention can remove originals; the archive preserves retained bytes rather than summarizing them away. Credential-shaped index findings name rules/locations, never values; token shapes do not prove live credentials. Review recovery scan findings through [RECOVERY.md](../docs/RECOVERY.md).

Use absolute -File paths: pwsh -WorkingDirectory does not select a relative script. .NET file APIs ignore PowerShell location, and worktree git config may edit shared local configuration. A failed native read is not empty success; use checked exits. PowerShell double-quoted text turns `` `r `` / `` `t `` into control bytes and drops other backticks: write Markdown code as ` ``x`` ` there; the Gate refuses U+000D (`PROHIBITED_CHARACTER`). Literal Draft steps must survive actual applier preflight and blob comparison: they must match how `apply-draft-steps.ps1` applies them (substring matching, deletions with context, a final newline; `test-draft-steps.ps1` covers it). In a product repository, never write an unallocated SPEC id in a tracked file (it reserves the number), and never commit a blocked checkpoint. Read old code's top level before running a causal negative: it may install real tools. Do not restart a host-killed heavy run without its owning authorization.

## Markdown guard

Test-MarkdownConsistency.ps1 checks working/index/explicit-tree Markdown without writes or external path probes. test-markdown-consistency.ps1 owns isolated Git fixtures and causal guard mutants and is discovered by the existing tests.ps1 recipe. [WORKFLOW](../WORKFLOW.md#markdown-consistency) owns the rules, root budgets, history exceptions and one-home table.

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
WORKBENCH_TEST_ROOT selects their explicit parent. `workspace-layout.ps1` resolves temporary storage: explicit
WORKBENCH_TEMP_ROOT first, then an explicit restore target, then a containing ORVION-Workbench-temporary, then
the canonical installed checkout's sibling ORVION-Workbench-temporary. Entries set process TEMP and TMP to its
`tmp\` before children start; accepted-code materializations use that root. Broken local layouts refuse
`WB_TEMP_LAYOUT_UNAVAILABLE`. Only RUNNER_TEMP, GITHUB_ACTIONS=true or an explicit ORVION_STANDALONE_TEMP=1
allow system temp for hosted/standalone use. An explicit root must be absolute and outside the checkout. Current prototype
evidence and first-installation bootstrap remain outside this checkout under the existing task's own packet.

## Always, with the Monitor tool (never a hand-written alarm loop)
Codex runs are watched by the orchestrator, or through this checkout's `lib\run_timed.ps1` with `lib\watch_run.ps1` (use absolute paths and the run's explicit WorkingDirectory).
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

Claude Code runs this checkout's `lib\hooks\Watch-Reminder.ps1`, a reporting adapter, never enforcement or approval; its sessions/events use the one data root described above.
At the actual Workbench root SessionStart supplies this index/Pulse; a direct-native session receives no Workbench
context. An explicit existing absolute `-File` command inside this Workbench checkout's `lib\` opts in for that event only; mere mentions and
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
| `Map-Repos.ps1` / `-Links <path>` / `-Orphans` / `-Install` | Interactive repository map v1: every Git repository under the GitHub folder, tracked files only, Obsidian-style links and backlinks (markdown links, named paths, globs, distinctive names, SPEC/WS/ADR ids, cross-repository) and orphans -> root `ai-map.json` + `ai-map.html` (git-ignored); `-Install` refreshes hourly and at logon |
| `Spider.ps1 '<entity or phrase>'` | one question across sessions, events, both repos' files and commits, memory and owner packets; ranked, values masked, ~4 s |
| `Events.ps1 -Find '<task>'` / `-Brief` / `-Add` | improvement memory: relevant past failures, discoveries, decisions; watchers record alarms |
| `Sync-Sessions.ps1` | verbatim archive of every ORVION session + `sessions\index.jsonl` (hook runs it at start and end); explicit `-AcknowledgeErrors -Root <data> -ExpectedSHA256 <hash> -Reason <text>` archives reviewed errors and records their acknowledgement |
| `Backup-Workspace.ps1 -Destination <usb>` / `Restore-Workspace.ps1 -From <backup>` | everything a clone cannot restore; encrypted drive required; restore never overwrites. Selective package v1: `-Package` (both) makes or restores one unencrypted 7z with a redacted secret-scan report instead (`..\docs\RECOVERY.md`) |
| `Restore-ORVION.cmd` / `Restore-ORVION.ps1` | double-click recovery beside the newest package and required .sha256; installs missing Git/7-Zip/pwsh, restores from its own Workbench bundle, runs product preparation, prints manual actions (`..\docs\RECOVERY.md`) |
| `..\tests.ps1` | sole full closure schedule: hazards plus each owning test suite; only own timed Finish may launch it with the bound recipe. The normal hook checks admission/freshness, not another full run. |

Session appends prove every archived prefix byte by streaming; rewrites retain the old version. Any failed pass emits a diagnostic even with `-Quiet` and exits 3 (follow remembers earlier failures). Hooks launch detached: success stays silent, failure status/output belongs to the child and never blocks the hook.
Restore requires a complete hash manifest, including `backup.json`, and refuses absolute or parent paths before writing. Every repository uses the same config allowlist; auth headers, cookie files, unapproved helpers and helpers containing literal secrets refuse by key only. Empty helper resets, manager/manager-core/wincred and gh auth token/git-credential commands (including shell functions) survive for re-login. URL userinfo is stripped from config keys and values with a key-only warning before any config or origin metadata is saved. Clone/init metadata is silently omitted; branch upstream entries remain kept.

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

## Session error acknowledgement

Hunt reports every nonempty `<data>\work\sync-errors.log` as a BUG. Review those failures and their disposition,
then hash the reviewed file with `Get-FileHash -LiteralPath '<data>\work\sync-errors.log' -Algorithm SHA256`.
Run `pwsh -NoProfile -File lib\Sync-Sessions.ps1 -Root '<data>' -AcknowledgeErrors -ExpectedSHA256 '<hash>' -Reason '<review and disposition>'`.
An explicit root, exact current hash and nonempty reason are required; acknowledgement cannot accompany `-Follow`.

A short per-log mutex shared with the error writer protects the reviewed bytes. The command creates a new readonly
`<data>\work\sync-errors-ack-<SHA256>-<id>.log`, verifies its bytes, appends and verifies a unique event containing its
digest, reason and archive path, then retires the matching active log. The follower's lifetime mutex is independent.
Success returns 0. A stale hash or any archive/event/retirement failure returns 3 and leaves the active log blocking.
Retain acknowledgement archives and the journal for recovery. New failures create a new active log and block Hunt
again; an acknowledgement records disposition of the reviewed errors, rather than proving a healthy sync.

For event evidence, Hunt checks the latest nonempty citation per pattern, ordered by `at` with journal order breaking
ties. Append corrections under the same pattern with corrected `-Evidence`; later empty assignment metadata inherits
that citation, and resolved status alone does not excuse a missing path. `test-sync-sessions-ack.ps1` owns refusal and
concurrency fixtures; `test-ws020-mutants.ps1 -Mutant <id>` runs a direct focused negative probe (`All` runs every mutant).

## Known traps (each cost a run)
- `pwsh -WorkingDirectory X -File scripts/y.ps1` runs the CALLER's repo script: always pass an absolute `-File`.
- `git grep` exits 1 for an unreadable blob, exactly as for "no match"; a failed native command reads as empty.
- `$Pid`, `$Host`, `$Input`, `$Matches`... are automatic variables; `Git`/`H`/`R` collide with commands/aliases.
- A one-element pipeline result is a scalar: wrap lists in `@()`.


## Workbench local CI test context

Use Workbench.ps1 -CI -Candidate <exact-40-character-lowercase-HEAD> -CIRuntimeRoot <new-external-directory> -Actionlint <external-pinned-actionlint.exe>. The existing engine starts its timed runner/watcher and tests.ps1 once; inspect ci.log, watcher.log, runner.exit, watcher.exit and ci-result.json at that external root. Nonzero, omitted owning suites, changed candidate/recipe/inputs, absent observer or forged direct suite parent refuses. Never invoke tests.ps1 or -CIWorker to bypass the parent. Native Finish/approval/receipt/Review/Complete remain independent and unchanged. This CI result cannot certify original work. Get-WorkbenchCITool owns the pinned tool identities; Get-WorkbenchWorkflowPolicy owns the exact deliberately narrow JSON/YAML workflow policy. No workflow file, hosted bootstrap, remote enforcement or publication is installed by this capability. Future provisioning is a separately governed dependency, not an implicit download or owner-credential use.

## Transport and CI evidence contract

Observer integrity: Coordinator derives the one event journal, retains valid partial diagnostics but returns UNREADABLE/exit 2 for incomplete required evidence and refuses assignment/closure/dispatch before writes. Technical decisions do not become owner decisions merely by category. Watch-Subagents requires an explicit supported Claude session, masks with the existing library before truncation, exposes missing/unreadable evidence and reports tool-wait cause as UNPROVEN; it never kills, retries or certifies. The optional Watch-Reminder supplies Workbench context only at this root or for an explicit existing Owner-Tools command in that event. Direct-native entry remains independent; archival preserves knowledge separately. These are reporting adapters, not authenticated approval, OS enforcement or a completed general management interface. Reuse one run observer and one shared host observer; report actionable changes immediately and routine long-gate heartbeat at most every five minutes. A late reminder cannot prove earlier live coverage or justify an expensive replay.

Native stage transport: lib/README.md identifies the existing agent adapters and their evidence limits. An explicit exact config selects one native root/contract; raw Draft SHA256 and destination-filtered blob, clean root, native Boot and normal .githooks precede mutation. Preserve native ACTION/WRITE/START_CONTEXT and refusal output. The existing applier Plan owns creation and literal grammar; scope is checked before writes, only declared paths are staged, and Git owns actual authorship. Native applicability is derived by the native engine, never forced to PASS by this adapter. Appends target legal section names, not an assumed section order. Finish, profiles, tests, receipt validation, Review/Complete and binding remain native; no child test schedule is duplicated. The diagnostic reviewer returns non-success for observed failures or unsupported required evidence and cannot auto-certify descriptive criteria. A post-commit diagnostic refusal requires inspecting actual state before any retry. These bounded adapters are not the general P3 management entry and do not inject dependencies into direct-native operation.

Post-allocation identity: native transport compares its selected filtered Draft blob with the unique actual Git allocation before native Boot or writes. A self-consistent replacement config/Draft pair grants no authority. Keep original failed proposal/fixtures as evidence and use a new exact candidate rather than substituting frozen bytes.

Arrival reporting: Pulse consumes one Coordinator Snapshot for owner routing and the queue, preserving that classifier's inherited assignment and explicit Readable state. A category named decision alone is not an owner wait. Missing/failed selected repository or required journal evidence yields visible UNREADABLE and Pulse exit2, never a zero-wait or clean substitute. A readable empty journal, unconfigured upstream or dirty tree retains its actual meaning. These observations grant no write permission, certification or universal liveness guarantee; native Boot and the owning exact contract still decide. test-pulse owns the real Git/journal caller fixtures.

Local CI capability: lib/Workbench.ps1 -CI -Candidate <full-lowercase-HEAD-SHA> -CIRuntimeRoot <new-absolute-external-directory> -Actionlint <verified-external-actionlint.exe> runs the existing timed runner and one concurrent watcher, then the existing tests.ps1 schedule once. It requires a clean independent root, exact candidate, real timed ancestry/observer and recipe binding ordered tests, hazard/helper blobs, evaluator, root, runtime, PowerShell/Git and pinned grammar tool/policy. Its internal -CIWorker is not a raw-entry bypass; absent real timed ancestry/observer refuses. The driver child is the actual direct suite parent; environment stamps alone grant no admission. A terminal RESUME None is permitted only in that CI route. A CI_TEST_ONLY result is not a local certification receipt, approval, native Review/Complete, hosted check or trusted candidate judgment. No CI path writes native working/archive receipts or lifecycle metadata. Equal-OS-privilege tampering remains outside the local trust boundary; independent accepted-code judgment and hosted protection remain separate requirements.

The supported first workflow set is exactly .github/workflows/workbench-acceptance.yml, encoded as the closed JSON subset of YAML returned by Get-WorkbenchWorkflowPolicy. All duplicate/unknown keys, changed branch/triggers, conditions, permissions, action/checkout settings, step commands and missing tests refuse. The upstream actionlint1.7.12 Windows/amd64 executable is pinned by Get-WorkbenchCITool (archive and executable SHA256); supply a verified external copy, never install globally or fetch latest implicitly. Semantic validation and real grammar parsing are both mandatory when a workflow exists; zero workflows is legitimate only for local capability preparation, not hosted parity. The policy contains fixed official-download/archive/binary hash-verified provisioning under RUNNER_TEMP/workbench-tools, followed by the fixed CI entry; this unit creates no workflow or hosted provisioning operation. Native owning CI tests require the pinned external tool through -Actionlint (or WORKBENCH_ACTIONLINT for targeted tests). Future hosted installation must prove its own bootstrap/toolchain/runtime and permission boundaries before freeze. Native CI-profile Finish validates this same grammar/policy before its unchanged owning tests and receipt rules; missing tool or unsupported workflow refuses. WORKSTATION remains blocked. No current private protection, hosted success, release interface or real trusted checkout is asserted. CTRL-19 remains OPEN.
