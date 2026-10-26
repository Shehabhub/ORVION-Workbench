# ORVION programme handoff — for a new agent with no history (Claude Code or Codex)

Written 2026-10-20 by the closing session (Claude Code, session `84ee17dc`). Read top to bottom once; it takes ~10 min.
Live state always wins over this file: run `lib\Pulse.ps1` and each repository's Boot (§3). Section 4 is a dated
snapshot and names the record that is authoritative for each fact.

## 1. Architecture and purpose
- **ORVION** is a travel CRM / operations / revenue platform for Egyptian travel agencies (flights, Umrah, Hajj, visa,
  hotels, tours): Supabase/PostgreSQL, SQL migrations + `app`-schema RPCs. The commercial roadmap is each repository's
  Phase 8 / **Batch 6**, ON HOLD by owner decision (2026-10-18) until the infrastructure programme closes.
- The **infrastructure programme** (now) makes the repositories self-governing and safe for any agent: a Gate that
  judges every Change Request (CR) transition, exact-SHA certification, trusted publication/promotion, recovery.
- **ORVION-Workbench** (this folder, source remote `Shehabhub/ORVION-Workbench`, `workbench-preflight` then `main`) is the owner's external execution and coordination layer:
  agent tools and combined (two-repository) work; the session archive and event journal use one data root: `ORVION_DATA_ROOT`, else sibling `ORVION-Owner-Tools` when it has `events\`, else this checkout. It is never repository
  authority and never a dependency of either repository.

## 2. Repository identities and boundaries (owner rule, 2026-10-20: strict independence)
| | Platinum | Founder |
|---|---|---|
| Checkout | `C:\Users\My Lab\Documents\GitHub\CRM` | `C:\Users\My Lab\Documents\GitHub\ORVION` |
| GitHub / account | `PlatPlusHub/CRM` / PlatPlusHub | `Shehabhub/ORVION` / Shehabhub |
| Hosted Supabase | Primary `vrvtsxexkiiiivlkdxzp` | `brplkqmbzffpxqgkkdzo` |
| Trusted clone (owner promotes from it) | `...\GitHub\CRM-trusted-main` | `...\GitHub\ORVION-trusted-main` |
- Neither repository may name the other, this workspace, or cross-repository facts: no README, AGENTS.md, Boot,
  manifest, GOVERNANCE pin or ADR text. Each keeps its own SPEC numbering (the same number names different contracts),
  receipts, CI, credentials and release. Combined operations live only here. "One coordinated programme when
  requested. Two fully independent repositories by design." A repository README that does not lead here is correct.
- Every repository works alone; workspace tools are optional helpers. Say where each change lands.

## 3. Entry points (verified 2026-10-20)
1. Combined work: `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\README.md` -> `RESUME.md` -> this file.
2. Platinum only: `C:\Users\My Lab\Documents\GitHub\CRM\README.md`, then `AGENTS.md`, then
   `pwsh -NoProfile -File scripts/check_agent_continuity.ps1 -Boot` at that root.
3. Founder only: the same three in `C:\Users\My Lab\Documents\GitHub\ORVION`.
Active task record (live checkpoint, ordered steps): `C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\20261020-wave1-v3\RESUME.md`.

## 4. Current authoritative state (snapshot 2026-10-20 ~17:55 local; verify before acting)
Authoritative live sources: each repository's Boot and `git`; `lib\Pulse.ps1`; the task record
`Documents\ORVION-Sandbox\evidence\20261020-wave1-v3\RESUME.md` (last checkpoint); the Gate 1 packet's `SHA256SUMS.txt`.
- **Repositories (verified)**: Platinum `CRM` main = origin/main = `94e7a39e6da7ac553842d2d2954cae38a574d45b` (SPEC-290),
  clean; Founder `ORVION` main = origin/main = `434180cc273e6a73423a48a3a00b77a9fdc379aa` (SPEC-292), clean; both
  trusted clones at the same SHAs, clean. Receipts: `.orvion-local-certification.json` (cr SPEC-290 / SPEC-292) and
  `.orvion-certifications\` in each checkout. Leftover released branches (harmless, do not delete without the owner):
  Platinum `orvion/spec-284-pending`, `-285-`, `-290-`; Founder `orvion/spec-292-pending`.
- **Contract A — FROZEN, AT GATE 1, NOT APPROVED, NOT IN EITHER REPOSITORY.** Packet
  `C:\Users\My Lab\Documents\ORVION-Owner-Review\SPEC-291-293-wave1\` (start at `GATE-1.md`; 49 files, `SHA256SUMS.txt`):
  | Repository | Contract | Draft SHA-256 | Git blob |
  |---|---|---|---|
  | Platinum | SPEC-291 | `5C94E1324730FB4A99AC8D86FA1A2C36D7335338FA98E0B455E2D8B435DF6FBE` | `3a007e12f8a4cf395845cb044e17a5681de677f8` |
  | Founder | SPEC-293 | `54BF9EE345D3CF88809ABAB1E4A3107BD5C2CCE7C18BD378828F5C21208F8C3C` | `40fb06902aa55c3c7945450067deed82f7c0ff62` |
  Same 6 files per repository (`scripts/check_agent_continuity.ps1`, `test_agent_continuity.ps1`, `github_public_read.ps1`,
  `test_github_public_read.ps1`, `watch_ci.ps1`, `CR_LIFECYCLE.md`); no cross-repository text (checked by the generator
  and two independent reviews). Evidence on the exact final bytes (all in the packet): control suite 595/595 both;
  reader 86/86 both; receipts 71/71; watcher self-test 62/62; consistency CLEAN; STORE negatives (unguarded fails
  OS1-3, OSM1-2); Certify negatives (unpatched fails 108c, INH-1u); watcher-wait negatives (pt 1.0 s, fd 1.5 s);
  byte check 12/12; lifecycle rehearsal PASSED both (`evidence\rehearsal\`); dress rehearsal of the batch with the real
  executor and the packet's configs PASSED (`ORVION-Sandbox\evidence\20261020-wave1-v3\dress-final\`); independent
  reviews CONFIRMED (`evidence\independent-review-REPORT.md`, `evidence\independent-final-review-REPORT.md`).
  Known limitation approved with it (Notes): a pause loop with no total bound (never a wrong verdict) -> contract B.
- **Never use**: the 2026-10-19 packet `Owner-Review\wave1-2026-10-19` (SUPERSEDED, never approved), any Draft under
  `wave1-v3\drafts\superseded-*`, `drafts-dry\`, `drafts-a\` (dry), `review-a*\` copies; generators `make-drafts.ps1`,
  `make-drafts.merged.ps1`, `apply-routing.ps1`, `apply-adr.ps1` (pre-independence).
- **Sandboxes** (disposable, push DISABLED): `ORVION-Sandbox\evidence\20261019-objstore\pt` and `\fd` hold the tested
  edits uncommitted; `rebuild-a.ps1` rebuilds them. Nothing is running. Open owner items: Gate 1 for contract A,
  BitLocker, workspace remote, Shared Evidence earn-or-waive, MCP prune / GitHub MCP, CTRL-19.

## 5. Completed work (precise states)
RELEASED = implemented, locally certified (Finish), published, promoted to `main`, `REMOTE_CERTIFY: READY`:
- History restoration; Founder operational independence (Founder SPEC-289 `794a6db`); basic Platinum-to-Founder sync
  (Platinum SPEC-286 `4a22aa5`; defects Platinum SPEC-287 / Founder SPEC-290); CR B GitHub Actions hardening
  (Platinum SPEC-289 `b091f0f`, Founder SPEC-291 `b1d996f`); CR C Three-Pass Draft Assurance + run cost reporting
  (Platinum SPEC-290 `94e7a39`, Founder SPEC-292 `434180c`, released 2026-10-20 with the owner's one-time approval).
PREPARED, NOT APPROVED: contract A (§4). Workspace tools: implemented and tested here (`tests.ps1`), not in any repository.

## 6. Remaining roadmap (ADR-0033 Programme sequence, Founder `reports/architecture-decision-records.md`; consolidated by the owner)
1. **Contract A** — "a read that cannot finish is never a verdict" (object-store/shallow guard + shared GitHub read
   budget, `REMOTE_CERTIFY: UNREADABLE`). Platinum SPEC-291 / Founder SPEC-293. **At Gate 1** (§4, §7).
2. **Contract B** — release interface (4 Publish/Promote launchers + 2 external dual coordinators), the agent tools
   tracked INSIDE each repository and named by its own Boot/AGENTS.md (no pointer here or to the other repository),
   `watch_run` fixes (late attach floods; ETA from test counts; `UNREADABLE` in its verdict words), the fail-closed
   reads remainder (`Git-State` treats a failed `rev-list --count` as 0; `Base-HasId` failures read as "free"), and
   contract A's recorded follow-ups (its Notes): a total deadline for `Wait-OrvionPublicSlot` pauses, a permanent
   `origin` misconfiguration reading `UNREADABLE`. Not drafted.
3. **Shared Evidence + Independent Native Finish optimization** — not earned; waived by the owner as a closure
   prerequisite on 2026-10-26 (a future CR may still earn it).
4. **Contract C** — split on 2026-10-26 (§12): C1 written closure criteria + selective package + same-machine
   isolated restore (WS-015); C2 clean-Windows recovery, performed by the owner's planned reinstallation
   (`docs/RECOVERY.md`).
5. Infrastructure closure (§12), then unchanged Phase 8 / Batch 6 and the commercial programme, each under its own CR.

## 7. Immediate next actions (in order)
1. Orient (read-only): `pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\lib\Pulse.ps1"`;
   Boot in each repository; confirm §4's SHAs and that `Get-FileHash` of both packet Drafts equals the table.
