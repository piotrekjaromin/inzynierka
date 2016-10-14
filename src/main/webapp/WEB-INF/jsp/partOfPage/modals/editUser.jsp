<div id="edit" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Edit account</h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="loginEditUser">
        Password: <input type="password" id="passwordEditUser" placeholder="password"><br>
        Mail: <input type="text" id="mailEditUser" placeholder="mail"><br>
        Name: <input type="text" id="nameEditUser" placeholder="name"><br>
        Surname: <input type="text" id="surnameEditUser" placeholder="surname"><br>
        <button onclick = "editUser()">edit</button>
      </div>
      <div class="modal-footer">
        <div id="alert_placeholderEditUser"></div>
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>