@model DNF.Security.Bussines.Access

@{var Res = $rootnamespace$.Res.res;}
@{
	Layout = "_LayoutOut.cshtml";
	ViewBag.Title = Res.sessionEnd;
}



<i class="fa fa-sign-out fa-fw" style="font-size: 140px; padding-bottom: 10px;"></i>
<p class="">
	@Res.sessionEndMsj
	<br /> @Res.sessionGreetings
</p>

