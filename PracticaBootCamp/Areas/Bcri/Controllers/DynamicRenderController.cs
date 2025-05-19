using System.Web.Mvc;

namespace PracticaBootCamp.Areas.Bcri.Controllers
{

    public class DynamicRenderController : Controller
    {
        protected override void HandleUnknownAction(string actionName)
        {
            var res = this.JavaScriptFromView();
            res.ExecuteResult(ControllerContext);
        }
    }
}
