<%--
  Created by IntelliJ IDEA.
  User: pietrek
  Date: 13.11.15
  Time: 13:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>Registration</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <script>
        function signUp(userRole) {

            if ($("#loginReg").val().length < 6) {
                $('#alert_placeholder').html('<div class="alert alert-danger">Failure: login is too short</div>')
                return;
            }

            if ($("#passwordReg").val().length < 6) {
                $('#alert_placeholder').html('<div class="alert alert-danger">Failure: password is too short</div>')
                return
            }


            $.ajax({
                type: "POST",
//                contentType : 'application/json; charset=utf-8',
                url: "registration",
                dataType: 'text',
                data: {
                    login: $("#loginReg").val(),
                    password: $("#passwordReg").val(),
                    mail: $("#mailReg").val(),
                    name: $("#nameReg").val(),
                    surname: $("#surnameReg").val(),
                    userRole: userRole
                },
                success: function (response) {
                    $(".form-inline").hide();
                    $('#alert_placeholder').html('<div class="alert alert-success">' + response + '</div>')
                },
                error: function (response) {
                    $('#alert_placeholder').html('<div class="alert alert-danger">' + response + '</div>')
                }
            });

        }
    </script>

</head>
<body>

<h2>Library</h2>
<%@include file="partOfPage/buttons/loginRegistrationButton.jsp" %>

<div class="panel panel-primary">
    <div class="panel-heading">
        Registration
        <button class="btn btn-default" onclick="window.location.href='/TrafficThreat'">Go to main page</button>
    </div>
    <div class="panel-body">
        <input type="text" id="loginReg" class="form-control" placeholder="Login">
        <input type="password" id="passwordReg" class="form-control" placeholder="Password">
        <input type="text" id="mailReg" class="form-control" placeholder="Mail">
        <input type="text" id="nameReg" class="form-control" placeholder="Name">
        <input type="text" id="surnameReg" class="form-control" placeholder="Surname">

        <button onclick="signUp('USER')" class="btn btn-default">Sign up</button>
        <sec:authorize access="hasRole('ADMIN')">
            <button onclick="signUp('ADMIN')" class="btn btn-default">Sign up as admin</button>
        </sec:authorize>

    </div>
</div>
<div id="alert_placeholder">

</div>

</body>
</html>
