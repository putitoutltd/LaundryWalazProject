<?php

//user Routes
Router\Helper::map('user', array(
    '/api/user/register' => array('post' => 'register_user'),
    '/api/user/verify-token' => array('put' => 'verify_registration_token'),
    '/api/user/login' => array('post' => 'user_login'),
    '/api/user/update' => array('put' => 'update_user'),
    '/api/user/logout' => array('put' => 'user_logout'),
    '/api/user/forget-password' => array('post' => 'forget_password'),
    '/api/user/reset-forgot-password' => array('post' => 'reset_forgot_password'),
    '/api/user/device' => array('post' => 'register_device_token'),
    '/api/user/device/remove' => array('put' => 'remove_device_token'),
    '/api/user/getuser' => array('put' => 'get_user_by_token'),
    '/api/user/is_logged_in' => array('put' => 'is_logged_in'),
    '/api/user/send_area_request' => array('get' => 'send_area_request'),
    '/api/user/send_feedback' => array('get' => 'send_feedback'),
    '/' => array('get' => 'index'),
    '/admin/login' => array('post' => 'admin_login'),
    '/admin/logout' => array('get' => 'admin_logout'),
    '/dashboard' => array('get' => 'dashboard'),
    '/users' => array('get' => 'list_users'),
    
));
Router\Helper::map('service', array(
    '/api/services/list' => array('get' => 'get_all_services'),
    '/api/services/operating_areas' => array('get' => 'get_all_operating_areas'),
    '/services/update' => array('any' => 'edit_service'),
    '/pricing' => array('get' => 'list_prices'),
    
));

Router\Helper::map('order', array(
    '/api/order/create' => array('post' => 'create_order'),
    '/api/order/status' => array('post' => 'get_order_status'),
    '/orders' => array('get' => 'list_orders'),
    '/orders/edit' => array('get' => 'edit_order'),
    '/orders/items/add' => array('get' => 'add_items'),
    '/orders/items/additem' => array('post' => 'add_items'),
    '/orders/status/update' => array('post' => 'update_order_status'),
    '/orders/delete' => array('post' => 'delete_order'),
    
));

Router\Helper::map('report', array(
    '/reports' => array('get' => 'list_reports'),
    '/reports/area_report' => array('get' => 'area_report'),
    '/reports/sales_report' => array('get' => 'sales_report'),
    '/reports/orders_report' => array('get' => 'orders_report'),
    '/reports/selling_report' => array('get' => 'selling_report'),
    '/reports/customer_report' => array('get' => 'customer_report'),
    '/reports/users_report' => array('get' => 'users_report'),
    
));

Router\Helper::map('cron', array(
    '/cron/broadcast_push_notifications/?' => array('get' => 'broadcast_push_notifications'),
    '/cron/vaccination/activity/?' => array('get' => 'generate_vaccination_activity'),
));

