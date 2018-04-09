using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Capstone.Web.Models
{
	public class ProjectModel
	{
		public int HouseId { get; set; }
		public Guid UserId { get; set; }
		public string HouseName { get; set; }
		public bool Basement { get; set; }
		public int Floors { get; set; }
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

	}
}