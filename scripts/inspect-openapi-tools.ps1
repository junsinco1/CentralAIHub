$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== CentralAIHub OpenAPI tool discovery ===" -ForegroundColor Cyan
Write-Host "This prints only paths and operationIds. No provider data or secrets." -ForegroundColor DarkGray

$python = @'
import json
import urllib.request

servers = [
    ("supabase_readonly", "http://supabase-readonly:8002/openapi.json"),
    ("render_readonly", "http://render-readonly:8003/openapi.json"),
    ("twilio_readonly", "http://twilio-readonly:8001/openapi.json"),
]

for server_id, url in servers:
    print()
    print("SERVER", server_id)
    print("SPEC", url)
    try:
        with urllib.request.urlopen(url, timeout=8) as r:
            spec = json.load(r)
            print("HTTP", r.status)
    except Exception as e:
        print("ERROR", type(e).__name__, str(e))
        continue

    title = (spec.get("info") or {}).get("title")
    version = (spec.get("info") or {}).get("version")
    print("TITLE", title)
    print("VERSION", version)

    count = 0
    for path, item in sorted((spec.get("paths") or {}).items()):
        if not isinstance(item, dict):
            continue
        for method, op in item.items():
            if method.lower() not in {"get","post","put","patch","delete","options","head","trace"}:
                continue
            if not isinstance(op, dict):
                continue
            operation_id = op.get("operationId")
            print(f"TOOL {method.upper():6} {path:40} operationId={operation_id}")
            count += 1

    print("DISCOVERED", count)
'@

$bytes = [System.Text.Encoding]::UTF8.GetBytes($python)
$encoded = [Convert]::ToBase64String($bytes)
$runner = "import base64;exec(base64.b64decode('$encoded'))"

docker exec open-webui python -c $runner
