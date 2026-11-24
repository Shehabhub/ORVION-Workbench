# Workbench Change Request - WS-049

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

## Objective

Put the constitution in front of every reply and check the reply, with the scope of data/records/WS-049/CONTRACT.md section 4. .claude/settings.json adds a UserPromptSubmit command hook that runs lib/hooks/Load-Constitution.ps1 (timeout 20) and a Stop hook of type prompt (timeout 30). On UserPromptSubmit, Load-Constitution.ps1 prints only DEC-33 of docs/DECISIONS.md under the heading "THE CONSTITUTION, DEC-33 of <root>\docs\DECISIONS.md (apply each rule before writing):", within the 9500-character bound already used for SessionStart, else the existing retrieve line; a missing rule prints the retrieve line as before. The Stop prompt passes when stop_hook_active is true or the reply claims no result, completion, test outcome, approval or fact taken from a tool, agent or web page; otherwise it returns the reply, naming the rule and quoting the sentence to fix, when it breaks DEC-33 rule 4 (acts on or claims an approval not given), rule 5 (states another's claim as verified fact) or rule 10 (says done, passed, proven or fixed without the check and the artifact). lib/test-watch-reminder.ps1 adds the UserPromptSubmit cases and two production mutants; lib/README.md names the new events; changes/README.md gets the WS-049 row Organize -Refresh writes. Benefit (DEC-30: errors prevented, fewer owner interventions): the owner found agents deciding without the constitution (owner words of 2026-11-24); SessionStart loads it once per context, so in a long session it drifts out of attention, and nothing checked a reply before the owner read it.

Tier: Significant under DEC-12 (a hook on every owner message and a check that can return any reply, in .claude/settings.json, a governance control file). Governance check: every consumer listed (CONTRACT.md section 4); the owning tests run on the candidate with the new cases and causal production mutants; a hook probe on the replay; a retro closes the workstream. Authority: DEC-02, DEC-08, DEC-09, DEC-11, DEC-12, DEC-13, DEC-14, DEC-22, DEC-23, DEC-24, DEC-25, DEC-26, DEC-28, DEC-30 and DEC-33; the owner's words of 2026-11-24 frozen in data/records/WS-048/owner-words/owner-2026-11-24-constitution-enforcement.txt (SHA256 450894BF94216E96D1E7D70B2CE4683340FD2425EA741A96EB36C8F85F3F196A), with the owner's approval of the final proposal ("good very good") and "now refine the last plan build", under the owner's delegation that the constitution decides in the owner's absence (data/records/WS-046/owner-words/owner-2026-11-21-constitution-decides-in-my-absence.txt, SHA256 DB34F67C2AF82D9A9751597247ABEEBD74B4BBB1CC6F47291D2572FE080EEAB0) and the live AFK Mode run instruction. Gate approvals are Claude main's under that delegation, labelled DELEGATED; no owner text is typed by an agent (DEC-02).

Number: WS-049. Intended contract: changes/WS-049-constitution-prompt-gate.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: this contract changes neither lib/Invoke-ContractLifecycle.ps1 nor the judge and adds no script, so both roles run the Original's own controller (SHA256 AD76811656C7DAEEED7D214597F986178B57BA7943DE4B16F0438A33F57CEF57), its SHA256 checked before each stage, with the accepted judge. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run.

## Baseline

e08429d88b79db041c7ea91bf23571e878812255

## Write Scope

- .claude/settings.json
- changes/README.md
- lib/hooks/Load-Constitution.ps1
- lib/README.md
- lib/test-watch-reminder.ps1
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: the permissions deny list, the SessionStart hook and the PreToolUse hook of .claude/settings.json; every SessionStart line of lib/hooks/Load-Constitution.ps1 (its output for every source is unchanged apart from the lib/README.md Always line this contract changes); every other case of lib/test-watch-reminder.ps1; every other row and line of lib/README.md and changes/README.md; docs/DECISIONS.md (the constitution itself does not change); lib/hooks/Watch-Reminder.ps1, Guard-Write.ps1, Probe-Guard.ps1 and every other lib/ file, test and hook; lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1 and lib/Workbench.ps1; docs/ (docs/WORKSPACE-LAYOUT.md names the hook and stays true); past changes/WS-0xx files; the owner's profile (%USERPROFILE%\.claude and %LOCALAPPDATA%\usage); data/ (untracked); the seven legacy folders, Owner-Tools, the vault and every package; any CRM or ORVION change (DEC-08); any Supabase project, Primary or Founder Secondary; credentials, real sessions or events (DEC-09); Codex, subagents, RAM, power or scheduled-task changes; any push or release before both roles are Complete (DEC-25).

## Draft Assurance

V1: WS049-V1-CLAUDE-SIGNIFICANT-DESIGN-20261124-01 | 2026-11-24 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-049\assurance\V1\DRAFT.md | 27DDCE8F3D9D13D84B1BD1DB61542A025E25F175521E9834C8F773DEB2451A54
V2: WS049-V2-CLAUDE-SIGNIFICANT-ADVERSARIAL-20261124-01 | 2026-11-24 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-049\assurance\V2\DRAFT.md | 9D12FEC57DA112D8CBDA48943DC021D849DC631C82B044647A38A70B8C73516F
V3: WS049-V3-CLAUDE-REFRESH-20261124-01 | 2026-11-24 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-049\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V1 DESIGN by Claude main, claude-opus-5-5, under D120: the owner skipped Codex and subagents on 2026-11-08 ~01:20 Cairo, standing (the owner's words verbatim in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md; D124 wrote D120 into DEC-14 and DEC-19). Codex skipped by owner decision, not by unavailability. No Codex work is claimed and nothing here is independent. V1 designs the scope of data/records/WS-049/CONTRACT.md section 4 from the frozen candidate.

V2 ADVERSARIAL by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V2 attacks V1 and changes no output: (a) bound: Claude Code caps a UserPromptSubmit hook's added context at 10,000 characters; the hook prints DEC-33 alone (2954 bytes) under the 9500 bound already used for SessionStart, and over it prints the retrieve line, never a cut text; the PROMPTBOUND mutant proves the bound is tested. (b) fail loud: the UserPromptSubmit branch sits after the missing-rule check, so a docs/DECISIONS.md without DEC-33 still prints the retrieve line on every event; the PROMPT mutant (branch never taken) proves the event case is tested. (c) reach: the hook judges its root by CLAUDE_PROJECT_DIR, else the event cwd, against its own parent of lib, so a session outside the Workbench gets nothing from it; CRM and ORVION sessions do not load the Workbench project settings. (d) Stop loop and cost: the prompt answers ok when stop_hook_active is true, so a returned reply is checked at most once more, and a reply with no claim passes; the cost is one small-model call per reply. (e) untouched controls: the deny list, SessionStart and PreToolUse keep their bytes (numstat 22/0, the exact added lines, and the parsed hook counts in the Draft check); Guard-Write.ps1 and test-organize read only the deny list. (f) unprovable here: the Stop prompt's verdict runs only in a live session, so it stays a HYPOTHESIS until real replies after Complete, recorded in the retro (DEC-33 rule 10).

V3 REFRESH by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V3 changes no output and confirms the live facts on 2026-11-24: origin/main and the Original HEAD are both e08429d88b79db041c7ea91bf23571e878812255 with a clean tree; lib/Invoke-ContractLifecycle.ps1 is still SHA256 AD76811656C7DAEEED7D214597F986178B57BA7943DE4B16F0438A33F57CEF57 and lib/Test-WorkbenchChange.ps1 still 4E1F00E159B82ECDFDD0F0C542A08B71D77BBFE4ABAAB4B6B1B8377587017FD1; the pinned host is 7.6.8 and git 2.56.1.windows.1. The V1 Draft check passed with both mutants (PROMPT and PROMPTBOUND) killed, each first FAIL line the Load-Constitution assertion naming its case, their bytes restored, the hook probe as designed, no gitleaks finding and 0 of 74 hazards; V2 reused the V1 test results because the replay tree was identical, and V3 does the same under the same rule.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W49\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W49\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W49\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W49\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.56.1.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none. PowerShell 7.6.8 is the portable host in ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8, which WS-034 and WS-040 to WS-048 ran; git 2.56.1 is the live machine version.

1. Check whether `.claude/settings.json` contains `"UserPromptSubmit": [`; if so record Already Applied when its Git blob is 1770bce133b2c4a0a50bffb8fcecc338bc89365e, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-049 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
       ],
   ```
   insert
   ```text
       "UserPromptSubmit": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "pwsh -NoProfile -File \"$CLAUDE_PROJECT_DIR/lib/hooks/Load-Constitution.ps1\"",
               "timeout": 20
             }
           ]
         }
       ],
       "Stop": [
         {
           "hooks": [
             {
               "type": "prompt",
               "prompt": "Check one reply of an agent working on ORVION. Hook input: $ARGUMENTS. If stop_hook_active is true, answer {\"ok\": true}. Read last_assistant_message. If it claims no result, completion, test outcome, approval or fact taken from a tool, agent or web page, answer {\"ok\": true}. Otherwise answer {\"ok\": false, \"reason\": \"...\"} when one of these holds, the reason naming the rule and quoting the sentence to fix: DEC-33 rule 4, it acts on or claims an approval that the owner's live message or a recorded delegation does not give; DEC-33 rule 5, it states another agent's, tool's or page's claim as verified fact without saying whose claim it is; DEC-33 rule 10, it says done, passed, proven or fixed without naming how it was checked and the artifact that shows it. Else answer {\"ok\": true}.",
               "timeout": 30
             }
           ]
         }
       ],
   ```

   The resulting file's Git blob is 1770bce133b2c4a0a50bffb8fcecc338bc89365e.

2. Check whether `changes/README.md` contains `| WS-049-constitution-prompt-gate.md | contracts | Workbench Change Request - WS-049 | - | - |`; if so record Already Applied when its Git blob is ee8a76130cd075fc76277a719bcefa971ca18e30, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-049 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-048-carried-cancel-write-scope.md | contracts | Workbench Change Request - WS-048 | - | - |
   ```
   insert
   ```text
   | WS-049-constitution-prompt-gate.md | contracts | Workbench Change Request - WS-049 | - | - |
   ```

   The resulting file's Git blob is ee8a76130cd075fc76277a719bcefa971ca18e30.

