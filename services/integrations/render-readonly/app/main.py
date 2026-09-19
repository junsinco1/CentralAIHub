import os
from typing import Any

import httpx
from fastapi import FastAPI, HTTPException, Query

API_BASE = "https://api.render.com"
TOKEN = os.getenv("RENDER_API_KEY", "").strip()

app = FastAPI(
    title="CentralAIHub Render Read Only",
    version="1.0.0",
    description="Read-only proxy for selected Render API endpoints.",
)

async def provider_get(path: str, params: dict[str, Any] | None = None) -> Any:
    if not TOKEN:
        raise HTTPException(status_code=503, detail="Render API key is not configured")

    headers = {
        "Authorization": f"Bearer {TOKEN}",
        "Accept": "application/json",
    }

    try:
        async with httpx.AsyncClient(timeout=20.0) as client:
            response = await client.get(f"{API_BASE}{path}", headers=headers, params=params)
    except httpx.HTTPError:
        raise HTTPException(status_code=502, detail="Render API is unreachable")

    if response.status_code >= 400:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Render API returned HTTP {response.status_code}",
        )

    try:
        return response.json()
    except ValueError:
        raise HTTPException(status_code=502, detail="Render API returned invalid JSON")


@app.get("/health", operation_id="render_health")
async def health() -> dict[str, Any]:
    return {"status": "ok", "configured": bool(TOKEN), "mode": "read-only"}


@app.get("/workspaces", operation_id="render_list_workspaces")
async def list_workspaces(
    limit: int = Query(default=20, ge=1, le=100),
    cursor: str | None = None,
) -> Any:
    params: dict[str, Any] = {"limit": limit}
    if cursor:
        params["cursor"] = cursor
    return await provider_get("/v1/owners", params=params)


@app.get("/services", operation_id="render_list_services")
async def list_services(
    limit: int = Query(default=20, ge=1, le=100),
    cursor: str | None = None,
) -> Any:
    params: dict[str, Any] = {"limit": limit}
    if cursor:
        params["cursor"] = cursor
    return await provider_get("/v1/services", params=params)


@app.get("/projects", operation_id="render_list_projects")
async def list_projects(
    limit: int = Query(default=20, ge=1, le=100),
    cursor: str | None = None,
) -> Any:
    params: dict[str, Any] = {"limit": limit}
    if cursor:
        params["cursor"] = cursor
    return await provider_get("/v1/projects", params=params)


@app.get(
    "/services/{service_id}/deploys",
    operation_id="render_list_service_deploys",
)
async def list_service_deploys(
    service_id: str,
    limit: int = Query(default=20, ge=1, le=100),
    cursor: str | None = None,
) -> Any:
    params: dict[str, Any] = {"limit": limit}
    if cursor:
        params["cursor"] = cursor
    return await provider_get(f"/v1/services/{service_id}/deploys", params=params)
