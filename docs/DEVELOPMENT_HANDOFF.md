# CentralAIHub Development Handoff

## Goal

CentralAIHub diagnoses across live tools and repository context.

Actual code edits happen only after Pedro explicitly selects a project and opens that repository in VS Code with Continue + Qwen3-Coder 30B A3B.

## Division of labor

### CentralAIHub-20B
Use for:
- GitHub read-only inspection
- Supabase/Render/Twilio read-only inspection
- staging vs production reasoning
- identifying the correct repository
- locating likely files/components
- writing a coding handoff packet

It should not edit application code itself.

### Qwen3-Coder 30B A3B + Continue
Use for:
- direct repository edits
- multi-file implementation
- refactoring
- debugging
- tests
- local validation

### Codex
Use after local coding for:
- second-pass review
- cleanup
- edge cases
- release/readiness review
- difficult bugs

## Explicit activation rule

A repository becomes writable only when Pedro explicitly starts a coding task for that repository.

Examples:
- "Work on BrightPathHome."
- "Use local AI to finish BrightPathHome."
- "Fix this bug in Lampwell."

CentralAIHub setup or inspection never activates write permission.

## Recommended workflow

1. Ask CentralAIHub-20B to diagnose the issue using live tools and GitHub.
2. Ask it to produce a **Coding Handoff Packet**.
3. Open the exact repository locally in VS Code.
4. Start Continue Agent with Qwen3-Coder 30B A3B.
5. Paste the handoff packet.
6. Tell Continue to read the local README, AI_CONTEXT.md, and relevant manifests before editing.
7. Make changes only in the selected repo.
8. Run local tests/builds.
9. Review `git diff`.
10. Commit only after review.
11. Use Codex for a final pass when desired.
12. Deployment is a separate explicit step.

## Coding Handoff Packet format

CentralAIHub-20B should return:

```text
CODING HANDOFF

Repository:
<exact owner/repo>

Local project:
<expected local folder if known>

Objective:
<one clear coding objective>

Why this repo:
<why this is the correct code owner>

Observed live state:
- GitHub:
- Supabase:
- Render:
- Twilio:
(only relevant providers)

Staging/production boundary:
<explicit separation>

Relevant files/components:
- <path>
- <path>

Known constraints:
- <constraint>
- <constraint>

Requested implementation:
1. ...
2. ...

Required validation:
- ...
- ...

Do not:
- modify other repositories
- deploy production
- run production migrations
- change live Twilio routing
- rotate credentials

Completion report:
- files changed
- tests/builds run
- unresolved issues
- recommended Codex review points
```

## Continue first instruction

After opening the target repo in VS Code, prepend this instruction to the handoff:

```text
You are working only in the currently opened repository.

Before editing:
1. Read README.md.
2. Read AI_CONTEXT.md if present.
3. Inspect the relevant manifests/build files.
4. Confirm the staging/production boundary.
5. Inspect git status.
6. Do not touch another repository.
7. Do not deploy or change production infrastructure.

Then implement the CODING HANDOFF below.
```

## Safety

Code authorization is not deployment authorization.

Even during an active coding task, do not:
- deploy production
- run production migrations
- change production provider settings
- send real communications
- alter phone routing
- rotate secrets

unless Pedro separately and explicitly authorizes that action.
