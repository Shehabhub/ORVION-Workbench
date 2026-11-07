# ORVION programme closure

The Lift record and the criteria that close the programme and resume Batch 6 (DEC-05). Restore-ORVION.ps1 prints
"per HANDOFF.md section 12" during a restore, so section 12 keeps its number.

## 11. Lift record (owner: one dated line, saved with the owner's words as DEC-01 says, once criteria 1-5 are evidenced)

```text
LIFT <yyyy-mm-dd>: Batch 6 hold lifted by the owner; HANDOFF.md section 12 criteria 1-5 evidenced in data\records\delegation-20261026\LIFT-EVIDENCE.md.
```

LIFT 2026-11-07: Batch 6 hold lifted by the owner; HANDOFF.md section 12 criteria 1-5 evidenced in data\records\delegation-20261026\LIFT-EVIDENCE.md.

## 12. Success criteria before the programme closes and Batch 6 resumes

These are the written closure criteria (contract C1); each needs recorded evidence, none is inferred:

1. Contracts A and B RELEASED in both repositories (published, promoted, `REMOTE_CERTIFY: READY`). Done before WS-015.
2. C1: WS-015 released (`Backup-Workspace -Package`/`Restore-Workspace -Package`), one real package made and its
   OneDrive copy verified by a cloud re-download, and its same-machine isolated restore into new empty roots verified
   (SHA256SUMS, exact refs/HEAD, and each restored repository's Boot printing its expected READY result). C1 is not a
   clean-machine proof. The package is NOT encrypted: the owner decided on 2026-10-26 that an unencrypted compressed
   archive in OneDrive replaces the earlier "encrypted backup" condition; secrets are reported by name (rule, file,
   line) by the package's scan, never claimed absent.
3. Founder ADR-0033 amended through a native Founder CR and released, so Founder's Boot routes to Batch 6 like
   Platinum's; a cold-start agent in each repository reaches that next action from its README/Boot alone.
4. Shared Evidence: waived as a closure prerequisite (not earned). CTRL-19: OPEN, residual risk accepted by the owner.
   Workbench Stages 2-7 / P3 management are not Batch 6 prerequisites.
5. C2, amended by the owner 2026-10-27 (no Windows reinstallation): C1 on package orvion-backup-20261026T201821Z.7z
   (SHA256 BC28B482F6E101D40D3DD2E9DA5690C122589350804F64FE59BC612D8E9F0203; cloud re-download matched; isolated
   restore; CRM, ORVION and Workbench Boots READY), plus one isolated run of the released `lib/Restore-ORVION.cmd`
   launcher against a fresh package. Clean-machine tool installation stays UNPROVEN: residual risk accepted by the
   owner.

The hold is lifted by one recorded lift decision that cites the evidence of 1-5; each product's Boot then owns Batch 6.

## 13. Evidence boundaries

What evidence proves, and what it never certifies: DEC-22. Approvals: DEC-02. Releases: DEC-25. What lifts the Batch 6
hold: DEC-04. Restore limits: [Not yet proven](docs/RECOVERY.md#not-yet-proven).
