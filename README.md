# Agent rules

Ryan's fork of [`dev-centr/agent-rules`](https://github.com/dev-centr/agent-rules). Contribute portable changes to [`dev-centr/agent-rules`](https://github.com/dev-centr/agent-rules). **This fork** ([`AMDphreak/agent-rules`](https://github.com/AMDphreak/agent-rules)) carries personal defaults on top of that story.

**Dev-Centr product behavior** (when the app acts on behalf of the user) does **not** live here. It belongs in [dev-centr/devcentr-agent-rules](https://github.com/dev-centr/devcentr-agent-rules).

## Architecture

```mermaid
flowchart TB
  subgraph forkable [agent-rules forkable]
    G[general/]
    P[profiles/]
    R[RULES.md]
    M[README.md]
  end
  subgraph product [devcentr-agent-rules]
    X[Dev-Centr product rules]
  end
  subgraph personal [Optional local only]
    Z[CODE_ROOT shortcut or symlink]
  end
  subgraph other [dev-centr/templates]
    W[workspaces payloads docs]
  end
  M --> P
  R --> P
  R --> G
  Z -.-> forkable
  other -->|README links| forkable
  product -.->|used by Dev-Centr app| other
```

- **agent-rules** (this repo family): forkable end-user instructions and profiles.
- **devcentr-agent-rules**: rules for when the Dev-Centr app acts on behalf of the user (separate repository).
- **templates**: project templates; README there links to forkable agent rules, not to personal copies.

## Quick start

1. Clone into your code hive, for example `$CODE_ROOT/github.com/<your-username>/.forks/agent-rules` (see `general/folder-schema.md`).
2. **Supported compose/watch:** install [`dev-centr/rules-manager`](https://github.com/dev-centr/rules-manager). Set `rules_repo_path` to this clone. Hostname → `laptop` / `desktop` lives in rules-manager config. Output: `$CODE_ROOT/agent-rules.composed.md` (never commit).
3. **Temporary path hack only:** a junction such as `…/AMDphreak/agent-rules` → `.forks/agent-rules` may exist for short paths; do not require it once rules-manager is configured.
4. Use `profiles/laptop.md` / `profiles/desktop.md` (constants) and `profiles/*.overlay.md` (machine-only bullets). Templates `my-laptop.md` / `my-desktop.md` remain for forks that rename profiles.
5. **`RULES.md` is written for the agent**. Paste **`RULES.md`** or the composed file into Cursor User Rules / AGENTS.md after filling constants (or let rules-manager fill from the active profile).

### Profile constants (your `profiles/*.md`)

| Constant | Required? | Purpose |
|----------|-----------|---------|
| `CODE_ROOT` | Yes | Root directory where you clone Git repos (see `general/folder-schema.md`). |
| `ENVIRONMENT` | Yes | `windows`, `mac`, or `linux` — selects `general/windows.md`, `general/mac.md`, or `general/linux.md`. |
| `GITHUB_USER` | No | Your username for path examples and org layouts. |
| `ISSUES_REPO` | No | Path to your `.issues` repo if you use that workflow. |

## Consolidated Rules (Fallback)

If your AI agent has difficulty reading multiple files from disk or refuses to follow the "1-step assembly" instructions in `RULES.md`, you can use the **[CONSOLIDATED_RULES.md](file:///Z:/code/github.com/amdphreak/agent-rules/CONSOLIDATED_RULES.md)** file instead.

This file blends the modular rules and profile constants into a single document, suitable for direct pasting into a system prompt or custom instructions field.

## Pointing the agent at this repository

When you paste `RULES.md` into your agent and define `$AGENT_RULES_PATH`, you are commanding the AI to perform a batched semantic read of all foundational modules simultaneously using its native tools (e.g., `view_file`, `read_file`). This prevents multi-turn ping-pong delays and avoids the common truncation issues associated with traditional CLI `cat` output.

The agent will automatically pull:

1. `profiles/<infer-profile-name>.md`
2. `general/global.md`
3. `general/environment.md`
4. `general/<windows|mac|linux>.md`
5. `general/creator.md`
6. `general/folder-schema.md`
(and `general/documentation.md` / `general/app-architecture.md` selectively).

Create **`$CODE_ROOT/MEMORIES.md`** for workstation facts (see **Machine-local memories** below). Do not commit per-repo `MEMORIES.md`.

For **Dev-Centr automation** acting on behalf of the user, the product should load rules from [devcentr-agent-rules](https://github.com/dev-centr/devcentr-agent-rules), not from this forkable repo.

## Machine-local memories

Canonical file: **`$CODE_ROOT/MEMORIES.md`** (e.g. `Z:\code\MEMORIES.md`). Workstation-only; never commit.

Committed template / format: link:MEMORIES.example.md[`MEMORIES.example.md`].

`MEMORIES.md` inside **this** `agent-rules` clone remains gitignored for backwards compatibility, but prefer `$CODE_ROOT/MEMORIES.md` so every harness finds one sys-wide file.

Do **not** commit per-repo `MEMORIES.md`. Project facts → `AGENTS.md` + docs.

Example line:

```text
Flutter SDK: `C:\flutter-sdk\flutter\bin` — refresh PATH if `flutter` missing (counter: 1)
```

## Relation to Dev-Centr templates

Project templates (workspaces, payloads, template docs) live in [dev-centr/templates](https://github.com/dev-centr/templates). That repo **links** to agent rules here; it should not embed a second copy of personal rules.

## License

Add a license file if you want this fork to be reusable by others.
