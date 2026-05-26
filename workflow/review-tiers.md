# Review Tiers — when to single-review and when to triple-loop

How to decide what level of review a change deserves before it lands. Two named
tiers, each with stated scope. The triple-loop exists; it is **not** the default;
the default is named too.

> New tiers earn their place via observed need, not theoretical completeness. If
> a real change fits neither bucket, add a tier *then* — citing the case that
> justified it. Don't pre-specify a middle tier "just in case."

## Tier 0 — single code-reviewer pass

**Default for routine work.** Run a code-reviewer agent once, address findings,
ship.

Scope:
- Refactors with no behaviour change and a passing test suite
- Dependency bumps with no upgrade-path semantics
- Doc updates, comments, config tweaks
- Additions that follow an existing pattern already in the codebase
- Anything reversible by a trivial revert / rollback

Skipping review entirely is fine for **trivial mechanical edits** (typos,
formatting). Use judgment; if in doubt, run Tier 0.

## Tier 1 — full triple-loop

**Required for changes you cannot take back, or where a defect is a security
incident rather than a bug.** Three passes, three different cognitive idioms, in
distinct sessions / contexts:

1. **Code-reviewer** — surface defects, drift from the plan, NITs, missed
   verifications. The standard quality pass.
2. **Devil's-advocate (paranoid adversary)** — a *separate session with no shared
   context with pass 1*. Job: enumerate attack vectors, abuse cases, "what if the
   operator is compromised," "what if this script gets swapped" pivots. **Bias
   toward over-finding.**
3. **Security expert (defensive triage)** — takes the DA's output. Job: triage
   what must land in *this* change vs what belongs in a backlog vs what is
   real-but-pre-existing-and-out-of-scope. **Bias toward proportional response.**

Scope — any of:
- Irreversible edits (force-pushing a shared branch, deleting a rollback path,
  destructive migrations)
- Secret rotations, ACL changes, IAM / policy changes
- Anything that **removes a manual review step** (replacing a human checklist
  with automation)
- Changes to backup / restore, integrity anchors, or recovery paths
- First-time framework introductions whose pattern future work will inherit (the
  precedent *is* the artifact)

### Why the split matters

A single combined reviewer picks a stance — find-everything or triage-everything
— and biases the output. Splitting the roles lets the devil's-advocate say "this
is HIGH" without the defender softening it in the same breath, and lets the
defender say "real but pre-existing, defer to backlog" without the DA having to
walk it back. Each idiom stays sharp.

## Reviewers are fallible — verify before "fixing"

Both tiers carry the same caveat: **a reviewer claim is evidence, not a verdict.**
Verify the claim against ground truth before applying a fix. A sham fix for a
phantom finding is the same anti-pattern as a sham fix for a real one. Close a
phantom finding by recording "verified already correct" — **never** by a sham
edit.

## When to use which — the quick test

> Can a defect in this change be undone in **under 15 minutes, by me, without
> involving anyone else, without losing data, and without anyone noticing
> externally**?
>
> - **Yes → Tier 0.**
> - **No → Tier 1.**

If a change is ambiguous, it's **Tier 1 until proven Tier 0.**
