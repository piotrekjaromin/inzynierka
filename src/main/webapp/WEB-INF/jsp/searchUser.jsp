<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: piotrek
  Date: 21.11.15
  Time: 02:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <script src="http://www.jsviews.com/download/jsrender.min.js"></script>
    <link href="<c:url value='/static/css/main.css'/>" rel="stylesheet" type="text/css">
    <title>Search users</title>
    <script>

        var searchTypeGlobal = 'login';

        function search(searchType) {
            searchTypeGlobal = searchType;
            $.ajax({
                type: "POST",
                url: "/admin/searchUser",
                data: {
                    "searchType": searchType,
                    "userData": $('#userData').val()
                },
                dataType: "json",
                success: function (response) {
                    console.log(response);
                    console.log(createTable(response));
                    document.getElementById("tableOfUsers").innerHTML = createTable(response);
                },

                error: function (e) {
                    $('#alert_placeholder').html('<div class="alert alert-failure">failure</div>');

                }
            });
        }


        function borrow() {

            $.ajax({
                type: "POST",
                url: "/admin/borrowBook",
                data: {
                    "bookUuid": $('#bookUuid').val(),
                    "userUuid": $('#userUuid').val()
                },
                dataType: "text",
                success: function (response) {
                    alert(response);
                    search(searchTypeGlobal);
                },

                error: function (e) {
                    alert("Oops! Something has gone wrong");
                    search(searchTypeGlobal);
                }
            });
        }

        function returnBook() {

            $.ajax({
                type: "POST",
                url: "/admin/returnBook",
                data: {
                    "uuidBook": $('#bookUuid').val(),
                    "uuidUser": $('#userUuid').val()
                },
                dataType: "text",
                success: function (response) {
                    alert(response);
                    search(searchTypeGlobal);
                },

                error: function (e) {
                    alert("Oops! Something has gone wrong");
                    search(searchTypeGlobal);
                }
            });
        }

        function payDebt() {

            $.ajax({
                type: "POST",
                url: "/admin/payDebt",
                data: {
                    "uuidUser": $('#userUuid').val(),
                    "debt": $('#debtReturn').val()
                },
                dataType: "text",
                success: function (response) {
                    alert(response);
                    search(searchTypeGlobal);
                },

                error: function (e) {
                    alert("Oops! Something has gone wrong");
                    search(searchTypeGlobal);
                }
            });
        }

        function reserveBook() {

            $.ajax({
                type: "POST",
                url: "/reserveBook",
                data: {
                    "userUuid": $('#userUuid').val(),
                    "bookUuid": $('#bookUuid').val()
                },
                dataType: "text",
                success: function (response) {
                    alert(response);
                    location.reload();
                },

                error: function (e) {
                    alert("Oops! Something has gone wrong");
                    search(searchTypeGlobal);
                }
            });
        }

        function cancelReserveBook() {

            $.ajax({
                type: "POST",
                url: "/admin/cancelReservedBook",
                data: {
                    "userUuid": $('#userUuid').val(),
                    "bookUuid": $('#bookUuid').val()
                },
                dataType: "text",
                success: function (response) {
                    alert(response);
                    search(se)
                },

                error: function (e) {
                    alert("Oops! Something has gone wrong");
                    search(searchTypeGlobal);
                }
            });
        }


        function createTable(json) {
            var myTemplate = $.templates("#UserTmpl");
            var html = "<table class='table' >"
            html += '<tr>' +
                    '<th>uuid</th>' +
                    '<th>id number</th>' +
                    '<th>Login</th>' +
                    '<th>Name</th>' +
                    '<th>Surname</th>' +
                    '<th>mail</th>' +
                    '<th>books</th>' +
                    '<th>debt</th>' +
                    '<td>edit</td>' +
                    '</tr>';
            html += myTemplate.render(json);
            html += "</table>";
            return html;
            console.log(html);
        }


        function addIdNumber() {

            $.ajax({
                type: "POST",
                url: "/admin/addIdNumber/",
                data: {
                    "idNumber": $('#idNumber').val(),
                    "userUuid": $('#userUuid').val()
                },
                dataType: "text",
                success: function (response) {
                    alert(response);
                    location.reload();
                },

                error: function (response) {
                    alert(response);
                    location.reload();
                }
            });
        }

    </script>
    <script id="UserTmpl" type="text/x-jsrender">
        <tr>

            <td>{{:uuid}}</td>
            <td>{{:idNumber}}</td>
            <td>{{:login}}</td>
            <td>{{:name}}</td>
            <td>{{:surname}}</td>
            <td>{{:mail}}</td>
            <td>
            {{for books}}
                {{:title}} {{:year}}<br>
            {{/for}}
            <td>{{:debt}}</td>
            </td>
            <sec:authorize access="hasAnyRole('ADMIN')">
        <td><button onclick="$('#userUuid').val('{{:uuid}}')" class="btn btn-default" data-toggle="modal" data-target="#myModal">action</button></td>

    </sec:authorize>
        </tr>




    </script>
</head>
<body>

<div id="header">
    <div id="menu_bars">
        <%@include file="partOfPage/buttons/menuButtons.jsp" %>
    </div>
    <div class="form-inline">
        <input type="text" id="userData" class="form-control" placeholder="uuid/login">
        <button onclick="search('uuid')" class="btn btn-default">Search by uuid</button>
        <button onclick="search('login')" class="btn btn-default">Search by login</button>
    </div>

    <div id="show_book_image">
        <div id="tableOfUsers"></div>
    </div>

</div>

<%@include file="partOfPage/modals/operationOnUser.jsp" %>

</body>
</html>

