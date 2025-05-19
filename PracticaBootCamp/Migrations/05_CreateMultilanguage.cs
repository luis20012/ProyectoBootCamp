using System.Web.Hosting;
using FluentMigrator;

namespace DatabaseVersionControl
{

    [Migration(5)]
    public class CreateMultiLanguage : Migration
    {
        public override void Up()
        {

            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\CreateMultiLanguage.sql"));
        }

        public override void Down()
        {
            //
        }
    }
}