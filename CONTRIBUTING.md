# Contributing

## Upstream

Portable rules belong in `general/`.

When `https://github.com/dev-centr/agent-rules` exists, open pull requests there for shared improvements. Keep personal constants and org-specific examples in your fork (for example [`AMDphreak/agent-rules`](https://github.com/AMDphreak/agent-rules)).

**Dev-Centr product behavior** (automation acting for the user) belongs in [dev-centr/devcentr-agent-rules](https://github.com/dev-centr/devcentr-agent-rules), not in this repository.

## Profiles

Add new device templates under `profiles/` with clear constant names. Prefer one file per machine or role rather than many overlapping names. Include **`ENVIRONMENT`** (`windows`, `mac`, or `linux`) so agents load the correct `general/<os>.md` file.

## Suggestions

Optional playbooks live under `suggestions/` (not assembled by `MAIN.md` unless you wire them). Keep them debranded; put personal instances in an "Example instance" section you can strip when contributing upstream. Matching Cursor rules use `alwaysApply: false` under `.cursor/rules/`.