2. **Wait for the owner's Gate 1.** Do not approve for them. The message they send is in `GATE-1.md` ("To approve").
   If they ask questions, answer from the packet; do not re-run suites, rehearsals or reviews (all on these exact bytes).
3. After an approval that names BOTH exact digests: follow `PKT\exec\RUNBOOK.md` steps 2-13 exactly
   (`preflight-a.ps1 -Before approve` -> `LIB\Invoke-ContractStage.ps1 -Config PKT\exec\<pt|fd>.psd1 -Stage approve`,
   `implement` -> Finish through `run_timed.ps1` + `watch_run.ps1` (memory: two together need >= 5.2 GB) -> Review ->
   Complete -> Bind -> `make-owner-scripts-a.ps1` -> owner publishes -> one CI watcher at a time -> owner promotes ->
   `-Certify` -> closure). An approval naming only one digest: run that repository alone (the configs are separate).
4. Never: regenerate or edit a frozen Draft (it changes the digest); approve, publish or promote without the owner;
   commit a Draft before approval; restart a killed heavy run without the owner's OK; run two CI watchers at once
   before contract A is on `main`; touch Batch 6.
5. After contract A is RELEASED: draft contract B (§6) from a sandbox prototype, same method (§8), its own Gate 1.

## 8. Governance (each repository's `ENGINEERING_METHOD.md`, `CR_LIFECYCLE.md`, `AGENTS.md`, `GOVERNANCE.md`)
- **CR lifecycle**: Draft -> (Gate 1: the owner approves the exact SHA-256 of the frozen Draft) -> allocate + Approve
  commits -> implement the Draft's literal steps -> **Finish** (`-Finish`, only through `scripts/run_timed.ps1`, watched by
  `scripts/watch_run.ps1`; writes the local receipt `LOCAL_CERTIFY: READY`) -> independent **Review** (live Git, not the
  log) -> Complete -> `-Gate -BindCandidate` (bound record) -> owner **publish** to `orvion-preflight` -> exact-SHA CI ->
  owner **promote** from the trusted clone (`promote_main.ps1`, `-Gate -Trusted` judges with an evaluator outside the
  candidate) -> `-Certify` (`REMOTE_CERTIFY: READY`). Publish/promote are the owner's (`CR_LIFECYCLE.md` §9).
