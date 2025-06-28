# api.py

import requests
import time

# URL base
BASE_URL = "http://localhost:8080"

def autenticar_tenant():
    url = f"{BASE_URL}/api/auth/login"
    payload = {
        "username": "admin@urbia.local",
        "password": "sysadmin"
    }
    print("🔐 Autenticando con ThingsBoard...")
    try:
        response = requests.post(url, json=payload)
        response.raise_for_status()
        token = response.json()["token"]
        print("✅ Token recibido:", token[:20], "...")
        return token
    except Exception as e:
        print("❌ Error al autenticar:", e)
        return None

def obtener_dispositivos(token):
    url = f"{BASE_URL}/api/tenant/devices?pageSize=100&page=0"
    headers = {"X-Authorization": f"Bearer {token}"}
    print("📡 Solicitando lista de dispositivos...")
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        dispositivos = response.json().get("data", [])
        print(f"✅ {len(dispositivos)} dispositivos encontrados.")
        return dispositivos
    except Exception as e:
        print("❌ Error al obtener dispositivos:", e)
        return []

import pandas as pd

def obtener_telemetria_historica(device_id, token, keys, minutos=10):
    headers = {"X-Authorization": f"Bearer {token}"}
    ts_actual = int(time.time() * 1000)
    ts_inicio = ts_actual - minutos * 60 * 1000
    keys_str = ",".join(keys)

    url = f"{BASE_URL}/api/plugins/telemetry/DEVICE/{device_id}/values/timeseries"
    params = {
        "keys": keys_str,
        "startTs": ts_inicio,
        "endTs": ts_actual,
        "interval": 1000,
        "limit": 1000,
        "agg": "NONE"
    }

    print(f"📥 Solicitando telemetría de los últimos {minutos} minutos para: {keys_str}")
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()
        datos = response.json()

        if not datos:
            print("⚠️ Respuesta vacía desde ThingsBoard.")
            return pd.DataFrame()

        registros = []
        for sensor, lecturas in datos.items():
            for lectura in lecturas:
                ts = int(lectura["ts"])
                valor = float(lectura["value"])
                registros.append({"timestamp": pd.to_datetime(ts, unit='ms'), "sensor": sensor, "valor": valor})

        df = pd.DataFrame(registros)
        print(f"✅ Telemetría convertida a DataFrame con {len(df)} filas.")
        return df

    except Exception as e:
        print("❌ Error al obtener telemetría:", e)
        return pd.DataFrame()
