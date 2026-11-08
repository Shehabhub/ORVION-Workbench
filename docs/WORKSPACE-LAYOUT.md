# ORVION workspace architecture (mandatory reference)

Status: APPROVED TARGET (DEC-06, 2026-10-31): every agent follows it. It wins over an older document; a native check
wins over it, and the agent records the conflict (section 22). Slice S1 of WS-033 lands it as `docs/WORKSPACE-LAYOUT.md`
(the name the Markdown guard reads); PLAN.md orders the steps that build it, and this document says the result.

## 0. How to use this document

1. Read section 14 (the method) before any work; read the section for the thing you are about to touch.
2. Nothing here is optional. If a case is not covered, follow section 22; never invent a private convention.
3. Words in section 23 have exactly that meaning.

## 1. The four tests (owner principles, DEC-03)

Every file, folder and section passes all four, or it is merged or deleted.

| Test | Question | It fails when |
| --- | --- | --- |
| Learn first | Did we look before adding? Is there already a home? Does it rest on evidence? | a second home for the same thing; content with no source; a measurement repeated without need |
| Learn before making assumptions | Is every fact this step depends on verified now: the file read, the check run, the current official source read? | a guess acted on; a remembered value used without reading its source; an agent deciding what only the owner knows |
| Earn it and worth it | What actively reads it, and is it worth its size? | no active reader (no tool, gate, decision, agent step or owner need); kept only as history; cost bigger than use |
| Simplify without weakness | Is this the shortest form that keeps every gate, test, rule, needed piece of evidence and security boundary? | duplication; small, closely related files kept apart; history in an active file; a weakened gate, test or security boundary; a rule dropped to meet a size budget |

Enforced by: `Organize -New` (needs purpose and reader; refuses a second home), `Organize -Check` (reports UNEARNED
items and broken references), `Organize -Clean` (removes disposable, duplicate and expired items), the Markdown guard
(size, IDs, links), the guards of DEC-28, and the review. Simplifying never removes a native gate, a test assertion,
cited evidence or a security boundary.

## 2. The places

| Place | Holds | GitHub | Lifetime |
| --- | --- | --- | --- |
| `ORVION-Workbench` | every essential file: tools, router, rules, decisions and their archive, the owner's words, recovery inputs, contracts, one short summary per workstream; in git-ignored `data/`: live state, the event journal, the session index, the raw transcripts of the last 60 days, Claude memory and the evidence records (section 3.1) | PUBLIC (DEC-09), pushed once per workstream (DEC-25); as compact as possible, well under GitHub's free 1 GB (DEC-08) | permanent |
| `ORVION-Workbench-temporary` | only transient files: the active workstream folder, clones, sandboxes, scratch, run logs, re-creatable pinned tools; rebuilt by `Restore-Workspace -Temporary` | no | deleted by hand or by `Organize -Clean` |
| `OneDrive\ORVION-Recovery` (the vault, the one backup copy) | only the last 7 daily packages with their sidecars, the restore launchers and Save-State's small continuity copy (section 3.3) | no; inside the free 5 GB plan (DEC-08) | packages: the last 7, plus any an active file names (DEC-27); continuity: overwritten |

Losing either cloud copy loses nothing essential: GitHub is restored from the local checkout and `data/` from the newest
package (DEC-08). No other cloud service holds ORVION files.

Not ours and never changed by this architecture: CRM and ORVION repositories, `ORVION-Workbench-trusted-main`, the
'ORVION Repository Map' task, `.omc/` plugin state, client settings except the reversible fixes K01-K03 in the
migration map. The legacy folders ORVION-Sandbox and ORVION-Owner-Tools under Documents,
`ORVION-Owner-Review`, `ORVION-drafts-backup` and `ORVION-Owner-Recovery` are handled by the Owner Lift, not here.
`ORVION-Owner-Tools` exists only until WS-033 step P7.2b folds it in; it is deleted at step P8.3b, after the checks
and the next 02:00 backup.

## 3. Full layout

Anything not shown here is a violation that `Organize -Check` reports.

### 3.1 ORVION-Workbench (tracked in Git unless marked IGNORED)

