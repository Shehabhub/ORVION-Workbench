# ORVION recovery — start here after any interruption

This file owns the active Workbench contract pointer and routes to the existing programme checkpoint. For Workbench's
own changes run lib/Workbench.ps1 -Boot and follow WORKFLOW.md. Transcripts and dated HANDOFF snapshots are history;
each product's own Boot remains its authority. This is not a second programme status report.

0. **New to this programme (no history)?** Read [`HANDOFF.md`](HANDOFF.md) once: architecture, boundaries, governance,
   lessons, roadmap, owner decisions and the last verified state with its next actions. Then continue here.
1. **Exact resume point.** Run `pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\lib\Pulse.ps1"`.
   Its `in flight` lines name the active work and that work's own `RESUME.md` (last verified checkpoint, ordered resumable
   steps, evidence, blockers, where to stop for the owner). Cannot run commands? Search `events\events.jsonl` (this folder)
   for `RESUME HERE`; the newest such line names the same file.
2. **Latest session.** Pulse's `last` line names it; every session, newest first, with its raw transcript path:
   `sessions\INDEX.md`. Search them all: `lib\Spider.ps1 '<SPEC id, error, script or phrase>'`.
3. **The programme: one programme, two independent repositories.**
   - Platinum `C:\Users\My Lab\Documents\GitHub\CRM` (PlatPlusHub/CRM) and Founder `C:\Users\My Lab\Documents\GitHub\ORVION`
     (Shehabhub/ORVION). In each: `README.md`, then `AGENTS.md`, then
     `pwsh -NoProfile -File scripts/check_agent_continuity.ps1 -Boot` at its root.
   - The infrastructure programme's order is ADR-0033's Programme sequence (Founder `reports/architecture-decision-records.md`);
     Platinum names it, never copies it.
   - Each repository keeps its own identity, SPEC numbering (the same number names different contracts), contracts,
     receipts, CI, credentials and release. Coordination never merges them: one candidate SHA, one Finish, one exact-SHA
     certification per repository.
4. **Boundaries.** Nothing is approved until the owner approves an exact SHA-256 (Gate 1); Drafts are committed only then.
   Publish and promote are the owner's (`CR_LIFECYCLE.md` §9). Batch 6 is ON HOLD; CTRL-19 is OPEN.
5. **Before any task.** `lib\Events.ps1 -Find '<task in a few words>'`: what earlier agents learned, with the session that holds it.

Active Workbench Contract: changes/WS-004-native-stage-integrity.md
