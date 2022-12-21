import random
import sys
from azure.iot.hub import IoTHubRegistryManager

MESSAGE_COUNT = 2
MSG_TXT = "{\"service client sent a message\": %.2f}"

# connection string dla iot huba
CONNECTION_STRING = "HostName=shamboo.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=LuaiDSdYuXy7N8e+cUNWplqqZrGgDh+8WALsYYjjZtY="
DEVICE_ID = "shamboo_apka"


def iothub_messaging():
    try:
        registry_manager = IoTHubRegistryManager(CONNECTION_STRING)

        for i in range(0, MESSAGE_COUNT):
            print('Sending message: {0}'.format(i))
            # na razie wysylamy losowa liczbe
            data = MSG_TXT % (random.random() * 4 + 2)

            props = {}
            # optional: assign system properties
            props.update(messageId="message_%d" % i)
            props.update(correlationId="correlation_%d" % i)
            props.update(contentType="application/json")

            # optional: assign application properties
            prop_text = "PropMsg_%d" % i
            props.update(testProperty=prop_text)

            registry_manager.send_c2d_message(DEVICE_ID, data, properties=props)

        input("Press Enter to continue...\n")

    except Exception as ex:
        print("Unexpected error {0}" % ex)
        return
    except KeyboardInterrupt:
        print("IoT Hub C2D Messaging service sample stopped")


if __name__ == '__main__':
    print("Starting...")
    iothub_messaging()


