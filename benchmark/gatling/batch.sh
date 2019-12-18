#!/bin/sh
set -e

dir="$(cd "$(dirname "$0")"; pwd)"

###

export SIMULATION_NAME="stack2-shop2-4vcpu-4vcpudb"
export USER_COUNT=300
export CUSTOMER_COUNT=12
export ADMIN_COUNT=0
export RAMP_DURATION=900
export SHOP_URL="http://shop2.stack2.prestashop.net"
export ADMIN_URL="$SHOP_URL/ps-admin"
$dir/run.sh

echo "end of simulation, waiting cool down before next"
sleep 5

###

echo "end of simulations"
