from app.models import Lectura
from app.storage import guardar_lectura

def procesar_lectura(lectura: Lectura):
    print(f"📥 Lectura recibida: {lectura}")
    guardar_lectura(lectura)
    return {"mensaje": "Lectura almacenada correctamente"}
