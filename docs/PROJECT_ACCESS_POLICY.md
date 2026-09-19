# Project Access Policy

## Default: read-only

CentralAIHub may inspect application repositories for context, including:

- README and AI_CONTEXT files
- source code
- build manifests
- schemas and migrations
- deployment documentation
- Git history and branches
- issues and pull requests
- architecture and integration contracts

This does **not** authorize edits.

## When writes are allowed

Application repository writes are permitted only when the user intentionally starts a coding task for that specific project.

Examples:

- "Finish BrightPathHome with Qwen"
- "Open Lampwell and fix this bug"
- "Have Continue implement this feature in AdvisorWorkspace"
- "Let Codex clean up this project"

In that case, the coding workflow may edit the selected repository while respecting its own `AI_CONTEXT.md`, tests, release boundaries, and production safeguards.

## What does not authorize writes

These activities remain read-only with respect to app repos:

- CentralAIHub setup
- adding models
- adding Open WebUI tools
- configuring SearXNG
- provider API setup
- GitHub MCP setup
- Twilio tool access
- Supabase/Render inventory
- project discovery or architecture review
- creating the cross-project registry

## External services

CentralAIHub can connect to GitHub, Twilio, Supabase, Render, and other services to provide context and tooling.

Connection does not imply mutation permission.

Provider integrations should default to read-only where practical.

## Existing in-progress services

The existing `github-mcp` and `twilio-readonly` containers remain connected to the shared `local-ai` network but are not owned by CentralAIHub infrastructure work. Their implementation/reconfiguration belongs to the separate project/Codex workflow.

## Production

Even during an intentional coding task, code changes do not imply permission to:

- deploy production
- run production migrations
- change live phone routing
- send outreach
- rotate credentials
- alter production data

Those actions require their own explicit authorization.
