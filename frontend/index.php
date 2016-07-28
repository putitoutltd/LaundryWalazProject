<!doctype html>
<html lang="en-US">
    <?php 
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }
        include_once('settings.php');
        $serverUrl = FRONTEND_URL;
    ?>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>Laundry Walaz | On your door step</title>
        <link rel="icon" type="image/png" href="images/favicon.ico">
        <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
        <!--[if lt IE 9]>
        <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
        <!--[if lt IE 8]>
        <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
        <!--[if lt IE 7]>
        <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->

        <!-- [ view port meta tag ] -->
        <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=no;">

        <!-- roboto fonts -->
        <link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,200,200italic,300,300italic,400italic,600,600italic,700,700italic,900,900italic' rel='stylesheet' type='text/css'>

        <!-- bootstrap CSS -->
        <link href="css/vendors/bootstrap.min.css" rel="stylesheet" type="text/css">
        <!-- fonts CSS -->
        <link href="css/fonts.css" rel="stylesheet" type="text/css">
        <!-- layer slider -->
        <link href="css/vendors/animate.min.css" rel="stylesheet">
        <link href="css/vendors/bootstrap-layer-slider.css" rel="stylesheet">

        <link href="css/vendors/animate.css" rel="stylesheet">
        <link href="css/vendors/datepicker.css" rel="stylesheet">
        <link href="css/vendors/bootstrap-select.css" rel="stylesheet">

        <!--- checkboxes css --->
        <link href="css/vendors/checkbox.css" rel="stylesheet">


        <!-- main styles -->
        <link href="css/all.css" rel="stylesheet" type="text/css">
        
        <style>
            #processing,#order_details_block{
                display:none;
            }
            #order_details,#msg1,#msg2,#msg3{
                display:none;
            }
            #today_time_li,#tomorrow_time_li,#other_time_li{
                visibility: hidden;
            }
            .text-danger{
                color: red;
                font-size: 10pt;
            }
            #has-error{
                display: none;
                color: red;
                position: fixed;
                z-index: 1000;
                background-color: #e6e6e6;
                opacity: 0.9;
                width: 100%;
                top: 0;
                padding: 15px;
                font-size: 15pt;
                text-align: center;
                font-weight: bold;
                
            }
            #has-success{
                display: none;
                color: green;
                position: fixed;
                z-index: 1000;
                background-color: #e6e6e6;
                opacity: 0.9;
                width: 100%;
                top: 0;
                padding: 15px;
                font-size: 15pt;
                text-align: center;
                font-weight: bold;
                
            }
            #r_error{
                text-align: center;
                color: red;
            }
            #order_details_block{
                position: relative;
                z-index: 9999;
            }
            .seal-order{
                background: url(images/order-confirmation.png) 0px 0px no-repeat;
            }
            .running_order{
                padding: 10px;
                text-align: center;
                background: url(images/order-confirmation.png) 0px 0px no-repeat;
                color: #FFF;
            }
            .menu_logout{
                
            }
        </style>

    </head>
    <?php 
        //echo md5('4f5y123#$%');
        
        $hasError = FALSE; $loggedIn = FALSE;
        $loginFormSubmitted = filter_input(INPUT_POST, 'login_submit');
        if($loginFormSubmitted){
            // user login
            $endPoint4 = 'api/user/login';
            $userLogin =  array(
                'email' => filter_input(INPUT_POST, 'login_email'),
                'password' => filter_input(INPUT_POST, 'login_password')
            );
            $loginResponse = sendRequest($endPoint4, $userLogin, 'POST');
            if($loginResponse->status == 'failure'){
                $_SESSION['has_error'] = $loginResponse->message;
                
                $hasError = $_SESSION['has_error'];
                //$redirectUrl = filter_input(INPUT_SERVER, 'HTTP_REFERER').'#loginForm';
                //header('Location: '.$redirectUrl); 
            }
            else if($loginResponse->status == 'success'){
                $loggedIn = TRUE;
                $cookie_name = "_lw";
                $cookie_value = time().'something';
                setcookie($cookie_name, md5($cookie_value), time() + (86400 * 30), "/"); // 86400 = 1 day
                ?>
                    <script>
                var userData = '<?php echo json_encode($loginResponse->data); ?>';       
                // Check browser support
                if (typeof(Storage) !== "undefined") {
                    // Store
                    localStorage.setItem("_lus", userData);
                    
                } else {
                    alert("Sorry, your browser does not support Web Storage...");
                }
                </script>
                <?php
                
            }/*
            echo '<pre style="z-index: 1000;position: absolute;">';            
            print_r($loginResponse);
            //print_r($_SERVER);
            echo '</pre>';
            */
            
        }
        
        $userData = new stdClass();
        if(isset($_COOKIE['_lw'])){ 
            $loggedIn = TRUE;
        }else{
            
        }
        // date calculations
        date_default_timezone_set("Asia/Karachi");

        $format = 'Y-m-d H:i:s';
        $fullTime = date($format);
        //$fullTime = date('Y-m-d 09:15:s');

        $currentHour = date('G');
        $disableToday = ( $currentHour >= 18 ) ? TRUE : FALSE;
        $disableExpressToday = ( $currentHour >= 11 ) ? TRUE : FALSE;
        //$disableToday = TRUE;
        //$disableExpressToday = TRUE;
        $currentMinutes = date('i');
        $newHour = FALSE;
            if( ($currentHour <= 8 )  ){ 
                $fullTime = date($format, strtotime(date('Y-m-d 11:00:00')));
                $newHour = date('H:i a', strtotime(date('Y-m-d 11:00:00')));
            }
            $slots = array();
            for($i=0; $i < 11; $i++){

                if($newHour){ 
                    $slots[] = $newHour;
                }
                if($i == 0){
                    $newTime = date($format,strtotime('+2 hour',strtotime($fullTime)));
                }else{
                    $newTime = date($format,strtotime('+1 hour',strtotime($fullTime)));
                }
                $newHourPlain = date('H', strtotime($newTime));
                $newHour = date('h:i a', strtotime($newTime));
                $fullTime = $newTime;

                if($newHourPlain >= 20){ 
                    $slots[] = '08:00 pm';
                    break;
                }
            }
            // full day slots for tomorrow and other day
            $fullDaySlots = array();
            $startTime = date('Y-m-d 11:00:00');
            $newStartHour = '11:00 am';
            for($i=0; $i < 11; $i++){

                if($newStartHour){ 
                    $fullDaySlots[] = $newStartHour;
                }

                $newTime = date($format,strtotime('+1 hour',strtotime($startTime)));
                $newHourPlain = date('H', strtotime($newTime));
                $newStartHour = date('h:i a', strtotime($newTime));
                $startTime = $newTime;

                if($newHourPlain >= 20){ 
                    $fullDaySlots[] = '08:00 pm';
                    break;
                }
            }
            
            //echo '<pre>'; print_r($slots); echo '</pre>'; 
    ?>

    <body class="document-body" data-spy="scroll" data-target=".header" data-offset="175">
        
        
        <div id="has-error" style="<?php if($hasError){ echo 'display: block;';} ?>">
            <?= $hasError; ?>
            <?php unset($_SESSION['has_error']); ?>
        </div>
        <div id="has-success">
        </div>
        
        <!-- header main begins -->
        <div class="header-main" id="home">

            <!-- header begins -->
            <div class="header">
                <div class="container">
                    <div class="logo">
                        <a href="#home" class="page-scroll"><img src="images/laundry-walaz-logo.png" alt="" ></a>
                    </div>
                    <div class="navigation-holder desktop-nav">
                        <div class="navbar" role="navigation" >
                            <div class="navbar-collapse collapse">
                                <ul class="nav navigation clearfix">
                                    <li><a href="#home" class="page-scroll" id="first-link">Home</a></li>
                                    <li><a href="#how-to-order" class="page-scroll">how to order</a></li>
                                    <li><a href="#the-app" class="page-scroll">the app</a></li>
                                    <li class="why-laudrywalaz"><a href="#why-laundry-walaz" class="page-scroll">why laundry walaz</a></li>
                                    <li><a href="#pricing-table" class="page-scroll">pricing</a></li>
                                    <li><a href="#schedule" class="page-scroll">schedule a pick-up</a></li>
                                    <li><a href="#operating-areas" class="page-scroll">operating areas</a></li>
                                    <li class="menu_login" ><a href="" data-toggle="modal" data-target="#loginForm" class="page-scroll">login</a></li>
                                    <li class="menu_logout" style="display: none;" ><a onclick="logout()" href="">logout</a></li>
                                </ul>
                            </div>
                        </div>

                    </div>
                    <div class="navigation-holder mobile-nav clearfix">
                        <div class="navi-opener">
                            <a href="javascript:void(null);">
                                <img src="images/menu.svg" alt="" >
                            </a>
                        </div>
                        <div class="navbar" role="navigation">
                            <div class="mobile-navi-list">
                                <ul class="nav navigation clearfix">
                                    <li><a href="#home" class="page-scroll" id="first-link">Home</a></li>
                                    <li><a href="#how-to-order" class="page-scroll">how to order</a></li>
                                    <li><a href="#the-app" class="page-scroll">the app</a></li>
                                    <li class="why-laudrywalaz"><a href="#why-laundry-walaz" class="page-scroll">why laundry walaz</a></li>
                                    <li><a href="#pricing-table" class="page-scroll">pricing</a></li>
                                    <li><a href="#schedule" class="page-scroll">schedule a pick-up</a></li>
                                    <li><a href="#operating-areas" class="page-scroll">operating areas</a></li>
                                    <li class="menu_login" ><a href="" data-toggle="modal" data-target="#loginForm" class="page-scroll">login</a></li>
                                    <li class="menu_logout"  style="display: none;"  ><a onclick="logout()" href="">logout</a></li>
                                </ul>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
            <!-- header ends -->

            <!-- banner begins -->
            <div class="banner-holder clearfix" data-speed="5" data-type="background">
                <div class="banner-visual clearfix" data-speed="1" data-type="background">
                    <div class="banner-content">
                        <div class="start-fresh">
                            <span><img src="images/start-fresh.png" alt=""></span>
                            <span class="laundry-app"><img src="images/laundry-app.png" alt=""></span>
                        </div>
                        <div class="banner-schedule">
                            <h1>Scheduling a dry cleaning or laundry <br>takes only a minute</h1>
                            <a href="#schedule" class="page-scroll">Pick-Up</a>
                        </div>
                    </div>


                </div>
                <div class="noteBook">
                    <img src="images/notebook.png" alt="">
                </div>
                <div class="banner-flowers">
                    <img src="images/banner-flowers.png" alt="">
                </div>

            </div>
            <!-- banner ends -->


        </div>
        <!-- header main ends -->

        <!-- how to order begins -->
        <div class="how-to-order-holder" id="how-to-order" data-speed="1" data-type="background">
            <div class="container">
                <div class="order-visual">
                    <h2>Refreshingly Convenient</h2>
                    <p>Express That gets you cleaned and neatly packaged<br> clothes in as little as 6 hours</p>

                    <div class="step-boxes clearfix" data-speed="5">
                        <div class="col-md-4 col-sm-4 col-xs-12">
                            <div class="step step-one">
                                <div class="schedlue-inn">
                                    <span><img src="images/schedule-laundry-walaz.png" alt="" ></span> 
                                    <p>Schedule a <br>Pick-Up</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 col-sm-4 col-xs-12">
                            <div class="step step-two">
                                <div class="schedlue-inn">
                                    <span><img src="images/laundry-walaz-cleaner.png" alt="" ></span> 
                                    <p class="collect">Collect at <br>your doorstep</p>
                                </div>
                            </div>

                        </div>
                        <div class="col-md-4 col-sm-4 col-xs-12">
                            <div class="step step-three">
                                <div class="schedlue-inn">
                                    <span><img src="images/laundry-walaz-delivery.jpg" alt="" ></span> 
                                    <p class="delivery">Clean <br> and Deliver</p>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- how to order ends -->

        <!-- get the APP begins -->
        <div class="app-holder" id="the-app" data-speed="0" data-type="background">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <div class="try-our-app">
                            <h2>Our App is coming soon</h2>
                            <p>Clean clothes are just a tap away with Laundry Walaz.</p>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="appstore-btns">
                                    <a href="#"><img src="images/app-store.png" alt="" ></a>
                                </div>

                            </div>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="appstore-btns">
                                    <a href="#"><img src="images/goolge-play.png" alt="" ></a>
                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <div class="try-our-app-iPad" data-speed="1.5" data-type="background">
                            <img src="images/get-the-app-iPod-mobile.png" alt="" >
                        </div>
                    </div>
                </div>
            </div>
            <!--            <div class="laundry-flowers">
                            <img src="images/laundry-flowers.png" alt="" >
                        </div>-->
            <div class="laundry-pen">
                <img src="images/laudry-pen.png" alt="" >
            </div>
        </div>
        <!-- get the APP ends -->

        <!-- features slider begins -->
        <div class="slider-holder" id="why-laundry-walaz" data-speed="0" data-type="background">
            <div class="container">
                <div id="carousel-example-generic" class="carousel slide">
                    <div class="carousel-inner" role="listbox">
                        <!-- First slide -->
                        <div class="item active">
                            <div class="clearfix" data-animation="animated fadeInLeft">
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                    <div class="slider-image watch">
                                        <img src="images/laundry-on-time.png" alt="" >
                                    </div>
                                </div>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <div class="slide-content">
                                        <h2>Time Efficient</h2>
                                        <p>Laundry Walaz understands the value of time in your life. We offer you our Next Day dry cleaning and laundry service which allows you to get fresh and clean clothes at your doorstep.</p>
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix" data-animation="animated fadeInRight">
                                <div class="col-md-4 col-sm-4 col-xs-12 pull-right">
                                    <div class="slider-image apple">
                                        <img src="images/laundry-fresh-and-crisp.png" alt="" >
                                    </div>
                                </div>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <div class="slide-content right-side">
                                        <h2>Fresh &AMP; Crisp</h2>
                                        <p>Quality remains an integral part of our business. We strive to integrate strict quality measures into each and every aspect of our operations. From our state-of-the-art dry cleaning and washing equipment to our flawless systemization. </p>
                                    </div>
                                </div>
                            </div>

                        </div> 

                        <!-- Second slide -->
                        <div class="item">
                            <div class="clearfix" data-animation="animated fadeInLeft">
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <div class="slider-image staff">
                                        <img src="images/professional-staff.png" alt="" >
                                    </div>
                                </div>
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <div class="slide-content">
                                        <h2>Our Staff</h2>
                                        <p>We are a team of specialist dry cleaning and laundering professionals who are champions of garment care. </p>
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix" data-animation="animated fadeInRight">
                                <div class="col-md-6 col-sm-6 col-xs-12 pull-right">
                                    <div class="slider-image reliable-image">
                                        <img src="images/laundry-nature-friendly.png" alt="" >
                                    </div>
                                </div>
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                    <div class="slide-content right-side reliable">
                                        <h2>Reliable</h2>
                                        <p>We at Laundry Walaz care about you. We care about your clothes. Which is why, we treat each and every one of your garments as if it were one of our own.</p>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <!-- Third slide -->
                        <div class="item">
                            <div class="clearfix" data-animation="animated fadeInLeft">
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                    <div class="slider-image">
                                        <img src="images/on-your-finger-tips.png" alt="" >
                                    </div>
                                </div>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <div class="slide-content">
                                        <h2>At your fingertips </h2>
                                        <p>We are the first in the market and industry to introduce a mobile app for android and IOS. With the help of this exclusive app, clean laundry is just one tap away.</p>
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix" data-animation="animated fadeInRight">
                                <div class="col-md-4 col-sm-4 col-xs-12 pull-right">
                                    <div class="slider-image">
                                        <img src="images/be-the-change.png" alt="" >
                                    </div>
                                </div>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <div class="slide-content right-side">
                                        <h2>Convenient</h2>
                                        <p>We are a mobile and web based door-to-door dry cleaning and laundry service. With flexible 2-hour time slots, you can choose a pick-up and drop-off time and we'll handle the rest. </p>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <a class="left carousel-control left-slide" href="#carousel-example-generic"
                           role="button" data-slide="prev">
                            <img src="images/left-arrow.svg" alt="" >
                        </a>
                        <a class="right carousel-control right-slide" href="#carousel-example-generic"
                           role="button" data-slide="next">
                            <img src="images/right-arrow.svg" alt="" >
                        </a>

                    </div>

                </div>

            </div>
        </div>
        <!-- features slider ends -->

        <!-- pricing table begins -->
        <div class="pricing-holder" id="pricing-table" data-speed="1" data-type="background">
            <div class="container clearfix">
                <div class="laundry-safe-inn">
                    <span class="hanger"><img src="images/laundry-hanger.png" alt="" ></span>
                    <div class="laundry-scroll-holder">
                        <div class="laundry-scroll-inner">
                            <?php
                            // update user information
                            $endPoint1 = 'api/services/list';
                            $getServiceList = array();
                            $servicesListResponse = sendRequest($endPoint1, $getServiceList, 'GET');

                            $serviceList = array();
                            if (isset($servicesListResponse->data)) {
                                $serviceList = $servicesListResponse->data;
                            }
                            foreach ($serviceList as $serviceCategory => $items):
                                ?>
                                <div class="scoll-heading clearfix">
                                    <div class="col-md-6 col-sm-6 col-xs-6">
                                        <span><?= $serviceCategory; ?></span>
                                    </div>
                                    <div class="col-md-3 col-sm-3 col-xs-3">
                                        <span>Dry Clean</span>
                                    </div>
                                    <div class="col-md-3 col-sm-3 col-xs-3">
                                        <span>Laundry</span>
                                    </div>
                                </div>
                                <?php foreach ($items as $item): ?>
                                    <div class="scroll-data clearfix">
                                        <div class="col-md-6 col-sm-6 col-xs-6">
                                            <span><?= $item->name; ?></span>
                                        </div>
                                        <div class="col-md-3 col-sm-3 col-xs-3">
                                            <span><?= ($item->price_dryclean == 0) ? ' - ' : $item->price_dryclean; ?></span>
                                        </div>
                                        <div class="col-md-3 col-sm-3 col-xs-3">
                                            <span><?= ($item->price_laundry == 0) ? ' - ' : $item->price_laundry; ?></span>
                                        </div>
                                    </div>
                                <?php endforeach; ?>

                            <?php endforeach; ?>

                            <div class="scroll-data">
                                <h3>All prices are exclusive of any applicable taxes</h3>
                            </div>

                        </div>

                    </div>
                </div>
            </div>
        </div>
        <!-- pricing table ends -->
        <?php 
            $today = date('jS M Y');
            $todayPlain = date('Y-m-d');
            $tomorrow = date('jS M Y', strtotime('+1 day', time()));
            $tomorrowPlain = date('Y-m-d', strtotime('+1 day', time()));
        ?>

        <!-- schedule begins -->
        <div class="schedule-holder" id="schedule" data-speed="0" data-type="background">
            <div class="schedul-visual">
                <div class="schedule-inn">
                    
                    <?php if($loggedIn){ ?>
                    
                    <!-- order status begins -->
                    <div class="order-confirmation-holder clearfix" id="order_details_block">
                        <div class="">
                            <div class="seal-order">
                                <div id="">
                                    <img src="images/seal.png" alt="" >
                                    <h3><span id="o_uname"></span>, your Order is currently in progress.</h3>
                                    <h4>order id</h4>
                                    <h5>DC-000<span id="o_orderid"></span></h5>
                                    <h4>status</h4>
                                    <h5><span id="o_status"></span></h5>
                                    <h4>PICK-UP Date</h4>
                                    <h5 id="o_upickup"></h5>
                                    <h4>Delivery Date</h4>
                                    <h5 id="o_udropoff"></h5>
                                </div>    
                            </div>
                               <!--  <div class="continue-btn">
                                <a href="javascript:void(null);" class="continue">Continue</a>
                            </div> -->
                        </div>

                    </div>
                    <!-- order confirmation ends -->
                    
                    <div class="schedule-holder-inner">  
                        <ul class="nav nav-tabs row">
                            <li class="col-md-6 col-sm-6 col-xs-6 active laundry-tabs-head"><a data-toggle="tab" href="#regular">Standard </a></li>
                            <li class="col-md-6 col-sm-6 col-xs-6 laundry-tabs-head"><a data-toggle="tab" href="#express">Express</a></li>
                        </ul>
                        <div class="tab-content">

                            <div id="regular" class="tab-pane fade in active">
                                <form name="regular" action="" id="laundryRegular">
                                    <!-- regular content begins -->
                                    <div class="tabs-content clearfix">
                                        <div class="col-md-6 col-sm-6 col-xs-12">
                                            <div class="pick-up-laundry">

                                                <h3>When</h3>
                                                <h4>Pick-Up on:</h4>
                                                <ul class="clearfix delivery-boxes">
                                                    <li class="col-md-4 col-sm-4 col-xs-4">
                                                        <input type="text" id="regular_today" <?php if($disableToday){ echo ' disabled ';} ?> value="<?php if(!$disableToday){ echo $todayPlain;} ?>" class="<?php if($disableToday){ echo ' btn ';} ?>schedule-day">
                                                        <div class="info">
                                                            <span class="today">Today</span>
                                                            <span><?= $today; ?></span>
                                                        </div>
                                                    </li>
                                                    <li class="col-md-4 col-sm-4 col-xs-4">
                                                        <input type="text" id="regular_tomorrow" value="<?= $tomorrowPlain; ?>" class="schedule-day" >
                                                        <div class="info">
                                                            <span class="today">Tomorrow</span>
                                                            <span><?= $tomorrow; ?></span>
                                                        </div>
                                                    </li>
                                                    <li class="col-md-4 col-sm-4 col-xs-4">
                                                        <input  type="text" id="pickup-date"  readonly="readonly"  onchange="fillValue(this,'regular_pick')"  value="" class="schedule-day picked-date">
                                                        <div class="info date-info">
                                                            <span class="today">Other Day</span>
                                                            <span>Select Other Day</span>
                                                        </div>
                                                    </li>
                                                </ul>

                                                <ul class="clearfix timings-list">
                                                    <li class="col-md-4 col-sm-4 col-xs-4" id="today_time_li">
                                                        <select class="selectpicker" <?php if($disableToday){ echo ' disabled ';}  ?> id="today_time">
                                                            <?php foreach ($slots as $slot):  ?>
                                                            <option value="<?= $slot; ?>"><?= $slot; ?></option>
                                                            <?php endforeach;  ?>
                                                        </select>
                                                    </li>
                                                    <li class="col-md-4 col-sm-4 col-xs-4" id="tomorrow_time_li">
                                                        <select class="selectpicker"  id="tomorrow_time">
                                                            <?php foreach ($fullDaySlots as $slot):  ?>
                                                            <option value="<?= $slot; ?>"><?= $slot; ?></option>
                                                            <?php endforeach;  ?>
                                                        </select>
                                                    </li>
                                                    <li class="col-md-4 col-sm-4 col-xs-4" id="other_time_li">
                                                        <select class="selectpicker"  id="other_time">
                                                            <?php foreach ($fullDaySlots as $slot):  ?>
                                                            <option value="<?= $slot; ?>"><?= $slot; ?></option>
                                                            <?php endforeach;  ?>
                                                        </select>
                                                    </li>

                                                </ul>
                                            </div>
                                            <div class="pick-up-laundry">
                                                <h4>Deliver on:</h4>
                                                <ul class="clearfix delivery-boxes">
                                                    <li class="col-md-4 col-sm-4 col-xs-4">
                                                        <input type="text" disabled="disabled" id="regular_deliver_day" class="btn schedule-day" >
                                                        <div class="info">
                                                            <span class="today">Today</span>
                                                            <span><?= $today; ?></span>
                                                        </div>
                                                    </li>
                                                    <li class="col-md-4 col-sm-4 col-xs-4">
                                                        <input type="text"  id="regular_deliver_tomorrow" value="<?= $tomorrowPlain; ?>" class="btn schedule-day" >
                                                        <div class="info">
                                                            <span class="today">Tomorrow</span>
                                                            <span><?= $tomorrow; ?></span>
                                                        </div>
                                                    </li>
                                                    <li class="col-md-4 col-sm-4 col-xs-4">
                                                        <input  type="text" id="deliver-date"  readonly="readonly"  onchange="fillValue(this,'regular_deliver')"  value="" class="schedule-day picked-date">
                                                        <div class="info deliver-info">
                                                            <span class="today">Other Day</span>
                                                            <span>Select Other Day</span>
                                                        </div>
                                                    </li>
                                                </ul>
                                                <p>Deliveries are made from 6:00 - 9:00 pm on the chosen day</p>

                                            </div>
                                        </div>
                                        <div class="col-md-6 col-sm-6 col-xs-12">
                                            <div class="where-to-deliver">
                                                <h3>Where</h3>
                                                <h4>Pick-Up and Deliver at:</h4>
                                                <input type="text" id="regular_address"class="laundry-input" value="" placeholder="Address" maxlength="100">
                                                <div class="operating-areas-options">
                                                    <select class="selectpicker"  id="regular_location">
                                                        <option value="0">Location</option>
                                                        <option value="1">Gulberg 1 - V</option>
                                                        <option value="2">Cavalry Ground</option>
                                                        <option value="3">Cantt</option>
                                                        <option value="4">DHA Phase 5 & 6</option>
                                                    </select>

                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="continue-btn">
                                    <a href="javascript:void(null);" class="continue laundry-order">Continue</a>
                                </div>
                                    <!-- regular content ends -->
                                </form>
                            </div>

                            <div id="express" class="tab-pane fade">
                                <form name="express" action="">
                                    <!-- express content begins -->
                                    <div class="tabs-content clearfix">
                                        <div class="col-md-6 col-sm-6 col-xs-12">
                                            <div class="pick-up-laundry">

                                                <h3>When</h3>
                                                <h4>Pick-Up on:</h4>
                                                <ul class="clearfix delivery-boxes">
                                                    <li class="col-md-4 col-sm-4 col-xs-4">
                                                        <input type="text" <?php if($disableExpressToday){ echo ' disabled ';} ?> value="<?php if(!$disableExpressToday){ echo $todayPlain;} ?>" id="express_day"   class="<?php if($disableExpressToday){ echo ' btn ';} ?>schedule-day" >
                                                        <div class="info">
                                                            <span class="today">Today</span>
                                                            <span><?= $today; ?></span>
                                                        </div>
                                                    </li>
                                                    <li class="col-md-4 col-sm-4 col-xs-4">
                                                        <input type="text"  id="express_tomorrow" value="<?php echo $tomorrow; ?>"   class="btn schedule-day " >
                                                        <div class="info">
                                                            <span class="today">Tomorrow</span>
                                                            <span><?= $tomorrow; ?></span>
                                                        </div>
                                                    </li>
                                                    <li class="col-md-4 col-sm-4 col-xs-4">
                                                        <input  type="text" id="express-pickup-date" readonly="readonly"  onchange="fillValue(this,'express_pick')" class="btn schedule-day picked-date">
                                                        <div class="info express-date-info">
                                                            <span class="today">Other Day</span>
                                                            <span>Select Other Day</span>
                                                        </div>
                                                    </li>
                                                </ul>

                                                <p>For Express Service, please place your order by maximum 10 am .</p>
                                            </div>
                                            <div class="pick-up-laundry">
                                                <h4>Deliver on:</h4>
                                                <ul class="clearfix delivery-boxes">
                                                    <li class="col-md-4 col-sm-4 col-xs-4">
                                                        <input type="text" <?php if($disableExpressToday){ echo ' disabled ';} ?> value="<?php if(!$disableExpressToday){ echo $todayPlain;} ?>"  id="express_deliver_day"   class="btn schedule-day" >
                                                        <div class="info">
                                                            <span class="today">Today</span>
                                                            <span><?= $today; ?></span>
                                                        </div>
                                                    </li>
                                                    <li class="col-md-4 col-sm-4 col-xs-4">
                                                        <input type="text" disabled="disabled"  id="express_deliver_tomorrow" value=""   class="btn schedule-day " >
                                                        <div class="info">
                                                            <span class="today">Tomorrow</span>
                                                            <span><?= $tomorrow; ?></span>
                                                        </div>
                                                    </li>
                                                    <li class="col-md-4 col-sm-4 col-xs-4">
                                                        <input  type="text" disabled="disabled"  id="express-deliver-date"  readonly="readonly"  onchange="fillValue(this,'express_deliver')" class="btn schedule-day picked-date">
                                                        <div class="info express-deliver-info">
                                                            <span class="today">Other Day</span>
                                                            <span>Select Other Day</span>
                                                        </div>
                                                    </li>
                                                </ul>
                                                <p>Deliveries are made from 6:00 - 9:00 pm on the chosen day</p>

                                            </div>
                                        </div>
                                        <div class="col-md-6 col-sm-6 col-xs-12">
                                            <div class="where-to-deliver">
                                                <h3>Where</h3>
                                                <h4>Pick-Up and Deliver at:</h4>
                                                <input type="text" id="express_address" class="laundry-input" placeholder="Address" maxlength="100" >
                                                <div class="operating-areas-options">
                                                    <select class="selectpicker"  id="express_location">
                                                        <option value="0">Location</option>
                                                        <option value="1">Gulberg 1 - V</option>
                                                        <option value="2">Cavalry Ground</option>
                                                        <option value="3">Cantt</option>
                                                        <option value="4">DHA Phase 5 & 6</option>
                                                    </select>

                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="continue-btn">
                                        <a href="javascript:void(null);" class="continue laundry-order">Continue</a>
                                    </div>
                                    <!-- express content ends -->
                                </form>
                            </div>

                        </div>
                    </div>
                    
                    <!-- contact holder begins -->
                    <div class="contact-info-holder clearfix">
                        <div class="contact-info-holder-inner">
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="contact-info">
                                    <!-- h3>Existing User login here</h3>
                                    <a href="" data-toggle="modal" data-target="#loginForm">Login</a -->
                                    <div class="personal-info" id="order_contact_info">
                                        <h4>Your contact information</h4>
                                        <div class="form-row clearfix">
                                            <div class="col-md-6 col-sm-12 col-xs-12">
                                                <input type="text" id="first_name" class="contact-input" placeholder="First Name *" >
                                            </div>
                                            <div class="col-md-6 col-sm-12 col-xs-12 no-padding-right">
                                                <input type="text" id="last_name" class="contact-input" placeholder="Last Name *" >
                                            </div>
                                        </div>
                                        <div class="form-row contact-form-row">
                                            <input type="text" id="email" class="contact-input" placeholder="Email *" >
                                        </div>
                                        <div class="form-row">
                                            <input type="text" id="phone" class="contact-input" placeholder="Phone *" >
                                        </div>
                                        <!-- div class="form-row">
                                            <input tabindex="9" id="future_reference" type="checkbox" id="square-checkbox-1">
                                            <label for="square-checkbox-1">Save it for future orders</label>
                                        </div -->
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="instructions">
                                    <h5>Special instructions</h5>
                                    <textarea id="special_instructions"></textarea>
                                </div>

                            </div>
                            <div class="continue-btn">
                                <a href="javascript:void(null);" class="continue laundry-contact-info">Continue</a>
                            </div>
                        </div>

                    </div>
                    <!-- contact holder ends -->

                    <!-- order confirmation begins -->
                    <div class="order-confirmation-holder clearfix">
                        <div class="seal-inner">
                            <div class="seal-order">
                                <div id="processing">Processing...</div>
                                <div id="order_details">
                                    <img src="images/seal.png" alt="" >
                                    <h3><span id="uname">Ahmad</span>, your Order has been placed.</h3>
                                    <h4>order id</h4>
                                    <h5>DC-000<span id="orderid"></span></h5>
                                    <h4>PICK-UP Date</h4>
                                    <h5 id="upickup">Monday, 26th June. 6:00 pm</h5>
                                    <h4>Delivery Date</h4>
                                    <h5 id="udropoff">Wednesday, 28th June. 6:00 pm</h5>
                                </div>    
                            </div>
                               <!--  <div class="continue-btn">
                                <a href="javascript:void(null);" class="continue">Continue</a>
                            </div> -->
                        </div>

                    </div>
                    <!-- order confirmation ends -->
                    <?php // logged in if ends
                    }else {  ?>
                    <!-- without login block -->
                    <div class="well well-lg">
                        <h2 class="animated zoomIn">Please login below to continue with your order
                            <p>
                                <a href="" data-toggle="modal" data-target="#loginForm" class="btn btn-success">LOGIN</a>
                            </p>    
                        </h2>
                    </div>
                    <!-- without login block ends -->
                    <?php } ?>
                </div>

            </div>

        </div>
        <!-- schedule ends -->

        <!-- operating areas begins -->
        <div class="operating-areas-holder" id="operating-areas">
            <div class="container">
                <div class="areas-in">
                    <div class="location-form">
                        <h2>We are Here!</h2>
                        <p>Our network is still growing. Currently, we are operating in the major areas of Lahore and soon we would be spreading clean laundry to the entire city.</p>
                        <p>If we are not around, leave us your email address with the area and we will inform you as soon as we're there</p>
                        <div class="form-row">
                            <input type="email" id="area_email" class="laundry-input laundry-email" placeholder="Email">
                        </div>
                        <div class="form-row">
                            <input type="text" id="area_area"  class="laundry-input laundry-location" placeholder="Area">
                        </div>
                        <div class="form-row">
                            <input type="button" onclick="sendAreaMail()" class="continue" value="Continue" >
                        </div>
                        <div class="form-row" id="msg1">
                            Thank you for your feedback
                        </div>
                    </div>
                </div> 
            </div>

        </div>
        <!-- operating areas ends -->

        <!-- footer begins -->
        <div class="footer-holder">
            <div class="container">
                <div class="row">
                    <div class="col-md-3 col-sm-3 col-xs-12">
                        <div class="footer-logo">
                            <span><img src="images/laundry-walaz-logo.png" alt="" ></span>
                        </div>
                    </div>
                    <div class="col-md-5 col-sm-5 col-xs-12">
                        <div class="laundry-location-footer">
                            16-A Cantonment Board Building, <br>Abid Majeed road, Girja Chowk,<br>Lahore Cantt.<br>042 36688830-31
                        </div>

                    </div>
                    <div class="col-md-4 col-sm-4 col-xs-12">
                        <ul class="social-links">
                            <li><a href="https://www.facebook.com/laundrywalaz/?fref=ts" target="_blank"><img src="images/facebook.svg" alt="" ></a></li>
                            <li><a href="https://www.instagram.com/laundrywalaz/" target="_blank"><img src="images/instagram.svg" alt="" ></a></li>
                        </ul>
                        <div class="footer-links">
                            <ul>
                                <li><a href="" data-toggle="modal" data-target="#terms">Terms &AMP; Policies</a></li>
                                <li><span class="separate">|</span></li>
                                <li><a href="" data-toggle="modal" data-target="#faqs">FAQs</a></li> 
                                <li><span class="separate">|</span></li>
                                <li><a href="" data-toggle="modal" data-target="#feedBackForm">Feedback</a></li>
                            </ul> 
                        </div>
                        

                    </div>
                </div>
                <div class="row copyrights">
                    Copyright 2016 Laundry Walaz. All rights reserved. <span style="font-size: 9pt; text-transform:lowercase;">Site by <a target="_blank" style="color: green; font-size: 9pt;" href="http://putitout.co.uk">putitout</a></span>
                </div>
            </div>
        </div>
        <!-- footer ends -->

        <!-- login popup begins -->
        <div id="loginForm" class="modal fade" role="dialog">
            <div class="login-form-holder">
                <button type="button" class="close-modal" data-dismiss="modal"></button>
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="login-form-inner clearfix">

                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="login-key">
                                    <h1>Login</h1>
                                    <span><img src="images/login-key.png" alt="" ></span>
                                </div>
                            </div>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <form name="login_form" method="POST" action="">
                                    <div class="login-form-rows">
                                        <div class="form-row">
                                            <input type="email" class="contact-input" name="login_email"  id="login_email" placeholder="Email" >
                                        </div>
                                        <div class="form-row">
                                            <input type="password" id="login_password"  name="login_password"   class="contact-input" placeholder="Password" >
                                        </div>
                                        
                                        <div class="form-row align-center remember-margin">
                                            <input tabindex="9" name="remember_me" value="1" type="checkbox" id="square-checkbox-2">
                                            <label for="square-checkbox-2">Remember me</label>
                                        </div>
                                        <div class="form-row align-center">
                                            <input type="submit" name="login_submit" class="login-submit" value="Login" >
                                        </div>
                                        <div class="form-row align-center">
                                            <a href="#" data-toggle="modal" data-target="#forgotForm" class="forgot">Fogot password?</a>
                                            <p class="register-link">If you are not already registered. <a href="" data-toggle="modal" data-target="#registerForm">Click here to register</a></p>
                                        </div>
                                    </div>
                                </form>    
                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </div>
        <!-- login popup ends -->

        <!-- register popup begins -->
        <div id="registerForm" class="modal fade" role="dialog">
            <div class="login-form-holder">
                <button type="button" class="close-modal" data-dismiss="modal"></button>
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="login-form-inner clearfix">
                            <h1>Register with Laundry Walaz</h1> 
                            <p id="r_error"></p> 
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="login-key">

                                    <span><img src="images/register-icon.png" alt="" ></span>
                                </div>
                            </div>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <form id="r_form">
                                    <div class="personal-info">
                                        <div class="form-row clearfix">
                                            <div class="col-md-6 col-sm-12 col-xs-12">
                                                <input id="r_first_name" name="r_first_name" type="text" class="contact-input" placeholder="First Name*" >
                                            </div>
                                            <div class="col-md-6 col-sm-12 col-xs-12 no-padding-right">
                                                <input id="r_last_name"  name="r_last_name" type="text" class="contact-input" placeholder="Last Name*" >
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <input type="email"  id="r_email" name="r_email" class="contact-input" placeholder="Email*" >
                                        </div>
                                        <div class="form-row">
                                            <input type="number" id="r_phone"  name="r_phone" class="contact-input" placeholder="Phone*" >
                                        </div>
                                        <div class="form-row">
                                            <input type="password" id="r_password" name="r_password"  class="contact-input" placeholder="Password*" >
                                        </div>
                                        <div class="form-row align-center reg-btn">
                                            <input type="button" id="r_submit" onclick="registerUser()" name="r_submit" class="login-submit" value="Register" >
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </div>
        <!-- register popup ends -->

        <!-- feedback popup begins -->
        <div id="feedBackForm" class="modal fade" role="dialog">
            <div class="login-form-holder">
                <button type="button" class="close-modal" data-dismiss="modal"></button>
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="login-form-inner clearfix">

                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="login-key">
                                    <h1>Feedback</h1>
                                    <span><img src="images/register-icon.png" alt="" ></span>
                                </div>
                            </div>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="feedback">
                                    <div class="feedback-row clearfix">
                                        <p>We want to hear what you love and what you think we can do better.</p>
                                    </div>
                                    <div class="feedback-row">
                                        <div class="operating-areas-options">
                                            <select class="selectpicker" id="feedback_about">
                                                <option>Your Feedback about ?</option>
                                                <option value="Quality">Quality</option>
                                                <option value="Staff">Staff</option>
                                                <option value="Service">Service</option>
                                            </select>

                                        </div>
                                    </div>
                                    <div class="feedback-row">
                                        <textarea id="feedback_description"></textarea>
                                    </div>
                                    <div class="feedback-row">
                                        <input type="button" onclick="sendFeedback()" class="laundry-submit" value="Send" >
                                    </div>
                                    <div class="form-row" id="msg2">
                                        Thank you for your feedback
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </div>
        <!-- feedback popup ends -->

        <!-- terms popup begins -->
        <div id="terms" class="modal fade" role="dialog">
            <div class="login-form-holder">
                <button type="button" class="close-modal" data-dismiss="modal"></button>
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="login-form-inner clearfix">
                            <div class="copytext-holder">
                                <h2>Terms and Policies</h2>
                                <h3>Standards &AMP; Expectations</h3>
                                <p>These terms and conditions ("User Terms") apply to your visit to and your use of our website at www.laundrywalaz.com(the "Website"), the Service and the Application (as defined below), as well as to all information, recommendations and/or services provided to you on or through the Website, the Service and the Application.</p>
                                <p>PLEASE READ THESE TERMS OF SERVICE CAREFULLY. BY ACCESSING OR USING LAUNDRY WALAZ. APPLICATIONS OR ANY SERVICES PROVIDED BY US, YOU AGREE TO BE BOUND BY THESE TERMS OF SERVICE. IF YOUDO NOT AGREE TO ALL OF THESE TERMS AND CONDITIONS, DO NOT ACCESS OR USE LAUNDRY WALAZ. APPLICATIONS OR ANY SERVICES PROVIDED BY US.</p>

                                <h3>What services does LAUNDRY WALAZ provide?</h3>
                                <p>LAUNDRY WALAZ provides pick-up and delivery services for dry cleaning and laundry. Pick-up and delivery may be requested through our Website, the use of an application supplied by LAUNDRY WALAZ, downloaded and installed by you on your single mobile device (smartphone) (the "Application") or by simply calling us. All services provided by LAUNDRY WALAZ to you by means of your use of the Website, Application or telephone are hereafter referred to as the "Service".</p>
                                <p>By using the Website, Application or the Service, you further agree that:
