public class Main {
    public static void main(String[] args) {
        SensorBase sensor = new SimuladorTemperatura("TEMP-JAVA-001");
        sensor.enviarLectura();
    }
}
