#!/bin/sh
set -e

if [ "$DB_SERVER" = "<to be defined>" -a $PS_INSTALL_AUTO = 1 ]; then
	echo >&2 'error: You requested automatic PrestaShop installation but MySQL server address is not provided '
	echo >&2 '  You need to specify DB_SERVER in order to proceed'
	exit 1
fi

if [ ! -f ./config/settings.inc.php  ]; then
	echo "\n* Reapplying PrestaShop files for enabled volumes ...";

	# init if empty
	cp -n -R -p /tmp/data-ps/prestashop/* /var/www/html

	cp -n -p /tmp/defines_custom.inc.php /var/www/html/config/defines_custom.inc.php

        if [ "${FIXTURE_FOLDER}" != "" ]
        then
                echo "\n* Pushing custom fixtures from ${FIXTURE_FOLDER}..."
                rm -rf /var/www/html/install/fixtures/fashion/
                mkdir -p  /var/www/html/install/fixtures/fashion/
                cp -R /opt/"${FIXTURE_FOLDER}"/* /var/www/html/install/fixtures/fashion/
                sed -i -e 's/dni=""/dni="11111111"/g' /var/www/html/install/fixtures/fashion/data/address.xml
        else
                echo "\n* No Fixture variable found..."
                echo ${FIXTURE_FOLDER}
        fi


	if [ $PS_FOLDER_INSTALL != "install" ]; then
		echo "\n* Renaming install folder as $PS_FOLDER_INSTALL ...";
		mv /var/www/html/install /var/www/html/$PS_FOLDER_INSTALL/
	fi

	if [ $PS_FOLDER_ADMIN != "admin" ]; then
		echo "\n* Renaming admin folder as $PS_FOLDER_ADMIN ...";
		mv /var/www/html/admin /var/www/html/$PS_FOLDER_ADMIN
	fi

	if [ $PS_HANDLE_DYNAMIC_DOMAIN = 1 ]; then
		cp /tmp/docker_updt_ps_domains.php /var/www/html
		sed -ie "s/DirectoryIndex\ index.php\ index.html/DirectoryIndex\ docker_updt_ps_domains.php\ index.php\ index.html/g" $APACHE_CONFDIR/conf-available/docker-php.conf
	fi

	if [ $PS_INSTALL_AUTO = 1 ]; then
		RET=1
		while [ $RET -ne 0 ]; do
		    echo "\n* Checking if $DB_SERVER is available..."
		    mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "status" > /dev/null 2>&1
		    RET=$?
		    if [ $RET -ne 0 ]; then
		        echo "\n* Waiting for confirmation of MySQL service startup";
		        sleep 5
		    fi
		done
		
		echo "\n* Installing PrestaShop, this may take a while ...";
		if [ $PS_ERASE_DB = 1 ]; then
			echo "\n* Drop & recreate mysql database...";
			if [ $DB_PASSWD = "" ]; then
				echo "\n* Dropping existing database $DB_NAME..."
		    		mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "drop database if exists $DB_NAME;"
				echo "\n* Creating database $DN_NAME..."
				mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER create $DB_NAME -p$DB_PASSWD --force;
			else
				echo "\n* Dropping existing database $DB_NAME..."
		    		mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "drop database if exists $DB_NAME;"
				echo "\n* Creating database $DN_NAME..."
				mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD create $DB_NAME --force;
			fi
		fi

		if [ "$PS_DOMAIN" = "<to be defined>" ]; then
			export PS_DOMAIN=$(hostname -i)
		fi

		echo "\n* Launching the installer script..."
		runuser -g www-data -u www-data -- php /var/www/html/$PS_FOLDER_INSTALL/index_cli.php \
		  --domain="$PS_DOMAIN" --db_server=$DB_SERVER:$DB_PORT --db_name="$DB_NAME" --db_user=$DB_USER \
			--db_password=$DB_PASSWD --prefix="$DB_PREFIX" --firstname="John" --lastname="Doe" \
			--password=$ADMIN_PASSWD --email="$ADMIN_MAIL" --language=$PS_LANGUAGE --country=$PS_COUNTRY \
			--all_languages=$PS_ALL_LANGUAGES --newsletter=0 --send_email=0 --ssl=$PS_ENABLE_SSL

		if [ $? -ne 0 ]; then
			echo 'warning: PrestaShop installation failed.'
		fi
	fi
else
    echo "\n* Pretashop Core already installed...";
fi


if [ $PS_CANONICAL_REDIRECT_DISABLE = 1 ]
then
	echo "\n* Disabling URL redirect"
	sed -i -e 's/OR su.domain_ssl =/OR su.domain LIKE "%" OR su.domain_ssl =/g' /var/www/html/classes/shop/Shop.php
	mysql -h $DB_SERVER -P $DB_PORT -b $DB_NAME -u $DB_USER -p$DB_PASSWD -e "UPDATE ps_configuration SET value = '0' WHERE name = 'PS_CANONICAL_REDIRECT';"
fi

echo "\n* Almost ! Starting web server now\n";

echo "Starting web server..."
# here we run cache warmup into parallel processes with apache one, keeping it running in foreground
sleep 5 && echo "Warming up FO cache...\n" && wget -t 5 http://localhost/index.php? && echo "FO cache warming done\n" &
sleep 6 && echo "Warming up BO cache...\n" && wget -t 5 http://localhost/${PS_FOLDER_ADMIN}/index.php?controller=AdminLogin && echo "BO cache warming done\n" &

# run apache foreground
_TOKEN_=disabled exec apache2-foreground
