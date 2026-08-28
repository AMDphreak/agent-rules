#Requires -Version 7
<#
.SYNOPSIS
  Unlock Bitwarden with a native GUI password prompt for agent shells.

.DESCRIPTION
  Tokenless. Copy to $env:USERPROFILE\unlock_bitwarden_gui.ps1 (or invoke from
  this skill path). Uses OpenShellOrg terminal-gui-prompts WinForms patterns
  when available; falls back to Get-Credential or Read-Host -AsSecureString.

  AI agents: dot-source, then use bw without printing BW_SESSION.

.PARAMETER PersistUserEnv
  Also write BW_SESSION to the User-level environment variable (~30 min TTL).

.EXAMPLE
  . "$env:USERPROFILE\unlock_bitwarden_gui.ps1"
  bw status

.EXAMPLE
  . "$env:USERPROFILE\unlock_bitwarden_gui.ps1" -PersistUserEnv
#>
[CmdletBinding()]
param(
    [switch] $PersistUserEnv
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-BwOnPath {
    if (-not (Get-Command bw -ErrorAction SilentlyContinue)) {
        $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
            [System.Environment]::GetEnvironmentVariable('Path', 'User')
    }
    if (-not (Get-Command bw -ErrorAction SilentlyContinue)) {
        throw 'Bitwarden CLI (bw) not found on PATH.'
    }
}

function Get-OpenShellInputDialogScript {
    $roots = @(
        $env:CODE_ROOT,
        $env:code,
        'Z:/code'
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique

    foreach ($root in $roots) {
        $candidate = Join-Path $root 'github.com/openshellorg/terminal-gui-prompts/scripts/Show-InputDialog.ps1'
        if (Test-Path -LiteralPath $candidate) { return $candidate }
    }
    return $null
}

function Get-MasterPasswordSecure {
    $scriptDir = $PSScriptRoot
    if ([string]::IsNullOrWhiteSpace($scriptDir)) {
        $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    }

    $localDialog = Join-Path $scriptDir 'Show-PasswordDialog.ps1'
    if (Test-Path -LiteralPath $localDialog) {
        $secure = . $localDialog -Message 'Enter your Bitwarden master password.' -Title 'Unlock Bitwarden'
        if ($null -ne $secure) { return $secure }
        throw 'Bitwarden unlock cancelled.'
    }

    if ([Environment]::UserInteractive) {
        try {
            $cred = Get-Credential -Message 'Enter your Bitwarden master password.' -UserName 'Bitwarden'
            if ($null -ne $cred) { return $cred.Password }
        } catch {
            # Fall through to Read-Host
        }
    }

    Write-Host 'Bitwarden master password:' -NoNewline
    return Read-Host -AsSecureString
}

function Set-BwSessionFromRaw {
    param([Parameter(Mandatory)][string] $Raw)
    $trimmed = $Raw.Trim()
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        throw 'Bitwarden session was empty.'
    }
    $env:BW_SESSION = $trimmed
}

function Invoke-PersistBwSession {
    param([string] $Session)
    $persist = Join-Path $PSScriptRoot 'persist_bw_session.ps1'
    if (-not (Test-Path -LiteralPath $persist)) {
        [Environment]::SetEnvironmentVariable('BW_SESSION', $Session, 'User')
        return
    }
    $Session | & $persist
}

Ensure-BwOnPath

$statusJson = & bw status 2>&1 | Out-String
try {
    $status = $statusJson | ConvertFrom-Json
} catch {
    throw "bw status failed: $statusJson"
}

if ($status.status -eq 'unlocked') {
    if ([string]::IsNullOrWhiteSpace($env:BW_SESSION)) {
        $stored = [Environment]::GetEnvironmentVariable('BW_SESSION', 'User')
        if (-not [string]::IsNullOrWhiteSpace($stored)) {
            Set-BwSessionFromRaw -Raw $stored
        }
    }
    if ($PersistUserEnv -and -not [string]::IsNullOrWhiteSpace($env:BW_SESSION)) {
        Invoke-PersistBwSession -Session $env:BW_SESSION
    }
    return
}

if ($status.status -ne 'locked') {
    throw "Unexpected Bitwarden status: $($status.status). Run 'bw login' in your own terminal if needed."
}

$securePassword = Get-MasterPasswordSecure
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
try {
    $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    $raw = & bw unlock $plain --raw 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "bw unlock failed (exit $LASTEXITCODE)."
    }
} finally {
    if ($plain) {
        $plain = [string]::new('x', $plain.Length)
    }
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
}

Set-BwSessionFromRaw -Raw ([string]$raw)

if ($PersistUserEnv) {
    Invoke-PersistBwSession -Session $env:BW_SESSION
}

# When executed (not dot-sourced), exit 0 without printing the session.
if ($MyInvocation.InvocationName -ne '.') {
    exit 0
}
