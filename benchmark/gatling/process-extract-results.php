<?php

$results = [];
foreach ($json['contents'] as $data) {
    $name = $data['name'];
    $stats = $data['stats'];
    $nameParts = explode(' ', $name);
    $category = array_shift($nameParts);
    // min response time
    $minResponseTime = $stats['minResponseTime']['total'];
    // 95th percentile
    $responseTime95th = $stats['percentiles3']['total'];
    // failed requests
    $failed = $stats['group4']['count'];
    if (empty($results[$category])) {
        $results[$category] = [
            'minResponseTime' => 0,
            'responseTime95th' => 0,
            'failed'           => 0,
        ];
    }
    // populate results
    if ($minResponseTime !=0) {
        // avoid null values due to errors
        if ($results[$category]['minResponseTime'] ==0) {
            $results[$category]['minResponseTime'] = $minResponseTime;
        } else {
            $results[$category]['minResponseTime'] = min($results[$category]['minResponseTime'], $minResponseTime);
        }
    }
    $results[$category]['responseTime95th'] = max($results[$category]['responseTime95th'], $responseTime95th);
    $results[$category]['failed'] += $failed;
}
$resultData['result'] = $results;
