# Main Rules

<!--
This is a modular context assembly file. For a consolidated, all-in-one ruleset, use **[RULES.md](./RULES.md)** instead.
-->

> **Dev Configuration**: resolve `CODE_ROOT` from this host (`%code%` / Cursor `~/.cursor/rules` / `profiles/<id>.md`). Do not bake a drive letter into Cursor User Rules (those sync).
> `AGENT_RULES_PATH=$CODE_ROOT/github.com/AMDphreak/agent-rules`

You are operating under this rules set.

## Context Assembly (CRITICAL FIRST STEP)

You must read all foundational rules in a single step using your native file reading tools. Do not read them sequentially. All paths below are strictly relative to `$AGENT_RULES_PATH`. Resolve that absolute path based on the variables above.

Read these files **simultaneously in parallel tool calls** to assemble your full context:

- `profiles/<infer-profile-name>.md` (contains machine constants, including `ENVIRONMENT`)
- `general/global.md`
- `general/environment.md`
- `general/<windows|mac|linux>.md` (infer OS from host or profile)
- `general/creator.md`
- `general/folder-schema.md`
- `general/documentation.md` (only if the task involves authoring or publishing project documentation)

Optional heavy curricula are **Cursor skills** (team: `dev-centr/agent-rules/skills/`; this fork: `skills/talk-normal`). See team `skills/CATALOG.md` and this fork’s `skills/CATALOG.md`.

*(Fallback)*: If you lack native file reading tools, use a terminal to read them all in one command (e.g. `cat`), but beware of output truncation. If the host cannot read the filesystem, follow the **obligations** below as your only source.

## Machine-local memory

- Read **`$CODE_ROOT/MEMORIES.md`** for durable facts about **this workstation** (paths, PATH gaps, hardware). Create it if missing (see `MEMORIES.example.md`). Never commit it.
- Do **not** use per-repo `MEMORIES.md` for project knowledge — put that in `AGENTS.md` + docs/README.

## Constants (interpret from the active profile)

- `CODE_ROOT` — root directory for all clones.
- `GITHUB_USER` — GitHub username for path examples.
- `ISSUES_REPO` — path to the `.issues` repository when that workflow is used.
- `ENVIRONMENT` — selects which OS layer file to apply: `windows` → `general/windows.md`, `mac` → `general/mac.md`, `linux` → `general/linux.md`.

## Obligations (always)

- **OS/Shell:** Assume **Windows 10/11** and **PowerShell 7** unless explicitly told otherwise.
- Write explanations in plain language.
- Treat `.gitignore` as an allow-list unless the project says otherwise (exclude `*` then allow specific).
- **Sync with remote before multi-file work:** in each affected git repo, `git fetch` and check `git status -sb` for `behind`. If the branch tracks a remote and is behind, pull/rebase (or merge) **before** coding. Do not invent a large change set against a stale local HEAD.
- For Python, use a `venv`; prefer `uv` over `pip`; install `uv` in scripts if missing.
- When builds fail, prefer fixing outdated project code over downgrading dependencies. If failure is due to a missing icon, stop the rebuild loop; use a placeholder or ask the user.
- For dependencies whose APIs are stale in memory, use Context7 MCP when available; if not, direct the user to <https://context7.com/>

## Dev-Centr product scope

These rules are for **end-user / project** agents. **Dev-Centr application automation** (acting on behalf of the user) must load `https://github.com/dev-centr/devcentr-agent-rules` instead of this repository—do not conflate the two.

## Optional Cursor skills (this repo)

Files under `skills/` are **not** auto-loaded by MAIN assembly. Junction into `~/.cursor/skills/<name>/` for Cursor discovery. Skill `write-skill` (`skills/write-skill/`) when authoring skills — description = trigger words, not a lay blurb.

## Memory file format (when writing `$CODE_ROOT/MEMORIES.md`)

Stable workstation facts only; see `MEMORIES.example.md`. One line shape:

```text
<fact about this machine> (counter: 1)
```
