<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="log_in" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <div class="modal-content">
      <div class="modal-header">
        <button type="buttonModal" class="close" data-dismiss="modal"
                onclick="window.location.href = '/'">&times;</button>
        <h4 class="modal-title">Log in</h4>
      </div>

      <c:url var="loginUrl" value="/login"/>
      <form action="${loginUrl}" method="post" class="form-horizontal">

        <div class="modal-body">

          <%--<div class="col-xs-3">--%>
          <input type="text" class="form-control" id="username" name="login" placeholder="Enter Username"
                 required>

          <input type="password" class="form-control" id="password" name="password"
                 placeholder="Enter Password"
                 required>
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

          <div class="form-actions">
            <input type="submit" class="btn btn-default" value="Log in">
          </div>
          <%--</div>--%>
          <c:if test="${not empty SPRING_SECURITY_LAST_EXCEPTION}">
            <font color="red">
              Your login attempt was not successful due to <br/><br/>
              <c:out value="${SPRING_SECURITY_LAST_EXCEPTION.message}"/>.
            </font>
          </c:if>
        </div>
      </form>

      <div class="modal-footer">
        <button type="buttonModal" class="btn btn-default" data-dismiss="modal"
                onclick="window.location.href = '/'">Close
        </button>
      </div>
    </div>

  </div>
</div>