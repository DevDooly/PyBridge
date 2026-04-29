from fastapi import APIRouter
import asyncio

router = APIRouter()

@router.get("/")
def read_root():
    return {"message": "Welcome to PyBridge API Server", "status": "online"}

@router.get("/delay")
async def delay_test():
    await asyncio.sleep(10)
    return {"status": "success", "message": "Responded after 10 seconds"}
