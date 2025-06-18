#!/bin/bash

echo "📊 Configurando dashboard local (Streamlit)..."

# Crear carpeta si no existe
mkdir -p dashboard

# Generar archivo principal de Streamlit
cat > dashboard/dashboard.py << 'EOF'
import streamlit as st
import pandas as pd
import sqlite3
from pathlib import Path

st.set_page_config(page_title="Dashboard UrbIA", layout="wide")
st.title("📊 Dashboard Local - Sensores UrbIA")

db_path = Path("lecturas/lecturas_edge.db")
csv_path = Path("lecturas/lecturas_cpp.csv")

# Mostrar desde base de datos si existe
if db_path.exists():
    st.subheader("Lecturas desde SQLite")
    with sqlite3.connect(str(db_path)) as conn:
        df = pd.read_sql_query("SELECT * FROM lectura ORDER BY timestamp DESC LIMIT 50", conn)
    st.dataframe(df, use_container_width=True)
# Fallback a CSV
elif csv_path.exists():
    st.subheader("Lecturas desde archivo CSV")
    df = pd.read_csv(csv_path)
    st.dataframe(df, use_container_width=True)
else:
    st.warning("No se encontraron datos disponibles aún.")
EOF

# Crear README
cat > dashboard/README.md << 'EOF'
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
EOF

echo "✅ Dashboard generado. Ejecuta con:"
echo "   ▶️ streamlit run dashboard/dashboard.py"
