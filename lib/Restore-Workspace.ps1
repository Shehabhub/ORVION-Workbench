# Restores a Backup-Workspace.ps1 folder onto a fresh machine. Never overwrites: every destination must be absent.
# Verifies SHA256SUMS.txt first; rebuilds each repository from its bundle with identical refs, HEAD, local config
# (identity, remote, credential pin, hooks path, branch upstreams: Boot refuses GIT_UPSTREAM_MISSING without them) and ignored receipts; then the workspace, Claude memory and legacy folders.
# Afterwards (manual, credentials are never backed up): gh auth login for PlatPlusHub and Shehabhub, then
# `pwsh -NoProfile -File <repo>\scripts\check_agent_continuity.ps1 -Boot` in each repository.
param([Parameter(Mandatory)][string]$From,[string]$Target=(Join-Path $env:USERPROFILE 'Documents\GitHub'),
      [string]$ClaudeHome=(Join-Path $env:USERPROFILE '.claude'),[string]$LegacyTarget=(Join-Path $env:USERPROFILE 'Documents'),[switch]$SkipLegacy)
$ErrorActionPreference='Stop'
function Invoke-Git{param([string]$Repo)$o=& git -C $Repo @args 2>&1;if($LASTEXITCODE){throw "GIT_FAILED $Repo git $args`n$o"};$o}
function Assert-Absent([string]$Path){if(Test-Path -LiteralPath $Path){throw "RESTORE_TARGET_EXISTS: $Path (restore never overwrites)"}}

$From=(Resolve-Path $From).Path
$bad=@(foreach($l in [IO.File]::ReadAllLines((Join-Path $From 'SHA256SUMS.txt'))){
    $h,$rel=$l-split'  ',2;$f=Join-Path $From $rel
    if(!(Test-Path -LiteralPath $f)-or(Get-FileHash -LiteralPath $f).Hash-ne$h){$rel}
})
if($bad.Count){throw "BACKUP_CORRUPT: $($bad.Count) file(s) fail SHA256SUMS, first: $($bad[0])"}
$plan=Get-Content (Join-Path $From 'backup.json') -Raw|ConvertFrom-Json
foreach($r in $plan.repos){Assert-Absent (Join-Path $Target $r.name)}
Assert-Absent (Join-Path $Target 'ORVION-Owner-Tools')

