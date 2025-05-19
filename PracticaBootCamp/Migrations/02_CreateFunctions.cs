using System.Web.Hosting;
using FluentMigrator;

namespace DatabaseVersionControl
{

    [Migration(2)]
    public class CreateFunctions : Migration
    {
        public override void Up()
        {

            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\CreateFunctions.sql"));
        }

        public override void Down()
        {
            //
        }
    }
}