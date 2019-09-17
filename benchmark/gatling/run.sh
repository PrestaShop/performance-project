#!/bin/sh
set -e

dir="$(cd "$(dirname "$0")"; pwd)"

docker run -it --rm \
    -v $dir/results:/opt/gatling/results \
    -e JAVA_OPTS="-DusersCount=10
                  -DcustomersCount=2
                  -DadminsCount=2
                  -DrampDurationInSeconds=60
                  -DhttpBaseUrlFO=http://sandbox.prestashop.com:8080
                  -DhttpBaseUrlBO=http://sandbox.prestashop.com:8080/admin1234
                  -DadminUser=admin@prestashop.com
                  -DadminPassword=admin" \
    --add-host=sandbox.prestashop.com:192.168.0.4 \
    prestashop/performance-gatling \
    -s LoadSimulation

