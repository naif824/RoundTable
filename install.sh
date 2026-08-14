#!/usr/bin/env bash
set -euo pipefail

usage() { echo "Usage: bash install.sh [--upgrade] /path/to/project" >&2; }

MODE="install"
if [[ "${1:-}" == "--upgrade" ]]; then MODE="upgrade"; shift; fi
if [[ $# -ne 1 ]]; then usage; exit 2; fi

PROJECT_ROOT="$1"
if [[ ! -d "$PROJECT_ROOT" ]]; then
  echo "Project folder does not exist: $PROJECT_ROOT" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template/RoundTable"
RT_DIR="$PROJECT_ROOT/RoundTable"
mkdir -p "$RT_DIR"

# Protocol code — the parts that are the protocol itself, not project state. On --upgrade
# these are force-refreshed (a broken/old rt-panel, an outdated README, a missing spec are
# replaced). Everything else (brief, scope, sprint, tasks, all logs, audit, team, and any
# role personas you customized) is additive-only and never overwritten.
is_protocol() {
  case "$1" in
    README.md|PANEL-GATE.md|bin/*) return 0 ;;
    *) return 1 ;;
  esac
}

added=0 updated=0 kept=0
while IFS= read -r -d '' rel; do
  rel="${rel#./}"
  if [[ -d "$TEMPLATE_DIR/$rel" ]]; then
    mkdir -p "$RT_DIR/$rel"
  elif [[ -e "$RT_DIR/$rel" || -L "$RT_DIR/$rel" ]]; then
    if [[ "$MODE" == "upgrade" ]] && is_protocol "$rel"; then
      rm -f "$RT_DIR/$rel"                       # drop stale file OR broken symlink
      mkdir -p "$(dirname "$RT_DIR/$rel")"
      cp "$TEMPLATE_DIR/$rel" "$RT_DIR/$rel"
      echo "  updated $rel"; updated=$((updated+1))
    else
      kept=$((kept+1))
    fi
  else
    mkdir -p "$(dirname "$RT_DIR/$rel")"
    cp "$TEMPLATE_DIR/$rel" "$RT_DIR/$rel"
    echo "  added   $rel"; added=$((added+1))
  fi
done < <(cd "$TEMPLATE_DIR" && find . -mindepth 1 -print0)

PROJECT_ROOT_ABS="$(cd "$PROJECT_ROOT" && pwd)"
if [[ "$MODE" == "install" || ! -f "$RT_DIR/project.md" ]]; then
  cat > "$RT_DIR/project.md" <<EOF
# Project

Project root:

\`\`\`text
$PROJECT_ROOT_ABS
\`\`\`

RoundTable folder:

\`\`\`text
$PROJECT_ROOT_ABS/RoundTable
\`\`\`
EOF
fi

chmod +x "$RT_DIR"/bin/* 2>/dev/null || true

update_instruction_file() {
  local file="$1"
  local path="$PROJECT_ROOT/$file"
  local block
  block="$(cat <<'EOF'
<!-- ROUNDTABLE:START -->
## RoundTable

This project uses RoundTable.

When the human says `roundtable`, follow `./RoundTable/README.md`.

The human brief is `./RoundTable/brief.md`. If it is missing or empty, ask for it and
fill it together **before** forming the team — team formation, the QA gate and the
Security gate are all derived from it.

After RoundTable is active:

- Do not execute meaningful work outside the RoundTable protocol.
- Post role discussion directly in the chat stream as visible role dialogue before actions or signoff.
- Log role discussion, actions, challenges, reviews, verification, signoffs, and handoff under `./RoundTable/`.
- Use `./RoundTable/bin/rt-log` for visible role dialogue and timestamped audit entries.
- The AI Operator may execute, but cannot self-approve. RoundTable reviews and signs off.
- Hard gates (QA, Security) require a passing multi-model panel: run
  `./RoundTable/bin/rt-panel --gate qa|security` and record the outcome. Any OBJECT blocks
  signoff and cannot be majority-overridden. See `./RoundTable/PANEL-GATE.md`.
<!-- ROUNDTABLE:END -->
EOF
)"

  if [[ -f "$path" ]]; then
    python3 - "$path" "$block" <<'PY'
import re, sys
path, block = sys.argv[1], sys.argv[2]
with open(path, "r", encoding="utf-8") as f:
    content = f.read()
pattern = r"<!-- ROUNDTABLE:START -->.*?<!-- ROUNDTABLE:END -->"
if re.search(pattern, content, flags=re.S):
    content = re.sub(pattern, block, content, flags=re.S)
else:
    if content and not content.endswith("\n"):
        content += "\n"
    content += "\n" + block + "\n"
with open(path, "w", encoding="utf-8") as f:
    f.write(content)
PY
  else
    printf "%s\n" "$block" > "$path"
  fi
}

update_instruction_file "CLAUDE.md"
update_instruction_file "AGENTS.md"
update_instruction_file "GEMINI.md"

bash "$RT_DIR/bin/rt-log" "AI Operator" "RoundTable ${MODE}ed for project: $PROJECT_ROOT_ABS (added=$added updated=$updated kept=$kept)"
bash "$RT_DIR/bin/rt-preflight" || true

echo "RoundTable ${MODE} complete at: $RT_DIR  (added=$added updated=$updated kept=$kept)"
