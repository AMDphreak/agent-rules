#Requires -Version 7
<#
.SYNOPSIS
  Persist BW_SESSION to the User environment for local agent reuse.

.DESCRIPTION
  Bitwarden session keys expire after ~30 minutes of inactivity. Storing in the
  User env var lets new shells pick up a recent unlock; re-run unlock when bw
  reports locked. Never commit BW_SESSION or paste it into chat.

  Accepts session on stdin or uses $env:BW_SESSION when piped empty.

.EXAMPLE
  bw unlock --raw | . "$env:USERPROFILE\unlock_bitwarden.ps1"
  . "$env:USERPROFILE\persist_bw_session.ps1"

.EXAMPLE
  . "$env:USERPROFILE\unlock_bitwarden_gui.ps1" -PersistUserEnv
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$session = $null
if ($MyInvocation.ExpectingInput) {
    $session = (@($input) | ForEach-Object { $_ }) -join [Environment]::NewLine
}
if ([string]::IsNullOrWhiteSpace($session)) {
    $session = $env:BW_SESSION
}
$session = $session.Trim()
if ([string]::IsNullOrWhiteSpace($session)) {
    throw 'No BW_SESSION to persist (unlock first).'
}

[Environment]::SetEnvironmentVariable('BW_SESSION', $session, 'User')
$env:BW_SESSION = $session

# Do not Write-Output the session.
if ($MyInvocation.InvocationName -ne '.') {
    exit 0
}
