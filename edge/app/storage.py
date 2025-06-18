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
