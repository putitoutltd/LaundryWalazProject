<?php

/**
 * Contains the actions related to service items
 * 
 * @author Muhammad Rashid <rashid.akram@putitout.co.uk>
 * @copyright (c) 2016, Putitout Solutions
 */
class ServiceItemsModel extends DbConnect
{

    protected $_table = 'service_items';
    protected $_categories = 'service_categories';
    
    

    public function __construct()
    {
        
    }
    
    public function getAllServices()
    {
        
        $response = array();
        $results = $this->getAll("SELECT t.*,c.name as category FROM $this->_table t "
                . "INNER JOIN $this->_categories c on c.id = t.service_categories_id ");
        
        foreach ($results as $row){
            if(isset($response[$row['category']])){
                $response[$row['category']][] = $row;
            }else{
                $response[$row['category']] = array();
                $response[$row['category']][] = $row;
            }
        }
        return $response;
    }
    
    public function getServiceItemById($itemId)
    {
        $result = $this->getRow("SELECT t.* FROM $this->_table t
                                    WHERE t.id = :item_id ", array(':item_id' => $itemId));
       return $result;
    }   


}
