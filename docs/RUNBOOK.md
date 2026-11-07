# Workbench runbook

How-to procedures for Workbench work; every rule they follow is cited by its DEC-NN in docs/DECISIONS.md.
Find a section with `grep -n '^## 3\.' docs/RUNBOOK.md`, then read from that line to the next `##` heading (DEC-32).

## 1. Setting up a checkout

Configure the local hooks once per checkout: `git config core.hooksPath .githooks`. Cloning alone installs neither the
hooks nor the journals and receipts. The engineering entry is `pwsh -NoProfile -File lib/Workbench.ps1 -Boot`.

## 2. Writing a contract

- Statuses: Draft, Approved, In Progress, Complete and Cancelled; runtime verdicts are not statuses. RESUME.md holds
  the one active Workbench contract pointer. Programme progress is live state (DEC-26) and the workstream plan
  (DEC-29), never a second contract registry.
- Create a contract from changes/TEMPLATE.md. Exact scope includes additions, deletions and both sides of renames.
  Local sessions, events, work files and credentials never enter tracked state (DEC-09).
- Freeze the three snapshots of DEC-13 under three distinct IDs and paths; unchanged successive content is allowed.
  The V3 snapshot's digest is supplied by the owner's exact Gate 1 and is not inside the snapshot; the approval
  evidence must identify that digest. It binds local evidence, not the owner's identity (DEC-02).
- Acceptance `check:` clauses are judged feasible at Approval and must still hold at Complete, locally and in CI.
- Machine clauses are closed vocabulary: one plain end-of-line check per criterion, either
  `blob:relative/path=full-lowercase-Git-SHA` or `normalized-resume:RESUME.md=uppercase-SHA256`; unknown or
  duplicated checks refuse. The literal steps' declared resulting blobs own the expected output bytes: the checker
  consumes those declarations without duplicating the applier, and optional blob criteria must agree with them. Every
  PowerShell or hook change needs declared approved output bytes or an explicit blob criterion; Complete checks every
  declared result. Normalized routing excludes only the active pointer, never other authority text, and a literal
  RESUME edit needs its normalized criterion. Undeclared control bodies and control deletion refuse. Windows-valid
  Unicode and space paths stay supported.
- New allocations need the frozen Execution Context section of changes/TEMPLATE.md: one original root, an independent
  push-disabled sandbox parent, short external test, temp and runtime roots, exact PowerShell and Git versions and an
  explicit minimum host headroom (the TEMP bound the evaluator does not check yet: DEC-07). Unknown fields, root
  overlap or reparse paths, the observed unsafe Windows fixture-path length, injected Git environments and changed
  managed runtime variables refuse before heavy work. The sandbox needs its own common directory, no alternates and
  disabled push, and the declared original cannot take that role. Terminal history and schema1 evidence stay as they
  are, never retrofitted.
- One recipe binds the test driver, the ordered owning test scripts, hazard inputs, helper blobs, versions and the
  frozen context. Original Approved execution logs also name one Sandbox Receipt and its SHA256: an immutable schema2
  artifact identifying the exact selected Draft and its successful timed END. Original Finish also needs its matching
  implementation fingerprint, evaluator and recipe, and produces its own fresh receipt. Runtime receipt references
  avoid a self-hash cycle and never replace original verification; root and output differences are explicit role
  bindings, never arbitrary substitutions.

## 3. From approval to Complete

1. After the exact approval, allocate the unchanged Draft, record Approved with its approval evidence, activate the
   pointer, record In Progress and implement only the scope. The approval evidence binds the exact selected Draft and
   the explicit physical execution root; a record copied to another checkout grants nothing. Frozen sections: DEC-22.
   Only the Runtime Checkpoint, checkbox state and append-only logs change; Complete and Cancelled history is
   immutable. Inspect the actual Git index subject: a passing working file proves nothing about different staged bytes.
2. Profiles: REPOSITORY always applies; CONTROL, COORDINATION and RECOVERY derive from the exact scope and are covered
   by the full suite plus their own new cases; WORKSTATION stays reserved and fail-closed. CI has its own local path
   (lib/README.md section 3), which is neither hosted enforcement nor an exemption from Finish. The check each profile
   adds: WORKSPACE-LAYOUT.md section 14.4. An unsupported profile blocks Approval as well as Finish: its tested
   verifier comes first, through its own approved CONTROL change.
3. Finish (DEC-23, DEC-24): run it through this checkout's absolute `lib/run_timed.ps1` with an explicit
   WorkingDirectory and an external log, watched at the same time by `lib/watch_run.ps1`; its root and PID stamp and
   its runner ancestry must match. A per-root exclusive operation handle refuses an overlapping Finish, admission or
   completion; an abandoned empty handle file is not a running process. One Finish owns the full tests.ps1 schedule,
   and the hook checks only admission and freshness. Finish checks clean committed inputs before and after the tests,
   retires the old working receipt and issues a fresh root-, input-, evaluator- and profile-bound receipt only on
   success; receipts are archived by digest and Review names the selected one. Keep the run logs: neither the archive
   nor a watcher exit replaces native success.
