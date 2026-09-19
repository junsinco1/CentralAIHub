# CentralAIHub Coding Handoff Prompt

Use this in CentralAIHub-20B when you want to move from diagnosis to coding:

```text
Prepare a CODING HANDOFF for this task.

Do not modify anything.

First use the relevant live provider tools and GitHub read-only context to identify:
- the exact repository that owns the code
- staging vs production boundaries
- relevant files/components
- current live state that matters to the bug/feature
- validation steps

Then output one self-contained handoff packet for Qwen3-Coder 30B in Continue.

The packet must explicitly say:
- edit only the selected repository
- read README.md and AI_CONTEXT.md first
- inspect git status before editing
- do not deploy production
- do not run production migrations
- do not modify unrelated repositories
- report files changed and tests run when finished
```
