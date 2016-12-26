<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Show users</title>

    <jsp:include page="partOfPage/cssImport.jsp"/>
    <jsp:include page="partOfPage/jsImport.jsp"/>
</head>
<body>

<div id="wrapper">
    <jsp:include page="partOfPage/navigator.jsp"/>

    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Show Users</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        Users List
                    </div>
                    <div class="panel-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <tr>
                                    <td>login</td>
                                    <td>mail</td>
                                    <td>name</td>
                                    <td>surname</td>
                                    <td>threats uuid</td>
                                </tr>
                                <c:forEach items="${users}" var="user">
                                    <tr>
                                        <td><c:out value="${user.login}"/></td>
                                        <td><c:out value="${user.mail}"/></td>
                                        <td><c:out value="${user.name}"/></td>
                                        <td><c:out value="${user.surname}"/></td>
                                        <td>
                                            <c:forEach items="${user.threats}" var="threat">
                                                <c:out value="${threat.uuid}"/><br/>
                                            </c:forEach>
                                        </td>

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

</body>
</html>
