<div id="edit" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Edit account</h4>
      </div>
      <div class="modal-body" id="editAccountModal">
        <input type="hidden" id="uuidEditUser">
        Mail: <input type="text" class="form-control" id="mailEditUser"><br>
        Password: <input type="password" class="form-control" id="passwordEditUser"><br>
        Name: <input type="text" class="form-control" id="nameEditUser"><br>
        Surname: <input type="text" class="form-control" id="surnameEditUser"><br>
        <button class="btn btn-default" onclick = "editUser()">Edit</button>
      </div>
      <div class="modal-footer">
        <div id="alert_placeholderEditUser"></div>
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>