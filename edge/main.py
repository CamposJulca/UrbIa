# edge/main.py

import sys
import os
from fastapi import FastAPI

# 🔧 Asegura que FastAPI pueda importar app/api.py sin importar desde dónde se ejecute
sys.path.append(os.path.dirname(__file__))

from app.api import router
from app.storage import init_db  # 👈 Importa el inicializador de la BD

# 🔧 Inicializa base de datos local al arrancar el servidor
init_db()

app = FastAPI(
    title="Nodo Edge UrbIA",
    description="API de recepción de lecturas de sensores en el nodo de borde (Edge)",
    version="1.0.0"
)

# 🚀 Registra rutas
app.include_router(router, prefix="/api")
