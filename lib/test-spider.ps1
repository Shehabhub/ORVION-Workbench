# Self-check for Spider.ps1 on a temp workspace: it finds the query in a session, an event, a repository file, a commit
# message and a note; it masks a credential value in the snippet; and a repository git cannot read refuses loudly.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-spidercheck-$([guid]::NewGuid().ToString('N').Substring(0,6))"
$previousProfile=$env:USERPROFILE;$env:USERPROFILE=Join-Path $t 'profile'
$savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
$env:GIT_CONFIG_GLOBAL=Join-Path $t 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
function Invoke-Quiet{param([string]$Dir)& git -C $Dir @args 2>&1|Out-Null;if($LASTEXITCODE){throw "git $args failed"}}
try{
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
    $out=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo)
    $text=$out-join"`n"
    Assert-That 'session found with its task' ($text-match'== sessions: 1 mention it'-and$text-match'zebra session')
    Assert-That 'credential value masked in the snippet' ($text-match'API_KEY=<masked>'-and$text-notmatch$tok)
    Assert-That 'event found' ($text-match'zebra-case')
    Assert-That 'repository file and commit found' ($text-match'files: 1 \(a\.md 2\)'-and$text-match'Fix ZEBRA-42')
    Assert-That 'note found' ($text-match'== notes: \d+ files.*README\.md')
    Assert-That 'missing optional Claude root is not created' (!(Test-Path (Join-Path $env:USERPROFILE '.claude')))
    $projects=Join-Path $t 'ws/records/claude-memory'
    [void][IO.Directory]::CreateDirectory($projects)
    $empty=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo)
    Assert-That 'empty optional projects retains workspace notes' (($empty-join' ')-match'README\.md')
    [void][IO.Directory]::CreateDirectory((Join-Path $projects 'no-memory'))
    $memory=Join-Path $projects 'project';[void][IO.Directory]::CreateDirectory($memory)
    $note=Join-Path $memory 'fixture.md';[IO.File]::WriteAllText($note,'ZEBRA-42 memory')
    $present=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo)
    Assert-That 'valid Claude memory is searched and missing project memory is optional' (($present-join' ')-match'fixture\.md')
    $handle=[IO.File]::Open($note,'Open','ReadWrite','None')
    try{$refused=try{& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo|Out-Null;$false}catch{$true}}finally{$handle.Dispose()}
    Assert-That 'present unreadable memory fails instead of becoming no match' $refused
    # Default repositories follow the map's discovery rule: all three repos, never trusted copies or the temporary tree.
    $gh=Join-Path $t 'gh'
    foreach($n in 'CRM','ORVION','ORVION-Workbench','ORVION-trusted-main','ORVION-Workbench-temporary'){$d=Join-Path $gh $n;New-Item -ItemType Directory $d -Force|Out-Null;Invoke-Quiet $d init -q;Set-Content (Join-Path $d 'n.md') 'ZEBRA-42';Invoke-Quiet $d add -A;Invoke-Quiet $d -c user.name=t -c user.email=t@t commit -q -m n}
    $all=@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -GitHub $gh)-join"`n"
    Assert-That 'default search covers CRM, ORVION and ORVION-Workbench, skipping trusted and temporary copies' ($all-match'(?m)^== CRM files: 1'-and$all-match'(?m)^== ORVION files: 1'-and$all-match'(?m)^== ORVION-Workbench files: 1'-and$all-notmatch'== ORVION-trusted-main'-and$all-notmatch'== ORVION-Workbench-temporary')
    # An expected repository that is present but not Git is a named coverage gap, never silently skipped.
    Rename-Item -LiteralPath (Join-Path $gh 'ORVION-Workbench\.git') '.git-hidden'
    try{$noGit=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -GitHub $gh);$noGitCode=$LASTEXITCODE}
    finally{Rename-Item -LiteralPath (Join-Path $gh 'ORVION-Workbench\.git-hidden') '.git'}
    Assert-That 'an expected repository without Git is a coverage gap (exit 3)' ($noGitCode-eq3-and($noGit-join"`n")-match'SPIDER_COVERAGE: incomplete - ORVION-Workbench \(no repository\)')
    # Every rendered field is masked: the query header and a session title, not only snippets.
    $ghToken='ghp_'+('A1b2C3d4E5'*4).Substring(0,36)
    $ixFile=Join-Path $t 'ws\sessions\index.jsonl';$savedIx=[IO.File]::ReadAllText($ixFile)
    [IO.File]::WriteAllText($ixFile,('{"id":"s1","start":"2026-10-01T10:00:00Z","title":"zebra '+$ghToken+'","repo":"CRM","raw":"sessions\\raw\\claude\\p\\s1.jsonl"}'))
    try{$masked=@(& (Join-Path $PSScriptRoot 'Spider.ps1') "ZEBRA-42 $ghToken" -Root (Join-Path $t 'ws') -Repos $repo)+@(& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $repo)}
    finally{[IO.File]::WriteAllText($ixFile,$savedIx)}
    # File names, archive pointers and git failures are rendered too: one mask covers every line.
    Set-Content (Join-Path $repo "$ghToken.md") 'ZEBRA-42';Invoke-Quiet $repo add -A;Invoke-Quiet $repo -c user.name=t -c user.email=t@t commit -q -m 'token-shaped file'
    $tokenWs=Join-Path $t $ghToken;Copy-Item (Join-Path $t 'ws') $tokenWs -Recurse
    $paths=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root $tokenWs -Repos $repo)-join"`n"
    $badRepo=Join-Path $t 'bad-repo';New-Item -ItemType Directory $badRepo|Out-Null;Set-Content (Join-Path $badRepo '.git') 'gitdir: C:/does/not/exist'
    $gitFail=try{& (Join-Path $PSScriptRoot 'Spider.ps1') "ZEBRA-42 $ghToken" -Root (Join-Path $t 'ws') -Repos $badRepo|Out-Null;''}catch{"$_"}
    Assert-That 'file names, archive pointers and git failures are masked' ($paths-match'files: 2'-and$paths-match'-> .*<masked>'-and!$paths.Contains('ghp_')-and$gitFail-match'SPIDER_GIT_FAILED'-and!$gitFail.Contains('ghp_'))
    Assert-That 'query header and session titles are masked' (($masked-join"`n")-match"SPIDER 'ZEBRA-42 <masked>'"-and($masked-join"`n")-match'zebra <masked>'-and!($masked-join"`n").Contains('ghp_'))
    $broken=Join-Path $t 'broken';New-Item -ItemType Directory $broken|Out-Null;Set-Content (Join-Path $broken '.git') 'gitdir: C:/does/not/exist'
    $refused=try{& (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $broken|Out-Null;$false}catch{"$_"-match'SPIDER_GIT_FAILED'}
    Assert-That 'an unreadable repository refuses, never reads as no match' $refused
    $archive=Join-Path $t 'ws\sessions\raw';$journal=Join-Path $t 'ws\events\events.jsonl'
    foreach($source in 'sessions','events','repository'){
        if($source-eq'sessions'){Move-Item -LiteralPath $archive -Destination (Join-Path $t 'saved-raw')}
        if($source-eq'events'){Move-Item -LiteralPath $journal -Destination (Join-Path $t 'saved-journal')}
        try{
            $selectedRepo=if($source-eq'repository'){Join-Path $t 'no-repo'}else{$repo}
            $gap=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ZEBRA-42' -Root (Join-Path $t 'ws') -Repos $selectedRepo);$gapCode=$LASTEXITCODE;$gapText=$gap-join"`n"
            $named=@{sessions='sessions \(no archive';events='events \(EVENTS_UNAVAILABLE\)';repository='no-repo \(no repository\)'}[$source]
            Assert-That "missing $source alone names its coverage gap and exits 3" ($gapCode-eq3-and$gapText-match("SPIDER_COVERAGE: incomplete - "+$named)-and($gapText-split'SPIDER_COVERAGE: incomplete - ')[-1]-notmatch';')
        }finally{
            if($source-eq'sessions'){Move-Item -LiteralPath (Join-Path $t 'saved-raw') -Destination $archive}
            if($source-eq'events'){Move-Item -LiteralPath (Join-Path $t 'saved-journal') -Destination $journal}
        }
    }
    Add-Content $journal '{"torn line'
    $damaged=@(& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'Spider.ps1') 'ABSENT-97' -Root (Join-Path $t 'ws') -Repos $repo);$damagedCode=$LASTEXITCODE;$damagedText=$damaged-join"`n"
    Assert-That 'damaged journal with no matches exits 3 and retains EVENTS_INCOMPLETE' ($damagedCode-eq3-and$damagedText-match'(?m)^== events: EVENTS_INCOMPLETE: 1 unreadable'-and$damagedText-match'SPIDER_COVERAGE: incomplete - events \(EVENTS_INCOMPLETE\)'-and$damagedText-notmatch'events: none')
}finally{$env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem;$env:USERPROFILE=$previousProfile;if(Test-Path $t){Get-ChildItem $t -Recurse -Force -File|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}}
if($fail){throw "SPIDER_SELFCHECK_FAILED $fail"};'SPIDER_SELFCHECK PASS'
