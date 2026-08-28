# Cursor skills (personal fork)

Team skills live in **`dev-centr/agent-rules/skills/`** (junction those into `~/.cursor/skills/`). This fork only lists **personal-only** packs.

| Skill | Triggers on | Status | Notes |
| --- | --- | --- | --- |
| `talk-normal` | "talk-normal", hexiecs/talk-normal, natural less-templated voice | active | Third-party prompts; user/project rules win |
| `bitwarden-unlock` | bitwarden, bw, BW_SESSION, ensure_bw_unlocked, session persist, BW_CLIENTID, bw login --apikey, unlock_bitwarden.ps1 | active | Workstation auth; local session reuse + API key login; never print/read secrets; templates in `scripts/` |

Upstream new portable skills to `dev-centr/agent-rules`. Inventory there: `skills/CATALOG.md`.
