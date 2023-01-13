using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System.Linq;
using Microsoft.WindowsAzure.Storage.Auth;
using System.Collections.Generic;
using System.ComponentModel;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using System.Security.Principal;
using Microsoft.WindowsAzure.Storage.Table;
using System.Collections;
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
            string SAS = "?sp=raud&st=2023-01-06T10:15:38Z&se=2023-02-07T10:15:00Z&spr=https&sv=2021-06-08&sig=AcltWqm8TCa%2Bre%2B8LUxZX9O%2FR%2BJTIzcVIvRYKc2%2BGeU%3D&tn=users";
            
            //creds for blob
            string connectionString = $"DefaultEndpointsProtocol=https;AccountName={accountName};AccountKey={accountKey};EndpointSuffix=core.windows.net";
            string containerName = "shamboo";

            if (req.Query.Keys.Count == 0)
            {
                return new BadRequestObjectResult("Please pass a deviceID.");
            }
            req.Query.TryGetValue("device_id", out var deviceID);
            req.Query.TryGetValue("email", out var userEmail);
            req.Query.TryGetValue("password", out var userPassword);
            
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
                    string content = new StreamReader(ms).ReadToEnd();
                    string Body = content.Split("Body\":{")[1].Split('}')[0][0..^0];
                    string[] deviceNameAndDistance = Body.Split(',');
                    string deviceName = deviceNameAndDistance[0].Split("\"device_id\":")[1].TrimStart();
                    if (deviceID[0] == deviceName)
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

