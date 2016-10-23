<div id="edit" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Add Comment</h4>
      </div>
      <div class="modal-body" id="editAccountModal">
        <div id="addCommentFields">
        <input type="hidden" id="uuid" value="${threat.uuid}"/>
        Number of stars: <input type="number" id="stars" class="form-control"><br/>
        Comment: <input type="text" id="comment" class="form-control" ><br/>
        <button onclick="checkData()" class="btn btn-default">Add Comment</button>
        </div>
          <div id="alert_placeholder"/>
      </div>
      <div class="modal-footer">
        <div id="alert_placeholderEditUser"></div>
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>