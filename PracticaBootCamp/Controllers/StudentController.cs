using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DevExpress.Office.Utils;
using DevExpress.XtraCharts.Native;
using DNF.Entity;
using DNF.Security.Bussines;
using DNF.Security.Dao;
using java.awt;
using Microsoft.AspNet.Identity;
using Nest;
using PracticaBootCamp.Bussines;

namespace PracticaBootCamp.Controllers
{
    public class StudentController : Controller
    {
        public User currentUser = Current.User;
        List<SelectListItem> stateStudentList = new List<SelectListItem>();
        List<SelectListItem> userList = new List<SelectListItem>();
        List<SelectListItem> profileList = new List<SelectListItem>();
        public void llenarList()
        {
            stateStudentList = new List<SelectListItem>();
            List<StateStudent> StudentStates = StateStudent.Dao.GetByFilter(new
            {
                StateStudent = "Activo"
            }).ToList();
            foreach (var item in StudentStates)
            {
                stateStudentList.Add(new SelectListItem
                {
                    Text = item.State,
                    Value = item.Id.ToString()
                });
            }
            stateStudentList.Insert(0, new SelectListItem { Text = "---Selecione---", Value = " " });

            userList = new List<SelectListItem>();
            List<User> users = new UserDao().GetByFilter(new
            {
                StateStudent = "Active"
            }).ToList()
                .Where(u => u.Profiles.Any(p => p.Id == 3))
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

            profileList = new List<SelectListItem>();
            List<Profile> profile = new ProfileDao().GetByFilter(new
            {
                Name = "Student",
                State = "Active"
            }).ToList()
                .Where(u => u.ProfileAccess.Any(p => p.Id == 3))
                .ToList();
            foreach (var item in profile)
            {
                userList.Add(new SelectListItem
                {
                    Text = (item.Name),
                    Value = item.Id.ToString()
                });
            }
            profileList.Insert(0, new SelectListItem { Text = "---Seleccione---", Value = " " });
        }

        // GET: Student
        [AccessCode("Student")]
        [Authenticated]
        public ActionResult Index()
        {
            ViewBag.Title = "Estudiante";
            ViewBag.Edit = Current.User.HasAccess("StudentEdit");
            ViewBag.New = Current.User.HasAccess("StudentCreate");
            ViewBag.Delete = Current.User.HasAccess("StudentDelete");
            llenarList();
            ViewBag.profileList = profileList;
            ViewBag.userList = userList;
            ViewBag.stateStudentList = stateStudentList;

            List<Student> list = null;
            list = Student.Dao.GetAll().ToList();
            list.LoadRelation(x => x.User);
            list.LoadRelation(x => x.StateStudent);
            list.LoadRelationList(x => x.StudentCourses);
            foreach (var item in list)
            {
                item.StudentCourses.LoadRelation(x => x.Course);
                item.StudentCourses.LoadRelation(x => x.Student);
            }
            list = list.Where(c => c.StateStudent != null && c.StateStudent.Id == 1).ToList();

            return View(list);
        }


        [HttpPost]
        [AccessCode("Student")]
        [Authenticated]
        public ActionResult Index(Student student)
        {
            ViewBag.Title = "Estudiante";
            ViewBag.Edit = Current.User.HasAccess("StudentEdit");
            ViewBag.New = Current.User.HasAccess("StudentCreate");
            ViewBag.Delete = Current.User.HasAccess("StudentDelete");
            llenarList();
            ViewBag.profileList = profileList;
            ViewBag.userList = userList;
            ViewBag.stateStudentList = stateStudentList;

            string Name = student.User.Name;
            int StateStudents = (int)student.StateStudent.Id;
            List<Student> list = null;
            list = Student.Dao.GetByIndexFilters(Name, StateStudents);
            list.LoadRelation(x => x.User);
            list.LoadRelation(x => x.StateStudent);
            list.LoadRelationList(x => x.StudentCourses);
            foreach (var item in list)
            {
                item.StudentCourses.LoadRelation(x => x.Course);
                item.StudentCourses.LoadRelation(x => x.Course.StateCourse);
                item.StudentCourses.LoadRelation(x => x.Student);
                item.StudentCourses.LoadRelation(x => x.Student.User);
                item.StudentCourses.LoadRelation(x => x.Student.StateStudent);
            }

            list = list.Where(c =>
       (string.IsNullOrEmpty(Name) || c.User.Name.Contains(Name)) &&
       (StateStudents == 0 || c.StateStudent?.Id == StateStudents))
           .ToList();
            return View(list);

        }



