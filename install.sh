#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: bash install.sh /path/to/project" >&2
}

if [[ $# -ne 1 ]]; then
  usage
  exit 2
fi

PROJECT_ROOT="$1"
if [[ ! -d "$PROJECT_ROOT" ]]; then
  echo "Project folder does not exist: $PROJECT_ROOT" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template/RoundTable"
RT_DIR="$PROJECT_ROOT/RoundTable"

mkdir -p "$RT_DIR"
cp -R "$TEMPLATE_DIR/." "$RT_DIR/"

PROJECT_ROOT_ABS="$(cd "$PROJECT_ROOT" && pwd)"
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

chmod +x "$RT_DIR"/bin/*

update_instruction_file() {
  local file="$1"
  local path="$PROJECT_ROOT/$file"
  local block
  block="$(cat <<'EOF'
<!-- ROUNDTABLE:START -->
## RoundTable

This project uses RoundTable.

When the human says `roundtable`, follow `./RoundTable/README.md`.

After RoundTable is active:

- Do not execute meaningful work outside the RoundTable protocol.
- Post role discussion directly in the chat stream as visible role dialogue before actions or signoff.
- Log role discussion, actions, challenges, reviews, verification, signoffs, and handoff under `./RoundTable/`.
- Use `./RoundTable/bin/rt-log` for visible role dialogue and timestamped audit entries.
- The AI Operator may execute, but cannot self-approve. RoundTable reviews and signs off.
<!-- ROUNDTABLE:END -->
EOF
)"

  if [[ -f "$path" ]]; then
    python3 - "$path" "$block" <<'PY'
import re
import sys

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

bash "$RT_DIR/bin/rt-log" "AI Operator" "RoundTable installed for project: $PROJECT_ROOT_ABS"
bash "$RT_DIR/bin/rt-preflight"

echo "RoundTable installed at: $RT_DIR"
