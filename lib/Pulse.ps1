# ORVION pulse: the workspace's live state in a dozen lines, for any agent arriving (the session-start hook prints it;
# Codex and others run it themselves). Everything is read at call time; nothing here is stored or authoritative.
#   repos      each repository: branch@HEAD, clean, ahead/behind its upstream as of the last fetch, pending candidates
#   running    the session archiver, timed runs (with their log's last line), host memory
#   waiting    open owner decisions (events with category decision)
#   last       the newest other session: task, when it ended, where it stopped
#   lessons    open or recurring events (Events.ps1 -Brief, decisions excluded)
# Read-only; a failing git read prints UNREADABLE for that repository instead of guessing.
param([string]$Root=(Split-Path $PSScriptRoot -Parent),[string]$Session=$env:CLAUDE_CODE_SESSION_ID,
      [string[]]$Repos=@('CRM','ORVION'|ForEach-Object{Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) $_}))
$ErrorActionPreference='Stop'
function Get-GitLine{param([string]$Repo)$o=& git -C $Repo @args 2>$null;if($LASTEXITCODE){throw "git $($args-join' ')"};"$o".Trim()}
"ORVION PULSE $([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC"
foreach($r in $Repos|Where-Object{Test-Path (Join-Path $_ '.git')}){
    $name=Split-Path $r -Leaf
    try{
        $head=Get-GitLine $r rev-parse --short HEAD;$branch=Get-GitLine $r rev-parse --abbrev-ref HEAD
        $dirty=@(& git -C $r status --porcelain 2>$null).Count;if($LASTEXITCODE){throw 'status'}
        $ab=try{(Get-GitLine $r rev-list --left-right --count 'HEAD...@{u}')-split'\s+'}catch{$null}
        # a pending tail already contained in the upstream was released: say so, it is only a leftover branch
        $pending=@(& git -C $r for-each-ref --format='%(refname:short) %(objectname)' 'refs/heads/orvion/*-pending' 2>$null|ForEach-Object{
            $n,$sha=$_-split' ';& git -C $r merge-base --is-ancestor $sha '@{u}' 2>$null;$gone=$LASTEXITCODE-eq0
            "$n@$($sha.Substring(0,7))$(if($gone){' (released, leftover branch)'})"})
        $state=if($ab){"$($ab[0]) ahead / $($ab[1]) behind upstream (last fetch)"}else{'no upstream'}
        "repo     $name $branch@$head $(if($dirty){"DIRTY($dirty)"}else{'clean'}), $state$(if($pending){"; pending: $($pending-join', ')"})"
    }catch{"repo     $name UNREADABLE ($($_.Exception.Message))"}
}
$procs=@(Get-CimInstance Win32_Process -Filter "Name='pwsh.exe'"|Where-Object{$_.CommandLine})
$follow=@($procs|Where-Object{$_.CommandLine-match'Sync-Sessions\.ps1.*-Follow'})
$timed=@($procs|Where-Object{$_.CommandLine-match'run_timed\.ps1'}|ForEach-Object{
    $log=[regex]::Match($_.CommandLine,'-Log\s+"?([^"]+?)"?(\s+-|\s*$)').Groups[1].Value
    $last=if($log-and(Test-Path -LiteralPath $log)){@(Get-Content -LiteralPath $log -Tail 1)[0]}else{''}
    "pid $($_.ProcessId)$(if($log){" $log"})$(if($last){": $($last.Substring(0,[Math]::Min(80,$last.Length)))"})"})
$os=Get-CimInstance Win32_OperatingSystem
"running  archiver $(if($follow){"following (pid $($follow[0].ProcessId))"}else{'NOT running (start a session or: Sync-Sessions.ps1 -Follow)'}); timed runs: $(if($timed){$timed-join' | '}else{'none'}); host: $([math]::Round($os.FreePhysicalMemory/1MB,1)) GB free, commit headroom $([math]::Round($os.FreeVirtualMemory/1MB,1)) GB"
# Decisions and lessons from the event log (latest record per pattern decides).
$log=Join-Path $Root 'events\events.jsonl'
$latest=@(if(Test-Path $log){[IO.File]::ReadAllLines($log)|Where-Object{$_}|ForEach-Object{$_|ConvertFrom-Json}|Group-Object pattern|ForEach-Object{@($_.Group|Sort-Object at)[-1]}})
$waiting=@($latest|Where-Object{$_.category-eq'decision'-and$_.status-eq'open'})
"waiting  on the owner: $($waiting.Count)"
foreach($w in $waiting){"         - $($w.pattern): $($w.summary.Substring(0,[Math]::Min(150,$w.summary.Length)))$(if($w.summary.Length-gt150){'...'})"}
$ixPath=Join-Path $Root 'sessions\index.jsonl'
$prev=@(if(Test-Path $ixPath){[IO.File]::ReadAllLines($ixPath)|Where-Object{$_}|ForEach-Object{$_|ConvertFrom-Json}|Where-Object{$_.id-ne$Session-and$_.prompts}|Sort-Object end})|Select-Object -Last 1
if($prev){"last     session $($prev.id.Substring(0,[Math]::Min(8,$prev.id.Length))) [$($prev.repo) $($prev.client)] `"$(@($prev.title,$prev.firstPrompt)|Where-Object{$_}|Select-Object -First 1)`" ended $(([datetime]$prev.end).ToUniversalTime().ToString('yyyy-MM-dd HH:mm')); last ask: `"$($prev.lastPrompt)`""}
$lessons=@($latest|Where-Object{$_.category-ne'decision'-and$_.status-in'open','deferred'}|Sort-Object at -Descending|Select-Object -First 3)
"lessons  open: $(@($latest|Where-Object{$_.category-ne'decision'-and$_.status-in'open','deferred'}).Count) ($(($lessons|ForEach-Object pattern)-join', ')); details: Events.ps1 -Brief"
"tools    Spider.ps1 '<anything>' (all sources) | Events.ps1 -Find '<task>' | Delegate.ps1 -List | sessions\INDEX.md | lib\README.md"
