using System;
using System.Configuration;
using System.Data.EntityClient;

namespace ShoppingCartV2
{
    internal static class AzureSqlConnectionStrings
    {
        internal static string For(string localConnectionName, string modelName)
        {
            ConnectionStringSettings setting = ConfigurationManager.ConnectionStrings["StoreDbBootstrap"];
            if (setting == null || setting.ConnectionString.IndexOf("(LocalDB)", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                return "name=" + localConnectionName;
            }

            EntityConnectionStringBuilder builder = new EntityConnectionStringBuilder
            {
                Metadata = "res://*/Models." + modelName + ".csdl|res://*/Models." + modelName + ".ssdl|res://*/Models." + modelName + ".msl",
                Provider = "System.Data.SqlClient",
                ProviderConnectionString = setting.ConnectionString
            };

            return builder.ConnectionString;
        }
    }
}
