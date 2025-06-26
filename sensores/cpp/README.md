# Simulador de Sensores en C++ para UrbIA

Este módulo simula múltiples sensores físicos en C++, generando datos en tiempo real y enviándolos a un servidor ThingsBoard mediante peticiones HTTP con libcurl. Forma parte del ecosistema UrbIA (Urban IoT Architecture), utilizado para el monitoreo urbano en tiempo real.

## 🧱 Arquitectura del Proyecto

- **Lenguaje:** C++17
- **Estructura modular:** Uso de clases base y herencia para representar sensores
- **Librerías externas:** [libcurl](https://curl.se/libcurl/) para envío HTTP, [nlohmann/json](https://github.com/nlohmann/json) para manipulación JSON
- **Plataforma de destino:** ThingsBoard (servidor local o en la nube)
- **Compilación:** mediante Makefile con estructura de carpetas `src/` y `include/`

## 📦 Estructura de Carpetas

```

cpp/
├── include/              # Archivos de encabezado (interfaces y clases)
│   ├── SensorBase.hpp
│   ├── SensorCO2.hpp
│   ├── SensorTemperatura.hpp
│   └── ... otros sensores
├── src/                  # Implementación de sensores y lógica de red
│   ├── main.cpp
│   ├── HttpClient.cpp
│   ├── SensorCO2.cpp
│   └── ... otros sensores
├── Makefile              # Archivo de compilación
└── README.md             # Este documento

````

## 📡 Sensores Simulados

Cada sensor hereda de `SensorBase` y simula valores realistas:

| Sensor         | Rango Simulado        | Unidad  |
|----------------|------------------------|---------|
| CO2            | 400 – 600 ppm           | ppm     |
| Temperatura    | 20.0 – 35.0             | °C      |
| Humedad        | 40.0 – 80.0             | %       |
| Presión        | 990.0 – 1025.0          | hPa     |
| Luz            | 0.0 – 1000.0            | Lux     |
| Ruido          | 30.0 – 120.0            | dB      |

## 🔄 Flujo de Ejecución

1. Se inicializa un vector de sensores (`std::shared_ptr<SensorBase>`)
2. En un loop infinito, cada 5 segundos:
   - Se simulan lecturas aleatorias.
   - Se construye un JSON con las lecturas.
   - Se envía el JSON por HTTP POST a ThingsBoard usando libcurl.
   - Se imprime en consola el resultado del envío.

## 🧪 Compilación y Ejecución

```bash
make clean && make run
````

Esto compila todos los archivos en `build/` y ejecuta el binario `sensor_simulator`.

## 🌐 Envío a ThingsBoard

El payload se envía al endpoint:

```
http://localhost:8080/api/v1/<TOKEN>/telemetry
```

El token debe ser proporcionado directamente en el código fuente (`main.cpp`). Este token debe corresponder a un dispositivo configurado en ThingsBoard.

## 🛠 Requisitos

* g++ con soporte para C++17
* libcurl (`sudo apt install libcurl4-openssl-dev`)
* ThingsBoard corriendo en `localhost:8080` o cambiar la URL en `HttpClient.cpp`

## 🔐 Consideraciones de Seguridad

Actualmente el token está embebido en el código. Para producción se recomienda:

* Usar variables de entorno o archivo `.env`
* Validar conectividad y manejo de errores más robusto en `HttpClient`

## ✨ Futuras Mejoras

* Incluir timestamps en cada lectura (`"ts"`).
* Guardar log local en CSV.
* Configurar vía argumentos el endpoint y token.
* Simular fallos o latencia de red.

---
