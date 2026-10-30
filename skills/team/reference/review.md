# Independent checks (phase 5)

Run the active quality agents (`tester`, `reviewer`, `security`) with the minimal brief from [briefs.md](briefs.md), and nothing more. The tester first if it writes files: both reviews then also cover its tests. Reviewer and security can run in parallel.

With no active quality agent, say so: the delivery will have only the developers' tests, written by those who wrote the code.

After each agent:

```
team scope-check <agent> --feature <name>
```

A reviewer that changed a file is an incident, and so is a tester that changed application code.

Then sort the results without softening them:

| Result | Next |
|---|---|
| Failing tests, blocking or important points | [fix.md](fix.md) |
| Spec ambiguity | Question to the user, do not settle it |
| Minor point | List it in the report, no fix round, unless asked otherwise |
| Nothing to report | Final verification, then report |

Final verification, essential because the tester added files:

```
team verify <name> --all
team advance <name> done
```
