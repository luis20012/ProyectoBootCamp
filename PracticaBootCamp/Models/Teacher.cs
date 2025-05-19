using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Data.Common;
using System.Reflection;
using DNF.Entity;
using PracticaBootCamp.Dao;
using PracticaBootCamp.Bussines;
using DNF.Enviroment;
using DNF.Type.Bussines;
using Type = DNF.Type.Bussines.Type;

using DNF.Security.Bussines;
using System.ComponentModel.DataAnnotations;



namespace PracticaBootCamp.Bussines
{

    public partial class Teacher : IEntityDao
    {
        public override long Id { get; set; }
        [Required(ErrorMessage = "El titulo del profesor es obligatorio")]
        public string Title { get; set; }
        [Required(ErrorMessage = "El usuario del profesor es obligatorio")]
        public User User { get; set; }
        [Required(ErrorMessage =("Es obligatorio que se ponga un estado al curso"))]
        public StateTeacher StateTeacher { get; set; }
     
        //private List<Teacher> _teachers;
        //public List<Teacher> Teachers
        //{
        //    get => _teachers ?? (_teachers = Teacher.Dao.GetBy(this));
        //    set => _teachers = value;
        //}
        private List<TeacherCourse> _teacherCourses;
        public List<TeacherCourse> TeacherCourses
        {
            get => _teacherCourses ?? (_teacherCourses = TeacherCourse.Dao.GetBy(this));
            set => _teacherCourses = value;
        }



        public override void Save()
        {
            Dao.Save(this);
        }
        public override void Delete()
        {
            Dao.Delete(Id);
        }

        private static TeacherDao _dao;
        public static TeacherDao Dao
            => _dao ?? (_dao = new TeacherDao());


    }
}
namespace PracticaBootCamp.Dao
{
    public partial class TeacherDao : DaoDb<Teacher>
    {
        public int GetDuplicateProfesor(string Title)
    => int.Parse(GetScalarFromSP("GetDuplicateProfesor", new { Title }));
        public List<Teacher> GetByIndexFilters(string name, string Title, int teacher_state_id)
    => GetFromSP("GetByIndexFilters", new { name,Title, teacher_state_id });





    }
}