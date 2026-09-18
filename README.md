# CentralAIHub

CentralAIHub is the dedicated infrastructure and orchestration repository for Pedro's local AI environment.

It is **not an application product repository**. Existing application repositories remain independent products with their own source, data boundaries, release processes, and `AI_CONTEXT.md` files.

## Purpose

CentralAIHub provides the shared local-AI layer around those applications:

- centralized model hosting on the Windows RTX 5070 Ti desktop
- Open WebUI as the general AI interface
- LM Studio as the primary local model server
- Qwen3-Coder 30B A3B for heavier coding work
- Qwen3.5 9B for lighter general/tool tasks
- SearXNG for private/self-hosted web search
- controlled integrations for GitHub, Supabase, Render, Twilio, and later browser automation
- a project registry so agents know which repository is which
- shared operating rules for local AI, Continue, Codex, and future agents

## Core rule

**CentralAIHub orchestrates projects. It does not absorb them.**

For example:

- `AdvisorWorkspace` stays the public advisor product.
- `BrightPathWorkspace` stays the private BrightPath advisor product.
- `BrightPathHome` stays the agency/CRM hub.
- `BrightPathPlatformCore` stays the shared application contract library.
- `CentralAIHub` only supplies shared AI infrastructure and project awareness.

## Primary machine

Windows desktop:

- NVIDIA GeForce RTX 5070 Ti
- 32 GB RAM currently
- LM Studio
- VS Code
- Continue
- Docker Desktop
- Git
- Tailscale

The MacBook remains a remote client/backup environment rather than a duplicate heavy AI host.

## Workflow

```text
Project repo
   |
VS Code + Continue
   |
LM Studio
   |
Qwen local models
   |
local edits/tests
   |
Git
   |
GitHub
   |
Codex final review / cleanup when desired
```

Open WebUI provides the separate conversational/tool-facing interface.

## Current phase

Phase 1 is infrastructure foundation only:

1. establish repository/context documentation
2. validate Windows prerequisites
3. connect Open WebUI to LM Studio
4. add SearXNG
5. add controlled integrations one at a time
6. add browser automation only after the core stack is stable

No production application is automatically deployed or modified by this repository.

See:

- [AI_CONTEXT.md](AI_CONTEXT.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Project registry](docs/PROJECT_REGISTRY.md)
- [Service ports](docs/SERVICE_PORTS.md)
- [Operating rules](docs/OPERATING_RULES.md)
