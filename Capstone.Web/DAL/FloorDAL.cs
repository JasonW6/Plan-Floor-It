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
		private const string SQL_InsertFloor = @"INSERT INTO Floor VALUES (@houseId, @floorNo, null);";
		private const string SQL_UpdateFloorPlan = @"UPDATE Floor SET FloorPlan = @json WHERE FloorId = @floorId;";

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
						FloorModel floor = new FloorModel
						{
							FloorId = Convert.ToInt32(reader["FloorId"]),
							HouseId = Convert.ToInt32(reader["HouseId"]),
							FloorNumber = Convert.ToInt32(reader["FloorNumber"]),
							FloorPlan = Convert.ToString(reader["FloorPlan"])
						};

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

		public bool CreateFloor(int floorNumber, int houseId)
		{
			try
			{
				using(SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();

					SqlCommand cmd = new SqlCommand(SQL_InsertFloor, conn);
					cmd.Parameters.AddWithValue("@houseId", houseId);
					cmd.Parameters.AddWithValue("@floorNo", floorNumber);

					cmd.ExecuteNonQuery();

					return true;
				}

			}
			catch(SqlException)
			{
				return false;
			}
		}

		public bool UpdateFloorPlan(int floorId, string json)
		{
			try
			{
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					conn.Open();

					SqlCommand cmd = new SqlCommand(SQL_UpdateFloorPlan, conn);
					cmd.Parameters.AddWithValue("@floorId", floorId);
					cmd.Parameters.AddWithValue("@json", json);
					cmd.ExecuteNonQuery();
				}
			}
			catch(SqlException)
			{
				return false;
			}

			return true;
		}
	}


}