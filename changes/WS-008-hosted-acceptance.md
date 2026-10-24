# Workbench Change Request - WS-008

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Install the single exact supported Workbench GitHub Actions acceptance workflow source using the accepted WS-007 local CI entry. Prove local source acceptance and native lifecycle feasibility. This contract does not publish, activate Actions, configure a required check, create a trusted checkout or claim hosted runtime/security parity.

## Baseline

d2e352eef6cf59f3277dcc4921ca476874f64680

## Write Scope

- RESUME.md
- .github/workflows/workbench-acceptance.yml

## Out of Scope

All other engineering paths; original execution without a separate exact Gate 1; publication, promotion, GitHub/account/credential/settings/subscription/visibility changes; trusted-main/Data root creation; product changes; new CI engines, schedulers or registries; storage migration/cleanup; broader P3/P4, Batch 6 and Phase 8. CTRL-19 remains OPEN. No completed WS005/006/007 Finish or CI replay. RESUME body unchanged; normal pointer transitions only.

## Draft Assurance

V1: WS008-HOSTED-DESIGN-20261024 | 2026-10-24 | C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-workflow-20261024\assurance\V1\DRAFT.md | 8E11D91ED0DA61F03E768C4D30CB6B76B92C428B9B6D7706C15AAE016699000A
V2: WS008-HOSTED-ADVERSARIAL-20261024 | 2026-10-24 | C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-workflow-20261024\assurance\V2\DRAFT.md | 36AEB1613C3A831694215EC8AC9408B0D377FBF86AE8D9749996E68F9BCCECF9
V3: WS008-HOSTED-REFRESH-20261024 | 2026-10-24 | C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-workflow-20261024\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WShA
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WShA\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WShA\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-workflow-20261024\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `.github/workflows/workbench-acceptance.yml` contains `Workbench acceptance`; if so record Already Applied when its Git blob is f8ea66fee5642bb2613e530c053fdbe617623898, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (install the exact accepted closed Workbench workflow policy; no new CI engine or privileged release operation), and change nothing else:

   ```text
   {
     "name": "Workbench acceptance",
     "on": {
       "push": {
         "branches": [
           "workbench-preflight"
         ]
       }
     },
     "permissions": {
       "contents": "read"
     },
     "jobs": {
       "workbench-acceptance": {
         "name": "workbench-acceptance",
         "runs-on": "windows-2025",
         "timeout-minutes": 60,
         "steps": [
           {
             "name": "Checkout",
             "uses": "actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683",
             "with": {
               "fetch-depth": 0,
               "persist-credentials": false
             }
           },
           {
             "name": "Provision pinned grammar",
             "shell": "pwsh",
             "run": "$ErrorActionPreference='Stop'\n$tools=Join-Path $env:RUNNER_TEMP 'workbench-tools'\n[void](New-Item -ItemType Directory -Path $tools -ErrorAction Stop)\n$archive=Join-Path $tools 'actionlint.zip'\nInvoke-WebRequest -Uri 'https://github.com/rhysd/actionlint/releases/download/v1.7.12/actionlint_1.7.12_windows_amd64.zip' -OutFile $archive\nif((Get-FileHash -LiteralPath $archive).Hash -cne '6E7241B51E6817EA6A047693D8E6FED13B31819C9A0DD6C5A726E1592D22F6E9'){throw 'CI_TOOL_ARCHIVE_CHANGED'}\n$zip=[IO.Compression.ZipFile]::OpenRead($archive)\ntry{\n    $entries=@($zip.Entries | Where-Object {$_.FullName -ceq 'actionlint.exe'})\n    if($entries.Count -ne 1){throw 'CI_TOOL_ENTRY_INVALID'}\n    [IO.Compression.ZipFileExtensions]::ExtractToFile($entries[0],(Join-Path $tools 'actionlint.exe'),$false)\n}finally{$zip.Dispose()}\nif((Get-FileHash -LiteralPath (Join-Path $tools 'actionlint.exe')).Hash -cne '54CA21BE3DE4C7CFA26914AA8B61BD76BF573EF3CAAC5F80D110558CDF241718'){throw 'CI_TOOL_BINARY_CHANGED'}"
           },
           {
             "name": "Verify",
             "shell": "pwsh",
             "run": "& ./lib/Workbench.ps1 -CI -Candidate $env:GITHUB_SHA -CIRuntimeRoot (Join-Path $env:RUNNER_TEMP (\"workbench-ci-\" + $env:GITHUB_RUN_ID + \"-\" + $env:GITHUB_RUN_ATTEMPT)) -Actionlint (Join-Path $env:RUNNER_TEMP \"workbench-tools/actionlint.exe\"); exit $LASTEXITCODE"
           }
         ]
       }
     }
   }
   ```

   The resulting file's Git blob is f8ea66fee5642bb2613e530c053fdbe617623898.

## Acceptance Criteria

