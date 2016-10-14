<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



        <div class="form-inline">

            <input type="text" class="authorName form-control notNull" placeholder="author name">
            <input type="text" class="authorSurname form-control notNull" placeholder="author surname">
            <input type="number" class="authorYear form-control notNull"  maxlength="4" placeholder="author year">
            <button class="btn btn-default" onclick="addAuthorField()">Add author</button><br>
            <div id="insertAuthorField"></div>
            <input type="text" id="title" class="form-control notNull" placeholder="title" >
            <input type="number" id="year" maxlength="4" class="form-control notNull" placeholder="year">
            <select id="condition" class="form-control notNull" required>
                <option value="Condition">--Condition--</option>
                <option value="Available">Available</option>
                <option value="Reserved">Reserved</option>
                <option value="Borrowed">Borrowed</option>
                <option value="Missing">Missing</option>
                <option value="Damaged">Damaged</option>
                <option value="Destroyed">Destroyed</option>
            </select>
            <select id="uuidType" class="form-control notNull" required>
                <option value="">--type of book--</option>
                <c:forEach items="${typesOfBooks}" var="type">
                    <option value="${type.uuid}">${type.name}</option>
                </c:forEach>
            </select>
            <select id="uuidSection" class="form-control notNull" required>
                <option value="">--section--</option>
                <c:forEach items="${sections}" var="section">
                    <option value="${section.uuid}">${section.name}</option>
                </c:forEach>
            </select>

            <button onclick="validateInput()" class="btn btn-default">Save</button>

        </div>

