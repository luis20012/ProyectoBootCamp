using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PracticaBootCamp.Bussines;

namespace PracticaBootCamp.Controllers
{
    public class QualificationController : Controller
    {
        List<SelectListItem> studentCourse = new List<SelectListItem>();
        public void llenarList()
        {
            studentCourse = new List<SelectListItem>();
            List<StudentCourse> courses = StudentCourse.Dao.GetByFilter(new
            {
                Code = "Active"
            }).ToList();
            foreach (var item in courses)
            {
                studentCourse.Add(new SelectListItem
                {
                    Text = item.Course.ToString(),
                    Value = item.Id.ToString()
                });
            }
            studentCourse.Insert(0, new SelectListItem { Text = "-----Seleccione---", Value = " " });
            ViewBag.studentCourse = studentCourse;
        }


        // GET: Qualification
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Create()
        {
            llenarList();
            ViewBag.studentCourse = studentCourse;
            ViewBag.url = Request.Headers["Referer"].ToString();
            return View();
        }

        [HttpPost]
        //[AccessCode("QualificationCreate")]
        //[Authenticated]
        public ActionResult Create(FormCollection collection)
        {
            ViewBag.studentCourse = studentCourse;
            try
            {
                if (ModelState.IsValid)
                {
                    //bool LessonExints = Lesson.Dao.GetAll().Any(l => l.Title.ToLower() == collection["Title"].ToLower());

                    //if (!LessonExints)
                    //{
                    Qualification qualification = new Qualification();
                    qualification.Qualy = collection["URL"];
                    qualification.LastModification = DateTime.Now;
                    qualification.StudentCourse = new StudentCourse { Id = long.Parse(collection["StudentCourset_Id"]) };
                    qualification.Save();
                    string url = collection["url"].ToString();
                    return RedirectToAction("Index", "Lesson");
                    //}
                    //else
                    //{
                    //    llenarList();
                    //    ViewBag.alert = "Ya existe un video con ese titulo";
                    //    ViewBag.courseList = lessonCourses;
                    //    ViewBag.url = Request.Headers["Referer"].ToString();
                    //    return View();
                    //}



                }
                llenarList();
                ViewBag.studentCourse = studentCourse;
                ViewBag.url = Request.Headers["Referer"].ToString();
                return View();
            }
            catch
            {
                return View();
            }


        }
    }
}