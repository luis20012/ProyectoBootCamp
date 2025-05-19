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

    public partial class Course : IEntityDao, IName, IDescription
    {
        public override long Id { get; set; }
        [Required(ErrorMessage = "El campo Nombre es obligatorio.")]
        public string Name { get; set; }
        [Required(ErrorMessage = "El campo Descripción es obligatorio.")]
        public string Description { get; set; }
        [Required(ErrorMessage = "El campo Duración es obligatorio.")]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? StartDate { get; set; }

        [Required(ErrorMessage = "El campo Fecha de finalización es obligatorio.")]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? EndDate { get; set; }
        [Required(ErrorMessage = "El campo estado del curso es obligatorio.")]
     
        public StateCourse StateCourse { get; set; }
        //public string Image { get; set; }
        private List<LessonCourse> _lessonCourses;
        public List<LessonCourse> LessonCourses
        {
            get => _lessonCourses ?? (_lessonCourses = LessonCourse.Dao.GetBy(this));
            set => _lessonCourses = value;
        }
       
        private List<StudentCourse> _studentCourses;
        public List<StudentCourse> StudentCourses
        {
            get => _studentCourses ?? (_studentCourses = StudentCourse.Dao.GetBy(this));
            set => _studentCourses = value;
        }
        private List<TeacherCourse> _teacherCourses;
        public List<TeacherCourse> TeacherCourses
        {
            get => _teacherCourses ?? (_teacherCourses = TeacherCourse.Dao.GetBy(this));
            set => _teacherCourses = value;
        }
        public int GetCourseLessonActive { get; set; }
        public int GetCourseStudentActive { get; set; }


        public override void Save()
        {

            Dao.Save(this);
        }
        public override void Delete()
        {
            Dao.Delete(Id);
        }

        private static CourseDao _dao;
        public static CourseDao Dao
            => _dao ?? (_dao = new CourseDao());

    }
}


namespace PracticaBootCamp.Dao
{
    public partial class CourseDao : DaoDb<Course>
    {
        public int GetLastOrder()
            => int.Parse(GetScalarFromSP("GetLastOrder"));
        public int GetDuplicateCourseName(string CourseName)
            => int.Parse(GetScalarFromSP("GetDuplicateCourseName", new { CourseName }));
        public List<Course> GetByIndexFilter( string name,int StateCourse)
            => GetFromSP("GetByIndexFilter", new { name , StateCourse });
        
      public List<Course> GetCourseLessonActive(string name)
            => GetFromSP("GetCourseLessonActive", new { name });
        public int GetDuplicateCourse(string Name)
          => int.Parse(GetScalarFromSP("GetDuplicateCourse", new { Name }));
    }
}
