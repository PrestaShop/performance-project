#!/bin/bash
###
### Default CRAWL_PAGEVIEW
crawlPageView="15"
### Default CART_PAGEVIEW
cartPageView="8"

### Retrieving simulation directory..."
cd /app/results
simulationDir=`ls -t */ |head -n 1|cut -d':' -f1`
### Last simulation directory: $simulationDir"

### Renaming simulation directory...
simulationDate=`date +\%Y\%m\%d\%H\%M\%S`
newDir="$SIMULATION_NAME-usercount-$USER_COUNT-custcount-$CUSTOMER_COUNT-admincount-$ADMIN_COUNT-rampduration-$RAMP_DURATION-$simulationDate"

if [ $simulationDir != $newDir ]
then
	mv $simulationDir $newDir
fi

## Retrieving global 95th percentiles response time
respTime=`cat $newDir/js/stats.json | jq -r -c [.stats.percentiles3.total]|cut -d'[' -f2|cut -d']' -f1`

orderPerHour=$((3600 * $CUSTOMER_COUNT / $RAMP_DURATION))
pageViewPerHour=$(($((3600 * (($cartPageView * $CUSTOMER_COUNT + crawlPageView * $USER_COUNT)) / $RAMP_DURATION))))

if [ ! -f newresults.csv ]
then
	echo "simulation-name;date;orderPerHour;pageViewPerHour;crawlRespTime;cartRespTime;globalRespTime" > newresults.csv
fi

echo "$SIMULATION_NAME;$simulationDate;$orderPerHour;$pageViewPerHour;$respTime" >> newresults.csv
