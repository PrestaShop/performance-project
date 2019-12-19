<?php

/** pageview count on one scenario of visitor browsing */
const PAGEVIEWS_CRAWL = 15;

/** pageview count on one scenario of order placing */
const PAGEVIEWS_CART = 8;

// RENAME GATLING RESULT DIRECTORY

echo "Renaming result directory\n";

include('process-rename-directory.php');

// PROCESS RESULTS

echo "Processing result\n";

$customerCount = getenv('CUSTOMER_COUNT');
$userCount = getenv('USER_COUNT');
$rampDuration = getenv('RAMP_DURATION');
$resultData = [
    'start'           => getenv('START'),
    'end'             => getenv('END'),
    'USER_COUNT'      => $userCount,
    'CUSTOMER_COUNT'  => $customerCount,
    'ADMIN_COUNT'     => getenv('ADMIN_COUNT'),
    'RAMP_DURATION'   => $rampDuration,
    'simulation name' => $simulationName,
    'conversionRate'  => round($customerCount / ($userCount + $customerCount), 1),
    'orderPerHour'    => round(3600 * $customerCount / $rampDuration),
    'pageViewPerHour' => round(3600 * (PAGEVIEWS_CRAWL * $userCount + PAGEVIEWS_CART * $customerCount) / $rampDuration),
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
