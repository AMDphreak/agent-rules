# Agent Rules
<!-- Consolidated agent preamble. Paste **this file** into Cursor User Rules / AGENTS.md. Do **not** paste `agent-rules.composed.md` or `profiles/*.overlay.md` into Cursor Settings — User Rules sync across machines. This-machine hive paths belong in `%USERPROFILE%\.cursor\rules\` (local `.mdc`; does not sync). Detail lives in `general/*.md` when assembling from MAIN.md. Do **not** paste skill bodies into this file. -->

## Constants
- CODE_ROOT: resolve `$env:code` / `%code%` / `$env:CODE_ROOT` on this host (never a second hive under the user profile). Concrete path lives only in this machine’s Cursor `~/.cursor/rules` and `profiles/<desktop|laptop>.md` — not in User Rules.
- GITHUB_USER: `amdphreak`
- ISSUES_REPO: `$CODE_ROOT/github.com/AMDphreak/.issues`
- ENVIRONMENT: `windows`
- MEMORIES: `$CODE_ROOT/MEMORIES.md` (sys-wide, machine-local — not per repo)

## Core
- Plain language: keep explanations easy to read.
- **File names in chat:** when you mention a file you are working on or the user asked about, write the **file name** as a markdown link to the workspace-relative path (forward slashes) so a click opens it in the editor. Do not use `file://` or Windows backslashes in chat links.
- Gitignore: allow-list (`*` then `!path`); update when adding files. Do **not** allow-list `MEMORIES.md` (keep it ignored).
- **Sync with remote before multi-file work:** in each affected git repo, `git fetch` and check `git status -sb` for `behind`. If the branch tracks a remote and is behind, pull/rebase (or merge) **before** coding. Do not invent a large change set against a stale local HEAD.
- **End of agent run:** if the run changed files, compose logical commits and push before the final reply (skill `push-code`; detail `general/end-of-run.md`). Skip only if the user said not to commit/push.
- **Sync skills/rules on drift:** when discovery install, always-on paste, or `$AGENT_RULES_PATH` SHA drifts from the shared reference (`dev-centr/agent-rules`), run skill `sync-agent-rules` and apply updates (stamp `AGENT_RULES_SYNCED_SHA` + `AGENT_RULES_SYNCED_LABEL` / `skills-set/*` in `$CODE_ROOT/harness.md`).
- **Hive remotes (prefer hive-watch):** do not `git fetch` the whole hive at chat start. Read **Last checked** in `$CODE_ROOT/machine.md` (hive-watch block) and `$CODE_ROOT/hive-watch.status.json`. If checked within **24h**, trust the status file; pull only repos you will edit that show behind. If stale, run [**hive-watch**](https://github.com/dev-centr/hive-watch) once (skill `hive-watch`). Detail: `general/hive-watch.md` in the agent-rules clone.
- Python: always `venv`; prefer `uv` over `pip`; install `uv` in scripts if missing.
- Build failures: fix project code over downgrading deps; missing icon → stop loop, placeholder or ask.
- Task lists in files: mark done with checkmark emojis.
- Changelogs: match the repo’s existing style; owned-project layout is skill `owned-changelog`.
- **This-machine paths:** read `%USERPROFILE%\.cursor\rules\` (local `.mdc`; not Settings User Rules). Cursor Settings User Rules sync across machines — never put hive or drive letters there.
- Never write secret values into git, docs, `MEMORIES.md`, or `.env.example` (name-only registry: skill `env-names-registry`).
- **Web fonts:** prefer self-hosting (Fontsource / local `woff2` + preload); do not `@import` Google Fonts or wait on a CDN for first paint. Detail: `general/self-host-fonts.md` (skill `self-host-fonts`).

## Environment
- OS/Shell: Windows 10/11 + PowerShell 7 unless told otherwise.
- **Code hive:** Windows User env `%code%` (= `CODE_ROOT`) is the short hive root. Prefer that over `%USERPROFILE%\code` (path length). Resolve `$env:code` / `$env:CODE_ROOT` before inventing paths; never keep a second hive under the user profile.
- Path refresh after tool installs:
  ```powershell
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  ```
- Node: `pnpm` (create/install); `pnpm dlx` one-offs; `pnpm exec` project bins.
- Git hosts: prefer MCP; else `gh` / `glab`.

## Repos
- Owned: `$CODE_ROOT/<host>/<owner>/<repo>`
- Forks: `$CODE_ROOT/<host>/<owner>/.forks/<repo>`
- Clones: `$CODE_ROOT/<host>/.clones/<owner>/<repo>`
- Hosts: usually `github.com` or `gitlab.com`.

## Creator (owned orgs)
- Transfers: `gh api`.
- **Agent rules:** canonical template is `dev-centr/agent-rules`. Each owned org this hive initializes gets `{org}/agent-rules` (pointer README + thin org `AGENTS.md` — **no submodule**; clone/fetch `dev-centr/agent-rules`). House workflow, not a requirement for every GitHub org. `{org}/.github/AGENT-RULES.md` is a pointer only — do not submodule rules into `.github`. Shared changes: PR `dev-centr/agent-rules`; org-only: commit wrapper `AGENTS.md`. Script: `dev-centr/agent-rules/scripts/setup-org-agent-rules-wrapper.ps1`.
- Config: SDL preferred; else JSON5 (`.json5` over `.json`).
- Changelog: every owned project, functional changes — skill `owned-changelog`.
- Issues: file for bugs, blockers, and external coordination — not routine owned-repo work (skill `owned-changelog`). When filing: skills `issue-reports` + `issues-repo-record` (when `ISSUES_REPO` set; always push); never chat-only.

## Docs
- Structure: Diátaxis (tutorials, how-to, explanation, reference).
- Format: AsciiDoc by default; retain Markdown on upstream forks; keep/add Markdown when a package registry only parses Markdown.
- Titles: follow site `STYLE.adoc` / `AGENTS.md` (not MEMORIES). **News = outward**; **blog = inward**. First-party news omits org; action essays pass implied [On]; prefer `X as Y` / *when* / disproof / questions; attach floating modifiers to an object; Antora topics = concept names. Philosophy: `Titles as orientation` (HCI Nerdz + ryanjohnson.dev). Cursor rules = `.cursor/rules/*.mdc` dir; this file stays the paste preamble.
- Project facts for agents: `AGENTS.md` + README/docs. Do not commit per-repo `MEMORIES.md`.
- On demand (do not inline): team skills in `dev-centr/agent-rules/skills/` — `antora-org-site`, `public-readme`, `ship-app`, `draft-pr`, `issue-reports`, `issues-repo-record`, `writing-news`, `writing-blog`, and `skills/CATALOG.md`. Personal-only: `talk-normal`.

## AI ops
- AsciiDoc: checklists `* [ ]`; blank line after **bold** headings; list continuations `+`; images `image::`.
- MEMORIES: **only** `$CODE_ROOT/MEMORIES.md` (sys-wide workstation facts). Create if missing. Usage counter from 1; increment on use. Gitignored / never committed. Read it when environment facts matter. Format example: `$CODE_ROOT/github.com/AMDphreak/agent-rules/MEMORIES.example.md`.
- Stale APIs: Context7 MCP (https://context7.com/); else skill `outdated-code-protocol`.
- Commits / push / PRs: skills `git-commit`, `push-code`, and `draft-pr`. At end of any run that changed files, load `push-code` (standing auth). Load `draft-pr` when opening a PR.
- Cursor skills: junction `dev-centr/agent-rules/skills/<name>` into `~/.cursor/skills/<name>/`. On drift: skill `sync-agent-rules`. Personal packs: `skills/CATALOG.md` in this fork. Do **not** paste skill bodies here. Skill `write-a-skill`: description field = trigger words, not a lay blurb.
