# sensores/cpp/Makefile
all:
\tg++ -std=c++17 -Wall src/sensor.cpp -o sensor_simulator -lcurl

run: all
\t./sensor_simulator

clean:
\trm -f sensor_simulator
