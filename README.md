# ORVION-Owner-Tools — the one local workspace outside both repositories

Not repository authority. Platinum (`..\CRM`, PlatPlusHub/CRM) and Founder (`..\ORVION`, Shehabhub/ORVION) each decide
through their own Boot, contracts and certification; everything here only drives, observes or preserves them.
**Never put work inside a repository tree**: an ignored sandbox copy there hid 32 broken references from
`check_repository_consistency.ps1` (it indexes ignored files), measured 2026-10-19.

| Folder | What | Git | Backup | Sensitive |
|---|---|---|---|---|
| `lib\` | agent tools; index: `lib\README.md` | no (until the wave-2 tooling contract tracks them) | yes | no |
| `sessions\raw\` | every ORVION agent session, verbatim (Claude Code + Codex) | never | yes, encrypted | **yes** |
| `sessions\index.jsonl` | one line per session: id, title, repo cwd, branch, start/end, size, SPECs, raw path, sha256 | never | yes | low |
| `events\events.jsonl` | improvement memory: what happened, how often, current disposition, evidence pointer | never | yes | low |
| `work\` | evidence, runs, drafts scratch; `work\sandboxes\` = disposable clones | never | yes (not sandboxes) | low |

## Sessions (nothing summarized away)
- `lib\Sync-Sessions.ps1` copies every session of the workspace into `sessions\raw\` at each session start and end
  (user-level Claude hook, ORVION folders only). Append-only: a shrunk source is kept beside, never over, the copy.
  Claude Code deletes its own transcripts after 30 days: everything before 2026-10-11 (e.g. session `cbaf43d9`,
  2026-09-12) was already gone when the archive started on 2026-10-20.
- Find a session: read `sessions\index.jsonl` (title, dates, SPECs). Search content: Grep over `sessions\raw\` (ripgrep
  handles the size; never `grep -o` a wide window, see events `orphaned-search-process`).
- Captured: messages, tool calls and results (large results in `tool-results\`), subagent transcripts, hook context,
  Monitor notifications. **Not captured**: hidden model reasoning (only what the client stores), anything a client
  never writes to disk, Codex sessions started outside the workspace, sessions deleted before 2026-10-20.
  Codex has no session hooks: its sessions are picked up at the next Claude session start or a manual sync.
- `secretHits` in the index counts credential-shaped strings (values never printed). Measured 2026-10-20: 0 real
  credentials in 49 sessions; the only JWTs are the local stack's public `supabase-demo` keys.

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
| `Documents\ORVION-Sandbox` (1.4 GB) | previous tool copy (`lib\`, superseded by this folder), evidence, run configs for SPEC-290..293 | no | legacy (git clones skipped) | its clones | legacy copy |
| `Documents\ORVION-Owner-Tools` | 2026-10-16 owner launchers + logs; `supabase-founder.json` holds URLs only | no | legacy | after the owner retires it | legacy copy |
| `Documents\ORVION-drafts-backup`, `Documents\Windows-Memory-Config` | 2026-10-12 Draft copies; 2026-10-18 WSL memory config | no | legacy | no | legacy copy |
| `%TEMP%\orvion-*` | test leftovers | no | no | yes | — |
| GitHub tokens (`gh`, `%APPDATA%\GitHub CLI`), Supabase CLI login | credentials | never | **never** | — | `gh auth login` for PlatPlusHub and Shehabhub |

Legacy folders move here only after what depends on them is released (owner scripts, Gate 1 packet, run configs):
copy, verify hashes, update references, then retire the old path with the owner's OK.

## Backup to USB, and recovery
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
