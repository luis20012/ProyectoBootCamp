using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using com.sun.org.apache.bcel.@internal.classfile;
using com.sun.security.auth;
using DevExpress.Internal;
using DevExpress.Pdf.Native.BouncyCastle.Tsp;
using DevExpress.XtraRichEdit.Import.Rtf;
using DNF.Entity;
using DNF.ExtendedDao;
using DNF.Security.Bussines;
using DNF.Security.Dao;
using Microsoft.AspNet.Identity;
using Nest;
using Org.BouncyCastle.Bcpg;
using PracticaBootCamp.Bussines;
using sun.java2d;

namespace PracticaBootCamp.Controllers
{
    public class TeacherController : Controller
    {
        //GET: Teacher
        [AccessCode("Teacher")]
        [Authenticated]
        public ActionResult Index()
        {
            ViewBag.Title = "Profesores";
            ViewBag.Edit = Current.User.HasAccess("TeacherEdit");
            ViewBag.New = Current.User.HasAccess("TeacherCreate");
            ViewBag.Delete = Current.User.HasAccess("TeacherDelete");

            llenarList();
            ViewBag.stateTeacherList = stateTeacherList;
            ViewBag.userList = userList;
            List<Teacher> list = null;
            list = Teacher.Dao.GetAll().ToList();
            list.LoadRelation(x => x.User);
            list.LoadRelationList(x => x.TeacherCourses);
            list.LoadRelation(x => x.StateTeacher);
            foreach (var item in list)
            {
                item.TeacherCourses.LoadRelation(x => x.Teacher);
                item.TeacherCourses.LoadRelation(x => x.Course);

            }
            list = list.Where(c => c.StateTeacher != null && c.StateTeacher.Id == 1).ToList();

            return View(list);
        }


        [HttpPost]
        [AccessCode("Teacher")]
        [Authenticated]
        public ActionResult Index(Teacher teacher)
        {
            ViewBag.Title = "Profesores";
            ViewBag.Edit = Current.User.HasAccess("TeacherEdit");
            ViewBag.New = Current.User.HasAccess("TeacherCreate");
            ViewBag.Delete = Current.User.HasAccess("TeacherDelete");
            llenarList();

            ViewBag.stateTeacherList = stateTeacherList;
            ViewBag.userList = userList;
            string name = teacher.User.Name;
            string title = teacher.Title;
            int stateTeacher = (int)teacher.StateTeacher.Id;
            List<Teacher> list = null;
            list = Teacher.Dao.GetByIndexFilters(name, title, stateTeacher);
            list.LoadRelation(x => x.User);
            list.LoadRelationList(x => x.TeacherCourses);
            list.LoadRelation(x => x.StateTeacher);
            foreach (var item in list)
            {

                item.TeacherCourses.LoadRelation(x => x.Teacher);
                item.TeacherCourses.LoadRelation(x => x.Course);
                item.TeacherCourses.LoadRelation(x => x.Course.StateCourse);
                item.TeacherCourses.LoadRelation(x => x.Teacher.User);
                item.TeacherCourses.LoadRelation(x => x.Teacher.StateTeacher);
            }
            list = list.Where(c =>
    (string.IsNullOrEmpty(name) || c.User.Name.Contains(name)) &&
    (stateTeacher == 0 || c.StateTeacher?.Id == stateTeacher))
        .ToList();


            return View(list);
        }
        [AccessCode("TeacherCreate")]
        [Authenticated]
        public ActionResult Create()
        {
            llenarList();
            ViewBag.stateTeacherList = stateTeacherList;
            ViewBag.userList = userList;
            ViewBag.url = Request.Headers["Referer"].ToString();
            return View();
        }
        [HttpPost]
        [AccessCode("TeacherCreate")]
        [Authenticated]
        public ActionResult Create(FormCollection collection)
        {
            llenarList();
            ViewBag.stateTeacherList = stateTeacherList;
            ViewBag.userList = userList;
            try
            {

                if (ModelState.IsValid)
                {
                    int userId;
                    if (int.TryParse(collection["User_Id"], out userId))
                    {
                        bool teacherExist = Teacher.Dao.GetAll().Any(x => x.User.Id != null && x.User.Id == userId);
                        if (!teacherExist)
                        {
                            Teacher teacher = new Teacher();
                            teacher.Title = collection["Title"];
                            teacher.User = new User { Id = int.Parse(collection["User_Id"]) };
                            teacher.StateTeacher = new StateTeacher { Id = 1 };
                            teacher.Save();
                            string url = collection["url"];
                            return RedirectToAction("Index", "Teacher");
                        }
                        else
                        {
                            llenarList();
                            ViewBag.Alert = "Ya tiene un usuario asignado este profesor ";
                            ViewBag.stateTeacherList = stateTeacherList;
                            ViewBag.userList = userList;
                            return View();
                        }
                    }

                }
                llenarList();
                ViewBag.stateTeacherList = stateTeacherList;
                ViewBag.userList = userList;
                return View();
            }
            catch
            {
                llenarList();
                ViewBag.stateTeacherList = stateTeacherList;
                ViewBag.userList = userList;
                return View();
            }


        }


