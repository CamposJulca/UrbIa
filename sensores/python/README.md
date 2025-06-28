# 📡 Módulo Python de Sensores - Proyecto UrbIA

Este módulo permite visualizar en tiempo real los datos de sensores conectados a ThingsBoard mediante un dashboard interactivo construido con Streamlit. Se conecta a ThingsBoard usando autenticación JWT para acceder a la telemetría histórica de cada sensor registrado.

## 📁 Estructura de archivos

```

sensores/python/
│
├── api.py              # Funciones de autenticación, consulta de dispositivos y telemetría
├── config.py           # Parámetros de conexión a ThingsBoard (host, token, credenciales)
├── dashboard.py        # Interfaz de visualización construida con Streamlit + Altair
├── main.py             # Script de arranque para ejecutar el dashboard
├── README.md           # Este archivo
└── **init**.py         # Archivo base para marcar como módulo de Python

````

## ⚙️ Requisitos

- Python 3.10+
- ThingsBoard Community Edition corriendo en `http://localhost:8080`
- Paquetes instalados (usando virtualenv preferiblemente):

```bash
pip install -r requirements.txt
````

> Si no tienes un `requirements.txt`, puedes crearlo con:
>
> ```bash
> pip freeze > requirements.txt
> ```

## 🔐 Configuración

Edita el archivo `config.py` con tus valores reales:

```python
THINGSBOARD_HOST = "http://localhost:8080"
DEVICE_TOKEN = "TOKEN_DE_DISPOSITIVO"  # Si usas envío directo (no necesario aquí)
TENANT_USER = "admin@urbia.local"
TENANT_PASSWORD = "sysadmin"
```

## 🚀 Ejecución

Para lanzar el dashboard:

```bash
cd sensores/python
python main.py
```

Esto abrirá automáticamente una instancia de Streamlit en el navegador con:

* Autenticación JWT al servidor ThingsBoard
* Consulta de sensores registrados por el Tenant
* Visualización en tiempo real de variables como temperatura, humedad, CO2, presión, luz, ruido
* KPI actuales, gráficas dinámicas y exportación CSV

## 📊 Funcionalidades del dashboard

* ✅ Autenticación segura vía JWT
* ✅ Selección de sensor desde el frontend
* ✅ Consulta de telemetría histórica de los últimos N minutos
* ✅ KPIs actuales por variable medida
* ✅ Gráficas interactivas con Altair
* ✅ Estadísticas descriptivas por variable
* ✅ Exportación de datos en formato `.csv`

## 📌 Notas adicionales

* El módulo está pensado para operar en red local. Si se expone públicamente, asegúrate de asegurar el backend.
* Los datos deben estar disponibles en ThingsBoard con claves estándar como `temperatura`, `humedad`, etc. Puedes modificar esto según tu esquema de sensores.

---

