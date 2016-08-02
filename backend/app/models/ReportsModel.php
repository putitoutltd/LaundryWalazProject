<?php

/**
 * Contains the actions related to user
 * 
 * @author Muhammad Rashid <rashid.akram@putitout.co.uk>
 * @copyright (c) 2016, Putitout Solutions
 */
class ReportsModel extends DbConnect
{

    protected $_orders = 'orders';
    protected $_locations = 'locations';
    protected $_order_items = 'order_items';
    protected $_service_items = 'service_items';
    protected $_users = 'users';


    public function __construct()
    {
        
    }
    
    public function getMonthlyAreaSpecificReport($yearMonth){
        
        $monthStart = $yearMonth.'-01';
        $monthEnd = $yearMonth.'-31';
        $query = "SELECT l.name, count(o.id) as orders FROM $this->_orders o
                                    INNER JOIN $this->_locations l on l.id = o.locations_id
                                    WHERE o.date_created >= :start 
                                    AND  o.date_created <= :end 
                                    GROUP BY o.locations_id";
        
        
        
        $results = $this->getAll($query, array(':start' => $monthStart, ':end' => $monthEnd));
        return $results;
        
    }
    
    public function getMonthlySalesReport($yearMonth){
        
        $monthStart = $yearMonth.'-01';
        $monthEnd = $yearMonth.'-31';
        $query = "SELECT si.name, si.price_dryclean, si.price_laundry, oi.quantity, si.price_dryclean * oi.quantity as total_dryclean, si.price_laundry * oi.quantity as total_laundry "
                . "FROM $this->_order_items oi
                    INNER JOIN $this->_service_items si on oi.service_items_id = si.id
                    INNER JOIN $this->_orders o on o.id = oi.orders_id    
                    WHERE o.date_created >= :start 
                    AND  o.date_created <= :end ";
        
        
        
        $results = $this->getAll($query, array(':start' => $monthStart, ':end' => $monthEnd));
        return $results;
        
    }
    
    public function getMonthlyOrdersReport($yearMonth){
        
        $monthStart = $yearMonth.'-01';
        $monthEnd = $yearMonth.'-31';
        $query = "SELECT o.status, count(o.status) as no_of_status FROM $this->_orders o
                                    WHERE o.date_created >= :start 
                                    AND  o.date_created <= :end 
                                    GROUP BY o.status";
        
        $results = $this->getAll($query, array(':start' => $monthStart, ':end' => $monthEnd));
        return $results;
        
    }
    
    public function getMonthlyMostSellingReport($yearMonth){
        
        $monthStart = $yearMonth.'-01';
        $monthEnd = $yearMonth.'-31';
        $query = "SELECT si.name, SUM(oi.quantity) as total_sales "
                . "FROM $this->_order_items oi
                    INNER JOIN $this->_service_items si on oi.service_items_id = si.id
                    INNER JOIN $this->_orders o on o.id = oi.orders_id    
                    WHERE o.date_created >= :start 
                    AND  o.date_created <= :end 
                    GROUP BY name ORDER BY total_sales DESC";
        
        $results = $this->getAll($query, array(':start' => $monthStart, ':end' => $monthEnd));
        return $results;
        
    }

    
    public function getMonthlyRepeatedCustomers($yearMonth){
        
        $monthStart = $yearMonth.'-01';
        $monthEnd = $yearMonth.'-31';
        $query = "SELECT u.id as uid, u.first_name,u.last_name, COUNT(o.id) as total_orders "
                . "FROM $this->_users u
                    INNER JOIN $this->_orders o on o.users_id = u.id    
                    WHERE o.date_created >= :start 
                    AND  o.date_created <= :end 
                    GROUP BY uid ORDER BY total_orders DESC";
        
        $results = $this->getAll($query, array(':start' => $monthStart, ':end' => $monthEnd));
        return $results;
        
    }

    public function getMonthlyUsersWithoutOrders($yearMonth){
        
        $monthStart = $yearMonth.'-01';
        $monthEnd = $yearMonth.'-31';
        $query = "SELECT u.id as uid, u.first_name,u.last_name,u.date_created, COUNT(o.id) as total_orders "
                . "FROM $this->_users u
                    LEFT JOIN $this->_orders o on o.users_id = u.id    
                    WHERE u.date_created >= :start 
                    AND  u.date_created <= :end 
                    GROUP BY uid HAVING total_orders = 0";
        
        $results = $this->getAll($query, array(':start' => $monthStart, ':end' => $monthEnd));
        return $results;
        
    }

}
