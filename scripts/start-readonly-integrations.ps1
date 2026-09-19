$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$envFile = Join-Path $repoRoot ".env.integrations"
$composeFile = Join-Path $repoRoot "compose.integrations.yaml"

if (-not (Test-Path $envFile)) {
    Write-Host "Missing .env.integrations." -ForegroundColor Yellow
    Write-Host "Create it from the example first:"
    Write-Host "Copy-Item .env.integrations.example .env.integrations"
    exit 1
}

try {
    docker network inspect local-ai *> $null
} catch {
    Write-Host "The existing Docker network 'local-ai' was not found." -ForegroundColor Red
    Write-Host "No changes were made."
    exit 1
}

foreach ($name in "supabase-readonly", "render-readonly") {
    $existing = docker ps -a --filter "name=^/$name$" --format "{{.Names}}"
    if ($existing) {
        Write-Host "$name already exists and will be managed by compose.integrations.yaml." -ForegroundColor DarkGray
    }
}

Write-Host "Building and starting only CentralAIHub-owned read-only integrations..." -ForegroundColor Cyan
docker compose -f $composeFile up -d --build

Write-Host ""
docker compose -f $composeFile ps

Write-Host ""
Write-Host "Health checks:" -ForegroundColor Cyan

try {
    $supabase = Invoke-RestMethod -Uri "http://127.0.0.1:8002/health" -TimeoutSec 8
    Write-Host ("Supabase adapter: status={0}, configured={1}" -f $supabase.status, $supabase.configured)
} catch {
    Write-Warning ("Supabase adapter health failed: " + $_.Exception.Message)
}

try {
    $render = Invoke-RestMethod -Uri "http://127.0.0.1:8003/health" -TimeoutSec 8
    Write-Host ("Render adapter: status={0}, configured={1}" -f $render.status, $render.configured)
} catch {
    Write-Warning ("Render adapter health failed: " + $_.Exception.Message)
}

Write-Host ""
Write-Host "This script does not modify github-mcp, twilio-readonly, open-webui, or searxng."
