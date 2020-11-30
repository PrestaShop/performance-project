#!/bin/sh
set -e

if [ `docker images|grep alpinejq |wc -l` -eq "0" ]
then
	docker build -t alpinejq -f Dockerfile.jq .
fi

# INIT
if [ -z "$SIMULATION_NAME" ]
then
  export SIMULATION_NAME=""
fi

if [ -z "$USER_COUNT" ]
then
  export USER_COUNT=1
fi

if [ -z "$CUSTOMER_COUNT" ]
then
  export CUSTOMER_COUNT=1
fi

if [ -z "$ADMIN_COUNT" ]
then
  export ADMIN_COUNT=0
fi

if [ -z "$RAMP_DURATION" ]
then
  export RAMP_DURATION=10
fi

dir="$(cd "$(dirname "$0")"; pwd)"

# PRINT PARAMETERS

echo "Running gatling"
echo "NAME: $SIMULATION_NAME"
echo "URL: $SHOP_URL"
echo "USER_COUNT: $USER_COUNT"
echo "CUSTOMER_COUNT: $CUSTOMER_COUNT"
echo "ADMIN_COUNT: $ADMIN_COUNT"
echo "RAMP_DURATION: $RAMP_DURATION"

# RUN SIMULATION

export START="$(date +"%Y-%m-%d %T")"

docker run -it --rm \
    -v $dir/user-files:/opt/gatling/user-files \
    -v $dir/conf:/opt/gatling/conf \
    -v $dir/results:/opt/gatling/results \
    -e JAVA_OPTS="-DusersCount=$USER_COUNT
                  -DcustomersCount=$CUSTOMER_COUNT
                  -DadminsCount=$ADMIN_COUNT
                  -DrampDurationInSeconds=$RAMP_DURATION
                  -DhttpBaseUrlFO=$SHOP_URL
                  -DhttpBaseUrlBO=$ADMIN_URL
                  -DadminUser=demo@prestashop.com
                  -DadminPassword=prestashop" \
    denvazh/gatling:3.0.3 \
    -s LoadSimulation \
    2>&1 | tee $dir/results/gatling.log

# following can be used as option above to properly redirect local host
#--add-host=sandbox.prestashop.com:192.168.10.68 \
