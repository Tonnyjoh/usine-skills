# Design (between plan and build)

Only with an active `design` agent and a feature that has an interface. This phase exists because the look of an interface is decided before the code, and because a frontend agent left alone falls back on the same defaults as every other AI output.

If the feature has no interface, skip it explicitly, because the script otherwise blocks development:

```
team advance <name> development --no-interface "<reason>"
```

## 1. Direction

```
team advance <name> design
```

Launch the design agent with: the spec's absolute path, the project's existing `DESIGN.md` and `PRODUCT.md` if any, and any taste the user expressed in their own words. Add nothing about how it should look: the direction is its job.

`team context` says whether impeccable is installed. The agent works without it, but report that it was unavailable. Inside a subagent, impeccable also runs in a reduced form: no interview, no generated comps. The brief is therefore a written direction, not an image: say so when you present it.

## 2. Stop: the user chooses (auto mode: see [auto.md](auto.md))

**Stop** and present the brief `<design_dir>/<name>.md`: the direction in a few lines, the typography and colors, the references and what was taken from them. Say plainly which references were only seen by title, and pass on the agent's questions.

This is a matter of taste, so it belongs to the user. Build nothing before an explicit go-ahead. If they want changes, send them back to the design agent with their words.

## 3. Record the approval

```
team approve-design <name> --quote "<the user's exact words>"
```

It refuses a brief with no `## References` section containing URLs actually consulted or `UNREACHABLE`. From then on, the brief is locked like the spec: any change requires a new approval. If the user pins a font the script bans (Geist for a project whose identity uses it, for example), add it to `project.design.allowed_fonts` in `.team/team.json` with their consent.

## 4. Build

Continue with [build.md](build.md). Add the brief's absolute path to the frontend's brief ([briefs.md](briefs.md)).

## 5. Review

Run in phase 5 ([review.md](review.md)): the design agent checks the built result, then `team design-check` checks what can be checked mechanically.
