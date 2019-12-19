<?php
$csvPath = __DIR__ . DIRECTORY_SEPARATOR . 'results' . DIRECTORY_SEPARATOR . 'results.csv';
$fileExists = file_exists($csvPath);
$fp = fopen($csvPath, 'a');

// prepare file headers if not exist
if (!$fileExists) {
    $csvInfos = [
        'simulation-name',
        'date',
        'orderPerHour',
        'pageViewPerHour',
    ];
    foreach (array_keys($resultData['result']) as $categoryName) {
        $csvInfos[] = $categoryName . '-responseTime95th';
    }
    fputcsv($fp, $csvInfos, ";");
}

// populate data
$csvInfos = [
    $simulationName,
    $resultData['start'],
    $resultData['orderPerHour'],
    $resultData['pageViewPerHour'],
];
foreach (array_keys($resultData['result']) as $categoryName) {
    $csvInfos[] = $resultData['result'][$categoryName]['responseTime95th'];
}
fputcsv($fp, $csvInfos, ";");

fclose($fp);
