# Read-only Markdown check. Working uses the Git index inventory with working bytes;
# Index or a tree-ish uses only selected Git blobs. No external reference is opened.
param([string]$Root=(Split-Path $PSScriptRoot -Parent),[string]$Tree='Working')
$ErrorActionPreference='Stop'
function Invoke-MarkdownGit([string]$Root,[string[]]$Arguments,[string]$Feed=''){
    $start=[Diagnostics.ProcessStartInfo]::new('git');$start.WorkingDirectory=$Root
    $start.UseShellExecute=$false;$start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true;$start.RedirectStandardInput=$true
    foreach($argument in $Arguments){$start.ArgumentList.Add($argument)}
    $process=[Diagnostics.Process]::Start($start);$buffer=[IO.MemoryStream]::new()
    try{
        $copy=$process.StandardOutput.BaseStream.CopyToAsync($buffer);$diagnostic=$process.StandardError.ReadToEndAsync()
        $process.StandardInput.Write($Feed);$process.StandardInput.Close();$null=$copy.GetAwaiter().GetResult();$process.WaitForExit()
        if($process.ExitCode-ne0){throw 'MD_GIT_UNREADABLE'}
        return ,$buffer.ToArray()
    }finally{$buffer.Dispose();$process.Dispose()}
}
function Get-MarkdownInput([string]$Root,[string]$Tree){
    $utf8=[Text.UTF8Encoding]::new($false,$true);$files=[Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
    $objects=@{};$inventory=if($Tree-in'Working','Index'){@('ls-files','--stage','-z')}else{@('ls-tree','-rz','--full-tree',$Tree)}
    $listing=$utf8.GetString((Invoke-MarkdownGit $Root $inventory))
    foreach($entry in $listing.Split([char]0,[StringSplitOptions]::RemoveEmptyEntries)){
        if($entry-notmatch '^(\d+) (?:blob )?([a-f0-9]{40,64})(?: (\d))?\t(.+)$'){throw 'MD_INVENTORY_UNREADABLE'}
        $mode=$Matches[1];$object=$Matches[2];$stage=$Matches[3];$path=$Matches[4]
        if($stage-and$stage-ne'0'){throw 'MD_INDEX_UNMERGED'}
        if($path-notmatch '(?i)\.md$'){continue}
        if($mode-notin'100644','100755'){throw "MD_INPUT_MODE: $path"}
        if($Tree-eq'Working'){
            $cursor=$Root
            foreach($part in $path.Split('/')){
                $cursor=Join-Path $cursor $part
                if(([IO.File]::GetAttributes($cursor)-band[IO.FileAttributes]::ReparsePoint)-ne0){throw "MD_INPUT_REPARSE: $path"}
            }
            $files.Add($path,$utf8.GetString([IO.File]::ReadAllBytes($cursor)))
        }else{$objects[$path]=$object}
    }
    if($Tree-ne'Working'-and$objects.Count){
        $paths=@($objects.Keys|Sort-Object -CaseSensitive)
        $bytes=Invoke-MarkdownGit $Root @('cat-file','--batch') ((($paths|ForEach-Object{$objects[$_]})-join"`n")+"`n")
        $offset=0
        foreach($path in $paths){
            $end=$offset;while($end-lt$bytes.Length-and$bytes[$end]-ne10){$end++}
            $header=[Text.Encoding]::ASCII.GetString($bytes,$offset,$end-$offset)
            if($header-notmatch '^[a-f0-9]{40,64} blob (\d+)$'){throw 'MD_BLOB_UNREADABLE'}
            $length=[int]$Matches[1];$offset=$end+1
            $files.Add($path,$utf8.GetString($bytes,$offset,$length));$offset+=$length+1
        }
    }
    if(!$files.Count){throw 'MD_INPUT_EMPTY'}
    foreach($path in $files.Keys){if([string]::IsNullOrWhiteSpace($files[$path])){throw "MD_INPUT_EMPTY: $path"}}
    return ,$files
}
function Get-MarkdownPlain([string]$Content){
    $lines=[Collections.Generic.List[string]]::new();$fence='';$size=0
    foreach($line in ($Content-replace"`r`n","`n").Split("`n")){
        if($line-match '^ {0,3}(`{3,}|~{3,})'){
            $marker=$Matches[1]
            if(!$fence){$fence=$marker.Substring(0,1);$size=$marker.Length}
            elseif($marker.StartsWith($fence)-and$marker.Length-ge$size-and$line-match '^ {0,3}(`+|~+)\s*$'){$fence=''}
            $lines.Add('');continue
        }
        if(!$fence){$lines.Add($line)}else{$lines.Add('')}
    }
    return $lines-join"`n"
}
function Get-MarkdownAnchors([string]$Content){
    $previous=$null;$anchors=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach($line in (Get-MarkdownPlain $Content).Split("`n")){
        if($line-match '^ {0,3}#{1,6}\s+(.+?)\s*#*\s*$'){
            $slug=$Matches[1]-replace '\[([^\]]+)\]\([^)]*\)','$1'
            $slug=($slug.ToLowerInvariant()-replace '[^\p{L}\p{M}\p{N}_\-\s]','')-replace '\s','-'
            $base=$slug;$number=0
            while($anchors.Contains($slug)){$number++;$slug="$base-$number"}
            [void]$anchors.Add($slug)
        }elseif($line-match '^\s*(?:=+|-+)\s*$'-and$previous-and$previous-notmatch '^\s*[|#>-]'){
            $slug=($previous.ToLowerInvariant()-replace '[^\p{L}\p{M}\p{N}_\-\s]','')-replace '\s','-'
            $base=$slug;$number=0;while($anchors.Contains($slug)){$number++;$slug="$base-$number"};[void]$anchors.Add($slug)
        }
        foreach($tag in [regex]::Matches($line,'(?i)<(?:a|h[1-6])\s+[^>]*(?:id|name)=["'']([^"'']+)["'']')){[void]$anchors.Add($tag.Groups[1].Value)}
        $previous=$line
    }
    return ,$anchors
}
function Get-MarkdownLinks([string]$Content){
    $plain=Get-MarkdownPlain $Content;$definitions=@{}
    foreach($definition in [regex]::Matches($plain,'(?m)^ {0,3}\[([^\]]+)\]:\s*(?:<([^>]+)>|(\S+))')){
        $definitions[($definition.Groups[1].Value.ToLowerInvariant()-replace '\s+',' ')]=$definition.Groups[2].Value+$definition.Groups[3].Value
    }
    $plain=$plain-replace '(?m)^ {0,3}\[[^\]]+\]:[^\n]*',''
    $plain=$plain-replace '`+[^`\n]*`+',''
    $inline='!?\[[^\]\n]*\]\(\s*(?:<([^>]+)>|((?:[^\s()\\]|\\.|(?<Paren>\()|(?<-Paren>\)))+)(?(Paren)(?!)))(?:\s+["''][^\n]*?["''])?\s*\)'
    foreach($link in [regex]::Matches($plain,$inline)){$link.Groups[1].Value+$link.Groups[2].Value}
    $plain=$plain-replace $inline,''
    foreach($link in [regex]::Matches($plain,'\[([^\]\n]+)\](?:\[([^\]\n]*)\])?')){
        $label=if($link.Groups[2].Success-and$link.Groups[2].Value){$link.Groups[2].Value}else{$link.Groups[1].Value}
        $key=$label.ToLowerInvariant()-replace '\s+',' '
        if($definitions.ContainsKey($key)){$definitions[$key]}
        elseif($link.Groups[2].Success){throw "MD_REFERENCE_MISSING: $label"}
    }
    foreach($link in [regex]::Matches($plain,'<((?:\.?\.?/|#)[^<>\s]+)>')){$link.Groups[1].Value}
}
function Resolve-MarkdownLink([string]$Source,[string]$Link,$Files,$Anchors){
    # URI schemes, rooted paths and sibling/private pointers are opaque; never stat them.
    $Link=[Net.WebUtility]::HtmlDecode($Link)-replace '\\([() ])','$1'
    if($Link-match '^(?:[a-zA-Z][\w+.-]*:|[/\\]{1,2})'){return}
    $parts=$Link.Split('#',2);$target=[Uri]::UnescapeDataString($parts[0]).Replace('\','/')
    $stack=[Collections.Generic.List[string]]::new();$outside=0
    foreach($part in (($Source-replace '[^/]+$','')+$target).Split('/')){
        if($part-eq'..'){if(!$stack.Count){$outside++}else{$stack.RemoveAt($stack.Count-1)}}elseif($part-and$part-ne'.'){$stack.Add($part)}
    }
    if($outside){if(($stack-join'/')-cmatch '^ORVION-Owner-Tools/(?:STATE\.md$|records/)'){return};throw "MD_EXTERNAL_UNAPPROVED: $Source -> $Link"}
    $resolved=if(!$target){$Source}else{$stack-join'/'}
    if($resolved.EndsWith('/')){$resolved=$resolved.TrimEnd('/')}
    if(!$resolved-or$Link.EndsWith('/')){
        if(!@($Files.Keys|Where-Object{$_.StartsWith("$resolved/",[StringComparison]::Ordinal)}).Count){throw "MD_LINK_MISSING: $Source -> $Link"};return
    }
    if(!$Files.ContainsKey($resolved)){throw "MD_LINK_MISSING: $Source -> $Link"}
    if($parts.Count-eq2-and$parts[1]-and$Anchors.ContainsKey($resolved)-and!$Anchors[$resolved].Contains([Uri]::UnescapeDataString($parts[1]))){throw "MD_ANCHOR_MISSING: $Source -> $Link"}
    return $resolved
}
function Test-MarkdownConsistency([string]$Root,[string]$Tree='Working'){
    $files=Get-MarkdownInput $Root $Tree;$anchors=@{};$edges=@{};$budgets=@{ 'AGENTS.md'=100;'README.md'=400;'RESUME.md'=120;'HANDOFF.md'=600;'WORKFLOW.md'=2400 }
    foreach($path in $files.Keys){$anchors[$path]=Get-MarkdownAnchors $files[$path]}
    # Other tracked targets may be linked, but only Markdown files participate in reachability.
    $targets=[Collections.Generic.Dictionary[string,string]]::new($files,[StringComparer]::Ordinal)
    $arguments=if($Tree-in'Working','Index'){@('ls-files','-z')}else{@('ls-tree','-rz','--name-only',$Tree)}
    foreach($path in ([Text.Encoding]::UTF8.GetString((Invoke-MarkdownGit $Root $arguments))).Split([char]0,[StringSplitOptions]::RemoveEmptyEntries)){if(!$targets.ContainsKey($path)){$targets.Add($path,'')}}
    $wordCounts=[ordered]@{}
    foreach($path in $budgets.Keys){
        if(!$files.ContainsKey($path)){throw "MD_ROOT_MISSING: $path"}
        $wordCounts[$path]=[regex]::Matches($files[$path],'\S+').Count
        if($wordCounts[$path]-gt$budgets[$path]){throw "MD_BUDGET: $path"}
    }
    $workflow=$files['WORKFLOW.md'];$history=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $indexes=[regex]::Matches($workflow,'(?ms)^## History index\r?\n(.*?)(?=^## |\z)')
    if($indexes.Count-ne1){throw 'MD_HISTORY_INDEX'}
    foreach($line in $indexes[0].Groups[1].Value.Split("`n")){if($line.Trim()-and$line-notmatch '^- \[[^\]]+\]\([^)]+\)\r?$'){throw 'MD_HISTORY_FORMAT'}}
    foreach($link in (Get-MarkdownLinks $indexes[0].Groups[1].Value)){
        if($link-cnotmatch '^(?:changes/WS-[^/]+\.md|docs/history/.+\.md)$'-or!$files.ContainsKey($link)-or!$history.Add($link)){throw "MD_HISTORY_ENTRY: $link"}
    }
    # Allocated contracts are judge-governed history by name (a contract's own file appears only at allocation, so an
    # explicit listing could never pass its own Finish); any other file under changes/ must still be reachable.
    foreach($path in $files.Keys){if($path-cmatch'^changes/WS-\d{3}-[A-Za-z0-9-]+\.md$'){[void]$history.Add($path)}}
    foreach($path in $files.Keys){
        $edges[$path]=if($history.Contains($path)){@()}else{@(foreach($link in (Get-MarkdownLinks $files[$path])){Resolve-MarkdownLink $path $link $targets $anchors})}
    }
    $expected=@('Arrival','Purpose','Active contract','Batch 6 closure','Governance','Programme plan','Workspace layout','Recovery','Tool catalogue','Contract template')
    $owners=@{'Arrival'='AGENTS.md';'Purpose'='README.md';'Active contract'='RESUME.md';'Batch 6 closure'='HANDOFF.md';'Governance'='WORKFLOW.md';'Programme plan'='docs/EXECUTION-PLAN.md';'Workspace layout'='docs/WORKSPACE-LAYOUT.md';'Recovery'='docs/RECOVERY.md';'Tool catalogue'='lib/README.md';'Contract template'='changes/TEMPLATE.md'}
    $homes=[regex]::Matches($workflow,'(?ms)^## One-home table\r?\n(.*?)(?=^## |\z)')
    if($homes.Count-ne1){throw 'MD_HOME_TABLE'}
    $rows=[regex]::Matches($homes[0].Groups[1].Value,'(?m)^\| ([^|]+?) \| \[[^\]]+\]\(([^)]+)\) \|\r?$');$concepts=@{};$locations=@{}
    if(@($homes[0].Groups[1].Value.Split("`n")|Where-Object{$_.Trim()}).Count-ne$rows.Count+2){throw 'MD_HOME_FORMAT'}
    foreach($row in $rows){
        $concept=$row.Groups[1].Value;$location=$row.Groups[2].Value
        if($concept-notin$expected-or$concepts.ContainsKey($concept)-or$locations.ContainsKey($location)-or($location-notmatch '#.+$'-and!($concept-ceq'Active contract'-and$location-ceq'RESUME.md'))){throw 'MD_HOME_ROW'}
        if($location.Split('#')[0]-cne$owners[$concept]){throw 'MD_HOME_OWNER'}
        $concepts[$concept]=$true;$locations[$location]=$true
    }
    if($concepts.Count-ne$expected.Count){throw 'MD_HOME_MISSING'}
    $reachable=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal);$queue=[Collections.Generic.Queue[string]]::new()
    $queue.Enqueue('README.md');$queue.Enqueue('AGENTS.md')
    while($queue.Count){$path=$queue.Dequeue();if($reachable.Add($path)){foreach($next in $edges[$path]){if($files.ContainsKey($next)){$queue.Enqueue($next)}}}}
    $paragraphs=@{};$retired='(?i)(?:Documents[/\\]ORVION-(?:Owner-Review|Sandbox)|ORVION-Owner-Tools[/\\]lib|C:[/\\](?:cx|ORVION-Temp)(?=[/\\\s`"''<]|$)|GitHub[/\\]ORVION-Recovery-Inputs)'
    foreach($path in $files.Keys){
        if(!$reachable.Contains($path)-and!$history.Contains($path)){throw "MD_ORPHAN: $path"}
        if($history.Contains($path)-or$path-clike'changes/WS-*.md'){continue}
        if($path-cne'RESUME.md'-and$files[$path].Contains('Active Workbench Contract:')){throw "MD_POINTER_HOME: $path"}
        $plain=Get-MarkdownPlain $files[$path]
        $header=($plain-split '(?m)^## ',2)[0]
        $dates=@([regex]::Matches($header,'(?im)^(?:Version[^\n]*?\|\s*|(?:Updated|Amended|Amendment|Last updated)(?:\s*:)?\s+)(\d{4}-\d{2}-\d{2})')|Select-Object -First 1|ForEach-Object{$_.Groups[1].Value})
        $amendments=@([regex]::Matches($plain,'(?i)\b(?:amended|amendment|updated)\b[^\n\d]{0,60}(\d{4}-\d{2}-\d{2})')|ForEach-Object{$_.Groups[1].Value}|Sort-Object)
        if($dates.Count-and$amendments.Count-and$dates[-1]-clt$amendments[-1]){throw "MD_STALE_DATE: $path"}
        foreach($paragraph in [regex]::Split(($files[$path]-replace"`r`n","`n").Trim(),'\n\s*\n')){
            $routing=$paragraph-replace '\[historical citation:[^\]]*\]\(<[^>]+>\)',''
            if($routing-match$retired-and$routing-notmatch '^Historical citation:'){throw "MD_RETIRED_ROUTE: $path"}
            if($paragraph-match$retired-and(($routing-match '^Historical citation:'-and$routing-match '(?i)\b(?:run|execute|invoke|pwsh|powershell|start at|follow|use)\b')-or$paragraph-match '(?im)^\s*(?:\d+\.\s*)?(?:run|execute|invoke|pwsh|powershell|start at|follow|use)\b')){throw "MD_RETIRED_INSTRUCTION: $path"}
        }
        foreach($paragraph in [regex]::Split($plain.Trim(),'\n\s*\n')){
            if($paragraph-match '(?m)^\s*(?:#|\||[-*+] |\d+[.)] |>|<)'){continue}
            $normalized=([regex]::Replace($paragraph,'\s+',' ')).Trim()
            if([regex]::Matches($normalized,'\S+').Count-ge25){
                if($paragraphs.ContainsKey($normalized)){throw "MD_DUPLICATE_PROSE: $($paragraphs[$normalized]), $path"}
                $paragraphs[$normalized]=$path
            }
        }
    }
    [pscustomobject]@{Result='MARKDOWN_CONSISTENCY PASS';Files=$files.Count;Words=$wordCounts}
}
if($MyInvocation.InvocationName-ne'.'){
    try{$result=Test-MarkdownConsistency $Root $Tree;$result.Result}catch{Write-Output $_.Exception.Message;exit 1}
}
