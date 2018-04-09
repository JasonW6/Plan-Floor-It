using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Capstone.Web.Models;
using System.Data.SqlClient;
using System.Configuration;

namespace Capstone.Web.DAL
{
    public class ProjectDAL
    {
        private string connectionString;

        private const string SQL_SelectProjectByHouseId = @"SELECT * FROM house WHERE HouseId = @houseId;";

        public ProjectDAL(string connectionString)
        {
            this.connectionString = connectionString;
        }

        public ProjectModel GetProjectByHouseId(int houseId)
        {
            ProjectModel project = null;

            try
            {
                using(SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(SQL_SelectProjectByHouseId, conn);
                    cmd.Parameters.AddWithValue("@houseId", houseId);

                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                       project = MapProjectFromTable(reader);
                    }

                    return project;
                }
            }
            catch (SqlException)
            {
                throw;
            }
        }

        private static ProjectModel MapProjectFromTable(SqlDataReader reader)
        {
            ProjectModel project = null;
            project.HouseId = Convert.ToInt32(reader["HouseId"]);
            project.UserId = Convert.ToInt32(reader["UserId"]);
            project.HouseName = Convert.ToString(reader["HouseName"]);
            project.Basement = Convert.ToBoolean(reader["Basement"]);
            project.Floors = Convert.ToInt32(reader["Floors"]);
            project.SquareFootage = Convert.ToDouble(reader["SquareFootage"]);
            project.Region = Convert.ToString(reader["Region"]);
            project.Budget = Convert.ToDecimal(reader["Budget"]);

            return project;
        }
    }
}