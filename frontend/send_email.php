<?php


 $action = filter_input(INPUT_POST, 'action');
$email = 'anonymus@laundrywalaz.com';
 // multiple recipients
 /*
$to  = 'info@laundrywalaz.com' . ', '; // note the comma
$to .= 'rashid.akram@putitout.co.uk';
*/
 $to  = 'rashid.akram@putitout.co.uk';
$message = '';
 if($action == 'feedback'){

     $about = filter_input(INPUT_POST, 'about');
     $feedback = filter_input(INPUT_POST, 'feedback');
// subject
$subject = 'New Feedback received';
    if(!empty($about) && !empty($feedback)){
        // message
        $message = '
        <html>
        <head>
          <title>New Feedback Received</title>
        </head>
        <body>
          <p>The feedback was about <b>'.$about.'</b></p>
          <p>'.$feedback.'</p>    

        </body>
        </html>
        ';
    }    
 }
 
 else if($action == 'area'){

     $email = filter_input(INPUT_POST, 'email');
     $area = filter_input(INPUT_POST, 'area');
// subject
$subject = 'New Area was requested';
    if(!empty($email) && !empty($area)){
        // message
        $message = '
        <html>
        <head>
          <title>New area requested</title>
        </head>
        <body>
          <p>The requested area is <b>'.$area.'</b></p>


        </body>
        </html>
        ';
    }    
 }
// To send HTML mail, the Content-type header must be set
$headers  = 'MIME-Version: 1.0' . "\r\n";
$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";

// Additional headers
//$headers .= 'To: Mary <mary@example.com>, Kelly <kelly@example.com>' . "\r\n";
$headers .= 'From: Laundrywalaz User <'.$email.'>' . "\r\n";
//$headers .= 'Cc: birthdayarchive@example.com' . "\r\n";
//$headers .= 'Bcc: birthdaycheck@example.com' . "\r\n";

// Mail it
if(!empty($message)){
    if(mail($to, $subject, $message, $headers)){
        echo '1';
    }else{
        echo '0';
    }
}