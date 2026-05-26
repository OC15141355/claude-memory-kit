# Claude Memory Kit — lightweight file-based memory

Operating manual for a compounding, file-based memory that any Claude Code
session can read and extend. This is the **"lite" tier of an LLM wiki**: memory
holds short, always-true facts; longer-form knowledge (if you keep any) lives
elsewhere and is pulled on demand.

Goal: every session writes a little, so every future session starts shorter and
smarter. Works offline — no external service is load-bearing.

This file is intentionally **portable** — drop it into any project unchanged.

## First run on a new environment (auto-trigger)

At the start of a session, check `memory/MEMORY.md`. **If it's empty or absent,
this kit hasn't been provisioned here yet — proactively tell the user and offer to
onboard now by running [`SETUP.md`](SETUP.md). Don't wait to be asked.** SETUP.md
interviews the user about their workflows, learns the environment, and stands up an
environment-specific instance. Once memory has real entries, skip this.

## Companion: the review workflow

This kit ships a review methodology alongside memory:
- [`workflow/review-tiers.md`](workflow/review-tiers.md) — Tier 0 (single
  code-reviewer) vs Tier 1 (triple-loop).
- [`workflow/tier-routing.md`](workflow/tier-routing.md) — which tier a change
  gets, and how Tier-0 dispatches.
- `agents/` — ready-to-install `code-reviewer` / `devils-advocate` /
  `security-expert` subagent definitions for the triple-loop.

## Where memory lives

- `memory/MEMORY.md` — the **index**, loaded into context at the start of every
  session. One line per memory. Never holds fact content — only pointers.
- `memory/<slug>.md` — one **fact per file**, with frontmatter (below).

At session start: read `memory/MEMORY.md`. Pull an individual fact file into
context only when its one-line `description` looks relevant.

## Fact file format

Each memory is ONE file holding ONE fact:

```markdown
---
name: <short-kebab-case-slug>
description: <one-line summary — used to judge relevance during recall>
metadata:
  type: user | feedback | project | reference
---

<the fact. For feedback/project, follow with **Why:** and **How to apply:**
lines. Link related memories with [[their-name]].>
```

Link liberally with `[[name]]` (the other memory's `name:` slug). A `[[link]]`
to a memory that doesn't exist yet is fine — it marks something worth writing
later, not an error.

## The four types

- **user** — who the user is: role, expertise, durable preferences.
- **feedback** — guidance on how to work (corrections *and* confirmed
  approaches). Always include the why.
- **project** — ongoing work, goals, constraints not derivable from the code or
  git history. Convert relative dates to absolute ("yesterday" → the date).
- **reference** — pointers to external resources (URLs, dashboards, tickets).

## The index (MEMORY.md)

After writing a fact file, add ONE line to `memory/MEMORY.md`:

```
- [Title](slug.md) — short hook
```

One line per memory. No frontmatter. **Never put fact content in the index.**

## When to save

Save when you learn something that will matter in a FUTURE session:
- a durable user fact or preference,
- feedback on how to work (with the why),
- a project goal/constraint not in the code or git history.

## When NOT to save

- Anything the repo already records: code structure, past fixes, git history,
  existing `CLAUDE.md` content.
- Anything that only matters to the current conversation.
- If asked to "remember" something already in the code/history, ask what was
  *non-obvious* about it and save that instead.

## Hygiene

- **Dedupe:** before creating, check for an existing file that already covers it.
  Update that file rather than adding a duplicate.
- **Delete what's wrong:** a memory that turns out to be false gets removed, not
  left to rot.
- **Recall is point-in-time:** a memory reflects what was true when written. If
  it names a file, function, or flag, verify that still exists before acting on
  it.
- **Keep facts atomic:** one fact per file keeps recall precise and updates cheap.

## Bootstrapping at a new location

1. Put this `CLAUDE.md` in the project (or `@import` it from your global
   `~/.claude/CLAUDE.md`).
2. Create `memory/MEMORY.md` with just the index header.
3. Start working. Write memories as durable facts surface.

(`bootstrap.sh` in this kit does steps 1–2 for you, with a clean empty index.)
