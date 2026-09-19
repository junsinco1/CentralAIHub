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

Write-Host "Building and starting only CentralAIHub-owned read-only integrations..." -ForegroundColor Cyan
docker compose -f $composeFile up -d --build

Write-Host ""
docker compose -f $composeFile ps

function Wait-Health([string]$name, [string]$url) {
    for ($i = 1; $i -le 10; $i++) {
        try {
            $r = Invoke-RestMethod -Uri $url -TimeoutSec 5
            Write-Host ("{0}: status={1}, configured={2}" -f $name, $r.status, $r.configured) -ForegroundColor Green
            return $true
        } catch {
            if ($i -lt 10) {
                Start-Sleep -Seconds 1
            }
        }
    }

    Write-Warning ("{0} health check did not become ready." -f $name)
    return $false
}

Write-Host ""
Write-Host "Health checks:" -ForegroundColor Cyan
Wait-Health "Supabase adapter" "http://127.0.0.1:8002/health" | Out-Null
Wait-Health "Render adapter" "http://127.0.0.1:8003/health" | Out-Null

Write-Host ""
Write-Host "This script does not modify github-mcp, twilio-readonly, open-webui, searxng, or any application repository."
