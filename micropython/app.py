import time
from read_distance import DistanceReader
from wifi_connection import WiFiConnectionManager
from azure_connection import AzureConnectionManager
from umqtt.robust import MQTTClient
import os

config = {
    'TRIG_PIN': 18,
    'ECHO_PIN': 19,
    'PORT': 8888,
    'SSID': 'ESP WIFI',
    'PASSWORD': 'iotiot420',
    'HOSTNAME': 'shamboo.azure-devices.net',
    'DEVICE_ID': 'esp32SAS',
    'SAS_KEY': 'SharedAccessSignature sr=shamboo.azure-devices.net%2Fdevices%2Fesp32SAS&sig=RMLGnNT%2FEEhOQNyNma8%2F0Ar2wD%2FteMVPkAgVZJAjDCM%3D&se=2032766595',
}

class Application:
    def __init__(self, config) -> None:
        self.distance_reader = DistanceReader(
            config['TRIG_PIN'],
            config['ECHO_PIN'])
        self.wifiConnectionManager = WiFiConnectionManager(
            config['DEVICE_ID'],
            config['PORT'],
            config['SSID'],
            config['PASSWORD'])
        self.azureConnectionManager = AzureConnectionManager(
            config['DEVICE_ID'],
            config['HOSTNAME'],
            config['SAS_KEY'])

        self.telemetry_topic = 'devices/' + \
            config["DEVICE_ID"] + '/messages/events/' + \
            '$.ct=application%2Fjson&$.ce=utf-8'
        self.c2d_topic = 'devices/' + \
            config["DEVICE_ID"] + '/messages/devicebound/#'

    def get_wifi_data(self):
        try:
            with open('wifi_data.txt', 'r') as f:
                print("Reading saved")
                lines = f.read().split('\n')
                self.wifiConnectionManager.ssid = lines[0].strip()
                self.wifiConnectionManager.password = lines[1].strip()
        except Exception as e:
            print(e)
            print("Writing to saved file")
            self.wifiConnectionManager.start_ap_and_get_wifi_data()
            with open('wifi_data.txt', 'w') as f:
                f.write(self.wifiConnectionManager.ssid + "\n" + self.wifiConnectionManager.password)


    def reset_password(self):
        if os.path.exists('wifi_data.txt'):
            os.remove('wifi_data.txt')

    def run(self) -> None:
        print('start')
        self.get_wifi_data()
        # self.wifiConnectionManager.start_ap_and_get_wifi_data()
        while not self.wifiConnectionManager.wifi_connect():
            self.wifiConnectionManager.start_ap_and_get_wifi_data()
        self.azureConnectionManager.connect()
        print('Connected to Azure')

        for i in range(20):
            distance = self.distance_reader.read_distance()
            print("sending message")
            self.azureConnectionManager.send(
                self.telemetry_topic, '{ "device_id": "' + config["DEVICE_ID"] + '", "distance": ' + str(distance) + ' }')
            print('Distance (cm): ', distance)
            time.sleep(15)  # wait 1 second

        self.azureConnectionManager.disconnect()
        self.wifiConnectionManager.wifi_disconnect()
        print('finish')


app = Application(config)


def run():
    app.run()
