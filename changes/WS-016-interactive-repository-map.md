# Workbench Change Request - WS-016

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Give agents and tools one current picture of the whole estate: lib/Map-Repos.ps1 discovers every Git repository under the GitHub folder on each run and writes a git-ignored ai-map.json and interactive ai-map.html in this root with Obsidian-style links, backlinks and orphans across the tracked files of all repositories, refreshable hourly by a per-user scheduled task.

## Baseline

a8bf1fdc460cbf31ef82c56f46d43a996164e1b7

## Write Scope

- RESUME.md
- lib/Map-Repos.ps1
- lib/ai-map.template.html
- lib/test-map-repos.ps1
- .gitignore
- README.md
- lib/README.md

## Out of Scope

All other engineering paths except native allocation/status/pointer bookkeeping. No product repository, checker, recipe driver, workflow, hook or GitHub setting change; the map never reads untracked or ignored files, sessions, the journal, receipts or evidence, and is never authority. Registering the scheduled task is a post-Complete operational step, not a contract step. CTRL-19 stays OPEN; Batch 6/Phase 8 stay ON HOLD.

## Draft Assurance

V1: WS016-MAP-DESIGN | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws016-package\assurance\V1\DRAFT.md | CC7F667B74F026344ABEC31D9D6FEDD0FBE437CB1C8526CDF38E9004EE98104D
V2: WS016-MAP-ADVERSARIAL | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws016-package\assurance\V2\DRAFT.md | 4A07F331503EFEEA9180B8FF4FF34F0D1A83018166390B74BA33B62C7F2B8FF9
V3: WS016-MAP-REFRESH | 2026-10-26 | C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws016-package\assurance\V3\DRAFT.md | SELECTED
Selected Version: V3

## Execution Context

Original Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Parent: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSmap16
Tests Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSmap16\t
Temp Root: C:\Users\My Lab\Documents\ORVION-Sandbox\evidence\WSmap16\tmp
Runtime Root: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws016-package\runtime
PowerShell Version: 7.6.8
Git Version: git version 2.54.0.windows.1
Minimum Physical GB: 1.5
Minimum Commit GB: 3

## Implementation Steps

