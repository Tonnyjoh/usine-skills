# Integrate (phase 4)

```
team advance <name> integration
```

## 1. Process the reports

If an agent is `blocked` on the contract, **do not work around it**. Explain the problem and the proposed correction, and wait for consent. After changing the contract, record a new approval (`team approve`) and inform all the agents concerned: the contract is their only common ground.

## 2. Bring it together

- **sequential, per-repo:** the changes are already in place, nothing to carry over.
- **worktree:** for each agent:

  ```
  team apply <agent> --worktree <path>
  ```

  The command refuses out-of-scope work, then carries the changes over to the main tree **without any commit**. The user thus keeps the decision at the end.

Conflict (`CANNOT_APPLY`): arbitrate in line with the contract. If the choice is a business one, ask. Disjoint scopes should not normally conflict; if they do, find out why (generated file, lockfile).

Once everything is carried over and verified in step 3, remove the worktrees. Since their changes are not committed, `git worktree remove` requires `--force`: do this only after confirming that each `apply` succeeded. Then delete their branches if you created any.

## 3. Verify the integrated result

```
team verify <name> --all
```

Each agent's verifications prove nothing about the whole: this is where you find out what does not fit together. On failure, it is a fix round ([fix.md](fix.md)). When everything passes:

```
team advance <name> review
```

This transition is refused if a verification is missing, fails or predates the last code change.