```text
ORVION-Workbench/
├── README.md               THE router for humans and agents (<= 8 KB): what this is, the places, where each kind of
│                           information lives, the work loop, save and compact, a read-on-need table
├── AGENTS.md               auto-loaded stub (<= 1.5 KB): "start at README.md", the non-negotiables, "NOW.md is injected"
├── RESUME.md               native contract pointer; written only by the native lifecycle
├── WORKFLOW.md             only the parts the trusted checker and the Markdown guard read
├── HANDOFF.md              Lift record and programme closure criteria only
├── tests.ps1               test entry point
├── .gitignore              ignores data/, ai-map.*, certification files, .omc/
├── changes/                README.md + contracts WS-0NN-<slug>.md (each = the chosen Draft of that workstream)
├── config/                 README.md + tool configuration
├── docs/
│   ├── README.md           organizer
│   ├── DECISIONS.md        every decision and rule in force, once: one entry per subject (DEC-NN), rewritten in place
│   ├── RUNBOOK.md          the standard workstream steps, the brief template, Codex and save procedures
│   ├── WORKSPACE-LAYOUT.md this architecture
│   ├── RECOVERY.md         recovery reference (trimmed only where contradicted)
│   ├── owner/              README.md + the owner's words verbatim, one folder each: yyyymmdd-<slug>/
│   │   └── recovery-inputs/  recovery-inputs.json + the backup inputs that live nowhere else
│   └── history/            README.md (index), LOG.tsv, DECISIONS-ARCHIVE.md, the byte-exact old decision log and its
│                           D-number map; nothing else: replaced text is deleted, Git history keeps it (DEC-10)
├── lib/                    flat tools: <Tool>.ps1 + test-<tool>.ps1; README.md is the tool index (section 13)
├── records/                README.md + one summary per finished workstream: WS-0NN/README.md (DEC-11, section 12)
├── .githooks/, .github/, .gitattributes  native, unchanged
├── data/                   IGNORED, carried by every daily package; this is ORVION_DATA_ROOT; it also holds a
│   │                       secret-scan hit that an active reader needs (DEC-09)
│   ├── README.md           organizer (local only)
│   ├── work/               NOW.md (live state, overwritten by Save-State only, <= 6 KB); hunt-last.txt (written by
│   │                       Hunt.ps1:306, read by Pulse.ps1:98); delegations/ (Delegate briefs and reports,
│   │                       Delegate.ps1 -List); the failure logs Hunt reports (sync-errors*.log, hook-errors.log); the
│   │                       run folders current events cite by relative path (MIGRATION-MAP.tsv O11)
│   ├── events/events.jsonl event journal (Events.ps1 and the tools that log)
│   ├── sessions/           INDEX.md + index.jsonl (generated by Sync-Sessions); raw/<client>/ the raw transcripts of
│   │                       the last 60 days (written by Sync-Sessions, searched by Spider, never in Git)
│   ├── records/            evidence without a tracked home, each file at its old path relative to Owner-Tools\records
│   │                       (Owner-Tools root files under owner-tools-root/), with MANIFEST.tsv, whose 566 rows resolve here
│   │                       unchanged; after the Lift's C1 pass only cited files stay (section 23, DEC-10, DEC-11)
│   ├── decisions-inbox.md  the owner's words verbatim, until the next contract folds them into DECISIONS.md
│   └── claude-memory/      Claude memory files (junction target of ~/.claude/projects/<project>/memory)
├── ai-map.html, ai-map.json  IGNORED, generated by Map-Repos (repository map)
├── workstation/            local, empty, untracked: reserved by config/README.md; the evaluator refuses any file there
└── .workbench-local-certification.json, .workbench-certifications/  IGNORED, native
```

### 3.2 ORVION-Workbench-temporary

```text
ORVION-Workbench-temporary/
├── README.md               organizer: which workstream is active, what has expired
├── tools/                  pinned pwsh-portable-7.6.8 and actionlint; Restore-Workspace -Temporary re-creates only
│                           actionlint (no tool re-creates pwsh-portable)
├── sb/W<NN>/               THE ACTIVE WORKSTREAM FOLDER (section 12): drafts, reviews, gate, runtime, sandbox
├── cx/W<NN>-<role>/        disposable clones (prototype, Codex clone, mutants, replay)
├── scratch/W<NN>-<yyyymmddThhmmssZ>-<role>/   per-run scratch
├── codex-relay-logs/W<NN>-<yyyymmddThhmmssZ>-<role>/   Codex relay logs
├── tmp/                    process TEMP for tests and Finish (emptied after each workstream)
├── map/                    ai-map.html + ai-map.json of temporary and data/ (the second map, DEC-06)
├── restore-staging/        Restore-ORVION staging; kept and reported, never deleted automatically (DEC-10)
└── judges/, retired/       kept empty: judges/ holds the accepted judge copy only while Workbench.ps1 runs (lines
                            35-41, 293); retired/ and restore-staging/ are made by lib/workspace-layout.ps1
```

Area names come from `lib/workspace-layout.ps1`; a new area needs that file and this document changed together. Tool
run files have no area here: hunt-last.txt, the failure logs and the delegation reports stay in `data/work/`, where the
tools write and read them (Hunt.ps1:306, Pulse.ps1:98).

### 3.3 The vault, OneDrive\ORVION-Recovery

```text
OneDrive\ORVION-Recovery\
├── orvion-backup-*.7z      the last 7 daily packages, each with its .sha256 and .secret-scan.txt sidecars; written by
│                           Backup-Workspace, which after each verified package runs Organize -Clean's retention tier:
│                           older packages that no active file names are deleted with their sidecars (slice S7, DEC-27)
├── Restore-ORVION.cmd/.ps1 restore launchers, copied by every Backup-Workspace package run
└── continuity/             Save-State's small copy of the latest progress: data/work/NOW.md, decisions-inbox.md when present,
                            data/events/ and the active workstream folder without its checkouts and temp (s/, t/, tmp/)
OneDrive\ORVION-Recovery.status\   the packages' status sidecar (latest.json, operation.lock, under 1 KB), written by
                                   Backup-Workspace at this pinned path (unchanged)
```

Nothing else is stored there (DEC-08): no organizer, evidence archive or transcript. Agents never work inside the vault
and read it only to restore; its writers are Backup-Workspace and Save-State.

## 4. Where does it go? (no other place is allowed)

