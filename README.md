# ORVION Workbench - independent management source

Source repository: https://github.com/Shehabhub/ORVION-Workbench (PUBLIC, measured 2026-10-26: never commit owner records, sessions, approvals or anything secret). Current selected checkout: `C:\Users\My Lab\Documents\GitHub\ORVION-Workbench`, an actual Git root. Local `.githooks` must be configured; cloning alone does not install hooks or recover journals/receipts. Existing native repositories remain independent siblings. Managed sandbox/test/temp/runtime stay outside this checkout under the accepted context.

What belongs in Git: reviewed code/tests/governance, contracts, selected portable plans and minimum safe unique authority/assurance knowledge required for reproducibility or continuation. An essential generated lock can be important; disposable handwritten scratch can be excluded. Secrets, sensitive transcripts and unique ignored working evidence need protected external recovery; Gitignore is not backup. This source-only clone does not restore the whole workstation. Generated local search views and disposable runtime are excluded; native tracked projections retain native authority.

Current plan and layout: [docs/EXECUTION-PLAN.md](docs/EXECUTION-PLAN.md), [docs/WORKSPACE-LAYOUT.md](docs/WORKSPACE-LAYOUT.md). These are the selected canonical source documents after verified WS005 R4 original completion and post-Complete checkpoint cutover. The sole external programme checkpoint owns live progress; prior external plan/layout copies remain history. Do not repeat completed WS005 readiness or cutover. General native management, indexing, consolidated-data cutover, hosted enforcement and clean-Windows recovery remain pending. Old ORVION-Owner-Tools data/archiver is preserved; no parallel blank archive is initialized here.

Stage 3 of the selected plan now requires Workbench-specific GitHub security parity and an independent proposed ORVION-Workbench-trusted-main checkout. These are future acceptance obligations, not activated hosted enforcement or permission to create/configure/publish. See the plan and layout for the exact private-entitlement, trusted-baseline, bootstrap and owner-authorization boundaries.

The remaining dated inventory below is historical context. Prefer the current source plan/checkpoint and actual Boot over its older path/remote/status statements.
**After any interruption, start at [`RESUME.md`](RESUME.md)**: live resume point, latest session, the two repositories, boundaries.

**For Workbench's own changes:** run `pwsh -NoProfile -File lib/Workbench.ps1 -Boot` from this root and follow [WORKFLOW.md](WORKFLOW.md). This initial local kernel supplies own admission/Finish/Review; full product supervision and workstation recovery remain separately governed. A product-only entry continues to use that product's own tools.

## Agent orientation (start here after a reinstall or a new session)

You may be a new Claude Code or Codex session with no memory of earlier work. Everything you need is in these files,
the event journal and the session archive; do not ask the owner to re-explain the project.

1. Where things stand: `RESUME.md` (active contract pointer, Pulse command, boundaries), then `HANDOFF.md` once.
2. Who decides: each repository's own README, AGENTS.md and Boot. Platinum = `..\CRM`, Founder = `..\ORVION`, this
   repository = its own changes only (`lib/Workbench.ps1 -Boot`, `WORKFLOW.md`). Gate 1, publish and promote are the
   owner's unless a recorded owner delegation says otherwise; a delegated decision is labelled delegated.
3. Learn before acting (enforced: own Finish runs `Events -Find` and `Hunt -Quick` itself; do the same by hand first).
   The ONE journal and session archive live in `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools`: pass it as
   `-Root` (below: `<data>`), or the tools read and write an empty store inside this checkout.
   - `lib\Events.ps1 -Root <data> -Find '<task>'` returns what earlier agents learned, with the session that holds it.
   - `lib\Spider.ps1 -Root <data> '<SPEC, error, script or phrase>'` finds the original evidence across sessions, both products'
     files and commits, memory and owner packets.
   - Find a comparable executed contract in the owning repository (`changes/` here, the product's own contract folder
     there) and copy its proven shape, not its repository-specific rules.
   - `lib\Hunt.ps1 -Quick -NoRecord` (from this checkout) for gaps before a change; the full Hunt only when the change is risky. Bounded, not routine.
   - Label each claim PROVEN (cited evidence), HYPOTHESIS (reasoned, unchecked) or UNVERIFIED (assumed).
4. Get help: `lib\Delegate.ps1 -Root <data>` writes a bounded brief for a cold agent. A Codex second opinion is advisory only and
   follows `C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\delegate-review\codex-delegate@3aa72d6\ORVION-USAGE.md`
   (`--ignore-user-config`, a disposable push-disabled clone, no commit, network or gh; you verify every claim). It
   never certifies.
