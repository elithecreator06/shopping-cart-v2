using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;

namespace ShoppingCartV2
{
    internal static class AzureSqlBootstrapper
    {
        private const string BootstrapLock = "ShoppingCartV2-AzureSqlBootstrap";

        internal static void EnsureCreated()
        {
            ConnectionStringSettings setting = ConfigurationManager.ConnectionStrings["StoreDbBootstrap"];
            if (setting == null || String.IsNullOrWhiteSpace(setting.ConnectionString))
            {
                return;
            }

            string scriptPath = HttpContext.Current.Server.MapPath("~/App_Data/AzureSqlBootstrap.sql");
            if (!File.Exists(scriptPath))
            {
                return;
            }

            try
            {
                using (SqlConnection connection = new SqlConnection(setting.ConnectionString))
                {
                    connection.Open();
                    using (SqlTransaction transaction = connection.BeginTransaction())
                    {
                        Execute(connection, transaction, "EXEC sp_getapplock @Resource = @resource, @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 60000;", BootstrapLock);

                        if (TableExists(connection, transaction, "Products"))
                        {
                            transaction.Commit();
                            return;
                        }

                        string[] batches = Regex.Split(File.ReadAllText(scriptPath), @"^\s*GO\s*$", RegexOptions.Multiline | RegexOptions.IgnoreCase);
                        foreach (string batch in batches)
                        {
                            if (!String.IsNullOrWhiteSpace(batch))
                            {
                                Execute(connection, transaction, batch);
                            }
                        }

                        transaction.Commit();
                    }
                }
            }
            catch (SqlException)
            {
                // The storefront can still serve its public landing page while Azure SQL is unavailable.
            }
        }

        private static bool TableExists(SqlConnection connection, SqlTransaction transaction, string tableName)
        {
            using (SqlCommand command = new SqlCommand("SELECT OBJECT_ID(N'[dbo].[" + tableName + "]', N'U')", connection, transaction))
            {
                return command.ExecuteScalar() != DBNull.Value;
            }
        }

        private static void Execute(SqlConnection connection, SqlTransaction transaction, string sql, string resource = null)
        {
            using (SqlCommand command = new SqlCommand(sql, connection, transaction))
            {
                command.CommandTimeout = 120;
                if (resource != null)
                {
                    command.Parameters.AddWithValue("@resource", resource);
                }
                command.ExecuteNonQuery();
            }
        }
    }
}
