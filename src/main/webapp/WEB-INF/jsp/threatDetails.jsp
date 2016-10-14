<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%--
  Created by IntelliJ IDEA.
  User: piotrek
  Date: 10.04.16
  Time: 22:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" type="text/css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <script async defer
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxPnLikp9JZlQjap5fpX4L6y3eeCNPz9o&callback=initMap">
    </script>
    <title>Show details</title>
    <script>
        function showImage(threatUuid) {
            <c:if test="${threat.pathToPhoto ne null}">
            $.ajax({
                type: "POST",
                url: "/TrafficThreat/showImage",
                dataType: 'text',
                data: {
                    uuid: threatUuid
                },
                success: function (response) {
                    $('#image').html("<img alt='Embedded Image' src='data:image/png;base64," + response + "'/> ");
                },
                error: function (response) {
                    $('#image').html(response);
                }
            });
            </c:if>
        }
        ;
    </script>

    <script>

        function initMap() {
            var myLatLng = {lat: ${threat.coordinates.horizontal}, lng: ${threat.coordinates.vertical}};

            var map = new google.maps.Map(document.getElementById('map'), {
                zoom: 14,
                center: myLatLng
            });

            var marker = new google.maps.Marker({
                position: myLatLng,
                map: map,
                title: '${threat.description}'
            });
        }
    </script>
</head>

<body onload="showImage('${threat.uuid}')">
<div class="panel panel-primary">
    <div class="panel-heading">
        Show details
        <button class="btn btn-default goToMainPage" onclick="window.location.href='/TrafficThreat'">Go to main page
        </button>
    </div>
    <div class="panel-body">
        <div class="table-responsive">
            <table class="table table-striped">
                <tr>
                    <td>uuid:</td>
                    <td>${threat.uuid}</td>
                </tr>
                <tr>
                    <td>type</td>
                    <td>${threat.type.threatType}</td>
                </tr>
                <tr>
                    <td>description</td>
                    <td>${threat.description}</td>
                </tr>
                <tr>
                    <td>login</td>
                    <td>${threat.login}</td>
                </tr>
                <tr>
                    <td>date</td>
                    <td>${threat.date}</td>
                </tr>
                <tr>
                    <td>vote</td>
                    <td>
                        <c:forEach items="${threat.votes}" var="vote">
                            ${vote.numberOfStars}, ${vote.login}, ${vote.comment}. ${vote.date}<br/>
                        </c:forEach>
                    </td>
                <tr>
                    <td>address</td>
                    <td>${threat.coordinates.street}, ${threat.coordinates.city}</td>
                </tr>
                <tr>
                    <td>isApproved</td>
                    <td>${threat.isApproved}</td>
                </tr>
                <sec:authorize access="hasRole('ADMIN')">
                    <tr>
                        <td>edit</td>
                        <td>
                            <button class="btn btn-default"
                                    onclick="location.href='/TrafficThreat/getThreat/?uuid=${threat.uuid}'">edit
                            </button>
                        </td>
                    </tr>
                </sec:authorize>
                <sec:authorize access="hasAnyRole('ADMIN', 'USER')">
                <tr>
                    <td>add vote</td>
                    <td>
                        <button class="btn btn-default"
                                onclick="location.href='/TrafficThreat/user/addVoteForThreat/?uuid=${threat.uuid}'">add
                            vote
                        </button>
                    </td>

                </tr>
                </sec:authorize>

            </table>
        </div>
        <div id="map" style="width: 60%; height: 60%"></div>

        <span id="image"/>


    </div>
</div>

</body>
</html>
