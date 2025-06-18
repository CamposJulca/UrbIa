from pydantic import BaseModel
from datetime import datetime

class Lectura(BaseModel):
    sensor_id: str
    tipo: str
    valor: float
    unidad: str
    timestamp: datetime
