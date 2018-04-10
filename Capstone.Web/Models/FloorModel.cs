using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Capstone.Web.Models
{
    public class FloorModel
    {
        public int FloorId { get; set; }
        public int HouseId { get; set; }
        public int FloorNumber { get; set; }
        public string FloorPlan { get; set; }

        public string FloorName
        {
            get
            {
                if (FloorId == 0)
                {
                    return "Basement";
                }

                return "Floor " + FloorId;
            }
        }
    }
}