from fastapi import APIRouter
from app.api.routes import system, files, items

api_router = APIRouter()
api_router.include_router(system.router, tags=["system"])
api_router.include_router(files.router, tags=["files"])
api_router.include_router(items.router, prefix="/items", tags=["items"])
