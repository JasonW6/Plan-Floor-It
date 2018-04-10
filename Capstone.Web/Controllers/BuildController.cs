using Capstone.Web.DAL;
using Capstone.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Capstone.Web.Controllers
{
    public class BuildController : Controller
    {
        IMaterialDAL dal;

        public BuildController(IMaterialDAL _dal)
        {
            dal = _dal;
        }

        public List<Material> GetMaterials()
        {
            List<Material> materials = dal.GetAllMaterials();
            return materials;
        }
    }
}