#!/bin/bash

echo "🛑 Deteniendo servicios de UrbIA..."

# Detener FastAPI
pkill -f "uvicorn.*edge.main"
echo "❎ Nodo Edge detenido"

# Detener simulador Python
pkill -f "python sensores/python/main.py"
echo "❎ Simulador Python detenido"

# Detener simulador C++
pkill -f "sensor_simulator"
echo "❎ Simulador C++ detenido"

# Detener dashboard Streamlit
pkill -f "streamlit run dashboard/dashboard.py"
echo "❎ Dashboard Streamlit detenido"

echo "✅ Todos los procesos fueron detenidos exitosamente."
