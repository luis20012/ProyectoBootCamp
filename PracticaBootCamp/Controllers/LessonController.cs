using System;
using System.Collections.Generic;
using System.EnterpriseServices.CompensatingResourceManager;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DevExpress.XtraSpreadsheet.Model;
using DNF.Entity;
using DNF.Security.Bussines;
using iTextSharp.text;
using java.awt;
using org.omg.CosNaming.NamingContextExtPackage;
using PracticaBootCamp.Bussines;

namespace PracticaBootCamp.Controllers
{
    public class LessonController : Controller
    {
        // GET: Lesson
        [AccessCode("Lesson")]
        [Authenticated]
        public ActionResult Index()
        {
            ViewBag.Title = "Lesson";
            ViewBag.Edit = Current.User.HasAccess("LessonEdit");
            ViewBag.New = Current.User.HasAccess("LessonCreate");
            ViewBag.Delete = Current.User.HasAccess("LessonDelete");
            ViewBag.Details = Current.User.HasAccess("LessonDetails");

            llenarList();
            ViewBag.lessonCourses = lessonCourses;
            List<Lesson> list = null;
            list = Lesson.Dao.GetByFilter(new
            {
                
                Enabled = true

            });
            list.LoadRelationList(x => x.LessonCourses);
            foreach (var item in list)
            {
                item.LessonCourses.LoadRelation(x => x.Course);
                item.LessonCourses.LoadRelation(x => x.Lesson);
            }
            return View(list);
        }

        [HttpPost]
        [AccessCode("Lesson")]
        [Authenticated]
        public ActionResult Index(Lesson lesson)
        {
            llenarList();
            ViewBag.lessonCourses = lessonCourses;
            string title = lesson.Title;
            // Convert to lowercase for case-insensitive comparison
            string enabled = lesson.Enabled.ToString().ToLower();
            List<Lesson> list = null;
            // Modify the filter to only consider Enabled = true if the user doesn't explicitly filter by it
            if (string.IsNullOrEmpty(enabled) || enabled == "true")
            {
                list = Lesson.Dao.GetByIndexFilter(title, "true");
            }
            else
            {
                list = Lesson.Dao.GetByIndexFilter(title, enabled);
            }
            list.LoadRelationList(x => x.LessonCourses);
            foreach (var item in list)
            {
                item.LessonCourses.LoadRelation(x => x.Lesson);
                item.LessonCourses.LoadRelation(x => x.Course);
            }
         
            return View(list);
       
        }

        [AccessCode("LessonCreate")]
        [Authenticated]
        public ActionResult Create()
        {
            llenarList();
            ViewBag.lessonCourses = lessonCourses;
            ViewBag.url = Request.Headers["Referer"].ToString();
            return View();
        }

        [HttpPost]
        [AccessCode("LessonCreate")]
        [Authenticated]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    bool LessonExints = Lesson.Dao.GetAll().Any(l => l.Title.ToLower() == collection["Title"].ToLower());

                    if (!LessonExints)
                    {
                        Lesson lesson = new Lesson();
                        lesson.Title = collection["Title"];
                        lesson.Description = collection["Description"];
                        lesson.Url = collection["URL"];
                        lesson.Enabled = true;
                        lesson.Save();
                        string url = collection["url"].ToString();
                        return RedirectToAction("Index", "Lesson");
                    }
                    else
                    {
                        llenarList();
                        ViewBag.alert = "Ya existe un video con ese titulo";
                        ViewBag.courseList = lessonCourses;
                        ViewBag.url = Request.Headers["Referer"].ToString();
                        return View();
                    }



                }
                llenarList();
                ViewBag.courseList = lessonCourses;
                ViewBag.url = Request.Headers["Referer"].ToString();
                return View();
            }
            catch
            {
                return View();
            }


        }
        [AccessCode("LessonDelete")]
        [Authenticated]
        public ActionResult Delete(int Id)
        {
            try
            {
                Lesson lesson = Lesson.Dao.Get(Id);
                foreach (var item in lesson.LessonCourses)
                {
                    item.Delete();
                }
            
                lesson.Delete();
                lesson.Save(); // Don't forget to save the changes to the lesson
                return RedirectToAction("Index", "Lesson");
            }
            catch
            {
                return View();
            }
        }
        [AccessCode("LessonDetails")]
        [Authenticated]
        public ActionResult Details(int id)
        {
            llenarList();
            ViewBag.lessonCourses = lessonCourses;
            List<Lesson> list = new List<Lesson>();
            Lesson lesson = Lesson.Dao.Get(id);
            list.Add(lesson);
            list.LoadRelationList(x => x.LessonCourses);
            foreach (var item in list)
            {
                item.LessonCourses.LoadRelation(x => x.Course);
                item.LessonCourses.LoadRelation(x => x.Lesson);
            }
            return View(list[0]);
        }





        List<SelectListItem> lessonCourses = new List<SelectListItem>();
        public void llenarList()
        {
            lessonCourses = new List<SelectListItem>();
            List<LessonCourse> courses = LessonCourse.Dao.GetByFilter(new
            {
                Enabled = true
            }).ToList();
            foreach (var item in courses)
            {
                lessonCourses.Add(new SelectListItem
                {
                    Text = item.Course.ToString(),
                    Value = item.Id.ToString()
                });
            }
            lessonCourses.Insert(0, new SelectListItem { Text = "-----Seleccione---", Value = " " });

        }
        [AccessCode("LessonEdit")]
        [Authenticated]
        public ActionResult Edit(int id)
        {
            llenarList();
            ViewBag.lessonCourses = lessonCourses;
            List<Lesson> list = new List<Lesson>();
            Lesson lesson = Lesson.Dao.Get(id);
            list.Add(lesson);
            list.LoadRelationList(x => x.LessonCourses);

            return View(list[0]);
        }

        // POST: Course/Edit/5
        [HttpPost]
        [AccessCode("LessonEdit")]
        [Authenticated]
        public ActionResult Edit(int id, FormCollection collection)
        {
            llenarList();
            ViewBag.lessonCourses = lessonCourses;
            try
            {
                Lesson lesson = Lesson.Dao.Get(id);
                if (ModelState.IsValid)
                {
                    if ((collection["Title"] == lesson.Title))
                    {
                        lesson.Title = collection["Title"];
                        lesson.Description = collection["Description"];
                        lesson.Url = collection["Url"];
                        lesson.Save();
                        return RedirectToAction("Index");

                    }
                    ViewBag.AlertDuplicateArtistName = "Ya hay un video con ese name";
                    llenarList();
                    llenarList();
                    ViewBag.lessonCourses = lessonCourses;
                    return View(lesson);
                }

                llenarList();
                ViewBag.lessonCourses = lessonCourses;

                return RedirectToAction("Index");
            }
            catch
            {
                llenarList();
                ViewBag.lessonCourses = lessonCourses;

                return RedirectToAction("Index");
            }
        }

    }
}