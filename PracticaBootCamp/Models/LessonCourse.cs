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

    public partial class LessonCourse : IEntityDao
    {
        public override long Id { get; set; }
        [Required(ErrorMessage =("Elegir el video para relacionar con el curso"))]
        public Lesson Lesson { get; set; }
        public List<Lesson> Lessons { get; set; }
        [Required(ErrorMessage = ("Elegir el curso para relacionar con el video"))]
        public Course Course { get; set; }
        public List<Course> courses { get; set; }


        public override void Save()
        {
            Dao.Save(this);
        }
        public override void Delete()
        {
            Dao.Delete(Id);
        }

        private static LessonCourseDao _dao;
        public static LessonCourseDao Dao
            => _dao ?? (_dao = new LessonCourseDao());

    }
}

namespace PracticaBootCamp.Dao
{
    public partial class LessonCourseDao : DaoDb<LessonCourse>
    {
        public int GetDuplicateValues(int CourseId, int LessonId)
            => int.Parse(GetScalarFromSP("GetDuplicateValues", new { CourseId, LessonId }));

        public int GetByIndexFilter(int Id)
  => int.Parse(GetScalarFromSP("GetByIndexFilter", new { Id }));
        public int GetLessonCourse(int CourseId)
         => int.Parse(GetScalarFromSP("GetLessonCourse", new { CourseId }));

        public int GetByFilterLC( int CourseId, int LessonId)
      => int.Parse(GetScalarFromSP("GetByFilterLC", new {  CourseId,LessonId }));



    }
}