$created=[Collections.Generic.List[string]]::new()
try{foreach($r in $plan.repos){
    $dest=Join-Path $Target $r.name;$src=Join-Path $From "repos\$($r.name)";$created.Add($dest)
    & git clone --quiet --no-checkout (Join-Path $From "repos\$($r.name).bundle") $dest 2>&1|Out-Null;if($LASTEXITCODE){throw "CLONE_FAILED $($r.name)"}
    $want=@([IO.File]::ReadAllLines((Join-Path $src 'refs.txt')))
    # --no-deref: origin/HEAD is symbolic; deleting or writing through it would move the branch it names.
    foreach($ref in @(Invoke-Git $dest for-each-ref --format='%(refname)')){Invoke-Git $dest update-ref --no-deref -d $ref|Out-Null}  # the bundle clone's own origin/* names
    foreach($l in $want){$sha,$ref=$l-split' ',2;if($ref-ne'refs/remotes/origin/HEAD'){Invoke-Git $dest update-ref --no-deref $ref $sha|Out-Null}}
    if($r.originHead){Invoke-Git $dest symbolic-ref refs/remotes/origin/HEAD $r.originHead|Out-Null}
    Invoke-Git $dest remote set-url origin $r.origin|Out-Null
    # Replace, never add on top: the clone already wrote branch.* (two values made `git config branch.main.remote` fail).
    # pushurl matters: a sandbox's DISABLED push URL must stay disabled after a restore.
    $cfg=[ordered]@{}
    foreach($l in [IO.File]::ReadAllLines((Join-Path $src 'git-config-local.txt'))){
        $k,$v=$l-split'=',2
        if($k-match'^(user\.|credential\.|core\.hookspath$|core\.autocrlf$|lfs\.|submodule\.|branch\.|remote\.origin\.pushurl$)'){$cfg[$k]=@($cfg[$k])+$v|Where-Object{$null-ne$_}}
    }
    foreach($k in $cfg.Keys){& git -C $dest config --local --unset-all $k 2>$null;foreach($v in @($cfg[$k])){Invoke-Git $dest config --local --add $k $v|Out-Null}}
    if($r.stash){"WARN $($r.name): $($r.stash) stash(es) existed; a bundle keeps only refs/stash, not the older entries"}
    if($r.worktrees-gt0){"WARN $($r.name): $($r.worktrees) linked worktree(s) existed and are not restored"}
    if($r.branch-eq'HEAD'){Invoke-Git $dest checkout --quiet --detach $r.head|Out-Null}else{Invoke-Git $dest checkout --quiet -f $r.branch|Out-Null}
    foreach($f in Get-ChildItem -LiteralPath $src -Recurse -File -Force){  # file by file: .claude\ already exists in the clone
        $rel=$f.FullName.Substring($src.Length+1);if($rel-in'refs.txt','git-config-local.txt'){continue}
        $d=Join-Path $dest $rel;New-Item -ItemType Directory (Split-Path $d -Parent) -Force|Out-Null;Copy-Item -LiteralPath $f.FullName $d
    }
    $got=@(Invoke-Git $dest for-each-ref --format='%(objectname) %(refname)')
    $head=(Invoke-Git $dest rev-parse HEAD).Trim();$dirty=@(Invoke-Git $dest status --porcelain).Count
    $ok=$head-eq$r.head-and!(Compare-Object $want $got)-and$dirty-eq0
    "$(if($ok){'RESTORED'}else{'MISMATCH'}) $($r.name) $($r.branch)@$($head.Substring(0,7)) refs=$($got.Count)/$($want.Count) clean=$($dirty-eq0)"
    if(!$ok){throw "RESTORE_MISMATCH $($r.name)"}
}}catch{"PARTIAL RESTORE: these were created before the failure; remove them before retrying: $($created-join', ')";throw}
Copy-Item (Join-Path $From 'owner-tools') (Join-Path $Target 'ORVION-Owner-Tools') -Recurse
"RESTORED ORVION-Owner-Tools"
foreach($m in Get-ChildItem (Join-Path $From 'claude\projects') -Directory -ErrorAction SilentlyContinue){
    $d=Join-Path $ClaudeHome "projects\$($m.Name)\memory"
    if(Test-Path $d){"SKIPPED claude memory $($m.Name) (exists)"}else{New-Item -ItemType Directory (Split-Path $d -Parent) -Force|Out-Null;Copy-Item (Join-Path $m.FullName 'memory') $d -Recurse;"RESTORED claude memory $($m.Name)"}
}
foreach($f in 'settings.json','statusline.ps1'){
    $s=Join-Path $From "claude\$f";if(!(Test-Path $s)){continue};$d=Join-Path $ClaudeHome $f
    if(Test-Path $d){Copy-Item $s "$d.restored";"KEPT existing $d (backup copy: $f.restored, merge by hand)"}else{New-Item -ItemType Directory $ClaudeHome -Force|Out-Null;Copy-Item $s $d;"RESTORED $d"}
}
if(!$SkipLegacy){foreach($l in Get-ChildItem (Join-Path $From 'legacy') -Directory -ErrorAction SilentlyContinue){
    $d=Join-Path $LegacyTarget $l.Name;if(Test-Path $d){"SKIPPED legacy $($l.Name) (exists)"}else{Copy-Item $l.FullName $d -Recurse;"RESTORED legacy $($l.Name)"}
}}
"NEXT: gh auth login (PlatPlusHub and Shehabhub), then Boot in each repository."