1. Check whether `lib/Map-Repos.ps1` contains `Interactive repository map v1:`; if so record Already Applied when its Git blob is a0d77573b8aaaab77b2eea1b86a87a0dc0d49ddc, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (interactive repository map only), and change nothing else:

   ```text
   # Interactive repository map v1: every Git repository under the GitHub folder, its committed files and the links between them.
   #   pwsh -NoProfile -File Map-Repos.ps1                 rebuild <Workbench root>\ai-map.json and ai-map.html (~a minute)
   #   pwsh -NoProfile -File Map-Repos.ps1 -Links <path>   one file's outgoing links and backlinks (repo:path or a unique tail)
   #   pwsh -NoProfile -File Map-Repos.ps1 -Orphans        files nothing links to (entry documents excepted)
   #   pwsh -NoProfile -File Map-Repos.ps1 -Install        refresh hourly and at logon (per-user scheduled task); -Uninstall removes it
   # Repositories are discovered on every run, so a new clone joins the map by itself; *-trusted-main copies and the
   # ORVION-Owner-Tools data store are skipped; an unborn or broken repository is listed under `problems`, never fatal.
   # Only files COMMITTED at HEAD are read (never the working tree or index, never untracked or ignored files), and paths
   # under sessions/ or events/ and *.jsonl are excluded; credentials in origin URLs are removed. Links (Obsidian-style,
   # with backlinks): markdown links, repository paths named in text, cross-repository paths, globs, distinctive bare file
   # names, SPEC-/WS- contract ids and ADR-NNNN sections. The outputs are git-ignored derived views, never authority.
   param([string]$GitHub=(Split-Path (Split-Path $PSScriptRoot -Parent) -Parent),[string]$Out=(Split-Path $PSScriptRoot -Parent),
         [string]$Links,[switch]$Orphans,[switch]$Install,[switch]$Uninstall,[string[]]$Skip=@('*-trusted-main','ORVION-Owner-Tools','_*'))
   $ErrorActionPreference='Stop'
   $GitHub=[IO.Path]::GetFullPath($GitHub);$Out=[IO.Path]::GetFullPath($Out);$json=Join-Path $Out 'ai-map.json';$task='ORVION Repository Map'
   if($Install){
       $skipArg=(@($Skip|ForEach-Object{"'"+$_.Replace("'","''")+"'"})-join',')
       $action=New-ScheduledTaskAction -Execute (Get-Command pwsh).Source -Argument "-NoProfile -WindowStyle Hidden -Command `"& '$PSCommandPath' -GitHub '$GitHub' -Out '$Out' -Skip $skipArg`""
       $triggers=@((New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME),(New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Hours 1)))
       Register-ScheduledTask -TaskName $task -Action $action -Trigger $triggers -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 10)) -Force|Out-Null
       "MAP TASK: '$task' refreshes $Out hourly and at logon";return
   }
   if($Uninstall){Unregister-ScheduledTask -TaskName $task -Confirm:$false -ErrorAction SilentlyContinue;"MAP TASK: removed";return}
   if($Links-or$Orphans){
       if(!(Test-Path -LiteralPath $json)){throw "MAP_MISSING: run Map-Repos.ps1 first ($json)"}
       $map=Get-Content -LiteralPath $json -Raw|ConvertFrom-Json
       if($Orphans){"ORPHANS: $($map.orphans.Count) of $($map.stats.files) files";$map.orphans;return}
       $hit=@($map.files|Where-Object{$_.id-ceq$Links-or$_.id.EndsWith('/'+$Links.Replace('\','/'))-or$_.id.EndsWith(':'+$Links.Replace('\','/'))})
       if($hit.Count-ne1){throw "MAP_LINKS_TARGET_$(if($hit.Count){'AMBIGUOUS: '+(@($hit.id)-join', ')}else{'UNKNOWN'})"}
       $f=$hit[0];"FILE: $($f.id)$(if($f.title){" - $($f.title)"})";"OUT ($($f.out.Count)):";$f.out|ForEach-Object{"  -> $_"};"IN ($($f.in.Count)):";$f.in|ForEach-Object{"  <- $_"};return
   }
   function Read-Git([string]$Repo){$o=@(& git -C $Repo @args 2>$null);if($LASTEXITCODE){throw "MAP_GIT_FAILED $Repo git $($args[0])"};$o}
   # Committed blob contents through one `git cat-file --batch`, in batches small enough that neither pipe can fill.
   function Read-Blobs([string]$Repo,[string[]]$BlobIds){
       $result=@{};if(!$BlobIds.Count){return $result}
       $si=[Diagnostics.ProcessStartInfo]::new('git');foreach($a in '-C',$Repo,'cat-file','--batch'){$si.ArgumentList.Add($a)};$si.UseShellExecute=$false;$si.RedirectStandardInput=$true;$si.RedirectStandardOutput=$true;$si.CreateNoWindow=$true
       $p=[Diagnostics.Process]::Start($si);$rd=[IO.BinaryReader]::new($p.StandardOutput.BaseStream)
       try{for($i=0;$i-lt$BlobIds.Count;$i+=100){
           $batch=$BlobIds[$i..([Math]::Min($i+99,$BlobIds.Count-1))];$p.StandardInput.Write(($batch-join"`n")+"`n");$p.StandardInput.Flush()
           foreach($id in $batch){
               $hdr=[Collections.Generic.List[byte]]::new();while(($b=$rd.ReadByte())-ne10){$hdr.Add($b)}
               $parts=[Text.Encoding]::ASCII.GetString($hdr.ToArray())-split' ';$n=[int64]$parts[2]
               $result[$id]=[Text.Encoding]::UTF8.GetString($rd.ReadBytes([int]$n));[void]$rd.ReadByte()
           }
       }}finally{$p.StandardInput.Close();$p.WaitForExit();$p.Dispose()}
       $result
   }
   # Discovery: a direct child of the GitHub folder whose top-level is itself; problems are reported, never fatal.
   $problems=[Collections.Generic.List[object]]::new()
   $repos=@(foreach($d in Get-ChildItem -LiteralPath $GitHub -Directory){
       if(@($Skip|Where-Object{$d.Name-like$_}).Count-or!(Test-Path -LiteralPath (Join-Path $d.FullName '.git'))){continue}
       $top="$(& git -C $d.FullName rev-parse --show-toplevel 2>$null)"
       if($LASTEXITCODE-or!$top-or[IO.Path]::GetFullPath($top)-ne$d.FullName){$problems.Add([ordered]@{repo=$d.Name;problem='not a readable Git work tree'});continue}
       $head="$(& git -C $d.FullName rev-parse -q --verify HEAD)".Trim();if(!$head){$problems.Add([ordered]@{repo=$d.Name;problem='no commits yet'})}
       [pscustomobject]@{name=$d.Name;root=$d.FullName;head=$head;branch="$(& git -C $d.FullName symbolic-ref -q --short HEAD)".Trim()
           origin=("$(& git -C $d.FullName config --get remote.origin.url)".Trim()-replace'://[^/@\s]+@','://')}
   })
   $text='\.(md|ps1|psm1|psd1|json|ya?ml|sql|py|ts|tsx|js|mjs|toml|txt|cmd|sh|csv)$';$private='(^|/)(sessions|events)/|\.jsonl$'
   $files=[ordered]@{};$byRepo=@{};$unscanned=[Collections.Generic.List[string]]::new();$bodies=@{}
   foreach($r in $repos){
       $rows=@();if($r.head){$rows=@(& git -C $r.root -c core.quotepath=off ls-tree -r --long HEAD 2>$null);if($LASTEXITCODE){throw "MAP_GIT_FAILED $($r.root) ls-tree"}};$paths=@();$want=@{}
       foreach($row in $rows){
           if($row-notmatch'^\d+ blob ([0-9a-f]{40,64}) +(\d+)\t(.+)$'){continue};$blob=$Matches[1];$size=[int64]$Matches[2];$p=$Matches[3]
           if($p-match$private){continue};$paths+=$p
           $files["$($r.name):$p"]=[ordered]@{id="$($r.name):$p";repo=$r.name;path=$p;title='';sections=@();out=[Collections.Generic.HashSet[string]]::new();in=[Collections.Generic.HashSet[string]]::new()}
           if($p-match$text){if($size-le2MB){$want[$blob]=@(@($want[$blob])+@($p)|Where-Object{$_})}else{$unscanned.Add("$($r.name):$p (over 2 MB)")}}
       }
       $byRepo[$r.name]=$paths;$got=Read-Blobs $r.root @($want.Keys)
       foreach($k in $want.Keys){foreach($p in $want[$k]){$bodies["$($r.name):$p"]=$got[$k]}}
   }
   # Indexes: unique basename and distinctive stem per repository, contract ids per repository, ADR sections.
   $base=@{};$stem=@{};$ids=@{}
   foreach($r in $repos){foreach($p in $byRepo[$r.name]){
       $k="$($r.name)|$([IO.Path]::GetFileName($p).ToLowerInvariant())";$base[$k]=@(@($base[$k])+@($p)|Where-Object{$_})
       $s=[IO.Path]::GetFileNameWithoutExtension($p);if($s.Length-ge10){$k="$($r.name)|$s";$stem[$k]=@(@($stem[$k])+@($p)|Where-Object{$_})}
       if($p-match'^changes/((?:SPEC|WS)-\d+)-'){$k="$($r.name)|$($Matches[1])";$ids[$k]=@(@($ids[$k])+@($p)|Where-Object{$_})}
   }}
   $adr=@{};$edges=[Collections.Generic.List[object]]::new();$seen=[Collections.Generic.HashSet[string]]::new();$broad=[ordered]@{};$names=@($repos.name)
   function Join-RepoPath([string]$Path){$parts=[Collections.Generic.List[string]]::new();foreach($s in $Path-split'/'){if($s-eq'..'){if(!$parts.Count){return $null};$parts.RemoveAt($parts.Count-1)}elseif($s-and$s-ne'.'){$parts.Add($s)}};$parts-join'/'}
   function Resolve-Target([string]$Repo,[string]$From,[string]$Target){
       $t=($Target-split'#')[0].Trim().Replace('\','/').Trim('`','"',"'",'<','>');if(!$t-or$t-match'^[a-z]+://'-and$t-notmatch'^file://'){return}
       $t=$t-replace'^file:///?','';try{$t=[Uri]::UnescapeDataString($t)}catch{}
       foreach($n in $names){$i=$t.IndexOf("/GitHub/$n/",[StringComparison]::OrdinalIgnoreCase);if($i-ge0){return "$n|$($t.Substring($i+9+$n.Length))"}}
       $dir=[IO.Path]::GetDirectoryName($From.Replace('/','\')).Replace('\','/')
       # A leading / is the repository root; otherwise the file's own folder first, then the root.
       $tries=if($t.StartsWith('/')){@($t.TrimStart('/'))}else{@($(if($dir){"$dir/$t"}),$t)}
       foreach($c in $tries){if(!$c){continue};$j=Join-RepoPath $c;if($j-and$files.Contains("$Repo`:$j")){return "$Repo|$j"}}
       # Only a path that leaves its own repository names a sibling repository.
       $up=if($dir){"$dir/$t"}else{$t}
       $m=[regex]::Match($t,'^(?:\.\./)+([^/]+)/(.+)$');if($m.Success-and$names-ccontains$m.Groups[1].Value-and!(Join-RepoPath $up)){return "$($m.Groups[1].Value)|$($m.Groups[2].Value)"}
       if($t-notmatch'/'){$b=@($base["$Repo|$($t.ToLowerInvariant())"]|Where-Object{$_});if($b.Count-eq1){return "$Repo|$($b[0])"}}
   }
   function Add-Edge([string]$From,[string]$To,[string]$Kind,[string]$Anchor){
       if(!$files.Contains($To)-or$From-ceq$To-or!$seen.Add("$From>$To#$Anchor")){return}
       [void]$files[$From].out.Add($To);[void]$files[$To].in.Add($From);$edges.Add([ordered]@{from=$From;to=$To;kind=$Kind;anchor=$Anchor})
   }
   foreach($id in @($bodies.Keys)){
       $f=$files[$id];if($f.path-match'\.md$'){$h=@([regex]::Matches($bodies[$id],'(?m)^#{1,4} (.+?)\s*$')|ForEach-Object{$_.Groups[1].Value});$f.sections=$h;if($h.Count){$f.title=$h[0]}
           foreach($m in [regex]::Matches($bodies[$id],'(?m)^#{2,4} (ADR-\d{4})\b')){$adr["$($f.repo)|$($m.Groups[1].Value)"]=$id}}
   }
   $pathRx='(?:\]\(([^)\s]+)\))|(?:`([^`\s]+\.[A-Za-z0-9]{1,5})(?:#[^`]*)?`)|((?:[A-Za-z]:)?[\w.\-]*(?:[\\/][\w.\-]+)+\.(?:md|ps1|psd1|json|ya?ml|sql|py|ts|js|toml|cmd|sh))'
   foreach($id in @($bodies.Keys)){
       $f=$files[$id];$body=$bodies[$id]
       foreach($m in [regex]::Matches($body,$pathRx)){
           $ref=@($m.Groups[1].Value,$m.Groups[2].Value,$m.Groups[3].Value)|Where-Object{$_}|Select-Object -First 1
           $hit=Resolve-Target $f.repo $f.path $ref;if($hit){$k,$p=$hit-split'\|',2;Add-Edge $id "$k`:$p" $(if($k-cne$f.repo){'cross-repo'}elseif($m.Groups[1].Success){'link'}else{'path'}) $(if($ref-match'#(.+)$'){$Matches[1]})}
       }
       # A pattern such as lib\test-*.ps1 links every committed file it matches (how a schedule reaches its suites).
       foreach($m in [regex]::Matches($body,'[\w.\-]+(?:[\\/][\w.\-*]+)*[\\/][\w.\-]*\*[\w.\-]*\.[A-Za-z0-9]{1,5}')){
           # ponytail: a pattern matching more than 30 files names a whole folder, not a reference; it is listed under stats.broadPatterns.
           $g=$m.Value.Replace('\','/');$hits=@($byRepo[$f.repo]|Where-Object{$_-like$g-or$_-like"*/$g"})
           if($hits.Count-le30){foreach($p in $hits){Add-Edge $id "$($f.repo):$p" 'glob' $m.Value}}else{$broad["$($f.repo):$g"]=$hits.Count}
       }
       foreach($m in [regex]::Matches($body,'[\w\-]{10,}')){$hits=@($stem["$($f.repo)|$($m.Value)"]|Where-Object{$_});if($hits.Count-eq1){Add-Edge $id "$($f.repo):$($hits[0])" 'name' $m.Value}}
       foreach($m in [regex]::Matches($body,'\b((?:SPEC|WS)-\d{2,4})\b')){foreach($p in @($ids["$($f.repo)|$($m.Groups[1].Value)"]|Where-Object{$_})){Add-Edge $id "$($f.repo):$p" 'contract' $m.Groups[1].Value}}
       foreach($m in [regex]::Matches($body,'\b(ADR-\d{4})\b')){$t=$adr["$($f.repo)|$($m.Groups[1].Value)"];if($t){Add-Edge $id $t 'adr' $m.Groups[1].Value}}
   }
   # Entry documents are roots, not orphans: agents arrive there first.
   $entry='^(README|AGENTS|CLAUDE|GEMINI|RESUME|HANDOFF|WORKFLOW|LICENSE|SECURITY|CONTRIBUTING)\.md$|^\.|/\.|(^|/)(README|AGENTS)\.md$'
   $list=@(foreach($f in $files.Values){[ordered]@{id=$f.id;repo=$f.repo;path=$f.path;title=$f.title;sections=@($f.sections);out=@($f.out|Sort-Object);in=@($f.in|Sort-Object)}})
   $orph=@($list|Where-Object{$_.in.Count-eq0-and$_.path-notmatch$entry}|ForEach-Object{$_.id}|Sort-Object)
   $map=[ordered]@{schema=1;generated=[DateTime]::UtcNow.ToString('o');tool='lib/Map-Repos.ps1';authority='derived view only; each repository owns its facts'
       repos=$repos;problems=$problems;stats=[ordered]@{repos=$repos.Count;files=$list.Count;edges=$edges.Count;orphans=$orph.Count;unscanned=@($unscanned);broadPatterns=$broad};orphans=$orph;files=$list;edges=$edges}
   $data=$map|ConvertTo-Json -Depth 6 -Compress
   $html=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'ai-map.template.html')).Replace('/*MAP_DATA*/null',$data.Replace('</','<\/'))
   # Each run writes its own temporary files and moves them into place, so overlapping runs never share a partial file.
   $run=[guid]::NewGuid().ToString('N')
   foreach($pair in @(@($json,$data),@((Join-Path $Out 'ai-map.html'),$html))){$tmp="$($pair[0]).$run.tmp";[IO.File]::WriteAllText($tmp,$pair[1],[Text.UTF8Encoding]::new($false));[IO.File]::Move($tmp,$pair[0],$true)}
   "MAP: $($repos.Count) repositories ($(@($repos.name)-join', ')), $($list.Count) files, $($edges.Count) links, $($orph.Count) orphans$(if($problems.Count){", $($problems.Count) problem(s)"})$(if($unscanned.Count){", $($unscanned.Count) unscanned"}) -> $json"
   ```

   The resulting file's Git blob is a0d77573b8aaaab77b2eea1b86a87a0dc0d49ddc.

2. Check whether `lib/ai-map.template.html` contains `<title>ORVION Repository Map</title>`; if so record Already Applied when its Git blob is cd7fcb51077581aaecf5535b7e60750ff958d840, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (interactive repository map only), and change nothing else:

   ```text
   <!doctype html>
   <html lang="en">
   <head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <title>ORVION Repository Map</title>
   <style>
   :root{--bg:#f7f7f5;--panel:#fff;--ink:#1d1d1b;--muted:#6b6b66;--line:#e2e1dc;--accent:#3a5bd9;--warn:#b5521b}
   @media (prefers-color-scheme:dark){:root{--bg:#161615;--panel:#1f1f1d;--ink:#ecebe6;--muted:#9b9a93;--line:#33332f;--accent:#8aa2ff;--warn:#f0a070}}
   *{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--ink);font:14px/1.45 system-ui,-apple-system,Segoe UI,sans-serif}
   header{display:flex;gap:12px;align-items:center;flex-wrap:wrap;padding:10px 16px;border-bottom:1px solid var(--line);background:var(--panel)}
   header h1{font-size:16px;margin:0 8px 0 0}header .stats{color:var(--muted);font-size:12px}
   input,select,button{font:inherit;color:inherit;background:var(--bg);border:1px solid var(--line);border-radius:6px;padding:5px 8px}
   button{cursor:pointer}button.on{border-color:var(--accent);color:var(--accent)}
   main{display:grid;grid-template-columns:minmax(220px,320px) 1fr;height:calc(100vh - 54px)}
   #list{overflow:auto;border-right:1px solid var(--line);background:var(--panel)}
   #list div{padding:4px 12px;cursor:pointer;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;font-size:13px}
   #list div:hover,#list div.sel{background:var(--bg)}#list .repo{color:var(--muted);font-size:11px}
   #detail{overflow:auto;padding:14px 18px;display:grid;grid-template-rows:auto 320px auto;gap:12px}
   h2{font-size:15px;margin:0;word-break:break-all}.muted{color:var(--muted)}
   canvas{width:100%;height:320px;background:var(--panel);border:1px solid var(--line);border-radius:8px}
   .cols{display:grid;grid-template-columns:1fr 1fr;gap:14px}.cols h3{font-size:13px;margin:0 0 6px}
   .cols a{display:block;color:var(--accent);text-decoration:none;font-size:13px;word-break:break-all;cursor:pointer}
   .orphan{color:var(--warn)}ul{margin:4px 0 0 18px;padding:0}
   @media (max-width:760px){main{grid-template-columns:1fr;height:auto}#list{max-height:40vh}.cols{grid-template-columns:1fr}}
   </style>
   </head>
   <body>
   <header><h1>ORVION Repository Map</h1>
   <input id="q" placeholder="Search files, titles, ids" size="28">
   <select id="repo"><option value="">All repositories</option></select>
   <button id="orph">Orphans only</button>
   <span class="stats" id="stats"></span></header>
   <main><div id="list"></div><div id="detail"><div><h2 id="title">Select a file</h2><div class="muted" id="sub"></div></div>
   <canvas id="g"></canvas>
   <div class="cols"><div><h3>Links out</h3><div id="out"></div></div><div><h3>Backlinks</h3><div id="in"></div></div></div></div></main>
   <script>
   const MAP=/*MAP_DATA*/null;
   const byId=new Map(MAP.files.map(f=>[f.id,f]));const orphans=new Set(MAP.orphans);
   const $=id=>document.getElementById(id);let onlyOrph=false,cur=null;
   $('stats').textContent=`${MAP.stats.repos} repositories · ${MAP.stats.files} files · ${MAP.stats.edges} links · ${MAP.stats.orphans} orphans · ${MAP.generated.slice(0,16).replace('T',' ')} UTC`;
   for(const r of MAP.repos){const o=document.createElement('option');o.value=r.name;o.textContent=r.name;$('repo').append(o)}
   function list(){const q=$('q').value.toLowerCase(),rp=$('repo').value,box=$('list');box.textContent='';let n=0;
    for(const f of MAP.files){if(rp&&f.repo!==rp)continue;if(onlyOrph&&!orphans.has(f.id))continue;
     if(q&&!(f.id.toLowerCase().includes(q)||(f.title||'').toLowerCase().includes(q)))continue;if(++n>600)break;
     const d=document.createElement('div');d.innerHTML=`<span class="repo">${esc(f.repo)}</span> ${esc(f.path)}`;if(orphans.has(f.id))d.classList.add('orphan');
     if(cur===f.id)d.classList.add('sel');d.onclick=()=>show(f.id);box.append(d)}}
   function esc(s){return s.replace(/[&<>]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;'}[c]))}
   function links(el,ids){el.textContent='';if(!ids.length){el.innerHTML='<span class="muted">none</span>';return}
    for(const id of ids){const a=document.createElement('a');a.textContent=id;a.onclick=()=>show(id);el.append(a)}}
   function show(id){const f=byId.get(id);if(!f)return;cur=id;$('title').textContent=f.id;
    $('sub').innerHTML=`${f.title?esc(f.title)+' · ':''}${f.out.length} out · ${f.in.length} in${orphans.has(id)?' · <span class="orphan">orphan: nothing links here</span>':''}`+
    (f.sections.length?`<ul>${f.sections.slice(0,12).map(s=>`<li>${esc(s)}</li>`).join('')}</ul>`:'');
    links($('out'),f.out);links($('in'),f.in);draw(f);list()}
   function draw(f){const c=$('g'),dpr=devicePixelRatio||1,W=c.clientWidth,H=c.clientHeight;c.width=W*dpr;c.height=H*dpr;const x=c.getContext('2d');x.scale(dpr,dpr);
    const ids=[f.id,...new Set([...f.out,...f.in])].slice(0,80),N=ids.map((id,i)=>({id,x:W/2+(i?Math.cos(i)*W/3:0),y:H/2+(i?Math.sin(i)*H/3:0),vx:0,vy:0}));
    const idx=new Map(N.map((n,i)=>[n.id,i])),E=[];for(const n of N){const g=byId.get(n.id);if(g)for(const t of g.out)if(idx.has(t))E.push([idx.get(n.id),idx.get(t)])}
    for(let it=0;it<220;it++){for(let i=0;i<N.length;i++)for(let j=i+1;j<N.length;j++){const a=N[i],b=N[j],dx=a.x-b.x,dy=a.y-b.y,d2=dx*dx+dy*dy+.01,k=900/d2;a.vx+=dx*k;a.vy+=dy*k;b.vx-=dx*k;b.vy-=dy*k}
     for(const[i,j]of E){const a=N[i],b=N[j],dx=b.x-a.x,dy=b.y-a.y,d=Math.hypot(dx,dy)||1,k=(d-90)*.02;a.vx+=dx/d*k;a.vy+=dy/d*k;b.vx-=dx/d*k;b.vy-=dy/d*k}
     for(const n of N){n.vx+=(W/2-n.x)*.004;n.vy+=(H/2-n.y)*.004;n.x+=n.vx*.5;n.y+=n.vy*.5;n.vx*=.6;n.vy*=.6;n.x=Math.max(8,Math.min(W-8,n.x));n.y=Math.max(8,Math.min(H-8,n.y))}}
    N[0].x=W/2;N[0].y=H/2;const css=getComputedStyle(document.body);x.strokeStyle=css.getPropertyValue('--line');
    for(const[i,j]of E){x.beginPath();x.moveTo(N[i].x,N[i].y);x.lineTo(N[j].x,N[j].y);x.stroke()}
    x.font='11px system-ui';for(const[i,n]of N.entries()){x.fillStyle=i?(orphans.has(n.id)?css.getPropertyValue('--warn'):css.getPropertyValue('--accent')):css.getPropertyValue('--ink');
     x.beginPath();x.arc(n.x,n.y,i?4:7,0,7);x.fill();x.fillStyle=css.getPropertyValue('--muted');x.fillText(n.id.split('/').pop(),n.x+6,n.y-6)}
    c.onclick=e=>{const r=c.getBoundingClientRect(),px=e.clientX-r.left,py=e.clientY-r.top;for(const n of N)if(Math.hypot(n.x-px,n.y-py)<8)return show(n.id)}}
   $('q').oninput=list;$('repo').onchange=list;$('orph').onclick=()=>{onlyOrph=!onlyOrph;$('orph').classList.toggle('on',onlyOrph);list()};
   list();const start=MAP.files.find(f=>/README\.md$/.test(f.path));if(start)show(start.id);
   </script>
   </body>
   </html>
   ```

   The resulting file's Git blob is cd7fcb51077581aaecf5535b7e60750ff958d840.

3. Check whether `lib/test-map-repos.ps1` contains `Interactive repository map v1`; if so record Already Applied when its Git blob is 1e5dc5b43a491f2f9a201306dc405261d00f4923, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (interactive repository map only), and change nothing else:

   ```text
   # Self-check for Map-Repos.ps1 (Interactive repository map v1): disposable temp repositories only.
   $ErrorActionPreference='Stop'
   $t=Join-Path ([IO.Path]::GetTempPath()) ('orvion-map-test-'+[guid]::NewGuid().ToString('N'));$gh=Join-Path $t 'GitHub';$out=Join-Path $t 'out'
   [void][IO.Directory]::CreateDirectory($gh);[void][IO.Directory]::CreateDirectory($out);$fail=0
   function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
   function New-Repo([string]$Name,[hashtable]$Files){
       $r=Join-Path $gh $Name;[void][IO.Directory]::CreateDirectory($r);& git init -q $r 2>&1|Out-Null
       foreach($k in $Files.Keys){$p=Join-Path $r $k;[void][IO.Directory]::CreateDirectory((Split-Path $p -Parent));[IO.File]::WriteAllText($p,$Files[$k])}
       & git -C $r add -A 2>&1|Out-Null;& git -C $r -c user.name=t -c user.email=t@t commit -q -m init 2>&1|Out-Null;if($LASTEXITCODE){throw "FIXTURE_COMMIT_FAILED $Name"};$r
   }
   try{
       $a=New-Repo 'RepoA' @{
           'README.md'="# Repo A`nStart at [the guide](docs/guide.md), its [first part](docs/guide.md#first) and [second part](docs/guide.md#second).`n"
           'docs/guide.md'="# Guide`nRun ``scripts/run.ps1``, see SPEC-001, ADR-0001, ../../RepoB/notes.md and [local](../RepoB/local.md); migration 202601010000_initial_schema applies.`n"
           'changes/SPEC-001-first.md'="# SPEC-001`nNothing else.`n"
           'reports/adr.md'="# ADRs`n## ADR-0001 — first decision`nText.`n"
           'scripts/run.ps1'="# runs every lib\test-*.ps1`n"
           'lib/test-one.ps1'="'ok'`n"
           'supabase/migrations/202601010000_initial_schema.sql'="select 1;`n"
           'lonely.md'="# Nobody links here`n"
           'RepoB/local.md'="# a folder named like a sibling repository`n"
           'sessions/raw/s.jsonl'='{"secret":"session-text-never-mapped"}'
           '.gitignore'="secret.md`n"
       }
       [IO.File]::WriteAllText((Join-Path $a 'secret.md'),'token=never-in-the-map')
       & git -C $a remote add origin 'https://user:origin-secret-123@example.com/a.git'
       [IO.File]::WriteAllText((Join-Path $a 'README.md'),"# Changed but not committed`n");[IO.File]::WriteAllText((Join-Path $a 'docs/staged.md'),'# staged only');& git -C $a add docs/staged.md
       $unborn=Join-Path $gh 'RepoD';& git init -q $unborn 2>&1|Out-Null
       $broken=Join-Path $gh 'RepoE\.git';[void][IO.Directory]::CreateDirectory($broken);[IO.File]::WriteAllText((Join-Path $broken 'HEAD'),'not a repository')
       [void](New-Repo 'RepoB' @{'notes.md'="# Notes`nBack to [guide](../RepoA/docs/guide.md).`n"})
       [void](New-Repo 'RepoA-trusted-main' @{'README.md'="# copy`n"})
       $script=Join-Path $PSScriptRoot 'Map-Repos.ps1'
       $o=@(& pwsh -NoProfile -File $script -GitHub $gh -Out $out 2>&1);if($LASTEXITCODE){throw ('MAP_RUN_FAILED: '+($o-join' '))}
       $m=Get-Content (Join-Path $out 'ai-map.json') -Raw|ConvertFrom-Json
       function Has-Edge([string]$From,[string]$To,[string]$Kind){@($m.edges|Where-Object{$_.from-ceq$From-and$_.to-ceq$To-and$_.kind-ceq$Kind}).Count-ge1}
       Assert-That 'discovers repositories, skips trusted copies, reports unborn and broken ones without failing' ((@($m.repos.name)-join',')-ceq'RepoA,RepoB,RepoD'-and@($m.problems|Where-Object{$_.repo-ceq'RepoD'-and$_.problem-match'no commits'}).Count-eq1-and@($m.problems|Where-Object{$_.repo-ceq'RepoE'}).Count-eq1)
       Assert-That 'each repository records its full HEAD' (@($m.repos|Where-Object{$_.name-ne'RepoD'-and$_.head-notmatch'^[0-9a-f]{40}$'}).Count-eq0)
       Assert-That 'a nested folder named like a sibling repository resolves locally' (Has-Edge 'RepoA:docs/guide.md' 'RepoA:RepoB/local.md' 'link')
       Assert-That 'two anchors into one file stay two edges' (@($m.edges|Where-Object{$_.from-ceq'RepoA:README.md'-and$_.to-ceq'RepoA:docs/guide.md'}).Count-eq3)
       Assert-That 'markdown link resolves relative to its file' (Has-Edge 'RepoA:README.md' 'RepoA:docs/guide.md' 'link')
       Assert-That 'a repository path named in text links' (Has-Edge 'RepoA:docs/guide.md' 'RepoA:scripts/run.ps1' 'path')
       Assert-That 'a contract id links to its contract' (Has-Edge 'RepoA:docs/guide.md' 'RepoA:changes/SPEC-001-first.md' 'contract')
       Assert-That 'an ADR id links to the file holding its section' (Has-Edge 'RepoA:docs/guide.md' 'RepoA:reports/adr.md' 'adr')
       Assert-That 'cross-repository paths link both ways' ((Has-Edge 'RepoA:docs/guide.md' 'RepoB:notes.md' 'cross-repo')-and(Has-Edge 'RepoB:notes.md' 'RepoA:docs/guide.md' 'cross-repo'))
       Assert-That 'a glob links the files it matches' (Has-Edge 'RepoA:scripts/run.ps1' 'RepoA:lib/test-one.ps1' 'glob')
       Assert-That 'a distinctive bare file name links' (Has-Edge 'RepoA:docs/guide.md' 'RepoA:supabase/migrations/202601010000_initial_schema.sql' 'name')
       $guide=@($m.files|Where-Object id -ceq 'RepoA:docs/guide.md')[0]
       Assert-That 'backlinks and sections are recorded' (($guide.in-ccontains'RepoA:README.md')-and($guide.in-ccontains'RepoB:notes.md')-and$guide.title-ceq'Guide')
       Assert-That 'orphans name unlinked files but never entry documents' (($m.orphans-ccontains'RepoA:lonely.md')-and($m.orphans-cnotcontains'RepoA:README.md')-and($m.orphans-cnotcontains'RepoA:docs/guide.md'))
       $raw=[IO.File]::ReadAllText((Join-Path $out 'ai-map.json'))+[IO.File]::ReadAllText((Join-Path $out 'ai-map.html'))
       Assert-That 'only committed content enters: no untracked, ignored, staged or working-tree text' ($raw-notmatch'secret\.md'-and$raw-notmatch'never-in-the-map'-and$raw-notmatch'staged\.md'-and$raw-notmatch'Changed but not committed')
       Assert-That 'sessions and origin credentials never enter the map' ($raw-notmatch'session-text-never-mapped'-and$raw-notmatch'sessions/raw'-and$raw-notmatch'origin-secret-123')
       Assert-That 'the interactive view embeds the map data' ($raw-notmatch'/\*MAP_DATA\*/null'-and$raw-match'ORVION Repository Map')
       $links=@(& pwsh -NoProfile -File $script -Out $out -Links 'docs/guide.md' 2>&1)
       Assert-That '-Links prints outgoing links and backlinks' ($LASTEXITCODE-eq0-and($links-join"`n")-match'<- RepoA:README\.md'-and($links-join"`n")-match'-> RepoB:notes\.md')
       $orph=@(& pwsh -NoProfile -File $script -Out $out -Orphans 2>&1)
       Assert-That '-Orphans lists the orphan files' ($LASTEXITCODE-eq0-and($orph-join"`n")-match'RepoA:lonely\.md')
       [void](New-Repo 'RepoC' @{'README.md'="# C`n"})
       & pwsh -NoProfile -File $script -GitHub $gh -Out $out 2>&1|Out-Null
       Assert-That 'a new repository joins on the next run' ((@((Get-Content (Join-Path $out 'ai-map.json') -Raw|ConvertFrom-Json).repos.name)-join',')-ceq'RepoA,RepoB,RepoC,RepoD')
   }finally{Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
   if($fail){throw "MAP_REPOS_SELFCHECK_FAILED $fail"};'MAP_REPOS_SELFCHECK PASS'
   ```

   The resulting file's Git blob is 1e5dc5b43a491f2f9a201306dc405261d00f4923.

4. Check whether `.gitignore` contains `# Interactive repository map v1:`; if so record Already Applied when its Git blob is 9ad9397a7f6e56cfcea7fcfb9536ae3c819669b3, and otherwise stop and report. Otherwise make exactly this one edit (interactive repository map only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   /ai-map.json
   ```
   insert
   ```text
   # Interactive repository map v1: lib/Map-Repos.ps1 regenerates its viewer beside ai-map.json.
   /ai-map.html
   ```

   The resulting file's Git blob is 9ad9397a7f6e56cfcea7fcfb9536ae3c819669b3.

5. Check whether `README.md` contains `Interactive repository map v1`; if so record Already Applied when its Git blob is 40d50f6cbc1b9499f3a0d50dbe0f92e16285a975, and otherwise stop and report. Otherwise make exactly this one edit (interactive repository map only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   7. Recovery after reinstalling Windows: [docs/RECOVERY.md](docs/RECOVERY.md).
   ```
   insert
   ```text
   8. See the whole estate at once (Interactive repository map v1): `lib\Map-Repos.ps1` maps every Git repository under
      the GitHub folder (discovered on each run) into `ai-map.json` and `ai-map.html` in this root (git-ignored, refreshed
      hourly once `-Install` registers its task). `-Links <path>` prints a file's links and backlinks; `-Orphans` lists
      files nothing links to: link a new file from where it belongs so it is never orphaned. A derived view, never authority.
   ```

   The resulting file's Git blob is 40d50f6cbc1b9499f3a0d50dbe0f92e16285a975.

6. Check whether `lib/README.md` contains `Interactive repository map v1:`; if so record Already Applied when its Git blob is ee2638b8123596eea559aeea41612a04ae81781c, and otherwise stop and report. Otherwise make exactly this one edit (interactive repository map only), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   | `Delegate.ps1 -Pattern <id> -Question '...'` / `-Report <folder> -Reply <file>` / `-List` | the delegation road: a bounded brief for a cold agent (authority never grows, due = twice its budget); `-Report` is the return road: saves the reply, records the verdict, hands the item back to the agent |
   ```
   insert
   ```text
   | `Map-Repos.ps1` / `-Links <path>` / `-Orphans` / `-Install` | Interactive repository map v1: every Git repository under the GitHub folder, tracked files only, Obsidian-style links and backlinks (markdown links, named paths, globs, distinctive names, SPEC/WS/ADR ids, cross-repository) and orphans -> root `ai-map.json` + `ai-map.html` (git-ignored); `-Install` refreshes hourly and at logon |
   ```

   The resulting file's Git blob is ee2638b8123596eea559aeea41612a04ae81781c.

## Acceptance Criteria

- [x] Exact approved scoped output. check: blob:lib/Map-Repos.ps1=a0d77573b8aaaab77b2eea1b86a87a0dc0d49ddc
- [x] Exact approved scoped output. check: blob:lib/ai-map.template.html=cd7fcb51077581aaecf5535b7e60750ff958d840
- [x] Exact approved scoped output. check: blob:lib/test-map-repos.ps1=1e5dc5b43a491f2f9a201306dc405261d00f4923
- [x] Exact approved scoped output. check: blob:.gitignore=9ad9397a7f6e56cfcea7fcfb9536ae3c819669b3
- [x] Exact approved scoped output. check: blob:README.md=40d50f6cbc1b9499f3a0d50dbe0f92e16285a975
- [x] Exact approved scoped output. check: blob:lib/README.md=ee2638b8123596eea559aeea41612a04ae81781c
- [x] The owning test proves: repositories are discovered, *-trusted-main copies skipped and unborn or broken ones reported without failing; the full HEAD is recorded; a nested folder named like a sibling repository resolves locally; two anchors into one file stay two edges; markdown links, named repository paths, contract ids, ADR sections, cross-repository paths (both ways), globs and distinctive bare names each produce their edge; backlinks, titles and sections are recorded; orphans list unlinked files but never entry documents; only committed content enters (no untracked, ignored, staged or working-tree text); sessions and origin credentials never enter; the HTML view embeds the data; -Links and -Orphans answer; a repository added later joins on the next run.
- [x] Mandatory V1/V2/V3, focused proof, planted-regression mutants, accepted literal replay controls and the real three-repository measurement are preserved. One isolated native timed/watched Finish owns the full schedule with a fresh SANDBOX receipt before original approval; the original needs its own fresh Finish, live Review, native Complete and an independent carrying-range READY.

## Review Gate

- [x] Inspect the six scoped files, the focused/mutant/literal evidence and the real measurement; preserve all frozen prior evidence.
- [x] Independently check the native receipt root/Draft/recipe/evaluator/fingerprint, ordered tests and timed/watcher/host exits; normal native Review/Complete and every new carrying transition must pass. No second-agent or provider certification is claimed.

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Execution Log

Owner directive of 2026-10-26 (C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\OWNER-DIRECTIVE-INTERACTIVE-MAP.md, decision D17) under the owner's exceptional delegation authorizes this one Workbench contract. Gate 1 for this Draft is DELEGATED: the owner did not type its digest. Sandbox approval is synthetic and grants no original authority.
Approved Draft: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws016-package\assurance\V3\DRAFT.md
Approved SHA256: BD6439F9BBB3C88E264C2782D93E5F910D5A958D10ABA4002889A726D7A5E84F
Owner Evidence: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\exceptional-delegation-20261026\GATE1-WS016-DELEGATED.md
Owner Evidence SHA256: A883C9614FC2F63BEB0A1F73905510DE8CADEEF723C7AEBEC4FAAA88A50D5F24
Execution Root: C:\Users\My Lab\Documents\GitHub\ORVION-Workbench
Sandbox Receipt: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws016-package\runtime\sandbox\own-finish-receipt.json
Sandbox Receipt SHA256: 4BC63AFC7A5DD29F71C88FCF322CF4CDA4E37B1242FA0742E32ABBB01AF9CAB3
Original admission: DELEGATED exact Gate 1 under the owner's exceptional delegation of 2026-10-26 (OWNER-DELEGATION.md SHA-256 94631C14708B783C584D0867AD4AD11221D5394F5FDEDAA48F64FA0BF9788217; decisions D1-D17; D17 is the owner directive for this map). The owner did not type this digest. Bound to this literal root, the exact V3 digest and the fresh sandbox receipt; no sandbox receipt transplant as original certification.
Original exact literal implementation applied by accepted native Workbench Execute. Declared filtered blobs match. Fresh root-bound original Finish and independent live Review remain required; sandbox success does not certify this root. This frozen Draft was not expanded.

## Verification Notes

Measured before freeze on the real workstation (real-measurement.json): 3 repositories discovered (CRM 20ea5e0, ORVION 0529a0d, ORVION-Workbench a8bf1fd), 0 problems, 2086 committed files, 35319 links (name 15643, path 14634, contract 3598, adr 791, glob 633, link 19, cross-repo 1), 146 orphans (mostly reports/history, superseded contracts and pgTAP tests), 0 unscanned, 16 broad patterns reported, 56 s, 8.7 MB JSON and 8.7 MB HTML. A first run reached only 300 orphans by path links; bare migration names and test globs then linked their files; an unbounded glob linked whole folders (20748 edges, 5 orphans), so a pattern matching more than 30 files is reported under stats.broadPatterns instead of linking. An independent Codex review (codex-review/review1-report.txt) held the first candidate for credential export, working-tree reads, wrong relative resolution, truncated HEAD, fatal unborn repositories, collapsed anchors and dropped -Skip; every proven finding is fixed and pinned by the 19-case self-check (codex-review/review1-disposition.md); section-level orphans are deferred. The hazard scanner caught $Raw/$raw, then $Ids/$ids, $Out/$out and $Ref/$ref; scan now 0. All three repositories are public (gh, 2026-10-26); the map reads committed HEAD blobs only. Four planted regressions (trusted-copy skip, backlinks, anchor dedupe, working-tree read) are each detected (mutants.log).
Verdict: Confirmed Complete
Reviewed Fingerprint: AC514A9D8FF1ED6C3FE2893E8D0F055E7979C1BFD9C728EB12889C45BC86CC17
Reviewed Receipt: BE5613F344ECAEC88DA1E6876F654F185149C3BE1F1445558DAB085FFE982BD0
Evidence: fresh ORIGINAL root-bound timed/watched Finish, actual ordered-suite schedule/exits, approved exact outputs and independently pinned accepted-code live review. Runtime: C:\Users\My Lab\Documents\ORVION-Owner-Review\engineering-continuation-20261025\ws016-package\runtime\original. No sandbox receipt transplant, remote parity, offsite recovery or equal-OS isolation claim.

## Selection reasons and sources

Evidence Refresh: focused-selected.log 19/19 PASS on the selected bytes, four planted regressions detected, hazard scan 0, real three-repository measurement (real-measurement.json), literal replay controls run before the one sandbox Finish. Baseline a8bf1fd (main = preflight), accepted judge 835E14DA unchanged.

Sources: OWNER-DIRECTIVE-INTERACTIVE-MAP.md, DECISIONS.md D17, accepted WORKFLOW/TEMPLATE/checker, WS-015 packet scripts, Founder scripts/generate-ai-map.ps1 (projection precedent), Spider.ps1 crawl rules, the real three-repository measurement.
