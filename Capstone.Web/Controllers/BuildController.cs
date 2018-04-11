﻿using Capstone.Web.DAL;
using Capstone.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;


namespace Capstone.Web.Controllers
{
    public class BuildController : ApiController
    {
        IMaterialDAL dal;
		IFloorDAL fdal;

        public BuildController(IMaterialDAL _dal, IFloorDAL _fdal)
        {
            dal = _dal;
			fdal = _fdal;
        }

        [HttpGet]
        [Route("api/materials")]
        public IHttpActionResult GetMaterials()
        {
            List<Material> materials = dal.GetAllMaterials();
            return Ok(materials);
        }

		[HttpGet]
		[Route("api/floors")]
		public IHttpActionResult GetFloors(int houseId)
		{
			List<FloorModel> floors = fdal.GetFloorsByHouseId(houseId);
			return Ok(floors);
		}
		
    }
}