        [AccessCode("StudentCreate")]
        [Authenticated]
        public ActionResult Create()
        {
            llenarList();
            ViewBag.stateStudentList = stateStudentList;
            ViewBag.userList = userList;
            ViewBag.url = Request.Headers["Referer"].ToString();
            return View();
        }
        [HttpPost]
        [AccessCode("StudentCreate")]
        [Authenticated]
        public ActionResult Create(FormCollection collection)
        {
            llenarList();
            ViewBag.stateStudentList = stateStudentList;
            ViewBag.userList = userList;
            try
            {
                if (ModelState.IsValid)
                {
                    int userId;
                    if (int.TryParse(collection["User_Id"], out userId))
                    {
                        bool studentExist = Student.Dao.GetAll().Any(x => x.User.Id != null && x.User.Id == userId);
                        if (!studentExist)
                        {
                            Student student = new Student();
                            student.Tuition = collection["Tuition"];
                            student.User = new User { Id = long.Parse(collection["User_Id"]) };
                            student.StateStudent = new StateStudent { Id = 1 };
                            student.Save();
                            string url = collection["url"];
                            return RedirectToAction("Index", "Student");
                        }
                        else
                        {
                            ViewBag.Alert = "Ya hay un Estudiante asociado con ese Usuario.";
                            llenarList();
                            ViewBag.stateStudentList = stateStudentList;
                            ViewBag.userList = userList;
                            return View();
                        }
                    }
                }
                llenarList();
                ViewBag.stateStudentList = stateStudentList;
                ViewBag.userList = userList;
                return View();
            }
            catch (Exception ex)
            {
                llenarList();
                ViewBag.stateStudentList = stateStudentList;
                ViewBag.userList = userList;
                return View();
            }
        }
        [AccessCode("StudentEdit")]
        [Authenticated]
        public ActionResult Edit(int id)
        {// Llenar las listas y enviarlas por ViewBag
            llenarList();
            ViewBag.stateStudentList = stateStudentList;
            ViewBag.userList = userList;
            List<Student> list = new List<Student>();
            Student student = Student.Dao.Get(id);
            list.Add(student);
            list.LoadRelation(x => x.StateStudent);
            list.LoadRelationList(x => x.StudentCourses);
            return View(list[0]);
        }

        [HttpPost]
        [AccessCode("StudentEdit")]
        [Authenticated]
        public ActionResult Edit(int id, FormCollection collection)
        {
            llenarList();
            ViewBag.stateStudentList = stateStudentList;
            ViewBag.userList = userList;

            
            try
            {
                if (ModelState.IsValid)
                {
                    Student student = Student.Dao.Get(id);
                    bool StudentExists = Student.Dao.GetAll()
                        .Any(l => l.Tuition.ToLower() == collection["Tuition"].ToLower() && l.Id != id);
                    if (StudentExists)
                    {
                        ViewBag.Alert = "Ya existe un estudiante con ese nombre";
                        llenarList();
                        ViewBag.stateStudentList = stateStudentList;
                        ViewBag.userList = userList;
                        return View(student);

                        
                    }
                    student.Tuition = collection["Tuition"];
                    student.StateStudent = new StateStudent { Id = long.Parse(collection["StateStudent"]) };
                    student.User = Student.Dao.Get(id).User;

                    student.Save();
                    return RedirectToAction("Index");
                }

                llenarList();
                ViewBag.stateStudentList = stateStudentList;
                ViewBag.userList = userList;
                return View();
            }
            catch
            {
                llenarList();
                ViewBag.stateStudentList = stateStudentList;
                ViewBag.userList = userList;
                return RedirectToAction("Index");
            }
        }
        [AccessCode("StudentDelete")]
        [Authenticated]
        public ActionResult Delete(int Id)
        {
            llenarList();
            ViewBag.stateStudentList = stateStudentList;
            ViewBag.userList = userList;
            Student student = Student.Dao.Get(Id);
            try
            {



                foreach (var rel in student.StudentCourses)
                {

                    rel.Delete();
                }
                student.StateStudent = new StateStudent { Id = 2 };
                student.Save();
                return RedirectToAction("Index");
            }
            catch
            {
                // Podés loguear el error si querés
                return View("Error"); // o View(model) si lo estás usando
            }
        }

    }
}