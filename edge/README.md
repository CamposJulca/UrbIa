# 🌐 Nodo Edge - UrbIA (Fase 0)

Este componente representa el nodo de borde (**Edge**) del sistema **UrbIA**, cuya función es recibir, validar y almacenar las lecturas de sensores simulados (Python, C++) de forma local.

## 📌 Objetivo

El nodo Edge opera como un microservicio HTTP RESTful construido con **FastAPI**, que escucha en el endpoint `/api/lectura/` y almacena las lecturas recibidas en una base de datos SQLite localizada.

---

## 📁 Estructura del módulo

```

edge/
├── main.py              # Punto de entrada del servidor FastAPI
└── app/
├── api.py           # Rutas (endpoints)
├── controller.py    # Lógica de negocio
├── models.py        # Esquemas Pydantic para validación
└── storage.py       # Manejador de base de datos SQLite

````

---

## ⚙️ Funcionamiento

- `main.py` inicializa la aplicación FastAPI e invoca `init_db()` al arrancar.
- `api.py` define la ruta `/api/lectura/` para recepción de datos.
- `controller.py` procesa cada lectura y la pasa a `storage.py`.
- `models.py` valida que cada dato recibido tenga la estructura correcta (`sensor_id`, `tipo`, `valor`, `unidad`, `timestamp`).
- `storage.py` se encarga de crear la base de datos `lecturas_edge.db` y de almacenar cada lectura recibida.

---

## 🗄️ Base de Datos Local

- Tipo: `SQLite`
- Ubicación: `lecturas/lecturas_edge.db`
- Tabla: `lectura`
```sql
CREATE TABLE IF NOT EXISTS lectura (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sensor_id TEXT,
    tipo TEXT,
    valor REAL,
    unidad TEXT,
    timestamp TEXT
);
````

---

## 🚀 Ejecución

Asegúrate de tener el entorno virtual activado (`venv`) y ejecuta el siguiente comando:

```bash
uvicorn edge.main:app --reload --port 8000
```

El servicio estará disponible en: [http://localhost:8000/docs](http://localhost:8000/docs)

---

## ✅ Estado Esperado

* Endpoint activo y funcionando localmente
* Capaz de recibir peticiones POST de sensores simulados
* Lecturas almacenadas en `lecturas_edge.db`
* Visible desde `/docs` de Swagger

---

## 📦 Dependencias

Instaladas previamente con `setup_estructura.sh`:

* `fastapi`
* `uvicorn`
* `sqlite3` (incluido con Python estándar)

---

