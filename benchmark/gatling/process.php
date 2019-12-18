<?php

// RENAME GATLING RESULT DIRECTORY

echo "Renaming result directory\n";

include('process-rename-directory.php');

// PROCESS RESULTS

echo "Processing result\n";

$resultData = [
    'start'           => getenv('START'),
    'end'             => getenv('END'),
    'USER_COUNT'      => getenv('USER_COUNT'),
    'CUSTOMER_COUNT'  => getenv('CUSTOMER_COUNT'),
    'ADMIN_COUNT'     => getenv('ADMIN_COUNT'),
    'RAMP_DURATION'   => getenv('RAMP_DURATION'),
    'simulation name' => $simulationName,
    'conversionRate'  => round(getenv('CUSTOMER_COUNT') / (getenv('USER_COUNT') + getenv('CUSTOMER_COUNT')), 1),
    'orderPerHour'    => round(3600 * getenv('CUSTOMER_COUNT') / getenv('RAMP_DURATION')),
];

$jsonContent = file_get_contents($dirNew . DIRECTORY_SEPARATOR . 'js' . DIRECTORY_SEPARATOR . 'stats.json');
$json = json_decode($jsonContent, true);

include('process-extract-results.php');

$dataContent = json_encode($resultData, JSON_PRETTY_PRINT);
echo $dataContent . "\n";
file_put_contents($dirNew . DIRECTORY_SEPARATOR . 'result.json', $dataContent);

// POPULATE CSV FILE

echo "Populating csv comparison file\n";

include('process-populate-csv.php');
