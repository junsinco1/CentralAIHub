$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "=== CentralAIHub diagnostics ===" -ForegroundColor Cyan

Write-Host ""
Write-Host "[1/4] Docker"
try {
    docker --version
    docker compose version
} catch {
    Write-Warning "Docker CLI was not available in this shell."
}

Write-Host ""
Write-Host "[2/4] LM Studio API on 127.0.0.1:1234"
try {
    $models = Invoke-RestMethod -Uri "http://127.0.0.1:1234/v1/models" -TimeoutSec 5
    Write-Host "LM Studio API reachable." -ForegroundColor Green
    if ($models.data) {
        Write-Host "Models reported:"
        $models.data | ForEach-Object { Write-Host (" - " + $_.id) }
    }
} catch {
    Write-Warning "LM Studio OpenAI-compatible API is not reachable on port 1234."
    Write-Host $_.Exception.Message
}

Write-Host ""
Write-Host "[3/4] Planned host ports"
foreach ($port in 1234, 3000, 8081) {
    try {
        $listeners = Get-NetTCPConnection -State Listen -LocalPort $port -ErrorAction Stop
        if ($listeners) {
            Write-Host ("Port {0}: in use/listening" -f $port)
            $listeners | Select-Object LocalAddress, LocalPort, OwningProcess | Format-Table
        }
    } catch {
        Write-Host ("Port {0}: no listener detected" -f $port)
    }
}

Write-Host ""
Write-Host "[4/4] Existing CentralAIHub containers"
try {
    docker compose ps
} catch {
    Write-Warning "Could not query Docker Compose services."
}

Write-Host ""
Write-Host "Diagnostics complete."
