#!/bin/bash

echo "🔧 Iniciando UrbIA..."

# Activar entorno virtual
source venv/bin/activate
echo "✅ Entorno virtual activado"

# Limpiar procesos anteriores
echo "🧹 Limpiando procesos previos..."
pkill -f "uvicorn.*edge.main" 2>/dev/null
pkill -f "python.*main.py" 2>/dev/null
pkill -f "streamlit.*dashboard.py" 2>/dev/null
pkill -f "make run" 2>/dev/null
pkill -f "java.*Main" 2>/dev/null

# Asegurar carpetas necesarias
mkdir -p logs lecturas

# Verificar base de datos SQLite
echo "📁 Verificando base de datos SQLite..."
python -c "from edge.app.storage import init_db; init_db()"
echo "📦 Base de datos lista"

# Lanzar servidor FastAPI
echo "🚀 Lanzando nodo Edge en puerto 8000..."
uvicorn edge.main:app --reload --port 8000 > logs/edge.log 2>&1 &
PID_EDGE=$!

# Simulador Python
echo "🐍 Iniciando simulador Python..."
python sensores/python/main.py > logs/sim_python.log 2>&1 &
PID_PYTHON=$!

# Simulador C++
echo "🛠️ Compilando y ejecutando simulador C++..."
cd sensores/cpp
make run > ../../logs/sim_cpp.log 2>&1 &
PID_CPP=$!
cd ../../

# Simulador Java
echo "☕ Compilando y ejecutando simulador Java..."
cd sensores/java
javac *.java && java Main > ../../logs/sim_java.log 2>&1 &
PID_JAVA=$!
cd ../../

# Dashboard Streamlit
echo "📊 Lanzando dashboard Streamlit en puerto 8501..."
streamlit run dashboard/dashboard.py > logs/dashboard.log 2>&1 &
PID_DASHBOARD=$!

# Mensaje final
echo "🌎 Todos los servicios están ejecutándose en segundo plano"
echo "📊 Logs disponibles en la carpeta 'logs/'"
echo ""
echo "🧼 Para detener todo manualmente, usa:"
echo "   kill $PID_EDGE $PID_PYTHON $PID_CPP $PID_JAVA $PID_DASHBOARD"
