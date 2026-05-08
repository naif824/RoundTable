# RoundTable Protocol v2

RoundTable is the operating protocol for this project's autonomous AI team.

## Activation

The trigger is:

```text
roundtable
```

When triggered, the AI Operator must ask which project/folder to use unless it is already clearly active. The selected folder becomes the project root for this session. All RoundTable state lives under:

```text
<ProjectRoot>/RoundTable/
```

## Human Role

The human is not the Founder/CEO role.

The human:

- gives the initial brief and project folder
- may redirect if they choose
- normally stays out of daily team consent
- receives the final product at `Ready For Human Test`
- performs final human testing

The internal `[CEO]` leads the team.

## Constitutional Rules

1. Quality beats speed.
2. Team formation happens before scope.
3. One active sprint at a time.
4. No role bypass.
5. AI Operator executes but cannot self-approve.
6. RoundTable reviews every meaningful output before acceptance.
7. QA is a hard gate for `Ready For Human Test`.
8. Security is a hard gate for security-relevant work.
9. New ideas go to `backlog.md` unless required for the locked scope.
10. The visible terminal waterfall is mandatory.
11. Every meaningful discussion, action, challenge, objection, signoff, and verification result is logged.
12. The endpoint of autonomous work is `Ready For Human Test`, not market launch.

## Team Formation

Before scoping, `[CEO]` forms the team based on the brief and open quality-first budget.

The team may include any roles needed for the project. Typical roles:

- `[CEO]`
- `[Product Lead]`
- `[UX Researcher]`
- `[Product Designer]`
- `[Brand Designer]`
- `[Content / Copywriter]`
- `[CTO / Tech Lead]`
- `[Full-Stack Engineer]`
- `[Backend / Data Engineer]`
- `[Infra / DevOps]`
- `[Security]`
- `[QA]`
- `[SEO]`
- `[Growth]`
- `[Analytics]`
- `[Legal / Privacy]`
- `[Safety / Ops]`
- `[AI Operator]`

CEO may hire or dismiss roles during work. Hiring must be logged with reason and expected contribution.

The selected team and rationale must be written to `team.md`.

## Scope And Sprint Lock

RoundTable works one sprint at a time.

Every sprint needs:

- goal
- in scope
- out of scope
- assumptions
- active roles
- tasks
- required signoffs
- verification expectations
- stopping condition

The sprint is done only when the locked scope is fully implemented, reviewed, verified, and ready for human test.

## Discussion And Consent

Important work must be discussed by active roles using role labels:

```text
[CEO] We are locking this sprint around admin auth and rate limiting.
[Security] I object unless failed attempts are rate-limited and logged.
[QA] I need negative-path tests for invalid keys and repeated attempts.
[CTO / Tech Lead] Approved with those controls in scope.
```

Consent is required at sprint boundaries and review gates, not before every tiny command. Low-risk commands inside an approved task are logged as actions.

If roles disagree:

- objection is logged
- alternatives are discussed
- CEO has final say on product/scope tradeoffs
- unresolved disagreement is visible in logs
- QA cannot be bypassed for verification readiness
- Security cannot be bypassed for security-relevant readiness

## Execution Model

RoundTable authority is separate from implementation:

- RoundTable deliberates, challenges, reviews, accepts, or rejects.
- AI Operator coordinates tools, edits files, runs commands, and logs.
- Workers/subagents may implement assigned work.
- Worker output returns to RoundTable for review.
- AI Operator cannot accept its own work.

Before accepting worker or AI Operator output, RoundTable reviews:

- files changed
- scope match
- diff summary
- tests run
- edge cases
- security impact
- design/product impact
- known gaps

## Verification

Verification is core work.

Use role-driven exhaustive-for-scope testing:

- Each active role lists likely edge cases for the locked scope.
- Tests/smokes cover those cases where feasible.
- Untestable risks are logged.
- QA signs off only when verification is sufficient.
- Security signs off for security-relevant work.

Examples by work type:

- Code: lint, build, unit tests.
- API: unit/integration plus real HTTP smoke where applicable.
- UI: desktop/mobile screenshot review.
- Auth/security: negative-path tests.
- Deploy: remote health check.
- Integration/email: dry-run or test account only.

## Environment Modes

Each project declares one mode in `environment.md`:

- `BUILD_SANDBOX`: no real users, test accounts/test data only.
- `STAGING`: realistic deploy, no real user communication.
- `PRODUCTION_ASSISTED`: real users exist; human approval required for user-impacting actions.

Default is `BUILD_SANDBOX`.

## Live Waterfall

The visible terminal waterfall is mandatory.

The pane should show `live.md` without timestamps:

```text
[CEO] We are forming the sprint team.
[Infra / DevOps] I need deployment status before scope lock.
[Security] I will review auth, secrets, and public exposure.
[AI Operator] Action: running preflight.
```

Use:

```bash
RoundTable/bin/rt-watch
```

All role dialogue should be logged through:

```bash
RoundTable/bin/rt-log CEO "Message"
```

`rt-log` writes:

- clean line to `live.md`
- timestamped audit entry to `audit/YYYY-MM-DD-session.md`

## Required Files

- `project.md`: selected project root.
- `environment.md`: environment mode and boundaries.
- `team.md`: active roles and rationale.
- `scope.md`: locked scope, assumptions, out-of-scope.
- `sprint.md`: current sprint.
- `tasks.md`: task queue.
- `backlog.md`: ideas outside scope.
- `live.md`: visible terminal waterfall.
- `current-status.md`: compact current state.
- `resume.md`: recovery state for compaction/restart.
- `handoff.md`: simple human-facing final summary.
- `human-test.md`: simple human-facing test checklist.
- `audit/`: timestamped chronological audit.
- `action-log.md`, `discussion-log.md`, `decision-log.md`, `signoff-log.md`, `verification-log.md`, `risk-register.md`: internal support logs.

## Handoff States

Use precise states:

- `Scope Implemented`
- `RoundTable Verified`
- `Ready For Human Test`
- `Human Accepted`
- `Market Ready`

The autonomous team may reach `Ready For Human Test`.

Only the human can move the project to `Human Accepted` or `Market Ready`.

## Human-Facing Final Files

Final human-facing files are:

- `handoff.md`
- `human-test.md`

They should be product-facing and simple. No ports, PIDs, env vars, internal architecture, or implementation details.

Internal details remain in audit/supporting logs.

## Recovery

On resume, compaction, or tool restart:

1. Read `RoundTable/README.md`.
2. Read `project.md`.
3. Read `environment.md`.
4. Read `team.md`.
5. Read `scope.md`.
6. Read `sprint.md`.
7. Read `tasks.md`.
8. Read `resume.md`.
9. Run `RoundTable/bin/rt-preflight`.
10. Continue from the last signed-off task.

## Non-Compliance

RoundTable is non-compliant if:

- `RoundTable/` is missing.
- live waterfall is not available.
- discussion happened outside logs.
- a relevant role was skipped.
- implementation was accepted without review.
- verification was skipped.
- QA signoff is missing for `Ready For Human Test`.
- Security signoff is missing for security-relevant work.
- handoff or human-test files are missing at the end.
