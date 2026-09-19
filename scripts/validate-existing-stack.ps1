$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "=== CentralAIHub existing-stack validation ===" -ForegroundColor Cyan

function Test-Http([string]$name, [string]$url) {
    try {
        $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 8
        Write-Host ("{0}: HTTP {1}" -f $name, $r.StatusCode) -ForegroundColor Green
        return $true
    } catch {
        Write-Warning ("{0}: FAILED - {1}" -f $name, $_.Exception.Message)
        return $false
    }
}

function Invoke-ContainerPython([string]$container, [string]$code) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($code)
    $encoded = [Convert]::ToBase64String($bytes)
    $runner = "import base64;exec(base64.b64decode('$encoded'))"
    docker exec $container python -c $runner
    return $LASTEXITCODE
}

Write-Host ""
Write-Host "[1/5] Host endpoints"

$openWebUIOk = Test-Http "Open WebUI" "http://127.0.0.1:3000"
$searxOk = Test-Http "SearXNG" "http://127.0.0.1:8080"

try {
    $models = Invoke-RestMethod -Uri "http://127.0.0.1:1234/v1/models" -TimeoutSec 8
    Write-Host "LM Studio: reachable" -ForegroundColor Green
    if ($models.data) {
        $models.data | ForEach-Object { Write-Host (" - " + $_.id) }
    }
} catch {
    Write-Warning ("LM Studio: FAILED - " + $_.Exception.Message)
}

Write-Host ""
Write-Host "[2/5] Open WebUI container -> LM Studio"

$lmPython = @'
import json, urllib.request
u = "http://host.docker.internal:1234/v1/models"
with urllib.request.urlopen(u, timeout=8) as r:
    data = json.load(r)
    print("HTTP", r.status)
    for m in data.get("data", []):
        print("-", m.get("id"))
'@

try {
    $exitCode = Invoke-ContainerPython "open-webui" $lmPython
    if ($exitCode -eq 0) {
        Write-Host "Open WebUI container can reach LM Studio." -ForegroundColor Green
    } else {
        Write-Warning "Open WebUI container could not reach LM Studio."
    }
} catch {
    Write-Warning ("Open WebUI -> LM Studio test failed: " + $_.Exception.Message)
}

Write-Host ""
Write-Host "[3/5] Open WebUI container -> SearXNG JSON search"

$searchPython = @'
import json, urllib.parse, urllib.request
q = urllib.parse.quote("OpenAI")
u = "http://searxng:8080/search?q=" + q + "&format=json"
with urllib.request.urlopen(u, timeout=15) as r:
    data = json.load(r)
    print("HTTP", r.status)
    print("results", len(data.get("results", [])))
'@

try {
    $exitCode = Invoke-ContainerPython "open-webui" $searchPython
    if ($exitCode -eq 0) {
        Write-Host "Open WebUI container can reach SearXNG JSON search." -ForegroundColor Green
    } else {
        Write-Warning "Open WebUI container could not complete a SearXNG JSON search."
    }
} catch {
    Write-Warning ("Open WebUI -> SearXNG test failed: " + $_.Exception.Message)
}

Write-Host ""
Write-Host "[4/5] Existing integration containers"

foreach ($name in "github-mcp", "twilio-readonly") {
    $status = docker inspect $name --format "{{.State.Status}}" 2>$null
    if ($status -eq "running") {
        Write-Host ("{0}: running" -f $name) -ForegroundColor Green
    } else {
        Write-Warning ("{0}: status={1}" -f $name, $status)
    }
}

Write-Host ""
Write-Host "[5/5] Shared Docker network"

docker network inspect local-ai --format "{{range .Containers}}{{.Name}} {{end}}"

Write-Host ""
Write-Host "Validation complete."
