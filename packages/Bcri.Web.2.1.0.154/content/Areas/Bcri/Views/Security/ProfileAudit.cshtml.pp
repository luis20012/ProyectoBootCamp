@using DNF.Security.Bussines
@{var Res = $rootnamespace$.Res.res;}
@{
    ViewBag.Title = Res.profilesreporttasks;
}

<style>
    #CustomView-jqGridProfiles {
        display: none;
    }
</style>

<div class="ibox">
    <div class="ibox-title">
        <h5>@Res.profilesreporttasks</h5>
        <div class="ibox-tools">
            <a class="collapse-link">
                <i class="fa fa-chevron-up"></i>
            </a>
        </div>
    </div>
    <div class="ibox-content">
        <div class="row">
            <div class="panel-body">
                <div class="col-lg-12">
                    <table id="jqGridProfiles"> </table>
                    <div id="jqGridProfilesPager"></div>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="ProfilesJsData" @*common data para el js*@
        data-dataUrl="@Url.Action("ProfilesAudit")">
</div>

@section scripts {
    @Scripts.Render("~/Areas/Bcri/Views/Security/ProfileAudit.js")
}


