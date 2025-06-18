from diagrams import Diagram, Cluster
from diagrams.custom import Custom
from diagrams.onprem.client import Users

with Diagram("UrbIA - Arquitectura General (Fase 0 – Fase 3)", filename="urbia_arquitectura_general", outformat="png", show=True, graph_attr={"bgcolor": "white"}):

    user = Users("Usuarios Urbanos")

    # -------------------- Fase 0 y 1 --------------------
    with Cluster("Fase 0-1: Sensores Simulados y Edge Local", graph_attr={"bgcolor": "#eefaf7"}):
        with Cluster("Sensores Multilenguaje"):
            sensor_java = Custom("Sensor Java", "./icons/java_icon.png")
            sensor_cpp = Custom("Sensor C++", "./icons/cpp_icon.png")
            sensor_python = Custom("Sensor Python", "./icons/python_icon.png")

        fastapi = Custom("FastAPI API", "./icons/python_icon.png")
        sqlite_local = Custom("SQLite (local)", "./icons/sqlite_icon.png")
        logs = Custom("Logs", "./icons/log_icon.png")

        # Flujo de sensores hacia Edge
        sensor_java >> fastapi
        sensor_cpp >> fastapi
        sensor_python >> fastapi

        # Logs
        sensor_java >> logs
        sensor_cpp >> logs
        sensor_python >> logs
        fastapi >> logs

        # Base de datos local
        fastapi >> sqlite_local

    # -------------------- Fase 2 --------------------
    with Cluster("Fase 2: Infraestructura Dockerizada", graph_attr={"bgcolor": "#f0f4ff"}):
        docker_sensor_java = Custom("SensorJava", "./icons/java_icon.png")
        docker_sensor_cpp = Custom("SensorCpp", "./icons/cpp_icon.png")
        docker_sensor_py = Custom("SensorPy", "./icons/python_icon.png")
        mqtt = Custom("MQTT Broker", "./icons/mqtt_icon.png")
        edge_api = Custom("EdgeAPI", "./icons/python_icon.png")
        postgres = Custom("PostgreSQL", "./icons/sqlite_icon.png")
        grafana = Custom("Grafana", "./icons/grafana_icon.png")

        # Flujo sensores → MQTT
        docker_sensor_java >> mqtt
        docker_sensor_cpp >> mqtt
        docker_sensor_py >> mqtt

        # MQTT → Edge API → PostgreSQL → Grafana
        mqtt >> edge_api >> postgres >> grafana

    # -------------------- Fase 3 --------------------
    with Cluster("Fase 3: Producción en la Nube / LAN", graph_attr={"bgcolor": "#f9f5f5"}):
        ansible = Custom("Gestión Despliegue", "./icons/ubuntu_icon.png")
        streamlit = Custom("Streamlit UI Pública", "./icons/streamlit_icon.png")
        nginx = Custom("Servidor Producción / API Gateway", "./icons/node_icon.png")
        sdn = Custom("Controlador SDN", "./icons/sdn_icon.png")

        # Usuarios acceden a Streamlit
        user >> streamlit

        # Despliegue → servidor
        ansible >> nginx
        streamlit >> nginx

        # Servidor se conecta al SDN
        nginx >> sdn

