---
name: bitwarden-unlock
description: >-
  Use when bitwarden, bw, BW_SESSION, ensure_bw_unlocked.ps1, bw_session_store,
  session persist, BW_CLIENTID, BW_CLIENTSECRET, bw login --apikey,
  bw-apikey.local.ps1, bw_login.ps1, unlock_bitwarden.ps1, vault unlock,
  piping session, Bitwarden CLI, bw unlock --raw, bw status, bw list, or
  generating a Bitwarden unlock script for an agent.
---

# Bitwarden CLI unlock (no session in context)

`BW_SESSION` is the vault **decrypt** key (from `bw unlock`). It stays valid until `bw lock` / `bw logout` — no built-in CLI timeout.

AI must **never read**, print, log, or copy `BW_SESSION`, `BW_CLIENTSECRET`, live `%USERPROFILE%\bw-apikey.local.ps1`, or `%USERPROFILE%\.bw-session.dpapi`. Do **not** `Read` profile scripts that may hold secrets. Invoke by path only (dot-source).

## This machine (agents) — use `ensure_bw_unlocked.ps1`

**Always** dot-source the session-aware entry point before any vault command (`bw list`, `bw get`, …):

```powershell
. "$env:USERPROFILE\ensure_bw_unlocked.ps1"
bw status   # JSON only — status + userEmail
```

What it does:

1. `bw_login.ps1` when not logged in (API key from `bw-apikey.local.ps1`)
2. **Restore** saved `BW_SESSION` (User env + DPAPI file `.bw-session.dpapi`)
3. Unlock via GUI **only** when still locked; **persist** session after unlock

Harness: `BITWARDEN_SESSION_PERSIST = enabled` in `$HARNESS`. Machine block in `$MACHINE` and always-on `bitwarden-unlock.mdc`.

Then `bw list`, `bw get`, `bw sync` as needed. Redirect/suppress anything that would print the token.

Report: locked/unlocked and user email if present. Never passwords, TOTP, item secrets, or session strings.

## Local session persistence (this workstation)

Install once (profile copies):

```powershell
$src = "$env:USERPROFILE\.cursor\skills\bitwarden-unlock\scripts"
Copy-Item "$src\ensure_bw_unlocked.ps1", "$src\bw_session_store.ps1", `
  "$src\persist_bw_session.ps1", "$src\unlock_bitwarden_gui.ps1", `
  "$src\Show-PasswordDialog.ps1", "$src\unlock_bitwarden.ps1" `
  $env:USERPROFILE -Force
```

After the **first** unlock in a session, later agent shells reuse the saved key until lock/logout.

Clear locally: `Clear-BwSessionLocal` (from dot-sourced `bw_session_store.ps1`) or `bw lock`.

## Personal API key (login, not unlock)

Bitwarden CLI reads `BW_CLIENTID` and `BW_CLIENTSECRET` for `bw login --apikey`. Live values: `%USERPROFILE%\bw-apikey.local.ps1`. Template: [scripts/bw-apikey.local.ps1.example](scripts/bw-apikey.local.ps1.example).

## Lower-level scripts

| Script | Role |
| --- | --- |
| `ensure_bw_unlocked.ps1` | **Agent entry** — login + restore + unlock + persist |
| `bw_session_store.ps1` | Save/restore/clear local session (User env + DPAPI) |
| `bw_login.ps1` | API-key login |
| `unlock_bitwarden_gui.ps1` | GUI master-password unlock; `-PersistUserEnv` |
| `unlock_bitwarden.ps1` | Pipe/`bw unlock --raw`; restores before prompt |
| `persist_bw_session.ps1` | Persist current `$env:BW_SESSION` |

## Generate scripts (other users / new machines)

Copy tokenless templates from [scripts/](scripts/) to `$env:USERPROFILE\`. Do **not** paste session keys into chat or git.

User creates session without the model seeing the token — **user runs in their own terminal**:

```powershell
bw unlock --raw | ForEach-Object { $env:BW_SESSION = $_ }
. "$env:USERPROFILE\persist_bw_session.ps1"
```

Optional org pattern (not default): upstream `general/bitwarden-session-persist-optional.md`.

## Windows

PowerShell 7. If `bw` is missing, refresh PATH from Machine+User, then retry. `bw` is Bitwarden CLI, not the other `bw` tools.