You will only use the Service, Website, or download the Application for your sole, personal use and will not resell it to a third party;
                                </p>
                                <p>You will not authorize others to use your account;</p>
                                <p>You will not assign or otherwise transfer your account to any other person or legal entity;</p>

                                <p>You will not use an account that is subject to any rights of a person other than you without appropriate authorization;</p>
                                <p>You will not use the Service, Website, or Application for unlawful purposes, including but not limited to sending or storing any unlawful material or for fraudulent purposes;
You will not use the Service , Website, or Application to cause nuisance, annoyance or inconvenience;
</p>
                                <p>You will not impair the proper operation of the network;</p>
                                <p>You will not try to harm the Service , Website, or Application in any way whatsoever;</p>
                                <p>You will not copy, or distribute the Website, Application, or other LAUNDRY WALAZ Content without written permission from LAUNDRY WALAZ;</p>
                                <p>You will keep secure and confidential your account password or any identification we provide you which allows access to the Service, Website, and the Application;</p>
                                <p>You will provide us with whatever proof of identity we may reasonably request;</p>
                                <p>You will not use the Service, Website, or Application with an incompatible or unauthorized device;</p>
                                <p>You will comply with all applicable law from your home nation, the country, state and/or city in which you are present while using the Application, Website, or Service</p>
                                <p>LAUNDRY WALAZ reserves the right to immediately terminate the Service and the use of the Website or Application should you not comply with any of the above rules.</p>
                                <h3>Care for Garments</h3>
                                <p>LAUNDRY WALAZ follows the care label instructions on each Garment that is processed. If a care label instruction tag was missing, LAUNDRY WALAZ will make a best-effort judgement on the method chosen for cleaning. If user requests garment treatment, which is contradictory to that indicated on the care label instructions, LAUNDRY WALAZ will make an attempt to contact the user and advise on the potential risks associated with proceeding with the treatment. If LAUNDRY WALAZare unable to obtain the user'sapproval to proceed, LAUNDRY WALAZ shall refrain from cleaning the garment in question. If the user authorizes LAUNDRY WALAZ to proceed, the user will assume responsibility for any damage to the garments.
