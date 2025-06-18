public class SimuladorTemperatura extends SensorBase {
    public SimuladorTemperatura(String id) {
        super(id, "temperatura", "°C");
    }

    @Override
    protected double generarValor() {
        return 20 + Math.random() * 10; // Simula entre 20 y 30
    }
}
