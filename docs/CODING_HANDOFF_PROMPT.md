# CentralAIHub Coding Handoff Prompt

Use this in CentralAIHub-20B when you want to move from diagnosis to coding:

```text
Prepare a CODING HANDOFF for this task.

Do not modify anything.

First use the relevant live provider tools and GitHub read-only context to identify:
- the exact repository that owns the code
- staging vs production boundaries
- current live state relevant to the request
- existing implementation
- existing tests
- validation steps

Before producing the handoff, apply this evidence gate:

1. Verify the exact repository owner/name/casing.
2. Inspect the repository tree.
3. Successfully retrieve every existing file you name.
4. Verify every endpoint, type, class, function, environment variable, library, test framework, build command, and CI platform assumption from source or authoritative project documentation.
5. Inspect existing tests before proposing new ones.
6. Decide whether the next blocker is code, validation, configuration, credentials/access, or deployment acceptance.

Do not use "or equivalent" for an unverified file.

If a proposed file does not exist, label it:
NEW FILE PROPOSED

Explain why an existing file cannot be extended instead.

Do not invent:
- files
- repositories
- APIs/endpoints
- tokens or environment variables
- libraries
- test frameworks
- CI workflows
- provider state
- missing features

Do not include implementation code or sample code unless Pedro explicitly asks for code.

Verify platform requirements:
- Xcode/xcodebuild/iOS Simulator require macOS.
- Never propose xcodebuild on a Linux runner.
- Do not claim CI exists unless workflow files were verified.

If evidence shows the next step is validation/configuration and not a code change, output:

NO CODING HANDOFF — NEXT STEP IS VALIDATION/CONFIGURATION

Then provide the exact validation/configuration procedure and stop.

Only when source evidence proves a code change is required, output one self-contained CODING HANDOFF for Qwen3-Coder 30B.

The packet must explicitly state:
- exact selected repository
- exact verified existing files involved
- evidence for why the change is needed
- staging/production boundary
- existing tests to run or extend
- edit only the selected repository
- read README.md and AI_CONTEXT.md first
- inspect git status before editing
- do not deploy production
- do not run production migrations
- do not modify unrelated repositories
- report files changed and tests run when finished
```
