# P4 - Consolidation, workstation and clean recovery

Version 5, 2026-10-21. Planning only. Detailed execution needs its own approved scope. The integrated dependency order is in [P2](02-B-DELIVERY.md); next C consumes these outputs instead of repeating them.

## M1 - Map the small legacy source and its replacement

Input: released B replacement interfaces, WS change authority, existing backup helpers.

- Source: C:/Users/My Lab/Documents/ORVION-Owner-Tools.
- Active destination: C:/Users/My Lab/Documents/GitHub/ORVION-Owner-Tools; never overlay its root.
- Preserved legacy copy: WS/work/legacy-owner-tools/20261021 under ignored local work; a historical archive, not a second active interface. If this target already exists, compare/refuse before choosing a new approved destination.
- Native release engines remain in their respective products. B's independent interfaces remain usable without WS; external dual coordination lives in WS.
- Preserve logs/backups/README/JSON. Classify sensitive/local content before tracking configuration; never print credentials.

1. Enumerate only this small source's relative paths and hashes, including explicit handling of hidden files/reparse points.
2. Map every declared live consumer (launcher/config/hook/backup) to its proved replacement. No process is not proof of no consumer.
3. Freeze the path mapping, source identity, new absent destination and independently verified rollback copy. Preserve historical raw records without editing them.

Exit: an explicit source/content/consumer mapping with no unknown overwrite or unexplained unique file.

## M2 - Copy, compare, cut over, then retire

1. Resolve absolute source/destination/backup/log paths and prove containment within approved boundaries. Reject reparse traversal and unexpected active writers. Never stop a workload based on an old PID.
2. Use a reviewed copy-only script. The earlier fixture used robocopy with /E /COPY:DAT /DCOPY:DAT /R:1 /W:1 /XJ /NP and a fixed approved log. Freeze literal paths/options later. No /MIR, /PURGE, /MOV, /MOVE or deletion in the copy step.
3. Treat exit >=8 as failure; a lower code is not proof of content identity. Compare complete relative-path sets and each file's SHA-256; rehash source to detect changes during copy. Missing/extra/changed files block cutover; never overwrite an unexplained difference.
4. Cut over only approved live consumers. Exercise routing/argument binding/wrong-target refusal in fixtures; no live publication for a parameter test. Prove no active dependency on the old path and backup coverage of the replacement.
5. Preserve the verified rollback outside the source. Retire/delete the old folder only if explicitly in approved scope and all previous evidence holds. Otherwise stop with a concrete retirement disposition; never silently leave two active interfaces or hide dependency behind a permanent junction.

On failure preserve source and differences; do not retire. A committed correction is forward-only through its contract. Earlier copy-fixture evidence is [a two-file fixture](../evidence/copy-fixture/result.json), not proof that the real merge happened.

Exit: one active operational location, no live old-path consumer and preserved unique content/rollback evidence.

## E1 - WS workstation without mandatory product dependencies

Input: actual WS tool requirements and existing product workstation experience. Do not rewrite product provisioners or run them to discover side effects.

| Capability | Intended checks |
|---|---|
| CORE | WS's own required runtime/tools; no projects or Docker required |
| PROJECT | Only explicitly selected root/identity/remote; own native doctor if requested |
| DUAL | Both targets because this operation explicitly requests both |
| SANDBOX | Separate clone/config/object ownership, push disabled and task-specific resources |
| BACKUP | Coverage/manifest/hash validity and restore-to-absent-target refusal |

1. Approve a small requirements authority, prepare/doctor entrypoints and tests; suggested WORKSTATION.md/.workstation names are proposals, not installed tools.
2. Doctor inspects; it does not install/login/start/stop or silently replace an account/target. Prepare performs only approved missing prerequisites and is idempotent.
3. In isolation prove absent optional products with CORE success, missing required tool failure, wrong path/remote refusal, explicit DUAL missing-party refusal and two prepare runs with no unnecessary second-run mutation.
4. Inspect the recorded product-bootstrap/root mismatch only if it remains in the intended restore path. Repair through that product's own CR if causal proof warrants it; never move the real checkout to satisfy a stale script.

Exit: capability-specific requirements, actionable diagnoses and measured preparation idempotence. Private remote/actual folder rename/general personal-assistant features are not automatic dependencies.

## E2 - Backup coverage before clean-Windows proof

Existing Backup-Workspace/Restore-Workspace and their simulated proof remain the starting point.

1. Declare the recovery inventory and each category's preservation mechanism: all necessary refs, ignored receipts/bound records/local configuration, uncommitted/index/untracked work, unique prototypes, older stash/reflog history, client settings, sensitive session/event data and any explicitly required Marketing/DB/WSL state. Mark exclusions and independent recovery procedures; do not claim a Git bundle preserves the whole workstation.
2. Extend existing helpers only for reproduced coverage gaps. Verify bundles/hashes and restore-ref equality; current stash tip being reachable does not prove older reflog-only states survived. No secrets in Git or output; credential reauthorization follows its existing owner-controlled procedure.
3. Take the approved encrypted backup to an independent destination. Freeze a stable restore point; active session archives/writers need a consistent snapshot policy, not a live recursive copy assumed complete.
4. Restore to an absent target on a suitable clean Windows VM/machine; reject existing-target and tampered-backup fixtures. Restore before bootstrap creates repository targets.
5. Compare required paths/hashes/refs/HEAD/config/receipts, run capability doctor and own product Boot, then only the actual authenticated/operational reads required by the declared claims. Software checks do not prove Auth/Storage/provider restoration.
6. Prepare twice in the recovered environment and inspect resulting changes; verify independent product operation without WS/the other product. Capture actual commands/results and coverage exclusions in C's existing acceptance evidence.

Exit: measured clean-environment recovery from a verified encrypted independent copy, with boundaries explicit. Earlier simulation is not this proof. Missing USB/BitLocker/VM blocks its own proof; never reinstall Windows on the working host to manufacture acceptance in this task.

## E3 - Sandbox correctness and bounded cleanup

A shared filesystem evidence/tools area does not imply a shared database target. Distinguish local ORVION-Sandbox, isolated product stack identities/ports, and public GitHub test fixtures. Preserve native target isolation; do not create a third DB stack or combine existing product stacks by assumption.

1. Recheck only the previously reported sandbox.ps1/helper call before treating it as an active defect. If still required and broken, approve the smallest repair, or prove a replacement before retirement. Do not run -Sweep as diagnosis.
2. Correct an existing Delegate/worktree experiment route only if it still permits Git-mutating worktrees; use independent clones and prove the affected route. No delegation is started by this plan.
3. Give each cleanup candidate an owning task, state, unique-content assessment, retention condition and verified preservation evidence. An old running label needs live process evidence; names/temp/draft/age alone authorize nothing.
4. Retire only exact approved targets after preservation/cutover. Preserve RESUME/evidence, original packets and unexplained unique work. No broad VHDX/volume/Docker pruning, production cleanup or system-wide scan.

P4 exits per proved substage. C/Q1 records actual results and unresolved blockers, then requests the owner's closure/hold decision. It never automatically resumes Batch 6.
