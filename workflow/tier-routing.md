# Tier Routing — which tier work gets, and how Tier-0 is dispatched

[`review-tiers.md`](review-tiers.md) answers *how much* review a change deserves.
This answers the adjacent question: **given a piece of work, which tier is it —
and for Tier-0, how do you dispatch it to a fresh-context subagent while keeping
yourself as the gate?**

Discipline first, tooling later: a routing table you consult by judgment, not a
framework that fires automatically. Build structural enforcement only once you
catch yourself mis-routing.

## The routing decision

Anchor on the `review-tiers.md` reversibility test:

> Can a defect be undone in <15 min, by me, without involving anyone else,
> without losing data, and without anyone noticing externally?
> **Yes → Tier-0. No → Tier-1.**

Starter heuristics (extend as real work teaches):

| Work shape | Tier | Dispatch? |
|---|---|---|
| Doc edits, comments, README, formatting | Tier-0 (often skip-review) | parallelizable |
| Dependency bumps with no upgrade-path semantics | Tier-0 | parallelizable |
| Additions following an existing pattern | Tier-0 | parallelizable |
| Refactors with no behaviour change + passing tests | Tier-0 | parallelizable |
| Secrets / IAM / ACL / policy changes | **Tier-1** | **NOT dispatched** |
| Irreversible edits (force-push, destructive migration, deleting a rollback path) | **Tier-1** | **NOT dispatched** |
| Removing a manual review step (automating away a checklist) | **Tier-1** | **NOT dispatched** |
| Backup / restore / integrity / recovery changes | **Tier-1** | **NOT dispatched** |
| First-time framework introductions future work inherits | **Tier-1** | **NOT dispatched** |

**The boundary is the point: Tier-1 work is NOT dispatched.** It stays manual —
separate fresh sessions, no shared context, you as the bridge. Only Tier-0 is
dispatched. Ambiguous → Tier-1 until proven Tier-0.

## Dispatching Tier-0 work — the SOP

1. **Classify** as Tier-0 via the table. Ambiguous → Tier-1.
2. **Curate the brief.** Give the generator the task cold + pointers to the
   context it needs (relevant files, prior decisions). Point, don't paste — the
   subagent self-serves from on-disk pointers.
3. **Dispatch a GENERATOR** subagent to produce the change (branch + edits). It
   does NOT push, merge, or commit outward-facing artifacts — those stay behind
   your gate.
4. **Dispatch an independent VERIFIER** subagent with the acceptance criteria
   cold — no shared context with the generator, no opinion in the prompt. It runs
   its own ground-truth checks and returns a verdict. (The no-shared-context
   partner pass, one scale down.)
5. **Operator gate.** Verify the verifier's findings against ground truth before
   acting — a reviewer claim is evidence, not a verdict. Triage, apply fixes,
   approve.
6. **Merge** is the second structural gate: you merge the PR / commit the change.
   Steps "3 returns to you" + 6 are *why* the human gate holds without extra
   tooling.

### Parallel substrate (when work is genuinely parallel)

- **Subagents** — the default for sequential work or simple fan-out
  (generator + verifier). No special flags.
- **Agent Teams** — one coordinated lead + teammates with a shared task list, for
  *one arc decomposed into coordinated parallel sub-tasks* (multi-lens review,
  competing-hypothesis investigation). Carries an autonomous-lead gate risk; run
  in plan-approval mode and keep the operator gate explicit.
- **Independent worktrees/sessions** — N *unrelated* Tier-0 tasks, each its own
  branch, no coordination.

One model per task, not stacked.

## Build trigger (evidence-gated)

Build a glue tool for a friction only if **all** hold: (1) it recurred in ≥2
tasks, (2) the manual workaround cost real minutes each time, (3) no config-only
fix exists. Otherwise don't build — record the friction and move on.
