using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using com.sun.jdi.request;
using com.sun.org.apache.bcel.@internal.generic;
using com.sun.tools.@internal.ws.util;
using com.sun.xml.@internal.bind.v2.model.core;
using DevExpress.Charts.ChartData;
using DevExpress.Xpo;
using DevExpress.XtraSpellChecker.Strategies;
using DevExpress.XtraTreeMap.Native;
using DNF.Entity;
using DNF.ExtendedDao;
using DNF.Security.Bussines;
using DNF.Security.Dao;
using java.awt;
using java.sql;
using Microsoft.AspNet.Identity;
using NPOI.SS.Formula.Functions;
using PracticaBootCamp.Bussines;
using sun.awt.geom;

namespace PracticaBootCamp.Controllers
{
    public class CourseController : Controller
    {
        public User currentUser = Current.User;
        // GET: Course
        [AccessCode("Course")]
        [Authenticated]
        public ActionResult Index()
        {
            ViewBag.Title = "Curso";
            ViewBag.Edit = Current.User.HasAccess("CourseEdit");
            ViewBag.New = Current.User.HasAccess("CourseCreate");
            ViewBag.Delete = Current.User.HasAccess("CourseDelete");
            ViewBag.Details = Current.User.HasAccess("CourseDetails");
            ViewBag.IndexP = Current.User.HasAccess("CourseIndexPrincipal");
            llenarList();
            ViewBag.teacherList = teacherList;
            ViewBag.stateCourseList = stateCourseList;
            List<Course> cursos = new List<Course>();
            var User_Id = Current.User.Id;
            var student = Student.Dao.GetByFilter(new { User_Id = User_Id }).FirstOrDefault();

            var teacher = Teacher.Dao.GetByFilter(new { User_Id = User_Id }).FirstOrDefault();


            if (student != null)
            {
                var studentCourses = StudentCourse.Dao.GetByFilter(new { Student_Id = student.Id });

                studentCourses.LoadRelation(x => x.Course);
                studentCourses.LoadRelation(x => x.Student);
                cursos.LoadRelationList(x => x.LessonCourses);
                cursos.LoadRelationList(x => x.TeacherCourses);
                cursos.LoadRelationList(x => x.StudentCourses);
                cursos.LoadRelation(x => x.StateCourse);
                foreach (var sc in studentCourses)
                {
                    cursos.Add(sc.Course);
                }

                cursos = cursos.Where(c => c.StateCourse != null && c.StateCourse.Id == 1).ToList();
            }
            else if (teacher != null)
            {
                var teacherCourses = TeacherCourse.Dao.GetByFilter(new { Teacher_Id = teacher.Id });

                teacherCourses.LoadRelation(x => x.Course);
                teacherCourses.LoadRelation(x => x.Teacher);
                cursos.LoadRelationList(x => x.LessonCourses);
                cursos.LoadRelationList(x => x.TeacherCourses);
                cursos.LoadRelationList(x => x.StudentCourses);
                cursos.LoadRelation(x => x.StateCourse);
                foreach (var tc in teacherCourses)
                {
                    teacherCourses.LoadRelation(x => x.Course);
                    teacherCourses.LoadRelation(x => x.Teacher);
                    teacherCourses.LoadRelation(x => x.Course.StateCourse);
                    cursos.Add(tc.Course);
                }

                cursos = cursos.Where(c => c.StateCourse != null && c.StateCourse.Id == 1).ToList();
            }
            else
            {
                cursos = Course.Dao.GetByFilter(new { StateCourse = "Activo", Code = "Active" }).ToList();

                cursos = cursos.Where(c => c.StateCourse != null && c.StateCourse.Id == 1).ToList();
            }

            // Cargar relaciones necesarias
            cursos.LoadRelationList(x => x.LessonCourses);
            cursos.LoadRelationList(x => x.TeacherCourses);
            cursos.LoadRelationList(x => x.StudentCourses);
            cursos.LoadRelation(x => x.StateCourse);

            foreach (var curso in cursos)
            {
                curso.TeacherCourses.LoadRelation(x => x.Teacher);
                curso.StudentCourses.LoadRelation(x => x.Student);
                curso.LessonCourses.LoadRelation(x => x.Lesson);
                curso.StudentCourses.LoadRelation(x => x.Course.StateCourse);
                curso.StudentCourses.LoadRelation(x => x.Course);
            }

            return View(cursos);

        }




