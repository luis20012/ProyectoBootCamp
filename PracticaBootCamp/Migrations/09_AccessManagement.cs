using System.Web.Hosting;
using FluentMigrator;

namespace DatabaseVersionControl
{

    [Migration(9)]
    public class CreateAccessManagement : Migration
    {
        public override void Up()
        {

            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\CreateAccessManagement.sql"));
        }

        public override void Down()
        {
            //
        }
    }
}