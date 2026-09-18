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

Foundation and validation.

Next work should validate the Windows environment before adding live service configuration.
