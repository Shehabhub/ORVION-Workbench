# Workbench Change Request - WS-001

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Deliver Workbench's own bounded local admission, literal execution and fresh certification cycle before adding product supervision.

## Baseline

088bab520f5c61336925472e892ee2c4a72f9650

## Write Scope

- .githooks/pre-commit
- .gitignore
- AGENTS.md
- README.md
- RESUME.md
- WORKFLOW.md
- changes/TEMPLATE.md
- lib/README.md
- lib/Test-WorkbenchChange.ps1
- lib/Workbench.ps1
- lib/test-workbench-governance.ps1
- lib/run_timed.ps1
- lib/watch_run.ps1
- lib/apply-draft-steps.ps1
- lib/test-draft-steps.ps1

## Out of Scope

Both native product checkouts and trusted clones, historical HANDOFF/runbooks/sealed packets, journals/sessions, private remote creation, product lifecycle engines/profiles/CI, retention/deletion/migration, workstation installation, Contract C and Batch 6. This is the first P3 kernel slice, not completion of G2c A-H.

## Required Reading

WORKFLOW.md (proposed exact payload); existing owner-workbench-handoff-20261021/runbooks/03-WORKBENCH.md G1-G3/G2c; preparation.json; existing B release and monitor integration evidence. Read only the specific source/lesson needed for a failure.

## Draft Assurance

V1: WS-GOV-V1-DESIGN | 2026-10-23 | C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-governance-20261023-r2\V1-DESIGN.md | 01A4EF1062BDEB694AD579035D015F9F9003F6B360F9968E95F193B18A7E7B3F
V2: WS-GOV-V2-ADVERSARIAL | 2026-10-23 | C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-governance-20261023-r2\V2-DRAFT.md | ED5AE3F2B82DE7A44D71556E18515A7DD63014DAEF3B0BD9F614E4FBF85AD11F
V3: WS-GOV-V3-REFRESH | 2026-10-23 | C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-governance-20261023-r2\V3-DRAFT.md | SELECTED
Selected Version: V3

## Pre-Approval Evidence

Significant CONTROL/REPOSITORY change. Selection requires EVIDENCE.json binding these exact Draft/payload bytes to accepted actual caller cases, literal replay and a normal-hook full self-lifecycle rehearsal with real tests.ps1 inside fresh timed/watched Finish. Synthetic assertions/short children prove dispatch/refusal only. No original approval or implementation is inferred from preparation.

V2 findings addressed: canonical Implementation Steps formatting retained from the existing applier; pre-write byte preservation and Git-filtered post-write assertions instead of platform-dependent newline comparisons; CRLF status editing; multiple pwsh application results; live-log Windows FileShare; exact execution-root and header/path binding; input/evaluator/profile freshness; immutable receipt selection; current-vs-historical evidence; inherited timing from another checkout; same-root operation overlap; accepted-baseline checker/hook and scoped pre-write Plan; unknown/conflicting predicates; declared literal outputs; Unicode/space preservation; local-data/known credential shapes; Brief unreadable/refused visibility. Current final-byte proofs, failed attempts and limits belong to EVIDENCE.json and raw logs, not a second programme report.

## Implementation Steps

1. Check whether `.githooks/pre-commit` contains `Execute the accepted checker, never the proposed working checker`; if so record Already Applied when its Git blob is 905d04a7ca5f191a03d32608eb0befdbee722c81, and otherwise stop and report. Otherwise make exactly these 2 edits (the bounded Workbench local governance kernel), each matched once, and change nothing else:

   a) replace the lines
   ```text
   # Refuse a commit unless every tool check passes and nothing under the local-data folders is staged.
   if git diff --cached --name-only | grep -E '^(sessions|events|work)/' >/dev/null; then
     echo "ORVION-Owner-Tools: local data (sessions/, events/, work/) is never committed" >&2
     exit 1
   ```
   with
   ```text
   # Execute the accepted checker, never the proposed working checker. No full-suite duplication.
   set -eu
   root=$(git rev-parse --show-toplevel) || exit 1
   judge=$(mktemp "${TMPDIR:-/tmp}/workbench-judge-XXXXXXXX.ps1") || exit 1
   trap 'rm -f -- "$judge"' EXIT HUP INT TERM
   if git cat-file -e HEAD:lib/Test-WorkbenchChange.ps1 2>/dev/null; then
       git show HEAD:lib/Test-WorkbenchChange.ps1 > "$judge" || exit 1
       pwsh -NoProfile -File "$judge" -Root "$root" -Mode Gate -Staged -Base HEAD
   else
       if [ -z "${WORKBENCH_BOOTSTRAP_JUDGE:-}" ] || [ -z "${WORKBENCH_BOOTSTRAP_SHA256:-}" ]; then
           echo 'WORKBENCH: BLOCKED'
           echo 'CODE: WB_EXPLICIT_REVIEWED_BOOTSTRAP_REQUIRED'
           exit 1
       fi
       pwsh -NoProfile -File "$WORKBENCH_BOOTSTRAP_JUDGE" -ExpectedEvaluatorSha256 "$WORKBENCH_BOOTSTRAP_SHA256" -Root "$root" -Mode Gate -Staged -Base HEAD
   ```

   b) replace the lines
   ```text
   fi
   exec pwsh -NoProfile -File "$(git rev-parse --show-toplevel)/tests.ps1"
   ```
   with
   ```text
   fi
   ```

   The resulting file's Git blob is 905d04a7ca5f191a03d32608eb0befdbee722c81.

2. Check whether `.gitignore` contains `.workbench-certifications/`; if so record Already Applied when its Git blob is 37b0b344439bf734da7d070a36249108b15ad4b5, and otherwise stop and report. Otherwise make exactly this one edit (the bounded Workbench local governance kernel), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   *.tmp
   ```
   insert
   ```text

   .workbench-local-certification.json
   .workbench-certifications/
   ```

   The resulting file's Git blob is 37b0b344439bf734da7d070a36249108b15ad4b5.

3. Check whether `AGENTS.md` contains `Workbench's own engineering entry is`; if so record Already Applied when its Git blob is bd4ed56173037a13079956c55fe2a6a86bd77c5f, and otherwise stop and report. Otherwise make exactly this one edit (the bounded Workbench local governance kernel), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   Router only (Codex and other agents that read AGENTS.md): read `README.md`, then `RESUME.md`, then `HANDOFF.md`.
   ```
   insert
   ```text
   Workbench's own engineering entry is `lib/Workbench.ps1 -Boot`; its authority is `WORKFLOW.md`.
   Use its actual contract/blocked result; dated programme history never grants a new scope.
   ```

   The resulting file's Git blob is bd4ed56173037a13079956c55fe2a6a86bd77c5f.

4. Check whether `README.md` contains `initial local kernel supplies own admission/Finish/Review`; if so record Already Applied when its Git blob is f1b3fc6ae103a6090dd7baf5c0dc76eede2018df, and otherwise stop and report. Otherwise make exactly this one edit (the bounded Workbench local governance kernel), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
   **After any interruption, start at [`RESUME.md`](RESUME.md)**: live resume point, latest session, the two repositories, boundaries.

   ```
   insert
   ```text
   **For Workbench's own changes:** run `pwsh -NoProfile -File lib/Workbench.ps1 -Boot` from this root and follow [WORKFLOW.md](WORKFLOW.md). This initial local kernel supplies own admission/Finish/Review; full product supervision and workstation recovery remain separately governed. A product-only entry continues to use that product's own tools.

   ```

   The resulting file's Git blob is f1b3fc6ae103a6090dd7baf5c0dc76eede2018df.

5. Check whether `RESUME.md` contains `This file owns the active Workbench contract pointer`; if so record Already Applied when its Git blob is 184d4e7858226b76d80130b8651b86b3fe32c431, and otherwise stop and report. Otherwise make exactly this one edit (the bounded Workbench local governance kernel), each matched once, and change nothing else:

   a) replace the lines
   ```text
   This file holds no state, so it never goes stale. It routes to the records that do. Transcripts are history; repository
   evidence and each repository's own Boot are authority.
   ```
   with
   ```text
   This file owns the active Workbench contract pointer and routes to the existing programme checkpoint. For Workbench's
   own changes run lib/Workbench.ps1 -Boot and follow WORKFLOW.md. Transcripts and dated HANDOFF snapshots are history;
   each product's own Boot remains its authority. This is not a second programme status report.
   ```

   The resulting file's Git blob is 184d4e7858226b76d80130b8651b86b3fe32c431.

6. Check whether `WORKFLOW.md` contains `# Workbench local workflow`; if so record Already Applied when its Git blob is 77b579feb600eb3ab3efd7f0595fc27e3ed211a5, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (the bounded Workbench local governance kernel), and change nothing else:

   ```text
   # Workbench local workflow

   This authority governs only Workbench's own changes. Each product retains its own native authority. Product supervision is not implemented by this first kernel. No generic command execution, project discovery, remote creation or cleanup is implied.

   Official contract statuses: Draft, Approved, In Progress, Complete, Cancelled. Runtime verdicts are not statuses. RESUME.md owns the one active Workbench contract pointer. The existing external task checkpoint owns programme progress; it is not a second Workbench contract registry.

   Create a contract using changes/TEMPLATE.md. Exact scope includes additions, deletions and both sides of renames. Local sessions/events/work and credentials never enter tracked engineering state. Freeze the Design, Adversarial Review and Evidence Refresh snapshots; use three distinct IDs/paths, allowing unchanged successive content. The V3 snapshot's digest is supplied by the owner's exact Gate 1; it does not contain its own hash. Approval evidence must actually identify that digest. This binds local evidence, not authenticated owner identity.

   After exact approval, allocate the unchanged Draft, then record Approved and the approval evidence, activate its pointer, record In Progress and implement only scope. Approval evidence binds the exact selected Draft and explicit physical execution root; copying a record to another checkout does not grant authority. Frozen sections never change. Runtime Checkpoint, checkbox state and append-only logs are the only mutable contract surfaces. Complete and Cancelled history is immutable. Inspect the actual Git/index subject; a passing working file is not proof of different staged bytes.

   First installation only: before the old tree has either WORKFLOW.md or a Workbench checker, the externally reviewed bootstrap may import its exact already-approved contract and RESUME pointer together. No implementation file is admitted in that import; the existing real hook still runs. Every established installation requires ordinary Draft allocation. This bounded initial trust root is explicit, not a standing approval bypass.

   lib/Workbench.ps1 is the operational entry. Boot performs read-only routing. Gate uses lib/Test-WorkbenchChange.ps1 from accepted HEAD; a range is judged by the specified accepted baseline and every intermediate transition. The hook uses accepted checker bytes, never a changed working checker. Initial installation has no checker: its explicit reviewed external bootstrap and exact digest must be supplied; absence refuses. Git hooks can be bypassed by an equal-OS-privilege actor. A separate accepted-baseline range judgment remains required; no hosted protection is present.

   Execute uses the accepted existing Draft applier and its new read-only Plan output. It checks exact approved Draft identity, physical root and every planned target against scope before the applier can write. The existing applier still owns literal parsing, whole-plan preflight, unique anchors, filtered blob verification and race/reparse checks. Neither an unscoped raw applier nor a candidate-modified executor grants authority. Temporary accepted-code materializations live under WORKBENCH_TEMP_ROOT or TEMP/ORVION-Workbench and are removed by their owning invocation.

   Machine clauses are closed vocabulary: one plain end-of-line check per criterion, either blob:relative/path=full-lowercase-Git-SHA or normalized-resume:RESUME.md=uppercase-SHA256. Unknown or duplicated checks refuse. The literal steps' declared resulting blobs own expected output bytes; the checker consumes those declarations without duplicating the applier. Optional blob criteria must agree with them. Every PowerShell/hook change needs declared approved output bytes or an explicit blob criterion. Complete checks every declared result. Normalized routing excludes only the active pointer, never other authority text; a literal RESUME edit requires its normalized criterion. Undeclared control bodies and control deletion refuse. Windows-valid Unicode and space paths remain supported.

   Tracked local-data roots and credential-shaped content on changed paths refuse without printing values. The latter deliberately covers a small known GitHub/API-token/private-key vocabulary based on the existing reporter, not all possible secrets. Raw sessions, credentials and operational history remain outside Git and protected from engineering cleanup.

   Finish must run through the own absolute lib/run_timed.ps1 with explicit WorkingDirectory, external log and simultaneous lib/watch_run.ps1. Its root/PID stamp and actual runner ancestry must match; an inherited outer run does not time a different checkout. A per-root exclusive operation handle prevents overlapping self-Finish/admission/completion; an abandoned empty handle file is not a running process. Use the existing Watch-Host when resource load warrants it. One Finish owns the full tests.ps1 schedule; the hook only checks admission/freshness. No duplicate full suite is run to repeat the same closure. Existing deliberate fixture tests and different lifecycle judgments remain required. Finish checks clean committed inputs before/after tests, retires the old working receipt and issues a fresh root/input/evaluator/profile-bound receipt only on success. Archive receipts immutably by digest; Review names the selected receipt. Historical range checks read that original evidence, while a new live completion additionally requires the current working receipt. Preserve run logs; neither archive nor a watcher exit substitutes for native success.

   REPOSITORY always applies. CONTROL, COORDINATION and RECOVERY derive from exact scope and are covered by the existing full suite plus their owning new cases. WORKSTATION and CI are reserved fail-closed selections until their separately approved capability exists; they are not green placeholders or optional exemptions. Additional future verification must not remove derived obligations.

   An unsupported profile blocks Approval as well as Finish. Introduce its tested verifier first through an independently approved CONTROL change before freezing a workstation/hosted-CI scope. This prevents approving a contract that this version already knows cannot finish.

   Review is a live observation: check every actual criterion, inspect timed runner/watcher final exits and fresh receipt, record Confirmed Complete and DONE/None, then use the read-only Review check. Complete verifies those facts again and prepares only its own status/pointer edits. Stage exact paths and commit normally; independently judge the entire carrying range before declaring local completion. No local-only result means publication, promotion or remote certification.

   Sources: Git githooks and git-write-tree manuals; SLSA v1.2 artifact verification informs subject/input expectations. This is not a claim of SLSA compliance, signature verification, owner authentication or tamper resistance against equal OS privileges.
   ```

   The resulting file's Git blob is 77b579feb600eb3ab3efd7f0595fc27e3ed211a5.

7. Check whether `changes/TEMPLATE.md` contains `# Workbench Change Request - WS-NNN`; if so record Already Applied when its Git blob is 64361e25e469b8614057b9b9f9f8898b87c81a34, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (the bounded Workbench local governance kernel), and change nothing else:

   ```text
   # Workbench Change Request - WS-NNN

   ## Status

   [x] Draft
   [ ] Approved
   [ ] In Progress
   [ ] Complete
   [ ] Cancelled

   ## Objective

   One bounded result.

   ## Baseline

   Exact accepted full commit SHA before allocation.

   ## Write Scope

   - RESUME.md
   - exact/engineering/path

   ## Out of Scope

   All other engineering paths, products, credentials, sessions, events, work, cleanup and remote settings.

   ## Draft Assurance

   V1: unique-design-id | UTC-YYYY-MM-DD | absolute immutable V1 snapshot | SHA256
   V2: unique-adversarial-id | UTC-YYYY-MM-DD | absolute immutable V2 snapshot | SHA256
   V3: unique-refresh-id | UTC-YYYY-MM-DD | absolute selected Draft | SELECTED
   Selected Version: V3

   ## Implementation Steps

   Literal replayable steps and exact resulting blobs. No guessed switches, paths or mandatory commands.

   ## Acceptance Criteria

   - [ ] Exact scoped result and owning checks proven.

   ## Review Gate

   - [ ] Live subject, receipt, timing/watching and acceptance reviewed.

   ## Runtime Checkpoint

   Resume Step: 1
   Blocker: None
   Recovery Attempt: 0

   ## Execution Log

   Append only. At approval add exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line. Use actual immutable paths/digests and the selected absolute root. Owner evidence must identify both the approved Draft digest and execution root. Do not invent approval.

   ## Verification Notes

   Append only. After actual live review add Verdict: Confirmed Complete, Reviewed Fingerprint and Reviewed Receipt lines identifying the observed current result. Do not claim future tests passed.
   ```

   The resulting file's Git blob is 64361e25e469b8614057b9b9f9f8898b87c81a34.

8. Check whether `lib/README.md` contains `tracked local Workbench tools`; if so record Already Applied when its Git blob is 209931a239876ea1007a83aff41aab717a3d416c, and otherwise stop and report. Otherwise make exactly these 2 edits (the bounded Workbench local governance kernel), each matched once, and change nothing else:

   a) replace the line
   ```text
   # ORVION agent tools (machine-local, untracked; workspace: ..\README.md)
   ```
   with
   ```text
   # ORVION agent tools (tracked local Workbench tools; workspace: ..\README.md)
   ```

   b) replace the lines
   ```text
   Planned to be tracked in each repository by the wave-2 tooling contract; until then this folder is the copy
   (moved 2026-10-20 from Documents\ORVION-Sandbox\lib, which is superseded).
   ```
   with
   ```text
   Contract B supplied each product's own independent native adapters. This directory remains the Workbench agent's tools,
   not a dependency injected into direct-native product operation. Its historical move from Documents\ORVION-Sandbox\lib
   does not make that old copy an execution entry.

   ## Workbench's own local cycle

   `Workbench.ps1 -Boot` routes own work; `-Execute` checks the accepted applier's read-only plan before writes;
   `-Gate -Staged` and `-Gate -Base <accepted-full-SHA> -Head <full-SHA>` use the
   accepted checker and preserve native product independence. `Test-WorkbenchChange.ps1` owns own scope, transitions,
   three-pass snapshots, exact local approval/root binding, machine clauses and receipt freshness. `run_timed.ps1` and
   `watch_run.ps1` are locally adopted reporting adapters; no product installation is needed. Use absolute script paths
   and the own explicit WorkingDirectory for self-Finish. The existing tests.ps1 remains the one full closure schedule.
   `test-workbench-governance.ps1` uses independent real-Git fixtures and short children for dispatch/refusal proofs;
   those children are not a replacement for the actual full Workbench tool suite. Failed fixture roots are preserved;
   WORKBENCH_TEST_ROOT selects their explicit parent, otherwise TEMP/ORVION-Workbench/tests is used. Accepted-code
   materializations use WORKBENCH_TEMP_ROOT or that same TEMP/ORVION-Workbench parent. Current prototype
   evidence and first-installation bootstrap remain outside this checkout under the existing task's own packet.
   ```

   The resulting file's Git blob is 209931a239876ea1007a83aff41aab717a3d416c.