- [ ] Exact single installed workflow output. check: blob:.github/workflows/workbench-acceptance.yml=f8ea66fee5642bb2613e530c053fdbe617623898
- [ ] RESUME authority body preserved. check: normalized-resume:RESUME.md=1F392B6A18CC44442BCABE3E23BF82571975C585E8C70496881136170FECE520
- [ ] Accepted checker semantic policy and real pinned actionlint accept the exact workflow. It uses only push/workbench-preflight, one named workbench-acceptance job, windows-2025, contents read, pinned checkout with full history/no persistent credentials, exact hash-checked grammar provisioning and the existing candidate-bound CI entry. No privileged event, secret/release step or conditional skip is introduced.
- [ ] Actual bounded caller/policy tests causally refuse malformed/duplicate/unknown workflow keys, unsafe triggers or branch/check/runner changes, skipped jobs, permissions escalation, unpinned/altered actions/tools, changed Verify command, missing tests, stale SHA, nonzero exits and forged success. Existing owning causal engine proof is reused only when exact inputs are unchanged, and this unit's mandatory Finish executes its native owning suite.
- [ ] Literal replay reproduces the exact output, is idempotent, and refuses changed existing output or wrong declared blob before writes. Only the one implementation path and legal lifecycle metadata are admitted. The exact pinned provisioning source matches the previously successful unchanged provision proof and binaries.
- [ ] In the independent sandbox, the exact workflow Verify body invokes actual local CI once at the committed implementation SHA using bounded local runner variables; it completes the full schedule as CI_TEST_ONLY without changing native receipts. This is local operational proof, never actual GitHub runner/event/check execution. Original execution reuses this valid sandbox workflow-call proof and requires its own fresh native Finish, not a redundant second full CI unless changed evidence demonstrates a need.
- [ ] This execution role has its own fresh timed/watched native Finish, including the derived CI profile, and independent live Review before native Complete. Every completion criterion is locally satisfiable; actual hosted run/check, publication, trusted evaluation, private protection and promotion are separately authorized future boundaries. No hosted check is required to Complete this initial local source contract.

## Review Gate

- [ ] Independently observe exact installed workflow bytes, original baseline/protected evidence, approved role/root/Draft, causal tests, literal replay and normal accepted hooks. Check the implementation plus available carrying transitions against the pinned accepted checker.
- [ ] Verify this role's own fresh receipt, exact implementation/evaluator/recipe/profiles, timed END and concurrent watcher/host exits. Inspect actual sandbox workflow-call CI result and unchanged native receipts; do not transplant a sandbox receipt as original certification.
- [ ] Record truthful local-only acceptance with DONE/None. Native Review precedes Complete; the full baseline-to-Complete range and clean final pointer are verified after Complete. Preserve WS005/006/007, original/unrelated roots and canonical plan v1.6/layout v1.5. Hosted execution/enforcement remain UNPROVEN and CTRL-19 OPEN.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Isolated preparation only. No original allocation or approval. The disposable sandbox may use explicitly synthetic exact-root approval solely to rehearse this scope; it grants no original/remote authority. Use existing native admission, Execute, timed/watched Finish, Review, Complete and accepted-range tools.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-workflow-20261024\assurance\V3\DRAFT.md
Approved SHA256: DC8B4ED0B617041E83B1D2F14A6A9252855BC10EF210A814BE34ABECD916EE38
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-workflow-20261024\runtime\original\owner-approval.md
Owner Evidence SHA256: 1D9563BF75606AB943C4FFB62F3AAEB26F75606A2381658C7D13530AABFBCE02
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\hosted-workflow-20261024\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: AD1BA2A6ACB2BD6A217CC9B67907DCD897447A87E238ADD816E1EC47A3C99679
Original literal workflow output applied through the accepted native Workbench entry, all declared blobs match. Fresh own timed/watched full Finish still required.

## Verification Notes

No future lifecycle verdict is asserted. Retain actual role-specific proof externally. Revalidate exact original baseline and selected bytes before any separately approved original operation.


## Selection reasons and sources

Selected V3: retain the exact one-output design after 30 positive/causal policy observations, unchanged pinned-tool/provision proof and current official trigger/checkout/runner/security evidence. The reviewed windows-2025 image 20261021.299.1 lists PowerShell 7.6.7 and Git 2.56.0.windows.2, differing from local 7.6.8/2.54.0.windows.1. The accepted CI recipe derives actual versions at runtime, while native certification retains frozen local context versions; no exact native-context version check is imposed on a hosted CI run. The image changes over time: platform dependencies are identified, but real cloud runtime success remains UNPROVEN until separately authorized publication. Complete the required new sandbox lifecycle before requesting original Gate 1; preserve failed probes and distinguish proposed check identity from installed enforcement.

Sources reviewed 2026-10-24: accepted WORKFLOW.md, Get-WorkbenchWorkflowPolicy/Get-WorkbenchCITool and canonical plan v1.6/layout v1.5; completed WS007 original evidence EF674801EBE914AED8E00FA4AB9C4454D37552C85BDA357A1DB47AE71F490F6F; this packet's actual probes. Official references: https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#push ; https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax ; https://github.com/actions/checkout/blob/11bd71901bbe5b1630ceea73d27597364c9af683/README.md ; https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md ; https://docs.github.com/en/actions/reference/security/secure-use . No owner authentication, universal secret detection, equal-OS tamper resistance or actual hosted enforcement is claimed.
