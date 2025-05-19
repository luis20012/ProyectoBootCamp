using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DNF.Security.Bussines;
using DNF.Security.Dao;
using PracticaBootCamp.Bussines;

namespace PracticaBootCamp.Controllers
{
    public class TeacherCourseController : Controller
    {
        List<SelectListItem> courseList = new List<SelectListItem>();
        List<SelectListItem> teacherList = new List<SelectListItem>();
        List<SelectListItem> userList = new List<SelectListItem>();
        private void llenarListas()
        {
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

            teacherList = new List<SelectListItem>();
            List<Teacher> teacher = Teacher.Dao.GetByFilter(new
            {
                Code = "Active"
            }).ToList()
                .Where(s => s.User.UserProfiles.Any(p => p.Profile.Id == 2))
                .ToList();
            foreach (var item in teacher)
            {
                teacherList.Add(new SelectListItem
                {
                    Text = (item.User.Name + " " + item.User.FullName + " (" + item.Title + ")"),
                    Value = item.Id.ToString()
                });
            }
            teacherList.Insert(0, new SelectListItem { Text = "---Elegir---", Value = " " });

            userList = new List<SelectListItem>();
            var userIds = teacher.Select(t => t.User).Distinct().ToList();
            List<User> users = new UserDao().GetByFilter(new
            {
                Id_in = userIds,
                Code = "Active",
                StateTeacher = "Activo"

            }).ToList()
                .Where(u => u.UserProfiles.Any(p => p.Id == 2))
                .ToList();
            var userDictionary = users.ToDictionary(u => u.Id);
            foreach (var item in users)
            {
                if (userDictionary.ContainsKey(item.Id)) // Asegurarse de que el usuario existe
                {
                    var user = userDictionary[item.Id];
                    teacherList.Add(new SelectListItem
                    {
                        Text = (user.Name + " " + user.FullName + "1"),
                        Value = item.Id.ToString()
                    });
                }
                else
                {
                    // Manejar el caso donde no se encuentra el usuario (opcional)
                    teacherList.Add(new SelectListItem
                    {
                        Text = "Usuario no encontrado para el profesor " + item.Id,
                        Value = item.Id.ToString()
                    });
                }
            }
            userList.Insert(0, new SelectListItem { Text = "---Elegir---", Value = " " });



            ViewBag.teacherList = teacherList;
            ViewBag.userList = userList;
            ViewBag.courseList = courseList;
        }



        // GET: TeacherCourse
        public ActionResult Create()
        {
            llenarListas();
            ViewBag.teacherList = teacherList;
            ViewBag.userList = userList;
            ViewBag.courseList = courseList;
            return View();
        }


        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            llenarListas();
            ViewBag.teacherList = teacherList;
            ViewBag.userList = userList;
            ViewBag.courseList = courseList;
            try
            {
                if (ModelState.IsValid)
                {
                    bool teacherCourseExist = TeacherCourse.Dao.GetAll().Any(x => x.Teacher.Id == long.Parse(collection["Teacher_Id"]) && x.Course.Id == long.Parse(collection["Course_Id"]));
                    if (!teacherCourseExist)
                    {
                        TeacherCourse teacherCourse = new TeacherCourse();
                        teacherCourse.Teacher = new Teacher { Id = long.Parse(collection["Teacher_Id"]) };
                        teacherCourse.Course = new Course { Id = long.Parse(collection["Course_Id"]) };
                        teacherCourse.Save();
                        return RedirectToAction("Index", "Teacher"); 
                    }
                    else
                    {
                        llenarListas();
                        ViewBag.Alert = "Este profesor ya esta asignado a este curso";
                        ViewBag.teacherList = teacherList;
                        ViewBag.userList = userList;
                        ViewBag.courseList = courseList;
                        return View();
                    }
                }
                llenarListas();
                ViewBag.teacherList = teacherList;
                ViewBag.userList = userList;
                ViewBag.courseList = courseList;
                return View();
            }
            catch
            {
                llenarListas();
                ViewBag.teacherList = teacherList;
                ViewBag.userList = userList;
                ViewBag.courseList = courseList;
                return View();
            }

        }


        public ActionResult Delete(int id)
        {
            try
            {
                TeacherCourse teacherCourse = TeacherCourse.Dao.Get(id);
                teacherCourse.Delete();
                return RedirectToAction("Index", "Teacher");

            }
            catch (Exception ex)
            {

                return View();
            }



        }







    }
}
