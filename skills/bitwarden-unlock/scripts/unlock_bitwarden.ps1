#Requires -Version 7
<#
.SYNOPSIS
  Put Bitwarden CLI session into the current process without printing it.

.DESCRIPTION
  Tokenless template. Copy to $env:USERPROFILE\unlock_bitwarden.ps1.
  Never commit a copy that contains a live BW_SESSION assignment.

  Restores a saved session (User env / DPAPI) before prompting. After a fresh
  unlock, persists locally when bw_session_store.ps1 is installed beside this
  script or in the profile.

  User (own terminal; AI must not capture the output):
    bw unlock --raw | ForEach-Object { $env:BW_SESSION = $_ }
    bw unlock --raw | . $env:USERPROFILE\unlock_bitwarden.ps1

  Agent (prefer ensure_bw_unlocked.ps1 instead):
    . $env:USERPROFILE\ensure_bw_unlocked.ps1
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

function Import-BwSessionStore {
    $beside = Join-Path $PSScriptRoot 'bw_session_store.ps1'
    $profile = Join-Path $env:USERPROFILE 'bw_session_store.ps1'
    if (Test-Path -LiteralPath $beside) { . $beside; return $true }
    if (Test-Path -LiteralPath $profile) { . $profile; return $true }
    return $false
}

function Test-BwVaultUnlocked {
    try {
        $raw = & bw status 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0) { return $false }
        $status = $raw | ConvertFrom-Json
        return ($status.status -eq 'unlocked')
    }
    catch {
        return $false
    }
}

if (-not (Get-Command bw -ErrorAction SilentlyContinue)) {
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
        [System.Environment]::GetEnvironmentVariable('Path', 'User')
}

$hasStore = Import-BwSessionStore
if ($hasStore) {
    [void] (Restore-BwSessionLocal)
    if (Test-BwVaultUnlocked) {
        if ($MyInvocation.InvocationName -ne '.') { exit 0 }
        return
    }
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

if ($hasStore -and -not [string]::IsNullOrWhiteSpace($env:BW_SESSION)) {
    Save-BwSessionLocal -Session $env:BW_SESSION
}

# Session is process-scoped. Do not Write-Output / Write-Host it.
# When dot-sourced, never `exit` — that would kill the caller.
if ($MyInvocation.InvocationName -ne '.') {
    exit 0
}
