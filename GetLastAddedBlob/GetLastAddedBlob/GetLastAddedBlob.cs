using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Linq;
using Azure.Storage.Blobs;
using System.Net.Http;

namespace GetLastAddedBlob
{
    public static class GetLastAddedBlob
    {
        [FunctionName("GetLastAddedBlob")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            //creds for connection
            string accountName = "databaseshamboo";
            string accountKey = "nY4AF++rbHrDT4yQ/XUsFdytvUJUBxNN+4rpeZ6RB8YbjjjhaaKvgM8dDyzuJYk7xY+6tEIXkefw+AStF9RmMA==";
            
            //creds for blob
            string connectionString = $"DefaultEndpointsProtocol=https;AccountName={accountName};AccountKey={accountKey};EndpointSuffix=core.windows.net";
            string containerName = "shamboo";

            req.Query.TryGetValue("device_id", out var deviceID);
            req.Query.TryGetValue("email", out var userEmail);
            req.Query.TryGetValue("password", out var userPassword);

            if (userPassword.Count == 0 || userEmail.Count == 0 || deviceID.Count == 0)

            {
                return new BadRequestObjectResult(-1);
            }
            
            try
            {
                using HttpClient httpClient = new();
                using HttpResponseMessage response = await httpClient.GetAsync($"https://shamboo-backend.azure-api.net/tableService/logUser?email={userEmail[0]}&password={userPassword[0]}");
                response.EnsureSuccessStatusCode();
                string responseBody = await response.Content.ReadAsStringAsync();


            }
            catch (HttpRequestException e)
            {
                return new BadRequestObjectResult(-1);
            }
            
            var container = new BlobContainerClient(connectionString, containerName);            
            var blobs = container.GetBlobs()
                                 .Where(b => b.Properties.CreatedOn > DateTime.Now.AddDays(-7))
                                 .OrderByDescending(b => b.Properties.CreatedOn)
                                 .ToList();
            
            foreach (var blob in blobs)
            {
                BlobClient blobClient = container.GetBlobClient(blob.Name);
                var ms = new MemoryStream();
                blobClient.DownloadTo(ms);
                ms.Position = 0;
                try
                {
                    string refactoredName = "\"" + deviceID[0] + "\"";
                    string content = new StreamReader(ms).ReadToEnd();
                    string Body = content.Split("Body\":{")[^1].Split('}')[0][..^0];
                    string[] deviceNameAndDistance = Body.Split(',');
                    string deviceName = deviceNameAndDistance[0].Split("\"device_id\": ")[1];
                    if (refactoredName == deviceName || deviceID[0] == "\"" + deviceName + "\"")
                    {
                        return new OkObjectResult(deviceNameAndDistance[1].Split(":")[1]);
                    }
                }
                catch (Exception e)
                {
                    //Catches incorrect messages
                    continue;
                }                
                
            }

            return new BadRequestObjectResult(-1);



        }
    }
}

