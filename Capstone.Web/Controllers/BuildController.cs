using Capstone.Web.DAL;
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

        public BuildController(IMaterialDAL _dal)
        {
            dal = _dal;
        }

        [HttpGet]
        [Route("api/materials")]
        public IHttpActionResult GetMaterials()
        {
            List<Material> materials = dal.GetAllMaterials();
            return Ok(materials);
        }
    }
}