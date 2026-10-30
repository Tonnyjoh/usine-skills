# Independent checks (phase 5)

Run the active quality agents (`tester`, `reviewer`, `security`) with the minimal brief from [briefs.md](briefs.md), and nothing more. The tester first if it writes files: both reviews then also cover its tests. Reviewer and security can run in parallel.

If the feature went through [design.md](design.md), also run the design agent's review pass, adding the design brief's absolute path to its brief. The running interface is what it reviews: give it the command to start the app if there is one.

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
team design-check --feature <name>    # with an active design agent and an interface
team advance <name> done
```

`design-check` scans what the feature changed for em dashes, emoji, sparkle-style icons and generic fonts, and blocks `done` until they are fixed. A star icon is not flagged, because it is legitimate for a rating: the design agent judges that case. It also returns impeccable's findings when installed: pass those on, but they do not block. A problem it finds is sent back like any other, through [fix.md](fix.md).
