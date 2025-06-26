#include <iostream>
#include <thread>
#include <chrono>
#include <vector>
#include <memory>
#include <cstdlib>
#include <ctime>
#include <nlohmann/json.hpp>

#include "SensorCO2.hpp"
#include "SensorTemperatura.hpp"
#include "SensorHumedad.hpp"
#include "SensorPresion.hpp"
#include "SensorLuz.hpp"
#include "SensorRuido.hpp"
#include "HttpClient.hpp"

using json = nlohmann::json;

int main() {
    std::srand(static_cast<unsigned int>(std::time(nullptr))); // Semilla aleatoria

    std::string token = "dZmGv5GgLocgJxy2fSXC";
    HttpClient client(token);

    std::vector<std::shared_ptr<SensorBase>> sensores = {
        std::make_shared<SensorCO2>(),
        std::make_shared<SensorTemperatura>(),
        std::make_shared<SensorHumedad>(),
        std::make_shared<SensorPresion>(),
        std::make_shared<SensorLuz>(),
        std::make_shared<SensorRuido>()
    };


    while (true) {
        json payload;
        for (const auto& sensor : sensores) {
            double valor = sensor->leerValor();
            std::cout << "📡 Sensor: " << sensor->getTipo() << ", Valor: " << valor << std::endl;
            payload[sensor->getTipo()] = valor;
        }

        if (!client.enviarJson(payload.dump())) {
            std::cerr << "❌ Error al enviar datos a ThingsBoard.\n";
        } else {
            std::cout << "✅ Datos enviados correctamente.\n";
        }

        std::this_thread::sleep_for(std::chrono::seconds(5));
    }

    return 0;
}
