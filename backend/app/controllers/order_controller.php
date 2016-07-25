<?php

/**
 * Handles all requests related to orders and performs opertaions accordingly
 * 
 * @author Muhammad Rashid <rashid.akram@putitout.co.uk>
 * @copyright (c) 2016, Putitout Solutions
 */
class OrderController extends BaseController
{

    public function __construct($params, $action, $app)
    {
        $this->model = new OrdersModel();
        parent::__construct($params, $action, $app);
    }
    
    
    /**
    * @api {post} /api/order/create  Create Order
    * @apiName CreateOrder
    * @apiGroup Orders
    * @apiVersion 0.1.0
    *
    * @apiParam {string} [email]
    * @apiParam {string} [phone] 
    * @apiParam {string} [first_name]
    * @apiParam {string} [last_name]
    * @apiParam {string} location_id
    * @apiParam {string} address
    * @apiParam {string} access_token The dynamic token generated after successful login
    * @apiParam {datetime} pickup_time 
    * @apiParam {datetime} dropoff_time 
    * @apiParam {string} [special_instructions]
    * 
    *
    * @apiSuccess {Array} response it returns an array with user details if successful other wise failure with message.
    */
    protected function _create_order()
    {
        $auth_token = $this->app->request->headers->get("auth-token");
        $this->validateHeaders($auth_token);    // validating auth headers
        $email = mb_strtolower($this->request->params('email'), 'UTF-8');
        
        $accessToken = Utility::escapeSpecial($this->request->params('access_token'));
        $userId = $this->validateAccessToken($accessToken);
        
        $todayDate = date('Y-m-d H:i:s');
        $data = array(
           // 'username'              => $this->request->params('username'),
            'email'                 => $email,
            'status'                => 0,
            'phone'                 => $this->request->params('phone'),
            'password'              => $this->request->params('password'),
            'first_name'            => $this->request->params('first_name'),
            'last_name'             => $this->request->params('last_name'),
            'locations_id'          => $this->request->params('location_id'),
            'address'               => $this->request->params('address'),
            'user_id'               => $userId,
            'pickup_time'           => $this->request->params('pickup_time'),
            'dropoff_time'          => $this->request->params('dropoff_time'),
            'special_instructions'  => $this->request->params('special_instructions'),
            'date_created'          => $todayDate,
            'date_modified'         => $todayDate,
            
        );
        
        // required fields validation
        $requiredParams = array('locations_id'=> $data['locations_id'],'address'=> $data['address']);
        $this->validateEmptyValues($requiredParams);
        
       
        // validate inputs
        if(!empty($email) && !filter_var($email, FILTER_VALIDATE_EMAIL)){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Email '.Messages::IS_NOT_VALID;
            Response::sendResponse($response);
        }
        
        // validating dates
        if(date('Y-m-d H:i:s',  strtotime($data['pickup_time'])) != $data['pickup_time']){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Pickup Time '.Messages::IS_NOT_VALID;
            Response::sendResponse($response);
        }
        if(date('Y-m-d H:i:s',  strtotime($data['dropoff_time'])) != $data['dropoff_time']){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Dropoff Time '.Messages::IS_NOT_VALID;
            Response::sendResponse($response);
        }
        // pick up cannot be set in past
        
        if( date('Y-m-d') > date('Y-m-d',  strtotime($data['pickup_time'])) ){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Pickup Time '.Messages::IS_NOT_VALID;
            Response::sendResponse($response);
        }
        
        // drop off cannot be set in past
        if( date('Y-m-d') > date('Y-m-d',  strtotime($data['dropoff_time']))   ){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Dropoff Time '.Messages::IS_NOT_VALID;
            Response::sendResponse($response);
        }
        
        // pick up cannot be greater than dropoff
        if( strtotime($data['dropoff_time']) <= strtotime($data['pickup_time']) ){
            $response['status'] = Response::FAILURE;
            $response['message'] = Messages::PICKUP_DROPOFF_MISMATCH;
            Response::sendResponse($response);
        }
        
        $usersModel = new UsersModel();
        
        //validating user id
        if(!empty($userId)){
            $userRecord = $usersModel->getRecordById($data['user_id']);
            if(!$userRecord){
                $response['status'] = Response::FAILURE;
                $response['message'] = 'User Id '.Messages::IS_NOT_VALID;
                Response::sendResponse($response);
            }
            //$userId = $data['user_id'];
            // overriding users details with saved details
            $data['email'] = $userRecord['email'];
            $data['phone'] = $userRecord['phone'];
            $data['first_name'] = $userRecord['first_name'];
            $data['last_name'] = $userRecord['last_name'];
            if(empty($data['locations_id'])){
                $data['locations_id'] = $userRecord['locations_id'];
            }
            if(empty($data['address'])){
                $data['address'] = $userRecord['address'];
            }
            
            
        }
        
        //validating user email
        if(empty($data['user_id']) && !empty($data['email'])){
            $userRecord = $usersModel->getRecordByEmail($data['email']);
            if(!$userRecord){
                $userData = array(
                     // 'username'              => $this->request->params('username'),
                    'email'                 => $email,
                    'status'                => 2,
                    'type'                  => 2,
                    'phone'                 => $this->request->params('phone'),
                    'password'              => $this->request->params('password'),
                    'first_name'            => $this->request->params('first_name'),
                    'last_name'             => $this->request->params('last_name'),
                    'locations_id'          => $this->request->params('location_id'),
                    'address'               => $this->request->params('address'),
                    'date_created'          => $todayDate,
                    'date_modified'         => $todayDate
                );
                
                $result = $usersModel->saveUser($userData);
                $userId = $result;
            }else{
                $userId = $userRecord['id'];
            }
        }
        
        $locationsModel = new LocationsModel();
        $allLocations = $locationsModel->getAllLocations(TRUE);
        
        if(!in_array($data['locations_id'], $allLocations)){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Location is '.Messages::INVALID;
            $response['data'] = $data['locations_id'];
            Response::sendResponse($response);
        }
        
        // creating order without items
        $orderData = array(
            'status'                => $data['status'],
            'phone'                 => $data['phone'],
            'locations_id'          => $data['locations_id'],
            'address'               => $data['address'],
            'users_id'              => $userId,
            'pickup_time'           => $data['pickup_time'],
            'dropoff_time'          => $data['dropoff_time'],
            'special_instructions'  => $data['special_instructions'],
            'date_created'          => $todayDate,
            'date_modified'         => $todayDate
        );
        
        $ordersModel = $this->model;
        $lastOrder = $ordersModel->getLastOrderByUserId($userId);
        if($lastOrder['status'] < 4){
            $response['status'] = Response::FAILURE;
            $response['message'] = Messages::ORDER_IN_PROGRESS;
            $response['data'] = $lastOrder;
            Response::sendResponse($response);
            
        }
        $orderId = $ordersModel->saveOrder($orderData);
        
       if($orderId ){
           
            $response['status'] = Response::SUCCESS;
            $response['data']['order_id'] = $orderId;
            $response['message'] = Messages::ORDER_CREATED_SUCCESSFULLY;
            $orderData['id'] = $orderId;
            $this->sendOrderEmail($orderData);
        }else{
            $response['status'] = Response::FAILURE;
            $response['message'] = Messages::RECORD_NOT_INSERTED;
        }
        Response::sendResponse($response);
    }
    
