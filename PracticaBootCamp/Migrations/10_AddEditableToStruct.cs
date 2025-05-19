using System.Web.Hosting;
using FluentMigrator;

namespace DatabaseVersionControl
{

    [Migration(10)]
    public class AddEditField : Migration
    {
        public override void Up()
        {

            Execute.Script(HostingEnvironment.MapPath(@"~\Migrations\AddEditableToStruct.sql"));
        }

        public override void Down()
        {
            //
        }
    }
}