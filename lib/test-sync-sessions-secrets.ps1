# Self-check for the archive's credential detector (Sync-Sessions.ps1 Get-SecretMatch / Hide-Secret): real shapes are found
# by kind, also right after a JSON \n escape; public local-development defaults, code and blob noise are not; masking
# removes every found value.
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'Sync-Sessions.ps1') -Library -Root ([IO.Path]::GetTempPath())
$fail=0;function Assert-That([string]$Name,[bool]$Ok){if($Ok){"PASS $Name"}else{"FAIL $Name";$script:fail++}}
function ConvertTo-B64Url([string]$s){[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($s)).TrimEnd('=').Replace('+','-').Replace('/','_')}
function New-Jwt([string]$Iss){(ConvertTo-B64Url '{"alg":"HS256","typ":"JWT"}')+'.'+(ConvertTo-B64Url ('{"iss":"'+$Iss+'","role":"service_role","pad":"xxxxxxxxxxxx"}'))+'.'+('s'*30)}
function Get-Kinds([string]$Text){@(Get-SecretMatch $Text|ForEach-Object kind)-join','}
$tok='gho_'+('A'*36)
Assert-That 'a GitHub token is found' ((Get-Kinds "{`"t`":`"$tok`"}")-eq'GITHUB_TOKEN')
Assert-That 'a token right after a JSON \n escape is found' ((Get-Kinds ('{"out":"first line\n'+$tok+'"}'))-eq'GITHUB_TOKEN')
Assert-That 'a token buried in a blob is not' ((Get-Kinds "{`"blob`":`"xx$($tok)yy`"}")-eq'')
Assert-That 'a real JWT is found, the supabase-demo one is not' ((Get-Kinds "{`"a`":`"$(New-Jwt 'supabase')`",`"b`":`"$(New-Jwt 'supabase-demo')`"}")-eq'JWT')
Assert-That 'a NAME=value token is found by its name' ((Get-Kinds 'CLAUDE_CODE_MESSAGING_TOKEN=0123456789abcdef0123456789abcdef')-eq'CLAUDE_CODE_MESSAGING_TOKEN')
Assert-That 'a connection-string password is found' ((Get-Kinds 'postgresql://app:S3cr3t!x@db.example:5432/app')-eq'CONNECTION_PASSWORD')
Assert-That 'the local stack password "postgres" is public' ((Get-Kinds 'postgresql://postgres:postgres@127.0.0.1:54322/postgres')-eq'')
Assert-That 'a short password with symbols is found' ((Get-Kinds '"password":"Pa$$w0rd!"')-eq'PASSWORD')
Assert-That 'the literal password "password" is not treated as public' ((Get-Kinds 'password=password')-eq'PASSWORD')
Assert-That 'a real sb_secret key is found, the local default is not' ((Get-Kinds ('{"k":"sb_secret_'+('Q'*30)+'","d":"sb_secret_N7UND0UgjKTVK-Uodkm0Hg_xSvEMPvz"}'))-eq'SUPABASE_SECRET')
Assert-That 'code that names a password is not a password' ((Get-Kinds '$password = Read-Host -AsSecureString')-eq'')
$line="before $tok middle CLAUDE_CODE_MESSAGING_TOKEN=0123456789abcdef0123456789abcdef after"
$m=Hide-Secret $line
Assert-That 'masking removes every found value' ($m-notmatch'gho_A'-and$m-notmatch'0123456789abcdef'-and$m.Contains('<masked>'))
if($fail){throw "SECRET_SELFCHECK_FAILED $fail"};'SECRET_SELFCHECK PASS'
