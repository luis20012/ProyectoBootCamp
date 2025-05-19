@{var Res = $rootnamespace$.Res.res;}
@{
    ViewBag.Title = Res.accessManagement;
}
<style type="text/css">
    .font-color-white{
        color:white !important;
    }
</style>
@Styles.Render("~/Content/jstree-theme/style.min.css")
<div class="col-lg-5">
    <div class="ibox">
        <div class="ibox-title">
            <h5>@Res.Menu</h5>
            <div class="ibox-tools">
                <div id="confirm-moving" class="pull-right">
                    <a id="tree-access-save" class="btn btn-success btn-xs font-color-white"><i class="fa fa-save"></i> @Res.save</a>
                    <a id="tree-access-cancel" class="btn btn-danger btn-xs font-color-white"><i class="fa fa-times"></i> @Res.cancel</a>
                </div>

                <div id="botoneraJstree" class="btn-group pull-right">
                    <a id="tree-access-add" class="btn btn-primary btn-xs font-color-white"><i class="fa fa-plus"></i></a>
                    <a id="tree-access-reload" class="btn btn-info btn-xs font-color-white"><i class="fa fa-retweet"></i></a>
                    <a id="tree-access-del" class="btn btn-danger btn-xs font-color-white" data-toggle="modal" data-target="#modalConfirmDelete"><i class="fa fa-trash"></i></a>
                </div>
            </div>
        </div>
        <div class="ibox-content">
            <!-- Tree view -->
            <div id="tree-access"></div>
        </div>
    </div>
</div>
<div class="col-lg-7">
    <!-- ConfigTree -->
    <div id="access-config"></div>
</div>

<div style="position: absolute;top: 0; right: 0; display: inline" class="fade in out" id="alerts-AccessManagement">

</div>
<!-- Modal -->
<div class="modal fade" id="modalConfirmDelete" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content panel panel-danger">
            <div class="modal-header panel-heading">
                <h4 class="panel-title" id="exampleModalLabel">@Res.delete <span class="selectedNode"></span></h4>
            </div>
            <div class="modal-body panel-body withSelectedNode">
                @Res.helpBlockConfimDeleteAccess
            </div>
            <div class="modal-body panel-body withNoSelectedNode">
                @Res.pleaseSelectANode
            </div>
            <div class="modal-footer panel-footer">
                <button type="button" class="btn btn-danger font-color-white" data-dismiss="modal">@Res.cancel</button>
                <button type="button" id="tree-access-del-confirm" data-dismiss="modal" class="btn btn-warning font-color-white"> @Res.confirm </button>
            </div>
        </div>
    </div>
</div>

<div id="AccessManagementJsData" @*common data para el js*@
     url-AccessTreeData="@Url.Action("AccessTreeData", "Security")"
     url-AccessTreeDataSave="@Url.Action("SaveAccessTreeOrder", "Security")"
     url-AccessData="@Url.Action("AccessData", "Security")"
     url-AccessDataDelete="@Url.Action("DeleteAccess", "Security")">
</div>


@section scripts {
    @Scripts.Render("~/Scripts/jstree/jstree.js")
    @Scripts.Render("~/Areas/Bcri/Views/Security/AccessManagement.js")
}