4. Context-bound Finish runs `Events.ps1 -Find` and `Hunt.ps1 -Quick -NoRecord` once before the heavy suite and keeps
   their exits; Quick GAP text is not zero findings, and quick mode is not the full mutant and lint audit. The per-root
   lease and one shared heavy lease refuse overlapping closures. The declared headroom is observed once before launch;
   unreadable or short evidence blocks without killing other work. tests.ps1 refuses a raw full-suite start without its
   own Finish parent and recipe. Accepted open risks: DEC-05.
5. Review is a live observation: check every actual criterion, the timed runner's and watcher's final exits and the
   fresh receipt, record Confirmed Complete and DONE/None, then run the read-only Review check. Complete verifies those
   facts again and prepares only its own status and pointer edits. Stage exact paths, commit normally and judge the
   whole carrying range before declaring local completion. Publication and promotion: DEC-25.

## 4. Native product stage transport

- An explicitly selected transport config names the exact Root, baseline, native SPEC and slug, selected Draft, raw
  SHA256, filtered allocation blob and configured Git user. Every post-allocation stage matches that blob to its single
  actual Git allocation before invoking a native child or writing. Never infer a target from an old folder or another
  SPEC with the same number.
- Read the native Boot ACTION, WRITE and START_CONTEXT, or its refusal, as the adapter preserves them. Creation uses the
  literal applier's whole Plan; absent HEAD content is not a creation failure.
- Never rerun approve after a diagnostic failure without inspecting the actual commits and status: a native transition
  may already have succeeded. Native applicability is PASS or NOT APPLICABLE, and the adapter grants no exemption.
  Explicit retirement stays scoped, and no invented model or coauthor enters a commit.
- After the implementation commit and DONE, invoke the selected repository's own timed and watched Finish exactly once
  (DEC-23); the stage adapter schedules none of its child tests. Inspect the actual criteria and the fresh receipt,
  supply the real review entry, Complete, then native bind. Failed or unknown diagnostics stay visible; an unsupported
  check needs its owning native evidence, never a fabricated approval or a copied criterion engine.
- Entry appends name their legal section, whatever the section order. Reuse the lifecycle, process and owned-fixture
  cleanup helpers. `test-native-stage.ps1` owns the stub-boundary positives, refusals and mutants; its fixtures never
  replace a real native lifecycle or an original receipt.

## 5. Codex test environment

Run focused test files in the owning Finish environment: WORKBENCH_TEMP_ROOT and WORKBENCH_TEST_ROOT under the
selected temporary root; TEMP and TMP set to `<temporary root>\tmp`; WORKBENCH_ACTIONLINT set to
`<temporary sibling>\tools\actionlint.exe`; ORVION_DATA_ROOT a new empty folder under that temp. Remove only owned
scratch. The owning native Finish alone schedules tests.ps1, so a delegate never starts a duplicate full suite
(DEC-23).

## 6. Session error acknowledgement

Hunt reports every nonempty `<data>\work\sync-errors.log` as a BUG. Review those failures and their disposition,
then hash the reviewed file with `Get-FileHash -LiteralPath '<data>\work\sync-errors.log' -Algorithm SHA256`.
Then run:

~~~text
pwsh -NoProfile -File lib\Sync-Sessions.ps1 -Root '<data>' -AcknowledgeErrors -ExpectedSHA256 '<hash>' -Reason '<review and disposition>'
~~~

An explicit root, the exact current hash and a nonempty reason are required; an acknowledgement cannot accompany
`-Follow`.

A short per-log mutex shared with the error writer protects the reviewed bytes. The command creates a new read-only
`<data>\work\sync-errors-ack-<SHA256>-<id>.log`, verifies its bytes, appends and verifies a unique event containing its
digest, reason and archive path, then retires the matching active log; the follower's lifetime mutex is independent.
Success returns 0. A stale hash or any archive, event or retirement failure returns 3 and leaves the active log
blocking. Keep the acknowledgement archives and the journal for recovery. New failures create a new active log and
block Hunt again: an acknowledgement records the disposition of the reviewed errors, it does not prove a healthy sync.

## 7. PowerShell traps

Each trap has cost a run here or in CRM (its CODING_STANDARDS.md section 12); a lesson that recurs is promoted to this
list. `lib/Test-ScriptHazards.ps1` flags some of them: run it on every new `.ps1`.

