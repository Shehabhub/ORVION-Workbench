# Turns a sandbox clone's uncommitted diff into literal Implementation Steps: each file's hunks become
# "immediately after <unique anchor> insert" / "replace <unique block> with" edits, applied in order to a
# simulated copy so every anchor is unique where it is applied, ending with the blob the step must produce.
# Generalised from evidence\20261019-cr-da\make-draft.ps1 (SPEC-290/292). Dot-source, then call
# Get-DraftFileStep. -ExpectedBlob overrides the sandbox blob for a file the lifecycle also edits before
# the step runs (the manifest's Active Change Request line is set at Approval).
function Get-IndentedBlock([string[]]$L){($L|ForEach-Object{if($_-eq''){''}else{"   $_"}})-join"`n"}
function Get-Fence([string[]]$L){"   ``````text`n"+(Get-IndentedBlock $L)+"`n   ``````"}
function Get-FileEdits([string]$Sb,[string]$f){
    $cur=[Collections.Generic.List[string]]::new([string[]]@((git -C $Sb show "HEAD:$f")-split"`r?`n"));$parts=@();$delta=0
    # Counted as apply-draft-steps.ps1 matches: a substring of the whole text, not whole lines (a block unique as lines
    # matched 5 times as a substring, contract-A rehearsal 2026-10-20).
    function Count-Block([string[]]$B){([regex]::Matches(($cur-join"`n"),[regex]::Escape($B-join"`n"))).Count}
    $diff=@(git -C $Sb -c core.autocrlf=true diff -U0 --no-color -- $f);if($LASTEXITCODE){throw "DIFF_FAILED $f"}
    $i=0
    while($i-lt$diff.Count){
        $m=[regex]::Match($diff[$i],'^@@ -(\d+)(?:,(\d+))? \+\d+(?:,\d+)? @@');$i++
        if(-not$m.Success){continue}
        $a=[int]$m.Groups[1].Value;$k=if($m.Groups[2].Success){[int]$m.Groups[2].Value}else{1}
        $old=@();$new=@()
        while($i-lt$diff.Count-and$diff[$i]-notmatch'^@@ '){if($diff[$i].StartsWith('-')){$old+=$diff[$i].Substring(1)}elseif($diff[$i].StartsWith('+')){$new+=$diff[$i].Substring(1)};$i++}
        if($k-eq0){
            $end=$a+$delta
            $n=1;do{$anc=@($cur.GetRange($end-$n,$n));$hits=Count-Block $anc;$n++}while($hits-ne1-and$n-lt8)
            if($hits-ne1){throw "ANCHOR_NOT_UNIQUE $f @$a"}
            $cur.InsertRange($end,[string[]]$new);$delta+=$new.Count
            $parts+="immediately after the line$(if($anc.Count-gt1){'s'})`n$(Get-Fence $anc)`n   insert`n$(Get-Fence $new)"
        }else{
            $at=$a-1+$delta
            if((@($cur.GetRange($at,$k))-join"`n")-cne($old-join"`n")){throw "SIMULATION_DRIFT $f @$a"}
            # A replaced block that also occurs elsewhere grows by its preceding unchanged lines until unique; a pure
            # deletion grows at least once, since "replace with nothing" would leave an empty line behind.
            $ctx=0;while(((Count-Block $old)-ne1-or$new.Count-eq0)-and$ctx-lt8-and$at-$ctx-gt0){$ctx++;$lead=$cur[$at-$ctx];$old=@($lead)+$old;$new=@($lead)+$new}
            if((Count-Block $old)-ne1-or$new.Count-eq0){throw "BLOCK_NOT_UNIQUE $f @$a"}
            $cur.RemoveRange($at-$ctx,$k+$ctx);$cur.InsertRange($at-$ctx,[string[]]$new);$delta+=$new.Count-$k-$ctx
            $parts+="replace the line$(if($old.Count-gt1){'s'})`n$(Get-Fence $old)`n   with`n$(Get-Fence $new)"
        }
    }
    $parts
}
function Get-DraftFileStep([string]$Sb,[string]$File,[string]$Marker,[string]$What,[string]$ExpectedBlob){
    # the resume marker must be in the edited file, or a resumed run could never say Already Applied (wave-1 review, 2026-10-20)
    $raw=[IO.File]::ReadAllText((Join-Path $Sb $File))
    if(-not$raw.Contains($Marker)){throw "MARKER_ABSENT $File :: $Marker"}
    # the steps cannot say "no newline at end of file"; such a file would never reproduce its blob
    if($raw.Length-and-not$raw.EndsWith("`n")){throw "NO_FINAL_NEWLINE $File"}
    $e=@(Get-FileEdits $Sb $File);if(!$e.Count){throw "NO_EDITS $File"}
    $nb=if($ExpectedBlob){$ExpectedBlob}else{(git -C $Sb hash-object -- $File).Trim()}
    $body="Check whether ``$File`` contains ``$Marker``; if so record Already Applied when its Git blob is $nb, and otherwise stop and report. Otherwise make exactly $(if($e.Count-gt1){"these $($e.Count) edits"}else{'this one edit'}) ($What), each matched once, and change nothing else:`n`n"
    $n=0;foreach($p in $e){$n++;$body+="   $([char](96+$n))) $p`n`n"}
    [pscustomobject]@{Text=$body+"   The resulting file's Git blob is $nb.";Blob=$nb}
}
