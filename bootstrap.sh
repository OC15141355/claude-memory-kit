#!/usr/bin/env bash
#
# bootstrap.sh — drop the operating kit into a project, then hand off to the
# agentic self-setup (SETUP.md).
#
# This copies the kit FILES into a target and creates a clean memory index. The
# real provisioning (learn the env, seed memories, localize tiers, install review
# agents) is done by Claude via SETUP.md. Your real facts accumulate in the
# TARGET, never in the template repo.
#
# Safe to re-run: never clobbers an existing CLAUDE.md or accumulated memory.
#
#   ./bootstrap.sh [target-dir]      (default target: current directory)
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-$PWD}"
TARGET="$(cd "$TARGET" && pwd)"

if [ "$TARGET" = "$SRC" ]; then
  echo "Refusing to bootstrap into the template itself. Pass a target dir." >&2
  exit 1
fi

echo "==> Installing operating kit into: $TARGET"

# --- methodology (CLAUDE.md) ----------------------------------------------
if [ -f "$TARGET/CLAUDE.md" ]; then
  cp "$SRC/CLAUDE.md" "$TARGET/CLAUDE.memory.md"
  echo "   $TARGET/CLAUDE.md exists — wrote CLAUDE.memory.md instead."
  echo "   Add this near the top of your CLAUDE.md to load it:"
  echo "       @./CLAUDE.memory.md"
else
  cp "$SRC/CLAUDE.md" "$TARGET/CLAUDE.md"
  echo "   wrote $TARGET/CLAUDE.md"
fi

# --- runbook + workflow + agent templates ---------------------------------
cp "$SRC/SETUP.md" "$TARGET/SETUP.md"
mkdir -p "$TARGET/workflow" "$TARGET/agents"
cp "$SRC"/workflow/*.md "$TARGET/workflow/"
cp "$SRC"/agents/*.md "$TARGET/agents/"
echo "   wrote SETUP.md, workflow/, agents/ (templates)"

# --- memory index (clean, empty) ------------------------------------------
mkdir -p "$TARGET/memory"
if [ -f "$TARGET/memory/MEMORY.md" ]; then
  echo "   $TARGET/memory/MEMORY.md exists — leaving your facts untouched."
else
  cat > "$TARGET/memory/MEMORY.md" <<'EOF'
# Memory Index

> Auto-loaded each session. One line per memory: `- [Title](file.md) — hook`.
> Never put fact content here — only pointers. Rules: see ../CLAUDE.md.

<!-- Pointers go here as you accumulate facts. -->
EOF
  echo "   wrote a fresh, empty $TARGET/memory/MEMORY.md"
fi

cat <<EOF

Done — files are in place. Now do the actual setup:

  1. Open Claude Code in:  $TARGET
  2. Say:  "read SETUP.md and set yourself up"

Claude will learn the environment, seed memory, localize the review tiers, and
install the review agents. Keep real facts here, not in the public template repo.
EOF
