# Doctor

Compares the declared team with what exists in the project. This is maintenance: launch no agent and change no code.

```
team doctor
```

An empty `findings` list is the good result: say so in one line and stop.

The severity says what to do, not how serious it is:

- **`auto`**: no decision to make, apply the fix (`team scaffold`), then report it in one line.
- **`mention`**: state it with the proposed fix. A hand-edited agent (`agent-drift`) may be intentional: never overwrite it outright.
- **`route`**: name the command that would solve the problem, and run it only if the user asks.

Present everything in one pass. Never repair these gaps on the side of a delivery: you would be changing the rules while the team is working.
