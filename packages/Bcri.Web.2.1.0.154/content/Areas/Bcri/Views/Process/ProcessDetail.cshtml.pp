@using DNF.Security.Bussines
@{var Res = $rootnamespace$.Res.res;}
@model Bcri.Core.Bussines.Process
@{
    ViewBag.Title = $"{Model.Config.Type.Name} - {Model.Config.Name} - {Model.Period.ToShortDateString() } - V{Model.Version}";
}
<div class="ibox">
    <div class="ibox-title">
        <h5>@ViewBag.Title</h5>
        <div class="ibox-tools">
            <a class="collapse-link">
                <i class="fa fa-chevron-up"></i>
            </a>
        </div>
    </div>
    <div class="ibox-content">
        <ul class="nav nav-tabs">
            <li class="active">
                <a href="#outputs" data-toggle="tab">@Res.results</a>
            </li>
            <li>
                <a href="#inputs" id="tabInputs" data-toggle="tab">@Res.sources</a>
            </li>
        </ul>
        <div class="tab-content">
            <div class="tab-pane fade in active row" id="outputs">
                @Html.Partial("Outputs", Model.Outputs)
            </div>
            <div class="tab-pane fade row" id="inputs">
                @Html.Partial("Inputs", Model.Inputs)
            </div>
        </div>
    </div>
</div>
@section scripts
{
    @Scripts.Render("~/Areas/Bcri/Views/Process/ProcessDetail.js")
}
