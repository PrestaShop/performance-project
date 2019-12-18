<?php
$resultDir = 'results';

echo "Renaming result directory\n";

// rename result directory
$gatlingLog = file_get_contents(__DIR__ . DIRECTORY_SEPARATOR . 'results' . DIRECTORY_SEPARATOR . 'gatling.log');
preg_match('#results/(loadsimulation-(\d+))/index.html#', $gatlingLog, $matches);
if (!isset($matches[1]) || !isset($matches[2])) {
    echo "Issue while renaming gatling result directory";
    die;
}


$simulationName = getenv('SIMULATION_NAME')
    . '-' . getenv('USER_COUNT')
    . '-' . getenv('CUSTOMER_COUNT')
    . '-' . getenv('ADMIN_COUNT');
$dirOld = __DIR__ . DIRECTORY_SEPARATOR . $resultDir . DIRECTORY_SEPARATOR . $matches[1];
$dirNew = __DIR__ .
    DIRECTORY_SEPARATOR .
    $resultDir .
    DIRECTORY_SEPARATOR .
    $simulationName .
    '-' .
    $matches[2];
echo "New name:" . $simulationName . '-' . $matches[2] . "\n";
if (!is_dir($dirOld)) {
    echo "Result directory does not exist ! " . $dirOld;
    die;
}
if (is_dir($dirNew)) {
    echo "Result directory already exists ! " . $dirNew;
    die;
}

$dirNew = __DIR__ .
    DIRECTORY_SEPARATOR .
    $resultDir .
    DIRECTORY_SEPARATOR .
    $simulationName .
    '-' .
    $matches[2];
rename($dirOld, $dirNew);
