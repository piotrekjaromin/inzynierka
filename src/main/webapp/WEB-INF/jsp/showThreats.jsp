<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>All Threats</title>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <jsp:include page="partOfPage/cssImport.jsp"/>
    <jsp:include page="partOfPage/jsImport.jsp"/>
    <script>
        function showImage(threatUuid) {
            $.ajax({
                type: "POST",
                url: "showImage",
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
        }
        ;

        function approve(threatUuid) {
            $.ajax({
                type: "POST",
                url: "/TrafficThreat/admin/approve",
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
        }
        ;

        function disapprove(threatUuid) {
            $.ajax({
                type: "POST",
                url: "/TrafficThreat/admin/disapprove",
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
        }
        ;

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
                    alert(response)
                }
            });
        };


    </script>
</head>
<body>
<div id="wrapper">
    <jsp:include page="partOfPage/navigator.jsp"/>

    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Show Threats</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        Traffic Threats List
                    </div>
                    <div class="panel-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <tr>
                                    <th>uuid</th>
                                    <th>login</th>
                                    <th>type</th>
                                    <th>description</th>
                                    <sec:authorize access="hasRole('ADMIN')">
                                        <th>is approved</th>
                                        <th>delete</th>
                                    </sec:authorize>
                                    <th>details</th>
                                </tr>
                                <c:forEach items="${threats}" var="threat">
                                    <tr>
                                        <td><c:out value="${threat.uuid}"/></td>
                                        <td><c:out value="${threat.login}"/></td>
                                        <td><c:out value="${threat.type.threatType}"/></td>
                                        <td><c:out value="${threat.description}"/></td>
                                        <sec:authorize access="hasRole('ADMIN')">
                                            <c:choose>
                                                <c:when test="${threat.isApproved eq true}">
                                                    <td>
                                                        <button class="btn btn-default" onclick="disapprove('${threat.uuid}')">
                                                            disapprove
                                                        </button>
                                                    </td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td>
                                                        <button class="btn btn-default" onclick="approve('${threat.uuid}')">approve
                                                        </button>
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>

                                            <td>
                                                <button class="btn btn-default" onclick="deleteThreat('${threat.uuid}')">delete</button>
                                            </td>
                                        </sec:authorize>
                                        <td>
                                            <button class="btn btn-default" onclick="location.href='getThreatDetails/?uuid=${threat.uuid}'">
                                                details
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>


                            </table>
                        </div>
                    </div>
                    <div id="image"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<%--</textarea>--%>
</body>
</html>
