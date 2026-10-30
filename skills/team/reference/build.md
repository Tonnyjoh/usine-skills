# Build (phase 3)

## 1. Prepare

```
team preflight <name>
```

It checks the go-ahead and gives the mode. If it blocks, report the code: `DIRTY_TREE` for example is a decision for the user (commit, set aside or go sequential), because a worktree would not see those files.

Then:

```
team advance <name> development
```

This command stores the starting state, which is the baseline for scope checks.

## 2. Launch

| Mode | How | Why |
|---|---|---|
| `sequential` | One agent at a time, in the current tree | One developer, or no isolation possible |
| `per-repo` | In parallel, without worktrees | Each repository already isolates its developer |
| `worktree` | In parallel, each in its worktree ([tools.md](tools.md)) | One git copy per agent |

If the tasks depend on each other, go sequential whatever the mode, and say why. For example, a frontend that needs migrations already written.

Launch parallel agents at the same time, each with a complete brief ([briefs.md](briefs.md)). How to launch an agent depends on your tool: see [tools.md](tools.md).

## 3. After each report

Check the scope against what was really changed, not what the agent declares:

```
team scope-check <agent> --feature <name>      # sequential, per-repo
team scope-check <agent> --worktree <path>     # worktree
```

- `out_of_scope` or `spec_or_contract_touched`: incident. Report it, then have that work undone or redone.
- `diverged_base`: the worktree does not start from the current branch. Resolve this before integrating.

An incident is recorded once, and the next agent is not blamed for those files. If you change a file yourself between two agents, run `team lead-change <name> --reason "<what and why>"` for the same reason.

In sequential mode, run it **after each agent**: the script then accepts its files as the baseline for checking the next one.

If an agent is `blocked` on the contract, go to [integrate.md](integrate.md), step 1.
