# Existing Windows AI Stack

_Observed from Pedro's Windows desktop on 2026-09-18._

CentralAIHub discovered that the core services already exist as running Docker containers. The correct path is to **adopt and document the existing stack**, not create duplicates.

## Running containers observed

| Container | Image | Published port |
|---|---|---:|
| `open-webui` | `ghcr.io/open-webui/open-webui:main` | 3000 -> 8080 |
| `searxng` | `searxng/searxng:latest` | 8080 -> 8080 |
| `github-mcp` | `ghcr.io/github/github-mcp-server` | 8082 -> 8082 |
| `twilio-readonly` | local image `twilio-readonly` | 8001 -> 8001 |

LM Studio is running natively on Windows at `127.0.0.1:1234`.

Models reported by LM Studio:

- `qwen3-coder-30b-a3b-instruct`
- `qwen2.5-coder-14b-instruct`
- `qwen/qwen3.5-9b`
- `google/gemma-4-e4b`
- `openai/gpt-oss-20b`
- `text-embedding-nomic-embed-text-v1.5`

## Verified persistence and topology

### Open WebUI
- Persistent named volume: `open-webui`
- Mounted to: `/app/backend/data`
- Networks: `bridge`, `local-ai`
- Restart policy: `unless-stopped`

This volume contains the Open WebUI application data and must be preserved.

### SearXNG
- Persistent volume mounted to `/etc/searxng`
- Persistent cache volume mounted to `/var/cache/searxng`
- Network: `local-ai`
- Restart policy: `unless-stopped`

The two volume IDs currently appear Docker-generated/anonymous. Do not delete or replace them until the current SearXNG configuration has been captured safely.

### GitHub MCP
- No filesystem mount observed
- Network: `local-ai`
- Restart policy: `unless-stopped`

Any authentication/configuration may therefore be provided through runtime configuration rather than a mounted data directory. Do not print environment variables into logs or chat while inventorying it.

### Twilio read-only
- No filesystem mount observed
- Network: `local-ai`
- Restart policy: `unless-stopped`

Any credentials/configuration may therefore be provided through runtime configuration rather than a mounted data directory. Do not print environment variables into logs or chat while inventorying it.

### Shared Docker network

`searxng`, `github-mcp`, and `twilio-readonly` share the `local-ai` network.

`open-webui` is attached to both `bridge` and `local-ai`, allowing it to participate in the shared AI-service network while retaining its other Docker connectivity.

## Important consequence

Do **not** run the fresh-install Compose stack yet.

The repository's `compose.yaml` remains a reproducible fallback/reference for a clean installation, but the existing containers should be preserved until their origin/Compose metadata is documented.

`scripts/start.ps1` intentionally detects existing `open-webui` or `searxng` containers and refuses to create duplicates.

## Remaining inventory item

Container origin / Compose metadata is still required.

Run:

```powershell
docker inspect open-webui searxng github-mcp twilio-readonly --format '{{.Name}} | compose_project={{index .Config.Labels "com.docker.compose.project"}} | compose_workdir={{index .Config.Labels "com.docker.compose.project.working_dir"}} | compose_files={{index .Config.Labels "com.docker.compose.project.config_files"}}'
```

This reveals whether the containers came from Docker Compose and, if so, which project/workdir/config file created them.

## Adoption rule

Until the origin inventory is complete:

- do not recreate the containers
- do not rename them
- do not delete their volumes
- do not run `docker compose down -v`
- do not replace Open WebUI's data directory
- do not replace SearXNG's configuration

Once origin metadata is mapped, CentralAIHub can document or manage the existing stack without risking existing accounts/settings.
