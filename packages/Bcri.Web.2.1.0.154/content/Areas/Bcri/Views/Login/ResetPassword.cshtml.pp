@model DNF.Security.Bussines.User
@{var Res = $rootnamespace$.Res.res;}
@{
    ViewBag.Title = "Reset Password";
    Layout = "~/Views/Shared/_LayoutLogin.cshtml";
}

@if (!string.IsNullOrEmpty(ViewBag.EmailSended))
{
    if (ViewBag.EmailSended == "true")
    {
        <h2>@Res.congrats</h2>

                            <p>@Res.successRecovery</p>




        return;
    }
}

@if (!string.IsNullOrEmpty(ViewBag.ErrorMessage))
{
    <div id="error"> @(ViewBag.ErrorMessage)</div>
}



<div id="box">

    <h2>@Res.recoverYourPass</h2>
    @using (Html.BeginForm())
    {
        <fieldset>
            <div class="form-group">

                @Html.TextBoxFor(model => model.Email, new { @class = "form-control", @placeholder = "Email@torecover.com", @type = "email" })
            </div>
            @if (ViewData["error"] != null)
            {
                <div class="alert alert-danger">
                    @ViewData["error"]
                </div>
            }

            <input class="btn btn-primary btn-lg btn-block" type="submit" value=@Res.recoverButon onclick="" />
        </fieldset>

    }
</div>

@section scripts{
    <script>
        $(function() {
            $('#LoginForm').validate();
        });
    </script>
}

