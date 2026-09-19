import os
from typing import Any

import httpx
from fastapi import FastAPI, HTTPException, Query

API_BASE = "https://api.supabase.com"
TOKEN = os.getenv("SUPABASE_ACCESS_TOKEN", "").strip()

app = FastAPI(
    title="CentralAIHub Supabase Read Only",
    version="1.0.0",
    description="Read-only proxy for selected Supabase Management API endpoints.",
)

async def provider_get(path: str, params: dict[str, Any] | None = None) -> Any:
    if not TOKEN:
        raise HTTPException(status_code=503, detail="Supabase access token is not configured")

    headers = {
        "Authorization": f"Bearer {TOKEN}",
        "Accept": "application/json",
    }

    try:
        async with httpx.AsyncClient(timeout=20.0) as client:
            response = await client.get(f"{API_BASE}{path}", headers=headers, params=params)
    except httpx.HTTPError:
        raise HTTPException(status_code=502, detail="Supabase Management API is unreachable")

    if response.status_code >= 400:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Supabase Management API returned HTTP {response.status_code}",
        )

    try:
        return response.json()
    except ValueError:
        raise HTTPException(status_code=502, detail="Supabase Management API returned invalid JSON")


@app.get("/health", operation_id="supabase_health")
async def health() -> dict[str, Any]:
    return {"status": "ok", "configured": bool(TOKEN), "mode": "read-only"}


@app.get("/organizations", operation_id="supabase_list_organizations")
async def list_organizations() -> Any:
    return await provider_get("/v1/organizations")


@app.get("/projects", operation_id="supabase_list_projects")
async def list_projects() -> Any:
    return await provider_get("/v1/projects")


@app.get(
    "/organizations/{slug}/projects",
    operation_id="supabase_list_organization_projects",
)
async def list_organization_projects(
    slug: str,
    limit: int = Query(default=50, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
    search: str | None = None,
) -> Any:
    params: dict[str, Any] = {"limit": limit, "offset": offset}
    if search:
        params["search"] = search
    return await provider_get(f"/v1/organizations/{slug}/projects", params=params)
