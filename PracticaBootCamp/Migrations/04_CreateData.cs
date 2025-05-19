using System.Web.Hosting;
using FluentMigrator;

namespace DatabaseVersionControl
{

    [Migration(4)]
    public class CreateData : Migration
    {
        public override void Up()
        {
            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\CreateData.sql"));
        }

        public override void Down()
        {
            //
        }
    }
}