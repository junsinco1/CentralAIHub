param(
    [Parameter(Mandatory=$true)]
    [string]$RepoPath
)

$ErrorActionPreference = "Stop"

$resolved = Resolve-Path $RepoPath -ErrorAction Stop

Write-Host ""
Write-Host "CentralAIHub coding workspace check" -ForegroundColor Cyan
Write-Host ("Repository: " + $resolved.Path)

if (-not (Test-Path (Join-Path $resolved.Path ".git"))) {
    throw "The selected folder is not a Git repository."
}

Push-Location $resolved.Path
try {
    Write-Host ""
    Write-Host "Git status:" -ForegroundColor Cyan
    git status --short

    Write-Host ""
    Write-Host "Context files:" -ForegroundColor Cyan

    foreach ($file in @("README.md","AI_CONTEXT.md","Package.swift","package.json","pyproject.toml","requirements.txt")) {
        if (Test-Path $file) {
            Write-Host (" - " + $file)
        }
    }

    Write-Host ""
    Write-Host "Current branch:" -ForegroundColor Cyan
    git branch --show-current

    Write-Host ""
    Write-Host "No files were modified." -ForegroundColor Green
    Write-Host "Open this folder in VS Code and use Continue + Qwen3-Coder 30B for the explicit coding task."
}
finally {
    Pop-Location
}
