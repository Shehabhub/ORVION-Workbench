# ORVION programme closure and evidence boundaries

Updated 2026-10-27. Live operation state is external; [RESUME.md](RESUME.md) routes there. Each product's README/AGENTS/Boot owns its execution. This document retains the Batch 6 gate, not a copied roadmap, owner queue or startup procedure. The [programme plan](docs/EXECUTION-PLAN.md) owns sequencing; [WORKFLOW.md](WORKFLOW.md) governs Workbench changes.

## Lift record (owner: one dated line in the delegation decisions record, typed once criteria 1-5 below are evidenced)
```
LIFT <yyyy-mm-dd>: Batch 6 hold lifted by the owner; HANDOFF.md section 12 criteria 1-5 evidenced in records\delegation-20261026\LIFT-EVIDENCE.md.
```

## 12. Success criteria before the programme closes and Batch 6 resumes

Amended 2026-10-26 under the owner's exceptional delegation (its text and SHA-256 are recorded in WS-015). These are the written closure criteria (contract C1); each needs recorded evidence, none is inferred:

1. Contracts A and B RELEASED in both repositories (published, promoted, `REMOTE_CERTIFY: READY`). Done before WS-015.
2. C1: WS-015 released (`Backup-Workspace -Package`/`Restore-Workspace -Package`), one real package made and its OneDrive copy verified by a cloud re-download, and its same-machine isolated restore into new empty roots verified (SHA256SUMS, exact refs/HEAD, and each restored repository's Boot printing its expected READY result). C1 is not a clean-machine proof. The package is NOT encrypted: the owner decided on 2026-10-26 that an unencrypted compressed archive in OneDrive replaces the earlier "encrypted backup" condition; secrets are reported by name (rule, file, line) by the package's scan, never claimed absent.
3. Founder ADR-0033 amended through a native Founder CR and released, so Founder's Boot routes to Batch 6 like Platinum's; a cold-start agent in each repository reaches that next action from its README/Boot alone.
4. Shared Evidence: waived as a closure prerequisite (not earned). CTRL-19: OPEN, residual risk accepted by the owner. Workbench Stages 2-7 / P3 management are not Batch 6 prerequisites.
5. C2, amended by the owner 2026-10-27 (no Windows reinstallation): C1 on package orvion-backup-20261026T201821Z.7z (SHA256 BC28B482F6E101D40D3DD2E9DA5690C122589350804F64FE59BC612D8E9F0203; cloud re-download matched; isolated restore; CRM, ORVION and Workbench Boots READY), plus one isolated run of the released `lib/Restore-ORVION.cmd` launcher against a fresh package. Clean-machine tool installation stays UNPROVEN: residual risk accepted by the owner.

The hold is lifted by one recorded lift decision that cites the evidence of 1-5; each product's Boot then owns Batch 6.

## Evidence boundaries

Snapshots, transcripts and historical contracts describe their exact subjects, not today's authority. A passing sandbox receipt cannot certify an original checkout; local completion, hosted success, independent trust, publication/promotion and remote certification remain separate facts. Historical receipts retain their physical roots and are never transplanted as working certification.

Nothing is Gate 1 until the owner approves the exact frozen Draft SHA-256; honest recorded delegation is labelled delegated. Publication, promotion, GitHub settings, credentials, production writes, destructive retirement and restarting a host-killed heavy run require their owning authorization. An earlier one-time release approval is not reusable. Neither this file nor workstation restoration lifts Batch 6 automatically. See [recovery limits](docs/RECOVERY.md#not-yet-proven).
