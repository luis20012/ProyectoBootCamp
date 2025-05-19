using System.Web.Mvc;
using Bcri.Core.Releaser;

namespace PracticaBootCamp.Areas.Bcri.Utility
{
    public class ExportResult : ActionResult
    {

        protected ExportBase exporter;
        protected ExportFormat format;
        public ExportResult(ExportFormat format, ExportBase Export)
        {
            this.format = format;
            this.exporter = Export;
        }

        public override void ExecuteResult(ControllerContext context)
        {

            var response = context.HttpContext.Response;
            response.ClearHeaders();
            response.ContentType = "text/text";

            exporter.format = format;
            exporter.SetStream(response.OutputStream);

            response.AddHeader("content-disposition", $"attachment; filename = {exporter.FileName}.{exporter.FileExtencion}");
            response.Buffer = false;
            response.BufferOutput = false;

            exporter.Export();
        }
    }
}
