---
name: bitwarden-unlock
description: >-
  Use when bitwarden, bw, BW_SESSION, unlock_bitwarden.ps1, vault unlock,
  piping session, Bitwarden CLI, bw unlock --raw, bw status, bw list, or
  generating a Bitwarden unlock script for an agent.
---

# Bitwarden CLI unlock (no session in context)

AI must **never read**, print, log, or copy `BW_SESSION` / session keys. Do **not** `Read` a live `%USERPROFILE%\unlock_bitwarden.ps1` — it may contain a hardcoded assignment. Invoke by path only.

## This machine (agents)

```powershell
. "$env:USERPROFILE\unlock_bitwarden.ps1"
if (-not (Get-Command bw -ErrorAction SilentlyContinue)) {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
    [System.Environment]::GetEnvironmentVariable("Path","User")
}
bw status
```

If the vault is **locked** and the terminal is non-interactive, use the GUI unlock script (OpenShellOrg-style WinForms + `Get-Credential` fallback):

```powershell
. "$env:USERPROFILE\unlock_bitwarden_gui.ps1"   # optional: -PersistUserEnv
bw status
```

Optional User-level session (~30 min TTL): `-PersistUserEnv` or `persist_bw_session.ps1`. See [scripts/README.adoc](scripts/README.adoc).

Then `bw list`, `bw get`, `bw sync` as needed. Capture **status JSON only** (`status`, `userEmail`). Redirect/suppress anything that would print the token (`bw unlock --raw`, `echo $env:BW_SESSION`, `Get-Content` on the profile script).

Report: locked/unlocked and user email if present. Never passwords, TOTP, item secrets, or session strings.

## Generate the script (other users / new machines)

Copy the tokenless template [scripts/unlock_bitwarden.ps1](scripts/unlock_bitwarden.ps1) to `$env:USERPROFILE\unlock_bitwarden.ps1`. Do **not** paste a session into the file from chat.

Creating without the model seeing the token — **user runs this in their own terminal**:

```powershell
bw unlock --raw | ForEach-Object { $env:BW_SESSION = $_ }
```

Or pipe into the script (stdin sets the env var; script never `Write-Output`s it):

```powershell
bw unlock --raw | . "$env:USERPROFILE\unlock_bitwarden.ps1"
```

The template:

- If stdin has data, sets `BW_SESSION` from the pipeline
- Else runs `bw unlock --raw` and assigns without echoing
- Sets env for the **current process only**
- Returns 0 on success when executed; when **dot-sourced**, must not `exit` (that kills the caller)

Do not commit the live profile script if it might contain a session. The template in this skill is OK to git.

## Windows

PowerShell 7. If `bw` is missing, refresh PATH from Machine+User as above, then retry. `bw` is Bitwarden CLI, not the other `bw` tools.
