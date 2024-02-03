<?php
require_once($_SERVER["DOCUMENT_ROOT"] . "/tem/file_paths.php");
require_once(FilePaths::database_connection());

class CreditorItemPlayerTotalRepo {
    private $db;

    function insert_or_update($creditor_item_id, $player_id, $amount) {
        $query = "INSERT INTO tem_creditor_item_player_total (player_id, creditor_item_id, creditor_item_total_count)
            VALUE (:player_id, :creditor_item_id, 4)
            ON DUPLICATE KEY UPDATE creditor_item_total_count = creditor_item_total_count + VALUE(creditor_item_total_count);";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
    }
}