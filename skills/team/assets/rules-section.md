## Agent team

Managed by the `/team` skill (`.team/team.json`). The project lead is the main session.

{{TABLE}}

### Rules

1. The contract, written before the code, is the source of truth between producers and consumers. Developers never change it: if it is insufficient, they stop and report it.
2. Each agent writes only in its scope. Any step outside it is an incident to report.
3. Each subagent starts with no memory: briefs are complete.
4. Quality agents stay independent: spec and contract, never the developers' reasoning.
5. A task is done only when the verifications really pass.
6. No irreversible action without explicit consent: data deletion, `git push --force`, destructive migration, deployment, sending messages.
7. No secrets in the code: environment variables only.
8. No silent assumptions: an ambiguity becomes a question.
9. At most 3 fix rounds per feature.
10. No team for a small task: an isolated bug or a narrow change is handled directly.
11. No commit without asking the user, every time. Also ask whether the commit should carry an attribution line (`Co-Authored-By: … <noreply@…>`): several AI tools or people may work on this project, so nothing is added by default. Commit messages are written in English.
12. No generic AI look: no em dashes in interface text, no generic default font unless the project chose it, no sparkle, star or magic-wand icons, and no emoji anywhere in the code, comments, logs or commit messages. `team design-check` enforces what it can detect.

### Developer report

```
STATUS: done | blocked | partial
FILES CHANGED: <list>
CRITERIA COVERED: AC-x ...
VERIFICATIONS: <command> -> <real result>
PROBLEMS / QUESTIONS: <list or "none">
DEVIATIONS FROM THE CONTRACT: <list or "none">
```
