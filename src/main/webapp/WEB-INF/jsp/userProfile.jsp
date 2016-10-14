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

                    if (bookmark == 'userDetails') {
                        createUserDetails(response);
                    } else if (bookmark == 'borrowedBooks') {
                        createBorrowedBooks(response);
                    } else
                        createReservedBooks(response);
                },

                error: function (e) {
                    alert("Error")
                }
            });
        }

        function createUserDetails(json) {
            $('#myBooks').hide();
            $('#userDetails').show();
            document.getElementById("userDetailsBookmark").className = "active";
            document.getElementById("borrowedBooksBookmark").className = "";
            document.getElementById("reservedBooksBookmark").className = "";


            var userDetails = "login: " + json.login + "<br>";
            userDetails += "mail: " + json.mail + "<br>";
            userDetails += "name: " + json.name + "<br>";
            userDetails += "surname: " + json.surname + "<br>";
            userDetails += "debt: " + json.debt + "<br>";
            userDetails += "<button class='btn btn-primary' data-toggle='modal' data-target='#edit'>edit</button><br>"
            $('#userDetails').html(userDetails)
            $('#loginEditUser').val(json.login);
            $('#nameEditUser').val(json.name);
            $('#surnameEditUser').val(json.surname);
            $('#mailEditUser').val(json.mail);
        }

        function createBorrowedBooks(json) {
            $('#myBooks').show();
            $('#userDetails').hide();
            console.log("json");
            console.log(json);
            document.getElementById("userDetailsBookmark").className = "";
            document.getElementById("borrowedBooksBookmark").className = "active";
            document.getElementById("reservedBooksBookmark").className = "";


            var myBooks = "";
            json.forEach(function (book) {
                console.log(book);
                myBooks += book.title + " " + book.authors[0].name + " " + book.authors[0].surname + " " + book.year + "<br>";
            })
            $('#myBooks').html(createTable(json));
        }

        function createReservedBooks(json) {
            $('#myBooks').show();
            $('#userDetails').hide();
            console.log("json");
            console.log(json);
            document.getElementById("userDetailsBookmark").className = "";
            document.getElementById("borrowedBooksBookmark").className = "";
            document.getElementById("reservedBooksBookmark").className = "active";

            var myBooks = "";
            json.forEach(function (book) {
                console.log(book);
                myBooks += book.title + " " + book.authors[0].name + " " + book.authors[0].surname + " " + book.year + "<br>";
            })
            $('#myBooks').html(createTableReserved(json));
        }



        function editUser() {

            var user = {
                "name": $('#nameEditUser').val(),
                "surname": $('#surnameEditUser').val(),
                "login": $('#loginEditUser').val(),
                "password": $('#passwordEditUser').val(),
                "mail": $('#mailEditUser').val()
            }

            $.ajax({
                type: "POST",
                contentType: 'application/json; charset=utf-8',
                url: "/user/editUser",
                dataType: 'text',
                data: JSON.stringify(user),
                success: function (response) {
                    console.log(response);
                    view('userDetails');
                    $('#alert_placeholderEditUser').html('<div class="alert alert-success">' + response + '</div>')
                },
                error: function (response) {
                    console.log(response);
                    $('#alert_placeholderEditUser').html('<div class="alert alert-danger">' + response + '</div>')
                }
            });
        }

    </script>


    <script id="threatsList" type="text/x-jsrender">
        <tr>

            <td>{{:title}}</td>
            <td>{{:year}}</td>
            <td>
            {{for authors}}
                {{:name}} {{:surname}} {{:bornYear}} <br>
            {{/for}}
            </td>
            <td id='condition{{:id}}'>{{:condition.condition}}</td>
            <td>{{:typeOfBook.name}}</td>
            <td>{{:section.name}}</td>
            <td><button class="btn btn-default" onclick="cancelReservation('{{:uuid}}')">Cancel reservation</button></td>

        </tr>




    </script>

</head>
<body onload="view('userDetails')">
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
                            <li role="presentation" class="active" id="userDetailsBookmark"><a onclick="view('userDetails')">User
                                Details</a></li>
                            <li role="presentation" class="" id="borrowedBooksBookmark"><a onclick="view('borrowedBooks')">Borrowed
                                Books</a></li>
                            <li role="presentation" class="" id="reservedBooksBookmark"><a onclick="view('reservedBooks')">Reserved
                                Books</a></li>
                        </ul>
                    </div>
                    <div class="panel-body">


                        <div id="userDetails"></div>
                        <div id="myBooks"></div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
