<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: piotrek
  Date: 08.04.16
  Time: 10:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" type="text/css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <title>Edit threat</title>

    <script>
        function edit() {
            $.ajax({
                type: "POST",
                url: "/TrafficThreat/admin/editThreat",
                dataType: 'text',
                data: {
                    uuid: $("#uuid").val(),
                    typeOfThreat: $("#typeOfThreat").val(),
                    location: $("#location").val(),
                    description: $("#description").val()
                },
                success: function (response) {
                    alert(response)
                },
                error: function (response) {
                    alert(response)
                }
            });
        }
        ;
    </script>
</head>
<body>
<div class="panel panel-primary">
    <div class="panel-heading">
        Edit Threat
        <button class="btn btn-default" onclick="window.location.href='/TrafficThreat'">Go to main page</button>
    </div>
    <div class="panel-body">

        <table>
            <input type="hidden" value="${threat.uuid}" id="uuid">
            <tr>
                <td>uuid</td>
                <td><c:out value="${threat.uuid}"/></td>
            </tr>
            <tr>
                <td>type</td>
                <td>
                    <select class="form-control" id="typeOfThreat">
                        <c:choose>
                            <c:when test="${threat.type.threatType eq 'Stale'}">
                                <option value="Stale" selected>Stale</option>
                                <option value="Krotkotrwale">Krotkotrwale</option>
                            </c:when>
                            <c:otherwise>
                                <option value="Stale">Stale</option>
                                <option value="Krotkotrwale" selected>Krotkotrwale</option>
                            </c:otherwise>
                        </c:choose>

                    </select></td>
            </tr>
            <tr>
                <td>description</td>
                <td><input type="text" class="form-control" value="${threat.description}" id="description"></td>
            </tr>
            <tr>
                <td>location</td>
                <td><input type="text" class="form-control"
                           value="${threat.coordinates.street};${threat.coordinates.city}" id="location"/></td>
            </tr>
        </table>
        <button class="btn btn-default" onclick="edit()">edit</button>
        </div>
    </div>
</body>
</html>
