@using Bcri.Core.Bussines
@using $rootnamespace$.Areas.Bcri.Models
@using DNF.Security.Bussines
@model List<ProcessInput>

<div class="panel-body col-lg-12 form-group">

    <div class="row">
        <div class="col-md-6">
            <select id="selRepositoryInputs" class="form-control" style="width: 100%">
                @foreach (ProcessInput input in Model)
                {
                    <option value="@input.Config.Code-input-@input.Repository.Id" grid-attach="@input.Config.Code-input-@input.Repository.Id">
                        @input.Config.Name (@input.Repository.Period.ToShortDateString()) @(Current.User.HasAccess("Developer") ? $"({input.Repository.Id})" : "" )
                    </option>
                }
            </select>
        </div>
    </div>


    <hr />
    <div class="row">
        <div class="col-md-12">
            <div id="contentInputsGrid" class="tab-content">
                @foreach (ProcessInput input in Model)
                {
                    <div class="panel-body tab-pane fade @(Model.IndexOf(input) == 0 ? "in active" : "")" id="@input.Config.Code-input-@input.Repository.Id">
                        @*<h3>@output.Config.Name</h3>*@
                        <div class="row">
                            <div class="col-lg-12">
                                @Html.Partial("JqGridBcri", new GridModel
                                {
                                    EntityName = input.Config.RepositoryConfig.Code,
                                    GridId = input.Config.Code + input.Repository.Id,
                                    RepositoryId = input.Repository.Id,
                                    RepositoryConfigId = input.Config.RepositoryConfig.Id,
                                    Editable = false,
                                    Exportable = true
                                })
                            </div>
                        </div>
                    </div>
                }
            </div>
        </div>
    </div>

</div>
<!-- /.panel-body -->

