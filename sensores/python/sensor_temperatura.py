# sensores/python/sensor_temperatura.py
from base_sensor import BaseSensor
import random

class SensorTemperatura(BaseSensor):
    def __init__(self):
        super().__init__("TEMP-001", "temperatura", "°C")

    def generar_valor(self):
        return round(random.uniform(18.0, 35.0), 2)
