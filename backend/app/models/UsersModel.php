<?php

/**
 * Contains the actions related to user
 * 
 * @author Muhammad Rashid <rashid.akram@putitout.co.uk>
 * @copyright (c) 2015, Putitout Solutions
 */
class UsersModel extends DbConnect
{

    protected $_table = 'users';
    

    public function __construct()
    {
        
    }
    /**
     * Saves user data
     * 
     * @param Array $data Data array to save
     * @return int/bool inserted id or false otherwise
     */
    public function saveUser($data)
    {
        return $this->save($this->_table, $data);
    }
 
    /**
     * Checks the email record if already registered
     * 
     * @param string $email
     * @return int/bool number of rows count or false if no record found
     */
    public function checkIfEmailExist($email)
    {
        return $this->countRows($this->_table, "email=:email", array(':email' => $email));
    }
    
    public function checkTokenWithEmail($email,$token)
    {
        return $this->getRow("SELECT * FROM $this->_table WHERE email=:email AND verification_token = :token ", array(':email' => $email, 'token' => $token));
    }

    /**
     * Returns the access token by authenticating user email and password
     * 
     * @param string $email email of the user
     * @param string $password password of the user
     * @return Array
     */
    public function loginAuthentication($email, $password)
    {
        $query = "SELECT first_name,last_name,status, type,date_modified,email,id  FROM $this->_table WHERE email = :email AND password = :password LIMIT 1";
        return $this->getRow($query, array(':email' => $email, ':password' => $password));
    }
    
    /**
     * Returns the access token by authenticating user social id and origin
     * 
     * @param string $socialId Social Id of the user
     * @param string $origin Registration origin of the user eg facebook
     * @return Array
     */
    public function loginSocialAuthentication($socialId, $origin)
    {
        $query = "SELECT id,first_name,last_name,middle_name,status,country,type,gender,date_modified,email,first_login  FROM $this->_table WHERE social_id = :social_id AND registration_origin = :origin LIMIT 1";
        return $this->getRow($query, array(':social_id' => $socialId, ':origin' => $origin));
    }

    /**
     * Generates the user unique token and saves into database
     * 
     * @param email $email email of the user
     * @return boolean/string false if token not generated, token string otherwise
     */
    public function generateAccessToken($email)
    {
        $utility = new Utility();
        $token = $utility->randomToken();
        
        if ($token) {
            $this->update($this->_table, array('access_token' => ':access_token'), "email = :email", array(':email' => $email, ':access_token' => $token));
        } else {
            return false;
        }
        
        return $token;
    }
    
    /**
     * Generates the user unique token and saves into database
     * 
     * @param email $socialId social id of the user
     * @param string $origin registration origin of the user
     * @return boolean/string false if token not generated, token string otherwise
     */
    public function generateAccessTokenForSocial($socialId, $origin)
    {
        $utility = new Utility();
        $token = $utility->randomToken();
        
        if ($token) {
            $this->update($this->_table, array('access_token' => ':access_token'), "social_id = :social_id AND registration_origin = :origin", array(':social_id' => $socialId, ':origin' => $origin, ':access_token' => $token));
        } else {
            return false;
        }
        
        return $token;
    }

    /**
     * Returns the user's record by access token
     * 
     * @param string $token system generated user's unique access token
     * @return Array
     */
    public function getRecordByToken($token)
    {
        $query = "SELECT first_name,last_name,address, locations_id, phone, status,date_modified,email,id FROM $this->_table WHERE access_token = :access_token LIMIT 1";
        $row = $this->getRow($query, array(':access_token' => $token));
        
        return $row;
    }
   
    /**
     * Returns the user's record by user id
     * 
     * @param string $recordId Id of the user
     * @return Array
     */
    public function getRecordById($recordId)
    {
        $query = "SELECT first_name,last_name,address, locations_id, phone, status,date_modified,email,id FROM $this->_table WHERE id = :record_id LIMIT 1";
        return $this->getRow($query, array(':record_id' => $recordId));
    }
    /**
     * Returns the user's record by Email
     * 
     * @param string $email user's unique Email
     * @return Array
     */
    public function getRecordByEmail($email)
    {
        $query = "SELECT id,email,forgot_password_token, first_name, last_name,address, locations_id, phone,  status,password FROM $this->_table WHERE email = :email LIMIT 1";
        return $this->getRow($query, array(':email' => $email));
    }
    public function updateUser($data, $id)
    {
        return $this->update($this->_table, $data, " id = :id", array(':id' => $id));
    }

    /**
     * Deletes the record of the user  from database by user id
     * 
     * @param int $id id of the user
     * @return bool successfull opertaion or failure
     */
    public function deleteRecordById($id)
    {
        return $this->runQuery("DELETE FROM $this->_table WHERE id = :id", array(':id' => $id));
    }
    public function fieldValidations($data,$scenario = 'create'){
        
        $required = array('email','phone','first_name','password');
        
        $validStatuses = SystemOptions::getUserStatuses();
        $validTypes = SystemOptions::getUserTypes();
        //$validOrigins = SystemOptions::getRegistrationOrigins();
        
        if($scenario == 'create'){
            foreach ($required as $key){
                if(!isset($data[$key])){
                   return $key.' '.Messages::IS_REQUIRED;
                }   
            }
        }
        // valid status
        if(isset($data['status']) && !array_key_exists($data['status'], $validStatuses)){
            $value = $data['status'];
            return 'Value['.$value.'] for status '.Messages::IS_NOT_VALID;
        }
        // valid type
        if(isset($data['type']) && !array_key_exists($data['type'], $validTypes)){
            $value = $data['type'];
            return 'Value['.$value.'] for type '.Messages::IS_NOT_VALID;
        }
       
        return TRUE;
    }
    
    public function getAllUsers()
    {
        
        //$response = array();
        $results = $this->getAll("SELECT t.* FROM $this->_table t  ORDER BY t.date_created ");
        
        
        return $results;
    }
    
    
    /**
     * Removes the access token of the user and sets to NULL
     * 
     * @param int $accessTokenId access token of the user
     * @return bool successfull opertaion or failure
     */
    public function removeAccessTokenById($id)
    {
        return $this->runQuery("UPDATE $this->_table SET access_token = NULL WHERE id = :id", array(':id' => $id));
    }

}
