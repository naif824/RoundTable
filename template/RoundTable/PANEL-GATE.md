# Panel Hard-Gate Spec

The problem RoundTable started with: roles are **personas** — the same model in different
voices. A `[QA]` persona signing off is one actor grading its own homework. The panel gate
replaces self-attestation with **independent capability**: at every hard gate, a panel of
four *different* models (`claude`, `codex`, `gemini`, `grok`) votes, and their verdict
binds. Personas set the discipline; the panel supplies the second pair of eyes that a
single model structurally cannot be.

## When the panel is MANDATORY (hard gates)

A hard gate may not be signed off on the operator's own judgement alone. Run the panel and
record its outcome first:

| Gate | Trigger | Command |
|---|---|---|
| **QA** | Any move to `Ready For Human Test` | `RoundTable/bin/rt-panel --gate qa -f <acceptance-evidence>` |
| **Security** | Any security-relevant work (brief §6 = yes) | `RoundTable/bin/rt-panel --gate security -f <artifact>` |

The panel is also *available* (not mandatory) for any hard decision — locking scope,
an architecture fork, a risky migration: `rt-panel "<the decision>"`.

## The verdict rule

Each reviewer ends with exactly one line: `VERDICT: APPROVE | CONCERNS | OBJECT`.
rt-panel aggregates them into one outcome and a blocking exit code:

| Outcome | Exit | Meaning | What the gate does |
|---|---|---|---|
| **PASS** | 0 | quorum reached, no OBJECT, no CONCERNS | Gate may be signed off. Log it. |
| **HOLD** | 2 | ≥1 CONCERNS, no OBJECT | **No signoff** until each concern is resolved, or explicitly accepted with a logged reason. |
| **BLOCKED** | 3 | ≥1 OBJECT | **No signoff.** A hard-gate OBJECT **cannot be majority-overridden** — it must be resolved (or the human overrules it, in writing). |
| **NO-QUORUM** | 4 | < `RT_PANEL_QUORUM` (default 3) reviewers returned a verdict | Gate cannot pass; re-run. A gate that can't convene a panel is not a passed gate. |

**Non-negotiable:** one OBJECT from any reviewer blocks a hard gate. Three APPROVEs do not
outvote it. This is deliberate — a security or data-loss objection that four-fifths of a
room misses is exactly the one worth stopping for.

## What gets logged

In `--gate` mode rt-panel appends a timestamped block to the matching log
(`verification-log.md` for QA, `signoff-log.md` otherwise): the outcome, each model's
verdict, and the tally. So the audit trail shows not just *that* QA signed off, but *what
an independent panel said* — and any dissent that was overruled.

## How it wires into signoff

1. Operator prepares the acceptance evidence (the brief's §4 test run, the diff, the artifact).
2. Operator runs `rt-panel --gate qa|security` from the project root (reviewers inspect real files, read-only).
3. `PASS` → the gate role signs off in `signoff-log.md`, citing the panel outcome.
   `HOLD`/`BLOCKED`/`NO-QUORUM` → the sprint is **not** `Ready For Human Test`; resolve and re-run.
4. The AI Operator still cannot self-approve (Rule 5): it runs the panel, it does not vote in it.

## Degradation

If a reviewer CLI is missing or times out it counts as `MISSING`, not APPROVE — silence is
never consent. As long as `RT_PANEL_QUORUM` models return a verdict the gate can still reach
PASS/HOLD/BLOCKED; below quorum it is NO-QUORUM by construction. Tune with
`RT_PANEL_QUORUM`, `RT_PANEL_TIMEOUT`, `RT_PANEL_TIMEOUT_GROK`.
