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
using System.ComponentModel.DataAnnotations;



namespace PracticaBootCamp.Bussines
{

    public partial class TeacherCourse : IEntityDao
    {
        public override long Id { get; set; }
        [Required(ErrorMessage = ("Asignar el porfesor al curso"))]
        public Teacher Teacher { get; set; }
        [Required(ErrorMessage = ("Elegir el curso a cual asignar"))]
        public Course Course { get; set; }

        public override void Save()
        {
            Dao.Save(this);
        }
        public override void Delete()
        {
            Dao.Delete(Id);
        }

        private static TeacherCourseDao _dao;
        public static TeacherCourseDao Dao
            => _dao ?? (_dao = new TeacherCourseDao());
    }
}


namespace PracticaBootCamp.Dao
{
    public partial class TeacherCourseDao : DaoDb<TeacherCourse>
    {
        public int GetDuplicateValues(int CourseId, int TeaherId)
            => int.Parse(GetScalarFromSP("GetDuplicateValues", new { CourseId, TeaherId }));

        public List<TeacherCourse> GetByIndexFilter(int Course_Id, long? Teacher_Id)
           => GetFromSP("GetByIndexFilter", new { Course_Id, Teacher_Id });

        public TeacherCourse GetByTeacher_Id(long TeacherId)
  => GetFirstFromSP("GetByStudent_id", new { TeacherId });
    }

}