    protected function _list_orders()
    {
        if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        $ordersModel = $this->model;
        $orders = $ordersModel->getAllOrders();
        $this->page_title = 'Orders Listing';
        $this->render('order/list_orders',array('orders' => $orders) );
    }
    
    
    
    
    protected function _edit_order()
    {
       if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        $data = array();
        $params = $this->request->params();
        $orderId = ( isset($params['oid']) && !empty($params['oid']) ) ? $params['oid'] : '';
        if(empty($orderId)){ 
            $data['error'] = 'invalid order id'; 
            $this->render('order/edit_order',$data );
        }
        $ordersModel = $this->model;
        $order = $ordersModel->getOrderById($orderId);
        $this->page_title = 'Edit Order';
        
        if(!$order['order'] && !$order['orderItems']){ 
            $data['error'] = 'invalid order id'; 
        }
        
        $data['order'] = $order['order'];
        $data['orderItems'] = $order['orderItems'];
        $this->render('order/edit_order',$data );
    }
    
    protected function _add_items()
    {
       if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        $data = array();
        $params = $this->request->params();
        $orderId = ( isset($params['oid']) && !empty($params['oid']) ) ? $params['oid'] : '';
        if(empty($orderId)){ 
            $data['error'] = 'invalid order id'; 
            $this->render('order/add_order_items',$data );
            return;
        }
        $ordersModel = $this->model;
        
        // saving order items 
        if(isset($params['items'])){
            
            // removing old items to avoid duplication
            
            $ordersModel->deleteItemsByOrderId($orderId);
            foreach ($params['items'] as $item){
                $quantity = ( isset($params['quantity_'.$item]) )? $params['quantity_'.$item] : 1;
                $itemData = array(
                    'orders_id' => $orderId,
                    'service_items_id' => $item,
                    'quantity' => $quantity
                );
                $ordersModel->saveOrderItem($itemData);
                
            }
            $this->redirect('/orders/edit?oid='.$orderId);
        }
        
        $order = $ordersModel->getOrderById($orderId);
        $this->page_title = 'Add Items';
        $this->page_heading = 'Choose order items';
        
        if(!$order['order'] && !$order['orderItems']){ 
            $data['error'] = 'invalid order id'; 
        }
        $serviceModel = new ServiceItemsModel();
        $serviceList = $serviceModel->getAllServices();
        
        $data['services'] = $serviceList;
        $data['order'] = $order['order'];
        $data['orderItems'] = $order['orderItems'];
        $this->render('order/add_order_items',$data );
    }
    
    
    
