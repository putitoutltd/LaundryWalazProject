<?php

/**
 * Handles all requests related to services and its items and performs opertaions accordingly
 * 
 * @author Muhammad Rashid <rashid.akram@putitout.co.uk>
 * @copyright (c) 2016, Putitout Solutions
 */
class ServiceController extends BaseController
{

    public function __construct($params, $action, $app)
    {
        $this->model = new ServiceItemsModel();
        parent::__construct($params, $action, $app);
    }
    
    /**
    * @api {get} /api/services/list  Services List
    * @apiName ServiceList
    * @apiGroup Services
    * @apiVersion 0.1.0
    *
    *
    * @apiSuccess {Array} response it returns an array with services list.
    */
    protected function _get_all_services()
    {
        $auth_token = $this->app->request->headers->get("auth-token");
        $this->validateHeaders($auth_token);    // validating auth headers
       
        $servicesModel = $this->model;
        
        $allServices = $servicesModel->getAllServices();
        
        // if the user is already registered don't go further
       // if($alreadyRegistered && isset($alreadyRegistered['status']) && $alreadyRegistered['status'] != '4'){
         if(count($allServices) == 0){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Services '.Messages::NOT_FOUND;
        }else{
            $response['status'] = Response::SUCCESS;
            //$response['message'] = Messages::USER_SUCCESSFULLY_REGISTERED;
            $response['data'] = $allServices;
        }
        
            
            
        Response::sendResponse($response);
    }
    
    
    /**
    * @api {get} /api/services/operating_areas  Operating Areas
    * @apiName OperatingAreas
    * @apiGroup Services
    * @apiVersion 0.1.0
    *
    *
    * @apiSuccess {Array} response it returns an array with operating areas list.
    */
    protected function _get_all_operating_areas()
    {
        $auth_token = $this->app->request->headers->get("auth-token");
        $this->validateHeaders($auth_token);    // validating auth headers
       
        $servicesModel = $this->model;
        
        $allAreas = $servicesModel->getAllLocations();
       
         if(count($allAreas) == 0){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Areas '.Messages::NOT_FOUND;
        }else{
            $response['status'] = Response::SUCCESS;
            $response['data']['operating_areas'] = $allAreas;
        }
        
            
        Response::sendResponse($response);
    }
    
    
    protected function _list_prices()
    {
        if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        
        $servicesModel = new ServiceItemsModel();
        $allServices = $servicesModel->getAllServices();
        
        
        $this->page_title = 'Pricing';
        $this->render('service/list_prices',array('prices' => $allServices) );
    }
    
    
    protected function _edit_service()
    {
       if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        $data = array();
        $params = $this->request->params();
        $serviceId = ( isset($params['sid']) && !empty($params['sid']) ) ? $params['sid'] : '';
        if(empty($serviceId)){ 
            $data['error'] = 'invalid item id'; 
            $this->render('service/edit_service',$data );
        }
        $servicesModel = $this->model;
        $order = $servicesModel->getServiceItemById($serviceId);
        $this->page_title = 'Edit Service Item';
        
        $data['order'] = $order['order'];
        $data['orderItems'] = $order['orderItems'];
        $this->render('order/edit_order',$data );
    }
        
}