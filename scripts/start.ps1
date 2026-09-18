$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

if (-not (Test-Path ".env")) {
    Write-Host "No .env file found. Creating one from .env.example..." -ForegroundColor Yellow
    & (Join-Path $PSScriptRoot "bootstrap-env.ps1")
}

Write-Host "Starting CentralAIHub Phase 1 services..." -ForegroundColor Cyan
docker compose pull
docker compose up -d

Write-Host ""
docker compose ps

Write-Host ""
Write-Host "Open WebUI: http://127.0.0.1:3000" -ForegroundColor Green
Write-Host "SearXNG:     http://127.0.0.1:8081" -ForegroundColor Green
