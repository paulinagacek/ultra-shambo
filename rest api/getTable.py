import requests
import base64
import hmac
import hashlib
import datetime

# Set the storage account name and storage account key
storage_account_name = "databaseshamboo"
storage_account_key = "nY4AF++rbHrDT4yQ/XUsFdytvUJUBxNN+4rpeZ6RB8YbjjjhaaKvgM8dDyzuJYk7xY+6tEIXkefw+AStF9RmMA=="

# Set the API version
api_version = "2021-06-08"

# Set the table name
table_name = "users"

# Set the current date and time
x_ms_date = datetime.datetime.utcnow().strftime("%a, %d %b %Y %H:%M:%S GMT")

# Set the resource URI
resource_uri = f"/{storage_account_name}/{table_name}"

# Set the content-type
content_type = "application/json;odata=nometadata"

# Set the HTTP verb
http_verb = "GET"

# Set the content-md5 to an empty string
content_md5 = ""

# Set the string-to-sign
string_to_sign = f"{http_verb}\n{content_md5}\n{content_type}\n{x_ms_date}\n{resource_uri}"

# Create the signature
signature = base64.b64encode(hmac.new(base64.b64decode(storage_account_key), msg=string_to_sign.encode('utf-8'), digestmod=hashlib.sha256).digest()).decode()

# Set the authorization header
authorization = f"SharedKey {storage_account_name}:{signature}"

# Set the headers
headers = {
    "x-ms-date": x_ms_date,
    "x-ms-version": api_version,
    "Authorization": authorization,
    "Content-Type": content_type,
    "Accept": "application/json"
}

# Set the URL
url = f"https://{storage_account_name}.table.core.windows.net/{table_name}"

# Send the request
response = requests.get(url, headers=headers)

# Print the response
print(response.text)
