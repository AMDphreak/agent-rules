---
name: talk-normal
description: >-
  Use when the user asks for talk-normal, natural less-templated assistant
  voice, hexiecs/talk-normal, or less robotic writing style from that repo.
---

# talk-normal (optional tone)

Load only when the user **explicitly** asks. Supplemental — user chat rules, repo `AGENTS.md`, and `profiles/*.md` win on conflict. Do **not** fork upstream unless they ask.

## Clone

Read-only third-party clone (see `general/folder-schema.md`):

`$CODE_ROOT/github.com/.clones/hexiecs/talk-normal`

If missing:

```powershell
New-Item -ItemType Directory -Force -Path "$CODE_ROOT/github.com/.clones/hexiecs" | Out-Null
git clone https://github.com/hexiecs/talk-normal.git "$CODE_ROOT/github.com/.clones/hexiecs/talk-normal"
```

Then read the prompt files in that clone and apply them to prose in this session.
