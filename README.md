# 🌆 UrbIA - Plataforma Inteligente de Monitoreo Urbano (Fase 0 - PMV)

**UrbIA** es una plataforma modular, escalable y open-source para el monitoreo de variables urbanas en tiempo real, con enfoque en ciudades intermedias como Manizales. Este repositorio contiene el **Producto Mínimo Viable (PMV)** local desarrollado en la Fase 0 del proyecto.

## 📌 Objetivo del PMV

Simular sensores distribuidos (temperatura, ruido, humedad, etc.) que envían lecturas a un nodo Edge, las cuales se almacenan y visualizan en tiempo real, sin requerir conexión externa o nube.

## 🧱 Estructura de Carpetas

```

UrbIA/
├── sensores/          # Simuladores en Python, C++ y Java
│   ├── python/
│   ├── cpp/
│   └── java/          # Estructura base (implementación futura)
├── edge/              # Nodo Edge con FastAPI + SQLite
├── dashboard/         # Dashboard local con Streamlit
├── lecturas/          # Archivos CSV y base de datos local
├── logs/              # Registros de ejecución
├── venv/              # Entorno virtual Python
├── start\_urbia.sh     # Script de ejecución unificada
├── requirements.txt   # Dependencias Python
└── README.md          # Este archivo

````

## 🚀 Cómo ejecutar UrbIA localmente

1. Clona o ubícate en la raíz del proyecto
2. Asegúrate de tener `python3`, `g++`, `make` y `curl` instalados
3. Ejecuta el entorno local completo:

```bash
chmod +x start_urbia.sh
./start_urbia.sh
````

Este script:

* Activa el entorno virtual Python
* Inicia el servidor FastAPI en `http://localhost:8000`
* Lanza el simulador Python
* Compila y ejecuta el simulador C++
* Genera logs en `logs/`

> 🧼 Para detener todo: copia y pega el comando `kill` que se imprime al final.

---

## 📊 Visualización de datos

Abre en tu navegador:

```
http://localhost:8501
```

Esto mostrará el dashboard desarrollado en Streamlit. Podrás visualizar lecturas recientes desde SQLite (`lecturas_edge.db`) o CSV (`lecturas_cpp.csv`).

---

## 🛠️ Tecnologías empleadas

* **Python** (Simulación, API Edge, Dashboard)
* **C++** (Simulación de sensores vía HTTP)
* **FastAPI** (Microservicio Edge)
* **SQLite** (Persistencia local)
* **Streamlit** (Visualización en tiempo real)
* **Bash** (Automatización)

---

## 🧪 Estado actual (Fase 0)

✅ Múltiples sensores simulados

✅ Microservicios locales funcionales

✅ Almacenamiento e interfaz básica

✅ Logging centralizado

✅ Documentación y automatización de scripts

---

## 🔜 Próximos pasos

* Fase 1: Contenerización de servicios (Docker)
* Fase 2: Integración de brokers (MQTT o Redis)
* Fase 3: Visualización avanzada, despliegue real y monitoreo urbano

---

## 👥 Autores

* **Daniel C. Campos Julca** (Arquitectura e implementación)
* **Basado en la tesis** de **J. S. Giraldo**: *Arquitectura para el monitoreo y análisis de datos urbanos usando SDN y Fog*

---

## 📖 Licencia

Este proyecto es de código abierto y está licenciado bajo MIT.