# The real, evidenced events backfilled on 2026-10-20 (2026-09-12 .. 2026-10-19). Fixture for test-events-retrieval.ps1;
# with -Root it seeds any workspace root (the live log was seeded from this file).
param([string]$Root=(Split-Path (Split-Path $PSScriptRoot -Parent) -Parent))
# Sessions are the Claude Code session ids whose archived transcript (sessions\raw) holds the raw evidence;
# memory:<name> is the Claude memory file that recorded the lesson.
$ev=Join-Path (Split-Path $PSScriptRoot -Parent) 'Events.ps1'
$when=@{'63808aed'='2026-10-13';'e02f0fe8'='2026-10-12';'d5f0f1f2'='2026-10-18';'cbaf43d9'='2026-09-12';'ef4f85b6'='2026-10-15';'84ee17dc'='2026-10-19'}
$tags=@{'agent-stall-unseen-approval'='background subagent agent stuck hang waiting permission prompt launch parallel'
  'ps-reserved-name'='powershell pid process id param parameter variable name alias helper function host input event'
  'pwsh-file-relative-path'='founder platinum other repo cross-repository workingdirectory script path generator check'
  'native-failure-reads-empty'='git exit code lastexitcode grep ls-tree empty output fail-open missing object'
  'watch-run-eta'='watcher monitor eta progress timed run finish suite minutes left'
  'host-memory-pressure'='ram memory paging commit slow finish suite parallel wsl docker'
  'start-process-quoting'='start-process argumentlist spaces quoting child process launch'
  'relative-path-wrong-location'='path relative cwd location push-location scratchpad short'
  'orphaned-search-process'='grep transcript large file search stop kill orphan'
  'session-history-lost'='transcript session history jsonl cleanup retention archive lost'
  'nested-workspace-in-repo'='sandbox clone worktree evidence folder inside repository orvion-local ignored'
  'secret-printed-to-transcript'='environment env variables token secret credential print'
  'agents-miss-tools'='tool index discover boot agents codex'}
function Add-Seed{param([hashtable]$A)$A.Tags=$tags[$A.Pattern];$A.At=[datetime]"$($when[$A.Session.Substring(0,8)])T12:00:00Z";& $ev -Root $Root -Add @A|Out-Null}
$s84='84ee17dc-76fe-4805-8511-2c83423b31a9';$s63='63808aed-c360-41de-a638-d9b28b21e217';$se0='e02f0fe8-a3b4-4d23-9011-4f34e0d84a4c'
$sd5='d5f0f1f2-bccb-47e1-aacc-979d1c2e1cab';$scb='cbaf43d9-4c5e-42a8-9a59-6c20ae736929';$sef='ef4f85b6-be26-4d7e-b68c-bd431800e671'

Add-Seed @{Pattern='agent-stall-unseen-approval';Session=$s63;Category='failure';Cause='confirmed';Status='resolved';Severity='high'
  Summary='background agent stalled: tool call on a scratchpad path waited on an approval prompt no one could see';Action='pass the repo path and inline the candidate text';Evidence='memory:background-agents-stall-on-scratchpad-paths'}
Add-Seed @{Pattern='agent-stall-unseen-approval';Session=$s84;Category='failure';Cause='confirmed';Status='resolved';Severity='high'
  Summary='three background agents waited 52 min on a Grep outside the working directories; reruns stalled the same way';Tool='Watch-Subagents.ps1';Action='read-only agents use Read/Grep/Glob inside additionalDirectories; watch every background agent';Evidence='memory:background-agents-stall-on-permission-prompts'}
Add-Seed @{Pattern='ps-reserved-name';Session=$se0;Category='failure';Cause='confirmed';Status='resolved'
  Summary='helper named Git/H/R collided with a command or alias and recursed';Tool='Test-ScriptHazards.ps1';Action='Verb-Noun helper names';Evidence='memory:powershell-helper-names-collide-with-aliases'}
Add-Seed @{Pattern='ps-reserved-name';Session=$s84;Category='failure';Cause='confirmed';Status='resolved'
  Summary='new scripts used $Pid and $event (automatic variables) as names; Watch-Host param silently broken';Tool='Test-ScriptHazards.ps1';Action='run Test-ScriptHazards on every new .ps1 (now flags automatic variables)';Evidence="session:$s84"}
Add-Seed @{Pattern='pwsh-file-relative-path';Session=$s84;Category='failure';Cause='confirmed';Status='resolved';Severity='warn'
  Summary='pwsh -WorkingDirectory <Founder> -File scripts/x.ps1 ran the CALLER repo''s script; a Review measurement was taken on the wrong repo';Action='always pass an absolute -File path';Evidence='memory:pwsh-file-relative-path-ignores-workingdirectory'}
Add-Seed @{Pattern='native-failure-reads-empty';Session=$sd5;Category='failure';Cause='confirmed';Status='resolved';Severity='high'
  Summary='a failed git command read as empty output ("clean", "no match") and a check passed';Action='Invoke-RepoGit / check $LASTEXITCODE; rehearsals throw on unmet verdicts';Evidence='memory:native-command-failure-reads-as-empty'}
