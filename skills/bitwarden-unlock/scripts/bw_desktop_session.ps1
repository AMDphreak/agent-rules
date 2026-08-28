#Requires -Version 7
<#
.SYNOPSIS
  Detect Bitwarden Desktop IPC availability (no session adoption).

.DESCRIPTION
  The Desktop app exposes an IPC endpoint for browser integration (named pipe on
  Windows, Unix socket on macOS/Linux). The official CLI does not yet support
  adopting the Desktop unlock session. This helper only detects whether Desktop
  appears running and whether the IPC endpoint exists — it cannot retrieve a
  session key without implementing the encrypted native-messaging protocol.

  See: https://github.com/bitwarden/clients (feature request for --use-desktop-session)

.NOTES
  Pipe path on Windows matches bitwarden-cli-bio / Desktop PR #4020:
  \\.\pipe\{base64url(sha256(homedir))}.s.bw
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Set after the GitHub issue is filed; updated by ensure_bw_unlocked when known.
$script:BwDesktopSessionFeatureRequestUrl = 'https://github.com/bitwarden/clients/issues/22773'

function Set-BwDesktopSessionFeatureRequestUrl {
    param([Parameter(Mandatory)][string] $Url)
    $script:BwDesktopSessionFeatureRequestUrl = $Url
}

function Get-BwDesktopWindowsPipeName {
    $homeDir = [Environment]::GetFolderPath('UserProfile')
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [Text.Encoding]::UTF8.GetBytes($homeDir)
        $hash = $sha.ComputeHash($bytes)
    }
    finally {
        $sha.Dispose()
    }
    $b64 = [Convert]::ToBase64String($hash)
    $hashB64 = $b64.Replace('+', '-').Replace('/', '_').TrimEnd('=')
    return "$hashB64.s.bw"
}

function Test-BwDesktopProcessRunning {
    $names = @('Bitwarden', 'bitwarden')
    foreach ($name in $names) {
        if (Get-Process -Name $name -ErrorAction SilentlyContinue) {
            return $true
        }
    }
    return $false
}

function Test-BwDesktopIpcEndpoint {
    if ($IsWindows -or ($env:OS -match 'Windows')) {
        $pipeName = Get-BwDesktopWindowsPipeName
        return Test-Path -LiteralPath "\\.\pipe\$pipeName"
    }
    # macOS / Linux paths — detection only; no connection attempt
    $home = $env:HOME
    if ([string]::IsNullOrWhiteSpace($home)) {
        return $false
    }
    if ($IsMacOS) {
        $candidates = @(
            (Join-Path $home 'Library/Group Containers/LTZ2PFU5D6.com.bitwarden.desktop/s.bw'),
            (Join-Path $home 'Library/Caches/com.bitwarden.desktop/s.bw')
        )
        foreach ($path in $candidates) {
            if (Test-Path -LiteralPath $path) { return $true }
        }
        return $false
    }
    $cache = if ($env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME } else { Join-Path $home '.cache' }
    return Test-Path -LiteralPath (Join-Path $cache 'com.bitwarden.desktop/s.bw')
}

function Get-BwDesktopSessionHint {
    <#
    .OUTPUTS
      PSCustomObject with detection fields and an actionable Message when CLI is
      locked but Desktop IPC appears available.
    #>
    $cliLocked = $false
    $cliStatus = $null
    if (Get-Command bw -ErrorAction SilentlyContinue) {
        try {
            $raw = & bw status 2>&1 | Out-String
            if ($LASTEXITCODE -eq 0) {
                $cliStatus = $raw | ConvertFrom-Json
                $cliLocked = ($cliStatus.status -eq 'locked')
            }
        }
        catch {
            # ignore — caller may run before bw is on PATH
        }
    }

    $desktopRunning = Test-BwDesktopProcessRunning
    $ipcAvailable = Test-BwDesktopIpcEndpoint

    $message = $null
    if ($cliLocked -and ($desktopRunning -or $ipcAvailable)) {
        $message = @(
            'Bitwarden CLI is locked but the Desktop app appears to be running with browser integration IPC.'
            'The CLI cannot adopt the Desktop unlock session today — unlock states are independent.'
            'Workarounds: run unlock_bitwarden_gui.ps1 (master password), persist BW_SESSION, or use bwbio for biometric unlock via Desktop.'
            "Feature request (please vote/comment): $script:BwDesktopSessionFeatureRequestUrl"
        ) -join ' '
    }

    [PSCustomObject]@{
        CliLocked       = $cliLocked
        CliStatus       = if ($cliStatus) { $cliStatus.status } else { $null }
        DesktopRunning  = $desktopRunning
        IpcAvailable    = $ipcAvailable
        CanAdoptSession = $false
        Message         = $message
        FeatureRequest  = $script:BwDesktopSessionFeatureRequestUrl
    }
}

function Write-BwDesktopSessionHintIfRelevant {
    param(
        [switch] $Warning
    )
    $hint = Get-BwDesktopSessionHint
    if (-not $hint.Message) {
        return $hint
    }
    if ($Warning) {
        Write-Warning $hint.Message
    }
    else {
        Write-Host $hint.Message
    }
    return $hint
}
