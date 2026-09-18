# Operating Rules

## 1. Identify before editing

Before any agent edits a project repository:

- read its README
- read `AI_CONTEXT.md` when present
- inspect its manifests/build files
- determine whether it is active, prototype, backend, module, public product, private product, or potentially legacy

Names alone are not sufficient.

## 2. GitHub is the shared source of truth

Use Git branches/commits to carry changes between machines and agents.

Avoid creating competing unsynchronized versions on Windows and Mac.

## 3. Local-first coding

Default coding path:

```text
VS Code -> Continue -> LM Studio -> Qwen -> edit/test -> Git
```

Use cloud review as a second pass when beneficial.

## 4. Protect production

CentralAIHub setup is not authorization to:

- deploy an application
- alter live Render services
- change Supabase production policies or migrations
- change Twilio phone routing
- modify DNS
- submit App Store builds
- rotate production credentials
- send client outreach

Those require project-specific intent.

## 5. Secrets

Secrets belong in local environment variables, OS credential stores, GitHub secrets when appropriate, or the relevant provider's secret manager.

Never put them in:
- Git
- `AI_CONTEXT.md`
- README files
- screenshots
- prompt examples
- test fixtures

## 6. Integration privilege

Start with read-only access where possible.

Add write capability only when the workflow actually requires it.

## 7. Testing

Prefer:
- local services
- synthetic data
- disposable test accounts
- staging

Do not use live client, patient, or sensitive financial data for infrastructure testing.

## 8. Agent handoff

A useful project `AI_CONTEXT.md` should state:

- what the project is
- current architecture
- current task/status
- important decisions
- external services
- commands/tests
- safety boundaries
- next steps

Agents should update project context when a meaningful architectural or operational decision changes.
