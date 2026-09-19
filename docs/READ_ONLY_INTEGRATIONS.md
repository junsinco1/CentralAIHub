# Read-only Supabase and Render integrations

These adapters are owned by CentralAIHub and are separate from the existing `github-mcp` and `twilio-readonly` containers.

## Scope freeze

CentralAIHub must **not modify, recreate, secure, reconfigure, or otherwise manage**:

- `github-mcp`
- `twilio-readonly`

Those services belong to another in-progress effort and are reserved for Codex/that project.

## New adapters

### supabase-readonly

Container name:

```text
supabase-readonly
```

Host test URL:

```text
http://127.0.0.1:8002
```

Docker/Open WebUI URL:

```text
http://supabase-readonly:8002
```

Exposed operations:

- health
- list organizations
- list projects
- list projects in an organization

No create/update/delete endpoints exist in this adapter.

### render-readonly

Container name:

```text
render-readonly
```

Host test URL:

```text
http://127.0.0.1:8003
```

Docker/Open WebUI URL:

```text
http://render-readonly:8003
```

Exposed operations:

- health
- list workspaces
- list services
- list projects
- list deploy history for a service

No deploy/update/restart/delete endpoints exist in this adapter.

## Security model

- host ports bind to `127.0.0.1` only
- containers join the existing private `local-ai` Docker network
- provider credentials stay in local `.env.integrations`
- provider credentials are never returned by the adapters
- upstream error bodies are not forwarded
- the adapters implement GET-only provider calls
- no application database content is queried by these Management API adapters

## Setup

Create the local environment file:

```powershell
Copy-Item .env.integrations.example .env.integrations
notepad .env.integrations
```

Add the provider tokens locally, then start only these new services:

```powershell
docker compose -f compose.integrations.yaml up -d --build
```

Verify:

```powershell
curl.exe http://127.0.0.1:8002/health
curl.exe http://127.0.0.1:8003/health
```

## Open WebUI

For **Global Tool Servers** in Open WebUI Admin Settings, use:

```text
http://supabase-readonly:8002
http://render-readonly:8003
```

Open WebUI's backend is already attached to `local-ai`, so it can resolve those container names directly.

FastAPI exposes each OpenAPI spec automatically at:

```text
/openapi.json
```

Only enable the tools after their local health and provider-list calls have been verified.
