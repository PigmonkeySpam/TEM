<?php


class CreditorItemPlayerTotal {
    private $player_id;
    private $creditor_item_id;
    private $creditor_item_total_count;
    private $last_updated;
    private $test;

    function __construct() {
        // return $this;
    }

    // getters & setters
    function get_player_id() {
        return $this->player_id;
    }
    function set_player_id($player_id) {
        $this->player_id = $player_id;
        return $this;
    }
    
    function get_creditor_item_id() {
        return $this->creditor_item_id;
    }
    function set_creditor_item_id($creditor_item_id) {
        $this->creditor_item_id = $creditor_item_id;
        return $this;
    }

    function get_creditor_item_total_count() {
        return $this->creditor_item_total_count;
    }
    function set_creditor_item_total_count($creditor_item_total_count) {
        $this->creditor_item_total_count = $creditor_item_total_count;
        return $this;
    }

    function get_last_updated() {
        return $this->last_updated;
    }
    function set_last_updated($last_updated) {
        $this->last_updated = $last_updated;
        return $this;
    }

    function get_test() {
        return $this->test;
    }
    function set_test($test) {
        $this->test = $test;
        return $this;
    }
}