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

        function loadVotes(threatUuid) {
            $("#currentThreatUuid").val(threatUuid);
            $.ajax({
                type: "POST",
                url: "/TrafficThreat/loadVotes",
                dataType: 'text',
                data: {
                    uuid: threatUuid
                },
                async: false,
                success: function (response) {
                    var obj = JSON.parse(response);

                    var result = "<table class='table table-striped'><tr><td>stars</td><td>date</td><td>login</td><td>comment</td><td></td></tr>"

                    obj.forEach(function (vote) {
                        result += "<tr>";

                        stars = "";

                        for(i=0;  i< vote.numberOfStars; i++) {
                            stars += "<span class='glyphicon glyphicon-star'></span>"
                        }
                        result += "<td>" + stars+ "</td>"
                        result += "<td>" + vote.date + "</td>"
                        result += "<td>" + vote.login + "</td>"
                        result += "<td>" + vote.voteComment + "</td>"
                        result += "<td><button class='btn btn-default btn-xs' data-toggle='modal' data-target='#replyModal' onclick='$(\"#currentVoteUuid\").val(\""+ vote.uuid + "\")'>reply</button>"
                        result += "</tr>";
                        vote.comments.forEach(function (comment) {
                            result += "<tr style='font-size: 12px'>";
                            result += "<td></td>";
                            result += "<td>" + comment.date + "</td>";
                            result += "<td>" + comment.login + "</td>";
                            result += "<td>" + comment.comment + "</td>";
                            result += "<td></td>";

                            result += "</tr>"
                        })
                    })
                    result += "</table>";
                    result += "<button class='btn btn-default btn-xs' data-toggle='modal' data-target='#votesCommentModal'>Add Vote</button>"
                    $("#insertVotes").html(result);
                }
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
            if ($("#uuid").val() == "") {
                $('#alert_placeholder').html('<div class="alert alert-danger">Error: no uuid</div>')
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
                    stars: document.getElementsByClassName("rating-input")[0].getElementsByClassName('glyphicon-star').length,
                    uuid: $("#currentThreatUuid").val(),
                    comment: $("#comment").val()
                },
                success: function (response) {
                    if(response == "Success") {
                        window.location.reload(false);
                    }
                },
                error: function (response) {
                    $('#alert_addVote').html('<div class="alert alert-danger">' + response + '</div>')
                }
            });
        }
        ;

        function reply() {

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
                    var context = "type: ${threat.type.name}<br>";
                    context += "description: ${threat.description}<br>";
                    context += "date: ${threat.date}<br>";
                    context += "<img height='100' alt='No image' src='data:image/png;base64," + showImage('${threat.uuid}') + "'/><br>";
                    context += "<button class='btn btn-default' onclick='location.href=\"/TrafficThreat/getThreatDetails/?uuid=${threat.uuid}\"'>show details</button>";
                    context += "<button class='btn btn-default' data-toggle='modal' data-target='#votesModal' onclick='loadVotes(\"${threat.uuid}\")'>votes</button>";

                    infowindow.setContent(context);
                    infowindow.open(map, marker);
                }
            })(marker, counter));
            </c:forEach>
        }

        (function ($) {

            $.fn.rating = function () {

                var element;

                // A private function to highlight a star corresponding to a given value
                function _paintValue(ratingInput, value) {
                    var selectedStar = $(ratingInput).find('[data-value=' + value + ']');
                    selectedStar.removeClass('glyphicon-star-empty').addClass('glyphicon-star');
                    selectedStar.prevAll('[data-value]').removeClass('glyphicon-star-empty').addClass('glyphicon-star');
                    selectedStar.nextAll('[data-value]').removeClass('glyphicon-star').addClass('glyphicon-star-empty');
                }

                // A private function to remove the selected rating
                function _clearValue(ratingInput) {
                    var self = $(ratingInput);
                    self.find('[data-value]').removeClass('glyphicon-star').addClass('glyphicon-star-empty');
                    self.find('.rating-clear').hide();
                    self.find('input').val('').trigger('change');
                }

                // Iterate and transform all selected inputs
                for (element = this.length - 1; element >= 0; element--) {

                    var el, i, ratingInputs,
                            originalInput = $(this[element]),
                            max = originalInput.data('max') || 5,
                            min = originalInput.data('min') || 0,
                            clearable = originalInput.data('clearable') || null,
                            stars = '';

                    // HTML element construction
                    for (i = min; i <= max; i++) {
                        // Create <max> empty stars
                        stars += ['<span class="glyphicon glyphicon-star-empty" data-value="', i, '"></span>'].join('');
                    }
                    // Add a clear link if clearable option is set
                    if (clearable) {
                        stars += [
                            ' <a class="rating-clear" style="display:none;" href="javascript:void">',
                            '<span class="glyphicon glyphicon-remove"></span> ',
                            clearable,
                            '</a>'].join('');
                    }

                    el = [
                        // Rating widget is wrapped inside a div
                        '<div class="rating-input">',
                        stars,
                        // Value will be hold in a hidden input with same name and id than original input so the form will still work
                        '<input type="hidden" name="',
                        originalInput.attr('name'),
                        '" value="',
                        originalInput.val(),
                        '" id="',
                        originalInput.attr('id'),
                        '" />',
                        '</div>'].join('');

                    // Replace original inputs HTML with the new one
                    originalInput.replaceWith(el);

                }

                // Give live to the newly generated widgets
                $('.rating-input')
                // Highlight stars on hovering
                        .on('mouseenter', '[data-value]', function () {
                            var self = $(this);
                            _paintValue(self.closest('.rating-input'), self.data('value'));
                        })
                        // View current value while mouse is out
                        .on('mouseleave', '[data-value]', function () {
                            var self = $(this);
                            var val = self.siblings('input').val();
                            if (val) {
                                _paintValue(self.closest('.rating-input'), val);
                            } else {
                                _clearValue(self.closest('.rating-input'));
                            }
                        })
                        // Set the selected value to the hidden field
                        .on('click', '[data-value]', function (e) {
                            var self = $(this);
                            var val = self.data('value');
                            self.siblings('input').val(val).trigger('change');
                            self.siblings('.rating-clear').show();
                            e.preventDefault();
                            false
                        })
                        // Remove value on clear
                        .on('click', '.rating-clear', function (e) {
                            _clearValue($(this).closest('.rating-input'));
                            e.preventDefault();
                            false
                        })
                        // Initialize view with default value
                        .each(function () {
                            var val = $(this).find('input').val();
                            if (val) {
                                _paintValue(this, val);
                                $(this).find('.rating-clear').show();
                            }
                        });

            };

            // Auto apply conversion of number fields with class 'rating' into rating-fields
            $(function () {
                if ($('input.rating[type=number]').length > 0) {
                    $('input.rating[type=number]').rating();
                }
            });

        }(jQuery));
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
                            <div class="table-responsive">
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
                                            <td><c:out value="${threat.type.name}"/></td>
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
                        </div>
                        <div id="image"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--alter table threat drop constraint fkcf3t634qwigq9sv7cicw4y3wj--%>

</div>
<jsp:include page="partOfPage/modals/votes.jsp"/>
</body>
</html>