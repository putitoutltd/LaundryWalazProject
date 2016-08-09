<?php


/**
 * Contains the all data sets allowed for system
 * 
 * @author Muhammad Rashid <rashid.akram@putitout.co.uk>
 * @copyright (c) 2015, Putitout Solutions
 */
class SystemOptions
{

    public function __construct()
    {
        
    }

    /**
     * Returns possible status values
     * 
     * @return Array Response containing valid values for User Statuses
     */
    public static function getUserStatuses()
    {
        return array(
            '1' => 'Active',
            '2' => 'Inactive',
            '3' => 'Unverified'
            
        );
    }
    
    /**
    * Returns possible user Types
    * 
    * @return Array Response containing valid values for User Types
    */
    public static function getUserTypes()
    {
        return array(
            '1' => 'Admin',
            '2' => 'Normal',
            '3' => 'Operator'
        );
    }
    
    
    /**
    * Returns possible order statuses
    * 
    * @return Array Response containing valid values for Order statuses
    */
    public static function getOrderStatuses()
    {
        return array(
            '0' => 'Awaiting Pick Up',
            '1' => 'Going in Laundry',
            '2' => 'Cleaning Your Laundry',
            '3' => 'Clean Laundry on your way',
            '4' => 'Delivered',
            '5' => 'Canceled'
        );
    }
    
    /**
    * Returns possible Origin Types
    * 
    * @return Array Response containing valid origins
    */
    public static function getRegistrationOrigins()
    {
        return array(
            'standard',
            'facebook',
            'google'
        );
    }
    
    
}
