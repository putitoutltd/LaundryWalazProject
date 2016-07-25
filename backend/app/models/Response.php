<?php

/**
 * Contains the all responses which are used in response of a API call
 * 
 * @author Muhammad Shahbaz <mohammadshahbax@mail.com>
 * @copyright (c) 2015, Putitout Solutions
 */
class Response
{

    const SUCCESS = 'success';
    const FAILURE = 'failure';
    const OK = 'ok';
   
    
    
    /**
     * Returns the response array
     * 
     * @param Array $data response patteren array
     */
    public static function sendResponse($data)
    {
        $response = array(
            'status' => isset($data['status']) ? $data['status'] : '',
            'message' => isset($data['message']) ? $data['message'] : '',
            'data' => isset($data['data']) ? $data['data'] : ''
        );
        
        //Loging Into Files
        $slim = new \Slim\Slim();
        $req = $slim->request();
        Utility::log(array('REQUEST' =>$req->params(), 'HEADER-AUTH-TOKEN' => $req->headers->get("auth-token") , 'RESPONSE' => $response));
        
        echo json_encode($response);
        exit;
    }

}
