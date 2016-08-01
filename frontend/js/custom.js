var packageType = 'regular';
var orderPickDate;
var orderPickTime;
var orderDeliverDate;
var orderAddress;
var orderLocation;
var specialInstructions;
var firstName;
var lastName;
var email;
var phone;
var futureReference;
var orderGlobalStatuses = ['Awaiting Pick Up','Going in Laundry','Cleaning Your Laundry','Clean Laundry on your way','Delivered'];

$(function () {


    /*ids
     * 
     * regular_today
     * regular_tomorrow
     * pickup-date
     * regular_deliver_day
     * regular_deliver_tomorrow
     * deliver-date
     * regular_address
     * regular_location
     * 
     * express_day
     * express_tomorrow
     * express-pickup-date
     * express_deliver_day
     * express_deliver_tomorrow
     * express-deliver-date
     * express_address
     * express_location
     * 
     * first_name
     * last_name
     * email
     * phone
     * future_reference
     * special_instructions
     */

    // reload the location on widowns resize
    if ($(window).width() <= 990) {
        $(".document-body").attr("data-offset", "95");
    } else {
        $(".document-body").attr("data-offset", "155");
    }

    var screenHeight = $(window).height();
    if ($(window).width() <= 768) {
        screenHeight = 0;
    }
    ;
    $(window).resize(function () {
        if ($(window).width() <= 990) {
            screenHeight = 0;
        }
    });
    
    
    // all screens min height on page load //
    $(".header-main").css("min-height", screenHeight + "px");
    $(".how-to-order-holder").css("min-height", screenHeight + "px");
    $(".app-holder").css("min-height", screenHeight + "px");
    $(".slider-holder").css("min-height", screenHeight + "px");
    $(".operating-areas-holder").css("min-height", screenHeight + "px");
    
    
    // banner section fixed height 
    $('.header-main').waypoint(function (direction) {
        $(this).css("min-height", screenHeight + "px");
    }, {
        offset: '100%',
    });

    // how it works fixed height 
    $('.how-to-order-holder').waypoint(function (direction) {
        $(this).css("min-height", screenHeight + "px");
    }, {
        offset: '100%',
    });

    // get the app fixed height 
    $('.app-holder').waypoint(function (direction) {
        $(this).css("min-height", screenHeight + "px");
        if (direction === "down") {

            $(".try-our-app h2").delay(2000).addClass("animated zoomIn");
            $(".try-our-app p").delay(2000).addClass("animated zoomIn");
            $(".appstore-btns").delay(2000).addClass("animated zoomIn");


        } else {
            $(".try-our-app h2").removeClass("animated zoomIn");
            $(".try-our-app p").removeClass("animated zoomIn");
            $(".appstore-btns").removeClass("animated zoomIn");
        }
    }, {
        offset: '100%',
    });
    $('.try-our-app-iPad').waypoint(function (direction) {
        $(this).css("min-height", screenHeight + "px");
        if ($(window).width() <= 768) {
            $(this).css("min-height", "inherit");
        }
    }, {
        offset: '100%',
    });

    // slider section fixed height 
    $('.slider-holder').waypoint(function (direction) {
        $(this).css("min-height", screenHeight + "px");
        $(".carousel-inner").css("height", screenHeight + "px");
        if ($(window).width() <= 768) {
            $(".carousel-inner").css("height", 1200 + "px");
        }
    }, {
        offset: '100%',
    });

    // operating areas fixed height 
    $('.operating-areas-holder').waypoint(function (direction) {
        $(this).css("min-height", screenHeight + "px");
    }, {
        offset: '100%',
    });



    // how it works fixed height 
    $('.pricing-holder').waypoint(function (direction) {
        $(this).css("min-height", screenHeight + "px");
    }, {
        offset: '100%',
    });

    $('.how-to-order-holder').waypoint(function (direction) {
        if (direction === "down") {
            $(".how-to-order-holder h2").delay(2000).addClass("animated zoomIn");
            $(".how-to-order-holder p").delay(2000).addClass("animated zoomIn");
            $(".step-one").delay(1000).fadeIn();
            $(".step-one").delay(2000).addClass("animated flipInX");

            $(".step-two").delay(1200).fadeIn();
            $(".step-two").delay(2000).addClass("animated flipInX");

            $(".step-three").delay(1400).fadeIn();
            $(".step-three").delay(2000).addClass("animated flipInX");
        } else {
            $(".how-to-order-holder h2").removeClass("animated zoomIn");
            $(".how-to-order-holder p").removeClass("animated zoomIn");
            $(".step").css("display", "none");
            $(".step").removeClass("animated flipInX");
        }
    }, {
        offset: '100%',
    });

    $(".schedlue-inn").mouseenter(function () {
        $(this).css("background", "#e2f3ff");
    });
    $(".schedlue-inn").mouseleave(function () {
        $(this).css("background", "white");
    });


    // select day //     
    $(".schedule-day").click(function () {

        var elemId = $(this).attr('id');
        var elemValue = $(this).val();

        //console.log("id: "+elemId);
        //console.log("value: "+elemValue);

        $(this).addClass("active");
        $(this).parent().siblings().find('input').removeClass('active');

        if ($("#pickup-date").hasClass("active")) {
            $(".date-info").fadeOut("fast");
        } else {
            $(".date-info").fadeIn("fast");
        }
        if ($("#deliver-date").hasClass("active")) {
            $(".deliver-info").fadeOut("fast");
        } else {
            $(".deliver-info").fadeIn("fast");
        }
        if ($("#express-deliver-date").hasClass("active")) {
            $(".express-deliver-info").fadeOut("fast");
        } else {
            $(".express-deliver-info").fadeIn("fast");
        }

        if ($("#express-pickup-date").hasClass("active")) {
            $(".express-date-info").fadeOut("fast");
        } else {
            $(".express-date-info").fadeIn("fast");
        }

        // populate elements values
        if (elemId === 'regular_today') {
            orderPickDate = elemValue;
            orderPickTime = $('#today_time').val();

            $('#regular_deliver_tomorrow').attr("disabled", false);
            $('#today_time_li').css("visibility", "visible");
            ;
            $('#tomorrow_time_li').css("visibility", "hidden");
            $('#other_time_li').css("visibility", "hidden");
            //#today_time, #tomorrow_time, #other_time
        }
        if (elemId === 'express_day') {
            orderPickDate = elemValue;
            orderDeliverDate = elemValue;
            orderPickTime = ' 11:00:00';
            //$('#today_time_li').css("visibility","visible");;
            $('#tomorrow_time_li').css("visibility", "hidden");
            $('#other_time_li').css("visibility", "hidden");
            //#today_time, #tomorrow_time, #other_time
        } else if (elemId === 'regular_tomorrow') {
            orderPickDate = elemValue;
            orderPickTime = $('#tomorrow_time').val();
            $('#regular_deliver_tomorrow').attr("disabled", "disabled");
            orderDeliverDate = '';
            $("#regular_deliver_tomorrow").removeClass("active");

            $('#tomorrow_time_li').css("visibility", "visible");
            $('#today_time_li').css("visibility", "hidden");
            $('#other_time_li').css("visibility", "hidden");
        } else if (elemId === 'express_tomorrow') {
            orderPickDate = elemValue;
            orderDeliverDate = elemValue;
            orderPickTime = ' 11:00:00';
            // $('#tomorrow_time_li').css("visibility","visible");
            $('#today_time_li').css("visibility", "hidden");
            $('#other_time_li').css("visibility", "hidden");
        } else if (elemId === 'pickup-date') {
            orderPickDate = elemValue;
            orderPickTime = $('#other_time').val();
            $('#other_time_li').css("visibility", "visible");
            $('#today_time_li').css("visibility", "hidden");
            $('#tomorrow_time_li').css("visibility", "hidden");
        } else if (elemId === 'express-pickup-date') {
            orderPickDate = elemValue;
            orderDeliverDate = elemValue;
            orderPickTime = ' 11:00:00';
            //$('#other_time_li').css("visibility","visible");
            $('#today_time_li').css("visibility", "hidden");
            $('#tomorrow_time_li').css("visibility", "hidden");
        } else if (elemId === 'regular_deliver_day' || elemId === 'express_deliver_day') {
            orderDeliverDate = elemValue;
        } else if (elemId === 'regular_deliver_tomorrow' || elemId === 'express_deliver_tomorrow') {
            orderDeliverDate = elemValue;
        } else if (elemId === 'deliver-date' || elemId === 'express-deliver-date') {
            orderDeliverDate = elemValue;
        }


    });

    // select time slot //
    $(".time-slot").click(function () {
        $(this).addClass("active");
        $(this).parent().siblings().find('input').removeClass('active');


    });
    var nowDate = new Date();
    var today = new Date(nowDate.getFullYear(), nowDate.getMonth(), nowDate.getDate() + 2, 0, 0, 0, 0);


    // date picker script //
    $('#pickup-date').datepicker({
        format: "yyyy-mm-dd",
        todayBtn:  1,
        autoclose: true,
        startDate: today
    }).on('changeDate', function (selected) {
        var minDate = new Date(selected.date.valueOf());
        var newMinDate = new Date(minDate.getFullYear(), minDate.getMonth(), minDate.getDate() + 1, 0, 0, 0, 0);
        $('#deliver-date').datepicker('setStartDate', newMinDate);
    });
   
     $('#deliver-date').datepicker({
        format: "yyyy-mm-dd",
        autoclose: true,
        startDate: today
    });/*
      .on('changeDate', function (selected) {
            var minDate = new Date(selected.date.valueOf());
            $('#pickup-date').datepicker('setEndDate', minDate);
    });*/
    
   
   
    $('#express-pickup-date').datepicker({
        format: "yyyy-mm-dd",
        autoclose: true,
        startDate: today
    });
    $('#express-deliver-date').datepicker({
        format: "yyyy-mm-dd",
        autoclose: true,
        startDate: today
    });






});



    