<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Add Threat</title>

    <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxPnLikp9JZlQjap5fpX4L6y3eeCNPz9o&callback=initMap"></script>
    <jsp:include page="partOfPage/cssImport.jsp"/>
    <jsp:include page="partOfPage/jsImport.jsp"/>

    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <%--<style>--%>
    <%--html, body {--%>
    <%--height: 100%;--%>
    <%--margin: 0;--%>
    <%--padding: 0;--%>
    <%--}--%>
    <%--/*#map {*/--%>
    <%--/*height: 70%;*/--%>
    <%--/*}*/--%>
    <%--#floating-panel {--%>
    <%--position: absolute;--%>
    <%--top: 10px;--%>
    <%--left: 25%;--%>
    <%--z-index: 5;--%>
    <%--background-color: #fff;--%>
    <%--padding: 5px;--%>
    <%--border: 1px solid #999;--%>
    <%--text-align: center;--%>
    <%--font-family: 'Roboto','sans-serif';--%>
    <%--line-height: 30px;--%>
    <%--padding-left: 10px;--%>
    <%--}--%>
    <%--</style>--%>

    <script>

        var map;
        var geocoder;

        function checkData() {
            if ($("#typeOfThreat").val() == null) {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: no choosen type of threat </div>')
                return false;
            }
            if ($("#description").val() == "") {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: no description</div>')
                return false;
            }
            if ($("#coordinates").val() == "" || $("#coordinates").val().split(';').length != 2) {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: bad coordinates</div>')
                return false;
            }

            if ($("#address").val() == "") {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: bad location</div>')
                return false;
            }

            return true;

        }

        function addThreat() {

//            if(!geocodeAddress(geocoder, map))  {
//                console.log("error geocode");
//                return;
//            }

            if (!checkData()) {
                console.log("error checkData");
                return;
            }

            $.ajax({
                type: "POST",
                url: "addThreat",
                dataType: 'text',
                data: {
                    typeOfThreat: $("#typeOfThreat").val(),
                    description: $("#description").val(),
                    coordinates: $("#coordinates").val(),
                    address: $("#address").val()

                },
                success: function (response) {
                    $(".form-inline").hide();
                    $('#alert_placeholder').html('<div class="alert alert-success">' + response + '</div>')

                },
                error: function (response) {
                    $('#alert_placeholder').html('<div class="alert alert-danger">' + response + '</div>')
                }
            });
        }

        function initMap() {
            map = new google.maps.Map(document.getElementById('map'), {
                zoom: 8,
                center: {lat: 50.061, lng: 19.937}
            });
            geocoder = new google.maps.Geocoder();

            document.getElementById('submit').addEventListener('click', function () {
                geocodeAddress(geocoder, map);
            });
        }

        function geocodeAddress(geocoder, resultsMap) {
            var isCorrect = false;
            var address = document.getElementById('address').value;
            geocoder.geocode({'address': address}, function (results, status) {
                if (status === google.maps.GeocoderStatus.OK) {
                    console.log("correct");
                    isCorrect = true;
                    $('#coordinates').val(results[0].geometry.location.lat() + ";" + results[0].geometry.location.lng());
                    resultsMap.setZoom(15);
                    resultsMap.setCenter(results[0].geometry.location);

                    var marker = new google.maps.Marker({
                        map: resultsMap,
                        position: results[0].geometry.location
                    });
                } else {
                    alert('Geocode was not successful for the following reason: ' + status);
                    console.log("in geo");
                }
            });
            console.log(isCorrect);
            return isCorrect;
        }
    </script>

</head>
<body onload="initMap()">

<div id="wrapper">
    <jsp:include page="partOfPage/navigator.jsp"/>

    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Add Threat</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        Add Threat
                    </div>
                    <div class="panel-body">

                        <select class="form-control" id="typeOfThreat" required>
                            <option value="" disabled selected hidden>Type of threat</option>
                            <c:forEach var="threatType" items="${threatTypes}">
                                <option value=${threatType.threatType}>${threatType.threatType}</option>
                            </c:forEach>
                        </select>
                        <input type="text" id="description" class="form-control" placeholder="Description">
                        <input type="hidden" id="coordinates" class="form-control">
                        <input id="address" type="textbox" class="form-control" value="Rynek główny, Kraków">
                        <input id="submit" class="btn btn-default" type="button" value="check location">
                        <button onclick="addThreat()" class="btn btn-default">Add threat</button>
                        <div id="alert_placeholder"></div>

                        <br/>
                        <div id="map" style="width: 60%; height: 60%"></div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    </div>

</body>
</html>
