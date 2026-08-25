# Machine overlay - laptop

Copy this file plus `profiles/laptop.md` constants into `%USERPROFILE%\.cursor\rules\machine.mdc` on this host (`alwaysApply: true`). Do not paste into Cursor User Rules (those sync).

- Prefer `C:\code` paths on this host (no `Z:` drive).
- Personal agent-rules clone: `C:\code\github.com\AMDphreak\.forks\agent-rules` (junction at `...\AMDphreak\agent-rules` is temporary until rules-manager path config is universal).
- Compose/watch via [dev-centr/rules-manager](https://github.com/dev-centr/rules-manager) (`rulesd` + tray); do not rely on junctions for day-to-day sync.
