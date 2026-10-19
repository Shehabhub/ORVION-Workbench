# Host resource monitor (agent tooling, not repository code): an EVENT STREAM for the Monitor tool, one line
# per threshold crossing, silent otherwise. Replaces the hand-written alarm loops of 2026-10-19 (one matched
# `^END` and never fired; one used physical memory alone and fired at 1.9 GB while commit headroom was
# 10 GB). Measured that day: physical free near 2 GB slowed the control suite from 36 to 47 minutes by
# paging, while commit headroom predicts failure; so the two are reported as different things.
#   PRESSURE   physical free < -PhysGB: expect slowdown (paging), nothing has failed
#   COMMIT LOW commit headroom < -CommitGB: allocations can start to fail; consider stopping a run
#   OK         the condition cleared (hysteresis +0.5 GB, so a value hovering at the line does not flap)
#   PID GONE   a process named in -WatchPid exited; with -ExitWhenPidsGone the watch ends when all have
# Read-only.
param([double]$PhysGB=1.5,[double]$CommitGB=3,[int]$PollSeconds=15,[int[]]$WatchPid,[switch]$ExitWhenPidsGone)
$ErrorActionPreference='Stop'
$WatchPid=@($WatchPid|ForEach-Object{"$_"-split','}|Where-Object{$_}|ForEach-Object{[int]$_})
$state=@{phys=$false;commit=$false};$alive=@{};foreach($p in $WatchPid){$alive[$p]=$true}
function Get-Mem{$o=Get-CimInstance Win32_OperatingSystem;[pscustomobject]@{Phys=[Math]::Round($o.FreePhysicalMemory/1MB,2);Commit=[Math]::Round($o.FreeVirtualMemory/1MB,2)}}
$m=Get-Mem;"WATCHING host: phys free $($m.Phys) GB, commit headroom $($m.Commit) GB; thresholds phys<$PhysGB commit<$CommitGB$(if($WatchPid.Count){"; pids $($WatchPid-join',')"})"
while($true){
    $m=Get-Mem
    if(!$state.phys-and$m.Phys-lt$PhysGB){"PRESSURE phys free $($m.Phys) GB (< $PhysGB): expect slowdown from paging; commit headroom $($m.Commit) GB";$state.phys=$true}
    elseif($state.phys-and$m.Phys-ge$PhysGB+0.5){"OK phys free $($m.Phys) GB";$state.phys=$false}
    if(!$state.commit-and$m.Commit-lt$CommitGB){"COMMIT LOW headroom $($m.Commit) GB (< $CommitGB): allocations may fail; stop the newest heavy run rather than lose both";$state.commit=$true
        $null=& (Join-Path $PSScriptRoot 'Events.ps1') -Add -Pattern host-memory-pressure -Source monitor -Category observation -Severity high -Summary "commit headroom fell to $($m.Commit) GB" -Tags 'ram memory commit finish suite parallel' 2>$null}  # improvement memory
    elseif($state.commit-and$m.Commit-ge$CommitGB+0.5){"OK commit headroom $($m.Commit) GB";$state.commit=$false}
    foreach($p in @($alive.Keys)){if($alive[$p]-and!(Get-Process -Id $p -ErrorAction SilentlyContinue)){"PID GONE $p";$alive[$p]=$false}}
    if($ExitWhenPidsGone-and$WatchPid.Count-and!@($alive.Values|Where-Object{$_}).Count){'ALL PIDS GONE';exit 0}
    Start-Sleep -Seconds $PollSeconds
}
