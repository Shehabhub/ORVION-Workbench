# Applies a Draft's file-edit steps literally to a checkout at the baseline and compares each result with
# the blob the step names. Proves the steps are deterministic and complete, using the Draft's text alone.
param([Parameter(Mandatory)][string]$Draft,[Parameter(Mandatory)][string]$Root)
$ErrorActionPreference='Stop'
$t=[IO.File]::ReadAllText($Draft)-replace"`r`n","`n"
$steps=[regex]::Match($t,'(?s)## Implementation Steps\n\n(.*?)\n## Acceptance Criteria').Groups[1].Value
$items=[regex]::Split($steps,'(?m)^(?=\d+\. )')|Where-Object{$_-match'^\d+\. Check whether `([^`]+)` contains'}
$fail=0
foreach($it in $items){
    $file=[regex]::Match($it,'^\d+\. Check whether `([^`]+)`').Groups[1].Value
    $want=[regex]::Match($it,"The resulting file's Git blob is ([0-9a-f]{40})").Groups[1].Value
    $p=Join-Path $Root $file;$raw=[IO.File]::ReadAllText($p);$nl=if($raw.Contains("`r`n")){"`r`n"}else{"`n"};$text=$raw-replace"`r`n","`n"
    # @() keeps a one-edit file a list: unwrapped, $ops[0] is the first CHARACTER of the only op.
    $fences=@([regex]::Matches($it,'(?s)   ```text\n(.*?)\n   ```')|ForEach-Object{(@($_.Groups[1].Value-split"`n")|ForEach-Object{if($_.StartsWith('   ')){$_.Substring(3)}else{$_}})-join"`n"})
    $ops=@([regex]::Matches($it,'(?m)^   [a-z]\) (immediately after the lines?|replace the lines?)')|ForEach-Object{$_.Groups[1].Value})
    if($fences.Count-ne2*$ops.Count){throw "$file fences=$($fences.Count) ops=$($ops.Count)"}
    for($i=0;$i-lt$ops.Count;$i++){
        $a=$fences[2*$i];$b=$fences[2*$i+1]
        $c=([regex]::Matches($text,[regex]::Escape($a))).Count;if($c-ne1){throw "$file op $i matched $c times"}
        $at=$text.IndexOf($a,[StringComparison]::Ordinal)
        $text=if($ops[$i].StartsWith('replace')){$text.Remove($at,$a.Length).Insert($at,$b)}else{$text.Insert($at+$a.Length,"`n"+$b)}
    }
    [IO.File]::WriteAllText($p,($text-replace"`n",$nl),[Text.UTF8Encoding]::new($false))
    $got=(git -C $Root hash-object -- $file).Trim()
    "{0,-40} ops={1} blob={2} {3}" -f $file,$ops.Count,$got,$(if($got-eq$want){'MATCHES the Draft'}else{$fail++;"DIFFERS (Draft says $want)"})
}
"files: $($items.Count), mismatches: $fail"
exit $fail
