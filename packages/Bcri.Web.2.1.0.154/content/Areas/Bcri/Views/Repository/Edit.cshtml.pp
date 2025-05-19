@using $rootnamespace$.Areas.Bcri.Models
@model Bcri.Core.Bussines.Repository
@{
    string gridId = $"jqGrid-{Model.Config.Code}";
}
<div class="ibox">
    <div class="ibox-title">
        <h5>@Model.Config.Name</h5>
        <div class="ibox-tools">
            <a class="collapse-link">
                <i class="fa fa-chevron-up"></i>
            </a>
        </div>
    </div>
    <div class="ibox-content">
        @Html.Partial("JqGridBcri", new GridModel
            {
                EntityName = Model.Config.Code,
                RepositoryId = 0,
                RepositoryConfigId = Model.Config.Id,
                Editable = true,
                Exportable = true,
                ServerSide = false

            })
    </div>
</div>

