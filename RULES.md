# Agent Rules
<!-- Consolidated agent preamble. Paste into User Rules / AGENTS.md. Detail lives in general/*.md when assembling from MAIN.md. -->

## Constants
- CODE_ROOT: `Z:\code`
- GITHUB_USER: `amdphreak`
- ISSUES_REPO: `Z:\code\github.com\AMDphreak\.issues`
- ENVIRONMENT: `windows`
- MEMORIES: `$CODE_ROOT/MEMORIES.md` (sys-wide, machine-local — not per repo)

## Core
- Plain language: keep explanations easy to read.
- Gitignore: allow-list (`*` then `!path`); update when adding files. Do **not** allow-list `MEMORIES.md` (keep it ignored).
- **Sync with remote before multi-file work:** in each affected git repo, `git fetch` and check `git status -sb` for `behind`. If the branch tracks a remote and is behind, pull/rebase (or merge) **before** coding. Do not invent a large change set against a stale local HEAD.
- Python: always `venv`; prefer `uv` over `pip`; install `uv` in scripts if missing.
- Build failures: fix project code over downgrading deps; missing icon → stop loop, placeholder or ask.
- Task lists in files: mark done with checkmark emojis.
- Changelogs: match the repo’s existing style.

## Environment
- OS/Shell: Windows 10/11 + PowerShell 7 unless told otherwise.
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
- Issues: draft in `ISSUES_REPO` per its instructions; never only in the command.
- Config: SDL preferred; else JSON5 (`.json5` over `.json`).
- Changelog: every project; README links to it; timeline + `changelog-details/date - title`.

## Docs
- Structure: Diátaxis (tutorials, how-to, explanation, reference).
- Format: AsciiDoc unless host requires Markdown (e.g. npm).
- Antora: follow `dev-centr/docs` essentials — Lunr on every site; versioned components need `@antora-supplemental/alias-component-to-latest` (or equiv) until core opt-in; prefer comments on antora/antora#291 over duplicate issues.
- Titles: follow site `STYLE.adoc` / `AGENTS.md` (not MEMORIES). Short defaults — first-party news omits org; action essays pass implied [On] and drop surplus *the*; prefer `X as Y` / *when* / disproof / questions over rigid `X is Y`; attach floating modifiers to an object; Antora topics = concept names. Philosophy: `Titles as orientation` (HCI Nerdz + ryanjohnson.dev). Cursor rules = `.cursor/rules/*.mdc` dir; this file stays the paste preamble.
- **Pull requests:** when opening or drafting a PR, read `general/pull-requests.md`. **Title** in simple plain language. **Summary/intro** in inviting plain English (lead with the human problem; short bullets; soft close). **UI-visible** changes need before/after screenshots at minimum. Tone: gift to maintainers, not a lecture.
- Project facts for agents: `AGENTS.md` + README/docs. Do not commit per-repo `MEMORIES.md`.
- **App shipping architecture:** when scaffolding/building/shipping apps (GUI, CLI, TUI, libs, games, services), read `general/app-architecture.md` and adhere to local Software Product Essentials at `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/explanation/architecture/` (hub: `software-product-essentials.adoc`). About/build info, debug dump, Windows auto-update, installers, and CI release pipelines are core—not polish.

## AI ops
- AsciiDoc: checklists `* [ ]`; blank line after **bold** headings; list continuations `+`; images `image::`.
- MEMORIES: **only** `$CODE_ROOT/MEMORIES.md` (sys-wide workstation facts). Create if missing. Usage counter from 1; increment on use. Gitignored / never committed. Read it when environment facts matter. Format example: `$CODE_ROOT/github.com/AMDphreak/agent-rules/MEMORIES.example.md`.
- Stale APIs: Context7 MCP (https://context7.com/); else Outdated Code Protocol.
- talk-normal (only if asked): prompts under `$CODE_ROOT/github.com/.clones/hexiecs/talk-normal`; clone if missing; do not fork unless asked; user/project rules win on conflict.
- Outdated Code Protocol: `AI-LOCAL-LIBRARY-DOCS.local.json5` + `docs/_local-library-docs/`; prefer local indexed docs/source; for Dlang prefer cloning source.
