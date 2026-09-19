# Service Ports

Observed on the Windows desktop on 2026-09-18.

| Service | Host port | Container/internal port | Status |
|---|---:|---:|---|
| LM Studio API | 1234 | native Windows service | Running / verified |
| Open WebUI | 3000 | 8080 | Running / existing |
| SearXNG | 8080 | 8080 | Running / existing |
| GitHub MCP | 8082 | 8082 | Running / existing |
| Twilio read-only | 8001 | 8001 | Running / existing |
| Integration gateway | 8788 | 8788 | Reserved / future |
| Browser automation service | 3001 | project-defined | Future |

## Fresh-install fallback

The repository's reference `compose.yaml` uses host port **8081** for SearXNG so that a clean CentralAIHub install does not collide with an existing service on 8080.

That fallback Compose file must not be used to replace the current running stack until the existing containers, mounts, and origins are fully documented.

## Rules

- Do not change a working service port merely to match a template.
- Inspect active listeners before starting containers.
- Preserve the existing Open WebUI data volume and SearXNG configuration.
- Prefer binding private infrastructure to localhost unless remote access is intentionally required.
- For remote access, prefer Tailscale/private networking rather than exposing local AI services directly to the public internet.
- Record future port changes here and in the relevant service documentation.
