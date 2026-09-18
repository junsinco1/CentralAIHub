$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$examplePath = Join-Path $repoRoot ".env.example"
$envPath = Join-Path $repoRoot ".env"

if (Test-Path $envPath) {
    Write-Host ".env already exists. No changes made." -ForegroundColor Yellow
    exit 0
}

if (-not (Test-Path $examplePath)) {
    throw ".env.example was not found at $examplePath"
}

function New-RandomHex([int]$byteCount = 32) {
    $bytes = New-Object byte[] $byteCount
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try {
        $rng.GetBytes($bytes)
    } finally {
        $rng.Dispose()
    }
    return -join ($bytes | ForEach-Object { $_.ToString("x2") })
}

$content = Get-Content $examplePath -Raw
$webuiSecret = New-RandomHex 32
$searxSecret = New-RandomHex 32

$firstMarker = "WEBUI_SECRET_KEY=CHANGE_ME_WITH_RANDOM_64_HEX"
$secondMarker = "SEARXNG_SECRET=CHANGE_ME_WITH_RANDOM_64_HEX"

$content = $content.Replace($firstMarker, "WEBUI_SECRET_KEY=$webuiSecret")
$content = $content.Replace($secondMarker, "SEARXNG_SECRET=$searxSecret")

Set-Content -Path $envPath -Value $content -Encoding UTF8
Write-Host "Created local .env with random secrets:" -ForegroundColor Green
Write-Host $envPath
Write-Host ""
Write-Host "The .env file is ignored by Git. Do not commit it."
