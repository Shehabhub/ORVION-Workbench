# Small silent check for one long job: prints nothing while the job runs and keeps writing, then exactly one line and exits.
#   DONE      the process exited (the job's own result file says whether it passed)
#   STALLED   the process is alive but nothing under -Path was written for -QuietMinutes; the cause is unproven, nothing is killed
#   UNREADABLE  -Path does not exist (missing evidence is never a healthy state)
# Progress is the newest write time under -Path (file or folder); the dead man's switch is the absence of one.
# Each file is refreshed first: a folder listing shows a stale time for a file held open, which read as STALLED.
# Ceiling: a job that computes silently for longer than -QuietMinutes reads as STALLED; raise it or have the job write a heartbeat.
param([Parameter(Mandatory)][int]$WatchPid,[Parameter(Mandatory)][string[]]$Path,[double]$QuietMinutes=15,[double]$PollSeconds=10)
$ErrorActionPreference='Stop'
function Get-Newest([string[]]$Folders){$t=[datetime]::MinValue;foreach($p in $Folders){if(!(Test-Path -LiteralPath $p)){return $null}
    foreach($i in @(Get-Item -LiteralPath $p -Force)+@(Get-ChildItem -LiteralPath $p -Recurse -Force -File -ErrorAction SilentlyContinue)){$i.Refresh();if($i.LastWriteTimeUtc-gt$t){$t=$i.LastWriteTimeUtc}}};$t}
$last=Get-Newest $Path;if(!$last){'UNREADABLE: a -Path does not exist';exit 1}
$quiet=[Diagnostics.Stopwatch]::StartNew()
while($true){
    if(!(Get-Process -Id $WatchPid -ErrorAction SilentlyContinue)){"DONE: process $WatchPid exited";exit 0}
    $now=Get-Newest $Path;if($now-gt$last){$last=$now;$quiet.Restart()}
    if($quiet.Elapsed.TotalMinutes-ge$QuietMinutes){"STALLED: process $WatchPid alive, nothing written under -Path for $([math]::Round($quiet.Elapsed.TotalMinutes,1)) min; cause unproven";exit 2}
    Start-Sleep -Seconds $PollSeconds}