        //POST Course/Index
        [HttpPost]
        [AccessCode("Course")]
        [Authenticated]
        public ActionResult Index(Course course)
        {
            ViewBag.Edit = Current.User.HasAccess("CourseEdit");
            ViewBag.New = Current.User.HasAccess("CourseCreate");
            ViewBag.Delete = Current.User.HasAccess("CourseDelete");
            ViewBag.Details = Current.User.HasAccess("CourseDetails");
            ViewBag.IndexP = Current.User.HasAccess("CourseIndexPrincipal");
            llenarList();

            ViewBag.stateCourseList = stateCourseList;

            string name = course.Name;
            int StateCourse = (int)course.StateCourse.Id;
            var User_Id = Current.User.Id;
            var student = Student.Dao.GetByFilter(new { User_Id = User_Id }).FirstOrDefault();
            var teacher = Teacher.Dao.GetByFilter(new { User_Id = User_Id }).FirstOrDefault();
            List<Course> cursos = new List<Course>();

            if (student != null)
            {
                var studentCourses = StudentCourse.Dao.GetByFilter(new { Student_Id = student.Id });
                studentCourses.LoadRelation(x => x.Course);

                cursos = studentCourses
                    .Where(sc =>
                        sc.Course != null &&
                        (string.IsNullOrEmpty(name) || sc.Course.Name.Contains(name)) &&
                        (StateCourse == 1 || sc.Course.StateCourse?.Id == StateCourse))
                    .Select(sc => sc.Course)
                    .ToList();
            }
            else if (teacher != null)
            {
                var teacherCourses = TeacherCourse.Dao.GetByFilter(new { Teacher_Id = teacher.Id });
                teacherCourses.LoadRelation(x => x.Course);

                cursos = teacherCourses
                    .Where(tc =>
                        tc.Course != null &&
                        (string.IsNullOrEmpty(name) || tc.Course.Name.Contains(name)) &&
                        (StateCourse == 0 || tc.Course.StateCourse?.Id == StateCourse))
                    .Select(tc => tc.Course)
                    .ToList();
            }
            else
            {
                //Administrador ve todos los cursos con filtros
                //cursos = Course.Dao.GetByIndexFilter(name, StateCourse).ToList();
                cursos = Course.Dao.GetAll().ToList();
                //if (StateCourse_Id > 0)
                //{
                //    cursos = cursos.Where(c => c.StateCourse?.Id == StateCourse_Id).ToList();
                //}
            }
            cursos = cursos.Where(c =>
        (string.IsNullOrEmpty(name) || c.Name.Contains(name)) &&
        (StateCourse == 0 || c.StateCourse?.Id == StateCourse))
            .ToList();
            //Cargar relaciones
            cursos.LoadRelationList(x => x.TeacherCourses);
            cursos.LoadRelationList(x => x.StudentCourses);
            cursos.LoadRelationList(x => x.LessonCourses);
            cursos.LoadRelation(x => x.StateCourse);

            foreach (var curso in cursos)
            {
                curso.TeacherCourses.LoadRelation(x => x.Teacher);
                curso.StudentCourses.LoadRelation(x => x.Student);
                curso.LessonCourses.LoadRelation(x => x.Lesson);
                curso.StudentCourses.LoadRelation(x => x.Course.StateCourse);
                curso.StudentCourses.LoadRelation(x => x.Course);
            }

            return View(cursos);
        }

