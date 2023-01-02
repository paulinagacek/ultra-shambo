
from azure.storage.blob import BlobServiceClient
import json

storage_account_name = "databaseshamboo"
access_key = "nY4AF++rbHrDT4yQ/XUsFdytvUJUBxNN+4rpeZ6RB8YbjjjhaaKvgM8dDyzuJYk7xY+6tEIXkefw+AStF9RmMA=="


container_name = "shamboo"
conn_string = "DefaultEndpointsProtocol=https;AccountName=databaseshamboo;AccountKey=nY4AF++rbHrDT4yQ/XUsFdytvUJUBxNN+4rpeZ6RB8YbjjjhaaKvgM8dDyzuJYk7xY+6tEIXkefw+AStF9RmMA==;EndpointSuffix=core.windows.net"
blob_service_client = BlobServiceClient.from_connection_string(conn_string)


container_client = blob_service_client.get_container_client(container_name)
blob_list = []

for blob in container_client.list_blobs():
    blob_list.append(blob)

blob_list.sort(key=lambda blob: blob.last_modified, reverse=True)


content = container_client.download_blob(blob_list[0].name).readall().decode('utf-8')
content = content.split('"Body":')[1].split('}')[0]

print(content)
