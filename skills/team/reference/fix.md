# Fix (phase 6)

Three rounds at most: beyond that, rerunning only consumes tokens, and the problem lies elsewhere (spec, contract, architecture).

```
team round <name>
```

If the exit code is 3 (`ROUNDS_EXHAUSTED`), rerun nothing: go to the stop below.

## One round

1. Group the problems by developer agent.
2. Send them back in a complete brief ([briefs.md](briefs.md)), with for each one the criterion concerned and the **evidence**: command, output, expected and actual.
3. Check the scope (`team scope-check`), then go back through [integrate.md](integrate.md): `team advance <name> integration`, carry over if needed, `verify --all`, `advance review`.
4. Rerun the checks with a blank context, without telling them what was fixed.

A failing test is fixed in the code. If it looks wrong, that is a spec question, not a reason to weaken it.

If the ambiguity comes from the spec, **do not settle it**: ask the question. An answer that changes the spec requires a new approval (`team approve`).

## After three unsuccessful rounds

```
team stop <name> --reason "<what resists>"
```

Then [report.md](report.md): what resists, what was tried and what needs deciding.
