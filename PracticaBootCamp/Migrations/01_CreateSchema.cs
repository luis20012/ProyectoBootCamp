using System.Web.Hosting;
using FluentMigrator;

namespace DatabaseVersionControl
{

    [Migration(1)]
    public class CreateSchema : Migration
    {
        public override void Up()
        {
            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\CreateSchema.sql"));
        }

        public override void Down()
        {
            //
        }
    }
}