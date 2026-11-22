# Workbench Change Request - WS-046

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Make the shared approve stage refuse a sandbox whose native repository-consistency run failed anything beyond the expected RECOVER-1 for the undeployed target, with the scope of data/records/WS-046/CONTRACT.md section 3. lib/lifecycle.ps1 gains Get-ConsistencyExtra, which reads the log's own final "REPOSITORY CONSISTENCY:" verdict line (bare or with the Run-Timed prefix), allows one issue when the RECOVER-1 ledger line is present and one for each ConsistencyAccepted line found verbatim, and returns the remaining count; it throws when the log has no verdict or a named line is absent. lib/Invoke-ContractStage.ps1's approve stage, after the Draft blob check and before allocation, refuses SANDBOX_CONSISTENCY_LOG_REQUIRED without a SandboxConsistency log and SANDBOX_CONSISTENCY_NOT_CLEAN when the extra count is above zero, and its header names the two config keys. lib/test-native-stage.ps1 gives every fixture config a clean log and adds five cases, the fifth proving the refusal causal. lib/README.md's Invoke-ContractStage row names the refusal. changes/README.md gets the WS-046 row Organize -Refresh writes. Benefit: SPEC-323 r2 and SPEC-327 were both approved over a sandbox log whose RECOVER-1 sub-count equalled the total while Check 21 STALE-1 was a second issue; SPEC-327 found it only after the Primary write and was Cancelled. From WS-046 on that repeat refuses before allocation, so no Primary write follows a sandbox that already failed.

Tier: Significant under DEC-12 (a new refusal in the shared approve stage every CRM and ORVION SPEC passes before a Primary write). Governance check: every consumer listed (CONTRACT.md section 3); the owning tests run on the candidate with production mutants; a retro closes the workstream. Authority: DEC-02, DEC-08, DEC-09, DEC-11, DEC-12, DEC-13, DEC-14, DEC-22, DEC-23, DEC-24, DEC-25, DEC-26, DEC-30 and DEC-33 (rule 12: guard a proven repeat at source); the delegated decision data/records/WS-046/owner-words/spec327-DELEGATED-CANCEL.md (SHA256 95A2D4C1E244658D4AAF5CFD4E3BC9AAEA8A6EA3080F2095586C2A88171C52BF) over the proven blocker data/records/WS-046/owner-words/spec327-original-postdeploy-blocker.md (SHA256 F947A462E2C6BC76BD8FCEBA2AF786D5FE397D4E1A30175DC56A4EF2EE171E1F), under the owner's run modes of 2026-11-21 (data/records/WS-046/owner-words/owner-2026-11-21-run-modes-redefined.txt, SHA256 35E35600BB9D2D69EBF0A85BE8E6256260617F9A8B47F74A091565BC53AF69DD) and the owner's delegation that the constitution decides in the owner's absence (data/records/WS-046/owner-words/owner-2026-11-21-constitution-decides-in-my-absence.txt, SHA256 DB34F67C2AF82D9A9751597247ABEEBD74B4BBB1CC6F47291D2572FE080EEAB0), with the owner's live words of 2026-11-22 "continue cluade - don't stop at any step - you have what you need" and "Keep going". Every scope choice is Claude main's under that delegation, labelled DELEGATED; no owner text is typed by an agent (DEC-02).

Number: WS-046. Intended contract: changes/WS-046-approve-sandbox-consistency-guard.md. It is allocated natively and is deliberately absent from Write Scope. Preparation leaves Active Workbench Contract: None.

Controller: this contract changes neither lib/Invoke-ContractLifecycle.ps1 nor the judge and adds no script, so both roles run the Original's own controller (SHA256 AD76811656C7DAEEED7D214597F986178B57BA7943DE4B16F0438A33F57CEF57), its SHA256 checked before each stage, with the accepted judge. Native Workbench.ps1 and the pinned evaluator keep every authority; any stage that does not print its expected result stops the run. Invoke-ContractLifecycle does not call Invoke-ContractStage, so this contract's own stages do not pass the new refusal.

## Baseline

75fe0dfbf19b4b709fff9ae47fc384da51a9166c

## Write Scope

- changes/README.md
- lib/Invoke-ContractStage.ps1
- lib/lifecycle.ps1
- lib/README.md
- lib/test-native-stage.ps1
- RESUME.md

