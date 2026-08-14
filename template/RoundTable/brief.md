# Brief — <project / change name>

> The one unstructured input to RoundTable. `[CEO]` forms the team from this **before**
> scope is locked (Constitutional Rule 2), QA gates `Ready For Human Test` against the
> "Done means" section (Rule 7), and Security only engages if §6 says so (Rule 8).
> Anything you leave vague here, the team will decide for you.
>
> Fill every section. Write "none" rather than deleting one — a blank section is a
> decision nobody made.

---

## 1. Outcome — one sentence

<What is true when this is finished, stated as a result, not an activity.>

*Not "improve the filter" — "the morning digest shows only items I'd act on, and I stop
opening it out of duty."*

## 2. Why now

<What changed, broke, or became possible. If nothing did, say so — that is a real answer
and may mean this belongs in `backlog.md` instead.>

## 3. Done means

Testable statements. Each one is a QA gate item; if QA cannot check it, it is not done.

- [ ] <observable condition>
- [ ] <observable condition>
- [ ] <observable condition>

**Explicitly NOT done-blocking:** <the nice-to-haves that must not hold up signoff>

## 4. How I will test it

<The exact thing you will do at `Ready For Human Test`. A command, a screen, a file to
open. If you cannot describe your own test, the team cannot build to it.>

## 5. Scope

**In:** <what this touches>

**Out:** <what it deliberately does not touch, even though it is adjacent>

**Must not touch:** <files, services, data that are off limits — the team may not modify
these even to make the work easier>

*New ideas found along the way go to `backlog.md`, not into this scope (Rule 9).*

## 6. Risk & gates

- **Security-relevant?** yes / no — <auth, secrets, personal data, public endpoints,
  anything reachable from the internet>. If yes, Security signoff becomes a hard gate.
- **Reversible?** <how to undo it — the specific command or file>
- **Blast radius:** <what breaks if this is wrong, and who notices>
- **Sensitive data:** <does this touch client, family, or regulated data — and may it
  leave the machine it lives on?>

## 7. Where it runs

- **Machine:** ft `100.77.255.37` / Mac mini `100.67.90.60` / Air `100.122.115.71` /
  Huwawi `100.81.232.20`
- **Saudi endpoints?** If this calls a Saudi portal or Saudi-market API, it must be
  probed from the **Mac or Huwawi**, never ft — ft is Zurich and gets geo-fenced or
  quietly served degraded data.
- **Leaves no residue:** build artifacts, DMGs, archives and `node_modules` are cleaned
  before handoff (MacLab hard rules).

## 8. Evidence

<What measurement proves it worked — not "it looks right". A count, a diff, a before/after,
a test that fails on the old behaviour. If there is no way to measure it, say so plainly;
the team will treat the result as unverified.>

## 9. Source of truth

<Which data the team should trust when sources disagree, and which are known stale.
Name the file, endpoint or record. Memory and old notes are not sources of truth.>

## 10. Constraints

- **Deadline / trigger date:** <or "none">
- **Budget:** <token/spend ceiling, or "open — quality first" per Rule 1>
- **Must reuse:** <existing thing that already solves part of this — check
  `projects/ft.md` before anything gets built twice>

## 11. Open questions for the team

<What you genuinely do not know and want `[CEO]` to decide or research. Being honest here
is what stops the team inventing an answer and calling it a requirement.>

---

## Worked example

**1. Outcome** — Board-report compensation extraction is trustworthy enough to sell, because
every extracted figure carries a confidence score and the low-confidence ones are queued for
review instead of silently shipped.

**2. Why now** — MacOCR already beats Cohere on committee coverage, but there is no way to
tell a good extraction from a bad one, so the whole corpus is one-tier and unsellable.

**3. Done means**
- [ ] Every extracted field carries a confidence value
- [ ] Fields below threshold appear in a review queue, not in the output
- [ ] Re-running the same PDF twice produces identical output
- **Not done-blocking:** a UI for the review queue; a JSONL file is fine

**4. How I will test it** — Run it over 5 board reports I have already checked by hand and
compare against my own numbers.

**5. Scope** — In: the extraction pipeline in `~/MacLab/MacOCR`. Out: the Jaras app and its
backend. Must not touch: `jaras.db` (read-only for this work).

**6. Risk & gates** — Security-relevant: no. Reversible: outputs are new files; nothing
overwritten. Blast radius: none, offline pipeline. Sensitive data: public filings only.

**7. Where it runs** — Mac mini. No Saudi endpoints (PDFs already fetched). Clean `build/`
before handoff.

**8. Evidence** — Field-level accuracy against the 5 hand-checked reports, reported as a
number, before and after.

**9. Source of truth** — The Arabic board report PDF. Not `jaras.db`, which was populated by
the older Cohere pass and is known wrong on units.

**10. Constraints** — No deadline. Budget open. Must reuse the existing Apple Vision pipeline
rather than starting a new extractor.

**11. Open questions** — What confidence threshold is right? I do not know; propose one from
the data rather than guessing.
