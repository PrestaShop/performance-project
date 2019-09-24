#!/bin/bash

if [ $PS_CANONICAL_REDIRECT_DISABLE = 1 ]
then
	echo ""
        echo " => Disabling URL redirects..."
        sed -i -e 's/OR su.domain_ssl =/OR su.domain LIKE "%" OR su.domain_ssl =/g' /var/www/html/classes/shop/Shop.php
        mysql -h $DB_SERVER -P $DB_PORT -b $DB_NAME -u $DB_USER -p$DB_PASSWD -e "UPDATE ps_configuration SET value = '0' WHERE name = 'PS_CANONICAL_REDIRECT';"
else
	echo ""
	echo " => Not set to disable URL stuff..."
fi
