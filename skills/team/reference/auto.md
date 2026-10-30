# Auto mode

The user asked you not to wait for them: run the whole of [ship.md](ship.md) on your own and hand them a finished, verified project. Only their own message can ask for this. Every check stays: what changes is who gives the go-ahead, and they gave it in advance.

## Start

```
team start <name> --auto --quote "<the user's exact words>"
```

If no team exists, propose it with `team propose`, using the agents they named and otherwise the smallest team that fits, then write and generate it without waiting.

Without a named stack, follow what the repository shows. On an empty project with nothing to go on, choose the most common stack for the job and note it.

## Decide instead of asking

Each time the normal process would ask a question, decide and record it, with what you ruled out:

```
team note <name> "Chose X over Y because Z"
```

A wrong assumption is cheap when it is visible at the end and expensive when it is hidden. Prefer the option that is easiest to change later. Pass the same instruction to the agents: no waiting, assumptions in their report. Record the ones that matter.

Record the go-aheads with:

```
team approve <name> --auto
team approve-design <name> --auto
```

The spec must still have testable criteria, and the design brief real references. An approved document that changes later needs `--auto` again and a note saying why.

## Stop anyway

Stop and report, whatever the mode, when:

1. **A commit, push, merge or deployment** would come next. The user decides, and is asked about the attribution line.
2. **An action is irreversible** or touches anything outside the project: data deletion, sending messages, spending money.
3. **`team round` returns `ROUNDS_EXHAUSTED`.** Do not bypass the limit. Report what resists.
4. **Something only the user has is missing:** a secret, an access, a real business fact that must not be invented, such as a price or a legal mention on a real product.
5. **A blocking problem cannot be settled from the request,** because every option contradicts something the user said.

Do not widen permissions or a sandbox to keep going. If a tool's permission prompt blocks an agent, report it.

## Report

Use [report.md](report.md), and add:

- the user's quote that enabled auto mode;
- **Decided for you:** every `team note`, and the design direction with its alternatives, so they can see at once what to overturn.

Passing checks only prove what the spec says, and in this mode you wrote the spec yourself. Say so, and tell the user to look at the result.
