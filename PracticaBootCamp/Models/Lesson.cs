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

    public partial class Lesson : IEntityDao
    {
        public override long Id { get; set; }

        [Required(ErrorMessage ="El titulo del video es obligatorio")]
        public string Title { get; set; }
        [Required(ErrorMessage = "La descripcion del video es obligatoria")]
        public string Description { get; set; }
        [Required(ErrorMessage = "La Url es obligatoria")]
        public string Url { get; set; }
        public bool? Enabled { get; set; }
        private List<LessonCourse> _lessonCourses;
        public List<LessonCourse> LessonCourses
        {
            get => _lessonCourses ?? (_lessonCourses = LessonCourse.Dao.GetBy(this));
            set => _lessonCourses = value;
        }


        public int LessonCourseActives { get; set; }
        public override void Save()
        {
            Dao.Save(this);
        }
        public override void Delete()
        {
            Dao.Delete(Id);
        }

        private static LessonDao _dao;
        public static LessonDao Dao
            => _dao ?? (_dao = new LessonDao());

    }
}

namespace PracticaBootCamp.Dao
{
    public partial class LessonDao : DaoDb<Lesson>
    {
        public int GetLastOrder()
           => int.Parse(GetScalarFromSP("GetLastOrder"));

        public Lesson GetByTitle(string Title)
            => GetFirstFromSP("GetByTitle", new { Title });

        public List<Lesson> GetByIndexFilter(string Title, string Enabled)
            => GetFromSP("GetByIndexFilter", new { Title });
        public int GetCourseLesson(int CourseId)
          => int.Parse(GetScalarFromSP("GetCourseLesson", new { CourseId }));
    }
}


