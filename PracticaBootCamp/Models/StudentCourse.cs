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

    public partial class StudentCourse : IEntityDao
    {
        public override long Id { get; set; }

        public double? Average { get; set; }
        [Required(ErrorMessage ="Es obligatorio elegir el estudiante")]
        public Student Student { get; set; }
        [Required(ErrorMessage = "Es obligatorio elegir el curso")]
        public Course Course { get; set; }
        //private List<Qualification> _qualifications;
        //public List<Qualification> Qualifications
        //{
        //    get => _qualifications ?? (_qualifications = Qualification.Dao.GetBy(this));
        //    set => _qualifications = value;
        //}



        public override void Save()
        {
            Dao.Save(this);
        }
        public override void Delete()
        {
            Dao.Delete(Id);
        }

        private static StudentCourseDao _dao;
        public static StudentCourseDao Dao
            => _dao ?? (_dao = new StudentCourseDao());



    }
}
namespace PracticaBootCamp.Dao
{
    public partial class StudentCourseDao : DaoDb<StudentCourse>
    {
        public int GetDuplicateValues(int Course_Id, int Student_Id)
            => int.Parse(GetScalarFromSP("GetDuplicateValues", new { Course_Id, Student_Id }));

        public List<StudentCourse> GetByIndexFilter(int IdCourse, long? Student_Id)
           => GetFromSP("GetByIndexFilter", new { IdCourse, Student_Id });
        public StudentCourse GetByStudent_id(long StudentId)
       => GetFirstFromSP("GetByStudent_id", new { StudentId });

    }

}