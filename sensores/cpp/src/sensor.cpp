// sensores/cpp/src/sensor.cpp
#include <iostream>
#include <fstream>
#include <string>
#include <chrono>
#include <thread>
#include <ctime>
#include <random>
#include <curl/curl.h>
using namespace std;

string now_iso() {
    time_t now = time(0);
    tm *gmtm = gmtime(&now);
    char buf[80];
    strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%S", gmtm);
    return string(buf);
}

double generar_temperatura() {
    random_device rd;
    mt19937 gen(rd());
    uniform_real_distribution<> dis(18.0, 35.0);
    return dis(gen);
}

void enviar_lectura() {
    CURL *curl = curl_easy_init();
    if(curl) {
        string timestamp = now_iso();
        double valor = generar_temperatura();
        string json = "{\"sensor_id\":\"TEMP-CPP\",\"tipo\":\"temperatura\",\"valor\":" + to_string(valor) + ",\"unidad\":\"°C\",\"timestamp\":\"" + timestamp + "\"}";

        curl_easy_setopt(curl, CURLOPT_URL, "http://localhost:8000/api/lectura/");
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, json.c_str());

        struct curl_slist *headers = NULL;
        headers = curl_slist_append(headers, "Content-Type: application/json");
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

        CURLcode res = curl_easy_perform(curl);
        if(res != CURLE_OK)
            cerr << "❌ Error al enviar datos: " << curl_easy_strerror(res) << endl;
        else
            cout << "📈 Lectura: " << valor << " °C [" << timestamp << "]" << endl;

        curl_easy_cleanup(curl);
    }
}

int main() {
    cout << "🌡️ Simulador C++ + HTTP iniciado..." << endl;
    while (true) {
        enviar_lectura();
        this_thread::sleep_for(chrono::seconds(5));
    }
    return 0;
}
