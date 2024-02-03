<?php

class FilePaths {
    // Root paths
    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    public static $server_root = $_SERVER["DOCUMENT_ROOT"] . "/tem";
    public static $web_root = "/tem";

    // Paths for everywhere
    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    public static $main_css = self::$web_root . "/main_styles.css";
    public static $global_JS_functions = self::$web_root . "/global_JS_functions.js";
    public static $database_connection = self::$server_root . "/database_connection.php";

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    // Core Directories
    public static $trading = self::$server_root . "/trading";


    // Trading
}


?>