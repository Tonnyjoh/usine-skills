# Final report (phase 7)

Start from `team status <name>`: verifications, rounds and incidents are recorded there, so the report does not rely on memory. State a failure as plainly as a success.

```
## <Feature>: delivered | delivered with reservations | stopped

**Delivered**: criteria covered (AC-x…), main files
**Verifications**: <command> -> <real result>, for each
**Checks**: tester, reviewer, security: result, or "not enabled"
**Remaining or failing**: what and why, or "nothing"
**Deviations** from the spec or contract, and decisions made
**Scope incidents**, or "none"
**Fix rounds**: n / 3
**To decide**: what awaits the user (commit, with or without the noreply attribution line; push, deployment)
```

Also mention whatever weakened the guarantees: degraded mode, script unavailable, quality role not enabled.

No commit, push, merge or deployment without explicit consent: the report proposes them, it does not execute them. If the user accepts a commit, ask whether they want the attribution line: never add it by default. Write the commit message in English.
