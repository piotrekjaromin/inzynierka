
<form action="/TrafficThreat/registration" method="post" class="form-horizontal">
<input type="text" id="loginReg" class="form-control" placeholder="Login">
<input type="password" id="passwordReg" class="form-control" placeholder="Password">
<input type="password" id="mailReg" class="form-control" placeholder="Mail">
<input type="password" id="nameReg" class="form-control" placeholder="Name">
<input type="password" id="surnameReg" class="form-control" placeholder="Surname">
<input type="submit">
<button onclick="signUp('USER')" class="btn btn-default">Sign up</button>
<sec:authorize access="hasRole('ADMIN')">
    <button onclick="signUp('ADMIN')" class="btn btn-default">Sign up as admin</button>
</sec:authorize>
    </form>