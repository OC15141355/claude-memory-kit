# claude-memory-kit

A tiny, portable **operating kit for Claude Code** — it gives Claude a compounding
file-based memory *and* a tiered code-review workflow, then **provisions itself**
on a new environment. Clone it at work, tell Claude to set itself up, and it
learns the environment, seeds its memory, and stands up its own
environment-specific instance.

This repo is the **template**. Your real facts/config accumulate in your work
project, never here — see *Self-setup at work* below.

## What's in here

| Path | What |
|---|---|
| `SETUP.md` | **The agentic self-setup runbook.** Claude executes it to provision the kit on a new environment. |
| `CLAUDE.md` | The memory methodology. Claude Code auto-loads it. |
| `memory/MEMORY.md` | The index, loaded each session — one line per memory. |
| `memory/*.md` | Two generic example facts (format reference). |
| `workflow/review-tiers.md` | Tier 0 (single review) vs Tier 1 (triple-loop). |
| `workflow/tier-routing.md` | Which tier a change gets; how Tier-0 dispatches. |
| `agents/*.md` | `code-reviewer` / `devils-advocate` / `security-expert` subagent definitions for the triple-loop. |
| `bootstrap.sh` | Mechanical scaffold: copies the kit into a target + clean memory, then hands off to `SETUP.md`. |

## The two methodologies

**Memory** — every session writes a little; every future session starts shorter
and smarter. `MEMORY.md` is a short, always-loaded index; one fact per file, four
types (`user` / `feedback` / `project` / `reference`). Rules: [`CLAUDE.md`](CLAUDE.md).

**Review tiers** — Tier 0 is a single code-reviewer pass (routine, reversible
work). Tier 1 is the full triple-loop — code-reviewer → devil's-advocate →
security-expert, in separate sessions — for irreversible or security-sensitive
changes. Rules: [`workflow/review-tiers.md`](workflow/review-tiers.md).

## Self-setup at work

```bash
git clone https://github.com/OC15141355/claude-memory-kit.git
```

Then either:

**A. Let Claude provision in place** — open Claude Code in the clone and say:
> read SETUP.md and set yourself up

**B. Drop it into an existing project first**, then provision:
```bash
cd /path/to/your-work-project
/path/to/claude-memory-kit/bootstrap.sh .
# then open Claude Code here and say: "read SETUP.md and set yourself up"
```

Either way, `SETUP.md` drives Claude to: read the methodology → learn the
environment (stack, CI, available review agents) → ask a small batch of questions
+ record explicit assumptions → seed memory, localize the Tier-1 list, and
install the review agents. From then on, future sessions load `memory/MEMORY.md`
and apply the tiers automatically.

> ⚠️ **Your work facts stay in your work project, not in this public template.**
> Don't push real memories/config back to this repo.

## Relationship to Claude Code's built-in memory

If your Claude Code has the built-in auto-memory feature, this complements it:
same conventions (a `MEMORY.md` index + frontmatter fact files), made explicit
and portable so behaviour is identical everywhere — plus the review workflow and
self-setup, which the built-in feature doesn't provide.

## Heavier tier (not included)

This is the memory + review slice. The full LLM-wiki pattern (immutable `raw/`
sources, curated `active/`, derived `wiki/`, append-only `log.md`, ingest
cadences) is a separate, heavier system — deliberately left out.
