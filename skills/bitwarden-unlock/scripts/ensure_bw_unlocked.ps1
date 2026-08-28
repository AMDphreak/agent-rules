#Requires -Version 7
<#
.SYNOPSIS
  Log in, restore a saved vault session, unlock if needed — agent entry point.

.DESCRIPTION
  Copy to $env:USERPROFILE\ensure_bw_unlocked.ps1 with bw_session_store.ps1 and
  sibling unlock/login scripts. Restores BW_SESSION from User env + DPAPI file
  before prompting. Persists session after every successful unlock.

  AI agents (this machine): always dot-source this first for any bw vault work:
    . "$env:USERPROFILE\ensure_bw_unlocked.ps1"
    bw list items   # example

  Never Read bw-apikey.local.ps1, .bw-session.dpapi, or profile scripts that
  may hold secrets. Capture bw status JSON only.
#>
[CmdletBinding()]
param(
    [switch] $SkipLogin
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-ScriptRoot {
    $root = $PSScriptRoot
    if ([string]::IsNullOrWhiteSpace($root)) {
        $root = Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    return $root
}

function Ensure-BwOnPath {
    if (-not (Get-Command bw -ErrorAction SilentlyContinue)) {
        $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
            [System.Environment]::GetEnvironmentVariable('Path', 'User')
    }
    if (-not (Get-Command bw -ErrorAction SilentlyContinue)) {
        throw 'Bitwarden CLI (bw) not found on PATH.'
    }
}

function Invoke-ProfileScript {
    param(
        [Parameter(Mandatory)][string] $Name
    )
    $root = Get-ScriptRoot
    $local = Join-Path $env:USERPROFILE $Name
    $beside = Join-Path $root $Name
    if (Test-Path -LiteralPath $local) {
        . $local
        return
    }
    if (Test-Path -LiteralPath $beside) {
        . $beside
        return
    }
    throw "Missing $Name in `$env:USERPROFILE or script directory."
}

Ensure-BwOnPath

$storePath = Join-Path (Get-ScriptRoot) 'bw_session_store.ps1'
if (-not (Test-Path -LiteralPath $storePath)) {
    $storePath = Join-Path $env:USERPROFILE 'bw_session_store.ps1'
}
if (-not (Test-Path -LiteralPath $storePath)) {
    throw 'Missing bw_session_store.ps1 beside ensure_bw_unlocked.ps1 or in profile.'
}
. $storePath

if (-not $SkipLogin) {
    $loginScript = Join-Path $env:USERPROFILE 'bw_login.ps1'
    if (Test-Path -LiteralPath $loginScript) {
        . $loginScript
    }
}

[void] (Restore-BwSessionLocal)
if (Test-BwVaultUnlocked) {
    return
}

# Desktop unlock does not propagate to CLI — hint before prompting (detection only).
$desktopHintScript = Join-Path (Get-ScriptRoot) 'bw_desktop_session.ps1'
if (-not (Test-Path -LiteralPath $desktopHintScript)) {
    $desktopHintScript = Join-Path $env:USERPROFILE 'bw_desktop_session.ps1'
}
if (-not (Test-Path -LiteralPath $desktopHintScript)) {
    $skillHint = Join-Path $env:USERPROFILE '.cursor/skills/bitwarden-unlock/scripts/bw_desktop_session.ps1'
    if (Test-Path -LiteralPath $skillHint) { $desktopHintScript = $skillHint }
}
if (Test-Path -LiteralPath $desktopHintScript) {
    . $desktopHintScript
    Write-BwDesktopSessionHintIfRelevant -Warning | Out-Null
}

$guiUnlock = Join-Path $env:USERPROFILE 'unlock_bitwarden_gui.ps1'
if (Test-Path -LiteralPath $guiUnlock) {
    . $guiUnlock -PersistUserEnv
}
else {
    Invoke-ProfileScript -Name 'unlock_bitwarden_gui.ps1'
}

if (-not [string]::IsNullOrWhiteSpace($env:BW_SESSION)) {
    Save-BwSessionLocal -Session $env:BW_SESSION
}

if (-not (Test-BwVaultUnlocked)) {
    throw 'Bitwarden vault is still locked after ensure_bw_unlocked.'
}

if ($MyInvocation.InvocationName -ne '.') {
    exit 0
}
