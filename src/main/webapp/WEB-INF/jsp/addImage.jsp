<%--
  Created by IntelliJ IDEA.
  User: piotrek
  Date: 19.03.16
  Time: 20:33
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

    <title>Add Image</title>

    <jsp:include page="partOfPage/cssImport.jsp"/>
    <jsp:include page="partOfPage/jsImport.jsp"/>
</head>
<body>
<div id="wrapper">
    <jsp:include page="partOfPage/navigator.jsp"/>

    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Add Image</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        Add Image
                    </div>
                    <div class="panel-body">
                        <form method="POST" enctype="multipart/form-data" action="addImage">
                            <input class="form-control" type="text" name="uuid" placeholder="uuid"/>
                            <label class="btn btn-default btn-file">
                                Choose file <input type="file" name="file" style="display: none;"/>
                            </label>
                            <input class="btn btn-default" type="submit" value="Upload"/>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
