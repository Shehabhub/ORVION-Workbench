# Workbench Change Request - WS-028

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Record integrity in the existing Hunt (D36, audit PLAN item 4): a C2 hound that fails any declared decision supersession not named on both sides, and an opt-in C1 deletion/placement readiness check with typed LIVE/HISTORICAL/HARMLESS edges, every match, manifest identity, protection and INCOMPLETE coverage, proven by real FAIL and PASS tests including the audit's eleven regression cases. Readiness only: nothing is deleted, moved or authorized.

Intended contract: changes/WS-028-record-integrity.md. Preparation leaves Active Workbench Contract: None; native allocation, status and pointer transitions remain native-owned.

## Baseline

7a4d476a1861fc3f3683e59b27c40eb370973f25

## Write Scope

- RESUME.md
- lib/Hunt.ps1
- lib/test-hunt.ps1
- lib/README.md

## Out of Scope

All other engineering paths, products, credentials, sessions, events, real deletion/relocation, the real C1 clearance run and its inputs/manifest (Final Stop Packet), Save-Continuity repair, semantic conflict judging, new frameworks/registries/services, remote/settings/security changes. The private decision-record heading back-pointers (records/WS-028/package/decision-backpointers) are owner data maintained outside this repository, not an engineering output.

## Draft Assurance

V1: WS028-V1-CLAUDE-DESIGN-20261030-01 | 2026-10-30 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-028\package\assurance\V1\DRAFT.md | 2BE7A63B0910D497764149131669B7B00FF737563A87909E42DCD45322B5FAAF
V2: WS028-V2-CLAUDE-ADVERSARIAL-20261030-01 | 2026-10-30 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-028\package\assurance\V2\DRAFT.md | BEA20AC53C314D9698C8EA119022EECA86046E3CDAB37993D0BAD7A6C800C716
V3: WS028-V7-CLAUDE-MAIN-CORRECTIVE-20261031-01 | 2026-10-31 | C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-028\package\assurance\V7\DRAFT.md | SELECTED
Selected Version: V3

The native evaluator has exactly three assurance slots; its third (selected) slot carries this V7 corrective successor, authored by Claude main under owner decision D84 (one V7, with a stop rule). Frozen V3 (assurance\V3\DRAFT.md SHA256 03D7B5B9CCA0E600FF4D6C9CB8701CE3430B200CC543E686E84788278CE34B72), V4 (95A4F99ED04D27A09E155BD85064526E4ED65DD10D113A588D36AE8A9DF378AD), V5 (2DFA03DC45D8CB029E435D65FB15CD15919755DEBFE33D53CC31947C34C4EF07) and V6 (assurance\V6\DRAFT.md SHA256 63FEDE31739C1B55E78551E265E15111C68ECF8FAFF19B025708BF7FD01AC779) were each reviewed REVISE (v3-v6-review REVIEW.json: R1, R1b, R1c, R1d, one truncated-path root cause). Under owner D85 (temporary: no subagents) the ONE review of this frozen V7 is a Claude-main self-review, labelled as such and not claimed independent; no provider diversity or second review is claimed.

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W28\sb
Tests Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W28\t
Temp Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\sb\W28\tmp
Runtime Root: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-028\package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Preparation Environment

Operational buffer: 5 GB physical / 8 GB commit before any own Finish. Preparation checks use the portable 7.6.8 executable in the disposable clone; the native context admission owns actual observations. own Finish runs Hunt Quick NoRecord against the checkout's data root (or an empty disposable store when none is beside it) and fails on any BUG, so the real decision record must be paired before an original Finish.

## Implementation Steps