## Out of Scope

Every path outside Write Scope apart from the native-allocated contract and native pointer transitions. In particular: every other function and line of lib/lifecycle.ps1 and lib/Invoke-ContractStage.ps1 (no other stage changes, and approve keeps every earlier check in its order); every other case of lib/test-native-stage.ps1; every other row of lib/README.md and changes/README.md; lib/Hunt.ps1 and its analyzer exception list; docs/; the batch6 per-SPEC .psd1 configs and every SPEC record (past configs ran under the old approve; SPEC-328 adds its own key later through its own records); lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Workbench.ps1 and every other lib/ file, test and hook; past changes/WS-0xx files; .claude/settings.json and the user settings in the owner's profile; data/ (untracked); the seven legacy folders, Owner-Tools, the vault and every package; any CRM or ORVION change (DEC-08); any Supabase project, Primary or Founder Secondary; credentials, real sessions or events (DEC-09); Codex, subagents, RAM, power or scheduled-task changes; any push or release before both roles are Complete (DEC-25).

## Draft Assurance

V1: WS046-V1-CLAUDE-SIGNIFICANT-DESIGN-20261122-01 | 2026-11-22 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-046\assurance\V1\DRAFT.md | BC7AB75B5F454619FAE74A503150F9098917B2C1BB97EF5585997DB13890C911
V2: WS046-V2-CLAUDE-SIGNIFICANT-ADVERSARIAL-20261122-01 | 2026-11-22 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-046\assurance\V2\DRAFT.md | 6B113A3A937A844DD7FBFFFC7C3CED3B71144285C9E2DB0FFBD7A90D39D40555
V3: WS046-V3-CLAUDE-REFRESH-20261122-01 | 2026-11-22 | C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-046\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

