$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

function Get-RunningContainer([string]$name) {
    try {
        return docker ps --filter "name=^/$name$" --format "{{.Names}}"
    } catch {
        return ""
    }
}

$existingOpenWebUI = Get-RunningContainer "open-webui"
$existingSearxng = Get-RunningContainer "searxng"

if ($existingOpenWebUI -or $existingSearxng) {
    Write-Host "Existing AI containers detected." -ForegroundColor Yellow
    if ($existingOpenWebUI) { Write-Host " - open-webui" }
    if ($existingSearxng) { Write-Host " - searxng" }
    Write-Host ""
    Write-Host "CentralAIHub will NOT start duplicate containers." -ForegroundColor Yellow
    Write-Host "Use the existing-stack adoption workflow in docs\EXISTING_STACK.md."
    exit 0
}

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
