# Plan a feature (phases 1 and 2)

You work alone: no agent runs before the go-ahead. This is the cheapest moment to correct a mistake, and the one that most often decides the final quality.

If the request is really a small task, say so and handle it directly.

## 1. Understand

`team start <name-in-lowercase-with-hyphens>`, then explore the code to understand the conventions and what already exists.

If essential information is missing, ask **at most 5 short questions, all at once**. Do not ask what the code or a conventional choice establishes.

## 2. Write the spec

`<specs_dir>/<name>.md` from `_spec-template.md`. The quality criterion: a tester who has read only this file knows what to check.

- Numbered criteria AC-1, AC-2… in the form "Given…, when…, then <observable result>". "The interface is pleasant" cannot be tested; "the button is disabled while the email is invalid" can.
- Business rules BR-x, error cases EC-x, the interface and its states (loading, empty, error, access denied), constraints, out of scope.
- Any decision you made for the user goes in "Open questions" or in the assumptions you will present.

## 3. Complete the contract

Endpoints, schemas, error codes, use of the `Error` schema. Precise down to field names: whatever stays vague will be interpreted differently on each side. Without an API, an equivalent interface contract (shared types, events) plays the same role.

## 4. Validate: mandatory stop

**Stop** and present:

- a summary of the spec and contract;
- the assumptions made;
- the planned split: which agent, which criteria;
- the mode, given by `team preflight`: sequential, per-repo or worktree.

Delegate nothing before an explicit go-ahead. An "ok" to another question is not one.

## 5. Record the approval

```
team approve <name> --quote "<the user's exact words>"
```

The script sets the spec to "approved" and stores its fingerprint and the contract's. If either changes afterwards, development is refused (`SPEC_CHANGED_AFTER_APPROVAL`): present the change, get a new approval, then rerun this command.