5. Watch, do not poll: `run_timed.ps1` + `watch_run.ps1`, one `Watch-Host.ps1 -ExitWhenPidsGone` for heavy runs,
   `Watch-Subagents.ps1` for background agents (table in `lib\README.md`). Pulse shows the arrival state.
6. Leave knowledge behind: a confirmed lesson becomes an event (`Events.ps1 -Root <data> -Add`), then graduates to its repository
   home through a contract. Long work writes a dated checkpoint that names the next step, and adds a `RESUME HERE`
   event pointing at it.
7. Recovery after reinstalling Windows: [docs/RECOVERY.md](docs/RECOVERY.md).
8. See the whole estate at once (Interactive repository map v1): `lib\Map-Repos.ps1` maps every Git repository under
   the GitHub folder (discovered on each run) into `ai-map.json` and `ai-map.html` in this root (git-ignored, refreshed
   hourly once `-Install` registers its task). `-Links <path>` prints a file's links and backlinks; `-Orphans` lists
   files nothing links to: link a new file from where it belongs so it is never orphaned. A derived view, never authority.

Not repository authority. Platinum (`..\CRM`, PlatPlusHub/CRM) and Founder (`..\ORVION`, Shehabhub/ORVION) each decide
through their own Boot, contracts and certification; everything here only drives, observes or preserves them.
**Never put work inside a repository tree**: an ignored sandbox copy there hid 32 broken references from
`check_repository_consistency.ps1` (it indexes ignored files), measured 2026-10-19.

