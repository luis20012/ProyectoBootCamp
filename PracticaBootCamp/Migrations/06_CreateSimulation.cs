using System.Web.Hosting;
using FluentMigrator;

namespace DatabaseVersionControl
{

    [Migration(6)]
    public class CreateSimulation : Migration
    {
        public override void Up()
        {

            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\CreateSimulation.sql"));
        }

        public override void Down()
        {
            //
        }
    }
}