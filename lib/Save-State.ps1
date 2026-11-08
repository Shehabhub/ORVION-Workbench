# The one save of every agent (DEC-26), procedure in docs/RUNBOOK.md section 11. Builds data/work/NOW.md from its
# template (WORKSPACE-LAYOUT.md section 14.2), has the Markdown guard's Test-NowMarkdown check it and renders the status
# page from the workstream's plan file (DEC-29), so a refused save writes nothing; then overwrites NOW.md, appends one
# line to the workstream's LOG.md, writes the page beside it, replaces the vault's continuity copy (WORKSPACE-LAYOUT.md
# section 3.3) once every copied file's SHA256 matches its source, and prints the page line, the SAVED line, the
# /compact line and the resume message. Owner questions, pointers and the workstream carry over from the previous
# NOW.md unless given; pending decisions are the ## headings of decisions-inbox.md in the data root; Running is stated at every
# save. It reads none of the legacy folders (MIGRATION-MAP.tsv L05, X01). -Check compares each sb\W*\status.html with a
# fresh page from the PLAN.md beside it, skipping the one stamped line, and writes nothing (GENERATED STALE: <path>, exit 1).
[CmdletBinding(DefaultParameterSetName='Save')]
param(
    [Parameter(Mandatory,ParameterSetName='Save')][string]$Operation,[Parameter(Mandatory,ParameterSetName='Save')][string]$Done,[Parameter(Mandatory,ParameterSetName='Save')][string[]]$Evidence,
    [Parameter(Mandatory,ParameterSetName='Save')][string]$Next,[Parameter(Mandatory,ParameterSetName='Save')][string]$RunBy,
    [Parameter(Mandatory,ParameterSetName='Check')][switch]$Check,
    [string]$Now,[string]$Blocker,[string]$Workstream,[string[]]$Question,[string[]]$Running,[string[]]$Pointer,
    [string]$Checkout=(Split-Path $PSScriptRoot -Parent),[string]$DataRoot,[string]$Temporary,[string]$Plan,[string]$Vault)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'Test-MarkdownConsistency.ps1')  # functions only (it sets $Root and $Tree, unused here)
if(!$DataRoot){$DataRoot=if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{Join-Path $Checkout 'data'}}
if(!$Temporary){$Temporary=Join-Path (Split-Path $Checkout -Parent) 'ORVION-Workbench-temporary'}
if(!$Vault){$cloud=if($env:OneDrive){$env:OneDrive}else{Join-Path $HOME 'OneDrive'};$Vault=Join-Path $cloud 'ORVION-Recovery'}
$nowPath=[IO.Path]::Combine($DataRoot,'work','NOW.md');$utf8=[Text.UTF8Encoding]::new($false)
function Get-NowItems([string]$Text,[int]$Id){
    # The "- " items of one section of a NOW.md this tool wrote; a wrapped item continues on lines indented by two.
    $items=[Collections.Generic.List[string]]::new()
    foreach($line in [regex]::Match($Text,"(?ms)^## $Id\. [^\n]*\n(.*?)(?=^## |\z)").Groups[1].Value.Split("`n")){
        if($line.StartsWith('- ')){$items.Add($line.Substring(2))}elseif($line.StartsWith('  ')-and$items.Count){$items[$items.Count-1]+=' '+$line.Trim()}
    }
    return ,$items.ToArray()
}
function Format-NowText([string]$Text,[string]$Lead=''){
    # Wraps at 118 characters, inside the guard's 200; one longer word stays whole and the guard refuses it.
    $lines=[Collections.Generic.List[string]]::new();$line=''
    foreach($word in @($Text-split '\s+'|Where-Object{$_})){
        if($line-and$line.Length+1+$word.Length-gt118){$lines.Add($line);$line=$word}elseif($line){$line+=' '+$word}else{$line=$word}
    }
    $lines.Add($line);$pad=' '*$Lead.Length
    return (@(for($i=0;$i-lt$lines.Count;$i++){if($i){$pad+$lines[$i]}else{$Lead+$lines[$i]}})-join"`n")
}
function Format-NowList([string[]]$Items,[switch]$Whole){
    if(!$Items.Count){return 'None.'}
    return (@($Items|ForEach-Object{if($Whole){"- $_"}else{Format-NowText $_ '- '}})-join"`n")
}
function Format-Clause([string]$Text){$clause=($Text-replace '\s+',' ').Trim();if($clause-match '[.?!]$'){$clause}else{$clause+'.'}}
function ConvertTo-PageHtml([string]$s){$p=$s.Split([char]96);if($p.Count%2-eq0){throw "SAVE_PLAN_CODE_SPAN: $s"}
    (0..($p.Count-1)|ForEach-Object{$e=[Net.WebUtility]::HtmlEncode($p[$_]);if($_%2){"<code>$e</code>"}else{$e}})-join''}