9. Check whether `lib/Test-WorkbenchChange.ps1` contains `Workbench's own local admission checker`; if so record Already Applied when its Git blob is 8365653fb8264fac3d522d2bc9a2df5a29a69453, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (the bounded Workbench local governance kernel), and change nothing else:

   ```text
   # Workbench's own local admission checker. Product authority is never evaluated here.
   [CmdletBinding()]
   param([ValidateSet('Boot','Gate','Range')][string]$Mode='Boot',
         [string]$Root=(Split-Path $PSScriptRoot -Parent),[string]$Base='HEAD',
         [string]$Head='HEAD',[switch]$Staged,[string]$ExpectedEvaluatorSha256)
   $ErrorActionPreference='Stop'
   try{[Console]::OutputEncoding=[Text.UTF8Encoding]::new($false)}catch{}
   function Invoke-WorkbenchGit([string]$Checkout,[string[]]$Arguments) {
       $lines=@(& git -C $Checkout -c core.quotepath=false @Arguments 2>$null)
       if($LASTEXITCODE-ne0){throw 'WB_GIT_UNREADABLE'}
       $lines
   }
   function Get-WorkbenchDigest([string]$value) {
       [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($value)))
   }
   function Assert-WorkbenchRelativePath([string]$Relative) {
       $segments=@($Relative-split'/')
       if(!$Relative-or[IO.Path]::IsPathRooted($Relative)-or$Relative-match'[\\\x00-\x1f<>:"|?*`]'-or
          @($segments|Where-Object{$_-in@('','.','..','.git')-or$_-match'[ .]$|^(?:CON|PRN|AUX|NUL|COM[1-9\u00b9\u00b2\u00b3]|LPT[1-9\u00b9\u00b2\u00b3])(?:\.|$)'}).Count){throw 'WB_RELATIVE_PATH_INVALID'}
   }
   function Get-WorkbenchLocalPath([string]$Checkout,[string]$Relative) {
       Assert-WorkbenchRelativePath $Relative
       $segments=@($Relative-split'/')
       $cursor=[IO.Path]::GetFullPath($Checkout)
       foreach($segment in @('')+$segments){
           if($segment){$cursor=Join-Path $cursor $segment}
           $item=Get-Item -LiteralPath $cursor -Force -ErrorAction SilentlyContinue
           if($item-and($item.Attributes-band[IO.FileAttributes]::ReparsePoint)){throw 'WB_REPARSE_LOCAL_PATH_REFUSED'}
       }
       $cursor
   }
   function Assert-WorkbenchRoot([string]$Checkout) {
       $rootItem=Get-Item -LiteralPath $Checkout -Force -ErrorAction Stop
       if($rootItem.Attributes-band[IO.FileAttributes]::ReparsePoint){throw 'WB_REPARSE_ROOT_REFUSED'}
       $resolvedRoot=[IO.Path]::GetFullPath($Checkout)
       $top=@(Invoke-WorkbenchGit $resolvedRoot @('rev-parse','--show-toplevel'))[0]
       if([IO.Path]::GetFullPath($top)-ine$resolvedRoot){throw 'WB_ROOT_MISMATCH'}
       $common=@(Invoke-WorkbenchGit $resolvedRoot @('rev-parse','--path-format=absolute','--git-common-dir'))[0]
       if([IO.Path]::GetFullPath($common)-ine(Join-Path $resolvedRoot '.git')){throw 'WB_SHARED_GIT_REFUSED'}
       if((Get-Item -LiteralPath (Join-Path $resolvedRoot '.git') -Force).Attributes-band[IO.FileAttributes]::ReparsePoint-or
          (Test-Path -LiteralPath (Join-Path $resolvedRoot '.git/objects/info/alternates'))){throw 'WB_SHARED_OBJECT_STORE_REFUSED'}
       $resolvedRoot
   }
   function Enter-WorkbenchOperation([string]$Checkout) {
       $leasePath=Join-Path $Checkout '.git/workbench-operation.lock'
       $item=Get-Item -LiteralPath $leasePath -Force -ErrorAction SilentlyContinue
       if($item-and($item.Attributes-band[IO.FileAttributes]::ReparsePoint)){throw 'WB_REPARSE_LOCAL_PATH_REFUSED'}
       try{[IO.File]::Open($leasePath,[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)}
       catch{throw 'WB_OPERATION_IN_PROGRESS_OR_UNREADABLE'}
   }
   function Get-WorkbenchText([string]$Checkout,[string]$tree,[string]$path) {
       (@(Invoke-WorkbenchGit $Checkout @('show',"${tree}:$path"))-join[char]10)+[char]10
   }
   function Get-WorkbenchFields([string]$Text) {
       $identity=@([regex]::Matches($Text,'(?m)^# Workbench Change Request - (?<id>WS-[0-9]{3})\r?$'))
       if($identity.Count-ne1){throw 'WB_CONTRACT_ID_INVALID'}
       $sections=[ordered]@{}
       $matchesFound=[regex]::Matches(($Text-replace'\r\n',"$([char]10)"),'(?ms)^## (?<name>[^\n]+)\n(?<body>.*?)(?=^## |\z)')
       foreach($matchFound in $matchesFound){
           $name=$matchFound.Groups['name'].Value.Trim()
           if($sections.Contains($name)){throw "WB_DUPLICATE_SECTION:$name"}
           $sections[$name]=$matchFound.Groups['body'].Value.Trim()
       }
       foreach($required in 'Status','Objective','Baseline','Write Scope','Out of Scope','Draft Assurance','Implementation Steps','Acceptance Criteria','Review Gate','Runtime Checkpoint','Execution Log','Verification Notes'){
           if(!$sections.Contains($required)){throw "WB_MISSING_SECTION:$required"}
       }
       $states=@([regex]::Matches($sections.Status,'(?m)^\[x\] (Draft|Approved|In Progress|Complete|Cancelled)$')|ForEach-Object{$_.Groups[1].Value})
       $statusLines=@($sections.Status-split'\n'|Where-Object{$_.Trim()})
       $statusNames=@($statusLines|ForEach-Object{$_-replace'^\[[ x]\] ',''}|Sort-Object -Unique)
       if($states.Count-ne1-or$statusLines.Count-ne5-or$statusNames.Count-ne5-or@($statusLines|Where-Object{$_-cnotmatch'^\[[ x]\] (Draft|Approved|In Progress|Complete|Cancelled)$'}).Count){throw 'WB_STATUS_INVALID'}
       $checkpoint=@{}
       foreach($field in @(@('Resume Step','(?:[1-9][0-9]*|DONE)'),@('Blocker','(?:None|[A-Z][A-Z0-9_-]+)'),@('Recovery Attempt','[0-3]'))){
           $entries=@([regex]::Matches($sections['Runtime Checkpoint'],'(?m)^'+$field[0]+': (?<value>'+$field[1]+')$'))
           if($entries.Count-ne1){throw 'WB_RUNTIME_CHECKPOINT_INVALID'}
           $checkpoint[$field[0]]=$entries[0].Groups['value'].Value
       }
       [pscustomobject]@{Id=$identity[0].Groups['id'].Value;Sections=$sections;Status=$states[0];Checkpoint=$checkpoint}
   }
   function Get-WorkbenchFrozen($record) {
       $pieces=@('Contract Identity: '+$record.Id)
       foreach($name in $record.Sections.Keys){
           if($name-in@('Status','Runtime Checkpoint','Execution Log','Verification Notes')){continue}
           $body=$record.Sections[$name]
           if($name-in@('Acceptance Criteria','Review Gate')){$body=$body-creplace'(?m)^- \[[ x]\] ','- [ ] '}
           $pieces+=$name+[char]10+$body
       }
       $pieces-join([char]10+[string][char]10)
   }
   function Set-WorkbenchSection([string]$Text,[string]$SectionName,[string]$ReplacementBody) {
       $pattern='(?ms)^## '+[regex]::Escape($SectionName)+'\r?\n.*?(?=^## |\z)'
       $sectionsFound=@([regex]::Matches($Text,$pattern))
       if($sectionsFound.Count-ne1){throw 'WB_MUTABLE_SECTION_NOT_UNIQUE'}
       $lineBreak=if($Text.Contains(([string][char]13+[char]10))){[string][char]13+[char]10}else{[string][char]10}
       $normalizedBody=$ReplacementBody.Trim()-replace'\r\n',([string][char]10)
       $normalizedBody=$normalizedBody-replace'\n',$lineBreak
       $replacement='## '+$SectionName+$lineBreak+$lineBreak+$normalizedBody+$lineBreak+$lineBreak
       $matchFound=$sectionsFound[0]
       $Text.Remove($matchFound.Index,$matchFound.Length).Insert($matchFound.Index,$replacement)
   }
   function Get-WorkbenchScope($record) {
       $paths=@($record.Sections['Write Scope']-split'\n'|Where-Object{$_-match'^- '}|ForEach-Object{$_.Substring(2).Trim()})
       if(!$paths.Count-or@($paths|Sort-Object -Unique).Count-ne$paths.Count){throw 'WB_SCOPE_INVALID'}
       foreach($path in $paths){
           Assert-WorkbenchRelativePath $path
           if($path-match'^(sessions|events|work)(/|$)'){throw 'WB_SCOPE_PATH_REFUSED'}
       }
       $paths
   }
   function Get-WorkbenchProfiles([string[]]$paths) {
       $profiles=@('REPOSITORY')
       if(@($paths|Where-Object{$_-match'(^AGENTS\.md$|^RESUME\.md$|^WORKFLOW\.md$|^changes/|^\.githooks/|^tests\.ps1$|^lib/(Workbench|Test-WorkbenchChange|test-workbench|run_timed|watch_run|apply-draft-steps|Invoke-DraftSteps))'}).Count){$profiles+='CONTROL'}
       if(@($paths|Where-Object{$_-match'^lib/(Owner-|Invoke-Owner|Test-Owner|Coordinator|Watch-|Delegate|Invoke-Contract|lifecycle)'}).Count){$profiles+='COORDINATION'}
       if(@($paths|Where-Object{$_-match'(WORKSTATION|[Dd]octor|[Bb]ootstrap|[Pp]repare)'}).Count){$profiles+='WORKSTATION'}
       if(@($paths|Where-Object{$_-match'^lib/(Backup|Restore)'}).Count){$profiles+='RECOVERY'}
       if(@($paths|Where-Object{$_-match'^\.github/'}).Count){$profiles+='CI'}
       $profiles|Sort-Object -Unique
   }
   function Get-WorkbenchBlobChecks($record,[string[]]$scope) {
       $checks=@([regex]::Matches($record.Sections['Acceptance Criteria'],'(?m)check: (?<clause>[^\n]+)$'))
       $seen=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
       foreach($check in $checks){
           $clause=$check.Groups['clause'].Value.Trim()
           if($clause-cmatch'^blob:(?<path>.+)=(?<sha>[0-9a-f]{40})$'){$kind='blob';$checkPath=$Matches.path;$expectedValue=$Matches.sha}
           elseif($clause-cmatch'^normalized-resume:(?<path>RESUME\.md)=(?<sha>[0-9A-F]{64})$'){$kind='normalized-resume';$checkPath=$Matches.path;$expectedValue=$Matches.sha}
           else{throw 'WB_CHECK_CLAUSE_INVALID_OR_UNSUPPORTED'}
           if($checkPath-cnotin$scope-or!$seen.Add($checkPath)){throw 'WB_BLOB_CHECK_SCOPE_OR_DUPLICATE'}
           [pscustomobject]@{Kind=$kind;Path=$checkPath;Value=$expectedValue}
       }
   }
   function Get-WorkbenchStepDeclarations($record,[string[]]$scope) {
       # Declaration closure only; the accepted existing applier owns operation interpretation.
       $items=@([regex]::Split($record.Sections['Implementation Steps'],'(?m)^(?=\d+\. )')|Where-Object{$_-match'^\d+\. Check whether '})
       $seen=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
       foreach($item in $items){
           $target=[regex]::Match($item,'^\d+\. Check whether `(?<path>[^`]+)` contains `[^`]+`')
           $outputBlob=@([regex]::Matches($item,"(?m)^   The resulting file's Git blob is (?<blob>[0-9a-f]{40})\.$"))
           if(!$target.Success-or$outputBlob.Count-ne1){throw 'WB_LITERAL_STEP_DECLARATION_INVALID'}
           $targetPath=$target.Groups['path'].Value
           if($targetPath-cnotin$scope-or!$seen.Add($targetPath)){throw 'WB_LITERAL_STEP_SCOPE_OR_DUPLICATE'}
           [pscustomobject]@{Path=$targetPath;Kind='blob';Value=$outputBlob[0].Groups['blob'].Value}
       }
   }
   function Get-WorkbenchApprovalValues($record) {
       $values=@{}
       foreach($field in 'Approved Draft','Approved SHA256','Owner Evidence','Owner Evidence SHA256','Execution Root'){
           $found=@([regex]::Matches($record.Sections['Execution Log'],'(?m)^'+[regex]::Escape($field)+': (?<value>[^\n]+)$'))
           if($found.Count-ne1){throw "WB_APPROVAL_MISSING_OR_DUPLICATED:$field"}
           $values[$field]=$found[0].Groups['value'].Value.Trim()
       }
       $values
   }
   function Get-WorkbenchResumeDigest([string]$Text) {
       Get-WorkbenchDigest (($Text-replace'\r\n',([string][char]10))-replace'(?m)^Active Workbench Contract: [^\n]+','Active Workbench Contract: NORMALIZED')
   }
   function Get-WorkbenchPointer([string]$Text,[switch]$AllowMissing) {
       $pointers=@([regex]::Matches($Text,'(?m)^Active Workbench Contract: (?<path>None|changes/WS-[0-9]{3}-[A-Za-z0-9-]+\.md)\r?$'))
       if(!$pointers.Count-and$AllowMissing){return 'None'}
       if($pointers.Count-ne1){throw 'WB_ACTIVE_POINTER_INVALID'}
       $pointers[0].Groups['path'].Value
   }
   function Assert-WorkbenchArtifact([string]$path,[string]$Digest) {
       if(![IO.Path]::IsPathFullyQualified($path)-or$Digest-cnotmatch'^[0-9A-F]{64}$'){throw 'WB_ARTIFACT_IDENTITY_INVALID'}
       $item=Get-Item -LiteralPath $path -Force -ErrorAction Stop
       if($item.PSIsContainer-or($item.Attributes-band[IO.FileAttributes]::ReparsePoint)-or
          (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash-cne$Digest){throw 'WB_ARTIFACT_CHANGED'}
   }
   function Assert-WorkbenchApproval($record,[string]$Checkout) {
       $values=Get-WorkbenchApprovalValues $record
       Assert-WorkbenchArtifact $values['Approved Draft'] $values['Approved SHA256']
       Assert-WorkbenchArtifact $values['Owner Evidence'] $values['Owner Evidence SHA256']
       if(![IO.Path]::IsPathFullyQualified($values['Execution Root'])-or
          [IO.Path]::GetFullPath($values['Execution Root'])-ine[IO.Path]::GetFullPath($Checkout)){throw 'WB_APPROVAL_ROOT_MISMATCH'}
       if(![IO.File]::ReadAllText($values['Owner Evidence']).Contains($values['Approved SHA256'],[StringComparison]::Ordinal)){throw 'WB_OWNER_EVIDENCE_SUBJECT_MISMATCH'}
       if(![IO.File]::ReadAllText($values['Owner Evidence']).Contains($values['Execution Root'],[StringComparison]::Ordinal)){throw 'WB_OWNER_EVIDENCE_ROOT_MISMATCH'}
       $draft=Get-WorkbenchFields ([IO.File]::ReadAllText($values['Approved Draft']))
       if($draft.Status-cne'Draft'-or(Get-WorkbenchFrozen $draft)-cne(Get-WorkbenchFrozen $record)){throw 'WB_APPROVED_AUTHORITY_CHANGED'}
       $identities=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
       $paths=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
       foreach($version in 1..3){
           $assurance=@([regex]::Matches($record.Sections['Draft Assurance'],'(?m)^V'+$version+': (?<id>[^|\n]+) \| (?<date>[0-9]{4}-[0-9]{2}-[0-9]{2}) \| (?<path>[^|\n]+) \| (?<hash>[0-9A-F]{64}|SELECTED)$'))
           if($assurance.Count-ne1){throw 'WB_THREE_PASS_MISSING_OR_DUPLICATED'}
           $entry=$assurance[0].Groups
           $dateValue=[DateTime]::MinValue
           if(![DateTime]::TryParseExact($entry['date'].Value,'yyyy-MM-dd',[Globalization.CultureInfo]::InvariantCulture,[Globalization.DateTimeStyles]::None,[ref]$dateValue)-or$dateValue.Date-gt[DateTime]::UtcNow.Date){throw 'WB_ASSURANCE_DATE_INVALID'}
           if(!$identities.Add($entry['id'].Value.Trim())-or!$paths.Add($entry['path'].Value.Trim())){throw 'WB_THREE_PASS_IDENTITY_DUPLICATED'}
           if($version-eq3){
               if($entry['hash'].Value-cne'SELECTED'-or$entry['path'].Value.Trim()-cne$values['Approved Draft']){throw 'WB_SELECTED_DRAFT_MISMATCH'}
           }else{Assert-WorkbenchArtifact $entry['path'].Value.Trim() $entry['hash'].Value}
       }
       if($record.Sections['Draft Assurance']-notmatch'(?m)^Selected Version: V3$'){throw 'WB_SELECTED_VERSION_INVALID'}
   }
   function Get-WorkbenchFingerprint([string]$Checkout,[string]$tree,[string]$contract) {
       $rows=@(Invoke-WorkbenchGit $Checkout @('ls-tree','-r',$tree))
       $inputs=@()
       foreach($row in $rows){
           if($row-notmatch'^(?<mode>[0-9]+) blob (?<blob>[0-9a-f]{40})\t(?<path>.+)$'){throw 'WB_UNSUPPORTED_TREE_ENTRY'}
           $modeValue=$Matches.mode;$blobValue=$Matches.blob;$pathValue=$Matches.path
           if($modeValue-cnotin@('100644','100755')){throw 'WB_NONREGULAR_TREE_ENTRY_REFUSED'}
           if($pathValue-eq$contract){$blobValue=Get-WorkbenchDigest (Get-WorkbenchFrozen (Get-WorkbenchFields (Get-WorkbenchText $Checkout $tree $pathValue)))}
           elseif($pathValue-eq'RESUME.md'){$blobValue=Get-WorkbenchResumeDigest (Get-WorkbenchText $Checkout $tree $pathValue)}
           $inputs+="$modeValue $blobValue $pathValue"
       }
       Get-WorkbenchDigest ($inputs-join[char]10)
   }
   function Read-WorkbenchReceipt([string]$Checkout,[string]$Digest) {
       $receiptPath=if($Digest){Get-WorkbenchLocalPath $Checkout ".workbench-certifications/$Digest.json"}else{Get-WorkbenchLocalPath $Checkout '.workbench-local-certification.json'}
       if(!(Test-Path -LiteralPath $receiptPath -PathType Leaf)){throw 'WB_RECEIPT_MISSING'}
       $receiptText=[IO.File]::ReadAllText($receiptPath)
       $json=[System.Text.Json.JsonDocument]::Parse($receiptText)
       try{
           $names=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
           foreach($property in $json.RootElement.EnumerateObject()){if(!$names.Add($property.Name)){throw 'WB_RECEIPT_DUPLICATE_MEMBER'}}
           if($json.RootElement.GetProperty('schema').ValueKind-ne[System.Text.Json.JsonValueKind]::Number-or
              $json.RootElement.GetProperty('schema').GetInt32()-ne1){throw 'WB_RECEIPT_SCHEMA_INVALID'}
           if((@($names|Sort-Object)-join',')-cne'contract,digest,evaluator,fingerprint,finishHead,profiles,result,root,runLog,runStart,schema'){throw 'WB_RECEIPT_FIELDS_INVALID'}
       }finally{$json.Dispose()}
       $value=$receiptText|ConvertFrom-Json -ErrorAction Stop
       if($value.schema-ne1-or$value.result-cne'READY'){throw 'WB_RECEIPT_INVALID'}
       $expected=$value.digest
       $material=[ordered]@{schema=$value.schema;root=$value.root;contract=$value.contract;finishHead=$value.finishHead;fingerprint=$value.fingerprint;profiles=@($value.profiles);evaluator=$value.evaluator;runLog=$value.runLog;runStart=$value.runStart;result=$value.result}
       if((Get-WorkbenchDigest ($material|ConvertTo-Json -Compress -Depth 5))-cne$expected){throw 'WB_RECEIPT_DIGEST_INVALID'}
       $value
   }
   function Assert-WorkbenchCompletion([string]$Checkout,[string]$tree,[string]$contract,$record,[string[]]$profiles,[switch]$Historical) {
       foreach($section in 'Acceptance Criteria','Review Gate'){
           if($record.Sections[$section]-match'(?m)^- \[ \] '-or$record.Sections[$section]-notmatch'(?m)^- \[x\] '){throw 'WB_COMPLETION_CRITERIA_OPEN'}
       }
       if($record.Sections['Verification Notes']-notmatch'(?m)^Verdict: Confirmed Complete$'-or
          $record.Sections['Runtime Checkpoint']-notmatch'(?m)^Resume Step: DONE$'-or
          $record.Sections['Runtime Checkpoint']-notmatch'(?m)^Blocker: None$'){throw 'WB_LIVE_REVIEW_MISSING'}
       $fingerprint=Get-WorkbenchFingerprint $Checkout $tree $contract
       $reviewed=@([regex]::Matches($record.Sections['Verification Notes'],'(?m)^Reviewed Receipt: (?<digest>[0-9A-F]{64})$'))
       if(!$reviewed.Count){throw 'WB_REVIEW_RECEIPT_MISSING'}
       $reviewDigest=$reviewed[-1].Groups['digest'].Value
       $receipt=Read-WorkbenchReceipt $Checkout $reviewDigest
       if(!$Historical){$working=Read-WorkbenchReceipt $Checkout;if($working.digest-cne$reviewDigest){throw 'WB_WORKING_RECEIPT_NOT_REVIEWED'}}
       $evaluator=@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${tree}:lib/Test-WorkbenchChange.ps1"))[0]
       if([IO.Path]::GetFullPath($receipt.root)-ine[IO.Path]::GetFullPath($Checkout)-or
          $receipt.finishHead-cnotmatch'^[0-9a-f]{40}$'-or
          $receipt.contract-cne$contract-or$receipt.fingerprint-cne(Get-WorkbenchFingerprint $Checkout $tree $contract)-or
          $receipt.evaluator-cne$evaluator-or(@($receipt.profiles)-join',')-cne($profiles-join',')){throw 'WB_RECEIPT_STALE_OR_WRONG_SUBJECT'}
       if($record.Sections['Verification Notes']-notmatch('(?m)^Reviewed Fingerprint: '+[regex]::Escape($fingerprint)+'$')){throw 'WB_REVIEW_SUBJECT_MISSING'}
       $log=[IO.File]::ReadAllLines($receipt.runLog)
       if(!$log.Count-or$log[0]-cne$receipt.runStart-or-not@($log|Where-Object{$_-match'^\[\+[^]]+ min\] END exit=0 '}).Count){throw 'WB_TIMED_RUN_NOT_SUCCESSFUL'}
   }
   function Test-WorkbenchTree([string]$Checkout,[string]$Before,[string]$After,[switch]$RequireWorkingMatch,[switch]$Historical) {
       $paths=@(Invoke-WorkbenchGit $Checkout @('diff','--name-only','--no-renames',$Before,$After))
       $beforeFiles=@(Invoke-WorkbenchGit $Checkout @('ls-tree','-r','--name-only',$Before))
       $afterFiles=@(Invoke-WorkbenchGit $Checkout @('ls-tree','-r','--name-only',$After))
       $caseNames=[Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
       foreach($path in $afterFiles){if(!$caseNames.Add($path)){throw 'WB_CASE_COLLISION_TREE'}}
       foreach($path in $afterFiles){if($path-match'^(sessions|events|work)(/|$)'-or$path-match'^\.workbench-'){throw 'WB_LOCAL_DATA_REFUSED'}}
       # Bounded known credential shapes, based on the existing watcher's redaction vocabulary.
       # This is not a complete secret detector; values are never printed.
       foreach($path in $paths|Where-Object{$afterFiles-ccontains$_}){
           $content=Get-WorkbenchText $Checkout $After $path
           if($content-match'\b(gh[pousr]_[A-Za-z0-9]{20,}|github_pat_\w{20,}|sk-[A-Za-z0-9_-]{20,})|-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----'){throw "WB_CREDENTIAL_SHAPED_CONTENT_REFUSED:$path"}
       }
       $pointer=Get-WorkbenchPointer (Get-WorkbenchText $Checkout $After 'RESUME.md') -AllowMissing:($afterFiles-cnotcontains'WORKFLOW.md')
       $priorPointer=if($beforeFiles-contains'WORKFLOW.md'){Get-WorkbenchPointer (Get-WorkbenchText $Checkout $Before 'RESUME.md')}else{'None'}
       $contract=if($pointer-ne'None'){$pointer}elseif($priorPointer-ne'None'){$priorPointer}else{@($paths|Where-Object{$_-cmatch'^changes/WS-[0-9]{3}-[A-Za-z0-9-]+\.md$'})}
       if(@($contract).Count-ne1-or!$contract){if(!$paths.Count){return $null};throw 'WB_GOVERNING_CONTRACT_MISSING_OR_AMBIGUOUS'}
       if($afterFiles-cnotcontains$contract){throw 'WB_CONTRACT_MISSING'}
       $record=Get-WorkbenchFields (Get-WorkbenchText $Checkout $After $contract)
       if($contract-cnotmatch('^changes/'+[regex]::Escape($record.Id)+'-[A-Za-z0-9-]+\.md$')){throw 'WB_CONTRACT_PATH_ID_MISMATCH'}
       $scope=@(Get-WorkbenchScope $record)
       $blobChecks=@(Get-WorkbenchBlobChecks $record $scope)
       $stepDeclarations=@(Get-WorkbenchStepDeclarations $record $scope)
       if(@($stepDeclarations|Where-Object{$_.Path-ceq'RESUME.md'}).Count-and
          @($blobChecks|Where-Object{$_.Kind-ceq'normalized-resume'}).Count-ne1){throw 'WB_RESUME_NORMALIZATION_CHECK_REQUIRED'}
       foreach($pin in $blobChecks|Where-Object{$_.Kind-ceq'blob'}){
           $declared=@($stepDeclarations|Where-Object{$_.Path-ceq$pin.Path})
           if($declared.Count-and$declared[0].Value-cne$pin.Value){throw 'WB_CONTRADICTORY_BLOB_PREDICATE'}
       }
       $profiles=@(Get-WorkbenchProfiles $scope)
       if($record.Status-in@('Approved','In Progress')-and('CI'-in$profiles-or'WORKSTATION'-in$profiles)){throw 'WB_PROFILE_CAPABILITY_NOT_YET_IMPLEMENTED'}
       $baseline=$record.Sections['Baseline'].Trim()
       if($baseline-cnotmatch'^[0-9a-f]{40}$'){throw 'WB_BASELINE_INVALID'}
       & git -C $Checkout merge-base --is-ancestor $baseline $Before 2>$null
       if($LASTEXITCODE-ne0){throw 'WB_BASELINE_NOT_ANCESTOR'}
       $oldRecord=$null
       $initialImport=$false
       if($beforeFiles-ccontains$contract){$oldRecord=Get-WorkbenchFields (Get-WorkbenchText $Checkout $Before $contract)}
       if($oldRecord){
           $legal=@{Draft=@('Draft','Approved','Cancelled');Approved=@('Approved','In Progress','Cancelled');'In Progress'=@('In Progress','Complete','Cancelled');Complete=@('Complete');Cancelled=@('Cancelled')}
           if($record.Status-cnotin$legal[$oldRecord.Status]){throw 'WB_ILLEGAL_TRANSITION'}
           if($oldRecord.Status-ne'Draft'-and(Get-WorkbenchFrozen $oldRecord)-cne(Get-WorkbenchFrozen $record)){throw 'WB_FROZEN_AUTHORITY_CHANGED'}
           foreach($appendOnly in 'Execution Log','Verification Notes'){
               if(!$record.Sections[$appendOnly].StartsWith($oldRecord.Sections[$appendOnly],[StringComparison]::Ordinal)){throw 'WB_EVIDENCE_HISTORY_REWRITTEN'}
           }
           if($oldRecord.Status-in@('Complete','Cancelled')-and(Get-WorkbenchText $Checkout $Before $contract)-cne(Get-WorkbenchText $Checkout $After $contract)){throw 'WB_TERMINAL_CONTRACT_IMMUTABLE'}
       }elseif($record.Status-ne'Draft'){
           # One initial import: exact externally approved Draft, before any kernel implementation.
           # Existing installations never gain a second allocation route.
           $initialImport=$record.Status-ceq'Approved'-and$beforeFiles-cnotcontains'WORKFLOW.md'-and
               $beforeFiles-cnotcontains'lib/Test-WorkbenchChange.ps1'-and$afterFiles-cnotcontains'WORKFLOW.md'-and
               $afterFiles-cnotcontains'lib/Test-WorkbenchChange.ps1'-and
               !@($paths|Where-Object{$_-cnotin@($contract,'RESUME.md')}).Count
           if(!$initialImport){throw 'WB_ALLOCATION_MUST_BE_DRAFT'}
       }
       if($record.Status-in@('Approved','In Progress','Complete')){Assert-WorkbenchApproval $record $Checkout}
       foreach($path in $paths){
           if($path-ceq$contract){continue}
           if($path-cnotin$scope){throw "WB_WRITE_SCOPE_REFUSED:$path"}
           if($record.Status-eq'Draft'){throw 'WB_DRAFT_IMPLEMENTATION_REFUSED'}
           if($record.Status-in@('Complete','Cancelled')){
               if($path-cne'RESUME.md'){throw 'WB_TERMINAL_IMPLEMENTATION_REFUSED'}
               $oldResume=(Get-WorkbenchText $Checkout $Before 'RESUME.md')-replace'(?m)^Active Workbench Contract: [^\n]+','Active Workbench Contract: NORMALIZED'
               $newResume=(Get-WorkbenchText $Checkout $After 'RESUME.md')-replace'(?m)^Active Workbench Contract: [^\n]+','Active Workbench Contract: NORMALIZED'
               if($oldResume-cne$newResume){throw 'WB_TERMINAL_ROUTER_EDIT_REFUSED'}
           }
           if($path-ceq'RESUME.md'-and$initialImport){
               $oldResume=Get-WorkbenchText $Checkout $Before 'RESUME.md'
               $newResume=(Get-WorkbenchText $Checkout $After 'RESUME.md')-replace'(?m)^Active Workbench Contract: [^\n]+\n?',''
               if($oldResume.TrimEnd([char]10,[char]13)-cne$newResume.TrimEnd([char]10,[char]13)){throw 'WB_INITIAL_IMPORT_IMPLEMENTATION_REFUSED'}
           }
           $declaredOutput=@($stepDeclarations|Where-Object{$_.Path-ceq$path})
           if($declaredOutput.Count-and$path-cne'RESUME.md'){
               if($afterFiles-cnotcontains$path-or@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${After}:$path"))[0]-cne$declaredOutput[0].Value){throw 'WB_DECLARED_OUTPUT_MISMATCH'}
           }
           if($declaredOutput.Count-and$path-ceq'RESUME.md'-and!$initialImport){
               $oldRoute=Get-WorkbenchResumeDigest (Get-WorkbenchText $Checkout $Before 'RESUME.md')
               $newRoute=Get-WorkbenchResumeDigest (Get-WorkbenchText $Checkout $After 'RESUME.md')
               if($oldRoute-cne$newRoute-and@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${After}:$path"))[0]-cne$declaredOutput[0].Value){throw 'WB_DECLARED_ROUTING_OUTPUT_MISMATCH'}
           }
           if($path-match'\.ps1$|^\.githooks/'){
               $pin=@($blobChecks|Where-Object{$_.Path-ceq$path})
               if(!$pin.Count){$pin=$declaredOutput}
               if($pin.Count-ne1-or$afterFiles-cnotcontains$path){throw 'WB_CONTROL_PIN_REQUIRED'}
               $actualControl=@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${After}:$path"))[0]
               if($pin[0].Kind-cne'blob'-or$actualControl-cne$pin[0].Value){throw 'WB_UNAPPROVED_CONTROL_BYTES'}
           }
           if($path-cmatch'^changes/WS-' -and $path-cne$contract){throw 'WB_UNRELATED_CONTRACT_REFUSED'}
       }
       if($record.Status-in@('Draft','Complete','Cancelled')-and$pointer-ne'None'){throw 'WB_ACTIVE_STATUS_CONTRADICTION'}
       if($record.Status-in@('Approved','In Progress')-and$pointer-cne$contract){throw 'WB_ACTIVE_CONTRACT_MISMATCH'}
       if($RequireWorkingMatch){
           if(@(Invoke-WorkbenchGit $Checkout @('diff','--name-only','--no-renames')).Count-or
              @(Invoke-WorkbenchGit $Checkout @('ls-files','--others','--exclude-standard')).Count){throw 'WB_WORKING_INDEX_MISMATCH'}
           foreach($path in $paths){
               if($afterFiles-ccontains$path){
                   $workingPath=Get-WorkbenchLocalPath $Checkout $path
                   if(!(Test-Path -LiteralPath $workingPath -PathType Leaf)){throw 'WB_WORKING_INDEX_MISMATCH'}
                   $workingBlob=@(Invoke-WorkbenchGit $Checkout @('hash-object',"--path=$path",'--',$workingPath))[0]
                   $treeBlob=@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${After}:$path"))[0]
                   if($workingBlob-cne$treeBlob){throw 'WB_WORKING_INDEX_MISMATCH'}
               }
           }
       }
       if($record.Status-eq'Complete'){
           foreach($declaredOutput in $stepDeclarations|Where-Object{$_.Path-cne'RESUME.md'}){
               if($afterFiles-cnotcontains$declaredOutput.Path-or@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${After}:$($declaredOutput.Path)"))[0]-cne$declaredOutput.Value){throw 'WB_COMPLETION_DECLARED_OUTPUT_MISMATCH'}
           }
           foreach($pin in $blobChecks){
               if($afterFiles-cnotcontains$pin.Path){throw 'WB_COMPLETION_BLOB_MISMATCH'}
               $actualPin=if($pin.Kind-ceq'blob'){@(Invoke-WorkbenchGit $Checkout @('rev-parse',"${After}:$($pin.Path)"))[0]}else{Get-WorkbenchResumeDigest (Get-WorkbenchText $Checkout $After $pin.Path)}
               if($actualPin-cne$pin.Value){throw 'WB_COMPLETION_BLOB_MISMATCH'}
           }
           Assert-WorkbenchCompletion $Checkout $After $contract $record $profiles -Historical:$Historical
       }
       [pscustomobject]@{Contract=$contract;Status=$record.Status;Profiles=$profiles;Scope=$scope;Fingerprint=(Get-WorkbenchFingerprint $Checkout $After $contract)}
   }
   if($MyInvocation.InvocationName-eq'.'){return}
   $operationLease=$null
   try {
       if($ExpectedEvaluatorSha256-and(Get-FileHash -LiteralPath $PSCommandPath).Hash-cne$ExpectedEvaluatorSha256){throw 'WB_BOOTSTRAP_EVALUATOR_CHANGED'}
       $Root=Assert-WorkbenchRoot $Root
       if($Mode-eq'Gate'-and$Staged){$operationLease=Enter-WorkbenchOperation $Root}
       if($Mode-eq'Boot'){
           $pointer=Get-WorkbenchPointer ([IO.File]::ReadAllText((Join-Path $Root 'RESUME.md')))
           $dirty=@(Invoke-WorkbenchGit $Root @('status','--porcelain','--untracked-files=all'))
           if($dirty.Count){throw 'WB_WORKING_TREE_DIRTY'}
           if($pointer-eq'None'){$bootLines=@('MODE: PLAN','ACTION: Read RESUME.md for the current task; prepare an isolated Draft and obtain its exact Gate 1 before original writes','START_CONTEXT: WORKFLOW.md, RESUME.md','WRITE: none (isolated preparation only)')}else{
               $active=Get-WorkbenchFields ([IO.File]::ReadAllText((Join-Path $Root $pointer)))
               if($pointer-cnotmatch('^changes/'+[regex]::Escape($active.Id)+'-[A-Za-z0-9-]+\.md$')){throw 'WB_CONTRACT_PATH_ID_MISMATCH'}
               if($active.Status-cnotin@('Approved','In Progress')){throw 'WB_ACTIVE_STATUS_CONTRADICTION'}
               Assert-WorkbenchApproval $active $Root
               if($active.Checkpoint.Blocker-cne'None'){throw ('WB_RUNTIME_BLOCKER:'+$active.Checkpoint.Blocker)}
               $nextAction=if($active.Status-ceq'Approved'){'Record In Progress under the approved contract, then execute its literal steps'}elseif($active.Checkpoint['Resume Step']-ceq'DONE'){'Use the existing run/receipt evidence; perform only the missing Finish, live Review or Complete stage'}else{'Execute implementation step '+$active.Checkpoint['Resume Step']+' through the scope-checked entry'}
               $bootLines=@("STATUS: $($active.Status)","STEP: $($active.Checkpoint['Resume Step'])","BLOCKER: None","ACTION: $nextAction","START_CONTEXT: WORKFLOW.md, $pointer","WRITE: $((Get-WorkbenchScope $active)-join', ')","PROFILES: $((Get-WorkbenchProfiles @(Get-WorkbenchScope $active))-join', ')")
           }
           'WORKBENCH: READY';"ACTIVE_CONTRACT: $pointer";$bootLines
       }elseif($Mode-eq'Range'){
           if($Base-cnotmatch'^[0-9a-f]{40}$'-or$Head-cnotmatch'^[0-9a-f]{40}$'){throw 'WB_FULL_RANGE_SHA_REQUIRED'}
           & git -C $Root merge-base --is-ancestor $Base $Head 2>$null;if($LASTEXITCODE){throw 'WB_RANGE_DIVERGED'}
           foreach($commit in @(Invoke-WorkbenchGit $Root @('rev-list','--reverse',"$Base..$Head"))){
               $parents=@(@(Invoke-WorkbenchGit $Root @('rev-list','--parents','-n','1',$commit))[0]-split' ')
               if($parents.Count-ne2){throw 'WB_MERGE_RANGE_REFUSED'}
               $null=Test-WorkbenchTree $Root $parents[1] $commit -Historical
           }
           'WORKBENCH: READY';'EVIDENCE: every range transition checked'
       }else{
           $tree=if($Staged){@(Invoke-WorkbenchGit $Root @('write-tree'))[0]}else{@(Invoke-WorkbenchGit $Root @('rev-parse',"$Head^{tree}"))[0]}
           $result=Test-WorkbenchTree $Root $Base $tree -RequireWorkingMatch:$Staged
           'WORKBENCH: READY'
           if($result){"CONTRACT: $($result.Contract)";"STATUS: $($result.Status)";"PROFILES: $($result.Profiles-join', ')"}
       }
       exit 0
   }catch{ 'WORKBENCH: BLOCKED';"CODE: $($_.Exception.Message)";exit 1 }
   finally{if($operationLease){$operationLease.Dispose()}}
   ```

   The resulting file's Git blob is 8365653fb8264fac3d522d2bc9a2df5a29a69453.

10. Check whether `lib/Workbench.ps1` contains `Operational entry for Workbench's own cycle`; if so record Already Applied when its Git blob is 3dee99dee892e5f3cb1ccc905f861cf344abfdee, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (the bounded Workbench local governance kernel), and change nothing else:

   ```text
   # Operational entry for Workbench's own cycle. Native product dispatch is a later contract.
   [CmdletBinding(DefaultParameterSetName='Boot')]
   param([Parameter(ParameterSetName='Boot',Mandatory)][switch]$Boot,
         [Parameter(ParameterSetName='Gate',Mandatory)][switch]$Gate,
         [Parameter(ParameterSetName='Finish',Mandatory)][switch]$Finish,
         [Parameter(ParameterSetName='Review',Mandatory)][switch]$Review,
         [Parameter(ParameterSetName='Complete',Mandatory)][switch]$Complete,
         [Parameter(ParameterSetName='Execute',Mandatory)][switch]$Execute,
         [Parameter(ParameterSetName='Gate')][switch]$Staged,
         [Parameter(ParameterSetName='Gate')][string]$Base='HEAD',
         [Parameter(ParameterSetName='Gate')][string]$Head,
         [string]$Root=(Split-Path $PSScriptRoot -Parent),
         [string]$BootstrapJudge,[string]$BootstrapSha256)
   $ErrorActionPreference='Stop'
   try{[Console]::OutputEncoding=[Text.UTF8Encoding]::new($false)}catch{}
   $temporaryJudge=$null
   $operationLease=$null
   $toolDirectory=$null
   $temporaryParent=if($env:WORKBENCH_TEMP_ROOT){[IO.Path]::GetFullPath($env:WORKBENCH_TEMP_ROOT)}else{Join-Path ([IO.Path]::GetTempPath()) 'ORVION-Workbench'}
   function Read-WorkbenchEntryGit([string[]]$Arguments) {
       $outputLines=@(& git -C $Root @Arguments 2>$null)
       if($LASTEXITCODE-ne0){throw 'WB_ENTRY_GIT_UNREADABLE'}
       $outputLines
   }
   function Get-WorkbenchAcceptedJudge {
       $files=@(Read-WorkbenchEntryGit @('ls-tree','-r','--name-only','HEAD'))
       if($files-ccontains'lib/Test-WorkbenchChange.ps1'){
           $expectedBlob=@(Read-WorkbenchEntryGit @('rev-parse','HEAD:lib/Test-WorkbenchChange.ps1'))[0]
           $judgeParent=Join-Path $temporaryParent 'judges'
           [void][IO.Directory]::CreateDirectory($judgeParent)
           $script:temporaryJudge=Join-Path $judgeParent ('wb-judge-'+[guid]::NewGuid().ToString('N')+'.ps1')
           $text=(@(Read-WorkbenchEntryGit @('show','HEAD:lib/Test-WorkbenchChange.ps1'))-join[char]10)+[char]10
           [IO.File]::WriteAllText($script:temporaryJudge,$text,[Text.UTF8Encoding]::new($false))
           $actualBlob=@(Read-WorkbenchEntryGit @('hash-object','--no-filters','--',$script:temporaryJudge))[0]
           if($actualBlob-cne$expectedBlob){throw 'WB_ACCEPTED_JUDGE_BYTES_MISMATCH'}
           return $script:temporaryJudge
       }
       if(!$BootstrapJudge-or$BootstrapSha256-cnotmatch'^[0-9A-F]{64}$'-or
          ![IO.Path]::IsPathFullyQualified($BootstrapJudge)-or
          (Get-FileHash -LiteralPath $BootstrapJudge -Algorithm SHA256).Hash-cne$BootstrapSha256){throw 'WB_EXPLICIT_REVIEWED_BOOTSTRAP_REQUIRED'}
       $fullJudge=[IO.Path]::GetFullPath($BootstrapJudge)
       if($fullJudge.StartsWith($Root.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'WB_BOOTSTRAP_INSIDE_SUBJECT_REFUSED'}
       $fullJudge
   }
   try {
       $Root=[IO.Path]::GetFullPath($Root)
       if($temporaryParent-ieq$Root-or$temporaryParent.StartsWith($Root.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'WB_TEMP_ROOT_INSIDE_CHECKOUT_REFUSED'}
       if([IO.Path]::GetFullPath($PSCommandPath)-ine(Join-Path $Root 'lib/Workbench.ps1')){throw 'WB_ENTRY_ROOT_MISMATCH'}
       $judge=Get-WorkbenchAcceptedJudge
       if($Boot){& pwsh -NoProfile -File $judge -Root $Root -Mode Boot;exit $LASTEXITCODE}
       if($Gate){
           if($Head){& pwsh -NoProfile -File $judge -Root $Root -Mode Range -Base $Base -Head $Head}
           else{& pwsh -NoProfile -File $judge -Root $Root -Mode Gate -Base $Base -Staged:$Staged}
           exit $LASTEXITCODE
       }
       . $judge -Root $Root
       $Root=Assert-WorkbenchRoot $Root
       $operationLease=Enter-WorkbenchOperation $Root
       $contract=Get-WorkbenchPointer ([IO.File]::ReadAllText((Join-Path $Root 'RESUME.md')))
       if($contract-eq'None'){throw 'WB_ACTIVE_CONTRACT_REQUIRED'}
       $contractFile=Get-WorkbenchLocalPath $Root $contract
       $record=Get-WorkbenchFields ([IO.File]::ReadAllText($contractFile))
       if($record.Status-cne'In Progress'){throw 'WB_IN_PROGRESS_REQUIRED'}
       if($record.Checkpoint.Blocker-cne'None'){throw ('WB_RUNTIME_BLOCKER:'+$record.Checkpoint.Blocker)}
       Assert-WorkbenchApproval $record $Root
       $dirty=@(Read-WorkbenchEntryGit @('status','--porcelain','--untracked-files=all'))
       if($dirty.Count){throw 'WB_CLEAN_IMPLEMENTATION_REQUIRED'}
       $finishHead=@(Read-WorkbenchEntryGit @('rev-parse','HEAD'))[0]
       $tree=@(Read-WorkbenchEntryGit @('rev-parse','HEAD^{tree}'))[0]
       $profiles=@(Get-WorkbenchProfiles @(Get-WorkbenchScope $record))
       $fingerprint=Get-WorkbenchFingerprint $Root $tree $contract
       if($Execute){
           $approval=Get-WorkbenchApprovalValues $record
           $selectedDraft=$approval['Approved Draft']
           $toolDirectory=Join-Path $temporaryParent ('tools/workbench-approved-applier-'+[guid]::NewGuid().ToString('N'))
           [void][IO.Directory]::CreateDirectory($toolDirectory)
           foreach($tool in 'apply-draft-steps.ps1','Invoke-DraftSteps.ps1'){
               $toolText=(@(Read-WorkbenchEntryGit @('show',('HEAD:lib/'+$tool)))-join[char]10)+[char]10
               $toolPath=Join-Path $toolDirectory $tool
               [IO.File]::WriteAllText($toolPath,$toolText,[Text.UTF8Encoding]::new($false))
               $expectedTool=@(Read-WorkbenchEntryGit @('rev-parse',('HEAD:lib/'+$tool)))[0]
               $actualTool=@(Read-WorkbenchEntryGit @('hash-object','--no-filters','--',$toolPath))[0]
               if($actualTool-cne$expectedTool){throw 'WB_ACCEPTED_APPLIER_BYTES_MISMATCH'}
           }
           $applier=Join-Path $toolDirectory 'apply-draft-steps.ps1'
           $planLines=@(& pwsh -NoProfile -File $applier -Draft $selectedDraft -Root $Root -Plan 2>&1);$planExit=$LASTEXITCODE
           if($planExit-ne0){throw 'WB_EXECUTION_PLAN_UNREADABLE'}
           $plan=($planLines-join[char]10)|ConvertFrom-Json -ErrorAction Stop
           if($plan.Schema-ne1-or[IO.Path]::GetFullPath($plan.Root)-ine$Root-or$plan.DraftSHA256-cne$approval['Approved SHA256']-or!@($plan.Files).Count){throw 'WB_EXECUTION_PLAN_IDENTITY_MISMATCH'}
           $scope=@(Get-WorkbenchScope $record)
           foreach($item in $plan.Files){if($item.File-cnotin$scope){throw 'WB_EXECUTION_PLAN_OUTSIDE_SCOPE'}}
           Assert-WorkbenchArtifact $selectedDraft $approval['Approved SHA256']
           & pwsh -NoProfile -File $applier -Draft $selectedDraft -Root $Root
           if($LASTEXITCODE-ne0){throw 'WB_LITERAL_EXECUTION_FAILED'}
           'WORKBENCH_EXECUTE: DONE (normal scoped commit and verification still required)'
       }elseif($Finish){
           if(!$env:ORVION_TIMED_LOG-or!(Test-Path -LiteralPath $env:ORVION_TIMED_LOG -PathType Leaf)-or
              !$env:ORVION_TIMED_ROOT-or[IO.Path]::GetFullPath($env:ORVION_TIMED_ROOT)-ine$Root){throw 'WB_FINISH_NOT_TIMED_FROM_OWN_ROOT'}
           $runLog=[IO.Path]::GetFullPath($env:ORVION_TIMED_LOG)
           if($runLog.StartsWith($Root.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'WB_LOG_INSIDE_CHECKOUT_REFUSED'}
           $logStream=[IO.File]::Open($runLog,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
           $logReader=[IO.StreamReader]::new($logStream,[Text.Encoding]::UTF8,$true)
           try{$runStart=$logReader.ReadLine()}finally{$logReader.Dispose()}
           if($runStart-notmatch'^\[[^]]+\] START pid=[0-9]+ '){throw 'WB_TIMED_START_INVALID'}
           $runnerId=0
           if(![int]::TryParse($env:ORVION_TIMED_PID,[ref]$runnerId)-or$runStart-notmatch(' START pid='+$runnerId+' ')){throw 'WB_TIMED_RUNNER_ID_INVALID'}
           $ancestorId=$PID;$foundRunner=$false
           for($hop=0;$hop-lt8-and$ancestorId-gt0;$hop++){
               $processRow=Get-CimInstance Win32_Process -Filter "ProcessId=$ancestorId" -ErrorAction Stop
               if(!$processRow){throw 'WB_TIMED_ANCESTRY_UNREADABLE'}
               if($ancestorId-eq$runnerId){
                   $expectedRunner=Get-WorkbenchLocalPath $Root 'lib/run_timed.ps1'
                   if(!([string]$processRow.CommandLine).Contains($expectedRunner,[StringComparison]::OrdinalIgnoreCase)){throw 'WB_TIMED_RUNNER_SOURCE_MISMATCH'}
                   $foundRunner=$true;break
               }
               $ancestorId=[int]$processRow.ParentProcessId
           }
           if(!$foundRunner){throw 'WB_TIMED_RUNNER_NOT_ANCESTOR'}
           if('WORKSTATION'-in$profiles-or'CI'-in$profiles){throw 'WB_REQUIRED_PROFILE_NOT_IMPLEMENTED'}
           $workingReceipt=Get-WorkbenchLocalPath $Root '.workbench-local-certification.json'
           if(Test-Path -LiteralPath $workingReceipt){[IO.File]::Delete($workingReceipt)}
           $clock=[Diagnostics.Stopwatch]::StartNew()
           & pwsh -NoProfile -File (Join-Path $Root 'tests.ps1')
           $testExit=$LASTEXITCODE
           if($testExit-ne0){"FAILED: pwsh -NoProfile -File tests.ps1 (exit $testExit)";throw "WB_REQUIRED_TESTS_FAILED:exit=$testExit"}
           $afterHead=@(Read-WorkbenchEntryGit @('rev-parse','HEAD'))[0]
           if($afterHead-cne$finishHead-or@(Read-WorkbenchEntryGit @('status','--porcelain','--untracked-files=all')).Count){throw 'WB_INPUT_CHANGED_DURING_FINISH'}
           if((Get-WorkbenchFingerprint $Root $tree $contract)-cne$fingerprint){throw 'WB_FINGERPRINT_CHANGED_DURING_FINISH'}
           $receipt=[ordered]@{schema=1;root=$Root;contract=$contract;finishHead=$finishHead;fingerprint=$fingerprint;profiles=$profiles;
               evaluator=@(Read-WorkbenchEntryGit @('rev-parse','HEAD:lib/Test-WorkbenchChange.ps1'))[0];runLog=$runLog;runStart=$runStart;result='READY'}
           $digest=Get-WorkbenchDigest ($receipt|ConvertTo-Json -Depth 5 -Compress)
           $receipt['digest']=$digest
           $bytes=($receipt|ConvertTo-Json -Depth 5)
           [IO.File]::WriteAllText($workingReceipt,$bytes,[Text.UTF8Encoding]::new($false))
           $archive=Get-WorkbenchLocalPath $Root '.workbench-certifications'
           [void][IO.Directory]::CreateDirectory($archive)
           $archivedReceipt=Join-Path $archive ($digest+'.json')
           if(Test-Path -LiteralPath $archivedReceipt){
               if([IO.File]::ReadAllText($archivedReceipt)-cne$bytes){throw 'WB_HISTORICAL_RECEIPT_COLLISION'}
           }else{[IO.File]::WriteAllText($archivedReceipt,$bytes,[Text.UTF8Encoding]::new($false))}
           'WORKBENCH_LOCAL_CERTIFY: READY';"PROFILES: $($profiles-join', ')";"RECEIPT: $digest";"TIME: Workbench Finish $($clock.Elapsed.ToString('hh\:mm\:ss'))"
       }elseif($Review){
           Assert-WorkbenchCompletion $Root $tree $contract $record $profiles
           'WORKBENCH_REVIEW: READY';"FINGERPRINT: $fingerprint"
       }elseif($Complete){
           Assert-WorkbenchCompletion $Root $tree $contract $record $profiles
           $contractText=[IO.File]::ReadAllText($contractFile)
           $statusBody=$record.Sections.Status.Replace('[x] In Progress','[ ] In Progress').Replace('[ ] Complete','[x] Complete')
           $contractText=Set-WorkbenchSection $contractText 'Status' $statusBody
           if((Get-WorkbenchFrozen (Get-WorkbenchFields $contractText))-cne(Get-WorkbenchFrozen $record)){throw 'WB_COMPLETION_WOULD_CHANGE_FROZEN_AUTHORITY'}
           $resume=Get-WorkbenchLocalPath $Root 'RESUME.md'
           $resumeText=[IO.File]::ReadAllText($resume)
           $resumeText=[regex]::Replace($resumeText,'(?m)^Active Workbench Contract: [^\r\n]+','Active Workbench Contract: None')
           [IO.File]::WriteAllText($contractFile,$contractText,[Text.UTF8Encoding]::new($false))
           [IO.File]::WriteAllText($resume,$resumeText,[Text.UTF8Encoding]::new($false))
           'WORKBENCH_COMPLETE: PREPARED (normal scoped commit and range judgment still required)'
       }
       exit 0
   }catch{'WORKBENCH: BLOCKED';"CODE: $($_.Exception.Message)";exit 1}
   finally{
       if($operationLease){$operationLease.Dispose()}
       if($temporaryJudge-and(Test-Path -LiteralPath $temporaryJudge)){[IO.File]::Delete($temporaryJudge)}
       if($toolDirectory-and(Test-Path -LiteralPath $toolDirectory)){
           # Only these two own materializations; no recursive deletion or target discovery.
           foreach($tool in 'apply-draft-steps.ps1','Invoke-DraftSteps.ps1'){[IO.File]::Delete((Join-Path $toolDirectory $tool))}
           [IO.Directory]::Delete($toolDirectory,$false)
       }
   }
   ```

   The resulting file's Git blob is 3dee99dee892e5f3cb1ccc905f861cf344abfdee.

11. Check whether `lib/test-workbench-governance.ps1` contains `Real local Git/caller fixtures`; if so record Already Applied when its Git blob is 1d64c008421bba9a93f6348ac01a71681e23c587, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (the bounded Workbench local governance kernel), and change nothing else:

   ```text
   # Real local Git/caller fixtures. Synthetic owner assertions and short test children are NOT live approval or full-suite certification.
   $ErrorActionPreference='Stop'
   . (Join-Path $PSScriptRoot 'Test-WorkbenchChange.ps1')
   . (Join-Path $PSScriptRoot 'remove-owned.ps1')
   . (Join-Path $PSScriptRoot 'Invoke-DraftSteps.ps1')
   $testParent=if($env:WORKBENCH_TEST_ROOT){[IO.Path]::GetFullPath($env:WORKBENCH_TEST_ROOT)}else{Join-Path ([IO.Path]::GetTempPath()) 'ORVION-Workbench/tests'}
   [void][IO.Directory]::CreateDirectory($testParent)
   $ownedRoot=Join-Path $testParent ('orvion-wb-governance-'+[guid]::NewGuid().ToString('N'))
   [void][IO.Directory]::CreateDirectory($ownedRoot)
   $observations=[Collections.Generic.List[object]]::new()
   $failures=0
   $caseNumber=0
   function Write-FixtureFile([string]$file,[string]$text) {
       [void][IO.Directory]::CreateDirectory((Split-Path $file -Parent))
       [IO.File]::WriteAllText($file,$text,[Text.UTF8Encoding]::new($false))
   }
   function Invoke-FixtureGit([string]$checkout,[string[]]$Arguments,[switch]$AllowFailure) {
       $lines=@(& git -C $checkout @Arguments 2>&1);$exitValue=$LASTEXITCODE
       $row=[pscustomobject]@{Kind='git';Root=$checkout;Arguments=$Arguments;Exit=$exitValue;Output=@($lines|ForEach-Object{"$_"})}
       $observations.Add($row)
       if($exitValue-ne0-and!$AllowFailure){throw "FIXTURE_GIT_FAILED:$($Arguments-join' '):$($lines-join' ')"}
       $row
   }
   function Invoke-FixtureChecker([string]$checkout,[string[]]$Arguments) {
       $lines=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Test-WorkbenchChange.ps1') -Root $checkout @Arguments 2>&1)
       $row=[pscustomobject]@{Kind='checker';Root=$checkout;Arguments=$Arguments;Exit=$LASTEXITCODE;Output=@($lines|ForEach-Object{"$_"})}
       $observations.Add($row);$row
   }
   function Assert-Fixture([string]$Name,[bool]$Condition,$Detail=$null) {
       if($Condition){"PASS $Name"}else{$script:failures++;"FAIL $Name $($Detail|ConvertTo-Json -Compress -Depth 4)"}
   }
   function Copy-Fixture([string]$From,[string]$Name) {
       $destination=Join-Path $ownedRoot $Name
       $null=Invoke-FixtureGit $ownedRoot @('clone','--quiet','--no-local',$From,$destination)
       foreach($setting in @(@('core.hooksPath','.githooks'),@('core.autocrlf','true'),@('gc.auto','0'),@('maintenance.auto','false'),@('user.name','Fixture'),@('user.email','fixture@invalid.local'))){$null=Invoke-FixtureGit $destination @('config','--local',$setting[0],$setting[1])}
       $null=Invoke-FixtureGit $destination @('remote','set-url','--push','origin','DISABLED')
       $destination
   }
   function Save-FixtureCommit([string]$checkout,[string[]]$paths,[string]$Message,[switch]$AllowFailure) {
       $null=Invoke-FixtureGit $checkout (@('add','--')+$paths)
       Invoke-FixtureGit $checkout @('commit','--quiet','-m',$Message) -AllowFailure:$AllowFailure
   }
   function Set-FixtureStatus([string]$checkout,[string]$State) {
       $file=Join-Path $checkout 'changes/WS-001-fixture.md'
       $text=[IO.File]::ReadAllText($file)-replace'\r\n',([string][char]10)
       $text=[regex]::Replace($text,'(?m)^\[x\] (Draft|Approved|In Progress|Complete|Cancelled)$','[ ] $1')
       $text=$text.Replace('[ ] '+$State,'[x] '+$State)
       Write-FixtureFile $file $text
   }
   function Approve-FixtureCheckout([string]$checkout,[switch]$AllowFailure) {
       Set-FixtureStatus $checkout 'Approved'
       $ownerFile=Join-Path $evidence ('owner-'+[guid]::NewGuid().ToString('N')+'.txt')
       Write-FixtureFile $ownerFile ("SYNTHETIC FIXTURE ONLY: approve exact Draft $draftDigest for execution root $checkout")
       $ownerDigest=(Get-FileHash -LiteralPath $ownerFile).Hash
       $file=Join-Path $checkout 'changes/WS-001-fixture.md'
       $approved=[IO.File]::ReadAllText($file).Replace('## Verification Notes',("Approved Draft: $v3"+[char]10+"Approved SHA256: $draftDigest"+[char]10+"Owner Evidence: $ownerFile"+[char]10+"Owner Evidence SHA256: $ownerDigest"+[char]10+"Execution Root: $checkout"+[char]10+[char]10+'## Verification Notes'))
       Write-FixtureFile $file $approved
       Write-FixtureFile (Join-Path $checkout 'RESUME.md') ('# Fixture'+[char]10+'Active Workbench Contract: changes/WS-001-fixture.md'+[char]10)
       Save-FixtureCommit $checkout @('changes/WS-001-fixture.md','RESUME.md') 'Fixture exact root-bound approval' -AllowFailure:$AllowFailure
   }
   function New-ApprovedFixture([string]$Name) {
       $checkout=Copy-Fixture $draftSnapshot $Name
       $null=Approve-FixtureCheckout $checkout
       $checkout
   }
   function Start-FixtureChild([string[]]$Arguments,[string]$Directory) {
       $info=[Diagnostics.ProcessStartInfo]::new((Get-Command pwsh -CommandType Application|Select-Object -First 1).Source)
       $info.UseShellExecute=$false;$info.CreateNoWindow=$true;$info.RedirectStandardOutput=$true;$info.RedirectStandardError=$true
       $info.WorkingDirectory=$Directory
       foreach($argument in $Arguments){$info.ArgumentList.Add($argument)}
       $process=[Diagnostics.Process]::new();$process.StartInfo=$info;$null=$process.Start()
       [pscustomobject]@{Process=$process;Out=$process.StandardOutput.ReadToEndAsync();Err=$process.StandardError.ReadToEndAsync()}
   }
   function Receive-FixtureChild($child) {
       try{
           if(!$child.Process.WaitForExit(60000)){$child.Process.Kill($true);throw 'OWNED_FIXTURE_CHILD_TIMEOUT'}
           [pscustomobject]@{Exit=$child.Process.ExitCode;Output=$child.Out.GetAwaiter().GetResult()+$child.Err.GetAwaiter().GetResult()}
       }finally{$child.Process.Dispose()}
   }
   function Invoke-FixtureFinish([string]$checkout,[string]$Label) {
       $log=Join-Path $ownedRoot ($Label+'.log')
       $entryPath=Join-Path $checkout 'lib/Workbench.ps1'
       $command="& '"+$entryPath.Replace("'","''")+"' -Root '"+$checkout.Replace("'","''")+"' -Finish"
       $runner=Start-FixtureChild @('-NoProfile','-File',(Join-Path $checkout 'lib/run_timed.ps1'),'-Log',$log,'-WorkingDirectory',$checkout,'-Command',$command) $checkout
       $observer=Start-FixtureChild @('-NoProfile','-File',(Join-Path $checkout 'lib/watch_run.ps1'),'-Log',$log,'-Run',$Label,'-Brief','-PollSeconds','0.1','-QuietMinutes','5','-Csv',(Join-Path $ownedRoot ($Label+'.csv'))) $checkout
       $runnerResult=Receive-FixtureChild $runner
       $watchResult=Receive-FixtureChild $observer
       $raw=[IO.File]::ReadAllText($log)
       $row=[pscustomobject]@{Kind='actual-fixture-run';Root=$checkout;Log=$log;Runner=$runnerResult;Watcher=$watchResult;Output=$raw}
       $observations.Add($row);$row
   }
   function Test-DuplicateSnapshotFixture {
       $checkout=Copy-Fixture $draftSnapshot 'duplicate-assurance'
       $oldSelected=$v3
       $v3=Join-Path $evidence 'duplicate-selected.md'
       $file=Join-Path $checkout 'changes/WS-001-fixture.md'
       $changed=[IO.File]::ReadAllText($file).Replace($oldSelected,$v3).Replace('V2: fixture-adversarial','V2: fixture-design')
       Write-FixtureFile $file $changed;Write-FixtureFile $v3 $changed
       $draftDigest=(Get-FileHash -LiteralPath $v3).Hash
       $null=Save-FixtureCommit $checkout @('changes/WS-001-fixture.md') 'Fixture unapproved duplicate assurance proposal'
       $refusal=Approve-FixtureCheckout $checkout -AllowFailure
       Assert-Fixture 'actual approval hook rejects duplicated pass identities' ($refusal.Exit-ne0-and($refusal.Output-join' ')-match'WB_THREE_PASS_IDENTITY_DUPLICATED') $refusal
   }
   function Test-AuthorizedCheckerFixture {
       $checkout=Copy-Fixture $draftSnapshot 'authorized-checker-change'
       $oldSelected=$v3;$v3=Join-Path $evidence 'authorized-checker-selected.md'
       $newChecker=[IO.File]::ReadAllText((Join-Path $checkout 'lib/Test-WorkbenchChange.ps1'))+[char]10+'# An explicitly approved non-semantic fixture change.'+[char]10
       $proposal=Join-Path $evidence 'checker-proposal.ps1';Write-FixtureFile $proposal $newChecker
       $pin=(Invoke-FixtureGit $checkout @('hash-object','--path=lib/Test-WorkbenchChange.ps1','--',$proposal)).Output[0]
       $file=Join-Path $checkout 'changes/WS-001-fixture.md'
       $changed=[IO.File]::ReadAllText($file).Replace($oldSelected,$v3).Replace('- [ ] Feature has the expected reviewed content.',('- [ ] Explicit checker bytes; check: blob:lib/Test-WorkbenchChange.ps1='+$pin))
       Write-FixtureFile $file $changed;Write-FixtureFile $v3 $changed
       $draftDigest=(Get-FileHash -LiteralPath $v3).Hash
       $null=Save-FixtureCommit $checkout @('changes/WS-001-fixture.md') 'Fixture unapproved exact checker proposal'
       $null=Approve-FixtureCheckout $checkout
       Set-FixtureStatus $checkout 'In Progress';Write-FixtureFile (Join-Path $checkout 'lib/Test-WorkbenchChange.ps1') $newChecker
       $accepted=Save-FixtureCommit $checkout @('changes/WS-001-fixture.md','lib/Test-WorkbenchChange.ps1') 'Fixture authorized checker update'
       Assert-Fixture 'accepted checker admits an explicitly approved exact successor' ($accepted.Exit-eq0) $accepted
       Write-FixtureFile (Join-Path $checkout 'lib/Test-WorkbenchChange.ps1') 'exit 0'
       $null=Invoke-FixtureGit $checkout @('add','lib/Test-WorkbenchChange.ps1')
       $refused=Invoke-FixtureChecker $checkout @('-Mode','Gate','-Staged')
       Assert-Fixture 'another body cannot substitute for the approved checker blob' ($refused.Exit-ne0-and($refused.Output-join' ')-match'WB_UNAPPROVED_CONTROL_BYTES') $refused
   }
   function Invoke-FixtureWatch([string]$watcher,[string]$Label) {
       $log=Join-Path $ownedRoot ($Label+'.log')
       $lines=@(('['+(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+"] START pid=$PID host=fixture | bounded completed replay"),
           '[+   0.001 min] PASS 1 mentioning UNREADABLE is test progress',
           '[+   0.002 min] TOOL: UNREADABLE',
           '[+   0.003 min] PUBLISH: REFUSED',
           '[+   0.004 min] END exit=1 total=0.0 min concurrent_end=0')
       [IO.File]::WriteAllLines($log,$lines,[Text.UTF8Encoding]::new($false))
       $child=Start-FixtureChild @('-NoProfile','-File',$watcher,'-Log',$log,'-Run',$Label,'-Brief','-PollSeconds','0.1','-QuietMinutes','5','-Csv',(Join-Path $ownedRoot ($Label+'.csv'))) $ownedRoot
       $result=Receive-FixtureChild $child
       $observations.Add([pscustomobject]@{Kind='watcher-replay';Log=$log;Watcher=$watcher;Exit=$result.Exit;Output=$result.Output})
       $result
   }
   function Test-ExecuteFixture {
       $checkout=Copy-Fixture $draftSnapshot 'actual-execute'
       $file=Join-Path $checkout 'feature.txt';$beforeBytes=[IO.File]::ReadAllBytes($file)
       try{Write-FixtureFile $file ('after'+[char]10);$step=Get-DraftFileStep $checkout 'feature.txt' 'after' 'isolated literal execution fixture'}
       finally{[IO.File]::WriteAllBytes($file,$beforeBytes)}
       $oldSelected=$v3;$v3=Join-Path $evidence 'execute-selected.md'
       $contractFile=Join-Path $checkout 'changes/WS-001-fixture.md'
       $body=[IO.File]::ReadAllText($contractFile).Replace($oldSelected,$v3)
       $body=Set-WorkbenchSection $body 'Implementation Steps' ('1. '+$step.Text)
       Write-FixtureFile $contractFile $body;Write-FixtureFile $v3 $body
       $fixturePlanLines=@(& pwsh -NoProfile -File (Join-Path $checkout 'lib/apply-draft-steps.ps1') -Draft $v3 -Root $checkout -Plan 2>&1)
       $fixturePlanExit=$LASTEXITCODE
       $fixturePlanValue=if($fixturePlanExit-eq0){($fixturePlanLines-join[char]10)|ConvertFrom-Json}else{$null}
       Assert-Fixture 'literal fixture uses the existing replay grammar before approval or writes' ($fixturePlanExit-eq0-and$fixturePlanValue.Files.Count-eq1-and$fixturePlanValue.Files[0].File-ceq'feature.txt'-and[Convert]::ToBase64String([IO.File]::ReadAllBytes($file))-ceq[Convert]::ToBase64String($beforeBytes)) $fixturePlanLines
       if($fixturePlanExit-ne0){throw 'FIXTURE_LITERAL_PLAN_PRECHECK_FAILED'}
       $draftDigest=(Get-FileHash -LiteralPath $v3).Hash
       $null=Save-FixtureCommit $checkout @('changes/WS-001-fixture.md') 'Fixture literal execution Draft'
       $null=Approve-FixtureCheckout $checkout
       Set-FixtureStatus $checkout 'In Progress'
       $null=Save-FixtureCommit $checkout @('changes/WS-001-fixture.md') 'Fixture begin literal execution'
       $entryPath=Join-Path $checkout 'lib/Workbench.ps1'
       $outputLines=@(& pwsh -NoProfile -File $entryPath -Root $checkout -Execute 2>&1);$exitValue=$LASTEXITCODE
       $executeBlob=(Invoke-FixtureGit $checkout @('hash-object','--path=feature.txt','--',$file)).Output[0]
       Assert-Fixture 'actual Execute uses accepted Plan and applier for an in-scope first write' ($exitValue-eq0-and$executeBlob-ceq$step.Blob-and($outputLines-join' ')-match'WORKBENCH_EXECUTE: DONE') $outputLines
       $null=Save-FixtureCommit $checkout @('feature.txt') 'Fixture literal implementation commit'
       $writeAt=(Get-Item -LiteralPath $file).LastWriteTimeUtc.Ticks
       $outputLines=@(& pwsh -NoProfile -File $entryPath -Root $checkout -Execute 2>&1);$exitValue=$LASTEXITCODE
       Assert-Fixture 'actual Execute resumes Already Applied without rewriting the selected file' ($exitValue-eq0-and($outputLines-join' ')-match'ALREADY_APPLIED: feature.txt'-and(Get-Item -LiteralPath $file).LastWriteTimeUtc.Ticks-eq$writeAt) $outputLines
   }
   try {
       $seed=Join-Path $ownedRoot 'seed';[void][IO.Directory]::CreateDirectory($seed)
       $null=Invoke-FixtureGit $seed @('init','--quiet')
       foreach($setting in @(@('user.name','Fixture'),@('user.email','fixture@invalid.local'),@('core.hooksPath','.git/hooks'),@('core.autocrlf','true'),@('gc.auto','0'),@('maintenance.auto','false'))){$null=Invoke-FixtureGit $seed @('config','--local',$setting[0],$setting[1])}
       foreach($relative in 'lib/Test-WorkbenchChange.ps1','lib/Workbench.ps1','lib/run_timed.ps1','lib/watch_run.ps1','lib/apply-draft-steps.ps1','lib/Invoke-DraftSteps.ps1','.githooks/pre-commit'){
           $source=Join-Path (Split-Path $PSScriptRoot -Parent) $relative
           Write-FixtureFile (Join-Path $seed $relative) ([IO.File]::ReadAllText($source))
       }
       Write-FixtureFile (Join-Path $seed 'RESUME.md') ('# Fixture'+[char]10+'Active Workbench Contract: None'+[char]10)
       Write-FixtureFile (Join-Path $seed 'WORKFLOW.md') ('# Fixture local authority'+[char]10)
       Write-FixtureFile (Join-Path $seed '.gitignore') ('work/'+[char]10+'.workbench-local-certification.json'+[char]10+'.workbench-certifications/'+[char]10)
       Write-FixtureFile (Join-Path $seed 'feature.txt') ('before'+[char]10)
       $shortTests=@'
   $ErrorActionPreference='Stop'
   $counter=Join-Path $PSScriptRoot 'work/count.txt'
   [void][IO.Directory]::CreateDirectory((Split-Path $counter -Parent))
   $count=if(Test-Path -LiteralPath $counter){[int][IO.File]::ReadAllText($counter)}else{0}
   [IO.File]::WriteAllText($counter,[string]($count+1))
   if(Test-Path -LiteralPath (Join-Path $PSScriptRoot 'work/fail')){exit 7}
   'PASS synthetic fixture child (dispatch proof only)'
   exit 0
   '@
       Write-FixtureFile (Join-Path $seed 'tests.ps1') ($shortTests+[char]10)
       $null=Invoke-FixtureGit $seed @('add','.')
       $null=Invoke-FixtureGit $seed @('commit','--quiet','-m','Synthetic accepted checker seed; fixture trust assumption only')
       $baseline=(Invoke-FixtureGit $seed @('rev-parse','HEAD')).Output[0]
       $draftRoot=Copy-Fixture $seed 'draft'
       $evidence=Join-Path $ownedRoot 'assurance';[void][IO.Directory]::CreateDirectory($evidence)
       $v1=Join-Path $evidence 'V1.md';$v2=Join-Path $evidence 'V2.md';$v3=Join-Path $evidence 'V3.md';$ownerFile=Join-Path $evidence 'owner.txt'
       Write-FixtureFile $v1 'V1 fixture design; no live authority.'
       Write-FixtureFile $v2 'V2 fixture adversarial review; no live authority.'
       $sha1=(Get-FileHash -LiteralPath $v1).Hash;$sha2=(Get-FileHash -LiteralPath $v2).Hash
       $date=[DateTime]::UtcNow.ToString('yyyy-MM-dd')
       $text=@"
   # Workbench Change Request - WS-001

   ## Status
   [x] Draft
   [ ] Approved
   [ ] In Progress
   [ ] Complete
   [ ] Cancelled

   ## Objective
   Change one synthetic feature — retain UTF-8 authority and native admission.

   ## Baseline
   $baseline

   ## Write Scope
   - RESUME.md
   - feature.txt
   - lib/Test-WorkbenchChange.ps1
   - .githooks/pre-commit

   ## Out of Scope
   Every other engineering path and all real roots.

   ## Draft Assurance
   V1: fixture-design | $date | $v1 | $sha1
   V2: fixture-adversarial | $date | $v2 | $sha2
   V3: fixture-refresh | $date | $v3 | SELECTED
   Selected Version: V3

   ## Implementation Steps
   Change feature.txt only. Checker/hook scope permits causal mutation tests but no unpinned control edits.

   ## Acceptance Criteria
   - [ ] Feature has the expected reviewed content.

   ## Review Gate
   - [ ] Actual fixture runner and watcher results checked.

   ## Runtime Checkpoint
   Resume Step: 1
   Blocker: None
   Recovery Attempt: 0

   ## Execution Log
   Fixture only; no production approval.

   ## Verification Notes
   Fixture only.
   "@+[char]10
       Write-FixtureFile $v3 $text
       $draftDigest=(Get-FileHash -LiteralPath $v3).Hash
       Write-FixtureFile $ownerFile ("SYNTHETIC FIXTURE ONLY: approve exact Draft $draftDigest")
       $contract=Join-Path $draftRoot 'changes/WS-001-fixture.md';Write-FixtureFile $contract $text
       $draftCommit=Save-FixtureCommit $draftRoot @('changes/WS-001-fixture.md') 'Fixture Draft'
       $draftSnapshot=Copy-Fixture $draftRoot 'unapproved-seed'
       Assert-Fixture 'actual hook admits a Draft allocation' ($draftCommit.Exit-eq0)
       $core=Invoke-FixtureChecker $seed @('-Mode','Boot')
       Assert-Fixture 'CORE Boot has no product dependency or remote' ($core.Exit-eq0-and($core.Output-join' ')-match'MODE: PLAN') $core

       $bad=Copy-Fixture $draftRoot 'draft-implementation'
       Write-FixtureFile (Join-Path $bad 'feature.txt') 'unapproved'
       $blocked=Save-FixtureCommit $bad @('feature.txt') 'Forbidden Draft implementation' -AllowFailure
       Assert-Fixture 'actual hook rejects implementation without an active approved contract' ($blocked.Exit-ne0-and($blocked.Output-join' ')-match'WB_GOVERNING_CONTRACT_MISSING_OR_AMBIGUOUS|WB_DRAFT_IMPLEMENTATION_REFUSED') $blocked

       $approvalCommit=Approve-FixtureCheckout $draftRoot
       Assert-Fixture 'actual hook checks exact approval and three snapshot identities' ($approvalCommit.Exit-eq0) $approvalCommit
       $approvedHead=(Invoke-FixtureGit $draftRoot @('rev-parse','HEAD')).Output[0]
       $wrongRoot=Copy-Fixture $draftRoot 'wrong-root-record'
       $wrongRootRead=Invoke-FixtureChecker $wrongRoot @('-Mode','Boot')
       Assert-Fixture 'an approved record copied to another root grants no write authority' ($wrongRootRead.Exit-ne0-and($wrongRootRead.Output-join' ')-match'WB_APPROVAL_ROOT_MISMATCH') $wrongRootRead

       foreach($scenario in 'scope','frozen','index','checker','hook','complete','cancel','credential','local-data'){
           $script:caseNumber++;$bad=New-ApprovedFixture ("negative-$scenario")
           $approvedHead=(Invoke-FixtureGit $bad @('rev-parse','HEAD')).Output[0]
           $paths=@('changes/WS-001-fixture.md')
           switch($scenario){
               scope{Write-FixtureFile (Join-Path $bad 'outside.txt') 'outside';$paths=@('outside.txt');$expected='WB_WRITE_SCOPE_REFUSED'}
               frozen{$file=Join-Path $bad 'changes/WS-001-fixture.md';Write-FixtureFile $file ([IO.File]::ReadAllText($file).Replace('Change one synthetic feature','Widen the approved objective'));$expected='WB_FROZEN_AUTHORITY_CHANGED'}
               index{Write-FixtureFile (Join-Path $bad 'feature.txt') 'staged';$null=Invoke-FixtureGit $bad @('add','feature.txt');Write-FixtureFile (Join-Path $bad 'feature.txt') 'different working bytes';$paths=@();$expected='WB_WORKING_INDEX_MISMATCH'}
               checker{Write-FixtureFile (Join-Path $bad 'lib/Test-WorkbenchChange.ps1') 'exit 0';$paths=@('lib/Test-WorkbenchChange.ps1');$expected='WB_CONTROL_PIN_REQUIRED'}
               hook{Write-FixtureFile (Join-Path $bad '.githooks/pre-commit') ('#!/bin/sh'+[char]10+'exit 0'+[char]10);$paths=@('.githooks/pre-commit');$expected='WB_CONTROL_PIN_REQUIRED'}
               complete{Set-FixtureStatus $bad 'Complete';Write-FixtureFile (Join-Path $bad 'RESUME.md') ('# Fixture'+[char]10+'Active Workbench Contract: None'+[char]10);$paths+=@('RESUME.md');$expected='WB_ILLEGAL_TRANSITION'}
               cancel{Set-FixtureStatus $bad 'Cancelled';Write-FixtureFile (Join-Path $bad 'RESUME.md') ('# Fixture'+[char]10+'Active Workbench Contract: None'+[char]10);Write-FixtureFile (Join-Path $bad 'feature.txt') 'concealed during cancel';$paths+=@('RESUME.md','feature.txt');$expected='WB_TERMINAL_IMPLEMENTATION_REFUSED'}
               credential{Write-FixtureFile (Join-Path $bad 'feature.txt') ('ghp_'+('Q'*36));$paths=@('feature.txt');$expected='WB_CREDENTIAL_SHAPED_CONTENT_REFUSED'}
               local-data{Write-FixtureFile (Join-Path $bad 'work/private.txt') 'synthetic protected local history';$null=Invoke-FixtureGit $bad @('add','-f','work/private.txt');$paths=@();$expected='WB_LOCAL_DATA_REFUSED'}
           }
           if($paths.Count){$null=Invoke-FixtureGit $bad (@('add','--')+$paths)}
           # Direct accepted checker is the separate trust door, even when a candidate disables its working hook.
           $rejected=Invoke-FixtureChecker $bad @('-Mode','Gate','-Staged')
           Assert-Fixture ("causal $scenario refusal") ($rejected.Exit-ne0-and($rejected.Output-join' ')-match$expected) $rejected
           $unchanged=(Invoke-FixtureGit $bad @('rev-parse','HEAD')).Output[0]
           Assert-Fixture ("$scenario leaves accepted HEAD unchanged") ($unchanged-ceq$approvedHead)
       }
       $missing=New-ApprovedFixture 'artifact-change'
       $saved=[IO.File]::ReadAllText($v2)
       try{Write-FixtureFile $v2 'changed';$negative=Invoke-FixtureChecker $missing @('-Mode','Gate','-Staged');Assert-Fixture 'changed immutable V2 refuses' ($negative.Exit-ne0-and($negative.Output-join' ')-match'WB_ARTIFACT_CHANGED') $negative}
       finally{Write-FixtureFile $v2 $saved}
       Test-DuplicateSnapshotFixture
       Test-AuthorizedCheckerFixture
       Test-ExecuteFixture

       $brokenRoot=Invoke-FixtureChecker $ownedRoot @('-Mode','Boot')
       Assert-Fixture 'failed Git read is BLOCKED, never clean/READY' ($brokenRoot.Exit-ne0-and($brokenRoot.Output-join' ')-match'WB_ENTRY_GIT_UNREADABLE|WB_GIT_UNREADABLE'-and($brokenRoot.Output-join' ')-notmatch'WORKBENCH: READY') $brokenRoot
       $singleStatus=$text.Replace('[ ] Approved','[x] Approved')
       $statusRefused=$false;try{$null=Get-WorkbenchFields $singleStatus}catch{$statusRefused=$_.Exception.Message-eq'WB_STATUS_INVALID'}
       Assert-Fixture 'two official statuses refuse' $statusRefused
       $nested=$text.Replace('Change feature.txt only. Checker/hook scope permits causal mutation tests but no unpinned control edits.',('   [x] In Progress'+[char]10+'   [ ] Complete'+[char]10+'   ## Status'+[char]10+'   Resume Step: 1'))
       $nestedBefore=Get-WorkbenchFields $nested
       $nestedAfter=Set-WorkbenchSection $nested 'Status' $nestedBefore.Sections.Status.Replace('[x] Draft','[ ] Draft').Replace('[ ] Approved','[x] Approved')
       Assert-Fixture 'section mutation never rewrites contract-like strings inside literal payloads' ((Get-WorkbenchFrozen (Get-WorkbenchFields $nestedAfter))-ceq(Get-WorkbenchFrozen $nestedBefore))
       $duplicateStatus=$text.Replace('[ ] Cancelled','[ ] Draft')
       $duplicateRefused=$false;try{$null=Get-WorkbenchFields $duplicateStatus}catch{$duplicateRefused=$_.Exception.Message-eq'WB_STATUS_INVALID'}
       Assert-Fixture 'duplicated status options refuse' $duplicateRefused
       Assert-Fixture 'profiles derive CONTROL and REPOSITORY from governing scope' ((@(Get-WorkbenchProfiles @('RESUME.md','feature.txt'))-join',')-ceq'CONTROL,REPOSITORY')
       $fakeRecord=[pscustomobject]@{Sections=@{'Acceptance Criteria'='- [ ] unknown mandatory check: shell:exit 0'}}
       $unknownRefused=$false;try{$null=@(Get-WorkbenchBlobChecks $fakeRecord @('feature.txt'))}catch{$unknownRefused=$_.Exception.Message-eq'WB_CHECK_CLAUSE_INVALID_OR_UNSUPPORTED'}
       Assert-Fixture 'unknown machine-check vocabulary refuses instead of silently disappearing' $unknownRefused
       $resumeDigest=Get-WorkbenchResumeDigest ('# route'+[char]10+'Active Workbench Contract: None'+[char]10)
       $activeDigest=Get-WorkbenchResumeDigest ('# route'+[char]10+'Active Workbench Contract: changes/WS-001-fixture.md'+[char]10)
       Assert-Fixture 'only the lifecycle pointer is normalized in routing evidence' ($resumeDigest-ceq$activeDigest-and$resumeDigest-cne(Get-WorkbenchResumeDigest ('# altered route'+[char]10+'Active Workbench Contract: None'+[char]10)))
       $unicodeRecord=[pscustomobject]@{Sections=@{'Write Scope'='- tools/new file Ω.txt'}}
       Assert-Fixture 'governed scope preserves the existing Unicode and space path capability' ((@(Get-WorkbenchScope $unicodeRecord))[0]-ceq'tools/new file Ω.txt')

       $valid=New-ApprovedFixture 'lifecycle'
       Set-FixtureStatus $valid 'In Progress';Write-FixtureFile (Join-Path $valid 'feature.txt') ('after'+[char]10)
       $execution=Save-FixtureCommit $valid @('changes/WS-001-fixture.md','feature.txt') 'Fixture execution'
       Assert-Fixture 'own actual hook admits in-scope execution' ($execution.Exit-eq0) $execution
       $entry=Join-Path $valid 'lib/Workbench.ps1'
       $noTiming=@(& pwsh -NoProfile -File $entry -Root $valid -Finish 2>&1);$noTimingExit=$LASTEXITCODE
       Assert-Fixture 'Finish refuses a direct untimed start' ($noTimingExit-ne0-and($noTiming-join' ')-match'WB_FINISH_NOT_TIMED') $noTiming
       Assert-Fixture 'the hook never ran the fixture test child' (!(Test-Path -LiteralPath (Join-Path $valid 'work/count.txt')))
       $lease=[IO.File]::Open((Join-Path $valid '.git/workbench-operation.lock'),[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)
       try{$busy=Invoke-FixtureChecker $valid @('-Mode','Gate','-Staged');Assert-Fixture 'same-root admission refuses while another operation holds the lease' ($busy.Exit-ne0-and($busy.Output-join' ')-match'WB_OPERATION_IN_PROGRESS_OR_UNREADABLE') $busy}
       finally{$lease.Dispose()}
       $free=Invoke-FixtureChecker $valid @('-Mode','Gate','-Staged')
       Assert-Fixture 'an abandoned empty lease file does not block a new lawful operation' ($free.Exit-eq0) $free
       Write-FixtureFile (Join-Path $valid '.workbench-local-certification.json') 'stale working receipt'
       Write-FixtureFile (Join-Path $valid 'work/fail') 'fail the synthetic child deliberately'
       $failedRun=Invoke-FixtureFinish $valid 'wb-fixture-failed'
       Assert-Fixture 'failed actual timed fixture Finish preserves the child failure' ($failedRun.Runner.Exit-ne0-and$failedRun.Output-match'WB_REQUIRED_TESTS_FAILED:exit=7') $failedRun
       Assert-Fixture 'failed Finish retires the prior working receipt' (!(Test-Path -LiteralPath (Join-Path $valid '.workbench-local-certification.json')))
       Assert-Fixture 'simultaneous actual watcher also reports a failed run' ($failedRun.Watcher.Exit-ne0) $failedRun.Watcher
       [IO.File]::Delete((Join-Path $valid 'work/fail'))
       $successfulRun=Invoke-FixtureFinish $valid 'wb-fixture-success'
       Assert-Fixture 'successful actual timed fixture Finish emits a fresh receipt' ($successfulRun.Runner.Exit-eq0-and$successfulRun.Output-match'WORKBENCH_LOCAL_CERTIFY: READY') $successfulRun
       Assert-Fixture 'simultaneous actual watcher observes successful END' ($successfulRun.Watcher.Exit-eq0-and$successfulRun.Output-match'END exit=0 ') $successfulRun.Watcher
       $receipt=Read-WorkbenchReceipt $valid
       Assert-Fixture 'fresh receipt binds its own root and exact implementation' ($receipt.root-ieq$valid-and$receipt.fingerprint-ceq(Get-WorkbenchFingerprint $valid 'HEAD' 'changes/WS-001-fixture.md'))
       $file=Join-Path $valid 'changes/WS-001-fixture.md'
       $reviewText=[IO.File]::ReadAllText($file)-replace'\r\n',([string][char]10)
       $reviewText=$reviewText.Replace('- [ ] ','- [x] ').Replace('Resume Step: 1','Resume Step: DONE')
       $reviewText+=[char]10+'Verdict: Confirmed Complete'+[char]10+'Reviewed Fingerprint: '+$receipt.fingerprint+[char]10+'Reviewed Receipt: '+$receipt.digest+[char]10
       Write-FixtureFile $file $reviewText
       $null=Save-FixtureCommit $valid @('changes/WS-001-fixture.md') 'Fixture truthful live Review'
       $reviewOutput=@(& pwsh -NoProfile -File $entry -Root $valid -Review 2>&1);$reviewExit=$LASTEXITCODE
       Assert-Fixture 'actual Review entry validates current receipt and run' ($reviewExit-eq0-and($reviewOutput-join' ')-match'WORKBENCH_REVIEW: READY') $reviewOutput
       $completeOutput=@(& pwsh -NoProfile -File $entry -Root $valid -Complete 2>&1);$completeExit=$LASTEXITCODE
       Assert-Fixture 'actual Complete entry prepares only legal lifecycle metadata' ($completeExit-eq0-and($completeOutput-join' ')-match'WORKBENCH_COMPLETE: PREPARED') $completeOutput
       $completeCommit=Save-FixtureCommit $valid @('changes/WS-001-fixture.md','RESUME.md') 'Fixture Complete'
       Assert-Fixture 'actual hook admits Complete with fresh own receipt' ($completeCommit.Exit-eq0) $completeCommit
       $finalHead=(Invoke-FixtureGit $valid @('rev-parse','HEAD')).Output[0]
       $range=Invoke-FixtureChecker $valid @('-Mode','Range','-Base',$baseline,'-Head',$finalHead)
       Assert-Fixture 'actual range checker accepts every valid lifecycle transition' ($range.Exit-eq0) $range
       Assert-Fixture 'hooks and Review/Complete did not rerun Finish child tests' ([int][IO.File]::ReadAllText((Join-Path $valid 'work/count.txt'))-eq2)
       $archive=Join-Path $valid ('.workbench-certifications/'+$receipt.digest+'.json')
       Assert-Fixture 'the exact original receipt is archived by its own immutable digest' ((Get-FileHash -LiteralPath $archive).Hash-ceq(Get-FileHash -LiteralPath (Join-Path $valid '.workbench-local-certification.json')).Hash)

       $counterexample=New-ApprovedFixture 'range-counterexample'
       $approvedHead=(Invoke-FixtureGit $counterexample @('rev-parse','HEAD')).Output[0]
       Write-FixtureFile (Join-Path $counterexample 'outside.txt') 'forbidden intermediate; isolated Git data only'
       $null=Invoke-FixtureGit $counterexample @('add','outside.txt')
       $badTree=(Invoke-FixtureGit $counterexample @('write-tree')).Output[0]
       $badCommit=(Invoke-FixtureGit $counterexample @('commit-tree',$badTree,'-p',$approvedHead,'-m','Isolated invalid intermediate data')).Output[0]
       [IO.File]::Delete((Join-Path $counterexample 'outside.txt'))
       $null=Invoke-FixtureGit $counterexample @('add','-A')
       $goodTree=(Invoke-FixtureGit $counterexample @('write-tree')).Output[0]
       $goodEnd=(Invoke-FixtureGit $counterexample @('commit-tree',$goodTree,'-p',$badCommit,'-m','Isolated restored endpoint data')).Output[0]
       $endpoint=(Invoke-FixtureGit $counterexample @('diff','--name-only',$approvedHead,$goodEnd)).Output
       $badRange=Invoke-FixtureChecker $counterexample @('-Mode','Range','-Base',$approvedHead,'-Head',$goodEnd)
       Assert-Fixture 'valid endpoints do not hide an invalid intermediate transition' (!$endpoint.Count-and$badRange.Exit-ne0-and($badRange.Output-join' ')-match'WB_WRITE_SCOPE_REFUSED') $badRange
       $watcher=Join-Path $PSScriptRoot 'watch_run.ps1'
       $replay=Invoke-FixtureWatch $watcher 'wb-alert-positive'
       Assert-Fixture 'actual Brief caller reports generic unreadable and refused outcomes' ($replay.Exit-ne0-and$replay.Output-match'TOOL: UNREADABLE'-and$replay.Output-match'PUBLISH: REFUSED') $replay
       Assert-Fixture 'actual Brief caller suppresses passing test progress' ($replay.Output-notmatch'PASS 1 mentioning') $replay
       $mutant=Join-Path $ownedRoot 'watcher-mutant/watch_run.ps1'
       $watcherText=[IO.File]::ReadAllText($watcher)
       $mutated=$watcherText.Replace('|UNREADABLE|','|UNREADABLE_SUPPRESSED|')
       Assert-Fixture 'alert mutation actually changes the selected implementation' ($mutated-cne$watcherText)
       Write-FixtureFile $mutant $mutated
       $mutantResult=Invoke-FixtureWatch $mutant 'wb-alert-mutant'
       Assert-Fixture 'unreadable-suppression mutant is killed by the actual caller case' ($mutantResult.Output-notmatch'TOOL: UNREADABLE') $mutantResult
   }catch{$failures++;"FAIL fixture setup or execution: $($_.Exception.Message)"}
   finally{
       if($env:WORKBENCH_TEST_EVIDENCE){Write-FixtureFile $env:WORKBENCH_TEST_EVIDENCE ($observations|ConvertTo-Json -Depth 7)}
       if($failures-eq0){$null=Remove-OrvionOwnedTree $ownedRoot @($testParent)}else{"PRESERVED_FIXTURES: $ownedRoot"}
   }
   "WORKBENCH GOVERNANCE CHECK: $failures failed"
   exit [int]($failures-gt0)
   ```

   The resulting file's Git blob is 1d64c008421bba9a93f6348ac01a71681e23c587.

12. Check whether `lib/run_timed.ps1` contains `Workbench adoption: bind a self-Finish`; if so record Already Applied when its Git blob is 7e688fc261ed4041878b32dc3ff855222ee0454b, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (the bounded Workbench local governance kernel), and change nothing else:

   ```text
   # ORVION timed runner -- ON-DEMAND REPORTING ADAPTER (AGENTS.md section 7). It owns no truth.
   #
   # Runs one command and writes every output line to -Log prefixed with the minutes elapsed, so a
   # long run (`check_agent_continuity.ps1 -Finish`, a guard suite) can be watched while it runs
   # (`scripts/watch_run.ps1`) and its timing quoted with the conditions it was measured under
   # (`ENGINEERING_METHOD.md §3`). The START line records the date, the runner's process id, the
   # environment, and how many OTHER repository scripts were already running: a run measured beside
   # other work is labelled as such and is not a baseline. The command's exit code is preserved.
   #
   # It never retries, reruns, filters, or judges anything, and it replaces no verification.
   #
   # Usage:
   #   pwsh -NoProfile -File scripts/run_timed.ps1 -Log <file> -Command "pwsh -NoProfile -File scripts/check_agent_continuity.ps1 -Finish"
   param(
       [Parameter(Mandatory)][string]$Log,
       [Parameter(Mandatory)][string]$Command,
       [string]$WorkingDirectory = (Split-Path $PSScriptRoot -Parent)
   )
   $ErrorActionPreference = 'Continue'
   $Log = [IO.Path]::GetFullPath($Log, (Get-Location).Path)
   Set-Location -LiteralPath $WorkingDirectory

   # Other PowerShell script files running now (`-File <x>.ps1`, from any directory: the run that made
   # SPEC-248's -Finish timing unusable was a scratch validation script outside `scripts/`). An editor's
   # terminal integration is dot-sourced through -Command, not run with -File, so it is not counted; nor
   # are these tools, because a watcher observing this run is not load on it. The label is a lower bound:
   # work started any other way is not seen.
   function Get-ConcurrentScripts {
       @(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe' OR Name='powershell.exe'" |
           Where-Object { $_.ProcessId -ne $PID } | ForEach-Object {
               $m = [regex]::Match("$($_.CommandLine)", '(?i)\s-File\s+(?:"(?<f>[^"]+\.ps1)"|''(?<f>[^'']+\.ps1)''|(?<f>\S+\.ps1))')
               if ($m.Success) { Split-Path $m.Groups['f'].Value -Leaf } } |
           Where-Object { $_ -notmatch '^(run_timed|watch_\w+)\.ps1$' })
   }
   $head = (git rev-parse --short HEAD 2>$null); if (-not $head) { $head = 'none' }
   $before = Get-ConcurrentScripts
   $envLabel = 'host={0} pwsh={1} cpus={2} head={3} concurrent={4}' -f $env:COMPUTERNAME, $PSVersionTable.PSVersion, [Environment]::ProcessorCount, $head, $(if ($before.Count) { $before -join ',' } else { '0' })
   $sw = [Diagnostics.Stopwatch]::StartNew()
   # What it runs can see that it is timed and where: `check_agent_continuity.ps1 -Finish` refuses to
   # start without this (SPEC-283, CR_LIFECYCLE.md §9).
   $env:ORVION_TIMED_LOG = $Log
   # Workbench adoption: bind a self-Finish to this runner and its actual selected root.
   $env:ORVION_TIMED_ROOT = [IO.Path]::GetFullPath($WorkingDirectory)
   $env:ORVION_TIMED_PID = [string]$PID
   '[{0}] START pid={1} {2} | {3}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $PID, $envLabel, $Command | Out-File -LiteralPath $Log -Encoding utf8
   # Stamped to a thousandth of a minute (0.06 s), culture-invariant, so every test line a suite prints
   # carries its own measurable time (SPEC-283); a tenth of a minute hid every test shorter than 6 s.
   function Stamp { $sw.Elapsed.TotalMinutes.ToString('0.000', [Globalization.CultureInfo]::InvariantCulture).PadLeft(8) }
   # RESOURCES. While the command runs, free memory, this run's own process tree and CPU are sampled to
   # `<log>.resources.csv` every ORVION_RESOURCE_SECONDS (default 60), and one summary line precedes END,
   # so the conditions behind a slow or killed run (a suite was killed at 1.7 GB free on 2026-10-12) and
   # the headroom for running two suites together are measured, not guessed. It observes only. A host
   # without these Windows counters, such as a hosted Linux runner, says `RESOURCES: unavailable`.
   $resources = "$Log.resources.csv"; $sampler = $null
   if ($IsWindows) {
       $every = 60; if (-not [int]::TryParse("$env:ORVION_RESOURCE_SECONDS", [ref]$every) -or $every -lt 1) { $every = 60 }
       $sampler = Start-ThreadJob -ArgumentList $PID, $resources, $every -ScriptBlock {
           param($Root, $Path, $Seconds)
           $inv = [Globalization.CultureInfo]::InvariantCulture
           'at,free_gb,tree_mb,cpu_pct' | Out-File -LiteralPath $Path -Encoding utf8
           while ($true) {
               $all = @(Get-CimInstance Win32_Process -Property ProcessId, ParentProcessId, WorkingSetSize)
               $ids = [Collections.Generic.HashSet[int]]::new(); [void]$ids.Add($Root)
               do { $n = $ids.Count; foreach ($p in $all) { if ($ids.Contains([int]$p.ParentProcessId)) { [void]$ids.Add([int]$p.ProcessId) } } } while ($ids.Count -gt $n)
               $tree = ($all | Where-Object { $ids.Contains([int]$_.ProcessId) } | Measure-Object WorkingSetSize -Sum).Sum / 1MB
               $free = (Get-CimInstance Win32_OperatingSystem -Property FreePhysicalMemory).FreePhysicalMemory / 1MB
               $cpu = (Get-CimInstance Win32_Processor -Property LoadPercentage | Measure-Object LoadPercentage -Average).Average
               [string]::Format($inv, '{0:yyyy-MM-dd HH:mm:ss},{1:0.00},{2:0},{3:0}', (Get-Date), $free, $tree, $cpu) | Out-File -LiteralPath $Path -Append -Encoding utf8
               Start-Sleep -Seconds $Seconds
           }
       }
   }
   pwsh -NoProfile -Command "$Command`nexit `$LASTEXITCODE" 2>&1 | ForEach-Object { '[+{0} min] {1}' -f (Stamp), $_ } | Out-File -LiteralPath $Log -Append -Encoding utf8
   # `pwsh -Command` collapses a child's exit code to 1 unless it is propagated explicitly, exactly as
   # `check_agent_continuity.ps1` Invoke-Verification does; the appended `exit $LASTEXITCODE` is that propagation.
   $code = $LASTEXITCODE
   if ($sampler) { Stop-Job $sampler; Remove-Job $sampler -Force }
   # A sample cut off by Stop-Job is dropped, never allowed to disturb END or the exit code.
   $summary = try {
       $inv = [Globalization.CultureInfo]::InvariantCulture; $x = 0.0
       $rows = @(if ($sampler -and (Test-Path -LiteralPath $resources)) { Import-Csv -LiteralPath $resources | Where-Object { [double]::TryParse("$($_.cpu_pct)", [Globalization.NumberStyles]::Float, $inv, [ref]$x) } })
       if (-not $rows.Count) { 'RESOURCES: unavailable' } else {
           $col = { param($Name) $rows | ForEach-Object { [double]::Parse($_.$Name, $inv) } }
           [string]::Format($inv, 'RESOURCES: samples={0} min_free_gb={1:0.00} peak_tree_mb={2:0} max_cpu_pct={3:0} ({4})', $rows.Count,
               (& $col free_gb | Measure-Object -Minimum).Minimum, (& $col tree_mb | Measure-Object -Maximum).Maximum, (& $col cpu_pct | Measure-Object -Maximum).Maximum, $resources) }
   } catch { "RESOURCES: unreadable ($($_.Exception.Message))" }
   '[+{0} min] {1}' -f (Stamp), $summary | Out-File -LiteralPath $Log -Append -Encoding utf8
   $after = Get-ConcurrentScripts
   '[+{0} min] END exit={1} total={2} min concurrent_end={3}' -f (Stamp), $code, $sw.Elapsed.TotalMinutes.ToString('0.0', [Globalization.CultureInfo]::InvariantCulture), $(if ($after.Count) { $after -join ',' } else { '0' }) | Out-File -LiteralPath $Log -Append -Encoding utf8
   exit $code
   ```

   The resulting file's Git blob is 7e688fc261ed4041878b32dc3ff855222ee0454b.

13. Check whether `lib/watch_run.ps1` contains `|UNREADABLE|REFUSED|`; if so record Already Applied when its Git blob is a51f2877987bdb9a8050576e51f41439fd40b324, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (the bounded Workbench local governance kernel), and change nothing else:

   ```text
   # ORVION run watcher -- ON-DEMAND REPORTING ADAPTER (AGENTS.md section 7). It owns no truth.
   #
   # Follows a log written by `scripts/run_timed.ps1` and prints:
   #   * the run's start and the watcher's own attach time, so a late watch is visible;
   #   * every RESULT line, with the minutes since the run started and since the previous result;
   #   * a heartbeat when the log has been silent for -QuietMinutes, naming the repository script the
   #     runner is executing at that moment and its CPU time, so a long stage is distinguishable from
   #     a stall, and an ETA from comparable past runs (or why there is none);
   #   * RUNNER GONE when the runner's process has exited without writing its END line (killed or
   #     crashed), and a notice when no runner has started at all;
   #   * FINDINGS, each once per run and labelled by what the evidence supports: [confirmed] for a fact the
   #     log and the history establish (a failure that also failed in earlier runs), [hypothesis] for a
   #     comparison that needs a person to judge (a command run twice, a step or a run slower than its
   #     history, steps every recent successful run had and this one lacks);
   #   * at END, a comparison with the previous recorded run of the same -Run name, with both runs'
   #     conditions, so a timing is never compared without knowing what else was running.
   # With -Brief, for an agent's monitor, it prints only what needs attention - failures, findings,
   # heartbeats, RUNNER GONE and the end - plus a progress line every -ProgressMinutes; everything else is
   # still recorded.
   #
   # Every result, every TEST line a suite prints (`PASS <name>`, `FAIL <name>`, TAP `ok`/`not ok`), every
   # evaluator stage (`TIME: STAGES`) and every finding is appended to a LOCAL timings file outside the
   # repository, with the run's log as its evidence reference; a test's time is the time since the line
   # before it, and a failed test is a test like any other, also printed and counted as a failure. That
   # file is the one timing history: the evaluator appends the runs nobody timed (SPEC-283), and -Report
   # reads it - where the time goes, the slowest tests and stages, which runs regressed, and which failures
   # recur, each normalised by how often that run executes. It never exceeds -MaxBytes (10 MB, about
   # 50,000 rows, measured to load in about a second): every append, the evaluator's or a watcher's, keeps
   # the newest rows within half of it once it passes the limit (Add-TimingRows).
   # What the watcher prints and writes to the history is redacted of values shaped like a known
   # credential (Hide-Secret). The runner's log, which each row names as its evidence, is the run's RAW
   # output and is not redacted; it stays where the agent wrote it.
   # It exits 0 only when the run ended `END exit=0`; a run that ended non-zero, or a runner that died,
   # exits 1, so a background notification never reports a failed run as a clean watch.
   #
   # It never retries, reruns, dismisses or approves anything, never classifies a failure's cause, and
   # never changes a file but its own history. `-Finish` and `-Certify` remain the only verdicts, a
   # finding is evidence for the reader to judge, and a [hypothesis] is never reported as a defect.
   #
   # Usage:
   #   pwsh -NoProfile -File scripts/watch_run.ps1 -Log <file> -Run finish-control [-Brief]
   #   pwsh -NoProfile -File scripts/watch_run.ps1 -Log <file> -Run finish-control -Eta    # one estimate, now
   #   pwsh -NoProfile -File scripts/watch_run.ps1 -Report [-Run finish-control]          # the history
   param(
       [string]$Log,
       [string]$Run,
       [double]$QuietMinutes = 5,
       [double]$PollSeconds = 10,
       [string]$Csv = (Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'ORVION\timings.csv'),
       [switch]$Eta,
       [switch]$Report,
       [switch]$Brief,
       [double]$ProgressMinutes = 10,
       [long]$MaxBytes = 10MB
   )

   # RESULT VOCABULARY, derived from what the repository's scripts actually print:
   #   * `check_agent_continuity.ps1` Invoke-Verification step lines: `PASS: <cmd>`, `FAILED: <cmd> (exit N)`;
   #   * verdict lines `<LABEL>: <WORD>`, the words being every one a script prints outside its tests:
   #     CLEAN, READY, PASSED, COMPLETE, DONE, PENDING, UNPROVEN, FAILED, BLOCKED, INCOMPLETE,
   #     RECOVERY_EXHAUSTED, `NOT ...` and `N issue(s)` (scripts/*.ps1 and .workstation/*.ps1, 2026-10-09);
   #   * `check_repository_consistency.ps1` issue lines, indented `  <MULTI WORD LABEL>: ...`;
   #   * `CODE:` / `EVIDENCE:` refusals, suite totals `N passed, M failed`, TAP `not ok`, `ERROR:`,
   #     mutation verdicts, and the runner's own `END exit=N`;
   #   * the evaluator's `TIME:` lines for each run, stage, profile and verification command (SPEC-283).
   # Structural families rather than a hand list of labels, so a new label of a known family is still
   # reported. CASE-SENSITIVE on purpose: with PowerShell's default case-insensitive `-match`, `FAIL\b`
   # matches the prose "fail-closed". Per-assertion `PASS 101 ...` lines are deliberately not results;
   # every `FAIL` is. Both are TESTS, recorded with their own time; a failed one is also printed. A line is
   # judged a test FIRST, so `FAIL <name>` and TAP `not ok` - which the result vocabulary also matches - are
   # timed and reported as the tests they are. A TAP `not ok` with a TODO or SKIP directive is not a
   # failure (TAP 14 specification, "Directives").
   $script:ResultRx = '(^(PASS|FAILED|SKIPPED?): .*|^\s*[A-Z][A-Z0-9_-]*(?: [A-Z0-9_-]+)*: (CLEAN|READY|PASSED|COMPLETE|DONE|PENDING|UNPROVEN|FAILED|BLOCKED|INCOMPLETE|RECOVERY_EXHAUSTED|UNREADABLE|REFUSED|NOT [A-Z]+|\d+ issue).*|^\s+[A-Z][A-Z0-9-]*(?: [A-Z0-9-]+)+: .*|^(CODE|EVIDENCE): (?!none\b).*|^\s*FAIL\b.*|\b\d+ passed, \d+ failed\b|\bnot ok\b|\bERROR:.*|ALL CHECKS PASSED|\bKILLED\b|\bSURVIVED\b|^END exit=\d+|^TIME: .*)'
   function Test-ResultLine([string]$body) { $body -cmatch $script:ResultRx }
   $script:TestRx = '^\s*(PASS|FAIL)\s+[^:\s]\S*|^(not )?ok \d+\b'
   function Test-TestLine([string]$body) { $body -cmatch $script:TestRx }
   $script:FailedTestRx = '^\s*FAIL\s|^not ok\b(?!.*#\s*(?i:todo|skip)\b)'
   # What -Brief still prints: anything that is or may be a failure, and the end. A pass prints nothing.
   $script:AttentionRx = '(\bFAIL|\bFAILED\b|BLOCKED|^CODE: |\bnot ok\b|\bERROR:|\bSURVIVED\b|INCOMPLETE|UNPROVEN|UNREADABLE|REFUSED|RECOVERY_EXHAUSTED|\b[1-9]\d* failed\b|^END exit=|CERTIFY: )'

   # The runner's START line: `[yyyy-MM-dd HH:mm:ss] START pid=N <environment> | <command>`.
   function Read-StartLine([string]$line) {
       $m = [regex]::Match($line, '^\[(?<at>\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)\] START pid=(?<pid>\d+) (?<env>[^|]*?) \| ')
       if (-not $m.Success) { return $null }
       [pscustomobject]@{ At = [datetime]$m.Groups['at'].Value; Pid = [int]$m.Groups['pid'].Value; Env = $m.Groups['env'].Value.Trim() }
   }

   # The newest live descendant of the runner, named by the repository script it runs when it runs one.
   function Get-RunningStage([int]$RunnerPid) {
       $all = @(Get-CimInstance Win32_Process)
       $kids = @{}; foreach ($p in $all) { $kids[[int]$p.ParentProcessId] += @($p) }
       $desc = [Collections.Generic.List[object]]::new(); $queue = [Collections.Generic.Queue[int]]::new(); $queue.Enqueue($RunnerPid)
       while ($queue.Count) { foreach ($c in @($kids[$queue.Dequeue()])) { if ($c) { $desc.Add($c); $queue.Enqueue([int]$c.ProcessId) } } }
       $scripted = @($desc | Where-Object { $_.CommandLine -match 'scripts[\\/][\w.-]+\.ps1' } | Sort-Object CreationDate)
       $stage = if ($scripted.Count) { $scripted[-1] } elseif ($desc.Count) { @($desc | Sort-Object CreationDate)[-1] } else { $null }
       if (-not $stage) { return 'the runner has no child process' }
       $name = if ($stage.CommandLine -match '(scripts[\\/][\w.-]+\.ps1)') { $Matches[1] } else { $stage.Name }
       $cpu = (Get-Process -Id $stage.ProcessId -ErrorAction SilentlyContinue).CPU
       'running {0} since {1} (cpu {2:N0}s)' -f $name, $stage.CreationDate.ToString('HH:mm:ss'), $cpu
   }

   # ---- history: the timings file, read as runs (SPEC-283) ---------------------------------------------
   # A value that looks like a credential never reaches the screen or the history.
   function Hide-Secret([string]$Text) {
       # GitHub's documented token prefixes (ghp_, gho_, ghu_, ghs_, ghr_, github_pat_), common API keys and
       # JWTs by shape; then any `key=value` or `key: value` whose key names a credential, and a bearer value.
       $t = $Text -replace '\b(gh[pousr]_[A-Za-z0-9]{20,}|github_pat_\w{20,}|sk-[A-Za-z0-9_-]{20,}|eyJ[\w-]{10,}\.[\w-]{10,}\.[\w-]+)', '<redacted>'
       $t = $t -replace '(?i)\bbearer\s+(?!<redacted>)\S+', 'Bearer <redacted>'
       $t -replace '(?i)\b(token|secret|password|passwd|api[_-]?key|authorization)(\s*[:=]\s*)(?!Bearer <redacted>)(?!<redacted>)\S+', '$1$2<redacted>'
   }
   # A step's identity across runs: its text without the elapsed time it carries or the evidence after ` :: `.
   function Get-StepKey([string]$step) { ((($step -replace ' :: .*$', '') -replace ' \d\d:\d\d:\d\d\s*$', '') -replace '\s+', ' ').Trim() }
   function ConvertTo-Minutes([string]$Value) { [double]::Parse($Value, [Globalization.NumberStyles]::Float -bor [Globalization.NumberStyles]::AllowThousands, [Globalization.CultureInfo]::InvariantCulture) }
   function Format-Minutes([double]$Value) { $Value.ToString('0.0###', [Globalization.CultureInfo]::InvariantCulture) }
   function Get-Median([double[]]$Values) { $s = @($Values | Sort-Object); if (-not $s.Count) { return $null }; if ($s.Count % 2) { $s[($s.Count - 1) / 2] } else { ($s[$s.Count / 2 - 1] + $s[$s.Count / 2]) / 2 } }
   # A `TIME:` line states its own duration, which is truer than the gap between two log stamps.
   function Get-StatedMinutes([string]$step) { if ($step -match ' (\d\d):(\d\d):(\d\d)\s*$') { [int]$Matches[1] * 60 + [int]$Matches[2] + [int]$Matches[3] / 60 } else { $null } }
   # `TIME: STAGES <mode> a=1.23s b=0.40s` as one row per stage.
   function Split-Stages([string]$body) {
       $m = [regex]::Match($body, '^TIME: STAGES (?<mode>.+?) (?=\S+=[\d.]+s\b)'); if (-not $m.Success) { return }
       foreach ($s in [regex]::Matches($body, '(?<n>[^\s=]+)=(?<v>[\d.]+)s\b')) { [pscustomobject]@{ Step = "STAGE $($m.Groups['mode'].Value) $($s.Groups['n'].Value)"; Minutes = [double]::Parse($s.Groups['v'].Value, [Globalization.CultureInfo]::InvariantCulture) / 60 } }
   }
   function Get-StepKind([string]$step) {
       if ($step -like 'END exit=*') { 'end' } elseif ($step -like 'finding *') { 'finding' } elseif ($step -like 'STAGE *') { 'stage' }
       elseif ($step -like 'TIME: *') { 'time' } elseif (Test-TestLine $step) { 'test' } else { 'result' }
   }
   # Every run of one -Run name but $Exclude: its steps, an index of each step's first occurrence, whether it
   # ended, and whether it ended `END exit=0`.
   function Read-History([object[]]$rows, [string]$name, [string]$Exclude = '') {
       foreach ($g in @($rows | Where-Object { $_.run -eq $name -and $_.date -ne $Exclude } | Group-Object date)) {
           $steps = @($g.Group | ForEach-Object { [pscustomobject]@{ Key = (Get-StepKey $_.step); T = (ConvertTo-Minutes $_.elapsed_min); Delta = (ConvertTo-Minutes $_.delta_min); Step = $_.step; Kind = (Get-StepKind $_.step) } })
           $index = @{}; foreach ($s in $steps) { if (-not $index.ContainsKey($s.Key)) { $index[$s.Key] = $s } }
           $end = @($steps | Where-Object { $_.Kind -eq 'end' }) | Select-Object -Last 1
           [pscustomobject]@{ Date = $g.Name; Ended = [bool]$end; Ok = [bool]($end -and $end.Step -match '^END exit=0\b'); Total = $(if ($end) { $end.T } else { $null }); Steps = $steps; Index = $index }
       }
   }
   # Minutes left, from what the last 10 comparable SUCCESSFUL runs still had to do after this step: failed
   # and unfinished runs distort a duration, and a median with its range, not a mean, describes a long-tailed
   # one (CI practice: Jenkins, TeamCity, Metabase). Two runs at least, or no estimate - one sample is a
   # guess - and fewer than five are labelled a low sample.
   function Get-Recent([object[]]$history, [int]$n) { @($history | Where-Object { $_.Ok } | Sort-Object Date | Select-Object -Last $n) }
   function Get-Eta([object[]]$history, [string]$key, [double]$Since, [double]$now, [int]$TestCount = 0) {
       $byCount = $TestCount -gt 0 -and (Test-TestLine $key)
       $countLabel = ''
       if ($byCount) {
           $samples = @(foreach ($h in (Get-Recent $history 10)) {
               $testRows = @($h.Steps | Where-Object Kind -eq 'test')
               if ($testRows.Count -ge $TestCount) {
                   $s = $testRows[$TestCount - 1]
                   if ($s.Key -ceq $key) { [pscustomobject]@{ Count = $testRows.Count; Left = $h.Total - $s.T - $Since } }
               }
           })
           if ($samples.Count -lt 2) { return "eta: none - $($samples.Count) comparable successful run(s) at observed test count $TestCount" }
           $totals = @($samples | ForEach-Object { $_.Count } | Sort-Object -Unique)
           if ($totals.Count -ne 1) { return 'eta: none - incompatible historical test totals at this observed test count' }
           $left = @($samples | ForEach-Object { $_.Left })
           $countLabel = ", by observed test count $TestCount (historical total $($totals[0]) tests)"
       } else {
           $left = @(foreach ($h in (Get-Recent $history 10)) {
               if ($key) { $s = $h.Index[$key]; if ($s) { $h.Total - $s.T - $Since } } else { $h.Total - $now }
           })
           # Non-test stages retain the existing measured step/total fallback; tests never guess a count match.
           if ($left.Count -lt 2 -and $key) { return Get-Eta $history '' $Since $now }
       }
       if ($left.Count -lt 2) { return "eta: none - $($left.Count) comparable successful run(s) in the history$(if ($key) { ' reached this step' })" }
       $s = @($left | Sort-Object)
       'eta: ~{0:N1} min left (median of {1} comparable successful runs{5}{4}; range {2:N1} to {3:N1})' -f [Math]::Max(0, (Get-Median $s)), $s.Count, [Math]::Max(0, $s[0]), [Math]::Max(0, $s[-1]), $(if ($s.Count -lt 5) { ', low sample' }), $(if ($byCount) { $countLabel } elseif (-not $key) { ', by run totals' })
   }
   # Findings on one recorded line. $State dedupes them per run and counts this run's commands and steps.
   function New-FindingState { [pscustomobject]@{ Said = [Collections.Generic.HashSet[string]]::new(); Keys = [Collections.Generic.HashSet[string]]::new(); Commands = @{} } }
   function Get-StepFindings([object[]]$history, $state, [string]$body, [double]$delta) {
       $key = Get-StepKey $body; [void]$state.Keys.Add($key); $found = @()
       if ($body -cmatch '^(FAILED: |CODE: )|\bERROR:' -or $body -cmatch $script:FailedTestRx) {
           $prior = @($history | Where-Object { $_.Index.ContainsKey($key) })
           if ($prior.Count) { $found += "finding [confirmed] recurring failure: $key - also in $($prior.Count) of $(@($history).Count) earlier runs" }
       }
       if ($body -cmatch '^(PASS|FAILED): (?<cmd>.+?)(?: \(exit \d+\))?$') {
           $cmd = $Matches['cmd']; $state.Commands[$cmd] = 1 + [int]$state.Commands[$cmd]
           if ($state.Commands[$cmd] -eq 2) { $found += "finding [hypothesis] repeated execution: $cmd ran twice in this run - wasteful unless its profile lists it twice on purpose" }
       }
       $d = @(foreach ($h in (Get-Recent $history 10)) { $s = $h.Index[$key]; if ($s) { $s.Delta } })
       if ($d.Count -ge 3) { $med = Get-Median $d; if ($delta -gt [Math]::Max(1.5 * $med, $med + 1)) { $found += ('finding [hypothesis] slow step: {0} took {1:N1} min against a median of {2:N1} over {3} successful runs' -f $key, $delta, $med, $d.Count) } }
       @($found | Where-Object { $state.Said.Add($_) })
   }
   # At END: steps each of the last successful runs had and this one lacks (one finding, however many), and
   # a run slower than they were.
   function Get-EndFindings([object[]]$history, $state, [double]$Total) {
       $ok = Get-Recent $history 5; $found = @()
       if ($ok.Count -ge 3) {
           $absent = @($ok[0].Index.Keys | Where-Object { $_ -notlike 'END exit=*' -and $_ -notlike 'finding *' -and -not $state.Keys.Contains($_) } | Where-Object { $k = $_; -not @($ok | Where-Object { -not $_.Index.ContainsKey($k) }).Count } | Sort-Object)
           if ($absent.Count -eq 1) { $found += "finding [hypothesis] expected step absent: $($absent[0]) - present in each of the last $($ok.Count) successful runs" }
           elseif ($absent.Count) { $found += "finding [hypothesis] expected steps absent: $($absent.Count) steps each of the last $($ok.Count) successful runs had (first: $($absent[0]))" }
           $med = Get-Median @($ok | ForEach-Object { $_.Total })
           if ($Total -gt [Math]::Max(1.25 * $med, $med + 2)) { $found += ('finding [hypothesis] slower run: {0:N1} min against a median of {1:N1} over the last {2} successful runs' -f $Total, $med, $ok.Count) }
       }
       @($found | Where-Object { $state.Said.Add($_) })
   }
   # The history, summarised: where the time goes, the slowest tests and stages, which runs regressed, which
   # failures recur. A failure rate is per run of its own -Run name, so a run that executes often is not
   # ranked worse for being run. The top lists are views; every row stays in the history.
   function Format-Report([object[]]$rows, [string]$Only) {
       $rates = @()
       foreach ($n in @($rows | ForEach-Object { $_.run } | Sort-Object -Unique | Where-Object { -not $Only -or $_ -eq $Only })) {
           $h = @(Read-History $rows $n); $ok = @($h | Where-Object { $_.Ok } | Sort-Object Date); $ended = @($h | Where-Object { $_.Ended })
           $line = '{0}: {1} runs, {2} ended, {3} succeeded' -f $n, $h.Count, $ended.Count, $ok.Count
           if ($ok.Count) {
               $t = @($ok | ForEach-Object { $_.Total } | Sort-Object); $med = Get-Median $t
               $line += '; median {0:N2} min, p90 {1:N2}' -f $med, $t[[Math]::Max(0, [Math]::Ceiling(0.9 * $t.Count) - 1)]
               if ($ok.Count -ge 3 -and $ok[-1].Total -gt [Math]::Max(1.25 * $med, $med + 2)) { $line += ('; REGRESSION [hypothesis]: latest {0:N2} min' -f $ok[-1].Total) }
           }
           $line
           $share = @{}; $sum = 0.0
           foreach ($r in $ok) { foreach ($s in $r.Steps) { if ($s.Kind -ne 'result') { continue }; $share[$s.Key] += $s.Delta; $sum += $s.Delta } }
           if ($sum -gt 0) { foreach ($e in @($share.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 3)) { '  time {0,3:N0}%  {1}' -f (100 * $e.Value / $sum), $e.Key } }
           # A stage's or a test's time is its own whether its run succeeded or not, so a failed test is ranked too.
           foreach ($kind in 'stage', 'test') {
               $per = @{}; foreach ($r in $h) { foreach ($s in @($r.Steps | Where-Object { $_.Kind -eq $kind })) { $per[$s.Key] += @($s.Delta) } }
               foreach ($e in @($per.GetEnumerator() | ForEach-Object { [pscustomobject]@{ Key = $_.Key; Med = (Get-Median $_.Value) } } | Sort-Object Med -Descending | Select-Object -First 5)) { '  slowest {0} {1,7:N3} min  {2}' -f $kind, $e.Med, $e.Key }
           }
           foreach ($k in @($h | ForEach-Object { @($_.Steps | Where-Object { $_.Step -cmatch '^(FAILED: |CODE: |END exit=[1-9])' -or $_.Step -cmatch $script:FailedTestRx } | ForEach-Object { $_.Key } | Select-Object -Unique) } | Group-Object)) {
               $rates += [pscustomobject]@{ Run = $n; Key = $k.Name; Runs = $k.Count; Of = $h.Count; Rate = $k.Count / [Math]::Max(1, $h.Count) }
           }
           $f = @($h | ForEach-Object { $_.Steps } | Where-Object { $_.Kind -eq 'finding' } | ForEach-Object { $_.Key -replace '^(finding \[\w+\] [^:]+):.*$', '$1' } | Group-Object)
           if ($f.Count) { '  findings: ' + (@($f | ForEach-Object { "$($_.Name) x$($_.Count)" }) -join '; ') }
       }
       $ranked = @($rates | Where-Object { $_.Of -ge 3 } | Sort-Object @{ Expression = 'Rate'; Descending = $true }, @{ Expression = 'Of'; Descending = $true } | Select-Object -First 8)
       if ($ranked.Count) { 'failures by rate (runs affected / runs of that name; names with at least 3 runs):' }
       foreach ($x in $ranked) { '  {0,3:N0}%  {1} in {2} of {3} {4} runs{5}' -f (100 * $x.Rate), $x.Key, $x.Runs, $x.Of, $x.Run, $(if ($x.Runs -ge 2) { ' - investigate [hypothesis]: a Skill, Guard or Hook is a candidate only once the Improvement Loop shows need, gap and value' }) }
   }
   # The history's one write path, shared VERBATIM with scripts/check_agent_continuity.ps1 (scripts/watch_selftest.ps1
   # holds the two copies equal). A named mutex per history file serialises every writer and the watcher's
   # reads across processes, so an append never interleaves with another append or with a trim. The bound
   # holds after every append: past $MaxBytes the history keeps its newest whole rows within half of it,
   # written to a temporary file beside it and moved over it, so the history is never rewritten in place.
   function Use-TimingHistory([string]$Path, [scriptblock]$body) {
       $id = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes([IO.Path]::GetFullPath($Path).ToLowerInvariant())))
       $lock = [Threading.Mutex]::new($false, 'Global\ORVION-timings-' + $id.Substring(0, 32))
       try {
           # An abandoned mutex (its holder was killed) is acquired: the history is only ever replaced whole.
           try { if (-not $lock.WaitOne(15000)) { throw "the timing history $Path stayed locked for 15 s" } } catch [Threading.AbandonedMutexException] { }
           try { & $body } finally { $lock.ReleaseMutex() }
       } finally { $lock.Dispose() }
   }
   function Add-TimingRows([string]$Path, [string[]]$rows, [long]$MaxBytes) {
       Use-TimingHistory $Path {
           if (-not [IO.File]::Exists($Path)) { [IO.File]::WriteAllText($Path, 'run,date,step,elapsed_min,delta_min,env' + [Environment]::NewLine) }
           if ($rows.Count) { [IO.File]::AppendAllText($Path, ($rows -join [Environment]::NewLine) + [Environment]::NewLine) }
           if ([IO.FileInfo]::new($Path).Length -le $MaxBytes) { return }
           $b = [IO.File]::ReadAllBytes($Path); $h = [Array]::IndexOf($b, [byte]10) + 1
           $n = [Array]::IndexOf($b, [byte]10, [int][Math]::Max($h, $b.Length - [Math]::Floor($MaxBytes / 2))); $cut = if ($n -lt 0) { $b.Length } else { $n + 1 }
           $tmp = "$Path.tmp"; $f = [IO.File]::Create($tmp); try { $f.Write($b, 0, $h); $f.Write($b, $cut, $b.Length - $cut) } finally { $f.Dispose() }
           [IO.File]::Move($tmp, $Path, $true)
           'history: kept the newest {0:N0} of {1:N0} bytes of rows (limit {2:N0})' -f ($b.Length - $cut), ($b.Length - $h), $MaxBytes
       }
   }
   function Read-TimingRows([string]$Path) {
       try { @((Use-TimingHistory $Path { [IO.File]::ReadAllLines($Path) }) | ConvertFrom-Csv) } catch { Write-Warning "history: not read - $($_.Exception.Message)"; @() }
   }
   function Write-Row([string]$Path, [string]$name, [string]$identity, [string]$step, [double]$t, [double]$delta, [string]$conditions) {
       try { Add-TimingRows $Path @('"{0}","{1}","{2}",{3},{4},"{5}"' -f $name, $identity, ($step -replace '"', "'"), (Format-Minutes $t), (Format-Minutes $delta), $conditions) $MaxBytes }
       catch { "history: row not written - $($_.Exception.Message)" }
   }

   if ($MyInvocation.InvocationName -eq '.') { return }   # dot-sourced by scripts/watch_selftest.ps1 for the functions above
   $ErrorActionPreference = 'Continue'
   [void][IO.Directory]::CreateDirectory((Split-Path $Csv -Parent))
   try { Add-TimingRows $Csv @() $MaxBytes } catch { "history: not prepared - $($_.Exception.Message)" }   # creates it; bounds one an older writer left over its limit
   if ($Report) { Format-Report @(Read-TimingRows $Csv) $Run; exit 0 }
   if (-not $Log -or -not $Run) { throw 'usage: watch_run.ps1 -Log <run_timed log> -Run <stable name> [-Brief] [-Eta] | -Report [-Run <name>]' }
   $Log = [IO.Path]::GetFullPath($Log, (Get-Location).Path)
   $StampRx = '^\[\+\s*(?<t>[\d.]+) min\] (?<body>.*)$'

   if ($Eta) {
       $first = if (Test-Path -LiteralPath $Log) { Read-StartLine (Get-Content -LiteralPath $Log -TotalCount 1 -Encoding utf8) }
       if (-not $first) { 'eta: none - no START line in the log yet'; exit 0 }
       $lines = @(Get-Content -LiteralPath $Log -Encoding utf8 | ForEach-Object { [regex]::Match($_, $StampRx) } | Where-Object { $_.Success -and ((Test-ResultLine $_.Groups['body'].Value) -or (Test-TestLine $_.Groups['body'].Value)) })
       $now = ((Get-Date) - $first.At).TotalMinutes
       $hist = @(Read-History @(Read-TimingRows $Csv) $Run $first.At.ToString('yyyy-MM-dd HH:mm:ss'))
       if ($lines.Count -and $lines[-1].Groups['body'].Value -match '^END exit=') { "eta: the run has ended ($($lines[-1].Groups['body'].Value))"; exit 0 }
       if ($lines.Count) { $t = [double]::Parse($lines[-1].Groups['t'].Value, [Globalization.CultureInfo]::InvariantCulture); Get-Eta $hist (Get-StepKey $lines[-1].Groups['body'].Value) ($now - $t) $now (@($lines | Where-Object { Test-TestLine $_.Groups['body'].Value }).Count) } else { Get-Eta $hist '' 0 $now }
       exit 0
   }

   $wait = [Diagnostics.Stopwatch]::StartNew(); $lastNote = 0.0; $start = $null
   while (-not $start) {
       if (Test-Path -LiteralPath $Log) { $start = Read-StartLine (Get-Content -LiteralPath $Log -TotalCount 1 -Encoding utf8) }
       if ($start) { break }
       if ($wait.Elapsed.TotalMinutes - $lastNote -ge $QuietMinutes) { $lastNote = $wait.Elapsed.TotalMinutes; 'heartbeat: no log or no START line after {0:N1} min - the runner may not have started' -f $wait.Elapsed.TotalMinutes }
       Start-Sleep -Seconds ([Math]::Min(2, $PollSeconds))
   }
   $identity = $start.At.ToString('yyyy-MM-dd HH:mm:ss')   # identifies THIS run; a re-armed watcher computes the same value
   'watching {0} (started {1}, attached {2}, runner pid {3}; {4})' -f $Run, $identity, (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $start.Pid, $start.Env
   $rows = @(Read-TimingRows $Csv); $have = @{}; $rows | ForEach-Object { $have[($_.run, $_.date, $_.step, $_.elapsed_min) -join '|'] = 1 }
   $history = @(Read-History $rows $Run $identity); $state = New-FindingState; $conditions = "$($start.Env) log=$Log"; $lastKey = ''
   function Save-Step([string]$step, [double]$t, [double]$delta) {
       $key = ($Run, $identity, $step, (Format-Minutes $t)) -join '|'
       if (-not $have.ContainsKey($key)) { $have[$key] = 1; Write-Row $Csv $Run $identity $step $t $delta $conditions }
   }
   $replaying = $true; $seen = 0; $last = 0.0; $prevLine = 0.0; $tests = 0; $results = 0; $failed = 0; $lastProgress = 0.0; $quiet = [Diagnostics.Stopwatch]::StartNew()
   while ($true) {
       $lines = @(Get-Content -LiteralPath $Log -Encoding utf8)
       if ($lines.Count -gt $seen) {
           foreach ($line in $lines[$seen..($lines.Count - 1)]) {
               $m = [regex]::Match($line, $StampRx)
               if (-not $m.Success) { continue }
               $t = [double]::Parse($m.Groups['t'].Value, [Globalization.CultureInfo]::InvariantCulture); $body = Hide-Secret $m.Groups['body'].Value
               $sinceLine = $t - $prevLine; $prevLine = $t
               if ($Brief -and ((-not $replaying -and $t - $lastProgress -ge $ProgressMinutes) -or ($replaying -and $body -match '^END exit='))) {
                   $lastProgress = $t; $now = ((Get-Date) - $start.At).TotalMinutes
                   'progress: {0:N1} min - {1} tests and {2} results so far, {3} failing; {4}' -f $t, $tests, $results, $failed, (Get-Eta $history $lastKey ($now - $t) $now $tests)
               }
               $step = ($body.Substring(0, [Math]::Min(160, $body.Length))) -replace '"', "'"
               if (Test-TestLine $body) {
                   $tests++; $lastKey = Get-StepKey $step; Save-Step $step $t $sinceLine
                   if ($body -cmatch $script:FailedTestRx) { $failed++; '[{0,5:N1} min | +{1:N1}] {2}' -f $t, $sinceLine, $step }
                   foreach ($f in (Get-StepFindings $history $state $step $sinceLine)) { $f; Save-Step $f $t 0 }
                   continue
               }
               if (-not (Test-ResultLine $body)) { continue }
               $results++; if ($body -cmatch $script:AttentionRx -and $body -notmatch '^END exit=0\b|\b0 failed\b|: READY\b') { $failed++ }
               $delta = $t - $last; $last = $t; $lastKey = Get-StepKey $step
               if (-not $Brief -or $body -cmatch $script:AttentionRx) { '[{0,5:N1} min | +{1:N1}] {2}' -f $t, $delta, $step }
               $stages = @(Split-Stages $body)
               if ($stages.Count) { $at = $t; foreach ($s in $stages) { Save-Step $s.Step $at $s.Minutes } }
               else { $stated = Get-StatedMinutes $step; Save-Step $step $t $(if ($null -ne $stated -and $step -like 'TIME: *') { $stated } else { $delta }) }
               $found = if ($body -match '^END exit=') { Get-EndFindings $history $state $t } else { Get-StepFindings $history $state $step $delta }
               foreach ($f in $found) { $f; Save-Step $f $t 0 }
               if ($body -match '^END exit=') {
                   $prev = Read-TimingRows $Csv | Where-Object { $_.run -eq $Run -and $_.step -like 'END exit=*' -and $_.date -ne $identity } | Select-Object -Last 1
                   if ($prev) { 'compare: this run {0:N1} min [{1}] vs previous {2} min on {3} [{4}]' -f $t, $start.Env, $prev.elapsed_min, $prev.date, $prev.env }
                   else { "compare: first recorded run of '$Run' ($('{0:N1}' -f $t) min) [$($start.Env)]" }
                   exit [int]($body -notmatch '^END exit=0\b')
               }
           }
           if($replaying){
               if($Brief-and$prevLine-$lastProgress-ge$ProgressMinutes){
                   $lastProgress=$prevLine;$now=((Get-Date)-$start.At).TotalMinutes
                   'progress: {0:N1} min - {1} tests and {2} results so far, {3} failing; {4}' -f $prevLine,$tests,$results,$failed,(Get-Eta $history $lastKey ($now-$prevLine) $now $tests)
               }
               $lastProgress=$prevLine;$replaying=$false
           }
           $seen = $lines.Count; $quiet.Restart()
       } elseif (-not (Get-Process -Id $start.Pid -ErrorAction SilentlyContinue)) {
           # Re-read once: the END line may have landed between the read above and this check.
           if (@(Get-Content -LiteralPath $Log -Encoding utf8).Count -gt $seen) { continue }
           'RUNNER GONE: process {0} exited without an END line after {1:N1} min (last result at {2:N1} min) - the run did not finish' -f $start.Pid, ((Get-Date) - $start.At).TotalMinutes, $last
           exit 1
       } elseif ($quiet.Elapsed.TotalMinutes -ge $QuietMinutes) {
           $now = ((Get-Date) - $start.At).TotalMinutes
           'heartbeat: no new output for {0:N1} min (last result at {1:N1} min) - {2}; {3}' -f $quiet.Elapsed.TotalMinutes, $last, (Get-RunningStage $start.Pid), (Get-Eta $history $lastKey ($now - $prevLine) $now $tests)
           $quiet.Restart()
       }
       Start-Sleep -Seconds $PollSeconds
   }
   ```

   The resulting file's Git blob is a51f2877987bdb9a8050576e51f41439fd40b324.

14. Check whether `lib/apply-draft-steps.ps1` contains `[switch]$Preview`; if so record Already Applied when its Git blob is 10dc5bda3de02375de39c7764b874fd1f352b2a8, and otherwise stop and report. Otherwise make exactly these 3 edits (the bounded Workbench local governance kernel), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([Parameter(Mandatory)][string]$Draft,[Parameter(Mandatory)][string]$Root)
   ```
   with
   ```text
   param([Parameter(Mandatory)][string]$Draft,[Parameter(Mandatory)][string]$Root,[Alias('Plan')][switch]$Preview)
   ```

   b) replace the line
   ```text
           $plans+= [pscustomobject]@{File=$file;Path=$p;Skip=$true}
   ```
   with
   ```text
           $plans+= [pscustomobject]@{File=$file;Path=$p;Skip=$true;Create=$false;Blob=$want}
   ```

   c) immediately after the lines
   ```text
       $plans+=[pscustomobject]@{File=$file;Path=$p;Skip=$false;Create=$creating;Before=$raw;Text=$text;Blob=$got}
   }
   ```
   insert
   ```text
   if($Preview){
       [ordered]@{Schema=1;Root=[IO.Path]::GetFullPath($Root);DraftSHA256=(Get-FileHash -LiteralPath $Draft -Algorithm SHA256).Hash;
           Files=@($plans|ForEach-Object{[ordered]@{File=$_.File;Blob=$_.Blob;Skip=$_.Skip;Create=$_.Create}})}|ConvertTo-Json -Depth 5
       exit 0
   }
   ```

   The resulting file's Git blob is 10dc5bda3de02375de39c7764b874fd1f352b2a8.

15. Check whether `lib/test-draft-steps.ps1` contains `read-only Plan names the exact Unicode/space target`; if so record Already Applied when its Git blob is 8b08aaeb0eff88c1bf97a98df2d1fdbc27a572f2, and otherwise stop and report. Otherwise make exactly this one edit (the bounded Workbench local governance kernel), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   function Test-CreationCases{
   ```
   insert
   ```text
       $x=New-CreationFixture 'plan-without-writes'
       $beforeConfig=(Get-FileHash -LiteralPath (Join-Path $x.Root '.git/config')).Hash
       $planText=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'apply-draft-steps.ps1') -Draft $x.Draft -Root $x.Root -Plan 2>&1)
       $planExit=$LASTEXITCODE
       $planValue=try{($planText-join[char]10)|ConvertFrom-Json -ErrorAction Stop}catch{$null}
       Assert-DraftCase 'read-only Plan names the exact Unicode/space target and blob without creating it' ($planExit-eq0-and$planValue.Schema-eq1-and$planValue.Files.Count-eq1-and$planValue.Files[0].File-ceq$x.Relative-and$planValue.Files[0].Blob-ceq$x.Want-and!(Test-Path -LiteralPath $x.Path)-and(Get-FileHash -LiteralPath (Join-Path $x.Root '.git/config')).Hash-ceq$beforeConfig) ($planText-join' ')
   ```

   The resulting file's Git blob is 8b08aaeb0eff88c1bf97a98df2d1fdbc27a572f2.

## Acceptance Criteria

- [ ] Every literal target matches its declared result; one owning checker, entry, pointer and existing full test schedule are retained.
- [ ] Routing content is exact while lifecycle pointer changes remain legal; check: normalized-resume:RESUME.md=72C0F8CEF1A08BA4EF511A3CF103CFF9C550672712E418323842518B384431A1
- [ ] Actual index/range consumers reject unauthorized scope, frozen changes, stale/wrong/missing evidence and illegal intermediate transitions; legal controls pass.
- [ ] Three identified immutable assurance snapshots and selected exact approval/root are checked; equal successive content is not rejected merely for equality.
- [ ] Execute uses accepted applier Plan before any implementation write, retains byte/anchor/path preflight and idempotent resume.
- [ ] One fresh real timed/watched self-Finish runs real tests.ps1, with no full-suite replay by Hook/Review/Complete. Original exits/durations and required failures remain visible.
- [ ] CORE works with no products; native product source, governance and release remain independent and untouched.
- [ ] Original source/history is preserved; no owner identity, protected remote, full supervisor, clean-machine recovery or programme-closure claim is inferred.

## Review Gate

- [ ] Independently inspect current Git/index, exact source results, fresh own receipt, runner/watch terminal exits and all acceptance evidence.
- [ ] Verify no native product changes, unrelated dirt, frozen-authority edits, stale evidence transplant or hidden failed mandatory command.
- [ ] Verify exact pending work remains in existing P3 G2c A-H/P4/C and Batch 6 stays held.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Draft preparation only. Append actual approval/root and execution evidence; never manufacture owner approval or rewrite these lines.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-governance-20261023-r2\V3-DRAFT.md
Approved SHA256: 0F7CD48D965BB008D5B8D41CE4402D4ED6D43E7A61280AA21116FA44A883F4B5
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\workbench-governance-20261023-r2-original-execution\owner-approval-binding.txt
Owner Evidence SHA256: 80B961DE41941457AF323FD99D5574F3F4BD2C3539308D9E4D16724BFCD597F2
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools
Original literal implementation applied with accepted original applier; all15 declared output blobs verified. A fresh original timed/watched self-Finish remains mandatory; no sandbox receipt is used.

## Verification Notes

No original execution or Review yet. Append actual live review only after fresh matching self-Finish, then record Verdict: Confirmed Complete, Reviewed Fingerprint and Reviewed Receipt.

## Notes

First-installation import is limited to this exact externally approved Draft plus active pointer, before the old tree has a kernel; the existing normal hook still runs. The reviewed external bootstrap judge is used only until accepted HEAD contains the checker. Subsequent allocations require Draft and normal transitions. Local exact-byte assertions are not authenticated owner identity or protection against equal OS privileges. Root-bound approvals/receipts require a separately governed relocation/recovery procedure. WORKSTATION/CI fail closed until separately implemented under their own approved scope. No native whole-suite rerun is earned by this Workbench change.
