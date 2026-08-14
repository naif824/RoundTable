# LLM Guide: RoundTable

Use this file when an AI assistant needs to understand the repo quickly.

## Purpose

RoundTable is a reusable protocol/template for autonomous AI product teams.

The human says `roundtable`; the AI asks for the project folder; then all meaningful work is routed through `<ProjectRoot>/RoundTable/`.

## Non-Negotiables

- Team formation before scope.
- One sprint at a time.
- Quality over speed.
- Role challenge is required.
- AI Operator cannot self-approve.
- Workers/subagents implement; RoundTable reviews.
- QA is required for `Ready For Human Test`.
- Security is required for security-relevant work.
- Hard gates (QA, Security) require a passing multi-model panel (`bin/rt-panel --gate qa|security`):
  four independent CLIs vote, any OBJECT blocks, and the operator runs the panel but cannot vote in it.
  See `template/RoundTable/PANEL-GATE.md`.
- Visible role dialogue in the chat stream is mandatory before actions and signoff.
- Timestamped audit is mandatory.

## Main Files

- `install.sh`: installs RoundTable into a project.
- `template/RoundTable/README.md`: project-local protocol.
- `template/RoundTable/bin/rt-log`: writes visible + audit logs.
- `template/RoundTable/bin/rt-watch`: tails the live log.
- `template/RoundTable/bin/rt-preflight`: checks required files.
- `tests/test_install.sh`: installer smoke test.

## Important Behavior

When RoundTable is active, post role discussion directly in the chat stream as visible role dialogue. Do not hide discussion only in terminal output, `live.md`, tool logs, or audit files. Files are mirrors for history; the human must see the discussion live in chat.

Do not replace existing `CLAUDE.md`, `AGENTS.md`, or `GEMINI.md`. The installer updates only the managed RoundTable section between:

```md
<!-- ROUNDTABLE:START -->
<!-- ROUNDTABLE:END -->
```

## Validation

Run:

```bash
bash tests/test_install.sh
```
