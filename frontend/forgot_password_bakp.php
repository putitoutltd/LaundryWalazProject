<!doctype html>
<html lang="en-US">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <!-- [ view port meta tag ] -->
        <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=no;">
        <title>Verify your account</title>
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
        <style>
            *{
                margin:0px;
                padding:0px;
                
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
                background:#f8f8f8;
                margin:0px;
                padding:6px 40px 0;
            }
            @media only screen and (min-width: 768px) {

            }
        </style>
    </head>

    <body> <?php $tempPassword = generateRandomString(); ?>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="background:#f8f8f8; padding:6px 40px 0;">
            <tr>
                <td>
                    <div style="max-width:800px; margin:0 auto;"><img src="images/colored-top.png" alt="top_bar" ></div>
                    <form action="" method="GET">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="background:  #ffffff; margin:0 auto; padding:0px 40px 325px; max-width:800px;">
                            <tr>
                                <td align="center" valign="top" style="text-align:center; padding:20px 0 30px;">
                                    <img width="150" src="images/laundry-walaz-logo.png" alt="Laundrywalaz" >
                                </td>
                            </tr>
                            <tr>
                                <td align="center" valign="top" style="text-align:center; padding:20px 0 30px;">
                                    <label for="pw1">Password :</label><input type="password" id="pw1" name="pw1" />
                                </td>
                            </tr>
                            <tr>
                                <td align="center" valign="top" style="text-align:center; padding:20px 0 30px;">
                                    <label for="pw2">Repeat Password :</label><input type="password" id="pw2" name="pw2" />
                                </td>
                            </tr>
                             <tr>
                                <td align="center" valign="top" style="text-align:center; padding:20px 0 30px;">
                                    <input type="submit" name="pwdr" value="Save" />
                                    <?php 
                                        $email = filter_input(INPUT_GET, 'et');
                                        $token = filter_input(INPUT_GET, 'pt');
                                        $timestamp = filter_input(INPUT_GET, 'vd');
                                        $environment = filter_input(INPUT_GET, 'en');
                                    ?>
                                    <input type="hidden" name="et" value="<?= $email; ?>" />
                                    <input type="hidden" name="pt" value="<?= $token; ?>" />
                                    <input type="hidden" name="vd" value="<?= $timestamp; ?>" />
                                    <input type="hidden" name="en" value="<?= $environment; ?>" />
                                </td>
                            </tr>
                            <tr>
                                <td align="center" valign="top" style="font-size:18px; color:#69cef6; font-weight:bold; padding:50px 0 150px;">
                                    <?php

                                    if(filter_input(INPUT_GET, 'pwdr')){
                                        $endPoint = 'api/user/reset-forgot-password';

                                        $email = filter_input(INPUT_GET, 'et');
                                        $token = filter_input(INPUT_GET, 'pt');
                                        $timestamp = filter_input(INPUT_GET, 'vd');
                                        $environment = filter_input(INPUT_GET, 'en');
                                        $password = filter_input(INPUT_GET, 'pw1');
        //echo base64_decode($email);
                                        if (!empty($email) && !empty($timestamp) && !empty($token) && !empty($environment)) {
                                            $data = array(
                                                'email' => $email,
                                                'pass_token' => $token,
                                                'time_sent' => $timestamp,
                                                'new_password' => $password,
                                            );
                                            //sendRequest($endPoint, $verifyToken, 'PUT',$environment);
                                            switch ($environment) {
                                                case 'st':
                                                    $host = 'http://backend.laundrywalaz.localhost/';
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
                                            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
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
                                                echo '<h1>' . $res->message . '</h1>';
                                            }
                                        } else {
                                            echo '<h1 style="color:#f00;">Access Denied!</h1>';
                                        }
                                    }
                                    ?>
                                </td>
                            </tr>

                        </table>
                    </form>
                    <table border="0" cellspacing="0" cellpadding="0" style="margin:0 auto; padding:30px 40px 50px; text-align:center; max-width:800px;">

                        
                        <tr>
                            <td align="center" valign="top" style="line-height:24px; padding:0 0 30px; text-transform:uppercase;">
                                &copy; <?= date('Y'); ?> Laundrywalaz. All rights reserved. <span style="font-size: 9pt; text-transform:lowercase;">powered by <a target="_blank" style="color: green; font-size: 9pt;" href="http://putitout.co.uk">putitout</a></span>
                            </td>
                        </tr>

                    </table> 
                </td>
            </tr>
        </table>

        <?php
            
            function generateRandomString($length = 9) {
    
                return substr(str_shuffle("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), 0, $length);
            }
        ?>






    </body>
</html>