function ConvertTo-PageAttribute([string]$s){[Net.WebUtility]::HtmlEncode($s)}
function Format-PageCells($row,$head,[int]$from){($from..($row.Count-1)|ForEach-Object{"<td data-label=""$(ConvertTo-PageAttribute $head[$_])"">$(ConvertTo-PageHtml $row[$_])</td>"})-join''}
function Format-PageHeads($head){($head|ForEach-Object{"<th>$(ConvertTo-PageHtml $_)</th>"})-join''}
function Assert-PageTable($b,$where){
    if($b.Rows.Count-lt3-or$b.Rows[0].Count-lt2-or@($b.Rows[1]|Where-Object{$_-notmatch'^:?-{3,}:?$'}).Count){throw "SAVE_PLAN_TABLE_UNREADABLE: $where"}
    for($r=2;$r-lt$b.Rows.Count;$r++){if($b.Rows[$r].Count-ne$b.Rows[0].Count){throw "SAVE_PLAN_TABLE_SHAPE: $where row $($b.Rows[$r][0])"}}}
function Get-PageStepCell($Entry,[string]$Like){for($i=0;$i-lt$Entry.Head.Count;$i++){if($Entry.Head[$i]-like$Like){return $Entry.Row[$i]}};throw "SAVE_PLAN_STEP_COLUMN: $($Entry.Row[0]) has no $Like column"}
function ConvertTo-StatusPage([string]$PlanPath){
    # The P1.1f generator: section 6, the batches of section 7 and the step tables of section 3 of the plan file as one HTML page. Every word comes
    # from the plan except each step's state, which follows from where the step stands: in the Done table Done, first in
    # section 6 Now, elsewhere in section 6 Next, otherwise Pending. A table it cannot read, a step ID used twice or a
    # section 6 row that names no open step, a batch naming no open step or an open step in no batch is refused (DEC-29).
    # Ceiling: reads only the Markdown the plan uses (headings,
    # paragraphs, tables, code spans); a pipe inside a cell fails.
    $parts=[Collections.Generic.List[object]]::new();$cur=$null;$last=$null;$h1=$null;$status=$null
    foreach($l in [IO.File]::ReadAllLines($PlanPath)){
        $t=$l.Trim()
        if(!$h1-and$l.StartsWith('# ')){$h1=$l.Substring(2).Trim();continue}
        if(!$status-and$l.StartsWith('Status: ')){$status=$t}
        if($l-match'^(#{2,3}) (.+)$'){$cur=[pscustomobject]@{Level=$Matches[1].Length;Title=$Matches[2].Trim();Blocks=[Collections.Generic.List[object]]::new()};$parts.Add($cur);$last=$null;continue}
        if(!$cur){continue}
        if(!$t){$last=$null;continue}
        if($t.StartsWith('|')){
            if(!$last-or$last.Kind-ne'table'){$last=[pscustomobject]@{Kind='table';Rows=[Collections.Generic.List[object]]::new()};$cur.Blocks.Add($last)}
            $last.Rows.Add([string[]]@($t.Trim('|').Split('|')|ForEach-Object{$_.Trim()}));continue}
        if(!$last-or$last.Kind-ne'para'){$last=[pscustomobject]@{Kind='para';Text=$t};$cur.Blocks.Add($last)}else{$last.Text+=' '+$t}
    }
    $s6=@($parts|Where-Object{$_.Level-eq2-and$_.Title-match'^6\.\s'})
    $k3=-1;for($k=0;$k-lt$parts.Count;$k++){if($parts[$k].Level-eq2-and$parts[$k].Title-match'^3\.\s'){$k3=$k}}
    if(!$h1-or!$status-or$s6.Count-ne1-or$k3-lt0){throw "SAVE_PLAN_SECTIONS: $PlanPath needs a title, a Status line and sections 3 and 6"}
    $subs=@(for($k=$k3+1;$k-lt$parts.Count-and$parts[$k].Level-eq3;$k++){$parts[$k]})
    $state=[ordered]@{};$stepRow=@{}
    foreach($p in $subs){foreach($b in @($p.Blocks|Where-Object Kind -eq 'table')){
        Assert-PageTable $b $p.Title;if($b.Rows[0][0]-ne'Step'){throw "SAVE_PLAN_STEP_HEADER: $($p.Title)"}
        for($r=2;$r-lt$b.Rows.Count;$r++){$id=$b.Rows[$r][0];if($state.Contains($id)){throw "SAVE_PLAN_STEP_TWICE: $id"}
            $state[$id]=if($p.Title-match'^Done\b'){'Done'}else{'Pending'};$stepRow[$id]=[pscustomobject]@{Head=$b.Rows[0];Row=$b.Rows[$r]}}}}
    $t6=@($s6[0].Blocks|Where-Object Kind -eq 'table');if($t6.Count-ne1){throw 'SAVE_PLAN_SECTION_6_TABLE'};$t6=$t6[0];Assert-PageTable $t6 'section 6'
    if($t6.Rows[0][0]-ne'Rank'-or$t6.Rows[0][1]-ne'Step'){throw 'SAVE_PLAN_SECTION_6_HEADER'}
    for($r=2;$r-lt$t6.Rows.Count;$r++){$id=($t6.Rows[$r][1]-split'\s')[0]
        if($state[$id]-ne'Pending'){throw "SAVE_PLAN_SECTION_6_STEP: $($t6.Rows[$r][1])"}
        $state[$id]=if($r-eq2){'Now'}else{'Next'}}
    $s7=@($parts|Where-Object{$_.Level-eq2-and$_.Title-match'^7\.\s'})
    $t7=@($s7.Blocks|Where-Object Kind -eq 'table');if($t7.Count-ne1){throw 'SAVE_PLAN_SECTION_7_TABLE'};$t7=$t7[0];Assert-PageTable $t7 'section 7'
    if(($t7.Rows[0]-join'|')-cne'Batch|Steps|Same files|Run by|Ends with|Why here'){throw 'SAVE_PLAN_SECTION_7_HEADER'}
    $named=@{};$batchSteps=@{}
    for($r=2;$r-lt$t7.Rows.Count;$r++){
        $ids=@([regex]::Matches($t7.Rows[$r][1],'\bP\d+(?:\.\d+)?[a-z]?\b')|ForEach-Object{$_.Value});if(!$ids.Count){throw "SAVE_PLAN_BATCH_NO_STEPS: $($t7.Rows[$r][0])"}
        foreach($id in $ids){if(!$state.Contains($id)-or$state[$id]-eq'Done'){throw "SAVE_PLAN_BATCH_STEP: $id"};$named[$id]=1}
        $batchSteps[$r]=$ids}
    foreach($id in @($state.Keys|Where-Object{$state[$_]-ne'Done'})){if(!$named[$id]){throw "SAVE_PLAN_STEP_NO_BATCH: $id"}}

    $css=@'
<style>
/* Layout: one reading column; the header with the progress meter, then the ranked queue, the batches, then every step table. */
:root{
  --bg:#f3f5f9;--surface:#ffffff;--fg:#17202d;--muted:#566275;--line:#d8dee8;
  --accent:#2d4cc8;--next-bg:#e7ecfb;--done:#1c7046;--done-bg:#e2f2e8;--now:#934600;--now-bg:#fcecda;
  --display:"IBM Plex Sans Condensed","Arial Narrow",system-ui,sans-serif;
  --body:"IBM Plex Sans",system-ui,-apple-system,"Segoe UI",sans-serif;
  --mono:"IBM Plex Mono",ui-monospace,Consolas,monospace;
}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){
  --bg:#0e1219;--surface:#151a23;--fg:#e1e6ee;--muted:#95a0b2;--line:#273040;
  --accent:#8fa6ff;--next-bg:#1a2340;--done:#5ac78c;--done-bg:#13271c;--now:#f1a65c;--now-bg:#2d1f0f;color-scheme:dark}}
:root[data-theme="dark"]{
  --bg:#0e1219;--surface:#151a23;--fg:#e1e6ee;--muted:#95a0b2;--line:#273040;
  --accent:#8fa6ff;--next-bg:#1a2340;--done:#5ac78c;--done-bg:#13271c;--now:#f1a65c;--now-bg:#2d1f0f;color-scheme:dark}
body{background:var(--bg);color:var(--fg);font:15px/1.55 var(--body)}
main{max-width:78rem;margin:0 auto;padding-block:28px 56px;padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px));display:grid;gap:36px}
header,section{display:grid;gap:12px;min-width:0}
h1,h2,h3{font-family:var(--display);font-weight:600;line-height:1.2;text-wrap:balance;margin:0}
h1{font-size:1.85rem;max-width:40ch}
h2{font-size:1.3rem;padding-bottom:6px;border-bottom:1px solid var(--line)}
h3{font-size:1.05rem;margin-top:18px}
p{margin:0;max-width:75ch}
.status,.note{color:var(--muted)}
.meta{font:12px/1.4 var(--mono);color:var(--muted);overflow-wrap:anywhere}
.progress{display:flex;align-items:center;gap:12px;flex-wrap:wrap}
.bar{flex:1 1 200px;max-width:420px;height:8px;border-radius:4px;background:var(--line);overflow:hidden}
.bar span{display:block;height:100%;background:var(--done)}
.progress p{font-weight:600;font-variant-numeric:tabular-nums}
.tbl{overflow-x:auto;border:1px solid var(--line);border-radius:6px;background:var(--surface)}
table{border-collapse:collapse;width:100%;font-size:14px}
th{font:600 11px/1.3 var(--body);letter-spacing:.06em;text-transform:uppercase;color:var(--muted);text-align:left;padding:10px 12px;border-bottom:1px solid var(--line);white-space:nowrap}
td{padding:10px 12px;border-top:1px solid var(--line);vertical-align:top;overflow-wrap:break-word}
tbody tr:first-child td{border-top:0}
code{font:13px var(--mono);background:var(--bg);padding:1px 4px;border-radius:3px;overflow-wrap:anywhere}
td.id,.rank td:first-child{font-family:var(--mono);font-weight:500;white-space:nowrap;font-variant-numeric:tabular-nums}
.chip{display:inline-block;font:600 11px/1 var(--body);letter-spacing:.05em;text-transform:uppercase;padding:4px 8px;border-radius:999px;border:1px solid var(--line);color:var(--muted);white-space:nowrap}
.filters{display:flex;flex-wrap:wrap;gap:8px}
.filters button{font:600 12px/1 var(--body);padding:8px 12px;border-radius:999px;border:1px solid var(--line);background:var(--surface);color:var(--fg);cursor:pointer}
.filters button[aria-pressed="true"]{background:var(--accent);border-color:var(--accent);color:var(--bg)}
.filters button:focus-visible,summary:focus-visible{outline:2px solid var(--accent);outline-offset:2px}
.batches{display:grid;gap:10px}
.batch{border:1px solid var(--line);border-radius:6px;background:var(--surface);min-width:0}
.batch.is-now{border-color:var(--now)}
.batch summary{cursor:pointer;padding:12px 14px;display:grid;gap:6px}
.batch summary b{font:600 1.02rem/1.25 var(--display)}
.facts{display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,15rem),1fr));gap:4px 16px;font-size:13.5px;color:var(--muted)}
.facts span b{font:600 10.5px/1.5 var(--body);letter-spacing:.06em;text-transform:uppercase;display:block}
.batch .tbl{border:0;border-top:1px solid var(--line);border-radius:0}
tr.now{background:var(--now-bg)}
tr.now .chip{color:var(--now);border-color:var(--now)}
tr.next .chip{color:var(--accent);background:var(--next-bg);border-color:transparent}
tr.done .chip{color:var(--done);background:var(--done-bg);border-color:transparent}
tr.done td:not(.st){color:var(--muted)}
@media (max-width:640px){
  .tbl table,.tbl tbody,.tbl tr,.tbl td{display:block}
  .tbl thead{display:none}
  .tbl tr{padding:10px 12px;border-top:1px solid var(--line)}
  .tbl tbody tr:first-child{border-top:0}
  .tbl td{border:0;padding:3px 0}
  .tbl td.id,.tbl td.st{display:inline-block;margin-right:10px}
  .tbl td[data-label]::before{content:attr(data-label);display:block;font:600 10px/1.5 var(--body);letter-spacing:.06em;text-transform:uppercase;color:var(--muted)}
}
</style>
'@
    $total=$state.Count;$nDone=@($state.Values|Where-Object{$_-eq'Done'}).Count;$pct=[math]::Round(100*$nDone/$total)
    $sha=(Get-FileHash -LiteralPath $PlanPath).Hash.Substring(0,8)
    $at=[TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([datetime]::UtcNow,'Egypt Standard Time').ToString('yyyy-MM-dd HH:mm')
    $cls=@{Done='done';Now='now';Next='next';Pending='pending'}
    $o=[Collections.Generic.List[string]]::new()
    $o.Add("<!-- generated by lib/Save-State.ps1 from $(Split-Path $PlanPath -Leaf); do not edit -->")
    $o.Add("<title>$(ConvertTo-PageHtml (($h1-split':')[0].Trim()))</title>")
    $o.Add('<meta name="claude:viewport-fit-sides" content="cover">')
    $o.Add('<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500&family=IBM+Plex+Sans+Condensed:wght@600&family=IBM+Plex+Sans:wght@400;600&display=swap">')
    $o.Add($css)
    $o.Add("<main><header><h1>$(ConvertTo-PageHtml $h1)</h1><p class=""status"">$(ConvertTo-PageHtml $status)</p>")
    $o.Add("<div class=""progress""><div class=""bar"" role=""progressbar"" aria-label=""Steps done"" aria-valuemin=""0"" aria-valuemax=""$total"" aria-valuenow=""$nDone""><span style=""width:$pct%""></span></div><p>$nDone of $total steps done</p></div>")
    $o.Add("<p class=""meta"">Generated $at Cairo from $(Split-Path $PlanPath -Leaf), SHA256 $sha</p></header>")
    $h=$t6.Rows[0]
    $o.Add("<section><h2>$(ConvertTo-PageHtml ($s6[0].Title-replace'^\d+\.\s+',''))</h2><div class=""tbl""><table class=""rank""><thead><tr>$(Format-PageHeads $h)</tr></thead><tbody>")
    for($r=2;$r-lt$t6.Rows.Count;$r++){$row=$t6.Rows[$r];$o.Add("<tr class=""$($cls[$state[($row[1]-split'\s')[0]]])"">$(Format-PageCells $row $h 0)</tr>")}
    $o.Add('</tbody></table></div></section>')
    $o.Add("<section><h2>$(ConvertTo-PageHtml ($s7[0].Title-replace'^\d+\.\s+',''))</h2>")
    foreach($b in @($s7[0].Blocks|Where-Object Kind -eq 'para')){$o.Add("<p class=""note"">$(ConvertTo-PageHtml $b.Text)</p>")}
    $o.Add('<div class="filters" role="group" aria-label="Show batches by model"><button type="button" data-family="" aria-pressed="true">All</button><button type="button" data-family="opus" aria-pressed="false">Opus</button><button type="button" data-family="sonnet" aria-pressed="false">Sonnet</button><button type="button" data-family="haiku" aria-pressed="false">Haiku</button><button type="button" data-family="codex" aria-pressed="false">Codex</button></div><div class="batches">')
    for($r=2;$r-lt$t7.Rows.Count;$r++){$row=$t7.Rows[$r];$ids=$batchSteps[$r];$isNow=$r-eq2
        $runBy=(@($row[3])+@($ids|ForEach-Object{Get-PageStepCell $stepRow[$_] 'Run by*'}))-join' '
        $families=(@('opus','sonnet','haiku','codex')|Where-Object{$runBy-imatch$_})-join' '
        $o.Add("<details class=""batch$(if($isNow){' is-now'})"" data-families=""$families""$(if($isNow){' open'})><summary><b>$(ConvertTo-PageHtml $row[0])</b><span class=""facts""><span><b>Steps</b>$(ConvertTo-PageHtml $row[1])</span><span><b>Same files</b>$(ConvertTo-PageHtml $row[2])</span><span><b>Run by</b>$(ConvertTo-PageHtml $row[3])</span><span><b>Ends with</b>$(ConvertTo-PageHtml $row[4])</span><span><b>Why here</b>$(ConvertTo-PageHtml $row[5])</span></span></summary>")
        $o.Add('<div class="tbl"><table class="steps"><thead><tr><th>Step</th><th>State</th><th>Do</th><th>Run by</th><th>Time</th></tr></thead><tbody>')
        foreach($id in @($ids|Select-Object -Unique)){$s=$state[$id];$e=$stepRow[$id]
            $o.Add("<tr class=""$($cls[$s])""><td class=""id"">$(ConvertTo-PageHtml $id)</td><td class=""st""><span class=""chip"">$s</span></td><td data-label=""Do"">$(ConvertTo-PageHtml (Get-PageStepCell $e 'Do'))</td><td data-label=""Run by"">$(ConvertTo-PageHtml (Get-PageStepCell $e 'Run by*'))</td><td data-label=""Time"">$(ConvertTo-PageHtml (Get-PageStepCell $e 'Time*'))</td></tr>")}
        $o.Add('</tbody></table></div></details>')}
    $o.Add('</div></section>')
    $o.Add('<script>document.querySelectorAll(".filters button").forEach(function(button){button.addEventListener("click",function(){document.querySelectorAll(".filters button").forEach(function(other){other.setAttribute("aria-pressed",String(other===button))});document.querySelectorAll(".batch").forEach(function(batch){batch.hidden=!!button.dataset.family&&batch.dataset.families.split(" ").indexOf(button.dataset.family)<0})})});</script>')
    $o.Add("<section><h2>$(ConvertTo-PageHtml ($parts[$k3].Title-replace'^\d+\.\s+',''))</h2>")
    foreach($p in $subs){$o.Add("<h3>$(ConvertTo-PageHtml $p.Title)</h3>")
        foreach($b in $p.Blocks){
            if($b.Kind-eq'para'){$o.Add("<p class=""note"">$(ConvertTo-PageHtml $b.Text)</p>");continue}
            $h=$b.Rows[0]
            $o.Add("<div class=""tbl""><table class=""steps""><thead><tr><th>$(ConvertTo-PageHtml $h[0])</th><th>State</th>$(Format-PageHeads @($h|Select-Object -Skip 1))</tr></thead><tbody>")
            for($r=2;$r-lt$b.Rows.Count;$r++){$row=$b.Rows[$r];$s=$state[$row[0]]
                $o.Add("<tr class=""$($cls[$s])"" data-step=""$(ConvertTo-PageAttribute $row[0])""><td class=""id"">$(ConvertTo-PageHtml $row[0])</td><td class=""st""><span class=""chip"">$s</span></td>$(Format-PageCells $row $h 1)</tr>")}
            $o.Add('</tbody></table></div>')}}
    $o.Add('</section></main>')
    $html=$o-join"`n"
    if($html-match'[\x00-\x08\x0B\x0C\x0E-\x1F]'){throw 'SAVE_PLAN_CONTROL_CHARACTER'}
    [pscustomobject]@{Html=$html;Total=$total;Done=$nDone;Now=(@($state.Keys|Where-Object{$state[$_]-eq'Now'})-join',');Sha=$sha}
}
function Get-ContinuityFile([string]$Directory,[string]$Prefix,[string[]]$Skip=@()){
    # One [path in continuity/, source] pair per file below $Directory, without the top-level folders named in $Skip.
    foreach($item in @(Get-ChildItem -LiteralPath $Directory -Force)){
        if(!$item.PSIsContainer){,@("$Prefix/$($item.Name)",$item.FullName)}
        elseif($item.Name-notin$Skip){foreach($file in @(Get-ChildItem -LiteralPath $item.FullName -Recurse -File -Force)){
            ,@(("$Prefix/"+[IO.Path]::GetRelativePath($Directory,$file.FullName).Replace('\','/')),$file.FullName)}}
    }
}

if($Check){
    $staleCount=0;$stampLine='^<p class="meta">Generated '
    foreach($item in @(Get-ChildItem -Path ([IO.Path]::Combine($Temporary,'sb','W*','status.html')) -File -ErrorAction Ignore)){
        $source=Join-Path $item.DirectoryName 'PLAN.md'
        $fresh=if(Test-Path -LiteralPath $source -PathType Leaf){((ConvertTo-StatusPage $source).Html-split"`n"|Where-Object{$_-cnotmatch$stampLine})-join"`n"}
        $stored=(([IO.File]::ReadAllText($item.FullName)-replace"`r`n","`n")-split"`n"|Where-Object{$_-cnotmatch$stampLine})-join"`n"
        if($fresh-cne$stored){"GENERATED STALE: $($item.FullName)";$staleCount++}
    }
    exit $(if($staleCount){1}else{0})
}
$old=if(Test-Path -LiteralPath $nowPath){[IO.File]::ReadAllText($nowPath)-replace"`r`n","`n"}else{''}
if(!$Workstream){if($old-cmatch '^# NOW (WS-\d{3})\n'){$Workstream=$Matches[1]}else{throw 'SAVE_WORKSTREAM_REQUIRED'}}
if($Workstream-cnotmatch '^WS-\d{3}$'){throw "SAVE_WORKSTREAM_FORMAT: $Workstream"}
$folder=[IO.Path]::Combine($Temporary,'sb','W'+[int]$Workstream.Substring(3))
if(!(Test-Path -LiteralPath $folder -PathType Container)){throw "SAVE_WORKSTREAM_FOLDER_MISSING: $folder"}
foreach($path in $Evidence){
    $full=if([IO.Path]::IsPathFullyQualified($path)){$path}else{Join-Path $Checkout $path}
    if(!(Test-Path -LiteralPath $full)){throw "SAVE_EVIDENCE_MISSING: $path"}
}
if(!(Test-Path -LiteralPath $Vault -PathType Container)){throw "SAVE_VAULT_MISSING: $Vault"}
if(!$Plan){$Plan=Join-Path $folder 'PLAN.md'}
if(!(Test-Path -LiteralPath $Plan -PathType Leaf)){throw "SAVE_PLAN_MISSING: $Plan"}
if(!$PSBoundParameters.ContainsKey('Question')){$Question=Get-NowItems $old 4}
if(!$PSBoundParameters.ContainsKey('Pointer')){$Pointer=Get-NowItems $old 7}
$Question=@($Question|Where-Object{$_-and$_.Trim()});$Pointer=@($Pointer|Where-Object{$_-and$_.Trim()})
$Running=@($Running|Where-Object{$_-and$_.Trim()})
$inbox=[IO.Path]::Combine($DataRoot,'decisions-inbox.md')
$pending=if(Test-Path -LiteralPath $inbox){@([regex]::Matches(([IO.File]::ReadAllText($inbox)-replace"`r`n","`n"),'(?m)^## (.+)$')|ForEach-Object{$_.Groups[1].Value.Trim()})}else{@()}
if(!$Now){$Now=if($Blocker){"$Workstream $Operation"}else{"$Workstream $Operation done"}}
if($Blocker){$Now+=" BLOCKED: $Blocker"}
$Now=Format-Clause $Now

$utc=[datetime]::UtcNow;$cairo=[TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($utc,'Egypt Standard Time')
$text=(@(
    "# NOW $Workstream"
    Format-NowText "Live state, overwritten by lib/Save-State.ps1 only (DEC-26): saved $($cairo.ToString('yyyy-MM-dd HH:mm')) Cairo after $Operation."
    '','## 1. Now','',$Now
    '','## 2. Done last','',(Format-NowText $Done),'','Evidence:',(Format-NowList $Evidence -Whole)
    '','## 3. Next','',(Format-NowText $Next),'',(Format-NowText "Run by (DEC-18): $RunBy")
    '','## 4. Owner questions','',(Format-NowList $Question)
    '','## 5. Pending decisions','',(Format-NowList $pending)
    '','## 6. Running','',(Format-NowList $Running)
    '','## 7. Pointers','',(Format-NowList $Pointer -Whole)
)-join"`n")+"`n"
$guarded=Test-NowMarkdown $Checkout $text
$page=ConvertTo-StatusPage $Plan

[void][IO.Directory]::CreateDirectory((Split-Path $nowPath -Parent))
[IO.File]::WriteAllText("$nowPath.tmp",$text,$utf8);[IO.File]::Move("$nowPath.tmp",$nowPath,$true)
$log=Join-Path $folder 'LOG.md';$stamp=$utc.ToString('yyyy-MM-ddTHH:mm:ssZ')
if(!(Test-Path -LiteralPath $log)){[IO.File]::WriteAllText($log,"# LOG $Workstream`n`nOne line per save, appended by lib/Save-State.ps1 only.`n`n",$utf8)}
$entry="- $stamp $(($Operation-replace '\s+',' ').Trim()): $(Format-Clause $Done) Evidence: $($Evidence-join'; '). Next: $(Format-Clause $Next)"
if($Blocker){$entry+=" BLOCKED: $(Format-Clause $Blocker)"}
[IO.File]::AppendAllText($log,$entry+"`n",$utf8)
$pagePath=Join-Path $folder 'status.html'
[IO.File]::WriteAllText("$pagePath.tmp",$page.Html,$utf8);[IO.File]::Move("$pagePath.tmp",$pagePath,$true)

# The continuity copy is built beside the old one and swapped in only after every file matches its source, so a failed
# copy leaves the previous one whole; a mismatch (a file written to during the copy) refuses, and the save is run again.
$copies=@(,@('data/work/NOW.md',$nowPath))
if(Test-Path -LiteralPath $inbox){$copies+=,@("data/$(Split-Path $inbox -Leaf)",$inbox)}
$events=Join-Path $DataRoot 'events';if(Test-Path -LiteralPath $events -PathType Container){$copies+=@(Get-ContinuityFile $events 'data/events')}
$copies+=@(Get-ContinuityFile $folder "sb/$(Split-Path $folder -Leaf)" 's','t','tmp')
$continuity=Join-Path $Vault 'continuity';$stage="$continuity.new";$previous="$continuity.old"
# A stop between the two moves below leaves continuity.old as the only whole copy: it is restored, never deleted (F1).
if(!(Test-Path -LiteralPath $continuity)-and(Test-Path -LiteralPath $previous)){[IO.Directory]::Move($previous,$continuity)}
# Git object files copied from nested clones are read-only, and Directory.Delete refuses them (2026-11-07).
function Remove-Copy([string]$Path){Get-ChildItem -LiteralPath $Path -Recurse -Force -File|Where-Object IsReadOnly|ForEach-Object{$_.IsReadOnly=$false};[IO.Directory]::Delete($Path,$true)}
foreach($path in $stage,$previous){if(Test-Path -LiteralPath $path){Remove-Copy $path}}
foreach($copy in $copies){$target=Join-Path $stage $copy[0];[void][IO.Directory]::CreateDirectory((Split-Path $target -Parent));[IO.File]::Copy($copy[1],$target)}
$differ=@(foreach($copy in $copies){if((Get-FileHash -LiteralPath $copy[1]).Hash-cne(Get-FileHash -LiteralPath (Join-Path $stage $copy[0])).Hash){$copy[0]}})
if($differ.Count){Remove-Copy $stage;throw "SAVE_CONTINUITY_MISMATCH: $($differ-join', ')"}
if(Test-Path -LiteralPath $continuity){[IO.Directory]::Move($continuity,$previous)}
[IO.Directory]::Move($stage,$continuity)
if(Test-Path -LiteralPath $previous){Remove-Copy $previous}

$ask=if($Question.Count){' Open owner questions: '+(@($Question|ForEach-Object{Format-Clause $_})-join' ')}else{''}
# The two pasted lines carry only the first sentence of Next; NOW.md holds the whole step. Ceiling: an abbreviation such
# as "e.g. " ends that sentence early.
$step=[regex]::Match((Format-Clause $Next),'^.*?[.?!](?=\s|$)').Value
"STATUS_PAGE $pagePath steps=$($page.Total) done=$($page.Done) now=$($page.Now) plan=$($page.Sha)"
"SAVED $stamp ($($cairo.ToString('HH:mm')) Cairo) $Workstream $(($Operation-replace '\s+',' ').Trim())  NOW.md $($guarded.Bytes) B  continuity copy verified"
"/compact Keep: $Now Next = $step$ask Times in Cairo. English only."
"Resume. NOW.md is already loaded; do not re-read it. Next: $step Run by: $(Format-Clause $RunBy) Save after the step and give the compact line and resume message. Times in Cairo. English only."
