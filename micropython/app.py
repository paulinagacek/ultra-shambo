import time
from read_distance import DistanceReader
from connection import ConnectionManager

config = {
    "TRIG_PIN": 18,
    "ECHO_PIN": 19,
    "PORT": 2137,
    "SSID": "ESP WIFI",
    "PASSWORD": "iotiot420"
}

def run():
    app = Application(config)
    app.run()

class Application:
    def __init__(self, config) -> None:
        self.config = config
        self.distance_reader = DistanceReader(self.config["TRIG_PIN"], self.config["ECHO_PIN"])
        self.connectionManager = ConnectionManager(self.config["PORT"], self.config["SSID"], self.config["PASSWORD"])

    def run(self) -> None:
        print("start")
        self.connectionManager.start_ap_and_get_wifi_data()
        self.connectionManager.wifi_connect()

        for i in range(20) :
            distance = self.distance_reader.read_distance()
            print("Distance (cm): ", distance)
            time.sleep(1) # wait 1 second

        print("finish")
    