<?php
require_once($_SERVER["DOCUMENT_ROOT"] . "/tem/file_paths.php");


class Player {
    // properties
    private $id;
    private $playername;
    private $credit_balance;
    private $brownie_point_balance;
    private $test;


    function __construct($id, $playername, $credit_balance, $brownie_point_balance, $test) {
        $this->set_id($id);
        $this->set_playername($playername);
        $this->set_credit_balance($credit_balance);
        $this->set_brownie_point_balance($brownie_point_balance);
        $this->set_test($test);
    }
    
    
    // getters & setters
    function get_id() {
        return $this->$id;
    }
    function set_id($id) {
        $this->id = $id;
    }
    
    function get_playername() {
        return $this->playername;
    }
    function set_playername($playername) {
        $this->playername = $playername;
    }

    function get_credit_balance() {
        return $this->credit_balance;
    }
    function set_credit_balance($credit_balance) {
        if (gettype($credit_balance) == "integer") {
            $this->credit_balance = $credit_balance;
            return true;
        // } elseif (gettype($credit_balance) == "NULL") {
        //     echo("credit_balance should not be null ...or just comment this line out"); die();
        //     $this->credit_balance = 0;
        } else {
            return false;
        }
    }
    
    function get_brownie_point_balance() {
        return $this->brownie_point_balance;
    }
    function set_brownie_point_balance($brownie_point_balance) {
        if (gettype($brownie_point_balance) == "integer") {
            $this->brownie_point_balance = $brownie_point_balance;
            return true;
        // } elseif (gettype($brownie_point_balance) == "NULL") {
        //     $this->brownie_point_balance = 0;
        } else {
            return false;
        }
    }

    function get_test() {
        return $this->test;
    }
    function set_test($test) {
        $this->test = $test;
    }


    // function to_string() {
    //     return "
    //     Player {
    //         id=$this->id,
    //         name=$this->name
    //     }
    //     ";
    // }
}
?>
