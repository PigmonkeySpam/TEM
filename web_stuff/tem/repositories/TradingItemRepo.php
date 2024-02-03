<?php
require_once($_SERVER["DOCUMENT_ROOT"] . "/tem/file_paths.php");
require_once(FilePaths::database_connection());

class TradingItemRepo {
    private $db;

    function __construct() {
        $this->db = get_database_connection();
    }


    function get_where_identifier($identifier) {
        // todo optimise this or something: don't need to select all this stuff
        $query = "
            SELECT tti.id AS id, tti.identifier AS identifier, tti.pretty_name AS pretty_name, tti.test AS test, 
                   tticv.id AS trading_item_credit_value_id, tticv.credit_value AS credit_value, 
                   tticv.brownie_points_value AS brownie_points_value, tticv.start_time AS start_time,
                   tticv.end_time AS end_time, tticv.test AS trading_item_credit_value_test
            FROM tem_trading_item tti
            JOIN tem_trading_item_credit_value tticv ON tticv.trading_item_id = tti.id
            WHERE tti.identifier = :identifier
                AND (CURRENT_TIMESTAMP() BETWEEN tticv.start_time AND tticv.end_time
                    OR tticv.end_time IS NULL);
        ";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(":identifier", $identifier);
        $stmt->execute();
        $stmt->setFetchMode(PDO::FETCH_ASSOC);
        $result = $stmt->fetchAll();
        // todo remove
        echo("<pre>");
        echo("identifier=$identifier");
        echo("query=$query");
        print_r($result);
        echo("</pre>");

        if (count($result) == 0) {
            return false;
        }
        $result = $result[0];
        return new TradingItem(
            $result["id"], 
            $result["identifier"],
            $result["pretty_name"],
//            $result["trading_item_credit_value_id"],
            $result["credit_value"],
            $result["brownie_points_value"],
            $result["test"]
        );
    }

    function insert_using_identifier_only($identifier) {
        // todo: doing transactions at this level might be dumb actually...
        $this->db->beginTransaction();
        try {
            $query = "INSERT INTO tem_creditor_item(identifier) VALUE (:identifier);";
            $stmt = $this->db->prepare($query);
            $stmt->bindParam(":identifier", $identifier);
            $stmt->execute();

            $query = "INSERT INTO tem_trading_item_credit_value (trading_item_id, start_time) VALUE (:trading_item_id, DATE_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY));";
            $stmt = $this->db->prepare($query);
            $trading_item_id = $this->db->lastInsertId();
            $stmt->bindParam(":trading_item_id", $trading_item_id);
            $stmt->execute();
        }
        catch (Exception $e) {
            $this->db->rollback();
            return false;
        }
        $this->db->commit();
        return true;
    }

    function get_where_identifier_or_insert($identifier) {
        $keep_going = true;
        while ($keep_going) {
            $keep_going = false;
            $creditor_item = $this->get_where_identifier($identifier);
            if ($creditor_item == false) {
                $this->insert_using_identifier_only($identifier);
                $keep_going = true;
            }
            else {
                return $creditor_item;
            }
        }
    }
}

?>
