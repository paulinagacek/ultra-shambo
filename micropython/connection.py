import usocket as socket
import network


class ConnectionManager:
    def __init__(self, port, ssid, password) -> None:
        self.port = port
        self.ssid = ""
        self.password = ""

        self.ap = network.WLAN(network.AP_IF)
        self.ap.config(essid=ssid,
            authmode=4, # WPA/WPA2-PSK
            password=password, 
            max_clients=10)

    def start_ap_and_get_wifi_data(self):
        self.ap.active(True)
        print("APN started")
        self.ssid, self.password = self.__get_wifi_data()
        print("APN stopped")
        self.ap.active(False)

    def wifi_connect(self):
        print(f"Connecting to {self.ssid}")
        wlan = network.WLAN(network.STA_IF)
        wlan.active(True)
        if not wlan.isconnected():
            wlan.connect(self.ssid, self.password)
            while not wlan.isconnected():
                pass
        print(f"Connected")

    def __get_wifi_data(self):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.bind(('', self.port))
        s.listen(5)

        conn, _ = s.accept()
        request = conn.recv(1024).rstrip()
        wifi_data = self.__parse_wifi_data(str(request))
        conn.send('OK')
        conn.close()
        s.close()
        return wifi_data


    def __parse_wifi_data(self, request: str):
        '''Required data format="ssid;password" '''
        return request[2:-1].split(';', 1)
