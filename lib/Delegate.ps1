# The delegation road of the improvement loop: turn an open or recurring event into a bounded investigation another
# agent can run cold, and get its verdict back into the event log.
#   Delegate.ps1 -Pattern <id> -Question '<what to prove or disprove>' [-Query '<phrase for the spider>'] [-Mode sandbox]
#       writes work\delegations\<UTC>-<pattern>\BRIEF.md (question, what is known, authority, method, report format),
#       records the delegation as an event, and prints how to launch it (a background agent: the hook adds the watchdog)
#   Delegate.ps1 -Report <delegation folder> -Reply <file holding the delegate's reply>
#       the return road: saves the reply as REPORT.md (never overwrites), reads its VERDICT line and records the
#       verdict as the pattern's next event, owned again by the delegating agent (Coordinator.ps1 then holds it)
#   Delegate.ps1 -List   every delegation, newest first, with its verdict once REPORT.md exists
#   Delegate.ps1 -CodexBrief <brief> -Clone <temporary\cx\...> -Workstream W<NN> [-ResumeSession <id>] [-OutDir <data/records/new>]
#       runs one Codex relay session (fresh, or the workstream's own resumed: DEC-21) in a clone under temporary\cx, confined
#       by MXC to the clone and its scratch run folder (DEC-20), refused if MXC is unavailable, with TEMP/TMP set to that folder at launch (DEC-20 names what MXC does to them), and
#       compares the watched places before and after (exit 4 + a failure event on any change or unreadable snapshot)
# Authority never grows by delegation: readonly = read the repositories, write only the delegation folder; sandbox =
# also experiment in disposable copies under the system temp folder. Never a commit, push, release, credential or
# Owner-Review edit. The verdict is evidence for the delegating agent to verify, not a decision. -ReadRoots narrows the
# brief's read authority to the task; that is guidance to the delegate, not OS enforcement.
[CmdletBinding(DefaultParameterSetName='brief')]
param([Parameter(ParameterSetName='brief',Mandatory)][ValidatePattern('^[a-z0-9]+(-[a-z0-9]+)*$')][string]$Pattern,
      [Parameter(ParameterSetName='brief',Mandatory)][string]$Question,
      [Parameter(ParameterSetName='brief')][string]$Query='',
      [Parameter(ParameterSetName='brief')][ValidateSet('readonly','sandbox')][string]$Mode='readonly',
      [Parameter(ParameterSetName='brief')][int]$Minutes=30,
      [Parameter(ParameterSetName='brief')][string[]]$ReadRoots,
      [Parameter(ParameterSetName='codex',Mandatory)][string]$CodexBrief,
      [Parameter(ParameterSetName='codex',Mandatory)][string]$Clone,
      [Parameter(ParameterSetName='codex',Mandatory)][ValidatePattern('^W\d{2,}$')][string]$Workstream,
      [Parameter(ParameterSetName='codex')][ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._:-]*$')][string]$ResumeSession,
      [Parameter(ParameterSetName='codex')][ValidateSet('low','medium','high','xhigh')][string]$Effort='high',  # DEC-18
      [Parameter(ParameterSetName='codex')][Alias('Model')][ValidateSet('sol','terra')][string]$Family,
      [Parameter(ParameterSetName='codex')][switch]$Research,
      [Parameter(ParameterSetName='codex')][switch]$IsolatedVerification,
      [Parameter(ParameterSetName='codex')][string]$ModelCache,
      [Parameter(ParameterSetName='codex')][string]$OutDir,
      [Parameter(ParameterSetName='codex')][ValidateRange(1,120)][int]$TimeoutMinutes=20,
      [Parameter(ParameterSetName='codex')][string]$Relay,
      [Parameter(ParameterSetName='codex')][string[]]$Watch,
      [Parameter(ParameterSetName='list',Mandatory)][switch]$List,
      [Parameter(ParameterSetName='report',Mandatory)][string]$Report,
      [Parameter(ParameterSetName='report',Mandatory)][string]$Reply,
      [string]$Root=$(if($env:ORVION_DATA_ROOT){if(![IO.Path]::IsPathFullyQualified($env:ORVION_DATA_ROOT)){throw 'ORVION_DATA_ROOT_NOT_ABSOLUTE'};$env:ORVION_DATA_ROOT}else{Join-Path (Split-Path ($PSScriptRoot-replace'[\\/]hooks$','') -Parent) 'data'}))
$ErrorActionPreference='Stop'
# DEC-19: no internet for Codex; the research profile is retired (DEC-16).
if($CodexBrief-and$Research){throw 'CODEX_RESEARCH_REFUSED: no internet for Codex (DEC-19); research belongs to Claude main (DEC-16)'}
if(!$PSBoundParameters.ContainsKey('Root')-and!$env:ORVION_DATA_ROOT-and!(Test-Path -LiteralPath (Join-Path $Root 'events') -PathType Container)){
    if($List){'DELEGATIONS_UNAVAILABLE: ORVION_DATA_ROOT_UNAVAILABLE';exit 3};throw 'ORVION_DATA_ROOT_UNAVAILABLE'
}
. (Join-Path $PSScriptRoot 'workspace-layout.ps1')
$temporaryRoot=Initialize-OrvionTemporaryRoot -Checkout (Split-Path $PSScriptRoot -Parent)
$base=Join-Path $Root 'work\delegations';$ev=Join-Path $PSScriptRoot 'Events.ps1'

