<?php
// this script is used to update csv content in case of changes in process scripts

$path = __DIR__ . DIRECTORY_SEPARATOR . 'results' . DIRECTORY_SEPARATOR . 'results.csv';
if (file_exists($path)) {
    echo "Deleting results.csv\n";
    unlink($path);
}
foreach (['results'] as $dirToScan) {
    $files = scandir($dirToScan);
    foreach ($files as $dir) {
        $path = $dirToScan . '/' . $dir . '/result.json';
        if (file_exists($path)) {
            $resultData = json_decode(file_get_contents($path), true);
            $simulationName = $resultData['simulation name'];
            include('process-populate-csv.php');
        }
    }
}
