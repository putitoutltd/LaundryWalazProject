<?php

/**
 * Handles all requests related to reports and performs opertaions accordingly
 * 
 * @author Muhammad Rashid <rashid.akram@putitout.co.uk>
 * @copyright (c) 2016, Putitout Solutions
 */
class ReportController extends BaseController
{

    public function __construct($params, $action, $app)
    {
        $this->model = new ReportsModel();
        parent::__construct($params, $action, $app);
    }
    
    protected function _list_reports()
    {
        if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        
        $this->page_title = 'Reports Listing';
        $this->render('report/index' );
    }
    
    
    protected function _area_report()
    {
        if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        $params = $this->request->params();
        $yearMonth= ( isset($params['month']) && !empty($params['month']) ) ? $params['month'] : date('Y-m');
        
        $reportsModel = $this->model;
        $monthReport = $reportsModel->getMonthlyAreaSpecificReport($yearMonth);
        //echo 'ff: '.$yearMonth; print_r($monthReport); die();
        $this->page_title = 'Monthly Area Report';
        $data = array(
            'report' => $monthReport
        );
        $this->render('report/area_report' , $data);
    }
    
    protected function _sales_report()
    {
        if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        $params = $this->request->params();
        $yearMonth= ( isset($params['month']) && !empty($params['month']) ) ? $params['month'] : date('Y-m');
        
        $reportsModel = $this->model;
        $monthReport = $reportsModel->getMonthlySalesReport($yearMonth);
        //echo 'ff: '.$yearMonth; print_r($monthReport); die();
        $this->page_title = 'Monthly Sales Report';
        $data = array(
            'report' => $monthReport
        );
        $this->render('report/sales_report' , $data);
    }
    
    protected function _orders_report()
    {
        if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        $params = $this->request->params();
        $yearMonth= ( isset($params['month']) && !empty($params['month']) ) ? $params['month'] : date('Y-m');
        
        $reportsModel = $this->model;
        $monthReport = $reportsModel->getMonthlyOrdersReport($yearMonth);
        //echo 'ff: '.$yearMonth; print_r($monthReport); die();
        $this->page_title = 'Monthly Orders Report';
        $data = array(
            'report' => $monthReport
        );
        $this->render('report/orders_report' , $data);
    }
    
    protected function _selling_report()
    {
        if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        $params = $this->request->params();
        $yearMonth= ( isset($params['month']) && !empty($params['month']) ) ? $params['month'] : date('Y-m');
        
        $reportsModel = $this->model;
        $monthReport = $reportsModel->getMonthlyMostSellingReport($yearMonth);
        
        $this->page_title = 'Monthly Most Selling Report';
        $data = array(
            'report' => $monthReport
        );
        $this->render('report/selling_report' , $data);
    }
    
    protected function _customer_report()
    {
        if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        $params = $this->request->params();
        $yearMonth= ( isset($params['month']) && !empty($params['month']) ) ? $params['month'] : date('Y-m');
        
        $reportsModel = $this->model;
        $monthReport = $reportsModel->getMonthlyRepeatedCustomers($yearMonth);
        
        $this->page_title = 'Monthly Most Repeating Customers Report';
        $data = array(
            'report' => $monthReport
        );
        $this->render('report/customer_report' , $data);
    }
    
    
    protected function _users_report()
    {
        if($this->isUserAuthenticated !== TRUE){
            $this->redirect('/');
        } 
        $params = $this->request->params();
        $yearMonth= ( isset($params['month']) && !empty($params['month']) ) ? $params['month'] : date('Y-m');
        
        $reportsModel = $this->model;
        $monthReport = $reportsModel->getMonthlyUsersWithoutOrders($yearMonth);
        
        $this->page_title = 'Monthly Users without Orders Report';
        $data = array(
            'report' => $monthReport
        );
        $this->render('report/users_report' , $data);
    }
    
    
        
}