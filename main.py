from fastapi import FastAPI

import pandas as pd
import os
from pydantic import BaseModel

app = FastAPI(title="PyBridge API Server")

class FilePathRequest(BaseModel):
    file_path: str

@app.get("/")
def read_root():
    return {"message": "Welcome to PyBridge API Server", "status": "online"}

@app.post("/validate-csv")
def validate_csv(request: FilePathRequest):
    if not os.path.exists(request.file_path):
        return {"status": "error", "message": f"File not found: {request.file_path}"}
    
    if not request.file_path.endswith('.csv'):
        return {"status": "error", "message": "Only CSV files are supported"}

    try:
        df = pd.read_csv(request.file_path)
        # 간단한 검증: 비어있는지 확인 및 기본 정보 추출
        if df.empty:
            return {"status": "warning", "message": "The CSV file is empty", "file": request.file_path}
        
        return {
            "status": "success",
            "message": "CSV validation successful",
            "file": request.file_path,
            "data_summary": {
                "rows": len(df),
                "columns": list(df.columns),
                "null_counts": df.isnull().sum().to_dict()
            }
        }
    except Exception as e:
        return {"status": "error", "message": f"Error reading CSV: {str(e)}"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: str = None):
    return {"item_id": item_id, "query": q}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8088)
