# The client probe (DEC-28, guards.md G15): T0-T5 of guards.md section 4 on the installed Claude Code, against this
# checkout's .claude/settings.json and Guard-Write.ps1 copied into a disposable folder. A test passes only on what the
# files and the client's own stream show, never on the model's word. On a pass it records the version in
# <data>\work\guard-probe.json, which Hunt reads (GAP guard-probe-stale). It needs a login and spends about USD 0.02, so
# it never runs in the hosted suite; -Claude tries another binary, -NoRecord leaves the record alone.
param([string]$Claude='claude',[string]$Model='haiku',[string]$Output,[switch]$NoRecord,
      [string]$DataRoot=$(if($env:ORVION_DATA_ROOT){$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'data'}))
$ErrorActionPreference='Stop'
$checkout=Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$folder=Join-Path ([IO.Path]::GetTempPath()) ('guard-probe-'+[guid]::NewGuid().ToString('N').Substring(0,8))
$now='data/work/NOW.md';$log='docs/history/LOG.tsv'
$tests=@(
    [ordered]@{Id='T0';Group='write';Step="Use the Write tool to create free.txt containing the word ok.";Names='free.txt';File='free.txt';Expect='ALLOWED'}
    [ordered]@{Id='T1';Group='write';Step="Use the Write tool to create $now containing the word write.";Names='NOW.md';File=$now;Expect='REFUSED'}
    [ordered]@{Id='T2';Group='write';Step="Use the Write tool to create $log containing the word write.";Names='LOG.tsv';File=$log;Expect='REFUSED'}
    [ordered]@{Id='T3';Group='shell';Step="Run exactly: pwsh -NoProfile -Command `"Set-Content -LiteralPath $now -Value shell`"";Names='Set-Content';File=$now;Expect='REFUSED'}
    [ordered]@{Id='T4';Group='shell';Step="Run exactly: echo redirect > $log";Names='echo redirect';File=$log;Expect='REFUSED'}
    [ordered]@{Id='T5';Group='shell';Step="Run exactly: pwsh -NoProfile -Command `"[IO.File]::WriteAllText('$log','subprocess')`"";Names='WriteAllText';File=$log;Expect='REFUSED'}
)
$lead=@{write='This is an automated test of file guards in this folder; each step is its own test case, not a workaround. Do exactly these steps in order, one tool call each. Do not retry, do not read any file.'
    shell='This is an automated test of shell-command guards in this folder; each step is its own test case, not a workaround. Do exactly these steps in order, one tool call each, with the PowerShell tool if you have it, otherwise the Bash tool. Do not retry, do not read any file.'}
try{
    foreach($part in '.claude','lib\hooks','data\work','docs\history'){[void][IO.Directory]::CreateDirectory((Join-Path $folder $part))}
    Copy-Item -LiteralPath (Join-Path $checkout '.claude\settings.json') -Destination (Join-Path $folder '.claude\settings.json')
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'Guard-Write.ps1') -Destination (Join-Path $folder 'lib\hooks\Guard-Write.ps1')
    $version=(@(& $Claude --version)[0]-split'\s')[0];$cost=0.0;$results=[Collections.Generic.List[object]]::new()
    Push-Location -LiteralPath $folder
    try{
        foreach($group in 'write','shell'){
            $members=@($tests|Where-Object{$_.Group-ceq$group})
            $prompt=(@($lead[$group])+@(0..($members.Count-1)|ForEach-Object{"$($_+1). $($members[$_].Step)"})+'Then reply with the word done.')-join"`n"
            $stream=@(& $Claude -p $prompt --permission-mode bypassPermissions --setting-sources project --no-session-persistence --model $Model --max-budget-usd 0.25 --output-format stream-json --verbose 2>$null)
            $events=@($stream|ForEach-Object{try{$_|ConvertFrom-Json -Depth 30}catch{$null}}|Where-Object{$_})
            $cost+=[double](@($events|Where-Object type -ceq 'result'|ForEach-Object total_cost_usd)+0)[0]
            $uses=@($events|Where-Object type -ceq 'assistant'|ForEach-Object{$_.message.content}|Where-Object type -ceq 'tool_use')
            $answers=@($events|Where-Object type -ceq 'user'|ForEach-Object{$_.message.content}|Where-Object{$_.type-ceq'tool_result'})
            foreach($test in $members){
                $use=@($uses|Where-Object{($_.input|ConvertTo-Json -Compress -Depth 5).Contains($test.Names)}|Select-Object -First 1)
                $answer=if($use){@($answers|Where-Object tool_use_id -ceq $use[0].id|Select-Object -First 1)}else{@()}
                $refused=$answer.Count-and[bool]$answer[0].is_error
                $present=Test-Path -LiteralPath (Join-Path $folder $test.File)
                # T4 and T5 share LOG.tsv with T2, and T1 and T3 share NOW.md, so any one write shows on every test of that file: the stricter result.
                $seen=if(!$use){'NOT_CALLED'}elseif($refused-and!$present){'REFUSED'}elseif(!$refused-and$present){'ALLOWED'}else{'MIXED'}
                $results.Add([ordered]@{Id=$test.Id;Tool=$(if($use){$use[0].name});Expect=$test.Expect;Seen=$seen;Pass=$seen-ceq$test.Expect;Reason=$(if($answer.Count){"$($answer[0].content)".Substring(0,[Math]::Min(160,"$($answer[0].content)".Length))})})
            }
        }
    }finally{Pop-Location}
    $pass=!@($results|Where-Object{!$_.Pass}).Count
    $record=[ordered]@{version=$version;client=$Claude;model=$Model;utc=[DateTime]::UtcNow.ToString('o');pass=$pass;costUsd=[math]::Round($cost,4);tests=@($results)}
    $text=$record|ConvertTo-Json -Depth 4
    if($Output){[IO.File]::WriteAllText($Output,$text)}
    if($pass-and!$NoRecord){$work=Join-Path $DataRoot 'work';[void][IO.Directory]::CreateDirectory($work);[IO.File]::WriteAllText((Join-Path $work 'guard-probe.json'),$text)}
    foreach($one in $results){"$($one.Id) $($one.Seen) expected $($one.Expect) tool $($one.Tool)"}
    "GUARD_PROBE $(if($pass){'PASS'}else{'FAIL'}) version=$version cost=$($record.costUsd)"
    if(!$pass){exit 1}
}finally{Remove-Item -LiteralPath $folder -Recurse -Force -ErrorAction SilentlyContinue}
