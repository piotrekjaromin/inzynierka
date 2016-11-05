<div id="addType" class="modal fade" role="dialog">
    <div class="modal-dialog">

        <div class="modal-content">
            <div class="modal-header">
                <button type="buttonModal" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Add type</h4>
            </div>
            <div class="modal-body" id="modalToHide">

                <div id="form" class="'form-group" style="display: inline">
                    <div class="panel-body">
                        <input type="hidden" name="parentUuid" id="parentUuid"/>
                        <input type="text" id="typeAddType" class="form-control" placeholder="type">
                        <button onclick="addThreatType()" class="btn btn-default">Add Threat Subtype</button>

                    </div>

                </div>
            </div>


            <div class="modal-footer">
                <div id="alert_placeholderAddType"></div>
                <button type="buttonModal" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>

    </div>
</div>