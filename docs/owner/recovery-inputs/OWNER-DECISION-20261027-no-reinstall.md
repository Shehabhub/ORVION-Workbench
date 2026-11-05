# Owner decision, 2026-10-27 (~00:15 Cairo): no Windows reinstall; amend lift criterion 5

## Owner's request (written in Arabic, paraphrased in English)
Instead of reinstalling Windows, delete only the ORVION-related folders outside C:\Users\My Lab\Documents\GitHub, then re-download and re-prepare them. Never touch the GitHub folder.

## Orchestrator's assessment, given to the owner
- Deleting the ORVION folders outside GitHub and restoring them would prove nothing new, because the isolated restore that passed tonight already restored all 6 legacy folders. It could also lose work done after the 20:18Z package.
- Inventory, measured read-only:
  - Owner-Review: 1.57 GB, the live state and evidence;
  - Sandbox: 2.77 GB of evidence;
  - old Codex clones: about 120 MB, some holding out/ folders not in any package;
  - test temp leftovers: about 150 MB;
  - free disk: 218 GB.
  None of it is worth deleting.
- The question put to the owner: is the reinstall needed for its own sake, or mainly as the recovery proof? Skipping it requires changing HANDOFF §12 criterion 5 ("C2: the owner's planned Windows reinstallation"), which only the owner can do.

## Owner's answer (selected option, verbatim)
"Skip reinstall (Recommended)": no Windows reinstall. The owner records that criterion 5 is met by C1 (passed tonight) plus a test of the double-click restore file once it is built. What stays unproven is installing tools on a bare Windows, which only matters if the machine is ever really lost.

## Effect
- The Windows reinstall is CANCELLED. No ORVION folders are deleted.
- Criterion 5 becomes: C1 on package orvion-backup-20261026T201821Z.7z (SHA256 BC28B482F6E101D40D3DD2E9DA5690C122589350804F64FE59BC612D8E9F0203; cloud re-download matched; isolated restore 212 s; CRM, ORVION and Workbench Boots READY, 2026-10-27), PLUS an isolated run of the released WS-023 Restore-ORVION.cmd against a fresh package.
  - Clean-machine tool installation stays UNPROVEN; the owner accepts it as residual risk.
- The HANDOFF.md §12 text change goes into WS-023 scope.
- This is NOT the lift decision. The hold stays ON until the owner records one lift decision citing criteria 1-5. CTRL-19 stays OPEN.
