<?php

/**
 * Contains the all operations related to Devices of the registered users
 * 
 * @author Muhammad Shahbaz <mohammadshahbax@mail.com>
 * @copyright (c) 2015, Putitout Solutions
 */
class DevicesModel extends DbConnect
{

    protected $_table = 'devices';
    protected $_users = 'users';

    public function __construct()
    {
        
    }

    /**
     * saves the device data in database
     * 
     * @param Array $data data array to save in database
     * @return boolean
     */
    public function saveDevice($data)
    {
        if($this->getDeviceByUserId($data['user_id'])){
            return $this->updateDevice($data, $data['user_id']);
        }
        return $this->save($this->_table, $data);
    }
    /**
     * Update Device data
     * 
     * @param Array $data Data array to save
     * @param $userId Id of the event to be updated
     * @return int/bool inserted id or false otherwise
     */
    public function updateDevice($data, $userId)
    {
        return $this->update($this->_table, $data, " user_id = :id", array(':id' => $userId));
    }
    

    /**
     * Returns the device details by id of the user
     * 
     * @param int $userId id of the user
     * @return boolean
     */
    public function getDeviceByUserId($userId)
    {
        $query = "SELECT id, device_token FROM $this->_table
                    WHERE user_id = :user_id";
       return $this->getRow($query, array(':user_id' => $userId));
    }

    /**
     * Deletes the all devices from database by user id
     * 
     * @param int $userId id of the device
     * @return bool
     */
    public function deleteRecordById($userId,$deviceToken = FALSE)
    {
        $AND = " "; $params = array(':user_id' => $userId);
        if($deviceToken){
            $AND = " AND device_token = :device_token ";
            $params[':device_token'] = $deviceToken; 
        }
        $this->delete($this->_table, "user_id = :user_id".$AND, $params);
    }

}
