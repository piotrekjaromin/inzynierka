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
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Sign in</title>

    <jsp:include page="partOfPage/cssImport.jsp"/>
    <jsp:include page="partOfPage/jsImport.jsp"/>
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
            if ($("#mailReg").val().length < 10) {
                $('#alert_placeholder').html('<div class="alert alert-danger">Failure: mail is too short</div>')
                return
            }
            if ($("#mailReg").val().indexOf("@") < 0 || $("#mailReg").val().indexOf(".") < 0) {
                $('#alert_placeholder').html('<div class="alert alert-danger">Failure: mail must contains characters: @ and .</div>')
                return
            }

            if ($("#nameReg").val().length < 4) {
                $('#alert_placeholder').html('<div class="alert alert-danger">Failure: name is too short</div>')
                return
            }
            if ($("#surnameReg").val().length < 4) {
                $('#alert_placeholder').html('<div class="alert alert-danger">Failure: surname is too short</div>')
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
                    if (response == 'Success') {
                        $("#registrationForm").hide();
                        $('#alert_placeholder').html('<div class="alert alert-success">' + response + '</div>')
                    } else {
                        $('#alert_placeholder').html('<div class="alert alert-danger">' + response + '</div>')
                    }
                },
                error: function (response) {
                    $('#alert_placeholder').html('<div class="alert alert-danger">' + response + '</div>')
                }
            });

        }
    </script>

</head>
<body>
<div id="wrapper">
    <jsp:include page="partOfPage/navigator.jsp"/>

    <div id="page-wrapper">
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Sign up</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <div class="row">
            <div id="alert_placeholder"/>
        </div>
        <div class="row">

            <div class="col-xs-3" id="registrationForm">
                <input type="text" id="loginReg" class="form-control" placeholder="Login">
                <input type="password" id="passwordReg" class="form-control" placeholder="Password">
                <input type="text" id="mailReg" class="form-control" placeholder="Mail">
                <input type="text" id="nameReg" class="form-control" placeholder="Name">
                <input type="text" id="surnameReg" class="form-control" placeholder="Surname">
                <button onclick="signUp('USER')" class="btn btn-default">Sign Up</button>
                <sec:authorize access="hasRole('ADMIN')">
                    <button onclick="signUp('ADMIN')" class="btn btn-default">Sign Up As Admin</button>
                </sec:authorize>
            </div>

        </div>

    </div>
</div>

</body>
</html>
