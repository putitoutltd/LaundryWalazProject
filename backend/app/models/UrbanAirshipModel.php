<?php

/**
 * Contains the all operations related to urbanairship.com
 * 
 * @author Muhammad Rashid <rashid.akram@putitout.co.uk>
 * @copyright (c) 2016, Putitout Solutions
 */

use UrbanAirship\Airship;
use UrbanAirship\AirshipException;
use UrbanAirship\UALog;
use UrbanAirship\Push as P;
use Monolog\Logger;
use Monolog\Handler\StreamHandler;

class UrbanAirshipModel
{

    private $app_key = '';
    private $app_secret = '';
    private $master_secret = '';
    

    /**
     * Class constructor sets the api credentilas
     * 
     */
    public function __construct()
    {
        //From configurations
        $filename = dirname(__FILE__) . '/Config.php';
        if (file_exists($filename)) {
            include_once $filename;
            if (defined('URBAN_APP_KEY') && defined('URBAN_APP_SECRET') && defined('URBAN_MASTER_SECRET')) {
                $this->app_key = URBAN_APP_KEY;
                $this->app_secret = URBAN_APP_SECRET;
                $this->master_secret = URBAN_MASTER_SECRET;
            }
        }
        
    }

    /**
     * 
     * @param Array $data dataset which will be pass to parse.com
     * 
     * @param string $type device type e.g android, ios
     * @param string $deviceToken device unique token which wiil be use by parse.com to send push notifications
     * @return bool
     */
    public function sendPush($data, $deviceToken = false)
    {
        $pushMessage = (isset($data['alert'])) ? $data['alert'] : "You have a new notification on LaundryWalaz";
        UALog::setLogHandlers(array(new StreamHandler("php://stdout", Logger::DEBUG)));
        $airship = new Airship($this->app_key, $this->master_secret);
        //'F02D40D7B77B2B8E4E58F62D1FF111A4634C638701DE04D2BDF77247111541B6'
        try {
            $additionalPaylod = array('ios' => array('badge' => '+1','alert' => $pushMessage));
            $response = $airship->push()
                //->setAudience(P\all)
                ->setAudience(P\deviceToken($deviceToken))    
                ->setNotification(P\notification($pushMessage,$additionalPaylod))
                ->setDeviceTypes(P\all)
                ->send();
             return $response;
        } catch (AirshipException $e) {
            return $e;
        }
    }

}