- Pass an absolute `-File`: `pwsh -WorkingDirectory X -File scripts/y.ps1` runs the caller's script, and a Review
  measurement was taken on the wrong repository (event pwsh-file-relative-path).
- .NET file APIs ignore the PowerShell location: give them absolute paths. Expand TEMP with `[IO.Path]::GetFullPath`
  before a provider cmdlet: under the 8.3 form `C:\Users\MYLAB~1`, `Remove-Item -LiteralPath` refused a file that
  `[IO.File]::Delete` removed (event relative-path-wrong-location, three times).
- Automatic variables (`$Pid`, `$Host`, `$Input`, `$Matches`, `$event`) are not free names: a `$Pid` parameter
  silently broke Watch-Host (event ps-reserved-name). Short helper names collide with aliases: a function named R ran
  Invoke-History, and CRM's `Rd` deleted AGENTS.md. Name helpers Verb-Noun.
- Variable names are case-insensitive: in CRM's SPEC-238 script `$r` overwrote `$R`, the repository root.
- A one-element pipeline result is a scalar: wrap lists in `@()`. The comma binds tighter than `+`: `'a','b'+'c'` is
  three elements, not `'a','bc'`; parenthesize a computed element.
- Assigning a value outside a `[ValidateSet]` parameter's set inside its function throws ValidationMetadataException:
  copy the parameter to a local variable before changing it.
- `-Attributes !ReparsePoint` also skips OneDrive cloud-only files: the vault looked like 390 MB in 34 files instead of
  1,098 MB in 1,165, and a 110 MB evidence folder was planned for deletion as empty (event
  onedrive-placeholder-undercount). Skip only LinkType SymbolicLink or Junction.
- Windows keeps paths under 260 characters: the limits of the test root and TEMP are in WORKSPACE-LAYOUT.md section 9.
- A failed native read is not empty success: `git grep` exits 1 for an unreadable blob exactly as for no match. Check
  every exit, and copy `$LASTEXITCODE` into a local at once (assigning it inside a function shadows it).
- `-match` ignores case and rebinds `$Matches`: use `-cmatch` where case matters and `[regex]::Match` for a value
  that must survive another match; compare exact text with ordinal comparers (CRM SPEC-255).
- In double-quoted text a backtick escapes: `` `r `` and `` `t `` become control bytes and other backticks vanish, and
  the Gate refuses U+000D (`PROHIBITED_CHARACTER`). Write Markdown code there as ` ``x`` `, build literal text with
  single quotes, and write repository text with LF.
- `Start-Process -ArgumentList` splits a path with a space (`My Lab`): pass one argument string with each path in
  double quotes.
- Worktree git config may edit the shared local configuration.
- Literal Draft steps must survive the applier's preflight and blob comparison: substring matching, deletions with
  context and a final newline (`apply-draft-steps.ps1`; `test-draft-steps.ps1` covers it).
- In a product repository, never write an unallocated SPEC id in a tracked file (it reserves the number), and never
  commit a blocked checkpoint. Read old code's top level before running a causal negative: it may install real tools.
  A host-killed heavy run restarts only as DEC-23 allows.

## 8. Before saying nothing is running

List the top memory consumers and the orphaned processes (parent gone), and after a timed-out shell call confirm that
its child exited: on 2026-10-27 an orphaned grep held 10.6 GB (DEC-24).

## 9. Asking the owner

Ask only what cannot be derived (DEC-02, DEC-29, DEC-31), in this form:

1. The question, and why it cannot be derived from the code, the records or a sensible default.
2. The evidence already exhausted: the files read, the checks run, the sources consulted.
3. Two to four options, each with its consequence.
4. The recommendation and its reason.
5. Reversibility: what undoing each option would cost.

## 10. Workstream end

1. The retro of DEC-12: Claude main and Codex each name what does not satisfy them, every item with a remedy and a
   check.
2. For every tool, rule and folder the workstream touched, ask once: does it still earn its place (DEC-03)? Merge or
   delete what does not.
3. Each defect class the workstream fixed names the guard that now keeps it closed, or why there is none (DEC-28).
4. The summary, the cited files and the cleanup: WORKSPACE-LAYOUT.md section 12.

## 11. Saving

One call saves every operation (DEC-26).

~~~powershell
pwsh -NoProfile -File lib/Save-State.ps1 -Operation '<operation>' -Done '<what finished>' -Evidence '<path>','<path>' `
    -Next '<exact next step>' -RunBy '<who: model, effort>' [-Blocker '<text>'] [-Question '<question>','<question>'] `
    [-Running '<process or operation.json>'] [-Pointer '<path>'] [-Now '<one line>'] [-Workstream WS-0NN] [-Plan '<path>']
~~~

- The first save names the workstream; later saves take it from the NOW.md title. Its folder `sb/W<NN>/` in
  temporary must exist, made when the workstream starts (refused: `SAVE_WORKSTREAM_FOLDER_MISSING`).
