#!/bin/bash

	echo ""
        echo " => Launching FO & BO warmups..."
        # here we run cache warmup into parallel processes with apache one, keeping it running in foreground
        sleep 5 && echo "Warming up FO cache..." && echo "" && curl -I -H"Host: $PS_DOMAIN" --retry 5 http://localhost/index.php? && echo "FO cache warming done" &
        #sleep 6 && echo "Warming up BO cache...\n" && wget -t 5 http://localhost/${PS_FOLDER_ADMIN}/index.php?controller=AdminLogin && echo "BO cache warming done\n" &
        sleep 6 && echo "Warming up BO cache..." && echo "" && curl -I -H"Host: $PS_DOMAIN" --retry 5 http://localhost/${PS_FOLDER_ADMIN}/index.php?controller=AdminLogin && echo "BO cache warming done" &

