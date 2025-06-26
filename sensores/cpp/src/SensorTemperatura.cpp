#include "SensorTemperatura.hpp"
#include <cstdlib>

SensorTemperatura::SensorTemperatura() : SensorBase("Temperatura") {}

std::string SensorTemperatura::getTipo() const {
    return "Temperatura";
}

double SensorTemperatura::leerValor() const {
    return 20.0 + static_cast<double>(std::rand() % 1501) / 100.0;  // 20.0 - 35.0 °C
}
