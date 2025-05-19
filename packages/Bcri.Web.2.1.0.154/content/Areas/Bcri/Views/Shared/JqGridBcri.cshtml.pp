@using Bcri.Core.Bussines
@using DNF.Structure.Bussines
@model $rootnamespace$.Areas.Bcri.Models.GridModel

@{


	if (Model.RepositoryId != 0)
	{
		var repo = Repository.Dao.Get(Model.RepositoryId);
		if (repo != null) {
			Model.RepositoryConfigId = repo.Config.Id;

			repo.Config.Entity = Entity.Dao.Get(repo.Config.Entity.Id);
			Model.EntityName = repo.Config.Entity.Name;
		}
	}

	if (string.IsNullOrEmpty(Model.GridId))
	{
		if (!string.IsNullOrEmpty(Model.EntityName))
		{
			Model.GridId = Model.EntityName;
		}
		else if (Model.RepositoryConfigId != 0)
		{
			Model.GridId = RepositoryConfig.Dao.Get(Model.RepositoryConfigId)?.Code;
		}

	}


	string gridId = $"jqGrid-{Model.GridId}";
}

        @* agregar marka selector unico para la RepositoryDataGrid tipo Role="repositoridatagrid" *@
<table id="@Model.GridId"
        data-GridId="@Model.GridId"
        data-EntityName="@Model.EntityName"
        data-repositoryId="@Model.RepositoryId"
        data-repositoryConfigId="@Model.RepositoryConfigId"
        data-ServerSide="@Model.ServerSide"
        data-Editable="@Model.Editable"
        data-Exportable="@Model.Exportable"></table>
<div id="@Model.GridId-Pager"></div>

@* mover esto al layout y dejar de concatenar el RepositoryController *@

