from diagrams import Diagram, Cluster
from diagrams.custom import Custom
from diagrams.onprem.client import Users

with Diagram("UrbIA - Arquitectura PMV (Fase 0)", filename="urbia_arquitectura_pmv_fase0", outformat="png", show=True, graph_attr={"bgcolor": "white"}):

    user = Users("Usuario Local")

    with Cluster("📊 Dashboard Local", graph_attr={"bgcolor": "#e6f2ff"}):
        db_vis = Custom("lecturas_edge.db", "./icons/sqlite_icon.png")
        csv_vis = Custom("lecturas_cpp.csv", "./icons/cpp_icon.png")
        streamlit_ui = Custom("Streamlit UI", "./icons/streamlit_icon.png")
        user >> streamlit_ui
        db_vis >> streamlit_ui
        csv_vis >> streamlit_ui

    with Cluster("📍 Sensores Simulados", graph_attr={"bgcolor": "#f2f9ff"}):
        sensor_python = Custom("Sensor Python", "./icons/python_icon.png")
        sensor_cpp = Custom("Sensor C++", "./icons/cpp_icon.png")
        sensor_java = Custom("Sensor Java", "./icons/java_icon.png")

    with Cluster("🧠 Nodo Edge", graph_attr={"bgcolor": "#f2f2f2"}):
        edge_api = Custom("FastAPI API", "./icons/python_icon.png")
        sqlite = Custom("SQLite (Edge)", "./icons/sqlite_icon.png")
        edge_api >> sqlite

    with Cluster("📝 Logs", graph_attr={"bgcolor": "#f9f9f9"}):
        log_file = Custom("logs/", "./icons/log_icon.png")

    # Flujo sensores hacia Edge
    sensor_python >> edge_api
    sensor_cpp >> edge_api
    sensor_java >> edge_api

    # Flujo hacia logs
    sensor_python >> log_file
    sensor_cpp >> log_file
    sensor_java >> log_file
    edge_api >> log_file

    # Dashboard accede a datos del Edge
    sqlite >> streamlit_ui
