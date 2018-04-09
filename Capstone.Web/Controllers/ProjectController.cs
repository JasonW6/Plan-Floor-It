using Capstone.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;


namespace Capstone.Web.Controllers
{
    public class ProjectController : Controller
    {
        // GET: Project

        [HttpGet]
        public ActionResult NewProject()
        {
            return View();
        }

        [HttpPost]
        public ActionResult NewProject(ProjectModel model)
        {
            //dal - inset Model into database

            return RedirectToAction("Build", new { houseId = model.HouseId });
        }

        public ActionResult Build(int houseId)
        {
            //dal - find house by house id
            //create project model with house

            ProjectModel model = new ProjectModel();

            return View("Build", model);  
        }

    }
}