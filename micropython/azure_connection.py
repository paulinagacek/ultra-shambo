from umqtt.robust import MQTTClient

class AzureConnectionManager:

    def __init__(self, device_id, hostname, sas_key) -> None:
        self.client = MQTTClient(
            client_id=device_id,
            server=hostname,
            keepalive=120,
            user=hostname+'/'+device_id+'/?api-version=2021-04-12',
            password=sas_key,
            ssl=True,
            port=8883
        )

    def connect(self):
        self.client.connect()

    def disconnect(self):
        self.client.disconnect()

    def send(self, topic, message):
        print("sending message:", message)
        self.client.publish(topic=topic, msg=message)
