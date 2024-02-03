<?php
require_once($_SERVER["DOCUMENT_ROOT"] . "/tem/file_paths.php");


function get_db_connection() {
    // DB login details - different if local or remote
    if ($_SERVER["SERVER_NAME"] != "localhost") {
        $servername = "localhost";
        $user = "jkeys2";
        $pass = "L8f9iY52";
        $database = "jkeys2";
    }
    else {
        $servername = "localhost";
        $user = "root";
        $pass = "";
        $database = "assdb";
        // $database = "monchtestthingdb";
    }
    
    try {
        $db = new PDO('mysql:host=localhost;dbname='.$database, $user, $pass, array(
            PDO::ATTR_PERSISTENT => true
        ));
        return $db;
    }
    catch(PDOException $e) {
        echo 'Message: ' . $e->getMessage();
        die;
    }




    // try {
    //     // https://www.w3schools.com/php/php_mysql_connect.asp
    //     // Create connection
    //     $conn = mysqli_connect($servername, $username, $password, $database);
    //     // Check connection
    //     if (!$conn) {
    //         die("Connection to database failed: " . mysqli_connect_error());
    //     }
    //     echo ('<script>console.log("Successfully connected to local database!");</script>');
    //     return $conn;
    // }
    // // catch exception for "Fatal error: Uncaught mysqli_sql_exception: No connection could be made because the target machine actively refused it in"
    // catch(Exception $e) {
    //     echo 'Message: ' . $e->getMessage();
    //     die;
    // }
}
?>