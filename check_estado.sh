#!/bin/bash

echo "🔍 Verificando estado de los servicios de UrbIA..."

check_service() {
  pgrep -f "$1" > /dev/null
  if [ $? -eq 0 ]; then
    echo "✅ $2: OK"
  else
    echo "❌ $2: ERROR"
  fi
}

check_service "uvicorn.*edge.main"       "Nodo Edge (FastAPI)"
check_service "python.*main.py"          "Simulador Python"
check_service "make run"                 "Simulador C++"
check_service "java.*Main"               "Simulador Java"
check_service "streamlit.*dashboard.py"  "Dashboard (Streamlit)"
