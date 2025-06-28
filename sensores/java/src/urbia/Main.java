package urbia;

import org.json.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

public class Main {

    static String login(String username, String password) throws Exception {
        URL url = new URL("http://localhost:8080/api/auth/login");
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json; utf-8");
        con.setDoOutput(true);

        JSONObject credentials = new JSONObject();
        credentials.put("username", username);
        credentials.put("password", password);

        try (OutputStream os = con.getOutputStream()) {
            byte[] input = credentials.toString().getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            response.append(line.trim());
        }

        JSONObject json = new JSONObject(response.toString());
        return json.getString("token");
    }

    static JSONArray getDevices(String token) throws Exception {
        URL url = new URL("http://localhost:8080/api/tenant/devices?pageSize=100&page=0");
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");
        con.setRequestProperty("X-Authorization", "Bearer " + token);

        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            response.append(line.trim());
        }

        JSONObject json = new JSONObject(response.toString());
        return json.getJSONArray("data");
    }

    static JSONArray getTelemetry(String token, String deviceId) throws Exception {
        URL url = new URL("http://localhost:8080/api/plugins/telemetry/DEVICE/" + deviceId + "/values/timeseries?keys=co2,temperatura,ruido,luz,humedad,presion");
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");
        con.setRequestProperty("X-Authorization", "Bearer " + token);

        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            response.append(line.trim());
        }

        JSONObject json = new JSONObject(response.toString());
        JSONArray resultados = new JSONArray();

        for (String key : json.keySet()) {
            JSONArray valores = json.getJSONArray(key);
            for (int i = 0; i < valores.length(); i++) {
                JSONObject lectura = valores.getJSONObject(i);
                JSONObject registro = new JSONObject();
                registro.put("ts", lectura.getLong("ts"));
                registro.put("key", key.toLowerCase());
                registro.put("value", lectura.getString("value"));
                resultados.put(registro);
            }
        }

        return resultados;
    }

    static void exportarCSV(JSONArray datos, String nombreDispositivo) {
        try (PrintWriter writer = new PrintWriter(new File("lecturas_" + nombreDispositivo + ".csv"))) {
            writer.println("timestamp,variable,valor");
            for (int i = 0; i < datos.length(); i++) {
                JSONObject dato = datos.getJSONObject(i);
                Date fecha = new Date(dato.getLong("ts"));
                writer.printf("%s,%s,%s%n", fecha.toString(), dato.getString("key"), dato.getString("value"));
            }
            System.out.println("📁 Archivo CSV generado: lecturas_" + nombreDispositivo + ".csv");
        } catch (Exception e) {
            System.out.println("❌ Error al escribir el archivo CSV: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        try {
            System.out.println("\n🌐 UrbIA :: Cliente Java para ThingsBoard\n");
            String username = "daniel@urbia.local";
            String password = "Urbia2025.";
            System.out.println("🧑 Usuario ThingsBoard: " + username);
            System.out.println("🔑 Contraseña: " + password);

            String token = login(username, password);
            System.out.println("✅ Token recibido: " + token);

            JSONArray dispositivos = getDevices(token);
            if (dispositivos.length() == 0) {
                System.out.println("⚠️ No se encontraron dispositivos.");
                return;
            }

            Scanner sc = new Scanner(System.in);
            while (true) {
                System.out.println("\n📋 Menú de opciones:");
                for (int i = 0; i < dispositivos.length(); i++) {
                    JSONObject dispositivo = dispositivos.getJSONObject(i);
                    String nombre = dispositivo.getString("name");
                    String tipo = dispositivo.getString("type");
                    System.out.printf("%d) %s [%s]\n", i + 1, nombre, tipo);
                }
                System.out.println("0) Salir\n");
                System.out.print("👉 Seleccione un dispositivo: ");
                int opcion = sc.nextInt();
                if (opcion == 0) break;

                JSONObject dispositivo = dispositivos.getJSONObject(opcion - 1);
                String deviceId = dispositivo.getJSONObject("id").getString("id");
                String nombreDispositivo = dispositivo.getString("name");

                JSONArray lecturas = getTelemetry(token, deviceId);
                System.out.println("\n📈 Últimas lecturas de: " + nombreDispositivo);
                for (int i = 0; i < lecturas.length(); i++) {
                    JSONObject dato = lecturas.getJSONObject(i);
                    Date fecha = new Date(dato.getLong("ts"));
                    System.out.printf("📌 [%s] %s = %s\n", fecha.toString(), dato.getString("key"), dato.getString("value"));
                }

                System.out.print("\n💾 ¿Desea exportar estas lecturas? (s/n): ");
                String exportar = sc.next();
                if (exportar.equalsIgnoreCase("s")) {
                    exportarCSV(lecturas, nombreDispositivo);
                }
            }

            System.out.println("👋 Programa finalizado.");

        } catch (Exception e) {
            System.out.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
