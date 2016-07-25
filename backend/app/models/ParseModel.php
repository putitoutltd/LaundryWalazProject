<?php

/**
 * Contains the all operations related to parse.com
 * 
 * @author Muhammad Shahbaz <mohammadshahbax@mail.com>
 * @copyright (c) 2015, Putitout Solutions
 */
class ParseModel
{

    private $app_id = '';
    private $rest_key = '';
    private $master_key = '';
    private $api_push = 'https://api.parse.com/1/push';
    private $api_installation = 'https://api.parse.com/1/installations';

    /**
     * Class constructor sets the credentilas if passed on intiation of the object
     * 
     * @param Array $credentials credentials array
     */
    public function __construct($credentials = array())
    {
        //From configurations
        $filename = dirname(__FILE__) . '/Config.php';
        if (file_exists($filename)) {
            include_once $filename;
            if (defined('PARSE_APP_ID') && defined('PARSE_REST_KEY') && defined('PARSE_MASTER_KEY')) {
                $this->app_id = PARSE_APP_ID;
                $this->rest_key = PARSE_REST_KEY;
                $this->master_key = PARSE_MASTER_KEY;
            }
        }
        //Passing from object initiation
        if (!empty($credentials) && is_array($credentials)) {
            $this->app_id = isset($credentials['app_id']) ? $credentials['app_id'] : "";
            $this->rest_key = isset($credentials['rest_key']) ? $credentials['rest_key'] : "";
            $this->master_key = isset($credentials['master_key']) ? $credentials['master_key'] : "";
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
    public function sendPush($data, $type = false, $deviceToken = false)
    {
        $dataArray = array(
            'expiry' => 1451606400,
            'data' => $data
        );
        if ($type && $type != '') {
            $dataArray['type'] = $type;
            $dataArray['channel'] = 'global';
        }
        if ($deviceToken) {
            $dataArray['where']['deviceToken'] = $deviceToken;
        }
        return $this->hitCurl($this->api_push, $dataArray);
    }

    /**
     * 
     * @param Array $data data array to save on parse.com through api call
     * @return bool
     */
    public function registerDevice($data)
    {
        return $this->hitCurl($this->api_installation, $data);
    }

    /**
     * Sends the data to parse.com by curl API call
     * 
     * @param type $url url of the parse api
     * @param Array $data data array which will be pass to parse.com by curl call
     * @return bool
     */
    public function hitCurl($url, $data)
    {
        $jsonData = json_encode($data);
        $headers = array(
            "X-Parse-Application-Id:  $this->app_id",
            "X-Parse-REST-API-Key:  $this->rest_key",
            "Content-Type: application/json",
            'Content-Length: ' . strlen($jsonData),
        );

        $rest = curl_init();
        curl_setopt($rest, CURLOPT_URL, $url);
        //curl_setopt($rest, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($rest, CURLOPT_PORT, 443);
        curl_setopt($rest, CURLOPT_POST, 1);
        curl_setopt($rest, CURLOPT_POSTFIELDS, $jsonData);
        curl_setopt($rest, CURLOPT_HTTPHEADER, $headers);
        $response = curl_exec($rest);
        return $response;
    }

}
