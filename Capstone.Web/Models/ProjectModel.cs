using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Capstone.Web.Models;

namespace Capstone.Web.Models
{
    public class ProjectModel
    {
        public int HouseId { get; set; }
        public Guid UserId { get; set; }
        public string HouseName { get; set; }
        public bool HasBasement { get; set; }
        public int NumberOfFloors { get; set; }
        public List<FloorModel> ListOfFloors { get; set; }
        public double Length { get; set; }
        public double Width { get; set; }
        public double SquareFootage
        {
            get
            {
                return Length * Width;
            }
            set { }
        }
        public string Region { get; set; }
        public decimal Budget { get; set; }

        public decimal BaseCost
        {
            get
            {
                return (decimal)(Length * Width) * NumberOfFloors;
            }
            set { }
        }

        public int GetFloorCount()
        {
            int count = NumberOfFloors;
            return count++;
        }
    }
}