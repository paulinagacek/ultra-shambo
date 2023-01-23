using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Linq;
using System.Collections.Generic;
using System.Net.Http;
using System.IO;
using System.Text.Json;

namespace GetLastAddedBlob
{
    public static class GetLastAddedDistance
    {
        [FunctionName("GetLastAddedDistance")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            //creds for connection
            //string accountName = "databaseshamboo";
            //string accountKey = "nY4AF++rbHrDT4yQ/XUsFdytvUJUBxNN+4rpeZ6RB8YbjjjhaaKvgM8dDyzuJYk7xY+6tEIXkefw+AStF9RmMA==";

            string MEASUREMENTS_SAS = "?sp=raud&st=2023-01-21T14:13:03Z&se=2023-02-22T14:13:00Z&sv=2021-06-08&sig=bP3yZEp6Cdd2nq5E10mtFPTznzCJRq%2Bk1mRvtxaVpXk%3D&tn=measurements";
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            RequestBody data = JsonSerializer.Deserialize<RequestBody>(requestBody);

            // check whether query string is valid
            // req.Query.TryGetValue("device_id", out var deviceID);
            // req.Query.TryGetValue("email", out var userEmail);
            // req.Query.TryGetValue("password", out var userPassword);

            if (data.Email == "" || data.Password == "" || data.DeviceId == "")

            {
                return new BadRequestObjectResult(-1);
            }

            try
            {
                using HttpClient httpClient = new();

                //check if user can read this measurement
                using HttpResponseMessage idResponse = await httpClient.GetAsync($"https://shamboo-backend.azure-api.net/tableService/deviceId?email={data.Email}&password={data.Password}");
                idResponse.EnsureSuccessStatusCode();
                string fetchedDeviceID = await idResponse.Content.ReadAsStringAsync();

                if (fetchedDeviceID != data.DeviceId)
                {
                    return new BadRequestObjectResult(-1);
                }

                //get last added measurement
                httpClient.DefaultRequestHeaders.Add("DataServiceVersion", "3.0");
                httpClient.DefaultRequestHeaders.Add("MaxDataServiceVersion", "3.0");
                httpClient.DefaultRequestHeaders.Add("Accept", "application/json;odata=nometadata");
                httpClient.DefaultRequestHeaders.Add("Accept-Charset", "UTF-8");

                using HttpResponseMessage distancesResponse = await httpClient.GetAsync($"https://databaseshamboo.table.core.windows.net/measurements{MEASUREMENTS_SAS}&$filter=device_id%20eq%20'{data.DeviceId}'&$select=distance,Timestamp");
                distancesResponse.EnsureSuccessStatusCode();
                string distances = await distancesResponse.Content.ReadAsStringAsync();

                Response response = System.Text.Json.JsonSerializer.Deserialize<Response>(distances);
                var lastAddedDistance = response.value.OrderByDescending(x => x.Timestamp).First().distance;
                return new OkObjectResult(lastAddedDistance);
            }

            catch (HttpRequestException e)
            {
                return new BadRequestObjectResult(-1);
            }

        }
    }

    public class RequestBody
    {
        public string Email { get; set; } = "";
        public string Password { get; set; } = "";
        public string DeviceId { get; set; } = "";
    }


    public class Response
    {
        public List<Value> value { get; set; }
    }

    public class Value
    {
        public DateTime Timestamp { get; set; }

        public double distance { get; set; }
    }

}

