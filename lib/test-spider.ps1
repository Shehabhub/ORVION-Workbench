# Self-check for Spider.ps1 on a temp workspace: it finds the query in a session, an event, a repository file, a commit
# message, a data file and a temporary file, each under its label; a Markdown hit carries path:line section N; it masks a credential value in the snippet; and a repository git cannot read refuses loudly.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-spidercheck-$([guid]::NewGuid().ToString('N').Substring(0,6))"
$previousProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
$savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
$env:GIT_CONFIG_GLOBAL=Join-Path $t 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
function Invoke-Quiet{param([string]$Dir)& git -C $Dir @args 2>&1|Out-Null;if($LASTEXITCODE){throw "git $args failed"}}
try{
    $tempRoot=Join-Path $t 'temporary';[void][IO.Directory]::CreateDirectory($tempRoot)
    $raw=Join-Path $t 'ws\sessions\raw\claude\p';New-Item -ItemType Directory $raw -Force|Out-Null
    $tok='Z'+('9'*25)
    Set-Content (Join-Path $raw 's1.jsonl') ("{`"timestamp`":`"2026-10-01T10:00:00Z`",`"x`":`"saw ZEBRA-42 with API_KEY=$tok here`"}")
    '{"id":"s1","start":"2026-10-01T10:00:00Z","title":"zebra session","repo":"CRM","raw":"sessions\\raw\\claude\\p\\s1.jsonl"}'|Set-Content (Join-Path $t 'ws\sessions\index.jsonl')
    & (Join-Path $PSScriptRoot 'Events.ps1') -Root (Join-Path $t 'ws') -Add -Pattern zebra-case -Session s1 -Summary 'ZEBRA-42 broke once' -Tags 'zebra-42'|Out-Null
    [void][IO.Directory]::CreateDirectory((Join-Path $t 'ws/records/claude-memory/project'))
    Set-Content (Join-Path $t 'ws/records/README.md') 'Notes about ZEBRA-42.'
    $repo=Join-Path $t 'repo';New-Item -ItemType Directory $repo|Out-Null;Invoke-Quiet $repo init -q
    Set-Content (Join-Path $repo 'a.md') "ZEBRA-42 is fixed`nZEBRA-42 again";Invoke-Quiet $repo add -A
    Invoke-Quiet $repo -c user.name=t -c user.email=t@t commit -q -m 'Fix ZEBRA-42'
    $out=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $repo)
    $text=$out-join"`n"
    Assert-That 'session found with its task' ($text-match'== data sessions: 1 mention it'-and$text-match'zebra session')
    Assert-That 'credential value masked in the snippet' ($text-match'API_KEY=<masked>'-and$text-notmatch$tok)
    Assert-That 'event found' ($text-match'zebra-case')
    Assert-That 'repository file and commit found' ($text-match'== repo repo files: 1 \(a\.md 2\)'-and$text-match'Fix ZEBRA-42')
    Assert-That 'note found' ($text-match'== data files: \d+ .*README\.md')
    Assert-That 'the transcripts and the journal are not searched twice' ($text-notmatch'(?m)^== data files:.*(s1\.jsonl|events\.jsonl)')
    # A token cut by the snippet window (70 characters before the query, 220 long) is still masked whole: the window
    # starts 12 characters into one token and ends 12 characters into another, so only the pre-cut mask hides them.
    $cutTok='ghp_'+'Qx7Lm2Vt9Rk4Wp6Ns3Hd8Jf5Bc1Gz0YaUe4T'
    Set-Content (Join-Path $raw 'edge-start.jsonl') ('{"x":" '+$cutTok+' '+('s'*40)+' EDGE-77 here"}')
    Set-Content (Join-Path $raw 'edge-end.jsonl') ('{"x":"EDGE-77 '+('e'*193)+' '+$cutTok+' end"}')
    $cut=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'EDGE-77' -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $repo)-join"`n"
    Assert-That 'a token cut by the snippet window leaves no 8-character fragment' ($cut-match'== data sessions: 2 mention it'-and@(0..($cutTok.Length-8)|Where-Object{$cut.Contains($cutTok.Substring($_,8))}).Count-eq0)
    Assert-That 'missing optional Claude root is not created' (!(Test-Path (Join-Path $env:USERPROFILE '.claude')))
    $projects=Join-Path $t 'ws/records/claude-memory'
    [void][IO.Directory]::CreateDirectory($projects)
    $empty=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $repo)
    Assert-That 'empty optional projects retains workspace notes' (($empty-join' ')-match'README\.md')
    [void][IO.Directory]::CreateDirectory((Join-Path $projects 'no-memory'))
    $memory=Join-Path $projects 'project';[void][IO.Directory]::CreateDirectory($memory)
    $note=Join-Path $memory 'fixture.md';[IO.File]::WriteAllText($note,'ZEBRA-42 memory')
    $present=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $repo)
    Assert-That 'valid Claude memory is searched and missing project memory is optional' (($present-join' ')-match'fixture\.md')
    $handle=[IO.File]::Open($note,'Open','ReadWrite','None')
    try{$locked=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $repo);$lockedCode=$LASTEXITCODE}finally{$handle.Dispose()}
    Assert-That 'an unreadable file is a named coverage gap, never no match' ($lockedCode-eq3-and($locked-join"`n")-match'SPIDER_COVERAGE: incomplete - data \(unreadable .*fixture\.md\)')
    # SP06: a Markdown hit prints path:line section N, the nearest ## heading above it, outside a code fence.
    $fence='```'
    $docs=[ordered]@{'above.md'="# Title`nCASE-1";'three.md'="# Title`n## 3. Third`nCASE-2 words";'fence.md'="## 3. Third`n${fence}text`n## 9. Fenced`n$fence`nCASE-3";'deep.md'="### 10.1 Deep`nCASE-4";'dec.md'="## DEC-18 Rule`nCASE-5";'plain.md'="## Plain title`nCASE-6";'many.md'="CASE-7`nCASE-7`nCASE-7`nCASE-7`nCASE-7";'edge.md'=(' '+$cutTok+' '+('s'*40)+' CASE-8 here');'note.txt'='CASE-9'}
    foreach($name in $docs.Keys){Set-Content (Join-Path $repo $name) $docs[$name]};Invoke-Quiet $repo add -A;Invoke-Quiet $repo -c user.name=t -c user.email=t@t commit -q -m 'section fixtures'
    Set-Content (Join-Path $t 'ws/records/three.md') "## 3. Third`nCASE-2 data"
    $case=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'CASE-' -Top 20 -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $repo)-join"`n"
    Assert-That 'a Markdown hit prints path:line and its section number' ($case-match'(?m)^  repo repo three\.md:3 section 3: CASE-2 words')
    Assert-That 'a hit above the first ## heading prints section -' ($case-match'(?m)^  repo repo above\.md:2 section -: CASE-1')
    Assert-That 'a heading inside a code fence is not a section' ($case-match'(?m)^  repo repo fence\.md:5 section 3: CASE-3')
    Assert-That 'a dotted heading prints its whole ID' ($case-match'(?m)^  repo repo deep\.md:2 section 10\.1: CASE-4')
    Assert-That 'a decision heading prints its ID' ($case-match'(?m)^  repo repo dec\.md:2 section DEC-18: CASE-5')
    Assert-That 'a heading with no ID prints its title' ($case-match'(?m)^  repo repo plain\.md:2 section Plain title: CASE-6')
    Assert-That 'a file with more than three hits prints three and the rest as a count' (@([regex]::Matches($case,'(?m)^  repo repo many\.md:\d+ section -')).Count-eq3-and$case-match'(?m)^  repo repo many\.md: \+2 more$')
    Assert-That 'a non-Markdown hit keeps path and count, with no line' ($case-match'note\.txt 1'-and$case-notmatch'note\.txt:')
    Assert-That 'a token cut by the window on a Markdown hit leaves no fragment' ($case-match'edge\.md:1 section -'-and@(0..($cutTok.Length-8)|Where-Object{$case.Contains($cutTok.Substring($_,8))}).Count-eq0)
    Assert-That 'a data Markdown hit carries the data label' ($case-match'(?m)^  data records/three\.md:2 section 3: CASE-2 data')
    # Temporary is bounded: names everywhere walked, text of sb, scratch and each README, never a checkout, a link or a binary.
    foreach($d in 'sb/W33/sandbox-a','sb/W33/TEMP-8-checkout/.git','scratch/W33-x','cx/W33-proto'){[void][IO.Directory]::CreateDirectory((Join-Path $tempRoot $d))}
    Set-Content (Join-Path $tempRoot 'sb/W33/notes.md') "## 4. Notes`nTEMP-8 kept"
    Set-Content (Join-Path $tempRoot 'scratch/W33-x/out.log') 'TEMP-8 log'
    Set-Content (Join-Path $tempRoot 'README.md') 'TEMP-8 organizer'
    Set-Content (Join-Path $tempRoot 'cx/W33-proto/loose.md') 'TEMP-8 clone'
    Set-Content (Join-Path $tempRoot 'sb/W33/sandbox-a/s.md') 'TEMP-8 sandbox'
    Set-Content (Join-Path $tempRoot 'sb/W33/TEMP-8-checkout/c.md') 'TEMP-8 checkout'
    Set-Content (Join-Path $tempRoot 'sb/W33/x.dll') 'TEMP-8 binary'
    Set-Content (Join-Path $tempRoot 'sb/W33/TEMP-8-name.bin') 'nothing here'
    $outside=Join-Path $t 'outside';[void][IO.Directory]::CreateDirectory($outside);Set-Content (Join-Path $outside 'TEMP-8-far.md') 'TEMP-8 far'
    [IO.File]::WriteAllText((Join-Path $tempRoot 'sb/W33/big.txt'),'TEMP-8 '+('b'*(2MB+1)))
    $linked=Join-Path $tempRoot 'sb/W33/linked';New-Item -ItemType Junction -Path $linked -Target $outside|Out-Null
    [void][IO.Directory]::CreateDirectory((Join-Path $t 'ws/records/sandbox-d'));Set-Content (Join-Path $t 'ws/records/sandbox-d/s.md') 'TEMP-8 data sandbox'
    $bound=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'TEMP-8' -Top 20 -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $repo)-join"`n"
    $tempLine=[regex]::Match($bound,'(?m)^== temporary files:.*$').Value;$nameLine=[regex]::Match($bound,'(?m)^== temporary names:.*$').Value
    Assert-That 'temporary searches sb, scratch and README, under its label' ($tempLine-match'== temporary files: 3 '-and$tempLine-match'sb/W33/notes\.md 1'-and$tempLine-match'scratch/W33-x/out\.log 1'-and$tempLine-match'README\.md 1')
    Assert-That 'a temporary Markdown hit carries the temporary label' ($bound-match'(?m)^  temporary sb/W33/notes\.md:2 section 4: TEMP-8 kept')
    Assert-That 'a clone outside the bound is not read' ($tempLine-notmatch'loose\.md')
    Assert-That 'a sandbox folder is not read in temporary or data' ($tempLine-notmatch'sandbox'-and$bound-notmatch'sandbox-d/s\.md')
    Assert-That 'a Git checkout is one name, never entered' ($tempLine-notmatch'c\.md'-and$nameLine-match'sb/W33/TEMP-8-checkout/'-and$nameLine-notmatch'checkout/c\.md')
    Assert-That 'a binary is a name, its text not read' ($tempLine-notmatch'x\.dll'-and$nameLine-match'TEMP-8-name\.bin')
    Assert-That 'a file over 2 MB is counted, not read' ($tempLine-notmatch'big\.txt'-and$tempLine-match'; 1 over 2 MB not read')
    Assert-That 'a link is not followed' ($bound-notmatch'TEMP-8-far'-and$tempLine-notmatch'linked')
    [IO.Directory]::Delete($linked)  # a recursive delete refuses a junction without administrator rights
    # Default repositories follow the map's discovery rule: all three repos, never trusted copies or the temporary tree.
    $gh=Join-Path $t 'gh'
    foreach($n in 'CRM','ORVION','ORVION-Workbench','ORVION-trusted-main','ORVION-Workbench-temporary'){$d=Join-Path $gh $n;New-Item -ItemType Directory $d -Force|Out-Null;Invoke-Quiet $d init -q;Set-Content (Join-Path $d 'n.md') 'ZEBRA-42';Invoke-Quiet $d add -A;Invoke-Quiet $d -c user.name=t -c user.email=t@t commit -q -m n}
    $all=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Temporary $tempRoot -GitHub $gh)-join"`n"
    Assert-That 'default search covers CRM, ORVION and ORVION-Workbench, skipping trusted and temporary copies' ($all-match'(?m)^== repo CRM files: 1'-and$all-match'(?m)^== repo ORVION files: 1'-and$all-match'(?m)^== repo ORVION-Workbench files: 1'-and$all-notmatch'== repo ORVION-trusted-main'-and$all-notmatch'== repo ORVION-Workbench-temporary')
    # An expected repository that is present but not Git is a named coverage gap, never silently skipped.
    Rename-Item -LiteralPath (Join-Path $gh 'ORVION-Workbench\.git') '.git-hidden'
    try{$noGit=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Temporary $tempRoot -GitHub $gh);$noGitCode=$LASTEXITCODE}
    finally{Rename-Item -LiteralPath (Join-Path $gh 'ORVION-Workbench\.git-hidden') '.git'}
    Assert-That 'an expected repository without Git is a coverage gap (exit 3)' ($noGitCode-eq3-and($noGit-join"`n")-match'SPIDER_COVERAGE: incomplete - ORVION-Workbench \(no repository\)')
    # Every rendered field is masked: the query header and a session title, not only snippets.
    $ghToken='ghp_'+('A1b2C3d4E5'*4).Substring(0,36)
    $ixFile=Join-Path $t 'ws\sessions\index.jsonl';$savedIx=[IO.File]::ReadAllText($ixFile)
    [IO.File]::WriteAllText($ixFile,('{"id":"s1","start":"2026-10-01T10:00:00Z","title":"zebra '+$ghToken+'","repo":"CRM","raw":"sessions\\raw\\claude\\p\\s1.jsonl"}'))
    try{$masked=@(& (Join-Path $PSScriptRoot 'Spider.ps1') "ZEBRA-42 $ghToken" -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $repo)+@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $repo)}
    finally{[IO.File]::WriteAllText($ixFile,$savedIx)}
    # File names, archive pointers and git failures are rendered too: one mask covers every line.
    Set-Content (Join-Path $repo "$ghToken.md") 'ZEBRA-42';Invoke-Quiet $repo add -A;Invoke-Quiet $repo -c user.name=t -c user.email=t@t commit -q -m 'token-shaped file'
    $tokenWs=Join-Path $t $ghToken;Copy-Item (Join-Path $t 'ws') $tokenWs -Recurse
    $paths=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root $tokenWs -Temporary $tempRoot -Repos $repo)-join"`n"
    $badRepo=Join-Path $t 'bad-repo';New-Item -ItemType Directory $badRepo|Out-Null;Set-Content (Join-Path $badRepo '.git') 'gitdir: C:/does/not/exist'
    $gitFail=try{& (Join-Path $PSScriptRoot 'Spider.ps1') "ZEBRA-42 $ghToken" -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $badRepo|Out-Null;''}catch{"$_"}
    Assert-That 'file names, archive pointers and git failures are masked' ($paths-match'files: 2'-and$paths-match'-> .*<masked>'-and!$paths.Contains('ghp_')-and$gitFail-match'SPIDER_GIT_FAILED'-and!$gitFail.Contains('ghp_'))
    Assert-That 'query header and session titles are masked' (($masked-join"`n")-match"SPIDER 'ZEBRA-42 <masked>'"-and($masked-join"`n")-match'zebra <masked>'-and!($masked-join"`n").Contains('ghp_'))
    $broken=Join-Path $t 'broken';New-Item -ItemType Directory $broken|Out-Null;Set-Content (Join-Path $broken '.git') 'gitdir: C:/does/not/exist'
    $refused=try{& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $broken|Out-Null;$false}catch{"$_"-match'SPIDER_GIT_FAILED'}
    Assert-That 'an unreadable repository refuses, never reads as no match' $refused
    $archive=Join-Path $t 'ws\sessions\raw';$journal=Join-Path $t 'ws\events\events.jsonl'
    foreach($source in 'sessions','events','repository','temporary'){
        if($source-eq'sessions'){Move-Item -LiteralPath $archive -Destination (Join-Path $t 'saved-raw')}
        if($source-eq'events'){Move-Item -LiteralPath $journal -Destination (Join-Path $t 'saved-journal')}
        if($source-eq'temporary'){Move-Item -LiteralPath $tempRoot -Destination (Join-Path $t 'saved-temporary')}
        try{
            $selectedRepo=if($source-eq'repository'){Join-Path $t 'no-repo'}else{$repo}
            $gap=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $selectedRepo);$gapCode=$LASTEXITCODE;$gapText=$gap-join"`n"
            $named=@{sessions='sessions \(no archive';events='events \(EVENTS_UNAVAILABLE\)';repository='no-repo \(no repository\)';temporary='temporary \(no folder at'}[$source]
            Assert-That "missing $source alone names its coverage gap and exits 3" ($gapCode-eq3-and$gapText-match("SPIDER_COVERAGE: incomplete - "+$named)-and($gapText-split'SPIDER_COVERAGE: incomplete - ')[-1]-notmatch';'-and($source-ne'temporary'-or$gapText-match'(?m)^== temporary: UNAVAILABLE \(no folder at '))
        }finally{
            if($source-eq'sessions'){Move-Item -LiteralPath (Join-Path $t 'saved-raw') -Destination $archive}
            if($source-eq'events'){Move-Item -LiteralPath (Join-Path $t 'saved-journal') -Destination $journal}
            if($source-eq'temporary'){Move-Item -LiteralPath (Join-Path $t 'saved-temporary') -Destination $tempRoot}
        }
    }
    Add-Content $journal '{"torn line'
    $damaged=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ABSENT-97' -Root (Join-Path $t 'ws') -Temporary $tempRoot -Repos $repo);$damagedCode=$LASTEXITCODE;$damagedText=$damaged-join"`n"
    Assert-That 'damaged journal with no matches exits 3 and retains EVENTS_INCOMPLETE' ($damagedCode-eq3-and$damagedText-match'(?m)^== data events: EVENTS_INCOMPLETE: 1 unreadable'-and$damagedText-match'SPIDER_COVERAGE: incomplete - events \(EVENTS_INCOMPLETE\)'-and$damagedText-notmatch'events: none')
}finally{$env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem;$env:USERPROFILE=$previousProfile;if(Test-Path $t){Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}}
if($fail){throw "SPIDER_SELFCHECK_FAILED $fail"};'SPIDER_SELFCHECK PASS'
