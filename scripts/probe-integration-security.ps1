$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "=== CentralAIHub integration security probe ===" -ForegroundColor Cyan
Write-Host "No credentials or environment variables are printed." -ForegroundColor DarkGray

function Get-CurlStatus([string]$Url, [string]$Method = "GET", [string]$Body = $null, [string[]]$Headers = @()) {
    $args = @("-sS", "-o", "NUL", "-w", "%{http_code}", "-X", $Method)

    foreach ($h in $Headers) {
        $args += @("-H", $h)
    }

    if ($Body -ne $null) {
        $args += @("--data-binary", $Body)
    }

    $args += $Url

    try {
        $status = & curl.exe @args 2>$null
        if ($LASTEXITCODE -ne 0) {
            return "curl-error"
        }
        return $status
    } catch {
        return "curl-error"
    }
}

Write-Host ""
Write-Host "[1/4] GitHub MCP GET status"

foreach ($url in @(
    "http://127.0.0.1:8082/",
    "http://127.0.0.1:8082/mcp",
    "http://127.0.0.1:8082/.well-known/oauth-protected-resource"
)) {
    $status = Get-CurlStatus $url "GET"
    Write-Host ("{0} -> HTTP {1}" -f $url, $status)
}

Write-Host ""
Write-Host "[2/4] GitHub MCP safe initialize POST"

$initBody = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"centralaihub-probe","version":"1.0"}}}'
$headers = @(
    "Content-Type: application/json",
    "Accept: application/json, text/event-stream"
)

foreach ($url in @(
    "http://127.0.0.1:8082/",
    "http://127.0.0.1:8082/mcp"
)) {
    $status = Get-CurlStatus $url "POST" $initBody $headers
    Write-Host ("POST {0} -> HTTP {1}" -f $url, $status)
}

Write-Host ""
Write-Host "[3/4] Twilio read-only unauthenticated status"

foreach ($path in @(
    "/phone-numbers",
    "/calls",
    "/messages"
)) {
    $url = "http://127.0.0.1:8001" + $path
    $status = Get-CurlStatus $url "GET"
    Write-Host ("{0} -> HTTP {1}" -f $url, $status)
}

Write-Host ""
Write-Host "[4/4] Twilio OpenAPI security declaration"

try {
    $openapi = Invoke-RestMethod -Uri "http://127.0.0.1:8001/openapi.json" -TimeoutSec 8

    if ($openapi.components.securitySchemes) {
        Write-Host "Security schemes declared:" -ForegroundColor Green
        $openapi.components.securitySchemes.PSObject.Properties | ForEach-Object {
            $scheme = $_.Value
            Write-Host (" - {0}: type={1}, scheme={2}" -f $_.Name, $scheme.type, $scheme.scheme)
        }
    } else {
        Write-Warning "No OpenAPI securitySchemes were declared."
    }

    foreach ($p in @("/phone-numbers", "/calls", "/messages")) {
        $node = $openapi.paths.$p
        if ($node -and $node.get) {
            $secured = $false
            if ($node.get.security) { $secured = $true }
            elseif ($openapi.security) { $secured = $true }
            Write-Host ("{0} GET declares security: {1}" -f $p, $secured)
        }
    }
}
catch {
    Write-Warning ("Could not inspect Twilio OpenAPI security metadata: " + $_.Exception.Message)
}

Write-Host ""
Write-Host "Reminder: both integration containers are currently published on all host interfaces."
Write-Host "No network binding changes were made by this probe."
