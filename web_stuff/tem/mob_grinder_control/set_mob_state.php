<?php
session_start();
$secret = $_POST["secret"];
if ($secret != "a") {
    header("HTTP/1.1 403");
    die(403);
}

if (empty($_POST["mobName"])) {
    $mobName = $_GET["mobName"];
} else {
    $mobName = $_POST["mobName"];
}


function writeJson($data) {
    $file = fopen("node_on_states.json", "w");
    fwrite($file, json_encode($data));
    fclose($file);
}


$mobStatesData = json_decode(file_get_contents("node_on_states.json"), true);
echo("<pre>");
print_r($mobStatesData);
echo("</pre>");
$i = 0;
foreach($mobStatesData as $mobState) {
    if ($mobState["mobName"] == $mobName) {
        if (!$mobState["automaticControl"]) { die; }
        $mobStatesData[$i]["turnOffTime"] = time() + 60;
        writeJson($mobStatesData);
        header("HTTP/1.1 200 OK!");
        die;
    }
    $i += 1;
}
header("HTTP/1.1 400 mobName not found in list");
?>