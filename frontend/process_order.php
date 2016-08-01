<?php 
    include_once('settings.php');

    $action = filter_input(INPUT_POST, 'action');
    $email = filter_input(INPUT_POST, 'email');
    $accessToken = filter_input(INPUT_POST, 'ac');
    $phone = filter_input(INPUT_POST, 'phone');
    $password = filter_input(INPUT_POST, 'password');
    $first_name = filter_input(INPUT_POST, 'first_name');
    $last_name = filter_input(INPUT_POST, 'last_name');
    $locations_id = filter_input(INPUT_POST, 'locations_id');
    $address = filter_input(INPUT_POST, 'address');
    $user_id = filter_input(INPUT_POST, 'user_id');
    $pickup_time = filter_input(INPUT_POST, 'pickup_time');
    $dropoff_time = filter_input(INPUT_POST, 'dropoff_time');
    $special_instructions = filter_input(INPUT_POST, 'special_instructions');
    
    
// update user information
$endPoint2 = 'api/order/create';
$createOrder =  array(
    'email' => $email,
    'phone' => $phone,
    'first_name' => $first_name,
    'last_name' => $last_name,
    'location_id' => $locations_id,
    'address' => $address,
    'password' => $password,
    'access_token' => $accessToken,
    'pickup_time' => date('Y-m-d H:i:s',  strtotime($pickup_time)),
    'dropoff_time' => date('Y-m-d H:i:s',  strtotime($dropoff_time)),
    'special_instructions' => $special_instructions
       
);

if($action == 'create_order'){ 
    
    echo sendRequest($endPoint2, $createOrder);
    
    return;
}




if($action == 'verify_identity'){ 
    // checking if user token is valid
    $endPoint3 = 'api/user/is_logged_in';
    $loggedInData = array(
        'access_token' => $accessToken
    );
    
    echo sendRequest($endPoint3, $loggedInData, 'PUT');
    
    return;
}


if($action == 'sync_order'){ 
    // checking if user token is valid
    $endPoint = 'api/order/status';
    $data = array(
        'access_token' => $accessToken
    );
    
    echo sendRequest($endPoint, $data, 'POST');
    
    return;
}


if($action == 'forgot_password'){ 
    // checking if user token is valid
    $endPoint = 'api/user/forget-password';
    $data = array(
        'email' => $email
    );
    
    echo sendRequest($endPoint, $data, 'POST');
    
    return;
}


if($action == 'create_user'){ 
    
    // register a new user
    $endPoint1 = 'api/user/register';
    $registerUser =  array(
       // 'username' => '',
        'email' => $email,
        'password' => $password,
        'first_name' => $first_name,
        'phone' => $phone,
        'last_name' => $last_name,
       
    );
    
    echo sendRequest($endPoint1, $registerUser);
    
    return;
}



// CALLS
//sendRequest($endPoint1, $registerUser);


function sendRequest($endPoint, $data , $method = 'POST' ){
        $host = BACKEND_URL;
        $url = $host.$endPoint;
        //echo $url;
        //print_r($data);
        $ch = curl_init();                    // initiate curl
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); // return the output in string format
        curl_setopt($ch, CURLOPT_POST, true);  // tell curl you want to post something
        //if($putRequest){
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
        //}
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data)); // define what you want to post
        
        
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                'auth-token: {sPjadfadf@4hyBASYdfsLdWJFz2juAdAOI(MkjAnRhsTVC>Wih))J9WT(kr'
            ));
        
        //curl_setopt($ch, CURLOPT_HEADER, true);
        $output = curl_exec($ch); // execute
        curl_close($ch); // close curl handle
        //var_dump($output);
        //return json_decode($output);
        return $output;
       
}

