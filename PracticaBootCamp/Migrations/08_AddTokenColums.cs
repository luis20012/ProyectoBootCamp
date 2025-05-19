using System.Web.Hosting;
using FluentMigrator;

namespace DatabaseVersionControl
{

    [Migration(8)]
    public class AddTokenColums : Migration
    {
        public override void Up()
        {

            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\AddTokenColums.sql"));
        }

        public override void Down()
        {
            //
        }
    }
}