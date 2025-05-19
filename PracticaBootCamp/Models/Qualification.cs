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

    public partial class Qualification : IEntityDao
    {
        public override long Id { get; set; }
        public string Qualy { get; set; }
        public DateTime? LastModification { get; set; }
        public StudentCourse StudentCourse { get; set; }



        public override void Save()
        {
            Dao.Save(this);
        }
        public override void Delete()
        {
            Dao.Delete(Id);
        }

        private static QualificationDao _dao;
        public static QualificationDao Dao
            => _dao ?? (_dao = new QualificationDao());

    }
}

namespace PracticaBootCamp.Dao
{
    public partial class QualificationDao : DaoDb<Qualification>
    {
    }
}




