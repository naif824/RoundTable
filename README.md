# RoundTable

RoundTable is a project-local operating system for autonomous AI teams.

It is designed for a solo builder who wants to drop a brief, form an internal team, let the team challenge itself, lock a sprint, execute through agents/tools, review every output, verify deeply, and stop only when the work is ready for human test.

## Trigger

The canonical trigger is:

```text
roundtable
```

When the human says `roundtable`, the AI Operator asks which project/folder to use, then initializes or loads:

```text
<ProjectRoot>/RoundTable/
```

After RoundTable is active, meaningful work must run through the RoundTable protocol.

## Install

```bash
bash install.sh /path/to/project
```

The installer:

- creates `<ProjectRoot>/RoundTable`
- installs helper scripts in `<ProjectRoot>/RoundTable/bin`
- creates RoundTable state/log files
- adds managed RoundTable sections to `CLAUDE.md`, `AGENTS.md`, and `GEMINI.md`
- preserves unrelated existing instructions

## Core Idea

RoundTable is not a planning format. It is a governance and review authority.

- The internal CEO leads the team.
- The human is not the Founder role. The human starts the process and tests at the end.
- The team forms before scope.
- Scope is locked into one sprint at a time.
- Parallel agents may implement inside a sprint, but RoundTable reviews and accepts their output.
- AI Operator executes, but cannot self-approve.
- QA is a hard gate for `Ready For Human Test`.
- Security is a hard gate for security-relevant work.
- Quality beats speed.

## Project Layout

```text
RoundTable/
  README.md
  project.md
  environment.md
  team.md
  scope.md
  sprint.md
  tasks.md
  backlog.md
  live.md
  current-status.md
  resume.md
  handoff.md
  human-test.md
  action-log.md
  discussion-log.md
  decision-log.md
  signoff-log.md
  verification-log.md
  risk-register.md
  approval-gates.md
  runtime.md
  artifacts.md
  audit/
  roles/
  bin/
    rt-log
    rt-preflight
    rt-watch
    rt-handoff
```

## Helpers

Inside a project:

```bash
RoundTable/bin/rt-log CEO "We are forming the team before scope."
RoundTable/bin/rt-watch
RoundTable/bin/rt-preflight
```

`rt-log` writes clean role dialogue to `RoundTable/live.md` and timestamped audit entries to `RoundTable/audit/YYYY-MM-DD-session.md`.

The visible terminal waterfall must show role dialogue without timestamps:

```text
[CEO] We are forming the team before scope.
[Security] I need to review auth, secrets, and data exposure before signoff.
[QA] Ready for human test requires edge-case verification for the locked scope.
```

## Status

This repo is the reusable source template. Each installed project owns its own `RoundTable/` folder and logs.
