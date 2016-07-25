<?php


/**
 * Contains all Email templates allowed from system
 * 
 * @author Muhammad Rashid <rashid.akram@putitout.co.uk>
 * @copyright (c) 2015, Putitout Solutions
 */
class EmailTemplates
{

    public static $fromAddr = 'service@laundrywalaz.com';
    public static $fromName = 'Laundrywalaz';
    public function __construct()
    {
        
    }
    
    public static function sendInvite($receiver, $emailVars){
        
        $invitedAs = (isset($emailVars['invited_as'])) ? $emailVars['invited_as'] : 'Guest';
        $sender = (isset($emailVars['sender'])) ? $emailVars['sender'] : ' Anonymus';
        $senderName = (isset($emailVars['sender_name'])) ? $emailVars['sender_name'] : ' Anonymus';
        $receiverName = (isset($emailVars['receiver_name'])) ? $emailVars['receiver_name'] : ' User';
        
        $subject = $senderName.' wants to connect with you';
        //$body = "Welcome to Kidlr <br /> You have been invited as [$invitedAs] to kidlr by $sender";
        $body = '<!doctype html>
<html lang="en-US">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <!-- [ view port meta tag ] -->
        <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=no;">
        <title>Invite friends and family</title>
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
            * {
                margin: 0px;
                padding: 0px;
                border: none;
                outline: none;
            }
            a {
                color: #333;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
            body {
                font-family: Verdana, sans-serif;
                font-size: 14px;
                color: #565656;
                background: #f8f8f8;
                margin: 0px;
                padding: 6px 40px 0;
            }
            table.Bs{
                border-collapse:separate !important;
            }

            @media only screen and (min-width: 768px) {
            }
        </style>
    </head>

    <body>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="background:#f8f8f8; padding:6px 40px 0; border-collapse:separate !important;">
            <tr>
                <td align="left" valign="top">
                    <div style="max-width:800px; margin:0 auto;"><img src="http://kidlr.co/images/email/kiddlr-top.png" alt="" ></div>
                </td>
            </tr>
            <tr>
                <td align="left" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="background:url(http://kidlr.co/images/email/kiddlr.png) 0px bottom no-repeat #ffffff; margin:0 auto; padding:0px 40px 325px; max-width:800px; min-height:650px; border-collapse:separate !important;">
                        <tr>
                            <td align="center" valign="top" style="text-align:center; padding:20px 0 30px;"><img src="http://kidlr.co/images/email/kidlr-logo.png" alt="" ></td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="font-size:22px; color:#69cef6; font-weight:bold; padding:0 0 27px;"> Dear '.$receiverName.', </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="line-height:24px; padding:0 0 30px;"> '.$senderName.' wants to connect with you as '.$invitedAs.' on Kidlr network. </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="line-height:24px; padding:0 0 30px;"> You may proceed with request by downloading the Kidlr App. </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="line-height:24px; padding:0 0 30px;">
                                <a href="https://itunes.apple.com/pk/app/kidlr/id1087274305?mt=8" target="_blank">
                                    <img src="http://kidlr.co/images/available-on-the-app-store.jpg" alt="" style="width:180px; padding:20px 0 0;" >
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top"><span style="font-weight:bold; color:#000; display: block; padding-bottom:20px;">Thank You</span> <span style="font-normal; color:#000; display: block; padding-bottom:5px;">Regards</span> <span style="font-weight:bold; color:#8ac53f;">Kidlr Team</span></td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="line-height:24px; padding:0 0 30px;"> NOTE: Please DO NOT reply to this email. </td>
                        </tr>
                        
                    </table></td>
            </tr>
            <tr>
                <td align="left" valign="top">
                    <table border="0" cellspacing="0" cellpadding="0" style="max-width:400px; margin:0 auto; padding:30px 0 0; border-collapse:separate !important;">
                        <tr>
                            <td align="center" valign="top" style="padding:0 15px;" width="33%"><a href="http://kidlr.co/about.html" target="_blank" style="color:#8ac53f;">About</a></td>
                            <td align="center" valign="top" style="padding:0 15px;" width="33%"><a href="http://kidlr.co/faqs.html" target="_blank" style="color:#69cef6;">FAQs</a></td>
                            <td align="center" valign="top" style="padding:0 15px;" width="33%"><a href="http://kidlr.co/privacy.html" target="_blank" style="color:#922683;">Privacy</a></td>
                        </tr>
                        <tr>
                            <td align="center" valign="top" colspan="3" style="line-height:24px; padding:20px 0 30px; text-align:center; text-transform:uppercase;">&copy; 2016 Kidlr. All rights reserved.</td>
                        </tr>
                    </table></td>
            </tr>
        </table>
    </body>
</html>';
        return Utility::sendEmail(self::$fromAddr,  self::$fromName , $receiver,$subject , $body);
        
    }
    public static function userVerification($receiver,$verificationCode,$receiverName){
        
        $frontEndUrl = Utility::frontend_url();
        $verificationUrl = $frontEndUrl.'verify.php?et='.  base64_encode($receiver).'&ts='.base64_encode($verificationCode).'&te='.rand().time().'&en=pr';
        $subject = "Verify your email for Laundrywalaz";
        /*
        $body = 'You have been recently registered with Kidlr. We welcome you to our exciting network however '
                . 'you need to verify your email in order to enjoy our great features. Please use below link to '
                . 'verify your email address. Please keep in mind that this code is valid for one day only.'
                . '<br /><br /><b><a href=" '.$verificationUrl.'">Please click here to verify yourself </a></b><br /><br />'
                . 'Thank you,<br />Kidlr Team';
        */
        $body = '<!doctype html>
<html lang="en-US">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <!-- [ view port meta tag ] -->
        <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=no;">
        <title>Verify your email for Kidlr</title>
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
            * {
                margin: 0px;
                padding: 0px;
                border: none;
                outline: none;
            }
            a {
                color: #333;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
            body {
                font-family: Verdana, sans-serif;
                font-size: 14px;
                color: #565656;
                background: #f8f8f8;
                margin: 0px;
                padding: 6px 40px 0;
            }
            table.Bs{
                border-collapse:separate !important;
            }

            @media only screen and (min-width: 768px) {
            }
        </style>
    </head>

    <body>
        <div><span style="font-size:12.8px">Hi '.$receiverName.',</span><br style="font-size:12.8px"><br style="font-size:12.8px"><span style="font-size:12.8px">Congratulations! Your Laundry Walaz account has been created and clean clothes are just around the corner! &nbsp;</span><br style="font-size:12.8px"><br style="font-size:12.8px"><span style="font-size:12.8px">Your Laundry Walaz account will allow you to schedule pickups, save your address, add special care instructions, and much more.</span></div>

<div><span style="font-size:12.8px"><br></span></div>

<div><span style="font-size:12.8px">So whenever you are ready, click&nbsp;</span><b style="font-size:12.8px">PLACE ORDER</b><span style="font-size:12.8px">, and one of our riders will be on their way to take care of your laundry!</span><br style="font-size:12.8px"><br>Please click on the following link to verify your email address and details.</div>

<div><br></div>

<div><a href="'.$verificationUrl.'">'.$verificationUrl.'</a></div>
<div><br></div>

<div><br style="font-size:12.8px"><span style="font-size:12.8px">Need help? Our customer service team are available on the number below.</span><br><span style="font-size:12.8px">Thanks!</span></div>

<div><br style="font-size:12.8px"><span style="font-size:12.8px">Laundry Walaz Team</span><br style="font-size:12.8px"><span style="font-size:12.8px">0423-6688830-1</span><br style="font-size:12.8px"><u><a href="http://www.laundrywalaz.com" target="_blank" data-saferedirecturl="https://www.google.com/url?hl=en-GB&amp;q=http://www.laundrywalaz.com&amp;source=gmail&amp;ust=1469256256626000&amp;usg=AFQjCNEDdf063qDZgJ-ZKNOSRL7B5DG4rA">www.laundrywalaz.com</a></u></div>
    </body>
</html>';
        return Utility::sendEmail(self::$fromAddr,  self::$fromName , $receiver,$subject , $body);
        
        
    }
    
    public static function userVaccination($receiver,$params){
        
        $subject = "Schedule details forwarded to Sehat";
        /*$body = 'Hi, Please follow the details below to complete vaccination schedule'
                . '<br /><br /><b><a href="https://www.sehat.com/">Sehat.com</a></b><br /><br />'
                . 'Thank you,<br />Kidlr Team';
        */
        $email = $params['email'];
        $phone = $params['phone'];
        $vaccination = $params['vaccination'];
        $referralId = $params['referral_id'];
        $userName = $params['user_name'];
        $childName = $params['child_name'].' ';
        
        $body = '<!doctype html>
<html lang="en-US">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <!-- [ view port meta tag ] -->
        <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=no;">
        <title>Vaccination Schedule</title>
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
            * {
                margin: 0px;
                padding: 0px;
                border: none;
                outline: none;
            }
            a {
                color: #333;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
            body {
                font-family: Verdana, sans-serif;
                font-size: 14px;
                color: #565656;
                background: #f8f8f8;
                margin: 0px;
                padding: 6px 40px 0;
            }
            table.Bs{
                border-collapse:separate !important;
            }

            @media only screen and (min-width: 768px) {
            }
        </style>
    </head>

    <body>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="background:#f8f8f8; padding:6px 40px 0; border-collapse:separate !important;">
            <tr>
                <td align="left" valign="top"><div style="max-width:800px; margin:0 auto;"><img src="http://kidlr.co/images/email/kiddlr-top.png" alt="" ></div></td>
            </tr>
            <tr>
                <td align="left" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="background:url(http://kidlr.co/images/email/kiddlr.png) 0px bottom no-repeat #ffffff; margin:0 auto; padding:0px 40px 325px; max-width:800px; min-height:650px; border-collapse:separate !important;">
                        <tr>
                            <td align="center" valign="top" style="text-align:center; padding:20px 0 30px;"><img src="http://kidlr.co/images/email/kidlr-logo.png" alt="" ></td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="font-size:22px; color:#69cef6; font-weight:bold; padding:0 0 27px;"> Dear '.$userName.', </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="line-height:24px; padding:0 0 30px;"> Your schedule for ['.$vaccination.'] for your kid <b>'.$childName.'</b>has been forwarded to our vaccine partner Sehat. You have provided following information; </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="line-height:24px; padding:0 0 30px;"><span style="font-weight:bold; color:#000;">Email:</span> <span style="font-weight:bold; color:#8ac53f;">'.$email.'</span> <br>
                                <span style="font-weight:bold; color:#000;">Contact Number:</span> <span style="font-weight:bold; color:#f68e1f;">'.$phone.'</span></td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="line-height:24px; padding:0 0 20px;"> Sehat will contact you on above mentioned information to proceed further. Your reference ID is '.$referralId.' </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="line-height:24px; padding:0 0 30px;">
                                Disclaimer: Kidlr is not responsible for further discussion between You and Sehat.
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top"><span style="font-weight:bold; color:#000; display: block; padding-bottom:20px;">Thank You</span> <span style="font-normal; color:#000; display: block; padding-bottom:5px;">Regards</span> <span style="font-weight:bold; color:#8ac53f;">Kidlr Team</span></td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="line-height:24px; padding:0 0 20px;"> NOTE: Please DO NOT reply to this email. </td>
                        </tr>
                    </table></td>
            </tr>
            <tr>

                <td align="left" valign="top">

                    <table border="0" cellspacing="0" cellpadding="0" style="max-width:400px; margin:0 auto; padding:30px 0 50px; border-collapse:separate !important;">
                        <tr>
                            <td align="center" valign="top" style="padding:0 15px;" width="33%"><a href="http://kidlr.co/about.html" target="_blank" style="color:#8ac53f;">About</a></td>
                            <td align="center" valign="top" style="padding:0 15px;" width="33%"><a href="http://kidlr.co/faqs.html" target="_blank" style="color:#69cef6;">FAQs</a></td>
                            <td align="center" valign="top" style="padding:0 15px;"><a href="http://kidlr.co/privacy.html" target="_blank" style="color:#922683;">Privacy</a></td>
                        </tr>
                        <tr>
                            <td align="center" valign="top" colspan="3" style="line-height:24px; padding:20px 0 30px; text-align:center; text-transform:uppercase;" colspan="3">&copy; 2016 Kidlr. All rights reserved.
                            </td>

                        </tr>

                    </table>
                </td>

            </tr>

        </table>
    </body>
</html>';
        
        Utility::sendEmail(self::$fromAddr,  self::$fromName , VACCINATION_PUTITOUT_EMAIL,$subject.' - COPY' , $body); //email to putitout
        Utility::sendEmail(self::$fromAddr,  self::$fromName , VACCINATION_VENDOR_EMAIL,$subject , $body); //email to vendor
        return Utility::sendEmail(self::$fromAddr,  self::$fromName , $receiver,$subject , $body); // email to user
        
        
    }
    
    public static function userRegisteration($receiver,$name = 'User'){
        
        $subject = 'Welcome to Laundrywalaz';
        //$body = "Welcome to Kidlr <br /> We wish you to have a great experience with us.";
        $body = '<!doctype html>
<html lang="en-US">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <!-- [ view port meta tag ] -->
        <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=no;">
        <title>Welcome to Kiddlr</title>
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
            * {
                margin: 0px;
                padding: 0px;
                border: none;
                outline: none;
            }
            a {
                color: #333;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
            body {
                font-family: Verdana, sans-serif;
                font-size: 14px;
                color: #565656;
                background: #f8f8f8;
                margin: 0px;
                padding: 6px 40px 0;
            }
            table.Bs{
                border-collapse:separate !important;
            }

            @media only screen and (min-width: 768px) {
            }
        </style>
    </head>

    <body>
        <div><span style="font-size:12.8px">Hi '.$name.',</span><br style="font-size:12.8px"><br style="font-size:12.8px"><span style="font-size:12.8px">Congratulations! Your Laundry Walaz account has been verified and clean clothes are just around the corner! &nbsp;</span>
<div><br></div>

<div><br style="font-size:12.8px"><span style="font-size:12.8px">Need help? Our customer service team are available on the number below.</span><br><span style="font-size:12.8px">Thanks!</span></div>

<div><br style="font-size:12.8px"><span style="font-size:12.8px">Laundry Walaz Team</span><br style="font-size:12.8px"><span style="font-size:12.8px">0423-6688830-1</span><br style="font-size:12.8px"><u><a href="http://www.laundrywalaz.com" target="_blank" data-saferedirecturl="https://www.google.com/url?hl=en-GB&amp;q=http://www.laundrywalaz.com&amp;source=gmail&amp;ust=1469256256626000&amp;usg=AFQjCNEDdf063qDZgJ-ZKNOSRL7B5DG4rA">www.laundrywalaz.com</a></u></div>
    
    </body>
</html>
';
        return Utility::sendEmail(self::$fromAddr,  self::$fromName , $receiver,$subject , $body);
        
    }
    
    public static function forgetPassword($receiver,$passwordToken, $userName){
        
        $frontEndUrl = Utility::frontend_url();
        $passwordResetUrl = $frontEndUrl.'forgot_password.php?et='.  base64_encode($receiver).'&pt='.$passwordToken.'&vd='.time().'&te='.rand().time().'&en=pr';
        
        $subject = 'Forgot password requested '.$userName.' at Laundrywalaz';
        
        $body = '<!doctype html>
<html lang="en-US">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <!-- [ view port meta tag ] -->
        <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=no;">
        <title>Welcome to Kiddlr</title>
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
            * {
                margin: 0px;
                padding: 0px;
                border: none;
                outline: none;
            }
            a {
                color: #333;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
            body {
                font-family: Verdana, sans-serif;
                font-size: 14px;
                color: #565656;
                background: #f8f8f8;
                margin: 0px;
                padding: 6px 40px 0;
            }
            table.Bs{
                border-collapse:separate !important;
            }

            @media only screen and (min-width: 768px) {
            }
        </style>
    </head>

    <body>
        <div><span style="font-size:12.8px">Hi '.$userName.',</span><br style="font-size:12.8px"><br style="font-size:12.8px"><span style="font-size:12.8px">You have requested for a forgot password. Please click on the following link to proceed on resetting your new password.</span>
<div><br></div>
<div><a href="'.$passwordResetUrl.'" target="_blank"></a>'.$passwordResetUrl.'</div>
<br style="font-size:12.8px"><span style="font-size:12.8px">Please note that this link is valid for one hour only.</span>
<div><br style="font-size:12.8px"><span style="font-size:12.8px">Need help? Our customer service team are available on the number below.</span><br><span style="font-size:12.8px">Thanks!</span></div>

<div><br style="font-size:12.8px"><span style="font-size:12.8px">Laundry Walaz Team</span><br style="font-size:12.8px"><span style="font-size:12.8px">0423-6688830-1</span><br style="font-size:12.8px"><u><a href="http://www.laundrywalaz.com" target="_blank" data-saferedirecturl="https://www.google.com/url?hl=en-GB&amp;q=http://www.laundrywalaz.com&amp;source=gmail&amp;ust=1469256256626000&amp;usg=AFQjCNEDdf063qDZgJ-ZKNOSRL7B5DG4rA">www.laundrywalaz.com</a></u></div>
    
    </body>
</html>';
        return Utility::sendEmail(self::$fromAddr,  self::$fromName , $receiver,$subject , $body);
        
    }
    
    public static function resetPassword($receiver,$name){
        
        $subject = 'Password has been reset for '.$name.' at Kidlr';
        //$body = 'Your Password has been changed successfully';
        $body = '<!doctype html>
<html lang="en-US">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <!-- [ view port meta tag ] -->
        <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=no;">
        <title>Confirmation email after password reset</title>
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
            * {
                margin: 0px;
                padding: 0px;
                border: none;
                outline: none;
            }
            a {
                color: #333;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
            body {
                font-family: Verdana, sans-serif;
                font-size: 14px;
                color: #565656;
                background: #f8f8f8;
                margin: 0px;
                padding: 6px 40px 0;
            }
            table.Bs{
                border-collapse:separate !important;
            }

            @media only screen and (min-width: 768px) {
            }
        </style>
    </head>

    <body>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="background:#f8f8f8; padding:6px 40px 0; border-collapse:separate !important;">
            <tr>
                <td><div style="max-width:800px; margin:0 auto;"><img src="http://kidlr.co/images/email/kiddlr-top.png" alt="" ></div></td>
            </tr>
            <tr>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0" style="background:url(http://kidlr.co/images/email/kiddlr.png) 0px bottom no-repeat #ffffff; margin:0 auto; padding:0px 40px 325px; max-width:800px; border-collapse:separate !important;">
                        <tr>
                            <td align="center" valign="top" style="text-align:center; padding:20px 0 30px;"><img src="http://kidlr.co/images/email/kidlr-logo.png" alt="" ></td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="font-size:22px; color:#69cef6; font-weight:bold; padding:0 0 27px;"> Dear '.$name.', </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="line-height:24px; padding:0 0 30px;"> You have successfully reset your password for your account at Kidlr. </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="line-height:24px; padding:0 0 30px;"> You may now log in with your new credentials. </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top"><span style="font-weight:bold; color:#000; display: block; padding-bottom:20px;">Thank You</span> <span style="font-normal; color:#000; display: block; padding-bottom:5px;">Regards</span> <span style="font-weight:bold; color:#8ac53f;">Kidlr Team</span></td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" style="line-height:24px; padding:0 0 20px;"> NOTE: Please DO NOT reply to this email. </td>
                        </tr>
                    </table></td>
            </tr>
            <tr>
                <td><table border="0" cellspacing="0" cellpadding="0" style="max-width:400px; margin:0 auto; padding:30px 0 30px; border-collapse:separate !important;">
                        <tr>
                            <td align="center" valign="top" style="padding:0 15px;"><a href="http://kidlr.co/about.html" target="_blank" style="color:#8ac53f;">About</a></td>
                            <td align="center" valign="top" style="padding:0 15px;"><a href="http://kidlr.co/faqs.html" target="_blank" style="color:#69cef6;">FAQs</a></td>
                            <td align="center" valign="top" style="padding:0 15px;"><a href="http://kidlr.co/privacy.html" target="_blank" style="color:#922683;">Privacy</a></td>
                        </tr>
                        <tr>
                            <td align="center" valign="top" colspan="3" style="line-height:24px; padding:30px 0 30px; text-transform:uppercase;">&copy; 2016 Kidlr. All rights reserved. </td>
                        </tr>
                    </table></td>
            </tr>
        </table>
    </body>
</html>';
        
        
        return Utility::sendEmail(self::$fromAddr,  self::$fromName , $receiver,$subject , $body);
        
    }
}
