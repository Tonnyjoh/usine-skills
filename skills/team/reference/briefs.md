# Delegation briefs

A subagent knows only what its brief says. Give **absolute paths** for the spec and the contract: a worktree starts from the last commit and does not contain these files if they are not committed yet.

If an agent needs a running app, give it its own port and ask it to stop its server. Build once yourself when agents run at the same time, and tell them not to rebuild, because a build replaces what the others are serving. Never ask an agent to stop a server it did not start.

## Developer

```
1. Goal: <one sentence>
2. Spec: <absolute path>, criteria AC-x to AC-y
3. Contract: <absolute path>, endpoints: <list>
   Design brief (interface work, if approved): <absolute path>
4. Scope: write in <paths>. Forbidden: everything else, including the spec and the contract.
5. Constraints: <architecture, conventions, libraries specific to this task>
6. Before handing back: <verification command>
7. Report: the format in your agent definition, with the real output of the commands.
<Mode line>
```

Mode line, according to `team preflight`:

- **sequential**: "You work in the current tree. No commit."
- **per-repo**: "You work in `<absolute path of the repository>`. No commit."
- **worktree**: "You work in an isolated worktree. Run `<install>` first. No commit: leave your changes as they are. Give the worktree's path in your report."

## Quality agent

Only:

```
Spec: <absolute path>
Contract: <absolute path>
To examine: <diff or scope, with the command to get it>
Commands: <verifications>
Writing: <test folders | none>
```

**Nothing else.** No reports, no developer explanations, no summary of what caused problems, no previous attempts. A sentence like "the backend already handles this case" is enough to skew the check, because the agent then looks for confirmation. In a fix round, do not pass on what was fixed either: it rechecks the spec.
