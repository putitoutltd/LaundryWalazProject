<?php

/**
 * Handles all requests related to user and performs opertaions accordingly
 * 
 * @author Muhammad Rashid <rashid.akram@putitout.co.uk>
 * @copyright (c) 2015, Putitout Solutions
 */
class UserController extends BaseController
{
    
    public function __construct($params, $action, $app)
    {
        $this->model = new UsersModel();
        parent::__construct($params, $action, $app);
    }

    /**
    * @api {post} /api/user/register  Register new User
    * @apiName Register
    * @apiGroup Users
    * @apiVersion 0.1.0
    *
    * @apiParam {string} email  must be unique
    * @apiParam {string} password
    * @apiParam {string} [location_id]
    * @apiParam {string} phone 
    * @apiParam {string} first_name
    * @apiParam {string} last_name
    * @apiParam {string} [address]
    * 
    *
    * @apiSuccess {Array} response it returns an array with user details if successful other wise failure with message.
    */
    protected function _register_user()
    {
        $auth_token = $this->app->request->headers->get("auth-token");
        $this->validateHeaders($auth_token);    // validating auth headers
        $email = mb_strtolower($this->request->params('email'), 'UTF-8');
        
        
        $todayDate = date('Y-m-d H:i:s');
        $data = array(
           // 'username'              => $this->request->params('username'),
            'email'         => $email,
            'status'        => 3,
            'phone'         => $this->request->params('phone'),
            'password'      => $this->request->params('password'),
            'first_name'    => $this->request->params('first_name'),
            'last_name'     => $this->request->params('last_name'),
            'locations_id'  => $this->request->params('location_id'),
            'address'       => $this->request->params('address'),
            'type'          => 2,
            'date_created'  => $todayDate,
            'date_modified' => $todayDate,
            
        );
        
       // required fields validation
        $requiredParams = array('email'=>$email,'phone'=> $data['phone'],'password'=> $data['password'],'first_name'=> $data['first_name'],'last_name'=> $data['last_name']);
        $this->validateEmptyValues($requiredParams);
        
        // validate inputs
        if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Email '.Messages::IS_NOT_VALID;
            Response::sendResponse($response);
        }
        
        $usersModel = new UsersModel();
        
        $validate = $usersModel->fieldValidations($data);
        if($validate !== TRUE){
            $response['status'] = Response::FAILURE;
            $response['message'] = $validate;
            Response::sendResponse($response);
        }
        
        $locationsModel = new LocationsModel();
        $allLocations = $locationsModel->getAllLocations(TRUE);
        
        if(!in_array($data['locations_id'], $allLocations)){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Location is '.Messages::INVALID;
            $response['data'] = $data['locations_id'];
            Response::sendResponse($response);
        }
        $alreadyRegistered = $usersModel->getRecordByEmail($email);
        
        // if the user is already registered don't go further
       // if($alreadyRegistered && isset($alreadyRegistered['status']) && $alreadyRegistered['status'] != '4'){
         if($alreadyRegistered){
            $response['status'] = Response::FAILURE;
            $response['message'] = Messages::USER_ALREADY_REGISTERED;
            $response['data'] = $alreadyRegistered;
            Response::sendResponse($response);
        }
        if($data['status']    == USER_UNVERIFIED){
            $fullName = Utility::concatNotEmptyValues(array($data['first_name'],$data['last_name']));
            $emailDetails = $this->sendVerificationEmail($email,$fullName);
            
            $data['verification_token']    = $emailDetails['token'] ;
            $data['verification_token_expiry']    = $emailDetails['expiry'];
        
        }
        
        $data['password'] = $this->encryptPassword($data['password']);
        $data['date_created']  = $todayDate;
        $result = $usersModel->saveUser($data);
        $userId = $result;
        
