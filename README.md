# ORVION Workbench

The owner's ORVION workspace in the public repository <https://github.com/Shehabhub/ORVION-Workbench>: tools, tests,
decisions, contracts and portable engineering knowledge. This file routes each kind of information to its one home.

## 1. What this is

ORVION-Workbench manages the owner's workspace around the CRM and ORVION repositories, which keep their own native
authority (DEC-08). What may be published, and the secret scan every file passes first: DEC-09. Backup and recovery:
DEC-27.

## 2. Which source wins

The owner's live instruction (DEC-02), then docs/DECISIONS.md, then the native lifecycle (WORKFLOW.md with
lib/Workbench.ps1), then docs/RUNBOOK.md, then the workstream plan and its records, then history. A dated record or an
earlier report never grants scope (DEC-02).

## 3. The places

Two working folders and one backup copy: DEC-08. What each holds: WORKSPACE-LAYOUT.md sections 2 and 3. Where a new
item goes: WORKSPACE-LAYOUT.md section 4.

## 4. Read on need

| You need | Read |
| --- | --- |
| a decision or rule in force | [docs/DECISIONS.md](docs/DECISIONS.md), one entry: `grep -n '^## DEC-18' docs/DECISIONS.md` |
| how to do a step | [docs/RUNBOOK.md](docs/RUNBOOK.md) |
| the layout, the method and the checks | [docs/WORKSPACE-LAYOUT.md](docs/WORKSPACE-LAYOUT.md) |
| the engineering entry | `pwsh -NoProfile -File lib/Workbench.ps1 -Boot`, then [WORKFLOW.md](WORKFLOW.md) |
| the active contract | [RESUME.md](RESUME.md) |
| a new contract | [changes/TEMPLATE.md](changes/TEMPLATE.md); the contracts: [changes/](changes/README.md) |
| a tool | [lib/README.md](lib/README.md) |
| the criteria that close the programme | [HANDOFF.md](HANDOFF.md) |
| recovery after a lost machine | [docs/RECOVERY.md](docs/RECOVERY.md) |
| the documents and their history | [docs/](docs/README.md) and the [history index](docs/history/README.md) |
| configuration examples | [config/README.md](config/README.md) |

## 5. The work loop

The method for every task: WORKSPACE-LAYOUT.md section 14.1. Sizing it to the change: DEC-12. Finding a section: one
grep and one ranged read (DEC-32).

## 6. Save and compact

After every operation, save as DEC-26 says, then give the owner the /compact line and the resume message; the owner
types /compact by hand. The exact output: WORKSPACE-LAYOUT.md section 14.2.
