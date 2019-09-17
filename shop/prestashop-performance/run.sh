#!/bin/bash
# use it if you want to customize prestashop run
set -e

echo "Starting web server..."
# here we run cache warmup into parallel processes with apache one, keeping it running in foreground
echo "Warming up FO cache...\n" && sleep 5 && wget -t 5 http://localhost/index.php? && echo "FO cache warming done\n" &
echo "Warming up BO cache...\n" && wget -t 5 http://localhost/${PS_FOLDER_ADMIN}/index.php?controller=AdminLogin && echo "BO cache warming done\n" &

# run apache foreground
_TOKEN_=disabled exec /tmp/docker_run.sh