3. Check whether `lib/hooks/Load-Constitution.ps1` contains `# blocks and exits 0. As the UserPromptSubmit hook it prints only DEC-33's twelve rules, so each owner message puts them`; if so record Already Applied when its Git blob is 30db23c520424535bd841bb09043c3e48e6e11c1, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-049 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   # blocks and exits 0.
   ```
   with
   ```text
   # blocks and exits 0. As the UserPromptSubmit hook it prints only DEC-33's twelve rules, so each owner message puts them
   # in front of the reply; the Stop prompt hook of .claude/settings.json then checks the reply against rules 4, 5 and 10.
   ```

   b) immediately after the line
   ```text
       if($missing){"$retrieve (not found: $($missing-join', '))."; exit 0}
   ```
   insert
   ```text
       if($e.hook_event_name-eq'UserPromptSubmit'){
           $rules="THE CONSTITUTION, DEC-33 of $workbench\docs\DECISIONS.md (apply each rule before writing):`n$dec33"
           if($rules.Length-gt9500){"$retrieve (over the 9500-character bound)."}else{$rules}; exit 0
       }
   ```

   The resulting file's Git blob is 30db23c520424535bd841bb09043c3e48e6e11c1.

4. Check whether `lib/README.md` contains `and this section, UserPromptSubmit DEC-33 again on each message, and Stop checks the reply against rules 4, 5 and 10; a direct-native session receives no Workbench`; if so record Already Applied when its Git blob is 15a5411750b27e8d001c83007357769f92d5d9eb, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-049 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   and this section; a direct-native session receives no Workbench
   ```
   with
   ```text
   and this section, UserPromptSubmit DEC-33 again on each message, and Stop checks the reply against rules 4, 5 and 10; a direct-native session receives no Workbench
   ```

   b) replace the line
   ```text
   | `hooks\Load-Constitution.ps1` | the SessionStart hook of `.claude/settings.json` at the Workbench root, on every source: DEC-30 and DEC-33 of docs/DECISIONS.md whole and the title of every other decision; section 4 only in a new context (startup, clear), else a pointer to it; within 9500 characters, the tool section giving way first; a missing rule or a breach prints `CONSTITUTION NOT LOADED: read ...` |
   ```
   with
   ```text
   | `hooks\Load-Constitution.ps1` | the SessionStart hook of `.claude/settings.json` at the Workbench root, on every source: DEC-30 and DEC-33 of docs/DECISIONS.md whole and the title of every other decision; section 4 only in a new context (startup, clear), else a pointer to it; within 9500 characters, the tool section giving way first; a missing rule or a breach prints `CONSTITUTION NOT LOADED: read ...`. Also the UserPromptSubmit hook: DEC-33 alone on every owner message, within 9500 characters. The Stop prompt hook beside it (no script) asks the background model to return a reply that breaks DEC-33 rule 4, 5 or 10 with the sentence to fix; it passes a reply with no claim and never fires twice in a row |
   ```

   The resulting file's Git blob is 15a5411750b27e8d001c83007357769f92d5d9eb.

