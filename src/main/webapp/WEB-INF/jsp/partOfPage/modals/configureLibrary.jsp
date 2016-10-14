<script>

  function getData(){
    $.ajax({
      type: "GET",
      url: "/admin/configureLibrary",

      dataType: "json",
      success: function (response) {
        console.log(response)
        $('#days').val(response.borrowedDays)
        $('#interests').val(response.interests)
        $('#maxBorrowedBooks').val(response.maxBorrowedBooks)
        $('#maxReservedBooks').val(response.maxReservedBooks)
        $('#expirationTime').val(response.expirationSessionMinutes)

      },

      error: function (e) {
        alert("Oops! Something has gone wrong")
      }
  })}

  function edit() {

    $.ajax({
      type: "POST",
      url: "/admin/editLibraryConfiguration",
      data: {
        "days": $('#days').val(),
        "interests": $("#interests").val(),
        "maxBorrowedBooks": $("#maxBorrowedBooks").val(),
        "maxReservedBooks": $("#maxReservedBooks").val(),
        "expirationTime": $("#expirationTime").val()
      },
      dataType: "text",
      success: function (response) {
        alert(response);
      },

      error: function (e) {
        alert("Oops! Something has gone wrong")
      }
    });
  }
</script>

<div id="configureLibrary" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Configure library</h4>
      </div>
      <div class="modal-body">
        Max days: <input type="text" id="days" placeholder="days"><br>
        Interests: <input type="text" id="interests" placeholder="interests"><br>
        Max reserved books: <input type="text" id="maxReservedBooks" placeholder="max reserved books"><br>
        Max borrowed books: <input type="text" id="maxBorrowedBooks" placeholder="max borrowed books"><br>
        Expiration time: <input type="text" id="expirationTime" placeholder="expiration session time"><br>
        <button onclick = "edit()">edit</button>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>