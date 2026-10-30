# Menu with no argument

The user is really asking "what should I do?". Answer from the result of `team context`, without running anything.

Lead with **one to three recommendations**, each with the exact command and a reason drawn from the facts, then show the commands table.

- `NOT_A_PROJECT`: ask which project, offering `recent_repos`. Create nothing in the home folder.
- `NO_TEAM`: `/team add <agents>`, or `/team compose` for a custom team.
- `AGENT_NOT_GENERATED` or non-empty `composition_problems`: `/team doctor`.
- A feature in progress: the command for its phase, from the table below.
- Team ready and nothing in progress: `/team plan <feature>` or `/team ship <feature>`.

| Recorded phase | Next command |
|---|---|
| `planning` | `plan`: get the go-ahead |
| `approved` | `build` |
| `development` | `integrate` |
| `integration` | `review` |
| `review` | `fix` if there are problems, otherwise `report` |
| `fix` | `integrate` |
| `done`, `stopped` | `report` if not yet presented; otherwise nothing |

## Questions about the approach

Answer without executing. To advise on a composition:

- **Start small:** one developer and one tester, then add a role only for a gap you have observed (bugs slipping through, security flaws, missing documentation).
- **Each agent adds cost and a risk of divergence.** Parallelism only makes sense if the scopes are truly independent.
- **If the result is poor, look at the spec first:** most failures come from vague acceptance criteria.