5. Check whether `lib/test-watch-reminder.ps1` contains `# 9500 bound, the retrieve line when a rule is missing, silence elsewhere; as the UserPromptSubmit hook DEC-33 alone,`; if so record Already Applied when its Git blob is 461c91473a9dac7732a208eab33ccd30fbf6349d, and otherwise stop and report. Otherwise make exactly these 5 edits (land this exact frozen WS-049 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
               # 9500 bound, the retrieve line when a rule is missing, silence elsewhere; then four mutants, each must be caught.
   ```
   with
   ```text
               # 9500 bound, the retrieve line when a rule is missing, silence elsewhere; as the UserPromptSubmit hook DEC-33 alone,
               # bounded; then seven mutants, each must be caught.
   ```

   b) immediately after the lines
   ```text
                       if($source-eq'startup'){$script:constitutionStartup=$o}elseif($source-eq'resume'){$script:constitutionResume=$o}
                   }
   ```
   insert
   ```text
                   $r=Invoke-DeadlineEvent $constitutionHook 'UserPromptSubmit' $deadlineCheckout;$o=$r.Text;$script:constitutionPrompt=$o
                   if($r.Exit-ne0-or$r.Error-or$o.Length-gt9500-or@(Get-DecisionSection 'DEC-33'|Where-Object{!$o.Contains($_)}).Count-or$o.Contains('## DEC-30 ')-or$o.Contains('Other decisions in force')-or$o.Contains('Tool guidance')){$faults.Add('DEC-33 alone on UserPromptSubmit')}
   ```

   c) immediately after the line
   ```text
                   if(!(Invoke-DeadlineEvent $constitutionHook 'SessionStart' $deadlineCheckout 'startup').Text.Contains('over the 9500-character bound')){$faults.Add('constitution bound')}
   ```
   insert
   ```text
                   if(!(Invoke-DeadlineEvent $constitutionHook 'UserPromptSubmit' $deadlineCheckout).Text.Contains('over the 9500-character bound')){$faults.Add('UserPromptSubmit bound')}
   ```

   d) replace the line
   ```text
               "BYTES Load-Constitution startup=$($constitutionStartup.Length) resume=$($constitutionResume.Length) characters"
   ```
   with
   ```text
               "BYTES Load-Constitution startup=$($constitutionStartup.Length) resume=$($constitutionResume.Length) prompt=$($constitutionPrompt.Length) characters"
   ```

   e) replace the lines
   ```text
               $mutants=[ordered]@{source="if(`$true){";retrieve='if($false){"$retrieve (not found:';bound='-gt99999){$guidance=$pointer}';scope="TrimEnd('\')){}";project='$cwd=if($false){'}
               $mutated=[ordered]@{source="if(!`$e.source-or`$e.source-in'startup','clear'){";retrieve='if($missing){"$retrieve (not found:';bound='-gt9500){$guidance=$pointer}';scope="TrimEnd('\')){exit 0}";project='$cwd=if($env:CLAUDE_PROJECT_DIR){'}
   ```
   with
   ```text
               $mutants=[ordered]@{source="if(`$true){";retrieve='if($false){"$retrieve (not found:';bound='-gt99999){$guidance=$pointer}';scope="TrimEnd('\')){}";project='$cwd=if($false){';prompt='if($false){';promptbound='if($rules.Length-gt99999)'}
               $mutated=[ordered]@{source="if(!`$e.source-or`$e.source-in'startup','clear'){";retrieve='if($missing){"$retrieve (not found:';bound='-gt9500){$guidance=$pointer}';scope="TrimEnd('\')){exit 0}";project='$cwd=if($env:CLAUDE_PROJECT_DIR){';prompt="if(`$e.hook_event_name-eq'UserPromptSubmit'){";promptbound='if($rules.Length-gt9500)'}
   ```

   The resulting file's Git blob is 461c91473a9dac7732a208eab33ccd30fbf6349d.

## Acceptance Criteria

- [x] Output `.claude/settings.json` equals its declared resulting Git blob. check: blob:.claude/settings.json=1770bce133b2c4a0a50bffb8fcecc338bc89365e
- [x] Output `changes/README.md` equals its declared resulting Git blob. check: blob:changes/README.md=ee8a76130cd075fc76277a719bcefa971ca18e30
- [x] Output `lib/hooks/Load-Constitution.ps1` equals its declared resulting Git blob. check: blob:lib/hooks/Load-Constitution.ps1=30db23c520424535bd841bb09043c3e48e6e11c1
- [x] Output `lib/README.md` equals its declared resulting Git blob. check: blob:lib/README.md=15a5411750b27e8d001c83007357769f92d5d9eb
- [x] Output `lib/test-watch-reminder.ps1` equals its declared resulting Git blob. check: blob:lib/test-watch-reminder.ps1=461c91473a9dac7732a208eab33ccd30fbf6349d
- [x] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [x] AC-01 Behaviour: .claude/settings.json (numstat 22/0) adds exactly a UserPromptSubmit hook list with one command hook, `pwsh -NoProfile -File "$CLAUDE_PROJECT_DIR/lib/hooks/Load-Constitution.ps1"` with timeout 20, and a Stop hook list with one hook of type prompt and timeout 30 whose prompt checks DEC-33 rules 4, 5 and 10, answers {"ok": true} when stop_hook_active is true or the reply makes no claim, and names the rule and quotes the sentence to fix when it answers false; the permissions deny list, the SessionStart and the PreToolUse hooks keep their bytes, and the file parses as JSON. lib/hooks/Load-Constitution.ps1 (6/1) adds only two header comment lines and the UserPromptSubmit branch after the missing-rule check, which prints DEC-33 alone, headed "THE CONSTITUTION, DEC-33 of", within 9500 characters, else the retrieve line with "(over the 9500-character bound)". On the replay the Draft check runs the hook with a UserPromptSubmit event: exit 0, every DEC-33 line present, no DEC-30, no other-decisions line and no tool guidance, at most 9500 characters; with a SessionStart compact event its output is byte-identical to the baseline hook's, and with a startup event it differs only by the changed lib/README.md Always line.
- [x] AC-02 Tests and documentation: lib/test-watch-reminder.ps1 (8/4) adds exactly the faults 'DEC-33 alone on UserPromptSubmit' and 'UserPromptSubmit bound', prompt= in the BYTES line and the mutants prompt and promptbound beside the five existing ones; no existing check is removed or weakened. lib/README.md changes only line 136 and the Load-Constitution row (2/2), which name the UserPromptSubmit and Stop hooks. Two production mutants on the replay must each make test-watch-reminder fail with its Load-Constitution assertion as the first FAIL line and the named case in that line's fault list, and the Draft check must kill both and restore the bytes: PROMPT (the UserPromptSubmit branch never taken) and PROMPTBOUND (its 9500 bound raised to 99999). test-organize and test-markdown-consistency pass on the replay.
- [x] AC-03 Organizer: changes/README.md is what lib/Organize.ps1 -Refresh writes: it holds the WS-049 row, and a refresh of the replay with this contract in place changes no organizer.
- [x] AC-04 Secrets and privacy: gitleaks on the exact candidate range reports no finding in the 5 outputs and RESUME.md; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; neither masked value (the computer name, a marketing tunnel script name) nor the owner's e-mail is in any changed file or in this contract.
- [x] AC-05 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria; the scope profiles include CONTROL, so the Finish runs the full test schedule, test-watch-reminder, test-organize and test-markdown-consistency among it. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json. From each Finish launch to END: no Events -Add, Save-State or edit in a protected root, and Docker off.
- [x] AC-06 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-049/evidence/protected-before.json, captured before the sandbox Finish and again after Original Complete with data/records/WS-038/Capture-Protected.ps1; lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1 and lib/Workbench.ps1 are unchanged; both roles ran the Original's controller whose SHA256 this Draft names; CRM, ORVION and their trusted copies keep their HEAD and files (the lifecycle's protected-root compare); no Supabase project is touched; no Codex, subagent, RAM, power setting or scheduled task change; no push before both roles are Complete.

## Review Gate

- [x] Inspect the live subject, this role's fresh receipt, timing and watching evidence, and every criterion above, with attempts, deviations and gaps kept visible. No prototype result or earlier receipt substitutes for this role's gate.
- [x] Review: one Claude-main self-review, labelled as such and never called independent. The Codex review (DEC-14) is recorded SKIPPED by the owner's decision of 2026-11-08 ~01:20 Cairo, never replaced or claimed (D120). At most one corrective version; a remaining material disagreement goes to the owner.
- [x] Retro (DEC-12): Claude main names what does not satisfy it, each item with a remedy and a check.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Append only. No approval, execution-root binding or receipt is claimed. At actual approval add exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line using actual immutable identities. Owner evidence must name the approved digest and execution root. For original execution append exactly one Sandbox Receipt and Sandbox Receipt SHA256 for the matching successful schema2 sandbox artifact. A delegated decision needs actual live owner delegation and is labelled delegated. Never invent human confirmation or approval.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-049\assurance\V3\DRAFT.md
Approved SHA256: A42C7F5B702EEFA41074C934E5657953E34369E96382E4BFCFFFEDE59D28DDC5
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-049\gate\GATE1-WS049-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: E9A083B759374F9854E63F29A5FFB1061079A7B30B15B8E26979DD9776DA1157
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W49\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 67F0652B7E6F53E694DFD124960BCA9A1DD83A95CECEDD9E62E4D4BA0B91A877
Original exact declared outputs applied by accepted native Execute; fresh own Finish and Review/Complete remain required. Other protected roots unchanged. Controller: the Original's own lib/Invoke-ContractLifecycle.ps1 (SHA256 AD768116), unchanged by this contract and used by both roles, checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority.
Residual risks carried unchanged from the selected Draft Review Gate and data/records/WS-049/CONTRACT.md; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (D120, frozen in data/records/WS-034/owner-words), not by unavailability. Controller: the Original's own lib/Invoke-ContractLifecycle.ps1 (SHA256 AD768116), unchanged by this contract and used by both roles, checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority. Release is a later stage (DEC-25), after Original Complete and the retro.

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W49-c2 (data/records/WS-049/Make-Candidate.ps1). Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json beside this Draft. The Stop prompt hook's verdict runs only in a live session, so it stays a HYPOTHESIS until real replies after Complete show it; those go into the retro. After Complete, outside this contract: the release under DEC-25 on the DELEGATED record, only when every gate passed and Claude main's retro is satisfied; the protected state is compared with its record from before; Save-State records the result.
Verdict: Confirmed Complete
Reviewed Fingerprint: F8CA1E73D756718C7B6A04A3A78F237294F3387427B98AA864EFC876D03C8177
Reviewed Receipt: 613C67C1C368E33E569A43C2D19DB66CD0441E99A45A31EFFE6D88650AC5975C
Live ORIGINAL-role review: runtime/original/criterion-review.json. Own Finish 32 ordered suites, runner/watcher/host 0/0/0, real journal unchanged. Review: ONE Claude-main SELF-REVIEW, not independent; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (D120, frozen in data/records/WS-034/owner-words), not by unavailability. Exact completed sandbox proof 3D73CE0B908295330316DF71F3F8E8A8FBD35AF22FA2BBC4AEBA6095C456476E bound. Not pushed; the one release (DEC-25) follows only on every gate passed and the retro, under the owner's request and AFK Mode (DELEGATED).

