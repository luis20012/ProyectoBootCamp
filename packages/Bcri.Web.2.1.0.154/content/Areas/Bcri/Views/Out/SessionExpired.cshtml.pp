
@{var Res = $rootnamespace$.Res.res;}
@{
	Layout = "_LayoutOut.cshtml";
	ViewBag.Title = Res.sessionExpired;
}



<i class="fa fa-clock-o fa-fw" style="font-size: 140px; padding-bottom: 10px;"></i>
<p class="">@Res.sessionExpiredMsj</p>
<a href="@Url.Action("Index","Home")">
	<div class="btn btn-success ">@Res.backHome</div>
</a>

