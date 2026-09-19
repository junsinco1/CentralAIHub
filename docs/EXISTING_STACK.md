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

## Origin / management model

No `com.docker.compose.*` labels were present on any of the four containers.

Therefore they should be treated as **manually created/non-Compose-managed containers** unless later evidence shows another manager created them.

CentralAIHub will not replace them merely to force them under Compose management. The current containers are healthy, persistent, and already connected through `local-ai`.

The repository's `compose.yaml` is a clean-install/recovery reference, not the active manager for these running containers.

## Adoption rule

Preserve the running stack:

- do not recreate the containers without a migration plan
- do not rename them
- do not delete their volumes
- do not run `docker compose down -v` against a replacement stack
- do not replace Open WebUI's data directory
- do not replace SearXNG's configuration
- do not dump container environment variables into Git, logs, or chat

CentralAIHub can manage the current installation operationally through documented container names and safe scripts without rebuilding it.

## Next step

Validate each existing service from the user side:

1. Open WebUI loads on port 3000
2. Open WebUI can chat with LM Studio models
3. SearXNG loads on port 8080
4. Open WebUI web search successfully uses SearXNG
5. GitHub MCP responds through the existing integration
6. Twilio read-only responds through the existing integration

Only missing capabilities should be added. Working services should not be rebuilt.
