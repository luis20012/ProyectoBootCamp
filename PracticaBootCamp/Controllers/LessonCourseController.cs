using System;
using System.Collections.Generic;
using System.EnterpriseServices.CompensatingResourceManager;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using com.sun.org.apache.bcel.@internal.classfile;
using DNF.Entity;
using DNF.Security.Bussines;
using PracticaBootCamp.Bussines;

namespace PracticaBootCamp.Controllers
{
    public class LessonCourseController : Controller
    {
        [AccessCode("LessonCourse")]
        [Authenticated]
        public ActionResult Index()
        {
            ViewBag.Title = "VideosCursos";
            //ViewBag.Edit = Current.User.HasAccess("CourseEdit");
            ViewBag.New = Current.User.HasAccess("LessonCourseCreate");
            //ViewBag.Delete = Current.User.HasAccess("CourseDelete");

            return View();
        }
        [AccessCode("LessonCourseCreate")]
        [Authenticated]
        public ActionResult Create()
        {
            ViewBag.Title = "VideosCursos";
            //ViewBag.Edit = Current.User.HasAccess("CourseEdit");
            ViewBag.New = Current.User.HasAccess("LessonCourseCreate");
            //ViewBag.Delete = Current.User.HasAccess("CourseDelete");
            llenarList();
            ViewBag.lessonList = lessonList;
            ViewBag.courseList = courseList;
            ViewBag.lessonUrlList = lessonUrlList;

            return View();
        }

        [HttpPost]
        [AccessCode("LessonCourseCreate")]
        [Authenticated]
        public ActionResult Create(FormCollection collection)
        {
            ViewBag.Title = "VideosCursos";
            //ViewBag.Edit = Current.User.HasAccess("CourseEdit");
            ViewBag.New = Current.User.HasAccess("LessonCourseCreate");
            //ViewBag.Delete = Current.User.HasAccess("CourseDelete");
            try
            {
                if (ModelState.IsValid)
                {
                    bool LessonUrl = LessonCourse.Dao.GetAll().Any(x => x.Lesson.Id == long.Parse(collection["Lesson"]) && x.Course.Id == long.Parse(collection["Course"]));

                    if (!LessonUrl)
                    {
                        LessonCourse lessonCourse = new LessonCourse();
                        lessonCourse.Lesson = new Lesson { Id = long.Parse(collection["Lesson"]) };
                        lessonCourse.Course = new Course { Id = long.Parse(collection["Course"]) };
                        lessonCourse.Save();
                        return RedirectToAction("Create", "LessonCourse");
                    }
                    else
                    {
                        llenarList();
                        ViewBag.Alert = "Este video ya esta asignado a este curso";
                        ViewBag.lessonList = lessonList;
                        ViewBag.courseList = courseList;
                        ViewBag.lessonUrlList = lessonUrlList;
                        return View();
                    }
                    
                   


                }
                llenarList();
                ViewBag.lessonList = lessonList;
                ViewBag.courseList = courseList;
                ViewBag.lessonUrlList = lessonUrlList;
                return View();
            }
            catch
            {
                llenarList();
                ViewBag.lessonList = lessonList;
                ViewBag.courseList = courseList;
                ViewBag.lessonUrlList = lessonUrlList;
                return View();
            }
        }

        List<SelectListItem> lessonList = new List<SelectListItem>();
        List<SelectListItem> lessonUrlList = new List<SelectListItem>();
        List<SelectListItem> courseList = new List<SelectListItem>();
        List<SelectListItem> teacherList = new List<SelectListItem>();
        public void llenarList()
        {
            teacherList = new List<SelectListItem>();
            lessonList = new List<SelectListItem>();
            lessonUrlList = new List<SelectListItem>();
            courseList = new List<SelectListItem>();
            List<Course> course = Course.Dao.GetByFilter(new
            {
                StateCourse = "Activo"
            }).ToList();
            foreach (var item in course)
            {
                courseList.Add(new SelectListItem
                {
                    Text = item.Name,
                    Value = item.Id.ToString()
                });
            }
            courseList.Insert(0, new SelectListItem { Text = "---Selecciona---", Value = "" });

            List<Lesson> lesson = Lesson.Dao.GetByFilter(new
            {
                Enabled = true
            }).ToList();
            foreach (var item in lesson)
            {
                lessonList.Add(new SelectListItem
                {
                    Text = item.Title,
                    Value = item.Id.ToString()

                });
            }
            lessonList.Insert(0, new SelectListItem { Text = "----Selecciona-----", Value = " " });
            List<Lesson> lesson1 = Lesson.Dao.GetByFilter(new
            {
                Enabled = true
            }).ToList();
            foreach (var item in lesson1)
            {
                lessonUrlList.Add(new SelectListItem
                {
                    Text = item.Url,
                    Value = item.Id.ToString()

                });
            }
            lessonUrlList.Insert(0, new SelectListItem { Text = "----Selecciona-----", Value = " " });


            teacherList = new List<SelectListItem>();
            List<Teacher> teachers = Teacher.Dao.GetByFilter(new
            {
                Code = "Active"
            }).ToList();
            foreach (var item in teachers)
            {
                teacherList.Add(new SelectListItem
                {
                    Text = (item.User.Name + " " + item.User.FullName),
                    Value = item.Id.ToString()
                });
            }
            teacherList.Insert(0, new SelectListItem { Text = "---seleciona---", Value = " " });
        }





    }
}