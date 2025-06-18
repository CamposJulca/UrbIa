# sensores/python/main.py
import time
import requests
from sensor_temperatura import SensorTemperatura

sensor = SensorTemperatura()
print("🌡️ Simulador de sensores iniciado...")

while True:
    lectura = sensor.obtener_lectura()
    print(f"📈 Lectura generada: {lectura}")
    try:
        response = requests.post("http://localhost:8000/api/lectura/", json=lectura)
        if response.status_code == 200:
            print("✅ Enviado al backend correctamente")
        else:
            print(f"⚠️ Error al enviar: {response.status_code}")
    except Exception as e:
        print(f"❌ Error de conexión: {e}")
    time.sleep(5)
