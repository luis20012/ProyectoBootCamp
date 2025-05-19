using System.Web.Hosting;
using FluentMigrator;

namespace DatabaseVersionControl
{

    [Migration(11)]
    public class ProcessAccessDefaultWithRes : Migration
    {
        public override void Up()
        {
            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\ProcessAccessDefaultWithRes.sql"));
        }

        public override void Down()
        {
            //
        }
    }
}