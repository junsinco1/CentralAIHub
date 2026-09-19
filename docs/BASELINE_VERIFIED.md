# Verified Baseline

_Verified on Windows: 2026-09-18._

## Core services

The current CentralAIHub baseline is operational without recreating the existing containers.

### Host-side validation

- Open WebUI: HTTP 200 on `127.0.0.1:3000`
- SearXNG: HTTP 200 on `127.0.0.1:8080`
- LM Studio: reachable on `127.0.0.1:1234`

### LM Studio models reported

- `qwen3-coder-30b-a3b-instruct`
- `qwen2.5-coder-14b-instruct`
- `qwen/qwen3.5-9b`
- `google/gemma-4-e4b`
- `openai/gpt-oss-20b`
- `text-embedding-nomic-embed-text-v1.5`

### Container-to-service validation

From inside the existing `open-webui` container:

- LM Studio `/v1/models`: HTTP 200
- SearXNG JSON search: HTTP 200
- SearXNG query returned 28 results in the validation run

### Existing integration containers

- `github-mcp`: running
- `twilio-readonly`: running

### Docker network

The shared `local-ai` network contains:

- `open-webui`
- `searxng`
- `github-mcp`
- `twilio-readonly`

## Baseline decision

This existing stack is the official CentralAIHub baseline.

Do not recreate Open WebUI or SearXNG simply to move them under a new Compose project.

Preserve:

- the `open-webui` data volume
- existing SearXNG configuration/cache volumes
- the `local-ai` Docker network
- current container names until an intentional migration is planned

The repository `compose.yaml` remains a clean-install/recovery reference rather than the active owner of these running containers.

## Next phase

1. identify the safe HTTP/runtime shape of `github-mcp`
2. identify the safe HTTP/runtime shape of `twilio-readonly`
3. validate those integrations without exposing their secrets
4. add Supabase read-only/status integration
5. add Render read-only/status integration
6. add browser automation only after the controlled integration layer is stable
