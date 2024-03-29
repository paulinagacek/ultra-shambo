# -------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
# --------------------------------------------------------------------------

import os
import time
import uuid
from azure.iot.device import IoTHubDeviceClient, Message, X509

# The connection string for a device should never be stored in code.
# For the sake of simplicity we are creating the X509 connection string
# containing Hostname and Device Id in the following format:
# "HostName=<iothub_host_name>;DeviceId=<device_id>;x509=true"


# The device that has been created on the portal using X509 CA signing or Self signing capabilities
device_id = "esp32"
hostname = "shamboo.azure-devices.net"


x509 = X509(
    cert_file="cert.pem",
    key_file="esp32.pem",
    pass_phrase="",
)

# The client object is used to interact with your Azure IoT hub.
device_client = IoTHubDeviceClient.create_from_x509_certificate(
    hostname=hostname, device_id=device_id, x509=x509
)

# Connect the client.
device_client.connect()
print("Connected to Azure IoT Hub")
# send 5 messages with a 1 second pause between each message
for i in range(1, 3):
    print("sending message #" + str(i))
    msg = Message("test wind speed " + "cos sdasdasd")
    msg.message_id = uuid.uuid4()
    msg.correlation_id = "correlation-1234"
    msg.custom_properties["tornado-warning"] = "yes"
    msg.content_encoding = "utf-8"
    msg.content_type = "application/json"
    device_client.send_message(msg)
    time.sleep(1)

# # send only string messages
# for i in range(6, 11):
#     print("sending message #" + str(i))
#     device_client.send_message("test payload message " + str(i))
#     time.sleep(1)


# finally, shut down the client
device_client.shutdown()