# Windows environment

Use this file when `ENVIRONMENT = windows` in your profile (or when you are clearly on Windows).

## Shell and OS

- Assume **Windows 10/11** and **PowerShell 7** unless the user says otherwise.
- When you install a tool in PowerShell and it adds itself to `PATH`, refresh the session:

```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

## Code hive path (`%code%`)

- **Canonical short root:** set a User environment variable named `code` (cmd: `%code%`, PowerShell: `$env:code`) to the machine’s code hive. Prefer a **short** path (`C:\code` or `Z:\code`) over `%USERPROFILE%\code` — Windows path length bites deep trees/builds.
- Also set User `CODE_ROOT` to the **same** value (rules-manager / scripts often read `CODE_ROOT`).
- After creating/changing it, refresh the current session:

```powershell
$env:code = [Environment]::GetEnvironmentVariable('code','User')
$env:CODE_ROOT = [Environment]::GetEnvironmentVariable('CODE_ROOT','User')
```

- Agents: resolve `CODE_ROOT` from `$env:code` / `$env:CODE_ROOT` first; fall back to the active profile’s `CODE_ROOT`. Do **not** invent `C:\Users\<you>\code` as a second hive.

## Node and Python tooling

- Use **`pnpm`** for Node. For one-off tools: `pnpm dlx`; for project binaries: `pnpm exec`.
- Use **`uv`** instead of `pip` for Python. Scripts may install `uv` if it is missing.

## Git hosting CLIs

- Prefer **`gh`** (GitHub) and **`glab`** (GitLab) for operations that are not covered by MCP.
