@using DNF.Security.Bussines
@{var Res = $rootnamespace$.Res.res;}

@{
    ViewBag.Title = Res.users;
}
<div class="ibox">
    <div class="ibox-title">
        <h5>@Res.users</h5>
        <div class="ibox-tools">
            <a class="collapse-link">
                <i class="fa fa-chevron-up"></i>
            </a>
        </div>
    </div>
    <div class="ibox-content">
        <div id="buttonExport" style="text-align:right;">
            <div class="menuRibbon-item">
                @if (ViewBag.HabilitadoBotonExportXls)
                {
                    <button type="button" class="btn btn-default btn-lg" onclick="javascript: CallBtnExportXls();" title="Descargar Excel">
                        <i class="fa fa-file-excel-o"></i>
                    </button>

                }
                @if (ViewBag.HabilitadoBotonExportPdf)
                {
                    <button type="button" class="btn btn-default btn-lg" onclick="javascript: CallBtnExportPdf();" title="Descargar PDF">
                        <i class="fa fa-file-pdf-o"></i>

                    </button>

                }
                @if (ViewBag.HabilitadoBotonExportTxt)
                {
                    <button type="button" class="btn btn-default btn-lg" onclick="javascript: CallBtnExportTxt();" title="Descargar TXT">
                        <i class="fa fa-file-text-o"></i>

                    </button>

                }
            </div>
        </div>

        <div class="row">
            <div class="panel-body">
                <div class="col-lg-12">
                    <table id="jqGridUsers"> </table>
                    <div id="jqGridUsersPager"></div>
                </div>
            </div>
        </div>

        <div id="profilesControl" style="display: none">
            @*template para el user edit*@
            <ul class="list-group checked-list-box " style="max-height: 200px; overflow: auto;">
                @foreach (var profile in (List<SelectListItem>)ViewBag.Profiles)
                {
                    <li class="list-group-item">
                        <label class="checkbox"><input type="checkbox" class="" value="@profile.Value">@profile.Text</label>
                    </li>
                }
            </ul>
        </div>
    </div>
</div>
<div id="UsersJsData" @*common data para el js*@
        data-dataUrl="@Url.Action("UsersData")"
        data-editUrl="@Url.Action("UserEdit")"
        data-password="@System.Configuration.ConfigurationManager.AppSettings["UseActiveDirectory"]"
        data-accessEdit="@Current.User.HasAccess("UserEdit").ToString().ToLower()"
        data-accessNew="@Current.User.HasAccess("UserNew").ToString().ToLower()"
        data-accessDelete="@Current.User.HasAccess("UserDelete").ToString().ToLower()">

</div>
<script type="text/javascript">

    function CallBtnExportXls() {
        var urlGrid = '@Url.Action("exportExcel", "Security")?tittle=' + "Usuarios" + "&fromDate=" + "" + "&toDate=" + "" + "&act01=" + "";
        var sLink = urlGrid;
        window.location.href = sLink;
    }

    function CallBtnExportPdf() {
        var urlGrid = '@Url.Action("exportPDF", "Security")?tittle=' + "Usuarios" + "&fromDate=" + "" + "&toDate=" + "" + "&act01=" + "";
        var sLink = urlGrid;
        window.location.href = sLink;
    }
    function CallBtnExportTxt() {
        var urlGrid = '@Url.Action("exportTXT", "Security")?tittle=' + "Usuarios" + "&fromDate=" + "" + "&toDate=" + "" + "&act01=" + "";
        var sLink = urlGrid;
        window.location.href = sLink;
    }
</script>
@section scripts {
    @Scripts.Render("~/Areas/Bcri/Views/Security/Users.js")
}


