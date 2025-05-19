using System;
using System.Collections.Generic;
using System.EnterpriseServices;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using com.sun.org.apache.bcel.@internal.classfile;
using com.sun.tools.@internal.ws.processor.model;
using DNF.Entity;
using DNF.Security.Bussines;
using DNF.Security.Dao;
using javax.xml.soap;
using Microsoft.AspNet.Identity;
using PracticaBootCamp.Bussines;

namespace PracticaBootCamp.Controllers
{
    public class StudentCourseController : Controller
    {
        // GET: StudentCourse
        public User currentUser = Current.User;


        List<SelectListItem> lessonList = new List<SelectListItem>();
        List<SelectListItem> courseList = new List<SelectListItem>();
        List<SelectListItem> studentList = new List<SelectListItem>();
        List<SelectListItem> userList = new List<SelectListItem>();
        public void llenarList()
        {
            userList = new List<SelectListItem>();
            List<User> users = new UserDao().GetByFilter(new
            {
                StateStudent = "Active"
            }).ToList()
                .Where(u => u.Profiles.Any(p => p.Id == 2))
                .ToList();
            foreach (var item in users)
            {
                userList.Add(new SelectListItem
                {
                    Text = (item.Name + " " + item.FullName),
                    Value = item.Id.ToString()
                });
            }
            userList.Insert(0, new SelectListItem { Text = "---Seleccione---", Value = " " });
            lessonList = new List<SelectListItem>();

            studentList = new List<SelectListItem>();
            courseList = new List<SelectListItem>();
            List<Course> course = Course.Dao.GetByFilter(new
            {
                Code = "Active"
            }).ToList();
            foreach (var item in course)
            {
                courseList.Add(new SelectListItem
                {
                    Text = item.Name,
                    Value = item.Id.ToString()
                });
            }
            courseList.Insert(0, new SelectListItem { Text = "---Elegir---", Value = "" });

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
            lessonList.Insert(0, new SelectListItem { Text = "----Elegir-----", Value = " " });


            studentList = new List<SelectListItem>();
            List<Student> students = Student.Dao.GetByFilter(new
            {
                Code = "Active"
            }).ToList().
            Where(s => s.User.Profiles.Any(p => p.Id == 3))
            .ToList(); 
            foreach (var item in students)
            {
                studentList.Add(new SelectListItem
                {
                    Text = (item.User.Name + " " + item.User.FullName + " " + item.Tuition),
                    Value = item.Id.ToString()
                });
            }
            studentList.Insert(0, new SelectListItem { Text = "---Elegir---", Value = " " });
            ViewBag.courseList = courseList;
            ViewBag.studentList = studentList;
            ViewBag.lessonList = lessonList;
            ViewBag.userList = userList;
        }


        public ActionResult Create()
        {
            llenarList();
            ViewBag.courseList = courseList;
            ViewBag.studentList = studentList;
            ViewBag.userList = userList;
            ViewBag.lessonList = lessonList;
            return View();
        }

        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            llenarList();
            ViewBag.courseList = courseList;
            ViewBag.studentList = studentList;
            ViewBag.lessonList = lessonList;
            ViewBag.userList = userList;



            try
            {
                if (ModelState.IsValid)
                {
                    bool CourseExiste = StudentCourse.Dao.GetAll().Any(x => x.Course.Id == long.Parse(collection["Course_Id"]) && x.Student.Id == long.Parse(collection["Student_Id"]));

                    if (!CourseExiste)
                    {
                        StudentCourse studentCourse = new StudentCourse();
                        studentCourse.Average = 0;

                        studentCourse.Student = new Student { Id = long.Parse(collection["Student_Id"]) };
                        studentCourse.Course = new Course { Id = long.Parse(collection["Course_Id"]) };
                        studentCourse.Save();
                        return RedirectToAction("Index", "Student");
                    }
                    else
                    {
                        ViewBag.Alert = "El curso ya fue asignado al estudiante";
                        llenarList();
                        ViewBag.courseList = courseList;
                        ViewBag.studentList = studentList;
                        ViewBag.lessonList = lessonList;
                        return View(); 
                        
                    }   
                    
                    
                }
                llenarList();
                ViewBag.courseList = courseList;
                ViewBag.studentList = studentList;
                ViewBag.lessonList = lessonList;
                return View();
            }
            catch (Exception ex)
            {
                llenarList();
                ViewBag.courseList = courseList;
                ViewBag.studentList = studentList;
                ViewBag.lessonList = lessonList;
                return View();
            }

        }

        public ActionResult Edit(int Id)
        {
            llenarList();
            ViewBag.courseList = courseList;
            ViewBag.studentList = studentList;
            ViewBag.lessonList = lessonList;
            List<StudentCourse> list = new List<StudentCourse>();
            StudentCourse student = StudentCourse.Dao.Get(Id);
            list.Add(student);
            return View(list[0]);
        }
        [HttpPost]
        public ActionResult Edit(int Id, FormCollection collection)
        {
            llenarList();
            ViewBag.courseList = courseList;
            ViewBag.studentList = studentList;
            ViewBag.lessonList = lessonList;

            try
            {
                StudentCourse student = StudentCourse.Dao.Get(Id);
                if (ModelState.IsValid)
                {
                    student.Average = double.Parse(collection["Average"]);
                    student.Course = new Course { Id = long.Parse(collection["Course.Id"]) };
                    student.Student = new Student { Id = long.Parse(collection["Student.Id"]) };

                    student.Save();
                    return RedirectToAction("Index");
                }
                llenarList();
                ViewBag.courseList = courseList;
                ViewBag.studentList = studentList;
                ViewBag.lessonList = lessonList;

                return RedirectToAction("Index");
            }
            catch
            {
                llenarList();
                ViewBag.courseList = courseList;
                ViewBag.studentList = studentList;
                ViewBag.lessonList = lessonList;
                return RedirectToAction("Index");
            }
        }

        public ActionResult Delete(int id)
        {
            try
            {
                StudentCourse studentCourse = StudentCourse.Dao.Get(id);
                studentCourse.Delete();
                return RedirectToAction("Index", "Student");
            }
            catch (Exception ex)
            {
                return View();
            }



        }


        //public ActionResult mycourses(Student student)
        //{
        //    string UserId = User.Identity.GetUserId();
        //    string StudentId = student.user.Id.ToString();
        //    if (string.IsNullOrEmpty(UserId))
        //    {
        //        return RedirectToAction("Login", "Account");
        //    }
        //    if (UserId == StudentId)
        //    {
        //        List<StudentCourse> list = null;
        //        list = StudentCourse.Dao.GetByStudent_id((int)UserId);
        //    }





        //}

    }
}