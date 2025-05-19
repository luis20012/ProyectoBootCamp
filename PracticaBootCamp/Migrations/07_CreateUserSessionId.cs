using System.Web.Hosting;
using FluentMigrator;

namespace DatabaseVersionControl
{

    [Migration(7)]
    public class CreateUserSessionId : Migration
    {
        public override void Up()
        {

            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\CreateUserSessionId.sql"));
        }

        public override void Down()
        {
            //
        }
    }
}