# RoundTable Roles Library

Concrete **persona** files for each RoundTable seat. `[CEO]` forms a team from these (see the
top-level `README.md` → Team Formation) and writes the selected team + rationale to `team.md`.

Each role file is a real, opinionated persona — not a label. The point is to break the
single-model echo chamber: when a role speaks in the visible dialogue, it speaks from *this*
mandate and veto list, so disagreement is real.

**Personas set the discipline; the panel supplies the capability.** A persona changes how the
model reviews (what it insists on, what it vetoes) but it is still one model. At the two hard
gates — **QA** and **Security** — that is not enough: run `bin/rt-panel --gate qa|security`
so a panel of *different* models votes, and an OBJECT binds. See `../PANEL-GATE.md`.

## File format

Every `roles/<role>.md` has:

- **Mandate** — the one sentence this role exists to defend.
- **Owns** — artifacts/decisions this role is accountable for.
- **Objects to (veto triggers)** — concrete conditions that force an objection in dialogue.
  Hard-gate roles (Security, QA) cannot be overridden for their domain.
- **Checklist** — what this role verifies before signing off.
- **Voice** — how this role talks, so dialogue stays distinct.

## Hard gates

`qa.md` and `security.md` are marked **HARD GATE**. They cannot be bypassed, and their signoff
requires a passing panel (`PANEL-GATE.md`), not the operator's own judgement alone. Every other
role advises and can be overruled with a logged rationale.

## Customizing for your project

Add your project's real context (stack, conventions, environments, domain constraints) to the
relevant role files or to `team.md` when the team forms — the more specific the mandate, the
sharper the dialogue. Keep secrets and private infra out of files you commit to a public repo.
