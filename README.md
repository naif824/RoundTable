# RoundTable

**Autonomous AI team workflow for Claude Code, Codex, Gemini, Cursor, VS Code, and long-running tmux sessions.**

RoundTable turns an AI coding session into a project-local product team. You give a brief, the team forms roles, challenges assumptions, locks one sprint, implements through agents/tools, reviews the output, verifies edge cases, and stops when the work is **Ready For Human Test**.

It is built for solo founders and builders who want an AI team that can work while they sleep, without losing visibility, memory, review discipline, or audit history.

## Why RoundTable Exists

Most AI coding workflows fail in the same places:

- the model rushes from brief to code
- assumptions stay hidden
- security, QA, design, and product concerns are skipped
- long sessions lose context
- autonomous work happens silently
- "done" means "code was written", not "work was reviewed and verified"

RoundTable fixes that by making the AI operate as a visible team in the chat stream, with logs, roles, challenge, signoff, and final human-test handoff.

## The Trigger

The human says:

```text
roundtable
```

The AI asks which project/folder to use, then initializes or loads:

```text
<ProjectRoot>/RoundTable/
```

After that, meaningful work runs through the RoundTable protocol.

## What It Does

- Forms a project-specific AI team before scoping.
- Uses roles like `[CEO]`, `[CTO]`, `[Security]`, `[QA]`, `[Product]`, `[Design]`, `[Infra]`, and `[AI Operator]`.
- Forces roles to challenge each other instead of silently agreeing.
- Locks one sprint at a time to avoid drift.
- Allows workers/subagents to implement, but requires RoundTable review before acceptance.
- Prevents the AI Operator from self-approving its own work.
- Makes QA a hard gate for `Ready For Human Test`.
- Makes Security a hard gate for security-relevant work.
- Keeps human-visible role dialogue in the chat stream.
- Keeps timestamped audit logs for historical review.
- Produces simple human-facing handoff and test instructions at the end.

## Install

Clone this repo, then install RoundTable into any project:

```bash
git clone https://github.com/naif824/RoundTable.git
cd RoundTable
bash install.sh /path/to/project
```

The installer creates:

```text
/path/to/project/RoundTable/
```

It also adds managed RoundTable sections to:

- `CLAUDE.md`
- `AGENTS.md`
- `GEMINI.md`

Existing content is preserved.

## Project Layout

```text
RoundTable/
  README.md              # project-local protocol
  project.md             # selected project root
  environment.md         # BUILD_SANDBOX / STAGING / PRODUCTION_ASSISTED
  team.md                # active team and rationale
  scope.md               # locked scope and assumptions
  sprint.md              # current sprint
  tasks.md               # task queue
  backlog.md             # ideas outside the sprint
  live.md                # mirror of visible role dialogue
  current-status.md      # compact status
  resume.md              # recovery state after restart/compaction
  handoff.md             # simple human-facing final summary
  human-test.md          # simple human-facing test checklist
  brief.md               # the human intake — scope, "done means", must-not-touch, evidence
  PANEL-GATE.md          # spec: the multi-model hard gate
  audit/                 # timestamped chronological audit
  roles/                 # persona library (Mandate/Owns/Objects-to/Checklist/Voice); QA & Security are hard gates
  bin/
    rt-log
    rt-watch
    rt-preflight
    rt-handoff
    rt-panel             # multi-model review panel + hard gate
```

## Visible Role Dialogue

RoundTable is designed for long-running AI sessions. Role discussion belongs in the chat stream first; terminal logs and `live.md` are audit mirrors, not a substitute for visible discussion.

The chat stream must show clean role dialogue without timestamps:

```text
[CEO] We are forming the team before scope.
[Security] I need auth, secrets, and public exposure reviewed before signoff.
[QA] Ready for human test requires edge-case verification for the locked scope.
[AI Operator] Action: running preflight.
```

Every log line can be written with:

```bash
RoundTable/bin/rt-log CEO "We are forming the team before scope."
RoundTable/bin/rt-log Security "I need auth, secrets, and public exposure reviewed before signoff."
```

`rt-log` writes:

- clean visible text to `RoundTable/live.md`
- timestamped audit text to `RoundTable/audit/YYYY-MM-DD-session.md`

## Core Rules

- **Quality beats speed.**
- Team formation happens before scope.
- One active sprint at a time.
- No role bypass.
- The AI Operator executes but cannot self-approve.
- RoundTable reviews every meaningful output before acceptance.
- QA controls whether a sprint is verified.
- Security controls signoff for security-relevant work.
- **Hard gates (QA, Security) require a passing multi-model panel** (`bin/rt-panel --gate`) — a
  panel of different models votes, an OBJECT binds, and the same model that did the work cannot
  be the one that clears it. See `PANEL-GATE.md`.
- New ideas go to `backlog.md` unless needed for the locked scope.
- Human test is the final autonomous endpoint.

## The Panel Gate

Roles are personas — the same model in different voices. A `[QA]` persona signing off on its own
work is self-attestation. `bin/rt-panel` fixes that: at each hard gate it fans the artifact out to
**four independent CLIs (`claude`, `codex`, `gemini`, `grok`)**, each with a distinct lens, and
aggregates their verdicts into one blocking outcome:

```bash
RoundTable/bin/rt-panel --gate qa       -f acceptance-evidence.md
RoundTable/bin/rt-panel --gate security -f changed-endpoint.py
```

`PASS` (exit 0) lets the gate sign off; `HOLD` (concerns), `BLOCKED` (any OBJECT — cannot be
majority-overridden), or `NO-QUORUM` all stop it. In `--gate` mode the outcome and every model's
verdict are appended to `verification-log.md` / `signoff-log.md`, so the audit shows what an
independent panel said, not just that the operator asserted it. Full rules: `PANEL-GATE.md`.

## Ready For Human Test

RoundTable does not claim market launch.

The autonomous team can reach:

```text
Ready For Human Test
```

That means:

- locked scope implemented
- RoundTable reviewed the output
- objections resolved or logged
- QA verification signed off
- Security signed off when relevant
- human-facing `handoff.md` and `human-test.md` are ready

Only the human can move the project to:

- `Human Accepted`
- `Market Ready`

## Who This Is For

RoundTable is useful if you:

- use Claude Code, Codex, Gemini, Cursor, or VS Code Remote SSH
- run long AI sessions in `tmux`
- want autonomous AI work while you are away
- care about product quality, QA, security, and auditability
- want a solo-founder version of an AI product team

## What This Is Not

RoundTable is not:

- an AI model
- a replacement for Claude/Codex/Gemini
- a project management SaaS
- a magic memory system
- a production-launch approval system

It is a project-local operating protocol and toolkit for AI-assisted autonomous delivery.

## Test

```bash
bash tests/test_install.sh
```

## Current Status

RoundTable is early but usable. The first version focuses on the installable project template, AI instruction files, visible live log, timestamped audit log, and core methodology.