if($CodexBrief){
    # DEC-20: workspace-write under MXC, writable roots the clone and the run folder only, passed per run; hosted search and command network off (DEC-19).
    function Get-CodexSafePath([string]$Path){
        if(![IO.Path]::IsPathFullyQualified($Path)-or$Path-match'^[\\/]{2}'-or
           $Path-match'(^|[\\/])\.{1,2}([\\/]|$)|[\x00-\x1f"<>|?*%!^]' -or
           $Path-match'(?i)(^|[\\/])(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(\.[^\\/]*)?([\\/]|$)' -or
           ($Path-replace'^[A-Za-z]:','')-match':' -or $Path-match'[^\\/][. ]([\\/]|$)'){throw 'CODEX_PATH_REFUSED: absolute local path without traversal or ambiguous components required'}
        $full=[IO.Path]::GetFullPath($Path).TrimEnd('\','/')
        for($cursor=$full;$cursor;$cursor=Split-Path $cursor -Parent){
            $item=Get-Item -LiteralPath $cursor -Force -ErrorAction SilentlyContinue
            if($item-and($item.Attributes-band[IO.FileAttributes]::ReparsePoint)){throw 'CODEX_REPARSE_REFUSED'}
        }
        $full
    }
    function Test-CodexWithin([string]$Path,[string]$Parent){
        $Path.Equals($Parent,[StringComparison]::OrdinalIgnoreCase)-or$Path.StartsWith($Parent+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)
    }
    function Test-CodexOverlap([string]$A,[string]$B){(Test-CodexWithin $A $B)-or(Test-CodexWithin $B $A)}
    $briefFile=Get-CodexSafePath $CodexBrief;$cloneDir=Get-CodexSafePath $Clone
    if(!(Test-Path -LiteralPath $briefFile -PathType Leaf)){throw 'CODEX_BRIEF_MISSING'}
    # The template of docs/RUNBOOK.md section 12 (DEC-21): at most 8 KB, every section present and filled, evidence at most 60 lines.
    if((Get-Item -LiteralPath $briefFile).Length-gt8KB){throw 'CODEX_BRIEF_REFUSED: over 8 KB'}
    $briefSections=[ordered]@{};$briefSection=$null
    $briefHeadings='Objective','Why delegated','Scope','Authority','Embedded evidence','Read only if needed','Write boundary','Deliverables','Acceptance','Stop conditions','Return format'
    foreach($line in [IO.File]::ReadAllLines($briefFile)){
        if($line-match'^## (.+?)\s*$'-and$briefHeadings-ccontains$Matches[1]){
            $briefSection=$Matches[1];if($briefSections.Contains($briefSection)){throw "CODEX_BRIEF_REFUSED: section '$briefSection' twice"}
            $briefSections[$briefSection]=[Collections.Generic.List[string]]::new()
        }elseif($briefSection-and$line.Trim()){$briefSections[$briefSection].Add($line)}
    }
    foreach($heading in $briefHeadings){if(!$briefSections.Contains($heading)-or!$briefSections[$heading].Count){throw "CODEX_BRIEF_REFUSED: section '$heading' missing or empty"}}
    $briefEvidenceLines=$briefSections['Embedded evidence'].Count
    if($briefEvidenceLines-gt60){throw "CODEX_BRIEF_REFUSED: embedded evidence holds $briefEvidenceLines lines, the limit is 60"}
    $temporaryRoot=Get-CodexSafePath $temporaryRoot
    $cxRoot=Join-Path $temporaryRoot 'cx'
    if(!(Test-CodexWithin $cloneDir $cxRoot)-or$cloneDir-eq$cxRoot-or!(Test-Path -LiteralPath (Join-Path $cloneDir '.git') -PathType Container)){throw 'CODEX_CLONE_REFUSED: independent git clone under temporary/cx required'}
    $common=@(& git -C $cloneDir rev-parse --path-format=absolute --git-common-dir 2>$null)
    if($LASTEXITCODE-or$common.Count-ne1-or(Get-CodexSafePath $common[0])-ine(Join-Path $cloneDir '.git')){throw 'CODEX_CLONE_REFUSED: shared git storage'}
    if(Test-Path -LiteralPath (Join-Path $cloneDir '.git/objects/info/alternates')){throw 'CODEX_CLONE_REFUSED: shared objects'}
    foreach($remoteName in @(& git -C $cloneDir remote 2>$null)){
        $pushTargets=@(& git -C $cloneDir remote get-url --push --all $remoteName 2>$null)
        if($LASTEXITCODE-or!$pushTargets.Count-or@($pushTargets|Where-Object{$_-cne'DISABLED'}).Count){throw 'CODEX_CLONE_REFUSED: configured push must be DISABLED'}
    }
    if($LASTEXITCODE){throw 'CODEX_CLONE_REFUSED: unreadable remotes'}
    $sourceRoot=Get-CodexSafePath (Split-Path $PSScriptRoot -Parent)
    $dataRoot=Get-CodexSafePath $Root;$evidenceRoot=Join-Path $dataRoot 'records'
    if((Test-CodexOverlap $dataRoot $sourceRoot)-or(Test-CodexOverlap $dataRoot $temporaryRoot)-or
       $dataRoot-match'(?i)(^|[\\/])(\.codex|\.claude|credentials|sessions|records|events)([\\/]|$)'){throw 'CODEX_OUTPUT_ROOT_REFUSED: data root overlaps source, temporary storage or private subtrees'}
    for($cursor=$dataRoot;$cursor;$cursor=Split-Path $cursor -Parent){if(Test-Path -LiteralPath (Join-Path $cursor '.git')){throw 'CODEX_OUTPUT_ROOT_REFUSED: Git source ancestor'}}
    $localRelay=Get-CodexSafePath (Join-Path $PSScriptRoot 'codex-relay.mjs')
    if($Relay-and(Get-CodexSafePath $Relay)-ine$localRelay){throw 'CODEX_RELAY_OVERRIDE_REFUSED: fixed local relay required'}
    $Relay=$localRelay
    if(!(Test-Path -LiteralPath $Relay -PathType Leaf)){throw 'CODEX_RELAY_MISSING'}
    $requiredFamily='sol'
    if(!$Family){$Family=$requiredFamily};if($Family-ne$requiredFamily){throw "CODEX_MODEL_FAMILY_REFUSED: this profile requires $requiredFamily"}
    # Launcher only: read the CLI's existing availability cache, never give its path/content to the delegate.
    if(!$ModelCache){$cacheHome=if($env:CODEX_HOME){$env:CODEX_HOME}else{Join-Path $env:USERPROFILE '.codex'};$ModelCache=Join-Path $cacheHome 'models_cache.json'}
    $ModelCache=Get-CodexSafePath $ModelCache
    try{
        # PS 7.6 otherwise converts ISO strings to DateTime before timezone validation.
        $cache=Get-Content -LiteralPath $ModelCache -Raw|ConvertFrom-Json -DateKind String -ErrorAction Stop
        if($cache.fetched_at-isnot[string]-or$cache.fetched_at-notmatch'(Z|[+-]\d{2}:\d{2})\z'){throw 'timestamp lacks explicit timezone'}
        $fetched=[DateTimeOffset]::Parse($cache.fetched_at,[Globalization.CultureInfo]::InvariantCulture)
        if($fetched-lt[DateTimeOffset]::UtcNow.AddHours(-24)-or$fetched-gt[DateTimeOffset]::UtcNow.AddMinutes(5)-or!$cache.models-or$cache.client_version-notmatch'\A\d+\.\d+\.\d+\z'){throw 'stale or incomplete'}
        $candidates=@();$slugs=@{}
        foreach($entry in $cache.models){
            if($entry.slug-isnot[string]-or$entry.slug-notmatch'\A[a-zA-Z0-9][a-zA-Z0-9._:/-]*\z'-or$slugs.ContainsKey($entry.slug)){throw 'unsafe or duplicate model'}
            $slugs[$entry.slug]=$true
            if($entry.visibility-ceq'list'-and$entry.slug-match("(^|-)"+$Family+'(-|$)')){
                if($entry.slug-cnotmatch('\Agpt-(?<version>(?:0|[1-9]\d*)(?:\.(?:0|[1-9]\d*)){0,2})-'+$Family+'\z')){throw 'unsupported family identifier'}
                $numeric=$Matches.version;$number=[version]$(if($numeric.Contains('.')){$numeric}else{"$numeric.0"})
                if(@($entry.supported_reasoning_levels|Where-Object effort -CEQ $Effort).Count){$candidates+= [pscustomobject]@{Id=$entry.slug;Version=$number}}
            }
        }
        if(!$candidates.Count){throw 'no available compatible family member'}
        $Model=($candidates|Sort-Object Version -Descending|Select-Object -First 1).Id
    }catch{throw "CODEX_MODEL_AVAILABILITY_UNVERIFIED: current valid cache must contain visible $Family supporting $Effort; no fallback or refresh. $($_.Exception.Message)"}
    # One Codex session per workstream (DEC-21): a resume names the session this workstream recorded; a second fresh one is refused.
    $sessionFile=Get-CodexSafePath (Join-Path $temporaryRoot "sb/$Workstream/codex/session.json")
    $knownSession=if(Test-Path -LiteralPath $sessionFile){(Get-Content -LiteralPath $sessionFile -Raw|ConvertFrom-Json).SessionId}
    if($ResumeSession-and$knownSession-cne$ResumeSession){throw "CODEX_SESSION_REFUSED: $Workstream recorded session '$knownSession', not '$ResumeSession'"}
    if(!$ResumeSession-and$knownSession){throw "CODEX_SESSION_REFUSED: $Workstream already holds session '$knownSession'; use -ResumeSession"}
    $run="$Workstream-$([DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))-codex-$([guid]::NewGuid().ToString('N').Substring(0,8))"
    $scratch=Get-CodexSafePath (Join-Path $temporaryRoot "scratch/$run")
    $logs=Get-CodexSafePath (Join-Path $temporaryRoot "codex-relay-logs/$run")
    if($OutDir){
        $logs=Get-CodexSafePath $OutDir
        if(!(Test-CodexWithin $logs $evidenceRoot)-or$logs-eq$evidenceRoot-or(Test-CodexOverlap $logs $cloneDir)-or(Test-CodexOverlap $logs $scratch)-or
           [IO.Path]::GetRelativePath($evidenceRoot,$logs)-match'(?i)(^|[\\/])(\.git|\.codex|\.claude|credentials|sessions|events)([\\/]|$)'){throw 'CODEX_OUTPUT_SCOPE_REFUSED: fresh records child of the bound data root required; no private session/credential subtrees'}
        for($cursor=$logs;$cursor;$cursor=Split-Path $cursor -Parent){if(Test-Path -LiteralPath (Join-Path $cursor '.git')){throw 'CODEX_OUTPUT_SCOPE_REFUSED: Git source ancestor'}}
    }
    if((Test-Path -LiteralPath $logs)-or(Test-Path -LiteralPath $scratch)){throw 'CODEX_OUTPUT_COLLISION'}
    [void](New-Item -ItemType Directory -Path $scratch -ErrorAction Stop)
    [void](New-Item -ItemType Directory -Path $logs -ErrorAction Stop)
    $prefixed=Join-Path $scratch 'BRIEF.md'
    $advisory=@'
DELEGATE ARRIVAL OVERRIDE (overrides the global ~/.codex/AGENTS.md lines; DEC-20): skip global arrival, Pulse, Events, Spider and private records. Do not read real sessions or events, ~/.codex, ~/.claude, ORVION-Owner-Tools or credentials: the sandbox confines writes, not reads, so this rule is yours to keep. Do not read AGENTS.md; this brief embeds what applies, and what it embeds you do not read again. Writes outside the clone and the run folder are refused, .git stays read-only, and there is no internet: hosted search and command network are off. Permanent evidence belongs to the launcher, never delegate tools. No delegation, agent creation, commit/push/reset or full tests/Finish. Memories and multi_agent are requested off; spawning tools may remain exposed. Never experiment with spawning; observed unauthorized creation fails/escalates. End with at most 40 lines in the seven HANDOFF fields, each label at the start of a line: INHERITED, PROVEN, UNPROVEN, CHANGED, REMAINING, DO NOT TOUCH, NEXT.

'@
    $runProfile='engineering';$hostedSearch='disabled';$sandbox='workspace-write'
    $roots="Clone: $cloneDir`nRun folder (your deliverables; set TEMP and TMP here before any temporary file, since inside MXC the default TEMP can be the container's own folder): $scratch`n`n"
    [IO.File]::WriteAllText($prefixed,$advisory+$roots+[IO.File]::ReadAllText($briefFile))
    # the temporary root always sits beside the checkouts, wherever this script runs from
    if(!$Watch){$gitHub=Split-Path $temporaryRoot -Parent;$Watch=@("$env:SystemDrive\",$env:USERPROFILE,$gitHub)+@(Get-ChildItem -LiteralPath $gitHub -Directory|Where-Object{Test-Path -LiteralPath (Join-Path $_.FullName '.git')}|ForEach-Object FullName)}
    function Get-CodexWorld{foreach($place in $Watch){
        if(Test-Path -LiteralPath (Join-Path $place '.git')){
            $head=@(& git -C $place rev-parse HEAD 2>$null);$headCode=$LASTEXITCODE
            # Git's paths are UTF-8 whatever the caller's console says: under CP437 a non-ASCII path decodes to one that does not exist, its hash stays empty and a rewrite goes unseen.
            $savedEncoding=[Console]::OutputEncoding;[Console]::OutputEncoding=[Text.UTF8Encoding]::new($false)
            try{$state=@(& git -C $place -c core.quotepath=false status --porcelain=v1 -z --untracked-files=all 2>$null)}finally{[Console]::OutputEncoding=$savedEncoding}
            if($headCode-or$LASTEXITCODE){throw "CODEX_WATCH_UNREADABLE: $place"};"$place|git|$head"
            $stateEntries=($state-join"`n").Split([char]0)
            for($entryIndex=0;$entryIndex-lt$stateEntries.Count;$entryIndex++){
                $line=$stateEntries[$entryIndex];if(!$line){continue}
                if($line.Length-lt4){throw 'CODEX_WATCH_UNREADABLE: invalid Git status'}
                $file=Get-CodexSafePath (Join-Path $place $line.Substring(3))
                "$place|$line|$(if(Test-Path -LiteralPath $file -PathType Leaf){(Get-FileHash -LiteralPath $file).Hash})"
                # In porcelain -z a rename/copy destination comes first, followed by the raw source path.
                if($line.Substring(0,2)-match'[RC]'){
                    $entryIndex++;if($entryIndex-ge$stateEntries.Count-or!$stateEntries[$entryIndex]){throw 'CODEX_WATCH_UNREADABLE: missing rename source'}
                    "$place|rename-source|$($stateEntries[$entryIndex])"
                }
            }
        }else{"$place|.";Get-ChildItem -LiteralPath $place -Force -Name -ErrorAction Stop|ForEach-Object{"$place|$_"}}  # the marker keeps an empty folder comparable
    }}
    # Both expected output roots exist before the snapshot. The existing tripwire is detection, not confinement.
    $watchUnreadable=$false
    $before=try{@(Get-CodexWorld)}catch{$watchUnreadable=$true;@("UNREADABLE|$($_.Exception.Message)")}
    $record=[ordered]@{Schema=1;Scope=$(if($IsolatedVerification){'isolated-verification'}else{'existing-delegation'});Profile=$runProfile;Workstream=$Workstream;ResumeSession=$ResumeSession;BriefBytes=(Get-Item -LiteralPath $briefFile).Length;BriefEvidenceLines=$briefEvidenceLines;Qualification='NOT ESTABLISHED by launcher';Family=$Family;SelectedModel=$Model;RequestedEffort=$Effort;ActualModel='UNVERIFIED: orchestrator must corroborate runtime';ActualEffort='UNVERIFIED: orchestrator must corroborate runtime';CacheSHA256=(Get-FileHash -LiteralPath $ModelCache).Hash;CacheClientVersion=$cache.client_version;RelaySHA256=(Get-FileHash -LiteralPath $Relay).Hash;InputBriefSHA256=(Get-FileHash -LiteralPath $briefFile).Hash;HostedSearch=$hostedSearch;Sandbox=$sandbox;WritableRoots=@($cloneDir,$scratch);CommandNetwork='off';ToolCatalog='UNPROVEN';SpawnPrevention='UNPROVEN';DurablePath=$logs}
    $savedTemp=$env:TEMP;$savedTmp=$env:TMP;$env:TEMP=$scratch;$env:TMP=$scratch
    $relayCode=5;$launchError='';$resumeArgument=if($ResumeSession){@('--session',$ResumeSession)}else{@()}
    try{if(!$watchUnreadable){& node $Relay --orvion-profile $runProfile --orvion-cache-version $cache.client_version --orvion-run-folder $scratch @resumeArgument --brief $prefixed --cd $cloneDir --sandbox $sandbox --ignore-user-config --clean-env --web-search $hostedSearch --model $Model --effort $Effort --timeout "${TimeoutMinutes}m" --out-dir $logs;$relayCode=$LASTEXITCODE}else{$launchError='CODEX_WATCH_UNREADABLE: no dispatch'}}
    catch{$launchError=$_.Exception.Message}
    finally{$env:TEMP=$savedTemp;$env:TMP=$savedTmp}
    $after=try{@(Get-CodexWorld)}catch{@("UNREADABLE|$($_.Exception.Message)")}
    $changed=@(Compare-Object $before $after|ForEach-Object{"$($_.SideIndicator) $($_.InputObject)"})
    if($watchUnreadable){$changed+= 'UNREADABLE|initial watch; no dispatch'}
    $controlFailure='';$controlFailures=[Collections.Generic.List[string]]::new();$spawnObserved=$false
    "CODEX_EVIDENCE: $logs"
    function Get-CodexEventItems($Value){
        # Only native event envelopes carry actions. Arguments, results, report text and
        # inventory entries are data even when they contain objects with a type field.
        if($Value-is[System.Collections.IDictionary]){
            $Value
            if($Value.type-in@('item.started','item.updated','item.completed')-and$Value.item-is[System.Collections.IDictionary]){$Value.item}
        }
    }
    function Test-CodexSpawn($Value){
        foreach($part in @(Get-CodexEventItems $Value)){
            if($part.type-in@('agent_spawn','spawn_agent','spawnAgent')){return $true}
            if($part.type-in@('collab_tool_call','tool_call','mcp_tool_call','function_call')){
                foreach($key in 'tool','name','recipient_name'){
                    if($part[$key]-is[string]-and$part[$key]-match'(^|[./])(spawn_agent|agent_spawn|spawnAgent)$'){return $true}
                }
            }
        }
        return $false
    }
    function Get-CodexRuntimeFailure($Value){
        foreach($part in @(Get-CodexEventItems $Value)){
            if($part.type-in@('warning','error')){
                if(($part.message,$part.text-join' ')-match'(?i)ignored|unknown|unsupported|unrecognized|invalid.{0,40}(config|feature)'){return 'runtime reports unsupported controls'}
                if($part.type-eq'error'){return 'runtime reports error'}
            }
            if($part.type-eq'turn.failed'){return 'runtime reports turn.failed'}
            if($part.type-in@('item.started','item.updated','item.completed')){
                if($part.item-isnot[System.Collections.IDictionary]){return 'invalid item event shape'}
                if($part.item.type-isnot[string]-or[string]::IsNullOrWhiteSpace($part.item.type)){return 'invalid item event type'}
            }
        }
        return ''
    }
    try{
        foreach($artifact in 'result.json','stderr.txt','events.jsonl','native-controls.json'){$null=Get-CodexSafePath (Join-Path $logs $artifact)}
        $result=Get-Content -LiteralPath (Join-Path $logs 'result.json') -Raw|ConvertFrom-Json
        if($result.model-cne$Model-or$result.effort-cne$Effort-or$result.webSearch-cne$hostedSearch-or$result.sandbox-cne$sandbox-or$result.orvionProfile-cne$runProfile-or!$result.ignoreUserConfig){throw 'relay metadata mismatch'}
        if($result.codexVersion-cne("codex-cli "+$cache.client_version)){throw 'cache/CLI version mismatch'}
        if($result.status-ceq'controls_unverified'){throw $result.error}
        if($ResumeSession-and$result.threadId-and$result.threadId-cne$ResumeSession){throw 'resume returned another session'}
        $diagnostic=Get-Content -LiteralPath (Join-Path $logs 'stderr.txt') -Raw
        if($diagnostic-match'(?i)ignored|unknown (config|feature)|unsupported|unrecognized|invalid.{0,40}(config|feature)'){throw 'ignored/unsupported controls in diagnostics'}
        if($result.status-eq'completed'-and($relayCode-ne0-or$result.exitCode-ne0)){throw 'relay completion/exit mismatch'}
        if($result.status-eq'completed'){
            $controls=Get-Content -LiteralPath (Join-Path $logs 'native-controls.json') -Raw|ConvertFrom-Json -ErrorAction Stop
            $requiredFeatures='memories','multi_agent'
            if($controls.exitCode-ne0-or$controls.error-or!$controls.featureList-or$controls.diagnostics-match'(?i)ignored|unknown|unsupported|unrecognized|invalid'){throw 'invalid native feature evidence'}
            foreach($featureName in $requiredFeatures){
                $featureLines=@($controls.featureList-split'\r?\n'|Where-Object{$_-match('^'+$featureName+'\s')})
                if($featureLines.Count-ne1-or$featureLines[0]-notmatch'\sfalse\s*$'){throw 'missing or ambiguous native feature evidence'}
            }
        }
    }catch{$controlFailure=$_.Exception.Message;$controlFailures.Add($controlFailure)}
    try{
        $null=Get-CodexSafePath (Join-Path $logs 'events.jsonl')
        $eventCount=0
        foreach($line in [IO.File]::ReadLines((Join-Path $logs 'events.jsonl'))){
            try{$runtimeEvent=$line|ConvertFrom-Json -AsHashtable -ErrorAction Stop}catch{$controlFailure='unreadable event catalog';$controlFailures.Add($controlFailure);continue}
            if($runtimeEvent-isnot[System.Collections.IDictionary]){$controlFailure='invalid event shape';$controlFailures.Add($controlFailure);continue}
            if(!$runtimeEvent.type-or$runtimeEvent.type-isnot[string]){$controlFailure='missing event type';$controlFailures.Add($controlFailure);continue}
            $eventCount++
            if(Test-CodexSpawn $runtimeEvent){$spawnObserved=$true}
            $runtimeFailure=Get-CodexRuntimeFailure $runtimeEvent
            if($runtimeFailure){$controlFailure=$runtimeFailure;$controlFailures.Add($controlFailure)}
        }
        if($result.status-eq'completed'-and!$eventCount){if(!$controlFailure){$controlFailure='missing runtime events'};$controlFailures.Add('missing runtime events')}
    }catch{$controlFailure=$_.Exception.Message;$controlFailures.Add($controlFailure)}
    $record['RelayExit']=$relayCode;$record['LaunchError']=$launchError;$record['ControlFailure']=$controlFailure;$record['ControlFailures']=@($controlFailures);$record['ObservedUnauthorizedSpawn']=$spawnObserved;$record['TripwireChanges']=$changed
    $null=Get-CodexSafePath (Join-Path $logs 'launcher.json')
    $launcherStream=[IO.File]::Open((Join-Path $logs 'launcher.json'),[IO.FileMode]::CreateNew,[IO.FileAccess]::Write)
    try{$bytes=[Text.Encoding]::UTF8.GetBytes(($record|ConvertTo-Json -Depth 6)+"`n");$launcherStream.Write($bytes,0,$bytes.Length)}finally{$launcherStream.Dispose()}
    # Hash every retained artifact, refusing redirected output trees; never overwrite the manifest.
    $hashes=@();$pending=[Collections.Generic.Queue[string]]::new();$pending.Enqueue($logs)
    while($pending.Count){$folder=$pending.Dequeue();$null=Get-CodexSafePath $folder
        foreach($item in Get-ChildItem -LiteralPath $folder -Force){
            $null=Get-CodexSafePath $item.FullName
            if($item.PSIsContainer){$pending.Enqueue($item.FullName)}else{$hashes+="$((Get-FileHash -LiteralPath $item.FullName).Hash)  $([IO.Path]::GetRelativePath($logs,$item.FullName).Replace('\','/'))"}
        }
    }
    $manifest=[IO.File]::Open((Join-Path $logs 'SHA256SUMS'),[IO.FileMode]::CreateNew,[IO.FileAccess]::Write)
    try{$bytes=[Text.Encoding]::UTF8.GetBytes((($hashes|Sort-Object)-join"`n")+"`n");$manifest.Write($bytes,0,$bytes.Length)}finally{$manifest.Dispose()}
    if($changed){
        $null=& $ev -Root $Root -Add -Pattern codex-outside-write -Source delegate-codex -Category failure -Status open -Summary "Codex run $run changed watched places: $(($changed|Select-Object -First 5)-join'; ')" -Evidence $logs -Owner agent -Action 'inspect what wrote it before any further Codex run; remove only after inspection'
        "CODEX_TRIPWIRE: $($changed.Count) change(s) outside the clone and scratch";$changed;exit 4
    }
    if($spawnObserved){'CODEX_UNAUTHORIZED_CREATION: observed spawn; stop and escalate to owner, no further run';exit 5}
    if($controlFailure-or$launchError){"CODEX_CONTROLS_UNVERIFIED: $controlFailure $launchError; stop and escalate";exit 5}
    if($result.threadId-and!$relayCode){
        [void][IO.Directory]::CreateDirectory((Split-Path $sessionFile -Parent))
        [IO.File]::WriteAllText($sessionFile,([ordered]@{Workstream=$Workstream;SessionId=$result.threadId;Model=$Model;Effort=$Effort;LastRun=$run}|ConvertTo-Json)+"`n")
    }
    # L19: the seven HANDOFF fields in at most 40 lines; Claude reads this summary, never the transcript.
    if($result.status-ceq'completed'-and!$relayCode){
        $final=@(if($result.finalPath){[IO.File]::ReadAllLines($result.finalPath)})
        $missingFields=@('INHERITED','PROVEN','UNPROVEN','CHANGED','REMAINING','DO NOT TOUCH','NEXT'|Where-Object{!@($final-cmatch"^\W*$_\b").Count})
        if($final.Count-gt40-or$missingFields.Count){"CODEX_RETURN_FORMAT: $($final.Count) lines, missing $($missingFields-join', '); read $logs";exit 6}
    }
    "CODEX_DONE relay exit $relayCode; scratch $scratch; logs $logs";exit $relayCode}

if($Report){
    $dir=(Resolve-Path -LiteralPath $Report).Path;$name=Split-Path $dir -Leaf
    $pm=[regex]::Match($name,'^\d{8}T\d{6}Z-(?<p>[a-z0-9]+(-[a-z0-9]+)*)$')
    if(!$pm.Success-or!(Test-Path (Join-Path $dir 'BRIEF.md'))){throw "DELEGATION_UNKNOWN: $dir is not a Delegate.ps1 folder"}
    $out=Join-Path $dir 'REPORT.md';if(Test-Path $out){throw "REPORT_EXISTS: $out (a verdict is recorded once)"}
    $text=[IO.File]::ReadAllText((Resolve-Path -LiteralPath $Reply).Path)
    $m=[regex]::Match($text,'(?m)^\s*VERDICT:\s*(CONFIRMED|DISPROVEN|INCONCLUSIVE)\b')
    if(!$m.Success){throw 'REPORT_NO_VERDICT: the reply has no VERDICT: CONFIRMED|DISPROVEN|INCONCLUSIVE line; ask the delegate again'}
    [IO.File]::WriteAllText($out,$text)
    $v=$m.Groups[1].Value;$first=($text-split"`r?`n"|Where-Object{$_.Trim()}|Select-Object -Skip 1 -First 1)
    $next=@{CONFIRMED='verify the decisive check yourself, then act on the proposal';INCONCLUSIVE='decide: dispatch again with a narrower question, or defer with a date';DISPROVEN=''}[$v]
    & $ev -Root $Root -Add -Pattern $pm.Groups['p'].Value -Source delegate -Category discovery -Cause $(if($v-eq'CONFIRMED'){'confirmed'}else{'hypothesis'}) -Status $(if($v-eq'DISPROVEN'){'disproven'}else{'open'}) -Summary "VERDICT: $v. $first" -Evidence $out -Owner $(if($next){'agent'}else{''}) -Action $next
    exit 0
}

if($List){
    if(!(Test-Path $base)){'DELEGATIONS: none';exit 0}
    $d=@(Get-ChildItem $base -Directory|Sort-Object Name -Descending)
    "DELEGATIONS: $($d.Count)"
    foreach($x in $d){
        $rep=Join-Path $x.FullName 'REPORT.md'
        $v=if(Test-Path $rep){$m=Select-String -LiteralPath $rep -Pattern '^\s*VERDICT:\s*(.+)$'|Select-Object -First 1;if($m){$m.Matches[0].Groups[1].Value.Trim()}else{'REPORT without a VERDICT line'}}else{'pending (no REPORT.md yet)'}
        "  $($x.Name): $v"
    }
    exit 0
}

$log=Join-Path $Root 'events\events.jsonl';$historyBad=0
$history=@(if(Test-Path $log){[IO.File]::ReadAllLines($log)|Where-Object{$_}|ForEach-Object{try{$o=$_|ConvertFrom-Json;if(!$o.pattern-or!$o.at){throw 'invalid record'};$o}catch{$historyBad++}}|Where-Object pattern -eq $Pattern|Sort-Object at})
$known=@($history|ForEach-Object{"- $(([datetime]$_.at).ToUniversalTime().ToString('yyyy-MM-dd')) [$($_.category), $($_.status), cause $($_.cause)] $($_.summary)$(if($_.action){" -> $($_.action)"})$(if($_.evidence){" (evidence: $($_.evidence))"})"})
if($historyBad){$known+="- EVENTS_INCOMPLETE: $historyBad unreadable history record(s) skipped in $log"}
if(!(Test-Path $log)){$known+="- EVENTS_UNAVAILABLE: no history journal at $log"}
$related=@(& $ev -Root $Root -Find $Question -Top 3);$lookupCode=$LASTEXITCODE
$related=@($related|Where-Object{$_-notmatch"^EVENTS:|^EVENTS relevant|\] $([regex]::Escape($Pattern)):"})  # solved before? say so before the work starts
if($historyBad-and$lookupCode-eq0){$lookupCode=2}
$spider=if($Query){@(& (Join-Path $PSScriptRoot 'Spider.ps1') $Query -Top 3 -Root $Root)}else{@()}
$dir=Join-Path $base "$([DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))-$Pattern";New-Item -ItemType Directory $dir -Force|Out-Null
$reportPath=Join-Path $dir 'REPORT.md'
$readable=if($ReadRoots){'only these roots: '+(($ReadRoots|ForEach-Object{'`'+$_+'`'})-join', ')}else{'every file of the workspace and both repositories'}
$gitScope=if($ReadRoots){'inside those roots only'}else{'in the real checkouts'}
$authority=if($Mode-eq'sandbox'){
"- You MAY create disposable copies (clones, worktrees, files) under ``$(Join-Path $temporaryRoot 'cx\ORVION-<task>')`` and run experiments there, including deliberate failure injection. Delete them when done.
- You MAY read $readable, and run read-only git commands $gitScope."
}else{
"- You MAY read $readable, and run read-only git commands (show, log, grep, rev-parse, cat-file, ls-tree, status) $gitScope."
}
$brief=@"
# Delegated investigation: $Pattern

Brief written $([DateTime]::UtcNow.ToString('yyyy-MM-dd HH:mm')) UTC by the improvement loop's delegation road (``lib\Delegate.ps1``).
You start cold: everything you need is here or reachable from here. Mode: **$Mode**. Time budget: **$Minutes minutes**.

## Question
$Question

## What is already known (event history for ``$Pattern``)
$(if($known){$known-join"`n"}else{'- nothing recorded yet'})

## Related past events and how they ended (``Events.ps1 -Find`` on the question)
$(if($related){$related-join"`n"}else{'- none recorded'})

## What the spider found$(if($Query){" for '$Query'"})
$(if($spider){'```'+"`n"+($spider-join"`n")+"`n"+'```'}else{'- not run (no -Query given)'})

## Authority (delegation never grants more)
$authority
- You MAY write only inside ``$dir`` (probe scripts and their outputs)$(if($Mode-eq'sandbox'){' and your own temp copies'}).
- You MUST NOT commit, push, check out, reset or otherwise change the real checkouts (``Documents\GitHub\CRM``, ``Documents\GitHub\ORVION``, the trusted-main clones), edit ``$Root\records``, touch credentials (``gh auth``, tokens), call remote services that write, or start ``-Finish``.
- Prefer Read/Grep/Glob for files; use PowerShell for git and experiments. Never print environment variable values or secrets.
- Repository authority stays where it is: each repository's own Boot, contracts and Gate 1. Your result is evidence, not a decision.

## Method
1. LEARN: read what is cited above and the code it names before forming a view. Name the established way this kind of thing is checked.
2. REPRODUCE OR FALSIFY: design the smallest experiment that would prove the question either way$(if($Mode-eq'readonly'){' using reads only'}); run it; keep every command and its output.
3. MEASURE: exact numbers from real outputs; label anything you did not run as a hypothesis.
4. Save each probe and its raw output in ``$dir`` as you go, so the evidence survives even if you stop early.
5. STOP when the question is answered, or when the time budget is spent (then report INCONCLUSIVE with what remains).

## Deliverable
Your final reply IS the report (helper agents may not write report files; the delegating agent saves your reply as ``$reportPath``). In this order:
- ``VERDICT: CONFIRMED`` | ``VERDICT: DISPROVEN`` | ``VERDICT: INCONCLUSIVE`` (first line, exactly this form)
- Cause: confirmed or hypothesis, in one paragraph
- Evidence: the commands you ran and the decisive output lines, with file:line pointers
- Proposal: the smallest change that would fix it, in which repository or tool, and through which route (repository contract with its own Gate 1, or a workspace tool change); or "none"
- Cost and risk of the proposal

Your reply must start with the VERDICT line and contain the whole report, nothing else. Do not record events
yourself: the delegating agent records your verdict when it saves your reply (one return road, no permission prompt).
"@
[IO.File]::WriteAllText((Join-Path $dir 'BRIEF.md'),$brief)
# due = twice the budget: past it, Coordinator.ps1 reports the delegation OVERDUE (no report came back)
$null=& $ev -Root $Root -Add -Pattern $Pattern -Source delegate-road -Category observation -Status open -Summary "delegated ($Mode, $Minutes min): $Question" -Evidence (Join-Path $dir 'BRIEF.md') -Owner "delegate:$(Split-Path $dir -Leaf)" -Action 'report back' -Due ([DateTime]::UtcNow.AddMinutes(2*$Minutes).ToString('yyyy-MM-ddTHH:mm:ssZ',[Globalization.CultureInfo]::InvariantCulture))
"DELEGATED $Pattern -> $(Join-Path $dir 'BRIEF.md')"
"LAUNCH a background agent with exactly this prompt: Read `"$(Join-Path $dir 'BRIEF.md')`" and carry it out exactly as written."
"WHEN IT FINISHES: save its reply to a file, then: pwsh -NoProfile -File `"$PSCommandPath`" -Report `"$dir`" -Reply <that file>   (re-run its decisive check yourself before acting on it)"
exit $lookupCode
