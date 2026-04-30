from fastapi import APIRouter
from app.services.csv_service import validate_csv_file

router = APIRouter()

@router.get("/validate-csv")
def validate_csv(file_path: str):
    return validate_csv_file(file_path)
