
<div id="votesModal" class="modal fade" role="dialog">
    <div class="modal-dialog">

        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Votes</h4>
            </div>
            <div class="modal-body">
                <div class="table-responsive" id="insertVotes">
                </div>
            </div>
            <div id="alert_placeholder"/>
        </div>
        <div class="modal-footer">
            <div id="alert_placeholderEditUser"></div>
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
    </div>
</div>


<div id="votesCommentModal" class="modal fade" role="dialog">
    <div class="modal-dialog">

        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Votes</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="currentThreatUuid">
                Number of stars: <input type="number" id="stars" class="form-control"><br/>
                Comment: <input type="text" id="comment" class="form-control" ><br/>
                <button onclick="checkData()" class="btn btn-warning btn-sm">Add Comment</button>
            </div>

            <div class="modal-footer">
                <div id="alert_addVote"></div>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<div id="replyModal" class="modal fade" role="dialog">
    <div class="modal-dialog">

        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Votes</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="currentVoteUuid">
                Comment: <input type="text" id="voteComment" class="form-control" ><br/>
                <button onclick="reply()" class="btn btn-warning btn-sm">Reply</button>
            </div>

            <div class="modal-footer">
                <div id="alert_addComment"></div>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>