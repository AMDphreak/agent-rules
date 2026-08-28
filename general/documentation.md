# Documentation (optional layer)

Read this file when you **author, structure, or publish** project documentation for repositories the user owns. Skip it for pure code tasks with no doc impact.

## Illustrations and figures (default)

When you **add or substantially update** visitor-facing docs (explanations, how-tos, curated lists, architecture, onboarding), ship **at least one orientation visual** unless the page is pure tabular reference or a thin changelog stub.

Prefer: local Mermaid/PlantUML/SVG under `modules/.../images/`, then screenshots/mockups, then source stills (e.g. YouTube thumbnails saved locally for Antora). Quote AsciiDoc alts that contain commas. Wall-of-text concept pages without a figure are incomplete. Shared detail also in `dev-centr/agent-rules` `general/documentation.md` when that clone is the sync source.

## Structure

- **Diátaxis** (tutorials, how-to, explanation, reference).
- Public README face: skill **`public-readme`**.
- **Antora hubs:** skill **`antora-org-site`** (Valentus lean; **Facto** compose pack `antora-supplemental/antora-facto` — confirm). Encoding: skill **`fix-docs-encoding`**. Org detail when present: `dev-centr/agent-rules` `agents/engineering/antora.md`.
- Changelogs: skill **`owned-changelog`**. Shippable apps: skill **`ship-app`**. PRs: skill **`draft-pr`**.

## Titles for news, blogs, and essays

When authoring or reviewing titles:

1. **First-party news** — omit the org; notification line (`Feature added…`) unless another actor did it.
2. **Action essays** — invisible **[On]**; drop surplus *the*; no bare imperatives.
3. **Framing** — prefer `X as Y`, process nouns, `A X is Y`, *when*, disproof, or identity questions over rigid `X is Y`.
4. **Modifiers** — attach to an object (`top-level organization`).
5. **Docs topics** — concept names.
6. One idea per news item; big idea first; human names before CLI tokens when possible.

See each site’s `STYLE.adoc`. Philosophy essays: **Titles as orientation** (HCI Nerdz + ryanjohnson.dev). Cursor `.cursor/rules/*.mdc` is a **directory**, not one file. Project agent facts → `AGENTS.md`. Workstation facts → `$CODE_ROOT/MEMORIES.md` only.

News/blog **body** → skills `writing-news` / `writing-blog`.
