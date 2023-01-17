import usocket as socket
import time
import network


class WiFiConnectionManager:
    def __init__(self, device_id, port, ssid, password) -> None:
        self.device_id = device_id
        self.port = port
        self.ssid = ""
        self.password = ""

        self.ap = network.WLAN(network.AP_IF)
        self.ap.config(essid=ssid,
            authmode=4, # WPA2-PSK
            password=password, 
            max_clients=10)

        self.wifi = None

    def start_ap_and_get_wifi_data(self):
        self.ap.active(True)
        print("APN started")
        self.ssid, self.password = self.__get_wifi_data()
        print(self.ssid, self.password)
        print("APN stopped")
        self.ap.active(False)

    def __get_wifi_data(self):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # Create STREAM TCP socket
        s.bind(('', self.port)) # bind socket with any IP and port
        s.listen(5) # the number of unaccepted connections 

        conn, _ = s.accept()
        request = conn.recv(1024).rstrip() # receive msg
        wifi_data = self.__parse_wifi_data(str(request))
        conn.send(self.device_id)
        time.sleep(0.2)
        conn.close()
        s.close()
        return wifi_data

    def __parse_wifi_data(self, request: str):
        '''Required data format="ssid;password" '''
        return request[2:-1].split(';', 1)

    def wifi_connect(self):
        print(f"Connecting to {self.ssid}")
        self.wifi = network.WLAN(network.STA_IF)
        self.wifi.active(True)
        start = time.time()
        if not self.wifi.isconnected():
            self.wifi.connect(self.ssid, self.password)
            while not self.wifi.isconnected():
                if time.time() - start > 30:
                    print("Did not connect")
                    self.wifi_disconnect()
                    return False
        print("Connected")
        return True

    def wifi_disconnect(self):
        self.wifi.active(False)
        self.wifi = None
