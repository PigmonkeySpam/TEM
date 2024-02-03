<?php
session_start();

$mobName = $_GET["mobName"];


function writeJson($data) {
    $file = fopen("node_on_states.json", "w");
    fwrite($file, json_encode($data));
    fclose($file);
}


$mobStatesData = json_decode(file_get_contents("node_on_states.json"), true);
$i = 0;
foreach($mobStatesData as $mobState) {
    if ($mobState["mobName"] == $mobName) {
        // echo("mobState['turnOffTime'] = ".$mobState['turnOffTime']."\n");
        // echo("time = ".time()."\n");
        if ($mobState["turnOffTime"] < time()) {
            echo("0");
        } else {
            echo("1");
        }
        header("HTTP/1.1 200 OK!");
        die;
    }
    $i += 1;
}
header("HTTP/1.1 400 mobName not found in list");
?>