        //Get Course/Create
        [AccessCode("CourseCreate")]
        [Authenticated]
        public ActionResult Create()
        {
            llenarList();
            ViewBag.stateCourseList = stateCourseList;
            ViewBag.lessonCourseList = lessonCourseList;
            ViewBag.teacherList = teacherList;
            ViewBag.url = Request.Headers["Referer"].ToString();
            return View();
        }
        [HttpPost]
        [AccessCode("CourseCreate")]
        [Authenticated]
        public ActionResult Create(FormCollection collection, HttpPostedFileBase imageFile)
        {
            llenarList();
            ViewBag.stateCourseList = stateCourseList;
            try
            {
                if (ModelState.IsValid)
                {
                    bool courseExists = Course.Dao.GetAll().Any(c => c.Name.ToLower() == collection["Name"].ToLower());


                    if (!courseExists)
                    {
                        Course course = new Course();
                        course.Name = collection["Name"];
                        course.Description = collection["Description"];
                        course.StartDate = DateTime.Parse(collection["StartDate"]);
                        course.EndDate = DateTime.Parse(collection["EndDate"]);
                        course.StateCourse = new StateCourse { Id = 1 };
                        course.Save();
                        return RedirectToAction("Index", "Course");
                    }
                    else
                    {
                        ViewBag.Alert = "ya existe un curso con este nombre";
                        llenarList();
                        ViewBag.stateCourseList = stateCourseList;
                        ViewBag.lessonCourseList = lessonCourseList;
                        ViewBag.teacherList = teacherList;
                        return View();
                    }


                }
                llenarList();
                ViewBag.stateCourseList = stateCourseList;
                ViewBag.lessonCourseList = lessonCourseList;
                ViewBag.teacherList = teacherList;
                return View();
            }
            catch
            {
                return View();
            }
        }


        List<SelectListItem> stateCourseList = new List<SelectListItem>();
        List<SelectListItem> lessonCourseList = new List<SelectListItem>();
        List<SelectListItem> teacherList = new List<SelectListItem>();

        public void llenarList()
        {
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
            teacherList.Insert(0, new SelectListItem { Text = "---Elegir---", Value = " " });

            stateCourseList = new List<SelectListItem>();
            List<StateCourse> stateCourses = StateCourse.Dao.GetByFilter(new
            {
                Code = "Active",
                StateCourse = "Activo"
            }).ToList();
            foreach (var item in stateCourses)
            {
                stateCourseList.Add(new SelectListItem
                {
                    Text = item.State,
                    Value = item.Id.ToString()
                });
            }
            stateCourseList.Insert(0, new SelectListItem { Text = "---Elegir---", Value = " " });


            lessonCourseList = new List<SelectListItem>();
            List<LessonCourse> lessonCourses = LessonCourse.Dao.GetByFilter(new
            {
                Code = "Active"
            }).ToList();
            foreach (var item in lessonCourses)
            {
                lessonCourseList.Add(new SelectListItem
                {
                    Text = item.Lesson.Title,
                    Value = item.Id.ToString()
                });
            }
            lessonCourseList.Insert(0, new SelectListItem { Text = "--Elegir--", Value = " " });
        }
        [AccessCode("CourseEdit")]
        [Authenticated]
        public ActionResult Edit(int id)
        {
            llenarList();
            ViewBag.stateCourseList = stateCourseList;
            ViewBag.lessonCourseList = lessonCourseList;
            ViewBag.teacherList = teacherList;
            List<Course> list = new List<Course>();
            Course course = Course.Dao.Get(id);
            list.Add(course);
            list.LoadRelation(x => x.StateCourse);

            return View(list[0]);
        }

