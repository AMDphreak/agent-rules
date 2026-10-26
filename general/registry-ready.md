# Registry-ready checklist (Antora extensions registry)

A package is registry-ready when the registry can read everything it shows from the package itself:

- Repository topics name its kind (for example `antora-theme`, `antora-ui-bundle`, `antora-extension`).
- `package.json` carries an `antoraRegistry` block with `antora` (supported major versions) and flat `requires` / `worksWith` / `conflictsWith` / `provides` / `uses` keys (no nested `relations` object). Add `colorSchemes` for themes.
- **Monorepo packages each need their own `antoraRegistry` block** in their own `packages/<name>/package.json`. Tag releases per package as `<package>-v<semver>` (for example `color-scheme-v0.5.3`) so the registry maps each tag to its package.
- Every package is listed in the repo's `registry-index.json`, with its `layer`.
- Forks declare their upstream (forge `forked_from`) and a description that says what the fork adds.