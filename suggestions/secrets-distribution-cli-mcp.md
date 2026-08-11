# Suggestion: Secrets distribution (CLI · MCP · hub)

> **Status:** suggestion (optional layer). Not loaded by `MAIN.md` unless you wire it.
> **Audience:** agents and humans moving API keys from vendor dashboards into local env and hosted deploy matrices without retyping on every host change.

## Intent

Create credentials **once in each vendor**. Store them **once** in a human vault (and optionally a deploy-time secrets hub). **Distribute** into local `.env*` and hosting env vars (Vercel, Netlify, Convex deploy keys, …) from that hub when the deployment matrix changes.

Do **not** treat the hosting dashboard as the long-term source of truth.

## Layers (debranded)

| Layer | Role | Typical tools |
|-------|------|----------------|
| Vendor | Create / rotate keys | Console UI; optional vendor CLI (`gcloud`, Square dashboard, …) |
| Human vault | Store login + **custom fields** for API keys | Bitwarden CLI (`bw`), 1Password CLI, … |
| Deploy hub (optional) | Org source of truth for apply/sync | Pulumi ESC, cloud secret manager |
| Hosting matrix | Runtime / build env | Hosting CLI (`vercel env`), IaC providers |
| Agent surface | Discover + operate | Shell CLIs first; MCP when it helps (hosting MCP, Composio, …) |

**Rule of thumb:** CLI for secrets you already unlocked locally. MCP for authenticated SaaS ops when the server is linked and has the right tools. Prefer the sharper tool for each step (e.g. vault CLI for custom fields; hosting CLI for `env add`).

## Agent workflow

1. **Inventory** required vars from `.env.example` / docs (never invent names).
2. **Unlock vault** (`bw unlock` / session). Search items; read **custom fields** and notes (prefix-check only in chat—do not paste live secrets into the transcript).
3. **Classify ownership:** personal-ok vs org email / Business app vs must-provision.
4. **Write local** ignored env file(s); generate signing secrets locally when missing (`BETTER_AUTH_SECRET`, encryption keys).
5. **Push hosting** for the **org/team** project (`vercel link` / `--scope`), Production + Preview as appropriate. Separate prod signing secrets from local.
6. **Report gaps** clearly (account exists but no key field; Client ID missing while secret present; wrong email on vendor).
7. **Hub later:** promote vault → ESC (or equivalent) so host/matrix changes are `pulumi up` / sync, not re-entry.

## Security habits

- Never commit `.env.local` / deploy keys.
- Do not echo full secrets in agent chat; use length/prefix checks.
- Lock the vault when finished; treat pasted session tokens as compromised.
- `NEXT_PUBLIC_*` is browser-visible—never put private keys there.
- Prefer **custom fields** on vault items over dumping secrets only in notes.

## Example instance (FoodTruckNerdz / Ryan)

Non-normative; strip if forking without this org.

* **Vault:** Bitwarden CLI; org logins under `ryan@foodtrucknerdz.com`; API material in custom fields (e.g. Convex deploy keys on `dashboard.convex.dev`).
* **Hosting:** Vercel team `FTN` / project `ftn-site-nextjs`; prefer `pnpm add -g vercel` (winget may lack the CLI).
* **Local:** `site-nextjs/.env.local`.
* **IaC:** org `infra` is **Pulumi** (DNS/email); app secrets stay out until ESC sync exists. Convex schema lives in the app repo, not infra.
* **MCP:** Vercel MCP optional if CLI is enough; Composio Bitwarden tools may be org-admin-only—use `bw` for vault items.
* **Meta/Facebook:** one personal identity → Business/Developer app; add org email as admin; store Client ID/Secret under FTN in the vault.

## Related docs

When available on the Dev-Centr hub:

* General knowledge — secrets distribution explanation, how-to, and tutorial
* IaC explanation (Pulumi ESC as distribution, not vendor creation)
