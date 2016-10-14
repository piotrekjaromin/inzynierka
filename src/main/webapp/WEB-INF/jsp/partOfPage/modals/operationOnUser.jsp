<div id="myModal" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Show users</h4>
      </div>
      <div class="modal-body">
        <div class="form-inline">
        <input type="text" class="form-control" id="bookUuid">
        <input type="hidden" id="userUuid">
        <button class="btn btn-default" onclick="borrow()">Borrow</button>
        <button class="btn btn-default" onclick="returnBook()">Return</button>
        <button  class="btn btn-default" onclick="reserveBook()">Reserve</button>
        <button class="btn btn-default" onclick="cancelReserveBook()">Cancel reservation</button>
          </div>
        <div class="form-inline">
          <input type="text" class="form-control" id="debtReturn">
        <button  class="btn btn-default" onclick="payDebt()">Pay debt</button><br>
          </div>
        <div class="form-inline">
          <input type="text" class="form-control" id="idNumber">
        <button class="btn btn-default" onclick="addIdNumber()">Add id number</button>
        </div>
        </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>