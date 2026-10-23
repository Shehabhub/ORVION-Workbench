# Independent live-Git Review checks for an executed contract (read-only); judges the repository, not the
# Execution Log. Pre-Review observations only, not certification or a replacement native criterion engine.
# Exit 1 on an observed failure, 2 on required evidence this adapter cannot establish, 0 for its measured class only.
# Every git read goes through Invoke-RepoGit, so a failed read throws instead of reading as empty.
param([Parameter(Mandatory)][string]$Config,[string]$FinishLog)
$ErrorActionPreference='Stop'
$cfg=Import-PowerShellDataFile $Config;$r=$cfg.Root;$Rel="changes/$($cfg.Id)-$($cfg.Slug).md";$failed=0;$unproven=0
function Invoke-RepoGit([string[]]$GitArgs){$o=& git -C $r -c core.quotepath=false @GitArgs 2>$null;if($LASTEXITCODE){throw "git $($GitArgs-join' ') failed ($LASTEXITCODE)"};$o}
if(Invoke-RepoGit @('status','--porcelain')){$failed++;'FAIL dirty pre-Review subject'}
$head=Invoke-RepoGit @('rev-parse','HEAD');$t=[IO.File]::ReadAllText((Join-Path $r $Rel))-replace"`r`n","`n"
function Get-PathList([string]$Heading){[regex]::Match($t,"(?s)## $Heading[^\n]*\n(.+?)\n## ").Groups[1].Value-split"`n"|Where-Object{$_-match'^- `'}|ForEach-Object{($_-replace'^- `([^`]+)`.*$','$1')}}
$scope=Get-PathList 'Write Scope';$forbidden=Get-PathList 'Out of Scope'
"range $($cfg.Main)..$head"
$changed=@(Invoke-RepoGit @('diff','--name-only',"$($cfg.Main)..$head"));"changed: $($changed-join', ')"
$outside=@($changed|Where-Object{$_-ne$Rel-and$_-notin$scope});if($outside.Count){$failed++}
$forbiddenChanged=@($changed|Where-Object{$_-ne$Rel-and$_-in$forbidden});if($forbiddenChanged.Count){$failed++}
"outside Write Scope: [$($outside-join', ')]"
"forbidden paths changed: [$($forbiddenChanged-join', ')] of $($forbidden.Count) listed"
"authors: $((Invoke-RepoGit @('log','--format=%an <%ae>',"$($cfg.Main)..$head")|Sort-Object -Unique)-join'; ')"
$alloc=@(Invoke-RepoGit @('log','--diff-filter=A','--format=%H','--',$Rel));if($alloc.Count-ne1){throw 'REVIEW_ALLOCATION_AMBIGUOUS'};$alloc=$alloc[0]
$allocatedBlob=Invoke-RepoGit @('rev-parse',"${alloc}:$Rel");if($allocatedBlob-cne$cfg.Blob){$failed++}
if((Get-FileHash -LiteralPath $cfg.Draft).Hash-cne$cfg.Sha){$failed++;'FAIL selected Draft identity'}
"allocation $alloc stores blob $allocatedBlob (approved $($cfg.Blob))"
$d=Invoke-RepoGit @('diff','-U0',"${alloc}..$head",'--',$Rel)|Where-Object{$_-match'^-(?!--)'}
$bad=@($d|Where-Object{$_-notmatch'^-\[[ x]\] (Draft|Approved|In Progress|Complete)$|^-Resume Step: 1$|^-- \[ \] |^-None\.$'})
"contract removed-line diagnostic: $($bad.Count); native range Gate owns frozen text and legal transition judgment"
$ac=[regex]::Match($t,'(?s)\n## Acceptance Criteria\n(.+?)\n## ').Groups[1].Value;if(!$ac){throw 'NO_ACCEPTANCE_CRITERIA'}
$checks=@([regex]::Matches($ac,'`check: (blob|has|lacks) (\S+) (?:"((?:[^"])+)"|([0-9a-f]{40}))`'))
$clauses=[regex]::Matches($ac,'`check: ').Count
if($clauses-ne$checks.Count){$unproven++;'UNPROVEN: native checks outside this diagnostic adapter; use native authority, never infer a pass'}
foreach($m in $checks){
    $k=$m.Groups[1].Value;$p=$m.Groups[2].Value
    if($p.Contains('#')){$unproven++;'UNPROVEN: keyed native check requires its native authority';continue}
    $text=(Invoke-RepoGit @('show',"${head}:$p"))-join"`n"
    $ok=switch($k){'blob'{(Invoke-RepoGit @('rev-parse',"${head}:$p"))-eq$m.Groups[4].Value}'has'{$text.Contains($m.Groups[3].Value)}'lacks'{-not$text.Contains($m.Groups[3].Value)}}
    if(!$ok){$failed++};"criterion {0} {1}: {2}" -f $k,$p,$(if($ok){'holds'}else{'FAILS'})
}
if($FinishLog){
    $finish=[IO.File]::ReadAllText($FinishLog)
    if($finish-notmatch'LOCAL_CERTIFY: READY'-or$finish-notmatch'END exit=0'){$failed++;'FAIL supplied Finish log lacks its successful native result/END'}
    "finish log: "+((Get-Content -LiteralPath $FinishLog|Where-Object{$_-match'LOCAL_CERTIFY:|RESOURCES:|END exit=|EXIT'})-join' | ')
}
$rc=Get-Content -Raw (Join-Path $r '.orvion-local-certification.json')|ConvertFrom-Json
if($rc.cr-cne$cfg.Id-or$rc.result-cne'READY'){$failed++}
if($rc.finishHead-cne$head){$unproven++;'UNPROVEN: not the exact pre-Review Finish head; later metadata/binding is judged by native authority'}
"receipt: cr=$($rc.cr) result=$($rc.result) finishHead=$($rc.finishHead) fresh=$($rc.finishHead-eq$head)"
$native=Join-Path $r 'scripts/check_agent_continuity.ps1'
if(!(Test-Path -LiteralPath $native -PathType Leaf)){$unproven++;'UNPROVEN: native range Gate unavailable'}else{
    $gate=& pwsh -NoProfile -File $native -Root $r -Gate -BaseRef $cfg.Main -HeadRef $head 2>&1|Out-String
    $gateCode=$LASTEXITCODE;$gate
    if($gateCode-or$gate-notmatch'(?m)^ORVION: READY\r?$'){$failed++;'FAIL native range Gate'}
}
"REVIEW_DIAGNOSTICS: failures=$failed unproven=$unproven. Native gates/receipts and independent actual review remain mandatory; no descriptive criterion was auto-approved."
exit $(if($failed){1}elseif($unproven){2}else{0})