| You have | It goes to | Written by | When |
| --- | --- | --- | --- |
| a new owner instruction or decision | `decisions-inbox.md` in the data root (the owner's words verbatim, appended; absent until the first one) and a line in NOW.md | Claude main | the same turn |
| the change that decision makes | its entry in `docs/DECISIONS.md`, rewritten as one updated decision (a new subject gets a new entry) | the next workstream contract | at that contract |
| the replaced wording and the owner's words | `docs/history/DECISIONS-ARCHIVE.md`, appended, each item naming the entry it now lives in | the same contract | in the same contract |
| replaced text from any active document | nowhere: it is deleted, and Git history keeps the earlier version (DEC-10) | the change that replaces it | in that change |
| live state | `data/work/NOW.md` | Save-State | every operation |
| a workstream's drafts, briefs, reviews, gate records, runtime, prototype, measurements, one-off scripts | `sb/W<NN>/` in temporary (section 12) | the step that makes it | during the workstream |
| a workstream's summary: result, receipt, one line per failure, its cited files | `records/WS-<NN>/README.md` (tracked) | the Complete step | at the end |
| the files of a workstream that are cited (section 23) | `data/records/WS-<NN>/`; every other file of `sb/W<NN>/` is deleted by `-Clean` (DEC-11) | the close step | after its push |
| evidence from Owner-Tools without a tracked home | `data/records/`, at its old relative path (rows O02-O06, O12) | `Organize -Map` | WS-033 step P7.2b |
| a new tool | `lib/<Tool>.ps1` + `lib/test-<tool>.ps1` + a row in `lib/README.md` | a contract | in that contract |
| a tool's own run files | `data/work/` when another tool reads them (hunt-last.txt), else `temporary/scratch/` | the tool | while it runs |
| a lesson, failure or discovery worth keeping | the event journal: `lib/Events.ps1 -Add` | any agent | when found |
| an owner preference about how agents work | its entry in `docs/DECISIONS.md`; Claude memory holds only a pointer to the entry ID | Claude main | when given |
| backups | the vault: the last 7 packages (DEC-27) | Backup-Workspace only | daily 02:00 Cairo |
| session transcripts | `data/sessions/raw/<client>/`, the last 60 days (DEC-08) | Sync-Sessions only | automatically |
| a file that fails the secret scan and that an active reader needs | `data/` (DEC-09) | the step that found it | at once |
| anything not in this table | STOP: section 22 | — | — |

## 5. The organizer: README.md in every managed folder

Managed folders: the two working folders, every folder drawn in sections 3.1 and 3.2, each `sb/W<NN>/` and
`records/WS-<NN>/`. The vault is not managed: only Backup-Workspace (with the retention tier it runs) and Save-State
change it, and DEC-08 allows no organizer there.
Drawn but without generated tables: `lib/` and `config/` keep their own README (the tool index; the reserved scaffold).
Drawn but unmanaged: the native `.githooks/` and `.github/`, `workstation/` (reserved), `judges/` and `retired/` (kept
empty), and `data/claude-memory/`, whose reader is the client.
Deeper folders are sealed content (the old folders under `data/records/` too): one row in their managed parent's table;
nothing inside them is indexed.

```markdown
# <folder name>

Purpose: <one line>. Kind: <kind>. Lifetime: <permanent | until WS-0NN is complete | until the Lift's C1 pass>.
Reader: <the tool, step or person that reads this folder>.
Rules: <what may be added, the name pattern, who writes>.

<!-- organize:contents (generated by lib/Organize.ps1 -Refresh; do not edit) -->
| Name | Kind | Purpose | Reader | Updated |
<!-- /organize:contents -->

<!-- organize:changes (last 10 rows of docs/history/LOG.tsv for this folder; generated) -->
<!-- /organize:changes -->
```

- The header is written once, through `Organize -New`; it changes only through a contract or section 22.
- The tables are generated from the children's own headers, so each fact has one home.
- The changes table shows only the last 10 rows; the full record is `docs/history/LOG.tsv`.
- Kinds: router, stub, native, tool, contracts, config, reference, rules, decisions, owner-texts, archive, records,
  live-data, generated, organizer, active-workstream, clones, scratch, logs, pinned-tools, evidence.

## 6. Names

- Folders: lowercase-kebab-case, except the fixed forms `WS-0NN-<slug>` (contracts, records), `W<NN>`
  (temporary items), `DEC-NN` (entries of docs/DECISIONS.md; the old D-numbers stay as archive IDs) and dates `yyyymmdd` or
  `yyyymmddThhmmssZ` (UTC in names; Cairo time in messages to the owner).
- No spaces. Never the names new, old, copy, backup, misc, temp, final, v2 or similar: versions live in Git or the
  archive.
- One purpose per folder; at most 4 managed levels below a place.
- Paths stay under 240 characters (OneDrive refused paths over 400; event onedrive-path-too-long-fixture-residue).
- Draft versions are `V1`, `V2`, `V3` and correctives `V4`, `V5` and on; the evaluator's third slot holds the selected
  version under its honest ID.

## 7. Folder operations: only through Organize

| Action | Command | Guarantees |
| --- | --- | --- |
| create | `lib/Organize.ps1 -New <path> -Kind <kind> -Purpose '<text>' -Reader '<text>'` | standard name, README from section 5, parent refreshed, LOG row |
| move | `-Move <from> -To <to>` | refuses pinned paths (section 9); hashes verified; every reference in an active file updated in the same operation (DEC-10); LOG row with old and new path |
| delete | `-Clean -DryRun`, then `-Apply`; `-ListUncited` gives the list the owner confirms once, `-Confirmed <tsv>` adds it | only what section 8 marks deletable, through lib/remove-owned.ps1; refused while an active file names it, so no reference breaks, and a second check reports any that did; LOG row, or for the retention tier a row in `data/work/retention-log.tsv` |
| apply a map | `-Map <tsv> -DryRun`, then `-Apply` | executes migration rows; BLOCKED rows skipped and reported |
| refresh, check | `-Refresh`, `-Check` | regenerates organizer tables; reports every violation |

`LOG.tsv` columns: utc, action, place, from, to, workstream, reason, sha256. `data/work/retention-log.tsv`, which the daily retention tier writes so that the tracked checkout
stays clean for the next package, has the same columns. Both are appended, never edited. A hand-made
folder or move is caught by `-Check` (missing README, unknown name, missing from its parent, no LOG row).

## 8. Lifetimes and orphans

An orphan is anything that fails "Earn it": no active reader, kept only as history, or past its lifetime.

| Item | Lifetime | At the end |
| --- | --- | --- |
| `sb/W<NN>/`, `cx/W<NN>-*`, `scratch/W<NN>-*`, `codex-relay-logs/W<NN>-*` | until workstream `NN` is Complete and pushed and its cited files are hash-verified in `data/records/WS-<NN>/` or their content is in pushed Git history | deleted by `-Clean` |
| `temporary/tmp/` | until the workstream's Finish runs are done | emptied by `-Clean` |
| 0-byte logs | none | deleted by `-Clean` |
| an exact duplicate (same SHA256) of a checkout file, in `data/work/` | none | the copy is deleted by `-Clean`; a duplicate in `data/records/` is evidence and waits for the owner-confirmed list |
| replaced active text | until replaced | deleted; Git history keeps it |
| the owner's words, decision text and its archive, the event journal, the session index, workstream summaries, cited files (section 23) | permanent | never deleted |
| raw transcripts in `data/sessions/raw/` | 60 days | deleted by `-Clean`'s retention tier (slice S7) |
| backup packages and their sidecars | the last 7, plus any package an active file names (HANDOFF.md and DEC-05 name orvion-backup-20261026T201821Z.7z) | deleted by `-Clean`'s retention tier, which Backup-Workspace runs after each verified package (slice S7, DEC-27); a package carrying the OneDrive pin attribute is kept and reported |
| files in `data/records/` that are not cited | until the Lift's C1 pass | deleted by `-Clean` from the list the owner confirms once (DEC-10; PLAN P9.3) |
| `restore-staging/` | until the owner decides | kept and reported, never deleted automatically (DEC-10) |

`-Clean` refuses anything named by an active file: README, DECISIONS, NOW, the scheduled task actions, the client hook
settings. Tools that write run files put `W<NN>` in the name so `-Clean` knows when they end. A move or deletion
updates every reference in an active file in the same operation (DEC-10); a reference inside a frozen text (section 23)
is never edited and resolves through LOG.tsv.

## 9. Pinned paths and native constraints

| Rule | Why |
| --- | --- |
| `lib/Test-WorkbenchChange.ps1` (the accepted evaluator) is never changed, except once by WS-034 through the full method (DEC-07) | it is the trusted judge, pinned by hash; the WS-034 release sets the new pin |
| RESUME.md, WORKFLOW.md, HANDOFF.md, AGENTS.md, docs/RECOVERY.md, docs/WORKSPACE-LAYOUT.md keep their names | the evaluator, the Markdown guard and Restore-ORVION read them; Map-Repos treats them as entry documents (records/WS-033/MIGRATION-MAP.tsv W02-W04, W06, W07, W12) |
| `lib/` stays flat and keeps every tool name | the evaluator's profiles, the Finish schedule, scheduled tasks and client hooks call them by path |
| every commit to the Workbench goes through a contract and the staged gate | the native lifecycle checks every commit; that is why `data/` is git-ignored |
| `lib/Map-Repos.ps1`, `lib/Backup-Workspace.ps1`, `lib/hooks/Watch-Reminder.ps1` keep their paths | scheduled tasks and client hooks run them |
| the backup inputs move only together with an exact re-install of the backup task and one triggered run | the 02:00 backup reads them by path and hash |
| `data/claude-memory/` moves only with its three junctions (the CRM, ORVION and Workbench projects) re-pointed and every memory file hash-verified | Claude memory depends on it |
| a Finish that has operation.json is never rerun | one Finish per stage |
| a Tests Root of at most 101 characters and a TEMP of at most 97 | the evaluator refuses a longer Tests Root (line 53) but never checks TEMP; the deepest fixtures need 158 characters under the Tests Root and 162 under TEMP to stay inside Windows' 260 (P1.1a) |

Fallback (no judgment needed): if the trusted checker refuses a path under `ORVION-Workbench-temporary` for a Runtime
Root or an assurance artifact, use `ORVION-Workbench/data/ws/W<NN>/` with exactly the structure of section 12, and
record the refusal in LOG.tsv and NOW.md.

## 10. One home for each kind of information

| Information | Home | Written by | Read when |
| --- | --- | --- | --- |
| live state | `data/work/NOW.md` | Save-State, overwritten | injected at session start and after compact |
| decisions and rules in force | `docs/DECISIONS.md`: one entry per subject (DEC-NN), rewritten in place | the contract after an owner decision | by entry ID |
| owner decisions not yet in DECISIONS.md | `decisions-inbox.md` in the data root, when present, and the "Pending decisions" list in NOW.md | Claude main | injected with NOW.md |
| replaced wording and the owner's verbatim words | `docs/history/DECISIONS-ARCHIVE.md`, append-only, each item naming its DEC-NN | the contract that rewrites the entry | when tracing why |
| workstream work in progress | `sb/W<NN>/` | the workstream's steps | during it |
| workstream summary (result, receipt, failures, cited files) | `records/WS-<NN>/README.md` | the Complete step | audits |
| cited files of a finished workstream, and Owner-Tools evidence | `data/records/` | the close step; for Owner-Tools, P7.2b | audits; the Lift's C1 check |
| raw session transcripts (the last 60 days) | `data/sessions/raw/` | Sync-Sessions | Spider searches |
| the active workstream's plan | its plan file, in priority order; the status page is generated from it after each save (DEC-29) | Claude main; the page by its generator | each step; the owner on the page |
| every create, move, delete | `docs/history/LOG.tsv` | Organize only | resolving an old path, including one inside a frozen text |
| every deletion by the retention tier | `data/work/retention-log.tsv` | Organize only | resolving a package or transcript that has gone |
| owner preferences (how agents work) | their entries in `docs/DECISIONS.md`; Claude memory holds pointers only | the contract after the owner gives one | the memory index is auto-loaded |
| tool usage | `lib/README.md` | the tool's contract | when needed |
| lessons and discoveries | the event journal | Events.ps1 | `Events.ps1 -Find` |

One fact, one place (DEC-01): a rule or fact in force is written only in its home in this table; every other file cites
its ID and never restates it. A value that code must carry sits next to its DEC-NN, and the owning test compares it
with DECISIONS.md. A value that was copied and drifted before gets a watch pattern in its entry; the Markdown guard
flags an active line that matches it without the ID.

Writing rules: NOW.md is overwritten, never appended. LOG files and the archive are appended, never edited. A new
decision rewrites its entry in DECISIONS.md into one updated decision, consolidated and rephrased, never layered on
top of the old wording; the replaced wording goes to the archive in the same contract. Active files hold no history:
no amendment notes, no back-pointers, no change logs. A derived file (an organizer, an index, a map, the status page)
is generated from its one source and never kept by hand; a check regenerates it and fails when the stored copy is
stale (DEC-28). Long output goes to a file; the agent prints one line.

## 11. Decisions

- `docs/DECISIONS.md` is the single source of truth for every decision and rule in force. One entry per subject:
  `## DEC-NN <subject>`, then the decision in plain words (at most 12 lines), its scope, why (one line),
  `Changed: yyyy-mm-dd`, `History:` its archive IDs and, for a value that was copied and drifted before, `Watch:` a
  pattern. An entry stands alone: it never sends the reader to another entry to combine with it.
- A new owner decision rewrites each entry it changes into one updated decision, or adds an entry for a new subject.
  The replaced wording and the owner's words verbatim are appended to `docs/history/DECISIONS-ARCHIVE.md`, each item
  with its date, its archive ID and `Now in: DEC-NN`.
- The old log D1-D122 is kept byte-exact as `docs/history/DECISIONS-LOG.md`; `docs/history/DECISIONS-MAP.tsv` gives every D-number its DEC-NN,
  Expired or History, so an old reference resolves in one step.
- Hunt C2 checks that every archive item and every mapped D-number names an entry that exists; the Markdown guard
  checks DEC-ID uniqueness, the watch patterns and the size budget of DECISIONS.md (48 KB; each entry's decision at
  most 12 lines).

## 12. Workstream lifecycle and where the drafts live

During workstream `NN`, all of its work sits in one folder:

```text
ORVION-Workbench-temporary/sb/W<NN>/
├── README.md        organizer: workstream, current stage, "ACTIVE: do not delete until WS-0NN is complete"
├── LOG.md           one line per save, appended by Save-State only (section 14.1)
├── PLAN.md          the plan file (DEC-29), in priority order; Save-State renders it into status.html at every save
├── status.html      the status page, published as the workstream's private claude.ai page (section 14.1)
├── prototype/       PROTOTYPE.json, source.patch, measurements
├── codex/           session.json (Codex session ID, model ID, effort: DEC-18), briefs, Codex reports verbatim
├── assurance/
│   ├── V1/          DRAFT.md, REPORT.md, FROZEN.json, draft-check.json, evidence/
│   ├── V2/          the same
│   ├── V3/          the same
│   └── V4/ ...      correctives, each under its own name
├── reviews/         REVIEW.json and RESULT.json per review (self-review labelled; Codex review labelled)
├── gate/            QUALIFICATION.json, delegated Gate records
├── runtime/         sandbox/ and original/: Finish logs, receipts, results, refused attempts
├── s/, t/, tmp/     sandbox checkout, tests root, temp root
└── package/         the workstream's copies of the lifecycle controllers (until Invoke-ContractLifecycle.ps1 replaces them)
```

Save-State copies this folder, without `s/`, `t/` and `tmp/`, to `vault continuity/` after every operation (section
3.3), and `-Clean` refuses to touch it while the workstream is not Complete.

When the workstream is finished:

1. The chosen version is the contract: `changes/WS-0NN-<slug>.md`, in Git, pushed with the workstream.
2. `records/WS-<NN>/README.md` is its one summary (DEC-11): the result and the receipt (verbatim, with its SHA256), each
   failed, refused or superseded attempt in one line with its reason, every version (role: design, adversarial,
   evidence refresh, corrective; author; SHA256; review verdict; why chosen or not), and each cited file (section 23)
   with its SHA256 and its path under `data/records/WS-<NN>/`.
3. After the push and release, the cited files of `sb/W<NN>/` are copied to `data/records/WS-<NN>/` and hash-checked
   against the summary; then `-Clean` deletes the temporary items of `W<NN>`.
4. Timing limit: the chosen draft names V1 and V2 by path and hash, so both are cited files. They leave `sb/W<NN>/`
   only after the push and release, and only if P1 has confirmed that no later native check reads them there again.

Existing records (WS-022 to WS-033) follow row O04: their summaries come from WS-033 step P1.3b, and the rest of each
folder goes to `data/records/WS-<NN>/` until the Lift's C1 pass.

## 13. Tools

All tools stay in `ORVION-Workbench/lib/`, flat, each beside its test. `lib/README.md` groups them:

| Group | Tools |
| --- | --- |
| find and know | Spider, Map-Repos, Events, Pulse, Hunt, Coordinator |
| order and checks | Organize (new), Test-MarkdownConsistency, Test-ScriptHazards, remove-owned |
| work method | Workbench, Test-WorkbenchChange (never changed), Invoke-ContractStage, apply-draft-steps, Invoke-DraftSteps, Delegate, Invoke-ContractLifecycle |
| save and recover | Save-State (new), Sync-Sessions, Backup-Workspace, Restore-Workspace, Restore-ORVION |
| watch long runs | run_timed, watch_run, Watch-Host, Watch-Subagents, hooks/Watch-Reminder |
| owner operations | Owner-PublishDual, Owner-PromoteDual, Invoke-OwnerDual, Test-OwnerDualAdmission |

Data paths after WS-033:

| Tool | Reads and writes |
| --- | --- |
| Events, Pulse, Hunt, Coordinator, Sync-Sessions and the other data-root readers (MIGRATION-MAP.tsv O13) | `data/` (`ORVION_DATA_ROOT`), instead of Owner-Tools |
| Sync-Sessions | raw transcripts to `data/sessions/raw/` and the index to `data/sessions/` |
| Map-Repos | `ai-map.*` for the repository (as today) and `temporary/map/` for temporary and `data/` |
| Backup-Workspace | inputs from `docs/owner/recovery-inputs/recovery-inputs.json`; task re-installed once; after each verified package, `Organize -Clean`'s retention tier: packages beyond the last 7 that no active file names, raw transcripts older than 60 days (slice S7) |
| Hunt, Pulse, Delegate | `data/work/`: hunt-last.txt (Hunt.ps1:306 writes, Pulse.ps1:98 reads), Delegate's reports and the failure logs, where they are today |
| Save-State | NOW.md, the workstream LOG line, the vault continuity copy, the regenerated status page (DEC-29) |
| Organize | the two working folders and `data/`; `docs/history/LOG.tsv`; `data/work/retention-log.tsv`; the vault only through the retention tier |

Spider searches: the repository (tracked files), `data/` (with the raw transcripts and `data/records/`) and
`ORVION-Workbench-temporary` (bounded: organizers, names, workstream folders, no sandbox checkouts, no binaries). Every
hit carries its source label (repo, data, temporary); a Markdown hit also carries `path:line section N` (signposting.md
SP06). An unreadable source is reported UNAVAILABLE, never as zero hits. The evidence of a finished workstream is found
through its `records/WS-<NN>/README.md`.

## 14. The method (every agent, every task)

### 14.1 Work loop

1. Start: AGENTS.md is auto-loaded and NOW.md is injected. Do not read anything already in context.
2. Find, then read only the part you need: Spider, the maps, Grep with a line range; DECISIONS.md by entry ID; never read
   an archive or a decision history whole.
3. Before measuring or researching, look for existing data first (the session index, records, the event journal).
4. Do one operation (section 23).
5. Save: `lib/Save-State.ps1 -Operation '<operation>' -Done '<what finished>' -Evidence '<path>' -Next '<exact next step>'
   -RunBy '<who: model, effort>' [-Blocker '<text>']`; every parameter: RUNBOOK.md section 11.
6. Publish the status page file Save-State printed as the update of the workstream's page (DEC-29), then report to the
   owner: what finished (in Cairo time), then the /compact line and the resume message it printed. The owner types
   /compact by hand.

### 14.2 Save-State output (exact form)

```text
STATUS_PAGE <path of sb/W<NN>/status.html> steps=<n> done=<n> now=<step> plan=<first 8 hex of the plan's SHA256>
SAVED <utc> (<hh:mm> Cairo) WS-0NN <operation>  NOW.md <bytes> B  continuity copy verified
/compact Keep: <one line from NOW.md "Now">. Next = <NOW.md "Next">. <open owner question, if any>. Times in Cairo. English only.
Resume. NOW.md is already loaded; do not re-read it. Next: <NOW.md "Next">. Run by: <model, effort>. Save after the step and give the compact line and resume message. Times in Cairo. English only.
```

The first line is for the agent, which publishes that page (section 14.1); the other three go to the owner unchanged.
In them, NOW.md "Next" stands for its first sentence; NOW.md holds the whole step.

NOW.md sections, in this order: Now (one line), Done last (with evidence path), Next (exact command and who runs it,
DEC-18), Owner questions, Pending decisions (owner words not yet folded into DECISIONS.md), Running (processes,
operation.json files), Pointers (at most 8 paths).

### 14.3 Token rules for Claude main

- Never re-read a file after editing it, and never re-read a file already in context.
- Grep before Read; Read large files with offset and limit.
- Print short results: `Select-Object -Last N`, one-line summaries; long output goes to a file in `sb/W<NN>/`.
- Write Markdown tables lint-clean (`| --- |` separators, placeholders in backticks), because the editor injects
  every lint warning of an edited Markdown file into the conversation.
- Edit large Markdown files with a script when the editor's lint output would be large.
- Name helper functions Verb-Noun: short names clash with PowerShell aliases (a function named R ran
  Invoke-History instead).
- Run long jobs in the background with one Monitor; never poll with sleep; report a running Finish only when it ends
  or fails, unless the owner asks for more.
- One operation per turn where possible. Group the open steps into batches by the files they share (the plan's Roadmap
  section), one batch per session, so nothing is read twice.
- Before every slice or step, Claude main stops, names the cheaper of the two below and gives the resume message; the
  owner types it. The parts inside a slice run with no stop.
- End a batch with the cheaper of two. `/clear` costs nothing and keeps only NOW.md. `/compact` costs one read of the
  whole context plus a summary, and adds about 16k tokens to every later request. Compact only when the next batch would
  otherwise read again more than about 25k tokens (about 100 KB) of the same files; otherwise clear. The figure is an
  estimate at prompt-cache price ratios over 30 requests.
- Keep the context under 200k: every request carries all of it, so a turn at 400k costs four times a turn at 100k.
- Change model right after a clear or a compact, when the context to cache again is smallest.
- NOW.md's reading list names the next batch's sections and line ranges only, never history rows.

### 14.4 Sizing the method to the change (in force when slice S1 lands)

The tiers, and the rule that a purpose adds its check: DEC-12. The check that each derived profile adds:

| Profile (paths: Test-WorkbenchChange.ps1 lines 353-358) | Check it adds |
| --- | --- |
| REPOSITORY (always) | scope, hazard and secret scans, the Markdown guard; the full suite locally (from WS-034: the always-on checks plus the tests that own the changed files); the full suite on GitHub before main moves |
| CONTROL (governance, lifecycle, hooks, the evaluator) | every consumer of each changed rule line listed and checked; a mutant that each new guard kills |
| COORDINATION (Delegate, Coordinator, Watch-*) | its owning tests (test-delegate, test-coordinator, test-watch-*) |
| RECOVERY (Backup*, Restore*) | one real backup run and its restore check |
| CI (.github/) | actionlint, then the GitHub run on the exact head |
| WORKSTATION (Doctor, Bootstrap, Prepare) | refused until its verifier exists (unchanged) |
| any new or changed test | the hosted-portability run of section 19 |

## 15. Codex protocol (fewer tokens, smoother hand-offs)

| Rule | Detail |
| --- | --- |
| one session per workstream | V1 Design, then V2 Adversarial, then the review of V3 run in ONE Codex session: the first run through Delegate records the session ID in `sb/W<NN>/codex/session.json`; later steps use `codex exec resume <session ID> <prompt>` (Delegate `-ResumeSession`) |
| freeze between steps | V1 is frozen and hashed before the V2 prompt; V2 before V3 work |
| model and effort | DEC-18; the exact model ID from the run metadata goes into session.json; Delegate's effort value carries DEC-18 (slice S6) |
| brief template (<= 8 KB) | objective; why delegated (the distinct view or parallel work it buys); scope in and out; authority (DEC-NN IDs); embedded evidence (<= 60 lines, so Codex re-reads nothing it was given, DEC-21); read only if needed (path and why); write boundary; deliverables; acceptance; stop conditions; return format |
| context | "AGENTS.md is already loaded: do not read it"; until K02 is done, the brief overrides the stale global ~/.codex/AGENTS.md lines |
| return format | a summary of at most 40 lines in the seven HANDOFF fields (INHERITED, PROVEN, UNPROVEN, CHANGED, REMAINING, DO NOT TOUCH, NEXT); deliverables written to `sb/W<NN>/codex/` or `assurance/V<n>/`; Claude reads the summary and the diffs, never the whole transcript |
| two-way | each brief asks Codex for its own proposals and concerns; Claude answers in a disposition table (agree or disagree, with evidence) |
| verification by Claude | read test edits first (a weakened assertion is a contract change); verify each material finding against real data; one rebuttal round before a rejection is final |
| V2 honesty | V2 in V1's session is labelled "same-session V2" and uses the fixed adversarial checklist in RUNBOOK.md |
| no internet | DEC-19; research of current standards, for the prototype and for V3, is Claude main's (DEC-16) |
| safety | every run through Delegate; never beside a heavy job (Finish, full suite, package build, restore); never touch a watched checkout during a run; fixtures under the run's TEMP, never in deliverables |
| unavailable or limit hit | DEC-19 |

## 16. Subagents

No Claude subagents: DEC-15; Codex (section 15) gives the second view. If the owner allows a subagent for some role,
its startup context is measured before and after.

## 17. Push and release

- Release rule: DEC-25 (procedure: lib/README "Explicit dual owner operations", ruleset "Workbench Main Protection").
- Approvals that only the owner can give: DEC-02.

## 18. Security

- The repository is public by owner choice (DEC-09): all essential governance is published.
- Secrets are never committed: keys, tokens, passwords, connection strings, cookies, private keys. Every file entering
  Git passes the secret scan (the Sync-Sessions masking patterns); a hit keeps the file out of Git, in `data/` if an
  active reader needs it (DEC-09).
- Raw transcripts never enter Git. GitHub push protection is the second net, not the first.
- No privileges are widened; no credential, machine setting or unrelated repository is changed, except K01-K03.

## 19. Checks

| Check | Run by | Covers |
| --- | --- | --- |
| `Organize -Check` | Hunt Quick (so Pulse and Finish see it) | layout, names, organizers, orphans, LOG coverage, broken references (DEC-10) |
| guards and stale checks (slice S11, DEC-28) | `Organize -Check` and the owning tests | a schema check for each TSV, JSON and JSONL data file; each derived file regenerated and compared with its stored copy; the write guards that P1.1e proves the client enforces |
| Markdown guard (lib/Test-MarkdownConsistency.ps1; read-only: the working tree, the index or a Git tree, never an outside path) | the Finish schedule | every tracked Markdown file reachable from README.md or AGENTS.md through local links, unless it is history (an allocated contract, or a link in the History index of docs/history/README.md); links and anchors resolved case-sensitively from their file; the One-home table of WORKFLOW.md (each concept once, in its fixed home); only RESUME.md declares the active contract pointer; no duplicate prose paragraph of 25 words or more; no header date older than a body amendment; a retired path never as an instruction; DEC-ID uniqueness, watch patterns (never on a frozen owner text whose exact bytes the guard pins, and no other check is skipped), archive append-only with every item naming an existing entry, size budgets in bytes after CRLF to LF (AGENTS.md 1.5 KB, NOW.md 6 KB, README.md 8 KB, DECISIONS.md 48 KB, RESUME.md 900 B, HANDOFF.md 4,500 B, WORKFLOW.md 20,300 B, injected hook text), links and line length (<= 200; table rows exempt) in active files; section IDs and citations (records/WS-033/signposting.md section 5) |
| Hunt C2 | Hunt Quick | every archive item and every mapped D-number names an existing DEC entry |
| secret scan | Save-State and the contract's staged gate | every file entering Git |
| native gates | the lifecycle | unchanged |
| purpose checks | Review, from the derived profiles (section 14.4) | each profile's added check ran on the exact candidate (DEC-12) |
| hosted portability | P1 of every workstream | each new or changed test runs once outside any ORVION-Workbench-temporary folder with a 101-character test root (the longest the evaluator admits), so a test that needs this PC's layout or a short root fails before the push (DEC-12, P1.1a) |

The checks cover active files only, so old history never blocks a future contract. No check claims to understand
meaning; contradictions in wording still need the review.

## 20. Day-to-day flow

```text
START        AGENTS.md (auto) + NOW.md (injected) ------------------------> work begins, nothing re-read
NEED A RULE  docs/DECISIONS.md by DEC-NN --> why, or what it said before? its History IDs in the archive
EACH STEP    Save-State --> NOW.md overwritten, LOG line, vault continuity copy, status page regenerated
                       \--> prints the /compact line and the resume message for the owner
NEW DECISION owner --> decisions-inbox.md (data root) + NOW.md "Pending decisions"
                       \--> next contract: its entry rewritten in docs/DECISIONS.md; the old wording --> the archive
WS END       summary --> records/WS-<NN>/README.md; push through the release checks;
             cited files --> data/records/WS-<NN>; Organize -Clean deletes the W<NN> items in temporary
02:00 DAILY  Backup-Workspace --> one package in the vault --> -Clean retention: last 7 packages, transcripts 60 days
```

## 21. Targets (measured with measure.ps1 and inventory.ps1)

| Measure | 2026-10-31 baseline | Target |
| --- | --- | --- |
| working folders | 3 | 2, plus the vault (the last 7 packages and the continuity copy) |
| cloud space (free plans) | GitHub 3.5 MB; OneDrive about 1.2 GB | GitHub well under 1 GB; OneDrive only the last 7 packages (plus any an active file names) and the continuity copy |
| files kept only as history | thousands (old packages, copies, archives) | 0 after the Lift |
| broken references after a move or deletion | not checked | 0 (Organize -Check, the Markdown guard, Hunt) |
| files read before working | 4-6 plus a 37 KB log | the stub plus injected NOW.md (<= 6 KB) |
| state re-read after a compact | about 10 k tokens | none |
| decisions and rules | 101 layered decisions plus copies in documents, memory and code | one consolidated docs/DECISIONS.md and one archive |
| folders with an organizer | a few | every managed folder |
| create, move, delete | each agent its own way | one tool, one log |
| workstream controller scripts | copied each time (139 copies) | one shared tool from WS-034, if it earns its place |
| temporary data | about 5 GB, 142 k files | only the active workstream and the pinned tools |
| hook runs per shell call | 2 | 1 |
| Codex sessions per workstream | one per phase | one |

## 22. When something is not covered, or must change

The owner authorized improvements as needs arise (DEC-02). The procedure, with no discretion:

1. Check sections 4 and 10 again; most cases are there.
2. If not covered: choose the smallest change that passes the four tests (section 1) and weakens nothing in section 9
   or 18.
3. Make it, and in the same operation record it: a LOG.tsv row if a folder changed; this document rewritten in place,
   with no change notes inside it (earlier versions: Git history; before slice S1, the daily packages); the owner's words in
   `decisions-inbox.md` (data root) if it changes a decision; a line in NOW.md.
4. If the change would weaken a gate, a test or security, or needs an approval only the owner can give: STOP and ask
   the owner. Never work around a refusal.

## 23. Words

| Word | Meaning |
| --- | --- |
| place | one of the two working folders or the vault |
| managed folder | a folder that must have an organizer (section 5) |
| organizer | the README.md of a managed folder |
| sealed content | everything below a managed folder's direct children that are not managed themselves |
| active file | a file agents or tools read in normal work: README, AGENTS, DECISIONS, RUNBOOK, this document, NOW, the plan, organizers, lib/README, the tools and the memory files |
| frozen text | the owner's words, a contract, the decision archive and evidence: never edited; appended to only where its own rules say so |
| operation | one lifecycle step that leaves evidence: Prototype, one Draft version, one review, Qualify, Gate, each Stage, one Finish, Review, Complete, one cleanup tier, one push |
| evidence | a record that proves what happened; kept while a workstream is open, and after it only when cited (DEC-11) |
| cited | a file whose path or SHA256 a decision in force, a contract, the current evidence of an event, a tool, a memory file, recovery-inputs.json or an active document names, or that sits in a folder one of these (a contract excepted) names; a mention only in the archive or in other evidence does not count (records/WS-033/cite-scan.ps1) |
| broken reference | a path, link, citation or section ID in an active file that resolves to nothing; a reference inside a frozen text resolves through LOG.tsv |
| orphan | an item that fails "Earn it": no active reader, kept only as history, or past its lifetime |
| pinned path | a path that moves only together with all its readers (section 9) |
| vault | OneDrive\ORVION-Recovery, the one backup copy (section 3.3) |
| workstream folder | `ORVION-Workbench-temporary/sb/W<NN>/` |
