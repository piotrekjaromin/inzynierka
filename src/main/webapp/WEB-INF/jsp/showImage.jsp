<%--
  Created by IntelliJ IDEA.
  User: piotrek
  Date: 19.03.16
  Time: 22:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Show image</title>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <script>
        function showImage() {
            $.ajax({
                type: "POST",
                url: "showImage",
                dataType: 'text',
                data: {
                    uuid: $("#uuid").val()
                },
                success: function (response) {
                    $('#image').html("<img alt='Embedded Image' src='data:image/png;base64," + response + "'/> ");
                },
                error: function (response) {
                    $('#image').html(response);
                }
            });
        };
    </script>
</head>
<body>


  threat uuid: <input type="text" name="uuid" id = "uuid"/>
  <button type="button" onclick="showImage()">show</button>
<div id="image">

</div>
</body>
</html>