        List<SelectListItem> stateTeacherList = new List<SelectListItem>();
        List<SelectListItem> profileList = new List<SelectListItem>();
        List<SelectListItem> userList = new List<SelectListItem>();
        public void llenarList()
        {
            stateTeacherList = new List<SelectListItem>();
            List<StateTeacher> teacherStates = StateTeacher.Dao.GetByFilter(new
            {
                Code = "Active"
            }).ToList();
            foreach (var item in teacherStates)
            {
                stateTeacherList.Add(new SelectListItem
                {
                    Text = item.State,
                    Value = item.Id.ToString()
                });
            }
            stateTeacherList.Insert(0, new SelectListItem { Text = "---Selecione---", Value = " " });

            userList = new List<SelectListItem>();
            List<User> users = new UserDao().GetByFilter(new
            {
                Code = "Active"
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




        }
        [AccessCode("TeacherDelete")]
        [Authenticated]
        public ActionResult Delete(int Id, Teacher model)
        {
            llenarList();
            ViewBag.stateTeacherList = stateTeacherList;
            ViewBag.userList = userList;
            Teacher teacher = Teacher.Dao.Get(Id);
            try
            {


                foreach (var rel in teacher.TeacherCourses)
                {
                    rel.Delete();
                }

                teacher.StateTeacher = new StateTeacher { Id = 2 };
                teacher.Save();
                return RedirectToAction("Index");
            }
            catch
            {
                // Podés loguear el error si querés
                return View("Error"); // o View(model) si lo estás usando
            }
        }
        [AccessCode("TeacherEdit")]
        [Authenticated]
        public ActionResult Edit(int id)
        {
            llenarList();
            ViewBag.stateTeacherList = stateTeacherList;
            ViewBag.userList = userList;
            List<Teacher> list = new List<Teacher>();
            Teacher teacher = Teacher.Dao.Get(id);
            list.Add(teacher);
            list.LoadRelation(x => x.User);
            list.LoadRelationList(x => x.TeacherCourses);

            return View(list[0]);
        }

        [HttpPost]
        [AccessCode("TeacherEdit")]
        [Authenticated]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {

                if (ModelState.IsValid)
                {
                    Teacher teacher = Teacher.Dao.Get(id);
                    bool TeacherExists = Teacher.Dao.GetAll()
                        .Any(l => l.Title.ToLower() == collection["Title"].ToLower() && l.Id != id);
                    if (TeacherExists)
                    {
                        ViewBag.Alert = "Ya existe un Profesor con ese Usuario";
                        llenarList();
                        ViewBag.stateTeacherList = stateTeacherList;
                        ViewBag.userList = userList;
                        return View(teacher);

                    }
                   

                    teacher.Title = collection["Title"];
                    teacher.StateTeacher = new StateTeacher { Id = long.Parse(collection["StateTeacher"]) };
                    teacher.User = Teacher.Dao.Get(id).User;
                    teacher.Save();
                    return RedirectToAction("Index");

                }
                llenarList();
                ViewBag.stateTeacherList = stateTeacherList;
                ViewBag.userList = userList;
                return RedirectToAction("Index");
            }
            catch
            {
                llenarList();
                ViewBag.stateTeacherList = stateTeacherList;
                ViewBag.userList = userList;
                return RedirectToAction("Index");
            }
        }
    }
}