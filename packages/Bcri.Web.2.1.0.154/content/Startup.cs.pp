using System.Configuration;
using System.Reflection;
using $rootnamespace$;
using DNF.Release.Bussines;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(Startup))]
namespace $rootnamespace$
{
    public partial class Startup
    {


        public void Configuration(IAppBuilder app)
        {

        }
    }
}

