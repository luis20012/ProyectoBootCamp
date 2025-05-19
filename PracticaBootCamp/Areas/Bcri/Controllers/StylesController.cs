using System.Web.Mvc;

namespace RazorForCssAndJs.Controllers
{
    public class StylesController : Controller
    {
        public ActionResult Index()
        {
            return Content("Styles folder");
        }

        protected override void HandleUnknownAction(string actionName)
        {
            var res = this.CssFromView(actionName);
            res.ExecuteResult(ControllerContext);
        }
    }
}

