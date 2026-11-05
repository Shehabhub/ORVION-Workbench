# Read-only Markdown check. Working uses the Git index inventory with working bytes;
# Index or a tree-ish uses only selected Git blobs. No external reference is opened.
param([string]$Root=(Split-Path $PSScriptRoot -Parent),[string]$Tree='Working')
$ErrorActionPreference='Stop'
# The active documents of DEC-32. NOW.md, written only by Save-State (DEC-26): its sections in order and its pointer limit
# are WORKSPACE-LAYOUT.md section 14.2, its budget section 19; test-markdown-consistency compares all three with the text.
$MarkdownActive=@('README.md','WORKFLOW.md','HANDOFF.md','docs/RUNBOOK.md','docs/DECISIONS.md','docs/WORKSPACE-LAYOUT.md','lib/README.md')
$NowSections=@('Now','Done last','Next','Owner questions','Pending decisions','Running','Pointers');$NowPointers=8;$NowBudget=6144
# A frozen text (WORKSPACE-LAYOUT.md section 23) keeps its words: these exact bytes, after CRLF to LF, skip the watch patterns and no other check.
$FrozenOwnerTexts=[Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
$FrozenOwnerTexts['docs/owner/20261031-owner-directive-improvement-ws/DIRECTIVE.md']='E58EC467F29CDDA0F9C749A39807E760CDC1BCD9CD0607630036C2C925D29C4F'
function Get-MarkdownTextHash([string]$Text){[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($Text)))}
function Invoke-MarkdownGit([string]$Root,[string[]]$Arguments,[string]$Feed=''){
    $start=[Diagnostics.ProcessStartInfo]::new('git');$start.WorkingDirectory=$Root
    $start.UseShellExecute=$false;$start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true;$start.RedirectStandardInput=$true
    foreach($argument in $Arguments){$start.ArgumentList.Add($argument)}
    $process=[Diagnostics.Process]::Start($start);$buffer=[IO.MemoryStream]::new()
    try{
        $copy=$process.StandardOutput.BaseStream.CopyToAsync($buffer);$diagnostic=$process.StandardError.ReadToEndAsync()
        $process.StandardInput.Write($Feed);$process.StandardInput.Close();$null=$copy.GetAwaiter().GetResult();$process.WaitForExit()
        if($process.ExitCode-ne0){throw "MD_GIT_UNREADABLE $($diagnostic.GetAwaiter().GetResult().Trim())"}
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
        if($path-notmatch '(?i)\.(?:md|ps1)$'){continue}  # tools are read for their citations only
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
    if(!@($files.Keys-match '(?i)\.md$').Count){throw 'MD_INPUT_EMPTY'}
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
    # URI schemes, rooted paths and the pointers into the git-ignored data\ are opaque; never stat them.
    $Link=[Net.WebUtility]::HtmlDecode($Link)-replace '\\([() ])','$1'
    if($Link-match '^(?:[a-zA-Z][\w+.-]*:|[/\\]{1,2})'){return}
    $parts=$Link.Split('#',2);$target=[Uri]::UnescapeDataString($parts[0]).Replace('\','/')
    $stack=[Collections.Generic.List[string]]::new();$outside=0
    foreach($part in (($Source-replace '[^/]+$','')+$target).Split('/')){
        if($part-eq'..'){if(!$stack.Count){$outside++}else{$stack.RemoveAt($stack.Count-1)}}elseif($part-and$part-ne'.'){$stack.Add($part)}
    }
    if($outside){throw "MD_EXTERNAL_UNAPPROVED: $Source -> $Link"}
    if(($stack-join'/')-cmatch '^data/(?:work/NOW\.md$|records/)'){return}
    $resolved=if(!$target){$Source}else{$stack-join'/'}
    if($resolved.EndsWith('/')){$resolved=$resolved.TrimEnd('/')}
    if(!$resolved-or$Link.EndsWith('/')){
        if(!@($Files.Keys|Where-Object{$_.StartsWith("$resolved/",[StringComparison]::Ordinal)}).Count){throw "MD_LINK_MISSING: $Source -> $Link"};return
    }
    if(!$Files.ContainsKey($resolved)){throw "MD_LINK_MISSING: $Source -> $Link"}
    if($parts.Count-eq2-and$parts[1]-and$Anchors.ContainsKey($resolved)-and!$Anchors[$resolved].Contains([Uri]::UnescapeDataString($parts[1]))){throw "MD_ANCHOR_MISSING: $Source -> $Link"}
    return $resolved
}
function Get-MarkdownSections([string]$Path,[string]$Content){
    # DEC-32: every ## heading of an active document starts with its ID (DEC-NN in docs/DECISIONS.md, else "N."), every
    # ### with its parent's "N.M"; IDs are unique in the file; at most three lines stand between the title and the first ##.
    $ids=[Collections.Generic.List[string]]::new();$parent='';$preamble=0;$started=$false
    foreach($line in (Get-MarkdownPlain $Content).Split("`n")){
        if($line-match '^(#{2,3})\s+(.*)$'){
            $started=$true;$level=$Matches[1];$title=$Matches[2]
            $id=if($level-eq'###'){if($parent-and$title-match"^($([regex]::Escape($parent))\.\d+) "){$Matches[1]}}elseif($Path-ceq'docs/DECISIONS.md'){if($title-match '^(DEC-\d{2}) '){$Matches[1]}}elseif($title-match '^(\d+)\. '){$Matches[1]}
            if(!$id-or$ids.Contains($id)){throw "MD_SECTION_ID: $Path '$line' (IDs: $($ids-join', '))"}
            $ids.Add($id);if($level-eq'##'){$parent=$id}
        }elseif(!$started-and$line.Trim()-and$line-notmatch '^# '){$preamble++}
    }
    if($preamble-gt3){throw "MD_PREAMBLE: $Path has $preamble lines before its first section (IDs: $($ids-join', '))"}
    return ,$ids
}
function Get-MarkdownActiveSections($Files){
    $sections=@{};foreach($path in $MarkdownActive){$sections[$path]=Get-MarkdownSections $path $Files[$path]}
    return $sections
}
function Assert-MarkdownCitations([string]$path,[string]$text,$sections){
    # SP11: a citation names the section that holds the content: "FILE section N" or a bare DEC-NN, never the router.
    $cite='(?<![\w./\\-])([\w./\\-]+\.md)`? sections? (\d+(?:\.\d+)?(?:(?:,? and |, | or )\d+(?:\.\d+)?)*)'
    $cited=@(foreach($match in [regex]::Matches($text,$cite)){
        $name=$match.Groups[1].Value.Replace('\','/')
        $target=if($name-cin'AGENTS.md','README.md'-or$sections.ContainsKey($name)){$name}elseif($name-notmatch '/'){$found=@($sections.Keys-clike"*/$name");if($found.Count-eq1){$found[0]}}
        if($target){foreach($id in [regex]::Matches($match.Groups[2].Value,'\d+(?:\.\d+)?')){,@($target,$id.Value,$match.Value)}}
    })+@(foreach($match in [regex]::Matches($text,'(?<![\w-])DEC-\d{2}(?!\d)')){,@('docs/DECISIONS.md',$match.Value,$match.Value)})
    foreach($citation in $cited){
        if($citation[0]-cin'AGENTS.md','README.md'){throw "MD_ROUTER_HOP: $path cites $($citation[2])"}
        if(@($sections[$citation[0]]-ceq$citation[1]).Count-ne1){throw "MD_SECTION_MISSING: $path cites $($citation[2]); $($citation[0]) holds $($sections[$citation[0]]-join', ')"}
    }
}
function Test-NowMarkdown([string]$Root,[string]$Content){
    # NOW.md lives in git-ignored data/, so its writer runs this before every write: the budget, the sections in order,
    # a one-line Now, at most $NowPointers pointers that exist (relative ones from $Root), the line length and section IDs
    # of DEC-32, and its citations against the active documents of the checkout $Root.
    $text=$Content-replace"`r`n","`n";$bytes=[Text.Encoding]::UTF8.GetByteCount($text)
    if($bytes-gt$NowBudget){throw "MD_NOW_BUDGET: $bytes B"}
    $null=Get-MarkdownSections 'NOW.md' $text
    $lines=$text.Split("`n")
    for($i=0;$i-lt$lines.Count;$i++){if($lines[$i].Length-gt200-and!$lines[$i].StartsWith('|')){throw "MD_NOW_LINE_LENGTH: NOW.md:$($i+1)"}}
    $plain=Get-MarkdownPlain $text;$body=@{};$titles=[Collections.Generic.List[string]]::new()
    foreach($match in [regex]::Matches($plain,'(?ms)^## ([^\n]*)\n(.*?)(?=^## |\z)')){
        $titles.Add($match.Groups[1].Value);$body[$titles.Count]=@($match.Groups[2].Value.Split("`n")|Where-Object{$_.Trim()})
    }
    $expected=for($i=0;$i-lt$NowSections.Count;$i++){"$($i+1). $($NowSections[$i])"}
    if(($titles-join'|')-cne($expected-join'|')){throw "MD_NOW_SECTIONS: NOW.md holds $($titles-join', ')"}
    if($body[1].Count-ne1){throw "MD_NOW_LINE: Now has $($body[1].Count) lines"}
    $pointers=$body[$NowSections.Count]
    if(($pointers-join'')-cne'None.'){
        if($pointers.Count-gt$NowPointers-or@($pointers|Where-Object{$_-cnotmatch '^- \S'}).Count){throw "MD_NOW_POINTERS: $($pointers.Count) lines"}
        foreach($pointer in $pointers){
            $target=$pointer.Substring(2).Trim();if(![IO.Path]::IsPathFullyQualified($target)){$target=Join-Path $Root $target}
            if(!(Test-Path -LiteralPath $target)){throw "MD_NOW_POINTER_MISSING: $pointer"}
        }
    }
    Assert-MarkdownCitations 'NOW.md' $plain (Get-MarkdownActiveSections (Get-MarkdownInput $Root 'Working'))
    [pscustomobject]@{Result='NOW_MARKDOWN PASS';Bytes=$bytes}
}
function Test-MarkdownConsistency([string]$Root,[string]$Tree='Working'){
    $inputs=Get-MarkdownInput $Root $Tree;$anchors=@{};$edges=@{};$tools=@{}
    $files=[Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
    foreach($path in $inputs.Keys){if($path-match '(?i)\.md$'){$files.Add($path,$inputs[$path])}else{$tools[$path]=$inputs[$path]}}
    # Byte budgets after CRLF to LF: WORKSPACE-LAYOUT.md section 19.
    $budgets=@{'AGENTS.md'=1536;'README.md'=8192;'RESUME.md'=900;'HANDOFF.md'=4500;'WORKFLOW.md'=20300;'docs/DECISIONS.md'=40960}
    $active=$MarkdownActive
    $index='docs/history/README.md'
    foreach($path in @($budgets.Keys)+$active+$index){if(!$files.ContainsKey($path)){throw "MD_ROOT_MISSING: $path"}}
    foreach($path in $files.Keys){$anchors[$path]=Get-MarkdownAnchors $files[$path]}
    # Other tracked targets may be linked, but only Markdown files participate in reachability.
    $targets=[Collections.Generic.Dictionary[string,string]]::new($files,[StringComparer]::Ordinal)
    $arguments=if($Tree-in'Working','Index'){@('ls-files','-z')}else{@('ls-tree','-rz','--name-only',$Tree)}
    foreach($path in ([Text.Encoding]::UTF8.GetString((Invoke-MarkdownGit $Root $arguments))).Split([char]0,[StringSplitOptions]::RemoveEmptyEntries)){if(!$targets.ContainsKey($path)){$targets.Add($path,'')}}
    $byteCounts=[ordered]@{}
    foreach($path in $budgets.Keys){
        $byteCounts[$path]=[Text.Encoding]::UTF8.GetByteCount(($files[$path]-replace"`r`n","`n"))
        if($byteCounts[$path]-gt$budgets[$path]){throw "MD_BUDGET: $path"}
    }
    $workflow=$files['WORKFLOW.md'];$history=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $indexes=[regex]::Matches($files[$index],'(?ms)^## History index\r?\n(.*?)(?=^## |\z)')
    if($indexes.Count-ne1){throw 'MD_HISTORY_INDEX'}
    foreach($line in $indexes[0].Groups[1].Value.Split("`n")){if($line.Trim()-and$line-notmatch '^- \[[^\]]+\]\([^)]+\)\r?$'){throw 'MD_HISTORY_FORMAT'}}
    foreach($link in (Get-MarkdownLinks $indexes[0].Groups[1].Value)){
        $resolved=Resolve-MarkdownLink $index $link $files $anchors
        if($resolved-cnotmatch '^(?:changes/WS-[^/]+\.md|docs/history/(?!README\.md$).+\.md)$'-or!$history.Add($resolved)){throw "MD_HISTORY_ENTRY: $link"}
    }
    # Allocated contracts are judge-governed history by name (a contract's own file appears only at allocation, so an
    # explicit listing could never pass its own Finish); any other file under changes/ must still be reachable.
    foreach($path in $files.Keys){if($path-cmatch'^changes/WS-\d{3}-[A-Za-z0-9-]+\.md$'){[void]$history.Add($path)}}
    foreach($path in $files.Keys){
        $edges[$path]=if($history.Contains($path)){@()}else{@(foreach($link in (Get-MarkdownLinks $files[$path])){Resolve-MarkdownLink $path $link $targets $anchors})}
    }
    $expected=@('Arrival','Purpose','Active contract','Batch 6 closure','Decisions and rules','Procedures','Workspace layout','Recovery','Tool catalogue','Contract template')
    $owners=@{'Arrival'='AGENTS.md';'Purpose'='README.md';'Active contract'='RESUME.md';'Batch 6 closure'='HANDOFF.md';'Decisions and rules'='docs/DECISIONS.md';'Procedures'='docs/RUNBOOK.md';'Workspace layout'='docs/WORKSPACE-LAYOUT.md';'Recovery'='docs/RECOVERY.md';'Tool catalogue'='lib/README.md';'Contract template'='changes/TEMPLATE.md'}
    $homes=[regex]::Matches($workflow,'(?ms)^## (?:\d+\. )?One-home table\r?\n(.*?)(?=^## |\z)')
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
    $sections=Get-MarkdownActiveSections $files
    foreach($path in @($active)+'AGENTS.md'){
        $lines=($files[$path]-replace"`r`n","`n").Split("`n")
        for($i=0;$i-lt$lines.Count;$i++){if($lines[$i].Length-gt200-and!$lines[$i].StartsWith('|')){throw "MD_LINE_LENGTH: ${path}:$($i+1)"}}
    }
    # Entry format and limits: WORKSPACE-LAYOUT.md section 11; a Watch pattern flags a copied value (DEC-01).
    $watches=@{};$entries=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach($entry in [regex]::Matches(($files['docs/DECISIONS.md']-replace"`r`n","`n"),'(?ms)^## (DEC-\d{2}) [^\n]*\n(.*?)(?=^## |\z)')){
        $id=$entry.Groups[1].Value
        if($entry.Groups[2].Value-notmatch '^\n((?s:.+?))\n\nScope: [^\n]+\nWhy: [^\n]+\nChanged: \d{4}-\d{2}-\d{2}\nHistory: [^\n]+(?:\nWatch: `([^\n]+)`)?\n*$'){throw "MD_DECISION_ENTRY: $id"}
        $count=@($Matches[1].Split("`n")|Where-Object{$_.Trim()}).Count
        if($count-gt12){throw "MD_DECISION_LINES: $id has $count lines"}
        if($Matches[2]){$watches[$id]=[regex]::new($Matches[2])}
        [void]$entries.Add($id)
    }
    # The archive (WORKSPACE-LAYOUT.md section 19): each item names an entry that exists, and what the last commit held stays its first bytes.
    $archivePath='docs/history/DECISIONS-ARCHIVE.md'
    if($files.ContainsKey($archivePath)){
        $archive=$files[$archivePath]-replace"`r`n","`n"
        foreach($item in [regex]::Matches($archive,'(?ms)^## (\S+)[^\n]*\n(.*?)(?=^## |\z)')){
            $named=@([regex]::Matches([regex]::Match($item.Groups[2].Value,'(?m)^Now in: .*$').Value,'DEC-\d{2}(?!\d)')|ForEach-Object Value)
            if(!$named-or@($named|Where-Object{!$entries.Contains($_)})){throw "MD_ARCHIVE_ITEM: $($item.Groups[1].Value)"}
        }
        $base=if($Tree-in'Working','Index'){'HEAD'}else{"$Tree^"}
        # Absent there (a new archive, a tree with no parent) leaves nothing to compare.
        $prior=try{[Text.Encoding]::UTF8.GetString((Invoke-MarkdownGit $Root @('show',"${base}:$archivePath")))-replace"`r`n","`n"}catch{''}
        if(!$archive.StartsWith($prior,[StringComparison]::Ordinal)){throw 'MD_ARCHIVE_APPEND: an earlier item changed'}
    }
    foreach($path in @($files.Keys)+@($tools.Keys)){
        if($history.Contains($path)-or$path-clike'changes/WS-*.md'){continue}
        $text=if($tools.ContainsKey($path)){$tools[$path]}else{$files[$path]-replace"`r`n","`n"}
        if(!$tools.ContainsKey($path)-and$path-cne'docs/DECISIONS.md'){
            $lines=$text.Split("`n");$frozen=$FrozenOwnerTexts[$path]-ceq(Get-MarkdownTextHash $text)
            for($i=0;!$frozen-and$i-lt$lines.Count;$i++){foreach($id in $watches.Keys){if($watches[$id].IsMatch($lines[$i])-and!$lines[$i].Contains($id)){throw "MD_WATCH: ${path}:$($i+1) matches the Watch pattern of $id without citing it"}}}
            $text=Get-MarkdownPlain $text
        }
        Assert-MarkdownCitations $path $text $sections
    }
    [pscustomobject]@{Result='MARKDOWN_CONSISTENCY PASS';Files=$files.Count;Bytes=$byteCounts}
}
if($MyInvocation.InvocationName-ne'.'){
    try{$result=Test-MarkdownConsistency $Root $Tree;$result.Result}catch{Write-Output $_.Exception.Message;exit 1}
}
