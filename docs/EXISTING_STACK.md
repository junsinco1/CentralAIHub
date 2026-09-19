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

## Important consequence

Do **not** run the fresh-install Compose stack yet.

The repository's `compose.yaml` remains a reproducible fallback/reference for a clean installation, but the existing containers should be preserved until their origin, mounts, networks, and persistence are documented.

`scripts/start.ps1` intentionally detects existing `open-webui` or `searxng` containers and refuses to create duplicates.

## Safe adoption inventory

Run the following commands on Windows. They intentionally avoid printing container environment variables because those may contain secrets.

### Container origin / Compose metadata

```powershell
docker inspect open-webui searxng github-mcp twilio-readonly --format '{{.Name}} | compose_project={{index .Config.Labels "com.docker.compose.project"}} | compose_workdir={{index .Config.Labels "com.docker.compose.project.working_dir"}} | compose_files={{index .Config.Labels "com.docker.compose.project.config_files"}}'
```

### Mounts / persistent storage

```powershell
docker inspect open-webui searxng github-mcp twilio-readonly --format '{{.Name}}{{range .Mounts}} | {{.Type}}:{{.Source}} -> {{.Destination}}{{end}}'
```

### Networks

```powershell
docker inspect open-webui searxng github-mcp twilio-readonly --format '{{.Name}} | networks={{range $k,$v := .NetworkSettings.Networks}}{{$k}} {{end}}'
```

### Restart policy

```powershell
docker inspect open-webui searxng github-mcp twilio-readonly --format '{{.Name}} | restart={{.HostConfig.RestartPolicy.Name}}'
```

## Adoption rule

Until this inventory is complete:

- do not recreate the containers
- do not rename them
- do not delete their volumes
- do not run `docker compose down -v`
- do not replace Open WebUI's data directory
- do not replace SearXNG's configuration

Once the current stack is mapped, CentralAIHub can document or manage it without risking existing accounts/settings.
