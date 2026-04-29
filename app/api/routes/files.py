from fastapi import APIRouter
from app.schemas.file import FilePathRequest
from app.services.csv_service import validate_csv_file

router = APIRouter()

@router.post("/validate-csv")
def validate_csv(request: FilePathRequest):
    return validate_csv_file(request.file_path)
