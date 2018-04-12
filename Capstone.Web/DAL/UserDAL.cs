using Capstone.Web.Authentication;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Identity;
using System.Security.Principal;
using System.Configuration;

namespace Capstone.Web.DAL
{
    public class UserDAL
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        private string getNameQuery = "SELECT Name FROM Users WHERE UserId = @userId;";

        public string GetFirstName(string userId)
        {
            string firstName = "";
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(getNameQuery, conn);
                    cmd.Parameters.AddWithValue("@userId", userId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        firstName = Convert.ToString(reader["Name"]);
                    }
                }

            }
            catch (SqlException)
            {
                throw;
            }

            return firstName;
        }
    }
}