#Requires -Version 7
<#
.SYNOPSIS
  Persist BW_SESSION locally for reuse across agent shells.

.DESCRIPTION
  Saves to User-level BW_SESSION and a DPAPI-protected file at
  $env:USERPROFILE\.bw-session.dpapi. Valid until bw lock / bw logout — no
  built-in CLI timeout. Never commit session material or paste it into chat.

  Accepts session on stdin or uses $env:BW_SESSION when piped empty.

.EXAMPLE
  bw unlock --raw | . "$env:USERPROFILE\unlock_bitwarden.ps1"
  . "$env:USERPROFILE\persist_bw_session.ps1"

.EXAMPLE
  . "$env:USERPROFILE\unlock_bitwarden_gui.ps1" -PersistUserEnv
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$storeBeside = Join-Path $PSScriptRoot 'bw_session_store.ps1'
$storeProfile = Join-Path $env:USERPROFILE 'bw_session_store.ps1'
if (Test-Path -LiteralPath $storeBeside) { . $storeBeside }
elseif (Test-Path -LiteralPath $storeProfile) { . $storeProfile }
else {
    throw 'Missing bw_session_store.ps1 beside persist_bw_session.ps1 or in profile.'
}

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

Save-BwSessionLocal -Session $session

# Do not Write-Output the session.
if ($MyInvocation.InvocationName -ne '.') {
    exit 0
}
