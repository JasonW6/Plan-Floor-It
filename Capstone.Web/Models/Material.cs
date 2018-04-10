using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Capstone.Web.Models
{
    public class Material
    {
        public int MaterialId { get; set; }
        public string Name { get; set; }
        public bool IsMaterial { get; set; }
        public decimal LowPrice { get; set; }
        public decimal MediumPrice { get; set; }
        public decimal HighPrice { get; set; }
        public string ImageSource { get; set; }
    }
}