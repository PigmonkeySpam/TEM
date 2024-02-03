<?php
require_once($_SERVER["DOCUMENT_ROOT"] . "/tem/file_paths.php");

class CreditorItem {
    private $id;
    private $identifier;
    private $pretty_name;
    private $credit_value;
    private $test;


    function __construct($id, $identifier, $pretty_name, $test) {
        $this->set_id($id);
        $this->set_identifier($identifier);
        $this->set_pretty_name($pretty_name);
        $this->set_credit_value($credit_value)
        $this->set_test($test);
        // return $this;
    }


    // getters & setters
    function get_id() {
        return $this->id;
    }
    function set_id($id) {
        $this->id = $id;
    }

    function get_identifier() {
        return $this->identifier;
    }
    function set_identifier($identifier) {
        $this->identifier = $identifier;
    }

    function get_pretty_name() {
        return $this->pretty_name;
    }
    function set_pretty_name($pretty_name) {
        $this->pretty_name = $pretty_name;
    }

    function get_credit_value() {
        return $this->credit_value;
    }
    function set_credit_value($credit_value) {
        $this->credit_value = $credit_value;
    }

    function get_test() {
        return $this->test;
    }
    function set_test($test) {
        $this->test = $test;
    }
}