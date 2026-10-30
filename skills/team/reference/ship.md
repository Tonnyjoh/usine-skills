# Ship a feature end to end

Chain the phases, loading each reference when you reach it. "Ship" does not allow skipping a stop: it only saves the user from retyping a command between two.

1. [add.md](add.md) or [compose.md](compose.md) if the team does not exist. **Stop: agreement on the team.** If the agents require a restart, see [degraded.md](degraded.md).
2. [plan.md](plan.md). **Stop: go-ahead on the spec, contract and split.**
3. [build.md](build.md)
4. [integrate.md](integrate.md)
5. [review.md](review.md), then [fix.md](fix.md) as long as needed, three rounds at most.
6. [report.md](report.md). **Stop: the user decides about the commit and what comes next.**

Between two stops, continue without asking for confirmation. Resuming after an interruption starts from `team status`, never from your memory of the conversation.
