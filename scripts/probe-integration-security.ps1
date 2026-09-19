$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "=== CentralAIHub integration security probe v3 ===" -ForegroundColor Cyan
Write-Host "No credentials or response bodies are printed." -ForegroundColor DarkGray

function Get-StatusOnly {
    param(
        [Parameter(Mandatory=$true)][string]$Uri,
        [string]$Method = "GET",
        [string]$Body = $null,
        [hashtable]$Headers = @{}
    )

    try {
        $req = [System.Net.HttpWebRequest]::Create($Uri)
        $req.Method = $Method
        $req.Timeout = 8000
        $req.AllowAutoRedirect = $false

        foreach ($key in $Headers.Keys) {
            switch ($key.ToLowerInvariant()) {
                "accept" { $req.Accept = $Headers[$key] }
                "content-type" { $req.ContentType = $Headers[$key] }
                default { $req.Headers[$key] = $Headers[$key] }
            }
        }

        if ($Body -ne $null) {
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
            $req.ContentLength = $bytes.Length
            $stream = $req.GetRequestStream()
            try {
                $stream.Write($bytes, 0, $bytes.Length)
            } finally {
                $stream.Dispose()
            }
        }

        $resp = $req.GetResponse()
        try {
            return [int]$resp.StatusCode
        } finally {
            $resp.Close()
        }
    }
    catch [System.Net.WebException] {
        if ($_.Exception.Response) {
            try {
                return [int]$_.Exception.Response.StatusCode
            } finally {
                $_.Exception.Response.Close()
            }
        }
        return "network-error"
    }
    catch {
        return "exception"
    }
}

Write-Host ""
Write-Host "[1/4] GitHub MCP GET status"

foreach ($uri in @(
    "http://127.0.0.1:8082/",
    "http://127.0.0.1:8082/mcp",
    "http://127.0.0.1:8082/.well-known/oauth-protected-resource"
)) {
    $status = Get-StatusOnly -Uri $uri -Method "GET"
    Write-Host ("{0} -> HTTP {1}" -f $uri, $status)
}

Write-Host ""
Write-Host "[2/4] GitHub MCP safe initialize POST"

$initBody = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"centralaihub-probe","version":"1.0"}}}'
$postHeaders = @{
    "Accept" = "application/json, text/event-stream"
    "Content-Type" = "application/json"
}

foreach ($uri in @(
    "http://127.0.0.1:8082/",
    "http://127.0.0.1:8082/mcp"
)) {
    $status = Get-StatusOnly -Uri $uri -Method "POST" -Body $initBody -Headers $postHeaders
    Write-Host ("POST {0} -> HTTP {1}" -f $uri, $status)
}

Write-Host ""
Write-Host "[3/4] Twilio read-only unauthenticated status"

foreach ($path in @(
    "/phone-numbers",
    "/calls",
    "/messages"
)) {
    $uri = "http://127.0.0.1:8001" + $path
    $status = Get-StatusOnly -Uri $uri -Method "GET"
    Write-Host ("{0} -> HTTP {1}" -f $uri, $status)
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
Write-Host "Probe complete."
