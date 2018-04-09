using Capstone.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Capstone.Web.DAL;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;


namespace Capstone.Web.Controllers
{
    public class ProjectController : Controller
    {

		IProjectDAL dal;

		public ProjectController(IProjectDAL dal)
		{
			this.dal = dal;
		}

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

			model.UserId = Guid.Parse(User.Identity.GetUserId());


            int id = dal.AddNewHouse(model);

            return RedirectToAction("Build", new { houseId = id });
        }

        public ActionResult Build(int houseId)
        {
			ProjectModel model = dal.GetProjectByHouseId(houseId);

            return View("Build", model);  
        }

    }
}