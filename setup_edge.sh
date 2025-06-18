#!/bin/bash

echo "🔧 Configurando Nodo Edge (FastAPI)..."

# Crear estructura de carpetas
mkdir -p edge/app
touch edge/__init__.py edge/app/__init__.py

# Crear archivo main.py
cat > edge/main.py << 'EOF'
from fastapi import FastAPI
from app.api import router
from app.storage import init_db

app = FastAPI(
    title="Nodo Edge UrbIA",
    description="API de recepción de lecturas de sensores en el nodo de borde (Edge)",
    version="1.0.0"
)

@app.on_event("startup")
def startup():
    init_db()

app.include_router(router, prefix="/api")
EOF

# Crear archivo api.py
cat > edge/app/api.py << 'EOF'
from fastapi import APIRouter
from app.models import Lectura
from app.controller import procesar_lectura

router = APIRouter()

@router.post("/lectura/", summary="Recibir lectura de sensor")
async def post_lectura(lectura: Lectura):
    return procesar_lectura(lectura)
EOF

# Crear archivo controller.py
cat > edge/app/controller.py << 'EOF'
from app.models import Lectura
from app.storage import guardar_lectura

def procesar_lectura(lectura: Lectura):
    print(f"📥 Lectura recibida: {lectura}")
    guardar_lectura(lectura)
    return {"mensaje": "Lectura almacenada correctamente"}
EOF

# Crear archivo models.py
cat > edge/app/models.py << 'EOF'
from pydantic import BaseModel
from datetime import datetime

class Lectura(BaseModel):
    sensor_id: str
    tipo: str
    valor: float
    unidad: str
    timestamp: datetime
EOF

# Crear archivo storage.py
cat > edge/app/storage.py << 'EOF'
import sqlite3
from pathlib import Path

DATABASE = "lecturas/lecturas_edge.db"
SCHEMA = """
CREATE TABLE IF NOT EXISTS lectura (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sensor_id TEXT,
    tipo TEXT,
    valor REAL,
    unidad TEXT,
    timestamp TEXT
);
"""

def init_db():
    Path("lecturas").mkdir(parents=True, exist_ok=True)
    Path(DATABASE).touch(exist_ok=True)
    with sqlite3.connect(DATABASE) as conn:
        conn.execute(SCHEMA)

def guardar_lectura(lectura):
    with sqlite3.connect(DATABASE) as conn:
        conn.execute(
            "INSERT INTO lectura (sensor_id, tipo, valor, unidad, timestamp) VALUES (?, ?, ?, ?, ?)",
            (lectura.sensor_id, lectura.tipo, lectura.valor, lectura.unidad, lectura.timestamp.isoformat())
        )
EOF

echo "✅ Nodo Edge listo. Puedes ejecutarlo con:"
echo "   ▶️ uvicorn edge.main:app --reload --port 8000"
