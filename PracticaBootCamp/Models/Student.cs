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
using DevExpress.Office.Utils;
using System.ComponentModel.DataAnnotations;



namespace PracticaBootCamp.Bussines
{

    public partial class Student : IEntityDao
    {

        public override long Id { get; set; }
        [Required(ErrorMessage ="Es obligatorio el Identificador")]
        public string Tuition { get; set; }
        [Required(ErrorMessage = "Es obligatorio el Usuario")]
        public User User { get; set; }
        public StateStudent StateStudent { get; set; }
        private List<Student> _students;
        public List<Student> Students
        {
            get => _students ?? (_students = Student.Dao.GetBy(this));
            set => _students = value;
        }
        private List<StudentCourse> _studentCourses;
        public List<StudentCourse> StudentCourses
        {
            get => _studentCourses ?? (_studentCourses = StudentCourse.Dao.GetBy(this));
            set => _studentCourses = value;
        }



        public override void Save()
        {
            Dao.Save(this);
        }
        public override void Delete()
        {
            Dao.Delete(Id);
        }

        private static StudentDao _dao;
        public static StudentDao Dao
            => _dao ?? (_dao = new StudentDao());


    }
}
namespace PracticaBootCamp.Dao
{
    public partial class StudentDao : DaoDb<Student>
    {
        public int GetDuplicateStudent(int User_Id)
=> int.Parse(GetScalarFromSP("GetDuplicateStudent", new { User_Id }));
        public List<Student> GetByIndexFilters( string UserName,int StudentStates)
    => GetFromSP("GetByIndexFilters", new { UserName, StudentStates });
        public Student GetByUser_Id(int UserId)
      => GetFirstFromSP("GetByUser_Id", new { UserId });
        public int GetCourseStudent(int CourseId)
         => int.Parse(GetScalarFromSP("GetCourseStudent", new { CourseId }));

    }
}