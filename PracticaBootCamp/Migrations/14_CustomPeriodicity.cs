using System.Web.Hosting;
using FluentMigrator;

namespace Bcri.Web.Migrations
{
    [Migration(14)]
    public class CustomPeriodicity : Migration
    {

        public override void Up()
        {
            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\CustomPeriodicity.sql"));
        }

        public override void Down()
        {
            //
        }
    }

}