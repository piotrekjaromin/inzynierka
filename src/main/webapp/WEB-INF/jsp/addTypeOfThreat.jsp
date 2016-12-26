<%@ page import="com.models.ThreatType" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: piotrek
  Date: 19.03.16
  Time: 20:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<%!
    public String printTypes(ThreatType type, String dashes) {

    if (type != null) {
        String result = type.getName();
        String button = " <button class='btn btn-default btn-xs' data-toggle='modal' data-target='#addType' onclick='addUuid(\"" + type.getUuid() + "\")'>add</button><br/>";
        dashes += " &emsp; ";

        result += button;

        for (ThreatType typeTmp : type.getChilds()) {
            result = result + dashes + printTypes(typeTmp, dashes);
        }
        return result;
    } else return "";
}%>


<script>

    function addUuid(uuid) {
        console.log("uuidFunc: " + uuid);
        $("#parentUuid").val(uuid);
    }

    function addThreatType() {

        console.log("uuid: " + $("#parentUuid").val());
        console.log("type: " + $("#typeAddType").val());
        $.ajax({
            type: "POST",
            url: "addThreatType",
            dataType: 'text',
            data: {
                parentUuid: $("#parentUuid").val(),
                threatType: $("#typeAddType").val()

            },
            success: function (response) {

                if(response == "Success") {
                    $("#modalToHide").hide();
                    $('#alert_placeholderAddType').html('<div class="alert alert-success">' + response + '</div>')
                    window.location.href = "addThreatType";
                } else {
                    $('#alert_placeholderAddType').html('<div class="alert alert-danger">' + response + '</div>')
                }
            },
            error: function (response) {
                $('#alert_placeholderAddType').html('<div class="alert alert-danger">' + response + '</div>')
            }
        });
    }
</script>

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Add Type Of Threat</title>

    <jsp:include page="partOfPage/cssImport.jsp"/>
    <jsp:include page="partOfPage/jsImport.jsp"/>
</head>
<body>
<div id="wrapper">
    <jsp:include page="partOfPage/navigator.jsp"/>

    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Add Types Of Threat</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        Types Of Traffic Threat
                    </div>
                    <div class="panel-body">
                        <% out.print(printTypes((ThreatType) request.getAttribute("threatType"), "")); %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="partOfPage/modals/addType.jsp"/>
</body>
</html>
