# Cursor Composer agent routing (personal profile)

**Scope:** Cursor IDE on this harness (`HARNESS_NAME = cursor`), especially when the parent chat runs **Composer 2.5 Fast** as coordinator. Not for Cloudflare Workers-only flows, Antora-only doc agents, or non-Cursor CLIs unless the user explicitly opts in.

**Machine install:** copy or junction `$AGENT_RULES_PATH/.cursor/rules/cursor-composer-agent-routing.mdc` into `$LOCAL_RULES_DIR` with `alwaysApply: true`. Do not paste this body into Cursor Settings User Rules (those sync across machines).

## Models (Task `model` slugs)

### Composer 2.5 Fast (`composer-2.5-fast`)

- **Best for:** Fast implementation, mechanical refactors, multi-file edits, low-latency scaffolding, **coordinator triage** in standing org/product chats.
- **Strengths:** Predictable diffs, low token overhead, generous plan limits, follows instructions without over-architecting.
- **Weaknesses:** Deep planning, unfamiliar abstractions, long research threads.

### Grok 4.6 (`cursor-grok-4.6-high`)

- **Best for:** Cost-effective reasoning, architecture sanity checks, code review, medium research.
- **Strengths:** Balance of intelligence and token cost; more responsive than 4.7.
- **Weaknesses:** Sometimes hesitant in agent mode without a nudge to finish edits.

### Grok 4.7 (`grok-4.7-high`)

- **Best for:** Hard edge-case logic, gnarly debugging, provider-policy research, large canvas summaries.
- **Strengths:** Strong reasoning on tricky logic.
- **Weaknesses:** High token use; more stubs and verbosity than surgical diffs — avoid for routine whole-file writes.

## Practical routing

1. **Default workhorse:** Composer 2.5 Fast for defined edits, tickets, and coordinator replies.
2. **Review / architecture:** Grok 4.6 for plans and second opinions.
3. **Targeted escalation:** Grok 4.7 only for hard blocks or heavy research — not as default implementer.

When spawning Task subagents, pass an explicit `model` when it differs from the parent. Use parent model only when it already matches the job. If the user names a model, use it. Do not treat “newest Grok” as default.

**Subagent types (Cursor):** `explore` for codebase search; `generalPurpose` for mixed research; `bugbot` / `security-review` only when the user asks; `environment: cloud` only when the user wants a cloud worker on a repo branch.

## Coordinator workspace (inbox chats)

Standing coordinator chats (JobTangent, Dev-Centr inbox, Master) are **themed inboxes**, not the product repo root.

- **Do not** call `move_agent_to_root` into `$CODE_ROOT/.../career-journey` (or another product clone) just because the conversation is about that product.
- **`move_agent_to_root` back to home / empty-window often fails** — Cursor expects a real project folder, not an arbitrary non-repo path.
- **Repo edits:** spawn a **cloud worker** (`Task`, `environment: cloud`) on the target repo, or ask the user to use a **repo-scoped** chat. The coordinator commits/reviews via PR links; it does not re-root itself.

Deeplinks with `workspace=career-journey` only for chats intentionally opened on that repo—not for cross-org briefings.

## Subagent chaining (recursive)

Every layer — parent chat, Task workers, and children they spawn — should:

1. **Size the job** (depth, ambiguity, research vs mechanical edit vs implementation).
2. **Execute locally** when narrow (few tool steps).
3. **Delegate** when context is large, reasoning is deep, or the change set would sprawl.
4. **Pass this same four-step rule** in the child brief so delegation can recurse.

Do not hoard work to save subagent calls; do not delegate a one-file grep. Coordinators stay on Composer; children pick models per the sections above.

## Parallel git (when workers touch repos)

When multiple subagents edit git repos in one wave, workers **commit locally only**; the coordinator batches push after the wave (`general/parallel-git-closeout.md` in team `dev-centr/agent-rules`). Put `GIT_CLOSEOUT=commit-only` in worker briefs.
