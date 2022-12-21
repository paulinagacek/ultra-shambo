import time
from azure.iot.device import IoTHubDeviceClient

RECEIVED_MESSAGES = 0

# connection string brany dla apki
CONNECTION_STRING = "HostName=shamboo.azure-devices.net;DeviceId=shamboo_apka;SharedAccessKey=szME/R607srN+8uT/N5d02lZeE/QcEEaPhtfMjQ7pCY="


def message_handler(message):
    global RECEIVED_MESSAGES
    RECEIVED_MESSAGES += 1
    print("")
    print("Message received:")
    for property_ in vars(message).items():
        print("    {}".format(property_))
    print("Total calls received: {}".format(RECEIVED_MESSAGES))


def main():
    print("Starting...")

    client = IoTHubDeviceClient.create_from_connection_string(CONNECTION_STRING)

    print("Waiting for C2D messages, press Ctrl-C to exit")
    try:
        # Attach the handler to the client
        client.on_message_received = message_handler

        while True:
            time.sleep(1000)
    except KeyboardInterrupt:
        print("IoT Hub C2D Messaging device sample stopped")
    finally:
        # Graceful exit
        print("Shutting down IoT Hub Client")
        client.shutdown()


if __name__ == '__main__':
    main()

