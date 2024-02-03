<?php
echo("post_incomming_items <br>");

require_once($_SERVER["DOCUMENT_ROOT"] . "/tem/file_paths.php");
require_once(FilePaths::server_root() . "/repositories/PlayerRepo.php");
// require_once(FilePaths::server_root() . "/data_models/Player.php");

$data = $_POST["data"];
$data_decoded = json_decode($data, true);

// echo("<pre>");
// print_r($_GET);
// print_r($_POST);
// print_r($data);
// print_r($data_decoded);
// echo("</pre>");

if ($data_decoded["passkey"] != "aaa") {
    die();
}


//$creditorItemPlayerTotalRepo = new CreditorItemPlayerTotalRepo();
$tradingItemRepo = new TradingItemRepo();
$playerRepo = new PlayerRepo();
$player = $playerRepo->get_where_playername_or_insert($data_decoded["playername"]);
echo("<pre>");
var_dump($player);
echo("</pre>");



/////! todo: oh cool, I just remembered that playernames can be changed
// todo implement a transaction code to validate receipts?
//$receipt = new Receipt($player->get_playername());


$inventory_raw = strval($data_decoded["inventory"]);
$tradingTransactionRepo = new \Trading\TradingTransactionRepo();
$tradingTransaction = new TradingTransaction($player, $inventory_raw);
$tradingTransactionRepo->store($tradingTransaction);

foreach ($data_decoded["inventory"] as $item) {
    // get the creditor_item id - or create new entry if it doesn't exist
    $trading_item = $tradingItemRepo->get_where_identifier_or_insert($item["identifier"]);

    // create tem_trading_transaction_entry
    $transactionEntry = new TradingTransactionEntry();
    
    // update or insert tem_creditor_item_player_total:
//    $creditorItemPlayerTotalRepo->insert_or_update($creditor_item->get_id(), $player->get_id(), $item["size"]);

    // but then also total stuff up and things for the receipt




    "INSERT INTO tem_creditor_item (identifier)
    VALUE ('hi')
    ON DUPLICATE KEY UPDATE identifier = identifier;"; // so like not this
    // update or insert tem_creditor_item_player_total:
    "INSERT INTO tem_creditor_item_player_total (player_id, creditor_item_id, creditor_item_total_count)
    VALUE (:player_id, :creditor_item_id, 4)
    ON DUPLICATE KEY UPDATE creditor_item_total_count = creditor_item_total_count + VALUE(creditor_item_total_count);";
}


?>
