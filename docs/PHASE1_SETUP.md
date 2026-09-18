# Phase 1 Setup — Open WebUI + LM Studio + SearXNG

Validated against the current official LM Studio, Open WebUI, and SearXNG documentation on 2026-09-18.

## Scope

Phase 1 intentionally does only three things:

1. keep LM Studio running natively on Windows
2. run Open WebUI in Docker
3. run SearXNG in Docker and connect it to Open WebUI

No GitHub/Supabase/Render/Twilio credentials are required yet.

## Safety posture

The initial Compose file binds both browser-facing services to `127.0.0.1` only:

- Open WebUI: `127.0.0.1:3000`
- SearXNG: `127.0.0.1:8081`

This prevents accidental LAN/public exposure during initial validation.

Remote Tailscale access will be added only after local validation.

## Prerequisites

On the Windows desktop:

- Docker Desktop is installed and running
- LM Studio is installed
- LM Studio local server is enabled on port 1234
- at least one chat model is loaded or loadable
- Git is installed

LM Studio's OpenAI-compatible endpoint is expected at:

```text
http://127.0.0.1:1234/v1
```

Docker containers reach the Windows host through:

```text
http://host.docker.internal:1234/v1
```

## 1. Clone the repo

Recommended Windows path:

```text
C:\Users\pedro\OneDrive\Documents\GitHub\CentralAIHub
```

From PowerShell:

```powershell
cd "$env:USERPROFILE\OneDrive\Documents\GitHub"
git clone https://github.com/junsinco1/CentralAIHub.git
cd CentralAIHub
```

If it is already cloned:

```powershell
cd "$env:USERPROFILE\OneDrive\Documents\GitHub\CentralAIHub"
git pull
```

## 2. Run diagnostics before starting containers

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\diagnose.ps1
```

The most important result is that LM Studio responds on port 1234 and lists models.

## 3. Create the local environment file

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\bootstrap-env.ps1
```

This creates `.env` from `.env.example` and generates random local secrets for Open WebUI and SearXNG.

`.env` is ignored by Git.

## 4. Start Phase 1

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start.ps1
```

Or directly:

```powershell
docker compose up -d
```

## 5. Open the services

Open WebUI:

```text
http://127.0.0.1:3000
```

SearXNG:

```text
http://127.0.0.1:8081
```

## 6. Verify the LM Studio connection

The Compose configuration preconfigures Open WebUI's OpenAI-compatible backend as:

```text
http://host.docker.internal:1234/v1
```

If the connection does not appear, use Open WebUI Admin > Connections and add that URL manually.

If LM Studio authentication is enabled, put the LM Studio API token in the local `.env` as `LM_STUDIO_API_KEY` and recreate Open WebUI.

## 7. Verify SearXNG

SearXNG has JSON output enabled in:

```text
services/searxng/settings.yml
```

Open WebUI is configured to query:

```text
http://searxng:8080/search?q=<query>
```

Web search is enabled in the Compose environment. Open WebUI stores many admin settings persistently; if a setting was changed later through the Admin UI, that saved value may take precedence over the environment default.

## Stop without deleting data

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\stop.ps1
```

or:

```powershell
docker compose down
```

Do not add `-v` unless you intentionally want to delete persistent Open WebUI/SearXNG volumes.

## Phase 1 acceptance checks

Phase 1 is successful when:

- `http://127.0.0.1:1234/v1/models` returns LM Studio models
- Open WebUI loads on port 3000
- a local LM Studio model can answer from Open WebUI
- SearXNG loads on port 8081
- Open WebUI web search returns SearXNG results
- restarting the containers preserves the Open WebUI account/settings

Only then proceed to remote/Tailscale access and external integrations.
