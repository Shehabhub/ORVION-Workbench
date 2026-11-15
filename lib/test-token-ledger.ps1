# Self-check for Token-Ledger.ps1 in a test root (WORKBENCH_TEST_ROOT, else TEMP), over synthetic transcripts only: the
# figures of one row (turns deduplicated by message id, sidechains excluded, compactions, repeated Read ranges, top file),
# an unchanged transcript kept unparsed, a changed one parsed again, a row whose transcript is gone kept, -Show, the
# default table under the data root, the transcript folder derived from the checkout path under HOME, and a missing
# transcript folder giving no row and no error. No real transcript is read.
param([string]$Ledger=(Join-Path $PSScriptRoot 'Token-Ledger.ps1'))
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'remove-owned.ps1')
$parent=if($env:WORKBENCH_TEST_ROOT){$env:WORKBENCH_TEST_ROOT}else{$env:TEMP}
if(![IO.Path]::IsPathFullyQualified($parent)){throw 'LEDGER_TEST_ROOT_REQUIRED'}
[void][IO.Directory]::CreateDirectory($parent);$parent=(Get-Item -LiteralPath $parent).FullName
$scratch=Join-Path $parent ('tl-'+[guid]::NewGuid().ToString('N').Substring(0,8));[void][IO.Directory]::CreateDirectory($scratch)
$script:passed=0
function Assert-Ledger([bool]$Condition,[string]$What){if(!$Condition){throw "LEDGER_ASSERT: $What"};$script:passed++}
function ConvertTo-Line($Value){$Value|ConvertTo-Json -Depth 10 -Compress}
function Get-Usage([string]$Id,[int]$In,[int]$Read,[int]$Create,$Content=@(),[switch]$Side){
    ConvertTo-Line @{type='assistant';isSidechain=[bool]$Side;message=@{id=$Id;usage=@{input_tokens=$In;cache_read_input_tokens=$Read;cache_creation_input_tokens=$Create};content=@($Content)}}
}
function Get-Read([string]$Id,[string]$Path){@{type='tool_use';id=$Id;name='Read';input=@{file_path=$Path}}}
function Get-Result([string]$Id,[string]$Text){ConvertTo-Line @{type='user';message=@{content=@(@{type='tool_result';tool_use_id=$Id;content=$Text})}}}
function Get-Rows([string]$Table){$rows=@{};foreach($row in Import-Csv -LiteralPath $Table -Delimiter "`t"){$rows[$row.Session]=$row};$rows}
try{
    $project=Join-Path $scratch 'project';[void][IO.Directory]::CreateDirectory($project)
    $a='aaaaaaaa-0000-0000-0000-000000000001';$b='bbbbbbbb-0000-0000-0000-000000000002'
    $lines=@(
        (Get-Usage 'm1' 10 100 0),(Get-Usage 'm1' 10 100 0)  # the same message twice counts once
        (Get-Usage 'm2' 5 200 50 (Get-Read 't1' 'C:\x\a.md')),(Get-Result 't1' 'abcdef')
        (Get-Usage 'm3' 5 300 0 (Get-Read 't2' 'C:\x\a.md')),(Get-Result 't2' 'abcdef')
        (Get-Usage 'm4' 1 200 0 (Get-Read 't3' 'C:\x\b.md')),(Get-Result 't3' 'zz')
        (ConvertTo-Line @{type='system';compactMetadata=@{preTokens=5000}})
        (Get-Usage 'm9' 99999 0 0 -Side)
        '{"usage": not json'
    )
    [IO.File]::WriteAllText((Join-Path $project "$a.jsonl"),($lines-join"`n")+"`n")
    $bFile=Join-Path $project "$b.jsonl";[IO.File]::WriteAllText($bFile,(Get-Usage 'n1' 1 1 1)+"`n")
    $table=Join-Path $scratch 'out\ledger.tsv'
    $out=@(& $Ledger -Project $project -Out $table)
    Assert-Ledger ($out.Count-eq2) "two rows printed: $($out-join' | ')"
    $rows=Get-Rows $table;$row=$rows[$a]
    # A string result is measured as its JSON text: "abcdef" is 8 characters, "zz" 4; the second a.md read repeats 8 of 20.
    foreach($pair in @(@('Turns','4'),@('Turn1','110'),@('Turn10','0'),@('Peak','305'),@('Compacts','1'),@('MedianCompactAt','5000'),@('ReadChars','20'),@('RepeatPct','40'),@('TopFile','a.md'),@('TopReads','2'))){
        Assert-Ledger ($row.($pair[0])-ceq$pair[1]) "$($pair[0]) is $($row.($pair[0])), expected $($pair[1])"
    }
    Assert-Ledger ($rows[$b].Turns-ceq'1'-and$rows[$b].TopFile-ceq'-') 'a session without reads'
    Assert-Ledger ($out[-1]-cmatch'^\d{4}-\d\d-\d\d \d\d:\d\d (aaaaaaaa|bbbbbbbb) turns \d+ t1 \d+ t10 0 peak \d+ compacts \d at \d+ repeat \d+% top \S+ x\d+$') "line shape: $($out[-1])"
    # An unchanged transcript keeps its row unparsed; a grown one is parsed again; a row without a transcript is kept.
    $text=[IO.File]::ReadAllText($table).Replace("$a`t$($row.LastUtc)`t$($row.Bytes)`t4`t","$a`t$($row.LastUtc)`t$($row.Bytes)`t999`t")
    [IO.File]::WriteAllText($table,$text+"cccccccc-gone`t2000-01-01 00:00`t1`t1`t1`t0`t1`t0`t0`t0`t0`t-`t0`n")
    [IO.File]::AppendAllText($bFile,(Get-Usage 'n2' 2 2 2)+"`n")
    $out=@(& $Ledger -Project $project -Out $table -Show 1);$rows=Get-Rows $table
    Assert-Ledger ($rows[$a].Turns-ceq'999') 'an unchanged transcript is not parsed again'
    Assert-Ledger ($rows[$b].Turns-ceq'2') 'a changed transcript is parsed again'
    Assert-Ledger ($rows.ContainsKey('cccccccc-gone')) 'a row whose transcript is gone is kept'
    Assert-Ledger ($out.Count-eq1) "-Show 1 prints one line: $($out-join' | ')"
    Assert-Ledger (!(Test-Path -LiteralPath "$table.tmp")) 'no temporary table left'
    # Defaults: the table under the data root; the transcript folder named after the checkout path under HOME.
    $data=Join-Path $scratch 'data';$out=@(& $Ledger -Project $project -DataRoot $data)
    Assert-Ledger ((Test-Path -LiteralPath ([IO.Path]::Combine($data,'records','token-ledger.tsv')))-and$out.Count-eq2) 'default table under the data root'
    $home2=Join-Path $scratch 'home';$checkout=Join-Path $scratch 'Some Lab\GitHub\ORVION-Workbench'
    $derived=Join-Path $home2 ('.claude\projects\'+($checkout-replace'[^A-Za-z0-9]','-'));[void][IO.Directory]::CreateDirectory($derived)
    Copy-Item -LiteralPath $bFile -Destination $derived
    $saved=$env:USERPROFILE;$env:USERPROFILE=$home2
    try{$out=@(& pwsh -NoProfile -File $Ledger -Checkout $checkout -DataRoot (Join-Path $scratch 'data2') 2>&1)}finally{$env:USERPROFILE=$saved}
    Assert-Ledger ($LASTEXITCODE-eq0-and$out.Count-eq1-and"$out"-cmatch' bbbbbbbb turns 2 ') "derived transcript folder: $out"
    $out=@(& $Ledger -Project (Join-Path $scratch 'absent') -Out (Join-Path $scratch 'empty.tsv'))
    Assert-Ledger ($out.Count-eq0-and([IO.File]::ReadAllText((Join-Path $scratch 'empty.tsv')).StartsWith("Session`t"))) 'a missing transcript folder gives no row and no error'
    "TOKEN_LEDGER_TESTS PASS: $script:passed assertions"
}finally{$null=Remove-OrvionOwnedTree -Path $scratch -AllowedRoots @($parent)}
