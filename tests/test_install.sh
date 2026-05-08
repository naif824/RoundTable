#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/project"
cat > "$TMP/project/AGENTS.md" <<'EOF'
# Existing Agent Instructions

Keep this line.
EOF

bash "$ROOT/install.sh" "$TMP/project" >/tmp/roundtable-install-test.out

test -d "$TMP/project/RoundTable"
test -f "$TMP/project/RoundTable/bin/rt-log"
test -f "$TMP/project/RoundTable/README.md"
test -f "$TMP/project/RoundTable/project.md"
test -f "$TMP/project/CLAUDE.md"
test -f "$TMP/project/AGENTS.md"
test -f "$TMP/project/GEMINI.md"

grep -q "Keep this line." "$TMP/project/AGENTS.md"
grep -q "ROUNDTABLE:START" "$TMP/project/AGENTS.md"
grep -q "RoundTable installed for project" "$TMP/project/RoundTable/live.md"
ls "$TMP/project/RoundTable/audit"/*-session.md >/dev/null

bash "$TMP/project/RoundTable/bin/rt-log" CEO "Test message"
grep -q "\\[CEO\\] Test message" "$TMP/project/RoundTable/live.md"
grep -q "\\[CEO\\] Test message" "$TMP/project/RoundTable/audit/"*-session.md

bash "$TMP/project/RoundTable/bin/rt-preflight" >/tmp/roundtable-preflight-test.out

echo "install test passed"
