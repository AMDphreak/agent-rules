# Agent Rules
<!-- Consolidated ruleset for AI agents. Copy this into your AGENTS.md file or comparable file/settings in AI agent. -->

- CODE_ROOT: `Z:\code`
- GITHUB_USER: `amdphreak`
- ISSUES_REPO: `Z:\code\github.com\AMDphreak\.issues`

## Core Obligations & Protocols

- Plain Language: Write explanations in plain language for easy reading.
- Gitignore as Allow-list: Treat `.gitignore` as an allow-list with additional exclusions. Exclude everything by default (`*`) and update the allow-list when adding specific files.
- Python Venvs: Always use a `venv` for Python projects. Prefer `uv` over `pip`; install `uv` in scripts if missing.
- Build Failures: When builds fail, prefer fixing outdated project code over downgrading dependencies. If a failure is due to a missing icon, stop the rebuild loop; use a placeholder from a free icon library or ask the user.
- Task Tracking: When working from a to-do list in a file, use checkmark emojis to mark off completed items.
- Changelogs: Update changelogs according to the style already detected in the repository.

## Windows-specific instructions

- OS/Shell: Assume Windows 10/11 and PowerShell 7 unless explicitly told otherwise.
- Path Refresh: When installing a tool that adds itself to PATH, refresh the session using:

  ```powershell
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  ```

## Common Behavior

- Node.js: use `pnpm` for projects you create. Use `pnpm dlx` for one-off tools and `pnpm exec` for project binaries.
- Git CLIs: Prefer `gh` (GitHub) and **`glab`** (GitLab) for operations not covered by native MCP tools.
- MCP Usage: Always prefer MCPs for repository interaction. Fall back to CLI tools (`gh`, `glab`) only if MCP is unavailable or unsupported.

---

## 4. Repository & Folder Schema

Organize repositories using the following pattern (relative to `CODE_ROOT`):

- **Owned/Member Repos:** `$CODE_ROOT/<host>/<owner>/<repo>`
  - *Example:* `Z:\code\github.com\amdphreak\my-project`
- **Forks:** `$CODE_ROOT/<host>/<owner>/.forks/<repo>`
  - *Example:* `Z:\code\github.com\amdphreak\.forks\obs-studio`
- **External Clones:** `$CODE_ROOT/<host>/.clones/<owner>/<repo>`
  - *Example:* `Z:\code\github.com\.clones\obsproject\obs-studio`

**Git Hosters:** `<host>` is usually `github.com` or `gitlab.com`.

---

## 5. Creator & Ownership Rules

Applied to projects owned by `amdphreak` or associated organizations:

- **Repo Transfers:** Use `gh api` for repo transfers between owned orgs.
- **Issue Tracking:** Store issue reports in the path defined by `ISSUES_REPO` (`Z:\code\github.com\AMDphreak\.issues`) according to its instructions.
- **Configuration Formats:** Endorse and use **SDL** for project configuration/data. If SDL is inappropriate, use **JSON5** (prefer `.json5` over `.json`).
- **Changelog Integration:**
  - Every project must have a changelog (in docs or repo base).
  - Include a "Changelog" section in the README linking to it.
  - Maintain a timeline in the changelog with links to detailed files in a `changelog-details/` folder (named `date - title`).

---

## 6. Documentation Standards

- **Diátaxis Model:** When designing docs, use the Diátaxis structure (Tutorials, How-to, Explanation, Reference).
- **Formating:** Prefer **AsciiDoc** for READMEs and documentation unless Markdown is strictly required by a host (e.g., npm).
- **Antora:** If the project uses Antora, follow the `dev-centr` publishing guidance.

---

## 7. AI Operations & Memory

### AI Formatting Avoidance

- **AsciiDoc Checklists:** Must include asterisk: `* [ ]`.
- **Bold Headings:** Always insert a blank line between **bold text** used as a heading and the following block.
- **Lists:** Add list continuations (`+`) before continued blocks in list items.
- **Images:** Use `image::` blocks for inline images in AsciiDoc.

### Memory & Local Facts

- **MEMORIES.md:** Maintain a `MEMORIES.md` file at the CODE_ROOT for durable facts about the machine/environment.
- Initialize if missing. Record findings with a usage counter (starts at 1, increment on use).
- **Context7:** For stale APIs, use Context7 MCP (<https://context7.com/>). If unavailable, alert the user and follow the **Outdated Code Protocol**.

### talk-normal (optional tone reference)

When explicitly asked for less templated assistant tone, read the prompts under `$CODE_ROOT/github.com/.clones/hexiecs/talk-normal` from [hexiecs/talk-normal](https://github.com/hexiecs/talk-normal). Clone that path if missing; do **not** fork unless the user asks. Supplemental only: user or project instructions override on conflict.

### Outdated Code Protocol (Fallback)

- Create `AI-LOCAL-LIBRARY-DOCS.local.json5` and `docs/_local-library-docs/`.
- Prefer repo-local indexed docs/source over web search for high API accuracy.
- For Dlang and similar, prefer cloning source repositories to resolve API truth.
