using System.Web.Mvc;

namespace PracticaBootCamp.Areas.Bcri
{
    public class BcriAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Bcri";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {

            context.MapRoute(
                "Process", // Route name
                "Process/{processCode}/{action}/{Id}", // URL with parameters
                new { controller = "Process", action = "Processes", id = UrlParameter.Optional, area = "Bcri" },
                new { controller = "Process" },
                new[] { "PracticaBootCamp.Areas.Bcri.Controllers" } // Parameter defaults
            );

            context.MapRoute(
               "ConfigCreate", // Route name
               "Config/CreateConfig", // URL with parameters
               new { controller = "Config", action = "CreateConfig", id = UrlParameter.Optional, area = "Bcri" },
               new { controller = "Config", action = "CreateConfig" },
               new[] { "PracticaBootCamp.Areas.Bcri.Controllers" } // Parameter defaults
           );


            context.MapRoute(
                "Config", // Route name
                "Config/{processCode}/{action}/{Id}", // URL with parameters
                new { controller = "Config", action = "Index", id = UrlParameter.Optional, area = "Bcri" },
                new { controller = "Config" },
                new[] { "PracticaBootCamp.Areas.Bcri.Controllers" } // Parameter defaults
            );

            context.MapRoute(
                "Diagram", // Route name
                "Diagram/{action}/{entity}", // URL with parameters
                new { controller = "Diagram", action = "Entity", entity = UrlParameter.Optional },
                new { controller = "Diagram" },
                new[] { "PracticaBootCamp.Areas.Bcri.Controllers", "PracticaBootCamp.Controllers" } // Parameter defaults
            );

            context.MapRoute(
               "Grid", // Route name
               "Grid/{action}/{entityName}", // URL with parameters
               new { controller = "Grid", action = "Index", id = UrlParameter.Optional, area = "Bcri" },
               new { controller = "Grid" },
               new[] { "PracticaBootCamp.Areas.Bcri.Controllers" } // Parameter defaults
            );


            context.MapRoute(
               "RepositoryLoadModelData", // Route name
               "Repository/LoadColModelAndData/{Id}", // URL with parameters
               new { controller = "Repository", action = "LoadColModelAndData", id = UrlParameter.Optional, area = "Bcri" },
               new { controller = "Repository" },
               new[] { "PracticaBootCamp.Areas.Bcri.Controllers" } // Parameter defaults
            );

            context.MapRoute(
               "Repository", // Route name
               "Repository/{repositoryCode}/{action}/{Id}", // URL with parameters
               new { controller = "Repository", action = "Index", id = UrlParameter.Optional, area = "Bcri" },
               new { controller = "Repository" },
               new[] { "PracticaBootCamp.Areas.Bcri.Controllers" } // Parameter defaults
            );


            context.MapRoute(
                "Wizard_default",
                "Wizard/{action}/{entity}",
                new { controller = "Wizard", action = "Entity", entity = UrlParameter.Optional },
                new { controller = "Wizard" },
                new[] { "PracticaBootCamp.Areas.Bcri.Controllers", "PracticaBootCamp.Controllers" }
            );

            context.MapRoute(
                "RESTLogin",
                "api/login",
                new { controller = "Login", action = "LoginREST" },
                new { controller = "Login" },
                new[] { "Pmp.Web.Areas.Bcri.Controllers", "Pmp.Web.Controllers" }
            );

            context.MapRoute(
                "RESTReport",
                "api/report",
                new { controller = "Report", action = "DataREST" },
                new { controller = "Report" },
                new[] { "Pmp.Web.Areas.Bcri.Controllers", "Pmp.Web.Controllers" }
            );

            context.MapRoute(
              "Bcri_default",
              "{controller}/{action}/{id}",
              new { action = "Index", id = UrlParameter.Optional },
              namespaces: new[] { "PracticaBootCamp.Areas.Bcri.Controllers", "PracticaBootCamp.Controllers" }
            );


            BcriConfig.Register();

        }
    }
}