- **CAG** (admission): one definition of transitions, judged by the hook at HEAD and by CI at every commit of a range.
  **ACI**: changing a GOVERNANCE §6 pin is an authority change with a Gate-found consumer closure.
  **SACI** (stale authority): a pinned line keeps its ratified text in every state. **PICF** (completion feasibility):
  `check:` clauses on Acceptance Criteria are judged feasible at Approval and must hold at Complete (locally and in CI).
- **Three-Pass Draft Assurance**: every Draft records `Pass 1 Design`, `Pass 2 Adversarial Review`, `Pass 3 Evidence
  Refresh` (dated) and `Selected Version`; the Gate refuses a missing/duplicate/undated record.
- Drafts are committed only at approval; never write an unallocated SPEC id in a tracked file (it reserves the number);
  a blocked checkpoint is never committed; reading is unrestricted, writing needs an active approved CR's Write Scope.
- Before freezing: sandbox + prototype in a disposable clone, then a full lifecycle rehearsal
  (`lib\Invoke-DraftRehearsal.ps1`), byte check (tested blob == step blob), independent review (`lib\Delegate.ps1`).

## 9. Execution lessons (each cost a run; the full journal: `lib\Events.ps1 -Find '<task>'`)
- **Learn before guessing**: a first diagnosis is a hypothesis until measured (2026-10-20: "gc.auto" was wrong; Git 2.54
  automatic *maintenance* packed fixture objects; fixed with `gc.auto 0` + `maintenance.auto false`).
