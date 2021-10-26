using System;
using System.Threading;
using System.Threading.Tasks;
using Azure.Messaging.ServiceBus;
using Azure.Identity;
using Microsoft.Extensions.Options;
using System.Text.Json;

namespace batchdemo.queue_processor
{
    class Program
    {
        static async Task Main(string[] args)
        {
            string QUEUE_NAME = System.Environment.GetEnvironmentVariable("QUEUE_NAME"); //batchjob
            string SERVICE_BUS = $"{System.Environment.GetEnvironmentVariable("SERVICE_BUS")}.servicebus.windows.net";
            string userAssignedClientId = System.Environment.GetEnvironmentVariable("MSI_CLIENT_ID");

            Console.WriteLine($"Connecting to {SERVICE_BUS}/{QUEUE_NAME}");

            var credential = new DefaultAzureCredential(new DefaultAzureCredentialOptions { ManagedIdentityClientId = userAssignedClientId })
            await using var client = new ServiceBusClient(SERVICE_BUS, credential);

            var receiver = client.CreateReceiver(QUEUE_NAME);
            
            Console.WriteLine($"Waiting on new messages");
            var receivedMessage = await receiver.ReceiveMessageAsync();

            var msg = JsonSerializer.Deserialize<Message>(receivedMessage.Body.ToString());

            Console.WriteLine($"Processing - {msg.message.file}");
            await receiver.CompleteMessageAsync(receivedMessage);
        }
    }

    public class Message {
        public FilePath message { get; set; }
    }

    public class FilePath {
        public string file { get; set; }
    }

}
