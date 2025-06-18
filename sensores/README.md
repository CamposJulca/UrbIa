# 📡 Simuladores de Sensores - UrbIA

Este módulo contiene los simuladores de sensores para el **Producto Mínimo Viable (PMV)** de UrbIA. Cada simulador genera lecturas de un tipo específico de sensor y las envía al **Nodo Edge local** vía HTTP.

---

## 📁 Estructura de Carpetas

```

sensores/
├── python/       # Simulador en Python
│   ├── base\_sensor.py
│   ├── sensor\_temperatura.py
│   └── main.py
├── cpp/          # Simulador en C++
│   ├── Makefile
│   └── src/
│       └── sensor.cpp
└── java/         # (Planeado) Simulador en Java
└── src/
└── SensorBase.java

````

---

## 🔧 Simulador en Python

### 📍 Ubicación
`sensores/python/`

### 🧠 Descripción
- Implementa orientación a objetos: `BaseSensor` y su subclase `SensorTemperatura`.
- Genera un valor aleatorio de temperatura cada 5 segundos.
- Envia los datos como JSON a `http://localhost:8000/api/lectura/`.

### ▶️ Ejecución

```bash
source venv/bin/activate
python sensores/python/main.py
````

---

## 🔧 Simulador en C++

### 📍 Ubicación

`sensores/cpp/`

### 🧠 Descripción

* Usa `libcurl` para hacer peticiones HTTP POST.
* Genera lecturas simuladas de temperatura.
* Envia los datos como JSON al mismo endpoint del nodo Edge.

### ▶️ Ejecución

```bash
cd sensores/cpp
make run
```

> Para instalar libcurl:
>
> ```bash
> sudo apt install libcurl4-openssl-dev
> ```

---

## ☕ Simulador en Java (en preparación)

### 📍 Ubicación

`sensores/java/`

### 🧠 Descripción

* Estructura base orientada a objetos.
* Se implementará en Fase 1 del proyecto.
* Permitirá simular sensores más complejos o integrar dispositivos Android embebidos.

---

## 🔄 Flujo de Comunicación

Cada simulador se comunica con el **Nodo Edge** (servidor FastAPI) expuesto en `http://localhost:8000/api/lectura/`.

```text
[Sensor Python/C++/Java] ---> POST JSON ---> [FastAPI - edge/app/api.py]
```

---

## ✨ Recomendaciones

* Ejecuta los simuladores **después** de haber iniciado el servidor de Edge.
* Verifica la conexión y logs para confirmar que los datos se reciben correctamente.
* Puedes modificar los sensores o crear nuevos tipos heredando de la clase base.



