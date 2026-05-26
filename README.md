# claude-memory-kit

A tiny, portable methodology for giving Claude Code a **compounding, file-based
memory** — the "lite" memory-management tier of an LLM wiki. Drop it into any
project (work or personal) and Claude starts remembering durable facts across
sessions.

This repo is the **template**. Your real facts never live here — see
*Using it at work* below.

## What's in here

| File | What |
|---|---|
| `CLAUDE.md` | The methodology. Claude Code auto-loads it; it defines the memory rules. |
| `memory/MEMORY.md` | Example index — one line per memory, loaded each session. |
| `memory/*.md` | Two **generic** example facts so you can see the format. |
| `bootstrap.sh` | Scaffolds the kit into a target project with a *clean, empty* memory. |

## The idea

Every session writes a little; every future session starts shorter and smarter.

- `MEMORY.md` = a short index, always loaded.
- One **fact per file**, pulled on demand by relevance.
- Four types: `user`, `feedback`, `project`, `reference`.

Full rules: see [`CLAUDE.md`](CLAUDE.md).

## Using it at work

```bash
git clone https://github.com/OC15141355/claude-memory-kit.git
cd /path/to/your-work-project
/path/to/claude-memory-kit/bootstrap.sh .
```

`bootstrap.sh`:
- copies `CLAUDE.md` into the target (or, if one already exists, writes
  `CLAUDE.memory.md` and tells you to `@import` it),
- creates a **fresh, empty** `memory/MEMORY.md`.

Then open Claude Code there — it reads `memory/MEMORY.md` each session and grows
it as you work.

> ⚠️ **Your work facts stay in your work project, not in this public template.**
> Don't push real memories back to this repo. If you want them backed up, do that
> in a private/local spot of your own choosing.

## Relationship to Claude Code's built-in memory

If your Claude Code has the built-in auto-memory feature, this complements it:
same conventions (a `MEMORY.md` index + frontmatter fact files), just made
explicit and portable so behaviour is identical everywhere — including boxes
where the feature isn't enabled.

## Heavier tier (not included)

This is the memory-only slice. The full LLM-wiki pattern (immutable `raw/`
sources, curated `active/`, derived `wiki/`, append-only `log.md`, ingest
cadences) is a separate, heavier system — deliberately left out here.
