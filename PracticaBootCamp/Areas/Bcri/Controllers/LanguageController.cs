using System.Globalization;
using System.Web.Mvc;
using DNF.Security.Bussines;
using Type = DNF.Type.Bussines.Type;
namespace PracticaBootCamp.Areas.Bcri.Controllers
{
    public class LanguageController : Controller
    {
        // GET: Bcri/Language
        public ActionResult Change(string culture)
        {
            Current.User.Language = new Type("Language", culture);
            Current.User.Save();
            System.Threading.Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(culture);
            return new EmptyResult();
        }
    }
}
