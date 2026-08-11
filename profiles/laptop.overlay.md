# Machine overlay - laptop

- `%code%` / `CODE_ROOT` → `C:\code` (no `Z:` drive). Never use `C:\Users\...\code` as a second hive.
- Personal agent-rules clone: `%code%\github.com\AMDphreak\.forks\agent-rules` (junction at `...\AMDphreak\agent-rules` is temporary until rules-manager path config is universal).
- Compose/watch via [dev-centr/rules-manager](https://github.com/dev-centr/rules-manager) (`rulesd` + tray); do not rely on junctions for day-to-day sync.
