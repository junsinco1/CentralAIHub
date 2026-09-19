$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "=== CentralAIHub read-only provider validation ===" -ForegroundColor Cyan

$checks = @(
    @{Name="Supabase health"; Url="http://127.0.0.1:8002/health"},
    @{Name="Supabase organizations"; Url="http://127.0.0.1:8002/organizations"},
    @{Name="Supabase projects"; Url="http://127.0.0.1:8002/projects"},
    @{Name="Render health"; Url="http://127.0.0.1:8003/health"},
    @{Name="Render workspaces"; Url="http://127.0.0.1:8003/workspaces"},
    @{Name="Render services"; Url="http://127.0.0.1:8003/services"}
)

foreach ($check in $checks) {
    try {
        $r = Invoke-WebRequest -Uri $check.Url -UseBasicParsing -TimeoutSec 15
        Write-Host ("{0}: HTTP {1}" -f $check.Name, $r.StatusCode) -ForegroundColor Green
    } catch {
        $code = $null
        if ($_.Exception.Response) {
            try { $code = [int]$_.Exception.Response.StatusCode } catch {}
        }
        Write-Warning ("{0}: failed{1}" -f $check.Name, $(if($code){" HTTP $code"}else{""}))
    }
}

Write-Host ""
Write-Host "Open WebUI container -> provider adapters"

$python = @'
import urllib.request
for name,url in [
    ("supabase","http://supabase-readonly:8002/health"),
    ("render","http://render-readonly:8003/health"),
]:
    with urllib.request.urlopen(url,timeout=8) as r:
        print(name, r.status)
'@

$bytes=[System.Text.Encoding]::UTF8.GetBytes($python)
$encoded=[Convert]::ToBase64String($bytes)
$runner="import base64;exec(base64.b64decode('$encoded'))"
docker exec open-webui python -c $runner
