<%@ Page Inherits="Tridion.Web.UI.Controls.TridionPage" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8">
    <title>Download Report from SDL WEB8</title>
    <%--<script src="${JsUrl}jquery-2.1.4.js" lang="javascript"></script>--%>
    <link rel="stylesheet" type="text/css" href="${CssUrl}/Popup.css">
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />

    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" />


</head>
<body>
    <%-- <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>--%>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <%--<script type="text/javascript" src="http://code.jquery.com/jquery-1.8.2.js"></script>--%>
    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function () {
            // var person = '{Name: "' + $("#txtName").val() + '" }';
            $.ajax({
                type: "GET",
                url: "http://192.168.20.205:81/Alchemy/Plugins/DownloadCMSReport/api/Service/GetPublicationList",
                // data: person,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {

                    $.each(response, function (i, obj) {
                        //alert(obj.value + ":" + obj.text);
                        var div_data = "<option value=" + obj.id + ">" + obj.title + "</option>";
                        //alert(div_data);
                        $(div_data).appendTo('#ddlPubList');
                    });
                    //alert("Hello: " + response.title + ".\nCurrent Date and Time: " + response.id);
                },
                failure: function (response) {
                    alert(response.responseText);
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        });

        $(function () {
            $("#btnGet").click(function () {
                var person = '{Name: "' + $("#txtName").val() + '" }';
                $.ajax({
                    type: "POST",
                    url: "http://192.168.20.205:81/Alchemy/Plugins/DownloadCMSReport/api/Service/AjaxMethod",
                    data: person,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        // alert("Hello: " + response.name + ".\nCurrent Date and Time: " + response.dateTime);
                    },
                    failure: function (response) {
                        alert(response.responseText);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    }
                });
            });
        });
        $(function () {
            $("#btnGet").click(function () {
                var person = '{Name: "' + $("#txtName").val() + '" }';
                $.ajax({
                    type: "GET",
                    url: "http://192.168.20.205:81/Alchemy/Plugins/DownloadCMSReport/api/Service/GetUserListData",
                    data: person,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        //alert("Hello: " + response.title + ".\nCurrent Date and Time: " + response.id);
                    },
                    failure: function (response) {
                        alert(response.responseText);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    }
                });
            });

        });
        $(function () {
            $("#btnGet").click(function () {
                var person = '{Name: "' + $("#txtName").val() + '" }';
                $.ajax({
                    type: "GET",
                    url: "http://192.168.20.205:81/Alchemy/Plugins/DownloadCMSReport/api/Service/GetPublicationList",
                    data: person,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {

                        //$.each(response.item, function (i, obj) {
                        //    //alert(obj.value + ":" + obj.text);
                        //    var div_data = "<option value=" + obj.id + ">" + obj.title + "</option>";
                        //    alert(div_data);
                        //    $(div_data).appendTo('#ddlPubList');
                        //});
                        //alert("Hello: " + response.title + ".\nCurrent Date and Time: " + response.id);
                    },
                    failure: function (response) {
                        alert(response.responseText);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    }
                });
            });

        });
        $(function () {
            $("#btnGet").click(function () {
                var pubId = '{pubId: "' + $("#ddlPubList").val() + '",itemType: "' + $("#itemTypes").val() + '"}';
                $.ajax({
                    type: "POST",
                    url: "http://192.168.20.205:81/Alchemy/Plugins/DownloadCMSReport/api/Service/AjaxGetComponent",
                    data: pubId,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        //alert("Hello: " + response.title + ".\nCurrent Date and Time: " + response.id);
                        $('#table-responsive-tr').empty();
                        $.each(response.item, function (index, data) {
                            $('#table-responsive-tr').append('<tr><td>' + data.id + '</td><td>' + data.title + '</td><td>' + data.fromPub + '</td><td>' + data.owningPublicationTitle + '</td><td>' + data.owningPublicationID + '</td><td>' + data.modified + '</td></tr>');
                        })
                    },
                    failure: function (response) {
                        alert(response.responseText);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    }
                });
            });

        });

        $(function () {
            $('#datetimepicker1').datepicker();
        });
        $(function () {
            $('#datetimepicker2').datepicker();
        });
    </script>

    <div class="container">
        <form>
            <div class="form-group row">
                <h1>Download CMS Report</h1>
            </div>
            <div class="form-group row">
                <label for="lgFormGroupInput" class="col-sm-2 col-form-label col-form-label-lg">Publication Id</label>
                <div class="col-sm-10">
                    <%--<input type="text" id="txtName" class="form-control form-control-lg" placeholder="Publication Id">--%>
                    <div class="dropdown">
                        <select name="pubList" id="ddlPubList">
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group row">
                <label for="lgFormGroupInput" class="col-sm-2 col-form-label col-form-label-lg">Select Item Type</label>
                <div class="col-sm-10">
                    <div class="dropdown">
                        <select name="item1" id="itemTypes">
                            <option selected="selected" value="all">All</option>
                            <option value="16">Components</option>
                            <option value="8">Schema</option>
                            <option value="32">Component Template</option>
                            <option value="64">Page</option>
                            <option value="4">StructureGroup</option>
                            <option value="128">Page Template</option>
                            <option value="512">Category</option>
                            <option value="1024">Keyword</option>
                            <option value="2048">TemplateBuildingBlock</option>
                            <option value="2">Folder</option>
                        </select>
                    </div>
                </div>
            </div>
<%--            <div class="row">
                <div class='col-sm-6'>
                    <div class="form-group">
                        <div class='input-group date' id='datetimepicker1'>
                            <label for="lgFormGroupInput" class="col-sm-2 col-form-label col-form-label-lg">From :</label>
                            <input type='text' class="form-control" />
                            <span class="input-group-addon">
                                <span class="glyphicon glyphicon-calendar"></span>
                            </span>
                        </div>
                        <div class='input-group date' id='datetimepicker2'>
                            <label for="lgFormGroupInput" class="col-sm-2 col-form-label col-form-label-lg">To :</label>
                            <input type='text' class="form-control" />
                            <span class="input-group-addon">
                                <span class="glyphicon glyphicon-calendar"></span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>--%>
            <div class="form-group row">

                <div class="col-sm-10">
                    <input type="button" id="btnGet" class="btn btn-primary" value="Download" />
                </div>
            </div>
            <div class="table-responsive">
                <table id="ajax-response" class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>FromPub</th>
                            <th>OwningPublicationTitle</th>
                            <th>OwningPublicationID</th>
                            <th>Modified</th>
                        </tr>
                    </thead>
                    <tbody id="table-responsive-tr">
                        
                        
                    </tbody>
                </table>
            </div>
        </form>
    </div>

</body>

</html>

