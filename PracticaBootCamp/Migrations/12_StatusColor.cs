using System.Web.Hosting;
using FluentMigrator;

namespace Bcri.Web.Migrations
{
    [Migration(12)]
    public class StatusColor : Migration
    {

        public override void Up()
        {
            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\StatusColor.sql"));
        }

        public override void Down()
        {
            //
        }
    }

}