        // POST: Course/Edit/5
        [HttpPost]
        [AccessCode("CourseEdit")]
        [Authenticated]
        public ActionResult Edit(int id, FormCollection collection)
        {
            llenarList();
            ViewBag.stateCourseList = stateCourseList;
            ViewBag.teacherList = teacherList;

            ViewBag.lessonCourseList = lessonCourseList;
            try
            {
                Course course = Course.Dao.Get(id);
                if (ModelState.IsValid)
                {
                    //if ((collection["Name"] == course.Name))
                    //{
                    course.Name = collection["Name"];
                    course.Description = collection["Description"];
                    course.EndDate = DateTime.Parse(collection["EndDate"]);
                    course.StateCourse = new StateCourse { Id = long.Parse(collection["StateCourse"]) };

                    course.Save();
                    return RedirectToAction("Index");

                    //}
                    ViewBag.AlertDuplicateArtistName = "Ya hay un artista con ese nombre artístico";
                    llenarList();
                    ViewBag.teacherList = teacherList;
                    ViewBag.stateCourseList = stateCourseList;
                    return View(course);
                }

                llenarList();
                ViewBag.teacherList = teacherList;
                ViewBag.stateCourseList = stateCourseList;

                return RedirectToAction("Index");
            }
            catch
            {
                llenarList();
                ViewBag.teacherList = teacherList;
                ViewBag.stateCourseList = stateCourseList;

                return RedirectToAction("Index");
            }
        }
        [AccessCode("CourseDelete")]
        [Authenticated]
        public ActionResult Delete(int Id)
        {
            llenarList();
            ViewBag.teacherList = teacherList;
            ViewBag.stateCourseList = stateCourseList;
            try
            {
                Course course = Course.Dao.Get(Id);
                foreach (var item in course.StudentCourses)
                {
                    item.Delete();
                }
                foreach (var itam in course.TeacherCourses)
                {
                    itam.Delete();
                }
                foreach (var video in course.LessonCourses)
                {
                    video.Delete();
                }
                course.StateCourse = new StateCourse { Id = 5 };
                course.Save();
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        [AccessCode("CourseDetails")]
        [Authenticated]
        public ActionResult Details(int Id)
        {
            llenarList();
            ViewBag.teacherList = teacherList;
            ViewBag.stateCourseList = stateCourseList;
            ViewBag.lessonCourseList = lessonCourseList;
            List<Course> list = new List<Course>();
            Course course = Course.Dao.Get(Id);
            LessonCourse lesson1 = LessonCourse.Dao.Get(Id);
            course.GetCourseLessonActive = Lesson.Dao.GetCourseLesson((int)course.Id);
            list.Add(course);
            list.LoadRelation(x => x.StateCourse);
            list.LoadRelationList(x => x.TeacherCourses);
            list.LoadRelationList(x => x.StudentCourses);
            list.LoadRelationList(x => x.LessonCourses);
            foreach (var item in list)
            {
                item.StudentCourses.LoadRelation(x => x.Student);
                item.StudentCourses.LoadRelation(x => x.Course);
                item.TeacherCourses.LoadRelation(x => x.Course);
                item.TeacherCourses.LoadRelation(x => x.Teacher);
                item.LessonCourses.LoadRelation(x => x.Course);
                item.LessonCourses.LoadRelation(x => x.Lesson);
                foreach (var lesson in item.LessonCourses)
                {
                    lesson.Lesson.LessonCourses.LoadRelation(x => x.Lesson);
                    lesson.Lesson.LessonCourseActives = Lesson.Dao.GetCourseLesson((int)lesson.Lesson.Id);
                }
                item.LessonCourses.LoadRelation(x => x.Course);
                foreach (var teacherCourse in item.TeacherCourses)
                {
                    teacherCourse.Teacher = Teacher.Dao.Get(teacherCourse.Teacher.Id);
                    teacherCourse.Teacher.User = new UserDao().Get(teacherCourse.Teacher.User.Id);
                }
            }
            llenarList();
            ViewBag.teacherList = teacherList;
            ViewBag.lessonCourseList = lessonCourseList;
            ViewBag.stateCourseList = stateCourseList;
            return View(list[0]);
        }

        public ActionResult IndexPrincipal()
        {
            ViewBag.Title = "Curso";
            ViewBag.Edit = Current.User.HasAccess("CourseEdit");
            ViewBag.New = Current.User.HasAccess("CourseCreate");
            ViewBag.Delete = Current.User.HasAccess("CourseDelete");
            ViewBag.Details = Current.User.HasAccess("CourseDetails");
            ViewBag.IndexP = Current.User.HasAccess("CourseIndexPrincipal");
            llenarList();
            ViewBag.teacherList = teacherList;
            ViewBag.stateCourseList = stateCourseList;
            var User_Id = Current.User.Id;
            var student = Student.Dao.GetByFilter(new { User_Id = User_Id }).FirstOrDefault();

            var teacher = Teacher.Dao.GetByFilter(new { User_Id = User_Id }).FirstOrDefault();
            List<Course> cursos = new List<Course>();

            if (student != null)
            {
                var studentCourses = StudentCourse.Dao.GetByFilter(new { Student_Id = student.Id });

                studentCourses.LoadRelation(x => x.Course);
                studentCourses.LoadRelation(x => x.Student);
                cursos.LoadRelationList(x => x.LessonCourses);
                cursos.LoadRelationList(x => x.TeacherCourses);
                cursos.LoadRelationList(x => x.StudentCourses);
                cursos.LoadRelation(x => x.StateCourse);
                foreach (var sc in studentCourses)
                {
                    cursos.Add(sc.Course);
                }
                cursos = cursos.Where(c => c.StateCourse != null && c.StateCourse.Id == 1).ToList();
            }
            else if (teacher != null)
            {
                var teacherCourses = TeacherCourse.Dao.GetByFilter(new { Teacher_Id = teacher.Id });

                teacherCourses.LoadRelation(x => x.Course);
                teacherCourses.LoadRelation(x => x.Teacher);
                cursos.LoadRelationList(x => x.LessonCourses);
                cursos.LoadRelationList(x => x.TeacherCourses);
                cursos.LoadRelationList(x => x.StudentCourses);
                cursos.LoadRelation(x => x.StateCourse);
                foreach (var tc in teacherCourses)
                {
                    teacherCourses.LoadRelation(x => x.Course);
                    teacherCourses.LoadRelation(x => x.Teacher);
                    cursos.Add(tc.Course);
                }
                cursos = cursos.Where(c => c.StateCourse != null && c.StateCourse.Id == 1).ToList();
            }
            else
            {
                cursos = Course.Dao.GetByFilter(new { Code = "Active" }).ToList();
                cursos = cursos.Where(c => c.StateCourse != null && c.StateCourse.Id == 1).ToList();
            }


            // Cargar relaciones necesarias
            cursos.LoadRelationList(x => x.LessonCourses);
            cursos.LoadRelationList(x => x.TeacherCourses);
            cursos.LoadRelationList(x => x.StudentCourses);
            cursos.LoadRelation(x => x.StateCourse);

            foreach (var curso in cursos)
            {
                curso.TeacherCourses.LoadRelation(x => x.Teacher);
                curso.StudentCourses.LoadRelation(x => x.Student);
                curso.LessonCourses.LoadRelation(x => x.Lesson);
                curso.StudentCourses.LoadRelation(x => x.Course.StateCourse);
                curso.StudentCourses.LoadRelation(x => x.Course);
            }

            return View(cursos);

        }
        [HttpPost]
        [AccessCode("Course")]
        public ActionResult IndexPrincipal(Course course, FormCollection collection)
        {
            ViewBag.Edit = Current.User.HasAccess("CourseEdit");
            ViewBag.New = Current.User.HasAccess("CourseCreate");
            ViewBag.Delete = Current.User.HasAccess("CourseDelete");
            ViewBag.Details = Current.User.HasAccess("CourseDetails");
            ViewBag.IndexP = Current.User.HasAccess("CourseIndexPrincipal");
            llenarList();
            ViewBag.stateCourseList = stateCourseList;

            var User_Id = Current.User.Id;
            var student = Student.Dao.GetByFilter(new { User_Id = User_Id }).FirstOrDefault();
            var teacher = Teacher.Dao.GetByFilter(new { User_Id = User_Id }).FirstOrDefault();
            List<Course> cursos = new List<Course>();
            string name = course.Name;
            int? stateCourseId = (int)course.StateCourse?.Id;
            if (student != null)
            {
                var studentCourses = StudentCourse.Dao.GetByFilter(new { Student_Id = student.Id });
                cursos = Course.Dao.GetByIndexFilter(name, (int)stateCourseId);
                studentCourses.LoadRelation(x => x.Course);
                studentCourses.LoadRelation(x => x.Student);
                foreach (var sc in studentCourses)
                {
                    var c = Course.Dao.Get(sc.Course.Id);
                    cursos.LoadRelationList(x => x.TeacherCourses);
                    cursos.LoadRelationList(x => x.StudentCourses);
                    cursos.LoadRelationList(x => x.LessonCourses);
                    cursos.LoadRelation(x => x.StateCourse);
                    if (c != null &&
                        (string.IsNullOrEmpty(name) || c.Name.Contains(name)) &&
                        (!stateCourseId.HasValue || c.StateCourse.Id == stateCourseId.Value))
                    {


                        cursos.Add(c);
                    }
                }
            }
            else if (teacher != null)
            {
                var teacherCourses = TeacherCourse.Dao.GetByFilter(new { Teacher_Id = teacher.Id });
                cursos = Course.Dao.GetByIndexFilter(name, (int)stateCourseId);
                teacherCourses.LoadRelation(x => x.Course);
                teacherCourses.LoadRelation(x => x.Teacher);
                foreach (var tc in teacherCourses)
                {
                    var c = Course.Dao.Get(tc.Course.Id);
                    cursos.LoadRelationList(x => x.TeacherCourses);
                    cursos.LoadRelationList(x => x.StudentCourses);
                    cursos.LoadRelationList(x => x.LessonCourses);
                    cursos.LoadRelation(x => x.StateCourse);
                    if (c != null &&
                        (string.IsNullOrEmpty(name) || c.Name.Contains(name)) &&
                        (!stateCourseId.HasValue || c.StateCourse.Id == stateCourseId.Value))
                    {

                        cursos.Add(c);
                    }
                }
            }
            else
            {
                // Admin: filtra en todos los cursos
                cursos = Course.Dao.GetByIndexFilter(name, stateCourseId ?? 0).ToList();
            }

            // Cargar relaciones
            cursos.LoadRelationList(x => x.TeacherCourses);
            cursos.LoadRelationList(x => x.StudentCourses);
            cursos.LoadRelationList(x => x.LessonCourses);
            cursos.LoadRelation(x => x.StateCourse);

            foreach (var curso in cursos)
            {
                curso.TeacherCourses.LoadRelation(x => x.Teacher);
                curso.StudentCourses.LoadRelation(x => x.Student);
                curso.LessonCourses.LoadRelation(x => x.Lesson);
                curso.StudentCourses.LoadRelation(x => x.Course.StateCourse);
                curso.StudentCourses.LoadRelation(x => x.Course);
            }

            return View(cursos);


        }

        //[AccessCode("CourseStudents")]
        //[Authenticated]
        public ActionResult Students(int id)
        {
            List<Course> list = new List<Course>();
            Course course = Course.Dao.Get(id);
            course.GetCourseLessonActive = Student.Dao.GetCourseStudent((int)course.Id);
            list.Add(course);
            list.LoadRelationList(c => c.StudentCourses);

            foreach (var sc in list)
            {
                sc.StudentCourses.LoadRelation(s => s.Student);
                sc.StudentCourses.LoadRelation(s => s.Student.User);
                sc.StudentCourses.LoadRelation(s => s.Student.StateStudent);

                sc.StudentCourses.LoadRelation(s => s.Course);
                sc.StudentCourses.LoadRelation(s => s.Course.StateCourse);
            }

            var students = course.StudentCourses.Select(sc => sc.Student).ToList();

            ViewBag.CourseName = course.Name;
            ViewBag.CourseId = id; // <= ESTO ES LO NUEVO
            return View(students);
        }



    }



}
