#!/bin/bash
set -e

dir="$(cd "$(dirname "$0")"; pwd)"

STACK="stack1"
MAIN_SHOP_URL="http://shop2.$STACK.prestashop.net"
BASE_COUNT="20"
CUSTOMER_COUNT="0"
ADMIN_COUNT="0"
STEP_COUNT="0"
RAMP_DURATION="30"
NB_STEPS="2"
START="0"
###

until [ $START -gt $NB_STEPS ]
do
	NEW_COUNT=$(($BASE_COUNT+$STEP_COUNT))
	START=$(($START+1))
	BASE_COUNT=$NEW_COUNT

	export SIMULATION_NAME="$STACK-shop2-$NEW_COUNT-cust-count-$CUSTOMER_COUNT"
	export USER_COUNT=$NEW_COUNT
	export CUSTOMER_COUNT="$CUSTOMER_COUNT"
	export ADMIN_COUNT="$ADMIN_COUNT"
	export RAMP_DURATION="$RAMP_DURATION"
	export SHOP_URL="$MAIN_SHOP_URL"
	export ADMIN_URL="$SHOP_URL/ps-admin"

	### Launching the first run
	./run.sh

	echo ""
	echo "Performance test ended, waiting for cool down before next run..."
	sleep 10

	export END="$(date +"%Y-%m-%d %T")"

	docker run -it --rm \
	    -v "$dir":/app \
	    -e SIMULATION_NAME \
	    -e SHOP_URL \
	    -e USER_COUNT \
	    -e CUSTOMER_COUNT \
	    -e ADMIN_COUNT \
	    -e RAMP_DURATION \
	    -e START \
	    -e END \
	    alpinejq /bin/bash /app/process.sh

	sleep 180

	./run.sh

	echo ""
	echo "Performance test ended, waiting for cool down before next run..."
	sleep 10

	export END="$(date +"%Y-%m-%d %T")"

	docker run -it --rm \
	    -v "$dir":/app \
	    -e SIMULATION_NAME \
	    -e SHOP_URL \
	    -e USER_COUNT \
	    -e CUSTOMER_COUNT \
	    -e ADMIN_COUNT \
	    -e RAMP_DURATION \
	    -e START \
	    -e END \
	    alpinejq /bin/bash /app/process.sh

	sleep 180
done
