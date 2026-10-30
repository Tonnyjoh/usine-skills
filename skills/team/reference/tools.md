# By tool

The process, the script and the files are the same everywhere. Only the actions below change.

| Action | Claude Code | Codex | Other tool |
|---|---|---|---|
| Invoke the skill | `/team …` | `$team …` | Depends on the tool, or have it read `SKILL.md` |
| Agent files | `.claude/agents/<name>.md` | `.codex/agents/<name>.toml` | None: see [degraded.md](degraded.md) |
| Launch an agent | `Agent` tool, `subagent_type` = the name | Explicitly ask to launch the agent by name | See [degraded.md](degraded.md) |
| Isolate an agent | `isolation: "worktree"` | Create the worktree yourself (below) | Create the worktree yourself, if the tool allows it |
| Ask questions | Interactive question tool | Message with numbered choices | Message with numbered choices |
| Rules read | `CLAUDE.md` | `AGENTS.md` | `AGENTS.md`, if the tool reads it |

The skill targets Claude Code first: by default, `project.tools` in `.team/team.json` is `["claude"]`. On a project shared with Codex, set `["claude", "codex"]`, then rerun `team scaffold`: it adds `.codex/agents/` and `AGENTS.md`. Codex support follows its documentation but has not been tried in a real Codex session.

## Creating a worktree yourself

```
git worktree add .team/worktrees/<agent> -b team-wt/<agent>
```

Add `.team/worktrees/` to the local ignore file (`.git/info/exclude`) and give the agent this absolute path as its working folder. Like any worktree, it starts from the last commit: briefs therefore keep absolute paths to the spec and the contract.

A tool's sandbox may refuse this command because it writes to `.git` (Codex does by default). If so, do not widen the sandbox yourself: go **sequential** in the current tree, and say why.

## What each tool really guarantees

- **Read-only:** Claude Code removes the agent's write tools; Codex does not, since an agent file can limit neither the sandbox nor writing. There, only the instruction prevents it: so run `team scope-check` after each reviewer, without exception.
- **Model:** `model` concerns only Claude Code. A Codex agent inherits the session's model unless `codex_model` is set.
- **Independent checks:** they require an agent with a blank context. Without real subagents, say so in the report.

- **Seeing the design:** the design agent uses Claude in Chrome when it is connected and the site is permitted, in the user's real browser and read-only on public pages. Without a browser, it only has text and titles and must say so. The design agent file sets no tool list so that it inherits these tools.

The `team` script needs only Python 3 and git, and depends on no tool.