LAUNDRY WALAZ will not guarantee the successful removal of any stain but will make every attempt to remove stains without damage to the garment.
</p>
<h3>Item Count</h3>
                                <p>Our rider will count every item given to us for cleaning. Once the garments arrive at the facility, we will carry out a separate and thorough count of the cycle and will check to see that the count matches the receipt. If the counts do not reconcile, LAUNDRY WALAZ will inform the customer of the difference. Once issue has been solved, LAUNDRY WALAZ will proceed with cleaning the Garments. </p>
                                <h3 class='subheading'>Privacy Policy</h3>
                                <p>LAUNDRY WALAZ may collect and process the personal data of the visitors of the Website and users of the Application according to the Privacy Policy.</p>
                                <h3>Our Corporate Address</h3>
                                <p>LAUNDRY WALAZ, 16/A, CANTT BOARD BUILDING, ABID MAJEED ROAD, LAHORE CANTT.</p>
                                <h3>Loss or Damage:</h3>
                                <p>For any damage or loss, we are liable to pay up to 5 times the cost of work rendered.We strictly follow the care label for each item and wash/dry clean accordingly. However after following the care label if the garment still bleeds, shrinks and fades, the service provider shall not be held responsible.LAUNDRY WALAZ shall not be responsible for any damage that is done to Customer's Items during normal washing and drying such as buttons falling off, beads coming loose, seam coming undone, etc.</p>
                            </div>


                        </div>

                    </div>

                </div>

            </div>
        </div>
        <!-- terms popup ends -->

        <!-- faq's popup begins -->
        <div id="faqs" class="modal fade" role="dialog">
            <div class="login-form-holder">
                <button type="button" class="close-modal" data-dismiss="modal"></button>
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="login-form-inner clearfix">
                            <div class="copytext-holder">
                                <h2>Frequently Asked Questions</h2>
                                <h3 class="subheading">1. Collection &AMP; Delivery</h3>
                                <h3>How do I request a pick up?</h3>
                                <p>
                                    It's easy <br>1) Just download our app from the App Store or Google Play. Follow the on-screen instructions to schedule a pickup time within 60 seconds.
                                    <br>2) You can also place an order using our website www.laundrywalaz.com<br>
                                    <br>
