using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Capstone.Web.Models;
using System.Data.SqlClient;
using System.Configuration;

namespace Capstone.Web.DAL
{
    public class ProjectDAL : IProjectDAL
    {
        private string connectionString;

        private const string SQL_SelectProjectByHouseId = @"SELECT * FROM house WHERE HouseId = @houseId;";
		private const string SQL_AddNewHouse = @"INSERT INTO house (UserId, HouseName, Basement, Floors, Length, Width, SquareFootage, Budget, BaseCost) VALUES (@userId, @houseName, 1, @floors, @length, @width, @squareFootage, @budget, @baseCost);";
		private const string SQL_GetUserProjects = @"SELECT * FROM House WHERE UserId = @userId;";

        public ProjectDAL(string connectionString)
        {
            this.connectionString = connectionString;
        }

		public int AddNewHouse(ProjectModel model)
		{
			try
			{
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();
					SqlCommand cmd = new SqlCommand(SQL_AddNewHouse, conn);
					cmd.Parameters.AddWithValue("@userId", model.UserId);
					cmd.Parameters.AddWithValue("@houseName", model.HouseName);
					cmd.Parameters.AddWithValue("@floors", model.NumberOfFloors);
                    cmd.Parameters.AddWithValue("@length", model.Length);
                    cmd.Parameters.AddWithValue("width", model.Width);
					cmd.Parameters.AddWithValue("@squareFootage", model.SquareFootage);
					cmd.Parameters.AddWithValue("@budget", model.Budget);
                    cmd.Parameters.AddWithValue("@baseCost", model.BaseCost);

					cmd.ExecuteNonQuery();

					cmd = new SqlCommand("SELECT MAX(HouseId) FROM House;", conn);
					int houseId = (int)cmd.ExecuteScalar();
					return houseId;

				}
			}
			catch(SqlException)
			{
				throw;
			}
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

		public List<ProjectModel> GetUserProjects(Guid userId)
		{
			List<ProjectModel> userProjects = new List<ProjectModel>();

			try
			{
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();
					SqlCommand cmd = new SqlCommand(SQL_GetUserProjects, conn);
					cmd.Parameters.AddWithValue("@userId", userId);

					SqlDataReader reader = cmd.ExecuteReader();

					while(reader.Read())
					{
						ProjectModel project = MapProjectFromTable(reader);
						userProjects.Add(project);
					}

				}

			}
			catch(SqlException)
			{
				throw;
			}

			return userProjects;
		}

        public static ProjectModel MapProjectFromTable(SqlDataReader reader)
        {
            ProjectModel project = new ProjectModel
            {
                HouseId = Convert.ToInt32(reader["HouseId"]),
                UserId = new Guid(Convert.ToString(reader["UserId"])),
                HouseName = Convert.ToString(reader["HouseName"]),
                HasBasement = Convert.ToBoolean(reader["Basement"]),
                NumberOfFloors = Convert.ToInt32(reader["Floors"]),
                Length = Convert.ToInt32(reader["Length"]),
                Width = Convert.ToInt32(reader["Width"]),
                SquareFootage = Convert.ToDouble(reader["SquareFootage"]),
                Budget = Convert.ToDecimal(reader["Budget"])
            };

            return project;
        }

        public void DeleteProject(int projectID)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand("DELETE FROM Floor WHERE HouseId = @projectId; DELETE from House WHERE HouseId = @projectId", conn);
                cmd.Parameters.AddWithValue("@projectId", projectID);

                cmd.ExecuteNonQuery();
            }
        }
    }
}