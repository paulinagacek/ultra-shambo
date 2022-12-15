import socket

# Create a client socket
clientSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM);
# Connect to the server
clientSocket.connect(("192.168.4.1", 2137));
# Send data to server
data = "Redmi Note 11;bananaski";
clientSocket.send(data.encode());
# Receive data from server
dataFromServer = clientSocket.recv(1024);
# Print to the console
print(dataFromServer.decode());
