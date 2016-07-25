<?php

/**
 * Contains the actions related to orders
 * 
 * @author Muhammad Rashid <rashid.akram@putitout.co.uk>
 * @copyright (c) 2016, Putitout Solutions
 */
class OrdersModel extends DbConnect
{

    protected $_table = 'orders';
    protected $_items = 'order_items';
    protected $_users = 'users';
    protected $_locations = 'locations';
    protected $_service_categories = 'service_categories';
    protected $_service_items = 'service_items';





    public function __construct()
    {
        
    }
    
    /**
     * Saves order data
     * 
     * @param Array $data Data array to save
     * @return int/bool inserted id or false otherwise
     */
    public function saveOrder($data)
    {
        //$orderData = $data['order'];
        $orderId = $this->save($this->_table, $data);
        
        /*
        if($orderId){
            //saving order items
            $orderItems = $data['items'];
            foreach ($orderItems as $item){
                $this->saveOrderItem($item);
            }
        }*/
        return $orderId;
    }
    
    public function updateOrder($data, $id)
    {
        return $this->update($this->_table, $data, " id = :id", array(':id' => $id));
    }
    
    /**
     * Saves order items data
     * 
     * @param Array $data Data array to save
     * @return int/bool inserted id or false otherwise
     */
    public function saveOrderItem($data)
    {
        return $this->save($this->_items, $data);
    }
    
    /**
     * Deletes the items of the order by order id
     * 
     * @param int $orderId id of the order
     * @return bool successfull opertaion or failure
     */
    public function deleteItemsByOrderId($orderId)
    {
        return $this->runQuery("DELETE FROM $this->_items WHERE orders_id = :order_id", array(':order_id' => $orderId));
    }
  
    public function getAllOrders()
    {
        
        $response = array();
        $results = $this->getAll("SELECT t.*,u.first_name, u.last_name FROM $this->_table t "
                . "INNER JOIN $this->_users u on u.id = t.users_id ORDER BY t.id DESC ");
        
        
        return $results;
    }
    
    public function deleteOrder($orderId)
    {
        $results = $this->runQuery("DELETE FROM $this->_table WHERE id = :id", array(':id' => $orderId));
        $this->runQuery("DELETE FROM $this->_items WHERE orders_id = :id", array(':id' => $orderId));
        
        return $results;
    }
    
    
    
    public function getOrderById($orderId)
    {
        $order = $this->getRow("SELECT u.first_name, u.last_name,l.name as location, o.* FROM $this->_table o
                                    INNER JOIN $this->_users u on u.id = o.users_id
                                    INNER JOIN $this->_locations l on l.id = o.locations_id
                                    WHERE o.id = :order_id ", array(':order_id' => $orderId));
        
        $orderItems = $this->getAll("SELECT i.*,si.*,sc.name as category FROM $this->_items i
                                    INNER JOIN $this->_service_items si on si.id = i.service_items_id
                                    INNER JOIN $this->_service_categories sc on sc.id = si.service_categories_id
                                    WHERE i.orders_id = :order_id ", array(':order_id' => $orderId));

        
        return $response = array(
            'order' => $order,
            'orderItems' => $orderItems
        );
    }
    
    public function getLastOrderByUserId($userId)
    {
        return $this->getRow("SELECT u.first_name, u.last_name,l.name as location, o.* FROM $this->_table o
                                    INNER JOIN $this->_users u on u.id = o.users_id
                                    INNER JOIN $this->_locations l on l.id = o.locations_id
                                    WHERE u.id = :user_id ORDER BY o.id DESC LIMIT 1", array(':user_id' => $userId));
        
    }

}
