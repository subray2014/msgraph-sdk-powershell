using Microsoft.Graph.PowerShell.Authentication.Interfaces;
using Newtonsoft.Json;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;

namespace Microsoft.Graph.PowerShell.Authentication.Common
{
    internal class DependencySettings
    {
        public IDictionary<string, Version> SharedDependencies { get; set; } = new ConcurrentDictionary<string, Version>(StringComparer.CurrentCultureIgnoreCase);
        public IList<string> MultiFrameworkDependencies { get; set; } = new List<string>();

        public DependencySettings()
        {
            // OnImport: Read dependencies from file.
            // TODO: Dynamically read "C:\Dev\MicrosoftGraph\msgraph-sdk-powershell\src\Authentication\Authentication\Dependencies.json".
            string path = "C:\\Dev\\MicrosoftGraph\\msgraph-sdk-powershell\\src\\Authentication\\Authentication\\Dependencies.json";
            //using (var fileProvider = ProtectedFileProvider.CreateFileProvider(path, FileProtection.SharedRead))
            //{
            //    string contents = fileProvider.CreateReader().ReadToEnd();
            //    var dependencySettings = JsonConvert.DeserializeObject<DependencySettings>(contents);
            //    //SharedDependencies = dependencySettings.SharedDependencies;
            //    MultiFrameworkDependencies = dependencySettings.MultiFrameworkDependencies;
            //}

            var serializer = new JsonSerializer();
            using (StreamReader sr = new StreamReader(path))
            using (JsonReader reader = new JsonTextReader(sr))
            {
                var dependencySettings = serializer.Deserialize<DependencySettings>(reader);
                MultiFrameworkDependencies = dependencySettings.MultiFrameworkDependencies;
            }
        }


        internal T DeserializeObject<T>(string serialization, JsonConverter converter = null)
        {
            try
            {
                return converter == null ? JsonConvert.DeserializeObject<T>(serialization) : JsonConvert.DeserializeObject<T>(serialization, converter);
            }
            catch (JsonException)
            {
                throw;
            }
        }
    }
}
