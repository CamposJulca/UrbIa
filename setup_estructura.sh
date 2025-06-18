#!/bin/bash

echo "🚧 Iniciando configuración de estructura para UrbIA (Fase 0)..."

# Crear carpetas base
echo "📁 Creando carpetas base..."
mkdir -p sensores/python sensores/cpp sensores/java
mkdir -p edge/app
mkdir -p dashboard
mkdir -p lecturas
mkdir -p logs
mkdir -p shared

# Crear entorno virtual
echo "🐍 Creando entorno virtual..."
python3 -m venv venv

# Activar entorno virtual
source venv/bin/activate

# Instalar dependencias necesarias
echo "🔧 Instalando paquetes básicos..."
pip install --upgrade pip
pip install fastapi uvicorn requests streamlit --break-system-packages
pip freeze | grep -E 'fastapi|uvicorn|requests|streamlit' > requirements.txt

# Crear README.md inicial
echo "📝 Generando README.md..."
cat <<EOF > README.md
# UrbIA - Plataforma de Monitoreo Urbano Inteligente

Este repositorio contiene el desarrollo del Producto Mínimo Viable (PMV) del sistema UrbIA, inspirado en la tesis de J.S. Giraldo. El sistema permite simular sensores, capturar datos vía un nodo Edge y visualizar lecturas localmente.

## Estructura

- \`sensores/\`: simuladores multilenguaje (Python, C++, Java)
- \`edge/\`: nodo receptor en FastAPI + SQLite
- \`dashboard/\`: visualización local (Streamlit o HTML)
- \`logs/\`: registros de operación
- \`lecturas/\`: datos generados y recibidos
- \`shared/\`: interfaces y definiciones comunes

## Requisitos

- Python 3.10+
- venv habilitado
- GCC para C++
- JDK 17+ para simulador Java

## Fase 0 - PMV

- Comunicación sensor → edge (HTTP POST)
- Persistencia local en SQLite
- Simulación de múltiples tipos de sensores
- Visualización básica de lecturas
EOF

echo "✅ Estructura lista. Ahora puedes ejecutar:"
echo "    source venv/bin/activate"
