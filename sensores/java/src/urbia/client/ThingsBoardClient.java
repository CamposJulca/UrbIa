package urbia.client;

import urbia.model.SensorLectura;
import urbia.utils.HttpUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.*;

public class ThingsBoardClient {
    private static final String URL_BASE = "http://localhost:8080/api";
    private final String username;
    private final String password;
    private String token;

    public ThingsBoardClient(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public boolean autenticar() {
        try {
            JSONObject payload = new JSONObject();
            payload.put("username", username);
            payload.put("password", password);

            String response = HttpUtils.post(URL_BASE + "/auth/login", payload.toString());
            JSONObject json = new JSONObject(response);
            token = json.getString("token");
            System.out.println("✅ Token recibido: " + token);
            return true;
        } catch (Exception e) {
            System.out.println("Error en autenticación: " + e.getMessage());
            return false;
        }
    }

    public List<Map<String, String>> obtenerDispositivos() {
        try {
            String response = HttpUtils.get(URL_BASE + "/tenant/devices?pageSize=100&page=0", token);
            JSONObject json = new JSONObject(response);
            JSONArray data = json.getJSONArray("data");

            List<Map<String, String>> dispositivos = new ArrayList<>();
            for (int i = 0; i < data.length(); i++) {
                JSONObject obj = data.getJSONObject(i);
                Map<String, String> map = new HashMap<>();
                map.put("id", obj.getJSONObject("id").getString("id")); // ✅ Accede al campo "id" dentro del objeto "id"
                map.put("name", obj.getString("name"));
                dispositivos.add(map);
            }
            return dispositivos;
        } catch (Exception e) {
            System.out.println("Error al obtener dispositivos: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    public List<SensorLectura> obtenerLecturas(String deviceId) {
        try {
            String url = URL_BASE + "/plugins/telemetry/DEVICE/" + deviceId + "/values/timeseries?limit=20";
            String response = HttpUtils.get(url, token);
            JSONObject json = new JSONObject(response);

            List<SensorLectura> lecturas = new ArrayList<>();
            for (String clave : json.keySet()) {
                JSONArray array = json.getJSONArray(clave);
                for (int i = 0; i < array.length(); i++) {
                    JSONObject obj = array.getJSONObject(i);
                    long ts = obj.getLong("ts");
                    String valor = obj.getString("value");
                    lecturas.add(new SensorLectura(ts, clave, valor));
                }
            }
            return lecturas;
        } catch (Exception e) {
            System.out.println("Error al obtener lecturas: " + e.getMessage());
            return Collections.emptyList();
        }
    }
}
