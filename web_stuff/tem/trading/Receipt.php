<?php
// todo include stuff




// ! should this stuff just be the transaction_log db table stuff (todo) <-- just so I find it when I Ctrl + f
class Receipt {
    private $playername; //todo change this to Player object
    private $transaction_code;
    private $valued_items;
    private $unvalued_items;
    private $total_credits;
    private $total_brownie_points;

    function __construct($playername) {
        $this->set_playername = $playername;
        $this->set_total_credits = 0; // todo not set or add the setter ...but there is no point in a private setter really?
        $this->total_brownie_points = 0;
    }

    public function add_creditor_item($creditor_item) {
        if (gettype($creditor_item->get_credit_value) == "integer") {
            $valued_items.array_push($creditor_item);
            $total_credits = $total_credits + $creditor_item->get_credit_value();
        }
        else { // no credit_value: give brownie points instead
            $unvalued_items.array_push($creditor_item);
            $total_brownie_points = $total_brownie_points + 1;
        }
    }
}