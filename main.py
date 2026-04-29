from fastapi import FastAPI
from app.api.router import api_router

app = FastAPI(
    title="PyBridge API Server",
    description="Python 기반의 고성능 비동기 API 서버입니다.",
    version="1.0.0"
)

app.include_router(api_router)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8088, reload=True)
