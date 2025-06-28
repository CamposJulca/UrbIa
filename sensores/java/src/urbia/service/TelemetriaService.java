package urbia.service;

import urbia.client.ThingsBoardClient;
import urbia.model.SensorLectura;

import java.util.*;

public class TelemetriaService {

    private final ThingsBoardClient client;

    public TelemetriaService(ThingsBoardClient client) {
        this.client = client;
    }

    public List<SensorLectura> obtenerUltimasLecturas(String deviceId) {
        return client.obtenerLecturas(deviceId);
    }

    public void mostrarResumenLecturas(String deviceId) {
        List<SensorLectura> lecturas = obtenerUltimasLecturas(deviceId);
        if (lecturas.isEmpty()) {
            System.out.println("⚠️ No hay lecturas para este dispositivo.");
            return;
        }

        System.out.println("\n📊 Resumen de lecturas:");
        for (SensorLectura lectura : lecturas) {
            System.out.printf("📌 [%s] %s = %s\n", new Date(lectura.getTimestamp()), lectura.getClave(), lectura.getValor());
        }
    }
}
