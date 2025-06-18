#!/bin/bash

echo "🔧 Configurando simuladores de sensores..."

# Crear carpetas si no existen
mkdir -p sensores/python
mkdir -p sensores/cpp/src
mkdir -p sensores/java/src

# ---------- PYTHON ----------
echo "📦 Generando simulador base en Python..."

cat <<EOF > sensores/python/base_sensor.py
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
EOF

cat <<EOF > sensores/python/sensor_temperatura.py
# sensores/python/sensor_temperatura.py
from base_sensor import BaseSensor
import random

class SensorTemperatura(BaseSensor):
    def __init__(self):
        super().__init__("TEMP-001", "temperatura", "°C")

    def generar_valor(self):
        return round(random.uniform(18.0, 35.0), 2)
EOF

cat <<EOF > sensores/python/main.py
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
EOF

# ---------- C++ ----------
echo "🧊 Generando simulador base en C++..."

cat <<EOF > sensores/cpp/src/sensor.cpp
// sensores/cpp/src/sensor.cpp
#include <iostream>
#include <fstream>
#include <string>
#include <chrono>
#include <thread>
#include <ctime>
#include <random>
#include <curl/curl.h>
using namespace std;

string now_iso() {
    time_t now = time(0);
    tm *gmtm = gmtime(&now);
    char buf[80];
    strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%S", gmtm);
    return string(buf);
}

double generar_temperatura() {
    random_device rd;
    mt19937 gen(rd());
    uniform_real_distribution<> dis(18.0, 35.0);
    return dis(gen);
}

void enviar_lectura() {
    CURL *curl = curl_easy_init();
    if(curl) {
        string timestamp = now_iso();
        double valor = generar_temperatura();
        string json = "{\\"sensor_id\\":\\"TEMP-CPP\\",\\"tipo\\":\\"temperatura\\",\\"valor\\":" + to_string(valor) + ",\\"unidad\\":\\"°C\\",\\"timestamp\\":\\"" + timestamp + "\\"}";

        curl_easy_setopt(curl, CURLOPT_URL, "http://localhost:8000/api/lectura/");
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, json.c_str());

        struct curl_slist *headers = NULL;
        headers = curl_slist_append(headers, "Content-Type: application/json");
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

        CURLcode res = curl_easy_perform(curl);
        if(res != CURLE_OK)
            cerr << "❌ Error al enviar datos: " << curl_easy_strerror(res) << endl;
        else
            cout << "📈 Lectura: " << valor << " °C [" << timestamp << "]" << endl;

        curl_easy_cleanup(curl);
    }
}

int main() {
    cout << "🌡️ Simulador C++ + HTTP iniciado..." << endl;
    while (true) {
        enviar_lectura();
        this_thread::sleep_for(chrono::seconds(5));
    }
    return 0;
}
EOF

cat <<EOF > sensores/cpp/Makefile
# sensores/cpp/Makefile
all:
\tg++ -std=c++17 -Wall src/sensor.cpp -o sensor_simulator -lcurl

run: all
\t./sensor_simulator

clean:
\trm -f sensor_simulator
EOF

# ---------- JAVA (placeholder) ----------
echo "☕ Estructura Java preparada para futura implementación."

cat <<EOF > sensores/java/src/SensorBase.java
// sensores/java/src/SensorBase.java
public abstract class SensorBase {
    protected String sensorId;
    protected String tipo;
    protected String unidad;

    public SensorBase(String sensorId, String tipo, String unidad) {
        this.sensorId = sensorId;
        this.tipo = tipo;
        this.unidad = unidad;
    }

    public abstract double generarValor();
}
EOF

echo "✅ Simuladores listos. Puedes ejecutar:"
echo "  ▶️ Python: source venv/bin/activate && python sensores/python/main.py"
echo "  ▶️ C++: cd sensores/cpp && make run"
