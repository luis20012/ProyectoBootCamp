@using DNF.Security.Bussines;
@using System.Configuration;
@using System.Globalization;
@using $rootnamespace$.Areas.Bcri.Utility;
@using Type = DNF.Type.Bussines.Type;
@{
    /**/

    var Res = $rootnamespace$.Res.res;
}

<div class="navbar-default sidebar" role="navigation">
    <nav class="navbar-default navbar-static-side" role="navigation">
        <div class="sidebar-collapse">
            <ul class="nav metismenu" id="nav1">
                <li class="nav-header">
                    <div class="dropdown profile-element">
                        <div class="logo-client"></div>
                        <a data-toggle="dropdown" class="dropdown-toggle" href="#" aria-expanded="false">
                            <span class="block m-t-xs font-bold">@Html.Raw(Current.User.FullName) <b class="caret"></b></span>
                        </a>
                        @if (SettingsSiteUtility.UserChooseCulture)
                        {
                    <ul class="dropdown-menu animated fadeInRight m-t-xs" x-placement="bottom-start" style="position: absolute; top: 110px; left: 5px; will-change: top, left;">
                                    @*@{
                        if (ConfigurationManager.AppSettings["UseActiveDirectory"].ToString().ToUpper() == "FALSE")
                        {
                            <li>
                                <a class="dropdown-item" href="@Url.Action("ChangePassword", "Login") ">@Res.userProfile</a>
                            </li>
                            <li class="dropdown-divider"></li>
                        }
                    }
                    <li><a class="dropdown-item" href="@Url.Action("LogOut", "Login")">@Res.logOut</a></li>*@

                        <li>
                            <a class="dropdown-item" href="#"><i class="fa fa-globe fa-fw"></i>@Res.Language</a>
                            <select id="languageSelector" class="form-control placeholder">
                                @foreach (var lang in new Type("Language")?.AllTypes)
                                {
                                    if (lang.Code != CultureInfo.CurrentUICulture.Name)
                                    {
                    <option value="@lang.Code">@lang.Name</option>
                                    }
                                    else
                                    {
                    <option selected>@lang.Name</option>
                                    }
                                }
                            </select>
                        </li>
                        <li class="dropdown-divider"></li>
						<li>
							@Html.ActionLink(@Res.changePass, "ChangePassword","Login")
						</li>
                    </ul>
                        }
                    </div>
                    <!--div class="dropdown profile-element">

                    </div-->
                    <div class="logo-element">
                        CS
                    </div>
                </li>
            </ul>
            <div class="sidebar sidebar-container" id="nav2">
                <ul class="nav metismenu" id="side-menu">
                    @if (Current.User != null)
                    {
                        @Html.Partial("Access", Access.Dao.GetNested(
                                           Current.User.Accesses
                                               .Where(x => x.Type.Code == "Folder" || x.Type.Code == "Menu").ToList()))

                    }
                    </ul>
                </div>
            </div>
            <!-- /.sidebar-collapse -->
        </nav>
    </div>

