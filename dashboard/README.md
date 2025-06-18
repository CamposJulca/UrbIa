# 📊 Dashboard UrbIA (Local)

Este dashboard básico permite visualizar las lecturas generadas por los sensores simulados de UrbIA durante la Fase 0.

## 🔧 Tecnologías utilizadas

- [Streamlit](https://streamlit.io/)
- SQLite (lectura directa)
- CSV como alternativa (lecturas_cpp.csv o similar)

## ▶️ Ejecución

Desde el entorno virtual (`venv`) activado, ejecuta:

```bash
streamlit run dashboard/dashboard.py
```

El servidor se abrirá en tu navegador en [http://localhost:8501](http://localhost:8501)

## 📁 Archivos esperados

- `lecturas/lecturas_edge.db` generado por el nodo Edge
- o `lecturas/lecturas_cpp.csv` generado por el simulador en C++

## 🧪 Estado esperado

- Tabla actualizada en tiempo real al recibir lecturas
- Interfaz local para pruebas funcionales