    protected function _delete_order()
    {
       if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        $data = array();
        $params = $this->request->params();
        $orderId = ( isset($params['oid']) && !empty($params['oid']) ) ? $params['oid'] : '';
        if(empty($orderId)){ 
            $data['error'] = 'invalid order id'; 
            echo json_encode($data);
            return;
        }
        $ordersModel = $this->model;
        
        
        $order = $ordersModel->getOrderById($orderId);
        if(!$order['order'] && !$order['orderItems']){ 
            $data['error'] = 'invalid order id'; 
            echo json_encode($data);
            return;
        }
        
        if($ordersModel->deleteOrder($orderId)){
            $data['success'] = 'Order deleted successfully'; 
            echo json_encode($data);
            return;
        }else{
            $data['error'] = 'Unable to delete order'; 
            echo json_encode($data);
            return;
        }
        
        
    }
    
    
    protected function _update_order_status()
    {
        if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
       
        $data = array();
        $params = $this->request->params();
        $orderId = ( isset($params['oid']) && !empty($params['oid']) ) ? $params['oid'] : '';
        $orderStatus = ( isset($params['ost']) && !empty($params['ost']) ) ? $params['ost'] : '';
        
        if(!empty($orderId) && !empty($orderStatus)){ 
            $ordersModel = $this->model;
            $orderStatuses = SystemOptions::getOrderStatuses();
            $order = $ordersModel->getOrderById($orderId);
            if($order){
                $status =  ( isset($orderStatuses[$orderStatus]) ) ? $orderStatus : $order['status'];
                $data = array(
                    'status' => $status,
                    'date_modified' => date('Y-m-d H:i:s')
                );
                
                $updated = $ordersModel->updateOrder($data, $orderId);
                if($updated){
                    $res = array(
                        'status' => 1,
                        'message' => 'Status updated successfully!'
                    );
                    echo json_encode($res);
                    return;
                }
            }
        }
        $res = array(
                        'status' => 0,
                        'message' => 'Unable to update'
                    );
            echo json_encode($res);
        
    }
    
    private function sendOrderEmail($orderDetails){
       
        /*
        $to  = 'info@laundrywalaz.com' . ', '; // note the comma
        $to .= 'rashid.akram@putitout.co.uk';
        */
         $to  = 'info@laundrywalaz.com';
        $subject = 'New Order Placed';
        
        // message
        $message = '
        <html>
        <head>
          <title>New Order has been placed</title>
        </head>
        <body>
          <p>Order Id: <b>'.$orderDetails['id'].'</b></p>
          <p>Phone: <b>'.$orderDetails['phone'].'</b></p>
          <p>Address: <b>'.$orderDetails['address'].'</b></p>
          <p>Pickup: <b>'.$orderDetails['pickup_time'].'</b></p>
          <p>Dropoff: <b>'.date('Y-m-d', strtotime($orderDetails['dropoff_time'])).' 06:00 pm - 09:00 pm</b></p>
          <p>Special Instructions: <b>'.$orderDetails['special_instructions'].'</b></p>

        </body>
        </html>
        ';
        
        // To send HTML mail, the Content-type header must be set
        $headers  = 'MIME-Version: 1.0' . "\r\n";
        $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";

        // Additional headers
        //$headers .= 'To: Mary <mary@example.com>, Kelly <kelly@example.com>' . "\r\n";
        $headers .= 'From: Laundrywalaz User <service@laundrywalaz.com>' . "\r\n";
        //$headers .= 'Cc: birthdayarchive@example.com' . "\r\n";
        //$headers .= 'Bcc: birthdaycheck@example.com' . "\r\n";

        // Mail it
        if(!empty($message)){
            return @mail($to, $subject, $message, $headers);
        }
           
    }
        
}