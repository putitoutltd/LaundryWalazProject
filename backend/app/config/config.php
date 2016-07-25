<?php

class AppConfig
{

    /**
     * Default Framework(Slim) Configs
     * @access protected
     * @var array
     */
    protected static $defaultConfig = array(
        "templates.path" => VIEWS_FOLDER,
        "layout.file" => "./layouts/layout.php"
    );

    /**
     * Get configuration
     * 
     * Set app configurations and return array of configurations
     * @return array Web App configs
     */
    public static function get()
    {
        self::showAllErrors();
        self::defineConstants();
        self::loadFiles();
        return self::$defaultConfig;
    }

    /**
     * Returns the application environment
     * 
     * @return string environment string
     */
    public static function detectEnvironment()
    {
        return (getenv('APPLICATION_ENV')) ? getenv('APPLICATION_ENV') : 'production';
    }

    /**
     * Set PHP directives to notify of all errors
     *
     * */
    public static function showAllErrors()
    {
        if (self::detectEnvironment() !== 'production') {
            error_reporting(E_ALL);
            ini_set('display_errors', '1');
        }
    }

    /**
     * Load Files
     * 
     * Loads all base files
     */
    public static function loadFiles()
    {
        $autoload = array(
            CONTROLLERS_FOLDER . "/base_controller.php",
            VENDOR_FOLDER . '/autoload.php',
                //LIB_FOLDER			 		. "/routes_helper.php"	 , 
        );
        foreach ($autoload as $file) {
            require_once($file);
        }
        //Models path for PHP Autoloader
        set_include_path(implode(PATH_SEPARATOR, array(
            realpath(MODELS_FOLDER),
            realpath(LIB_FOLDER),
            get_include_path(),
        )));

        spl_autoload_register(function ($class) {
            include str_replace('\\', '/', $class) . '.php';
        });
    }

    /**
     * Define app top level constants
     *
     * */
    public static function defineConstants()
    {
        define("APP_FOLDER", ROOT . "/app");
        define("VIEWS_FOLDER", APP_FOLDER . "/views/");
        define("MODELS_FOLDER", APP_FOLDER . "/models/");
        define("MAILS_FOLDER", APP_FOLDER . "/mailers/");
        define("CONTROLLERS_FOLDER", APP_FOLDER . "/controllers/");
        define("CONFIG_FOLDER", APP_FOLDER . "/config/");
        define("PRESENTERS_FOLDER", APP_FOLDER . "/presenters/");
        define("VENDOR_FOLDER", ROOT . "/vendor/");
        define("LIB_FOLDER", ROOT . "/libs/");
        
    }

}
