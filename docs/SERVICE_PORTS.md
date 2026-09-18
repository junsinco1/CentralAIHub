# Service Ports

These are **planned CentralAIHub defaults**, not proof that a service is currently running.

Validate the host before binding a port.

| Service | Host port | Internal/default | Status |
|---|---:|---:|---|
| LM Studio API | 1234 | 1234 | Existing known convention; validate before use |
| Open WebUI | 3000 | 8080 in container | Planned |
| SearXNG | 8081 | 8080 in container | Planned |
| Integration gateway | 8788 | 8788 | Reserved/planned |
| Browser automation service | 3001 | project-defined | Future |

## Rules

- Do not change an existing service port merely to match this document.
- Inspect active listeners before starting containers.
- Keep Open WebUI and SearXNG on different host ports.
- Prefer binding private infrastructure to localhost unless remote access is intentionally required.
- For remote access, prefer Tailscale/private networking rather than exposing local AI services directly to the public internet.
- Record any future port change here and in the relevant service README.