- PowerShell double-quoted text turns `` `r `` / `` `t `` into control bytes and drops other backticks: write Markdown
  code as ` ``x`` ` there; the Gate refuses U+000D (`PROHIBITED_CHARACTER`). The Draft generator now refuses control bytes.
- Generated Draft steps must match how `apply-draft-steps.ps1` applies them (substring matching; deletions with
  context; a final newline) — `lib\test-draft-steps.ps1` covers it. Always rehearse before freezing.
- A failed native command reads as empty (`if(git status)` on error = "clean"): use throwing wrappers.
- `pwsh -WorkingDirectory X -File rel.ps1` runs the caller's script: absolute `-File` paths. .NET file APIs ignore the
  PowerShell location. `git config` in a worktree edits the main repo. Helper names must not shadow commands/aliases.
- **Resources**: a control suite ~42 min; a Finish 45-70 min (two in parallel need >= 5.2 GB free; at 3 GB it pages).
  Claude Code's low-memory reaper killed two suites at 7 min once: restart only with the owner's OK. Avoid starting a
  Finish 12:15-12:30 local (a future-date test straddles 10:00 UTC).
- **GitHub API quota**: anonymous 60 requests/hour per IP, shared by every watcher; a 304 still costs 1;
  `/rate_limit` is free. Two 30 s watchers exhausted it in 15 min and `-Certify` printed FAILED while CI was green.
  Until contract A is on `main`: ONE watcher at a time, `-PollSeconds 120`. Exit 2 = unreadable, never "failed".
- Background agents stall on unseen permission prompts: read-only delegates use Read/Grep/Glob only; watch every
  background agent and every timed run under Monitor (`Watch-Subagents`, `watch_run`, `Watch-Host`).
- Never run unguarded old code as a causal negative without reading its top level (it once ran real winget/npm).

## 10. Coordinator and continuity (all in `lib\`, index `lib\README.md`)
- **Pulse** (`Pulse.ps1`): the live state an arriving agent sees first (repos, pending candidates, running runs, host,
  owner waits, last session, coordinator queue, in-flight work and its RESUME). Printed at Claude session start.
- **Lion King** = `Coordinator.ps1`: reads the one journal, holds every open item to an owner, next action and due time
  (TRIAGE/OVERDUE/OWNER/DISPATCHED/READY); closes nothing without a recorded reason.
- **Spider** = `Spider.ps1 '<phrase>'`: one question across sessions, events, both repositories, memory and packets.
- **Dogs** = `Hunt.ps1`: invariants, liveness, untested tools, planted-bug mutants; every BUG/GAP becomes an event.
- **Birds** = the watchers: `watch_run` (in each repository; one timed run), `Watch-Host` (memory), `Watch-Subagents`
  (background agents STALLED/FINISHED).
