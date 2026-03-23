# Environment and preferences

<!---
ENVIRONMENT RULES MANIFEST — rules specific to the preferred OS, shell, CLI tools, and local path schema.
--->

## Operating system and CLI

- You are on Windows 11 and PowerShell 7.
- Whenever you install a new tool in PowerShell and it adds itself to the `PATH`, refresh the environment with `$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")`
- Use `pnpm`. For one-off package execution, use `pnpm dlx`; use `pnpm exec` for binaries from installed dependencies.
- Use `uv` instead of `pip`. Scripts should install `uv` if not present.
- Use MCPs to interact with repos. If no MCP is available or MCP cannot perform that operation, use `gh` and `glab` commands. If those are unavailable, try to install them or alert the user.

## Local Git strategies

- Clone git repositories using `general/folder-schema.md` with root set to the `CODE_ROOT` constant from your active `profiles/*.md` file.
- Use AsciiDoc for README unless Markdown is explicitly requested.
- Do not rename `README.md` files that are made for package hosts like npm.

## Outdated code protocol fallback

*(Fallback strategy if Context7 is ignored)*

- Create a repo-local workflow for AI agents and developers.
- For that workflow, strongly prefer repo-local indexed docs or source over web search when the repo uses AI or RAG indexing and API accuracy matters.
- Standard structure for that workflow:
  - committed template manifest: `AI-LOCAL-LIBRARY-DOCS.example.json5`
  - ignored machine-local manifest: `AI-LOCAL-LIBRARY-DOCS.local.json5`
  - ignored local docs or source cache inside the repo: `docs/_local-library-docs/`
  - refresh or bootstrap script in `scripts/` to clone or update those docs or source repositories
- The filename `AI-LOCAL-LIBRARY-DOCS.local.json5` is intentionally loud so AI tools notice it. Use that exact name unless the user asks otherwise.
- Add `.gitignore` entries for `AI-LOCAL-LIBRARY-DOCS.local.json5` and `docs/_local-library-docs/` when setting this up.
- Document this workflow in the repo README and docs so new developers and AI agents know to initialize it before doing version-sensitive dependency work.
- In that documentation, tell AI to search local cloned docs or source first, then use web search only when local docs are missing, stale, or clearly not the version in use.
- For D and similar ecosystems, prefer cloning the source repositories because doc comments, examples, and actual implementation are often all needed to resolve API truth.
- If a developer wants a writable personal copy of a docs or source repo, prefer one local clone with multiple Git remotes (`origin` for the fork, `upstream` for the source project) instead of multiple duplicate local clones.
- If many repositories on the same machine need the same supporting docs or source repositories, prefer a shared local Git cache or reference clone strategy. Use normal Git features like additional remotes, `git clone --reference` or `--reference-if-able`, or a local mirror cache. Avoid requiring hardlinks or symlinks as the primary strategy for large shared trees.
- If web search is chosen instead of local docs, make that an explicit project decision in docs and tell AI to verify each dependency against upstream docs rather than trusting model memory.
