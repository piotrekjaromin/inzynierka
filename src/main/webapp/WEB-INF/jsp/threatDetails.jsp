<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            if ($("#stars").val() == "") {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: no stars </div>')
                return;
            }
            if ($("#comment").val() == "") {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: no comment</div>')
                return;
            }

            addVote();

        }

        function reply() {

            console.log("in reply")
            $.ajax({
                type: "POST",
                url: "/TrafficThreat/user/replyToComment",
                dataType: 'text',
                data: {
                    uuid: $("#currentVoteUuid").val(),
                    comment: $("#voteComment").val()
                },
                success: function (response) {
                    result = response;
                },
                error: function (response) {
                    $('#alert_addVote').html('<div class="alert alert-danger">' + response + '</div>')
                }
            });
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
        }
        ;

        function insertStars(stars) {

            result = "";
            for (i = 0; i < parseInt(stars); i++) {
                result += "<span class='glyphicon glyphicon-star'></span>"
            }

            $("#numberOfStars").innerHTML(result);
        }

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
                                    <td>date type</td>
                                    <td>${threat.dateType}</td>
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
                                    <td><fmt:formatDate type="both"
                                                        dateStyle="medium" timeStyle="medium"
                                                        value="${threat.date}" /></td>
                                </tr>

                                <c:if test="${threat.dateType eq 'jednorazowe'}">
                                    <tr>
                                        <td>start date</td>
                                        <td><fmt:formatDate type="both"
                                                            dateStyle="medium" timeStyle="medium"
                                                            value="${threat.startDate}" /></td>
                                    </tr>
                                    <tr>
                                        <td>end date</td>
                                        <td><fmt:formatDate type="both"
                                                            dateStyle="medium" timeStyle="medium"
                                                            value="${threat.endDate}" /></td>
                                    </tr>
                                </c:if>
                                <c:if test="${threat.dateType eq 'okresowe'}">
                                    <tr>
                                        <td>days</td>
                                        <td>
                                        <c:forEach items="${threat.periodicDays}" var="day">
                                            <c:if test="${day eq '1'}">
                                                poniedziałek
                                            </c:if>
                                            <c:if test="${day eq '2'}">
                                                wtorek
                                            </c:if>
                                            <c:if test="${day eq '3'}">
                                                środa
                                            </c:if>
                                            <c:if test="${day eq '4'}">
                                                czwartek
                                            </c:if>
                                            <c:if test="${day eq '5'}">
                                                piątek
                                            </c:if>
                                            <c:if test="${day eq '6'}">
                                                sobota
                                            </c:if>
                                            <c:if test="${day eq '7'}">
                                                niedziela
                                            </c:if>
                                        </c:forEach>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>begin time</td>
                                        <td><fmt:formatDate pattern="HH:mm"
                                                            value="${threat.startDate}" /></td>
                                    </tr>
                                    <tr>
                                        <td>end time</td>
                                        <td><fmt:formatDate pattern="HH:mm"
                                                            value="${threat.endDate}" /></td>
                                    </tr>

                                </c:if>


                                <tr>
                                    <td>address</td>
                                    <td>${threat.coordinates.street}, ${threat.coordinates.city}</td>
                                </tr>
                                <tr>
                                    <td>isApproved</td>
                                    <td>${threat.isApproved}</td>
                                </tr>
                                <sec:authorize access="hasAnyRole('ADMIN', 'USER')">
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

                    </div>
                </div>
            </div>


            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">Photos/Videos
                            <sec:authorize access="hasAnyRole('ADMIN', 'USER')">
                                <form style="display: inline;" method="POST" id="addThreatID" enctype="multipart/form-data" action="/TrafficThreat/user/addPhotos">
                                    <label class="btn btn-default btn-file">
                                        <input type="file" name="file" accept=".jpg, .png, .mp4" multiple/>
                                    </label>

                                    <input type="hidden" name="threatUuid" value="${threat.uuid}">
                                    <button type="submit">Upload</button>
                                </form>
                                <br>
                            </sec:authorize>
                        </div>
                        <div class="panel-body">

                            <c:forEach items="${photos}" var="photo">

                                <img src="/directory-listing-uri/${photo}" alt="photo" height="20%" width="20%">
                            </c:forEach>


                            <c:forEach items="${videos}" var="video">

                                <video width="320" height="240" controls>
                                    <source src="/directory-listing-uri/${video}" type="video/mp4">
                                    Your browser does not support the video tag.
                                </video>
                            </c:forEach>
                        </div>
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
                                <button class='btn btn-default' data-toggle='modal' data-target='#edit'>Add</button>
                                <br>
                            </sec:authorize>
                        </div>
                        <div class="panel-body">
                            <table class="table table-striped">
                                <tr>
                                    <th>vote</th>
                                    <th>login</th>
                                    <th>added date</th>
                                    <th>comment</th>
                                    <th></th>
                                </tr>
                                <c:forEach items="${threat.votes}" var="vote">
                                    <tr>
                                        <td id="numberOfStars" nowrap>
                                            <c:forEach begin="1" end="${vote.numberOfStars}" var="star">
                                                <span class='glyphicon glyphicon-star'></span>
                                            </c:forEach>
                                        </td>
                                        <td><c:out value="${vote.login}"/></td>
                                        <td><c:out value="${vote.date}"/></td>
                                        <td><c:out value="${vote.voteComment}"/></td>
                                    </tr>

                                    <c:forEach items="${vote.comments}" var="comment">
                                        <tr style='font-size: 12px'>
                                            <td></td>
                                            <td>${comment.login}</td>
                                            <td>${comment.date}</td>
                                            <td>${comment.comment}</td>
                                        </tr
                                    </c:forEach>
                                </c:forEach>


                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
