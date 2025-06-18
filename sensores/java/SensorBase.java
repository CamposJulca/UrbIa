import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.Instant;

public abstract class SensorBase {
    protected String sensorId;
    protected String tipo;
    protected String unidad;

    public SensorBase(String sensorId, String tipo, String unidad) {
        this.sensorId = sensorId;
        this.tipo = tipo;
        this.unidad = unidad;
    }

    public void enviarLectura() {
        double valor = generarValor();
        String timestamp = Instant.now().toString();
        String json = String.format("{\"sensor_id\":\"%s\",\"tipo\":\"%s\",\"valor\":%.2f,\"unidad\":\"%s\",\"timestamp\":\"%s\"}",
                sensorId, tipo, valor, unidad, timestamp);
        try {
            URL url = new URL("http://localhost:8000/api/lectura/");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            OutputStream os = conn.getOutputStream();
            os.write(json.getBytes());
            os.flush();
            os.close();
            System.out.println("Lectura enviada: " + json);
        } catch (Exception e) {
            System.out.println("❌ Error al enviar lectura: " + e.getMessage());
        }
    }

    protected abstract double generarValor();
}
