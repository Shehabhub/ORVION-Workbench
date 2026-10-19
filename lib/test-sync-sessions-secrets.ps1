# Self-check for Sync-Sessions.ps1's detector: a bounded token and a non-demo JWT count; a demo JWT and a token buried in a blob do not.
. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library
function ConvertTo-B64Url([string]$s){[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($s)).TrimEnd('=').Replace('+','-').Replace('/','_')}
function New-Jwt([string]$Iss){
    $h=ConvertTo-B64Url '{"alg":"HS256","typ":"JWT"}';$p=ConvertTo-B64Url ('{"iss":"'+$Iss+'","role":"service_role","pad":"xxxxxxxxxxxx"}')
    $h+'.'+$p+'.'+('s'*30)
}
$tok='gho_'+('A'*36)
$line="{`"t`":`"$tok`"} {`"k`":`"$(New-Jwt 'supabase')`"} {`"k`":`"$(New-Jwt 'supabase-demo')`"} {`"blob`":`"xx$($tok)yy`"}"
$t=[regex]::Matches($line,$secret).Count;$j=@([regex]::Matches($line,$jwt));$real=@($j|Where-Object{Test-RealJwt $_.Groups[1].Value}).Count
"tokens=$t jwts=$($j.Count) realJwts=$real"
$hits=$t+$real
if($hits-ne2){throw "SECRET_SELFCHECK_FAILED hits=$hits expected=2"};"SECRET_SELFCHECK PASS hits=2"
