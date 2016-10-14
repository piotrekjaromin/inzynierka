

<script type="text/javascript">

  $(function() {

    $('#uuidType').val('${book.typeOfBook.uuid}');
    $('#condition').val('${book.condition.condition}');
    $('#uuidSection').val('${book.section.uuid}');
  });

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

  function update() {
    var authors = [];
    getAuthors().split(';').forEach(function f(data) {
      authors.push ({
        "name" : data.split('&')[0],
        "surname" : data.split('&')[1],
        "bornYear" : data.split('&')[2]
      })

    });

    var condition={
      "condition": $("#condition").val()
    };

    var typeOfBook={
      "uuid" : $("#uuidType").val()
    };

    var section={
      "uuid" : $("#uuidSection").val()
    };

    var book ={
      "uuid" : "${book.uuid}",
      "title" : $("#title").val(),
      "year" : $("#year").val(),
      "condition" : condition,
      "authors" : authors,
      "section" : section,
      "typeOfBook" : typeOfBook
    };

    console.log(book);

    $.ajax({
      type: "POST",
      contentType : 'application/json; charset=utf-8',
      url: "/admin/editBook",
      dataType : 'text',
      data: JSON.stringify(book),
      success: function (response) {
        $(".form-inline").hide();
        if(response=="Success")

          $('#alert_placeholder').html('<div class="alert alert-success">' + response + '</div>')
        else {
          console.log('error');
          console.log(book);
          $('#alert_placeholder').html('<div class="alert alert-danger">' + response + '</div>')
        }
      },
      error: function (response) {
        console.log(error);
        console.log(book);
        $('#alert_placeholder').html('<div class="alert alert-danger">' + response + '</div>')
      }
    });

  }

  function addAuthorField() {
    var fields = "<div><input type='text' class='authorName form-control' placeholder='author name'> " +
            "<input type='text' class='authorSurname form-control' placeholder='author surname'> " +
            "<input type='number' class='authorYear form-control' placeholder='author year' > " +
            "<button class='btn btn-default' onclick=$(this).parent('div').remove()>Remove</button></div>";

    $('#authors').append(fields);
  }

  function getDataEditBook(bookUuid) {
    $.ajax({
      type: "GET",
      url: "/admin/getDataEditBook",
      data: bookUuid,
      dataType: "json",
      success: function (response) {
        console.log(response);
      },

      error: function (e) {
        alert("Oops! Something has gone wrong")
      }
  })
  }
</script>











<div id="edit" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Edit account</h4>
      </div>
      <div class="modal-body">


        <div class="form-inline">
          <div id="authors">
            <c:forEach items="${book.authors}" var="author" varStatus="outher">
            <div>
              <input type="text"  class="form-control authorName" value="${author.name}">
              <input type="text"  class="form-control authorSurname" value="${author.surname}">
              <input type="number"  class="form-control authorYear" value="${author.bornYear}">
              <c:choose>
              <c:when test="${outher.index eq 0}"><button class="btn btn-default" onclick="addAuthorField()">Add author</button></div></c:when>
            <c:otherwise><button class='btn btn-default' onclick=$(this).parent('div').remove()>Remove</button></div></c:otherwise>
          </c:choose>

          </c:forEach>
        </div>
        <input type="text" id="title" class="form-control" value="${book.title}">
        <input type="number" id="year" class="form-control" value="${book.year}">
        <select id="condition" class="form-control">
          <option value="Available">Available</option>
          <option value="Reserved">Reserved</option>
          <option value="Borrowed">Borrowed</option>
          <option value="Missing">Missing</option>
          <option value="Damaged">Damaged</option>
          <option value="Destroyed">Destroyed</option>
        </select>


        <select id="uuidType" class="form-control" >
          <option value="">type</option>
          <c:forEach items="${types}" var="type">
            <option value="${type.uuid}">${type.name}</option>
          </c:forEach>
        </select>

        <select id="uuidSection" class="form-control">
          <option value="">--section--</option>
          <c:forEach items="${sections}" var="section">
            <option value="${section.uuid}">${section.name}</option>
          </c:forEach>
        </select>
        <button onclick="update()" class="btn btn-default">Update</button>
      </div>
    </div>
  </div>



      </div>
      <div class="modal-footer">
        <div id="alert_placeholder"></div>
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>