﻿using System.Web.Hosting;
using FluentMigrator;

namespace DatabaseVersionControl
{

    [Migration(3)]
    public class CreateProcedures : Migration
    {
        public override void Up()
        {

            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\CreateProcedures.sql"));
        }

        public override void Down()
        {
            //
        }
    }
}