# Self-check for Organize.ps1 (-New, -Move, -Clean, -Refresh, -Check, -Map): one disposable workspace fixture; each negative case makes one
# hand-made change, expects its own code and undoes the change, so the next case starts from a passing fixture.
param([switch]$MapOnly,[switch]$GuardsOnly,[switch]$RetentionOnly)
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) ('orvion-org-'+[guid]::NewGuid().ToString('N').Substring(0,8));$wb=Join-Path $t 'wb';$tmpRoot=Join-Path $t 'tp';$data=Join-Path $wb 'data';$fail=0
$script=Join-Path $PSScriptRoot 'Organize.ps1'
function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
function Invoke-Tool{$out=@(& pwsh -NoProfile -File $script @args -Checkout $wb -Temporary $tmpRoot -Root $data 2>&1|ForEach-Object{"$_"});[pscustomobject]@{Exit=$LASTEXITCODE;Text=$out-join"`n"}}
function Add-File([string]$Path,[string]$Text='x'){[void][IO.Directory]::CreateDirectory((Split-Path $Path -Parent));[IO.File]::WriteAllText($Path,$Text)}
function Add-Organizer([string]$Path,[string]$Kind='reference'){$made=Invoke-Tool -New $Path -Kind $Kind -Purpose "the $($Path.Split('\')[-1]) folder" -Reader 'the fixture';if($made.Exit){throw "FIXTURE_NEW_FAILED $Path $($made.Text)"}}
function Assert-Finds([string]$Name,[string]$Code){$checked=Invoke-Tool -Check;$ok=$checked.Exit-eq1-and$checked.Text-cmatch"(?m)^$Code$"-and$checked.Text-cmatch'ORGANIZE_CHECK FAIL 1$';Assert-That $Name $ok;if(!$ok){"  $($checked.Text)"}}
function Assert-Passes([string]$Name){$checked=Invoke-Tool -Check;$ok=$checked.Exit-eq0-and$checked.Text-cmatch'ORGANIZE_CHECK PASS$';Assert-That $Name $ok;if(!$ok){"  $($checked.Text)"}}
function Assert-TextFinds([string]$Name,[string]$Path,[string]$Extra,[string]$Code){$kept=[IO.File]::ReadAllText($Path);[IO.File]::AppendAllText($Path,"$Extra`n");Assert-Finds $Name $Code;[IO.File]::WriteAllText($Path,$kept)}
function Assert-TextPasses([string]$Name,[string]$Path,[string]$Extra){$kept=[IO.File]::ReadAllText($Path);[IO.File]::AppendAllText($Path,"$Extra`n");Assert-Passes $Name;[IO.File]::WriteAllText($Path,$kept)}
function Assert-Refused([string]$Name,[string]$Code,[string[]]$Arguments){$refused=@(& pwsh -NoProfile -File $script @Arguments -Checkout $wb -Temporary $tmpRoot -Root $data 2>&1|ForEach-Object{"$_"});$exit=$LASTEXITCODE;Assert-That $Name ($exit-ne0-and($refused-join"`n")-cmatch$Code)}
try{
    foreach($file in 'AGENTS.md','RESUME.md','WORKFLOW.md','HANDOFF.md','tests.ps1','.gitignore','.gitattributes','.githooks/h','.github/g','config/README.md','lib/README.md','lib/Tool.ps1','lib/Organize.ps1','lib/hooks/w.ps1','README.md'){Add-File (Join-Path $wb $file) "# $file`n"}
    Add-File (Join-Path $wb 'README.md') "# README.md`nThe tools and documents: Tool.ps1, RUNBOOK.md, RECOVERY.md, DECISIONS.md, WORKSPACE-LAYOUT.md.`n"
    foreach($folder in 'changes','docs','docs/history','docs/owner','records'){[void][IO.Directory]::CreateDirectory((Join-Path $wb $folder))}
    foreach($folder in 'changes','docs','docs\history','docs\owner','docs\owner\recovery-inputs','records'){Add-Organizer (Join-Path $wb $folder)}
    Add-File (Join-Path $wb 'changes/TEMPLATE.md') "# Template`n";Add-File (Join-Path $wb 'changes/WS-001-first.md') "# WS-001 first`n"
    foreach($file in 'RUNBOOK.md','RECOVERY.md','DECISIONS.md'){Add-File (Join-Path $wb "docs/$file") "# $file`nPurpose: a $file with a | pipe. Kind: reference. Lifetime: permanent.`nReader: the owner.`n"}
    Add-File (Join-Path $wb 'docs/WORKSPACE-LAYOUT.md') "# The layout`n"
    [void][IO.Directory]::CreateDirectory($data);Add-Organizer $data 'live-data'
    foreach($folder in 'work','events','sessions','records'){Add-Organizer (Join-Path $data $folder) 'live-data'}
    Add-File (Join-Path $data 'events/events.jsonl') '';Add-File (Join-Path $data 'records/old-folder/deep/a.txt');Add-File (Join-Path $data 'decisions-inbox.md') "# Inbox`n"
    [void][IO.Directory]::CreateDirectory($tmpRoot);Add-Organizer $tmpRoot 'scratch'
    foreach($area in 'tmp','cx','sb','tools','restore-staging','codex-relay-logs','scratch','map'){Add-Organizer (Join-Path $tmpRoot $area) 'scratch'}
    [void][IO.Directory]::CreateDirectory((Join-Path $tmpRoot 'retired'));[void][IO.Directory]::CreateDirectory((Join-Path $tmpRoot 'judges'))
    $made=Invoke-Tool -Refresh;if($made.Exit){throw "FIXTURE_REFRESH_FAILED $($made.Text)"}
    Assert-Passes 'a complete workspace passes'

    if(!$RetentionOnly){
    # The guards of DEC-28, guards.md section 6: one hand-made defect per check, each undone before the next.
    function Assert-FileFinds([string]$Name,[string]$Path,[string]$Text,[string]$Code){$kept=if(Test-Path -LiteralPath $Path){[IO.File]::ReadAllText($Path)};Add-File $Path $Text;Assert-Finds $Name $Code;if($null-eq$kept){Remove-Item -LiteralPath $Path -Force}else{[IO.File]::WriteAllText($Path,$kept)}}
    $sections=Join-Path $data 'records/WS-033/sections.tsv';$sectionsAt='data:records/WS-033/sections\.tsv'
    $sectionsHead="ID`tFile`tLines`tSection`tKind`tAction`tTarget`tDEC`tNote`n";$sectionsRow="L1`tf`t1`ts`trule`tKEEP`t`t`t`n"
    Add-File $sections "$sectionsHead$sectionsRow"
    $made=Invoke-Tool -Refresh;if($made.Exit){throw "FIXTURE_REFRESH_FAILED $($made.Text)"}
    Assert-Passes 'a data table that keeps its schema passes'
    Assert-FileFinds 'G06 a row with a wrong column count' $sections "$sectionsHead$sectionsRow`L2`tf`n" "BAD_TSV ${sectionsAt}:3 columns 2 of 9"
    Assert-FileFinds 'G06 a duplicate ID' $sections "$sectionsHead$sectionsRow$sectionsRow" "BAD_TSV ${sectionsAt}:3 duplicate ID L1"
    Assert-FileFinds 'G06 an ID off its pattern' $sections "$sectionsHead$($sectionsRow.Replace('L1','X1'))" "BAD_TSV ${sectionsAt}:2 ID X1"
    Assert-FileFinds 'G06 a value outside its enum' $sections "$sectionsHead$($sectionsRow.Replace('rule','guess'))" "BAD_TSV ${sectionsAt}:2 Kind guess"
    Assert-FileFinds 'G06 a changed header' $sections "$($sectionsHead.Replace('Note','Remark'))$sectionsRow" "BAD_TSV $sectionsAt header"
    Remove-Item -LiteralPath (Split-Path $sections -Parent) -Recurse -Force
    $made=Invoke-Tool -Refresh;if($made.Exit){throw "FIXTURE_REFRESH_FAILED $($made.Text)"}
    $events=Join-Path $data 'events/events.jsonl'
    $eventLine='{"at":"2026-11-03T00:00:00Z","session":"s","source":"t","pattern":"p","category":"failure","severity":"info","summary":"x","status":"open"}'
    Add-File $events "$eventLine`n";Assert-Passes 'an event line that keeps its schema passes'
    Assert-FileFinds 'G05 a torn JSONL line' $events "$eventLine`n$($eventLine.Substring(0,30))`n" 'BAD_JSON data:events/events\.jsonl:2'
    Assert-FileFinds 'G05 a JSONL line off its schema' $events "$eventLine`n$($eventLine.Replace('"open"','"maybe"'))`n" 'BAD_JSON data:events/events\.jsonl:2'
    Add-File $events ''
    Assert-FileFinds 'G05 a JSON file off its schema' (Join-Path $data 'work/deletion-readiness.json') '{"schema":1,"at":"a","inputs":[],"outcome":"guess","edges":[]}' 'BAD_JSON data:work/deletion-readiness\.json'
    $docsTable=Join-Path $wb 'docs/README.md';$docsKept=[IO.File]::ReadAllText($docsTable);[IO.File]::WriteAllText($docsTable,$docsKept.Replace('a RUNBOOK.md with a','an edited RUNBOOK.md with a'))
    Assert-That 'the organizer case edits a generated row' ($docsKept-cne[IO.File]::ReadAllText($docsTable))
    Assert-Finds 'G07 a stale organizer table' 'GENERATED STALE: workbench:docs/README\.md';[IO.File]::WriteAllText($docsTable,$docsKept)
    $logTsv=Join-Path $wb 'docs\history\LOG.tsv';$logKept=[IO.File]::ReadAllText($logTsv);$savedGlobal=$env:GIT_CONFIG_GLOBAL;$savedSystem=$env:GIT_CONFIG_NOSYSTEM
    $env:GIT_CONFIG_GLOBAL=Join-Path $t 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
    try{
        & git -C $wb init -q 2>&1|Out-Null;& git -C $wb add docs/history/LOG.tsv 2>&1|Out-Null;& git -C $wb -c user.name=t -c user.email=t@t commit -q -m log 2>&1|Out-Null
        if($LASTEXITCODE){throw 'FIXTURE_COMMIT_FAILED'}
        # Any LOG change also dates the organizers' change tables, so these two read the one code only.
        [IO.File]::AppendAllText($logTsv,"2026-11-03T00:00:00Z`tnew`tdata`t`tx`tWS-033`tr`t`n")
        Assert-That 'G09 an appended LOG row is no rewrite' ((Invoke-Tool -Check).Text-cnotmatch'LOG_REWRITTEN')
        [IO.File]::WriteAllText($logTsv,$logKept.Replace("`tnew`t","`tmove`t"))
        Assert-That 'the LOG case changes a committed row' ($logKept-cne[IO.File]::ReadAllText($logTsv))
        $rewritten=Invoke-Tool -Check;Assert-That 'G09 a changed committed row of LOG.tsv' ($rewritten.Exit-eq1-and$rewritten.Text-cmatch'(?m)^LOG_REWRITTEN workbench:docs/history/LOG\.tsv$');[IO.File]::WriteAllText($logTsv,$logKept)
    }finally{$env:GIT_CONFIG_GLOBAL=$savedGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedSystem;Get-ChildItem -LiteralPath (Join-Path $wb '.git') -Recurse -Force -File -ErrorAction Ignore|ForEach-Object{$_.Attributes='Normal'};Remove-Item -LiteralPath (Join-Path $wb '.git') -Recurse -Force -ErrorAction Ignore}
    Assert-Passes 'the fixture passes after the data cases'
    # G07: -Check runs every generator's own -Check; each owning test holds the deep cases.
    Add-File (Join-Path $data 'sessions/index.jsonl') '{"v":1,"client":"claude","id":"a","raw":"r","bytes":1,"tools":{},"start":"2026-11-03T00:00:00Z"}'
    $indexPage=Join-Path $data 'sessions/INDEX.md'
    Assert-Finds 'G07 Check runs Sync-Sessions -Check, an absent page is stale' "GENERATED STALE: $([regex]::Escape($indexPage.Replace('/','\')))"
    Remove-Item -LiteralPath (Join-Path $data 'sessions/index.jsonl') -Force
    $w77=Join-Path $tmpRoot 'sb\W77';$logKept=[IO.File]::ReadAllText($logTsv);Add-Organizer $w77
    Add-File (Join-Path $w77 'PLAN.md') "# WS-077 plan: a fixture`n`nStatus: in force.`n`n## 6. Now and next`n`n| Rank | Step | Why |`n| --- | --- | --- |`n| 1 | P2 Build | first |`n`n## 7. Roadmap`n`n| Batch | Steps | Same files | Run by | Ends with | Why here |`n| --- | --- | --- | --- | --- | --- |`n| B1 | P2 | a | Opus | a save | first |`n`n## 3. Steps`n`n### Done`n`n| Step | Output |`n| --- | --- |`n| P1 | x |`n`n### P2 Build`n`n| Step | Do | Run by | Time |`n| --- | --- | --- | --- |`n| P2 | build | Opus | 1 h |`n";Add-File (Join-Path $w77 'status.html') '<!-- a hand edit -->'
    Assert-Finds 'G07 Check runs Save-State -Check, a page the plan does not produce is stale' "GENERATED STALE: $([regex]::Escape((Join-Path $w77 'status.html')))"
    Remove-Item -LiteralPath $w77 -Recurse -Force;[IO.File]::WriteAllText($logTsv,$logKept)
    $made=Invoke-Tool -Refresh;if($made.Exit){throw "FIXTURE_REFRESH_FAILED $($made.Text)"}
    $mapJson=Join-Path $wb 'ai-map.json';Add-File $mapJson '{}'
    Assert-That 'G07 Check runs Map-Repos -Check, a hand-made map is stale' ((Invoke-Tool -Check).Text-cmatch"(?m)^GENERATED STALE: $([regex]::Escape($mapJson))$")
    Assert-That 'G07 Check -Quick leaves the map out' ((Invoke-Tool -Check -Quick).Text-cnotmatch'GENERATED STALE')
    Remove-Item -LiteralPath $mapJson -Force
    # G01, G02: the one list is the deny rules of .claude/settings.json; each single-writer file has its rule and the one handler covers both shells.
    $settingsFile=Join-Path (Split-Path $PSScriptRoot -Parent) '.claude\settings.json';$settings=[IO.File]::ReadAllText($settingsFile)|ConvertFrom-Json
    foreach($rule in '/data/work/NOW.md','/docs/history/LOG.tsv','/data/work/retention-log.tsv','/data/events/events.jsonl','/data/sessions/index.jsonl','/data/sessions/INDEX.md','/data/work/hunt-last.txt','/ai-map.html','/ai-map.json','~/Documents/GitHub/ORVION-Workbench-temporary/map/**','~/Documents/GitHub/ORVION-Workbench-temporary/sb/*/status.html'){
        Assert-That "G01 a deny rule for $rule" ($settings.permissions.deny-ccontains"Edit($rule)")
    }
    foreach($shell in 'PowerShell','Bash'){
        # No `if` on the handler: on Claude Code 2.1.310 an `if` filter does not see a redirect's target, so `echo x > <file>` passed it (prototype\s11\guard-session-probe.md).
        $handlers=@($settings.hooks.PreToolUse|Where-Object{$shell-cmatch"^($($_.matcher))$"}|ForEach-Object hooks)
        Assert-That "G02 one unfiltered guard handler on $shell" ($handlers.Count-eq1-and$handlers[0].command-cmatch'lib/hooks/Guard-Write\.ps1'-and!$handlers[0].if)
    }
    function Get-GuardExit([string]$Command){@{tool_input=@{command=$Command}}|ConvertTo-Json -Compress|& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'hooks\Guard-Write.ps1') 2>&1|Out-Null;$LASTEXITCODE}
    foreach($name in 'NOW.md','LOG.tsv','retention-log.tsv','events.jsonl','index.jsonl','INDEX.md','hunt-last.txt','ai-map.html','ai-map.json','status.html'){
        Assert-That "G02 refuses a write naming $name" ((Get-GuardExit "echo x > some/folder/$name")-eq2)
    }
    $doc='data/work/NOW.md'
    foreach($write in "Set-Content $doc x","set-content $doc x","Add-Content $doc x","Clear-Content $doc","x | Out-File $doc","x | Tee-Object $doc","Move-Item a $doc","Copy-Item a $doc","Remove-Item $doc","Rename-Item $doc b","New-Item $doc","echo x > $doc","echo x >> $doc","mv a $doc","cp a $doc","rm $doc","tee $doc","sed -i s/a/b/ $doc","[IO.File]::WriteAllText('$doc','x')","[System.IO.File]::AppendAllText('$doc','x')","[IO.File]::Delete('$doc')","echo x > a 2>&1; Set-Content docs/history/LOG.tsv x","Set-Content ai-map.json x","Set-Content -Value 'a;b' -Path $doc","Set-Content -Value `"a|b`" -Path $doc","Set-Content -Value @'`nx | y`n'@ -Path $doc","echo x | Out-File out/package/release/run.log","pwsh -File a.ps1 > C:\x\package\release\run.log","Get-Content a && Add-Content x\package\release\b.txt y"){
        Assert-That "G02 refuses: $write" ((Get-GuardExit $write)-eq2)
    }
    foreach($read in "Get-Content $doc","cat $doc","git log -- $doc","git status 2>&1 | Select-String $doc","Get-Content $doc 2>`$null","cat $doc 2> /dev/null","`$x=`$a.b -> $doc","Set-Content NOW.md.bak x","Set-Content MY-NOW.md x","Set-Content free.txt x","Get-Content $doc > out.txt","Get-Content $doc | Set-Content copy.txt","@'`nnotes on $doc`n'@ | Set-Content notes.txt","Get-Content out\package\release\manifest.json","Get-Content out\package\release\a.txt > log.txt"){
        Assert-That "G02 passes: $read" ((Get-GuardExit $read)-eq0)
    }
    if($GuardsOnly){if($fail){throw "ORGANIZE_GUARDS_FAILED $fail"};'ORGANIZE_GUARDS PASS';return}
    }

    # The retention tier (DEC-27, DEC-10, slice S7). A lib copy whose sync lock is its own, so the real archiver never answers for the fixture.
    Add-Type -TypeDefinition @"
