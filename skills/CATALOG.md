# Cursor skills (personal fork)

Team skills live in **`dev-centr/agent-rules/skills/`** (junction those into `~/.cursor/skills/`). This fork only lists **personal-only** packs.

| Skill | Triggers on | Status | Notes |
| --- | --- | --- | --- |
| `talk-normal` | "talk-normal", hexiecs/talk-normal, natural less-templated voice | active | Third-party prompts; user/project rules win |
| `bitwarden-unlock` | bitwarden, bw, BW_SESSION, BW_CLIENTID, bw login --apikey, bw-apikey.local.ps1, unlock_bitwarden.ps1, vault unlock | active | Workstation auth; API key login + unlock; never print/read secrets; templates in `scripts/` |

Upstream new portable skills to `dev-centr/agent-rules`. Inventory there: `skills/CATALOG.md`.
