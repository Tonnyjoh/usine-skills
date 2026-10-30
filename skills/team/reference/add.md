# Add agents

The short way: the user names the agents they want, you deduce the rest from the project. No interrogation. The same path serves the first setup and adding an agent later (`add back` on an existing team).

## 1. Propose

```
team propose front test
```

Known names: `front`, `back`, `mobile`, `data`, `devops`, `design`, `test`, `review`, `security`, `ux`, `doc`.

To choose the stack, add it after a colon: `front:next`, `back:nest`. The choice wins over what the repository suggests, and an empty project needs one.

| Agent | Stacks |
|---|---|
| `front` | `next`, `react`, `angular`, `vue`, `nuxt`, `svelte`, `astro` |
| `back` | `nest`, `express`, `spring`, `fastapi`, `django`, `laravel`, `symfony`, `php`, `dotnet`, `go` |
| `mobile` | `flutter`, `rn`, `compose`, `swiftui` |
| `data` | `postgres`, `mysql`, `mongo`, `oracle` |
| `devops` | `docker`, `actions`, `gitlab`, `k8s`, `terraform` |

If the user gave no stack and `to_confirm` asks for one, ask with these choices, deduced stack first. Nothing is written at this stage.

## 2. Confirm

Show `table` once and ask for a simple agreement. Ask a question only for what appears in `to_confirm` or `problems`: those are the cases the repository cannot settle, and a team with no verification command could prove nothing.

If those questions change the proposal, edit `.team/team.json` afterwards (see its format in [compose.md](compose.md)).

A Laravel or Symfony project with Vue or React in the same folder gives `OVERLAPPING_SCOPES` for `add back front`: ask where the frontend lives (`resources/js`, `assets`) and narrow both scopes in `.team/team.json`.

From the second developer on, a contract becomes mandatory and `propose` adds its path: say so in one sentence, because this is what lets front and back work without stepping on each other.

## 3. Generate

```
team propose front test --write
team scaffold
```

Existing files are not replaced: `to_confirm` returns their diff, including for an existing `CLAUDE.md` or `AGENTS.md`. Show it and rerun with `--overwrite <file>` after consent.

## 4. Conclude

In two lines: the available agents, and how to use them.

- For a complete feature: `/team ship <feature>`.
- For a targeted task, the agents can also be called directly ("ask the frontend to…"), without the full process.

If the new agents are not recognized in this session, say that a restart or `/agents` will load them.
