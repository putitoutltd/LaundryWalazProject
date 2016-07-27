<!doctype html>
<html lang="en-US">
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
        <style>
            *{
                margin:0px;
                padding:0px;
                border:none;
                outline:none;
            }
            a{
                color:#333;
                text-decoration: none;
            }
            a:hover{
                text-decoration:underline;
            }
			body{
                font-family:Verdana, sans-serif;
                font-size:14px;
                color:#565656;
                background:#ffffff;
                margin:0px;
                padding:0px;
            }
            
        </style>

</head>

<body>
	 <table width="660" border="0" cellspacing="0" cellpadding="0" style="margin:0 auto;">
  <tr>
    <td align="left" valign="top" style="background:url(images/email/header.png) 0px 0px no-repeat;">
    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="left" valign="top">
    	<img src="images/email/laundry-walaz-logo.png" alt="" style="width:132px; margin:16px 0 -84px 16px;" >
    </td>
    <td align="left" valign="top" style="font-size:18px; color:#fff; text-align:right; padding:16px 16px 0 0;">January 1, 2017</td>
  </tr>
</table>

    </td>
  </tr>
  <tr>
    <td align="left" valign="top" style="border:10px solid #5aacd9; padding:94px 20px 20px 20px; min-height:200px;">
    	
        <!-- cotent table begins -->
        <form action="" method="GET">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="left" valign="top" style="padding:0 0 10px; text-align:center;">
    
		<?php
                                $endPoint = 'api/user/verify-token';

                                $email = filter_input(INPUT_GET, 'et');
                                $token = filter_input(INPUT_GET, 'ts');
                                $environment = filter_input(INPUT_GET, 'en');
//echo base64_decode($email);
                                if (!empty($email) && !empty($token) && !empty($environment)) {
                                    $data = array(
                                        'email' => $email,
                                        'token' => $token,
                                    );
                                    //sendRequest($endPoint, $verifyToken, 'PUT',$environment);
                                    switch ($environment) {
                                        case 'st':
                                            $host = 'http://backend-staging.laundrywalaz.com/';
                                            break;
                                        case 'pr':
                                            $host = 'http://backend.laundrywalaz.com/';
                                            break;
                                        case 'lo':
                                            $host = 'http://backend.laundrywalaz.localhost/';
                                            break;
                                        default :
                                            $host = 'http://backend.laundrywalaz.localhost/';
                                            break;
                                    }
                                    $url = $host . $endPoint;
                                    
                                    $ch = curl_init();                    // initiate curl
                                    curl_setopt($ch, CURLOPT_URL, $url);
                                    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); // return the output in string format
                                    curl_setopt($ch, CURLOPT_POST, true);  // tell curl you want to post something
                                    //if($putRequest){
                                    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PUT');
                                    //}
                                    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data)); // define what you want to post

                                    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                                        'auth-token: {sPjadfadf@4hyBASYdfsLdWJFz2juAdAOI(MkjAnRhsTVC>Wih))J9WT(kr'
                                    ));

                                    //curl_setopt($ch, CURLOPT_HEADER, true);
                                    $output = curl_exec($ch); // execute

                                    curl_close($ch); // close curl handle
                                    //echo $output;
                                    $res = json_decode($output);
                                    if (isset($res->message)) {
                                        echo '<h1 style="font-size:24px;">' . $res->message . '</h1>';
                                    }
                                } else {
                                    echo '<h1 style="color:#f00; font-size:24px;">Access Denied!</h1>';
                                }
                                ?>
    	 
    </td>
  </tr>
  
</table>
		</form>
        <!-- cotent table ends -->
        
    </td>
  </tr>
  <tr>
    <td align="left" valign="top" style="background:#5aacd9;">
    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="left" valign="top" style="font-size:15px; color:#fff; padding:16px 16px 10px 16px;">You've received this confirmation email to update you about your activities on Laundry Walaz App/website</td>
  </tr>
  <tr>
    <td align="left" valign="top" style="font-size:15px; color:#fff; padding:16px 16px 10px 16px;">&copy; 2016 Laundry Walaz. 1600 Amphitheatre Parkway, Mountain View, CA 94043 </td>
  </tr>
  <tr>
    <td align="left" valign="top" style="padding:16px 16px 10px 16px;">
    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="left" valign="top">
    	<ul style="list-style-type:none;">
        	<li style="display:inline-block; padding:20px 4px 0;">
            	<a href="http://localhost/laundrywalaz/#terms" style="font-size:15px; color:#fff;" target="_blank">F.A.Qs</a>
            </li>
            <li style="display:inline-block; padding:20px 4px 0px;">
            	<a href="http://localhost/laundrywalaz/#faqs" style="font-size:15px; color:#fff;" target="_blank">Terms &amp; Policies</a>
            </li>
        </ul>
    </td>
    <td align="left" valign="top" style="text-align:right;">
    	<ul style="list-style-type:none;">
        	<li style="display:inline-block; padding:0 4px;">
            	<a href="https://www.facebook.com/laundrywalaz/?fref=ts"><img src="images/email/facebook.png" alt="" style="width:42px;" ></a>
            </li>
            <li style="display:inline-block; padding:0 4px;">
            	<a href="https://www.instagram.com/laundrywalaz/"><img src="images/email/instagram.png" alt="" style="width:42px;" ></a>
            </li>
            <li style="display:inline-block; padding:0 4px;">
            	<a href="tel:1-042-36688830"><img src="images/email/call.png" alt="" style="width:42px;" ></a>
            </li>
        </ul>
    </td>
  </tr>
</table>

    </td>
  </tr>
</table>

    </td>
  </tr>
</table>
   
</body>
</html>
