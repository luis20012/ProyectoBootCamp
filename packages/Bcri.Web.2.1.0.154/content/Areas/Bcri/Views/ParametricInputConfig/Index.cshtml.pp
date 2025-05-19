@using DNF.Security.Bussines
@{var Res = $rootnamespace$.Res.res;}
@model Bcri.Core.Bussines.ProcessConfig
@{
    Layout = "";
}

<div class="ibox">
    <div class="ibox-title">
        <h5>@Res.parametrics</h5>
        <div class="ibox-tools">
            <a class="collapse-link">
                <i class="fa fa-chevron-up"></i>
            </a>
        </div>
    </div>
    <div class="ibox-content">
        <table id="jqGridParametricInputConfig"> </table>
        <div id="jqGridParametricInputConfigPager"></div>
    </div>
</div>

<div id="ParametricInputConfigJsData"
        data-dataUrl="@Url.Action("ProcessInputData")"
        data-edit="@Current.User.HasAccess("ProcessInputConfigEdit").ToString().ToLower()"
        data-editUrl="@Url.Action("ProcessInputConfigEdit")"
        data-processconfigid="@Model.Id"
        data-optionsdataurl="@Url.Action("GetOptionsData")">

</div>

@section scripts {
    @Scripts.Render("~/Areas/Bcri/Views/ParametricInputConfig/Index.js")
}
