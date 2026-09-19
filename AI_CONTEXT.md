# AI Context — CentralAIHub

## Purpose

CentralAIHub is the shared local-AI infrastructure/control-plane repository.

It exists to coordinate models, tools, search, integrations, and project awareness across Pedro's separate application repositories.

It is not itself a CRM, insurance app, finance app, nursing app, Bible app, trading app, or production backend.

## Primary environment

Windows desktop is the primary AI machine.

Current known hardware/workflow:

- NVIDIA GeForce RTX 5070 Ti
- 32 GB RAM currently
- LM Studio local inference server
- VS Code + Continue for direct repository editing
- Docker Desktop for containerized services
- Git + GitHub for version control
- Tailscale for remote access
- MacBook Air is a remote client/backup environment

## Verified local status — 2026-09-18

Windows diagnostics confirmed:

- Docker 29.8.0
- Docker Compose v5.5.1
- LM Studio reachable at `127.0.0.1:1234`
- existing `open-webui` container on host port 3000
- existing `searxng` container on host port 8080
- existing `github-mcp` container on host port 8082
- existing `twilio-readonly` container on host port 8001

LM Studio reported:
- qwen3-coder-30b-a3b-instruct
- qwen2.5-coder-14b-instruct
- qwen/qwen3.5-9b
- google/gemma-4-e4b
- openai/gpt-oss-20b
- text-embedding-nomic-embed-text-v1.5

Therefore CentralAIHub is in **adoption mode**, not fresh-install mode. Preserve the existing containers and their persistent storage until their origin/mount/network metadata is documented.

See `docs/EXISTING_STACK.md`.

## Model roles

### Heavy local coding
- Qwen3-Coder 30B A3B

### Lighter general/tool work
- Qwen3.5 9B

### Cloud review
- Codex may be used for final review, cleanup, verification, or difficult tasks after local work.

Do not assume a model is loaded merely because it is listed here. Validate the LM Studio model endpoint before depending on it.

## Architecture boundaries

CentralAIHub may contain:

- Docker/service definitions
- local AI configuration
- Open WebUI configuration guidance
- SearXNG configuration
- integration adapters
- read-only project inventory/metadata
- scripts for local environment checks
- documentation
- safe examples/placeholders

CentralAIHub must not become the source repository for existing apps.

Application source stays in each application's own repository.

## Source of truth

GitHub repositories are the source of truth for application code.

Each active project should maintain its own `AI_CONTEXT.md` with project-specific constraints.

`docs/PROJECT_REGISTRY.md` is CentralAIHub's cross-project map.

## Production safety restrictions

- Never commit real secrets, tokens, passwords, private keys, certificates, provisioning profiles, database dumps, client/patient data, or user exports.
- Never copy production secrets into documentation, examples, prompts, or test fixtures.
- Do not enable production deployment merely to validate CentralAIHub.
- Do not run database migrations against production without explicit project-specific authorization.
- Do not change Twilio routing, Render production services, Supabase production policies, App Store configuration, DNS, or live application settings as part of infrastructure setup unless explicitly requested.
- Prefer read-only integrations first.
- Use synthetic data for testing.
- Keep staging and production identities separate.
- Do not let one app's credentials or data leak into another app's context.

## Project identity rule

Before editing any repository:

1. identify the repository exactly
2. read its `README`, `AI_CONTEXT.md`, and relevant manifests/configuration
3. confirm whether it is a product, module, backend, prototype, or legacy repository
4. preserve its existing deployment/data boundaries
5. only then make changes

This rule exists specifically to prevent similarly named BrightPath repositories from being confused.

## InfiniteTalk

InfiniteTalk is complete and out of scope for CentralAIHub setup.

## Current phase

**Core baseline verified.**

Open WebUI, LM Studio, and SearXNG were validated end to end.

The existing `github-mcp` and `twilio-readonly` containers are **frozen/out of scope for CentralAIHub changes**. They belong to another unfinished project and must be left for Codex/that project to manage.

CentralAIHub now owns two new isolated adapters:
- `supabase-readonly`
- `render-readonly`

Both expose GET-only provider operations, join `local-ai`, and bind host test ports to localhost only.

See:
- `docs/BASELINE_VERIFIED.md`
- `docs/READ_ONLY_INTEGRATIONS.md`

## Verified provider adapters — 2026-09-18

The CentralAIHub-owned provider adapters are now running and verified:

- `supabase-readonly` -> host `127.0.0.1:8002`
- `render-readonly` -> host `127.0.0.1:8003`

Verified HTTP 200:
- Supabase `/health`
- Supabase `/organizations`
- Supabase `/projects`
- Render `/health`
- Render `/workspaces`
- Render `/services`

Both containers join the existing `local-ai` network and their host ports bind to localhost only.

## Project modification policy

CentralAIHub infrastructure work must treat all application repositories as **read-only by default**.

Reading README files, AI_CONTEXT files, manifests, source, issues, deployment metadata, and project state for context is allowed.

Writing to an application repository is allowed only when Pedro intentionally starts a coding task for that specific project, for example:
- opening `BrightPathHome` in VS Code
- using Continue + Qwen to implement/fix code
- explicitly asking Codex to review or modify that project

Infrastructure setup, tool wiring, provider integration, search configuration, and hub maintenance are never sufficient authorization to edit an application repository.

Existing `github-mcp` and `twilio-readonly` stay connected to CentralAIHub for context/tool access but are not to be recreated or reconfigured by this infrastructure project.

## Next task

Register the verified Supabase and Render OpenAPI adapters in Open WebUI, then document the connected tool layer while preserving this project-write boundary.


## Open WebUI tool routing verified — 2026-09-18

Qwen3.5 9B successfully called the live Supabase, Render, and Twilio read-only tools from Open WebUI.

The backend/OpenAPI wiring is therefore verified.

Use `docs/CENTRALAIHUB_QWEN_PROMPT.md` as the system prompt for a dedicated Open WebUI CentralAIHub preset.

Provider tools should be preferred over memory/knowledge retrieval for live service questions.
