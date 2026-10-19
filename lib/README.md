# ORVION agent tools (machine-local, untracked; workspace: ..\README.md)

Proven agent tooling for both repositories. Not repository authority: each repository's own scripts and
contracts decide; these only drive them. Run `Test-ScriptHazards.ps1` on every new scratch `.ps1`.
Planned to be tracked in each repository by the wave-2 tooling contract; until then this folder is the copy
(moved 2026-10-20 from Documents\ORVION-Sandbox\lib, which is superseded).

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

## Known traps (each cost a run)
- `pwsh -WorkingDirectory X -File scripts/y.ps1` runs the CALLER's repo script: always pass an absolute `-File`.
- `git grep` exits 1 for an unreadable blob, exactly as for "no match"; a failed native command reads as empty.
- `$Pid`, `$Host`, `$Input`, `$Matches`... are automatic variables; `Git`/`H`/`R` collide with commands/aliases.
- A one-element pipeline result is a scalar: wrap lists in `@()`.
