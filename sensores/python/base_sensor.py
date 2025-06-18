# sensores/python/base_sensor.py
import random
from datetime import datetime

class BaseSensor:
    def __init__(self, sensor_id, tipo, unidad):
        self.sensor_id = sensor_id
        self.tipo = tipo
        self.unidad = unidad

    def generar_valor(self):
        raise NotImplementedError("Este método debe ser implementado por subclases")

    def obtener_lectura(self):
        return {
            "sensor_id": self.sensor_id,
            "tipo": self.tipo,
            "valor": self.generar_valor(),
            "unidad": self.unidad,
            "timestamp": datetime.utcnow().isoformat()
        }
