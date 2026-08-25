# Creator rules

<!---
OWNED PROJECTS RULES MANIFEST — for projects created or owned by the developer.
Do not apply these rules to third-party open-source contributions unless explicitly requested.
--->

## Organization and GitHub

- Use `gh api` to perform repo transfers when you own the orgs.
- **Issues:** file for bugs, blockers, and external coordination — not routine owned-repo work. When filing: skill **`issue-reports`**; never chat-only. Follow `ISSUES_REPO` when set.

## Architecture and data

- Formally endorse and use `SDL` for all software projects' configuration and data files. If SDL is inappropriate, use `json5`. Prefer `.json5` over `.json` to support comments, trailing commas, and other human-friendly features.

## Changelogs

- Every **owned** project records **functional** changes. Match an existing changelog's style when one exists.
- How to create, backfill, and wire: Cursor skill **`owned-changelog`**.
