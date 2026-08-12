# Documentation (optional layer)

Read this file when you **author, structure, or publish** project documentation for repositories the user owns. Skip it for pure code tasks with no doc impact.

## Structure

- When you design documentation for a project, consider the **Diátaxis** model (tutorials, how-to, explanation, reference) so material is easy to navigate.

## Antora (when used)

- If the project uses **Antora**, follow the publishing and layout guidance in the Dev-Centr documentation repository: `dev-centr/docs` — especially `docs/modules/ROOT/pages/publishing/antora-essential-extensions.adoc` and `docs/modules/ROOT/pages/publishing/antora-ui-branding.adoc`.
- **Essential extension — Lunr search:** Every Antora site we publish must enable `@antora/lunr-extension` (install the package and register it under `antora.extensions`). Treat client-side search as required plumbing. Register Lunr before wrappers such as `@antora-supplemental/antora-search-chat`.
- **Essential extension — alias component root → latest:** Versioned Antora components must not leave bare `/component/` as a 404. Enable `@antora-supplemental/alias-component-to-latest` (or equivalent) on every multi-version (or numbered-version) site until Antora core ships an opt-in for this. Treat it as required site plumbing, not optional polish.
- **Upstream:** Prefer commenting on existing Antora discussions ([antora/antora#291](https://gitlab.com/antora/antora/-/issues/291)) over opening duplicate issues. Goal: opt-in core playbook key (e.g. `urls.alias_component_to_latest: true`), same behavior as the documented extension use case.

## Relationship to creator rules

- Changelog placement and ownership expectations live in `general/creator.md`. This file covers **how** documentation is shaped and **when** Antora-specific paths apply.
- Shippable **product** architecture (About, updates, packaging, pipelines) lives in `general/app-architecture.md` and the local general-knowledge Software Product Essentials pages—not here.

## Titles for news, blogs, and essays

When authoring or reviewing titles:

1. **First-party news** — omit the org; notification line (`Feature added…`) unless another actor did it.
2. **Action essays** — invisible **[On]**; drop surplus *the*; no bare imperatives.
3. **Framing** — prefer `X as Y`, process nouns, `A X is Y`, *when*, disproof, or identity questions over rigid `X is Y`.
4. **Modifiers** — attach to an object (`top-level organization`).
5. **Docs topics** — concept names.
6. One idea per news item; big idea first; human names before CLI tokens when possible.

See each site’s `STYLE.adoc`. Philosophy essays: **Titles as orientation** (HCI Nerdz + ryanjohnson.dev). Cursor `.cursor/rules/*.mdc` is a **directory**, not one file. Project agent facts → `AGENTS.md`. Workstation facts → `$CODE_ROOT/MEMORIES.md` only (never per-repo `MEMORIES.md`).

## Pull request titles and summaries

When opening or drafting a PR, follow [`general/pull-requests.md`](./pull-requests.md): simple-language titles; inviting plain-English intros; screenshots for UI-visible changes.

