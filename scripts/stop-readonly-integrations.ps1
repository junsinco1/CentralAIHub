$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

docker compose -f .\compose.integrations.yaml down

Write-Host "Stopped only CentralAIHub-owned Supabase/Render read-only adapters." -ForegroundColor Green
Write-Host "Existing github-mcp, twilio-readonly, open-webui, and searxng containers were not targeted."
