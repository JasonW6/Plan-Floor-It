using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Capstone.Web.Models;
using System.Data.SqlClient;

namespace Capstone.Web.DAL
{
	public class FloorDAL : IFloorDAL
	{
		private string connectionString;
		private const string SQL_GetFloorsByHouseId = @"SELECT * FROM Floor where HouseId = @houseId;";

		public FloorDAL(string connectionString)
		{
			this.connectionString = connectionString;
		}

		public List<FloorModel> GetFloorsByHouseId(int houseId)
		{
			List<FloorModel> houseFloors = new List<FloorModel>();

			try
			{
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();

					SqlCommand cmd = new SqlCommand(SQL_GetFloorsByHouseId, conn);
					cmd.Parameters.AddWithValue("@houseId", houseId);

					SqlDataReader reader = cmd.ExecuteReader();
					while (reader.Read())
					{
						FloorModel floor = new FloorModel();
						floor.FloorId = Convert.ToInt32(reader["FloorId"]);
						floor.HouseId = Convert.ToInt32(reader["HouseId"]);
						floor.FloorNumber = Convert.ToInt32(reader["FloorNumber"]);
						floor.FloorPlan = Convert.ToString(reader["FloorPlan"]);
						houseFloors.Add(floor);
					}
				}

			}
			catch(SqlException)
			{
				throw;
			}

			return houseFloors;

		}
	}
}