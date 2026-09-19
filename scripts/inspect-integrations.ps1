$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "=== CentralAIHub integration interface probe ===" -ForegroundColor Cyan
Write-Host "This script does not print container environment variables." -ForegroundColor DarkGray

function Get-StatusCode {
    param(
        [string]$Url,
        [string]$Method = "GET",
        [string]$ContentType = "application/json",
        [string]$Body = $null
    )

    try {
        $params = @{
            Uri = $Url
            Method = $Method
            UseBasicParsing = $true
            TimeoutSec = 8
            ErrorAction = "Stop"
        }

        if ($Body -ne $null) {
            $params["Body"] = $Body
            $params["ContentType"] = $ContentType
        }

        $r = Invoke-WebRequest @params
        return [PSCustomObject]@{
            Url = $Url
            Method = $Method
            Status = [int]$r.StatusCode
            ContentType = $r.Headers["Content-Type"]
        }
    }
    catch {
        $status = $null
        $contentType = $null

        if ($_.Exception.Response) {
            try { $status = [int]$_.Exception.Response.StatusCode } catch {}
            try { $contentType = $_.Exception.Response.Headers["Content-Type"] } catch {}
        }

        return [PSCustomObject]@{
            Url = $Url
            Method = $Method
            Status = $status
            ContentType = $contentType
        }
    }
}

Write-Host ""
Write-Host "[1/4] Safe container metadata"

foreach ($name in "github-mcp", "twilio-readonly") {
    try {
        $raw = docker inspect $name | ConvertFrom-Json
        $c = $raw[0]

        [PSCustomObject]@{
            Name = $c.Name
            Image = $c.Config.Image
            State = $c.State.Status
            Restart = $c.HostConfig.RestartPolicy.Name
            Networks = ($c.NetworkSettings.Networks.PSObject.Properties.Name -join ",")
            PublishedPorts = (($c.NetworkSettings.Ports.PSObject.Properties | ForEach-Object {
                $containerPort = $_.Name
                $bindings = $_.Value
                if ($bindings) {
                    $bindings | ForEach-Object { "$($_.HostIp):$($_.HostPort)->$containerPort" }
                }
            }) -join "; ")
        } | Format-List
    }
    catch {
        Write-Warning ("Could not inspect {0}: {1}" -f $name, $_.Exception.Message)
    }
}

Write-Host ""
Write-Host "[2/4] GitHub MCP HTTP surface"

$githubResults = @()
$githubResults += Get-StatusCode "http://127.0.0.1:8082/" "GET"
$githubResults += Get-StatusCode "http://127.0.0.1:8082/.well-known/oauth-protected-resource" "GET"

# Streamable HTTP MCP endpoints commonly reject GET with 405.
# A 4xx response still proves the HTTP service is reachable.
$githubResults | Format-Table -AutoSize

Write-Host ""
Write-Host "[3/4] Twilio read-only HTTP surface"

$twilioPaths = @(
    "/",
    "/health",
    "/healthz",
    "/openapi.json"
)

$twilioResults = foreach ($path in $twilioPaths) {
    Get-StatusCode ("http://127.0.0.1:8001" + $path) "GET"
}

$twilioResults | Format-Table -AutoSize

Write-Host ""
Write-Host "[4/4] Optional OpenAPI title (safe)"

try {
    $openapi = Invoke-RestMethod -Uri "http://127.0.0.1:8001/openapi.json" -TimeoutSec 8
    if ($openapi.info) {
        Write-Host ("Twilio service title: " + $openapi.info.title) -ForegroundColor Green
        Write-Host ("Twilio service version: " + $openapi.info.version)
    }
    if ($openapi.paths) {
        Write-Host "Documented paths:"
        $openapi.paths.PSObject.Properties.Name | Sort-Object | ForEach-Object {
            Write-Host (" - " + $_)
        }
    }
}
catch {
    Write-Host "No readable OpenAPI document was exposed. That is not necessarily an error." -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "Probe complete."
