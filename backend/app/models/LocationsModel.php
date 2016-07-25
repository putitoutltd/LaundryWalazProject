<?php

/**
 * Contains the actions related to locations
 * 
 * @author Muhammad Rashid <rashid.akram@putitout.co.uk>
 * @copyright (c) 2016, Putitout Solutions
 */
class LocationsModel extends DbConnect
{

    protected $_table = 'locations';
    protected $_cities = 'cities';
    

    public function __construct()
    {
        
    }
    
    public function getAllLocations($onlyIds = FALSE)
    {
        $response = array();
        $SELECT = ($onlyIds === TRUE) ? ' t.id ' : ' t.*,c.name as city '; 
        $results = $this->getAll("SELECT $SELECT FROM $this->_table t "
                . "INNER JOIN $this->_cities c on c.id = t.cities_id ");
        
        if($onlyIds){
            foreach ($results as $row){
                $response[] = $row['id'];
            }
        }
        else{
            $response = $results;
        }
        return $response;
    }


}