3) Simply call us on 0423-6688830-1
 
                                </p>
                                <h3>How should I sort my laundry before collection?</h3>
                                <p>At laundry Walaz, we provide Laundry and Dry cleaning services. Upon pick up, our rider will have 2 bags labelled laundry and dry cleaning.  Any item that you wish to be laundered(wash+iron) needs to be placed in the laundry bag. Whereas items that are dry-clean only shall be placed in the dry clean bag. These bags remain a property of Laundry Walaz hence shall not be handed over to our valued customers. </p>
                                <h3>I missed my slot! What do I do?</h3>
                                <p>We are happy to pick up your clothing at a more convenient time. Just book your pickup again.</p>
                                <h3>What are your operating hours?</h3>
                                <p>We operate from 09:00 AM to 06:00 PM, 7 days a Week.</p>
                                <h3>What information do you require for pickup?</h3>
                                <p>You need to provide us with your Name, Mobile Number, Address and Pickup/Drop off dates and time.</p>
                                <h3>Do I have to count the items before handing over to your rider?</h3>
                                <p>Yes please! We request you to count your clothes at the time of pickup and verify it on the pickup slip. No claims for garment loss will be entertained once the order gets completed. Please double check the number of items provided.</p>
                                <h3>Why do I have to sign on the invoice?</h3>
                                <p>By signing the slip, you agree to the number of items collected and the terms and conditions.</p>
                                <h3>Do I get an order confirmation call?</h3>
                                <p>Yes, our customer services will call you and confirm the order. We shall also send you an order confirmation email. </p>
                                <h3>Do I get a call before order delivery?</h3>
                                <p>Laundry Walaz may or may not call you prior to delivery. If you want us to call you before delivering, please intimate our rider upon pickup.</p>
                                <h3>Do you entertain any special instructions?</h3>
                                <p>If you wish to provide any special instruction, it has to be provided to our rider and must be mentioned on the Pickup Slip provided to you.</p>
                                <h3>Can I provide you with my own suit cover or hanger?</h3>
                                <p>We shall not accept any items such as suit bags, hangers, detergents and etc. We have our own packing to keep your clothes safe and fresh.</p>
                                <h3>How do you address quality issues?</h3>
                                <p>Any issue with respect to Quality has to be reported to us within 24 hours of Delivery of garments. We will deal on a case-by-case basis</p>
                                <h3>Which items can be washed and which can be dry Cleaned?</h3>
                                <p>Read the care instructions on the clothing label inside the garment to be positive. A general rule of thumb is that dry cleaning is for synthetic materials and more refined items - e.g. suits, delicate dresses - and laundry is for natural materials - e.g. t-shirts, pants, socks. Don't worry, we process clothes according to the care label. </p>
                                <h3>How can I contact you?</h3>
                                <p>You can either call us on 0423-6688830-1 or by emailing us at info@laundrywalaz.com</p>
                                <h3 class="subheading">2. Payment</h3>
                                <h3>How much does it cost?</h3>
                                <p>Please see our pricing list here: <a href="#pricing-table" class="page-scroll closeterms">http://laundrywalaz.com/pricing</a></p>
                                
                                <h3>Is there a minimum order?</h3>
                                <p>There is no minimum order</p>
                                <h3>Should I tip your riders?</h3>
                                <p>It entirely depends on you  - Although we take good care of our riders. If you think he really did a great job then you could. Otherwise you can also praise him by emailing or contacting us, as we'd love to hear from you.</p>
                                <h3>Why do you process payment after the order is complete?</h3>
                                <p>We believe that no one should pay for something before the service is done.</p>
                                <h3>What payment methods are available?</h3>
                                <p>You can pay via cash or wireless debit/credit card machine that shall be with our rider.</p>
                                <h3>There's a mistake with my bill. What will you do about it?</h3>
                                <p>Sorry for not getting it right the first time. Let us know and our rider shall rectify changes upon drop off. </p>
                                <h3 class="subheading">3. Washing</h3>
                                
                                <h3>Are my clothes insured whilst in your care?</h3>
                                <p>You don't have to worry - we take good care of your clothes. Yes, they are and fall under the standard terms and conditions while being laundered. For any damage or loss, we are liable to pay up to 5 times the cost of work rendered.</p>
                                <h3>Are there things that you will not wash?</h3>
                                <p>Currently, we wash most items of clothing apart from leather items. If our laundry specialist discovers that it would not be sensible to wash a certain textile, we will contact you and agree on how to continue.</p>
                                <h3>Can you get a stain out for me?</h3>
                                <p>We can definitely try! Stains are best treated immediately, so your garment has a better chance of recovery. Turn your garment inside out and run cold water over the stain. This will greatly help the affected area, and in return make the stain easier to remove.</p>
                                <h3>How do I know that my personal items of laundry are in safe hands?</h3>
                                <p>The safety of personal items is in our hearts. Our Laundry Walaz riders understand that and are hand-selected professionals. If your personal items need to be washed a certain way, don't worry we'll ask you for any special requests when we collect them.</p>
                                <h3>How do you keep my clothes together?</h3>
                                <p>At the washing facility we use a bag system to ensure your clothes stay together along with tagging of each individual item don't worry,we won't get them mixed up.</p>
                                <h3>My clothes need to be washed in a specific way - what can you do?</h3>
                                <p>We know that your clothes are very personal items. Hence, our rider will ask you about the way your laundry should be processed at each pickup.</p>
                                <h3>What do I do if you ruin my clothes?</h3>
                                <p>In the unlikely event of this happening, please contact our customer care within 24 hours of receiving your items. We'll deal with these situations on a personal level.</p>
                                <h3>Where does the washing go?</h3>
                                <p>Your order is taken to our professional facility, which is continuously tested and monitored to ensure a high quality of service.</p>
                                
                            </div>


                        </div>

                    </div>

                </div>

            </div>
        </div>
        <!-- faq's popup ends -->

        <!-- forgot password popup begins -->
        <div id="forgotForm" class="modal fade" role="dialog">
            <div class="login-form-holder">
                <button type="button" class="close-modal" data-dismiss="modal"></button>
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="login-form-inner clearfix">
                            <h1>Forgot Login details</h1>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="login-key">
                                    <span><img src="images/register-icon.png" alt="" ></span>
                                </div>
                            </div>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="feedback">
                                    <div class="feedback-row clearfix">
                                        <p>Enter you email and we will email you instructions on how to reset your password.</p>
                                    </div>
                                    <div class="feedback-row">
                                        <input type="email" id="forgot_email" name="forgot_email" class="contact-input" placeholder="Email" >
                                    </div>
                                    <div class="feedback-row">
                                        <input type="button" onclick="sendForgotMail()" class="laundry-submit" name="forget_password" value="Send" >
                                    </div>
                                    <div class="form-row" id="msg3">
                                        We have sent you an email on how to reset your password.
                                    </div>
                                    
                                </div>
                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </div>
        <!-- forgot password popup ends -->




        <script src="js/jquery-1.11.3.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/parallax.js"></script>
        <!-- scrolling nav scripts -->
        <script src="js/jquery.easing.min.js"></script>
        <script src="js/scrolling-nav.js"></script>

        <!-- bootstrap layer slider script -->
        <script src="js/bootstrap-layer-slider.js"></script>

        <!-- trigger viewport through waypoint -->
        <script src="js/waypoints.min.js" type="text/javascript"></script>
        <script src="js/bootstrap-datepicker.js" type="text/javascript"></script>
        <script src="js/bootstrap-select.js" type="text/javascript"></script>
        <!--- checkboxes js --->
        <script src="js/icheck.js"></script>
        <script src="js/custom.js" type="text/javascript"></script>
        
        <script>
            
           
            var usr = localStorage.getItem("_lus");
            if(usr){
                // user is logged in
                $(".menu_login").hide();
                $(".menu_logout").show();
                
                // filling in user information in contact section
                var obj = JSON.parse(usr);
                
                var orderDetails = obj.order;
                console.log(orderDetails);
                if(orderDetails && orderDetails.status < 4){
                    $("#order_details_block").show();
                    $(".schedule-holder-inner").hide();
                    
                    var pDate = formatDate(orderDetails.pickup_time);
                    var dDate = formatDate(orderDetails.dropoff_time);

                    var displayPickDate = pDate;
                    var displayDropDate = dDate;
                    var oStatus = (orderGlobalStatuses[orderDetails.status]) ? orderGlobalStatuses[orderDetails.status] : '-';
                    
                    $("#o_upickup").html(displayPickDate);
                    $("#o_udropoff").html(displayDropDate);
                    $("#o_uname").html(orderDetails.first_name);
                    $("#o_orderid").html(orderDetails.id);
                    $("#o_status").html(oStatus);
                    
                }
                $("#first_name").val(obj.details.first_name);
                $("#last_name").val(obj.details.last_name);
                $("#email").val(obj.details.email);
                $("#phone").val(obj.details.phone);
                $("#order_contact_info :input").prop("readonly", true);
                
            }else{
                // user is not logged in
            }
            
            function logout(){
                
                event.preventDefault();
                createCookie("_lw","",-1);
                localStorage.removeItem("_lus");
                
                $("#has-success").html("You have logged out successfully");
                $("#has-success").show(2000);
                setTimeout(function(){ $("#has-success").hide(1000); }, 3000);
                setTimeout(function(){ window.location = "<?= $serverUrl; ?>"; }, 4000);
                
            }
            
            function sync_user() {
                var ac = localStorage.getItem("_lus");
                if(!ac){
                    return;
                }
                var obj = JSON.parse(ac);
                 var detailObj = {
                     'ac'                 : obj.access_token,
                     'action'             : 'verify_identity'
                 };
                 
                 //return;
                 // process the form
                 $.ajax({
                     type        : 'POST', // define the type of HTTP verb we want to use (POST for our form)
                     url         : 'process_order.php', // the url where we want to POST
                     data        : detailObj, // our data object
                     dataType    : 'json', // what type of data do we expect back from the server
                     encode          : true
                 })
                // using the done promise callback
                .done(function(data) {
                    
                    if(data.status === 'failure'){
                        createCookie("_lw","",-1);
                        localStorage.removeItem("_lus");

                        $("#has-success").html("You session has expired, Please login again");
                        $("#has-success").show(2000);
                        setTimeout(function(){ $("#has-success").hide(1000); }, 3000);
                        setTimeout(function(){ window.location = "<?= $serverUrl; ?>"; }, 4000);

                    }
                });
            }

            sync_user();
             
             
            function registerUser() {
                       
                var ufirstName = $("#r_first_name").val();
                var ulastName = $("#r_last_name").val();
                var uemail = $("#r_email").val();
                var uphone = $("#r_phone").val();
                var upwd = $("#r_password").val();
                
                if(ufirstName == '' || ulastName == '' || uemail == '' || uphone == '' || upwd == '' ){
                    //alert("all fields are required");
                    $("#r_error").css("color", "red");
                    $("#r_error").html("All fields are required");
                    return;
                }else{
                    $("#r_error").html(" ");
                }
                $("#r_error").css("color", "green");
                $("#r_error").html("Processing...");
                $("#r_form :input").prop("disabled", true);
                 var Obj = {
                     'email'                 : uemail,
                     'phone'                 : uphone,
                     'password'              : upwd,
                     'first_name'            : ufirstName,
                     'last_name'             : ulastName,
                     'action'                : 'create_user'
                 };

                 //console.log(orderObj);
                 // process the form
                 $.ajax({
                     type        : 'POST', // define the type of HTTP verb we want to use (POST for our form)
                     url         : 'process_order.php', // the url where we want to POST
                     data        : Obj, // our data object
                     dataType    : 'json', // what type of data do we expect back from the server
                     encode          : true
                 })
                     // using the done promise callback
                     .done(function(data) {

                         if(data.status === 'success'){
                            
                            $("#r_error").html("Verification email has been sent to your account, It will show up within 10 minutes."); 
                            setTimeout(function(){ window.location = "<?= $serverUrl; ?>"; }, 3000);
                         }
                         else if(data.status === 'failure'){
                             $("#r_form :input").prop("disabled", false);
                              $("#r_error").html(data.message);
                         }

                         // log data to the console so we can see
                         console.log(data); 
                         // here we will handle errors and validation messages
                     });
                } 
             
            $(document).ready(function () {
                $(".navi-opener").click(function () {
                    $(".mobile-navi-list").slideToggle();
                });
                $(".mobile-navi-list li a").click(function(){
                     $(".mobile-navi-list").toggle("up");
                 });
                 $('.navbar-collapse a').click(function () {
                    $(".navbar-collapse").collapse('hide');
                });
                // checkbox script
                $('input').iCheck({
                    checkboxClass: 'icheckbox_square-green',
                });
                $(".forgot").click(function () {
                    window.setTimeout(function () {
                        $('#loginForm').modal('hide');
                    }, 1000);
                });
                $(".selectpicker").change(function () {
                    if(this.id !== 'regular_location'){
                        orderPickTime = $(this).val();
                        //alert(orderPickTime);
                    }
                });

                $(".register-link a").click(function () {
                    window.setTimeout(function () {
                        $('#loginForm').modal('hide');
                    }, 1000);
                });
                $(".closeterms").click(function () {
                        $('#faqs').modal('hide');
                });
                
                // open modal from email template footer links //
                if(window.location.href.indexOf('#faqs') != -1) {
                    $('#faqs').modal('show');
                }
                 if(window.location.href.indexOf('#terms') != -1) {
                    $('#terms').modal('show');
                }
                if(window.location.href.indexOf('#loginForm') != -1) {
                    $('#loginForm').modal('show');
                }
                
                $(".laundry-order").click(function () {
                    
                    
                    //alert("continue clicked");
                    var regularAddress = $("#regular_address").val();
                    var expressAddress = $("#express_address").val();
                    var regularLocation = $("#regular_location").val();
                    var expressLocation = $("#express_location").val();
                    
                    if(!orderPickDate){
                        alert("You should choose a Pick up date");
                        event.preventDefault();
                        return;
                    }
                    if(!orderDeliverDate){
                        alert("You should choose a Delivery date");
                        event.preventDefault();
                        return;
                    }
                    if(regularAddress != '' ){ 
                        orderAddress = regularAddress;
                    }
                    else if(expressAddress != '' ){ 
                        orderAddress = expressAddress;
                    }else{ 
                        alert("Address field cannot be empty");
                        event.preventDefault();
                        return;
                    }
                    
                    
                    if(regularLocation > 0  ){
                        orderLocation = regularLocation;
                    }
                    else if(expressLocation > 0 ){
                        orderLocation = expressLocation;
                    }else{
                        alert("Location field cannot be empty");
                        event.preventDefault();
                        return;
                    }
                    
                    //validating dates
                    var formattedPickUpTime = orderPickDate+" "+orderPickTime;
                    var formattedDropOffTime = orderDeliverDate+" 19:00:00";
                    
                    var x = new Date(formattedPickUpTime);
                    var y = new Date(formattedDropOffTime);
                    
                    console.log(formattedPickUpTime);
                    
                    if(x > y){
                        alert("Pickup date cannot be greater than delivery date");
                        event.preventDefault();
                        return;
                    }
                    
                    $(".schedule-holder-inner").css("visibility", "hidden");
                    $(".contact-info-holder-inner").css("visibility", "visible");
                    
                    $('#tomorrow_time_li').css("visibility","hidden");
                        $('#today_time_li').css("visibility","hidden");
                        $('#other_time_li').css("visibility","hidden");
             
                });
                $(".laundry-contact-info").click(function () {
                    
                    var ufirstName = $("#first_name").val();
                    var ulastName = $("#last_name").val();
                    var uemail = $("#email").val();
                    var uphone = $("#phone").val();
                    var ufutureReference = $("#future_reference").checked;
                    var uspecialInstructions = $("#special_instructions").val();
                    
                    if(ufirstName == '' || ulastName == '' || uemail == '' || uphone == ''  ){
                        alert("Please fill out required fields");
                        event.preventDefault();
                        return;
                    }
                    
                    specialInstructions = uspecialInstructions;
                    firstName = ufirstName;
                    lastName = ulastName;
                    email = uemail;
                    phone = uphone;
                    futureReference = ufutureReference;
                    
                    $(".contact-info-holder-inner").css("visibility", "hidden");
                    $(".seal-inner").css("visibility", "visible");
                    
                    processOrder();
                });
                
            });
            
            function fillValue(elem, elemId){
                if(elemId == 'regular_pick'){
                    orderPickDate = elem.value;
                }
                else if(elemId == 'regular_deliver'){
                    orderDeliverDate = elem.value;
                }
                else if(elemId == 'express_pick'){
                    orderPickDate = elem.value;
                }
                else if(elemId == 'express_deliver'){
                    orderDeliverDate = elem.value;
                }
                
            }
            
            function createCookie(name,value,days) {
                if (days) {
                    var date = new Date();
                    date.setTime(date.getTime()+(days*24*60*60*1000));
                    var expires = "; expires="+date.toGMTString();
                }
                else{ var expires = ""; }
                document.cookie = name+"="+value+expires+"; path=/";
            }

                   function processOrder() {
                       
                       $("#processing").show();
                       
                       var ac = localStorage.getItem("_lus");
                        if(!ac){
                            return;
                        }
                        var obj = JSON.parse(ac);
                         
                       
                       var formattedPickUpTime = orderPickDate+" "+orderPickTime;
                       var formattedDropOffTime = orderDeliverDate+" 19:00:00";
                        var orderObj = {
                            'email'                 : email,
                            'phone'                 : phone,
                            'password'              : '',
                            'first_name'            : firstName,
                            'last_name'             : lastName,
                            'locations_id'          : orderLocation,
                            'address'               : orderAddress,
                            'ac'                    : obj.access_token,
                            'pickup_time'           : formattedPickUpTime,
                            'dropoff_time'          : formattedDropOffTime,
                            'special_instructions'  : specialInstructions,
                            'action'                : 'create_order'
                        };
                        
                        //console.log(orderObj);
                        // process the form
                        $.ajax({
                            type        : 'POST', // define the type of HTTP verb we want to use (POST for our form)
                            url         : 'process_order.php', // the url where we want to POST
                            data        : orderObj, // our data object
                            dataType    : 'json', // what type of data do we expect back from the server
                            encode          : true
                        })
                            // using the done promise callback
                            .done(function(data) {
                                
                                if(data.status === 'success'){
                                    
                                    var pDate = formatDate(orderPickDate);
                                    var dDate = formatDate(orderDeliverDate);
                                   
                                    var displayPickDate = pDate+" "+orderPickTime;
                                    var displayDropDate = dDate+" 06:00 pm - 09:00 pm";

                                    $("#uname").html(orderObj.first_name+" "+orderObj.last_name);
                                    $("#orderid").html(data.data.order_id);
                                    $("#upickup").html(displayPickDate);
                                    $("#udropoff").html(displayDropDate);
                                    
                                    $("#processing").hide();
                                    $("#order_details").show();
                                }
                                else if(data.status === 'failure'){
                                     $("#processing").html(data.message);
                                }
                                
                                // log data to the console so we can see
                                console.log(data); 
                                // here we will handle errors and validation messages
                            });
                    }
                    
                    
                    function sendForgotMail() {
                       var areaEmail = $("#forgot_email").val();
                       
                       var dataObj = {
                            'email'                 : areaEmail,
                            'action'                : 'forgot_password'
                        };
                        $("#msg3").html("Processing...");
                        $("#msg3").show();
                        // process the form
                        $.ajax({
                            type        : 'POST', // define the type of HTTP verb we want to use (POST for our form)
                            url         : 'process_order.php', // the url where we want to POST
                            data        : dataObj, // our data object
                            dataType    : 'json', // what type of data do we expect back from the server
                            encode          : true
                        })
                            // using the done promise callback
                            .done(function(data) {
                                if(data.message){
                                    
                                    $("#msg3").html(data.message);        
                                    setTimeout(function(){ $("#msg3").hide(1000); }, 4000);
                    
                                }
                                // here we will handle errors and validation messages
                            });
                    }
                    
                    function sendAreaMail() {
                       var areaEmail = $("#area_email").val();
                       var areaArea = $("#area_area").val();
                       var dataObj = {
                            'email'                 : areaEmail,
                            'area'                 : areaArea,
                            'action'                : 'area'
                        };
                        // process the form
                        $.ajax({
                            type        : 'POST', // define the type of HTTP verb we want to use (POST for our form)
                            url         : 'send_email.php', // the url where we want to POST
                            data        : dataObj, // our data object
                            //dataType    : 'json', // what type of data do we expect back from the server
                            encode          : true
                        })
                            // using the done promise callback
                            .done(function(data) {
                                if(data == '1'){
                                    $("#msg1").show();
                                }
                                else if(data.status === 'failure'){
                                    // $("#processing").html(data.message);
                                }
                                // log data to the console so we can see
                                console.log(data); 
                                // here we will handle errors and validation messages
                            });
                    }
                    
                     function sendFeedback() {
                       
                        var feedbackAbout = $("#feedback_about").val();
                        var feedbackDescription = $("#feedback_description").val();
                        var orderObj = {
                            'about'                 : feedbackAbout,
                            'feedback'                 : feedbackDescription,
                            'action'                : 'feedback'
                        };
                        
                        //console.log(orderObj);
                        // process the form
                        $.ajax({
                            type        : 'POST', // define the type of HTTP verb we want to use (POST for our form)
                            url         : 'send_email.php', // the url where we want to POST
                            data        : orderObj, // our data object
                            //dataType    : 'json', // what type of data do we expect back from the server
                            encode          : true
                        })
                            // using the done promise callback
                            .done(function(data) {
                                
                                if(data == '1'){
                                    $("#msg2").show();
                                }
                                else if(data.status === 'failure'){
                                    // $("#processing").html(data.message);
                                }
                                
                                // log data to the console so we can see
                                console.log(data); 
                                // here we will handle errors and validation messages
                            });
                    }
                    
                    function formatDate(dateString){
                        
                        var x = new Date(dateString);
                        
                        var da = x.getDate();	
                        var mo = x.getMonth() + 1;	
                        var ye = x.getFullYear();
                        
                        if(da < 10){
                            da = "0"+da;
                        }
                        if(mo < 10){
                            mo = "0"+mo;
                        }

                        return da+"-"+mo+"-"+ye;

                    }
                    
                    
        
            
        </script>
        
        <?php
        

        function sendRequest($endPoint, $data, $method = 'POST') {
            
            $host = BACKEND_URL;
            $url = $host . $endPoint;
            //  echo $url;

            $ch = curl_init();                    // initiate curl
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); // return the output in string format
            curl_setopt($ch, CURLOPT_POST, true);  // tell curl you want to post something
            //if($putRequest){
            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
            //}
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data)); // define what you want to post


            curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                'auth-token: {sPjadfadf@4hyBASYdfsLdWJFz2juAdAOI(MkjAnRhsTVC>Wih))J9WT(kr'
            ));

            //curl_setopt($ch, CURLOPT_HEADER, true);
            $output = curl_exec($ch); // execute
            curl_close($ch); // close curl handle
            //var_dump($output);
            return json_decode($output);
        }

        echo '<span style="display:none">Current time is : '.date('Y-m-d H:i:s').'</span>';
        ?>

    </body>
</html>
