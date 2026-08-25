#Requires -Version 7
<#
.SYNOPSIS
  Put Bitwarden CLI session into the current process without printing it.

.DESCRIPTION
  Tokenless template. Copy to $env:USERPROFILE\unlock_bitwarden.ps1.
  Never commit a copy that contains a live BW_SESSION assignment.

  User (own terminal; AI must not capture the output):
    bw unlock --raw | ForEach-Object { $env:BW_SESSION = $_ }
    bw unlock --raw | . $env:USERPROFILE\unlock_bitwarden.ps1

  Agent (after the profile script exists):
    . $env:USERPROFILE\unlock_bitwarden.ps1
    bw status
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Set-BwSessionFromRaw {
    param([Parameter(Mandatory)][string]$Raw)
    $trimmed = $Raw.Trim()
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        throw 'Bitwarden session was empty.'
    }
    $env:BW_SESSION = $trimmed
}

if (-not (Get-Command bw -ErrorAction SilentlyContinue)) {
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
        [System.Environment]::GetEnvironmentVariable('Path', 'User')
}

$piped = $null
if ($MyInvocation.ExpectingInput) {
    $piped = (@($input) | ForEach-Object { $_ }) -join [Environment]::NewLine
}

if (-not [string]::IsNullOrWhiteSpace($piped)) {
    Set-BwSessionFromRaw -Raw $piped
}
elseif ([string]::IsNullOrWhiteSpace($env:BW_SESSION)) {
    $raw = & bw unlock --raw
    if ($LASTEXITCODE -ne 0) {
        throw "bw unlock failed (exit $LASTEXITCODE)."
    }
    Set-BwSessionFromRaw -Raw ([string]$raw)
}

# Session is process-scoped. Do not Write-Output / Write-Host it.
# When dot-sourced, never `exit` — that would kill the caller.
if ($MyInvocation.InvocationName -ne '.') {
    exit 0
}
