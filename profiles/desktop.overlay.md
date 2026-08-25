# Machine overlay - desktop

Copy this file plus `profiles/desktop.md` constants into `%USERPROFILE%\.cursor\rules\machine.mdc` on this host (`alwaysApply: true`). Do not paste into Cursor User Rules (those sync).

- Prefer `Z:\code` paths on this host.
- Personal agent-rules clone under `$CODE_ROOT/github.com/AMDphreak/.forks/agent-rules` (or owned path); junctions/hardlinks are a temporary path hack only.
- Compose/watch via [dev-centr/rules-manager](https://github.com/dev-centr/rules-manager) (`rulesd` + tray).
