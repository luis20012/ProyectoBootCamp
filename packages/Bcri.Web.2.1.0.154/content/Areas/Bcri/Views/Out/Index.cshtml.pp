

@{
	var Res = $rootnamespace$.Res.res;
	Layout = "_LayoutOut.cshtml";
	ViewBag.Title = Res.userNotAllowed;
}


<i class="fa fa-ban fa-fw" style="font-size: 140px; padding-bottom: 10px;"></i>
<p class="">@Res.msjUserNotAllowed</p>

