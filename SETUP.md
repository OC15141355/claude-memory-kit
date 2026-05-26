# SETUP — self-provision this operating kit on a new environment

**Audience: Claude Code.** This is a runbook *you* execute once when this kit
lands in a new environment (a fresh work machine / repo). Goal: understand the
methodology, learn the environment from ground truth, fill the gaps explicitly,
and stand up a working, environment-specific instance of the kit.

**Trigger:** run this when `memory/MEMORY.md` is empty/absent, or when the user
says "set yourself up" / "onboard to this environment."

Work the phases in order. Apply the memory rules in `CLAUDE.md` and the review
rules in `workflow/review-tiers.md` as you go. Use a TodoWrite list to track the
phases.

---

## Phase 1 — Understand the methodology (read, don't skim)

Read and internalize:
- `CLAUDE.md` — file-based memory (MEMORY.md index + frontmatter fact files;
  types user/feedback/project/reference; when to save / hygiene).
- `workflow/review-tiers.md` — Tier 0 (single code-reviewer) vs Tier 1 (triple-
  loop: code-reviewer → devil's-advocate → security-expert).
- `workflow/tier-routing.md` — which tier a change gets; how Tier-0 dispatches.

Then state back to the user, in 3–4 lines: (a) how memory works, (b) the two
review tiers and when each fires. This proves the kit loaded before you change
anything.

## Phase 2 — Learn the environment (ground truth, not assumption)

Investigate the actual environment. Prefer commands over guesses. Capture:

- **Project** — language(s), framework, package manager, and the real
  build / test / lint commands. Read manifests (`package.json`, `go.mod`,
  `pyproject.toml`, `Cargo.toml`, `pom.xml`), `Makefile`, CI config.
- **VCS + CI** — git remote/host (GitHub? GitLab? CodeCommit?), default branch,
  CI system (`.github/workflows`, `.gitlab-ci.yml`, …).
- **Review agents available** — do `code-reviewer`, `devils-advocate`,
  `security-expert` (or equivalents) exist? Check `.claude/agents/` and installed
  plugins/skills. Note which are missing — Tier 1 needs all three.
- **Team docs (canonical — read these first; treat as ground truth)** —
  `CONTRIBUTING.md`, `CODEOWNERS`, `README`, ADR / architecture docs, `.github/`
  (PR & issue templates, workflows), CI config (`.github/workflows`,
  `.gitlab-ci.yml`), deploy/release docs, existing `CLAUDE.md`. The team's
  process is what *is*, not what you'd like — **conform**.
- **Local conventions** — lint/format config, commit-message conventions.
- **Tooling/OS** — shell, OS, key CLIs present.

Keep a scratch list of findings — they become seed memories in Phase 4.

## Phase 3 — Interview the user about their workflows

The user is an **active source** — but **the team docs from Phase 2 are
canonical**. For each area below, start by stating what Phase 2 already taught
you, and ask the user only for **gaps the docs didn't cover** (and for things
only they can tell you — preferences, harvest from their prior unstructured
Claude usage, gotchas they've learned that aren't written down). Ask in a few
focused batches, not one wall; confirm as you go; record explicit assumptions
for anything still unclear — never assume silently.

**Review & risk**
- What classes of change are **Tier-1 here** (irreversible / security-incident:
  prod deploys, DB migrations, IAM/secret changes, public releases)?
- Should the triple-loop run on all Tier-1, or specific paths only?
- Any change types that can skip review entirely?

**Source control & shipping**
- Branch naming + PR conventions; who approves/merges; required CI gates.
- How code ships (CI/CD, manual deploy, release process); what's irreversible.

**Testing & quality**
- The real test / build / lint commands; when tests are required before merge.
- Formatting / lint rules to always honour.

**Memory seeds**
- The user's role on this project; working-style preferences (concise vs
  detailed, etc.).
- Hard constraints / gotchas worth always-loading.
- What must **never** be written to memory (secrets, teammates' info, client
  data, anything sensitive).

**Harvest from prior unstructured Claude usage**
- Context the user keeps re-pasting to Claude (codebase quirks, tribal
  knowledge, recurring tasks) — strong seed-memory candidates.
- Prompts or workflows that have worked well but aren't team-documented.

**Logistics**
- Where memory should live (project-local `./memory/` default, or shared).

Capture answers as you go — they become seed memories in Phase 4.

## Phase 4 — Stand up this environment's version

1. **Scaffold memory — and place it correctly for the context.**
   - **Solo / personal project** → `./memory/` in the project (default).
   - **Team-shared repo** → memory is **personal-only, never committed.** Add
     `memory/` to `.gitignore`, or place memory outside the repo entirely
     (e.g. `~/.claude/<project>-memory/`) and point `CLAUDE.md` at it. Never
     write teammates' info, client data, or secrets into memory.

   Ensure `memory/MEMORY.md` exists as a clean index. If the kit's two example
   facts are still present and this is a real environment, delete them.
2. **Seed memories** from Phases 2–3 (one fact per file, per `CLAUDE.md`):
   - a `project` fact — the project + stack + build/test commands;
   - a `user` fact — the user's role/preferences here (if learned);
   - `reference` facts — repo URL, CI dashboard, key docs;
   - a `feedback` fact seeding review discipline — *"Tier-1 triple-loop for
     irreversible/security changes; Tier-0 single review otherwise,"* with this
     environment's Tier-1 list.
   Add a pointer line to `memory/MEMORY.md` for each.
3. **Localize routing.** Write `workflow/tier-routing.local.md` with the
   environment-specific Tier-1 paths (Phase 3) and which review agents are
   actually available.
4. **Install the review agents if missing.** If `code-reviewer` /
   `devils-advocate` / `security-expert` aren't available, copy the templates
   from `agents/` into the appropriate scope:
   - **Personal use in a team repo** → `~/.claude/agents/` (user scope —
     not committed, not shared with teammates). This is the default.
   - **Shared with the team** → `.claude/agents/` in the repo (project scope —
     committed, requires team agreement).

   **Tier 1 is not real until all three exist.**
5. **Record assumptions.** Write `ASSUMPTIONS.md` (or a `project` memory) listing
   every Phase-3 assumption, so they can be confirmed/corrected later.

## Phase 5 — Confirm and hand back

Report to the user:
- what you learned about the environment,
- the memories you seeded (list them),
- the localized Tier-1 list,
- which review agents are ready vs missing,
- every assumption you recorded.

Ask them to correct anything. Then setup is complete — future sessions read
`memory/MEMORY.md` and apply the review tiers automatically. Re-run any phase if
the environment changes.