- **Journal**: `events\events.jsonl` under the one data root above via `Events.ps1 -Add/-Find/-Brief`; **delegation**: `Delegate.ps1` (brief ->
  report -> verdict event). **Sessions**: `sessions\raw\` verbatim (Claude + Codex; sensitive: token shapes
  noted in `docs/RECOVERY.md`), `sessions\INDEX.md` under that same data root, kept by `Sync-Sessions.ps1`, started by Claude Code running this checkout's `lib\hooks\Watch-Reminder.ps1`. **Backup**: `Backup-Workspace.ps1 -Package`
  (one selective archive in OneDrive, unencrypted by owner decision; reinstall and restore steps: `docs\RECOVERY.md`).
  Recover the latest verified state: Pulse -> its `in flight` line -> that task's RESUME.md.
- Codex does not read Claude hooks or memory: it starts from §3 and this file. Claude memory
  (`C:\Users\My Lab\.claude\projects\C--Users-My-Lab-Documents-GitHub-CRM\memory\MEMORY.md`) is a convenience copy.

## 11. Owner decisions
- **Approved and used**: everything in §5; the one-time publish/promote approval for SPEC-290/292 ("only this time").
- **Requires the owner**: Gate 1 for each frozen Draft (exact SHA-256; both digests may come in one message); publish;
  promote; any GitHub setting; any credential; deleting anything outside disposable preparation; restarting a heavy
  run the host killed; what to do with secret-scan findings in the recovery package (`docs\RECOVERY.md`); the open
  decisions: BitLocker on C:,
  MCP prune / GitHub MCP. Decided 2026-10-26: Shared Evidence waived as a closure prerequisite; CTRL-19 dispositioned
  OPEN with its residual risk accepted (below).
- **ON HOLD**: Batch 6 (both repositories) and the Phase 8 remainder, until the §12 lift record. **OPEN**: CTRL-19 (both
  `gh` tokens are reachable by this OS user; `main` protection depends on GitHub configuration the repositories cannot
  set); residual risk accepted by the owner, not closed.
- **Forbidden without authorization**: production/hosted writes, credential exposure, history rewriting, publishing,
  promoting, modifying protected repository files outside an approved contract, cross-repository references.
- Owner working rules: verify every request is sound and worth it, state the verdict in one line; learn before
  guessing; earn it, worth it, simplify without weakening; record every confirmed own mistake as an event.

## Startup message (owner: paste into a fresh Claude Code or Codex session)
```
You are continuing the ORVION infrastructure programme with no prior history. Work only from files and live commands.
Read in order: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\README.md, then RESUME.md, then HANDOFF.md in that
folder. Run: pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\lib\Pulse.ps1"
Then report to me: the verified current state, the next owner decision required, and the first safe action.
Until I authorize it: do not approve, implement, run Finish, publish or promote; do not edit either repository or any
frozen Draft; keep Platinum (CRM) and Founder (ORVION) independent. Before any task I give, check it is sound and
worth doing and state that verdict in one line.
```

## 12. Success criteria before the programme closes and Batch 6 resumes
Amended 2026-10-26 under the owner's exceptional delegation (its text and SHA-256 are recorded in WS-015). These are the
written closure criteria (contract C1); each needs recorded evidence, none is inferred:
1. Contracts A and B RELEASED in both repositories (published, promoted, `REMOTE_CERTIFY: READY`). Done before WS-015.
2. C1: WS-015 released (`Backup-Workspace -Package`/`Restore-Workspace -Package`), one real package made and its
   OneDrive copy verified by a cloud re-download, and its same-machine isolated restore into new empty roots verified (SHA256SUMS, exact refs/HEAD, and each restored
   repository's Boot printing its expected READY result). C1 is not a clean-machine proof. The package is NOT
   encrypted: the owner decided on 2026-10-26 that an unencrypted compressed archive in OneDrive replaces the earlier
   "encrypted backup" condition; secrets are reported by name (rule, file, line) by the package's scan, never claimed absent.
3. Founder ADR-0033 amended through a native Founder CR and released, so Founder's Boot routes to Batch 6 like Platinum's;
   a cold-start agent in each repository reaches that next action from its README/Boot alone.
4. Shared Evidence: waived as a closure prerequisite (not earned). CTRL-19: OPEN, residual risk accepted by the owner.
   Workbench Stages 2-7 / P3 management are not Batch 6 prerequisites.
5. C2, amended by the owner 2026-10-27 (no Windows reinstallation): C1 on package
   orvion-backup-20261026T201821Z.7z (SHA256 BC28B482F6E101D40D3DD2E9DA5690C122589350804F64FE59BC612D8E9F0203; cloud
   re-download matched; isolated restore; CRM, ORVION and Workbench Boots READY), plus one isolated run of the released
   `lib/Restore-ORVION.cmd` launcher against a fresh package. Clean-machine tool installation stays UNPROVEN: residual risk accepted by the owner.
The hold is lifted by one recorded lift decision that cites the evidence of 1-5; each product's Boot then owns Batch 6.
