@model DNF.Security.Bussines.Access
@{var Res = $rootnamespace$.Res.res;}
@{
	Layout = "_LayoutOut.cshtml";
	ViewBag.Title = Res.noAccess;
	var acceso = Model?.Name ?? "";
}


<i class="fa fa-ban fa-fw" style="font-size: 140px; padding-bottom: 10px;"></i>
<p class="">@Res.mensajeNoAccess @acceso.<br /> @Res.mensajeContactAdmin</p>

