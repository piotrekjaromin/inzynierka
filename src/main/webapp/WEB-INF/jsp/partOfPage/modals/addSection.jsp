<script>
    function addSection() {
        $('.clean').empty();
        $("#form").show();
        $.ajax({
            type: "POST",
            url: "/admin/addSection",
            data: {
                "section" : $('#sectionAddSection').val()
            },
            dataType: "text",
            success: function (response) {

                if(response =="success") {
                    $("#form").hide();
                    $('.alert_placeholderAddSection').html('<div class="alert alert-success">' + response + '</div>');
                }else
                    $('.alert_placeholderAddSection').html('<div class="alert alert-danger">' + response +'</div>');

            },

            error: function (e) {
                alert("Error")

            }
        });
    }

    function clean(){
        $('.alert_placeholderAddSection').empty();
        $("#form").show();
    }
</script>


<div id="addSection" class="modal fade" role="dialog">
    <div class="modal-dialog">

        <div class="modal-content">
            <div class="modal-header">
                <button type="buttonModal" class="close" data-dismiss="modal" onclick="clean()">&times;</button>
                <h4 class="modal-title">Add section</h4>
            </div>
            <div class="modal-body">

                <div id="form" class="'form-group" style="display: inline">
                    <div class="panel-body">

                        <input type="text" id="sectionAddSection" class="form-control" placeholder="section">
                        <button onclick="addSection()" class="btn btn-default">Add section</button>

                    </div>

                </div>

                <div class="alert_placeholderAddSection"></div>
            </div>

            <div class="modal-footer">

                <button type="buttonModal" class="btn btn-default" data-dismiss="modal" onclick="clean()">Close</button>
            </div>
        </div>

    </div>
</div>