using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PracticaBootCamp.Bussines;

namespace PracticaBootCamp.Controllers
{
    public class SpecialtiesController : Controller
    {
        // GET: Specialty
        public ActionResult Index()
        {
            
            return View();
        }

        public ActionResult Create()
        {
            ViewBag.url = Request.Headers["Referer"].ToString();
            return View();
        }

        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {

                if (ModelState.IsValid)
                {
                    Specialties specialties = new Specialties();
                    specialties.Description = collection["Description"];
                    specialties.Enabled = true;
                    specialties.Save();
                    string url = collection["Url"];
                    return RedirectToAction("Index");
                }
                return View();
            }
            catch
            {
                return View();
            }
           
        }


    }
}