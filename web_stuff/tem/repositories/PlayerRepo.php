<?php
require_once($_SERVER["DOCUMENT_ROOT"] . "/tem/file_paths.php");
require_once(FilePaths::database_connection());

require_once(FilePaths::server_root() . "/data_models/Player.php");

class PlayerRepo {
    private $db;

    public function __construct() {
        $this->db = get_db_connection();
    }

    public function get_where_playername_or_insert($playername) {
        $keep_going = true;
        while ($keep_going) {
            $keep_going = false;
            $player = $this->get_where_playername($playername);
            if ($player == false) {
                $this->insert_using_name_only($playername);
                $keep_going = true;
            } 
            else {
                return $player;
            }
            // todo if max retries
        }
    }

    public function get_where_playername($name) {
        $query = "SELECT * FROM tem_player WHERE playername = :playername;";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(":playername", $name);
        $stmt->execute();
        $stmt->setFetchMode(PDO::FETCH_ASSOC);
        $result = $stmt->fetchAll();
        echo("<pre>");
        echo("name=$name");
        echo("query=$query");
        print_r($result);
        echo("</pre>");

        if (count($result) == 0) {
            return false;
        }
        $result = $result[0];
        return new Player(
            $result["id"], 
            $result["playername"],
            $result["credit_balance"],
            $result["brownie_point_balance"],
            $result["test"]
        );
    }

    public function insert_using_name_only($playername) {
        $query = "INSERT INTO tem_player(playername) VALUE (:playername);";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(":playername", $playername);
        $stmt->execute();
    }
}

?>