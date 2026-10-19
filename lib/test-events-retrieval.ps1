# Retrieval regression: on the real seeded events (fixtures\seed-events.ps1, in a temp root), each task an agent might
# be given must bring back the lesson it needs first. Every probe here once failed or was tuned for; keep them all.
$ErrorActionPreference='Stop'
$t=Join-Path ([IO.Path]::GetTempPath()) "orvion-retrieval-$([guid]::NewGuid().ToString('N').Substring(0,6))";New-Item -ItemType Directory $t|Out-Null
$probes=[ordered]@{
    'write a script that takes a process id and waits until it exits'='ps-reserved-name'  # lost to "exits" until 2-letter terms counted
    'launch three background agents to read the Owner-Review evidence'='agent-stall-unseen-approval'
    'run the Founder generator check from the CRM checkout'='pwsh-file-relative-path'
    'start the Finish for the next contract and tell me how long is left'='watch-run-eta'
    'copy an old sandbox clone into the repo so it is easy to find'='nested-workspace-in-repo'
    'watch_run'='watch-run-eta'  # lost to the stem "watch" until exact words scored double
    'OBJECT_STORE_INCOMPLETE git grep missing object'='native-failure-reads-empty'
    'is my laptop memory too low to run two suites'='host-memory-pressure'  # unseen when the ranking was last tuned
}
$fail=0
try{
    & (Join-Path $PSScriptRoot 'fixtures\seed-events.ps1') -Root $t|Out-Null
    foreach($q in $probes.Keys){
        $top=@(& (Join-Path $PSScriptRoot 'Events.ps1') -Root $t -Find $q -Top 1|Where-Object{$_-match'^\['})[0]
        if($top-match"\] $($probes[$q]):"){"PASS $($probes[$q]) <- $q"}else{$fail++;"FAIL $($probes[$q]) <- $q (got: $top)"}
    }
}finally{[IO.Directory]::Delete($t,$true)}
if($fail){throw "RETRIEVAL_SELFCHECK_FAILED $fail of $($probes.Count)"};"RETRIEVAL_SELFCHECK PASS $($probes.Count)/$($probes.Count)"
