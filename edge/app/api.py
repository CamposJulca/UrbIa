from fastapi import APIRouter
from app.models import Lectura
from app.controller import procesar_lectura

router = APIRouter()

@router.post("/lectura/", summary="Recibir lectura de sensor")
async def post_lectura(lectura: Lectura):
    return procesar_lectura(lectura)
