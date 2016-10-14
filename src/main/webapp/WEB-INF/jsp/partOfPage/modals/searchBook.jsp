<%@ taglib prefix="Author" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript">
    var searchType = "";

    function search(type) {

        var author = {
            "name": $("#authorName").val(),
            "surname": $("#authorSurname").val(),
            "bornYear": $("#authorYear").val()
        }


        var book = {
            "title": $("#title").val(),
            "year": $("#year").val(),
            "authors": [author]
        };

        var searchBook = {
            "book": book,
            "searchType": type.toString()
        }

        console.log(searchBook);

        $.ajax({
            type: "POST",
            contentType: 'application/json; charset=utf-8',
            url: "/searchBooks",
            data: JSON.stringify(searchBook),
            dataType: "json",
            success: function (response) {
//                searchType = type;
//                console.log(response);
//                $("#displayTable").html(createTable(response));

                window.location="/showBooks/page?variable=" + searchBook;
            },

            error: function (e) {

//                alert('Error: ' + e);
//                console.log(e)

            }
        });
    }

    function show() {
        console.log("in show");
        $.ajax({
            type: "POST",
            url: "/showBooks",
            data: {},
            dataType: "json",
            success: function (response) {
                $("#displayTable").html(createTable(response));
            },

            error: function (e) {

                alert('Error: ' + e);
                console.log(e)

            }
        });
    }


    function createTable(json) {
        var myTemplate = $.templates("#BookTmpl");
        var html = "<table class='table' >"
        html += '<tr>' +
                '<th>Title</th>' +
                '<th>Year</th>' +
                '<th>Author</th>' +
                '<th>Condition</th>' +
                '<th>Type Of Book</th>' +
                '<th>Section</th>' +
                <sec:authorize access="hasRole('ADMIN')">
                '<th>Edit</th>' +
                </sec:authorize>
                <sec:authorize access="hasAnyRole('ADMIN', 'USER')">
                '<th>Uuid</th>' +
                '<th>Action</th>' +
                '<th>Generate QR Code</th>' +

                </sec:authorize>

                '</tr>';

        html += myTemplate.render(json);
        html += "</table>";
        console.log(html);
        return html;
    }


    function editBook(uuid) {

        $.ajax({
            type: "POST",
            url: "/admin/editBook",
            data: {
                "uuid": uuid
            },
            dataType: "text",
            success: function (response) {
                alert(response);
                show();

            },

            error: function (e) {
                alert("Oops! Something has gone wrong")
                show();
            }
        });
    }

    function reserveBook(uuid) {
        console.log("inreserveBook");
        $.ajax({
            type: "POST",
            url: "/reserveBook",
            data: {
                "bookUuid": uuid,
                "userUuid": ""
            },
            dataType: "text",
            success: function (response) {
                alert(response);
                show();

            },

            error: function (e) {
                alert("Oops! Something has gone wrong")
                show();
            }
        });
    }

    function generateQr(bookUuid) {
        $.ajax({
            type: "GET",
            url: "/admin/qrGenerate/",
            data: {
                uuid: bookUuid
            },
            dataType: "text",
            success: function (response) {
                console.log("<img alt='Embedded Image' src='data:image/png;base64," + response + "'/>");

                $('#image').html("<img alt='Embedded Image' src='data:image/png;base64," + response + "'/>");
            },

            error: function (e) {

                alert('Error: ' + e);
                console.log(e)

            }
        });
    }
</script>

<script id="BookTmpl" type="text/x-jsrender">
        <tr>

            <td id='title{{:uuid}}'>{{:title}}</td>
            <td id='year{{:uuid}}'>{{:year}}</td>
            <td id='title{{:uuid}}'>
            {{for authors}}
                {{:name}} {{:surname}} {{:bornYear}} <br>
            {{/for}}
            </td>
            <td id='condition{{:uuid}}'>{{:condition.condition}}</td>
            <td>{{:typeOfBook.name}}</td>
            <td>{{:section.name}}</td>
            <sec:authorize access="hasAnyRole('ADMIN', 'USER')">
    {{if condition.condition=='Available'}}
    <td><button class="btn btn-default" onclick="reserveBook('{{:uuid}}')">reserveBook</button></td>
    {{else}}
    <td>not available</td>
    {{/if}}
</sec:authorize>
            <sec:authorize access="hasRole('ADMIN')">
    <td>{{:uuid}}</td>
    <td><a href="<c:url value='/admin/editBook/{{:uuid}}'/>" ><button class="btn btn-primary">edit</button><a></td>
    <td><button onclick='generateQr("{{:uuid}}")' class="btn btn-default">generate Qr Code </button></td>
</sec:authorize>
        </tr>







</script>


<div id="searchBooks" class="modal fade" role="dialog">
    <div class="modal-dialog">

        <div class="modal-content">
            <div class="modal-header">
                <button type="buttonModal" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Search book</h4>
            </div>

            <form action="/searchBooks" method="post">
                <div class="form-inline">

                    by Author:
                    <%--<form:input path="author.name" size="100"/>--%>
                    <%--<form:input path="author.surname"/>--%>
                    <%--<form:input path="author.bornYear"/>--%>

                        <input type="text" id="authorName" class="form-control" placeholder="name">
                        <input type="text" id="authorSurname" class="form-control" placeholder="surname">
                        <input type="number" id="authorYear" class="form-control" placeholder="bornYear">
                        <input type="submit" onclick="search('author')" class="btn btn-default">by author</inputbutton>

                </div>

                <div class="form-inline">

                    by Title:
                    <%--<form:input path="book.title"/>--%>

                        <input type="text" id="title" class="form-control" placeholder="title">
                        <button onclick="search('title')" class="btn btn-default">by title</button>
                </div>


                <div class="form-inline">

                    by Year:
                    <%--<form:input path="book.year"/>--%>
                        <input type="number" id="year" class="form-control" placeholder="year">
                        <button onclick="search('year')" class="btn btn-default">by book year</button>
                </div>

                <%--<form:input path="searchbook.searchType"/>--%>
                <button onclick="search('all')" class="btn btn-default">search</button>

            </form>


            <div class="modal-footer">
                <div id="alert_placeholder"></div>
                <button type="buttonModal" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>


