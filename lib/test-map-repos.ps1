# Self-check for Map-Repos.ps1 (Interactive repository map v1): disposable temp repositories only.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) ('orvion-map-test-'+[guid]::NewGuid().ToString('N'));$gh=Join-Path $t 'GitHub';$out=Join-Path $t 'out'
[void][IO.Directory]::CreateDirectory($gh);[void][IO.Directory]::CreateDirectory($out);$fail=0
$savedGitGlobal=$env:GIT_CONFIG_GLOBAL;$savedGitNoSystem=$env:GIT_CONFIG_NOSYSTEM
$env:GIT_CONFIG_GLOBAL=Join-Path $t 'fixture.gitconfig';$env:GIT_CONFIG_NOSYSTEM='1'
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
    [void](New-Repo 'ORVION-Workbench-temporary' @{'README.md'="# disposable`n"})
    [void](New-Repo 'RepoA-trusted-main' @{'README.md'="# copy`n"})
    $script=Join-Path $PSScriptRoot 'Map-Repos.ps1'
    $o=@(& pwsh -NoProfile -File $script -GitHub $gh -Out $out 2>&1);if($LASTEXITCODE){throw ('MAP_RUN_FAILED: '+($o-join' '))}
    $m=Get-Content (Join-Path $out 'ai-map.json') -Raw|ConvertFrom-Json
    function Has-Edge([string]$From,[string]$To,[string]$Kind){@($m.edges|Where-Object{$_.from-ceq$From-and$_.to-ceq$To-and$_.kind-ceq$Kind}).Count-ge1}
    Assert-That 'discovers repositories, skips trusted and temporary copies, reports unborn and broken ones without failing' ((@($m.repos.name)-join',')-ceq'RepoA,RepoB,RepoD'-and@($m.problems|Where-Object{$_.repo-ceq'RepoD'-and$_.problem-match'no commits'}).Count-eq1-and@($m.problems|Where-Object{$_.repo-ceq'RepoE'}).Count-eq1)
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
}finally{$env:GIT_CONFIG_GLOBAL=$savedGitGlobal;$env:GIT_CONFIG_NOSYSTEM=$savedGitNoSystem;Get-ChildItem $t -Recurse -Force -File -ErrorAction SilentlyContinue|ForEach-Object{$_.Attributes='Normal'};[IO.Directory]::Delete($t,$true)}
if($fail){throw "MAP_REPOS_SELFCHECK_FAILED $fail"};'MAP_REPOS_SELFCHECK PASS'
