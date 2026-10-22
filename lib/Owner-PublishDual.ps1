# Explicit two-repository operation; each own tracked owner interface retains its confirmation and native gates.
[CmdletBinding()]
param([Parameter(Mandatory)][string]$Descriptor,[Parameter(Mandatory)][string]$EvidenceDirectory,[string]$Approval,[string]$ApprovalSha256,[switch]$NonInteractive)
& (Join-Path $PSScriptRoot 'Invoke-OwnerDual.ps1') -Operation PUBLISH -Descriptor $Descriptor -EvidenceDirectory $EvidenceDirectory -Approval $Approval -ApprovalSha256 $ApprovalSha256 -NonInteractive:$NonInteractive
exit $LASTEXITCODE
