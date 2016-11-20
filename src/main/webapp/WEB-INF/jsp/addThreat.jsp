<%@ page import="com.models.ThreatType" %>
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
    <script src="//ajax.googleapis.com/ajax/libs/dojo/1.11.2/dojo/dojo.js"></script>
    <jsp:include page="partOfPage/cssImport.jsp"/>
    <jsp:include page="partOfPage/jsImport.jsp"/>
    <link rel="stylesheet" type="text/css" href="/TrafficThreat/resources/css/bootstrap-multiselect.css"/>
    <script src="/TrafficThreat/resources/js/bootstrap-multiselect.js"></script>

    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">

    <%!public String printTypes(ThreatType type, String dashes) {

        if (type != null) {
            String result;
            dashes += "---|";
            if (type.getChilds().isEmpty()) {
                result = "<option value = '" + type.getUuid() + "'>" + dashes + type.getName() + "</option>";
            } else {
                result = "<option disabled value = '" + type.getUuid() + "'>" + dashes + type.getName() + "</option>";
            }

            for (ThreatType typeTmp : type.getChilds()) {
                result = result + printTypes(typeTmp, dashes);
            }
            return result;
        } else return "";
    }%>

    <script>

        var map;
        var geocoder;

        $(document).ready(function () {
            $('#example-getting-started').multiselect();
        });

        function subFunction() {
            if ($("#typeOfThreat").val() == null) {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: no choosen type of threat </div>')
                return false;
            }
            if ($("#description").val() == "") {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: no description</div>')
                return false;
            }

            if ($("#description").val().length < 10) {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: description too short</div>')
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

            $("#checkLocation").click();
            $("#addThreatID").submit();


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
                    $("#addThreatForm").hide();
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

            document.getElementById('checkLocation').addEventListener('click', function () {
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


        function insertDateToType() {
            result = "";

            if ($("#typeOfThreat2").val() == "jednorazowe") {

                result += "<div class='form-group col-xs-3'><input type='text' id='startDate' name='startDate' class='form-control col-xs-3' placeholder='start date'></div>"
                result += "<div class='form-group col-xs-3'><input type='text' id='endDate' name='startDate' class='form-control col-xs-3' placeholder='end date'></div>"
                $("#dateOfTypeFields").html(result);

            } else if ($("#typeOfThreat2").val() == "okresowe") {
                result = "<select id='example-getting-started' multiple='multiple'>"
                result += "<option value='1'>Monday</option>"
                result += "<option value='2'>Tuesday</option>"
                result += "<option value='3'>Wednesday</option>"
                result += "<option value='4'>Thursday</option>"
                result += "<option value='5'>Friday</option>"
                result += "<option value='6'>Saturday</option>"
                result += "<option value='7'>Sunday</option>"
                result += "</select>"
                $("#dateOfTypeFields").html(result);
                $('#example-getting-started').multiselect()

            } else $("#dateOfTypeFields").html("");

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

                        <div id="addThreatForm">

                            <form method="POST" id="addThreatID" enctype="multipart/form-data" action="/TrafficThreat/user/addThreat">
                                <div class="row">
                                    <div class="form-group col-xs-3">
                                        <label class="btn btn-default btn-file">
                                            Choose file <input type="file" name="file" style="display: none;" multiple/>
                                        </label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group col-xs-4">
                                        <select class="form-control col-xs-3" id="typeOfThreat" name="typeOfThreat" required>
                                            <option value="" disabled selected hidden>Type of threat</option>
                                            <% out.print(printTypes((ThreatType) request.getAttribute("threatType"), "")); %>
                                        </select>
                                    </div>
                                </div>

                                <div class='row'>
                                    <div class="form-group col-xs-5">
                                        <select class="form-control" id="typeOfThreat2" name="typeOfThreat2" required onclick="insertDateToType()">
                                            <option value="" disabled selected hidden>Date type</option>
                                            <option value="jednorazowe">Jednorazowe</option>
                                            <option value="stałe">Stałe</option>
                                            <option value="okresowe">Okresowe</option>
                                        </select></div>

                                    <div id="dateOfTypeFields"></div>
                                </div>
                                <div class='row'>
                                    <div class="form-group col-xs-7">
                                        <input type="text" id="description" name="description" class="form-control" placeholder="Description">
                                    </div>
                                </div>
                                <input type="hidden" id="coordinates" name="coordinates" class="form-control">
                                <div class='row'>
                                    <div class="input-group form-group col-xs-7">
                                        <input id="address" type="textbox" class="form-control" name="address" value="Rynek główny, Kraków">
                                        <span class="input-group-btn">
                                        <button id="checkLocation" class="btn btn-default" type="button">Go!</button>
                                        </span>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group col-xs-4">
                                        <input type="button" onclick="subFunction()" class="btn btn-default" value="Add Threat">
                                    </div>
                                </div>
                            </form>
                        </div>
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
