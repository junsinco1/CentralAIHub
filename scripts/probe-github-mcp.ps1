$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "=== CentralAIHub GitHub MCP connection probe ===" -ForegroundColor Cyan
Write-Host "No environment variables or credentials are printed." -ForegroundColor DarkGray

Write-Host ""
Write-Host "[1/3] Safe container command metadata"

try {
    $raw = docker inspect github-mcp | ConvertFrom-Json
    $c = $raw[0]

    [PSCustomObject]@{
        Name       = $c.Name
        Image      = $c.Config.Image
        Entrypoint = ($c.Config.Entrypoint -join " ")
        Cmd        = ($c.Config.Cmd -join " ")
        Networks   = ($c.NetworkSettings.Networks.PSObject.Properties.Name -join ",")
        Restart    = $c.HostConfig.RestartPolicy.Name
    } | Format-List
}
catch {
    Write-Warning ("Could not inspect github-mcp: " + $_.Exception.Message)
}

Write-Host ""
Write-Host "[2/3] 401 response headers only"

$urls = @(
    "http://127.0.0.1:8082/",
    "http://127.0.0.1:8082/mcp"
)

foreach ($url in $urls) {
    Write-Host ""
    Write-Host $url

    try {
        $req = [System.Net.HttpWebRequest]::Create($url)
        $req.Method = "POST"
        $req.ContentType = "application/json"
        $req.Accept = "application/json, text/event-stream"
        $req.Timeout = 8000

        $body = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"centralaihub-probe","version":"1.0"}}}'
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
        $req.ContentLength = $bytes.Length

        $stream = $req.GetRequestStream()
        try { $stream.Write($bytes,0,$bytes.Length) } finally { $stream.Dispose() }

        $resp = $req.GetResponse()
        try {
            Write-Host ("HTTP " + [int]$resp.StatusCode)
            foreach ($key in @("WWW-Authenticate","Content-Type")) {
                $value = $resp.Headers[$key]
                if ($value) { Write-Host ("{0}: {1}" -f $key,$value) }
            }
        } finally {
            $resp.Close()
        }
    }
    catch [System.Net.WebException] {
        if ($_.Exception.Response) {
            $resp = $_.Exception.Response
            try {
                Write-Host ("HTTP " + [int]$resp.StatusCode)
                foreach ($key in @("WWW-Authenticate","Content-Type")) {
                    $value = $resp.Headers[$key]
                    if ($value) { Write-Host ("{0}: {1}" -f $key,$value) }
                }
            } finally {
                $resp.Close()
            }
        } else {
            Write-Warning $_.Exception.Message
        }
    }
}

Write-Host ""
Write-Host "[3/3] Docker-internal reachability from Open WebUI"

$python = @'
import urllib.request
for url in [
    "http://github-mcp:8082/",
    "http://github-mcp:8082/mcp",
]:
    try:
        req=urllib.request.Request(url,method="POST",data=b'{}',headers={"Content-Type":"application/json","Accept":"application/json, text/event-stream"})
        with urllib.request.urlopen(req,timeout=8) as r:
            print(url, r.status)
    except Exception as e:
        code=getattr(e,"code",None)
        print(url, code if code is not None else type(e).__name__)
'@

$bytes=[System.Text.Encoding]::UTF8.GetBytes($python)
$encoded=[Convert]::ToBase64String($bytes)
$runner="import base64;exec(base64.b64decode('$encoded'))"
docker exec open-webui python -c $runner

Write-Host ""
Write-Host "Probe complete."
