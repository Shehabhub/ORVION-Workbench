# Generic executor for an owner-approved ORVION contract on its AUTHORITATIVE checkout (agent tooling, not
# repository code). Replaces the per-contract copies execute-crc.ps1 / execute-crb.ps1 (2026-10-19), one of
# which carried a recursing `Git` helper. Every mismatch throws before any write; every commit goes through
# the repository's own pre-commit hook. The implement stage applies the frozen Draft's own steps literally
# (apply-draft-steps.ps1) and verifies each blob, so nothing is copied from a sandbox. Every git read that a
# decision rests on goes through Invoke-RepoGit, which throws on a failed git: an unchecked `git status` that fails
# prints nothing, which read as a clean checkout (found by failure injection, 2026-10-19).
# ponytail: edits to existing files only; a Draft that creates a file needs a create step added here.
#
# Config (.psd1): Root, Main (full baseline SHA), Id, Slug, Draft (path), Sha (Draft SHA-256), Blob (Draft
# Git blob), User, Suffix (commit suffix), ApprovalNote (one sentence naming the owner's approval),
# Retired (optional paths the Draft deletes), Gh (owner/repo), GhUser (account for gh, optional).
param([Parameter(Mandatory)][string]$Config,
      [Parameter(Mandatory)][ValidateSet('approve','implement','review','complete','bind')][string]$Stage,[string]$EntryFile)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'lifecycle.ps1')
$cfg=Import-PowerShellDataFile $Config
$r=$cfg.Root;$Id=$cfg.Id;$ContractRel="changes/$Id-$($cfg.Slug).md";$Retired=@($cfg.Retired|Where-Object{$_})
$log=Join-Path (Split-Path $Config -Parent) "$Id-lifecycle.log"
function Write-Say([string]$s){$l="[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $s";Add-Content -LiteralPath $log -Value $l -Encoding utf8;$l}
function Invoke-RepoGit([string[]]$GitArgs){$o=& git -C $r @GitArgs 2>$null;if($LASTEXITCODE){throw "git $($GitArgs-join' ') failed ($LASTEXITCODE)"};$o}
function Get-Brief([string]$t){(($t-split"`r?`n")|Where-Object{$_-match'^(ORVION|MODE|CODE|SUBJECT|APPROVAL_EVIDENCE|CRITERIA|BLOCKER|PREPARE):'}|Select-Object -First 8)-join' | '}
function Save-Commit([string]$Message){
    Invoke-RepoGit @('add','-A')|Out-Null
    $trailer="Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>";if($env:ORVION_COMMIT_TRAILER){$trailer+="`n$env:ORVION_COMMIT_TRAILER"}
    $out=& git -C $r commit -q -m "$Message`n`n$trailer" 2>&1|Out-String;$code=$LASTEXITCODE
    Add-Content -LiteralPath $log -Value $out -Encoding utf8
    if($code){Write-Say "COMMIT REFUSED ($code): $Message :: $(Get-Brief $out)";throw 'COMMIT_REFUSED'}
    Write-Say ("COMMIT OK {0} {1} :: {2}" -f (Invoke-RepoGit @('rev-parse','HEAD')),$Message,(Get-Brief $out));$out
}
function Set-Manifest([string]$Key,[string]$Value){
    $manifestRel='_ORVION_CANONICAL/manifest.md';$t=Read-RepoText $r $manifestRel
    $m=[regex]::Matches($t,"(?m)^$([regex]::Escape($Key)): [^\r\n]*");if($m.Count-ne1){throw "MANIFEST_LINE_COUNT:$Key"}
    Write-RepoText $r $manifestRel ($t.Remove($m[0].Index,$m[0].Length).Insert($m[0].Index,"${Key}: $Value"))
}
function Get-Entry{if(!$EntryFile-or!(Test-Path $EntryFile)){throw 'ENTRY_FILE_REQUIRED'};$e=[IO.File]::ReadAllText($EntryFile).Trim();$e-replace"`r?`n",(Get-Newline (Read-RepoText $r $ContractRel))}
# The files the Draft's steps change, with the blob each step must produce.
function Get-DraftFiles{$t=[IO.File]::ReadAllText($cfg.Draft)-replace"`r`n","`n"
    $o=[ordered]@{};foreach($m in [regex]::Matches($t,'(?ms)^\d+\. Check whether `([^`]+)` contains.*?The resulting file''s Git blob is ([0-9a-f]{40})')){$o[$m.Groups[1].Value]=$m.Groups[2].Value};$o}

