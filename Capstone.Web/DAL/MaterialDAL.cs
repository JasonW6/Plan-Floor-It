using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Capstone.Web.Models;
using System.Data.SqlClient;
using System.Configuration;

namespace Capstone.Web.DAL
{
    public class MaterialDAL : IMaterialDAL
    {
        private string connectionString;
        private const string getMaterialsQuery = "SELECT * FROM Materials";

        public MaterialDAL(string connectionString)
        {
            this.connectionString = connectionString;
        }

        public List<Material> GetAllMaterials()
        {
            List<Material> materials = new List<Material>();
            try
            {
                using(SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(getMaterialsQuery, conn);
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        Material material = MapMaterialFromTable(reader);
                        materials.Add(material);
                    }
                }
            }
            catch(SqlException)
            {
                throw;
            }

            return materials;
        }

        private Material MapMaterialFromTable(SqlDataReader reader)
        {
            Material material = new Material
            {
                MaterialId = Convert.ToInt32(reader["MaterialId"]),
                Name = Convert.ToString(reader["Material_Type_Item"]),
                IsMaterial = Convert.ToBoolean(reader["IsMaterial"]),
                LowPrice = Convert.ToDecimal(reader["LowPrice"]),
                MediumPrice = Convert.ToDecimal(reader["MidPrice"]),
                HighPrice = Convert.ToDecimal(reader["HighPrice"]),
                ImageSource = Convert.ToString(reader["ImageSource"])
            };
            return material;
        } 
    }
}