<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="googlemaps" uri="/WEB-INF/googlemaps.tld" %>
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
            var result;
            $.ajax({
                type: "POST",
                url: "/TrafficThreat/showImage",
                dataType: 'text',
                data: {
                    uuid: threatUuid
                },
                async: false,
                success: function (response) {
                    result = response;
                }
            });
            return result;
        }
        ;

        function initMap() {
            var myLatLng = {lat: 50.0618971, lng: 19.93675600000006};
            var counter = 0;
            var marker;
            var map = new google.maps.Map(document.getElementById('map'), {
                zoom: 14,
                center: myLatLng
            });

            var infowindow = new google.maps.InfoWindow();

            <c:forEach items="${approvedThreats}" var="threat">
            counter = counter + 1;

            marker = new google.maps.Marker({
                position: new google.maps.LatLng(${threat.coordinates.horizontal}, ${threat.coordinates.vertical}),
                map: map,
                title: '${threat.description}'
            });

            google.maps.event.addListener(marker, 'click', (function (marker, counter) {
                return function () {
                    var context = "type: ${threat.type.threatType}<br>";
                    context += "description: ${threat.description}<br>";
                    context += "date: ${threat.date}<br>";
                    context += "<img height='100' alt='No image' src='data:image/png;base64," + showImage('${threat.uuid}') + "'/><br>";
                    context += "<button onclick='location.href=\"/TrafficThreat/getThreatDetails/?uuid=${threat.uuid}\"'>show details</button>";

                    infowindow.setContent(context);
                    infowindow.open(map, marker);
                }
            })(marker, counter));
            </c:forEach>
        }
    </script>

</head>

<body onload="initMap()">

<div id="wrapper">
    <jsp:include page="partOfPage/navigator.jsp"/>

    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Dashboard</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        Traffic Threats Map
                    </div>
                    <div class="panel-body">
                        <%--<button class='btn btnMenu btn-primary' onclick="location.href='showThreats'">Show threats</button>--%>

                        <%--<sec:authorize access="hasAnyRole('ADMIN', 'USER')">--%>
                        <%--<button class='btn btnMenu btn-primary' onclick="location.href='/TrafficThreat/user/addThreat'">Add threat</button>--%>
                        <%--<button class='btn btnMenu btn-primary' onclick="location.href='/TrafficThreat/user/addImage'">Add image</button>--%>
                        <%--<button class='btn btnMenu btn-primary' onclick="location.href='showLogs'">Show logs</button>--%>
                        <%--</sec:authorize>--%>

                        <%--<sec:authorize access="hasRole('ADMIN')">--%>
                        <%--<button class='btn btnMenu btn-primary' onclick="location.href='admin/showUsers'">Show users</button>--%>
                        <%--<button class='btn btnMenu btn-primary' onclick="location.href='admin/addThreatType'">Add threat type</button>--%>
                        <%--</sec:authorize>--%>

                        <%--<br/>--%>
                        <%--<br/>--%>

                        <div id="map" style="width: 100%; height: 100%"></div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Threats Added Today
                        </div>
                        <div class="panel-body">
                            <table class="table table-striped">
                                <tr>
                                    <th>uuid</th>
                                    <th>login</th>
                                    <th>type</th>
                                    <th>description</th>
                                    <th>is approved</th>
                                    <th>details</th>
                                </tr>
                                <c:forEach items="${addedToday}" var="threat">
                                    <tr>
                                        <td><c:out value="${threat.uuid}"/></td>
                                        <td><c:out value="${threat.login}"/></td>
                                        <td><c:out value="${threat.type.threatType}"/></td>
                                        <td><c:out value="${threat.description}"/></td>
                                        <td><c:out value="${threat.isApproved}"/></td>
                                        <td>
                                            <button class="btn btn-default" onclick="location.href='getThreatDetails/?uuid=${threat.uuid}'">
                                                details
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>


                            </table>
                        </div>
                        <div id="image"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>