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
