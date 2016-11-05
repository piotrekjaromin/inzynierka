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
                    $('#image').html("<table style='width: 100%; height: 60%'><tr><td><img alt='Embedded Image' style='width: 100%;' src='data:image/png;base64," + response + "'/></td></tr></table> ");
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


        function checkData() {
            if($("#stars").val() == "") {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: no stars </div>')
                return;
            }
            if($("#comment").val() == "") {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: no comment</div>')
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
                    $('#addCommentFields').hide();
                    location.reload(true)
                },
                error: function (response) {
                    $('#alert_placeholder').html('<div class="alert alert-danger">' + response + '</div>')
                }
            });
        };
    </script>
</head>

<body onload="initMap(); showImage('${threat.uuid}')">
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
                                <td>
                                    <div id="map" style="width: 100%; height: 99%"/>
                                </td>
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
                                    <td>${threat.type.name}</td>
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
                                            <button class="btn btn-default" onclick="location.href='/TrafficThreat/editThreat/?uuid=${threat.uuid}'">edit
                                            </button>
                                        </td>
                                    </tr>
                                </sec:authorize>
                            </table>
                        </div>
                        <div id="image"/>

                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Comments
                            <sec:authorize access="hasAnyRole('ADMIN', 'USER')">
                                <%--<button class="btn btn-default" onclick="location.href='/TrafficThreat/user/addVoteForThreat/?uuid=${threat.uuid}'">Add</button>--%>
                                <button class='btn btn-default' data-toggle='modal' data-target='#edit'>Add</button><br>
                            </sec:authorize>
                        </div>
                        <div class="panel-body">
                            <table class="table table-striped">
                                <tr>
                                    <th>vote</th>
                                    <th>login</th>
                                    <th>date</th>
                                    <th>comment</th>
                                    <th></th>
                                </tr>
                                <c:forEach items="${threat.votes}" var="vote">
                                    <tr>
                                        <td><c:out value="${vote.numberOfStars}"/></td>
                                        <td><c:out value="${vote.login}"/></td>
                                        <td><c:out value="${vote.date}"/></td>
                                        <td><c:out value="${vote.voteComment}"/></td>
                                        <td><button class="btn btn-default btn-xs">reply</button></td>
                                    </tr>
                                </c:forEach>


                            </table>
                        </div>
                    </div>
                </div>
            </div>


        </div>
    </div>
</div>
<jsp:include page="partOfPage/modals/addVote.jsp"/>
</body>
</html>
