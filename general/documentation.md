# Documentation (optional layer)

Read this file when you **author, structure, or publish** project documentation for repositories the user owns. Skip it for pure code tasks with no doc impact.

## Structure

- **Diátaxis** (tutorials, how-to, explanation, reference).
- Public README face: skill **`public-readme`**; layout detail in `general/readme-layout.md`. Hand-edit per repo; do not batch-script cross-repo README rewrites.
- **Antora hubs:** skill **`antora-org-site`**; hub wiring in `general/antora-docs-sites.md`. Valentus lean; **Facto** compose pack `antora-supplemental/antora-facto` — confirm. Encoding: skill **`fix-docs-encoding`**. Org detail when present: `dev-centr/agent-rules` `agents/engineering/antora.md`.
- **Essential extension — Lunr search:** Every Antora site we publish must enable `@antora/lunr-extension` (install the package and register it under `antora.extensions`). Treat client-side search as required plumbing. Register Lunr before wrappers such as `@antora-supplemental/antora-search-chat`.
- **Essential extension — AI search/help:** Add the AI-assisted layer from **`antora-supplemental`** — prefer [`antora-search-chat`](https://github.com/antora-supplemental/antora-search-chat) (Lunr-first Search/Ask omnibox). Related: [`antora-ai-help-extension`](https://github.com/antora-supplemental/antora-ai-help-extension). If `antora-supplemental` (or those extensions) cannot be found after a reasonable search, **stop and alert the user** so they can notify whoever owns this automation rule — then wait for a reply.
- **Essential extension — alias component root → latest:** Versioned Antora components must not leave bare `/component/` as a 404. Enable `@antora-supplemental/alias-component-to-latest` (or equivalent) on every multi-version (or numbered-version) site until Antora core ships an opt-in for this. Treat it as required site plumbing, not optional polish.
- **Essential plumbing — math formulas:** Every docs site (Antora, Markdown/Astro, AsciiDoc marketing sites) must ship math rendering **even when the current page has no formulas**. Antora: playbook `asciidoc.attributes.stem: latexmath` plus KaTeX (`site-math.js` in Valentus / org supplemental-ui). Use `stem:[…]` / `[stem]` blocks for LaTeX. Markdown sites: `remark-math` + `rehype-katex` (or equivalent) and KaTeX CSS. Do not leave `$…$` / `Hash(Bytes_…)` as raw prose when the source discussion used math.
- **Upstream:** Prefer commenting on existing Antora discussions ([antora/antora#291](https://gitlab.com/antora/antora/-/issues/291)) over opening duplicate issues. Goal: opt-in core playbook key (e.g. `urls.alias_component_to_latest: true`), same behavior as the documented extension use case.
- Changelogs: skill **`owned-changelog`**. Shippable apps: skill **`ship-app`**. PRs: skill **`draft-pr`**.

## Relationship to creator rules

- Changelog placement and ownership expectations live in `general/creator.md`. This file covers **how** documentation is shaped and **when** Antora-specific paths apply.
- Shippable **product** architecture (About, updates, packaging, pipelines) lives in `general/app-architecture.md` and the local general-knowledge Software Product Essentials pages—not here.

## Titles for news, blogs, and essays

**Stance before title shape:**

- **News** faces **outward** — what entered the shared record (shipped, added, partnered).
- **Blog / essay** faces **inward** — ideas, ideals, philosophy, craft tutorials, working theories; often thinking in public.
- **Changelog** is neither — shipping minutiae stay in Antora / `/changelog`.

Essay: https://ryanjohnson.dev/blog/posts/blog-as-inner-thought/ · house STYLE: HCI-Nerdz `STYLE.adoc`.

When authoring or reviewing titles:

1. **First-party news** — omit the org; notification line (`Feature added…`) unless another actor did it.
2. **Action essays** — invisible **[On]**; drop surplus *the*; no bare imperatives.
3. **Framing** — prefer `X as Y`, process nouns, `A X is Y`, *when*, disproof, or identity questions over rigid `X is Y`.
4. **Modifiers** — attach to an object (`top-level organization`).
5. **Docs topics** — concept names.
6. One idea per news item; big idea first; human names before CLI tokens when possible.

See each site's `STYLE.adoc`. Philosophy essays: **Titles as orientation** (HCI Nerdz + ryanjohnson.dev). Cursor `.cursor/rules/*.mdc` is a **directory**, not one file. Project agent facts → `AGENTS.md`. Workstation facts → `$CODE_ROOT/MEMORIES.md` only (never per-repo `MEMORIES.md`).

## Body copy: news vs blog

Team skills **`writing-news`** / **`writing-blog`** cover org work. **Personal fork:** Cursor skill `writing-news-vs-blog` — on-demand; do not paste into User Rules.

- **Canonical (this repo):** `skills/writing-news-vs-blog/` (`SKILL.md`, `news.md`, `blog.md`, `published-sources.md`)
- **Cursor install:** `~/.cursor/skills/writing-news-vs-blog` (junction to the path above on this machine)
- **When:** drafting or revising news posts, ship notes, blog/essays, or when the user asks for news vs blog voice / lede / attribution / anti-slop article prose
- Read `SKILL.md`, pick mode, then follow `news.md` or `blog.md`. Do not load this skill for ordinary chat replies.
