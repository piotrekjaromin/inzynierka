<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<script type="text/javascript">

    function getBookProperties() {
        $.ajax({
            type: "GET",
            url: "/admin/getBookProperties",
            dataType: 'json',
            success: function (response) {

                var sections="<option>---Add section---</option>";
                var types="<option>---Add type---</option>";

                response.sections.forEach(function f(section){
                    sections += "<option value=" + section.uuid +">" + section.name + "</option>";
                })

                response.types.forEach(function f(type){
                    types += "<option value=" + type.uuid +">" + type.name + "</option>";
                })
                $('#uuidSectionAddBook').html(sections);

                $('#uuidTypeAddBook').html(types);



            },
            error: function (response) {
                $('.alert_placeholderAddBook').html('<div class="alert alert-danger">' + response + '</div>')
            }
        });
    }

    function getAuthors() {
        var authors = ""
        for (i = 0; i < $('.authorName').length; i++) {
            authors += $('.authorName')[i].value + "&" + $('.authorSurname')[i].value + "&" + $('.authorYear')[i].value + ";";
        }
        if (authors.charAt(authors.length - 1) == ';')
            authors = authors.substring(0, authors.length - 1);
        console.log(authors);
        return authors;
    }

    function addAuthorField() {
        var fields = "<div><input type='text' class='authorName form-control' placeholder='author name'> " +
                "<input type='text' class='authorSurname form-control' placeholder='author surname'> " +
                "<input type='text' class='authorYear form-control' placeholder='author year'> " +
                "<button class='btn btn-default' onclick=$(this).parent('div').remove()>remove</button><div>";

        $('#insertAuthorField').append(fields);
    }

    function saveBook() {
        var authors = [];
        getAuthors().split(';').forEach(function f(data) {
            authors.push({
                "name": data.split('&')[0],
                "surname": data.split('&')[1],
                "bornYear": data.split('&')[2]
            })

        });

        var condition = {
            "condition": $("#conditionAddBook").val()
        };

        var typeOfBook = {
            "uuid": $("#uuidTypeAddBook").val()
        };

        var section = {
            "uuid": $("#uuidSectionAddBook").val()
        };

        var book = {
            "title": $("#titleAddBook").val(),
            "year": $("#yearAddBook").val(),
            "condition": condition,
            "authors": authors,
            "section": section,
            "typeOfBook": typeOfBook
        };


        $.ajax({
            type: "POST",
            contentType: 'application/json; charset=utf-8',
            url: "/admin/saveBook",
            dataType: 'text',
            data: JSON.stringify(book),
            success: function (response) {
                $(".form-inline").hide();
                $('.alert_placeholderAddBook').html('<div class="alert alert-success">' + response + '</div>')
            },
            error: function (response) {
                $('.alert_placeholderAddBook').html('<div class="alert alert-danger">' + response + '</div>')
            }
        });
    }

    function validateInput() {
        $('.alert_placeholder').empty();
        $("#form").show();
        for (i = 0; i < $('.notNull').length; i++) {
            if ($('.notNull')[i].value == '') {
                $('.alert_placeholderAddBook').html('<div class="alert alert-danger">Failure: Fields cannot be empty</div>')
                return;
            }
        }

        if($("#conditionAddBook").val()=="Condition" || $("#conditionAddBook").val()=="---Add type---" ||$("#uuidSectionAddBook").val()=="---Add section---"){
            $('.alert_placeholderAddBook').html('<div class="alert alert-danger">Failure: Fields cannot be empty</div>')
            return;
        }


        saveBook();
    }

    function clean(){
        $('.alert_placeholder').empty();
        $("#form").show();
    }
</script>


<div id="addBook" class="modal fade" role="dialog">
    <div class="modal-dialog">

        <div class="modal-content">
            <div class="modal-header">
                <button type="buttonModal" class="close" data-dismiss="modal" onclick="clean()">&times;</button>
                <h4 class="modal-title">Add books</h4>
            </div>
            <div class="modal-body">

                <div class="form-inline">

                    <input type="text" class="authorName form-control notNull" placeholder="author name">
                    <input type="text" class="authorSurname form-control notNull" placeholder="author surname">
                    <input type="number" class="authorYear form-control notNull" size="4" placeholder="author year">
                    <button class="btn btn-default" onclick="addAuthorField()">Add author</button>
                    <br>

                    <div id="insertAuthorField"></div>
                    <input type="text" id="titleAddBook" class="form-control notNull" placeholder="title">
                    <input type="number" id="yearAddBook" maxlength="4" class="form-control notNull" placeholder="year">
                    <select id="conditionAddBook" class="form-control notNull" required>
                        <option value="Condition">--Condition--</option>
                        <option value="Available">Available</option>
                        <option value="Reserved">Reserved</option>
                        <option value="Borrowed">Borrowed</option>
                        <option value="Missing">Missing</option>
                        <option value="Damaged">Damaged</option>
                        <option value="Destroyed">Destroyed</option>
                    </select>
                    <select id="uuidTypeAddBook" class="form-control notNull" required>

                    </select>
                    <select id="uuidSectionAddBook" class="form-control notNull" required>
                        <option value="">--section--</option>

                    </select>


                    <button onclick="validateInput()" class="btn btn-default">Save</button>

                </div>
            </div>


            <div class="modal-footer">
                <div class="alert_placeholderAddBook"></div>
                <button type="buttonModal" class="btn btn-default" data-dismiss="modal" onclick="clean()">Close</button>
            </div>
        </div>

    </div>
</div>