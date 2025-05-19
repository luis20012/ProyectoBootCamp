@{var Res = $rootnamespace$.Res.res;}
@{
	ViewBag.Title = "Simulation";
}
<div class="row">
	<div class="col-lg-12">
		<h1 id="ProcessTitle" class="page-header">
			@Res.simulation
		</h1>
	</div>
</div>

<div class="container-fluid">
	<div class="row">
		<div class="col-lg-12">
			<button type="button" id="New" class="btn btn-default">@Res.newNew</button>

			<table id="gridSimulation"> </table>
			<div id="gridSimulationPager"></div>
		</div>
	</div>
</div>

<div id="simulationActionTemplate">
	<div class="processActionGrid" data-processId="" style="display: none">
		<a data-action="Join" class="fa fa-sign-in Approve" title="@Res.join"> @Res.join</a>
		<a data-action="Left" class="fa fa-sign-out Refuse" title="@Res.left"> @Res.left</a>
		<a data-action="Delete" class="fa fa-trash Refuse" title=@Res.deleted></a>
		<a data-action="Export" class="fa fa-download" title=@Res.export></a>
	</div>

</div>

<div id="simulationCreateForm" hidden="hidden">
	<form>
		<div class="row">
			<div class="col-lg-12">
				<div class="form-group">
					@Html.Label(@Res.name) @*remplazar por el role desde el js al elegir agreement*@
					@Html.TextBox("Name", "", new { maxLength = 100, required = true, @class = "form-control" })
				</div>
				<div class="form-group">
					<label>Simulation Data</label>
					<div class="radio">
						<label>
							<input type="radio" name="SimulationData" id="Current" value="Current" checked="">Current 
						</label>
					</div>
					<div class="radio">
						<label>
							<input type="radio" name="SimulationData" id="Empty" value="Empty">Empty
						</label>
					</div>
				</div>
			</div>
		</div>
	</form>
</div>


@section scripts
{
	@Scripts.Render("~/Areas/Bcri/Views/Simulation/Index.js")
}
