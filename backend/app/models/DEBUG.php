<?php

/**
 * @author Muhammad Shahbaz <mohammadshahbax@mail.com>
 * @copyright (c) 2015, Putitout Solutions
 */
class DEBUG
{

    public function __construct()
    {
        
    }

    /**
     * prints the detail information about array or variable for debugging perpose.
     * 
     * @param string/int/Array $var
     * @param bool $exit
     */
    public static function dump($var, $exit = true)
    {
        echo "<div style='background-color: CC6600; font-weight: bold;'> <pre>";

        if (is_array($var) || is_object($var)) {
            echo htmlentities(print_r($var, true));
        } elseif (is_string($var)) {
            echo "string(" . strlen($var) . ") \"" . htmlentities($var) . "\"\n";
        } else {
            var_dump($var);
        }
        echo "</pre> </div>";

        if ($exit) {
            exit;
        }
    }

}
