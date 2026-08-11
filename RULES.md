# Agent Rules
<!-- Consolidated agent preamble. Paste into User Rules / AGENTS.md. Detail lives in general/*.md when assembling from MAIN.md. -->

## Constants
- CODE_ROOT: `C:\code`
- GITHUB_USER: `amdphreak`
- ISSUES_REPO: `C:\code\github.com/AMDphreak/.issues`
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
- **Code hive:** Windows User env `%code%` (= `CODE_ROOT`) points at the short root (`C:\code` or `Z:\code`). Prefer that over `%USERPROFILE%\code` (path length). Resolve `$env:code` / `$env:CODE_ROOT` before inventing paths; never keep a second hive under the user profile.
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
- Changelog: every project; functional changes; README links to it; index + `changelog-details/date - title`; backfill from git if missing; wire into docs; alert user if cross-org secrets are required.

## Docs
- Structure: Diátaxis (tutorials, how-to, explanation, reference).
- Format: AsciiDoc by default; retain Markdown on upstream forks; keep/add Markdown when a package registry only parses Markdown. See `general/readme-layout.md`.
- Antora: Valentus + org branding; follow `dev-centr/docs` essentials — Lunr on every site; AI search via `antora-supplemental/antora-search-chat` (alert user and wait if the org/extensions cannot be found); versioned components need `@antora-supplemental/alias-component-to-latest` (or equiv) until core opt-in; prefer comments on antora/antora#291 over duplicate issues.
- **Math on every docs site:** enable rendering even when unused (Antora `stem: latexmath` + KaTeX/`site-math.js`; Markdown `remark-math` + `rehype-katex`). Prefer `stem:[...]` / `$...$` over raw formula prose.
- **One Antora site per org** with a hub: wire `docs/` into the hub playbook; never publish a second Antora site on project GitHub Pages. See `general/antora-docs-sites.md`.
- **Public README layout:** when creating/revising GitHub-facing READMEs, follow `general/readme-layout.md` (Best-README adapted: centered for-the-badge chrome, **Explore the docs »** → org hub, TOC if >3 sections, role-grouped Built With, back-to-top). Do not add Docs/CI shields that break the established look. Hand-edit per repo.
- Titles: follow site `STYLE.adoc` / `AGENTS.md` (not MEMORIES). **News = outward** (shared record); **blog = inward** (ideas, ideals, philosophy, tutorials, thinking in public). Short defaults — first-party news omits org; action essays pass implied [On] and drop surplus *the*; prefer `X as Y` / *when* / disproof / questions over rigid `X is Y`; attach floating modifiers to an object; Antora topics = concept names. Philosophy: `Titles as orientation` (HCI Nerdz + ryanjohnson.dev). Cursor rules = `.cursor/rules/*.mdc` dir; this file stays the paste preamble.
- Project facts for agents: `AGENTS.md` + README/docs. Do not commit per-repo `MEMORIES.md`.
- **App shipping architecture:** when scaffolding/building/shipping apps (GUI, CLI, TUI, libs, games, services), read `general/app-architecture.md` and adhere to local Software Product Essentials at `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/explanation/architecture/` (hub: `software-product-essentials.adoc`). About/build info, debug dump, Windows auto-update, installers, and CI release pipelines are core—not polish.

## AI ops
- AsciiDoc: checklists `* [ ]`; blank line after **bold** headings; list continuations `+`; images `image::`.
- MEMORIES: **only** `$CODE_ROOT/MEMORIES.md` (sys-wide workstation facts). Create if missing. Usage counter from 1; increment on use. Gitignored / never committed. Read it when environment facts matter. Format example: `$CODE_ROOT/github.com/AMDphreak/agent-rules/MEMORIES.example.md`.
- Stale APIs: Context7 MCP (https://context7.com/); else Outdated Code Protocol.
- talk-normal (only if asked): prompts under `$CODE_ROOT/github.com/.clones/hexiecs/talk-normal`; clone if missing; do not fork unless asked; user/project rules win on conflict.
- writing-news-vs-blog (news/blog body copy only): Cursor skill — canonical `skills/writing-news-vs-blog/`; do **not** paste full directives into always-on User Rules; titles stance stays under Docs above.
- Outdated Code Protocol: `AI-LOCAL-LIBRARY-DOCS.local.json5` + `docs/_local-library-docs/`; prefer local indexed docs/source; for Dlang prefer cloning source.