if((git -C $r rev-parse --show-toplevel)-ne($r-replace'\\','/')){throw 'ROOT_MISMATCH'}
if((git -C $r config user.name)-ne$cfg.User){throw 'IDENTITY_MISMATCH'}
switch($Stage){
'approve'{
    Write-Say "=== $Id approve stage start; draft $($cfg.Draft)"
    $h=(Get-FileHash -Algorithm SHA256 $cfg.Draft).Hash;if($h-ne$cfg.Sha){throw "DRAFT_SHA_MISMATCH $h"}
    if((git -C $r hash-object --no-filters $cfg.Draft)-ne$cfg.Blob){throw 'DRAFT_BLOB_MISMATCH'}
    Invoke-RepoGit @('fetch','-q','origin')|Out-Null
    $head=Invoke-RepoGit @('rev-parse','HEAD');$om=Invoke-RepoGit @('rev-parse','origin/main')
    if($head-ne$cfg.Main){throw "BASELINE_MOVED head=$head"}
    # SPEC-284 ordered pending candidates: a baseline not yet promoted is lawful only as a descendant of
    # main with its own bound record in this original checkout.
    if($om-ne$cfg.Main){
        & git -C $r merge-base --is-ancestor $om $head 2>$null;if($LASTEXITCODE){throw "BASELINE_NOT_DESCENDANT origin=$om"}
        if(!(Test-Path -LiteralPath (Join-Path $r ".orvion-certifications\$head.json"))){throw "PENDING_BASELINE_UNBOUND $head"}
        Write-Say "baseline $head is a pending candidate above main $om, bound record present"
    }
    if(Invoke-RepoGit @('status','--porcelain')){throw 'DIRTY_CHECKOUT'}
    if(Test-Path (Join-Path $r $ContractRel)){throw 'CONTRACT_EXISTS'}
    $text=[IO.File]::ReadAllText($cfg.Draft);$n=0
    foreach($m in [regex]::Matches($text,'\| `([^`]+)` \| `([0-9a-f]{40})` \|')){$n++
        $a=Invoke-RepoGit @('rev-parse',"HEAD:$($m.Groups[1].Value)");if($a-ne$m.Groups[2].Value){throw "ANCHOR_MISMATCH $($m.Groups[1].Value) $a"}}
    Write-Say "preconditions: sha256 $h = approved; blob $($cfg.Blob); HEAD = origin/main = $head; clean; $n source anchors match"
    Copy-Item -LiteralPath $cfg.Draft -Destination (Join-Path $r $ContractRel)
    Save-Commit "${Id}: allocate exact frozen Draft ($($cfg.Suffix))"|Out-Null
    $alloc=Invoke-RepoGit @('rev-parse','HEAD');if((Invoke-RepoGit @('rev-parse',"HEAD:$ContractRel"))-ne$cfg.Blob){throw 'ALLOCATED_BLOB_MISMATCH'}
    $t=Read-RepoText $r $ContractRel;$nl=Get-Newline $t;$t=Set-Status $t 'Draft' 'Approved'
    $t=Add-ToSection $t 'Verification Notes' ("### $(Get-Date -Format yyyy-MM-dd) — Gate 1 approval recorded${nl}${nl}$($cfg.ApprovalNote) Immediately before allocation the hash, the Draft blob $($cfg.Blob), all $n source anchors, the baseline HEAD $($cfg.Main) against refreshed origin/main $om and a clean checkout were revalidated, and the pre-commit allocator admitted the identity; Draft allocated as $($alloc.Substring(0,7)). No implementation performed before this transition. Batch 6 remains ON HOLD; CTRL-19 remains OPEN.")
    Write-RepoText $r $ContractRel $t;Set-Manifest 'Active Change Request' "``$ContractRel``";Update-Projections $r
    $out=Save-Commit "${Id}: Approve exact frozen contract ($($cfg.Suffix))"
    if($out-notmatch'APPROVAL_EVIDENCE: PASS'){throw 'APPROVAL_EVIDENCE_NOT_PASS'}
}
'implement'{
    Write-Say "=== $Id implement stage start"
    $t=Read-RepoText $r $ContractRel;if($t-notmatch'(?m)^\[x\] Approved'){throw 'NOT_APPROVED'};if($t-match'(?m)^Resume Step: DONE'){throw 'ALREADY_DONE'}
    $files=Get-DraftFiles;if(!$files.Count){throw 'NO_FILE_STEPS'}
    foreach($f in $files.Keys){if((Invoke-RepoGit @('rev-parse',"HEAD:$f"))-eq$files[$f]){throw "ALREADY_APPLIED $f"}}
    foreach($f in $Retired){if(!(Test-Path -LiteralPath (Join-Path $r $f))){throw "RETIRED_ALREADY_ABSENT $f"}}
    $ap=& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'apply-draft-steps.ps1') -Draft $cfg.Draft -Root $r 2>&1|Out-String
    Add-Content -LiteralPath $log -Value $ap -Encoding utf8;if($LASTEXITCODE){throw 'DRAFT_STEPS_DID_NOT_REPRODUCE'}
    if($Retired.Count){Invoke-RepoGit (@('rm','-q','--')+$Retired)|Out-Null}
    Update-Projections $r
    & pwsh -NoProfile -WorkingDirectory $r -File (Join-Path $r 'scripts/generate-ai-map.ps1') -Check *>$null;if($LASTEXITCODE){throw "GENERATOR_CHECK $LASTEXITCODE"}
    $scope=[regex]::Match($t,'(?s)## Write Scope\s+(.+?)\n## ').Groups[1].Value-split"`r?`n"|Where-Object{$_-match'^- `'}|ForEach-Object{($_-replace'^- `|`$','')}
    Invoke-RepoGit @('add','-A')|Out-Null
    $changed=@(Invoke-RepoGit @('diff','--cached','--name-only'));$outside=@($changed|Where-Object{$_-notin$scope});if($outside){throw "OUT_OF_SCOPE $($outside-join',')"}
    $num=@{};foreach($s in @(Invoke-RepoGit (@('diff','--cached','--numstat','--')+@($files.Keys)))){$p=$s-split"`t";$num[$p[2]]="$($p[0]) insertions, $($p[1]) deletions"}
    $alloc=(Invoke-RepoGit @('log','--diff-filter=A','--format=%h','--',$ContractRel));$appr=(Invoke-RepoGit @('rev-parse','--short=7','HEAD'))
    $t=Read-RepoText $r $ContractRel;$nl=Get-Newline $t;$t=Set-Status $t 'Approved' 'In Progress'
    $lines=@("- Step 1 Applied: the owner's Gate 1 approval names this exact Draft's SHA-256; the baseline HEAD was $($cfg.Main) and every source anchor matched there; Draft allocated as $alloc and approved as $appr with APPROVAL_EVIDENCE: PASS.")
    $i=1;foreach($f in $files.Keys){$i++;$lines+="- Step $i Applied: ``$f`` edited exactly as the step states; blob $($files[$f]) ($($num[$f]))."}
    $lines+="- Step $($i+1) Applied: generator rerun, ``generate-ai-map.ps1 -Check`` exit 0, the staged change names only Write Scope paths. Every edit was applied literally from this contract's steps and its Git blob checked before commit. Fresh timed and watched Finish, independent Review, Complete and candidate binding remain. Batch 6 remains ON HOLD; CTRL-19 remains OPEN."
    $e="### $(Get-Date -Format yyyy-MM-dd) — Implementation checkpoint (Claude)${nl}${nl}Outcome: Complete (implementation steps; final verification pending)${nl}${nl}"+($lines-join$nl)
    $t=Add-ToSection $t 'Verification Notes' $e;$t=Set-Once $t "Resume Step: 1$nl" "Resume Step: DONE$nl" 'checkpoint';Write-RepoText $r $ContractRel $t
    Save-Commit "${Id}: implement the approved contract; Runtime Checkpoint DONE before timed Finish ($($cfg.Suffix))"|Out-Null
    foreach($f in $files.Keys){if((Invoke-RepoGit @('rev-parse',"HEAD:$f"))-ne$files[$f]){throw "COMMITTED_BLOB_MISMATCH $f"}}
    Write-Say "implement stage end; $($files.Count) committed blobs verified"
}
'review'{
    if(Invoke-RepoGit @('status','--porcelain')){throw 'DIRTY_CHECKOUT'}
    $rc=Get-Content -Raw (Join-Path $r '.orvion-local-certification.json')|ConvertFrom-Json
    if($rc.cr-ne$Id-or$rc.result-ne'READY'-or$rc.finishHead-ne(Invoke-RepoGit @('rev-parse','HEAD'))){throw "RECEIPT_NOT_FRESH $($rc.cr) $($rc.result) $($rc.finishHead)"}
    $e=Get-Entry;if($e-notmatch'Verdict: Confirmed Complete'){throw 'NO_VERDICT'}
    $t=Read-RepoText $r $ContractRel;Write-RepoText $r $ContractRel (Add-ToSection $t 'Review Gate' $e)
    Save-Commit "${Id}: Review Confirmed Complete after fresh verification ($($cfg.Suffix))"|Out-Null
}
'complete'{
    if(Invoke-RepoGit @('status','--porcelain')){throw 'DIRTY_CHECKOUT'}
    $draftBoxes=([regex]::Matches([IO.File]::ReadAllText($cfg.Draft),'(?m)^- \[ \] ')).Count
    $t=Read-RepoText $r $ContractRel;$t=Set-Status $t 'In Progress' 'Complete'
    $boxes=([regex]::Matches($t,'(?m)^- \[ \] ')).Count;if($boxes-ne$draftBoxes){throw "CHECKBOX_COUNT $boxes, Draft has $draftBoxes"}
    $t=[regex]::Replace($t,'(?m)^- \[ \] ','- [x] ');$t=Add-ToSection $t 'Verification Notes' (Get-Entry);Write-RepoText $r $ContractRel $t
    $lc=[regex]::Match([IO.File]::ReadAllText($cfg.Draft),'`(Last Completed: \*\*.+?\*\*)`').Groups[1].Value;if(!$lc){throw 'NO_LAST_COMPLETED'}
    Set-Manifest 'Active Change Request' 'None.';Set-Manifest 'Last Completed' $lc.Substring('Last Completed: '.Length);Update-Projections $r
    Save-Commit "${Id}: Complete locally verified contract ($($cfg.Suffix))"|Out-Null
    if(!(Read-RepoText $r '_ORVION_CANONICAL/manifest.md').Contains($lc)){throw 'LAST_COMPLETED_NOT_WRITTEN'}
}
'bind'{
    $cand=Invoke-RepoGit @('rev-parse','HEAD');if(Invoke-RepoGit @('status','--porcelain')){throw 'DIRTY_CHECKOUT'}
    $o=& pwsh -NoProfile -WorkingDirectory $r -File (Join-Path $r 'scripts/check_agent_continuity.ps1') -Gate -BindCandidate -Root $r -BaseRef $cfg.Main -HeadRef $cand 2>&1|Out-String;$code=$LASTEXITCODE
    Add-Content -LiteralPath $log -Value $o -Encoding utf8;Write-Say "BIND $($cfg.Main)..$cand exit=$code :: $(Get-Brief $o)";$o
    if($code){throw "BIND_FAILED $code"}
}}
