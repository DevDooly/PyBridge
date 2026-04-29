import os
import pandas as pd

def validate_csv_file(file_path: str) -> dict:
    if not os.path.exists(file_path):
        return {"status": "error", "message": f"File not found: {file_path}"}
    
    if not file_path.endswith('.csv'):
        return {"status": "error", "message": "Only CSV files are supported"}

    try:
        df = pd.read_csv(file_path)
        if df.empty:
            return {"status": "warning", "message": "The CSV file is empty", "file": file_path}
        
        return {
            "status": "success",
            "message": "CSV validation successful",
            "file": file_path,
            "data_summary": {
                "rows": len(df),
                "columns": list(df.columns),
                "null_counts": df.isnull().sum().to_dict()
            }
        }
    except Exception as e:
        return {"status": "error", "message": f"Error reading CSV: {str(e)}"}