Add-Seed @{Pattern='native-failure-reads-empty';Session=$s84;Category='discovery';Cause='confirmed';Status='open';Severity='high'
  Summary='git grep exits 1 for an unreadable blob as for no match: with one object missing the commit hook printed READY for a reused id';Action='object-store guard before any read (Platinum SPEC-291 / Founder SPEC-293 at Gate 1)';Evidence='Owner-Review\wave1-2026-10-19\evidence';Trigger='closes when SPEC-291/293 are certified'}
Add-Seed @{Pattern='watch-run-eta';Session=$sd5;Category='failure';Cause='confirmed';Status='resolved'
  Summary='watch_run gave no ETA ("0 comparable runs") because -Run was a SPEC id';Tool='scripts/watch_run.ps1';Action='use a stable -Run name: finish-control, control-suite';Evidence='memory:watch-run-needs-a-stable-run-name'}
Add-Seed @{Pattern='watch-run-eta';Session=$s84;Category='proposal';Cause='confirmed';Status='deferred'
  Summary='watch_run: late attach replays old progress; no ETA without same-name history; median ETA ignored live progress (44 min shown, 21 left)';Action='test-count ETA from the last run of the same suite';Trigger='wave-2 tooling contract'}
Add-Seed @{Pattern='host-memory-pressure';Session=$se0;Category='failure';Cause='confirmed';Status='resolved';Severity='high'
  Summary='host killed a suite at 1.7 GB free physical memory';Action='stop ORVION containers and drop the WSL cache before -Finish';Evidence='memory:free-memory-before-finish'}
Add-Seed @{Pattern='host-memory-pressure';Session=$s84;Category='discovery';Cause='confirmed';Status='resolved'
  Summary='low free RAM predicts slowdown (4.5 GB 36 min, 3.1 GB 43, 2 GB 47); low commit headroom predicts failure (stayed ~10 GB)';Tool='Watch-Host.ps1';Action='PRESSURE = expect slowdown; COMMIT LOW = stop the newest heavy run'}
Add-Seed @{Pattern='start-process-quoting';Session=$scb;Category='failure';Cause='confirmed';Status='resolved'
  Summary='Start-Process -ArgumentList dropped quoting of a space-bearing path; the child failed silently';Action='use & or pass explicit quotes; read stderr first when something hangs';Evidence='memory:start-process-argumentlist-drops-quoting (raw session deleted by 30-day cleanup)'}
Add-Seed @{Pattern='relative-path-wrong-location';Session=$se0;Category='failure';Cause='confirmed';Status='resolved'
  Summary='.NET file APIs resolved a relative path against the process cwd, not the PowerShell location';Action='absolute paths for [IO.File]';Evidence='memory:dotnet-file-apis-ignore-powershell-location'}
Add-Seed @{Pattern='relative-path-wrong-location';Session=$s63;Category='failure';Cause='confirmed';Status='resolved'
  Summary='the scratchpad 8.3 short path broke Push-Location';Action='long path or -WorkingDirectory; assert cwd before mutating';Evidence='memory:scratchpad-short-path-breaks-push-location'}
Add-Seed @{Pattern='orphaned-search-process';Session=$sef;Category='failure';Cause='confirmed';Status='resolved';Severity='warn'
  Summary='a stopped Bash left a 9.7 GB grep.exe running over a transcript';Action='ReadLines+IndexOf for transcripts; check leftovers after a stop';Evidence='memory:stopped-bash-can-orphan-grep'}
Add-Seed @{Pattern='session-history-lost';Session=$s84;Category='discovery';Cause='confirmed';Status='resolved';Severity='high'
  Summary='Claude Code deletes transcripts after 30 days (cleanupPeriodDays unset): session cbaf43d9 (2026-09-12) and every session before 2026-10-11 are gone';Tool='Sync-Sessions.ps1';Action='archive verbatim at every session start/end into ORVION-Owner-Tools\sessions'}
Add-Seed @{Pattern='nested-workspace-in-repo';Session=$s84;Category='discovery';Cause='confirmed';Status='resolved';Severity='high'
  Summary='an ignored sandbox copy inside a repo hid 32 broken references from check_repository_consistency (basename index walks ignored files)';Action='keep all local work outside the repository trees (ORVION-Owner-Tools\work)'}
Add-Seed @{Pattern='secret-printed-to-transcript';Session=$s84;Category='failure';Cause='confirmed';Status='resolved';Severity='warn'
  Summary='listing env vars by name pattern printed a local Claude Code IPC token into the transcript';Action='print variable names only, never values, when inspecting the environment'}
Add-Seed @{Pattern='agents-miss-tools';Session=$s84;Category='discovery';Cause='confirmed';Status='deferred'
  Summary='agents find a tool when the task names the need, never otherwise; Boot names no working tool';Tool='ORVION-Owner-Tools\README.md';Action='Boot TOOLS lines per mode + generated index';Evidence='memory:why-agents-miss-orvion-tools';Trigger='wave-2 tooling contract'}
'seeded'
