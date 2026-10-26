# ORVION recovery — start here after any interruption

This file owns the active Workbench contract pointer and routes to the existing programme checkpoint. For Workbench's
own changes run lib/Workbench.ps1 -Boot and follow WORKFLOW.md. Transcripts and dated HANDOFF snapshots are history;
each product's own Boot remains its authority. This is not a second programme status report.

0. **New to this programme (no history)?** Read [`HANDOFF.md`](HANDOFF.md) once: architecture, boundaries, governance,
   lessons, roadmap, owner decisions and the last verified state with its next actions. Then continue here.
1. **Exact resume point.** Run `pwsh -NoProfile -File "C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\lib\Pulse.ps1" -Root "C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools"`.
   Its `in flight` lines name the active work and that work's own `RESUME.md` (last verified checkpoint, ordered resumable
   steps, evidence, blockers, where to stop for the owner). Cannot run commands? Search `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\events\events.jsonl` (the preserved single journal)
   for `RESUME HERE`; the newest such line names the same file.
2. **Latest session.** Pulse's `last` line names it; every session, newest first, with its raw transcript path:
   `C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\sessions\INDEX.md`. Search them all: `lib\Spider.ps1 -Root 'C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools' '<SPEC id, error, script or phrase>'`.
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
   Publish and promote are the owner's (`CR_LIFECYCLE.md` §9). Batch 6 is ON HOLD until the lift record that HANDOFF.md §12 requires; CTRL-19 is OPEN.
   Reinstalling Windows or recovering this workstation: [`docs/RECOVERY.md`](docs/RECOVERY.md) (one unencrypted package in OneDrive, exact steps).
5. **Before any task.** `lib\Events.ps1 -Root 'C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools' -Find '<task in a few words>'`: what earlier agents learned, with the session that holds it.

Source/data transition: this checkout is the selected source, with the existing local accepted hook. The old ORVION-Owner-Tools root remains the ONE event/session data store until separately tested migration. Explicit Root arguments above select it; no journal/working receipt is transplanted here. HANDOFF.md is dated history. This routing does not authorize a native operation or certify restored state.

Active Workbench Contract: changes/WS-020-trustworthy-archiver.md
