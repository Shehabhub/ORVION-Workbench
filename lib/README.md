# ORVION agent tools

The tool index for both repositories: these tools drive each repository's own scripts and contracts and are never
their authority (DEC-08). Run `Test-ScriptHazards.ps1` on every new scratch `.ps1`. Procedures: docs/RUNBOOK.md.

## 1. Data root and the find-and-know tools

Live state: DEC-26. Existing tools before new code: DEC-17. Lessons go to the event journal: WORKSPACE-LAYOUT.md section 10.
These tools are the Workbench agent's own, never a dependency of direct-native product operation.

Data root (one data root everywhere): Events, Spider, Pulse, Coordinator, Delegate, Watch-Subagents, Sync-Sessions,
Backup-Workspace, Hunt `-DataRoot` and the session hook (`hooks\Watch-Reminder.ps1`) default to
`ORVION_DATA_ROOT`, else the checkout's git-ignored `data\` (WORKSPACE-LAYOUT.md section 3.1). Missing data is
unavailable; default writers refuse `ORVION_DATA_ROOT_UNAVAILABLE` unless `data\events\` exists. Pass an explicit root
for tests/hosted use. An environment override must be fully qualified; otherwise `ORVION_DATA_ROOT_NOT_ABSOLUTE`
refuses it. The hook reports on stderr, exits 0, and logs only to an absolute override or an existing `data\events\`.
Hunt `-NoRecord` suppresses events only: `work\hunt-last.txt` remains in the data root.
Readers report `EVENTS_UNAVAILABLE` (exit 3), `EVENTS_INCOMPLETE` (exit 2), or `SPIDER_COVERAGE: incomplete` (exit 3).
Pulse reports a damaged session index as `last UNREADABLE` with exit 2. A missing index prints `last none: no session
index`; it does not itself make Pulse fail when the journal and selected repositories are readable.
Failed process/host discovery prints `running  UNREADABLE` (exit 2). Pulse output is capped at 4096 characters:
diagnostics, counts and pointers first, then owner waits in urgency order, ending with an exact `more` line and a
same-root Coordinator command.
SessionStart waits at most 6 s for Pulse (then kills its process tree and says live state is UNREADABLE) and caps its
context at 8192. It injects `data\work\NOW.md` whole at every start (missing or over 6144 bytes: said so, never cut),
and in a new context (startup, /clear) this tool index and the full Pulse; after compact, resume or fork a pointer to
this index and only Pulse's header, state, waiting and running lines.
Hunt reports malformed or unreadable `sessions\index.jsonl` rows as `BUG index-unreadable` with a count and keeps going.
Hunt's `-Root` stays this checkout (its source and lint scope).
Hunt C2 reads `docs\DECISIONS.md` (`-DecisionsPath`) and, beside it, `history\DECISIONS-ARCHIVE.md` and
`history\DECISIONS-MAP.tsv`: an archive item or mapped D-number that names no existing entry is `BUG decision-dangling`;
unreadable is `BUG decision-record-unreadable`, absent is `GAP decision-record-missing`, `GAP decision-archive-missing` or
`GAP decision-map-missing`. Hunt Quick also runs `Organize.ps1 -Check`: a layout problem is `GAP organize-check` until P7
makes the real layout pass, and a check that cannot finish is `BUG organize-check-failed`.

Hunt C1 (`-DeletionReadiness <inputs.json>`, opt-in) reports deletion and placement readiness only; it never deletes
or authorizes. It scans every line of the declared live and historical files and directories for the deletion and
temporary roots in their usual spellings (absolute, JSON-escaped, slash, `file:///`, `\\?\`, MSYS `//c/`, under
Documents and through the profile variables), classifies each edge LIVE, HISTORICAL or declared HARMLESS, checks the
manifest's identities (paths, bytes, SHA256) and the copies under the declared protected roots, accepted breaks and
live map digests. A live reference into the temporary root fails unless declared HARMLESS or an accepted break. Every
edge goes to `<data>\work\deletion-readiness.json`; `C1 PASS` needs zero failing edges and no unread input, otherwise
`BUG c1-fail` or `BUG c1-incomplete` (exit 1). INCOMPLETE also covers a relative input path, a link inside a declared
or cited directory (never followed), unparsable live JSON, an unreadable copy and a cited path that may go on past a
separator character. Only a complete C1 run closes an earlier C1 finding. Not seen: computed paths, `..\`, 8.3 short
names, `\/` and `\u` JSON escapes, percent-encoded `file:` URIs and root-relative spellings. Its inputs remain
owner-reviewed evidence.

For event evidence, Hunt checks the latest nonempty citation per pattern, ordered by `at` with journal order breaking
ties. Append corrections under the same pattern with corrected `-Evidence`; later empty assignment metadata inherits
that citation, and resolved status alone does not excuse a missing path. `test-sync-sessions-ack.ps1` owns refusal and
concurrency fixtures; `test-ws020-mutants.ps1 -Mutant <id>` runs a direct focused negative probe (`All` runs every mutant).

## 2. Markdown guard

`Test-MarkdownConsistency.ps1 [-Root <checkout>] [-Tree Working|Index|<tree-ish>]` checks the tracked Markdown without
writing or probing an outside path; what it checks: WORKSPACE-LAYOUT.md section 19 and DEC-32. Its `Test-NowMarkdown`
checks the git-ignored NOW.md for its one writer, Save-State.
`test-markdown-consistency.ps1` owns its isolated Git fixtures and causal mutants, and tests.ps1 runs it.

## 3. Workbench's own local cycle

`Workbench.ps1 -Boot` routes own work (read-only); `-Execute` checks the accepted applier's read-only plan before
writes; `-Gate -Staged` and `-Gate -Base <accepted-full-SHA> -Head <full-SHA>` use the
accepted checker and preserve native product independence. `Test-WorkbenchChange.ps1` owns own scope, transitions,
three-pass snapshots, exact local approval/root binding, machine clauses and receipt freshness. `run_timed.ps1` and
`watch_run.ps1` are locally adopted reporting adapters; no product installation is needed. Use absolute script paths
and the own explicit WorkingDirectory for self-Finish. The existing tests.ps1 remains the one full closure schedule.
New context-governed contracts bind the sandbox recipe, roots, relevant environment and versions to original execution.
Use WORKFLOW.md and changes/TEMPLATE.md; original approval records the exact successful sandbox receipt artifact.
Own Finish admits headroom/exclusive context use, invokes Events Find and Hunt Quick NoRecord, and runs that schedule
once with its actual parent/recipe binding. The original always needs its own fresh receipt; historical schema1 records
are preserved. These local controls are not human authentication or protection against equal OS privileges.

Gate judges a range by the specified accepted baseline and every intermediate transition; the hook uses the accepted
checker bytes, never a changed working checker. An initial installation has no checker: its explicit reviewed external
bootstrap and exact digest must be supplied, and absence refuses. Git hooks can be bypassed by an actor with equal OS
privileges, so a separate accepted-baseline range judgment stays required. Tracked local-data roots and
credential-shaped content on changed paths refuse without printing values; the credential check covers the small known
GitHub, API-token and private-key vocabulary of the existing reporter, not every possible secret (DEC-09).
Execute uses the accepted Draft applier and its read-only Plan output: it checks the exact approved Draft identity, the
physical root and every planned target against the scope before the applier can write. The applier still owns literal
parsing, whole-plan preflight, unique anchors, filtered blob verification and race and reparse checks; neither an
unscoped raw applier nor a candidate-modified executor grants authority. Temporary accepted-code materializations live
under WORKBENCH_TEMP_ROOT or TEMP/ORVION-Workbench and are removed by their owning invocation.

`test-workbench-governance.ps1` uses independent real-Git fixtures and short children for dispatch/refusal proofs;
those children are not a replacement for the actual full Workbench tool suite. Failed fixture roots are preserved;
WORKBENCH_TEST_ROOT selects their explicit parent. `workspace-layout.ps1` resolves temporary storage: explicit
WORKBENCH_TEMP_ROOT first, then an explicit restore target, then a containing ORVION-Workbench-temporary, then
the canonical installed checkout's sibling ORVION-Workbench-temporary. Entries set process TEMP and TMP to its
`tmp\` before children start; accepted-code materializations use that root. Broken local layouts refuse
`WB_TEMP_LAYOUT_UNAVAILABLE`. Only RUNNER_TEMP, GITHUB_ACTIONS=true or an explicit ORVION_STANDALONE_TEMP=1
allow system temp for hosted/standalone use. An explicit root must be absolute and outside the checkout.

Local CI: `Workbench.ps1 -CI -Candidate <exact-40-character-lowercase-HEAD> -CIRuntimeRoot <new-external-directory>
-Actionlint <external-pinned-actionlint.exe>` starts the timed runner and one watcher, then the tests.ps1 schedule
once; inspect ci.log, watcher.log, runner.exit, watcher.exit and ci-result.json at that external root. It needs a
clean independent root, the exact candidate, real timed ancestry and observer, and the recipe binding (ordered tests,
hazard and helper blobs, evaluator, root, runtime, PowerShell and Git versions, the pinned grammar tool and policy).
Nonzero exits, omitted owning suites, a changed candidate, recipe or input, an absent observer or a forged suite parent
refuse; never invoke tests.ps1 or `-CIWorker` to bypass the parent. A terminal RESUME None is allowed only on this
route. A CI_TEST_ONLY result is not a certification receipt, an approval, a native Review or Complete, a hosted check
or a trusted judgment, and no CI path writes native receipts or lifecycle metadata.
Get-WorkbenchCITool pins actionlint 1.7.12 for Windows/amd64 (archive and executable SHA256): supply a verified
external copy, never a global install or an implicit latest download. Get-WorkbenchWorkflowPolicy owns the exact
workflow set, `.github/workflows/workbench-acceptance.yml`, as a closed JSON subset of YAML: duplicate or unknown keys,
changed branches, triggers, conditions, permissions, action or checkout settings, step commands and missing tests
refuse. Semantic validation and real grammar parsing are both mandatory when a workflow exists; zero workflows is
legitimate only for local preparation, not hosted parity. Owning CI tests take the pinned tool through `-Actionlint`
(or WORKBENCH_ACTIONLINT for targeted tests); a CI-profile Finish validates the same grammar and policy first, and a
missing tool or unsupported workflow refuses. WORKSTATION stays blocked. Accepted open risks: DEC-05.

## 4. Always, with the Monitor tool (never a hand-written alarm loop)

Codex runs are watched by the orchestrator, or through this checkout's `lib\run_timed.ps1` with `lib\watch_run.ps1` (use absolute paths and the run's explicit WorkingDirectory).

| When | Run under Monitor | Ends by itself |
| --- | --- | --- |
| Any `scripts/run_timed.ps1` run (Finish, a suite) | `pwsh -NoProfile -File <repo>\scripts\watch_run.ps1 -Log <log> -Run finish-control -Brief` (a suite: `-Run control-suite`) | at END or RUNNER GONE |
| Any heavy run, or two at once | one shared `pwsh -NoProfile -File <lib>\Watch-Host.ps1 -WatchPid <owned runner PIDs> -ExitWhenPidsGone` | when the runners exit |
| Explicit Claude background agents | `pwsh -NoProfile -File <lib>\Watch-Subagents.ps1 -Session <exact session ID or absolute directory> -Only <agent IDs>` (or `-SinceStart`) | ALL FINISHED |

`STALLED` proves an unanswered tool wait; its cause remains UNPROVEN. Investigate the owned subject under native
authority before intervention. `UNREADABLE` is missing evidence, never a healthy state. Watch-Subagents requires an
explicit Claude session and refuses ambiguous/unsafe selectors; it does not guess the latest session or parse Codex.
It masks known credential shapes using the existing Sync-Sessions library before truncating any tool diagnostic.
Stalls append one event per transition; `-EventRoot` selects a disposable journal for tests. It never kills or retries.
`COMMIT LOW` and `PRESSURE` are resource evidence; what they allow, and what may run in parallel: DEC-24.
Reuse an existing observer instead of starting a duplicate.
Report state changes, receipts and blockers immediately; routine long-gate heartbeat is at most every five minutes.
Own Workbench Finish uses watcher `-Run workbench-finish`; native product Finish retains `finish-control`. These are
distinct comparable run families in the existing timing history, not new stores or separate monitoring engines.

Claude Code runs this checkout's `lib\hooks\Watch-Reminder.ps1`, a reporting adapter, never enforcement or approval; its sessions/events use the one data root described above.
At the actual Workbench root SessionStart supplies NOW.md, this index and Pulse; a direct-native session receives no Workbench
context. An explicit existing absolute `-File` command inside this Workbench checkout's `lib\` opts in for that event only; mere mentions and
unresolved variables do not. Archival remains separate at session start/end. Native README/AGENTS/Boot and native
tools govern direct entry; neither product acquires an Owner-Tools dependency. No global client setting is changed.
A post-tool reminder cannot prove prior live coverage: attach while the runner is alive; retain any coverage gap
instead of automatically rerunning an expensive test. General management/observer-handle integration remains pending.
These observers are reporting adapters: never authenticated approval, OS enforcement or a general management interface.

## 5. Workspace memory and recovery

| Tool | Purpose |
| --- | --- |
| `Hunt.ps1 [-Quick] [-DeletionReadiness <inputs.json>]` | the hunting dogs: invariants (incl. C2 archive and D-number names, the Organize -Check layout), liveness, versioning, untested tools, planted-bug mutants, lint, opt-in C1 deletion readiness, `GAP guard-probe-stale` when the installed Claude Code differs from the last probed one; every BUG/GAP becomes an event, the last result shows in Pulse |
| `Coordinator.ps1` / `-Brief` / `-Check` / `-Snapshot` / `-Assign` / `-Close` / `-Dispatch` | one event-journal classifier: UNOWNED, OVERDUE, OWNER, DISPATCHED, ACTIVE. Snapshot returns one schema1 object with Readable, Items and the same Brief lines; an incomplete snapshot explicitly has Readable=false. Explicit Owner=owner or Cause=owner-decision routes owner choices; technical decisions can remain ACTIVE. Text consumers retain UNREADABLE/exit 2 and mutation refuses before writes. Explicit empty journal is valid. Hunts/certifies nothing. |
| `Pulse.ps1` | arrival state from actual Git reads and one Coordinator snapshot shared by owner waits and queue. Inherited assignments stay intact; technical decisions are not owner waits. Missing/failed selected Git or journal evidence is UNREADABLE/exit 2; explicit empty journal or genuinely absent upstream is readable. DIRTY is an observation, never write authority. No fetch, test, retry or certification. test-pulse owns the real Git/journal caller fixtures. |
| `Delegate.ps1 -Pattern <id> -Question '...' [-ReadRoots ...]` / `-Report <folder> -Reply <file>` / `-List` / `-CodexBrief <brief> -Clone <temporary\cx\...> -Workstream W<NN> [-ResumeSession <id>] [-OutDir <data/records/new>]` | bounded briefs and their verdict return road; Codex controls, evidence paths and refusals are [in section 6](#6-codex-delegation-controls) |
| `Map-Repos.ps1` / `-Links <path>` / `-Orphans` / `-Check` / `-Install` | Interactive repository map v1 (`-Check` compares the stored maps with a fresh build, writes nothing, and prints `GENERATED STALE: <path>`; the second map is stale by age alone, since it lists live folders): every Git repository under the GitHub folder, tracked files only, Obsidian-style links and backlinks (markdown links, named paths, globs, distinctive names, SPEC/WS/ADR ids, cross-repository) and orphans -> root `ai-map.json` + `ai-map.html` (git-ignored); every run also writes the second map (DEC-06) to `<temporary>\map`: the names in temporary and the data root, no file opened, a Git checkout one row, a link not followed, a missing source `UNAVAILABLE`; `-Install` refreshes hourly and at logon |
| `Watch-Quiet.ps1 -WatchPid <pid> -Path <file or folder> [-QuietMinutes 15]` | the small silent check of one long job, under Monitor (records/WS-033/silent-verification.md): prints nothing while the job runs and keeps writing, then one line, `DONE`, `STALLED` (cause unproven, nothing killed) or `UNREADABLE` |
| `Organize.ps1 -New <path> -Kind <kind> -Purpose '...' -Reader '...'` / `-Move <from> -To <to>` / `-Clean -DryRun` or `-Apply` / `-Clean -ListUncited`, `-Confirmed <tsv>` / `-Clean -Retention -Vault <folder> -DryRun` or `-Apply` / `-Map <tsv> -DryRun` or `-Apply` / `-Refresh` / `-Check [-Quick]` | the one folder tool (WORKSPACE-LAYOUT.md sections 5-8): a managed folder with its organizer, parent refresh and `docs/history/LOG.tsv` row; a move hash-verified, refusing pinned paths, with every reference in an active file updated in the same operation (rolled back whole on failure) and frozen text resolving through the LOG; a clean of section 8's disposable, empty-log, duplicate and owner-confirmed uncited tiers through `remove-owned.ps1`, refusing what an active file names, what is not pushed and a cited file whose bytes are not in the workstream's records (`CLEAN deleted=<n> refused=<n>`); the retention tier, packages beyond the last 7 with their sidecars and raw transcripts past 60 days, each unless an active file names it, logged to `data/work/retention-log.tsv`; organizer tables generated from the children's own headers; layout, names, organizers, parent rows, LOG coverage, path budget, broken links, paths, sections, citations and orphans checked, a missing place `UNAVAILABLE`; `-Check` also reads each data file against `data-schemas.json` (`BAD_TSV`, `BAD_JSON`), proves the committed LOG.tsv a prefix of the working copy (`LOG_REWRITTEN`) and runs every generator's `-Check` (`GENERATED STALE: <path>`); `-Quick` leaves the maps out |
| `Spider.ps1 '<entity or phrase>'` | one question across each repository, the data root (raw transcripts, events, every text file) and temporary (bounded: names, `sb`, `scratch`, each README), live; each hit under its source label `repo`, `data` or `temporary`, a Markdown hit as `path:line section N`; a missing source says `UNAVAILABLE` and exits 3; values masked |
| `Events.ps1 -Find '<task>'` / `-Brief` / `-Add` | improvement memory: relevant past failures, discoveries, decisions; watchers record alarms |
| `Sync-Sessions.ps1` | verbatim archive of every ORVION session + `sessions\index.jsonl` (hook runs it at start and end), a session past retention keeping its row with an empty raw path; explicit `-AcknowledgeErrors -Root <data> -ExpectedSHA256 <hash> -Reason <text>` archives reviewed errors and records their acknowledgement (docs/RUNBOOK.md); `-Check` compares INDEX.md with a fresh page from the index, writes nothing, and prints `GENERATED STALE: <path>` |
| `Backup-Workspace.ps1 -Destination <folder> [-Package] [-Install] [-Status]` / `Restore-Workspace.ps1 -From <backup>` | Selected recovery coverage, explicit daily opt-in and separate application/Scheduler status. After a verified package it runs Organize's retention tier; a failure there is printed and in the status, and never fails the backup. The directory route requires an encrypted drive; the package is unencrypted. [Recovery](../docs/RECOVERY.md#daily-backup-opt-in-and-observation) owns arguments, durable inputs, retention and proof limits. Restore never overwrites. |
| `Restore-ORVION.cmd` / `Restore-ORVION.ps1` | double-click recovery beside the newest package and required .sha256; installs missing Git/7-Zip/pwsh, restores from its own Workbench bundle, runs product preparation, prints manual actions (`..\docs\RECOVERY.md`) |
| `Save-State.ps1 -Operation <op> -Done <text> -Evidence <path> -Next <step> -RunBy <who>` | the one save (DEC-26): NOW.md from its template, checked by `Test-NowMarkdown` before it is written, one line in the workstream's LOG.md, the status page from the plan file (DEC-29), the hash-verified vault continuity copy, then the page line, the SAVED line, the /compact line and the resume message; every parameter in [RUNBOOK.md](../docs/RUNBOOK.md) section 11; `-Check` compares each stored status page with a fresh one, writes nothing, and prints `GENERATED STALE: <path>` |
| `data-schemas.json` | the schemas `Organize -Check` reads: exact header, column count, unique ID, pattern and enum for each TSV; JSON Schema 2020-12 for each JSON and JSONL file (guards.md G05, G06) |
| `hooks\Guard-Write.ps1` | the PreToolUse guard of `.claude/settings.json` on PowerShell and Bash (DEC-28, guards.md G02): a command naming a single-writer file with a write verb exits 2, `GUARD_SINGLE_WRITER`. While a Finish runs (a pwsh running run_timed.ps1 with its finish.log; `-FinishLog` names another log for tests), `Events.ps1 -Add` exits 2, `GUARD_FINISH_JOURNAL`. The names are those of the settings' Edit deny rules (G01). It catches accidents and is no security boundary |
| `hooks\Probe-Guard.ps1` | the repeatable client probe of guards.md G15, which starts headless `claude -p --permission-mode bypassPermissions`. It has never run and no agent launches it: the owner accepted the in-session record instead (2026-11-03, records/WS-033/prototype/s11/guard-session-probe.md), so Hunt keeps `GAP guard-probe-stale` |
| `..\tests.ps1` | sole full closure schedule: hazards plus each owning test suite; only own timed Finish may launch it with the bound recipe. The normal hook checks admission/freshness, not another full run. |

Session appends prove every archived prefix byte by streaming; rewrites retain the old version. Any failed pass emits a
diagnostic even with `-Quiet` and exits 3 (follow remembers earlier failures). Hooks launch detached: success stays
silent, failure status/output belongs to the child and never blocks the hook.
Restore requires a complete hash manifest, including `backup.json`, and refuses absolute or parent paths before
writing. Every repository uses the same config allowlist; auth headers, cookie files, unapproved helpers and helpers
containing literal secrets refuse by key only. Empty helper resets, manager/manager-core/wincred and gh auth
token/git-credential commands (including shell functions) survive for re-login. URL userinfo is stripped from config
keys and values with a key-only warning before any config or origin metadata is saved. Clone/init metadata is
silently omitted; branch upstream entries remain kept.

Sync-Sessions: retained sessions include client-written messages, tool calls and results, attachments, subagents and
hook context; hidden reasoning, unwritten client state and already-deleted sources cannot be recovered. Claude's
retention can remove originals; the archive preserves the retained bytes rather than summarizing them away.
Credential-shaped index findings name rules and locations, never values, and token shapes do not prove live
credentials; review recovery scan findings through [RECOVERY.md](../docs/RECOVERY.md). A recurring pattern is an
investigation candidate, not authority for a task.
Codex archival reads the compact first session-metadata line. Its cwd selector accepts a `Documents\GitHub\CRM`
or `Documents\GitHub\ORVION` prefix, or `ORVION` anywhere in cwd (PowerShell's case-insensitive match). Disposable
Codex clones live under `..\ORVION-Workbench-temporary\cx\<name>` (DEC-20); that parent contains ORVION, so its clones
are selected by the archival cwd rule. Naming a clone does not change its native repository authority.

## 6. Codex delegation controls

`Delegate.ps1 -CodexBrief <absolute brief> -Clone <temporary/cx/clone> -Workstream W<NN>` runs Codex with fixed
engineering controls; the rules it serves: DEC-18 (model and effort), DEC-19 (role, no internet), DEC-20 (launch and
safety) and DEC-21 (briefs and sessions). Ordinary calls need no new approval or isolation flag;
`-IsolatedVerification` only labels evidence. `-Research` is refused before any CLI call (DEC-19): Codex does no
research (DEC-16). The brief follows the template of [docs/RUNBOOK.md](../docs/RUNBOOK.md) section 12, or it is refused.
`-Effort low|medium|high|xhigh` carries the effort of DEC-18, high when omitted.
`-ResumeSession <id>` continues the session the workstream recorded in `sb/W<NN>/codex/session.json`; a second fresh
session, or a resume of another, is refused. A return outside the seven HANDOFF fields in 40 lines exits 6.

Every run is workspace-write under the MXC Windows sandbox, selected by name so it fails rather than falling back; the
writable roots are the clone and the run folder only, passed per run with `-c` and never client-wide, with the temporary
folders left out, command network off, hosted web off and approval never (DEC-19, DEC-20). Inside MXC the default TEMP
can still be the container's own folder, which no check watches, so the brief tells the delegate to set TEMP and TMP to
the run folder (DEC-20). Before the model, the relay
runs `codex sandbox` with those same settings, no model and an empty `CODEX_HOME`: each root must take a write and the
log folder must refuse one, checked by the relay itself and kept in `mxc-probe.json`. Any other outcome is exit 5
(`ORVION_MXC_REFUSED`) with no model call and nothing widened. The sandbox confines writes, not reads, so the
private-read rule is the delegate's to keep and its brief embeds what it needs (DEC-20).

Runs also use ignored user config for exec, a clean child environment, memories off (feature plus use/generation),
multi_agent=false, zero project document bytes and advisory arrival/private-read guidance. Existing memory files remain
untouched. An explicit incompatible family or effort refuses (DEC-18). The fixed [relay](codex-relay.mjs) accepts no
arbitrary configuration override or alternate dispatch. Installed CLI 0.166.0 accepts `--ignore-user-config` under exec
only. No-model feature preflight uses the same working directory and fixed overrides, with a fresh empty task-temporary
`CODEX_HOME` and no exec-only flag; no config and auth are copied, and exec retains its original
environment/authentication home and flag. Temporary feature artifacts stay in scratch. The probe requires
memories/multi_agent false; raw positive/negative diagnostics, status and available errors are retained. This
establishes native feature recognition only: configuration equivalence (including managed/profile/trust loading),
supplemental settings and effective exec settings/tools remain unverified.

Missing/ignored or ambiguous feature states refuse before model dispatch; ignored runtime controls,
unreadable/invalid/empty completed-run events, runtime errors or observed spawning fail with exit 5 and escalation.
Inspection covers root events and native item envelopes, including item.completed/error; structured inventories,
arguments, tool results and report examples are data. All detected failures remain recorded, with observed-spawn
escalation preserved. No spawning experiment is permitted. Exposure alone is recorded separately from observed
creation. Outside-write/unreadable-watch failures retain exit 4 and the existing event; what the tripwire can and
cannot catch: DEC-20. Git watch paths use raw NUL-delimited status for Unicode and rename destinations. The default
watch list is unchanged; nested non-Git edits and create-then-delete can escape detection. Finite event coverage proves
no complete tool visibility. These boundaries remain UNPROVEN by flags, feature lists or a clean run.

`-Family sol` (also `-Model sol`; any other family refuses) selects the numerically latest visible compatible identifier in the
required family from the CLI's existing `models_cache.json`, supporting the requested effort (the family and effort
in force: DEC-18). `-ModelCache <absolute file>` supplies that cache; otherwise only the launcher reads CODEX_HOME
(else USERPROFILE/.codex). This replaces exact-ID selection, with no new registry, live refresh or cross-family
fallback. Delegates receive neither cache nor private paths. The timestamp parser preserves ISO strings on PowerShell
7.6 before checking explicit timezone, age (24h) and future tolerance (5m). Malformed/duplicate/unsafe identifiers,
unsupported effort and CLI/cache mismatch refuse. `launcher.json` retains selected model/effort, cache/relay/input
hashes and explicit UNVERIFIED actual model/effort pending corroboration (DEC-18). Requested argv is not
effective-setting proof.

Default evidence is `<temporary>/codex-relay-logs/W<NN>-<UTC>-codex-<id>`; TEMP/TMP use the scratch run folder of that name. Opt-in
`-OutDir <absolute fresh path>` uses the relay's existing output option, restricted to a strict child of
`<bound Root>/records`, for example a fresh run under `records/WS-026/package/runtime`. Another data root,
source/Git/temp overlap (including Git descendants inside records), session/credential subtrees, traversal, ambiguous
paths, reparse ancestors and collisions refuse. Clone remotes must have disabled push destinations; a clone with no
remotes is also usable. This checks configured targets, not technical prevention of a direct push or config rewrite.
Root is a trusted caller binding, not authentication. Permanent evidence belongs to the launcher. `CODEX_EVIDENCE` returns the
durable destination; launcher.json and SHA256SUMS use CreateNew, and the manifest covers all retained artifacts except itself, including failure evidence. Hashes cannot resist equal OS
privileges or concurrent hostile path replacement. Owning tests bind synthetic cache/CLI/watch/data roots; no fixture
tree belongs in permanent records.

The one helper vendors the supplied MIT upstream amElnagdy/delegate-skills relay at commit
`3aa72d681a79e2a9d09bd9a316353003ae1cb4a7`, retaining its license. The original supports search/output flags but
cannot express required arbitrary configuration overrides through its interface; this local adaptation supplies the
fixed profile, feature preflight and MXC probe, preserving launch/timeout/artifact mechanics. It never rewrites an external relay,
auth or user config. `-Relay` cannot substitute another implementation. [test-delegate.ps1](test-delegate.ps1) owns
synthetic integration/refusals, diagnostic retention and regression cases; these cannot certify installed CLI
behavior; the per-run probe measures confinement on the installed CLI, for that run's settings.

## 7. Contract lifecycle

| Tool | Purpose |
| --- | --- |
| `Invoke-ContractLifecycle.ps1 -Manifest <x>.json -Role Sandbox\|Original -Stage prepare\|allocate\|approve\|implement\|finish\|inspect\|review\|complete\|dryrun` | one lifecycle controller from a small per-workstream manifest, replacing the copied Prepare-*, Stage-*, Run-*Finish, Review-*Finish and Complete-* scripts from WS-034 on. Native Workbench.ps1 and the hash-pinned accepted evaluator keep every authority; `dryrun` walks a finished workstream and writes nothing. |
| `Invoke-ContractStage.ps1 -Config <x>.psd1 -Stage approve\|implement\|review\|complete\|bind` | bounded native transport: exact selected Draft/filter identity, native Boot and normal hooks before transitions; whole applier Plan before writes, declared paths only, actual Git authorship. Native gates remain authority. |
| `Test-ContractReview.ps1 -Config <x>.psd1 [-FinishLog <log>]` | read-only pre-Review diagnostics plus one native range Gate; exit1 observed failure, exit2 UNPROVEN/unsupported evidence, exit0 only for the measured class. Never certifies all descriptive/native criteria or replaces independent Review. |
| `Invoke-DraftSteps.ps1` (dot-source) | turns a sandbox diff into literal Draft steps with blobs |
| `apply-draft-steps.ps1 -Draft <d> -Root <clone>` | proves a Draft's steps reproduce its blobs |
| `Invoke-DraftRehearsal.ps1` | bounded literal/native-entry probes in a disposable clone: deliberately interrupts Finish and uses later sandbox-specific hook/worktree arrangements. Not a complete Finish/lifecycle proof; never transplant its results as original certification. |
| `lifecycle.ps1` (dot-source) | shared helpers, including `Stop-ProcessTreeFully` |

These are the Workbench agent's adapters; direct entry into one product uses that product's own tools only. How to use
them: docs/RUNBOOK.md, "Native product stage transport". A self-consistent replacement config and Draft pair grants no
authority: keep the failed proposal and its fixtures as evidence and use a new exact candidate instead of substituting
frozen bytes. General single- and multi-target management, observer handles, recipe bridging and partial recovery are
not supplied by these adapters. New tools enter through the existing tested governance; this index is discovery only.

## 8. Explicit dual owner operations

`Owner-PublishDual.ps1` and `Owner-PromoteDual.ps1` coordinate the two own tracked owner interfaces.
`Invoke-OwnerDual.ps1` holds their one shared descriptor/result sequence; it does not replace native gates. They need
an interactive owner console and preserve each interface's own confirmation. `-NonInteractive` refuses, and an earlier
release delegation is not reused (DEC-25). Use existing approved owner entrypoints to bootstrap a release until the
tracked interfaces are available on each trusted `main`.

Run one operation with `pwsh -NoProfile -File <lib>/Owner-PublishDual.ps1 -Descriptor <absolute-json-path>
-EvidenceDirectory <absolute-external-directory> -Approval <absolute-operation-approval-json> -ApprovalSha256
<explicit-reviewed-SHA256>`; replace Publish with Promote for promotion. Missing approval refuses. The reviewed
descriptor has exactly `schema: 1` and `targets`, an array of exactly two records. Each record has exactly these fields:

| Field | Value |
| --- | --- |
| `repository` | One `PlatPlusHub/CRM` and one `Shehabhub/ORVION`, each once; their own account routes are checked without requesting a token |
| `candidateRoot` | Explicit absolute original candidate checkout; all four checkout roots must be distinct |
| `trustedRoot` | Explicit absolute clean trusted `main` checkout; no clone, fetch, fast-forward or repair is performed by the coordinator |
| `candidate` | Full lowercase 40-character candidate SHA, already prepared through its own lifecycle |
| `base` | Full lowercase 40-character reviewed main SHA |

`Test-OwnerDualAdmission.ps1` is the one minimum local activation interlock, not full P3 governance. The explicit
per-operation document has exactly `schema`, `operation`, `workbenchRoot`, `workbenchHead`, `workbenchConfigSha256`,
`sourceDraftSha256`, `reviewSha256`, `sourceFiles`, `descriptorSha256`, `evidenceDirectory`, `expiresUtc` and
`configurations`. Use integer schema 1, exact full commit/digest identities, the actual installed clean Workbench root,
UTC expiry in `yyyy-MM-ddTHH:mm:ssZ`, four source entries `{path,sha256}` for the two entrypoints, core and checker,
and four configuration entries `{root,sha256}` for the selected candidate/trusted local Git configs. No token values
belong in the document. The source Draft and independent review digests identify the separately approved
installation/review evidence; they are not owner authentication. There is no auto-approval generator or approval
registry.

The evidence directory must match the explicit approval and be outside all five checkouts, including Workbench. Exact
approval/descriptor bytes, source identities and configuration are checked at admission and again before each side
effect. Duplicate JSON members, stale/modified input, wrong selection and missing tracked source refuse. Both product
targets are checked before either child is invoked. Each child writes its new allowlisted operation record to a unique
target directory; the coordinator validates that record and reads the exact remote ref. A nonzero child, wrong
record, unreadable ref or readable ref mismatch prevents a DONE result. `result.json` preserves per-target results,
exits and the local admission identity. It is operation evidence, never a native receipt or certification.

The operation document is an explicit local operator assertion. A digest, local hook, mutable receipt or console
confirmation cannot authenticate the owner or resist an actor with equal OS privileges. Actual GitHub actor identity
remains UNVERIFIED here; own-account routing is configuration evidence only. Preserve independent native
Gate/CI/trusted judgments; CTRL-19 stays open (DEC-05). Do not infer live release permission from installing this
tool, from a source-contract approval or from a previous release delegation.

After partial success, inspect that result and the refs, then rerun the same reviewed descriptor. An exact
already-completed ref is recorded as `ALREADY_DONE` and its child is skipped; the unfinished target is attempted
normally. No rollback, retry loop or history rewrite occurs. Test with `pwsh -NoProfile -File
<lib>/test-owner-dual.ps1`; its real local Git/child fixtures use explicit console/transport seams and never prove
actual authenticated identity or live release. Preserve the external evidence directory with local backup.
