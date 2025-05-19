using Microsoft.Owin;
using Owin;
using PracticaBootCamp;

[assembly: OwinStartup(typeof(Startup))]
namespace PracticaBootCamp
{
    public partial class Startup
    {


        public void Configuration(IAppBuilder app)
        {

        }
    }
}

