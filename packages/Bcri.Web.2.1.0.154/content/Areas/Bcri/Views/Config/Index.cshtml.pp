@using System.Collections.Generic
@{var Res = $rootnamespace$.Res.res;}
@model Bcri.Core.Bussines.ProcessConfig
@{
    ViewBag.Title = @Res.settings;
}
<div class="row">
    <div class="col-lg-12">
        <div id="configSaveAlert"></div>
        <form id="configForm">
            <div class="row">
                <div class="col-lg-6">
                    <div class="ibox">
                        <div class="ibox-title">
                            <h5>@Res.general</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            @Html.HiddenFor(x => x.Id)
                            <div class="form-group">
                                <label>@Res.type</label>
                                @Html.DropDownListFor(x => x.Type.Id, (List<SelectListItem>)ViewBag.ProcessTypes, new { @class = "form-control" })
                            </div>
                            <div class="form-group">
                                <label>@Res.name</label>
                                @Html.TextBoxFor(x => x.Name, new { @class = "form-control" })
                                <p class="help-block">Display name in titles, menus, etc.</p>
                            </div>
                            <div class="form-group">
                                <label>@Res.code</label>
                                @Html.TextBoxFor(x => x.Code, new { disabled = !Model.IsNew(), @class = "form-control", maxlength = 50 })
                            </div>


                            <div class="form-group">
                                <label>@Res.description</label>
                                @Html.TextAreaFor(x => x.Description, new { @class = "form-control", maxlength = 4050 })
                                <p class="help-block">@Res.businessDescription</p>
                            </div>
                        </div>
                    </div>
                </div>
                @*convertir la parte de proceso en algo mucho mas intuitivo con elecciones simples*@
                @*<div class="form-group">
                <label>Clase a Ejecutar</label>
                @Html.TextBoxFor(x => x.Class, new { @class = "form-control" })
            </div>*@
                @*convertir la parte de proceso en algo mucho mas intuitivo con elecciones simples*@
                <div class="col-lg-6">
                    <div class="ibox">
                        <div class="ibox-title">
                            <h5>@Res.automation</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <div class="form-group">
                                <div class="checkbox">
                                    <label>@Html.CheckBoxFor(x => x.AutoExecute) @Res.execution</label>
                                    <p class="help-block">@Res.helpBlockAutomation</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="checkbox">
                                    <label>@Html.CheckBoxFor(x => x.AutoApprove) @Res.approval</label>
                                    <p class="help-block">@Res.helpBlockApproval</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="checkbox">
                                    <label>@Html.CheckBoxFor(x => x.Regenerate) @Res.reprocess</label>
                                    <p class="help-block">@Res.helpBlockReprocess</p>
                                </div>
                            </div>
                            <div class="form-group formAuto">
                                <label>@Res.executionTime</label>
                                <div class="input-group date" id="executeOnTimePicker">
                                    @Html.TextBox("ExecuteOnTime", Model.ExecuteOnHour.ToString("00") + ":" + Model.ExecuteOnMinute.ToString("00"), new { @class = "form-control", maxlength = 5 })
                                    <span class="input-group-addon">
                                        <span class="glyphicon glyphicon-time"></span>
                                    </span>
                                </div>
                            </div>
                            <div class="form-group formAuto">
                                <label>@Res.runProcessAfter</label>
                                @Html.DropDownListFor(x => x.ExecuteDelayDays, (List<SelectListItem>)ViewBag.ExecuteDelayDayss, new { @class = "form-control" })
                                <p class="help-block">@Res.helpBlockRunProcessAfter</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="ibox">
                        <div class="ibox-title">
                            <h5>@Res.frequency</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <div class="form-group">
                                <label>@Res.priodicity</label>
                                @Html.DropDownListFor(x => x.Frequency.Id, (List<SelectListItem>)ViewBag.Frequencys, new { @class = "form-control" })
                            </div>
                            <div class="form-group">
                                <label>@Res.holydays</label>
                                @Html.DropDownListFor(x => x.HolyDays.Id, (List<SelectListItem>)ViewBag.HolyDayss, new { @class = "form-control" })
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <button type="submit" id="configSave" class="btn btn-primary">@Res.save</button>
                </div>
            </div>
            <hr />
        </form>
    </div>
</div>

<div id="configIndexjsData"
     data-saveurl="@Url.Action("Save", new {processCode = Model.Code})"></div>

<div class="row">
    <div class="col-lg-12">
        <h2>@Res.InputRepositories</h2>
    </div>
    <div class="col-lg-12">
        @{Html.RenderAction("Index", "ParametricInputConfig", new { ProcessConfigId = Model.Id });}
    </div>
    <div class="col-lg-12">
        @{Html.RenderAction("Index", "ProcessInputConfig", new { ProcessConfigId = Model.Id });}
    </div>
    <div class="col-lg-12">
        <hr />
        <h2>@Res.OutputRepositories</h2>
    </div>
    <div class="col-lg-12">
        @{Html.RenderAction("Index", "ProcessOutputConfig", new { ProcessConfigId = Model.Id });}
    </div>
</div>
<div class="row">
    <div class="col-lg-12">
        <hr />
        <h2>@Res.busines</h2>
        @Html.Partial("ProcessUnit", Model)
    </div>
</div>


    @section scripts {
        @Scripts.Render("~/Areas/Bcri/Views/Config/Index.js")

        @Scripts.Render("~/Areas/Bcri/Views/Config/ProcessUnit.js")
        @Scripts.Render("~/Areas/Bcri/Views/BcpImport/Index.js")
        @Scripts.Render("~/Areas/Bcri/Views/SpProcess/Index.js")


        @Scripts.Render("~/Areas/Bcri/Views/ProcessInputConfig/Index.js")
        @Scripts.Render("~/Areas/Bcri/Views/ParametricInputConfig/Index.js")
        @Scripts.Render("~/Areas/Bcri/Views/ProcessOutputConfig/Index.js")
    }