        if ($result) {
            
            $response['status'] = Response::SUCCESS;
            
            $response['message'] = Messages::USER_SUCCESSFULLY_REGISTERED;
            //EmailTemplates::userRegisteration($email,$name); // sending email to the user
            
            
            //$token = $usersModel->generateAccessToken($email);
            //$response['data']['access_token'] = $token;
            $response['data']['user_id'] = $userId;
            $response['data']['details'] = $usersModel->getRecordById($userId);
            //$response['data']['img'] = Utility::getImageUrl('users', $userId, $token);
                
        } else {
            $response['status'] = Response::FAILURE;
            $response['message'] = Messages::RECORD_NOT_INSERTED;
        } 
        Response::sendResponse($response);
    }
    
    
    
    /**
    * @api {put} /api/user/verify-token  Verify Token
    * @apiName VerifyToken
    * @apiGroup Users
    * @apiVersion 0.1.0
    *
    * @apiParam {string} token  token to be verified
    * @apiParam {string} email  email with which the user registered
    *
    * @apiSuccess {Array} response Containing success status or failure with message.
    */
    protected function _verify_registration_token()
    {
        $auth_token = $this->app->request->headers->get("auth-token");
        $this->validateHeaders($auth_token);    // validating auth headers
        
        $token = base64_decode($this->request->params('token'));
        $email = base64_decode($this->request->params('email')) ;
        $todate = date('Y-m-d H:i:s');
        // validate inputs
        if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Email '.Messages::IS_NOT_VALID;
            Response::sendResponse($response);
        }
        // required fields validation
        $requiredParams = array('email'=>$email,'token'=> $token);
        $this->validateEmptyValues($requiredParams);
        
        $usersModel = new UsersModel();
        $result = $usersModel->checkTokenWithEmail($email,trim($token));
        
        if ($result ) {
            if(isset($result['verification_token_expiry']) && time() < $result['verification_token_expiry']){
                $response['status'] = Response::SUCCESS;
                $response['message'] = Messages::USER_VERIFIED;
                $data = array(
                    'verification_token' => '',
                    'verification_token_expiry' => '',
                    'date_modified' => $todate,
                    'status' => USER_ACTIVE
                );
                $usersModel->updateUser($data, $result['id']);
                $fullName = Utility::concatNotEmptyValues(array($result['first_name'],$result['last_name']));
                EmailTemplates::userRegisteration($email,$fullName); // sending email to the user
                //$token = $usersModel->generateAccessToken($email);
                //$response['data']['access_token'] = $token;
                //$response['data']['user_id'] = $result['id'];
                //$response['data']['details'] = $usersModel->getRecordById($result['id']);
                //$response['data']['img'] = Utility::getImageUrl('users', $result['id'], $token);
                
            }else if(isset($result['verification_token_expiry']) && time() > $result['verification_token_expiry']){
                
                $fullName = Utility::concatNotEmptyValues(array($result['first_name'],$result['middle_name'],$result['last_name']));
                $emailDetails = $this->sendVerificationEmail($email,$fullName);
            
                $data = array(
                    'verification_token' => $emailDetails['token'],
                    'verification_token_expiry' => $emailDetails['expiry'],
                    'date_modified' => $todate,
                );
                $usersModel->updateUser($data, $result['id']);
                $response['status'] = Response::SUCCESS;
                $response['message'] = Messages::VERIFICATION_EMAIL_RESENT;
            }
            
        } else {
            $response['status'] = Response::FAILURE;
            $response['message'] = Messages::INVALID_VERIFICATION_TOKEN;
        }
        
        
        Response::sendResponse($response);
    }
    
    /**
    * @api {put} /api/user/update  Update User
    * @apiName Update
    * @apiGroup Users
    * @apiVersion 0.1.0
    *
    * @apiParam {string} access_token  The token you receive if successfully login
    * @apiParam {string} first_name
    * @apiParam {string} middle_name
    * @apiParam {string} last_name
    * @apiParam {string} country
    * @apiParam {int} [status] e.g 1,2 ['1' => 'Active', '2' => 'Inactive','3' => 'Suspended','4' => 'Invited']
    * @apiParam {string} [type] currently supports only one type of user i.e. 1 ['1' => 'Normal',]
    * @apiParam {string} gender possible values : male, female
    *
    * @apiSuccess {Array} response Returns an array containing updated values or failure with message.
    */
    protected function _update_user()
    {        
        $auth_token = $this->app->request->headers->get("auth-token");
        $this->validateHeaders($auth_token);    // validating auth headers
        $access_token = Utility::escapeSpecial($this->request->params('access_token'));
        
        $data = array(
            'first_name'            => $this->request->params('first_name'),
            'middle_name'           => $this->request->params('middle_name'),
            'last_name'             => $this->request->params('last_name'),
            'status'                => $this->request->params('status'),
            'type'                  => $this->request->params('type'),
            'country'               => $this->request->params('country'),
            'gender'                => $this->request->params('gender'),
            'date_modified'         => date('Y-m-d H:i:s')
        );
        
        $countriesList = CountryModel::getCountriesList();
        // validate inputs
        if(!empty($data['country']) && !array_key_exists($data['country'], $countriesList)){
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Country ['.$data['country'].']'.Messages::IS_NOT_VALID;
            Response::sendResponse($response);
        }
        
        $usersModel = new UsersModel();
        $validate = $usersModel->fieldValidations($data,'update');
        if($validate !== TRUE){
            $response['status'] = Response::FAILURE;
            $response['message'] = $validate;
            Response::sendResponse($response);
        }
        
        if (!empty($access_token)) {
            $userRecord = $usersModel->getRecordByToken($access_token);
            if (!empty($userRecord)) { //User Record Exists
                $updated = $usersModel->updateUser(array_filter($data),$userRecord['id']);
                if ($updated) {
                    $response['status'] = Response::SUCCESS;
                    $response['message'] = Messages::INFORMATION_UPDATED;
                    $response['data']['details'] = array_filter($data);
                } else {
                    $response['status'] = Response::FAILURE;
                    $response['message'] = Messages::FAILED_TO_UPDATE;
                }
            } else {
                    $response['status'] = Response::FAILURE;
                    $response['message'] = Messages::ACCESS_TOKEN_NOT_VALID;
                }
        } else {
            $response['status'] = Response::FAILURE;
            $response['message'] = Messages::ACCESS_TOKEN_MISSING;
        }   
        Response::sendResponse($response);
    }
    
    /**
    * @api {post} /api/user/login  Login
    * @apiName Login
    * @apiGroup Users
    * @apiVersion 0.1.0
    *
    * @apiParam {string} email  The email that was used to register 
    * @apiParam {string} password  User's password
    *
    * @apiSuccess {Array} response it returns an array with access token and user details if successful other wise failure with message.
    */
    protected function _user_login()
    {        
        $auth_token = $this->app->request->headers->get("auth-token");
        $this->validateHeaders($auth_token);    // validating auth headers
        
        $email = mb_strtolower($this->request->params('email'), 'UTF-8');
        $password = $this->request->params('password');
       
        // required fields validation
        $requiredParams = array('email'=>$email,'password'=> $password);
        $this->validateEmptyValues($requiredParams);
        
        $usersModel = new UsersModel();
        $result = $usersModel->loginAuthentication($email, $this->encryptPassword($password) );
        if (!empty($result)) { // Record Exists
            
            // IF USER IS ACTIVE
            if($result['status'] == USER_ACTIVE){
                
                $ordersModel = new OrdersModel();
                $order = $ordersModel->getLastOrderByUserId($result['id']);
                $response['status'] = Response::SUCCESS;
                $response['message'] = Messages::LOGGED_IN_SUCCESSFUL;
                $response['data']['details'] = $result;
                $response['data']['order'] = $order;
                $token = $usersModel->generateAccessToken($email);
                $response['data']['access_token'] = $token;
                //$response['data']['details']['img'] = Utility::getImageUrl('users', $result['id'], $token);
                
            }else if($result['status'] == USER_UNVERIFIED){
                $response['status'] = Response::FAILURE;
                $response['data']['email'] = $email;
                $response['message'] = Messages::EMAIL_NOT_VERIFIED;
            }
        } else {
            $response['status'] = Response::FAILURE;
            $response['message'] = Messages::LOGIN_CREDENTIALS_INVALID;
        }
        
        Response::sendResponse($response);
    }
    
    /**
    * @api {put} /api/user/logout  Logout
    * @apiName Logout
    * @apiGroup Users
    * @apiVersion 0.1.0
    *
    * @apiParam {string} access_token  The token you receive if successfully login
    *
    * @apiSuccess {Array} response it returns an array with success or failure with message.
    */
    
    protected function _user_logout()
    {
        $auth_token = $this->app->request->headers->get("auth-token");
        $this->validateHeaders($auth_token);    // validating auth headers
        
        $accessToken = Utility::escapeSpecial($this->request->params('access_token'));
        $userId = $this->validateAccessToken($accessToken);
        
        $userModel = new UsersModel();
        $updated = $userModel->removeAccessTokenById($userId);
        if ($updated) {

           // $deviceModel = new DevicesModel();
           // $deviceModel->deleteRecordById($userId);  //Removing device from the table

            $response['status'] = Response::SUCCESS;
            $response['message'] = Messages::LOGGED_OUT_SUCCESSFUL;
        } else {
            $response['status'] = Response::FAILURE;
            $response['message'] = Messages::FAILED_TO_UPDATE;
        }
        
        Response::sendResponse($response);
    }
    
    /**
    * @api {post} /api/user/forget-password  Forget Password
    * @apiName ForgetPassword
    * @apiGroup Users
    * @apiVersion 0.1.0
    *
    * @apiParam {string} email  User's email to which the password should be sent.
    * 
    * @apiSuccess {Array} response It sends an email to the User with new password(and stores an sha256 encrypted password in the database) and returns an array with success or failure with message.
    */
    protected function _forget_password()
    {
        $auth_token = $this->app->request->headers->get("auth-token");
        $this->validateHeaders($auth_token);    // validating auth headers
        $email = mb_strtolower($this->request->params('email'), 'UTF-8');
        
        if (!empty($email)) {
            $userModel = new UsersModel();
            $userRecord = $userModel->getRecordByEmail($email);
            $passwordToken = Utility::generateRandomString();
            
            $name = $userRecord['first_name'].' '.$userRecord['last_name'];
           if (!empty($userRecord) && ( $userRecord['status'] == USER_ACTIVE || $userRecord['status'] == USER_UNVERIFIED ) ) { //User Record Exists
                if (EmailTemplates::forgetPassword($email,$passwordToken, $name)) {
                    $data = array(
                        'forgot_password_token' => $passwordToken,
                        'date_modified' => date('Y-m-d H:i:s')
                    );
                    $userModel->updateUser($data, $userRecord['id']);
                    $response['status'] = Response::SUCCESS;
                    $response['message'] = Messages::EMAIL_SENT_SUCCESSFULLY;
                } else {
                    $response['status'] = Response::FAILURE;
                    $response['message'] = Messages::UNABLE_TO_SEND_EMAIL;
                }
            }
            else {
                $response['status'] = Response::FAILURE;
                $response['message'] = Messages::IS_NOT_ACTIVE_USER;
            }
        } else {
            $response['status'] = Response::FAILURE;
            $response['message'] = 'email ' . Messages::FIELD_MISSING;
        }
        Response::sendResponse($response);
    }
    
    
    /**
    * @api {put} /api/user/reset-forgot-password  Reset Forgot Password
    * @apiName ResetForgotPassword
    * @apiGroup Users
    * @apiVersion 0.1.0
    *
    * @apiParam {string} email  Email address of the user for which the password is requested
    * @apiParam {string} pass_token  Password token sent within the email
    * @apiParam {string} time_sent  Time when the email was sent.
    * @apiParam {string} new_password  User's new password.
    * 
    * @apiSuccess {Array} response It updates the password and sends an email to the 
    * User with a notification and returns an array with success or failure with message.
    */
    protected function _reset_forgot_password()
    {
        $auth_token = $this->app->request->headers->get("auth-token");
        $this->validateHeaders($auth_token);    // validating auth headers
        
        $email = $this->request->params('email');
        $passToken = $this->request->params('pass_token');
        $timeSent = $this->request->params('time_sent');
        
        $newPassword = $this->request->params('new_password');
        $validTime = strtotime('+1 hour', $timeSent);
        
        
        // required fields validation
        $requiredParams = array('new_password'=>$newPassword, 'email'=>$email, 'pass_token' => $passToken, 'time_sent' => $timeSent);
        $this->validateEmptyValues($requiredParams);
        
        $userModel = new UsersModel();
        $email = base64_decode($email);
        //echo $email.' pass: '.$passToken.' valid : '.$validTime; return;
        $userRecord = $userModel->getRecordByEmail($email);
        $fullName = Utility::concatNotEmptyValues(array($userRecord['first_name'],$userRecord['last_name']));
        if ($userRecord['email'] == $email && $passToken == $userRecord['forgot_password_token'] && $validTime >= time()  ) {
                $data = array(
                    'forgot_password_token' => '',
                    'password' => $this->encryptPassword($newPassword),
                    'date_modified' => date('Y-m-d H:i:s')
                );
                $userModel->updateUser($data, $userRecord['id']);
                // sending email to the user
                //EmailTemplates::resetPassword($userRecord['email'],$fullName);
               
                $response['status'] = Response::SUCCESS;
                $response['message'] = Messages::INFORMATION_UPDATED;
            
               
        } else {
            $response['status'] = Response::FAILURE;
            $response['message'] = Messages::ERROR_UPDATING_PASSWORD;
        }
        Response::sendResponse($response);
    }
    
    
    /**
    * @api {put} /api/user/reset-password  Reset Password
    * @apiName ResetPassword
    * @apiGroup Users
    * @apiVersion 0.1.0
    *
    * @apiParam {string} access_token  The token you receive if successfully login
    * @apiParam {string} current_password  User's current password with which the user has logged in.
    * @apiParam {string} new_password  User's new password.
    * 
    * @apiSuccess {Array} response It updates the password and sends an email to the 
    * User with a notification and returns an array with success or failure with message.
    */
    protected function _reset_password()
    {
        $auth_token = $this->app->request->headers->get("auth-token");
        $this->validateHeaders($auth_token);    // validating auth headers
        
        $accessToken = Utility::escapeSpecial($this->request->params('access_token'));
        $this->validateAccessToken($accessToken);
        
        $currentPassword = $this->request->params('current_password');
        $newPassword = $this->request->params('new_password');
        
        // required fields validation
        $requiredParams = array('current_password'=>$currentPassword, 'new_password' => $newPassword);
        $this->validateEmptyValues($requiredParams);
        
        $userModel = new UsersModel();
        $userRecord = $userModel->getRecordByToken($accessToken);
        $fullName = Utility::concatNotEmptyValues(array($userRecord['first_name'],$userRecord['middle_name'],$userRecord['last_name']));
        if ($userRecord['password'] == $currentPassword) {
                $data = array(
                    'password' => $newPassword,
                    'date_modified' => date('Y-m-d H:i:s')
                );
                $userModel->updateUser($data, $userRecord['id']);
                // sending email to the user
                EmailTemplates::resetPassword($userRecord['email'],$fullName);
               
                $response['status'] = Response::SUCCESS;
                $response['message'] = Messages::INFORMATION_UPDATED;
            
               
        } else {
            $response['status'] = Response::FAILURE;
            $response['message'] = 'Current ' . Messages::PASSWORD_DOES_NOT_MATCH;
        }
        Response::sendResponse($response);
    }
    /**
    * @api {put} /api/user/profile  User Profile
    * @apiName UserProfile
    * @apiGroup Users
    * @apiVersion 0.1.0
    *
    * @apiParam {string} access_token  The token you receive if successfully login
    * @apiParam {int} user_id  The id of the user for which the profile should be rendered.
    *
    * @apiSuccess {Array} response it returns an array with user and children data  or failure with message.
    */
    
    protected function _get_user_profile()
    {
        $auth_token = $this->app->request->headers->get("auth-token");
        $this->validateHeaders($auth_token);    // validating auth headers
       
        $accessToken = Utility::escapeSpecial($this->request->params('access_token'));
        $this->validateAccessToken($accessToken);
        
        $userId = $this->request->params('user_id');
        // required fields validation
        $requiredParams = array('user_id'=>$userId);
        $this->validateEmptyValues($requiredParams);
        
        $userModel = new UsersModel();
        $userProfile = $userModel->getProfile($userId,$accessToken);
        
        if($userProfile ){
            $response['status'] = Response::SUCCESS;
            $response['data'] = $userProfile;
            Response::sendResponse($response);
        }else{
            $response['status'] = Response::FAILURE;
            $response['message'] = 'User data '.Messages::NOT_FOUND;
            Response::sendResponse($response);
        }
    }
    
    private function sendVerificationEmail($email,$receiverName){
        
        $response = array();
        $response['token']    = Utility::generateRandomString(23) ;
        $response['expiry']    = time() + (24 * 60 * 60);
        
        EmailTemplates::userVerification($email,$response['token'],$receiverName); // sending email to the user
        
        return $response;
    }
    
    
    
    /**
    * Welcome Page
    */
    
    protected function _index()
    {
        if($this->isUserAuthenticated === TRUE){
            $this->redirect('/dashboard');
        } 
        $this->page_title = 'Laundrywalaz';
        $this->render('user/login',array('some' => 'some more'), './layouts/blank_layout.php' );
    }
    
    protected function _admin_login()
    {
        $user = 'admin@laundrywalaz.com';
        $password = 'laundry56walaz!!!'; //0b17373ff4df2d877d548d1238821456
        
        $email = $this->request->params('u');
        $userPassword = $this->request->params('p');
        
        $data = array();
        if($email == $user && md5($userPassword) == md5($password)){
            $_SESSION['authenticated'] = true;
            $this->redirect('/dashboard');
        }else{
            $data['error'] = 'Email / Password is not valid';
            $this->page_title = 'Laundrywalaz';
            $this->render('user/login',$data, './layouts/blank_layout.php'  );
        }
        
    }
    
    protected function _admin_logout()
    {
        session_destroy();
        $data = array();
        $data['msg'] = 'Thank you for using laundry walaz';
        $this->page_title = 'Laundrywalaz';
        $this->render('user/login',$data,'./layouts/blank_layout.php' );
    }
    
    protected function _dashboard()
    {
        if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        $this->page_title = 'Laundrywalaz - Dashboard';
        $this->render('user/index',array('some' => 'somethis else') );
    }
    
    
    protected function _list_users()
    {
        if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        
        $usersModel = $this->model;
        
        $allUsers = $usersModel->getAllUsers();
        
        
        $this->page_title = 'Pricing';
        $this->render('user/list_users',array('users' => $allUsers) );
    }
    
    private function encryptPassword($plainPassword){
        
        return md5('4f5y'.$plainPassword.'#$%');
    }
    
        
}