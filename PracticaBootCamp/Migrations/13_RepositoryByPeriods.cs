using System.Web.Hosting;
using FluentMigrator;

namespace Bcri.Web.Migrations
{
    [Migration(13)]
    public class RepositoryByPeriods : Migration
    {

        public override void Up()
        {
            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\RepositoryByPeriods.sql"));
        }

        public override void Down()
        {
            //
        }
    }

}