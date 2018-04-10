﻿using System;
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
		private const string SQL_AddNewHouse = @"INSERT INTO house (UserId, HouseName, Basement, Floors, SquareFootage, Region, Budget) VALUES (@userId, @houseName, @basement, @floors, @squareFootage, @region, @budget);";

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
					cmd.Parameters.AddWithValue("@basement", model.HasBasement);
					cmd.Parameters.AddWithValue("@floors", model.NumberOfFloors);
					cmd.Parameters.AddWithValue("@squareFootage", model.SquareFootage);
					cmd.Parameters.AddWithValue("@region", model.Region);
					cmd.Parameters.AddWithValue("@budget", model.Budget);

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

        public static ProjectModel MapProjectFromTable(SqlDataReader reader)
        {
            ProjectModel project = new ProjectModel
            {
                HouseId = Convert.ToInt32(reader["HouseId"]),
                UserId = new Guid(Convert.ToString(reader["UserId"])),
                HouseName = Convert.ToString(reader["HouseName"]),
                Basement = Convert.ToBoolean(reader["Basement"]),
                Floors = Convert.ToInt32(reader["Floors"]),
                SquareFootage = Convert.ToDouble(reader["SquareFootage"]),
                Region = Convert.ToString(reader["Region"]),
                Budget = Convert.ToDecimal(reader["Budget"])
            };

            return project;
        }
    }
}