- Every evidence path exists, absolute or relative to the checkout (refused: `SAVE_EVIDENCE_MISSING`).
- Owner questions and pointers carry over from the previous NOW.md unless given, and `-Question @()` clears them.
  Running is stated at every save (None when omitted). Now defaults to the workstream and operation with "done";
  `-Blocker` adds "BLOCKED: <text>".
- Pending decisions are the `## ` headings of `decisions-inbox.md` in the data root (absent until the first owner decision is captured): one heading per owner decision not yet
  folded into DECISIONS.md (DEC-01), and the contract that folds it removes the item.
- Nothing is written until three checks pass. The Markdown guard's `Test-NowMarkdown` checks the text: the budget and
  line length of WORKSPACE-LAYOUT.md section 19, the sections of section 14.2, the pointers and the citations. The vault
  exists (refused: `SAVE_VAULT_MISSING`). The status page renders from the plan file, `sb/W<NN>/PLAN.md` unless `-Plan`
  names another (refused: `SAVE_PLAN_MISSING`, or the `SAVE_PLAN_*` rule the plan breaks: an unbalanced code span, a
  table it cannot read or of uneven rows, a missing title, Status line or section 3, 6 or 7, a step table not headed
  Step, a step ID used twice, section 6 without its one Rank and Step table or naming no open step, section 7 without
  its one table of batches, a batch naming no open step, an open step in no batch, a batch's step without a Do, Run by
  or Time column, a control character). A refused save writes nothing and prints the rule it broke.
- It overwrites `data/work/NOW.md`, appends one line to `sb/W<NN>/LOG.md` and writes `sb/W<NN>/status.html`. Then it
  builds the vault's continuity copy (WORKSPACE-LAYOUT.md section 3.3) in `continuity.new` and swaps it in only when
  every file's SHA256 matches its source; on a mismatch (refused: `SAVE_CONTINUITY_MISMATCH`, a file written to during
  the copy) NOW.md, LOG.md and the page are saved, the previous copy stays whole, and the save is run again.
- It prints the four lines of WORKSPACE-LAYOUT.md section 14.2: the agent publishes the page the first names (DEC-29),
  and the other three go to the owner unchanged, carrying the first sentence of Next. The data root is `ORVION_DATA_ROOT`, else the checkout's `data/`;
  temporary is the checkout's sibling `ORVION-Workbench-temporary`; the vault is `ORVION-Recovery` in OneDrive; tests
  pass `-Checkout`, `-DataRoot`, `-Temporary` and `-Vault`.

## 12. Codex brief

Every brief to Codex is at most 8 KB and holds these sections, each once, none empty (DEC-21; the fields: WORKSPACE-LAYOUT.md
section 15). `Delegate.ps1` refuses any other before a CLI call (`CODEX_BRIEF_REFUSED`) and records the size and the
evidence lines in `launcher.json`.

~~~markdown
## Objective
## Why delegated
The distinct view or parallel work this buys, and why Claude main does not do it alone.
## Scope
In and out.
## Authority
The DEC-NN IDs that govern the work.
## Embedded evidence
At most 60 lines, so Codex re-reads nothing it was given.
## Read only if needed
Path and why. AGENTS.md and the global ~/.codex/AGENTS.md: do not read them.
## Write boundary
The clone and the run folder only (DEC-20); deliverables there, which Claude main moves.
## Deliverables
Include your proposals and concerns; Claude main answers them in a disposition table.
## Acceptance
## Stop conditions
## Return format
At most 40 lines in the seven fields: INHERITED, PROVEN, UNPROVEN, CHANGED, REMAINING, DO NOT TOUCH, NEXT.
~~~

A return outside that format exits 6 (`CODEX_RETURN_FORMAT`); its session stays recorded, so a resume can correct it.
The launcher writes the session ID, model and effort (DEC-18) to `sb/W<NN>/codex/session.json`; `Delegate.ps1
-Workstream W<NN> -ResumeSession <session ID>` continues it, and a second fresh session there is refused (DEC-21).

Fixed adversarial checklist of a same-session V2, in V1's session and labelled so:

1. Assume V1 is wrong: name what would disprove each claim, then try it.
2. Hostile input: empty, huge, spaces, Unicode, quotes, a path that traverses or is a link.
3. Failure paths: a dependency down, a partial write, a timeout, a second run over the first.
4. Checks: a test or mutant that cannot fail, a check weakened or skipped to pass.
5. Security boundaries: secrets, privileges, confinement, what a refusal leaves behind.
6. Authority: each change against its DEC-NN and the brief's scope.
7. Concurrency and load: what side by side runs share.
8. What V1 did not prove: list it under UNPROVEN, never as passed.