V1 DESIGN by Claude main, claude-opus-5-5, under D120: the owner skipped Codex and subagents on 2026-11-08 ~01:20 Cairo, standing (the owner's words verbatim in data/records/WS-034/owner-words/decisions-inbox-20261109T0620.md; D124 wrote D120 into DEC-14 and DEC-19). Codex skipped by owner decision, not by unavailability. No Codex work is claimed and nothing here is independent. V1 designs the scope of data/records/WS-046/CONTRACT.md section 3 from the frozen candidate.

V2 ADVERSARIAL by Claude main, claude-opus-5-5, under the same D120 standing: Codex skipped by owner decision, not by unavailability; nothing here is independent. V2 attacks V1 and changes no output: (a) V1 proved the guard only on synthetic fixtures; V2 runs the candidate's Get-ConsistencyExtra over every recorded batch6 native consistency log (data/records/WS-046/review/real-logs.txt, SHA256 A96CD055873CD0059BD36680CE78EDD52770C82E71D06BEC2951C70355272A65): SPEC-327's sandbox-step6 log gives 1 extra (the repeat is caught on the real bytes), SPEC-326's sandbox-step9, exit-bundle-a r3's sandbox-step7 and the Run-Timed-prefixed entry1 r2 original-predeploy log give 0, and the real SPEC-327 stale line named as accepted gives 0 while an absent named line throws; V2 puts these four logs into AC-01 as a probe the Draft check runs on the replay; (b) the baseline lib/lifecycle.ps1 lacks a final newline, which the generator's line edits cannot express and apply-draft-steps keeps, so the candidate adds it (numstat 14/1, the last line otherwise unchanged) and the Draft carries one explicit edit of the last two lines that adds it, proven by the replay blob; (c) a log whose verdict line the regex cannot read (a changed Run-Timed prefix) throws CONSISTENCY_LOG_UNREADABLE and never approves, so the residual fails closed.

V3 REFRESH by Claude main, claude-opus-5-5, under the same D120 standing; nothing here is independent. V3 rechecks the live facts V2 rests on and changes no output: origin main and the Original HEAD are both 75fe0df at baseline 75fe0df, the Original controller is still AD76811656C7DAEEED7D214597F986178B57BA7943DE4B16F0438A33F57CEF57, the pinned PowerShell is 7.6.8, git is 2.56.1.windows.1, and Check-Draft V2 passed with the replay blob of lib/lifecycle.ps1 equal to 1cc952623cd8e0d2f0665cd5dd3f341dd875eaf5, both production mutants killed (GUARDOFF, SUBCOUNT), the four real-log probes as V2 states, 0 gitleaks findings and 0 of 74 hazards, with V1's test results reused because the replay tree is identical. The first V1 check (V1/claude-draft-check-try1-FAIL.json) failed only on two index and quoting faults in Check-Draft's own text checks, fixed in the check before V1 passed on the same replay tree.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W46\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W46\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W46\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W46\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.56.1.windows.1
Minimum Physical GB: 0.001
Minimum Commit GB: 0.001

## Implementation Steps

Apply the literal file steps with the accepted baseline lib/apply-draft-steps.ps1 -Draft <this immutable Draft> -Root <admitted checkout>; the values are the actual admitted absolute paths, never the authoring clone. Steps run in printed order. Every payload is inline, so replay needs no source file. The Execution Context floors carry the owner's removal of every RAM minimum (2026-11-07): the evaluator accepts any value above 0, so 0.001 GB stands for none. PowerShell 7.6.8 is the portable host in ORVION-Workbench-temporary\tools\pwsh-portable-7.6.8, which WS-034 and WS-040 to WS-045 ran; git 2.56.1 is the live machine version.

1. Check whether `changes/README.md` contains `| WS-046-approve-sandbox-consistency-guard.md | contracts | Workbench Change Request - WS-046 | - | - |`; if so record Already Applied when its Git blob is dc771efef1dc0be8d388851d4774dda1dbb09226, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-046 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | WS-045-constitution-revision-3.md | contracts | Workbench Change Request - WS-045 | - | - |
   ```
   insert
   ```text
   | WS-046-approve-sandbox-consistency-guard.md | contracts | Workbench Change Request - WS-046 | - | - |
   ```

   The resulting file's Git blob is dc771efef1dc0be8d388851d4774dda1dbb09226.

2. Check whether `lib/Invoke-ContractStage.ps1` contains `# a sentence the approve and implement entries end with; absent means none), SandboxConsistency (approve: the sandbox's`; if so record Already Applied when its Git blob is eeb8538634620b49b74e30cf3cf8a78b524df299, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-046 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   # a sentence the approve and implement entries end with; absent means none).
   ```
   with
   ```text
   # a sentence the approve and implement entries end with; absent means none), SandboxConsistency (approve: the sandbox's
   # native repository-consistency log on the Draft's final tree), ConsistencyAccepted (optional exact log lines the Draft names).
   ```

   b) immediately after the line
   ```text
       if((Invoke-RepoGit @('hash-object',"--path=$ContractRel",'--',$cfg.Draft))-ne$cfg.Blob){throw 'DRAFT_BLOB_MISMATCH'}
   ```
   insert
   ```text
       # The sandbox's full native consistency run on the Draft's final tree: nothing beyond RECOVER-1 and the lines the
       # Draft names may fail (SPEC-323 r2 and SPEC-327 were approved over a missed STALE-1; event draft-pins-blob-of-file-later-step-edits).
       if(!$cfg.SandboxConsistency-or!(Test-Path -LiteralPath $cfg.SandboxConsistency -PathType Leaf)){throw 'SANDBOX_CONSISTENCY_LOG_REQUIRED'}
       $extra=Get-ConsistencyExtra $cfg.SandboxConsistency @($cfg.ConsistencyAccepted);if($extra-gt0){throw "SANDBOX_CONSISTENCY_NOT_CLEAN extra=$extra"}
       Write-Say "sandbox consistency: no issue beyond RECOVER-1 and $(@($cfg.ConsistencyAccepted|Where-Object{$_}).Count) named line(s); sha256 $((Get-FileHash -LiteralPath $cfg.SandboxConsistency).Hash)"
   ```

   The resulting file's Git blob is eeb8538634620b49b74e30cf3cf8a78b524df299.

3. Check whether `lib/lifecycle.ps1` contains `# Issues in a native repository-consistency log beyond those a sandbox may lawfully show. The total comes from the log's`; if so record Already Applied when its Git blob is 1cc952623cd8e0d2f0665cd5dd3f341dd875eaf5, and otherwise stop and report. Otherwise make exactly these 2 edits (land this exact frozen WS-046 candidate output), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
       Write-RepoText $Root $manifestRel ($t.Remove($m[0].Index,$m[0].Length).Insert($m[0].Index,"${Key}: $Value"))
   }
   ```
   insert
   ```text
   # Issues in a native repository-consistency log beyond those a sandbox may lawfully show. The total comes from the log's
   # own final line (bare, or with the Run-Timed prefix); an undeployed target fails Check 19 (RECOVER-1), which the native script counts as exactly one issue
   # however many ledger lines it prints; each $Accepted line must appear verbatim and accepts one more. SPEC-323 r2 and
   # SPEC-327 were approved over a log whose RECOVER-1 sub-count (2) equalled the total while STALE-1 was a second issue:
   # never compare sub-counts, compare the total. Returns the extra count; throws when the log has no final verdict.
   function Get-ConsistencyExtra([string]$Path,[string[]]$Accepted=@()){
       $t=[IO.File]::ReadAllText($Path);$v=[regex]::Matches($t,'(?m)^(?:\[\+ *[\d.]+ min\] )?REPOSITORY CONSISTENCY: (CLEAN|(\d+) issue\(s\) found)\r?$')
       if(!$v.Count){throw "CONSISTENCY_LOG_UNREADABLE $Path"}
       $total=if($v[$v.Count-1].Groups[2].Success){[int]$v[$v.Count-1].Groups[2].Value}else{0}
       $allowed=[int]($t-match'(?m)^(?:\[\+ *[\d.]+ min\] )?  Primary ledger evidence is ABSENT, STALE or DISAGREES')
       foreach($a in @($Accepted|Where-Object{$_})){if(!$t.Contains($a)){throw "CONSISTENCY_ACCEPTED_LINE_ABSENT $a"};$allowed++}
       $total-$allowed
   }
   ```

   b) replace the lines
   ```text
       [pscustomobject]@{Stopped=$born.Count;Survivors=$live.Count}
   }
   ```
   with
   ```text
       [pscustomobject]@{Stopped=$born.Count;Survivors=$live.Count}
   }

   ```

   The resulting file's Git blob is 1cc952623cd8e0d2f0665cd5dd3f341dd875eaf5.

4. Check whether `lib/README.md` contains `| bounded native transport: exact selected Draft/filter identity, native Boot and normal hooks before transitions; whole applier Plan before writes, declared paths only, actual Git authorship; approve refuses unless`; if so record Already Applied when its Git blob is 9db1313856d1dfb345e1f0ce4cc1b83b08a70ebc, and otherwise stop and report. Otherwise make exactly this one edit (land this exact frozen WS-046 candidate output), each matched once, and change nothing else:

   a) replace the line
   ```text
   | `Invoke-ContractStage.ps1 -Config <x>.psd1 -Stage approve\|implement\|review\|complete\|bind` | bounded native transport: exact selected Draft/filter identity, native Boot and normal hooks before transitions; whole applier Plan before writes, declared paths only, actual Git authorship. Native gates remain authority. |
   ```
   with
   ```text
   | `Invoke-ContractStage.ps1 -Config <x>.psd1 -Stage approve\|implement\|review\|complete\|bind` | bounded native transport: exact selected Draft/filter identity, native Boot and normal hooks before transitions; whole applier Plan before writes, declared paths only, actual Git authorship; approve refuses unless `SandboxConsistency` (the sandbox's native consistency log) shows nothing beyond RECOVER-1 and the `ConsistencyAccepted` lines. Native gates remain authority. |
   ```

   The resulting file's Git blob is 9db1313856d1dfb345e1f0ce4cc1b83b08a70ebc.

5. Check whether `lib/test-native-stage.ps1` contains `# Native repository-consistency logs: RECOVER-1 alone (lawful in a sandbox for an undeployed target), and RECOVER-1 whose`; if so record Already Applied when its Git blob is dc44345dfee6ec3a46c7bdcb489a11ed3e67c805, and otherwise stop and report. Otherwise make exactly these 7 edits (land this exact frozen WS-046 candidate output), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   [void][IO.Directory]::CreateDirectory($tempRoot)
   ```
   insert
   ```text
   # Native repository-consistency logs: RECOVER-1 alone (lawful in a sandbox for an undeployed target), and RECOVER-1 whose
   # sub-count equals the total while STALE-1 is a second issue (SPEC-323 r2 and SPEC-327 were approved over such a log).
   $ledger="  Primary ledger evidence is ABSENT, STALE or DISAGREES -- see above."
   $cleanLog=Join-Path $tempRoot 'consistency-clean.log';[IO.File]::WriteAllText($cleanLog,"RECOVER-1: FAILED (2 issue(s))`r`n$ledger`r`nREPOSITORY CONSISTENCY: 1 issue(s) found`r`n")
   $staleLine='STALE FRESHNESS METADATA: plan.md declares 2026-11-21 but line 9 carries 2026-11-22'
   $staleLog=Join-Path $tempRoot 'consistency-stale.log';[IO.File]::WriteAllText($staleLog,"RECOVER-1: FAILED (2 issue(s))`r`n$ledger`r`n$staleLine`r`nREPOSITORY CONSISTENCY: 2 issue(s) found`r`n")
   ```

   b) replace the line
   ```text
       [IO.File]::WriteAllText($createdFixture.Config,"@{Root='$($createdFixture.Root)';Main='$main';Id='SPEC-1';Slug='probe';Draft='$($createdFixture.Draft)';Sha='$((Get-FileHash -LiteralPath $createdFixture.Draft).Hash)';Blob='$blob';User='Stage Fixture';Suffix='toy only';ApprovalNote='synthetic only'}")
   ```
   with
   ```text
       [IO.File]::WriteAllText($createdFixture.Config,"@{Root='$($createdFixture.Root)';Main='$main';Id='SPEC-1';Slug='probe';Draft='$($createdFixture.Draft)';Sha='$((Get-FileHash -LiteralPath $createdFixture.Draft).Hash)';Blob='$blob';User='Stage Fixture';Suffix='toy only';ApprovalNote='synthetic only';SandboxConsistency='$cleanLog'}")
   ```

   c) replace the line
   ```text
       [IO.File]::WriteAllText($f.Config,"@{Root='$root';Main='$top';Id='SPEC-1';Slug='probe';Draft='$($f.Draft)';Sha='$((Get-FileHash -LiteralPath $f.Draft).Hash)';Blob='$blob';User='Stage Fixture';Suffix='toy only';ApprovalNote='synthetic only'}")
   ```
   with
   ```text
       [IO.File]::WriteAllText($f.Config,"@{Root='$root';Main='$top';Id='SPEC-1';Slug='probe';Draft='$($f.Draft)';Sha='$((Get-FileHash -LiteralPath $f.Draft).Hash)';Blob='$blob';User='Stage Fixture';Suffix='toy only';ApprovalNote='synthetic only';SandboxConsistency='$cleanLog'}")
   ```

   d) replace the line
   ```text
           if($evidence-eq'NOT APPLICABLE'){[IO.File]::WriteAllText($approval.Config,[IO.File]::ReadAllText($approval.Config).Replace("ApprovalNote='synthetic only'}","ApprovalNote='synthetic only';HoldNote='Toy hold stays.'}"))}
   ```
   with
   ```text
           if($evidence-eq'NOT APPLICABLE'){[IO.File]::WriteAllText($approval.Config,[IO.File]::ReadAllText($approval.Config).Replace("ApprovalNote='synthetic only';","ApprovalNote='synthetic only';HoldNote='Toy hold stays.';"))}
   ```

   e) immediately after the lines
   ```text
           Assert-Stage "approval entry carries the configured HoldNote only ($evidence)" ($approvedText.Contains('before this transition.')-and$held-eq($evidence-eq'NOT APPLICABLE')-and!$approvedText.Contains('ON HOLD'))
       }
   ```
   insert
   ```text
       function Set-ConsistencyKey($Fixture,[string]$Value){[IO.File]::WriteAllText($Fixture.Config,[IO.File]::ReadAllText($Fixture.Config).Replace("SandboxConsistency='$cleanLog'",$Value));$Fixture.Head=@(Read-StageGit $Fixture.Root @('rev-parse','HEAD'))[0]}
       $staleFixture=New-ApprovalFixture 'approval-stale' 'PASS';Set-ConsistencyKey $staleFixture "SandboxConsistency='$staleLog'";$blocked=Invoke-StageFixture $staleFixture -Stage approve
       Assert-Stage 'a sandbox consistency issue beyond RECOVER-1 refuses approval before allocation' ($blocked.Exit-ne0-and$blocked.Output-match'SANDBOX_CONSISTENCY_NOT_CLEAN extra=1'-and$blocked.Head-ceq$staleFixture.Head-and!(Test-Path (Join-Path $staleFixture.Root 'changes/SPEC-1-probe.md'))) $blocked.Output
       $noLog=New-ApprovalFixture 'approval-nolog' 'PASS';Set-ConsistencyKey $noLog '';$blocked=Invoke-StageFixture $noLog -Stage approve
       Assert-Stage 'approval without a sandbox consistency log refuses before allocation' ($blocked.Exit-ne0-and$blocked.Output-match'SANDBOX_CONSISTENCY_LOG_REQUIRED'-and$blocked.Head-ceq$noLog.Head) $blocked.Output
       $named=New-ApprovalFixture 'approval-named' 'PASS';Set-ConsistencyKey $named "SandboxConsistency='$staleLog';ConsistencyAccepted=@('$staleLine')";$accepted=Invoke-StageFixture $named -Stage approve
       Assert-Stage 'an issue line the Draft names verbatim is accepted' ($accepted.Exit-eq0-and$accepted.Output-match'1 named line') $accepted.Output
       $absent=New-ApprovalFixture 'approval-absent-line' 'PASS';Set-ConsistencyKey $absent "SandboxConsistency='$staleLog';ConsistencyAccepted=@('STALE FRESHNESS METADATA: other.md')";$blocked=Invoke-StageFixture $absent -Stage approve
       Assert-Stage 'a named line absent from the log refuses' ($blocked.Exit-ne0-and$blocked.Output-match'CONSISTENCY_ACCEPTED_LINE_ABSENT'-and$blocked.Head-ceq$absent.Head) $blocked.Output
   ```

   f) replace the line
   ```text
       [IO.File]::WriteAllText($swapped.Config,"@{Root='$($swapped.Root)';Main='$($swappedConfig.Main)';Id='SPEC-1';Slug='probe';Draft='$($swapped.Draft)';Sha='$((Get-FileHash -LiteralPath $swapped.Draft).Hash)';Blob='$swappedBlob';User='Stage Fixture';Suffix='toy only';ApprovalNote='synthetic only'}")
   ```
   with
   ```text
       [IO.File]::WriteAllText($swapped.Config,"@{Root='$($swapped.Root)';Main='$($swappedConfig.Main)';Id='SPEC-1';Slug='probe';Draft='$($swapped.Draft)';Sha='$((Get-FileHash -LiteralPath $swapped.Draft).Hash)';Blob='$swappedBlob';User='Stage Fixture';Suffix='toy only';ApprovalNote='synthetic only';SandboxConsistency='$cleanLog'}")
   ```

   g) immediately after the line
   ```text
       Assert-Stage 'causal removal of allocation binding allows the exact unallocated revision to execute' ($bad.Exit-eq0-and$bad.FileExists-and$bad.Head-cne$swapped.Head)
   ```
   insert
   ```text
       $body=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Invoke-ContractStage.ps1'));$needle='if($extra-gt0){throw "SANDBOX_CONSISTENCY_NOT_CLEAN extra=$extra"}'
       if(!$body.Contains($needle)){throw 'STAGE_CONSISTENCY_MUTANT_ANCHOR'};[IO.File]::WriteAllText($path,$body.Replace($needle,''))
       $mutantStale=New-ApprovalFixture 'approval-stale-mutant' 'PASS';Set-ConsistencyKey $mutantStale "SandboxConsistency='$staleLog'";$bad=Invoke-StageFixture $mutantStale -Library $mutantLib -Stage approve
       Assert-Stage 'causal removal of the consistency guard approves over a missed STALE-1 (the SPEC-327 repeat)' ($bad.Exit-eq0-and$bad.Head-cne$mutantStale.Head) $bad.Output
   ```

   The resulting file's Git blob is dc44345dfee6ec3a46c7bdcb489a11ed3e67c805.

## Acceptance Criteria

- [x] Output `changes/README.md` equals its declared resulting Git blob. check: blob:changes/README.md=dc771efef1dc0be8d388851d4774dda1dbb09226
- [x] Output `lib/Invoke-ContractStage.ps1` equals its declared resulting Git blob. check: blob:lib/Invoke-ContractStage.ps1=eeb8538634620b49b74e30cf3cf8a78b524df299
- [x] Output `lib/lifecycle.ps1` equals its declared resulting Git blob. check: blob:lib/lifecycle.ps1=1cc952623cd8e0d2f0665cd5dd3f341dd875eaf5
- [x] Output `lib/README.md` equals its declared resulting Git blob. check: blob:lib/README.md=9db1313856d1dfb345e1f0ce4cc1b83b08a70ebc
- [x] Output `lib/test-native-stage.ps1` equals its declared resulting Git blob. check: blob:lib/test-native-stage.ps1=dc44345dfee6ec3a46c7bdcb489a11ed3e67c805
- [x] RESUME routing is unchanged after native pointer normalization only. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [x] AC-01 Guard: lib/lifecycle.ps1 gains only Get-ConsistencyExtra with its comment (numstat 14/1: one 13-line hunk after Set-ManifestLine, and the final line of the file unchanged except for the final newline the baseline lacked, which the Draft adds with its own explicit edit of the last two lines): it reads the log's final "REPOSITORY CONSISTENCY:" verdict line, bare or with the Run-Timed "[+ n min] " prefix, as the total; it allows one issue when the RECOVER-1 ledger line "  Primary ledger evidence is ABSENT, STALE or DISAGREES" is present and one for each ConsistencyAccepted line found verbatim; it throws CONSISTENCY_LOG_UNREADABLE without a verdict and CONSISTENCY_ACCEPTED_LINE_ABSENT for a named line the log lacks; it never compares a sub-count. On the replay it reads recorded batch6 logs as the native lifecycle wrote them: exit-bundle-c\spec327\runtime\sandbox-step6-consistency.log gives 1 extra (the SPEC-327 repeat), and exit-bundle-b\spec326\runtime\sandbox-step9-consistency.log, exit-bundle-a\r3\runtime\sandbox-step7-consistency.log and the Run-Timed-prefixed entry1-task-creation\r2\runtime\original-predeploy-consistency.log give 0, a probe the Draft check runs. lib/Invoke-ContractStage.ps1 changes only its header (the two config keys) and the approve stage (numstat 7/1): right after DRAFT_BLOB_MISMATCH and before the fetch and allocation it throws SANDBOX_CONSISTENCY_LOG_REQUIRED without a readable SandboxConsistency file and SANDBOX_CONSISTENCY_NOT_CLEAN when Get-ConsistencyExtra returns above zero, and says the log's SHA256 when it passes; every other stage and check keeps its bytes and order.
- [x] AC-02 Tests and documentation: lib/test-native-stage.ps1 (23/4) writes a clean RECOVER-1 log and a stale log whose RECOVER-1 sub-count equals the total while STALE-1 is a second issue, gives every fixture config SandboxConsistency on the clean log, and adds exactly five cases: "a sandbox consistency issue beyond RECOVER-1 refuses approval before allocation", "approval without a sandbox consistency log refuses before allocation", "an issue line the Draft names verbatim is accepted", "a named line absent from the log refuses" and "causal removal of the consistency guard approves over a missed STALE-1 (the SPEC-327 repeat)"; no existing case is removed. lib/README.md changes only the Invoke-ContractStage row to name the refusal (1/1). Two production mutants on the replay must each make test-native-stage fail with its first FAIL line the stale case: GUARDOFF (the approve refusal line removed from Invoke-ContractStage.ps1) and SUBCOUNT (Get-ConsistencyExtra subtracting the RECOVER-1 sub-count instead of the allowed count, the SPEC-327 misreading); the Draft check must kill both and restore the bytes.
- [x] AC-03 Organizer: changes/README.md is what lib/Organize.ps1 -Refresh writes: it holds the WS-046 row, and a refresh of the replay with this contract in place changes no organizer.
- [x] AC-04 Secrets and privacy: gitleaks on the exact candidate range reports no finding in the 5 outputs and RESUME.md; on this contract every finding, if any, is a Git object ID or SHA256 digest that the Draft pins or the native lifecycle writes into its Execution Log, each listed; neither masked value (the computer name, a marketing tunnel script name) nor the owner's e-mail is in any changed file or in this contract.
- [x] AC-05 Native completion, for the current role only: qualify the actual V3 with immutable V1 and V2 identities, allocate and approve natively for this role and root, apply every step, one watched Finish under DEC-23 and DEC-24 with one row per run in data/records/WS-033/measurements.tsv (failures too), and a live review of its own receipt and criteria; the owning tests test-native-stage, test-lifecycle-failclosed, test-contract-lifecycle and test-markdown-consistency run in the Finish. Original additionally needs the exact successful sandbox proof and its own approval. Never rerun a Finish that has operation.json. From each Finish launch to END: no Events -Add, Save-State or edit in a protected root, and Docker off.
- [x] AC-06 Boundary: the seven legacy folders, the vault step3 folder and the restore staging equal their record in data/records/WS-046/evidence/protected-before.json, captured before the sandbox Finish and again after Original Complete with data/records/WS-038/Capture-Protected.ps1; lib/Invoke-ContractLifecycle.ps1, lib/Test-WorkbenchChange.ps1, lib/apply-draft-steps.ps1, lib/Workbench.ps1 and every batch6 SPEC config are unchanged; both roles ran the Original's controller whose SHA256 this Draft names; the user settings are unchanged; CRM, ORVION and their trusted copies keep their HEAD and files (the lifecycle's protected-root compare); no Supabase project is touched; no Codex, subagent, RAM, power setting or scheduled task change; no push before both roles are Complete.

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
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-046\assurance\V3\DRAFT.md
Approved SHA256: B202D261FF1242AA78E0918C240F78C49FA339E1E943CBE69D1EF8A68D285B7A
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench\data\records\WS-046\gate\GATE1-WS046-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: 83E1E23CCEBCA5989B8A5C19A0D0B7D0A8D2D9D5365B8B494D7B2D0CE2AFA85D
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W46\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 6099F0133AFFD49A4D630ECB3A11F12D4D2CC3C7CC3D4281C77EC2F0463AF4A3
Original exact declared outputs applied by accepted native Execute; fresh own Finish and Review/Complete remain required. Other protected roots unchanged. Controller: the Original's own lib/Invoke-ContractLifecycle.ps1 (SHA256 AD768116), unchanged by this contract and used by both roles, checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority.
Residual risks carried unchanged from the selected Draft Review Gate and data/records/WS-046/CONTRACT.md; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (D120, frozen in data/records/WS-034/owner-words), not by unavailability. Controller: the Original's own lib/Invoke-ContractLifecycle.ps1 (SHA256 AD768116), unchanged by this contract and used by both roles, checked by Run-Stage before each stage; the judge and native Workbench.ps1 keep every authority. Release is a later stage (DEC-25), after Original Complete and the retro.

## Verification Notes

V3 preparation; authorship: Claude main, claude-opus-5-5, effort high, under DEC-13, from the frozen uncommitted candidate in C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W46-c2 (data/records/WS-046/Make-Candidate.ps1). Nothing in this Draft marks a criterion passed. No Gate, Finish, Review, Complete or release has run in this preparation. Draft-time proof is in claude-draft-check.json beside this Draft. After Complete, outside this contract: the release under DEC-25 on the DELEGATED record, only when every gate passed and Claude main's retro is satisfied; the protected state is compared with its record from before; SPEC-328's approve config carries SandboxConsistency; Save-State records the result.
Verdict: Confirmed Complete
Reviewed Fingerprint: 98A63F4ABB1A1384F34AC0DD89C4A4C5FDC22F436F78378A3158AB15BD0A3E82
Reviewed Receipt: F520AE5BD0BD9F3681239D2FDF31D355AC17B0BEC61A6EC1D5A49060BD0FB51E
Live ORIGINAL-role review: runtime/original/criterion-review.json. Own Finish 32 ordered suites, runner/watcher/host 0/0/0, real journal unchanged. Review: ONE Claude-main SELF-REVIEW, not independent; Codex SKIPPED by owner decision 2026-11-08 ~01:20 Cairo (D120, frozen in data/records/WS-034/owner-words), not by unavailability. Exact completed sandbox proof B2351DE2D990BD7589C8EB425E953ACDC5FFB3F8E37814FAF41BDB724290B3EC bound. Not pushed; the one release (DEC-25) follows only on every gate passed and the retro, under spec327-DELEGATED-CANCEL rule 12 and run mode 2 (DELEGATED).

