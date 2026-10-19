# Independent live-Git Review checks for an executed contract (read-only); judges the repository, not the
# Execution Log. Takes the same .psd1 as Invoke-ContractStage.ps1. Generalised from CR B's review-checks.ps1.
# Every git read goes through Invoke-RepoGit, so a failed read throws instead of reading as empty.
param([Parameter(Mandatory)][string]$Config,[string]$FinishLog)
$ErrorActionPreference='Stop'
$cfg=Import-PowerShellDataFile $Config;$r=$cfg.Root;$Rel="changes/$($cfg.Id)-$($cfg.Slug).md"
function Invoke-RepoGit([string[]]$GitArgs){$o=& git -C $r @GitArgs 2>$null;if($LASTEXITCODE){throw "git $($GitArgs-join' ') failed ($LASTEXITCODE)"};$o}
$head=Invoke-RepoGit @('rev-parse','HEAD');$t=[IO.File]::ReadAllText((Join-Path $r $Rel))-replace"`r`n","`n"
function Get-PathList([string]$Heading){[regex]::Match($t,"(?s)## $Heading[^\n]*\n(.+?)\n## ").Groups[1].Value-split"`n"|Where-Object{$_-match'^- `'}|ForEach-Object{($_-replace'^- `([^`]+)`.*$','$1')}}
$scope=Get-PathList 'Write Scope';$forbidden=Get-PathList 'Out of Scope'
"range $($cfg.Main)..$head"
$changed=@(Invoke-RepoGit @('diff','--name-only',"$($cfg.Main)..$head"));"changed: $($changed-join', ')"
"outside Write Scope: [$((@($changed|Where-Object{$_-notin$scope}))-join', ')]"
"forbidden paths changed: [$((@($changed|Where-Object{$_-in$forbidden}))-join', ')] of $($forbidden.Count) listed"
"authors: $((Invoke-RepoGit @('log','--format=%an <%ae>',"$($cfg.Main)..$head")|Sort-Object -Unique)-join'; ')"
$alloc=Invoke-RepoGit @('log','--diff-filter=A','--format=%H','--',$Rel);"allocation $alloc stores blob $(Invoke-RepoGit @('rev-parse',"${alloc}:$Rel")) (approved $($cfg.Blob))"
$d=Invoke-RepoGit @('diff','-U0',"${alloc}..$head",'--',$Rel)|Where-Object{$_-match'^-(?!--)'}
$bad=@($d|Where-Object{$_-notmatch'^-\[[ x]\] (Draft|Approved|In Progress|Complete)$|^-Resume Step: 1$|^-- \[ \] |^-None\.$'})
"contract lines removed outside Status/Checkpoint/checkboxes/empty logs: $($bad.Count) $($bad-join' / ')"
$ac=[regex]::Match($t,'(?s)\n## Acceptance Criteria\n(.+?)\n## ').Groups[1].Value;if(!$ac){throw 'NO_ACCEPTANCE_CRITERIA'}
foreach($m in [regex]::Matches($ac,'`check: (blob|has|lacks) (\S+) (?:"((?:[^"])+)"|([0-9a-f]{40}))`')){
    $k=$m.Groups[1].Value;$p=$m.Groups[2].Value;$text=(Invoke-RepoGit @('show',"${head}:$p"))-join"`n"
    $ok=switch($k){'blob'{(Invoke-RepoGit @('rev-parse',"${head}:$p"))-eq$m.Groups[4].Value}'has'{$text.Contains($m.Groups[3].Value)}'lacks'{-not$text.Contains($m.Groups[3].Value)}}
    "criterion {0} {1}: {2}" -f $k,$p,$(if($ok){'holds'}else{'FAILS'})
}
if($FinishLog){"finish log: "+((Get-Content -LiteralPath $FinishLog|Where-Object{$_-match'LOCAL_CERTIFY:|^RESOURCES:|^END|EXIT'})-join' | ')}
$rc=Get-Content -Raw (Join-Path $r '.orvion-local-certification.json')|ConvertFrom-Json
"receipt: cr=$($rc.cr) result=$($rc.result) finishHead=$($rc.finishHead) fresh=$($rc.finishHead-eq$head)"
