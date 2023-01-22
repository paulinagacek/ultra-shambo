# from umqtt.robust import MQTTClient
import urequests as requests
import ujson

# class AzureConnectionManager:

#     def __init__(self, device_id, hostname, sas_key) -> None:
#         self.client = MQTTClient(
#             client_id=device_id,
#             server=hostname,
#             keepalive=120,
#             user=hostname+'/'+device_id+'/?api-version=2021-04-12',
#             password=sas_key,
#             ssl=True,
#             port=8883
#         )

#     def connect(self):
#         self.client.connect()

#     def disconnect(self):
#         self.client.disconnect()

#     def send(self, topic, message):
#         print("sending message:", message)
#         self.client.publish(topic=topic, msg=message)

class AzureConnectionManagerHttps:
    UPLOAD_MEASUREMENT_URL = 'https://shamboo-backend.azure-api.net/readBlobApp/SendDistance'
    def __init__(self, device_id) -> None:
        self.device_id = device_id

    def send_distance(self, distance):
        post_data = ujson.dumps({ 'device_id': self.device_id, 'distance': distance})

        print("sending message :", '{ "device_id": "' + self.device_id + '", "distance": ' + str(distance) + ' }')
        res = requests.post(AzureConnectionManagerHttps.UPLOAD_MEASUREMENT_URL, headers = {'content-type': 'application/json'}, data = post_data).text
        print('Response:', res)
