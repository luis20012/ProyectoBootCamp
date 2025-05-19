@model Bcri.Core.Bussines.Search
@{var Res = $rootnamespace$.Res.res;}
@{
    Layout = "~/Views/Shared/_LayoutBcri.cshtml";
}
<link href="~/Scripts/dropzone/dropzone.css" rel="stylesheet"/>
<link href="~/Content/site.css" rel="stylesheet"/>


<form id="FilterForm">
    @Html.HiddenFor(x => x.Page)
    @Html.HiddenFor(x => x.PageSize)  
    @Html.HiddenFor(x => x.Query) 
</form>
<div class="container-fluid">

    <div class="row" style="display: inline-block; vertical-align: top">
        <h1 class="page-header" style="display: inline-block;">@Res.documentSearch</h1> 
       
        <a href="#" id="add" data-toggle="modal" data-target="#myModal" ><img src="~/Content/images/plus-icon.png" alt="NewDocument"/></a>
    </div>


    @using (Html.BeginForm())
    {
        <input id="search" type="text" class="form-control" placeholder=@Res.placeHolderSearch name="toSearch"/>
    }
    <div class="candidatesContainerSearch">
        <ul class="chat">
            @Html.Partial("Contracts", Model.ResultSearch)
        </ul>
</div>
</div>



<!--Drag and drop!-->
<div id="myModal" class="modal fade" role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">@Res.uploadDocuments </h4>
            </div>
            <div class="modal-body">
                <h4>@Res.selectFiles</h4>
                <form action="~/DocumentSearch/SaveUploadedFile" method="post" enctype="multipart/form-data" class="dropzone upload-drop-zone" id="dropzone">
                    <div class="fallback">
                        <input name="file" type="file" multiple />
                        <input type="submit" value="Upload" />
                    </div>
                </form>
            </div>

          <!-- <form  class="dropzone" id="dropzoneForm" style="width: 50px; background: none; border: none;">--> 
                 
        </div>

    </div>
</div>



@section scripts {
    @Scripts.Render("~/Scripts/dropzone/dropzone.js")
    @Scripts.Render("~/Areas/Bcri/Views/DocumentSearch/AddFile.js")
} 
<div id="DocumentSearchIndexJsData" @*common data para el js*@
     data-getpage="@Url.Action("GetSearchPage")"> 
</div>
