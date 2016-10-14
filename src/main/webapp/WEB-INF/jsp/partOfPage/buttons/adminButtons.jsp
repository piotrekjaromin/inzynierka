<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authorize access="hasRole('ADMIN')">

    <div class="btn-group">
        <button type="button" class="btn btnMenu btn-primary dropdown-toggle" data-toggle="dropdown">
            Admin tools<span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a data-toggle='modal' data-target='#addBook' onclick="getBookProperties()">Add book</a></li>
            <li><a data-toggle='modal' data-target='#addSection'>Add section</a></li>
            <li><a data-toggle='modal' data-target='#addType'>Add type</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="/admin/showUsers">Show users</a></li>
            <li><a href="/admin/searchUser">Search user</a></li>
            <li role="separator" class="divider"></li>
            <li><a data-toggle='modal' data-target='#configureLibrary' onclick="getData()">Edit configuration</a></li>
            <li role="separator" class="divider"></li>
            <li><a data-toggle='modal' data-target='#sign_up'>Create admin account</a></li>

        </ul>
    </div>

    <%@include file="../modals/addSection.jsp" %>
    <%@include file="../modals/addType.jsp" %>
    <%@include file="../modals/configureLibrary.jsp" %>
    <%@include file="../modals/addBook.jsp" %>


</sec:authorize>