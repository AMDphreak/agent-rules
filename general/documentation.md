# Documentation (optional layer)

Read this file when you **author, structure, or publish** project documentation for repositories the user owns. Skip it for pure code tasks with no doc impact.

## Structure

- When you design documentation for a project, consider the **Diátaxis** model (tutorials, how-to, explanation, reference) so material is easy to navigate.

## Antora (when used)

- If the project uses **Antora**, follow the publishing and layout guidance in the Dev-Centr documentation repository: `dev-centr/docs` — especially `docs/modules/ROOT/pages/publishing/antora-essential-extensions.adoc` and `docs/modules/ROOT/pages/publishing/antora-ui-branding.adoc`.
- **Essential extension — alias component root → latest:** Versioned Antora components must not leave bare `/component/` as a 404. Enable `@antora-supplemental/alias-component-to-latest` (or equivalent) on every multi-version (or numbered-version) site until Antora core ships an opt-in for this. Treat it as required site plumbing, not optional polish.
- **Upstream:** Prefer commenting on existing Antora discussions ([antora/antora#291](https://gitlab.com/antora/antora/-/issues/291)) over opening duplicate issues. Goal: opt-in core playbook key (e.g. `urls.alias_component_to_latest: true`), same behavior as the documented extension use case.

## Relationship to creator rules

- Changelog placement and ownership expectations live in `general/creator.md`. This file covers **how** documentation is shaped and **when** Antora-specific paths apply.
