using System;
using System.Configuration;
using System.Web.Mvc;
using DNF.Security.Bussines;

namespace PracticaBootCamp.Controllers
{
    [Authenticated]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            if (Current.User != null)
            {
                var uderId = Current.User;
                LogAccion.Dao.AddLog("LogIn", uderId.Name, null);
            }


            return RedirectToAction("IndexPrincipal","Course");
        }

        [HttpPost]
        public JsonResult closeLogOut()
        {
            if (Convert.ToBoolean(ConfigurationManager.AppSettings["UseActiveDirectory"]))
            {
                LogAccion.Dao.AddLog("LogOut"
                    , Current.User.Name
                    , null);

            }
            Session.Clear();
            Session.Abandon();
            Request.Cookies["ASP.NET_SessionId"].Value = string.Empty;
            return this.Json(new { success = true });
        }

    }
}


