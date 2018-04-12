using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Capstone.Web.Models
{
    public class Room
    {
        public string RoomName { get; set; }
        public bool HasWallPaper { get; set; }
        public int Width { get; set; }
        public int Length { get; set; }
    }
}