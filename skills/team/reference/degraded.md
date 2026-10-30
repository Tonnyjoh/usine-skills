# Degraded mode

## Project agents not recognized

Newly created agent files may load only after a restart. Offer to restart the session (or run `/agents` in Claude Code), then continue with "Continue at phase 1". If the user prefers to continue right away, or if your tool has no generated agent format:

1. Read the agent's file or, if there is none for your tool, `.claude/agents/<name>.md` or `.codex/agents/<name>.toml`.
2. Launch your tool's generic agent with, at the top of the prompt, that file's instructions without its header, then the brief.
3. Mention the substitution once. The guarantee changes on one point: tool restrictions no longer apply, so `scope-check` becomes the only barrier for read-only agents.

## No subagents in this environment

Perform the roles yourself, one after the other, in sequential mode. For each role, adopt only the instructions in its agent file.

A check run by whoever just wrote the code is not independent, however carefully it is done. Say so clearly in the report. Nothing else changes: the stops, `verify` and the three rounds still apply.

## No git

No worktree, no `scope-check`, no fingerprint: a verification therefore never becomes "stale". Offer `git init`, with consent. Otherwise, work sequentially, rerun `verify --all` at the very end, and state these limits in the report.
