$("#edit_status_action").click(function(){
        event.preventDefault();
        $("#status_plain").hide();
        $("#status_edit").show();
    });
     
 var nowDate = new Date();
 var today = new Date(nowDate.getFullYear(), nowDate.getMonth(), nowDate.getDate(), 0, 0, 0, 0);     
$('.datepicker').datepicker({
        format: "yyyy-mm-dd",
        autoclose: true,
        startDate: today
    });    
    
$(document).ready(function(){
    $(".time_slot").change(function(){
       var currentElementId =  $(this).attr('id');
       
       if(currentElementId === 'pickup' || currentElementId === 'pickup_time1'){
            var pick_string = $("#pickup").val()+" "+$("#pickup_time1").val();
            $("#pickup_time").val(pick_string);
       }
       if(currentElementId === 'dropoff' || currentElementId === 'dropoff_time1'){
            var pick_string = $("#dropoff").val()+" "+$("#dropoff_time1").val();
            $("#dropoff_time").val(pick_string);
       }
    });
});    