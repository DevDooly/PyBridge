import os
from dotenv import load_dotenv
from fastapi import FastAPI
from app.api.router import api_router

load_dotenv()

app = FastAPI(
    title="PyBridge API Server",
    description="Python 기반의 고성능 비동기 API 서버입니다.",
    version="1.0.0"
)

app.include_router(api_router)

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 8088))
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=True)
