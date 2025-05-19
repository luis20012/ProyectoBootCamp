using System.Collections.Generic;
using System.Web.Mvc;
using System;
using System.Linq;
using System.Security.Principal;
using System.Web.Configuration;
using $rootnamespace$.Areas.Bcri.Models;
using System.Web.Routing;
using DNF.Security.Bussines;
using System.Web;
using System.Configuration;

namespace $rootnamespace$.Controllers
{
    [Authenticated]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            if (Current.User != null)
            {
                var uderId = Current.User;
                LogAccion.Dao.AddLog("LogIn", uderId.FullName, null);
            }
           
            
            return View();
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


