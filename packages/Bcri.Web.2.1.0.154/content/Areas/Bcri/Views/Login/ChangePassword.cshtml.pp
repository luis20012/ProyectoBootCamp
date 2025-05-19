@model $rootnamespace$.Areas.Bcri.Models.GeneratePass
@{var Res = $rootnamespace$.Res.res;}

<div class="col-lg-12">
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
			<div class="container-fluid">
				<div class="row">
					<h1 class="page-header">@Res.changePass</h1>

				</div>
				<div class="row">
					<div class="col-lg-6">
						<form id="password" method="POST">
							@if (ViewData["error"] != null)
							{
								<div class="alert alert-danger">
									@ViewData["error"]
								</div>
							}
							@if (ViewData["Ok"] != null)
							{
								<div class="alert alert-success">
									@Res.succesHasChangedPass
								</div>

							}

							@Html.HiddenFor(x => x.id)

							<div class="form-group">
								<label>@Res.currentPassword</label>
								@Html.PasswordFor(x => x.ActualPassword, new { @class = "form-control", @placeholder = @Res.currentPassword, @type = "password" })
							</div>

							<div class="form-group">
								<label>@Res.newPass</label>
								@Html.PasswordFor(x => x.Password, new { @class = "form-control", @placeholder = @Res.newPass, @type = "password" })
							</div>
							<div class="form-group">
								<label>@Res.repeatPass</label>
								@Html.PasswordFor(model => model.ConfirmPassword, new { @class = "form-control", @placeholder = @Res.repeatPass, @type = "password" })
								@Html.ValidationMessageFor(x => x.ConfirmPassword)
							</div>
							<input class="btn btn-primary btn-lg btn-block" type="submit" value=@Res.config onclick="" />
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
@Scripts.Render("~/bundles/jqueryval")
