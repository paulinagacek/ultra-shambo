import time
from read_distance import DistanceReader
from phone_connection import PhoneConnectionManager
# from azure_connection import AzureConnectionManager
from own_umqtt import MQTTClient
import urequests
import machine
rtc = machine.RTC()
rtc.datetime((2023, 1, 6, 4, 12, 0, 0, 0))

config = {
    'TRIG_PIN': 18,
    'ECHO_PIN': 19,
    'PORT': 8888,
    'SSID': 'ESP WIFI',
    'PASSWORD': 'iotiot420',
    # 'DEVICE_ID': 'shamboo_distance_meter',
    'HOSTNAME': 'shamboo.azure-devices.net',
    'DEVICE_ID': 'esp32',
    'SAS_KEY': 'SharedAccessSignature sr=shamboo.azure-devices.net%2Fdevices%2Fesp32SAS&sig=RMLGnNT%2FEEhOQNyNma8%2F0Ar2wD%2FteMVPkAgVZJAjDCM%3D&se=2032766595',
    'CERT_PATH': 'flash/certs/public.pem',
    'KEY_PATH': 'flash/certs/private.pem'
}


class Application:
    def __init__(self, config) -> None:
        self.distance_reader = DistanceReader(
            config['TRIG_PIN'], 
            config['ECHO_PIN'])
        self.phoneConnectionManager = PhoneConnectionManager(
            config['DEVICE_ID'],
            config['PORT'], 
            config['SSID'], 
            config['PASSWORD'])
        # self.azureConnectionManager = AzureConnectionManager(
        #     config['DEVICE_ID'], 
        #     config['HOSTNAME'], 
        #     config['SAS_KEY'])
        # self.client = MQTTClient(
        #     client_id=config['DEVICE_ID'],
        #     server=config['HOSTNAME'],
        #     user=f'{config['HOSTNAME']}/{config['DEVICE_ID']}',
        #     password=config['SAS_KEY'],
        #     keepalive=60
        # )

        with open(config['CERT_PATH'], 'r') as f:
            cert = f.read()
        with open(config['KEY_PATH'], 'r') as f:
            key = f.read()

        # def parse_connection(connection_string):
        #     cs_args = connection_string.split(DELIMITER)
        #     dictionary = dict(arg.split(VALUE_SEPARATOR, 1) for arg in cs_args)
        #     return dictionary
        issas = False

        if issas:
            self.client = MQTTClient(
                client_id=config['DEVICE_ID'],
                server=config['HOSTNAME'],
                keepalive=120,
                user=config['HOSTNAME']+'/'+config['DEVICE_ID']+'/?api-version=2021-04-12',
                password=config['SAS_KEY'],
                ssl=True,
                port=8883
            )
        else:
            self.client = MQTTClient(
                client_id=config['DEVICE_ID'],
                server=config['HOSTNAME'],
                keepalive=120,
                port=8883,
                ssl=True,
                ssl_params={'cert': cert, 'key': key, 'server_side': False}
            )



        self.telemetry_topic = 'devices/' + config["DEVICE_ID"] + '/messages/events/' + '$.ct=application%2Fjson&$.ce=utf-8'
        self.c2d_topic = 'devices/' + config["DEVICE_ID"] + '/messages/devicebound/#'

    def run(self) -> None:
        print('start')
        # self.phoneConnectionManager.start_ap_and_get_wifi_data()
        self.phoneConnectionManager.ssid = 'Redmi Note 11'
        self.phoneConnectionManager.password = 'bananaski'
        self.phoneConnectionManager.wifi_connect()

        # self.azureConnectionManager.connect()
        # self.azureConnectionManager.send(self.telemetry_topic, 'ds 21')
        # self.azureConnectionManager.disconnect()
        self.client.connect()

        print('Connected to Azure')
        for i in range(5):
            print("sending message")
            self.client.publish(
                topic=self.telemetry_topic, 
                msg='{ "device_id": ' + config["DEVICE_ID"] + ', "distance": ' + str(20.137) + ' }')
            time.sleep(1)

        for i in range(20):
            distance = self.distance_reader.read_distance()
            print('Distance (cm): ', distance)
            time.sleep(1)  # wait 1 second

        self.client.disconnect()
        self.phoneConnectionManager.wifi_disconnect()
        print('finish')


app = Application(config)

def run():
    app.run()
