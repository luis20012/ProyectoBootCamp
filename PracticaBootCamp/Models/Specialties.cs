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

    public partial class Specialties : IEntityDao, IDescription
    {
        public override long Id { get; set; }
        public string Description { get; set; }
        public Teacher Teacher { get; set; }

        public bool? Enabled { get; set; }

        public override void Save()
        {
            Dao.Save(this);
        }
        public override void Delete()
        {
            Dao.Delete(Id);
        }

        private static SpecialtiesDao _dao;
        public static SpecialtiesDao Dao
            => _dao ?? (_dao = new SpecialtiesDao());

    }
}

namespace PracticaBootCamp.Dao
{
    public partial class SpecialtiesDao : DaoDb<Specialties>
    {
    }
}