using System;using System.Runtime.InteropServices;using Microsoft.Win32.SafeHandles;
public static class Rp{
[DllImport("kernel32",SetLastError=true,CharSet=CharSet.Unicode)]public static extern SafeFileHandle CreateFile(string n,uint a,uint s,IntPtr p,uint c,uint f,IntPtr t);
[DllImport("kernel32",SetLastError=true)]public static extern bool DeviceIoControl(SafeFileHandle h,uint code,byte[] i,int il,IntPtr o,int ol,out int r,IntPtr ov);
public static int Set(string path,uint tag){var h=CreateFile(path,0x40000000|0x80000000,0,IntPtr.Zero,3,0x02000000|0x00200000,IntPtr.Zero);if(h.IsInvalid)return Marshal.GetLastWin32Error();
var g=new Guid("11111111-2222-3333-4444-555555555555").ToByteArray();var b=new byte[8+16+4];BitConverter.GetBytes(tag).CopyTo(b,0);BitConverter.GetBytes((ushort)4).CopyTo(b,4);g.CopyTo(b,8);int r;
bool ok=DeviceIoControl(h,0x900A4,b,b.Length,IntPtr.Zero,0,out r,IntPtr.Zero);int e=ok?0:Marshal.GetLastWin32Error();h.Dispose();return e;}}
"@
    $retLib=Join-Path $t 'ret-lib';[void][IO.Directory]::CreateDirectory($retLib)
    foreach($name in 'Organize.ps1','workspace-layout.ps1','remove-owned.ps1','data-schemas.json','Test-MarkdownConsistency.ps1'){Copy-Item -LiteralPath (Join-Path $PSScriptRoot $name) $retLib}
    $lockName='Local\orvion-ret-'+[guid]::NewGuid().ToString('N')
    [IO.File]::WriteAllText((Join-Path $retLib 'Sync-Sessions.ps1'),[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'Sync-Sessions.ps1')).Replace('Local\orvion-sync-sessions',$lockName))
    $retScript=Join-Path $retLib 'Organize.ps1';$vault=Join-Path $t 'vault';$retLog=Join-Path $data 'work\retention-log.tsv'
    $retRunbook=Join-Path $wb 'docs\RUNBOOK.md';$retKept=[IO.File]::ReadAllText($retRunbook);$retLogPath=Join-Path $wb 'docs\history\LOG.tsv';$retLogBefore=[IO.File]::ReadAllText($retLogPath)
    function Invoke-Retention([string[]]$Mode){$said=@(& pwsh -NoProfile -File $retScript -Clean -Retention -Vault $vault @Mode -Checkout $wb -Temporary $tmpRoot -Root $data 2>&1|ForEach-Object{"$_"});[pscustomobject]@{Exit=$LASTEXITCODE;Text=$said-join"`n"}}
    function Get-RetPackage([int]$Day){'orvion-backup-202601{0:00}T000000Z.7z' -f $Day}
    function Add-Package([string]$Name,[string[]]$Sidecars=@('.sha256','.secret-scan.txt')){Add-File (Join-Path $vault $Name) 'pkg';foreach($suffix in $Sidecars){Add-File (Join-Path $vault "$Name$suffix") $(if($suffix-ceq'.sha256'){('A'*64)+" *$Name`n"}else{'clean'})}}
    function Test-Unit([string]$Name){@('','.sha256','.secret-scan.txt'|Where-Object{Test-Path -LiteralPath (Join-Path $vault "$Name$_")}).Count}
    Assert-Refused 'Retention without Clean is refused' 'ORGANIZE_RETENTION_NEEDS: -Clean' @('-Check','-Retention','-Vault',$vault)
    Assert-Refused 'Retention without a vault is refused' 'ORGANIZE_RETENTION_NEEDS: -Vault' @('-Clean','-Retention','-DryRun')
    Assert-Refused 'a missing vault is refused' 'ORGANIZE_PLACE_UNAVAILABLE: vault' @('-Clean','-Retention','-Vault',$vault,'-DryRun')
    [void][IO.Directory]::CreateDirectory($vault)
    Assert-Refused 'Retention needs one of DryRun and Apply' 'ORGANIZE_RETENTION_NEEDS: exactly one' @('-Clean','-Retention','-Vault',$vault)
    Assert-Refused 'Retention takes no ListUncited' 'ORGANIZE_RETENTION_NEEDS: exactly one' @('-Clean','-Retention','-Vault',$vault,'-DryRun','-ListUncited')
    foreach($day in 1..10){Add-Package (Get-RetPackage $day)}
    foreach($suffix in '','.sha256','.secret-scan.txt'){if([Rp]::Set((Join-Path $vault "$(Get-RetPackage 1)$suffix"),0x1234)){throw 'FIXTURE_PLACEHOLDER_FAILED'}}
    $others='Restore-ORVION.cmd','Restore-ORVION.ps1','notes.txt','orvion-backup-old.7z','orvion-backup-0.7z','continuity\keep.txt','step3-x\keep.txt'
    foreach($name in $others){Add-File (Join-Path $vault $name)}
    $vaultLink=Join-Path $vault 'orvion-backup-20200101T000000Z.7z';[void](New-Item -ItemType Junction -Path $vaultLink -Target $wb)
    [IO.File]::AppendAllText($retRunbook,"Restore from $(Get-RetPackage 2).`n")
    $dry=Invoke-Retention '-DryRun'
    Assert-That 'DryRun lists each unit past the last 7 and what is kept' ($dry.Exit-eq0-and$dry.Text-cmatch"(?m)^DELETE retention vault:$([regex]::Escape((Get-RetPackage 1))) bytes=\d+ -$"-and$dry.Text-cmatch"(?m)^DELETE retention vault:$([regex]::Escape((Get-RetPackage 3))) bytes=3 $('A'*64)$"-and$dry.Text-cmatch"(?m)^KEPT retention vault:$([regex]::Escape((Get-RetPackage 2))) NAMED workbench:docs/RUNBOOK\.md$"-and$dry.Text-cmatch'(?m)^CLEAN dryrun delete=6 refused=0$')
    Assert-That 'DryRun deletes nothing and logs nothing' (!@(1..10|Where-Object{(Test-Unit (Get-RetPackage $_))-ne3}).Count-and!(Test-Path -LiteralPath $retLog))
    $applied=Invoke-Retention '-Apply'
    Assert-That 'Apply reports every deletion' ($applied.Exit-eq0-and@([regex]::Matches($applied.Text,'(?m)^DELETED retention vault:')).Count-eq6-and$applied.Text-cmatch'(?m)^CLEAN deleted=6 refused=0$')
    Assert-That 'Apply leaves the last 7 packages with their sidecars' (!@(4..10|Where-Object{(Test-Unit (Get-RetPackage $_))-ne3}).Count)
    Assert-That 'Apply deletes an older package' (!(Test-Path -LiteralPath (Join-Path $vault (Get-RetPackage 3))))
    Assert-That 'Apply deletes a cloud file' (!(Test-Path -LiteralPath (Join-Path $vault (Get-RetPackage 1))))
    Assert-That 'Apply deletes a package''s sidecars with it' (!(Test-Unit (Get-RetPackage 1))-and!(Test-Unit (Get-RetPackage 3)))
    Assert-That 'Apply keeps a package an active file names, with its sidecars' ((Test-Unit (Get-RetPackage 2))-eq3)
    Assert-That 'Apply leaves everything that is no package' (!@($others|Where-Object{!(Test-Path -LiteralPath (Join-Path $vault $_))}).Count-and(Test-Path -LiteralPath $vaultLink))
    $retRows=@(if(Test-Path -LiteralPath $retLog){Import-Csv -LiteralPath $retLog -Delimiter "`t"})
    Assert-That 'each deletion has one row in the retention log' ($retRows.Count-eq6-and!@($retRows|Where-Object{$_.action-cne'delete'-or$_.place-cne'vault'-or$_.reason-cne'retention'}).Count-and@($retRows|Where-Object{$_.from-ceq(Get-RetPackage 3)-and$_.sha256-ceq('A'*64)}).Count-eq1)
    Assert-That 'the tracked LOG.tsv stays as it was' ([IO.File]::ReadAllText($retLogPath)-ceq$retLogBefore)
    $again=Invoke-Retention '-Apply'
    Assert-That 'a second run has nothing to do' ($again.Exit-eq0-and$again.Text-cmatch'(?m)^CLEAN deleted=0 refused=0$')
    $sidecarNamed='orvion-backup-20251101T000000Z.7z';Add-Package $sidecarNamed;[IO.File]::AppendAllText($retRunbook,"Hash in $sidecarNamed.sha256 here`n")
    $seen=Invoke-Retention '-DryRun';Assert-That 'a sidecar an active file names keeps its package' ($seen.Text-cmatch"(?m)^KEPT retention vault:$([regex]::Escape($sidecarNamed)) NAMED workbench:docs/RUNBOOK\.md$")
    $pinned='orvion-backup-20251201T000000Z.7z';Add-Package $pinned;& attrib +P (Join-Path $vault $pinned)
    $seen=Invoke-Retention '-Apply';Assert-That 'a pinned package is kept and reported' ($seen.Exit-eq0-and$seen.Text-cmatch"(?m)^KEPT retention vault:$([regex]::Escape($pinned)) PINNED$"-and(Test-Unit $pinned)-eq3)
    & attrib -P (Join-Path $vault $pinned)
    $unverified='orvion-backup-20260201T000000Z.7z';Add-Package $unverified @('.secret-scan.txt')
    $seen=Invoke-Retention '-Apply';Assert-That 'a newest package with no hash refuses the vault part' ($seen.Exit-eq1-and$seen.Text-cmatch"(?m)^REFUSED retention vault:$([regex]::Escape($unverified)) ORGANIZE_RETENTION_NEWEST_UNVERIFIED$"-and(Test-Unit $pinned)-eq3)
    foreach($suffix in '','.secret-scan.txt'){[IO.File]::Delete((Join-Path $vault "$unverified$suffix"))}
    $seen=Invoke-Retention '-Apply';Assert-That 'an unpinned package goes on the next run' ($seen.Exit-eq0-and!(Test-Unit $pinned))
    $orphan='orvion-backup-20251002T000000Z.7z.sha256';Add-File (Join-Path $vault $orphan) 'x'
    $seen=Invoke-Retention '-Apply';Assert-That 'an orphan sidecar is kept and reported' ($seen.Exit-eq0-and$seen.Text-cmatch"(?m)^KEPT retention vault:$([regex]::Escape($orphan)) ORPHAN_SIDECAR$"-and(Test-Path -LiteralPath (Join-Path $vault $orphan)))
    $linked='orvion-backup-20251003T000000Z.7z';Add-Package $linked @('.secret-scan.txt');[void](New-Item -ItemType Junction -Path (Join-Path $vault "$linked.sha256") -Target $wb)
    $seen=Invoke-Retention '-Apply';Assert-That 'a link in a unit refuses that unit' ($seen.Exit-eq1-and$seen.Text-cmatch"(?m)^REFUSED retention vault:$([regex]::Escape($linked)) ORGANIZE_LINK_REFUSED$"-and(Test-Path -LiteralPath (Join-Path $vault $linked)))
    [IO.Directory]::Delete((Join-Path $vault "$linked.sha256"));foreach($suffix in '','.secret-scan.txt'){[IO.File]::Delete((Join-Path $vault "$linked$suffix"))}
    # Transcripts past 60 days, whole units, and the index row stays.
    $project=Join-Path $data 'sessions\raw\claude\C--x-ORVION';$noSource=Join-Path $t 'no-source'
    function Add-Transcript([string]$Path,[int]$Age){Add-File $Path ('{"timestamp":"2026-01-01T00:00:00Z","type":"user","message":{"role":"user","content":"x"}}'+"`n");(Get-Item -LiteralPath $Path).LastWriteTimeUtc=[DateTime]::UtcNow.AddDays(-$Age)}
    function Get-RetId([int]$N){'11111111-0000-4000-8000-00000000000'+$N}
    Add-Transcript (Join-Path $project "$(Get-RetId 1).jsonl") 61;Add-Transcript (Join-Path $project "$(Get-RetId 1)\subagents\a.jsonl") 61;Add-Transcript (Join-Path $project "$(Get-RetId 1).replaced-20260101000000000.jsonl") 61
    Add-Transcript (Join-Path $project "$(Get-RetId 2).jsonl") 59
    Add-Transcript (Join-Path $project "$(Get-RetId 3).jsonl") 61;Add-Transcript (Join-Path $project "$(Get-RetId 3)\subagents\a.jsonl") 1
    Add-Transcript (Join-Path $project "$(Get-RetId 4).jsonl") 61;[IO.File]::AppendAllText($retRunbook,"See $(Get-RetId 4).jsonl here.`n")
    Add-Transcript (Join-Path $project "$(Get-RetId 5).jsonl") 61
    $codexFile=Join-Path $data "sessions\raw\codex\2026\01\01\rollout-2026-01-01T00-00-00-$(Get-RetId 6).jsonl";Add-Transcript $codexFile 61
    $memoryCopy=Join-Path $project 'memory\old.md';Add-Transcript $memoryCopy 61
    $retJournal=Join-Path $data 'events\events.jsonl'
    [IO.File]::WriteAllText($retJournal,((@{pattern='p5';at='2026-01-01';evidence="sessions\raw\claude\C--x-ORVION\$(Get-RetId 5).jsonl"}|ConvertTo-Json -Compress)+"`n"+(@{pattern='p0';at='2026-01-01';evidence='sessions\raw'}|ConvertTo-Json -Compress)+"`n"))
    $null=& pwsh -NoProfile -File (Join-Path $retLib 'Sync-Sessions.ps1') -Root $data -ClaudeProjects $noSource -CodexSessions $noSource;if($LASTEXITCODE){throw 'FIXTURE_INDEX_FAILED'}
    $indexFile=Join-Path $data 'sessions\index.jsonl';$indexBefore=[IO.File]::ReadAllText($indexFile)
    $dry=Invoke-Retention '-DryRun'
    Assert-That 'DryRun lists a transcript past the line' ($dry.Exit-eq0-and$dry.Text-cmatch"(?m)^DELETE retention data:sessions/raw/claude/C--x-ORVION/$(Get-RetId 1)\.jsonl bytes=\d+ [0-9A-F]{64}$")
    Assert-That 'DryRun deletes no transcript and leaves the index' ((Test-Path -LiteralPath (Join-Path $project "$(Get-RetId 1).jsonl"))-and[IO.File]::ReadAllText($indexFile)-ceq$indexBefore)
    $applied=Invoke-Retention '-Apply'
    Assert-That 'Apply deletes a transcript past the line, its copy and its folder' ($applied.Exit-eq0-and!@("$(Get-RetId 1).jsonl","$(Get-RetId 1).replaced-20260101000000000.jsonl",(Get-RetId 1)|Where-Object{Test-Path -LiteralPath (Join-Path $project $_)}).Count)
    Assert-That 'Apply deletes a Codex transcript past the line' (!(Test-Path -LiteralPath $codexFile))
    Assert-That 'a transcript inside 60 days stays' (Test-Path -LiteralPath (Join-Path $project "$(Get-RetId 2).jsonl"))
    Assert-That 'a unit with a fresh companion stays' (Test-Path -LiteralPath (Join-Path $project "$(Get-RetId 3).jsonl"))
    Assert-That 'a transcript an active file names is kept and reported' ($applied.Text-cmatch"(?m)^KEPT retention data:sessions/raw/claude/C--x-ORVION/$(Get-RetId 4)\.jsonl NAMED workbench:docs/RUNBOOK\.md$"-and(Test-Path -LiteralPath (Join-Path $project "$(Get-RetId 4).jsonl")))
    Assert-That 'a transcript the evidence cites is kept and reported' ($applied.Text-cmatch"(?m)^KEPT retention data:sessions/raw/claude/C--x-ORVION/$(Get-RetId 5)\.jsonl CITED$"-and(Test-Path -LiteralPath (Join-Path $project "$(Get-RetId 5).jsonl")))
    Assert-That 'a memory copy past the line is no transcript' (Test-Path -LiteralPath $memoryCopy)
    $retIndex=@([IO.File]::ReadAllLines($indexFile)|Where-Object{$_}|ForEach-Object{$_|ConvertFrom-Json})
    $goneRow=@($retIndex|Where-Object id -ceq (Get-RetId 1))[0];$stayRow=@($retIndex|Where-Object id -ceq (Get-RetId 2))[0]
    Assert-That 'the index keeps a deleted transcript''s row, with an empty raw path and its bytes' ($goneRow-and$goneRow.raw-ceq''-and$goneRow.bytes-gt0-and$stayRow.raw)
    Assert-That 'transcript deletions are in the retention log' (@(Import-Csv -LiteralPath $retLog -Delimiter "`t"|Where-Object{$_.place-ceq'data'-and$_.from-clike"*$(Get-RetId 1).jsonl"-and$_.sha256-cmatch'^[0-9A-F]{64}$'}).Count-eq1)
    Add-Transcript (Join-Path $project "$(Get-RetId 7).jsonl") 61
    $held=[Threading.Mutex]::new($true,$lockName)
    try{$busy=Invoke-Retention '-Apply'}finally{$held.ReleaseMutex();$held.Dispose()}
    Assert-That 'a busy sync lock keeps the transcript for the next run' ($busy.Exit-eq0-and$busy.Text-cmatch"(?m)^KEPT retention data:sessions/raw/claude/C--x-ORVION/$(Get-RetId 7)\.jsonl SYNC_UNAVAILABLE$"-and(Test-Path -LiteralPath (Join-Path $project "$(Get-RetId 7).jsonl")))
    $seen=Invoke-Retention '-Apply';Assert-That 'the next run deletes it' ($seen.Exit-eq0-and!(Test-Path -LiteralPath (Join-Path $project "$(Get-RetId 7).jsonl")))
    [IO.File]::WriteAllText($retRunbook,$retKept);[IO.File]::WriteAllText($retJournal,'')
    $made=Invoke-Tool -Refresh;if($made.Exit){throw "FIXTURE_REFRESH_FAILED $($made.Text)"}
    Assert-Passes 'Check holds the retention log and an empty raw path to their schemas'
    Add-File $retLog ([IO.File]::ReadAllText($retLog)+"2026-01-01T00:00:00Z`tdelete`tnowhere`tx`t-`t-`tretention`t-`n")
    $checked=Invoke-Tool -Check;Assert-That 'Check refuses a retention log row off its enum' ($checked.Exit-eq1-and$checked.Text-cmatch'(?m)^BAD_TSV data:work/retention-log\.tsv:\d+ place nowhere$')
    Get-ChildItem $vault -Recurse -Force -Attributes ReparsePoint|ForEach-Object{if($_.PSIsContainer){[IO.Directory]::Delete($_.FullName,$false)}else{[IO.File]::Delete($_.FullName)}}
    [IO.Directory]::Delete($vault,$true);[IO.Directory]::Delete((Join-Path $data 'sessions\raw'),$true);foreach($name in $retLog,$indexFile,(Join-Path $data 'sessions\INDEX.md')){[IO.File]::Delete($name)}
    $made=Invoke-Tool -Refresh;if($made.Exit){throw "FIXTURE_REFRESH_FAILED $($made.Text)"}
    Assert-Passes 'the fixture passes after the retention cases'
    if($RetentionOnly){if($fail){throw "ORGANIZE_RETENTION_FAILED $fail"};'ORGANIZE_RETENTION PASS';return}

    # -Map: only an "Organize -Map" row acts, through its machine columns; what cannot run is BLOCKED and the rest goes on.
    $mapFile=Join-Path $t 'map.tsv';$by='Organize -Map (P7)';$runbookFile=Join-Path $wb 'docs/RUNBOOK.md';$logFile=Join-Path $wb 'docs\history\LOG.tsv'
    function Set-Map([string[]]$Rows,[string]$Header="ID`tBy`tItem`tAction`tResult`tStatus`tFrom`tTo"){[IO.File]::WriteAllText($mapFile,(@($Header)+$Rows)-join"`n")}
    foreach($name in 'map-one','map-two','map-three','map-named','map-four','owner-map'){Add-File (Join-Path $data "records/$name/a.txt")}
    $bookKept=[IO.File]::ReadAllText($runbookFile);[IO.File]::AppendAllText($runbookFile,"See data/records/map-one/a.txt and data/records/map-named/a.txt.`n")
    Set-Map @("R1`t$by`tsome prose`tMOVE`tprose`tREADY`t`t","R2`t$by`tp`tSPLIT`tp`tREADY`t`t","R3`t$by`tp`tMOVE`tp`tHOLD`tdata\records\map-three`tdata\records\map-held","R4`t$by`tp`tDELETE`tp`tREADY`tdata\records\map-named`t","R5`t$by`tp`tDELETE`tp`tREADY`tdata\records\owner-map`t","R6`t$by`tp`tDELETE`tp`tREADY`tdata\records\map-absent`t","R7`tby hand (P1.6)`tp`tDELETE`tp`tREADY`tdata\records\map-three`t","R8`t$by`tp`tMOVE`tp`tREADY`tdata\records\map-one`tdata\records\map-moved","R9`t$by`tp`tDELETE`tp`tREADY`tdata\records\map-two`t","R10`t$by`tp`tNONE`tp`tREADY`t`t")
    $logBefore=[IO.File]::ReadAllLines($logFile).Count;$bookBefore=[IO.File]::ReadAllText($runbookFile)
    $map=Invoke-Tool -Map $mapFile -DryRun
    foreach($blockedRow in @(@('R1','ORGANIZE_MAP_NO_PATHS'),@('R2','ORGANIZE_MAP_ACTION'),@('R3','ORGANIZE_MAP_STATUS'),@('R4','ORGANIZE_MAP_REFUSED: data:records/map-named NAMED workbench:docs/RUNBOOK\.md'),@('R5','ORGANIZE_MAP_PERMANENT'),@('R6','ORGANIZE_MAP_NO_SOURCE'))){Assert-That "Map blocks $($blockedRow[0]) with $($blockedRow[1])" ($map.Text-cmatch"(?m)^BLOCKED $($blockedRow[0]) $($blockedRow[1])")}
    Assert-That 'Map leaves a row another method runs alone' ($map.Text-cnotmatch'R7'-and$map.Text-cmatch'skipped=1')
    Assert-That 'Map dry run reports what it would do, exit 1 while a row is blocked' ($map.Exit-eq1-and$map.Text-cmatch'(?m)^OK R8 MOVE data:records/map-one -> data:records/map-moved \S+ refs=1 files=1$'-and$map.Text-cmatch'(?m)^OK R9 DELETE data:records/map-two bytes=1 '-and$map.Text-cmatch'(?m)^OK R10 NONE$'-and$map.Text-cmatch'(?m)^MAP dryrun ok=3 blocked=6 skipped=1$')
    Assert-That 'Map dry run changes nothing' ((Test-Path (Join-Path $data 'records/map-one/a.txt'))-and(Test-Path (Join-Path $data 'records/map-two/a.txt'))-and!(Test-Path (Join-Path $data 'records/map-moved'))-and[IO.File]::ReadAllLines($logFile).Count-eq$logBefore-and[IO.File]::ReadAllText($runbookFile)-ceq$bookBefore)
    $map=Invoke-Tool -Map $mapFile -Apply -Workstream 'WS-033' -Reason 'P7'
    $newRows=@([IO.File]::ReadAllLines($logFile)|Select-Object -Skip $logBefore|ForEach-Object{,$_.Split("`t")})
    Assert-That 'Map apply runs the ready rows past the blocked ones and reports them' ($map.Exit-eq1-and$map.Text-cmatch'(?m)^MAP APPLIED ok=3 blocked=6 skipped=1$'-and(Test-Path (Join-Path $data 'records/map-moved/a.txt'))-and!(Test-Path (Join-Path $data 'records/map-one'))-and!(Test-Path (Join-Path $data 'records/map-two')))
    Assert-That 'Map apply touches no blocked or skipped row' ((Test-Path (Join-Path $data 'records/map-three/a.txt'))-and(Test-Path (Join-Path $data 'records/map-named/a.txt'))-and(Test-Path (Join-Path $data 'records/owner-map/a.txt'))-and!(Test-Path (Join-Path $data 'records/map-held')))
    Assert-That 'Map apply writes one LOG row per action, with the row and the hash' ($newRows.Count-eq2-and$newRows[0][1]-ceq'move'-and$newRows[0][6]-ceq'R8: P7'-and$newRows[1][1]-ceq'delete'-and$newRows[1][6]-ceq'R9: P7'-and$newRows[1][7]-cmatch'^[0-9A-Fa-f]{64}$')
    Assert-That 'Map apply updates the references of a move' ([IO.File]::ReadAllText($runbookFile)-cmatch'data/records/map-moved/a\.txt'-and[IO.File]::ReadAllText($runbookFile)-cnotmatch'map-one')
    [IO.File]::WriteAllText($runbookFile,"$bookKept[x][r]`n`n[r]: ../data/records/map%2Dfour/a.txt`n");Set-Map @("R11`t$by`tp`tDELETE`tp`tREADY`tdata\records\map-four`t")
    $map=Invoke-Tool -Map $mapFile -Apply
    Assert-That 'Map apply reports a reference it broke' ($map.Exit-eq1-and$map.Text-cmatch'(?m)^MAP_BROKE BROKEN_LINK workbench:docs/RUNBOOK\.md -> \.\./data/records/map%2Dfour/a\.txt$'-and$map.Text-cmatch'(?m)^MAP APPLIED ok=1 blocked=0 skipped=0$')
    [IO.File]::WriteAllText($runbookFile,$bookKept);Set-Map @("R12`t$by`tp`tNONE`tp`tREADY")
    $map=Invoke-Tool -Map $mapFile -DryRun
    Assert-That 'a map with nothing blocked exits 0' ($map.Exit-eq0-and$map.Text-cmatch'(?m)^MAP dryrun ok=1 blocked=0 skipped=0$')
    Assert-Refused 'Map without -DryRun or -Apply' 'ORGANIZE_MAP_NEEDS' @('-Map',$mapFile)
    Assert-Refused 'Map with an absent file' 'ORGANIZE_MAP_BAD' @('-Map',(Join-Path $t 'absent.tsv'),'-DryRun')
    Assert-Refused 'Map beside another action' 'ORGANIZE_ACTION_REQUIRED' @('-Map',$mapFile,'-Check')
    Set-Map @("R13`t$by`tp`tNONE`tp") "ID`tBy`tItem`tAction`tResult"
    Assert-Refused 'Map without a Status column' 'ORGANIZE_MAP_BAD' @('-Map',$mapFile,'-DryRun')
    foreach($name in 'map-moved','map-three','map-named','owner-map'){Remove-Item -LiteralPath (Join-Path $data "records/$name") -Recurse -Force}
    $made=Invoke-Tool -Refresh;if($made.Exit){throw "FIXTURE_REFRESH_FAILED $($made.Text)"}
    Assert-Passes 'the fixture passes after the map cases'

    # Hunt Quick runs -Check (section 19): silent on a passing layout, a GAP naming the problem otherwise.
    $savedManaged=$env:WORKBENCH_TEMP_ROOT;$env:WORKBENCH_TEMP_ROOT=$tmpRoot
    try{
        $hunt=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $wb -DataRoot $data -Quick -NoRecord 2>&1)-join"`n"
        Assert-That 'Hunt Quick is silent on a passing layout' ($hunt-cmatch'HUNT '-and$hunt-cnotmatch'organize-check')
        Add-File (Join-Path $wb 'stray.txt')
        $hunt=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Hunt.ps1') -Root $wb -DataRoot $data -Quick -NoRecord 2>&1)-join"`n"
        Assert-That 'Hunt Quick reports a layout problem as a GAP' ($hunt-cmatch'GAP organize-check: 1 layout problem\(s\): \S+ workbench:/?stray\.txt')
    }finally{$env:WORKBENCH_TEMP_ROOT=$savedManaged;Remove-Item -LiteralPath (Join-Path $wb 'stray.txt') -Force -ErrorAction SilentlyContinue}
    Assert-Passes 'the fixture passes after the Hunt cases'
    if($MapOnly){if($fail){throw "ORGANIZE_MAP_FAILED $fail"};'ORGANIZE_MAP PASS';return}

    # -New: section 5's organizer, the parent's row, the LOG row.
    $w33=Join-Path $tmpRoot 'sb\W33'
    $made=Invoke-Tool -New $w33 -Kind 'active-workstream' -Purpose 'the active workstream.' -Reader 'the agent' -Lifetime 'until WS-033 is complete' -Workstream 'WS-033' -Reason 'starts'
    $readme=[IO.File]::ReadAllText((Join-Path $w33 'README.md'));$parent=[IO.File]::ReadAllText((Join-Path $tmpRoot 'sb\README.md'))
    Assert-That 'New writes section 5''s organizer' ($made.Exit-eq0-and$readme.StartsWith("# W33`n`nPurpose: the active workstream. Kind: active-workstream. Lifetime: until WS-033 is complete.`nReader: the agent.`nRules: ")-and$readme.Contains('<!-- organize:contents')-and$readme.Contains('<!-- organize:changes'))
    Assert-That 'New refreshes the parent from the child''s own header' ($parent-cmatch"\| W33/ \| active-workstream \| the active workstream \| the agent \| \d{4}-\d\d-\d\d \|")
    $logLines=[IO.File]::ReadAllLines((Join-Path $wb 'docs\history\LOG.tsv'));$cells=$logLines[-1].Split("`t")
    Assert-That 'New appends one LOG row of the eight columns' ($logLines[0]-ceq"utc`taction`tplace`tfrom`tto`tworkstream`treason`tsha256"-and$cells.Count-eq8-and$cells[1]-ceq'new'-and$cells[2]-ceq'temporary'-and$cells[3]-ceq'-'-and$cells[4]-ceq'sb/W33'-and$cells[5]-ceq'WS-033'-and$cells[6]-ceq'starts'-and$cells[0]-cmatch'^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\dZ$')
    Assert-That 'the parent''s changes table shows the new folder' ($parent-cmatch'\| new \| - \| sb/W33 \| starts \|')
    Assert-Passes 'a folder made with New passes Check'

    # -New refusals.
    $before=[IO.File]::ReadAllBytes((Join-Path $wb 'docs\history\LOG.tsv')).Length
    $refusals=@(
        ,@('an unknown kind','ORGANIZE_KIND_UNKNOWN',@('-New',(Join-Path $tmpRoot 'sb\W34'),'-Kind','stuff','-Purpose','p','-Reader','r'))
        ,@('a path outside every place','ORGANIZE_OUTSIDE_PLACE',@('-New',(Join-Path $t 'elsewhere'),'-Kind','scratch','-Purpose','p','-Reader','r'))
        ,@('a name no rule allows','ORGANIZE_NOT_MANAGED',@('-New',(Join-Path $wb 'records\notes'),'-Kind','records','-Purpose','p','-Reader','r'))
        ,@('an existing organizer','ORGANIZE_ORGANIZER_EXISTS',@('-New',$w33,'-Kind','scratch','-Purpose','p','-Reader','r'))
        ,@('a folder with its own README','ORGANIZE_NO_ORGANIZER_HERE',@('-New',(Join-Path $wb 'lib'),'-Kind','tool','-Purpose','p','-Reader','r'))
        ,@('a line break in the text','ORGANIZE_TEXT_REFUSED',@('-New',(Join-Path $tmpRoot 'sb\W34'),'-Kind','scratch','-Purpose',"p`nq",'-Reader','r'))
        ,@('a marker in the text','ORGANIZE_TEXT_REFUSED',@('-New',(Join-Path $tmpRoot 'sb\W34'),'-Kind','scratch','-Purpose','p','-Reader','<!-- r'))
        ,@('a header word in the text','ORGANIZE_TEXT_REFUSED',@('-New',(Join-Path $tmpRoot 'sb\W34'),'-Kind','scratch','-Purpose','p Kind: x','-Reader','r'))
        ,@('a missing field','ORGANIZE_NEW_NEEDS',@('-New',(Join-Path $tmpRoot 'sb\W34'),'-Kind','scratch','-Purpose','p'))
    )
    foreach($case in $refusals){
        $refused=@(& pwsh -NoProfile -File $script @($case[2]) -Checkout $wb -Temporary $tmpRoot -Root $data 2>&1|ForEach-Object{"$_"});$code=$LASTEXITCODE
        Assert-That "New refuses $($case[0])" ($code-ne0-and($refused-join"`n")-cmatch$case[1])
    }
    Assert-That 'a refused New writes no folder and no LOG row' (!(Test-Path -LiteralPath (Join-Path $tmpRoot 'sb\W34'))-and[IO.File]::ReadAllBytes((Join-Path $wb 'docs\history\LOG.tsv')).Length-eq$before)
    $bare=Join-Path $t 'tp-bare';[void][IO.Directory]::CreateDirectory($bare)
    $refused=@(& pwsh -NoProfile -File $script -New (Join-Path $bare 'sb\W34') -Kind scratch -Purpose p -Reader r -Checkout $wb -Temporary $bare -Root $data 2>&1|ForEach-Object{"$_"})
    Assert-That 'New refuses a missing parent' ($LASTEXITCODE-ne0-and($refused-join"`n")-cmatch'ORGANIZE_PARENT_MISSING')
    $target=Join-Path $t 'link-target';[void][IO.Directory]::CreateDirectory($target)
    $linkedSb=Join-Path $bare 'sb';$null=New-Item -ItemType Junction -Path $linkedSb -Target $target
    $refused=@(& pwsh -NoProfile -File $script -New (Join-Path $linkedSb 'W34') -Kind scratch -Purpose p -Reader r -Checkout $wb -Temporary $bare -Root $data 2>&1|ForEach-Object{"$_"})
    Assert-That 'New refuses a path through a junction and writes nothing behind it' ($LASTEXITCODE-ne0-and($refused-join"`n")-cmatch'ORGANIZE_LINK_REFUSED'-and!@(Get-ChildItem -LiteralPath $target -Force).Count)
    [IO.Directory]::Delete($linkedSb);[IO.Directory]::Delete($bare)
    $none=@(& pwsh -NoProfile -File $script -Checkout $wb 2>&1|ForEach-Object{"$_"})
    Assert-That 'no action is refused' ($LASTEXITCODE-ne0-and($none-join"`n")-cmatch'ORGANIZE_ACTION_REQUIRED')
    $two=@(& pwsh -NoProfile -File $script -Check -Refresh -Checkout $wb 2>&1|ForEach-Object{"$_"})
    Assert-That 'two actions are refused' ($LASTEXITCODE-ne0-and($two-join"`n")-cmatch'ORGANIZE_ACTION_REQUIRED')

    # -Refresh: the rows, byte-stable and without opening what it must not.
    Add-File (Join-Path $data 'records/first.ps1') "# the first comment line`nsecond`n"
    $cloud=Join-Path $data 'records/cloud.md';Add-File $cloud "# must-stay-unread`n";[IO.File]::SetAttributes($cloud,[IO.File]::GetAttributes($cloud)-bor[IO.FileAttributes]::Offline)
    $outsideFolder=Join-Path $t 'outside';Add-File (Join-Path $outsideFolder 'README.md') "# o`n`nPurpose: must-stay-unread. Kind: scratch. Lifetime: permanent.`nReader: r.`nRules: r.`n"
    $null=New-Item -ItemType Junction -Path (Join-Path $data 'records/linked') -Target $outsideFolder
    $made=Invoke-Tool -Refresh;$records=[IO.File]::ReadAllText((Join-Path $data 'records\README.md'));$docs=[IO.File]::ReadAllText((Join-Path $wb 'docs\README.md'))
    $second=Invoke-Tool -Refresh
    Assert-That 'Refresh writes nothing the second time' ($second.Exit-eq0-and$second.Text-cmatch'REFRESHED 0 of \d+ organizers')
    Assert-That 'a Markdown child gives its Purpose line and Reader, a pipe escaped' ($docs-cmatch'\| RUNBOOK\.md \| reference \| a RUNBOOK\.md with a \\\| pipe\. \| the owner\. \| - \|')
    Assert-That 'a Markdown child without Purpose gives its title' ($docs-cmatch'\| WORKSPACE-LAYOUT\.md \| reference \| The layout \| - \| - \|')
    Assert-That 'a tool gives its first comment line' ($records-cmatch'\| first\.ps1 \| live-data \| the first comment line \| - \| - \|')
    Assert-That 'a managed child gives its own header' ($docs-cmatch'\| history/ \| reference \| the history folder \| the fixture \| \d{4}')
    Assert-That 'sealed content is one row and nothing inside it is indexed' ($records-cmatch'\| old-folder/ \| sealed \| - \| - \| - \|'-and$records-cnotmatch'deep')
    Assert-That 'a cloud-only file is a row and is never opened' ($records-cmatch'\| cloud\.md \| live-data \| - \| - \| - \|'-and$records-cnotmatch'must-stay-unread')
    Assert-That 'a junction is a link row and is not followed' ($records-cmatch'\| linked/ \| link \| - \| - \| - \|'-and$records-cnotmatch'must-stay-unread')
    Assert-That 'the organizer does not list itself' ($records-cnotmatch'\| README\.md \|')
    [IO.Directory]::Delete((Join-Path $data 'records/linked'));[IO.File]::SetAttributes($cloud,[IO.FileAttributes]::Normal);[IO.File]::Delete($cloud);[IO.File]::Delete((Join-Path $data 'records/first.ps1'))
    $crlfPath=Join-Path $wb 'docs\owner\README.md';[IO.File]::WriteAllText($crlfPath,[IO.File]::ReadAllText($crlfPath).Replace("`n","`r`n"))
    $null=Invoke-Tool -Refresh;$crlf=[IO.File]::ReadAllText($crlfPath)
    Assert-That 'Refresh keeps a file''s line endings' ($crlf.Contains("`r`n")-and!($crlf-replace"`r`n",'').Contains("`n"))
    [IO.File]::WriteAllText($crlfPath,$crlf.Replace("`r`n","`n"))
    $logPath=Join-Path $wb 'docs\history\LOG.tsv';$logText=[IO.File]::ReadAllText($logPath)
    [IO.File]::AppendAllText($logPath,(@(1..12|ForEach-Object{"2026-11-02T00:00:$('{0:00}' -f $_)Z`tmove`tworkbench`trecords/WS-0$('{0:00}' -f $_)`tdocs/history/item$_`t-`trow-$_`t-"})-join"`n")+"`n")
    $null=Invoke-Tool -Refresh;$history=[IO.File]::ReadAllText((Join-Path $wb 'docs\history\README.md'))
    Assert-That 'the changes table holds the last 10 rows of this folder' ($history-cmatch'\| row-12 \|'-and$history-cmatch'\| row-3 \|'-and$history-cnotmatch'\| row-2 \|'-and@([regex]::Matches($history,'\| row-\d+ \|')).Count-eq10)
    [IO.File]::AppendAllText($logPath,"2025-01-02T00:00:00Z`tmove`tworkbench`told/x`tdocs/RECOVERY.md`t-`tmoved`t-`n1999-01-02T00:00:00Z`tmove`ttemporary`told/y`tdocs/RECOVERY.md`t-`telsewhere`t-`n")
    $null=Invoke-Tool -Refresh;$docs=[IO.File]::ReadAllText((Join-Path $wb 'docs\README.md'))
    Assert-That 'Updated is the child''s last LOG row of its own place' ($docs-cmatch'\| RECOVERY\.md \|[^\n]*\| 2025-01-02 \|')
    Add-File (Join-Path $data 'work/a.txt');Add-File (Join-Path $data 'work/B.txt');$null=Invoke-Tool -Refresh;$workPage=[IO.File]::ReadAllText((Join-Path $data 'work\README.md'))
    Assert-That 'children sort ordinally, on every machine' ($workPage.IndexOf('| B.txt |')-ge0-and$workPage.IndexOf('| B.txt |')-lt$workPage.IndexOf('| a.txt |'))
    [IO.File]::Delete((Join-Path $data 'work/a.txt'));[IO.File]::Delete((Join-Path $data 'work/B.txt'))
    [IO.File]::WriteAllText($logPath,$logText);$null=Invoke-Tool -Refresh
    Assert-Passes 'the fixture passes again after the refresh cases'

    # -Check: one hand-made change, one finding of its own code.
    $hand=Join-Path $wb 'docs\notes.txt';Add-File $hand;$null=Invoke-Tool -Refresh;Assert-Finds 'an item the layout does not draw is reported' 'UNKNOWN workbench:docs/notes\.txt';[IO.File]::Delete($hand);$null=Invoke-Tool -Refresh
    $area=Join-Path $tmpRoot 'rt';[void][IO.Directory]::CreateDirectory($area);$null=Invoke-Tool -Refresh;Assert-Finds 'a temporary area that is not drawn is reported' 'UNKNOWN temporary:/rt/';[IO.Directory]::Delete($area);$null=Invoke-Tool -Refresh
    $moved=Join-Path $wb 'docs\RUNBOOK.md';$kept=[IO.File]::ReadAllText($moved);[IO.File]::Delete($moved);$null=Invoke-Tool -Refresh;Assert-Finds 'a drawn item that is gone is reported' 'MISSING workbench:docs/RUNBOOK\.md';[IO.File]::WriteAllText($moved,$kept);$null=Invoke-Tool -Refresh
    $page=Join-Path $wb 'docs\owner\README.md';$kept=[IO.File]::ReadAllText($page);[IO.File]::Delete($page);$null=Invoke-Tool -Refresh;Assert-Finds 'a managed folder without its organizer is reported' 'NO_ORGANIZER workbench:docs/owner';[IO.File]::WriteAllText($page,$kept);$null=Invoke-Tool -Refresh
    [IO.File]::WriteAllText($page,$kept.Replace('Kind: reference.','Kind: stuff.'));$null=Invoke-Tool -Refresh;Assert-Finds 'an unknown kind in a header is reported' 'BAD_ORGANIZER workbench:docs/owner header';[IO.File]::WriteAllText($page,$kept);$null=Invoke-Tool -Refresh
    [IO.File]::WriteAllText($page,$kept.Replace('<!-- /organize:changes -->',''));Assert-Finds 'a lost marker is reported' 'BAD_ORGANIZER workbench:docs/owner markers';[IO.File]::WriteAllText($page,$kept)
    $index=Join-Path $wb 'config\README.md';$kept=[IO.File]::ReadAllText($index);[IO.File]::Delete($index);Assert-Finds 'a tool-index folder without its README is reported' 'NO_ORGANIZER workbench:config';[IO.File]::WriteAllText($index,$kept)
    $old=Join-Path $tmpRoot 'cx\W33-old';[void][IO.Directory]::CreateDirectory($old);Assert-Finds 'a forbidden name is reported' 'NAME temporary:cx/W33-old/';[IO.Directory]::Delete($old)
    $draft=Join-Path $tmpRoot 'cx\W33-v1';[void][IO.Directory]::CreateDirectory($draft);Assert-Passes 'a Draft version may be a clone''s role';[IO.Directory]::Delete($draft)
    $held=Join-Path $wb 'docs\owner\20261102-v2';[void][IO.Directory]::CreateDirectory($held);$null=Invoke-Tool -Refresh;Assert-Finds 'a version as any other name is reported' 'NAME workbench:docs/owner/20261102-v2/';[IO.Directory]::Delete($held);$null=Invoke-Tool -Refresh
    $bad=Join-Path $tmpRoot 'scratch\my run';[void][IO.Directory]::CreateDirectory($bad);Assert-Finds 'a name outside the fixed form is reported' 'UNKNOWN temporary:scratch/my run/';[IO.Directory]::Delete($bad)
    $null=New-Item -ItemType Junction -Path (Join-Path $tmpRoot 'cx\W33-link') -Target $target;Assert-Finds 'a link in a managed folder is reported' 'LINK temporary:cx/W33-link/';[IO.Directory]::Delete((Join-Path $tmpRoot 'cx\W33-link'))
    $kept=Join-Path $tmpRoot 'retired\left.txt';Add-File $kept;Assert-Finds 'retired, kept empty, reports what it holds' 'UNKNOWN temporary:retired/left\.txt';[IO.File]::Delete($kept)
    $hand=Join-Path $wb 'records\WS-099';Add-File (Join-Path $hand 'README.md') ([IO.File]::ReadAllText((Join-Path $tmpRoot 'sb\W33\README.md')));$null=Invoke-Tool -Refresh;Assert-Finds 'a hand-made managed folder has no LOG row' 'NO_LOG_ROW workbench:records/WS-099'
    $page=Join-Path $wb 'records\README.md';$kept=[IO.File]::ReadAllText($page);[IO.Directory]::Delete($hand,$true)
    Assert-Finds 'a table row with no child is reported' 'NO_SUCH_CHILD workbench:records/WS-099/';$null=Invoke-Tool -Refresh
    $hand=Join-Path $tmpRoot 'sb\W77';[void][IO.Directory]::CreateDirectory($hand);$checked=Invoke-Tool -Check
    Assert-That 'a hand-made folder is caught: no organizer, no LOG row, missing from its parent' ($checked.Exit-eq1-and$checked.Text-cmatch'(?m)^NO_ORGANIZER temporary:sb/W77$'-and$checked.Text-cmatch'(?m)^NO_LOG_ROW temporary:sb/W77$'-and$checked.Text-cmatch'(?m)^MISSING_FROM_PARENT temporary:sb/W77/$');[IO.Directory]::Delete($hand)
    $run=Join-Path $tmpRoot 'scratch\W33-20261102T000000Z-run';[void][IO.Directory]::CreateDirectory($run);Assert-Passes 'a Live area needs no row for a tool''s run folder';[IO.Directory]::Delete($run)
    $pad=240-$wb.Length-'\lib\test-.ps1'.Length;$long=Join-Path $wb ('lib\test-'+('l'*$pad)+'.ps1');Add-File $long;$checked=Invoke-Tool -Check;Assert-That 'a checkout path of 240 characters is reported' ($long.Length-eq240-and$checked.Exit-eq1-and$checked.Text.Contains("TOO_LONG $long"))
    $short=Join-Path $wb ('lib\test-'+('l'*($pad-1))+'.ps1');[IO.File]::Move($long,$short);Assert-Passes 'a path of 239 characters is not';[IO.File]::Delete($short)
    $pad=240-$data.Length-'\work\.txt'.Length;$long=Join-Path $data ('work\'+('d'*$pad)+'.txt');Add-File $long;$checked=Invoke-Tool -Check;Assert-That 'a data path of 240 characters is reported' ($checked.Exit-eq1-and$checked.Text.Contains("TOO_LONG $long"));[IO.File]::Delete($long)

    # -Check: broken references in active files. Each appended line is one hand-made break, undone at once.
    $runbook=Join-Path $wb 'docs\RUNBOOK.md';$tool=Join-Path $wb 'lib\Tool.ps1';$nowFile=Join-Path $data 'work\NOW.md';Add-File $nowFile "# NOW`n";$null=Invoke-Tool -Refresh
    Assert-TextFinds 'a broken link is reported' $runbook '[x](gone.md)' 'BROKEN_LINK workbench:docs/RUNBOOK\.md -> gone\.md'
    Assert-TextFinds 'a broken anchor is reported' $runbook '[x](RECOVERY.md#nowhere)' 'BROKEN_ANCHOR workbench:docs/RUNBOOK\.md -> RECOVERY\.md#nowhere'
    Assert-TextPasses 'a link, its anchor and a URI pass' $runbook '[x](RECOVERY.md#recoverymd) and [y](https://example.invalid/gone)'
    Assert-TextFinds 'a reference link with no definition is reported' $runbook '[x][nope]' 'BROKEN_LINK workbench:docs/RUNBOOK\.md MD_REFERENCE_MISSING: nope'
    Assert-TextFinds 'a named path that is gone is reported' $runbook 'see docs/nowhere.md.' 'BROKEN_PATH workbench:docs/RUNBOOK\.md docs/nowhere\.md'
    Assert-TextFinds 'a named data path that is gone is reported' $runbook 'see data/nowhere/x.md' 'BROKEN_PATH workbench:docs/RUNBOOK\.md data/nowhere/x\.md'
    Assert-TextFinds 'a named temporary path that is gone is reported' $runbook 'see ORVION-Workbench-temporary/cx/W33-gone/x' 'BROKEN_PATH workbench:docs/RUNBOOK\.md ORVION-Workbench-temporary/cx/W33-gone/x'
    Assert-TextFinds 'a records path in neither place is reported' $runbook 'see records/nowhere.txt' 'BROKEN_PATH workbench:docs/RUNBOOK\.md records/nowhere\.txt'
    Assert-TextPasses 'a pattern, a variable, a records path of either place and a dropped .md pass' $runbook 'sb/W<NN>/ docs/W<NN>-x.md lib/$name.ps1 data/records/* records/old-folder/deep/a.txt data/records/old-folder/deep/a.txt lib/README ORVION-Workbench-temporary/tmp/README.md temporary/tmp/README.md'
    $memo=Join-Path $data 'claude-memory\m.md';Add-File $memo 'see data/trigger/function/view and temporary/reversible and docs/gone-x.md';$checked=Invoke-Tool -Check;Assert-That 'memory prose without an extension is no path, a missing .md in memory still is' ($checked.Text-cnotmatch'BROKEN_PATH data:claude-memory/m\.md data/trigger'-and$checked.Text-cnotmatch'BROKEN_PATH data:claude-memory/m\.md temporary/reversible'-and$checked.Text-cmatch'(?m)^BROKEN_PATH data:claude-memory/m\.md docs/gone-x\.md$');[IO.File]::Delete($memo);[IO.Directory]::Delete((Split-Path $memo -Parent))
    Assert-TextFinds 'NOW.md is an active file' $nowFile 'see docs/nowhere.md' 'BROKEN_PATH data:work/NOW\.md docs/nowhere\.md'
    Assert-TextFinds 'an organizer''s own prose is an active file' (Join-Path $wb 'docs\README.md') '[x](gone.md)' 'BROKEN_LINK workbench:docs/README\.md -> gone\.md'
    Assert-TextFinds 'a tool naming a file that is gone is reported' $tool '# see ''docs/nowhere.md''' 'BROKEN_PATH workbench:lib/Tool\.ps1 docs/nowhere\.md'
    Assert-TextPasses 'a tool''s path without an extension is not' $tool '# see ''docs/nowhere'''
    $fixtureTest=Join-Path $wb 'lib\test-fixture.ps1';Add-File $fixtureTest "'docs/nowhere.md' DEC-$(99)`n";Assert-Passes 'a test''s strings are its fixtures';[IO.File]::Delete($fixtureTest)
    Assert-TextFinds 'a citation of no section is reported' $runbook "WORKFLOW.md section $(9)" 'BROKEN_CITATION workbench:docs/RUNBOOK\.md MD_SECTION_MISSING: .*'
    Assert-TextFinds 'a decision that does not exist is reported' $runbook "DEC-$(99)" 'BROKEN_CITATION workbench:docs/RUNBOOK\.md MD_SECTION_MISSING: .*'
    Assert-TextFinds 'a citation of the router is reported' $runbook "README.md section $(1)" 'BROKEN_CITATION workbench:docs/RUNBOOK\.md MD_ROUTER_HOP: .*'
    Assert-TextFinds 'a section without its ID is reported' $runbook '## no id' 'BROKEN_SECTION MD_SECTION_ID: .*'
    $contract=Join-Path $wb 'changes\WS-001-first.md';Assert-TextPasses 'a frozen text is not checked' $contract "[x](gone.md) docs/nowhere.md DEC-$(99)"
    $bytesFile=Join-Path $wb 'lib\Latin.md';[IO.File]::WriteAllBytes($bytesFile,[byte[]](0x23,0x20,0xFF,0x0A));Add-File (Join-Path $wb 'lib\README.md') "# README`nLatin.md`n"
    Assert-Finds 'an active file that is not UTF-8 is reported' 'UNREADABLE_ACTIVE workbench:lib/Latin\.md'
    # -Check: orphans.
    [IO.File]::Delete($bytesFile);Add-File (Join-Path $wb 'lib\README.md') "# lib/README.md`n"
    $orphan=Join-Path $wb 'lib\Unused.ps1';Add-File $orphan '# Unused.ps1 names only itself';Assert-Finds 'a tool no active file names is an orphan' 'ORPHAN workbench:lib/Unused\.ps1';[IO.File]::Delete($orphan)
    $orphan=Join-Path $wb 'config\unused.json';Add-File $orphan '{}';Assert-Finds 'a config file no active file names is an orphan' 'ORPHAN workbench:config/unused\.json';[IO.File]::Delete($orphan)
    $clone=Join-Path $tmpRoot 'cx\W01-role';[void][IO.Directory]::CreateDirectory($clone);$kept=[IO.File]::ReadAllText($contract)
    Assert-Passes 'a run folder of an open workstream is no orphan'
    [IO.File]::WriteAllText($contract,"$kept## Status`n[x] Complete`n");Assert-Finds 'a run folder of a Complete workstream is an orphan' 'ORPHAN temporary:cx/W01-role/';[IO.File]::WriteAllText($contract,$kept);[IO.Directory]::Delete($clone)

    # -Move: every reference in an active file, in the same operation; frozen text is untouched and resolves through the LOG.
    Add-File (Join-Path $data 'records\old-folder-2\x.txt');Add-File (Join-Path $data 'records\old-folder.md') "# near`n"
    $runbookKept=[IO.File]::ReadAllText($runbook)
    $spell="## 1. Moves`nSlash data/records/old-folder/deep/a.txt.`nBack data\records\old-folder\deep\a.txt.`nAbsolute $data\records\old-folder\deep\a.txt.`nLink [a](../data/records/old-folder/deep/a.txt#top).`nFolder data/records/old-folder/ and data/records/old-folder.`n"
    $near="Near data/records/old-folder-2/x.txt, data/records/old-folder.md, xdata/records/old-folder/deep and notdata/records/old-folder.`n"
    [IO.File]::AppendAllText($runbook,$spell+$near)
    [IO.File]::WriteAllBytes($nowFile,[byte[]](0xEF,0xBB,0xBF)+[Text.Encoding]::UTF8.GetBytes("# NOW`r`nsee data/records/old-folder/deep/a.txt`r`n"))
    $toolKept=[IO.File]::ReadAllText($tool);Add-File $tool "`$x='data\records\old-folder\deep\a.txt'`n"
    $memory=Join-Path $data 'claude-memory\p\MEMORY.md';Add-File $memory "see data/records/old-folder/deep/a.txt`n"
    $planFile=Join-Path $w33 'PLAN.md';Add-File $planFile "see data/records/old-folder/deep/a.txt`n"
    $organizer=Join-Path $wb 'docs\history\README.md';$organizerKept=[IO.File]::ReadAllText($organizer);[IO.File]::AppendAllText($organizer,"see data/records/old-folder/deep/a.txt`n")
    $frozen=@((Join-Path $wb 'changes\WS-001-first.md'),(Join-Path $wb 'docs\history\DECISIONS-ARCHIVE.md'),(Join-Path $data 'records\evidence.md'))
    foreach($file in $frozen){Add-File $file "# frozen`nsee data/records/old-folder/deep/a.txt`n"};$frozenHashes=@($frozen|ForEach-Object{(Get-FileHash -LiteralPath $_).Hash})
    $null=Invoke-Tool -Refresh;Assert-Passes 'the fixture passes before the move'
    $logBefore=[IO.File]::ReadAllBytes($logPath).Length;$sealedHash=(Get-FileHash -LiteralPath (Join-Path $data 'records\old-folder\deep\a.txt')).Hash
    $made=Invoke-Tool -Move 'data\records\old-folder' -To 'data\records\new-folder' -Workstream 'WS-033' -Reason 'renamed'
    if($made.Exit-or$made.Text-cnotmatch'refs=11 files=6'){"  $($made.Text)"}
    Assert-That 'Move moves the tree and reports the references' ($made.Exit-eq0-and$made.Text-cmatch'MOVED data:records/old-folder -> data:records/new-folder [0-9A-F]{64} refs=11 files=6'-and(Test-Path -LiteralPath (Join-Path $data 'records\new-folder\deep\a.txt'))-and!(Test-Path -LiteralPath (Join-Path $data 'records\old-folder')))
    Assert-That 'Move updates each spelling and keeps its separators' ([IO.File]::ReadAllText($runbook)-ceq$runbookKept+$spell.Replace('old-folder','new-folder')+$near)
    $nowBytes=[IO.File]::ReadAllBytes($nowFile)
    Assert-That 'Move keeps a file''s BOM and line endings' ($nowBytes[0]-eq0xEF-and$nowBytes[1]-eq0xBB-and$nowBytes[2]-eq0xBF-and[Text.Encoding]::UTF8.GetString($nowBytes,3,$nowBytes.Length-3)-ceq"# NOW`r`nsee data/records/new-folder/deep/a.txt`r`n")
    Assert-That 'Move updates a tool, a memory file and the plan' ([IO.File]::ReadAllText($tool)-ceq"`$x='data\records\new-folder\deep\a.txt'`n"-and[IO.File]::ReadAllText($memory)-ceq"see data/records/new-folder/deep/a.txt`n"-and[IO.File]::ReadAllText($planFile)-ceq"see data/records/new-folder/deep/a.txt`n")
    Assert-That 'Move updates an organizer''s own prose' ([IO.File]::ReadAllText($organizer).EndsWith("see data/records/new-folder/deep/a.txt`n"))
    Assert-That 'Move edits no frozen text' ((@($frozen|ForEach-Object{(Get-FileHash -LiteralPath $_).Hash})-join'|')-ceq($frozenHashes-join'|'))
    $cells=[IO.File]::ReadAllLines($logPath)[-1].Split("`t");$treeHash=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes("deep\a.txt $sealedHash")))
    Assert-That 'a frozen reference resolves through one LOG row of old path, new path and the tree''s hash' ($cells[1]-ceq'move'-and$cells[2]-ceq'data'-and$cells[3]-ceq'records/old-folder'-and$cells[4]-ceq'records/new-folder'-and$cells[5]-ceq'WS-033'-and$cells[6]-ceq'renamed'-and$cells[7]-ceq$treeHash-and[IO.File]::ReadAllLines($logPath).Count-eq(@([IO.File]::ReadAllBytes($logPath)|Where-Object{$_-eq10}).Count))
    $table=[IO.File]::ReadAllText((Join-Path $data 'records\README.md'))
    Assert-That 'Move refreshes the parent, whose generated rows keep the old path' ($table-cmatch'\| new-folder/ \|'-and$table-cnotmatch'\| old-folder/ \|'-and$table-cmatch'\| move \| records/old-folder \| records/new-folder \| renamed \|')
    Assert-Passes 'a move leaves Check passing'

    # -Move rewrites relative links by what they resolve to, from the file that holds them, in and out of a moved file.
    Add-File (Join-Path $data 'work\sub\keep.txt');$notes=Join-Path $data 'work\notes.md';Add-File $notes "[r](../../docs/RECOVERY.md) [s](sibling.md#top) [u](https://example.invalid/a) [o](#own)`n";Add-File (Join-Path $data 'work\sibling.md') "# sibling`n"
    Add-File $nowFile "[n](notes.md) [d](./notes.md#a) [k](./sibling.md)`n";Add-File $memory "kept`n";$null=Invoke-Tool -Refresh
    $made=Invoke-Tool -Move 'data\work\notes.md' -To 'data\work\sub\notes.md'
    if($made.Exit){"  $($made.Text)"}
    Assert-That 'Move re-bases the links of a moved file, and only those' ($made.Exit-eq0-and[IO.File]::ReadAllText((Join-Path $data 'work\sub\notes.md'))-ceq"[r](../../../docs/RECOVERY.md) [s](../sibling.md#top) [u](https://example.invalid/a) [o](#own)`n")
    Assert-That 'Move re-bases the links to a moved file, and only those' ([IO.File]::ReadAllText($nowFile)-ceq"[n](sub/notes.md) [d](sub/notes.md#a) [k](./sibling.md)`n")
    [IO.Directory]::Delete((Join-Path $data 'work\sub'),$true);[IO.File]::Delete((Join-Path $data 'work\sibling.md'));Add-File $nowFile "# NOW`n";$null=Invoke-Tool -Refresh
    # A checkout path may go bare; a look-alike in another place is another folder.
    Add-Organizer (Join-Path $wb 'records\WS-001') 'records';Add-File (Join-Path $data 'records\WS-001\z.txt')
    $recovery=Join-Path $wb 'docs\RECOVERY.md';$recoveryKept=[IO.File]::ReadAllText($recovery)
    [IO.File]::AppendAllText($recovery,"records/WS-001/README.md, ORVION-Workbench/records/WS-001, data/records/WS-001/z.txt, [l](../records/WS-001/README.md) and [m](records/WS-001/README.md)`n");$null=Invoke-Tool -Refresh
    $made=Invoke-Tool -Move 'records\WS-001' -To 'records\WS-002'
    Assert-That 'Move updates a bare checkout path, its named form and a link, and no look-alike' ($made.Exit-eq0-and$made.Text-cmatch'refs=3 files=1'-and[IO.File]::ReadAllText($recovery)-ceq$recoveryKept+"records/WS-002/README.md, ORVION-Workbench/records/WS-002, data/records/WS-001/z.txt, [l](../records/WS-002/README.md) and [m](records/WS-001/README.md)`n")
    Assert-That 'a moved folder''s own organizer shows the move' ([IO.File]::ReadAllText((Join-Path $wb 'records\WS-002\README.md'))-cmatch'\| move \| records/WS-001 \| records/WS-002 \|')
    [IO.File]::WriteAllText($recovery,$recoveryKept);Add-File (Join-Path $data 'records\WS-002\z.txt');[IO.File]::AppendAllText($recovery,"records/WS-002/README.md, data/records/WS-002/z.txt`n");$null=Invoke-Tool -Refresh
    $made=Invoke-Tool -Move (Join-Path $data 'records\WS-002') -To (Join-Path $data 'records\WS-003')
    Assert-That 'a data path needs its place, so the checkout''s look-alike stays' ($made.Exit-eq0-and[IO.File]::ReadAllText($recovery)-ceq$recoveryKept+"records/WS-002/README.md, data/records/WS-003/z.txt`n")
    [IO.File]::WriteAllText($recovery,$recoveryKept);[IO.Directory]::Delete((Join-Path $data 'records\WS-001'),$true);[IO.Directory]::Delete((Join-Path $data 'records\WS-003'),$true);$null=Invoke-Tool -Refresh
    Assert-Passes 'a moved managed folder keeps its LOG coverage'
    # Across places the place's spelling changes too.
    Add-File (Join-Path $tmpRoot 'tmp\run.txt');[IO.File]::AppendAllText($recovery,"ORVION-Workbench-temporary/tmp/run.txt, temporary\tmp\run.txt, $tmpRoot\tmp\run.txt`n")
    $made=Invoke-Tool -Move (Join-Path $tmpRoot 'tmp\run.txt') -To (Join-Path $data 'work\run.txt');$cells=[IO.File]::ReadAllLines($logPath)[-1].Split("`t")
    Assert-That 'Move across places respells the place' ($made.Exit-eq0-and[IO.File]::ReadAllText($recovery)-ceq$recoveryKept+"data/work/run.txt, data\work\run.txt, $data\work\run.txt`n")
    Assert-That 'the LOG row of a move across places names the old place' ($cells[2]-ceq'data'-and$cells[3]-ceq'temporary:tmp/run.txt'-and$cells[4]-ceq'work/run.txt')
    [IO.File]::WriteAllText($recovery,$recoveryKept);[IO.File]::Delete((Join-Path $data 'work\run.txt'));$null=Invoke-Tool -Refresh

    # A failure midway leaves nothing: the tree back, every written file restored, no LOG row.
    [IO.File]::WriteAllText($nowFile,"see data/records/new-folder/deep/a.txt`n");$runbookMoved=[IO.File]::ReadAllBytes($runbook);$logBefore=[IO.File]::ReadAllBytes($logPath).Length
    $held=[IO.File]::Open($nowFile,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::Read)
    try{$made=Invoke-Tool -Move 'data\records\new-folder' -To 'data\records\third-folder'}finally{$held.Dispose()}
    Assert-That 'a failed write rolls the whole move back' ($made.Exit-ne0-and(Test-Path -LiteralPath (Join-Path $data 'records\new-folder\deep\a.txt'))-and!(Test-Path -LiteralPath (Join-Path $data 'records\third-folder'))-and[Convert]::ToHexString([IO.File]::ReadAllBytes($runbook))-ceq[Convert]::ToHexString($runbookMoved)-and[IO.File]::ReadAllBytes($logPath).Length-eq$logBefore-and!@(Get-ChildItem -LiteralPath $data -Recurse -File -Filter '*.organize').Count-and!@(Get-ChildItem -LiteralPath $nowFile -Force|Where-Object{[IO.File]::ReadAllText($_.FullName)-cnotmatch'new-folder'}).Count)

    # -Move refusals.
    Add-File (Join-Path $wb 'docs\owner\recovery-inputs\inputs.json') '{}';Add-File (Join-Path $wb '.git\config');$null=Invoke-Tool -Refresh
    $runbookMoved=[IO.File]::ReadAllBytes($runbook);$logBefore=[IO.File]::ReadAllBytes($logPath).Length;$from=Join-Path $data 'records\new-folder'
    $moves=@(
        ,@('a tool','ORGANIZE_PINNED',@('-Move',$tool,'-To',(Join-Path $wb 'lib\Other.ps1')))
        ,@('a drawn document','ORGANIZE_PINNED',@('-Move',$recovery,'-To',(Join-Path $wb 'docs\Other.md')))
        ,@('a drawn document by another case','ORGANIZE_PINNED',@('-Move',$recovery.ToLowerInvariant(),'-To',(Join-Path $data 'records\Other.md')))
        ,@('a drawn folder','ORGANIZE_PINNED',@('-Move',(Join-Path $wb 'docs\owner'),'-To',(Join-Path $wb 'docs\other')))
        ,@('a place''s root','ORGANIZE_PINNED',@('-Move',$data,'-To',(Join-Path $tmpRoot 'tmp\data')))
        ,@('the LOG','ORGANIZE_PINNED',@('-Move',$logPath,'-To',(Join-Path $wb 'docs\history\DECISIONS-LOG.md')))
        ,@('Claude memory','ORGANIZE_PINNED',@('-Move',$memory,'-To',(Join-Path $data 'work\MEMORY.md')))
        ,@('the backup inputs','ORGANIZE_PINNED',@('-Move',(Join-Path $wb 'docs\owner\recovery-inputs\inputs.json'),'-To',(Join-Path $data 'records\inputs.json')))
        ,@('Git''s own folder','ORGANIZE_PINNED',@('-Move',(Join-Path $wb '.git\config'),'-To',(Join-Path $data 'records\config')))
        ,@('a target among the tools','ORGANIZE_PINNED',@('-Move',$from,'-To',(Join-Path $wb 'lib\fixtures')))
        ,@('a missing source','ORGANIZE_MOVE_NO_SOURCE',@('-Move',(Join-Path $data 'records\absent'),'-To',(Join-Path $data 'records\there')))
        ,@('a target that exists','ORGANIZE_TARGET_EXISTS',@('-Move',$from,'-To',(Join-Path $data 'records\old-folder-2')))
        ,@('a move into itself','ORGANIZE_MOVE_INTO_ITSELF',@('-Move',$from,'-To',(Join-Path $from 'deep\inner')))
        ,@('a missing target parent','ORGANIZE_PARENT_MISSING',@('-Move',$from,'-To',(Join-Path $data 'records\none\inner')))
        ,@('a target outside every place','ORGANIZE_OUTSIDE_PLACE',@('-Move',$from,'-To',(Join-Path $t 'elsewhere')))
        ,@('a forbidden name','ORGANIZE_NAME_REFUSED',@('-Move',$from,'-To',(Join-Path $data 'records\old')))
        ,@('a name the layout does not allow','ORGANIZE_NOT_MANAGED',@('-Move',$from,'-To',(Join-Path $wb 'docs\stuff')))
        ,@('a target past the path budget','ORGANIZE_PATH_TOO_LONG',@('-Move',$from,'-To',(Join-Path $data ('records\'+('n'*(240-$data.Length-'\records\\deep\a.txt'.Length))))))
        ,@('no target','ORGANIZE_MOVE_NEEDS',@('-Move',$from))
        ,@('a tab in the reason','ORGANIZE_TEXT_REFUSED',@('-Move',$from,'-To',(Join-Path $data 'records\there'),'-Reason',"a`tb"))
    )
    foreach($case in $moves){Assert-Refused "Move refuses $($case[0])" $case[1] $case[2]}
    $linkTarget=Join-Path $t 'move-link-target';Add-File (Join-Path $linkTarget 'k.txt')
    $through=Join-Path $data 'records\through';$null=New-Item -ItemType Junction -Path $through -Target $linkTarget
    Assert-Refused 'Move refuses a source that is a link' 'ORGANIZE_LINK_REFUSED' @('-Move',$through,'-To',(Join-Path $data 'records\there'))
    Assert-Refused 'Move refuses a source through a link' 'ORGANIZE_LINK_REFUSED' @('-Move',(Join-Path $through 'k.txt'),'-To',(Join-Path $data 'records\there.txt'))
    Assert-Refused 'Move refuses a target through a link' 'ORGANIZE_LINK_REFUSED' @('-Move',$from,'-To',(Join-Path $through 'there'))
    [IO.Directory]::Delete($through)
    $holder=Join-Path $data 'records\holder';Add-File (Join-Path $holder 'plain.txt');$null=New-Item -ItemType Junction -Path (Join-Path $holder 'inner') -Target $linkTarget
    Assert-Refused 'Move refuses a tree holding a link' 'ORGANIZE_LINK_REFUSED' @('-Move',$holder,'-To',(Join-Path $data 'records\there'))
    [IO.Directory]::Delete((Join-Path $holder 'inner'))
    $cloudFile=Join-Path $holder 'cloud.txt';Add-File $cloudFile;[IO.File]::SetAttributes($cloudFile,[IO.File]::GetAttributes($cloudFile)-bor[IO.FileAttributes]::Offline)
    Assert-Refused 'Move refuses a tree holding a cloud-only file' 'ORGANIZE_MOVE_CLOUD_ONLY' @('-Move',$holder,'-To',(Join-Path $data 'records\there'))
    [IO.File]::SetAttributes($cloudFile,[IO.FileAttributes]::Normal);[IO.Directory]::Delete($holder,$true)
    $bytesFile=Join-Path $wb 'lib\Latin.md';[IO.File]::WriteAllBytes($bytesFile,[byte[]](0x23,0x20,0xFF,0x0A))
    Assert-Refused 'Move refuses when an active file cannot be read as UTF-8' 'ORGANIZE_ACTIVE_UNREADABLE' @('-Move',$from,'-To',(Join-Path $data 'records\there'))
    [IO.File]::Delete($bytesFile)
    [IO.File]::Delete((Join-Path $wb 'docs\owner\recovery-inputs\inputs.json'));[IO.Directory]::Delete((Join-Path $wb '.git'),$true);$null=Invoke-Tool -Refresh
    Assert-That 'a refused Move writes no file and no LOG row' (!(Test-Path -LiteralPath (Join-Path $data 'records\there'))-and(Test-Path -LiteralPath (Join-Path $from 'deep\a.txt'))-and[Convert]::ToHexString([IO.File]::ReadAllBytes($runbook))-ceq[Convert]::ToHexString($runbookMoved)-and[IO.File]::ReadAllBytes($logPath).Length-eq$logBefore)
    # Everything back to the plain fixture: the old folder's name is free again, by one more move.
    [IO.File]::WriteAllText($runbook,$runbookKept);[IO.File]::WriteAllText($tool,$toolKept);[IO.File]::WriteAllText($organizer,$organizerKept);[IO.File]::WriteAllText($nowFile,"# NOW`n");[IO.Directory]::Delete((Join-Path $data 'claude-memory'),$true);[IO.File]::Delete($planFile)
    foreach($file in $frozen[1..2]){[IO.File]::Delete($file)};[IO.File]::WriteAllText($frozen[0],"# WS-001 first`n");[IO.Directory]::Delete((Join-Path $data 'records\old-folder-2'),$true);[IO.File]::Delete((Join-Path $data 'records\old-folder.md'))
    $null=Invoke-Tool -Refresh;Assert-Passes 'the fixture passes again after the move cases'

    # -Clean. A real repository and upstream, so "Complete and pushed" is proved, not assumed.
    function Invoke-Git{$said=& git -C $wb -c user.name=t -c user.email=t@t.invalid -c core.hooksPath= -c commit.gpgsign=false @args 2>&1;if($LASTEXITCODE){throw "FIXTURE_GIT_FAILED $args $said"}}
    function Set-Contract([string]$Text){[IO.File]::WriteAllText($contract,$Text);Invoke-Git add changes/WS-001-first.md;Invoke-Git commit -q -m c;Invoke-Git push -q -u origin main}
    function Assert-Clean([string]$Name,[string[]]$Says,[string[]]$Lacks=@(),[string[]]$Mode=@('-DryRun'),[int]$Exit=0){
        $said=@(& pwsh -NoProfile -File $script -Clean @Mode -Checkout $wb -Temporary $tmpRoot -Root $data 2>&1|ForEach-Object{"$_"});$code=$LASTEXITCODE;$text=$said-join"`n"
        $ok=$code-eq$Exit-and!@($Says|Where-Object{$text-cnotmatch"(?m)^$_$"}).Count-and!@($Lacks|Where-Object{$text-cmatch"(?m)^$_$"}).Count
        Assert-That $Name $ok;if(!$ok){"  exit $code`n  $text"}
    }
    function Add-Evidence([string]$Pattern,[string]$At,[string]$Evidence){[IO.File]::AppendAllText((Join-Path $data 'events\events.jsonl'),(@{pattern=$Pattern;at=$At;evidence=$Evidence}|ConvertTo-Json -Compress)+"`n")}
    function Clear-Evidence{[IO.File]::WriteAllText((Join-Path $data 'events\events.jsonl'),'')}
    function Get-Sha([string]$Text){[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($Text)))}
    $remote=Join-Path $t 'remote.git';$null=& git init -q --bare -b main $remote 2>&1;Invoke-Git init -q -b main;Invoke-Git remote add origin $remote
    $plainContract="# WS-001 first`n## Status`n[x] Complete`n";Set-Contract $plainContract
    $run=Join-Path $tmpRoot 'cx\W01-role';$runFile=Join-Path $run 'a.txt';Add-File $runFile 'run-bytes';$runSha=Get-Sha 'run-bytes';$del='DELETE disposable temporary:cx/W01-role bytes=9 [0-9A-F]{64}'
    $logBefore=[IO.File]::ReadAllBytes($logPath).Length
    Assert-Clean 'DryRun lists a run folder of a Complete, pushed workstream' @($del,'CLEAN dryrun delete=1 refused=0')
    Assert-That 'DryRun deletes nothing and writes no LOG row' ((Test-Path -LiteralPath $runFile)-and[IO.File]::ReadAllBytes($logPath).Length-eq$logBefore)
    foreach($case in @(@('Clean alone',@()),@('DryRun and Apply together',@('-DryRun','-Apply')))){$said=@(& pwsh -NoProfile -File $script -Clean @($case[1]) -Checkout $wb -Temporary $tmpRoot -Root $data 2>&1|ForEach-Object{"$_"});Assert-That "$($case[0]) is refused" ($LASTEXITCODE-ne0-and($said-join"`n")-cmatch'ORGANIZE_CLEAN_NEEDS')}
    Assert-Refused 'Clean refuses a tab in the reason' 'ORGANIZE_TEXT_REFUSED' @('-Clean','-DryRun','-Reason',"a`tb")
    $said=@(& pwsh -NoProfile -File $script -Clean -DryRun -Checkout $wb -Temporary (Join-Path $t 'no-temp') -Root $data 2>&1|ForEach-Object{"$_"});Assert-That 'a missing temporary refuses the whole Clean' ($LASTEXITCODE-ne0-and($said-join"`n")-cmatch'ORGANIZE_PLACE_UNAVAILABLE: temporary')
    $said=@(& pwsh -NoProfile -File $script -Clean -DryRun -Checkout $wb -Temporary $tmpRoot -Root (Join-Path $t 'no-data') 2>&1|ForEach-Object{"$_"});Assert-That 'a missing data root refuses the whole Clean' ($LASTEXITCODE-ne0-and($said-join"`n")-cmatch'ORGANIZE_PLACE_UNAVAILABLE: data')
    $bytesFile=Join-Path $wb 'lib\Latin.md';[IO.File]::WriteAllBytes($bytesFile,[byte[]](0x23,0x20,0xFF,0x0A));Assert-Refused 'Clean refuses when an active file cannot be read as UTF-8' 'ORGANIZE_ACTIVE_UNREADABLE' @('-Clean','-DryRun');[IO.File]::Delete($bytesFile)
    # Not pushed: an uncommitted Complete, then a commit the upstream lacks.
    [IO.File]::WriteAllText($contract,$plainContract+"more`n");Assert-Clean 'a contract with an uncommitted change is not pushed' @('REFUSED disposable temporary:cx/W01-role NOT_PUSHED','CLEAN dryrun delete=0 refused=1')
    Invoke-Git add changes/WS-001-first.md;Invoke-Git commit -q -m local;Assert-Clean 'a commit the upstream lacks is not pushed' @('REFUSED disposable temporary:cx/W01-role NOT_PUSHED');Invoke-Git push -q origin main;Assert-Clean 'once pushed it is deletable' @($del)
    Invoke-Git branch --unset-upstream;Assert-Clean 'a branch with no upstream is not pushed' @('REFUSED disposable temporary:cx/W01-role NOT_PUSHED');Invoke-Git branch -u origin/main
    [IO.Directory]::Move((Join-Path $wb '.git'),(Join-Path $t 'parked.git'));Assert-Clean 'a checkout that is no repository is not pushed' @('REFUSED disposable temporary:cx/W01-role NOT_PUSHED');[IO.Directory]::Move((Join-Path $t 'parked.git'),(Join-Path $wb '.git'))
    # Named by an active file: refused, whatever the spelling; a frozen text and a test's fixture are not active.
    $runbookKept=[IO.File]::ReadAllText($runbook);$refusedNamed='REFUSED disposable temporary:cx/W01-role NAMED workbench:docs/RUNBOOK\.md'
    foreach($case in @(@('its path','see ORVION-Workbench-temporary/cx/W01-role/a.txt'),@('its absolute path',"see $run\a.txt"),@('its name alone','the W01-role clone'))){[IO.File]::AppendAllText($runbook,"$($case[1])`n");Assert-Clean "an active file naming $($case[0]) keeps the item" @($refusedNamed,'CLEAN dryrun delete=0 refused=1');[IO.File]::WriteAllText($runbook,$runbookKept)}
    [IO.File]::AppendAllText($runbook,"the W01-role-2 and xW01-role clones`n");Assert-Clean 'a longer name is not this name' @($del);[IO.File]::WriteAllText($runbook,$runbookKept)
    Add-File (Join-Path $wb 'lib\test-fixture.ps1') "'W01-role'`n";Assert-Clean 'a test''s strings do not keep an item' @($del);[IO.File]::Delete((Join-Path $wb 'lib\test-fixture.ps1'))
    Add-File (Join-Path $data 'records\frozen.md') "see W01-role`n";Assert-Clean 'a frozen text does not keep an item' @($del);[IO.File]::Delete((Join-Path $data 'records\frozen.md'))
    [IO.File]::AppendAllText($runbook,"see the W01-role clone`n");Assert-Clean 'Apply refuses too, keeps the item, writes no LOG row and exits 1' @($refusedNamed,'CLEAN deleted=0 refused=1') @() @('-Apply') 1;[IO.File]::WriteAllText($runbook,$runbookKept)
    Assert-That 'a refused Clean keeps the item and the LOG' ((Test-Path -LiteralPath $runFile)-and[IO.File]::ReadAllBytes($logPath).Length-eq$logBefore)
    # A plan inside a candidate does not keep the candidate, nor its own folder.
    Add-Organizer (Join-Path $tmpRoot 'sb\W01');Add-File (Join-Path $tmpRoot 'sb\W01\PLAN.md') "the clone is temporary/cx/W01-role/a.txt and this is temporary/sb/W01/PLAN.md`n"
    Assert-Clean 'a finished plan does not pin its own clone' @($del,'DELETE disposable temporary:sb/W01 bytes=\d+ [0-9A-F]{64}','CLEAN dryrun delete=2 refused=0');[IO.Directory]::Delete((Join-Path $tmpRoot 'sb\W01'),$true);[IO.File]::WriteAllBytes($logPath,[IO.File]::ReadAllBytes($logPath)[0..($logBefore-1)]);$null=Invoke-Tool -Refresh
    # Cited: the file must be in data/records/WS-0NN/ with the same bytes first.
    $citedRun='REFUSED disposable temporary:cx/W01-role CITED_NOT_IN_RECORDS cx/W01-role/a\.txt'
    Add-Evidence 'p' '2026-01-01' $runSha;Assert-Clean 'a file whose hash the evidence names is cited' @($citedRun)
    Add-Evidence 'p' '2026-01-02' 'something else';Assert-Clean 'only the latest evidence of a pattern cites' @($del);Clear-Evidence
    Add-Evidence 'p' '2026-01-01' 'cx/W01-role/a.txt';Assert-Clean 'a file whose path the evidence names is cited' @($citedRun);Clear-Evidence
    Add-Evidence 'p' '2026-01-01' $runSha;$copy=Join-Path $data 'records\WS-001\kept.txt';Add-File $copy 'other-bytes';Assert-Clean 'a different file in the records does not verify it' @($citedRun)
    Add-File $copy 'run-bytes';Assert-Clean 'its exact bytes in the workstream''s records verify it' @($del);[IO.Directory]::Delete((Join-Path $data 'records\WS-001'),$true)
    Add-File (Join-Path $data 'records\WS-002\kept.txt') 'run-bytes';Assert-Clean 'another workstream''s records do not verify it' @($citedRun);[IO.Directory]::Delete((Join-Path $data 'records\WS-002'),$true);Clear-Evidence
    Set-Contract ($plainContract+"cx/W01-role/a.txt`n");Assert-Clean 'a contract naming the file cites it' @($citedRun)
    Set-Contract ($plainContract+"cx/W01-role/`n");Assert-Clean 'a contract naming only the folder does not' @($del);Set-Contract $plainContract
    Add-File (Join-Path $run 'sub\b.txt') 'sub-bytes';Add-Evidence 'p' '2026-01-01' 'cx\W01-role\sub\';Assert-Clean 'evidence naming a folder cites what it holds' @('REFUSED disposable temporary:cx/W01-role CITED_NOT_IN_RECORDS cx/W01-role/sub/b\.txt');Clear-Evidence;[IO.Directory]::Delete((Join-Path $run 'sub'),$true)
    # A tracked file needs no copy once its content is on a remote ref.
    $trackedFile=Join-Path $run 'tracked.txt';Add-File $trackedFile 'tracked-bytes';$gitKept=Join-Path $wb 'config\git-kept.txt';Add-File $gitKept 'tracked-bytes';Invoke-Git add config/git-kept.txt;Invoke-Git commit -q -m kept;Add-Evidence 'p' '2026-01-01' (Get-Sha 'tracked-bytes')
    Assert-Clean 'a cited file only in local Git is refused' @('REFUSED disposable temporary:cx/W01-role CITED_NOT_IN_RECORDS cx/W01-role/tracked\.txt')
    Invoke-Git push -q origin main;Assert-Clean 'a cited file whose content is in pushed Git history goes' @('DELETE disposable temporary:cx/W01-role bytes=22 [0-9A-F]{64}')
    Clear-Evidence;[IO.File]::Delete($trackedFile);[IO.File]::Delete($gitKept)
    # What hashing would follow or hydrate is refused.
    $null=New-Item -ItemType Junction -Path (Join-Path $run 'inner') -Target $target;Assert-Clean 'a run folder holding a link is refused' @('REFUSED disposable temporary:cx/W01-role ORGANIZE_LINK_REFUSED');[IO.Directory]::Delete((Join-Path $run 'inner'))
    $cloudFile=Join-Path $run 'cloud.txt';Add-File $cloudFile;[IO.File]::SetAttributes($cloudFile,[IO.File]::GetAttributes($cloudFile)-bor[IO.FileAttributes]::Offline);Assert-Clean 'a run folder holding a cloud-only file is refused' @('REFUSED disposable temporary:cx/W01-role ORGANIZE_MOVE_CLOUD_ONLY');[IO.File]::SetAttributes($cloudFile,[IO.FileAttributes]::Normal);[IO.File]::Delete($cloudFile)
    # A failed removal is a refusal, with no LOG row.
    $held=[IO.File]::Open($runFile,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::Read)
    try{Assert-Clean 'a removal that fails is refused, with no LOG row' @('CLEAN deleted=0 refused=1') @() @('-Apply') 1}finally{$held.Dispose()}
    Assert-That 'the failed removal wrote no LOG row' ([IO.File]::ReadAllBytes($logPath).Length-eq$logBefore)
    # Apply: gone, one LOG row with the tree's hash, the parent refreshed, Check passing.
    $hash=Get-Sha "a.txt $runSha";Assert-Clean 'Apply deletes and reports' @("DELETED disposable temporary:cx/W01-role bytes=9 $hash",'CLEAN deleted=1 refused=0') @() @('-Apply','-Workstream','WS-033','-Reason','done')
    $cells=[IO.File]::ReadAllLines($logPath)[-1].Split("`t");$table=[IO.File]::ReadAllText((Join-Path $tmpRoot 'cx\README.md'))
    Assert-That 'Apply removes the folder and writes one LOG row' (!(Test-Path -LiteralPath $run)-and$cells[1]-ceq'delete'-and$cells[2]-ceq'temporary'-and$cells[3]-ceq'cx/W01-role'-and$cells[4]-ceq'-'-and$cells[5]-ceq'WS-033'-and$cells[6]-ceq'disposable: done'-and$cells[7]-ceq$hash)
    Assert-That 'Apply refreshes the parent' ($table-cmatch'\| delete \| cx/W01-role \| - \| disposable: done \|')
    $null=Invoke-Tool -Refresh;Assert-Passes 'a clean leaves Check passing'
    # temporary/tmp is emptied only when no workstream is open; restore-staging is reported and kept.
    $parked=Join-Path $t 'parked-w33';[IO.Directory]::Move($w33,$parked);$null=Invoke-Tool -Refresh
    $tmpFile=Join-Path $tmpRoot 'tmp\x.txt';Add-File $tmpFile 'tmp-bytes';$tmpDel='DELETE disposable temporary:tmp/x\.txt bytes=9 [0-9A-F]{64}'
    Assert-Clean 'tmp is emptied when no workstream is open, its organizer kept' @($tmpDel,'CLEAN dryrun delete=1 refused=0') @('.*tmp/README.*')
    [void][IO.Directory]::CreateDirectory((Join-Path $tmpRoot 'cx\W02-open'));Assert-Clean 'a run folder with no Complete contract keeps tmp, and itself' @('CLEAN dryrun delete=0 refused=0');[IO.Directory]::Delete((Join-Path $tmpRoot 'cx\W02-open'))
    $openContract=Join-Path $wb 'changes\WS-002-open.md';Add-File $openContract "# WS-002`nNot Complete yet.`n";Assert-Clean 'an open contract keeps tmp' @('CLEAN dryrun delete=0 refused=0');[IO.File]::Delete($openContract)
    $held=Join-Path $tmpRoot 'restore-staging\held.txt';Add-File $held 'held-bytes'
    Assert-Clean 'Apply empties tmp and keeps what restore-staging holds, reported' @('KEPT owner-decides temporary:restore-staging/held\.txt','DELETED disposable temporary:tmp/x\.txt bytes=9 [0-9A-F]{64}','CLEAN deleted=1 refused=0') @() @('-Apply')
    Assert-That 'restore-staging and the organizer of tmp remain' ((Test-Path -LiteralPath $held)-and!(Test-Path -LiteralPath $tmpFile)-and(Test-Path -LiteralPath (Join-Path $tmpRoot 'tmp\README.md')));[IO.File]::Delete($held);[IO.Directory]::Move($parked,$w33);$null=Invoke-Tool -Refresh
    # 0-byte logs: a day old, in the run and live areas, never evidence.
    $long=[DateTime]::UtcNow.AddDays(-2);$logFolder=Join-Path $tmpRoot 'scratch\W33-20261101T000000Z-run'
    foreach($name in 'old.log','young.log','full.log','old.txt'){Add-File (Join-Path $logFolder $name) $(if($name-ceq'full.log'){'x'}else{''})}
    foreach($name in 'old.log','full.log','old.txt'){[IO.File]::SetLastWriteTimeUtc((Join-Path $logFolder $name),$long)}
    $evidenceLog=Join-Path $data 'records\run.log';Add-File $evidenceLog '';[IO.File]::SetLastWriteTimeUtc($evidenceLog,$long)
    $liveLog=Join-Path $data 'work\idle.log';Add-File $liveLog '';[IO.File]::SetLastWriteTimeUtc($liveLog,$long)
    $logDel="DELETE empty-log temporary:scratch/W33-20261101T000000Z-run/old\.log bytes=0 [0-9A-F]{64}";$liveDel='DELETE empty-log data:work/idle\.log bytes=0 [0-9A-F]{64}'
    Assert-Clean 'only an old 0-byte log of a run or live area is listed' @($logDel,$liveDel,'CLEAN dryrun delete=2 refused=0')
    [IO.File]::AppendAllText($nowFile,"see temporary/scratch/W33-20261101T000000Z-run/old.log`n");Assert-Clean 'an active file naming an empty log keeps it' @('REFUSED empty-log temporary:scratch/W33-20261101T000000Z-run/old\.log NAMED data:work/NOW\.md',$liveDel);[IO.File]::WriteAllText($nowFile,"# NOW`n")
    Assert-Clean 'Apply deletes the empty logs' @('DELETED empty-log data:work/idle\.log bytes=0 [0-9A-F]{64}','CLEAN deleted=2 refused=0') @() @('-Apply')
    Assert-That 'Apply kept the young log, the full log, the other file and the evidence' (!(Test-Path -LiteralPath (Join-Path $logFolder 'old.log'))-and(Test-Path -LiteralPath (Join-Path $logFolder 'young.log'))-and(Test-Path -LiteralPath (Join-Path $logFolder 'full.log'))-and(Test-Path -LiteralPath (Join-Path $logFolder 'old.txt'))-and(Test-Path -LiteralPath $evidenceLog))
    [IO.Directory]::Delete($logFolder,$true);[IO.File]::Delete($evidenceLog);$null=Invoke-Tool -Refresh
    # Exact duplicates of a checkout file, in data/records and data/work.
    $original=[IO.File]::ReadAllText($recovery);$dupFolder=Join-Path $data 'work\dup';$dup=Join-Path $dupFolder 'copy x.md';Add-File $dup $original
    $dupDel='DELETE duplicate data:work/dup/copy x\.md bytes=\d+ [0-9A-F]{64}'
    Assert-Clean 'an exact duplicate of a checkout file is listed' @($dupDel,'CLEAN dryrun delete=1 refused=0')
    Add-File (Join-Path $dupFolder 'near.md') ($original.Substring(0,$original.Length-1)+'!');Add-File (Join-Path $dupFolder 'empty.md') '';Add-File (Join-Path $wb 'docs\history\DECISIONS-EMPTY.md') '';Assert-Clean 'the same length alone, and two empty files, are no duplicates' @($dupDel,'CLEAN dryrun delete=1 refused=0');foreach($file in (Join-Path $dupFolder 'near.md'),(Join-Path $dupFolder 'empty.md'),(Join-Path $wb 'docs\history\DECISIONS-EMPTY.md')){[IO.File]::Delete($file)}
    $evidenceCopy=Join-Path $data 'records\evidence-copy\copy.md';Add-File $evidenceCopy $original;Assert-Clean 'a duplicate in the records is evidence and waits for the Lift' @($dupDel,'CLEAN dryrun delete=1 refused=0');[IO.Directory]::Delete((Split-Path $evidenceCopy),$true)
    Add-File (Join-Path $data 'sessions\copy.md') $original;Add-File (Join-Path $data 'claude-memory\p\copy.md') $original;Add-File (Join-Path $data 'records\claude-memory\p\copy.md') $original;Assert-Clean 'the session store and Claude memory are never scanned' @($dupDel,'CLEAN dryrun delete=1 refused=0');[IO.File]::Delete((Join-Path $data 'sessions\copy.md'));[IO.Directory]::Delete((Join-Path $data 'claude-memory'),$true);[IO.Directory]::Delete((Join-Path $data 'records\claude-memory'),$true)
    Add-Evidence 'p' '2026-01-01' (Get-Sha $original);Assert-Clean 'a duplicate whose hash is cited is kept and reported' @('KEPT duplicate data:work/dup/copy x\.md CITED','CLEAN dryrun delete=0 refused=0');Clear-Evidence
    Add-Evidence 'p' '2026-01-01' 'dup/copy x.md';Assert-Clean 'a duplicate whose path is cited is kept and reported' @('KEPT duplicate data:work/dup/copy x\.md CITED');Clear-Evidence
    [IO.File]::AppendAllText($runbook,"[c](../data/work/dup/copy%20x.md)`n");Assert-Clean 'a link to a duplicate keeps it' @('REFUSED duplicate data:work/dup/copy x\.md NAMED workbench:docs/RUNBOOK\.md');[IO.File]::WriteAllText($runbook,$runbookKept)
    [IO.File]::AppendAllText($runbook,"see copy x.md`n");Assert-Clean 'a duplicate''s bare name does not keep it' @($dupDel);[IO.File]::WriteAllText($runbook,$runbookKept)
    [IO.File]::WriteAllText($nowFile,$original);Assert-Clean 'an active file is no duplicate' @($dupDel) @('.*work/NOW.*');[IO.File]::WriteAllText($nowFile,"# NOW`n")
    # What the named check cannot see, Apply's second check reports.
    [IO.File]::AppendAllText($runbook,"[x][r]`n`n[r]: ../data/work/dup/copy%20x.md`n");Assert-Clean 'a deletion that breaks a reference is reported' @('CLEAN_BROKE BROKEN_LINK workbench:docs/RUNBOOK\.md -> \.\./data/work/dup/copy%20x\.md','CLEAN deleted=1 refused=0') @() @('-Apply') 1;[IO.File]::WriteAllText($runbook,$runbookKept)
    [IO.Directory]::Delete($dupFolder,$true);$null=Invoke-Tool -Refresh
    # The uncited tier: the list comes from -ListUncited; only the owner's confirmed list deletes, row by row, each proved again.
    $u1=Join-Path $data 'records\keep\one.txt';$u2=Join-Path $data 'records\keep\two.txt';Add-File $u1 'uncited-one';Add-File $u2 'uncited-two';Add-File (Join-Path $data 'records\claude-memory\m.md') 'memory';Add-File (Join-Path $data 'records\owner-originals\o.md') 'words';Add-File (Join-Path $data 'records\keep\owner-note.md') 'words';$oneSha=Get-Sha 'uncited-one';$twoSha=Get-Sha 'uncited-two'
    Add-Evidence 'p' '2026-01-01' $twoSha
    $listed=@(& pwsh -NoProfile -File $script -Clean -ListUncited -Checkout $wb -Temporary $tmpRoot -Root $data 2>&1|ForEach-Object{"$_"});$code=$LASTEXITCODE
    Assert-That 'ListUncited gives the uncited files and their hashes, not what is cited or Claude memory' ($code-eq0-and$listed[0]-ceq"Path`tSha256"-and$listed-ccontains"keep\one.txt`t$oneSha"-and!@($listed|Where-Object{$_-clike'keep\two*'-or$_-clike'claude-memory*'-or$_-clike'*owner-*'}).Count)
    $locked=[IO.File]::Open($u1,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::None)
    try{$partial=@(& pwsh -NoProfile -File $script -Clean -ListUncited -Checkout $wb -Temporary $tmpRoot -Root $data 2>&1|ForEach-Object{"$_"});$code=$LASTEXITCODE}finally{$locked.Dispose()}
    Assert-That 'a file that cannot be read gives no partial list' ($code-ne0-and!@($partial|Where-Object{$_-cmatch"`t[0-9A-F]{64}$"}).Count)
    Assert-Clean 'no list, no uncited tier' @('CLEAN dryrun delete=0 refused=0')
    $list=Join-Path $t 'confirmed.tsv';function Set-List([string[]]$Rows){[IO.File]::WriteAllText($list,((@("Path`tSha256")+$Rows)-join"`n")+"`n")}
    Set-List @("keep\one.txt`t$oneSha");Assert-Clean 'a confirmed row is listed' @("DELETE uncited data:records/keep/one\.txt bytes=11 $oneSha",'CLEAN dryrun delete=1 refused=0') @() @('-DryRun','-Confirmed',$list)
    Set-List @("keep\one.txt`t$twoSha");Assert-Clean 'a file changed since the owner confirmed it is refused' @('REFUSED uncited data:records/keep/one\.txt HASH_CHANGED') @() @('-DryRun','-Confirmed',$list)
    Set-List @("keep\two.txt`t$twoSha");Assert-Clean 'a file cited since then is refused' @('REFUSED uncited data:records/keep/two\.txt CITED') @() @('-DryRun','-Confirmed',$list)
    Set-List @("keep\none.txt`t$oneSha");Assert-Clean 'a row with no file is refused' @('REFUSED uncited data:records/keep/none\.txt NO_SUCH_FILE') @() @('-DryRun','-Confirmed',$list)
    Set-List @("..\work\NOW.md`t$oneSha");Assert-Clean 'a row outside data/records is refused' @('REFUSED uncited data:records/\.\.\\work\\NOW\.md NOT_IN_RECORDS') @() @('-DryRun','-Confirmed',$list)
    Set-List @("claude-memory\m.md`t$oneSha");Assert-Clean 'a row in Claude memory is refused' @('REFUSED uncited data:records/claude-memory/m\.md PERMANENT') @() @('-DryRun','-Confirmed',$list)
    Set-List @("owner-originals\o.md`t$oneSha","keep\owner-note.md`t$oneSha");Assert-Clean 'a row of the owner''s words is refused' @('REFUSED uncited data:records/owner-originals/o\.md PERMANENT','REFUSED uncited data:records/keep/owner-note\.md PERMANENT') @() @('-DryRun','-Confirmed',$list)
    Set-List @("keep\one.txt`t$oneSha");[IO.File]::AppendAllText($runbook,"see data/records/keep/one.txt`n");Assert-Clean 'a confirmed row an active file names is refused' @('REFUSED uncited data:records/keep/one\.txt NAMED workbench:docs/RUNBOOK\.md') @() @('-DryRun','-Confirmed',$list);[IO.File]::WriteAllText($runbook,$runbookKept)
    [IO.File]::AppendAllText($runbook,"see records/keep/one.txt`n");Assert-Clean 'a bare records path names it too' @('REFUSED uncited data:records/keep/one\.txt NAMED workbench:docs/RUNBOOK\.md') @() @('-DryRun','-Confirmed',$list);[IO.File]::WriteAllText($runbook,$runbookKept)
    Assert-Refused 'a list that does not exist is refused' 'ORGANIZE_CLEAN_NO_LIST' @('-Clean','-DryRun','-Confirmed',(Join-Path $t 'absent.tsv'))
    [IO.File]::WriteAllText($list,"File`tHash`nkeep\one.txt`t$oneSha`n");Assert-Refused 'a list without its columns is refused' 'ORGANIZE_CLEAN_BAD_LIST' @('-Clean','-DryRun','-Confirmed',$list)
    Set-List @("keep\one.txt`t$oneSha");Assert-Clean 'Apply deletes the confirmed row' @("DELETED uncited data:records/keep/one\.txt bytes=11 $oneSha",'CLEAN deleted=1 refused=0') @() @('-Apply','-Confirmed',$list)
    Assert-That 'Apply deleted that file only, with its LOG row' (!(Test-Path -LiteralPath $u1)-and(Test-Path -LiteralPath $u2)-and[IO.File]::ReadAllLines($logPath)[-1].Split("`t")[3]-ceq'records/keep/one.txt')
    Clear-Evidence;foreach($folder in 'keep','claude-memory','owner-originals'){[IO.Directory]::Delete((Join-Path $data "records\$folder"),$true)}
    # Back to the plain fixture for the cases below.
    [IO.File]::WriteAllText($contract,"# WS-001 first`n");Get-ChildItem (Join-Path $wb '.git') -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete((Join-Path $wb '.git'),$true);$null=Invoke-Tool -Refresh
    Assert-Passes 'the fixture passes again after the clean cases'

    # A missing place reports UNAVAILABLE; it is never a pass over nothing, and it does not fail a checkout without it.
    $o=@(& pwsh -NoProfile -File $script -Check -Checkout $wb -Temporary (Join-Path $t 'no-temp') -Root (Join-Path $t 'no-data') 2>&1|ForEach-Object{"$_"});$code=$LASTEXITCODE
    Assert-That 'a missing temporary and data root are UNAVAILABLE, named in the verdict' ($code-eq0-and($o-join"`n")-cmatch"(?m)^UNAVAILABLE temporary "-and($o-join"`n")-cmatch"(?m)^UNAVAILABLE data "-and($o-join"`n")-cmatch'ORGANIZE_CHECK PASS \(unavailable: temporary, data\)$')
    $kept=[IO.File]::ReadAllText($runbook);[IO.File]::AppendAllText($runbook,"[x](../data/only.md) data/only.md ORVION-Workbench-temporary/cx/W33-none/x`n")
    $o=@(& pwsh -NoProfile -File $script -Check -Checkout $wb -Temporary (Join-Path $t 'no-temp') -Root (Join-Path $t 'no-data') 2>&1|ForEach-Object{"$_"});$code=$LASTEXITCODE
    Assert-That 'a reference into a missing place is not called broken' ($code-eq0-and($o-join"`n")-cmatch'ORGANIZE_CHECK PASS \(unavailable: temporary, data\)$')
    $elsewhere=Join-Path $t 'data-elsewhere';Add-File (Join-Path $elsewhere 'only.md') "# only`n"
    $o=@(& pwsh -NoProfile -File $script -Check -Checkout $wb -Temporary $tmpRoot -Root $elsewhere 2>&1|ForEach-Object{"$_"})
    Assert-That 'a link into the checkout''s data folder follows -Root' (($o-join"`n")-cnotmatch'BROKEN_\w+ \S+ .*only\.md'-and($o-join"`n")-cmatch'MISSING data:/work/')
    [IO.File]::WriteAllText($runbook,$kept)
    $o=@(& pwsh -NoProfile -File $script -Check -Checkout (Join-Path $t 'no-wb') 2>&1|ForEach-Object{"$_"})
    Assert-That 'a missing checkout is refused' ($LASTEXITCODE-ne0-and($o-join"`n")-cmatch'ORGANIZE_CHECKOUT_UNAVAILABLE')
    $resolved=Invoke-Tool -New 'data\ws\none' -Kind scratch -Purpose p -Reader r
    Assert-That 'the data root inside the checkout is its own place, and a relative path starts at the checkout' ($resolved.Exit-ne0-and$resolved.Text-cmatch'ORGANIZE_NOT_MANAGED: data:ws/none')
    Assert-Passes 'the fixture ends passing'
}finally{Get-ChildItem $t -Recurse -Force -Attributes ReparsePoint -ErrorAction SilentlyContinue|ForEach-Object{if($_.PSIsContainer){[IO.Directory]::Delete($_.FullName,$false)}else{[IO.File]::Delete($_.FullName)}};Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
if($fail){throw "ORGANIZE_SELFCHECK_FAILED $fail"};'ORGANIZE_SELFCHECK PASS'
