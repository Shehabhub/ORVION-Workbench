# The token ledger of DEC-18 (from WS-033 D108): one row per Claude main session in <data root>\records\token-ledger.tsv,
# so each save shows whether the method saves: context size at turns 1 and 10 and at its peak, how often it was compacted
# and at what size, and how much of what the Read tool returned was the same range of a file that session had already
# read, with the most-read file. Read-only over the transcripts. A session whose transcript has not changed size keeps its
# row unparsed, and a session whose transcript is gone keeps its row, so a save costs about a second. Prints the last rows.
# Save-State calls it after the save is whole (-Show 1); the slice cost table stays a status-page step, never a save step.
# Ceiling: counts the characters of tool results, not tokens; a repeat is the same file, offset and limit in one session,
# so overlaps and reads in a later session are not counted and the figure is a lower bound; subagent sidechains are excluded.
param([string]$Checkout=(Split-Path $PSScriptRoot -Parent),[string]$DataRoot,[string[]]$Project,[string]$Out,[int]$Show=6)
$ErrorActionPreference='Stop'
if(!$DataRoot){$DataRoot=if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{Join-Path $Checkout 'data'}}
if(!$Out){$Out=[IO.Path]::Combine($DataRoot,'records','token-ledger.tsv')}
# Claude Code names a project's transcript folder after its path, every character other than a letter or digit a dash.
if(!$Project){$Project=@(Join-Path $HOME ('.claude\projects\'+([IO.Path]::GetFullPath($Checkout).TrimEnd('\')-replace'[^A-Za-z0-9]','-')))}
$columns='Session','LastUtc','Bytes','Turns','Turn1','Turn10','Peak','Compacts','MedianCompactAt','ReadChars','RepeatPct','TopFile','TopReads'
$kept=@{};if(Test-Path -LiteralPath $Out){foreach($row in Import-Csv -LiteralPath $Out -Delimiter "`t"){$kept[$row.Session]=$row}}
$listed=@{};$folders=@($Project|Where-Object{Test-Path -LiteralPath $_ -PathType Container})
$rows=foreach($file in @(if($folders.Count){Get-ChildItem -LiteralPath $folders -Filter *.jsonl})){
    $id=$file.BaseName;$known=$kept[$id];$listed[$id]=1
    if($known-and[long]$known.Bytes-eq$file.Length){$known;continue}
    $seen=@{};$sizes=[Collections.Generic.List[int]]::new();$compactAt=[Collections.Generic.List[int]]::new();$names=@{};$reads=@{};$ranges=@{};$readChars=0L;$repeatChars=0L
    foreach($line in [IO.File]::ReadLines($file.FullName)){
        if($line-notmatch'"compactMetadata"|"usage"|"tool_use"|"tool_result"'){continue}
        try{$entry=$line|ConvertFrom-Json -Depth 40}catch{continue}
        if($entry.isSidechain){continue}
        if($entry.compactMetadata){$compactAt.Add([int]$entry.compactMetadata.preTokens);continue}
        if($entry.type-eq'assistant'-and$entry.message.usage-and!$seen[$entry.message.id]){
            $seen[$entry.message.id]=1;$usage=$entry.message.usage
            $sizes.Add([int]$usage.input_tokens+[int]$usage.cache_read_input_tokens+[int]$usage.cache_creation_input_tokens)
        }
        foreach($block in @($entry.message.content)){
            if($block.type-eq'tool_use'-and$block.name-ceq'Read'){$names[$block.id]=@($block.input.file_path,"$($block.input.file_path)|$($block.input.offset)|$($block.input.limit)")}
            elseif($block.type-eq'tool_result'-and$names[$block.tool_use_id]){
                $path,$range=$names[$block.tool_use_id];$size=("$($block.content|ConvertTo-Json -Depth 6 -Compress)").Length;$readChars+=$size;$reads[$path]=[int]$reads[$path]+1
                if($ranges[$range]){$repeatChars+=$size}else{$ranges[$range]=1}
                $names.Remove($block.tool_use_id)  # a transcript can carry the same result twice
            }
        }
    }
    if(!$sizes.Count){continue}
    $top=@($reads.GetEnumerator()|Sort-Object Value -Descending|Select-Object -First 1)
    $middle=if($compactAt.Count){@($compactAt|Sort-Object)[[int]($compactAt.Count/2)]}else{0}
    [pscustomobject]@{Session=$id;LastUtc=$file.LastWriteTimeUtc.ToString('yyyy-MM-dd HH:mm');Bytes=$file.Length;Turns=$sizes.Count;Turn1=$sizes[0]
        Turn10=$(if($sizes.Count-ge10){$sizes[9]}else{0});Peak=($sizes|Measure-Object -Maximum).Maximum;Compacts=$compactAt.Count;MedianCompactAt=$middle;ReadChars=$readChars
        RepeatPct=$(if($readChars){[int](100*$repeatChars/$readChars)}else{0});TopFile=$(if($top.Count){Split-Path $top[0].Key -Leaf}else{'-'});TopReads=$(if($top.Count){$top[0].Value}else{0})}
}
$sorted=@(@($rows)+@($kept.Values|Where-Object{!$listed[$_.Session]})|Where-Object{$_}|Sort-Object LastUtc)
$lines=@($columns-join"`t")+@($sorted|ForEach-Object{$row=$_;(@($columns|ForEach-Object{$row.$_}))-join"`t"})
[void][IO.Directory]::CreateDirectory((Split-Path $Out -Parent))
[IO.File]::WriteAllText("$Out.tmp",($lines-join"`n")+"`n",[Text.UTF8Encoding]::new($false));[IO.File]::Move("$Out.tmp",$Out,$true)
$sorted|Select-Object -Last $Show|ForEach-Object{"$($_.LastUtc) $($_.Session.Substring(0,8)) turns $($_.Turns) t1 $($_.Turn1) t10 $($_.Turn10) peak $($_.Peak) compacts $($_.Compacts) at $($_.MedianCompactAt) repeat $($_.RepeatPct)% top $($_.TopFile) x$($_.TopReads)"}
