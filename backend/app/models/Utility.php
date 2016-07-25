<?php

define("ENCRYPTION_KEY", "LaundryWalaz C@Nn3c! Application");
define("AUTHENTICATION_TOKEN", "{sPjadfadf@4hyBASYdfsLdWJFz2juAdAOI(MkjAnRhsTVC>Wih))J9WT(kr");
include_once dirname(__FILE__) . '/Config.php';

/**
 * Contains the all common utilities of the project
 * 
 * @author Muhammad Rashid Akram <rashid.akram@putitout.co.uk>
 * @copyright (c) 2015, Putitout Solutions
 */
class Utility
{
    
    private static $_internalSocketClient = null;
    
    public function __construct()
    {
        
    }

    /**
     * Returns the array after validating
     * 
     * @param Array $header Array of headers to validate
     * @return Array Response array on headers validation
     */
    public function validateHeaders($header)
    {
        
        $response = array();
        $response['status'] = Response::OK;
        return $response;   // temporarily disallowed headers validation
        
        $valid = false;
        if (isset($header['auth-token']) && $header['auth-token'] === AUTHENTICATION_TOKEN) {
            $response['status'] = Response::OK;
            $valid = true;
        }
        if (!$valid) {
            $response['status'] = Response::FAILURE;
            $response['message'] = Messages::MISSING_HEADERS;
        }
        return $response;
    }
    /**
     * Returns the base url of the server
     * 
     * @return string base url string 
     */
    public static function base_url($site = false)
    {
        /*
        if ($site) {
            include_once dirname(__FILE__) . '/Config.php';
            switch ($site) {
                case 'RESET_PASSWORD':
                    $url = defined('FRONTEND_URL') ? FRONTEND_URL : '';
                    break;
                default :
                    $url = "http://" . filter_input(INPUT_SERVER, 'SERVER_NAME');
            }
            return $url;
        } 
        return "http://" . filter_input(INPUT_SERVER, 'SERVER_NAME');
         * 
         */
        $url = defined('BASE_URL') ? BASE_URL : '';
        return $url; 
    }
    
    /**
     * Returns the theme url of the server
     * 
     * @return string theme url string 
     */
    public static function theme_url()
    {
        $url = defined('THEME_URL') ? THEME_URL : '';
        return $url; 
    }
    
    public static function frontend_url()
    {
        $url = defined('FRONTEND_URL') ? FRONTEND_URL : '';
        return $url; 
    }
    /**
     * Returns the api url
     * 
     * @return string api url string 
     */
    public static function api_url()
    {
       
        $url = defined('API_URL') ? API_URL : '';
        return $url;           
    }

