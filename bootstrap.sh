#!/usr/bin/env bash
#
# bootstrap.sh — drop the memory kit into a project so Claude Code starts
# maintaining file-based memory there.
#
# Your real facts accumulate in the TARGET, never in this template repo.
# Safe to re-run: it never clobbers an existing CLAUDE.md or accumulated memory.
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

echo "==> Installing memory kit into: $TARGET"

# --- methodology (CLAUDE.md) ----------------------------------------------
if [ -f "$TARGET/CLAUDE.md" ]; then
  cp "$SRC/CLAUDE.md" "$TARGET/CLAUDE.memory.md"
  echo "   $TARGET/CLAUDE.md already exists — wrote CLAUDE.memory.md instead."
  echo "   Add this line near the top of your CLAUDE.md to load it:"
  echo "       @./CLAUDE.memory.md"
else
  cp "$SRC/CLAUDE.md" "$TARGET/CLAUDE.md"
  echo "   wrote $TARGET/CLAUDE.md"
fi

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

echo
echo "Done. Open Claude Code in $TARGET — it reads memory/MEMORY.md each session."
echo "Remember: keep real facts here, not in the public template repo."
