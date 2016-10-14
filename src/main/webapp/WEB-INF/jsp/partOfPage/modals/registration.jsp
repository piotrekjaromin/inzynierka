<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<script>
  function signUp(role) {

    if ($("#loginReg").val().length < 6) {
      $('#alert_placeholderReg').html('<div class="alert alert-danger">Failure: login is too short</div>')
      return;
    }

    if ($("#passwordReg").val().length < 6) {
      $('#alert_placeholderReg').html('<div class="alert alert-danger">Failure: password is too short</div>')
      return
    }

    var userRole = {
      "type": role
    }

    var user = {
      "login": $("#loginReg").val(),
      "password": $("#passwordReg").val(),
      "name": $("#nameReg").val(),
      "surname": $("#surnameReg").val(),
      "mail": $("#mailReg").val(),
      "userRole": userRole
    };

    $.ajax({
      type: "POST",
      contentType: 'application/json; charset=utf-8',
      url: "/registration",
      dataType: 'text',
      data: JSON.stringify(user),
      success: function (response) {
        $(".form-inline").hide();
        if (response == 'Success')
          $('#alert_placeholderReg').html('<div class="alert alert-success">' + response + '</div>')
        else
          $('#alert_placeholderReg').html('<div class="alert alert-danger">' + response + '</div>')

      },
      error: function (response) {
        $('#alert_placeholderReg').html('<div class="alert alert-danger">' + response + '</div>')
      }
    });

  }
</script>

<div id="sign_up" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <div class="modal-content">
      <div class="modal-header">
        <button type="buttonModal" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Registration</h4>
      </div>
      <div class="modal-body">

        <input type="text" id="loginReg" class="form-control" placeholder="Login">
        <input type="password" id="passwordReg" class="form-control" placeholder="Password">
        <input type="text" id="mailReg" class="form-control" placeholder="e-mail adress">
        <input type="text" id="nameReg" class="form-control" placeholder="name">
        <input type="text" id="surnameReg" class="form-control" placeholder="surname">

        <button onclick="signUp('USER')" class="btn btn-default">Sign up</button>
        <sec:authorize access="hasRole('ADMIN')">
          <button onclick="signUp('ADMIN')" class="btn btn-default">Sign up as admin</button>
        </sec:authorize>
      </div>


      <div class="modal-footer">
        <div id="alert_placeholderReg"></div>
        <button type="buttonModal" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>