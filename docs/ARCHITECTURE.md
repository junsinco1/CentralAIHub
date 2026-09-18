# CentralAIHub Architecture

_Last inventory baseline: 2026-09-18_

## Design goal

Create one stable local-AI platform on the Windows desktop without merging or rewriting the existing application repositories.

## High-level topology

```text
                    +----------------------+
                    |      GitHub          |
                    | project source truth |
                    +----------+-----------+
                               |
                               |
                    +----------v-----------+
                    |   Windows Desktop    |
                    |   RTX 5070 Ti        |
                    +----------+-----------+
                               |
              +----------------+----------------+
              |                |                |
      +-------v------+  +------v------+  +------v-------+
      |  LM Studio   |  | Open WebUI  |  | VS Code     |
      | local models |  | AI console  |  | + Continue  |
      +-------+------+  +------+------+  +------+-------+
              |                |               |
              |                |               |
      +-------v------+  +------v------+        |
      | Qwen3-Coder  |  | SearXNG     |        |
      | Qwen3.5 9B   |  | web search  |        |
      +--------------+  +------+------+       |
                               |               |
                         +-----v---------------v----+
                         | Controlled integrations |
                         | GitHub / Supabase /      |
                         | Render / Twilio / later  |
                         | browser automation       |
                         +--------------------------+

MacBook Air
    |
    +-- remote client via Tailscale / SSH / browser
    +-- backup local AI only when remote access is unavailable
```

## Separation of responsibilities

### LM Studio
Hosts local models and exposes an OpenAI-compatible API.

### VS Code + Continue
Primary coding interface for local repository work.

### Open WebUI
General conversational interface and future tool-facing hub.

### SearXNG
Self-hosted search provider for Open WebUI and future local agents.

### CentralAIHub integrations
Small, controlled adapters that expose only the capabilities intentionally needed.

Initial preference:
- read-only where practical
- least privilege
- separate credentials per external service
- explicit production boundaries

### GitHub
Source of truth for application code.

CentralAIHub must never silently treat a local uncommitted folder as authoritative over the corresponding GitHub repository.

## Model routing

### Qwen3-Coder 30B A3B
Preferred for:
- repository coding
- refactoring
- debugging
- multi-file implementation
- architecture-sensitive code changes

### Qwen3.5 9B
Preferred for:
- lightweight questions
- summaries
- simple scripts
- tool routing
- lower-latency general work

### Codex
Preferred as a cloud second-pass reviewer when additional reasoning, QA, cleanup, or validation is desired.

## Integration rollout order

1. LM Studio validation
2. Open WebUI
3. SearXNG
4. GitHub read-only integration for the local hub
5. Supabase
6. Render
7. Twilio read-only/status access
8. browser automation / Playwright

Each stage must work before the next stage becomes a dependency.

## Data boundary

CentralAIHub should store configuration and metadata, not sensitive application datasets.

Do not centralize:
- insurance client records
- patient data
- CRM production records
- private call reports
- financial user records
- application signing secrets

Those remain within their approved systems.
