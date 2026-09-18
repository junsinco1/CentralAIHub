$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

docker compose down
Write-Host "CentralAIHub containers stopped. Persistent volumes were kept." -ForegroundColor Green
