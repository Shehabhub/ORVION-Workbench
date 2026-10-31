# Self-check for Hunt.ps1: a planted bug its self-check catches is NOT reported, a harmless change the check cannot
# see IS reported as a surviving mutant, a stale mutant is reported, and nothing is recorded with -NoRecord.
param([switch]$RootProbeOnly,[switch]$EvidenceProbeOnly,[switch]$IndexProbeOnly,[switch]$RecordProbeOnly)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-huntcheck-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t|Out-Null
$savedTemporaryRoot=$env:WORKBENCH_TEMP_ROOT;$savedTemp=$env:TEMP;$savedTmp=$env:TMP;$env:WORKBENCH_TEMP_ROOT=$t+'-managed'
$savedProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
try{
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
    if(!$RootProbeOnly-and!$EvidenceProbeOnly){
        $indexStore=Join-Path $t 'index-probe'
        foreach($part in 'sessions','events','work'){[void][IO.Directory]::CreateDirectory((Join-Path $indexStore $part))}
        $indexLauncher=Join-Path $t 'index-probe.ps1'
        [IO.File]::WriteAllText($indexLauncher,@'
param([string]$Hunt,[string]$Store,[switch]$Record)
function Get-Process { @() }
function Get-CimInstance { @() }
& $Hunt -Root $Store -DataRoot $Store -Quick -NoRecord:(!$Record)
exit $LASTEXITCODE
'@)
        $indexFile=Join-Path $indexStore 'sessions/index.jsonl'
        $indexJournal=Join-Path $indexStore 'events/events.jsonl'
        $oldIndexEvents=@(foreach($pattern in 'hunt-index-consistency','hunt-lesson-raw-missing','hunt-unrelated-old'){
            @{at='2000-01-01T00:00:00Z';pattern=$pattern;status='open';category='observation';summary='old fixture';session='hunter-fixture'}|ConvertTo-Json -Compress
        })
        [IO.File]::WriteAllLines($indexJournal,[string[]]$oldIndexEvents)
        [IO.File]::WriteAllText((Join-Path $indexStore 'work/sync-errors.log'),'INDEPENDENT-SENTINEL')
        $marker=Join-Path $indexStore 'sessions/marker.jsonl'
        [IO.File]::WriteAllText($marker,'x');(Get-Item $marker).LastWriteTimeUtc=[DateTime]::UtcNow.AddHours(-1)
        $indexRow=@{id='before';raw='sessions\marker.jsonl';bytes=0;metaBytes=0}
        $indexAfter=@{id='after';raw='sessions\marker.jsonl';bytes=0;metaBytes=0}
        [IO.File]::WriteAllLines($indexFile,[string[]]@(($indexRow|ConvertTo-Json -Compress),'{torn','null',($indexAfter|ConvertTo-Json -Compress),'  '))
        $indexHash=(Get-FileHash $indexJournal).Hash
        $indexOutput=@(& pwsh -NoProfile -File $indexLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $indexStore 2>&1)-join"`n";$indexCode=$LASTEXITCODE
        Assert-That 'index corruption counts two rows, checks valid rows on both sides and continues other hounds' ($indexCode-eq1-and$indexOutput-match'BUG index-unreadable: 2 malformed row\(s\)'-and$indexOutput-match'BUG index-consistency: 2 '-and$indexOutput-match'BUG sync-errors:.*INDEPENDENT-SENTINEL'-and$indexOutput-match'^HUNT ')
        Assert-That 'partial index saves its result and NoRecord preserves the journal' ((Test-Path (Join-Path $indexStore 'work/hunt-last.txt'))-and(Get-FileHash $indexJournal).Hash-ceq$indexHash)
        # The repository map refreshes itself only while its scheduled task exists and last succeeded.
        $mapLauncher=Join-Path $t 'map-probe.ps1'
        [IO.File]::WriteAllText($mapLauncher,@'
param([string]$Hunt,[string]$Store,[string]$Mode)
function Get-Process { @() }
function Get-CimInstance { @() }
$task=switch($Mode){'missing'{{throw 'no task'}}'failed'{{[pscustomobject]@{LastTaskResult=1}}}default{{[pscustomobject]@{LastTaskResult=0}}}}
& $Hunt -Root $Store -DataRoot $Store -Quick -NoRecord -GetMapTask $task
exit $LASTEXITCODE
'@)
        $mapSeen=@{}
        foreach($mode in 'missing','failed','ok'){$mapSeen[$mode]=(@(& pwsh -NoProfile -File $mapLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $indexStore -Mode $mode 2>&1)-join"`n")-match'GAP map-task'}
        Assert-That 'map task missing or failed is a GAP; a healthy task is not' ($mapSeen.missing-and$mapSeen.failed-and!$mapSeen.ok)
        $indexRow.bytes=1;$indexRow.metaBytes=1
        [IO.File]::WriteAllText((Join-Path $indexStore 'work/sync-errors.log'),'')
        [IO.File]::WriteAllLines($indexFile,[string[]]@(($indexRow|ConvertTo-Json -Compress),'{torn'))
        $null=& pwsh -NoProfile -File $indexLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $indexStore -Record
        $recordIndexCode=$LASTEXITCODE
        $indexEvents=@([IO.File]::ReadAllLines($indexJournal)|ForEach-Object{$_|ConvertFrom-Json})
        Assert-That 'incomplete index retains old index and lesson findings while unrelated findings can resolve' (@($indexEvents|Where-Object pattern -eq 'hunt-index-consistency')[-1].status-eq'open'-and@($indexEvents|Where-Object pattern -eq 'hunt-lesson-raw-missing')[-1].status-eq'open'-and@($indexEvents|Where-Object pattern -eq 'hunt-unrelated-old')[-1].status-eq'resolved')
        Assert-That 'index corruption alone exits 1 and recording names index unreadability in the journal' ($recordIndexCode-eq1-and@($indexEvents|Where-Object pattern -eq 'hunt-index-unreadable').Count-eq1)
        $indexLock=[IO.File]::Open($indexFile,'Open','ReadWrite','None')
        try{$lockedOutput=@(& pwsh -NoProfile -File $indexLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $indexStore 2>&1)-join"`n";$lockedCode=$LASTEXITCODE}finally{$indexLock.Dispose()}
        Assert-That 'unreadable index file reports unknown count and continues to the summary' ($lockedCode-eq1-and$lockedOutput-match'BUG index-unreadable: row count unknown'-and$lockedOutput-match'^HUNT ')
        if($IndexProbeOnly){if($fail){throw 'HUNT_INDEX_PROBE_FAILED'};'HUNT_INDEX_PROBE PASS';return}
    }
    if(!$RootProbeOnly){
        $evidenceRoot=Join-Path $t 'evidence';[void][IO.Directory]::CreateDirectory((Join-Path $evidenceRoot 'events'))
        [void][IO.Directory]::CreateDirectory((Join-Path $evidenceRoot 'work'))
        [IO.File]::WriteAllText((Join-Path $evidenceRoot 'work\correct.log'),'fixture')
        $evidenceEvents=@(
            [ordered]@{at='2026-10-20T00:00:00Z';pattern='corrected';evidence='work\wrong.log (38.027 min)';status='resolved'}
            [ordered]@{at='2026-10-26T00:00:00Z';pattern='corrected';evidence='work\correct.log (38.027 min)';status='resolved'}
            [ordered]@{at='2026-10-26T01:00:00Z';pattern='corrected';evidence='';status='resolved'}
            [ordered]@{at='2026-10-26T00:00:00Z';pattern='independent';evidence='work\still-missing.log';status='resolved'}
            # An empty latest update cannot erase a missing citation either.
            [ordered]@{at='2026-10-26T01:00:00Z';pattern='independent';evidence='';status='resolved'}
            # Many equal timestamps followed by an older backfill expose an unstable tie ordering.
            foreach($tieIndex in 0..15){[ordered]@{at='2026-10-26T00:00:00Z';pattern='equal-time';evidence=$(if($tieIndex-eq15){'work\correct.log'}else{'work\wrong.log'});status='open'}}
            [ordered]@{at='2000-01-01T00:00:00Z';pattern='equal-time';evidence='work\wrong.log';status='open'}
        )
        $evidenceJournal=Join-Path $evidenceRoot 'events\events.jsonl'
        [IO.File]::WriteAllLines($evidenceJournal,[string[]]@($evidenceEvents|ForEach-Object{$_|ConvertTo-Json -Compress}))
        $evidenceHash=(Get-FileHash -LiteralPath $evidenceJournal).Hash
        $evidenceLauncher=Join-Path $t 'evidence-probe.ps1'
        [IO.File]::WriteAllText($evidenceLauncher,@'
param([string]$Hunt,[string]$Store)
function Get-Process { @() }
function Get-CimInstance { @() }
& $Hunt -Root $Store -DataRoot $Store -Quick -NoRecord
exit $LASTEXITCODE
'@)
        $evidenceOutput=@(& pwsh -NoProfile -File $evidenceLauncher -Hunt (Join-Path $PSScriptRoot 'Hunt.ps1') -Store $evidenceRoot)
        $evidenceCode=$LASTEXITCODE
        $evidenceGap=@($evidenceOutput|Where-Object{$_-match'GAP event-evidence:'})-join' '
        Assert-That 'latest nonempty corrected evidence replaces historical missing paths' ($evidenceCode-eq0-and$evidenceGap-notmatch'corrected')
        Assert-That 'resolved missing evidence survives a later empty metadata update' ($evidenceGap-match'independent')
        Assert-That 'equal timestamp evidence uses last journal record despite older backfill' ($evidenceGap-notmatch'equal-time')
        Assert-That 'evidence projection never rewrites the append-only journal' ((Get-FileHash -LiteralPath $evidenceJournal).Hash-ceq$evidenceHash)
        if($EvidenceProbeOnly){if($fail){throw 'HUNT_EVIDENCE_PROBE_FAILED'};'HUNT_EVIDENCE_PROBE PASS';return}
    }

    # Independently controlled source and data with opposing evidence; Quick avoids slow mutants/lint.
    $layout=Join-Path $t 'roots';$checkout=Join-Path $layout 'ORVION-Workbench';$copy=Join-Path $checkout 'lib'
    $sibling=Join-Path $layout 'ORVION-Owner-Tools';$override=Join-Path $layout 'override store';$explicit=Join-Path $t 'explicit store'
    [void][IO.Directory]::CreateDirectory($copy)
    Copy-Item (Join-Path $PSScriptRoot '*') $copy -Recurse
    $savedDataRoot=$env:ORVION_DATA_ROOT
    try{
        foreach($case in 'sibling','override','explicit'){
            $env:ORVION_DATA_ROOT=$null
            [void][IO.Directory]::CreateDirectory((Join-Path $sibling 'events'))
            $expected=if($case-eq'explicit'){$env:ORVION_DATA_ROOT=$override;$explicit}elseif($case-eq'override'){$env:ORVION_DATA_ROOT=$override+'\';$override}else{$sibling}
            [void][IO.Directory]::CreateDirectory((Join-Path $expected 'work'));[void][IO.Directory]::CreateDirectory((Join-Path $expected 'sessions'));[void][IO.Directory]::CreateDirectory((Join-Path $expected 'events'))
            Set-Content (Join-Path $expected 'work\sync-errors.log') "fixture-$case"
            Set-Content (Join-Path $expected 'work\hook-errors.log') "fixture-hook-$case"
            Set-Content (Join-Path $expected 'sessions\marker.jsonl') '{}'
            (Get-Item (Join-Path $expected 'sessions\marker.jsonl')).LastWriteTimeUtc=[DateTime]::UtcNow.AddHours(-1)
            Set-Content (Join-Path $expected 'sessions\index.jsonl') '{"id":"fixture","raw":"sessions\\marker.jsonl","bytes":0,"metaBytes":0}'
            Set-Content (Join-Path $expected 'events\events.jsonl') '{torn','{"at":"2026-10-20T01:00:00Z","pattern":"fixture-evidence","evidence":"sessions\\marker.jsonl"}','{"at":"2000-01-01T00:00:00Z","pattern":"hunt-old-root-problem","status":"open","category":"observation"}'
            $archived=Join-Path $expected 'sessions\raw\claude\C--Fixture-ORVION';$source=Join-Path $env:USERPROFILE '.claude\projects\C--Fixture-ORVION'
            [void][IO.Directory]::CreateDirectory($archived);[void][IO.Directory]::CreateDirectory($source)
            Set-Content (Join-Path $archived 'prefix.jsonl') 'old';Set-Content (Join-Path $source 'prefix.jsonl') 'rewritten'
            Set-Content (Join-Path $archived 'MEMORY.md') 'old';Set-Content (Join-Path $source 'MEMORY.md') 'edited in place'  # not a transcript: never a prefix BUG
            $extra=if($case-eq'explicit'){@('-DataRoot',$explicit)}else{@()}
            $result=@(& pwsh -NoProfile -File (Join-Path $copy 'Hunt.ps1') -Quick @extra)-join"`n";$huntCode=$LASTEXITCODE
            Assert-That "hunt $case reads sessions, events and sync errors from data root with BUG exit 1" ($huntCode-eq1-and$result-match"BUG sync-errors:.*fixture-$case"-and$result-match'BUG index-consistency:.*index says'-and$result-match'BUG events-corrupt:'-and$result-match'BUG archive-prefix: 1 of 1 archived'-and$result-match"BUG hook-errors:.*fixture-hook-$case"-and$result-notmatch'GAP event-evidence:')
            $rootEvents=@(Get-Content (Join-Path $expected 'events\events.jsonl')|ForEach-Object{try{$_|ConvertFrom-Json}catch{$null=$_}})
            $closed=@($rootEvents|Where-Object pattern -eq 'hunt-old-root-problem')[-1]
            Assert-That "hunt $case records findings and last result only in data root" ((Test-Path (Join-Path $expected 'work\hunt-last.txt'))-and@($rootEvents|Where-Object pattern -eq 'hunt-sync-errors').Count-gt0-and$closed.status-eq'resolved'-and!(Test-Path (Join-Path $checkout 'work')))
            # Data has no .git. Source has an invalid .git; only the source may decide tools-git.
            Set-Content (Join-Path $checkout '.git') 'gitdir: missing-fixture-git'
            $sourceCheck=@(& pwsh -NoProfile -File (Join-Path $copy 'Hunt.ps1') -Quick -NoRecord @extra)-join"`n"
            Assert-That "hunt $case keeps git checks on source after library import" ($sourceCheck-match'BUG tools-git:')
            Remove-Item -LiteralPath (Join-Path $checkout '.git')
        }
    }finally{$env:ORVION_DATA_ROOT=$savedDataRoot}
    if($RootProbeOnly){if($fail){throw 'HUNT_ROOT_PROBE_FAILED'};'HUNT_ROOT_PROBE PASS';return}
    $set=@(
        ,@('Events.ps1','if($last.Count){"EVENT DUPLICATE','if($false){"EVENT DUPLICATE','test-events.ps1','duplicate refusal')        # caught
        ,@('Events.ps1','# One view per pattern','# One view, per pattern','test-events.ps1','a comment only')                          # survives
        ,@('Events.ps1','THIS TEXT IS NOT IN THE FILE','x','test-events.ps1','a mutant whose code moved')                           # stale
    )
    $out=@(& (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $t -DataRoot $t -NoRecord -MutantSet $set)-join"`n"
    Assert-That 'a caught mutant is not reported' ($out-notmatch'duplicate refusal broken')
    Assert-That 'a surviving mutant is reported as a gap' ($out-match'GAP mutant-survived: test-events\.ps1 still passes with a comment only broken')
    Assert-That 'a stale mutant is reported' ($out-match'GAP mutant-stale: mutant for a mutant whose code moved')
    Assert-That 'the last result is kept for Pulse' (Test-Path (Join-Path $t 'work\hunt-last.txt'))
    Assert-That '-NoRecord writes no events' (!(Test-Path (Join-Path $t 'events\events.jsonl')))
    & (Join-Path $PSScriptRoot 'Events.ps1') -Root $t -Add -Pattern hunt-old-problem -Session hunter-2026-01-01 -Category observation -Summary 'GAP: something once found'|Out-Null
    foreach($pattern in 'hunt-c1-fail','hunt-decision-backpointer'){& (Join-Path $PSScriptRoot 'Events.ps1') -Root $t -Add -Pattern $pattern -Session hunter-2026-01-01 -Category failure -Summary 'BUG: an earlier C1/C2 finding'|Out-Null}
    $null=& (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $t -DataRoot $t -Quick
    $ev=@([IO.File]::ReadAllLines((Join-Path $t 'events\events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json})
    $last=@($ev|Where-Object pattern -eq 'hunt-old-problem'|Sort-Object at)[-1]
    Assert-That 'a finding no longer found is closed by the hunter' ($last.status-eq'resolved'-and$last.summary-like'no longer found*')
    Assert-That 'a Hunt without -DeletionReadiness or a readable decision record leaves C1/C2 findings open' ((@(foreach($pattern in 'hunt-c1-fail','hunt-decision-backpointer'){@($ev|Where-Object pattern -eq $pattern|Sort-Object at)[-1].status})-join',')-ceq'open,open')
    Assert-That 'current findings are recorded as events' (@($ev|Where-Object{$_.pattern-eq'hunt-index-missing'-and$_.source-eq'hunter'}).Count-eq1)
    # The guard's other branches: a C1 that ran INCOMPLETE (inputs absent) and an unreadable (headingless) decision record.
    $headingless=Join-Path $t 'headingless.md';[IO.File]::WriteAllText($headingless,'no decision headings')
    $null=& (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $t -DataRoot $t -Quick -DeletionReadiness (Join-Path $t 'absent-inputs.json') -DecisionsPath $headingless
    $ev=@([IO.File]::ReadAllLines((Join-Path $t 'events\events.jsonl'))|ForEach-Object{$_|ConvertFrom-Json})
    Assert-That 'an INCOMPLETE C1 or an unreadable decision record leaves C1/C2 findings open' ((@(foreach($pattern in 'hunt-c1-fail','hunt-decision-backpointer'){@($ev|Where-Object pattern -eq $pattern|Sort-Object at)[-1].status})-join',')-ceq'open,open'-and@($ev|Where-Object pattern -eq 'hunt-c1-incomplete').Count-and@($ev|Where-Object pattern -eq 'hunt-decision-record-unreadable').Count)
}finally{$env:WORKBENCH_TEMP_ROOT=$savedTemporaryRoot;$env:TEMP=$savedTemp;$env:TMP=$savedTmp;$env:USERPROFILE=$savedProfile;$null=Remove-OrvionOwnedTree -Path $t -AllowedRoots @([IO.Path]::GetTempPath());if(Test-Path ($t+'-managed')){$null=Remove-OrvionOwnedTree -Path ($t+'-managed') -AllowedRoots @([IO.Path]::GetTempPath())}}
if($fail){throw "HUNT_SELFCHECK_FAILED $fail"};'HUNT_SELFCHECK PASS'