    /**
     * 
     * Returns the random system generated token string
     * 
     * @return string generated token string
     */
    public function randomToken()
    {
        if (function_exists('com_create_guid') === true) {
            return time().trim(com_create_guid(), '{}');
        }
        return time().sprintf(
                '%04X%04X-%04X-%04X-%04X-%04X%04X%04X', mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(16384, 20479), mt_rand(32768, 49151), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535)
        );
    }

    /**
     * Returns an encrypted & utf8-encoded
     */
    public static function encrypt($input)
    {
        return base64_encode(mcrypt_encrypt(MCRYPT_RIJNDAEL_256, md5(ENCRYPTION_KEY), $input, MCRYPT_MODE_CBC, md5(md5(ENCRYPTION_KEY))));
    }

    /**
     * Returns decrypted original string
     */
    public static function decrypt($input)
    {
        return rtrim(mcrypt_decrypt(MCRYPT_RIJNDAEL_256, md5(ENCRYPTION_KEY), base64_decode($input), MCRYPT_MODE_CBC, md5(md5(ENCRYPTION_KEY))), "\0");
    }

    
    /**
     * 
     * @param string $from
     * @param string $fromName
     * @param string $to
     * @param string $subject
     * @param string $body
     * @param array $attachments
     * @param array $embededImages Embeded images in email body
     * @param array $additionalTos other email addresses like CC's
     * 
     * @link https://github.com/PHPMailer/PHPMailer PhpMailer
     */
    
    public static function sendEmail($from, $fromName, $to, $subject, $body, $attachments = array(), $embededImages = array(),$additionalTos=array())
    {
        include_once dirname(__FILE__) . '/Config.php';
        
        $mail = new PHPMailer;
        $mail->Mailer          = "smtp";
        $mail->Port            = SMTP_PORT;  
        $mail->IsSMTP();  
        $mail->SMTPSecure      = "ssl";
        //$mail->SMTPDebug   = 2; 
        $mail->SMTPAuth        = true;
        $mail->SMTPKeepAlive   = true;                           
        $mail->Host            = SMTP_HOST;				 
        $mail->Username        = SMTP_USER;    
        $mail->Password        = SMTP_PASSWORD;        

        $mail->From = $from;
        $mail->FromName = $fromName;
        $mail->AddAddress($to);
        $mail->IsHTML(true);
        $mail->Subject = $subject;


        //  adding additional to address if exists
        if (count($additionalTos) > 0) {
            foreach ($additionalTos as $toAddress) {
                $mail->AddAddress($toAddress);
            }
        }
        //  adding attachments if they exist
        if (count($attachments) > 0) {
            foreach ($attachments as $attachment) {
                if (file_exists($attachment))
                    $mail->AddAttachment($attachment);
            }
        }
        // adding inline images if they exist
        if (count($embededImages) > 0) {
            foreach ($embededImages as $inlineImage) {
                if (file_exists($inlineImage['path']))
                    $mail->AddEmbeddedImage($inlineImage['path'], $inlineImage['id']);
            }
        }
        $mail->Body = $body;
        $response = $mail->Send();
        //$mail->SMTPDebug  = 2;
        $mail->ClearAddresses();
        $mail->ClearAttachments();
        $mail->ClearAllRecipients();

        return $response;
    }

    public static function log($data)
    {
        //echo "<pre>";  print_r($_SERVER); filter_input(INPUT_SERVER, 'HTTP_REFERER');exit;
        include_once dirname(__FILE__) . '/Config.php';
        if (defined('ACCESS_LOGS') && ACCESS_LOGS === 1) {
            $date = date('Y-m-d');
            $current_date = date("Y-m-d H:i:s");
            $dump = $current_date . " :: " . filter_input(INPUT_SERVER, 'REDIRECT_URL') . " " . json_encode($data) . PHP_EOL;
            $filename = "public/logs/access_log_$date.log";
            file_put_contents($filename, $dump, FILE_APPEND | LOCK_EX);
            chmod($filename, 0664);
        }
    }

    public static function escapeSpecial($string)
    {
        return preg_replace('/[^A-Za-z0-9\-]/', '', $string); // Removes special chars.
    }
    
    public static function generateRandomString($length = 9) {
    
        return substr(str_shuffle("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), 0, $length);
    }
    
    public static function calculateDateDifference($startDate, $endDate,$string = FALSE){
        
        $datetime1 = new DateTime($startDate);
        $datetime2 = new DateTime($endDate);
        $interval = $datetime1->diff($datetime2);
        if($string === TRUE){
            return $interval->format('%y years %m months and %d days');
        }else{
            $results = array();
            $results['years'] = $interval->format('%y');
            $results['months'] = $interval->format('%m');
            $results['days'] = $interval->format('%d');
            return $results;
        }
    }
    
    public static function concatNotEmptyValues($stringPieces = array()){
        
        $outputString = "";
        foreach ($stringPieces as $chunk){
            if(!empty($chunk)){
                $outputString .= ' '.$chunk;
            }
        }
        return trim($outputString);
    }
    
    public static function filterLimitOffset($offset, $limit){
        
        if(!empty($limit) && !is_numeric($limit)){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Limit '.Messages::IS_NOT_VALID;
            Response::sendResponse($response);
        }
        if(!empty($offset) && !is_numeric($offset)){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Offset '.Messages::IS_NOT_VALID;
            Response::sendResponse($response);
        }
        $limitRecords = "";
        if(!empty($limit) && !empty($offset)){
            $limitRecords =  $offset.','.$limit;
        }
        else if(!empty($limit) && empty($offset)){
            $limitRecords =  $limit;
        }
        
        return $limitRecords;
    }
    
    public static function sendCurlRequest($url,$data){
        
        //$jsonData = json_encode($data);
        
        //$params=['name'=>'John', 'surname'=>'Doe', 'age'=>36)
        $defaults = array(
        CURLOPT_URL => $url, 
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => $data,
        );
        $ch = curl_init();
        curl_setopt_array($ch, ($defaults));
        $response = curl_exec($ch);
        echo $response; 
        
    }
    
}
