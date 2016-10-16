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
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Index</title>

    <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxPnLikp9JZlQjap5fpX4L6y3eeCNPz9o&callback=initMap"></script>
    <jsp:include page="partOfPage/cssImport.jsp"/>
    <jsp:include page="partOfPage/jsImport.jsp"/>

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
                    $('#image').html("<img alt='Embedded Image' style='width: 100%;' src='data:image/png;base64," + response + "'/> ");
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
<div id="wrapper">
    <jsp:include page="partOfPage/navigator.jsp"/>

    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Threat Details</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <table style="width: 100%; height: 60%">
                        <tr>
                            <td><div id="map" style="width: 100%; height: 99%"/></td>
                        </tr>
                        </table>

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
                                            <button class="btn btn-default" onclick="location.href='/TrafficThreat/getThreat/?uuid=${threat.uuid}'">edit
                                            </button>
                                        </td>
                                    </tr>
                                </sec:authorize>
                                <sec:authorize access="hasAnyRole('ADMIN', 'USER')">
                                    <tr>
                                        <td>add vote</td>
                                        <td>
                                            <button class="btn btn-default" onclick="location.href='/TrafficThreat/user/addVoteForThreat/?uuid=${threat.uuid}'">add
                                                vote
                                            </button>
                                        </td>

                                    </tr>
                                </sec:authorize>

                            </table>
                        </div>

                        <table style="width: 100%; height: 60%">
                            <tr><td><div id="image"/></td></tr>
                        </table>


                    </div>
                </div>
            </div>
        </div>
        </div>
    </div>

</body>
</html>
