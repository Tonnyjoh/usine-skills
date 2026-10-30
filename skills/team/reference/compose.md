# Compose the team (phase 0)

Goal: a `.team/team.json` approved by the user, from which everything else is generated. Composing happens once; to change it, reread this file and go straight to step 3.

## 1. Start from the facts

Use `team context`. If `NOT_A_PROJECT` appears, ask for the project first. `team catalog` gives the known specialties and their instructions.

If the user provided a composition, use it as is. A value left empty or between `<...>` is not to be guessed.

## 2. Ask the missing questions

With multiple-choice questions ([tools.md](tools.md)), **all at once and 4 questions at most**: roles to activate, backend specialty, frontend specialty, verification commands. Offer the value deduced from the repository first. Do not ask what `context` establishes with certainty, but a "(to confirm)" value or a `null` verification remains a real question: a team with no verification command can prove nothing.

Typical compositions:

| Name | Agents | When |
|---|---|---|
| Light | one full-stack developer + reviewer | Most reliable to start with, no parallelism |
| Classic | backend + frontend + tester | API and interface well separated |
| Mobile | backend + mobile + tester + security | Mobile app and API |
| Reinforced | backend + frontend + data + tester + reviewer + security | Sensitive project, clearly higher cost |

Quality and design specialties, to offer if the role is active:

- tester: unit, integration, API contract, end-to-end, performance
- reviewer: general, performance, readability and architecture
- security: OWASP Top 10, secrets and dependencies, authentication and permissions
- ux: user journeys, interface states, accessibility
- documentation: technical documentation and README

## 3. Write `.team/team.json`

```json
{
  "version": 1,
  "project": {
    "name": "My project",
    "goal": "One sentence.",
    "specs_dir": "docs/specs",
    "contract": "docs/api/openapi.yaml",
    "tools": ["claude"]
  },
  "agents": [
    {
      "name": "backend",
      "role": "developer",
      "active": true,
      "specialty": "Java / Spring Boot",
      "repo": ".",
      "scope": ["backend"],
      "install": "./mvnw -q dependency:resolve",
      "verification": "cd backend && ./mvnw -q test",
      "model": "sonnet"
    },
    {
      "name": "tester",
      "role": "tester",
      "active": true,
      "specialty": "acceptance and contract tests",
      "repo": ".",
      "scope": ["backend/src/test", "frontend/src/**/*.spec.ts"],
      "verification": "cd backend && ./mvnw -q test",
      "model": "sonnet"
    }
  ]
}
```

What matters:

- `role` is `developer`, `tester`, `reviewer`, `security`, `ux` or `documentation`. Several agents can share a role (`backend-api`, `backend-worker`) if their scopes are disjoint.
- `scope` and the `project` paths are **relative to the project root**. `verification` runs in `repo`.
- Outside the catalog, `specialty` is `other: ...`: explore the repository, write `instructions` from the actual conventions and ask for confirmation. Add `purpose` if the agent's name does not say what it implements ("the mailing service", for example).
- `contract` can be `null` only with a single developer and no API involved.
- The documentation agent's `scope` never includes the specs or the contract; the script reports it as an incident anyway.

**Several repositories under a root without git** (`MULTI_REPO`): `repo` is the repository's folder, `scope` starts with it (`["api-myproject"]`) and the session must be started at the common root. Put specs and contract in the producing repository (`api-myproject/docs/specs`), otherwise they would be versioned nowhere.

## 4. Present and wait

Apply these rules and report any problem (`team preflight` checks them too):

1. At least one active developer, otherwise ask what to do.
2. One developer: simple sequential mode, the most reliable setup.
3. Several developers: disjoint scopes and a contract written before the code.
4. More than 4 active agents: warn about the cost and offer a smaller version.
5. Quality agents: always after integration and with a blank context.

Show the table: agent, specialty, scope, verification, tools, model, stating the planned mode. **Wait for agreement before creating files.** Writing `team.json` and generating come after.

## 5. Generate

```
team scaffold --dry-run    # what would be created, writing nothing
team scaffold
```

The script never replaces an existing, different file: it returns it in `to_confirm` with its diff. Show the diff, ask, and rerun with `--overwrite <file>` only after consent. This also applies to the section added to an existing `CLAUDE.md`.

For each active agent it creates one file per tool in `project.tools` (`.claude/agents/<name>.md`, `.codex/agents/<name>.toml`), then `<specs_dir>/_spec-template.md`, the contract skeleton if missing, and the "Agent team" section of `CLAUDE.md`, plus `AGENTS.md` if another tool is declared.

## 6. Report

Say exactly what was created and what was left untouched. New agents are sometimes visible only after a restart: ask to restart the session or run `/agents`, or apply [degraded.md](degraded.md) if the user prefers to continue right away.
