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



namespace PracticaBootCamp.Bussines
{

    public partial class StateStudent : IEntityDao
    {
        public override long Id { get; set; }
        public string State { get; set; }
        private List<Student> _students;
        public List<Student> Students
        {
            get => _students ?? (_students = Student.Dao.GetBy(this));
            set => _students = value;
        }



        public override void Save()
        {
            Dao.Save(this);
        }
        public override void Delete()
        {
            Dao.Delete(Id);
        }

        private static StateStudentDao _dao;
        public static StateStudentDao Dao
            => _dao ?? (_dao = new StateStudentDao());


    }
}

namespace PracticaBootCamp.Dao
{
    public partial class StateStudentDao : DaoDb<StateStudent>
    {
    }
}


