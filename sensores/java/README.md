# 🌐 UrbIA - Cliente Java para ThingsBoard

Este módulo implementa un cliente Java que se conecta a la plataforma [ThingsBoard](https://thingsboard.io/) para consultar los dispositivos registrados, visualizar sus lecturas más recientes y exportarlas a un archivo CSV. Forma parte del ecosistema UrbIA, enfocado en el monitoreo urbano inteligente con sensores IoT.

---

## 📁 Estructura del proyecto

```

sensores/java/
├── lib/                     # Librerías externas (ej. JSON)
│   └── json-20210307.jar
├── src/                     # Código fuente
│   ├── urbia/
│   │   ├── Main.java        # Clase principal con flujo de login, menú y exportación
│   │   ├── AuthService.java # Servicio de autenticación con ThingsBoard
│   │   ├── DeviceClient.java# Cliente para obtener lista de dispositivos y sus datos
│   │   └── Utils.java       # Funciones auxiliares (formateo, exportación, etc.)
├── bin/                     # Archivos compilados (.class)
├── urbia-client.jar         # Versión compilada lista para ejecución
└── README.md

````

---

## 🧱 Dependencias

- Java 11 o superior
- Librería JSON para Java: `json-20210307.jar`

Puedes descargar esta dependencia desde:
https://repo1.maven.org/maven2/org/json/json/20210307/json-20210307.jar

---

## 🚀 Compilación

Desde la carpeta `sensores/java`, ejecuta:

```bash
rm -rf bin
mkdir bin
javac -cp lib/json-20210307.jar -d bin $(find src -name "*.java")
````

---

## ▶️ Ejecución

```bash
java -cp bin:lib/json-20210307.jar urbia.Main
```

El cliente solicitará credenciales para ThingsBoard (por defecto configurado para `localhost:8080`) y mostrará un menú con los dispositivos disponibles. Al seleccionar un dispositivo, se listarán las últimas lecturas del sensor.

---

## 💾 Exportación

Después de visualizar las lecturas, el sistema permite exportarlas como archivo CSV en consola, en el siguiente formato:

```
Fecha,Variable,Valor
2025-06-28 15:06:03,co2,576.0
2025-06-28 15:06:03,ruido,119.89
...
```

---

## ✅ Mejoras implementadas

* Autenticación automática con token JWT.
* Visualización unificada de múltiples variables por sensor.
* Compatibilidad con distintos formatos de nombres (`Temperatura`, `temperature`, etc.).
* Exportación CSV directa desde consola.
* Menú interactivo para seleccionar dispositivos disponibles.

---

## 🔒 Notas de seguridad

Este cliente no almacena contraseñas. La autenticación es válida durante 1 hora (según el TTL del token generado por ThingsBoard).

---

