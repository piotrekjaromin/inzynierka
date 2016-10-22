<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>User profile</title>

    <jsp:include page="partOfPage/cssImport.jsp"/>
    <jsp:include page="partOfPage/jsImport.jsp"/>


    <script>
        function view(bookmark) {
            $.ajax({
                type: "POST",
                url: "/TrafficThreat/user/" + bookmark,
                dataType: "json",
                success: function (response) {
                    console.log(response);

                    if (bookmark == 'details') {
                        createUserDetails(response);
                    } else if (bookmark == 'myThreats') {
                        createMyThreats(response);
                    } else
                        createReservedBooks(response);
                },

                error: function (e) {
                    alert("Error")
                }
            });
        }

        function createUserDetails(json) {
            $('#myThreats').hide();
            $('#commentedThreats').hide();
            $('#userDetails').show();

            document.getElementById("userDetailsBookmark").className = "active";
            document.getElementById("myThreatsBookmark").className = "";
            document.getElementById("commentedThreatsBookmark").className = "";


            var userDetails = "login: " + json.login + "<br>";
            userDetails += "mail: " + json.mail + "<br>";
            userDetails += "name: " + json.name + "<br>";
            userDetails += "surname: " + json.surname + "<br>";

            userDetails += "<button class='btn btn-primary' data-toggle='modal' data-target='#edit'>edit</button><br>"
            $('#userDetails').html(userDetails)
            $('#loginEditUser').val(json.login);
            $('#nameEditUser').val(json.name);
            $('#surnameEditUser').val(json.surname);
            $('#mailEditUser').val(json.mail);
            $('#uuidEditUser').val(json.uuid);

        }

        function createMyThreats(json) {
            $('#myThreats').show();
            $('#userDetails').hide();
            $('#commentedThreats').hide();

            console.log("json");
            console.log(json);
            document.getElementById("userDetailsBookmark").className = "";
            document.getElementById("myThreatsBookmark").className = "active";
            document.getElementById("commentedThreatsBookmark").className = "";


            var threats = "";
            threats = "<div class='table-responsive'><table class='table table-striped'>"
            threats += "<tr>"
            threats += "<th>Uuid</th>"
            threats += "<th>Type</th>"
            threats += "<th>Description</th>"
            threats += "<th>Is approved</th>"
            threats += "<th>Details</th>"
            threats += "<th>Delete</th>"
            threats += "</tr>"

            json.forEach(function (threat) {
                var button = "<button class='btn btn-default' onclick=\"location.href='/TrafficThreat/getThreatDetails/?uuid=" + threat.uuid + "'\">"
                button += "details"
                button += "</button>"
                threats += "<tr><td>" + threat.uuid + "</td><td> " + threat.type.threatType + "</td><td> " + threat.description + " </td><td>" + threat.isApproved + "</td><td>" + button + "</td>";
                var deleteButton = "<td> <button class=\"btn btn-default\" onclick=\"deleteThreat('" + threat.uuid + "')\">delete</button> </td></tr>"
                threats += deleteButton;
            })
            threats += "</table></div>"
            $('#myThreats').html(threats);
        }

        function createReservedBooks(json) {
            $('#myBooks').show();
            $('#userDetails').hide();
            console.log("json");
            console.log(json);
            document.getElementById("userDetailsBookmark").className = "";
            document.getElementById("myThreatsBookmark").className = "";
            document.getElementById("commentedThreatsBookmark").className = "active";

            var myBooks = "";
            json.forEach(function (book) {
                console.log(book);
                myBooks += book.title + " " + book.authors[0].name + " " + book.authors[0].surname + " " + book.year + "<br>";
            })
            $('#myBooks').html(createTableReserved(json));
        }

        function deleteThreat(threatUuid) {
            $.ajax({
                type: "POST",
                url: "/TrafficThreat/user/deleteThreat",
                dataType: 'text',
                data: {
                    uuid: threatUuid
                },
                success: function (response) {
                    location.reload();
                    alert(response)
                },
                error: function (response) {
                    alert("Failure")
                }
            });
        };


        function editUser() {

            if ($("#passwordEditUser").val().length < 6) {
                $('#alert_placeholderEditUser').html('<div class="alert alert-danger">Failure: password is too short</div>')
                return
            }
            if ($("#mailEditUser").val().length < 10) {
                $('#alert_placeholderEditUser').html('<div class="alert alert-danger">Failure: mail is too short</div>')
                return
            }
            if ($("#mailEditUser").val().indexOf("@") < 0 || $("#mailEditUser").val().indexOf(".") < 0) {
                $('#alert_placeholderEditUser').html('<div class="alert alert-danger">Failure: mail must contains characters: @ and .</div>')
                return
            }

            if ($("#nameEditUser").val().length < 4) {
                $('#alert_placeholderEditUser').html('<div class="alert alert-danger">Failure: name is too short</div>')
                return
            }
            if ($("#surnameEditUser").val().length < 4) {
                $('#alert_placeholderEditUser').html('<div class="alert alert-danger">Failure: surname is too short</div>')
                return
            }

            $.ajax({
                        type: "POST",
                        //contentType: 'application/json; charset=utf-8',
                        url: "/TrafficThreat/user/editProfile",
                        dataType: 'text',
                        data: {
                            uuid: $("#uuidEditUser").val(),
                            mail: $("#mailEditUser").val(),
                            name: $("#nameEditUser").val(),
                            surname: $("#surnameEditUser").val(),
                            password: $("#passwordEditUser").val()
                        },
                        success: function (response) {

                            if (response.indexOf("Failure")>-1) {
                                $('#alert_placeholderEditUser').html('<div class="alert alert-danger">' + response + '</div>')
                            } else {
                                view('details');
                                $('#editAccountModal').hide();
                                $('#alert_placeholderEditUser').html('<div class="alert alert-success">' + response + '</div>')
                            }
                        },
                        error: function (response) {
                            console.log(response);
                            $('#alert_placeholderEditUser').html('<div class="alert alert-danger">' + response + '</div>')
                        }
                    }
            );
        }

    </script>


</head>
<body onload="view('details')">
<div id="wrapper">
    <jsp:include page="partOfPage/navigator.jsp"/>

    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">User Profile</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <ul class="nav nav-tabs">
                            <li role="presentation" class="active" id="userDetailsBookmark"><a onclick="view('details')">Details</a></li>
                            <li role="presentation" class="" id="myThreatsBookmark"><a onclick="view('myThreats')">My Threats</a></li>
                            <li role="presentation" class="" id="commentedThreatsBookmark"><a onclick="view('commentedThreats')">Commented Threads</a></li>
                        </ul>
                    </div>
                    <div class="panel-body">


                        <div id="userDetails"></div>
                        <div id="myThreats"></div>
                        <div id="commentedThreats"></div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="partOfPage/modals/editUser.jsp"/>
</body>
</html>
