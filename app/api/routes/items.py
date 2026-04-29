from fastapi import APIRouter
from typing import Optional

router = APIRouter()

@router.get("/{item_id}")
def read_item(item_id: int, q: Optional[str] = None):
    return {"item_id": item_id, "query": q}
