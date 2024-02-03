<?php

class FilePaths {
    // Root paths
    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    public static function server_root() {
        return $_SERVER["DOCUMENT_ROOT"] . "/tem";
    }
    public static function web_root() {
        return "/tem";
    }

    // Paths for everywhere
    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    public static function main_css() {
        return self::web_root() . "/main_styles.css";
    }
    public static function global_JS_functions() {
        return self::web_root() . "/global_JS_functions.js";
    }
    public static function database_connection() {
        return self::server_root() . "/database_connection.php";
    }

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    // Core Directories
    public static function trading() {
        return self::server_root() . "/trading";
    }


    // Trading
}


?>