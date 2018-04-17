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
		IFloorDAL fdal;

		public ProjectController(IProjectDAL _dal, IFloorDAL _fdal)
		{
			this.dal = _dal;
			this.fdal = _fdal;
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

			model.UserId = Guid.Parse(User.Identity.GetUserId());
            int houseId = dal.AddNewHouse(model);
			MakeFloors(model.GetFloorCount(), houseId);

            return RedirectToAction("Build", new { houseId = houseId });
        }

        public ActionResult Build(int houseId)
        {
			ProjectModel model = dal.GetProjectByHouseId(houseId);

            return View("Build", model);  
        }

		public ActionResult Dashboard()
		{
			//Return list of user projects
			var result = dal.GetUserProjects(Guid.Parse(User.Identity.GetUserId()));

			return View("Dashboard", result);
		}

		private void MakeFloors(int numberOfFloors, int houseId)
		{
			for(int i = 0; i <= numberOfFloors; i++)
			{
				fdal.CreateFloor(i, houseId);
			}
		}
    }
}