<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add vote</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

    <script>

        function checkData() {
            if($("#stars").val() == "") {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: no stars </div>')
                return;
            }
            if($("#comment").val() == "") {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: no comment</div>')
                return;
            }
            if($("#uuid").val() == "") {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: no uuid</div>')
                return;
            }

            addVote();

        }


        function addVote() {
            $.ajax({
                type: "POST",
                url: "/TrafficThreat/user/addVoteForThreat",
                dataType: 'text',
                data: {
                    stars: $("#stars").val(),
                    uuid: $("#uuid").val(),
                    comment: $("#comment").val()
                },
                success: function (response) {
                    $('#alert_placeholder').html('<div class="alert alert-success">' + response + '</div>')
                },
                error: function (response) {
                    $('#alert_placeholder').html('<div class="alert alert-danger">' + response + '</div>')
                }
            });
        }
        ;
    </script>

</head>
<body>
<div class="panel panel-primary">
    <div class="panel-heading">
        Add vote
        <button class="btn btn-default" onclick="window.location.href='/TrafficThreat'">Go to main page</button>
    </div>
    <div class="panel-body">
        <input type="number" id="stars" class="form-control" placeholder="Number of stars">
        <input type="text" id="comment" class="form-control" placeholder="Comment">
        <c:choose>
            <c:when test="${threatUuid eq null}">
                <input type="text" id="uuid" class="form-control" placeholder="Thread uuid">
            </c:when>
            <c:otherwise>
                <input type="hidden" id="uuid" value="${threatUuid}">
            </c:otherwise>
        </c:choose>

        <button onclick="checkData()" class="btn btn-default">Add Vote</button>
        <div id="alert_placeholder"></div>
    </div>
</div>

</body>
</html>
