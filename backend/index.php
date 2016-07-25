<?php

/**
 * myApp
 *
 * This class bootstrap your slim MVC project
 * 
 * @version 0.1
 * @author Muhammad Shahbaz <mohammadshahbax@gmail.com>
 */
class MyApp
{

    public static function __init()
    {

        
        // current dir 
        define("ROOT", __DIR__);

        // Load bootstrap
        require_once ROOT . "/app/config/bootstrap.php";

        AppBootstrap::init();
    }

}

session_cache_limiter(false);
session_start();
MyApp::__init();
