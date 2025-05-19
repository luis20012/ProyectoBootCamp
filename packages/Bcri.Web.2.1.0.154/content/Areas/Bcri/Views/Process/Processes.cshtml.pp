@using DNF.Security.Bussines
@using System.Configuration
@using Bcri.Core.Bussines
@using $rootnamespace$.Areas.Bcri.Models
@{var Res = $rootnamespace$.Res.res;}
@model Bcri.Core.Bussines.ProcessConfig
@{
	var PICs = Model.InputConfigs.Where(x => (x.Visibility.Code != "Hide" || Current.User.HasAccess("Developer")) && x.RepositoryConfig.Type.Code.ToLower() == "parametric" && Access.Dao.GetByFilter(new { url = "~/Repository/" + x.RepositoryConfig.Code + "/edit" }).Any(y => Current.User.HasAccess(y.Code)));
}
@{
	ViewBag.Title = Model?.Name;
}
<style type="text/css">
    #editProcess{
        float:left;
    }
    #editProcess:hover{
        color:black;
    }
	.margin {
		margin-top:5px;
		margin-bottom:5px;
	}
	.tab-container {
		padding: 5px;
		border-width: 0px 1px 1px;
		border-style: solid;
		border-color: rgb(221, 221, 221);
		border-image: initial;
		border-bottom-left-radius: 2.5px;
		border-bottom-right-radius: 2.5px;
	}
</style>
<div class="col-lg-12">
    <div class="ibox">
        <div class="ibox-title">
            <h5>@Model.Type.Name - @Model.Name</h5>
            <div class="ibox-tools">
                @if (Current.User.HasAccess(Model.AccessCode + "Configuration"))
				{
                    <a title=@Res.config href="@Url.Action("Index", "Config", new { processCode = Model.Code })" id="editProcess">
                        <i class="fa fa-edit"></i>
                    </a>
				}
                <a class="collapse-link">
                    <i class="fa fa-chevron-up"></i>
                </a>
            </div>
        </div>
        <div class="ibox-content">
			<ul class="nav nav-tabs">
				<li class="active">
					<a href="#processExcecuted" data-toggle="tab">@Res.processExecutions</a>
				</li>
				@if (PICs.Count() > 0)
				{
				<li>
					<a href="#processParam" data-toggle="tab">@Res.processParametric</a>
				</li>
				}
			</ul>
			<div class="tab-content">
				<div class="tab-pane fade in active tab-container" id="processExcecuted">
					@if (Current.User.HasAccess(Model?.AccessCode + "New"))
					{
						<div class="btn-group margin">
							<button type="button" id="NewSingle" class="btn btn-default">@Res.newNew</button>

							<button type="button" class="btn btn-default dropdown-toggle"
									data-toggle="dropdown">
								<span class="caret"></span>
								<span class="sr-only">@Res.openMenu</span>
							</button>

							<ul class="dropdown-menu" role="menu">
								<li><a href="#" id="NewRange">@Res.newRange</a></li>

							</ul>
						</div>
					}
					<table id="jqGridProcess"> </table>
					<div id="jqGridProcessPager"></div>
					<div id="processActionGridTemplate">
						<div class="processActionGrid" data-processId="" style="display: none">
							@if (Current.User.HasAccess(Model?.AccessCode + "ChangeState"))
							{
								<a data-action="Details" class="fa fa-database" title=@Res.viewDetails></a>
								<a data-action="Approve" class="fa fa-thumbs-o-up Approve" title=@Res.approve></a>
								if (Model.Regenerate == true)
								{
									<a data-action="Presented" class="fa fa-thumbs-o-up fa-bank" title=@Res.presented></a>
								}


								<a data-action="Refuse" class="fa fa-thumbs-o-down Refuse" title=@Res.rejected></a>

							}
							@if (Current.User.HasAccess("Developer"))
							{
								<a data-action="Delete" class="fa fa-trash Refuse" title=@Res.deleted></a>
								<a data-action="Export" class="fa fa-download" title=@Res.export></a>
							}
						</div>
					</div>
				</div>
				<div class="tab-pane fade tab-container" id="processParam">
					<div class="row">
						<div class="col-md-6">
							<select id="parametrics" class="form-control margin">
								@foreach (ProcessInputConfig parametric in PICs)
								{
									<option value="@parametric.Code" grid-attach="@parametric.Code">
										@parametric.Name
									</option>
								}
							</select>
						</div>
					</div>
					<div class="tab-content">
						@foreach (ProcessInputConfig parametric in PICs)
						{
							<div class="panel-body tab-pane fade @(Model.InputConfigs.IndexOf(parametric) == 0 ? "in active" : "")" id="@parametric.Code">
								<div class="row">
									<div class="col-lg-12">

										@Html.Partial("JqGridBcri", new GridModel
											{
												EntityName = parametric.RepositoryConfig.Code,
												GridId = parametric.Code + "-grid",
												RepositoryId = 0,
												RepositoryConfigId = parametric.RepositoryConfig.Id,
												Editable = true,
												Exportable = true,
												ServerSide = false
											})
									</div>
								</div>
							</div>
						}
					</div>
				</div>
			</div>
        </div>
    </div>
</div>
<div id="ProcessesJsData"
     data-editurl="@Url.Action("Add")"
     data-dataurl="@Url.Action("Data", new {Model?.Id})"
     data-detailurl="@Url.Action("ProcessDetail")"
     data-hasnew="@Current.User.HasAccess(Model?.AccessCode + "New").ToString().ToLower()">
</div>

@section scripts {
    @Scripts.Render("~/Areas/Bcri/Views/Process/Processes.js")
    @Html.Partial("New.js")
}