1. Check whether `lib/Hunt.ps1` contains `function Test-DeletionReadiness`; if so record Already Applied when its Git blob is 7cd66cabef46a3147f31c17cb65e06cd335603dd, and otherwise stop and report. Otherwise make exactly these 10 edits (add the C2 decision back-pointer hound and the opt-in C1 deletion-readiness check), each matched once, and change nothing else:

   a) replace the line
   ```text
   # last result for Pulse. Read-only except that log, the events log and temp folders.
   ```
   with
   ```text
   # last result for Pulse. Read-only except that log, the events log, temp folders and, with -DeletionReadiness, its
   # report work\deletion-readiness.json.
   ```

   b) replace the line
   ```text
   #               evidence paths exist; lessons whose raw session is not archived
   ```
   with
   ```text
   #               evidence paths exist; lessons whose raw session is not archived; every declared decision
   #               supersession is named on both sides (C2: declared links only, no script judges meaning)
   #   readiness   opt-in -DeletionReadiness <inputs.json>: C1 deletion/placement readiness (see Test-DeletionReadiness)
   ```

   c) replace the line
   ```text
   # -NoRecord suppresses events only; work\hunt-last.txt is still written in the data root.
   ```
   with
   ```text
   # -NoRecord suppresses events only; work\hunt-last.txt (and any C1 report) is still written in the data root.
   ```

   d) replace the line
   ```text
   param([string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quick,[switch]$NoRecord,[object[]]$MutantSet,[string]$DataRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'}),[scriptblock]$GetMapTask={Get-ScheduledTask -TaskName 'ORVION Repository Map' -ErrorAction Stop | Get-ScheduledTaskInfo -ErrorAction Stop})  # test seams
   ```
   with
   ```text
   param([string]$Root=(Split-Path $PSScriptRoot -Parent),[switch]$Quick,[switch]$NoRecord,[object[]]$MutantSet,[string]$DecisionsPath,[string]$DeletionReadiness,[string]$DataRoot=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) -Parent) 'ORVION-Owner-Tools'}),[scriptblock]$GetMapTask={Get-ScheduledTask -TaskName 'ORVION Repository Map' -ErrorAction Stop | Get-ScheduledTaskInfo -ErrorAction Stop})  # test seams
   ```

   e) immediately after the line
   ```text
   $orphan=@(if(!$indexIncomplete){$events|Where-Object{$_.session-and$_.session-notlike'hunter-*'-and!$ids[$_.session]-and$_.session-notin$lost}|ForEach-Object session|Select-Object -Unique})
   ```
   insert
   ```text
   # C2: "Dn supersedes/amends/reopens Dm" and "Dm ... superseded/amended/revised/reopened ... by Dn" each need both
   # sections to name the other. A missing record is a GAP; an unreadable one is a BUG, never a clean result.
   # Owned here, so a caller's variables of the same name (an in-process & invocation) never reach the closure guard.
   $decisions=@{};$c1=$null
   if(!$DecisionsPath){$DecisionsPath=Join-Path $DataRoot 'records\delegation-20261026\DECISIONS.md'}
   if(!(Test-Path -LiteralPath $DecisionsPath -PathType Leaf)){Add-Finding GAP decision-record-missing "no decision record at $DecisionsPath`: supersession back-pointers unchecked" 'decision record missing supersession'}
   else{try{
       $decisions=@{};foreach($m in [regex]::Matches([IO.File]::ReadAllText($DecisionsPath),'(?ms)^## (D\d+)\b.*?(?=^## D\d+\b|\z)')){$decisions[$m.Groups[1].Value]+=$m.Value}
       if(!$decisions.Count){throw 'no decision headings'}
       $unpaired=@(@(foreach($n in $decisions.Keys){
           foreach($m in [regex]::Matches($decisions[$n],'(?i)(?<!\bD\d+\s)\b(?:supersedes|amends|reopens)\s+(D\d+)\b')){$o=$m.Groups[1].Value;if(!$decisions.ContainsKey($o)-or$decisions[$o]-notmatch"\b$n\b"){"$n->$o"}}
           foreach($m in [regex]::Matches($decisions[$n],'(?i)\b(?:superseded|amended|revised|reopened)\b[^.;()\r\n]{0,60}?\bby\s+(D\d+)')){$o=$m.Groups[1].Value;if(!$decisions.ContainsKey($o)-or$decisions[$o]-notmatch"\b$n\b"){"$o->$n"}}
       })|Sort-Object -Unique)
       if($unpaired){Add-Finding BUG decision-backpointer "$($unpaired.Count) declared supersession(s) not named on both sides (newer->older): $($unpaired-join', ')" 'decision supersession back-pointer'}
   }catch{Add-Finding BUG decision-record-unreadable "decision record $DecisionsPath unreadable: $($_.Exception.Message)" 'decision record unreadable'}}
   ```

   f) immediately after the lines
   ```text
       }else{Add-Finding GAP lint-unavailable 'PSScriptAnalyzer is not installed: Install-Module PSScriptAnalyzer -Scope CurrentUser' 'lint static analysis'}
   }

   ```
   insert
   ```text
   # C1 deletion/placement readiness (records/audit-20261027/codex-place/AUDIT-ANSWER.md rules 1-9; rule 2 resolves only
   # absolute and Documents-relative spellings and rule 6's ambiguous current reader is not judged). Reports only: it never
   # deletes, moves or authorizes. Inputs (schema 1, every path fully qualified): deletionRoots, temporaryRoot, profileRoot,
   # live[] and historical[] (files or directories; every line, every match; a junction or symlink inside is never followed
   # and is INCOMPLETE), manifest (TSV OriginalPath,RecordPath,Bytes,SHA256; RecordPath may be relative to the manifest's
   # folder), protected[] (roots whose copies carry
   # package/cloud protection evidence), harmless[{source,line,target,reason}], acceptedBreaks[{target,decision}].
   # PASS needs zero FAIL edges and complete coverage; anything unread is INCOMPLETE.
   function Test-DeletionReadiness([string]$InputsPath){
       $edges=[Collections.Generic.List[object]]::new();$incomplete=[Collections.Generic.List[string]]::new()
       function Get-Full([string]$p){[IO.Path]::GetFullPath($p).TrimEnd('\')}
       function Test-Under([string]$p,[string]$r){$p-ieq$r-or$p.StartsWith($r+'\',[StringComparison]::OrdinalIgnoreCase)}
       try{$spec=Get-Content -LiteralPath $InputsPath -Raw -ErrorAction Stop|ConvertFrom-Json
           if($spec.schema-ne1-or!@($spec.deletionRoots).Count-or!$spec.temporaryRoot-or!$spec.profileRoot){throw 'schema 1 with deletionRoots, temporaryRoot, profileRoot required'}
           $roots=@($spec.deletionRoots|ForEach-Object{Get-Full $_});$temp=Get-Full $spec.temporaryRoot;$userProfile=Get-Full $spec.profileRoot
           # A relative path has no known base (rule 2): a relative root would silently match nothing.
           if(@(@($spec.deletionRoots)+$spec.temporaryRoot+$spec.profileRoot+@($spec.protected)+@($spec.live)+@($spec.historical)+@($spec.manifest)+@($spec.harmless|ForEach-Object source)+@($spec.acceptedBreaks|ForEach-Object target)|Where-Object{$_-and![IO.Path]::IsPathFullyQualified($_)}).Count){throw 'every input path must be fully qualified'}
           $protected=@($spec.protected|Where-Object{$_}|ForEach-Object{Get-Full $_})
           # A harmless declaration exempts one target on one source line, never every hit on that line.
           $harmless=@{};foreach($h in @($spec.harmless|Where-Object{$_})){if(!$h.reason){throw 'harmless entry without reason'};$harmless["$((Get-Full $h.source).ToUpperInvariant())|$($h.line)|$((Get-Full $h.target).ToUpperInvariant())"]=$h.reason}
           $breaks=@{};foreach($b in @($spec.acceptedBreaks|Where-Object{$_})){if(!$b.decision){throw 'accepted break without decision pointer'};$breaks[(Get-Full $b.target).ToUpperInvariant()]=$b.decision}
       }catch{return [pscustomobject]@{outcome='INCOMPLETE';edges=@();incomplete=@("inputs ${InputsPath}: $($_.Exception.Message)")}}
       $manifest=@{}
       if($spec.manifest){try{foreach($row in [IO.File]::ReadAllLines($spec.manifest)){
           if(!$row.Trim()-or$row-like'OriginalPath*'){continue};$c=$row-split"`t"
           if($c.Count-ne4-or$c[3]-cnotmatch'^[A-F0-9]{64}$'-or![IO.Path]::IsPathFullyQualified($c[0])-or!$c[1]){throw "malformed row: $row"}
           # A relative RecordPath has one known base, the manifest's folder; every row of an original listed twice is checked.
           $manifest[(Get-Full $c[0]).ToUpperInvariant()]+=@([pscustomobject]@{original=Get-Full $c[0];record=[IO.Path]::GetFullPath($c[1],[IO.Path]::GetDirectoryName($spec.manifest)).TrimEnd('\');bytes=[long]$c[2];sha256=$c[3]})
       }}catch{$incomplete.Add("manifest $($spec.manifest): $($_.Exception.Message)")}}
       # Anchors: each absolute root plus Documents-relative spellings of roots under the profile's Documents.
       $anchors=@(foreach($r in @($roots)+$temp){$r;$d=Join-Path $userProfile 'Documents';if(Test-Under $r $d){$r.Substring($d.Length-'Documents'.Length)}})
       function Add-Edge($Source,$Line,$Role,$Target,$Result,$Reason){$edges.Add([pscustomobject]@{source=$Source;line=$Line;role=$Role;target=$Target;result=$Result;reason=$Reason})}
       function Test-Copy($Source,$Line,$Role,$Target){
           $rows=@($manifest.Values|ForEach-Object{$_}|Where-Object{Test-Under $_.original $Target})
           if(!$rows){
               if((Test-Under $Target $temp)-and(Test-Path -LiteralPath $Target)){Add-Edge $Source $Line $Role $Target FAIL 'exists under temporary, but required evidence has no protected copy (permanence)'}
               else{Add-Edge $Source $Line $Role $Target FAIL 'no manifest identity for required evidence'};return}
           foreach($row in $rows){
               $why=$null
               if(@($roots+$temp|Where-Object{Test-Under $row.record $_}).Count){$why='copy lies inside a deletion/temporary root (protection)'}
               elseif(!(Test-Path -LiteralPath $row.record -PathType Leaf)){$why='manifest copy missing'}
               elseif((Get-Item -LiteralPath $row.record).Length-ne$row.bytes-or(Get-FileHash -LiteralPath $row.record).Hash-cne$row.sha256){$why='manifest copy bytes/SHA256 differ'}
               elseif((Test-Path -LiteralPath $row.original -PathType Leaf)-and(Get-FileHash -LiteralPath $row.original).Hash-cne$row.sha256){$why='original differs from its supposedly identical copy'}
               elseif(!@($protected|Where-Object{Test-Under $row.record $_}).Count){$why='copy has no protection evidence (protection)'}
               if($why){Add-Edge $Source $Line $Role $row.original FAIL $why}else{Add-Edge $Source $Line $Role $row.original PASS "protected copy $($row.record) $($row.sha256)"}
           }
           # A junction or symlink inside a cited directory is never followed and is an omission, as for declared inputs.
           if((Test-Path -LiteralPath $Target -PathType Container)){foreach($f in Get-ChildItem -LiteralPath $Target -Recurse -Force){if($f.LinkType-in'Junction','SymbolicLink'){$incomplete.Add("$Role ${Source}:$Line cited $($f.FullName): $($f.LinkType) to $($f.LinkTarget) not followed")}elseif(!$f.PSIsContainer-and!$manifest.ContainsKey((Get-Full $f.FullName).ToUpperInvariant())){Add-Edge $Source $Line $Role $f.FullName FAIL 'file in cited directory has no manifest identity'}}}
       }
       foreach($group in @(@('LIVE',$spec.live),@('HISTORICAL',$spec.historical))){
           $role=$group[0]
           foreach($entry in @($group[1]|Where-Object{$_})){
               $files=try{if(Test-Path -LiteralPath $entry -PathType Container){$items=@(Get-ChildItem -LiteralPath $entry -Recurse -Force -ErrorAction Stop)
                       # Recursion does not enter a junction or symlink: each one is an omission, never silently complete.
                       foreach($link in @($items|Where-Object LinkType -in 'Junction','SymbolicLink')){$incomplete.Add("$role input $($link.FullName): $($link.LinkType) to $($link.LinkTarget) not followed")}
                       @($items|Where-Object{!$_.PSIsContainer-and$_.LinkType-notin'Junction','SymbolicLink'}|ForEach-Object FullName)}elseif(Test-Path -LiteralPath $entry -PathType Leaf){@($entry)}else{throw 'missing'}}catch{$incomplete.Add("$role input ${entry}: $($_.Exception.Message)");continue}
               foreach($file in $files){
                   $source=Get-Full $file
                   try{$lines=[IO.File]::ReadAllLines($source)}catch{$incomplete.Add("$role input ${source}: unreadable");continue}
                   for($i=0;$i-lt$lines.Count;$i++){
                       # JSON escapes (also nested ones), slashes, file:/// and \\?\ prefixes, MSYS //c/ drives and
                       # $env:USERPROFILE/${env:USERPROFILE}/$HOME/$env:HOME/${HOME}/%USERPROFILE%/~ spellings.
                       $text=$lines[$i].Replace('/','\')-replace'\\{2,}','\'-replace'(?i)\bfile:\\+(?=[a-z]:)|\\+\?\\(?=[a-z]:)',''-replace'(?<=^|[\s"''(=,;\[])\\{1,2}([A-Za-z])(?=\\)','$1:'-replace'(?i)\$\{?env:USERPROFILE\}?|%USERPROFILE%|\$\{?(?:env:)?HOME\b\}?|(?<![\w~])~(?=\\)',$userProfile.Replace('$','$$')
                       foreach($anchor in $anchors){
                           foreach($m in [regex]::Matches($text,'(?i)(?<![\w\\])'+[regex]::Escape($anchor)+'(?![\w-])(?:\\[^"''`<>|*?\s,;)\]]*)?')){
                               $raw=$m.Value.TrimEnd('.','\');try{$target=if([IO.Path]::IsPathFullyQualified($raw)){Get-Full $raw}else{Get-Full (Join-Path $userProfile $raw)}}catch{$incomplete.Add("$role ${source}:$($i+1) unparsable path $raw");continue}
                               $key="$($source.ToUpperInvariant())|$($i+1)|$($target.ToUpperInvariant())"
                               if($harmless.ContainsKey($key)){Add-Edge $source ($i+1) $role $target PASS "HARMLESS: $($harmless[$key])";continue}
                               # The match ends at the first stop character; every stop character except " < > | * ? (which no
                               # file name holds) may still belong to the cited name, so the class is closed by construction:
                               # after any run of them (any Unicode whitespace , ; ' ) ] backtick), INCOMPLETE, never a PASS or
                               # FAIL for the shortened prefix, when the next token is path-like (\ or .ext) or an existing
                               # sibling is named "<leaf><run><next>...". Checked before the target-only accepted-break lookup,
                               # so a break on a prefix never exempts a longer cited path (only a line-keyed HARMLESS does).
                               try{$cut=[regex]::Match($text.Substring($m.Index+$m.Length),'^([\s,;'')\]`]+)([^"''`<>|*?\s,;)\]]*)');$sep=$cut.Groups[1].Value;$next=$cut.Groups[2].Value
                                   $space=$sep-match'^ +$';$sibling="$(Split-Path $target -Leaf)$sep$next*"
                                   $continues=$cut.Success-and(!$space-or$next)-and($next-match'\\|\.\w+$'-or[bool](Get-ChildItem -LiteralPath (Split-Path $target) -Filter $sibling -Force -ErrorAction Ignore))}catch{$incomplete.Add("$role ${source}:$($i+1) $target unreadable: $($_.Exception.Message)");continue}
                               if($continues){$incomplete.Add("$role ${source}:$($i+1) $(if($space){'path continues after a space'}else{"path may continue after '$sep'"}): $target$sep$next");continue}
                               if($breaks.ContainsKey($target.ToUpperInvariant())){Add-Edge $source ($i+1) $role $target PASS "accepted break: $($breaks[$target.ToUpperInvariant()])";continue}
                               if($role-eq'LIVE'){Add-Edge $source ($i+1) $role $target FAIL $(if(Test-Under $target $temp){'live dependency left under temporary'}else{'live read/write/binding into a deletion root'})}
                               else{try{Test-Copy $source ($i+1) $role $target}catch{$incomplete.Add("$role ${source}:$($i+1) $target unreadable: $($_.Exception.Message)")}}
                           }
                       }
                   }
                   # A live recovery-input map's selected targets must exist with their approved digests (an item without
                   # one FAILs); a live JSON that cannot be parsed or hashed is unread, not a clean map.
                   if($role-eq'LIVE'-and$source-like'*.json'){try{$map=Get-Content -LiteralPath $source -Raw|ConvertFrom-Json
                       foreach($item in @($map.inputs|Where-Object{$_.path})){
                           if(!$item.sha256-or![IO.Path]::IsPathFullyQualified($item.path)-or!(Test-Path -LiteralPath $item.path -PathType Leaf)-or(Get-FileHash -LiteralPath $item.path).Hash-cne$item.sha256){Add-Edge $source 0 LIVE (Get-Full $item.path) FAIL 'selected recovery input absent, hash-changed or without an approved digest'}}
                   }catch{$incomplete.Add("LIVE input ${source}: JSON unparsable or map input unreadable")}}
               }
           }
       }
       $fails=@($edges|Where-Object result -eq FAIL)
       [pscustomobject]@{outcome=$(if($incomplete.Count){'INCOMPLETE'}elseif($fails.Count){'FAIL'}else{'PASS'});edges=@($edges);incomplete=@($incomplete)}
   }
   $readinessLine=$null
   if($DeletionReadiness){
       $c1=Test-DeletionReadiness $DeletionReadiness;$report=Join-Path $DataRoot 'work\deletion-readiness.json'
       New-Item -ItemType Directory (Join-Path $DataRoot 'work') -Force|Out-Null
       [ordered]@{schema=1;at=[DateTime]::UtcNow.ToString('o');inputs=$DeletionReadiness;outcome=$c1.outcome;incomplete=$c1.incomplete;edges=$c1.edges}|ConvertTo-Json -Depth 5|Set-Content -LiteralPath $report -Encoding utf8NoBOM
       $failCount=@($c1.edges|Where-Object result -eq FAIL).Count
       if($c1.outcome-eq'PASS'){$readinessLine="C1 PASS: $(@($c1.edges).Count) edge(s), zero unresolved, coverage complete; report $report (readiness only, never deletion authority)"}
       else{Add-Finding BUG "c1-$($c1.outcome.ToLower())" "C1 $($c1.outcome): $failCount failing edge(s), $(@($c1.incomplete).Count) unread input(s); report $report" 'deletion readiness c1 placement'}
   }
   ```

   g) replace the line
   ```text
   $summary;$findings|ForEach-Object{"  $($_.kind) $($_.hound): $($_.text)"}
   ```
   with
   ```text
   $summary;if($readinessLine){"  $readinessLine"};$findings|ForEach-Object{"  $($_.kind) $($_.hound): $($_.text)"}
   ```

   h) replace the line
   ```text
   [IO.File]::WriteAllLines((Join-Path $DataRoot 'work\hunt-last.txt'),[string[]](@($summary)+@($findings|ForEach-Object{"  $($_.kind) $($_.hound): $($_.text)"})))
   ```
   with
   ```text
   [IO.File]::WriteAllLines((Join-Path $DataRoot 'work\hunt-last.txt'),[string[]](@($summary)+@($readinessLine|Where-Object{$_}|ForEach-Object{"  $_"})+@($findings|ForEach-Object{"  $($_.kind) $($_.hound): $($_.text)"})))
   ```

   i) replace the line
   ```text
       # A hound that no longer finds what it reported closes its own finding; hounds -Quick skipped cannot judge.
   ```
   with
   ```text
       # A hound that no longer finds what it reported closes its own finding; hounds -Quick skipped cannot judge, nor can
       # C2 without readable decisions or C1 that did not run (no -DeletionReadiness) or was INCOMPLETE.
   ```

   j) immediately after the line
   ```text
           if($indexIncomplete-and$g.Name-match'^hunt-(index-|lesson-raw-missing$)'){continue}
   ```
   insert
   ```text
           if(($g.Name-eq'hunt-decision-backpointer'-and!$decisions.Count)-or($g.Name-like'hunt-c1-*'-and$c1.outcome-notin'PASS','FAIL')){continue}
   ```

   The resulting file's Git blob is 7cd66cabef46a3147f31c17cb65e06cd335603dd.

2. Check whether `lib/test-hunt.ps1` contains `C1 case 11: declared pinned disposable tool in temporary PASSes`; if so record Already Applied when its Git blob is 4c03954b8db6684fabcc7c66ac41331f94f01c3e, and otherwise stop and report. Otherwise make exactly these 5 edits (preserve every existing assertion and add the C2 and eleven C1 regression cases), each matched once, and change nothing else:

   a) replace the line
   ```text
   param([switch]$RootProbeOnly,[switch]$EvidenceProbeOnly,[switch]$IndexProbeOnly)
   ```
   with
   ```text
   param([switch]$RootProbeOnly,[switch]$EvidenceProbeOnly,[switch]$IndexProbeOnly,[switch]$RecordProbeOnly)
   ```

   b) immediately after the lines
   ```text
   $fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
   try{
   ```
   insert
   ```text
       if(!$RootProbeOnly-and!$EvidenceProbeOnly-and!$IndexProbeOnly){
           # Record integrity: C2 decision back-pointers and the C1 audit's eleven real regression cases, on synthetic roots.
           $store=Join-Path $t 'record-probe';foreach($part in 'sessions','events','work','records'){[void][IO.Directory]::CreateDirectory((Join-Path $store $part))}
           $recordLauncher=Join-Path $t 'record-probe.ps1'
           [IO.File]::WriteAllText($recordLauncher,@'
   param([string]$Hunt,[string]$Store,[string]$Decisions,[string]$Readiness)
   function Get-Process { @() }
   function Get-CimInstance { @() }
   $extra=@{};if($Decisions){$extra.DecisionsPath=$Decisions};if($Readiness){$extra.DeletionReadiness=$Readiness}
   & $Hunt -Root $Store -DataRoot $Store -Quick -NoRecord @extra
   exit $LASTEXITCODE
   '@)
           function Invoke-RecordHunt([string]$Decisions,[string]$Readiness){$o=@(& pwsh -NoProfile -File $recordLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $store -Decisions $Decisions -Readiness $Readiness 2>&1)-join"`n";[pscustomobject]@{code=$LASTEXITCODE;out=$o}}
           $decisionFile=Join-Path $store 'records\DECISIONS.md'
           [IO.File]::WriteAllText($decisionFile,@'
   ## D5 2026-10-26 Key custody
   Encrypted package keys held by the owner.
   ## D10 2026-10-26 Owner revised recovery: no encryption
   OWNER-DIRECTIVE supersedes D5 key custody.
   ## D29 2026-10-27 Step 2 (sequence "CRM first" amended by D30)
   ## D30 2026-10-27 Step 2 concurrent (amends D29's sequence only)
   ## D32 2026-10-27 Codex input (web-search exclusion superseded by D33)
   ## D33 2026-10-27 Governed upgrade (reopens D32's exclusion)
   Supersedes D32's "NOT authorized" only for this path. F1 D33 supersedes D31's author allocation.
   '@)
           $c2=Invoke-RecordHunt $decisionFile
           Assert-That 'C2 reports the historical D10->D5 missing back-pointer as a BUG' ($c2.code-eq1-and$c2.out-match'(?m)BUG decision-backpointer: 1 declared supersession\(s\) not named on both sides \(newer->older\): D10->D5\r?$')
           Assert-That 'C2 passes paired D29/D30 and D32/D33 and ignores a link stated about another decision' ($c2.out-notmatch'D30->D29|D33->D32|D33->D31')
           $paired=[IO.File]::ReadAllText($decisionFile).Replace('## D5 2026-10-26 Key custody','## D5 2026-10-26 Key custody (superseded by D10)')
           [IO.File]::WriteAllText($decisionFile,$paired)
           Assert-That 'C2 is silent once both sides name the supersession' ((Invoke-RecordHunt $decisionFile).out-notmatch'decision-')
           # A back link declared only by the older decision (real phrasing) fails until the newer section names it.
           [IO.File]::AppendAllText($decisionFile,"`n## D37 2026-10-28 WS-029 first (deletion-required acceptance superseded for the WS-029 V3 successor by D43)`n## D39 2026-10-28 Maximum effort (level revised to xhigh by D41)`n## D41 2026-10-28 Effort revised: xhigh for D39 work`n## D43 2026-10-28 WS-029 Candidate C approved`n")
           Assert-That 'C2 reports a back link named only by the older decision; "revised to xhigh by D41" with D41 naming D39 is paired' ((Invoke-RecordHunt $decisionFile).out-match'(?m)BUG decision-backpointer: 1 declared supersession\(s\) not named on both sides \(newer->older\): D43->D37\r?$')
           $lock=[IO.File]::Open($decisionFile,'Open','ReadWrite','None')
           try{$c2Locked=Invoke-RecordHunt $decisionFile}finally{$lock.Dispose()}
           Assert-That 'C2 unreadable decision record is a BUG, never green' ($c2Locked.code-eq1-and$c2Locked.out-match'BUG decision-record-unreadable')
           Assert-That 'C2 absent decision record is reported as a GAP' ((Invoke-RecordHunt (Join-Path $store 'records\absent.md')).out-match'GAP decision-record-missing')
           # C1: synthetic profile with deletion roots, temporary root, canonical data root and protected records.
           $userHome=Join-Path $t 'c1 home';$docs=Join-Path $userHome 'Documents'
           $sandbox=Join-Path $docs 'ORVION-Sandbox';$review=Join-Path $docs 'ORVION-Owner-Review';$temporary=Join-Path $docs 'GitHub\ORVION-Workbench-temporary'
           $data=Join-Path $docs 'GitHub\ORVION-Owner-Tools';$records=Join-Path $data 'records';$scan=Join-Path $t 'c1 scan'
           foreach($d in $sandbox,$review,$temporary,$records,$scan,(Join-Path $review 'contract-a'),(Join-Path $sandbox 'calendar'),(Join-Path $review 'packet-2'),(Join-Path $temporary 'run'),(Join-Path $temporary 'tools'),(Join-Path $review 'ws1\runtime'),(Join-Path $review 'ws2\runtime')){[void][IO.Directory]::CreateDirectory($d)}
           function New-C1File([string]$Path,[string]$Text){[IO.File]::WriteAllText($Path,$Text);$Path}
           $proof=New-C1File (Join-Path $records 'proof.json') 'approved proof'
           $contractA=New-C1File (Join-Path $review 'contract-a\OWNER-APPROVAL.md') 'contract A approval'
           $calendar=New-C1File (Join-Path $sandbox 'calendar\baseline-linux.log') 'calendar log'
           $calendarCopy=New-C1File (Join-Path $review 'packet-2\baseline-linux.log') 'calendar log'
           $tempEvidence=New-C1File (Join-Path $temporary 'run\finish.log') 'finish log'
           $actionlint=New-C1File (Join-Path $temporary 'tools\actionlint.exe') 'binary'
           $receiptLog=New-C1File (Join-Path $review 'ws1\runtime\finish.log') 'ws1 finish'
           $receiptLogCopy=New-C1File (Join-Path $records 'ws1-finish.log') 'ws1 finish'
           $r1=New-C1File (Join-Path $review 'ws1\own-finish-receipt.json') 'receipt one'
           $r2=New-C1File (Join-Path $review 'ws2\own-finish-receipt.json') 'receipt two'
           $r1Copy=New-C1File (Join-Path $records 'ws1-own-finish-receipt.json') 'receipt one'
           $r2Copy=New-C1File (Join-Path $records 'ws2-own-finish-receipt.json') 'receipt two'
           $delegation=New-C1File (Join-Path $review 'OWNER-DELEGATION.md') 'delegation'
           $delegationCopy=New-C1File (Join-Path $records 'OWNER-DELEGATION.md') 'delegation'
           # Case 1: line 7 repaired, line 12 still reads the Sandbox (the first-match scan's blind spot).
           $save=New-C1File (Join-Path $scan 'Save-Continuity.ps1') (((1..14|ForEach-Object{"# line $_"})-join"`n").Replace('# line 7',"`$a='$records\continuity'").Replace('# line 12',"`$b='$sandbox\prototype-1'"))
           # Case 2: the selected recovery-input map still targets Owner-Review.
           # A selected input outside every root whose digest changed can only be caught by the map check itself.
           $changed=New-C1File (Join-Path $records 'changed.json') 'changed after approval'
           $map=New-C1File (Join-Path $scan 'recovery-inputs.json') (@{schema=1;inputs=@(@{name='proof';path=$proof;sha256=(Get-FileHash $proof).Hash},@{name='old';path=(Join-Path $review 'old-proof.json');sha256=('A'*64)},@{name='changed';path=$changed;sha256=('B'*64)})}|ConvertTo-Json -Depth 4)
           # Case 11: a pinned tool in temporary with a tested rebuild contract, declared disposable.
           $tools=New-C1File (Join-Path $scan 'tools.json') ('{"actionlint":"'+$actionlint.Replace('\','\\')+'"}')
           # Cases 3-6, 8-10: required historical citations.
           $history=New-C1File (Join-Path $scan 'history.md') ("Contract A: $contractA`ncalendar: $calendar`nreceipt one: $r1`nreceipt two: $r2`ndelegation: $delegation`nrelative: Documents\ORVION-Owner-Review\OWNER-DELEGATION.md")
           $events=New-C1File (Join-Path $scan 'events.jsonl') ('{"pattern":"row159","evidence":"'+$tempEvidence.Replace('\','\\')+'"}'+"`n"+'{"pattern":"row4","evidence":"'+(Join-Path $review 'missing-run.log').Replace('\','\\')+'"}')
           $receipt=New-C1File (Join-Path $scan 'own-finish-receipt.json') ("{`n  `"root`": `"$($sandbox.Replace('\','\\'))\\s`",`n  `"runLog`": `"$($receiptLog.Replace('\','\\'))`"`n}")
           # Case 7: an old-path test fixture is harmless, but neither a second path on its line nor a later operational hit is.
           $fixture=New-C1File (Join-Path $scan 'test-markdown-consistency.ps1') ("# fixture $sandbox\lib\old.ps1; Copy-Item $sandbox\lib\live.ps1 .`n`$live='$sandbox\lib'")
           # Live bindings spelled as MSYS //c/ (as in Claude settings) or through profile tokens must not hide.
           $settings=New-C1File (Join-Path $scan 'settings.json') ('{"permissions":{"allow":["Read(//'+$sandbox.Substring(0,1).ToLower()+$sandbox.Substring(2).Replace('\','/')+'/lib/**)"]}}')
           $profileSpelled=New-C1File (Join-Path $scan 'profile-spelled.ps1') ("`$a=`"`$env:USERPROFILE\Documents\ORVION-Sandbox\lib`"`n`$b=`"`$HOME/Documents/ORVION-Owner-Review/x`"")
           $manifest=New-C1File (Join-Path $scan 'MANIFEST.tsv') ((@("OriginalPath`tRecordPath`tBytes`tSHA256")+@(foreach($pair in @(@($calendar,$calendarCopy),@($receiptLog,$receiptLogCopy),@($r1,$r1Copy),@($r2,$r2Copy),@($delegation,$delegationCopy))){"$($pair[0])`t$($pair[1])`t$((Get-Item $pair[1]).Length)`t$((Get-FileHash $pair[1]).Hash)"}))-join"`n")
           $inputs=@{schema=1;deletionRoots=@($sandbox,$review);temporaryRoot=$temporary;profileRoot=$userHome;live=@($save,$map,$tools,$fixture,$settings,$profileSpelled);historical=@($history,$events,$receipt);manifest=$manifest;protected=@($records)
               harmless=@(@{source=$fixture;line=1;target="$sandbox\lib\old.ps1";reason='old-path test fixture'},@{source=$receipt;line=2;target="$sandbox\s";reason='provenance root'},@{source=$tools;line=1;target=$actionlint;reason='pinned disposable tool with tested rebuild/hash contract'});acceptedBreaks=@()}
           $inputsFile=Join-Path $scan 'inputs.json';$inputs|ConvertTo-Json -Depth 5|Set-Content $inputsFile
           $c1=Invoke-RecordHunt '' $inputsFile;$c1Report=Get-Content (Join-Path $store 'work\deletion-readiness.json') -Raw|ConvertFrom-Json
           function Get-C1Edge([string]$Source,[int]$Line,[string]$Target){,@($c1Report.edges|Where-Object{$_.source-eq$Source-and$_.line-eq$Line-and(!$Target-or$_.target-eq$Target)})}
           Assert-That 'C1 case 1: repaired line 7 is no edge, line 12 still reading the Sandbox FAILs LIVE' (!(Get-C1Edge $save 7)-and(Get-C1Edge $save 12)[0].result-eq'FAIL'-and(Get-C1Edge $save 12)[0].role-eq'LIVE')
           Assert-That 'C1 case 2: selected map target under Owner-Review FAILs LIVE although the proof input passes' (@($c1Report.edges|Where-Object{$_.source-eq$map-and$_.result-eq'FAIL'-and$_.target-like'*old-proof.json'}).Count-ge1-and!@($c1Report.edges|Where-Object{$_.source-eq$map-and$_.target-eq$proof}).Count)
           Assert-That 'C1 a selected map input outside every root FAILs when its digest changed' ((Get-C1Edge $map 0 $changed)[0].result-eq'FAIL')
           Assert-That 'C1 case 3: Contract A approval without manifest identity FAILs HISTORICAL' ((Get-C1Edge $history 1)[0].result-eq'FAIL'-and(Get-C1Edge $history 1)[0].reason-match'no manifest identity')
           Assert-That 'C1 case 4: copy kept only inside another deleting packet FAILs protection despite equal hash' ((Get-C1Edge $history 2)[0].result-eq'FAIL'-and(Get-C1Edge $history 2)[0].reason-match'inside a deletion/temporary root \(protection\)')
           Assert-That 'C1 case 5: required evidence existing under temporary FAILs permanence' ((Get-C1Edge $events 1)[0].result-eq'FAIL'-and(Get-C1Edge $events 1)[0].reason-match'permanence')
           Assert-That 'C1 case 6: absent historical run log without copy/break FAILs HISTORICAL' ((Get-C1Edge $events 2)[0].result-eq'FAIL'-and(Get-C1Edge $events 2)[0].reason-match'no manifest identity')
           Assert-That 'C1 case 7: declared old-path fixture PASSes HARMLESS; its later operational hit FAILs' ((Get-C1Edge $fixture 1)[0].result-eq'PASS'-and(Get-C1Edge $fixture 2)[0].result-eq'FAIL')
           Assert-That 'C1 a second path on a HARMLESS line is not exempt' ((Get-C1Edge $fixture 1 "$sandbox\lib\live.ps1")[0].result-eq'FAIL')
           Assert-That 'C1 MSYS //c/ and profile-token spellings of deletion roots FAIL LIVE' ((Get-C1Edge $settings 1)[0].result-eq'FAIL'-and(Get-C1Edge $profileSpelled 1)[0].result-eq'FAIL'-and(Get-C1Edge $profileSpelled 2)[0].result-eq'FAIL')
           Assert-That 'C1 case 8: provenance root PASSes, preserved run log PASSes without the whole sandbox' ((Get-C1Edge $receipt 2)[0].result-eq'PASS'-and(Get-C1Edge $receipt 3)[0].result-eq'PASS')
           Assert-That 'C1 case 9: same-named receipts keep separate identities' ((Get-C1Edge $history 3)[0].result-eq'PASS'-and(Get-C1Edge $history 4)[0].result-eq'PASS'-and(Get-C1Edge $history 3)[0].reason-ne(Get-C1Edge $history 4)[0].reason)
           Assert-That 'C1 case 10: equal source/copy SHA256 PASSes identity, also via Documents-relative spelling' ((Get-C1Edge $history 5)[0].result-eq'PASS'-and(Get-C1Edge $history 6)[0].result-eq'PASS')
           Assert-That 'C1 case 11: declared pinned disposable tool in temporary PASSes' ((Get-C1Edge $tools 1)[0].result-eq'PASS')
           Assert-That 'C1 FAIL is a BUG with exit 1 and a full report' ($c1.code-eq1-and$c1.out-match'BUG c1-fail: '-and$c1Report.outcome-eq'FAIL')
           [IO.File]::WriteAllText((Join-Path $records 'ws2-own-finish-receipt.json'),'receipt one');[IO.File]::WriteAllText($r1,'receipt ONE')
           $c1=Invoke-RecordHunt '' $inputsFile;$c1Report=Get-Content (Join-Path $store 'work\deletion-readiness.json') -Raw|ConvertFrom-Json
           Assert-That 'C1 a mismatched supposedly identical copy FAILs' ((Get-C1Edge $history 4)[0].result-eq'FAIL'-and(Get-C1Edge $history 4)[0].reason-match'differ')
           Assert-That 'C1 an original that differs from its supposedly identical copy FAILs' ((Get-C1Edge $history 3)[0].result-eq'FAIL'-and(Get-C1Edge $history 3)[0].reason-match'original differs')
           $linked=Join-Path $scan 'linked';[void][IO.Directory]::CreateDirectory($linked);$null=New-Item -ItemType Junction -Path (Join-Path $linked 'review') -Target $review
           $inputs.historical+=Join-Path $scan 'absent.md';$inputs.live+=$linked;$inputs|ConvertTo-Json -Depth 5|Set-Content $inputsFile
           $copyLock=[IO.File]::Open($receiptLogCopy,'Open','ReadWrite','None')
           try{$c1=Invoke-RecordHunt '' $inputsFile}finally{$copyLock.Dispose();[IO.Directory]::Delete((Join-Path $linked 'review'))}
           $c1Report=Get-Content (Join-Path $store 'work\deletion-readiness.json') -Raw|ConvertFrom-Json
           Assert-That 'C1 an unread declared input is INCOMPLETE and blocks clearance' ($c1.code-eq1-and$c1.out-match'BUG c1-incomplete: ')
           Assert-That 'C1 a junction is never followed and a locked copy is unread: both INCOMPLETE in the written report' (@($c1Report.incomplete|Where-Object{$_-match'Junction to .+ not followed'}).Count-eq1-and@($c1Report.incomplete|Where-Object{$_.Contains($receiptLogCopy)}).Count-ge1)
           $clean=@{schema=1;deletionRoots=@($sandbox,$review);temporaryRoot=$temporary;profileRoot=$userHome;live=@($tools);historical=@($receipt);manifest=$manifest;protected=@($records);harmless=$inputs.harmless}
           $clean|ConvertTo-Json -Depth 5|Set-Content $inputsFile
           $c1=Invoke-RecordHunt '' $inputsFile
           Assert-That 'C1 PASS needs zero unresolved edges and prints an explicit readiness-only line' ($c1.code-eq0-and$c1.out-match'C1 PASS: 3 edge\(s\), zero unresolved'-and$c1.out-notmatch'c1-')
           $clean.deletionRoots=@('Documents\ORVION-Sandbox');$clean|ConvertTo-Json -Depth 5|Set-Content $inputsFile
           $c1=Invoke-RecordHunt '' $inputsFile
           Assert-That 'C1 a relative root has no known base: INCOMPLETE, never a silent PASS' ($c1.code-eq1-and$c1.out-match'BUG c1-incomplete: ')
           # Real records\MANIFEST.tsv rows are records-relative and name some originals twice; a cited directory may hold a link.
           $approval=New-C1File (Join-Path $review 'ws2\runtime\approval.txt') 'approval';$null=New-C1File (Join-Path $records 'approval-bad.txt') 'APPROVAL';$null=New-C1File (Join-Path $records 'approval-good.txt') 'approval'
           $unprotected=New-C1File (Join-Path $review 'ws2\runtime\unprotected.txt') 'unprotected';$unprotectedCopy=New-C1File (Join-Path $scan 'unprotected-copy.txt') 'unprotected'
           $relativeManifest=New-C1File (Join-Path $records 'MANIFEST.tsv') ("OriginalPath`tRecordPath`tBytes`tSHA256`n$receiptLog`tws1-finish.log`t$((Get-Item $receiptLogCopy).Length)`t$((Get-FileHash $receiptLogCopy).Hash)`n$approval`tapproval-bad.txt`t8`t$((Get-FileHash $approval).Hash)`n$approval`tapproval-good.txt`t8`t$((Get-FileHash $approval).Hash)`n$unprotected`t$unprotectedCopy`t$((Get-Item $unprotectedCopy).Length)`t$((Get-FileHash $unprotectedCopy).Hash)")
           $citing=New-C1File (Join-Path $scan 'history-cited.md') "run log: $receiptLog`nruntime: $(Join-Path $review 'ws1\runtime')`napproval: $approval`nunprotected: $unprotected"
           # The same target harmless on line 1 is still an operational hit on line 2 (harmless is keyed by line).
           $sameTarget=New-C1File (Join-Path $scan 'fixture-same-target.ps1') ("# fixture $sandbox\lib\same.ps1`n& $sandbox\lib\same.ps1")
           @{schema=1;deletionRoots=@($sandbox,$review);temporaryRoot=$temporary;profileRoot=$userHome;live=@($sameTarget);historical=@($citing);manifest=$relativeManifest;protected=@($records)
               harmless=@(@{source=$sameTarget;line=1;target="$sandbox\lib\same.ps1";reason='old-path test fixture'})}|ConvertTo-Json -Depth 5|Set-Content $inputsFile
           $citedLink=Join-Path $review 'ws1\runtime\link';$null=New-Item -ItemType Junction -Path $citedLink -Target $sandbox
           try{$c1=Invoke-RecordHunt '' $inputsFile}finally{[IO.Directory]::Delete($citedLink)}
           $c1Report=Get-Content (Join-Path $store 'work\deletion-readiness.json') -Raw|ConvertFrom-Json;$twice=Get-C1Edge $citing 3
           Assert-That 'C1 a relative RecordPath resolves against the manifest folder, never the caller' ((Get-C1Edge $citing 1)[0].result-eq'PASS'-and(Get-C1Edge $citing 1)[0].reason-like"protected copy $receiptLogCopy *")
           Assert-That 'C1 every row of an original listed twice is verified: a mismatched first copy FAILs' (@($twice|Where-Object{$_.result-eq'FAIL'-and$_.reason-match'differ'}).Count-eq1-and@($twice|Where-Object result -eq PASS).Count-eq1)
           Assert-That 'C1 a junction inside a cited historical directory is INCOMPLETE, never followed' ($c1.code-eq1-and$c1Report.outcome-eq'INCOMPLETE'-and@($c1Report.incomplete|Where-Object{$_-match'cited .+ Junction to .+ not followed'}).Count-eq1)
           Assert-That 'C1 a verified copy outside every root but under no protected root FAILs protection' ((Get-C1Edge $citing 4)[0].result-eq'FAIL'-and(Get-C1Edge $citing 4)[0].reason-match'no protection evidence')
           Assert-That 'C1 a HARMLESS line does not exempt the same target on a later line' ((Get-C1Edge $sameTarget 1)[0].result-eq'PASS'-and(Get-C1Edge $sameTarget 2)[0].result-eq'FAIL')
           # A cited path that goes on after a space (its preserved prefix must not PASS), a map input without a digest, and
           # file:///, \\?\, $env:HOME, ${HOME} spellings: V3 printed C1 PASS for exactly this set.
           foreach($d in (Join-Path $review 'ws3'),(Join-Path $review 'ws3 runtime')){[void][IO.Directory]::CreateDirectory($d)}
           $kept=New-C1File (Join-Path $review 'ws3\a.log') 'kept';$keptCopy=New-C1File (Join-Path $records 'ws3-a.log') 'kept';$null=New-C1File (Join-Path $review 'ws3 runtime\finish.log') 'unpreserved'
           # The review's case, then one line per signal: a token with \, a token with an extension, an existing sibling.
           $spaced=New-C1File (Join-Path $scan 'history-spaced.md') "run log: $review\ws3 runtime\finish.log`nold: $review\ws3 gone\finish`ncopy: $review\ws3\a.log copy.log`nruntime: $review\ws3 runtime"
           $undigested=New-C1File (Join-Path $scan 'recovery-undigested.json') (@{schema=1;inputs=@(@{name='gone';path=(Join-Path $records 'gone.json')})}|ConvertTo-Json -Depth 4)
           $spelled=New-C1File (Join-Path $scan 'spelled.ps1') ("`$a='file:///$($sandbox.Replace('\','/'))/lib'`n& '\\?\$sandbox\lib\run.ps1'`n`$b=`"`$env:HOME\Documents\ORVION-Sandbox\lib`"`n`$c=`"`${HOME}\Documents\ORVION-Sandbox\lib`"")
           $keptManifest=New-C1File (Join-Path $scan 'MANIFEST-kept.tsv') "OriginalPath`tRecordPath`tBytes`tSHA256`n$kept`t$keptCopy`t4`t$((Get-FileHash $keptCopy).Hash)"
           @{schema=1;deletionRoots=@($sandbox,$review);temporaryRoot=$temporary;profileRoot=$userHome;live=@($undigested,$spelled);historical=@($spaced);manifest=$keptManifest;protected=@($records)}|ConvertTo-Json -Depth 5|Set-Content $inputsFile
           $c1=Invoke-RecordHunt '' $inputsFile;$c1Report=Get-Content (Join-Path $store 'work\deletion-readiness.json') -Raw|ConvertFrom-Json
           Assert-That 'C1 a cited path that goes on after a space is INCOMPLETE, never a PASS for its preserved prefix' ($c1.code-eq1-and@(1..4|Where-Object{$n=$_;@($c1Report.incomplete|Where-Object{$_.Contains("${spaced}:$n path continues after a space")}).Count-eq1-and!(Get-C1Edge $spaced $n).Count}).Count-eq4)
           Assert-That 'C1 a selected map input without an approved digest FAILs' ((Get-C1Edge $undigested 0)[0].result-eq'FAIL')
           Assert-That 'C1 file:///, \\?\, $env:HOME and ${HOME} spellings of deletion roots FAIL LIVE' (@(1..4|Where-Object{(Get-C1Edge $spelled $_)[0].result-eq'FAIL'}).Count-eq4)
           # A match also ends at , ; ' ) ] and backtick, all legal in file names: V4 printed C1 PASS for lines 1-6 below.
           # Line 7 is ordinary prose punctuation (still a PASS); line 8 cites a directory whose other files lack identity.
           foreach($d in 'ws5','ws5,old',"ws5's run"){[void][IO.Directory]::CreateDirectory((Join-Path $review $d))}
           $kept5=New-C1File (Join-Path $review 'ws5\a.log') 'kept5';$kept5Copy=New-C1File (Join-Path $records 'ws5-a.log') 'kept5'
           foreach($f in 'ws5,old\finish.log',"ws5's run\finish.log",'ws5\a.log]v','ws5\a.log`bak'){$null=New-C1File (Join-Path $review $f) 'unpreserved'}
           $cutAt=New-C1File (Join-Path $scan 'history-cut.md') ("old: $review\ws5,old\finish.log`ngone: $review\ws5;gone\finish.log`nrun: $review\ws5's run\finish.log`nparen: $review\ws5)gone\finish.log`nrcs: $review\ws5\a.log]v`nbak: $review\ws5\a.log``bak`nsee $review\ws5\a.log, and (also $review\ws5\a.log).`ndir: $review\ws5")
           $nested=New-C1File (Join-Path $scan 'nested.json') ('{"cmd":"{\"p\":\"'+$sandbox.Replace('\','\\\\')+'\\\\lib\"}"}')
           $broken=New-C1File (Join-Path $scan 'broken.ps1') "& $sandbox\lib\broken.ps1"
           $cutManifest=New-C1File (Join-Path $scan 'MANIFEST-cut.tsv') "OriginalPath`tRecordPath`tBytes`tSHA256`n$kept5`t$kept5Copy`t5`t$((Get-FileHash $kept5Copy).Hash)"
           # Any other run of stop characters a name may hold: Unicode whitespace, or a space then ' or , (V5 printed C1 PASS).
           $nbsp=[string][char]0x00A0;$ideo=[string][char]0x3000
           foreach($d in "ws5${nbsp}old","ws5${ideo}old","ws5 'old'",'ws5 ,old'){[void][IO.Directory]::CreateDirectory((Join-Path $review $d));$null=New-C1File (Join-Path $review "$d\finish.log") 'unpreserved'};$null=New-C1File (Join-Path $review "ws5\a.log${nbsp}v") 'unpreserved'
           $cutRun=New-C1File (Join-Path $scan 'history-cut-run.md') ("a: $review\ws5${nbsp}old\finish.log`nb: $review\ws5${ideo}old\finish.log`nc: $review\ws5\a.log${nbsp}v`nd: $review\ws5 'old'\finish.log`ne: $review\ws5 ,old\finish.log")
           # A target-only accepted break on a prefix never exempts a longer cited path (V6 printed C1 PASS for lines 1-2).
           foreach($f in 'tools (v2)\run.ps1','tools,v2\run.ps1'){$null=New-C1File (New-Item -ItemType Directory -Force (Split-Path (Join-Path $sandbox $f))|ForEach-Object{Join-Path $sandbox $f}) 'live'}
           $breakPrefix=New-C1File (Join-Path $scan 'break-prefix.ps1') ("& '$sandbox\tools (v2)\run.ps1'`n& $sandbox\tools,v2\run.ps1`n& $sandbox\tools")
           $cutInputs=@{schema=1;deletionRoots=@($sandbox,$review);temporaryRoot=$temporary;profileRoot=$userHome;live=@($nested,$broken,$breakPrefix);historical=@($cutAt,$cutRun);manifest=$cutManifest;protected=@($records);acceptedBreaks=@(@{target="$sandbox\lib\broken.ps1";decision='D80'},@{target="$sandbox\tools";decision='D84'})}
           $cutInputs|ConvertTo-Json -Depth 5|Set-Content $inputsFile
           $c1=Invoke-RecordHunt '' $inputsFile;$c1Report=Get-Content (Join-Path $store 'work\deletion-readiness.json') -Raw|ConvertFrom-Json
           Assert-That 'C1 a cited path that may go on after , ; '' ) ] or backtick is INCOMPLETE, never a PASS for its preserved prefix' ($c1.code-eq1-and@(1..6|Where-Object{$n=$_;@($c1Report.incomplete|Where-Object{$_.Contains("${cutAt}:$n path may continue after ")}).Count-eq1-and!(Get-C1Edge $cutAt $n).Count}).Count-eq6)
           Assert-That 'C1 a cited path that may go on after any run of Unicode whitespace or a space then '' or , is INCOMPLETE' (@(1..5|Where-Object{$n=$_;@($c1Report.incomplete|Where-Object{$_.Contains("${cutRun}:$n path may continue after ")}).Count-eq1-and!(Get-C1Edge $cutRun $n).Count}).Count-eq5)
           Assert-That 'C1 an accepted break on a prefix never exempts a longer cited path; the exact target still PASSes' (@(1..2|Where-Object{$n=$_;@($c1Report.incomplete|Where-Object{$_.StartsWith("LIVE ${breakPrefix}:$n path ")-and$_-match' path (continues|may continue) after '}).Count-eq1-and!(Get-C1Edge $breakPrefix $n).Count}).Count-eq2-and(Get-C1Edge $breakPrefix 3)[0].reason-eq'accepted break: D84')
           Assert-That 'C1 ordinary punctuation after a preserved path still PASSes' (@((Get-C1Edge $cutAt 7)|Where-Object result -eq PASS).Count-eq2-and!@($c1Report.incomplete|Where-Object{$_.Contains("${cutAt}:7 ")}).Count)
           Assert-That 'C1 a file in a cited directory without manifest identity FAILs' ((Get-C1Edge $cutAt 8 (Join-Path $review 'ws5\a.log]v'))[0].reason-eq'file in cited directory has no manifest identity')
           Assert-That 'C1 a nested-JSON spelling of a deletion root FAILs LIVE' ((Get-C1Edge $nested 1)[0].result-eq'FAIL')
           Assert-That 'C1 an accepted break with a decision pointer PASSes its LIVE edge' ((Get-C1Edge $broken 1)[0].result-eq'PASS'-and(Get-C1Edge $broken 1)[0].reason-eq'accepted break: D80')
           # Otherwise clean (only the break's LIVE edge), so the missing decision pointer alone makes it INCOMPLETE.
           $cutInputs.historical=@();$cutInputs.live=@($broken);$cutInputs.acceptedBreaks=@(@{target="$sandbox\lib\broken.ps1"});$cutInputs|ConvertTo-Json -Depth 5|Set-Content $inputsFile
           $c1=Invoke-RecordHunt '' $inputsFile;$c1Report=Get-Content (Join-Path $store 'work\deletion-readiness.json') -Raw|ConvertFrom-Json
           Assert-That 'C1 an accepted break without a decision pointer is INCOMPLETE' ($c1.code-eq1-and$c1.out-match'BUG c1-incomplete: '-and@($c1Report.incomplete|Where-Object{$_-match'accepted break without decision pointer'}).Count-eq1)
           if($RecordProbeOnly){if($fail){throw 'HUNT_RECORD_PROBE_FAILED'};'HUNT_RECORD_PROBE PASS';return}
       }
   ```

   c) immediately after the line
   ```text
       & (Join-Path $PSScriptRoot 'Events.ps1') -Root $t -Add -Pattern hunt-old-problem -Session hunter-2026-01-01 -Category observation -Summary 'GAP: something once found'|Out-Null
   ```
   insert
   ```text
       foreach($pattern in 'hunt-c1-fail','hunt-decision-backpointer'){& (Join-Path $PSScriptRoot 'Events.ps1') -Root $t -Add -Pattern $pattern -Session hunter-2026-01-01 -Category failure -Summary 'BUG: an earlier C1/C2 finding'|Out-Null}
   ```

   d) immediately after the line
   ```text
       Assert-That 'a finding no longer found is closed by the hunter' ($last.status-eq'resolved'-and$last.summary-like'no longer found*')
   ```
   insert
   ```text
       Assert-That 'a Hunt without -DeletionReadiness or a readable decision record leaves C1/C2 findings open' ((@(foreach($pattern in 'hunt-c1-fail','hunt-decision-backpointer'){@($ev|Where-Object pattern -eq $pattern|Sort-Object at)[-1].status})-join',')-ceq'open,open')
   ```

   e) immediately after the line
   ```text
       Assert-That 'current findings are recorded as events' (@($ev|Where-Object{$_.pattern-eq'hunt-index-missing'-and$_.source-eq'hunter'}).Count-eq1)
   ```
   insert
   ```text
       # The guard's other branches: a C1 that ran INCOMPLETE (inputs absent) and an unreadable (headingless) decision record.
       $headingless=Join-Path $t 'headingless.md';[IO.File]::WriteAllText($headingless,'no decision headings')
       $null=& (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $t -DataRoot $t -Quick -DeletionReadiness (Join-Path $t 'absent-inputs.json') -DecisionsPath $headingless
       $ev=@([IO.File]::ReadAllLines((Join-Path $t 'events\events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json})
       Assert-That 'an INCOMPLETE C1 or an unreadable decision record leaves C1/C2 findings open' ((@(foreach($pattern in 'hunt-c1-fail','hunt-decision-backpointer'){@($ev|Where-Object pattern -eq $pattern|Sort-Object at)[-1].status})-join',')-ceq'open,open'-and@($ev|Where-Object pattern -eq 'hunt-c1-incomplete').Count-and@($ev|Where-Object pattern -eq 'hunt-decision-record-unreadable').Count)
   ```

   The resulting file's Git blob is 4c03954b8db6684fabcc7c66ac41331f94f01c3e.

3. Check whether `lib/README.md` contains `or "Dm ... superseded/amended/revised/reopened ... by Dn" must name the other decision in both sections`; if so record Already Applied when its Git blob is 802d98f2e92273bd02703ddf200ee7d83f22944d, and otherwise stop and report. Otherwise make exactly these 2 edits (describe C1/C2 semantics, the Finish consumer and limits), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   Hunt's `-Root` stays this checkout (its source and lint scope).
   ```
   insert
   ```text
   Hunt C2 reads `<data>\records\delegation-20261026\DECISIONS.md` (`-DecisionsPath`): a declared "Dn supersedes/amends/reopens Dm"
   or "Dm ... superseded/amended/revised/reopened ... by Dn" must name the other decision in both sections, else
   `BUG decision-backpointer`; unreadable is `BUG decision-record-unreadable`, absent is `GAP decision-record-missing`.
   Declared links only, in these adjacent forms (`supersedes D39's`, `superseded for X by D43`, within one clause): list or
   prose forms (`Supersedes: D33 ..., D34 ...`) and undeclared semantic conflicts stay residuals. Own Finish runs Hunt
   Quick, so an unpaired real decision blocks Finish until the section that does not yet name the other gains the pointer.
   Hunt C1 (`-DeletionReadiness <inputs.json>`, opt-in) reports deletion/placement readiness only and never deletes or
   authorizes. It scans every line and match of the declared live/historical files or directories for the deletion and
   temporary roots (absolute, JSON-escaped (also nested), slash, `file:///`, `\\?\` and MSYS `//c/` variants, `Documents\...`,
   `$env:USERPROFILE`, `$HOME`, `$env:HOME`, `${HOME}`, `%USERPROFILE%` and `~` against the profile), classifies each edge
   LIVE, HISTORICAL or declared HARMLESS (by source line and target), checks manifest identity (OriginalPath, RecordPath
   absolute or relative to the manifest's folder, bytes, SHA256; every row of an original listed twice), copies outside
   deletion/temporary roots under declared protected roots, accepted breaks and live map digests (a map input without one
   FAILs). A live reference into the temporary root FAILs unless declared HARMLESS or an accepted break. Every edge goes to
   `<data>\work\deletion-readiness.json`; `C1 PASS` needs zero failing edges and no unread input, otherwise `BUG c1-fail`
   or `BUG c1-incomplete` (exit 1). INCOMPLETE also covers a relative input path, a junction or symlink inside a declared
   or cited directory (never followed; a declared or cited path that is itself a link is read through, one level), an
   unparsable live JSON, an unreadable copy and a cited path that may go on past any run of the characters that end a
   match but a file name can hold (any Unicode whitespace, `,` `;` `'` `)` `]` or a backtick; only `"` `<` `>` `|` `*` `?`
   end a path for certain): the next token holds `\` or an extension, or a `<leaf><run><next>...` sibling exists. This
   holds for live and historical lines and is checked before accepted breaks, so a break (keyed by target only) on a
   prefix never exempts a longer cited path. A command line naming a preserved original then its copy is therefore
   INCOMPLETE until declared HARMLESS for that source line and target (which does not re-verify the copy). Only a complete C1 run closes an earlier C1 finding, and it closes it whatever
   inputs produced it. A cited path that goes on past such a run with a plain word and no such sibling (for example,
   already deleted) is still checked as its prefix. Not seen: computed paths (`Join-Path $docs 'ORVION-Sandbox'`), `..\`, 8.3 short names, `\/` and `\u`
   JSON escapes, percent-encoded `file:` URIs and `work\`, repository- or temporary-root-relative spellings; rule 6's
   ambiguous current reader is not judged. The inputs (roots, manifest, protection, harmless and break declarations)
   remain owner-reviewed evidence.
   ```

   b) replace the line
   ```text
   | `Hunt.ps1 [-Quick]` | the hunting dogs: invariants, liveness, versioning, untested tools, planted-bug mutants, lint; every BUG/GAP becomes an event, the last result shows in Pulse |
   ```
   with
   ```text
   | `Hunt.ps1 [-Quick] [-DeletionReadiness <inputs.json>]` | the hunting dogs: invariants (incl. C2 decision back-pointers), liveness, versioning, untested tools, planted-bug mutants, lint, opt-in C1 deletion readiness; every BUG/GAP becomes an event, the last result shows in Pulse |
   ```

   The resulting file's Git blob is 802d98f2e92273bd02703ddf200ee7d83f22944d.

## Acceptance Criteria

- [x] Hunt output equals its declared resulting Git blob. check: blob:lib/Hunt.ps1=7cd66cabef46a3147f31c17cb65e06cd335603dd
- [x] Owning test output equals its declared resulting Git blob. check: blob:lib/test-hunt.ps1=4c03954b8db6684fabcc7c66ac41331f94f01c3e
- [x] Catalogue output equals its declared resulting Git blob. check: blob:lib/README.md=802d98f2e92273bd02703ddf200ee7d83f22944d
- [x] RESUME routing remains identical after only native pointer normalization. check: normalized-resume:RESUME.md=89E9380B5C9884F717AB5505CE53AF02BD4026DCBBDBAA7E2612FEC939C8111A
- [x] Every existing test-hunt assertion is preserved unchanged and the complete lib/test-hunt.ps1 runs inside the actual owning native schedule on the final candidate; no assertion removal, weakening or prior-result reuse.
- [x] C2 real FAIL and PASS: the historical D10->D5 missing back-pointer is a BUG naming D10->D5; paired D29/D30 and D32/D33 and a link stated about another decision (F1 D33 supersedes D31) are not reported; a back link declared only by the older decision (D37 "superseded for the WS-029 V3 successor by D43") is a BUG naming D43->D37 while "revised to xhigh by D41" with D41 naming D39 is paired; a paired record is silent; an unreadable record is BUG decision-record-unreadable, never green; an absent record is GAP decision-record-missing.
- [x] C1 eleven audit regression cases (records/audit-20261027/codex-place/AUDIT-ANSWER.md:256-270) each produce their stated outcome on synthetic roots: Save line 12 Sandbox FAIL LIVE with repaired line 7 no edge; map target under Owner-Review FAIL LIVE; Contract A without manifest FAIL HISTORICAL; copy only inside another deleting packet FAIL protection; temporary evidence FAIL permanence; absent run log FAIL HISTORICAL; declared fixture PASS HARMLESS with a later operational hit in the same file FAIL; provenance root PASS and preserved run log PASS; same-named receipts keep separate identities; equal source/copy SHA256 PASS including the Documents-relative spelling; declared pinned disposable tool PASS. Also a mismatched supposedly identical copy FAILs and an original that differs from its copy FAILs; a selected map input outside every root with a changed digest or without one FAILs; MSYS //c/, file:///, \\?\ and profile-token ($env:USERPROFILE, $HOME, $env:HOME, ${HOME}) spellings of deletion roots FAIL LIVE; neither a second path on a HARMLESS line nor the same target on a later line is exempt; a verified copy under no protected root FAILs protection; every manifest row of an original listed twice is verified (a mismatched first copy FAILs); a relative RecordPath resolves against the manifest's folder, never the caller; an unread declared input, a locked copy, a junction inside a declared or cited directory (never followed), a relative root and a cited path that may go on past any run of characters that end a match but a file name may hold (any Unicode whitespace , ; ' ) ] backtick; next token with \ or an extension, or an existing "<leaf><run><next>" sibling; never a PASS for its preserved prefix, on live and historical lines and before the target-only accepted-break lookup, so a break on a prefix never exempts a longer cited path, while ordinary punctuation after a preserved path still PASSes) are INCOMPLETE (BUG, exit 1); a nested-JSON spelling of a deletion root FAILs LIVE; a file in a cited directory without manifest identity FAILs; an accepted break with a decision pointer PASSes its LIVE edge and one without a decision is INCOMPLETE; and a clean set prints an explicit readiness-only C1 PASS with exit 0. Every edge is in the report JSON.
- [x] Ordinary Hunt without -DeletionReadiness is unchanged except the C2 hound and the closure guard (a Hunt without -DeletionReadiness or with an INCOMPLETE C1 never closes an earlier C1 finding, and one without a readable decision record never closes C2's); existing consumers (own Finish Hunt Quick, Pulse hunt-last) are inspected; disposable/sandbox stores give GAP decision-record-missing only. Before the original Finish the real decision record is paired (four owner-data heading back-pointers with before/after hashes), so Hunt Quick on the real data root has no C2 BUG.
- [x] Admit the sandbox root under the accepted native Gate and this selected Draft; own full Finish with live runner/watch/host evidence and fresh receipt; then a separate original Gate, own original Finish, live Review/Complete and carrying range. No native gate is waived; no unchanged passed expensive check is rerun without a source/failure/concern reason (D77).
- [x] lib/README.md accurately states C1/C2 semantics, the Finish consumer effect and limits: declared links only (semantic conflicts residual), a cited path that may go on past any run of whitespace , ; ' ) ] or backtick is INCOMPLETE only on a path-like next token or an existing sibling (otherwise its prefix is checked), a command line naming an original then its copy is INCOMPLETE until declared, C1 closure is keyed by hound, not by inputs, the unseen spellings and the rule 2/rule 6 gaps, accepted breaks exempting a temporary-root LIVE edge, inputs/manifest/protection/harmless/break declarations are owner-reviewed evidence, readiness never authorizes deletion.

## Review Gate

- [x] Observe the live root, final selected Draft/source/test/docs fingerprints, native receipt, runner/watch coverage and all acceptance evidence for that root.
- [x] ONE fresh independent review of the same frozen selected candidate under owner D77/D79 (Codex bypassed) is complete and recorded; V2/V3/V4 fresh-subagent and V5/V6/V7 Claude-main (owner D80/D82/D84) authorship is labelled; the V7 review is a Claude-main self-review under owner D85, labelled as such and not claimed independent; no second review, provider diversity or agreement table is claimed.
- [x] Remaining risks are explicit: C2 sees declared adjacent links only (list/prose forms such as D39's "Supersedes, for these activities only", excluded vocabulary such as overrides/replaces, merged duplicate headings, a link whose subject is the declaring decision itself, and semantic conflicts stay residual); C1 classification depends on owner-reviewed inputs (inventory completeness, live/historical lists, harmless lines, protected roots, accepted breaks, which also exempt a LIVE edge, including one into the temporary root); rule 2 resolves only absolute and Documents-relative spellings, so computed paths, relative ..\, work\, repository- or temporary-root-relative spellings, 8.3 short names, \/ or \u JSON escapes and percent-encoded file: URIs are not seen, and rule 6's ambiguous current reader is not judged; a cited path that may go on past any run of whitespace (all Unicode \s) , ; ' ) ] or backtick is INCOMPLETE when the next token holds \ or an extension or a "<leaf><run><next>" sibling exists, but one continued by a plain word with no such sibling (for example, already deleted) is checked as its prefix and can PASS on a preserved prefix; that guard can add fail-closed INCOMPLETE noise on prose and on a command line naming an original then its copy, which only a line-keyed HARMLESS declaration clears (a target-only accepted break never does, and HARMLESS does not re-verify that copy; an owner HARMLESS on a prefix also clears that line's longer cited path), and any live JSON whose inputs[] items carry a path is read as a recovery map, so a digest-less item FAILs; a junction or symlink inside a declared or cited directory is never followed (INCOMPLETE), but a declared or cited path that is itself a link is read through one level; Hunt now initialises $c1/$decisions itself (test-hunt invokes Hunt in-process; no assertion kills removing that initialisation); a complete C1 PASS closes an earlier C1 finding whatever inputs produced it (closure keyed by hound); protection evidence is declared, not proven by C1; the real C1 run, its inputs and its manifest (records\MANIFEST.tsv is records-relative and names two originals twice) and deletion stay with the Final Stop Packet and the owner.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Append only. No approval or execution-root binding is claimed here. At actual approval append exactly one Approved Draft, Approved SHA256, Owner Evidence, Owner Evidence SHA256 and Execution Root line with actual immutable identities. For original execution append the actual Sandbox Receipt and Sandbox Receipt SHA256. Any delegated decision is labelled delegated.
Approved Draft: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-028\package\assurance\V7\DRAFT.md
Approved SHA256: 2D08F84610A630E657A3AB88E6CE229BAA593E53683B97FE20BE6AA4205D5C31
Owner Evidence: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-028\package\gate\GATE1-WS028-ORIGINAL-DELEGATED.md
Owner Evidence SHA256: 969225270CF5B80C467CCC63998DD15D673F8A02B70E3E9D62CB50346C560BB4
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\GitHub\ORVION-Owner-Tools\records\WS-028\package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 92CC6A6B5C04C9F0D4EB3A5110017DD3670C9FE304D60737C656DFB2FFF81AA3
Original exact three declared outputs applied by accepted native Execute; fresh own Finish and independent Review/Complete remain required. Other protected roots unchanged; prior failed attempts retained.
Residual risks carried unchanged from the selected Draft Review Gate and V2-V7 REPORT.md (C2 declared adjacent links only; C1 depends on owner-reviewed inputs; computed paths unseen). Real C1 run (manual input check, D84) and deletion: Final Stop Packet and owner.

## Verification Notes

V7 preparation (not native execution): candidate diff from clone C:\Users\My Lab\Documents\GitHub\ORVION-Workbench-temporary\cx\W28-v7 at baseline 7a4d476a1861fc3f3683e59b27c40eb370973f25. V7 corrective evidence (Claude main under owner D84/D85) on these final blobs (portable 7.6.8): complete lib/test-hunt.ps1 HUNT_SELFCHECK PASS (exit 0, 170 s, 71 PASS, 0 FAIL; every earlier assertion name kept, 1 added); record probe 43 PASS; lib/test-pulse.ps1 PULSE_SELFCHECK PASS; Test-ScriptHazards 0 on lib/Hunt.ps1 and lib/test-hunt.ps1; MARKDOWN_CONSISTENCY PASS; semantic mutants in copies of lib (record probe, or the complete suite for the two closure-guard mutants): original PASS and 26 of 26 mutants FAIL (the 25 V6 mutants with the continuation-guard entry re-pointed to V7's code, plus C1-V7-break-before-guard), and the V7 tests against frozen V6's Hunt FAIL 1 (accepted break on a prefix). Review probes V6 -> V7: an accepted break on a prefix with a LIVE '<prefix> (v2)\x' or '<prefix>,v2\x' line C1 PASS -> INCOMPLETE; a HARMLESS (source line and target) declared on a prefix still clears that line (documented owner clearance); every V3-V6 probe case unchanged (space, comma, semicolon, apostrophe, paren, comma in a file name, Unicode whitespace, space then ' or , INCOMPLETE; nested JSON and live temporary reference FAIL; prose and empty PASS). The continuation guard now runs for live and historical lines before the target-only accepted-break lookup; only a line-keyed HARMLESS precedes it. C2 on the current real private decision record (D85 version 54E93434A35724826E3E05AA7CF17E766F7989CA58A1F1FC7BEC6FD9FA484EB5): Hunt -Quick -NoRecord, synthetic data root, 0 decision findings, record hash unchanged. These are preparation observations, never native receipts.
Verdict: Confirmed Complete
Reviewed Fingerprint: 0A1D30863A232E5A85F054361515FC1E17680BD5DCB3B64BECCFDDD8F82EF78A
Reviewed Receipt: FE3C92ADBE84953146DC65BEB4702081A74653391E36264E6E442E4168D0CEE4
Live ORIGINAL-role review: runtime/original/criterion-review.json. Own Finish 27 ordered suites, runner/watcher/host 0/0/0, real journal unchanged; six protected roots and historical evidence preserved; original changes limited to three admitted outputs/contract/pointer/new receipt. Exact completed sandbox proof C4F5286717FDA524F2BFF6CF723C3C9806C97C76A9A3FD9F1C609E7BDEAF05B5 bound. Review: ONE Claude-main SELF-REVIEW ACCEPT under owner D85 (not independent) - owner override D77/D79, not two reviews. Not pushed; hosted release separate. CTRL19 OPEN.

