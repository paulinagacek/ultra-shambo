using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Text.Json;
using System.Net.Http;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;

namespace SendNewDistance
{
    public static class Function
    {
        [FunctionName("SendDistance")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            string USERS_SAS = "?sp=raud&st=2023-01-06T10:15:38Z&se=2023-02-07T10:15:00Z&spr=https&sv=2021-06-08&sig=AcltWqm8TCa%2Bre%2B8LUxZX9O%2FR%2BJTIzcVIvRYKc2%2BGeU%3D&tn=users";
            string MEASUREMENTS_SAS = "?sp=raud&st=2023-01-21T14:13:03Z&se=2023-02-22T14:13:00Z&sv=2021-06-08&sig=bP3yZEp6Cdd2nq5E10mtFPTznzCJRq%2Bk1mRvtxaVpXk%3D&tn=measurements";

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();

            try
            {
                ESP_DATA data = JsonSerializer.Deserialize<ESP_DATA>(requestBody);

                using HttpClient httpClient = new();

                httpClient.DefaultRequestHeaders.Add("DataServiceVersion", "3.0");
                httpClient.DefaultRequestHeaders.Add("MaxDataServiceVersion", "3.0");
                httpClient.DefaultRequestHeaders.Add("Accept", "application/json;odata=nometadata");
                httpClient.DefaultRequestHeaders.Add("Accept-Charset", "UTF-8");

                using HttpResponseMessage isDevicePairedResponse = await httpClient.GetAsync($"https://databaseshamboo.table.core.windows.net/users{USERS_SAS}&$filter=deviceID%20eq%20'{data.device_id}'&$select=RowKey");
                isDevicePairedResponse.EnsureSuccessStatusCode();
                string pairedWith = await isDevicePairedResponse.Content.ReadAsStringAsync();
                UserResponse response = JsonSerializer.Deserialize<UserResponse>(pairedWith);

                if (response.value.Count == 0)
                {
                    return new BadRequestObjectResult(-1);
                }

                using HttpResponseMessage RowKeysResponse = await httpClient.GetAsync($"https://databaseshamboo.table.core.windows.net/measurements{MEASUREMENTS_SAS}&$select=RowKey,Timestamp, device_id");
                RowKeysResponse.EnsureSuccessStatusCode();
                string RowKeys = await RowKeysResponse.Content.ReadAsStringAsync();
                RowKeysResponse rowKeys = JsonSerializer.Deserialize<RowKeysResponse>(RowKeys);
                if (!int.TryParse(rowKeys.value.OrderByDescending(x => int.Parse(x.RowKey)).First().RowKey, out int nextFreeRowkey))
                {
                    return new BadRequestObjectResult(-1);
                }

                var lastAddedMessageTime = rowKeys.value
                    .Where(x => x.device_id == data.device_id)
                    .OrderByDescending(x => x.Timestamp)
                    .First()
                    .Timestamp;
                
                if (lastAddedMessageTime > DateTime.Now.AddSeconds(-10))
                {
                    return new BadRequestObjectResult("Sending too fast");
                }
                    nextFreeRowkey += 1;
                    var rebuildedBody = new RebuildedBody()
                    {
                        RowKey = nextFreeRowkey.ToString(),
                        PartitionKey = "measurement",
                        device_id = data.device_id,
                        distance = data.distance,
                    };

                var body = new StringContent(JsonSerializer.Serialize(rebuildedBody));
                body.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/json");
                var finalResponse = await httpClient.PostAsync($"https://databaseshamboo.table.core.windows.net/measurements{MEASUREMENTS_SAS}", body);
                finalResponse.EnsureSuccessStatusCode();
            }

            catch (Exception e)
            {
                return new BadRequestObjectResult(-1);
            }

            return new OkObjectResult("created");
        }
    }


    public class ESP_DATA
    {
        public string device_id { get; set; }
        public double distance { get; set; }

    }

    public class UserResponse
    {
        public List<UserValue> value { get; set; }
    }

    public class UserValue
    {
        public string RowKey { get; set; }
    }

    public class RowKeysResponse
    {
        public List<RowKey_> value { get; set; }
    }

    public class RowKey_
    {
        public string RowKey { get; set; }
        public DateTime Timestamp { get; set; }
        public string device_id { get; set; }
    }

    public class RebuildedBody
    {
        public string RowKey { get; set; }   
        public string PartitionKey { get; set; }   
        public string device_id { get; set; }
        public double distance { get; set; }
    }

}
