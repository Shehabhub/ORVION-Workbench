# Shared contract-editing helpers for sandbox lifecycle rehearsals. Pure text edits plus the native
# generator; every commit goes through the repository's own pre-commit hook.
function Get-Newline([string]$Text){if($Text.Contains("`r`n")){"`r`n"}else{"`n"}}
function Read-RepoText([string]$Root,[string]$Rel){[IO.File]::ReadAllText((Join-Path $Root $Rel))}
function Write-RepoText([string]$Root,[string]$Rel,[string]$Text){[IO.File]::WriteAllText((Join-Path $Root $Rel),$Text,[Text.UTF8Encoding]::new($false))}
function Set-Once([string]$Text,[string]$Old,[string]$New,[string]$What){
    $n=([regex]::Matches($Text,[regex]::Escape($Old))).Count
    if($n-ne1){throw "ANCHOR_COUNT_${n}:$What"}
    $Text.Replace($Old,$New)
}
function Set-Status([string]$Text,[string]$From,[string]$To){
    $nl=Get-Newline $Text
    $t=Set-Once $Text "[x] $From$nl" "[ ] $From$nl" "status from $From"
    Set-Once $t "[ ] $To$nl" "[x] $To$nl" "status to $To"
}
# Appends an entry at the end of the section that precedes $NextHeading (after its "None.", as the
# native contracts do).
function Add-ToSection([string]$Text,[string]$NextHeading,[string]$Entry){
    $nl=Get-Newline $Text
    Set-Once $Text "$nl## $NextHeading$nl" "$nl$Entry$nl$nl## $NextHeading$nl" "append before $NextHeading"
}
function Set-ManifestLine([string]$Root,[string]$Key,[string]$Value){
    $manifestRel='_ORVION_CANONICAL/manifest.md';$t=Read-RepoText $Root $manifestRel
    # [^\r\n]*, not .*$: on a CRLF working tree .*$ swallows the carriage return and mixes line endings.
    $m=[regex]::Matches($t,"(?m)^$([regex]::Escape($Key)): [^\r\n]*")
    if($m.Count-ne1){throw "MANIFEST_LINE_COUNT:$Key"}
    Write-RepoText $Root $manifestRel ($t.Remove($m[0].Index,$m[0].Length).Insert($m[0].Index,"${Key}: $Value"))
}
function Update-Projections([string]$Root){
    & pwsh -NoProfile -WorkingDirectory $Root -File (Join-Path $Root 'scripts/generate-ai-map.ps1')|Out-Null
    if($LASTEXITCODE){throw 'GENERATOR_FAILED'}
}

# Which Win32_Process rows belong to the tree rooted at $RootId (started $RootCreated): a process joins only if
# its parent joined and it started no earlier than that parent. Windows reuses process ids and leaves a dead
# parent's id on its children, so a parent id alone can adopt an unrelated process; and a parent id now held by
# a younger, unrelated process passes on only children born before that process. Returns id -> start time.
# ponytail: a grandchild whose parent died before the first scan and whose id was then reused is not found.
function Select-OwnedProcesses($Rows,[int]$RootId,[datetime]$RootCreated,[hashtable]$Known=@{}){
    if(-not$Known.Count){$Known[$RootId]=$RootCreated}
    $holder=@{};foreach($x in $Rows){$holder[[int]$x.ProcessId]=$x.CreationDate}
    do{$n=$Known.Count
        foreach($x in $Rows){$id=[int]$x.ProcessId;$p=[int]$x.ParentProcessId
            if($Known.ContainsKey($id)-or-not$Known.ContainsKey($p)-or$x.CreationDate-lt$Known[$p]){continue}
            if($holder.ContainsKey($p)-and$holder[$p]-ne$Known[$p]-and$x.CreationDate-ge$holder[$p]){continue}
            $Known[$id]=$x.CreationDate}
    }while($Known.Count-gt$n)
    $Known
}
# Stops a process and every descendant, including children spawned while the stop runs and children of a root
# that has already exited. A single tree snapshot missed a control suite started mid-kill on 2026-10-19 (it ran
# orphaned for 20 minutes and held the rehearsal's output pipe), so this rescans until nothing it owns is alive,
# and kills only processes whose id AND start time it recorded. Bounded by $Rounds; the caller must treat
# Survivors > 0 as a failure.
function Stop-ProcessTreeFully([int]$RootId,[datetime]$RootCreated,[int]$Rounds=10){
    $row=Get-CimInstance Win32_Process -Filter "ProcessId=$RootId"
    if($row-and[Math]::Abs(($row.CreationDate-$RootCreated).TotalSeconds)-lt1){$RootCreated=$row.CreationDate}
    $born=@{};$live=@()
    for($i=0;$i-le$Rounds;$i++){
        $all=@(Get-CimInstance Win32_Process)
        $born=Select-OwnedProcesses $all $RootId $RootCreated $born
        $live=@($all|Where-Object{$born.ContainsKey([int]$_.ProcessId)-and$_.CreationDate-eq$born[[int]$_.ProcessId]}|Sort-Object CreationDate -Descending)
        if(-not$live.Count-or$i-eq$Rounds){break}
        foreach($x in $live){Stop-Process -Id $x.ProcessId -Force -ErrorAction SilentlyContinue};Start-Sleep -Milliseconds 500
    }
    [pscustomobject]@{Stopped=$born.Count;Survivors=$live.Count}
}