| Folder | What | Git | Backup | Sensitive |
|---|---|---|---|---|
| `lib\`, `tests.ps1` | agent tools (index: `lib\README.md`) and their checks | local Git repo (no remote yet) | yes | no |
| `sessions\raw\` | every ORVION agent session, verbatim (Claude Code + Codex) | never | yes (package, unencrypted by owner decision) | **yes** |
| `sessions\index.jsonl` | one line per session: id, title, repo cwd, branch, start/end, size, SPECs, raw path, sha256 | never | yes | low |
| `events\events.jsonl` | improvement memory: what happened, how often, current disposition, evidence pointer | never | yes | low |
| `work\` | evidence, runs, drafts scratch; `work\sandboxes\` = disposable clones | never | yes (not sandboxes) | low |

## Sessions (nothing summarized away)
- `lib\Sync-Sessions.ps1 -Follow` (started by the session-start hook, one instance) copies every session of the workspace
  into `sessions\raw\` once a minute while any Claude Code or Codex process runs, then a last pass when all are gone;
  no session depends on its shutdown hook. Only complete lines are appended, after the archived bytes are proven to be
  a prefix of the source; a killed pass is completed by the next one; a rewritten source keeps the old copy beside it.
  Measured 2026-10-20: about 1 s and 1 s CPU per pass including PowerShell start, 0 bytes lost in the self-check cases.
  Claude Code deletes its own transcripts after 30 days: everything before 2026-10-11 (e.g. session `cbaf43d9`,
  2026-09-12) was already gone when the archive started on 2026-10-20.
- Find a session: read `sessions\INDEX.md` (newest first: task, minutes, prompts, tools, errors, compactions, agents,
  events, most-discussed SPECs, raw path) or `sessions\index.jsonl`; `lib\Events.ps1 -Find` links each lesson to its session. Search content: Grep over `sessions\raw\` (ripgrep
  handles the size; never `grep -o` a wide window, see events `orphaned-search-process`).
- Captured: messages, tool calls and results (large results in `tool-results\`), subagent transcripts, hook context,
  Monitor notifications. **Not captured**: hidden model reasoning (only what the client stores), anything a client
  never writes to disk, Codex sessions started outside the workspace, sessions deleted before 2026-10-20.
  Codex has no session hooks: its sessions are picked up at the next Claude session start or a manual sync.
- `secretHits` / `secretNames` in the index flag credential-shaped strings by name (values never printed or stored).
  Measured 2026-10-20 across 49 sessions: one real secret, `CLAUDE_CODE_MESSAGING_TOKEN` in session 84ee17dc (a
  per-session local pipe token, live only while that session runs); every other hit is the local Supabase stack's
  published defaults or code. The raw history stays verbatim (integrity); protection is: never in Git, and the
  recovery package reports secret findings by name (`docs/RECOVERY.md`); BitLocker on C: stays an owner action.

## Improvement memory
`lib\Events.ps1 -Brief` (printed at session start) lists open or recurring patterns; `-Find '<task>'` returns the few
relevant to a task; `-Add` records one. Watch-Subagents (STALLED) and Watch-Host (COMMIT LOW) record their alarms
themselves. A pattern recurring across sessions is an investigation candidate, not a task. A confirmed lesson
graduates to its repository home (or Claude memory) through the normal lifecycle; this log is never authority.

## Inventory (measured 2026-10-20)
| Location | Purpose | Tracked | Backup | Disposable | Restore |
|---|---|---|---|---|---|
| `..\CRM`, `..\ORVION` | the repositories; ignored receipts `.orvion-local-certification.json`, `.orvion-certifications\`, `.claude\settings*.json`; **unpushed candidates and `orvion/*-pending` branches exist only here** | yes + ignored state | bundle (all refs) + ignored files + local config | no | `Restore-Workspace.ps1` |
| `..\CRM-trusted-main`, `..\ORVION-trusted-main` | trusted clones the owner promotes from; per-account credential pin in local config | yes | bundle + config | no | same |
| this folder | tools, sessions, events, work | no | yes | `work\sandboxes` only | same |
| `~\.claude\projects\*ORVION/CRM*\memory`, `~\.claude\settings.json`, `statusline.ps1` | Claude memory and hooks | no | yes | no | same (never overwrites) |
| `~\.codex\sessions` | Codex transcripts | no | via `sessions\raw` | no | archive copy |
| `Documents\ORVION-Owner-Review` (1.4 GB) | owner packets; **live**: `cr-da-execution-2026-10-19\owner-publish/promote.ps1`, `wave1-2026-10-19\GATE-1-PACKET.md` | no | legacy | no | legacy copy |
| `Documents\ORVION-Sandbox` (1.4 GB) | evidence, sandboxes and run configs for SPEC-290..293 (its old `lib\` copy was deleted 2026-10-20 after every script was repointed here) | no | legacy (git clones skipped) | its clones | legacy copy |
| `Documents\ORVION-Owner-Tools` | the owner's **working** Platinum release adapters (`Owner-Publish/Promote.ps1`, used 2026-10-18) + logs; its README explains; same name as this folder by history only | no | legacy | no: merged by the wave-2 release interface | legacy copy |
| `Documents\ORVION-drafts-backup`, `Documents\Windows-Memory-Config` | 2026-10-12 Draft copies; 2026-10-18 WSL memory config | no | legacy | no | legacy copy |
| `%TEMP%\orvion-*` | test leftovers | no | no | yes | — |
| GitHub tokens (`gh`, `%APPDATA%\GitHub CLI`), Supabase CLI login | credentials | never | **never** | — | `gh auth login` for PlatPlusHub and Shehabhub |

Legacy folders move here only after what depends on them is released (owner scripts, Gate 1 packet, run configs):
copy, verify hashes, update references, then retire the old path with the owner's OK.

## Backup to USB, and recovery
Reinstalling Windows: use [docs/RECOVERY.md](docs/RECOVERY.md) (one selective package in OneDrive). The USB folder
backup below remains available:
1. Turn on BitLocker To Go for the stick (the system drive C: was measured unencrypted, 2026-10-20).
2. `pwsh -NoProfile -File "<this folder>\lib\Backup-Workspace.ps1" -Destination E:\` → `orvion-backup-<UTC>\` with `SHA256SUMS.txt`.
   Refuses an unencrypted drive; reports a dirty checkout (uncommitted work is not in a bundle).
3. New machine: install Git, PowerShell 7, gh, Docker/WSL, Supabase CLI per each repository's `README.md`, then
   `pwsh -NoProfile -File E:\orvion-backup-<UTC>\owner-tools\lib\Restore-Workspace.ps1 -From E:\orvion-backup-<UTC>`.
   Verifies every hash first, never overwrites, and restores refs, HEAD, local config, receipts, workspace and memory.
4. `gh auth login` for both accounts, then Boot in each repository.

Proof level (2026-10-20): **Simulated** — backup → restore into an empty location → all 4 repositories at their exact
SHAs with identical refs, clean trees, byte-identical receipts and bound records, and Boot output identical to the
originals (`ORVION: READY`) apart from timings. Corrupt-backup and existing-target refusals tested. Not yet
**clean-install proven** (needs Windows Sandbox or a VM: owner action).
