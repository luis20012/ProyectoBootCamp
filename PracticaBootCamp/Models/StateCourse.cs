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

    public partial class StateCourse : IEntityDao
    {
        public override long Id { get; set; }
        [Required(ErrorMessage = "El campo Estado es obligatorio.")]
        public string State { get; set; }
        private List<Course> _courses;
        public List<Course> Courses
        {
            get => _courses ?? (_courses = Course.Dao.GetBy(this));
            set => _courses = value;
        }



        public override void Save()
        {
            Dao.Save(this);
        }
        public override void Delete()
        {
            Dao.Delete(Id);
        }

        private static StateCourseDao _dao;
        public static StateCourseDao Dao
            => _dao ?? (_dao = new StateCourseDao());


    }
}

namespace PracticaBootCamp.Dao
{
    public partial class StateCourseDao : DaoDb<StateCourse>
    {
    }
}






