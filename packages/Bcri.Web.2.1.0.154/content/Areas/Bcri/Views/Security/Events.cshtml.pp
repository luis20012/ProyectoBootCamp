@{var Res = $rootnamespace$.Res.res;}
@{
    ViewBag.Title = Res.auditableeventsreport;
}

<style>
    #CustomView-jqGridEvents {
        display: none;
    }
</style>

<div class="ibox">
    <div class="ibox-title">
        <h5>@Res.auditableeventsreport</h5>
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
                    <table id="jqGridEvents"> </table>
                    <div id="jqGridEventsPager"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="EventsJsData" @*common data para el js*@
        data-dataUrl="@Url.Action("EventsAudit")">
</div>


@section scripts {
    @Scripts.Render("~/Areas/Bcri/Views/Security/Events.js")
}




